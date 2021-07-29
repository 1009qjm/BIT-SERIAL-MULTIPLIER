#include"bit_serial_multiplier.h"
#include<iostream>
#include<stdlib.h>
using namespace std;

int main(){
	for(int i=0;i<1000;i++){
		int Aw=10;
		int Bw=18;
		ap_int<32> A=rand()%1024-512;
		ap_int<32> B=rand()%256-128;

		hls::stream<ap_uint<1>> As;
		hls::stream<ap_uint<1>> Bs;
		for(int i=0;i<Aw;i++)
			As<<A(i,i);
		for(int i=0;i<Bw;i++)
			Bs<<B(i,i);
		ap_int<32> res=bit_serial_multiplier(As,Bs,Aw,Bw);
		cout<<"A="<<A<<"    B="<<B<<"    A*B="<<A*B<<"    OUT="<<res<<endl;
		if(A*B!=res)
			return -1;
	}
	return 0;
}
