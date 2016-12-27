
.text




.code 32






.align 5
.Lsigma:
.long 0x61707865,0x3320646e,0x79622d32,0x6b206574 @ endian-neutral
.Lone:
.long 1,0,0,0




.word -1


.globl ChaCha20_ctr32
.type ChaCha20_ctr32,%function
.align 5
ChaCha20_ctr32:
.LChaCha20_ctr32:
 ldr r12,[sp,#0] @ pull pointer to counter and nonce
 stmdb sp!,{r0,r1,r2,r4-r11,lr}

 sub r14,pc,#16 @ ChaCha20_ctr32



 cmp r2,#0 @ len==0?



 addeq sp,sp,#4*3
 beq .Lno_data
 ldmia r12,{r4,r5,r6,r7} @ load counter and nonce
 sub sp,sp,#4*(16) @ off-load area
 sub r14,r14,#64 @ .Lsigma
 stmdb sp!,{r4,r5,r6,r7} @ copy counter and nonce
 ldmia r3,{r4,r5,r6,r7,r8,r9,r10,r11} @ load key
 ldmia r14,{r0,r1,r2,r3} @ load sigma
 stmdb sp!,{r4,r5,r6,r7,r8,r9,r10,r11} @ copy key
 stmdb sp!,{r0,r1,r2,r3} @ copy sigma
 str r10,[sp,#4*(16+10)] @ off-load "rx"
 str r11,[sp,#4*(16+11)] @ off-load "rx"
 b .Loop_outer_enter

.align 4
.Loop_outer:
 ldmia sp,{r0,r1,r2,r3,r4,r5,r6,r7,r8,r9} @ load key material
 str r11,[sp,#4*(32+2)] @ save len
 str r12, [sp,#4*(32+1)] @ save inp
 str r14, [sp,#4*(32+0)] @ save out
.Loop_outer_enter:
 ldr r11, [sp,#4*(15)]
 ldr r12,[sp,#4*(12)] @ modulo-scheduled load
 ldr r10, [sp,#4*(13)]
 ldr r14,[sp,#4*(14)]
 str r11, [sp,#4*(16+15)]
 mov r11,#10
 b .Loop

.align 4
.Loop:
 subs r11,r11,#1
 add r0,r0,r4
 mov r12,r12,ror#16
 add r1,r1,r5
 mov r10,r10,ror#16
 eor r12,r12,r0,ror#16
 eor r10,r10,r1,ror#16
 add r8,r8,r12
 mov r4,r4,ror#20
 add r9,r9,r10
 mov r5,r5,ror#20
 eor r4,r4,r8,ror#20
 eor r5,r5,r9,ror#20
 add r0,r0,r4
 mov r12,r12,ror#24
 add r1,r1,r5
 mov r10,r10,ror#24
 eor r12,r12,r0,ror#24
 eor r10,r10,r1,ror#24
 add r8,r8,r12
 mov r4,r4,ror#25
 add r9,r9,r10
 mov r5,r5,ror#25
 str r10,[sp,#4*(16+13)]
 ldr r10,[sp,#4*(16+15)]
 eor r4,r4,r8,ror#25
 eor r5,r5,r9,ror#25
 str r8,[sp,#4*(16+8)]
 ldr r8,[sp,#4*(16+10)]
 add r2,r2,r6
 mov r14,r14,ror#16
 str r9,[sp,#4*(16+9)]
 ldr r9,[sp,#4*(16+11)]
 add r3,r3,r7
 mov r10,r10,ror#16
 eor r14,r14,r2,ror#16
 eor r10,r10,r3,ror#16
 add r8,r8,r14
 mov r6,r6,ror#20
 add r9,r9,r10
 mov r7,r7,ror#20
 eor r6,r6,r8,ror#20
 eor r7,r7,r9,ror#20
 add r2,r2,r6
 mov r14,r14,ror#24
 add r3,r3,r7
 mov r10,r10,ror#24
 eor r14,r14,r2,ror#24
 eor r10,r10,r3,ror#24
 add r8,r8,r14
 mov r6,r6,ror#25
 add r9,r9,r10
 mov r7,r7,ror#25
 eor r6,r6,r8,ror#25
 eor r7,r7,r9,ror#25
 add r0,r0,r5
 mov r10,r10,ror#16
 add r1,r1,r6
 mov r12,r12,ror#16
 eor r10,r10,r0,ror#16
 eor r12,r12,r1,ror#16
 add r8,r8,r10
 mov r5,r5,ror#20
 add r9,r9,r12
 mov r6,r6,ror#20
 eor r5,r5,r8,ror#20
 eor r6,r6,r9,ror#20
 add r0,r0,r5
 mov r10,r10,ror#24
 add r1,r1,r6
 mov r12,r12,ror#24
 eor r10,r10,r0,ror#24
 eor r12,r12,r1,ror#24
 add r8,r8,r10
 mov r5,r5,ror#25
 str r10,[sp,#4*(16+15)]
 ldr r10,[sp,#4*(16+13)]
 add r9,r9,r12
 mov r6,r6,ror#25
 eor r5,r5,r8,ror#25
 eor r6,r6,r9,ror#25
 str r8,[sp,#4*(16+10)]
 ldr r8,[sp,#4*(16+8)]
 add r2,r2,r7
 mov r10,r10,ror#16
 str r9,[sp,#4*(16+11)]
 ldr r9,[sp,#4*(16+9)]
 add r3,r3,r4
 mov r14,r14,ror#16
 eor r10,r10,r2,ror#16
 eor r14,r14,r3,ror#16
 add r8,r8,r10
 mov r7,r7,ror#20
 add r9,r9,r14
 mov r4,r4,ror#20
 eor r7,r7,r8,ror#20
 eor r4,r4,r9,ror#20
 add r2,r2,r7
 mov r10,r10,ror#24
 add r3,r3,r4
 mov r14,r14,ror#24
 eor r10,r10,r2,ror#24
 eor r14,r14,r3,ror#24
 add r8,r8,r10
 mov r7,r7,ror#25
 add r9,r9,r14
 mov r4,r4,ror#25
 eor r7,r7,r8,ror#25
 eor r4,r4,r9,ror#25
 bne .Loop

 ldr r11,[sp,#4*(32+2)] @ load len

 str r8, [sp,#4*(16+8)] @ modulo-scheduled store
 str r9, [sp,#4*(16+9)]
 str r12,[sp,#4*(16+12)]
 str r10, [sp,#4*(16+13)]
 str r14,[sp,#4*(16+14)]

 @ at this point we have first half of 512-bit result in
 @ rx and second half at sp+4*(16+8)

 cmp r11,#64 @ done yet?



 addlo r12,sp,#4*(0) @ shortcut or ...
 ldrhs r12,[sp,#4*(32+1)] @ ... load inp
 addlo r14,sp,#4*(0) @ shortcut or ...
 ldrhs r14,[sp,#4*(32+0)] @ ... load out

 ldr r8,[sp,#4*(0)] @ load key material
 ldr r9,[sp,#4*(1)]



 orr r10,r12,r14
 tst r10,#3 @ are input and output aligned?
 ldr r10,[sp,#4*(2)]
 bne .Lunaligned
 cmp r11,#64 @ restore flags



 ldr r11,[sp,#4*(3)]

 add r0,r0,r8 @ accumulate key material
 add r1,r1,r9



 ldrhs r8,[r12],#16 @ load input
 ldrhs r9,[r12,#-12]

 add r2,r2,r10
 add r3,r3,r11



 ldrhs r10,[r12,#-8]
 ldrhs r11,[r12,#-4]
 eorhs r0,r0,r8 @ xor with input
 eorhs r1,r1,r9
 add r8,sp,#4*(4)
 str r0,[r14],#16 @ store output



 eorhs r2,r2,r10
 eorhs r3,r3,r11
 ldmia r8,{r8,r9,r10,r11} @ load key material
 str r1,[r14,#-12]
 str r2,[r14,#-8]
 str r3,[r14,#-4]

 add r4,r4,r8 @ accumulate key material
 add r5,r5,r9



 ldrhs r8,[r12],#16 @ load input
 ldrhs r9,[r12,#-12]
 add r6,r6,r10
 add r7,r7,r11



 ldrhs r10,[r12,#-8]
 ldrhs r11,[r12,#-4]
 eorhs r4,r4,r8
 eorhs r5,r5,r9
 add r8,sp,#4*(8)
 str r4,[r14],#16 @ store output



 eorhs r6,r6,r10
 eorhs r7,r7,r11
 str r5,[r14,#-12]
 ldmia r8,{r8,r9,r10,r11} @ load key material
 str r6,[r14,#-8]
 add r0,sp,#4*(16+8)
 str r7,[r14,#-4]

 ldmia r0,{r0,r1,r2,r3,r4,r5,r6,r7} @ load second half

 add r0,r0,r8 @ accumulate key material
 add r1,r1,r9



 ldrhs r8,[r12],#16 @ load input
 ldrhs r9,[r12,#-12]



 strhi r10,[sp,#4*(16+10)] @ copy "rx" while at it
 strhi r11,[sp,#4*(16+11)] @ copy "rx" while at it
 add r2,r2,r10
 add r3,r3,r11



 ldrhs r10,[r12,#-8]
 ldrhs r11,[r12,#-4]
 eorhs r0,r0,r8
 eorhs r1,r1,r9
 add r8,sp,#4*(12)
 str r0,[r14],#16 @ store output



 eorhs r2,r2,r10
 eorhs r3,r3,r11
 str r1,[r14,#-12]
 ldmia r8,{r8,r9,r10,r11} @ load key material
 str r2,[r14,#-8]
 str r3,[r14,#-4]

 add r4,r4,r8 @ accumulate key material
 add r5,r5,r9



 addhi r8,r8,#1 @ next counter value
 strhi r8,[sp,#4*(12)] @ save next counter value



 ldrhs r8,[r12],#16 @ load input
 ldrhs r9,[r12,#-12]
 add r6,r6,r10
 add r7,r7,r11



 ldrhs r10,[r12,#-8]
 ldrhs r11,[r12,#-4]
 eorhs r4,r4,r8
 eorhs r5,r5,r9



 ldrne r8,[sp,#4*(32+2)] @ re-load len



 eorhs r6,r6,r10
 eorhs r7,r7,r11
 str r4,[r14],#16 @ store output
 str r5,[r14,#-12]



 subhs r11,r8,#64 @ len-=64
 str r6,[r14,#-8]
 str r7,[r14,#-4]
 bhi .Loop_outer

 beq .Ldone

 b .Ltail

.align 4
.Lunaligned:@ unaligned endian-neutral path
 cmp r11,#64 @ restore flags



 ldr r11,[sp,#4*(3)]
 add r0,r0,r8 @ accumulate key material
 add r1,r1,r9
 add r2,r2,r10



 eorlo r8,r8,r8 @ zero or ...
 ldrhsb r8,[r12],#16 @ ... load input
 eorlo r9,r9,r9
 ldrhsb r9,[r12,#-12]

 add r3,r3,r11



 eorlo r10,r10,r10
 ldrhsb r10,[r12,#-8]
 eorlo r11,r11,r11
 ldrhsb r11,[r12,#-4]

 eor r0,r8,r0 @ xor with input (or zero)
 eor r1,r9,r1



 ldrhsb r8,[r12,#-15] @ load more input
 ldrhsb r9,[r12,#-11]
 eor r2,r10,r2
 strb r0,[r14],#16 @ store output
 eor r3,r11,r3



 ldrhsb r10,[r12,#-7]
 ldrhsb r11,[r12,#-3]
 strb r1,[r14,#-12]
 eor r0,r8,r0,lsr#8
 strb r2,[r14,#-8]
 eor r1,r9,r1,lsr#8



 ldrhsb r8,[r12,#-14] @ load more input
 ldrhsb r9,[r12,#-10]
 strb r3,[r14,#-4]
 eor r2,r10,r2,lsr#8
 strb r0,[r14,#-15]
 eor r3,r11,r3,lsr#8



 ldrhsb r10,[r12,#-6]
 ldrhsb r11,[r12,#-2]
 strb r1,[r14,#-11]
 eor r0,r8,r0,lsr#8
 strb r2,[r14,#-7]
 eor r1,r9,r1,lsr#8



 ldrhsb r8,[r12,#-13] @ load more input
 ldrhsb r9,[r12,#-9]
 strb r3,[r14,#-3]
 eor r2,r10,r2,lsr#8
 strb r0,[r14,#-14]
 eor r3,r11,r3,lsr#8



 ldrhsb r10,[r12,#-5]
 ldrhsb r11,[r12,#-1]
 strb r1,[r14,#-10]
 strb r2,[r14,#-6]
 eor r0,r8,r0,lsr#8
 strb r3,[r14,#-2]
 eor r1,r9,r1,lsr#8
 strb r0,[r14,#-13]
 eor r2,r10,r2,lsr#8
 strb r1,[r14,#-9]
 eor r3,r11,r3,lsr#8
 strb r2,[r14,#-5]
 strb r3,[r14,#-1]
 add r8,sp,#4*(4+0)
 ldmia r8,{r8,r9,r10,r11} @ load key material
 add r0,sp,#4*(16+8)
 add r4,r4,r8 @ accumulate key material
 add r5,r5,r9
 add r6,r6,r10



 eorlo r8,r8,r8 @ zero or ...
 ldrhsb r8,[r12],#16 @ ... load input
 eorlo r9,r9,r9
 ldrhsb r9,[r12,#-12]

 add r7,r7,r11



 eorlo r10,r10,r10
 ldrhsb r10,[r12,#-8]
 eorlo r11,r11,r11
 ldrhsb r11,[r12,#-4]

 eor r4,r8,r4 @ xor with input (or zero)
 eor r5,r9,r5



 ldrhsb r8,[r12,#-15] @ load more input
 ldrhsb r9,[r12,#-11]
 eor r6,r10,r6
 strb r4,[r14],#16 @ store output
 eor r7,r11,r7



 ldrhsb r10,[r12,#-7]
 ldrhsb r11,[r12,#-3]
 strb r5,[r14,#-12]
 eor r4,r8,r4,lsr#8
 strb r6,[r14,#-8]
 eor r5,r9,r5,lsr#8



 ldrhsb r8,[r12,#-14] @ load more input
 ldrhsb r9,[r12,#-10]
 strb r7,[r14,#-4]
 eor r6,r10,r6,lsr#8
 strb r4,[r14,#-15]
 eor r7,r11,r7,lsr#8



 ldrhsb r10,[r12,#-6]
 ldrhsb r11,[r12,#-2]
 strb r5,[r14,#-11]
 eor r4,r8,r4,lsr#8
 strb r6,[r14,#-7]
 eor r5,r9,r5,lsr#8



 ldrhsb r8,[r12,#-13] @ load more input
 ldrhsb r9,[r12,#-9]
 strb r7,[r14,#-3]
 eor r6,r10,r6,lsr#8
 strb r4,[r14,#-14]
 eor r7,r11,r7,lsr#8



 ldrhsb r10,[r12,#-5]
 ldrhsb r11,[r12,#-1]
 strb r5,[r14,#-10]
 strb r6,[r14,#-6]
 eor r4,r8,r4,lsr#8
 strb r7,[r14,#-2]
 eor r5,r9,r5,lsr#8
 strb r4,[r14,#-13]
 eor r6,r10,r6,lsr#8
 strb r5,[r14,#-9]
 eor r7,r11,r7,lsr#8
 strb r6,[r14,#-5]
 strb r7,[r14,#-1]
 add r8,sp,#4*(4+4)
 ldmia r8,{r8,r9,r10,r11} @ load key material
 ldmia r0,{r0,r1,r2,r3,r4,r5,r6,r7} @ load second half



 strhi r10,[sp,#4*(16+10)] @ copy "rx"
 strhi r11,[sp,#4*(16+11)] @ copy "rx"
 add r0,r0,r8 @ accumulate key material
 add r1,r1,r9
 add r2,r2,r10



 eorlo r8,r8,r8 @ zero or ...
 ldrhsb r8,[r12],#16 @ ... load input
 eorlo r9,r9,r9
 ldrhsb r9,[r12,#-12]

 add r3,r3,r11



 eorlo r10,r10,r10
 ldrhsb r10,[r12,#-8]
 eorlo r11,r11,r11
 ldrhsb r11,[r12,#-4]

 eor r0,r8,r0 @ xor with input (or zero)
 eor r1,r9,r1



 ldrhsb r8,[r12,#-15] @ load more input
 ldrhsb r9,[r12,#-11]
 eor r2,r10,r2
 strb r0,[r14],#16 @ store output
 eor r3,r11,r3



 ldrhsb r10,[r12,#-7]
 ldrhsb r11,[r12,#-3]
 strb r1,[r14,#-12]
 eor r0,r8,r0,lsr#8
 strb r2,[r14,#-8]
 eor r1,r9,r1,lsr#8



 ldrhsb r8,[r12,#-14] @ load more input
 ldrhsb r9,[r12,#-10]
 strb r3,[r14,#-4]
 eor r2,r10,r2,lsr#8
 strb r0,[r14,#-15]
 eor r3,r11,r3,lsr#8



 ldrhsb r10,[r12,#-6]
 ldrhsb r11,[r12,#-2]
 strb r1,[r14,#-11]
 eor r0,r8,r0,lsr#8
 strb r2,[r14,#-7]
 eor r1,r9,r1,lsr#8



 ldrhsb r8,[r12,#-13] @ load more input
 ldrhsb r9,[r12,#-9]
 strb r3,[r14,#-3]
 eor r2,r10,r2,lsr#8
 strb r0,[r14,#-14]
 eor r3,r11,r3,lsr#8



 ldrhsb r10,[r12,#-5]
 ldrhsb r11,[r12,#-1]
 strb r1,[r14,#-10]
 strb r2,[r14,#-6]
 eor r0,r8,r0,lsr#8
 strb r3,[r14,#-2]
 eor r1,r9,r1,lsr#8
 strb r0,[r14,#-13]
 eor r2,r10,r2,lsr#8
 strb r1,[r14,#-9]
 eor r3,r11,r3,lsr#8
 strb r2,[r14,#-5]
 strb r3,[r14,#-1]
 add r8,sp,#4*(4+8)
 ldmia r8,{r8,r9,r10,r11} @ load key material
 add r4,r4,r8 @ accumulate key material



 addhi r8,r8,#1 @ next counter value
 strhi r8,[sp,#4*(12)] @ save next counter value
 add r5,r5,r9
 add r6,r6,r10



 eorlo r8,r8,r8 @ zero or ...
 ldrhsb r8,[r12],#16 @ ... load input
 eorlo r9,r9,r9
 ldrhsb r9,[r12,#-12]

 add r7,r7,r11



 eorlo r10,r10,r10
 ldrhsb r10,[r12,#-8]
 eorlo r11,r11,r11
 ldrhsb r11,[r12,#-4]

 eor r4,r8,r4 @ xor with input (or zero)
 eor r5,r9,r5



 ldrhsb r8,[r12,#-15] @ load more input
 ldrhsb r9,[r12,#-11]
 eor r6,r10,r6
 strb r4,[r14],#16 @ store output
 eor r7,r11,r7



 ldrhsb r10,[r12,#-7]
 ldrhsb r11,[r12,#-3]
 strb r5,[r14,#-12]
 eor r4,r8,r4,lsr#8
 strb r6,[r14,#-8]
 eor r5,r9,r5,lsr#8



 ldrhsb r8,[r12,#-14] @ load more input
 ldrhsb r9,[r12,#-10]
 strb r7,[r14,#-4]
 eor r6,r10,r6,lsr#8
 strb r4,[r14,#-15]
 eor r7,r11,r7,lsr#8



 ldrhsb r10,[r12,#-6]
 ldrhsb r11,[r12,#-2]
 strb r5,[r14,#-11]
 eor r4,r8,r4,lsr#8
 strb r6,[r14,#-7]
 eor r5,r9,r5,lsr#8



 ldrhsb r8,[r12,#-13] @ load more input
 ldrhsb r9,[r12,#-9]
 strb r7,[r14,#-3]
 eor r6,r10,r6,lsr#8
 strb r4,[r14,#-14]
 eor r7,r11,r7,lsr#8



 ldrhsb r10,[r12,#-5]
 ldrhsb r11,[r12,#-1]
 strb r5,[r14,#-10]
 strb r6,[r14,#-6]
 eor r4,r8,r4,lsr#8
 strb r7,[r14,#-2]
 eor r5,r9,r5,lsr#8
 strb r4,[r14,#-13]
 eor r6,r10,r6,lsr#8
 strb r5,[r14,#-9]
 eor r7,r11,r7,lsr#8
 strb r6,[r14,#-5]
 strb r7,[r14,#-1]



 ldrne r8,[sp,#4*(32+2)] @ re-load len



 subhs r11,r8,#64 @ len-=64
 bhi .Loop_outer

 beq .Ldone


.Ltail:
 ldr r12,[sp,#4*(32+1)] @ load inp
 add r9,sp,#4*(0)
 ldr r14,[sp,#4*(32+0)] @ load out

.Loop_tail:
 ldrb r10,[r9],#1 @ read buffer on stack
 ldrb r11,[r12],#1 @ read input
 subs r8,r8,#1
 eor r11,r11,r10
 strb r11,[r14],#1 @ store output
 bne .Loop_tail

.Ldone:
 add sp,sp,#4*(32+3)
.Lno_data:
 ldmia sp!,{r4,r5,r6,r7,r8,r9,r10,r11,pc}
.size ChaCha20_ctr32,.-ChaCha20_ctr32
