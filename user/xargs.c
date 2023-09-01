#include"user.h"
#include"../kernel/param.h"

int main(int argc, char *argv[])
{
    char *newArgv[MAXARG];      //存每个拼接完成指令的argv
    char **newArgvP = newArgv;  //指向newArgv的第一个空闲位置
    char readBuf[32];           //读取输入时的缓冲区

    char lineBuf[32];        //存用尾零分割的已有每行输出
    char *newArg = lineBuf;  //指向lineBuf中，最后一个未被存入newArgv子串的首地址
    char *lineP = lineBuf;   //指向lineBuf的第一个空闲位置

    for(int i = 1; i < argc; i++, newArgvP++){  //暂存待拼接指令的argv
        *newArgvP = argv[i];
    }

    // printf("argc: %d\n", argc);
    // printf("argv:\n");
    // for (int i = 0; i < argc; i++)
    // {
    //     printf("@%d: %s@\n", i, argv[i]);
    // }

    while (1) {  //不断读取标准输入
        const int readLen = read(0, readBuf, sizeof(readBuf));  //一次最多读32B，实际读取长度由readLen表示
        if (readLen == 0)
            break;

        for (int i = 0; i < readLen; i++) {
            switch (readBuf[i])
            {
            case '\n':
                *lineP = '\0';         //参数读取结束，分割并添加尾零
                lineP = lineBuf;       //lineP复位
                *newArgvP++ = newArg;  //将最后一个参数存入
                newArg = lineBuf;      //newArg复位
                *newArgvP = '\0';      //多加一个空串作为整一条指令的结束符号
                newArgvP = &(newArgv[argc - 1]);  //回到待拼接指令的末尾，准备将下一行的输出拼接上去

                int pid = fork();  //创建进程

                if (pid < 0) {
                    printf("message #xargs: failed to fork\n");
                    exit(1);
                }

                if (pid == 0) {  //子进程执行拼接后的完整指令
                    exec(argv[1], newArgv);
                }

                wait(0);  //父进程等待子进程执行完毕
                break;
            case ' ':
                *lineP++ = '\0';       //参数读取结束，分割并添加尾零
                *newArgvP++ = newArg;  //将该参数存入
                newArg = lineP;        //newArg指向下一个参数在lineBuf中的首地址，准备下次存入
                break;
            default:
                *lineP++ = readBuf[i];  //直接读进lineBuf
                break;
            }
        }
    }

    exit(0);
}