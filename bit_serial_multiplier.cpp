#include"bit_serial_multiplier.h"

data_t bit_serial_multiplier(hls::stream<bit> &A,hls::stream<bit> &B,int Aw,int Bw){
	int maxW=(Aw>Bw)?Aw:Bw;
	bit signA;
	bit signB;
	ap_int<32> Acur=0;
	ap_int<32> Bcur=0;
	ap_int<32> singleWeight=1;
	ap_int<32> doubleWeight=1;
	bit bitA;
	bit bitB;
	bit bitAnd;
	ap_int<32> psum1;
	ap_int<32> psum2;
	ap_int<32> psum3;
	ap_int<32> psum=0;
	for(int bitcount=0;bitcount<maxW;bitcount++){
#pragma HLS PIPELINE
		//相当于有符号扩展
		if(bitcount<=Aw-1)
			A>>bitA;
		//相当于有符号扩展
		if(bitcount<=Bw-1)
			B>>bitB;
		bitAnd=bitA&bitB;
//		cout<<"bitA="<<bitA<<",bitB="<<bitB<<endl;
//		cout<<"bitcount="<<bitcount<<"tow weights="<<singleWeight<<","<<doubleWeight<<endl;
//		cout<<"bitAnd="<<bitAnd<<endl;
		//符号位
		signA=(bitcount==maxW-1)?bitA:(bit)0;
		signB=(bitcount==maxW-1)?bitB:(bit)0;
		//psum1=bitA*bitB*signA*signB*weightA*weightB       weightA=weightB=2^bitcount
		if(signA^signB==(bit)1)
			if(bitAnd==(bit)1)
				psum1=-doubleWeight;
			else
				psum1=(ap_int<32>)0;
		else
			if(bitAnd==(bit)1)
				psum1=doubleWeight;
			else
			    psum1=(ap_int<32>)0;
		//psum2=signA*weightA*bitA*Bcur
		if(signA==(bit)1)
			if(bitA==(bit)1)
				psum2=-Bcur;
			else
				psum2=0;
		else
			if(bitA==(bit)1)
				psum2=Bcur;
			else
				psum2=0;
		//psum3=signB*weightB*bitB*Acur
		if(signB==(bit)1)
			if(bitB==(bit)1)
				psum3=-Acur;
			else
				psum3=0;
		else
			if(bitB==(bit)1)
			    psum3=Acur;
			else
				psum3=0;
		//Acur,Bcur
		if(bitA==(bit)1)
			Acur|=((ap_int<32>)doubleWeight);
		if(bitB==(bit)1)
			Bcur|=((ap_int<32>)doubleWeight);
		singleWeight=singleWeight<<1;
		doubleWeight=doubleWeight<<2;
		Acur=Acur<<1;
		Bcur=Bcur<<1;
		//psum
		psum+=(psum1+psum2+psum3);
	}
	return psum;
}

void InnerProductUnit(int Aw,int Bw,ap_int<16> A[VEC_LEN],ap_int<16> B[VEC_LEN],ap_int<16> O[VEC_LEN]){
#pragma HLS ARRAY_PARTITION variable=O complete dim=1
#pragma HLS ARRAY_PARTITION variable=B complete dim=1
#pragma HLS ARRAY_PARTITION variable=A complete dim=1
	hls::stream<bit> As[VEC_LEN];
#pragma HLS ARRAY_PARTITION variable=As complete dim=1
#pragma HLS STREAM variable=As depth=16 dim=1
	hls::stream<bit> Bs[VEC_LEN];
#pragma HLS STREAM variable=Bs depth=16 dim=1
#pragma HLS ARRAY_PARTITION variable=Bs complete dim=1
	for(int i=0;i<Aw;i++){
#pragma HLS PIPELINE II=1
		for(int j=0;j<VEC_LEN;j++)
			As[j]<<A[j](i,i);
	}
	for(int i=0;i<Bw;i++){
#pragma HLS PIPELINE II=1
		for(int j=0;j<VEC_LEN;j++)
			Bs[j]<<B[j](i,i);
	}
	for(int i=0;i<VEC_LEN;i++){
#pragma HLS UNROLL
		O[i]=bit_serial_multiplier(As[i],Bs[i],Aw,Bw);
	}
}
