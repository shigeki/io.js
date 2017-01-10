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
      'defines': [
        # Compression is not used and considered insecure (CRIME.)
        'OPENSSL_NO_COMP',

        # SSLv3 is susceptible to downgrade attacks (POODLE.)
        'OPENSSL_NO_SSL3',

        # Heartbeat is a TLS extension, that couldn't be turned off or
        # asked to be not advertised. Unfortunately this is unacceptable for
        # Microsoft's IIS, which seems to be ignoring whole ClientHello after
        # seeing this extension.
        'OPENSSL_NO_HEARTBEATS',

        # Compile out hardware engines.  Most are stubs that dynamically load
        # the real driver but that poses a security liability when an attacker
        # is able to create a malicious DLL in one of the default search paths.
        'OPENSSL_NO_HW',
      ],
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
        ['openssl_no_asm==0', {
          'includes': ['./openssl-cl_asm.gypi'],
        }, {
          'includes': ['./openssl-cl_no_asm.gypi'],
        }],
      ],
    },
  ],
}
