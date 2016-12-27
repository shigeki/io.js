
.text




.code 32


.globl poly1305_emit
.globl poly1305_blocks
.globl poly1305_init
.type poly1305_init,%function
.align 5
poly1305_init:
.Lpoly1305_init:
 stmdb sp!,{r4,r5,r6,r7,r8,r9,r10,r11}

 eor r3,r3,r3
 cmp r1,#0
 str r3,[r0,#0] @ zero hash value
 str r3,[r0,#4]
 str r3,[r0,#8]
 str r3,[r0,#12]
 str r3,[r0,#16]
 str r3,[r0,#36] @ is_base2_26
 add r0,r0,#20




 moveq r0,#0
 beq .Lno_key





 ldrb r4,[r1,#0]
 mov r10,#0x0fffffff
 ldrb r5,[r1,#1]
 and r3,r10,#-4 @ 0x0ffffffc
 ldrb r6,[r1,#2]
 ldrb r7,[r1,#3]
 orr r4,r4,r5,lsl#8
 ldrb r5,[r1,#4]
 orr r4,r4,r6,lsl#16
 ldrb r6,[r1,#5]
 orr r4,r4,r7,lsl#24
 ldrb r7,[r1,#6]
 and r4,r4,r10







 ldrb r8,[r1,#7]
 orr r5,r5,r6,lsl#8
 ldrb r6,[r1,#8]
 orr r5,r5,r7,lsl#16
 ldrb r7,[r1,#9]
 orr r5,r5,r8,lsl#24
 ldrb r8,[r1,#10]
 and r5,r5,r3
 ldrb r9,[r1,#11]
 orr r6,r6,r7,lsl#8
 ldrb r7,[r1,#12]
 orr r6,r6,r8,lsl#16
 ldrb r8,[r1,#13]
 orr r6,r6,r9,lsl#24
 ldrb r9,[r1,#14]
 and r6,r6,r3

 ldrb r10,[r1,#15]
 orr r7,r7,r8,lsl#8
 str r4,[r0,#0]
 orr r7,r7,r9,lsl#16
 str r5,[r0,#4]
 orr r7,r7,r10,lsl#24
 str r6,[r0,#8]
 and r7,r7,r3
 str r7,[r0,#12]




 mov r0,#0

.Lno_key:
 ldmia sp!,{r4,r5,r6,r7,r8,r9,r10,r11}



 tst lr,#1
 moveq pc,lr @ be binary compatible with V4, yet
.word 0xe12fff1e @ interoperable with Thumb ISA:-)

.size poly1305_init,.-poly1305_init
.type poly1305_blocks,%function
.align 5
poly1305_blocks:
 stmdb sp!,{r3,r4,r5,r6,r7,r8,r9,r10,r11,lr}

 ands r2,r2,#-16
 beq .Lno_data

 cmp r3,#0
 add r2,r2,r1 @ end pointer
 sub sp,sp,#32

 ldmia r0,{r4,r5,r6,r7,r8,r9,r10,r11,r12} @ load context

 str r0,[sp,#12] @ offload stuff
 mov lr,r1
 str r2,[sp,#16]
 str r10,[sp,#20]
 str r11,[sp,#24]
 str r12,[sp,#28]
 b .Loop

.Loop:

 ldrb r0,[lr],#16 @ load input



 addhi r8,r8,#1 @ 1<<128
 ldrb r1,[lr,#-15]
 ldrb r2,[lr,#-14]
 ldrb r3,[lr,#-13]
 orr r1,r0,r1,lsl#8
 ldrb r0,[lr,#-12]
 orr r2,r1,r2,lsl#16
 ldrb r1,[lr,#-11]
 orr r3,r2,r3,lsl#24
 ldrb r2,[lr,#-10]
 adds r4,r4,r3 @ accumulate input

 ldrb r3,[lr,#-9]
 orr r1,r0,r1,lsl#8
 ldrb r0,[lr,#-8]
 orr r2,r1,r2,lsl#16
 ldrb r1,[lr,#-7]
 orr r3,r2,r3,lsl#24
 ldrb r2,[lr,#-6]
 adcs r5,r5,r3

 ldrb r3,[lr,#-5]
 orr r1,r0,r1,lsl#8
 ldrb r0,[lr,#-4]
 orr r2,r1,r2,lsl#16
 ldrb r1,[lr,#-3]
 orr r3,r2,r3,lsl#24
 ldrb r2,[lr,#-2]
 adcs r6,r6,r3

 ldrb r3,[lr,#-1]
 orr r1,r0,r1,lsl#8
 str lr,[sp,#8] @ offload input pointer
 orr r2,r1,r2,lsl#16
 add r10,r10,r10,lsr#2
 orr r3,r2,r3,lsl#24
 add r11,r11,r11,lsr#2
 adcs r7,r7,r3
 add r12,r12,r12,lsr#2

 umull r2,r3,r5,r9
 adc r8,r8,#0
 umull r0,r1,r4,r9
 umlal r2,r3,r8,r10
 umlal r0,r1,r7,r10
 ldr r10,[sp,#20] @ reload r10
 umlal r2,r3,r6,r12
 umlal r0,r1,r5,r12
 umlal r2,r3,r7,r11
 umlal r0,r1,r6,r11
 umlal r2,r3,r4,r10
 str r0,[sp,#0] @ future r4
 mul r0,r11,r8
 ldr r11,[sp,#24] @ reload r11
 adds r2,r2,r1 @ d1+=d0>>32
 eor r1,r1,r1
 adc lr,r3,#0 @ future r6
 str r2,[sp,#4] @ future r5

 mul r2,r12,r8
 eor r3,r3,r3
 umlal r0,r1,r7,r12
 ldr r12,[sp,#28] @ reload r12
 umlal r2,r3,r7,r9
 umlal r0,r1,r6,r9
 umlal r2,r3,r6,r10
 umlal r0,r1,r5,r10
 umlal r2,r3,r5,r11
 umlal r0,r1,r4,r11
 umlal r2,r3,r4,r12
 ldr r4,[sp,#0]
 mul r8,r9,r8
 ldr r5,[sp,#4]

 adds r6,lr,r0 @ d2+=d1>>32
 ldr lr,[sp,#8] @ reload input pointer
 adc r1,r1,#0
 adds r7,r2,r1 @ d3+=d2>>32
 ldr r0,[sp,#16] @ reload end pointer
 adc r3,r3,#0
 add r8,r8,r3 @ h4+=d3>>32

 and r1,r8,#-4
 and r8,r8,#3
 add r1,r1,r1,lsr#2 @ *=5
 adds r4,r4,r1
 adcs r5,r5,#0
 adcs r6,r6,#0
 adcs r7,r7,#0
 adc r8,r8,#0

 cmp r0,lr @ done yet?
 bhi .Loop

 ldr r0,[sp,#12]
 add sp,sp,#32
 stmia r0,{r4,r5,r6,r7,r8} @ store the result

.Lno_data:



 ldmia sp!,{r3,r4,r5,r6,r7,r8,r9,r10,r11,lr}
 tst lr,#1
 moveq pc,lr @ be binary compatible with V4, yet
.word 0xe12fff1e @ interoperable with Thumb ISA:-)

.size poly1305_blocks,.-poly1305_blocks
.type poly1305_emit,%function
.align 5
poly1305_emit:
 stmdb sp!,{r4,r5,r6,r7,r8,r9,r10,r11}
.Lpoly1305_emit_enter:

 ldmia r0,{r3,r4,r5,r6,r7}
 adds r8,r3,#5 @ compare to modulus
 adcs r9,r4,#0
 adcs r10,r5,#0
 adcs r11,r6,#0
 adc r7,r7,#0
 tst r7,#4 @ did it carry/borrow?




 movne r3,r8
 ldr r8,[r2,#0]



 movne r4,r9
 ldr r9,[r2,#4]



 movne r5,r10
 ldr r10,[r2,#8]



 movne r6,r11
 ldr r11,[r2,#12]

 adds r3,r3,r8
 adcs r4,r4,r9
 adcs r5,r5,r10
 adc r6,r6,r11
 strb r3,[r1,#0]
 mov r3,r3,lsr#8
 strb r4,[r1,#4]
 mov r4,r4,lsr#8
 strb r5,[r1,#8]
 mov r5,r5,lsr#8
 strb r6,[r1,#12]
 mov r6,r6,lsr#8

 strb r3,[r1,#1]
 mov r3,r3,lsr#8
 strb r4,[r1,#5]
 mov r4,r4,lsr#8
 strb r5,[r1,#9]
 mov r5,r5,lsr#8
 strb r6,[r1,#13]
 mov r6,r6,lsr#8

 strb r3,[r1,#2]
 mov r3,r3,lsr#8
 strb r4,[r1,#6]
 mov r4,r4,lsr#8
 strb r5,[r1,#10]
 mov r5,r5,lsr#8
 strb r6,[r1,#14]
 mov r6,r6,lsr#8

 strb r3,[r1,#3]
 strb r4,[r1,#7]
 strb r5,[r1,#11]
 strb r6,[r1,#15]

 ldmia sp!,{r4,r5,r6,r7,r8,r9,r10,r11}



 tst lr,#1
 moveq pc,lr @ be binary compatible with V4, yet
.word 0xe12fff1e @ interoperable with Thumb ISA:-)

.size poly1305_emit,.-poly1305_emit
.byte 80,111,108,121,49,51,48,53,32,102,111,114,32,65,82,77,118,52,47,78,69,79,78,44,32,67,82,89,80,84,79,71,65,77,83,32,98,121,32,60,97,112,112,114,111,64,111,112,101,110,115,115,108,46,111,114,103,62,0
.align 2
.align 2
