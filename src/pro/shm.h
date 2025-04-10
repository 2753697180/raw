#ifndef _SHMDATA_H_HEADER
#define _SHMDATA_H_HEADER
#define TEXT_SZ 2048
#include <unistd.h>
#include <stdlib.h>
#include <stdio.h>
#include <string.h>
#include <sys/shm.h>
#include <vector>
#include <iostream>
class shared_use_st
{  
public:
    int written1;
    int written2;
    int read1;
    int read2;//作为一个标志，非0：表示可读，0表示可写 
    double data[TEXT_SZ];//记录写入和读取的文本
    int size ;
};
void writedata(const std::vector<double> &buffer);
#endif

