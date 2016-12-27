
.text




.code 32


.align 5
.globl OPENSSL_atomic_add
.type OPENSSL_atomic_add,%function
OPENSSL_atomic_add:
 stmdb sp!,{r4,r5,r6,lr}
 ldr r2,.Lspinlock
 adr r3,.Lspinlock
 mov r4,r0
 mov r5,r1
 add r6,r3,r2 @ &spinlock
 b .+8
.Lspin: bl sched_yield
 mov r0,#-1
 swp r0,r0,[r6]
 cmp r0,#0
 bne .Lspin

 ldr r2,[r4]
 add r2,r2,r5
 str r2,[r4]
 str r0,[r6] @ release spinlock
 ldmia sp!,{r4,r5,r6,lr}
 tst lr,#1
 moveq pc,lr
.word 0xe12fff1e @ bx lr

.size OPENSSL_atomic_add,.-OPENSSL_atomic_add

.globl OPENSSL_cleanse
.type OPENSSL_cleanse,%function
OPENSSL_cleanse:
 eor ip,ip,ip
 cmp r1,#7



 subhs r1,r1,#4
 bhs .Lot
 cmp r1,#0
 beq .Lcleanse_done
.Little:
 strb ip,[r0],#1
 subs r1,r1,#1
 bhi .Little
 b .Lcleanse_done

.Lot: tst r0,#3
 beq .Laligned
 strb ip,[r0],#1
 sub r1,r1,#1
 b .Lot
.Laligned:
 str ip,[r0],#4
 subs r1,r1,#4
 bhs .Laligned
 adds r1,r1,#4
 bne .Little
.Lcleanse_done:



 tst lr,#1
 moveq pc,lr
.word 0xe12fff1e @ bx lr

.size OPENSSL_cleanse,.-OPENSSL_cleanse

.globl CRYPTO_memcmp
.type CRYPTO_memcmp,%function
.align 4
CRYPTO_memcmp:
 eor ip,ip,ip
 cmp r2,#0
 beq .Lno_data
 stmdb sp!,{r4,r5}

.Loop_cmp:
 ldrb r4,[r0],#1
 ldrb r5,[r1],#1
 eor r4,r4,r5
 orr ip,ip,r4
 subs r2,r2,#1
 bne .Loop_cmp

 ldmia sp!,{r4,r5}
.Lno_data:
 neg r0,ip
 mov r0,r0,lsr#31



 tst lr,#1
 moveq pc,lr
.word 0xe12fff1e @ bx lr

.size CRYPTO_memcmp,.-CRYPTO_memcmp
.globl OPENSSL_wipe_cpu
.type OPENSSL_wipe_cpu,%function
OPENSSL_wipe_cpu:
 eor r2,r2,r2
 eor r3,r3,r3
 eor ip,ip,ip
 mov r0,sp



 tst lr,#1
 moveq pc,lr
.word 0xe12fff1e @ bx lr

.size OPENSSL_wipe_cpu,.-OPENSSL_wipe_cpu

.globl OPENSSL_instrument_bus
.type OPENSSL_instrument_bus,%function
OPENSSL_instrument_bus:
 eor r0,r0,r0



 tst lr,#1
 moveq pc,lr
.word 0xe12fff1e @ bx lr

.size OPENSSL_instrument_bus,.-OPENSSL_instrument_bus

.globl OPENSSL_instrument_bus2
.type OPENSSL_instrument_bus2,%function
OPENSSL_instrument_bus2:
 eor r0,r0,r0



 tst lr,#1
 moveq pc,lr
.word 0xe12fff1e @ bx lr

.size OPENSSL_instrument_bus2,.-OPENSSL_instrument_bus2

.align 5







.Lspinlock:
.word atomic_add_spinlock-.Lspinlock
.align 5

.data
.align 2
atomic_add_spinlock:
.word 0


.comm OPENSSL_armcap_P,4,4
.hidden OPENSSL_armcap_P
