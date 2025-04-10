#include "shm.h"
#include <vector>
void writedata(const std::vector<double> &buffer)
{
    int running = 1;   
    void *shm = NULL;  
    class  shared_use_st *shared = NULL;
    int shmid;  //创建共享内存
    shmid = shmget((key_t)1234, sizeof(class shared_use_st), 0666|IPC_CREAT);
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
    shared = (class shared_use_st*)shm;   
    shared->read1 = 0;
    shared->read2=0;    
    shared->written1 = 0;
    shared->written2=1;
    while(running)//向共享内存中写数据  
    {       //数据还没有被读取，则等待数据被读取,不能向共享内存中写入文本       
        if((shared->written2 != 0)&&(shared->written1==0))
        {  
            shared->size = buffer.size();  
            // 写入数据  
            printf("Data written to shared memory:\n");  
            for (size_t i = 0; i < shared->size; ++i)  
            {  
                shared->data[i] = buffer[i];
                printf("%f ", shared->data[i]);  
            }  
            printf("\n"); 
            shared->written2 = 0;
            shared->read1 = 1;
            shared->read2 = 0;     
            shared->written1 = 0;    
            running = 0;
        }
        else  
        {  
            printf("Waiting for shared memory to be available...\n");  
            sleep(1); // 等待 1 秒  
        }  
    
    }  
    if (shmdt(shm) == -1)  
    {  
        fprintf(stderr, "shmdt failed\n");  
        exit(EXIT_FAILURE);  
    }  

    // 删除共享内存  
 if (shmctl(shmid, IPC_RMID, 0) == -1)  
    {  
        fprintf(stderr, "shmctl failed\n");  
        exit(EXIT_FAILURE);  
    }  
}
    
