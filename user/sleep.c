#include"user.h"

int main(int argc, char *argv[])
{
    const char* warning = "usage #sleep: sleep <milliseconds>\n";  //无参数时的提示

    if (argc == 1) {  //只有一个参数时给出提示
        write(1, warning, strlen(warning));
        exit(0);
    }

    const int count = atoi(argv[1]);  //正常情况直接进行系统调用
    sleep(count);
    exit(0);
}