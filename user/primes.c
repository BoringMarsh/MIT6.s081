#define LIMIT 35
#include"user.h"

//递归计算过程：子进程视角（设有父、子、孙进程），传进了父->子的管道
void cascade_calc(int *ptoc)
{
    close(ptoc[1]);  //子进程不需要写，直接关闭

    int prime;
    if (read(ptoc[0], &prime, sizeof(prime)) == 0) {  //若读不出数据，则读取完毕，关闭管道后结束进程
        close(ptoc[0]);
        exit(0);
    }

    printf("prime %d\n", prime);  //经过筛选，读出的第一个数一定为素数
    int ctogc[2];  //子进程到孙进程的管道

    if (pipe(ctogc) < 0) {
        printf("message #prime: failed to create pipe\n");
        exit(1);
    }

    int pid = fork();

    if (pid < 0) {
        printf("message #prime: failed to fork\n");
        exit(2);
    }

    if (pid == 0) {
        cascade_calc(ctogc);  //进行递归计算
    }
    else {
        close(ctogc[0]);  //对孙进程时，子进程不需要读，直接关闭
        int num;

        while (read(ptoc[0], &num, sizeof(num)) > 0) {  //继续读取父进程传来的数据，只有在读出的数无法整除prime才传给孙进程
            if (num % prime != 0)
                write(ctogc[1], &num, sizeof(num));
        }

        close(ctogc[1]);  //孙进程read为阻塞，关闭通知其进行读取
        wait(0);  //等待孙进程结束
    }
}

int main(int argc, char *argv[])
{
    int ptoc[2];  //父进程到子进程的管道，初始为第一级和第二级进程间的管道

    if (pipe(ptoc) < 0) {
        printf("message #prime: failed to create pipe\n");
        exit(1);
    }

    int pid = fork();

    if (pid < 0) {
        printf("message #prime: failed to fork\n");
        exit(2);
    }

    if (pid == 0) {
        cascade_calc(ptoc);  //进行递归计算
    }
    else {
        close(ptoc[0]);  //父进程不用读，直接关闭

        for (int i = 2; i <= LIMIT; i++)  //写入所有数字
            write(ptoc[1], &i, sizeof(i));

        close(ptoc[1]);  //子进程read为阻塞，关闭通知其进行读取
        wait(0);  //等待子进程结束
    }

    exit(0);
}