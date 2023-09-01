#include"user.h"

int main(int argc, char *argv[])
{
    int ptoc[2], ctop[2];  //两个管道，分别负责两个方向的通信。由于有读写两个整型参数，因此长度为2

    if (pipe(ptoc) < 0 || pipe(ctop) < 0) {  //创建管道，失败则返回负数
        printf("message #pingpong: failed to create pipe\n");
        exit(1);
    }

    int pid = fork();

    if (pid < 0) {  //创建子进程，失败则返回负数
        printf("message #pingpong: failed to fork\n");
        exit(2);
    }

    if (pid == 0) {
        char cbuf[1];
        read(ptoc[0], cbuf, sizeof(cbuf));  //读阻塞，因此可以完成与父进程的同步
        printf("%d: received ping\n", getpid());

        write(ctop[1], cbuf, strlen(cbuf));
    }
    else {
        char pbuf[1] = { 'c' };
        write(ptoc[1], pbuf, strlen(pbuf));
        wait(0);  //等子进程结束写后再读，完成同步
        read(ctop[0], pbuf, sizeof(pbuf));
        printf("%d: received pong\n", getpid());
    }

    exit(0);
}