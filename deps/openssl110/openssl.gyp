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
            ['target_arch=="arm" and OS=="linux"', {
              'includes': ['config/archs/linux-armv4/asm/openssl.gypi'],
            }, 'target_arch=="ia32" and OS=="mac"', {
              'includes': ['config/archs/darwin-i386-cc/asm/openssl.gypi'],
              'include_dirs': ['config/archs/darwin-i386-cc/asm'],
            }, 'target_arch=="ia32" and OS=="win"', {
            }, 'target_arch=="ia32" and OS=="linux"', {
              'includes': ['config/archs/linux-elf/asm/openssl.gypi'],
              'include_dirs': ['config/archs/linux-elf/asm'],
            }, 'target_arch=="ia32"', {
              # ia32 others
            }, 'target_arch=="x64" and OS=="mac"', {
              'includes': ['config/archs/darwin64-x86_64-cc/asm/openssl.gypi'],
              'include_dirs': ['config/archs/darwin64-x86_64-cc/asm'],
            }, 'target_arch=="x64" and OS=="win"', {
            }, 'target_arch=="x64" and OS=="linux"', {
              'includes': ['config/archs/linux-x86_64/asm/openssl.gypi'],
              'include_dirs': [
                'config/archs/linux-x86_64/asm',
                'config/archs/linux-x86_64/asm/include',
                'config/archs/linux-x86_64/asm/crypto',
                'config/archs/linux-x86_64/asm/crypto/include/internal',
              ],
            }, 'target_arch=="arm64" and OS=="linux"', {
            }, {
              # Other architectures don't use assembly.
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
            ['target_arch=="arm" and OS=="linux"', {
              'includes': ['config/archs/linux-armv4/asm/openssl-cl.gypi'],
            }, 'target_arch=="ia32" and OS=="mac"', {
              'includes': ['config/archs/darwin-i386-cc/asm/openssl-cl.gypi'],
            }, 'target_arch=="ia32" and OS=="win"', {
            }, 'target_arch=="ia32" and OS=="linux"', {
              'includes': ['config/archs/linux-elf/asm/openssl-cl.gypi'],
            }, 'target_arch=="x64" and OS=="mac"', {
              'includes': ['config/archs/darwin64-x86_64-cc/asm/openssl-cl.gypi'],
            }, 'target_arch=="x64" and OS=="win"', {
            }, 'target_arch=="x64" and OS=="linux"', {
              'includes': ['config/archs/linux-x86_64/asm/openssl-cl.gypi'],
            }, 'target_arch=="arm64" and OS=="linux"', {
            }, { # other archs
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
