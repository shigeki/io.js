
.text
.arch armv8-a+crypto

.align 5
.globl _armv7_neon_probe
.type _armv7_neon_probe,%function
_armv7_neon_probe:
 orr v15.16b, v15.16b, v15.16b
 ret
.size _armv7_neon_probe,.-_armv7_neon_probe

.globl _armv7_tick
.type _armv7_tick,%function
_armv7_tick:



 mrs x0, CNTVCT_EL0

 ret
.size _armv7_tick,.-_armv7_tick

.globl _armv8_aes_probe
.type _armv8_aes_probe,%function
_armv8_aes_probe:
 aese v0.16b, v0.16b
 ret
.size _armv8_aes_probe,.-_armv8_aes_probe

.globl _armv8_sha1_probe
.type _armv8_sha1_probe,%function
_armv8_sha1_probe:
 sha1h s0, s0
 ret
.size _armv8_sha1_probe,.-_armv8_sha1_probe

.globl _armv8_sha256_probe
.type _armv8_sha256_probe,%function
_armv8_sha256_probe:
 sha256su0 v0.4s, v0.4s
 ret
.size _armv8_sha256_probe,.-_armv8_sha256_probe
.globl _armv8_pmull_probe
.type _armv8_pmull_probe,%function
_armv8_pmull_probe:
 pmull v0.1q, v0.1d, v0.1d
 ret
.size _armv8_pmull_probe,.-_armv8_pmull_probe

.globl OPENSSL_cleanse
.type OPENSSL_cleanse,%function
.align 5
OPENSSL_cleanse:
 cbz x1,.Lret
 cmp x1,#15
 b.hi .Lot
 nop
.Little:
 strb wzr,[x0],#1
 subs x1,x1,#1
 b.ne .Little
.Lret: ret

.align 4
.Lot: tst x0,#7
 b.eq .Laligned
 strb wzr,[x0],#1
 sub x1,x1,#1
 b .Lot

.align 4
.Laligned:
 str xzr,[x0],#8
 sub x1,x1,#8
 tst x1,#-8
 b.ne .Laligned
 cbnz x1,.Little
 ret
.size OPENSSL_cleanse,.-OPENSSL_cleanse

.globl CRYPTO_memcmp
.type CRYPTO_memcmp,%function
.align 4
CRYPTO_memcmp:
 eor w3,w3,w3
 cbz x2,.Lno_data
.Loop_cmp:
 ldrb w4,[x0],#1
 ldrb w5,[x1],#1
 eor w4,w4,w5
 orr w3,w3,w4
 subs x2,x2,#1
 b.ne .Loop_cmp

.Lno_data:
 neg w0,w3
 lsr w0,w0,#31
 ret
.size CRYPTO_memcmp,.-CRYPTO_memcmp
