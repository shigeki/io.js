{
  'variables': {
    'is_clang%': 0,
    'gcc_version%': 0,
    'openssl_no_asm%': 0,
    'llvm_version%': 0,
    'xcode_version%': 0,
    'gas_version%': 0,
    'openssl_fips%': 'false',
  },
  'targets': [
    {
      'target_name': 'openssl',
      'type': '<(library)',
      'includes': ['./openssl_common.gypi'],
      'conditions': [
        [ 'openssl_no_asm==0 and target_arch!="s390x" and OS!="win"', {
          'includes': ['./openssl_asm.gypi'],
        }, {
          'includes': ['./openssl_no_asm.gypi'],
        }],
      ],
      'direct_dependent_settings': {
        'include_dirs': [ 'openssl/include']
      }
    }, {
      # openssl-cli target
      'target_name': 'openssl-cli',
      'type': 'executable',
      'dependencies': ['openssl'],
      'includes': ['./openssl_common.gypi'],
      'conditions': [
        ['openssl_no_asm==0 and target_arch!="s390x" and OS!="win"', {
          'includes': ['./openssl-cl_asm.gypi'],
        }, {
          'includes': ['./openssl-cl_no_asm.gypi'],
        }],
      ],
    },
  ],
}
