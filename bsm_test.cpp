#include"bit_serial_multiplier.h"
#include<iostream>
#include<stdlib.h>
using namespace std;

int main(){
	ap_int<16> A[VEC_LEN];
	ap_int<16> B[VEC_LEN];
	ap_int<16> O[VEC_LEN];
	int Aw=8;                 //-32->31
	int Bw=4;                 //-16->15
	for(int i=0;i<VEC_LEN;i++)
	{
		A[i]=rand()%256-128;
		B[i]=rand()%16-8;
		O[i]=0;
	}
	InnerProductUnit(Aw,Bw,A,B,O);
	for(int i=0;i<VEC_LEN;i++)
		cout<<A[i]<<","<<B[i]<<","<<A[i]*B[i]<<","<<O[i]<<endl;
//	for(int i=0;i<1000;i++){
//		int Aw=8;
//		int Bw=10;
//		ap_int<32> A=rand()%256-128;
//		ap_int<32> B=rand()%1024-512;
//
//		hls::stream<ap_uint<1>> As;
//		hls::stream<ap_uint<1>> Bs;
//		for(int i=0;i<Aw;i++)
//			As<<A(i,i);
//		for(int i=0;i<Bw;i++)
//			Bs<<B(i,i);
//		ap_int<32> res=bit_serial_multiplier(As,Bs,Aw,Bw);
//		cout<<"A="<<A<<"    B="<<B<<"    A*B="<<A*B<<"    OUT="<<res<<endl;
//		if(A*B!=res)
//			return -1;
//	}
	return 0;
}
