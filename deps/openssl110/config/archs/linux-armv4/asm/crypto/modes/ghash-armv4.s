
.text






.code 32







.type rem_4bit,%object
.align 5
rem_4bit:
.short 0x0000,0x1C20,0x3840,0x2460
.short 0x7080,0x6CA0,0x48C0,0x54E0
.short 0xE100,0xFD20,0xD940,0xC560
.short 0x9180,0x8DA0,0xA9C0,0xB5E0
.size rem_4bit,.-rem_4bit

.type rem_4bit_get,%function
rem_4bit_get:



 sub r2,pc,#8+32 @ &rem_4bit

 b .Lrem_4bit_got
 nop
 nop
.size rem_4bit_get,.-rem_4bit_get

.globl gcm_ghash_4bit
.type gcm_ghash_4bit,%function
.align 4
gcm_ghash_4bit:



 sub r12,pc,#8+48 @ &rem_4bit

 add r3,r2,r3 @ r3 to point at the end
 stmdb sp!,{r3,r4,r5,r6,r7,r8,r9,r10,r11,lr} @ save r3/end too

 ldmia r12,{r4,r5,r6,r7,r8,r9,r10,r11} @ copy rem_4bit ...
 stmdb sp!,{r4,r5,r6,r7,r8,r9,r10,r11} @ ... to stack

 ldrb r12,[r2,#15]
 ldrb r14,[r0,#15]
.Louter:
 eor r12,r12,r14
 and r14,r12,#0xf0
 and r12,r12,#0x0f
 mov r3,#14

 add r7,r1,r12,lsl#4
 ldmia r7,{r4,r5,r6,r7} @ load Htbl[nlo]
 add r11,r1,r14
 ldrb r12,[r2,#14]

 and r14,r4,#0xf @ rem
 ldmia r11,{r8,r9,r10,r11} @ load Htbl[nhi]
 add r14,r14,r14
 eor r4,r8,r4,lsr#4
 ldrh r8,[sp,r14] @ rem_4bit[rem]
 eor r4,r4,r5,lsl#28
 ldrb r14,[r0,#14]
 eor r5,r9,r5,lsr#4
 eor r5,r5,r6,lsl#28
 eor r6,r10,r6,lsr#4
 eor r6,r6,r7,lsl#28
 eor r7,r11,r7,lsr#4
 eor r12,r12,r14
 and r14,r12,#0xf0
 and r12,r12,#0x0f
 eor r7,r7,r8,lsl#16

.Linner:
 add r11,r1,r12,lsl#4
 and r12,r4,#0xf @ rem
 subs r3,r3,#1
 add r12,r12,r12
 ldmia r11,{r8,r9,r10,r11} @ load Htbl[nlo]
 eor r4,r8,r4,lsr#4
 eor r4,r4,r5,lsl#28
 eor r5,r9,r5,lsr#4
 eor r5,r5,r6,lsl#28
 ldrh r8,[sp,r12] @ rem_4bit[rem]
 eor r6,r10,r6,lsr#4



 ldrplb r12,[r2,r3]
 eor r6,r6,r7,lsl#28
 eor r7,r11,r7,lsr#4

 add r11,r1,r14
 and r14,r4,#0xf @ rem
 eor r7,r7,r8,lsl#16 @ ^= rem_4bit[rem]
 add r14,r14,r14
 ldmia r11,{r8,r9,r10,r11} @ load Htbl[nhi]
 eor r4,r8,r4,lsr#4



 ldrplb r8,[r0,r3]
 eor r4,r4,r5,lsl#28
 eor r5,r9,r5,lsr#4
 ldrh r9,[sp,r14]
 eor r5,r5,r6,lsl#28
 eor r6,r10,r6,lsr#4
 eor r6,r6,r7,lsl#28



 eorpl r12,r12,r8
 eor r7,r11,r7,lsr#4



 andpl r14,r12,#0xf0
 andpl r12,r12,#0x0f
 eor r7,r7,r9,lsl#16 @ ^= rem_4bit[rem]
 bpl .Linner

 ldr r3,[sp,#32] @ re-load r3/end
 add r2,r2,#16
 mov r14,r4






 mov r9,r4,lsr#8
 strb r4,[r0,#12+3]
 mov r10,r4,lsr#16
 strb r9,[r0,#12+2]
 mov r11,r4,lsr#24
 strb r10,[r0,#12+1]
 strb r11,[r0,#12]

 cmp r2,r3






 mov r9,r5,lsr#8
 strb r5,[r0,#8+3]
 mov r10,r5,lsr#16
 strb r9,[r0,#8+2]
 mov r11,r5,lsr#24
 strb r10,[r0,#8+1]
 strb r11,[r0,#8]





 ldrneb r12,[r2,#15]






 mov r9,r6,lsr#8
 strb r6,[r0,#4+3]
 mov r10,r6,lsr#16
 strb r9,[r0,#4+2]
 mov r11,r6,lsr#24
 strb r10,[r0,#4+1]
 strb r11,[r0,#4]
 mov r9,r7,lsr#8
 strb r7,[r0,#0+3]
 mov r10,r7,lsr#16
 strb r9,[r0,#0+2]
 mov r11,r7,lsr#24
 strb r10,[r0,#0+1]
 strb r11,[r0,#0]


 bne .Louter

 add sp,sp,#36



 ldmia sp!,{r4,r5,r6,r7,r8,r9,r10,r11,lr}
 tst lr,#1
 moveq pc,lr @ be binary compatible with V4, yet
.word 0xe12fff1e @ interoperable with Thumb ISA:-)

.size gcm_ghash_4bit,.-gcm_ghash_4bit

.globl gcm_gmult_4bit
.type gcm_gmult_4bit,%function
gcm_gmult_4bit:
 stmdb sp!,{r4,r5,r6,r7,r8,r9,r10,r11,lr}
 ldrb r12,[r0,#15]
 b rem_4bit_get
.Lrem_4bit_got:
 and r14,r12,#0xf0
 and r12,r12,#0x0f
 mov r3,#14

 add r7,r1,r12,lsl#4
 ldmia r7,{r4,r5,r6,r7} @ load Htbl[nlo]
 ldrb r12,[r0,#14]

 add r11,r1,r14
 and r14,r4,#0xf @ rem
 ldmia r11,{r8,r9,r10,r11} @ load Htbl[nhi]
 add r14,r14,r14
 eor r4,r8,r4,lsr#4
 ldrh r8,[r2,r14] @ rem_4bit[rem]
 eor r4,r4,r5,lsl#28
 eor r5,r9,r5,lsr#4
 eor r5,r5,r6,lsl#28
 eor r6,r10,r6,lsr#4
 eor r6,r6,r7,lsl#28
 eor r7,r11,r7,lsr#4
 and r14,r12,#0xf0
 eor r7,r7,r8,lsl#16
 and r12,r12,#0x0f

.Loop:
 add r11,r1,r12,lsl#4
 and r12,r4,#0xf @ rem
 subs r3,r3,#1
 add r12,r12,r12
 ldmia r11,{r8,r9,r10,r11} @ load Htbl[nlo]
 eor r4,r8,r4,lsr#4
 eor r4,r4,r5,lsl#28
 eor r5,r9,r5,lsr#4
 eor r5,r5,r6,lsl#28
 ldrh r8,[r2,r12] @ rem_4bit[rem]
 eor r6,r10,r6,lsr#4



 ldrplb r12,[r0,r3]
 eor r6,r6,r7,lsl#28
 eor r7,r11,r7,lsr#4

 add r11,r1,r14
 and r14,r4,#0xf @ rem
 eor r7,r7,r8,lsl#16 @ ^= rem_4bit[rem]
 add r14,r14,r14
 ldmia r11,{r8,r9,r10,r11} @ load Htbl[nhi]
 eor r4,r8,r4,lsr#4
 eor r4,r4,r5,lsl#28
 eor r5,r9,r5,lsr#4
 ldrh r8,[r2,r14] @ rem_4bit[rem]
 eor r5,r5,r6,lsl#28
 eor r6,r10,r6,lsr#4
 eor r6,r6,r7,lsl#28
 eor r7,r11,r7,lsr#4



 andpl r14,r12,#0xf0
 andpl r12,r12,#0x0f
 eor r7,r7,r8,lsl#16 @ ^= rem_4bit[rem]
 bpl .Loop






 mov r9,r4,lsr#8
 strb r4,[r0,#12+3]
 mov r10,r4,lsr#16
 strb r9,[r0,#12+2]
 mov r11,r4,lsr#24
 strb r10,[r0,#12+1]
 strb r11,[r0,#12]
 mov r9,r5,lsr#8
 strb r5,[r0,#8+3]
 mov r10,r5,lsr#16
 strb r9,[r0,#8+2]
 mov r11,r5,lsr#24
 strb r10,[r0,#8+1]
 strb r11,[r0,#8]
 mov r9,r6,lsr#8
 strb r6,[r0,#4+3]
 mov r10,r6,lsr#16
 strb r9,[r0,#4+2]
 mov r11,r6,lsr#24
 strb r10,[r0,#4+1]
 strb r11,[r0,#4]
 mov r9,r7,lsr#8
 strb r7,[r0,#0+3]
 mov r10,r7,lsr#16
 strb r9,[r0,#0+2]
 mov r11,r7,lsr#24
 strb r10,[r0,#0+1]
 strb r11,[r0,#0]





 ldmia sp!,{r4,r5,r6,r7,r8,r9,r10,r11,lr}
 tst lr,#1
 moveq pc,lr @ be binary compatible with V4, yet
.word 0xe12fff1e @ interoperable with Thumb ISA:-)

.size gcm_gmult_4bit,.-gcm_gmult_4bit
.byte 71,72,65,83,72,32,102,111,114,32,65,82,77,118,52,47,78,69,79,78,44,32,67,82,89,80,84,79,71,65,77,83,32,98,121,32,60,97,112,112,114,111,64,111,112,101,110,115,115,108,46,111,114,103,62,0
.align 2
.align 2
