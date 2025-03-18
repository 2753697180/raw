#include <unistd.h>
#include <stdlib.h>
#include <stdio.h>
#include <string.h>
#include <sys/shm.h>
#include "app.h"
int main()
{  
    int running = 1;   
    void *shm = NULL;  
    struct shared_use_st *shared = NULL;
    char buffer[BUFSIZ + 1];//用于保存输入的文本
    int shmid;  //创建共享内存
    shmid = shmget((key_t)1234, sizeof(struct shared_use_st), 0666|IPC_CREAT);
    if(shmid == -1)
    {  
        fprintf(stderr, "shmget failed\n");
        exit(EXIT_FAILURE);
    }   //将共享内存连接到当前进程的地址空间
    shm = shmat(shmid, (void*)0, 0);   
    if(shm == (void*)-1)
    {  
        fprintf(stderr, "shmat failed\n");     
        exit(EXIT_FAILURE);
    }  
    printf("Memory attached at %p\n", shm);    //设置共享内存   
    shared = (struct shared_use_st*)shm;   
    shared->read1 = 0;
    shared->read2=0;    
    shared->written1 = 1;
    shared->written2=0;
    while(running)//向共享内存中写数据  
    {       //数据还没有被读取，则等待数据被读取,不能向共享内存中写入文本       
        if((shared->written2 != 0)&&(shared->written1==0))
        {  
            printf("This is app2 :Enter some text: ");       
            fgets(buffer, BUFSIZ, stdin);   
            strncpy(shared->text, buffer, TEXT_SZ);      //写完数据，设置written使共享内存段可读
            shared->written2 = 0;
            shared->read1 = 1;
            shared->read2 = 0;     
            shared->written1 = 0;    
        }
       else if((shared->read2 !=0)&& (shared->read1==0))   //输入了end，退出循环（程序） 
        { printf("the app1 wrote: %s", shared->text);      
            sleep(rand() % 3);
            shared->read1 = 0;          
            shared->written1=0 ;
            shared->read2=0;
            shared->written2=1;      //读取完数据，设置written使共享内存段可写
            if(strncmp(shared->text, "end", 3) == 0)    //输入了end，退出循环（程序）  
            running = 0;       
        }
        else     
        {   printf("Waiting  the app1 \n");
              sleep(2);  
            
        }      
    }   //把共享内存从当前进程中分离
    if(shmdt(shm) == -1)   
    {      
        fprintf(stderr, "shmdt failed\n");     
        exit(EXIT_FAILURE);
    }  
    sleep(2);  
    exit(EXIT_SUCCESS);
}