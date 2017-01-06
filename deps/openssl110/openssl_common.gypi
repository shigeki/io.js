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
    }],
    [ 'OS=="win"', {
      'defines': [
        ## default of Win. See INSTALL in openssl repo.
        'OPENSSLDIR="C:\Program Files\Common Files\SSL"'
        'ENGINESDIR="nul"',
      ],
    }, {
      'cflags': ['-Wno-missing-field-initializers',
                 ## TODO: check gcc_version>=4.3
                 '-Wno-old-style-declaration'],
      'defines': [
        'ENGINESDIR="/dev/null"',
        'TERMIOS',
      ],
    }],
    [ 'OS=="mac"', {
      'xcode_settings': {
        'WARNING_CFLAGS': ['-Wno-missing-field-initializers']
      },
      'defines': ['OPENSSLDIR="/System/Library/OpenSSL/"'],
    }],
    [ 'OS=="solaris"', {
      'defines': ['__EXTENSIONS__'],
    }],
    [ 'OS!="win" or OS!="mac"', {
      # Linux and others
      # Set to ubuntu default path for convenience. If necessary,
      # override this at runtime with the SSL_CERT_DIR environment
      # variable.
      'defines': ['OPENSSLDIR="/etc/ssl"'],
    }],
  ],
}
