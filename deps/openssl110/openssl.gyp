{
  'variables': {
    'openssl_no_asm%': 0,
  },
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
        }],
        ['openssl_no_asm!=0', {
          # Disable asm
          'defines': [
            'OPENSSL_NO_ASM',
          ],
          'sources': ['<@(openssl_sources_no_asm)'],
        }, {
          # "else if" was supported in https://codereview.chromium.org/601353002
          'conditions': [
            ['target_arch=="arm" and OS=="linux"', {
             'include_dirs': ['config/archs/linux-armv4/'],
             'includes': ['config/archs/linux-armv4/openssl.gypi'],
              'defines': [
                'OPENSSL_CPUID_OBJ',
                'ENGINESDIR="/dev/null"',
                'OPENSSLDIR="/etc/ssl"',
                '<@(openssl_defines_linux-armv4)',
              ],
              'cflags' : ['<@(openssl_cflags_linux-armv4)'],
              'libraries': ['<@(openssl_ex_libs_linux-armv4)'],
              'sources': ['<@(openssl_sources)', '<@(openssl_sources_linux-armv4)'],
            }, 'target_arch=="ia32" and OS=="mac"', {
             'include_dirs': ['config/archs/darwin-i386-cc/'],
             'includes': ['config/archs/darwin-i386-cc/openssl.gypi'],
              'defines': [
                'OPENSSL_CPUID_OBJ',
                'ENGINESDIR="/dev/null"',
                'OPENSSLDIR="/etc/ssl"',
                '<@(openssl_defines_darwin-i386-cc)',
              ],
              'cflags' : ['<@(openssl_cflags_darwin-i386-cc)'],
              'libraries': ['<@(openssl_ex_libs_darwin-i386-cc)'],
              'sources': ['<@(openssl_sources)', '<@(openssl_sources_darwin-i386-cc)'],
            }, 'target_arch=="ia32" and OS=="win"', {
            }, 'target_arch=="ia32" and OS=="linux"', {
             'include_dirs': ['config/archs/linux-elf/'],
             'includes': ['config/archs/linux-elf/openssl.gypi'],
              # Linux or others
              'defines': [
                'OPENSSL_CPUID_OBJ',
                'ENGINESDIR="/dev/null"',
                'OPENSSLDIR="/etc/ssl"',
                '<@(openssl_defines_linux-elf)',
              ],
              'cflags' : ['<@(openssl_cflags_linux-elf)'],
              'libraries': ['<@(openssl_ex_libs_linux-elf)'],
              'sources': ['<@(openssl_sources)', '<@(openssl_sources_linux-elf)'],
            }, 'target_arch=="ia32"', {
              # ia32 others
            }, 'target_arch=="x64" and OS=="mac"', {
             'include_dirs': ['config/archs/darwin64-x86_64-cc/'],
             'includes': ['config/archs/darwin64-x86_64-cc/openssl.gypi'],
              'defines': [
                'OPENSSL_CPUID_OBJ',
                'ENGINESDIR="/dev/null"',
                'OPENSSLDIR="/etc/ssl"',
                '<@(openssl_defines_darwin64-x86_64-cc)',
              ],
              'cflags' : ['<@(openssl_cflags_darwin64-x86_64-cc)'],
              'libraries': ['<@(openssl_ex_libs_darwin64-x86_64-cc)'],
              'sources': ['<@(openssl_sources)', '<@(openssl_sources_darwin64-x86_64-cc)'],
            }, 'target_arch=="x64" and OS=="win"', {
            }, 'target_arch=="x64" and OS=="linux"', {
             'include_dirs': ['config/archs/linux-x86_64/'],
             'includes': ['config/archs/linux-x86_64/openssl.gypi'],
              # Linux or others
              'defines': [
                'OPENSSL_CPUID_OBJ',
                'ENGINESDIR="/dev/null"',
                'OPENSSLDIR="/etc/ssl"',
                '<@(openssl_defines_linux-x86_64)',
              ],
              'cflags' : ['<@(openssl_cflags_linux-x86_64)'],
              'libraries': ['<@(openssl_ex_libs_linux-x86_64)'],
              'sources': ['<@(openssl_sources)', '<@(openssl_sources_linux-x86_64)'],
            }, 'target_arch=="arm64" and OS=="linux"', {
            }, {
              # Other architectures don't use assembly.
            }],
          ],
        }], # end of conditions of openssl_no_asm
      ],
      'direct_dependent_settings': {
        'include_dirs': [
          'openssl/include'
        ],
      },
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
         ['target_arch=="arm" and OS=="linux"', {
             'includes': ['config/archs/linux-armv4/openssl.gypi'],
             'cflags': ['<@(openssl_cflags_linux-armv4)'],
             'defines': ['<@(openssl_defines_linux-armv4)'],
             'sources': ['<@(openssl_cli_srcs_linux-armv4)'],
             'libraries': ['<@(openssl_ex_libs_linux-armv4)'],
           }, 'target_arch=="ia32" and OS=="mac"', {
             'includes': ['config/archs/darwin-i386-cc/openssl.gypi'],
             'cflags': ['<@(openssl_cflags_darwin-i386-cc)'],
             'defines': ['<@(openssl_defines_darwin-i386-cc)'],
             'sources': ['<@(openssl_cli_srcs_darwin-i386-cc)'],
             'libraries': ['<@(openssl_ex_libs_darwin-i386-cc)'],
           }, 'target_arch=="ia32" and OS=="win"', {
           }, 'target_arch=="ia32" and OS=="linux"', {
             'includes': ['config/archs/linux-elf/openssl.gypi'],
             'cflags': ['<@(openssl_cflags_linux-elf)'],
             'defines': ['<@(openssl_defines_linux-elf)'],
             'sources': ['<@(openssl_cli_srcs_linux-elf)'],
             'libraries': ['<@(openssl_ex_libs_linux-elf)'],
           }, 'target_arch=="x64" and OS=="mac"', {
             'includes': ['config/archs/darwin64-x86_64-cc/openssl.gypi'],
             'cflags': ['<@(openssl_cflags_darwin64-x86_64-cc)'],
             'defines': ['<@(openssl_defines_darwin64-x86_64-cc)'],
             'sources': ['<@(openssl_cli_srcs_darwin64-x86_64-cc)'],
             'libraries': ['<@(openssl_ex_libs_darwin64-x86_64-cc)'],
           }, 'target_arch=="x64" and OS=="win"', {
           }, 'target_arch=="x64" and OS=="linux"', {
             'includes': ['config/archs/linux-x86_64/openssl.gypi'],
             'cflags': ['<@(openssl_cflags_linux-x86_64)'],
             'defines': ['<@(openssl_defines_linux-x86_64)'],
             'sources': ['<@(openssl_cli_srcs_linux-x86_64)'],
             'libraries': ['<@(openssl_ex_libs_linux-x86_64)'],
           }, 'target_arch=="arm64" and OS=="linux"', {
           }, { # other archs
           }
          ],
        ],
     }
  ],
}

# Local Variables:
# tab-width:2
# indent-tabs-mode:nil
# End:
# vim: set expandtab tabstop=2 shiftwidth=2:
