#include <unistd.h>
#include <stdlib.h>
#include <stdio.h>
#include <sys/shm.h>
#include "app.h"
#include <string.h>
int main()
{  
    int running = 1;//程序是否继续运行的标志  
    void *shm = NULL;//分配的共享内存的原始首地址   
    struct shared_use_st *shared;//指向shm   
    int shmid;//共享内存标识符 //创建共享内存   
    char buffer[BUFSIZ + 1];
    shmid = shmget((key_t)1234, sizeof(struct shared_use_st), 0666|IPC_CREAT);
    if(shmid == -1)
    {      
        fprintf(stderr, "shmget failed\n");
        exit(EXIT_FAILURE);
    }   //将共享内存连接到当前进程的地址空间
    shm = shmat(shmid, 0, 0);
    if(shm == (void*)-1)   
    {  
        fprintf(stderr, "shmat failed\n"); 
        exit(EXIT_FAILURE);
    }  
    printf("\nMemory attached at %p\n", shm);  // 使用 %p 打印指针 //设置共享内存   
    shared = (struct shared_use_st*)shm; 
    shared->read1 = 0;
    shared->read2=0;    
    shared->written1 = 1;
    shared->written2=0;
    while(running)//读取共享内存中的数据 
    {       //没有进程向共享内存定数据有数据可读取       
        if((shared->written1 != 0)&&(shared->written2==0))
        {  
            printf("This is app1 :Enter some text: ");       
            fgets(buffer, BUFSIZ, stdin);   
            strncpy(shared->text, buffer, TEXT_SZ);      //写完数据，设置written使共享内存段可读
            shared->written1 = 0;
            shared->read1 = 0;
            shared->read2 = 1;     
            shared->written2 = 0;    
        }
        else if((shared->read1 !=0)&& (shared->read2==0))   //输入了end，退出循环（程序） 
        { printf("the app2 wrote: %s", shared->text);      
            sleep(rand() % 3);
            shared->read1 = 0;          
            shared->written1 = 1;
            shared->read2=0;
            shared->written2=0;      //读取完数据，设置written使共享内存段可写
            if(strncmp(shared->text, "end", 3) == 0)    //输入了end，退出循环（程序）  
            running = 0;       
        }  
        else     
        {   printf("Waiting the app2\n");
              sleep(2);  
        }   
    
    }   //把共享内存从当前进程中分离
    if(shmdt(shm) == -1)   
    {      
        fprintf(stderr, "shmdt failed\n");     
        exit(EXIT_FAILURE);
    }   //删除共享内存   
    if(shmctl(shmid, IPC_RMID, 0) == -1)   
    {  
        fprintf(stderr, "shmctl(IPC_RMID) failed\n");  
        exit(EXIT_FAILURE);
    }  
    exit(EXIT_SUCCESS);
}