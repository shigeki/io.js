{
  'targets': [
    {
      'target_name': 'openssl',
      'type': '<(library)',
      'include_dirs': [
        'openssl/',
        'openssl/include/',
        'openssl/crypto/',
        'openssl/crypto/include/',
        'openssl/crypto/modes/',
      ],
      'defines': [
        'ENGINESDIR="/dev/null"',
        'OPENSSLDIR="/etc/ssl"',
      ],
      'conditions': [
        [ 'OS=="aix"', {
          # AIX is missing /usr/include/endian.h
          'defines': [
            '__LITTLE_ENDIAN=1234',
            '__BIG_ENDIAN=4321',
            '__BYTE_ORDER=__BIG_ENDIAN',
            '__FLOAT_WORD_ORDER=__BIG_ENDIAN'],
        }],
        [ 'node_byteorder=="big"', {
          # Define Big Endian
          'defines': ['B_ENDIAN']
        }, {
        # Define Little Endian
        'defines':['L_ENDIAN']
        }],],
      'conditions': [
        ['openssl_no_asm==0', {
          'defines': ['OPENSSL_CPUID_OBJ'],
          'conditions': [
            ['target_arch=="ppc" and OS=="aix"', {
              'includes': ['config/archs/aix-gcc/asm/openssl.gypi'],
            }, ['target_arch=="ppc" and OS=="linux"', {
              'includes': ['config/archs/linux-pcc/asm/openssl.gypi'],
            }, ['target_arch=="ppc64" and OS=="aix"', {
              'includes': ['config/archs/aix64-gcc/asm/openssl.gypi'],
            }, ['target_arch=="ppc64" and OS=="linux"', {
              'includes': ['config/archs/linux-ppc64/asm/openssl.gypi'],
            }, ['target_arch=="s390" and OS=="linux"', {
              'includes': ['config/archs/linux32-s390x/asm/openssl.gypi'],
            }, ['target_arch=="s390x" and OS=="linux"', {
              'includes': ['config/archs/linux64-s390x/asm/openssl.gypi'],
            }, ['target_arch=="arm" and OS=="linux"', {
              'includes': ['config/archs/linux-armv4/asm/openssl.gypi'],
            }, 'target_arch=="arm64" and OS=="linux"', {
              'includes': ['config/archs/linux-aarch64/asm/openssl.gypi'],
            }, 'target_arch=="ia32" and OS=="linux"', {
              'includes': ['config/archs/linux-elf/asm/openssl.gypi'],
            }, 'target_arch=="ia32" and OS=="mac"', {
              'includes': ['config/archs/darwin-i386-cc/asm/openssl.gypi'],
            }, 'target_arch=="ia32" and OS=="solaris"', {
              'includes': ['config/archs/solaris-x86-gcc/asm/openssl.gypi'],
            }, 'target_arch=="ia32" and OS=="win"', {
              'includes': ['config/archs/VC-WIN32/asm/openssl.gypi'],
            }, 'target_arch=="ia32"', {
              # noasm linux-elf for other ia32 platforms
              'includes': ['config/archs/linux-elf/no-asm/openssl.gypi'],
            }, 'target_arch=="x64" and OS=="freebsd"', {
              'includes': ['config/archs/BSD-x86_64/asm/openssl.gypi'],
            }, 'target_arch=="x64" and OS=="mac"', {
              'includes': ['config/archs/darwin64-x86_64-cc/asm/openssl.gypi'],
            }, 'target_arch=="x64" and OS=="solaris"', {
              'includes': ['config/archs/solaris64-x86_64-gcc/asm/openssl.gypi'],
            }, 'target_arch=="x64" and OS=="win"', {
              'includes': ['config/archs/VC-WIN64A/asm/openssl.gypi'],
            }, 'target_arch=="x64" and OS=="linux"', {
              'includes': ['config/archs/linux-x86_64/asm/openssl.gypi'],
            }, {
              # Other architectures don't use assembly
              'includes': ['config/archs/linux-x86_64/no-asm/openssl.gypi'],
            }],
          ],
        }, {
          'defines': ['OPENSSL_NO_ASM'],
          'conditions': [
            ['target_arch=="arm" and OS=="linux"', {
              'includes': ['config/archs/linux-armv4/no-asm/openssl.gypi'],
            }, 'target_arch=="ia32" and OS=="mac"', {
              'includes': ['config/archs/darwin-i386-cc/no-asm/openssl.gypi'],
              'include_dirs': ['config/archs/darwin-i386-cc/no-asm'],
            }, 'target_arch=="ia32" and OS=="win"', {
            }, 'target_arch=="ia32" and OS=="linux"', {
              'includes': ['config/archs/linux-elf/no-asm/openssl.gypi'],
              'include_dirs': ['config/archs/linux-elf/no-asm'],
            }, 'target_arch=="ia32"', {
              # ia32 others
            }, 'target_arch=="x64" and OS=="mac"', {
              'includes': ['config/archs/darwin64-x86_64-cc/no-asm/openssl.gypi'],
              'include_dirs': ['config/archs/darwin64-x86_64-cc/no-asm'],
            }, 'target_arch=="x64" and OS=="win"', {
            }, 'target_arch=="x64" and OS=="linux"', {
              'includes': ['config/archs/linux-x86_64/no-asm/openssl.gypi'],
              'include_dirs': [
                'config/archs/linux-x86_64/no-asm',
                'config/archs/linux-x86_64/no-asm/include',
                'config/archs/linux-x86_64/no-asm/crypto',
                'config/archs/linux-x86_64/no-asm/crypto/include/internal',
              ],
            }, 'target_arch=="arm64" and OS=="linux"', {
            }, {
              # Other architectures don't use assembly.
            }],
          ],
        }],
      ],
      'direct_dependent_settings': {
        'include_dirs': [
          'openssl/include'
        ],
      }
    },
    {
      # openssl-cli target
      'target_name': 'openssl-cli',
      'type': 'executable',
      'dependencies': ['openssl'],
      'include_dirs': [
        'openssl/',
        'openssl/include/'
      ],
      'conditions': [
        ['openssl_no_asm==0', {
          'conditions': [
            ['target_arch=="ppc" and OS=="aix"', {
              'includes': ['config/archs/aix-gcc/asm/openssl-cl.gypi'],
            }, ['target_arch=="ppc" and OS=="linux"', {
              'includes': ['config/archs/linux-pcc/asm/openssl-cl.gypi'],
            }, ['target_arch=="ppc64" and OS=="aix"', {
              'includes': ['config/archs/aix64-gcc/asm/openssl-cl.gypi'],
            }, ['target_arch=="ppc64" and OS=="linux"', {
              'includes': ['config/archs/linux-ppc64/asm/openssl-cl.gypi'],
            }, ['target_arch=="s390" and OS=="linux"', {
              'includes': ['config/archs/linux32-s390x/asm/openssl-cl.gypi'],
            }, ['target_arch=="s390x" and OS=="linux"', {
              'includes': ['config/archs/linux64-s390x/asm/openssl-cl.gypi'],
            }, ['target_arch=="arm" and OS=="linux"', {
              'includes': ['config/archs/linux-armv4/asm/openssl-cl.gypi'],
            }, 'target_arch=="arm64" and OS=="linux"', {
              'includes': ['config/archs/linux-aarch64/asm/openssl-cl.gypi'],
            }, 'target_arch=="ia32" and OS=="linux"', {
              'includes': ['config/archs/linux-elf/asm/openssl-cl.gypi'],
            }, 'target_arch=="ia32" and OS=="mac"', {
              'includes': ['config/archs/darwin-i386-cc/asm/openssl-cl.gypi'],
            }, 'target_arch=="ia32" and OS=="solaris"', {
              'includes': ['config/archs/solaris-x86-gcc/asm/openssl-cl.gypi'],
            }, 'target_arch=="ia32" and OS=="win"', {
              'includes': ['config/archs/VC-WIN32/asm/openssl-cl.gypi'],
            }, 'target_arch=="ia32"', {
              # noasm linux-elf for other ia32 platforms
              'includes': ['config/archs/linux-elf/no-asm/openssl-cl.gypi'],
            }, 'target_arch=="x64" and OS=="freebsd"', {
              'includes': ['config/archs/BSD-x86_64/asm/openssl-cl.gypi'],
            }, 'target_arch=="x64" and OS=="mac"', {
              'includes': ['config/archs/darwin64-x86_64-cc/asm/openssl-cl.gypi'],
            }, 'target_arch=="x64" and OS=="solaris"', {
              'includes': ['config/archs/solaris64-x86_64-gcc/asm/openssl-cl.gypi'],
            }, 'target_arch=="x64" and OS=="win"', {
              'includes': ['config/archs/VC-WIN64A/asm/openssl-cl.gypi'],
            }, 'target_arch=="x64" and OS=="linux"', {
              'includes': ['config/archs/linux-x86_64/asm/openssl-cl.gypi'],
            }, {
              # Other architectures don't use assembly
              'includes': ['config/archs/linux-x86_64/no-asm/openssl-cl.gypi'],
            }],
          ],
        }, {
          'conditions': [
            ['target_arch=="arm" and OS=="linux"', {
              'includes': ['config/archs/linux-armv4/no-asm/openssl-cl.gypi'],
            }, 'target_arch=="ia32" and OS=="mac"', {
              'includes': ['config/archs/darwin-i386-cc/no-asm/openssl-cl.gypi'],
            }, 'target_arch=="ia32" and OS=="win"', {
            }, 'target_arch=="ia32" and OS=="linux"', {
              'includes': ['config/archs/linux-elf/no-asm/openssl-cl.gypi'],
            }, 'target_arch=="x64" and OS=="mac"', {
              'includes': ['config/archs/darwin64-x86_64-cc/no-asm/openssl-cl.gypi'],
            }, 'target_arch=="x64" and OS=="win"', {
            }, 'target_arch=="x64" and OS=="linux"', {
              'includes': ['config/archs/linux-x86_64/no-asm/openssl-cl.gypi'],
            }, 'target_arch=="arm64" and OS=="linux"', {
            }, { # other archs
            }],
          ],
        }],
      ],
    },
  ],
}
