{
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
      'defines': ['OPENSSLDIR="/etc/ssl"'],
    }, 'OS=="win"', {
      'defines': [
        ## default of Win. See INSTALL in openssl repo.
        'OPENSSLDIR="C:\Program Files\Common Files\SSL"'
        'ENGINESDIR="nul"',
        'PURIFY', '_REENTRANT', 'OPENSSL_NO_SSL2',
        'OPENSSL_NO_SSL3', 'OPENSSL_NO_HEARTBEATS', 'MK1MF_BUILD',
        'WIN32_LEAN_AND_MEAN', 'OPENSSL_SYSNAME_WIN32', 'WIN32',
        '_CRT_SECURE_NO_DEPRECATE', '_CRT_NONSTDC_NO_DEPRECATE',
        '_HAS_EXCEPTIONS=0', 'BUILDING_V8_SHARED=1',
        'BUILDING_UV_SHARED=1', 'L_ENDIAN', 'DSO_WIN32',
        'OPENSSL_NO_DYNAMIC_ENGINE', 'OPENSSL_NO_CAPIENG',
      ],
    }, 'OS=="mac"', {
      'xcode_settings': {
        'WARNING_CFLAGS': ['-Wno-missing-field-initializers']
      },
      'defines': ['OPENSSLDIR="/System/Library/OpenSSL/"'],
    }, 'OS=="solaris"', {
      'defines': ['__EXTENSIONS__'],
      'defines': ['OPENSSLDIR="/etc/ssl"'],
    }, {
      # linux and others
      'cflags': ['-Wno-missing-field-initializers',
                 ## TODO: check gcc_version>=4.3
                 '-Wno-old-style-declaration'],
      'defines': [
        'ENGINESDIR="/dev/null"',
        'TERMIOS',
      ],
      'defines': ['OPENSSLDIR="/etc/ssl"'],
    }],
  ]
}
