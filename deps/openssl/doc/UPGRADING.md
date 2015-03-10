## How to upgrade openssl library in io.js

This document is intended to describe the procedure to upgrade openssl from 1.0.1 to 1.0.2 in io.js.

### Build System and Upgrading Overview
The openssl build system is based on the perl script of Configure.
For example, running `Configure linux_x86-64` in the openssl repository generates Makefile for linux_x86_64.
There are various parameters depends on each os and arch.`Configure TABLE` shows very useful information.
In io.js, build target is defined as `--dest-os` and `--dest-cpu` by using configure.

Here is a table of mapping each dest-os and dest-cpu in gyp to the config targets in openssl.

|   | ia32 | x64 | arm | arm64 | others |
|---|------|-----|-----|-------|--------|
| win | VC-WIN32 | VC-WIN64A | - | - | - |
| mac | darwin-i386-cc|darwin64-x86_64-cc | - | - | - |
| linux and others | linux-elf | linux-x86_64 | linux_armv4 | linux-aarch64 | linux-elf + no-asm |

We need to convert all parameters such as sources, defines, cflags and others generated in Makefile and write them into gypi files. Since `crypto/opensslconf.h` depends on os and arch, we also need to change `dep/openssl/config/opensslconf.h` so as to work on all targets.

Asm is enabled by default in openssl. Makefiles generated asm files with `crypto/*/asm/*.pl` and write them into `crypt/*/*.s`. As perl is not a requirement of io.js build,  they all should be generated and stored under `deps/openssl/asm` directory with `deps/openssl/asm/Makefile` in advance.


### 1. Replace openssl source in `deps/openssl/openssl`
Remove old openssl sources in `deps/openssl/openssl` .
Get original openssl sources from https://www.openssl.org/source/openssl-1.0.2.tar.gz and extract all files into `deps/openssl/openssl` .

### 2.Replace openssl header files in `deps/openssl/openssl/include/openssl`
all header files in `deps/openssl/openssl/include/openssl/*.h{ are symbolic links so they are replaced into the files to include a real header file such as
````
#include "../../crypto/aes/aes.h"
````
### 3. Change `opensslconf.h` so as to fit each platform.
`deps/openssl/openssl/crypto/opensslconf.h` should work on all targets. We need to change it so as to be listed in [diffs on crypto/opensslconf.h between platforms in openssl-1.0.2](openssl_conf.pdf). After copying from crypto/opensslconf.h generated with `./Confiure linux-x86_64` in openssl-1.0.2 and three patches of
[574407a6](https://github.com/iojs/io.js/commit/574407a67f5d42d22aac57a128448997c674c3e5), [153ce237](https://github.com/iojs/io.js/commit/153ce23727d935b4ae1c6850547df1a606cf0295) and [e05dff1e](https://github.com/iojs/io.js/commit/e05dff1e6071b6d4a34af68bf9477c7a9445e25e) are reapplied.

### 4. Update asm/Makefiles
The following changes were made on upgrading from openssl-1.0.1 to openssl-1.0.2
- Updated asm files for each platforms which are required in openssl-1.0.2. The changes of asm files are checked by comparing files between `openssl-1.0.2/crypto/*/*.s` and `deps/openssl/asm/x64-elf-gas/*/*.s` in linux-x64 case.
- Some perl files in `deps/openssl/openssl/crypto/*/asm/*.pl` need CC and ASM envs. Added a check if these envs exist. Followed asm files are to be generated with CC=gcc and ASM=nasm on Linux.
- Added new 32bit targets/rules with a sse2 flag (OPENSSL_IA32_SSE2) to generate asm to use SSE2.
- Generating sha512 asm files in x86_64 with `deps/openssl/openssl/crypto/sha/asm/sha512-x86_64.pl` need output filename which has 512 in . Added a new rule and target directory of asm/sha512 to store them.
- PERLASM_SCHEME of linux-armv4 is `void` as defined in openssl Configure. Changed its target/rule and all directories are moved from arm-elf-gas to arm-void-gas.

### 5. Update openssl.gyp and openssl.gypi
cflags and define parameters of each target can be obtained via Configure TABLE. Put them into the table list of [define and cflags changes in openssl-1.0.2](openssl_define_list.pdf)

### 6. Apply upstream patches for masm on Win32
openssl-1.0.2 has a bug in building with masm on Win32. Apply a patch of [9cefe5ba](https://github.com/iojs/io.js/commit/9cefe5baf8360a7f39f7933c9c1b470a45c617a9) in upstream repository that is not released yet.

### 7. Generate updated asm files
After asm/Makefile updated, new asm files are generated. In openssl-1.0.2, new directories of `deps/openssl/asm/` and `deps/opensssl/asm/sha512/x64-*/share` need to be created. With export environments of CC=gcc and ASM=nasm, then type `make` command and check if new asm files are generated.

### 8. Apply private patches
There are two kinds of private patches to be applied in openssl-1.0.2.

- openssl-cli built on win is used for test on io.js. Key press requirement of openssl-cli in win causes timeout of several tests. [44402826](https://github.com/iojs/io.js/commit/44402826a19d0497f4233a3d8e2d3c2a8685ad84) fixes this.

- Root certs of 1024bit RSA key length were deprecated in io.js. When a tls server has a cross root cert, io.js client leads CERT_UNTRUSTED error as openssl does not find alternate cert chains. [82a7fd91](https://github.com/iojs/io.js/commit/82a7fd91fbc6556b60fe7954f26cabc420451798) and [d70cd792](https://github.com/iojs/io.js/commit/d70cd7928d920fc2845122ee77ea99ee1d7a19fc) solve this issue. They need to be backported from master branch to be released as 1.1.0.
