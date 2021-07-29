#include"bit_serial_multiplier.h"

data_t bit_serial_multiplier(hls::stream<bit> &A,hls::stream<bit> &B,int Aw,int Bw){
	int maxW=(Aw>Bw)?Aw:Bw;
	bit signA;
	bit signB;
	ap_int<32> Acur=0;
	ap_int<32> Bcur=0;
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
		if(bitcount>Aw-1)
			bitA=Acur(Aw-1,Aw-1);
		else
			A>>bitA;
		//相当于有符号扩展
		if(bitcount>Bw-1)
			bitB=Bcur(Bw-1,Bw-1);
		else
			B>>bitB;
		bitAnd=bitA&bitB;
//		cout<<"bitA="<<bitA<<",bitB="<<bitB<<endl;
//		cout<<"bitAnd="<<bitAnd<<endl;
		//符号位
		signA=(bitcount==maxW-1)?bitA:(bit)0;
		signB=(bitcount==maxW-1)?bitB:(bit)0;
		//psum1=bitA*bitB*signA*signB*weightA*weightB       weightA=weightB=2^bitcount
		if(signA^signB==(bit)1)
			psum1=-(ap_int<32>)bitAnd<<(bitcount<<1);
		else
			psum1=(ap_int<32>)bitAnd<<(bitcount<<1);
		//psum2=signA*weightA*bitA*Bcur
		if(signA==(bit)1)
			if(bitA==(bit)1)
				psum2=-Bcur<<bitcount;
			else
				psum2=0;
		else
			if(bitA==(bit)1)
				psum2=Bcur<<bitcount;
			else
				psum2=0;
		//psum3=signB*weightB*bitB*Acur
		if(signB==(bit)1)
			if(bitB==(bit)1)
				psum3=-Acur<<bitcount;
			else
				psum3=0;
		else
			if(bitB==(bit)1)
			    psum3=Acur<<bitcount;
			else
				psum3=0;
		//Acur,Bcur
		Acur(bitcount,bitcount)=bitA;
		Bcur(bitcount,bitcount)=bitB;
		//psum
		psum+=(psum1+psum2+psum3);
	}
	return psum;
}
