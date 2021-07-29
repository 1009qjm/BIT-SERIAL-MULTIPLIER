#include<hls_stream.h>
#include<ap_int.h>
#include<iostream>
using namespace std;

typedef ap_uint<1> bit;
typedef ap_int<32> data_t;
data_t bit_serial_multiplier(hls::stream<bit> &A,hls::stream<bit> &B,int Aw,int Bw);
