
.text




.code 32

.type mul_1x1_ialu,%function
.align 5
mul_1x1_ialu:
 mov r4,#0
 bic r5,r1,#3<<30 @ a1=a&0x3fffffff
 str r4,[sp,#0] @ tab[0]=0
 add r6,r5,r5 @ a2=a1<<1
 str r5,[sp,#4] @ tab[1]=a1
 eor r7,r5,r6 @ a1^a2
 str r6,[sp,#8] @ tab[2]=a2
 mov r8,r5,lsl#2 @ a4=a1<<2
 str r7,[sp,#12] @ tab[3]=a1^a2
 eor r9,r5,r8 @ a1^a4
 str r8,[sp,#16] @ tab[4]=a4
 eor r4,r6,r8 @ a2^a4
 str r9,[sp,#20] @ tab[5]=a1^a4
 eor r7,r7,r8 @ a1^a2^a4
 str r4,[sp,#24] @ tab[6]=a2^a4
 and r8,r12,r0,lsl#2
 str r7,[sp,#28] @ tab[7]=a1^a2^a4

 and r9,r12,r0,lsr#1
 ldr r5,[sp,r8] @ tab[b & 0x7]
 and r8,r12,r0,lsr#4
 ldr r7,[sp,r9] @ tab[b >> 3 & 0x7]
 and r9,r12,r0,lsr#7
 ldr r6,[sp,r8] @ tab[b >> 6 & 0x7]
 eor r5,r5,r7,lsl#3 @ stall
 mov r4,r7,lsr#29
 ldr r7,[sp,r9] @ tab[b >> 9 & 0x7]

 and r8,r12,r0,lsr#10
 eor r5,r5,r6,lsl#6
 eor r4,r4,r6,lsr#26
 ldr r6,[sp,r8] @ tab[b >> 12 & 0x7]

 and r9,r12,r0,lsr#13
 eor r5,r5,r7,lsl#9
 eor r4,r4,r7,lsr#23
 ldr r7,[sp,r9] @ tab[b >> 15 & 0x7]

 and r8,r12,r0,lsr#16
 eor r5,r5,r6,lsl#12
 eor r4,r4,r6,lsr#20
 ldr r6,[sp,r8] @ tab[b >> 18 & 0x7]

 and r9,r12,r0,lsr#19
 eor r5,r5,r7,lsl#15
 eor r4,r4,r7,lsr#17
 ldr r7,[sp,r9] @ tab[b >> 21 & 0x7]

 and r8,r12,r0,lsr#22
 eor r5,r5,r6,lsl#18
 eor r4,r4,r6,lsr#14
 ldr r6,[sp,r8] @ tab[b >> 24 & 0x7]

 and r9,r12,r0,lsr#25
 eor r5,r5,r7,lsl#21
 eor r4,r4,r7,lsr#11
 ldr r7,[sp,r9] @ tab[b >> 27 & 0x7]

 tst r1,#1<<30
 and r8,r12,r0,lsr#28
 eor r5,r5,r6,lsl#24
 eor r4,r4,r6,lsr#8
 ldr r6,[sp,r8] @ tab[b >> 30 ]




 eorne r5,r5,r0,lsl#30
 eorne r4,r4,r0,lsr#2
 tst r1,#1<<31
 eor r5,r5,r7,lsl#27
 eor r4,r4,r7,lsr#5



 eorne r5,r5,r0,lsl#31
 eorne r4,r4,r0,lsr#1
 eor r5,r5,r6,lsl#30
 eor r4,r4,r6,lsr#2

 mov pc,lr
.size mul_1x1_ialu,.-mul_1x1_ialu
.globl bn_GF2m_mul_2x2
.type bn_GF2m_mul_2x2,%function
.align 5
bn_GF2m_mul_2x2:
 stmdb sp!,{r4,r5,r6,r7,r8,r9,r10,lr}

 mov r10,r0 @ reassign 1st argument
 mov r0,r3 @ r0=b1
 sub r7,sp,#36
 mov r8,sp
 and r7,r7,#-32
 ldr r3,[sp,#32] @ load b0
 mov r12,#7<<2
 mov sp,r7 @ allocate tab[8]
 str r8,[r7,#32]

 bl mul_1x1_ialu @ a1·b1
 str r5,[r10,#8]
 str r4,[r10,#12]

 eor r0,r0,r3 @ flip b0 and b1
 eor r1,r1,r2 @ flip a0 and a1
 eor r3,r3,r0
 eor r2,r2,r1
 eor r0,r0,r3
 eor r1,r1,r2
 bl mul_1x1_ialu @ a0·b0
 str r5,[r10]
 str r4,[r10,#4]

 eor r1,r1,r2
 eor r0,r0,r3
 bl mul_1x1_ialu @ (a1+a0)·(b1+b0)
 ldmia r10,{r6,r7,r8,r9}
 eor r5,r5,r4
 ldr sp,[sp,#32] @ destroy tab[8]
 eor r4,r4,r7
 eor r5,r5,r6
 eor r4,r4,r8
 eor r5,r5,r9
 eor r4,r4,r9
 str r4,[r10,#8]
 eor r5,r5,r4
 str r5,[r10,#4]




 ldmia sp!,{r4,r5,r6,r7,r8,r9,r10,lr}
 tst lr,#1
 moveq pc,lr @ be binary compatible with V4, yet
.word 0xe12fff1e @ interoperable with Thumb ISA:-)
.size bn_GF2m_mul_2x2,.-bn_GF2m_mul_2x2





.byte 71,70,40,50,94,109,41,32,77,117,108,116,105,112,108,105,99,97,116,105,111,110,32,102,111,114,32,65,82,77,118,52,47,78,69,79,78,44,32,67,82,89,80,84,79,71,65,77,83,32,98,121,32,60,97,112,112,114,111,64,111,112,101,110,115,115,108,46,111,114,103,62,0
.align 2
.align 5
