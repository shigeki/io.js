@ Copyright 2012-2016 The OpenSSL Project Authors. All Rights Reserved.
@
@ Licensed under the OpenSSL license (the "License"). You may not use
@ this file except in compliance with the License. You can obtain a copy
@ in the file LICENSE in the source distribution or at
@ https:


@ ====================================================================
@ Written by Andy Polyakov <appro@openssl.org> for the OpenSSL
@ project. The module is, however, dual licensed under OpenSSL and
@ CRYPTOGAMS licenses depending on where you obtain it. For further
@ details see http:
@
@ Specific modes and adaptation for Linux kernel by Ard Biesheuvel
@ <ard.biesheuvel@linaro.org>. Permission to use under GPL terms is
@ granted.
@ ====================================================================

@ Bit-sliced AES for ARM NEON
@
@ February 2012.
@
@ This implementation is direct adaptation of bsaes-x86_64 module for
@ ARM NEON. Except that this module is endian-neutral [in sense that
@ it can be compiled for either endianness] by courtesy of vld1.8's
@ neutrality. Initial version doesn't implement interface to OpenSSL,
@ only low-level primitives and unsupported entry points, just enough
@ to collect performance results, which for Cortex-A8 core are:
@
@ encrypt 19.5 cycles per byte processed with 128-bit key
@ decrypt 22.1 cycles per byte processed with 128-bit key
@ key conv. 440 cycles per 128-bit key/0.18 of 8x block
@
@ Snapdragon S4 encrypts byte in 17.6 cycles and decrypts in 19.7,
@ which is [much] worse than anticipated (for further details see
@ http:
@
@ Cortex-A15 manages in 14.2/16.1 cycles [when integer-only code
@ manages in 20.0 cycles].
@
@ When comparing to x86_64 results keep in mind that NEON unit is
@ [mostly] single-issue and thus can't [fully] benefit from
@ instruction-level parallelism. And when comparing to aes-armv4
@ results keep in mind key schedule conversion overhead (see
@ bsaes-x86_64.pl for further details)...
@
@ <appro@openssl.org>

@ April-August 2013
@
@ Add CBC, CTR and XTS subroutines, adapt for kernel use.
@
@ <ard.biesheuvel@linaro.org>


