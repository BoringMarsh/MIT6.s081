
user/_symlinktest:     file format elf64-littleriscv


Disassembly of section .text:

0000000000000000 <stat_slink>:
}

// stat a symbolic link using O_NOFOLLOW
static int
stat_slink(char *pn, struct stat *st)
{
   0:	1101                	addi	sp,sp,-32
   2:	ec06                	sd	ra,24(sp)
   4:	e822                	sd	s0,16(sp)
   6:	e426                	sd	s1,8(sp)
   8:	1000                	addi	s0,sp,32
   a:	84ae                	mv	s1,a1
  int fd = open(pn, O_RDONLY | O_NOFOLLOW);
   c:	6585                	lui	a1,0x1
   e:	80058593          	addi	a1,a1,-2048 # 800 <stat>
  12:	00001097          	auipc	ra,0x1
  16:	970080e7          	jalr	-1680(ra) # 982 <open>
  if(fd < 0)
  1a:	02054063          	bltz	a0,3a <stat_slink+0x3a>
    return -1;
  if(fstat(fd, st) != 0)
  1e:	85a6                	mv	a1,s1
  20:	00001097          	auipc	ra,0x1
  24:	97a080e7          	jalr	-1670(ra) # 99a <fstat>
  28:	00a03533          	snez	a0,a0
  2c:	40a00533          	neg	a0,a0
    return -1;
  return 0;
}
  30:	60e2                	ld	ra,24(sp)
  32:	6442                	ld	s0,16(sp)
  34:	64a2                	ld	s1,8(sp)
  36:	6105                	addi	sp,sp,32
  38:	8082                	ret
    return -1;
  3a:	557d                	li	a0,-1
  3c:	bfd5                	j	30 <stat_slink+0x30>

