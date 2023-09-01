#include"user.h"
#include"../kernel/stat.h"
#include"../kernel/fs.h"
#include"../kernel/fcntl.h"  //输出方式
#include"../kernel/types.h"

char *fmtname(char *path)
{
    static char buf[DIRSIZ + 1];
    char *p;

    //定位最后一个斜杠后第一个字母
    for (p = path + strlen(path); p >= path && *p != '/'; p--);
    p++;
    
    memmove(buf, p, strlen(p) + 1);  //放入buf
    return buf;
}

void find(char *path, char *fileName)
{
    int fileID;
    struct stat status;

    if ((fileID = open(path, O_RDONLY)) < 0) {
        printf("message #find: cannot open %s\n", path);
        return;
    }

    if (fstat(fileID, &status) < 0) {
        printf("message #find: cannot stat %s\n", path);
        close(fileID);
        return;
    }

    char buf[512], *p;
    struct dirent child;

    switch (status.type)
    {
    case T_FILE:
        if (strcmp(fmtname(path), fileName) == 0) {  //若找到一个文件，且该文件名与指定的文件名相同，则说明找到
            printf("%s\n", path);
        }
        break;
    case T_DIR:
        if (strlen(path) + 1 + DIRSIZ + 1 > sizeof(buf)) {  //路径超过缓冲区长度则进行相应提示
            printf("message #find: path too long\n");
            break;
        }

        strcpy(buf, path);  //拷贝路径到缓冲区并加上斜杠
        p = buf + strlen(buf);
        *p++ = '/';

        while (read(fileID, &child, sizeof(child)) == sizeof(child)) {  //逐个读取当前路径的子项，相关信息为16字节
            
            //printf("child.name:%s, child.inum:%d\n", child.name, child.inum);

            if (strcmp(child.name, "") == 0)  //若子项名字为空，说明所有子项读取完毕
                break;

			if(child.inum == 0 || child.inum == 1 || strcmp(child.name, ".") == 0 || strcmp(child.name, "..") == 0)  //若子项编号或名字不合要求，则过滤掉
				continue;
            
			memmove(p, child.name, strlen(child.name));
			p[strlen(child.name)] = 0;
            //printf(buf);
            //printf("\n");
			find(buf, fileName);  //递归寻找目标文件
        }

        break;
    }

    close(fileID);
}

int main(int argc, char *argv[])
{
    if (argc < 3) {
        printf("usage #find: find <path> <fileName>\n");
        exit(0);
    }

    find(argv[1], argv[2]);
    exit(0);
}