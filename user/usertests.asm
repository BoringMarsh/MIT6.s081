
user/_usertests:     file format elf64-littleriscv


Disassembly of section .text:

0000000000000000 <copyinstr1>:
}

// what if you pass ridiculous string pointers to system calls?
void
copyinstr1(char *s)
{
       0:	1141                	addi	sp,sp,-16
       2:	e406                	sd	ra,8(sp)
       4:	e022                	sd	s0,0(sp)
       6:	0800                	addi	s0,sp,16
  uint64 addrs[] = { 0x80000000LL, 0xffffffffffffffff };

  for(int ai = 0; ai < 2; ai++){
    uint64 addr = addrs[ai];

    int fd = open((char *)addr, O_CREATE|O_WRONLY);
       8:	20100593          	li	a1,513
       c:	4505                	li	a0,1
       e:	057e                	slli	a0,a0,0x1f
      10:	00005097          	auipc	ra,0x5
      14:	63e080e7          	jalr	1598(ra) # 564e <open>
    if(fd >= 0){
      18:	02055063          	bgez	a0,38 <copyinstr1+0x38>
    int fd = open((char *)addr, O_CREATE|O_WRONLY);
      1c:	20100593          	li	a1,513
      20:	557d                	li	a0,-1
      22:	00005097          	auipc	ra,0x5
      26:	62c080e7          	jalr	1580(ra) # 564e <open>
    uint64 addr = addrs[ai];
      2a:	55fd                	li	a1,-1
    if(fd >= 0){
      2c:	00055863          	bgez	a0,3c <copyinstr1+0x3c>
      printf("open(%p) returned %d, not -1\n", addr, fd);
      exit(1);
    }
  }
}
      30:	60a2                	ld	ra,8(sp)
      32:	6402                	ld	s0,0(sp)
      34:	0141                	addi	sp,sp,16
      36:	8082                	ret
    uint64 addr = addrs[ai];
      38:	4585                	li	a1,1
      3a:	05fe                	slli	a1,a1,0x1f
      printf("open(%p) returned %d, not -1\n", addr, fd);
      3c:	862a                	mv	a2,a0
      3e:	00006517          	auipc	a0,0x6
      42:	e1250513          	addi	a0,a0,-494 # 5e50 <malloc+0x404>
      46:	00006097          	auipc	ra,0x6
      4a:	948080e7          	jalr	-1720(ra) # 598e <printf>
      exit(1);
      4e:	4505                	li	a0,1
      50:	00005097          	auipc	ra,0x5
      54:	5be080e7          	jalr	1470(ra) # 560e <exit>

0000000000000058 <bsstest>:
void
bsstest(char *s)
{
  int i;

  for(i = 0; i < sizeof(uninit); i++){
      58:	00009797          	auipc	a5,0x9
      5c:	33878793          	addi	a5,a5,824 # 9390 <uninit>
      60:	0000c697          	auipc	a3,0xc
      64:	a4068693          	addi	a3,a3,-1472 # baa0 <buf>
    if(uninit[i] != '\0'){
      68:	0007c703          	lbu	a4,0(a5)
      6c:	e709                	bnez	a4,76 <bsstest+0x1e>
  for(i = 0; i < sizeof(uninit); i++){
      6e:	0785                	addi	a5,a5,1
      70:	fed79ce3          	bne	a5,a3,68 <bsstest+0x10>
      74:	8082                	ret
{
      76:	1141                	addi	sp,sp,-16
      78:	e406                	sd	ra,8(sp)
      7a:	e022                	sd	s0,0(sp)
      7c:	0800                	addi	s0,sp,16
      printf("%s: bss test failed\n", s);
      7e:	85aa                	mv	a1,a0
      80:	00006517          	auipc	a0,0x6
      84:	df050513          	addi	a0,a0,-528 # 5e70 <malloc+0x424>
      88:	00006097          	auipc	ra,0x6
      8c:	906080e7          	jalr	-1786(ra) # 598e <printf>
      exit(1);
      90:	4505                	li	a0,1
      92:	00005097          	auipc	ra,0x5
      96:	57c080e7          	jalr	1404(ra) # 560e <exit>

000000000000009a <opentest>:
{
      9a:	1101                	addi	sp,sp,-32
      9c:	ec06                	sd	ra,24(sp)
      9e:	e822                	sd	s0,16(sp)
      a0:	e426                	sd	s1,8(sp)
      a2:	1000                	addi	s0,sp,32
      a4:	84aa                	mv	s1,a0
  fd = open("echo", 0);
      a6:	4581                	li	a1,0
      a8:	00006517          	auipc	a0,0x6
      ac:	de050513          	addi	a0,a0,-544 # 5e88 <malloc+0x43c>
      b0:	00005097          	auipc	ra,0x5
      b4:	59e080e7          	jalr	1438(ra) # 564e <open>
  if(fd < 0){
      b8:	02054663          	bltz	a0,e4 <opentest+0x4a>
  close(fd);
      bc:	00005097          	auipc	ra,0x5
      c0:	57a080e7          	jalr	1402(ra) # 5636 <close>
  fd = open("doesnotexist", 0);
      c4:	4581                	li	a1,0
      c6:	00006517          	auipc	a0,0x6
      ca:	de250513          	addi	a0,a0,-542 # 5ea8 <malloc+0x45c>
      ce:	00005097          	auipc	ra,0x5
      d2:	580080e7          	jalr	1408(ra) # 564e <open>
  if(fd >= 0){
      d6:	02055563          	bgez	a0,100 <opentest+0x66>
}
      da:	60e2                	ld	ra,24(sp)
      dc:	6442                	ld	s0,16(sp)
      de:	64a2                	ld	s1,8(sp)
      e0:	6105                	addi	sp,sp,32
      e2:	8082                	ret
    printf("%s: open echo failed!\n", s);
      e4:	85a6                	mv	a1,s1
      e6:	00006517          	auipc	a0,0x6
      ea:	daa50513          	addi	a0,a0,-598 # 5e90 <malloc+0x444>
      ee:	00006097          	auipc	ra,0x6
      f2:	8a0080e7          	jalr	-1888(ra) # 598e <printf>
    exit(1);
      f6:	4505                	li	a0,1
      f8:	00005097          	auipc	ra,0x5
      fc:	516080e7          	jalr	1302(ra) # 560e <exit>
    printf("%s: open doesnotexist succeeded!\n", s);
     100:	85a6                	mv	a1,s1
     102:	00006517          	auipc	a0,0x6
     106:	db650513          	addi	a0,a0,-586 # 5eb8 <malloc+0x46c>
     10a:	00006097          	auipc	ra,0x6
     10e:	884080e7          	jalr	-1916(ra) # 598e <printf>
    exit(1);
     112:	4505                	li	a0,1
     114:	00005097          	auipc	ra,0x5
     118:	4fa080e7          	jalr	1274(ra) # 560e <exit>

000000000000011c <truncate2>:
{
     11c:	7179                	addi	sp,sp,-48
     11e:	f406                	sd	ra,40(sp)
     120:	f022                	sd	s0,32(sp)
     122:	ec26                	sd	s1,24(sp)
     124:	e84a                	sd	s2,16(sp)
     126:	e44e                	sd	s3,8(sp)
     128:	1800                	addi	s0,sp,48
     12a:	89aa                	mv	s3,a0
  unlink("truncfile");
     12c:	00006517          	auipc	a0,0x6
     130:	db450513          	addi	a0,a0,-588 # 5ee0 <malloc+0x494>
     134:	00005097          	auipc	ra,0x5
     138:	52a080e7          	jalr	1322(ra) # 565e <unlink>
  int fd1 = open("truncfile", O_CREATE|O_TRUNC|O_WRONLY);
     13c:	60100593          	li	a1,1537
     140:	00006517          	auipc	a0,0x6
     144:	da050513          	addi	a0,a0,-608 # 5ee0 <malloc+0x494>
     148:	00005097          	auipc	ra,0x5
     14c:	506080e7          	jalr	1286(ra) # 564e <open>
     150:	84aa                	mv	s1,a0
  write(fd1, "abcd", 4);
     152:	4611                	li	a2,4
     154:	00006597          	auipc	a1,0x6
     158:	d9c58593          	addi	a1,a1,-612 # 5ef0 <malloc+0x4a4>
     15c:	00005097          	auipc	ra,0x5
     160:	4d2080e7          	jalr	1234(ra) # 562e <write>
  int fd2 = open("truncfile", O_TRUNC|O_WRONLY);
     164:	40100593          	li	a1,1025
     168:	00006517          	auipc	a0,0x6
     16c:	d7850513          	addi	a0,a0,-648 # 5ee0 <malloc+0x494>
     170:	00005097          	auipc	ra,0x5
     174:	4de080e7          	jalr	1246(ra) # 564e <open>
     178:	892a                	mv	s2,a0
  int n = write(fd1, "x", 1);
     17a:	4605                	li	a2,1
     17c:	00006597          	auipc	a1,0x6
     180:	d7c58593          	addi	a1,a1,-644 # 5ef8 <malloc+0x4ac>
     184:	8526                	mv	a0,s1
     186:	00005097          	auipc	ra,0x5
     18a:	4a8080e7          	jalr	1192(ra) # 562e <write>
  if(n != -1){
     18e:	57fd                	li	a5,-1
     190:	02f51b63          	bne	a0,a5,1c6 <truncate2+0xaa>
  unlink("truncfile");
     194:	00006517          	auipc	a0,0x6
     198:	d4c50513          	addi	a0,a0,-692 # 5ee0 <malloc+0x494>
     19c:	00005097          	auipc	ra,0x5
     1a0:	4c2080e7          	jalr	1218(ra) # 565e <unlink>
  close(fd1);
     1a4:	8526                	mv	a0,s1
     1a6:	00005097          	auipc	ra,0x5
     1aa:	490080e7          	jalr	1168(ra) # 5636 <close>
  close(fd2);
     1ae:	854a                	mv	a0,s2
     1b0:	00005097          	auipc	ra,0x5
     1b4:	486080e7          	jalr	1158(ra) # 5636 <close>
}
     1b8:	70a2                	ld	ra,40(sp)
     1ba:	7402                	ld	s0,32(sp)
     1bc:	64e2                	ld	s1,24(sp)
     1be:	6942                	ld	s2,16(sp)
     1c0:	69a2                	ld	s3,8(sp)
     1c2:	6145                	addi	sp,sp,48
     1c4:	8082                	ret
    printf("%s: write returned %d, expected -1\n", s, n);
     1c6:	862a                	mv	a2,a0
     1c8:	85ce                	mv	a1,s3
     1ca:	00006517          	auipc	a0,0x6
     1ce:	d3650513          	addi	a0,a0,-714 # 5f00 <malloc+0x4b4>
     1d2:	00005097          	auipc	ra,0x5
     1d6:	7bc080e7          	jalr	1980(ra) # 598e <printf>
    exit(1);
     1da:	4505                	li	a0,1
     1dc:	00005097          	auipc	ra,0x5
     1e0:	432080e7          	jalr	1074(ra) # 560e <exit>

00000000000001e4 <createtest>:
{
     1e4:	7179                	addi	sp,sp,-48
     1e6:	f406                	sd	ra,40(sp)
     1e8:	f022                	sd	s0,32(sp)
     1ea:	ec26                	sd	s1,24(sp)
     1ec:	e84a                	sd	s2,16(sp)
     1ee:	1800                	addi	s0,sp,48
  name[0] = 'a';
     1f0:	06100793          	li	a5,97
     1f4:	fcf40c23          	sb	a5,-40(s0)
  name[2] = '\0';
     1f8:	fc040d23          	sb	zero,-38(s0)
     1fc:	03000493          	li	s1,48
  for(i = 0; i < N; i++){
     200:	06400913          	li	s2,100
    name[1] = '0' + i;
     204:	fc940ca3          	sb	s1,-39(s0)
    fd = open(name, O_CREATE|O_RDWR);
     208:	20200593          	li	a1,514
     20c:	fd840513          	addi	a0,s0,-40
     210:	00005097          	auipc	ra,0x5
     214:	43e080e7          	jalr	1086(ra) # 564e <open>
    close(fd);
     218:	00005097          	auipc	ra,0x5
     21c:	41e080e7          	jalr	1054(ra) # 5636 <close>
  for(i = 0; i < N; i++){
     220:	2485                	addiw	s1,s1,1
     222:	0ff4f493          	andi	s1,s1,255
     226:	fd249fe3          	bne	s1,s2,204 <createtest+0x20>
  name[0] = 'a';
     22a:	06100793          	li	a5,97
     22e:	fcf40c23          	sb	a5,-40(s0)
  name[2] = '\0';
     232:	fc040d23          	sb	zero,-38(s0)
     236:	03000493          	li	s1,48
  for(i = 0; i < N; i++){
     23a:	06400913          	li	s2,100
    name[1] = '0' + i;
     23e:	fc940ca3          	sb	s1,-39(s0)
    unlink(name);
     242:	fd840513          	addi	a0,s0,-40
     246:	00005097          	auipc	ra,0x5
     24a:	418080e7          	jalr	1048(ra) # 565e <unlink>
  for(i = 0; i < N; i++){
     24e:	2485                	addiw	s1,s1,1
     250:	0ff4f493          	andi	s1,s1,255
     254:	ff2495e3          	bne	s1,s2,23e <createtest+0x5a>
}
     258:	70a2                	ld	ra,40(sp)
     25a:	7402                	ld	s0,32(sp)
     25c:	64e2                	ld	s1,24(sp)
     25e:	6942                	ld	s2,16(sp)
     260:	6145                	addi	sp,sp,48
     262:	8082                	ret

0000000000000264 <bigwrite>:
{
     264:	715d                	addi	sp,sp,-80
     266:	e486                	sd	ra,72(sp)
     268:	e0a2                	sd	s0,64(sp)
     26a:	fc26                	sd	s1,56(sp)
     26c:	f84a                	sd	s2,48(sp)
     26e:	f44e                	sd	s3,40(sp)
     270:	f052                	sd	s4,32(sp)
     272:	ec56                	sd	s5,24(sp)
     274:	e85a                	sd	s6,16(sp)
     276:	e45e                	sd	s7,8(sp)
     278:	0880                	addi	s0,sp,80
     27a:	8baa                	mv	s7,a0
  unlink("bigwrite");
     27c:	00006517          	auipc	a0,0x6
     280:	a8450513          	addi	a0,a0,-1404 # 5d00 <malloc+0x2b4>
     284:	00005097          	auipc	ra,0x5
     288:	3da080e7          	jalr	986(ra) # 565e <unlink>
  for(sz = 499; sz < (MAXOPBLOCKS+2)*BSIZE; sz += 471){
     28c:	1f300493          	li	s1,499
    fd = open("bigwrite", O_CREATE | O_RDWR);
     290:	00006a97          	auipc	s5,0x6
     294:	a70a8a93          	addi	s5,s5,-1424 # 5d00 <malloc+0x2b4>
      int cc = write(fd, buf, sz);
     298:	0000ca17          	auipc	s4,0xc
     29c:	808a0a13          	addi	s4,s4,-2040 # baa0 <buf>
  for(sz = 499; sz < (MAXOPBLOCKS+2)*BSIZE; sz += 471){
     2a0:	6b0d                	lui	s6,0x3
     2a2:	1c9b0b13          	addi	s6,s6,457 # 31c9 <subdir+0x171>
    fd = open("bigwrite", O_CREATE | O_RDWR);
     2a6:	20200593          	li	a1,514
     2aa:	8556                	mv	a0,s5
     2ac:	00005097          	auipc	ra,0x5
     2b0:	3a2080e7          	jalr	930(ra) # 564e <open>
     2b4:	892a                	mv	s2,a0
    if(fd < 0){
     2b6:	04054d63          	bltz	a0,310 <bigwrite+0xac>
      int cc = write(fd, buf, sz);
     2ba:	8626                	mv	a2,s1
     2bc:	85d2                	mv	a1,s4
     2be:	00005097          	auipc	ra,0x5
     2c2:	370080e7          	jalr	880(ra) # 562e <write>
     2c6:	89aa                	mv	s3,a0
      if(cc != sz){
     2c8:	06a49463          	bne	s1,a0,330 <bigwrite+0xcc>
      int cc = write(fd, buf, sz);
     2cc:	8626                	mv	a2,s1
     2ce:	85d2                	mv	a1,s4
     2d0:	854a                	mv	a0,s2
     2d2:	00005097          	auipc	ra,0x5
     2d6:	35c080e7          	jalr	860(ra) # 562e <write>
      if(cc != sz){
     2da:	04951963          	bne	a0,s1,32c <bigwrite+0xc8>
    close(fd);
     2de:	854a                	mv	a0,s2
     2e0:	00005097          	auipc	ra,0x5
     2e4:	356080e7          	jalr	854(ra) # 5636 <close>
    unlink("bigwrite");
     2e8:	8556                	mv	a0,s5
     2ea:	00005097          	auipc	ra,0x5
     2ee:	374080e7          	jalr	884(ra) # 565e <unlink>
  for(sz = 499; sz < (MAXOPBLOCKS+2)*BSIZE; sz += 471){
     2f2:	1d74849b          	addiw	s1,s1,471
     2f6:	fb6498e3          	bne	s1,s6,2a6 <bigwrite+0x42>
}
     2fa:	60a6                	ld	ra,72(sp)
     2fc:	6406                	ld	s0,64(sp)
     2fe:	74e2                	ld	s1,56(sp)
     300:	7942                	ld	s2,48(sp)
     302:	79a2                	ld	s3,40(sp)
     304:	7a02                	ld	s4,32(sp)
     306:	6ae2                	ld	s5,24(sp)
     308:	6b42                	ld	s6,16(sp)
     30a:	6ba2                	ld	s7,8(sp)
     30c:	6161                	addi	sp,sp,80
     30e:	8082                	ret
      printf("%s: cannot create bigwrite\n", s);
     310:	85de                	mv	a1,s7
     312:	00006517          	auipc	a0,0x6
     316:	c1650513          	addi	a0,a0,-1002 # 5f28 <malloc+0x4dc>
     31a:	00005097          	auipc	ra,0x5
     31e:	674080e7          	jalr	1652(ra) # 598e <printf>
      exit(1);
     322:	4505                	li	a0,1
     324:	00005097          	auipc	ra,0x5
     328:	2ea080e7          	jalr	746(ra) # 560e <exit>
     32c:	84ce                	mv	s1,s3
      int cc = write(fd, buf, sz);
     32e:	89aa                	mv	s3,a0
        printf("%s: write(%d) ret %d\n", s, sz, cc);
     330:	86ce                	mv	a3,s3
     332:	8626                	mv	a2,s1
     334:	85de                	mv	a1,s7
     336:	00006517          	auipc	a0,0x6
     33a:	c1250513          	addi	a0,a0,-1006 # 5f48 <malloc+0x4fc>
     33e:	00005097          	auipc	ra,0x5
     342:	650080e7          	jalr	1616(ra) # 598e <printf>
        exit(1);
     346:	4505                	li	a0,1
     348:	00005097          	auipc	ra,0x5
     34c:	2c6080e7          	jalr	710(ra) # 560e <exit>

0000000000000350 <copyin>:
{
     350:	715d                	addi	sp,sp,-80
     352:	e486                	sd	ra,72(sp)
     354:	e0a2                	sd	s0,64(sp)
     356:	fc26                	sd	s1,56(sp)
     358:	f84a                	sd	s2,48(sp)
     35a:	f44e                	sd	s3,40(sp)
     35c:	f052                	sd	s4,32(sp)
     35e:	0880                	addi	s0,sp,80
  uint64 addrs[] = { 0x80000000LL, 0xffffffffffffffff };
     360:	4785                	li	a5,1
     362:	07fe                	slli	a5,a5,0x1f
     364:	fcf43023          	sd	a5,-64(s0)
     368:	57fd                	li	a5,-1
     36a:	fcf43423          	sd	a5,-56(s0)
  for(int ai = 0; ai < 2; ai++){
     36e:	fc040913          	addi	s2,s0,-64
    int fd = open("copyin1", O_CREATE|O_WRONLY);
     372:	00006a17          	auipc	s4,0x6
     376:	beea0a13          	addi	s4,s4,-1042 # 5f60 <malloc+0x514>
    uint64 addr = addrs[ai];
     37a:	00093983          	ld	s3,0(s2)
    int fd = open("copyin1", O_CREATE|O_WRONLY);
     37e:	20100593          	li	a1,513
     382:	8552                	mv	a0,s4
     384:	00005097          	auipc	ra,0x5
     388:	2ca080e7          	jalr	714(ra) # 564e <open>
     38c:	84aa                	mv	s1,a0
    if(fd < 0){
     38e:	08054863          	bltz	a0,41e <copyin+0xce>
    int n = write(fd, (void*)addr, 8192);
     392:	6609                	lui	a2,0x2
     394:	85ce                	mv	a1,s3
     396:	00005097          	auipc	ra,0x5
     39a:	298080e7          	jalr	664(ra) # 562e <write>
    if(n >= 0){
     39e:	08055d63          	bgez	a0,438 <copyin+0xe8>
    close(fd);
     3a2:	8526                	mv	a0,s1
     3a4:	00005097          	auipc	ra,0x5
     3a8:	292080e7          	jalr	658(ra) # 5636 <close>
    unlink("copyin1");
     3ac:	8552                	mv	a0,s4
     3ae:	00005097          	auipc	ra,0x5
     3b2:	2b0080e7          	jalr	688(ra) # 565e <unlink>
    n = write(1, (char*)addr, 8192);
     3b6:	6609                	lui	a2,0x2
     3b8:	85ce                	mv	a1,s3
     3ba:	4505                	li	a0,1
     3bc:	00005097          	auipc	ra,0x5
     3c0:	272080e7          	jalr	626(ra) # 562e <write>
    if(n > 0){
     3c4:	08a04963          	bgtz	a0,456 <copyin+0x106>
    if(pipe(fds) < 0){
     3c8:	fb840513          	addi	a0,s0,-72
     3cc:	00005097          	auipc	ra,0x5
     3d0:	252080e7          	jalr	594(ra) # 561e <pipe>
     3d4:	0a054063          	bltz	a0,474 <copyin+0x124>
    n = write(fds[1], (char*)addr, 8192);
     3d8:	6609                	lui	a2,0x2
     3da:	85ce                	mv	a1,s3
     3dc:	fbc42503          	lw	a0,-68(s0)
     3e0:	00005097          	auipc	ra,0x5
     3e4:	24e080e7          	jalr	590(ra) # 562e <write>
    if(n > 0){
     3e8:	0aa04363          	bgtz	a0,48e <copyin+0x13e>
    close(fds[0]);
     3ec:	fb842503          	lw	a0,-72(s0)
     3f0:	00005097          	auipc	ra,0x5
     3f4:	246080e7          	jalr	582(ra) # 5636 <close>
    close(fds[1]);
     3f8:	fbc42503          	lw	a0,-68(s0)
     3fc:	00005097          	auipc	ra,0x5
     400:	23a080e7          	jalr	570(ra) # 5636 <close>
  for(int ai = 0; ai < 2; ai++){
     404:	0921                	addi	s2,s2,8
     406:	fd040793          	addi	a5,s0,-48
     40a:	f6f918e3          	bne	s2,a5,37a <copyin+0x2a>
}
     40e:	60a6                	ld	ra,72(sp)
     410:	6406                	ld	s0,64(sp)
     412:	74e2                	ld	s1,56(sp)
     414:	7942                	ld	s2,48(sp)
     416:	79a2                	ld	s3,40(sp)
     418:	7a02                	ld	s4,32(sp)
     41a:	6161                	addi	sp,sp,80
     41c:	8082                	ret
      printf("open(copyin1) failed\n");
     41e:	00006517          	auipc	a0,0x6
     422:	b4a50513          	addi	a0,a0,-1206 # 5f68 <malloc+0x51c>
     426:	00005097          	auipc	ra,0x5
     42a:	568080e7          	jalr	1384(ra) # 598e <printf>
      exit(1);
     42e:	4505                	li	a0,1
     430:	00005097          	auipc	ra,0x5
     434:	1de080e7          	jalr	478(ra) # 560e <exit>
      printf("write(fd, %p, 8192) returned %d, not -1\n", addr, n);
     438:	862a                	mv	a2,a0
     43a:	85ce                	mv	a1,s3
     43c:	00006517          	auipc	a0,0x6
     440:	b4450513          	addi	a0,a0,-1212 # 5f80 <malloc+0x534>
     444:	00005097          	auipc	ra,0x5
     448:	54a080e7          	jalr	1354(ra) # 598e <printf>
      exit(1);
     44c:	4505                	li	a0,1
     44e:	00005097          	auipc	ra,0x5
     452:	1c0080e7          	jalr	448(ra) # 560e <exit>
      printf("write(1, %p, 8192) returned %d, not -1 or 0\n", addr, n);
     456:	862a                	mv	a2,a0
     458:	85ce                	mv	a1,s3
     45a:	00006517          	auipc	a0,0x6
     45e:	b5650513          	addi	a0,a0,-1194 # 5fb0 <malloc+0x564>
     462:	00005097          	auipc	ra,0x5
     466:	52c080e7          	jalr	1324(ra) # 598e <printf>
      exit(1);
     46a:	4505                	li	a0,1
     46c:	00005097          	auipc	ra,0x5
     470:	1a2080e7          	jalr	418(ra) # 560e <exit>
      printf("pipe() failed\n");
     474:	00006517          	auipc	a0,0x6
     478:	b6c50513          	addi	a0,a0,-1172 # 5fe0 <malloc+0x594>
     47c:	00005097          	auipc	ra,0x5
     480:	512080e7          	jalr	1298(ra) # 598e <printf>
      exit(1);
     484:	4505                	li	a0,1
     486:	00005097          	auipc	ra,0x5
     48a:	188080e7          	jalr	392(ra) # 560e <exit>
      printf("write(pipe, %p, 8192) returned %d, not -1 or 0\n", addr, n);
     48e:	862a                	mv	a2,a0
     490:	85ce                	mv	a1,s3
     492:	00006517          	auipc	a0,0x6
     496:	b5e50513          	addi	a0,a0,-1186 # 5ff0 <malloc+0x5a4>
     49a:	00005097          	auipc	ra,0x5
     49e:	4f4080e7          	jalr	1268(ra) # 598e <printf>
      exit(1);
     4a2:	4505                	li	a0,1
     4a4:	00005097          	auipc	ra,0x5
     4a8:	16a080e7          	jalr	362(ra) # 560e <exit>

00000000000004ac <copyout>:
{
     4ac:	711d                	addi	sp,sp,-96
     4ae:	ec86                	sd	ra,88(sp)
     4b0:	e8a2                	sd	s0,80(sp)
     4b2:	e4a6                	sd	s1,72(sp)
     4b4:	e0ca                	sd	s2,64(sp)
     4b6:	fc4e                	sd	s3,56(sp)
     4b8:	f852                	sd	s4,48(sp)
     4ba:	f456                	sd	s5,40(sp)
     4bc:	1080                	addi	s0,sp,96
  uint64 addrs[] = { 0x80000000LL, 0xffffffffffffffff };
     4be:	4785                	li	a5,1
     4c0:	07fe                	slli	a5,a5,0x1f
     4c2:	faf43823          	sd	a5,-80(s0)
     4c6:	57fd                	li	a5,-1
     4c8:	faf43c23          	sd	a5,-72(s0)
  for(int ai = 0; ai < 2; ai++){
     4cc:	fb040913          	addi	s2,s0,-80
    int fd = open("README", 0);
     4d0:	00006a17          	auipc	s4,0x6
     4d4:	b50a0a13          	addi	s4,s4,-1200 # 6020 <malloc+0x5d4>
    n = write(fds[1], "x", 1);
     4d8:	00006a97          	auipc	s5,0x6
     4dc:	a20a8a93          	addi	s5,s5,-1504 # 5ef8 <malloc+0x4ac>
    uint64 addr = addrs[ai];
     4e0:	00093983          	ld	s3,0(s2)
    int fd = open("README", 0);
     4e4:	4581                	li	a1,0
     4e6:	8552                	mv	a0,s4
     4e8:	00005097          	auipc	ra,0x5
     4ec:	166080e7          	jalr	358(ra) # 564e <open>
     4f0:	84aa                	mv	s1,a0
    if(fd < 0){
     4f2:	08054663          	bltz	a0,57e <copyout+0xd2>
    int n = read(fd, (void*)addr, 8192);
     4f6:	6609                	lui	a2,0x2
     4f8:	85ce                	mv	a1,s3
     4fa:	00005097          	auipc	ra,0x5
     4fe:	12c080e7          	jalr	300(ra) # 5626 <read>
    if(n > 0){
     502:	08a04b63          	bgtz	a0,598 <copyout+0xec>
    close(fd);
     506:	8526                	mv	a0,s1
     508:	00005097          	auipc	ra,0x5
     50c:	12e080e7          	jalr	302(ra) # 5636 <close>
    if(pipe(fds) < 0){
     510:	fa840513          	addi	a0,s0,-88
     514:	00005097          	auipc	ra,0x5
     518:	10a080e7          	jalr	266(ra) # 561e <pipe>
     51c:	08054d63          	bltz	a0,5b6 <copyout+0x10a>
    n = write(fds[1], "x", 1);
     520:	4605                	li	a2,1
     522:	85d6                	mv	a1,s5
     524:	fac42503          	lw	a0,-84(s0)
     528:	00005097          	auipc	ra,0x5
     52c:	106080e7          	jalr	262(ra) # 562e <write>
    if(n != 1){
     530:	4785                	li	a5,1
     532:	08f51f63          	bne	a0,a5,5d0 <copyout+0x124>
    n = read(fds[0], (void*)addr, 8192);
     536:	6609                	lui	a2,0x2
     538:	85ce                	mv	a1,s3
     53a:	fa842503          	lw	a0,-88(s0)
     53e:	00005097          	auipc	ra,0x5
     542:	0e8080e7          	jalr	232(ra) # 5626 <read>
    if(n > 0){
     546:	0aa04263          	bgtz	a0,5ea <copyout+0x13e>
    close(fds[0]);
     54a:	fa842503          	lw	a0,-88(s0)
     54e:	00005097          	auipc	ra,0x5
     552:	0e8080e7          	jalr	232(ra) # 5636 <close>
    close(fds[1]);
     556:	fac42503          	lw	a0,-84(s0)
     55a:	00005097          	auipc	ra,0x5
     55e:	0dc080e7          	jalr	220(ra) # 5636 <close>
  for(int ai = 0; ai < 2; ai++){
     562:	0921                	addi	s2,s2,8
     564:	fc040793          	addi	a5,s0,-64
     568:	f6f91ce3          	bne	s2,a5,4e0 <copyout+0x34>
}
     56c:	60e6                	ld	ra,88(sp)
     56e:	6446                	ld	s0,80(sp)
     570:	64a6                	ld	s1,72(sp)
     572:	6906                	ld	s2,64(sp)
     574:	79e2                	ld	s3,56(sp)
     576:	7a42                	ld	s4,48(sp)
     578:	7aa2                	ld	s5,40(sp)
     57a:	6125                	addi	sp,sp,96
     57c:	8082                	ret
      printf("open(README) failed\n");
     57e:	00006517          	auipc	a0,0x6
     582:	aaa50513          	addi	a0,a0,-1366 # 6028 <malloc+0x5dc>
     586:	00005097          	auipc	ra,0x5
     58a:	408080e7          	jalr	1032(ra) # 598e <printf>
      exit(1);
     58e:	4505                	li	a0,1
     590:	00005097          	auipc	ra,0x5
     594:	07e080e7          	jalr	126(ra) # 560e <exit>
      printf("read(fd, %p, 8192) returned %d, not -1 or 0\n", addr, n);
     598:	862a                	mv	a2,a0
     59a:	85ce                	mv	a1,s3
     59c:	00006517          	auipc	a0,0x6
     5a0:	aa450513          	addi	a0,a0,-1372 # 6040 <malloc+0x5f4>
     5a4:	00005097          	auipc	ra,0x5
     5a8:	3ea080e7          	jalr	1002(ra) # 598e <printf>
      exit(1);
     5ac:	4505                	li	a0,1
     5ae:	00005097          	auipc	ra,0x5
     5b2:	060080e7          	jalr	96(ra) # 560e <exit>
      printf("pipe() failed\n");
     5b6:	00006517          	auipc	a0,0x6
     5ba:	a2a50513          	addi	a0,a0,-1494 # 5fe0 <malloc+0x594>
     5be:	00005097          	auipc	ra,0x5
     5c2:	3d0080e7          	jalr	976(ra) # 598e <printf>
      exit(1);
     5c6:	4505                	li	a0,1
     5c8:	00005097          	auipc	ra,0x5
     5cc:	046080e7          	jalr	70(ra) # 560e <exit>
      printf("pipe write failed\n");
     5d0:	00006517          	auipc	a0,0x6
     5d4:	aa050513          	addi	a0,a0,-1376 # 6070 <malloc+0x624>
     5d8:	00005097          	auipc	ra,0x5
     5dc:	3b6080e7          	jalr	950(ra) # 598e <printf>
      exit(1);
     5e0:	4505                	li	a0,1
     5e2:	00005097          	auipc	ra,0x5
     5e6:	02c080e7          	jalr	44(ra) # 560e <exit>
      printf("read(pipe, %p, 8192) returned %d, not -1 or 0\n", addr, n);
     5ea:	862a                	mv	a2,a0
     5ec:	85ce                	mv	a1,s3
     5ee:	00006517          	auipc	a0,0x6
     5f2:	a9a50513          	addi	a0,a0,-1382 # 6088 <malloc+0x63c>
     5f6:	00005097          	auipc	ra,0x5
     5fa:	398080e7          	jalr	920(ra) # 598e <printf>
      exit(1);
     5fe:	4505                	li	a0,1
     600:	00005097          	auipc	ra,0x5
     604:	00e080e7          	jalr	14(ra) # 560e <exit>

0000000000000608 <truncate1>:
{
     608:	711d                	addi	sp,sp,-96
     60a:	ec86                	sd	ra,88(sp)
     60c:	e8a2                	sd	s0,80(sp)
     60e:	e4a6                	sd	s1,72(sp)
     610:	e0ca                	sd	s2,64(sp)
     612:	fc4e                	sd	s3,56(sp)
     614:	f852                	sd	s4,48(sp)
     616:	f456                	sd	s5,40(sp)
     618:	1080                	addi	s0,sp,96
     61a:	8aaa                	mv	s5,a0
  unlink("truncfile");
     61c:	00006517          	auipc	a0,0x6
     620:	8c450513          	addi	a0,a0,-1852 # 5ee0 <malloc+0x494>
     624:	00005097          	auipc	ra,0x5
     628:	03a080e7          	jalr	58(ra) # 565e <unlink>
  int fd1 = open("truncfile", O_CREATE|O_WRONLY|O_TRUNC);
     62c:	60100593          	li	a1,1537
     630:	00006517          	auipc	a0,0x6
     634:	8b050513          	addi	a0,a0,-1872 # 5ee0 <malloc+0x494>
     638:	00005097          	auipc	ra,0x5
     63c:	016080e7          	jalr	22(ra) # 564e <open>
     640:	84aa                	mv	s1,a0
  write(fd1, "abcd", 4);
     642:	4611                	li	a2,4
     644:	00006597          	auipc	a1,0x6
     648:	8ac58593          	addi	a1,a1,-1876 # 5ef0 <malloc+0x4a4>
     64c:	00005097          	auipc	ra,0x5
     650:	fe2080e7          	jalr	-30(ra) # 562e <write>
  close(fd1);
     654:	8526                	mv	a0,s1
     656:	00005097          	auipc	ra,0x5
     65a:	fe0080e7          	jalr	-32(ra) # 5636 <close>
  int fd2 = open("truncfile", O_RDONLY);
     65e:	4581                	li	a1,0
     660:	00006517          	auipc	a0,0x6
     664:	88050513          	addi	a0,a0,-1920 # 5ee0 <malloc+0x494>
     668:	00005097          	auipc	ra,0x5
     66c:	fe6080e7          	jalr	-26(ra) # 564e <open>
     670:	84aa                	mv	s1,a0
  int n = read(fd2, buf, sizeof(buf));
     672:	02000613          	li	a2,32
     676:	fa040593          	addi	a1,s0,-96
     67a:	00005097          	auipc	ra,0x5
     67e:	fac080e7          	jalr	-84(ra) # 5626 <read>
  if(n != 4){
     682:	4791                	li	a5,4
     684:	0cf51e63          	bne	a0,a5,760 <truncate1+0x158>
  fd1 = open("truncfile", O_WRONLY|O_TRUNC);
     688:	40100593          	li	a1,1025
     68c:	00006517          	auipc	a0,0x6
     690:	85450513          	addi	a0,a0,-1964 # 5ee0 <malloc+0x494>
     694:	00005097          	auipc	ra,0x5
     698:	fba080e7          	jalr	-70(ra) # 564e <open>
     69c:	89aa                	mv	s3,a0
  int fd3 = open("truncfile", O_RDONLY);
     69e:	4581                	li	a1,0
     6a0:	00006517          	auipc	a0,0x6
     6a4:	84050513          	addi	a0,a0,-1984 # 5ee0 <malloc+0x494>
     6a8:	00005097          	auipc	ra,0x5
     6ac:	fa6080e7          	jalr	-90(ra) # 564e <open>
     6b0:	892a                	mv	s2,a0
  n = read(fd3, buf, sizeof(buf));
     6b2:	02000613          	li	a2,32
     6b6:	fa040593          	addi	a1,s0,-96
     6ba:	00005097          	auipc	ra,0x5
     6be:	f6c080e7          	jalr	-148(ra) # 5626 <read>
     6c2:	8a2a                	mv	s4,a0
  if(n != 0){
     6c4:	ed4d                	bnez	a0,77e <truncate1+0x176>
  n = read(fd2, buf, sizeof(buf));
     6c6:	02000613          	li	a2,32
     6ca:	fa040593          	addi	a1,s0,-96
     6ce:	8526                	mv	a0,s1
     6d0:	00005097          	auipc	ra,0x5
     6d4:	f56080e7          	jalr	-170(ra) # 5626 <read>
     6d8:	8a2a                	mv	s4,a0
  if(n != 0){
     6da:	e971                	bnez	a0,7ae <truncate1+0x1a6>
  write(fd1, "abcdef", 6);
     6dc:	4619                	li	a2,6
     6de:	00006597          	auipc	a1,0x6
     6e2:	a3a58593          	addi	a1,a1,-1478 # 6118 <malloc+0x6cc>
     6e6:	854e                	mv	a0,s3
     6e8:	00005097          	auipc	ra,0x5
     6ec:	f46080e7          	jalr	-186(ra) # 562e <write>
  n = read(fd3, buf, sizeof(buf));
     6f0:	02000613          	li	a2,32
     6f4:	fa040593          	addi	a1,s0,-96
     6f8:	854a                	mv	a0,s2
     6fa:	00005097          	auipc	ra,0x5
     6fe:	f2c080e7          	jalr	-212(ra) # 5626 <read>
  if(n != 6){
     702:	4799                	li	a5,6
     704:	0cf51d63          	bne	a0,a5,7de <truncate1+0x1d6>
  n = read(fd2, buf, sizeof(buf));
     708:	02000613          	li	a2,32
     70c:	fa040593          	addi	a1,s0,-96
     710:	8526                	mv	a0,s1
     712:	00005097          	auipc	ra,0x5
     716:	f14080e7          	jalr	-236(ra) # 5626 <read>
  if(n != 2){
     71a:	4789                	li	a5,2
     71c:	0ef51063          	bne	a0,a5,7fc <truncate1+0x1f4>
  unlink("truncfile");
     720:	00005517          	auipc	a0,0x5
     724:	7c050513          	addi	a0,a0,1984 # 5ee0 <malloc+0x494>
     728:	00005097          	auipc	ra,0x5
     72c:	f36080e7          	jalr	-202(ra) # 565e <unlink>
  close(fd1);
     730:	854e                	mv	a0,s3
     732:	00005097          	auipc	ra,0x5
     736:	f04080e7          	jalr	-252(ra) # 5636 <close>
  close(fd2);
     73a:	8526                	mv	a0,s1
     73c:	00005097          	auipc	ra,0x5
     740:	efa080e7          	jalr	-262(ra) # 5636 <close>
  close(fd3);
     744:	854a                	mv	a0,s2
     746:	00005097          	auipc	ra,0x5
     74a:	ef0080e7          	jalr	-272(ra) # 5636 <close>
}
     74e:	60e6                	ld	ra,88(sp)
     750:	6446                	ld	s0,80(sp)
     752:	64a6                	ld	s1,72(sp)
     754:	6906                	ld	s2,64(sp)
     756:	79e2                	ld	s3,56(sp)
     758:	7a42                	ld	s4,48(sp)
     75a:	7aa2                	ld	s5,40(sp)
     75c:	6125                	addi	sp,sp,96
     75e:	8082                	ret
    printf("%s: read %d bytes, wanted 4\n", s, n);
     760:	862a                	mv	a2,a0
     762:	85d6                	mv	a1,s5
     764:	00006517          	auipc	a0,0x6
     768:	95450513          	addi	a0,a0,-1708 # 60b8 <malloc+0x66c>
     76c:	00005097          	auipc	ra,0x5
     770:	222080e7          	jalr	546(ra) # 598e <printf>
    exit(1);
     774:	4505                	li	a0,1
     776:	00005097          	auipc	ra,0x5
     77a:	e98080e7          	jalr	-360(ra) # 560e <exit>
    printf("aaa fd3=%d\n", fd3);
     77e:	85ca                	mv	a1,s2
     780:	00006517          	auipc	a0,0x6
     784:	95850513          	addi	a0,a0,-1704 # 60d8 <malloc+0x68c>
     788:	00005097          	auipc	ra,0x5
     78c:	206080e7          	jalr	518(ra) # 598e <printf>
    printf("%s: read %d bytes, wanted 0\n", s, n);
     790:	8652                	mv	a2,s4
     792:	85d6                	mv	a1,s5
     794:	00006517          	auipc	a0,0x6
     798:	95450513          	addi	a0,a0,-1708 # 60e8 <malloc+0x69c>
     79c:	00005097          	auipc	ra,0x5
     7a0:	1f2080e7          	jalr	498(ra) # 598e <printf>
    exit(1);
     7a4:	4505                	li	a0,1
     7a6:	00005097          	auipc	ra,0x5
     7aa:	e68080e7          	jalr	-408(ra) # 560e <exit>
    printf("bbb fd2=%d\n", fd2);
     7ae:	85a6                	mv	a1,s1
     7b0:	00006517          	auipc	a0,0x6
     7b4:	95850513          	addi	a0,a0,-1704 # 6108 <malloc+0x6bc>
     7b8:	00005097          	auipc	ra,0x5
     7bc:	1d6080e7          	jalr	470(ra) # 598e <printf>
    printf("%s: read %d bytes, wanted 0\n", s, n);
     7c0:	8652                	mv	a2,s4
     7c2:	85d6                	mv	a1,s5
     7c4:	00006517          	auipc	a0,0x6
     7c8:	92450513          	addi	a0,a0,-1756 # 60e8 <malloc+0x69c>
     7cc:	00005097          	auipc	ra,0x5
     7d0:	1c2080e7          	jalr	450(ra) # 598e <printf>
    exit(1);
     7d4:	4505                	li	a0,1
     7d6:	00005097          	auipc	ra,0x5
     7da:	e38080e7          	jalr	-456(ra) # 560e <exit>
    printf("%s: read %d bytes, wanted 6\n", s, n);
     7de:	862a                	mv	a2,a0
     7e0:	85d6                	mv	a1,s5
     7e2:	00006517          	auipc	a0,0x6
     7e6:	93e50513          	addi	a0,a0,-1730 # 6120 <malloc+0x6d4>
     7ea:	00005097          	auipc	ra,0x5
     7ee:	1a4080e7          	jalr	420(ra) # 598e <printf>
    exit(1);
     7f2:	4505                	li	a0,1
     7f4:	00005097          	auipc	ra,0x5
     7f8:	e1a080e7          	jalr	-486(ra) # 560e <exit>
    printf("%s: read %d bytes, wanted 2\n", s, n);
     7fc:	862a                	mv	a2,a0
     7fe:	85d6                	mv	a1,s5
     800:	00006517          	auipc	a0,0x6
     804:	94050513          	addi	a0,a0,-1728 # 6140 <malloc+0x6f4>
     808:	00005097          	auipc	ra,0x5
     80c:	186080e7          	jalr	390(ra) # 598e <printf>
    exit(1);
     810:	4505                	li	a0,1
     812:	00005097          	auipc	ra,0x5
     816:	dfc080e7          	jalr	-516(ra) # 560e <exit>

000000000000081a <writetest>:
{
     81a:	7139                	addi	sp,sp,-64
     81c:	fc06                	sd	ra,56(sp)
     81e:	f822                	sd	s0,48(sp)
     820:	f426                	sd	s1,40(sp)
     822:	f04a                	sd	s2,32(sp)
     824:	ec4e                	sd	s3,24(sp)
     826:	e852                	sd	s4,16(sp)
     828:	e456                	sd	s5,8(sp)
     82a:	e05a                	sd	s6,0(sp)
     82c:	0080                	addi	s0,sp,64
     82e:	8b2a                	mv	s6,a0
  fd = open("small", O_CREATE|O_RDWR);
     830:	20200593          	li	a1,514
     834:	00006517          	auipc	a0,0x6
     838:	92c50513          	addi	a0,a0,-1748 # 6160 <malloc+0x714>
     83c:	00005097          	auipc	ra,0x5
     840:	e12080e7          	jalr	-494(ra) # 564e <open>
  if(fd < 0){
     844:	0a054d63          	bltz	a0,8fe <writetest+0xe4>
     848:	892a                	mv	s2,a0
     84a:	4481                	li	s1,0
    if(write(fd, "aaaaaaaaaa", SZ) != SZ){
     84c:	00006997          	auipc	s3,0x6
     850:	93c98993          	addi	s3,s3,-1732 # 6188 <malloc+0x73c>
    if(write(fd, "bbbbbbbbbb", SZ) != SZ){
     854:	00006a97          	auipc	s5,0x6
     858:	96ca8a93          	addi	s5,s5,-1684 # 61c0 <malloc+0x774>
  for(i = 0; i < N; i++){
     85c:	06400a13          	li	s4,100
    if(write(fd, "aaaaaaaaaa", SZ) != SZ){
     860:	4629                	li	a2,10
     862:	85ce                	mv	a1,s3
     864:	854a                	mv	a0,s2
     866:	00005097          	auipc	ra,0x5
     86a:	dc8080e7          	jalr	-568(ra) # 562e <write>
     86e:	47a9                	li	a5,10
     870:	0af51563          	bne	a0,a5,91a <writetest+0x100>
    if(write(fd, "bbbbbbbbbb", SZ) != SZ){
     874:	4629                	li	a2,10
     876:	85d6                	mv	a1,s5
     878:	854a                	mv	a0,s2
     87a:	00005097          	auipc	ra,0x5
     87e:	db4080e7          	jalr	-588(ra) # 562e <write>
     882:	47a9                	li	a5,10
     884:	0af51a63          	bne	a0,a5,938 <writetest+0x11e>
  for(i = 0; i < N; i++){
     888:	2485                	addiw	s1,s1,1
     88a:	fd449be3          	bne	s1,s4,860 <writetest+0x46>
  close(fd);
     88e:	854a                	mv	a0,s2
     890:	00005097          	auipc	ra,0x5
     894:	da6080e7          	jalr	-602(ra) # 5636 <close>
  fd = open("small", O_RDONLY);
     898:	4581                	li	a1,0
     89a:	00006517          	auipc	a0,0x6
     89e:	8c650513          	addi	a0,a0,-1850 # 6160 <malloc+0x714>
     8a2:	00005097          	auipc	ra,0x5
     8a6:	dac080e7          	jalr	-596(ra) # 564e <open>
     8aa:	84aa                	mv	s1,a0
  if(fd < 0){
     8ac:	0a054563          	bltz	a0,956 <writetest+0x13c>
  i = read(fd, buf, N*SZ*2);
     8b0:	7d000613          	li	a2,2000
     8b4:	0000b597          	auipc	a1,0xb
     8b8:	1ec58593          	addi	a1,a1,492 # baa0 <buf>
     8bc:	00005097          	auipc	ra,0x5
     8c0:	d6a080e7          	jalr	-662(ra) # 5626 <read>
  if(i != N*SZ*2){
     8c4:	7d000793          	li	a5,2000
     8c8:	0af51563          	bne	a0,a5,972 <writetest+0x158>
  close(fd);
     8cc:	8526                	mv	a0,s1
     8ce:	00005097          	auipc	ra,0x5
     8d2:	d68080e7          	jalr	-664(ra) # 5636 <close>
  if(unlink("small") < 0){
     8d6:	00006517          	auipc	a0,0x6
     8da:	88a50513          	addi	a0,a0,-1910 # 6160 <malloc+0x714>
     8de:	00005097          	auipc	ra,0x5
     8e2:	d80080e7          	jalr	-640(ra) # 565e <unlink>
     8e6:	0a054463          	bltz	a0,98e <writetest+0x174>
}
     8ea:	70e2                	ld	ra,56(sp)
     8ec:	7442                	ld	s0,48(sp)
     8ee:	74a2                	ld	s1,40(sp)
     8f0:	7902                	ld	s2,32(sp)
     8f2:	69e2                	ld	s3,24(sp)
     8f4:	6a42                	ld	s4,16(sp)
     8f6:	6aa2                	ld	s5,8(sp)
     8f8:	6b02                	ld	s6,0(sp)
     8fa:	6121                	addi	sp,sp,64
     8fc:	8082                	ret
    printf("%s: error: creat small failed!\n", s);
     8fe:	85da                	mv	a1,s6
     900:	00006517          	auipc	a0,0x6
     904:	86850513          	addi	a0,a0,-1944 # 6168 <malloc+0x71c>
     908:	00005097          	auipc	ra,0x5
     90c:	086080e7          	jalr	134(ra) # 598e <printf>
    exit(1);
     910:	4505                	li	a0,1
     912:	00005097          	auipc	ra,0x5
     916:	cfc080e7          	jalr	-772(ra) # 560e <exit>
      printf("%s: error: write aa %d new file failed\n", s, i);
     91a:	8626                	mv	a2,s1
     91c:	85da                	mv	a1,s6
     91e:	00006517          	auipc	a0,0x6
     922:	87a50513          	addi	a0,a0,-1926 # 6198 <malloc+0x74c>
     926:	00005097          	auipc	ra,0x5
     92a:	068080e7          	jalr	104(ra) # 598e <printf>
      exit(1);
     92e:	4505                	li	a0,1
     930:	00005097          	auipc	ra,0x5
     934:	cde080e7          	jalr	-802(ra) # 560e <exit>
      printf("%s: error: write bb %d new file failed\n", s, i);
     938:	8626                	mv	a2,s1
     93a:	85da                	mv	a1,s6
     93c:	00006517          	auipc	a0,0x6
     940:	89450513          	addi	a0,a0,-1900 # 61d0 <malloc+0x784>
     944:	00005097          	auipc	ra,0x5
     948:	04a080e7          	jalr	74(ra) # 598e <printf>
      exit(1);
     94c:	4505                	li	a0,1
     94e:	00005097          	auipc	ra,0x5
     952:	cc0080e7          	jalr	-832(ra) # 560e <exit>
    printf("%s: error: open small failed!\n", s);
     956:	85da                	mv	a1,s6
     958:	00006517          	auipc	a0,0x6
     95c:	8a050513          	addi	a0,a0,-1888 # 61f8 <malloc+0x7ac>
     960:	00005097          	auipc	ra,0x5
     964:	02e080e7          	jalr	46(ra) # 598e <printf>
    exit(1);
     968:	4505                	li	a0,1
     96a:	00005097          	auipc	ra,0x5
     96e:	ca4080e7          	jalr	-860(ra) # 560e <exit>
    printf("%s: read failed\n", s);
     972:	85da                	mv	a1,s6
     974:	00006517          	auipc	a0,0x6
     978:	8a450513          	addi	a0,a0,-1884 # 6218 <malloc+0x7cc>
     97c:	00005097          	auipc	ra,0x5
     980:	012080e7          	jalr	18(ra) # 598e <printf>
    exit(1);
     984:	4505                	li	a0,1
     986:	00005097          	auipc	ra,0x5
     98a:	c88080e7          	jalr	-888(ra) # 560e <exit>
    printf("%s: unlink small failed\n", s);
     98e:	85da                	mv	a1,s6
     990:	00006517          	auipc	a0,0x6
     994:	8a050513          	addi	a0,a0,-1888 # 6230 <malloc+0x7e4>
     998:	00005097          	auipc	ra,0x5
     99c:	ff6080e7          	jalr	-10(ra) # 598e <printf>
    exit(1);
     9a0:	4505                	li	a0,1
     9a2:	00005097          	auipc	ra,0x5
     9a6:	c6c080e7          	jalr	-916(ra) # 560e <exit>

00000000000009aa <writebig>:
{
     9aa:	7139                	addi	sp,sp,-64
     9ac:	fc06                	sd	ra,56(sp)
     9ae:	f822                	sd	s0,48(sp)
     9b0:	f426                	sd	s1,40(sp)
     9b2:	f04a                	sd	s2,32(sp)
     9b4:	ec4e                	sd	s3,24(sp)
     9b6:	e852                	sd	s4,16(sp)
     9b8:	e456                	sd	s5,8(sp)
     9ba:	0080                	addi	s0,sp,64
     9bc:	8aaa                	mv	s5,a0
  fd = open("big", O_CREATE|O_RDWR);
     9be:	20200593          	li	a1,514
     9c2:	00006517          	auipc	a0,0x6
     9c6:	88e50513          	addi	a0,a0,-1906 # 6250 <malloc+0x804>
     9ca:	00005097          	auipc	ra,0x5
     9ce:	c84080e7          	jalr	-892(ra) # 564e <open>
  if(fd < 0){
     9d2:	08054563          	bltz	a0,a5c <writebig+0xb2>
     9d6:	89aa                	mv	s3,a0
     9d8:	4481                	li	s1,0
    ((int*)buf)[0] = i;
     9da:	0000b917          	auipc	s2,0xb
     9de:	0c690913          	addi	s2,s2,198 # baa0 <buf>
  for(i = 0; i < MAXFILE; i++){
     9e2:	6a41                	lui	s4,0x10
     9e4:	10ba0a13          	addi	s4,s4,267 # 1010b <__BSS_END__+0x165b>
    ((int*)buf)[0] = i;
     9e8:	00992023          	sw	s1,0(s2)
    if(write(fd, buf, BSIZE) != BSIZE){
     9ec:	40000613          	li	a2,1024
     9f0:	85ca                	mv	a1,s2
     9f2:	854e                	mv	a0,s3
     9f4:	00005097          	auipc	ra,0x5
     9f8:	c3a080e7          	jalr	-966(ra) # 562e <write>
     9fc:	40000793          	li	a5,1024
     a00:	06f51c63          	bne	a0,a5,a78 <writebig+0xce>
  for(i = 0; i < MAXFILE; i++){
     a04:	2485                	addiw	s1,s1,1
     a06:	ff4491e3          	bne	s1,s4,9e8 <writebig+0x3e>
  close(fd);
     a0a:	854e                	mv	a0,s3
     a0c:	00005097          	auipc	ra,0x5
     a10:	c2a080e7          	jalr	-982(ra) # 5636 <close>
  fd = open("big", O_RDONLY);
     a14:	4581                	li	a1,0
     a16:	00006517          	auipc	a0,0x6
     a1a:	83a50513          	addi	a0,a0,-1990 # 6250 <malloc+0x804>
     a1e:	00005097          	auipc	ra,0x5
     a22:	c30080e7          	jalr	-976(ra) # 564e <open>
     a26:	89aa                	mv	s3,a0
  n = 0;
     a28:	4481                	li	s1,0
    i = read(fd, buf, BSIZE);
     a2a:	0000b917          	auipc	s2,0xb
     a2e:	07690913          	addi	s2,s2,118 # baa0 <buf>
  if(fd < 0){
     a32:	06054263          	bltz	a0,a96 <writebig+0xec>
    i = read(fd, buf, BSIZE);
     a36:	40000613          	li	a2,1024
     a3a:	85ca                	mv	a1,s2
     a3c:	854e                	mv	a0,s3
     a3e:	00005097          	auipc	ra,0x5
     a42:	be8080e7          	jalr	-1048(ra) # 5626 <read>
    if(i == 0){
     a46:	c535                	beqz	a0,ab2 <writebig+0x108>
    } else if(i != BSIZE){
     a48:	40000793          	li	a5,1024
     a4c:	0af51f63          	bne	a0,a5,b0a <writebig+0x160>
    if(((int*)buf)[0] != n){
     a50:	00092683          	lw	a3,0(s2)
     a54:	0c969a63          	bne	a3,s1,b28 <writebig+0x17e>
    n++;
     a58:	2485                	addiw	s1,s1,1
    i = read(fd, buf, BSIZE);
     a5a:	bff1                	j	a36 <writebig+0x8c>
    printf("%s: error: creat big failed!\n", s);
     a5c:	85d6                	mv	a1,s5
     a5e:	00005517          	auipc	a0,0x5
     a62:	7fa50513          	addi	a0,a0,2042 # 6258 <malloc+0x80c>
     a66:	00005097          	auipc	ra,0x5
     a6a:	f28080e7          	jalr	-216(ra) # 598e <printf>
    exit(1);
     a6e:	4505                	li	a0,1
     a70:	00005097          	auipc	ra,0x5
     a74:	b9e080e7          	jalr	-1122(ra) # 560e <exit>
      printf("%s: error: write big file failed\n", s, i);
     a78:	8626                	mv	a2,s1
     a7a:	85d6                	mv	a1,s5
     a7c:	00005517          	auipc	a0,0x5
     a80:	7fc50513          	addi	a0,a0,2044 # 6278 <malloc+0x82c>
     a84:	00005097          	auipc	ra,0x5
     a88:	f0a080e7          	jalr	-246(ra) # 598e <printf>
      exit(1);
     a8c:	4505                	li	a0,1
     a8e:	00005097          	auipc	ra,0x5
     a92:	b80080e7          	jalr	-1152(ra) # 560e <exit>
    printf("%s: error: open big failed!\n", s);
     a96:	85d6                	mv	a1,s5
     a98:	00006517          	auipc	a0,0x6
     a9c:	80850513          	addi	a0,a0,-2040 # 62a0 <malloc+0x854>
     aa0:	00005097          	auipc	ra,0x5
     aa4:	eee080e7          	jalr	-274(ra) # 598e <printf>
    exit(1);
     aa8:	4505                	li	a0,1
     aaa:	00005097          	auipc	ra,0x5
     aae:	b64080e7          	jalr	-1180(ra) # 560e <exit>
      if(n == MAXFILE - 1){
     ab2:	67c1                	lui	a5,0x10
     ab4:	10a78793          	addi	a5,a5,266 # 1010a <__BSS_END__+0x165a>
     ab8:	02f48a63          	beq	s1,a5,aec <writebig+0x142>
  close(fd);
     abc:	854e                	mv	a0,s3
     abe:	00005097          	auipc	ra,0x5
     ac2:	b78080e7          	jalr	-1160(ra) # 5636 <close>
  if(unlink("big") < 0){
     ac6:	00005517          	auipc	a0,0x5
     aca:	78a50513          	addi	a0,a0,1930 # 6250 <malloc+0x804>
     ace:	00005097          	auipc	ra,0x5
     ad2:	b90080e7          	jalr	-1136(ra) # 565e <unlink>
     ad6:	06054863          	bltz	a0,b46 <writebig+0x19c>
}
     ada:	70e2                	ld	ra,56(sp)
     adc:	7442                	ld	s0,48(sp)
     ade:	74a2                	ld	s1,40(sp)
     ae0:	7902                	ld	s2,32(sp)
     ae2:	69e2                	ld	s3,24(sp)
     ae4:	6a42                	ld	s4,16(sp)
     ae6:	6aa2                	ld	s5,8(sp)
     ae8:	6121                	addi	sp,sp,64
     aea:	8082                	ret
        printf("%s: read only %d blocks from big", s, n);
     aec:	863e                	mv	a2,a5
     aee:	85d6                	mv	a1,s5
     af0:	00005517          	auipc	a0,0x5
     af4:	7d050513          	addi	a0,a0,2000 # 62c0 <malloc+0x874>
     af8:	00005097          	auipc	ra,0x5
     afc:	e96080e7          	jalr	-362(ra) # 598e <printf>
        exit(1);
     b00:	4505                	li	a0,1
     b02:	00005097          	auipc	ra,0x5
     b06:	b0c080e7          	jalr	-1268(ra) # 560e <exit>
      printf("%s: read failed %d\n", s, i);
     b0a:	862a                	mv	a2,a0
     b0c:	85d6                	mv	a1,s5
     b0e:	00005517          	auipc	a0,0x5
     b12:	7da50513          	addi	a0,a0,2010 # 62e8 <malloc+0x89c>
     b16:	00005097          	auipc	ra,0x5
     b1a:	e78080e7          	jalr	-392(ra) # 598e <printf>
      exit(1);
     b1e:	4505                	li	a0,1
     b20:	00005097          	auipc	ra,0x5
     b24:	aee080e7          	jalr	-1298(ra) # 560e <exit>
      printf("%s: read content of block %d is %d\n", s,
     b28:	8626                	mv	a2,s1
     b2a:	85d6                	mv	a1,s5
     b2c:	00005517          	auipc	a0,0x5
     b30:	7d450513          	addi	a0,a0,2004 # 6300 <malloc+0x8b4>
     b34:	00005097          	auipc	ra,0x5
     b38:	e5a080e7          	jalr	-422(ra) # 598e <printf>
      exit(1);
     b3c:	4505                	li	a0,1
     b3e:	00005097          	auipc	ra,0x5
     b42:	ad0080e7          	jalr	-1328(ra) # 560e <exit>
    printf("%s: unlink big failed\n", s);
     b46:	85d6                	mv	a1,s5
     b48:	00005517          	auipc	a0,0x5
     b4c:	7e050513          	addi	a0,a0,2016 # 6328 <malloc+0x8dc>
     b50:	00005097          	auipc	ra,0x5
     b54:	e3e080e7          	jalr	-450(ra) # 598e <printf>
    exit(1);
     b58:	4505                	li	a0,1
     b5a:	00005097          	auipc	ra,0x5
     b5e:	ab4080e7          	jalr	-1356(ra) # 560e <exit>

0000000000000b62 <unlinkread>:
{
     b62:	7179                	addi	sp,sp,-48
     b64:	f406                	sd	ra,40(sp)
     b66:	f022                	sd	s0,32(sp)
     b68:	ec26                	sd	s1,24(sp)
     b6a:	e84a                	sd	s2,16(sp)
     b6c:	e44e                	sd	s3,8(sp)
     b6e:	1800                	addi	s0,sp,48
     b70:	89aa                	mv	s3,a0
  fd = open("unlinkread", O_CREATE | O_RDWR);
     b72:	20200593          	li	a1,514
     b76:	00005517          	auipc	a0,0x5
     b7a:	11a50513          	addi	a0,a0,282 # 5c90 <malloc+0x244>
     b7e:	00005097          	auipc	ra,0x5
     b82:	ad0080e7          	jalr	-1328(ra) # 564e <open>
  if(fd < 0){
     b86:	0e054563          	bltz	a0,c70 <unlinkread+0x10e>
     b8a:	84aa                	mv	s1,a0
  write(fd, "hello", SZ);
     b8c:	4615                	li	a2,5
     b8e:	00005597          	auipc	a1,0x5
     b92:	7d258593          	addi	a1,a1,2002 # 6360 <malloc+0x914>
     b96:	00005097          	auipc	ra,0x5
     b9a:	a98080e7          	jalr	-1384(ra) # 562e <write>
  close(fd);
     b9e:	8526                	mv	a0,s1
     ba0:	00005097          	auipc	ra,0x5
     ba4:	a96080e7          	jalr	-1386(ra) # 5636 <close>
  fd = open("unlinkread", O_RDWR);
     ba8:	4589                	li	a1,2
     baa:	00005517          	auipc	a0,0x5
     bae:	0e650513          	addi	a0,a0,230 # 5c90 <malloc+0x244>
     bb2:	00005097          	auipc	ra,0x5
     bb6:	a9c080e7          	jalr	-1380(ra) # 564e <open>
     bba:	84aa                	mv	s1,a0
  if(fd < 0){
     bbc:	0c054863          	bltz	a0,c8c <unlinkread+0x12a>
  if(unlink("unlinkread") != 0){
     bc0:	00005517          	auipc	a0,0x5
     bc4:	0d050513          	addi	a0,a0,208 # 5c90 <malloc+0x244>
     bc8:	00005097          	auipc	ra,0x5
     bcc:	a96080e7          	jalr	-1386(ra) # 565e <unlink>
     bd0:	ed61                	bnez	a0,ca8 <unlinkread+0x146>
  fd1 = open("unlinkread", O_CREATE | O_RDWR);
     bd2:	20200593          	li	a1,514
     bd6:	00005517          	auipc	a0,0x5
     bda:	0ba50513          	addi	a0,a0,186 # 5c90 <malloc+0x244>
     bde:	00005097          	auipc	ra,0x5
     be2:	a70080e7          	jalr	-1424(ra) # 564e <open>
     be6:	892a                	mv	s2,a0
  write(fd1, "yyy", 3);
     be8:	460d                	li	a2,3
     bea:	00005597          	auipc	a1,0x5
     bee:	7be58593          	addi	a1,a1,1982 # 63a8 <malloc+0x95c>
     bf2:	00005097          	auipc	ra,0x5
     bf6:	a3c080e7          	jalr	-1476(ra) # 562e <write>
  close(fd1);
     bfa:	854a                	mv	a0,s2
     bfc:	00005097          	auipc	ra,0x5
     c00:	a3a080e7          	jalr	-1478(ra) # 5636 <close>
  if(read(fd, buf, sizeof(buf)) != SZ){
     c04:	660d                	lui	a2,0x3
     c06:	0000b597          	auipc	a1,0xb
     c0a:	e9a58593          	addi	a1,a1,-358 # baa0 <buf>
     c0e:	8526                	mv	a0,s1
     c10:	00005097          	auipc	ra,0x5
     c14:	a16080e7          	jalr	-1514(ra) # 5626 <read>
     c18:	4795                	li	a5,5
     c1a:	0af51563          	bne	a0,a5,cc4 <unlinkread+0x162>
  if(buf[0] != 'h'){
     c1e:	0000b717          	auipc	a4,0xb
     c22:	e8274703          	lbu	a4,-382(a4) # baa0 <buf>
     c26:	06800793          	li	a5,104
     c2a:	0af71b63          	bne	a4,a5,ce0 <unlinkread+0x17e>
  if(write(fd, buf, 10) != 10){
     c2e:	4629                	li	a2,10
     c30:	0000b597          	auipc	a1,0xb
     c34:	e7058593          	addi	a1,a1,-400 # baa0 <buf>
     c38:	8526                	mv	a0,s1
     c3a:	00005097          	auipc	ra,0x5
     c3e:	9f4080e7          	jalr	-1548(ra) # 562e <write>
     c42:	47a9                	li	a5,10
     c44:	0af51c63          	bne	a0,a5,cfc <unlinkread+0x19a>
  close(fd);
     c48:	8526                	mv	a0,s1
     c4a:	00005097          	auipc	ra,0x5
     c4e:	9ec080e7          	jalr	-1556(ra) # 5636 <close>
  unlink("unlinkread");
     c52:	00005517          	auipc	a0,0x5
     c56:	03e50513          	addi	a0,a0,62 # 5c90 <malloc+0x244>
     c5a:	00005097          	auipc	ra,0x5
     c5e:	a04080e7          	jalr	-1532(ra) # 565e <unlink>
}
     c62:	70a2                	ld	ra,40(sp)
     c64:	7402                	ld	s0,32(sp)
     c66:	64e2                	ld	s1,24(sp)
     c68:	6942                	ld	s2,16(sp)
     c6a:	69a2                	ld	s3,8(sp)
     c6c:	6145                	addi	sp,sp,48
     c6e:	8082                	ret
    printf("%s: create unlinkread failed\n", s);
     c70:	85ce                	mv	a1,s3
     c72:	00005517          	auipc	a0,0x5
     c76:	6ce50513          	addi	a0,a0,1742 # 6340 <malloc+0x8f4>
     c7a:	00005097          	auipc	ra,0x5
     c7e:	d14080e7          	jalr	-748(ra) # 598e <printf>
    exit(1);
     c82:	4505                	li	a0,1
     c84:	00005097          	auipc	ra,0x5
     c88:	98a080e7          	jalr	-1654(ra) # 560e <exit>
    printf("%s: open unlinkread failed\n", s);
     c8c:	85ce                	mv	a1,s3
     c8e:	00005517          	auipc	a0,0x5
     c92:	6da50513          	addi	a0,a0,1754 # 6368 <malloc+0x91c>
     c96:	00005097          	auipc	ra,0x5
     c9a:	cf8080e7          	jalr	-776(ra) # 598e <printf>
    exit(1);
     c9e:	4505                	li	a0,1
     ca0:	00005097          	auipc	ra,0x5
     ca4:	96e080e7          	jalr	-1682(ra) # 560e <exit>
    printf("%s: unlink unlinkread failed\n", s);
     ca8:	85ce                	mv	a1,s3
     caa:	00005517          	auipc	a0,0x5
     cae:	6de50513          	addi	a0,a0,1758 # 6388 <malloc+0x93c>
     cb2:	00005097          	auipc	ra,0x5
     cb6:	cdc080e7          	jalr	-804(ra) # 598e <printf>
    exit(1);
     cba:	4505                	li	a0,1
     cbc:	00005097          	auipc	ra,0x5
     cc0:	952080e7          	jalr	-1710(ra) # 560e <exit>
    printf("%s: unlinkread read failed", s);
     cc4:	85ce                	mv	a1,s3
     cc6:	00005517          	auipc	a0,0x5
     cca:	6ea50513          	addi	a0,a0,1770 # 63b0 <malloc+0x964>
     cce:	00005097          	auipc	ra,0x5
     cd2:	cc0080e7          	jalr	-832(ra) # 598e <printf>
    exit(1);
     cd6:	4505                	li	a0,1
     cd8:	00005097          	auipc	ra,0x5
     cdc:	936080e7          	jalr	-1738(ra) # 560e <exit>
    printf("%s: unlinkread wrong data\n", s);
     ce0:	85ce                	mv	a1,s3
     ce2:	00005517          	auipc	a0,0x5
     ce6:	6ee50513          	addi	a0,a0,1774 # 63d0 <malloc+0x984>
     cea:	00005097          	auipc	ra,0x5
     cee:	ca4080e7          	jalr	-860(ra) # 598e <printf>
    exit(1);
     cf2:	4505                	li	a0,1
     cf4:	00005097          	auipc	ra,0x5
     cf8:	91a080e7          	jalr	-1766(ra) # 560e <exit>
    printf("%s: unlinkread write failed\n", s);
     cfc:	85ce                	mv	a1,s3
     cfe:	00005517          	auipc	a0,0x5
     d02:	6f250513          	addi	a0,a0,1778 # 63f0 <malloc+0x9a4>
     d06:	00005097          	auipc	ra,0x5
     d0a:	c88080e7          	jalr	-888(ra) # 598e <printf>
    exit(1);
     d0e:	4505                	li	a0,1
     d10:	00005097          	auipc	ra,0x5
     d14:	8fe080e7          	jalr	-1794(ra) # 560e <exit>

0000000000000d18 <linktest>:
{
     d18:	1101                	addi	sp,sp,-32
     d1a:	ec06                	sd	ra,24(sp)
     d1c:	e822                	sd	s0,16(sp)
     d1e:	e426                	sd	s1,8(sp)
     d20:	e04a                	sd	s2,0(sp)
     d22:	1000                	addi	s0,sp,32
     d24:	892a                	mv	s2,a0
  unlink("lf1");
     d26:	00005517          	auipc	a0,0x5
     d2a:	6ea50513          	addi	a0,a0,1770 # 6410 <malloc+0x9c4>
     d2e:	00005097          	auipc	ra,0x5
     d32:	930080e7          	jalr	-1744(ra) # 565e <unlink>
  unlink("lf2");
     d36:	00005517          	auipc	a0,0x5
     d3a:	6e250513          	addi	a0,a0,1762 # 6418 <malloc+0x9cc>
     d3e:	00005097          	auipc	ra,0x5
     d42:	920080e7          	jalr	-1760(ra) # 565e <unlink>
  fd = open("lf1", O_CREATE|O_RDWR);
     d46:	20200593          	li	a1,514
     d4a:	00005517          	auipc	a0,0x5
     d4e:	6c650513          	addi	a0,a0,1734 # 6410 <malloc+0x9c4>
     d52:	00005097          	auipc	ra,0x5
     d56:	8fc080e7          	jalr	-1796(ra) # 564e <open>
  if(fd < 0){
     d5a:	10054763          	bltz	a0,e68 <linktest+0x150>
     d5e:	84aa                	mv	s1,a0
  if(write(fd, "hello", SZ) != SZ){
     d60:	4615                	li	a2,5
     d62:	00005597          	auipc	a1,0x5
     d66:	5fe58593          	addi	a1,a1,1534 # 6360 <malloc+0x914>
     d6a:	00005097          	auipc	ra,0x5
     d6e:	8c4080e7          	jalr	-1852(ra) # 562e <write>
     d72:	4795                	li	a5,5
     d74:	10f51863          	bne	a0,a5,e84 <linktest+0x16c>
  close(fd);
     d78:	8526                	mv	a0,s1
     d7a:	00005097          	auipc	ra,0x5
     d7e:	8bc080e7          	jalr	-1860(ra) # 5636 <close>
  if(link("lf1", "lf2") < 0){
     d82:	00005597          	auipc	a1,0x5
     d86:	69658593          	addi	a1,a1,1686 # 6418 <malloc+0x9cc>
     d8a:	00005517          	auipc	a0,0x5
     d8e:	68650513          	addi	a0,a0,1670 # 6410 <malloc+0x9c4>
     d92:	00005097          	auipc	ra,0x5
     d96:	8dc080e7          	jalr	-1828(ra) # 566e <link>
     d9a:	10054363          	bltz	a0,ea0 <linktest+0x188>
  unlink("lf1");
     d9e:	00005517          	auipc	a0,0x5
     da2:	67250513          	addi	a0,a0,1650 # 6410 <malloc+0x9c4>
     da6:	00005097          	auipc	ra,0x5
     daa:	8b8080e7          	jalr	-1864(ra) # 565e <unlink>
  if(open("lf1", 0) >= 0){
     dae:	4581                	li	a1,0
     db0:	00005517          	auipc	a0,0x5
     db4:	66050513          	addi	a0,a0,1632 # 6410 <malloc+0x9c4>
     db8:	00005097          	auipc	ra,0x5
     dbc:	896080e7          	jalr	-1898(ra) # 564e <open>
     dc0:	0e055e63          	bgez	a0,ebc <linktest+0x1a4>
  fd = open("lf2", 0);
     dc4:	4581                	li	a1,0
     dc6:	00005517          	auipc	a0,0x5
     dca:	65250513          	addi	a0,a0,1618 # 6418 <malloc+0x9cc>
     dce:	00005097          	auipc	ra,0x5
     dd2:	880080e7          	jalr	-1920(ra) # 564e <open>
     dd6:	84aa                	mv	s1,a0
  if(fd < 0){
     dd8:	10054063          	bltz	a0,ed8 <linktest+0x1c0>
  if(read(fd, buf, sizeof(buf)) != SZ){
     ddc:	660d                	lui	a2,0x3
     dde:	0000b597          	auipc	a1,0xb
     de2:	cc258593          	addi	a1,a1,-830 # baa0 <buf>
     de6:	00005097          	auipc	ra,0x5
     dea:	840080e7          	jalr	-1984(ra) # 5626 <read>
     dee:	4795                	li	a5,5
     df0:	10f51263          	bne	a0,a5,ef4 <linktest+0x1dc>
  close(fd);
     df4:	8526                	mv	a0,s1
     df6:	00005097          	auipc	ra,0x5
     dfa:	840080e7          	jalr	-1984(ra) # 5636 <close>
  if(link("lf2", "lf2") >= 0){
     dfe:	00005597          	auipc	a1,0x5
     e02:	61a58593          	addi	a1,a1,1562 # 6418 <malloc+0x9cc>
     e06:	852e                	mv	a0,a1
     e08:	00005097          	auipc	ra,0x5
     e0c:	866080e7          	jalr	-1946(ra) # 566e <link>
     e10:	10055063          	bgez	a0,f10 <linktest+0x1f8>
  unlink("lf2");
     e14:	00005517          	auipc	a0,0x5
     e18:	60450513          	addi	a0,a0,1540 # 6418 <malloc+0x9cc>
     e1c:	00005097          	auipc	ra,0x5
     e20:	842080e7          	jalr	-1982(ra) # 565e <unlink>
  if(link("lf2", "lf1") >= 0){
     e24:	00005597          	auipc	a1,0x5
     e28:	5ec58593          	addi	a1,a1,1516 # 6410 <malloc+0x9c4>
     e2c:	00005517          	auipc	a0,0x5
     e30:	5ec50513          	addi	a0,a0,1516 # 6418 <malloc+0x9cc>
     e34:	00005097          	auipc	ra,0x5
     e38:	83a080e7          	jalr	-1990(ra) # 566e <link>
     e3c:	0e055863          	bgez	a0,f2c <linktest+0x214>
  if(link(".", "lf1") >= 0){
     e40:	00005597          	auipc	a1,0x5
     e44:	5d058593          	addi	a1,a1,1488 # 6410 <malloc+0x9c4>
     e48:	00005517          	auipc	a0,0x5
     e4c:	6d850513          	addi	a0,a0,1752 # 6520 <malloc+0xad4>
     e50:	00005097          	auipc	ra,0x5
     e54:	81e080e7          	jalr	-2018(ra) # 566e <link>
     e58:	0e055863          	bgez	a0,f48 <linktest+0x230>
}
     e5c:	60e2                	ld	ra,24(sp)
     e5e:	6442                	ld	s0,16(sp)
     e60:	64a2                	ld	s1,8(sp)
     e62:	6902                	ld	s2,0(sp)
     e64:	6105                	addi	sp,sp,32
     e66:	8082                	ret
    printf("%s: create lf1 failed\n", s);
     e68:	85ca                	mv	a1,s2
     e6a:	00005517          	auipc	a0,0x5
     e6e:	5b650513          	addi	a0,a0,1462 # 6420 <malloc+0x9d4>
     e72:	00005097          	auipc	ra,0x5
     e76:	b1c080e7          	jalr	-1252(ra) # 598e <printf>
    exit(1);
     e7a:	4505                	li	a0,1
     e7c:	00004097          	auipc	ra,0x4
     e80:	792080e7          	jalr	1938(ra) # 560e <exit>
    printf("%s: write lf1 failed\n", s);
     e84:	85ca                	mv	a1,s2
     e86:	00005517          	auipc	a0,0x5
     e8a:	5b250513          	addi	a0,a0,1458 # 6438 <malloc+0x9ec>
     e8e:	00005097          	auipc	ra,0x5
     e92:	b00080e7          	jalr	-1280(ra) # 598e <printf>
    exit(1);
     e96:	4505                	li	a0,1
     e98:	00004097          	auipc	ra,0x4
     e9c:	776080e7          	jalr	1910(ra) # 560e <exit>
    printf("%s: link lf1 lf2 failed\n", s);
     ea0:	85ca                	mv	a1,s2
     ea2:	00005517          	auipc	a0,0x5
     ea6:	5ae50513          	addi	a0,a0,1454 # 6450 <malloc+0xa04>
     eaa:	00005097          	auipc	ra,0x5
     eae:	ae4080e7          	jalr	-1308(ra) # 598e <printf>
    exit(1);
     eb2:	4505                	li	a0,1
     eb4:	00004097          	auipc	ra,0x4
     eb8:	75a080e7          	jalr	1882(ra) # 560e <exit>
    printf("%s: unlinked lf1 but it is still there!\n", s);
     ebc:	85ca                	mv	a1,s2
     ebe:	00005517          	auipc	a0,0x5
     ec2:	5b250513          	addi	a0,a0,1458 # 6470 <malloc+0xa24>
     ec6:	00005097          	auipc	ra,0x5
     eca:	ac8080e7          	jalr	-1336(ra) # 598e <printf>
    exit(1);
     ece:	4505                	li	a0,1
     ed0:	00004097          	auipc	ra,0x4
     ed4:	73e080e7          	jalr	1854(ra) # 560e <exit>
    printf("%s: open lf2 failed\n", s);
     ed8:	85ca                	mv	a1,s2
     eda:	00005517          	auipc	a0,0x5
     ede:	5c650513          	addi	a0,a0,1478 # 64a0 <malloc+0xa54>
     ee2:	00005097          	auipc	ra,0x5
     ee6:	aac080e7          	jalr	-1364(ra) # 598e <printf>
    exit(1);
     eea:	4505                	li	a0,1
     eec:	00004097          	auipc	ra,0x4
     ef0:	722080e7          	jalr	1826(ra) # 560e <exit>
    printf("%s: read lf2 failed\n", s);
     ef4:	85ca                	mv	a1,s2
     ef6:	00005517          	auipc	a0,0x5
     efa:	5c250513          	addi	a0,a0,1474 # 64b8 <malloc+0xa6c>
     efe:	00005097          	auipc	ra,0x5
     f02:	a90080e7          	jalr	-1392(ra) # 598e <printf>
    exit(1);
     f06:	4505                	li	a0,1
     f08:	00004097          	auipc	ra,0x4
     f0c:	706080e7          	jalr	1798(ra) # 560e <exit>
    printf("%s: link lf2 lf2 succeeded! oops\n", s);
     f10:	85ca                	mv	a1,s2
     f12:	00005517          	auipc	a0,0x5
     f16:	5be50513          	addi	a0,a0,1470 # 64d0 <malloc+0xa84>
     f1a:	00005097          	auipc	ra,0x5
     f1e:	a74080e7          	jalr	-1420(ra) # 598e <printf>
    exit(1);
     f22:	4505                	li	a0,1
     f24:	00004097          	auipc	ra,0x4
     f28:	6ea080e7          	jalr	1770(ra) # 560e <exit>
    printf("%s: link non-existant succeeded! oops\n", s);
     f2c:	85ca                	mv	a1,s2
     f2e:	00005517          	auipc	a0,0x5
     f32:	5ca50513          	addi	a0,a0,1482 # 64f8 <malloc+0xaac>
     f36:	00005097          	auipc	ra,0x5
     f3a:	a58080e7          	jalr	-1448(ra) # 598e <printf>
    exit(1);
     f3e:	4505                	li	a0,1
     f40:	00004097          	auipc	ra,0x4
     f44:	6ce080e7          	jalr	1742(ra) # 560e <exit>
    printf("%s: link . lf1 succeeded! oops\n", s);
     f48:	85ca                	mv	a1,s2
     f4a:	00005517          	auipc	a0,0x5
     f4e:	5de50513          	addi	a0,a0,1502 # 6528 <malloc+0xadc>
     f52:	00005097          	auipc	ra,0x5
     f56:	a3c080e7          	jalr	-1476(ra) # 598e <printf>
    exit(1);
     f5a:	4505                	li	a0,1
     f5c:	00004097          	auipc	ra,0x4
     f60:	6b2080e7          	jalr	1714(ra) # 560e <exit>

0000000000000f64 <bigdir>:
{
     f64:	715d                	addi	sp,sp,-80
     f66:	e486                	sd	ra,72(sp)
     f68:	e0a2                	sd	s0,64(sp)
     f6a:	fc26                	sd	s1,56(sp)
     f6c:	f84a                	sd	s2,48(sp)
     f6e:	f44e                	sd	s3,40(sp)
     f70:	f052                	sd	s4,32(sp)
     f72:	ec56                	sd	s5,24(sp)
     f74:	e85a                	sd	s6,16(sp)
     f76:	0880                	addi	s0,sp,80
     f78:	89aa                	mv	s3,a0
  unlink("bd");
     f7a:	00005517          	auipc	a0,0x5
     f7e:	5ce50513          	addi	a0,a0,1486 # 6548 <malloc+0xafc>
     f82:	00004097          	auipc	ra,0x4
     f86:	6dc080e7          	jalr	1756(ra) # 565e <unlink>
  fd = open("bd", O_CREATE);
     f8a:	20000593          	li	a1,512
     f8e:	00005517          	auipc	a0,0x5
     f92:	5ba50513          	addi	a0,a0,1466 # 6548 <malloc+0xafc>
     f96:	00004097          	auipc	ra,0x4
     f9a:	6b8080e7          	jalr	1720(ra) # 564e <open>
  if(fd < 0){
     f9e:	0c054963          	bltz	a0,1070 <bigdir+0x10c>
  close(fd);
     fa2:	00004097          	auipc	ra,0x4
     fa6:	694080e7          	jalr	1684(ra) # 5636 <close>
  for(i = 0; i < N; i++){
     faa:	4901                	li	s2,0
    name[0] = 'x';
     fac:	07800a93          	li	s5,120
    if(link("bd", name) != 0){
     fb0:	00005a17          	auipc	s4,0x5
     fb4:	598a0a13          	addi	s4,s4,1432 # 6548 <malloc+0xafc>
  for(i = 0; i < N; i++){
     fb8:	1f400b13          	li	s6,500
    name[0] = 'x';
     fbc:	fb540823          	sb	s5,-80(s0)
    name[1] = '0' + (i / 64);
     fc0:	41f9579b          	sraiw	a5,s2,0x1f
     fc4:	01a7d71b          	srliw	a4,a5,0x1a
     fc8:	012707bb          	addw	a5,a4,s2
     fcc:	4067d69b          	sraiw	a3,a5,0x6
     fd0:	0306869b          	addiw	a3,a3,48
     fd4:	fad408a3          	sb	a3,-79(s0)
    name[2] = '0' + (i % 64);
     fd8:	03f7f793          	andi	a5,a5,63
     fdc:	9f99                	subw	a5,a5,a4
     fde:	0307879b          	addiw	a5,a5,48
     fe2:	faf40923          	sb	a5,-78(s0)
    name[3] = '\0';
     fe6:	fa0409a3          	sb	zero,-77(s0)
    if(link("bd", name) != 0){
     fea:	fb040593          	addi	a1,s0,-80
     fee:	8552                	mv	a0,s4
     ff0:	00004097          	auipc	ra,0x4
     ff4:	67e080e7          	jalr	1662(ra) # 566e <link>
     ff8:	84aa                	mv	s1,a0
     ffa:	e949                	bnez	a0,108c <bigdir+0x128>
  for(i = 0; i < N; i++){
     ffc:	2905                	addiw	s2,s2,1
     ffe:	fb691fe3          	bne	s2,s6,fbc <bigdir+0x58>
  unlink("bd");
    1002:	00005517          	auipc	a0,0x5
    1006:	54650513          	addi	a0,a0,1350 # 6548 <malloc+0xafc>
    100a:	00004097          	auipc	ra,0x4
    100e:	654080e7          	jalr	1620(ra) # 565e <unlink>
    name[0] = 'x';
    1012:	07800913          	li	s2,120
  for(i = 0; i < N; i++){
    1016:	1f400a13          	li	s4,500
    name[0] = 'x';
    101a:	fb240823          	sb	s2,-80(s0)
    name[1] = '0' + (i / 64);
    101e:	41f4d79b          	sraiw	a5,s1,0x1f
    1022:	01a7d71b          	srliw	a4,a5,0x1a
    1026:	009707bb          	addw	a5,a4,s1
    102a:	4067d69b          	sraiw	a3,a5,0x6
    102e:	0306869b          	addiw	a3,a3,48
    1032:	fad408a3          	sb	a3,-79(s0)
    name[2] = '0' + (i % 64);
    1036:	03f7f793          	andi	a5,a5,63
    103a:	9f99                	subw	a5,a5,a4
    103c:	0307879b          	addiw	a5,a5,48
    1040:	faf40923          	sb	a5,-78(s0)
    name[3] = '\0';
    1044:	fa0409a3          	sb	zero,-77(s0)
    if(unlink(name) != 0){
    1048:	fb040513          	addi	a0,s0,-80
    104c:	00004097          	auipc	ra,0x4
    1050:	612080e7          	jalr	1554(ra) # 565e <unlink>
    1054:	ed21                	bnez	a0,10ac <bigdir+0x148>
  for(i = 0; i < N; i++){
    1056:	2485                	addiw	s1,s1,1
    1058:	fd4491e3          	bne	s1,s4,101a <bigdir+0xb6>
}
    105c:	60a6                	ld	ra,72(sp)
    105e:	6406                	ld	s0,64(sp)
    1060:	74e2                	ld	s1,56(sp)
    1062:	7942                	ld	s2,48(sp)
    1064:	79a2                	ld	s3,40(sp)
    1066:	7a02                	ld	s4,32(sp)
    1068:	6ae2                	ld	s5,24(sp)
    106a:	6b42                	ld	s6,16(sp)
    106c:	6161                	addi	sp,sp,80
    106e:	8082                	ret
    printf("%s: bigdir create failed\n", s);
    1070:	85ce                	mv	a1,s3
    1072:	00005517          	auipc	a0,0x5
    1076:	4de50513          	addi	a0,a0,1246 # 6550 <malloc+0xb04>
    107a:	00005097          	auipc	ra,0x5
    107e:	914080e7          	jalr	-1772(ra) # 598e <printf>
    exit(1);
    1082:	4505                	li	a0,1
    1084:	00004097          	auipc	ra,0x4
    1088:	58a080e7          	jalr	1418(ra) # 560e <exit>
      printf("%s: bigdir link(bd, %s) failed\n", s, name);
    108c:	fb040613          	addi	a2,s0,-80
    1090:	85ce                	mv	a1,s3
    1092:	00005517          	auipc	a0,0x5
    1096:	4de50513          	addi	a0,a0,1246 # 6570 <malloc+0xb24>
    109a:	00005097          	auipc	ra,0x5
    109e:	8f4080e7          	jalr	-1804(ra) # 598e <printf>
      exit(1);
    10a2:	4505                	li	a0,1
    10a4:	00004097          	auipc	ra,0x4
    10a8:	56a080e7          	jalr	1386(ra) # 560e <exit>
      printf("%s: bigdir unlink failed", s);
    10ac:	85ce                	mv	a1,s3
    10ae:	00005517          	auipc	a0,0x5
    10b2:	4e250513          	addi	a0,a0,1250 # 6590 <malloc+0xb44>
    10b6:	00005097          	auipc	ra,0x5
    10ba:	8d8080e7          	jalr	-1832(ra) # 598e <printf>
      exit(1);
    10be:	4505                	li	a0,1
    10c0:	00004097          	auipc	ra,0x4
    10c4:	54e080e7          	jalr	1358(ra) # 560e <exit>

00000000000010c8 <validatetest>:
{
    10c8:	7139                	addi	sp,sp,-64
    10ca:	fc06                	sd	ra,56(sp)
    10cc:	f822                	sd	s0,48(sp)
    10ce:	f426                	sd	s1,40(sp)
    10d0:	f04a                	sd	s2,32(sp)
    10d2:	ec4e                	sd	s3,24(sp)
    10d4:	e852                	sd	s4,16(sp)
    10d6:	e456                	sd	s5,8(sp)
    10d8:	e05a                	sd	s6,0(sp)
    10da:	0080                	addi	s0,sp,64
    10dc:	8b2a                	mv	s6,a0
  for(p = 0; p <= (uint)hi; p += PGSIZE){
    10de:	4481                	li	s1,0
    if(link("nosuchfile", (char*)p) != -1){
    10e0:	00005997          	auipc	s3,0x5
    10e4:	4d098993          	addi	s3,s3,1232 # 65b0 <malloc+0xb64>
    10e8:	597d                	li	s2,-1
  for(p = 0; p <= (uint)hi; p += PGSIZE){
    10ea:	6a85                	lui	s5,0x1
    10ec:	00114a37          	lui	s4,0x114
    if(link("nosuchfile", (char*)p) != -1){
    10f0:	85a6                	mv	a1,s1
    10f2:	854e                	mv	a0,s3
    10f4:	00004097          	auipc	ra,0x4
    10f8:	57a080e7          	jalr	1402(ra) # 566e <link>
    10fc:	01251f63          	bne	a0,s2,111a <validatetest+0x52>
  for(p = 0; p <= (uint)hi; p += PGSIZE){
    1100:	94d6                	add	s1,s1,s5
    1102:	ff4497e3          	bne	s1,s4,10f0 <validatetest+0x28>
}
    1106:	70e2                	ld	ra,56(sp)
    1108:	7442                	ld	s0,48(sp)
    110a:	74a2                	ld	s1,40(sp)
    110c:	7902                	ld	s2,32(sp)
    110e:	69e2                	ld	s3,24(sp)
    1110:	6a42                	ld	s4,16(sp)
    1112:	6aa2                	ld	s5,8(sp)
    1114:	6b02                	ld	s6,0(sp)
    1116:	6121                	addi	sp,sp,64
    1118:	8082                	ret
      printf("%s: link should not succeed\n", s);
    111a:	85da                	mv	a1,s6
    111c:	00005517          	auipc	a0,0x5
    1120:	4a450513          	addi	a0,a0,1188 # 65c0 <malloc+0xb74>
    1124:	00005097          	auipc	ra,0x5
    1128:	86a080e7          	jalr	-1942(ra) # 598e <printf>
      exit(1);
    112c:	4505                	li	a0,1
    112e:	00004097          	auipc	ra,0x4
    1132:	4e0080e7          	jalr	1248(ra) # 560e <exit>

0000000000001136 <pgbug>:
// regression test. copyin(), copyout(), and copyinstr() used to cast
// the virtual page address to uint, which (with certain wild system
// call arguments) resulted in a kernel page faults.
void
pgbug(char *s)
{
    1136:	7179                	addi	sp,sp,-48
    1138:	f406                	sd	ra,40(sp)
    113a:	f022                	sd	s0,32(sp)
    113c:	ec26                	sd	s1,24(sp)
    113e:	1800                	addi	s0,sp,48
  char *argv[1];
  argv[0] = 0;
    1140:	fc043c23          	sd	zero,-40(s0)
  exec((char*)0xeaeb0b5b00002f5e, argv);
    1144:	00007497          	auipc	s1,0x7
    1148:	12c4b483          	ld	s1,300(s1) # 8270 <__SDATA_BEGIN__>
    114c:	fd840593          	addi	a1,s0,-40
    1150:	8526                	mv	a0,s1
    1152:	00004097          	auipc	ra,0x4
    1156:	4f4080e7          	jalr	1268(ra) # 5646 <exec>

  pipe((int*)0xeaeb0b5b00002f5e);
    115a:	8526                	mv	a0,s1
    115c:	00004097          	auipc	ra,0x4
    1160:	4c2080e7          	jalr	1218(ra) # 561e <pipe>

  exit(0);
    1164:	4501                	li	a0,0
    1166:	00004097          	auipc	ra,0x4
    116a:	4a8080e7          	jalr	1192(ra) # 560e <exit>

000000000000116e <badarg>:

// regression test. test whether exec() leaks memory if one of the
// arguments is invalid. the test passes if the kernel doesn't panic.
void
badarg(char *s)
{
    116e:	7139                	addi	sp,sp,-64
    1170:	fc06                	sd	ra,56(sp)
    1172:	f822                	sd	s0,48(sp)
    1174:	f426                	sd	s1,40(sp)
    1176:	f04a                	sd	s2,32(sp)
    1178:	ec4e                	sd	s3,24(sp)
    117a:	0080                	addi	s0,sp,64
    117c:	64b1                	lui	s1,0xc
    117e:	35048493          	addi	s1,s1,848 # c350 <buf+0x8b0>
  for(int i = 0; i < 50000; i++){
    char *argv[2];
    argv[0] = (char*)0xffffffff;
    1182:	597d                	li	s2,-1
    1184:	02095913          	srli	s2,s2,0x20
    argv[1] = 0;
    exec("echo", argv);
    1188:	00005997          	auipc	s3,0x5
    118c:	d0098993          	addi	s3,s3,-768 # 5e88 <malloc+0x43c>
    argv[0] = (char*)0xffffffff;
    1190:	fd243023          	sd	s2,-64(s0)
    argv[1] = 0;
    1194:	fc043423          	sd	zero,-56(s0)
    exec("echo", argv);
    1198:	fc040593          	addi	a1,s0,-64
    119c:	854e                	mv	a0,s3
    119e:	00004097          	auipc	ra,0x4
    11a2:	4a8080e7          	jalr	1192(ra) # 5646 <exec>
  for(int i = 0; i < 50000; i++){
    11a6:	34fd                	addiw	s1,s1,-1
    11a8:	f4e5                	bnez	s1,1190 <badarg+0x22>
  }
  
  exit(0);
    11aa:	4501                	li	a0,0
    11ac:	00004097          	auipc	ra,0x4
    11b0:	462080e7          	jalr	1122(ra) # 560e <exit>

00000000000011b4 <copyinstr2>:
{
    11b4:	7155                	addi	sp,sp,-208
    11b6:	e586                	sd	ra,200(sp)
    11b8:	e1a2                	sd	s0,192(sp)
    11ba:	0980                	addi	s0,sp,208
  for(int i = 0; i < MAXPATH; i++)
    11bc:	f6840793          	addi	a5,s0,-152
    11c0:	fe840693          	addi	a3,s0,-24
    b[i] = 'x';
    11c4:	07800713          	li	a4,120
    11c8:	00e78023          	sb	a4,0(a5)
  for(int i = 0; i < MAXPATH; i++)
    11cc:	0785                	addi	a5,a5,1
    11ce:	fed79de3          	bne	a5,a3,11c8 <copyinstr2+0x14>
  b[MAXPATH] = '\0';
    11d2:	fe040423          	sb	zero,-24(s0)
  int ret = unlink(b);
    11d6:	f6840513          	addi	a0,s0,-152
    11da:	00004097          	auipc	ra,0x4
    11de:	484080e7          	jalr	1156(ra) # 565e <unlink>
  if(ret != -1){
    11e2:	57fd                	li	a5,-1
    11e4:	0ef51063          	bne	a0,a5,12c4 <copyinstr2+0x110>
  int fd = open(b, O_CREATE | O_WRONLY);
    11e8:	20100593          	li	a1,513
    11ec:	f6840513          	addi	a0,s0,-152
    11f0:	00004097          	auipc	ra,0x4
    11f4:	45e080e7          	jalr	1118(ra) # 564e <open>
  if(fd != -1){
    11f8:	57fd                	li	a5,-1
    11fa:	0ef51563          	bne	a0,a5,12e4 <copyinstr2+0x130>
  ret = link(b, b);
    11fe:	f6840593          	addi	a1,s0,-152
    1202:	852e                	mv	a0,a1
    1204:	00004097          	auipc	ra,0x4
    1208:	46a080e7          	jalr	1130(ra) # 566e <link>
  if(ret != -1){
    120c:	57fd                	li	a5,-1
    120e:	0ef51b63          	bne	a0,a5,1304 <copyinstr2+0x150>
  char *args[] = { "xx", 0 };
    1212:	00006797          	auipc	a5,0x6
    1216:	57e78793          	addi	a5,a5,1406 # 7790 <malloc+0x1d44>
    121a:	f4f43c23          	sd	a5,-168(s0)
    121e:	f6043023          	sd	zero,-160(s0)
  ret = exec(b, args);
    1222:	f5840593          	addi	a1,s0,-168
    1226:	f6840513          	addi	a0,s0,-152
    122a:	00004097          	auipc	ra,0x4
    122e:	41c080e7          	jalr	1052(ra) # 5646 <exec>
  if(ret != -1){
    1232:	57fd                	li	a5,-1
    1234:	0ef51963          	bne	a0,a5,1326 <copyinstr2+0x172>
  int pid = fork();
    1238:	00004097          	auipc	ra,0x4
    123c:	3ce080e7          	jalr	974(ra) # 5606 <fork>
  if(pid < 0){
    1240:	10054363          	bltz	a0,1346 <copyinstr2+0x192>
  if(pid == 0){
    1244:	12051463          	bnez	a0,136c <copyinstr2+0x1b8>
    1248:	00007797          	auipc	a5,0x7
    124c:	14078793          	addi	a5,a5,320 # 8388 <big.0>
    1250:	00008697          	auipc	a3,0x8
    1254:	13868693          	addi	a3,a3,312 # 9388 <__global_pointer$+0x918>
      big[i] = 'x';
    1258:	07800713          	li	a4,120
    125c:	00e78023          	sb	a4,0(a5)
    for(int i = 0; i < PGSIZE; i++)
    1260:	0785                	addi	a5,a5,1
    1262:	fed79de3          	bne	a5,a3,125c <copyinstr2+0xa8>
    big[PGSIZE] = '\0';
    1266:	00008797          	auipc	a5,0x8
    126a:	12078123          	sb	zero,290(a5) # 9388 <__global_pointer$+0x918>
    char *args2[] = { big, big, big, 0 };
    126e:	00007797          	auipc	a5,0x7
    1272:	c1278793          	addi	a5,a5,-1006 # 7e80 <malloc+0x2434>
    1276:	6390                	ld	a2,0(a5)
    1278:	6794                	ld	a3,8(a5)
    127a:	6b98                	ld	a4,16(a5)
    127c:	6f9c                	ld	a5,24(a5)
    127e:	f2c43823          	sd	a2,-208(s0)
    1282:	f2d43c23          	sd	a3,-200(s0)
    1286:	f4e43023          	sd	a4,-192(s0)
    128a:	f4f43423          	sd	a5,-184(s0)
    ret = exec("echo", args2);
    128e:	f3040593          	addi	a1,s0,-208
    1292:	00005517          	auipc	a0,0x5
    1296:	bf650513          	addi	a0,a0,-1034 # 5e88 <malloc+0x43c>
    129a:	00004097          	auipc	ra,0x4
    129e:	3ac080e7          	jalr	940(ra) # 5646 <exec>
    if(ret != -1){
    12a2:	57fd                	li	a5,-1
    12a4:	0af50e63          	beq	a0,a5,1360 <copyinstr2+0x1ac>
      printf("exec(echo, BIG) returned %d, not -1\n", fd);
    12a8:	55fd                	li	a1,-1
    12aa:	00005517          	auipc	a0,0x5
    12ae:	3be50513          	addi	a0,a0,958 # 6668 <malloc+0xc1c>
    12b2:	00004097          	auipc	ra,0x4
    12b6:	6dc080e7          	jalr	1756(ra) # 598e <printf>
      exit(1);
    12ba:	4505                	li	a0,1
    12bc:	00004097          	auipc	ra,0x4
    12c0:	352080e7          	jalr	850(ra) # 560e <exit>
    printf("unlink(%s) returned %d, not -1\n", b, ret);
    12c4:	862a                	mv	a2,a0
    12c6:	f6840593          	addi	a1,s0,-152
    12ca:	00005517          	auipc	a0,0x5
    12ce:	31650513          	addi	a0,a0,790 # 65e0 <malloc+0xb94>
    12d2:	00004097          	auipc	ra,0x4
    12d6:	6bc080e7          	jalr	1724(ra) # 598e <printf>
    exit(1);
    12da:	4505                	li	a0,1
    12dc:	00004097          	auipc	ra,0x4
    12e0:	332080e7          	jalr	818(ra) # 560e <exit>
    printf("open(%s) returned %d, not -1\n", b, fd);
    12e4:	862a                	mv	a2,a0
    12e6:	f6840593          	addi	a1,s0,-152
    12ea:	00005517          	auipc	a0,0x5
    12ee:	31650513          	addi	a0,a0,790 # 6600 <malloc+0xbb4>
    12f2:	00004097          	auipc	ra,0x4
    12f6:	69c080e7          	jalr	1692(ra) # 598e <printf>
    exit(1);
    12fa:	4505                	li	a0,1
    12fc:	00004097          	auipc	ra,0x4
    1300:	312080e7          	jalr	786(ra) # 560e <exit>
    printf("link(%s, %s) returned %d, not -1\n", b, b, ret);
    1304:	86aa                	mv	a3,a0
    1306:	f6840613          	addi	a2,s0,-152
    130a:	85b2                	mv	a1,a2
    130c:	00005517          	auipc	a0,0x5
    1310:	31450513          	addi	a0,a0,788 # 6620 <malloc+0xbd4>
    1314:	00004097          	auipc	ra,0x4
    1318:	67a080e7          	jalr	1658(ra) # 598e <printf>
    exit(1);
    131c:	4505                	li	a0,1
    131e:	00004097          	auipc	ra,0x4
    1322:	2f0080e7          	jalr	752(ra) # 560e <exit>
    printf("exec(%s) returned %d, not -1\n", b, fd);
    1326:	567d                	li	a2,-1
    1328:	f6840593          	addi	a1,s0,-152
    132c:	00005517          	auipc	a0,0x5
    1330:	31c50513          	addi	a0,a0,796 # 6648 <malloc+0xbfc>
    1334:	00004097          	auipc	ra,0x4
    1338:	65a080e7          	jalr	1626(ra) # 598e <printf>
    exit(1);
    133c:	4505                	li	a0,1
    133e:	00004097          	auipc	ra,0x4
    1342:	2d0080e7          	jalr	720(ra) # 560e <exit>
    printf("fork failed\n");
    1346:	00005517          	auipc	a0,0x5
    134a:	78250513          	addi	a0,a0,1922 # 6ac8 <malloc+0x107c>
    134e:	00004097          	auipc	ra,0x4
    1352:	640080e7          	jalr	1600(ra) # 598e <printf>
    exit(1);
    1356:	4505                	li	a0,1
    1358:	00004097          	auipc	ra,0x4
    135c:	2b6080e7          	jalr	694(ra) # 560e <exit>
    exit(747); // OK
    1360:	2eb00513          	li	a0,747
    1364:	00004097          	auipc	ra,0x4
    1368:	2aa080e7          	jalr	682(ra) # 560e <exit>
  int st = 0;
    136c:	f4042a23          	sw	zero,-172(s0)
  wait(&st);
    1370:	f5440513          	addi	a0,s0,-172
    1374:	00004097          	auipc	ra,0x4
    1378:	2a2080e7          	jalr	674(ra) # 5616 <wait>
  if(st != 747){
    137c:	f5442703          	lw	a4,-172(s0)
    1380:	2eb00793          	li	a5,747
    1384:	00f71663          	bne	a4,a5,1390 <copyinstr2+0x1dc>
}
    1388:	60ae                	ld	ra,200(sp)
    138a:	640e                	ld	s0,192(sp)
    138c:	6169                	addi	sp,sp,208
    138e:	8082                	ret
    printf("exec(echo, BIG) succeeded, should have failed\n");
    1390:	00005517          	auipc	a0,0x5
    1394:	30050513          	addi	a0,a0,768 # 6690 <malloc+0xc44>
    1398:	00004097          	auipc	ra,0x4
    139c:	5f6080e7          	jalr	1526(ra) # 598e <printf>
    exit(1);
    13a0:	4505                	li	a0,1
    13a2:	00004097          	auipc	ra,0x4
    13a6:	26c080e7          	jalr	620(ra) # 560e <exit>

00000000000013aa <truncate3>:
{
    13aa:	7159                	addi	sp,sp,-112
    13ac:	f486                	sd	ra,104(sp)
    13ae:	f0a2                	sd	s0,96(sp)
    13b0:	eca6                	sd	s1,88(sp)
    13b2:	e8ca                	sd	s2,80(sp)
    13b4:	e4ce                	sd	s3,72(sp)
    13b6:	e0d2                	sd	s4,64(sp)
    13b8:	fc56                	sd	s5,56(sp)
    13ba:	1880                	addi	s0,sp,112
    13bc:	892a                	mv	s2,a0
  close(open("truncfile", O_CREATE|O_TRUNC|O_WRONLY));
    13be:	60100593          	li	a1,1537
    13c2:	00005517          	auipc	a0,0x5
    13c6:	b1e50513          	addi	a0,a0,-1250 # 5ee0 <malloc+0x494>
    13ca:	00004097          	auipc	ra,0x4
    13ce:	284080e7          	jalr	644(ra) # 564e <open>
    13d2:	00004097          	auipc	ra,0x4
    13d6:	264080e7          	jalr	612(ra) # 5636 <close>
  pid = fork();
    13da:	00004097          	auipc	ra,0x4
    13de:	22c080e7          	jalr	556(ra) # 5606 <fork>
  if(pid < 0){
    13e2:	08054063          	bltz	a0,1462 <truncate3+0xb8>
  if(pid == 0){
    13e6:	e969                	bnez	a0,14b8 <truncate3+0x10e>
    13e8:	06400993          	li	s3,100
      int fd = open("truncfile", O_WRONLY);
    13ec:	00005a17          	auipc	s4,0x5
    13f0:	af4a0a13          	addi	s4,s4,-1292 # 5ee0 <malloc+0x494>
      int n = write(fd, "1234567890", 10);
    13f4:	00005a97          	auipc	s5,0x5
    13f8:	2fca8a93          	addi	s5,s5,764 # 66f0 <malloc+0xca4>
      int fd = open("truncfile", O_WRONLY);
    13fc:	4585                	li	a1,1
    13fe:	8552                	mv	a0,s4
    1400:	00004097          	auipc	ra,0x4
    1404:	24e080e7          	jalr	590(ra) # 564e <open>
    1408:	84aa                	mv	s1,a0
      if(fd < 0){
    140a:	06054a63          	bltz	a0,147e <truncate3+0xd4>
      int n = write(fd, "1234567890", 10);
    140e:	4629                	li	a2,10
    1410:	85d6                	mv	a1,s5
    1412:	00004097          	auipc	ra,0x4
    1416:	21c080e7          	jalr	540(ra) # 562e <write>
      if(n != 10){
    141a:	47a9                	li	a5,10
    141c:	06f51f63          	bne	a0,a5,149a <truncate3+0xf0>
      close(fd);
    1420:	8526                	mv	a0,s1
    1422:	00004097          	auipc	ra,0x4
    1426:	214080e7          	jalr	532(ra) # 5636 <close>
      fd = open("truncfile", O_RDONLY);
    142a:	4581                	li	a1,0
    142c:	8552                	mv	a0,s4
    142e:	00004097          	auipc	ra,0x4
    1432:	220080e7          	jalr	544(ra) # 564e <open>
    1436:	84aa                	mv	s1,a0
      read(fd, buf, sizeof(buf));
    1438:	02000613          	li	a2,32
    143c:	f9840593          	addi	a1,s0,-104
    1440:	00004097          	auipc	ra,0x4
    1444:	1e6080e7          	jalr	486(ra) # 5626 <read>
      close(fd);
    1448:	8526                	mv	a0,s1
    144a:	00004097          	auipc	ra,0x4
    144e:	1ec080e7          	jalr	492(ra) # 5636 <close>
    for(int i = 0; i < 100; i++){
    1452:	39fd                	addiw	s3,s3,-1
    1454:	fa0994e3          	bnez	s3,13fc <truncate3+0x52>
    exit(0);
    1458:	4501                	li	a0,0
    145a:	00004097          	auipc	ra,0x4
    145e:	1b4080e7          	jalr	436(ra) # 560e <exit>
    printf("%s: fork failed\n", s);
    1462:	85ca                	mv	a1,s2
    1464:	00005517          	auipc	a0,0x5
    1468:	25c50513          	addi	a0,a0,604 # 66c0 <malloc+0xc74>
    146c:	00004097          	auipc	ra,0x4
    1470:	522080e7          	jalr	1314(ra) # 598e <printf>
    exit(1);
    1474:	4505                	li	a0,1
    1476:	00004097          	auipc	ra,0x4
    147a:	198080e7          	jalr	408(ra) # 560e <exit>
        printf("%s: open failed\n", s);
    147e:	85ca                	mv	a1,s2
    1480:	00005517          	auipc	a0,0x5
    1484:	25850513          	addi	a0,a0,600 # 66d8 <malloc+0xc8c>
    1488:	00004097          	auipc	ra,0x4
    148c:	506080e7          	jalr	1286(ra) # 598e <printf>
        exit(1);
    1490:	4505                	li	a0,1
    1492:	00004097          	auipc	ra,0x4
    1496:	17c080e7          	jalr	380(ra) # 560e <exit>
        printf("%s: write got %d, expected 10\n", s, n);
    149a:	862a                	mv	a2,a0
    149c:	85ca                	mv	a1,s2
    149e:	00005517          	auipc	a0,0x5
    14a2:	26250513          	addi	a0,a0,610 # 6700 <malloc+0xcb4>
    14a6:	00004097          	auipc	ra,0x4
    14aa:	4e8080e7          	jalr	1256(ra) # 598e <printf>
        exit(1);
    14ae:	4505                	li	a0,1
    14b0:	00004097          	auipc	ra,0x4
    14b4:	15e080e7          	jalr	350(ra) # 560e <exit>
    14b8:	09600993          	li	s3,150
    int fd = open("truncfile", O_CREATE|O_WRONLY|O_TRUNC);
    14bc:	00005a17          	auipc	s4,0x5
    14c0:	a24a0a13          	addi	s4,s4,-1500 # 5ee0 <malloc+0x494>
    int n = write(fd, "xxx", 3);
    14c4:	00005a97          	auipc	s5,0x5
    14c8:	25ca8a93          	addi	s5,s5,604 # 6720 <malloc+0xcd4>
    int fd = open("truncfile", O_CREATE|O_WRONLY|O_TRUNC);
    14cc:	60100593          	li	a1,1537
    14d0:	8552                	mv	a0,s4
    14d2:	00004097          	auipc	ra,0x4
    14d6:	17c080e7          	jalr	380(ra) # 564e <open>
    14da:	84aa                	mv	s1,a0
    if(fd < 0){
    14dc:	04054763          	bltz	a0,152a <truncate3+0x180>
    int n = write(fd, "xxx", 3);
    14e0:	460d                	li	a2,3
    14e2:	85d6                	mv	a1,s5
    14e4:	00004097          	auipc	ra,0x4
    14e8:	14a080e7          	jalr	330(ra) # 562e <write>
    if(n != 3){
    14ec:	478d                	li	a5,3
    14ee:	04f51c63          	bne	a0,a5,1546 <truncate3+0x19c>
    close(fd);
    14f2:	8526                	mv	a0,s1
    14f4:	00004097          	auipc	ra,0x4
    14f8:	142080e7          	jalr	322(ra) # 5636 <close>
  for(int i = 0; i < 150; i++){
    14fc:	39fd                	addiw	s3,s3,-1
    14fe:	fc0997e3          	bnez	s3,14cc <truncate3+0x122>
  wait(&xstatus);
    1502:	fbc40513          	addi	a0,s0,-68
    1506:	00004097          	auipc	ra,0x4
    150a:	110080e7          	jalr	272(ra) # 5616 <wait>
  unlink("truncfile");
    150e:	00005517          	auipc	a0,0x5
    1512:	9d250513          	addi	a0,a0,-1582 # 5ee0 <malloc+0x494>
    1516:	00004097          	auipc	ra,0x4
    151a:	148080e7          	jalr	328(ra) # 565e <unlink>
  exit(xstatus);
    151e:	fbc42503          	lw	a0,-68(s0)
    1522:	00004097          	auipc	ra,0x4
    1526:	0ec080e7          	jalr	236(ra) # 560e <exit>
      printf("%s: open failed\n", s);
    152a:	85ca                	mv	a1,s2
    152c:	00005517          	auipc	a0,0x5
    1530:	1ac50513          	addi	a0,a0,428 # 66d8 <malloc+0xc8c>
    1534:	00004097          	auipc	ra,0x4
    1538:	45a080e7          	jalr	1114(ra) # 598e <printf>
      exit(1);
    153c:	4505                	li	a0,1
    153e:	00004097          	auipc	ra,0x4
    1542:	0d0080e7          	jalr	208(ra) # 560e <exit>
      printf("%s: write got %d, expected 3\n", s, n);
    1546:	862a                	mv	a2,a0
    1548:	85ca                	mv	a1,s2
    154a:	00005517          	auipc	a0,0x5
    154e:	1de50513          	addi	a0,a0,478 # 6728 <malloc+0xcdc>
    1552:	00004097          	auipc	ra,0x4
    1556:	43c080e7          	jalr	1084(ra) # 598e <printf>
      exit(1);
    155a:	4505                	li	a0,1
    155c:	00004097          	auipc	ra,0x4
    1560:	0b2080e7          	jalr	178(ra) # 560e <exit>

0000000000001564 <exectest>:
{
    1564:	715d                	addi	sp,sp,-80
    1566:	e486                	sd	ra,72(sp)
    1568:	e0a2                	sd	s0,64(sp)
    156a:	fc26                	sd	s1,56(sp)
    156c:	f84a                	sd	s2,48(sp)
    156e:	0880                	addi	s0,sp,80
    1570:	892a                	mv	s2,a0
  char *echoargv[] = { "echo", "OK", 0 };
    1572:	00005797          	auipc	a5,0x5
    1576:	91678793          	addi	a5,a5,-1770 # 5e88 <malloc+0x43c>
    157a:	fcf43023          	sd	a5,-64(s0)
    157e:	00005797          	auipc	a5,0x5
    1582:	1ca78793          	addi	a5,a5,458 # 6748 <malloc+0xcfc>
    1586:	fcf43423          	sd	a5,-56(s0)
    158a:	fc043823          	sd	zero,-48(s0)
  unlink("echo-ok");
    158e:	00005517          	auipc	a0,0x5
    1592:	1c250513          	addi	a0,a0,450 # 6750 <malloc+0xd04>
    1596:	00004097          	auipc	ra,0x4
    159a:	0c8080e7          	jalr	200(ra) # 565e <unlink>
  pid = fork();
    159e:	00004097          	auipc	ra,0x4
    15a2:	068080e7          	jalr	104(ra) # 5606 <fork>
  if(pid < 0) {
    15a6:	04054663          	bltz	a0,15f2 <exectest+0x8e>
    15aa:	84aa                	mv	s1,a0
  if(pid == 0) {
    15ac:	e959                	bnez	a0,1642 <exectest+0xde>
    close(1);
    15ae:	4505                	li	a0,1
    15b0:	00004097          	auipc	ra,0x4
    15b4:	086080e7          	jalr	134(ra) # 5636 <close>
    fd = open("echo-ok", O_CREATE|O_WRONLY);
    15b8:	20100593          	li	a1,513
    15bc:	00005517          	auipc	a0,0x5
    15c0:	19450513          	addi	a0,a0,404 # 6750 <malloc+0xd04>
    15c4:	00004097          	auipc	ra,0x4
    15c8:	08a080e7          	jalr	138(ra) # 564e <open>
    if(fd < 0) {
    15cc:	04054163          	bltz	a0,160e <exectest+0xaa>
    if(fd != 1) {
    15d0:	4785                	li	a5,1
    15d2:	04f50c63          	beq	a0,a5,162a <exectest+0xc6>
      printf("%s: wrong fd\n", s);
    15d6:	85ca                	mv	a1,s2
    15d8:	00005517          	auipc	a0,0x5
    15dc:	19850513          	addi	a0,a0,408 # 6770 <malloc+0xd24>
    15e0:	00004097          	auipc	ra,0x4
    15e4:	3ae080e7          	jalr	942(ra) # 598e <printf>
      exit(1);
    15e8:	4505                	li	a0,1
    15ea:	00004097          	auipc	ra,0x4
    15ee:	024080e7          	jalr	36(ra) # 560e <exit>
     printf("%s: fork failed\n", s);
    15f2:	85ca                	mv	a1,s2
    15f4:	00005517          	auipc	a0,0x5
    15f8:	0cc50513          	addi	a0,a0,204 # 66c0 <malloc+0xc74>
    15fc:	00004097          	auipc	ra,0x4
    1600:	392080e7          	jalr	914(ra) # 598e <printf>
     exit(1);
    1604:	4505                	li	a0,1
    1606:	00004097          	auipc	ra,0x4
    160a:	008080e7          	jalr	8(ra) # 560e <exit>
      printf("%s: create failed\n", s);
    160e:	85ca                	mv	a1,s2
    1610:	00005517          	auipc	a0,0x5
    1614:	14850513          	addi	a0,a0,328 # 6758 <malloc+0xd0c>
    1618:	00004097          	auipc	ra,0x4
    161c:	376080e7          	jalr	886(ra) # 598e <printf>
      exit(1);
    1620:	4505                	li	a0,1
    1622:	00004097          	auipc	ra,0x4
    1626:	fec080e7          	jalr	-20(ra) # 560e <exit>
    if(exec("echo", echoargv) < 0){
    162a:	fc040593          	addi	a1,s0,-64
    162e:	00005517          	auipc	a0,0x5
    1632:	85a50513          	addi	a0,a0,-1958 # 5e88 <malloc+0x43c>
    1636:	00004097          	auipc	ra,0x4
    163a:	010080e7          	jalr	16(ra) # 5646 <exec>
    163e:	02054163          	bltz	a0,1660 <exectest+0xfc>
  if (wait(&xstatus) != pid) {
    1642:	fdc40513          	addi	a0,s0,-36
    1646:	00004097          	auipc	ra,0x4
    164a:	fd0080e7          	jalr	-48(ra) # 5616 <wait>
    164e:	02951763          	bne	a0,s1,167c <exectest+0x118>
  if(xstatus != 0)
    1652:	fdc42503          	lw	a0,-36(s0)
    1656:	cd0d                	beqz	a0,1690 <exectest+0x12c>
    exit(xstatus);
    1658:	00004097          	auipc	ra,0x4
    165c:	fb6080e7          	jalr	-74(ra) # 560e <exit>
      printf("%s: exec echo failed\n", s);
    1660:	85ca                	mv	a1,s2
    1662:	00005517          	auipc	a0,0x5
    1666:	11e50513          	addi	a0,a0,286 # 6780 <malloc+0xd34>
    166a:	00004097          	auipc	ra,0x4
    166e:	324080e7          	jalr	804(ra) # 598e <printf>
      exit(1);
    1672:	4505                	li	a0,1
    1674:	00004097          	auipc	ra,0x4
    1678:	f9a080e7          	jalr	-102(ra) # 560e <exit>
    printf("%s: wait failed!\n", s);
    167c:	85ca                	mv	a1,s2
    167e:	00005517          	auipc	a0,0x5
    1682:	11a50513          	addi	a0,a0,282 # 6798 <malloc+0xd4c>
    1686:	00004097          	auipc	ra,0x4
    168a:	308080e7          	jalr	776(ra) # 598e <printf>
    168e:	b7d1                	j	1652 <exectest+0xee>
  fd = open("echo-ok", O_RDONLY);
    1690:	4581                	li	a1,0
    1692:	00005517          	auipc	a0,0x5
    1696:	0be50513          	addi	a0,a0,190 # 6750 <malloc+0xd04>
    169a:	00004097          	auipc	ra,0x4
    169e:	fb4080e7          	jalr	-76(ra) # 564e <open>
  if(fd < 0) {
    16a2:	02054a63          	bltz	a0,16d6 <exectest+0x172>
  if (read(fd, buf, 2) != 2) {
    16a6:	4609                	li	a2,2
    16a8:	fb840593          	addi	a1,s0,-72
    16ac:	00004097          	auipc	ra,0x4
    16b0:	f7a080e7          	jalr	-134(ra) # 5626 <read>
    16b4:	4789                	li	a5,2
    16b6:	02f50e63          	beq	a0,a5,16f2 <exectest+0x18e>
    printf("%s: read failed\n", s);
    16ba:	85ca                	mv	a1,s2
    16bc:	00005517          	auipc	a0,0x5
    16c0:	b5c50513          	addi	a0,a0,-1188 # 6218 <malloc+0x7cc>
    16c4:	00004097          	auipc	ra,0x4
    16c8:	2ca080e7          	jalr	714(ra) # 598e <printf>
    exit(1);
    16cc:	4505                	li	a0,1
    16ce:	00004097          	auipc	ra,0x4
    16d2:	f40080e7          	jalr	-192(ra) # 560e <exit>
    printf("%s: open failed\n", s);
    16d6:	85ca                	mv	a1,s2
    16d8:	00005517          	auipc	a0,0x5
    16dc:	00050513          	mv	a0,a0
    16e0:	00004097          	auipc	ra,0x4
    16e4:	2ae080e7          	jalr	686(ra) # 598e <printf>
    exit(1);
    16e8:	4505                	li	a0,1
    16ea:	00004097          	auipc	ra,0x4
    16ee:	f24080e7          	jalr	-220(ra) # 560e <exit>
  unlink("echo-ok");
    16f2:	00005517          	auipc	a0,0x5
    16f6:	05e50513          	addi	a0,a0,94 # 6750 <malloc+0xd04>
    16fa:	00004097          	auipc	ra,0x4
    16fe:	f64080e7          	jalr	-156(ra) # 565e <unlink>
  if(buf[0] == 'O' && buf[1] == 'K')
    1702:	fb844703          	lbu	a4,-72(s0)
    1706:	04f00793          	li	a5,79
    170a:	00f71863          	bne	a4,a5,171a <exectest+0x1b6>
    170e:	fb944703          	lbu	a4,-71(s0)
    1712:	04b00793          	li	a5,75
    1716:	02f70063          	beq	a4,a5,1736 <exectest+0x1d2>
    printf("%s: wrong output\n", s);
    171a:	85ca                	mv	a1,s2
    171c:	00005517          	auipc	a0,0x5
    1720:	09450513          	addi	a0,a0,148 # 67b0 <malloc+0xd64>
    1724:	00004097          	auipc	ra,0x4
    1728:	26a080e7          	jalr	618(ra) # 598e <printf>
    exit(1);
    172c:	4505                	li	a0,1
    172e:	00004097          	auipc	ra,0x4
    1732:	ee0080e7          	jalr	-288(ra) # 560e <exit>
    exit(0);
    1736:	4501                	li	a0,0
    1738:	00004097          	auipc	ra,0x4
    173c:	ed6080e7          	jalr	-298(ra) # 560e <exit>

0000000000001740 <pipe1>:
{
    1740:	711d                	addi	sp,sp,-96
    1742:	ec86                	sd	ra,88(sp)
    1744:	e8a2                	sd	s0,80(sp)
    1746:	e4a6                	sd	s1,72(sp)
    1748:	e0ca                	sd	s2,64(sp)
    174a:	fc4e                	sd	s3,56(sp)
    174c:	f852                	sd	s4,48(sp)
    174e:	f456                	sd	s5,40(sp)
    1750:	f05a                	sd	s6,32(sp)
    1752:	ec5e                	sd	s7,24(sp)
    1754:	1080                	addi	s0,sp,96
    1756:	892a                	mv	s2,a0
  if(pipe(fds) != 0){
    1758:	fa840513          	addi	a0,s0,-88
    175c:	00004097          	auipc	ra,0x4
    1760:	ec2080e7          	jalr	-318(ra) # 561e <pipe>
    1764:	ed25                	bnez	a0,17dc <pipe1+0x9c>
    1766:	84aa                	mv	s1,a0
  pid = fork();
    1768:	00004097          	auipc	ra,0x4
    176c:	e9e080e7          	jalr	-354(ra) # 5606 <fork>
    1770:	8a2a                	mv	s4,a0
  if(pid == 0){
    1772:	c159                	beqz	a0,17f8 <pipe1+0xb8>
  } else if(pid > 0){
    1774:	16a05e63          	blez	a0,18f0 <pipe1+0x1b0>
    close(fds[1]);
    1778:	fac42503          	lw	a0,-84(s0)
    177c:	00004097          	auipc	ra,0x4
    1780:	eba080e7          	jalr	-326(ra) # 5636 <close>
    total = 0;
    1784:	8a26                	mv	s4,s1
    cc = 1;
    1786:	4985                	li	s3,1
    while((n = read(fds[0], buf, cc)) > 0){
    1788:	0000aa97          	auipc	s5,0xa
    178c:	318a8a93          	addi	s5,s5,792 # baa0 <buf>
      if(cc > sizeof(buf))
    1790:	6b0d                	lui	s6,0x3
    while((n = read(fds[0], buf, cc)) > 0){
    1792:	864e                	mv	a2,s3
    1794:	85d6                	mv	a1,s5
    1796:	fa842503          	lw	a0,-88(s0)
    179a:	00004097          	auipc	ra,0x4
    179e:	e8c080e7          	jalr	-372(ra) # 5626 <read>
    17a2:	10a05263          	blez	a0,18a6 <pipe1+0x166>
      for(i = 0; i < n; i++){
    17a6:	0000a717          	auipc	a4,0xa
    17aa:	2fa70713          	addi	a4,a4,762 # baa0 <buf>
    17ae:	00a4863b          	addw	a2,s1,a0
        if((buf[i] & 0xff) != (seq++ & 0xff)){
    17b2:	00074683          	lbu	a3,0(a4)
    17b6:	0ff4f793          	andi	a5,s1,255
    17ba:	2485                	addiw	s1,s1,1
    17bc:	0cf69163          	bne	a3,a5,187e <pipe1+0x13e>
      for(i = 0; i < n; i++){
    17c0:	0705                	addi	a4,a4,1
    17c2:	fec498e3          	bne	s1,a2,17b2 <pipe1+0x72>
      total += n;
    17c6:	00aa0a3b          	addw	s4,s4,a0
      cc = cc * 2;
    17ca:	0019979b          	slliw	a5,s3,0x1
    17ce:	0007899b          	sext.w	s3,a5
      if(cc > sizeof(buf))
    17d2:	013b7363          	bgeu	s6,s3,17d8 <pipe1+0x98>
        cc = sizeof(buf);
    17d6:	89da                	mv	s3,s6
        if((buf[i] & 0xff) != (seq++ & 0xff)){
    17d8:	84b2                	mv	s1,a2
    17da:	bf65                	j	1792 <pipe1+0x52>
    printf("%s: pipe() failed\n", s);
    17dc:	85ca                	mv	a1,s2
    17de:	00005517          	auipc	a0,0x5
    17e2:	fea50513          	addi	a0,a0,-22 # 67c8 <malloc+0xd7c>
    17e6:	00004097          	auipc	ra,0x4
    17ea:	1a8080e7          	jalr	424(ra) # 598e <printf>
    exit(1);
    17ee:	4505                	li	a0,1
    17f0:	00004097          	auipc	ra,0x4
    17f4:	e1e080e7          	jalr	-482(ra) # 560e <exit>
    close(fds[0]);
    17f8:	fa842503          	lw	a0,-88(s0)
    17fc:	00004097          	auipc	ra,0x4
    1800:	e3a080e7          	jalr	-454(ra) # 5636 <close>
    for(n = 0; n < N; n++){
    1804:	0000ab17          	auipc	s6,0xa
    1808:	29cb0b13          	addi	s6,s6,668 # baa0 <buf>
    180c:	416004bb          	negw	s1,s6
    1810:	0ff4f493          	andi	s1,s1,255
    1814:	409b0993          	addi	s3,s6,1033
      if(write(fds[1], buf, SZ) != SZ){
    1818:	8bda                	mv	s7,s6
    for(n = 0; n < N; n++){
    181a:	6a85                	lui	s5,0x1
    181c:	42da8a93          	addi	s5,s5,1069 # 142d <truncate3+0x83>
{
    1820:	87da                	mv	a5,s6
        buf[i] = seq++;
    1822:	0097873b          	addw	a4,a5,s1
    1826:	00e78023          	sb	a4,0(a5)
      for(i = 0; i < SZ; i++)
    182a:	0785                	addi	a5,a5,1
    182c:	fef99be3          	bne	s3,a5,1822 <pipe1+0xe2>
        buf[i] = seq++;
    1830:	409a0a1b          	addiw	s4,s4,1033
      if(write(fds[1], buf, SZ) != SZ){
    1834:	40900613          	li	a2,1033
    1838:	85de                	mv	a1,s7
    183a:	fac42503          	lw	a0,-84(s0)
    183e:	00004097          	auipc	ra,0x4
    1842:	df0080e7          	jalr	-528(ra) # 562e <write>
    1846:	40900793          	li	a5,1033
    184a:	00f51c63          	bne	a0,a5,1862 <pipe1+0x122>
    for(n = 0; n < N; n++){
    184e:	24a5                	addiw	s1,s1,9
    1850:	0ff4f493          	andi	s1,s1,255
    1854:	fd5a16e3          	bne	s4,s5,1820 <pipe1+0xe0>
    exit(0);
    1858:	4501                	li	a0,0
    185a:	00004097          	auipc	ra,0x4
    185e:	db4080e7          	jalr	-588(ra) # 560e <exit>
        printf("%s: pipe1 oops 1\n", s);
    1862:	85ca                	mv	a1,s2
    1864:	00005517          	auipc	a0,0x5
    1868:	f7c50513          	addi	a0,a0,-132 # 67e0 <malloc+0xd94>
    186c:	00004097          	auipc	ra,0x4
    1870:	122080e7          	jalr	290(ra) # 598e <printf>
        exit(1);
    1874:	4505                	li	a0,1
    1876:	00004097          	auipc	ra,0x4
    187a:	d98080e7          	jalr	-616(ra) # 560e <exit>
          printf("%s: pipe1 oops 2\n", s);
    187e:	85ca                	mv	a1,s2
    1880:	00005517          	auipc	a0,0x5
    1884:	f7850513          	addi	a0,a0,-136 # 67f8 <malloc+0xdac>
    1888:	00004097          	auipc	ra,0x4
    188c:	106080e7          	jalr	262(ra) # 598e <printf>
}
    1890:	60e6                	ld	ra,88(sp)
    1892:	6446                	ld	s0,80(sp)
    1894:	64a6                	ld	s1,72(sp)
    1896:	6906                	ld	s2,64(sp)
    1898:	79e2                	ld	s3,56(sp)
    189a:	7a42                	ld	s4,48(sp)
    189c:	7aa2                	ld	s5,40(sp)
    189e:	7b02                	ld	s6,32(sp)
    18a0:	6be2                	ld	s7,24(sp)
    18a2:	6125                	addi	sp,sp,96
    18a4:	8082                	ret
    if(total != N * SZ){
    18a6:	6785                	lui	a5,0x1
    18a8:	42d78793          	addi	a5,a5,1069 # 142d <truncate3+0x83>
    18ac:	02fa0063          	beq	s4,a5,18cc <pipe1+0x18c>
      printf("%s: pipe1 oops 3 total %d\n", total);
    18b0:	85d2                	mv	a1,s4
    18b2:	00005517          	auipc	a0,0x5
    18b6:	f5e50513          	addi	a0,a0,-162 # 6810 <malloc+0xdc4>
    18ba:	00004097          	auipc	ra,0x4
    18be:	0d4080e7          	jalr	212(ra) # 598e <printf>
      exit(1);
    18c2:	4505                	li	a0,1
    18c4:	00004097          	auipc	ra,0x4
    18c8:	d4a080e7          	jalr	-694(ra) # 560e <exit>
    close(fds[0]);
    18cc:	fa842503          	lw	a0,-88(s0)
    18d0:	00004097          	auipc	ra,0x4
    18d4:	d66080e7          	jalr	-666(ra) # 5636 <close>
    wait(&xstatus);
    18d8:	fa440513          	addi	a0,s0,-92
    18dc:	00004097          	auipc	ra,0x4
    18e0:	d3a080e7          	jalr	-710(ra) # 5616 <wait>
    exit(xstatus);
    18e4:	fa442503          	lw	a0,-92(s0)
    18e8:	00004097          	auipc	ra,0x4
    18ec:	d26080e7          	jalr	-730(ra) # 560e <exit>
    printf("%s: fork() failed\n", s);
    18f0:	85ca                	mv	a1,s2
    18f2:	00005517          	auipc	a0,0x5
    18f6:	f3e50513          	addi	a0,a0,-194 # 6830 <malloc+0xde4>
    18fa:	00004097          	auipc	ra,0x4
    18fe:	094080e7          	jalr	148(ra) # 598e <printf>
    exit(1);
    1902:	4505                	li	a0,1
    1904:	00004097          	auipc	ra,0x4
    1908:	d0a080e7          	jalr	-758(ra) # 560e <exit>

000000000000190c <exitwait>:
{
    190c:	7139                	addi	sp,sp,-64
    190e:	fc06                	sd	ra,56(sp)
    1910:	f822                	sd	s0,48(sp)
    1912:	f426                	sd	s1,40(sp)
    1914:	f04a                	sd	s2,32(sp)
    1916:	ec4e                	sd	s3,24(sp)
    1918:	e852                	sd	s4,16(sp)
    191a:	0080                	addi	s0,sp,64
    191c:	8a2a                	mv	s4,a0
  for(i = 0; i < 100; i++){
    191e:	4901                	li	s2,0
    1920:	06400993          	li	s3,100
    pid = fork();
    1924:	00004097          	auipc	ra,0x4
    1928:	ce2080e7          	jalr	-798(ra) # 5606 <fork>
    192c:	84aa                	mv	s1,a0
    if(pid < 0){
    192e:	02054a63          	bltz	a0,1962 <exitwait+0x56>
    if(pid){
    1932:	c151                	beqz	a0,19b6 <exitwait+0xaa>
      if(wait(&xstate) != pid){
    1934:	fcc40513          	addi	a0,s0,-52
    1938:	00004097          	auipc	ra,0x4
    193c:	cde080e7          	jalr	-802(ra) # 5616 <wait>
    1940:	02951f63          	bne	a0,s1,197e <exitwait+0x72>
      if(i != xstate) {
    1944:	fcc42783          	lw	a5,-52(s0)
    1948:	05279963          	bne	a5,s2,199a <exitwait+0x8e>
  for(i = 0; i < 100; i++){
    194c:	2905                	addiw	s2,s2,1
    194e:	fd391be3          	bne	s2,s3,1924 <exitwait+0x18>
}
    1952:	70e2                	ld	ra,56(sp)
    1954:	7442                	ld	s0,48(sp)
    1956:	74a2                	ld	s1,40(sp)
    1958:	7902                	ld	s2,32(sp)
    195a:	69e2                	ld	s3,24(sp)
    195c:	6a42                	ld	s4,16(sp)
    195e:	6121                	addi	sp,sp,64
    1960:	8082                	ret
      printf("%s: fork failed\n", s);
    1962:	85d2                	mv	a1,s4
    1964:	00005517          	auipc	a0,0x5
    1968:	d5c50513          	addi	a0,a0,-676 # 66c0 <malloc+0xc74>
    196c:	00004097          	auipc	ra,0x4
    1970:	022080e7          	jalr	34(ra) # 598e <printf>
      exit(1);
    1974:	4505                	li	a0,1
    1976:	00004097          	auipc	ra,0x4
    197a:	c98080e7          	jalr	-872(ra) # 560e <exit>
        printf("%s: wait wrong pid\n", s);
    197e:	85d2                	mv	a1,s4
    1980:	00005517          	auipc	a0,0x5
    1984:	ec850513          	addi	a0,a0,-312 # 6848 <malloc+0xdfc>
    1988:	00004097          	auipc	ra,0x4
    198c:	006080e7          	jalr	6(ra) # 598e <printf>
        exit(1);
    1990:	4505                	li	a0,1
    1992:	00004097          	auipc	ra,0x4
    1996:	c7c080e7          	jalr	-900(ra) # 560e <exit>
        printf("%s: wait wrong exit status\n", s);
    199a:	85d2                	mv	a1,s4
    199c:	00005517          	auipc	a0,0x5
    19a0:	ec450513          	addi	a0,a0,-316 # 6860 <malloc+0xe14>
    19a4:	00004097          	auipc	ra,0x4
    19a8:	fea080e7          	jalr	-22(ra) # 598e <printf>
        exit(1);
    19ac:	4505                	li	a0,1
    19ae:	00004097          	auipc	ra,0x4
    19b2:	c60080e7          	jalr	-928(ra) # 560e <exit>
      exit(i);
    19b6:	854a                	mv	a0,s2
    19b8:	00004097          	auipc	ra,0x4
    19bc:	c56080e7          	jalr	-938(ra) # 560e <exit>

00000000000019c0 <twochildren>:
{
    19c0:	1101                	addi	sp,sp,-32
    19c2:	ec06                	sd	ra,24(sp)
    19c4:	e822                	sd	s0,16(sp)
    19c6:	e426                	sd	s1,8(sp)
    19c8:	e04a                	sd	s2,0(sp)
    19ca:	1000                	addi	s0,sp,32
    19cc:	892a                	mv	s2,a0
    19ce:	3e800493          	li	s1,1000
    int pid1 = fork();
    19d2:	00004097          	auipc	ra,0x4
    19d6:	c34080e7          	jalr	-972(ra) # 5606 <fork>
    if(pid1 < 0){
    19da:	02054c63          	bltz	a0,1a12 <twochildren+0x52>
    if(pid1 == 0){
    19de:	c921                	beqz	a0,1a2e <twochildren+0x6e>
      int pid2 = fork();
    19e0:	00004097          	auipc	ra,0x4
    19e4:	c26080e7          	jalr	-986(ra) # 5606 <fork>
      if(pid2 < 0){
    19e8:	04054763          	bltz	a0,1a36 <twochildren+0x76>
      if(pid2 == 0){
    19ec:	c13d                	beqz	a0,1a52 <twochildren+0x92>
        wait(0);
    19ee:	4501                	li	a0,0
    19f0:	00004097          	auipc	ra,0x4
    19f4:	c26080e7          	jalr	-986(ra) # 5616 <wait>
        wait(0);
    19f8:	4501                	li	a0,0
    19fa:	00004097          	auipc	ra,0x4
    19fe:	c1c080e7          	jalr	-996(ra) # 5616 <wait>
  for(int i = 0; i < 1000; i++){
    1a02:	34fd                	addiw	s1,s1,-1
    1a04:	f4f9                	bnez	s1,19d2 <twochildren+0x12>
}
    1a06:	60e2                	ld	ra,24(sp)
    1a08:	6442                	ld	s0,16(sp)
    1a0a:	64a2                	ld	s1,8(sp)
    1a0c:	6902                	ld	s2,0(sp)
    1a0e:	6105                	addi	sp,sp,32
    1a10:	8082                	ret
      printf("%s: fork failed\n", s);
    1a12:	85ca                	mv	a1,s2
    1a14:	00005517          	auipc	a0,0x5
    1a18:	cac50513          	addi	a0,a0,-852 # 66c0 <malloc+0xc74>
    1a1c:	00004097          	auipc	ra,0x4
    1a20:	f72080e7          	jalr	-142(ra) # 598e <printf>
      exit(1);
    1a24:	4505                	li	a0,1
    1a26:	00004097          	auipc	ra,0x4
    1a2a:	be8080e7          	jalr	-1048(ra) # 560e <exit>
      exit(0);
    1a2e:	00004097          	auipc	ra,0x4
    1a32:	be0080e7          	jalr	-1056(ra) # 560e <exit>
        printf("%s: fork failed\n", s);
    1a36:	85ca                	mv	a1,s2
    1a38:	00005517          	auipc	a0,0x5
    1a3c:	c8850513          	addi	a0,a0,-888 # 66c0 <malloc+0xc74>
    1a40:	00004097          	auipc	ra,0x4
    1a44:	f4e080e7          	jalr	-178(ra) # 598e <printf>
        exit(1);
    1a48:	4505                	li	a0,1
    1a4a:	00004097          	auipc	ra,0x4
    1a4e:	bc4080e7          	jalr	-1084(ra) # 560e <exit>
        exit(0);
    1a52:	00004097          	auipc	ra,0x4
    1a56:	bbc080e7          	jalr	-1092(ra) # 560e <exit>

0000000000001a5a <forkfork>:
{
    1a5a:	7179                	addi	sp,sp,-48
    1a5c:	f406                	sd	ra,40(sp)
    1a5e:	f022                	sd	s0,32(sp)
    1a60:	ec26                	sd	s1,24(sp)
    1a62:	1800                	addi	s0,sp,48
    1a64:	84aa                	mv	s1,a0
    int pid = fork();
    1a66:	00004097          	auipc	ra,0x4
    1a6a:	ba0080e7          	jalr	-1120(ra) # 5606 <fork>
    if(pid < 0){
    1a6e:	04054163          	bltz	a0,1ab0 <forkfork+0x56>
    if(pid == 0){
    1a72:	cd29                	beqz	a0,1acc <forkfork+0x72>
    int pid = fork();
    1a74:	00004097          	auipc	ra,0x4
    1a78:	b92080e7          	jalr	-1134(ra) # 5606 <fork>
    if(pid < 0){
    1a7c:	02054a63          	bltz	a0,1ab0 <forkfork+0x56>
    if(pid == 0){
    1a80:	c531                	beqz	a0,1acc <forkfork+0x72>
    wait(&xstatus);
    1a82:	fdc40513          	addi	a0,s0,-36
    1a86:	00004097          	auipc	ra,0x4
    1a8a:	b90080e7          	jalr	-1136(ra) # 5616 <wait>
    if(xstatus != 0) {
    1a8e:	fdc42783          	lw	a5,-36(s0)
    1a92:	ebbd                	bnez	a5,1b08 <forkfork+0xae>
    wait(&xstatus);
    1a94:	fdc40513          	addi	a0,s0,-36
    1a98:	00004097          	auipc	ra,0x4
    1a9c:	b7e080e7          	jalr	-1154(ra) # 5616 <wait>
    if(xstatus != 0) {
    1aa0:	fdc42783          	lw	a5,-36(s0)
    1aa4:	e3b5                	bnez	a5,1b08 <forkfork+0xae>
}
    1aa6:	70a2                	ld	ra,40(sp)
    1aa8:	7402                	ld	s0,32(sp)
    1aaa:	64e2                	ld	s1,24(sp)
    1aac:	6145                	addi	sp,sp,48
    1aae:	8082                	ret
      printf("%s: fork failed", s);
    1ab0:	85a6                	mv	a1,s1
    1ab2:	00005517          	auipc	a0,0x5
    1ab6:	dce50513          	addi	a0,a0,-562 # 6880 <malloc+0xe34>
    1aba:	00004097          	auipc	ra,0x4
    1abe:	ed4080e7          	jalr	-300(ra) # 598e <printf>
      exit(1);
    1ac2:	4505                	li	a0,1
    1ac4:	00004097          	auipc	ra,0x4
    1ac8:	b4a080e7          	jalr	-1206(ra) # 560e <exit>
{
    1acc:	0c800493          	li	s1,200
        int pid1 = fork();
    1ad0:	00004097          	auipc	ra,0x4
    1ad4:	b36080e7          	jalr	-1226(ra) # 5606 <fork>
        if(pid1 < 0){
    1ad8:	00054f63          	bltz	a0,1af6 <forkfork+0x9c>
        if(pid1 == 0){
    1adc:	c115                	beqz	a0,1b00 <forkfork+0xa6>
        wait(0);
    1ade:	4501                	li	a0,0
    1ae0:	00004097          	auipc	ra,0x4
    1ae4:	b36080e7          	jalr	-1226(ra) # 5616 <wait>
      for(int j = 0; j < 200; j++){
    1ae8:	34fd                	addiw	s1,s1,-1
    1aea:	f0fd                	bnez	s1,1ad0 <forkfork+0x76>
      exit(0);
    1aec:	4501                	li	a0,0
    1aee:	00004097          	auipc	ra,0x4
    1af2:	b20080e7          	jalr	-1248(ra) # 560e <exit>
          exit(1);
    1af6:	4505                	li	a0,1
    1af8:	00004097          	auipc	ra,0x4
    1afc:	b16080e7          	jalr	-1258(ra) # 560e <exit>
          exit(0);
    1b00:	00004097          	auipc	ra,0x4
    1b04:	b0e080e7          	jalr	-1266(ra) # 560e <exit>
      printf("%s: fork in child failed", s);
    1b08:	85a6                	mv	a1,s1
    1b0a:	00005517          	auipc	a0,0x5
    1b0e:	d8650513          	addi	a0,a0,-634 # 6890 <malloc+0xe44>
    1b12:	00004097          	auipc	ra,0x4
    1b16:	e7c080e7          	jalr	-388(ra) # 598e <printf>
      exit(1);
    1b1a:	4505                	li	a0,1
    1b1c:	00004097          	auipc	ra,0x4
    1b20:	af2080e7          	jalr	-1294(ra) # 560e <exit>

0000000000001b24 <reparent2>:
{
    1b24:	1101                	addi	sp,sp,-32
    1b26:	ec06                	sd	ra,24(sp)
    1b28:	e822                	sd	s0,16(sp)
    1b2a:	e426                	sd	s1,8(sp)
    1b2c:	1000                	addi	s0,sp,32
    1b2e:	32000493          	li	s1,800
    int pid1 = fork();
    1b32:	00004097          	auipc	ra,0x4
    1b36:	ad4080e7          	jalr	-1324(ra) # 5606 <fork>
    if(pid1 < 0){
    1b3a:	00054f63          	bltz	a0,1b58 <reparent2+0x34>
    if(pid1 == 0){
    1b3e:	c915                	beqz	a0,1b72 <reparent2+0x4e>
    wait(0);
    1b40:	4501                	li	a0,0
    1b42:	00004097          	auipc	ra,0x4
    1b46:	ad4080e7          	jalr	-1324(ra) # 5616 <wait>
  for(int i = 0; i < 800; i++){
    1b4a:	34fd                	addiw	s1,s1,-1
    1b4c:	f0fd                	bnez	s1,1b32 <reparent2+0xe>
  exit(0);
    1b4e:	4501                	li	a0,0
    1b50:	00004097          	auipc	ra,0x4
    1b54:	abe080e7          	jalr	-1346(ra) # 560e <exit>
      printf("fork failed\n");
    1b58:	00005517          	auipc	a0,0x5
    1b5c:	f7050513          	addi	a0,a0,-144 # 6ac8 <malloc+0x107c>
    1b60:	00004097          	auipc	ra,0x4
    1b64:	e2e080e7          	jalr	-466(ra) # 598e <printf>
      exit(1);
    1b68:	4505                	li	a0,1
    1b6a:	00004097          	auipc	ra,0x4
    1b6e:	aa4080e7          	jalr	-1372(ra) # 560e <exit>
      fork();
    1b72:	00004097          	auipc	ra,0x4
    1b76:	a94080e7          	jalr	-1388(ra) # 5606 <fork>
      fork();
    1b7a:	00004097          	auipc	ra,0x4
    1b7e:	a8c080e7          	jalr	-1396(ra) # 5606 <fork>
      exit(0);
    1b82:	4501                	li	a0,0
    1b84:	00004097          	auipc	ra,0x4
    1b88:	a8a080e7          	jalr	-1398(ra) # 560e <exit>

0000000000001b8c <createdelete>:
{
    1b8c:	7175                	addi	sp,sp,-144
    1b8e:	e506                	sd	ra,136(sp)
    1b90:	e122                	sd	s0,128(sp)
    1b92:	fca6                	sd	s1,120(sp)
    1b94:	f8ca                	sd	s2,112(sp)
    1b96:	f4ce                	sd	s3,104(sp)
    1b98:	f0d2                	sd	s4,96(sp)
    1b9a:	ecd6                	sd	s5,88(sp)
    1b9c:	e8da                	sd	s6,80(sp)
    1b9e:	e4de                	sd	s7,72(sp)
    1ba0:	e0e2                	sd	s8,64(sp)
    1ba2:	fc66                	sd	s9,56(sp)
    1ba4:	0900                	addi	s0,sp,144
    1ba6:	8caa                	mv	s9,a0
  for(pi = 0; pi < NCHILD; pi++){
    1ba8:	4901                	li	s2,0
    1baa:	4991                	li	s3,4
    pid = fork();
    1bac:	00004097          	auipc	ra,0x4
    1bb0:	a5a080e7          	jalr	-1446(ra) # 5606 <fork>
    1bb4:	84aa                	mv	s1,a0
    if(pid < 0){
    1bb6:	02054f63          	bltz	a0,1bf4 <createdelete+0x68>
    if(pid == 0){
    1bba:	c939                	beqz	a0,1c10 <createdelete+0x84>
  for(pi = 0; pi < NCHILD; pi++){
    1bbc:	2905                	addiw	s2,s2,1
    1bbe:	ff3917e3          	bne	s2,s3,1bac <createdelete+0x20>
    1bc2:	4491                	li	s1,4
    wait(&xstatus);
    1bc4:	f7c40513          	addi	a0,s0,-132
    1bc8:	00004097          	auipc	ra,0x4
    1bcc:	a4e080e7          	jalr	-1458(ra) # 5616 <wait>
    if(xstatus != 0)
    1bd0:	f7c42903          	lw	s2,-132(s0)
    1bd4:	0e091263          	bnez	s2,1cb8 <createdelete+0x12c>
  for(pi = 0; pi < NCHILD; pi++){
    1bd8:	34fd                	addiw	s1,s1,-1
    1bda:	f4ed                	bnez	s1,1bc4 <createdelete+0x38>
  name[0] = name[1] = name[2] = 0;
    1bdc:	f8040123          	sb	zero,-126(s0)
    1be0:	03000993          	li	s3,48
    1be4:	5a7d                	li	s4,-1
    1be6:	07000c13          	li	s8,112
      } else if((i >= 1 && i < N/2) && fd >= 0){
    1bea:	4b21                	li	s6,8
      if((i == 0 || i >= N/2) && fd < 0){
    1bec:	4ba5                	li	s7,9
    for(pi = 0; pi < NCHILD; pi++){
    1bee:	07400a93          	li	s5,116
    1bf2:	a29d                	j	1d58 <createdelete+0x1cc>
      printf("fork failed\n", s);
    1bf4:	85e6                	mv	a1,s9
    1bf6:	00005517          	auipc	a0,0x5
    1bfa:	ed250513          	addi	a0,a0,-302 # 6ac8 <malloc+0x107c>
    1bfe:	00004097          	auipc	ra,0x4
    1c02:	d90080e7          	jalr	-624(ra) # 598e <printf>
      exit(1);
    1c06:	4505                	li	a0,1
    1c08:	00004097          	auipc	ra,0x4
    1c0c:	a06080e7          	jalr	-1530(ra) # 560e <exit>
      name[0] = 'p' + pi;
    1c10:	0709091b          	addiw	s2,s2,112
    1c14:	f9240023          	sb	s2,-128(s0)
      name[2] = '\0';
    1c18:	f8040123          	sb	zero,-126(s0)
      for(i = 0; i < N; i++){
    1c1c:	4951                	li	s2,20
    1c1e:	a015                	j	1c42 <createdelete+0xb6>
          printf("%s: create failed\n", s);
    1c20:	85e6                	mv	a1,s9
    1c22:	00005517          	auipc	a0,0x5
    1c26:	b3650513          	addi	a0,a0,-1226 # 6758 <malloc+0xd0c>
    1c2a:	00004097          	auipc	ra,0x4
    1c2e:	d64080e7          	jalr	-668(ra) # 598e <printf>
          exit(1);
    1c32:	4505                	li	a0,1
    1c34:	00004097          	auipc	ra,0x4
    1c38:	9da080e7          	jalr	-1574(ra) # 560e <exit>
      for(i = 0; i < N; i++){
    1c3c:	2485                	addiw	s1,s1,1
    1c3e:	07248863          	beq	s1,s2,1cae <createdelete+0x122>
        name[1] = '0' + i;
    1c42:	0304879b          	addiw	a5,s1,48
    1c46:	f8f400a3          	sb	a5,-127(s0)
        fd = open(name, O_CREATE | O_RDWR);
    1c4a:	20200593          	li	a1,514
    1c4e:	f8040513          	addi	a0,s0,-128
    1c52:	00004097          	auipc	ra,0x4
    1c56:	9fc080e7          	jalr	-1540(ra) # 564e <open>
        if(fd < 0){
    1c5a:	fc0543e3          	bltz	a0,1c20 <createdelete+0x94>
        close(fd);
    1c5e:	00004097          	auipc	ra,0x4
    1c62:	9d8080e7          	jalr	-1576(ra) # 5636 <close>
        if(i > 0 && (i % 2 ) == 0){
    1c66:	fc905be3          	blez	s1,1c3c <createdelete+0xb0>
    1c6a:	0014f793          	andi	a5,s1,1
    1c6e:	f7f9                	bnez	a5,1c3c <createdelete+0xb0>
          name[1] = '0' + (i / 2);
    1c70:	01f4d79b          	srliw	a5,s1,0x1f
    1c74:	9fa5                	addw	a5,a5,s1
    1c76:	4017d79b          	sraiw	a5,a5,0x1
    1c7a:	0307879b          	addiw	a5,a5,48
    1c7e:	f8f400a3          	sb	a5,-127(s0)
          if(unlink(name) < 0){
    1c82:	f8040513          	addi	a0,s0,-128
    1c86:	00004097          	auipc	ra,0x4
    1c8a:	9d8080e7          	jalr	-1576(ra) # 565e <unlink>
    1c8e:	fa0557e3          	bgez	a0,1c3c <createdelete+0xb0>
            printf("%s: unlink failed\n", s);
    1c92:	85e6                	mv	a1,s9
    1c94:	00005517          	auipc	a0,0x5
    1c98:	c1c50513          	addi	a0,a0,-996 # 68b0 <malloc+0xe64>
    1c9c:	00004097          	auipc	ra,0x4
    1ca0:	cf2080e7          	jalr	-782(ra) # 598e <printf>
            exit(1);
    1ca4:	4505                	li	a0,1
    1ca6:	00004097          	auipc	ra,0x4
    1caa:	968080e7          	jalr	-1688(ra) # 560e <exit>
      exit(0);
    1cae:	4501                	li	a0,0
    1cb0:	00004097          	auipc	ra,0x4
    1cb4:	95e080e7          	jalr	-1698(ra) # 560e <exit>
      exit(1);
    1cb8:	4505                	li	a0,1
    1cba:	00004097          	auipc	ra,0x4
    1cbe:	954080e7          	jalr	-1708(ra) # 560e <exit>
        printf("%s: oops createdelete %s didn't exist\n", s, name);
    1cc2:	f8040613          	addi	a2,s0,-128
    1cc6:	85e6                	mv	a1,s9
    1cc8:	00005517          	auipc	a0,0x5
    1ccc:	c0050513          	addi	a0,a0,-1024 # 68c8 <malloc+0xe7c>
    1cd0:	00004097          	auipc	ra,0x4
    1cd4:	cbe080e7          	jalr	-834(ra) # 598e <printf>
        exit(1);
    1cd8:	4505                	li	a0,1
    1cda:	00004097          	auipc	ra,0x4
    1cde:	934080e7          	jalr	-1740(ra) # 560e <exit>
      } else if((i >= 1 && i < N/2) && fd >= 0){
    1ce2:	054b7163          	bgeu	s6,s4,1d24 <createdelete+0x198>
      if(fd >= 0)
    1ce6:	02055a63          	bgez	a0,1d1a <createdelete+0x18e>
    for(pi = 0; pi < NCHILD; pi++){
    1cea:	2485                	addiw	s1,s1,1
    1cec:	0ff4f493          	andi	s1,s1,255
    1cf0:	05548c63          	beq	s1,s5,1d48 <createdelete+0x1bc>
      name[0] = 'p' + pi;
    1cf4:	f8940023          	sb	s1,-128(s0)
      name[1] = '0' + i;
    1cf8:	f93400a3          	sb	s3,-127(s0)
      fd = open(name, 0);
    1cfc:	4581                	li	a1,0
    1cfe:	f8040513          	addi	a0,s0,-128
    1d02:	00004097          	auipc	ra,0x4
    1d06:	94c080e7          	jalr	-1716(ra) # 564e <open>
      if((i == 0 || i >= N/2) && fd < 0){
    1d0a:	00090463          	beqz	s2,1d12 <createdelete+0x186>
    1d0e:	fd2bdae3          	bge	s7,s2,1ce2 <createdelete+0x156>
    1d12:	fa0548e3          	bltz	a0,1cc2 <createdelete+0x136>
      } else if((i >= 1 && i < N/2) && fd >= 0){
    1d16:	014b7963          	bgeu	s6,s4,1d28 <createdelete+0x19c>
        close(fd);
    1d1a:	00004097          	auipc	ra,0x4
    1d1e:	91c080e7          	jalr	-1764(ra) # 5636 <close>
    1d22:	b7e1                	j	1cea <createdelete+0x15e>
      } else if((i >= 1 && i < N/2) && fd >= 0){
    1d24:	fc0543e3          	bltz	a0,1cea <createdelete+0x15e>
        printf("%s: oops createdelete %s did exist\n", s, name);
    1d28:	f8040613          	addi	a2,s0,-128
    1d2c:	85e6                	mv	a1,s9
    1d2e:	00005517          	auipc	a0,0x5
    1d32:	bc250513          	addi	a0,a0,-1086 # 68f0 <malloc+0xea4>
    1d36:	00004097          	auipc	ra,0x4
    1d3a:	c58080e7          	jalr	-936(ra) # 598e <printf>
        exit(1);
    1d3e:	4505                	li	a0,1
    1d40:	00004097          	auipc	ra,0x4
    1d44:	8ce080e7          	jalr	-1842(ra) # 560e <exit>
  for(i = 0; i < N; i++){
    1d48:	2905                	addiw	s2,s2,1
    1d4a:	2a05                	addiw	s4,s4,1
    1d4c:	2985                	addiw	s3,s3,1
    1d4e:	0ff9f993          	andi	s3,s3,255
    1d52:	47d1                	li	a5,20
    1d54:	02f90a63          	beq	s2,a5,1d88 <createdelete+0x1fc>
    for(pi = 0; pi < NCHILD; pi++){
    1d58:	84e2                	mv	s1,s8
    1d5a:	bf69                	j	1cf4 <createdelete+0x168>
  for(i = 0; i < N; i++){
    1d5c:	2905                	addiw	s2,s2,1
    1d5e:	0ff97913          	andi	s2,s2,255
    1d62:	2985                	addiw	s3,s3,1
    1d64:	0ff9f993          	andi	s3,s3,255
    1d68:	03490863          	beq	s2,s4,1d98 <createdelete+0x20c>
  name[0] = name[1] = name[2] = 0;
    1d6c:	84d6                	mv	s1,s5
      name[0] = 'p' + i;
    1d6e:	f9240023          	sb	s2,-128(s0)
      name[1] = '0' + i;
    1d72:	f93400a3          	sb	s3,-127(s0)
      unlink(name);
    1d76:	f8040513          	addi	a0,s0,-128
    1d7a:	00004097          	auipc	ra,0x4
    1d7e:	8e4080e7          	jalr	-1820(ra) # 565e <unlink>
    for(pi = 0; pi < NCHILD; pi++){
    1d82:	34fd                	addiw	s1,s1,-1
    1d84:	f4ed                	bnez	s1,1d6e <createdelete+0x1e2>
    1d86:	bfd9                	j	1d5c <createdelete+0x1d0>
    1d88:	03000993          	li	s3,48
    1d8c:	07000913          	li	s2,112
  name[0] = name[1] = name[2] = 0;
    1d90:	4a91                	li	s5,4
  for(i = 0; i < N; i++){
    1d92:	08400a13          	li	s4,132
    1d96:	bfd9                	j	1d6c <createdelete+0x1e0>
}
    1d98:	60aa                	ld	ra,136(sp)
    1d9a:	640a                	ld	s0,128(sp)
    1d9c:	74e6                	ld	s1,120(sp)
    1d9e:	7946                	ld	s2,112(sp)
    1da0:	79a6                	ld	s3,104(sp)
    1da2:	7a06                	ld	s4,96(sp)
    1da4:	6ae6                	ld	s5,88(sp)
    1da6:	6b46                	ld	s6,80(sp)
    1da8:	6ba6                	ld	s7,72(sp)
    1daa:	6c06                	ld	s8,64(sp)
    1dac:	7ce2                	ld	s9,56(sp)
    1dae:	6149                	addi	sp,sp,144
    1db0:	8082                	ret

0000000000001db2 <linkunlink>:
{
    1db2:	711d                	addi	sp,sp,-96
    1db4:	ec86                	sd	ra,88(sp)
    1db6:	e8a2                	sd	s0,80(sp)
    1db8:	e4a6                	sd	s1,72(sp)
    1dba:	e0ca                	sd	s2,64(sp)
    1dbc:	fc4e                	sd	s3,56(sp)
    1dbe:	f852                	sd	s4,48(sp)
    1dc0:	f456                	sd	s5,40(sp)
    1dc2:	f05a                	sd	s6,32(sp)
    1dc4:	ec5e                	sd	s7,24(sp)
    1dc6:	e862                	sd	s8,16(sp)
    1dc8:	e466                	sd	s9,8(sp)
    1dca:	1080                	addi	s0,sp,96
    1dcc:	84aa                	mv	s1,a0
  unlink("x");
    1dce:	00004517          	auipc	a0,0x4
    1dd2:	12a50513          	addi	a0,a0,298 # 5ef8 <malloc+0x4ac>
    1dd6:	00004097          	auipc	ra,0x4
    1dda:	888080e7          	jalr	-1912(ra) # 565e <unlink>
  pid = fork();
    1dde:	00004097          	auipc	ra,0x4
    1de2:	828080e7          	jalr	-2008(ra) # 5606 <fork>
  if(pid < 0){
    1de6:	02054b63          	bltz	a0,1e1c <linkunlink+0x6a>
    1dea:	8c2a                	mv	s8,a0
  unsigned int x = (pid ? 1 : 97);
    1dec:	4c85                	li	s9,1
    1dee:	e119                	bnez	a0,1df4 <linkunlink+0x42>
    1df0:	06100c93          	li	s9,97
    1df4:	06400493          	li	s1,100
    x = x * 1103515245 + 12345;
    1df8:	41c659b7          	lui	s3,0x41c65
    1dfc:	e6d9899b          	addiw	s3,s3,-403
    1e00:	690d                	lui	s2,0x3
    1e02:	0399091b          	addiw	s2,s2,57
    if((x % 3) == 0){
    1e06:	4a0d                	li	s4,3
    } else if((x % 3) == 1){
    1e08:	4b05                	li	s6,1
      unlink("x");
    1e0a:	00004a97          	auipc	s5,0x4
    1e0e:	0eea8a93          	addi	s5,s5,238 # 5ef8 <malloc+0x4ac>
      link("cat", "x");
    1e12:	00005b97          	auipc	s7,0x5
    1e16:	b06b8b93          	addi	s7,s7,-1274 # 6918 <malloc+0xecc>
    1e1a:	a825                	j	1e52 <linkunlink+0xa0>
    printf("%s: fork failed\n", s);
    1e1c:	85a6                	mv	a1,s1
    1e1e:	00005517          	auipc	a0,0x5
    1e22:	8a250513          	addi	a0,a0,-1886 # 66c0 <malloc+0xc74>
    1e26:	00004097          	auipc	ra,0x4
    1e2a:	b68080e7          	jalr	-1176(ra) # 598e <printf>
    exit(1);
    1e2e:	4505                	li	a0,1
    1e30:	00003097          	auipc	ra,0x3
    1e34:	7de080e7          	jalr	2014(ra) # 560e <exit>
      close(open("x", O_RDWR | O_CREATE));
    1e38:	20200593          	li	a1,514
    1e3c:	8556                	mv	a0,s5
    1e3e:	00004097          	auipc	ra,0x4
    1e42:	810080e7          	jalr	-2032(ra) # 564e <open>
    1e46:	00003097          	auipc	ra,0x3
    1e4a:	7f0080e7          	jalr	2032(ra) # 5636 <close>
  for(i = 0; i < 100; i++){
    1e4e:	34fd                	addiw	s1,s1,-1
    1e50:	c88d                	beqz	s1,1e82 <linkunlink+0xd0>
    x = x * 1103515245 + 12345;
    1e52:	033c87bb          	mulw	a5,s9,s3
    1e56:	012787bb          	addw	a5,a5,s2
    1e5a:	00078c9b          	sext.w	s9,a5
    if((x % 3) == 0){
    1e5e:	0347f7bb          	remuw	a5,a5,s4
    1e62:	dbf9                	beqz	a5,1e38 <linkunlink+0x86>
    } else if((x % 3) == 1){
    1e64:	01678863          	beq	a5,s6,1e74 <linkunlink+0xc2>
      unlink("x");
    1e68:	8556                	mv	a0,s5
    1e6a:	00003097          	auipc	ra,0x3
    1e6e:	7f4080e7          	jalr	2036(ra) # 565e <unlink>
    1e72:	bff1                	j	1e4e <linkunlink+0x9c>
      link("cat", "x");
    1e74:	85d6                	mv	a1,s5
    1e76:	855e                	mv	a0,s7
    1e78:	00003097          	auipc	ra,0x3
    1e7c:	7f6080e7          	jalr	2038(ra) # 566e <link>
    1e80:	b7f9                	j	1e4e <linkunlink+0x9c>
  if(pid)
    1e82:	020c0463          	beqz	s8,1eaa <linkunlink+0xf8>
    wait(0);
    1e86:	4501                	li	a0,0
    1e88:	00003097          	auipc	ra,0x3
    1e8c:	78e080e7          	jalr	1934(ra) # 5616 <wait>
}
    1e90:	60e6                	ld	ra,88(sp)
    1e92:	6446                	ld	s0,80(sp)
    1e94:	64a6                	ld	s1,72(sp)
    1e96:	6906                	ld	s2,64(sp)
    1e98:	79e2                	ld	s3,56(sp)
    1e9a:	7a42                	ld	s4,48(sp)
    1e9c:	7aa2                	ld	s5,40(sp)
    1e9e:	7b02                	ld	s6,32(sp)
    1ea0:	6be2                	ld	s7,24(sp)
    1ea2:	6c42                	ld	s8,16(sp)
    1ea4:	6ca2                	ld	s9,8(sp)
    1ea6:	6125                	addi	sp,sp,96
    1ea8:	8082                	ret
    exit(0);
    1eaa:	4501                	li	a0,0
    1eac:	00003097          	auipc	ra,0x3
    1eb0:	762080e7          	jalr	1890(ra) # 560e <exit>

0000000000001eb4 <manywrites>:
{
    1eb4:	711d                	addi	sp,sp,-96
    1eb6:	ec86                	sd	ra,88(sp)
    1eb8:	e8a2                	sd	s0,80(sp)
    1eba:	e4a6                	sd	s1,72(sp)
    1ebc:	e0ca                	sd	s2,64(sp)
    1ebe:	fc4e                	sd	s3,56(sp)
    1ec0:	f852                	sd	s4,48(sp)
    1ec2:	f456                	sd	s5,40(sp)
    1ec4:	f05a                	sd	s6,32(sp)
    1ec6:	ec5e                	sd	s7,24(sp)
    1ec8:	1080                	addi	s0,sp,96
    1eca:	8aaa                	mv	s5,a0
  for(int ci = 0; ci < nchildren; ci++){
    1ecc:	4981                	li	s3,0
    1ece:	4911                	li	s2,4
    int pid = fork();
    1ed0:	00003097          	auipc	ra,0x3
    1ed4:	736080e7          	jalr	1846(ra) # 5606 <fork>
    1ed8:	84aa                	mv	s1,a0
    if(pid < 0){
    1eda:	02054963          	bltz	a0,1f0c <manywrites+0x58>
    if(pid == 0){
    1ede:	c521                	beqz	a0,1f26 <manywrites+0x72>
  for(int ci = 0; ci < nchildren; ci++){
    1ee0:	2985                	addiw	s3,s3,1
    1ee2:	ff2997e3          	bne	s3,s2,1ed0 <manywrites+0x1c>
    1ee6:	4491                	li	s1,4
    int st = 0;
    1ee8:	fa042423          	sw	zero,-88(s0)
    wait(&st);
    1eec:	fa840513          	addi	a0,s0,-88
    1ef0:	00003097          	auipc	ra,0x3
    1ef4:	726080e7          	jalr	1830(ra) # 5616 <wait>
    if(st != 0)
    1ef8:	fa842503          	lw	a0,-88(s0)
    1efc:	ed6d                	bnez	a0,1ff6 <manywrites+0x142>
  for(int ci = 0; ci < nchildren; ci++){
    1efe:	34fd                	addiw	s1,s1,-1
    1f00:	f4e5                	bnez	s1,1ee8 <manywrites+0x34>
  exit(0);
    1f02:	4501                	li	a0,0
    1f04:	00003097          	auipc	ra,0x3
    1f08:	70a080e7          	jalr	1802(ra) # 560e <exit>
      printf("fork failed\n");
    1f0c:	00005517          	auipc	a0,0x5
    1f10:	bbc50513          	addi	a0,a0,-1092 # 6ac8 <malloc+0x107c>
    1f14:	00004097          	auipc	ra,0x4
    1f18:	a7a080e7          	jalr	-1414(ra) # 598e <printf>
      exit(1);
    1f1c:	4505                	li	a0,1
    1f1e:	00003097          	auipc	ra,0x3
    1f22:	6f0080e7          	jalr	1776(ra) # 560e <exit>
      name[0] = 'b';
    1f26:	06200793          	li	a5,98
    1f2a:	faf40423          	sb	a5,-88(s0)
      name[1] = 'a' + ci;
    1f2e:	0619879b          	addiw	a5,s3,97
    1f32:	faf404a3          	sb	a5,-87(s0)
      name[2] = '\0';
    1f36:	fa040523          	sb	zero,-86(s0)
      unlink(name);
    1f3a:	fa840513          	addi	a0,s0,-88
    1f3e:	00003097          	auipc	ra,0x3
    1f42:	720080e7          	jalr	1824(ra) # 565e <unlink>
    1f46:	4bf9                	li	s7,30
          int cc = write(fd, buf, sz);
    1f48:	0000ab17          	auipc	s6,0xa
    1f4c:	b58b0b13          	addi	s6,s6,-1192 # baa0 <buf>
        for(int i = 0; i < ci+1; i++){
    1f50:	8a26                	mv	s4,s1
    1f52:	0209ce63          	bltz	s3,1f8e <manywrites+0xda>
          int fd = open(name, O_CREATE | O_RDWR);
    1f56:	20200593          	li	a1,514
    1f5a:	fa840513          	addi	a0,s0,-88
    1f5e:	00003097          	auipc	ra,0x3
    1f62:	6f0080e7          	jalr	1776(ra) # 564e <open>
    1f66:	892a                	mv	s2,a0
          if(fd < 0){
    1f68:	04054763          	bltz	a0,1fb6 <manywrites+0x102>
          int cc = write(fd, buf, sz);
    1f6c:	660d                	lui	a2,0x3
    1f6e:	85da                	mv	a1,s6
    1f70:	00003097          	auipc	ra,0x3
    1f74:	6be080e7          	jalr	1726(ra) # 562e <write>
          if(cc != sz){
    1f78:	678d                	lui	a5,0x3
    1f7a:	04f51e63          	bne	a0,a5,1fd6 <manywrites+0x122>
          close(fd);
    1f7e:	854a                	mv	a0,s2
    1f80:	00003097          	auipc	ra,0x3
    1f84:	6b6080e7          	jalr	1718(ra) # 5636 <close>
        for(int i = 0; i < ci+1; i++){
    1f88:	2a05                	addiw	s4,s4,1
    1f8a:	fd49d6e3          	bge	s3,s4,1f56 <manywrites+0xa2>
        unlink(name);
    1f8e:	fa840513          	addi	a0,s0,-88
    1f92:	00003097          	auipc	ra,0x3
    1f96:	6cc080e7          	jalr	1740(ra) # 565e <unlink>
      for(int iters = 0; iters < howmany; iters++){
    1f9a:	3bfd                	addiw	s7,s7,-1
    1f9c:	fa0b9ae3          	bnez	s7,1f50 <manywrites+0x9c>
      unlink(name);
    1fa0:	fa840513          	addi	a0,s0,-88
    1fa4:	00003097          	auipc	ra,0x3
    1fa8:	6ba080e7          	jalr	1722(ra) # 565e <unlink>
      exit(0);
    1fac:	4501                	li	a0,0
    1fae:	00003097          	auipc	ra,0x3
    1fb2:	660080e7          	jalr	1632(ra) # 560e <exit>
            printf("%s: cannot create %s\n", s, name);
    1fb6:	fa840613          	addi	a2,s0,-88
    1fba:	85d6                	mv	a1,s5
    1fbc:	00005517          	auipc	a0,0x5
    1fc0:	96450513          	addi	a0,a0,-1692 # 6920 <malloc+0xed4>
    1fc4:	00004097          	auipc	ra,0x4
    1fc8:	9ca080e7          	jalr	-1590(ra) # 598e <printf>
            exit(1);
    1fcc:	4505                	li	a0,1
    1fce:	00003097          	auipc	ra,0x3
    1fd2:	640080e7          	jalr	1600(ra) # 560e <exit>
            printf("%s: write(%d) ret %d\n", s, sz, cc);
    1fd6:	86aa                	mv	a3,a0
    1fd8:	660d                	lui	a2,0x3
    1fda:	85d6                	mv	a1,s5
    1fdc:	00004517          	auipc	a0,0x4
    1fe0:	f6c50513          	addi	a0,a0,-148 # 5f48 <malloc+0x4fc>
    1fe4:	00004097          	auipc	ra,0x4
    1fe8:	9aa080e7          	jalr	-1622(ra) # 598e <printf>
            exit(1);
    1fec:	4505                	li	a0,1
    1fee:	00003097          	auipc	ra,0x3
    1ff2:	620080e7          	jalr	1568(ra) # 560e <exit>
      exit(st);
    1ff6:	00003097          	auipc	ra,0x3
    1ffa:	618080e7          	jalr	1560(ra) # 560e <exit>

0000000000001ffe <forktest>:
{
    1ffe:	7179                	addi	sp,sp,-48
    2000:	f406                	sd	ra,40(sp)
    2002:	f022                	sd	s0,32(sp)
    2004:	ec26                	sd	s1,24(sp)
    2006:	e84a                	sd	s2,16(sp)
    2008:	e44e                	sd	s3,8(sp)
    200a:	1800                	addi	s0,sp,48
    200c:	89aa                	mv	s3,a0
  for(n=0; n<N; n++){
    200e:	4481                	li	s1,0
    2010:	3e800913          	li	s2,1000
    pid = fork();
    2014:	00003097          	auipc	ra,0x3
    2018:	5f2080e7          	jalr	1522(ra) # 5606 <fork>
    if(pid < 0)
    201c:	02054863          	bltz	a0,204c <forktest+0x4e>
    if(pid == 0)
    2020:	c115                	beqz	a0,2044 <forktest+0x46>
  for(n=0; n<N; n++){
    2022:	2485                	addiw	s1,s1,1
    2024:	ff2498e3          	bne	s1,s2,2014 <forktest+0x16>
    printf("%s: fork claimed to work 1000 times!\n", s);
    2028:	85ce                	mv	a1,s3
    202a:	00005517          	auipc	a0,0x5
    202e:	92650513          	addi	a0,a0,-1754 # 6950 <malloc+0xf04>
    2032:	00004097          	auipc	ra,0x4
    2036:	95c080e7          	jalr	-1700(ra) # 598e <printf>
    exit(1);
    203a:	4505                	li	a0,1
    203c:	00003097          	auipc	ra,0x3
    2040:	5d2080e7          	jalr	1490(ra) # 560e <exit>
      exit(0);
    2044:	00003097          	auipc	ra,0x3
    2048:	5ca080e7          	jalr	1482(ra) # 560e <exit>
  if (n == 0) {
    204c:	cc9d                	beqz	s1,208a <forktest+0x8c>
  if(n == N){
    204e:	3e800793          	li	a5,1000
    2052:	fcf48be3          	beq	s1,a5,2028 <forktest+0x2a>
  for(; n > 0; n--){
    2056:	00905b63          	blez	s1,206c <forktest+0x6e>
    if(wait(0) < 0){
    205a:	4501                	li	a0,0
    205c:	00003097          	auipc	ra,0x3
    2060:	5ba080e7          	jalr	1466(ra) # 5616 <wait>
    2064:	04054163          	bltz	a0,20a6 <forktest+0xa8>
  for(; n > 0; n--){
    2068:	34fd                	addiw	s1,s1,-1
    206a:	f8e5                	bnez	s1,205a <forktest+0x5c>
  if(wait(0) != -1){
    206c:	4501                	li	a0,0
    206e:	00003097          	auipc	ra,0x3
    2072:	5a8080e7          	jalr	1448(ra) # 5616 <wait>
    2076:	57fd                	li	a5,-1
    2078:	04f51563          	bne	a0,a5,20c2 <forktest+0xc4>
}
    207c:	70a2                	ld	ra,40(sp)
    207e:	7402                	ld	s0,32(sp)
    2080:	64e2                	ld	s1,24(sp)
    2082:	6942                	ld	s2,16(sp)
    2084:	69a2                	ld	s3,8(sp)
    2086:	6145                	addi	sp,sp,48
    2088:	8082                	ret
    printf("%s: no fork at all!\n", s);
    208a:	85ce                	mv	a1,s3
    208c:	00005517          	auipc	a0,0x5
    2090:	8ac50513          	addi	a0,a0,-1876 # 6938 <malloc+0xeec>
    2094:	00004097          	auipc	ra,0x4
    2098:	8fa080e7          	jalr	-1798(ra) # 598e <printf>
    exit(1);
    209c:	4505                	li	a0,1
    209e:	00003097          	auipc	ra,0x3
    20a2:	570080e7          	jalr	1392(ra) # 560e <exit>
      printf("%s: wait stopped early\n", s);
    20a6:	85ce                	mv	a1,s3
    20a8:	00005517          	auipc	a0,0x5
    20ac:	8d050513          	addi	a0,a0,-1840 # 6978 <malloc+0xf2c>
    20b0:	00004097          	auipc	ra,0x4
    20b4:	8de080e7          	jalr	-1826(ra) # 598e <printf>
      exit(1);
    20b8:	4505                	li	a0,1
    20ba:	00003097          	auipc	ra,0x3
    20be:	554080e7          	jalr	1364(ra) # 560e <exit>
    printf("%s: wait got too many\n", s);
    20c2:	85ce                	mv	a1,s3
    20c4:	00005517          	auipc	a0,0x5
    20c8:	8cc50513          	addi	a0,a0,-1844 # 6990 <malloc+0xf44>
    20cc:	00004097          	auipc	ra,0x4
    20d0:	8c2080e7          	jalr	-1854(ra) # 598e <printf>
    exit(1);
    20d4:	4505                	li	a0,1
    20d6:	00003097          	auipc	ra,0x3
    20da:	538080e7          	jalr	1336(ra) # 560e <exit>

00000000000020de <kernmem>:
{
    20de:	715d                	addi	sp,sp,-80
    20e0:	e486                	sd	ra,72(sp)
    20e2:	e0a2                	sd	s0,64(sp)
    20e4:	fc26                	sd	s1,56(sp)
    20e6:	f84a                	sd	s2,48(sp)
    20e8:	f44e                	sd	s3,40(sp)
    20ea:	f052                	sd	s4,32(sp)
    20ec:	ec56                	sd	s5,24(sp)
    20ee:	0880                	addi	s0,sp,80
    20f0:	8a2a                	mv	s4,a0
  for(a = (char*)(KERNBASE); a < (char*) (KERNBASE+2000000); a += 50000){
    20f2:	4485                	li	s1,1
    20f4:	04fe                	slli	s1,s1,0x1f
    if(xstatus != -1)  // did kernel kill child?
    20f6:	5afd                	li	s5,-1
  for(a = (char*)(KERNBASE); a < (char*) (KERNBASE+2000000); a += 50000){
    20f8:	69b1                	lui	s3,0xc
    20fa:	35098993          	addi	s3,s3,848 # c350 <buf+0x8b0>
    20fe:	1003d937          	lui	s2,0x1003d
    2102:	090e                	slli	s2,s2,0x3
    2104:	48090913          	addi	s2,s2,1152 # 1003d480 <__BSS_END__+0x1002e9d0>
    pid = fork();
    2108:	00003097          	auipc	ra,0x3
    210c:	4fe080e7          	jalr	1278(ra) # 5606 <fork>
    if(pid < 0){
    2110:	02054963          	bltz	a0,2142 <kernmem+0x64>
    if(pid == 0){
    2114:	c529                	beqz	a0,215e <kernmem+0x80>
    wait(&xstatus);
    2116:	fbc40513          	addi	a0,s0,-68
    211a:	00003097          	auipc	ra,0x3
    211e:	4fc080e7          	jalr	1276(ra) # 5616 <wait>
    if(xstatus != -1)  // did kernel kill child?
    2122:	fbc42783          	lw	a5,-68(s0)
    2126:	05579d63          	bne	a5,s5,2180 <kernmem+0xa2>
  for(a = (char*)(KERNBASE); a < (char*) (KERNBASE+2000000); a += 50000){
    212a:	94ce                	add	s1,s1,s3
    212c:	fd249ee3          	bne	s1,s2,2108 <kernmem+0x2a>
}
    2130:	60a6                	ld	ra,72(sp)
    2132:	6406                	ld	s0,64(sp)
    2134:	74e2                	ld	s1,56(sp)
    2136:	7942                	ld	s2,48(sp)
    2138:	79a2                	ld	s3,40(sp)
    213a:	7a02                	ld	s4,32(sp)
    213c:	6ae2                	ld	s5,24(sp)
    213e:	6161                	addi	sp,sp,80
    2140:	8082                	ret
      printf("%s: fork failed\n", s);
    2142:	85d2                	mv	a1,s4
    2144:	00004517          	auipc	a0,0x4
    2148:	57c50513          	addi	a0,a0,1404 # 66c0 <malloc+0xc74>
    214c:	00004097          	auipc	ra,0x4
    2150:	842080e7          	jalr	-1982(ra) # 598e <printf>
      exit(1);
    2154:	4505                	li	a0,1
    2156:	00003097          	auipc	ra,0x3
    215a:	4b8080e7          	jalr	1208(ra) # 560e <exit>
      printf("%s: oops could read %x = %x\n", s, a, *a);
    215e:	0004c683          	lbu	a3,0(s1)
    2162:	8626                	mv	a2,s1
    2164:	85d2                	mv	a1,s4
    2166:	00005517          	auipc	a0,0x5
    216a:	84250513          	addi	a0,a0,-1982 # 69a8 <malloc+0xf5c>
    216e:	00004097          	auipc	ra,0x4
    2172:	820080e7          	jalr	-2016(ra) # 598e <printf>
      exit(1);
    2176:	4505                	li	a0,1
    2178:	00003097          	auipc	ra,0x3
    217c:	496080e7          	jalr	1174(ra) # 560e <exit>
      exit(1);
    2180:	4505                	li	a0,1
    2182:	00003097          	auipc	ra,0x3
    2186:	48c080e7          	jalr	1164(ra) # 560e <exit>

000000000000218a <bigargtest>:
{
    218a:	7179                	addi	sp,sp,-48
    218c:	f406                	sd	ra,40(sp)
    218e:	f022                	sd	s0,32(sp)
    2190:	ec26                	sd	s1,24(sp)
    2192:	1800                	addi	s0,sp,48
    2194:	84aa                	mv	s1,a0
  unlink("bigarg-ok");
    2196:	00005517          	auipc	a0,0x5
    219a:	83250513          	addi	a0,a0,-1998 # 69c8 <malloc+0xf7c>
    219e:	00003097          	auipc	ra,0x3
    21a2:	4c0080e7          	jalr	1216(ra) # 565e <unlink>
  pid = fork();
    21a6:	00003097          	auipc	ra,0x3
    21aa:	460080e7          	jalr	1120(ra) # 5606 <fork>
  if(pid == 0){
    21ae:	c121                	beqz	a0,21ee <bigargtest+0x64>
  } else if(pid < 0){
    21b0:	0a054063          	bltz	a0,2250 <bigargtest+0xc6>
  wait(&xstatus);
    21b4:	fdc40513          	addi	a0,s0,-36
    21b8:	00003097          	auipc	ra,0x3
    21bc:	45e080e7          	jalr	1118(ra) # 5616 <wait>
  if(xstatus != 0)
    21c0:	fdc42503          	lw	a0,-36(s0)
    21c4:	e545                	bnez	a0,226c <bigargtest+0xe2>
  fd = open("bigarg-ok", 0);
    21c6:	4581                	li	a1,0
    21c8:	00005517          	auipc	a0,0x5
    21cc:	80050513          	addi	a0,a0,-2048 # 69c8 <malloc+0xf7c>
    21d0:	00003097          	auipc	ra,0x3
    21d4:	47e080e7          	jalr	1150(ra) # 564e <open>
  if(fd < 0){
    21d8:	08054e63          	bltz	a0,2274 <bigargtest+0xea>
  close(fd);
    21dc:	00003097          	auipc	ra,0x3
    21e0:	45a080e7          	jalr	1114(ra) # 5636 <close>
}
    21e4:	70a2                	ld	ra,40(sp)
    21e6:	7402                	ld	s0,32(sp)
    21e8:	64e2                	ld	s1,24(sp)
    21ea:	6145                	addi	sp,sp,48
    21ec:	8082                	ret
    21ee:	00006797          	auipc	a5,0x6
    21f2:	09a78793          	addi	a5,a5,154 # 8288 <args.1>
    21f6:	00006697          	auipc	a3,0x6
    21fa:	18a68693          	addi	a3,a3,394 # 8380 <args.1+0xf8>
      args[i] = "bigargs test: failed\n                                                                                                                                                                                                       ";
    21fe:	00004717          	auipc	a4,0x4
    2202:	7da70713          	addi	a4,a4,2010 # 69d8 <malloc+0xf8c>
    2206:	e398                	sd	a4,0(a5)
    for(i = 0; i < MAXARG-1; i++)
    2208:	07a1                	addi	a5,a5,8
    220a:	fed79ee3          	bne	a5,a3,2206 <bigargtest+0x7c>
    args[MAXARG-1] = 0;
    220e:	00006597          	auipc	a1,0x6
    2212:	07a58593          	addi	a1,a1,122 # 8288 <args.1>
    2216:	0e05bc23          	sd	zero,248(a1)
    exec("echo", args);
    221a:	00004517          	auipc	a0,0x4
    221e:	c6e50513          	addi	a0,a0,-914 # 5e88 <malloc+0x43c>
    2222:	00003097          	auipc	ra,0x3
    2226:	424080e7          	jalr	1060(ra) # 5646 <exec>
    fd = open("bigarg-ok", O_CREATE);
    222a:	20000593          	li	a1,512
    222e:	00004517          	auipc	a0,0x4
    2232:	79a50513          	addi	a0,a0,1946 # 69c8 <malloc+0xf7c>
    2236:	00003097          	auipc	ra,0x3
    223a:	418080e7          	jalr	1048(ra) # 564e <open>
    close(fd);
    223e:	00003097          	auipc	ra,0x3
    2242:	3f8080e7          	jalr	1016(ra) # 5636 <close>
    exit(0);
    2246:	4501                	li	a0,0
    2248:	00003097          	auipc	ra,0x3
    224c:	3c6080e7          	jalr	966(ra) # 560e <exit>
    printf("%s: bigargtest: fork failed\n", s);
    2250:	85a6                	mv	a1,s1
    2252:	00005517          	auipc	a0,0x5
    2256:	86650513          	addi	a0,a0,-1946 # 6ab8 <malloc+0x106c>
    225a:	00003097          	auipc	ra,0x3
    225e:	734080e7          	jalr	1844(ra) # 598e <printf>
    exit(1);
    2262:	4505                	li	a0,1
    2264:	00003097          	auipc	ra,0x3
    2268:	3aa080e7          	jalr	938(ra) # 560e <exit>
    exit(xstatus);
    226c:	00003097          	auipc	ra,0x3
    2270:	3a2080e7          	jalr	930(ra) # 560e <exit>
    printf("%s: bigarg test failed!\n", s);
    2274:	85a6                	mv	a1,s1
    2276:	00005517          	auipc	a0,0x5
    227a:	86250513          	addi	a0,a0,-1950 # 6ad8 <malloc+0x108c>
    227e:	00003097          	auipc	ra,0x3
    2282:	710080e7          	jalr	1808(ra) # 598e <printf>
    exit(1);
    2286:	4505                	li	a0,1
    2288:	00003097          	auipc	ra,0x3
    228c:	386080e7          	jalr	902(ra) # 560e <exit>

0000000000002290 <stacktest>:
{
    2290:	7179                	addi	sp,sp,-48
    2292:	f406                	sd	ra,40(sp)
    2294:	f022                	sd	s0,32(sp)
    2296:	ec26                	sd	s1,24(sp)
    2298:	1800                	addi	s0,sp,48
    229a:	84aa                	mv	s1,a0
  pid = fork();
    229c:	00003097          	auipc	ra,0x3
    22a0:	36a080e7          	jalr	874(ra) # 5606 <fork>
  if(pid == 0) {
    22a4:	c115                	beqz	a0,22c8 <stacktest+0x38>
  } else if(pid < 0){
    22a6:	04054463          	bltz	a0,22ee <stacktest+0x5e>
  wait(&xstatus);
    22aa:	fdc40513          	addi	a0,s0,-36
    22ae:	00003097          	auipc	ra,0x3
    22b2:	368080e7          	jalr	872(ra) # 5616 <wait>
  if(xstatus == -1)  // kernel killed child?
    22b6:	fdc42503          	lw	a0,-36(s0)
    22ba:	57fd                	li	a5,-1
    22bc:	04f50763          	beq	a0,a5,230a <stacktest+0x7a>
    exit(xstatus);
    22c0:	00003097          	auipc	ra,0x3
    22c4:	34e080e7          	jalr	846(ra) # 560e <exit>

static inline uint64
r_sp()
{
  uint64 x;
  asm volatile("mv %0, sp" : "=r" (x) );
    22c8:	870a                	mv	a4,sp
    printf("%s: stacktest: read below stack %p\n", s, *sp);
    22ca:	77fd                	lui	a5,0xfffff
    22cc:	97ba                	add	a5,a5,a4
    22ce:	0007c603          	lbu	a2,0(a5) # fffffffffffff000 <__BSS_END__+0xffffffffffff0550>
    22d2:	85a6                	mv	a1,s1
    22d4:	00005517          	auipc	a0,0x5
    22d8:	82450513          	addi	a0,a0,-2012 # 6af8 <malloc+0x10ac>
    22dc:	00003097          	auipc	ra,0x3
    22e0:	6b2080e7          	jalr	1714(ra) # 598e <printf>
    exit(1);
    22e4:	4505                	li	a0,1
    22e6:	00003097          	auipc	ra,0x3
    22ea:	328080e7          	jalr	808(ra) # 560e <exit>
    printf("%s: fork failed\n", s);
    22ee:	85a6                	mv	a1,s1
    22f0:	00004517          	auipc	a0,0x4
    22f4:	3d050513          	addi	a0,a0,976 # 66c0 <malloc+0xc74>
    22f8:	00003097          	auipc	ra,0x3
    22fc:	696080e7          	jalr	1686(ra) # 598e <printf>
    exit(1);
    2300:	4505                	li	a0,1
    2302:	00003097          	auipc	ra,0x3
    2306:	30c080e7          	jalr	780(ra) # 560e <exit>
    exit(0);
    230a:	4501                	li	a0,0
    230c:	00003097          	auipc	ra,0x3
    2310:	302080e7          	jalr	770(ra) # 560e <exit>

0000000000002314 <copyinstr3>:
{
    2314:	7179                	addi	sp,sp,-48
    2316:	f406                	sd	ra,40(sp)
    2318:	f022                	sd	s0,32(sp)
    231a:	ec26                	sd	s1,24(sp)
    231c:	1800                	addi	s0,sp,48
  sbrk(8192);
    231e:	6509                	lui	a0,0x2
    2320:	00003097          	auipc	ra,0x3
    2324:	376080e7          	jalr	886(ra) # 5696 <sbrk>
  uint64 top = (uint64) sbrk(0);
    2328:	4501                	li	a0,0
    232a:	00003097          	auipc	ra,0x3
    232e:	36c080e7          	jalr	876(ra) # 5696 <sbrk>
  if((top % PGSIZE) != 0){
    2332:	03451793          	slli	a5,a0,0x34
    2336:	e3c9                	bnez	a5,23b8 <copyinstr3+0xa4>
  top = (uint64) sbrk(0);
    2338:	4501                	li	a0,0
    233a:	00003097          	auipc	ra,0x3
    233e:	35c080e7          	jalr	860(ra) # 5696 <sbrk>
  if(top % PGSIZE){
    2342:	03451793          	slli	a5,a0,0x34
    2346:	e3d9                	bnez	a5,23cc <copyinstr3+0xb8>
  char *b = (char *) (top - 1);
    2348:	fff50493          	addi	s1,a0,-1 # 1fff <forktest+0x1>
  *b = 'x';
    234c:	07800793          	li	a5,120
    2350:	fef50fa3          	sb	a5,-1(a0)
  int ret = unlink(b);
    2354:	8526                	mv	a0,s1
    2356:	00003097          	auipc	ra,0x3
    235a:	308080e7          	jalr	776(ra) # 565e <unlink>
  if(ret != -1){
    235e:	57fd                	li	a5,-1
    2360:	08f51363          	bne	a0,a5,23e6 <copyinstr3+0xd2>
  int fd = open(b, O_CREATE | O_WRONLY);
    2364:	20100593          	li	a1,513
    2368:	8526                	mv	a0,s1
    236a:	00003097          	auipc	ra,0x3
    236e:	2e4080e7          	jalr	740(ra) # 564e <open>
  if(fd != -1){
    2372:	57fd                	li	a5,-1
    2374:	08f51863          	bne	a0,a5,2404 <copyinstr3+0xf0>
  ret = link(b, b);
    2378:	85a6                	mv	a1,s1
    237a:	8526                	mv	a0,s1
    237c:	00003097          	auipc	ra,0x3
    2380:	2f2080e7          	jalr	754(ra) # 566e <link>
  if(ret != -1){
    2384:	57fd                	li	a5,-1
    2386:	08f51e63          	bne	a0,a5,2422 <copyinstr3+0x10e>
  char *args[] = { "xx", 0 };
    238a:	00005797          	auipc	a5,0x5
    238e:	40678793          	addi	a5,a5,1030 # 7790 <malloc+0x1d44>
    2392:	fcf43823          	sd	a5,-48(s0)
    2396:	fc043c23          	sd	zero,-40(s0)
  ret = exec(b, args);
    239a:	fd040593          	addi	a1,s0,-48
    239e:	8526                	mv	a0,s1
    23a0:	00003097          	auipc	ra,0x3
    23a4:	2a6080e7          	jalr	678(ra) # 5646 <exec>
  if(ret != -1){
    23a8:	57fd                	li	a5,-1
    23aa:	08f51c63          	bne	a0,a5,2442 <copyinstr3+0x12e>
}
    23ae:	70a2                	ld	ra,40(sp)
    23b0:	7402                	ld	s0,32(sp)
    23b2:	64e2                	ld	s1,24(sp)
    23b4:	6145                	addi	sp,sp,48
    23b6:	8082                	ret
    sbrk(PGSIZE - (top % PGSIZE));
    23b8:	0347d513          	srli	a0,a5,0x34
    23bc:	6785                	lui	a5,0x1
    23be:	40a7853b          	subw	a0,a5,a0
    23c2:	00003097          	auipc	ra,0x3
    23c6:	2d4080e7          	jalr	724(ra) # 5696 <sbrk>
    23ca:	b7bd                	j	2338 <copyinstr3+0x24>
    printf("oops\n");
    23cc:	00004517          	auipc	a0,0x4
    23d0:	75450513          	addi	a0,a0,1876 # 6b20 <malloc+0x10d4>
    23d4:	00003097          	auipc	ra,0x3
    23d8:	5ba080e7          	jalr	1466(ra) # 598e <printf>
    exit(1);
    23dc:	4505                	li	a0,1
    23de:	00003097          	auipc	ra,0x3
    23e2:	230080e7          	jalr	560(ra) # 560e <exit>
    printf("unlink(%s) returned %d, not -1\n", b, ret);
    23e6:	862a                	mv	a2,a0
    23e8:	85a6                	mv	a1,s1
    23ea:	00004517          	auipc	a0,0x4
    23ee:	1f650513          	addi	a0,a0,502 # 65e0 <malloc+0xb94>
    23f2:	00003097          	auipc	ra,0x3
    23f6:	59c080e7          	jalr	1436(ra) # 598e <printf>
    exit(1);
    23fa:	4505                	li	a0,1
    23fc:	00003097          	auipc	ra,0x3
    2400:	212080e7          	jalr	530(ra) # 560e <exit>
    printf("open(%s) returned %d, not -1\n", b, fd);
    2404:	862a                	mv	a2,a0
    2406:	85a6                	mv	a1,s1
    2408:	00004517          	auipc	a0,0x4
    240c:	1f850513          	addi	a0,a0,504 # 6600 <malloc+0xbb4>
    2410:	00003097          	auipc	ra,0x3
    2414:	57e080e7          	jalr	1406(ra) # 598e <printf>
    exit(1);
    2418:	4505                	li	a0,1
    241a:	00003097          	auipc	ra,0x3
    241e:	1f4080e7          	jalr	500(ra) # 560e <exit>
    printf("link(%s, %s) returned %d, not -1\n", b, b, ret);
    2422:	86aa                	mv	a3,a0
    2424:	8626                	mv	a2,s1
    2426:	85a6                	mv	a1,s1
    2428:	00004517          	auipc	a0,0x4
    242c:	1f850513          	addi	a0,a0,504 # 6620 <malloc+0xbd4>
    2430:	00003097          	auipc	ra,0x3
    2434:	55e080e7          	jalr	1374(ra) # 598e <printf>
    exit(1);
    2438:	4505                	li	a0,1
    243a:	00003097          	auipc	ra,0x3
    243e:	1d4080e7          	jalr	468(ra) # 560e <exit>
    printf("exec(%s) returned %d, not -1\n", b, fd);
    2442:	567d                	li	a2,-1
    2444:	85a6                	mv	a1,s1
    2446:	00004517          	auipc	a0,0x4
    244a:	20250513          	addi	a0,a0,514 # 6648 <malloc+0xbfc>
    244e:	00003097          	auipc	ra,0x3
    2452:	540080e7          	jalr	1344(ra) # 598e <printf>
    exit(1);
    2456:	4505                	li	a0,1
    2458:	00003097          	auipc	ra,0x3
    245c:	1b6080e7          	jalr	438(ra) # 560e <exit>

0000000000002460 <rwsbrk>:
{
    2460:	1101                	addi	sp,sp,-32
    2462:	ec06                	sd	ra,24(sp)
    2464:	e822                	sd	s0,16(sp)
    2466:	e426                	sd	s1,8(sp)
    2468:	e04a                	sd	s2,0(sp)
    246a:	1000                	addi	s0,sp,32
  uint64 a = (uint64) sbrk(8192);
    246c:	6509                	lui	a0,0x2
    246e:	00003097          	auipc	ra,0x3
    2472:	228080e7          	jalr	552(ra) # 5696 <sbrk>
  if(a == 0xffffffffffffffffLL) {
    2476:	57fd                	li	a5,-1
    2478:	06f50363          	beq	a0,a5,24de <rwsbrk+0x7e>
    247c:	84aa                	mv	s1,a0
  if ((uint64) sbrk(-8192) ==  0xffffffffffffffffLL) {
    247e:	7579                	lui	a0,0xffffe
    2480:	00003097          	auipc	ra,0x3
    2484:	216080e7          	jalr	534(ra) # 5696 <sbrk>
    2488:	57fd                	li	a5,-1
    248a:	06f50763          	beq	a0,a5,24f8 <rwsbrk+0x98>
  fd = open("rwsbrk", O_CREATE|O_WRONLY);
    248e:	20100593          	li	a1,513
    2492:	00003517          	auipc	a0,0x3
    2496:	71650513          	addi	a0,a0,1814 # 5ba8 <malloc+0x15c>
    249a:	00003097          	auipc	ra,0x3
    249e:	1b4080e7          	jalr	436(ra) # 564e <open>
    24a2:	892a                	mv	s2,a0
  if(fd < 0){
    24a4:	06054763          	bltz	a0,2512 <rwsbrk+0xb2>
  n = write(fd, (void*)(a+4096), 1024);
    24a8:	6505                	lui	a0,0x1
    24aa:	94aa                	add	s1,s1,a0
    24ac:	40000613          	li	a2,1024
    24b0:	85a6                	mv	a1,s1
    24b2:	854a                	mv	a0,s2
    24b4:	00003097          	auipc	ra,0x3
    24b8:	17a080e7          	jalr	378(ra) # 562e <write>
    24bc:	862a                	mv	a2,a0
  if(n >= 0){
    24be:	06054763          	bltz	a0,252c <rwsbrk+0xcc>
    printf("write(fd, %p, 1024) returned %d, not -1\n", a+4096, n);
    24c2:	85a6                	mv	a1,s1
    24c4:	00004517          	auipc	a0,0x4
    24c8:	6b450513          	addi	a0,a0,1716 # 6b78 <malloc+0x112c>
    24cc:	00003097          	auipc	ra,0x3
    24d0:	4c2080e7          	jalr	1218(ra) # 598e <printf>
    exit(1);
    24d4:	4505                	li	a0,1
    24d6:	00003097          	auipc	ra,0x3
    24da:	138080e7          	jalr	312(ra) # 560e <exit>
    printf("sbrk(rwsbrk) failed\n");
    24de:	00004517          	auipc	a0,0x4
    24e2:	64a50513          	addi	a0,a0,1610 # 6b28 <malloc+0x10dc>
    24e6:	00003097          	auipc	ra,0x3
    24ea:	4a8080e7          	jalr	1192(ra) # 598e <printf>
    exit(1);
    24ee:	4505                	li	a0,1
    24f0:	00003097          	auipc	ra,0x3
    24f4:	11e080e7          	jalr	286(ra) # 560e <exit>
    printf("sbrk(rwsbrk) shrink failed\n");
    24f8:	00004517          	auipc	a0,0x4
    24fc:	64850513          	addi	a0,a0,1608 # 6b40 <malloc+0x10f4>
    2500:	00003097          	auipc	ra,0x3
    2504:	48e080e7          	jalr	1166(ra) # 598e <printf>
    exit(1);
    2508:	4505                	li	a0,1
    250a:	00003097          	auipc	ra,0x3
    250e:	104080e7          	jalr	260(ra) # 560e <exit>
    printf("open(rwsbrk) failed\n");
    2512:	00004517          	auipc	a0,0x4
    2516:	64e50513          	addi	a0,a0,1614 # 6b60 <malloc+0x1114>
    251a:	00003097          	auipc	ra,0x3
    251e:	474080e7          	jalr	1140(ra) # 598e <printf>
    exit(1);
    2522:	4505                	li	a0,1
    2524:	00003097          	auipc	ra,0x3
    2528:	0ea080e7          	jalr	234(ra) # 560e <exit>
  close(fd);
    252c:	854a                	mv	a0,s2
    252e:	00003097          	auipc	ra,0x3
    2532:	108080e7          	jalr	264(ra) # 5636 <close>
  unlink("rwsbrk");
    2536:	00003517          	auipc	a0,0x3
    253a:	67250513          	addi	a0,a0,1650 # 5ba8 <malloc+0x15c>
    253e:	00003097          	auipc	ra,0x3
    2542:	120080e7          	jalr	288(ra) # 565e <unlink>
  fd = open("README", O_RDONLY);
    2546:	4581                	li	a1,0
    2548:	00004517          	auipc	a0,0x4
    254c:	ad850513          	addi	a0,a0,-1320 # 6020 <malloc+0x5d4>
    2550:	00003097          	auipc	ra,0x3
    2554:	0fe080e7          	jalr	254(ra) # 564e <open>
    2558:	892a                	mv	s2,a0
  if(fd < 0){
    255a:	02054963          	bltz	a0,258c <rwsbrk+0x12c>
  n = read(fd, (void*)(a+4096), 10);
    255e:	4629                	li	a2,10
    2560:	85a6                	mv	a1,s1
    2562:	00003097          	auipc	ra,0x3
    2566:	0c4080e7          	jalr	196(ra) # 5626 <read>
    256a:	862a                	mv	a2,a0
  if(n >= 0){
    256c:	02054d63          	bltz	a0,25a6 <rwsbrk+0x146>
    printf("read(fd, %p, 10) returned %d, not -1\n", a+4096, n);
    2570:	85a6                	mv	a1,s1
    2572:	00004517          	auipc	a0,0x4
    2576:	63650513          	addi	a0,a0,1590 # 6ba8 <malloc+0x115c>
    257a:	00003097          	auipc	ra,0x3
    257e:	414080e7          	jalr	1044(ra) # 598e <printf>
    exit(1);
    2582:	4505                	li	a0,1
    2584:	00003097          	auipc	ra,0x3
    2588:	08a080e7          	jalr	138(ra) # 560e <exit>
    printf("open(rwsbrk) failed\n");
    258c:	00004517          	auipc	a0,0x4
    2590:	5d450513          	addi	a0,a0,1492 # 6b60 <malloc+0x1114>
    2594:	00003097          	auipc	ra,0x3
    2598:	3fa080e7          	jalr	1018(ra) # 598e <printf>
    exit(1);
    259c:	4505                	li	a0,1
    259e:	00003097          	auipc	ra,0x3
    25a2:	070080e7          	jalr	112(ra) # 560e <exit>
  close(fd);
    25a6:	854a                	mv	a0,s2
    25a8:	00003097          	auipc	ra,0x3
    25ac:	08e080e7          	jalr	142(ra) # 5636 <close>
  exit(0);
    25b0:	4501                	li	a0,0
    25b2:	00003097          	auipc	ra,0x3
    25b6:	05c080e7          	jalr	92(ra) # 560e <exit>

00000000000025ba <sbrkbasic>:
{
    25ba:	7139                	addi	sp,sp,-64
    25bc:	fc06                	sd	ra,56(sp)
    25be:	f822                	sd	s0,48(sp)
    25c0:	f426                	sd	s1,40(sp)
    25c2:	f04a                	sd	s2,32(sp)
    25c4:	ec4e                	sd	s3,24(sp)
    25c6:	e852                	sd	s4,16(sp)
    25c8:	0080                	addi	s0,sp,64
    25ca:	8a2a                	mv	s4,a0
  pid = fork();
    25cc:	00003097          	auipc	ra,0x3
    25d0:	03a080e7          	jalr	58(ra) # 5606 <fork>
  if(pid < 0){
    25d4:	02054c63          	bltz	a0,260c <sbrkbasic+0x52>
  if(pid == 0){
    25d8:	ed21                	bnez	a0,2630 <sbrkbasic+0x76>
    a = sbrk(TOOMUCH);
    25da:	40000537          	lui	a0,0x40000
    25de:	00003097          	auipc	ra,0x3
    25e2:	0b8080e7          	jalr	184(ra) # 5696 <sbrk>
    if(a == (char*)0xffffffffffffffffL){
    25e6:	57fd                	li	a5,-1
    25e8:	02f50f63          	beq	a0,a5,2626 <sbrkbasic+0x6c>
    for(b = a; b < a+TOOMUCH; b += 4096){
    25ec:	400007b7          	lui	a5,0x40000
    25f0:	97aa                	add	a5,a5,a0
      *b = 99;
    25f2:	06300693          	li	a3,99
    for(b = a; b < a+TOOMUCH; b += 4096){
    25f6:	6705                	lui	a4,0x1
      *b = 99;
    25f8:	00d50023          	sb	a3,0(a0) # 40000000 <__BSS_END__+0x3fff1550>
    for(b = a; b < a+TOOMUCH; b += 4096){
    25fc:	953a                	add	a0,a0,a4
    25fe:	fef51de3          	bne	a0,a5,25f8 <sbrkbasic+0x3e>
    exit(1);
    2602:	4505                	li	a0,1
    2604:	00003097          	auipc	ra,0x3
    2608:	00a080e7          	jalr	10(ra) # 560e <exit>
    printf("fork failed in sbrkbasic\n");
    260c:	00004517          	auipc	a0,0x4
    2610:	5c450513          	addi	a0,a0,1476 # 6bd0 <malloc+0x1184>
    2614:	00003097          	auipc	ra,0x3
    2618:	37a080e7          	jalr	890(ra) # 598e <printf>
    exit(1);
    261c:	4505                	li	a0,1
    261e:	00003097          	auipc	ra,0x3
    2622:	ff0080e7          	jalr	-16(ra) # 560e <exit>
      exit(0);
    2626:	4501                	li	a0,0
    2628:	00003097          	auipc	ra,0x3
    262c:	fe6080e7          	jalr	-26(ra) # 560e <exit>
  wait(&xstatus);
    2630:	fcc40513          	addi	a0,s0,-52
    2634:	00003097          	auipc	ra,0x3
    2638:	fe2080e7          	jalr	-30(ra) # 5616 <wait>
  if(xstatus == 1){
    263c:	fcc42703          	lw	a4,-52(s0)
    2640:	4785                	li	a5,1
    2642:	00f70d63          	beq	a4,a5,265c <sbrkbasic+0xa2>
  a = sbrk(0);
    2646:	4501                	li	a0,0
    2648:	00003097          	auipc	ra,0x3
    264c:	04e080e7          	jalr	78(ra) # 5696 <sbrk>
    2650:	84aa                	mv	s1,a0
  for(i = 0; i < 5000; i++){
    2652:	4901                	li	s2,0
    2654:	6985                	lui	s3,0x1
    2656:	38898993          	addi	s3,s3,904 # 1388 <copyinstr2+0x1d4>
    265a:	a005                	j	267a <sbrkbasic+0xc0>
    printf("%s: too much memory allocated!\n", s);
    265c:	85d2                	mv	a1,s4
    265e:	00004517          	auipc	a0,0x4
    2662:	59250513          	addi	a0,a0,1426 # 6bf0 <malloc+0x11a4>
    2666:	00003097          	auipc	ra,0x3
    266a:	328080e7          	jalr	808(ra) # 598e <printf>
    exit(1);
    266e:	4505                	li	a0,1
    2670:	00003097          	auipc	ra,0x3
    2674:	f9e080e7          	jalr	-98(ra) # 560e <exit>
    a = b + 1;
    2678:	84be                	mv	s1,a5
    b = sbrk(1);
    267a:	4505                	li	a0,1
    267c:	00003097          	auipc	ra,0x3
    2680:	01a080e7          	jalr	26(ra) # 5696 <sbrk>
    if(b != a){
    2684:	04951c63          	bne	a0,s1,26dc <sbrkbasic+0x122>
    *b = 1;
    2688:	4785                	li	a5,1
    268a:	00f48023          	sb	a5,0(s1)
    a = b + 1;
    268e:	00148793          	addi	a5,s1,1
  for(i = 0; i < 5000; i++){
    2692:	2905                	addiw	s2,s2,1
    2694:	ff3912e3          	bne	s2,s3,2678 <sbrkbasic+0xbe>
  pid = fork();
    2698:	00003097          	auipc	ra,0x3
    269c:	f6e080e7          	jalr	-146(ra) # 5606 <fork>
    26a0:	892a                	mv	s2,a0
  if(pid < 0){
    26a2:	04054d63          	bltz	a0,26fc <sbrkbasic+0x142>
  c = sbrk(1);
    26a6:	4505                	li	a0,1
    26a8:	00003097          	auipc	ra,0x3
    26ac:	fee080e7          	jalr	-18(ra) # 5696 <sbrk>
  c = sbrk(1);
    26b0:	4505                	li	a0,1
    26b2:	00003097          	auipc	ra,0x3
    26b6:	fe4080e7          	jalr	-28(ra) # 5696 <sbrk>
  if(c != a + 1){
    26ba:	0489                	addi	s1,s1,2
    26bc:	04a48e63          	beq	s1,a0,2718 <sbrkbasic+0x15e>
    printf("%s: sbrk test failed post-fork\n", s);
    26c0:	85d2                	mv	a1,s4
    26c2:	00004517          	auipc	a0,0x4
    26c6:	58e50513          	addi	a0,a0,1422 # 6c50 <malloc+0x1204>
    26ca:	00003097          	auipc	ra,0x3
    26ce:	2c4080e7          	jalr	708(ra) # 598e <printf>
    exit(1);
    26d2:	4505                	li	a0,1
    26d4:	00003097          	auipc	ra,0x3
    26d8:	f3a080e7          	jalr	-198(ra) # 560e <exit>
      printf("%s: sbrk test failed %d %x %x\n", i, a, b);
    26dc:	86aa                	mv	a3,a0
    26de:	8626                	mv	a2,s1
    26e0:	85ca                	mv	a1,s2
    26e2:	00004517          	auipc	a0,0x4
    26e6:	52e50513          	addi	a0,a0,1326 # 6c10 <malloc+0x11c4>
    26ea:	00003097          	auipc	ra,0x3
    26ee:	2a4080e7          	jalr	676(ra) # 598e <printf>
      exit(1);
    26f2:	4505                	li	a0,1
    26f4:	00003097          	auipc	ra,0x3
    26f8:	f1a080e7          	jalr	-230(ra) # 560e <exit>
    printf("%s: sbrk test fork failed\n", s);
    26fc:	85d2                	mv	a1,s4
    26fe:	00004517          	auipc	a0,0x4
    2702:	53250513          	addi	a0,a0,1330 # 6c30 <malloc+0x11e4>
    2706:	00003097          	auipc	ra,0x3
    270a:	288080e7          	jalr	648(ra) # 598e <printf>
    exit(1);
    270e:	4505                	li	a0,1
    2710:	00003097          	auipc	ra,0x3
    2714:	efe080e7          	jalr	-258(ra) # 560e <exit>
  if(pid == 0)
    2718:	00091763          	bnez	s2,2726 <sbrkbasic+0x16c>
    exit(0);
    271c:	4501                	li	a0,0
    271e:	00003097          	auipc	ra,0x3
    2722:	ef0080e7          	jalr	-272(ra) # 560e <exit>
  wait(&xstatus);
    2726:	fcc40513          	addi	a0,s0,-52
    272a:	00003097          	auipc	ra,0x3
    272e:	eec080e7          	jalr	-276(ra) # 5616 <wait>
  exit(xstatus);
    2732:	fcc42503          	lw	a0,-52(s0)
    2736:	00003097          	auipc	ra,0x3
    273a:	ed8080e7          	jalr	-296(ra) # 560e <exit>

000000000000273e <sbrkmuch>:
{
    273e:	7179                	addi	sp,sp,-48
    2740:	f406                	sd	ra,40(sp)
    2742:	f022                	sd	s0,32(sp)
    2744:	ec26                	sd	s1,24(sp)
    2746:	e84a                	sd	s2,16(sp)
    2748:	e44e                	sd	s3,8(sp)
    274a:	e052                	sd	s4,0(sp)
    274c:	1800                	addi	s0,sp,48
    274e:	89aa                	mv	s3,a0
  oldbrk = sbrk(0);
    2750:	4501                	li	a0,0
    2752:	00003097          	auipc	ra,0x3
    2756:	f44080e7          	jalr	-188(ra) # 5696 <sbrk>
    275a:	892a                	mv	s2,a0
  a = sbrk(0);
    275c:	4501                	li	a0,0
    275e:	00003097          	auipc	ra,0x3
    2762:	f38080e7          	jalr	-200(ra) # 5696 <sbrk>
    2766:	84aa                	mv	s1,a0
  p = sbrk(amt);
    2768:	06400537          	lui	a0,0x6400
    276c:	9d05                	subw	a0,a0,s1
    276e:	00003097          	auipc	ra,0x3
    2772:	f28080e7          	jalr	-216(ra) # 5696 <sbrk>
  if (p != a) {
    2776:	0ca49863          	bne	s1,a0,2846 <sbrkmuch+0x108>
  char *eee = sbrk(0);
    277a:	4501                	li	a0,0
    277c:	00003097          	auipc	ra,0x3
    2780:	f1a080e7          	jalr	-230(ra) # 5696 <sbrk>
    2784:	87aa                	mv	a5,a0
  for(char *pp = a; pp < eee; pp += 4096)
    2786:	00a4f963          	bgeu	s1,a0,2798 <sbrkmuch+0x5a>
    *pp = 1;
    278a:	4685                	li	a3,1
  for(char *pp = a; pp < eee; pp += 4096)
    278c:	6705                	lui	a4,0x1
    *pp = 1;
    278e:	00d48023          	sb	a3,0(s1)
  for(char *pp = a; pp < eee; pp += 4096)
    2792:	94ba                	add	s1,s1,a4
    2794:	fef4ede3          	bltu	s1,a5,278e <sbrkmuch+0x50>
  *lastaddr = 99;
    2798:	064007b7          	lui	a5,0x6400
    279c:	06300713          	li	a4,99
    27a0:	fee78fa3          	sb	a4,-1(a5) # 63fffff <__BSS_END__+0x63f154f>
  a = sbrk(0);
    27a4:	4501                	li	a0,0
    27a6:	00003097          	auipc	ra,0x3
    27aa:	ef0080e7          	jalr	-272(ra) # 5696 <sbrk>
    27ae:	84aa                	mv	s1,a0
  c = sbrk(-PGSIZE);
    27b0:	757d                	lui	a0,0xfffff
    27b2:	00003097          	auipc	ra,0x3
    27b6:	ee4080e7          	jalr	-284(ra) # 5696 <sbrk>
  if(c == (char*)0xffffffffffffffffL){
    27ba:	57fd                	li	a5,-1
    27bc:	0af50363          	beq	a0,a5,2862 <sbrkmuch+0x124>
  c = sbrk(0);
    27c0:	4501                	li	a0,0
    27c2:	00003097          	auipc	ra,0x3
    27c6:	ed4080e7          	jalr	-300(ra) # 5696 <sbrk>
  if(c != a - PGSIZE){
    27ca:	77fd                	lui	a5,0xfffff
    27cc:	97a6                	add	a5,a5,s1
    27ce:	0af51863          	bne	a0,a5,287e <sbrkmuch+0x140>
  a = sbrk(0);
    27d2:	4501                	li	a0,0
    27d4:	00003097          	auipc	ra,0x3
    27d8:	ec2080e7          	jalr	-318(ra) # 5696 <sbrk>
    27dc:	84aa                	mv	s1,a0
  c = sbrk(PGSIZE);
    27de:	6505                	lui	a0,0x1
    27e0:	00003097          	auipc	ra,0x3
    27e4:	eb6080e7          	jalr	-330(ra) # 5696 <sbrk>
    27e8:	8a2a                	mv	s4,a0
  if(c != a || sbrk(0) != a + PGSIZE){
    27ea:	0aa49a63          	bne	s1,a0,289e <sbrkmuch+0x160>
    27ee:	4501                	li	a0,0
    27f0:	00003097          	auipc	ra,0x3
    27f4:	ea6080e7          	jalr	-346(ra) # 5696 <sbrk>
    27f8:	6785                	lui	a5,0x1
    27fa:	97a6                	add	a5,a5,s1
    27fc:	0af51163          	bne	a0,a5,289e <sbrkmuch+0x160>
  if(*lastaddr == 99){
    2800:	064007b7          	lui	a5,0x6400
    2804:	fff7c703          	lbu	a4,-1(a5) # 63fffff <__BSS_END__+0x63f154f>
    2808:	06300793          	li	a5,99
    280c:	0af70963          	beq	a4,a5,28be <sbrkmuch+0x180>
  a = sbrk(0);
    2810:	4501                	li	a0,0
    2812:	00003097          	auipc	ra,0x3
    2816:	e84080e7          	jalr	-380(ra) # 5696 <sbrk>
    281a:	84aa                	mv	s1,a0
  c = sbrk(-(sbrk(0) - oldbrk));
    281c:	4501                	li	a0,0
    281e:	00003097          	auipc	ra,0x3
    2822:	e78080e7          	jalr	-392(ra) # 5696 <sbrk>
    2826:	40a9053b          	subw	a0,s2,a0
    282a:	00003097          	auipc	ra,0x3
    282e:	e6c080e7          	jalr	-404(ra) # 5696 <sbrk>
  if(c != a){
    2832:	0aa49463          	bne	s1,a0,28da <sbrkmuch+0x19c>
}
    2836:	70a2                	ld	ra,40(sp)
    2838:	7402                	ld	s0,32(sp)
    283a:	64e2                	ld	s1,24(sp)
    283c:	6942                	ld	s2,16(sp)
    283e:	69a2                	ld	s3,8(sp)
    2840:	6a02                	ld	s4,0(sp)
    2842:	6145                	addi	sp,sp,48
    2844:	8082                	ret
    printf("%s: sbrk test failed to grow big address space; enough phys mem?\n", s);
    2846:	85ce                	mv	a1,s3
    2848:	00004517          	auipc	a0,0x4
    284c:	42850513          	addi	a0,a0,1064 # 6c70 <malloc+0x1224>
    2850:	00003097          	auipc	ra,0x3
    2854:	13e080e7          	jalr	318(ra) # 598e <printf>
    exit(1);
    2858:	4505                	li	a0,1
    285a:	00003097          	auipc	ra,0x3
    285e:	db4080e7          	jalr	-588(ra) # 560e <exit>
    printf("%s: sbrk could not deallocate\n", s);
    2862:	85ce                	mv	a1,s3
    2864:	00004517          	auipc	a0,0x4
    2868:	45450513          	addi	a0,a0,1108 # 6cb8 <malloc+0x126c>
    286c:	00003097          	auipc	ra,0x3
    2870:	122080e7          	jalr	290(ra) # 598e <printf>
    exit(1);
    2874:	4505                	li	a0,1
    2876:	00003097          	auipc	ra,0x3
    287a:	d98080e7          	jalr	-616(ra) # 560e <exit>
    printf("%s: sbrk deallocation produced wrong address, a %x c %x\n", s, a, c);
    287e:	86aa                	mv	a3,a0
    2880:	8626                	mv	a2,s1
    2882:	85ce                	mv	a1,s3
    2884:	00004517          	auipc	a0,0x4
    2888:	45450513          	addi	a0,a0,1108 # 6cd8 <malloc+0x128c>
    288c:	00003097          	auipc	ra,0x3
    2890:	102080e7          	jalr	258(ra) # 598e <printf>
    exit(1);
    2894:	4505                	li	a0,1
    2896:	00003097          	auipc	ra,0x3
    289a:	d78080e7          	jalr	-648(ra) # 560e <exit>
    printf("%s: sbrk re-allocation failed, a %x c %x\n", s, a, c);
    289e:	86d2                	mv	a3,s4
    28a0:	8626                	mv	a2,s1
    28a2:	85ce                	mv	a1,s3
    28a4:	00004517          	auipc	a0,0x4
    28a8:	47450513          	addi	a0,a0,1140 # 6d18 <malloc+0x12cc>
    28ac:	00003097          	auipc	ra,0x3
    28b0:	0e2080e7          	jalr	226(ra) # 598e <printf>
    exit(1);
    28b4:	4505                	li	a0,1
    28b6:	00003097          	auipc	ra,0x3
    28ba:	d58080e7          	jalr	-680(ra) # 560e <exit>
    printf("%s: sbrk de-allocation didn't really deallocate\n", s);
    28be:	85ce                	mv	a1,s3
    28c0:	00004517          	auipc	a0,0x4
    28c4:	48850513          	addi	a0,a0,1160 # 6d48 <malloc+0x12fc>
    28c8:	00003097          	auipc	ra,0x3
    28cc:	0c6080e7          	jalr	198(ra) # 598e <printf>
    exit(1);
    28d0:	4505                	li	a0,1
    28d2:	00003097          	auipc	ra,0x3
    28d6:	d3c080e7          	jalr	-708(ra) # 560e <exit>
    printf("%s: sbrk downsize failed, a %x c %x\n", s, a, c);
    28da:	86aa                	mv	a3,a0
    28dc:	8626                	mv	a2,s1
    28de:	85ce                	mv	a1,s3
    28e0:	00004517          	auipc	a0,0x4
    28e4:	4a050513          	addi	a0,a0,1184 # 6d80 <malloc+0x1334>
    28e8:	00003097          	auipc	ra,0x3
    28ec:	0a6080e7          	jalr	166(ra) # 598e <printf>
    exit(1);
    28f0:	4505                	li	a0,1
    28f2:	00003097          	auipc	ra,0x3
    28f6:	d1c080e7          	jalr	-740(ra) # 560e <exit>

00000000000028fa <sbrkarg>:
{
    28fa:	7179                	addi	sp,sp,-48
    28fc:	f406                	sd	ra,40(sp)
    28fe:	f022                	sd	s0,32(sp)
    2900:	ec26                	sd	s1,24(sp)
    2902:	e84a                	sd	s2,16(sp)
    2904:	e44e                	sd	s3,8(sp)
    2906:	1800                	addi	s0,sp,48
    2908:	89aa                	mv	s3,a0
  a = sbrk(PGSIZE);
    290a:	6505                	lui	a0,0x1
    290c:	00003097          	auipc	ra,0x3
    2910:	d8a080e7          	jalr	-630(ra) # 5696 <sbrk>
    2914:	892a                	mv	s2,a0
  fd = open("sbrk", O_CREATE|O_WRONLY);
    2916:	20100593          	li	a1,513
    291a:	00004517          	auipc	a0,0x4
    291e:	48e50513          	addi	a0,a0,1166 # 6da8 <malloc+0x135c>
    2922:	00003097          	auipc	ra,0x3
    2926:	d2c080e7          	jalr	-724(ra) # 564e <open>
    292a:	84aa                	mv	s1,a0
  unlink("sbrk");
    292c:	00004517          	auipc	a0,0x4
    2930:	47c50513          	addi	a0,a0,1148 # 6da8 <malloc+0x135c>
    2934:	00003097          	auipc	ra,0x3
    2938:	d2a080e7          	jalr	-726(ra) # 565e <unlink>
  if(fd < 0)  {
    293c:	0404c163          	bltz	s1,297e <sbrkarg+0x84>
  if ((n = write(fd, a, PGSIZE)) < 0) {
    2940:	6605                	lui	a2,0x1
    2942:	85ca                	mv	a1,s2
    2944:	8526                	mv	a0,s1
    2946:	00003097          	auipc	ra,0x3
    294a:	ce8080e7          	jalr	-792(ra) # 562e <write>
    294e:	04054663          	bltz	a0,299a <sbrkarg+0xa0>
  close(fd);
    2952:	8526                	mv	a0,s1
    2954:	00003097          	auipc	ra,0x3
    2958:	ce2080e7          	jalr	-798(ra) # 5636 <close>
  a = sbrk(PGSIZE);
    295c:	6505                	lui	a0,0x1
    295e:	00003097          	auipc	ra,0x3
    2962:	d38080e7          	jalr	-712(ra) # 5696 <sbrk>
  if(pipe((int *) a) != 0){
    2966:	00003097          	auipc	ra,0x3
    296a:	cb8080e7          	jalr	-840(ra) # 561e <pipe>
    296e:	e521                	bnez	a0,29b6 <sbrkarg+0xbc>
}
    2970:	70a2                	ld	ra,40(sp)
    2972:	7402                	ld	s0,32(sp)
    2974:	64e2                	ld	s1,24(sp)
    2976:	6942                	ld	s2,16(sp)
    2978:	69a2                	ld	s3,8(sp)
    297a:	6145                	addi	sp,sp,48
    297c:	8082                	ret
    printf("%s: open sbrk failed\n", s);
    297e:	85ce                	mv	a1,s3
    2980:	00004517          	auipc	a0,0x4
    2984:	43050513          	addi	a0,a0,1072 # 6db0 <malloc+0x1364>
    2988:	00003097          	auipc	ra,0x3
    298c:	006080e7          	jalr	6(ra) # 598e <printf>
    exit(1);
    2990:	4505                	li	a0,1
    2992:	00003097          	auipc	ra,0x3
    2996:	c7c080e7          	jalr	-900(ra) # 560e <exit>
    printf("%s: write sbrk failed\n", s);
    299a:	85ce                	mv	a1,s3
    299c:	00004517          	auipc	a0,0x4
    29a0:	42c50513          	addi	a0,a0,1068 # 6dc8 <malloc+0x137c>
    29a4:	00003097          	auipc	ra,0x3
    29a8:	fea080e7          	jalr	-22(ra) # 598e <printf>
    exit(1);
    29ac:	4505                	li	a0,1
    29ae:	00003097          	auipc	ra,0x3
    29b2:	c60080e7          	jalr	-928(ra) # 560e <exit>
    printf("%s: pipe() failed\n", s);
    29b6:	85ce                	mv	a1,s3
    29b8:	00004517          	auipc	a0,0x4
    29bc:	e1050513          	addi	a0,a0,-496 # 67c8 <malloc+0xd7c>
    29c0:	00003097          	auipc	ra,0x3
    29c4:	fce080e7          	jalr	-50(ra) # 598e <printf>
    exit(1);
    29c8:	4505                	li	a0,1
    29ca:	00003097          	auipc	ra,0x3
    29ce:	c44080e7          	jalr	-956(ra) # 560e <exit>

00000000000029d2 <argptest>:
{
    29d2:	1101                	addi	sp,sp,-32
    29d4:	ec06                	sd	ra,24(sp)
    29d6:	e822                	sd	s0,16(sp)
    29d8:	e426                	sd	s1,8(sp)
    29da:	e04a                	sd	s2,0(sp)
    29dc:	1000                	addi	s0,sp,32
    29de:	892a                	mv	s2,a0
  fd = open("init", O_RDONLY);
    29e0:	4581                	li	a1,0
    29e2:	00004517          	auipc	a0,0x4
    29e6:	3fe50513          	addi	a0,a0,1022 # 6de0 <malloc+0x1394>
    29ea:	00003097          	auipc	ra,0x3
    29ee:	c64080e7          	jalr	-924(ra) # 564e <open>
  if (fd < 0) {
    29f2:	02054b63          	bltz	a0,2a28 <argptest+0x56>
    29f6:	84aa                	mv	s1,a0
  read(fd, sbrk(0) - 1, -1);
    29f8:	4501                	li	a0,0
    29fa:	00003097          	auipc	ra,0x3
    29fe:	c9c080e7          	jalr	-868(ra) # 5696 <sbrk>
    2a02:	567d                	li	a2,-1
    2a04:	fff50593          	addi	a1,a0,-1
    2a08:	8526                	mv	a0,s1
    2a0a:	00003097          	auipc	ra,0x3
    2a0e:	c1c080e7          	jalr	-996(ra) # 5626 <read>
  close(fd);
    2a12:	8526                	mv	a0,s1
    2a14:	00003097          	auipc	ra,0x3
    2a18:	c22080e7          	jalr	-990(ra) # 5636 <close>
}
    2a1c:	60e2                	ld	ra,24(sp)
    2a1e:	6442                	ld	s0,16(sp)
    2a20:	64a2                	ld	s1,8(sp)
    2a22:	6902                	ld	s2,0(sp)
    2a24:	6105                	addi	sp,sp,32
    2a26:	8082                	ret
    printf("%s: open failed\n", s);
    2a28:	85ca                	mv	a1,s2
    2a2a:	00004517          	auipc	a0,0x4
    2a2e:	cae50513          	addi	a0,a0,-850 # 66d8 <malloc+0xc8c>
    2a32:	00003097          	auipc	ra,0x3
    2a36:	f5c080e7          	jalr	-164(ra) # 598e <printf>
    exit(1);
    2a3a:	4505                	li	a0,1
    2a3c:	00003097          	auipc	ra,0x3
    2a40:	bd2080e7          	jalr	-1070(ra) # 560e <exit>

0000000000002a44 <sbrkbugs>:
{
    2a44:	1141                	addi	sp,sp,-16
    2a46:	e406                	sd	ra,8(sp)
    2a48:	e022                	sd	s0,0(sp)
    2a4a:	0800                	addi	s0,sp,16
  int pid = fork();
    2a4c:	00003097          	auipc	ra,0x3
    2a50:	bba080e7          	jalr	-1094(ra) # 5606 <fork>
  if(pid < 0){
    2a54:	02054263          	bltz	a0,2a78 <sbrkbugs+0x34>
  if(pid == 0){
    2a58:	ed0d                	bnez	a0,2a92 <sbrkbugs+0x4e>
    int sz = (uint64) sbrk(0);
    2a5a:	00003097          	auipc	ra,0x3
    2a5e:	c3c080e7          	jalr	-964(ra) # 5696 <sbrk>
    sbrk(-sz);
    2a62:	40a0053b          	negw	a0,a0
    2a66:	00003097          	auipc	ra,0x3
    2a6a:	c30080e7          	jalr	-976(ra) # 5696 <sbrk>
    exit(0);
    2a6e:	4501                	li	a0,0
    2a70:	00003097          	auipc	ra,0x3
    2a74:	b9e080e7          	jalr	-1122(ra) # 560e <exit>
    printf("fork failed\n");
    2a78:	00004517          	auipc	a0,0x4
    2a7c:	05050513          	addi	a0,a0,80 # 6ac8 <malloc+0x107c>
    2a80:	00003097          	auipc	ra,0x3
    2a84:	f0e080e7          	jalr	-242(ra) # 598e <printf>
    exit(1);
    2a88:	4505                	li	a0,1
    2a8a:	00003097          	auipc	ra,0x3
    2a8e:	b84080e7          	jalr	-1148(ra) # 560e <exit>
  wait(0);
    2a92:	4501                	li	a0,0
    2a94:	00003097          	auipc	ra,0x3
    2a98:	b82080e7          	jalr	-1150(ra) # 5616 <wait>
  pid = fork();
    2a9c:	00003097          	auipc	ra,0x3
    2aa0:	b6a080e7          	jalr	-1174(ra) # 5606 <fork>
  if(pid < 0){
    2aa4:	02054563          	bltz	a0,2ace <sbrkbugs+0x8a>
  if(pid == 0){
    2aa8:	e121                	bnez	a0,2ae8 <sbrkbugs+0xa4>
    int sz = (uint64) sbrk(0);
    2aaa:	00003097          	auipc	ra,0x3
    2aae:	bec080e7          	jalr	-1044(ra) # 5696 <sbrk>
    sbrk(-(sz - 3500));
    2ab2:	6785                	lui	a5,0x1
    2ab4:	dac7879b          	addiw	a5,a5,-596
    2ab8:	40a7853b          	subw	a0,a5,a0
    2abc:	00003097          	auipc	ra,0x3
    2ac0:	bda080e7          	jalr	-1062(ra) # 5696 <sbrk>
    exit(0);
    2ac4:	4501                	li	a0,0
    2ac6:	00003097          	auipc	ra,0x3
    2aca:	b48080e7          	jalr	-1208(ra) # 560e <exit>
    printf("fork failed\n");
    2ace:	00004517          	auipc	a0,0x4
    2ad2:	ffa50513          	addi	a0,a0,-6 # 6ac8 <malloc+0x107c>
    2ad6:	00003097          	auipc	ra,0x3
    2ada:	eb8080e7          	jalr	-328(ra) # 598e <printf>
    exit(1);
    2ade:	4505                	li	a0,1
    2ae0:	00003097          	auipc	ra,0x3
    2ae4:	b2e080e7          	jalr	-1234(ra) # 560e <exit>
  wait(0);
    2ae8:	4501                	li	a0,0
    2aea:	00003097          	auipc	ra,0x3
    2aee:	b2c080e7          	jalr	-1236(ra) # 5616 <wait>
  pid = fork();
    2af2:	00003097          	auipc	ra,0x3
    2af6:	b14080e7          	jalr	-1260(ra) # 5606 <fork>
  if(pid < 0){
    2afa:	02054a63          	bltz	a0,2b2e <sbrkbugs+0xea>
  if(pid == 0){
    2afe:	e529                	bnez	a0,2b48 <sbrkbugs+0x104>
    sbrk((10*4096 + 2048) - (uint64)sbrk(0));
    2b00:	00003097          	auipc	ra,0x3
    2b04:	b96080e7          	jalr	-1130(ra) # 5696 <sbrk>
    2b08:	67ad                	lui	a5,0xb
    2b0a:	8007879b          	addiw	a5,a5,-2048
    2b0e:	40a7853b          	subw	a0,a5,a0
    2b12:	00003097          	auipc	ra,0x3
    2b16:	b84080e7          	jalr	-1148(ra) # 5696 <sbrk>
    sbrk(-10);
    2b1a:	5559                	li	a0,-10
    2b1c:	00003097          	auipc	ra,0x3
    2b20:	b7a080e7          	jalr	-1158(ra) # 5696 <sbrk>
    exit(0);
    2b24:	4501                	li	a0,0
    2b26:	00003097          	auipc	ra,0x3
    2b2a:	ae8080e7          	jalr	-1304(ra) # 560e <exit>
    printf("fork failed\n");
    2b2e:	00004517          	auipc	a0,0x4
    2b32:	f9a50513          	addi	a0,a0,-102 # 6ac8 <malloc+0x107c>
    2b36:	00003097          	auipc	ra,0x3
    2b3a:	e58080e7          	jalr	-424(ra) # 598e <printf>
    exit(1);
    2b3e:	4505                	li	a0,1
    2b40:	00003097          	auipc	ra,0x3
    2b44:	ace080e7          	jalr	-1330(ra) # 560e <exit>
  wait(0);
    2b48:	4501                	li	a0,0
    2b4a:	00003097          	auipc	ra,0x3
    2b4e:	acc080e7          	jalr	-1332(ra) # 5616 <wait>
  exit(0);
    2b52:	4501                	li	a0,0
    2b54:	00003097          	auipc	ra,0x3
    2b58:	aba080e7          	jalr	-1350(ra) # 560e <exit>

0000000000002b5c <execout>:
// test the exec() code that cleans up if it runs out
// of memory. it's really a test that such a condition
// doesn't cause a panic.
void
execout(char *s)
{
    2b5c:	715d                	addi	sp,sp,-80
    2b5e:	e486                	sd	ra,72(sp)
    2b60:	e0a2                	sd	s0,64(sp)
    2b62:	fc26                	sd	s1,56(sp)
    2b64:	f84a                	sd	s2,48(sp)
    2b66:	f44e                	sd	s3,40(sp)
    2b68:	f052                	sd	s4,32(sp)
    2b6a:	0880                	addi	s0,sp,80
  for(int avail = 0; avail < 15; avail++){
    2b6c:	4901                	li	s2,0
    2b6e:	49bd                	li	s3,15
    int pid = fork();
    2b70:	00003097          	auipc	ra,0x3
    2b74:	a96080e7          	jalr	-1386(ra) # 5606 <fork>
    2b78:	84aa                	mv	s1,a0
    if(pid < 0){
    2b7a:	02054063          	bltz	a0,2b9a <execout+0x3e>
      printf("fork failed\n");
      exit(1);
    } else if(pid == 0){
    2b7e:	c91d                	beqz	a0,2bb4 <execout+0x58>
      close(1);
      char *args[] = { "echo", "x", 0 };
      exec("echo", args);
      exit(0);
    } else {
      wait((int*)0);
    2b80:	4501                	li	a0,0
    2b82:	00003097          	auipc	ra,0x3
    2b86:	a94080e7          	jalr	-1388(ra) # 5616 <wait>
  for(int avail = 0; avail < 15; avail++){
    2b8a:	2905                	addiw	s2,s2,1
    2b8c:	ff3912e3          	bne	s2,s3,2b70 <execout+0x14>
    }
  }

  exit(0);
    2b90:	4501                	li	a0,0
    2b92:	00003097          	auipc	ra,0x3
    2b96:	a7c080e7          	jalr	-1412(ra) # 560e <exit>
      printf("fork failed\n");
    2b9a:	00004517          	auipc	a0,0x4
    2b9e:	f2e50513          	addi	a0,a0,-210 # 6ac8 <malloc+0x107c>
    2ba2:	00003097          	auipc	ra,0x3
    2ba6:	dec080e7          	jalr	-532(ra) # 598e <printf>
      exit(1);
    2baa:	4505                	li	a0,1
    2bac:	00003097          	auipc	ra,0x3
    2bb0:	a62080e7          	jalr	-1438(ra) # 560e <exit>
        if(a == 0xffffffffffffffffLL)
    2bb4:	59fd                	li	s3,-1
        *(char*)(a + 4096 - 1) = 1;
    2bb6:	4a05                	li	s4,1
        uint64 a = (uint64) sbrk(4096);
    2bb8:	6505                	lui	a0,0x1
    2bba:	00003097          	auipc	ra,0x3
    2bbe:	adc080e7          	jalr	-1316(ra) # 5696 <sbrk>
        if(a == 0xffffffffffffffffLL)
    2bc2:	01350763          	beq	a0,s3,2bd0 <execout+0x74>
        *(char*)(a + 4096 - 1) = 1;
    2bc6:	6785                	lui	a5,0x1
    2bc8:	953e                	add	a0,a0,a5
    2bca:	ff450fa3          	sb	s4,-1(a0) # fff <bigdir+0x9b>
      while(1){
    2bce:	b7ed                	j	2bb8 <execout+0x5c>
      for(int i = 0; i < avail; i++)
    2bd0:	01205a63          	blez	s2,2be4 <execout+0x88>
        sbrk(-4096);
    2bd4:	757d                	lui	a0,0xfffff
    2bd6:	00003097          	auipc	ra,0x3
    2bda:	ac0080e7          	jalr	-1344(ra) # 5696 <sbrk>
      for(int i = 0; i < avail; i++)
    2bde:	2485                	addiw	s1,s1,1
    2be0:	ff249ae3          	bne	s1,s2,2bd4 <execout+0x78>
      close(1);
    2be4:	4505                	li	a0,1
    2be6:	00003097          	auipc	ra,0x3
    2bea:	a50080e7          	jalr	-1456(ra) # 5636 <close>
      char *args[] = { "echo", "x", 0 };
    2bee:	00003517          	auipc	a0,0x3
    2bf2:	29a50513          	addi	a0,a0,666 # 5e88 <malloc+0x43c>
    2bf6:	faa43c23          	sd	a0,-72(s0)
    2bfa:	00003797          	auipc	a5,0x3
    2bfe:	2fe78793          	addi	a5,a5,766 # 5ef8 <malloc+0x4ac>
    2c02:	fcf43023          	sd	a5,-64(s0)
    2c06:	fc043423          	sd	zero,-56(s0)
      exec("echo", args);
    2c0a:	fb840593          	addi	a1,s0,-72
    2c0e:	00003097          	auipc	ra,0x3
    2c12:	a38080e7          	jalr	-1480(ra) # 5646 <exec>
      exit(0);
    2c16:	4501                	li	a0,0
    2c18:	00003097          	auipc	ra,0x3
    2c1c:	9f6080e7          	jalr	-1546(ra) # 560e <exit>

0000000000002c20 <fourteen>:
{
    2c20:	1101                	addi	sp,sp,-32
    2c22:	ec06                	sd	ra,24(sp)
    2c24:	e822                	sd	s0,16(sp)
    2c26:	e426                	sd	s1,8(sp)
    2c28:	1000                	addi	s0,sp,32
    2c2a:	84aa                	mv	s1,a0
  if(mkdir("12345678901234") != 0){
    2c2c:	00004517          	auipc	a0,0x4
    2c30:	38c50513          	addi	a0,a0,908 # 6fb8 <malloc+0x156c>
    2c34:	00003097          	auipc	ra,0x3
    2c38:	a42080e7          	jalr	-1470(ra) # 5676 <mkdir>
    2c3c:	e165                	bnez	a0,2d1c <fourteen+0xfc>
  if(mkdir("12345678901234/123456789012345") != 0){
    2c3e:	00004517          	auipc	a0,0x4
    2c42:	1d250513          	addi	a0,a0,466 # 6e10 <malloc+0x13c4>
    2c46:	00003097          	auipc	ra,0x3
    2c4a:	a30080e7          	jalr	-1488(ra) # 5676 <mkdir>
    2c4e:	e56d                	bnez	a0,2d38 <fourteen+0x118>
  fd = open("123456789012345/123456789012345/123456789012345", O_CREATE);
    2c50:	20000593          	li	a1,512
    2c54:	00004517          	auipc	a0,0x4
    2c58:	21450513          	addi	a0,a0,532 # 6e68 <malloc+0x141c>
    2c5c:	00003097          	auipc	ra,0x3
    2c60:	9f2080e7          	jalr	-1550(ra) # 564e <open>
  if(fd < 0){
    2c64:	0e054863          	bltz	a0,2d54 <fourteen+0x134>
  close(fd);
    2c68:	00003097          	auipc	ra,0x3
    2c6c:	9ce080e7          	jalr	-1586(ra) # 5636 <close>
  fd = open("12345678901234/12345678901234/12345678901234", 0);
    2c70:	4581                	li	a1,0
    2c72:	00004517          	auipc	a0,0x4
    2c76:	26e50513          	addi	a0,a0,622 # 6ee0 <malloc+0x1494>
    2c7a:	00003097          	auipc	ra,0x3
    2c7e:	9d4080e7          	jalr	-1580(ra) # 564e <open>
  if(fd < 0){
    2c82:	0e054763          	bltz	a0,2d70 <fourteen+0x150>
  close(fd);
    2c86:	00003097          	auipc	ra,0x3
    2c8a:	9b0080e7          	jalr	-1616(ra) # 5636 <close>
  if(mkdir("12345678901234/12345678901234") == 0){
    2c8e:	00004517          	auipc	a0,0x4
    2c92:	2c250513          	addi	a0,a0,706 # 6f50 <malloc+0x1504>
    2c96:	00003097          	auipc	ra,0x3
    2c9a:	9e0080e7          	jalr	-1568(ra) # 5676 <mkdir>
    2c9e:	c57d                	beqz	a0,2d8c <fourteen+0x16c>
  if(mkdir("123456789012345/12345678901234") == 0){
    2ca0:	00004517          	auipc	a0,0x4
    2ca4:	30850513          	addi	a0,a0,776 # 6fa8 <malloc+0x155c>
    2ca8:	00003097          	auipc	ra,0x3
    2cac:	9ce080e7          	jalr	-1586(ra) # 5676 <mkdir>
    2cb0:	cd65                	beqz	a0,2da8 <fourteen+0x188>
  unlink("123456789012345/12345678901234");
    2cb2:	00004517          	auipc	a0,0x4
    2cb6:	2f650513          	addi	a0,a0,758 # 6fa8 <malloc+0x155c>
    2cba:	00003097          	auipc	ra,0x3
    2cbe:	9a4080e7          	jalr	-1628(ra) # 565e <unlink>
  unlink("12345678901234/12345678901234");
    2cc2:	00004517          	auipc	a0,0x4
    2cc6:	28e50513          	addi	a0,a0,654 # 6f50 <malloc+0x1504>
    2cca:	00003097          	auipc	ra,0x3
    2cce:	994080e7          	jalr	-1644(ra) # 565e <unlink>
  unlink("12345678901234/12345678901234/12345678901234");
    2cd2:	00004517          	auipc	a0,0x4
    2cd6:	20e50513          	addi	a0,a0,526 # 6ee0 <malloc+0x1494>
    2cda:	00003097          	auipc	ra,0x3
    2cde:	984080e7          	jalr	-1660(ra) # 565e <unlink>
  unlink("123456789012345/123456789012345/123456789012345");
    2ce2:	00004517          	auipc	a0,0x4
    2ce6:	18650513          	addi	a0,a0,390 # 6e68 <malloc+0x141c>
    2cea:	00003097          	auipc	ra,0x3
    2cee:	974080e7          	jalr	-1676(ra) # 565e <unlink>
  unlink("12345678901234/123456789012345");
    2cf2:	00004517          	auipc	a0,0x4
    2cf6:	11e50513          	addi	a0,a0,286 # 6e10 <malloc+0x13c4>
    2cfa:	00003097          	auipc	ra,0x3
    2cfe:	964080e7          	jalr	-1692(ra) # 565e <unlink>
  unlink("12345678901234");
    2d02:	00004517          	auipc	a0,0x4
    2d06:	2b650513          	addi	a0,a0,694 # 6fb8 <malloc+0x156c>
    2d0a:	00003097          	auipc	ra,0x3
    2d0e:	954080e7          	jalr	-1708(ra) # 565e <unlink>
}
    2d12:	60e2                	ld	ra,24(sp)
    2d14:	6442                	ld	s0,16(sp)
    2d16:	64a2                	ld	s1,8(sp)
    2d18:	6105                	addi	sp,sp,32
    2d1a:	8082                	ret
    printf("%s: mkdir 12345678901234 failed\n", s);
    2d1c:	85a6                	mv	a1,s1
    2d1e:	00004517          	auipc	a0,0x4
    2d22:	0ca50513          	addi	a0,a0,202 # 6de8 <malloc+0x139c>
    2d26:	00003097          	auipc	ra,0x3
    2d2a:	c68080e7          	jalr	-920(ra) # 598e <printf>
    exit(1);
    2d2e:	4505                	li	a0,1
    2d30:	00003097          	auipc	ra,0x3
    2d34:	8de080e7          	jalr	-1826(ra) # 560e <exit>
    printf("%s: mkdir 12345678901234/123456789012345 failed\n", s);
    2d38:	85a6                	mv	a1,s1
    2d3a:	00004517          	auipc	a0,0x4
    2d3e:	0f650513          	addi	a0,a0,246 # 6e30 <malloc+0x13e4>
    2d42:	00003097          	auipc	ra,0x3
    2d46:	c4c080e7          	jalr	-948(ra) # 598e <printf>
    exit(1);
    2d4a:	4505                	li	a0,1
    2d4c:	00003097          	auipc	ra,0x3
    2d50:	8c2080e7          	jalr	-1854(ra) # 560e <exit>
    printf("%s: create 123456789012345/123456789012345/123456789012345 failed\n", s);
    2d54:	85a6                	mv	a1,s1
    2d56:	00004517          	auipc	a0,0x4
    2d5a:	14250513          	addi	a0,a0,322 # 6e98 <malloc+0x144c>
    2d5e:	00003097          	auipc	ra,0x3
    2d62:	c30080e7          	jalr	-976(ra) # 598e <printf>
    exit(1);
    2d66:	4505                	li	a0,1
    2d68:	00003097          	auipc	ra,0x3
    2d6c:	8a6080e7          	jalr	-1882(ra) # 560e <exit>
    printf("%s: open 12345678901234/12345678901234/12345678901234 failed\n", s);
    2d70:	85a6                	mv	a1,s1
    2d72:	00004517          	auipc	a0,0x4
    2d76:	19e50513          	addi	a0,a0,414 # 6f10 <malloc+0x14c4>
    2d7a:	00003097          	auipc	ra,0x3
    2d7e:	c14080e7          	jalr	-1004(ra) # 598e <printf>
    exit(1);
    2d82:	4505                	li	a0,1
    2d84:	00003097          	auipc	ra,0x3
    2d88:	88a080e7          	jalr	-1910(ra) # 560e <exit>
    printf("%s: mkdir 12345678901234/12345678901234 succeeded!\n", s);
    2d8c:	85a6                	mv	a1,s1
    2d8e:	00004517          	auipc	a0,0x4
    2d92:	1e250513          	addi	a0,a0,482 # 6f70 <malloc+0x1524>
    2d96:	00003097          	auipc	ra,0x3
    2d9a:	bf8080e7          	jalr	-1032(ra) # 598e <printf>
    exit(1);
    2d9e:	4505                	li	a0,1
    2da0:	00003097          	auipc	ra,0x3
    2da4:	86e080e7          	jalr	-1938(ra) # 560e <exit>
    printf("%s: mkdir 12345678901234/123456789012345 succeeded!\n", s);
    2da8:	85a6                	mv	a1,s1
    2daa:	00004517          	auipc	a0,0x4
    2dae:	21e50513          	addi	a0,a0,542 # 6fc8 <malloc+0x157c>
    2db2:	00003097          	auipc	ra,0x3
    2db6:	bdc080e7          	jalr	-1060(ra) # 598e <printf>
    exit(1);
    2dba:	4505                	li	a0,1
    2dbc:	00003097          	auipc	ra,0x3
    2dc0:	852080e7          	jalr	-1966(ra) # 560e <exit>

0000000000002dc4 <iputtest>:
{
    2dc4:	1101                	addi	sp,sp,-32
    2dc6:	ec06                	sd	ra,24(sp)
    2dc8:	e822                	sd	s0,16(sp)
    2dca:	e426                	sd	s1,8(sp)
    2dcc:	1000                	addi	s0,sp,32
    2dce:	84aa                	mv	s1,a0
  if(mkdir("iputdir") < 0){
    2dd0:	00004517          	auipc	a0,0x4
    2dd4:	23050513          	addi	a0,a0,560 # 7000 <malloc+0x15b4>
    2dd8:	00003097          	auipc	ra,0x3
    2ddc:	89e080e7          	jalr	-1890(ra) # 5676 <mkdir>
    2de0:	04054563          	bltz	a0,2e2a <iputtest+0x66>
  if(chdir("iputdir") < 0){
    2de4:	00004517          	auipc	a0,0x4
    2de8:	21c50513          	addi	a0,a0,540 # 7000 <malloc+0x15b4>
    2dec:	00003097          	auipc	ra,0x3
    2df0:	892080e7          	jalr	-1902(ra) # 567e <chdir>
    2df4:	04054963          	bltz	a0,2e46 <iputtest+0x82>
  if(unlink("../iputdir") < 0){
    2df8:	00004517          	auipc	a0,0x4
    2dfc:	24850513          	addi	a0,a0,584 # 7040 <malloc+0x15f4>
    2e00:	00003097          	auipc	ra,0x3
    2e04:	85e080e7          	jalr	-1954(ra) # 565e <unlink>
    2e08:	04054d63          	bltz	a0,2e62 <iputtest+0x9e>
  if(chdir("/") < 0){
    2e0c:	00004517          	auipc	a0,0x4
    2e10:	26450513          	addi	a0,a0,612 # 7070 <malloc+0x1624>
    2e14:	00003097          	auipc	ra,0x3
    2e18:	86a080e7          	jalr	-1942(ra) # 567e <chdir>
    2e1c:	06054163          	bltz	a0,2e7e <iputtest+0xba>
}
    2e20:	60e2                	ld	ra,24(sp)
    2e22:	6442                	ld	s0,16(sp)
    2e24:	64a2                	ld	s1,8(sp)
    2e26:	6105                	addi	sp,sp,32
    2e28:	8082                	ret
    printf("%s: mkdir failed\n", s);
    2e2a:	85a6                	mv	a1,s1
    2e2c:	00004517          	auipc	a0,0x4
    2e30:	1dc50513          	addi	a0,a0,476 # 7008 <malloc+0x15bc>
    2e34:	00003097          	auipc	ra,0x3
    2e38:	b5a080e7          	jalr	-1190(ra) # 598e <printf>
    exit(1);
    2e3c:	4505                	li	a0,1
    2e3e:	00002097          	auipc	ra,0x2
    2e42:	7d0080e7          	jalr	2000(ra) # 560e <exit>
    printf("%s: chdir iputdir failed\n", s);
    2e46:	85a6                	mv	a1,s1
    2e48:	00004517          	auipc	a0,0x4
    2e4c:	1d850513          	addi	a0,a0,472 # 7020 <malloc+0x15d4>
    2e50:	00003097          	auipc	ra,0x3
    2e54:	b3e080e7          	jalr	-1218(ra) # 598e <printf>
    exit(1);
    2e58:	4505                	li	a0,1
    2e5a:	00002097          	auipc	ra,0x2
    2e5e:	7b4080e7          	jalr	1972(ra) # 560e <exit>
    printf("%s: unlink ../iputdir failed\n", s);
    2e62:	85a6                	mv	a1,s1
    2e64:	00004517          	auipc	a0,0x4
    2e68:	1ec50513          	addi	a0,a0,492 # 7050 <malloc+0x1604>
    2e6c:	00003097          	auipc	ra,0x3
    2e70:	b22080e7          	jalr	-1246(ra) # 598e <printf>
    exit(1);
    2e74:	4505                	li	a0,1
    2e76:	00002097          	auipc	ra,0x2
    2e7a:	798080e7          	jalr	1944(ra) # 560e <exit>
    printf("%s: chdir / failed\n", s);
    2e7e:	85a6                	mv	a1,s1
    2e80:	00004517          	auipc	a0,0x4
    2e84:	1f850513          	addi	a0,a0,504 # 7078 <malloc+0x162c>
    2e88:	00003097          	auipc	ra,0x3
    2e8c:	b06080e7          	jalr	-1274(ra) # 598e <printf>
    exit(1);
    2e90:	4505                	li	a0,1
    2e92:	00002097          	auipc	ra,0x2
    2e96:	77c080e7          	jalr	1916(ra) # 560e <exit>

0000000000002e9a <exitiputtest>:
{
    2e9a:	7179                	addi	sp,sp,-48
    2e9c:	f406                	sd	ra,40(sp)
    2e9e:	f022                	sd	s0,32(sp)
    2ea0:	ec26                	sd	s1,24(sp)
    2ea2:	1800                	addi	s0,sp,48
    2ea4:	84aa                	mv	s1,a0
  pid = fork();
    2ea6:	00002097          	auipc	ra,0x2
    2eaa:	760080e7          	jalr	1888(ra) # 5606 <fork>
  if(pid < 0){
    2eae:	04054663          	bltz	a0,2efa <exitiputtest+0x60>
  if(pid == 0){
    2eb2:	ed45                	bnez	a0,2f6a <exitiputtest+0xd0>
    if(mkdir("iputdir") < 0){
    2eb4:	00004517          	auipc	a0,0x4
    2eb8:	14c50513          	addi	a0,a0,332 # 7000 <malloc+0x15b4>
    2ebc:	00002097          	auipc	ra,0x2
    2ec0:	7ba080e7          	jalr	1978(ra) # 5676 <mkdir>
    2ec4:	04054963          	bltz	a0,2f16 <exitiputtest+0x7c>
    if(chdir("iputdir") < 0){
    2ec8:	00004517          	auipc	a0,0x4
    2ecc:	13850513          	addi	a0,a0,312 # 7000 <malloc+0x15b4>
    2ed0:	00002097          	auipc	ra,0x2
    2ed4:	7ae080e7          	jalr	1966(ra) # 567e <chdir>
    2ed8:	04054d63          	bltz	a0,2f32 <exitiputtest+0x98>
    if(unlink("../iputdir") < 0){
    2edc:	00004517          	auipc	a0,0x4
    2ee0:	16450513          	addi	a0,a0,356 # 7040 <malloc+0x15f4>
    2ee4:	00002097          	auipc	ra,0x2
    2ee8:	77a080e7          	jalr	1914(ra) # 565e <unlink>
    2eec:	06054163          	bltz	a0,2f4e <exitiputtest+0xb4>
    exit(0);
    2ef0:	4501                	li	a0,0
    2ef2:	00002097          	auipc	ra,0x2
    2ef6:	71c080e7          	jalr	1820(ra) # 560e <exit>
    printf("%s: fork failed\n", s);
    2efa:	85a6                	mv	a1,s1
    2efc:	00003517          	auipc	a0,0x3
    2f00:	7c450513          	addi	a0,a0,1988 # 66c0 <malloc+0xc74>
    2f04:	00003097          	auipc	ra,0x3
    2f08:	a8a080e7          	jalr	-1398(ra) # 598e <printf>
    exit(1);
    2f0c:	4505                	li	a0,1
    2f0e:	00002097          	auipc	ra,0x2
    2f12:	700080e7          	jalr	1792(ra) # 560e <exit>
      printf("%s: mkdir failed\n", s);
    2f16:	85a6                	mv	a1,s1
    2f18:	00004517          	auipc	a0,0x4
    2f1c:	0f050513          	addi	a0,a0,240 # 7008 <malloc+0x15bc>
    2f20:	00003097          	auipc	ra,0x3
    2f24:	a6e080e7          	jalr	-1426(ra) # 598e <printf>
      exit(1);
    2f28:	4505                	li	a0,1
    2f2a:	00002097          	auipc	ra,0x2
    2f2e:	6e4080e7          	jalr	1764(ra) # 560e <exit>
      printf("%s: child chdir failed\n", s);
    2f32:	85a6                	mv	a1,s1
    2f34:	00004517          	auipc	a0,0x4
    2f38:	15c50513          	addi	a0,a0,348 # 7090 <malloc+0x1644>
    2f3c:	00003097          	auipc	ra,0x3
    2f40:	a52080e7          	jalr	-1454(ra) # 598e <printf>
      exit(1);
    2f44:	4505                	li	a0,1
    2f46:	00002097          	auipc	ra,0x2
    2f4a:	6c8080e7          	jalr	1736(ra) # 560e <exit>
      printf("%s: unlink ../iputdir failed\n", s);
    2f4e:	85a6                	mv	a1,s1
    2f50:	00004517          	auipc	a0,0x4
    2f54:	10050513          	addi	a0,a0,256 # 7050 <malloc+0x1604>
    2f58:	00003097          	auipc	ra,0x3
    2f5c:	a36080e7          	jalr	-1482(ra) # 598e <printf>
      exit(1);
    2f60:	4505                	li	a0,1
    2f62:	00002097          	auipc	ra,0x2
    2f66:	6ac080e7          	jalr	1708(ra) # 560e <exit>
  wait(&xstatus);
    2f6a:	fdc40513          	addi	a0,s0,-36
    2f6e:	00002097          	auipc	ra,0x2
    2f72:	6a8080e7          	jalr	1704(ra) # 5616 <wait>
  exit(xstatus);
    2f76:	fdc42503          	lw	a0,-36(s0)
    2f7a:	00002097          	auipc	ra,0x2
    2f7e:	694080e7          	jalr	1684(ra) # 560e <exit>

0000000000002f82 <dirtest>:
{
    2f82:	1101                	addi	sp,sp,-32
    2f84:	ec06                	sd	ra,24(sp)
    2f86:	e822                	sd	s0,16(sp)
    2f88:	e426                	sd	s1,8(sp)
    2f8a:	1000                	addi	s0,sp,32
    2f8c:	84aa                	mv	s1,a0
  if(mkdir("dir0") < 0){
    2f8e:	00004517          	auipc	a0,0x4
    2f92:	11a50513          	addi	a0,a0,282 # 70a8 <malloc+0x165c>
    2f96:	00002097          	auipc	ra,0x2
    2f9a:	6e0080e7          	jalr	1760(ra) # 5676 <mkdir>
    2f9e:	04054563          	bltz	a0,2fe8 <dirtest+0x66>
  if(chdir("dir0") < 0){
    2fa2:	00004517          	auipc	a0,0x4
    2fa6:	10650513          	addi	a0,a0,262 # 70a8 <malloc+0x165c>
    2faa:	00002097          	auipc	ra,0x2
    2fae:	6d4080e7          	jalr	1748(ra) # 567e <chdir>
    2fb2:	04054963          	bltz	a0,3004 <dirtest+0x82>
  if(chdir("..") < 0){
    2fb6:	00004517          	auipc	a0,0x4
    2fba:	11250513          	addi	a0,a0,274 # 70c8 <malloc+0x167c>
    2fbe:	00002097          	auipc	ra,0x2
    2fc2:	6c0080e7          	jalr	1728(ra) # 567e <chdir>
    2fc6:	04054d63          	bltz	a0,3020 <dirtest+0x9e>
  if(unlink("dir0") < 0){
    2fca:	00004517          	auipc	a0,0x4
    2fce:	0de50513          	addi	a0,a0,222 # 70a8 <malloc+0x165c>
    2fd2:	00002097          	auipc	ra,0x2
    2fd6:	68c080e7          	jalr	1676(ra) # 565e <unlink>
    2fda:	06054163          	bltz	a0,303c <dirtest+0xba>
}
    2fde:	60e2                	ld	ra,24(sp)
    2fe0:	6442                	ld	s0,16(sp)
    2fe2:	64a2                	ld	s1,8(sp)
    2fe4:	6105                	addi	sp,sp,32
    2fe6:	8082                	ret
    printf("%s: mkdir failed\n", s);
    2fe8:	85a6                	mv	a1,s1
    2fea:	00004517          	auipc	a0,0x4
    2fee:	01e50513          	addi	a0,a0,30 # 7008 <malloc+0x15bc>
    2ff2:	00003097          	auipc	ra,0x3
    2ff6:	99c080e7          	jalr	-1636(ra) # 598e <printf>
    exit(1);
    2ffa:	4505                	li	a0,1
    2ffc:	00002097          	auipc	ra,0x2
    3000:	612080e7          	jalr	1554(ra) # 560e <exit>
    printf("%s: chdir dir0 failed\n", s);
    3004:	85a6                	mv	a1,s1
    3006:	00004517          	auipc	a0,0x4
    300a:	0aa50513          	addi	a0,a0,170 # 70b0 <malloc+0x1664>
    300e:	00003097          	auipc	ra,0x3
    3012:	980080e7          	jalr	-1664(ra) # 598e <printf>
    exit(1);
    3016:	4505                	li	a0,1
    3018:	00002097          	auipc	ra,0x2
    301c:	5f6080e7          	jalr	1526(ra) # 560e <exit>
    printf("%s: chdir .. failed\n", s);
    3020:	85a6                	mv	a1,s1
    3022:	00004517          	auipc	a0,0x4
    3026:	0ae50513          	addi	a0,a0,174 # 70d0 <malloc+0x1684>
    302a:	00003097          	auipc	ra,0x3
    302e:	964080e7          	jalr	-1692(ra) # 598e <printf>
    exit(1);
    3032:	4505                	li	a0,1
    3034:	00002097          	auipc	ra,0x2
    3038:	5da080e7          	jalr	1498(ra) # 560e <exit>
    printf("%s: unlink dir0 failed\n", s);
    303c:	85a6                	mv	a1,s1
    303e:	00004517          	auipc	a0,0x4
    3042:	0aa50513          	addi	a0,a0,170 # 70e8 <malloc+0x169c>
    3046:	00003097          	auipc	ra,0x3
    304a:	948080e7          	jalr	-1720(ra) # 598e <printf>
    exit(1);
    304e:	4505                	li	a0,1
    3050:	00002097          	auipc	ra,0x2
    3054:	5be080e7          	jalr	1470(ra) # 560e <exit>

0000000000003058 <subdir>:
{
    3058:	1101                	addi	sp,sp,-32
    305a:	ec06                	sd	ra,24(sp)
    305c:	e822                	sd	s0,16(sp)
    305e:	e426                	sd	s1,8(sp)
    3060:	e04a                	sd	s2,0(sp)
    3062:	1000                	addi	s0,sp,32
    3064:	892a                	mv	s2,a0
  unlink("ff");
    3066:	00004517          	auipc	a0,0x4
    306a:	1ca50513          	addi	a0,a0,458 # 7230 <malloc+0x17e4>
    306e:	00002097          	auipc	ra,0x2
    3072:	5f0080e7          	jalr	1520(ra) # 565e <unlink>
  if(mkdir("dd") != 0){
    3076:	00004517          	auipc	a0,0x4
    307a:	08a50513          	addi	a0,a0,138 # 7100 <malloc+0x16b4>
    307e:	00002097          	auipc	ra,0x2
    3082:	5f8080e7          	jalr	1528(ra) # 5676 <mkdir>
    3086:	38051663          	bnez	a0,3412 <subdir+0x3ba>
  fd = open("dd/ff", O_CREATE | O_RDWR);
    308a:	20200593          	li	a1,514
    308e:	00004517          	auipc	a0,0x4
    3092:	09250513          	addi	a0,a0,146 # 7120 <malloc+0x16d4>
    3096:	00002097          	auipc	ra,0x2
    309a:	5b8080e7          	jalr	1464(ra) # 564e <open>
    309e:	84aa                	mv	s1,a0
  if(fd < 0){
    30a0:	38054763          	bltz	a0,342e <subdir+0x3d6>
  write(fd, "ff", 2);
    30a4:	4609                	li	a2,2
    30a6:	00004597          	auipc	a1,0x4
    30aa:	18a58593          	addi	a1,a1,394 # 7230 <malloc+0x17e4>
    30ae:	00002097          	auipc	ra,0x2
    30b2:	580080e7          	jalr	1408(ra) # 562e <write>
  close(fd);
    30b6:	8526                	mv	a0,s1
    30b8:	00002097          	auipc	ra,0x2
    30bc:	57e080e7          	jalr	1406(ra) # 5636 <close>
  if(unlink("dd") >= 0){
    30c0:	00004517          	auipc	a0,0x4
    30c4:	04050513          	addi	a0,a0,64 # 7100 <malloc+0x16b4>
    30c8:	00002097          	auipc	ra,0x2
    30cc:	596080e7          	jalr	1430(ra) # 565e <unlink>
    30d0:	36055d63          	bgez	a0,344a <subdir+0x3f2>
  if(mkdir("/dd/dd") != 0){
    30d4:	00004517          	auipc	a0,0x4
    30d8:	0a450513          	addi	a0,a0,164 # 7178 <malloc+0x172c>
    30dc:	00002097          	auipc	ra,0x2
    30e0:	59a080e7          	jalr	1434(ra) # 5676 <mkdir>
    30e4:	38051163          	bnez	a0,3466 <subdir+0x40e>
  fd = open("dd/dd/ff", O_CREATE | O_RDWR);
    30e8:	20200593          	li	a1,514
    30ec:	00004517          	auipc	a0,0x4
    30f0:	0b450513          	addi	a0,a0,180 # 71a0 <malloc+0x1754>
    30f4:	00002097          	auipc	ra,0x2
    30f8:	55a080e7          	jalr	1370(ra) # 564e <open>
    30fc:	84aa                	mv	s1,a0
  if(fd < 0){
    30fe:	38054263          	bltz	a0,3482 <subdir+0x42a>
  write(fd, "FF", 2);
    3102:	4609                	li	a2,2
    3104:	00004597          	auipc	a1,0x4
    3108:	0cc58593          	addi	a1,a1,204 # 71d0 <malloc+0x1784>
    310c:	00002097          	auipc	ra,0x2
    3110:	522080e7          	jalr	1314(ra) # 562e <write>
  close(fd);
    3114:	8526                	mv	a0,s1
    3116:	00002097          	auipc	ra,0x2
    311a:	520080e7          	jalr	1312(ra) # 5636 <close>
  fd = open("dd/dd/../ff", 0);
    311e:	4581                	li	a1,0
    3120:	00004517          	auipc	a0,0x4
    3124:	0b850513          	addi	a0,a0,184 # 71d8 <malloc+0x178c>
    3128:	00002097          	auipc	ra,0x2
    312c:	526080e7          	jalr	1318(ra) # 564e <open>
    3130:	84aa                	mv	s1,a0
  if(fd < 0){
    3132:	36054663          	bltz	a0,349e <subdir+0x446>
  cc = read(fd, buf, sizeof(buf));
    3136:	660d                	lui	a2,0x3
    3138:	00009597          	auipc	a1,0x9
    313c:	96858593          	addi	a1,a1,-1688 # baa0 <buf>
    3140:	00002097          	auipc	ra,0x2
    3144:	4e6080e7          	jalr	1254(ra) # 5626 <read>
  if(cc != 2 || buf[0] != 'f'){
    3148:	4789                	li	a5,2
    314a:	36f51863          	bne	a0,a5,34ba <subdir+0x462>
    314e:	00009717          	auipc	a4,0x9
    3152:	95274703          	lbu	a4,-1710(a4) # baa0 <buf>
    3156:	06600793          	li	a5,102
    315a:	36f71063          	bne	a4,a5,34ba <subdir+0x462>
  close(fd);
    315e:	8526                	mv	a0,s1
    3160:	00002097          	auipc	ra,0x2
    3164:	4d6080e7          	jalr	1238(ra) # 5636 <close>
  if(link("dd/dd/ff", "dd/dd/ffff") != 0){
    3168:	00004597          	auipc	a1,0x4
    316c:	0c058593          	addi	a1,a1,192 # 7228 <malloc+0x17dc>
    3170:	00004517          	auipc	a0,0x4
    3174:	03050513          	addi	a0,a0,48 # 71a0 <malloc+0x1754>
    3178:	00002097          	auipc	ra,0x2
    317c:	4f6080e7          	jalr	1270(ra) # 566e <link>
    3180:	34051b63          	bnez	a0,34d6 <subdir+0x47e>
  if(unlink("dd/dd/ff") != 0){
    3184:	00004517          	auipc	a0,0x4
    3188:	01c50513          	addi	a0,a0,28 # 71a0 <malloc+0x1754>
    318c:	00002097          	auipc	ra,0x2
    3190:	4d2080e7          	jalr	1234(ra) # 565e <unlink>
    3194:	34051f63          	bnez	a0,34f2 <subdir+0x49a>
  if(open("dd/dd/ff", O_RDONLY) >= 0){
    3198:	4581                	li	a1,0
    319a:	00004517          	auipc	a0,0x4
    319e:	00650513          	addi	a0,a0,6 # 71a0 <malloc+0x1754>
    31a2:	00002097          	auipc	ra,0x2
    31a6:	4ac080e7          	jalr	1196(ra) # 564e <open>
    31aa:	36055263          	bgez	a0,350e <subdir+0x4b6>
  if(chdir("dd") != 0){
    31ae:	00004517          	auipc	a0,0x4
    31b2:	f5250513          	addi	a0,a0,-174 # 7100 <malloc+0x16b4>
    31b6:	00002097          	auipc	ra,0x2
    31ba:	4c8080e7          	jalr	1224(ra) # 567e <chdir>
    31be:	36051663          	bnez	a0,352a <subdir+0x4d2>
  if(chdir("dd/../../dd") != 0){
    31c2:	00004517          	auipc	a0,0x4
    31c6:	0fe50513          	addi	a0,a0,254 # 72c0 <malloc+0x1874>
    31ca:	00002097          	auipc	ra,0x2
    31ce:	4b4080e7          	jalr	1204(ra) # 567e <chdir>
    31d2:	36051a63          	bnez	a0,3546 <subdir+0x4ee>
  if(chdir("dd/../../../dd") != 0){
    31d6:	00004517          	auipc	a0,0x4
    31da:	11a50513          	addi	a0,a0,282 # 72f0 <malloc+0x18a4>
    31de:	00002097          	auipc	ra,0x2
    31e2:	4a0080e7          	jalr	1184(ra) # 567e <chdir>
    31e6:	36051e63          	bnez	a0,3562 <subdir+0x50a>
  if(chdir("./..") != 0){
    31ea:	00004517          	auipc	a0,0x4
    31ee:	13650513          	addi	a0,a0,310 # 7320 <malloc+0x18d4>
    31f2:	00002097          	auipc	ra,0x2
    31f6:	48c080e7          	jalr	1164(ra) # 567e <chdir>
    31fa:	38051263          	bnez	a0,357e <subdir+0x526>
  fd = open("dd/dd/ffff", 0);
    31fe:	4581                	li	a1,0
    3200:	00004517          	auipc	a0,0x4
    3204:	02850513          	addi	a0,a0,40 # 7228 <malloc+0x17dc>
    3208:	00002097          	auipc	ra,0x2
    320c:	446080e7          	jalr	1094(ra) # 564e <open>
    3210:	84aa                	mv	s1,a0
  if(fd < 0){
    3212:	38054463          	bltz	a0,359a <subdir+0x542>
  if(read(fd, buf, sizeof(buf)) != 2){
    3216:	660d                	lui	a2,0x3
    3218:	00009597          	auipc	a1,0x9
    321c:	88858593          	addi	a1,a1,-1912 # baa0 <buf>
    3220:	00002097          	auipc	ra,0x2
    3224:	406080e7          	jalr	1030(ra) # 5626 <read>
    3228:	4789                	li	a5,2
    322a:	38f51663          	bne	a0,a5,35b6 <subdir+0x55e>
  close(fd);
    322e:	8526                	mv	a0,s1
    3230:	00002097          	auipc	ra,0x2
    3234:	406080e7          	jalr	1030(ra) # 5636 <close>
  if(open("dd/dd/ff", O_RDONLY) >= 0){
    3238:	4581                	li	a1,0
    323a:	00004517          	auipc	a0,0x4
    323e:	f6650513          	addi	a0,a0,-154 # 71a0 <malloc+0x1754>
    3242:	00002097          	auipc	ra,0x2
    3246:	40c080e7          	jalr	1036(ra) # 564e <open>
    324a:	38055463          	bgez	a0,35d2 <subdir+0x57a>
  if(open("dd/ff/ff", O_CREATE|O_RDWR) >= 0){
    324e:	20200593          	li	a1,514
    3252:	00004517          	auipc	a0,0x4
    3256:	15e50513          	addi	a0,a0,350 # 73b0 <malloc+0x1964>
    325a:	00002097          	auipc	ra,0x2
    325e:	3f4080e7          	jalr	1012(ra) # 564e <open>
    3262:	38055663          	bgez	a0,35ee <subdir+0x596>
  if(open("dd/xx/ff", O_CREATE|O_RDWR) >= 0){
    3266:	20200593          	li	a1,514
    326a:	00004517          	auipc	a0,0x4
    326e:	17650513          	addi	a0,a0,374 # 73e0 <malloc+0x1994>
    3272:	00002097          	auipc	ra,0x2
    3276:	3dc080e7          	jalr	988(ra) # 564e <open>
    327a:	38055863          	bgez	a0,360a <subdir+0x5b2>
  if(open("dd", O_CREATE) >= 0){
    327e:	20000593          	li	a1,512
    3282:	00004517          	auipc	a0,0x4
    3286:	e7e50513          	addi	a0,a0,-386 # 7100 <malloc+0x16b4>
    328a:	00002097          	auipc	ra,0x2
    328e:	3c4080e7          	jalr	964(ra) # 564e <open>
    3292:	38055a63          	bgez	a0,3626 <subdir+0x5ce>
  if(open("dd", O_RDWR) >= 0){
    3296:	4589                	li	a1,2
    3298:	00004517          	auipc	a0,0x4
    329c:	e6850513          	addi	a0,a0,-408 # 7100 <malloc+0x16b4>
    32a0:	00002097          	auipc	ra,0x2
    32a4:	3ae080e7          	jalr	942(ra) # 564e <open>
    32a8:	38055d63          	bgez	a0,3642 <subdir+0x5ea>
  if(open("dd", O_WRONLY) >= 0){
    32ac:	4585                	li	a1,1
    32ae:	00004517          	auipc	a0,0x4
    32b2:	e5250513          	addi	a0,a0,-430 # 7100 <malloc+0x16b4>
    32b6:	00002097          	auipc	ra,0x2
    32ba:	398080e7          	jalr	920(ra) # 564e <open>
    32be:	3a055063          	bgez	a0,365e <subdir+0x606>
  if(link("dd/ff/ff", "dd/dd/xx") == 0){
    32c2:	00004597          	auipc	a1,0x4
    32c6:	1ae58593          	addi	a1,a1,430 # 7470 <malloc+0x1a24>
    32ca:	00004517          	auipc	a0,0x4
    32ce:	0e650513          	addi	a0,a0,230 # 73b0 <malloc+0x1964>
    32d2:	00002097          	auipc	ra,0x2
    32d6:	39c080e7          	jalr	924(ra) # 566e <link>
    32da:	3a050063          	beqz	a0,367a <subdir+0x622>
  if(link("dd/xx/ff", "dd/dd/xx") == 0){
    32de:	00004597          	auipc	a1,0x4
    32e2:	19258593          	addi	a1,a1,402 # 7470 <malloc+0x1a24>
    32e6:	00004517          	auipc	a0,0x4
    32ea:	0fa50513          	addi	a0,a0,250 # 73e0 <malloc+0x1994>
    32ee:	00002097          	auipc	ra,0x2
    32f2:	380080e7          	jalr	896(ra) # 566e <link>
    32f6:	3a050063          	beqz	a0,3696 <subdir+0x63e>
  if(link("dd/ff", "dd/dd/ffff") == 0){
    32fa:	00004597          	auipc	a1,0x4
    32fe:	f2e58593          	addi	a1,a1,-210 # 7228 <malloc+0x17dc>
    3302:	00004517          	auipc	a0,0x4
    3306:	e1e50513          	addi	a0,a0,-482 # 7120 <malloc+0x16d4>
    330a:	00002097          	auipc	ra,0x2
    330e:	364080e7          	jalr	868(ra) # 566e <link>
    3312:	3a050063          	beqz	a0,36b2 <subdir+0x65a>
  if(mkdir("dd/ff/ff") == 0){
    3316:	00004517          	auipc	a0,0x4
    331a:	09a50513          	addi	a0,a0,154 # 73b0 <malloc+0x1964>
    331e:	00002097          	auipc	ra,0x2
    3322:	358080e7          	jalr	856(ra) # 5676 <mkdir>
    3326:	3a050463          	beqz	a0,36ce <subdir+0x676>
  if(mkdir("dd/xx/ff") == 0){
    332a:	00004517          	auipc	a0,0x4
    332e:	0b650513          	addi	a0,a0,182 # 73e0 <malloc+0x1994>
    3332:	00002097          	auipc	ra,0x2
    3336:	344080e7          	jalr	836(ra) # 5676 <mkdir>
    333a:	3a050863          	beqz	a0,36ea <subdir+0x692>
  if(mkdir("dd/dd/ffff") == 0){
    333e:	00004517          	auipc	a0,0x4
    3342:	eea50513          	addi	a0,a0,-278 # 7228 <malloc+0x17dc>
    3346:	00002097          	auipc	ra,0x2
    334a:	330080e7          	jalr	816(ra) # 5676 <mkdir>
    334e:	3a050c63          	beqz	a0,3706 <subdir+0x6ae>
  if(unlink("dd/xx/ff") == 0){
    3352:	00004517          	auipc	a0,0x4
    3356:	08e50513          	addi	a0,a0,142 # 73e0 <malloc+0x1994>
    335a:	00002097          	auipc	ra,0x2
    335e:	304080e7          	jalr	772(ra) # 565e <unlink>
    3362:	3c050063          	beqz	a0,3722 <subdir+0x6ca>
  if(unlink("dd/ff/ff") == 0){
    3366:	00004517          	auipc	a0,0x4
    336a:	04a50513          	addi	a0,a0,74 # 73b0 <malloc+0x1964>
    336e:	00002097          	auipc	ra,0x2
    3372:	2f0080e7          	jalr	752(ra) # 565e <unlink>
    3376:	3c050463          	beqz	a0,373e <subdir+0x6e6>
  if(chdir("dd/ff") == 0){
    337a:	00004517          	auipc	a0,0x4
    337e:	da650513          	addi	a0,a0,-602 # 7120 <malloc+0x16d4>
    3382:	00002097          	auipc	ra,0x2
    3386:	2fc080e7          	jalr	764(ra) # 567e <chdir>
    338a:	3c050863          	beqz	a0,375a <subdir+0x702>
  if(chdir("dd/xx") == 0){
    338e:	00004517          	auipc	a0,0x4
    3392:	23250513          	addi	a0,a0,562 # 75c0 <malloc+0x1b74>
    3396:	00002097          	auipc	ra,0x2
    339a:	2e8080e7          	jalr	744(ra) # 567e <chdir>
    339e:	3c050c63          	beqz	a0,3776 <subdir+0x71e>
  if(unlink("dd/dd/ffff") != 0){
    33a2:	00004517          	auipc	a0,0x4
    33a6:	e8650513          	addi	a0,a0,-378 # 7228 <malloc+0x17dc>
    33aa:	00002097          	auipc	ra,0x2
    33ae:	2b4080e7          	jalr	692(ra) # 565e <unlink>
    33b2:	3e051063          	bnez	a0,3792 <subdir+0x73a>
  if(unlink("dd/ff") != 0){
    33b6:	00004517          	auipc	a0,0x4
    33ba:	d6a50513          	addi	a0,a0,-662 # 7120 <malloc+0x16d4>
    33be:	00002097          	auipc	ra,0x2
    33c2:	2a0080e7          	jalr	672(ra) # 565e <unlink>
    33c6:	3e051463          	bnez	a0,37ae <subdir+0x756>
  if(unlink("dd") == 0){
    33ca:	00004517          	auipc	a0,0x4
    33ce:	d3650513          	addi	a0,a0,-714 # 7100 <malloc+0x16b4>
    33d2:	00002097          	auipc	ra,0x2
    33d6:	28c080e7          	jalr	652(ra) # 565e <unlink>
    33da:	3e050863          	beqz	a0,37ca <subdir+0x772>
  if(unlink("dd/dd") < 0){
    33de:	00004517          	auipc	a0,0x4
    33e2:	25250513          	addi	a0,a0,594 # 7630 <malloc+0x1be4>
    33e6:	00002097          	auipc	ra,0x2
    33ea:	278080e7          	jalr	632(ra) # 565e <unlink>
    33ee:	3e054c63          	bltz	a0,37e6 <subdir+0x78e>
  if(unlink("dd") < 0){
    33f2:	00004517          	auipc	a0,0x4
    33f6:	d0e50513          	addi	a0,a0,-754 # 7100 <malloc+0x16b4>
    33fa:	00002097          	auipc	ra,0x2
    33fe:	264080e7          	jalr	612(ra) # 565e <unlink>
    3402:	40054063          	bltz	a0,3802 <subdir+0x7aa>
}
    3406:	60e2                	ld	ra,24(sp)
    3408:	6442                	ld	s0,16(sp)
    340a:	64a2                	ld	s1,8(sp)
    340c:	6902                	ld	s2,0(sp)
    340e:	6105                	addi	sp,sp,32
    3410:	8082                	ret
    printf("%s: mkdir dd failed\n", s);
    3412:	85ca                	mv	a1,s2
    3414:	00004517          	auipc	a0,0x4
    3418:	cf450513          	addi	a0,a0,-780 # 7108 <malloc+0x16bc>
    341c:	00002097          	auipc	ra,0x2
    3420:	572080e7          	jalr	1394(ra) # 598e <printf>
    exit(1);
    3424:	4505                	li	a0,1
    3426:	00002097          	auipc	ra,0x2
    342a:	1e8080e7          	jalr	488(ra) # 560e <exit>
    printf("%s: create dd/ff failed\n", s);
    342e:	85ca                	mv	a1,s2
    3430:	00004517          	auipc	a0,0x4
    3434:	cf850513          	addi	a0,a0,-776 # 7128 <malloc+0x16dc>
    3438:	00002097          	auipc	ra,0x2
    343c:	556080e7          	jalr	1366(ra) # 598e <printf>
    exit(1);
    3440:	4505                	li	a0,1
    3442:	00002097          	auipc	ra,0x2
    3446:	1cc080e7          	jalr	460(ra) # 560e <exit>
    printf("%s: unlink dd (non-empty dir) succeeded!\n", s);
    344a:	85ca                	mv	a1,s2
    344c:	00004517          	auipc	a0,0x4
    3450:	cfc50513          	addi	a0,a0,-772 # 7148 <malloc+0x16fc>
    3454:	00002097          	auipc	ra,0x2
    3458:	53a080e7          	jalr	1338(ra) # 598e <printf>
    exit(1);
    345c:	4505                	li	a0,1
    345e:	00002097          	auipc	ra,0x2
    3462:	1b0080e7          	jalr	432(ra) # 560e <exit>
    printf("subdir mkdir dd/dd failed\n", s);
    3466:	85ca                	mv	a1,s2
    3468:	00004517          	auipc	a0,0x4
    346c:	d1850513          	addi	a0,a0,-744 # 7180 <malloc+0x1734>
    3470:	00002097          	auipc	ra,0x2
    3474:	51e080e7          	jalr	1310(ra) # 598e <printf>
    exit(1);
    3478:	4505                	li	a0,1
    347a:	00002097          	auipc	ra,0x2
    347e:	194080e7          	jalr	404(ra) # 560e <exit>
    printf("%s: create dd/dd/ff failed\n", s);
    3482:	85ca                	mv	a1,s2
    3484:	00004517          	auipc	a0,0x4
    3488:	d2c50513          	addi	a0,a0,-724 # 71b0 <malloc+0x1764>
    348c:	00002097          	auipc	ra,0x2
    3490:	502080e7          	jalr	1282(ra) # 598e <printf>
    exit(1);
    3494:	4505                	li	a0,1
    3496:	00002097          	auipc	ra,0x2
    349a:	178080e7          	jalr	376(ra) # 560e <exit>
    printf("%s: open dd/dd/../ff failed\n", s);
    349e:	85ca                	mv	a1,s2
    34a0:	00004517          	auipc	a0,0x4
    34a4:	d4850513          	addi	a0,a0,-696 # 71e8 <malloc+0x179c>
    34a8:	00002097          	auipc	ra,0x2
    34ac:	4e6080e7          	jalr	1254(ra) # 598e <printf>
    exit(1);
    34b0:	4505                	li	a0,1
    34b2:	00002097          	auipc	ra,0x2
    34b6:	15c080e7          	jalr	348(ra) # 560e <exit>
    printf("%s: dd/dd/../ff wrong content\n", s);
    34ba:	85ca                	mv	a1,s2
    34bc:	00004517          	auipc	a0,0x4
    34c0:	d4c50513          	addi	a0,a0,-692 # 7208 <malloc+0x17bc>
    34c4:	00002097          	auipc	ra,0x2
    34c8:	4ca080e7          	jalr	1226(ra) # 598e <printf>
    exit(1);
    34cc:	4505                	li	a0,1
    34ce:	00002097          	auipc	ra,0x2
    34d2:	140080e7          	jalr	320(ra) # 560e <exit>
    printf("link dd/dd/ff dd/dd/ffff failed\n", s);
    34d6:	85ca                	mv	a1,s2
    34d8:	00004517          	auipc	a0,0x4
    34dc:	d6050513          	addi	a0,a0,-672 # 7238 <malloc+0x17ec>
    34e0:	00002097          	auipc	ra,0x2
    34e4:	4ae080e7          	jalr	1198(ra) # 598e <printf>
    exit(1);
    34e8:	4505                	li	a0,1
    34ea:	00002097          	auipc	ra,0x2
    34ee:	124080e7          	jalr	292(ra) # 560e <exit>
    printf("%s: unlink dd/dd/ff failed\n", s);
    34f2:	85ca                	mv	a1,s2
    34f4:	00004517          	auipc	a0,0x4
    34f8:	d6c50513          	addi	a0,a0,-660 # 7260 <malloc+0x1814>
    34fc:	00002097          	auipc	ra,0x2
    3500:	492080e7          	jalr	1170(ra) # 598e <printf>
    exit(1);
    3504:	4505                	li	a0,1
    3506:	00002097          	auipc	ra,0x2
    350a:	108080e7          	jalr	264(ra) # 560e <exit>
    printf("%s: open (unlinked) dd/dd/ff succeeded\n", s);
    350e:	85ca                	mv	a1,s2
    3510:	00004517          	auipc	a0,0x4
    3514:	d7050513          	addi	a0,a0,-656 # 7280 <malloc+0x1834>
    3518:	00002097          	auipc	ra,0x2
    351c:	476080e7          	jalr	1142(ra) # 598e <printf>
    exit(1);
    3520:	4505                	li	a0,1
    3522:	00002097          	auipc	ra,0x2
    3526:	0ec080e7          	jalr	236(ra) # 560e <exit>
    printf("%s: chdir dd failed\n", s);
    352a:	85ca                	mv	a1,s2
    352c:	00004517          	auipc	a0,0x4
    3530:	d7c50513          	addi	a0,a0,-644 # 72a8 <malloc+0x185c>
    3534:	00002097          	auipc	ra,0x2
    3538:	45a080e7          	jalr	1114(ra) # 598e <printf>
    exit(1);
    353c:	4505                	li	a0,1
    353e:	00002097          	auipc	ra,0x2
    3542:	0d0080e7          	jalr	208(ra) # 560e <exit>
    printf("%s: chdir dd/../../dd failed\n", s);
    3546:	85ca                	mv	a1,s2
    3548:	00004517          	auipc	a0,0x4
    354c:	d8850513          	addi	a0,a0,-632 # 72d0 <malloc+0x1884>
    3550:	00002097          	auipc	ra,0x2
    3554:	43e080e7          	jalr	1086(ra) # 598e <printf>
    exit(1);
    3558:	4505                	li	a0,1
    355a:	00002097          	auipc	ra,0x2
    355e:	0b4080e7          	jalr	180(ra) # 560e <exit>
    printf("chdir dd/../../dd failed\n", s);
    3562:	85ca                	mv	a1,s2
    3564:	00004517          	auipc	a0,0x4
    3568:	d9c50513          	addi	a0,a0,-612 # 7300 <malloc+0x18b4>
    356c:	00002097          	auipc	ra,0x2
    3570:	422080e7          	jalr	1058(ra) # 598e <printf>
    exit(1);
    3574:	4505                	li	a0,1
    3576:	00002097          	auipc	ra,0x2
    357a:	098080e7          	jalr	152(ra) # 560e <exit>
    printf("%s: chdir ./.. failed\n", s);
    357e:	85ca                	mv	a1,s2
    3580:	00004517          	auipc	a0,0x4
    3584:	da850513          	addi	a0,a0,-600 # 7328 <malloc+0x18dc>
    3588:	00002097          	auipc	ra,0x2
    358c:	406080e7          	jalr	1030(ra) # 598e <printf>
    exit(1);
    3590:	4505                	li	a0,1
    3592:	00002097          	auipc	ra,0x2
    3596:	07c080e7          	jalr	124(ra) # 560e <exit>
    printf("%s: open dd/dd/ffff failed\n", s);
    359a:	85ca                	mv	a1,s2
    359c:	00004517          	auipc	a0,0x4
    35a0:	da450513          	addi	a0,a0,-604 # 7340 <malloc+0x18f4>
    35a4:	00002097          	auipc	ra,0x2
    35a8:	3ea080e7          	jalr	1002(ra) # 598e <printf>
    exit(1);
    35ac:	4505                	li	a0,1
    35ae:	00002097          	auipc	ra,0x2
    35b2:	060080e7          	jalr	96(ra) # 560e <exit>
    printf("%s: read dd/dd/ffff wrong len\n", s);
    35b6:	85ca                	mv	a1,s2
    35b8:	00004517          	auipc	a0,0x4
    35bc:	da850513          	addi	a0,a0,-600 # 7360 <malloc+0x1914>
    35c0:	00002097          	auipc	ra,0x2
    35c4:	3ce080e7          	jalr	974(ra) # 598e <printf>
    exit(1);
    35c8:	4505                	li	a0,1
    35ca:	00002097          	auipc	ra,0x2
    35ce:	044080e7          	jalr	68(ra) # 560e <exit>
    printf("%s: open (unlinked) dd/dd/ff succeeded!\n", s);
    35d2:	85ca                	mv	a1,s2
    35d4:	00004517          	auipc	a0,0x4
    35d8:	dac50513          	addi	a0,a0,-596 # 7380 <malloc+0x1934>
    35dc:	00002097          	auipc	ra,0x2
    35e0:	3b2080e7          	jalr	946(ra) # 598e <printf>
    exit(1);
    35e4:	4505                	li	a0,1
    35e6:	00002097          	auipc	ra,0x2
    35ea:	028080e7          	jalr	40(ra) # 560e <exit>
    printf("%s: create dd/ff/ff succeeded!\n", s);
    35ee:	85ca                	mv	a1,s2
    35f0:	00004517          	auipc	a0,0x4
    35f4:	dd050513          	addi	a0,a0,-560 # 73c0 <malloc+0x1974>
    35f8:	00002097          	auipc	ra,0x2
    35fc:	396080e7          	jalr	918(ra) # 598e <printf>
    exit(1);
    3600:	4505                	li	a0,1
    3602:	00002097          	auipc	ra,0x2
    3606:	00c080e7          	jalr	12(ra) # 560e <exit>
    printf("%s: create dd/xx/ff succeeded!\n", s);
    360a:	85ca                	mv	a1,s2
    360c:	00004517          	auipc	a0,0x4
    3610:	de450513          	addi	a0,a0,-540 # 73f0 <malloc+0x19a4>
    3614:	00002097          	auipc	ra,0x2
    3618:	37a080e7          	jalr	890(ra) # 598e <printf>
    exit(1);
    361c:	4505                	li	a0,1
    361e:	00002097          	auipc	ra,0x2
    3622:	ff0080e7          	jalr	-16(ra) # 560e <exit>
    printf("%s: create dd succeeded!\n", s);
    3626:	85ca                	mv	a1,s2
    3628:	00004517          	auipc	a0,0x4
    362c:	de850513          	addi	a0,a0,-536 # 7410 <malloc+0x19c4>
    3630:	00002097          	auipc	ra,0x2
    3634:	35e080e7          	jalr	862(ra) # 598e <printf>
    exit(1);
    3638:	4505                	li	a0,1
    363a:	00002097          	auipc	ra,0x2
    363e:	fd4080e7          	jalr	-44(ra) # 560e <exit>
    printf("%s: open dd rdwr succeeded!\n", s);
    3642:	85ca                	mv	a1,s2
    3644:	00004517          	auipc	a0,0x4
    3648:	dec50513          	addi	a0,a0,-532 # 7430 <malloc+0x19e4>
    364c:	00002097          	auipc	ra,0x2
    3650:	342080e7          	jalr	834(ra) # 598e <printf>
    exit(1);
    3654:	4505                	li	a0,1
    3656:	00002097          	auipc	ra,0x2
    365a:	fb8080e7          	jalr	-72(ra) # 560e <exit>
    printf("%s: open dd wronly succeeded!\n", s);
    365e:	85ca                	mv	a1,s2
    3660:	00004517          	auipc	a0,0x4
    3664:	df050513          	addi	a0,a0,-528 # 7450 <malloc+0x1a04>
    3668:	00002097          	auipc	ra,0x2
    366c:	326080e7          	jalr	806(ra) # 598e <printf>
    exit(1);
    3670:	4505                	li	a0,1
    3672:	00002097          	auipc	ra,0x2
    3676:	f9c080e7          	jalr	-100(ra) # 560e <exit>
    printf("%s: link dd/ff/ff dd/dd/xx succeeded!\n", s);
    367a:	85ca                	mv	a1,s2
    367c:	00004517          	auipc	a0,0x4
    3680:	e0450513          	addi	a0,a0,-508 # 7480 <malloc+0x1a34>
    3684:	00002097          	auipc	ra,0x2
    3688:	30a080e7          	jalr	778(ra) # 598e <printf>
    exit(1);
    368c:	4505                	li	a0,1
    368e:	00002097          	auipc	ra,0x2
    3692:	f80080e7          	jalr	-128(ra) # 560e <exit>
    printf("%s: link dd/xx/ff dd/dd/xx succeeded!\n", s);
    3696:	85ca                	mv	a1,s2
    3698:	00004517          	auipc	a0,0x4
    369c:	e1050513          	addi	a0,a0,-496 # 74a8 <malloc+0x1a5c>
    36a0:	00002097          	auipc	ra,0x2
    36a4:	2ee080e7          	jalr	750(ra) # 598e <printf>
    exit(1);
    36a8:	4505                	li	a0,1
    36aa:	00002097          	auipc	ra,0x2
    36ae:	f64080e7          	jalr	-156(ra) # 560e <exit>
    printf("%s: link dd/ff dd/dd/ffff succeeded!\n", s);
    36b2:	85ca                	mv	a1,s2
    36b4:	00004517          	auipc	a0,0x4
    36b8:	e1c50513          	addi	a0,a0,-484 # 74d0 <malloc+0x1a84>
    36bc:	00002097          	auipc	ra,0x2
    36c0:	2d2080e7          	jalr	722(ra) # 598e <printf>
    exit(1);
    36c4:	4505                	li	a0,1
    36c6:	00002097          	auipc	ra,0x2
    36ca:	f48080e7          	jalr	-184(ra) # 560e <exit>
    printf("%s: mkdir dd/ff/ff succeeded!\n", s);
    36ce:	85ca                	mv	a1,s2
    36d0:	00004517          	auipc	a0,0x4
    36d4:	e2850513          	addi	a0,a0,-472 # 74f8 <malloc+0x1aac>
    36d8:	00002097          	auipc	ra,0x2
    36dc:	2b6080e7          	jalr	694(ra) # 598e <printf>
    exit(1);
    36e0:	4505                	li	a0,1
    36e2:	00002097          	auipc	ra,0x2
    36e6:	f2c080e7          	jalr	-212(ra) # 560e <exit>
    printf("%s: mkdir dd/xx/ff succeeded!\n", s);
    36ea:	85ca                	mv	a1,s2
    36ec:	00004517          	auipc	a0,0x4
    36f0:	e2c50513          	addi	a0,a0,-468 # 7518 <malloc+0x1acc>
    36f4:	00002097          	auipc	ra,0x2
    36f8:	29a080e7          	jalr	666(ra) # 598e <printf>
    exit(1);
    36fc:	4505                	li	a0,1
    36fe:	00002097          	auipc	ra,0x2
    3702:	f10080e7          	jalr	-240(ra) # 560e <exit>
    printf("%s: mkdir dd/dd/ffff succeeded!\n", s);
    3706:	85ca                	mv	a1,s2
    3708:	00004517          	auipc	a0,0x4
    370c:	e3050513          	addi	a0,a0,-464 # 7538 <malloc+0x1aec>
    3710:	00002097          	auipc	ra,0x2
    3714:	27e080e7          	jalr	638(ra) # 598e <printf>
    exit(1);
    3718:	4505                	li	a0,1
    371a:	00002097          	auipc	ra,0x2
    371e:	ef4080e7          	jalr	-268(ra) # 560e <exit>
    printf("%s: unlink dd/xx/ff succeeded!\n", s);
    3722:	85ca                	mv	a1,s2
    3724:	00004517          	auipc	a0,0x4
    3728:	e3c50513          	addi	a0,a0,-452 # 7560 <malloc+0x1b14>
    372c:	00002097          	auipc	ra,0x2
    3730:	262080e7          	jalr	610(ra) # 598e <printf>
    exit(1);
    3734:	4505                	li	a0,1
    3736:	00002097          	auipc	ra,0x2
    373a:	ed8080e7          	jalr	-296(ra) # 560e <exit>
    printf("%s: unlink dd/ff/ff succeeded!\n", s);
    373e:	85ca                	mv	a1,s2
    3740:	00004517          	auipc	a0,0x4
    3744:	e4050513          	addi	a0,a0,-448 # 7580 <malloc+0x1b34>
    3748:	00002097          	auipc	ra,0x2
    374c:	246080e7          	jalr	582(ra) # 598e <printf>
    exit(1);
    3750:	4505                	li	a0,1
    3752:	00002097          	auipc	ra,0x2
    3756:	ebc080e7          	jalr	-324(ra) # 560e <exit>
    printf("%s: chdir dd/ff succeeded!\n", s);
    375a:	85ca                	mv	a1,s2
    375c:	00004517          	auipc	a0,0x4
    3760:	e4450513          	addi	a0,a0,-444 # 75a0 <malloc+0x1b54>
    3764:	00002097          	auipc	ra,0x2
    3768:	22a080e7          	jalr	554(ra) # 598e <printf>
    exit(1);
    376c:	4505                	li	a0,1
    376e:	00002097          	auipc	ra,0x2
    3772:	ea0080e7          	jalr	-352(ra) # 560e <exit>
    printf("%s: chdir dd/xx succeeded!\n", s);
    3776:	85ca                	mv	a1,s2
    3778:	00004517          	auipc	a0,0x4
    377c:	e5050513          	addi	a0,a0,-432 # 75c8 <malloc+0x1b7c>
    3780:	00002097          	auipc	ra,0x2
    3784:	20e080e7          	jalr	526(ra) # 598e <printf>
    exit(1);
    3788:	4505                	li	a0,1
    378a:	00002097          	auipc	ra,0x2
    378e:	e84080e7          	jalr	-380(ra) # 560e <exit>
    printf("%s: unlink dd/dd/ff failed\n", s);
    3792:	85ca                	mv	a1,s2
    3794:	00004517          	auipc	a0,0x4
    3798:	acc50513          	addi	a0,a0,-1332 # 7260 <malloc+0x1814>
    379c:	00002097          	auipc	ra,0x2
    37a0:	1f2080e7          	jalr	498(ra) # 598e <printf>
    exit(1);
    37a4:	4505                	li	a0,1
    37a6:	00002097          	auipc	ra,0x2
    37aa:	e68080e7          	jalr	-408(ra) # 560e <exit>
    printf("%s: unlink dd/ff failed\n", s);
    37ae:	85ca                	mv	a1,s2
    37b0:	00004517          	auipc	a0,0x4
    37b4:	e3850513          	addi	a0,a0,-456 # 75e8 <malloc+0x1b9c>
    37b8:	00002097          	auipc	ra,0x2
    37bc:	1d6080e7          	jalr	470(ra) # 598e <printf>
    exit(1);
    37c0:	4505                	li	a0,1
    37c2:	00002097          	auipc	ra,0x2
    37c6:	e4c080e7          	jalr	-436(ra) # 560e <exit>
    printf("%s: unlink non-empty dd succeeded!\n", s);
    37ca:	85ca                	mv	a1,s2
    37cc:	00004517          	auipc	a0,0x4
    37d0:	e3c50513          	addi	a0,a0,-452 # 7608 <malloc+0x1bbc>
    37d4:	00002097          	auipc	ra,0x2
    37d8:	1ba080e7          	jalr	442(ra) # 598e <printf>
    exit(1);
    37dc:	4505                	li	a0,1
    37de:	00002097          	auipc	ra,0x2
    37e2:	e30080e7          	jalr	-464(ra) # 560e <exit>
    printf("%s: unlink dd/dd failed\n", s);
    37e6:	85ca                	mv	a1,s2
    37e8:	00004517          	auipc	a0,0x4
    37ec:	e5050513          	addi	a0,a0,-432 # 7638 <malloc+0x1bec>
    37f0:	00002097          	auipc	ra,0x2
    37f4:	19e080e7          	jalr	414(ra) # 598e <printf>
    exit(1);
    37f8:	4505                	li	a0,1
    37fa:	00002097          	auipc	ra,0x2
    37fe:	e14080e7          	jalr	-492(ra) # 560e <exit>
    printf("%s: unlink dd failed\n", s);
    3802:	85ca                	mv	a1,s2
    3804:	00004517          	auipc	a0,0x4
    3808:	e5450513          	addi	a0,a0,-428 # 7658 <malloc+0x1c0c>
    380c:	00002097          	auipc	ra,0x2
    3810:	182080e7          	jalr	386(ra) # 598e <printf>
    exit(1);
    3814:	4505                	li	a0,1
    3816:	00002097          	auipc	ra,0x2
    381a:	df8080e7          	jalr	-520(ra) # 560e <exit>

000000000000381e <rmdot>:
{
    381e:	1101                	addi	sp,sp,-32
    3820:	ec06                	sd	ra,24(sp)
    3822:	e822                	sd	s0,16(sp)
    3824:	e426                	sd	s1,8(sp)
    3826:	1000                	addi	s0,sp,32
    3828:	84aa                	mv	s1,a0
  if(mkdir("dots") != 0){
    382a:	00004517          	auipc	a0,0x4
    382e:	e4650513          	addi	a0,a0,-442 # 7670 <malloc+0x1c24>
    3832:	00002097          	auipc	ra,0x2
    3836:	e44080e7          	jalr	-444(ra) # 5676 <mkdir>
    383a:	e549                	bnez	a0,38c4 <rmdot+0xa6>
  if(chdir("dots") != 0){
    383c:	00004517          	auipc	a0,0x4
    3840:	e3450513          	addi	a0,a0,-460 # 7670 <malloc+0x1c24>
    3844:	00002097          	auipc	ra,0x2
    3848:	e3a080e7          	jalr	-454(ra) # 567e <chdir>
    384c:	e951                	bnez	a0,38e0 <rmdot+0xc2>
  if(unlink(".") == 0){
    384e:	00003517          	auipc	a0,0x3
    3852:	cd250513          	addi	a0,a0,-814 # 6520 <malloc+0xad4>
    3856:	00002097          	auipc	ra,0x2
    385a:	e08080e7          	jalr	-504(ra) # 565e <unlink>
    385e:	cd59                	beqz	a0,38fc <rmdot+0xde>
  if(unlink("..") == 0){
    3860:	00004517          	auipc	a0,0x4
    3864:	86850513          	addi	a0,a0,-1944 # 70c8 <malloc+0x167c>
    3868:	00002097          	auipc	ra,0x2
    386c:	df6080e7          	jalr	-522(ra) # 565e <unlink>
    3870:	c545                	beqz	a0,3918 <rmdot+0xfa>
  if(chdir("/") != 0){
    3872:	00003517          	auipc	a0,0x3
    3876:	7fe50513          	addi	a0,a0,2046 # 7070 <malloc+0x1624>
    387a:	00002097          	auipc	ra,0x2
    387e:	e04080e7          	jalr	-508(ra) # 567e <chdir>
    3882:	e94d                	bnez	a0,3934 <rmdot+0x116>
  if(unlink("dots/.") == 0){
    3884:	00004517          	auipc	a0,0x4
    3888:	e5450513          	addi	a0,a0,-428 # 76d8 <malloc+0x1c8c>
    388c:	00002097          	auipc	ra,0x2
    3890:	dd2080e7          	jalr	-558(ra) # 565e <unlink>
    3894:	cd55                	beqz	a0,3950 <rmdot+0x132>
  if(unlink("dots/..") == 0){
    3896:	00004517          	auipc	a0,0x4
    389a:	e6a50513          	addi	a0,a0,-406 # 7700 <malloc+0x1cb4>
    389e:	00002097          	auipc	ra,0x2
    38a2:	dc0080e7          	jalr	-576(ra) # 565e <unlink>
    38a6:	c179                	beqz	a0,396c <rmdot+0x14e>
  if(unlink("dots") != 0){
    38a8:	00004517          	auipc	a0,0x4
    38ac:	dc850513          	addi	a0,a0,-568 # 7670 <malloc+0x1c24>
    38b0:	00002097          	auipc	ra,0x2
    38b4:	dae080e7          	jalr	-594(ra) # 565e <unlink>
    38b8:	e961                	bnez	a0,3988 <rmdot+0x16a>
}
    38ba:	60e2                	ld	ra,24(sp)
    38bc:	6442                	ld	s0,16(sp)
    38be:	64a2                	ld	s1,8(sp)
    38c0:	6105                	addi	sp,sp,32
    38c2:	8082                	ret
    printf("%s: mkdir dots failed\n", s);
    38c4:	85a6                	mv	a1,s1
    38c6:	00004517          	auipc	a0,0x4
    38ca:	db250513          	addi	a0,a0,-590 # 7678 <malloc+0x1c2c>
    38ce:	00002097          	auipc	ra,0x2
    38d2:	0c0080e7          	jalr	192(ra) # 598e <printf>
    exit(1);
    38d6:	4505                	li	a0,1
    38d8:	00002097          	auipc	ra,0x2
    38dc:	d36080e7          	jalr	-714(ra) # 560e <exit>
    printf("%s: chdir dots failed\n", s);
    38e0:	85a6                	mv	a1,s1
    38e2:	00004517          	auipc	a0,0x4
    38e6:	dae50513          	addi	a0,a0,-594 # 7690 <malloc+0x1c44>
    38ea:	00002097          	auipc	ra,0x2
    38ee:	0a4080e7          	jalr	164(ra) # 598e <printf>
    exit(1);
    38f2:	4505                	li	a0,1
    38f4:	00002097          	auipc	ra,0x2
    38f8:	d1a080e7          	jalr	-742(ra) # 560e <exit>
    printf("%s: rm . worked!\n", s);
    38fc:	85a6                	mv	a1,s1
    38fe:	00004517          	auipc	a0,0x4
    3902:	daa50513          	addi	a0,a0,-598 # 76a8 <malloc+0x1c5c>
    3906:	00002097          	auipc	ra,0x2
    390a:	088080e7          	jalr	136(ra) # 598e <printf>
    exit(1);
    390e:	4505                	li	a0,1
    3910:	00002097          	auipc	ra,0x2
    3914:	cfe080e7          	jalr	-770(ra) # 560e <exit>
    printf("%s: rm .. worked!\n", s);
    3918:	85a6                	mv	a1,s1
    391a:	00004517          	auipc	a0,0x4
    391e:	da650513          	addi	a0,a0,-602 # 76c0 <malloc+0x1c74>
    3922:	00002097          	auipc	ra,0x2
    3926:	06c080e7          	jalr	108(ra) # 598e <printf>
    exit(1);
    392a:	4505                	li	a0,1
    392c:	00002097          	auipc	ra,0x2
    3930:	ce2080e7          	jalr	-798(ra) # 560e <exit>
    printf("%s: chdir / failed\n", s);
    3934:	85a6                	mv	a1,s1
    3936:	00003517          	auipc	a0,0x3
    393a:	74250513          	addi	a0,a0,1858 # 7078 <malloc+0x162c>
    393e:	00002097          	auipc	ra,0x2
    3942:	050080e7          	jalr	80(ra) # 598e <printf>
    exit(1);
    3946:	4505                	li	a0,1
    3948:	00002097          	auipc	ra,0x2
    394c:	cc6080e7          	jalr	-826(ra) # 560e <exit>
    printf("%s: unlink dots/. worked!\n", s);
    3950:	85a6                	mv	a1,s1
    3952:	00004517          	auipc	a0,0x4
    3956:	d8e50513          	addi	a0,a0,-626 # 76e0 <malloc+0x1c94>
    395a:	00002097          	auipc	ra,0x2
    395e:	034080e7          	jalr	52(ra) # 598e <printf>
    exit(1);
    3962:	4505                	li	a0,1
    3964:	00002097          	auipc	ra,0x2
    3968:	caa080e7          	jalr	-854(ra) # 560e <exit>
    printf("%s: unlink dots/.. worked!\n", s);
    396c:	85a6                	mv	a1,s1
    396e:	00004517          	auipc	a0,0x4
    3972:	d9a50513          	addi	a0,a0,-614 # 7708 <malloc+0x1cbc>
    3976:	00002097          	auipc	ra,0x2
    397a:	018080e7          	jalr	24(ra) # 598e <printf>
    exit(1);
    397e:	4505                	li	a0,1
    3980:	00002097          	auipc	ra,0x2
    3984:	c8e080e7          	jalr	-882(ra) # 560e <exit>
    printf("%s: unlink dots failed!\n", s);
    3988:	85a6                	mv	a1,s1
    398a:	00004517          	auipc	a0,0x4
    398e:	d9e50513          	addi	a0,a0,-610 # 7728 <malloc+0x1cdc>
    3992:	00002097          	auipc	ra,0x2
    3996:	ffc080e7          	jalr	-4(ra) # 598e <printf>
    exit(1);
    399a:	4505                	li	a0,1
    399c:	00002097          	auipc	ra,0x2
    39a0:	c72080e7          	jalr	-910(ra) # 560e <exit>

00000000000039a4 <dirfile>:
{
    39a4:	1101                	addi	sp,sp,-32
    39a6:	ec06                	sd	ra,24(sp)
    39a8:	e822                	sd	s0,16(sp)
    39aa:	e426                	sd	s1,8(sp)
    39ac:	e04a                	sd	s2,0(sp)
    39ae:	1000                	addi	s0,sp,32
    39b0:	892a                	mv	s2,a0
  fd = open("dirfile", O_CREATE);
    39b2:	20000593          	li	a1,512
    39b6:	00002517          	auipc	a0,0x2
    39ba:	47250513          	addi	a0,a0,1138 # 5e28 <malloc+0x3dc>
    39be:	00002097          	auipc	ra,0x2
    39c2:	c90080e7          	jalr	-880(ra) # 564e <open>
  if(fd < 0){
    39c6:	0e054d63          	bltz	a0,3ac0 <dirfile+0x11c>
  close(fd);
    39ca:	00002097          	auipc	ra,0x2
    39ce:	c6c080e7          	jalr	-916(ra) # 5636 <close>
  if(chdir("dirfile") == 0){
    39d2:	00002517          	auipc	a0,0x2
    39d6:	45650513          	addi	a0,a0,1110 # 5e28 <malloc+0x3dc>
    39da:	00002097          	auipc	ra,0x2
    39de:	ca4080e7          	jalr	-860(ra) # 567e <chdir>
    39e2:	cd6d                	beqz	a0,3adc <dirfile+0x138>
  fd = open("dirfile/xx", 0);
    39e4:	4581                	li	a1,0
    39e6:	00004517          	auipc	a0,0x4
    39ea:	da250513          	addi	a0,a0,-606 # 7788 <malloc+0x1d3c>
    39ee:	00002097          	auipc	ra,0x2
    39f2:	c60080e7          	jalr	-928(ra) # 564e <open>
  if(fd >= 0){
    39f6:	10055163          	bgez	a0,3af8 <dirfile+0x154>
  fd = open("dirfile/xx", O_CREATE);
    39fa:	20000593          	li	a1,512
    39fe:	00004517          	auipc	a0,0x4
    3a02:	d8a50513          	addi	a0,a0,-630 # 7788 <malloc+0x1d3c>
    3a06:	00002097          	auipc	ra,0x2
    3a0a:	c48080e7          	jalr	-952(ra) # 564e <open>
  if(fd >= 0){
    3a0e:	10055363          	bgez	a0,3b14 <dirfile+0x170>
  if(mkdir("dirfile/xx") == 0){
    3a12:	00004517          	auipc	a0,0x4
    3a16:	d7650513          	addi	a0,a0,-650 # 7788 <malloc+0x1d3c>
    3a1a:	00002097          	auipc	ra,0x2
    3a1e:	c5c080e7          	jalr	-932(ra) # 5676 <mkdir>
    3a22:	10050763          	beqz	a0,3b30 <dirfile+0x18c>
  if(unlink("dirfile/xx") == 0){
    3a26:	00004517          	auipc	a0,0x4
    3a2a:	d6250513          	addi	a0,a0,-670 # 7788 <malloc+0x1d3c>
    3a2e:	00002097          	auipc	ra,0x2
    3a32:	c30080e7          	jalr	-976(ra) # 565e <unlink>
    3a36:	10050b63          	beqz	a0,3b4c <dirfile+0x1a8>
  if(link("README", "dirfile/xx") == 0){
    3a3a:	00004597          	auipc	a1,0x4
    3a3e:	d4e58593          	addi	a1,a1,-690 # 7788 <malloc+0x1d3c>
    3a42:	00002517          	auipc	a0,0x2
    3a46:	5de50513          	addi	a0,a0,1502 # 6020 <malloc+0x5d4>
    3a4a:	00002097          	auipc	ra,0x2
    3a4e:	c24080e7          	jalr	-988(ra) # 566e <link>
    3a52:	10050b63          	beqz	a0,3b68 <dirfile+0x1c4>
  if(unlink("dirfile") != 0){
    3a56:	00002517          	auipc	a0,0x2
    3a5a:	3d250513          	addi	a0,a0,978 # 5e28 <malloc+0x3dc>
    3a5e:	00002097          	auipc	ra,0x2
    3a62:	c00080e7          	jalr	-1024(ra) # 565e <unlink>
    3a66:	10051f63          	bnez	a0,3b84 <dirfile+0x1e0>
  fd = open(".", O_RDWR);
    3a6a:	4589                	li	a1,2
    3a6c:	00003517          	auipc	a0,0x3
    3a70:	ab450513          	addi	a0,a0,-1356 # 6520 <malloc+0xad4>
    3a74:	00002097          	auipc	ra,0x2
    3a78:	bda080e7          	jalr	-1062(ra) # 564e <open>
  if(fd >= 0){
    3a7c:	12055263          	bgez	a0,3ba0 <dirfile+0x1fc>
  fd = open(".", 0);
    3a80:	4581                	li	a1,0
    3a82:	00003517          	auipc	a0,0x3
    3a86:	a9e50513          	addi	a0,a0,-1378 # 6520 <malloc+0xad4>
    3a8a:	00002097          	auipc	ra,0x2
    3a8e:	bc4080e7          	jalr	-1084(ra) # 564e <open>
    3a92:	84aa                	mv	s1,a0
  if(write(fd, "x", 1) > 0){
    3a94:	4605                	li	a2,1
    3a96:	00002597          	auipc	a1,0x2
    3a9a:	46258593          	addi	a1,a1,1122 # 5ef8 <malloc+0x4ac>
    3a9e:	00002097          	auipc	ra,0x2
    3aa2:	b90080e7          	jalr	-1136(ra) # 562e <write>
    3aa6:	10a04b63          	bgtz	a0,3bbc <dirfile+0x218>
  close(fd);
    3aaa:	8526                	mv	a0,s1
    3aac:	00002097          	auipc	ra,0x2
    3ab0:	b8a080e7          	jalr	-1142(ra) # 5636 <close>
}
    3ab4:	60e2                	ld	ra,24(sp)
    3ab6:	6442                	ld	s0,16(sp)
    3ab8:	64a2                	ld	s1,8(sp)
    3aba:	6902                	ld	s2,0(sp)
    3abc:	6105                	addi	sp,sp,32
    3abe:	8082                	ret
    printf("%s: create dirfile failed\n", s);
    3ac0:	85ca                	mv	a1,s2
    3ac2:	00004517          	auipc	a0,0x4
    3ac6:	c8650513          	addi	a0,a0,-890 # 7748 <malloc+0x1cfc>
    3aca:	00002097          	auipc	ra,0x2
    3ace:	ec4080e7          	jalr	-316(ra) # 598e <printf>
    exit(1);
    3ad2:	4505                	li	a0,1
    3ad4:	00002097          	auipc	ra,0x2
    3ad8:	b3a080e7          	jalr	-1222(ra) # 560e <exit>
    printf("%s: chdir dirfile succeeded!\n", s);
    3adc:	85ca                	mv	a1,s2
    3ade:	00004517          	auipc	a0,0x4
    3ae2:	c8a50513          	addi	a0,a0,-886 # 7768 <malloc+0x1d1c>
    3ae6:	00002097          	auipc	ra,0x2
    3aea:	ea8080e7          	jalr	-344(ra) # 598e <printf>
    exit(1);
    3aee:	4505                	li	a0,1
    3af0:	00002097          	auipc	ra,0x2
    3af4:	b1e080e7          	jalr	-1250(ra) # 560e <exit>
    printf("%s: create dirfile/xx succeeded!\n", s);
    3af8:	85ca                	mv	a1,s2
    3afa:	00004517          	auipc	a0,0x4
    3afe:	c9e50513          	addi	a0,a0,-866 # 7798 <malloc+0x1d4c>
    3b02:	00002097          	auipc	ra,0x2
    3b06:	e8c080e7          	jalr	-372(ra) # 598e <printf>
    exit(1);
    3b0a:	4505                	li	a0,1
    3b0c:	00002097          	auipc	ra,0x2
    3b10:	b02080e7          	jalr	-1278(ra) # 560e <exit>
    printf("%s: create dirfile/xx succeeded!\n", s);
    3b14:	85ca                	mv	a1,s2
    3b16:	00004517          	auipc	a0,0x4
    3b1a:	c8250513          	addi	a0,a0,-894 # 7798 <malloc+0x1d4c>
    3b1e:	00002097          	auipc	ra,0x2
    3b22:	e70080e7          	jalr	-400(ra) # 598e <printf>
    exit(1);
    3b26:	4505                	li	a0,1
    3b28:	00002097          	auipc	ra,0x2
    3b2c:	ae6080e7          	jalr	-1306(ra) # 560e <exit>
    printf("%s: mkdir dirfile/xx succeeded!\n", s);
    3b30:	85ca                	mv	a1,s2
    3b32:	00004517          	auipc	a0,0x4
    3b36:	c8e50513          	addi	a0,a0,-882 # 77c0 <malloc+0x1d74>
    3b3a:	00002097          	auipc	ra,0x2
    3b3e:	e54080e7          	jalr	-428(ra) # 598e <printf>
    exit(1);
    3b42:	4505                	li	a0,1
    3b44:	00002097          	auipc	ra,0x2
    3b48:	aca080e7          	jalr	-1334(ra) # 560e <exit>
    printf("%s: unlink dirfile/xx succeeded!\n", s);
    3b4c:	85ca                	mv	a1,s2
    3b4e:	00004517          	auipc	a0,0x4
    3b52:	c9a50513          	addi	a0,a0,-870 # 77e8 <malloc+0x1d9c>
    3b56:	00002097          	auipc	ra,0x2
    3b5a:	e38080e7          	jalr	-456(ra) # 598e <printf>
    exit(1);
    3b5e:	4505                	li	a0,1
    3b60:	00002097          	auipc	ra,0x2
    3b64:	aae080e7          	jalr	-1362(ra) # 560e <exit>
    printf("%s: link to dirfile/xx succeeded!\n", s);
    3b68:	85ca                	mv	a1,s2
    3b6a:	00004517          	auipc	a0,0x4
    3b6e:	ca650513          	addi	a0,a0,-858 # 7810 <malloc+0x1dc4>
    3b72:	00002097          	auipc	ra,0x2
    3b76:	e1c080e7          	jalr	-484(ra) # 598e <printf>
    exit(1);
    3b7a:	4505                	li	a0,1
    3b7c:	00002097          	auipc	ra,0x2
    3b80:	a92080e7          	jalr	-1390(ra) # 560e <exit>
    printf("%s: unlink dirfile failed!\n", s);
    3b84:	85ca                	mv	a1,s2
    3b86:	00004517          	auipc	a0,0x4
    3b8a:	cb250513          	addi	a0,a0,-846 # 7838 <malloc+0x1dec>
    3b8e:	00002097          	auipc	ra,0x2
    3b92:	e00080e7          	jalr	-512(ra) # 598e <printf>
    exit(1);
    3b96:	4505                	li	a0,1
    3b98:	00002097          	auipc	ra,0x2
    3b9c:	a76080e7          	jalr	-1418(ra) # 560e <exit>
    printf("%s: open . for writing succeeded!\n", s);
    3ba0:	85ca                	mv	a1,s2
    3ba2:	00004517          	auipc	a0,0x4
    3ba6:	cb650513          	addi	a0,a0,-842 # 7858 <malloc+0x1e0c>
    3baa:	00002097          	auipc	ra,0x2
    3bae:	de4080e7          	jalr	-540(ra) # 598e <printf>
    exit(1);
    3bb2:	4505                	li	a0,1
    3bb4:	00002097          	auipc	ra,0x2
    3bb8:	a5a080e7          	jalr	-1446(ra) # 560e <exit>
    printf("%s: write . succeeded!\n", s);
    3bbc:	85ca                	mv	a1,s2
    3bbe:	00004517          	auipc	a0,0x4
    3bc2:	cc250513          	addi	a0,a0,-830 # 7880 <malloc+0x1e34>
    3bc6:	00002097          	auipc	ra,0x2
    3bca:	dc8080e7          	jalr	-568(ra) # 598e <printf>
    exit(1);
    3bce:	4505                	li	a0,1
    3bd0:	00002097          	auipc	ra,0x2
    3bd4:	a3e080e7          	jalr	-1474(ra) # 560e <exit>

0000000000003bd8 <iref>:
{
    3bd8:	7139                	addi	sp,sp,-64
    3bda:	fc06                	sd	ra,56(sp)
    3bdc:	f822                	sd	s0,48(sp)
    3bde:	f426                	sd	s1,40(sp)
    3be0:	f04a                	sd	s2,32(sp)
    3be2:	ec4e                	sd	s3,24(sp)
    3be4:	e852                	sd	s4,16(sp)
    3be6:	e456                	sd	s5,8(sp)
    3be8:	e05a                	sd	s6,0(sp)
    3bea:	0080                	addi	s0,sp,64
    3bec:	8b2a                	mv	s6,a0
    3bee:	03300913          	li	s2,51
    if(mkdir("irefd") != 0){
    3bf2:	00004a17          	auipc	s4,0x4
    3bf6:	ca6a0a13          	addi	s4,s4,-858 # 7898 <malloc+0x1e4c>
    mkdir("");
    3bfa:	00003497          	auipc	s1,0x3
    3bfe:	7ae48493          	addi	s1,s1,1966 # 73a8 <malloc+0x195c>
    link("README", "");
    3c02:	00002a97          	auipc	s5,0x2
    3c06:	41ea8a93          	addi	s5,s5,1054 # 6020 <malloc+0x5d4>
    fd = open("xx", O_CREATE);
    3c0a:	00004997          	auipc	s3,0x4
    3c0e:	b8698993          	addi	s3,s3,-1146 # 7790 <malloc+0x1d44>
    3c12:	a891                	j	3c66 <iref+0x8e>
      printf("%s: mkdir irefd failed\n", s);
    3c14:	85da                	mv	a1,s6
    3c16:	00004517          	auipc	a0,0x4
    3c1a:	c8a50513          	addi	a0,a0,-886 # 78a0 <malloc+0x1e54>
    3c1e:	00002097          	auipc	ra,0x2
    3c22:	d70080e7          	jalr	-656(ra) # 598e <printf>
      exit(1);
    3c26:	4505                	li	a0,1
    3c28:	00002097          	auipc	ra,0x2
    3c2c:	9e6080e7          	jalr	-1562(ra) # 560e <exit>
      printf("%s: chdir irefd failed\n", s);
    3c30:	85da                	mv	a1,s6
    3c32:	00004517          	auipc	a0,0x4
    3c36:	c8650513          	addi	a0,a0,-890 # 78b8 <malloc+0x1e6c>
    3c3a:	00002097          	auipc	ra,0x2
    3c3e:	d54080e7          	jalr	-684(ra) # 598e <printf>
      exit(1);
    3c42:	4505                	li	a0,1
    3c44:	00002097          	auipc	ra,0x2
    3c48:	9ca080e7          	jalr	-1590(ra) # 560e <exit>
      close(fd);
    3c4c:	00002097          	auipc	ra,0x2
    3c50:	9ea080e7          	jalr	-1558(ra) # 5636 <close>
    3c54:	a889                	j	3ca6 <iref+0xce>
    unlink("xx");
    3c56:	854e                	mv	a0,s3
    3c58:	00002097          	auipc	ra,0x2
    3c5c:	a06080e7          	jalr	-1530(ra) # 565e <unlink>
  for(i = 0; i < NINODE + 1; i++){
    3c60:	397d                	addiw	s2,s2,-1
    3c62:	06090063          	beqz	s2,3cc2 <iref+0xea>
    if(mkdir("irefd") != 0){
    3c66:	8552                	mv	a0,s4
    3c68:	00002097          	auipc	ra,0x2
    3c6c:	a0e080e7          	jalr	-1522(ra) # 5676 <mkdir>
    3c70:	f155                	bnez	a0,3c14 <iref+0x3c>
    if(chdir("irefd") != 0){
    3c72:	8552                	mv	a0,s4
    3c74:	00002097          	auipc	ra,0x2
    3c78:	a0a080e7          	jalr	-1526(ra) # 567e <chdir>
    3c7c:	f955                	bnez	a0,3c30 <iref+0x58>
    mkdir("");
    3c7e:	8526                	mv	a0,s1
    3c80:	00002097          	auipc	ra,0x2
    3c84:	9f6080e7          	jalr	-1546(ra) # 5676 <mkdir>
    link("README", "");
    3c88:	85a6                	mv	a1,s1
    3c8a:	8556                	mv	a0,s5
    3c8c:	00002097          	auipc	ra,0x2
    3c90:	9e2080e7          	jalr	-1566(ra) # 566e <link>
    fd = open("", O_CREATE);
    3c94:	20000593          	li	a1,512
    3c98:	8526                	mv	a0,s1
    3c9a:	00002097          	auipc	ra,0x2
    3c9e:	9b4080e7          	jalr	-1612(ra) # 564e <open>
    if(fd >= 0)
    3ca2:	fa0555e3          	bgez	a0,3c4c <iref+0x74>
    fd = open("xx", O_CREATE);
    3ca6:	20000593          	li	a1,512
    3caa:	854e                	mv	a0,s3
    3cac:	00002097          	auipc	ra,0x2
    3cb0:	9a2080e7          	jalr	-1630(ra) # 564e <open>
    if(fd >= 0)
    3cb4:	fa0541e3          	bltz	a0,3c56 <iref+0x7e>
      close(fd);
    3cb8:	00002097          	auipc	ra,0x2
    3cbc:	97e080e7          	jalr	-1666(ra) # 5636 <close>
    3cc0:	bf59                	j	3c56 <iref+0x7e>
    3cc2:	03300493          	li	s1,51
    chdir("..");
    3cc6:	00003997          	auipc	s3,0x3
    3cca:	40298993          	addi	s3,s3,1026 # 70c8 <malloc+0x167c>
    unlink("irefd");
    3cce:	00004917          	auipc	s2,0x4
    3cd2:	bca90913          	addi	s2,s2,-1078 # 7898 <malloc+0x1e4c>
    chdir("..");
    3cd6:	854e                	mv	a0,s3
    3cd8:	00002097          	auipc	ra,0x2
    3cdc:	9a6080e7          	jalr	-1626(ra) # 567e <chdir>
    unlink("irefd");
    3ce0:	854a                	mv	a0,s2
    3ce2:	00002097          	auipc	ra,0x2
    3ce6:	97c080e7          	jalr	-1668(ra) # 565e <unlink>
  for(i = 0; i < NINODE + 1; i++){
    3cea:	34fd                	addiw	s1,s1,-1
    3cec:	f4ed                	bnez	s1,3cd6 <iref+0xfe>
  chdir("/");
    3cee:	00003517          	auipc	a0,0x3
    3cf2:	38250513          	addi	a0,a0,898 # 7070 <malloc+0x1624>
    3cf6:	00002097          	auipc	ra,0x2
    3cfa:	988080e7          	jalr	-1656(ra) # 567e <chdir>
}
    3cfe:	70e2                	ld	ra,56(sp)
    3d00:	7442                	ld	s0,48(sp)
    3d02:	74a2                	ld	s1,40(sp)
    3d04:	7902                	ld	s2,32(sp)
    3d06:	69e2                	ld	s3,24(sp)
    3d08:	6a42                	ld	s4,16(sp)
    3d0a:	6aa2                	ld	s5,8(sp)
    3d0c:	6b02                	ld	s6,0(sp)
    3d0e:	6121                	addi	sp,sp,64
    3d10:	8082                	ret

0000000000003d12 <openiputtest>:
{
    3d12:	7179                	addi	sp,sp,-48
    3d14:	f406                	sd	ra,40(sp)
    3d16:	f022                	sd	s0,32(sp)
    3d18:	ec26                	sd	s1,24(sp)
    3d1a:	1800                	addi	s0,sp,48
    3d1c:	84aa                	mv	s1,a0
  if(mkdir("oidir") < 0){
    3d1e:	00004517          	auipc	a0,0x4
    3d22:	bb250513          	addi	a0,a0,-1102 # 78d0 <malloc+0x1e84>
    3d26:	00002097          	auipc	ra,0x2
    3d2a:	950080e7          	jalr	-1712(ra) # 5676 <mkdir>
    3d2e:	04054263          	bltz	a0,3d72 <openiputtest+0x60>
  pid = fork();
    3d32:	00002097          	auipc	ra,0x2
    3d36:	8d4080e7          	jalr	-1836(ra) # 5606 <fork>
  if(pid < 0){
    3d3a:	04054a63          	bltz	a0,3d8e <openiputtest+0x7c>
  if(pid == 0){
    3d3e:	e93d                	bnez	a0,3db4 <openiputtest+0xa2>
    int fd = open("oidir", O_RDWR);
    3d40:	4589                	li	a1,2
    3d42:	00004517          	auipc	a0,0x4
    3d46:	b8e50513          	addi	a0,a0,-1138 # 78d0 <malloc+0x1e84>
    3d4a:	00002097          	auipc	ra,0x2
    3d4e:	904080e7          	jalr	-1788(ra) # 564e <open>
    if(fd >= 0){
    3d52:	04054c63          	bltz	a0,3daa <openiputtest+0x98>
      printf("%s: open directory for write succeeded\n", s);
    3d56:	85a6                	mv	a1,s1
    3d58:	00004517          	auipc	a0,0x4
    3d5c:	b9850513          	addi	a0,a0,-1128 # 78f0 <malloc+0x1ea4>
    3d60:	00002097          	auipc	ra,0x2
    3d64:	c2e080e7          	jalr	-978(ra) # 598e <printf>
      exit(1);
    3d68:	4505                	li	a0,1
    3d6a:	00002097          	auipc	ra,0x2
    3d6e:	8a4080e7          	jalr	-1884(ra) # 560e <exit>
    printf("%s: mkdir oidir failed\n", s);
    3d72:	85a6                	mv	a1,s1
    3d74:	00004517          	auipc	a0,0x4
    3d78:	b6450513          	addi	a0,a0,-1180 # 78d8 <malloc+0x1e8c>
    3d7c:	00002097          	auipc	ra,0x2
    3d80:	c12080e7          	jalr	-1006(ra) # 598e <printf>
    exit(1);
    3d84:	4505                	li	a0,1
    3d86:	00002097          	auipc	ra,0x2
    3d8a:	888080e7          	jalr	-1912(ra) # 560e <exit>
    printf("%s: fork failed\n", s);
    3d8e:	85a6                	mv	a1,s1
    3d90:	00003517          	auipc	a0,0x3
    3d94:	93050513          	addi	a0,a0,-1744 # 66c0 <malloc+0xc74>
    3d98:	00002097          	auipc	ra,0x2
    3d9c:	bf6080e7          	jalr	-1034(ra) # 598e <printf>
    exit(1);
    3da0:	4505                	li	a0,1
    3da2:	00002097          	auipc	ra,0x2
    3da6:	86c080e7          	jalr	-1940(ra) # 560e <exit>
    exit(0);
    3daa:	4501                	li	a0,0
    3dac:	00002097          	auipc	ra,0x2
    3db0:	862080e7          	jalr	-1950(ra) # 560e <exit>
  sleep(1);
    3db4:	4505                	li	a0,1
    3db6:	00002097          	auipc	ra,0x2
    3dba:	8e8080e7          	jalr	-1816(ra) # 569e <sleep>
  if(unlink("oidir") != 0){
    3dbe:	00004517          	auipc	a0,0x4
    3dc2:	b1250513          	addi	a0,a0,-1262 # 78d0 <malloc+0x1e84>
    3dc6:	00002097          	auipc	ra,0x2
    3dca:	898080e7          	jalr	-1896(ra) # 565e <unlink>
    3dce:	cd19                	beqz	a0,3dec <openiputtest+0xda>
    printf("%s: unlink failed\n", s);
    3dd0:	85a6                	mv	a1,s1
    3dd2:	00003517          	auipc	a0,0x3
    3dd6:	ade50513          	addi	a0,a0,-1314 # 68b0 <malloc+0xe64>
    3dda:	00002097          	auipc	ra,0x2
    3dde:	bb4080e7          	jalr	-1100(ra) # 598e <printf>
    exit(1);
    3de2:	4505                	li	a0,1
    3de4:	00002097          	auipc	ra,0x2
    3de8:	82a080e7          	jalr	-2006(ra) # 560e <exit>
  wait(&xstatus);
    3dec:	fdc40513          	addi	a0,s0,-36
    3df0:	00002097          	auipc	ra,0x2
    3df4:	826080e7          	jalr	-2010(ra) # 5616 <wait>
  exit(xstatus);
    3df8:	fdc42503          	lw	a0,-36(s0)
    3dfc:	00002097          	auipc	ra,0x2
    3e00:	812080e7          	jalr	-2030(ra) # 560e <exit>

0000000000003e04 <forkforkfork>:
{
    3e04:	1101                	addi	sp,sp,-32
    3e06:	ec06                	sd	ra,24(sp)
    3e08:	e822                	sd	s0,16(sp)
    3e0a:	e426                	sd	s1,8(sp)
    3e0c:	1000                	addi	s0,sp,32
    3e0e:	84aa                	mv	s1,a0
  unlink("stopforking");
    3e10:	00004517          	auipc	a0,0x4
    3e14:	b0850513          	addi	a0,a0,-1272 # 7918 <malloc+0x1ecc>
    3e18:	00002097          	auipc	ra,0x2
    3e1c:	846080e7          	jalr	-1978(ra) # 565e <unlink>
  int pid = fork();
    3e20:	00001097          	auipc	ra,0x1
    3e24:	7e6080e7          	jalr	2022(ra) # 5606 <fork>
  if(pid < 0){
    3e28:	04054563          	bltz	a0,3e72 <forkforkfork+0x6e>
  if(pid == 0){
    3e2c:	c12d                	beqz	a0,3e8e <forkforkfork+0x8a>
  sleep(20); // two seconds
    3e2e:	4551                	li	a0,20
    3e30:	00002097          	auipc	ra,0x2
    3e34:	86e080e7          	jalr	-1938(ra) # 569e <sleep>
  close(open("stopforking", O_CREATE|O_RDWR));
    3e38:	20200593          	li	a1,514
    3e3c:	00004517          	auipc	a0,0x4
    3e40:	adc50513          	addi	a0,a0,-1316 # 7918 <malloc+0x1ecc>
    3e44:	00002097          	auipc	ra,0x2
    3e48:	80a080e7          	jalr	-2038(ra) # 564e <open>
    3e4c:	00001097          	auipc	ra,0x1
    3e50:	7ea080e7          	jalr	2026(ra) # 5636 <close>
  wait(0);
    3e54:	4501                	li	a0,0
    3e56:	00001097          	auipc	ra,0x1
    3e5a:	7c0080e7          	jalr	1984(ra) # 5616 <wait>
  sleep(10); // one second
    3e5e:	4529                	li	a0,10
    3e60:	00002097          	auipc	ra,0x2
    3e64:	83e080e7          	jalr	-1986(ra) # 569e <sleep>
}
    3e68:	60e2                	ld	ra,24(sp)
    3e6a:	6442                	ld	s0,16(sp)
    3e6c:	64a2                	ld	s1,8(sp)
    3e6e:	6105                	addi	sp,sp,32
    3e70:	8082                	ret
    printf("%s: fork failed", s);
    3e72:	85a6                	mv	a1,s1
    3e74:	00003517          	auipc	a0,0x3
    3e78:	a0c50513          	addi	a0,a0,-1524 # 6880 <malloc+0xe34>
    3e7c:	00002097          	auipc	ra,0x2
    3e80:	b12080e7          	jalr	-1262(ra) # 598e <printf>
    exit(1);
    3e84:	4505                	li	a0,1
    3e86:	00001097          	auipc	ra,0x1
    3e8a:	788080e7          	jalr	1928(ra) # 560e <exit>
      int fd = open("stopforking", 0);
    3e8e:	00004497          	auipc	s1,0x4
    3e92:	a8a48493          	addi	s1,s1,-1398 # 7918 <malloc+0x1ecc>
    3e96:	4581                	li	a1,0
    3e98:	8526                	mv	a0,s1
    3e9a:	00001097          	auipc	ra,0x1
    3e9e:	7b4080e7          	jalr	1972(ra) # 564e <open>
      if(fd >= 0){
    3ea2:	02055463          	bgez	a0,3eca <forkforkfork+0xc6>
      if(fork() < 0){
    3ea6:	00001097          	auipc	ra,0x1
    3eaa:	760080e7          	jalr	1888(ra) # 5606 <fork>
    3eae:	fe0554e3          	bgez	a0,3e96 <forkforkfork+0x92>
        close(open("stopforking", O_CREATE|O_RDWR));
    3eb2:	20200593          	li	a1,514
    3eb6:	8526                	mv	a0,s1
    3eb8:	00001097          	auipc	ra,0x1
    3ebc:	796080e7          	jalr	1942(ra) # 564e <open>
    3ec0:	00001097          	auipc	ra,0x1
    3ec4:	776080e7          	jalr	1910(ra) # 5636 <close>
    3ec8:	b7f9                	j	3e96 <forkforkfork+0x92>
        exit(0);
    3eca:	4501                	li	a0,0
    3ecc:	00001097          	auipc	ra,0x1
    3ed0:	742080e7          	jalr	1858(ra) # 560e <exit>

0000000000003ed4 <preempt>:
{
    3ed4:	7139                	addi	sp,sp,-64
    3ed6:	fc06                	sd	ra,56(sp)
    3ed8:	f822                	sd	s0,48(sp)
    3eda:	f426                	sd	s1,40(sp)
    3edc:	f04a                	sd	s2,32(sp)
    3ede:	ec4e                	sd	s3,24(sp)
    3ee0:	e852                	sd	s4,16(sp)
    3ee2:	0080                	addi	s0,sp,64
    3ee4:	892a                	mv	s2,a0
  pid1 = fork();
    3ee6:	00001097          	auipc	ra,0x1
    3eea:	720080e7          	jalr	1824(ra) # 5606 <fork>
  if(pid1 < 0) {
    3eee:	00054563          	bltz	a0,3ef8 <preempt+0x24>
    3ef2:	84aa                	mv	s1,a0
  if(pid1 == 0)
    3ef4:	e105                	bnez	a0,3f14 <preempt+0x40>
    for(;;)
    3ef6:	a001                	j	3ef6 <preempt+0x22>
    printf("%s: fork failed", s);
    3ef8:	85ca                	mv	a1,s2
    3efa:	00003517          	auipc	a0,0x3
    3efe:	98650513          	addi	a0,a0,-1658 # 6880 <malloc+0xe34>
    3f02:	00002097          	auipc	ra,0x2
    3f06:	a8c080e7          	jalr	-1396(ra) # 598e <printf>
    exit(1);
    3f0a:	4505                	li	a0,1
    3f0c:	00001097          	auipc	ra,0x1
    3f10:	702080e7          	jalr	1794(ra) # 560e <exit>
  pid2 = fork();
    3f14:	00001097          	auipc	ra,0x1
    3f18:	6f2080e7          	jalr	1778(ra) # 5606 <fork>
    3f1c:	89aa                	mv	s3,a0
  if(pid2 < 0) {
    3f1e:	00054463          	bltz	a0,3f26 <preempt+0x52>
  if(pid2 == 0)
    3f22:	e105                	bnez	a0,3f42 <preempt+0x6e>
    for(;;)
    3f24:	a001                	j	3f24 <preempt+0x50>
    printf("%s: fork failed\n", s);
    3f26:	85ca                	mv	a1,s2
    3f28:	00002517          	auipc	a0,0x2
    3f2c:	79850513          	addi	a0,a0,1944 # 66c0 <malloc+0xc74>
    3f30:	00002097          	auipc	ra,0x2
    3f34:	a5e080e7          	jalr	-1442(ra) # 598e <printf>
    exit(1);
    3f38:	4505                	li	a0,1
    3f3a:	00001097          	auipc	ra,0x1
    3f3e:	6d4080e7          	jalr	1748(ra) # 560e <exit>
  pipe(pfds);
    3f42:	fc840513          	addi	a0,s0,-56
    3f46:	00001097          	auipc	ra,0x1
    3f4a:	6d8080e7          	jalr	1752(ra) # 561e <pipe>
  pid3 = fork();
    3f4e:	00001097          	auipc	ra,0x1
    3f52:	6b8080e7          	jalr	1720(ra) # 5606 <fork>
    3f56:	8a2a                	mv	s4,a0
  if(pid3 < 0) {
    3f58:	02054e63          	bltz	a0,3f94 <preempt+0xc0>
  if(pid3 == 0){
    3f5c:	e525                	bnez	a0,3fc4 <preempt+0xf0>
    close(pfds[0]);
    3f5e:	fc842503          	lw	a0,-56(s0)
    3f62:	00001097          	auipc	ra,0x1
    3f66:	6d4080e7          	jalr	1748(ra) # 5636 <close>
    if(write(pfds[1], "x", 1) != 1)
    3f6a:	4605                	li	a2,1
    3f6c:	00002597          	auipc	a1,0x2
    3f70:	f8c58593          	addi	a1,a1,-116 # 5ef8 <malloc+0x4ac>
    3f74:	fcc42503          	lw	a0,-52(s0)
    3f78:	00001097          	auipc	ra,0x1
    3f7c:	6b6080e7          	jalr	1718(ra) # 562e <write>
    3f80:	4785                	li	a5,1
    3f82:	02f51763          	bne	a0,a5,3fb0 <preempt+0xdc>
    close(pfds[1]);
    3f86:	fcc42503          	lw	a0,-52(s0)
    3f8a:	00001097          	auipc	ra,0x1
    3f8e:	6ac080e7          	jalr	1708(ra) # 5636 <close>
    for(;;)
    3f92:	a001                	j	3f92 <preempt+0xbe>
     printf("%s: fork failed\n", s);
    3f94:	85ca                	mv	a1,s2
    3f96:	00002517          	auipc	a0,0x2
    3f9a:	72a50513          	addi	a0,a0,1834 # 66c0 <malloc+0xc74>
    3f9e:	00002097          	auipc	ra,0x2
    3fa2:	9f0080e7          	jalr	-1552(ra) # 598e <printf>
     exit(1);
    3fa6:	4505                	li	a0,1
    3fa8:	00001097          	auipc	ra,0x1
    3fac:	666080e7          	jalr	1638(ra) # 560e <exit>
      printf("%s: preempt write error", s);
    3fb0:	85ca                	mv	a1,s2
    3fb2:	00004517          	auipc	a0,0x4
    3fb6:	97650513          	addi	a0,a0,-1674 # 7928 <malloc+0x1edc>
    3fba:	00002097          	auipc	ra,0x2
    3fbe:	9d4080e7          	jalr	-1580(ra) # 598e <printf>
    3fc2:	b7d1                	j	3f86 <preempt+0xb2>
  close(pfds[1]);
    3fc4:	fcc42503          	lw	a0,-52(s0)
    3fc8:	00001097          	auipc	ra,0x1
    3fcc:	66e080e7          	jalr	1646(ra) # 5636 <close>
  if(read(pfds[0], buf, sizeof(buf)) != 1){
    3fd0:	660d                	lui	a2,0x3
    3fd2:	00008597          	auipc	a1,0x8
    3fd6:	ace58593          	addi	a1,a1,-1330 # baa0 <buf>
    3fda:	fc842503          	lw	a0,-56(s0)
    3fde:	00001097          	auipc	ra,0x1
    3fe2:	648080e7          	jalr	1608(ra) # 5626 <read>
    3fe6:	4785                	li	a5,1
    3fe8:	02f50363          	beq	a0,a5,400e <preempt+0x13a>
    printf("%s: preempt read error", s);
    3fec:	85ca                	mv	a1,s2
    3fee:	00004517          	auipc	a0,0x4
    3ff2:	95250513          	addi	a0,a0,-1710 # 7940 <malloc+0x1ef4>
    3ff6:	00002097          	auipc	ra,0x2
    3ffa:	998080e7          	jalr	-1640(ra) # 598e <printf>
}
    3ffe:	70e2                	ld	ra,56(sp)
    4000:	7442                	ld	s0,48(sp)
    4002:	74a2                	ld	s1,40(sp)
    4004:	7902                	ld	s2,32(sp)
    4006:	69e2                	ld	s3,24(sp)
    4008:	6a42                	ld	s4,16(sp)
    400a:	6121                	addi	sp,sp,64
    400c:	8082                	ret
  close(pfds[0]);
    400e:	fc842503          	lw	a0,-56(s0)
    4012:	00001097          	auipc	ra,0x1
    4016:	624080e7          	jalr	1572(ra) # 5636 <close>
  printf("kill... ");
    401a:	00004517          	auipc	a0,0x4
    401e:	93e50513          	addi	a0,a0,-1730 # 7958 <malloc+0x1f0c>
    4022:	00002097          	auipc	ra,0x2
    4026:	96c080e7          	jalr	-1684(ra) # 598e <printf>
  kill(pid1);
    402a:	8526                	mv	a0,s1
    402c:	00001097          	auipc	ra,0x1
    4030:	612080e7          	jalr	1554(ra) # 563e <kill>
  kill(pid2);
    4034:	854e                	mv	a0,s3
    4036:	00001097          	auipc	ra,0x1
    403a:	608080e7          	jalr	1544(ra) # 563e <kill>
  kill(pid3);
    403e:	8552                	mv	a0,s4
    4040:	00001097          	auipc	ra,0x1
    4044:	5fe080e7          	jalr	1534(ra) # 563e <kill>
  printf("wait... ");
    4048:	00004517          	auipc	a0,0x4
    404c:	92050513          	addi	a0,a0,-1760 # 7968 <malloc+0x1f1c>
    4050:	00002097          	auipc	ra,0x2
    4054:	93e080e7          	jalr	-1730(ra) # 598e <printf>
  wait(0);
    4058:	4501                	li	a0,0
    405a:	00001097          	auipc	ra,0x1
    405e:	5bc080e7          	jalr	1468(ra) # 5616 <wait>
  wait(0);
    4062:	4501                	li	a0,0
    4064:	00001097          	auipc	ra,0x1
    4068:	5b2080e7          	jalr	1458(ra) # 5616 <wait>
  wait(0);
    406c:	4501                	li	a0,0
    406e:	00001097          	auipc	ra,0x1
    4072:	5a8080e7          	jalr	1448(ra) # 5616 <wait>
    4076:	b761                	j	3ffe <preempt+0x12a>

0000000000004078 <sbrkfail>:
{
    4078:	7119                	addi	sp,sp,-128
    407a:	fc86                	sd	ra,120(sp)
    407c:	f8a2                	sd	s0,112(sp)
    407e:	f4a6                	sd	s1,104(sp)
    4080:	f0ca                	sd	s2,96(sp)
    4082:	ecce                	sd	s3,88(sp)
    4084:	e8d2                	sd	s4,80(sp)
    4086:	e4d6                	sd	s5,72(sp)
    4088:	0100                	addi	s0,sp,128
    408a:	8aaa                	mv	s5,a0
  if(pipe(fds) != 0){
    408c:	fb040513          	addi	a0,s0,-80
    4090:	00001097          	auipc	ra,0x1
    4094:	58e080e7          	jalr	1422(ra) # 561e <pipe>
    4098:	e901                	bnez	a0,40a8 <sbrkfail+0x30>
    409a:	f8040493          	addi	s1,s0,-128
    409e:	fa840993          	addi	s3,s0,-88
    40a2:	8926                	mv	s2,s1
    if(pids[i] != -1)
    40a4:	5a7d                	li	s4,-1
    40a6:	a085                	j	4106 <sbrkfail+0x8e>
    printf("%s: pipe() failed\n", s);
    40a8:	85d6                	mv	a1,s5
    40aa:	00002517          	auipc	a0,0x2
    40ae:	71e50513          	addi	a0,a0,1822 # 67c8 <malloc+0xd7c>
    40b2:	00002097          	auipc	ra,0x2
    40b6:	8dc080e7          	jalr	-1828(ra) # 598e <printf>
    exit(1);
    40ba:	4505                	li	a0,1
    40bc:	00001097          	auipc	ra,0x1
    40c0:	552080e7          	jalr	1362(ra) # 560e <exit>
      sbrk(BIG - (uint64)sbrk(0));
    40c4:	00001097          	auipc	ra,0x1
    40c8:	5d2080e7          	jalr	1490(ra) # 5696 <sbrk>
    40cc:	064007b7          	lui	a5,0x6400
    40d0:	40a7853b          	subw	a0,a5,a0
    40d4:	00001097          	auipc	ra,0x1
    40d8:	5c2080e7          	jalr	1474(ra) # 5696 <sbrk>
      write(fds[1], "x", 1);
    40dc:	4605                	li	a2,1
    40de:	00002597          	auipc	a1,0x2
    40e2:	e1a58593          	addi	a1,a1,-486 # 5ef8 <malloc+0x4ac>
    40e6:	fb442503          	lw	a0,-76(s0)
    40ea:	00001097          	auipc	ra,0x1
    40ee:	544080e7          	jalr	1348(ra) # 562e <write>
      for(;;) sleep(1000);
    40f2:	3e800513          	li	a0,1000
    40f6:	00001097          	auipc	ra,0x1
    40fa:	5a8080e7          	jalr	1448(ra) # 569e <sleep>
    40fe:	bfd5                	j	40f2 <sbrkfail+0x7a>
  for(i = 0; i < sizeof(pids)/sizeof(pids[0]); i++){
    4100:	0911                	addi	s2,s2,4
    4102:	03390563          	beq	s2,s3,412c <sbrkfail+0xb4>
    if((pids[i] = fork()) == 0){
    4106:	00001097          	auipc	ra,0x1
    410a:	500080e7          	jalr	1280(ra) # 5606 <fork>
    410e:	00a92023          	sw	a0,0(s2)
    4112:	d94d                	beqz	a0,40c4 <sbrkfail+0x4c>
    if(pids[i] != -1)
    4114:	ff4506e3          	beq	a0,s4,4100 <sbrkfail+0x88>
      read(fds[0], &scratch, 1);
    4118:	4605                	li	a2,1
    411a:	faf40593          	addi	a1,s0,-81
    411e:	fb042503          	lw	a0,-80(s0)
    4122:	00001097          	auipc	ra,0x1
    4126:	504080e7          	jalr	1284(ra) # 5626 <read>
    412a:	bfd9                	j	4100 <sbrkfail+0x88>
  c = sbrk(PGSIZE);
    412c:	6505                	lui	a0,0x1
    412e:	00001097          	auipc	ra,0x1
    4132:	568080e7          	jalr	1384(ra) # 5696 <sbrk>
    4136:	8a2a                	mv	s4,a0
    if(pids[i] == -1)
    4138:	597d                	li	s2,-1
    413a:	a021                	j	4142 <sbrkfail+0xca>
  for(i = 0; i < sizeof(pids)/sizeof(pids[0]); i++){
    413c:	0491                	addi	s1,s1,4
    413e:	01348f63          	beq	s1,s3,415c <sbrkfail+0xe4>
    if(pids[i] == -1)
    4142:	4088                	lw	a0,0(s1)
    4144:	ff250ce3          	beq	a0,s2,413c <sbrkfail+0xc4>
    kill(pids[i]);
    4148:	00001097          	auipc	ra,0x1
    414c:	4f6080e7          	jalr	1270(ra) # 563e <kill>
    wait(0);
    4150:	4501                	li	a0,0
    4152:	00001097          	auipc	ra,0x1
    4156:	4c4080e7          	jalr	1220(ra) # 5616 <wait>
    415a:	b7cd                	j	413c <sbrkfail+0xc4>
  if(c == (char*)0xffffffffffffffffL){
    415c:	57fd                	li	a5,-1
    415e:	04fa0163          	beq	s4,a5,41a0 <sbrkfail+0x128>
  pid = fork();
    4162:	00001097          	auipc	ra,0x1
    4166:	4a4080e7          	jalr	1188(ra) # 5606 <fork>
    416a:	84aa                	mv	s1,a0
  if(pid < 0){
    416c:	04054863          	bltz	a0,41bc <sbrkfail+0x144>
  if(pid == 0){
    4170:	c525                	beqz	a0,41d8 <sbrkfail+0x160>
  wait(&xstatus);
    4172:	fbc40513          	addi	a0,s0,-68
    4176:	00001097          	auipc	ra,0x1
    417a:	4a0080e7          	jalr	1184(ra) # 5616 <wait>
  if(xstatus != -1 && xstatus != 2)
    417e:	fbc42783          	lw	a5,-68(s0)
    4182:	577d                	li	a4,-1
    4184:	00e78563          	beq	a5,a4,418e <sbrkfail+0x116>
    4188:	4709                	li	a4,2
    418a:	08e79d63          	bne	a5,a4,4224 <sbrkfail+0x1ac>
}
    418e:	70e6                	ld	ra,120(sp)
    4190:	7446                	ld	s0,112(sp)
    4192:	74a6                	ld	s1,104(sp)
    4194:	7906                	ld	s2,96(sp)
    4196:	69e6                	ld	s3,88(sp)
    4198:	6a46                	ld	s4,80(sp)
    419a:	6aa6                	ld	s5,72(sp)
    419c:	6109                	addi	sp,sp,128
    419e:	8082                	ret
    printf("%s: failed sbrk leaked memory\n", s);
    41a0:	85d6                	mv	a1,s5
    41a2:	00003517          	auipc	a0,0x3
    41a6:	7d650513          	addi	a0,a0,2006 # 7978 <malloc+0x1f2c>
    41aa:	00001097          	auipc	ra,0x1
    41ae:	7e4080e7          	jalr	2020(ra) # 598e <printf>
    exit(1);
    41b2:	4505                	li	a0,1
    41b4:	00001097          	auipc	ra,0x1
    41b8:	45a080e7          	jalr	1114(ra) # 560e <exit>
    printf("%s: fork failed\n", s);
    41bc:	85d6                	mv	a1,s5
    41be:	00002517          	auipc	a0,0x2
    41c2:	50250513          	addi	a0,a0,1282 # 66c0 <malloc+0xc74>
    41c6:	00001097          	auipc	ra,0x1
    41ca:	7c8080e7          	jalr	1992(ra) # 598e <printf>
    exit(1);
    41ce:	4505                	li	a0,1
    41d0:	00001097          	auipc	ra,0x1
    41d4:	43e080e7          	jalr	1086(ra) # 560e <exit>
    a = sbrk(0);
    41d8:	4501                	li	a0,0
    41da:	00001097          	auipc	ra,0x1
    41de:	4bc080e7          	jalr	1212(ra) # 5696 <sbrk>
    41e2:	892a                	mv	s2,a0
    sbrk(10*BIG);
    41e4:	3e800537          	lui	a0,0x3e800
    41e8:	00001097          	auipc	ra,0x1
    41ec:	4ae080e7          	jalr	1198(ra) # 5696 <sbrk>
    for (i = 0; i < 10*BIG; i += PGSIZE) {
    41f0:	87ca                	mv	a5,s2
    41f2:	3e800737          	lui	a4,0x3e800
    41f6:	993a                	add	s2,s2,a4
    41f8:	6705                	lui	a4,0x1
      n += *(a+i);
    41fa:	0007c683          	lbu	a3,0(a5) # 6400000 <__BSS_END__+0x63f1550>
    41fe:	9cb5                	addw	s1,s1,a3
    for (i = 0; i < 10*BIG; i += PGSIZE) {
    4200:	97ba                	add	a5,a5,a4
    4202:	ff279ce3          	bne	a5,s2,41fa <sbrkfail+0x182>
    printf("%s: allocate a lot of memory succeeded %d\n", s, n);
    4206:	8626                	mv	a2,s1
    4208:	85d6                	mv	a1,s5
    420a:	00003517          	auipc	a0,0x3
    420e:	78e50513          	addi	a0,a0,1934 # 7998 <malloc+0x1f4c>
    4212:	00001097          	auipc	ra,0x1
    4216:	77c080e7          	jalr	1916(ra) # 598e <printf>
    exit(1);
    421a:	4505                	li	a0,1
    421c:	00001097          	auipc	ra,0x1
    4220:	3f2080e7          	jalr	1010(ra) # 560e <exit>
    exit(1);
    4224:	4505                	li	a0,1
    4226:	00001097          	auipc	ra,0x1
    422a:	3e8080e7          	jalr	1000(ra) # 560e <exit>

000000000000422e <reparent>:
{
    422e:	7179                	addi	sp,sp,-48
    4230:	f406                	sd	ra,40(sp)
    4232:	f022                	sd	s0,32(sp)
    4234:	ec26                	sd	s1,24(sp)
    4236:	e84a                	sd	s2,16(sp)
    4238:	e44e                	sd	s3,8(sp)
    423a:	e052                	sd	s4,0(sp)
    423c:	1800                	addi	s0,sp,48
    423e:	89aa                	mv	s3,a0
  int master_pid = getpid();
    4240:	00001097          	auipc	ra,0x1
    4244:	44e080e7          	jalr	1102(ra) # 568e <getpid>
    4248:	8a2a                	mv	s4,a0
    424a:	0c800913          	li	s2,200
    int pid = fork();
    424e:	00001097          	auipc	ra,0x1
    4252:	3b8080e7          	jalr	952(ra) # 5606 <fork>
    4256:	84aa                	mv	s1,a0
    if(pid < 0){
    4258:	02054263          	bltz	a0,427c <reparent+0x4e>
    if(pid){
    425c:	cd21                	beqz	a0,42b4 <reparent+0x86>
      if(wait(0) != pid){
    425e:	4501                	li	a0,0
    4260:	00001097          	auipc	ra,0x1
    4264:	3b6080e7          	jalr	950(ra) # 5616 <wait>
    4268:	02951863          	bne	a0,s1,4298 <reparent+0x6a>
  for(int i = 0; i < 200; i++){
    426c:	397d                	addiw	s2,s2,-1
    426e:	fe0910e3          	bnez	s2,424e <reparent+0x20>
  exit(0);
    4272:	4501                	li	a0,0
    4274:	00001097          	auipc	ra,0x1
    4278:	39a080e7          	jalr	922(ra) # 560e <exit>
      printf("%s: fork failed\n", s);
    427c:	85ce                	mv	a1,s3
    427e:	00002517          	auipc	a0,0x2
    4282:	44250513          	addi	a0,a0,1090 # 66c0 <malloc+0xc74>
    4286:	00001097          	auipc	ra,0x1
    428a:	708080e7          	jalr	1800(ra) # 598e <printf>
      exit(1);
    428e:	4505                	li	a0,1
    4290:	00001097          	auipc	ra,0x1
    4294:	37e080e7          	jalr	894(ra) # 560e <exit>
        printf("%s: wait wrong pid\n", s);
    4298:	85ce                	mv	a1,s3
    429a:	00002517          	auipc	a0,0x2
    429e:	5ae50513          	addi	a0,a0,1454 # 6848 <malloc+0xdfc>
    42a2:	00001097          	auipc	ra,0x1
    42a6:	6ec080e7          	jalr	1772(ra) # 598e <printf>
        exit(1);
    42aa:	4505                	li	a0,1
    42ac:	00001097          	auipc	ra,0x1
    42b0:	362080e7          	jalr	866(ra) # 560e <exit>
      int pid2 = fork();
    42b4:	00001097          	auipc	ra,0x1
    42b8:	352080e7          	jalr	850(ra) # 5606 <fork>
      if(pid2 < 0){
    42bc:	00054763          	bltz	a0,42ca <reparent+0x9c>
      exit(0);
    42c0:	4501                	li	a0,0
    42c2:	00001097          	auipc	ra,0x1
    42c6:	34c080e7          	jalr	844(ra) # 560e <exit>
        kill(master_pid);
    42ca:	8552                	mv	a0,s4
    42cc:	00001097          	auipc	ra,0x1
    42d0:	372080e7          	jalr	882(ra) # 563e <kill>
        exit(1);
    42d4:	4505                	li	a0,1
    42d6:	00001097          	auipc	ra,0x1
    42da:	338080e7          	jalr	824(ra) # 560e <exit>

00000000000042de <mem>:
{
    42de:	7139                	addi	sp,sp,-64
    42e0:	fc06                	sd	ra,56(sp)
    42e2:	f822                	sd	s0,48(sp)
    42e4:	f426                	sd	s1,40(sp)
    42e6:	f04a                	sd	s2,32(sp)
    42e8:	ec4e                	sd	s3,24(sp)
    42ea:	0080                	addi	s0,sp,64
    42ec:	89aa                	mv	s3,a0
  if((pid = fork()) == 0){
    42ee:	00001097          	auipc	ra,0x1
    42f2:	318080e7          	jalr	792(ra) # 5606 <fork>
    m1 = 0;
    42f6:	4481                	li	s1,0
    while((m2 = malloc(10001)) != 0){
    42f8:	6909                	lui	s2,0x2
    42fa:	71190913          	addi	s2,s2,1809 # 2711 <sbrkbasic+0x157>
  if((pid = fork()) == 0){
    42fe:	c115                	beqz	a0,4322 <mem+0x44>
    wait(&xstatus);
    4300:	fcc40513          	addi	a0,s0,-52
    4304:	00001097          	auipc	ra,0x1
    4308:	312080e7          	jalr	786(ra) # 5616 <wait>
    if(xstatus == -1){
    430c:	fcc42503          	lw	a0,-52(s0)
    4310:	57fd                	li	a5,-1
    4312:	06f50363          	beq	a0,a5,4378 <mem+0x9a>
    exit(xstatus);
    4316:	00001097          	auipc	ra,0x1
    431a:	2f8080e7          	jalr	760(ra) # 560e <exit>
      *(char**)m2 = m1;
    431e:	e104                	sd	s1,0(a0)
      m1 = m2;
    4320:	84aa                	mv	s1,a0
    while((m2 = malloc(10001)) != 0){
    4322:	854a                	mv	a0,s2
    4324:	00001097          	auipc	ra,0x1
    4328:	728080e7          	jalr	1832(ra) # 5a4c <malloc>
    432c:	f96d                	bnez	a0,431e <mem+0x40>
    while(m1){
    432e:	c881                	beqz	s1,433e <mem+0x60>
      m2 = *(char**)m1;
    4330:	8526                	mv	a0,s1
    4332:	6084                	ld	s1,0(s1)
      free(m1);
    4334:	00001097          	auipc	ra,0x1
    4338:	690080e7          	jalr	1680(ra) # 59c4 <free>
    while(m1){
    433c:	f8f5                	bnez	s1,4330 <mem+0x52>
    m1 = malloc(1024*20);
    433e:	6515                	lui	a0,0x5
    4340:	00001097          	auipc	ra,0x1
    4344:	70c080e7          	jalr	1804(ra) # 5a4c <malloc>
    if(m1 == 0){
    4348:	c911                	beqz	a0,435c <mem+0x7e>
    free(m1);
    434a:	00001097          	auipc	ra,0x1
    434e:	67a080e7          	jalr	1658(ra) # 59c4 <free>
    exit(0);
    4352:	4501                	li	a0,0
    4354:	00001097          	auipc	ra,0x1
    4358:	2ba080e7          	jalr	698(ra) # 560e <exit>
      printf("couldn't allocate mem?!!\n", s);
    435c:	85ce                	mv	a1,s3
    435e:	00003517          	auipc	a0,0x3
    4362:	66a50513          	addi	a0,a0,1642 # 79c8 <malloc+0x1f7c>
    4366:	00001097          	auipc	ra,0x1
    436a:	628080e7          	jalr	1576(ra) # 598e <printf>
      exit(1);
    436e:	4505                	li	a0,1
    4370:	00001097          	auipc	ra,0x1
    4374:	29e080e7          	jalr	670(ra) # 560e <exit>
      exit(0);
    4378:	4501                	li	a0,0
    437a:	00001097          	auipc	ra,0x1
    437e:	294080e7          	jalr	660(ra) # 560e <exit>

0000000000004382 <sharedfd>:
{
    4382:	7159                	addi	sp,sp,-112
    4384:	f486                	sd	ra,104(sp)
    4386:	f0a2                	sd	s0,96(sp)
    4388:	eca6                	sd	s1,88(sp)
    438a:	e8ca                	sd	s2,80(sp)
    438c:	e4ce                	sd	s3,72(sp)
    438e:	e0d2                	sd	s4,64(sp)
    4390:	fc56                	sd	s5,56(sp)
    4392:	f85a                	sd	s6,48(sp)
    4394:	f45e                	sd	s7,40(sp)
    4396:	1880                	addi	s0,sp,112
    4398:	8a2a                	mv	s4,a0
  unlink("sharedfd");
    439a:	00002517          	auipc	a0,0x2
    439e:	92e50513          	addi	a0,a0,-1746 # 5cc8 <malloc+0x27c>
    43a2:	00001097          	auipc	ra,0x1
    43a6:	2bc080e7          	jalr	700(ra) # 565e <unlink>
  fd = open("sharedfd", O_CREATE|O_RDWR);
    43aa:	20200593          	li	a1,514
    43ae:	00002517          	auipc	a0,0x2
    43b2:	91a50513          	addi	a0,a0,-1766 # 5cc8 <malloc+0x27c>
    43b6:	00001097          	auipc	ra,0x1
    43ba:	298080e7          	jalr	664(ra) # 564e <open>
  if(fd < 0){
    43be:	04054a63          	bltz	a0,4412 <sharedfd+0x90>
    43c2:	892a                	mv	s2,a0
  pid = fork();
    43c4:	00001097          	auipc	ra,0x1
    43c8:	242080e7          	jalr	578(ra) # 5606 <fork>
    43cc:	89aa                	mv	s3,a0
  memset(buf, pid==0?'c':'p', sizeof(buf));
    43ce:	06300593          	li	a1,99
    43d2:	c119                	beqz	a0,43d8 <sharedfd+0x56>
    43d4:	07000593          	li	a1,112
    43d8:	4629                	li	a2,10
    43da:	fa040513          	addi	a0,s0,-96
    43de:	00001097          	auipc	ra,0x1
    43e2:	034080e7          	jalr	52(ra) # 5412 <memset>
    43e6:	3e800493          	li	s1,1000
    if(write(fd, buf, sizeof(buf)) != sizeof(buf)){
    43ea:	4629                	li	a2,10
    43ec:	fa040593          	addi	a1,s0,-96
    43f0:	854a                	mv	a0,s2
    43f2:	00001097          	auipc	ra,0x1
    43f6:	23c080e7          	jalr	572(ra) # 562e <write>
    43fa:	47a9                	li	a5,10
    43fc:	02f51963          	bne	a0,a5,442e <sharedfd+0xac>
  for(i = 0; i < N; i++){
    4400:	34fd                	addiw	s1,s1,-1
    4402:	f4e5                	bnez	s1,43ea <sharedfd+0x68>
  if(pid == 0) {
    4404:	04099363          	bnez	s3,444a <sharedfd+0xc8>
    exit(0);
    4408:	4501                	li	a0,0
    440a:	00001097          	auipc	ra,0x1
    440e:	204080e7          	jalr	516(ra) # 560e <exit>
    printf("%s: cannot open sharedfd for writing", s);
    4412:	85d2                	mv	a1,s4
    4414:	00003517          	auipc	a0,0x3
    4418:	5d450513          	addi	a0,a0,1492 # 79e8 <malloc+0x1f9c>
    441c:	00001097          	auipc	ra,0x1
    4420:	572080e7          	jalr	1394(ra) # 598e <printf>
    exit(1);
    4424:	4505                	li	a0,1
    4426:	00001097          	auipc	ra,0x1
    442a:	1e8080e7          	jalr	488(ra) # 560e <exit>
      printf("%s: write sharedfd failed\n", s);
    442e:	85d2                	mv	a1,s4
    4430:	00003517          	auipc	a0,0x3
    4434:	5e050513          	addi	a0,a0,1504 # 7a10 <malloc+0x1fc4>
    4438:	00001097          	auipc	ra,0x1
    443c:	556080e7          	jalr	1366(ra) # 598e <printf>
      exit(1);
    4440:	4505                	li	a0,1
    4442:	00001097          	auipc	ra,0x1
    4446:	1cc080e7          	jalr	460(ra) # 560e <exit>
    wait(&xstatus);
    444a:	f9c40513          	addi	a0,s0,-100
    444e:	00001097          	auipc	ra,0x1
    4452:	1c8080e7          	jalr	456(ra) # 5616 <wait>
    if(xstatus != 0)
    4456:	f9c42983          	lw	s3,-100(s0)
    445a:	00098763          	beqz	s3,4468 <sharedfd+0xe6>
      exit(xstatus);
    445e:	854e                	mv	a0,s3
    4460:	00001097          	auipc	ra,0x1
    4464:	1ae080e7          	jalr	430(ra) # 560e <exit>
  close(fd);
    4468:	854a                	mv	a0,s2
    446a:	00001097          	auipc	ra,0x1
    446e:	1cc080e7          	jalr	460(ra) # 5636 <close>
  fd = open("sharedfd", 0);
    4472:	4581                	li	a1,0
    4474:	00002517          	auipc	a0,0x2
    4478:	85450513          	addi	a0,a0,-1964 # 5cc8 <malloc+0x27c>
    447c:	00001097          	auipc	ra,0x1
    4480:	1d2080e7          	jalr	466(ra) # 564e <open>
    4484:	8baa                	mv	s7,a0
  nc = np = 0;
    4486:	8ace                	mv	s5,s3
  if(fd < 0){
    4488:	02054563          	bltz	a0,44b2 <sharedfd+0x130>
    448c:	faa40913          	addi	s2,s0,-86
      if(buf[i] == 'c')
    4490:	06300493          	li	s1,99
      if(buf[i] == 'p')
    4494:	07000b13          	li	s6,112
  while((n = read(fd, buf, sizeof(buf))) > 0){
    4498:	4629                	li	a2,10
    449a:	fa040593          	addi	a1,s0,-96
    449e:	855e                	mv	a0,s7
    44a0:	00001097          	auipc	ra,0x1
    44a4:	186080e7          	jalr	390(ra) # 5626 <read>
    44a8:	02a05f63          	blez	a0,44e6 <sharedfd+0x164>
    44ac:	fa040793          	addi	a5,s0,-96
    44b0:	a01d                	j	44d6 <sharedfd+0x154>
    printf("%s: cannot open sharedfd for reading\n", s);
    44b2:	85d2                	mv	a1,s4
    44b4:	00003517          	auipc	a0,0x3
    44b8:	57c50513          	addi	a0,a0,1404 # 7a30 <malloc+0x1fe4>
    44bc:	00001097          	auipc	ra,0x1
    44c0:	4d2080e7          	jalr	1234(ra) # 598e <printf>
    exit(1);
    44c4:	4505                	li	a0,1
    44c6:	00001097          	auipc	ra,0x1
    44ca:	148080e7          	jalr	328(ra) # 560e <exit>
        nc++;
    44ce:	2985                	addiw	s3,s3,1
    for(i = 0; i < sizeof(buf); i++){
    44d0:	0785                	addi	a5,a5,1
    44d2:	fd2783e3          	beq	a5,s2,4498 <sharedfd+0x116>
      if(buf[i] == 'c')
    44d6:	0007c703          	lbu	a4,0(a5)
    44da:	fe970ae3          	beq	a4,s1,44ce <sharedfd+0x14c>
      if(buf[i] == 'p')
    44de:	ff6719e3          	bne	a4,s6,44d0 <sharedfd+0x14e>
        np++;
    44e2:	2a85                	addiw	s5,s5,1
    44e4:	b7f5                	j	44d0 <sharedfd+0x14e>
  close(fd);
    44e6:	855e                	mv	a0,s7
    44e8:	00001097          	auipc	ra,0x1
    44ec:	14e080e7          	jalr	334(ra) # 5636 <close>
  unlink("sharedfd");
    44f0:	00001517          	auipc	a0,0x1
    44f4:	7d850513          	addi	a0,a0,2008 # 5cc8 <malloc+0x27c>
    44f8:	00001097          	auipc	ra,0x1
    44fc:	166080e7          	jalr	358(ra) # 565e <unlink>
  if(nc == N*SZ && np == N*SZ){
    4500:	6789                	lui	a5,0x2
    4502:	71078793          	addi	a5,a5,1808 # 2710 <sbrkbasic+0x156>
    4506:	00f99763          	bne	s3,a5,4514 <sharedfd+0x192>
    450a:	6789                	lui	a5,0x2
    450c:	71078793          	addi	a5,a5,1808 # 2710 <sbrkbasic+0x156>
    4510:	02fa8063          	beq	s5,a5,4530 <sharedfd+0x1ae>
    printf("%s: nc/np test fails\n", s);
    4514:	85d2                	mv	a1,s4
    4516:	00003517          	auipc	a0,0x3
    451a:	54250513          	addi	a0,a0,1346 # 7a58 <malloc+0x200c>
    451e:	00001097          	auipc	ra,0x1
    4522:	470080e7          	jalr	1136(ra) # 598e <printf>
    exit(1);
    4526:	4505                	li	a0,1
    4528:	00001097          	auipc	ra,0x1
    452c:	0e6080e7          	jalr	230(ra) # 560e <exit>
    exit(0);
    4530:	4501                	li	a0,0
    4532:	00001097          	auipc	ra,0x1
    4536:	0dc080e7          	jalr	220(ra) # 560e <exit>

000000000000453a <fourfiles>:
{
    453a:	7171                	addi	sp,sp,-176
    453c:	f506                	sd	ra,168(sp)
    453e:	f122                	sd	s0,160(sp)
    4540:	ed26                	sd	s1,152(sp)
    4542:	e94a                	sd	s2,144(sp)
    4544:	e54e                	sd	s3,136(sp)
    4546:	e152                	sd	s4,128(sp)
    4548:	fcd6                	sd	s5,120(sp)
    454a:	f8da                	sd	s6,112(sp)
    454c:	f4de                	sd	s7,104(sp)
    454e:	f0e2                	sd	s8,96(sp)
    4550:	ece6                	sd	s9,88(sp)
    4552:	e8ea                	sd	s10,80(sp)
    4554:	e4ee                	sd	s11,72(sp)
    4556:	1900                	addi	s0,sp,176
    4558:	f4a43c23          	sd	a0,-168(s0)
  char *names[] = { "f0", "f1", "f2", "f3" };
    455c:	00001797          	auipc	a5,0x1
    4560:	5d478793          	addi	a5,a5,1492 # 5b30 <malloc+0xe4>
    4564:	f6f43823          	sd	a5,-144(s0)
    4568:	00001797          	auipc	a5,0x1
    456c:	5d078793          	addi	a5,a5,1488 # 5b38 <malloc+0xec>
    4570:	f6f43c23          	sd	a5,-136(s0)
    4574:	00001797          	auipc	a5,0x1
    4578:	5cc78793          	addi	a5,a5,1484 # 5b40 <malloc+0xf4>
    457c:	f8f43023          	sd	a5,-128(s0)
    4580:	00001797          	auipc	a5,0x1
    4584:	5c878793          	addi	a5,a5,1480 # 5b48 <malloc+0xfc>
    4588:	f8f43423          	sd	a5,-120(s0)
  for(pi = 0; pi < NCHILD; pi++){
    458c:	f7040c13          	addi	s8,s0,-144
  char *names[] = { "f0", "f1", "f2", "f3" };
    4590:	8962                	mv	s2,s8
  for(pi = 0; pi < NCHILD; pi++){
    4592:	4481                	li	s1,0
    4594:	4a11                	li	s4,4
    fname = names[pi];
    4596:	00093983          	ld	s3,0(s2)
    unlink(fname);
    459a:	854e                	mv	a0,s3
    459c:	00001097          	auipc	ra,0x1
    45a0:	0c2080e7          	jalr	194(ra) # 565e <unlink>
    pid = fork();
    45a4:	00001097          	auipc	ra,0x1
    45a8:	062080e7          	jalr	98(ra) # 5606 <fork>
    if(pid < 0){
    45ac:	04054463          	bltz	a0,45f4 <fourfiles+0xba>
    if(pid == 0){
    45b0:	c12d                	beqz	a0,4612 <fourfiles+0xd8>
  for(pi = 0; pi < NCHILD; pi++){
    45b2:	2485                	addiw	s1,s1,1
    45b4:	0921                	addi	s2,s2,8
    45b6:	ff4490e3          	bne	s1,s4,4596 <fourfiles+0x5c>
    45ba:	4491                	li	s1,4
    wait(&xstatus);
    45bc:	f6c40513          	addi	a0,s0,-148
    45c0:	00001097          	auipc	ra,0x1
    45c4:	056080e7          	jalr	86(ra) # 5616 <wait>
    if(xstatus != 0)
    45c8:	f6c42b03          	lw	s6,-148(s0)
    45cc:	0c0b1e63          	bnez	s6,46a8 <fourfiles+0x16e>
  for(pi = 0; pi < NCHILD; pi++){
    45d0:	34fd                	addiw	s1,s1,-1
    45d2:	f4ed                	bnez	s1,45bc <fourfiles+0x82>
    45d4:	03000b93          	li	s7,48
    while((n = read(fd, buf, sizeof(buf))) > 0){
    45d8:	00007a17          	auipc	s4,0x7
    45dc:	4c8a0a13          	addi	s4,s4,1224 # baa0 <buf>
    45e0:	00007a97          	auipc	s5,0x7
    45e4:	4c1a8a93          	addi	s5,s5,1217 # baa1 <buf+0x1>
    if(total != N*SZ){
    45e8:	6d85                	lui	s11,0x1
    45ea:	770d8d93          	addi	s11,s11,1904 # 1770 <pipe1+0x30>
  for(i = 0; i < NCHILD; i++){
    45ee:	03400d13          	li	s10,52
    45f2:	aa1d                	j	4728 <fourfiles+0x1ee>
      printf("fork failed\n", s);
    45f4:	f5843583          	ld	a1,-168(s0)
    45f8:	00002517          	auipc	a0,0x2
    45fc:	4d050513          	addi	a0,a0,1232 # 6ac8 <malloc+0x107c>
    4600:	00001097          	auipc	ra,0x1
    4604:	38e080e7          	jalr	910(ra) # 598e <printf>
      exit(1);
    4608:	4505                	li	a0,1
    460a:	00001097          	auipc	ra,0x1
    460e:	004080e7          	jalr	4(ra) # 560e <exit>
      fd = open(fname, O_CREATE | O_RDWR);
    4612:	20200593          	li	a1,514
    4616:	854e                	mv	a0,s3
    4618:	00001097          	auipc	ra,0x1
    461c:	036080e7          	jalr	54(ra) # 564e <open>
    4620:	892a                	mv	s2,a0
      if(fd < 0){
    4622:	04054763          	bltz	a0,4670 <fourfiles+0x136>
      memset(buf, '0'+pi, SZ);
    4626:	1f400613          	li	a2,500
    462a:	0304859b          	addiw	a1,s1,48
    462e:	00007517          	auipc	a0,0x7
    4632:	47250513          	addi	a0,a0,1138 # baa0 <buf>
    4636:	00001097          	auipc	ra,0x1
    463a:	ddc080e7          	jalr	-548(ra) # 5412 <memset>
    463e:	44b1                	li	s1,12
        if((n = write(fd, buf, SZ)) != SZ){
    4640:	00007997          	auipc	s3,0x7
    4644:	46098993          	addi	s3,s3,1120 # baa0 <buf>
    4648:	1f400613          	li	a2,500
    464c:	85ce                	mv	a1,s3
    464e:	854a                	mv	a0,s2
    4650:	00001097          	auipc	ra,0x1
    4654:	fde080e7          	jalr	-34(ra) # 562e <write>
    4658:	85aa                	mv	a1,a0
    465a:	1f400793          	li	a5,500
    465e:	02f51863          	bne	a0,a5,468e <fourfiles+0x154>
      for(i = 0; i < N; i++){
    4662:	34fd                	addiw	s1,s1,-1
    4664:	f0f5                	bnez	s1,4648 <fourfiles+0x10e>
      exit(0);
    4666:	4501                	li	a0,0
    4668:	00001097          	auipc	ra,0x1
    466c:	fa6080e7          	jalr	-90(ra) # 560e <exit>
        printf("create failed\n", s);
    4670:	f5843583          	ld	a1,-168(s0)
    4674:	00003517          	auipc	a0,0x3
    4678:	3fc50513          	addi	a0,a0,1020 # 7a70 <malloc+0x2024>
    467c:	00001097          	auipc	ra,0x1
    4680:	312080e7          	jalr	786(ra) # 598e <printf>
        exit(1);
    4684:	4505                	li	a0,1
    4686:	00001097          	auipc	ra,0x1
    468a:	f88080e7          	jalr	-120(ra) # 560e <exit>
          printf("write failed %d\n", n);
    468e:	00003517          	auipc	a0,0x3
    4692:	3f250513          	addi	a0,a0,1010 # 7a80 <malloc+0x2034>
    4696:	00001097          	auipc	ra,0x1
    469a:	2f8080e7          	jalr	760(ra) # 598e <printf>
          exit(1);
    469e:	4505                	li	a0,1
    46a0:	00001097          	auipc	ra,0x1
    46a4:	f6e080e7          	jalr	-146(ra) # 560e <exit>
      exit(xstatus);
    46a8:	855a                	mv	a0,s6
    46aa:	00001097          	auipc	ra,0x1
    46ae:	f64080e7          	jalr	-156(ra) # 560e <exit>
          printf("wrong char\n", s);
    46b2:	f5843583          	ld	a1,-168(s0)
    46b6:	00003517          	auipc	a0,0x3
    46ba:	3e250513          	addi	a0,a0,994 # 7a98 <malloc+0x204c>
    46be:	00001097          	auipc	ra,0x1
    46c2:	2d0080e7          	jalr	720(ra) # 598e <printf>
          exit(1);
    46c6:	4505                	li	a0,1
    46c8:	00001097          	auipc	ra,0x1
    46cc:	f46080e7          	jalr	-186(ra) # 560e <exit>
      total += n;
    46d0:	00a9093b          	addw	s2,s2,a0
    while((n = read(fd, buf, sizeof(buf))) > 0){
    46d4:	660d                	lui	a2,0x3
    46d6:	85d2                	mv	a1,s4
    46d8:	854e                	mv	a0,s3
    46da:	00001097          	auipc	ra,0x1
    46de:	f4c080e7          	jalr	-180(ra) # 5626 <read>
    46e2:	02a05363          	blez	a0,4708 <fourfiles+0x1ce>
    46e6:	00007797          	auipc	a5,0x7
    46ea:	3ba78793          	addi	a5,a5,954 # baa0 <buf>
    46ee:	fff5069b          	addiw	a3,a0,-1
    46f2:	1682                	slli	a3,a3,0x20
    46f4:	9281                	srli	a3,a3,0x20
    46f6:	96d6                	add	a3,a3,s5
        if(buf[j] != '0'+i){
    46f8:	0007c703          	lbu	a4,0(a5)
    46fc:	fa971be3          	bne	a4,s1,46b2 <fourfiles+0x178>
      for(j = 0; j < n; j++){
    4700:	0785                	addi	a5,a5,1
    4702:	fed79be3          	bne	a5,a3,46f8 <fourfiles+0x1be>
    4706:	b7e9                	j	46d0 <fourfiles+0x196>
    close(fd);
    4708:	854e                	mv	a0,s3
    470a:	00001097          	auipc	ra,0x1
    470e:	f2c080e7          	jalr	-212(ra) # 5636 <close>
    if(total != N*SZ){
    4712:	03b91863          	bne	s2,s11,4742 <fourfiles+0x208>
    unlink(fname);
    4716:	8566                	mv	a0,s9
    4718:	00001097          	auipc	ra,0x1
    471c:	f46080e7          	jalr	-186(ra) # 565e <unlink>
  for(i = 0; i < NCHILD; i++){
    4720:	0c21                	addi	s8,s8,8
    4722:	2b85                	addiw	s7,s7,1
    4724:	03ab8d63          	beq	s7,s10,475e <fourfiles+0x224>
    fname = names[i];
    4728:	000c3c83          	ld	s9,0(s8)
    fd = open(fname, 0);
    472c:	4581                	li	a1,0
    472e:	8566                	mv	a0,s9
    4730:	00001097          	auipc	ra,0x1
    4734:	f1e080e7          	jalr	-226(ra) # 564e <open>
    4738:	89aa                	mv	s3,a0
    total = 0;
    473a:	895a                	mv	s2,s6
        if(buf[j] != '0'+i){
    473c:	000b849b          	sext.w	s1,s7
    while((n = read(fd, buf, sizeof(buf))) > 0){
    4740:	bf51                	j	46d4 <fourfiles+0x19a>
      printf("wrong length %d\n", total);
    4742:	85ca                	mv	a1,s2
    4744:	00003517          	auipc	a0,0x3
    4748:	36450513          	addi	a0,a0,868 # 7aa8 <malloc+0x205c>
    474c:	00001097          	auipc	ra,0x1
    4750:	242080e7          	jalr	578(ra) # 598e <printf>
      exit(1);
    4754:	4505                	li	a0,1
    4756:	00001097          	auipc	ra,0x1
    475a:	eb8080e7          	jalr	-328(ra) # 560e <exit>
}
    475e:	70aa                	ld	ra,168(sp)
    4760:	740a                	ld	s0,160(sp)
    4762:	64ea                	ld	s1,152(sp)
    4764:	694a                	ld	s2,144(sp)
    4766:	69aa                	ld	s3,136(sp)
    4768:	6a0a                	ld	s4,128(sp)
    476a:	7ae6                	ld	s5,120(sp)
    476c:	7b46                	ld	s6,112(sp)
    476e:	7ba6                	ld	s7,104(sp)
    4770:	7c06                	ld	s8,96(sp)
    4772:	6ce6                	ld	s9,88(sp)
    4774:	6d46                	ld	s10,80(sp)
    4776:	6da6                	ld	s11,72(sp)
    4778:	614d                	addi	sp,sp,176
    477a:	8082                	ret

000000000000477c <concreate>:
{
    477c:	7135                	addi	sp,sp,-160
    477e:	ed06                	sd	ra,152(sp)
    4780:	e922                	sd	s0,144(sp)
    4782:	e526                	sd	s1,136(sp)
    4784:	e14a                	sd	s2,128(sp)
    4786:	fcce                	sd	s3,120(sp)
    4788:	f8d2                	sd	s4,112(sp)
    478a:	f4d6                	sd	s5,104(sp)
    478c:	f0da                	sd	s6,96(sp)
    478e:	ecde                	sd	s7,88(sp)
    4790:	1100                	addi	s0,sp,160
    4792:	89aa                	mv	s3,a0
  file[0] = 'C';
    4794:	04300793          	li	a5,67
    4798:	faf40423          	sb	a5,-88(s0)
  file[2] = '\0';
    479c:	fa040523          	sb	zero,-86(s0)
  for(i = 0; i < N; i++){
    47a0:	4901                	li	s2,0
    if(pid && (i % 3) == 1){
    47a2:	4b0d                	li	s6,3
    47a4:	4a85                	li	s5,1
      link("C0", file);
    47a6:	00003b97          	auipc	s7,0x3
    47aa:	31ab8b93          	addi	s7,s7,794 # 7ac0 <malloc+0x2074>
  for(i = 0; i < N; i++){
    47ae:	02800a13          	li	s4,40
    47b2:	acc1                	j	4a82 <concreate+0x306>
      link("C0", file);
    47b4:	fa840593          	addi	a1,s0,-88
    47b8:	855e                	mv	a0,s7
    47ba:	00001097          	auipc	ra,0x1
    47be:	eb4080e7          	jalr	-332(ra) # 566e <link>
    if(pid == 0) {
    47c2:	a45d                	j	4a68 <concreate+0x2ec>
    } else if(pid == 0 && (i % 5) == 1){
    47c4:	4795                	li	a5,5
    47c6:	02f9693b          	remw	s2,s2,a5
    47ca:	4785                	li	a5,1
    47cc:	02f90b63          	beq	s2,a5,4802 <concreate+0x86>
      fd = open(file, O_CREATE | O_RDWR);
    47d0:	20200593          	li	a1,514
    47d4:	fa840513          	addi	a0,s0,-88
    47d8:	00001097          	auipc	ra,0x1
    47dc:	e76080e7          	jalr	-394(ra) # 564e <open>
      if(fd < 0){
    47e0:	26055b63          	bgez	a0,4a56 <concreate+0x2da>
        printf("concreate create %s failed\n", file);
    47e4:	fa840593          	addi	a1,s0,-88
    47e8:	00003517          	auipc	a0,0x3
    47ec:	2e050513          	addi	a0,a0,736 # 7ac8 <malloc+0x207c>
    47f0:	00001097          	auipc	ra,0x1
    47f4:	19e080e7          	jalr	414(ra) # 598e <printf>
        exit(1);
    47f8:	4505                	li	a0,1
    47fa:	00001097          	auipc	ra,0x1
    47fe:	e14080e7          	jalr	-492(ra) # 560e <exit>
      link("C0", file);
    4802:	fa840593          	addi	a1,s0,-88
    4806:	00003517          	auipc	a0,0x3
    480a:	2ba50513          	addi	a0,a0,698 # 7ac0 <malloc+0x2074>
    480e:	00001097          	auipc	ra,0x1
    4812:	e60080e7          	jalr	-416(ra) # 566e <link>
      exit(0);
    4816:	4501                	li	a0,0
    4818:	00001097          	auipc	ra,0x1
    481c:	df6080e7          	jalr	-522(ra) # 560e <exit>
        exit(1);
    4820:	4505                	li	a0,1
    4822:	00001097          	auipc	ra,0x1
    4826:	dec080e7          	jalr	-532(ra) # 560e <exit>
  memset(fa, 0, sizeof(fa));
    482a:	02800613          	li	a2,40
    482e:	4581                	li	a1,0
    4830:	f8040513          	addi	a0,s0,-128
    4834:	00001097          	auipc	ra,0x1
    4838:	bde080e7          	jalr	-1058(ra) # 5412 <memset>
  fd = open(".", 0);
    483c:	4581                	li	a1,0
    483e:	00002517          	auipc	a0,0x2
    4842:	ce250513          	addi	a0,a0,-798 # 6520 <malloc+0xad4>
    4846:	00001097          	auipc	ra,0x1
    484a:	e08080e7          	jalr	-504(ra) # 564e <open>
    484e:	892a                	mv	s2,a0
  n = 0;
    4850:	8aa6                	mv	s5,s1
    if(de.name[0] == 'C' && de.name[2] == '\0'){
    4852:	04300a13          	li	s4,67
      if(i < 0 || i >= sizeof(fa)){
    4856:	02700b13          	li	s6,39
      fa[i] = 1;
    485a:	4b85                	li	s7,1
  while(read(fd, &de, sizeof(de)) > 0){
    485c:	4641                	li	a2,16
    485e:	f7040593          	addi	a1,s0,-144
    4862:	854a                	mv	a0,s2
    4864:	00001097          	auipc	ra,0x1
    4868:	dc2080e7          	jalr	-574(ra) # 5626 <read>
    486c:	08a05163          	blez	a0,48ee <concreate+0x172>
    if(de.inum == 0)
    4870:	f7045783          	lhu	a5,-144(s0)
    4874:	d7e5                	beqz	a5,485c <concreate+0xe0>
    if(de.name[0] == 'C' && de.name[2] == '\0'){
    4876:	f7244783          	lbu	a5,-142(s0)
    487a:	ff4791e3          	bne	a5,s4,485c <concreate+0xe0>
    487e:	f7444783          	lbu	a5,-140(s0)
    4882:	ffe9                	bnez	a5,485c <concreate+0xe0>
      i = de.name[1] - '0';
    4884:	f7344783          	lbu	a5,-141(s0)
    4888:	fd07879b          	addiw	a5,a5,-48
    488c:	0007871b          	sext.w	a4,a5
      if(i < 0 || i >= sizeof(fa)){
    4890:	00eb6f63          	bltu	s6,a4,48ae <concreate+0x132>
      if(fa[i]){
    4894:	fb040793          	addi	a5,s0,-80
    4898:	97ba                	add	a5,a5,a4
    489a:	fd07c783          	lbu	a5,-48(a5)
    489e:	eb85                	bnez	a5,48ce <concreate+0x152>
      fa[i] = 1;
    48a0:	fb040793          	addi	a5,s0,-80
    48a4:	973e                	add	a4,a4,a5
    48a6:	fd770823          	sb	s7,-48(a4) # fd0 <bigdir+0x6c>
      n++;
    48aa:	2a85                	addiw	s5,s5,1
    48ac:	bf45                	j	485c <concreate+0xe0>
        printf("%s: concreate weird file %s\n", s, de.name);
    48ae:	f7240613          	addi	a2,s0,-142
    48b2:	85ce                	mv	a1,s3
    48b4:	00003517          	auipc	a0,0x3
    48b8:	23450513          	addi	a0,a0,564 # 7ae8 <malloc+0x209c>
    48bc:	00001097          	auipc	ra,0x1
    48c0:	0d2080e7          	jalr	210(ra) # 598e <printf>
        exit(1);
    48c4:	4505                	li	a0,1
    48c6:	00001097          	auipc	ra,0x1
    48ca:	d48080e7          	jalr	-696(ra) # 560e <exit>
        printf("%s: concreate duplicate file %s\n", s, de.name);
    48ce:	f7240613          	addi	a2,s0,-142
    48d2:	85ce                	mv	a1,s3
    48d4:	00003517          	auipc	a0,0x3
    48d8:	23450513          	addi	a0,a0,564 # 7b08 <malloc+0x20bc>
    48dc:	00001097          	auipc	ra,0x1
    48e0:	0b2080e7          	jalr	178(ra) # 598e <printf>
        exit(1);
    48e4:	4505                	li	a0,1
    48e6:	00001097          	auipc	ra,0x1
    48ea:	d28080e7          	jalr	-728(ra) # 560e <exit>
  close(fd);
    48ee:	854a                	mv	a0,s2
    48f0:	00001097          	auipc	ra,0x1
    48f4:	d46080e7          	jalr	-698(ra) # 5636 <close>
  if(n != N){
    48f8:	02800793          	li	a5,40
    48fc:	00fa9763          	bne	s5,a5,490a <concreate+0x18e>
    if(((i % 3) == 0 && pid == 0) ||
    4900:	4a8d                	li	s5,3
    4902:	4b05                	li	s6,1
  for(i = 0; i < N; i++){
    4904:	02800a13          	li	s4,40
    4908:	a8c9                	j	49da <concreate+0x25e>
    printf("%s: concreate not enough files in directory listing\n", s);
    490a:	85ce                	mv	a1,s3
    490c:	00003517          	auipc	a0,0x3
    4910:	22450513          	addi	a0,a0,548 # 7b30 <malloc+0x20e4>
    4914:	00001097          	auipc	ra,0x1
    4918:	07a080e7          	jalr	122(ra) # 598e <printf>
    exit(1);
    491c:	4505                	li	a0,1
    491e:	00001097          	auipc	ra,0x1
    4922:	cf0080e7          	jalr	-784(ra) # 560e <exit>
      printf("%s: fork failed\n", s);
    4926:	85ce                	mv	a1,s3
    4928:	00002517          	auipc	a0,0x2
    492c:	d9850513          	addi	a0,a0,-616 # 66c0 <malloc+0xc74>
    4930:	00001097          	auipc	ra,0x1
    4934:	05e080e7          	jalr	94(ra) # 598e <printf>
      exit(1);
    4938:	4505                	li	a0,1
    493a:	00001097          	auipc	ra,0x1
    493e:	cd4080e7          	jalr	-812(ra) # 560e <exit>
      close(open(file, 0));
    4942:	4581                	li	a1,0
    4944:	fa840513          	addi	a0,s0,-88
    4948:	00001097          	auipc	ra,0x1
    494c:	d06080e7          	jalr	-762(ra) # 564e <open>
    4950:	00001097          	auipc	ra,0x1
    4954:	ce6080e7          	jalr	-794(ra) # 5636 <close>
      close(open(file, 0));
    4958:	4581                	li	a1,0
    495a:	fa840513          	addi	a0,s0,-88
    495e:	00001097          	auipc	ra,0x1
    4962:	cf0080e7          	jalr	-784(ra) # 564e <open>
    4966:	00001097          	auipc	ra,0x1
    496a:	cd0080e7          	jalr	-816(ra) # 5636 <close>
      close(open(file, 0));
    496e:	4581                	li	a1,0
    4970:	fa840513          	addi	a0,s0,-88
    4974:	00001097          	auipc	ra,0x1
    4978:	cda080e7          	jalr	-806(ra) # 564e <open>
    497c:	00001097          	auipc	ra,0x1
    4980:	cba080e7          	jalr	-838(ra) # 5636 <close>
      close(open(file, 0));
    4984:	4581                	li	a1,0
    4986:	fa840513          	addi	a0,s0,-88
    498a:	00001097          	auipc	ra,0x1
    498e:	cc4080e7          	jalr	-828(ra) # 564e <open>
    4992:	00001097          	auipc	ra,0x1
    4996:	ca4080e7          	jalr	-860(ra) # 5636 <close>
      close(open(file, 0));
    499a:	4581                	li	a1,0
    499c:	fa840513          	addi	a0,s0,-88
    49a0:	00001097          	auipc	ra,0x1
    49a4:	cae080e7          	jalr	-850(ra) # 564e <open>
    49a8:	00001097          	auipc	ra,0x1
    49ac:	c8e080e7          	jalr	-882(ra) # 5636 <close>
      close(open(file, 0));
    49b0:	4581                	li	a1,0
    49b2:	fa840513          	addi	a0,s0,-88
    49b6:	00001097          	auipc	ra,0x1
    49ba:	c98080e7          	jalr	-872(ra) # 564e <open>
    49be:	00001097          	auipc	ra,0x1
    49c2:	c78080e7          	jalr	-904(ra) # 5636 <close>
    if(pid == 0)
    49c6:	08090363          	beqz	s2,4a4c <concreate+0x2d0>
      wait(0);
    49ca:	4501                	li	a0,0
    49cc:	00001097          	auipc	ra,0x1
    49d0:	c4a080e7          	jalr	-950(ra) # 5616 <wait>
  for(i = 0; i < N; i++){
    49d4:	2485                	addiw	s1,s1,1
    49d6:	0f448563          	beq	s1,s4,4ac0 <concreate+0x344>
    file[1] = '0' + i;
    49da:	0304879b          	addiw	a5,s1,48
    49de:	faf404a3          	sb	a5,-87(s0)
    pid = fork();
    49e2:	00001097          	auipc	ra,0x1
    49e6:	c24080e7          	jalr	-988(ra) # 5606 <fork>
    49ea:	892a                	mv	s2,a0
    if(pid < 0){
    49ec:	f2054de3          	bltz	a0,4926 <concreate+0x1aa>
    if(((i % 3) == 0 && pid == 0) ||
    49f0:	0354e73b          	remw	a4,s1,s5
    49f4:	00a767b3          	or	a5,a4,a0
    49f8:	2781                	sext.w	a5,a5
    49fa:	d7a1                	beqz	a5,4942 <concreate+0x1c6>
    49fc:	01671363          	bne	a4,s6,4a02 <concreate+0x286>
       ((i % 3) == 1 && pid != 0)){
    4a00:	f129                	bnez	a0,4942 <concreate+0x1c6>
      unlink(file);
    4a02:	fa840513          	addi	a0,s0,-88
    4a06:	00001097          	auipc	ra,0x1
    4a0a:	c58080e7          	jalr	-936(ra) # 565e <unlink>
      unlink(file);
    4a0e:	fa840513          	addi	a0,s0,-88
    4a12:	00001097          	auipc	ra,0x1
    4a16:	c4c080e7          	jalr	-948(ra) # 565e <unlink>
      unlink(file);
    4a1a:	fa840513          	addi	a0,s0,-88
    4a1e:	00001097          	auipc	ra,0x1
    4a22:	c40080e7          	jalr	-960(ra) # 565e <unlink>
      unlink(file);
    4a26:	fa840513          	addi	a0,s0,-88
    4a2a:	00001097          	auipc	ra,0x1
    4a2e:	c34080e7          	jalr	-972(ra) # 565e <unlink>
      unlink(file);
    4a32:	fa840513          	addi	a0,s0,-88
    4a36:	00001097          	auipc	ra,0x1
    4a3a:	c28080e7          	jalr	-984(ra) # 565e <unlink>
      unlink(file);
    4a3e:	fa840513          	addi	a0,s0,-88
    4a42:	00001097          	auipc	ra,0x1
    4a46:	c1c080e7          	jalr	-996(ra) # 565e <unlink>
    4a4a:	bfb5                	j	49c6 <concreate+0x24a>
      exit(0);
    4a4c:	4501                	li	a0,0
    4a4e:	00001097          	auipc	ra,0x1
    4a52:	bc0080e7          	jalr	-1088(ra) # 560e <exit>
      close(fd);
    4a56:	00001097          	auipc	ra,0x1
    4a5a:	be0080e7          	jalr	-1056(ra) # 5636 <close>
    if(pid == 0) {
    4a5e:	bb65                	j	4816 <concreate+0x9a>
      close(fd);
    4a60:	00001097          	auipc	ra,0x1
    4a64:	bd6080e7          	jalr	-1066(ra) # 5636 <close>
      wait(&xstatus);
    4a68:	f6c40513          	addi	a0,s0,-148
    4a6c:	00001097          	auipc	ra,0x1
    4a70:	baa080e7          	jalr	-1110(ra) # 5616 <wait>
      if(xstatus != 0)
    4a74:	f6c42483          	lw	s1,-148(s0)
    4a78:	da0494e3          	bnez	s1,4820 <concreate+0xa4>
  for(i = 0; i < N; i++){
    4a7c:	2905                	addiw	s2,s2,1
    4a7e:	db4906e3          	beq	s2,s4,482a <concreate+0xae>
    file[1] = '0' + i;
    4a82:	0309079b          	addiw	a5,s2,48
    4a86:	faf404a3          	sb	a5,-87(s0)
    unlink(file);
    4a8a:	fa840513          	addi	a0,s0,-88
    4a8e:	00001097          	auipc	ra,0x1
    4a92:	bd0080e7          	jalr	-1072(ra) # 565e <unlink>
    pid = fork();
    4a96:	00001097          	auipc	ra,0x1
    4a9a:	b70080e7          	jalr	-1168(ra) # 5606 <fork>
    if(pid && (i % 3) == 1){
    4a9e:	d20503e3          	beqz	a0,47c4 <concreate+0x48>
    4aa2:	036967bb          	remw	a5,s2,s6
    4aa6:	d15787e3          	beq	a5,s5,47b4 <concreate+0x38>
      fd = open(file, O_CREATE | O_RDWR);
    4aaa:	20200593          	li	a1,514
    4aae:	fa840513          	addi	a0,s0,-88
    4ab2:	00001097          	auipc	ra,0x1
    4ab6:	b9c080e7          	jalr	-1124(ra) # 564e <open>
      if(fd < 0){
    4aba:	fa0553e3          	bgez	a0,4a60 <concreate+0x2e4>
    4abe:	b31d                	j	47e4 <concreate+0x68>
}
    4ac0:	60ea                	ld	ra,152(sp)
    4ac2:	644a                	ld	s0,144(sp)
    4ac4:	64aa                	ld	s1,136(sp)
    4ac6:	690a                	ld	s2,128(sp)
    4ac8:	79e6                	ld	s3,120(sp)
    4aca:	7a46                	ld	s4,112(sp)
    4acc:	7aa6                	ld	s5,104(sp)
    4ace:	7b06                	ld	s6,96(sp)
    4ad0:	6be6                	ld	s7,88(sp)
    4ad2:	610d                	addi	sp,sp,160
    4ad4:	8082                	ret

0000000000004ad6 <bigfile>:
{
    4ad6:	7139                	addi	sp,sp,-64
    4ad8:	fc06                	sd	ra,56(sp)
    4ada:	f822                	sd	s0,48(sp)
    4adc:	f426                	sd	s1,40(sp)
    4ade:	f04a                	sd	s2,32(sp)
    4ae0:	ec4e                	sd	s3,24(sp)
    4ae2:	e852                	sd	s4,16(sp)
    4ae4:	e456                	sd	s5,8(sp)
    4ae6:	0080                	addi	s0,sp,64
    4ae8:	8aaa                	mv	s5,a0
  unlink("bigfile.dat");
    4aea:	00003517          	auipc	a0,0x3
    4aee:	07e50513          	addi	a0,a0,126 # 7b68 <malloc+0x211c>
    4af2:	00001097          	auipc	ra,0x1
    4af6:	b6c080e7          	jalr	-1172(ra) # 565e <unlink>
  fd = open("bigfile.dat", O_CREATE | O_RDWR);
    4afa:	20200593          	li	a1,514
    4afe:	00003517          	auipc	a0,0x3
    4b02:	06a50513          	addi	a0,a0,106 # 7b68 <malloc+0x211c>
    4b06:	00001097          	auipc	ra,0x1
    4b0a:	b48080e7          	jalr	-1208(ra) # 564e <open>
    4b0e:	89aa                	mv	s3,a0
  for(i = 0; i < N; i++){
    4b10:	4481                	li	s1,0
    memset(buf, i, SZ);
    4b12:	00007917          	auipc	s2,0x7
    4b16:	f8e90913          	addi	s2,s2,-114 # baa0 <buf>
  for(i = 0; i < N; i++){
    4b1a:	4a51                	li	s4,20
  if(fd < 0){
    4b1c:	0a054063          	bltz	a0,4bbc <bigfile+0xe6>
    memset(buf, i, SZ);
    4b20:	25800613          	li	a2,600
    4b24:	85a6                	mv	a1,s1
    4b26:	854a                	mv	a0,s2
    4b28:	00001097          	auipc	ra,0x1
    4b2c:	8ea080e7          	jalr	-1814(ra) # 5412 <memset>
    if(write(fd, buf, SZ) != SZ){
    4b30:	25800613          	li	a2,600
    4b34:	85ca                	mv	a1,s2
    4b36:	854e                	mv	a0,s3
    4b38:	00001097          	auipc	ra,0x1
    4b3c:	af6080e7          	jalr	-1290(ra) # 562e <write>
    4b40:	25800793          	li	a5,600
    4b44:	08f51a63          	bne	a0,a5,4bd8 <bigfile+0x102>
  for(i = 0; i < N; i++){
    4b48:	2485                	addiw	s1,s1,1
    4b4a:	fd449be3          	bne	s1,s4,4b20 <bigfile+0x4a>
  close(fd);
    4b4e:	854e                	mv	a0,s3
    4b50:	00001097          	auipc	ra,0x1
    4b54:	ae6080e7          	jalr	-1306(ra) # 5636 <close>
  fd = open("bigfile.dat", 0);
    4b58:	4581                	li	a1,0
    4b5a:	00003517          	auipc	a0,0x3
    4b5e:	00e50513          	addi	a0,a0,14 # 7b68 <malloc+0x211c>
    4b62:	00001097          	auipc	ra,0x1
    4b66:	aec080e7          	jalr	-1300(ra) # 564e <open>
    4b6a:	8a2a                	mv	s4,a0
  total = 0;
    4b6c:	4981                	li	s3,0
  for(i = 0; ; i++){
    4b6e:	4481                	li	s1,0
    cc = read(fd, buf, SZ/2);
    4b70:	00007917          	auipc	s2,0x7
    4b74:	f3090913          	addi	s2,s2,-208 # baa0 <buf>
  if(fd < 0){
    4b78:	06054e63          	bltz	a0,4bf4 <bigfile+0x11e>
    cc = read(fd, buf, SZ/2);
    4b7c:	12c00613          	li	a2,300
    4b80:	85ca                	mv	a1,s2
    4b82:	8552                	mv	a0,s4
    4b84:	00001097          	auipc	ra,0x1
    4b88:	aa2080e7          	jalr	-1374(ra) # 5626 <read>
    if(cc < 0){
    4b8c:	08054263          	bltz	a0,4c10 <bigfile+0x13a>
    if(cc == 0)
    4b90:	c971                	beqz	a0,4c64 <bigfile+0x18e>
    if(cc != SZ/2){
    4b92:	12c00793          	li	a5,300
    4b96:	08f51b63          	bne	a0,a5,4c2c <bigfile+0x156>
    if(buf[0] != i/2 || buf[SZ/2-1] != i/2){
    4b9a:	01f4d79b          	srliw	a5,s1,0x1f
    4b9e:	9fa5                	addw	a5,a5,s1
    4ba0:	4017d79b          	sraiw	a5,a5,0x1
    4ba4:	00094703          	lbu	a4,0(s2)
    4ba8:	0af71063          	bne	a4,a5,4c48 <bigfile+0x172>
    4bac:	12b94703          	lbu	a4,299(s2)
    4bb0:	08f71c63          	bne	a4,a5,4c48 <bigfile+0x172>
    total += cc;
    4bb4:	12c9899b          	addiw	s3,s3,300
  for(i = 0; ; i++){
    4bb8:	2485                	addiw	s1,s1,1
    cc = read(fd, buf, SZ/2);
    4bba:	b7c9                	j	4b7c <bigfile+0xa6>
    printf("%s: cannot create bigfile", s);
    4bbc:	85d6                	mv	a1,s5
    4bbe:	00003517          	auipc	a0,0x3
    4bc2:	fba50513          	addi	a0,a0,-70 # 7b78 <malloc+0x212c>
    4bc6:	00001097          	auipc	ra,0x1
    4bca:	dc8080e7          	jalr	-568(ra) # 598e <printf>
    exit(1);
    4bce:	4505                	li	a0,1
    4bd0:	00001097          	auipc	ra,0x1
    4bd4:	a3e080e7          	jalr	-1474(ra) # 560e <exit>
      printf("%s: write bigfile failed\n", s);
    4bd8:	85d6                	mv	a1,s5
    4bda:	00003517          	auipc	a0,0x3
    4bde:	fbe50513          	addi	a0,a0,-66 # 7b98 <malloc+0x214c>
    4be2:	00001097          	auipc	ra,0x1
    4be6:	dac080e7          	jalr	-596(ra) # 598e <printf>
      exit(1);
    4bea:	4505                	li	a0,1
    4bec:	00001097          	auipc	ra,0x1
    4bf0:	a22080e7          	jalr	-1502(ra) # 560e <exit>
    printf("%s: cannot open bigfile\n", s);
    4bf4:	85d6                	mv	a1,s5
    4bf6:	00003517          	auipc	a0,0x3
    4bfa:	fc250513          	addi	a0,a0,-62 # 7bb8 <malloc+0x216c>
    4bfe:	00001097          	auipc	ra,0x1
    4c02:	d90080e7          	jalr	-624(ra) # 598e <printf>
    exit(1);
    4c06:	4505                	li	a0,1
    4c08:	00001097          	auipc	ra,0x1
    4c0c:	a06080e7          	jalr	-1530(ra) # 560e <exit>
      printf("%s: read bigfile failed\n", s);
    4c10:	85d6                	mv	a1,s5
    4c12:	00003517          	auipc	a0,0x3
    4c16:	fc650513          	addi	a0,a0,-58 # 7bd8 <malloc+0x218c>
    4c1a:	00001097          	auipc	ra,0x1
    4c1e:	d74080e7          	jalr	-652(ra) # 598e <printf>
      exit(1);
    4c22:	4505                	li	a0,1
    4c24:	00001097          	auipc	ra,0x1
    4c28:	9ea080e7          	jalr	-1558(ra) # 560e <exit>
      printf("%s: short read bigfile\n", s);
    4c2c:	85d6                	mv	a1,s5
    4c2e:	00003517          	auipc	a0,0x3
    4c32:	fca50513          	addi	a0,a0,-54 # 7bf8 <malloc+0x21ac>
    4c36:	00001097          	auipc	ra,0x1
    4c3a:	d58080e7          	jalr	-680(ra) # 598e <printf>
      exit(1);
    4c3e:	4505                	li	a0,1
    4c40:	00001097          	auipc	ra,0x1
    4c44:	9ce080e7          	jalr	-1586(ra) # 560e <exit>
      printf("%s: read bigfile wrong data\n", s);
    4c48:	85d6                	mv	a1,s5
    4c4a:	00003517          	auipc	a0,0x3
    4c4e:	fc650513          	addi	a0,a0,-58 # 7c10 <malloc+0x21c4>
    4c52:	00001097          	auipc	ra,0x1
    4c56:	d3c080e7          	jalr	-708(ra) # 598e <printf>
      exit(1);
    4c5a:	4505                	li	a0,1
    4c5c:	00001097          	auipc	ra,0x1
    4c60:	9b2080e7          	jalr	-1614(ra) # 560e <exit>
  close(fd);
    4c64:	8552                	mv	a0,s4
    4c66:	00001097          	auipc	ra,0x1
    4c6a:	9d0080e7          	jalr	-1584(ra) # 5636 <close>
  if(total != N*SZ){
    4c6e:	678d                	lui	a5,0x3
    4c70:	ee078793          	addi	a5,a5,-288 # 2ee0 <exitiputtest+0x46>
    4c74:	02f99363          	bne	s3,a5,4c9a <bigfile+0x1c4>
  unlink("bigfile.dat");
    4c78:	00003517          	auipc	a0,0x3
    4c7c:	ef050513          	addi	a0,a0,-272 # 7b68 <malloc+0x211c>
    4c80:	00001097          	auipc	ra,0x1
    4c84:	9de080e7          	jalr	-1570(ra) # 565e <unlink>
}
    4c88:	70e2                	ld	ra,56(sp)
    4c8a:	7442                	ld	s0,48(sp)
    4c8c:	74a2                	ld	s1,40(sp)
    4c8e:	7902                	ld	s2,32(sp)
    4c90:	69e2                	ld	s3,24(sp)
    4c92:	6a42                	ld	s4,16(sp)
    4c94:	6aa2                	ld	s5,8(sp)
    4c96:	6121                	addi	sp,sp,64
    4c98:	8082                	ret
    printf("%s: read bigfile wrong total\n", s);
    4c9a:	85d6                	mv	a1,s5
    4c9c:	00003517          	auipc	a0,0x3
    4ca0:	f9450513          	addi	a0,a0,-108 # 7c30 <malloc+0x21e4>
    4ca4:	00001097          	auipc	ra,0x1
    4ca8:	cea080e7          	jalr	-790(ra) # 598e <printf>
    exit(1);
    4cac:	4505                	li	a0,1
    4cae:	00001097          	auipc	ra,0x1
    4cb2:	960080e7          	jalr	-1696(ra) # 560e <exit>

0000000000004cb6 <fsfull>:
{
    4cb6:	7171                	addi	sp,sp,-176
    4cb8:	f506                	sd	ra,168(sp)
    4cba:	f122                	sd	s0,160(sp)
    4cbc:	ed26                	sd	s1,152(sp)
    4cbe:	e94a                	sd	s2,144(sp)
    4cc0:	e54e                	sd	s3,136(sp)
    4cc2:	e152                	sd	s4,128(sp)
    4cc4:	fcd6                	sd	s5,120(sp)
    4cc6:	f8da                	sd	s6,112(sp)
    4cc8:	f4de                	sd	s7,104(sp)
    4cca:	f0e2                	sd	s8,96(sp)
    4ccc:	ece6                	sd	s9,88(sp)
    4cce:	e8ea                	sd	s10,80(sp)
    4cd0:	e4ee                	sd	s11,72(sp)
    4cd2:	1900                	addi	s0,sp,176
  printf("fsfull test\n");
    4cd4:	00003517          	auipc	a0,0x3
    4cd8:	f7c50513          	addi	a0,a0,-132 # 7c50 <malloc+0x2204>
    4cdc:	00001097          	auipc	ra,0x1
    4ce0:	cb2080e7          	jalr	-846(ra) # 598e <printf>
  for(nfiles = 0; ; nfiles++){
    4ce4:	4481                	li	s1,0
    name[0] = 'f';
    4ce6:	06600d13          	li	s10,102
    name[1] = '0' + nfiles / 1000;
    4cea:	3e800c13          	li	s8,1000
    name[2] = '0' + (nfiles % 1000) / 100;
    4cee:	06400b93          	li	s7,100
    name[3] = '0' + (nfiles % 100) / 10;
    4cf2:	4b29                	li	s6,10
    printf("writing %s\n", name);
    4cf4:	00003c97          	auipc	s9,0x3
    4cf8:	f6cc8c93          	addi	s9,s9,-148 # 7c60 <malloc+0x2214>
    int total = 0;
    4cfc:	4d81                	li	s11,0
      int cc = write(fd, buf, BSIZE);
    4cfe:	00007a17          	auipc	s4,0x7
    4d02:	da2a0a13          	addi	s4,s4,-606 # baa0 <buf>
    name[0] = 'f';
    4d06:	f5a40823          	sb	s10,-176(s0)
    name[1] = '0' + nfiles / 1000;
    4d0a:	0384c7bb          	divw	a5,s1,s8
    4d0e:	0307879b          	addiw	a5,a5,48
    4d12:	f4f408a3          	sb	a5,-175(s0)
    name[2] = '0' + (nfiles % 1000) / 100;
    4d16:	0384e7bb          	remw	a5,s1,s8
    4d1a:	0377c7bb          	divw	a5,a5,s7
    4d1e:	0307879b          	addiw	a5,a5,48
    4d22:	f4f40923          	sb	a5,-174(s0)
    name[3] = '0' + (nfiles % 100) / 10;
    4d26:	0374e7bb          	remw	a5,s1,s7
    4d2a:	0367c7bb          	divw	a5,a5,s6
    4d2e:	0307879b          	addiw	a5,a5,48
    4d32:	f4f409a3          	sb	a5,-173(s0)
    name[4] = '0' + (nfiles % 10);
    4d36:	0364e7bb          	remw	a5,s1,s6
    4d3a:	0307879b          	addiw	a5,a5,48
    4d3e:	f4f40a23          	sb	a5,-172(s0)
    name[5] = '\0';
    4d42:	f4040aa3          	sb	zero,-171(s0)
    printf("writing %s\n", name);
    4d46:	f5040593          	addi	a1,s0,-176
    4d4a:	8566                	mv	a0,s9
    4d4c:	00001097          	auipc	ra,0x1
    4d50:	c42080e7          	jalr	-958(ra) # 598e <printf>
    int fd = open(name, O_CREATE|O_RDWR);
    4d54:	20200593          	li	a1,514
    4d58:	f5040513          	addi	a0,s0,-176
    4d5c:	00001097          	auipc	ra,0x1
    4d60:	8f2080e7          	jalr	-1806(ra) # 564e <open>
    4d64:	892a                	mv	s2,a0
    if(fd < 0){
    4d66:	0a055663          	bgez	a0,4e12 <fsfull+0x15c>
      printf("open %s failed\n", name);
    4d6a:	f5040593          	addi	a1,s0,-176
    4d6e:	00003517          	auipc	a0,0x3
    4d72:	f0250513          	addi	a0,a0,-254 # 7c70 <malloc+0x2224>
    4d76:	00001097          	auipc	ra,0x1
    4d7a:	c18080e7          	jalr	-1000(ra) # 598e <printf>
  while(nfiles >= 0){
    4d7e:	0604c363          	bltz	s1,4de4 <fsfull+0x12e>
    name[0] = 'f';
    4d82:	06600b13          	li	s6,102
    name[1] = '0' + nfiles / 1000;
    4d86:	3e800a13          	li	s4,1000
    name[2] = '0' + (nfiles % 1000) / 100;
    4d8a:	06400993          	li	s3,100
    name[3] = '0' + (nfiles % 100) / 10;
    4d8e:	4929                	li	s2,10
  while(nfiles >= 0){
    4d90:	5afd                	li	s5,-1
    name[0] = 'f';
    4d92:	f5640823          	sb	s6,-176(s0)
    name[1] = '0' + nfiles / 1000;
    4d96:	0344c7bb          	divw	a5,s1,s4
    4d9a:	0307879b          	addiw	a5,a5,48
    4d9e:	f4f408a3          	sb	a5,-175(s0)
    name[2] = '0' + (nfiles % 1000) / 100;
    4da2:	0344e7bb          	remw	a5,s1,s4
    4da6:	0337c7bb          	divw	a5,a5,s3
    4daa:	0307879b          	addiw	a5,a5,48
    4dae:	f4f40923          	sb	a5,-174(s0)
    name[3] = '0' + (nfiles % 100) / 10;
    4db2:	0334e7bb          	remw	a5,s1,s3
    4db6:	0327c7bb          	divw	a5,a5,s2
    4dba:	0307879b          	addiw	a5,a5,48
    4dbe:	f4f409a3          	sb	a5,-173(s0)
    name[4] = '0' + (nfiles % 10);
    4dc2:	0324e7bb          	remw	a5,s1,s2
    4dc6:	0307879b          	addiw	a5,a5,48
    4dca:	f4f40a23          	sb	a5,-172(s0)
    name[5] = '\0';
    4dce:	f4040aa3          	sb	zero,-171(s0)
    unlink(name);
    4dd2:	f5040513          	addi	a0,s0,-176
    4dd6:	00001097          	auipc	ra,0x1
    4dda:	888080e7          	jalr	-1912(ra) # 565e <unlink>
    nfiles--;
    4dde:	34fd                	addiw	s1,s1,-1
  while(nfiles >= 0){
    4de0:	fb5499e3          	bne	s1,s5,4d92 <fsfull+0xdc>
  printf("fsfull test finished\n");
    4de4:	00003517          	auipc	a0,0x3
    4de8:	eac50513          	addi	a0,a0,-340 # 7c90 <malloc+0x2244>
    4dec:	00001097          	auipc	ra,0x1
    4df0:	ba2080e7          	jalr	-1118(ra) # 598e <printf>
}
    4df4:	70aa                	ld	ra,168(sp)
    4df6:	740a                	ld	s0,160(sp)
    4df8:	64ea                	ld	s1,152(sp)
    4dfa:	694a                	ld	s2,144(sp)
    4dfc:	69aa                	ld	s3,136(sp)
    4dfe:	6a0a                	ld	s4,128(sp)
    4e00:	7ae6                	ld	s5,120(sp)
    4e02:	7b46                	ld	s6,112(sp)
    4e04:	7ba6                	ld	s7,104(sp)
    4e06:	7c06                	ld	s8,96(sp)
    4e08:	6ce6                	ld	s9,88(sp)
    4e0a:	6d46                	ld	s10,80(sp)
    4e0c:	6da6                	ld	s11,72(sp)
    4e0e:	614d                	addi	sp,sp,176
    4e10:	8082                	ret
    int total = 0;
    4e12:	89ee                	mv	s3,s11
      if(cc < BSIZE)
    4e14:	3ff00a93          	li	s5,1023
      int cc = write(fd, buf, BSIZE);
    4e18:	40000613          	li	a2,1024
    4e1c:	85d2                	mv	a1,s4
    4e1e:	854a                	mv	a0,s2
    4e20:	00001097          	auipc	ra,0x1
    4e24:	80e080e7          	jalr	-2034(ra) # 562e <write>
      if(cc < BSIZE)
    4e28:	00aad563          	bge	s5,a0,4e32 <fsfull+0x17c>
      total += cc;
    4e2c:	00a989bb          	addw	s3,s3,a0
    while(1){
    4e30:	b7e5                	j	4e18 <fsfull+0x162>
    printf("wrote %d bytes\n", total);
    4e32:	85ce                	mv	a1,s3
    4e34:	00003517          	auipc	a0,0x3
    4e38:	e4c50513          	addi	a0,a0,-436 # 7c80 <malloc+0x2234>
    4e3c:	00001097          	auipc	ra,0x1
    4e40:	b52080e7          	jalr	-1198(ra) # 598e <printf>
    close(fd);
    4e44:	854a                	mv	a0,s2
    4e46:	00000097          	auipc	ra,0x0
    4e4a:	7f0080e7          	jalr	2032(ra) # 5636 <close>
    if(total == 0)
    4e4e:	f20988e3          	beqz	s3,4d7e <fsfull+0xc8>
  for(nfiles = 0; ; nfiles++){
    4e52:	2485                	addiw	s1,s1,1
    4e54:	bd4d                	j	4d06 <fsfull+0x50>

0000000000004e56 <rand>:
{
    4e56:	1141                	addi	sp,sp,-16
    4e58:	e422                	sd	s0,8(sp)
    4e5a:	0800                	addi	s0,sp,16
  randstate = randstate * 1664525 + 1013904223;
    4e5c:	00003717          	auipc	a4,0x3
    4e60:	41c70713          	addi	a4,a4,1052 # 8278 <randstate>
    4e64:	6308                	ld	a0,0(a4)
    4e66:	001967b7          	lui	a5,0x196
    4e6a:	60d78793          	addi	a5,a5,1549 # 19660d <__BSS_END__+0x187b5d>
    4e6e:	02f50533          	mul	a0,a0,a5
    4e72:	3c6ef7b7          	lui	a5,0x3c6ef
    4e76:	35f78793          	addi	a5,a5,863 # 3c6ef35f <__BSS_END__+0x3c6e08af>
    4e7a:	953e                	add	a0,a0,a5
    4e7c:	e308                	sd	a0,0(a4)
}
    4e7e:	2501                	sext.w	a0,a0
    4e80:	6422                	ld	s0,8(sp)
    4e82:	0141                	addi	sp,sp,16
    4e84:	8082                	ret

0000000000004e86 <badwrite>:
{
    4e86:	7179                	addi	sp,sp,-48
    4e88:	f406                	sd	ra,40(sp)
    4e8a:	f022                	sd	s0,32(sp)
    4e8c:	ec26                	sd	s1,24(sp)
    4e8e:	e84a                	sd	s2,16(sp)
    4e90:	e44e                	sd	s3,8(sp)
    4e92:	e052                	sd	s4,0(sp)
    4e94:	1800                	addi	s0,sp,48
  unlink("junk");
    4e96:	00003517          	auipc	a0,0x3
    4e9a:	e1250513          	addi	a0,a0,-494 # 7ca8 <malloc+0x225c>
    4e9e:	00000097          	auipc	ra,0x0
    4ea2:	7c0080e7          	jalr	1984(ra) # 565e <unlink>
    4ea6:	25800913          	li	s2,600
    int fd = open("junk", O_CREATE|O_WRONLY);
    4eaa:	00003997          	auipc	s3,0x3
    4eae:	dfe98993          	addi	s3,s3,-514 # 7ca8 <malloc+0x225c>
    write(fd, (char*)0xffffffffffL, 1);
    4eb2:	5a7d                	li	s4,-1
    4eb4:	018a5a13          	srli	s4,s4,0x18
    int fd = open("junk", O_CREATE|O_WRONLY);
    4eb8:	20100593          	li	a1,513
    4ebc:	854e                	mv	a0,s3
    4ebe:	00000097          	auipc	ra,0x0
    4ec2:	790080e7          	jalr	1936(ra) # 564e <open>
    4ec6:	84aa                	mv	s1,a0
    if(fd < 0){
    4ec8:	06054b63          	bltz	a0,4f3e <badwrite+0xb8>
    write(fd, (char*)0xffffffffffL, 1);
    4ecc:	4605                	li	a2,1
    4ece:	85d2                	mv	a1,s4
    4ed0:	00000097          	auipc	ra,0x0
    4ed4:	75e080e7          	jalr	1886(ra) # 562e <write>
    close(fd);
    4ed8:	8526                	mv	a0,s1
    4eda:	00000097          	auipc	ra,0x0
    4ede:	75c080e7          	jalr	1884(ra) # 5636 <close>
    unlink("junk");
    4ee2:	854e                	mv	a0,s3
    4ee4:	00000097          	auipc	ra,0x0
    4ee8:	77a080e7          	jalr	1914(ra) # 565e <unlink>
  for(int i = 0; i < assumed_free; i++){
    4eec:	397d                	addiw	s2,s2,-1
    4eee:	fc0915e3          	bnez	s2,4eb8 <badwrite+0x32>
  int fd = open("junk", O_CREATE|O_WRONLY);
    4ef2:	20100593          	li	a1,513
    4ef6:	00003517          	auipc	a0,0x3
    4efa:	db250513          	addi	a0,a0,-590 # 7ca8 <malloc+0x225c>
    4efe:	00000097          	auipc	ra,0x0
    4f02:	750080e7          	jalr	1872(ra) # 564e <open>
    4f06:	84aa                	mv	s1,a0
  if(fd < 0){
    4f08:	04054863          	bltz	a0,4f58 <badwrite+0xd2>
  if(write(fd, "x", 1) != 1){
    4f0c:	4605                	li	a2,1
    4f0e:	00001597          	auipc	a1,0x1
    4f12:	fea58593          	addi	a1,a1,-22 # 5ef8 <malloc+0x4ac>
    4f16:	00000097          	auipc	ra,0x0
    4f1a:	718080e7          	jalr	1816(ra) # 562e <write>
    4f1e:	4785                	li	a5,1
    4f20:	04f50963          	beq	a0,a5,4f72 <badwrite+0xec>
    printf("write failed\n");
    4f24:	00003517          	auipc	a0,0x3
    4f28:	da450513          	addi	a0,a0,-604 # 7cc8 <malloc+0x227c>
    4f2c:	00001097          	auipc	ra,0x1
    4f30:	a62080e7          	jalr	-1438(ra) # 598e <printf>
    exit(1);
    4f34:	4505                	li	a0,1
    4f36:	00000097          	auipc	ra,0x0
    4f3a:	6d8080e7          	jalr	1752(ra) # 560e <exit>
      printf("open junk failed\n");
    4f3e:	00003517          	auipc	a0,0x3
    4f42:	d7250513          	addi	a0,a0,-654 # 7cb0 <malloc+0x2264>
    4f46:	00001097          	auipc	ra,0x1
    4f4a:	a48080e7          	jalr	-1464(ra) # 598e <printf>
      exit(1);
    4f4e:	4505                	li	a0,1
    4f50:	00000097          	auipc	ra,0x0
    4f54:	6be080e7          	jalr	1726(ra) # 560e <exit>
    printf("open junk failed\n");
    4f58:	00003517          	auipc	a0,0x3
    4f5c:	d5850513          	addi	a0,a0,-680 # 7cb0 <malloc+0x2264>
    4f60:	00001097          	auipc	ra,0x1
    4f64:	a2e080e7          	jalr	-1490(ra) # 598e <printf>
    exit(1);
    4f68:	4505                	li	a0,1
    4f6a:	00000097          	auipc	ra,0x0
    4f6e:	6a4080e7          	jalr	1700(ra) # 560e <exit>
  close(fd);
    4f72:	8526                	mv	a0,s1
    4f74:	00000097          	auipc	ra,0x0
    4f78:	6c2080e7          	jalr	1730(ra) # 5636 <close>
  unlink("junk");
    4f7c:	00003517          	auipc	a0,0x3
    4f80:	d2c50513          	addi	a0,a0,-724 # 7ca8 <malloc+0x225c>
    4f84:	00000097          	auipc	ra,0x0
    4f88:	6da080e7          	jalr	1754(ra) # 565e <unlink>
  exit(0);
    4f8c:	4501                	li	a0,0
    4f8e:	00000097          	auipc	ra,0x0
    4f92:	680080e7          	jalr	1664(ra) # 560e <exit>

0000000000004f96 <countfree>:
// because out of memory with lazy allocation results in the process
// taking a fault and being killed, fork and report back.
//
int
countfree()
{
    4f96:	7139                	addi	sp,sp,-64
    4f98:	fc06                	sd	ra,56(sp)
    4f9a:	f822                	sd	s0,48(sp)
    4f9c:	f426                	sd	s1,40(sp)
    4f9e:	f04a                	sd	s2,32(sp)
    4fa0:	ec4e                	sd	s3,24(sp)
    4fa2:	0080                	addi	s0,sp,64
  int fds[2];

  if(pipe(fds) < 0){
    4fa4:	fc840513          	addi	a0,s0,-56
    4fa8:	00000097          	auipc	ra,0x0
    4fac:	676080e7          	jalr	1654(ra) # 561e <pipe>
    4fb0:	06054763          	bltz	a0,501e <countfree+0x88>
    printf("pipe() failed in countfree()\n");
    exit(1);
  }
  
  int pid = fork();
    4fb4:	00000097          	auipc	ra,0x0
    4fb8:	652080e7          	jalr	1618(ra) # 5606 <fork>

  if(pid < 0){
    4fbc:	06054e63          	bltz	a0,5038 <countfree+0xa2>
    printf("fork failed in countfree()\n");
    exit(1);
  }

  if(pid == 0){
    4fc0:	ed51                	bnez	a0,505c <countfree+0xc6>
    close(fds[0]);
    4fc2:	fc842503          	lw	a0,-56(s0)
    4fc6:	00000097          	auipc	ra,0x0
    4fca:	670080e7          	jalr	1648(ra) # 5636 <close>
    
    while(1){
      uint64 a = (uint64) sbrk(4096);
      if(a == 0xffffffffffffffff){
    4fce:	597d                	li	s2,-1
        break;
      }

      // modify the memory to make sure it's really allocated.
      *(char *)(a + 4096 - 1) = 1;
    4fd0:	4485                	li	s1,1

      // report back one more page.
      if(write(fds[1], "x", 1) != 1){
    4fd2:	00001997          	auipc	s3,0x1
    4fd6:	f2698993          	addi	s3,s3,-218 # 5ef8 <malloc+0x4ac>
      uint64 a = (uint64) sbrk(4096);
    4fda:	6505                	lui	a0,0x1
    4fdc:	00000097          	auipc	ra,0x0
    4fe0:	6ba080e7          	jalr	1722(ra) # 5696 <sbrk>
      if(a == 0xffffffffffffffff){
    4fe4:	07250763          	beq	a0,s2,5052 <countfree+0xbc>
      *(char *)(a + 4096 - 1) = 1;
    4fe8:	6785                	lui	a5,0x1
    4fea:	953e                	add	a0,a0,a5
    4fec:	fe950fa3          	sb	s1,-1(a0) # fff <bigdir+0x9b>
      if(write(fds[1], "x", 1) != 1){
    4ff0:	8626                	mv	a2,s1
    4ff2:	85ce                	mv	a1,s3
    4ff4:	fcc42503          	lw	a0,-52(s0)
    4ff8:	00000097          	auipc	ra,0x0
    4ffc:	636080e7          	jalr	1590(ra) # 562e <write>
    5000:	fc950de3          	beq	a0,s1,4fda <countfree+0x44>
        printf("write() failed in countfree()\n");
    5004:	00003517          	auipc	a0,0x3
    5008:	d1450513          	addi	a0,a0,-748 # 7d18 <malloc+0x22cc>
    500c:	00001097          	auipc	ra,0x1
    5010:	982080e7          	jalr	-1662(ra) # 598e <printf>
        exit(1);
    5014:	4505                	li	a0,1
    5016:	00000097          	auipc	ra,0x0
    501a:	5f8080e7          	jalr	1528(ra) # 560e <exit>
    printf("pipe() failed in countfree()\n");
    501e:	00003517          	auipc	a0,0x3
    5022:	cba50513          	addi	a0,a0,-838 # 7cd8 <malloc+0x228c>
    5026:	00001097          	auipc	ra,0x1
    502a:	968080e7          	jalr	-1688(ra) # 598e <printf>
    exit(1);
    502e:	4505                	li	a0,1
    5030:	00000097          	auipc	ra,0x0
    5034:	5de080e7          	jalr	1502(ra) # 560e <exit>
    printf("fork failed in countfree()\n");
    5038:	00003517          	auipc	a0,0x3
    503c:	cc050513          	addi	a0,a0,-832 # 7cf8 <malloc+0x22ac>
    5040:	00001097          	auipc	ra,0x1
    5044:	94e080e7          	jalr	-1714(ra) # 598e <printf>
    exit(1);
    5048:	4505                	li	a0,1
    504a:	00000097          	auipc	ra,0x0
    504e:	5c4080e7          	jalr	1476(ra) # 560e <exit>
      }
    }

    exit(0);
    5052:	4501                	li	a0,0
    5054:	00000097          	auipc	ra,0x0
    5058:	5ba080e7          	jalr	1466(ra) # 560e <exit>
  }

  close(fds[1]);
    505c:	fcc42503          	lw	a0,-52(s0)
    5060:	00000097          	auipc	ra,0x0
    5064:	5d6080e7          	jalr	1494(ra) # 5636 <close>

  int n = 0;
    5068:	4481                	li	s1,0
  while(1){
    char c;
    int cc = read(fds[0], &c, 1);
    506a:	4605                	li	a2,1
    506c:	fc740593          	addi	a1,s0,-57
    5070:	fc842503          	lw	a0,-56(s0)
    5074:	00000097          	auipc	ra,0x0
    5078:	5b2080e7          	jalr	1458(ra) # 5626 <read>
    if(cc < 0){
    507c:	00054563          	bltz	a0,5086 <countfree+0xf0>
      printf("read() failed in countfree()\n");
      exit(1);
    }
    if(cc == 0)
    5080:	c105                	beqz	a0,50a0 <countfree+0x10a>
      break;
    n += 1;
    5082:	2485                	addiw	s1,s1,1
  while(1){
    5084:	b7dd                	j	506a <countfree+0xd4>
      printf("read() failed in countfree()\n");
    5086:	00003517          	auipc	a0,0x3
    508a:	cb250513          	addi	a0,a0,-846 # 7d38 <malloc+0x22ec>
    508e:	00001097          	auipc	ra,0x1
    5092:	900080e7          	jalr	-1792(ra) # 598e <printf>
      exit(1);
    5096:	4505                	li	a0,1
    5098:	00000097          	auipc	ra,0x0
    509c:	576080e7          	jalr	1398(ra) # 560e <exit>
  }

  close(fds[0]);
    50a0:	fc842503          	lw	a0,-56(s0)
    50a4:	00000097          	auipc	ra,0x0
    50a8:	592080e7          	jalr	1426(ra) # 5636 <close>
  wait((int*)0);
    50ac:	4501                	li	a0,0
    50ae:	00000097          	auipc	ra,0x0
    50b2:	568080e7          	jalr	1384(ra) # 5616 <wait>
  
  return n;
}
    50b6:	8526                	mv	a0,s1
    50b8:	70e2                	ld	ra,56(sp)
    50ba:	7442                	ld	s0,48(sp)
    50bc:	74a2                	ld	s1,40(sp)
    50be:	7902                	ld	s2,32(sp)
    50c0:	69e2                	ld	s3,24(sp)
    50c2:	6121                	addi	sp,sp,64
    50c4:	8082                	ret

00000000000050c6 <run>:

// run each test in its own process. run returns 1 if child's exit()
// indicates success.
int
run(void f(char *), char *s) {
    50c6:	7179                	addi	sp,sp,-48
    50c8:	f406                	sd	ra,40(sp)
    50ca:	f022                	sd	s0,32(sp)
    50cc:	ec26                	sd	s1,24(sp)
    50ce:	e84a                	sd	s2,16(sp)
    50d0:	1800                	addi	s0,sp,48
    50d2:	84aa                	mv	s1,a0
    50d4:	892e                	mv	s2,a1
  int pid;
  int xstatus;

  printf("test %s: ", s);
    50d6:	00003517          	auipc	a0,0x3
    50da:	c8250513          	addi	a0,a0,-894 # 7d58 <malloc+0x230c>
    50de:	00001097          	auipc	ra,0x1
    50e2:	8b0080e7          	jalr	-1872(ra) # 598e <printf>
  if((pid = fork()) < 0) {
    50e6:	00000097          	auipc	ra,0x0
    50ea:	520080e7          	jalr	1312(ra) # 5606 <fork>
    50ee:	02054e63          	bltz	a0,512a <run+0x64>
    printf("runtest: fork error\n");
    exit(1);
  }
  if(pid == 0) {
    50f2:	c929                	beqz	a0,5144 <run+0x7e>
    f(s);
    exit(0);
  } else {
    wait(&xstatus);
    50f4:	fdc40513          	addi	a0,s0,-36
    50f8:	00000097          	auipc	ra,0x0
    50fc:	51e080e7          	jalr	1310(ra) # 5616 <wait>
    if(xstatus != 0) 
    5100:	fdc42783          	lw	a5,-36(s0)
    5104:	c7b9                	beqz	a5,5152 <run+0x8c>
      printf("FAILED\n");
    5106:	00003517          	auipc	a0,0x3
    510a:	c7a50513          	addi	a0,a0,-902 # 7d80 <malloc+0x2334>
    510e:	00001097          	auipc	ra,0x1
    5112:	880080e7          	jalr	-1920(ra) # 598e <printf>
    else
      printf("OK\n");
    return xstatus == 0;
    5116:	fdc42503          	lw	a0,-36(s0)
  }
}
    511a:	00153513          	seqz	a0,a0
    511e:	70a2                	ld	ra,40(sp)
    5120:	7402                	ld	s0,32(sp)
    5122:	64e2                	ld	s1,24(sp)
    5124:	6942                	ld	s2,16(sp)
    5126:	6145                	addi	sp,sp,48
    5128:	8082                	ret
    printf("runtest: fork error\n");
    512a:	00003517          	auipc	a0,0x3
    512e:	c3e50513          	addi	a0,a0,-962 # 7d68 <malloc+0x231c>
    5132:	00001097          	auipc	ra,0x1
    5136:	85c080e7          	jalr	-1956(ra) # 598e <printf>
    exit(1);
    513a:	4505                	li	a0,1
    513c:	00000097          	auipc	ra,0x0
    5140:	4d2080e7          	jalr	1234(ra) # 560e <exit>
    f(s);
    5144:	854a                	mv	a0,s2
    5146:	9482                	jalr	s1
    exit(0);
    5148:	4501                	li	a0,0
    514a:	00000097          	auipc	ra,0x0
    514e:	4c4080e7          	jalr	1220(ra) # 560e <exit>
      printf("OK\n");
    5152:	00003517          	auipc	a0,0x3
    5156:	c3650513          	addi	a0,a0,-970 # 7d88 <malloc+0x233c>
    515a:	00001097          	auipc	ra,0x1
    515e:	834080e7          	jalr	-1996(ra) # 598e <printf>
    5162:	bf55                	j	5116 <run+0x50>

0000000000005164 <main>:

int
main(int argc, char *argv[])
{
    5164:	c1010113          	addi	sp,sp,-1008
    5168:	3e113423          	sd	ra,1000(sp)
    516c:	3e813023          	sd	s0,992(sp)
    5170:	3c913c23          	sd	s1,984(sp)
    5174:	3d213823          	sd	s2,976(sp)
    5178:	3d313423          	sd	s3,968(sp)
    517c:	3d413023          	sd	s4,960(sp)
    5180:	3b513c23          	sd	s5,952(sp)
    5184:	3b613823          	sd	s6,944(sp)
    5188:	1f80                	addi	s0,sp,1008
    518a:	89aa                	mv	s3,a0
  int continuous = 0;
  char *justone = 0;

  if(argc == 2 && strcmp(argv[1], "-c") == 0){
    518c:	4789                	li	a5,2
    518e:	08f50b63          	beq	a0,a5,5224 <main+0xc0>
    continuous = 1;
  } else if(argc == 2 && strcmp(argv[1], "-C") == 0){
    continuous = 2;
  } else if(argc == 2 && argv[1][0] != '-'){
    justone = argv[1];
  } else if(argc > 1){
    5192:	4785                	li	a5,1
  char *justone = 0;
    5194:	4901                	li	s2,0
  } else if(argc > 1){
    5196:	0ca7c563          	blt	a5,a0,5260 <main+0xfc>
  }
  
  struct test {
    void (*f)(char *);
    char *s;
  } tests[] = {
    519a:	00003797          	auipc	a5,0x3
    519e:	d0678793          	addi	a5,a5,-762 # 7ea0 <malloc+0x2454>
    51a2:	c1040713          	addi	a4,s0,-1008
    51a6:	00003817          	auipc	a6,0x3
    51aa:	09a80813          	addi	a6,a6,154 # 8240 <malloc+0x27f4>
    51ae:	6388                	ld	a0,0(a5)
    51b0:	678c                	ld	a1,8(a5)
    51b2:	6b90                	ld	a2,16(a5)
    51b4:	6f94                	ld	a3,24(a5)
    51b6:	e308                	sd	a0,0(a4)
    51b8:	e70c                	sd	a1,8(a4)
    51ba:	eb10                	sd	a2,16(a4)
    51bc:	ef14                	sd	a3,24(a4)
    51be:	02078793          	addi	a5,a5,32
    51c2:	02070713          	addi	a4,a4,32
    51c6:	ff0794e3          	bne	a5,a6,51ae <main+0x4a>
    51ca:	6394                	ld	a3,0(a5)
    51cc:	679c                	ld	a5,8(a5)
    51ce:	e314                	sd	a3,0(a4)
    51d0:	e71c                	sd	a5,8(a4)
          exit(1);
      }
    }
  }

  printf("usertests starting\n");
    51d2:	00003517          	auipc	a0,0x3
    51d6:	c6e50513          	addi	a0,a0,-914 # 7e40 <malloc+0x23f4>
    51da:	00000097          	auipc	ra,0x0
    51de:	7b4080e7          	jalr	1972(ra) # 598e <printf>
  int free0 = countfree();
    51e2:	00000097          	auipc	ra,0x0
    51e6:	db4080e7          	jalr	-588(ra) # 4f96 <countfree>
    51ea:	8a2a                	mv	s4,a0
  int free1 = 0;
  int fail = 0;
  for (struct test *t = tests; t->s != 0; t++) {
    51ec:	c1843503          	ld	a0,-1000(s0)
    51f0:	c1040493          	addi	s1,s0,-1008
  int fail = 0;
    51f4:	4981                	li	s3,0
    if((justone == 0) || strcmp(t->s, justone) == 0) {
      if(!run(t->f, t->s))
        fail = 1;
    51f6:	4a85                	li	s5,1
  for (struct test *t = tests; t->s != 0; t++) {
    51f8:	e55d                	bnez	a0,52a6 <main+0x142>
  }

  if(fail){
    printf("SOME TESTS FAILED\n");
    exit(1);
  } else if((free1 = countfree()) < free0){
    51fa:	00000097          	auipc	ra,0x0
    51fe:	d9c080e7          	jalr	-612(ra) # 4f96 <countfree>
    5202:	85aa                	mv	a1,a0
    5204:	0f455163          	bge	a0,s4,52e6 <main+0x182>
    printf("FAILED -- lost some free pages %d (out of %d)\n", free1, free0);
    5208:	8652                	mv	a2,s4
    520a:	00003517          	auipc	a0,0x3
    520e:	bee50513          	addi	a0,a0,-1042 # 7df8 <malloc+0x23ac>
    5212:	00000097          	auipc	ra,0x0
    5216:	77c080e7          	jalr	1916(ra) # 598e <printf>
    exit(1);
    521a:	4505                	li	a0,1
    521c:	00000097          	auipc	ra,0x0
    5220:	3f2080e7          	jalr	1010(ra) # 560e <exit>
    5224:	84ae                	mv	s1,a1
  if(argc == 2 && strcmp(argv[1], "-c") == 0){
    5226:	00003597          	auipc	a1,0x3
    522a:	b6a58593          	addi	a1,a1,-1174 # 7d90 <malloc+0x2344>
    522e:	6488                	ld	a0,8(s1)
    5230:	00000097          	auipc	ra,0x0
    5234:	18c080e7          	jalr	396(ra) # 53bc <strcmp>
    5238:	10050563          	beqz	a0,5342 <main+0x1de>
  } else if(argc == 2 && strcmp(argv[1], "-C") == 0){
    523c:	00003597          	auipc	a1,0x3
    5240:	c3c58593          	addi	a1,a1,-964 # 7e78 <malloc+0x242c>
    5244:	6488                	ld	a0,8(s1)
    5246:	00000097          	auipc	ra,0x0
    524a:	176080e7          	jalr	374(ra) # 53bc <strcmp>
    524e:	c97d                	beqz	a0,5344 <main+0x1e0>
  } else if(argc == 2 && argv[1][0] != '-'){
    5250:	0084b903          	ld	s2,8(s1)
    5254:	00094703          	lbu	a4,0(s2)
    5258:	02d00793          	li	a5,45
    525c:	f2f71fe3          	bne	a4,a5,519a <main+0x36>
    printf("Usage: usertests [-c] [testname]\n");
    5260:	00003517          	auipc	a0,0x3
    5264:	b3850513          	addi	a0,a0,-1224 # 7d98 <malloc+0x234c>
    5268:	00000097          	auipc	ra,0x0
    526c:	726080e7          	jalr	1830(ra) # 598e <printf>
    exit(1);
    5270:	4505                	li	a0,1
    5272:	00000097          	auipc	ra,0x0
    5276:	39c080e7          	jalr	924(ra) # 560e <exit>
          exit(1);
    527a:	4505                	li	a0,1
    527c:	00000097          	auipc	ra,0x0
    5280:	392080e7          	jalr	914(ra) # 560e <exit>
        printf("FAILED -- lost %d free pages\n", free0 - free1);
    5284:	40a905bb          	subw	a1,s2,a0
    5288:	855a                	mv	a0,s6
    528a:	00000097          	auipc	ra,0x0
    528e:	704080e7          	jalr	1796(ra) # 598e <printf>
        if(continuous != 2)
    5292:	09498463          	beq	s3,s4,531a <main+0x1b6>
          exit(1);
    5296:	4505                	li	a0,1
    5298:	00000097          	auipc	ra,0x0
    529c:	376080e7          	jalr	886(ra) # 560e <exit>
  for (struct test *t = tests; t->s != 0; t++) {
    52a0:	04c1                	addi	s1,s1,16
    52a2:	6488                	ld	a0,8(s1)
    52a4:	c115                	beqz	a0,52c8 <main+0x164>
    if((justone == 0) || strcmp(t->s, justone) == 0) {
    52a6:	00090863          	beqz	s2,52b6 <main+0x152>
    52aa:	85ca                	mv	a1,s2
    52ac:	00000097          	auipc	ra,0x0
    52b0:	110080e7          	jalr	272(ra) # 53bc <strcmp>
    52b4:	f575                	bnez	a0,52a0 <main+0x13c>
      if(!run(t->f, t->s))
    52b6:	648c                	ld	a1,8(s1)
    52b8:	6088                	ld	a0,0(s1)
    52ba:	00000097          	auipc	ra,0x0
    52be:	e0c080e7          	jalr	-500(ra) # 50c6 <run>
    52c2:	fd79                	bnez	a0,52a0 <main+0x13c>
        fail = 1;
    52c4:	89d6                	mv	s3,s5
    52c6:	bfe9                	j	52a0 <main+0x13c>
  if(fail){
    52c8:	f20989e3          	beqz	s3,51fa <main+0x96>
    printf("SOME TESTS FAILED\n");
    52cc:	00003517          	auipc	a0,0x3
    52d0:	b1450513          	addi	a0,a0,-1260 # 7de0 <malloc+0x2394>
    52d4:	00000097          	auipc	ra,0x0
    52d8:	6ba080e7          	jalr	1722(ra) # 598e <printf>
    exit(1);
    52dc:	4505                	li	a0,1
    52de:	00000097          	auipc	ra,0x0
    52e2:	330080e7          	jalr	816(ra) # 560e <exit>
  } else {
    printf("ALL TESTS PASSED\n");
    52e6:	00003517          	auipc	a0,0x3
    52ea:	b4250513          	addi	a0,a0,-1214 # 7e28 <malloc+0x23dc>
    52ee:	00000097          	auipc	ra,0x0
    52f2:	6a0080e7          	jalr	1696(ra) # 598e <printf>
    exit(0);
    52f6:	4501                	li	a0,0
    52f8:	00000097          	auipc	ra,0x0
    52fc:	316080e7          	jalr	790(ra) # 560e <exit>
        printf("SOME TESTS FAILED\n");
    5300:	8556                	mv	a0,s5
    5302:	00000097          	auipc	ra,0x0
    5306:	68c080e7          	jalr	1676(ra) # 598e <printf>
        if(continuous != 2)
    530a:	f74998e3          	bne	s3,s4,527a <main+0x116>
      int free1 = countfree();
    530e:	00000097          	auipc	ra,0x0
    5312:	c88080e7          	jalr	-888(ra) # 4f96 <countfree>
      if(free1 < free0){
    5316:	f72547e3          	blt	a0,s2,5284 <main+0x120>
      int free0 = countfree();
    531a:	00000097          	auipc	ra,0x0
    531e:	c7c080e7          	jalr	-900(ra) # 4f96 <countfree>
    5322:	892a                	mv	s2,a0
      for (struct test *t = tests; t->s != 0; t++) {
    5324:	c1843583          	ld	a1,-1000(s0)
    5328:	d1fd                	beqz	a1,530e <main+0x1aa>
    532a:	c1040493          	addi	s1,s0,-1008
        if(!run(t->f, t->s)){
    532e:	6088                	ld	a0,0(s1)
    5330:	00000097          	auipc	ra,0x0
    5334:	d96080e7          	jalr	-618(ra) # 50c6 <run>
    5338:	d561                	beqz	a0,5300 <main+0x19c>
      for (struct test *t = tests; t->s != 0; t++) {
    533a:	04c1                	addi	s1,s1,16
    533c:	648c                	ld	a1,8(s1)
    533e:	f9e5                	bnez	a1,532e <main+0x1ca>
    5340:	b7f9                	j	530e <main+0x1aa>
    continuous = 1;
    5342:	4985                	li	s3,1
  } tests[] = {
    5344:	00003797          	auipc	a5,0x3
    5348:	b5c78793          	addi	a5,a5,-1188 # 7ea0 <malloc+0x2454>
    534c:	c1040713          	addi	a4,s0,-1008
    5350:	00003817          	auipc	a6,0x3
    5354:	ef080813          	addi	a6,a6,-272 # 8240 <malloc+0x27f4>
    5358:	6388                	ld	a0,0(a5)
    535a:	678c                	ld	a1,8(a5)
    535c:	6b90                	ld	a2,16(a5)
    535e:	6f94                	ld	a3,24(a5)
    5360:	e308                	sd	a0,0(a4)
    5362:	e70c                	sd	a1,8(a4)
    5364:	eb10                	sd	a2,16(a4)
    5366:	ef14                	sd	a3,24(a4)
    5368:	02078793          	addi	a5,a5,32
    536c:	02070713          	addi	a4,a4,32
    5370:	ff0794e3          	bne	a5,a6,5358 <main+0x1f4>
    5374:	6394                	ld	a3,0(a5)
    5376:	679c                	ld	a5,8(a5)
    5378:	e314                	sd	a3,0(a4)
    537a:	e71c                	sd	a5,8(a4)
    printf("continuous usertests starting\n");
    537c:	00003517          	auipc	a0,0x3
    5380:	adc50513          	addi	a0,a0,-1316 # 7e58 <malloc+0x240c>
    5384:	00000097          	auipc	ra,0x0
    5388:	60a080e7          	jalr	1546(ra) # 598e <printf>
        printf("SOME TESTS FAILED\n");
    538c:	00003a97          	auipc	s5,0x3
    5390:	a54a8a93          	addi	s5,s5,-1452 # 7de0 <malloc+0x2394>
        if(continuous != 2)
    5394:	4a09                	li	s4,2
        printf("FAILED -- lost %d free pages\n", free0 - free1);
    5396:	00003b17          	auipc	s6,0x3
    539a:	a2ab0b13          	addi	s6,s6,-1494 # 7dc0 <malloc+0x2374>
    539e:	bfb5                	j	531a <main+0x1b6>

00000000000053a0 <strcpy>:
#include "kernel/fcntl.h"
#include "user/user.h"

char*
strcpy(char *s, const char *t)
{
    53a0:	1141                	addi	sp,sp,-16
    53a2:	e422                	sd	s0,8(sp)
    53a4:	0800                	addi	s0,sp,16
  char *os;

  os = s;
  while((*s++ = *t++) != 0)
    53a6:	87aa                	mv	a5,a0
    53a8:	0585                	addi	a1,a1,1
    53aa:	0785                	addi	a5,a5,1
    53ac:	fff5c703          	lbu	a4,-1(a1)
    53b0:	fee78fa3          	sb	a4,-1(a5)
    53b4:	fb75                	bnez	a4,53a8 <strcpy+0x8>
    ;
  return os;
}
    53b6:	6422                	ld	s0,8(sp)
    53b8:	0141                	addi	sp,sp,16
    53ba:	8082                	ret

00000000000053bc <strcmp>:

int
strcmp(const char *p, const char *q)
{
    53bc:	1141                	addi	sp,sp,-16
    53be:	e422                	sd	s0,8(sp)
    53c0:	0800                	addi	s0,sp,16
  while(*p && *p == *q)
    53c2:	00054783          	lbu	a5,0(a0)
    53c6:	cb91                	beqz	a5,53da <strcmp+0x1e>
    53c8:	0005c703          	lbu	a4,0(a1)
    53cc:	00f71763          	bne	a4,a5,53da <strcmp+0x1e>
    p++, q++;
    53d0:	0505                	addi	a0,a0,1
    53d2:	0585                	addi	a1,a1,1
  while(*p && *p == *q)
    53d4:	00054783          	lbu	a5,0(a0)
    53d8:	fbe5                	bnez	a5,53c8 <strcmp+0xc>
  return (uchar)*p - (uchar)*q;
    53da:	0005c503          	lbu	a0,0(a1)
}
    53de:	40a7853b          	subw	a0,a5,a0
    53e2:	6422                	ld	s0,8(sp)
    53e4:	0141                	addi	sp,sp,16
    53e6:	8082                	ret

00000000000053e8 <strlen>:

uint
strlen(const char *s)
{
    53e8:	1141                	addi	sp,sp,-16
    53ea:	e422                	sd	s0,8(sp)
    53ec:	0800                	addi	s0,sp,16
  int n;

  for(n = 0; s[n]; n++)
    53ee:	00054783          	lbu	a5,0(a0)
    53f2:	cf91                	beqz	a5,540e <strlen+0x26>
    53f4:	0505                	addi	a0,a0,1
    53f6:	87aa                	mv	a5,a0
    53f8:	4685                	li	a3,1
    53fa:	9e89                	subw	a3,a3,a0
    53fc:	00f6853b          	addw	a0,a3,a5
    5400:	0785                	addi	a5,a5,1
    5402:	fff7c703          	lbu	a4,-1(a5)
    5406:	fb7d                	bnez	a4,53fc <strlen+0x14>
    ;
  return n;
}
    5408:	6422                	ld	s0,8(sp)
    540a:	0141                	addi	sp,sp,16
    540c:	8082                	ret
  for(n = 0; s[n]; n++)
    540e:	4501                	li	a0,0
    5410:	bfe5                	j	5408 <strlen+0x20>

0000000000005412 <memset>:

void*
memset(void *dst, int c, uint n)
{
    5412:	1141                	addi	sp,sp,-16
    5414:	e422                	sd	s0,8(sp)
    5416:	0800                	addi	s0,sp,16
  char *cdst = (char *) dst;
  int i;
  for(i = 0; i < n; i++){
    5418:	ca19                	beqz	a2,542e <memset+0x1c>
    541a:	87aa                	mv	a5,a0
    541c:	1602                	slli	a2,a2,0x20
    541e:	9201                	srli	a2,a2,0x20
    5420:	00a60733          	add	a4,a2,a0
    cdst[i] = c;
    5424:	00b78023          	sb	a1,0(a5)
  for(i = 0; i < n; i++){
    5428:	0785                	addi	a5,a5,1
    542a:	fee79de3          	bne	a5,a4,5424 <memset+0x12>
  }
  return dst;
}
    542e:	6422                	ld	s0,8(sp)
    5430:	0141                	addi	sp,sp,16
    5432:	8082                	ret

0000000000005434 <strchr>:

char*
strchr(const char *s, char c)
{
    5434:	1141                	addi	sp,sp,-16
    5436:	e422                	sd	s0,8(sp)
    5438:	0800                	addi	s0,sp,16
  for(; *s; s++)
    543a:	00054783          	lbu	a5,0(a0)
    543e:	cb99                	beqz	a5,5454 <strchr+0x20>
    if(*s == c)
    5440:	00f58763          	beq	a1,a5,544e <strchr+0x1a>
  for(; *s; s++)
    5444:	0505                	addi	a0,a0,1
    5446:	00054783          	lbu	a5,0(a0)
    544a:	fbfd                	bnez	a5,5440 <strchr+0xc>
      return (char*)s;
  return 0;
    544c:	4501                	li	a0,0
}
    544e:	6422                	ld	s0,8(sp)
    5450:	0141                	addi	sp,sp,16
    5452:	8082                	ret
  return 0;
    5454:	4501                	li	a0,0
    5456:	bfe5                	j	544e <strchr+0x1a>

0000000000005458 <gets>:

char*
gets(char *buf, int max)
{
    5458:	711d                	addi	sp,sp,-96
    545a:	ec86                	sd	ra,88(sp)
    545c:	e8a2                	sd	s0,80(sp)
    545e:	e4a6                	sd	s1,72(sp)
    5460:	e0ca                	sd	s2,64(sp)
    5462:	fc4e                	sd	s3,56(sp)
    5464:	f852                	sd	s4,48(sp)
    5466:	f456                	sd	s5,40(sp)
    5468:	f05a                	sd	s6,32(sp)
    546a:	ec5e                	sd	s7,24(sp)
    546c:	1080                	addi	s0,sp,96
    546e:	8baa                	mv	s7,a0
    5470:	8a2e                	mv	s4,a1
  int i, cc;
  char c;

  for(i=0; i+1 < max; ){
    5472:	892a                	mv	s2,a0
    5474:	4481                	li	s1,0
    cc = read(0, &c, 1);
    if(cc < 1)
      break;
    buf[i++] = c;
    if(c == '\n' || c == '\r')
    5476:	4aa9                	li	s5,10
    5478:	4b35                	li	s6,13
  for(i=0; i+1 < max; ){
    547a:	89a6                	mv	s3,s1
    547c:	2485                	addiw	s1,s1,1
    547e:	0344d863          	bge	s1,s4,54ae <gets+0x56>
    cc = read(0, &c, 1);
    5482:	4605                	li	a2,1
    5484:	faf40593          	addi	a1,s0,-81
    5488:	4501                	li	a0,0
    548a:	00000097          	auipc	ra,0x0
    548e:	19c080e7          	jalr	412(ra) # 5626 <read>
    if(cc < 1)
    5492:	00a05e63          	blez	a0,54ae <gets+0x56>
    buf[i++] = c;
    5496:	faf44783          	lbu	a5,-81(s0)
    549a:	00f90023          	sb	a5,0(s2)
    if(c == '\n' || c == '\r')
    549e:	01578763          	beq	a5,s5,54ac <gets+0x54>
    54a2:	0905                	addi	s2,s2,1
    54a4:	fd679be3          	bne	a5,s6,547a <gets+0x22>
  for(i=0; i+1 < max; ){
    54a8:	89a6                	mv	s3,s1
    54aa:	a011                	j	54ae <gets+0x56>
    54ac:	89a6                	mv	s3,s1
      break;
  }
  buf[i] = '\0';
    54ae:	99de                	add	s3,s3,s7
    54b0:	00098023          	sb	zero,0(s3)
  return buf;
}
    54b4:	855e                	mv	a0,s7
    54b6:	60e6                	ld	ra,88(sp)
    54b8:	6446                	ld	s0,80(sp)
    54ba:	64a6                	ld	s1,72(sp)
    54bc:	6906                	ld	s2,64(sp)
    54be:	79e2                	ld	s3,56(sp)
    54c0:	7a42                	ld	s4,48(sp)
    54c2:	7aa2                	ld	s5,40(sp)
    54c4:	7b02                	ld	s6,32(sp)
    54c6:	6be2                	ld	s7,24(sp)
    54c8:	6125                	addi	sp,sp,96
    54ca:	8082                	ret

00000000000054cc <stat>:

int
stat(const char *n, struct stat *st)
{
    54cc:	1101                	addi	sp,sp,-32
    54ce:	ec06                	sd	ra,24(sp)
    54d0:	e822                	sd	s0,16(sp)
    54d2:	e426                	sd	s1,8(sp)
    54d4:	e04a                	sd	s2,0(sp)
    54d6:	1000                	addi	s0,sp,32
    54d8:	892e                	mv	s2,a1
  int fd;
  int r;

  fd = open(n, O_RDONLY);
    54da:	4581                	li	a1,0
    54dc:	00000097          	auipc	ra,0x0
    54e0:	172080e7          	jalr	370(ra) # 564e <open>
  if(fd < 0)
    54e4:	02054563          	bltz	a0,550e <stat+0x42>
    54e8:	84aa                	mv	s1,a0
    return -1;
  r = fstat(fd, st);
    54ea:	85ca                	mv	a1,s2
    54ec:	00000097          	auipc	ra,0x0
    54f0:	17a080e7          	jalr	378(ra) # 5666 <fstat>
    54f4:	892a                	mv	s2,a0
  close(fd);
    54f6:	8526                	mv	a0,s1
    54f8:	00000097          	auipc	ra,0x0
    54fc:	13e080e7          	jalr	318(ra) # 5636 <close>
  return r;
}
    5500:	854a                	mv	a0,s2
    5502:	60e2                	ld	ra,24(sp)
    5504:	6442                	ld	s0,16(sp)
    5506:	64a2                	ld	s1,8(sp)
    5508:	6902                	ld	s2,0(sp)
    550a:	6105                	addi	sp,sp,32
    550c:	8082                	ret
    return -1;
    550e:	597d                	li	s2,-1
    5510:	bfc5                	j	5500 <stat+0x34>

0000000000005512 <atoi>:

int
atoi(const char *s)
{
    5512:	1141                	addi	sp,sp,-16
    5514:	e422                	sd	s0,8(sp)
    5516:	0800                	addi	s0,sp,16
  int n;

  n = 0;
  while('0' <= *s && *s <= '9')
    5518:	00054603          	lbu	a2,0(a0)
    551c:	fd06079b          	addiw	a5,a2,-48
    5520:	0ff7f793          	andi	a5,a5,255
    5524:	4725                	li	a4,9
    5526:	02f76963          	bltu	a4,a5,5558 <atoi+0x46>
    552a:	86aa                	mv	a3,a0
  n = 0;
    552c:	4501                	li	a0,0
  while('0' <= *s && *s <= '9')
    552e:	45a5                	li	a1,9
    n = n*10 + *s++ - '0';
    5530:	0685                	addi	a3,a3,1
    5532:	0025179b          	slliw	a5,a0,0x2
    5536:	9fa9                	addw	a5,a5,a0
    5538:	0017979b          	slliw	a5,a5,0x1
    553c:	9fb1                	addw	a5,a5,a2
    553e:	fd07851b          	addiw	a0,a5,-48
  while('0' <= *s && *s <= '9')
    5542:	0006c603          	lbu	a2,0(a3)
    5546:	fd06071b          	addiw	a4,a2,-48
    554a:	0ff77713          	andi	a4,a4,255
    554e:	fee5f1e3          	bgeu	a1,a4,5530 <atoi+0x1e>
  return n;
}
    5552:	6422                	ld	s0,8(sp)
    5554:	0141                	addi	sp,sp,16
    5556:	8082                	ret
  n = 0;
    5558:	4501                	li	a0,0
    555a:	bfe5                	j	5552 <atoi+0x40>

000000000000555c <memmove>:

void*
memmove(void *vdst, const void *vsrc, int n)
{
    555c:	1141                	addi	sp,sp,-16
    555e:	e422                	sd	s0,8(sp)
    5560:	0800                	addi	s0,sp,16
  char *dst;
  const char *src;

  dst = vdst;
  src = vsrc;
  if (src > dst) {
    5562:	02b57463          	bgeu	a0,a1,558a <memmove+0x2e>
    while(n-- > 0)
    5566:	00c05f63          	blez	a2,5584 <memmove+0x28>
    556a:	1602                	slli	a2,a2,0x20
    556c:	9201                	srli	a2,a2,0x20
    556e:	00c507b3          	add	a5,a0,a2
  dst = vdst;
    5572:	872a                	mv	a4,a0
      *dst++ = *src++;
    5574:	0585                	addi	a1,a1,1
    5576:	0705                	addi	a4,a4,1
    5578:	fff5c683          	lbu	a3,-1(a1)
    557c:	fed70fa3          	sb	a3,-1(a4)
    while(n-- > 0)
    5580:	fee79ae3          	bne	a5,a4,5574 <memmove+0x18>
    src += n;
    while(n-- > 0)
      *--dst = *--src;
  }
  return vdst;
}
    5584:	6422                	ld	s0,8(sp)
    5586:	0141                	addi	sp,sp,16
    5588:	8082                	ret
    dst += n;
    558a:	00c50733          	add	a4,a0,a2
    src += n;
    558e:	95b2                	add	a1,a1,a2
    while(n-- > 0)
    5590:	fec05ae3          	blez	a2,5584 <memmove+0x28>
    5594:	fff6079b          	addiw	a5,a2,-1
    5598:	1782                	slli	a5,a5,0x20
    559a:	9381                	srli	a5,a5,0x20
    559c:	fff7c793          	not	a5,a5
    55a0:	97ba                	add	a5,a5,a4
      *--dst = *--src;
    55a2:	15fd                	addi	a1,a1,-1
    55a4:	177d                	addi	a4,a4,-1
    55a6:	0005c683          	lbu	a3,0(a1)
    55aa:	00d70023          	sb	a3,0(a4)
    while(n-- > 0)
    55ae:	fee79ae3          	bne	a5,a4,55a2 <memmove+0x46>
    55b2:	bfc9                	j	5584 <memmove+0x28>

00000000000055b4 <memcmp>:

int
memcmp(const void *s1, const void *s2, uint n)
{
    55b4:	1141                	addi	sp,sp,-16
    55b6:	e422                	sd	s0,8(sp)
    55b8:	0800                	addi	s0,sp,16
  const char *p1 = s1, *p2 = s2;
  while (n-- > 0) {
    55ba:	ca05                	beqz	a2,55ea <memcmp+0x36>
    55bc:	fff6069b          	addiw	a3,a2,-1
    55c0:	1682                	slli	a3,a3,0x20
    55c2:	9281                	srli	a3,a3,0x20
    55c4:	0685                	addi	a3,a3,1
    55c6:	96aa                	add	a3,a3,a0
    if (*p1 != *p2) {
    55c8:	00054783          	lbu	a5,0(a0)
    55cc:	0005c703          	lbu	a4,0(a1)
    55d0:	00e79863          	bne	a5,a4,55e0 <memcmp+0x2c>
      return *p1 - *p2;
    }
    p1++;
    55d4:	0505                	addi	a0,a0,1
    p2++;
    55d6:	0585                	addi	a1,a1,1
  while (n-- > 0) {
    55d8:	fed518e3          	bne	a0,a3,55c8 <memcmp+0x14>
  }
  return 0;
    55dc:	4501                	li	a0,0
    55de:	a019                	j	55e4 <memcmp+0x30>
      return *p1 - *p2;
    55e0:	40e7853b          	subw	a0,a5,a4
}
    55e4:	6422                	ld	s0,8(sp)
    55e6:	0141                	addi	sp,sp,16
    55e8:	8082                	ret
  return 0;
    55ea:	4501                	li	a0,0
    55ec:	bfe5                	j	55e4 <memcmp+0x30>

00000000000055ee <memcpy>:

void *
memcpy(void *dst, const void *src, uint n)
{
    55ee:	1141                	addi	sp,sp,-16
    55f0:	e406                	sd	ra,8(sp)
    55f2:	e022                	sd	s0,0(sp)
    55f4:	0800                	addi	s0,sp,16
  return memmove(dst, src, n);
    55f6:	00000097          	auipc	ra,0x0
    55fa:	f66080e7          	jalr	-154(ra) # 555c <memmove>
}
    55fe:	60a2                	ld	ra,8(sp)
    5600:	6402                	ld	s0,0(sp)
    5602:	0141                	addi	sp,sp,16
    5604:	8082                	ret

0000000000005606 <fork>:
# generated by usys.pl - do not edit
#include "kernel/syscall.h"
.global fork
fork:
 li a7, SYS_fork
    5606:	4885                	li	a7,1
 ecall
    5608:	00000073          	ecall
 ret
    560c:	8082                	ret

000000000000560e <exit>:
.global exit
exit:
 li a7, SYS_exit
    560e:	4889                	li	a7,2
 ecall
    5610:	00000073          	ecall
 ret
    5614:	8082                	ret

0000000000005616 <wait>:
.global wait
wait:
 li a7, SYS_wait
    5616:	488d                	li	a7,3
 ecall
    5618:	00000073          	ecall
 ret
    561c:	8082                	ret

000000000000561e <pipe>:
.global pipe
pipe:
 li a7, SYS_pipe
    561e:	4891                	li	a7,4
 ecall
    5620:	00000073          	ecall
 ret
    5624:	8082                	ret

0000000000005626 <read>:
.global read
read:
 li a7, SYS_read
    5626:	4895                	li	a7,5
 ecall
    5628:	00000073          	ecall
 ret
    562c:	8082                	ret

000000000000562e <write>:
.global write
write:
 li a7, SYS_write
    562e:	48c1                	li	a7,16
 ecall
    5630:	00000073          	ecall
 ret
    5634:	8082                	ret

0000000000005636 <close>:
.global close
close:
 li a7, SYS_close
    5636:	48d5                	li	a7,21
 ecall
    5638:	00000073          	ecall
 ret
    563c:	8082                	ret

000000000000563e <kill>:
.global kill
kill:
 li a7, SYS_kill
    563e:	4899                	li	a7,6
 ecall
    5640:	00000073          	ecall
 ret
    5644:	8082                	ret

0000000000005646 <exec>:
.global exec
exec:
 li a7, SYS_exec
    5646:	489d                	li	a7,7
 ecall
    5648:	00000073          	ecall
 ret
    564c:	8082                	ret

000000000000564e <open>:
.global open
open:
 li a7, SYS_open
    564e:	48bd                	li	a7,15
 ecall
    5650:	00000073          	ecall
 ret
    5654:	8082                	ret

0000000000005656 <mknod>:
.global mknod
mknod:
 li a7, SYS_mknod
    5656:	48c5                	li	a7,17
 ecall
    5658:	00000073          	ecall
 ret
    565c:	8082                	ret

000000000000565e <unlink>:
.global unlink
unlink:
 li a7, SYS_unlink
    565e:	48c9                	li	a7,18
 ecall
    5660:	00000073          	ecall
 ret
    5664:	8082                	ret

0000000000005666 <fstat>:
.global fstat
fstat:
 li a7, SYS_fstat
    5666:	48a1                	li	a7,8
 ecall
    5668:	00000073          	ecall
 ret
    566c:	8082                	ret

000000000000566e <link>:
.global link
link:
 li a7, SYS_link
    566e:	48cd                	li	a7,19
 ecall
    5670:	00000073          	ecall
 ret
    5674:	8082                	ret

0000000000005676 <mkdir>:
.global mkdir
mkdir:
 li a7, SYS_mkdir
    5676:	48d1                	li	a7,20
 ecall
    5678:	00000073          	ecall
 ret
    567c:	8082                	ret

000000000000567e <chdir>:
.global chdir
chdir:
 li a7, SYS_chdir
    567e:	48a5                	li	a7,9
 ecall
    5680:	00000073          	ecall
 ret
    5684:	8082                	ret

0000000000005686 <dup>:
.global dup
dup:
 li a7, SYS_dup
    5686:	48a9                	li	a7,10
 ecall
    5688:	00000073          	ecall
 ret
    568c:	8082                	ret

000000000000568e <getpid>:
.global getpid
getpid:
 li a7, SYS_getpid
    568e:	48ad                	li	a7,11
 ecall
    5690:	00000073          	ecall
 ret
    5694:	8082                	ret

0000000000005696 <sbrk>:
.global sbrk
sbrk:
 li a7, SYS_sbrk
    5696:	48b1                	li	a7,12
 ecall
    5698:	00000073          	ecall
 ret
    569c:	8082                	ret

000000000000569e <sleep>:
.global sleep
sleep:
 li a7, SYS_sleep
    569e:	48b5                	li	a7,13
 ecall
    56a0:	00000073          	ecall
 ret
    56a4:	8082                	ret

00000000000056a6 <uptime>:
.global uptime
uptime:
 li a7, SYS_uptime
    56a6:	48b9                	li	a7,14
 ecall
    56a8:	00000073          	ecall
 ret
    56ac:	8082                	ret

00000000000056ae <symlink>:
.global symlink
symlink:
 li a7, SYS_symlink
    56ae:	48d9                	li	a7,22
 ecall
    56b0:	00000073          	ecall
 ret
    56b4:	8082                	ret

00000000000056b6 <putc>:

static char digits[] = "0123456789ABCDEF";

static void
putc(int fd, char c)
{
    56b6:	1101                	addi	sp,sp,-32
    56b8:	ec06                	sd	ra,24(sp)
    56ba:	e822                	sd	s0,16(sp)
    56bc:	1000                	addi	s0,sp,32
    56be:	feb407a3          	sb	a1,-17(s0)
  write(fd, &c, 1);
    56c2:	4605                	li	a2,1
    56c4:	fef40593          	addi	a1,s0,-17
    56c8:	00000097          	auipc	ra,0x0
    56cc:	f66080e7          	jalr	-154(ra) # 562e <write>
}
    56d0:	60e2                	ld	ra,24(sp)
    56d2:	6442                	ld	s0,16(sp)
    56d4:	6105                	addi	sp,sp,32
    56d6:	8082                	ret

00000000000056d8 <printint>:

static void
printint(int fd, int xx, int base, int sgn)
{
    56d8:	7139                	addi	sp,sp,-64
    56da:	fc06                	sd	ra,56(sp)
    56dc:	f822                	sd	s0,48(sp)
    56de:	f426                	sd	s1,40(sp)
    56e0:	f04a                	sd	s2,32(sp)
    56e2:	ec4e                	sd	s3,24(sp)
    56e4:	0080                	addi	s0,sp,64
    56e6:	84aa                	mv	s1,a0
  char buf[16];
  int i, neg;
  uint x;

  neg = 0;
  if(sgn && xx < 0){
    56e8:	c299                	beqz	a3,56ee <printint+0x16>
    56ea:	0805c863          	bltz	a1,577a <printint+0xa2>
    neg = 1;
    x = -xx;
  } else {
    x = xx;
    56ee:	2581                	sext.w	a1,a1
  neg = 0;
    56f0:	4881                	li	a7,0
    56f2:	fc040693          	addi	a3,s0,-64
  }

  i = 0;
    56f6:	4701                	li	a4,0
  do{
    buf[i++] = digits[x % base];
    56f8:	2601                	sext.w	a2,a2
    56fa:	00003517          	auipc	a0,0x3
    56fe:	b5e50513          	addi	a0,a0,-1186 # 8258 <digits>
    5702:	883a                	mv	a6,a4
    5704:	2705                	addiw	a4,a4,1
    5706:	02c5f7bb          	remuw	a5,a1,a2
    570a:	1782                	slli	a5,a5,0x20
    570c:	9381                	srli	a5,a5,0x20
    570e:	97aa                	add	a5,a5,a0
    5710:	0007c783          	lbu	a5,0(a5)
    5714:	00f68023          	sb	a5,0(a3)
  }while((x /= base) != 0);
    5718:	0005879b          	sext.w	a5,a1
    571c:	02c5d5bb          	divuw	a1,a1,a2
    5720:	0685                	addi	a3,a3,1
    5722:	fec7f0e3          	bgeu	a5,a2,5702 <printint+0x2a>
  if(neg)
    5726:	00088b63          	beqz	a7,573c <printint+0x64>
    buf[i++] = '-';
    572a:	fd040793          	addi	a5,s0,-48
    572e:	973e                	add	a4,a4,a5
    5730:	02d00793          	li	a5,45
    5734:	fef70823          	sb	a5,-16(a4)
    5738:	0028071b          	addiw	a4,a6,2

  while(--i >= 0)
    573c:	02e05863          	blez	a4,576c <printint+0x94>
    5740:	fc040793          	addi	a5,s0,-64
    5744:	00e78933          	add	s2,a5,a4
    5748:	fff78993          	addi	s3,a5,-1
    574c:	99ba                	add	s3,s3,a4
    574e:	377d                	addiw	a4,a4,-1
    5750:	1702                	slli	a4,a4,0x20
    5752:	9301                	srli	a4,a4,0x20
    5754:	40e989b3          	sub	s3,s3,a4
    putc(fd, buf[i]);
    5758:	fff94583          	lbu	a1,-1(s2)
    575c:	8526                	mv	a0,s1
    575e:	00000097          	auipc	ra,0x0
    5762:	f58080e7          	jalr	-168(ra) # 56b6 <putc>
  while(--i >= 0)
    5766:	197d                	addi	s2,s2,-1
    5768:	ff3918e3          	bne	s2,s3,5758 <printint+0x80>
}
    576c:	70e2                	ld	ra,56(sp)
    576e:	7442                	ld	s0,48(sp)
    5770:	74a2                	ld	s1,40(sp)
    5772:	7902                	ld	s2,32(sp)
    5774:	69e2                	ld	s3,24(sp)
    5776:	6121                	addi	sp,sp,64
    5778:	8082                	ret
    x = -xx;
    577a:	40b005bb          	negw	a1,a1
    neg = 1;
    577e:	4885                	li	a7,1
    x = -xx;
    5780:	bf8d                	j	56f2 <printint+0x1a>

0000000000005782 <vprintf>:
}

// Print to the given fd. Only understands %d, %x, %p, %s.
void
vprintf(int fd, const char *fmt, va_list ap)
{
    5782:	7119                	addi	sp,sp,-128
    5784:	fc86                	sd	ra,120(sp)
    5786:	f8a2                	sd	s0,112(sp)
    5788:	f4a6                	sd	s1,104(sp)
    578a:	f0ca                	sd	s2,96(sp)
    578c:	ecce                	sd	s3,88(sp)
    578e:	e8d2                	sd	s4,80(sp)
    5790:	e4d6                	sd	s5,72(sp)
    5792:	e0da                	sd	s6,64(sp)
    5794:	fc5e                	sd	s7,56(sp)
    5796:	f862                	sd	s8,48(sp)
    5798:	f466                	sd	s9,40(sp)
    579a:	f06a                	sd	s10,32(sp)
    579c:	ec6e                	sd	s11,24(sp)
    579e:	0100                	addi	s0,sp,128
  char *s;
  int c, i, state;

  state = 0;
  for(i = 0; fmt[i]; i++){
    57a0:	0005c903          	lbu	s2,0(a1)
    57a4:	18090f63          	beqz	s2,5942 <vprintf+0x1c0>
    57a8:	8aaa                	mv	s5,a0
    57aa:	8b32                	mv	s6,a2
    57ac:	00158493          	addi	s1,a1,1
  state = 0;
    57b0:	4981                	li	s3,0
      if(c == '%'){
        state = '%';
      } else {
        putc(fd, c);
      }
    } else if(state == '%'){
    57b2:	02500a13          	li	s4,37
      if(c == 'd'){
    57b6:	06400c13          	li	s8,100
        printint(fd, va_arg(ap, int), 10, 1);
      } else if(c == 'l') {
    57ba:	06c00c93          	li	s9,108
        printint(fd, va_arg(ap, uint64), 10, 0);
      } else if(c == 'x') {
    57be:	07800d13          	li	s10,120
        printint(fd, va_arg(ap, int), 16, 0);
      } else if(c == 'p') {
    57c2:	07000d93          	li	s11,112
    putc(fd, digits[x >> (sizeof(uint64) * 8 - 4)]);
    57c6:	00003b97          	auipc	s7,0x3
    57ca:	a92b8b93          	addi	s7,s7,-1390 # 8258 <digits>
    57ce:	a839                	j	57ec <vprintf+0x6a>
        putc(fd, c);
    57d0:	85ca                	mv	a1,s2
    57d2:	8556                	mv	a0,s5
    57d4:	00000097          	auipc	ra,0x0
    57d8:	ee2080e7          	jalr	-286(ra) # 56b6 <putc>
    57dc:	a019                	j	57e2 <vprintf+0x60>
    } else if(state == '%'){
    57de:	01498f63          	beq	s3,s4,57fc <vprintf+0x7a>
  for(i = 0; fmt[i]; i++){
    57e2:	0485                	addi	s1,s1,1
    57e4:	fff4c903          	lbu	s2,-1(s1)
    57e8:	14090d63          	beqz	s2,5942 <vprintf+0x1c0>
    c = fmt[i] & 0xff;
    57ec:	0009079b          	sext.w	a5,s2
    if(state == 0){
    57f0:	fe0997e3          	bnez	s3,57de <vprintf+0x5c>
      if(c == '%'){
    57f4:	fd479ee3          	bne	a5,s4,57d0 <vprintf+0x4e>
        state = '%';
    57f8:	89be                	mv	s3,a5
    57fa:	b7e5                	j	57e2 <vprintf+0x60>
      if(c == 'd'){
    57fc:	05878063          	beq	a5,s8,583c <vprintf+0xba>
      } else if(c == 'l') {
    5800:	05978c63          	beq	a5,s9,5858 <vprintf+0xd6>
      } else if(c == 'x') {
    5804:	07a78863          	beq	a5,s10,5874 <vprintf+0xf2>
      } else if(c == 'p') {
    5808:	09b78463          	beq	a5,s11,5890 <vprintf+0x10e>
        printptr(fd, va_arg(ap, uint64));
      } else if(c == 's'){
    580c:	07300713          	li	a4,115
    5810:	0ce78663          	beq	a5,a4,58dc <vprintf+0x15a>
          s = "(null)";
        while(*s != 0){
          putc(fd, *s);
          s++;
        }
      } else if(c == 'c'){
    5814:	06300713          	li	a4,99
    5818:	0ee78e63          	beq	a5,a4,5914 <vprintf+0x192>
        putc(fd, va_arg(ap, uint));
      } else if(c == '%'){
    581c:	11478863          	beq	a5,s4,592c <vprintf+0x1aa>
        putc(fd, c);
      } else {
        // Unknown % sequence.  Print it to draw attention.
        putc(fd, '%');
    5820:	85d2                	mv	a1,s4
    5822:	8556                	mv	a0,s5
    5824:	00000097          	auipc	ra,0x0
    5828:	e92080e7          	jalr	-366(ra) # 56b6 <putc>
        putc(fd, c);
    582c:	85ca                	mv	a1,s2
    582e:	8556                	mv	a0,s5
    5830:	00000097          	auipc	ra,0x0
    5834:	e86080e7          	jalr	-378(ra) # 56b6 <putc>
      }
      state = 0;
    5838:	4981                	li	s3,0
    583a:	b765                	j	57e2 <vprintf+0x60>
        printint(fd, va_arg(ap, int), 10, 1);
    583c:	008b0913          	addi	s2,s6,8
    5840:	4685                	li	a3,1
    5842:	4629                	li	a2,10
    5844:	000b2583          	lw	a1,0(s6)
    5848:	8556                	mv	a0,s5
    584a:	00000097          	auipc	ra,0x0
    584e:	e8e080e7          	jalr	-370(ra) # 56d8 <printint>
    5852:	8b4a                	mv	s6,s2
      state = 0;
    5854:	4981                	li	s3,0
    5856:	b771                	j	57e2 <vprintf+0x60>
        printint(fd, va_arg(ap, uint64), 10, 0);
    5858:	008b0913          	addi	s2,s6,8
    585c:	4681                	li	a3,0
    585e:	4629                	li	a2,10
    5860:	000b2583          	lw	a1,0(s6)
    5864:	8556                	mv	a0,s5
    5866:	00000097          	auipc	ra,0x0
    586a:	e72080e7          	jalr	-398(ra) # 56d8 <printint>
    586e:	8b4a                	mv	s6,s2
      state = 0;
    5870:	4981                	li	s3,0
    5872:	bf85                	j	57e2 <vprintf+0x60>
        printint(fd, va_arg(ap, int), 16, 0);
    5874:	008b0913          	addi	s2,s6,8
    5878:	4681                	li	a3,0
    587a:	4641                	li	a2,16
    587c:	000b2583          	lw	a1,0(s6)
    5880:	8556                	mv	a0,s5
    5882:	00000097          	auipc	ra,0x0
    5886:	e56080e7          	jalr	-426(ra) # 56d8 <printint>
    588a:	8b4a                	mv	s6,s2
      state = 0;
    588c:	4981                	li	s3,0
    588e:	bf91                	j	57e2 <vprintf+0x60>
        printptr(fd, va_arg(ap, uint64));
    5890:	008b0793          	addi	a5,s6,8
    5894:	f8f43423          	sd	a5,-120(s0)
    5898:	000b3983          	ld	s3,0(s6)
  putc(fd, '0');
    589c:	03000593          	li	a1,48
    58a0:	8556                	mv	a0,s5
    58a2:	00000097          	auipc	ra,0x0
    58a6:	e14080e7          	jalr	-492(ra) # 56b6 <putc>
  putc(fd, 'x');
    58aa:	85ea                	mv	a1,s10
    58ac:	8556                	mv	a0,s5
    58ae:	00000097          	auipc	ra,0x0
    58b2:	e08080e7          	jalr	-504(ra) # 56b6 <putc>
    58b6:	4941                	li	s2,16
    putc(fd, digits[x >> (sizeof(uint64) * 8 - 4)]);
    58b8:	03c9d793          	srli	a5,s3,0x3c
    58bc:	97de                	add	a5,a5,s7
    58be:	0007c583          	lbu	a1,0(a5)
    58c2:	8556                	mv	a0,s5
    58c4:	00000097          	auipc	ra,0x0
    58c8:	df2080e7          	jalr	-526(ra) # 56b6 <putc>
  for (i = 0; i < (sizeof(uint64) * 2); i++, x <<= 4)
    58cc:	0992                	slli	s3,s3,0x4
    58ce:	397d                	addiw	s2,s2,-1
    58d0:	fe0914e3          	bnez	s2,58b8 <vprintf+0x136>
        printptr(fd, va_arg(ap, uint64));
    58d4:	f8843b03          	ld	s6,-120(s0)
      state = 0;
    58d8:	4981                	li	s3,0
    58da:	b721                	j	57e2 <vprintf+0x60>
        s = va_arg(ap, char*);
    58dc:	008b0993          	addi	s3,s6,8
    58e0:	000b3903          	ld	s2,0(s6)
        if(s == 0)
    58e4:	02090163          	beqz	s2,5906 <vprintf+0x184>
        while(*s != 0){
    58e8:	00094583          	lbu	a1,0(s2)
    58ec:	c9a1                	beqz	a1,593c <vprintf+0x1ba>
          putc(fd, *s);
    58ee:	8556                	mv	a0,s5
    58f0:	00000097          	auipc	ra,0x0
    58f4:	dc6080e7          	jalr	-570(ra) # 56b6 <putc>
          s++;
    58f8:	0905                	addi	s2,s2,1
        while(*s != 0){
    58fa:	00094583          	lbu	a1,0(s2)
    58fe:	f9e5                	bnez	a1,58ee <vprintf+0x16c>
        s = va_arg(ap, char*);
    5900:	8b4e                	mv	s6,s3
      state = 0;
    5902:	4981                	li	s3,0
    5904:	bdf9                	j	57e2 <vprintf+0x60>
          s = "(null)";
    5906:	00003917          	auipc	s2,0x3
    590a:	94a90913          	addi	s2,s2,-1718 # 8250 <malloc+0x2804>
        while(*s != 0){
    590e:	02800593          	li	a1,40
    5912:	bff1                	j	58ee <vprintf+0x16c>
        putc(fd, va_arg(ap, uint));
    5914:	008b0913          	addi	s2,s6,8
    5918:	000b4583          	lbu	a1,0(s6)
    591c:	8556                	mv	a0,s5
    591e:	00000097          	auipc	ra,0x0
    5922:	d98080e7          	jalr	-616(ra) # 56b6 <putc>
    5926:	8b4a                	mv	s6,s2
      state = 0;
    5928:	4981                	li	s3,0
    592a:	bd65                	j	57e2 <vprintf+0x60>
        putc(fd, c);
    592c:	85d2                	mv	a1,s4
    592e:	8556                	mv	a0,s5
    5930:	00000097          	auipc	ra,0x0
    5934:	d86080e7          	jalr	-634(ra) # 56b6 <putc>
      state = 0;
    5938:	4981                	li	s3,0
    593a:	b565                	j	57e2 <vprintf+0x60>
        s = va_arg(ap, char*);
    593c:	8b4e                	mv	s6,s3
      state = 0;
    593e:	4981                	li	s3,0
    5940:	b54d                	j	57e2 <vprintf+0x60>
    }
  }
}
    5942:	70e6                	ld	ra,120(sp)
    5944:	7446                	ld	s0,112(sp)
    5946:	74a6                	ld	s1,104(sp)
    5948:	7906                	ld	s2,96(sp)
    594a:	69e6                	ld	s3,88(sp)
    594c:	6a46                	ld	s4,80(sp)
    594e:	6aa6                	ld	s5,72(sp)
    5950:	6b06                	ld	s6,64(sp)
    5952:	7be2                	ld	s7,56(sp)
    5954:	7c42                	ld	s8,48(sp)
    5956:	7ca2                	ld	s9,40(sp)
    5958:	7d02                	ld	s10,32(sp)
    595a:	6de2                	ld	s11,24(sp)
    595c:	6109                	addi	sp,sp,128
    595e:	8082                	ret

0000000000005960 <fprintf>:

void
fprintf(int fd, const char *fmt, ...)
{
    5960:	715d                	addi	sp,sp,-80
    5962:	ec06                	sd	ra,24(sp)
    5964:	e822                	sd	s0,16(sp)
    5966:	1000                	addi	s0,sp,32
    5968:	e010                	sd	a2,0(s0)
    596a:	e414                	sd	a3,8(s0)
    596c:	e818                	sd	a4,16(s0)
    596e:	ec1c                	sd	a5,24(s0)
    5970:	03043023          	sd	a6,32(s0)
    5974:	03143423          	sd	a7,40(s0)
  va_list ap;

  va_start(ap, fmt);
    5978:	fe843423          	sd	s0,-24(s0)
  vprintf(fd, fmt, ap);
    597c:	8622                	mv	a2,s0
    597e:	00000097          	auipc	ra,0x0
    5982:	e04080e7          	jalr	-508(ra) # 5782 <vprintf>
}
    5986:	60e2                	ld	ra,24(sp)
    5988:	6442                	ld	s0,16(sp)
    598a:	6161                	addi	sp,sp,80
    598c:	8082                	ret

000000000000598e <printf>:

void
printf(const char *fmt, ...)
{
    598e:	711d                	addi	sp,sp,-96
    5990:	ec06                	sd	ra,24(sp)
    5992:	e822                	sd	s0,16(sp)
    5994:	1000                	addi	s0,sp,32
    5996:	e40c                	sd	a1,8(s0)
    5998:	e810                	sd	a2,16(s0)
    599a:	ec14                	sd	a3,24(s0)
    599c:	f018                	sd	a4,32(s0)
    599e:	f41c                	sd	a5,40(s0)
    59a0:	03043823          	sd	a6,48(s0)
    59a4:	03143c23          	sd	a7,56(s0)
  va_list ap;

  va_start(ap, fmt);
    59a8:	00840613          	addi	a2,s0,8
    59ac:	fec43423          	sd	a2,-24(s0)
  vprintf(1, fmt, ap);
    59b0:	85aa                	mv	a1,a0
    59b2:	4505                	li	a0,1
    59b4:	00000097          	auipc	ra,0x0
    59b8:	dce080e7          	jalr	-562(ra) # 5782 <vprintf>
}
    59bc:	60e2                	ld	ra,24(sp)
    59be:	6442                	ld	s0,16(sp)
    59c0:	6125                	addi	sp,sp,96
    59c2:	8082                	ret

00000000000059c4 <free>:
static Header base;
static Header *freep;

void
free(void *ap)
{
    59c4:	1141                	addi	sp,sp,-16
    59c6:	e422                	sd	s0,8(sp)
    59c8:	0800                	addi	s0,sp,16
  Header *bp, *p;

  bp = (Header*)ap - 1;
    59ca:	ff050693          	addi	a3,a0,-16
  for(p = freep; !(bp > p && bp < p->s.ptr); p = p->s.ptr)
    59ce:	00003797          	auipc	a5,0x3
    59d2:	8b27b783          	ld	a5,-1870(a5) # 8280 <freep>
    59d6:	a805                	j	5a06 <free+0x42>
    if(p >= p->s.ptr && (bp > p || bp < p->s.ptr))
      break;
  if(bp + bp->s.size == p->s.ptr){
    bp->s.size += p->s.ptr->s.size;
    59d8:	4618                	lw	a4,8(a2)
    59da:	9db9                	addw	a1,a1,a4
    59dc:	feb52c23          	sw	a1,-8(a0)
    bp->s.ptr = p->s.ptr->s.ptr;
    59e0:	6398                	ld	a4,0(a5)
    59e2:	6318                	ld	a4,0(a4)
    59e4:	fee53823          	sd	a4,-16(a0)
    59e8:	a091                	j	5a2c <free+0x68>
  } else
    bp->s.ptr = p->s.ptr;
  if(p + p->s.size == bp){
    p->s.size += bp->s.size;
    59ea:	ff852703          	lw	a4,-8(a0)
    59ee:	9e39                	addw	a2,a2,a4
    59f0:	c790                	sw	a2,8(a5)
    p->s.ptr = bp->s.ptr;
    59f2:	ff053703          	ld	a4,-16(a0)
    59f6:	e398                	sd	a4,0(a5)
    59f8:	a099                	j	5a3e <free+0x7a>
    if(p >= p->s.ptr && (bp > p || bp < p->s.ptr))
    59fa:	6398                	ld	a4,0(a5)
    59fc:	00e7e463          	bltu	a5,a4,5a04 <free+0x40>
    5a00:	00e6ea63          	bltu	a3,a4,5a14 <free+0x50>
{
    5a04:	87ba                	mv	a5,a4
  for(p = freep; !(bp > p && bp < p->s.ptr); p = p->s.ptr)
    5a06:	fed7fae3          	bgeu	a5,a3,59fa <free+0x36>
    5a0a:	6398                	ld	a4,0(a5)
    5a0c:	00e6e463          	bltu	a3,a4,5a14 <free+0x50>
    if(p >= p->s.ptr && (bp > p || bp < p->s.ptr))
    5a10:	fee7eae3          	bltu	a5,a4,5a04 <free+0x40>
  if(bp + bp->s.size == p->s.ptr){
    5a14:	ff852583          	lw	a1,-8(a0)
    5a18:	6390                	ld	a2,0(a5)
    5a1a:	02059713          	slli	a4,a1,0x20
    5a1e:	9301                	srli	a4,a4,0x20
    5a20:	0712                	slli	a4,a4,0x4
    5a22:	9736                	add	a4,a4,a3
    5a24:	fae60ae3          	beq	a2,a4,59d8 <free+0x14>
    bp->s.ptr = p->s.ptr;
    5a28:	fec53823          	sd	a2,-16(a0)
  if(p + p->s.size == bp){
    5a2c:	4790                	lw	a2,8(a5)
    5a2e:	02061713          	slli	a4,a2,0x20
    5a32:	9301                	srli	a4,a4,0x20
    5a34:	0712                	slli	a4,a4,0x4
    5a36:	973e                	add	a4,a4,a5
    5a38:	fae689e3          	beq	a3,a4,59ea <free+0x26>
  } else
    p->s.ptr = bp;
    5a3c:	e394                	sd	a3,0(a5)
  freep = p;
    5a3e:	00003717          	auipc	a4,0x3
    5a42:	84f73123          	sd	a5,-1982(a4) # 8280 <freep>
}
    5a46:	6422                	ld	s0,8(sp)
    5a48:	0141                	addi	sp,sp,16
    5a4a:	8082                	ret

0000000000005a4c <malloc>:
  return freep;
}

void*
malloc(uint nbytes)
{
    5a4c:	7139                	addi	sp,sp,-64
    5a4e:	fc06                	sd	ra,56(sp)
    5a50:	f822                	sd	s0,48(sp)
    5a52:	f426                	sd	s1,40(sp)
    5a54:	f04a                	sd	s2,32(sp)
    5a56:	ec4e                	sd	s3,24(sp)
    5a58:	e852                	sd	s4,16(sp)
    5a5a:	e456                	sd	s5,8(sp)
    5a5c:	e05a                	sd	s6,0(sp)
    5a5e:	0080                	addi	s0,sp,64
  Header *p, *prevp;
  uint nunits;

  nunits = (nbytes + sizeof(Header) - 1)/sizeof(Header) + 1;
    5a60:	02051493          	slli	s1,a0,0x20
    5a64:	9081                	srli	s1,s1,0x20
    5a66:	04bd                	addi	s1,s1,15
    5a68:	8091                	srli	s1,s1,0x4
    5a6a:	0014899b          	addiw	s3,s1,1
    5a6e:	0485                	addi	s1,s1,1
  if((prevp = freep) == 0){
    5a70:	00003517          	auipc	a0,0x3
    5a74:	81053503          	ld	a0,-2032(a0) # 8280 <freep>
    5a78:	c515                	beqz	a0,5aa4 <malloc+0x58>
    base.s.ptr = freep = prevp = &base;
    base.s.size = 0;
  }
  for(p = prevp->s.ptr; ; prevp = p, p = p->s.ptr){
    5a7a:	611c                	ld	a5,0(a0)
    if(p->s.size >= nunits){
    5a7c:	4798                	lw	a4,8(a5)
    5a7e:	02977f63          	bgeu	a4,s1,5abc <malloc+0x70>
    5a82:	8a4e                	mv	s4,s3
    5a84:	0009871b          	sext.w	a4,s3
    5a88:	6685                	lui	a3,0x1
    5a8a:	00d77363          	bgeu	a4,a3,5a90 <malloc+0x44>
    5a8e:	6a05                	lui	s4,0x1
    5a90:	000a0b1b          	sext.w	s6,s4
  p = sbrk(nu * sizeof(Header));
    5a94:	004a1a1b          	slliw	s4,s4,0x4
        p->s.size = nunits;
      }
      freep = prevp;
      return (void*)(p + 1);
    }
    if(p == freep)
    5a98:	00002917          	auipc	s2,0x2
    5a9c:	7e890913          	addi	s2,s2,2024 # 8280 <freep>
  if(p == (char*)-1)
    5aa0:	5afd                	li	s5,-1
    5aa2:	a88d                	j	5b14 <malloc+0xc8>
    base.s.ptr = freep = prevp = &base;
    5aa4:	00009797          	auipc	a5,0x9
    5aa8:	ffc78793          	addi	a5,a5,-4 # eaa0 <base>
    5aac:	00002717          	auipc	a4,0x2
    5ab0:	7cf73a23          	sd	a5,2004(a4) # 8280 <freep>
    5ab4:	e39c                	sd	a5,0(a5)
    base.s.size = 0;
    5ab6:	0007a423          	sw	zero,8(a5)
    if(p->s.size >= nunits){
    5aba:	b7e1                	j	5a82 <malloc+0x36>
      if(p->s.size == nunits)
    5abc:	02e48b63          	beq	s1,a4,5af2 <malloc+0xa6>
        p->s.size -= nunits;
    5ac0:	4137073b          	subw	a4,a4,s3
    5ac4:	c798                	sw	a4,8(a5)
        p += p->s.size;
    5ac6:	1702                	slli	a4,a4,0x20
    5ac8:	9301                	srli	a4,a4,0x20
    5aca:	0712                	slli	a4,a4,0x4
    5acc:	97ba                	add	a5,a5,a4
        p->s.size = nunits;
    5ace:	0137a423          	sw	s3,8(a5)
      freep = prevp;
    5ad2:	00002717          	auipc	a4,0x2
    5ad6:	7aa73723          	sd	a0,1966(a4) # 8280 <freep>
      return (void*)(p + 1);
    5ada:	01078513          	addi	a0,a5,16
      if((p = morecore(nunits)) == 0)
        return 0;
  }
}
    5ade:	70e2                	ld	ra,56(sp)
    5ae0:	7442                	ld	s0,48(sp)
    5ae2:	74a2                	ld	s1,40(sp)
    5ae4:	7902                	ld	s2,32(sp)
    5ae6:	69e2                	ld	s3,24(sp)
    5ae8:	6a42                	ld	s4,16(sp)
    5aea:	6aa2                	ld	s5,8(sp)
    5aec:	6b02                	ld	s6,0(sp)
    5aee:	6121                	addi	sp,sp,64
    5af0:	8082                	ret
        prevp->s.ptr = p->s.ptr;
    5af2:	6398                	ld	a4,0(a5)
    5af4:	e118                	sd	a4,0(a0)
    5af6:	bff1                	j	5ad2 <malloc+0x86>
  hp->s.size = nu;
    5af8:	01652423          	sw	s6,8(a0)
  free((void*)(hp + 1));
    5afc:	0541                	addi	a0,a0,16
    5afe:	00000097          	auipc	ra,0x0
    5b02:	ec6080e7          	jalr	-314(ra) # 59c4 <free>
  return freep;
    5b06:	00093503          	ld	a0,0(s2)
      if((p = morecore(nunits)) == 0)
    5b0a:	d971                	beqz	a0,5ade <malloc+0x92>
  for(p = prevp->s.ptr; ; prevp = p, p = p->s.ptr){
    5b0c:	611c                	ld	a5,0(a0)
    if(p->s.size >= nunits){
    5b0e:	4798                	lw	a4,8(a5)
    5b10:	fa9776e3          	bgeu	a4,s1,5abc <malloc+0x70>
    if(p == freep)
    5b14:	00093703          	ld	a4,0(s2)
    5b18:	853e                	mv	a0,a5
    5b1a:	fef719e3          	bne	a4,a5,5b0c <malloc+0xc0>
  p = sbrk(nu * sizeof(Header));
    5b1e:	8552                	mv	a0,s4
    5b20:	00000097          	auipc	ra,0x0
    5b24:	b76080e7          	jalr	-1162(ra) # 5696 <sbrk>
  if(p == (char*)-1)
    5b28:	fd5518e3          	bne	a0,s5,5af8 <malloc+0xac>
        return 0;
    5b2c:	4501                	li	a0,0
    5b2e:	bf45                	j	5ade <malloc+0x92>
