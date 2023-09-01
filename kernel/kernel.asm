
kernel/kernel:     file format elf64-littleriscv


Disassembly of section .text:

0000000080000000 <_entry>:
    80000000:	00009117          	auipc	sp,0x9
    80000004:	18010113          	addi	sp,sp,384 # 80009180 <stack0>
    80000008:	6505                	lui	a0,0x1
    8000000a:	f14025f3          	csrr	a1,mhartid
    8000000e:	0585                	addi	a1,a1,1
    80000010:	02b50533          	mul	a0,a0,a1
    80000014:	912a                	add	sp,sp,a0
    80000016:	078000ef          	jal	ra,8000008e <start>

000000008000001a <spin>:
    8000001a:	a001                	j	8000001a <spin>

000000008000001c <timerinit>:
// which arrive at timervec in kernelvec.S,
// which turns them into software interrupts for
// devintr() in trap.c.
void
timerinit()
{
    8000001c:	1141                	addi	sp,sp,-16
    8000001e:	e422                	sd	s0,8(sp)
    80000020:	0800                	addi	s0,sp,16
// which hart (core) is this?
static inline uint64
r_mhartid()
{
  uint64 x;
  asm volatile("csrr %0, mhartid" : "=r" (x) );
    80000022:	f14027f3          	csrr	a5,mhartid
  // each CPU has a separate source of timer interrupts.
  int id = r_mhartid();
    80000026:	0007869b          	sext.w	a3,a5

  // ask the CLINT for a timer interrupt.
  int interval = 1000000; // cycles; about 1/10th second in qemu.
  *(uint64*)CLINT_MTIMECMP(id) = *(uint64*)CLINT_MTIME + interval;
    8000002a:	0037979b          	slliw	a5,a5,0x3
    8000002e:	02004737          	lui	a4,0x2004
    80000032:	97ba                	add	a5,a5,a4
    80000034:	0200c737          	lui	a4,0x200c
    80000038:	ff873583          	ld	a1,-8(a4) # 200bff8 <_entry-0x7dff4008>
    8000003c:	000f4637          	lui	a2,0xf4
    80000040:	24060613          	addi	a2,a2,576 # f4240 <_entry-0x7ff0bdc0>
    80000044:	95b2                	add	a1,a1,a2
    80000046:	e38c                	sd	a1,0(a5)

  // prepare information in scratch[] for timervec.
  // scratch[0..2] : space for timervec to save registers.
  // scratch[3] : address of CLINT MTIMECMP register.
  // scratch[4] : desired interval (in cycles) between timer interrupts.
  uint64 *scratch = &timer_scratch[id][0];
    80000048:	00269713          	slli	a4,a3,0x2
    8000004c:	9736                	add	a4,a4,a3
    8000004e:	00371693          	slli	a3,a4,0x3
    80000052:	00009717          	auipc	a4,0x9
    80000056:	fee70713          	addi	a4,a4,-18 # 80009040 <timer_scratch>
    8000005a:	9736                	add	a4,a4,a3
  scratch[3] = CLINT_MTIMECMP(id);
    8000005c:	ef1c                	sd	a5,24(a4)
  scratch[4] = interval;
    8000005e:	f310                	sd	a2,32(a4)
}

static inline void 
w_mscratch(uint64 x)
{
  asm volatile("csrw mscratch, %0" : : "r" (x));
    80000060:	34071073          	csrw	mscratch,a4
  asm volatile("csrw mtvec, %0" : : "r" (x));
    80000064:	00006797          	auipc	a5,0x6
    80000068:	d7c78793          	addi	a5,a5,-644 # 80005de0 <timervec>
    8000006c:	30579073          	csrw	mtvec,a5
  asm volatile("csrr %0, mstatus" : "=r" (x) );
    80000070:	300027f3          	csrr	a5,mstatus

  // set the machine-mode trap handler.
  w_mtvec((uint64)timervec);

  // enable machine-mode interrupts.
  w_mstatus(r_mstatus() | MSTATUS_MIE);
    80000074:	0087e793          	ori	a5,a5,8
  asm volatile("csrw mstatus, %0" : : "r" (x));
    80000078:	30079073          	csrw	mstatus,a5
  asm volatile("csrr %0, mie" : "=r" (x) );
    8000007c:	304027f3          	csrr	a5,mie

  // enable machine-mode timer interrupts.
  w_mie(r_mie() | MIE_MTIE);
    80000080:	0807e793          	ori	a5,a5,128
  asm volatile("csrw mie, %0" : : "r" (x));
    80000084:	30479073          	csrw	mie,a5
}
    80000088:	6422                	ld	s0,8(sp)
    8000008a:	0141                	addi	sp,sp,16
    8000008c:	8082                	ret

000000008000008e <start>:
{
    8000008e:	1141                	addi	sp,sp,-16
    80000090:	e406                	sd	ra,8(sp)
    80000092:	e022                	sd	s0,0(sp)
    80000094:	0800                	addi	s0,sp,16
  asm volatile("csrr %0, mstatus" : "=r" (x) );
    80000096:	300027f3          	csrr	a5,mstatus
  x &= ~MSTATUS_MPP_MASK;
    8000009a:	7779                	lui	a4,0xffffe
    8000009c:	7ff70713          	addi	a4,a4,2047 # ffffffffffffe7ff <end+0xffffffff7ffdd7ff>
    800000a0:	8ff9                	and	a5,a5,a4
  x |= MSTATUS_MPP_S;
    800000a2:	6705                	lui	a4,0x1
    800000a4:	80070713          	addi	a4,a4,-2048 # 800 <_entry-0x7ffff800>
    800000a8:	8fd9                	or	a5,a5,a4
  asm volatile("csrw mstatus, %0" : : "r" (x));
    800000aa:	30079073          	csrw	mstatus,a5
  asm volatile("csrw mepc, %0" : : "r" (x));
    800000ae:	00001797          	auipc	a5,0x1
    800000b2:	dbe78793          	addi	a5,a5,-578 # 80000e6c <main>
    800000b6:	34179073          	csrw	mepc,a5
  asm volatile("csrw satp, %0" : : "r" (x));
    800000ba:	4781                	li	a5,0
    800000bc:	18079073          	csrw	satp,a5
  asm volatile("csrw medeleg, %0" : : "r" (x));
    800000c0:	67c1                	lui	a5,0x10
    800000c2:	17fd                	addi	a5,a5,-1
    800000c4:	30279073          	csrw	medeleg,a5
  asm volatile("csrw mideleg, %0" : : "r" (x));
    800000c8:	30379073          	csrw	mideleg,a5
  asm volatile("csrr %0, sie" : "=r" (x) );
    800000cc:	104027f3          	csrr	a5,sie
  w_sie(r_sie() | SIE_SEIE | SIE_STIE | SIE_SSIE);
    800000d0:	2227e793          	ori	a5,a5,546
  asm volatile("csrw sie, %0" : : "r" (x));
    800000d4:	10479073          	csrw	sie,a5
  timerinit();
    800000d8:	00000097          	auipc	ra,0x0
    800000dc:	f44080e7          	jalr	-188(ra) # 8000001c <timerinit>
  asm volatile("csrr %0, mhartid" : "=r" (x) );
    800000e0:	f14027f3          	csrr	a5,mhartid
  w_tp(id);
    800000e4:	2781                	sext.w	a5,a5
}

static inline void 
w_tp(uint64 x)
{
  asm volatile("mv tp, %0" : : "r" (x));
    800000e6:	823e                	mv	tp,a5
  asm volatile("mret");
    800000e8:	30200073          	mret
}
    800000ec:	60a2                	ld	ra,8(sp)
    800000ee:	6402                	ld	s0,0(sp)
    800000f0:	0141                	addi	sp,sp,16
    800000f2:	8082                	ret

00000000800000f4 <consolewrite>:
//
// user write()s to the console go here.
//
int
consolewrite(int user_src, uint64 src, int n)
{
    800000f4:	715d                	addi	sp,sp,-80
    800000f6:	e486                	sd	ra,72(sp)
    800000f8:	e0a2                	sd	s0,64(sp)
    800000fa:	fc26                	sd	s1,56(sp)
    800000fc:	f84a                	sd	s2,48(sp)
    800000fe:	f44e                	sd	s3,40(sp)
    80000100:	f052                	sd	s4,32(sp)
    80000102:	ec56                	sd	s5,24(sp)
    80000104:	0880                	addi	s0,sp,80
  int i;

  for(i = 0; i < n; i++){
    80000106:	04c05663          	blez	a2,80000152 <consolewrite+0x5e>
    8000010a:	8a2a                	mv	s4,a0
    8000010c:	84ae                	mv	s1,a1
    8000010e:	89b2                	mv	s3,a2
    80000110:	4901                	li	s2,0
    char c;
    if(either_copyin(&c, user_src, src+i, 1) == -1)
    80000112:	5afd                	li	s5,-1
    80000114:	4685                	li	a3,1
    80000116:	8626                	mv	a2,s1
    80000118:	85d2                	mv	a1,s4
    8000011a:	fbf40513          	addi	a0,s0,-65
    8000011e:	00002097          	auipc	ra,0x2
    80000122:	350080e7          	jalr	848(ra) # 8000246e <either_copyin>
    80000126:	01550c63          	beq	a0,s5,8000013e <consolewrite+0x4a>
      break;
    uartputc(c);
    8000012a:	fbf44503          	lbu	a0,-65(s0)
    8000012e:	00000097          	auipc	ra,0x0
    80000132:	77a080e7          	jalr	1914(ra) # 800008a8 <uartputc>
  for(i = 0; i < n; i++){
    80000136:	2905                	addiw	s2,s2,1
    80000138:	0485                	addi	s1,s1,1
    8000013a:	fd299de3          	bne	s3,s2,80000114 <consolewrite+0x20>
  }

  return i;
}
    8000013e:	854a                	mv	a0,s2
    80000140:	60a6                	ld	ra,72(sp)
    80000142:	6406                	ld	s0,64(sp)
    80000144:	74e2                	ld	s1,56(sp)
    80000146:	7942                	ld	s2,48(sp)
    80000148:	79a2                	ld	s3,40(sp)
    8000014a:	7a02                	ld	s4,32(sp)
    8000014c:	6ae2                	ld	s5,24(sp)
    8000014e:	6161                	addi	sp,sp,80
    80000150:	8082                	ret
  for(i = 0; i < n; i++){
    80000152:	4901                	li	s2,0
    80000154:	b7ed                	j	8000013e <consolewrite+0x4a>

0000000080000156 <consoleread>:
// user_dist indicates whether dst is a user
// or kernel address.
//
int
consoleread(int user_dst, uint64 dst, int n)
{
    80000156:	7159                	addi	sp,sp,-112
    80000158:	f486                	sd	ra,104(sp)
    8000015a:	f0a2                	sd	s0,96(sp)
    8000015c:	eca6                	sd	s1,88(sp)
    8000015e:	e8ca                	sd	s2,80(sp)
    80000160:	e4ce                	sd	s3,72(sp)
    80000162:	e0d2                	sd	s4,64(sp)
    80000164:	fc56                	sd	s5,56(sp)
    80000166:	f85a                	sd	s6,48(sp)
    80000168:	f45e                	sd	s7,40(sp)
    8000016a:	f062                	sd	s8,32(sp)
    8000016c:	ec66                	sd	s9,24(sp)
    8000016e:	e86a                	sd	s10,16(sp)
    80000170:	1880                	addi	s0,sp,112
    80000172:	8aaa                	mv	s5,a0
    80000174:	8a2e                	mv	s4,a1
    80000176:	89b2                	mv	s3,a2
  uint target;
  int c;
  char cbuf;

  target = n;
    80000178:	00060b1b          	sext.w	s6,a2
  acquire(&cons.lock);
    8000017c:	00011517          	auipc	a0,0x11
    80000180:	00450513          	addi	a0,a0,4 # 80011180 <cons>
    80000184:	00001097          	auipc	ra,0x1
    80000188:	a3e080e7          	jalr	-1474(ra) # 80000bc2 <acquire>
  while(n > 0){
    // wait until interrupt handler has put some
    // input into cons.buffer.
    while(cons.r == cons.w){
    8000018c:	00011497          	auipc	s1,0x11
    80000190:	ff448493          	addi	s1,s1,-12 # 80011180 <cons>
      if(myproc()->killed){
        release(&cons.lock);
        return -1;
      }
      sleep(&cons.r, &cons.lock);
    80000194:	00011917          	auipc	s2,0x11
    80000198:	08490913          	addi	s2,s2,132 # 80011218 <cons+0x98>
    }

    c = cons.buf[cons.r++ % INPUT_BUF];

    if(c == C('D')){  // end-of-file
    8000019c:	4b91                	li	s7,4
      break;
    }

    // copy the input byte to the user-space buffer.
    cbuf = c;
    if(either_copyout(user_dst, dst, &cbuf, 1) == -1)
    8000019e:	5c7d                	li	s8,-1
      break;

    dst++;
    --n;

    if(c == '\n'){
    800001a0:	4ca9                	li	s9,10
  while(n > 0){
    800001a2:	07305863          	blez	s3,80000212 <consoleread+0xbc>
    while(cons.r == cons.w){
    800001a6:	0984a783          	lw	a5,152(s1)
    800001aa:	09c4a703          	lw	a4,156(s1)
    800001ae:	02f71463          	bne	a4,a5,800001d6 <consoleread+0x80>
      if(myproc()->killed){
    800001b2:	00001097          	auipc	ra,0x1
    800001b6:	7f8080e7          	jalr	2040(ra) # 800019aa <myproc>
    800001ba:	591c                	lw	a5,48(a0)
    800001bc:	e7b5                	bnez	a5,80000228 <consoleread+0xd2>
      sleep(&cons.r, &cons.lock);
    800001be:	85a6                	mv	a1,s1
    800001c0:	854a                	mv	a0,s2
    800001c2:	00002097          	auipc	ra,0x2
    800001c6:	ffc080e7          	jalr	-4(ra) # 800021be <sleep>
    while(cons.r == cons.w){
    800001ca:	0984a783          	lw	a5,152(s1)
    800001ce:	09c4a703          	lw	a4,156(s1)
    800001d2:	fef700e3          	beq	a4,a5,800001b2 <consoleread+0x5c>
    c = cons.buf[cons.r++ % INPUT_BUF];
    800001d6:	0017871b          	addiw	a4,a5,1
    800001da:	08e4ac23          	sw	a4,152(s1)
    800001de:	07f7f713          	andi	a4,a5,127
    800001e2:	9726                	add	a4,a4,s1
    800001e4:	01874703          	lbu	a4,24(a4)
    800001e8:	00070d1b          	sext.w	s10,a4
    if(c == C('D')){  // end-of-file
    800001ec:	077d0563          	beq	s10,s7,80000256 <consoleread+0x100>
    cbuf = c;
    800001f0:	f8e40fa3          	sb	a4,-97(s0)
    if(either_copyout(user_dst, dst, &cbuf, 1) == -1)
    800001f4:	4685                	li	a3,1
    800001f6:	f9f40613          	addi	a2,s0,-97
    800001fa:	85d2                	mv	a1,s4
    800001fc:	8556                	mv	a0,s5
    800001fe:	00002097          	auipc	ra,0x2
    80000202:	21a080e7          	jalr	538(ra) # 80002418 <either_copyout>
    80000206:	01850663          	beq	a0,s8,80000212 <consoleread+0xbc>
    dst++;
    8000020a:	0a05                	addi	s4,s4,1
    --n;
    8000020c:	39fd                	addiw	s3,s3,-1
    if(c == '\n'){
    8000020e:	f99d1ae3          	bne	s10,s9,800001a2 <consoleread+0x4c>
      // a whole line has arrived, return to
      // the user-level read().
      break;
    }
  }
  release(&cons.lock);
    80000212:	00011517          	auipc	a0,0x11
    80000216:	f6e50513          	addi	a0,a0,-146 # 80011180 <cons>
    8000021a:	00001097          	auipc	ra,0x1
    8000021e:	a5c080e7          	jalr	-1444(ra) # 80000c76 <release>

  return target - n;
    80000222:	413b053b          	subw	a0,s6,s3
    80000226:	a811                	j	8000023a <consoleread+0xe4>
        release(&cons.lock);
    80000228:	00011517          	auipc	a0,0x11
    8000022c:	f5850513          	addi	a0,a0,-168 # 80011180 <cons>
    80000230:	00001097          	auipc	ra,0x1
    80000234:	a46080e7          	jalr	-1466(ra) # 80000c76 <release>
        return -1;
    80000238:	557d                	li	a0,-1
}
    8000023a:	70a6                	ld	ra,104(sp)
    8000023c:	7406                	ld	s0,96(sp)
    8000023e:	64e6                	ld	s1,88(sp)
    80000240:	6946                	ld	s2,80(sp)
    80000242:	69a6                	ld	s3,72(sp)
    80000244:	6a06                	ld	s4,64(sp)
    80000246:	7ae2                	ld	s5,56(sp)
    80000248:	7b42                	ld	s6,48(sp)
    8000024a:	7ba2                	ld	s7,40(sp)
    8000024c:	7c02                	ld	s8,32(sp)
    8000024e:	6ce2                	ld	s9,24(sp)
    80000250:	6d42                	ld	s10,16(sp)
    80000252:	6165                	addi	sp,sp,112
    80000254:	8082                	ret
      if(n < target){
    80000256:	0009871b          	sext.w	a4,s3
    8000025a:	fb677ce3          	bgeu	a4,s6,80000212 <consoleread+0xbc>
        cons.r--;
    8000025e:	00011717          	auipc	a4,0x11
    80000262:	faf72d23          	sw	a5,-70(a4) # 80011218 <cons+0x98>
    80000266:	b775                	j	80000212 <consoleread+0xbc>

0000000080000268 <consputc>:
{
    80000268:	1141                	addi	sp,sp,-16
    8000026a:	e406                	sd	ra,8(sp)
    8000026c:	e022                	sd	s0,0(sp)
    8000026e:	0800                	addi	s0,sp,16
  if(c == BACKSPACE){
    80000270:	10000793          	li	a5,256
    80000274:	00f50a63          	beq	a0,a5,80000288 <consputc+0x20>
    uartputc_sync(c);
    80000278:	00000097          	auipc	ra,0x0
    8000027c:	55e080e7          	jalr	1374(ra) # 800007d6 <uartputc_sync>
}
    80000280:	60a2                	ld	ra,8(sp)
    80000282:	6402                	ld	s0,0(sp)
    80000284:	0141                	addi	sp,sp,16
    80000286:	8082                	ret
    uartputc_sync('\b'); uartputc_sync(' '); uartputc_sync('\b');
    80000288:	4521                	li	a0,8
    8000028a:	00000097          	auipc	ra,0x0
    8000028e:	54c080e7          	jalr	1356(ra) # 800007d6 <uartputc_sync>
    80000292:	02000513          	li	a0,32
    80000296:	00000097          	auipc	ra,0x0
    8000029a:	540080e7          	jalr	1344(ra) # 800007d6 <uartputc_sync>
    8000029e:	4521                	li	a0,8
    800002a0:	00000097          	auipc	ra,0x0
    800002a4:	536080e7          	jalr	1334(ra) # 800007d6 <uartputc_sync>
    800002a8:	bfe1                	j	80000280 <consputc+0x18>

00000000800002aa <consoleintr>:
// do erase/kill processing, append to cons.buf,
// wake up consoleread() if a whole line has arrived.
//
void
consoleintr(int c)
{
    800002aa:	1101                	addi	sp,sp,-32
    800002ac:	ec06                	sd	ra,24(sp)
    800002ae:	e822                	sd	s0,16(sp)
    800002b0:	e426                	sd	s1,8(sp)
    800002b2:	e04a                	sd	s2,0(sp)
    800002b4:	1000                	addi	s0,sp,32
    800002b6:	84aa                	mv	s1,a0
  acquire(&cons.lock);
    800002b8:	00011517          	auipc	a0,0x11
    800002bc:	ec850513          	addi	a0,a0,-312 # 80011180 <cons>
    800002c0:	00001097          	auipc	ra,0x1
    800002c4:	902080e7          	jalr	-1790(ra) # 80000bc2 <acquire>

  switch(c){
    800002c8:	47d5                	li	a5,21
    800002ca:	0af48663          	beq	s1,a5,80000376 <consoleintr+0xcc>
    800002ce:	0297ca63          	blt	a5,s1,80000302 <consoleintr+0x58>
    800002d2:	47a1                	li	a5,8
    800002d4:	0ef48763          	beq	s1,a5,800003c2 <consoleintr+0x118>
    800002d8:	47c1                	li	a5,16
    800002da:	10f49a63          	bne	s1,a5,800003ee <consoleintr+0x144>
  case C('P'):  // Print process list.
    procdump();
    800002de:	00002097          	auipc	ra,0x2
    800002e2:	1e6080e7          	jalr	486(ra) # 800024c4 <procdump>
      }
    }
    break;
  }
  
  release(&cons.lock);
    800002e6:	00011517          	auipc	a0,0x11
    800002ea:	e9a50513          	addi	a0,a0,-358 # 80011180 <cons>
    800002ee:	00001097          	auipc	ra,0x1
    800002f2:	988080e7          	jalr	-1656(ra) # 80000c76 <release>
}
    800002f6:	60e2                	ld	ra,24(sp)
    800002f8:	6442                	ld	s0,16(sp)
    800002fa:	64a2                	ld	s1,8(sp)
    800002fc:	6902                	ld	s2,0(sp)
    800002fe:	6105                	addi	sp,sp,32
    80000300:	8082                	ret
  switch(c){
    80000302:	07f00793          	li	a5,127
    80000306:	0af48e63          	beq	s1,a5,800003c2 <consoleintr+0x118>
    if(c != 0 && cons.e-cons.r < INPUT_BUF){
    8000030a:	00011717          	auipc	a4,0x11
    8000030e:	e7670713          	addi	a4,a4,-394 # 80011180 <cons>
    80000312:	0a072783          	lw	a5,160(a4)
    80000316:	09872703          	lw	a4,152(a4)
    8000031a:	9f99                	subw	a5,a5,a4
    8000031c:	07f00713          	li	a4,127
    80000320:	fcf763e3          	bltu	a4,a5,800002e6 <consoleintr+0x3c>
      c = (c == '\r') ? '\n' : c;
    80000324:	47b5                	li	a5,13
    80000326:	0cf48763          	beq	s1,a5,800003f4 <consoleintr+0x14a>
      consputc(c);
    8000032a:	8526                	mv	a0,s1
    8000032c:	00000097          	auipc	ra,0x0
    80000330:	f3c080e7          	jalr	-196(ra) # 80000268 <consputc>
      cons.buf[cons.e++ % INPUT_BUF] = c;
    80000334:	00011797          	auipc	a5,0x11
    80000338:	e4c78793          	addi	a5,a5,-436 # 80011180 <cons>
    8000033c:	0a07a703          	lw	a4,160(a5)
    80000340:	0017069b          	addiw	a3,a4,1
    80000344:	0006861b          	sext.w	a2,a3
    80000348:	0ad7a023          	sw	a3,160(a5)
    8000034c:	07f77713          	andi	a4,a4,127
    80000350:	97ba                	add	a5,a5,a4
    80000352:	00978c23          	sb	s1,24(a5)
      if(c == '\n' || c == C('D') || cons.e == cons.r+INPUT_BUF){
    80000356:	47a9                	li	a5,10
    80000358:	0cf48563          	beq	s1,a5,80000422 <consoleintr+0x178>
    8000035c:	4791                	li	a5,4
    8000035e:	0cf48263          	beq	s1,a5,80000422 <consoleintr+0x178>
    80000362:	00011797          	auipc	a5,0x11
    80000366:	eb67a783          	lw	a5,-330(a5) # 80011218 <cons+0x98>
    8000036a:	0807879b          	addiw	a5,a5,128
    8000036e:	f6f61ce3          	bne	a2,a5,800002e6 <consoleintr+0x3c>
      cons.buf[cons.e++ % INPUT_BUF] = c;
    80000372:	863e                	mv	a2,a5
    80000374:	a07d                	j	80000422 <consoleintr+0x178>
    while(cons.e != cons.w &&
    80000376:	00011717          	auipc	a4,0x11
    8000037a:	e0a70713          	addi	a4,a4,-502 # 80011180 <cons>
    8000037e:	0a072783          	lw	a5,160(a4)
    80000382:	09c72703          	lw	a4,156(a4)
          cons.buf[(cons.e-1) % INPUT_BUF] != '\n'){
    80000386:	00011497          	auipc	s1,0x11
    8000038a:	dfa48493          	addi	s1,s1,-518 # 80011180 <cons>
    while(cons.e != cons.w &&
    8000038e:	4929                	li	s2,10
    80000390:	f4f70be3          	beq	a4,a5,800002e6 <consoleintr+0x3c>
          cons.buf[(cons.e-1) % INPUT_BUF] != '\n'){
    80000394:	37fd                	addiw	a5,a5,-1
    80000396:	07f7f713          	andi	a4,a5,127
    8000039a:	9726                	add	a4,a4,s1
    while(cons.e != cons.w &&
    8000039c:	01874703          	lbu	a4,24(a4)
    800003a0:	f52703e3          	beq	a4,s2,800002e6 <consoleintr+0x3c>
      cons.e--;
    800003a4:	0af4a023          	sw	a5,160(s1)
      consputc(BACKSPACE);
    800003a8:	10000513          	li	a0,256
    800003ac:	00000097          	auipc	ra,0x0
    800003b0:	ebc080e7          	jalr	-324(ra) # 80000268 <consputc>
    while(cons.e != cons.w &&
    800003b4:	0a04a783          	lw	a5,160(s1)
    800003b8:	09c4a703          	lw	a4,156(s1)
    800003bc:	fcf71ce3          	bne	a4,a5,80000394 <consoleintr+0xea>
    800003c0:	b71d                	j	800002e6 <consoleintr+0x3c>
    if(cons.e != cons.w){
    800003c2:	00011717          	auipc	a4,0x11
    800003c6:	dbe70713          	addi	a4,a4,-578 # 80011180 <cons>
    800003ca:	0a072783          	lw	a5,160(a4)
    800003ce:	09c72703          	lw	a4,156(a4)
    800003d2:	f0f70ae3          	beq	a4,a5,800002e6 <consoleintr+0x3c>
      cons.e--;
    800003d6:	37fd                	addiw	a5,a5,-1
    800003d8:	00011717          	auipc	a4,0x11
    800003dc:	e4f72423          	sw	a5,-440(a4) # 80011220 <cons+0xa0>
      consputc(BACKSPACE);
    800003e0:	10000513          	li	a0,256
    800003e4:	00000097          	auipc	ra,0x0
    800003e8:	e84080e7          	jalr	-380(ra) # 80000268 <consputc>
    800003ec:	bded                	j	800002e6 <consoleintr+0x3c>
    if(c != 0 && cons.e-cons.r < INPUT_BUF){
    800003ee:	ee048ce3          	beqz	s1,800002e6 <consoleintr+0x3c>
    800003f2:	bf21                	j	8000030a <consoleintr+0x60>
      consputc(c);
    800003f4:	4529                	li	a0,10
    800003f6:	00000097          	auipc	ra,0x0
    800003fa:	e72080e7          	jalr	-398(ra) # 80000268 <consputc>
      cons.buf[cons.e++ % INPUT_BUF] = c;
    800003fe:	00011797          	auipc	a5,0x11
    80000402:	d8278793          	addi	a5,a5,-638 # 80011180 <cons>
    80000406:	0a07a703          	lw	a4,160(a5)
    8000040a:	0017069b          	addiw	a3,a4,1
    8000040e:	0006861b          	sext.w	a2,a3
    80000412:	0ad7a023          	sw	a3,160(a5)
    80000416:	07f77713          	andi	a4,a4,127
    8000041a:	97ba                	add	a5,a5,a4
    8000041c:	4729                	li	a4,10
    8000041e:	00e78c23          	sb	a4,24(a5)
        cons.w = cons.e;
    80000422:	00011797          	auipc	a5,0x11
    80000426:	dec7ad23          	sw	a2,-518(a5) # 8001121c <cons+0x9c>
        wakeup(&cons.r);
    8000042a:	00011517          	auipc	a0,0x11
    8000042e:	dee50513          	addi	a0,a0,-530 # 80011218 <cons+0x98>
    80000432:	00002097          	auipc	ra,0x2
    80000436:	f0c080e7          	jalr	-244(ra) # 8000233e <wakeup>
    8000043a:	b575                	j	800002e6 <consoleintr+0x3c>

000000008000043c <consoleinit>:

void
consoleinit(void)
{
    8000043c:	1141                	addi	sp,sp,-16
    8000043e:	e406                	sd	ra,8(sp)
    80000440:	e022                	sd	s0,0(sp)
    80000442:	0800                	addi	s0,sp,16
  initlock(&cons.lock, "cons");
    80000444:	00008597          	auipc	a1,0x8
    80000448:	bcc58593          	addi	a1,a1,-1076 # 80008010 <etext+0x10>
    8000044c:	00011517          	auipc	a0,0x11
    80000450:	d3450513          	addi	a0,a0,-716 # 80011180 <cons>
    80000454:	00000097          	auipc	ra,0x0
    80000458:	6de080e7          	jalr	1758(ra) # 80000b32 <initlock>

  uartinit();
    8000045c:	00000097          	auipc	ra,0x0
    80000460:	32a080e7          	jalr	810(ra) # 80000786 <uartinit>

  // connect read and write system calls
  // to consoleread and consolewrite.
  devsw[CONSOLE].read = consoleread;
    80000464:	0001c797          	auipc	a5,0x1c
    80000468:	2ac78793          	addi	a5,a5,684 # 8001c710 <devsw>
    8000046c:	00000717          	auipc	a4,0x0
    80000470:	cea70713          	addi	a4,a4,-790 # 80000156 <consoleread>
    80000474:	eb98                	sd	a4,16(a5)
  devsw[CONSOLE].write = consolewrite;
    80000476:	00000717          	auipc	a4,0x0
    8000047a:	c7e70713          	addi	a4,a4,-898 # 800000f4 <consolewrite>
    8000047e:	ef98                	sd	a4,24(a5)
}
    80000480:	60a2                	ld	ra,8(sp)
    80000482:	6402                	ld	s0,0(sp)
    80000484:	0141                	addi	sp,sp,16
    80000486:	8082                	ret

0000000080000488 <printint>:

static char digits[] = "0123456789abcdef";

static void
printint(int xx, int base, int sign)
{
    80000488:	7179                	addi	sp,sp,-48
    8000048a:	f406                	sd	ra,40(sp)
    8000048c:	f022                	sd	s0,32(sp)
    8000048e:	ec26                	sd	s1,24(sp)
    80000490:	e84a                	sd	s2,16(sp)
    80000492:	1800                	addi	s0,sp,48
  char buf[16];
  int i;
  uint x;

  if(sign && (sign = xx < 0))
    80000494:	c219                	beqz	a2,8000049a <printint+0x12>
    80000496:	08054663          	bltz	a0,80000522 <printint+0x9a>
    x = -xx;
  else
    x = xx;
    8000049a:	2501                	sext.w	a0,a0
    8000049c:	4881                	li	a7,0
    8000049e:	fd040693          	addi	a3,s0,-48

  i = 0;
    800004a2:	4701                	li	a4,0
  do {
    buf[i++] = digits[x % base];
    800004a4:	2581                	sext.w	a1,a1
    800004a6:	00008617          	auipc	a2,0x8
    800004aa:	b9a60613          	addi	a2,a2,-1126 # 80008040 <digits>
    800004ae:	883a                	mv	a6,a4
    800004b0:	2705                	addiw	a4,a4,1
    800004b2:	02b577bb          	remuw	a5,a0,a1
    800004b6:	1782                	slli	a5,a5,0x20
    800004b8:	9381                	srli	a5,a5,0x20
    800004ba:	97b2                	add	a5,a5,a2
    800004bc:	0007c783          	lbu	a5,0(a5)
    800004c0:	00f68023          	sb	a5,0(a3)
  } while((x /= base) != 0);
    800004c4:	0005079b          	sext.w	a5,a0
    800004c8:	02b5553b          	divuw	a0,a0,a1
    800004cc:	0685                	addi	a3,a3,1
    800004ce:	feb7f0e3          	bgeu	a5,a1,800004ae <printint+0x26>

  if(sign)
    800004d2:	00088b63          	beqz	a7,800004e8 <printint+0x60>
    buf[i++] = '-';
    800004d6:	fe040793          	addi	a5,s0,-32
    800004da:	973e                	add	a4,a4,a5
    800004dc:	02d00793          	li	a5,45
    800004e0:	fef70823          	sb	a5,-16(a4)
    800004e4:	0028071b          	addiw	a4,a6,2

  while(--i >= 0)
    800004e8:	02e05763          	blez	a4,80000516 <printint+0x8e>
    800004ec:	fd040793          	addi	a5,s0,-48
    800004f0:	00e784b3          	add	s1,a5,a4
    800004f4:	fff78913          	addi	s2,a5,-1
    800004f8:	993a                	add	s2,s2,a4
    800004fa:	377d                	addiw	a4,a4,-1
    800004fc:	1702                	slli	a4,a4,0x20
    800004fe:	9301                	srli	a4,a4,0x20
    80000500:	40e90933          	sub	s2,s2,a4
    consputc(buf[i]);
    80000504:	fff4c503          	lbu	a0,-1(s1)
    80000508:	00000097          	auipc	ra,0x0
    8000050c:	d60080e7          	jalr	-672(ra) # 80000268 <consputc>
  while(--i >= 0)
    80000510:	14fd                	addi	s1,s1,-1
    80000512:	ff2499e3          	bne	s1,s2,80000504 <printint+0x7c>
}
    80000516:	70a2                	ld	ra,40(sp)
    80000518:	7402                	ld	s0,32(sp)
    8000051a:	64e2                	ld	s1,24(sp)
    8000051c:	6942                	ld	s2,16(sp)
    8000051e:	6145                	addi	sp,sp,48
    80000520:	8082                	ret
    x = -xx;
    80000522:	40a0053b          	negw	a0,a0
  if(sign && (sign = xx < 0))
    80000526:	4885                	li	a7,1
    x = -xx;
    80000528:	bf9d                	j	8000049e <printint+0x16>

000000008000052a <panic>:
    release(&pr.lock);
}

void
panic(char *s)
{
    8000052a:	1101                	addi	sp,sp,-32
    8000052c:	ec06                	sd	ra,24(sp)
    8000052e:	e822                	sd	s0,16(sp)
    80000530:	e426                	sd	s1,8(sp)
    80000532:	1000                	addi	s0,sp,32
    80000534:	84aa                	mv	s1,a0
  pr.locking = 0;
    80000536:	00011797          	auipc	a5,0x11
    8000053a:	d007a523          	sw	zero,-758(a5) # 80011240 <pr+0x18>
  printf("panic: ");
    8000053e:	00008517          	auipc	a0,0x8
    80000542:	ada50513          	addi	a0,a0,-1318 # 80008018 <etext+0x18>
    80000546:	00000097          	auipc	ra,0x0
    8000054a:	02e080e7          	jalr	46(ra) # 80000574 <printf>
  printf(s);
    8000054e:	8526                	mv	a0,s1
    80000550:	00000097          	auipc	ra,0x0
    80000554:	024080e7          	jalr	36(ra) # 80000574 <printf>
  printf("\n");
    80000558:	00008517          	auipc	a0,0x8
    8000055c:	b7050513          	addi	a0,a0,-1168 # 800080c8 <digits+0x88>
    80000560:	00000097          	auipc	ra,0x0
    80000564:	014080e7          	jalr	20(ra) # 80000574 <printf>
  panicked = 1; // freeze uart output from other CPUs
    80000568:	4785                	li	a5,1
    8000056a:	00009717          	auipc	a4,0x9
    8000056e:	a8f72b23          	sw	a5,-1386(a4) # 80009000 <panicked>
  for(;;)
    80000572:	a001                	j	80000572 <panic+0x48>

0000000080000574 <printf>:
{
    80000574:	7131                	addi	sp,sp,-192
    80000576:	fc86                	sd	ra,120(sp)
    80000578:	f8a2                	sd	s0,112(sp)
    8000057a:	f4a6                	sd	s1,104(sp)
    8000057c:	f0ca                	sd	s2,96(sp)
    8000057e:	ecce                	sd	s3,88(sp)
    80000580:	e8d2                	sd	s4,80(sp)
    80000582:	e4d6                	sd	s5,72(sp)
    80000584:	e0da                	sd	s6,64(sp)
    80000586:	fc5e                	sd	s7,56(sp)
    80000588:	f862                	sd	s8,48(sp)
    8000058a:	f466                	sd	s9,40(sp)
    8000058c:	f06a                	sd	s10,32(sp)
    8000058e:	ec6e                	sd	s11,24(sp)
    80000590:	0100                	addi	s0,sp,128
    80000592:	8a2a                	mv	s4,a0
    80000594:	e40c                	sd	a1,8(s0)
    80000596:	e810                	sd	a2,16(s0)
    80000598:	ec14                	sd	a3,24(s0)
    8000059a:	f018                	sd	a4,32(s0)
    8000059c:	f41c                	sd	a5,40(s0)
    8000059e:	03043823          	sd	a6,48(s0)
    800005a2:	03143c23          	sd	a7,56(s0)
  locking = pr.locking;
    800005a6:	00011d97          	auipc	s11,0x11
    800005aa:	c9adad83          	lw	s11,-870(s11) # 80011240 <pr+0x18>
  if(locking)
    800005ae:	020d9b63          	bnez	s11,800005e4 <printf+0x70>
  if (fmt == 0)
    800005b2:	040a0263          	beqz	s4,800005f6 <printf+0x82>
  va_start(ap, fmt);
    800005b6:	00840793          	addi	a5,s0,8
    800005ba:	f8f43423          	sd	a5,-120(s0)
  for(i = 0; (c = fmt[i] & 0xff) != 0; i++){
    800005be:	000a4503          	lbu	a0,0(s4)
    800005c2:	14050f63          	beqz	a0,80000720 <printf+0x1ac>
    800005c6:	4981                	li	s3,0
    if(c != '%'){
    800005c8:	02500a93          	li	s5,37
    switch(c){
    800005cc:	07000b93          	li	s7,112
  consputc('x');
    800005d0:	4d41                	li	s10,16
    consputc(digits[x >> (sizeof(uint64) * 8 - 4)]);
    800005d2:	00008b17          	auipc	s6,0x8
    800005d6:	a6eb0b13          	addi	s6,s6,-1426 # 80008040 <digits>
    switch(c){
    800005da:	07300c93          	li	s9,115
    800005de:	06400c13          	li	s8,100
    800005e2:	a82d                	j	8000061c <printf+0xa8>
    acquire(&pr.lock);
    800005e4:	00011517          	auipc	a0,0x11
    800005e8:	c4450513          	addi	a0,a0,-956 # 80011228 <pr>
    800005ec:	00000097          	auipc	ra,0x0
    800005f0:	5d6080e7          	jalr	1494(ra) # 80000bc2 <acquire>
    800005f4:	bf7d                	j	800005b2 <printf+0x3e>
    panic("null fmt");
    800005f6:	00008517          	auipc	a0,0x8
    800005fa:	a3250513          	addi	a0,a0,-1486 # 80008028 <etext+0x28>
    800005fe:	00000097          	auipc	ra,0x0
    80000602:	f2c080e7          	jalr	-212(ra) # 8000052a <panic>
      consputc(c);
    80000606:	00000097          	auipc	ra,0x0
    8000060a:	c62080e7          	jalr	-926(ra) # 80000268 <consputc>
  for(i = 0; (c = fmt[i] & 0xff) != 0; i++){
    8000060e:	2985                	addiw	s3,s3,1
    80000610:	013a07b3          	add	a5,s4,s3
    80000614:	0007c503          	lbu	a0,0(a5)
    80000618:	10050463          	beqz	a0,80000720 <printf+0x1ac>
    if(c != '%'){
    8000061c:	ff5515e3          	bne	a0,s5,80000606 <printf+0x92>
    c = fmt[++i] & 0xff;
    80000620:	2985                	addiw	s3,s3,1
    80000622:	013a07b3          	add	a5,s4,s3
    80000626:	0007c783          	lbu	a5,0(a5)
    8000062a:	0007849b          	sext.w	s1,a5
    if(c == 0)
    8000062e:	cbed                	beqz	a5,80000720 <printf+0x1ac>
    switch(c){
    80000630:	05778a63          	beq	a5,s7,80000684 <printf+0x110>
    80000634:	02fbf663          	bgeu	s7,a5,80000660 <printf+0xec>
    80000638:	09978863          	beq	a5,s9,800006c8 <printf+0x154>
    8000063c:	07800713          	li	a4,120
    80000640:	0ce79563          	bne	a5,a4,8000070a <printf+0x196>
      printint(va_arg(ap, int), 16, 1);
    80000644:	f8843783          	ld	a5,-120(s0)
    80000648:	00878713          	addi	a4,a5,8
    8000064c:	f8e43423          	sd	a4,-120(s0)
    80000650:	4605                	li	a2,1
    80000652:	85ea                	mv	a1,s10
    80000654:	4388                	lw	a0,0(a5)
    80000656:	00000097          	auipc	ra,0x0
    8000065a:	e32080e7          	jalr	-462(ra) # 80000488 <printint>
      break;
    8000065e:	bf45                	j	8000060e <printf+0x9a>
    switch(c){
    80000660:	09578f63          	beq	a5,s5,800006fe <printf+0x18a>
    80000664:	0b879363          	bne	a5,s8,8000070a <printf+0x196>
      printint(va_arg(ap, int), 10, 1);
    80000668:	f8843783          	ld	a5,-120(s0)
    8000066c:	00878713          	addi	a4,a5,8
    80000670:	f8e43423          	sd	a4,-120(s0)
    80000674:	4605                	li	a2,1
    80000676:	45a9                	li	a1,10
    80000678:	4388                	lw	a0,0(a5)
    8000067a:	00000097          	auipc	ra,0x0
    8000067e:	e0e080e7          	jalr	-498(ra) # 80000488 <printint>
      break;
    80000682:	b771                	j	8000060e <printf+0x9a>
      printptr(va_arg(ap, uint64));
    80000684:	f8843783          	ld	a5,-120(s0)
    80000688:	00878713          	addi	a4,a5,8
    8000068c:	f8e43423          	sd	a4,-120(s0)
    80000690:	0007b903          	ld	s2,0(a5)
  consputc('0');
    80000694:	03000513          	li	a0,48
    80000698:	00000097          	auipc	ra,0x0
    8000069c:	bd0080e7          	jalr	-1072(ra) # 80000268 <consputc>
  consputc('x');
    800006a0:	07800513          	li	a0,120
    800006a4:	00000097          	auipc	ra,0x0
    800006a8:	bc4080e7          	jalr	-1084(ra) # 80000268 <consputc>
    800006ac:	84ea                	mv	s1,s10
    consputc(digits[x >> (sizeof(uint64) * 8 - 4)]);
    800006ae:	03c95793          	srli	a5,s2,0x3c
    800006b2:	97da                	add	a5,a5,s6
    800006b4:	0007c503          	lbu	a0,0(a5)
    800006b8:	00000097          	auipc	ra,0x0
    800006bc:	bb0080e7          	jalr	-1104(ra) # 80000268 <consputc>
  for (i = 0; i < (sizeof(uint64) * 2); i++, x <<= 4)
    800006c0:	0912                	slli	s2,s2,0x4
    800006c2:	34fd                	addiw	s1,s1,-1
    800006c4:	f4ed                	bnez	s1,800006ae <printf+0x13a>
    800006c6:	b7a1                	j	8000060e <printf+0x9a>
      if((s = va_arg(ap, char*)) == 0)
    800006c8:	f8843783          	ld	a5,-120(s0)
    800006cc:	00878713          	addi	a4,a5,8
    800006d0:	f8e43423          	sd	a4,-120(s0)
    800006d4:	6384                	ld	s1,0(a5)
    800006d6:	cc89                	beqz	s1,800006f0 <printf+0x17c>
      for(; *s; s++)
    800006d8:	0004c503          	lbu	a0,0(s1)
    800006dc:	d90d                	beqz	a0,8000060e <printf+0x9a>
        consputc(*s);
    800006de:	00000097          	auipc	ra,0x0
    800006e2:	b8a080e7          	jalr	-1142(ra) # 80000268 <consputc>
      for(; *s; s++)
    800006e6:	0485                	addi	s1,s1,1
    800006e8:	0004c503          	lbu	a0,0(s1)
    800006ec:	f96d                	bnez	a0,800006de <printf+0x16a>
    800006ee:	b705                	j	8000060e <printf+0x9a>
        s = "(null)";
    800006f0:	00008497          	auipc	s1,0x8
    800006f4:	93048493          	addi	s1,s1,-1744 # 80008020 <etext+0x20>
      for(; *s; s++)
    800006f8:	02800513          	li	a0,40
    800006fc:	b7cd                	j	800006de <printf+0x16a>
      consputc('%');
    800006fe:	8556                	mv	a0,s5
    80000700:	00000097          	auipc	ra,0x0
    80000704:	b68080e7          	jalr	-1176(ra) # 80000268 <consputc>
      break;
    80000708:	b719                	j	8000060e <printf+0x9a>
      consputc('%');
    8000070a:	8556                	mv	a0,s5
    8000070c:	00000097          	auipc	ra,0x0
    80000710:	b5c080e7          	jalr	-1188(ra) # 80000268 <consputc>
      consputc(c);
    80000714:	8526                	mv	a0,s1
    80000716:	00000097          	auipc	ra,0x0
    8000071a:	b52080e7          	jalr	-1198(ra) # 80000268 <consputc>
      break;
    8000071e:	bdc5                	j	8000060e <printf+0x9a>
  if(locking)
    80000720:	020d9163          	bnez	s11,80000742 <printf+0x1ce>
}
    80000724:	70e6                	ld	ra,120(sp)
    80000726:	7446                	ld	s0,112(sp)
    80000728:	74a6                	ld	s1,104(sp)
    8000072a:	7906                	ld	s2,96(sp)
    8000072c:	69e6                	ld	s3,88(sp)
    8000072e:	6a46                	ld	s4,80(sp)
    80000730:	6aa6                	ld	s5,72(sp)
    80000732:	6b06                	ld	s6,64(sp)
    80000734:	7be2                	ld	s7,56(sp)
    80000736:	7c42                	ld	s8,48(sp)
    80000738:	7ca2                	ld	s9,40(sp)
    8000073a:	7d02                	ld	s10,32(sp)
    8000073c:	6de2                	ld	s11,24(sp)
    8000073e:	6129                	addi	sp,sp,192
    80000740:	8082                	ret
    release(&pr.lock);
    80000742:	00011517          	auipc	a0,0x11
    80000746:	ae650513          	addi	a0,a0,-1306 # 80011228 <pr>
    8000074a:	00000097          	auipc	ra,0x0
    8000074e:	52c080e7          	jalr	1324(ra) # 80000c76 <release>
}
    80000752:	bfc9                	j	80000724 <printf+0x1b0>

0000000080000754 <printfinit>:
    ;
}

void
printfinit(void)
{
    80000754:	1101                	addi	sp,sp,-32
    80000756:	ec06                	sd	ra,24(sp)
    80000758:	e822                	sd	s0,16(sp)
    8000075a:	e426                	sd	s1,8(sp)
    8000075c:	1000                	addi	s0,sp,32
  initlock(&pr.lock, "pr");
    8000075e:	00011497          	auipc	s1,0x11
    80000762:	aca48493          	addi	s1,s1,-1334 # 80011228 <pr>
    80000766:	00008597          	auipc	a1,0x8
    8000076a:	8d258593          	addi	a1,a1,-1838 # 80008038 <etext+0x38>
    8000076e:	8526                	mv	a0,s1
    80000770:	00000097          	auipc	ra,0x0
    80000774:	3c2080e7          	jalr	962(ra) # 80000b32 <initlock>
  pr.locking = 1;
    80000778:	4785                	li	a5,1
    8000077a:	cc9c                	sw	a5,24(s1)
}
    8000077c:	60e2                	ld	ra,24(sp)
    8000077e:	6442                	ld	s0,16(sp)
    80000780:	64a2                	ld	s1,8(sp)
    80000782:	6105                	addi	sp,sp,32
    80000784:	8082                	ret

0000000080000786 <uartinit>:

void uartstart();

void
uartinit(void)
{
    80000786:	1141                	addi	sp,sp,-16
    80000788:	e406                	sd	ra,8(sp)
    8000078a:	e022                	sd	s0,0(sp)
    8000078c:	0800                	addi	s0,sp,16
  // disable interrupts.
  WriteReg(IER, 0x00);
    8000078e:	100007b7          	lui	a5,0x10000
    80000792:	000780a3          	sb	zero,1(a5) # 10000001 <_entry-0x6fffffff>

  // special mode to set baud rate.
  WriteReg(LCR, LCR_BAUD_LATCH);
    80000796:	f8000713          	li	a4,-128
    8000079a:	00e781a3          	sb	a4,3(a5)

  // LSB for baud rate of 38.4K.
  WriteReg(0, 0x03);
    8000079e:	470d                	li	a4,3
    800007a0:	00e78023          	sb	a4,0(a5)

  // MSB for baud rate of 38.4K.
  WriteReg(1, 0x00);
    800007a4:	000780a3          	sb	zero,1(a5)

  // leave set-baud mode,
  // and set word length to 8 bits, no parity.
  WriteReg(LCR, LCR_EIGHT_BITS);
    800007a8:	00e781a3          	sb	a4,3(a5)

  // reset and enable FIFOs.
  WriteReg(FCR, FCR_FIFO_ENABLE | FCR_FIFO_CLEAR);
    800007ac:	469d                	li	a3,7
    800007ae:	00d78123          	sb	a3,2(a5)

  // enable transmit and receive interrupts.
  WriteReg(IER, IER_TX_ENABLE | IER_RX_ENABLE);
    800007b2:	00e780a3          	sb	a4,1(a5)

  initlock(&uart_tx_lock, "uart");
    800007b6:	00008597          	auipc	a1,0x8
    800007ba:	8a258593          	addi	a1,a1,-1886 # 80008058 <digits+0x18>
    800007be:	00011517          	auipc	a0,0x11
    800007c2:	a8a50513          	addi	a0,a0,-1398 # 80011248 <uart_tx_lock>
    800007c6:	00000097          	auipc	ra,0x0
    800007ca:	36c080e7          	jalr	876(ra) # 80000b32 <initlock>
}
    800007ce:	60a2                	ld	ra,8(sp)
    800007d0:	6402                	ld	s0,0(sp)
    800007d2:	0141                	addi	sp,sp,16
    800007d4:	8082                	ret

00000000800007d6 <uartputc_sync>:
// use interrupts, for use by kernel printf() and
// to echo characters. it spins waiting for the uart's
// output register to be empty.
void
uartputc_sync(int c)
{
    800007d6:	1101                	addi	sp,sp,-32
    800007d8:	ec06                	sd	ra,24(sp)
    800007da:	e822                	sd	s0,16(sp)
    800007dc:	e426                	sd	s1,8(sp)
    800007de:	1000                	addi	s0,sp,32
    800007e0:	84aa                	mv	s1,a0
  push_off();
    800007e2:	00000097          	auipc	ra,0x0
    800007e6:	394080e7          	jalr	916(ra) # 80000b76 <push_off>

  if(panicked){
    800007ea:	00009797          	auipc	a5,0x9
    800007ee:	8167a783          	lw	a5,-2026(a5) # 80009000 <panicked>
    for(;;)
      ;
  }

  // wait for Transmit Holding Empty to be set in LSR.
  while((ReadReg(LSR) & LSR_TX_IDLE) == 0)
    800007f2:	10000737          	lui	a4,0x10000
  if(panicked){
    800007f6:	c391                	beqz	a5,800007fa <uartputc_sync+0x24>
    for(;;)
    800007f8:	a001                	j	800007f8 <uartputc_sync+0x22>
  while((ReadReg(LSR) & LSR_TX_IDLE) == 0)
    800007fa:	00574783          	lbu	a5,5(a4) # 10000005 <_entry-0x6ffffffb>
    800007fe:	0207f793          	andi	a5,a5,32
    80000802:	dfe5                	beqz	a5,800007fa <uartputc_sync+0x24>
    ;
  WriteReg(THR, c);
    80000804:	0ff4f513          	andi	a0,s1,255
    80000808:	100007b7          	lui	a5,0x10000
    8000080c:	00a78023          	sb	a0,0(a5) # 10000000 <_entry-0x70000000>

  pop_off();
    80000810:	00000097          	auipc	ra,0x0
    80000814:	406080e7          	jalr	1030(ra) # 80000c16 <pop_off>
}
    80000818:	60e2                	ld	ra,24(sp)
    8000081a:	6442                	ld	s0,16(sp)
    8000081c:	64a2                	ld	s1,8(sp)
    8000081e:	6105                	addi	sp,sp,32
    80000820:	8082                	ret

0000000080000822 <uartstart>:
// called from both the top- and bottom-half.
void
uartstart()
{
  while(1){
    if(uart_tx_w == uart_tx_r){
    80000822:	00008797          	auipc	a5,0x8
    80000826:	7e67b783          	ld	a5,2022(a5) # 80009008 <uart_tx_r>
    8000082a:	00008717          	auipc	a4,0x8
    8000082e:	7e673703          	ld	a4,2022(a4) # 80009010 <uart_tx_w>
    80000832:	06f70a63          	beq	a4,a5,800008a6 <uartstart+0x84>
{
    80000836:	7139                	addi	sp,sp,-64
    80000838:	fc06                	sd	ra,56(sp)
    8000083a:	f822                	sd	s0,48(sp)
    8000083c:	f426                	sd	s1,40(sp)
    8000083e:	f04a                	sd	s2,32(sp)
    80000840:	ec4e                	sd	s3,24(sp)
    80000842:	e852                	sd	s4,16(sp)
    80000844:	e456                	sd	s5,8(sp)
    80000846:	0080                	addi	s0,sp,64
      // transmit buffer is empty.
      return;
    }
    
    if((ReadReg(LSR) & LSR_TX_IDLE) == 0){
    80000848:	10000937          	lui	s2,0x10000
      // so we cannot give it another byte.
      // it will interrupt when it's ready for a new byte.
      return;
    }
    
    int c = uart_tx_buf[uart_tx_r % UART_TX_BUF_SIZE];
    8000084c:	00011a17          	auipc	s4,0x11
    80000850:	9fca0a13          	addi	s4,s4,-1540 # 80011248 <uart_tx_lock>
    uart_tx_r += 1;
    80000854:	00008497          	auipc	s1,0x8
    80000858:	7b448493          	addi	s1,s1,1972 # 80009008 <uart_tx_r>
    if(uart_tx_w == uart_tx_r){
    8000085c:	00008997          	auipc	s3,0x8
    80000860:	7b498993          	addi	s3,s3,1972 # 80009010 <uart_tx_w>
    if((ReadReg(LSR) & LSR_TX_IDLE) == 0){
    80000864:	00594703          	lbu	a4,5(s2) # 10000005 <_entry-0x6ffffffb>
    80000868:	02077713          	andi	a4,a4,32
    8000086c:	c705                	beqz	a4,80000894 <uartstart+0x72>
    int c = uart_tx_buf[uart_tx_r % UART_TX_BUF_SIZE];
    8000086e:	01f7f713          	andi	a4,a5,31
    80000872:	9752                	add	a4,a4,s4
    80000874:	01874a83          	lbu	s5,24(a4)
    uart_tx_r += 1;
    80000878:	0785                	addi	a5,a5,1
    8000087a:	e09c                	sd	a5,0(s1)
    
    // maybe uartputc() is waiting for space in the buffer.
    wakeup(&uart_tx_r);
    8000087c:	8526                	mv	a0,s1
    8000087e:	00002097          	auipc	ra,0x2
    80000882:	ac0080e7          	jalr	-1344(ra) # 8000233e <wakeup>
    
    WriteReg(THR, c);
    80000886:	01590023          	sb	s5,0(s2)
    if(uart_tx_w == uart_tx_r){
    8000088a:	609c                	ld	a5,0(s1)
    8000088c:	0009b703          	ld	a4,0(s3)
    80000890:	fcf71ae3          	bne	a4,a5,80000864 <uartstart+0x42>
  }
}
    80000894:	70e2                	ld	ra,56(sp)
    80000896:	7442                	ld	s0,48(sp)
    80000898:	74a2                	ld	s1,40(sp)
    8000089a:	7902                	ld	s2,32(sp)
    8000089c:	69e2                	ld	s3,24(sp)
    8000089e:	6a42                	ld	s4,16(sp)
    800008a0:	6aa2                	ld	s5,8(sp)
    800008a2:	6121                	addi	sp,sp,64
    800008a4:	8082                	ret
    800008a6:	8082                	ret

00000000800008a8 <uartputc>:
{
    800008a8:	7179                	addi	sp,sp,-48
    800008aa:	f406                	sd	ra,40(sp)
    800008ac:	f022                	sd	s0,32(sp)
    800008ae:	ec26                	sd	s1,24(sp)
    800008b0:	e84a                	sd	s2,16(sp)
    800008b2:	e44e                	sd	s3,8(sp)
    800008b4:	e052                	sd	s4,0(sp)
    800008b6:	1800                	addi	s0,sp,48
    800008b8:	8a2a                	mv	s4,a0
  acquire(&uart_tx_lock);
    800008ba:	00011517          	auipc	a0,0x11
    800008be:	98e50513          	addi	a0,a0,-1650 # 80011248 <uart_tx_lock>
    800008c2:	00000097          	auipc	ra,0x0
    800008c6:	300080e7          	jalr	768(ra) # 80000bc2 <acquire>
  if(panicked){
    800008ca:	00008797          	auipc	a5,0x8
    800008ce:	7367a783          	lw	a5,1846(a5) # 80009000 <panicked>
    800008d2:	c391                	beqz	a5,800008d6 <uartputc+0x2e>
    for(;;)
    800008d4:	a001                	j	800008d4 <uartputc+0x2c>
    if(uart_tx_w == uart_tx_r + UART_TX_BUF_SIZE){
    800008d6:	00008717          	auipc	a4,0x8
    800008da:	73a73703          	ld	a4,1850(a4) # 80009010 <uart_tx_w>
    800008de:	00008797          	auipc	a5,0x8
    800008e2:	72a7b783          	ld	a5,1834(a5) # 80009008 <uart_tx_r>
    800008e6:	02078793          	addi	a5,a5,32
    800008ea:	02e79b63          	bne	a5,a4,80000920 <uartputc+0x78>
      sleep(&uart_tx_r, &uart_tx_lock);
    800008ee:	00011997          	auipc	s3,0x11
    800008f2:	95a98993          	addi	s3,s3,-1702 # 80011248 <uart_tx_lock>
    800008f6:	00008497          	auipc	s1,0x8
    800008fa:	71248493          	addi	s1,s1,1810 # 80009008 <uart_tx_r>
    if(uart_tx_w == uart_tx_r + UART_TX_BUF_SIZE){
    800008fe:	00008917          	auipc	s2,0x8
    80000902:	71290913          	addi	s2,s2,1810 # 80009010 <uart_tx_w>
      sleep(&uart_tx_r, &uart_tx_lock);
    80000906:	85ce                	mv	a1,s3
    80000908:	8526                	mv	a0,s1
    8000090a:	00002097          	auipc	ra,0x2
    8000090e:	8b4080e7          	jalr	-1868(ra) # 800021be <sleep>
    if(uart_tx_w == uart_tx_r + UART_TX_BUF_SIZE){
    80000912:	00093703          	ld	a4,0(s2)
    80000916:	609c                	ld	a5,0(s1)
    80000918:	02078793          	addi	a5,a5,32
    8000091c:	fee785e3          	beq	a5,a4,80000906 <uartputc+0x5e>
      uart_tx_buf[uart_tx_w % UART_TX_BUF_SIZE] = c;
    80000920:	00011497          	auipc	s1,0x11
    80000924:	92848493          	addi	s1,s1,-1752 # 80011248 <uart_tx_lock>
    80000928:	01f77793          	andi	a5,a4,31
    8000092c:	97a6                	add	a5,a5,s1
    8000092e:	01478c23          	sb	s4,24(a5)
      uart_tx_w += 1;
    80000932:	0705                	addi	a4,a4,1
    80000934:	00008797          	auipc	a5,0x8
    80000938:	6ce7be23          	sd	a4,1756(a5) # 80009010 <uart_tx_w>
      uartstart();
    8000093c:	00000097          	auipc	ra,0x0
    80000940:	ee6080e7          	jalr	-282(ra) # 80000822 <uartstart>
      release(&uart_tx_lock);
    80000944:	8526                	mv	a0,s1
    80000946:	00000097          	auipc	ra,0x0
    8000094a:	330080e7          	jalr	816(ra) # 80000c76 <release>
}
    8000094e:	70a2                	ld	ra,40(sp)
    80000950:	7402                	ld	s0,32(sp)
    80000952:	64e2                	ld	s1,24(sp)
    80000954:	6942                	ld	s2,16(sp)
    80000956:	69a2                	ld	s3,8(sp)
    80000958:	6a02                	ld	s4,0(sp)
    8000095a:	6145                	addi	sp,sp,48
    8000095c:	8082                	ret

000000008000095e <uartgetc>:

// read one input character from the UART.
// return -1 if none is waiting.
int
uartgetc(void)
{
    8000095e:	1141                	addi	sp,sp,-16
    80000960:	e422                	sd	s0,8(sp)
    80000962:	0800                	addi	s0,sp,16
  if(ReadReg(LSR) & 0x01){
    80000964:	100007b7          	lui	a5,0x10000
    80000968:	0057c783          	lbu	a5,5(a5) # 10000005 <_entry-0x6ffffffb>
    8000096c:	8b85                	andi	a5,a5,1
    8000096e:	cb91                	beqz	a5,80000982 <uartgetc+0x24>
    // input data is ready.
    return ReadReg(RHR);
    80000970:	100007b7          	lui	a5,0x10000
    80000974:	0007c503          	lbu	a0,0(a5) # 10000000 <_entry-0x70000000>
    80000978:	0ff57513          	andi	a0,a0,255
  } else {
    return -1;
  }
}
    8000097c:	6422                	ld	s0,8(sp)
    8000097e:	0141                	addi	sp,sp,16
    80000980:	8082                	ret
    return -1;
    80000982:	557d                	li	a0,-1
    80000984:	bfe5                	j	8000097c <uartgetc+0x1e>

0000000080000986 <uartintr>:
// handle a uart interrupt, raised because input has
// arrived, or the uart is ready for more output, or
// both. called from trap.c.
void
uartintr(void)
{
    80000986:	1101                	addi	sp,sp,-32
    80000988:	ec06                	sd	ra,24(sp)
    8000098a:	e822                	sd	s0,16(sp)
    8000098c:	e426                	sd	s1,8(sp)
    8000098e:	1000                	addi	s0,sp,32
  // read and process incoming characters.
  while(1){
    int c = uartgetc();
    if(c == -1)
    80000990:	54fd                	li	s1,-1
    80000992:	a029                	j	8000099c <uartintr+0x16>
      break;
    consoleintr(c);
    80000994:	00000097          	auipc	ra,0x0
    80000998:	916080e7          	jalr	-1770(ra) # 800002aa <consoleintr>
    int c = uartgetc();
    8000099c:	00000097          	auipc	ra,0x0
    800009a0:	fc2080e7          	jalr	-62(ra) # 8000095e <uartgetc>
    if(c == -1)
    800009a4:	fe9518e3          	bne	a0,s1,80000994 <uartintr+0xe>
  }

  // send buffered characters.
  acquire(&uart_tx_lock);
    800009a8:	00011497          	auipc	s1,0x11
    800009ac:	8a048493          	addi	s1,s1,-1888 # 80011248 <uart_tx_lock>
    800009b0:	8526                	mv	a0,s1
    800009b2:	00000097          	auipc	ra,0x0
    800009b6:	210080e7          	jalr	528(ra) # 80000bc2 <acquire>
  uartstart();
    800009ba:	00000097          	auipc	ra,0x0
    800009be:	e68080e7          	jalr	-408(ra) # 80000822 <uartstart>
  release(&uart_tx_lock);
    800009c2:	8526                	mv	a0,s1
    800009c4:	00000097          	auipc	ra,0x0
    800009c8:	2b2080e7          	jalr	690(ra) # 80000c76 <release>
}
    800009cc:	60e2                	ld	ra,24(sp)
    800009ce:	6442                	ld	s0,16(sp)
    800009d0:	64a2                	ld	s1,8(sp)
    800009d2:	6105                	addi	sp,sp,32
    800009d4:	8082                	ret

00000000800009d6 <kfree>:
// which normally should have been returned by a
// call to kalloc().  (The exception is when
// initializing the allocator; see kinit above.)
void
kfree(void *pa)
{
    800009d6:	1101                	addi	sp,sp,-32
    800009d8:	ec06                	sd	ra,24(sp)
    800009da:	e822                	sd	s0,16(sp)
    800009dc:	e426                	sd	s1,8(sp)
    800009de:	e04a                	sd	s2,0(sp)
    800009e0:	1000                	addi	s0,sp,32
  struct run *r;

  if(((uint64)pa % PGSIZE) != 0 || (char*)pa < end || (uint64)pa >= PHYSTOP)
    800009e2:	03451793          	slli	a5,a0,0x34
    800009e6:	ebb9                	bnez	a5,80000a3c <kfree+0x66>
    800009e8:	84aa                	mv	s1,a0
    800009ea:	00020797          	auipc	a5,0x20
    800009ee:	61678793          	addi	a5,a5,1558 # 80021000 <end>
    800009f2:	04f56563          	bltu	a0,a5,80000a3c <kfree+0x66>
    800009f6:	47c5                	li	a5,17
    800009f8:	07ee                	slli	a5,a5,0x1b
    800009fa:	04f57163          	bgeu	a0,a5,80000a3c <kfree+0x66>
    panic("kfree");

  // Fill with junk to catch dangling refs.
  memset(pa, 1, PGSIZE);
    800009fe:	6605                	lui	a2,0x1
    80000a00:	4585                	li	a1,1
    80000a02:	00000097          	auipc	ra,0x0
    80000a06:	2bc080e7          	jalr	700(ra) # 80000cbe <memset>

  r = (struct run*)pa;

  acquire(&kmem.lock);
    80000a0a:	00011917          	auipc	s2,0x11
    80000a0e:	87690913          	addi	s2,s2,-1930 # 80011280 <kmem>
    80000a12:	854a                	mv	a0,s2
    80000a14:	00000097          	auipc	ra,0x0
    80000a18:	1ae080e7          	jalr	430(ra) # 80000bc2 <acquire>
  r->next = kmem.freelist;
    80000a1c:	01893783          	ld	a5,24(s2)
    80000a20:	e09c                	sd	a5,0(s1)
  kmem.freelist = r;
    80000a22:	00993c23          	sd	s1,24(s2)
  release(&kmem.lock);
    80000a26:	854a                	mv	a0,s2
    80000a28:	00000097          	auipc	ra,0x0
    80000a2c:	24e080e7          	jalr	590(ra) # 80000c76 <release>
}
    80000a30:	60e2                	ld	ra,24(sp)
    80000a32:	6442                	ld	s0,16(sp)
    80000a34:	64a2                	ld	s1,8(sp)
    80000a36:	6902                	ld	s2,0(sp)
    80000a38:	6105                	addi	sp,sp,32
    80000a3a:	8082                	ret
    panic("kfree");
    80000a3c:	00007517          	auipc	a0,0x7
    80000a40:	62450513          	addi	a0,a0,1572 # 80008060 <digits+0x20>
    80000a44:	00000097          	auipc	ra,0x0
    80000a48:	ae6080e7          	jalr	-1306(ra) # 8000052a <panic>

0000000080000a4c <freerange>:
{
    80000a4c:	7179                	addi	sp,sp,-48
    80000a4e:	f406                	sd	ra,40(sp)
    80000a50:	f022                	sd	s0,32(sp)
    80000a52:	ec26                	sd	s1,24(sp)
    80000a54:	e84a                	sd	s2,16(sp)
    80000a56:	e44e                	sd	s3,8(sp)
    80000a58:	e052                	sd	s4,0(sp)
    80000a5a:	1800                	addi	s0,sp,48
  p = (char*)PGROUNDUP((uint64)pa_start);
    80000a5c:	6785                	lui	a5,0x1
    80000a5e:	fff78493          	addi	s1,a5,-1 # fff <_entry-0x7ffff001>
    80000a62:	94aa                	add	s1,s1,a0
    80000a64:	757d                	lui	a0,0xfffff
    80000a66:	8ce9                	and	s1,s1,a0
  for(; p + PGSIZE <= (char*)pa_end; p += PGSIZE)
    80000a68:	94be                	add	s1,s1,a5
    80000a6a:	0095ee63          	bltu	a1,s1,80000a86 <freerange+0x3a>
    80000a6e:	892e                	mv	s2,a1
    kfree(p);
    80000a70:	7a7d                	lui	s4,0xfffff
  for(; p + PGSIZE <= (char*)pa_end; p += PGSIZE)
    80000a72:	6985                	lui	s3,0x1
    kfree(p);
    80000a74:	01448533          	add	a0,s1,s4
    80000a78:	00000097          	auipc	ra,0x0
    80000a7c:	f5e080e7          	jalr	-162(ra) # 800009d6 <kfree>
  for(; p + PGSIZE <= (char*)pa_end; p += PGSIZE)
    80000a80:	94ce                	add	s1,s1,s3
    80000a82:	fe9979e3          	bgeu	s2,s1,80000a74 <freerange+0x28>
}
    80000a86:	70a2                	ld	ra,40(sp)
    80000a88:	7402                	ld	s0,32(sp)
    80000a8a:	64e2                	ld	s1,24(sp)
    80000a8c:	6942                	ld	s2,16(sp)
    80000a8e:	69a2                	ld	s3,8(sp)
    80000a90:	6a02                	ld	s4,0(sp)
    80000a92:	6145                	addi	sp,sp,48
    80000a94:	8082                	ret

0000000080000a96 <kinit>:
{
    80000a96:	1141                	addi	sp,sp,-16
    80000a98:	e406                	sd	ra,8(sp)
    80000a9a:	e022                	sd	s0,0(sp)
    80000a9c:	0800                	addi	s0,sp,16
  initlock(&kmem.lock, "kmem");
    80000a9e:	00007597          	auipc	a1,0x7
    80000aa2:	5ca58593          	addi	a1,a1,1482 # 80008068 <digits+0x28>
    80000aa6:	00010517          	auipc	a0,0x10
    80000aaa:	7da50513          	addi	a0,a0,2010 # 80011280 <kmem>
    80000aae:	00000097          	auipc	ra,0x0
    80000ab2:	084080e7          	jalr	132(ra) # 80000b32 <initlock>
  freerange(end, (void*)PHYSTOP);
    80000ab6:	45c5                	li	a1,17
    80000ab8:	05ee                	slli	a1,a1,0x1b
    80000aba:	00020517          	auipc	a0,0x20
    80000abe:	54650513          	addi	a0,a0,1350 # 80021000 <end>
    80000ac2:	00000097          	auipc	ra,0x0
    80000ac6:	f8a080e7          	jalr	-118(ra) # 80000a4c <freerange>
}
    80000aca:	60a2                	ld	ra,8(sp)
    80000acc:	6402                	ld	s0,0(sp)
    80000ace:	0141                	addi	sp,sp,16
    80000ad0:	8082                	ret

0000000080000ad2 <kalloc>:
// Allocate one 4096-byte page of physical memory.
// Returns a pointer that the kernel can use.
// Returns 0 if the memory cannot be allocated.
void *
kalloc(void)
{
    80000ad2:	1101                	addi	sp,sp,-32
    80000ad4:	ec06                	sd	ra,24(sp)
    80000ad6:	e822                	sd	s0,16(sp)
    80000ad8:	e426                	sd	s1,8(sp)
    80000ada:	1000                	addi	s0,sp,32
  struct run *r;

  acquire(&kmem.lock);
    80000adc:	00010497          	auipc	s1,0x10
    80000ae0:	7a448493          	addi	s1,s1,1956 # 80011280 <kmem>
    80000ae4:	8526                	mv	a0,s1
    80000ae6:	00000097          	auipc	ra,0x0
    80000aea:	0dc080e7          	jalr	220(ra) # 80000bc2 <acquire>
  r = kmem.freelist;
    80000aee:	6c84                	ld	s1,24(s1)
  if(r)
    80000af0:	c885                	beqz	s1,80000b20 <kalloc+0x4e>
    kmem.freelist = r->next;
    80000af2:	609c                	ld	a5,0(s1)
    80000af4:	00010517          	auipc	a0,0x10
    80000af8:	78c50513          	addi	a0,a0,1932 # 80011280 <kmem>
    80000afc:	ed1c                	sd	a5,24(a0)
  release(&kmem.lock);
    80000afe:	00000097          	auipc	ra,0x0
    80000b02:	178080e7          	jalr	376(ra) # 80000c76 <release>

  if(r)
    memset((char*)r, 5, PGSIZE); // fill with junk
    80000b06:	6605                	lui	a2,0x1
    80000b08:	4595                	li	a1,5
    80000b0a:	8526                	mv	a0,s1
    80000b0c:	00000097          	auipc	ra,0x0
    80000b10:	1b2080e7          	jalr	434(ra) # 80000cbe <memset>
  return (void*)r;
}
    80000b14:	8526                	mv	a0,s1
    80000b16:	60e2                	ld	ra,24(sp)
    80000b18:	6442                	ld	s0,16(sp)
    80000b1a:	64a2                	ld	s1,8(sp)
    80000b1c:	6105                	addi	sp,sp,32
    80000b1e:	8082                	ret
  release(&kmem.lock);
    80000b20:	00010517          	auipc	a0,0x10
    80000b24:	76050513          	addi	a0,a0,1888 # 80011280 <kmem>
    80000b28:	00000097          	auipc	ra,0x0
    80000b2c:	14e080e7          	jalr	334(ra) # 80000c76 <release>
  if(r)
    80000b30:	b7d5                	j	80000b14 <kalloc+0x42>

0000000080000b32 <initlock>:
#include "proc.h"
#include "defs.h"

void
initlock(struct spinlock *lk, char *name)
{
    80000b32:	1141                	addi	sp,sp,-16
    80000b34:	e422                	sd	s0,8(sp)
    80000b36:	0800                	addi	s0,sp,16
  lk->name = name;
    80000b38:	e50c                	sd	a1,8(a0)
  lk->locked = 0;
    80000b3a:	00052023          	sw	zero,0(a0)
  lk->cpu = 0;
    80000b3e:	00053823          	sd	zero,16(a0)
}
    80000b42:	6422                	ld	s0,8(sp)
    80000b44:	0141                	addi	sp,sp,16
    80000b46:	8082                	ret

0000000080000b48 <holding>:
// Interrupts must be off.
int
holding(struct spinlock *lk)
{
  int r;
  r = (lk->locked && lk->cpu == mycpu());
    80000b48:	411c                	lw	a5,0(a0)
    80000b4a:	e399                	bnez	a5,80000b50 <holding+0x8>
    80000b4c:	4501                	li	a0,0
  return r;
}
    80000b4e:	8082                	ret
{
    80000b50:	1101                	addi	sp,sp,-32
    80000b52:	ec06                	sd	ra,24(sp)
    80000b54:	e822                	sd	s0,16(sp)
    80000b56:	e426                	sd	s1,8(sp)
    80000b58:	1000                	addi	s0,sp,32
  r = (lk->locked && lk->cpu == mycpu());
    80000b5a:	6904                	ld	s1,16(a0)
    80000b5c:	00001097          	auipc	ra,0x1
    80000b60:	e32080e7          	jalr	-462(ra) # 8000198e <mycpu>
    80000b64:	40a48533          	sub	a0,s1,a0
    80000b68:	00153513          	seqz	a0,a0
}
    80000b6c:	60e2                	ld	ra,24(sp)
    80000b6e:	6442                	ld	s0,16(sp)
    80000b70:	64a2                	ld	s1,8(sp)
    80000b72:	6105                	addi	sp,sp,32
    80000b74:	8082                	ret

0000000080000b76 <push_off>:
// it takes two pop_off()s to undo two push_off()s.  Also, if interrupts
// are initially off, then push_off, pop_off leaves them off.

void
push_off(void)
{
    80000b76:	1101                	addi	sp,sp,-32
    80000b78:	ec06                	sd	ra,24(sp)
    80000b7a:	e822                	sd	s0,16(sp)
    80000b7c:	e426                	sd	s1,8(sp)
    80000b7e:	1000                	addi	s0,sp,32
  asm volatile("csrr %0, sstatus" : "=r" (x) );
    80000b80:	100024f3          	csrr	s1,sstatus
    80000b84:	100027f3          	csrr	a5,sstatus
  w_sstatus(r_sstatus() & ~SSTATUS_SIE);
    80000b88:	9bf5                	andi	a5,a5,-3
  asm volatile("csrw sstatus, %0" : : "r" (x));
    80000b8a:	10079073          	csrw	sstatus,a5
  int old = intr_get();

  intr_off();
  if(mycpu()->noff == 0)
    80000b8e:	00001097          	auipc	ra,0x1
    80000b92:	e00080e7          	jalr	-512(ra) # 8000198e <mycpu>
    80000b96:	5d3c                	lw	a5,120(a0)
    80000b98:	cf89                	beqz	a5,80000bb2 <push_off+0x3c>
    mycpu()->intena = old;
  mycpu()->noff += 1;
    80000b9a:	00001097          	auipc	ra,0x1
    80000b9e:	df4080e7          	jalr	-524(ra) # 8000198e <mycpu>
    80000ba2:	5d3c                	lw	a5,120(a0)
    80000ba4:	2785                	addiw	a5,a5,1
    80000ba6:	dd3c                	sw	a5,120(a0)
}
    80000ba8:	60e2                	ld	ra,24(sp)
    80000baa:	6442                	ld	s0,16(sp)
    80000bac:	64a2                	ld	s1,8(sp)
    80000bae:	6105                	addi	sp,sp,32
    80000bb0:	8082                	ret
    mycpu()->intena = old;
    80000bb2:	00001097          	auipc	ra,0x1
    80000bb6:	ddc080e7          	jalr	-548(ra) # 8000198e <mycpu>
  return (x & SSTATUS_SIE) != 0;
    80000bba:	8085                	srli	s1,s1,0x1
    80000bbc:	8885                	andi	s1,s1,1
    80000bbe:	dd64                	sw	s1,124(a0)
    80000bc0:	bfe9                	j	80000b9a <push_off+0x24>

0000000080000bc2 <acquire>:
{
    80000bc2:	1101                	addi	sp,sp,-32
    80000bc4:	ec06                	sd	ra,24(sp)
    80000bc6:	e822                	sd	s0,16(sp)
    80000bc8:	e426                	sd	s1,8(sp)
    80000bca:	1000                	addi	s0,sp,32
    80000bcc:	84aa                	mv	s1,a0
  push_off(); // disable interrupts to avoid deadlock.
    80000bce:	00000097          	auipc	ra,0x0
    80000bd2:	fa8080e7          	jalr	-88(ra) # 80000b76 <push_off>
  if(holding(lk))
    80000bd6:	8526                	mv	a0,s1
    80000bd8:	00000097          	auipc	ra,0x0
    80000bdc:	f70080e7          	jalr	-144(ra) # 80000b48 <holding>
  while(__sync_lock_test_and_set(&lk->locked, 1) != 0)
    80000be0:	4705                	li	a4,1
  if(holding(lk))
    80000be2:	e115                	bnez	a0,80000c06 <acquire+0x44>
  while(__sync_lock_test_and_set(&lk->locked, 1) != 0)
    80000be4:	87ba                	mv	a5,a4
    80000be6:	0cf4a7af          	amoswap.w.aq	a5,a5,(s1)
    80000bea:	2781                	sext.w	a5,a5
    80000bec:	ffe5                	bnez	a5,80000be4 <acquire+0x22>
  __sync_synchronize();
    80000bee:	0ff0000f          	fence
  lk->cpu = mycpu();
    80000bf2:	00001097          	auipc	ra,0x1
    80000bf6:	d9c080e7          	jalr	-612(ra) # 8000198e <mycpu>
    80000bfa:	e888                	sd	a0,16(s1)
}
    80000bfc:	60e2                	ld	ra,24(sp)
    80000bfe:	6442                	ld	s0,16(sp)
    80000c00:	64a2                	ld	s1,8(sp)
    80000c02:	6105                	addi	sp,sp,32
    80000c04:	8082                	ret
    panic("acquire");
    80000c06:	00007517          	auipc	a0,0x7
    80000c0a:	46a50513          	addi	a0,a0,1130 # 80008070 <digits+0x30>
    80000c0e:	00000097          	auipc	ra,0x0
    80000c12:	91c080e7          	jalr	-1764(ra) # 8000052a <panic>

0000000080000c16 <pop_off>:

void
pop_off(void)
{
    80000c16:	1141                	addi	sp,sp,-16
    80000c18:	e406                	sd	ra,8(sp)
    80000c1a:	e022                	sd	s0,0(sp)
    80000c1c:	0800                	addi	s0,sp,16
  struct cpu *c = mycpu();
    80000c1e:	00001097          	auipc	ra,0x1
    80000c22:	d70080e7          	jalr	-656(ra) # 8000198e <mycpu>
  asm volatile("csrr %0, sstatus" : "=r" (x) );
    80000c26:	100027f3          	csrr	a5,sstatus
  return (x & SSTATUS_SIE) != 0;
    80000c2a:	8b89                	andi	a5,a5,2
  if(intr_get())
    80000c2c:	e78d                	bnez	a5,80000c56 <pop_off+0x40>
    panic("pop_off - interruptible");
  if(c->noff < 1)
    80000c2e:	5d3c                	lw	a5,120(a0)
    80000c30:	02f05b63          	blez	a5,80000c66 <pop_off+0x50>
    panic("pop_off");
  c->noff -= 1;
    80000c34:	37fd                	addiw	a5,a5,-1
    80000c36:	0007871b          	sext.w	a4,a5
    80000c3a:	dd3c                	sw	a5,120(a0)
  if(c->noff == 0 && c->intena)
    80000c3c:	eb09                	bnez	a4,80000c4e <pop_off+0x38>
    80000c3e:	5d7c                	lw	a5,124(a0)
    80000c40:	c799                	beqz	a5,80000c4e <pop_off+0x38>
  asm volatile("csrr %0, sstatus" : "=r" (x) );
    80000c42:	100027f3          	csrr	a5,sstatus
  w_sstatus(r_sstatus() | SSTATUS_SIE);
    80000c46:	0027e793          	ori	a5,a5,2
  asm volatile("csrw sstatus, %0" : : "r" (x));
    80000c4a:	10079073          	csrw	sstatus,a5
    intr_on();
}
    80000c4e:	60a2                	ld	ra,8(sp)
    80000c50:	6402                	ld	s0,0(sp)
    80000c52:	0141                	addi	sp,sp,16
    80000c54:	8082                	ret
    panic("pop_off - interruptible");
    80000c56:	00007517          	auipc	a0,0x7
    80000c5a:	42250513          	addi	a0,a0,1058 # 80008078 <digits+0x38>
    80000c5e:	00000097          	auipc	ra,0x0
    80000c62:	8cc080e7          	jalr	-1844(ra) # 8000052a <panic>
    panic("pop_off");
    80000c66:	00007517          	auipc	a0,0x7
    80000c6a:	42a50513          	addi	a0,a0,1066 # 80008090 <digits+0x50>
    80000c6e:	00000097          	auipc	ra,0x0
    80000c72:	8bc080e7          	jalr	-1860(ra) # 8000052a <panic>

0000000080000c76 <release>:
{
    80000c76:	1101                	addi	sp,sp,-32
    80000c78:	ec06                	sd	ra,24(sp)
    80000c7a:	e822                	sd	s0,16(sp)
    80000c7c:	e426                	sd	s1,8(sp)
    80000c7e:	1000                	addi	s0,sp,32
    80000c80:	84aa                	mv	s1,a0
  if(!holding(lk))
    80000c82:	00000097          	auipc	ra,0x0
    80000c86:	ec6080e7          	jalr	-314(ra) # 80000b48 <holding>
    80000c8a:	c115                	beqz	a0,80000cae <release+0x38>
  lk->cpu = 0;
    80000c8c:	0004b823          	sd	zero,16(s1)
  __sync_synchronize();
    80000c90:	0ff0000f          	fence
  __sync_lock_release(&lk->locked);
    80000c94:	0f50000f          	fence	iorw,ow
    80000c98:	0804a02f          	amoswap.w	zero,zero,(s1)
  pop_off();
    80000c9c:	00000097          	auipc	ra,0x0
    80000ca0:	f7a080e7          	jalr	-134(ra) # 80000c16 <pop_off>
}
    80000ca4:	60e2                	ld	ra,24(sp)
    80000ca6:	6442                	ld	s0,16(sp)
    80000ca8:	64a2                	ld	s1,8(sp)
    80000caa:	6105                	addi	sp,sp,32
    80000cac:	8082                	ret
    panic("release");
    80000cae:	00007517          	auipc	a0,0x7
    80000cb2:	3ea50513          	addi	a0,a0,1002 # 80008098 <digits+0x58>
    80000cb6:	00000097          	auipc	ra,0x0
    80000cba:	874080e7          	jalr	-1932(ra) # 8000052a <panic>

0000000080000cbe <memset>:
#include "types.h"

void*
memset(void *dst, int c, uint n)
{
    80000cbe:	1141                	addi	sp,sp,-16
    80000cc0:	e422                	sd	s0,8(sp)
    80000cc2:	0800                	addi	s0,sp,16
  char *cdst = (char *) dst;
  int i;
  for(i = 0; i < n; i++){
    80000cc4:	ca19                	beqz	a2,80000cda <memset+0x1c>
    80000cc6:	87aa                	mv	a5,a0
    80000cc8:	1602                	slli	a2,a2,0x20
    80000cca:	9201                	srli	a2,a2,0x20
    80000ccc:	00a60733          	add	a4,a2,a0
    cdst[i] = c;
    80000cd0:	00b78023          	sb	a1,0(a5)
  for(i = 0; i < n; i++){
    80000cd4:	0785                	addi	a5,a5,1
    80000cd6:	fee79de3          	bne	a5,a4,80000cd0 <memset+0x12>
  }
  return dst;
}
    80000cda:	6422                	ld	s0,8(sp)
    80000cdc:	0141                	addi	sp,sp,16
    80000cde:	8082                	ret

0000000080000ce0 <memcmp>:

int
memcmp(const void *v1, const void *v2, uint n)
{
    80000ce0:	1141                	addi	sp,sp,-16
    80000ce2:	e422                	sd	s0,8(sp)
    80000ce4:	0800                	addi	s0,sp,16
  const uchar *s1, *s2;

  s1 = v1;
  s2 = v2;
  while(n-- > 0){
    80000ce6:	ca05                	beqz	a2,80000d16 <memcmp+0x36>
    80000ce8:	fff6069b          	addiw	a3,a2,-1
    80000cec:	1682                	slli	a3,a3,0x20
    80000cee:	9281                	srli	a3,a3,0x20
    80000cf0:	0685                	addi	a3,a3,1
    80000cf2:	96aa                	add	a3,a3,a0
    if(*s1 != *s2)
    80000cf4:	00054783          	lbu	a5,0(a0)
    80000cf8:	0005c703          	lbu	a4,0(a1)
    80000cfc:	00e79863          	bne	a5,a4,80000d0c <memcmp+0x2c>
      return *s1 - *s2;
    s1++, s2++;
    80000d00:	0505                	addi	a0,a0,1
    80000d02:	0585                	addi	a1,a1,1
  while(n-- > 0){
    80000d04:	fed518e3          	bne	a0,a3,80000cf4 <memcmp+0x14>
  }

  return 0;
    80000d08:	4501                	li	a0,0
    80000d0a:	a019                	j	80000d10 <memcmp+0x30>
      return *s1 - *s2;
    80000d0c:	40e7853b          	subw	a0,a5,a4
}
    80000d10:	6422                	ld	s0,8(sp)
    80000d12:	0141                	addi	sp,sp,16
    80000d14:	8082                	ret
  return 0;
    80000d16:	4501                	li	a0,0
    80000d18:	bfe5                	j	80000d10 <memcmp+0x30>

0000000080000d1a <memmove>:

void*
memmove(void *dst, const void *src, uint n)
{
    80000d1a:	1141                	addi	sp,sp,-16
    80000d1c:	e422                	sd	s0,8(sp)
    80000d1e:	0800                	addi	s0,sp,16
  const char *s;
  char *d;

  s = src;
  d = dst;
  if(s < d && s + n > d){
    80000d20:	02a5e563          	bltu	a1,a0,80000d4a <memmove+0x30>
    s += n;
    d += n;
    while(n-- > 0)
      *--d = *--s;
  } else
    while(n-- > 0)
    80000d24:	fff6069b          	addiw	a3,a2,-1
    80000d28:	ce11                	beqz	a2,80000d44 <memmove+0x2a>
    80000d2a:	1682                	slli	a3,a3,0x20
    80000d2c:	9281                	srli	a3,a3,0x20
    80000d2e:	0685                	addi	a3,a3,1
    80000d30:	96ae                	add	a3,a3,a1
    80000d32:	87aa                	mv	a5,a0
      *d++ = *s++;
    80000d34:	0585                	addi	a1,a1,1
    80000d36:	0785                	addi	a5,a5,1
    80000d38:	fff5c703          	lbu	a4,-1(a1)
    80000d3c:	fee78fa3          	sb	a4,-1(a5)
    while(n-- > 0)
    80000d40:	fed59ae3          	bne	a1,a3,80000d34 <memmove+0x1a>

  return dst;
}
    80000d44:	6422                	ld	s0,8(sp)
    80000d46:	0141                	addi	sp,sp,16
    80000d48:	8082                	ret
  if(s < d && s + n > d){
    80000d4a:	02061713          	slli	a4,a2,0x20
    80000d4e:	9301                	srli	a4,a4,0x20
    80000d50:	00e587b3          	add	a5,a1,a4
    80000d54:	fcf578e3          	bgeu	a0,a5,80000d24 <memmove+0xa>
    d += n;
    80000d58:	972a                	add	a4,a4,a0
    while(n-- > 0)
    80000d5a:	fff6069b          	addiw	a3,a2,-1
    80000d5e:	d27d                	beqz	a2,80000d44 <memmove+0x2a>
    80000d60:	02069613          	slli	a2,a3,0x20
    80000d64:	9201                	srli	a2,a2,0x20
    80000d66:	fff64613          	not	a2,a2
    80000d6a:	963e                	add	a2,a2,a5
      *--d = *--s;
    80000d6c:	17fd                	addi	a5,a5,-1
    80000d6e:	177d                	addi	a4,a4,-1
    80000d70:	0007c683          	lbu	a3,0(a5)
    80000d74:	00d70023          	sb	a3,0(a4)
    while(n-- > 0)
    80000d78:	fef61ae3          	bne	a2,a5,80000d6c <memmove+0x52>
    80000d7c:	b7e1                	j	80000d44 <memmove+0x2a>

0000000080000d7e <memcpy>:

// memcpy exists to placate GCC.  Use memmove.
void*
memcpy(void *dst, const void *src, uint n)
{
    80000d7e:	1141                	addi	sp,sp,-16
    80000d80:	e406                	sd	ra,8(sp)
    80000d82:	e022                	sd	s0,0(sp)
    80000d84:	0800                	addi	s0,sp,16
  return memmove(dst, src, n);
    80000d86:	00000097          	auipc	ra,0x0
    80000d8a:	f94080e7          	jalr	-108(ra) # 80000d1a <memmove>
}
    80000d8e:	60a2                	ld	ra,8(sp)
    80000d90:	6402                	ld	s0,0(sp)
    80000d92:	0141                	addi	sp,sp,16
    80000d94:	8082                	ret

0000000080000d96 <strncmp>:

int
strncmp(const char *p, const char *q, uint n)
{
    80000d96:	1141                	addi	sp,sp,-16
    80000d98:	e422                	sd	s0,8(sp)
    80000d9a:	0800                	addi	s0,sp,16
  while(n > 0 && *p && *p == *q)
    80000d9c:	ce11                	beqz	a2,80000db8 <strncmp+0x22>
    80000d9e:	00054783          	lbu	a5,0(a0)
    80000da2:	cf89                	beqz	a5,80000dbc <strncmp+0x26>
    80000da4:	0005c703          	lbu	a4,0(a1)
    80000da8:	00f71a63          	bne	a4,a5,80000dbc <strncmp+0x26>
    n--, p++, q++;
    80000dac:	367d                	addiw	a2,a2,-1
    80000dae:	0505                	addi	a0,a0,1
    80000db0:	0585                	addi	a1,a1,1
  while(n > 0 && *p && *p == *q)
    80000db2:	f675                	bnez	a2,80000d9e <strncmp+0x8>
  if(n == 0)
    return 0;
    80000db4:	4501                	li	a0,0
    80000db6:	a809                	j	80000dc8 <strncmp+0x32>
    80000db8:	4501                	li	a0,0
    80000dba:	a039                	j	80000dc8 <strncmp+0x32>
  if(n == 0)
    80000dbc:	ca09                	beqz	a2,80000dce <strncmp+0x38>
  return (uchar)*p - (uchar)*q;
    80000dbe:	00054503          	lbu	a0,0(a0)
    80000dc2:	0005c783          	lbu	a5,0(a1)
    80000dc6:	9d1d                	subw	a0,a0,a5
}
    80000dc8:	6422                	ld	s0,8(sp)
    80000dca:	0141                	addi	sp,sp,16
    80000dcc:	8082                	ret
    return 0;
    80000dce:	4501                	li	a0,0
    80000dd0:	bfe5                	j	80000dc8 <strncmp+0x32>

0000000080000dd2 <strncpy>:

char*
strncpy(char *s, const char *t, int n)
{
    80000dd2:	1141                	addi	sp,sp,-16
    80000dd4:	e422                	sd	s0,8(sp)
    80000dd6:	0800                	addi	s0,sp,16
  char *os;

  os = s;
  while(n-- > 0 && (*s++ = *t++) != 0)
    80000dd8:	872a                	mv	a4,a0
    80000dda:	8832                	mv	a6,a2
    80000ddc:	367d                	addiw	a2,a2,-1
    80000dde:	01005963          	blez	a6,80000df0 <strncpy+0x1e>
    80000de2:	0705                	addi	a4,a4,1
    80000de4:	0005c783          	lbu	a5,0(a1)
    80000de8:	fef70fa3          	sb	a5,-1(a4)
    80000dec:	0585                	addi	a1,a1,1
    80000dee:	f7f5                	bnez	a5,80000dda <strncpy+0x8>
    ;
  while(n-- > 0)
    80000df0:	86ba                	mv	a3,a4
    80000df2:	00c05c63          	blez	a2,80000e0a <strncpy+0x38>
    *s++ = 0;
    80000df6:	0685                	addi	a3,a3,1
    80000df8:	fe068fa3          	sb	zero,-1(a3)
  while(n-- > 0)
    80000dfc:	fff6c793          	not	a5,a3
    80000e00:	9fb9                	addw	a5,a5,a4
    80000e02:	010787bb          	addw	a5,a5,a6
    80000e06:	fef048e3          	bgtz	a5,80000df6 <strncpy+0x24>
  return os;
}
    80000e0a:	6422                	ld	s0,8(sp)
    80000e0c:	0141                	addi	sp,sp,16
    80000e0e:	8082                	ret

0000000080000e10 <safestrcpy>:

// Like strncpy but guaranteed to NUL-terminate.
char*
safestrcpy(char *s, const char *t, int n)
{
    80000e10:	1141                	addi	sp,sp,-16
    80000e12:	e422                	sd	s0,8(sp)
    80000e14:	0800                	addi	s0,sp,16
  char *os;

  os = s;
  if(n <= 0)
    80000e16:	02c05363          	blez	a2,80000e3c <safestrcpy+0x2c>
    80000e1a:	fff6069b          	addiw	a3,a2,-1
    80000e1e:	1682                	slli	a3,a3,0x20
    80000e20:	9281                	srli	a3,a3,0x20
    80000e22:	96ae                	add	a3,a3,a1
    80000e24:	87aa                	mv	a5,a0
    return os;
  while(--n > 0 && (*s++ = *t++) != 0)
    80000e26:	00d58963          	beq	a1,a3,80000e38 <safestrcpy+0x28>
    80000e2a:	0585                	addi	a1,a1,1
    80000e2c:	0785                	addi	a5,a5,1
    80000e2e:	fff5c703          	lbu	a4,-1(a1)
    80000e32:	fee78fa3          	sb	a4,-1(a5)
    80000e36:	fb65                	bnez	a4,80000e26 <safestrcpy+0x16>
    ;
  *s = 0;
    80000e38:	00078023          	sb	zero,0(a5)
  return os;
}
    80000e3c:	6422                	ld	s0,8(sp)
    80000e3e:	0141                	addi	sp,sp,16
    80000e40:	8082                	ret

0000000080000e42 <strlen>:

int
strlen(const char *s)
{
    80000e42:	1141                	addi	sp,sp,-16
    80000e44:	e422                	sd	s0,8(sp)
    80000e46:	0800                	addi	s0,sp,16
  int n;

  for(n = 0; s[n]; n++)
    80000e48:	00054783          	lbu	a5,0(a0)
    80000e4c:	cf91                	beqz	a5,80000e68 <strlen+0x26>
    80000e4e:	0505                	addi	a0,a0,1
    80000e50:	87aa                	mv	a5,a0
    80000e52:	4685                	li	a3,1
    80000e54:	9e89                	subw	a3,a3,a0
    80000e56:	00f6853b          	addw	a0,a3,a5
    80000e5a:	0785                	addi	a5,a5,1
    80000e5c:	fff7c703          	lbu	a4,-1(a5)
    80000e60:	fb7d                	bnez	a4,80000e56 <strlen+0x14>
    ;
  return n;
}
    80000e62:	6422                	ld	s0,8(sp)
    80000e64:	0141                	addi	sp,sp,16
    80000e66:	8082                	ret
  for(n = 0; s[n]; n++)
    80000e68:	4501                	li	a0,0
    80000e6a:	bfe5                	j	80000e62 <strlen+0x20>

0000000080000e6c <main>:
volatile static int started = 0;

// start() jumps here in supervisor mode on all CPUs.
void
main()
{
    80000e6c:	1141                	addi	sp,sp,-16
    80000e6e:	e406                	sd	ra,8(sp)
    80000e70:	e022                	sd	s0,0(sp)
    80000e72:	0800                	addi	s0,sp,16
  if(cpuid() == 0){
    80000e74:	00001097          	auipc	ra,0x1
    80000e78:	b0a080e7          	jalr	-1270(ra) # 8000197e <cpuid>
    virtio_disk_init(); // emulated hard disk
    userinit();      // first user process
    __sync_synchronize();
    started = 1;
  } else {
    while(started == 0)
    80000e7c:	00008717          	auipc	a4,0x8
    80000e80:	19c70713          	addi	a4,a4,412 # 80009018 <started>
  if(cpuid() == 0){
    80000e84:	c139                	beqz	a0,80000eca <main+0x5e>
    while(started == 0)
    80000e86:	431c                	lw	a5,0(a4)
    80000e88:	2781                	sext.w	a5,a5
    80000e8a:	dff5                	beqz	a5,80000e86 <main+0x1a>
      ;
    __sync_synchronize();
    80000e8c:	0ff0000f          	fence
    printf("hart %d starting\n", cpuid());
    80000e90:	00001097          	auipc	ra,0x1
    80000e94:	aee080e7          	jalr	-1298(ra) # 8000197e <cpuid>
    80000e98:	85aa                	mv	a1,a0
    80000e9a:	00007517          	auipc	a0,0x7
    80000e9e:	21e50513          	addi	a0,a0,542 # 800080b8 <digits+0x78>
    80000ea2:	fffff097          	auipc	ra,0xfffff
    80000ea6:	6d2080e7          	jalr	1746(ra) # 80000574 <printf>
    kvminithart();    // turn on paging
    80000eaa:	00000097          	auipc	ra,0x0
    80000eae:	0d8080e7          	jalr	216(ra) # 80000f82 <kvminithart>
    trapinithart();   // install kernel trap vector
    80000eb2:	00001097          	auipc	ra,0x1
    80000eb6:	752080e7          	jalr	1874(ra) # 80002604 <trapinithart>
    plicinithart();   // ask PLIC for device interrupts
    80000eba:	00005097          	auipc	ra,0x5
    80000ebe:	f66080e7          	jalr	-154(ra) # 80005e20 <plicinithart>
  }

  scheduler();        
    80000ec2:	00001097          	auipc	ra,0x1
    80000ec6:	01c080e7          	jalr	28(ra) # 80001ede <scheduler>
    consoleinit();
    80000eca:	fffff097          	auipc	ra,0xfffff
    80000ece:	572080e7          	jalr	1394(ra) # 8000043c <consoleinit>
    printfinit();
    80000ed2:	00000097          	auipc	ra,0x0
    80000ed6:	882080e7          	jalr	-1918(ra) # 80000754 <printfinit>
    printf("\n");
    80000eda:	00007517          	auipc	a0,0x7
    80000ede:	1ee50513          	addi	a0,a0,494 # 800080c8 <digits+0x88>
    80000ee2:	fffff097          	auipc	ra,0xfffff
    80000ee6:	692080e7          	jalr	1682(ra) # 80000574 <printf>
    printf("xv6 kernel is booting\n");
    80000eea:	00007517          	auipc	a0,0x7
    80000eee:	1b650513          	addi	a0,a0,438 # 800080a0 <digits+0x60>
    80000ef2:	fffff097          	auipc	ra,0xfffff
    80000ef6:	682080e7          	jalr	1666(ra) # 80000574 <printf>
    printf("\n");
    80000efa:	00007517          	auipc	a0,0x7
    80000efe:	1ce50513          	addi	a0,a0,462 # 800080c8 <digits+0x88>
    80000f02:	fffff097          	auipc	ra,0xfffff
    80000f06:	672080e7          	jalr	1650(ra) # 80000574 <printf>
    kinit();         // physical page allocator
    80000f0a:	00000097          	auipc	ra,0x0
    80000f0e:	b8c080e7          	jalr	-1140(ra) # 80000a96 <kinit>
    kvminit();       // create kernel page table
    80000f12:	00000097          	auipc	ra,0x0
    80000f16:	310080e7          	jalr	784(ra) # 80001222 <kvminit>
    kvminithart();   // turn on paging
    80000f1a:	00000097          	auipc	ra,0x0
    80000f1e:	068080e7          	jalr	104(ra) # 80000f82 <kvminithart>
    procinit();      // process table
    80000f22:	00001097          	auipc	ra,0x1
    80000f26:	9c4080e7          	jalr	-1596(ra) # 800018e6 <procinit>
    trapinit();      // trap vectors
    80000f2a:	00001097          	auipc	ra,0x1
    80000f2e:	6b2080e7          	jalr	1714(ra) # 800025dc <trapinit>
    trapinithart();  // install kernel trap vector
    80000f32:	00001097          	auipc	ra,0x1
    80000f36:	6d2080e7          	jalr	1746(ra) # 80002604 <trapinithart>
    plicinit();      // set up interrupt controller
    80000f3a:	00005097          	auipc	ra,0x5
    80000f3e:	ed0080e7          	jalr	-304(ra) # 80005e0a <plicinit>
    plicinithart();  // ask PLIC for device interrupts
    80000f42:	00005097          	auipc	ra,0x5
    80000f46:	ede080e7          	jalr	-290(ra) # 80005e20 <plicinithart>
    binit();         // buffer cache
    80000f4a:	00002097          	auipc	ra,0x2
    80000f4e:	dfa080e7          	jalr	-518(ra) # 80002d44 <binit>
    iinit();         // inode cache
    80000f52:	00002097          	auipc	ra,0x2
    80000f56:	550080e7          	jalr	1360(ra) # 800034a2 <iinit>
    fileinit();      // file table
    80000f5a:	00003097          	auipc	ra,0x3
    80000f5e:	5ae080e7          	jalr	1454(ra) # 80004508 <fileinit>
    virtio_disk_init(); // emulated hard disk
    80000f62:	00005097          	auipc	ra,0x5
    80000f66:	fe0080e7          	jalr	-32(ra) # 80005f42 <virtio_disk_init>
    userinit();      // first user process
    80000f6a:	00001097          	auipc	ra,0x1
    80000f6e:	d0a080e7          	jalr	-758(ra) # 80001c74 <userinit>
    __sync_synchronize();
    80000f72:	0ff0000f          	fence
    started = 1;
    80000f76:	4785                	li	a5,1
    80000f78:	00008717          	auipc	a4,0x8
    80000f7c:	0af72023          	sw	a5,160(a4) # 80009018 <started>
    80000f80:	b789                	j	80000ec2 <main+0x56>

0000000080000f82 <kvminithart>:

// Switch h/w page table register to the kernel's page table,
// and enable paging.
void
kvminithart()
{
    80000f82:	1141                	addi	sp,sp,-16
    80000f84:	e422                	sd	s0,8(sp)
    80000f86:	0800                	addi	s0,sp,16
  w_satp(MAKE_SATP(kernel_pagetable));
    80000f88:	00008797          	auipc	a5,0x8
    80000f8c:	0987b783          	ld	a5,152(a5) # 80009020 <kernel_pagetable>
    80000f90:	83b1                	srli	a5,a5,0xc
    80000f92:	577d                	li	a4,-1
    80000f94:	177e                	slli	a4,a4,0x3f
    80000f96:	8fd9                	or	a5,a5,a4
  asm volatile("csrw satp, %0" : : "r" (x));
    80000f98:	18079073          	csrw	satp,a5
// flush the TLB.
static inline void
sfence_vma()
{
  // the zero, zero means flush all TLB entries.
  asm volatile("sfence.vma zero, zero");
    80000f9c:	12000073          	sfence.vma
  sfence_vma();
}
    80000fa0:	6422                	ld	s0,8(sp)
    80000fa2:	0141                	addi	sp,sp,16
    80000fa4:	8082                	ret

0000000080000fa6 <walk>:
//   21..29 -- 9 bits of level-1 index.
//   12..20 -- 9 bits of level-0 index.
//    0..11 -- 12 bits of byte offset within the page.
pte_t *
walk(pagetable_t pagetable, uint64 va, int alloc)
{
    80000fa6:	7139                	addi	sp,sp,-64
    80000fa8:	fc06                	sd	ra,56(sp)
    80000faa:	f822                	sd	s0,48(sp)
    80000fac:	f426                	sd	s1,40(sp)
    80000fae:	f04a                	sd	s2,32(sp)
    80000fb0:	ec4e                	sd	s3,24(sp)
    80000fb2:	e852                	sd	s4,16(sp)
    80000fb4:	e456                	sd	s5,8(sp)
    80000fb6:	e05a                	sd	s6,0(sp)
    80000fb8:	0080                	addi	s0,sp,64
    80000fba:	84aa                	mv	s1,a0
    80000fbc:	89ae                	mv	s3,a1
    80000fbe:	8ab2                	mv	s5,a2
  if(va >= MAXVA)
    80000fc0:	57fd                	li	a5,-1
    80000fc2:	83e9                	srli	a5,a5,0x1a
    80000fc4:	4a79                	li	s4,30
    panic("walk");

  for(int level = 2; level > 0; level--) {
    80000fc6:	4b31                	li	s6,12
  if(va >= MAXVA)
    80000fc8:	04b7f263          	bgeu	a5,a1,8000100c <walk+0x66>
    panic("walk");
    80000fcc:	00007517          	auipc	a0,0x7
    80000fd0:	10450513          	addi	a0,a0,260 # 800080d0 <digits+0x90>
    80000fd4:	fffff097          	auipc	ra,0xfffff
    80000fd8:	556080e7          	jalr	1366(ra) # 8000052a <panic>
    pte_t *pte = &pagetable[PX(level, va)];
    if(*pte & PTE_V) {
      pagetable = (pagetable_t)PTE2PA(*pte);
    } else {
      if(!alloc || (pagetable = (pde_t*)kalloc()) == 0)
    80000fdc:	060a8663          	beqz	s5,80001048 <walk+0xa2>
    80000fe0:	00000097          	auipc	ra,0x0
    80000fe4:	af2080e7          	jalr	-1294(ra) # 80000ad2 <kalloc>
    80000fe8:	84aa                	mv	s1,a0
    80000fea:	c529                	beqz	a0,80001034 <walk+0x8e>
        return 0;
      memset(pagetable, 0, PGSIZE);
    80000fec:	6605                	lui	a2,0x1
    80000fee:	4581                	li	a1,0
    80000ff0:	00000097          	auipc	ra,0x0
    80000ff4:	cce080e7          	jalr	-818(ra) # 80000cbe <memset>
      *pte = PA2PTE(pagetable) | PTE_V;
    80000ff8:	00c4d793          	srli	a5,s1,0xc
    80000ffc:	07aa                	slli	a5,a5,0xa
    80000ffe:	0017e793          	ori	a5,a5,1
    80001002:	00f93023          	sd	a5,0(s2)
  for(int level = 2; level > 0; level--) {
    80001006:	3a5d                	addiw	s4,s4,-9
    80001008:	036a0063          	beq	s4,s6,80001028 <walk+0x82>
    pte_t *pte = &pagetable[PX(level, va)];
    8000100c:	0149d933          	srl	s2,s3,s4
    80001010:	1ff97913          	andi	s2,s2,511
    80001014:	090e                	slli	s2,s2,0x3
    80001016:	9926                	add	s2,s2,s1
    if(*pte & PTE_V) {
    80001018:	00093483          	ld	s1,0(s2)
    8000101c:	0014f793          	andi	a5,s1,1
    80001020:	dfd5                	beqz	a5,80000fdc <walk+0x36>
      pagetable = (pagetable_t)PTE2PA(*pte);
    80001022:	80a9                	srli	s1,s1,0xa
    80001024:	04b2                	slli	s1,s1,0xc
    80001026:	b7c5                	j	80001006 <walk+0x60>
    }
  }
  return &pagetable[PX(0, va)];
    80001028:	00c9d513          	srli	a0,s3,0xc
    8000102c:	1ff57513          	andi	a0,a0,511
    80001030:	050e                	slli	a0,a0,0x3
    80001032:	9526                	add	a0,a0,s1
}
    80001034:	70e2                	ld	ra,56(sp)
    80001036:	7442                	ld	s0,48(sp)
    80001038:	74a2                	ld	s1,40(sp)
    8000103a:	7902                	ld	s2,32(sp)
    8000103c:	69e2                	ld	s3,24(sp)
    8000103e:	6a42                	ld	s4,16(sp)
    80001040:	6aa2                	ld	s5,8(sp)
    80001042:	6b02                	ld	s6,0(sp)
    80001044:	6121                	addi	sp,sp,64
    80001046:	8082                	ret
        return 0;
    80001048:	4501                	li	a0,0
    8000104a:	b7ed                	j	80001034 <walk+0x8e>

000000008000104c <walkaddr>:
walkaddr(pagetable_t pagetable, uint64 va)
{
  pte_t *pte;
  uint64 pa;

  if(va >= MAXVA)
    8000104c:	57fd                	li	a5,-1
    8000104e:	83e9                	srli	a5,a5,0x1a
    80001050:	00b7f463          	bgeu	a5,a1,80001058 <walkaddr+0xc>
    return 0;
    80001054:	4501                	li	a0,0
    return 0;
  if((*pte & PTE_U) == 0)
    return 0;
  pa = PTE2PA(*pte);
  return pa;
}
    80001056:	8082                	ret
{
    80001058:	1141                	addi	sp,sp,-16
    8000105a:	e406                	sd	ra,8(sp)
    8000105c:	e022                	sd	s0,0(sp)
    8000105e:	0800                	addi	s0,sp,16
  pte = walk(pagetable, va, 0);
    80001060:	4601                	li	a2,0
    80001062:	00000097          	auipc	ra,0x0
    80001066:	f44080e7          	jalr	-188(ra) # 80000fa6 <walk>
  if(pte == 0)
    8000106a:	c105                	beqz	a0,8000108a <walkaddr+0x3e>
  if((*pte & PTE_V) == 0)
    8000106c:	611c                	ld	a5,0(a0)
  if((*pte & PTE_U) == 0)
    8000106e:	0117f693          	andi	a3,a5,17
    80001072:	4745                	li	a4,17
    return 0;
    80001074:	4501                	li	a0,0
  if((*pte & PTE_U) == 0)
    80001076:	00e68663          	beq	a3,a4,80001082 <walkaddr+0x36>
}
    8000107a:	60a2                	ld	ra,8(sp)
    8000107c:	6402                	ld	s0,0(sp)
    8000107e:	0141                	addi	sp,sp,16
    80001080:	8082                	ret
  pa = PTE2PA(*pte);
    80001082:	00a7d513          	srli	a0,a5,0xa
    80001086:	0532                	slli	a0,a0,0xc
  return pa;
    80001088:	bfcd                	j	8000107a <walkaddr+0x2e>
    return 0;
    8000108a:	4501                	li	a0,0
    8000108c:	b7fd                	j	8000107a <walkaddr+0x2e>

000000008000108e <mappages>:
// physical addresses starting at pa. va and size might not
// be page-aligned. Returns 0 on success, -1 if walk() couldn't
// allocate a needed page-table page.
int
mappages(pagetable_t pagetable, uint64 va, uint64 size, uint64 pa, int perm)
{
    8000108e:	715d                	addi	sp,sp,-80
    80001090:	e486                	sd	ra,72(sp)
    80001092:	e0a2                	sd	s0,64(sp)
    80001094:	fc26                	sd	s1,56(sp)
    80001096:	f84a                	sd	s2,48(sp)
    80001098:	f44e                	sd	s3,40(sp)
    8000109a:	f052                	sd	s4,32(sp)
    8000109c:	ec56                	sd	s5,24(sp)
    8000109e:	e85a                	sd	s6,16(sp)
    800010a0:	e45e                	sd	s7,8(sp)
    800010a2:	0880                	addi	s0,sp,80
    800010a4:	8aaa                	mv	s5,a0
    800010a6:	8b3a                	mv	s6,a4
  uint64 a, last;
  pte_t *pte;

  a = PGROUNDDOWN(va);
    800010a8:	777d                	lui	a4,0xfffff
    800010aa:	00e5f7b3          	and	a5,a1,a4
  last = PGROUNDDOWN(va + size - 1);
    800010ae:	167d                	addi	a2,a2,-1
    800010b0:	00b609b3          	add	s3,a2,a1
    800010b4:	00e9f9b3          	and	s3,s3,a4
  a = PGROUNDDOWN(va);
    800010b8:	893e                	mv	s2,a5
    800010ba:	40f68a33          	sub	s4,a3,a5
    if(*pte & PTE_V)
      panic("remap");
    *pte = PA2PTE(pa) | perm | PTE_V;
    if(a == last)
      break;
    a += PGSIZE;
    800010be:	6b85                	lui	s7,0x1
    800010c0:	012a04b3          	add	s1,s4,s2
    if((pte = walk(pagetable, a, 1)) == 0)
    800010c4:	4605                	li	a2,1
    800010c6:	85ca                	mv	a1,s2
    800010c8:	8556                	mv	a0,s5
    800010ca:	00000097          	auipc	ra,0x0
    800010ce:	edc080e7          	jalr	-292(ra) # 80000fa6 <walk>
    800010d2:	c51d                	beqz	a0,80001100 <mappages+0x72>
    if(*pte & PTE_V)
    800010d4:	611c                	ld	a5,0(a0)
    800010d6:	8b85                	andi	a5,a5,1
    800010d8:	ef81                	bnez	a5,800010f0 <mappages+0x62>
    *pte = PA2PTE(pa) | perm | PTE_V;
    800010da:	80b1                	srli	s1,s1,0xc
    800010dc:	04aa                	slli	s1,s1,0xa
    800010de:	0164e4b3          	or	s1,s1,s6
    800010e2:	0014e493          	ori	s1,s1,1
    800010e6:	e104                	sd	s1,0(a0)
    if(a == last)
    800010e8:	03390863          	beq	s2,s3,80001118 <mappages+0x8a>
    a += PGSIZE;
    800010ec:	995e                	add	s2,s2,s7
    if((pte = walk(pagetable, a, 1)) == 0)
    800010ee:	bfc9                	j	800010c0 <mappages+0x32>
      panic("remap");
    800010f0:	00007517          	auipc	a0,0x7
    800010f4:	fe850513          	addi	a0,a0,-24 # 800080d8 <digits+0x98>
    800010f8:	fffff097          	auipc	ra,0xfffff
    800010fc:	432080e7          	jalr	1074(ra) # 8000052a <panic>
      return -1;
    80001100:	557d                	li	a0,-1
    pa += PGSIZE;
  }
  return 0;
}
    80001102:	60a6                	ld	ra,72(sp)
    80001104:	6406                	ld	s0,64(sp)
    80001106:	74e2                	ld	s1,56(sp)
    80001108:	7942                	ld	s2,48(sp)
    8000110a:	79a2                	ld	s3,40(sp)
    8000110c:	7a02                	ld	s4,32(sp)
    8000110e:	6ae2                	ld	s5,24(sp)
    80001110:	6b42                	ld	s6,16(sp)
    80001112:	6ba2                	ld	s7,8(sp)
    80001114:	6161                	addi	sp,sp,80
    80001116:	8082                	ret
  return 0;
    80001118:	4501                	li	a0,0
    8000111a:	b7e5                	j	80001102 <mappages+0x74>

000000008000111c <kvmmap>:
{
    8000111c:	1141                	addi	sp,sp,-16
    8000111e:	e406                	sd	ra,8(sp)
    80001120:	e022                	sd	s0,0(sp)
    80001122:	0800                	addi	s0,sp,16
    80001124:	87b6                	mv	a5,a3
  if(mappages(kpgtbl, va, sz, pa, perm) != 0)
    80001126:	86b2                	mv	a3,a2
    80001128:	863e                	mv	a2,a5
    8000112a:	00000097          	auipc	ra,0x0
    8000112e:	f64080e7          	jalr	-156(ra) # 8000108e <mappages>
    80001132:	e509                	bnez	a0,8000113c <kvmmap+0x20>
}
    80001134:	60a2                	ld	ra,8(sp)
    80001136:	6402                	ld	s0,0(sp)
    80001138:	0141                	addi	sp,sp,16
    8000113a:	8082                	ret
    panic("kvmmap");
    8000113c:	00007517          	auipc	a0,0x7
    80001140:	fa450513          	addi	a0,a0,-92 # 800080e0 <digits+0xa0>
    80001144:	fffff097          	auipc	ra,0xfffff
    80001148:	3e6080e7          	jalr	998(ra) # 8000052a <panic>

000000008000114c <kvmmake>:
{
    8000114c:	1101                	addi	sp,sp,-32
    8000114e:	ec06                	sd	ra,24(sp)
    80001150:	e822                	sd	s0,16(sp)
    80001152:	e426                	sd	s1,8(sp)
    80001154:	e04a                	sd	s2,0(sp)
    80001156:	1000                	addi	s0,sp,32
  kpgtbl = (pagetable_t) kalloc();
    80001158:	00000097          	auipc	ra,0x0
    8000115c:	97a080e7          	jalr	-1670(ra) # 80000ad2 <kalloc>
    80001160:	84aa                	mv	s1,a0
  memset(kpgtbl, 0, PGSIZE);
    80001162:	6605                	lui	a2,0x1
    80001164:	4581                	li	a1,0
    80001166:	00000097          	auipc	ra,0x0
    8000116a:	b58080e7          	jalr	-1192(ra) # 80000cbe <memset>
  kvmmap(kpgtbl, UART0, UART0, PGSIZE, PTE_R | PTE_W);
    8000116e:	4719                	li	a4,6
    80001170:	6685                	lui	a3,0x1
    80001172:	10000637          	lui	a2,0x10000
    80001176:	100005b7          	lui	a1,0x10000
    8000117a:	8526                	mv	a0,s1
    8000117c:	00000097          	auipc	ra,0x0
    80001180:	fa0080e7          	jalr	-96(ra) # 8000111c <kvmmap>
  kvmmap(kpgtbl, VIRTIO0, VIRTIO0, PGSIZE, PTE_R | PTE_W);
    80001184:	4719                	li	a4,6
    80001186:	6685                	lui	a3,0x1
    80001188:	10001637          	lui	a2,0x10001
    8000118c:	100015b7          	lui	a1,0x10001
    80001190:	8526                	mv	a0,s1
    80001192:	00000097          	auipc	ra,0x0
    80001196:	f8a080e7          	jalr	-118(ra) # 8000111c <kvmmap>
  kvmmap(kpgtbl, PLIC, PLIC, 0x400000, PTE_R | PTE_W);
    8000119a:	4719                	li	a4,6
    8000119c:	004006b7          	lui	a3,0x400
    800011a0:	0c000637          	lui	a2,0xc000
    800011a4:	0c0005b7          	lui	a1,0xc000
    800011a8:	8526                	mv	a0,s1
    800011aa:	00000097          	auipc	ra,0x0
    800011ae:	f72080e7          	jalr	-142(ra) # 8000111c <kvmmap>
  kvmmap(kpgtbl, KERNBASE, KERNBASE, (uint64)etext-KERNBASE, PTE_R | PTE_X);
    800011b2:	00007917          	auipc	s2,0x7
    800011b6:	e4e90913          	addi	s2,s2,-434 # 80008000 <etext>
    800011ba:	4729                	li	a4,10
    800011bc:	80007697          	auipc	a3,0x80007
    800011c0:	e4468693          	addi	a3,a3,-444 # 8000 <_entry-0x7fff8000>
    800011c4:	4605                	li	a2,1
    800011c6:	067e                	slli	a2,a2,0x1f
    800011c8:	85b2                	mv	a1,a2
    800011ca:	8526                	mv	a0,s1
    800011cc:	00000097          	auipc	ra,0x0
    800011d0:	f50080e7          	jalr	-176(ra) # 8000111c <kvmmap>
  kvmmap(kpgtbl, (uint64)etext, (uint64)etext, PHYSTOP-(uint64)etext, PTE_R | PTE_W);
    800011d4:	4719                	li	a4,6
    800011d6:	46c5                	li	a3,17
    800011d8:	06ee                	slli	a3,a3,0x1b
    800011da:	412686b3          	sub	a3,a3,s2
    800011de:	864a                	mv	a2,s2
    800011e0:	85ca                	mv	a1,s2
    800011e2:	8526                	mv	a0,s1
    800011e4:	00000097          	auipc	ra,0x0
    800011e8:	f38080e7          	jalr	-200(ra) # 8000111c <kvmmap>
  kvmmap(kpgtbl, TRAMPOLINE, (uint64)trampoline, PGSIZE, PTE_R | PTE_X);
    800011ec:	4729                	li	a4,10
    800011ee:	6685                	lui	a3,0x1
    800011f0:	00006617          	auipc	a2,0x6
    800011f4:	e1060613          	addi	a2,a2,-496 # 80007000 <_trampoline>
    800011f8:	040005b7          	lui	a1,0x4000
    800011fc:	15fd                	addi	a1,a1,-1
    800011fe:	05b2                	slli	a1,a1,0xc
    80001200:	8526                	mv	a0,s1
    80001202:	00000097          	auipc	ra,0x0
    80001206:	f1a080e7          	jalr	-230(ra) # 8000111c <kvmmap>
  proc_mapstacks(kpgtbl);
    8000120a:	8526                	mv	a0,s1
    8000120c:	00000097          	auipc	ra,0x0
    80001210:	644080e7          	jalr	1604(ra) # 80001850 <proc_mapstacks>
}
    80001214:	8526                	mv	a0,s1
    80001216:	60e2                	ld	ra,24(sp)
    80001218:	6442                	ld	s0,16(sp)
    8000121a:	64a2                	ld	s1,8(sp)
    8000121c:	6902                	ld	s2,0(sp)
    8000121e:	6105                	addi	sp,sp,32
    80001220:	8082                	ret

0000000080001222 <kvminit>:
{
    80001222:	1141                	addi	sp,sp,-16
    80001224:	e406                	sd	ra,8(sp)
    80001226:	e022                	sd	s0,0(sp)
    80001228:	0800                	addi	s0,sp,16
  kernel_pagetable = kvmmake();
    8000122a:	00000097          	auipc	ra,0x0
    8000122e:	f22080e7          	jalr	-222(ra) # 8000114c <kvmmake>
    80001232:	00008797          	auipc	a5,0x8
    80001236:	dea7b723          	sd	a0,-530(a5) # 80009020 <kernel_pagetable>
}
    8000123a:	60a2                	ld	ra,8(sp)
    8000123c:	6402                	ld	s0,0(sp)
    8000123e:	0141                	addi	sp,sp,16
    80001240:	8082                	ret

0000000080001242 <uvmunmap>:
// Remove npages of mappings starting from va. va must be
// page-aligned. The mappings must exist.
// Optionally free the physical memory.
void
uvmunmap(pagetable_t pagetable, uint64 va, uint64 npages, int do_free)
{
    80001242:	715d                	addi	sp,sp,-80
    80001244:	e486                	sd	ra,72(sp)
    80001246:	e0a2                	sd	s0,64(sp)
    80001248:	fc26                	sd	s1,56(sp)
    8000124a:	f84a                	sd	s2,48(sp)
    8000124c:	f44e                	sd	s3,40(sp)
    8000124e:	f052                	sd	s4,32(sp)
    80001250:	ec56                	sd	s5,24(sp)
    80001252:	e85a                	sd	s6,16(sp)
    80001254:	e45e                	sd	s7,8(sp)
    80001256:	0880                	addi	s0,sp,80
  uint64 a;
  pte_t *pte;

  if((va % PGSIZE) != 0)
    80001258:	03459793          	slli	a5,a1,0x34
    8000125c:	e795                	bnez	a5,80001288 <uvmunmap+0x46>
    8000125e:	8a2a                	mv	s4,a0
    80001260:	892e                	mv	s2,a1
    80001262:	8ab6                	mv	s5,a3
    panic("uvmunmap: not aligned");

  for(a = va; a < va + npages*PGSIZE; a += PGSIZE){
    80001264:	0632                	slli	a2,a2,0xc
    80001266:	00b609b3          	add	s3,a2,a1
    if((pte = walk(pagetable, a, 0)) == 0)
      panic("uvmunmap: walk");
    if((*pte & PTE_V) == 0)
      panic("uvmunmap: not mapped");
    if(PTE_FLAGS(*pte) == PTE_V)
    8000126a:	4b85                	li	s7,1
  for(a = va; a < va + npages*PGSIZE; a += PGSIZE){
    8000126c:	6b05                	lui	s6,0x1
    8000126e:	0735e263          	bltu	a1,s3,800012d2 <uvmunmap+0x90>
      uint64 pa = PTE2PA(*pte);
      kfree((void*)pa);
    }
    *pte = 0;
  }
}
    80001272:	60a6                	ld	ra,72(sp)
    80001274:	6406                	ld	s0,64(sp)
    80001276:	74e2                	ld	s1,56(sp)
    80001278:	7942                	ld	s2,48(sp)
    8000127a:	79a2                	ld	s3,40(sp)
    8000127c:	7a02                	ld	s4,32(sp)
    8000127e:	6ae2                	ld	s5,24(sp)
    80001280:	6b42                	ld	s6,16(sp)
    80001282:	6ba2                	ld	s7,8(sp)
    80001284:	6161                	addi	sp,sp,80
    80001286:	8082                	ret
    panic("uvmunmap: not aligned");
    80001288:	00007517          	auipc	a0,0x7
    8000128c:	e6050513          	addi	a0,a0,-416 # 800080e8 <digits+0xa8>
    80001290:	fffff097          	auipc	ra,0xfffff
    80001294:	29a080e7          	jalr	666(ra) # 8000052a <panic>
      panic("uvmunmap: walk");
    80001298:	00007517          	auipc	a0,0x7
    8000129c:	e6850513          	addi	a0,a0,-408 # 80008100 <digits+0xc0>
    800012a0:	fffff097          	auipc	ra,0xfffff
    800012a4:	28a080e7          	jalr	650(ra) # 8000052a <panic>
      panic("uvmunmap: not mapped");
    800012a8:	00007517          	auipc	a0,0x7
    800012ac:	e6850513          	addi	a0,a0,-408 # 80008110 <digits+0xd0>
    800012b0:	fffff097          	auipc	ra,0xfffff
    800012b4:	27a080e7          	jalr	634(ra) # 8000052a <panic>
      panic("uvmunmap: not a leaf");
    800012b8:	00007517          	auipc	a0,0x7
    800012bc:	e7050513          	addi	a0,a0,-400 # 80008128 <digits+0xe8>
    800012c0:	fffff097          	auipc	ra,0xfffff
    800012c4:	26a080e7          	jalr	618(ra) # 8000052a <panic>
    *pte = 0;
    800012c8:	0004b023          	sd	zero,0(s1)
  for(a = va; a < va + npages*PGSIZE; a += PGSIZE){
    800012cc:	995a                	add	s2,s2,s6
    800012ce:	fb3972e3          	bgeu	s2,s3,80001272 <uvmunmap+0x30>
    if((pte = walk(pagetable, a, 0)) == 0)
    800012d2:	4601                	li	a2,0
    800012d4:	85ca                	mv	a1,s2
    800012d6:	8552                	mv	a0,s4
    800012d8:	00000097          	auipc	ra,0x0
    800012dc:	cce080e7          	jalr	-818(ra) # 80000fa6 <walk>
    800012e0:	84aa                	mv	s1,a0
    800012e2:	d95d                	beqz	a0,80001298 <uvmunmap+0x56>
    if((*pte & PTE_V) == 0)
    800012e4:	6108                	ld	a0,0(a0)
    800012e6:	00157793          	andi	a5,a0,1
    800012ea:	dfdd                	beqz	a5,800012a8 <uvmunmap+0x66>
    if(PTE_FLAGS(*pte) == PTE_V)
    800012ec:	3ff57793          	andi	a5,a0,1023
    800012f0:	fd7784e3          	beq	a5,s7,800012b8 <uvmunmap+0x76>
    if(do_free){
    800012f4:	fc0a8ae3          	beqz	s5,800012c8 <uvmunmap+0x86>
      uint64 pa = PTE2PA(*pte);
    800012f8:	8129                	srli	a0,a0,0xa
      kfree((void*)pa);
    800012fa:	0532                	slli	a0,a0,0xc
    800012fc:	fffff097          	auipc	ra,0xfffff
    80001300:	6da080e7          	jalr	1754(ra) # 800009d6 <kfree>
    80001304:	b7d1                	j	800012c8 <uvmunmap+0x86>

0000000080001306 <uvmcreate>:

// create an empty user page table.
// returns 0 if out of memory.
pagetable_t
uvmcreate()
{
    80001306:	1101                	addi	sp,sp,-32
    80001308:	ec06                	sd	ra,24(sp)
    8000130a:	e822                	sd	s0,16(sp)
    8000130c:	e426                	sd	s1,8(sp)
    8000130e:	1000                	addi	s0,sp,32
  pagetable_t pagetable;
  pagetable = (pagetable_t) kalloc();
    80001310:	fffff097          	auipc	ra,0xfffff
    80001314:	7c2080e7          	jalr	1986(ra) # 80000ad2 <kalloc>
    80001318:	84aa                	mv	s1,a0
  if(pagetable == 0)
    8000131a:	c519                	beqz	a0,80001328 <uvmcreate+0x22>
    return 0;
  memset(pagetable, 0, PGSIZE);
    8000131c:	6605                	lui	a2,0x1
    8000131e:	4581                	li	a1,0
    80001320:	00000097          	auipc	ra,0x0
    80001324:	99e080e7          	jalr	-1634(ra) # 80000cbe <memset>
  return pagetable;
}
    80001328:	8526                	mv	a0,s1
    8000132a:	60e2                	ld	ra,24(sp)
    8000132c:	6442                	ld	s0,16(sp)
    8000132e:	64a2                	ld	s1,8(sp)
    80001330:	6105                	addi	sp,sp,32
    80001332:	8082                	ret

0000000080001334 <uvminit>:
// Load the user initcode into address 0 of pagetable,
// for the very first process.
// sz must be less than a page.
void
uvminit(pagetable_t pagetable, uchar *src, uint sz)
{
    80001334:	7179                	addi	sp,sp,-48
    80001336:	f406                	sd	ra,40(sp)
    80001338:	f022                	sd	s0,32(sp)
    8000133a:	ec26                	sd	s1,24(sp)
    8000133c:	e84a                	sd	s2,16(sp)
    8000133e:	e44e                	sd	s3,8(sp)
    80001340:	e052                	sd	s4,0(sp)
    80001342:	1800                	addi	s0,sp,48
  char *mem;

  if(sz >= PGSIZE)
    80001344:	6785                	lui	a5,0x1
    80001346:	04f67863          	bgeu	a2,a5,80001396 <uvminit+0x62>
    8000134a:	8a2a                	mv	s4,a0
    8000134c:	89ae                	mv	s3,a1
    8000134e:	84b2                	mv	s1,a2
    panic("inituvm: more than a page");
  mem = kalloc();
    80001350:	fffff097          	auipc	ra,0xfffff
    80001354:	782080e7          	jalr	1922(ra) # 80000ad2 <kalloc>
    80001358:	892a                	mv	s2,a0
  memset(mem, 0, PGSIZE);
    8000135a:	6605                	lui	a2,0x1
    8000135c:	4581                	li	a1,0
    8000135e:	00000097          	auipc	ra,0x0
    80001362:	960080e7          	jalr	-1696(ra) # 80000cbe <memset>
  mappages(pagetable, 0, PGSIZE, (uint64)mem, PTE_W|PTE_R|PTE_X|PTE_U);
    80001366:	4779                	li	a4,30
    80001368:	86ca                	mv	a3,s2
    8000136a:	6605                	lui	a2,0x1
    8000136c:	4581                	li	a1,0
    8000136e:	8552                	mv	a0,s4
    80001370:	00000097          	auipc	ra,0x0
    80001374:	d1e080e7          	jalr	-738(ra) # 8000108e <mappages>
  memmove(mem, src, sz);
    80001378:	8626                	mv	a2,s1
    8000137a:	85ce                	mv	a1,s3
    8000137c:	854a                	mv	a0,s2
    8000137e:	00000097          	auipc	ra,0x0
    80001382:	99c080e7          	jalr	-1636(ra) # 80000d1a <memmove>
}
    80001386:	70a2                	ld	ra,40(sp)
    80001388:	7402                	ld	s0,32(sp)
    8000138a:	64e2                	ld	s1,24(sp)
    8000138c:	6942                	ld	s2,16(sp)
    8000138e:	69a2                	ld	s3,8(sp)
    80001390:	6a02                	ld	s4,0(sp)
    80001392:	6145                	addi	sp,sp,48
    80001394:	8082                	ret
    panic("inituvm: more than a page");
    80001396:	00007517          	auipc	a0,0x7
    8000139a:	daa50513          	addi	a0,a0,-598 # 80008140 <digits+0x100>
    8000139e:	fffff097          	auipc	ra,0xfffff
    800013a2:	18c080e7          	jalr	396(ra) # 8000052a <panic>

00000000800013a6 <uvmdealloc>:
// newsz.  oldsz and newsz need not be page-aligned, nor does newsz
// need to be less than oldsz.  oldsz can be larger than the actual
// process size.  Returns the new process size.
uint64
uvmdealloc(pagetable_t pagetable, uint64 oldsz, uint64 newsz)
{
    800013a6:	1101                	addi	sp,sp,-32
    800013a8:	ec06                	sd	ra,24(sp)
    800013aa:	e822                	sd	s0,16(sp)
    800013ac:	e426                	sd	s1,8(sp)
    800013ae:	1000                	addi	s0,sp,32
  if(newsz >= oldsz)
    return oldsz;
    800013b0:	84ae                	mv	s1,a1
  if(newsz >= oldsz)
    800013b2:	00b67d63          	bgeu	a2,a1,800013cc <uvmdealloc+0x26>
    800013b6:	84b2                	mv	s1,a2

  if(PGROUNDUP(newsz) < PGROUNDUP(oldsz)){
    800013b8:	6785                	lui	a5,0x1
    800013ba:	17fd                	addi	a5,a5,-1
    800013bc:	00f60733          	add	a4,a2,a5
    800013c0:	767d                	lui	a2,0xfffff
    800013c2:	8f71                	and	a4,a4,a2
    800013c4:	97ae                	add	a5,a5,a1
    800013c6:	8ff1                	and	a5,a5,a2
    800013c8:	00f76863          	bltu	a4,a5,800013d8 <uvmdealloc+0x32>
    int npages = (PGROUNDUP(oldsz) - PGROUNDUP(newsz)) / PGSIZE;
    uvmunmap(pagetable, PGROUNDUP(newsz), npages, 1);
  }

  return newsz;
}
    800013cc:	8526                	mv	a0,s1
    800013ce:	60e2                	ld	ra,24(sp)
    800013d0:	6442                	ld	s0,16(sp)
    800013d2:	64a2                	ld	s1,8(sp)
    800013d4:	6105                	addi	sp,sp,32
    800013d6:	8082                	ret
    int npages = (PGROUNDUP(oldsz) - PGROUNDUP(newsz)) / PGSIZE;
    800013d8:	8f99                	sub	a5,a5,a4
    800013da:	83b1                	srli	a5,a5,0xc
    uvmunmap(pagetable, PGROUNDUP(newsz), npages, 1);
    800013dc:	4685                	li	a3,1
    800013de:	0007861b          	sext.w	a2,a5
    800013e2:	85ba                	mv	a1,a4
    800013e4:	00000097          	auipc	ra,0x0
    800013e8:	e5e080e7          	jalr	-418(ra) # 80001242 <uvmunmap>
    800013ec:	b7c5                	j	800013cc <uvmdealloc+0x26>

00000000800013ee <uvmalloc>:
  if(newsz < oldsz)
    800013ee:	0ab66163          	bltu	a2,a1,80001490 <uvmalloc+0xa2>
{
    800013f2:	7139                	addi	sp,sp,-64
    800013f4:	fc06                	sd	ra,56(sp)
    800013f6:	f822                	sd	s0,48(sp)
    800013f8:	f426                	sd	s1,40(sp)
    800013fa:	f04a                	sd	s2,32(sp)
    800013fc:	ec4e                	sd	s3,24(sp)
    800013fe:	e852                	sd	s4,16(sp)
    80001400:	e456                	sd	s5,8(sp)
    80001402:	0080                	addi	s0,sp,64
    80001404:	8aaa                	mv	s5,a0
    80001406:	8a32                	mv	s4,a2
  oldsz = PGROUNDUP(oldsz);
    80001408:	6985                	lui	s3,0x1
    8000140a:	19fd                	addi	s3,s3,-1
    8000140c:	95ce                	add	a1,a1,s3
    8000140e:	79fd                	lui	s3,0xfffff
    80001410:	0135f9b3          	and	s3,a1,s3
  for(a = oldsz; a < newsz; a += PGSIZE){
    80001414:	08c9f063          	bgeu	s3,a2,80001494 <uvmalloc+0xa6>
    80001418:	894e                	mv	s2,s3
    mem = kalloc();
    8000141a:	fffff097          	auipc	ra,0xfffff
    8000141e:	6b8080e7          	jalr	1720(ra) # 80000ad2 <kalloc>
    80001422:	84aa                	mv	s1,a0
    if(mem == 0){
    80001424:	c51d                	beqz	a0,80001452 <uvmalloc+0x64>
    memset(mem, 0, PGSIZE);
    80001426:	6605                	lui	a2,0x1
    80001428:	4581                	li	a1,0
    8000142a:	00000097          	auipc	ra,0x0
    8000142e:	894080e7          	jalr	-1900(ra) # 80000cbe <memset>
    if(mappages(pagetable, a, PGSIZE, (uint64)mem, PTE_W|PTE_X|PTE_R|PTE_U) != 0){
    80001432:	4779                	li	a4,30
    80001434:	86a6                	mv	a3,s1
    80001436:	6605                	lui	a2,0x1
    80001438:	85ca                	mv	a1,s2
    8000143a:	8556                	mv	a0,s5
    8000143c:	00000097          	auipc	ra,0x0
    80001440:	c52080e7          	jalr	-942(ra) # 8000108e <mappages>
    80001444:	e905                	bnez	a0,80001474 <uvmalloc+0x86>
  for(a = oldsz; a < newsz; a += PGSIZE){
    80001446:	6785                	lui	a5,0x1
    80001448:	993e                	add	s2,s2,a5
    8000144a:	fd4968e3          	bltu	s2,s4,8000141a <uvmalloc+0x2c>
  return newsz;
    8000144e:	8552                	mv	a0,s4
    80001450:	a809                	j	80001462 <uvmalloc+0x74>
      uvmdealloc(pagetable, a, oldsz);
    80001452:	864e                	mv	a2,s3
    80001454:	85ca                	mv	a1,s2
    80001456:	8556                	mv	a0,s5
    80001458:	00000097          	auipc	ra,0x0
    8000145c:	f4e080e7          	jalr	-178(ra) # 800013a6 <uvmdealloc>
      return 0;
    80001460:	4501                	li	a0,0
}
    80001462:	70e2                	ld	ra,56(sp)
    80001464:	7442                	ld	s0,48(sp)
    80001466:	74a2                	ld	s1,40(sp)
    80001468:	7902                	ld	s2,32(sp)
    8000146a:	69e2                	ld	s3,24(sp)
    8000146c:	6a42                	ld	s4,16(sp)
    8000146e:	6aa2                	ld	s5,8(sp)
    80001470:	6121                	addi	sp,sp,64
    80001472:	8082                	ret
      kfree(mem);
    80001474:	8526                	mv	a0,s1
    80001476:	fffff097          	auipc	ra,0xfffff
    8000147a:	560080e7          	jalr	1376(ra) # 800009d6 <kfree>
      uvmdealloc(pagetable, a, oldsz);
    8000147e:	864e                	mv	a2,s3
    80001480:	85ca                	mv	a1,s2
    80001482:	8556                	mv	a0,s5
    80001484:	00000097          	auipc	ra,0x0
    80001488:	f22080e7          	jalr	-222(ra) # 800013a6 <uvmdealloc>
      return 0;
    8000148c:	4501                	li	a0,0
    8000148e:	bfd1                	j	80001462 <uvmalloc+0x74>
    return oldsz;
    80001490:	852e                	mv	a0,a1
}
    80001492:	8082                	ret
  return newsz;
    80001494:	8532                	mv	a0,a2
    80001496:	b7f1                	j	80001462 <uvmalloc+0x74>

0000000080001498 <freewalk>:

// Recursively free page-table pages.
// All leaf mappings must already have been removed.
void
freewalk(pagetable_t pagetable)
{
    80001498:	7179                	addi	sp,sp,-48
    8000149a:	f406                	sd	ra,40(sp)
    8000149c:	f022                	sd	s0,32(sp)
    8000149e:	ec26                	sd	s1,24(sp)
    800014a0:	e84a                	sd	s2,16(sp)
    800014a2:	e44e                	sd	s3,8(sp)
    800014a4:	e052                	sd	s4,0(sp)
    800014a6:	1800                	addi	s0,sp,48
    800014a8:	8a2a                	mv	s4,a0
  // there are 2^9 = 512 PTEs in a page table.
  for(int i = 0; i < 512; i++){
    800014aa:	84aa                	mv	s1,a0
    800014ac:	6905                	lui	s2,0x1
    800014ae:	992a                	add	s2,s2,a0
    pte_t pte = pagetable[i];
    if((pte & PTE_V) && (pte & (PTE_R|PTE_W|PTE_X)) == 0){
    800014b0:	4985                	li	s3,1
    800014b2:	a821                	j	800014ca <freewalk+0x32>
      // this PTE points to a lower-level page table.
      uint64 child = PTE2PA(pte);
    800014b4:	8129                	srli	a0,a0,0xa
      freewalk((pagetable_t)child);
    800014b6:	0532                	slli	a0,a0,0xc
    800014b8:	00000097          	auipc	ra,0x0
    800014bc:	fe0080e7          	jalr	-32(ra) # 80001498 <freewalk>
      pagetable[i] = 0;
    800014c0:	0004b023          	sd	zero,0(s1)
  for(int i = 0; i < 512; i++){
    800014c4:	04a1                	addi	s1,s1,8
    800014c6:	03248163          	beq	s1,s2,800014e8 <freewalk+0x50>
    pte_t pte = pagetable[i];
    800014ca:	6088                	ld	a0,0(s1)
    if((pte & PTE_V) && (pte & (PTE_R|PTE_W|PTE_X)) == 0){
    800014cc:	00f57793          	andi	a5,a0,15
    800014d0:	ff3782e3          	beq	a5,s3,800014b4 <freewalk+0x1c>
    } else if(pte & PTE_V){
    800014d4:	8905                	andi	a0,a0,1
    800014d6:	d57d                	beqz	a0,800014c4 <freewalk+0x2c>
      panic("freewalk: leaf");
    800014d8:	00007517          	auipc	a0,0x7
    800014dc:	c8850513          	addi	a0,a0,-888 # 80008160 <digits+0x120>
    800014e0:	fffff097          	auipc	ra,0xfffff
    800014e4:	04a080e7          	jalr	74(ra) # 8000052a <panic>
    }
  }
  kfree((void*)pagetable);
    800014e8:	8552                	mv	a0,s4
    800014ea:	fffff097          	auipc	ra,0xfffff
    800014ee:	4ec080e7          	jalr	1260(ra) # 800009d6 <kfree>
}
    800014f2:	70a2                	ld	ra,40(sp)
    800014f4:	7402                	ld	s0,32(sp)
    800014f6:	64e2                	ld	s1,24(sp)
    800014f8:	6942                	ld	s2,16(sp)
    800014fa:	69a2                	ld	s3,8(sp)
    800014fc:	6a02                	ld	s4,0(sp)
    800014fe:	6145                	addi	sp,sp,48
    80001500:	8082                	ret

0000000080001502 <uvmfree>:

// Free user memory pages,
// then free page-table pages.
void
uvmfree(pagetable_t pagetable, uint64 sz)
{
    80001502:	1101                	addi	sp,sp,-32
    80001504:	ec06                	sd	ra,24(sp)
    80001506:	e822                	sd	s0,16(sp)
    80001508:	e426                	sd	s1,8(sp)
    8000150a:	1000                	addi	s0,sp,32
    8000150c:	84aa                	mv	s1,a0
  if(sz > 0)
    8000150e:	e999                	bnez	a1,80001524 <uvmfree+0x22>
    uvmunmap(pagetable, 0, PGROUNDUP(sz)/PGSIZE, 1);
  freewalk(pagetable);
    80001510:	8526                	mv	a0,s1
    80001512:	00000097          	auipc	ra,0x0
    80001516:	f86080e7          	jalr	-122(ra) # 80001498 <freewalk>
}
    8000151a:	60e2                	ld	ra,24(sp)
    8000151c:	6442                	ld	s0,16(sp)
    8000151e:	64a2                	ld	s1,8(sp)
    80001520:	6105                	addi	sp,sp,32
    80001522:	8082                	ret
    uvmunmap(pagetable, 0, PGROUNDUP(sz)/PGSIZE, 1);
    80001524:	6605                	lui	a2,0x1
    80001526:	167d                	addi	a2,a2,-1
    80001528:	962e                	add	a2,a2,a1
    8000152a:	4685                	li	a3,1
    8000152c:	8231                	srli	a2,a2,0xc
    8000152e:	4581                	li	a1,0
    80001530:	00000097          	auipc	ra,0x0
    80001534:	d12080e7          	jalr	-750(ra) # 80001242 <uvmunmap>
    80001538:	bfe1                	j	80001510 <uvmfree+0xe>

000000008000153a <uvmcopy>:
  pte_t *pte;
  uint64 pa, i;
  uint flags;
  char *mem;

  for(i = 0; i < sz; i += PGSIZE){
    8000153a:	c679                	beqz	a2,80001608 <uvmcopy+0xce>
{
    8000153c:	715d                	addi	sp,sp,-80
    8000153e:	e486                	sd	ra,72(sp)
    80001540:	e0a2                	sd	s0,64(sp)
    80001542:	fc26                	sd	s1,56(sp)
    80001544:	f84a                	sd	s2,48(sp)
    80001546:	f44e                	sd	s3,40(sp)
    80001548:	f052                	sd	s4,32(sp)
    8000154a:	ec56                	sd	s5,24(sp)
    8000154c:	e85a                	sd	s6,16(sp)
    8000154e:	e45e                	sd	s7,8(sp)
    80001550:	0880                	addi	s0,sp,80
    80001552:	8b2a                	mv	s6,a0
    80001554:	8aae                	mv	s5,a1
    80001556:	8a32                	mv	s4,a2
  for(i = 0; i < sz; i += PGSIZE){
    80001558:	4981                	li	s3,0
    if((pte = walk(old, i, 0)) == 0)
    8000155a:	4601                	li	a2,0
    8000155c:	85ce                	mv	a1,s3
    8000155e:	855a                	mv	a0,s6
    80001560:	00000097          	auipc	ra,0x0
    80001564:	a46080e7          	jalr	-1466(ra) # 80000fa6 <walk>
    80001568:	c531                	beqz	a0,800015b4 <uvmcopy+0x7a>
      panic("uvmcopy: pte should exist");
    if((*pte & PTE_V) == 0)
    8000156a:	6118                	ld	a4,0(a0)
    8000156c:	00177793          	andi	a5,a4,1
    80001570:	cbb1                	beqz	a5,800015c4 <uvmcopy+0x8a>
      panic("uvmcopy: page not present");
    pa = PTE2PA(*pte);
    80001572:	00a75593          	srli	a1,a4,0xa
    80001576:	00c59b93          	slli	s7,a1,0xc
    flags = PTE_FLAGS(*pte);
    8000157a:	3ff77493          	andi	s1,a4,1023
    if((mem = kalloc()) == 0)
    8000157e:	fffff097          	auipc	ra,0xfffff
    80001582:	554080e7          	jalr	1364(ra) # 80000ad2 <kalloc>
    80001586:	892a                	mv	s2,a0
    80001588:	c939                	beqz	a0,800015de <uvmcopy+0xa4>
      goto err;
    memmove(mem, (char*)pa, PGSIZE);
    8000158a:	6605                	lui	a2,0x1
    8000158c:	85de                	mv	a1,s7
    8000158e:	fffff097          	auipc	ra,0xfffff
    80001592:	78c080e7          	jalr	1932(ra) # 80000d1a <memmove>
    if(mappages(new, i, PGSIZE, (uint64)mem, flags) != 0){
    80001596:	8726                	mv	a4,s1
    80001598:	86ca                	mv	a3,s2
    8000159a:	6605                	lui	a2,0x1
    8000159c:	85ce                	mv	a1,s3
    8000159e:	8556                	mv	a0,s5
    800015a0:	00000097          	auipc	ra,0x0
    800015a4:	aee080e7          	jalr	-1298(ra) # 8000108e <mappages>
    800015a8:	e515                	bnez	a0,800015d4 <uvmcopy+0x9a>
  for(i = 0; i < sz; i += PGSIZE){
    800015aa:	6785                	lui	a5,0x1
    800015ac:	99be                	add	s3,s3,a5
    800015ae:	fb49e6e3          	bltu	s3,s4,8000155a <uvmcopy+0x20>
    800015b2:	a081                	j	800015f2 <uvmcopy+0xb8>
      panic("uvmcopy: pte should exist");
    800015b4:	00007517          	auipc	a0,0x7
    800015b8:	bbc50513          	addi	a0,a0,-1092 # 80008170 <digits+0x130>
    800015bc:	fffff097          	auipc	ra,0xfffff
    800015c0:	f6e080e7          	jalr	-146(ra) # 8000052a <panic>
      panic("uvmcopy: page not present");
    800015c4:	00007517          	auipc	a0,0x7
    800015c8:	bcc50513          	addi	a0,a0,-1076 # 80008190 <digits+0x150>
    800015cc:	fffff097          	auipc	ra,0xfffff
    800015d0:	f5e080e7          	jalr	-162(ra) # 8000052a <panic>
      kfree(mem);
    800015d4:	854a                	mv	a0,s2
    800015d6:	fffff097          	auipc	ra,0xfffff
    800015da:	400080e7          	jalr	1024(ra) # 800009d6 <kfree>
    }
  }
  return 0;

 err:
  uvmunmap(new, 0, i / PGSIZE, 1);
    800015de:	4685                	li	a3,1
    800015e0:	00c9d613          	srli	a2,s3,0xc
    800015e4:	4581                	li	a1,0
    800015e6:	8556                	mv	a0,s5
    800015e8:	00000097          	auipc	ra,0x0
    800015ec:	c5a080e7          	jalr	-934(ra) # 80001242 <uvmunmap>
  return -1;
    800015f0:	557d                	li	a0,-1
}
    800015f2:	60a6                	ld	ra,72(sp)
    800015f4:	6406                	ld	s0,64(sp)
    800015f6:	74e2                	ld	s1,56(sp)
    800015f8:	7942                	ld	s2,48(sp)
    800015fa:	79a2                	ld	s3,40(sp)
    800015fc:	7a02                	ld	s4,32(sp)
    800015fe:	6ae2                	ld	s5,24(sp)
    80001600:	6b42                	ld	s6,16(sp)
    80001602:	6ba2                	ld	s7,8(sp)
    80001604:	6161                	addi	sp,sp,80
    80001606:	8082                	ret
  return 0;
    80001608:	4501                	li	a0,0
}
    8000160a:	8082                	ret

000000008000160c <uvmclear>:

// mark a PTE invalid for user access.
// used by exec for the user stack guard page.
void
uvmclear(pagetable_t pagetable, uint64 va)
{
    8000160c:	1141                	addi	sp,sp,-16
    8000160e:	e406                	sd	ra,8(sp)
    80001610:	e022                	sd	s0,0(sp)
    80001612:	0800                	addi	s0,sp,16
  pte_t *pte;
  
  pte = walk(pagetable, va, 0);
    80001614:	4601                	li	a2,0
    80001616:	00000097          	auipc	ra,0x0
    8000161a:	990080e7          	jalr	-1648(ra) # 80000fa6 <walk>
  if(pte == 0)
    8000161e:	c901                	beqz	a0,8000162e <uvmclear+0x22>
    panic("uvmclear");
  *pte &= ~PTE_U;
    80001620:	611c                	ld	a5,0(a0)
    80001622:	9bbd                	andi	a5,a5,-17
    80001624:	e11c                	sd	a5,0(a0)
}
    80001626:	60a2                	ld	ra,8(sp)
    80001628:	6402                	ld	s0,0(sp)
    8000162a:	0141                	addi	sp,sp,16
    8000162c:	8082                	ret
    panic("uvmclear");
    8000162e:	00007517          	auipc	a0,0x7
    80001632:	b8250513          	addi	a0,a0,-1150 # 800081b0 <digits+0x170>
    80001636:	fffff097          	auipc	ra,0xfffff
    8000163a:	ef4080e7          	jalr	-268(ra) # 8000052a <panic>

000000008000163e <copyout>:
int
copyout(pagetable_t pagetable, uint64 dstva, char *src, uint64 len)
{
  uint64 n, va0, pa0;

  while(len > 0){
    8000163e:	c6bd                	beqz	a3,800016ac <copyout+0x6e>
{
    80001640:	715d                	addi	sp,sp,-80
    80001642:	e486                	sd	ra,72(sp)
    80001644:	e0a2                	sd	s0,64(sp)
    80001646:	fc26                	sd	s1,56(sp)
    80001648:	f84a                	sd	s2,48(sp)
    8000164a:	f44e                	sd	s3,40(sp)
    8000164c:	f052                	sd	s4,32(sp)
    8000164e:	ec56                	sd	s5,24(sp)
    80001650:	e85a                	sd	s6,16(sp)
    80001652:	e45e                	sd	s7,8(sp)
    80001654:	e062                	sd	s8,0(sp)
    80001656:	0880                	addi	s0,sp,80
    80001658:	8b2a                	mv	s6,a0
    8000165a:	8c2e                	mv	s8,a1
    8000165c:	8a32                	mv	s4,a2
    8000165e:	89b6                	mv	s3,a3
    va0 = PGROUNDDOWN(dstva);
    80001660:	7bfd                	lui	s7,0xfffff
    pa0 = walkaddr(pagetable, va0);
    if(pa0 == 0)
      return -1;
    n = PGSIZE - (dstva - va0);
    80001662:	6a85                	lui	s5,0x1
    80001664:	a015                	j	80001688 <copyout+0x4a>
    if(n > len)
      n = len;
    memmove((void *)(pa0 + (dstva - va0)), src, n);
    80001666:	9562                	add	a0,a0,s8
    80001668:	0004861b          	sext.w	a2,s1
    8000166c:	85d2                	mv	a1,s4
    8000166e:	41250533          	sub	a0,a0,s2
    80001672:	fffff097          	auipc	ra,0xfffff
    80001676:	6a8080e7          	jalr	1704(ra) # 80000d1a <memmove>

    len -= n;
    8000167a:	409989b3          	sub	s3,s3,s1
    src += n;
    8000167e:	9a26                	add	s4,s4,s1
    dstva = va0 + PGSIZE;
    80001680:	01590c33          	add	s8,s2,s5
  while(len > 0){
    80001684:	02098263          	beqz	s3,800016a8 <copyout+0x6a>
    va0 = PGROUNDDOWN(dstva);
    80001688:	017c7933          	and	s2,s8,s7
    pa0 = walkaddr(pagetable, va0);
    8000168c:	85ca                	mv	a1,s2
    8000168e:	855a                	mv	a0,s6
    80001690:	00000097          	auipc	ra,0x0
    80001694:	9bc080e7          	jalr	-1604(ra) # 8000104c <walkaddr>
    if(pa0 == 0)
    80001698:	cd01                	beqz	a0,800016b0 <copyout+0x72>
    n = PGSIZE - (dstva - va0);
    8000169a:	418904b3          	sub	s1,s2,s8
    8000169e:	94d6                	add	s1,s1,s5
    if(n > len)
    800016a0:	fc99f3e3          	bgeu	s3,s1,80001666 <copyout+0x28>
    800016a4:	84ce                	mv	s1,s3
    800016a6:	b7c1                	j	80001666 <copyout+0x28>
  }
  return 0;
    800016a8:	4501                	li	a0,0
    800016aa:	a021                	j	800016b2 <copyout+0x74>
    800016ac:	4501                	li	a0,0
}
    800016ae:	8082                	ret
      return -1;
    800016b0:	557d                	li	a0,-1
}
    800016b2:	60a6                	ld	ra,72(sp)
    800016b4:	6406                	ld	s0,64(sp)
    800016b6:	74e2                	ld	s1,56(sp)
    800016b8:	7942                	ld	s2,48(sp)
    800016ba:	79a2                	ld	s3,40(sp)
    800016bc:	7a02                	ld	s4,32(sp)
    800016be:	6ae2                	ld	s5,24(sp)
    800016c0:	6b42                	ld	s6,16(sp)
    800016c2:	6ba2                	ld	s7,8(sp)
    800016c4:	6c02                	ld	s8,0(sp)
    800016c6:	6161                	addi	sp,sp,80
    800016c8:	8082                	ret

00000000800016ca <copyin>:
int
copyin(pagetable_t pagetable, char *dst, uint64 srcva, uint64 len)
{
  uint64 n, va0, pa0;

  while(len > 0){
    800016ca:	caa5                	beqz	a3,8000173a <copyin+0x70>
{
    800016cc:	715d                	addi	sp,sp,-80
    800016ce:	e486                	sd	ra,72(sp)
    800016d0:	e0a2                	sd	s0,64(sp)
    800016d2:	fc26                	sd	s1,56(sp)
    800016d4:	f84a                	sd	s2,48(sp)
    800016d6:	f44e                	sd	s3,40(sp)
    800016d8:	f052                	sd	s4,32(sp)
    800016da:	ec56                	sd	s5,24(sp)
    800016dc:	e85a                	sd	s6,16(sp)
    800016de:	e45e                	sd	s7,8(sp)
    800016e0:	e062                	sd	s8,0(sp)
    800016e2:	0880                	addi	s0,sp,80
    800016e4:	8b2a                	mv	s6,a0
    800016e6:	8a2e                	mv	s4,a1
    800016e8:	8c32                	mv	s8,a2
    800016ea:	89b6                	mv	s3,a3
    va0 = PGROUNDDOWN(srcva);
    800016ec:	7bfd                	lui	s7,0xfffff
    pa0 = walkaddr(pagetable, va0);
    if(pa0 == 0)
      return -1;
    n = PGSIZE - (srcva - va0);
    800016ee:	6a85                	lui	s5,0x1
    800016f0:	a01d                	j	80001716 <copyin+0x4c>
    if(n > len)
      n = len;
    memmove(dst, (void *)(pa0 + (srcva - va0)), n);
    800016f2:	018505b3          	add	a1,a0,s8
    800016f6:	0004861b          	sext.w	a2,s1
    800016fa:	412585b3          	sub	a1,a1,s2
    800016fe:	8552                	mv	a0,s4
    80001700:	fffff097          	auipc	ra,0xfffff
    80001704:	61a080e7          	jalr	1562(ra) # 80000d1a <memmove>

    len -= n;
    80001708:	409989b3          	sub	s3,s3,s1
    dst += n;
    8000170c:	9a26                	add	s4,s4,s1
    srcva = va0 + PGSIZE;
    8000170e:	01590c33          	add	s8,s2,s5
  while(len > 0){
    80001712:	02098263          	beqz	s3,80001736 <copyin+0x6c>
    va0 = PGROUNDDOWN(srcva);
    80001716:	017c7933          	and	s2,s8,s7
    pa0 = walkaddr(pagetable, va0);
    8000171a:	85ca                	mv	a1,s2
    8000171c:	855a                	mv	a0,s6
    8000171e:	00000097          	auipc	ra,0x0
    80001722:	92e080e7          	jalr	-1746(ra) # 8000104c <walkaddr>
    if(pa0 == 0)
    80001726:	cd01                	beqz	a0,8000173e <copyin+0x74>
    n = PGSIZE - (srcva - va0);
    80001728:	418904b3          	sub	s1,s2,s8
    8000172c:	94d6                	add	s1,s1,s5
    if(n > len)
    8000172e:	fc99f2e3          	bgeu	s3,s1,800016f2 <copyin+0x28>
    80001732:	84ce                	mv	s1,s3
    80001734:	bf7d                	j	800016f2 <copyin+0x28>
  }
  return 0;
    80001736:	4501                	li	a0,0
    80001738:	a021                	j	80001740 <copyin+0x76>
    8000173a:	4501                	li	a0,0
}
    8000173c:	8082                	ret
      return -1;
    8000173e:	557d                	li	a0,-1
}
    80001740:	60a6                	ld	ra,72(sp)
    80001742:	6406                	ld	s0,64(sp)
    80001744:	74e2                	ld	s1,56(sp)
    80001746:	7942                	ld	s2,48(sp)
    80001748:	79a2                	ld	s3,40(sp)
    8000174a:	7a02                	ld	s4,32(sp)
    8000174c:	6ae2                	ld	s5,24(sp)
    8000174e:	6b42                	ld	s6,16(sp)
    80001750:	6ba2                	ld	s7,8(sp)
    80001752:	6c02                	ld	s8,0(sp)
    80001754:	6161                	addi	sp,sp,80
    80001756:	8082                	ret

0000000080001758 <copyinstr>:
copyinstr(pagetable_t pagetable, char *dst, uint64 srcva, uint64 max)
{
  uint64 n, va0, pa0;
  int got_null = 0;

  while(got_null == 0 && max > 0){
    80001758:	c6c5                	beqz	a3,80001800 <copyinstr+0xa8>
{
    8000175a:	715d                	addi	sp,sp,-80
    8000175c:	e486                	sd	ra,72(sp)
    8000175e:	e0a2                	sd	s0,64(sp)
    80001760:	fc26                	sd	s1,56(sp)
    80001762:	f84a                	sd	s2,48(sp)
    80001764:	f44e                	sd	s3,40(sp)
    80001766:	f052                	sd	s4,32(sp)
    80001768:	ec56                	sd	s5,24(sp)
    8000176a:	e85a                	sd	s6,16(sp)
    8000176c:	e45e                	sd	s7,8(sp)
    8000176e:	0880                	addi	s0,sp,80
    80001770:	8a2a                	mv	s4,a0
    80001772:	8b2e                	mv	s6,a1
    80001774:	8bb2                	mv	s7,a2
    80001776:	84b6                	mv	s1,a3
    va0 = PGROUNDDOWN(srcva);
    80001778:	7afd                	lui	s5,0xfffff
    pa0 = walkaddr(pagetable, va0);
    if(pa0 == 0)
      return -1;
    n = PGSIZE - (srcva - va0);
    8000177a:	6985                	lui	s3,0x1
    8000177c:	a035                	j	800017a8 <copyinstr+0x50>
      n = max;

    char *p = (char *) (pa0 + (srcva - va0));
    while(n > 0){
      if(*p == '\0'){
        *dst = '\0';
    8000177e:	00078023          	sb	zero,0(a5) # 1000 <_entry-0x7ffff000>
    80001782:	4785                	li	a5,1
      dst++;
    }

    srcva = va0 + PGSIZE;
  }
  if(got_null){
    80001784:	0017b793          	seqz	a5,a5
    80001788:	40f00533          	neg	a0,a5
    return 0;
  } else {
    return -1;
  }
}
    8000178c:	60a6                	ld	ra,72(sp)
    8000178e:	6406                	ld	s0,64(sp)
    80001790:	74e2                	ld	s1,56(sp)
    80001792:	7942                	ld	s2,48(sp)
    80001794:	79a2                	ld	s3,40(sp)
    80001796:	7a02                	ld	s4,32(sp)
    80001798:	6ae2                	ld	s5,24(sp)
    8000179a:	6b42                	ld	s6,16(sp)
    8000179c:	6ba2                	ld	s7,8(sp)
    8000179e:	6161                	addi	sp,sp,80
    800017a0:	8082                	ret
    srcva = va0 + PGSIZE;
    800017a2:	01390bb3          	add	s7,s2,s3
  while(got_null == 0 && max > 0){
    800017a6:	c8a9                	beqz	s1,800017f8 <copyinstr+0xa0>
    va0 = PGROUNDDOWN(srcva);
    800017a8:	015bf933          	and	s2,s7,s5
    pa0 = walkaddr(pagetable, va0);
    800017ac:	85ca                	mv	a1,s2
    800017ae:	8552                	mv	a0,s4
    800017b0:	00000097          	auipc	ra,0x0
    800017b4:	89c080e7          	jalr	-1892(ra) # 8000104c <walkaddr>
    if(pa0 == 0)
    800017b8:	c131                	beqz	a0,800017fc <copyinstr+0xa4>
    n = PGSIZE - (srcva - va0);
    800017ba:	41790833          	sub	a6,s2,s7
    800017be:	984e                	add	a6,a6,s3
    if(n > max)
    800017c0:	0104f363          	bgeu	s1,a6,800017c6 <copyinstr+0x6e>
    800017c4:	8826                	mv	a6,s1
    char *p = (char *) (pa0 + (srcva - va0));
    800017c6:	955e                	add	a0,a0,s7
    800017c8:	41250533          	sub	a0,a0,s2
    while(n > 0){
    800017cc:	fc080be3          	beqz	a6,800017a2 <copyinstr+0x4a>
    800017d0:	985a                	add	a6,a6,s6
    800017d2:	87da                	mv	a5,s6
      if(*p == '\0'){
    800017d4:	41650633          	sub	a2,a0,s6
    800017d8:	14fd                	addi	s1,s1,-1
    800017da:	9b26                	add	s6,s6,s1
    800017dc:	00f60733          	add	a4,a2,a5
    800017e0:	00074703          	lbu	a4,0(a4) # fffffffffffff000 <end+0xffffffff7ffde000>
    800017e4:	df49                	beqz	a4,8000177e <copyinstr+0x26>
        *dst = *p;
    800017e6:	00e78023          	sb	a4,0(a5)
      --max;
    800017ea:	40fb04b3          	sub	s1,s6,a5
      dst++;
    800017ee:	0785                	addi	a5,a5,1
    while(n > 0){
    800017f0:	ff0796e3          	bne	a5,a6,800017dc <copyinstr+0x84>
      dst++;
    800017f4:	8b42                	mv	s6,a6
    800017f6:	b775                	j	800017a2 <copyinstr+0x4a>
    800017f8:	4781                	li	a5,0
    800017fa:	b769                	j	80001784 <copyinstr+0x2c>
      return -1;
    800017fc:	557d                	li	a0,-1
    800017fe:	b779                	j	8000178c <copyinstr+0x34>
  int got_null = 0;
    80001800:	4781                	li	a5,0
  if(got_null){
    80001802:	0017b793          	seqz	a5,a5
    80001806:	40f00533          	neg	a0,a5
}
    8000180a:	8082                	ret

000000008000180c <wakeup1>:

// Wake up p if it is sleeping in wait(); used by exit().
// Caller must hold p->lock.
static void
wakeup1(struct proc *p)
{
    8000180c:	1101                	addi	sp,sp,-32
    8000180e:	ec06                	sd	ra,24(sp)
    80001810:	e822                	sd	s0,16(sp)
    80001812:	e426                	sd	s1,8(sp)
    80001814:	1000                	addi	s0,sp,32
    80001816:	84aa                	mv	s1,a0
  if(!holding(&p->lock))
    80001818:	fffff097          	auipc	ra,0xfffff
    8000181c:	330080e7          	jalr	816(ra) # 80000b48 <holding>
    80001820:	c909                	beqz	a0,80001832 <wakeup1+0x26>
    panic("wakeup1");
  if(p->chan == p && p->state == SLEEPING) {
    80001822:	749c                	ld	a5,40(s1)
    80001824:	00978f63          	beq	a5,s1,80001842 <wakeup1+0x36>
    p->state = RUNNABLE;
  }
}
    80001828:	60e2                	ld	ra,24(sp)
    8000182a:	6442                	ld	s0,16(sp)
    8000182c:	64a2                	ld	s1,8(sp)
    8000182e:	6105                	addi	sp,sp,32
    80001830:	8082                	ret
    panic("wakeup1");
    80001832:	00007517          	auipc	a0,0x7
    80001836:	98e50513          	addi	a0,a0,-1650 # 800081c0 <digits+0x180>
    8000183a:	fffff097          	auipc	ra,0xfffff
    8000183e:	cf0080e7          	jalr	-784(ra) # 8000052a <panic>
  if(p->chan == p && p->state == SLEEPING) {
    80001842:	4c98                	lw	a4,24(s1)
    80001844:	4785                	li	a5,1
    80001846:	fef711e3          	bne	a4,a5,80001828 <wakeup1+0x1c>
    p->state = RUNNABLE;
    8000184a:	4789                	li	a5,2
    8000184c:	cc9c                	sw	a5,24(s1)
}
    8000184e:	bfe9                	j	80001828 <wakeup1+0x1c>

0000000080001850 <proc_mapstacks>:
proc_mapstacks(pagetable_t kpgtbl) {
    80001850:	7139                	addi	sp,sp,-64
    80001852:	fc06                	sd	ra,56(sp)
    80001854:	f822                	sd	s0,48(sp)
    80001856:	f426                	sd	s1,40(sp)
    80001858:	f04a                	sd	s2,32(sp)
    8000185a:	ec4e                	sd	s3,24(sp)
    8000185c:	e852                	sd	s4,16(sp)
    8000185e:	e456                	sd	s5,8(sp)
    80001860:	e05a                	sd	s6,0(sp)
    80001862:	0080                	addi	s0,sp,64
    80001864:	89aa                	mv	s3,a0
  for(p = proc; p < &proc[NPROC]; p++) {
    80001866:	00010497          	auipc	s1,0x10
    8000186a:	e5248493          	addi	s1,s1,-430 # 800116b8 <proc>
    uint64 va = KSTACK((int) (p - proc));
    8000186e:	8b26                	mv	s6,s1
    80001870:	00006a97          	auipc	s5,0x6
    80001874:	790a8a93          	addi	s5,s5,1936 # 80008000 <etext>
    80001878:	04000937          	lui	s2,0x4000
    8000187c:	197d                	addi	s2,s2,-1
    8000187e:	0932                	slli	s2,s2,0xc
  for(p = proc; p < &proc[NPROC]; p++) {
    80001880:	00011a17          	auipc	s4,0x11
    80001884:	c48a0a13          	addi	s4,s4,-952 # 800124c8 <tickslock>
    char *pa = kalloc();
    80001888:	fffff097          	auipc	ra,0xfffff
    8000188c:	24a080e7          	jalr	586(ra) # 80000ad2 <kalloc>
    80001890:	862a                	mv	a2,a0
    if(pa == 0)
    80001892:	c131                	beqz	a0,800018d6 <proc_mapstacks+0x86>
    uint64 va = KSTACK((int) (p - proc));
    80001894:	416485b3          	sub	a1,s1,s6
    80001898:	858d                	srai	a1,a1,0x3
    8000189a:	000ab783          	ld	a5,0(s5)
    8000189e:	02f585b3          	mul	a1,a1,a5
    800018a2:	2585                	addiw	a1,a1,1
    800018a4:	00d5959b          	slliw	a1,a1,0xd
    kvmmap(kpgtbl, va, (uint64)pa, PGSIZE, PTE_R | PTE_W);
    800018a8:	4719                	li	a4,6
    800018aa:	6685                	lui	a3,0x1
    800018ac:	40b905b3          	sub	a1,s2,a1
    800018b0:	854e                	mv	a0,s3
    800018b2:	00000097          	auipc	ra,0x0
    800018b6:	86a080e7          	jalr	-1942(ra) # 8000111c <kvmmap>
  for(p = proc; p < &proc[NPROC]; p++) {
    800018ba:	16848493          	addi	s1,s1,360
    800018be:	fd4495e3          	bne	s1,s4,80001888 <proc_mapstacks+0x38>
}
    800018c2:	70e2                	ld	ra,56(sp)
    800018c4:	7442                	ld	s0,48(sp)
    800018c6:	74a2                	ld	s1,40(sp)
    800018c8:	7902                	ld	s2,32(sp)
    800018ca:	69e2                	ld	s3,24(sp)
    800018cc:	6a42                	ld	s4,16(sp)
    800018ce:	6aa2                	ld	s5,8(sp)
    800018d0:	6b02                	ld	s6,0(sp)
    800018d2:	6121                	addi	sp,sp,64
    800018d4:	8082                	ret
      panic("kalloc");
    800018d6:	00007517          	auipc	a0,0x7
    800018da:	8f250513          	addi	a0,a0,-1806 # 800081c8 <digits+0x188>
    800018de:	fffff097          	auipc	ra,0xfffff
    800018e2:	c4c080e7          	jalr	-948(ra) # 8000052a <panic>

00000000800018e6 <procinit>:
{
    800018e6:	7139                	addi	sp,sp,-64
    800018e8:	fc06                	sd	ra,56(sp)
    800018ea:	f822                	sd	s0,48(sp)
    800018ec:	f426                	sd	s1,40(sp)
    800018ee:	f04a                	sd	s2,32(sp)
    800018f0:	ec4e                	sd	s3,24(sp)
    800018f2:	e852                	sd	s4,16(sp)
    800018f4:	e456                	sd	s5,8(sp)
    800018f6:	e05a                	sd	s6,0(sp)
    800018f8:	0080                	addi	s0,sp,64
  initlock(&pid_lock, "nextpid");
    800018fa:	00007597          	auipc	a1,0x7
    800018fe:	8d658593          	addi	a1,a1,-1834 # 800081d0 <digits+0x190>
    80001902:	00010517          	auipc	a0,0x10
    80001906:	99e50513          	addi	a0,a0,-1634 # 800112a0 <pid_lock>
    8000190a:	fffff097          	auipc	ra,0xfffff
    8000190e:	228080e7          	jalr	552(ra) # 80000b32 <initlock>
  for(p = proc; p < &proc[NPROC]; p++) {
    80001912:	00010497          	auipc	s1,0x10
    80001916:	da648493          	addi	s1,s1,-602 # 800116b8 <proc>
      initlock(&p->lock, "proc");
    8000191a:	00007b17          	auipc	s6,0x7
    8000191e:	8beb0b13          	addi	s6,s6,-1858 # 800081d8 <digits+0x198>
      p->kstack = KSTACK((int) (p - proc));
    80001922:	8aa6                	mv	s5,s1
    80001924:	00006a17          	auipc	s4,0x6
    80001928:	6dca0a13          	addi	s4,s4,1756 # 80008000 <etext>
    8000192c:	04000937          	lui	s2,0x4000
    80001930:	197d                	addi	s2,s2,-1
    80001932:	0932                	slli	s2,s2,0xc
  for(p = proc; p < &proc[NPROC]; p++) {
    80001934:	00011997          	auipc	s3,0x11
    80001938:	b9498993          	addi	s3,s3,-1132 # 800124c8 <tickslock>
      initlock(&p->lock, "proc");
    8000193c:	85da                	mv	a1,s6
    8000193e:	8526                	mv	a0,s1
    80001940:	fffff097          	auipc	ra,0xfffff
    80001944:	1f2080e7          	jalr	498(ra) # 80000b32 <initlock>
      p->kstack = KSTACK((int) (p - proc));
    80001948:	415487b3          	sub	a5,s1,s5
    8000194c:	878d                	srai	a5,a5,0x3
    8000194e:	000a3703          	ld	a4,0(s4)
    80001952:	02e787b3          	mul	a5,a5,a4
    80001956:	2785                	addiw	a5,a5,1
    80001958:	00d7979b          	slliw	a5,a5,0xd
    8000195c:	40f907b3          	sub	a5,s2,a5
    80001960:	e0bc                	sd	a5,64(s1)
  for(p = proc; p < &proc[NPROC]; p++) {
    80001962:	16848493          	addi	s1,s1,360
    80001966:	fd349be3          	bne	s1,s3,8000193c <procinit+0x56>
}
    8000196a:	70e2                	ld	ra,56(sp)
    8000196c:	7442                	ld	s0,48(sp)
    8000196e:	74a2                	ld	s1,40(sp)
    80001970:	7902                	ld	s2,32(sp)
    80001972:	69e2                	ld	s3,24(sp)
    80001974:	6a42                	ld	s4,16(sp)
    80001976:	6aa2                	ld	s5,8(sp)
    80001978:	6b02                	ld	s6,0(sp)
    8000197a:	6121                	addi	sp,sp,64
    8000197c:	8082                	ret

000000008000197e <cpuid>:
{
    8000197e:	1141                	addi	sp,sp,-16
    80001980:	e422                	sd	s0,8(sp)
    80001982:	0800                	addi	s0,sp,16
  asm volatile("mv %0, tp" : "=r" (x) );
    80001984:	8512                	mv	a0,tp
}
    80001986:	2501                	sext.w	a0,a0
    80001988:	6422                	ld	s0,8(sp)
    8000198a:	0141                	addi	sp,sp,16
    8000198c:	8082                	ret

000000008000198e <mycpu>:
mycpu(void) {
    8000198e:	1141                	addi	sp,sp,-16
    80001990:	e422                	sd	s0,8(sp)
    80001992:	0800                	addi	s0,sp,16
    80001994:	8792                	mv	a5,tp
  struct cpu *c = &cpus[id];
    80001996:	2781                	sext.w	a5,a5
    80001998:	079e                	slli	a5,a5,0x7
}
    8000199a:	00010517          	auipc	a0,0x10
    8000199e:	91e50513          	addi	a0,a0,-1762 # 800112b8 <cpus>
    800019a2:	953e                	add	a0,a0,a5
    800019a4:	6422                	ld	s0,8(sp)
    800019a6:	0141                	addi	sp,sp,16
    800019a8:	8082                	ret

00000000800019aa <myproc>:
myproc(void) {
    800019aa:	1101                	addi	sp,sp,-32
    800019ac:	ec06                	sd	ra,24(sp)
    800019ae:	e822                	sd	s0,16(sp)
    800019b0:	e426                	sd	s1,8(sp)
    800019b2:	1000                	addi	s0,sp,32
  push_off();
    800019b4:	fffff097          	auipc	ra,0xfffff
    800019b8:	1c2080e7          	jalr	450(ra) # 80000b76 <push_off>
    800019bc:	8792                	mv	a5,tp
  struct proc *p = c->proc;
    800019be:	2781                	sext.w	a5,a5
    800019c0:	079e                	slli	a5,a5,0x7
    800019c2:	00010717          	auipc	a4,0x10
    800019c6:	8de70713          	addi	a4,a4,-1826 # 800112a0 <pid_lock>
    800019ca:	97ba                	add	a5,a5,a4
    800019cc:	6f84                	ld	s1,24(a5)
  pop_off();
    800019ce:	fffff097          	auipc	ra,0xfffff
    800019d2:	248080e7          	jalr	584(ra) # 80000c16 <pop_off>
}
    800019d6:	8526                	mv	a0,s1
    800019d8:	60e2                	ld	ra,24(sp)
    800019da:	6442                	ld	s0,16(sp)
    800019dc:	64a2                	ld	s1,8(sp)
    800019de:	6105                	addi	sp,sp,32
    800019e0:	8082                	ret

00000000800019e2 <forkret>:
{
    800019e2:	1141                	addi	sp,sp,-16
    800019e4:	e406                	sd	ra,8(sp)
    800019e6:	e022                	sd	s0,0(sp)
    800019e8:	0800                	addi	s0,sp,16
  release(&myproc()->lock);
    800019ea:	00000097          	auipc	ra,0x0
    800019ee:	fc0080e7          	jalr	-64(ra) # 800019aa <myproc>
    800019f2:	fffff097          	auipc	ra,0xfffff
    800019f6:	284080e7          	jalr	644(ra) # 80000c76 <release>
  if (first) {
    800019fa:	00007797          	auipc	a5,0x7
    800019fe:	df67a783          	lw	a5,-522(a5) # 800087f0 <first.1>
    80001a02:	eb89                	bnez	a5,80001a14 <forkret+0x32>
  usertrapret();
    80001a04:	00001097          	auipc	ra,0x1
    80001a08:	c18080e7          	jalr	-1000(ra) # 8000261c <usertrapret>
}
    80001a0c:	60a2                	ld	ra,8(sp)
    80001a0e:	6402                	ld	s0,0(sp)
    80001a10:	0141                	addi	sp,sp,16
    80001a12:	8082                	ret
    first = 0;
    80001a14:	00007797          	auipc	a5,0x7
    80001a18:	dc07ae23          	sw	zero,-548(a5) # 800087f0 <first.1>
    fsinit(ROOTDEV);
    80001a1c:	4505                	li	a0,1
    80001a1e:	00002097          	auipc	ra,0x2
    80001a22:	a04080e7          	jalr	-1532(ra) # 80003422 <fsinit>
    80001a26:	bff9                	j	80001a04 <forkret+0x22>

0000000080001a28 <allocpid>:
allocpid() {
    80001a28:	1101                	addi	sp,sp,-32
    80001a2a:	ec06                	sd	ra,24(sp)
    80001a2c:	e822                	sd	s0,16(sp)
    80001a2e:	e426                	sd	s1,8(sp)
    80001a30:	e04a                	sd	s2,0(sp)
    80001a32:	1000                	addi	s0,sp,32
  acquire(&pid_lock);
    80001a34:	00010917          	auipc	s2,0x10
    80001a38:	86c90913          	addi	s2,s2,-1940 # 800112a0 <pid_lock>
    80001a3c:	854a                	mv	a0,s2
    80001a3e:	fffff097          	auipc	ra,0xfffff
    80001a42:	184080e7          	jalr	388(ra) # 80000bc2 <acquire>
  pid = nextpid;
    80001a46:	00007797          	auipc	a5,0x7
    80001a4a:	dae78793          	addi	a5,a5,-594 # 800087f4 <nextpid>
    80001a4e:	4384                	lw	s1,0(a5)
  nextpid = nextpid + 1;
    80001a50:	0014871b          	addiw	a4,s1,1
    80001a54:	c398                	sw	a4,0(a5)
  release(&pid_lock);
    80001a56:	854a                	mv	a0,s2
    80001a58:	fffff097          	auipc	ra,0xfffff
    80001a5c:	21e080e7          	jalr	542(ra) # 80000c76 <release>
}
    80001a60:	8526                	mv	a0,s1
    80001a62:	60e2                	ld	ra,24(sp)
    80001a64:	6442                	ld	s0,16(sp)
    80001a66:	64a2                	ld	s1,8(sp)
    80001a68:	6902                	ld	s2,0(sp)
    80001a6a:	6105                	addi	sp,sp,32
    80001a6c:	8082                	ret

0000000080001a6e <proc_pagetable>:
{
    80001a6e:	1101                	addi	sp,sp,-32
    80001a70:	ec06                	sd	ra,24(sp)
    80001a72:	e822                	sd	s0,16(sp)
    80001a74:	e426                	sd	s1,8(sp)
    80001a76:	e04a                	sd	s2,0(sp)
    80001a78:	1000                	addi	s0,sp,32
    80001a7a:	892a                	mv	s2,a0
  pagetable = uvmcreate();
    80001a7c:	00000097          	auipc	ra,0x0
    80001a80:	88a080e7          	jalr	-1910(ra) # 80001306 <uvmcreate>
    80001a84:	84aa                	mv	s1,a0
  if(pagetable == 0)
    80001a86:	c121                	beqz	a0,80001ac6 <proc_pagetable+0x58>
  if(mappages(pagetable, TRAMPOLINE, PGSIZE,
    80001a88:	4729                	li	a4,10
    80001a8a:	00005697          	auipc	a3,0x5
    80001a8e:	57668693          	addi	a3,a3,1398 # 80007000 <_trampoline>
    80001a92:	6605                	lui	a2,0x1
    80001a94:	040005b7          	lui	a1,0x4000
    80001a98:	15fd                	addi	a1,a1,-1
    80001a9a:	05b2                	slli	a1,a1,0xc
    80001a9c:	fffff097          	auipc	ra,0xfffff
    80001aa0:	5f2080e7          	jalr	1522(ra) # 8000108e <mappages>
    80001aa4:	02054863          	bltz	a0,80001ad4 <proc_pagetable+0x66>
  if(mappages(pagetable, TRAPFRAME, PGSIZE,
    80001aa8:	4719                	li	a4,6
    80001aaa:	05893683          	ld	a3,88(s2)
    80001aae:	6605                	lui	a2,0x1
    80001ab0:	020005b7          	lui	a1,0x2000
    80001ab4:	15fd                	addi	a1,a1,-1
    80001ab6:	05b6                	slli	a1,a1,0xd
    80001ab8:	8526                	mv	a0,s1
    80001aba:	fffff097          	auipc	ra,0xfffff
    80001abe:	5d4080e7          	jalr	1492(ra) # 8000108e <mappages>
    80001ac2:	02054163          	bltz	a0,80001ae4 <proc_pagetable+0x76>
}
    80001ac6:	8526                	mv	a0,s1
    80001ac8:	60e2                	ld	ra,24(sp)
    80001aca:	6442                	ld	s0,16(sp)
    80001acc:	64a2                	ld	s1,8(sp)
    80001ace:	6902                	ld	s2,0(sp)
    80001ad0:	6105                	addi	sp,sp,32
    80001ad2:	8082                	ret
    uvmfree(pagetable, 0);
    80001ad4:	4581                	li	a1,0
    80001ad6:	8526                	mv	a0,s1
    80001ad8:	00000097          	auipc	ra,0x0
    80001adc:	a2a080e7          	jalr	-1494(ra) # 80001502 <uvmfree>
    return 0;
    80001ae0:	4481                	li	s1,0
    80001ae2:	b7d5                	j	80001ac6 <proc_pagetable+0x58>
    uvmunmap(pagetable, TRAMPOLINE, 1, 0);
    80001ae4:	4681                	li	a3,0
    80001ae6:	4605                	li	a2,1
    80001ae8:	040005b7          	lui	a1,0x4000
    80001aec:	15fd                	addi	a1,a1,-1
    80001aee:	05b2                	slli	a1,a1,0xc
    80001af0:	8526                	mv	a0,s1
    80001af2:	fffff097          	auipc	ra,0xfffff
    80001af6:	750080e7          	jalr	1872(ra) # 80001242 <uvmunmap>
    uvmfree(pagetable, 0);
    80001afa:	4581                	li	a1,0
    80001afc:	8526                	mv	a0,s1
    80001afe:	00000097          	auipc	ra,0x0
    80001b02:	a04080e7          	jalr	-1532(ra) # 80001502 <uvmfree>
    return 0;
    80001b06:	4481                	li	s1,0
    80001b08:	bf7d                	j	80001ac6 <proc_pagetable+0x58>

0000000080001b0a <proc_freepagetable>:
{
    80001b0a:	1101                	addi	sp,sp,-32
    80001b0c:	ec06                	sd	ra,24(sp)
    80001b0e:	e822                	sd	s0,16(sp)
    80001b10:	e426                	sd	s1,8(sp)
    80001b12:	e04a                	sd	s2,0(sp)
    80001b14:	1000                	addi	s0,sp,32
    80001b16:	84aa                	mv	s1,a0
    80001b18:	892e                	mv	s2,a1
  uvmunmap(pagetable, TRAMPOLINE, 1, 0);
    80001b1a:	4681                	li	a3,0
    80001b1c:	4605                	li	a2,1
    80001b1e:	040005b7          	lui	a1,0x4000
    80001b22:	15fd                	addi	a1,a1,-1
    80001b24:	05b2                	slli	a1,a1,0xc
    80001b26:	fffff097          	auipc	ra,0xfffff
    80001b2a:	71c080e7          	jalr	1820(ra) # 80001242 <uvmunmap>
  uvmunmap(pagetable, TRAPFRAME, 1, 0);
    80001b2e:	4681                	li	a3,0
    80001b30:	4605                	li	a2,1
    80001b32:	020005b7          	lui	a1,0x2000
    80001b36:	15fd                	addi	a1,a1,-1
    80001b38:	05b6                	slli	a1,a1,0xd
    80001b3a:	8526                	mv	a0,s1
    80001b3c:	fffff097          	auipc	ra,0xfffff
    80001b40:	706080e7          	jalr	1798(ra) # 80001242 <uvmunmap>
  uvmfree(pagetable, sz);
    80001b44:	85ca                	mv	a1,s2
    80001b46:	8526                	mv	a0,s1
    80001b48:	00000097          	auipc	ra,0x0
    80001b4c:	9ba080e7          	jalr	-1606(ra) # 80001502 <uvmfree>
}
    80001b50:	60e2                	ld	ra,24(sp)
    80001b52:	6442                	ld	s0,16(sp)
    80001b54:	64a2                	ld	s1,8(sp)
    80001b56:	6902                	ld	s2,0(sp)
    80001b58:	6105                	addi	sp,sp,32
    80001b5a:	8082                	ret

0000000080001b5c <freeproc>:
{
    80001b5c:	1101                	addi	sp,sp,-32
    80001b5e:	ec06                	sd	ra,24(sp)
    80001b60:	e822                	sd	s0,16(sp)
    80001b62:	e426                	sd	s1,8(sp)
    80001b64:	1000                	addi	s0,sp,32
    80001b66:	84aa                	mv	s1,a0
  if(p->trapframe)
    80001b68:	6d28                	ld	a0,88(a0)
    80001b6a:	c509                	beqz	a0,80001b74 <freeproc+0x18>
    kfree((void*)p->trapframe);
    80001b6c:	fffff097          	auipc	ra,0xfffff
    80001b70:	e6a080e7          	jalr	-406(ra) # 800009d6 <kfree>
  p->trapframe = 0;
    80001b74:	0404bc23          	sd	zero,88(s1)
  if(p->pagetable)
    80001b78:	68a8                	ld	a0,80(s1)
    80001b7a:	c511                	beqz	a0,80001b86 <freeproc+0x2a>
    proc_freepagetable(p->pagetable, p->sz);
    80001b7c:	64ac                	ld	a1,72(s1)
    80001b7e:	00000097          	auipc	ra,0x0
    80001b82:	f8c080e7          	jalr	-116(ra) # 80001b0a <proc_freepagetable>
  p->pagetable = 0;
    80001b86:	0404b823          	sd	zero,80(s1)
  p->sz = 0;
    80001b8a:	0404b423          	sd	zero,72(s1)
  p->pid = 0;
    80001b8e:	0204ac23          	sw	zero,56(s1)
  p->parent = 0;
    80001b92:	0204b023          	sd	zero,32(s1)
  p->name[0] = 0;
    80001b96:	14048c23          	sb	zero,344(s1)
  p->chan = 0;
    80001b9a:	0204b423          	sd	zero,40(s1)
  p->killed = 0;
    80001b9e:	0204a823          	sw	zero,48(s1)
  p->xstate = 0;
    80001ba2:	0204aa23          	sw	zero,52(s1)
  p->state = UNUSED;
    80001ba6:	0004ac23          	sw	zero,24(s1)
}
    80001baa:	60e2                	ld	ra,24(sp)
    80001bac:	6442                	ld	s0,16(sp)
    80001bae:	64a2                	ld	s1,8(sp)
    80001bb0:	6105                	addi	sp,sp,32
    80001bb2:	8082                	ret

0000000080001bb4 <allocproc>:
{
    80001bb4:	1101                	addi	sp,sp,-32
    80001bb6:	ec06                	sd	ra,24(sp)
    80001bb8:	e822                	sd	s0,16(sp)
    80001bba:	e426                	sd	s1,8(sp)
    80001bbc:	e04a                	sd	s2,0(sp)
    80001bbe:	1000                	addi	s0,sp,32
  for(p = proc; p < &proc[NPROC]; p++) {
    80001bc0:	00010497          	auipc	s1,0x10
    80001bc4:	af848493          	addi	s1,s1,-1288 # 800116b8 <proc>
    80001bc8:	00011917          	auipc	s2,0x11
    80001bcc:	90090913          	addi	s2,s2,-1792 # 800124c8 <tickslock>
    acquire(&p->lock);
    80001bd0:	8526                	mv	a0,s1
    80001bd2:	fffff097          	auipc	ra,0xfffff
    80001bd6:	ff0080e7          	jalr	-16(ra) # 80000bc2 <acquire>
    if(p->state == UNUSED) {
    80001bda:	4c9c                	lw	a5,24(s1)
    80001bdc:	c395                	beqz	a5,80001c00 <allocproc+0x4c>
      release(&p->lock);
    80001bde:	8526                	mv	a0,s1
    80001be0:	fffff097          	auipc	ra,0xfffff
    80001be4:	096080e7          	jalr	150(ra) # 80000c76 <release>
  for(p = proc; p < &proc[NPROC]; p++) {
    80001be8:	16848493          	addi	s1,s1,360
    80001bec:	ff2492e3          	bne	s1,s2,80001bd0 <allocproc+0x1c>
  return 0;
    80001bf0:	4481                	li	s1,0
}
    80001bf2:	8526                	mv	a0,s1
    80001bf4:	60e2                	ld	ra,24(sp)
    80001bf6:	6442                	ld	s0,16(sp)
    80001bf8:	64a2                	ld	s1,8(sp)
    80001bfa:	6902                	ld	s2,0(sp)
    80001bfc:	6105                	addi	sp,sp,32
    80001bfe:	8082                	ret
  p->pid = allocpid();
    80001c00:	00000097          	auipc	ra,0x0
    80001c04:	e28080e7          	jalr	-472(ra) # 80001a28 <allocpid>
    80001c08:	dc88                	sw	a0,56(s1)
  if((p->trapframe = (struct trapframe *)kalloc()) == 0){
    80001c0a:	fffff097          	auipc	ra,0xfffff
    80001c0e:	ec8080e7          	jalr	-312(ra) # 80000ad2 <kalloc>
    80001c12:	892a                	mv	s2,a0
    80001c14:	eca8                	sd	a0,88(s1)
    80001c16:	cd05                	beqz	a0,80001c4e <allocproc+0x9a>
  p->pagetable = proc_pagetable(p);
    80001c18:	8526                	mv	a0,s1
    80001c1a:	00000097          	auipc	ra,0x0
    80001c1e:	e54080e7          	jalr	-428(ra) # 80001a6e <proc_pagetable>
    80001c22:	892a                	mv	s2,a0
    80001c24:	e8a8                	sd	a0,80(s1)
  if(p->pagetable == 0){
    80001c26:	c91d                	beqz	a0,80001c5c <allocproc+0xa8>
  memset(&p->context, 0, sizeof(p->context));
    80001c28:	07000613          	li	a2,112
    80001c2c:	4581                	li	a1,0
    80001c2e:	06048513          	addi	a0,s1,96
    80001c32:	fffff097          	auipc	ra,0xfffff
    80001c36:	08c080e7          	jalr	140(ra) # 80000cbe <memset>
  p->context.ra = (uint64)forkret;
    80001c3a:	00000797          	auipc	a5,0x0
    80001c3e:	da878793          	addi	a5,a5,-600 # 800019e2 <forkret>
    80001c42:	f0bc                	sd	a5,96(s1)
  p->context.sp = p->kstack + PGSIZE;
    80001c44:	60bc                	ld	a5,64(s1)
    80001c46:	6705                	lui	a4,0x1
    80001c48:	97ba                	add	a5,a5,a4
    80001c4a:	f4bc                	sd	a5,104(s1)
  return p;
    80001c4c:	b75d                	j	80001bf2 <allocproc+0x3e>
    release(&p->lock);
    80001c4e:	8526                	mv	a0,s1
    80001c50:	fffff097          	auipc	ra,0xfffff
    80001c54:	026080e7          	jalr	38(ra) # 80000c76 <release>
    return 0;
    80001c58:	84ca                	mv	s1,s2
    80001c5a:	bf61                	j	80001bf2 <allocproc+0x3e>
    freeproc(p);
    80001c5c:	8526                	mv	a0,s1
    80001c5e:	00000097          	auipc	ra,0x0
    80001c62:	efe080e7          	jalr	-258(ra) # 80001b5c <freeproc>
    release(&p->lock);
    80001c66:	8526                	mv	a0,s1
    80001c68:	fffff097          	auipc	ra,0xfffff
    80001c6c:	00e080e7          	jalr	14(ra) # 80000c76 <release>
    return 0;
    80001c70:	84ca                	mv	s1,s2
    80001c72:	b741                	j	80001bf2 <allocproc+0x3e>

0000000080001c74 <userinit>:
{
    80001c74:	1101                	addi	sp,sp,-32
    80001c76:	ec06                	sd	ra,24(sp)
    80001c78:	e822                	sd	s0,16(sp)
    80001c7a:	e426                	sd	s1,8(sp)
    80001c7c:	1000                	addi	s0,sp,32
  p = allocproc();
    80001c7e:	00000097          	auipc	ra,0x0
    80001c82:	f36080e7          	jalr	-202(ra) # 80001bb4 <allocproc>
    80001c86:	84aa                	mv	s1,a0
  initproc = p;
    80001c88:	00007797          	auipc	a5,0x7
    80001c8c:	3aa7b023          	sd	a0,928(a5) # 80009028 <initproc>
  uvminit(p->pagetable, initcode, sizeof(initcode));
    80001c90:	03400613          	li	a2,52
    80001c94:	00007597          	auipc	a1,0x7
    80001c98:	b6c58593          	addi	a1,a1,-1172 # 80008800 <initcode>
    80001c9c:	6928                	ld	a0,80(a0)
    80001c9e:	fffff097          	auipc	ra,0xfffff
    80001ca2:	696080e7          	jalr	1686(ra) # 80001334 <uvminit>
  p->sz = PGSIZE;
    80001ca6:	6785                	lui	a5,0x1
    80001ca8:	e4bc                	sd	a5,72(s1)
  p->trapframe->epc = 0;      // user program counter
    80001caa:	6cb8                	ld	a4,88(s1)
    80001cac:	00073c23          	sd	zero,24(a4) # 1018 <_entry-0x7fffefe8>
  p->trapframe->sp = PGSIZE;  // user stack pointer
    80001cb0:	6cb8                	ld	a4,88(s1)
    80001cb2:	fb1c                	sd	a5,48(a4)
  safestrcpy(p->name, "initcode", sizeof(p->name));
    80001cb4:	4641                	li	a2,16
    80001cb6:	00006597          	auipc	a1,0x6
    80001cba:	52a58593          	addi	a1,a1,1322 # 800081e0 <digits+0x1a0>
    80001cbe:	15848513          	addi	a0,s1,344
    80001cc2:	fffff097          	auipc	ra,0xfffff
    80001cc6:	14e080e7          	jalr	334(ra) # 80000e10 <safestrcpy>
  p->cwd = namei("/");
    80001cca:	00006517          	auipc	a0,0x6
    80001cce:	52650513          	addi	a0,a0,1318 # 800081f0 <digits+0x1b0>
    80001cd2:	00002097          	auipc	ra,0x2
    80001cd6:	22a080e7          	jalr	554(ra) # 80003efc <namei>
    80001cda:	14a4b823          	sd	a0,336(s1)
  p->state = RUNNABLE;
    80001cde:	4789                	li	a5,2
    80001ce0:	cc9c                	sw	a5,24(s1)
  release(&p->lock);
    80001ce2:	8526                	mv	a0,s1
    80001ce4:	fffff097          	auipc	ra,0xfffff
    80001ce8:	f92080e7          	jalr	-110(ra) # 80000c76 <release>
}
    80001cec:	60e2                	ld	ra,24(sp)
    80001cee:	6442                	ld	s0,16(sp)
    80001cf0:	64a2                	ld	s1,8(sp)
    80001cf2:	6105                	addi	sp,sp,32
    80001cf4:	8082                	ret

0000000080001cf6 <growproc>:
{
    80001cf6:	1101                	addi	sp,sp,-32
    80001cf8:	ec06                	sd	ra,24(sp)
    80001cfa:	e822                	sd	s0,16(sp)
    80001cfc:	e426                	sd	s1,8(sp)
    80001cfe:	e04a                	sd	s2,0(sp)
    80001d00:	1000                	addi	s0,sp,32
    80001d02:	84aa                	mv	s1,a0
  struct proc *p = myproc();
    80001d04:	00000097          	auipc	ra,0x0
    80001d08:	ca6080e7          	jalr	-858(ra) # 800019aa <myproc>
    80001d0c:	892a                	mv	s2,a0
  sz = p->sz;
    80001d0e:	652c                	ld	a1,72(a0)
    80001d10:	0005861b          	sext.w	a2,a1
  if(n > 0){
    80001d14:	00904f63          	bgtz	s1,80001d32 <growproc+0x3c>
  } else if(n < 0){
    80001d18:	0204cc63          	bltz	s1,80001d50 <growproc+0x5a>
  p->sz = sz;
    80001d1c:	1602                	slli	a2,a2,0x20
    80001d1e:	9201                	srli	a2,a2,0x20
    80001d20:	04c93423          	sd	a2,72(s2)
  return 0;
    80001d24:	4501                	li	a0,0
}
    80001d26:	60e2                	ld	ra,24(sp)
    80001d28:	6442                	ld	s0,16(sp)
    80001d2a:	64a2                	ld	s1,8(sp)
    80001d2c:	6902                	ld	s2,0(sp)
    80001d2e:	6105                	addi	sp,sp,32
    80001d30:	8082                	ret
    if((sz = uvmalloc(p->pagetable, sz, sz + n)) == 0) {
    80001d32:	9e25                	addw	a2,a2,s1
    80001d34:	1602                	slli	a2,a2,0x20
    80001d36:	9201                	srli	a2,a2,0x20
    80001d38:	1582                	slli	a1,a1,0x20
    80001d3a:	9181                	srli	a1,a1,0x20
    80001d3c:	6928                	ld	a0,80(a0)
    80001d3e:	fffff097          	auipc	ra,0xfffff
    80001d42:	6b0080e7          	jalr	1712(ra) # 800013ee <uvmalloc>
    80001d46:	0005061b          	sext.w	a2,a0
    80001d4a:	fa69                	bnez	a2,80001d1c <growproc+0x26>
      return -1;
    80001d4c:	557d                	li	a0,-1
    80001d4e:	bfe1                	j	80001d26 <growproc+0x30>
    sz = uvmdealloc(p->pagetable, sz, sz + n);
    80001d50:	9e25                	addw	a2,a2,s1
    80001d52:	1602                	slli	a2,a2,0x20
    80001d54:	9201                	srli	a2,a2,0x20
    80001d56:	1582                	slli	a1,a1,0x20
    80001d58:	9181                	srli	a1,a1,0x20
    80001d5a:	6928                	ld	a0,80(a0)
    80001d5c:	fffff097          	auipc	ra,0xfffff
    80001d60:	64a080e7          	jalr	1610(ra) # 800013a6 <uvmdealloc>
    80001d64:	0005061b          	sext.w	a2,a0
    80001d68:	bf55                	j	80001d1c <growproc+0x26>

0000000080001d6a <fork>:
{
    80001d6a:	7139                	addi	sp,sp,-64
    80001d6c:	fc06                	sd	ra,56(sp)
    80001d6e:	f822                	sd	s0,48(sp)
    80001d70:	f426                	sd	s1,40(sp)
    80001d72:	f04a                	sd	s2,32(sp)
    80001d74:	ec4e                	sd	s3,24(sp)
    80001d76:	e852                	sd	s4,16(sp)
    80001d78:	e456                	sd	s5,8(sp)
    80001d7a:	0080                	addi	s0,sp,64
  struct proc *p = myproc();
    80001d7c:	00000097          	auipc	ra,0x0
    80001d80:	c2e080e7          	jalr	-978(ra) # 800019aa <myproc>
    80001d84:	8aaa                	mv	s5,a0
  if((np = allocproc()) == 0){
    80001d86:	00000097          	auipc	ra,0x0
    80001d8a:	e2e080e7          	jalr	-466(ra) # 80001bb4 <allocproc>
    80001d8e:	c17d                	beqz	a0,80001e74 <fork+0x10a>
    80001d90:	8a2a                	mv	s4,a0
  if(uvmcopy(p->pagetable, np->pagetable, p->sz) < 0){
    80001d92:	048ab603          	ld	a2,72(s5)
    80001d96:	692c                	ld	a1,80(a0)
    80001d98:	050ab503          	ld	a0,80(s5)
    80001d9c:	fffff097          	auipc	ra,0xfffff
    80001da0:	79e080e7          	jalr	1950(ra) # 8000153a <uvmcopy>
    80001da4:	04054a63          	bltz	a0,80001df8 <fork+0x8e>
  np->sz = p->sz;
    80001da8:	048ab783          	ld	a5,72(s5)
    80001dac:	04fa3423          	sd	a5,72(s4)
  np->parent = p;
    80001db0:	035a3023          	sd	s5,32(s4)
  *(np->trapframe) = *(p->trapframe);
    80001db4:	058ab683          	ld	a3,88(s5)
    80001db8:	87b6                	mv	a5,a3
    80001dba:	058a3703          	ld	a4,88(s4)
    80001dbe:	12068693          	addi	a3,a3,288
    80001dc2:	0007b803          	ld	a6,0(a5) # 1000 <_entry-0x7ffff000>
    80001dc6:	6788                	ld	a0,8(a5)
    80001dc8:	6b8c                	ld	a1,16(a5)
    80001dca:	6f90                	ld	a2,24(a5)
    80001dcc:	01073023          	sd	a6,0(a4)
    80001dd0:	e708                	sd	a0,8(a4)
    80001dd2:	eb0c                	sd	a1,16(a4)
    80001dd4:	ef10                	sd	a2,24(a4)
    80001dd6:	02078793          	addi	a5,a5,32
    80001dda:	02070713          	addi	a4,a4,32
    80001dde:	fed792e3          	bne	a5,a3,80001dc2 <fork+0x58>
  np->trapframe->a0 = 0;
    80001de2:	058a3783          	ld	a5,88(s4)
    80001de6:	0607b823          	sd	zero,112(a5)
  for(i = 0; i < NOFILE; i++)
    80001dea:	0d0a8493          	addi	s1,s5,208
    80001dee:	0d0a0913          	addi	s2,s4,208
    80001df2:	150a8993          	addi	s3,s5,336
    80001df6:	a00d                	j	80001e18 <fork+0xae>
    freeproc(np);
    80001df8:	8552                	mv	a0,s4
    80001dfa:	00000097          	auipc	ra,0x0
    80001dfe:	d62080e7          	jalr	-670(ra) # 80001b5c <freeproc>
    release(&np->lock);
    80001e02:	8552                	mv	a0,s4
    80001e04:	fffff097          	auipc	ra,0xfffff
    80001e08:	e72080e7          	jalr	-398(ra) # 80000c76 <release>
    return -1;
    80001e0c:	54fd                	li	s1,-1
    80001e0e:	a889                	j	80001e60 <fork+0xf6>
  for(i = 0; i < NOFILE; i++)
    80001e10:	04a1                	addi	s1,s1,8
    80001e12:	0921                	addi	s2,s2,8
    80001e14:	01348b63          	beq	s1,s3,80001e2a <fork+0xc0>
    if(p->ofile[i])
    80001e18:	6088                	ld	a0,0(s1)
    80001e1a:	d97d                	beqz	a0,80001e10 <fork+0xa6>
      np->ofile[i] = filedup(p->ofile[i]);
    80001e1c:	00002097          	auipc	ra,0x2
    80001e20:	77e080e7          	jalr	1918(ra) # 8000459a <filedup>
    80001e24:	00a93023          	sd	a0,0(s2)
    80001e28:	b7e5                	j	80001e10 <fork+0xa6>
  np->cwd = idup(p->cwd);
    80001e2a:	150ab503          	ld	a0,336(s5)
    80001e2e:	00002097          	auipc	ra,0x2
    80001e32:	82e080e7          	jalr	-2002(ra) # 8000365c <idup>
    80001e36:	14aa3823          	sd	a0,336(s4)
  safestrcpy(np->name, p->name, sizeof(p->name));
    80001e3a:	4641                	li	a2,16
    80001e3c:	158a8593          	addi	a1,s5,344
    80001e40:	158a0513          	addi	a0,s4,344
    80001e44:	fffff097          	auipc	ra,0xfffff
    80001e48:	fcc080e7          	jalr	-52(ra) # 80000e10 <safestrcpy>
  pid = np->pid;
    80001e4c:	038a2483          	lw	s1,56(s4)
  np->state = RUNNABLE;
    80001e50:	4789                	li	a5,2
    80001e52:	00fa2c23          	sw	a5,24(s4)
  release(&np->lock);
    80001e56:	8552                	mv	a0,s4
    80001e58:	fffff097          	auipc	ra,0xfffff
    80001e5c:	e1e080e7          	jalr	-482(ra) # 80000c76 <release>
}
    80001e60:	8526                	mv	a0,s1
    80001e62:	70e2                	ld	ra,56(sp)
    80001e64:	7442                	ld	s0,48(sp)
    80001e66:	74a2                	ld	s1,40(sp)
    80001e68:	7902                	ld	s2,32(sp)
    80001e6a:	69e2                	ld	s3,24(sp)
    80001e6c:	6a42                	ld	s4,16(sp)
    80001e6e:	6aa2                	ld	s5,8(sp)
    80001e70:	6121                	addi	sp,sp,64
    80001e72:	8082                	ret
    return -1;
    80001e74:	54fd                	li	s1,-1
    80001e76:	b7ed                	j	80001e60 <fork+0xf6>

0000000080001e78 <reparent>:
{
    80001e78:	7179                	addi	sp,sp,-48
    80001e7a:	f406                	sd	ra,40(sp)
    80001e7c:	f022                	sd	s0,32(sp)
    80001e7e:	ec26                	sd	s1,24(sp)
    80001e80:	e84a                	sd	s2,16(sp)
    80001e82:	e44e                	sd	s3,8(sp)
    80001e84:	e052                	sd	s4,0(sp)
    80001e86:	1800                	addi	s0,sp,48
    80001e88:	892a                	mv	s2,a0
  for(pp = proc; pp < &proc[NPROC]; pp++){
    80001e8a:	00010497          	auipc	s1,0x10
    80001e8e:	82e48493          	addi	s1,s1,-2002 # 800116b8 <proc>
      pp->parent = initproc;
    80001e92:	00007a17          	auipc	s4,0x7
    80001e96:	196a0a13          	addi	s4,s4,406 # 80009028 <initproc>
  for(pp = proc; pp < &proc[NPROC]; pp++){
    80001e9a:	00010997          	auipc	s3,0x10
    80001e9e:	62e98993          	addi	s3,s3,1582 # 800124c8 <tickslock>
    80001ea2:	a029                	j	80001eac <reparent+0x34>
    80001ea4:	16848493          	addi	s1,s1,360
    80001ea8:	03348363          	beq	s1,s3,80001ece <reparent+0x56>
    if(pp->parent == p){
    80001eac:	709c                	ld	a5,32(s1)
    80001eae:	ff279be3          	bne	a5,s2,80001ea4 <reparent+0x2c>
      acquire(&pp->lock);
    80001eb2:	8526                	mv	a0,s1
    80001eb4:	fffff097          	auipc	ra,0xfffff
    80001eb8:	d0e080e7          	jalr	-754(ra) # 80000bc2 <acquire>
      pp->parent = initproc;
    80001ebc:	000a3783          	ld	a5,0(s4)
    80001ec0:	f09c                	sd	a5,32(s1)
      release(&pp->lock);
    80001ec2:	8526                	mv	a0,s1
    80001ec4:	fffff097          	auipc	ra,0xfffff
    80001ec8:	db2080e7          	jalr	-590(ra) # 80000c76 <release>
    80001ecc:	bfe1                	j	80001ea4 <reparent+0x2c>
}
    80001ece:	70a2                	ld	ra,40(sp)
    80001ed0:	7402                	ld	s0,32(sp)
    80001ed2:	64e2                	ld	s1,24(sp)
    80001ed4:	6942                	ld	s2,16(sp)
    80001ed6:	69a2                	ld	s3,8(sp)
    80001ed8:	6a02                	ld	s4,0(sp)
    80001eda:	6145                	addi	sp,sp,48
    80001edc:	8082                	ret

0000000080001ede <scheduler>:
{
    80001ede:	711d                	addi	sp,sp,-96
    80001ee0:	ec86                	sd	ra,88(sp)
    80001ee2:	e8a2                	sd	s0,80(sp)
    80001ee4:	e4a6                	sd	s1,72(sp)
    80001ee6:	e0ca                	sd	s2,64(sp)
    80001ee8:	fc4e                	sd	s3,56(sp)
    80001eea:	f852                	sd	s4,48(sp)
    80001eec:	f456                	sd	s5,40(sp)
    80001eee:	f05a                	sd	s6,32(sp)
    80001ef0:	ec5e                	sd	s7,24(sp)
    80001ef2:	e862                	sd	s8,16(sp)
    80001ef4:	e466                	sd	s9,8(sp)
    80001ef6:	1080                	addi	s0,sp,96
    80001ef8:	8792                	mv	a5,tp
  int id = r_tp();
    80001efa:	2781                	sext.w	a5,a5
  c->proc = 0;
    80001efc:	00779b93          	slli	s7,a5,0x7
    80001f00:	0000f717          	auipc	a4,0xf
    80001f04:	3a070713          	addi	a4,a4,928 # 800112a0 <pid_lock>
    80001f08:	975e                	add	a4,a4,s7
    80001f0a:	00073c23          	sd	zero,24(a4)
        swtch(&c->context, &p->context);
    80001f0e:	0000f717          	auipc	a4,0xf
    80001f12:	3b270713          	addi	a4,a4,946 # 800112c0 <cpus+0x8>
    80001f16:	9bba                	add	s7,s7,a4
    int nproc = 0;
    80001f18:	4c01                	li	s8,0
      if(p->state == RUNNABLE) {
    80001f1a:	4a89                	li	s5,2
        c->proc = p;
    80001f1c:	079e                	slli	a5,a5,0x7
    80001f1e:	0000fb17          	auipc	s6,0xf
    80001f22:	382b0b13          	addi	s6,s6,898 # 800112a0 <pid_lock>
    80001f26:	9b3e                	add	s6,s6,a5
    for(p = proc; p < &proc[NPROC]; p++) {
    80001f28:	00010a17          	auipc	s4,0x10
    80001f2c:	5a0a0a13          	addi	s4,s4,1440 # 800124c8 <tickslock>
    80001f30:	a8a1                	j	80001f88 <scheduler+0xaa>
      release(&p->lock);
    80001f32:	8526                	mv	a0,s1
    80001f34:	fffff097          	auipc	ra,0xfffff
    80001f38:	d42080e7          	jalr	-702(ra) # 80000c76 <release>
    for(p = proc; p < &proc[NPROC]; p++) {
    80001f3c:	16848493          	addi	s1,s1,360
    80001f40:	03448a63          	beq	s1,s4,80001f74 <scheduler+0x96>
      acquire(&p->lock);
    80001f44:	8526                	mv	a0,s1
    80001f46:	fffff097          	auipc	ra,0xfffff
    80001f4a:	c7c080e7          	jalr	-900(ra) # 80000bc2 <acquire>
      if(p->state != UNUSED) {
    80001f4e:	4c9c                	lw	a5,24(s1)
    80001f50:	d3ed                	beqz	a5,80001f32 <scheduler+0x54>
        nproc++;
    80001f52:	2985                	addiw	s3,s3,1
      if(p->state == RUNNABLE) {
    80001f54:	fd579fe3          	bne	a5,s5,80001f32 <scheduler+0x54>
        p->state = RUNNING;
    80001f58:	0194ac23          	sw	s9,24(s1)
        c->proc = p;
    80001f5c:	009b3c23          	sd	s1,24(s6)
        swtch(&c->context, &p->context);
    80001f60:	06048593          	addi	a1,s1,96
    80001f64:	855e                	mv	a0,s7
    80001f66:	00000097          	auipc	ra,0x0
    80001f6a:	60c080e7          	jalr	1548(ra) # 80002572 <swtch>
        c->proc = 0;
    80001f6e:	000b3c23          	sd	zero,24(s6)
    80001f72:	b7c1                	j	80001f32 <scheduler+0x54>
    if(nproc <= 2) {   // only init and sh exist
    80001f74:	013aca63          	blt	s5,s3,80001f88 <scheduler+0xaa>
  asm volatile("csrr %0, sstatus" : "=r" (x) );
    80001f78:	100027f3          	csrr	a5,sstatus
  w_sstatus(r_sstatus() | SSTATUS_SIE);
    80001f7c:	0027e793          	ori	a5,a5,2
  asm volatile("csrw sstatus, %0" : : "r" (x));
    80001f80:	10079073          	csrw	sstatus,a5
      asm volatile("wfi");
    80001f84:	10500073          	wfi
  asm volatile("csrr %0, sstatus" : "=r" (x) );
    80001f88:	100027f3          	csrr	a5,sstatus
  w_sstatus(r_sstatus() | SSTATUS_SIE);
    80001f8c:	0027e793          	ori	a5,a5,2
  asm volatile("csrw sstatus, %0" : : "r" (x));
    80001f90:	10079073          	csrw	sstatus,a5
    int nproc = 0;
    80001f94:	89e2                	mv	s3,s8
    for(p = proc; p < &proc[NPROC]; p++) {
    80001f96:	0000f497          	auipc	s1,0xf
    80001f9a:	72248493          	addi	s1,s1,1826 # 800116b8 <proc>
        p->state = RUNNING;
    80001f9e:	4c8d                	li	s9,3
    80001fa0:	b755                	j	80001f44 <scheduler+0x66>

0000000080001fa2 <sched>:
{
    80001fa2:	7179                	addi	sp,sp,-48
    80001fa4:	f406                	sd	ra,40(sp)
    80001fa6:	f022                	sd	s0,32(sp)
    80001fa8:	ec26                	sd	s1,24(sp)
    80001faa:	e84a                	sd	s2,16(sp)
    80001fac:	e44e                	sd	s3,8(sp)
    80001fae:	1800                	addi	s0,sp,48
  struct proc *p = myproc();
    80001fb0:	00000097          	auipc	ra,0x0
    80001fb4:	9fa080e7          	jalr	-1542(ra) # 800019aa <myproc>
    80001fb8:	84aa                	mv	s1,a0
  if(!holding(&p->lock))
    80001fba:	fffff097          	auipc	ra,0xfffff
    80001fbe:	b8e080e7          	jalr	-1138(ra) # 80000b48 <holding>
    80001fc2:	c93d                	beqz	a0,80002038 <sched+0x96>
  asm volatile("mv %0, tp" : "=r" (x) );
    80001fc4:	8792                	mv	a5,tp
  if(mycpu()->noff != 1)
    80001fc6:	2781                	sext.w	a5,a5
    80001fc8:	079e                	slli	a5,a5,0x7
    80001fca:	0000f717          	auipc	a4,0xf
    80001fce:	2d670713          	addi	a4,a4,726 # 800112a0 <pid_lock>
    80001fd2:	97ba                	add	a5,a5,a4
    80001fd4:	0907a703          	lw	a4,144(a5)
    80001fd8:	4785                	li	a5,1
    80001fda:	06f71763          	bne	a4,a5,80002048 <sched+0xa6>
  if(p->state == RUNNING)
    80001fde:	4c98                	lw	a4,24(s1)
    80001fe0:	478d                	li	a5,3
    80001fe2:	06f70b63          	beq	a4,a5,80002058 <sched+0xb6>
  asm volatile("csrr %0, sstatus" : "=r" (x) );
    80001fe6:	100027f3          	csrr	a5,sstatus
  return (x & SSTATUS_SIE) != 0;
    80001fea:	8b89                	andi	a5,a5,2
  if(intr_get())
    80001fec:	efb5                	bnez	a5,80002068 <sched+0xc6>
  asm volatile("mv %0, tp" : "=r" (x) );
    80001fee:	8792                	mv	a5,tp
  intena = mycpu()->intena;
    80001ff0:	0000f917          	auipc	s2,0xf
    80001ff4:	2b090913          	addi	s2,s2,688 # 800112a0 <pid_lock>
    80001ff8:	2781                	sext.w	a5,a5
    80001ffa:	079e                	slli	a5,a5,0x7
    80001ffc:	97ca                	add	a5,a5,s2
    80001ffe:	0947a983          	lw	s3,148(a5)
    80002002:	8792                	mv	a5,tp
  swtch(&p->context, &mycpu()->context);
    80002004:	2781                	sext.w	a5,a5
    80002006:	079e                	slli	a5,a5,0x7
    80002008:	0000f597          	auipc	a1,0xf
    8000200c:	2b858593          	addi	a1,a1,696 # 800112c0 <cpus+0x8>
    80002010:	95be                	add	a1,a1,a5
    80002012:	06048513          	addi	a0,s1,96
    80002016:	00000097          	auipc	ra,0x0
    8000201a:	55c080e7          	jalr	1372(ra) # 80002572 <swtch>
    8000201e:	8792                	mv	a5,tp
  mycpu()->intena = intena;
    80002020:	2781                	sext.w	a5,a5
    80002022:	079e                	slli	a5,a5,0x7
    80002024:	97ca                	add	a5,a5,s2
    80002026:	0937aa23          	sw	s3,148(a5)
}
    8000202a:	70a2                	ld	ra,40(sp)
    8000202c:	7402                	ld	s0,32(sp)
    8000202e:	64e2                	ld	s1,24(sp)
    80002030:	6942                	ld	s2,16(sp)
    80002032:	69a2                	ld	s3,8(sp)
    80002034:	6145                	addi	sp,sp,48
    80002036:	8082                	ret
    panic("sched p->lock");
    80002038:	00006517          	auipc	a0,0x6
    8000203c:	1c050513          	addi	a0,a0,448 # 800081f8 <digits+0x1b8>
    80002040:	ffffe097          	auipc	ra,0xffffe
    80002044:	4ea080e7          	jalr	1258(ra) # 8000052a <panic>
    panic("sched locks");
    80002048:	00006517          	auipc	a0,0x6
    8000204c:	1c050513          	addi	a0,a0,448 # 80008208 <digits+0x1c8>
    80002050:	ffffe097          	auipc	ra,0xffffe
    80002054:	4da080e7          	jalr	1242(ra) # 8000052a <panic>
    panic("sched running");
    80002058:	00006517          	auipc	a0,0x6
    8000205c:	1c050513          	addi	a0,a0,448 # 80008218 <digits+0x1d8>
    80002060:	ffffe097          	auipc	ra,0xffffe
    80002064:	4ca080e7          	jalr	1226(ra) # 8000052a <panic>
    panic("sched interruptible");
    80002068:	00006517          	auipc	a0,0x6
    8000206c:	1c050513          	addi	a0,a0,448 # 80008228 <digits+0x1e8>
    80002070:	ffffe097          	auipc	ra,0xffffe
    80002074:	4ba080e7          	jalr	1210(ra) # 8000052a <panic>

0000000080002078 <exit>:
{
    80002078:	7179                	addi	sp,sp,-48
    8000207a:	f406                	sd	ra,40(sp)
    8000207c:	f022                	sd	s0,32(sp)
    8000207e:	ec26                	sd	s1,24(sp)
    80002080:	e84a                	sd	s2,16(sp)
    80002082:	e44e                	sd	s3,8(sp)
    80002084:	e052                	sd	s4,0(sp)
    80002086:	1800                	addi	s0,sp,48
    80002088:	8a2a                	mv	s4,a0
  struct proc *p = myproc();
    8000208a:	00000097          	auipc	ra,0x0
    8000208e:	920080e7          	jalr	-1760(ra) # 800019aa <myproc>
    80002092:	89aa                	mv	s3,a0
  if(p == initproc)
    80002094:	00007797          	auipc	a5,0x7
    80002098:	f947b783          	ld	a5,-108(a5) # 80009028 <initproc>
    8000209c:	0d050493          	addi	s1,a0,208
    800020a0:	15050913          	addi	s2,a0,336
    800020a4:	02a79363          	bne	a5,a0,800020ca <exit+0x52>
    panic("init exiting");
    800020a8:	00006517          	auipc	a0,0x6
    800020ac:	19850513          	addi	a0,a0,408 # 80008240 <digits+0x200>
    800020b0:	ffffe097          	auipc	ra,0xffffe
    800020b4:	47a080e7          	jalr	1146(ra) # 8000052a <panic>
      fileclose(f);
    800020b8:	00002097          	auipc	ra,0x2
    800020bc:	534080e7          	jalr	1332(ra) # 800045ec <fileclose>
      p->ofile[fd] = 0;
    800020c0:	0004b023          	sd	zero,0(s1)
  for(int fd = 0; fd < NOFILE; fd++){
    800020c4:	04a1                	addi	s1,s1,8
    800020c6:	01248563          	beq	s1,s2,800020d0 <exit+0x58>
    if(p->ofile[fd]){
    800020ca:	6088                	ld	a0,0(s1)
    800020cc:	f575                	bnez	a0,800020b8 <exit+0x40>
    800020ce:	bfdd                	j	800020c4 <exit+0x4c>
  begin_op();
    800020d0:	00002097          	auipc	ra,0x2
    800020d4:	048080e7          	jalr	72(ra) # 80004118 <begin_op>
  iput(p->cwd);
    800020d8:	1509b503          	ld	a0,336(s3)
    800020dc:	00002097          	auipc	ra,0x2
    800020e0:	822080e7          	jalr	-2014(ra) # 800038fe <iput>
  end_op();
    800020e4:	00002097          	auipc	ra,0x2
    800020e8:	0b4080e7          	jalr	180(ra) # 80004198 <end_op>
  p->cwd = 0;
    800020ec:	1409b823          	sd	zero,336(s3)
  acquire(&initproc->lock);
    800020f0:	00007497          	auipc	s1,0x7
    800020f4:	f3848493          	addi	s1,s1,-200 # 80009028 <initproc>
    800020f8:	6088                	ld	a0,0(s1)
    800020fa:	fffff097          	auipc	ra,0xfffff
    800020fe:	ac8080e7          	jalr	-1336(ra) # 80000bc2 <acquire>
  wakeup1(initproc);
    80002102:	6088                	ld	a0,0(s1)
    80002104:	fffff097          	auipc	ra,0xfffff
    80002108:	708080e7          	jalr	1800(ra) # 8000180c <wakeup1>
  release(&initproc->lock);
    8000210c:	6088                	ld	a0,0(s1)
    8000210e:	fffff097          	auipc	ra,0xfffff
    80002112:	b68080e7          	jalr	-1176(ra) # 80000c76 <release>
  acquire(&p->lock);
    80002116:	854e                	mv	a0,s3
    80002118:	fffff097          	auipc	ra,0xfffff
    8000211c:	aaa080e7          	jalr	-1366(ra) # 80000bc2 <acquire>
  struct proc *original_parent = p->parent;
    80002120:	0209b483          	ld	s1,32(s3)
  release(&p->lock);
    80002124:	854e                	mv	a0,s3
    80002126:	fffff097          	auipc	ra,0xfffff
    8000212a:	b50080e7          	jalr	-1200(ra) # 80000c76 <release>
  acquire(&original_parent->lock);
    8000212e:	8526                	mv	a0,s1
    80002130:	fffff097          	auipc	ra,0xfffff
    80002134:	a92080e7          	jalr	-1390(ra) # 80000bc2 <acquire>
  acquire(&p->lock);
    80002138:	854e                	mv	a0,s3
    8000213a:	fffff097          	auipc	ra,0xfffff
    8000213e:	a88080e7          	jalr	-1400(ra) # 80000bc2 <acquire>
  reparent(p);
    80002142:	854e                	mv	a0,s3
    80002144:	00000097          	auipc	ra,0x0
    80002148:	d34080e7          	jalr	-716(ra) # 80001e78 <reparent>
  wakeup1(original_parent);
    8000214c:	8526                	mv	a0,s1
    8000214e:	fffff097          	auipc	ra,0xfffff
    80002152:	6be080e7          	jalr	1726(ra) # 8000180c <wakeup1>
  p->xstate = status;
    80002156:	0349aa23          	sw	s4,52(s3)
  p->state = ZOMBIE;
    8000215a:	4791                	li	a5,4
    8000215c:	00f9ac23          	sw	a5,24(s3)
  release(&original_parent->lock);
    80002160:	8526                	mv	a0,s1
    80002162:	fffff097          	auipc	ra,0xfffff
    80002166:	b14080e7          	jalr	-1260(ra) # 80000c76 <release>
  sched();
    8000216a:	00000097          	auipc	ra,0x0
    8000216e:	e38080e7          	jalr	-456(ra) # 80001fa2 <sched>
  panic("zombie exit");
    80002172:	00006517          	auipc	a0,0x6
    80002176:	0de50513          	addi	a0,a0,222 # 80008250 <digits+0x210>
    8000217a:	ffffe097          	auipc	ra,0xffffe
    8000217e:	3b0080e7          	jalr	944(ra) # 8000052a <panic>

0000000080002182 <yield>:
{
    80002182:	1101                	addi	sp,sp,-32
    80002184:	ec06                	sd	ra,24(sp)
    80002186:	e822                	sd	s0,16(sp)
    80002188:	e426                	sd	s1,8(sp)
    8000218a:	1000                	addi	s0,sp,32
  struct proc *p = myproc();
    8000218c:	00000097          	auipc	ra,0x0
    80002190:	81e080e7          	jalr	-2018(ra) # 800019aa <myproc>
    80002194:	84aa                	mv	s1,a0
  acquire(&p->lock);
    80002196:	fffff097          	auipc	ra,0xfffff
    8000219a:	a2c080e7          	jalr	-1492(ra) # 80000bc2 <acquire>
  p->state = RUNNABLE;
    8000219e:	4789                	li	a5,2
    800021a0:	cc9c                	sw	a5,24(s1)
  sched();
    800021a2:	00000097          	auipc	ra,0x0
    800021a6:	e00080e7          	jalr	-512(ra) # 80001fa2 <sched>
  release(&p->lock);
    800021aa:	8526                	mv	a0,s1
    800021ac:	fffff097          	auipc	ra,0xfffff
    800021b0:	aca080e7          	jalr	-1334(ra) # 80000c76 <release>
}
    800021b4:	60e2                	ld	ra,24(sp)
    800021b6:	6442                	ld	s0,16(sp)
    800021b8:	64a2                	ld	s1,8(sp)
    800021ba:	6105                	addi	sp,sp,32
    800021bc:	8082                	ret

00000000800021be <sleep>:
{
    800021be:	7179                	addi	sp,sp,-48
    800021c0:	f406                	sd	ra,40(sp)
    800021c2:	f022                	sd	s0,32(sp)
    800021c4:	ec26                	sd	s1,24(sp)
    800021c6:	e84a                	sd	s2,16(sp)
    800021c8:	e44e                	sd	s3,8(sp)
    800021ca:	1800                	addi	s0,sp,48
    800021cc:	89aa                	mv	s3,a0
    800021ce:	892e                	mv	s2,a1
  struct proc *p = myproc();
    800021d0:	fffff097          	auipc	ra,0xfffff
    800021d4:	7da080e7          	jalr	2010(ra) # 800019aa <myproc>
    800021d8:	84aa                	mv	s1,a0
  if(lk != &p->lock){  //DOC: sleeplock0
    800021da:	05250663          	beq	a0,s2,80002226 <sleep+0x68>
    acquire(&p->lock);  //DOC: sleeplock1
    800021de:	fffff097          	auipc	ra,0xfffff
    800021e2:	9e4080e7          	jalr	-1564(ra) # 80000bc2 <acquire>
    release(lk);
    800021e6:	854a                	mv	a0,s2
    800021e8:	fffff097          	auipc	ra,0xfffff
    800021ec:	a8e080e7          	jalr	-1394(ra) # 80000c76 <release>
  p->chan = chan;
    800021f0:	0334b423          	sd	s3,40(s1)
  p->state = SLEEPING;
    800021f4:	4785                	li	a5,1
    800021f6:	cc9c                	sw	a5,24(s1)
  sched();
    800021f8:	00000097          	auipc	ra,0x0
    800021fc:	daa080e7          	jalr	-598(ra) # 80001fa2 <sched>
  p->chan = 0;
    80002200:	0204b423          	sd	zero,40(s1)
    release(&p->lock);
    80002204:	8526                	mv	a0,s1
    80002206:	fffff097          	auipc	ra,0xfffff
    8000220a:	a70080e7          	jalr	-1424(ra) # 80000c76 <release>
    acquire(lk);
    8000220e:	854a                	mv	a0,s2
    80002210:	fffff097          	auipc	ra,0xfffff
    80002214:	9b2080e7          	jalr	-1614(ra) # 80000bc2 <acquire>
}
    80002218:	70a2                	ld	ra,40(sp)
    8000221a:	7402                	ld	s0,32(sp)
    8000221c:	64e2                	ld	s1,24(sp)
    8000221e:	6942                	ld	s2,16(sp)
    80002220:	69a2                	ld	s3,8(sp)
    80002222:	6145                	addi	sp,sp,48
    80002224:	8082                	ret
  p->chan = chan;
    80002226:	03353423          	sd	s3,40(a0)
  p->state = SLEEPING;
    8000222a:	4785                	li	a5,1
    8000222c:	cd1c                	sw	a5,24(a0)
  sched();
    8000222e:	00000097          	auipc	ra,0x0
    80002232:	d74080e7          	jalr	-652(ra) # 80001fa2 <sched>
  p->chan = 0;
    80002236:	0204b423          	sd	zero,40(s1)
  if(lk != &p->lock){
    8000223a:	bff9                	j	80002218 <sleep+0x5a>

000000008000223c <wait>:
{
    8000223c:	715d                	addi	sp,sp,-80
    8000223e:	e486                	sd	ra,72(sp)
    80002240:	e0a2                	sd	s0,64(sp)
    80002242:	fc26                	sd	s1,56(sp)
    80002244:	f84a                	sd	s2,48(sp)
    80002246:	f44e                	sd	s3,40(sp)
    80002248:	f052                	sd	s4,32(sp)
    8000224a:	ec56                	sd	s5,24(sp)
    8000224c:	e85a                	sd	s6,16(sp)
    8000224e:	e45e                	sd	s7,8(sp)
    80002250:	0880                	addi	s0,sp,80
    80002252:	8aaa                	mv	s5,a0
  struct proc *p = myproc();
    80002254:	fffff097          	auipc	ra,0xfffff
    80002258:	756080e7          	jalr	1878(ra) # 800019aa <myproc>
    8000225c:	892a                	mv	s2,a0
  acquire(&p->lock);
    8000225e:	fffff097          	auipc	ra,0xfffff
    80002262:	964080e7          	jalr	-1692(ra) # 80000bc2 <acquire>
    havekids = 0;
    80002266:	4b81                	li	s7,0
        if(np->state == ZOMBIE){
    80002268:	4a11                	li	s4,4
        havekids = 1;
    8000226a:	4b05                	li	s6,1
    for(np = proc; np < &proc[NPROC]; np++){
    8000226c:	00010997          	auipc	s3,0x10
    80002270:	25c98993          	addi	s3,s3,604 # 800124c8 <tickslock>
    havekids = 0;
    80002274:	875e                	mv	a4,s7
    for(np = proc; np < &proc[NPROC]; np++){
    80002276:	0000f497          	auipc	s1,0xf
    8000227a:	44248493          	addi	s1,s1,1090 # 800116b8 <proc>
    8000227e:	a08d                	j	800022e0 <wait+0xa4>
          pid = np->pid;
    80002280:	0384a983          	lw	s3,56(s1)
          if(addr != 0 && copyout(p->pagetable, addr, (char *)&np->xstate,
    80002284:	000a8e63          	beqz	s5,800022a0 <wait+0x64>
    80002288:	4691                	li	a3,4
    8000228a:	03448613          	addi	a2,s1,52
    8000228e:	85d6                	mv	a1,s5
    80002290:	05093503          	ld	a0,80(s2)
    80002294:	fffff097          	auipc	ra,0xfffff
    80002298:	3aa080e7          	jalr	938(ra) # 8000163e <copyout>
    8000229c:	02054263          	bltz	a0,800022c0 <wait+0x84>
          freeproc(np);
    800022a0:	8526                	mv	a0,s1
    800022a2:	00000097          	auipc	ra,0x0
    800022a6:	8ba080e7          	jalr	-1862(ra) # 80001b5c <freeproc>
          release(&np->lock);
    800022aa:	8526                	mv	a0,s1
    800022ac:	fffff097          	auipc	ra,0xfffff
    800022b0:	9ca080e7          	jalr	-1590(ra) # 80000c76 <release>
          release(&p->lock);
    800022b4:	854a                	mv	a0,s2
    800022b6:	fffff097          	auipc	ra,0xfffff
    800022ba:	9c0080e7          	jalr	-1600(ra) # 80000c76 <release>
          return pid;
    800022be:	a8a9                	j	80002318 <wait+0xdc>
            release(&np->lock);
    800022c0:	8526                	mv	a0,s1
    800022c2:	fffff097          	auipc	ra,0xfffff
    800022c6:	9b4080e7          	jalr	-1612(ra) # 80000c76 <release>
            release(&p->lock);
    800022ca:	854a                	mv	a0,s2
    800022cc:	fffff097          	auipc	ra,0xfffff
    800022d0:	9aa080e7          	jalr	-1622(ra) # 80000c76 <release>
            return -1;
    800022d4:	59fd                	li	s3,-1
    800022d6:	a089                	j	80002318 <wait+0xdc>
    for(np = proc; np < &proc[NPROC]; np++){
    800022d8:	16848493          	addi	s1,s1,360
    800022dc:	03348463          	beq	s1,s3,80002304 <wait+0xc8>
      if(np->parent == p){
    800022e0:	709c                	ld	a5,32(s1)
    800022e2:	ff279be3          	bne	a5,s2,800022d8 <wait+0x9c>
        acquire(&np->lock);
    800022e6:	8526                	mv	a0,s1
    800022e8:	fffff097          	auipc	ra,0xfffff
    800022ec:	8da080e7          	jalr	-1830(ra) # 80000bc2 <acquire>
        if(np->state == ZOMBIE){
    800022f0:	4c9c                	lw	a5,24(s1)
    800022f2:	f94787e3          	beq	a5,s4,80002280 <wait+0x44>
        release(&np->lock);
    800022f6:	8526                	mv	a0,s1
    800022f8:	fffff097          	auipc	ra,0xfffff
    800022fc:	97e080e7          	jalr	-1666(ra) # 80000c76 <release>
        havekids = 1;
    80002300:	875a                	mv	a4,s6
    80002302:	bfd9                	j	800022d8 <wait+0x9c>
    if(!havekids || p->killed){
    80002304:	c701                	beqz	a4,8000230c <wait+0xd0>
    80002306:	03092783          	lw	a5,48(s2)
    8000230a:	c39d                	beqz	a5,80002330 <wait+0xf4>
      release(&p->lock);
    8000230c:	854a                	mv	a0,s2
    8000230e:	fffff097          	auipc	ra,0xfffff
    80002312:	968080e7          	jalr	-1688(ra) # 80000c76 <release>
      return -1;
    80002316:	59fd                	li	s3,-1
}
    80002318:	854e                	mv	a0,s3
    8000231a:	60a6                	ld	ra,72(sp)
    8000231c:	6406                	ld	s0,64(sp)
    8000231e:	74e2                	ld	s1,56(sp)
    80002320:	7942                	ld	s2,48(sp)
    80002322:	79a2                	ld	s3,40(sp)
    80002324:	7a02                	ld	s4,32(sp)
    80002326:	6ae2                	ld	s5,24(sp)
    80002328:	6b42                	ld	s6,16(sp)
    8000232a:	6ba2                	ld	s7,8(sp)
    8000232c:	6161                	addi	sp,sp,80
    8000232e:	8082                	ret
    sleep(p, &p->lock);  //DOC: wait-sleep
    80002330:	85ca                	mv	a1,s2
    80002332:	854a                	mv	a0,s2
    80002334:	00000097          	auipc	ra,0x0
    80002338:	e8a080e7          	jalr	-374(ra) # 800021be <sleep>
    havekids = 0;
    8000233c:	bf25                	j	80002274 <wait+0x38>

000000008000233e <wakeup>:
{
    8000233e:	7139                	addi	sp,sp,-64
    80002340:	fc06                	sd	ra,56(sp)
    80002342:	f822                	sd	s0,48(sp)
    80002344:	f426                	sd	s1,40(sp)
    80002346:	f04a                	sd	s2,32(sp)
    80002348:	ec4e                	sd	s3,24(sp)
    8000234a:	e852                	sd	s4,16(sp)
    8000234c:	e456                	sd	s5,8(sp)
    8000234e:	0080                	addi	s0,sp,64
    80002350:	8a2a                	mv	s4,a0
  for(p = proc; p < &proc[NPROC]; p++) {
    80002352:	0000f497          	auipc	s1,0xf
    80002356:	36648493          	addi	s1,s1,870 # 800116b8 <proc>
    if(p->state == SLEEPING && p->chan == chan) {
    8000235a:	4985                	li	s3,1
      p->state = RUNNABLE;
    8000235c:	4a89                	li	s5,2
  for(p = proc; p < &proc[NPROC]; p++) {
    8000235e:	00010917          	auipc	s2,0x10
    80002362:	16a90913          	addi	s2,s2,362 # 800124c8 <tickslock>
    80002366:	a811                	j	8000237a <wakeup+0x3c>
    release(&p->lock);
    80002368:	8526                	mv	a0,s1
    8000236a:	fffff097          	auipc	ra,0xfffff
    8000236e:	90c080e7          	jalr	-1780(ra) # 80000c76 <release>
  for(p = proc; p < &proc[NPROC]; p++) {
    80002372:	16848493          	addi	s1,s1,360
    80002376:	03248063          	beq	s1,s2,80002396 <wakeup+0x58>
    acquire(&p->lock);
    8000237a:	8526                	mv	a0,s1
    8000237c:	fffff097          	auipc	ra,0xfffff
    80002380:	846080e7          	jalr	-1978(ra) # 80000bc2 <acquire>
    if(p->state == SLEEPING && p->chan == chan) {
    80002384:	4c9c                	lw	a5,24(s1)
    80002386:	ff3791e3          	bne	a5,s3,80002368 <wakeup+0x2a>
    8000238a:	749c                	ld	a5,40(s1)
    8000238c:	fd479ee3          	bne	a5,s4,80002368 <wakeup+0x2a>
      p->state = RUNNABLE;
    80002390:	0154ac23          	sw	s5,24(s1)
    80002394:	bfd1                	j	80002368 <wakeup+0x2a>
}
    80002396:	70e2                	ld	ra,56(sp)
    80002398:	7442                	ld	s0,48(sp)
    8000239a:	74a2                	ld	s1,40(sp)
    8000239c:	7902                	ld	s2,32(sp)
    8000239e:	69e2                	ld	s3,24(sp)
    800023a0:	6a42                	ld	s4,16(sp)
    800023a2:	6aa2                	ld	s5,8(sp)
    800023a4:	6121                	addi	sp,sp,64
    800023a6:	8082                	ret

00000000800023a8 <kill>:
// Kill the process with the given pid.
// The victim won't exit until it tries to return
// to user space (see usertrap() in trap.c).
int
kill(int pid)
{
    800023a8:	7179                	addi	sp,sp,-48
    800023aa:	f406                	sd	ra,40(sp)
    800023ac:	f022                	sd	s0,32(sp)
    800023ae:	ec26                	sd	s1,24(sp)
    800023b0:	e84a                	sd	s2,16(sp)
    800023b2:	e44e                	sd	s3,8(sp)
    800023b4:	1800                	addi	s0,sp,48
    800023b6:	892a                	mv	s2,a0
  struct proc *p;

  for(p = proc; p < &proc[NPROC]; p++){
    800023b8:	0000f497          	auipc	s1,0xf
    800023bc:	30048493          	addi	s1,s1,768 # 800116b8 <proc>
    800023c0:	00010997          	auipc	s3,0x10
    800023c4:	10898993          	addi	s3,s3,264 # 800124c8 <tickslock>
    acquire(&p->lock);
    800023c8:	8526                	mv	a0,s1
    800023ca:	ffffe097          	auipc	ra,0xffffe
    800023ce:	7f8080e7          	jalr	2040(ra) # 80000bc2 <acquire>
    if(p->pid == pid){
    800023d2:	5c9c                	lw	a5,56(s1)
    800023d4:	03278363          	beq	a5,s2,800023fa <kill+0x52>
        p->state = RUNNABLE;
      }
      release(&p->lock);
      return 0;
    }
    release(&p->lock);
    800023d8:	8526                	mv	a0,s1
    800023da:	fffff097          	auipc	ra,0xfffff
    800023de:	89c080e7          	jalr	-1892(ra) # 80000c76 <release>
  for(p = proc; p < &proc[NPROC]; p++){
    800023e2:	16848493          	addi	s1,s1,360
    800023e6:	ff3491e3          	bne	s1,s3,800023c8 <kill+0x20>
  }
  return -1;
    800023ea:	557d                	li	a0,-1
}
    800023ec:	70a2                	ld	ra,40(sp)
    800023ee:	7402                	ld	s0,32(sp)
    800023f0:	64e2                	ld	s1,24(sp)
    800023f2:	6942                	ld	s2,16(sp)
    800023f4:	69a2                	ld	s3,8(sp)
    800023f6:	6145                	addi	sp,sp,48
    800023f8:	8082                	ret
      p->killed = 1;
    800023fa:	4785                	li	a5,1
    800023fc:	d89c                	sw	a5,48(s1)
      if(p->state == SLEEPING){
    800023fe:	4c98                	lw	a4,24(s1)
    80002400:	00f70963          	beq	a4,a5,80002412 <kill+0x6a>
      release(&p->lock);
    80002404:	8526                	mv	a0,s1
    80002406:	fffff097          	auipc	ra,0xfffff
    8000240a:	870080e7          	jalr	-1936(ra) # 80000c76 <release>
      return 0;
    8000240e:	4501                	li	a0,0
    80002410:	bff1                	j	800023ec <kill+0x44>
        p->state = RUNNABLE;
    80002412:	4789                	li	a5,2
    80002414:	cc9c                	sw	a5,24(s1)
    80002416:	b7fd                	j	80002404 <kill+0x5c>

0000000080002418 <either_copyout>:
// Copy to either a user address, or kernel address,
// depending on usr_dst.
// Returns 0 on success, -1 on error.
int
either_copyout(int user_dst, uint64 dst, void *src, uint64 len)
{
    80002418:	7179                	addi	sp,sp,-48
    8000241a:	f406                	sd	ra,40(sp)
    8000241c:	f022                	sd	s0,32(sp)
    8000241e:	ec26                	sd	s1,24(sp)
    80002420:	e84a                	sd	s2,16(sp)
    80002422:	e44e                	sd	s3,8(sp)
    80002424:	e052                	sd	s4,0(sp)
    80002426:	1800                	addi	s0,sp,48
    80002428:	84aa                	mv	s1,a0
    8000242a:	892e                	mv	s2,a1
    8000242c:	89b2                	mv	s3,a2
    8000242e:	8a36                	mv	s4,a3
  struct proc *p = myproc();
    80002430:	fffff097          	auipc	ra,0xfffff
    80002434:	57a080e7          	jalr	1402(ra) # 800019aa <myproc>
  if(user_dst){
    80002438:	c08d                	beqz	s1,8000245a <either_copyout+0x42>
    return copyout(p->pagetable, dst, src, len);
    8000243a:	86d2                	mv	a3,s4
    8000243c:	864e                	mv	a2,s3
    8000243e:	85ca                	mv	a1,s2
    80002440:	6928                	ld	a0,80(a0)
    80002442:	fffff097          	auipc	ra,0xfffff
    80002446:	1fc080e7          	jalr	508(ra) # 8000163e <copyout>
  } else {
    memmove((char *)dst, src, len);
    return 0;
  }
}
    8000244a:	70a2                	ld	ra,40(sp)
    8000244c:	7402                	ld	s0,32(sp)
    8000244e:	64e2                	ld	s1,24(sp)
    80002450:	6942                	ld	s2,16(sp)
    80002452:	69a2                	ld	s3,8(sp)
    80002454:	6a02                	ld	s4,0(sp)
    80002456:	6145                	addi	sp,sp,48
    80002458:	8082                	ret
    memmove((char *)dst, src, len);
    8000245a:	000a061b          	sext.w	a2,s4
    8000245e:	85ce                	mv	a1,s3
    80002460:	854a                	mv	a0,s2
    80002462:	fffff097          	auipc	ra,0xfffff
    80002466:	8b8080e7          	jalr	-1864(ra) # 80000d1a <memmove>
    return 0;
    8000246a:	8526                	mv	a0,s1
    8000246c:	bff9                	j	8000244a <either_copyout+0x32>

000000008000246e <either_copyin>:
// Copy from either a user address, or kernel address,
// depending on usr_src.
// Returns 0 on success, -1 on error.
int
either_copyin(void *dst, int user_src, uint64 src, uint64 len)
{
    8000246e:	7179                	addi	sp,sp,-48
    80002470:	f406                	sd	ra,40(sp)
    80002472:	f022                	sd	s0,32(sp)
    80002474:	ec26                	sd	s1,24(sp)
    80002476:	e84a                	sd	s2,16(sp)
    80002478:	e44e                	sd	s3,8(sp)
    8000247a:	e052                	sd	s4,0(sp)
    8000247c:	1800                	addi	s0,sp,48
    8000247e:	892a                	mv	s2,a0
    80002480:	84ae                	mv	s1,a1
    80002482:	89b2                	mv	s3,a2
    80002484:	8a36                	mv	s4,a3
  struct proc *p = myproc();
    80002486:	fffff097          	auipc	ra,0xfffff
    8000248a:	524080e7          	jalr	1316(ra) # 800019aa <myproc>
  if(user_src){
    8000248e:	c08d                	beqz	s1,800024b0 <either_copyin+0x42>
    return copyin(p->pagetable, dst, src, len);
    80002490:	86d2                	mv	a3,s4
    80002492:	864e                	mv	a2,s3
    80002494:	85ca                	mv	a1,s2
    80002496:	6928                	ld	a0,80(a0)
    80002498:	fffff097          	auipc	ra,0xfffff
    8000249c:	232080e7          	jalr	562(ra) # 800016ca <copyin>
  } else {
    memmove(dst, (char*)src, len);
    return 0;
  }
}
    800024a0:	70a2                	ld	ra,40(sp)
    800024a2:	7402                	ld	s0,32(sp)
    800024a4:	64e2                	ld	s1,24(sp)
    800024a6:	6942                	ld	s2,16(sp)
    800024a8:	69a2                	ld	s3,8(sp)
    800024aa:	6a02                	ld	s4,0(sp)
    800024ac:	6145                	addi	sp,sp,48
    800024ae:	8082                	ret
    memmove(dst, (char*)src, len);
    800024b0:	000a061b          	sext.w	a2,s4
    800024b4:	85ce                	mv	a1,s3
    800024b6:	854a                	mv	a0,s2
    800024b8:	fffff097          	auipc	ra,0xfffff
    800024bc:	862080e7          	jalr	-1950(ra) # 80000d1a <memmove>
    return 0;
    800024c0:	8526                	mv	a0,s1
    800024c2:	bff9                	j	800024a0 <either_copyin+0x32>

00000000800024c4 <procdump>:
// Print a process listing to console.  For debugging.
// Runs when user types ^P on console.
// No lock to avoid wedging a stuck machine further.
void
procdump(void)
{
    800024c4:	715d                	addi	sp,sp,-80
    800024c6:	e486                	sd	ra,72(sp)
    800024c8:	e0a2                	sd	s0,64(sp)
    800024ca:	fc26                	sd	s1,56(sp)
    800024cc:	f84a                	sd	s2,48(sp)
    800024ce:	f44e                	sd	s3,40(sp)
    800024d0:	f052                	sd	s4,32(sp)
    800024d2:	ec56                	sd	s5,24(sp)
    800024d4:	e85a                	sd	s6,16(sp)
    800024d6:	e45e                	sd	s7,8(sp)
    800024d8:	0880                	addi	s0,sp,80
  [ZOMBIE]    "zombie"
  };
  struct proc *p;
  char *state;

  printf("\n");
    800024da:	00006517          	auipc	a0,0x6
    800024de:	bee50513          	addi	a0,a0,-1042 # 800080c8 <digits+0x88>
    800024e2:	ffffe097          	auipc	ra,0xffffe
    800024e6:	092080e7          	jalr	146(ra) # 80000574 <printf>
  for(p = proc; p < &proc[NPROC]; p++){
    800024ea:	0000f497          	auipc	s1,0xf
    800024ee:	32648493          	addi	s1,s1,806 # 80011810 <proc+0x158>
    800024f2:	00010917          	auipc	s2,0x10
    800024f6:	12e90913          	addi	s2,s2,302 # 80012620 <bcache+0x140>
    if(p->state == UNUSED)
      continue;
    if(p->state >= 0 && p->state < NELEM(states) && states[p->state])
    800024fa:	4b11                	li	s6,4
      state = states[p->state];
    else
      state = "???";
    800024fc:	00006997          	auipc	s3,0x6
    80002500:	d6498993          	addi	s3,s3,-668 # 80008260 <digits+0x220>
    printf("%d %s %s", p->pid, state, p->name);
    80002504:	00006a97          	auipc	s5,0x6
    80002508:	d64a8a93          	addi	s5,s5,-668 # 80008268 <digits+0x228>
    printf("\n");
    8000250c:	00006a17          	auipc	s4,0x6
    80002510:	bbca0a13          	addi	s4,s4,-1092 # 800080c8 <digits+0x88>
    if(p->state >= 0 && p->state < NELEM(states) && states[p->state])
    80002514:	00006b97          	auipc	s7,0x6
    80002518:	d8cb8b93          	addi	s7,s7,-628 # 800082a0 <states.0>
    8000251c:	a00d                	j	8000253e <procdump+0x7a>
    printf("%d %s %s", p->pid, state, p->name);
    8000251e:	ee06a583          	lw	a1,-288(a3)
    80002522:	8556                	mv	a0,s5
    80002524:	ffffe097          	auipc	ra,0xffffe
    80002528:	050080e7          	jalr	80(ra) # 80000574 <printf>
    printf("\n");
    8000252c:	8552                	mv	a0,s4
    8000252e:	ffffe097          	auipc	ra,0xffffe
    80002532:	046080e7          	jalr	70(ra) # 80000574 <printf>
  for(p = proc; p < &proc[NPROC]; p++){
    80002536:	16848493          	addi	s1,s1,360
    8000253a:	03248163          	beq	s1,s2,8000255c <procdump+0x98>
    if(p->state == UNUSED)
    8000253e:	86a6                	mv	a3,s1
    80002540:	ec04a783          	lw	a5,-320(s1)
    80002544:	dbed                	beqz	a5,80002536 <procdump+0x72>
      state = "???";
    80002546:	864e                	mv	a2,s3
    if(p->state >= 0 && p->state < NELEM(states) && states[p->state])
    80002548:	fcfb6be3          	bltu	s6,a5,8000251e <procdump+0x5a>
    8000254c:	1782                	slli	a5,a5,0x20
    8000254e:	9381                	srli	a5,a5,0x20
    80002550:	078e                	slli	a5,a5,0x3
    80002552:	97de                	add	a5,a5,s7
    80002554:	6390                	ld	a2,0(a5)
    80002556:	f661                	bnez	a2,8000251e <procdump+0x5a>
      state = "???";
    80002558:	864e                	mv	a2,s3
    8000255a:	b7d1                	j	8000251e <procdump+0x5a>
  }
}
    8000255c:	60a6                	ld	ra,72(sp)
    8000255e:	6406                	ld	s0,64(sp)
    80002560:	74e2                	ld	s1,56(sp)
    80002562:	7942                	ld	s2,48(sp)
    80002564:	79a2                	ld	s3,40(sp)
    80002566:	7a02                	ld	s4,32(sp)
    80002568:	6ae2                	ld	s5,24(sp)
    8000256a:	6b42                	ld	s6,16(sp)
    8000256c:	6ba2                	ld	s7,8(sp)
    8000256e:	6161                	addi	sp,sp,80
    80002570:	8082                	ret

0000000080002572 <swtch>:
    80002572:	00153023          	sd	ra,0(a0)
    80002576:	00253423          	sd	sp,8(a0)
    8000257a:	e900                	sd	s0,16(a0)
    8000257c:	ed04                	sd	s1,24(a0)
    8000257e:	03253023          	sd	s2,32(a0)
    80002582:	03353423          	sd	s3,40(a0)
    80002586:	03453823          	sd	s4,48(a0)
    8000258a:	03553c23          	sd	s5,56(a0)
    8000258e:	05653023          	sd	s6,64(a0)
    80002592:	05753423          	sd	s7,72(a0)
    80002596:	05853823          	sd	s8,80(a0)
    8000259a:	05953c23          	sd	s9,88(a0)
    8000259e:	07a53023          	sd	s10,96(a0)
    800025a2:	07b53423          	sd	s11,104(a0)
    800025a6:	0005b083          	ld	ra,0(a1)
    800025aa:	0085b103          	ld	sp,8(a1)
    800025ae:	6980                	ld	s0,16(a1)
    800025b0:	6d84                	ld	s1,24(a1)
    800025b2:	0205b903          	ld	s2,32(a1)
    800025b6:	0285b983          	ld	s3,40(a1)
    800025ba:	0305ba03          	ld	s4,48(a1)
    800025be:	0385ba83          	ld	s5,56(a1)
    800025c2:	0405bb03          	ld	s6,64(a1)
    800025c6:	0485bb83          	ld	s7,72(a1)
    800025ca:	0505bc03          	ld	s8,80(a1)
    800025ce:	0585bc83          	ld	s9,88(a1)
    800025d2:	0605bd03          	ld	s10,96(a1)
    800025d6:	0685bd83          	ld	s11,104(a1)
    800025da:	8082                	ret

00000000800025dc <trapinit>:

extern int devintr();

void
trapinit(void)
{
    800025dc:	1141                	addi	sp,sp,-16
    800025de:	e406                	sd	ra,8(sp)
    800025e0:	e022                	sd	s0,0(sp)
    800025e2:	0800                	addi	s0,sp,16
  initlock(&tickslock, "time");
    800025e4:	00006597          	auipc	a1,0x6
    800025e8:	ce458593          	addi	a1,a1,-796 # 800082c8 <states.0+0x28>
    800025ec:	00010517          	auipc	a0,0x10
    800025f0:	edc50513          	addi	a0,a0,-292 # 800124c8 <tickslock>
    800025f4:	ffffe097          	auipc	ra,0xffffe
    800025f8:	53e080e7          	jalr	1342(ra) # 80000b32 <initlock>
}
    800025fc:	60a2                	ld	ra,8(sp)
    800025fe:	6402                	ld	s0,0(sp)
    80002600:	0141                	addi	sp,sp,16
    80002602:	8082                	ret

0000000080002604 <trapinithart>:

// set up to take exceptions and traps while in the kernel.
void
trapinithart(void)
{
    80002604:	1141                	addi	sp,sp,-16
    80002606:	e422                	sd	s0,8(sp)
    80002608:	0800                	addi	s0,sp,16
  asm volatile("csrw stvec, %0" : : "r" (x));
    8000260a:	00003797          	auipc	a5,0x3
    8000260e:	74678793          	addi	a5,a5,1862 # 80005d50 <kernelvec>
    80002612:	10579073          	csrw	stvec,a5
  w_stvec((uint64)kernelvec);
}
    80002616:	6422                	ld	s0,8(sp)
    80002618:	0141                	addi	sp,sp,16
    8000261a:	8082                	ret

000000008000261c <usertrapret>:
//
// return to user space
//
void
usertrapret(void)
{
    8000261c:	1141                	addi	sp,sp,-16
    8000261e:	e406                	sd	ra,8(sp)
    80002620:	e022                	sd	s0,0(sp)
    80002622:	0800                	addi	s0,sp,16
  struct proc *p = myproc();
    80002624:	fffff097          	auipc	ra,0xfffff
    80002628:	386080e7          	jalr	902(ra) # 800019aa <myproc>
  asm volatile("csrr %0, sstatus" : "=r" (x) );
    8000262c:	100027f3          	csrr	a5,sstatus
  w_sstatus(r_sstatus() & ~SSTATUS_SIE);
    80002630:	9bf5                	andi	a5,a5,-3
  asm volatile("csrw sstatus, %0" : : "r" (x));
    80002632:	10079073          	csrw	sstatus,a5
  // kerneltrap() to usertrap(), so turn off interrupts until
  // we're back in user space, where usertrap() is correct.
  intr_off();

  // send syscalls, interrupts, and exceptions to trampoline.S
  w_stvec(TRAMPOLINE + (uservec - trampoline));
    80002636:	00005617          	auipc	a2,0x5
    8000263a:	9ca60613          	addi	a2,a2,-1590 # 80007000 <_trampoline>
    8000263e:	00005697          	auipc	a3,0x5
    80002642:	9c268693          	addi	a3,a3,-1598 # 80007000 <_trampoline>
    80002646:	8e91                	sub	a3,a3,a2
    80002648:	040007b7          	lui	a5,0x4000
    8000264c:	17fd                	addi	a5,a5,-1
    8000264e:	07b2                	slli	a5,a5,0xc
    80002650:	96be                	add	a3,a3,a5
  asm volatile("csrw stvec, %0" : : "r" (x));
    80002652:	10569073          	csrw	stvec,a3

  // set up trapframe values that uservec will need when
  // the process next re-enters the kernel.
  p->trapframe->kernel_satp = r_satp();         // kernel page table
    80002656:	6d38                	ld	a4,88(a0)
  asm volatile("csrr %0, satp" : "=r" (x) );
    80002658:	180026f3          	csrr	a3,satp
    8000265c:	e314                	sd	a3,0(a4)
  p->trapframe->kernel_sp = p->kstack + PGSIZE; // process's kernel stack
    8000265e:	6d38                	ld	a4,88(a0)
    80002660:	6134                	ld	a3,64(a0)
    80002662:	6585                	lui	a1,0x1
    80002664:	96ae                	add	a3,a3,a1
    80002666:	e714                	sd	a3,8(a4)
  p->trapframe->kernel_trap = (uint64)usertrap;
    80002668:	6d38                	ld	a4,88(a0)
    8000266a:	00000697          	auipc	a3,0x0
    8000266e:	13868693          	addi	a3,a3,312 # 800027a2 <usertrap>
    80002672:	eb14                	sd	a3,16(a4)
  p->trapframe->kernel_hartid = r_tp();         // hartid for cpuid()
    80002674:	6d38                	ld	a4,88(a0)
  asm volatile("mv %0, tp" : "=r" (x) );
    80002676:	8692                	mv	a3,tp
    80002678:	f314                	sd	a3,32(a4)
  asm volatile("csrr %0, sstatus" : "=r" (x) );
    8000267a:	100026f3          	csrr	a3,sstatus
  // set up the registers that trampoline.S's sret will use
  // to get to user space.
  
  // set S Previous Privilege mode to User.
  unsigned long x = r_sstatus();
  x &= ~SSTATUS_SPP; // clear SPP to 0 for user mode
    8000267e:	eff6f693          	andi	a3,a3,-257
  x |= SSTATUS_SPIE; // enable interrupts in user mode
    80002682:	0206e693          	ori	a3,a3,32
  asm volatile("csrw sstatus, %0" : : "r" (x));
    80002686:	10069073          	csrw	sstatus,a3
  w_sstatus(x);

  // set S Exception Program Counter to the saved user pc.
  w_sepc(p->trapframe->epc);
    8000268a:	6d38                	ld	a4,88(a0)
  asm volatile("csrw sepc, %0" : : "r" (x));
    8000268c:	6f18                	ld	a4,24(a4)
    8000268e:	14171073          	csrw	sepc,a4

  // tell trampoline.S the user page table to switch to.
  uint64 satp = MAKE_SATP(p->pagetable);
    80002692:	692c                	ld	a1,80(a0)
    80002694:	81b1                	srli	a1,a1,0xc

  // jump to trampoline.S at the top of memory, which 
  // switches to the user page table, restores user registers,
  // and switches to user mode with sret.
  uint64 fn = TRAMPOLINE + (userret - trampoline);
    80002696:	00005717          	auipc	a4,0x5
    8000269a:	9fa70713          	addi	a4,a4,-1542 # 80007090 <userret>
    8000269e:	8f11                	sub	a4,a4,a2
    800026a0:	97ba                	add	a5,a5,a4
  ((void (*)(uint64,uint64))fn)(TRAPFRAME, satp);
    800026a2:	577d                	li	a4,-1
    800026a4:	177e                	slli	a4,a4,0x3f
    800026a6:	8dd9                	or	a1,a1,a4
    800026a8:	02000537          	lui	a0,0x2000
    800026ac:	157d                	addi	a0,a0,-1
    800026ae:	0536                	slli	a0,a0,0xd
    800026b0:	9782                	jalr	a5
}
    800026b2:	60a2                	ld	ra,8(sp)
    800026b4:	6402                	ld	s0,0(sp)
    800026b6:	0141                	addi	sp,sp,16
    800026b8:	8082                	ret

00000000800026ba <clockintr>:
  w_sstatus(sstatus);
}

void
clockintr()
{
    800026ba:	1101                	addi	sp,sp,-32
    800026bc:	ec06                	sd	ra,24(sp)
    800026be:	e822                	sd	s0,16(sp)
    800026c0:	e426                	sd	s1,8(sp)
    800026c2:	1000                	addi	s0,sp,32
  acquire(&tickslock);
    800026c4:	00010497          	auipc	s1,0x10
    800026c8:	e0448493          	addi	s1,s1,-508 # 800124c8 <tickslock>
    800026cc:	8526                	mv	a0,s1
    800026ce:	ffffe097          	auipc	ra,0xffffe
    800026d2:	4f4080e7          	jalr	1268(ra) # 80000bc2 <acquire>
  ticks++;
    800026d6:	00007517          	auipc	a0,0x7
    800026da:	95a50513          	addi	a0,a0,-1702 # 80009030 <ticks>
    800026de:	411c                	lw	a5,0(a0)
    800026e0:	2785                	addiw	a5,a5,1
    800026e2:	c11c                	sw	a5,0(a0)
  wakeup(&ticks);
    800026e4:	00000097          	auipc	ra,0x0
    800026e8:	c5a080e7          	jalr	-934(ra) # 8000233e <wakeup>
  release(&tickslock);
    800026ec:	8526                	mv	a0,s1
    800026ee:	ffffe097          	auipc	ra,0xffffe
    800026f2:	588080e7          	jalr	1416(ra) # 80000c76 <release>
}
    800026f6:	60e2                	ld	ra,24(sp)
    800026f8:	6442                	ld	s0,16(sp)
    800026fa:	64a2                	ld	s1,8(sp)
    800026fc:	6105                	addi	sp,sp,32
    800026fe:	8082                	ret

0000000080002700 <devintr>:
// returns 2 if timer interrupt,
// 1 if other device,
// 0 if not recognized.
int
devintr()
{
    80002700:	1101                	addi	sp,sp,-32
    80002702:	ec06                	sd	ra,24(sp)
    80002704:	e822                	sd	s0,16(sp)
    80002706:	e426                	sd	s1,8(sp)
    80002708:	1000                	addi	s0,sp,32
  asm volatile("csrr %0, scause" : "=r" (x) );
    8000270a:	14202773          	csrr	a4,scause
  uint64 scause = r_scause();

  if((scause & 0x8000000000000000L) &&
    8000270e:	00074d63          	bltz	a4,80002728 <devintr+0x28>
    // now allowed to interrupt again.
    if(irq)
      plic_complete(irq);

    return 1;
  } else if(scause == 0x8000000000000001L){
    80002712:	57fd                	li	a5,-1
    80002714:	17fe                	slli	a5,a5,0x3f
    80002716:	0785                	addi	a5,a5,1
    // the SSIP bit in sip.
    w_sip(r_sip() & ~2);

    return 2;
  } else {
    return 0;
    80002718:	4501                	li	a0,0
  } else if(scause == 0x8000000000000001L){
    8000271a:	06f70363          	beq	a4,a5,80002780 <devintr+0x80>
  }
}
    8000271e:	60e2                	ld	ra,24(sp)
    80002720:	6442                	ld	s0,16(sp)
    80002722:	64a2                	ld	s1,8(sp)
    80002724:	6105                	addi	sp,sp,32
    80002726:	8082                	ret
     (scause & 0xff) == 9){
    80002728:	0ff77793          	andi	a5,a4,255
  if((scause & 0x8000000000000000L) &&
    8000272c:	46a5                	li	a3,9
    8000272e:	fed792e3          	bne	a5,a3,80002712 <devintr+0x12>
    int irq = plic_claim();
    80002732:	00003097          	auipc	ra,0x3
    80002736:	726080e7          	jalr	1830(ra) # 80005e58 <plic_claim>
    8000273a:	84aa                	mv	s1,a0
    if(irq == UART0_IRQ){
    8000273c:	47a9                	li	a5,10
    8000273e:	02f50763          	beq	a0,a5,8000276c <devintr+0x6c>
    } else if(irq == VIRTIO0_IRQ){
    80002742:	4785                	li	a5,1
    80002744:	02f50963          	beq	a0,a5,80002776 <devintr+0x76>
    return 1;
    80002748:	4505                	li	a0,1
    } else if(irq){
    8000274a:	d8f1                	beqz	s1,8000271e <devintr+0x1e>
      printf("unexpected interrupt irq=%d\n", irq);
    8000274c:	85a6                	mv	a1,s1
    8000274e:	00006517          	auipc	a0,0x6
    80002752:	b8250513          	addi	a0,a0,-1150 # 800082d0 <states.0+0x30>
    80002756:	ffffe097          	auipc	ra,0xffffe
    8000275a:	e1e080e7          	jalr	-482(ra) # 80000574 <printf>
      plic_complete(irq);
    8000275e:	8526                	mv	a0,s1
    80002760:	00003097          	auipc	ra,0x3
    80002764:	71c080e7          	jalr	1820(ra) # 80005e7c <plic_complete>
    return 1;
    80002768:	4505                	li	a0,1
    8000276a:	bf55                	j	8000271e <devintr+0x1e>
      uartintr();
    8000276c:	ffffe097          	auipc	ra,0xffffe
    80002770:	21a080e7          	jalr	538(ra) # 80000986 <uartintr>
    80002774:	b7ed                	j	8000275e <devintr+0x5e>
      virtio_disk_intr();
    80002776:	00004097          	auipc	ra,0x4
    8000277a:	b98080e7          	jalr	-1128(ra) # 8000630e <virtio_disk_intr>
    8000277e:	b7c5                	j	8000275e <devintr+0x5e>
    if(cpuid() == 0){
    80002780:	fffff097          	auipc	ra,0xfffff
    80002784:	1fe080e7          	jalr	510(ra) # 8000197e <cpuid>
    80002788:	c901                	beqz	a0,80002798 <devintr+0x98>
  asm volatile("csrr %0, sip" : "=r" (x) );
    8000278a:	144027f3          	csrr	a5,sip
    w_sip(r_sip() & ~2);
    8000278e:	9bf5                	andi	a5,a5,-3
  asm volatile("csrw sip, %0" : : "r" (x));
    80002790:	14479073          	csrw	sip,a5
    return 2;
    80002794:	4509                	li	a0,2
    80002796:	b761                	j	8000271e <devintr+0x1e>
      clockintr();
    80002798:	00000097          	auipc	ra,0x0
    8000279c:	f22080e7          	jalr	-222(ra) # 800026ba <clockintr>
    800027a0:	b7ed                	j	8000278a <devintr+0x8a>

00000000800027a2 <usertrap>:
{
    800027a2:	1101                	addi	sp,sp,-32
    800027a4:	ec06                	sd	ra,24(sp)
    800027a6:	e822                	sd	s0,16(sp)
    800027a8:	e426                	sd	s1,8(sp)
    800027aa:	e04a                	sd	s2,0(sp)
    800027ac:	1000                	addi	s0,sp,32
  asm volatile("csrr %0, sstatus" : "=r" (x) );
    800027ae:	100027f3          	csrr	a5,sstatus
  if((r_sstatus() & SSTATUS_SPP) != 0)
    800027b2:	1007f793          	andi	a5,a5,256
    800027b6:	e3ad                	bnez	a5,80002818 <usertrap+0x76>
  asm volatile("csrw stvec, %0" : : "r" (x));
    800027b8:	00003797          	auipc	a5,0x3
    800027bc:	59878793          	addi	a5,a5,1432 # 80005d50 <kernelvec>
    800027c0:	10579073          	csrw	stvec,a5
  struct proc *p = myproc();
    800027c4:	fffff097          	auipc	ra,0xfffff
    800027c8:	1e6080e7          	jalr	486(ra) # 800019aa <myproc>
    800027cc:	84aa                	mv	s1,a0
  p->trapframe->epc = r_sepc();
    800027ce:	6d3c                	ld	a5,88(a0)
  asm volatile("csrr %0, sepc" : "=r" (x) );
    800027d0:	14102773          	csrr	a4,sepc
    800027d4:	ef98                	sd	a4,24(a5)
  asm volatile("csrr %0, scause" : "=r" (x) );
    800027d6:	14202773          	csrr	a4,scause
  if(r_scause() == 8){
    800027da:	47a1                	li	a5,8
    800027dc:	04f71c63          	bne	a4,a5,80002834 <usertrap+0x92>
    if(p->killed)
    800027e0:	591c                	lw	a5,48(a0)
    800027e2:	e3b9                	bnez	a5,80002828 <usertrap+0x86>
    p->trapframe->epc += 4;
    800027e4:	6cb8                	ld	a4,88(s1)
    800027e6:	6f1c                	ld	a5,24(a4)
    800027e8:	0791                	addi	a5,a5,4
    800027ea:	ef1c                	sd	a5,24(a4)
  asm volatile("csrr %0, sstatus" : "=r" (x) );
    800027ec:	100027f3          	csrr	a5,sstatus
  w_sstatus(r_sstatus() | SSTATUS_SIE);
    800027f0:	0027e793          	ori	a5,a5,2
  asm volatile("csrw sstatus, %0" : : "r" (x));
    800027f4:	10079073          	csrw	sstatus,a5
    syscall();
    800027f8:	00000097          	auipc	ra,0x0
    800027fc:	2e0080e7          	jalr	736(ra) # 80002ad8 <syscall>
  if(p->killed)
    80002800:	589c                	lw	a5,48(s1)
    80002802:	ebc1                	bnez	a5,80002892 <usertrap+0xf0>
  usertrapret();
    80002804:	00000097          	auipc	ra,0x0
    80002808:	e18080e7          	jalr	-488(ra) # 8000261c <usertrapret>
}
    8000280c:	60e2                	ld	ra,24(sp)
    8000280e:	6442                	ld	s0,16(sp)
    80002810:	64a2                	ld	s1,8(sp)
    80002812:	6902                	ld	s2,0(sp)
    80002814:	6105                	addi	sp,sp,32
    80002816:	8082                	ret
    panic("usertrap: not from user mode");
    80002818:	00006517          	auipc	a0,0x6
    8000281c:	ad850513          	addi	a0,a0,-1320 # 800082f0 <states.0+0x50>
    80002820:	ffffe097          	auipc	ra,0xffffe
    80002824:	d0a080e7          	jalr	-758(ra) # 8000052a <panic>
      exit(-1);
    80002828:	557d                	li	a0,-1
    8000282a:	00000097          	auipc	ra,0x0
    8000282e:	84e080e7          	jalr	-1970(ra) # 80002078 <exit>
    80002832:	bf4d                	j	800027e4 <usertrap+0x42>
  } else if((which_dev = devintr()) != 0){
    80002834:	00000097          	auipc	ra,0x0
    80002838:	ecc080e7          	jalr	-308(ra) # 80002700 <devintr>
    8000283c:	892a                	mv	s2,a0
    8000283e:	c501                	beqz	a0,80002846 <usertrap+0xa4>
  if(p->killed)
    80002840:	589c                	lw	a5,48(s1)
    80002842:	c3a1                	beqz	a5,80002882 <usertrap+0xe0>
    80002844:	a815                	j	80002878 <usertrap+0xd6>
  asm volatile("csrr %0, scause" : "=r" (x) );
    80002846:	142025f3          	csrr	a1,scause
    printf("usertrap(): unexpected scause %p pid=%d\n", r_scause(), p->pid);
    8000284a:	5c90                	lw	a2,56(s1)
    8000284c:	00006517          	auipc	a0,0x6
    80002850:	ac450513          	addi	a0,a0,-1340 # 80008310 <states.0+0x70>
    80002854:	ffffe097          	auipc	ra,0xffffe
    80002858:	d20080e7          	jalr	-736(ra) # 80000574 <printf>
  asm volatile("csrr %0, sepc" : "=r" (x) );
    8000285c:	141025f3          	csrr	a1,sepc
  asm volatile("csrr %0, stval" : "=r" (x) );
    80002860:	14302673          	csrr	a2,stval
    printf("            sepc=%p stval=%p\n", r_sepc(), r_stval());
    80002864:	00006517          	auipc	a0,0x6
    80002868:	adc50513          	addi	a0,a0,-1316 # 80008340 <states.0+0xa0>
    8000286c:	ffffe097          	auipc	ra,0xffffe
    80002870:	d08080e7          	jalr	-760(ra) # 80000574 <printf>
    p->killed = 1;
    80002874:	4785                	li	a5,1
    80002876:	d89c                	sw	a5,48(s1)
    exit(-1);
    80002878:	557d                	li	a0,-1
    8000287a:	fffff097          	auipc	ra,0xfffff
    8000287e:	7fe080e7          	jalr	2046(ra) # 80002078 <exit>
  if(which_dev == 2)
    80002882:	4789                	li	a5,2
    80002884:	f8f910e3          	bne	s2,a5,80002804 <usertrap+0x62>
    yield();
    80002888:	00000097          	auipc	ra,0x0
    8000288c:	8fa080e7          	jalr	-1798(ra) # 80002182 <yield>
    80002890:	bf95                	j	80002804 <usertrap+0x62>
  int which_dev = 0;
    80002892:	4901                	li	s2,0
    80002894:	b7d5                	j	80002878 <usertrap+0xd6>

0000000080002896 <kerneltrap>:
{
    80002896:	7179                	addi	sp,sp,-48
    80002898:	f406                	sd	ra,40(sp)
    8000289a:	f022                	sd	s0,32(sp)
    8000289c:	ec26                	sd	s1,24(sp)
    8000289e:	e84a                	sd	s2,16(sp)
    800028a0:	e44e                	sd	s3,8(sp)
    800028a2:	1800                	addi	s0,sp,48
  asm volatile("csrr %0, sepc" : "=r" (x) );
    800028a4:	14102973          	csrr	s2,sepc
  asm volatile("csrr %0, sstatus" : "=r" (x) );
    800028a8:	100024f3          	csrr	s1,sstatus
  asm volatile("csrr %0, scause" : "=r" (x) );
    800028ac:	142029f3          	csrr	s3,scause
  if((sstatus & SSTATUS_SPP) == 0)
    800028b0:	1004f793          	andi	a5,s1,256
    800028b4:	cb85                	beqz	a5,800028e4 <kerneltrap+0x4e>
  asm volatile("csrr %0, sstatus" : "=r" (x) );
    800028b6:	100027f3          	csrr	a5,sstatus
  return (x & SSTATUS_SIE) != 0;
    800028ba:	8b89                	andi	a5,a5,2
  if(intr_get() != 0)
    800028bc:	ef85                	bnez	a5,800028f4 <kerneltrap+0x5e>
  if((which_dev = devintr()) == 0){
    800028be:	00000097          	auipc	ra,0x0
    800028c2:	e42080e7          	jalr	-446(ra) # 80002700 <devintr>
    800028c6:	cd1d                	beqz	a0,80002904 <kerneltrap+0x6e>
  if(which_dev == 2 && myproc() != 0 && myproc()->state == RUNNING)
    800028c8:	4789                	li	a5,2
    800028ca:	06f50a63          	beq	a0,a5,8000293e <kerneltrap+0xa8>
  asm volatile("csrw sepc, %0" : : "r" (x));
    800028ce:	14191073          	csrw	sepc,s2
  asm volatile("csrw sstatus, %0" : : "r" (x));
    800028d2:	10049073          	csrw	sstatus,s1
}
    800028d6:	70a2                	ld	ra,40(sp)
    800028d8:	7402                	ld	s0,32(sp)
    800028da:	64e2                	ld	s1,24(sp)
    800028dc:	6942                	ld	s2,16(sp)
    800028de:	69a2                	ld	s3,8(sp)
    800028e0:	6145                	addi	sp,sp,48
    800028e2:	8082                	ret
    panic("kerneltrap: not from supervisor mode");
    800028e4:	00006517          	auipc	a0,0x6
    800028e8:	a7c50513          	addi	a0,a0,-1412 # 80008360 <states.0+0xc0>
    800028ec:	ffffe097          	auipc	ra,0xffffe
    800028f0:	c3e080e7          	jalr	-962(ra) # 8000052a <panic>
    panic("kerneltrap: interrupts enabled");
    800028f4:	00006517          	auipc	a0,0x6
    800028f8:	a9450513          	addi	a0,a0,-1388 # 80008388 <states.0+0xe8>
    800028fc:	ffffe097          	auipc	ra,0xffffe
    80002900:	c2e080e7          	jalr	-978(ra) # 8000052a <panic>
    printf("scause %p\n", scause);
    80002904:	85ce                	mv	a1,s3
    80002906:	00006517          	auipc	a0,0x6
    8000290a:	aa250513          	addi	a0,a0,-1374 # 800083a8 <states.0+0x108>
    8000290e:	ffffe097          	auipc	ra,0xffffe
    80002912:	c66080e7          	jalr	-922(ra) # 80000574 <printf>
  asm volatile("csrr %0, sepc" : "=r" (x) );
    80002916:	141025f3          	csrr	a1,sepc
  asm volatile("csrr %0, stval" : "=r" (x) );
    8000291a:	14302673          	csrr	a2,stval
    printf("sepc=%p stval=%p\n", r_sepc(), r_stval());
    8000291e:	00006517          	auipc	a0,0x6
    80002922:	a9a50513          	addi	a0,a0,-1382 # 800083b8 <states.0+0x118>
    80002926:	ffffe097          	auipc	ra,0xffffe
    8000292a:	c4e080e7          	jalr	-946(ra) # 80000574 <printf>
    panic("kerneltrap");
    8000292e:	00006517          	auipc	a0,0x6
    80002932:	aa250513          	addi	a0,a0,-1374 # 800083d0 <states.0+0x130>
    80002936:	ffffe097          	auipc	ra,0xffffe
    8000293a:	bf4080e7          	jalr	-1036(ra) # 8000052a <panic>
  if(which_dev == 2 && myproc() != 0 && myproc()->state == RUNNING)
    8000293e:	fffff097          	auipc	ra,0xfffff
    80002942:	06c080e7          	jalr	108(ra) # 800019aa <myproc>
    80002946:	d541                	beqz	a0,800028ce <kerneltrap+0x38>
    80002948:	fffff097          	auipc	ra,0xfffff
    8000294c:	062080e7          	jalr	98(ra) # 800019aa <myproc>
    80002950:	4d18                	lw	a4,24(a0)
    80002952:	478d                	li	a5,3
    80002954:	f6f71de3          	bne	a4,a5,800028ce <kerneltrap+0x38>
    yield();
    80002958:	00000097          	auipc	ra,0x0
    8000295c:	82a080e7          	jalr	-2006(ra) # 80002182 <yield>
    80002960:	b7bd                	j	800028ce <kerneltrap+0x38>

0000000080002962 <argraw>:
  return strlen(buf);
}

static uint64
argraw(int n)
{
    80002962:	1101                	addi	sp,sp,-32
    80002964:	ec06                	sd	ra,24(sp)
    80002966:	e822                	sd	s0,16(sp)
    80002968:	e426                	sd	s1,8(sp)
    8000296a:	1000                	addi	s0,sp,32
    8000296c:	84aa                	mv	s1,a0
  struct proc *p = myproc();
    8000296e:	fffff097          	auipc	ra,0xfffff
    80002972:	03c080e7          	jalr	60(ra) # 800019aa <myproc>
  switch (n) {
    80002976:	4795                	li	a5,5
    80002978:	0497e163          	bltu	a5,s1,800029ba <argraw+0x58>
    8000297c:	048a                	slli	s1,s1,0x2
    8000297e:	00006717          	auipc	a4,0x6
    80002982:	a8a70713          	addi	a4,a4,-1398 # 80008408 <states.0+0x168>
    80002986:	94ba                	add	s1,s1,a4
    80002988:	409c                	lw	a5,0(s1)
    8000298a:	97ba                	add	a5,a5,a4
    8000298c:	8782                	jr	a5
  case 0:
    return p->trapframe->a0;
    8000298e:	6d3c                	ld	a5,88(a0)
    80002990:	7ba8                	ld	a0,112(a5)
  case 5:
    return p->trapframe->a5;
  }
  panic("argraw");
  return -1;
}
    80002992:	60e2                	ld	ra,24(sp)
    80002994:	6442                	ld	s0,16(sp)
    80002996:	64a2                	ld	s1,8(sp)
    80002998:	6105                	addi	sp,sp,32
    8000299a:	8082                	ret
    return p->trapframe->a1;
    8000299c:	6d3c                	ld	a5,88(a0)
    8000299e:	7fa8                	ld	a0,120(a5)
    800029a0:	bfcd                	j	80002992 <argraw+0x30>
    return p->trapframe->a2;
    800029a2:	6d3c                	ld	a5,88(a0)
    800029a4:	63c8                	ld	a0,128(a5)
    800029a6:	b7f5                	j	80002992 <argraw+0x30>
    return p->trapframe->a3;
    800029a8:	6d3c                	ld	a5,88(a0)
    800029aa:	67c8                	ld	a0,136(a5)
    800029ac:	b7dd                	j	80002992 <argraw+0x30>
    return p->trapframe->a4;
    800029ae:	6d3c                	ld	a5,88(a0)
    800029b0:	6bc8                	ld	a0,144(a5)
    800029b2:	b7c5                	j	80002992 <argraw+0x30>
    return p->trapframe->a5;
    800029b4:	6d3c                	ld	a5,88(a0)
    800029b6:	6fc8                	ld	a0,152(a5)
    800029b8:	bfe9                	j	80002992 <argraw+0x30>
  panic("argraw");
    800029ba:	00006517          	auipc	a0,0x6
    800029be:	a2650513          	addi	a0,a0,-1498 # 800083e0 <states.0+0x140>
    800029c2:	ffffe097          	auipc	ra,0xffffe
    800029c6:	b68080e7          	jalr	-1176(ra) # 8000052a <panic>

00000000800029ca <fetchaddr>:
{
    800029ca:	1101                	addi	sp,sp,-32
    800029cc:	ec06                	sd	ra,24(sp)
    800029ce:	e822                	sd	s0,16(sp)
    800029d0:	e426                	sd	s1,8(sp)
    800029d2:	e04a                	sd	s2,0(sp)
    800029d4:	1000                	addi	s0,sp,32
    800029d6:	84aa                	mv	s1,a0
    800029d8:	892e                	mv	s2,a1
  struct proc *p = myproc();
    800029da:	fffff097          	auipc	ra,0xfffff
    800029de:	fd0080e7          	jalr	-48(ra) # 800019aa <myproc>
  if(addr >= p->sz || addr+sizeof(uint64) > p->sz)
    800029e2:	653c                	ld	a5,72(a0)
    800029e4:	02f4f863          	bgeu	s1,a5,80002a14 <fetchaddr+0x4a>
    800029e8:	00848713          	addi	a4,s1,8
    800029ec:	02e7e663          	bltu	a5,a4,80002a18 <fetchaddr+0x4e>
  if(copyin(p->pagetable, (char *)ip, addr, sizeof(*ip)) != 0)
    800029f0:	46a1                	li	a3,8
    800029f2:	8626                	mv	a2,s1
    800029f4:	85ca                	mv	a1,s2
    800029f6:	6928                	ld	a0,80(a0)
    800029f8:	fffff097          	auipc	ra,0xfffff
    800029fc:	cd2080e7          	jalr	-814(ra) # 800016ca <copyin>
    80002a00:	00a03533          	snez	a0,a0
    80002a04:	40a00533          	neg	a0,a0
}
    80002a08:	60e2                	ld	ra,24(sp)
    80002a0a:	6442                	ld	s0,16(sp)
    80002a0c:	64a2                	ld	s1,8(sp)
    80002a0e:	6902                	ld	s2,0(sp)
    80002a10:	6105                	addi	sp,sp,32
    80002a12:	8082                	ret
    return -1;
    80002a14:	557d                	li	a0,-1
    80002a16:	bfcd                	j	80002a08 <fetchaddr+0x3e>
    80002a18:	557d                	li	a0,-1
    80002a1a:	b7fd                	j	80002a08 <fetchaddr+0x3e>

0000000080002a1c <fetchstr>:
{
    80002a1c:	7179                	addi	sp,sp,-48
    80002a1e:	f406                	sd	ra,40(sp)
    80002a20:	f022                	sd	s0,32(sp)
    80002a22:	ec26                	sd	s1,24(sp)
    80002a24:	e84a                	sd	s2,16(sp)
    80002a26:	e44e                	sd	s3,8(sp)
    80002a28:	1800                	addi	s0,sp,48
    80002a2a:	892a                	mv	s2,a0
    80002a2c:	84ae                	mv	s1,a1
    80002a2e:	89b2                	mv	s3,a2
  struct proc *p = myproc();
    80002a30:	fffff097          	auipc	ra,0xfffff
    80002a34:	f7a080e7          	jalr	-134(ra) # 800019aa <myproc>
  int err = copyinstr(p->pagetable, buf, addr, max);
    80002a38:	86ce                	mv	a3,s3
    80002a3a:	864a                	mv	a2,s2
    80002a3c:	85a6                	mv	a1,s1
    80002a3e:	6928                	ld	a0,80(a0)
    80002a40:	fffff097          	auipc	ra,0xfffff
    80002a44:	d18080e7          	jalr	-744(ra) # 80001758 <copyinstr>
  if(err < 0)
    80002a48:	00054763          	bltz	a0,80002a56 <fetchstr+0x3a>
  return strlen(buf);
    80002a4c:	8526                	mv	a0,s1
    80002a4e:	ffffe097          	auipc	ra,0xffffe
    80002a52:	3f4080e7          	jalr	1012(ra) # 80000e42 <strlen>
}
    80002a56:	70a2                	ld	ra,40(sp)
    80002a58:	7402                	ld	s0,32(sp)
    80002a5a:	64e2                	ld	s1,24(sp)
    80002a5c:	6942                	ld	s2,16(sp)
    80002a5e:	69a2                	ld	s3,8(sp)
    80002a60:	6145                	addi	sp,sp,48
    80002a62:	8082                	ret

0000000080002a64 <argint>:

// Fetch the nth 32-bit system call argument.
int
argint(int n, int *ip)
{
    80002a64:	1101                	addi	sp,sp,-32
    80002a66:	ec06                	sd	ra,24(sp)
    80002a68:	e822                	sd	s0,16(sp)
    80002a6a:	e426                	sd	s1,8(sp)
    80002a6c:	1000                	addi	s0,sp,32
    80002a6e:	84ae                	mv	s1,a1
  *ip = argraw(n);
    80002a70:	00000097          	auipc	ra,0x0
    80002a74:	ef2080e7          	jalr	-270(ra) # 80002962 <argraw>
    80002a78:	c088                	sw	a0,0(s1)
  return 0;
}
    80002a7a:	4501                	li	a0,0
    80002a7c:	60e2                	ld	ra,24(sp)
    80002a7e:	6442                	ld	s0,16(sp)
    80002a80:	64a2                	ld	s1,8(sp)
    80002a82:	6105                	addi	sp,sp,32
    80002a84:	8082                	ret

0000000080002a86 <argaddr>:
// Retrieve an argument as a pointer.
// Doesn't check for legality, since
// copyin/copyout will do that.
int
argaddr(int n, uint64 *ip)
{
    80002a86:	1101                	addi	sp,sp,-32
    80002a88:	ec06                	sd	ra,24(sp)
    80002a8a:	e822                	sd	s0,16(sp)
    80002a8c:	e426                	sd	s1,8(sp)
    80002a8e:	1000                	addi	s0,sp,32
    80002a90:	84ae                	mv	s1,a1
  *ip = argraw(n);
    80002a92:	00000097          	auipc	ra,0x0
    80002a96:	ed0080e7          	jalr	-304(ra) # 80002962 <argraw>
    80002a9a:	e088                	sd	a0,0(s1)
  return 0;
}
    80002a9c:	4501                	li	a0,0
    80002a9e:	60e2                	ld	ra,24(sp)
    80002aa0:	6442                	ld	s0,16(sp)
    80002aa2:	64a2                	ld	s1,8(sp)
    80002aa4:	6105                	addi	sp,sp,32
    80002aa6:	8082                	ret

0000000080002aa8 <argstr>:
// Fetch the nth word-sized system call argument as a null-terminated string.
// Copies into buf, at most max.
// Returns string length if OK (including nul), -1 if error.
int
argstr(int n, char *buf, int max)
{
    80002aa8:	1101                	addi	sp,sp,-32
    80002aaa:	ec06                	sd	ra,24(sp)
    80002aac:	e822                	sd	s0,16(sp)
    80002aae:	e426                	sd	s1,8(sp)
    80002ab0:	e04a                	sd	s2,0(sp)
    80002ab2:	1000                	addi	s0,sp,32
    80002ab4:	84ae                	mv	s1,a1
    80002ab6:	8932                	mv	s2,a2
  *ip = argraw(n);
    80002ab8:	00000097          	auipc	ra,0x0
    80002abc:	eaa080e7          	jalr	-342(ra) # 80002962 <argraw>
  uint64 addr;
  if(argaddr(n, &addr) < 0)
    return -1;
  return fetchstr(addr, buf, max);
    80002ac0:	864a                	mv	a2,s2
    80002ac2:	85a6                	mv	a1,s1
    80002ac4:	00000097          	auipc	ra,0x0
    80002ac8:	f58080e7          	jalr	-168(ra) # 80002a1c <fetchstr>
}
    80002acc:	60e2                	ld	ra,24(sp)
    80002ace:	6442                	ld	s0,16(sp)
    80002ad0:	64a2                	ld	s1,8(sp)
    80002ad2:	6902                	ld	s2,0(sp)
    80002ad4:	6105                	addi	sp,sp,32
    80002ad6:	8082                	ret

0000000080002ad8 <syscall>:
[SYS_symlink] sys_symlink,
};

void
syscall(void)
{
    80002ad8:	1101                	addi	sp,sp,-32
    80002ada:	ec06                	sd	ra,24(sp)
    80002adc:	e822                	sd	s0,16(sp)
    80002ade:	e426                	sd	s1,8(sp)
    80002ae0:	e04a                	sd	s2,0(sp)
    80002ae2:	1000                	addi	s0,sp,32
  int num;
  struct proc *p = myproc();
    80002ae4:	fffff097          	auipc	ra,0xfffff
    80002ae8:	ec6080e7          	jalr	-314(ra) # 800019aa <myproc>
    80002aec:	84aa                	mv	s1,a0

  num = p->trapframe->a7;
    80002aee:	05853903          	ld	s2,88(a0)
    80002af2:	0a893783          	ld	a5,168(s2)
    80002af6:	0007869b          	sext.w	a3,a5
  if(num > 0 && num < NELEM(syscalls) && syscalls[num]) {
    80002afa:	37fd                	addiw	a5,a5,-1
    80002afc:	4755                	li	a4,21
    80002afe:	00f76f63          	bltu	a4,a5,80002b1c <syscall+0x44>
    80002b02:	00369713          	slli	a4,a3,0x3
    80002b06:	00006797          	auipc	a5,0x6
    80002b0a:	91a78793          	addi	a5,a5,-1766 # 80008420 <syscalls>
    80002b0e:	97ba                	add	a5,a5,a4
    80002b10:	639c                	ld	a5,0(a5)
    80002b12:	c789                	beqz	a5,80002b1c <syscall+0x44>
    p->trapframe->a0 = syscalls[num]();
    80002b14:	9782                	jalr	a5
    80002b16:	06a93823          	sd	a0,112(s2)
    80002b1a:	a839                	j	80002b38 <syscall+0x60>
  } else {
    printf("%d %s: unknown sys call %d\n",
    80002b1c:	15848613          	addi	a2,s1,344
    80002b20:	5c8c                	lw	a1,56(s1)
    80002b22:	00006517          	auipc	a0,0x6
    80002b26:	8c650513          	addi	a0,a0,-1850 # 800083e8 <states.0+0x148>
    80002b2a:	ffffe097          	auipc	ra,0xffffe
    80002b2e:	a4a080e7          	jalr	-1462(ra) # 80000574 <printf>
            p->pid, p->name, num);
    p->trapframe->a0 = -1;
    80002b32:	6cbc                	ld	a5,88(s1)
    80002b34:	577d                	li	a4,-1
    80002b36:	fbb8                	sd	a4,112(a5)
  }
}
    80002b38:	60e2                	ld	ra,24(sp)
    80002b3a:	6442                	ld	s0,16(sp)
    80002b3c:	64a2                	ld	s1,8(sp)
    80002b3e:	6902                	ld	s2,0(sp)
    80002b40:	6105                	addi	sp,sp,32
    80002b42:	8082                	ret

0000000080002b44 <sys_exit>:
#include "spinlock.h"
#include "proc.h"

uint64
sys_exit(void)
{
    80002b44:	1101                	addi	sp,sp,-32
    80002b46:	ec06                	sd	ra,24(sp)
    80002b48:	e822                	sd	s0,16(sp)
    80002b4a:	1000                	addi	s0,sp,32
  int n;
  if(argint(0, &n) < 0)
    80002b4c:	fec40593          	addi	a1,s0,-20
    80002b50:	4501                	li	a0,0
    80002b52:	00000097          	auipc	ra,0x0
    80002b56:	f12080e7          	jalr	-238(ra) # 80002a64 <argint>
    return -1;
    80002b5a:	57fd                	li	a5,-1
  if(argint(0, &n) < 0)
    80002b5c:	00054963          	bltz	a0,80002b6e <sys_exit+0x2a>
  exit(n);
    80002b60:	fec42503          	lw	a0,-20(s0)
    80002b64:	fffff097          	auipc	ra,0xfffff
    80002b68:	514080e7          	jalr	1300(ra) # 80002078 <exit>
  return 0;  // not reached
    80002b6c:	4781                	li	a5,0
}
    80002b6e:	853e                	mv	a0,a5
    80002b70:	60e2                	ld	ra,24(sp)
    80002b72:	6442                	ld	s0,16(sp)
    80002b74:	6105                	addi	sp,sp,32
    80002b76:	8082                	ret

0000000080002b78 <sys_getpid>:

uint64
sys_getpid(void)
{
    80002b78:	1141                	addi	sp,sp,-16
    80002b7a:	e406                	sd	ra,8(sp)
    80002b7c:	e022                	sd	s0,0(sp)
    80002b7e:	0800                	addi	s0,sp,16
  return myproc()->pid;
    80002b80:	fffff097          	auipc	ra,0xfffff
    80002b84:	e2a080e7          	jalr	-470(ra) # 800019aa <myproc>
}
    80002b88:	5d08                	lw	a0,56(a0)
    80002b8a:	60a2                	ld	ra,8(sp)
    80002b8c:	6402                	ld	s0,0(sp)
    80002b8e:	0141                	addi	sp,sp,16
    80002b90:	8082                	ret

0000000080002b92 <sys_fork>:

uint64
sys_fork(void)
{
    80002b92:	1141                	addi	sp,sp,-16
    80002b94:	e406                	sd	ra,8(sp)
    80002b96:	e022                	sd	s0,0(sp)
    80002b98:	0800                	addi	s0,sp,16
  return fork();
    80002b9a:	fffff097          	auipc	ra,0xfffff
    80002b9e:	1d0080e7          	jalr	464(ra) # 80001d6a <fork>
}
    80002ba2:	60a2                	ld	ra,8(sp)
    80002ba4:	6402                	ld	s0,0(sp)
    80002ba6:	0141                	addi	sp,sp,16
    80002ba8:	8082                	ret

0000000080002baa <sys_wait>:

uint64
sys_wait(void)
{
    80002baa:	1101                	addi	sp,sp,-32
    80002bac:	ec06                	sd	ra,24(sp)
    80002bae:	e822                	sd	s0,16(sp)
    80002bb0:	1000                	addi	s0,sp,32
  uint64 p;
  if(argaddr(0, &p) < 0)
    80002bb2:	fe840593          	addi	a1,s0,-24
    80002bb6:	4501                	li	a0,0
    80002bb8:	00000097          	auipc	ra,0x0
    80002bbc:	ece080e7          	jalr	-306(ra) # 80002a86 <argaddr>
    80002bc0:	87aa                	mv	a5,a0
    return -1;
    80002bc2:	557d                	li	a0,-1
  if(argaddr(0, &p) < 0)
    80002bc4:	0007c863          	bltz	a5,80002bd4 <sys_wait+0x2a>
  return wait(p);
    80002bc8:	fe843503          	ld	a0,-24(s0)
    80002bcc:	fffff097          	auipc	ra,0xfffff
    80002bd0:	670080e7          	jalr	1648(ra) # 8000223c <wait>
}
    80002bd4:	60e2                	ld	ra,24(sp)
    80002bd6:	6442                	ld	s0,16(sp)
    80002bd8:	6105                	addi	sp,sp,32
    80002bda:	8082                	ret

0000000080002bdc <sys_sbrk>:

uint64
sys_sbrk(void)
{
    80002bdc:	7179                	addi	sp,sp,-48
    80002bde:	f406                	sd	ra,40(sp)
    80002be0:	f022                	sd	s0,32(sp)
    80002be2:	ec26                	sd	s1,24(sp)
    80002be4:	1800                	addi	s0,sp,48
  int addr;
  int n;

  if(argint(0, &n) < 0)
    80002be6:	fdc40593          	addi	a1,s0,-36
    80002bea:	4501                	li	a0,0
    80002bec:	00000097          	auipc	ra,0x0
    80002bf0:	e78080e7          	jalr	-392(ra) # 80002a64 <argint>
    return -1;
    80002bf4:	54fd                	li	s1,-1
  if(argint(0, &n) < 0)
    80002bf6:	00054f63          	bltz	a0,80002c14 <sys_sbrk+0x38>
  addr = myproc()->sz;
    80002bfa:	fffff097          	auipc	ra,0xfffff
    80002bfe:	db0080e7          	jalr	-592(ra) # 800019aa <myproc>
    80002c02:	4524                	lw	s1,72(a0)
  if(growproc(n) < 0)
    80002c04:	fdc42503          	lw	a0,-36(s0)
    80002c08:	fffff097          	auipc	ra,0xfffff
    80002c0c:	0ee080e7          	jalr	238(ra) # 80001cf6 <growproc>
    80002c10:	00054863          	bltz	a0,80002c20 <sys_sbrk+0x44>
    return -1;
  return addr;
}
    80002c14:	8526                	mv	a0,s1
    80002c16:	70a2                	ld	ra,40(sp)
    80002c18:	7402                	ld	s0,32(sp)
    80002c1a:	64e2                	ld	s1,24(sp)
    80002c1c:	6145                	addi	sp,sp,48
    80002c1e:	8082                	ret
    return -1;
    80002c20:	54fd                	li	s1,-1
    80002c22:	bfcd                	j	80002c14 <sys_sbrk+0x38>

0000000080002c24 <sys_sleep>:

uint64
sys_sleep(void)
{
    80002c24:	7139                	addi	sp,sp,-64
    80002c26:	fc06                	sd	ra,56(sp)
    80002c28:	f822                	sd	s0,48(sp)
    80002c2a:	f426                	sd	s1,40(sp)
    80002c2c:	f04a                	sd	s2,32(sp)
    80002c2e:	ec4e                	sd	s3,24(sp)
    80002c30:	0080                	addi	s0,sp,64
  int n;
  uint ticks0;

  if(argint(0, &n) < 0)
    80002c32:	fcc40593          	addi	a1,s0,-52
    80002c36:	4501                	li	a0,0
    80002c38:	00000097          	auipc	ra,0x0
    80002c3c:	e2c080e7          	jalr	-468(ra) # 80002a64 <argint>
    return -1;
    80002c40:	57fd                	li	a5,-1
  if(argint(0, &n) < 0)
    80002c42:	06054563          	bltz	a0,80002cac <sys_sleep+0x88>
  acquire(&tickslock);
    80002c46:	00010517          	auipc	a0,0x10
    80002c4a:	88250513          	addi	a0,a0,-1918 # 800124c8 <tickslock>
    80002c4e:	ffffe097          	auipc	ra,0xffffe
    80002c52:	f74080e7          	jalr	-140(ra) # 80000bc2 <acquire>
  ticks0 = ticks;
    80002c56:	00006917          	auipc	s2,0x6
    80002c5a:	3da92903          	lw	s2,986(s2) # 80009030 <ticks>
  while(ticks - ticks0 < n){
    80002c5e:	fcc42783          	lw	a5,-52(s0)
    80002c62:	cf85                	beqz	a5,80002c9a <sys_sleep+0x76>
    if(myproc()->killed){
      release(&tickslock);
      return -1;
    }
    sleep(&ticks, &tickslock);
    80002c64:	00010997          	auipc	s3,0x10
    80002c68:	86498993          	addi	s3,s3,-1948 # 800124c8 <tickslock>
    80002c6c:	00006497          	auipc	s1,0x6
    80002c70:	3c448493          	addi	s1,s1,964 # 80009030 <ticks>
    if(myproc()->killed){
    80002c74:	fffff097          	auipc	ra,0xfffff
    80002c78:	d36080e7          	jalr	-714(ra) # 800019aa <myproc>
    80002c7c:	591c                	lw	a5,48(a0)
    80002c7e:	ef9d                	bnez	a5,80002cbc <sys_sleep+0x98>
    sleep(&ticks, &tickslock);
    80002c80:	85ce                	mv	a1,s3
    80002c82:	8526                	mv	a0,s1
    80002c84:	fffff097          	auipc	ra,0xfffff
    80002c88:	53a080e7          	jalr	1338(ra) # 800021be <sleep>
  while(ticks - ticks0 < n){
    80002c8c:	409c                	lw	a5,0(s1)
    80002c8e:	412787bb          	subw	a5,a5,s2
    80002c92:	fcc42703          	lw	a4,-52(s0)
    80002c96:	fce7efe3          	bltu	a5,a4,80002c74 <sys_sleep+0x50>
  }
  release(&tickslock);
    80002c9a:	00010517          	auipc	a0,0x10
    80002c9e:	82e50513          	addi	a0,a0,-2002 # 800124c8 <tickslock>
    80002ca2:	ffffe097          	auipc	ra,0xffffe
    80002ca6:	fd4080e7          	jalr	-44(ra) # 80000c76 <release>
  return 0;
    80002caa:	4781                	li	a5,0
}
    80002cac:	853e                	mv	a0,a5
    80002cae:	70e2                	ld	ra,56(sp)
    80002cb0:	7442                	ld	s0,48(sp)
    80002cb2:	74a2                	ld	s1,40(sp)
    80002cb4:	7902                	ld	s2,32(sp)
    80002cb6:	69e2                	ld	s3,24(sp)
    80002cb8:	6121                	addi	sp,sp,64
    80002cba:	8082                	ret
      release(&tickslock);
    80002cbc:	00010517          	auipc	a0,0x10
    80002cc0:	80c50513          	addi	a0,a0,-2036 # 800124c8 <tickslock>
    80002cc4:	ffffe097          	auipc	ra,0xffffe
    80002cc8:	fb2080e7          	jalr	-78(ra) # 80000c76 <release>
      return -1;
    80002ccc:	57fd                	li	a5,-1
    80002cce:	bff9                	j	80002cac <sys_sleep+0x88>

0000000080002cd0 <sys_kill>:

uint64
sys_kill(void)
{
    80002cd0:	1101                	addi	sp,sp,-32
    80002cd2:	ec06                	sd	ra,24(sp)
    80002cd4:	e822                	sd	s0,16(sp)
    80002cd6:	1000                	addi	s0,sp,32
  int pid;

  if(argint(0, &pid) < 0)
    80002cd8:	fec40593          	addi	a1,s0,-20
    80002cdc:	4501                	li	a0,0
    80002cde:	00000097          	auipc	ra,0x0
    80002ce2:	d86080e7          	jalr	-634(ra) # 80002a64 <argint>
    80002ce6:	87aa                	mv	a5,a0
    return -1;
    80002ce8:	557d                	li	a0,-1
  if(argint(0, &pid) < 0)
    80002cea:	0007c863          	bltz	a5,80002cfa <sys_kill+0x2a>
  return kill(pid);
    80002cee:	fec42503          	lw	a0,-20(s0)
    80002cf2:	fffff097          	auipc	ra,0xfffff
    80002cf6:	6b6080e7          	jalr	1718(ra) # 800023a8 <kill>
}
    80002cfa:	60e2                	ld	ra,24(sp)
    80002cfc:	6442                	ld	s0,16(sp)
    80002cfe:	6105                	addi	sp,sp,32
    80002d00:	8082                	ret

0000000080002d02 <sys_uptime>:

// return how many clock tick interrupts have occurred
// since start.
uint64
sys_uptime(void)
{
    80002d02:	1101                	addi	sp,sp,-32
    80002d04:	ec06                	sd	ra,24(sp)
    80002d06:	e822                	sd	s0,16(sp)
    80002d08:	e426                	sd	s1,8(sp)
    80002d0a:	1000                	addi	s0,sp,32
  uint xticks;

  acquire(&tickslock);
    80002d0c:	0000f517          	auipc	a0,0xf
    80002d10:	7bc50513          	addi	a0,a0,1980 # 800124c8 <tickslock>
    80002d14:	ffffe097          	auipc	ra,0xffffe
    80002d18:	eae080e7          	jalr	-338(ra) # 80000bc2 <acquire>
  xticks = ticks;
    80002d1c:	00006497          	auipc	s1,0x6
    80002d20:	3144a483          	lw	s1,788(s1) # 80009030 <ticks>
  release(&tickslock);
    80002d24:	0000f517          	auipc	a0,0xf
    80002d28:	7a450513          	addi	a0,a0,1956 # 800124c8 <tickslock>
    80002d2c:	ffffe097          	auipc	ra,0xffffe
    80002d30:	f4a080e7          	jalr	-182(ra) # 80000c76 <release>
  return xticks;
}
    80002d34:	02049513          	slli	a0,s1,0x20
    80002d38:	9101                	srli	a0,a0,0x20
    80002d3a:	60e2                	ld	ra,24(sp)
    80002d3c:	6442                	ld	s0,16(sp)
    80002d3e:	64a2                	ld	s1,8(sp)
    80002d40:	6105                	addi	sp,sp,32
    80002d42:	8082                	ret

0000000080002d44 <binit>:
  struct buf head;
} bcache;

void
binit(void)
{
    80002d44:	7179                	addi	sp,sp,-48
    80002d46:	f406                	sd	ra,40(sp)
    80002d48:	f022                	sd	s0,32(sp)
    80002d4a:	ec26                	sd	s1,24(sp)
    80002d4c:	e84a                	sd	s2,16(sp)
    80002d4e:	e44e                	sd	s3,8(sp)
    80002d50:	e052                	sd	s4,0(sp)
    80002d52:	1800                	addi	s0,sp,48
  struct buf *b;

  initlock(&bcache.lock, "bcache");
    80002d54:	00005597          	auipc	a1,0x5
    80002d58:	78458593          	addi	a1,a1,1924 # 800084d8 <syscalls+0xb8>
    80002d5c:	0000f517          	auipc	a0,0xf
    80002d60:	78450513          	addi	a0,a0,1924 # 800124e0 <bcache>
    80002d64:	ffffe097          	auipc	ra,0xffffe
    80002d68:	dce080e7          	jalr	-562(ra) # 80000b32 <initlock>

  // Create linked list of buffers
  bcache.head.prev = &bcache.head;
    80002d6c:	00017797          	auipc	a5,0x17
    80002d70:	77478793          	addi	a5,a5,1908 # 8001a4e0 <bcache+0x8000>
    80002d74:	00018717          	auipc	a4,0x18
    80002d78:	9d470713          	addi	a4,a4,-1580 # 8001a748 <bcache+0x8268>
    80002d7c:	2ae7b823          	sd	a4,688(a5)
  bcache.head.next = &bcache.head;
    80002d80:	2ae7bc23          	sd	a4,696(a5)
  for(b = bcache.buf; b < bcache.buf+NBUF; b++){
    80002d84:	0000f497          	auipc	s1,0xf
    80002d88:	77448493          	addi	s1,s1,1908 # 800124f8 <bcache+0x18>
    b->next = bcache.head.next;
    80002d8c:	893e                	mv	s2,a5
    b->prev = &bcache.head;
    80002d8e:	89ba                	mv	s3,a4
    initsleeplock(&b->lock, "buffer");
    80002d90:	00005a17          	auipc	s4,0x5
    80002d94:	750a0a13          	addi	s4,s4,1872 # 800084e0 <syscalls+0xc0>
    b->next = bcache.head.next;
    80002d98:	2b893783          	ld	a5,696(s2)
    80002d9c:	e8bc                	sd	a5,80(s1)
    b->prev = &bcache.head;
    80002d9e:	0534b423          	sd	s3,72(s1)
    initsleeplock(&b->lock, "buffer");
    80002da2:	85d2                	mv	a1,s4
    80002da4:	01048513          	addi	a0,s1,16
    80002da8:	00001097          	auipc	ra,0x1
    80002dac:	636080e7          	jalr	1590(ra) # 800043de <initsleeplock>
    bcache.head.next->prev = b;
    80002db0:	2b893783          	ld	a5,696(s2)
    80002db4:	e7a4                	sd	s1,72(a5)
    bcache.head.next = b;
    80002db6:	2a993c23          	sd	s1,696(s2)
  for(b = bcache.buf; b < bcache.buf+NBUF; b++){
    80002dba:	45848493          	addi	s1,s1,1112
    80002dbe:	fd349de3          	bne	s1,s3,80002d98 <binit+0x54>
  }
}
    80002dc2:	70a2                	ld	ra,40(sp)
    80002dc4:	7402                	ld	s0,32(sp)
    80002dc6:	64e2                	ld	s1,24(sp)
    80002dc8:	6942                	ld	s2,16(sp)
    80002dca:	69a2                	ld	s3,8(sp)
    80002dcc:	6a02                	ld	s4,0(sp)
    80002dce:	6145                	addi	sp,sp,48
    80002dd0:	8082                	ret

0000000080002dd2 <bread>:
}

// Return a locked buf with the contents of the indicated block.
struct buf*
bread(uint dev, uint blockno)
{
    80002dd2:	7179                	addi	sp,sp,-48
    80002dd4:	f406                	sd	ra,40(sp)
    80002dd6:	f022                	sd	s0,32(sp)
    80002dd8:	ec26                	sd	s1,24(sp)
    80002dda:	e84a                	sd	s2,16(sp)
    80002ddc:	e44e                	sd	s3,8(sp)
    80002dde:	1800                	addi	s0,sp,48
    80002de0:	892a                	mv	s2,a0
    80002de2:	89ae                	mv	s3,a1
  acquire(&bcache.lock);
    80002de4:	0000f517          	auipc	a0,0xf
    80002de8:	6fc50513          	addi	a0,a0,1788 # 800124e0 <bcache>
    80002dec:	ffffe097          	auipc	ra,0xffffe
    80002df0:	dd6080e7          	jalr	-554(ra) # 80000bc2 <acquire>
  for(b = bcache.head.next; b != &bcache.head; b = b->next){
    80002df4:	00018497          	auipc	s1,0x18
    80002df8:	9a44b483          	ld	s1,-1628(s1) # 8001a798 <bcache+0x82b8>
    80002dfc:	00018797          	auipc	a5,0x18
    80002e00:	94c78793          	addi	a5,a5,-1716 # 8001a748 <bcache+0x8268>
    80002e04:	02f48f63          	beq	s1,a5,80002e42 <bread+0x70>
    80002e08:	873e                	mv	a4,a5
    80002e0a:	a021                	j	80002e12 <bread+0x40>
    80002e0c:	68a4                	ld	s1,80(s1)
    80002e0e:	02e48a63          	beq	s1,a4,80002e42 <bread+0x70>
    if(b->dev == dev && b->blockno == blockno){
    80002e12:	449c                	lw	a5,8(s1)
    80002e14:	ff279ce3          	bne	a5,s2,80002e0c <bread+0x3a>
    80002e18:	44dc                	lw	a5,12(s1)
    80002e1a:	ff3799e3          	bne	a5,s3,80002e0c <bread+0x3a>
      b->refcnt++;
    80002e1e:	40bc                	lw	a5,64(s1)
    80002e20:	2785                	addiw	a5,a5,1
    80002e22:	c0bc                	sw	a5,64(s1)
      release(&bcache.lock);
    80002e24:	0000f517          	auipc	a0,0xf
    80002e28:	6bc50513          	addi	a0,a0,1724 # 800124e0 <bcache>
    80002e2c:	ffffe097          	auipc	ra,0xffffe
    80002e30:	e4a080e7          	jalr	-438(ra) # 80000c76 <release>
      acquiresleep(&b->lock);
    80002e34:	01048513          	addi	a0,s1,16
    80002e38:	00001097          	auipc	ra,0x1
    80002e3c:	5e0080e7          	jalr	1504(ra) # 80004418 <acquiresleep>
      return b;
    80002e40:	a8b9                	j	80002e9e <bread+0xcc>
  for(b = bcache.head.prev; b != &bcache.head; b = b->prev){
    80002e42:	00018497          	auipc	s1,0x18
    80002e46:	94e4b483          	ld	s1,-1714(s1) # 8001a790 <bcache+0x82b0>
    80002e4a:	00018797          	auipc	a5,0x18
    80002e4e:	8fe78793          	addi	a5,a5,-1794 # 8001a748 <bcache+0x8268>
    80002e52:	00f48863          	beq	s1,a5,80002e62 <bread+0x90>
    80002e56:	873e                	mv	a4,a5
    if(b->refcnt == 0) {
    80002e58:	40bc                	lw	a5,64(s1)
    80002e5a:	cf81                	beqz	a5,80002e72 <bread+0xa0>
  for(b = bcache.head.prev; b != &bcache.head; b = b->prev){
    80002e5c:	64a4                	ld	s1,72(s1)
    80002e5e:	fee49de3          	bne	s1,a4,80002e58 <bread+0x86>
  panic("bget: no buffers");
    80002e62:	00005517          	auipc	a0,0x5
    80002e66:	68650513          	addi	a0,a0,1670 # 800084e8 <syscalls+0xc8>
    80002e6a:	ffffd097          	auipc	ra,0xffffd
    80002e6e:	6c0080e7          	jalr	1728(ra) # 8000052a <panic>
      b->dev = dev;
    80002e72:	0124a423          	sw	s2,8(s1)
      b->blockno = blockno;
    80002e76:	0134a623          	sw	s3,12(s1)
      b->valid = 0;
    80002e7a:	0004a023          	sw	zero,0(s1)
      b->refcnt = 1;
    80002e7e:	4785                	li	a5,1
    80002e80:	c0bc                	sw	a5,64(s1)
      release(&bcache.lock);
    80002e82:	0000f517          	auipc	a0,0xf
    80002e86:	65e50513          	addi	a0,a0,1630 # 800124e0 <bcache>
    80002e8a:	ffffe097          	auipc	ra,0xffffe
    80002e8e:	dec080e7          	jalr	-532(ra) # 80000c76 <release>
      acquiresleep(&b->lock);
    80002e92:	01048513          	addi	a0,s1,16
    80002e96:	00001097          	auipc	ra,0x1
    80002e9a:	582080e7          	jalr	1410(ra) # 80004418 <acquiresleep>
  struct buf *b;

  b = bget(dev, blockno);
  if(!b->valid) {
    80002e9e:	409c                	lw	a5,0(s1)
    80002ea0:	cb89                	beqz	a5,80002eb2 <bread+0xe0>
    virtio_disk_rw(b, 0);
    b->valid = 1;
  }
  return b;
}
    80002ea2:	8526                	mv	a0,s1
    80002ea4:	70a2                	ld	ra,40(sp)
    80002ea6:	7402                	ld	s0,32(sp)
    80002ea8:	64e2                	ld	s1,24(sp)
    80002eaa:	6942                	ld	s2,16(sp)
    80002eac:	69a2                	ld	s3,8(sp)
    80002eae:	6145                	addi	sp,sp,48
    80002eb0:	8082                	ret
    virtio_disk_rw(b, 0);
    80002eb2:	4581                	li	a1,0
    80002eb4:	8526                	mv	a0,s1
    80002eb6:	00003097          	auipc	ra,0x3
    80002eba:	1d0080e7          	jalr	464(ra) # 80006086 <virtio_disk_rw>
    b->valid = 1;
    80002ebe:	4785                	li	a5,1
    80002ec0:	c09c                	sw	a5,0(s1)
  return b;
    80002ec2:	b7c5                	j	80002ea2 <bread+0xd0>

0000000080002ec4 <bwrite>:

// Write b's contents to disk.  Must be locked.
void
bwrite(struct buf *b)
{
    80002ec4:	1101                	addi	sp,sp,-32
    80002ec6:	ec06                	sd	ra,24(sp)
    80002ec8:	e822                	sd	s0,16(sp)
    80002eca:	e426                	sd	s1,8(sp)
    80002ecc:	1000                	addi	s0,sp,32
    80002ece:	84aa                	mv	s1,a0
  if(!holdingsleep(&b->lock))
    80002ed0:	0541                	addi	a0,a0,16
    80002ed2:	00001097          	auipc	ra,0x1
    80002ed6:	5e0080e7          	jalr	1504(ra) # 800044b2 <holdingsleep>
    80002eda:	cd01                	beqz	a0,80002ef2 <bwrite+0x2e>
    panic("bwrite");
  virtio_disk_rw(b, 1);
    80002edc:	4585                	li	a1,1
    80002ede:	8526                	mv	a0,s1
    80002ee0:	00003097          	auipc	ra,0x3
    80002ee4:	1a6080e7          	jalr	422(ra) # 80006086 <virtio_disk_rw>
}
    80002ee8:	60e2                	ld	ra,24(sp)
    80002eea:	6442                	ld	s0,16(sp)
    80002eec:	64a2                	ld	s1,8(sp)
    80002eee:	6105                	addi	sp,sp,32
    80002ef0:	8082                	ret
    panic("bwrite");
    80002ef2:	00005517          	auipc	a0,0x5
    80002ef6:	60e50513          	addi	a0,a0,1550 # 80008500 <syscalls+0xe0>
    80002efa:	ffffd097          	auipc	ra,0xffffd
    80002efe:	630080e7          	jalr	1584(ra) # 8000052a <panic>

0000000080002f02 <brelse>:

// Release a locked buffer.
// Move to the head of the most-recently-used list.
void
brelse(struct buf *b)
{
    80002f02:	1101                	addi	sp,sp,-32
    80002f04:	ec06                	sd	ra,24(sp)
    80002f06:	e822                	sd	s0,16(sp)
    80002f08:	e426                	sd	s1,8(sp)
    80002f0a:	e04a                	sd	s2,0(sp)
    80002f0c:	1000                	addi	s0,sp,32
    80002f0e:	84aa                	mv	s1,a0
  if(!holdingsleep(&b->lock))
    80002f10:	01050913          	addi	s2,a0,16
    80002f14:	854a                	mv	a0,s2
    80002f16:	00001097          	auipc	ra,0x1
    80002f1a:	59c080e7          	jalr	1436(ra) # 800044b2 <holdingsleep>
    80002f1e:	c92d                	beqz	a0,80002f90 <brelse+0x8e>
    panic("brelse");

  releasesleep(&b->lock);
    80002f20:	854a                	mv	a0,s2
    80002f22:	00001097          	auipc	ra,0x1
    80002f26:	54c080e7          	jalr	1356(ra) # 8000446e <releasesleep>

  acquire(&bcache.lock);
    80002f2a:	0000f517          	auipc	a0,0xf
    80002f2e:	5b650513          	addi	a0,a0,1462 # 800124e0 <bcache>
    80002f32:	ffffe097          	auipc	ra,0xffffe
    80002f36:	c90080e7          	jalr	-880(ra) # 80000bc2 <acquire>
  b->refcnt--;
    80002f3a:	40bc                	lw	a5,64(s1)
    80002f3c:	37fd                	addiw	a5,a5,-1
    80002f3e:	0007871b          	sext.w	a4,a5
    80002f42:	c0bc                	sw	a5,64(s1)
  if (b->refcnt == 0) {
    80002f44:	eb05                	bnez	a4,80002f74 <brelse+0x72>
    // no one is waiting for it.
    b->next->prev = b->prev;
    80002f46:	68bc                	ld	a5,80(s1)
    80002f48:	64b8                	ld	a4,72(s1)
    80002f4a:	e7b8                	sd	a4,72(a5)
    b->prev->next = b->next;
    80002f4c:	64bc                	ld	a5,72(s1)
    80002f4e:	68b8                	ld	a4,80(s1)
    80002f50:	ebb8                	sd	a4,80(a5)
    b->next = bcache.head.next;
    80002f52:	00017797          	auipc	a5,0x17
    80002f56:	58e78793          	addi	a5,a5,1422 # 8001a4e0 <bcache+0x8000>
    80002f5a:	2b87b703          	ld	a4,696(a5)
    80002f5e:	e8b8                	sd	a4,80(s1)
    b->prev = &bcache.head;
    80002f60:	00017717          	auipc	a4,0x17
    80002f64:	7e870713          	addi	a4,a4,2024 # 8001a748 <bcache+0x8268>
    80002f68:	e4b8                	sd	a4,72(s1)
    bcache.head.next->prev = b;
    80002f6a:	2b87b703          	ld	a4,696(a5)
    80002f6e:	e724                	sd	s1,72(a4)
    bcache.head.next = b;
    80002f70:	2a97bc23          	sd	s1,696(a5)
  }
  
  release(&bcache.lock);
    80002f74:	0000f517          	auipc	a0,0xf
    80002f78:	56c50513          	addi	a0,a0,1388 # 800124e0 <bcache>
    80002f7c:	ffffe097          	auipc	ra,0xffffe
    80002f80:	cfa080e7          	jalr	-774(ra) # 80000c76 <release>
}
    80002f84:	60e2                	ld	ra,24(sp)
    80002f86:	6442                	ld	s0,16(sp)
    80002f88:	64a2                	ld	s1,8(sp)
    80002f8a:	6902                	ld	s2,0(sp)
    80002f8c:	6105                	addi	sp,sp,32
    80002f8e:	8082                	ret
    panic("brelse");
    80002f90:	00005517          	auipc	a0,0x5
    80002f94:	57850513          	addi	a0,a0,1400 # 80008508 <syscalls+0xe8>
    80002f98:	ffffd097          	auipc	ra,0xffffd
    80002f9c:	592080e7          	jalr	1426(ra) # 8000052a <panic>

0000000080002fa0 <bpin>:

void
bpin(struct buf *b) {
    80002fa0:	1101                	addi	sp,sp,-32
    80002fa2:	ec06                	sd	ra,24(sp)
    80002fa4:	e822                	sd	s0,16(sp)
    80002fa6:	e426                	sd	s1,8(sp)
    80002fa8:	1000                	addi	s0,sp,32
    80002faa:	84aa                	mv	s1,a0
  acquire(&bcache.lock);
    80002fac:	0000f517          	auipc	a0,0xf
    80002fb0:	53450513          	addi	a0,a0,1332 # 800124e0 <bcache>
    80002fb4:	ffffe097          	auipc	ra,0xffffe
    80002fb8:	c0e080e7          	jalr	-1010(ra) # 80000bc2 <acquire>
  b->refcnt++;
    80002fbc:	40bc                	lw	a5,64(s1)
    80002fbe:	2785                	addiw	a5,a5,1
    80002fc0:	c0bc                	sw	a5,64(s1)
  release(&bcache.lock);
    80002fc2:	0000f517          	auipc	a0,0xf
    80002fc6:	51e50513          	addi	a0,a0,1310 # 800124e0 <bcache>
    80002fca:	ffffe097          	auipc	ra,0xffffe
    80002fce:	cac080e7          	jalr	-852(ra) # 80000c76 <release>
}
    80002fd2:	60e2                	ld	ra,24(sp)
    80002fd4:	6442                	ld	s0,16(sp)
    80002fd6:	64a2                	ld	s1,8(sp)
    80002fd8:	6105                	addi	sp,sp,32
    80002fda:	8082                	ret

0000000080002fdc <bunpin>:

void
bunpin(struct buf *b) {
    80002fdc:	1101                	addi	sp,sp,-32
    80002fde:	ec06                	sd	ra,24(sp)
    80002fe0:	e822                	sd	s0,16(sp)
    80002fe2:	e426                	sd	s1,8(sp)
    80002fe4:	1000                	addi	s0,sp,32
    80002fe6:	84aa                	mv	s1,a0
  acquire(&bcache.lock);
    80002fe8:	0000f517          	auipc	a0,0xf
    80002fec:	4f850513          	addi	a0,a0,1272 # 800124e0 <bcache>
    80002ff0:	ffffe097          	auipc	ra,0xffffe
    80002ff4:	bd2080e7          	jalr	-1070(ra) # 80000bc2 <acquire>
  b->refcnt--;
    80002ff8:	40bc                	lw	a5,64(s1)
    80002ffa:	37fd                	addiw	a5,a5,-1
    80002ffc:	c0bc                	sw	a5,64(s1)
  release(&bcache.lock);
    80002ffe:	0000f517          	auipc	a0,0xf
    80003002:	4e250513          	addi	a0,a0,1250 # 800124e0 <bcache>
    80003006:	ffffe097          	auipc	ra,0xffffe
    8000300a:	c70080e7          	jalr	-912(ra) # 80000c76 <release>
}
    8000300e:	60e2                	ld	ra,24(sp)
    80003010:	6442                	ld	s0,16(sp)
    80003012:	64a2                	ld	s1,8(sp)
    80003014:	6105                	addi	sp,sp,32
    80003016:	8082                	ret

0000000080003018 <bfree>:
}

// Free a disk block.
static void
bfree(int dev, uint b)
{
    80003018:	1101                	addi	sp,sp,-32
    8000301a:	ec06                	sd	ra,24(sp)
    8000301c:	e822                	sd	s0,16(sp)
    8000301e:	e426                	sd	s1,8(sp)
    80003020:	e04a                	sd	s2,0(sp)
    80003022:	1000                	addi	s0,sp,32
    80003024:	84ae                	mv	s1,a1
  struct buf *bp;
  int bi, m;

  bp = bread(dev, BBLOCK(b, sb));
    80003026:	00d5d59b          	srliw	a1,a1,0xd
    8000302a:	00018797          	auipc	a5,0x18
    8000302e:	b927a783          	lw	a5,-1134(a5) # 8001abbc <sb+0x1c>
    80003032:	9dbd                	addw	a1,a1,a5
    80003034:	00000097          	auipc	ra,0x0
    80003038:	d9e080e7          	jalr	-610(ra) # 80002dd2 <bread>
  bi = b % BPB;
  m = 1 << (bi % 8);
    8000303c:	0074f713          	andi	a4,s1,7
    80003040:	4785                	li	a5,1
    80003042:	00e797bb          	sllw	a5,a5,a4
  if((bp->data[bi/8] & m) == 0)
    80003046:	14ce                	slli	s1,s1,0x33
    80003048:	90d9                	srli	s1,s1,0x36
    8000304a:	00950733          	add	a4,a0,s1
    8000304e:	05874703          	lbu	a4,88(a4)
    80003052:	00e7f6b3          	and	a3,a5,a4
    80003056:	c69d                	beqz	a3,80003084 <bfree+0x6c>
    80003058:	892a                	mv	s2,a0
    panic("freeing free block");
  bp->data[bi/8] &= ~m;
    8000305a:	94aa                	add	s1,s1,a0
    8000305c:	fff7c793          	not	a5,a5
    80003060:	8ff9                	and	a5,a5,a4
    80003062:	04f48c23          	sb	a5,88(s1)
  log_write(bp);
    80003066:	00001097          	auipc	ra,0x1
    8000306a:	28a080e7          	jalr	650(ra) # 800042f0 <log_write>
  brelse(bp);
    8000306e:	854a                	mv	a0,s2
    80003070:	00000097          	auipc	ra,0x0
    80003074:	e92080e7          	jalr	-366(ra) # 80002f02 <brelse>
}
    80003078:	60e2                	ld	ra,24(sp)
    8000307a:	6442                	ld	s0,16(sp)
    8000307c:	64a2                	ld	s1,8(sp)
    8000307e:	6902                	ld	s2,0(sp)
    80003080:	6105                	addi	sp,sp,32
    80003082:	8082                	ret
    panic("freeing free block");
    80003084:	00005517          	auipc	a0,0x5
    80003088:	48c50513          	addi	a0,a0,1164 # 80008510 <syscalls+0xf0>
    8000308c:	ffffd097          	auipc	ra,0xffffd
    80003090:	49e080e7          	jalr	1182(ra) # 8000052a <panic>

0000000080003094 <balloc>:
{
    80003094:	711d                	addi	sp,sp,-96
    80003096:	ec86                	sd	ra,88(sp)
    80003098:	e8a2                	sd	s0,80(sp)
    8000309a:	e4a6                	sd	s1,72(sp)
    8000309c:	e0ca                	sd	s2,64(sp)
    8000309e:	fc4e                	sd	s3,56(sp)
    800030a0:	f852                	sd	s4,48(sp)
    800030a2:	f456                	sd	s5,40(sp)
    800030a4:	f05a                	sd	s6,32(sp)
    800030a6:	ec5e                	sd	s7,24(sp)
    800030a8:	e862                	sd	s8,16(sp)
    800030aa:	e466                	sd	s9,8(sp)
    800030ac:	1080                	addi	s0,sp,96
  for(b = 0; b < sb.size; b += BPB){
    800030ae:	00018797          	auipc	a5,0x18
    800030b2:	af67a783          	lw	a5,-1290(a5) # 8001aba4 <sb+0x4>
    800030b6:	cbd1                	beqz	a5,8000314a <balloc+0xb6>
    800030b8:	8baa                	mv	s7,a0
    800030ba:	4a81                	li	s5,0
    bp = bread(dev, BBLOCK(b, sb));
    800030bc:	00018b17          	auipc	s6,0x18
    800030c0:	ae4b0b13          	addi	s6,s6,-1308 # 8001aba0 <sb>
    for(bi = 0; bi < BPB && b + bi < sb.size; bi++){
    800030c4:	4c01                	li	s8,0
      m = 1 << (bi % 8);
    800030c6:	4985                	li	s3,1
    for(bi = 0; bi < BPB && b + bi < sb.size; bi++){
    800030c8:	6a09                	lui	s4,0x2
  for(b = 0; b < sb.size; b += BPB){
    800030ca:	6c89                	lui	s9,0x2
    800030cc:	a831                	j	800030e8 <balloc+0x54>
    brelse(bp);
    800030ce:	854a                	mv	a0,s2
    800030d0:	00000097          	auipc	ra,0x0
    800030d4:	e32080e7          	jalr	-462(ra) # 80002f02 <brelse>
  for(b = 0; b < sb.size; b += BPB){
    800030d8:	015c87bb          	addw	a5,s9,s5
    800030dc:	00078a9b          	sext.w	s5,a5
    800030e0:	004b2703          	lw	a4,4(s6)
    800030e4:	06eaf363          	bgeu	s5,a4,8000314a <balloc+0xb6>
    bp = bread(dev, BBLOCK(b, sb));
    800030e8:	41fad79b          	sraiw	a5,s5,0x1f
    800030ec:	0137d79b          	srliw	a5,a5,0x13
    800030f0:	015787bb          	addw	a5,a5,s5
    800030f4:	40d7d79b          	sraiw	a5,a5,0xd
    800030f8:	01cb2583          	lw	a1,28(s6)
    800030fc:	9dbd                	addw	a1,a1,a5
    800030fe:	855e                	mv	a0,s7
    80003100:	00000097          	auipc	ra,0x0
    80003104:	cd2080e7          	jalr	-814(ra) # 80002dd2 <bread>
    80003108:	892a                	mv	s2,a0
    for(bi = 0; bi < BPB && b + bi < sb.size; bi++){
    8000310a:	004b2503          	lw	a0,4(s6)
    8000310e:	000a849b          	sext.w	s1,s5
    80003112:	8662                	mv	a2,s8
    80003114:	faa4fde3          	bgeu	s1,a0,800030ce <balloc+0x3a>
      m = 1 << (bi % 8);
    80003118:	41f6579b          	sraiw	a5,a2,0x1f
    8000311c:	01d7d69b          	srliw	a3,a5,0x1d
    80003120:	00c6873b          	addw	a4,a3,a2
    80003124:	00777793          	andi	a5,a4,7
    80003128:	9f95                	subw	a5,a5,a3
    8000312a:	00f997bb          	sllw	a5,s3,a5
      if((bp->data[bi/8] & m) == 0){  // Is block free?
    8000312e:	4037571b          	sraiw	a4,a4,0x3
    80003132:	00e906b3          	add	a3,s2,a4
    80003136:	0586c683          	lbu	a3,88(a3)
    8000313a:	00d7f5b3          	and	a1,a5,a3
    8000313e:	cd91                	beqz	a1,8000315a <balloc+0xc6>
    for(bi = 0; bi < BPB && b + bi < sb.size; bi++){
    80003140:	2605                	addiw	a2,a2,1
    80003142:	2485                	addiw	s1,s1,1
    80003144:	fd4618e3          	bne	a2,s4,80003114 <balloc+0x80>
    80003148:	b759                	j	800030ce <balloc+0x3a>
  panic("balloc: out of blocks");
    8000314a:	00005517          	auipc	a0,0x5
    8000314e:	3de50513          	addi	a0,a0,990 # 80008528 <syscalls+0x108>
    80003152:	ffffd097          	auipc	ra,0xffffd
    80003156:	3d8080e7          	jalr	984(ra) # 8000052a <panic>
        bp->data[bi/8] |= m;  // Mark block in use.
    8000315a:	974a                	add	a4,a4,s2
    8000315c:	8fd5                	or	a5,a5,a3
    8000315e:	04f70c23          	sb	a5,88(a4)
        log_write(bp);
    80003162:	854a                	mv	a0,s2
    80003164:	00001097          	auipc	ra,0x1
    80003168:	18c080e7          	jalr	396(ra) # 800042f0 <log_write>
        brelse(bp);
    8000316c:	854a                	mv	a0,s2
    8000316e:	00000097          	auipc	ra,0x0
    80003172:	d94080e7          	jalr	-620(ra) # 80002f02 <brelse>
  bp = bread(dev, bno);
    80003176:	85a6                	mv	a1,s1
    80003178:	855e                	mv	a0,s7
    8000317a:	00000097          	auipc	ra,0x0
    8000317e:	c58080e7          	jalr	-936(ra) # 80002dd2 <bread>
    80003182:	892a                	mv	s2,a0
  memset(bp->data, 0, BSIZE);
    80003184:	40000613          	li	a2,1024
    80003188:	4581                	li	a1,0
    8000318a:	05850513          	addi	a0,a0,88
    8000318e:	ffffe097          	auipc	ra,0xffffe
    80003192:	b30080e7          	jalr	-1232(ra) # 80000cbe <memset>
  log_write(bp);
    80003196:	854a                	mv	a0,s2
    80003198:	00001097          	auipc	ra,0x1
    8000319c:	158080e7          	jalr	344(ra) # 800042f0 <log_write>
  brelse(bp);
    800031a0:	854a                	mv	a0,s2
    800031a2:	00000097          	auipc	ra,0x0
    800031a6:	d60080e7          	jalr	-672(ra) # 80002f02 <brelse>
}
    800031aa:	8526                	mv	a0,s1
    800031ac:	60e6                	ld	ra,88(sp)
    800031ae:	6446                	ld	s0,80(sp)
    800031b0:	64a6                	ld	s1,72(sp)
    800031b2:	6906                	ld	s2,64(sp)
    800031b4:	79e2                	ld	s3,56(sp)
    800031b6:	7a42                	ld	s4,48(sp)
    800031b8:	7aa2                	ld	s5,40(sp)
    800031ba:	7b02                	ld	s6,32(sp)
    800031bc:	6be2                	ld	s7,24(sp)
    800031be:	6c42                	ld	s8,16(sp)
    800031c0:	6ca2                	ld	s9,8(sp)
    800031c2:	6125                	addi	sp,sp,96
    800031c4:	8082                	ret

00000000800031c6 <bmap>:

// Return the disk block address of the nth block in inode ip.
// If there is no such block, bmap allocates one.
static uint
bmap(struct inode *ip, uint bn)
{
    800031c6:	7139                	addi	sp,sp,-64
    800031c8:	fc06                	sd	ra,56(sp)
    800031ca:	f822                	sd	s0,48(sp)
    800031cc:	f426                	sd	s1,40(sp)
    800031ce:	f04a                	sd	s2,32(sp)
    800031d0:	ec4e                	sd	s3,24(sp)
    800031d2:	e852                	sd	s4,16(sp)
    800031d4:	e456                	sd	s5,8(sp)
    800031d6:	0080                	addi	s0,sp,64
    800031d8:	89aa                	mv	s3,a0
  uint addr, *a;
  struct buf *bp;

  if(bn < NDIRECT){
    800031da:	47a9                	li	a5,10
    800031dc:	08b7fd63          	bgeu	a5,a1,80003276 <bmap+0xb0>
    if((addr = ip->addrs[bn]) == 0)
      ip->addrs[bn] = addr = balloc(ip->dev);
    return addr;
  }
  bn -= NDIRECT;
    800031e0:	ff55849b          	addiw	s1,a1,-11
    800031e4:	0004871b          	sext.w	a4,s1

  if(bn < NINDIRECT1){
    800031e8:	0ff00793          	li	a5,255
    800031ec:	0ae7f863          	bgeu	a5,a4,8000329c <bmap+0xd6>
      log_write(bp);
    }
    brelse(bp);
    return addr;
  }
  bn -= NINDIRECT1;
    800031f0:	ef55849b          	addiw	s1,a1,-267
    800031f4:	0004871b          	sext.w	a4,s1

  if (bn < NINDIRECT2) {
    800031f8:	67c1                	lui	a5,0x10
    800031fa:	14f77e63          	bgeu	a4,a5,80003356 <bmap+0x190>
    //load first-level indirect block, allocating if necessary
    if((addr = ip->addrs[NDIRECT + 1]) == 0)
    800031fe:	08052583          	lw	a1,128(a0)
    80003202:	10058063          	beqz	a1,80003302 <bmap+0x13c>
      ip->addrs[NDIRECT + 1] = addr = balloc(ip->dev);

    //load second-level indirect block, allocating if necessary
    bp = bread(ip->dev, addr);
    80003206:	0009a503          	lw	a0,0(s3)
    8000320a:	00000097          	auipc	ra,0x0
    8000320e:	bc8080e7          	jalr	-1080(ra) # 80002dd2 <bread>
    80003212:	892a                	mv	s2,a0
    a = (uint*)bp->data;
    80003214:	05850a13          	addi	s4,a0,88
    if ((addr = a[bn / NINDIRECT1]) == 0) {
    80003218:	0084d79b          	srliw	a5,s1,0x8
    8000321c:	078a                	slli	a5,a5,0x2
    8000321e:	9a3e                	add	s4,s4,a5
    80003220:	000a2a83          	lw	s5,0(s4) # 2000 <_entry-0x7fffe000>
    80003224:	0e0a8963          	beqz	s5,80003316 <bmap+0x150>
      a[bn / NINDIRECT1] = addr = balloc(ip->dev);
      log_write(bp);
    }
    brelse(bp);
    80003228:	854a                	mv	a0,s2
    8000322a:	00000097          	auipc	ra,0x0
    8000322e:	cd8080e7          	jalr	-808(ra) # 80002f02 <brelse>

    //load data block, allocating if necessary
    bp = bread(ip->dev, addr);
    80003232:	85d6                	mv	a1,s5
    80003234:	0009a503          	lw	a0,0(s3)
    80003238:	00000097          	auipc	ra,0x0
    8000323c:	b9a080e7          	jalr	-1126(ra) # 80002dd2 <bread>
    80003240:	8a2a                	mv	s4,a0
    a = (uint*)bp->data;
    80003242:	05850793          	addi	a5,a0,88
    if ((addr = a[bn % NINDIRECT1]) == 0) {
    80003246:	0ff4f593          	andi	a1,s1,255
    8000324a:	058a                	slli	a1,a1,0x2
    8000324c:	00b784b3          	add	s1,a5,a1
    80003250:	0004a903          	lw	s2,0(s1)
    80003254:	0e090163          	beqz	s2,80003336 <bmap+0x170>
      a[bn % NINDIRECT1] = addr = balloc(ip->dev);
      log_write(bp);
    }
    brelse(bp);
    80003258:	8552                	mv	a0,s4
    8000325a:	00000097          	auipc	ra,0x0
    8000325e:	ca8080e7          	jalr	-856(ra) # 80002f02 <brelse>
    return addr;
  }

  panic("bmap: out of range");
}
    80003262:	854a                	mv	a0,s2
    80003264:	70e2                	ld	ra,56(sp)
    80003266:	7442                	ld	s0,48(sp)
    80003268:	74a2                	ld	s1,40(sp)
    8000326a:	7902                	ld	s2,32(sp)
    8000326c:	69e2                	ld	s3,24(sp)
    8000326e:	6a42                	ld	s4,16(sp)
    80003270:	6aa2                	ld	s5,8(sp)
    80003272:	6121                	addi	sp,sp,64
    80003274:	8082                	ret
    if((addr = ip->addrs[bn]) == 0)
    80003276:	02059493          	slli	s1,a1,0x20
    8000327a:	9081                	srli	s1,s1,0x20
    8000327c:	048a                	slli	s1,s1,0x2
    8000327e:	94aa                	add	s1,s1,a0
    80003280:	0504a903          	lw	s2,80(s1)
    80003284:	fc091fe3          	bnez	s2,80003262 <bmap+0x9c>
      ip->addrs[bn] = addr = balloc(ip->dev);
    80003288:	4108                	lw	a0,0(a0)
    8000328a:	00000097          	auipc	ra,0x0
    8000328e:	e0a080e7          	jalr	-502(ra) # 80003094 <balloc>
    80003292:	0005091b          	sext.w	s2,a0
    80003296:	0524a823          	sw	s2,80(s1)
    8000329a:	b7e1                	j	80003262 <bmap+0x9c>
    if((addr = ip->addrs[NDIRECT]) == 0)
    8000329c:	5d6c                	lw	a1,124(a0)
    8000329e:	c985                	beqz	a1,800032ce <bmap+0x108>
    bp = bread(ip->dev, addr);
    800032a0:	0009a503          	lw	a0,0(s3)
    800032a4:	00000097          	auipc	ra,0x0
    800032a8:	b2e080e7          	jalr	-1234(ra) # 80002dd2 <bread>
    800032ac:	8a2a                	mv	s4,a0
    a = (uint*)bp->data;
    800032ae:	05850793          	addi	a5,a0,88
    if((addr = a[bn]) == 0){
    800032b2:	1482                	slli	s1,s1,0x20
    800032b4:	9081                	srli	s1,s1,0x20
    800032b6:	048a                	slli	s1,s1,0x2
    800032b8:	94be                	add	s1,s1,a5
    800032ba:	0004a903          	lw	s2,0(s1)
    800032be:	02090263          	beqz	s2,800032e2 <bmap+0x11c>
    brelse(bp);
    800032c2:	8552                	mv	a0,s4
    800032c4:	00000097          	auipc	ra,0x0
    800032c8:	c3e080e7          	jalr	-962(ra) # 80002f02 <brelse>
    return addr;
    800032cc:	bf59                	j	80003262 <bmap+0x9c>
      ip->addrs[NDIRECT] = addr = balloc(ip->dev);
    800032ce:	4108                	lw	a0,0(a0)
    800032d0:	00000097          	auipc	ra,0x0
    800032d4:	dc4080e7          	jalr	-572(ra) # 80003094 <balloc>
    800032d8:	0005059b          	sext.w	a1,a0
    800032dc:	06b9ae23          	sw	a1,124(s3)
    800032e0:	b7c1                	j	800032a0 <bmap+0xda>
      a[bn] = addr = balloc(ip->dev);
    800032e2:	0009a503          	lw	a0,0(s3)
    800032e6:	00000097          	auipc	ra,0x0
    800032ea:	dae080e7          	jalr	-594(ra) # 80003094 <balloc>
    800032ee:	0005091b          	sext.w	s2,a0
    800032f2:	0124a023          	sw	s2,0(s1)
      log_write(bp);
    800032f6:	8552                	mv	a0,s4
    800032f8:	00001097          	auipc	ra,0x1
    800032fc:	ff8080e7          	jalr	-8(ra) # 800042f0 <log_write>
    80003300:	b7c9                	j	800032c2 <bmap+0xfc>
      ip->addrs[NDIRECT + 1] = addr = balloc(ip->dev);
    80003302:	4108                	lw	a0,0(a0)
    80003304:	00000097          	auipc	ra,0x0
    80003308:	d90080e7          	jalr	-624(ra) # 80003094 <balloc>
    8000330c:	0005059b          	sext.w	a1,a0
    80003310:	08b9a023          	sw	a1,128(s3)
    80003314:	bdcd                	j	80003206 <bmap+0x40>
      a[bn / NINDIRECT1] = addr = balloc(ip->dev);
    80003316:	0009a503          	lw	a0,0(s3)
    8000331a:	00000097          	auipc	ra,0x0
    8000331e:	d7a080e7          	jalr	-646(ra) # 80003094 <balloc>
    80003322:	00050a9b          	sext.w	s5,a0
    80003326:	015a2023          	sw	s5,0(s4)
      log_write(bp);
    8000332a:	854a                	mv	a0,s2
    8000332c:	00001097          	auipc	ra,0x1
    80003330:	fc4080e7          	jalr	-60(ra) # 800042f0 <log_write>
    80003334:	bdd5                	j	80003228 <bmap+0x62>
      a[bn % NINDIRECT1] = addr = balloc(ip->dev);
    80003336:	0009a503          	lw	a0,0(s3)
    8000333a:	00000097          	auipc	ra,0x0
    8000333e:	d5a080e7          	jalr	-678(ra) # 80003094 <balloc>
    80003342:	0005091b          	sext.w	s2,a0
    80003346:	0124a023          	sw	s2,0(s1)
      log_write(bp);
    8000334a:	8552                	mv	a0,s4
    8000334c:	00001097          	auipc	ra,0x1
    80003350:	fa4080e7          	jalr	-92(ra) # 800042f0 <log_write>
    80003354:	b711                	j	80003258 <bmap+0x92>
  panic("bmap: out of range");
    80003356:	00005517          	auipc	a0,0x5
    8000335a:	1ea50513          	addi	a0,a0,490 # 80008540 <syscalls+0x120>
    8000335e:	ffffd097          	auipc	ra,0xffffd
    80003362:	1cc080e7          	jalr	460(ra) # 8000052a <panic>

0000000080003366 <iget>:
{
    80003366:	7179                	addi	sp,sp,-48
    80003368:	f406                	sd	ra,40(sp)
    8000336a:	f022                	sd	s0,32(sp)
    8000336c:	ec26                	sd	s1,24(sp)
    8000336e:	e84a                	sd	s2,16(sp)
    80003370:	e44e                	sd	s3,8(sp)
    80003372:	e052                	sd	s4,0(sp)
    80003374:	1800                	addi	s0,sp,48
    80003376:	89aa                	mv	s3,a0
    80003378:	8a2e                	mv	s4,a1
  acquire(&icache.lock);
    8000337a:	00018517          	auipc	a0,0x18
    8000337e:	84650513          	addi	a0,a0,-1978 # 8001abc0 <icache>
    80003382:	ffffe097          	auipc	ra,0xffffe
    80003386:	840080e7          	jalr	-1984(ra) # 80000bc2 <acquire>
  empty = 0;
    8000338a:	4901                	li	s2,0
  for(ip = &icache.inode[0]; ip < &icache.inode[NINODE]; ip++){
    8000338c:	00018497          	auipc	s1,0x18
    80003390:	84c48493          	addi	s1,s1,-1972 # 8001abd8 <icache+0x18>
    80003394:	00019697          	auipc	a3,0x19
    80003398:	2d468693          	addi	a3,a3,724 # 8001c668 <log>
    8000339c:	a039                	j	800033aa <iget+0x44>
    if(empty == 0 && ip->ref == 0)    // Remember empty slot.
    8000339e:	02090b63          	beqz	s2,800033d4 <iget+0x6e>
  for(ip = &icache.inode[0]; ip < &icache.inode[NINODE]; ip++){
    800033a2:	08848493          	addi	s1,s1,136
    800033a6:	02d48a63          	beq	s1,a3,800033da <iget+0x74>
    if(ip->ref > 0 && ip->dev == dev && ip->inum == inum){
    800033aa:	449c                	lw	a5,8(s1)
    800033ac:	fef059e3          	blez	a5,8000339e <iget+0x38>
    800033b0:	4098                	lw	a4,0(s1)
    800033b2:	ff3716e3          	bne	a4,s3,8000339e <iget+0x38>
    800033b6:	40d8                	lw	a4,4(s1)
    800033b8:	ff4713e3          	bne	a4,s4,8000339e <iget+0x38>
      ip->ref++;
    800033bc:	2785                	addiw	a5,a5,1
    800033be:	c49c                	sw	a5,8(s1)
      release(&icache.lock);
    800033c0:	00018517          	auipc	a0,0x18
    800033c4:	80050513          	addi	a0,a0,-2048 # 8001abc0 <icache>
    800033c8:	ffffe097          	auipc	ra,0xffffe
    800033cc:	8ae080e7          	jalr	-1874(ra) # 80000c76 <release>
      return ip;
    800033d0:	8926                	mv	s2,s1
    800033d2:	a03d                	j	80003400 <iget+0x9a>
    if(empty == 0 && ip->ref == 0)    // Remember empty slot.
    800033d4:	f7f9                	bnez	a5,800033a2 <iget+0x3c>
    800033d6:	8926                	mv	s2,s1
    800033d8:	b7e9                	j	800033a2 <iget+0x3c>
  if(empty == 0)
    800033da:	02090c63          	beqz	s2,80003412 <iget+0xac>
  ip->dev = dev;
    800033de:	01392023          	sw	s3,0(s2)
  ip->inum = inum;
    800033e2:	01492223          	sw	s4,4(s2)
  ip->ref = 1;
    800033e6:	4785                	li	a5,1
    800033e8:	00f92423          	sw	a5,8(s2)
  ip->valid = 0;
    800033ec:	04092023          	sw	zero,64(s2)
  release(&icache.lock);
    800033f0:	00017517          	auipc	a0,0x17
    800033f4:	7d050513          	addi	a0,a0,2000 # 8001abc0 <icache>
    800033f8:	ffffe097          	auipc	ra,0xffffe
    800033fc:	87e080e7          	jalr	-1922(ra) # 80000c76 <release>
}
    80003400:	854a                	mv	a0,s2
    80003402:	70a2                	ld	ra,40(sp)
    80003404:	7402                	ld	s0,32(sp)
    80003406:	64e2                	ld	s1,24(sp)
    80003408:	6942                	ld	s2,16(sp)
    8000340a:	69a2                	ld	s3,8(sp)
    8000340c:	6a02                	ld	s4,0(sp)
    8000340e:	6145                	addi	sp,sp,48
    80003410:	8082                	ret
    panic("iget: no inodes");
    80003412:	00005517          	auipc	a0,0x5
    80003416:	14650513          	addi	a0,a0,326 # 80008558 <syscalls+0x138>
    8000341a:	ffffd097          	auipc	ra,0xffffd
    8000341e:	110080e7          	jalr	272(ra) # 8000052a <panic>

0000000080003422 <fsinit>:
fsinit(int dev) {
    80003422:	7179                	addi	sp,sp,-48
    80003424:	f406                	sd	ra,40(sp)
    80003426:	f022                	sd	s0,32(sp)
    80003428:	ec26                	sd	s1,24(sp)
    8000342a:	e84a                	sd	s2,16(sp)
    8000342c:	e44e                	sd	s3,8(sp)
    8000342e:	1800                	addi	s0,sp,48
    80003430:	892a                	mv	s2,a0
  bp = bread(dev, 1);
    80003432:	4585                	li	a1,1
    80003434:	00000097          	auipc	ra,0x0
    80003438:	99e080e7          	jalr	-1634(ra) # 80002dd2 <bread>
    8000343c:	84aa                	mv	s1,a0
  memmove(sb, bp->data, sizeof(*sb));
    8000343e:	00017997          	auipc	s3,0x17
    80003442:	76298993          	addi	s3,s3,1890 # 8001aba0 <sb>
    80003446:	02000613          	li	a2,32
    8000344a:	05850593          	addi	a1,a0,88
    8000344e:	854e                	mv	a0,s3
    80003450:	ffffe097          	auipc	ra,0xffffe
    80003454:	8ca080e7          	jalr	-1846(ra) # 80000d1a <memmove>
  brelse(bp);
    80003458:	8526                	mv	a0,s1
    8000345a:	00000097          	auipc	ra,0x0
    8000345e:	aa8080e7          	jalr	-1368(ra) # 80002f02 <brelse>
  if(sb.magic != FSMAGIC)
    80003462:	0009a703          	lw	a4,0(s3)
    80003466:	102037b7          	lui	a5,0x10203
    8000346a:	04078793          	addi	a5,a5,64 # 10203040 <_entry-0x6fdfcfc0>
    8000346e:	02f71263          	bne	a4,a5,80003492 <fsinit+0x70>
  initlog(dev, &sb);
    80003472:	00017597          	auipc	a1,0x17
    80003476:	72e58593          	addi	a1,a1,1838 # 8001aba0 <sb>
    8000347a:	854a                	mv	a0,s2
    8000347c:	00001097          	auipc	ra,0x1
    80003480:	bf8080e7          	jalr	-1032(ra) # 80004074 <initlog>
}
    80003484:	70a2                	ld	ra,40(sp)
    80003486:	7402                	ld	s0,32(sp)
    80003488:	64e2                	ld	s1,24(sp)
    8000348a:	6942                	ld	s2,16(sp)
    8000348c:	69a2                	ld	s3,8(sp)
    8000348e:	6145                	addi	sp,sp,48
    80003490:	8082                	ret
    panic("invalid file system");
    80003492:	00005517          	auipc	a0,0x5
    80003496:	0d650513          	addi	a0,a0,214 # 80008568 <syscalls+0x148>
    8000349a:	ffffd097          	auipc	ra,0xffffd
    8000349e:	090080e7          	jalr	144(ra) # 8000052a <panic>

00000000800034a2 <iinit>:
{
    800034a2:	7179                	addi	sp,sp,-48
    800034a4:	f406                	sd	ra,40(sp)
    800034a6:	f022                	sd	s0,32(sp)
    800034a8:	ec26                	sd	s1,24(sp)
    800034aa:	e84a                	sd	s2,16(sp)
    800034ac:	e44e                	sd	s3,8(sp)
    800034ae:	1800                	addi	s0,sp,48
  initlock(&icache.lock, "icache");
    800034b0:	00005597          	auipc	a1,0x5
    800034b4:	0d058593          	addi	a1,a1,208 # 80008580 <syscalls+0x160>
    800034b8:	00017517          	auipc	a0,0x17
    800034bc:	70850513          	addi	a0,a0,1800 # 8001abc0 <icache>
    800034c0:	ffffd097          	auipc	ra,0xffffd
    800034c4:	672080e7          	jalr	1650(ra) # 80000b32 <initlock>
  for(i = 0; i < NINODE; i++) {
    800034c8:	00017497          	auipc	s1,0x17
    800034cc:	72048493          	addi	s1,s1,1824 # 8001abe8 <icache+0x28>
    800034d0:	00019997          	auipc	s3,0x19
    800034d4:	1a898993          	addi	s3,s3,424 # 8001c678 <log+0x10>
    initsleeplock(&icache.inode[i].lock, "inode");
    800034d8:	00005917          	auipc	s2,0x5
    800034dc:	0b090913          	addi	s2,s2,176 # 80008588 <syscalls+0x168>
    800034e0:	85ca                	mv	a1,s2
    800034e2:	8526                	mv	a0,s1
    800034e4:	00001097          	auipc	ra,0x1
    800034e8:	efa080e7          	jalr	-262(ra) # 800043de <initsleeplock>
  for(i = 0; i < NINODE; i++) {
    800034ec:	08848493          	addi	s1,s1,136
    800034f0:	ff3498e3          	bne	s1,s3,800034e0 <iinit+0x3e>
}
    800034f4:	70a2                	ld	ra,40(sp)
    800034f6:	7402                	ld	s0,32(sp)
    800034f8:	64e2                	ld	s1,24(sp)
    800034fa:	6942                	ld	s2,16(sp)
    800034fc:	69a2                	ld	s3,8(sp)
    800034fe:	6145                	addi	sp,sp,48
    80003500:	8082                	ret

0000000080003502 <ialloc>:
{
    80003502:	715d                	addi	sp,sp,-80
    80003504:	e486                	sd	ra,72(sp)
    80003506:	e0a2                	sd	s0,64(sp)
    80003508:	fc26                	sd	s1,56(sp)
    8000350a:	f84a                	sd	s2,48(sp)
    8000350c:	f44e                	sd	s3,40(sp)
    8000350e:	f052                	sd	s4,32(sp)
    80003510:	ec56                	sd	s5,24(sp)
    80003512:	e85a                	sd	s6,16(sp)
    80003514:	e45e                	sd	s7,8(sp)
    80003516:	0880                	addi	s0,sp,80
  for(inum = 1; inum < sb.ninodes; inum++){
    80003518:	00017717          	auipc	a4,0x17
    8000351c:	69472703          	lw	a4,1684(a4) # 8001abac <sb+0xc>
    80003520:	4785                	li	a5,1
    80003522:	04e7fa63          	bgeu	a5,a4,80003576 <ialloc+0x74>
    80003526:	8aaa                	mv	s5,a0
    80003528:	8bae                	mv	s7,a1
    8000352a:	4485                	li	s1,1
    bp = bread(dev, IBLOCK(inum, sb));
    8000352c:	00017a17          	auipc	s4,0x17
    80003530:	674a0a13          	addi	s4,s4,1652 # 8001aba0 <sb>
    80003534:	00048b1b          	sext.w	s6,s1
    80003538:	0044d793          	srli	a5,s1,0x4
    8000353c:	018a2583          	lw	a1,24(s4)
    80003540:	9dbd                	addw	a1,a1,a5
    80003542:	8556                	mv	a0,s5
    80003544:	00000097          	auipc	ra,0x0
    80003548:	88e080e7          	jalr	-1906(ra) # 80002dd2 <bread>
    8000354c:	892a                	mv	s2,a0
    dip = (struct dinode*)bp->data + inum%IPB;
    8000354e:	05850993          	addi	s3,a0,88
    80003552:	00f4f793          	andi	a5,s1,15
    80003556:	079a                	slli	a5,a5,0x6
    80003558:	99be                	add	s3,s3,a5
    if(dip->type == 0){  // a free inode
    8000355a:	00099783          	lh	a5,0(s3)
    8000355e:	c785                	beqz	a5,80003586 <ialloc+0x84>
    brelse(bp);
    80003560:	00000097          	auipc	ra,0x0
    80003564:	9a2080e7          	jalr	-1630(ra) # 80002f02 <brelse>
  for(inum = 1; inum < sb.ninodes; inum++){
    80003568:	0485                	addi	s1,s1,1
    8000356a:	00ca2703          	lw	a4,12(s4)
    8000356e:	0004879b          	sext.w	a5,s1
    80003572:	fce7e1e3          	bltu	a5,a4,80003534 <ialloc+0x32>
  panic("ialloc: no inodes");
    80003576:	00005517          	auipc	a0,0x5
    8000357a:	01a50513          	addi	a0,a0,26 # 80008590 <syscalls+0x170>
    8000357e:	ffffd097          	auipc	ra,0xffffd
    80003582:	fac080e7          	jalr	-84(ra) # 8000052a <panic>
      memset(dip, 0, sizeof(*dip));
    80003586:	04000613          	li	a2,64
    8000358a:	4581                	li	a1,0
    8000358c:	854e                	mv	a0,s3
    8000358e:	ffffd097          	auipc	ra,0xffffd
    80003592:	730080e7          	jalr	1840(ra) # 80000cbe <memset>
      dip->type = type;
    80003596:	01799023          	sh	s7,0(s3)
      log_write(bp);   // mark it allocated on the disk
    8000359a:	854a                	mv	a0,s2
    8000359c:	00001097          	auipc	ra,0x1
    800035a0:	d54080e7          	jalr	-684(ra) # 800042f0 <log_write>
      brelse(bp);
    800035a4:	854a                	mv	a0,s2
    800035a6:	00000097          	auipc	ra,0x0
    800035aa:	95c080e7          	jalr	-1700(ra) # 80002f02 <brelse>
      return iget(dev, inum);
    800035ae:	85da                	mv	a1,s6
    800035b0:	8556                	mv	a0,s5
    800035b2:	00000097          	auipc	ra,0x0
    800035b6:	db4080e7          	jalr	-588(ra) # 80003366 <iget>
}
    800035ba:	60a6                	ld	ra,72(sp)
    800035bc:	6406                	ld	s0,64(sp)
    800035be:	74e2                	ld	s1,56(sp)
    800035c0:	7942                	ld	s2,48(sp)
    800035c2:	79a2                	ld	s3,40(sp)
    800035c4:	7a02                	ld	s4,32(sp)
    800035c6:	6ae2                	ld	s5,24(sp)
    800035c8:	6b42                	ld	s6,16(sp)
    800035ca:	6ba2                	ld	s7,8(sp)
    800035cc:	6161                	addi	sp,sp,80
    800035ce:	8082                	ret

00000000800035d0 <iupdate>:
{
    800035d0:	1101                	addi	sp,sp,-32
    800035d2:	ec06                	sd	ra,24(sp)
    800035d4:	e822                	sd	s0,16(sp)
    800035d6:	e426                	sd	s1,8(sp)
    800035d8:	e04a                	sd	s2,0(sp)
    800035da:	1000                	addi	s0,sp,32
    800035dc:	84aa                	mv	s1,a0
  bp = bread(ip->dev, IBLOCK(ip->inum, sb));
    800035de:	415c                	lw	a5,4(a0)
    800035e0:	0047d79b          	srliw	a5,a5,0x4
    800035e4:	00017597          	auipc	a1,0x17
    800035e8:	5d45a583          	lw	a1,1492(a1) # 8001abb8 <sb+0x18>
    800035ec:	9dbd                	addw	a1,a1,a5
    800035ee:	4108                	lw	a0,0(a0)
    800035f0:	fffff097          	auipc	ra,0xfffff
    800035f4:	7e2080e7          	jalr	2018(ra) # 80002dd2 <bread>
    800035f8:	892a                	mv	s2,a0
  dip = (struct dinode*)bp->data + ip->inum%IPB;
    800035fa:	05850793          	addi	a5,a0,88
    800035fe:	40c8                	lw	a0,4(s1)
    80003600:	893d                	andi	a0,a0,15
    80003602:	051a                	slli	a0,a0,0x6
    80003604:	953e                	add	a0,a0,a5
  dip->type = ip->type;
    80003606:	04449703          	lh	a4,68(s1)
    8000360a:	00e51023          	sh	a4,0(a0)
  dip->major = ip->major;
    8000360e:	04649703          	lh	a4,70(s1)
    80003612:	00e51123          	sh	a4,2(a0)
  dip->minor = ip->minor;
    80003616:	04849703          	lh	a4,72(s1)
    8000361a:	00e51223          	sh	a4,4(a0)
  dip->nlink = ip->nlink;
    8000361e:	04a49703          	lh	a4,74(s1)
    80003622:	00e51323          	sh	a4,6(a0)
  dip->size = ip->size;
    80003626:	44f8                	lw	a4,76(s1)
    80003628:	c518                	sw	a4,8(a0)
  memmove(dip->addrs, ip->addrs, sizeof(ip->addrs));
    8000362a:	03400613          	li	a2,52
    8000362e:	05048593          	addi	a1,s1,80
    80003632:	0531                	addi	a0,a0,12
    80003634:	ffffd097          	auipc	ra,0xffffd
    80003638:	6e6080e7          	jalr	1766(ra) # 80000d1a <memmove>
  log_write(bp);
    8000363c:	854a                	mv	a0,s2
    8000363e:	00001097          	auipc	ra,0x1
    80003642:	cb2080e7          	jalr	-846(ra) # 800042f0 <log_write>
  brelse(bp);
    80003646:	854a                	mv	a0,s2
    80003648:	00000097          	auipc	ra,0x0
    8000364c:	8ba080e7          	jalr	-1862(ra) # 80002f02 <brelse>
}
    80003650:	60e2                	ld	ra,24(sp)
    80003652:	6442                	ld	s0,16(sp)
    80003654:	64a2                	ld	s1,8(sp)
    80003656:	6902                	ld	s2,0(sp)
    80003658:	6105                	addi	sp,sp,32
    8000365a:	8082                	ret

000000008000365c <idup>:
{
    8000365c:	1101                	addi	sp,sp,-32
    8000365e:	ec06                	sd	ra,24(sp)
    80003660:	e822                	sd	s0,16(sp)
    80003662:	e426                	sd	s1,8(sp)
    80003664:	1000                	addi	s0,sp,32
    80003666:	84aa                	mv	s1,a0
  acquire(&icache.lock);
    80003668:	00017517          	auipc	a0,0x17
    8000366c:	55850513          	addi	a0,a0,1368 # 8001abc0 <icache>
    80003670:	ffffd097          	auipc	ra,0xffffd
    80003674:	552080e7          	jalr	1362(ra) # 80000bc2 <acquire>
  ip->ref++;
    80003678:	449c                	lw	a5,8(s1)
    8000367a:	2785                	addiw	a5,a5,1
    8000367c:	c49c                	sw	a5,8(s1)
  release(&icache.lock);
    8000367e:	00017517          	auipc	a0,0x17
    80003682:	54250513          	addi	a0,a0,1346 # 8001abc0 <icache>
    80003686:	ffffd097          	auipc	ra,0xffffd
    8000368a:	5f0080e7          	jalr	1520(ra) # 80000c76 <release>
}
    8000368e:	8526                	mv	a0,s1
    80003690:	60e2                	ld	ra,24(sp)
    80003692:	6442                	ld	s0,16(sp)
    80003694:	64a2                	ld	s1,8(sp)
    80003696:	6105                	addi	sp,sp,32
    80003698:	8082                	ret

000000008000369a <ilock>:
{
    8000369a:	1101                	addi	sp,sp,-32
    8000369c:	ec06                	sd	ra,24(sp)
    8000369e:	e822                	sd	s0,16(sp)
    800036a0:	e426                	sd	s1,8(sp)
    800036a2:	e04a                	sd	s2,0(sp)
    800036a4:	1000                	addi	s0,sp,32
  if(ip == 0 || ip->ref < 1)
    800036a6:	c115                	beqz	a0,800036ca <ilock+0x30>
    800036a8:	84aa                	mv	s1,a0
    800036aa:	451c                	lw	a5,8(a0)
    800036ac:	00f05f63          	blez	a5,800036ca <ilock+0x30>
  acquiresleep(&ip->lock);
    800036b0:	0541                	addi	a0,a0,16
    800036b2:	00001097          	auipc	ra,0x1
    800036b6:	d66080e7          	jalr	-666(ra) # 80004418 <acquiresleep>
  if(ip->valid == 0){
    800036ba:	40bc                	lw	a5,64(s1)
    800036bc:	cf99                	beqz	a5,800036da <ilock+0x40>
}
    800036be:	60e2                	ld	ra,24(sp)
    800036c0:	6442                	ld	s0,16(sp)
    800036c2:	64a2                	ld	s1,8(sp)
    800036c4:	6902                	ld	s2,0(sp)
    800036c6:	6105                	addi	sp,sp,32
    800036c8:	8082                	ret
    panic("ilock");
    800036ca:	00005517          	auipc	a0,0x5
    800036ce:	ede50513          	addi	a0,a0,-290 # 800085a8 <syscalls+0x188>
    800036d2:	ffffd097          	auipc	ra,0xffffd
    800036d6:	e58080e7          	jalr	-424(ra) # 8000052a <panic>
    bp = bread(ip->dev, IBLOCK(ip->inum, sb));
    800036da:	40dc                	lw	a5,4(s1)
    800036dc:	0047d79b          	srliw	a5,a5,0x4
    800036e0:	00017597          	auipc	a1,0x17
    800036e4:	4d85a583          	lw	a1,1240(a1) # 8001abb8 <sb+0x18>
    800036e8:	9dbd                	addw	a1,a1,a5
    800036ea:	4088                	lw	a0,0(s1)
    800036ec:	fffff097          	auipc	ra,0xfffff
    800036f0:	6e6080e7          	jalr	1766(ra) # 80002dd2 <bread>
    800036f4:	892a                	mv	s2,a0
    dip = (struct dinode*)bp->data + ip->inum%IPB;
    800036f6:	05850593          	addi	a1,a0,88
    800036fa:	40dc                	lw	a5,4(s1)
    800036fc:	8bbd                	andi	a5,a5,15
    800036fe:	079a                	slli	a5,a5,0x6
    80003700:	95be                	add	a1,a1,a5
    ip->type = dip->type;
    80003702:	00059783          	lh	a5,0(a1)
    80003706:	04f49223          	sh	a5,68(s1)
    ip->major = dip->major;
    8000370a:	00259783          	lh	a5,2(a1)
    8000370e:	04f49323          	sh	a5,70(s1)
    ip->minor = dip->minor;
    80003712:	00459783          	lh	a5,4(a1)
    80003716:	04f49423          	sh	a5,72(s1)
    ip->nlink = dip->nlink;
    8000371a:	00659783          	lh	a5,6(a1)
    8000371e:	04f49523          	sh	a5,74(s1)
    ip->size = dip->size;
    80003722:	459c                	lw	a5,8(a1)
    80003724:	c4fc                	sw	a5,76(s1)
    memmove(ip->addrs, dip->addrs, sizeof(ip->addrs));
    80003726:	03400613          	li	a2,52
    8000372a:	05b1                	addi	a1,a1,12
    8000372c:	05048513          	addi	a0,s1,80
    80003730:	ffffd097          	auipc	ra,0xffffd
    80003734:	5ea080e7          	jalr	1514(ra) # 80000d1a <memmove>
    brelse(bp);
    80003738:	854a                	mv	a0,s2
    8000373a:	fffff097          	auipc	ra,0xfffff
    8000373e:	7c8080e7          	jalr	1992(ra) # 80002f02 <brelse>
    ip->valid = 1;
    80003742:	4785                	li	a5,1
    80003744:	c0bc                	sw	a5,64(s1)
    if(ip->type == 0)
    80003746:	04449783          	lh	a5,68(s1)
    8000374a:	fbb5                	bnez	a5,800036be <ilock+0x24>
      panic("ilock: no type");
    8000374c:	00005517          	auipc	a0,0x5
    80003750:	e6450513          	addi	a0,a0,-412 # 800085b0 <syscalls+0x190>
    80003754:	ffffd097          	auipc	ra,0xffffd
    80003758:	dd6080e7          	jalr	-554(ra) # 8000052a <panic>

000000008000375c <iunlock>:
{
    8000375c:	1101                	addi	sp,sp,-32
    8000375e:	ec06                	sd	ra,24(sp)
    80003760:	e822                	sd	s0,16(sp)
    80003762:	e426                	sd	s1,8(sp)
    80003764:	e04a                	sd	s2,0(sp)
    80003766:	1000                	addi	s0,sp,32
  if(ip == 0 || !holdingsleep(&ip->lock) || ip->ref < 1)
    80003768:	c905                	beqz	a0,80003798 <iunlock+0x3c>
    8000376a:	84aa                	mv	s1,a0
    8000376c:	01050913          	addi	s2,a0,16
    80003770:	854a                	mv	a0,s2
    80003772:	00001097          	auipc	ra,0x1
    80003776:	d40080e7          	jalr	-704(ra) # 800044b2 <holdingsleep>
    8000377a:	cd19                	beqz	a0,80003798 <iunlock+0x3c>
    8000377c:	449c                	lw	a5,8(s1)
    8000377e:	00f05d63          	blez	a5,80003798 <iunlock+0x3c>
  releasesleep(&ip->lock);
    80003782:	854a                	mv	a0,s2
    80003784:	00001097          	auipc	ra,0x1
    80003788:	cea080e7          	jalr	-790(ra) # 8000446e <releasesleep>
}
    8000378c:	60e2                	ld	ra,24(sp)
    8000378e:	6442                	ld	s0,16(sp)
    80003790:	64a2                	ld	s1,8(sp)
    80003792:	6902                	ld	s2,0(sp)
    80003794:	6105                	addi	sp,sp,32
    80003796:	8082                	ret
    panic("iunlock");
    80003798:	00005517          	auipc	a0,0x5
    8000379c:	e2850513          	addi	a0,a0,-472 # 800085c0 <syscalls+0x1a0>
    800037a0:	ffffd097          	auipc	ra,0xffffd
    800037a4:	d8a080e7          	jalr	-630(ra) # 8000052a <panic>

00000000800037a8 <itrunc>:

// Truncate inode (discard contents).
// Caller must hold ip->lock.
void
itrunc(struct inode *ip)
{
    800037a8:	715d                	addi	sp,sp,-80
    800037aa:	e486                	sd	ra,72(sp)
    800037ac:	e0a2                	sd	s0,64(sp)
    800037ae:	fc26                	sd	s1,56(sp)
    800037b0:	f84a                	sd	s2,48(sp)
    800037b2:	f44e                	sd	s3,40(sp)
    800037b4:	f052                	sd	s4,32(sp)
    800037b6:	ec56                	sd	s5,24(sp)
    800037b8:	e85a                	sd	s6,16(sp)
    800037ba:	e45e                	sd	s7,8(sp)
    800037bc:	e062                	sd	s8,0(sp)
    800037be:	0880                	addi	s0,sp,80
    800037c0:	89aa                	mv	s3,a0
  int i, j;
  struct buf *bp1, *bp2;
  uint *a1, *a2;

  for(i = 0; i < NDIRECT; i++){  //free direct blocks
    800037c2:	05050493          	addi	s1,a0,80
    800037c6:	07c50913          	addi	s2,a0,124
    800037ca:	a021                	j	800037d2 <itrunc+0x2a>
    800037cc:	0491                	addi	s1,s1,4
    800037ce:	01248d63          	beq	s1,s2,800037e8 <itrunc+0x40>
    if(ip->addrs[i]){
    800037d2:	408c                	lw	a1,0(s1)
    800037d4:	dde5                	beqz	a1,800037cc <itrunc+0x24>
      bfree(ip->dev, ip->addrs[i]);
    800037d6:	0009a503          	lw	a0,0(s3)
    800037da:	00000097          	auipc	ra,0x0
    800037de:	83e080e7          	jalr	-1986(ra) # 80003018 <bfree>
      ip->addrs[i] = 0;
    800037e2:	0004a023          	sw	zero,0(s1)
    800037e6:	b7dd                	j	800037cc <itrunc+0x24>
    }
  }

  if(ip->addrs[NDIRECT]){  //free first-level blocks
    800037e8:	07c9a583          	lw	a1,124(s3)
    800037ec:	e59d                	bnez	a1,8000381a <itrunc+0x72>
    brelse(bp1);
    bfree(ip->dev, ip->addrs[NDIRECT]);
    ip->addrs[NDIRECT] = 0;
  }

  if (ip->addrs[NDIRECT + 1]) {  //free second-level blocks
    800037ee:	0809a583          	lw	a1,128(s3)
    800037f2:	eda5                	bnez	a1,8000386a <itrunc+0xc2>
    brelse(bp1);
    bfree(ip->dev, ip->addrs[NDIRECT + 1]);
    ip->addrs[NDIRECT + 1] = 0;
  }

  ip->size = 0;
    800037f4:	0409a623          	sw	zero,76(s3)
  iupdate(ip);
    800037f8:	854e                	mv	a0,s3
    800037fa:	00000097          	auipc	ra,0x0
    800037fe:	dd6080e7          	jalr	-554(ra) # 800035d0 <iupdate>
}
    80003802:	60a6                	ld	ra,72(sp)
    80003804:	6406                	ld	s0,64(sp)
    80003806:	74e2                	ld	s1,56(sp)
    80003808:	7942                	ld	s2,48(sp)
    8000380a:	79a2                	ld	s3,40(sp)
    8000380c:	7a02                	ld	s4,32(sp)
    8000380e:	6ae2                	ld	s5,24(sp)
    80003810:	6b42                	ld	s6,16(sp)
    80003812:	6ba2                	ld	s7,8(sp)
    80003814:	6c02                	ld	s8,0(sp)
    80003816:	6161                	addi	sp,sp,80
    80003818:	8082                	ret
    bp1 = bread(ip->dev, ip->addrs[NDIRECT]);
    8000381a:	0009a503          	lw	a0,0(s3)
    8000381e:	fffff097          	auipc	ra,0xfffff
    80003822:	5b4080e7          	jalr	1460(ra) # 80002dd2 <bread>
    80003826:	8a2a                	mv	s4,a0
    for(j = 0; j < NINDIRECT1; j++){
    80003828:	05850493          	addi	s1,a0,88
    8000382c:	45850913          	addi	s2,a0,1112
    80003830:	a021                	j	80003838 <itrunc+0x90>
    80003832:	0491                	addi	s1,s1,4
    80003834:	01248b63          	beq	s1,s2,8000384a <itrunc+0xa2>
      if(a1[j])
    80003838:	408c                	lw	a1,0(s1)
    8000383a:	dde5                	beqz	a1,80003832 <itrunc+0x8a>
        bfree(ip->dev, a1[j]);
    8000383c:	0009a503          	lw	a0,0(s3)
    80003840:	fffff097          	auipc	ra,0xfffff
    80003844:	7d8080e7          	jalr	2008(ra) # 80003018 <bfree>
    80003848:	b7ed                	j	80003832 <itrunc+0x8a>
    brelse(bp1);
    8000384a:	8552                	mv	a0,s4
    8000384c:	fffff097          	auipc	ra,0xfffff
    80003850:	6b6080e7          	jalr	1718(ra) # 80002f02 <brelse>
    bfree(ip->dev, ip->addrs[NDIRECT]);
    80003854:	07c9a583          	lw	a1,124(s3)
    80003858:	0009a503          	lw	a0,0(s3)
    8000385c:	fffff097          	auipc	ra,0xfffff
    80003860:	7bc080e7          	jalr	1980(ra) # 80003018 <bfree>
    ip->addrs[NDIRECT] = 0;
    80003864:	0609ae23          	sw	zero,124(s3)
    80003868:	b759                	j	800037ee <itrunc+0x46>
    bp1 = bread(ip->dev, ip->addrs[NDIRECT + 1]);
    8000386a:	0009a503          	lw	a0,0(s3)
    8000386e:	fffff097          	auipc	ra,0xfffff
    80003872:	564080e7          	jalr	1380(ra) # 80002dd2 <bread>
    80003876:	8c2a                	mv	s8,a0
    for(i = 0; i < NINDIRECT1; i++) {
    80003878:	05850a13          	addi	s4,a0,88
    8000387c:	45850b13          	addi	s6,a0,1112
    80003880:	a83d                	j	800038be <itrunc+0x116>
        for (j = 0; j < NINDIRECT1; j++) {
    80003882:	0491                	addi	s1,s1,4
    80003884:	00990b63          	beq	s2,s1,8000389a <itrunc+0xf2>
          if (a2[j])
    80003888:	408c                	lw	a1,0(s1)
    8000388a:	dde5                	beqz	a1,80003882 <itrunc+0xda>
            bfree(ip->dev, a2[j]);
    8000388c:	0009a503          	lw	a0,0(s3)
    80003890:	fffff097          	auipc	ra,0xfffff
    80003894:	788080e7          	jalr	1928(ra) # 80003018 <bfree>
    80003898:	b7ed                	j	80003882 <itrunc+0xda>
        brelse(bp2);
    8000389a:	855e                	mv	a0,s7
    8000389c:	fffff097          	auipc	ra,0xfffff
    800038a0:	666080e7          	jalr	1638(ra) # 80002f02 <brelse>
        bfree(ip->dev, a1[i]);
    800038a4:	000aa583          	lw	a1,0(s5)
    800038a8:	0009a503          	lw	a0,0(s3)
    800038ac:	fffff097          	auipc	ra,0xfffff
    800038b0:	76c080e7          	jalr	1900(ra) # 80003018 <bfree>
        a1[i] = 0;
    800038b4:	000aa023          	sw	zero,0(s5)
    for(i = 0; i < NINDIRECT1; i++) {
    800038b8:	0a11                	addi	s4,s4,4
    800038ba:	036a0263          	beq	s4,s6,800038de <itrunc+0x136>
      if (a1[i]) {
    800038be:	8ad2                	mv	s5,s4
    800038c0:	000a2583          	lw	a1,0(s4)
    800038c4:	d9f5                	beqz	a1,800038b8 <itrunc+0x110>
        bp2 = bread(ip->dev, a1[i]);
    800038c6:	0009a503          	lw	a0,0(s3)
    800038ca:	fffff097          	auipc	ra,0xfffff
    800038ce:	508080e7          	jalr	1288(ra) # 80002dd2 <bread>
    800038d2:	8baa                	mv	s7,a0
        for (j = 0; j < NINDIRECT1; j++) {
    800038d4:	05850493          	addi	s1,a0,88
    800038d8:	45850913          	addi	s2,a0,1112
    800038dc:	b775                	j	80003888 <itrunc+0xe0>
    brelse(bp1);
    800038de:	8562                	mv	a0,s8
    800038e0:	fffff097          	auipc	ra,0xfffff
    800038e4:	622080e7          	jalr	1570(ra) # 80002f02 <brelse>
    bfree(ip->dev, ip->addrs[NDIRECT + 1]);
    800038e8:	0809a583          	lw	a1,128(s3)
    800038ec:	0009a503          	lw	a0,0(s3)
    800038f0:	fffff097          	auipc	ra,0xfffff
    800038f4:	728080e7          	jalr	1832(ra) # 80003018 <bfree>
    ip->addrs[NDIRECT + 1] = 0;
    800038f8:	0809a023          	sw	zero,128(s3)
    800038fc:	bde5                	j	800037f4 <itrunc+0x4c>

00000000800038fe <iput>:
{
    800038fe:	1101                	addi	sp,sp,-32
    80003900:	ec06                	sd	ra,24(sp)
    80003902:	e822                	sd	s0,16(sp)
    80003904:	e426                	sd	s1,8(sp)
    80003906:	e04a                	sd	s2,0(sp)
    80003908:	1000                	addi	s0,sp,32
    8000390a:	84aa                	mv	s1,a0
  acquire(&icache.lock);
    8000390c:	00017517          	auipc	a0,0x17
    80003910:	2b450513          	addi	a0,a0,692 # 8001abc0 <icache>
    80003914:	ffffd097          	auipc	ra,0xffffd
    80003918:	2ae080e7          	jalr	686(ra) # 80000bc2 <acquire>
  if(ip->ref == 1 && ip->valid && ip->nlink == 0){
    8000391c:	4498                	lw	a4,8(s1)
    8000391e:	4785                	li	a5,1
    80003920:	02f70363          	beq	a4,a5,80003946 <iput+0x48>
  ip->ref--;
    80003924:	449c                	lw	a5,8(s1)
    80003926:	37fd                	addiw	a5,a5,-1
    80003928:	c49c                	sw	a5,8(s1)
  release(&icache.lock);
    8000392a:	00017517          	auipc	a0,0x17
    8000392e:	29650513          	addi	a0,a0,662 # 8001abc0 <icache>
    80003932:	ffffd097          	auipc	ra,0xffffd
    80003936:	344080e7          	jalr	836(ra) # 80000c76 <release>
}
    8000393a:	60e2                	ld	ra,24(sp)
    8000393c:	6442                	ld	s0,16(sp)
    8000393e:	64a2                	ld	s1,8(sp)
    80003940:	6902                	ld	s2,0(sp)
    80003942:	6105                	addi	sp,sp,32
    80003944:	8082                	ret
  if(ip->ref == 1 && ip->valid && ip->nlink == 0){
    80003946:	40bc                	lw	a5,64(s1)
    80003948:	dff1                	beqz	a5,80003924 <iput+0x26>
    8000394a:	04a49783          	lh	a5,74(s1)
    8000394e:	fbf9                	bnez	a5,80003924 <iput+0x26>
    acquiresleep(&ip->lock);
    80003950:	01048913          	addi	s2,s1,16
    80003954:	854a                	mv	a0,s2
    80003956:	00001097          	auipc	ra,0x1
    8000395a:	ac2080e7          	jalr	-1342(ra) # 80004418 <acquiresleep>
    release(&icache.lock);
    8000395e:	00017517          	auipc	a0,0x17
    80003962:	26250513          	addi	a0,a0,610 # 8001abc0 <icache>
    80003966:	ffffd097          	auipc	ra,0xffffd
    8000396a:	310080e7          	jalr	784(ra) # 80000c76 <release>
    itrunc(ip);
    8000396e:	8526                	mv	a0,s1
    80003970:	00000097          	auipc	ra,0x0
    80003974:	e38080e7          	jalr	-456(ra) # 800037a8 <itrunc>
    ip->type = 0;
    80003978:	04049223          	sh	zero,68(s1)
    iupdate(ip);
    8000397c:	8526                	mv	a0,s1
    8000397e:	00000097          	auipc	ra,0x0
    80003982:	c52080e7          	jalr	-942(ra) # 800035d0 <iupdate>
    ip->valid = 0;
    80003986:	0404a023          	sw	zero,64(s1)
    releasesleep(&ip->lock);
    8000398a:	854a                	mv	a0,s2
    8000398c:	00001097          	auipc	ra,0x1
    80003990:	ae2080e7          	jalr	-1310(ra) # 8000446e <releasesleep>
    acquire(&icache.lock);
    80003994:	00017517          	auipc	a0,0x17
    80003998:	22c50513          	addi	a0,a0,556 # 8001abc0 <icache>
    8000399c:	ffffd097          	auipc	ra,0xffffd
    800039a0:	226080e7          	jalr	550(ra) # 80000bc2 <acquire>
    800039a4:	b741                	j	80003924 <iput+0x26>

00000000800039a6 <iunlockput>:
{
    800039a6:	1101                	addi	sp,sp,-32
    800039a8:	ec06                	sd	ra,24(sp)
    800039aa:	e822                	sd	s0,16(sp)
    800039ac:	e426                	sd	s1,8(sp)
    800039ae:	1000                	addi	s0,sp,32
    800039b0:	84aa                	mv	s1,a0
  iunlock(ip);
    800039b2:	00000097          	auipc	ra,0x0
    800039b6:	daa080e7          	jalr	-598(ra) # 8000375c <iunlock>
  iput(ip);
    800039ba:	8526                	mv	a0,s1
    800039bc:	00000097          	auipc	ra,0x0
    800039c0:	f42080e7          	jalr	-190(ra) # 800038fe <iput>
}
    800039c4:	60e2                	ld	ra,24(sp)
    800039c6:	6442                	ld	s0,16(sp)
    800039c8:	64a2                	ld	s1,8(sp)
    800039ca:	6105                	addi	sp,sp,32
    800039cc:	8082                	ret

00000000800039ce <stati>:

// Copy stat information from inode.
// Caller must hold ip->lock.
void
stati(struct inode *ip, struct stat *st)
{
    800039ce:	1141                	addi	sp,sp,-16
    800039d0:	e422                	sd	s0,8(sp)
    800039d2:	0800                	addi	s0,sp,16
  st->dev = ip->dev;
    800039d4:	411c                	lw	a5,0(a0)
    800039d6:	c19c                	sw	a5,0(a1)
  st->ino = ip->inum;
    800039d8:	415c                	lw	a5,4(a0)
    800039da:	c1dc                	sw	a5,4(a1)
  st->type = ip->type;
    800039dc:	04451783          	lh	a5,68(a0)
    800039e0:	00f59423          	sh	a5,8(a1)
  st->nlink = ip->nlink;
    800039e4:	04a51783          	lh	a5,74(a0)
    800039e8:	00f59523          	sh	a5,10(a1)
  st->size = ip->size;
    800039ec:	04c56783          	lwu	a5,76(a0)
    800039f0:	e99c                	sd	a5,16(a1)
}
    800039f2:	6422                	ld	s0,8(sp)
    800039f4:	0141                	addi	sp,sp,16
    800039f6:	8082                	ret

00000000800039f8 <readi>:
readi(struct inode *ip, int user_dst, uint64 dst, uint off, uint n)
{
  uint tot, m;
  struct buf *bp;

  if(off > ip->size || off + n < off)
    800039f8:	457c                	lw	a5,76(a0)
    800039fa:	0ed7e963          	bltu	a5,a3,80003aec <readi+0xf4>
{
    800039fe:	7159                	addi	sp,sp,-112
    80003a00:	f486                	sd	ra,104(sp)
    80003a02:	f0a2                	sd	s0,96(sp)
    80003a04:	eca6                	sd	s1,88(sp)
    80003a06:	e8ca                	sd	s2,80(sp)
    80003a08:	e4ce                	sd	s3,72(sp)
    80003a0a:	e0d2                	sd	s4,64(sp)
    80003a0c:	fc56                	sd	s5,56(sp)
    80003a0e:	f85a                	sd	s6,48(sp)
    80003a10:	f45e                	sd	s7,40(sp)
    80003a12:	f062                	sd	s8,32(sp)
    80003a14:	ec66                	sd	s9,24(sp)
    80003a16:	e86a                	sd	s10,16(sp)
    80003a18:	e46e                	sd	s11,8(sp)
    80003a1a:	1880                	addi	s0,sp,112
    80003a1c:	8baa                	mv	s7,a0
    80003a1e:	8c2e                	mv	s8,a1
    80003a20:	8ab2                	mv	s5,a2
    80003a22:	84b6                	mv	s1,a3
    80003a24:	8b3a                	mv	s6,a4
  if(off > ip->size || off + n < off)
    80003a26:	9f35                	addw	a4,a4,a3
    return 0;
    80003a28:	4501                	li	a0,0
  if(off > ip->size || off + n < off)
    80003a2a:	0ad76063          	bltu	a4,a3,80003aca <readi+0xd2>
  if(off + n > ip->size)
    80003a2e:	00e7f463          	bgeu	a5,a4,80003a36 <readi+0x3e>
    n = ip->size - off;
    80003a32:	40d78b3b          	subw	s6,a5,a3

  for(tot=0; tot<n; tot+=m, off+=m, dst+=m){
    80003a36:	0a0b0963          	beqz	s6,80003ae8 <readi+0xf0>
    80003a3a:	4981                	li	s3,0
    bp = bread(ip->dev, bmap(ip, off/BSIZE));
    m = min(n - tot, BSIZE - off%BSIZE);
    80003a3c:	40000d13          	li	s10,1024
    if(either_copyout(user_dst, dst, bp->data + (off % BSIZE), m) == -1) {
    80003a40:	5cfd                	li	s9,-1
    80003a42:	a82d                	j	80003a7c <readi+0x84>
    80003a44:	020a1d93          	slli	s11,s4,0x20
    80003a48:	020ddd93          	srli	s11,s11,0x20
    80003a4c:	05890793          	addi	a5,s2,88
    80003a50:	86ee                	mv	a3,s11
    80003a52:	963e                	add	a2,a2,a5
    80003a54:	85d6                	mv	a1,s5
    80003a56:	8562                	mv	a0,s8
    80003a58:	fffff097          	auipc	ra,0xfffff
    80003a5c:	9c0080e7          	jalr	-1600(ra) # 80002418 <either_copyout>
    80003a60:	05950d63          	beq	a0,s9,80003aba <readi+0xc2>
      brelse(bp);
      tot = -1;
      break;
    }
    brelse(bp);
    80003a64:	854a                	mv	a0,s2
    80003a66:	fffff097          	auipc	ra,0xfffff
    80003a6a:	49c080e7          	jalr	1180(ra) # 80002f02 <brelse>
  for(tot=0; tot<n; tot+=m, off+=m, dst+=m){
    80003a6e:	013a09bb          	addw	s3,s4,s3
    80003a72:	009a04bb          	addw	s1,s4,s1
    80003a76:	9aee                	add	s5,s5,s11
    80003a78:	0569f763          	bgeu	s3,s6,80003ac6 <readi+0xce>
    bp = bread(ip->dev, bmap(ip, off/BSIZE));
    80003a7c:	000ba903          	lw	s2,0(s7)
    80003a80:	00a4d59b          	srliw	a1,s1,0xa
    80003a84:	855e                	mv	a0,s7
    80003a86:	fffff097          	auipc	ra,0xfffff
    80003a8a:	740080e7          	jalr	1856(ra) # 800031c6 <bmap>
    80003a8e:	0005059b          	sext.w	a1,a0
    80003a92:	854a                	mv	a0,s2
    80003a94:	fffff097          	auipc	ra,0xfffff
    80003a98:	33e080e7          	jalr	830(ra) # 80002dd2 <bread>
    80003a9c:	892a                	mv	s2,a0
    m = min(n - tot, BSIZE - off%BSIZE);
    80003a9e:	3ff4f613          	andi	a2,s1,1023
    80003aa2:	40cd07bb          	subw	a5,s10,a2
    80003aa6:	413b073b          	subw	a4,s6,s3
    80003aaa:	8a3e                	mv	s4,a5
    80003aac:	2781                	sext.w	a5,a5
    80003aae:	0007069b          	sext.w	a3,a4
    80003ab2:	f8f6f9e3          	bgeu	a3,a5,80003a44 <readi+0x4c>
    80003ab6:	8a3a                	mv	s4,a4
    80003ab8:	b771                	j	80003a44 <readi+0x4c>
      brelse(bp);
    80003aba:	854a                	mv	a0,s2
    80003abc:	fffff097          	auipc	ra,0xfffff
    80003ac0:	446080e7          	jalr	1094(ra) # 80002f02 <brelse>
      tot = -1;
    80003ac4:	59fd                	li	s3,-1
  }
  return tot;
    80003ac6:	0009851b          	sext.w	a0,s3
}
    80003aca:	70a6                	ld	ra,104(sp)
    80003acc:	7406                	ld	s0,96(sp)
    80003ace:	64e6                	ld	s1,88(sp)
    80003ad0:	6946                	ld	s2,80(sp)
    80003ad2:	69a6                	ld	s3,72(sp)
    80003ad4:	6a06                	ld	s4,64(sp)
    80003ad6:	7ae2                	ld	s5,56(sp)
    80003ad8:	7b42                	ld	s6,48(sp)
    80003ada:	7ba2                	ld	s7,40(sp)
    80003adc:	7c02                	ld	s8,32(sp)
    80003ade:	6ce2                	ld	s9,24(sp)
    80003ae0:	6d42                	ld	s10,16(sp)
    80003ae2:	6da2                	ld	s11,8(sp)
    80003ae4:	6165                	addi	sp,sp,112
    80003ae6:	8082                	ret
  for(tot=0; tot<n; tot+=m, off+=m, dst+=m){
    80003ae8:	89da                	mv	s3,s6
    80003aea:	bff1                	j	80003ac6 <readi+0xce>
    return 0;
    80003aec:	4501                	li	a0,0
}
    80003aee:	8082                	ret

0000000080003af0 <writei>:
writei(struct inode *ip, int user_src, uint64 src, uint off, uint n)
{
  uint tot, m;
  struct buf *bp;

  if(off > ip->size || off + n < off)
    80003af0:	457c                	lw	a5,76(a0)
    80003af2:	10d7e963          	bltu	a5,a3,80003c04 <writei+0x114>
{
    80003af6:	7159                	addi	sp,sp,-112
    80003af8:	f486                	sd	ra,104(sp)
    80003afa:	f0a2                	sd	s0,96(sp)
    80003afc:	eca6                	sd	s1,88(sp)
    80003afe:	e8ca                	sd	s2,80(sp)
    80003b00:	e4ce                	sd	s3,72(sp)
    80003b02:	e0d2                	sd	s4,64(sp)
    80003b04:	fc56                	sd	s5,56(sp)
    80003b06:	f85a                	sd	s6,48(sp)
    80003b08:	f45e                	sd	s7,40(sp)
    80003b0a:	f062                	sd	s8,32(sp)
    80003b0c:	ec66                	sd	s9,24(sp)
    80003b0e:	e86a                	sd	s10,16(sp)
    80003b10:	e46e                	sd	s11,8(sp)
    80003b12:	1880                	addi	s0,sp,112
    80003b14:	8b2a                	mv	s6,a0
    80003b16:	8c2e                	mv	s8,a1
    80003b18:	8ab2                	mv	s5,a2
    80003b1a:	8936                	mv	s2,a3
    80003b1c:	8bba                	mv	s7,a4
  if(off > ip->size || off + n < off)
    80003b1e:	9f35                	addw	a4,a4,a3
    80003b20:	0ed76463          	bltu	a4,a3,80003c08 <writei+0x118>
    return -1;
  if(off + n > MAXFILE*BSIZE)
    80003b24:	040437b7          	lui	a5,0x4043
    80003b28:	c0078793          	addi	a5,a5,-1024 # 4042c00 <_entry-0x7bfbd400>
    80003b2c:	0ee7e063          	bltu	a5,a4,80003c0c <writei+0x11c>
    return -1;

  for(tot=0; tot<n; tot+=m, off+=m, src+=m){
    80003b30:	0c0b8863          	beqz	s7,80003c00 <writei+0x110>
    80003b34:	4a01                	li	s4,0
    bp = bread(ip->dev, bmap(ip, off/BSIZE));
    m = min(n - tot, BSIZE - off%BSIZE);
    80003b36:	40000d13          	li	s10,1024
    if(either_copyin(bp->data + (off % BSIZE), user_src, src, m) == -1) {
    80003b3a:	5cfd                	li	s9,-1
    80003b3c:	a091                	j	80003b80 <writei+0x90>
    80003b3e:	02099d93          	slli	s11,s3,0x20
    80003b42:	020ddd93          	srli	s11,s11,0x20
    80003b46:	05848793          	addi	a5,s1,88
    80003b4a:	86ee                	mv	a3,s11
    80003b4c:	8656                	mv	a2,s5
    80003b4e:	85e2                	mv	a1,s8
    80003b50:	953e                	add	a0,a0,a5
    80003b52:	fffff097          	auipc	ra,0xfffff
    80003b56:	91c080e7          	jalr	-1764(ra) # 8000246e <either_copyin>
    80003b5a:	07950263          	beq	a0,s9,80003bbe <writei+0xce>
      brelse(bp);
      break;
    }
    log_write(bp);
    80003b5e:	8526                	mv	a0,s1
    80003b60:	00000097          	auipc	ra,0x0
    80003b64:	790080e7          	jalr	1936(ra) # 800042f0 <log_write>
    brelse(bp);
    80003b68:	8526                	mv	a0,s1
    80003b6a:	fffff097          	auipc	ra,0xfffff
    80003b6e:	398080e7          	jalr	920(ra) # 80002f02 <brelse>
  for(tot=0; tot<n; tot+=m, off+=m, src+=m){
    80003b72:	01498a3b          	addw	s4,s3,s4
    80003b76:	0129893b          	addw	s2,s3,s2
    80003b7a:	9aee                	add	s5,s5,s11
    80003b7c:	057a7663          	bgeu	s4,s7,80003bc8 <writei+0xd8>
    bp = bread(ip->dev, bmap(ip, off/BSIZE));
    80003b80:	000b2483          	lw	s1,0(s6)
    80003b84:	00a9559b          	srliw	a1,s2,0xa
    80003b88:	855a                	mv	a0,s6
    80003b8a:	fffff097          	auipc	ra,0xfffff
    80003b8e:	63c080e7          	jalr	1596(ra) # 800031c6 <bmap>
    80003b92:	0005059b          	sext.w	a1,a0
    80003b96:	8526                	mv	a0,s1
    80003b98:	fffff097          	auipc	ra,0xfffff
    80003b9c:	23a080e7          	jalr	570(ra) # 80002dd2 <bread>
    80003ba0:	84aa                	mv	s1,a0
    m = min(n - tot, BSIZE - off%BSIZE);
    80003ba2:	3ff97513          	andi	a0,s2,1023
    80003ba6:	40ad07bb          	subw	a5,s10,a0
    80003baa:	414b873b          	subw	a4,s7,s4
    80003bae:	89be                	mv	s3,a5
    80003bb0:	2781                	sext.w	a5,a5
    80003bb2:	0007069b          	sext.w	a3,a4
    80003bb6:	f8f6f4e3          	bgeu	a3,a5,80003b3e <writei+0x4e>
    80003bba:	89ba                	mv	s3,a4
    80003bbc:	b749                	j	80003b3e <writei+0x4e>
      brelse(bp);
    80003bbe:	8526                	mv	a0,s1
    80003bc0:	fffff097          	auipc	ra,0xfffff
    80003bc4:	342080e7          	jalr	834(ra) # 80002f02 <brelse>
  }

  if(off > ip->size)
    80003bc8:	04cb2783          	lw	a5,76(s6)
    80003bcc:	0127f463          	bgeu	a5,s2,80003bd4 <writei+0xe4>
    ip->size = off;
    80003bd0:	052b2623          	sw	s2,76(s6)

  // write the i-node back to disk even if the size didn't change
  // because the loop above might have called bmap() and added a new
  // block to ip->addrs[].
  iupdate(ip);
    80003bd4:	855a                	mv	a0,s6
    80003bd6:	00000097          	auipc	ra,0x0
    80003bda:	9fa080e7          	jalr	-1542(ra) # 800035d0 <iupdate>

  return tot;
    80003bde:	000a051b          	sext.w	a0,s4
}
    80003be2:	70a6                	ld	ra,104(sp)
    80003be4:	7406                	ld	s0,96(sp)
    80003be6:	64e6                	ld	s1,88(sp)
    80003be8:	6946                	ld	s2,80(sp)
    80003bea:	69a6                	ld	s3,72(sp)
    80003bec:	6a06                	ld	s4,64(sp)
    80003bee:	7ae2                	ld	s5,56(sp)
    80003bf0:	7b42                	ld	s6,48(sp)
    80003bf2:	7ba2                	ld	s7,40(sp)
    80003bf4:	7c02                	ld	s8,32(sp)
    80003bf6:	6ce2                	ld	s9,24(sp)
    80003bf8:	6d42                	ld	s10,16(sp)
    80003bfa:	6da2                	ld	s11,8(sp)
    80003bfc:	6165                	addi	sp,sp,112
    80003bfe:	8082                	ret
  for(tot=0; tot<n; tot+=m, off+=m, src+=m){
    80003c00:	8a5e                	mv	s4,s7
    80003c02:	bfc9                	j	80003bd4 <writei+0xe4>
    return -1;
    80003c04:	557d                	li	a0,-1
}
    80003c06:	8082                	ret
    return -1;
    80003c08:	557d                	li	a0,-1
    80003c0a:	bfe1                	j	80003be2 <writei+0xf2>
    return -1;
    80003c0c:	557d                	li	a0,-1
    80003c0e:	bfd1                	j	80003be2 <writei+0xf2>

0000000080003c10 <namecmp>:

// Directories

int
namecmp(const char *s, const char *t)
{
    80003c10:	1141                	addi	sp,sp,-16
    80003c12:	e406                	sd	ra,8(sp)
    80003c14:	e022                	sd	s0,0(sp)
    80003c16:	0800                	addi	s0,sp,16
  return strncmp(s, t, DIRSIZ);
    80003c18:	4639                	li	a2,14
    80003c1a:	ffffd097          	auipc	ra,0xffffd
    80003c1e:	17c080e7          	jalr	380(ra) # 80000d96 <strncmp>
}
    80003c22:	60a2                	ld	ra,8(sp)
    80003c24:	6402                	ld	s0,0(sp)
    80003c26:	0141                	addi	sp,sp,16
    80003c28:	8082                	ret

0000000080003c2a <dirlookup>:

// Look for a directory entry in a directory.
// If found, set *poff to byte offset of entry.
struct inode*
dirlookup(struct inode *dp, char *name, uint *poff)
{
    80003c2a:	7139                	addi	sp,sp,-64
    80003c2c:	fc06                	sd	ra,56(sp)
    80003c2e:	f822                	sd	s0,48(sp)
    80003c30:	f426                	sd	s1,40(sp)
    80003c32:	f04a                	sd	s2,32(sp)
    80003c34:	ec4e                	sd	s3,24(sp)
    80003c36:	e852                	sd	s4,16(sp)
    80003c38:	0080                	addi	s0,sp,64
  uint off, inum;
  struct dirent de;

  if(dp->type != T_DIR)
    80003c3a:	04451703          	lh	a4,68(a0)
    80003c3e:	4785                	li	a5,1
    80003c40:	00f71a63          	bne	a4,a5,80003c54 <dirlookup+0x2a>
    80003c44:	892a                	mv	s2,a0
    80003c46:	89ae                	mv	s3,a1
    80003c48:	8a32                	mv	s4,a2
    panic("dirlookup not DIR");

  for(off = 0; off < dp->size; off += sizeof(de)){
    80003c4a:	457c                	lw	a5,76(a0)
    80003c4c:	4481                	li	s1,0
      inum = de.inum;
      return iget(dp->dev, inum);
    }
  }

  return 0;
    80003c4e:	4501                	li	a0,0
  for(off = 0; off < dp->size; off += sizeof(de)){
    80003c50:	e79d                	bnez	a5,80003c7e <dirlookup+0x54>
    80003c52:	a8a5                	j	80003cca <dirlookup+0xa0>
    panic("dirlookup not DIR");
    80003c54:	00005517          	auipc	a0,0x5
    80003c58:	97450513          	addi	a0,a0,-1676 # 800085c8 <syscalls+0x1a8>
    80003c5c:	ffffd097          	auipc	ra,0xffffd
    80003c60:	8ce080e7          	jalr	-1842(ra) # 8000052a <panic>
      panic("dirlookup read");
    80003c64:	00005517          	auipc	a0,0x5
    80003c68:	97c50513          	addi	a0,a0,-1668 # 800085e0 <syscalls+0x1c0>
    80003c6c:	ffffd097          	auipc	ra,0xffffd
    80003c70:	8be080e7          	jalr	-1858(ra) # 8000052a <panic>
  for(off = 0; off < dp->size; off += sizeof(de)){
    80003c74:	24c1                	addiw	s1,s1,16
    80003c76:	04c92783          	lw	a5,76(s2)
    80003c7a:	04f4f763          	bgeu	s1,a5,80003cc8 <dirlookup+0x9e>
    if(readi(dp, 0, (uint64)&de, off, sizeof(de)) != sizeof(de))
    80003c7e:	4741                	li	a4,16
    80003c80:	86a6                	mv	a3,s1
    80003c82:	fc040613          	addi	a2,s0,-64
    80003c86:	4581                	li	a1,0
    80003c88:	854a                	mv	a0,s2
    80003c8a:	00000097          	auipc	ra,0x0
    80003c8e:	d6e080e7          	jalr	-658(ra) # 800039f8 <readi>
    80003c92:	47c1                	li	a5,16
    80003c94:	fcf518e3          	bne	a0,a5,80003c64 <dirlookup+0x3a>
    if(de.inum == 0)
    80003c98:	fc045783          	lhu	a5,-64(s0)
    80003c9c:	dfe1                	beqz	a5,80003c74 <dirlookup+0x4a>
    if(namecmp(name, de.name) == 0){
    80003c9e:	fc240593          	addi	a1,s0,-62
    80003ca2:	854e                	mv	a0,s3
    80003ca4:	00000097          	auipc	ra,0x0
    80003ca8:	f6c080e7          	jalr	-148(ra) # 80003c10 <namecmp>
    80003cac:	f561                	bnez	a0,80003c74 <dirlookup+0x4a>
      if(poff)
    80003cae:	000a0463          	beqz	s4,80003cb6 <dirlookup+0x8c>
        *poff = off;
    80003cb2:	009a2023          	sw	s1,0(s4)
      return iget(dp->dev, inum);
    80003cb6:	fc045583          	lhu	a1,-64(s0)
    80003cba:	00092503          	lw	a0,0(s2)
    80003cbe:	fffff097          	auipc	ra,0xfffff
    80003cc2:	6a8080e7          	jalr	1704(ra) # 80003366 <iget>
    80003cc6:	a011                	j	80003cca <dirlookup+0xa0>
  return 0;
    80003cc8:	4501                	li	a0,0
}
    80003cca:	70e2                	ld	ra,56(sp)
    80003ccc:	7442                	ld	s0,48(sp)
    80003cce:	74a2                	ld	s1,40(sp)
    80003cd0:	7902                	ld	s2,32(sp)
    80003cd2:	69e2                	ld	s3,24(sp)
    80003cd4:	6a42                	ld	s4,16(sp)
    80003cd6:	6121                	addi	sp,sp,64
    80003cd8:	8082                	ret

0000000080003cda <namex>:
// If parent != 0, return the inode for the parent and copy the final
// path element into name, which must have room for DIRSIZ bytes.
// Must be called inside a transaction since it calls iput().
static struct inode*
namex(char *path, int nameiparent, char *name)
{
    80003cda:	711d                	addi	sp,sp,-96
    80003cdc:	ec86                	sd	ra,88(sp)
    80003cde:	e8a2                	sd	s0,80(sp)
    80003ce0:	e4a6                	sd	s1,72(sp)
    80003ce2:	e0ca                	sd	s2,64(sp)
    80003ce4:	fc4e                	sd	s3,56(sp)
    80003ce6:	f852                	sd	s4,48(sp)
    80003ce8:	f456                	sd	s5,40(sp)
    80003cea:	f05a                	sd	s6,32(sp)
    80003cec:	ec5e                	sd	s7,24(sp)
    80003cee:	e862                	sd	s8,16(sp)
    80003cf0:	e466                	sd	s9,8(sp)
    80003cf2:	1080                	addi	s0,sp,96
    80003cf4:	84aa                	mv	s1,a0
    80003cf6:	8aae                	mv	s5,a1
    80003cf8:	8a32                	mv	s4,a2
  struct inode *ip, *next;

  if(*path == '/')
    80003cfa:	00054703          	lbu	a4,0(a0)
    80003cfe:	02f00793          	li	a5,47
    80003d02:	02f70363          	beq	a4,a5,80003d28 <namex+0x4e>
    ip = iget(ROOTDEV, ROOTINO);
  else
    ip = idup(myproc()->cwd);
    80003d06:	ffffe097          	auipc	ra,0xffffe
    80003d0a:	ca4080e7          	jalr	-860(ra) # 800019aa <myproc>
    80003d0e:	15053503          	ld	a0,336(a0)
    80003d12:	00000097          	auipc	ra,0x0
    80003d16:	94a080e7          	jalr	-1718(ra) # 8000365c <idup>
    80003d1a:	89aa                	mv	s3,a0
  while(*path == '/')
    80003d1c:	02f00913          	li	s2,47
  len = path - s;
    80003d20:	4b01                	li	s6,0
  if(len >= DIRSIZ)
    80003d22:	4c35                	li	s8,13

  while((path = skipelem(path, name)) != 0){
    ilock(ip);
    if(ip->type != T_DIR){
    80003d24:	4b85                	li	s7,1
    80003d26:	a865                	j	80003dde <namex+0x104>
    ip = iget(ROOTDEV, ROOTINO);
    80003d28:	4585                	li	a1,1
    80003d2a:	4505                	li	a0,1
    80003d2c:	fffff097          	auipc	ra,0xfffff
    80003d30:	63a080e7          	jalr	1594(ra) # 80003366 <iget>
    80003d34:	89aa                	mv	s3,a0
    80003d36:	b7dd                	j	80003d1c <namex+0x42>
      iunlockput(ip);
    80003d38:	854e                	mv	a0,s3
    80003d3a:	00000097          	auipc	ra,0x0
    80003d3e:	c6c080e7          	jalr	-916(ra) # 800039a6 <iunlockput>
      return 0;
    80003d42:	4981                	li	s3,0
  if(nameiparent){
    iput(ip);
    return 0;
  }
  return ip;
}
    80003d44:	854e                	mv	a0,s3
    80003d46:	60e6                	ld	ra,88(sp)
    80003d48:	6446                	ld	s0,80(sp)
    80003d4a:	64a6                	ld	s1,72(sp)
    80003d4c:	6906                	ld	s2,64(sp)
    80003d4e:	79e2                	ld	s3,56(sp)
    80003d50:	7a42                	ld	s4,48(sp)
    80003d52:	7aa2                	ld	s5,40(sp)
    80003d54:	7b02                	ld	s6,32(sp)
    80003d56:	6be2                	ld	s7,24(sp)
    80003d58:	6c42                	ld	s8,16(sp)
    80003d5a:	6ca2                	ld	s9,8(sp)
    80003d5c:	6125                	addi	sp,sp,96
    80003d5e:	8082                	ret
      iunlock(ip);
    80003d60:	854e                	mv	a0,s3
    80003d62:	00000097          	auipc	ra,0x0
    80003d66:	9fa080e7          	jalr	-1542(ra) # 8000375c <iunlock>
      return ip;
    80003d6a:	bfe9                	j	80003d44 <namex+0x6a>
      iunlockput(ip);
    80003d6c:	854e                	mv	a0,s3
    80003d6e:	00000097          	auipc	ra,0x0
    80003d72:	c38080e7          	jalr	-968(ra) # 800039a6 <iunlockput>
      return 0;
    80003d76:	89e6                	mv	s3,s9
    80003d78:	b7f1                	j	80003d44 <namex+0x6a>
  len = path - s;
    80003d7a:	40b48633          	sub	a2,s1,a1
    80003d7e:	00060c9b          	sext.w	s9,a2
  if(len >= DIRSIZ)
    80003d82:	099c5463          	bge	s8,s9,80003e0a <namex+0x130>
    memmove(name, s, DIRSIZ);
    80003d86:	4639                	li	a2,14
    80003d88:	8552                	mv	a0,s4
    80003d8a:	ffffd097          	auipc	ra,0xffffd
    80003d8e:	f90080e7          	jalr	-112(ra) # 80000d1a <memmove>
  while(*path == '/')
    80003d92:	0004c783          	lbu	a5,0(s1)
    80003d96:	01279763          	bne	a5,s2,80003da4 <namex+0xca>
    path++;
    80003d9a:	0485                	addi	s1,s1,1
  while(*path == '/')
    80003d9c:	0004c783          	lbu	a5,0(s1)
    80003da0:	ff278de3          	beq	a5,s2,80003d9a <namex+0xc0>
    ilock(ip);
    80003da4:	854e                	mv	a0,s3
    80003da6:	00000097          	auipc	ra,0x0
    80003daa:	8f4080e7          	jalr	-1804(ra) # 8000369a <ilock>
    if(ip->type != T_DIR){
    80003dae:	04499783          	lh	a5,68(s3)
    80003db2:	f97793e3          	bne	a5,s7,80003d38 <namex+0x5e>
    if(nameiparent && *path == '\0'){
    80003db6:	000a8563          	beqz	s5,80003dc0 <namex+0xe6>
    80003dba:	0004c783          	lbu	a5,0(s1)
    80003dbe:	d3cd                	beqz	a5,80003d60 <namex+0x86>
    if((next = dirlookup(ip, name, 0)) == 0){
    80003dc0:	865a                	mv	a2,s6
    80003dc2:	85d2                	mv	a1,s4
    80003dc4:	854e                	mv	a0,s3
    80003dc6:	00000097          	auipc	ra,0x0
    80003dca:	e64080e7          	jalr	-412(ra) # 80003c2a <dirlookup>
    80003dce:	8caa                	mv	s9,a0
    80003dd0:	dd51                	beqz	a0,80003d6c <namex+0x92>
    iunlockput(ip);
    80003dd2:	854e                	mv	a0,s3
    80003dd4:	00000097          	auipc	ra,0x0
    80003dd8:	bd2080e7          	jalr	-1070(ra) # 800039a6 <iunlockput>
    ip = next;
    80003ddc:	89e6                	mv	s3,s9
  while(*path == '/')
    80003dde:	0004c783          	lbu	a5,0(s1)
    80003de2:	05279763          	bne	a5,s2,80003e30 <namex+0x156>
    path++;
    80003de6:	0485                	addi	s1,s1,1
  while(*path == '/')
    80003de8:	0004c783          	lbu	a5,0(s1)
    80003dec:	ff278de3          	beq	a5,s2,80003de6 <namex+0x10c>
  if(*path == 0)
    80003df0:	c79d                	beqz	a5,80003e1e <namex+0x144>
    path++;
    80003df2:	85a6                	mv	a1,s1
  len = path - s;
    80003df4:	8cda                	mv	s9,s6
    80003df6:	865a                	mv	a2,s6
  while(*path != '/' && *path != 0)
    80003df8:	01278963          	beq	a5,s2,80003e0a <namex+0x130>
    80003dfc:	dfbd                	beqz	a5,80003d7a <namex+0xa0>
    path++;
    80003dfe:	0485                	addi	s1,s1,1
  while(*path != '/' && *path != 0)
    80003e00:	0004c783          	lbu	a5,0(s1)
    80003e04:	ff279ce3          	bne	a5,s2,80003dfc <namex+0x122>
    80003e08:	bf8d                	j	80003d7a <namex+0xa0>
    memmove(name, s, len);
    80003e0a:	2601                	sext.w	a2,a2
    80003e0c:	8552                	mv	a0,s4
    80003e0e:	ffffd097          	auipc	ra,0xffffd
    80003e12:	f0c080e7          	jalr	-244(ra) # 80000d1a <memmove>
    name[len] = 0;
    80003e16:	9cd2                	add	s9,s9,s4
    80003e18:	000c8023          	sb	zero,0(s9) # 2000 <_entry-0x7fffe000>
    80003e1c:	bf9d                	j	80003d92 <namex+0xb8>
  if(nameiparent){
    80003e1e:	f20a83e3          	beqz	s5,80003d44 <namex+0x6a>
    iput(ip);
    80003e22:	854e                	mv	a0,s3
    80003e24:	00000097          	auipc	ra,0x0
    80003e28:	ada080e7          	jalr	-1318(ra) # 800038fe <iput>
    return 0;
    80003e2c:	4981                	li	s3,0
    80003e2e:	bf19                	j	80003d44 <namex+0x6a>
  if(*path == 0)
    80003e30:	d7fd                	beqz	a5,80003e1e <namex+0x144>
  while(*path != '/' && *path != 0)
    80003e32:	0004c783          	lbu	a5,0(s1)
    80003e36:	85a6                	mv	a1,s1
    80003e38:	b7d1                	j	80003dfc <namex+0x122>

0000000080003e3a <dirlink>:
{
    80003e3a:	7139                	addi	sp,sp,-64
    80003e3c:	fc06                	sd	ra,56(sp)
    80003e3e:	f822                	sd	s0,48(sp)
    80003e40:	f426                	sd	s1,40(sp)
    80003e42:	f04a                	sd	s2,32(sp)
    80003e44:	ec4e                	sd	s3,24(sp)
    80003e46:	e852                	sd	s4,16(sp)
    80003e48:	0080                	addi	s0,sp,64
    80003e4a:	892a                	mv	s2,a0
    80003e4c:	8a2e                	mv	s4,a1
    80003e4e:	89b2                	mv	s3,a2
  if((ip = dirlookup(dp, name, 0)) != 0){
    80003e50:	4601                	li	a2,0
    80003e52:	00000097          	auipc	ra,0x0
    80003e56:	dd8080e7          	jalr	-552(ra) # 80003c2a <dirlookup>
    80003e5a:	e93d                	bnez	a0,80003ed0 <dirlink+0x96>
  for(off = 0; off < dp->size; off += sizeof(de)){
    80003e5c:	04c92483          	lw	s1,76(s2)
    80003e60:	c49d                	beqz	s1,80003e8e <dirlink+0x54>
    80003e62:	4481                	li	s1,0
    if(readi(dp, 0, (uint64)&de, off, sizeof(de)) != sizeof(de))
    80003e64:	4741                	li	a4,16
    80003e66:	86a6                	mv	a3,s1
    80003e68:	fc040613          	addi	a2,s0,-64
    80003e6c:	4581                	li	a1,0
    80003e6e:	854a                	mv	a0,s2
    80003e70:	00000097          	auipc	ra,0x0
    80003e74:	b88080e7          	jalr	-1144(ra) # 800039f8 <readi>
    80003e78:	47c1                	li	a5,16
    80003e7a:	06f51163          	bne	a0,a5,80003edc <dirlink+0xa2>
    if(de.inum == 0)
    80003e7e:	fc045783          	lhu	a5,-64(s0)
    80003e82:	c791                	beqz	a5,80003e8e <dirlink+0x54>
  for(off = 0; off < dp->size; off += sizeof(de)){
    80003e84:	24c1                	addiw	s1,s1,16
    80003e86:	04c92783          	lw	a5,76(s2)
    80003e8a:	fcf4ede3          	bltu	s1,a5,80003e64 <dirlink+0x2a>
  strncpy(de.name, name, DIRSIZ);
    80003e8e:	4639                	li	a2,14
    80003e90:	85d2                	mv	a1,s4
    80003e92:	fc240513          	addi	a0,s0,-62
    80003e96:	ffffd097          	auipc	ra,0xffffd
    80003e9a:	f3c080e7          	jalr	-196(ra) # 80000dd2 <strncpy>
  de.inum = inum;
    80003e9e:	fd341023          	sh	s3,-64(s0)
  if(writei(dp, 0, (uint64)&de, off, sizeof(de)) != sizeof(de))
    80003ea2:	4741                	li	a4,16
    80003ea4:	86a6                	mv	a3,s1
    80003ea6:	fc040613          	addi	a2,s0,-64
    80003eaa:	4581                	li	a1,0
    80003eac:	854a                	mv	a0,s2
    80003eae:	00000097          	auipc	ra,0x0
    80003eb2:	c42080e7          	jalr	-958(ra) # 80003af0 <writei>
    80003eb6:	872a                	mv	a4,a0
    80003eb8:	47c1                	li	a5,16
  return 0;
    80003eba:	4501                	li	a0,0
  if(writei(dp, 0, (uint64)&de, off, sizeof(de)) != sizeof(de))
    80003ebc:	02f71863          	bne	a4,a5,80003eec <dirlink+0xb2>
}
    80003ec0:	70e2                	ld	ra,56(sp)
    80003ec2:	7442                	ld	s0,48(sp)
    80003ec4:	74a2                	ld	s1,40(sp)
    80003ec6:	7902                	ld	s2,32(sp)
    80003ec8:	69e2                	ld	s3,24(sp)
    80003eca:	6a42                	ld	s4,16(sp)
    80003ecc:	6121                	addi	sp,sp,64
    80003ece:	8082                	ret
    iput(ip);
    80003ed0:	00000097          	auipc	ra,0x0
    80003ed4:	a2e080e7          	jalr	-1490(ra) # 800038fe <iput>
    return -1;
    80003ed8:	557d                	li	a0,-1
    80003eda:	b7dd                	j	80003ec0 <dirlink+0x86>
      panic("dirlink read");
    80003edc:	00004517          	auipc	a0,0x4
    80003ee0:	71450513          	addi	a0,a0,1812 # 800085f0 <syscalls+0x1d0>
    80003ee4:	ffffc097          	auipc	ra,0xffffc
    80003ee8:	646080e7          	jalr	1606(ra) # 8000052a <panic>
    panic("dirlink");
    80003eec:	00005517          	auipc	a0,0x5
    80003ef0:	81450513          	addi	a0,a0,-2028 # 80008700 <syscalls+0x2e0>
    80003ef4:	ffffc097          	auipc	ra,0xffffc
    80003ef8:	636080e7          	jalr	1590(ra) # 8000052a <panic>

0000000080003efc <namei>:

struct inode*
namei(char *path)
{
    80003efc:	1101                	addi	sp,sp,-32
    80003efe:	ec06                	sd	ra,24(sp)
    80003f00:	e822                	sd	s0,16(sp)
    80003f02:	1000                	addi	s0,sp,32
  char name[DIRSIZ];
  return namex(path, 0, name);
    80003f04:	fe040613          	addi	a2,s0,-32
    80003f08:	4581                	li	a1,0
    80003f0a:	00000097          	auipc	ra,0x0
    80003f0e:	dd0080e7          	jalr	-560(ra) # 80003cda <namex>
}
    80003f12:	60e2                	ld	ra,24(sp)
    80003f14:	6442                	ld	s0,16(sp)
    80003f16:	6105                	addi	sp,sp,32
    80003f18:	8082                	ret

0000000080003f1a <nameiparent>:

struct inode*
nameiparent(char *path, char *name)
{
    80003f1a:	1141                	addi	sp,sp,-16
    80003f1c:	e406                	sd	ra,8(sp)
    80003f1e:	e022                	sd	s0,0(sp)
    80003f20:	0800                	addi	s0,sp,16
    80003f22:	862e                	mv	a2,a1
  return namex(path, 1, name);
    80003f24:	4585                	li	a1,1
    80003f26:	00000097          	auipc	ra,0x0
    80003f2a:	db4080e7          	jalr	-588(ra) # 80003cda <namex>
}
    80003f2e:	60a2                	ld	ra,8(sp)
    80003f30:	6402                	ld	s0,0(sp)
    80003f32:	0141                	addi	sp,sp,16
    80003f34:	8082                	ret

0000000080003f36 <write_head>:
// Write in-memory log header to disk.
// This is the true point at which the
// current transaction commits.
static void
write_head(void)
{
    80003f36:	1101                	addi	sp,sp,-32
    80003f38:	ec06                	sd	ra,24(sp)
    80003f3a:	e822                	sd	s0,16(sp)
    80003f3c:	e426                	sd	s1,8(sp)
    80003f3e:	e04a                	sd	s2,0(sp)
    80003f40:	1000                	addi	s0,sp,32
  struct buf *buf = bread(log.dev, log.start);
    80003f42:	00018917          	auipc	s2,0x18
    80003f46:	72690913          	addi	s2,s2,1830 # 8001c668 <log>
    80003f4a:	01892583          	lw	a1,24(s2)
    80003f4e:	02892503          	lw	a0,40(s2)
    80003f52:	fffff097          	auipc	ra,0xfffff
    80003f56:	e80080e7          	jalr	-384(ra) # 80002dd2 <bread>
    80003f5a:	84aa                	mv	s1,a0
  struct logheader *hb = (struct logheader *) (buf->data);
  int i;
  hb->n = log.lh.n;
    80003f5c:	02c92683          	lw	a3,44(s2)
    80003f60:	cd34                	sw	a3,88(a0)
  for (i = 0; i < log.lh.n; i++) {
    80003f62:	02d05763          	blez	a3,80003f90 <write_head+0x5a>
    80003f66:	00018797          	auipc	a5,0x18
    80003f6a:	73278793          	addi	a5,a5,1842 # 8001c698 <log+0x30>
    80003f6e:	05c50713          	addi	a4,a0,92
    80003f72:	36fd                	addiw	a3,a3,-1
    80003f74:	1682                	slli	a3,a3,0x20
    80003f76:	9281                	srli	a3,a3,0x20
    80003f78:	068a                	slli	a3,a3,0x2
    80003f7a:	00018617          	auipc	a2,0x18
    80003f7e:	72260613          	addi	a2,a2,1826 # 8001c69c <log+0x34>
    80003f82:	96b2                	add	a3,a3,a2
    hb->block[i] = log.lh.block[i];
    80003f84:	4390                	lw	a2,0(a5)
    80003f86:	c310                	sw	a2,0(a4)
  for (i = 0; i < log.lh.n; i++) {
    80003f88:	0791                	addi	a5,a5,4
    80003f8a:	0711                	addi	a4,a4,4
    80003f8c:	fed79ce3          	bne	a5,a3,80003f84 <write_head+0x4e>
  }
  bwrite(buf);
    80003f90:	8526                	mv	a0,s1
    80003f92:	fffff097          	auipc	ra,0xfffff
    80003f96:	f32080e7          	jalr	-206(ra) # 80002ec4 <bwrite>
  brelse(buf);
    80003f9a:	8526                	mv	a0,s1
    80003f9c:	fffff097          	auipc	ra,0xfffff
    80003fa0:	f66080e7          	jalr	-154(ra) # 80002f02 <brelse>
}
    80003fa4:	60e2                	ld	ra,24(sp)
    80003fa6:	6442                	ld	s0,16(sp)
    80003fa8:	64a2                	ld	s1,8(sp)
    80003faa:	6902                	ld	s2,0(sp)
    80003fac:	6105                	addi	sp,sp,32
    80003fae:	8082                	ret

0000000080003fb0 <install_trans>:
  for (tail = 0; tail < log.lh.n; tail++) {
    80003fb0:	00018797          	auipc	a5,0x18
    80003fb4:	6e47a783          	lw	a5,1764(a5) # 8001c694 <log+0x2c>
    80003fb8:	0af05d63          	blez	a5,80004072 <install_trans+0xc2>
{
    80003fbc:	7139                	addi	sp,sp,-64
    80003fbe:	fc06                	sd	ra,56(sp)
    80003fc0:	f822                	sd	s0,48(sp)
    80003fc2:	f426                	sd	s1,40(sp)
    80003fc4:	f04a                	sd	s2,32(sp)
    80003fc6:	ec4e                	sd	s3,24(sp)
    80003fc8:	e852                	sd	s4,16(sp)
    80003fca:	e456                	sd	s5,8(sp)
    80003fcc:	e05a                	sd	s6,0(sp)
    80003fce:	0080                	addi	s0,sp,64
    80003fd0:	8b2a                	mv	s6,a0
    80003fd2:	00018a97          	auipc	s5,0x18
    80003fd6:	6c6a8a93          	addi	s5,s5,1734 # 8001c698 <log+0x30>
  for (tail = 0; tail < log.lh.n; tail++) {
    80003fda:	4a01                	li	s4,0
    struct buf *lbuf = bread(log.dev, log.start+tail+1); // read log block
    80003fdc:	00018997          	auipc	s3,0x18
    80003fe0:	68c98993          	addi	s3,s3,1676 # 8001c668 <log>
    80003fe4:	a00d                	j	80004006 <install_trans+0x56>
    brelse(lbuf);
    80003fe6:	854a                	mv	a0,s2
    80003fe8:	fffff097          	auipc	ra,0xfffff
    80003fec:	f1a080e7          	jalr	-230(ra) # 80002f02 <brelse>
    brelse(dbuf);
    80003ff0:	8526                	mv	a0,s1
    80003ff2:	fffff097          	auipc	ra,0xfffff
    80003ff6:	f10080e7          	jalr	-240(ra) # 80002f02 <brelse>
  for (tail = 0; tail < log.lh.n; tail++) {
    80003ffa:	2a05                	addiw	s4,s4,1
    80003ffc:	0a91                	addi	s5,s5,4
    80003ffe:	02c9a783          	lw	a5,44(s3)
    80004002:	04fa5e63          	bge	s4,a5,8000405e <install_trans+0xae>
    struct buf *lbuf = bread(log.dev, log.start+tail+1); // read log block
    80004006:	0189a583          	lw	a1,24(s3)
    8000400a:	014585bb          	addw	a1,a1,s4
    8000400e:	2585                	addiw	a1,a1,1
    80004010:	0289a503          	lw	a0,40(s3)
    80004014:	fffff097          	auipc	ra,0xfffff
    80004018:	dbe080e7          	jalr	-578(ra) # 80002dd2 <bread>
    8000401c:	892a                	mv	s2,a0
    struct buf *dbuf = bread(log.dev, log.lh.block[tail]); // read dst
    8000401e:	000aa583          	lw	a1,0(s5)
    80004022:	0289a503          	lw	a0,40(s3)
    80004026:	fffff097          	auipc	ra,0xfffff
    8000402a:	dac080e7          	jalr	-596(ra) # 80002dd2 <bread>
    8000402e:	84aa                	mv	s1,a0
    memmove(dbuf->data, lbuf->data, BSIZE);  // copy block to dst
    80004030:	40000613          	li	a2,1024
    80004034:	05890593          	addi	a1,s2,88
    80004038:	05850513          	addi	a0,a0,88
    8000403c:	ffffd097          	auipc	ra,0xffffd
    80004040:	cde080e7          	jalr	-802(ra) # 80000d1a <memmove>
    bwrite(dbuf);  // write dst to disk
    80004044:	8526                	mv	a0,s1
    80004046:	fffff097          	auipc	ra,0xfffff
    8000404a:	e7e080e7          	jalr	-386(ra) # 80002ec4 <bwrite>
    if(recovering == 0)
    8000404e:	f80b1ce3          	bnez	s6,80003fe6 <install_trans+0x36>
      bunpin(dbuf);
    80004052:	8526                	mv	a0,s1
    80004054:	fffff097          	auipc	ra,0xfffff
    80004058:	f88080e7          	jalr	-120(ra) # 80002fdc <bunpin>
    8000405c:	b769                	j	80003fe6 <install_trans+0x36>
}
    8000405e:	70e2                	ld	ra,56(sp)
    80004060:	7442                	ld	s0,48(sp)
    80004062:	74a2                	ld	s1,40(sp)
    80004064:	7902                	ld	s2,32(sp)
    80004066:	69e2                	ld	s3,24(sp)
    80004068:	6a42                	ld	s4,16(sp)
    8000406a:	6aa2                	ld	s5,8(sp)
    8000406c:	6b02                	ld	s6,0(sp)
    8000406e:	6121                	addi	sp,sp,64
    80004070:	8082                	ret
    80004072:	8082                	ret

0000000080004074 <initlog>:
{
    80004074:	7179                	addi	sp,sp,-48
    80004076:	f406                	sd	ra,40(sp)
    80004078:	f022                	sd	s0,32(sp)
    8000407a:	ec26                	sd	s1,24(sp)
    8000407c:	e84a                	sd	s2,16(sp)
    8000407e:	e44e                	sd	s3,8(sp)
    80004080:	1800                	addi	s0,sp,48
    80004082:	892a                	mv	s2,a0
    80004084:	89ae                	mv	s3,a1
  initlock(&log.lock, "log");
    80004086:	00018497          	auipc	s1,0x18
    8000408a:	5e248493          	addi	s1,s1,1506 # 8001c668 <log>
    8000408e:	00004597          	auipc	a1,0x4
    80004092:	57258593          	addi	a1,a1,1394 # 80008600 <syscalls+0x1e0>
    80004096:	8526                	mv	a0,s1
    80004098:	ffffd097          	auipc	ra,0xffffd
    8000409c:	a9a080e7          	jalr	-1382(ra) # 80000b32 <initlock>
  log.start = sb->logstart;
    800040a0:	0149a583          	lw	a1,20(s3)
    800040a4:	cc8c                	sw	a1,24(s1)
  log.size = sb->nlog;
    800040a6:	0109a783          	lw	a5,16(s3)
    800040aa:	ccdc                	sw	a5,28(s1)
  log.dev = dev;
    800040ac:	0324a423          	sw	s2,40(s1)
  struct buf *buf = bread(log.dev, log.start);
    800040b0:	854a                	mv	a0,s2
    800040b2:	fffff097          	auipc	ra,0xfffff
    800040b6:	d20080e7          	jalr	-736(ra) # 80002dd2 <bread>
  log.lh.n = lh->n;
    800040ba:	4d34                	lw	a3,88(a0)
    800040bc:	d4d4                	sw	a3,44(s1)
  for (i = 0; i < log.lh.n; i++) {
    800040be:	02d05563          	blez	a3,800040e8 <initlog+0x74>
    800040c2:	05c50793          	addi	a5,a0,92
    800040c6:	00018717          	auipc	a4,0x18
    800040ca:	5d270713          	addi	a4,a4,1490 # 8001c698 <log+0x30>
    800040ce:	36fd                	addiw	a3,a3,-1
    800040d0:	1682                	slli	a3,a3,0x20
    800040d2:	9281                	srli	a3,a3,0x20
    800040d4:	068a                	slli	a3,a3,0x2
    800040d6:	06050613          	addi	a2,a0,96
    800040da:	96b2                	add	a3,a3,a2
    log.lh.block[i] = lh->block[i];
    800040dc:	4390                	lw	a2,0(a5)
    800040de:	c310                	sw	a2,0(a4)
  for (i = 0; i < log.lh.n; i++) {
    800040e0:	0791                	addi	a5,a5,4
    800040e2:	0711                	addi	a4,a4,4
    800040e4:	fed79ce3          	bne	a5,a3,800040dc <initlog+0x68>
  brelse(buf);
    800040e8:	fffff097          	auipc	ra,0xfffff
    800040ec:	e1a080e7          	jalr	-486(ra) # 80002f02 <brelse>

static void
recover_from_log(void)
{
  read_head();
  install_trans(1); // if committed, copy from log to disk
    800040f0:	4505                	li	a0,1
    800040f2:	00000097          	auipc	ra,0x0
    800040f6:	ebe080e7          	jalr	-322(ra) # 80003fb0 <install_trans>
  log.lh.n = 0;
    800040fa:	00018797          	auipc	a5,0x18
    800040fe:	5807ad23          	sw	zero,1434(a5) # 8001c694 <log+0x2c>
  write_head(); // clear the log
    80004102:	00000097          	auipc	ra,0x0
    80004106:	e34080e7          	jalr	-460(ra) # 80003f36 <write_head>
}
    8000410a:	70a2                	ld	ra,40(sp)
    8000410c:	7402                	ld	s0,32(sp)
    8000410e:	64e2                	ld	s1,24(sp)
    80004110:	6942                	ld	s2,16(sp)
    80004112:	69a2                	ld	s3,8(sp)
    80004114:	6145                	addi	sp,sp,48
    80004116:	8082                	ret

0000000080004118 <begin_op>:
}

// called at the start of each FS system call.
void
begin_op(void)
{
    80004118:	1101                	addi	sp,sp,-32
    8000411a:	ec06                	sd	ra,24(sp)
    8000411c:	e822                	sd	s0,16(sp)
    8000411e:	e426                	sd	s1,8(sp)
    80004120:	e04a                	sd	s2,0(sp)
    80004122:	1000                	addi	s0,sp,32
  acquire(&log.lock);
    80004124:	00018517          	auipc	a0,0x18
    80004128:	54450513          	addi	a0,a0,1348 # 8001c668 <log>
    8000412c:	ffffd097          	auipc	ra,0xffffd
    80004130:	a96080e7          	jalr	-1386(ra) # 80000bc2 <acquire>
  while(1){
    if(log.committing){
    80004134:	00018497          	auipc	s1,0x18
    80004138:	53448493          	addi	s1,s1,1332 # 8001c668 <log>
      sleep(&log, &log.lock);
    } else if(log.lh.n + (log.outstanding+1)*MAXOPBLOCKS > LOGSIZE){
    8000413c:	4979                	li	s2,30
    8000413e:	a039                	j	8000414c <begin_op+0x34>
      sleep(&log, &log.lock);
    80004140:	85a6                	mv	a1,s1
    80004142:	8526                	mv	a0,s1
    80004144:	ffffe097          	auipc	ra,0xffffe
    80004148:	07a080e7          	jalr	122(ra) # 800021be <sleep>
    if(log.committing){
    8000414c:	50dc                	lw	a5,36(s1)
    8000414e:	fbed                	bnez	a5,80004140 <begin_op+0x28>
    } else if(log.lh.n + (log.outstanding+1)*MAXOPBLOCKS > LOGSIZE){
    80004150:	509c                	lw	a5,32(s1)
    80004152:	0017871b          	addiw	a4,a5,1
    80004156:	0007069b          	sext.w	a3,a4
    8000415a:	0027179b          	slliw	a5,a4,0x2
    8000415e:	9fb9                	addw	a5,a5,a4
    80004160:	0017979b          	slliw	a5,a5,0x1
    80004164:	54d8                	lw	a4,44(s1)
    80004166:	9fb9                	addw	a5,a5,a4
    80004168:	00f95963          	bge	s2,a5,8000417a <begin_op+0x62>
      // this op might exhaust log space; wait for commit.
      sleep(&log, &log.lock);
    8000416c:	85a6                	mv	a1,s1
    8000416e:	8526                	mv	a0,s1
    80004170:	ffffe097          	auipc	ra,0xffffe
    80004174:	04e080e7          	jalr	78(ra) # 800021be <sleep>
    80004178:	bfd1                	j	8000414c <begin_op+0x34>
    } else {
      log.outstanding += 1;
    8000417a:	00018517          	auipc	a0,0x18
    8000417e:	4ee50513          	addi	a0,a0,1262 # 8001c668 <log>
    80004182:	d114                	sw	a3,32(a0)
      release(&log.lock);
    80004184:	ffffd097          	auipc	ra,0xffffd
    80004188:	af2080e7          	jalr	-1294(ra) # 80000c76 <release>
      break;
    }
  }
}
    8000418c:	60e2                	ld	ra,24(sp)
    8000418e:	6442                	ld	s0,16(sp)
    80004190:	64a2                	ld	s1,8(sp)
    80004192:	6902                	ld	s2,0(sp)
    80004194:	6105                	addi	sp,sp,32
    80004196:	8082                	ret

0000000080004198 <end_op>:

// called at the end of each FS system call.
// commits if this was the last outstanding operation.
void
end_op(void)
{
    80004198:	7139                	addi	sp,sp,-64
    8000419a:	fc06                	sd	ra,56(sp)
    8000419c:	f822                	sd	s0,48(sp)
    8000419e:	f426                	sd	s1,40(sp)
    800041a0:	f04a                	sd	s2,32(sp)
    800041a2:	ec4e                	sd	s3,24(sp)
    800041a4:	e852                	sd	s4,16(sp)
    800041a6:	e456                	sd	s5,8(sp)
    800041a8:	0080                	addi	s0,sp,64
  int do_commit = 0;

  acquire(&log.lock);
    800041aa:	00018497          	auipc	s1,0x18
    800041ae:	4be48493          	addi	s1,s1,1214 # 8001c668 <log>
    800041b2:	8526                	mv	a0,s1
    800041b4:	ffffd097          	auipc	ra,0xffffd
    800041b8:	a0e080e7          	jalr	-1522(ra) # 80000bc2 <acquire>
  log.outstanding -= 1;
    800041bc:	509c                	lw	a5,32(s1)
    800041be:	37fd                	addiw	a5,a5,-1
    800041c0:	0007891b          	sext.w	s2,a5
    800041c4:	d09c                	sw	a5,32(s1)
  if(log.committing)
    800041c6:	50dc                	lw	a5,36(s1)
    800041c8:	e7b9                	bnez	a5,80004216 <end_op+0x7e>
    panic("log.committing");
  if(log.outstanding == 0){
    800041ca:	04091e63          	bnez	s2,80004226 <end_op+0x8e>
    do_commit = 1;
    log.committing = 1;
    800041ce:	00018497          	auipc	s1,0x18
    800041d2:	49a48493          	addi	s1,s1,1178 # 8001c668 <log>
    800041d6:	4785                	li	a5,1
    800041d8:	d0dc                	sw	a5,36(s1)
    // begin_op() may be waiting for log space,
    // and decrementing log.outstanding has decreased
    // the amount of reserved space.
    wakeup(&log);
  }
  release(&log.lock);
    800041da:	8526                	mv	a0,s1
    800041dc:	ffffd097          	auipc	ra,0xffffd
    800041e0:	a9a080e7          	jalr	-1382(ra) # 80000c76 <release>
}

static void
commit()
{
  if (log.lh.n > 0) {
    800041e4:	54dc                	lw	a5,44(s1)
    800041e6:	06f04763          	bgtz	a5,80004254 <end_op+0xbc>
    acquire(&log.lock);
    800041ea:	00018497          	auipc	s1,0x18
    800041ee:	47e48493          	addi	s1,s1,1150 # 8001c668 <log>
    800041f2:	8526                	mv	a0,s1
    800041f4:	ffffd097          	auipc	ra,0xffffd
    800041f8:	9ce080e7          	jalr	-1586(ra) # 80000bc2 <acquire>
    log.committing = 0;
    800041fc:	0204a223          	sw	zero,36(s1)
    wakeup(&log);
    80004200:	8526                	mv	a0,s1
    80004202:	ffffe097          	auipc	ra,0xffffe
    80004206:	13c080e7          	jalr	316(ra) # 8000233e <wakeup>
    release(&log.lock);
    8000420a:	8526                	mv	a0,s1
    8000420c:	ffffd097          	auipc	ra,0xffffd
    80004210:	a6a080e7          	jalr	-1430(ra) # 80000c76 <release>
}
    80004214:	a03d                	j	80004242 <end_op+0xaa>
    panic("log.committing");
    80004216:	00004517          	auipc	a0,0x4
    8000421a:	3f250513          	addi	a0,a0,1010 # 80008608 <syscalls+0x1e8>
    8000421e:	ffffc097          	auipc	ra,0xffffc
    80004222:	30c080e7          	jalr	780(ra) # 8000052a <panic>
    wakeup(&log);
    80004226:	00018497          	auipc	s1,0x18
    8000422a:	44248493          	addi	s1,s1,1090 # 8001c668 <log>
    8000422e:	8526                	mv	a0,s1
    80004230:	ffffe097          	auipc	ra,0xffffe
    80004234:	10e080e7          	jalr	270(ra) # 8000233e <wakeup>
  release(&log.lock);
    80004238:	8526                	mv	a0,s1
    8000423a:	ffffd097          	auipc	ra,0xffffd
    8000423e:	a3c080e7          	jalr	-1476(ra) # 80000c76 <release>
}
    80004242:	70e2                	ld	ra,56(sp)
    80004244:	7442                	ld	s0,48(sp)
    80004246:	74a2                	ld	s1,40(sp)
    80004248:	7902                	ld	s2,32(sp)
    8000424a:	69e2                	ld	s3,24(sp)
    8000424c:	6a42                	ld	s4,16(sp)
    8000424e:	6aa2                	ld	s5,8(sp)
    80004250:	6121                	addi	sp,sp,64
    80004252:	8082                	ret
  for (tail = 0; tail < log.lh.n; tail++) {
    80004254:	00018a97          	auipc	s5,0x18
    80004258:	444a8a93          	addi	s5,s5,1092 # 8001c698 <log+0x30>
    struct buf *to = bread(log.dev, log.start+tail+1); // log block
    8000425c:	00018a17          	auipc	s4,0x18
    80004260:	40ca0a13          	addi	s4,s4,1036 # 8001c668 <log>
    80004264:	018a2583          	lw	a1,24(s4)
    80004268:	012585bb          	addw	a1,a1,s2
    8000426c:	2585                	addiw	a1,a1,1
    8000426e:	028a2503          	lw	a0,40(s4)
    80004272:	fffff097          	auipc	ra,0xfffff
    80004276:	b60080e7          	jalr	-1184(ra) # 80002dd2 <bread>
    8000427a:	84aa                	mv	s1,a0
    struct buf *from = bread(log.dev, log.lh.block[tail]); // cache block
    8000427c:	000aa583          	lw	a1,0(s5)
    80004280:	028a2503          	lw	a0,40(s4)
    80004284:	fffff097          	auipc	ra,0xfffff
    80004288:	b4e080e7          	jalr	-1202(ra) # 80002dd2 <bread>
    8000428c:	89aa                	mv	s3,a0
    memmove(to->data, from->data, BSIZE);
    8000428e:	40000613          	li	a2,1024
    80004292:	05850593          	addi	a1,a0,88
    80004296:	05848513          	addi	a0,s1,88
    8000429a:	ffffd097          	auipc	ra,0xffffd
    8000429e:	a80080e7          	jalr	-1408(ra) # 80000d1a <memmove>
    bwrite(to);  // write the log
    800042a2:	8526                	mv	a0,s1
    800042a4:	fffff097          	auipc	ra,0xfffff
    800042a8:	c20080e7          	jalr	-992(ra) # 80002ec4 <bwrite>
    brelse(from);
    800042ac:	854e                	mv	a0,s3
    800042ae:	fffff097          	auipc	ra,0xfffff
    800042b2:	c54080e7          	jalr	-940(ra) # 80002f02 <brelse>
    brelse(to);
    800042b6:	8526                	mv	a0,s1
    800042b8:	fffff097          	auipc	ra,0xfffff
    800042bc:	c4a080e7          	jalr	-950(ra) # 80002f02 <brelse>
  for (tail = 0; tail < log.lh.n; tail++) {
    800042c0:	2905                	addiw	s2,s2,1
    800042c2:	0a91                	addi	s5,s5,4
    800042c4:	02ca2783          	lw	a5,44(s4)
    800042c8:	f8f94ee3          	blt	s2,a5,80004264 <end_op+0xcc>
    write_log();     // Write modified blocks from cache to log
    write_head();    // Write header to disk -- the real commit
    800042cc:	00000097          	auipc	ra,0x0
    800042d0:	c6a080e7          	jalr	-918(ra) # 80003f36 <write_head>
    install_trans(0); // Now install writes to home locations
    800042d4:	4501                	li	a0,0
    800042d6:	00000097          	auipc	ra,0x0
    800042da:	cda080e7          	jalr	-806(ra) # 80003fb0 <install_trans>
    log.lh.n = 0;
    800042de:	00018797          	auipc	a5,0x18
    800042e2:	3a07ab23          	sw	zero,950(a5) # 8001c694 <log+0x2c>
    write_head();    // Erase the transaction from the log
    800042e6:	00000097          	auipc	ra,0x0
    800042ea:	c50080e7          	jalr	-944(ra) # 80003f36 <write_head>
    800042ee:	bdf5                	j	800041ea <end_op+0x52>

00000000800042f0 <log_write>:
//   modify bp->data[]
//   log_write(bp)
//   brelse(bp)
void
log_write(struct buf *b)
{
    800042f0:	1101                	addi	sp,sp,-32
    800042f2:	ec06                	sd	ra,24(sp)
    800042f4:	e822                	sd	s0,16(sp)
    800042f6:	e426                	sd	s1,8(sp)
    800042f8:	e04a                	sd	s2,0(sp)
    800042fa:	1000                	addi	s0,sp,32
  int i;

  if (log.lh.n >= LOGSIZE || log.lh.n >= log.size - 1)
    800042fc:	00018717          	auipc	a4,0x18
    80004300:	39872703          	lw	a4,920(a4) # 8001c694 <log+0x2c>
    80004304:	47f5                	li	a5,29
    80004306:	08e7c063          	blt	a5,a4,80004386 <log_write+0x96>
    8000430a:	84aa                	mv	s1,a0
    8000430c:	00018797          	auipc	a5,0x18
    80004310:	3787a783          	lw	a5,888(a5) # 8001c684 <log+0x1c>
    80004314:	37fd                	addiw	a5,a5,-1
    80004316:	06f75863          	bge	a4,a5,80004386 <log_write+0x96>
    panic("too big a transaction");
  if (log.outstanding < 1)
    8000431a:	00018797          	auipc	a5,0x18
    8000431e:	36e7a783          	lw	a5,878(a5) # 8001c688 <log+0x20>
    80004322:	06f05a63          	blez	a5,80004396 <log_write+0xa6>
    panic("log_write outside of trans");

  acquire(&log.lock);
    80004326:	00018917          	auipc	s2,0x18
    8000432a:	34290913          	addi	s2,s2,834 # 8001c668 <log>
    8000432e:	854a                	mv	a0,s2
    80004330:	ffffd097          	auipc	ra,0xffffd
    80004334:	892080e7          	jalr	-1902(ra) # 80000bc2 <acquire>
  for (i = 0; i < log.lh.n; i++) {
    80004338:	02c92603          	lw	a2,44(s2)
    8000433c:	06c05563          	blez	a2,800043a6 <log_write+0xb6>
    if (log.lh.block[i] == b->blockno)   // log absorbtion
    80004340:	44cc                	lw	a1,12(s1)
    80004342:	00018717          	auipc	a4,0x18
    80004346:	35670713          	addi	a4,a4,854 # 8001c698 <log+0x30>
  for (i = 0; i < log.lh.n; i++) {
    8000434a:	4781                	li	a5,0
    if (log.lh.block[i] == b->blockno)   // log absorbtion
    8000434c:	4314                	lw	a3,0(a4)
    8000434e:	04b68d63          	beq	a3,a1,800043a8 <log_write+0xb8>
  for (i = 0; i < log.lh.n; i++) {
    80004352:	2785                	addiw	a5,a5,1
    80004354:	0711                	addi	a4,a4,4
    80004356:	fec79be3          	bne	a5,a2,8000434c <log_write+0x5c>
      break;
  }
  log.lh.block[i] = b->blockno;
    8000435a:	0621                	addi	a2,a2,8
    8000435c:	060a                	slli	a2,a2,0x2
    8000435e:	00018797          	auipc	a5,0x18
    80004362:	30a78793          	addi	a5,a5,778 # 8001c668 <log>
    80004366:	963e                	add	a2,a2,a5
    80004368:	44dc                	lw	a5,12(s1)
    8000436a:	ca1c                	sw	a5,16(a2)
  if (i == log.lh.n) {  // Add new block to log?
    bpin(b);
    8000436c:	8526                	mv	a0,s1
    8000436e:	fffff097          	auipc	ra,0xfffff
    80004372:	c32080e7          	jalr	-974(ra) # 80002fa0 <bpin>
    log.lh.n++;
    80004376:	00018717          	auipc	a4,0x18
    8000437a:	2f270713          	addi	a4,a4,754 # 8001c668 <log>
    8000437e:	575c                	lw	a5,44(a4)
    80004380:	2785                	addiw	a5,a5,1
    80004382:	d75c                	sw	a5,44(a4)
    80004384:	a83d                	j	800043c2 <log_write+0xd2>
    panic("too big a transaction");
    80004386:	00004517          	auipc	a0,0x4
    8000438a:	29250513          	addi	a0,a0,658 # 80008618 <syscalls+0x1f8>
    8000438e:	ffffc097          	auipc	ra,0xffffc
    80004392:	19c080e7          	jalr	412(ra) # 8000052a <panic>
    panic("log_write outside of trans");
    80004396:	00004517          	auipc	a0,0x4
    8000439a:	29a50513          	addi	a0,a0,666 # 80008630 <syscalls+0x210>
    8000439e:	ffffc097          	auipc	ra,0xffffc
    800043a2:	18c080e7          	jalr	396(ra) # 8000052a <panic>
  for (i = 0; i < log.lh.n; i++) {
    800043a6:	4781                	li	a5,0
  log.lh.block[i] = b->blockno;
    800043a8:	00878713          	addi	a4,a5,8
    800043ac:	00271693          	slli	a3,a4,0x2
    800043b0:	00018717          	auipc	a4,0x18
    800043b4:	2b870713          	addi	a4,a4,696 # 8001c668 <log>
    800043b8:	9736                	add	a4,a4,a3
    800043ba:	44d4                	lw	a3,12(s1)
    800043bc:	cb14                	sw	a3,16(a4)
  if (i == log.lh.n) {  // Add new block to log?
    800043be:	faf607e3          	beq	a2,a5,8000436c <log_write+0x7c>
  }
  release(&log.lock);
    800043c2:	00018517          	auipc	a0,0x18
    800043c6:	2a650513          	addi	a0,a0,678 # 8001c668 <log>
    800043ca:	ffffd097          	auipc	ra,0xffffd
    800043ce:	8ac080e7          	jalr	-1876(ra) # 80000c76 <release>
}
    800043d2:	60e2                	ld	ra,24(sp)
    800043d4:	6442                	ld	s0,16(sp)
    800043d6:	64a2                	ld	s1,8(sp)
    800043d8:	6902                	ld	s2,0(sp)
    800043da:	6105                	addi	sp,sp,32
    800043dc:	8082                	ret

00000000800043de <initsleeplock>:
#include "proc.h"
#include "sleeplock.h"

void
initsleeplock(struct sleeplock *lk, char *name)
{
    800043de:	1101                	addi	sp,sp,-32
    800043e0:	ec06                	sd	ra,24(sp)
    800043e2:	e822                	sd	s0,16(sp)
    800043e4:	e426                	sd	s1,8(sp)
    800043e6:	e04a                	sd	s2,0(sp)
    800043e8:	1000                	addi	s0,sp,32
    800043ea:	84aa                	mv	s1,a0
    800043ec:	892e                	mv	s2,a1
  initlock(&lk->lk, "sleep lock");
    800043ee:	00004597          	auipc	a1,0x4
    800043f2:	26258593          	addi	a1,a1,610 # 80008650 <syscalls+0x230>
    800043f6:	0521                	addi	a0,a0,8
    800043f8:	ffffc097          	auipc	ra,0xffffc
    800043fc:	73a080e7          	jalr	1850(ra) # 80000b32 <initlock>
  lk->name = name;
    80004400:	0324b023          	sd	s2,32(s1)
  lk->locked = 0;
    80004404:	0004a023          	sw	zero,0(s1)
  lk->pid = 0;
    80004408:	0204a423          	sw	zero,40(s1)
}
    8000440c:	60e2                	ld	ra,24(sp)
    8000440e:	6442                	ld	s0,16(sp)
    80004410:	64a2                	ld	s1,8(sp)
    80004412:	6902                	ld	s2,0(sp)
    80004414:	6105                	addi	sp,sp,32
    80004416:	8082                	ret

0000000080004418 <acquiresleep>:

void
acquiresleep(struct sleeplock *lk)
{
    80004418:	1101                	addi	sp,sp,-32
    8000441a:	ec06                	sd	ra,24(sp)
    8000441c:	e822                	sd	s0,16(sp)
    8000441e:	e426                	sd	s1,8(sp)
    80004420:	e04a                	sd	s2,0(sp)
    80004422:	1000                	addi	s0,sp,32
    80004424:	84aa                	mv	s1,a0
  acquire(&lk->lk);
    80004426:	00850913          	addi	s2,a0,8
    8000442a:	854a                	mv	a0,s2
    8000442c:	ffffc097          	auipc	ra,0xffffc
    80004430:	796080e7          	jalr	1942(ra) # 80000bc2 <acquire>
  while (lk->locked) {
    80004434:	409c                	lw	a5,0(s1)
    80004436:	cb89                	beqz	a5,80004448 <acquiresleep+0x30>
    sleep(lk, &lk->lk);
    80004438:	85ca                	mv	a1,s2
    8000443a:	8526                	mv	a0,s1
    8000443c:	ffffe097          	auipc	ra,0xffffe
    80004440:	d82080e7          	jalr	-638(ra) # 800021be <sleep>
  while (lk->locked) {
    80004444:	409c                	lw	a5,0(s1)
    80004446:	fbed                	bnez	a5,80004438 <acquiresleep+0x20>
  }
  lk->locked = 1;
    80004448:	4785                	li	a5,1
    8000444a:	c09c                	sw	a5,0(s1)
  lk->pid = myproc()->pid;
    8000444c:	ffffd097          	auipc	ra,0xffffd
    80004450:	55e080e7          	jalr	1374(ra) # 800019aa <myproc>
    80004454:	5d1c                	lw	a5,56(a0)
    80004456:	d49c                	sw	a5,40(s1)
  release(&lk->lk);
    80004458:	854a                	mv	a0,s2
    8000445a:	ffffd097          	auipc	ra,0xffffd
    8000445e:	81c080e7          	jalr	-2020(ra) # 80000c76 <release>
}
    80004462:	60e2                	ld	ra,24(sp)
    80004464:	6442                	ld	s0,16(sp)
    80004466:	64a2                	ld	s1,8(sp)
    80004468:	6902                	ld	s2,0(sp)
    8000446a:	6105                	addi	sp,sp,32
    8000446c:	8082                	ret

000000008000446e <releasesleep>:

void
releasesleep(struct sleeplock *lk)
{
    8000446e:	1101                	addi	sp,sp,-32
    80004470:	ec06                	sd	ra,24(sp)
    80004472:	e822                	sd	s0,16(sp)
    80004474:	e426                	sd	s1,8(sp)
    80004476:	e04a                	sd	s2,0(sp)
    80004478:	1000                	addi	s0,sp,32
    8000447a:	84aa                	mv	s1,a0
  acquire(&lk->lk);
    8000447c:	00850913          	addi	s2,a0,8
    80004480:	854a                	mv	a0,s2
    80004482:	ffffc097          	auipc	ra,0xffffc
    80004486:	740080e7          	jalr	1856(ra) # 80000bc2 <acquire>
  lk->locked = 0;
    8000448a:	0004a023          	sw	zero,0(s1)
  lk->pid = 0;
    8000448e:	0204a423          	sw	zero,40(s1)
  wakeup(lk);
    80004492:	8526                	mv	a0,s1
    80004494:	ffffe097          	auipc	ra,0xffffe
    80004498:	eaa080e7          	jalr	-342(ra) # 8000233e <wakeup>
  release(&lk->lk);
    8000449c:	854a                	mv	a0,s2
    8000449e:	ffffc097          	auipc	ra,0xffffc
    800044a2:	7d8080e7          	jalr	2008(ra) # 80000c76 <release>
}
    800044a6:	60e2                	ld	ra,24(sp)
    800044a8:	6442                	ld	s0,16(sp)
    800044aa:	64a2                	ld	s1,8(sp)
    800044ac:	6902                	ld	s2,0(sp)
    800044ae:	6105                	addi	sp,sp,32
    800044b0:	8082                	ret

00000000800044b2 <holdingsleep>:

int
holdingsleep(struct sleeplock *lk)
{
    800044b2:	7179                	addi	sp,sp,-48
    800044b4:	f406                	sd	ra,40(sp)
    800044b6:	f022                	sd	s0,32(sp)
    800044b8:	ec26                	sd	s1,24(sp)
    800044ba:	e84a                	sd	s2,16(sp)
    800044bc:	e44e                	sd	s3,8(sp)
    800044be:	1800                	addi	s0,sp,48
    800044c0:	84aa                	mv	s1,a0
  int r;
  
  acquire(&lk->lk);
    800044c2:	00850913          	addi	s2,a0,8
    800044c6:	854a                	mv	a0,s2
    800044c8:	ffffc097          	auipc	ra,0xffffc
    800044cc:	6fa080e7          	jalr	1786(ra) # 80000bc2 <acquire>
  r = lk->locked && (lk->pid == myproc()->pid);
    800044d0:	409c                	lw	a5,0(s1)
    800044d2:	ef99                	bnez	a5,800044f0 <holdingsleep+0x3e>
    800044d4:	4481                	li	s1,0
  release(&lk->lk);
    800044d6:	854a                	mv	a0,s2
    800044d8:	ffffc097          	auipc	ra,0xffffc
    800044dc:	79e080e7          	jalr	1950(ra) # 80000c76 <release>
  return r;
}
    800044e0:	8526                	mv	a0,s1
    800044e2:	70a2                	ld	ra,40(sp)
    800044e4:	7402                	ld	s0,32(sp)
    800044e6:	64e2                	ld	s1,24(sp)
    800044e8:	6942                	ld	s2,16(sp)
    800044ea:	69a2                	ld	s3,8(sp)
    800044ec:	6145                	addi	sp,sp,48
    800044ee:	8082                	ret
  r = lk->locked && (lk->pid == myproc()->pid);
    800044f0:	0284a983          	lw	s3,40(s1)
    800044f4:	ffffd097          	auipc	ra,0xffffd
    800044f8:	4b6080e7          	jalr	1206(ra) # 800019aa <myproc>
    800044fc:	5d04                	lw	s1,56(a0)
    800044fe:	413484b3          	sub	s1,s1,s3
    80004502:	0014b493          	seqz	s1,s1
    80004506:	bfc1                	j	800044d6 <holdingsleep+0x24>

0000000080004508 <fileinit>:
  struct file file[NFILE];
} ftable;

void
fileinit(void)
{
    80004508:	1141                	addi	sp,sp,-16
    8000450a:	e406                	sd	ra,8(sp)
    8000450c:	e022                	sd	s0,0(sp)
    8000450e:	0800                	addi	s0,sp,16
  initlock(&ftable.lock, "ftable");
    80004510:	00004597          	auipc	a1,0x4
    80004514:	15058593          	addi	a1,a1,336 # 80008660 <syscalls+0x240>
    80004518:	00018517          	auipc	a0,0x18
    8000451c:	29850513          	addi	a0,a0,664 # 8001c7b0 <ftable>
    80004520:	ffffc097          	auipc	ra,0xffffc
    80004524:	612080e7          	jalr	1554(ra) # 80000b32 <initlock>
}
    80004528:	60a2                	ld	ra,8(sp)
    8000452a:	6402                	ld	s0,0(sp)
    8000452c:	0141                	addi	sp,sp,16
    8000452e:	8082                	ret

0000000080004530 <filealloc>:

// Allocate a file structure.
struct file*
filealloc(void)
{
    80004530:	1101                	addi	sp,sp,-32
    80004532:	ec06                	sd	ra,24(sp)
    80004534:	e822                	sd	s0,16(sp)
    80004536:	e426                	sd	s1,8(sp)
    80004538:	1000                	addi	s0,sp,32
  struct file *f;

  acquire(&ftable.lock);
    8000453a:	00018517          	auipc	a0,0x18
    8000453e:	27650513          	addi	a0,a0,630 # 8001c7b0 <ftable>
    80004542:	ffffc097          	auipc	ra,0xffffc
    80004546:	680080e7          	jalr	1664(ra) # 80000bc2 <acquire>
  for(f = ftable.file; f < ftable.file + NFILE; f++){
    8000454a:	00018497          	auipc	s1,0x18
    8000454e:	27e48493          	addi	s1,s1,638 # 8001c7c8 <ftable+0x18>
    80004552:	00019717          	auipc	a4,0x19
    80004556:	21670713          	addi	a4,a4,534 # 8001d768 <ftable+0xfb8>
    if(f->ref == 0){
    8000455a:	40dc                	lw	a5,4(s1)
    8000455c:	cf99                	beqz	a5,8000457a <filealloc+0x4a>
  for(f = ftable.file; f < ftable.file + NFILE; f++){
    8000455e:	02848493          	addi	s1,s1,40
    80004562:	fee49ce3          	bne	s1,a4,8000455a <filealloc+0x2a>
      f->ref = 1;
      release(&ftable.lock);
      return f;
    }
  }
  release(&ftable.lock);
    80004566:	00018517          	auipc	a0,0x18
    8000456a:	24a50513          	addi	a0,a0,586 # 8001c7b0 <ftable>
    8000456e:	ffffc097          	auipc	ra,0xffffc
    80004572:	708080e7          	jalr	1800(ra) # 80000c76 <release>
  return 0;
    80004576:	4481                	li	s1,0
    80004578:	a819                	j	8000458e <filealloc+0x5e>
      f->ref = 1;
    8000457a:	4785                	li	a5,1
    8000457c:	c0dc                	sw	a5,4(s1)
      release(&ftable.lock);
    8000457e:	00018517          	auipc	a0,0x18
    80004582:	23250513          	addi	a0,a0,562 # 8001c7b0 <ftable>
    80004586:	ffffc097          	auipc	ra,0xffffc
    8000458a:	6f0080e7          	jalr	1776(ra) # 80000c76 <release>
}
    8000458e:	8526                	mv	a0,s1
    80004590:	60e2                	ld	ra,24(sp)
    80004592:	6442                	ld	s0,16(sp)
    80004594:	64a2                	ld	s1,8(sp)
    80004596:	6105                	addi	sp,sp,32
    80004598:	8082                	ret

000000008000459a <filedup>:

// Increment ref count for file f.
struct file*
filedup(struct file *f)
{
    8000459a:	1101                	addi	sp,sp,-32
    8000459c:	ec06                	sd	ra,24(sp)
    8000459e:	e822                	sd	s0,16(sp)
    800045a0:	e426                	sd	s1,8(sp)
    800045a2:	1000                	addi	s0,sp,32
    800045a4:	84aa                	mv	s1,a0
  acquire(&ftable.lock);
    800045a6:	00018517          	auipc	a0,0x18
    800045aa:	20a50513          	addi	a0,a0,522 # 8001c7b0 <ftable>
    800045ae:	ffffc097          	auipc	ra,0xffffc
    800045b2:	614080e7          	jalr	1556(ra) # 80000bc2 <acquire>
  if(f->ref < 1)
    800045b6:	40dc                	lw	a5,4(s1)
    800045b8:	02f05263          	blez	a5,800045dc <filedup+0x42>
    panic("filedup");
  f->ref++;
    800045bc:	2785                	addiw	a5,a5,1
    800045be:	c0dc                	sw	a5,4(s1)
  release(&ftable.lock);
    800045c0:	00018517          	auipc	a0,0x18
    800045c4:	1f050513          	addi	a0,a0,496 # 8001c7b0 <ftable>
    800045c8:	ffffc097          	auipc	ra,0xffffc
    800045cc:	6ae080e7          	jalr	1710(ra) # 80000c76 <release>
  return f;
}
    800045d0:	8526                	mv	a0,s1
    800045d2:	60e2                	ld	ra,24(sp)
    800045d4:	6442                	ld	s0,16(sp)
    800045d6:	64a2                	ld	s1,8(sp)
    800045d8:	6105                	addi	sp,sp,32
    800045da:	8082                	ret
    panic("filedup");
    800045dc:	00004517          	auipc	a0,0x4
    800045e0:	08c50513          	addi	a0,a0,140 # 80008668 <syscalls+0x248>
    800045e4:	ffffc097          	auipc	ra,0xffffc
    800045e8:	f46080e7          	jalr	-186(ra) # 8000052a <panic>

00000000800045ec <fileclose>:

// Close file f.  (Decrement ref count, close when reaches 0.)
void
fileclose(struct file *f)
{
    800045ec:	7139                	addi	sp,sp,-64
    800045ee:	fc06                	sd	ra,56(sp)
    800045f0:	f822                	sd	s0,48(sp)
    800045f2:	f426                	sd	s1,40(sp)
    800045f4:	f04a                	sd	s2,32(sp)
    800045f6:	ec4e                	sd	s3,24(sp)
    800045f8:	e852                	sd	s4,16(sp)
    800045fa:	e456                	sd	s5,8(sp)
    800045fc:	0080                	addi	s0,sp,64
    800045fe:	84aa                	mv	s1,a0
  struct file ff;

  acquire(&ftable.lock);
    80004600:	00018517          	auipc	a0,0x18
    80004604:	1b050513          	addi	a0,a0,432 # 8001c7b0 <ftable>
    80004608:	ffffc097          	auipc	ra,0xffffc
    8000460c:	5ba080e7          	jalr	1466(ra) # 80000bc2 <acquire>
  if(f->ref < 1)
    80004610:	40dc                	lw	a5,4(s1)
    80004612:	06f05163          	blez	a5,80004674 <fileclose+0x88>
    panic("fileclose");
  if(--f->ref > 0){
    80004616:	37fd                	addiw	a5,a5,-1
    80004618:	0007871b          	sext.w	a4,a5
    8000461c:	c0dc                	sw	a5,4(s1)
    8000461e:	06e04363          	bgtz	a4,80004684 <fileclose+0x98>
    release(&ftable.lock);
    return;
  }
  ff = *f;
    80004622:	0004a903          	lw	s2,0(s1)
    80004626:	0094ca83          	lbu	s5,9(s1)
    8000462a:	0104ba03          	ld	s4,16(s1)
    8000462e:	0184b983          	ld	s3,24(s1)
  f->ref = 0;
    80004632:	0004a223          	sw	zero,4(s1)
  f->type = FD_NONE;
    80004636:	0004a023          	sw	zero,0(s1)
  release(&ftable.lock);
    8000463a:	00018517          	auipc	a0,0x18
    8000463e:	17650513          	addi	a0,a0,374 # 8001c7b0 <ftable>
    80004642:	ffffc097          	auipc	ra,0xffffc
    80004646:	634080e7          	jalr	1588(ra) # 80000c76 <release>

  if(ff.type == FD_PIPE){
    8000464a:	4785                	li	a5,1
    8000464c:	04f90d63          	beq	s2,a5,800046a6 <fileclose+0xba>
    pipeclose(ff.pipe, ff.writable);
  } else if(ff.type == FD_INODE || ff.type == FD_DEVICE){
    80004650:	3979                	addiw	s2,s2,-2
    80004652:	4785                	li	a5,1
    80004654:	0527e063          	bltu	a5,s2,80004694 <fileclose+0xa8>
    begin_op();
    80004658:	00000097          	auipc	ra,0x0
    8000465c:	ac0080e7          	jalr	-1344(ra) # 80004118 <begin_op>
    iput(ff.ip);
    80004660:	854e                	mv	a0,s3
    80004662:	fffff097          	auipc	ra,0xfffff
    80004666:	29c080e7          	jalr	668(ra) # 800038fe <iput>
    end_op();
    8000466a:	00000097          	auipc	ra,0x0
    8000466e:	b2e080e7          	jalr	-1234(ra) # 80004198 <end_op>
    80004672:	a00d                	j	80004694 <fileclose+0xa8>
    panic("fileclose");
    80004674:	00004517          	auipc	a0,0x4
    80004678:	ffc50513          	addi	a0,a0,-4 # 80008670 <syscalls+0x250>
    8000467c:	ffffc097          	auipc	ra,0xffffc
    80004680:	eae080e7          	jalr	-338(ra) # 8000052a <panic>
    release(&ftable.lock);
    80004684:	00018517          	auipc	a0,0x18
    80004688:	12c50513          	addi	a0,a0,300 # 8001c7b0 <ftable>
    8000468c:	ffffc097          	auipc	ra,0xffffc
    80004690:	5ea080e7          	jalr	1514(ra) # 80000c76 <release>
  }
}
    80004694:	70e2                	ld	ra,56(sp)
    80004696:	7442                	ld	s0,48(sp)
    80004698:	74a2                	ld	s1,40(sp)
    8000469a:	7902                	ld	s2,32(sp)
    8000469c:	69e2                	ld	s3,24(sp)
    8000469e:	6a42                	ld	s4,16(sp)
    800046a0:	6aa2                	ld	s5,8(sp)
    800046a2:	6121                	addi	sp,sp,64
    800046a4:	8082                	ret
    pipeclose(ff.pipe, ff.writable);
    800046a6:	85d6                	mv	a1,s5
    800046a8:	8552                	mv	a0,s4
    800046aa:	00000097          	auipc	ra,0x0
    800046ae:	34c080e7          	jalr	844(ra) # 800049f6 <pipeclose>
    800046b2:	b7cd                	j	80004694 <fileclose+0xa8>

00000000800046b4 <filestat>:

// Get metadata about file f.
// addr is a user virtual address, pointing to a struct stat.
int
filestat(struct file *f, uint64 addr)
{
    800046b4:	715d                	addi	sp,sp,-80
    800046b6:	e486                	sd	ra,72(sp)
    800046b8:	e0a2                	sd	s0,64(sp)
    800046ba:	fc26                	sd	s1,56(sp)
    800046bc:	f84a                	sd	s2,48(sp)
    800046be:	f44e                	sd	s3,40(sp)
    800046c0:	0880                	addi	s0,sp,80
    800046c2:	84aa                	mv	s1,a0
    800046c4:	89ae                	mv	s3,a1
  struct proc *p = myproc();
    800046c6:	ffffd097          	auipc	ra,0xffffd
    800046ca:	2e4080e7          	jalr	740(ra) # 800019aa <myproc>
  struct stat st;
  
  if(f->type == FD_INODE || f->type == FD_DEVICE){
    800046ce:	409c                	lw	a5,0(s1)
    800046d0:	37f9                	addiw	a5,a5,-2
    800046d2:	4705                	li	a4,1
    800046d4:	04f76763          	bltu	a4,a5,80004722 <filestat+0x6e>
    800046d8:	892a                	mv	s2,a0
    ilock(f->ip);
    800046da:	6c88                	ld	a0,24(s1)
    800046dc:	fffff097          	auipc	ra,0xfffff
    800046e0:	fbe080e7          	jalr	-66(ra) # 8000369a <ilock>
    stati(f->ip, &st);
    800046e4:	fb840593          	addi	a1,s0,-72
    800046e8:	6c88                	ld	a0,24(s1)
    800046ea:	fffff097          	auipc	ra,0xfffff
    800046ee:	2e4080e7          	jalr	740(ra) # 800039ce <stati>
    iunlock(f->ip);
    800046f2:	6c88                	ld	a0,24(s1)
    800046f4:	fffff097          	auipc	ra,0xfffff
    800046f8:	068080e7          	jalr	104(ra) # 8000375c <iunlock>
    if(copyout(p->pagetable, addr, (char *)&st, sizeof(st)) < 0)
    800046fc:	46e1                	li	a3,24
    800046fe:	fb840613          	addi	a2,s0,-72
    80004702:	85ce                	mv	a1,s3
    80004704:	05093503          	ld	a0,80(s2)
    80004708:	ffffd097          	auipc	ra,0xffffd
    8000470c:	f36080e7          	jalr	-202(ra) # 8000163e <copyout>
    80004710:	41f5551b          	sraiw	a0,a0,0x1f
      return -1;
    return 0;
  }
  return -1;
}
    80004714:	60a6                	ld	ra,72(sp)
    80004716:	6406                	ld	s0,64(sp)
    80004718:	74e2                	ld	s1,56(sp)
    8000471a:	7942                	ld	s2,48(sp)
    8000471c:	79a2                	ld	s3,40(sp)
    8000471e:	6161                	addi	sp,sp,80
    80004720:	8082                	ret
  return -1;
    80004722:	557d                	li	a0,-1
    80004724:	bfc5                	j	80004714 <filestat+0x60>

0000000080004726 <fileread>:

// Read from file f.
// addr is a user virtual address.
int
fileread(struct file *f, uint64 addr, int n)
{
    80004726:	7179                	addi	sp,sp,-48
    80004728:	f406                	sd	ra,40(sp)
    8000472a:	f022                	sd	s0,32(sp)
    8000472c:	ec26                	sd	s1,24(sp)
    8000472e:	e84a                	sd	s2,16(sp)
    80004730:	e44e                	sd	s3,8(sp)
    80004732:	1800                	addi	s0,sp,48
  int r = 0;

  if(f->readable == 0)
    80004734:	00854783          	lbu	a5,8(a0)
    80004738:	c3d5                	beqz	a5,800047dc <fileread+0xb6>
    8000473a:	84aa                	mv	s1,a0
    8000473c:	89ae                	mv	s3,a1
    8000473e:	8932                	mv	s2,a2
    return -1;

  if(f->type == FD_PIPE){
    80004740:	411c                	lw	a5,0(a0)
    80004742:	4705                	li	a4,1
    80004744:	04e78963          	beq	a5,a4,80004796 <fileread+0x70>
    r = piperead(f->pipe, addr, n);
  } else if(f->type == FD_DEVICE){
    80004748:	470d                	li	a4,3
    8000474a:	04e78d63          	beq	a5,a4,800047a4 <fileread+0x7e>
    if(f->major < 0 || f->major >= NDEV || !devsw[f->major].read)
      return -1;
    r = devsw[f->major].read(1, addr, n);
  } else if(f->type == FD_INODE){
    8000474e:	4709                	li	a4,2
    80004750:	06e79e63          	bne	a5,a4,800047cc <fileread+0xa6>
    ilock(f->ip);
    80004754:	6d08                	ld	a0,24(a0)
    80004756:	fffff097          	auipc	ra,0xfffff
    8000475a:	f44080e7          	jalr	-188(ra) # 8000369a <ilock>
    if((r = readi(f->ip, 1, addr, f->off, n)) > 0)
    8000475e:	874a                	mv	a4,s2
    80004760:	5094                	lw	a3,32(s1)
    80004762:	864e                	mv	a2,s3
    80004764:	4585                	li	a1,1
    80004766:	6c88                	ld	a0,24(s1)
    80004768:	fffff097          	auipc	ra,0xfffff
    8000476c:	290080e7          	jalr	656(ra) # 800039f8 <readi>
    80004770:	892a                	mv	s2,a0
    80004772:	00a05563          	blez	a0,8000477c <fileread+0x56>
      f->off += r;
    80004776:	509c                	lw	a5,32(s1)
    80004778:	9fa9                	addw	a5,a5,a0
    8000477a:	d09c                	sw	a5,32(s1)
    iunlock(f->ip);
    8000477c:	6c88                	ld	a0,24(s1)
    8000477e:	fffff097          	auipc	ra,0xfffff
    80004782:	fde080e7          	jalr	-34(ra) # 8000375c <iunlock>
  } else {
    panic("fileread");
  }

  return r;
}
    80004786:	854a                	mv	a0,s2
    80004788:	70a2                	ld	ra,40(sp)
    8000478a:	7402                	ld	s0,32(sp)
    8000478c:	64e2                	ld	s1,24(sp)
    8000478e:	6942                	ld	s2,16(sp)
    80004790:	69a2                	ld	s3,8(sp)
    80004792:	6145                	addi	sp,sp,48
    80004794:	8082                	ret
    r = piperead(f->pipe, addr, n);
    80004796:	6908                	ld	a0,16(a0)
    80004798:	00000097          	auipc	ra,0x0
    8000479c:	3c0080e7          	jalr	960(ra) # 80004b58 <piperead>
    800047a0:	892a                	mv	s2,a0
    800047a2:	b7d5                	j	80004786 <fileread+0x60>
    if(f->major < 0 || f->major >= NDEV || !devsw[f->major].read)
    800047a4:	02451783          	lh	a5,36(a0)
    800047a8:	03079693          	slli	a3,a5,0x30
    800047ac:	92c1                	srli	a3,a3,0x30
    800047ae:	4725                	li	a4,9
    800047b0:	02d76863          	bltu	a4,a3,800047e0 <fileread+0xba>
    800047b4:	0792                	slli	a5,a5,0x4
    800047b6:	00018717          	auipc	a4,0x18
    800047ba:	f5a70713          	addi	a4,a4,-166 # 8001c710 <devsw>
    800047be:	97ba                	add	a5,a5,a4
    800047c0:	639c                	ld	a5,0(a5)
    800047c2:	c38d                	beqz	a5,800047e4 <fileread+0xbe>
    r = devsw[f->major].read(1, addr, n);
    800047c4:	4505                	li	a0,1
    800047c6:	9782                	jalr	a5
    800047c8:	892a                	mv	s2,a0
    800047ca:	bf75                	j	80004786 <fileread+0x60>
    panic("fileread");
    800047cc:	00004517          	auipc	a0,0x4
    800047d0:	eb450513          	addi	a0,a0,-332 # 80008680 <syscalls+0x260>
    800047d4:	ffffc097          	auipc	ra,0xffffc
    800047d8:	d56080e7          	jalr	-682(ra) # 8000052a <panic>
    return -1;
    800047dc:	597d                	li	s2,-1
    800047de:	b765                	j	80004786 <fileread+0x60>
      return -1;
    800047e0:	597d                	li	s2,-1
    800047e2:	b755                	j	80004786 <fileread+0x60>
    800047e4:	597d                	li	s2,-1
    800047e6:	b745                	j	80004786 <fileread+0x60>

00000000800047e8 <filewrite>:

// Write to file f.
// addr is a user virtual address.
int
filewrite(struct file *f, uint64 addr, int n)
{
    800047e8:	715d                	addi	sp,sp,-80
    800047ea:	e486                	sd	ra,72(sp)
    800047ec:	e0a2                	sd	s0,64(sp)
    800047ee:	fc26                	sd	s1,56(sp)
    800047f0:	f84a                	sd	s2,48(sp)
    800047f2:	f44e                	sd	s3,40(sp)
    800047f4:	f052                	sd	s4,32(sp)
    800047f6:	ec56                	sd	s5,24(sp)
    800047f8:	e85a                	sd	s6,16(sp)
    800047fa:	e45e                	sd	s7,8(sp)
    800047fc:	e062                	sd	s8,0(sp)
    800047fe:	0880                	addi	s0,sp,80
  int r, ret = 0;

  if(f->writable == 0)
    80004800:	00954783          	lbu	a5,9(a0)
    80004804:	10078663          	beqz	a5,80004910 <filewrite+0x128>
    80004808:	892a                	mv	s2,a0
    8000480a:	8aae                	mv	s5,a1
    8000480c:	8a32                	mv	s4,a2
    return -1;

  if(f->type == FD_PIPE){
    8000480e:	411c                	lw	a5,0(a0)
    80004810:	4705                	li	a4,1
    80004812:	02e78263          	beq	a5,a4,80004836 <filewrite+0x4e>
    ret = pipewrite(f->pipe, addr, n);
  } else if(f->type == FD_DEVICE){
    80004816:	470d                	li	a4,3
    80004818:	02e78663          	beq	a5,a4,80004844 <filewrite+0x5c>
    if(f->major < 0 || f->major >= NDEV || !devsw[f->major].write)
      return -1;
    ret = devsw[f->major].write(1, addr, n);
  } else if(f->type == FD_INODE){
    8000481c:	4709                	li	a4,2
    8000481e:	0ee79163          	bne	a5,a4,80004900 <filewrite+0x118>
    // and 2 blocks of slop for non-aligned writes.
    // this really belongs lower down, since writei()
    // might be writing a device like the console.
    int max = ((MAXOPBLOCKS-1-1-2) / 2) * BSIZE;
    int i = 0;
    while(i < n){
    80004822:	0ac05d63          	blez	a2,800048dc <filewrite+0xf4>
    int i = 0;
    80004826:	4981                	li	s3,0
    80004828:	6b05                	lui	s6,0x1
    8000482a:	c00b0b13          	addi	s6,s6,-1024 # c00 <_entry-0x7ffff400>
    8000482e:	6b85                	lui	s7,0x1
    80004830:	c00b8b9b          	addiw	s7,s7,-1024
    80004834:	a861                	j	800048cc <filewrite+0xe4>
    ret = pipewrite(f->pipe, addr, n);
    80004836:	6908                	ld	a0,16(a0)
    80004838:	00000097          	auipc	ra,0x0
    8000483c:	22e080e7          	jalr	558(ra) # 80004a66 <pipewrite>
    80004840:	8a2a                	mv	s4,a0
    80004842:	a045                	j	800048e2 <filewrite+0xfa>
    if(f->major < 0 || f->major >= NDEV || !devsw[f->major].write)
    80004844:	02451783          	lh	a5,36(a0)
    80004848:	03079693          	slli	a3,a5,0x30
    8000484c:	92c1                	srli	a3,a3,0x30
    8000484e:	4725                	li	a4,9
    80004850:	0cd76263          	bltu	a4,a3,80004914 <filewrite+0x12c>
    80004854:	0792                	slli	a5,a5,0x4
    80004856:	00018717          	auipc	a4,0x18
    8000485a:	eba70713          	addi	a4,a4,-326 # 8001c710 <devsw>
    8000485e:	97ba                	add	a5,a5,a4
    80004860:	679c                	ld	a5,8(a5)
    80004862:	cbdd                	beqz	a5,80004918 <filewrite+0x130>
    ret = devsw[f->major].write(1, addr, n);
    80004864:	4505                	li	a0,1
    80004866:	9782                	jalr	a5
    80004868:	8a2a                	mv	s4,a0
    8000486a:	a8a5                	j	800048e2 <filewrite+0xfa>
    8000486c:	00048c1b          	sext.w	s8,s1
      int n1 = n - i;
      if(n1 > max)
        n1 = max;

      begin_op();
    80004870:	00000097          	auipc	ra,0x0
    80004874:	8a8080e7          	jalr	-1880(ra) # 80004118 <begin_op>
      ilock(f->ip);
    80004878:	01893503          	ld	a0,24(s2)
    8000487c:	fffff097          	auipc	ra,0xfffff
    80004880:	e1e080e7          	jalr	-482(ra) # 8000369a <ilock>
      if ((r = writei(f->ip, 1, addr + i, f->off, n1)) > 0)
    80004884:	8762                	mv	a4,s8
    80004886:	02092683          	lw	a3,32(s2)
    8000488a:	01598633          	add	a2,s3,s5
    8000488e:	4585                	li	a1,1
    80004890:	01893503          	ld	a0,24(s2)
    80004894:	fffff097          	auipc	ra,0xfffff
    80004898:	25c080e7          	jalr	604(ra) # 80003af0 <writei>
    8000489c:	84aa                	mv	s1,a0
    8000489e:	00a05763          	blez	a0,800048ac <filewrite+0xc4>
        f->off += r;
    800048a2:	02092783          	lw	a5,32(s2)
    800048a6:	9fa9                	addw	a5,a5,a0
    800048a8:	02f92023          	sw	a5,32(s2)
      iunlock(f->ip);
    800048ac:	01893503          	ld	a0,24(s2)
    800048b0:	fffff097          	auipc	ra,0xfffff
    800048b4:	eac080e7          	jalr	-340(ra) # 8000375c <iunlock>
      end_op();
    800048b8:	00000097          	auipc	ra,0x0
    800048bc:	8e0080e7          	jalr	-1824(ra) # 80004198 <end_op>

      if(r != n1){
    800048c0:	009c1f63          	bne	s8,s1,800048de <filewrite+0xf6>
        // error from writei
        break;
      }
      i += r;
    800048c4:	013489bb          	addw	s3,s1,s3
    while(i < n){
    800048c8:	0149db63          	bge	s3,s4,800048de <filewrite+0xf6>
      int n1 = n - i;
    800048cc:	413a07bb          	subw	a5,s4,s3
      if(n1 > max)
    800048d0:	84be                	mv	s1,a5
    800048d2:	2781                	sext.w	a5,a5
    800048d4:	f8fb5ce3          	bge	s6,a5,8000486c <filewrite+0x84>
    800048d8:	84de                	mv	s1,s7
    800048da:	bf49                	j	8000486c <filewrite+0x84>
    int i = 0;
    800048dc:	4981                	li	s3,0
    }
    ret = (i == n ? n : -1);
    800048de:	013a1f63          	bne	s4,s3,800048fc <filewrite+0x114>
  } else {
    panic("filewrite");
  }

  return ret;
}
    800048e2:	8552                	mv	a0,s4
    800048e4:	60a6                	ld	ra,72(sp)
    800048e6:	6406                	ld	s0,64(sp)
    800048e8:	74e2                	ld	s1,56(sp)
    800048ea:	7942                	ld	s2,48(sp)
    800048ec:	79a2                	ld	s3,40(sp)
    800048ee:	7a02                	ld	s4,32(sp)
    800048f0:	6ae2                	ld	s5,24(sp)
    800048f2:	6b42                	ld	s6,16(sp)
    800048f4:	6ba2                	ld	s7,8(sp)
    800048f6:	6c02                	ld	s8,0(sp)
    800048f8:	6161                	addi	sp,sp,80
    800048fa:	8082                	ret
    ret = (i == n ? n : -1);
    800048fc:	5a7d                	li	s4,-1
    800048fe:	b7d5                	j	800048e2 <filewrite+0xfa>
    panic("filewrite");
    80004900:	00004517          	auipc	a0,0x4
    80004904:	d9050513          	addi	a0,a0,-624 # 80008690 <syscalls+0x270>
    80004908:	ffffc097          	auipc	ra,0xffffc
    8000490c:	c22080e7          	jalr	-990(ra) # 8000052a <panic>
    return -1;
    80004910:	5a7d                	li	s4,-1
    80004912:	bfc1                	j	800048e2 <filewrite+0xfa>
      return -1;
    80004914:	5a7d                	li	s4,-1
    80004916:	b7f1                	j	800048e2 <filewrite+0xfa>
    80004918:	5a7d                	li	s4,-1
    8000491a:	b7e1                	j	800048e2 <filewrite+0xfa>

000000008000491c <pipealloc>:
  int writeopen;  // write fd is still open
};

int
pipealloc(struct file **f0, struct file **f1)
{
    8000491c:	7179                	addi	sp,sp,-48
    8000491e:	f406                	sd	ra,40(sp)
    80004920:	f022                	sd	s0,32(sp)
    80004922:	ec26                	sd	s1,24(sp)
    80004924:	e84a                	sd	s2,16(sp)
    80004926:	e44e                	sd	s3,8(sp)
    80004928:	e052                	sd	s4,0(sp)
    8000492a:	1800                	addi	s0,sp,48
    8000492c:	84aa                	mv	s1,a0
    8000492e:	8a2e                	mv	s4,a1
  struct pipe *pi;

  pi = 0;
  *f0 = *f1 = 0;
    80004930:	0005b023          	sd	zero,0(a1)
    80004934:	00053023          	sd	zero,0(a0)
  if((*f0 = filealloc()) == 0 || (*f1 = filealloc()) == 0)
    80004938:	00000097          	auipc	ra,0x0
    8000493c:	bf8080e7          	jalr	-1032(ra) # 80004530 <filealloc>
    80004940:	e088                	sd	a0,0(s1)
    80004942:	c551                	beqz	a0,800049ce <pipealloc+0xb2>
    80004944:	00000097          	auipc	ra,0x0
    80004948:	bec080e7          	jalr	-1044(ra) # 80004530 <filealloc>
    8000494c:	00aa3023          	sd	a0,0(s4)
    80004950:	c92d                	beqz	a0,800049c2 <pipealloc+0xa6>
    goto bad;
  if((pi = (struct pipe*)kalloc()) == 0)
    80004952:	ffffc097          	auipc	ra,0xffffc
    80004956:	180080e7          	jalr	384(ra) # 80000ad2 <kalloc>
    8000495a:	892a                	mv	s2,a0
    8000495c:	c125                	beqz	a0,800049bc <pipealloc+0xa0>
    goto bad;
  pi->readopen = 1;
    8000495e:	4985                	li	s3,1
    80004960:	23352023          	sw	s3,544(a0)
  pi->writeopen = 1;
    80004964:	23352223          	sw	s3,548(a0)
  pi->nwrite = 0;
    80004968:	20052e23          	sw	zero,540(a0)
  pi->nread = 0;
    8000496c:	20052c23          	sw	zero,536(a0)
  initlock(&pi->lock, "pipe");
    80004970:	00004597          	auipc	a1,0x4
    80004974:	d3058593          	addi	a1,a1,-720 # 800086a0 <syscalls+0x280>
    80004978:	ffffc097          	auipc	ra,0xffffc
    8000497c:	1ba080e7          	jalr	442(ra) # 80000b32 <initlock>
  (*f0)->type = FD_PIPE;
    80004980:	609c                	ld	a5,0(s1)
    80004982:	0137a023          	sw	s3,0(a5)
  (*f0)->readable = 1;
    80004986:	609c                	ld	a5,0(s1)
    80004988:	01378423          	sb	s3,8(a5)
  (*f0)->writable = 0;
    8000498c:	609c                	ld	a5,0(s1)
    8000498e:	000784a3          	sb	zero,9(a5)
  (*f0)->pipe = pi;
    80004992:	609c                	ld	a5,0(s1)
    80004994:	0127b823          	sd	s2,16(a5)
  (*f1)->type = FD_PIPE;
    80004998:	000a3783          	ld	a5,0(s4)
    8000499c:	0137a023          	sw	s3,0(a5)
  (*f1)->readable = 0;
    800049a0:	000a3783          	ld	a5,0(s4)
    800049a4:	00078423          	sb	zero,8(a5)
  (*f1)->writable = 1;
    800049a8:	000a3783          	ld	a5,0(s4)
    800049ac:	013784a3          	sb	s3,9(a5)
  (*f1)->pipe = pi;
    800049b0:	000a3783          	ld	a5,0(s4)
    800049b4:	0127b823          	sd	s2,16(a5)
  return 0;
    800049b8:	4501                	li	a0,0
    800049ba:	a025                	j	800049e2 <pipealloc+0xc6>

 bad:
  if(pi)
    kfree((char*)pi);
  if(*f0)
    800049bc:	6088                	ld	a0,0(s1)
    800049be:	e501                	bnez	a0,800049c6 <pipealloc+0xaa>
    800049c0:	a039                	j	800049ce <pipealloc+0xb2>
    800049c2:	6088                	ld	a0,0(s1)
    800049c4:	c51d                	beqz	a0,800049f2 <pipealloc+0xd6>
    fileclose(*f0);
    800049c6:	00000097          	auipc	ra,0x0
    800049ca:	c26080e7          	jalr	-986(ra) # 800045ec <fileclose>
  if(*f1)
    800049ce:	000a3783          	ld	a5,0(s4)
    fileclose(*f1);
  return -1;
    800049d2:	557d                	li	a0,-1
  if(*f1)
    800049d4:	c799                	beqz	a5,800049e2 <pipealloc+0xc6>
    fileclose(*f1);
    800049d6:	853e                	mv	a0,a5
    800049d8:	00000097          	auipc	ra,0x0
    800049dc:	c14080e7          	jalr	-1004(ra) # 800045ec <fileclose>
  return -1;
    800049e0:	557d                	li	a0,-1
}
    800049e2:	70a2                	ld	ra,40(sp)
    800049e4:	7402                	ld	s0,32(sp)
    800049e6:	64e2                	ld	s1,24(sp)
    800049e8:	6942                	ld	s2,16(sp)
    800049ea:	69a2                	ld	s3,8(sp)
    800049ec:	6a02                	ld	s4,0(sp)
    800049ee:	6145                	addi	sp,sp,48
    800049f0:	8082                	ret
  return -1;
    800049f2:	557d                	li	a0,-1
    800049f4:	b7fd                	j	800049e2 <pipealloc+0xc6>

00000000800049f6 <pipeclose>:

void
pipeclose(struct pipe *pi, int writable)
{
    800049f6:	1101                	addi	sp,sp,-32
    800049f8:	ec06                	sd	ra,24(sp)
    800049fa:	e822                	sd	s0,16(sp)
    800049fc:	e426                	sd	s1,8(sp)
    800049fe:	e04a                	sd	s2,0(sp)
    80004a00:	1000                	addi	s0,sp,32
    80004a02:	84aa                	mv	s1,a0
    80004a04:	892e                	mv	s2,a1
  acquire(&pi->lock);
    80004a06:	ffffc097          	auipc	ra,0xffffc
    80004a0a:	1bc080e7          	jalr	444(ra) # 80000bc2 <acquire>
  if(writable){
    80004a0e:	02090d63          	beqz	s2,80004a48 <pipeclose+0x52>
    pi->writeopen = 0;
    80004a12:	2204a223          	sw	zero,548(s1)
    wakeup(&pi->nread);
    80004a16:	21848513          	addi	a0,s1,536
    80004a1a:	ffffe097          	auipc	ra,0xffffe
    80004a1e:	924080e7          	jalr	-1756(ra) # 8000233e <wakeup>
  } else {
    pi->readopen = 0;
    wakeup(&pi->nwrite);
  }
  if(pi->readopen == 0 && pi->writeopen == 0){
    80004a22:	2204b783          	ld	a5,544(s1)
    80004a26:	eb95                	bnez	a5,80004a5a <pipeclose+0x64>
    release(&pi->lock);
    80004a28:	8526                	mv	a0,s1
    80004a2a:	ffffc097          	auipc	ra,0xffffc
    80004a2e:	24c080e7          	jalr	588(ra) # 80000c76 <release>
    kfree((char*)pi);
    80004a32:	8526                	mv	a0,s1
    80004a34:	ffffc097          	auipc	ra,0xffffc
    80004a38:	fa2080e7          	jalr	-94(ra) # 800009d6 <kfree>
  } else
    release(&pi->lock);
}
    80004a3c:	60e2                	ld	ra,24(sp)
    80004a3e:	6442                	ld	s0,16(sp)
    80004a40:	64a2                	ld	s1,8(sp)
    80004a42:	6902                	ld	s2,0(sp)
    80004a44:	6105                	addi	sp,sp,32
    80004a46:	8082                	ret
    pi->readopen = 0;
    80004a48:	2204a023          	sw	zero,544(s1)
    wakeup(&pi->nwrite);
    80004a4c:	21c48513          	addi	a0,s1,540
    80004a50:	ffffe097          	auipc	ra,0xffffe
    80004a54:	8ee080e7          	jalr	-1810(ra) # 8000233e <wakeup>
    80004a58:	b7e9                	j	80004a22 <pipeclose+0x2c>
    release(&pi->lock);
    80004a5a:	8526                	mv	a0,s1
    80004a5c:	ffffc097          	auipc	ra,0xffffc
    80004a60:	21a080e7          	jalr	538(ra) # 80000c76 <release>
}
    80004a64:	bfe1                	j	80004a3c <pipeclose+0x46>

0000000080004a66 <pipewrite>:

int
pipewrite(struct pipe *pi, uint64 addr, int n)
{
    80004a66:	711d                	addi	sp,sp,-96
    80004a68:	ec86                	sd	ra,88(sp)
    80004a6a:	e8a2                	sd	s0,80(sp)
    80004a6c:	e4a6                	sd	s1,72(sp)
    80004a6e:	e0ca                	sd	s2,64(sp)
    80004a70:	fc4e                	sd	s3,56(sp)
    80004a72:	f852                	sd	s4,48(sp)
    80004a74:	f456                	sd	s5,40(sp)
    80004a76:	f05a                	sd	s6,32(sp)
    80004a78:	ec5e                	sd	s7,24(sp)
    80004a7a:	e862                	sd	s8,16(sp)
    80004a7c:	1080                	addi	s0,sp,96
    80004a7e:	84aa                	mv	s1,a0
    80004a80:	8aae                	mv	s5,a1
    80004a82:	8a32                	mv	s4,a2
  int i = 0;
  struct proc *pr = myproc();
    80004a84:	ffffd097          	auipc	ra,0xffffd
    80004a88:	f26080e7          	jalr	-218(ra) # 800019aa <myproc>
    80004a8c:	89aa                	mv	s3,a0

  acquire(&pi->lock);
    80004a8e:	8526                	mv	a0,s1
    80004a90:	ffffc097          	auipc	ra,0xffffc
    80004a94:	132080e7          	jalr	306(ra) # 80000bc2 <acquire>
  while(i < n){
    80004a98:	0b405363          	blez	s4,80004b3e <pipewrite+0xd8>
  int i = 0;
    80004a9c:	4901                	li	s2,0
    if(pi->nwrite == pi->nread + PIPESIZE){ //DOC: pipewrite-full
      wakeup(&pi->nread);
      sleep(&pi->nwrite, &pi->lock);
    } else {
      char ch;
      if(copyin(pr->pagetable, &ch, addr + i, 1) == -1)
    80004a9e:	5b7d                	li	s6,-1
      wakeup(&pi->nread);
    80004aa0:	21848c13          	addi	s8,s1,536
      sleep(&pi->nwrite, &pi->lock);
    80004aa4:	21c48b93          	addi	s7,s1,540
    80004aa8:	a089                	j	80004aea <pipewrite+0x84>
      release(&pi->lock);
    80004aaa:	8526                	mv	a0,s1
    80004aac:	ffffc097          	auipc	ra,0xffffc
    80004ab0:	1ca080e7          	jalr	458(ra) # 80000c76 <release>
      return -1;
    80004ab4:	597d                	li	s2,-1
  }
  wakeup(&pi->nread);
  release(&pi->lock);

  return i;
}
    80004ab6:	854a                	mv	a0,s2
    80004ab8:	60e6                	ld	ra,88(sp)
    80004aba:	6446                	ld	s0,80(sp)
    80004abc:	64a6                	ld	s1,72(sp)
    80004abe:	6906                	ld	s2,64(sp)
    80004ac0:	79e2                	ld	s3,56(sp)
    80004ac2:	7a42                	ld	s4,48(sp)
    80004ac4:	7aa2                	ld	s5,40(sp)
    80004ac6:	7b02                	ld	s6,32(sp)
    80004ac8:	6be2                	ld	s7,24(sp)
    80004aca:	6c42                	ld	s8,16(sp)
    80004acc:	6125                	addi	sp,sp,96
    80004ace:	8082                	ret
      wakeup(&pi->nread);
    80004ad0:	8562                	mv	a0,s8
    80004ad2:	ffffe097          	auipc	ra,0xffffe
    80004ad6:	86c080e7          	jalr	-1940(ra) # 8000233e <wakeup>
      sleep(&pi->nwrite, &pi->lock);
    80004ada:	85a6                	mv	a1,s1
    80004adc:	855e                	mv	a0,s7
    80004ade:	ffffd097          	auipc	ra,0xffffd
    80004ae2:	6e0080e7          	jalr	1760(ra) # 800021be <sleep>
  while(i < n){
    80004ae6:	05495d63          	bge	s2,s4,80004b40 <pipewrite+0xda>
    if(pi->readopen == 0 || pr->killed){
    80004aea:	2204a783          	lw	a5,544(s1)
    80004aee:	dfd5                	beqz	a5,80004aaa <pipewrite+0x44>
    80004af0:	0309a783          	lw	a5,48(s3)
    80004af4:	fbdd                	bnez	a5,80004aaa <pipewrite+0x44>
    if(pi->nwrite == pi->nread + PIPESIZE){ //DOC: pipewrite-full
    80004af6:	2184a783          	lw	a5,536(s1)
    80004afa:	21c4a703          	lw	a4,540(s1)
    80004afe:	2007879b          	addiw	a5,a5,512
    80004b02:	fcf707e3          	beq	a4,a5,80004ad0 <pipewrite+0x6a>
      if(copyin(pr->pagetable, &ch, addr + i, 1) == -1)
    80004b06:	4685                	li	a3,1
    80004b08:	01590633          	add	a2,s2,s5
    80004b0c:	faf40593          	addi	a1,s0,-81
    80004b10:	0509b503          	ld	a0,80(s3)
    80004b14:	ffffd097          	auipc	ra,0xffffd
    80004b18:	bb6080e7          	jalr	-1098(ra) # 800016ca <copyin>
    80004b1c:	03650263          	beq	a0,s6,80004b40 <pipewrite+0xda>
      pi->data[pi->nwrite++ % PIPESIZE] = ch;
    80004b20:	21c4a783          	lw	a5,540(s1)
    80004b24:	0017871b          	addiw	a4,a5,1
    80004b28:	20e4ae23          	sw	a4,540(s1)
    80004b2c:	1ff7f793          	andi	a5,a5,511
    80004b30:	97a6                	add	a5,a5,s1
    80004b32:	faf44703          	lbu	a4,-81(s0)
    80004b36:	00e78c23          	sb	a4,24(a5)
      i++;
    80004b3a:	2905                	addiw	s2,s2,1
    80004b3c:	b76d                	j	80004ae6 <pipewrite+0x80>
  int i = 0;
    80004b3e:	4901                	li	s2,0
  wakeup(&pi->nread);
    80004b40:	21848513          	addi	a0,s1,536
    80004b44:	ffffd097          	auipc	ra,0xffffd
    80004b48:	7fa080e7          	jalr	2042(ra) # 8000233e <wakeup>
  release(&pi->lock);
    80004b4c:	8526                	mv	a0,s1
    80004b4e:	ffffc097          	auipc	ra,0xffffc
    80004b52:	128080e7          	jalr	296(ra) # 80000c76 <release>
  return i;
    80004b56:	b785                	j	80004ab6 <pipewrite+0x50>

0000000080004b58 <piperead>:

int
piperead(struct pipe *pi, uint64 addr, int n)
{
    80004b58:	715d                	addi	sp,sp,-80
    80004b5a:	e486                	sd	ra,72(sp)
    80004b5c:	e0a2                	sd	s0,64(sp)
    80004b5e:	fc26                	sd	s1,56(sp)
    80004b60:	f84a                	sd	s2,48(sp)
    80004b62:	f44e                	sd	s3,40(sp)
    80004b64:	f052                	sd	s4,32(sp)
    80004b66:	ec56                	sd	s5,24(sp)
    80004b68:	e85a                	sd	s6,16(sp)
    80004b6a:	0880                	addi	s0,sp,80
    80004b6c:	84aa                	mv	s1,a0
    80004b6e:	892e                	mv	s2,a1
    80004b70:	8ab2                	mv	s5,a2
  int i;
  struct proc *pr = myproc();
    80004b72:	ffffd097          	auipc	ra,0xffffd
    80004b76:	e38080e7          	jalr	-456(ra) # 800019aa <myproc>
    80004b7a:	8a2a                	mv	s4,a0
  char ch;

  acquire(&pi->lock);
    80004b7c:	8526                	mv	a0,s1
    80004b7e:	ffffc097          	auipc	ra,0xffffc
    80004b82:	044080e7          	jalr	68(ra) # 80000bc2 <acquire>
  while(pi->nread == pi->nwrite && pi->writeopen){  //DOC: pipe-empty
    80004b86:	2184a703          	lw	a4,536(s1)
    80004b8a:	21c4a783          	lw	a5,540(s1)
    if(pr->killed){
      release(&pi->lock);
      return -1;
    }
    sleep(&pi->nread, &pi->lock); //DOC: piperead-sleep
    80004b8e:	21848993          	addi	s3,s1,536
  while(pi->nread == pi->nwrite && pi->writeopen){  //DOC: pipe-empty
    80004b92:	02f71463          	bne	a4,a5,80004bba <piperead+0x62>
    80004b96:	2244a783          	lw	a5,548(s1)
    80004b9a:	c385                	beqz	a5,80004bba <piperead+0x62>
    if(pr->killed){
    80004b9c:	030a2783          	lw	a5,48(s4)
    80004ba0:	ebc1                	bnez	a5,80004c30 <piperead+0xd8>
    sleep(&pi->nread, &pi->lock); //DOC: piperead-sleep
    80004ba2:	85a6                	mv	a1,s1
    80004ba4:	854e                	mv	a0,s3
    80004ba6:	ffffd097          	auipc	ra,0xffffd
    80004baa:	618080e7          	jalr	1560(ra) # 800021be <sleep>
  while(pi->nread == pi->nwrite && pi->writeopen){  //DOC: pipe-empty
    80004bae:	2184a703          	lw	a4,536(s1)
    80004bb2:	21c4a783          	lw	a5,540(s1)
    80004bb6:	fef700e3          	beq	a4,a5,80004b96 <piperead+0x3e>
  }
  for(i = 0; i < n; i++){  //DOC: piperead-copy
    80004bba:	4981                	li	s3,0
    if(pi->nread == pi->nwrite)
      break;
    ch = pi->data[pi->nread++ % PIPESIZE];
    if(copyout(pr->pagetable, addr + i, &ch, 1) == -1)
    80004bbc:	5b7d                	li	s6,-1
  for(i = 0; i < n; i++){  //DOC: piperead-copy
    80004bbe:	05505363          	blez	s5,80004c04 <piperead+0xac>
    if(pi->nread == pi->nwrite)
    80004bc2:	2184a783          	lw	a5,536(s1)
    80004bc6:	21c4a703          	lw	a4,540(s1)
    80004bca:	02f70d63          	beq	a4,a5,80004c04 <piperead+0xac>
    ch = pi->data[pi->nread++ % PIPESIZE];
    80004bce:	0017871b          	addiw	a4,a5,1
    80004bd2:	20e4ac23          	sw	a4,536(s1)
    80004bd6:	1ff7f793          	andi	a5,a5,511
    80004bda:	97a6                	add	a5,a5,s1
    80004bdc:	0187c783          	lbu	a5,24(a5)
    80004be0:	faf40fa3          	sb	a5,-65(s0)
    if(copyout(pr->pagetable, addr + i, &ch, 1) == -1)
    80004be4:	4685                	li	a3,1
    80004be6:	fbf40613          	addi	a2,s0,-65
    80004bea:	85ca                	mv	a1,s2
    80004bec:	050a3503          	ld	a0,80(s4)
    80004bf0:	ffffd097          	auipc	ra,0xffffd
    80004bf4:	a4e080e7          	jalr	-1458(ra) # 8000163e <copyout>
    80004bf8:	01650663          	beq	a0,s6,80004c04 <piperead+0xac>
  for(i = 0; i < n; i++){  //DOC: piperead-copy
    80004bfc:	2985                	addiw	s3,s3,1
    80004bfe:	0905                	addi	s2,s2,1
    80004c00:	fd3a91e3          	bne	s5,s3,80004bc2 <piperead+0x6a>
      break;
  }
  wakeup(&pi->nwrite);  //DOC: piperead-wakeup
    80004c04:	21c48513          	addi	a0,s1,540
    80004c08:	ffffd097          	auipc	ra,0xffffd
    80004c0c:	736080e7          	jalr	1846(ra) # 8000233e <wakeup>
  release(&pi->lock);
    80004c10:	8526                	mv	a0,s1
    80004c12:	ffffc097          	auipc	ra,0xffffc
    80004c16:	064080e7          	jalr	100(ra) # 80000c76 <release>
  return i;
}
    80004c1a:	854e                	mv	a0,s3
    80004c1c:	60a6                	ld	ra,72(sp)
    80004c1e:	6406                	ld	s0,64(sp)
    80004c20:	74e2                	ld	s1,56(sp)
    80004c22:	7942                	ld	s2,48(sp)
    80004c24:	79a2                	ld	s3,40(sp)
    80004c26:	7a02                	ld	s4,32(sp)
    80004c28:	6ae2                	ld	s5,24(sp)
    80004c2a:	6b42                	ld	s6,16(sp)
    80004c2c:	6161                	addi	sp,sp,80
    80004c2e:	8082                	ret
      release(&pi->lock);
    80004c30:	8526                	mv	a0,s1
    80004c32:	ffffc097          	auipc	ra,0xffffc
    80004c36:	044080e7          	jalr	68(ra) # 80000c76 <release>
      return -1;
    80004c3a:	59fd                	li	s3,-1
    80004c3c:	bff9                	j	80004c1a <piperead+0xc2>

0000000080004c3e <exec>:

static int loadseg(pde_t *pgdir, uint64 addr, struct inode *ip, uint offset, uint sz);

int
exec(char *path, char **argv)
{
    80004c3e:	de010113          	addi	sp,sp,-544
    80004c42:	20113c23          	sd	ra,536(sp)
    80004c46:	20813823          	sd	s0,528(sp)
    80004c4a:	20913423          	sd	s1,520(sp)
    80004c4e:	21213023          	sd	s2,512(sp)
    80004c52:	ffce                	sd	s3,504(sp)
    80004c54:	fbd2                	sd	s4,496(sp)
    80004c56:	f7d6                	sd	s5,488(sp)
    80004c58:	f3da                	sd	s6,480(sp)
    80004c5a:	efde                	sd	s7,472(sp)
    80004c5c:	ebe2                	sd	s8,464(sp)
    80004c5e:	e7e6                	sd	s9,456(sp)
    80004c60:	e3ea                	sd	s10,448(sp)
    80004c62:	ff6e                	sd	s11,440(sp)
    80004c64:	1400                	addi	s0,sp,544
    80004c66:	892a                	mv	s2,a0
    80004c68:	dea43423          	sd	a0,-536(s0)
    80004c6c:	deb43823          	sd	a1,-528(s0)
  uint64 argc, sz = 0, sp, ustack[MAXARG+1], stackbase;
  struct elfhdr elf;
  struct inode *ip;
  struct proghdr ph;
  pagetable_t pagetable = 0, oldpagetable;
  struct proc *p = myproc();
    80004c70:	ffffd097          	auipc	ra,0xffffd
    80004c74:	d3a080e7          	jalr	-710(ra) # 800019aa <myproc>
    80004c78:	84aa                	mv	s1,a0

  begin_op();
    80004c7a:	fffff097          	auipc	ra,0xfffff
    80004c7e:	49e080e7          	jalr	1182(ra) # 80004118 <begin_op>

  if((ip = namei(path)) == 0){
    80004c82:	854a                	mv	a0,s2
    80004c84:	fffff097          	auipc	ra,0xfffff
    80004c88:	278080e7          	jalr	632(ra) # 80003efc <namei>
    80004c8c:	c93d                	beqz	a0,80004d02 <exec+0xc4>
    80004c8e:	8aaa                	mv	s5,a0
    end_op();
    return -1;
  }
  ilock(ip);
    80004c90:	fffff097          	auipc	ra,0xfffff
    80004c94:	a0a080e7          	jalr	-1526(ra) # 8000369a <ilock>

  // Check ELF header
  if(readi(ip, 0, (uint64)&elf, 0, sizeof(elf)) != sizeof(elf))
    80004c98:	04000713          	li	a4,64
    80004c9c:	4681                	li	a3,0
    80004c9e:	e4840613          	addi	a2,s0,-440
    80004ca2:	4581                	li	a1,0
    80004ca4:	8556                	mv	a0,s5
    80004ca6:	fffff097          	auipc	ra,0xfffff
    80004caa:	d52080e7          	jalr	-686(ra) # 800039f8 <readi>
    80004cae:	04000793          	li	a5,64
    80004cb2:	00f51a63          	bne	a0,a5,80004cc6 <exec+0x88>
    goto bad;
  if(elf.magic != ELF_MAGIC)
    80004cb6:	e4842703          	lw	a4,-440(s0)
    80004cba:	464c47b7          	lui	a5,0x464c4
    80004cbe:	57f78793          	addi	a5,a5,1407 # 464c457f <_entry-0x39b3ba81>
    80004cc2:	04f70663          	beq	a4,a5,80004d0e <exec+0xd0>

 bad:
  if(pagetable)
    proc_freepagetable(pagetable, sz);
  if(ip){
    iunlockput(ip);
    80004cc6:	8556                	mv	a0,s5
    80004cc8:	fffff097          	auipc	ra,0xfffff
    80004ccc:	cde080e7          	jalr	-802(ra) # 800039a6 <iunlockput>
    end_op();
    80004cd0:	fffff097          	auipc	ra,0xfffff
    80004cd4:	4c8080e7          	jalr	1224(ra) # 80004198 <end_op>
  }
  return -1;
    80004cd8:	557d                	li	a0,-1
}
    80004cda:	21813083          	ld	ra,536(sp)
    80004cde:	21013403          	ld	s0,528(sp)
    80004ce2:	20813483          	ld	s1,520(sp)
    80004ce6:	20013903          	ld	s2,512(sp)
    80004cea:	79fe                	ld	s3,504(sp)
    80004cec:	7a5e                	ld	s4,496(sp)
    80004cee:	7abe                	ld	s5,488(sp)
    80004cf0:	7b1e                	ld	s6,480(sp)
    80004cf2:	6bfe                	ld	s7,472(sp)
    80004cf4:	6c5e                	ld	s8,464(sp)
    80004cf6:	6cbe                	ld	s9,456(sp)
    80004cf8:	6d1e                	ld	s10,448(sp)
    80004cfa:	7dfa                	ld	s11,440(sp)
    80004cfc:	22010113          	addi	sp,sp,544
    80004d00:	8082                	ret
    end_op();
    80004d02:	fffff097          	auipc	ra,0xfffff
    80004d06:	496080e7          	jalr	1174(ra) # 80004198 <end_op>
    return -1;
    80004d0a:	557d                	li	a0,-1
    80004d0c:	b7f9                	j	80004cda <exec+0x9c>
  if((pagetable = proc_pagetable(p)) == 0)
    80004d0e:	8526                	mv	a0,s1
    80004d10:	ffffd097          	auipc	ra,0xffffd
    80004d14:	d5e080e7          	jalr	-674(ra) # 80001a6e <proc_pagetable>
    80004d18:	8b2a                	mv	s6,a0
    80004d1a:	d555                	beqz	a0,80004cc6 <exec+0x88>
  for(i=0, off=elf.phoff; i<elf.phnum; i++, off+=sizeof(ph)){
    80004d1c:	e6842783          	lw	a5,-408(s0)
    80004d20:	e8045703          	lhu	a4,-384(s0)
    80004d24:	c735                	beqz	a4,80004d90 <exec+0x152>
  uint64 argc, sz = 0, sp, ustack[MAXARG+1], stackbase;
    80004d26:	4481                	li	s1,0
  for(i=0, off=elf.phoff; i<elf.phnum; i++, off+=sizeof(ph)){
    80004d28:	e0043423          	sd	zero,-504(s0)
    if(ph.vaddr % PGSIZE != 0)
    80004d2c:	6a05                	lui	s4,0x1
    80004d2e:	fffa0713          	addi	a4,s4,-1 # fff <_entry-0x7ffff001>
    80004d32:	dee43023          	sd	a4,-544(s0)
  uint64 pa;

  if((va % PGSIZE) != 0)
    panic("loadseg: va must be page aligned");

  for(i = 0; i < sz; i += PGSIZE){
    80004d36:	6d85                	lui	s11,0x1
    80004d38:	7d7d                	lui	s10,0xfffff
    80004d3a:	ac1d                	j	80004f70 <exec+0x332>
    pa = walkaddr(pagetable, va + i);
    if(pa == 0)
      panic("loadseg: address should exist");
    80004d3c:	00004517          	auipc	a0,0x4
    80004d40:	96c50513          	addi	a0,a0,-1684 # 800086a8 <syscalls+0x288>
    80004d44:	ffffb097          	auipc	ra,0xffffb
    80004d48:	7e6080e7          	jalr	2022(ra) # 8000052a <panic>
    if(sz - i < PGSIZE)
      n = sz - i;
    else
      n = PGSIZE;
    if(readi(ip, 0, (uint64)pa, offset+i, n) != n)
    80004d4c:	874a                	mv	a4,s2
    80004d4e:	009c86bb          	addw	a3,s9,s1
    80004d52:	4581                	li	a1,0
    80004d54:	8556                	mv	a0,s5
    80004d56:	fffff097          	auipc	ra,0xfffff
    80004d5a:	ca2080e7          	jalr	-862(ra) # 800039f8 <readi>
    80004d5e:	2501                	sext.w	a0,a0
    80004d60:	1aa91863          	bne	s2,a0,80004f10 <exec+0x2d2>
  for(i = 0; i < sz; i += PGSIZE){
    80004d64:	009d84bb          	addw	s1,s11,s1
    80004d68:	013d09bb          	addw	s3,s10,s3
    80004d6c:	1f74f263          	bgeu	s1,s7,80004f50 <exec+0x312>
    pa = walkaddr(pagetable, va + i);
    80004d70:	02049593          	slli	a1,s1,0x20
    80004d74:	9181                	srli	a1,a1,0x20
    80004d76:	95e2                	add	a1,a1,s8
    80004d78:	855a                	mv	a0,s6
    80004d7a:	ffffc097          	auipc	ra,0xffffc
    80004d7e:	2d2080e7          	jalr	722(ra) # 8000104c <walkaddr>
    80004d82:	862a                	mv	a2,a0
    if(pa == 0)
    80004d84:	dd45                	beqz	a0,80004d3c <exec+0xfe>
      n = PGSIZE;
    80004d86:	8952                	mv	s2,s4
    if(sz - i < PGSIZE)
    80004d88:	fd49f2e3          	bgeu	s3,s4,80004d4c <exec+0x10e>
      n = sz - i;
    80004d8c:	894e                	mv	s2,s3
    80004d8e:	bf7d                	j	80004d4c <exec+0x10e>
  uint64 argc, sz = 0, sp, ustack[MAXARG+1], stackbase;
    80004d90:	4481                	li	s1,0
  iunlockput(ip);
    80004d92:	8556                	mv	a0,s5
    80004d94:	fffff097          	auipc	ra,0xfffff
    80004d98:	c12080e7          	jalr	-1006(ra) # 800039a6 <iunlockput>
  end_op();
    80004d9c:	fffff097          	auipc	ra,0xfffff
    80004da0:	3fc080e7          	jalr	1020(ra) # 80004198 <end_op>
  p = myproc();
    80004da4:	ffffd097          	auipc	ra,0xffffd
    80004da8:	c06080e7          	jalr	-1018(ra) # 800019aa <myproc>
    80004dac:	8baa                	mv	s7,a0
  uint64 oldsz = p->sz;
    80004dae:	04853d03          	ld	s10,72(a0)
  sz = PGROUNDUP(sz);
    80004db2:	6785                	lui	a5,0x1
    80004db4:	17fd                	addi	a5,a5,-1
    80004db6:	94be                	add	s1,s1,a5
    80004db8:	77fd                	lui	a5,0xfffff
    80004dba:	8fe5                	and	a5,a5,s1
    80004dbc:	def43c23          	sd	a5,-520(s0)
  if((sz1 = uvmalloc(pagetable, sz, sz + 2*PGSIZE)) == 0)
    80004dc0:	6609                	lui	a2,0x2
    80004dc2:	963e                	add	a2,a2,a5
    80004dc4:	85be                	mv	a1,a5
    80004dc6:	855a                	mv	a0,s6
    80004dc8:	ffffc097          	auipc	ra,0xffffc
    80004dcc:	626080e7          	jalr	1574(ra) # 800013ee <uvmalloc>
    80004dd0:	8c2a                	mv	s8,a0
  ip = 0;
    80004dd2:	4a81                	li	s5,0
  if((sz1 = uvmalloc(pagetable, sz, sz + 2*PGSIZE)) == 0)
    80004dd4:	12050e63          	beqz	a0,80004f10 <exec+0x2d2>
  uvmclear(pagetable, sz-2*PGSIZE);
    80004dd8:	75f9                	lui	a1,0xffffe
    80004dda:	95aa                	add	a1,a1,a0
    80004ddc:	855a                	mv	a0,s6
    80004dde:	ffffd097          	auipc	ra,0xffffd
    80004de2:	82e080e7          	jalr	-2002(ra) # 8000160c <uvmclear>
  stackbase = sp - PGSIZE;
    80004de6:	7afd                	lui	s5,0xfffff
    80004de8:	9ae2                	add	s5,s5,s8
  for(argc = 0; argv[argc]; argc++) {
    80004dea:	df043783          	ld	a5,-528(s0)
    80004dee:	6388                	ld	a0,0(a5)
    80004df0:	c925                	beqz	a0,80004e60 <exec+0x222>
    80004df2:	e8840993          	addi	s3,s0,-376
    80004df6:	f8840c93          	addi	s9,s0,-120
  sp = sz;
    80004dfa:	8962                	mv	s2,s8
  for(argc = 0; argv[argc]; argc++) {
    80004dfc:	4481                	li	s1,0
    sp -= strlen(argv[argc]) + 1;
    80004dfe:	ffffc097          	auipc	ra,0xffffc
    80004e02:	044080e7          	jalr	68(ra) # 80000e42 <strlen>
    80004e06:	0015079b          	addiw	a5,a0,1
    80004e0a:	40f90933          	sub	s2,s2,a5
    sp -= sp % 16; // riscv sp must be 16-byte aligned
    80004e0e:	ff097913          	andi	s2,s2,-16
    if(sp < stackbase)
    80004e12:	13596363          	bltu	s2,s5,80004f38 <exec+0x2fa>
    if(copyout(pagetable, sp, argv[argc], strlen(argv[argc]) + 1) < 0)
    80004e16:	df043d83          	ld	s11,-528(s0)
    80004e1a:	000dba03          	ld	s4,0(s11) # 1000 <_entry-0x7ffff000>
    80004e1e:	8552                	mv	a0,s4
    80004e20:	ffffc097          	auipc	ra,0xffffc
    80004e24:	022080e7          	jalr	34(ra) # 80000e42 <strlen>
    80004e28:	0015069b          	addiw	a3,a0,1
    80004e2c:	8652                	mv	a2,s4
    80004e2e:	85ca                	mv	a1,s2
    80004e30:	855a                	mv	a0,s6
    80004e32:	ffffd097          	auipc	ra,0xffffd
    80004e36:	80c080e7          	jalr	-2036(ra) # 8000163e <copyout>
    80004e3a:	10054363          	bltz	a0,80004f40 <exec+0x302>
    ustack[argc] = sp;
    80004e3e:	0129b023          	sd	s2,0(s3)
  for(argc = 0; argv[argc]; argc++) {
    80004e42:	0485                	addi	s1,s1,1
    80004e44:	008d8793          	addi	a5,s11,8
    80004e48:	def43823          	sd	a5,-528(s0)
    80004e4c:	008db503          	ld	a0,8(s11)
    80004e50:	c911                	beqz	a0,80004e64 <exec+0x226>
    if(argc >= MAXARG)
    80004e52:	09a1                	addi	s3,s3,8
    80004e54:	fb3c95e3          	bne	s9,s3,80004dfe <exec+0x1c0>
  sz = sz1;
    80004e58:	df843c23          	sd	s8,-520(s0)
  ip = 0;
    80004e5c:	4a81                	li	s5,0
    80004e5e:	a84d                	j	80004f10 <exec+0x2d2>
  sp = sz;
    80004e60:	8962                	mv	s2,s8
  for(argc = 0; argv[argc]; argc++) {
    80004e62:	4481                	li	s1,0
  ustack[argc] = 0;
    80004e64:	00349793          	slli	a5,s1,0x3
    80004e68:	f9040713          	addi	a4,s0,-112
    80004e6c:	97ba                	add	a5,a5,a4
    80004e6e:	ee07bc23          	sd	zero,-264(a5) # ffffffffffffeef8 <end+0xffffffff7ffddef8>
  sp -= (argc+1) * sizeof(uint64);
    80004e72:	00148693          	addi	a3,s1,1
    80004e76:	068e                	slli	a3,a3,0x3
    80004e78:	40d90933          	sub	s2,s2,a3
  sp -= sp % 16;
    80004e7c:	ff097913          	andi	s2,s2,-16
  if(sp < stackbase)
    80004e80:	01597663          	bgeu	s2,s5,80004e8c <exec+0x24e>
  sz = sz1;
    80004e84:	df843c23          	sd	s8,-520(s0)
  ip = 0;
    80004e88:	4a81                	li	s5,0
    80004e8a:	a059                	j	80004f10 <exec+0x2d2>
  if(copyout(pagetable, sp, (char *)ustack, (argc+1)*sizeof(uint64)) < 0)
    80004e8c:	e8840613          	addi	a2,s0,-376
    80004e90:	85ca                	mv	a1,s2
    80004e92:	855a                	mv	a0,s6
    80004e94:	ffffc097          	auipc	ra,0xffffc
    80004e98:	7aa080e7          	jalr	1962(ra) # 8000163e <copyout>
    80004e9c:	0a054663          	bltz	a0,80004f48 <exec+0x30a>
  p->trapframe->a1 = sp;
    80004ea0:	058bb783          	ld	a5,88(s7) # 1058 <_entry-0x7fffefa8>
    80004ea4:	0727bc23          	sd	s2,120(a5)
  for(last=s=path; *s; s++)
    80004ea8:	de843783          	ld	a5,-536(s0)
    80004eac:	0007c703          	lbu	a4,0(a5)
    80004eb0:	cf11                	beqz	a4,80004ecc <exec+0x28e>
    80004eb2:	0785                	addi	a5,a5,1
    if(*s == '/')
    80004eb4:	02f00693          	li	a3,47
    80004eb8:	a039                	j	80004ec6 <exec+0x288>
      last = s+1;
    80004eba:	def43423          	sd	a5,-536(s0)
  for(last=s=path; *s; s++)
    80004ebe:	0785                	addi	a5,a5,1
    80004ec0:	fff7c703          	lbu	a4,-1(a5)
    80004ec4:	c701                	beqz	a4,80004ecc <exec+0x28e>
    if(*s == '/')
    80004ec6:	fed71ce3          	bne	a4,a3,80004ebe <exec+0x280>
    80004eca:	bfc5                	j	80004eba <exec+0x27c>
  safestrcpy(p->name, last, sizeof(p->name));
    80004ecc:	4641                	li	a2,16
    80004ece:	de843583          	ld	a1,-536(s0)
    80004ed2:	158b8513          	addi	a0,s7,344
    80004ed6:	ffffc097          	auipc	ra,0xffffc
    80004eda:	f3a080e7          	jalr	-198(ra) # 80000e10 <safestrcpy>
  oldpagetable = p->pagetable;
    80004ede:	050bb503          	ld	a0,80(s7)
  p->pagetable = pagetable;
    80004ee2:	056bb823          	sd	s6,80(s7)
  p->sz = sz;
    80004ee6:	058bb423          	sd	s8,72(s7)
  p->trapframe->epc = elf.entry;  // initial program counter = main
    80004eea:	058bb783          	ld	a5,88(s7)
    80004eee:	e6043703          	ld	a4,-416(s0)
    80004ef2:	ef98                	sd	a4,24(a5)
  p->trapframe->sp = sp; // initial stack pointer
    80004ef4:	058bb783          	ld	a5,88(s7)
    80004ef8:	0327b823          	sd	s2,48(a5)
  proc_freepagetable(oldpagetable, oldsz);
    80004efc:	85ea                	mv	a1,s10
    80004efe:	ffffd097          	auipc	ra,0xffffd
    80004f02:	c0c080e7          	jalr	-1012(ra) # 80001b0a <proc_freepagetable>
  return argc; // this ends up in a0, the first argument to main(argc, argv)
    80004f06:	0004851b          	sext.w	a0,s1
    80004f0a:	bbc1                	j	80004cda <exec+0x9c>
    80004f0c:	de943c23          	sd	s1,-520(s0)
    proc_freepagetable(pagetable, sz);
    80004f10:	df843583          	ld	a1,-520(s0)
    80004f14:	855a                	mv	a0,s6
    80004f16:	ffffd097          	auipc	ra,0xffffd
    80004f1a:	bf4080e7          	jalr	-1036(ra) # 80001b0a <proc_freepagetable>
  if(ip){
    80004f1e:	da0a94e3          	bnez	s5,80004cc6 <exec+0x88>
  return -1;
    80004f22:	557d                	li	a0,-1
    80004f24:	bb5d                	j	80004cda <exec+0x9c>
    80004f26:	de943c23          	sd	s1,-520(s0)
    80004f2a:	b7dd                	j	80004f10 <exec+0x2d2>
    80004f2c:	de943c23          	sd	s1,-520(s0)
    80004f30:	b7c5                	j	80004f10 <exec+0x2d2>
    80004f32:	de943c23          	sd	s1,-520(s0)
    80004f36:	bfe9                	j	80004f10 <exec+0x2d2>
  sz = sz1;
    80004f38:	df843c23          	sd	s8,-520(s0)
  ip = 0;
    80004f3c:	4a81                	li	s5,0
    80004f3e:	bfc9                	j	80004f10 <exec+0x2d2>
  sz = sz1;
    80004f40:	df843c23          	sd	s8,-520(s0)
  ip = 0;
    80004f44:	4a81                	li	s5,0
    80004f46:	b7e9                	j	80004f10 <exec+0x2d2>
  sz = sz1;
    80004f48:	df843c23          	sd	s8,-520(s0)
  ip = 0;
    80004f4c:	4a81                	li	s5,0
    80004f4e:	b7c9                	j	80004f10 <exec+0x2d2>
    if((sz1 = uvmalloc(pagetable, sz, ph.vaddr + ph.memsz)) == 0)
    80004f50:	df843483          	ld	s1,-520(s0)
  for(i=0, off=elf.phoff; i<elf.phnum; i++, off+=sizeof(ph)){
    80004f54:	e0843783          	ld	a5,-504(s0)
    80004f58:	0017869b          	addiw	a3,a5,1
    80004f5c:	e0d43423          	sd	a3,-504(s0)
    80004f60:	e0043783          	ld	a5,-512(s0)
    80004f64:	0387879b          	addiw	a5,a5,56
    80004f68:	e8045703          	lhu	a4,-384(s0)
    80004f6c:	e2e6d3e3          	bge	a3,a4,80004d92 <exec+0x154>
    if(readi(ip, 0, (uint64)&ph, off, sizeof(ph)) != sizeof(ph))
    80004f70:	2781                	sext.w	a5,a5
    80004f72:	e0f43023          	sd	a5,-512(s0)
    80004f76:	03800713          	li	a4,56
    80004f7a:	86be                	mv	a3,a5
    80004f7c:	e1040613          	addi	a2,s0,-496
    80004f80:	4581                	li	a1,0
    80004f82:	8556                	mv	a0,s5
    80004f84:	fffff097          	auipc	ra,0xfffff
    80004f88:	a74080e7          	jalr	-1420(ra) # 800039f8 <readi>
    80004f8c:	03800793          	li	a5,56
    80004f90:	f6f51ee3          	bne	a0,a5,80004f0c <exec+0x2ce>
    if(ph.type != ELF_PROG_LOAD)
    80004f94:	e1042783          	lw	a5,-496(s0)
    80004f98:	4705                	li	a4,1
    80004f9a:	fae79de3          	bne	a5,a4,80004f54 <exec+0x316>
    if(ph.memsz < ph.filesz)
    80004f9e:	e3843603          	ld	a2,-456(s0)
    80004fa2:	e3043783          	ld	a5,-464(s0)
    80004fa6:	f8f660e3          	bltu	a2,a5,80004f26 <exec+0x2e8>
    if(ph.vaddr + ph.memsz < ph.vaddr)
    80004faa:	e2043783          	ld	a5,-480(s0)
    80004fae:	963e                	add	a2,a2,a5
    80004fb0:	f6f66ee3          	bltu	a2,a5,80004f2c <exec+0x2ee>
    if((sz1 = uvmalloc(pagetable, sz, ph.vaddr + ph.memsz)) == 0)
    80004fb4:	85a6                	mv	a1,s1
    80004fb6:	855a                	mv	a0,s6
    80004fb8:	ffffc097          	auipc	ra,0xffffc
    80004fbc:	436080e7          	jalr	1078(ra) # 800013ee <uvmalloc>
    80004fc0:	dea43c23          	sd	a0,-520(s0)
    80004fc4:	d53d                	beqz	a0,80004f32 <exec+0x2f4>
    if(ph.vaddr % PGSIZE != 0)
    80004fc6:	e2043c03          	ld	s8,-480(s0)
    80004fca:	de043783          	ld	a5,-544(s0)
    80004fce:	00fc77b3          	and	a5,s8,a5
    80004fd2:	ff9d                	bnez	a5,80004f10 <exec+0x2d2>
    if(loadseg(pagetable, ph.vaddr, ip, ph.off, ph.filesz) < 0)
    80004fd4:	e1842c83          	lw	s9,-488(s0)
    80004fd8:	e3042b83          	lw	s7,-464(s0)
  for(i = 0; i < sz; i += PGSIZE){
    80004fdc:	f60b8ae3          	beqz	s7,80004f50 <exec+0x312>
    80004fe0:	89de                	mv	s3,s7
    80004fe2:	4481                	li	s1,0
    80004fe4:	b371                	j	80004d70 <exec+0x132>

0000000080004fe6 <argfd>:

// Fetch the nth word-sized system call argument as a file descriptor
// and return both the descriptor and the corresponding struct file.
static int
argfd(int n, int *pfd, struct file **pf)
{
    80004fe6:	7179                	addi	sp,sp,-48
    80004fe8:	f406                	sd	ra,40(sp)
    80004fea:	f022                	sd	s0,32(sp)
    80004fec:	ec26                	sd	s1,24(sp)
    80004fee:	e84a                	sd	s2,16(sp)
    80004ff0:	1800                	addi	s0,sp,48
    80004ff2:	892e                	mv	s2,a1
    80004ff4:	84b2                	mv	s1,a2
  int fd;
  struct file *f;

  if(argint(n, &fd) < 0)
    80004ff6:	fdc40593          	addi	a1,s0,-36
    80004ffa:	ffffe097          	auipc	ra,0xffffe
    80004ffe:	a6a080e7          	jalr	-1430(ra) # 80002a64 <argint>
    80005002:	04054063          	bltz	a0,80005042 <argfd+0x5c>
    return -1;
  if(fd < 0 || fd >= NOFILE || (f=myproc()->ofile[fd]) == 0)
    80005006:	fdc42703          	lw	a4,-36(s0)
    8000500a:	47bd                	li	a5,15
    8000500c:	02e7ed63          	bltu	a5,a4,80005046 <argfd+0x60>
    80005010:	ffffd097          	auipc	ra,0xffffd
    80005014:	99a080e7          	jalr	-1638(ra) # 800019aa <myproc>
    80005018:	fdc42703          	lw	a4,-36(s0)
    8000501c:	01a70793          	addi	a5,a4,26
    80005020:	078e                	slli	a5,a5,0x3
    80005022:	953e                	add	a0,a0,a5
    80005024:	611c                	ld	a5,0(a0)
    80005026:	c395                	beqz	a5,8000504a <argfd+0x64>
    return -1;
  if(pfd)
    80005028:	00090463          	beqz	s2,80005030 <argfd+0x4a>
    *pfd = fd;
    8000502c:	00e92023          	sw	a4,0(s2)
  if(pf)
    *pf = f;
  return 0;
    80005030:	4501                	li	a0,0
  if(pf)
    80005032:	c091                	beqz	s1,80005036 <argfd+0x50>
    *pf = f;
    80005034:	e09c                	sd	a5,0(s1)
}
    80005036:	70a2                	ld	ra,40(sp)
    80005038:	7402                	ld	s0,32(sp)
    8000503a:	64e2                	ld	s1,24(sp)
    8000503c:	6942                	ld	s2,16(sp)
    8000503e:	6145                	addi	sp,sp,48
    80005040:	8082                	ret
    return -1;
    80005042:	557d                	li	a0,-1
    80005044:	bfcd                	j	80005036 <argfd+0x50>
    return -1;
    80005046:	557d                	li	a0,-1
    80005048:	b7fd                	j	80005036 <argfd+0x50>
    8000504a:	557d                	li	a0,-1
    8000504c:	b7ed                	j	80005036 <argfd+0x50>

000000008000504e <fdalloc>:

// Allocate a file descriptor for the given file.
// Takes over file reference from caller on success.
static int
fdalloc(struct file *f)
{
    8000504e:	1101                	addi	sp,sp,-32
    80005050:	ec06                	sd	ra,24(sp)
    80005052:	e822                	sd	s0,16(sp)
    80005054:	e426                	sd	s1,8(sp)
    80005056:	1000                	addi	s0,sp,32
    80005058:	84aa                	mv	s1,a0
  int fd;
  struct proc *p = myproc();
    8000505a:	ffffd097          	auipc	ra,0xffffd
    8000505e:	950080e7          	jalr	-1712(ra) # 800019aa <myproc>
    80005062:	862a                	mv	a2,a0

  for(fd = 0; fd < NOFILE; fd++){
    80005064:	0d050793          	addi	a5,a0,208
    80005068:	4501                	li	a0,0
    8000506a:	46c1                	li	a3,16
    if(p->ofile[fd] == 0){
    8000506c:	6398                	ld	a4,0(a5)
    8000506e:	cb19                	beqz	a4,80005084 <fdalloc+0x36>
  for(fd = 0; fd < NOFILE; fd++){
    80005070:	2505                	addiw	a0,a0,1
    80005072:	07a1                	addi	a5,a5,8
    80005074:	fed51ce3          	bne	a0,a3,8000506c <fdalloc+0x1e>
      p->ofile[fd] = f;
      return fd;
    }
  }
  return -1;
    80005078:	557d                	li	a0,-1
}
    8000507a:	60e2                	ld	ra,24(sp)
    8000507c:	6442                	ld	s0,16(sp)
    8000507e:	64a2                	ld	s1,8(sp)
    80005080:	6105                	addi	sp,sp,32
    80005082:	8082                	ret
      p->ofile[fd] = f;
    80005084:	01a50793          	addi	a5,a0,26
    80005088:	078e                	slli	a5,a5,0x3
    8000508a:	963e                	add	a2,a2,a5
    8000508c:	e204                	sd	s1,0(a2)
      return fd;
    8000508e:	b7f5                	j	8000507a <fdalloc+0x2c>

0000000080005090 <create>:
  return -1;
}

static struct inode*
create(char *path, short type, short major, short minor)
{
    80005090:	715d                	addi	sp,sp,-80
    80005092:	e486                	sd	ra,72(sp)
    80005094:	e0a2                	sd	s0,64(sp)
    80005096:	fc26                	sd	s1,56(sp)
    80005098:	f84a                	sd	s2,48(sp)
    8000509a:	f44e                	sd	s3,40(sp)
    8000509c:	f052                	sd	s4,32(sp)
    8000509e:	ec56                	sd	s5,24(sp)
    800050a0:	0880                	addi	s0,sp,80
    800050a2:	89ae                	mv	s3,a1
    800050a4:	8ab2                	mv	s5,a2
    800050a6:	8a36                	mv	s4,a3
  struct inode *ip, *dp;
  char name[DIRSIZ];

  if((dp = nameiparent(path, name)) == 0)
    800050a8:	fb040593          	addi	a1,s0,-80
    800050ac:	fffff097          	auipc	ra,0xfffff
    800050b0:	e6e080e7          	jalr	-402(ra) # 80003f1a <nameiparent>
    800050b4:	892a                	mv	s2,a0
    800050b6:	12050e63          	beqz	a0,800051f2 <create+0x162>
    return 0;

  ilock(dp);
    800050ba:	ffffe097          	auipc	ra,0xffffe
    800050be:	5e0080e7          	jalr	1504(ra) # 8000369a <ilock>

  if((ip = dirlookup(dp, name, 0)) != 0){
    800050c2:	4601                	li	a2,0
    800050c4:	fb040593          	addi	a1,s0,-80
    800050c8:	854a                	mv	a0,s2
    800050ca:	fffff097          	auipc	ra,0xfffff
    800050ce:	b60080e7          	jalr	-1184(ra) # 80003c2a <dirlookup>
    800050d2:	84aa                	mv	s1,a0
    800050d4:	c921                	beqz	a0,80005124 <create+0x94>
    iunlockput(dp);
    800050d6:	854a                	mv	a0,s2
    800050d8:	fffff097          	auipc	ra,0xfffff
    800050dc:	8ce080e7          	jalr	-1842(ra) # 800039a6 <iunlockput>
    ilock(ip);
    800050e0:	8526                	mv	a0,s1
    800050e2:	ffffe097          	auipc	ra,0xffffe
    800050e6:	5b8080e7          	jalr	1464(ra) # 8000369a <ilock>
    if(type == T_FILE && (ip->type == T_FILE || ip->type == T_DEVICE))
    800050ea:	2981                	sext.w	s3,s3
    800050ec:	4789                	li	a5,2
    800050ee:	02f99463          	bne	s3,a5,80005116 <create+0x86>
    800050f2:	0444d783          	lhu	a5,68(s1)
    800050f6:	37f9                	addiw	a5,a5,-2
    800050f8:	17c2                	slli	a5,a5,0x30
    800050fa:	93c1                	srli	a5,a5,0x30
    800050fc:	4705                	li	a4,1
    800050fe:	00f76c63          	bltu	a4,a5,80005116 <create+0x86>
    panic("create: dirlink");

  iunlockput(dp);

  return ip;
}
    80005102:	8526                	mv	a0,s1
    80005104:	60a6                	ld	ra,72(sp)
    80005106:	6406                	ld	s0,64(sp)
    80005108:	74e2                	ld	s1,56(sp)
    8000510a:	7942                	ld	s2,48(sp)
    8000510c:	79a2                	ld	s3,40(sp)
    8000510e:	7a02                	ld	s4,32(sp)
    80005110:	6ae2                	ld	s5,24(sp)
    80005112:	6161                	addi	sp,sp,80
    80005114:	8082                	ret
    iunlockput(ip);
    80005116:	8526                	mv	a0,s1
    80005118:	fffff097          	auipc	ra,0xfffff
    8000511c:	88e080e7          	jalr	-1906(ra) # 800039a6 <iunlockput>
    return 0;
    80005120:	4481                	li	s1,0
    80005122:	b7c5                	j	80005102 <create+0x72>
  if((ip = ialloc(dp->dev, type)) == 0)
    80005124:	85ce                	mv	a1,s3
    80005126:	00092503          	lw	a0,0(s2)
    8000512a:	ffffe097          	auipc	ra,0xffffe
    8000512e:	3d8080e7          	jalr	984(ra) # 80003502 <ialloc>
    80005132:	84aa                	mv	s1,a0
    80005134:	c521                	beqz	a0,8000517c <create+0xec>
  ilock(ip);
    80005136:	ffffe097          	auipc	ra,0xffffe
    8000513a:	564080e7          	jalr	1380(ra) # 8000369a <ilock>
  ip->major = major;
    8000513e:	05549323          	sh	s5,70(s1)
  ip->minor = minor;
    80005142:	05449423          	sh	s4,72(s1)
  ip->nlink = 1;
    80005146:	4a05                	li	s4,1
    80005148:	05449523          	sh	s4,74(s1)
  iupdate(ip);
    8000514c:	8526                	mv	a0,s1
    8000514e:	ffffe097          	auipc	ra,0xffffe
    80005152:	482080e7          	jalr	1154(ra) # 800035d0 <iupdate>
  if(type == T_DIR){  // Create . and .. entries.
    80005156:	2981                	sext.w	s3,s3
    80005158:	03498a63          	beq	s3,s4,8000518c <create+0xfc>
  if(dirlink(dp, name, ip->inum) < 0)
    8000515c:	40d0                	lw	a2,4(s1)
    8000515e:	fb040593          	addi	a1,s0,-80
    80005162:	854a                	mv	a0,s2
    80005164:	fffff097          	auipc	ra,0xfffff
    80005168:	cd6080e7          	jalr	-810(ra) # 80003e3a <dirlink>
    8000516c:	06054b63          	bltz	a0,800051e2 <create+0x152>
  iunlockput(dp);
    80005170:	854a                	mv	a0,s2
    80005172:	fffff097          	auipc	ra,0xfffff
    80005176:	834080e7          	jalr	-1996(ra) # 800039a6 <iunlockput>
  return ip;
    8000517a:	b761                	j	80005102 <create+0x72>
    panic("create: ialloc");
    8000517c:	00003517          	auipc	a0,0x3
    80005180:	54c50513          	addi	a0,a0,1356 # 800086c8 <syscalls+0x2a8>
    80005184:	ffffb097          	auipc	ra,0xffffb
    80005188:	3a6080e7          	jalr	934(ra) # 8000052a <panic>
    dp->nlink++;  // for ".."
    8000518c:	04a95783          	lhu	a5,74(s2)
    80005190:	2785                	addiw	a5,a5,1
    80005192:	04f91523          	sh	a5,74(s2)
    iupdate(dp);
    80005196:	854a                	mv	a0,s2
    80005198:	ffffe097          	auipc	ra,0xffffe
    8000519c:	438080e7          	jalr	1080(ra) # 800035d0 <iupdate>
    if(dirlink(ip, ".", ip->inum) < 0 || dirlink(ip, "..", dp->inum) < 0)
    800051a0:	40d0                	lw	a2,4(s1)
    800051a2:	00003597          	auipc	a1,0x3
    800051a6:	53658593          	addi	a1,a1,1334 # 800086d8 <syscalls+0x2b8>
    800051aa:	8526                	mv	a0,s1
    800051ac:	fffff097          	auipc	ra,0xfffff
    800051b0:	c8e080e7          	jalr	-882(ra) # 80003e3a <dirlink>
    800051b4:	00054f63          	bltz	a0,800051d2 <create+0x142>
    800051b8:	00492603          	lw	a2,4(s2)
    800051bc:	00003597          	auipc	a1,0x3
    800051c0:	52458593          	addi	a1,a1,1316 # 800086e0 <syscalls+0x2c0>
    800051c4:	8526                	mv	a0,s1
    800051c6:	fffff097          	auipc	ra,0xfffff
    800051ca:	c74080e7          	jalr	-908(ra) # 80003e3a <dirlink>
    800051ce:	f80557e3          	bgez	a0,8000515c <create+0xcc>
      panic("create dots");
    800051d2:	00003517          	auipc	a0,0x3
    800051d6:	51650513          	addi	a0,a0,1302 # 800086e8 <syscalls+0x2c8>
    800051da:	ffffb097          	auipc	ra,0xffffb
    800051de:	350080e7          	jalr	848(ra) # 8000052a <panic>
    panic("create: dirlink");
    800051e2:	00003517          	auipc	a0,0x3
    800051e6:	51650513          	addi	a0,a0,1302 # 800086f8 <syscalls+0x2d8>
    800051ea:	ffffb097          	auipc	ra,0xffffb
    800051ee:	340080e7          	jalr	832(ra) # 8000052a <panic>
    return 0;
    800051f2:	84aa                	mv	s1,a0
    800051f4:	b739                	j	80005102 <create+0x72>

00000000800051f6 <sys_dup>:
{
    800051f6:	7179                	addi	sp,sp,-48
    800051f8:	f406                	sd	ra,40(sp)
    800051fa:	f022                	sd	s0,32(sp)
    800051fc:	ec26                	sd	s1,24(sp)
    800051fe:	1800                	addi	s0,sp,48
  if(argfd(0, 0, &f) < 0)
    80005200:	fd840613          	addi	a2,s0,-40
    80005204:	4581                	li	a1,0
    80005206:	4501                	li	a0,0
    80005208:	00000097          	auipc	ra,0x0
    8000520c:	dde080e7          	jalr	-546(ra) # 80004fe6 <argfd>
    return -1;
    80005210:	57fd                	li	a5,-1
  if(argfd(0, 0, &f) < 0)
    80005212:	02054363          	bltz	a0,80005238 <sys_dup+0x42>
  if((fd=fdalloc(f)) < 0)
    80005216:	fd843503          	ld	a0,-40(s0)
    8000521a:	00000097          	auipc	ra,0x0
    8000521e:	e34080e7          	jalr	-460(ra) # 8000504e <fdalloc>
    80005222:	84aa                	mv	s1,a0
    return -1;
    80005224:	57fd                	li	a5,-1
  if((fd=fdalloc(f)) < 0)
    80005226:	00054963          	bltz	a0,80005238 <sys_dup+0x42>
  filedup(f);
    8000522a:	fd843503          	ld	a0,-40(s0)
    8000522e:	fffff097          	auipc	ra,0xfffff
    80005232:	36c080e7          	jalr	876(ra) # 8000459a <filedup>
  return fd;
    80005236:	87a6                	mv	a5,s1
}
    80005238:	853e                	mv	a0,a5
    8000523a:	70a2                	ld	ra,40(sp)
    8000523c:	7402                	ld	s0,32(sp)
    8000523e:	64e2                	ld	s1,24(sp)
    80005240:	6145                	addi	sp,sp,48
    80005242:	8082                	ret

0000000080005244 <sys_read>:
{
    80005244:	7179                	addi	sp,sp,-48
    80005246:	f406                	sd	ra,40(sp)
    80005248:	f022                	sd	s0,32(sp)
    8000524a:	1800                	addi	s0,sp,48
  if(argfd(0, 0, &f) < 0 || argint(2, &n) < 0 || argaddr(1, &p) < 0)
    8000524c:	fe840613          	addi	a2,s0,-24
    80005250:	4581                	li	a1,0
    80005252:	4501                	li	a0,0
    80005254:	00000097          	auipc	ra,0x0
    80005258:	d92080e7          	jalr	-622(ra) # 80004fe6 <argfd>
    return -1;
    8000525c:	57fd                	li	a5,-1
  if(argfd(0, 0, &f) < 0 || argint(2, &n) < 0 || argaddr(1, &p) < 0)
    8000525e:	04054163          	bltz	a0,800052a0 <sys_read+0x5c>
    80005262:	fe440593          	addi	a1,s0,-28
    80005266:	4509                	li	a0,2
    80005268:	ffffd097          	auipc	ra,0xffffd
    8000526c:	7fc080e7          	jalr	2044(ra) # 80002a64 <argint>
    return -1;
    80005270:	57fd                	li	a5,-1
  if(argfd(0, 0, &f) < 0 || argint(2, &n) < 0 || argaddr(1, &p) < 0)
    80005272:	02054763          	bltz	a0,800052a0 <sys_read+0x5c>
    80005276:	fd840593          	addi	a1,s0,-40
    8000527a:	4505                	li	a0,1
    8000527c:	ffffe097          	auipc	ra,0xffffe
    80005280:	80a080e7          	jalr	-2038(ra) # 80002a86 <argaddr>
    return -1;
    80005284:	57fd                	li	a5,-1
  if(argfd(0, 0, &f) < 0 || argint(2, &n) < 0 || argaddr(1, &p) < 0)
    80005286:	00054d63          	bltz	a0,800052a0 <sys_read+0x5c>
  return fileread(f, p, n);
    8000528a:	fe442603          	lw	a2,-28(s0)
    8000528e:	fd843583          	ld	a1,-40(s0)
    80005292:	fe843503          	ld	a0,-24(s0)
    80005296:	fffff097          	auipc	ra,0xfffff
    8000529a:	490080e7          	jalr	1168(ra) # 80004726 <fileread>
    8000529e:	87aa                	mv	a5,a0
}
    800052a0:	853e                	mv	a0,a5
    800052a2:	70a2                	ld	ra,40(sp)
    800052a4:	7402                	ld	s0,32(sp)
    800052a6:	6145                	addi	sp,sp,48
    800052a8:	8082                	ret

00000000800052aa <sys_write>:
{
    800052aa:	7179                	addi	sp,sp,-48
    800052ac:	f406                	sd	ra,40(sp)
    800052ae:	f022                	sd	s0,32(sp)
    800052b0:	1800                	addi	s0,sp,48
  if(argfd(0, 0, &f) < 0 || argint(2, &n) < 0 || argaddr(1, &p) < 0)
    800052b2:	fe840613          	addi	a2,s0,-24
    800052b6:	4581                	li	a1,0
    800052b8:	4501                	li	a0,0
    800052ba:	00000097          	auipc	ra,0x0
    800052be:	d2c080e7          	jalr	-724(ra) # 80004fe6 <argfd>
    return -1;
    800052c2:	57fd                	li	a5,-1
  if(argfd(0, 0, &f) < 0 || argint(2, &n) < 0 || argaddr(1, &p) < 0)
    800052c4:	04054163          	bltz	a0,80005306 <sys_write+0x5c>
    800052c8:	fe440593          	addi	a1,s0,-28
    800052cc:	4509                	li	a0,2
    800052ce:	ffffd097          	auipc	ra,0xffffd
    800052d2:	796080e7          	jalr	1942(ra) # 80002a64 <argint>
    return -1;
    800052d6:	57fd                	li	a5,-1
  if(argfd(0, 0, &f) < 0 || argint(2, &n) < 0 || argaddr(1, &p) < 0)
    800052d8:	02054763          	bltz	a0,80005306 <sys_write+0x5c>
    800052dc:	fd840593          	addi	a1,s0,-40
    800052e0:	4505                	li	a0,1
    800052e2:	ffffd097          	auipc	ra,0xffffd
    800052e6:	7a4080e7          	jalr	1956(ra) # 80002a86 <argaddr>
    return -1;
    800052ea:	57fd                	li	a5,-1
  if(argfd(0, 0, &f) < 0 || argint(2, &n) < 0 || argaddr(1, &p) < 0)
    800052ec:	00054d63          	bltz	a0,80005306 <sys_write+0x5c>
  return filewrite(f, p, n);
    800052f0:	fe442603          	lw	a2,-28(s0)
    800052f4:	fd843583          	ld	a1,-40(s0)
    800052f8:	fe843503          	ld	a0,-24(s0)
    800052fc:	fffff097          	auipc	ra,0xfffff
    80005300:	4ec080e7          	jalr	1260(ra) # 800047e8 <filewrite>
    80005304:	87aa                	mv	a5,a0
}
    80005306:	853e                	mv	a0,a5
    80005308:	70a2                	ld	ra,40(sp)
    8000530a:	7402                	ld	s0,32(sp)
    8000530c:	6145                	addi	sp,sp,48
    8000530e:	8082                	ret

0000000080005310 <sys_close>:
{
    80005310:	1101                	addi	sp,sp,-32
    80005312:	ec06                	sd	ra,24(sp)
    80005314:	e822                	sd	s0,16(sp)
    80005316:	1000                	addi	s0,sp,32
  if(argfd(0, &fd, &f) < 0)
    80005318:	fe040613          	addi	a2,s0,-32
    8000531c:	fec40593          	addi	a1,s0,-20
    80005320:	4501                	li	a0,0
    80005322:	00000097          	auipc	ra,0x0
    80005326:	cc4080e7          	jalr	-828(ra) # 80004fe6 <argfd>
    return -1;
    8000532a:	57fd                	li	a5,-1
  if(argfd(0, &fd, &f) < 0)
    8000532c:	02054463          	bltz	a0,80005354 <sys_close+0x44>
  myproc()->ofile[fd] = 0;
    80005330:	ffffc097          	auipc	ra,0xffffc
    80005334:	67a080e7          	jalr	1658(ra) # 800019aa <myproc>
    80005338:	fec42783          	lw	a5,-20(s0)
    8000533c:	07e9                	addi	a5,a5,26
    8000533e:	078e                	slli	a5,a5,0x3
    80005340:	97aa                	add	a5,a5,a0
    80005342:	0007b023          	sd	zero,0(a5)
  fileclose(f);
    80005346:	fe043503          	ld	a0,-32(s0)
    8000534a:	fffff097          	auipc	ra,0xfffff
    8000534e:	2a2080e7          	jalr	674(ra) # 800045ec <fileclose>
  return 0;
    80005352:	4781                	li	a5,0
}
    80005354:	853e                	mv	a0,a5
    80005356:	60e2                	ld	ra,24(sp)
    80005358:	6442                	ld	s0,16(sp)
    8000535a:	6105                	addi	sp,sp,32
    8000535c:	8082                	ret

000000008000535e <sys_fstat>:
{
    8000535e:	1101                	addi	sp,sp,-32
    80005360:	ec06                	sd	ra,24(sp)
    80005362:	e822                	sd	s0,16(sp)
    80005364:	1000                	addi	s0,sp,32
  if(argfd(0, 0, &f) < 0 || argaddr(1, &st) < 0)
    80005366:	fe840613          	addi	a2,s0,-24
    8000536a:	4581                	li	a1,0
    8000536c:	4501                	li	a0,0
    8000536e:	00000097          	auipc	ra,0x0
    80005372:	c78080e7          	jalr	-904(ra) # 80004fe6 <argfd>
    return -1;
    80005376:	57fd                	li	a5,-1
  if(argfd(0, 0, &f) < 0 || argaddr(1, &st) < 0)
    80005378:	02054563          	bltz	a0,800053a2 <sys_fstat+0x44>
    8000537c:	fe040593          	addi	a1,s0,-32
    80005380:	4505                	li	a0,1
    80005382:	ffffd097          	auipc	ra,0xffffd
    80005386:	704080e7          	jalr	1796(ra) # 80002a86 <argaddr>
    return -1;
    8000538a:	57fd                	li	a5,-1
  if(argfd(0, 0, &f) < 0 || argaddr(1, &st) < 0)
    8000538c:	00054b63          	bltz	a0,800053a2 <sys_fstat+0x44>
  return filestat(f, st);
    80005390:	fe043583          	ld	a1,-32(s0)
    80005394:	fe843503          	ld	a0,-24(s0)
    80005398:	fffff097          	auipc	ra,0xfffff
    8000539c:	31c080e7          	jalr	796(ra) # 800046b4 <filestat>
    800053a0:	87aa                	mv	a5,a0
}
    800053a2:	853e                	mv	a0,a5
    800053a4:	60e2                	ld	ra,24(sp)
    800053a6:	6442                	ld	s0,16(sp)
    800053a8:	6105                	addi	sp,sp,32
    800053aa:	8082                	ret

00000000800053ac <sys_link>:
{
    800053ac:	7169                	addi	sp,sp,-304
    800053ae:	f606                	sd	ra,296(sp)
    800053b0:	f222                	sd	s0,288(sp)
    800053b2:	ee26                	sd	s1,280(sp)
    800053b4:	ea4a                	sd	s2,272(sp)
    800053b6:	1a00                	addi	s0,sp,304
  if(argstr(0, old, MAXPATH) < 0 || argstr(1, new, MAXPATH) < 0)
    800053b8:	08000613          	li	a2,128
    800053bc:	ed040593          	addi	a1,s0,-304
    800053c0:	4501                	li	a0,0
    800053c2:	ffffd097          	auipc	ra,0xffffd
    800053c6:	6e6080e7          	jalr	1766(ra) # 80002aa8 <argstr>
    return -1;
    800053ca:	57fd                	li	a5,-1
  if(argstr(0, old, MAXPATH) < 0 || argstr(1, new, MAXPATH) < 0)
    800053cc:	10054e63          	bltz	a0,800054e8 <sys_link+0x13c>
    800053d0:	08000613          	li	a2,128
    800053d4:	f5040593          	addi	a1,s0,-176
    800053d8:	4505                	li	a0,1
    800053da:	ffffd097          	auipc	ra,0xffffd
    800053de:	6ce080e7          	jalr	1742(ra) # 80002aa8 <argstr>
    return -1;
    800053e2:	57fd                	li	a5,-1
  if(argstr(0, old, MAXPATH) < 0 || argstr(1, new, MAXPATH) < 0)
    800053e4:	10054263          	bltz	a0,800054e8 <sys_link+0x13c>
  begin_op();
    800053e8:	fffff097          	auipc	ra,0xfffff
    800053ec:	d30080e7          	jalr	-720(ra) # 80004118 <begin_op>
  if((ip = namei(old)) == 0){
    800053f0:	ed040513          	addi	a0,s0,-304
    800053f4:	fffff097          	auipc	ra,0xfffff
    800053f8:	b08080e7          	jalr	-1272(ra) # 80003efc <namei>
    800053fc:	84aa                	mv	s1,a0
    800053fe:	c551                	beqz	a0,8000548a <sys_link+0xde>
  ilock(ip);
    80005400:	ffffe097          	auipc	ra,0xffffe
    80005404:	29a080e7          	jalr	666(ra) # 8000369a <ilock>
  if(ip->type == T_DIR){
    80005408:	04449703          	lh	a4,68(s1)
    8000540c:	4785                	li	a5,1
    8000540e:	08f70463          	beq	a4,a5,80005496 <sys_link+0xea>
  ip->nlink++;
    80005412:	04a4d783          	lhu	a5,74(s1)
    80005416:	2785                	addiw	a5,a5,1
    80005418:	04f49523          	sh	a5,74(s1)
  iupdate(ip);
    8000541c:	8526                	mv	a0,s1
    8000541e:	ffffe097          	auipc	ra,0xffffe
    80005422:	1b2080e7          	jalr	434(ra) # 800035d0 <iupdate>
  iunlock(ip);
    80005426:	8526                	mv	a0,s1
    80005428:	ffffe097          	auipc	ra,0xffffe
    8000542c:	334080e7          	jalr	820(ra) # 8000375c <iunlock>
  if((dp = nameiparent(new, name)) == 0)
    80005430:	fd040593          	addi	a1,s0,-48
    80005434:	f5040513          	addi	a0,s0,-176
    80005438:	fffff097          	auipc	ra,0xfffff
    8000543c:	ae2080e7          	jalr	-1310(ra) # 80003f1a <nameiparent>
    80005440:	892a                	mv	s2,a0
    80005442:	c935                	beqz	a0,800054b6 <sys_link+0x10a>
  ilock(dp);
    80005444:	ffffe097          	auipc	ra,0xffffe
    80005448:	256080e7          	jalr	598(ra) # 8000369a <ilock>
  if(dp->dev != ip->dev || dirlink(dp, name, ip->inum) < 0){
    8000544c:	00092703          	lw	a4,0(s2)
    80005450:	409c                	lw	a5,0(s1)
    80005452:	04f71d63          	bne	a4,a5,800054ac <sys_link+0x100>
    80005456:	40d0                	lw	a2,4(s1)
    80005458:	fd040593          	addi	a1,s0,-48
    8000545c:	854a                	mv	a0,s2
    8000545e:	fffff097          	auipc	ra,0xfffff
    80005462:	9dc080e7          	jalr	-1572(ra) # 80003e3a <dirlink>
    80005466:	04054363          	bltz	a0,800054ac <sys_link+0x100>
  iunlockput(dp);
    8000546a:	854a                	mv	a0,s2
    8000546c:	ffffe097          	auipc	ra,0xffffe
    80005470:	53a080e7          	jalr	1338(ra) # 800039a6 <iunlockput>
  iput(ip);
    80005474:	8526                	mv	a0,s1
    80005476:	ffffe097          	auipc	ra,0xffffe
    8000547a:	488080e7          	jalr	1160(ra) # 800038fe <iput>
  end_op();
    8000547e:	fffff097          	auipc	ra,0xfffff
    80005482:	d1a080e7          	jalr	-742(ra) # 80004198 <end_op>
  return 0;
    80005486:	4781                	li	a5,0
    80005488:	a085                	j	800054e8 <sys_link+0x13c>
    end_op();
    8000548a:	fffff097          	auipc	ra,0xfffff
    8000548e:	d0e080e7          	jalr	-754(ra) # 80004198 <end_op>
    return -1;
    80005492:	57fd                	li	a5,-1
    80005494:	a891                	j	800054e8 <sys_link+0x13c>
    iunlockput(ip);
    80005496:	8526                	mv	a0,s1
    80005498:	ffffe097          	auipc	ra,0xffffe
    8000549c:	50e080e7          	jalr	1294(ra) # 800039a6 <iunlockput>
    end_op();
    800054a0:	fffff097          	auipc	ra,0xfffff
    800054a4:	cf8080e7          	jalr	-776(ra) # 80004198 <end_op>
    return -1;
    800054a8:	57fd                	li	a5,-1
    800054aa:	a83d                	j	800054e8 <sys_link+0x13c>
    iunlockput(dp);
    800054ac:	854a                	mv	a0,s2
    800054ae:	ffffe097          	auipc	ra,0xffffe
    800054b2:	4f8080e7          	jalr	1272(ra) # 800039a6 <iunlockput>
  ilock(ip);
    800054b6:	8526                	mv	a0,s1
    800054b8:	ffffe097          	auipc	ra,0xffffe
    800054bc:	1e2080e7          	jalr	482(ra) # 8000369a <ilock>
  ip->nlink--;
    800054c0:	04a4d783          	lhu	a5,74(s1)
    800054c4:	37fd                	addiw	a5,a5,-1
    800054c6:	04f49523          	sh	a5,74(s1)
  iupdate(ip);
    800054ca:	8526                	mv	a0,s1
    800054cc:	ffffe097          	auipc	ra,0xffffe
    800054d0:	104080e7          	jalr	260(ra) # 800035d0 <iupdate>
  iunlockput(ip);
    800054d4:	8526                	mv	a0,s1
    800054d6:	ffffe097          	auipc	ra,0xffffe
    800054da:	4d0080e7          	jalr	1232(ra) # 800039a6 <iunlockput>
  end_op();
    800054de:	fffff097          	auipc	ra,0xfffff
    800054e2:	cba080e7          	jalr	-838(ra) # 80004198 <end_op>
  return -1;
    800054e6:	57fd                	li	a5,-1
}
    800054e8:	853e                	mv	a0,a5
    800054ea:	70b2                	ld	ra,296(sp)
    800054ec:	7412                	ld	s0,288(sp)
    800054ee:	64f2                	ld	s1,280(sp)
    800054f0:	6952                	ld	s2,272(sp)
    800054f2:	6155                	addi	sp,sp,304
    800054f4:	8082                	ret

00000000800054f6 <sys_unlink>:
{
    800054f6:	7151                	addi	sp,sp,-240
    800054f8:	f586                	sd	ra,232(sp)
    800054fa:	f1a2                	sd	s0,224(sp)
    800054fc:	eda6                	sd	s1,216(sp)
    800054fe:	e9ca                	sd	s2,208(sp)
    80005500:	e5ce                	sd	s3,200(sp)
    80005502:	1980                	addi	s0,sp,240
  if(argstr(0, path, MAXPATH) < 0)
    80005504:	08000613          	li	a2,128
    80005508:	f3040593          	addi	a1,s0,-208
    8000550c:	4501                	li	a0,0
    8000550e:	ffffd097          	auipc	ra,0xffffd
    80005512:	59a080e7          	jalr	1434(ra) # 80002aa8 <argstr>
    80005516:	18054163          	bltz	a0,80005698 <sys_unlink+0x1a2>
  begin_op();
    8000551a:	fffff097          	auipc	ra,0xfffff
    8000551e:	bfe080e7          	jalr	-1026(ra) # 80004118 <begin_op>
  if((dp = nameiparent(path, name)) == 0){
    80005522:	fb040593          	addi	a1,s0,-80
    80005526:	f3040513          	addi	a0,s0,-208
    8000552a:	fffff097          	auipc	ra,0xfffff
    8000552e:	9f0080e7          	jalr	-1552(ra) # 80003f1a <nameiparent>
    80005532:	84aa                	mv	s1,a0
    80005534:	c979                	beqz	a0,8000560a <sys_unlink+0x114>
  ilock(dp);
    80005536:	ffffe097          	auipc	ra,0xffffe
    8000553a:	164080e7          	jalr	356(ra) # 8000369a <ilock>
  if(namecmp(name, ".") == 0 || namecmp(name, "..") == 0)
    8000553e:	00003597          	auipc	a1,0x3
    80005542:	19a58593          	addi	a1,a1,410 # 800086d8 <syscalls+0x2b8>
    80005546:	fb040513          	addi	a0,s0,-80
    8000554a:	ffffe097          	auipc	ra,0xffffe
    8000554e:	6c6080e7          	jalr	1734(ra) # 80003c10 <namecmp>
    80005552:	14050a63          	beqz	a0,800056a6 <sys_unlink+0x1b0>
    80005556:	00003597          	auipc	a1,0x3
    8000555a:	18a58593          	addi	a1,a1,394 # 800086e0 <syscalls+0x2c0>
    8000555e:	fb040513          	addi	a0,s0,-80
    80005562:	ffffe097          	auipc	ra,0xffffe
    80005566:	6ae080e7          	jalr	1710(ra) # 80003c10 <namecmp>
    8000556a:	12050e63          	beqz	a0,800056a6 <sys_unlink+0x1b0>
  if((ip = dirlookup(dp, name, &off)) == 0)
    8000556e:	f2c40613          	addi	a2,s0,-212
    80005572:	fb040593          	addi	a1,s0,-80
    80005576:	8526                	mv	a0,s1
    80005578:	ffffe097          	auipc	ra,0xffffe
    8000557c:	6b2080e7          	jalr	1714(ra) # 80003c2a <dirlookup>
    80005580:	892a                	mv	s2,a0
    80005582:	12050263          	beqz	a0,800056a6 <sys_unlink+0x1b0>
  ilock(ip);
    80005586:	ffffe097          	auipc	ra,0xffffe
    8000558a:	114080e7          	jalr	276(ra) # 8000369a <ilock>
  if(ip->nlink < 1)
    8000558e:	04a91783          	lh	a5,74(s2)
    80005592:	08f05263          	blez	a5,80005616 <sys_unlink+0x120>
  if(ip->type == T_DIR && !isdirempty(ip)){
    80005596:	04491703          	lh	a4,68(s2)
    8000559a:	4785                	li	a5,1
    8000559c:	08f70563          	beq	a4,a5,80005626 <sys_unlink+0x130>
  memset(&de, 0, sizeof(de));
    800055a0:	4641                	li	a2,16
    800055a2:	4581                	li	a1,0
    800055a4:	fc040513          	addi	a0,s0,-64
    800055a8:	ffffb097          	auipc	ra,0xffffb
    800055ac:	716080e7          	jalr	1814(ra) # 80000cbe <memset>
  if(writei(dp, 0, (uint64)&de, off, sizeof(de)) != sizeof(de))
    800055b0:	4741                	li	a4,16
    800055b2:	f2c42683          	lw	a3,-212(s0)
    800055b6:	fc040613          	addi	a2,s0,-64
    800055ba:	4581                	li	a1,0
    800055bc:	8526                	mv	a0,s1
    800055be:	ffffe097          	auipc	ra,0xffffe
    800055c2:	532080e7          	jalr	1330(ra) # 80003af0 <writei>
    800055c6:	47c1                	li	a5,16
    800055c8:	0af51563          	bne	a0,a5,80005672 <sys_unlink+0x17c>
  if(ip->type == T_DIR){
    800055cc:	04491703          	lh	a4,68(s2)
    800055d0:	4785                	li	a5,1
    800055d2:	0af70863          	beq	a4,a5,80005682 <sys_unlink+0x18c>
  iunlockput(dp);
    800055d6:	8526                	mv	a0,s1
    800055d8:	ffffe097          	auipc	ra,0xffffe
    800055dc:	3ce080e7          	jalr	974(ra) # 800039a6 <iunlockput>
  ip->nlink--;
    800055e0:	04a95783          	lhu	a5,74(s2)
    800055e4:	37fd                	addiw	a5,a5,-1
    800055e6:	04f91523          	sh	a5,74(s2)
  iupdate(ip);
    800055ea:	854a                	mv	a0,s2
    800055ec:	ffffe097          	auipc	ra,0xffffe
    800055f0:	fe4080e7          	jalr	-28(ra) # 800035d0 <iupdate>
  iunlockput(ip);
    800055f4:	854a                	mv	a0,s2
    800055f6:	ffffe097          	auipc	ra,0xffffe
    800055fa:	3b0080e7          	jalr	944(ra) # 800039a6 <iunlockput>
  end_op();
    800055fe:	fffff097          	auipc	ra,0xfffff
    80005602:	b9a080e7          	jalr	-1126(ra) # 80004198 <end_op>
  return 0;
    80005606:	4501                	li	a0,0
    80005608:	a84d                	j	800056ba <sys_unlink+0x1c4>
    end_op();
    8000560a:	fffff097          	auipc	ra,0xfffff
    8000560e:	b8e080e7          	jalr	-1138(ra) # 80004198 <end_op>
    return -1;
    80005612:	557d                	li	a0,-1
    80005614:	a05d                	j	800056ba <sys_unlink+0x1c4>
    panic("unlink: nlink < 1");
    80005616:	00003517          	auipc	a0,0x3
    8000561a:	0f250513          	addi	a0,a0,242 # 80008708 <syscalls+0x2e8>
    8000561e:	ffffb097          	auipc	ra,0xffffb
    80005622:	f0c080e7          	jalr	-244(ra) # 8000052a <panic>
  for(off=2*sizeof(de); off<dp->size; off+=sizeof(de)){
    80005626:	04c92703          	lw	a4,76(s2)
    8000562a:	02000793          	li	a5,32
    8000562e:	f6e7f9e3          	bgeu	a5,a4,800055a0 <sys_unlink+0xaa>
    80005632:	02000993          	li	s3,32
    if(readi(dp, 0, (uint64)&de, off, sizeof(de)) != sizeof(de))
    80005636:	4741                	li	a4,16
    80005638:	86ce                	mv	a3,s3
    8000563a:	f1840613          	addi	a2,s0,-232
    8000563e:	4581                	li	a1,0
    80005640:	854a                	mv	a0,s2
    80005642:	ffffe097          	auipc	ra,0xffffe
    80005646:	3b6080e7          	jalr	950(ra) # 800039f8 <readi>
    8000564a:	47c1                	li	a5,16
    8000564c:	00f51b63          	bne	a0,a5,80005662 <sys_unlink+0x16c>
    if(de.inum != 0)
    80005650:	f1845783          	lhu	a5,-232(s0)
    80005654:	e7a1                	bnez	a5,8000569c <sys_unlink+0x1a6>
  for(off=2*sizeof(de); off<dp->size; off+=sizeof(de)){
    80005656:	29c1                	addiw	s3,s3,16
    80005658:	04c92783          	lw	a5,76(s2)
    8000565c:	fcf9ede3          	bltu	s3,a5,80005636 <sys_unlink+0x140>
    80005660:	b781                	j	800055a0 <sys_unlink+0xaa>
      panic("isdirempty: readi");
    80005662:	00003517          	auipc	a0,0x3
    80005666:	0be50513          	addi	a0,a0,190 # 80008720 <syscalls+0x300>
    8000566a:	ffffb097          	auipc	ra,0xffffb
    8000566e:	ec0080e7          	jalr	-320(ra) # 8000052a <panic>
    panic("unlink: writei");
    80005672:	00003517          	auipc	a0,0x3
    80005676:	0c650513          	addi	a0,a0,198 # 80008738 <syscalls+0x318>
    8000567a:	ffffb097          	auipc	ra,0xffffb
    8000567e:	eb0080e7          	jalr	-336(ra) # 8000052a <panic>
    dp->nlink--;
    80005682:	04a4d783          	lhu	a5,74(s1)
    80005686:	37fd                	addiw	a5,a5,-1
    80005688:	04f49523          	sh	a5,74(s1)
    iupdate(dp);
    8000568c:	8526                	mv	a0,s1
    8000568e:	ffffe097          	auipc	ra,0xffffe
    80005692:	f42080e7          	jalr	-190(ra) # 800035d0 <iupdate>
    80005696:	b781                	j	800055d6 <sys_unlink+0xe0>
    return -1;
    80005698:	557d                	li	a0,-1
    8000569a:	a005                	j	800056ba <sys_unlink+0x1c4>
    iunlockput(ip);
    8000569c:	854a                	mv	a0,s2
    8000569e:	ffffe097          	auipc	ra,0xffffe
    800056a2:	308080e7          	jalr	776(ra) # 800039a6 <iunlockput>
  iunlockput(dp);
    800056a6:	8526                	mv	a0,s1
    800056a8:	ffffe097          	auipc	ra,0xffffe
    800056ac:	2fe080e7          	jalr	766(ra) # 800039a6 <iunlockput>
  end_op();
    800056b0:	fffff097          	auipc	ra,0xfffff
    800056b4:	ae8080e7          	jalr	-1304(ra) # 80004198 <end_op>
  return -1;
    800056b8:	557d                	li	a0,-1
}
    800056ba:	70ae                	ld	ra,232(sp)
    800056bc:	740e                	ld	s0,224(sp)
    800056be:	64ee                	ld	s1,216(sp)
    800056c0:	694e                	ld	s2,208(sp)
    800056c2:	69ae                	ld	s3,200(sp)
    800056c4:	616d                	addi	sp,sp,240
    800056c6:	8082                	ret

00000000800056c8 <sys_symlink>:

uint64
sys_symlink(void)
{
    800056c8:	712d                	addi	sp,sp,-288
    800056ca:	ee06                	sd	ra,280(sp)
    800056cc:	ea22                	sd	s0,272(sp)
    800056ce:	e626                	sd	s1,264(sp)
    800056d0:	1200                	addi	s0,sp,288
  char target[MAXPATH], path[MAXPATH];
  struct inode *ip;

  //fetch target and path arguments
  if (argstr(0, target, MAXPATH) < 0 || argstr(1, path, MAXPATH) < 0)
    800056d2:	08000613          	li	a2,128
    800056d6:	f6040593          	addi	a1,s0,-160
    800056da:	4501                	li	a0,0
    800056dc:	ffffd097          	auipc	ra,0xffffd
    800056e0:	3cc080e7          	jalr	972(ra) # 80002aa8 <argstr>
    return -1;
    800056e4:	57fd                	li	a5,-1
  if (argstr(0, target, MAXPATH) < 0 || argstr(1, path, MAXPATH) < 0)
    800056e6:	06054563          	bltz	a0,80005750 <sys_symlink+0x88>
    800056ea:	08000613          	li	a2,128
    800056ee:	ee040593          	addi	a1,s0,-288
    800056f2:	4505                	li	a0,1
    800056f4:	ffffd097          	auipc	ra,0xffffd
    800056f8:	3b4080e7          	jalr	948(ra) # 80002aa8 <argstr>
    return -1;
    800056fc:	57fd                	li	a5,-1
  if (argstr(0, target, MAXPATH) < 0 || argstr(1, path, MAXPATH) < 0)
    800056fe:	04054963          	bltz	a0,80005750 <sys_symlink+0x88>

  begin_op();
    80005702:	fffff097          	auipc	ra,0xfffff
    80005706:	a16080e7          	jalr	-1514(ra) # 80004118 <begin_op>
  //create inode
  if ((ip = create(path, T_SYMLINK, 0, 0)) == 0) {
    8000570a:	4681                	li	a3,0
    8000570c:	4601                	li	a2,0
    8000570e:	4591                	li	a1,4
    80005710:	ee040513          	addi	a0,s0,-288
    80005714:	00000097          	auipc	ra,0x0
    80005718:	97c080e7          	jalr	-1668(ra) # 80005090 <create>
    8000571c:	84aa                	mv	s1,a0
    8000571e:	cd1d                	beqz	a0,8000575c <sys_symlink+0x94>
    end_op();
    return -1;
  }

  //write target to inode's data
  if (writei(ip, 0, (uint64)target, 0, MAXPATH) < MAXPATH) {
    80005720:	08000713          	li	a4,128
    80005724:	4681                	li	a3,0
    80005726:	f6040613          	addi	a2,s0,-160
    8000572a:	4581                	li	a1,0
    8000572c:	ffffe097          	auipc	ra,0xffffe
    80005730:	3c4080e7          	jalr	964(ra) # 80003af0 <writei>
    80005734:	07f00793          	li	a5,127
    80005738:	02a7d863          	bge	a5,a0,80005768 <sys_symlink+0xa0>
    iunlockput(ip);
    end_op();
    return -1;
  }

  iunlockput(ip);
    8000573c:	8526                	mv	a0,s1
    8000573e:	ffffe097          	auipc	ra,0xffffe
    80005742:	268080e7          	jalr	616(ra) # 800039a6 <iunlockput>
  end_op();
    80005746:	fffff097          	auipc	ra,0xfffff
    8000574a:	a52080e7          	jalr	-1454(ra) # 80004198 <end_op>
  return 0;
    8000574e:	4781                	li	a5,0
}
    80005750:	853e                	mv	a0,a5
    80005752:	60f2                	ld	ra,280(sp)
    80005754:	6452                	ld	s0,272(sp)
    80005756:	64b2                	ld	s1,264(sp)
    80005758:	6115                	addi	sp,sp,288
    8000575a:	8082                	ret
    end_op();
    8000575c:	fffff097          	auipc	ra,0xfffff
    80005760:	a3c080e7          	jalr	-1476(ra) # 80004198 <end_op>
    return -1;
    80005764:	57fd                	li	a5,-1
    80005766:	b7ed                	j	80005750 <sys_symlink+0x88>
    iunlockput(ip);
    80005768:	8526                	mv	a0,s1
    8000576a:	ffffe097          	auipc	ra,0xffffe
    8000576e:	23c080e7          	jalr	572(ra) # 800039a6 <iunlockput>
    end_op();
    80005772:	fffff097          	auipc	ra,0xfffff
    80005776:	a26080e7          	jalr	-1498(ra) # 80004198 <end_op>
    return -1;
    8000577a:	57fd                	li	a5,-1
    8000577c:	bfd1                	j	80005750 <sys_symlink+0x88>

000000008000577e <sys_open>:

uint64
sys_open(void)
{
    8000577e:	7155                	addi	sp,sp,-208
    80005780:	e586                	sd	ra,200(sp)
    80005782:	e1a2                	sd	s0,192(sp)
    80005784:	fd26                	sd	s1,184(sp)
    80005786:	f94a                	sd	s2,176(sp)
    80005788:	f54e                	sd	s3,168(sp)
    8000578a:	f152                	sd	s4,160(sp)
    8000578c:	ed56                	sd	s5,152(sp)
    8000578e:	0980                	addi	s0,sp,208
  int fd, omode;
  struct file *f;
  struct inode *ip;
  int n;

  if((n = argstr(0, path, MAXPATH)) < 0 || argint(1, &omode) < 0)
    80005790:	08000613          	li	a2,128
    80005794:	f4040593          	addi	a1,s0,-192
    80005798:	4501                	li	a0,0
    8000579a:	ffffd097          	auipc	ra,0xffffd
    8000579e:	30e080e7          	jalr	782(ra) # 80002aa8 <argstr>
    return -1;
    800057a2:	597d                	li	s2,-1
  if((n = argstr(0, path, MAXPATH)) < 0 || argint(1, &omode) < 0)
    800057a4:	12054663          	bltz	a0,800058d0 <sys_open+0x152>
    800057a8:	f3c40593          	addi	a1,s0,-196
    800057ac:	4505                	li	a0,1
    800057ae:	ffffd097          	auipc	ra,0xffffd
    800057b2:	2b6080e7          	jalr	694(ra) # 80002a64 <argint>
    800057b6:	10054d63          	bltz	a0,800058d0 <sys_open+0x152>

  begin_op();
    800057ba:	fffff097          	auipc	ra,0xfffff
    800057be:	95e080e7          	jalr	-1698(ra) # 80004118 <begin_op>

  if(omode & O_CREATE){
    800057c2:	f3c42783          	lw	a5,-196(s0)
    800057c6:	2007f793          	andi	a5,a5,512
    800057ca:	4941                	li	s2,16
    800057cc:	e7ad                	bnez	a5,80005836 <sys_open+0xb8>
        return -1;
      }

      ilock(ip);

      if (ip->type == T_SYMLINK && (omode & O_NOFOLLOW) == 0) {  //the inode is a symbolic link and we should follow it
    800057ce:	4a11                	li	s4,4
    800057d0:	6985                	lui	s3,0x1
    800057d2:	80098993          	addi	s3,s3,-2048 # 800 <_entry-0x7ffff800>
          iunlockput(ip);
          end_op();
          return -1;
        }

        if (readi(ip, 0, (uint64)path, 0, MAXPATH) < MAXPATH) {  //read target from inode's data to recursive
    800057d6:	07f00a93          	li	s5,127
      if ((ip = namei(path)) == 0) {  //get the inode according to current path
    800057da:	f4040513          	addi	a0,s0,-192
    800057de:	ffffe097          	auipc	ra,0xffffe
    800057e2:	71e080e7          	jalr	1822(ra) # 80003efc <namei>
    800057e6:	84aa                	mv	s1,a0
    800057e8:	10050463          	beqz	a0,800058f0 <sys_open+0x172>
      ilock(ip);
    800057ec:	ffffe097          	auipc	ra,0xffffe
    800057f0:	eae080e7          	jalr	-338(ra) # 8000369a <ilock>
      if (ip->type == T_SYMLINK && (omode & O_NOFOLLOW) == 0) {  //the inode is a symbolic link and we should follow it
    800057f4:	04449783          	lh	a5,68(s1)
    800057f8:	0007871b          	sext.w	a4,a5
    800057fc:	13471663          	bne	a4,s4,80005928 <sys_open+0x1aa>
    80005800:	f3c42783          	lw	a5,-196(s0)
    80005804:	00f9f7b3          	and	a5,s3,a5
    80005808:	efa1                	bnez	a5,80005860 <sys_open+0xe2>
        if (depth > max_depth) {  //recursive too deep
    8000580a:	397d                	addiw	s2,s2,-1
    8000580c:	0e090863          	beqz	s2,800058fc <sys_open+0x17e>
        if (readi(ip, 0, (uint64)path, 0, MAXPATH) < MAXPATH) {  //read target from inode's data to recursive
    80005810:	08000713          	li	a4,128
    80005814:	4681                	li	a3,0
    80005816:	f4040613          	addi	a2,s0,-192
    8000581a:	4581                	li	a1,0
    8000581c:	8526                	mv	a0,s1
    8000581e:	ffffe097          	auipc	ra,0xffffe
    80005822:	1da080e7          	jalr	474(ra) # 800039f8 <readi>
    80005826:	0eaad663          	bge	s5,a0,80005912 <sys_open+0x194>
          iunlockput(ip);
          end_op();
          return -1;
        }

        iunlockput(ip);
    8000582a:	8526                	mv	a0,s1
    8000582c:	ffffe097          	auipc	ra,0xffffe
    80005830:	17a080e7          	jalr	378(ra) # 800039a6 <iunlockput>
      if ((ip = namei(path)) == 0) {  //get the inode according to current path
    80005834:	b75d                	j	800057da <sys_open+0x5c>
    ip = create(path, T_FILE, 0, 0);
    80005836:	4681                	li	a3,0
    80005838:	4601                	li	a2,0
    8000583a:	4589                	li	a1,2
    8000583c:	f4040513          	addi	a0,s0,-192
    80005840:	00000097          	auipc	ra,0x0
    80005844:	850080e7          	jalr	-1968(ra) # 80005090 <create>
    80005848:	84aa                	mv	s1,a0
    if(ip == 0){
    8000584a:	cd49                	beqz	a0,800058e4 <sys_open+0x166>
      end_op();
      return -1;
    }
  }

  if(ip->type == T_DEVICE && (ip->major < 0 || ip->major >= NDEV)){
    8000584c:	04449703          	lh	a4,68(s1)
    80005850:	478d                	li	a5,3
    80005852:	00f71763          	bne	a4,a5,80005860 <sys_open+0xe2>
    80005856:	0464d703          	lhu	a4,70(s1)
    8000585a:	47a5                	li	a5,9
    8000585c:	0ee7e863          	bltu	a5,a4,8000594c <sys_open+0x1ce>
    iunlockput(ip);
    end_op();
    return -1;
  }

  if((f = filealloc()) == 0 || (fd = fdalloc(f)) < 0){
    80005860:	fffff097          	auipc	ra,0xfffff
    80005864:	cd0080e7          	jalr	-816(ra) # 80004530 <filealloc>
    80005868:	89aa                	mv	s3,a0
    8000586a:	10050e63          	beqz	a0,80005986 <sys_open+0x208>
    8000586e:	fffff097          	auipc	ra,0xfffff
    80005872:	7e0080e7          	jalr	2016(ra) # 8000504e <fdalloc>
    80005876:	892a                	mv	s2,a0
    80005878:	10054263          	bltz	a0,8000597c <sys_open+0x1fe>
    iunlockput(ip);
    end_op();
    return -1;
  }

  if(ip->type == T_DEVICE){
    8000587c:	04449703          	lh	a4,68(s1)
    80005880:	478d                	li	a5,3
    80005882:	0ef70063          	beq	a4,a5,80005962 <sys_open+0x1e4>
    f->type = FD_DEVICE;
    f->major = ip->major;
  } else {
    f->type = FD_INODE;
    80005886:	4789                	li	a5,2
    80005888:	00f9a023          	sw	a5,0(s3)
    f->off = 0;
    8000588c:	0209a023          	sw	zero,32(s3)
  }
  f->ip = ip;
    80005890:	0099bc23          	sd	s1,24(s3)
  f->readable = !(omode & O_WRONLY);
    80005894:	f3c42783          	lw	a5,-196(s0)
    80005898:	0017c713          	xori	a4,a5,1
    8000589c:	8b05                	andi	a4,a4,1
    8000589e:	00e98423          	sb	a4,8(s3)
  f->writable = (omode & O_WRONLY) || (omode & O_RDWR);
    800058a2:	0037f713          	andi	a4,a5,3
    800058a6:	00e03733          	snez	a4,a4
    800058aa:	00e984a3          	sb	a4,9(s3)

  if((omode & O_TRUNC) && ip->type == T_FILE){
    800058ae:	4007f793          	andi	a5,a5,1024
    800058b2:	c791                	beqz	a5,800058be <sys_open+0x140>
    800058b4:	04449703          	lh	a4,68(s1)
    800058b8:	4789                	li	a5,2
    800058ba:	0af70b63          	beq	a4,a5,80005970 <sys_open+0x1f2>
    itrunc(ip);
  }

  iunlock(ip);
    800058be:	8526                	mv	a0,s1
    800058c0:	ffffe097          	auipc	ra,0xffffe
    800058c4:	e9c080e7          	jalr	-356(ra) # 8000375c <iunlock>
  end_op();
    800058c8:	fffff097          	auipc	ra,0xfffff
    800058cc:	8d0080e7          	jalr	-1840(ra) # 80004198 <end_op>

  return fd;
}
    800058d0:	854a                	mv	a0,s2
    800058d2:	60ae                	ld	ra,200(sp)
    800058d4:	640e                	ld	s0,192(sp)
    800058d6:	74ea                	ld	s1,184(sp)
    800058d8:	794a                	ld	s2,176(sp)
    800058da:	79aa                	ld	s3,168(sp)
    800058dc:	7a0a                	ld	s4,160(sp)
    800058de:	6aea                	ld	s5,152(sp)
    800058e0:	6169                	addi	sp,sp,208
    800058e2:	8082                	ret
      end_op();
    800058e4:	fffff097          	auipc	ra,0xfffff
    800058e8:	8b4080e7          	jalr	-1868(ra) # 80004198 <end_op>
      return -1;
    800058ec:	597d                	li	s2,-1
    800058ee:	b7cd                	j	800058d0 <sys_open+0x152>
        end_op();
    800058f0:	fffff097          	auipc	ra,0xfffff
    800058f4:	8a8080e7          	jalr	-1880(ra) # 80004198 <end_op>
        return -1;
    800058f8:	597d                	li	s2,-1
    800058fa:	bfd9                	j	800058d0 <sys_open+0x152>
          iunlockput(ip);
    800058fc:	8526                	mv	a0,s1
    800058fe:	ffffe097          	auipc	ra,0xffffe
    80005902:	0a8080e7          	jalr	168(ra) # 800039a6 <iunlockput>
          end_op();
    80005906:	fffff097          	auipc	ra,0xfffff
    8000590a:	892080e7          	jalr	-1902(ra) # 80004198 <end_op>
          return -1;
    8000590e:	597d                	li	s2,-1
    80005910:	b7c1                	j	800058d0 <sys_open+0x152>
          iunlockput(ip);
    80005912:	8526                	mv	a0,s1
    80005914:	ffffe097          	auipc	ra,0xffffe
    80005918:	092080e7          	jalr	146(ra) # 800039a6 <iunlockput>
          end_op();
    8000591c:	fffff097          	auipc	ra,0xfffff
    80005920:	87c080e7          	jalr	-1924(ra) # 80004198 <end_op>
          return -1;
    80005924:	597d                	li	s2,-1
    80005926:	b76d                	j	800058d0 <sys_open+0x152>
    if(ip->type == T_DIR && omode != O_RDONLY){
    80005928:	2781                	sext.w	a5,a5
    8000592a:	4705                	li	a4,1
    8000592c:	f2e790e3          	bne	a5,a4,8000584c <sys_open+0xce>
    80005930:	f3c42783          	lw	a5,-196(s0)
    80005934:	d795                	beqz	a5,80005860 <sys_open+0xe2>
      iunlockput(ip);
    80005936:	8526                	mv	a0,s1
    80005938:	ffffe097          	auipc	ra,0xffffe
    8000593c:	06e080e7          	jalr	110(ra) # 800039a6 <iunlockput>
      end_op();
    80005940:	fffff097          	auipc	ra,0xfffff
    80005944:	858080e7          	jalr	-1960(ra) # 80004198 <end_op>
      return -1;
    80005948:	597d                	li	s2,-1
    8000594a:	b759                	j	800058d0 <sys_open+0x152>
    iunlockput(ip);
    8000594c:	8526                	mv	a0,s1
    8000594e:	ffffe097          	auipc	ra,0xffffe
    80005952:	058080e7          	jalr	88(ra) # 800039a6 <iunlockput>
    end_op();
    80005956:	fffff097          	auipc	ra,0xfffff
    8000595a:	842080e7          	jalr	-1982(ra) # 80004198 <end_op>
    return -1;
    8000595e:	597d                	li	s2,-1
    80005960:	bf85                	j	800058d0 <sys_open+0x152>
    f->type = FD_DEVICE;
    80005962:	00f9a023          	sw	a5,0(s3)
    f->major = ip->major;
    80005966:	04649783          	lh	a5,70(s1)
    8000596a:	02f99223          	sh	a5,36(s3)
    8000596e:	b70d                	j	80005890 <sys_open+0x112>
    itrunc(ip);
    80005970:	8526                	mv	a0,s1
    80005972:	ffffe097          	auipc	ra,0xffffe
    80005976:	e36080e7          	jalr	-458(ra) # 800037a8 <itrunc>
    8000597a:	b791                	j	800058be <sys_open+0x140>
      fileclose(f);
    8000597c:	854e                	mv	a0,s3
    8000597e:	fffff097          	auipc	ra,0xfffff
    80005982:	c6e080e7          	jalr	-914(ra) # 800045ec <fileclose>
    iunlockput(ip);
    80005986:	8526                	mv	a0,s1
    80005988:	ffffe097          	auipc	ra,0xffffe
    8000598c:	01e080e7          	jalr	30(ra) # 800039a6 <iunlockput>
    end_op();
    80005990:	fffff097          	auipc	ra,0xfffff
    80005994:	808080e7          	jalr	-2040(ra) # 80004198 <end_op>
    return -1;
    80005998:	597d                	li	s2,-1
    8000599a:	bf1d                	j	800058d0 <sys_open+0x152>

000000008000599c <sys_mkdir>:

uint64
sys_mkdir(void)
{
    8000599c:	7175                	addi	sp,sp,-144
    8000599e:	e506                	sd	ra,136(sp)
    800059a0:	e122                	sd	s0,128(sp)
    800059a2:	0900                	addi	s0,sp,144
  char path[MAXPATH];
  struct inode *ip;

  begin_op();
    800059a4:	ffffe097          	auipc	ra,0xffffe
    800059a8:	774080e7          	jalr	1908(ra) # 80004118 <begin_op>
  if(argstr(0, path, MAXPATH) < 0 || (ip = create(path, T_DIR, 0, 0)) == 0){
    800059ac:	08000613          	li	a2,128
    800059b0:	f7040593          	addi	a1,s0,-144
    800059b4:	4501                	li	a0,0
    800059b6:	ffffd097          	auipc	ra,0xffffd
    800059ba:	0f2080e7          	jalr	242(ra) # 80002aa8 <argstr>
    800059be:	02054963          	bltz	a0,800059f0 <sys_mkdir+0x54>
    800059c2:	4681                	li	a3,0
    800059c4:	4601                	li	a2,0
    800059c6:	4585                	li	a1,1
    800059c8:	f7040513          	addi	a0,s0,-144
    800059cc:	fffff097          	auipc	ra,0xfffff
    800059d0:	6c4080e7          	jalr	1732(ra) # 80005090 <create>
    800059d4:	cd11                	beqz	a0,800059f0 <sys_mkdir+0x54>
    end_op();
    return -1;
  }
  iunlockput(ip);
    800059d6:	ffffe097          	auipc	ra,0xffffe
    800059da:	fd0080e7          	jalr	-48(ra) # 800039a6 <iunlockput>
  end_op();
    800059de:	ffffe097          	auipc	ra,0xffffe
    800059e2:	7ba080e7          	jalr	1978(ra) # 80004198 <end_op>
  return 0;
    800059e6:	4501                	li	a0,0
}
    800059e8:	60aa                	ld	ra,136(sp)
    800059ea:	640a                	ld	s0,128(sp)
    800059ec:	6149                	addi	sp,sp,144
    800059ee:	8082                	ret
    end_op();
    800059f0:	ffffe097          	auipc	ra,0xffffe
    800059f4:	7a8080e7          	jalr	1960(ra) # 80004198 <end_op>
    return -1;
    800059f8:	557d                	li	a0,-1
    800059fa:	b7fd                	j	800059e8 <sys_mkdir+0x4c>

00000000800059fc <sys_mknod>:

uint64
sys_mknod(void)
{
    800059fc:	7135                	addi	sp,sp,-160
    800059fe:	ed06                	sd	ra,152(sp)
    80005a00:	e922                	sd	s0,144(sp)
    80005a02:	1100                	addi	s0,sp,160
  struct inode *ip;
  char path[MAXPATH];
  int major, minor;

  begin_op();
    80005a04:	ffffe097          	auipc	ra,0xffffe
    80005a08:	714080e7          	jalr	1812(ra) # 80004118 <begin_op>
  if((argstr(0, path, MAXPATH)) < 0 ||
    80005a0c:	08000613          	li	a2,128
    80005a10:	f7040593          	addi	a1,s0,-144
    80005a14:	4501                	li	a0,0
    80005a16:	ffffd097          	auipc	ra,0xffffd
    80005a1a:	092080e7          	jalr	146(ra) # 80002aa8 <argstr>
    80005a1e:	04054a63          	bltz	a0,80005a72 <sys_mknod+0x76>
     argint(1, &major) < 0 ||
    80005a22:	f6c40593          	addi	a1,s0,-148
    80005a26:	4505                	li	a0,1
    80005a28:	ffffd097          	auipc	ra,0xffffd
    80005a2c:	03c080e7          	jalr	60(ra) # 80002a64 <argint>
  if((argstr(0, path, MAXPATH)) < 0 ||
    80005a30:	04054163          	bltz	a0,80005a72 <sys_mknod+0x76>
     argint(2, &minor) < 0 ||
    80005a34:	f6840593          	addi	a1,s0,-152
    80005a38:	4509                	li	a0,2
    80005a3a:	ffffd097          	auipc	ra,0xffffd
    80005a3e:	02a080e7          	jalr	42(ra) # 80002a64 <argint>
     argint(1, &major) < 0 ||
    80005a42:	02054863          	bltz	a0,80005a72 <sys_mknod+0x76>
     (ip = create(path, T_DEVICE, major, minor)) == 0){
    80005a46:	f6841683          	lh	a3,-152(s0)
    80005a4a:	f6c41603          	lh	a2,-148(s0)
    80005a4e:	458d                	li	a1,3
    80005a50:	f7040513          	addi	a0,s0,-144
    80005a54:	fffff097          	auipc	ra,0xfffff
    80005a58:	63c080e7          	jalr	1596(ra) # 80005090 <create>
     argint(2, &minor) < 0 ||
    80005a5c:	c919                	beqz	a0,80005a72 <sys_mknod+0x76>
    end_op();
    return -1;
  }
  iunlockput(ip);
    80005a5e:	ffffe097          	auipc	ra,0xffffe
    80005a62:	f48080e7          	jalr	-184(ra) # 800039a6 <iunlockput>
  end_op();
    80005a66:	ffffe097          	auipc	ra,0xffffe
    80005a6a:	732080e7          	jalr	1842(ra) # 80004198 <end_op>
  return 0;
    80005a6e:	4501                	li	a0,0
    80005a70:	a031                	j	80005a7c <sys_mknod+0x80>
    end_op();
    80005a72:	ffffe097          	auipc	ra,0xffffe
    80005a76:	726080e7          	jalr	1830(ra) # 80004198 <end_op>
    return -1;
    80005a7a:	557d                	li	a0,-1
}
    80005a7c:	60ea                	ld	ra,152(sp)
    80005a7e:	644a                	ld	s0,144(sp)
    80005a80:	610d                	addi	sp,sp,160
    80005a82:	8082                	ret

0000000080005a84 <sys_chdir>:

uint64
sys_chdir(void)
{
    80005a84:	7135                	addi	sp,sp,-160
    80005a86:	ed06                	sd	ra,152(sp)
    80005a88:	e922                	sd	s0,144(sp)
    80005a8a:	e526                	sd	s1,136(sp)
    80005a8c:	e14a                	sd	s2,128(sp)
    80005a8e:	1100                	addi	s0,sp,160
  char path[MAXPATH];
  struct inode *ip;
  struct proc *p = myproc();
    80005a90:	ffffc097          	auipc	ra,0xffffc
    80005a94:	f1a080e7          	jalr	-230(ra) # 800019aa <myproc>
    80005a98:	892a                	mv	s2,a0
  
  begin_op();
    80005a9a:	ffffe097          	auipc	ra,0xffffe
    80005a9e:	67e080e7          	jalr	1662(ra) # 80004118 <begin_op>
  if(argstr(0, path, MAXPATH) < 0 || (ip = namei(path)) == 0){
    80005aa2:	08000613          	li	a2,128
    80005aa6:	f6040593          	addi	a1,s0,-160
    80005aaa:	4501                	li	a0,0
    80005aac:	ffffd097          	auipc	ra,0xffffd
    80005ab0:	ffc080e7          	jalr	-4(ra) # 80002aa8 <argstr>
    80005ab4:	04054b63          	bltz	a0,80005b0a <sys_chdir+0x86>
    80005ab8:	f6040513          	addi	a0,s0,-160
    80005abc:	ffffe097          	auipc	ra,0xffffe
    80005ac0:	440080e7          	jalr	1088(ra) # 80003efc <namei>
    80005ac4:	84aa                	mv	s1,a0
    80005ac6:	c131                	beqz	a0,80005b0a <sys_chdir+0x86>
    end_op();
    return -1;
  }
  ilock(ip);
    80005ac8:	ffffe097          	auipc	ra,0xffffe
    80005acc:	bd2080e7          	jalr	-1070(ra) # 8000369a <ilock>
  if(ip->type != T_DIR){
    80005ad0:	04449703          	lh	a4,68(s1)
    80005ad4:	4785                	li	a5,1
    80005ad6:	04f71063          	bne	a4,a5,80005b16 <sys_chdir+0x92>
    iunlockput(ip);
    end_op();
    return -1;
  }
  iunlock(ip);
    80005ada:	8526                	mv	a0,s1
    80005adc:	ffffe097          	auipc	ra,0xffffe
    80005ae0:	c80080e7          	jalr	-896(ra) # 8000375c <iunlock>
  iput(p->cwd);
    80005ae4:	15093503          	ld	a0,336(s2)
    80005ae8:	ffffe097          	auipc	ra,0xffffe
    80005aec:	e16080e7          	jalr	-490(ra) # 800038fe <iput>
  end_op();
    80005af0:	ffffe097          	auipc	ra,0xffffe
    80005af4:	6a8080e7          	jalr	1704(ra) # 80004198 <end_op>
  p->cwd = ip;
    80005af8:	14993823          	sd	s1,336(s2)
  return 0;
    80005afc:	4501                	li	a0,0
}
    80005afe:	60ea                	ld	ra,152(sp)
    80005b00:	644a                	ld	s0,144(sp)
    80005b02:	64aa                	ld	s1,136(sp)
    80005b04:	690a                	ld	s2,128(sp)
    80005b06:	610d                	addi	sp,sp,160
    80005b08:	8082                	ret
    end_op();
    80005b0a:	ffffe097          	auipc	ra,0xffffe
    80005b0e:	68e080e7          	jalr	1678(ra) # 80004198 <end_op>
    return -1;
    80005b12:	557d                	li	a0,-1
    80005b14:	b7ed                	j	80005afe <sys_chdir+0x7a>
    iunlockput(ip);
    80005b16:	8526                	mv	a0,s1
    80005b18:	ffffe097          	auipc	ra,0xffffe
    80005b1c:	e8e080e7          	jalr	-370(ra) # 800039a6 <iunlockput>
    end_op();
    80005b20:	ffffe097          	auipc	ra,0xffffe
    80005b24:	678080e7          	jalr	1656(ra) # 80004198 <end_op>
    return -1;
    80005b28:	557d                	li	a0,-1
    80005b2a:	bfd1                	j	80005afe <sys_chdir+0x7a>

0000000080005b2c <sys_exec>:

uint64
sys_exec(void)
{
    80005b2c:	7145                	addi	sp,sp,-464
    80005b2e:	e786                	sd	ra,456(sp)
    80005b30:	e3a2                	sd	s0,448(sp)
    80005b32:	ff26                	sd	s1,440(sp)
    80005b34:	fb4a                	sd	s2,432(sp)
    80005b36:	f74e                	sd	s3,424(sp)
    80005b38:	f352                	sd	s4,416(sp)
    80005b3a:	ef56                	sd	s5,408(sp)
    80005b3c:	0b80                	addi	s0,sp,464
  char path[MAXPATH], *argv[MAXARG];
  int i;
  uint64 uargv, uarg;

  if(argstr(0, path, MAXPATH) < 0 || argaddr(1, &uargv) < 0){
    80005b3e:	08000613          	li	a2,128
    80005b42:	f4040593          	addi	a1,s0,-192
    80005b46:	4501                	li	a0,0
    80005b48:	ffffd097          	auipc	ra,0xffffd
    80005b4c:	f60080e7          	jalr	-160(ra) # 80002aa8 <argstr>
    return -1;
    80005b50:	597d                	li	s2,-1
  if(argstr(0, path, MAXPATH) < 0 || argaddr(1, &uargv) < 0){
    80005b52:	0c054a63          	bltz	a0,80005c26 <sys_exec+0xfa>
    80005b56:	e3840593          	addi	a1,s0,-456
    80005b5a:	4505                	li	a0,1
    80005b5c:	ffffd097          	auipc	ra,0xffffd
    80005b60:	f2a080e7          	jalr	-214(ra) # 80002a86 <argaddr>
    80005b64:	0c054163          	bltz	a0,80005c26 <sys_exec+0xfa>
  }
  memset(argv, 0, sizeof(argv));
    80005b68:	10000613          	li	a2,256
    80005b6c:	4581                	li	a1,0
    80005b6e:	e4040513          	addi	a0,s0,-448
    80005b72:	ffffb097          	auipc	ra,0xffffb
    80005b76:	14c080e7          	jalr	332(ra) # 80000cbe <memset>
  for(i=0;; i++){
    if(i >= NELEM(argv)){
    80005b7a:	e4040493          	addi	s1,s0,-448
  memset(argv, 0, sizeof(argv));
    80005b7e:	89a6                	mv	s3,s1
    80005b80:	4901                	li	s2,0
    if(i >= NELEM(argv)){
    80005b82:	02000a13          	li	s4,32
    80005b86:	00090a9b          	sext.w	s5,s2
      goto bad;
    }
    if(fetchaddr(uargv+sizeof(uint64)*i, (uint64*)&uarg) < 0){
    80005b8a:	00391793          	slli	a5,s2,0x3
    80005b8e:	e3040593          	addi	a1,s0,-464
    80005b92:	e3843503          	ld	a0,-456(s0)
    80005b96:	953e                	add	a0,a0,a5
    80005b98:	ffffd097          	auipc	ra,0xffffd
    80005b9c:	e32080e7          	jalr	-462(ra) # 800029ca <fetchaddr>
    80005ba0:	02054a63          	bltz	a0,80005bd4 <sys_exec+0xa8>
      goto bad;
    }
    if(uarg == 0){
    80005ba4:	e3043783          	ld	a5,-464(s0)
    80005ba8:	c3b9                	beqz	a5,80005bee <sys_exec+0xc2>
      argv[i] = 0;
      break;
    }
    argv[i] = kalloc();
    80005baa:	ffffb097          	auipc	ra,0xffffb
    80005bae:	f28080e7          	jalr	-216(ra) # 80000ad2 <kalloc>
    80005bb2:	85aa                	mv	a1,a0
    80005bb4:	00a9b023          	sd	a0,0(s3)
    if(argv[i] == 0)
    80005bb8:	cd11                	beqz	a0,80005bd4 <sys_exec+0xa8>
      goto bad;
    if(fetchstr(uarg, argv[i], PGSIZE) < 0)
    80005bba:	6605                	lui	a2,0x1
    80005bbc:	e3043503          	ld	a0,-464(s0)
    80005bc0:	ffffd097          	auipc	ra,0xffffd
    80005bc4:	e5c080e7          	jalr	-420(ra) # 80002a1c <fetchstr>
    80005bc8:	00054663          	bltz	a0,80005bd4 <sys_exec+0xa8>
    if(i >= NELEM(argv)){
    80005bcc:	0905                	addi	s2,s2,1
    80005bce:	09a1                	addi	s3,s3,8
    80005bd0:	fb491be3          	bne	s2,s4,80005b86 <sys_exec+0x5a>
    kfree(argv[i]);

  return ret;

 bad:
  for(i = 0; i < NELEM(argv) && argv[i] != 0; i++)
    80005bd4:	10048913          	addi	s2,s1,256
    80005bd8:	6088                	ld	a0,0(s1)
    80005bda:	c529                	beqz	a0,80005c24 <sys_exec+0xf8>
    kfree(argv[i]);
    80005bdc:	ffffb097          	auipc	ra,0xffffb
    80005be0:	dfa080e7          	jalr	-518(ra) # 800009d6 <kfree>
  for(i = 0; i < NELEM(argv) && argv[i] != 0; i++)
    80005be4:	04a1                	addi	s1,s1,8
    80005be6:	ff2499e3          	bne	s1,s2,80005bd8 <sys_exec+0xac>
  return -1;
    80005bea:	597d                	li	s2,-1
    80005bec:	a82d                	j	80005c26 <sys_exec+0xfa>
      argv[i] = 0;
    80005bee:	0a8e                	slli	s5,s5,0x3
    80005bf0:	fc040793          	addi	a5,s0,-64
    80005bf4:	9abe                	add	s5,s5,a5
    80005bf6:	e80ab023          	sd	zero,-384(s5) # ffffffffffffee80 <end+0xffffffff7ffdde80>
  int ret = exec(path, argv);
    80005bfa:	e4040593          	addi	a1,s0,-448
    80005bfe:	f4040513          	addi	a0,s0,-192
    80005c02:	fffff097          	auipc	ra,0xfffff
    80005c06:	03c080e7          	jalr	60(ra) # 80004c3e <exec>
    80005c0a:	892a                	mv	s2,a0
  for(i = 0; i < NELEM(argv) && argv[i] != 0; i++)
    80005c0c:	10048993          	addi	s3,s1,256
    80005c10:	6088                	ld	a0,0(s1)
    80005c12:	c911                	beqz	a0,80005c26 <sys_exec+0xfa>
    kfree(argv[i]);
    80005c14:	ffffb097          	auipc	ra,0xffffb
    80005c18:	dc2080e7          	jalr	-574(ra) # 800009d6 <kfree>
  for(i = 0; i < NELEM(argv) && argv[i] != 0; i++)
    80005c1c:	04a1                	addi	s1,s1,8
    80005c1e:	ff3499e3          	bne	s1,s3,80005c10 <sys_exec+0xe4>
    80005c22:	a011                	j	80005c26 <sys_exec+0xfa>
  return -1;
    80005c24:	597d                	li	s2,-1
}
    80005c26:	854a                	mv	a0,s2
    80005c28:	60be                	ld	ra,456(sp)
    80005c2a:	641e                	ld	s0,448(sp)
    80005c2c:	74fa                	ld	s1,440(sp)
    80005c2e:	795a                	ld	s2,432(sp)
    80005c30:	79ba                	ld	s3,424(sp)
    80005c32:	7a1a                	ld	s4,416(sp)
    80005c34:	6afa                	ld	s5,408(sp)
    80005c36:	6179                	addi	sp,sp,464
    80005c38:	8082                	ret

0000000080005c3a <sys_pipe>:

uint64
sys_pipe(void)
{
    80005c3a:	7139                	addi	sp,sp,-64
    80005c3c:	fc06                	sd	ra,56(sp)
    80005c3e:	f822                	sd	s0,48(sp)
    80005c40:	f426                	sd	s1,40(sp)
    80005c42:	0080                	addi	s0,sp,64
  uint64 fdarray; // user pointer to array of two integers
  struct file *rf, *wf;
  int fd0, fd1;
  struct proc *p = myproc();
    80005c44:	ffffc097          	auipc	ra,0xffffc
    80005c48:	d66080e7          	jalr	-666(ra) # 800019aa <myproc>
    80005c4c:	84aa                	mv	s1,a0

  if(argaddr(0, &fdarray) < 0)
    80005c4e:	fd840593          	addi	a1,s0,-40
    80005c52:	4501                	li	a0,0
    80005c54:	ffffd097          	auipc	ra,0xffffd
    80005c58:	e32080e7          	jalr	-462(ra) # 80002a86 <argaddr>
    return -1;
    80005c5c:	57fd                	li	a5,-1
  if(argaddr(0, &fdarray) < 0)
    80005c5e:	0e054063          	bltz	a0,80005d3e <sys_pipe+0x104>
  if(pipealloc(&rf, &wf) < 0)
    80005c62:	fc840593          	addi	a1,s0,-56
    80005c66:	fd040513          	addi	a0,s0,-48
    80005c6a:	fffff097          	auipc	ra,0xfffff
    80005c6e:	cb2080e7          	jalr	-846(ra) # 8000491c <pipealloc>
    return -1;
    80005c72:	57fd                	li	a5,-1
  if(pipealloc(&rf, &wf) < 0)
    80005c74:	0c054563          	bltz	a0,80005d3e <sys_pipe+0x104>
  fd0 = -1;
    80005c78:	fcf42223          	sw	a5,-60(s0)
  if((fd0 = fdalloc(rf)) < 0 || (fd1 = fdalloc(wf)) < 0){
    80005c7c:	fd043503          	ld	a0,-48(s0)
    80005c80:	fffff097          	auipc	ra,0xfffff
    80005c84:	3ce080e7          	jalr	974(ra) # 8000504e <fdalloc>
    80005c88:	fca42223          	sw	a0,-60(s0)
    80005c8c:	08054c63          	bltz	a0,80005d24 <sys_pipe+0xea>
    80005c90:	fc843503          	ld	a0,-56(s0)
    80005c94:	fffff097          	auipc	ra,0xfffff
    80005c98:	3ba080e7          	jalr	954(ra) # 8000504e <fdalloc>
    80005c9c:	fca42023          	sw	a0,-64(s0)
    80005ca0:	06054863          	bltz	a0,80005d10 <sys_pipe+0xd6>
      p->ofile[fd0] = 0;
    fileclose(rf);
    fileclose(wf);
    return -1;
  }
  if(copyout(p->pagetable, fdarray, (char*)&fd0, sizeof(fd0)) < 0 ||
    80005ca4:	4691                	li	a3,4
    80005ca6:	fc440613          	addi	a2,s0,-60
    80005caa:	fd843583          	ld	a1,-40(s0)
    80005cae:	68a8                	ld	a0,80(s1)
    80005cb0:	ffffc097          	auipc	ra,0xffffc
    80005cb4:	98e080e7          	jalr	-1650(ra) # 8000163e <copyout>
    80005cb8:	02054063          	bltz	a0,80005cd8 <sys_pipe+0x9e>
     copyout(p->pagetable, fdarray+sizeof(fd0), (char *)&fd1, sizeof(fd1)) < 0){
    80005cbc:	4691                	li	a3,4
    80005cbe:	fc040613          	addi	a2,s0,-64
    80005cc2:	fd843583          	ld	a1,-40(s0)
    80005cc6:	0591                	addi	a1,a1,4
    80005cc8:	68a8                	ld	a0,80(s1)
    80005cca:	ffffc097          	auipc	ra,0xffffc
    80005cce:	974080e7          	jalr	-1676(ra) # 8000163e <copyout>
    p->ofile[fd1] = 0;
    fileclose(rf);
    fileclose(wf);
    return -1;
  }
  return 0;
    80005cd2:	4781                	li	a5,0
  if(copyout(p->pagetable, fdarray, (char*)&fd0, sizeof(fd0)) < 0 ||
    80005cd4:	06055563          	bgez	a0,80005d3e <sys_pipe+0x104>
    p->ofile[fd0] = 0;
    80005cd8:	fc442783          	lw	a5,-60(s0)
    80005cdc:	07e9                	addi	a5,a5,26
    80005cde:	078e                	slli	a5,a5,0x3
    80005ce0:	97a6                	add	a5,a5,s1
    80005ce2:	0007b023          	sd	zero,0(a5)
    p->ofile[fd1] = 0;
    80005ce6:	fc042503          	lw	a0,-64(s0)
    80005cea:	0569                	addi	a0,a0,26
    80005cec:	050e                	slli	a0,a0,0x3
    80005cee:	9526                	add	a0,a0,s1
    80005cf0:	00053023          	sd	zero,0(a0)
    fileclose(rf);
    80005cf4:	fd043503          	ld	a0,-48(s0)
    80005cf8:	fffff097          	auipc	ra,0xfffff
    80005cfc:	8f4080e7          	jalr	-1804(ra) # 800045ec <fileclose>
    fileclose(wf);
    80005d00:	fc843503          	ld	a0,-56(s0)
    80005d04:	fffff097          	auipc	ra,0xfffff
    80005d08:	8e8080e7          	jalr	-1816(ra) # 800045ec <fileclose>
    return -1;
    80005d0c:	57fd                	li	a5,-1
    80005d0e:	a805                	j	80005d3e <sys_pipe+0x104>
    if(fd0 >= 0)
    80005d10:	fc442783          	lw	a5,-60(s0)
    80005d14:	0007c863          	bltz	a5,80005d24 <sys_pipe+0xea>
      p->ofile[fd0] = 0;
    80005d18:	01a78513          	addi	a0,a5,26
    80005d1c:	050e                	slli	a0,a0,0x3
    80005d1e:	9526                	add	a0,a0,s1
    80005d20:	00053023          	sd	zero,0(a0)
    fileclose(rf);
    80005d24:	fd043503          	ld	a0,-48(s0)
    80005d28:	fffff097          	auipc	ra,0xfffff
    80005d2c:	8c4080e7          	jalr	-1852(ra) # 800045ec <fileclose>
    fileclose(wf);
    80005d30:	fc843503          	ld	a0,-56(s0)
    80005d34:	fffff097          	auipc	ra,0xfffff
    80005d38:	8b8080e7          	jalr	-1864(ra) # 800045ec <fileclose>
    return -1;
    80005d3c:	57fd                	li	a5,-1
}
    80005d3e:	853e                	mv	a0,a5
    80005d40:	70e2                	ld	ra,56(sp)
    80005d42:	7442                	ld	s0,48(sp)
    80005d44:	74a2                	ld	s1,40(sp)
    80005d46:	6121                	addi	sp,sp,64
    80005d48:	8082                	ret
    80005d4a:	0000                	unimp
    80005d4c:	0000                	unimp
	...

0000000080005d50 <kernelvec>:
    80005d50:	7111                	addi	sp,sp,-256
    80005d52:	e006                	sd	ra,0(sp)
    80005d54:	e40a                	sd	sp,8(sp)
    80005d56:	e80e                	sd	gp,16(sp)
    80005d58:	ec12                	sd	tp,24(sp)
    80005d5a:	f016                	sd	t0,32(sp)
    80005d5c:	f41a                	sd	t1,40(sp)
    80005d5e:	f81e                	sd	t2,48(sp)
    80005d60:	fc22                	sd	s0,56(sp)
    80005d62:	e0a6                	sd	s1,64(sp)
    80005d64:	e4aa                	sd	a0,72(sp)
    80005d66:	e8ae                	sd	a1,80(sp)
    80005d68:	ecb2                	sd	a2,88(sp)
    80005d6a:	f0b6                	sd	a3,96(sp)
    80005d6c:	f4ba                	sd	a4,104(sp)
    80005d6e:	f8be                	sd	a5,112(sp)
    80005d70:	fcc2                	sd	a6,120(sp)
    80005d72:	e146                	sd	a7,128(sp)
    80005d74:	e54a                	sd	s2,136(sp)
    80005d76:	e94e                	sd	s3,144(sp)
    80005d78:	ed52                	sd	s4,152(sp)
    80005d7a:	f156                	sd	s5,160(sp)
    80005d7c:	f55a                	sd	s6,168(sp)
    80005d7e:	f95e                	sd	s7,176(sp)
    80005d80:	fd62                	sd	s8,184(sp)
    80005d82:	e1e6                	sd	s9,192(sp)
    80005d84:	e5ea                	sd	s10,200(sp)
    80005d86:	e9ee                	sd	s11,208(sp)
    80005d88:	edf2                	sd	t3,216(sp)
    80005d8a:	f1f6                	sd	t4,224(sp)
    80005d8c:	f5fa                	sd	t5,232(sp)
    80005d8e:	f9fe                	sd	t6,240(sp)
    80005d90:	b07fc0ef          	jal	ra,80002896 <kerneltrap>
    80005d94:	6082                	ld	ra,0(sp)
    80005d96:	6122                	ld	sp,8(sp)
    80005d98:	61c2                	ld	gp,16(sp)
    80005d9a:	7282                	ld	t0,32(sp)
    80005d9c:	7322                	ld	t1,40(sp)
    80005d9e:	73c2                	ld	t2,48(sp)
    80005da0:	7462                	ld	s0,56(sp)
    80005da2:	6486                	ld	s1,64(sp)
    80005da4:	6526                	ld	a0,72(sp)
    80005da6:	65c6                	ld	a1,80(sp)
    80005da8:	6666                	ld	a2,88(sp)
    80005daa:	7686                	ld	a3,96(sp)
    80005dac:	7726                	ld	a4,104(sp)
    80005dae:	77c6                	ld	a5,112(sp)
    80005db0:	7866                	ld	a6,120(sp)
    80005db2:	688a                	ld	a7,128(sp)
    80005db4:	692a                	ld	s2,136(sp)
    80005db6:	69ca                	ld	s3,144(sp)
    80005db8:	6a6a                	ld	s4,152(sp)
    80005dba:	7a8a                	ld	s5,160(sp)
    80005dbc:	7b2a                	ld	s6,168(sp)
    80005dbe:	7bca                	ld	s7,176(sp)
    80005dc0:	7c6a                	ld	s8,184(sp)
    80005dc2:	6c8e                	ld	s9,192(sp)
    80005dc4:	6d2e                	ld	s10,200(sp)
    80005dc6:	6dce                	ld	s11,208(sp)
    80005dc8:	6e6e                	ld	t3,216(sp)
    80005dca:	7e8e                	ld	t4,224(sp)
    80005dcc:	7f2e                	ld	t5,232(sp)
    80005dce:	7fce                	ld	t6,240(sp)
    80005dd0:	6111                	addi	sp,sp,256
    80005dd2:	10200073          	sret
    80005dd6:	00000013          	nop
    80005dda:	00000013          	nop
    80005dde:	0001                	nop

0000000080005de0 <timervec>:
    80005de0:	34051573          	csrrw	a0,mscratch,a0
    80005de4:	e10c                	sd	a1,0(a0)
    80005de6:	e510                	sd	a2,8(a0)
    80005de8:	e914                	sd	a3,16(a0)
    80005dea:	6d0c                	ld	a1,24(a0)
    80005dec:	7110                	ld	a2,32(a0)
    80005dee:	6194                	ld	a3,0(a1)
    80005df0:	96b2                	add	a3,a3,a2
    80005df2:	e194                	sd	a3,0(a1)
    80005df4:	4589                	li	a1,2
    80005df6:	14459073          	csrw	sip,a1
    80005dfa:	6914                	ld	a3,16(a0)
    80005dfc:	6510                	ld	a2,8(a0)
    80005dfe:	610c                	ld	a1,0(a0)
    80005e00:	34051573          	csrrw	a0,mscratch,a0
    80005e04:	30200073          	mret
	...

0000000080005e0a <plicinit>:
// the riscv Platform Level Interrupt Controller (PLIC).
//

void
plicinit(void)
{
    80005e0a:	1141                	addi	sp,sp,-16
    80005e0c:	e422                	sd	s0,8(sp)
    80005e0e:	0800                	addi	s0,sp,16
  // set desired IRQ priorities non-zero (otherwise disabled).
  *(uint32*)(PLIC + UART0_IRQ*4) = 1;
    80005e10:	0c0007b7          	lui	a5,0xc000
    80005e14:	4705                	li	a4,1
    80005e16:	d798                	sw	a4,40(a5)
  *(uint32*)(PLIC + VIRTIO0_IRQ*4) = 1;
    80005e18:	c3d8                	sw	a4,4(a5)
}
    80005e1a:	6422                	ld	s0,8(sp)
    80005e1c:	0141                	addi	sp,sp,16
    80005e1e:	8082                	ret

0000000080005e20 <plicinithart>:

void
plicinithart(void)
{
    80005e20:	1141                	addi	sp,sp,-16
    80005e22:	e406                	sd	ra,8(sp)
    80005e24:	e022                	sd	s0,0(sp)
    80005e26:	0800                	addi	s0,sp,16
  int hart = cpuid();
    80005e28:	ffffc097          	auipc	ra,0xffffc
    80005e2c:	b56080e7          	jalr	-1194(ra) # 8000197e <cpuid>
  
  // set uart's enable bit for this hart's S-mode. 
  *(uint32*)PLIC_SENABLE(hart)= (1 << UART0_IRQ) | (1 << VIRTIO0_IRQ);
    80005e30:	0085171b          	slliw	a4,a0,0x8
    80005e34:	0c0027b7          	lui	a5,0xc002
    80005e38:	97ba                	add	a5,a5,a4
    80005e3a:	40200713          	li	a4,1026
    80005e3e:	08e7a023          	sw	a4,128(a5) # c002080 <_entry-0x73ffdf80>

  // set this hart's S-mode priority threshold to 0.
  *(uint32*)PLIC_SPRIORITY(hart) = 0;
    80005e42:	00d5151b          	slliw	a0,a0,0xd
    80005e46:	0c2017b7          	lui	a5,0xc201
    80005e4a:	953e                	add	a0,a0,a5
    80005e4c:	00052023          	sw	zero,0(a0)
}
    80005e50:	60a2                	ld	ra,8(sp)
    80005e52:	6402                	ld	s0,0(sp)
    80005e54:	0141                	addi	sp,sp,16
    80005e56:	8082                	ret

0000000080005e58 <plic_claim>:

// ask the PLIC what interrupt we should serve.
int
plic_claim(void)
{
    80005e58:	1141                	addi	sp,sp,-16
    80005e5a:	e406                	sd	ra,8(sp)
    80005e5c:	e022                	sd	s0,0(sp)
    80005e5e:	0800                	addi	s0,sp,16
  int hart = cpuid();
    80005e60:	ffffc097          	auipc	ra,0xffffc
    80005e64:	b1e080e7          	jalr	-1250(ra) # 8000197e <cpuid>
  int irq = *(uint32*)PLIC_SCLAIM(hart);
    80005e68:	00d5179b          	slliw	a5,a0,0xd
    80005e6c:	0c201537          	lui	a0,0xc201
    80005e70:	953e                	add	a0,a0,a5
  return irq;
}
    80005e72:	4148                	lw	a0,4(a0)
    80005e74:	60a2                	ld	ra,8(sp)
    80005e76:	6402                	ld	s0,0(sp)
    80005e78:	0141                	addi	sp,sp,16
    80005e7a:	8082                	ret

0000000080005e7c <plic_complete>:

// tell the PLIC we've served this IRQ.
void
plic_complete(int irq)
{
    80005e7c:	1101                	addi	sp,sp,-32
    80005e7e:	ec06                	sd	ra,24(sp)
    80005e80:	e822                	sd	s0,16(sp)
    80005e82:	e426                	sd	s1,8(sp)
    80005e84:	1000                	addi	s0,sp,32
    80005e86:	84aa                	mv	s1,a0
  int hart = cpuid();
    80005e88:	ffffc097          	auipc	ra,0xffffc
    80005e8c:	af6080e7          	jalr	-1290(ra) # 8000197e <cpuid>
  *(uint32*)PLIC_SCLAIM(hart) = irq;
    80005e90:	00d5151b          	slliw	a0,a0,0xd
    80005e94:	0c2017b7          	lui	a5,0xc201
    80005e98:	97aa                	add	a5,a5,a0
    80005e9a:	c3c4                	sw	s1,4(a5)
}
    80005e9c:	60e2                	ld	ra,24(sp)
    80005e9e:	6442                	ld	s0,16(sp)
    80005ea0:	64a2                	ld	s1,8(sp)
    80005ea2:	6105                	addi	sp,sp,32
    80005ea4:	8082                	ret

0000000080005ea6 <free_desc>:
}

// mark a descriptor as free.
static void
free_desc(int i)
{
    80005ea6:	1141                	addi	sp,sp,-16
    80005ea8:	e406                	sd	ra,8(sp)
    80005eaa:	e022                	sd	s0,0(sp)
    80005eac:	0800                	addi	s0,sp,16
  if(i >= NUM)
    80005eae:	479d                	li	a5,7
    80005eb0:	06a7c963          	blt	a5,a0,80005f22 <free_desc+0x7c>
    panic("free_desc 1");
  if(disk.free[i])
    80005eb4:	00018797          	auipc	a5,0x18
    80005eb8:	14c78793          	addi	a5,a5,332 # 8001e000 <disk>
    80005ebc:	00a78733          	add	a4,a5,a0
    80005ec0:	6789                	lui	a5,0x2
    80005ec2:	97ba                	add	a5,a5,a4
    80005ec4:	0187c783          	lbu	a5,24(a5) # 2018 <_entry-0x7fffdfe8>
    80005ec8:	e7ad                	bnez	a5,80005f32 <free_desc+0x8c>
    panic("free_desc 2");
  disk.desc[i].addr = 0;
    80005eca:	00451793          	slli	a5,a0,0x4
    80005ece:	0001a717          	auipc	a4,0x1a
    80005ed2:	13270713          	addi	a4,a4,306 # 80020000 <disk+0x2000>
    80005ed6:	6314                	ld	a3,0(a4)
    80005ed8:	96be                	add	a3,a3,a5
    80005eda:	0006b023          	sd	zero,0(a3)
  disk.desc[i].len = 0;
    80005ede:	6314                	ld	a3,0(a4)
    80005ee0:	96be                	add	a3,a3,a5
    80005ee2:	0006a423          	sw	zero,8(a3)
  disk.desc[i].flags = 0;
    80005ee6:	6314                	ld	a3,0(a4)
    80005ee8:	96be                	add	a3,a3,a5
    80005eea:	00069623          	sh	zero,12(a3)
  disk.desc[i].next = 0;
    80005eee:	6318                	ld	a4,0(a4)
    80005ef0:	97ba                	add	a5,a5,a4
    80005ef2:	00079723          	sh	zero,14(a5)
  disk.free[i] = 1;
    80005ef6:	00018797          	auipc	a5,0x18
    80005efa:	10a78793          	addi	a5,a5,266 # 8001e000 <disk>
    80005efe:	97aa                	add	a5,a5,a0
    80005f00:	6509                	lui	a0,0x2
    80005f02:	953e                	add	a0,a0,a5
    80005f04:	4785                	li	a5,1
    80005f06:	00f50c23          	sb	a5,24(a0) # 2018 <_entry-0x7fffdfe8>
  wakeup(&disk.free[0]);
    80005f0a:	0001a517          	auipc	a0,0x1a
    80005f0e:	10e50513          	addi	a0,a0,270 # 80020018 <disk+0x2018>
    80005f12:	ffffc097          	auipc	ra,0xffffc
    80005f16:	42c080e7          	jalr	1068(ra) # 8000233e <wakeup>
}
    80005f1a:	60a2                	ld	ra,8(sp)
    80005f1c:	6402                	ld	s0,0(sp)
    80005f1e:	0141                	addi	sp,sp,16
    80005f20:	8082                	ret
    panic("free_desc 1");
    80005f22:	00003517          	auipc	a0,0x3
    80005f26:	82650513          	addi	a0,a0,-2010 # 80008748 <syscalls+0x328>
    80005f2a:	ffffa097          	auipc	ra,0xffffa
    80005f2e:	600080e7          	jalr	1536(ra) # 8000052a <panic>
    panic("free_desc 2");
    80005f32:	00003517          	auipc	a0,0x3
    80005f36:	82650513          	addi	a0,a0,-2010 # 80008758 <syscalls+0x338>
    80005f3a:	ffffa097          	auipc	ra,0xffffa
    80005f3e:	5f0080e7          	jalr	1520(ra) # 8000052a <panic>

0000000080005f42 <virtio_disk_init>:
{
    80005f42:	1101                	addi	sp,sp,-32
    80005f44:	ec06                	sd	ra,24(sp)
    80005f46:	e822                	sd	s0,16(sp)
    80005f48:	e426                	sd	s1,8(sp)
    80005f4a:	1000                	addi	s0,sp,32
  initlock(&disk.vdisk_lock, "virtio_disk");
    80005f4c:	00003597          	auipc	a1,0x3
    80005f50:	81c58593          	addi	a1,a1,-2020 # 80008768 <syscalls+0x348>
    80005f54:	0001a517          	auipc	a0,0x1a
    80005f58:	1d450513          	addi	a0,a0,468 # 80020128 <disk+0x2128>
    80005f5c:	ffffb097          	auipc	ra,0xffffb
    80005f60:	bd6080e7          	jalr	-1066(ra) # 80000b32 <initlock>
  if(*R(VIRTIO_MMIO_MAGIC_VALUE) != 0x74726976 ||
    80005f64:	100017b7          	lui	a5,0x10001
    80005f68:	4398                	lw	a4,0(a5)
    80005f6a:	2701                	sext.w	a4,a4
    80005f6c:	747277b7          	lui	a5,0x74727
    80005f70:	97678793          	addi	a5,a5,-1674 # 74726976 <_entry-0xb8d968a>
    80005f74:	0ef71163          	bne	a4,a5,80006056 <virtio_disk_init+0x114>
     *R(VIRTIO_MMIO_VERSION) != 1 ||
    80005f78:	100017b7          	lui	a5,0x10001
    80005f7c:	43dc                	lw	a5,4(a5)
    80005f7e:	2781                	sext.w	a5,a5
  if(*R(VIRTIO_MMIO_MAGIC_VALUE) != 0x74726976 ||
    80005f80:	4705                	li	a4,1
    80005f82:	0ce79a63          	bne	a5,a4,80006056 <virtio_disk_init+0x114>
     *R(VIRTIO_MMIO_DEVICE_ID) != 2 ||
    80005f86:	100017b7          	lui	a5,0x10001
    80005f8a:	479c                	lw	a5,8(a5)
    80005f8c:	2781                	sext.w	a5,a5
     *R(VIRTIO_MMIO_VERSION) != 1 ||
    80005f8e:	4709                	li	a4,2
    80005f90:	0ce79363          	bne	a5,a4,80006056 <virtio_disk_init+0x114>
     *R(VIRTIO_MMIO_VENDOR_ID) != 0x554d4551){
    80005f94:	100017b7          	lui	a5,0x10001
    80005f98:	47d8                	lw	a4,12(a5)
    80005f9a:	2701                	sext.w	a4,a4
     *R(VIRTIO_MMIO_DEVICE_ID) != 2 ||
    80005f9c:	554d47b7          	lui	a5,0x554d4
    80005fa0:	55178793          	addi	a5,a5,1361 # 554d4551 <_entry-0x2ab2baaf>
    80005fa4:	0af71963          	bne	a4,a5,80006056 <virtio_disk_init+0x114>
  *R(VIRTIO_MMIO_STATUS) = status;
    80005fa8:	100017b7          	lui	a5,0x10001
    80005fac:	4705                	li	a4,1
    80005fae:	dbb8                	sw	a4,112(a5)
  *R(VIRTIO_MMIO_STATUS) = status;
    80005fb0:	470d                	li	a4,3
    80005fb2:	dbb8                	sw	a4,112(a5)
  uint64 features = *R(VIRTIO_MMIO_DEVICE_FEATURES);
    80005fb4:	4b94                	lw	a3,16(a5)
  features &= ~(1 << VIRTIO_RING_F_INDIRECT_DESC);
    80005fb6:	c7ffe737          	lui	a4,0xc7ffe
    80005fba:	75f70713          	addi	a4,a4,1887 # ffffffffc7ffe75f <end+0xffffffff47fdd75f>
    80005fbe:	8f75                	and	a4,a4,a3
  *R(VIRTIO_MMIO_DRIVER_FEATURES) = features;
    80005fc0:	2701                	sext.w	a4,a4
    80005fc2:	d398                	sw	a4,32(a5)
  *R(VIRTIO_MMIO_STATUS) = status;
    80005fc4:	472d                	li	a4,11
    80005fc6:	dbb8                	sw	a4,112(a5)
  *R(VIRTIO_MMIO_STATUS) = status;
    80005fc8:	473d                	li	a4,15
    80005fca:	dbb8                	sw	a4,112(a5)
  *R(VIRTIO_MMIO_GUEST_PAGE_SIZE) = PGSIZE;
    80005fcc:	6705                	lui	a4,0x1
    80005fce:	d798                	sw	a4,40(a5)
  *R(VIRTIO_MMIO_QUEUE_SEL) = 0;
    80005fd0:	0207a823          	sw	zero,48(a5) # 10001030 <_entry-0x6fffefd0>
  uint32 max = *R(VIRTIO_MMIO_QUEUE_NUM_MAX);
    80005fd4:	5bdc                	lw	a5,52(a5)
    80005fd6:	2781                	sext.w	a5,a5
  if(max == 0)
    80005fd8:	c7d9                	beqz	a5,80006066 <virtio_disk_init+0x124>
  if(max < NUM)
    80005fda:	471d                	li	a4,7
    80005fdc:	08f77d63          	bgeu	a4,a5,80006076 <virtio_disk_init+0x134>
  *R(VIRTIO_MMIO_QUEUE_NUM) = NUM;
    80005fe0:	100014b7          	lui	s1,0x10001
    80005fe4:	47a1                	li	a5,8
    80005fe6:	dc9c                	sw	a5,56(s1)
  memset(disk.pages, 0, sizeof(disk.pages));
    80005fe8:	6609                	lui	a2,0x2
    80005fea:	4581                	li	a1,0
    80005fec:	00018517          	auipc	a0,0x18
    80005ff0:	01450513          	addi	a0,a0,20 # 8001e000 <disk>
    80005ff4:	ffffb097          	auipc	ra,0xffffb
    80005ff8:	cca080e7          	jalr	-822(ra) # 80000cbe <memset>
  *R(VIRTIO_MMIO_QUEUE_PFN) = ((uint64)disk.pages) >> PGSHIFT;
    80005ffc:	00018717          	auipc	a4,0x18
    80006000:	00470713          	addi	a4,a4,4 # 8001e000 <disk>
    80006004:	00c75793          	srli	a5,a4,0xc
    80006008:	2781                	sext.w	a5,a5
    8000600a:	c0bc                	sw	a5,64(s1)
  disk.desc = (struct virtq_desc *) disk.pages;
    8000600c:	0001a797          	auipc	a5,0x1a
    80006010:	ff478793          	addi	a5,a5,-12 # 80020000 <disk+0x2000>
    80006014:	e398                	sd	a4,0(a5)
  disk.avail = (struct virtq_avail *)(disk.pages + NUM*sizeof(struct virtq_desc));
    80006016:	00018717          	auipc	a4,0x18
    8000601a:	06a70713          	addi	a4,a4,106 # 8001e080 <disk+0x80>
    8000601e:	e798                	sd	a4,8(a5)
  disk.used = (struct virtq_used *) (disk.pages + PGSIZE);
    80006020:	00019717          	auipc	a4,0x19
    80006024:	fe070713          	addi	a4,a4,-32 # 8001f000 <disk+0x1000>
    80006028:	eb98                	sd	a4,16(a5)
    disk.free[i] = 1;
    8000602a:	4705                	li	a4,1
    8000602c:	00e78c23          	sb	a4,24(a5)
    80006030:	00e78ca3          	sb	a4,25(a5)
    80006034:	00e78d23          	sb	a4,26(a5)
    80006038:	00e78da3          	sb	a4,27(a5)
    8000603c:	00e78e23          	sb	a4,28(a5)
    80006040:	00e78ea3          	sb	a4,29(a5)
    80006044:	00e78f23          	sb	a4,30(a5)
    80006048:	00e78fa3          	sb	a4,31(a5)
}
    8000604c:	60e2                	ld	ra,24(sp)
    8000604e:	6442                	ld	s0,16(sp)
    80006050:	64a2                	ld	s1,8(sp)
    80006052:	6105                	addi	sp,sp,32
    80006054:	8082                	ret
    panic("could not find virtio disk");
    80006056:	00002517          	auipc	a0,0x2
    8000605a:	72250513          	addi	a0,a0,1826 # 80008778 <syscalls+0x358>
    8000605e:	ffffa097          	auipc	ra,0xffffa
    80006062:	4cc080e7          	jalr	1228(ra) # 8000052a <panic>
    panic("virtio disk has no queue 0");
    80006066:	00002517          	auipc	a0,0x2
    8000606a:	73250513          	addi	a0,a0,1842 # 80008798 <syscalls+0x378>
    8000606e:	ffffa097          	auipc	ra,0xffffa
    80006072:	4bc080e7          	jalr	1212(ra) # 8000052a <panic>
    panic("virtio disk max queue too short");
    80006076:	00002517          	auipc	a0,0x2
    8000607a:	74250513          	addi	a0,a0,1858 # 800087b8 <syscalls+0x398>
    8000607e:	ffffa097          	auipc	ra,0xffffa
    80006082:	4ac080e7          	jalr	1196(ra) # 8000052a <panic>

0000000080006086 <virtio_disk_rw>:
  return 0;
}

void
virtio_disk_rw(struct buf *b, int write)
{
    80006086:	7119                	addi	sp,sp,-128
    80006088:	fc86                	sd	ra,120(sp)
    8000608a:	f8a2                	sd	s0,112(sp)
    8000608c:	f4a6                	sd	s1,104(sp)
    8000608e:	f0ca                	sd	s2,96(sp)
    80006090:	ecce                	sd	s3,88(sp)
    80006092:	e8d2                	sd	s4,80(sp)
    80006094:	e4d6                	sd	s5,72(sp)
    80006096:	e0da                	sd	s6,64(sp)
    80006098:	fc5e                	sd	s7,56(sp)
    8000609a:	f862                	sd	s8,48(sp)
    8000609c:	f466                	sd	s9,40(sp)
    8000609e:	f06a                	sd	s10,32(sp)
    800060a0:	ec6e                	sd	s11,24(sp)
    800060a2:	0100                	addi	s0,sp,128
    800060a4:	8aaa                	mv	s5,a0
    800060a6:	8d2e                	mv	s10,a1
  uint64 sector = b->blockno * (BSIZE / 512);
    800060a8:	00c52c83          	lw	s9,12(a0)
    800060ac:	001c9c9b          	slliw	s9,s9,0x1
    800060b0:	1c82                	slli	s9,s9,0x20
    800060b2:	020cdc93          	srli	s9,s9,0x20

  acquire(&disk.vdisk_lock);
    800060b6:	0001a517          	auipc	a0,0x1a
    800060ba:	07250513          	addi	a0,a0,114 # 80020128 <disk+0x2128>
    800060be:	ffffb097          	auipc	ra,0xffffb
    800060c2:	b04080e7          	jalr	-1276(ra) # 80000bc2 <acquire>
  for(int i = 0; i < 3; i++){
    800060c6:	4981                	li	s3,0
  for(int i = 0; i < NUM; i++){
    800060c8:	44a1                	li	s1,8
      disk.free[i] = 0;
    800060ca:	00018c17          	auipc	s8,0x18
    800060ce:	f36c0c13          	addi	s8,s8,-202 # 8001e000 <disk>
    800060d2:	6b89                	lui	s7,0x2
  for(int i = 0; i < 3; i++){
    800060d4:	4b0d                	li	s6,3
    800060d6:	a0ad                	j	80006140 <virtio_disk_rw+0xba>
      disk.free[i] = 0;
    800060d8:	00fc0733          	add	a4,s8,a5
    800060dc:	975e                	add	a4,a4,s7
    800060de:	00070c23          	sb	zero,24(a4)
    idx[i] = alloc_desc();
    800060e2:	c19c                	sw	a5,0(a1)
    if(idx[i] < 0){
    800060e4:	0207c563          	bltz	a5,8000610e <virtio_disk_rw+0x88>
  for(int i = 0; i < 3; i++){
    800060e8:	2905                	addiw	s2,s2,1
    800060ea:	0611                	addi	a2,a2,4
    800060ec:	19690d63          	beq	s2,s6,80006286 <virtio_disk_rw+0x200>
    idx[i] = alloc_desc();
    800060f0:	85b2                	mv	a1,a2
  for(int i = 0; i < NUM; i++){
    800060f2:	0001a717          	auipc	a4,0x1a
    800060f6:	f2670713          	addi	a4,a4,-218 # 80020018 <disk+0x2018>
    800060fa:	87ce                	mv	a5,s3
    if(disk.free[i]){
    800060fc:	00074683          	lbu	a3,0(a4)
    80006100:	fee1                	bnez	a3,800060d8 <virtio_disk_rw+0x52>
  for(int i = 0; i < NUM; i++){
    80006102:	2785                	addiw	a5,a5,1
    80006104:	0705                	addi	a4,a4,1
    80006106:	fe979be3          	bne	a5,s1,800060fc <virtio_disk_rw+0x76>
    idx[i] = alloc_desc();
    8000610a:	57fd                	li	a5,-1
    8000610c:	c19c                	sw	a5,0(a1)
      for(int j = 0; j < i; j++)
    8000610e:	01205d63          	blez	s2,80006128 <virtio_disk_rw+0xa2>
    80006112:	8dce                	mv	s11,s3
        free_desc(idx[j]);
    80006114:	000a2503          	lw	a0,0(s4)
    80006118:	00000097          	auipc	ra,0x0
    8000611c:	d8e080e7          	jalr	-626(ra) # 80005ea6 <free_desc>
      for(int j = 0; j < i; j++)
    80006120:	2d85                	addiw	s11,s11,1
    80006122:	0a11                	addi	s4,s4,4
    80006124:	ffb918e3          	bne	s2,s11,80006114 <virtio_disk_rw+0x8e>
  int idx[3];
  while(1){
    if(alloc3_desc(idx) == 0) {
      break;
    }
    sleep(&disk.free[0], &disk.vdisk_lock);
    80006128:	0001a597          	auipc	a1,0x1a
    8000612c:	00058593          	mv	a1,a1
    80006130:	0001a517          	auipc	a0,0x1a
    80006134:	ee850513          	addi	a0,a0,-280 # 80020018 <disk+0x2018>
    80006138:	ffffc097          	auipc	ra,0xffffc
    8000613c:	086080e7          	jalr	134(ra) # 800021be <sleep>
  for(int i = 0; i < 3; i++){
    80006140:	f8040a13          	addi	s4,s0,-128
{
    80006144:	8652                	mv	a2,s4
  for(int i = 0; i < 3; i++){
    80006146:	894e                	mv	s2,s3
    80006148:	b765                	j	800060f0 <virtio_disk_rw+0x6a>
  disk.desc[idx[0]].next = idx[1];

  disk.desc[idx[1]].addr = (uint64) b->data;
  disk.desc[idx[1]].len = BSIZE;
  if(write)
    disk.desc[idx[1]].flags = 0; // device reads b->data
    8000614a:	0001a697          	auipc	a3,0x1a
    8000614e:	eb66b683          	ld	a3,-330(a3) # 80020000 <disk+0x2000>
    80006152:	96ba                	add	a3,a3,a4
    80006154:	00069623          	sh	zero,12(a3)
  else
    disk.desc[idx[1]].flags = VRING_DESC_F_WRITE; // device writes b->data
  disk.desc[idx[1]].flags |= VRING_DESC_F_NEXT;
    80006158:	00018817          	auipc	a6,0x18
    8000615c:	ea880813          	addi	a6,a6,-344 # 8001e000 <disk>
    80006160:	0001a697          	auipc	a3,0x1a
    80006164:	ea068693          	addi	a3,a3,-352 # 80020000 <disk+0x2000>
    80006168:	6290                	ld	a2,0(a3)
    8000616a:	963a                	add	a2,a2,a4
    8000616c:	00c65583          	lhu	a1,12(a2) # 200c <_entry-0x7fffdff4>
    80006170:	0015e593          	ori	a1,a1,1
    80006174:	00b61623          	sh	a1,12(a2)
  disk.desc[idx[1]].next = idx[2];
    80006178:	f8842603          	lw	a2,-120(s0)
    8000617c:	628c                	ld	a1,0(a3)
    8000617e:	972e                	add	a4,a4,a1
    80006180:	00c71723          	sh	a2,14(a4)

  disk.info[idx[0]].status = 0xff; // device writes 0 on success
    80006184:	20050593          	addi	a1,a0,512
    80006188:	0592                	slli	a1,a1,0x4
    8000618a:	95c2                	add	a1,a1,a6
    8000618c:	577d                	li	a4,-1
    8000618e:	02e58823          	sb	a4,48(a1) # 80020158 <disk+0x2158>
  disk.desc[idx[2]].addr = (uint64) &disk.info[idx[0]].status;
    80006192:	00461713          	slli	a4,a2,0x4
    80006196:	6290                	ld	a2,0(a3)
    80006198:	963a                	add	a2,a2,a4
    8000619a:	03078793          	addi	a5,a5,48
    8000619e:	97c2                	add	a5,a5,a6
    800061a0:	e21c                	sd	a5,0(a2)
  disk.desc[idx[2]].len = 1;
    800061a2:	629c                	ld	a5,0(a3)
    800061a4:	97ba                	add	a5,a5,a4
    800061a6:	4605                	li	a2,1
    800061a8:	c790                	sw	a2,8(a5)
  disk.desc[idx[2]].flags = VRING_DESC_F_WRITE; // device writes the status
    800061aa:	629c                	ld	a5,0(a3)
    800061ac:	97ba                	add	a5,a5,a4
    800061ae:	4809                	li	a6,2
    800061b0:	01079623          	sh	a6,12(a5)
  disk.desc[idx[2]].next = 0;
    800061b4:	629c                	ld	a5,0(a3)
    800061b6:	973e                	add	a4,a4,a5
    800061b8:	00071723          	sh	zero,14(a4)

  // record struct buf for virtio_disk_intr().
  b->disk = 1;
    800061bc:	00caa223          	sw	a2,4(s5)
  disk.info[idx[0]].b = b;
    800061c0:	0355b423          	sd	s5,40(a1)

  // tell the device the first index in our chain of descriptors.
  disk.avail->ring[disk.avail->idx % NUM] = idx[0];
    800061c4:	6698                	ld	a4,8(a3)
    800061c6:	00275783          	lhu	a5,2(a4)
    800061ca:	8b9d                	andi	a5,a5,7
    800061cc:	0786                	slli	a5,a5,0x1
    800061ce:	97ba                	add	a5,a5,a4
    800061d0:	00a79223          	sh	a0,4(a5)

  __sync_synchronize();
    800061d4:	0ff0000f          	fence

  // tell the device another avail ring entry is available.
  disk.avail->idx += 1; // not % NUM ...
    800061d8:	6698                	ld	a4,8(a3)
    800061da:	00275783          	lhu	a5,2(a4)
    800061de:	2785                	addiw	a5,a5,1
    800061e0:	00f71123          	sh	a5,2(a4)

  __sync_synchronize();
    800061e4:	0ff0000f          	fence

  *R(VIRTIO_MMIO_QUEUE_NOTIFY) = 0; // value is queue number
    800061e8:	100017b7          	lui	a5,0x10001
    800061ec:	0407a823          	sw	zero,80(a5) # 10001050 <_entry-0x6fffefb0>

  // Wait for virtio_disk_intr() to say request has finished.
  while(b->disk == 1) {
    800061f0:	004aa783          	lw	a5,4(s5)
    800061f4:	02c79163          	bne	a5,a2,80006216 <virtio_disk_rw+0x190>
    sleep(b, &disk.vdisk_lock);
    800061f8:	0001a917          	auipc	s2,0x1a
    800061fc:	f3090913          	addi	s2,s2,-208 # 80020128 <disk+0x2128>
  while(b->disk == 1) {
    80006200:	4485                	li	s1,1
    sleep(b, &disk.vdisk_lock);
    80006202:	85ca                	mv	a1,s2
    80006204:	8556                	mv	a0,s5
    80006206:	ffffc097          	auipc	ra,0xffffc
    8000620a:	fb8080e7          	jalr	-72(ra) # 800021be <sleep>
  while(b->disk == 1) {
    8000620e:	004aa783          	lw	a5,4(s5)
    80006212:	fe9788e3          	beq	a5,s1,80006202 <virtio_disk_rw+0x17c>
  }

  disk.info[idx[0]].b = 0;
    80006216:	f8042903          	lw	s2,-128(s0)
    8000621a:	20090793          	addi	a5,s2,512
    8000621e:	00479713          	slli	a4,a5,0x4
    80006222:	00018797          	auipc	a5,0x18
    80006226:	dde78793          	addi	a5,a5,-546 # 8001e000 <disk>
    8000622a:	97ba                	add	a5,a5,a4
    8000622c:	0207b423          	sd	zero,40(a5)
    int flag = disk.desc[i].flags;
    80006230:	0001a997          	auipc	s3,0x1a
    80006234:	dd098993          	addi	s3,s3,-560 # 80020000 <disk+0x2000>
    80006238:	00491713          	slli	a4,s2,0x4
    8000623c:	0009b783          	ld	a5,0(s3)
    80006240:	97ba                	add	a5,a5,a4
    80006242:	00c7d483          	lhu	s1,12(a5)
    int nxt = disk.desc[i].next;
    80006246:	854a                	mv	a0,s2
    80006248:	00e7d903          	lhu	s2,14(a5)
    free_desc(i);
    8000624c:	00000097          	auipc	ra,0x0
    80006250:	c5a080e7          	jalr	-934(ra) # 80005ea6 <free_desc>
    if(flag & VRING_DESC_F_NEXT)
    80006254:	8885                	andi	s1,s1,1
    80006256:	f0ed                	bnez	s1,80006238 <virtio_disk_rw+0x1b2>
  free_chain(idx[0]);

  release(&disk.vdisk_lock);
    80006258:	0001a517          	auipc	a0,0x1a
    8000625c:	ed050513          	addi	a0,a0,-304 # 80020128 <disk+0x2128>
    80006260:	ffffb097          	auipc	ra,0xffffb
    80006264:	a16080e7          	jalr	-1514(ra) # 80000c76 <release>
}
    80006268:	70e6                	ld	ra,120(sp)
    8000626a:	7446                	ld	s0,112(sp)
    8000626c:	74a6                	ld	s1,104(sp)
    8000626e:	7906                	ld	s2,96(sp)
    80006270:	69e6                	ld	s3,88(sp)
    80006272:	6a46                	ld	s4,80(sp)
    80006274:	6aa6                	ld	s5,72(sp)
    80006276:	6b06                	ld	s6,64(sp)
    80006278:	7be2                	ld	s7,56(sp)
    8000627a:	7c42                	ld	s8,48(sp)
    8000627c:	7ca2                	ld	s9,40(sp)
    8000627e:	7d02                	ld	s10,32(sp)
    80006280:	6de2                	ld	s11,24(sp)
    80006282:	6109                	addi	sp,sp,128
    80006284:	8082                	ret
  struct virtio_blk_req *buf0 = &disk.ops[idx[0]];
    80006286:	f8042503          	lw	a0,-128(s0)
    8000628a:	20050793          	addi	a5,a0,512
    8000628e:	0792                	slli	a5,a5,0x4
  if(write)
    80006290:	00018817          	auipc	a6,0x18
    80006294:	d7080813          	addi	a6,a6,-656 # 8001e000 <disk>
    80006298:	00f80733          	add	a4,a6,a5
    8000629c:	01a036b3          	snez	a3,s10
    800062a0:	0ad72423          	sw	a3,168(a4)
  buf0->reserved = 0;
    800062a4:	0a072623          	sw	zero,172(a4)
  buf0->sector = sector;
    800062a8:	0b973823          	sd	s9,176(a4)
  disk.desc[idx[0]].addr = (uint64) buf0;
    800062ac:	7679                	lui	a2,0xffffe
    800062ae:	963e                	add	a2,a2,a5
    800062b0:	0001a697          	auipc	a3,0x1a
    800062b4:	d5068693          	addi	a3,a3,-688 # 80020000 <disk+0x2000>
    800062b8:	6298                	ld	a4,0(a3)
    800062ba:	9732                	add	a4,a4,a2
  struct virtio_blk_req *buf0 = &disk.ops[idx[0]];
    800062bc:	0a878593          	addi	a1,a5,168
    800062c0:	95c2                	add	a1,a1,a6
  disk.desc[idx[0]].addr = (uint64) buf0;
    800062c2:	e30c                	sd	a1,0(a4)
  disk.desc[idx[0]].len = sizeof(struct virtio_blk_req);
    800062c4:	6298                	ld	a4,0(a3)
    800062c6:	9732                	add	a4,a4,a2
    800062c8:	45c1                	li	a1,16
    800062ca:	c70c                	sw	a1,8(a4)
  disk.desc[idx[0]].flags = VRING_DESC_F_NEXT;
    800062cc:	6298                	ld	a4,0(a3)
    800062ce:	9732                	add	a4,a4,a2
    800062d0:	4585                	li	a1,1
    800062d2:	00b71623          	sh	a1,12(a4)
  disk.desc[idx[0]].next = idx[1];
    800062d6:	f8442703          	lw	a4,-124(s0)
    800062da:	628c                	ld	a1,0(a3)
    800062dc:	962e                	add	a2,a2,a1
    800062de:	00e61723          	sh	a4,14(a2) # ffffffffffffe00e <end+0xffffffff7ffdd00e>
  disk.desc[idx[1]].addr = (uint64) b->data;
    800062e2:	0712                	slli	a4,a4,0x4
    800062e4:	6290                	ld	a2,0(a3)
    800062e6:	963a                	add	a2,a2,a4
    800062e8:	058a8593          	addi	a1,s5,88
    800062ec:	e20c                	sd	a1,0(a2)
  disk.desc[idx[1]].len = BSIZE;
    800062ee:	6294                	ld	a3,0(a3)
    800062f0:	96ba                	add	a3,a3,a4
    800062f2:	40000613          	li	a2,1024
    800062f6:	c690                	sw	a2,8(a3)
  if(write)
    800062f8:	e40d19e3          	bnez	s10,8000614a <virtio_disk_rw+0xc4>
    disk.desc[idx[1]].flags = VRING_DESC_F_WRITE; // device writes b->data
    800062fc:	0001a697          	auipc	a3,0x1a
    80006300:	d046b683          	ld	a3,-764(a3) # 80020000 <disk+0x2000>
    80006304:	96ba                	add	a3,a3,a4
    80006306:	4609                	li	a2,2
    80006308:	00c69623          	sh	a2,12(a3)
    8000630c:	b5b1                	j	80006158 <virtio_disk_rw+0xd2>

000000008000630e <virtio_disk_intr>:

void
virtio_disk_intr()
{
    8000630e:	1101                	addi	sp,sp,-32
    80006310:	ec06                	sd	ra,24(sp)
    80006312:	e822                	sd	s0,16(sp)
    80006314:	e426                	sd	s1,8(sp)
    80006316:	e04a                	sd	s2,0(sp)
    80006318:	1000                	addi	s0,sp,32
  acquire(&disk.vdisk_lock);
    8000631a:	0001a517          	auipc	a0,0x1a
    8000631e:	e0e50513          	addi	a0,a0,-498 # 80020128 <disk+0x2128>
    80006322:	ffffb097          	auipc	ra,0xffffb
    80006326:	8a0080e7          	jalr	-1888(ra) # 80000bc2 <acquire>
  // we've seen this interrupt, which the following line does.
  // this may race with the device writing new entries to
  // the "used" ring, in which case we may process the new
  // completion entries in this interrupt, and have nothing to do
  // in the next interrupt, which is harmless.
  *R(VIRTIO_MMIO_INTERRUPT_ACK) = *R(VIRTIO_MMIO_INTERRUPT_STATUS) & 0x3;
    8000632a:	10001737          	lui	a4,0x10001
    8000632e:	533c                	lw	a5,96(a4)
    80006330:	8b8d                	andi	a5,a5,3
    80006332:	d37c                	sw	a5,100(a4)

  __sync_synchronize();
    80006334:	0ff0000f          	fence

  // the device increments disk.used->idx when it
  // adds an entry to the used ring.

  while(disk.used_idx != disk.used->idx){
    80006338:	0001a797          	auipc	a5,0x1a
    8000633c:	cc878793          	addi	a5,a5,-824 # 80020000 <disk+0x2000>
    80006340:	6b94                	ld	a3,16(a5)
    80006342:	0207d703          	lhu	a4,32(a5)
    80006346:	0026d783          	lhu	a5,2(a3)
    8000634a:	06f70163          	beq	a4,a5,800063ac <virtio_disk_intr+0x9e>
    __sync_synchronize();
    int id = disk.used->ring[disk.used_idx % NUM].id;
    8000634e:	00018917          	auipc	s2,0x18
    80006352:	cb290913          	addi	s2,s2,-846 # 8001e000 <disk>
    80006356:	0001a497          	auipc	s1,0x1a
    8000635a:	caa48493          	addi	s1,s1,-854 # 80020000 <disk+0x2000>
    __sync_synchronize();
    8000635e:	0ff0000f          	fence
    int id = disk.used->ring[disk.used_idx % NUM].id;
    80006362:	6898                	ld	a4,16(s1)
    80006364:	0204d783          	lhu	a5,32(s1)
    80006368:	8b9d                	andi	a5,a5,7
    8000636a:	078e                	slli	a5,a5,0x3
    8000636c:	97ba                	add	a5,a5,a4
    8000636e:	43dc                	lw	a5,4(a5)

    if(disk.info[id].status != 0)
    80006370:	20078713          	addi	a4,a5,512
    80006374:	0712                	slli	a4,a4,0x4
    80006376:	974a                	add	a4,a4,s2
    80006378:	03074703          	lbu	a4,48(a4) # 10001030 <_entry-0x6fffefd0>
    8000637c:	e731                	bnez	a4,800063c8 <virtio_disk_intr+0xba>
      panic("virtio_disk_intr status");

    struct buf *b = disk.info[id].b;
    8000637e:	20078793          	addi	a5,a5,512
    80006382:	0792                	slli	a5,a5,0x4
    80006384:	97ca                	add	a5,a5,s2
    80006386:	7788                	ld	a0,40(a5)
    b->disk = 0;   // disk is done with buf
    80006388:	00052223          	sw	zero,4(a0)
    wakeup(b);
    8000638c:	ffffc097          	auipc	ra,0xffffc
    80006390:	fb2080e7          	jalr	-78(ra) # 8000233e <wakeup>

    disk.used_idx += 1;
    80006394:	0204d783          	lhu	a5,32(s1)
    80006398:	2785                	addiw	a5,a5,1
    8000639a:	17c2                	slli	a5,a5,0x30
    8000639c:	93c1                	srli	a5,a5,0x30
    8000639e:	02f49023          	sh	a5,32(s1)
  while(disk.used_idx != disk.used->idx){
    800063a2:	6898                	ld	a4,16(s1)
    800063a4:	00275703          	lhu	a4,2(a4)
    800063a8:	faf71be3          	bne	a4,a5,8000635e <virtio_disk_intr+0x50>
  }

  release(&disk.vdisk_lock);
    800063ac:	0001a517          	auipc	a0,0x1a
    800063b0:	d7c50513          	addi	a0,a0,-644 # 80020128 <disk+0x2128>
    800063b4:	ffffb097          	auipc	ra,0xffffb
    800063b8:	8c2080e7          	jalr	-1854(ra) # 80000c76 <release>
}
    800063bc:	60e2                	ld	ra,24(sp)
    800063be:	6442                	ld	s0,16(sp)
    800063c0:	64a2                	ld	s1,8(sp)
    800063c2:	6902                	ld	s2,0(sp)
    800063c4:	6105                	addi	sp,sp,32
    800063c6:	8082                	ret
      panic("virtio_disk_intr status");
    800063c8:	00002517          	auipc	a0,0x2
    800063cc:	41050513          	addi	a0,a0,1040 # 800087d8 <syscalls+0x3b8>
    800063d0:	ffffa097          	auipc	ra,0xffffa
    800063d4:	15a080e7          	jalr	346(ra) # 8000052a <panic>
	...

0000000080007000 <_trampoline>:
    80007000:	14051573          	csrrw	a0,sscratch,a0
    80007004:	02153423          	sd	ra,40(a0)
    80007008:	02253823          	sd	sp,48(a0)
    8000700c:	02353c23          	sd	gp,56(a0)
    80007010:	04453023          	sd	tp,64(a0)
    80007014:	04553423          	sd	t0,72(a0)
    80007018:	04653823          	sd	t1,80(a0)
    8000701c:	04753c23          	sd	t2,88(a0)
    80007020:	f120                	sd	s0,96(a0)
    80007022:	f524                	sd	s1,104(a0)
    80007024:	fd2c                	sd	a1,120(a0)
    80007026:	e150                	sd	a2,128(a0)
    80007028:	e554                	sd	a3,136(a0)
    8000702a:	e958                	sd	a4,144(a0)
    8000702c:	ed5c                	sd	a5,152(a0)
    8000702e:	0b053023          	sd	a6,160(a0)
    80007032:	0b153423          	sd	a7,168(a0)
    80007036:	0b253823          	sd	s2,176(a0)
    8000703a:	0b353c23          	sd	s3,184(a0)
    8000703e:	0d453023          	sd	s4,192(a0)
    80007042:	0d553423          	sd	s5,200(a0)
    80007046:	0d653823          	sd	s6,208(a0)
    8000704a:	0d753c23          	sd	s7,216(a0)
    8000704e:	0f853023          	sd	s8,224(a0)
    80007052:	0f953423          	sd	s9,232(a0)
    80007056:	0fa53823          	sd	s10,240(a0)
    8000705a:	0fb53c23          	sd	s11,248(a0)
    8000705e:	11c53023          	sd	t3,256(a0)
    80007062:	11d53423          	sd	t4,264(a0)
    80007066:	11e53823          	sd	t5,272(a0)
    8000706a:	11f53c23          	sd	t6,280(a0)
    8000706e:	140022f3          	csrr	t0,sscratch
    80007072:	06553823          	sd	t0,112(a0)
    80007076:	00853103          	ld	sp,8(a0)
    8000707a:	02053203          	ld	tp,32(a0)
    8000707e:	01053283          	ld	t0,16(a0)
    80007082:	00053303          	ld	t1,0(a0)
    80007086:	18031073          	csrw	satp,t1
    8000708a:	12000073          	sfence.vma
    8000708e:	8282                	jr	t0

0000000080007090 <userret>:
    80007090:	18059073          	csrw	satp,a1
    80007094:	12000073          	sfence.vma
    80007098:	07053283          	ld	t0,112(a0)
    8000709c:	14029073          	csrw	sscratch,t0
    800070a0:	02853083          	ld	ra,40(a0)
    800070a4:	03053103          	ld	sp,48(a0)
    800070a8:	03853183          	ld	gp,56(a0)
    800070ac:	04053203          	ld	tp,64(a0)
    800070b0:	04853283          	ld	t0,72(a0)
    800070b4:	05053303          	ld	t1,80(a0)
    800070b8:	05853383          	ld	t2,88(a0)
    800070bc:	7120                	ld	s0,96(a0)
    800070be:	7524                	ld	s1,104(a0)
    800070c0:	7d2c                	ld	a1,120(a0)
    800070c2:	6150                	ld	a2,128(a0)
    800070c4:	6554                	ld	a3,136(a0)
    800070c6:	6958                	ld	a4,144(a0)
    800070c8:	6d5c                	ld	a5,152(a0)
    800070ca:	0a053803          	ld	a6,160(a0)
    800070ce:	0a853883          	ld	a7,168(a0)
    800070d2:	0b053903          	ld	s2,176(a0)
    800070d6:	0b853983          	ld	s3,184(a0)
    800070da:	0c053a03          	ld	s4,192(a0)
    800070de:	0c853a83          	ld	s5,200(a0)
    800070e2:	0d053b03          	ld	s6,208(a0)
    800070e6:	0d853b83          	ld	s7,216(a0)
    800070ea:	0e053c03          	ld	s8,224(a0)
    800070ee:	0e853c83          	ld	s9,232(a0)
    800070f2:	0f053d03          	ld	s10,240(a0)
    800070f6:	0f853d83          	ld	s11,248(a0)
    800070fa:	10053e03          	ld	t3,256(a0)
    800070fe:	10853e83          	ld	t4,264(a0)
    80007102:	11053f03          	ld	t5,272(a0)
    80007106:	11853f83          	ld	t6,280(a0)
    8000710a:	14051573          	csrrw	a0,sscratch,a0
    8000710e:	10200073          	sret
	...
