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
        'OPENSSL_CPUID_OBJ',
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
        ['target_arch=="arm" and OS=="linux"', {
          'includes': ['config/archs/linux-armv4/openssl.gypi'],
        }, 'target_arch=="ia32" and OS=="mac"', {
          'include_dirs': ['config/archs/darwin-i386-cc/'],
          'includes': ['config/archs/darwin-i386-cc/openssl.gypi'],
        }, 'target_arch=="ia32" and OS=="win"', {
        }, 'target_arch=="ia32" and OS=="linux"', {
          'include_dirs': ['config/archs/linux-elf/'],
          'includes': ['config/archs/linux-elf/openssl.gypi'],
        }, 'target_arch=="ia32"', {
          # ia32 others
        }, 'target_arch=="x64" and OS=="mac"', {
          'include_dirs': ['config/archs/darwin64-x86_64-cc/'],
          'includes': ['config/archs/darwin64-x86_64-cc/openssl.gypi'],
        }, 'target_arch=="x64" and OS=="win"', {
        }, 'target_arch=="x64" and OS=="linux"', {
          'include_dirs': ['config/archs/linux-x86_64/'],
          'includes': ['config/archs/linux-x86_64/openssl.gypi'],
        }, 'target_arch=="arm64" and OS=="linux"', {
        }, {
          # Other architectures don't use assembly.
        }],
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
          'includes': ['config/archs/linux-armv4/openssl-cl.gypi'],
        }, 'target_arch=="ia32" and OS=="mac"', {
          'includes': ['config/archs/darwin-i386-cc/openssl-cl.gypi'],
        }, 'target_arch=="ia32" and OS=="win"', {
        }, 'target_arch=="ia32" and OS=="linux"', {
          'includes': ['config/archs/linux-elf/openssl-cl.gypi'],
        }, 'target_arch=="x64" and OS=="mac"', {
          'includes': ['config/archs/darwin64-x86_64-cc/openssl-cl.gypi'],
        }, 'target_arch=="x64" and OS=="win"', {
        }, 'target_arch=="x64" and OS=="linux"', {
          'includes': ['config/archs/linux-x86_64/openssl-cl.gypi'],
        }, 'target_arch=="arm64" and OS=="linux"', {
        }, { # other archs
        }],
      ],
     }
  ],
}