000000000000003e <main>:
{
  3e:	7119                	addi	sp,sp,-128
  40:	fc86                	sd	ra,120(sp)
  42:	f8a2                	sd	s0,112(sp)
  44:	f4a6                	sd	s1,104(sp)
  46:	f0ca                	sd	s2,96(sp)
  48:	ecce                	sd	s3,88(sp)
  4a:	e8d2                	sd	s4,80(sp)
  4c:	e4d6                	sd	s5,72(sp)
  4e:	e0da                	sd	s6,64(sp)
  50:	fc5e                	sd	s7,56(sp)
  52:	f862                	sd	s8,48(sp)
  54:	0100                	addi	s0,sp,128
  unlink("/testsymlink/a");
  56:	00001517          	auipc	a0,0x1
  5a:	e1250513          	addi	a0,a0,-494 # e68 <malloc+0xe8>
  5e:	00001097          	auipc	ra,0x1
  62:	934080e7          	jalr	-1740(ra) # 992 <unlink>
  unlink("/testsymlink/b");
  66:	00001517          	auipc	a0,0x1
  6a:	e1250513          	addi	a0,a0,-494 # e78 <malloc+0xf8>
  6e:	00001097          	auipc	ra,0x1
  72:	924080e7          	jalr	-1756(ra) # 992 <unlink>
  unlink("/testsymlink/c");
  76:	00001517          	auipc	a0,0x1
  7a:	e1250513          	addi	a0,a0,-494 # e88 <malloc+0x108>
  7e:	00001097          	auipc	ra,0x1
  82:	914080e7          	jalr	-1772(ra) # 992 <unlink>
  unlink("/testsymlink/1");
  86:	00001517          	auipc	a0,0x1
  8a:	e1250513          	addi	a0,a0,-494 # e98 <malloc+0x118>
  8e:	00001097          	auipc	ra,0x1
  92:	904080e7          	jalr	-1788(ra) # 992 <unlink>
  unlink("/testsymlink/2");
  96:	00001517          	auipc	a0,0x1
  9a:	e1250513          	addi	a0,a0,-494 # ea8 <malloc+0x128>
  9e:	00001097          	auipc	ra,0x1
  a2:	8f4080e7          	jalr	-1804(ra) # 992 <unlink>
  unlink("/testsymlink/3");
  a6:	00001517          	auipc	a0,0x1
  aa:	e1250513          	addi	a0,a0,-494 # eb8 <malloc+0x138>
  ae:	00001097          	auipc	ra,0x1
  b2:	8e4080e7          	jalr	-1820(ra) # 992 <unlink>
  unlink("/testsymlink/4");
  b6:	00001517          	auipc	a0,0x1
  ba:	e1250513          	addi	a0,a0,-494 # ec8 <malloc+0x148>
  be:	00001097          	auipc	ra,0x1
  c2:	8d4080e7          	jalr	-1836(ra) # 992 <unlink>
  unlink("/testsymlink/z");
  c6:	00001517          	auipc	a0,0x1
  ca:	e1250513          	addi	a0,a0,-494 # ed8 <malloc+0x158>
  ce:	00001097          	auipc	ra,0x1
  d2:	8c4080e7          	jalr	-1852(ra) # 992 <unlink>
  unlink("/testsymlink/y");
  d6:	00001517          	auipc	a0,0x1
  da:	e1250513          	addi	a0,a0,-494 # ee8 <malloc+0x168>
  de:	00001097          	auipc	ra,0x1
  e2:	8b4080e7          	jalr	-1868(ra) # 992 <unlink>
  unlink("/testsymlink");
  e6:	00001517          	auipc	a0,0x1
  ea:	e1250513          	addi	a0,a0,-494 # ef8 <malloc+0x178>
  ee:	00001097          	auipc	ra,0x1
  f2:	8a4080e7          	jalr	-1884(ra) # 992 <unlink>

static void
testsymlink(void)
{
  int r, fd1 = -1, fd2 = -1;
  char buf[4] = {'a', 'b', 'c', 'd'};
  f6:	646367b7          	lui	a5,0x64636
  fa:	26178793          	addi	a5,a5,609 # 64636261 <__global_pointer$+0x64634748>
  fe:	f8f42823          	sw	a5,-112(s0)
  char c = 0, c2 = 0;
 102:	f8040723          	sb	zero,-114(s0)
 106:	f80407a3          	sb	zero,-113(s0)
  struct stat st;
    
  printf("Start: test symlinks\n");
 10a:	00001517          	auipc	a0,0x1
 10e:	dfe50513          	addi	a0,a0,-514 # f08 <malloc+0x188>
 112:	00001097          	auipc	ra,0x1
 116:	bb0080e7          	jalr	-1104(ra) # cc2 <printf>

  mkdir("/testsymlink");
 11a:	00001517          	auipc	a0,0x1
 11e:	dde50513          	addi	a0,a0,-546 # ef8 <malloc+0x178>
 122:	00001097          	auipc	ra,0x1
 126:	888080e7          	jalr	-1912(ra) # 9aa <mkdir>

  fd1 = open("/testsymlink/a", O_CREATE | O_RDWR);
 12a:	20200593          	li	a1,514
 12e:	00001517          	auipc	a0,0x1
 132:	d3a50513          	addi	a0,a0,-710 # e68 <malloc+0xe8>
 136:	00001097          	auipc	ra,0x1
 13a:	84c080e7          	jalr	-1972(ra) # 982 <open>
 13e:	84aa                	mv	s1,a0
  if(fd1 < 0) fail("failed to open a");
 140:	0e054f63          	bltz	a0,23e <main+0x200>

  r = symlink("/testsymlink/a", "/testsymlink/b");
 144:	00001597          	auipc	a1,0x1
 148:	d3458593          	addi	a1,a1,-716 # e78 <malloc+0xf8>
 14c:	00001517          	auipc	a0,0x1
 150:	d1c50513          	addi	a0,a0,-740 # e68 <malloc+0xe8>
 154:	00001097          	auipc	ra,0x1
 158:	88e080e7          	jalr	-1906(ra) # 9e2 <symlink>
  if(r < 0)
 15c:	10054063          	bltz	a0,25c <main+0x21e>
    fail("symlink b -> a failed");

  if(write(fd1, buf, sizeof(buf)) != 4)
 160:	4611                	li	a2,4
 162:	f9040593          	addi	a1,s0,-112
 166:	8526                	mv	a0,s1
 168:	00000097          	auipc	ra,0x0
 16c:	7fa080e7          	jalr	2042(ra) # 962 <write>
 170:	4791                	li	a5,4
 172:	10f50463          	beq	a0,a5,27a <main+0x23c>
    fail("failed to write to a");
 176:	00001517          	auipc	a0,0x1
 17a:	dea50513          	addi	a0,a0,-534 # f60 <malloc+0x1e0>
 17e:	00001097          	auipc	ra,0x1
 182:	b44080e7          	jalr	-1212(ra) # cc2 <printf>
 186:	4785                	li	a5,1
 188:	00001717          	auipc	a4,0x1
 18c:	18f72c23          	sw	a5,408(a4) # 1320 <failed>
  int r, fd1 = -1, fd2 = -1;
 190:	597d                	li	s2,-1
  if(c!=c2)
    fail("Value read from 4 differed from value written to 1\n");

  printf("test symlinks: ok\n");
done:
  close(fd1);
 192:	8526                	mv	a0,s1
 194:	00000097          	auipc	ra,0x0
 198:	7d6080e7          	jalr	2006(ra) # 96a <close>
  close(fd2);
 19c:	854a                	mv	a0,s2
 19e:	00000097          	auipc	ra,0x0
 1a2:	7cc080e7          	jalr	1996(ra) # 96a <close>
  int pid, i;
  int fd;
  struct stat st;
  int nchild = 2;

  printf("Start: test concurrent symlinks\n");
 1a6:	00001517          	auipc	a0,0x1
 1aa:	09a50513          	addi	a0,a0,154 # 1240 <malloc+0x4c0>
 1ae:	00001097          	auipc	ra,0x1
 1b2:	b14080e7          	jalr	-1260(ra) # cc2 <printf>
    
  fd = open("/testsymlink/z", O_CREATE | O_RDWR);
 1b6:	20200593          	li	a1,514
 1ba:	00001517          	auipc	a0,0x1
 1be:	d1e50513          	addi	a0,a0,-738 # ed8 <malloc+0x158>
 1c2:	00000097          	auipc	ra,0x0
 1c6:	7c0080e7          	jalr	1984(ra) # 982 <open>
  if(fd < 0) {
 1ca:	42054263          	bltz	a0,5ee <main+0x5b0>
    printf("FAILED: open failed");
    exit(1);
  }
  close(fd);
 1ce:	00000097          	auipc	ra,0x0
 1d2:	79c080e7          	jalr	1948(ra) # 96a <close>

  for(int j = 0; j < nchild; j++) {
    pid = fork();
 1d6:	00000097          	auipc	ra,0x0
 1da:	764080e7          	jalr	1892(ra) # 93a <fork>
    if(pid < 0){
 1de:	42054563          	bltz	a0,608 <main+0x5ca>
      printf("FAILED: fork failed\n");
      exit(1);
    }
    if(pid == 0) {
 1e2:	44050063          	beqz	a0,622 <main+0x5e4>
    pid = fork();
 1e6:	00000097          	auipc	ra,0x0
 1ea:	754080e7          	jalr	1876(ra) # 93a <fork>
    if(pid < 0){
 1ee:	40054d63          	bltz	a0,608 <main+0x5ca>
    if(pid == 0) {
 1f2:	42050863          	beqz	a0,622 <main+0x5e4>
    }
  }

  int r;
  for(int j = 0; j < nchild; j++) {
    wait(&r);
 1f6:	f9840513          	addi	a0,s0,-104
 1fa:	00000097          	auipc	ra,0x0
 1fe:	750080e7          	jalr	1872(ra) # 94a <wait>
    if(r != 0) {
 202:	f9842783          	lw	a5,-104(s0)
 206:	4a079a63          	bnez	a5,6ba <main+0x67c>
    wait(&r);
 20a:	f9840513          	addi	a0,s0,-104
 20e:	00000097          	auipc	ra,0x0
 212:	73c080e7          	jalr	1852(ra) # 94a <wait>
    if(r != 0) {
 216:	f9842783          	lw	a5,-104(s0)
 21a:	4a079063          	bnez	a5,6ba <main+0x67c>
      printf("test concurrent symlinks: failed\n");
      exit(1);
    }
  }
  printf("test concurrent symlinks: ok\n");
 21e:	00001517          	auipc	a0,0x1
 222:	0c250513          	addi	a0,a0,194 # 12e0 <malloc+0x560>
 226:	00001097          	auipc	ra,0x1
 22a:	a9c080e7          	jalr	-1380(ra) # cc2 <printf>
  exit(failed);
 22e:	00001517          	auipc	a0,0x1
 232:	0f252503          	lw	a0,242(a0) # 1320 <failed>
 236:	00000097          	auipc	ra,0x0
 23a:	70c080e7          	jalr	1804(ra) # 942 <exit>
  if(fd1 < 0) fail("failed to open a");
 23e:	00001517          	auipc	a0,0x1
 242:	ce250513          	addi	a0,a0,-798 # f20 <malloc+0x1a0>
 246:	00001097          	auipc	ra,0x1
 24a:	a7c080e7          	jalr	-1412(ra) # cc2 <printf>
 24e:	4785                	li	a5,1
 250:	00001717          	auipc	a4,0x1
 254:	0cf72823          	sw	a5,208(a4) # 1320 <failed>
  int r, fd1 = -1, fd2 = -1;
 258:	597d                	li	s2,-1
  if(fd1 < 0) fail("failed to open a");
 25a:	bf25                	j	192 <main+0x154>
    fail("symlink b -> a failed");
 25c:	00001517          	auipc	a0,0x1
 260:	ce450513          	addi	a0,a0,-796 # f40 <malloc+0x1c0>
 264:	00001097          	auipc	ra,0x1
 268:	a5e080e7          	jalr	-1442(ra) # cc2 <printf>
 26c:	4785                	li	a5,1
 26e:	00001717          	auipc	a4,0x1
 272:	0af72923          	sw	a5,178(a4) # 1320 <failed>
  int r, fd1 = -1, fd2 = -1;
 276:	597d                	li	s2,-1
    fail("symlink b -> a failed");
 278:	bf29                	j	192 <main+0x154>
  if (stat_slink("/testsymlink/b", &st) != 0)
 27a:	f9840593          	addi	a1,s0,-104
 27e:	00001517          	auipc	a0,0x1
 282:	bfa50513          	addi	a0,a0,-1030 # e78 <malloc+0xf8>
 286:	00000097          	auipc	ra,0x0
 28a:	d7a080e7          	jalr	-646(ra) # 0 <stat_slink>
 28e:	e50d                	bnez	a0,2b8 <main+0x27a>
  if(st.type != T_SYMLINK)
 290:	fa041703          	lh	a4,-96(s0)
 294:	4791                	li	a5,4
 296:	04f70063          	beq	a4,a5,2d6 <main+0x298>
    fail("b isn't a symlink");
 29a:	00001517          	auipc	a0,0x1
 29e:	d0650513          	addi	a0,a0,-762 # fa0 <malloc+0x220>
 2a2:	00001097          	auipc	ra,0x1
 2a6:	a20080e7          	jalr	-1504(ra) # cc2 <printf>
 2aa:	4785                	li	a5,1
 2ac:	00001717          	auipc	a4,0x1
 2b0:	06f72a23          	sw	a5,116(a4) # 1320 <failed>
  int r, fd1 = -1, fd2 = -1;
 2b4:	597d                	li	s2,-1
    fail("b isn't a symlink");
 2b6:	bdf1                	j	192 <main+0x154>
    fail("failed to stat b");
 2b8:	00001517          	auipc	a0,0x1
 2bc:	cc850513          	addi	a0,a0,-824 # f80 <malloc+0x200>
 2c0:	00001097          	auipc	ra,0x1
 2c4:	a02080e7          	jalr	-1534(ra) # cc2 <printf>
 2c8:	4785                	li	a5,1
 2ca:	00001717          	auipc	a4,0x1
 2ce:	04f72b23          	sw	a5,86(a4) # 1320 <failed>
  int r, fd1 = -1, fd2 = -1;
 2d2:	597d                	li	s2,-1
    fail("failed to stat b");
 2d4:	bd7d                	j	192 <main+0x154>
  fd2 = open("/testsymlink/b", O_RDWR);
 2d6:	4589                	li	a1,2
 2d8:	00001517          	auipc	a0,0x1
 2dc:	ba050513          	addi	a0,a0,-1120 # e78 <malloc+0xf8>
 2e0:	00000097          	auipc	ra,0x0
 2e4:	6a2080e7          	jalr	1698(ra) # 982 <open>
 2e8:	892a                	mv	s2,a0
  if(fd2 < 0)
 2ea:	02054d63          	bltz	a0,324 <main+0x2e6>
  read(fd2, &c, 1);
 2ee:	4605                	li	a2,1
 2f0:	f8e40593          	addi	a1,s0,-114
 2f4:	00000097          	auipc	ra,0x0
 2f8:	666080e7          	jalr	1638(ra) # 95a <read>
  if (c != 'a')
 2fc:	f8e44703          	lbu	a4,-114(s0)
 300:	06100793          	li	a5,97
 304:	02f70e63          	beq	a4,a5,340 <main+0x302>
    fail("failed to read bytes from b");
 308:	00001517          	auipc	a0,0x1
 30c:	cd850513          	addi	a0,a0,-808 # fe0 <malloc+0x260>
 310:	00001097          	auipc	ra,0x1
 314:	9b2080e7          	jalr	-1614(ra) # cc2 <printf>
 318:	4785                	li	a5,1
 31a:	00001717          	auipc	a4,0x1
 31e:	00f72323          	sw	a5,6(a4) # 1320 <failed>
 322:	bd85                	j	192 <main+0x154>
    fail("failed to open b");
 324:	00001517          	auipc	a0,0x1
 328:	c9c50513          	addi	a0,a0,-868 # fc0 <malloc+0x240>
 32c:	00001097          	auipc	ra,0x1
 330:	996080e7          	jalr	-1642(ra) # cc2 <printf>
 334:	4785                	li	a5,1
 336:	00001717          	auipc	a4,0x1
 33a:	fef72523          	sw	a5,-22(a4) # 1320 <failed>
 33e:	bd91                	j	192 <main+0x154>
  unlink("/testsymlink/a");
 340:	00001517          	auipc	a0,0x1
 344:	b2850513          	addi	a0,a0,-1240 # e68 <malloc+0xe8>
 348:	00000097          	auipc	ra,0x0
 34c:	64a080e7          	jalr	1610(ra) # 992 <unlink>
  if(open("/testsymlink/b", O_RDWR) >= 0)
 350:	4589                	li	a1,2
 352:	00001517          	auipc	a0,0x1
 356:	b2650513          	addi	a0,a0,-1242 # e78 <malloc+0xf8>
 35a:	00000097          	auipc	ra,0x0
 35e:	628080e7          	jalr	1576(ra) # 982 <open>
 362:	12055263          	bgez	a0,486 <main+0x448>
  r = symlink("/testsymlink/b", "/testsymlink/a");
 366:	00001597          	auipc	a1,0x1
 36a:	b0258593          	addi	a1,a1,-1278 # e68 <malloc+0xe8>
 36e:	00001517          	auipc	a0,0x1
 372:	b0a50513          	addi	a0,a0,-1270 # e78 <malloc+0xf8>
 376:	00000097          	auipc	ra,0x0
 37a:	66c080e7          	jalr	1644(ra) # 9e2 <symlink>
  if(r < 0)
 37e:	12054263          	bltz	a0,4a2 <main+0x464>
  r = open("/testsymlink/b", O_RDWR);
 382:	4589                	li	a1,2
 384:	00001517          	auipc	a0,0x1
 388:	af450513          	addi	a0,a0,-1292 # e78 <malloc+0xf8>
 38c:	00000097          	auipc	ra,0x0
 390:	5f6080e7          	jalr	1526(ra) # 982 <open>
  if(r >= 0)
 394:	12055563          	bgez	a0,4be <main+0x480>
  r = symlink("/testsymlink/nonexistent", "/testsymlink/c");
 398:	00001597          	auipc	a1,0x1
 39c:	af058593          	addi	a1,a1,-1296 # e88 <malloc+0x108>
 3a0:	00001517          	auipc	a0,0x1
 3a4:	d0050513          	addi	a0,a0,-768 # 10a0 <malloc+0x320>
 3a8:	00000097          	auipc	ra,0x0
 3ac:	63a080e7          	jalr	1594(ra) # 9e2 <symlink>
  if(r != 0)
 3b0:	12051563          	bnez	a0,4da <main+0x49c>
  r = symlink("/testsymlink/2", "/testsymlink/1");
 3b4:	00001597          	auipc	a1,0x1
 3b8:	ae458593          	addi	a1,a1,-1308 # e98 <malloc+0x118>
 3bc:	00001517          	auipc	a0,0x1
 3c0:	aec50513          	addi	a0,a0,-1300 # ea8 <malloc+0x128>
 3c4:	00000097          	auipc	ra,0x0
 3c8:	61e080e7          	jalr	1566(ra) # 9e2 <symlink>
  if(r) fail("Failed to link 1->2");
 3cc:	12051563          	bnez	a0,4f6 <main+0x4b8>
  r = symlink("/testsymlink/3", "/testsymlink/2");
 3d0:	00001597          	auipc	a1,0x1
 3d4:	ad858593          	addi	a1,a1,-1320 # ea8 <malloc+0x128>
 3d8:	00001517          	auipc	a0,0x1
 3dc:	ae050513          	addi	a0,a0,-1312 # eb8 <malloc+0x138>
 3e0:	00000097          	auipc	ra,0x0
 3e4:	602080e7          	jalr	1538(ra) # 9e2 <symlink>
  if(r) fail("Failed to link 2->3");
 3e8:	12051563          	bnez	a0,512 <main+0x4d4>
  r = symlink("/testsymlink/4", "/testsymlink/3");
 3ec:	00001597          	auipc	a1,0x1
 3f0:	acc58593          	addi	a1,a1,-1332 # eb8 <malloc+0x138>
 3f4:	00001517          	auipc	a0,0x1
 3f8:	ad450513          	addi	a0,a0,-1324 # ec8 <malloc+0x148>
 3fc:	00000097          	auipc	ra,0x0
 400:	5e6080e7          	jalr	1510(ra) # 9e2 <symlink>
  if(r) fail("Failed to link 3->4");
 404:	12051563          	bnez	a0,52e <main+0x4f0>
  close(fd1);
 408:	8526                	mv	a0,s1
 40a:	00000097          	auipc	ra,0x0
 40e:	560080e7          	jalr	1376(ra) # 96a <close>
  close(fd2);
 412:	854a                	mv	a0,s2
 414:	00000097          	auipc	ra,0x0
 418:	556080e7          	jalr	1366(ra) # 96a <close>
  fd1 = open("/testsymlink/4", O_CREATE | O_RDWR);
 41c:	20200593          	li	a1,514
 420:	00001517          	auipc	a0,0x1
 424:	aa850513          	addi	a0,a0,-1368 # ec8 <malloc+0x148>
 428:	00000097          	auipc	ra,0x0
 42c:	55a080e7          	jalr	1370(ra) # 982 <open>
 430:	84aa                	mv	s1,a0
  if(fd1<0) fail("Failed to create 4\n");
 432:	10054c63          	bltz	a0,54a <main+0x50c>
  fd2 = open("/testsymlink/1", O_RDWR);
 436:	4589                	li	a1,2
 438:	00001517          	auipc	a0,0x1
 43c:	a6050513          	addi	a0,a0,-1440 # e98 <malloc+0x118>
 440:	00000097          	auipc	ra,0x0
 444:	542080e7          	jalr	1346(ra) # 982 <open>
 448:	892a                	mv	s2,a0
  if(fd2<0) fail("Failed to open 1\n");
 44a:	10054e63          	bltz	a0,566 <main+0x528>
  c = '#';
 44e:	02300793          	li	a5,35
 452:	f8f40723          	sb	a5,-114(s0)
  r = write(fd2, &c, 1);
 456:	4605                	li	a2,1
 458:	f8e40593          	addi	a1,s0,-114
 45c:	00000097          	auipc	ra,0x0
 460:	506080e7          	jalr	1286(ra) # 962 <write>
  if(r!=1) fail("Failed to write to 1\n");
 464:	4785                	li	a5,1
 466:	10f50e63          	beq	a0,a5,582 <main+0x544>
 46a:	00001517          	auipc	a0,0x1
 46e:	d3650513          	addi	a0,a0,-714 # 11a0 <malloc+0x420>
 472:	00001097          	auipc	ra,0x1
 476:	850080e7          	jalr	-1968(ra) # cc2 <printf>
 47a:	4785                	li	a5,1
 47c:	00001717          	auipc	a4,0x1
 480:	eaf72223          	sw	a5,-348(a4) # 1320 <failed>
 484:	b339                	j	192 <main+0x154>
    fail("Should not be able to open b after deleting a");
 486:	00001517          	auipc	a0,0x1
 48a:	b8250513          	addi	a0,a0,-1150 # 1008 <malloc+0x288>
 48e:	00001097          	auipc	ra,0x1
 492:	834080e7          	jalr	-1996(ra) # cc2 <printf>
 496:	4785                	li	a5,1
 498:	00001717          	auipc	a4,0x1
 49c:	e8f72423          	sw	a5,-376(a4) # 1320 <failed>
 4a0:	b9cd                	j	192 <main+0x154>
    fail("symlink a -> b failed");
 4a2:	00001517          	auipc	a0,0x1
 4a6:	b9e50513          	addi	a0,a0,-1122 # 1040 <malloc+0x2c0>
 4aa:	00001097          	auipc	ra,0x1
 4ae:	818080e7          	jalr	-2024(ra) # cc2 <printf>
 4b2:	4785                	li	a5,1
 4b4:	00001717          	auipc	a4,0x1
 4b8:	e6f72623          	sw	a5,-404(a4) # 1320 <failed>
 4bc:	b9d9                	j	192 <main+0x154>
    fail("Should not be able to open b (cycle b->a->b->..)\n");
 4be:	00001517          	auipc	a0,0x1
 4c2:	ba250513          	addi	a0,a0,-1118 # 1060 <malloc+0x2e0>
 4c6:	00000097          	auipc	ra,0x0
 4ca:	7fc080e7          	jalr	2044(ra) # cc2 <printf>
 4ce:	4785                	li	a5,1
 4d0:	00001717          	auipc	a4,0x1
 4d4:	e4f72823          	sw	a5,-432(a4) # 1320 <failed>
 4d8:	b96d                	j	192 <main+0x154>
    fail("Symlinking to nonexistent file should succeed\n");
 4da:	00001517          	auipc	a0,0x1
 4de:	be650513          	addi	a0,a0,-1050 # 10c0 <malloc+0x340>
 4e2:	00000097          	auipc	ra,0x0
 4e6:	7e0080e7          	jalr	2016(ra) # cc2 <printf>
 4ea:	4785                	li	a5,1
 4ec:	00001717          	auipc	a4,0x1
 4f0:	e2f72a23          	sw	a5,-460(a4) # 1320 <failed>
 4f4:	b979                	j	192 <main+0x154>
  if(r) fail("Failed to link 1->2");
 4f6:	00001517          	auipc	a0,0x1
 4fa:	c0a50513          	addi	a0,a0,-1014 # 1100 <malloc+0x380>
 4fe:	00000097          	auipc	ra,0x0
 502:	7c4080e7          	jalr	1988(ra) # cc2 <printf>
 506:	4785                	li	a5,1
 508:	00001717          	auipc	a4,0x1
 50c:	e0f72c23          	sw	a5,-488(a4) # 1320 <failed>
 510:	b149                	j	192 <main+0x154>
  if(r) fail("Failed to link 2->3");
 512:	00001517          	auipc	a0,0x1
 516:	c0e50513          	addi	a0,a0,-1010 # 1120 <malloc+0x3a0>
 51a:	00000097          	auipc	ra,0x0
 51e:	7a8080e7          	jalr	1960(ra) # cc2 <printf>
 522:	4785                	li	a5,1
 524:	00001717          	auipc	a4,0x1
 528:	def72e23          	sw	a5,-516(a4) # 1320 <failed>
 52c:	b19d                	j	192 <main+0x154>
  if(r) fail("Failed to link 3->4");
 52e:	00001517          	auipc	a0,0x1
 532:	c1250513          	addi	a0,a0,-1006 # 1140 <malloc+0x3c0>
 536:	00000097          	auipc	ra,0x0
 53a:	78c080e7          	jalr	1932(ra) # cc2 <printf>
 53e:	4785                	li	a5,1
 540:	00001717          	auipc	a4,0x1
 544:	def72023          	sw	a5,-544(a4) # 1320 <failed>
 548:	b1a9                	j	192 <main+0x154>
  if(fd1<0) fail("Failed to create 4\n");
 54a:	00001517          	auipc	a0,0x1
 54e:	c1650513          	addi	a0,a0,-1002 # 1160 <malloc+0x3e0>
 552:	00000097          	auipc	ra,0x0
 556:	770080e7          	jalr	1904(ra) # cc2 <printf>
 55a:	4785                	li	a5,1
 55c:	00001717          	auipc	a4,0x1
 560:	dcf72223          	sw	a5,-572(a4) # 1320 <failed>
 564:	b13d                	j	192 <main+0x154>
  if(fd2<0) fail("Failed to open 1\n");
 566:	00001517          	auipc	a0,0x1
 56a:	c1a50513          	addi	a0,a0,-998 # 1180 <malloc+0x400>
 56e:	00000097          	auipc	ra,0x0
 572:	754080e7          	jalr	1876(ra) # cc2 <printf>
 576:	4785                	li	a5,1
 578:	00001717          	auipc	a4,0x1
 57c:	daf72423          	sw	a5,-600(a4) # 1320 <failed>
 580:	b909                	j	192 <main+0x154>
  r = read(fd1, &c2, 1);
 582:	4605                	li	a2,1
 584:	f8f40593          	addi	a1,s0,-113
 588:	8526                	mv	a0,s1
 58a:	00000097          	auipc	ra,0x0
 58e:	3d0080e7          	jalr	976(ra) # 95a <read>
  if(r!=1) fail("Failed to read from 4\n");
 592:	4785                	li	a5,1
 594:	02f51663          	bne	a0,a5,5c0 <main+0x582>
  if(c!=c2)
 598:	f8e44703          	lbu	a4,-114(s0)
 59c:	f8f44783          	lbu	a5,-113(s0)
 5a0:	02f70e63          	beq	a4,a5,5dc <main+0x59e>
    fail("Value read from 4 differed from value written to 1\n");
 5a4:	00001517          	auipc	a0,0x1
 5a8:	c4450513          	addi	a0,a0,-956 # 11e8 <malloc+0x468>
 5ac:	00000097          	auipc	ra,0x0
 5b0:	716080e7          	jalr	1814(ra) # cc2 <printf>
 5b4:	4785                	li	a5,1
 5b6:	00001717          	auipc	a4,0x1
 5ba:	d6f72523          	sw	a5,-662(a4) # 1320 <failed>
 5be:	bed1                	j	192 <main+0x154>
  if(r!=1) fail("Failed to read from 4\n");
 5c0:	00001517          	auipc	a0,0x1
 5c4:	c0050513          	addi	a0,a0,-1024 # 11c0 <malloc+0x440>
 5c8:	00000097          	auipc	ra,0x0
 5cc:	6fa080e7          	jalr	1786(ra) # cc2 <printf>
 5d0:	4785                	li	a5,1
 5d2:	00001717          	auipc	a4,0x1
 5d6:	d4f72723          	sw	a5,-690(a4) # 1320 <failed>
 5da:	be65                	j	192 <main+0x154>
  printf("test symlinks: ok\n");
 5dc:	00001517          	auipc	a0,0x1
 5e0:	c4c50513          	addi	a0,a0,-948 # 1228 <malloc+0x4a8>
 5e4:	00000097          	auipc	ra,0x0
 5e8:	6de080e7          	jalr	1758(ra) # cc2 <printf>
 5ec:	b65d                	j	192 <main+0x154>
    printf("FAILED: open failed");
 5ee:	00001517          	auipc	a0,0x1
 5f2:	c7a50513          	addi	a0,a0,-902 # 1268 <malloc+0x4e8>
 5f6:	00000097          	auipc	ra,0x0
 5fa:	6cc080e7          	jalr	1740(ra) # cc2 <printf>
    exit(1);
 5fe:	4505                	li	a0,1
 600:	00000097          	auipc	ra,0x0
 604:	342080e7          	jalr	834(ra) # 942 <exit>
      printf("FAILED: fork failed\n");
 608:	00001517          	auipc	a0,0x1
 60c:	c7850513          	addi	a0,a0,-904 # 1280 <malloc+0x500>
 610:	00000097          	auipc	ra,0x0
 614:	6b2080e7          	jalr	1714(ra) # cc2 <printf>
      exit(1);
 618:	4505                	li	a0,1
 61a:	00000097          	auipc	ra,0x0
 61e:	328080e7          	jalr	808(ra) # 942 <exit>
  int r, fd1 = -1, fd2 = -1;
 622:	06400493          	li	s1,100
      unsigned int x = (pid ? 1 : 97);
 626:	06100913          	li	s2,97
        x = x * 1103515245 + 12345;
 62a:	41c65ab7          	lui	s5,0x41c65
 62e:	e6da8a9b          	addiw	s5,s5,-403
 632:	6a0d                	lui	s4,0x3
 634:	039a0a1b          	addiw	s4,s4,57
        if((x % 3) == 0) {
 638:	4b0d                	li	s6,3
          unlink("/testsymlink/y");
 63a:	00001997          	auipc	s3,0x1
 63e:	8ae98993          	addi	s3,s3,-1874 # ee8 <malloc+0x168>
          symlink("/testsymlink/z", "/testsymlink/y");
 642:	00001b97          	auipc	s7,0x1
 646:	896b8b93          	addi	s7,s7,-1898 # ed8 <malloc+0x158>
            if(st.type != T_SYMLINK) {
 64a:	4c11                	li	s8,4
 64c:	a801                	j	65c <main+0x61e>
          unlink("/testsymlink/y");
 64e:	854e                	mv	a0,s3
 650:	00000097          	auipc	ra,0x0
 654:	342080e7          	jalr	834(ra) # 992 <unlink>
      for(i = 0; i < 100; i++){
 658:	34fd                	addiw	s1,s1,-1
 65a:	c8b9                	beqz	s1,6b0 <main+0x672>
        x = x * 1103515245 + 12345;
 65c:	035907bb          	mulw	a5,s2,s5
 660:	014787bb          	addw	a5,a5,s4
 664:	0007891b          	sext.w	s2,a5
        if((x % 3) == 0) {
 668:	0367f7bb          	remuw	a5,a5,s6
 66c:	f3ed                	bnez	a5,64e <main+0x610>
          symlink("/testsymlink/z", "/testsymlink/y");
 66e:	85ce                	mv	a1,s3
 670:	855e                	mv	a0,s7
 672:	00000097          	auipc	ra,0x0
 676:	370080e7          	jalr	880(ra) # 9e2 <symlink>
          if (stat_slink("/testsymlink/y", &st) == 0) {
 67a:	f9840593          	addi	a1,s0,-104
 67e:	854e                	mv	a0,s3
 680:	00000097          	auipc	ra,0x0
 684:	980080e7          	jalr	-1664(ra) # 0 <stat_slink>
 688:	f961                	bnez	a0,658 <main+0x61a>
            if(st.type != T_SYMLINK) {
 68a:	fa041583          	lh	a1,-96(s0)
 68e:	0005879b          	sext.w	a5,a1
 692:	fd8783e3          	beq	a5,s8,658 <main+0x61a>
              printf("FAILED: not a symbolic link\n", st.type);
 696:	00001517          	auipc	a0,0x1
 69a:	c0250513          	addi	a0,a0,-1022 # 1298 <malloc+0x518>
 69e:	00000097          	auipc	ra,0x0
 6a2:	624080e7          	jalr	1572(ra) # cc2 <printf>
              exit(1);
 6a6:	4505                	li	a0,1
 6a8:	00000097          	auipc	ra,0x0
 6ac:	29a080e7          	jalr	666(ra) # 942 <exit>
      exit(0);
 6b0:	4501                	li	a0,0
 6b2:	00000097          	auipc	ra,0x0
 6b6:	290080e7          	jalr	656(ra) # 942 <exit>
      printf("test concurrent symlinks: failed\n");
 6ba:	00001517          	auipc	a0,0x1
 6be:	bfe50513          	addi	a0,a0,-1026 # 12b8 <malloc+0x538>
 6c2:	00000097          	auipc	ra,0x0
 6c6:	600080e7          	jalr	1536(ra) # cc2 <printf>
      exit(1);
 6ca:	4505                	li	a0,1
 6cc:	00000097          	auipc	ra,0x0
 6d0:	276080e7          	jalr	630(ra) # 942 <exit>

00000000000006d4 <strcpy>:
#include "kernel/fcntl.h"
#include "user/user.h"

char*
strcpy(char *s, const char *t)
{
 6d4:	1141                	addi	sp,sp,-16
 6d6:	e422                	sd	s0,8(sp)
 6d8:	0800                	addi	s0,sp,16
  char *os;

  os = s;
  while((*s++ = *t++) != 0)
 6da:	87aa                	mv	a5,a0
 6dc:	0585                	addi	a1,a1,1
 6de:	0785                	addi	a5,a5,1
 6e0:	fff5c703          	lbu	a4,-1(a1)
 6e4:	fee78fa3          	sb	a4,-1(a5)
 6e8:	fb75                	bnez	a4,6dc <strcpy+0x8>
    ;
  return os;
}
 6ea:	6422                	ld	s0,8(sp)
 6ec:	0141                	addi	sp,sp,16
 6ee:	8082                	ret

00000000000006f0 <strcmp>:

int
strcmp(const char *p, const char *q)
{
 6f0:	1141                	addi	sp,sp,-16
 6f2:	e422                	sd	s0,8(sp)
 6f4:	0800                	addi	s0,sp,16
  while(*p && *p == *q)
 6f6:	00054783          	lbu	a5,0(a0)
 6fa:	cb91                	beqz	a5,70e <strcmp+0x1e>
 6fc:	0005c703          	lbu	a4,0(a1)
 700:	00f71763          	bne	a4,a5,70e <strcmp+0x1e>
    p++, q++;
 704:	0505                	addi	a0,a0,1
 706:	0585                	addi	a1,a1,1
  while(*p && *p == *q)
 708:	00054783          	lbu	a5,0(a0)
 70c:	fbe5                	bnez	a5,6fc <strcmp+0xc>
  return (uchar)*p - (uchar)*q;
 70e:	0005c503          	lbu	a0,0(a1)
}
 712:	40a7853b          	subw	a0,a5,a0
 716:	6422                	ld	s0,8(sp)
 718:	0141                	addi	sp,sp,16
 71a:	8082                	ret

000000000000071c <strlen>:

uint
strlen(const char *s)
{
 71c:	1141                	addi	sp,sp,-16
 71e:	e422                	sd	s0,8(sp)
 720:	0800                	addi	s0,sp,16
  int n;

  for(n = 0; s[n]; n++)
 722:	00054783          	lbu	a5,0(a0)
 726:	cf91                	beqz	a5,742 <strlen+0x26>
 728:	0505                	addi	a0,a0,1
 72a:	87aa                	mv	a5,a0
 72c:	4685                	li	a3,1
 72e:	9e89                	subw	a3,a3,a0
 730:	00f6853b          	addw	a0,a3,a5
 734:	0785                	addi	a5,a5,1
 736:	fff7c703          	lbu	a4,-1(a5)
 73a:	fb7d                	bnez	a4,730 <strlen+0x14>
    ;
  return n;
}
 73c:	6422                	ld	s0,8(sp)
 73e:	0141                	addi	sp,sp,16
 740:	8082                	ret
  for(n = 0; s[n]; n++)
 742:	4501                	li	a0,0
 744:	bfe5                	j	73c <strlen+0x20>

0000000000000746 <memset>:

void*
memset(void *dst, int c, uint n)
{
 746:	1141                	addi	sp,sp,-16
 748:	e422                	sd	s0,8(sp)
 74a:	0800                	addi	s0,sp,16
  char *cdst = (char *) dst;
  int i;
  for(i = 0; i < n; i++){
 74c:	ca19                	beqz	a2,762 <memset+0x1c>
 74e:	87aa                	mv	a5,a0
 750:	1602                	slli	a2,a2,0x20
 752:	9201                	srli	a2,a2,0x20
 754:	00a60733          	add	a4,a2,a0
    cdst[i] = c;
 758:	00b78023          	sb	a1,0(a5)
  for(i = 0; i < n; i++){
 75c:	0785                	addi	a5,a5,1
 75e:	fee79de3          	bne	a5,a4,758 <memset+0x12>
  }
  return dst;
}
 762:	6422                	ld	s0,8(sp)
 764:	0141                	addi	sp,sp,16
 766:	8082                	ret

0000000000000768 <strchr>:

char*
strchr(const char *s, char c)
{
 768:	1141                	addi	sp,sp,-16
 76a:	e422                	sd	s0,8(sp)
 76c:	0800                	addi	s0,sp,16
  for(; *s; s++)
 76e:	00054783          	lbu	a5,0(a0)
 772:	cb99                	beqz	a5,788 <strchr+0x20>
    if(*s == c)
 774:	00f58763          	beq	a1,a5,782 <strchr+0x1a>
  for(; *s; s++)
 778:	0505                	addi	a0,a0,1
 77a:	00054783          	lbu	a5,0(a0)
 77e:	fbfd                	bnez	a5,774 <strchr+0xc>
      return (char*)s;
  return 0;
 780:	4501                	li	a0,0
}
 782:	6422                	ld	s0,8(sp)
 784:	0141                	addi	sp,sp,16
 786:	8082                	ret
  return 0;
 788:	4501                	li	a0,0
 78a:	bfe5                	j	782 <strchr+0x1a>

000000000000078c <gets>:

char*
gets(char *buf, int max)
{
 78c:	711d                	addi	sp,sp,-96
 78e:	ec86                	sd	ra,88(sp)
 790:	e8a2                	sd	s0,80(sp)
 792:	e4a6                	sd	s1,72(sp)
 794:	e0ca                	sd	s2,64(sp)
 796:	fc4e                	sd	s3,56(sp)
 798:	f852                	sd	s4,48(sp)
 79a:	f456                	sd	s5,40(sp)
 79c:	f05a                	sd	s6,32(sp)
 79e:	ec5e                	sd	s7,24(sp)
 7a0:	1080                	addi	s0,sp,96
 7a2:	8baa                	mv	s7,a0
 7a4:	8a2e                	mv	s4,a1
  int i, cc;
  char c;

  for(i=0; i+1 < max; ){
 7a6:	892a                	mv	s2,a0
 7a8:	4481                	li	s1,0
    cc = read(0, &c, 1);
    if(cc < 1)
      break;
    buf[i++] = c;
    if(c == '\n' || c == '\r')
 7aa:	4aa9                	li	s5,10
 7ac:	4b35                	li	s6,13
  for(i=0; i+1 < max; ){
 7ae:	89a6                	mv	s3,s1
 7b0:	2485                	addiw	s1,s1,1
 7b2:	0344d863          	bge	s1,s4,7e2 <gets+0x56>
    cc = read(0, &c, 1);
 7b6:	4605                	li	a2,1
 7b8:	faf40593          	addi	a1,s0,-81
 7bc:	4501                	li	a0,0
 7be:	00000097          	auipc	ra,0x0
 7c2:	19c080e7          	jalr	412(ra) # 95a <read>
    if(cc < 1)
 7c6:	00a05e63          	blez	a0,7e2 <gets+0x56>
    buf[i++] = c;
 7ca:	faf44783          	lbu	a5,-81(s0)
 7ce:	00f90023          	sb	a5,0(s2)
    if(c == '\n' || c == '\r')
 7d2:	01578763          	beq	a5,s5,7e0 <gets+0x54>
 7d6:	0905                	addi	s2,s2,1
 7d8:	fd679be3          	bne	a5,s6,7ae <gets+0x22>
  for(i=0; i+1 < max; ){
 7dc:	89a6                	mv	s3,s1
 7de:	a011                	j	7e2 <gets+0x56>
 7e0:	89a6                	mv	s3,s1
      break;
  }
  buf[i] = '\0';
 7e2:	99de                	add	s3,s3,s7
 7e4:	00098023          	sb	zero,0(s3)
  return buf;
}
 7e8:	855e                	mv	a0,s7
 7ea:	60e6                	ld	ra,88(sp)
 7ec:	6446                	ld	s0,80(sp)
 7ee:	64a6                	ld	s1,72(sp)
 7f0:	6906                	ld	s2,64(sp)
 7f2:	79e2                	ld	s3,56(sp)
 7f4:	7a42                	ld	s4,48(sp)
 7f6:	7aa2                	ld	s5,40(sp)
 7f8:	7b02                	ld	s6,32(sp)
 7fa:	6be2                	ld	s7,24(sp)
 7fc:	6125                	addi	sp,sp,96
 7fe:	8082                	ret

0000000000000800 <stat>:

int
stat(const char *n, struct stat *st)
{
 800:	1101                	addi	sp,sp,-32
 802:	ec06                	sd	ra,24(sp)
 804:	e822                	sd	s0,16(sp)
 806:	e426                	sd	s1,8(sp)
 808:	e04a                	sd	s2,0(sp)
 80a:	1000                	addi	s0,sp,32
 80c:	892e                	mv	s2,a1
  int fd;
  int r;

  fd = open(n, O_RDONLY);
 80e:	4581                	li	a1,0
 810:	00000097          	auipc	ra,0x0
 814:	172080e7          	jalr	370(ra) # 982 <open>
  if(fd < 0)
 818:	02054563          	bltz	a0,842 <stat+0x42>
 81c:	84aa                	mv	s1,a0
    return -1;
  r = fstat(fd, st);
 81e:	85ca                	mv	a1,s2
 820:	00000097          	auipc	ra,0x0
 824:	17a080e7          	jalr	378(ra) # 99a <fstat>
 828:	892a                	mv	s2,a0
  close(fd);
 82a:	8526                	mv	a0,s1
 82c:	00000097          	auipc	ra,0x0
 830:	13e080e7          	jalr	318(ra) # 96a <close>
  return r;
}
 834:	854a                	mv	a0,s2
 836:	60e2                	ld	ra,24(sp)
 838:	6442                	ld	s0,16(sp)
 83a:	64a2                	ld	s1,8(sp)
 83c:	6902                	ld	s2,0(sp)
 83e:	6105                	addi	sp,sp,32
 840:	8082                	ret
    return -1;
 842:	597d                	li	s2,-1
 844:	bfc5                	j	834 <stat+0x34>

0000000000000846 <atoi>:

int
atoi(const char *s)
{
 846:	1141                	addi	sp,sp,-16
 848:	e422                	sd	s0,8(sp)
 84a:	0800                	addi	s0,sp,16
  int n;

  n = 0;
  while('0' <= *s && *s <= '9')
 84c:	00054603          	lbu	a2,0(a0)
 850:	fd06079b          	addiw	a5,a2,-48
 854:	0ff7f793          	andi	a5,a5,255
 858:	4725                	li	a4,9
 85a:	02f76963          	bltu	a4,a5,88c <atoi+0x46>
 85e:	86aa                	mv	a3,a0
  n = 0;
 860:	4501                	li	a0,0
  while('0' <= *s && *s <= '9')
 862:	45a5                	li	a1,9
    n = n*10 + *s++ - '0';
 864:	0685                	addi	a3,a3,1
 866:	0025179b          	slliw	a5,a0,0x2
 86a:	9fa9                	addw	a5,a5,a0
 86c:	0017979b          	slliw	a5,a5,0x1
 870:	9fb1                	addw	a5,a5,a2
 872:	fd07851b          	addiw	a0,a5,-48
  while('0' <= *s && *s <= '9')
 876:	0006c603          	lbu	a2,0(a3)
 87a:	fd06071b          	addiw	a4,a2,-48
 87e:	0ff77713          	andi	a4,a4,255
 882:	fee5f1e3          	bgeu	a1,a4,864 <atoi+0x1e>
  return n;
}
 886:	6422                	ld	s0,8(sp)
 888:	0141                	addi	sp,sp,16
 88a:	8082                	ret
  n = 0;
 88c:	4501                	li	a0,0
 88e:	bfe5                	j	886 <atoi+0x40>

0000000000000890 <memmove>:

void*
memmove(void *vdst, const void *vsrc, int n)
{
 890:	1141                	addi	sp,sp,-16
 892:	e422                	sd	s0,8(sp)
 894:	0800                	addi	s0,sp,16
  char *dst;
  const char *src;

  dst = vdst;
  src = vsrc;
  if (src > dst) {
 896:	02b57463          	bgeu	a0,a1,8be <memmove+0x2e>
    while(n-- > 0)
 89a:	00c05f63          	blez	a2,8b8 <memmove+0x28>
 89e:	1602                	slli	a2,a2,0x20
 8a0:	9201                	srli	a2,a2,0x20
 8a2:	00c507b3          	add	a5,a0,a2
  dst = vdst;
 8a6:	872a                	mv	a4,a0
      *dst++ = *src++;
 8a8:	0585                	addi	a1,a1,1
 8aa:	0705                	addi	a4,a4,1
 8ac:	fff5c683          	lbu	a3,-1(a1)
 8b0:	fed70fa3          	sb	a3,-1(a4)
    while(n-- > 0)
 8b4:	fee79ae3          	bne	a5,a4,8a8 <memmove+0x18>
    src += n;
    while(n-- > 0)
      *--dst = *--src;
  }
  return vdst;
}
 8b8:	6422                	ld	s0,8(sp)
 8ba:	0141                	addi	sp,sp,16
 8bc:	8082                	ret
    dst += n;
 8be:	00c50733          	add	a4,a0,a2
    src += n;
 8c2:	95b2                	add	a1,a1,a2
    while(n-- > 0)
 8c4:	fec05ae3          	blez	a2,8b8 <memmove+0x28>
 8c8:	fff6079b          	addiw	a5,a2,-1
 8cc:	1782                	slli	a5,a5,0x20
 8ce:	9381                	srli	a5,a5,0x20
 8d0:	fff7c793          	not	a5,a5
 8d4:	97ba                	add	a5,a5,a4
      *--dst = *--src;
 8d6:	15fd                	addi	a1,a1,-1
 8d8:	177d                	addi	a4,a4,-1
 8da:	0005c683          	lbu	a3,0(a1)
 8de:	00d70023          	sb	a3,0(a4)
    while(n-- > 0)
 8e2:	fee79ae3          	bne	a5,a4,8d6 <memmove+0x46>
 8e6:	bfc9                	j	8b8 <memmove+0x28>

00000000000008e8 <memcmp>:

int
memcmp(const void *s1, const void *s2, uint n)
{
 8e8:	1141                	addi	sp,sp,-16
 8ea:	e422                	sd	s0,8(sp)
 8ec:	0800                	addi	s0,sp,16
  const char *p1 = s1, *p2 = s2;
  while (n-- > 0) {
 8ee:	ca05                	beqz	a2,91e <memcmp+0x36>
 8f0:	fff6069b          	addiw	a3,a2,-1
 8f4:	1682                	slli	a3,a3,0x20
 8f6:	9281                	srli	a3,a3,0x20
 8f8:	0685                	addi	a3,a3,1
 8fa:	96aa                	add	a3,a3,a0
    if (*p1 != *p2) {
 8fc:	00054783          	lbu	a5,0(a0)
 900:	0005c703          	lbu	a4,0(a1)
 904:	00e79863          	bne	a5,a4,914 <memcmp+0x2c>
      return *p1 - *p2;
    }
    p1++;
 908:	0505                	addi	a0,a0,1
    p2++;
 90a:	0585                	addi	a1,a1,1
  while (n-- > 0) {
 90c:	fed518e3          	bne	a0,a3,8fc <memcmp+0x14>
  }
  return 0;
 910:	4501                	li	a0,0
 912:	a019                	j	918 <memcmp+0x30>
      return *p1 - *p2;
 914:	40e7853b          	subw	a0,a5,a4
}
 918:	6422                	ld	s0,8(sp)
 91a:	0141                	addi	sp,sp,16
 91c:	8082                	ret
  return 0;
 91e:	4501                	li	a0,0
 920:	bfe5                	j	918 <memcmp+0x30>

0000000000000922 <memcpy>:

void *
memcpy(void *dst, const void *src, uint n)
{
 922:	1141                	addi	sp,sp,-16
 924:	e406                	sd	ra,8(sp)
 926:	e022                	sd	s0,0(sp)
 928:	0800                	addi	s0,sp,16
  return memmove(dst, src, n);
 92a:	00000097          	auipc	ra,0x0
 92e:	f66080e7          	jalr	-154(ra) # 890 <memmove>
}
 932:	60a2                	ld	ra,8(sp)
 934:	6402                	ld	s0,0(sp)
 936:	0141                	addi	sp,sp,16
 938:	8082                	ret

000000000000093a <fork>:
# generated by usys.pl - do not edit
#include "kernel/syscall.h"
.global fork
fork:
 li a7, SYS_fork
 93a:	4885                	li	a7,1
 ecall
 93c:	00000073          	ecall
 ret
 940:	8082                	ret

0000000000000942 <exit>:
.global exit
exit:
 li a7, SYS_exit
 942:	4889                	li	a7,2
 ecall
 944:	00000073          	ecall
 ret
 948:	8082                	ret

000000000000094a <wait>:
.global wait
wait:
 li a7, SYS_wait
 94a:	488d                	li	a7,3
 ecall
 94c:	00000073          	ecall
 ret
 950:	8082                	ret

0000000000000952 <pipe>:
.global pipe
pipe:
 li a7, SYS_pipe
 952:	4891                	li	a7,4
 ecall
 954:	00000073          	ecall
 ret
 958:	8082                	ret

000000000000095a <read>:
.global read
read:
 li a7, SYS_read
 95a:	4895                	li	a7,5
 ecall
 95c:	00000073          	ecall
 ret
 960:	8082                	ret

0000000000000962 <write>:
.global write
write:
 li a7, SYS_write
 962:	48c1                	li	a7,16
 ecall
 964:	00000073          	ecall
 ret
 968:	8082                	ret

000000000000096a <close>:
.global close
close:
 li a7, SYS_close
 96a:	48d5                	li	a7,21
 ecall
 96c:	00000073          	ecall
 ret
 970:	8082                	ret

0000000000000972 <kill>:
.global kill
kill:
 li a7, SYS_kill
 972:	4899                	li	a7,6
 ecall
 974:	00000073          	ecall
 ret
 978:	8082                	ret

000000000000097a <exec>:
.global exec
exec:
 li a7, SYS_exec
 97a:	489d                	li	a7,7
 ecall
 97c:	00000073          	ecall
 ret
 980:	8082                	ret

0000000000000982 <open>:
.global open
open:
 li a7, SYS_open
 982:	48bd                	li	a7,15
 ecall
 984:	00000073          	ecall
 ret
 988:	8082                	ret

000000000000098a <mknod>:
.global mknod
mknod:
 li a7, SYS_mknod
 98a:	48c5                	li	a7,17
 ecall
 98c:	00000073          	ecall
 ret
 990:	8082                	ret

0000000000000992 <unlink>:
.global unlink
unlink:
 li a7, SYS_unlink
 992:	48c9                	li	a7,18
 ecall
 994:	00000073          	ecall
 ret
 998:	8082                	ret

000000000000099a <fstat>:
.global fstat
fstat:
 li a7, SYS_fstat
 99a:	48a1                	li	a7,8
 ecall
 99c:	00000073          	ecall
 ret
 9a0:	8082                	ret

00000000000009a2 <link>:
.global link
link:
 li a7, SYS_link
 9a2:	48cd                	li	a7,19
 ecall
 9a4:	00000073          	ecall
 ret
 9a8:	8082                	ret

00000000000009aa <mkdir>:
.global mkdir
mkdir:
 li a7, SYS_mkdir
 9aa:	48d1                	li	a7,20
 ecall
 9ac:	00000073          	ecall
 ret
 9b0:	8082                	ret

00000000000009b2 <chdir>:
.global chdir
chdir:
 li a7, SYS_chdir
 9b2:	48a5                	li	a7,9
 ecall
 9b4:	00000073          	ecall
 ret
 9b8:	8082                	ret

00000000000009ba <dup>:
.global dup
dup:
 li a7, SYS_dup
 9ba:	48a9                	li	a7,10
 ecall
 9bc:	00000073          	ecall
 ret
 9c0:	8082                	ret

00000000000009c2 <getpid>:
.global getpid
getpid:
 li a7, SYS_getpid
 9c2:	48ad                	li	a7,11
 ecall
 9c4:	00000073          	ecall
 ret
 9c8:	8082                	ret

00000000000009ca <sbrk>:
.global sbrk
sbrk:
 li a7, SYS_sbrk
 9ca:	48b1                	li	a7,12
 ecall
 9cc:	00000073          	ecall
 ret
 9d0:	8082                	ret

00000000000009d2 <sleep>:
.global sleep
sleep:
 li a7, SYS_sleep
 9d2:	48b5                	li	a7,13
 ecall
 9d4:	00000073          	ecall
 ret
 9d8:	8082                	ret

00000000000009da <uptime>:
.global uptime
uptime:
 li a7, SYS_uptime
 9da:	48b9                	li	a7,14
 ecall
 9dc:	00000073          	ecall
 ret
 9e0:	8082                	ret

00000000000009e2 <symlink>:
.global symlink
symlink:
 li a7, SYS_symlink
 9e2:	48d9                	li	a7,22
 ecall
 9e4:	00000073          	ecall
 ret
 9e8:	8082                	ret

00000000000009ea <putc>:

static char digits[] = "0123456789ABCDEF";

static void
putc(int fd, char c)
{
 9ea:	1101                	addi	sp,sp,-32
 9ec:	ec06                	sd	ra,24(sp)
 9ee:	e822                	sd	s0,16(sp)
 9f0:	1000                	addi	s0,sp,32
 9f2:	feb407a3          	sb	a1,-17(s0)
  write(fd, &c, 1);
 9f6:	4605                	li	a2,1
 9f8:	fef40593          	addi	a1,s0,-17
 9fc:	00000097          	auipc	ra,0x0
 a00:	f66080e7          	jalr	-154(ra) # 962 <write>
}
 a04:	60e2                	ld	ra,24(sp)
 a06:	6442                	ld	s0,16(sp)
 a08:	6105                	addi	sp,sp,32
 a0a:	8082                	ret

0000000000000a0c <printint>:

static void
printint(int fd, int xx, int base, int sgn)
{
 a0c:	7139                	addi	sp,sp,-64
 a0e:	fc06                	sd	ra,56(sp)
 a10:	f822                	sd	s0,48(sp)
 a12:	f426                	sd	s1,40(sp)
 a14:	f04a                	sd	s2,32(sp)
 a16:	ec4e                	sd	s3,24(sp)
 a18:	0080                	addi	s0,sp,64
 a1a:	84aa                	mv	s1,a0
  char buf[16];
  int i, neg;
  uint x;

  neg = 0;
  if(sgn && xx < 0){
 a1c:	c299                	beqz	a3,a22 <printint+0x16>
 a1e:	0805c863          	bltz	a1,aae <printint+0xa2>
    neg = 1;
    x = -xx;
  } else {
    x = xx;
 a22:	2581                	sext.w	a1,a1
  neg = 0;
 a24:	4881                	li	a7,0
 a26:	fc040693          	addi	a3,s0,-64
  }

  i = 0;
 a2a:	4701                	li	a4,0
  do{
    buf[i++] = digits[x % base];
 a2c:	2601                	sext.w	a2,a2
 a2e:	00001517          	auipc	a0,0x1
 a32:	8da50513          	addi	a0,a0,-1830 # 1308 <digits>
 a36:	883a                	mv	a6,a4
 a38:	2705                	addiw	a4,a4,1
 a3a:	02c5f7bb          	remuw	a5,a1,a2
 a3e:	1782                	slli	a5,a5,0x20
 a40:	9381                	srli	a5,a5,0x20
 a42:	97aa                	add	a5,a5,a0
 a44:	0007c783          	lbu	a5,0(a5)
 a48:	00f68023          	sb	a5,0(a3)
  }while((x /= base) != 0);
 a4c:	0005879b          	sext.w	a5,a1
 a50:	02c5d5bb          	divuw	a1,a1,a2
 a54:	0685                	addi	a3,a3,1
 a56:	fec7f0e3          	bgeu	a5,a2,a36 <printint+0x2a>
  if(neg)
 a5a:	00088b63          	beqz	a7,a70 <printint+0x64>
    buf[i++] = '-';
 a5e:	fd040793          	addi	a5,s0,-48
 a62:	973e                	add	a4,a4,a5
 a64:	02d00793          	li	a5,45
 a68:	fef70823          	sb	a5,-16(a4)
 a6c:	0028071b          	addiw	a4,a6,2

  while(--i >= 0)
 a70:	02e05863          	blez	a4,aa0 <printint+0x94>
 a74:	fc040793          	addi	a5,s0,-64
 a78:	00e78933          	add	s2,a5,a4
 a7c:	fff78993          	addi	s3,a5,-1
 a80:	99ba                	add	s3,s3,a4
 a82:	377d                	addiw	a4,a4,-1
 a84:	1702                	slli	a4,a4,0x20
 a86:	9301                	srli	a4,a4,0x20
 a88:	40e989b3          	sub	s3,s3,a4
    putc(fd, buf[i]);
 a8c:	fff94583          	lbu	a1,-1(s2)
 a90:	8526                	mv	a0,s1
 a92:	00000097          	auipc	ra,0x0
 a96:	f58080e7          	jalr	-168(ra) # 9ea <putc>
  while(--i >= 0)
 a9a:	197d                	addi	s2,s2,-1
 a9c:	ff3918e3          	bne	s2,s3,a8c <printint+0x80>
}
 aa0:	70e2                	ld	ra,56(sp)
 aa2:	7442                	ld	s0,48(sp)
 aa4:	74a2                	ld	s1,40(sp)
 aa6:	7902                	ld	s2,32(sp)
 aa8:	69e2                	ld	s3,24(sp)
 aaa:	6121                	addi	sp,sp,64
 aac:	8082                	ret
    x = -xx;
 aae:	40b005bb          	negw	a1,a1
    neg = 1;
 ab2:	4885                	li	a7,1
    x = -xx;
 ab4:	bf8d                	j	a26 <printint+0x1a>

0000000000000ab6 <vprintf>:
}

// Print to the given fd. Only understands %d, %x, %p, %s.
void
vprintf(int fd, const char *fmt, va_list ap)
{
 ab6:	7119                	addi	sp,sp,-128
 ab8:	fc86                	sd	ra,120(sp)
 aba:	f8a2                	sd	s0,112(sp)
 abc:	f4a6                	sd	s1,104(sp)
 abe:	f0ca                	sd	s2,96(sp)
 ac0:	ecce                	sd	s3,88(sp)
 ac2:	e8d2                	sd	s4,80(sp)
 ac4:	e4d6                	sd	s5,72(sp)
 ac6:	e0da                	sd	s6,64(sp)
 ac8:	fc5e                	sd	s7,56(sp)
 aca:	f862                	sd	s8,48(sp)
 acc:	f466                	sd	s9,40(sp)
 ace:	f06a                	sd	s10,32(sp)
 ad0:	ec6e                	sd	s11,24(sp)
 ad2:	0100                	addi	s0,sp,128
  char *s;
  int c, i, state;

  state = 0;
  for(i = 0; fmt[i]; i++){
 ad4:	0005c903          	lbu	s2,0(a1)
 ad8:	18090f63          	beqz	s2,c76 <vprintf+0x1c0>
 adc:	8aaa                	mv	s5,a0
 ade:	8b32                	mv	s6,a2
 ae0:	00158493          	addi	s1,a1,1
  state = 0;
 ae4:	4981                	li	s3,0
      if(c == '%'){
        state = '%';
      } else {
        putc(fd, c);
      }
    } else if(state == '%'){
 ae6:	02500a13          	li	s4,37
      if(c == 'd'){
 aea:	06400c13          	li	s8,100
        printint(fd, va_arg(ap, int), 10, 1);
      } else if(c == 'l') {
 aee:	06c00c93          	li	s9,108
        printint(fd, va_arg(ap, uint64), 10, 0);
      } else if(c == 'x') {
 af2:	07800d13          	li	s10,120
        printint(fd, va_arg(ap, int), 16, 0);
      } else if(c == 'p') {
 af6:	07000d93          	li	s11,112
    putc(fd, digits[x >> (sizeof(uint64) * 8 - 4)]);
 afa:	00001b97          	auipc	s7,0x1
 afe:	80eb8b93          	addi	s7,s7,-2034 # 1308 <digits>
 b02:	a839                	j	b20 <vprintf+0x6a>
        putc(fd, c);
 b04:	85ca                	mv	a1,s2
 b06:	8556                	mv	a0,s5
 b08:	00000097          	auipc	ra,0x0
 b0c:	ee2080e7          	jalr	-286(ra) # 9ea <putc>
 b10:	a019                	j	b16 <vprintf+0x60>
    } else if(state == '%'){
 b12:	01498f63          	beq	s3,s4,b30 <vprintf+0x7a>
  for(i = 0; fmt[i]; i++){
 b16:	0485                	addi	s1,s1,1
 b18:	fff4c903          	lbu	s2,-1(s1)
 b1c:	14090d63          	beqz	s2,c76 <vprintf+0x1c0>
    c = fmt[i] & 0xff;
 b20:	0009079b          	sext.w	a5,s2
    if(state == 0){
 b24:	fe0997e3          	bnez	s3,b12 <vprintf+0x5c>
      if(c == '%'){
 b28:	fd479ee3          	bne	a5,s4,b04 <vprintf+0x4e>
        state = '%';
 b2c:	89be                	mv	s3,a5
 b2e:	b7e5                	j	b16 <vprintf+0x60>
      if(c == 'd'){
 b30:	05878063          	beq	a5,s8,b70 <vprintf+0xba>
      } else if(c == 'l') {
 b34:	05978c63          	beq	a5,s9,b8c <vprintf+0xd6>
      } else if(c == 'x') {
 b38:	07a78863          	beq	a5,s10,ba8 <vprintf+0xf2>
      } else if(c == 'p') {
 b3c:	09b78463          	beq	a5,s11,bc4 <vprintf+0x10e>
        printptr(fd, va_arg(ap, uint64));
      } else if(c == 's'){
 b40:	07300713          	li	a4,115
 b44:	0ce78663          	beq	a5,a4,c10 <vprintf+0x15a>
          s = "(null)";
        while(*s != 0){
          putc(fd, *s);
          s++;
        }
      } else if(c == 'c'){
 b48:	06300713          	li	a4,99
 b4c:	0ee78e63          	beq	a5,a4,c48 <vprintf+0x192>
        putc(fd, va_arg(ap, uint));
      } else if(c == '%'){
 b50:	11478863          	beq	a5,s4,c60 <vprintf+0x1aa>
        putc(fd, c);
      } else {
        // Unknown % sequence.  Print it to draw attention.
        putc(fd, '%');
 b54:	85d2                	mv	a1,s4
 b56:	8556                	mv	a0,s5
 b58:	00000097          	auipc	ra,0x0
 b5c:	e92080e7          	jalr	-366(ra) # 9ea <putc>
        putc(fd, c);
 b60:	85ca                	mv	a1,s2
 b62:	8556                	mv	a0,s5
 b64:	00000097          	auipc	ra,0x0
 b68:	e86080e7          	jalr	-378(ra) # 9ea <putc>
      }
      state = 0;
 b6c:	4981                	li	s3,0
 b6e:	b765                	j	b16 <vprintf+0x60>
        printint(fd, va_arg(ap, int), 10, 1);
 b70:	008b0913          	addi	s2,s6,8
 b74:	4685                	li	a3,1
 b76:	4629                	li	a2,10
 b78:	000b2583          	lw	a1,0(s6)
 b7c:	8556                	mv	a0,s5
 b7e:	00000097          	auipc	ra,0x0
 b82:	e8e080e7          	jalr	-370(ra) # a0c <printint>
 b86:	8b4a                	mv	s6,s2
      state = 0;
 b88:	4981                	li	s3,0
 b8a:	b771                	j	b16 <vprintf+0x60>
        printint(fd, va_arg(ap, uint64), 10, 0);
 b8c:	008b0913          	addi	s2,s6,8
 b90:	4681                	li	a3,0
 b92:	4629                	li	a2,10
 b94:	000b2583          	lw	a1,0(s6)
 b98:	8556                	mv	a0,s5
 b9a:	00000097          	auipc	ra,0x0
 b9e:	e72080e7          	jalr	-398(ra) # a0c <printint>
 ba2:	8b4a                	mv	s6,s2
      state = 0;
 ba4:	4981                	li	s3,0
 ba6:	bf85                	j	b16 <vprintf+0x60>
        printint(fd, va_arg(ap, int), 16, 0);
 ba8:	008b0913          	addi	s2,s6,8
 bac:	4681                	li	a3,0
 bae:	4641                	li	a2,16
 bb0:	000b2583          	lw	a1,0(s6)
 bb4:	8556                	mv	a0,s5
 bb6:	00000097          	auipc	ra,0x0
 bba:	e56080e7          	jalr	-426(ra) # a0c <printint>
 bbe:	8b4a                	mv	s6,s2
      state = 0;
 bc0:	4981                	li	s3,0
 bc2:	bf91                	j	b16 <vprintf+0x60>
        printptr(fd, va_arg(ap, uint64));
 bc4:	008b0793          	addi	a5,s6,8
 bc8:	f8f43423          	sd	a5,-120(s0)
 bcc:	000b3983          	ld	s3,0(s6)
  putc(fd, '0');
 bd0:	03000593          	li	a1,48
 bd4:	8556                	mv	a0,s5
 bd6:	00000097          	auipc	ra,0x0
 bda:	e14080e7          	jalr	-492(ra) # 9ea <putc>
  putc(fd, 'x');
 bde:	85ea                	mv	a1,s10
 be0:	8556                	mv	a0,s5
 be2:	00000097          	auipc	ra,0x0
 be6:	e08080e7          	jalr	-504(ra) # 9ea <putc>
 bea:	4941                	li	s2,16
    putc(fd, digits[x >> (sizeof(uint64) * 8 - 4)]);
 bec:	03c9d793          	srli	a5,s3,0x3c
 bf0:	97de                	add	a5,a5,s7
 bf2:	0007c583          	lbu	a1,0(a5)
 bf6:	8556                	mv	a0,s5
 bf8:	00000097          	auipc	ra,0x0
 bfc:	df2080e7          	jalr	-526(ra) # 9ea <putc>
  for (i = 0; i < (sizeof(uint64) * 2); i++, x <<= 4)
 c00:	0992                	slli	s3,s3,0x4
 c02:	397d                	addiw	s2,s2,-1
 c04:	fe0914e3          	bnez	s2,bec <vprintf+0x136>
        printptr(fd, va_arg(ap, uint64));
 c08:	f8843b03          	ld	s6,-120(s0)
      state = 0;
 c0c:	4981                	li	s3,0
 c0e:	b721                	j	b16 <vprintf+0x60>
        s = va_arg(ap, char*);
 c10:	008b0993          	addi	s3,s6,8
 c14:	000b3903          	ld	s2,0(s6)
        if(s == 0)
 c18:	02090163          	beqz	s2,c3a <vprintf+0x184>
        while(*s != 0){
 c1c:	00094583          	lbu	a1,0(s2)
 c20:	c9a1                	beqz	a1,c70 <vprintf+0x1ba>
          putc(fd, *s);
 c22:	8556                	mv	a0,s5
 c24:	00000097          	auipc	ra,0x0
 c28:	dc6080e7          	jalr	-570(ra) # 9ea <putc>
          s++;
 c2c:	0905                	addi	s2,s2,1
        while(*s != 0){
 c2e:	00094583          	lbu	a1,0(s2)
 c32:	f9e5                	bnez	a1,c22 <vprintf+0x16c>
        s = va_arg(ap, char*);
 c34:	8b4e                	mv	s6,s3
      state = 0;
 c36:	4981                	li	s3,0
 c38:	bdf9                	j	b16 <vprintf+0x60>
          s = "(null)";
 c3a:	00000917          	auipc	s2,0x0
 c3e:	6c690913          	addi	s2,s2,1734 # 1300 <malloc+0x580>
        while(*s != 0){
 c42:	02800593          	li	a1,40
 c46:	bff1                	j	c22 <vprintf+0x16c>
        putc(fd, va_arg(ap, uint));
 c48:	008b0913          	addi	s2,s6,8
 c4c:	000b4583          	lbu	a1,0(s6)
 c50:	8556                	mv	a0,s5
 c52:	00000097          	auipc	ra,0x0
 c56:	d98080e7          	jalr	-616(ra) # 9ea <putc>
 c5a:	8b4a                	mv	s6,s2
      state = 0;
 c5c:	4981                	li	s3,0
 c5e:	bd65                	j	b16 <vprintf+0x60>
        putc(fd, c);
 c60:	85d2                	mv	a1,s4
 c62:	8556                	mv	a0,s5
 c64:	00000097          	auipc	ra,0x0
 c68:	d86080e7          	jalr	-634(ra) # 9ea <putc>
      state = 0;
 c6c:	4981                	li	s3,0
 c6e:	b565                	j	b16 <vprintf+0x60>
        s = va_arg(ap, char*);
 c70:	8b4e                	mv	s6,s3
      state = 0;
 c72:	4981                	li	s3,0
 c74:	b54d                	j	b16 <vprintf+0x60>
    }
  }
}
 c76:	70e6                	ld	ra,120(sp)
 c78:	7446                	ld	s0,112(sp)
 c7a:	74a6                	ld	s1,104(sp)
 c7c:	7906                	ld	s2,96(sp)
 c7e:	69e6                	ld	s3,88(sp)
 c80:	6a46                	ld	s4,80(sp)
 c82:	6aa6                	ld	s5,72(sp)
 c84:	6b06                	ld	s6,64(sp)
 c86:	7be2                	ld	s7,56(sp)
 c88:	7c42                	ld	s8,48(sp)
 c8a:	7ca2                	ld	s9,40(sp)
 c8c:	7d02                	ld	s10,32(sp)
 c8e:	6de2                	ld	s11,24(sp)
 c90:	6109                	addi	sp,sp,128
 c92:	8082                	ret

0000000000000c94 <fprintf>:

void
fprintf(int fd, const char *fmt, ...)
{
 c94:	715d                	addi	sp,sp,-80
 c96:	ec06                	sd	ra,24(sp)
 c98:	e822                	sd	s0,16(sp)
 c9a:	1000                	addi	s0,sp,32
 c9c:	e010                	sd	a2,0(s0)
 c9e:	e414                	sd	a3,8(s0)
 ca0:	e818                	sd	a4,16(s0)
 ca2:	ec1c                	sd	a5,24(s0)
 ca4:	03043023          	sd	a6,32(s0)
 ca8:	03143423          	sd	a7,40(s0)
  va_list ap;

  va_start(ap, fmt);
 cac:	fe843423          	sd	s0,-24(s0)
  vprintf(fd, fmt, ap);
 cb0:	8622                	mv	a2,s0
 cb2:	00000097          	auipc	ra,0x0
 cb6:	e04080e7          	jalr	-508(ra) # ab6 <vprintf>
}
 cba:	60e2                	ld	ra,24(sp)
 cbc:	6442                	ld	s0,16(sp)
 cbe:	6161                	addi	sp,sp,80
 cc0:	8082                	ret

0000000000000cc2 <printf>:

void
printf(const char *fmt, ...)
{
 cc2:	711d                	addi	sp,sp,-96
 cc4:	ec06                	sd	ra,24(sp)
 cc6:	e822                	sd	s0,16(sp)
 cc8:	1000                	addi	s0,sp,32
 cca:	e40c                	sd	a1,8(s0)
 ccc:	e810                	sd	a2,16(s0)
 cce:	ec14                	sd	a3,24(s0)
 cd0:	f018                	sd	a4,32(s0)
 cd2:	f41c                	sd	a5,40(s0)
 cd4:	03043823          	sd	a6,48(s0)
 cd8:	03143c23          	sd	a7,56(s0)
  va_list ap;

  va_start(ap, fmt);
 cdc:	00840613          	addi	a2,s0,8
 ce0:	fec43423          	sd	a2,-24(s0)
  vprintf(1, fmt, ap);
 ce4:	85aa                	mv	a1,a0
 ce6:	4505                	li	a0,1
 ce8:	00000097          	auipc	ra,0x0
 cec:	dce080e7          	jalr	-562(ra) # ab6 <vprintf>
}
 cf0:	60e2                	ld	ra,24(sp)
 cf2:	6442                	ld	s0,16(sp)
 cf4:	6125                	addi	sp,sp,96
 cf6:	8082                	ret

0000000000000cf8 <free>:
static Header base;
static Header *freep;

void
free(void *ap)
{
 cf8:	1141                	addi	sp,sp,-16
 cfa:	e422                	sd	s0,8(sp)
 cfc:	0800                	addi	s0,sp,16
  Header *bp, *p;

  bp = (Header*)ap - 1;
 cfe:	ff050693          	addi	a3,a0,-16
  for(p = freep; !(bp > p && bp < p->s.ptr); p = p->s.ptr)
 d02:	00000797          	auipc	a5,0x0
 d06:	6267b783          	ld	a5,1574(a5) # 1328 <freep>
 d0a:	a805                	j	d3a <free+0x42>
    if(p >= p->s.ptr && (bp > p || bp < p->s.ptr))
      break;
  if(bp + bp->s.size == p->s.ptr){
    bp->s.size += p->s.ptr->s.size;
 d0c:	4618                	lw	a4,8(a2)
 d0e:	9db9                	addw	a1,a1,a4
 d10:	feb52c23          	sw	a1,-8(a0)
    bp->s.ptr = p->s.ptr->s.ptr;
 d14:	6398                	ld	a4,0(a5)
 d16:	6318                	ld	a4,0(a4)
 d18:	fee53823          	sd	a4,-16(a0)
 d1c:	a091                	j	d60 <free+0x68>
  } else
    bp->s.ptr = p->s.ptr;
  if(p + p->s.size == bp){
    p->s.size += bp->s.size;
 d1e:	ff852703          	lw	a4,-8(a0)
 d22:	9e39                	addw	a2,a2,a4
 d24:	c790                	sw	a2,8(a5)
    p->s.ptr = bp->s.ptr;
 d26:	ff053703          	ld	a4,-16(a0)
 d2a:	e398                	sd	a4,0(a5)
 d2c:	a099                	j	d72 <free+0x7a>
    if(p >= p->s.ptr && (bp > p || bp < p->s.ptr))
 d2e:	6398                	ld	a4,0(a5)
 d30:	00e7e463          	bltu	a5,a4,d38 <free+0x40>
 d34:	00e6ea63          	bltu	a3,a4,d48 <free+0x50>
{
 d38:	87ba                	mv	a5,a4
  for(p = freep; !(bp > p && bp < p->s.ptr); p = p->s.ptr)
 d3a:	fed7fae3          	bgeu	a5,a3,d2e <free+0x36>
 d3e:	6398                	ld	a4,0(a5)
 d40:	00e6e463          	bltu	a3,a4,d48 <free+0x50>
    if(p >= p->s.ptr && (bp > p || bp < p->s.ptr))
 d44:	fee7eae3          	bltu	a5,a4,d38 <free+0x40>
  if(bp + bp->s.size == p->s.ptr){
 d48:	ff852583          	lw	a1,-8(a0)
 d4c:	6390                	ld	a2,0(a5)
 d4e:	02059713          	slli	a4,a1,0x20
 d52:	9301                	srli	a4,a4,0x20
 d54:	0712                	slli	a4,a4,0x4
 d56:	9736                	add	a4,a4,a3
 d58:	fae60ae3          	beq	a2,a4,d0c <free+0x14>
    bp->s.ptr = p->s.ptr;
 d5c:	fec53823          	sd	a2,-16(a0)
  if(p + p->s.size == bp){
 d60:	4790                	lw	a2,8(a5)
 d62:	02061713          	slli	a4,a2,0x20
 d66:	9301                	srli	a4,a4,0x20
 d68:	0712                	slli	a4,a4,0x4
 d6a:	973e                	add	a4,a4,a5
 d6c:	fae689e3          	beq	a3,a4,d1e <free+0x26>
  } else
    p->s.ptr = bp;
 d70:	e394                	sd	a3,0(a5)
  freep = p;
 d72:	00000717          	auipc	a4,0x0
 d76:	5af73b23          	sd	a5,1462(a4) # 1328 <freep>
}
 d7a:	6422                	ld	s0,8(sp)
 d7c:	0141                	addi	sp,sp,16
 d7e:	8082                	ret

0000000000000d80 <malloc>:
  return freep;
}

void*
malloc(uint nbytes)
{
 d80:	7139                	addi	sp,sp,-64
 d82:	fc06                	sd	ra,56(sp)
 d84:	f822                	sd	s0,48(sp)
 d86:	f426                	sd	s1,40(sp)
 d88:	f04a                	sd	s2,32(sp)
 d8a:	ec4e                	sd	s3,24(sp)
 d8c:	e852                	sd	s4,16(sp)
 d8e:	e456                	sd	s5,8(sp)
 d90:	e05a                	sd	s6,0(sp)
 d92:	0080                	addi	s0,sp,64
  Header *p, *prevp;
  uint nunits;

  nunits = (nbytes + sizeof(Header) - 1)/sizeof(Header) + 1;
 d94:	02051493          	slli	s1,a0,0x20
 d98:	9081                	srli	s1,s1,0x20
 d9a:	04bd                	addi	s1,s1,15
 d9c:	8091                	srli	s1,s1,0x4
 d9e:	0014899b          	addiw	s3,s1,1
 da2:	0485                	addi	s1,s1,1
  if((prevp = freep) == 0){
 da4:	00000517          	auipc	a0,0x0
 da8:	58453503          	ld	a0,1412(a0) # 1328 <freep>
 dac:	c515                	beqz	a0,dd8 <malloc+0x58>
    base.s.ptr = freep = prevp = &base;
    base.s.size = 0;
  }
  for(p = prevp->s.ptr; ; prevp = p, p = p->s.ptr){
 dae:	611c                	ld	a5,0(a0)
    if(p->s.size >= nunits){
 db0:	4798                	lw	a4,8(a5)
 db2:	02977f63          	bgeu	a4,s1,df0 <malloc+0x70>
 db6:	8a4e                	mv	s4,s3
 db8:	0009871b          	sext.w	a4,s3
 dbc:	6685                	lui	a3,0x1
 dbe:	00d77363          	bgeu	a4,a3,dc4 <malloc+0x44>
 dc2:	6a05                	lui	s4,0x1
 dc4:	000a0b1b          	sext.w	s6,s4
  p = sbrk(nu * sizeof(Header));
 dc8:	004a1a1b          	slliw	s4,s4,0x4
        p->s.size = nunits;
      }
      freep = prevp;
      return (void*)(p + 1);
    }
    if(p == freep)
 dcc:	00000917          	auipc	s2,0x0
 dd0:	55c90913          	addi	s2,s2,1372 # 1328 <freep>
  if(p == (char*)-1)
 dd4:	5afd                	li	s5,-1
 dd6:	a88d                	j	e48 <malloc+0xc8>
    base.s.ptr = freep = prevp = &base;
 dd8:	00000797          	auipc	a5,0x0
 ddc:	55878793          	addi	a5,a5,1368 # 1330 <base>
 de0:	00000717          	auipc	a4,0x0
 de4:	54f73423          	sd	a5,1352(a4) # 1328 <freep>
 de8:	e39c                	sd	a5,0(a5)
    base.s.size = 0;
 dea:	0007a423          	sw	zero,8(a5)
    if(p->s.size >= nunits){
 dee:	b7e1                	j	db6 <malloc+0x36>
      if(p->s.size == nunits)
 df0:	02e48b63          	beq	s1,a4,e26 <malloc+0xa6>
        p->s.size -= nunits;
 df4:	4137073b          	subw	a4,a4,s3
 df8:	c798                	sw	a4,8(a5)
        p += p->s.size;
 dfa:	1702                	slli	a4,a4,0x20
 dfc:	9301                	srli	a4,a4,0x20
 dfe:	0712                	slli	a4,a4,0x4
 e00:	97ba                	add	a5,a5,a4
        p->s.size = nunits;
 e02:	0137a423          	sw	s3,8(a5)
      freep = prevp;
 e06:	00000717          	auipc	a4,0x0
 e0a:	52a73123          	sd	a0,1314(a4) # 1328 <freep>
      return (void*)(p + 1);
 e0e:	01078513          	addi	a0,a5,16
      if((p = morecore(nunits)) == 0)
        return 0;
  }
}
 e12:	70e2                	ld	ra,56(sp)
 e14:	7442                	ld	s0,48(sp)
 e16:	74a2                	ld	s1,40(sp)
 e18:	7902                	ld	s2,32(sp)
 e1a:	69e2                	ld	s3,24(sp)
 e1c:	6a42                	ld	s4,16(sp)
 e1e:	6aa2                	ld	s5,8(sp)
 e20:	6b02                	ld	s6,0(sp)
 e22:	6121                	addi	sp,sp,64
 e24:	8082                	ret
        prevp->s.ptr = p->s.ptr;
 e26:	6398                	ld	a4,0(a5)
 e28:	e118                	sd	a4,0(a0)
 e2a:	bff1                	j	e06 <malloc+0x86>
  hp->s.size = nu;
 e2c:	01652423          	sw	s6,8(a0)
  free((void*)(hp + 1));
 e30:	0541                	addi	a0,a0,16
 e32:	00000097          	auipc	ra,0x0
 e36:	ec6080e7          	jalr	-314(ra) # cf8 <free>
  return freep;
 e3a:	00093503          	ld	a0,0(s2)
      if((p = morecore(nunits)) == 0)
 e3e:	d971                	beqz	a0,e12 <malloc+0x92>
  for(p = prevp->s.ptr; ; prevp = p, p = p->s.ptr){
 e40:	611c                	ld	a5,0(a0)
    if(p->s.size >= nunits){
 e42:	4798                	lw	a4,8(a5)
 e44:	fa9776e3          	bgeu	a4,s1,df0 <malloc+0x70>
    if(p == freep)
 e48:	00093703          	ld	a4,0(s2)
 e4c:	853e                	mv	a0,a5
 e4e:	fef719e3          	bne	a4,a5,e40 <malloc+0xc0>
  p = sbrk(nu * sizeof(Header));
 e52:	8552                	mv	a0,s4
 e54:	00000097          	auipc	ra,0x0
 e58:	b76080e7          	jalr	-1162(ra) # 9ca <sbrk>
  if(p == (char*)-1)
 e5c:	fd5518e3          	bne	a0,s5,e2c <malloc+0xac>
        return 0;
 e60:	4501                	li	a0,0
 e62:	bf45                	j	e12 <malloc+0x92>
