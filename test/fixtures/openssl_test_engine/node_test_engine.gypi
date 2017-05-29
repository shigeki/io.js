{
  'sources': ['node_test_engine.c'],
  'conditions': [
    ['OS=="win"', {
      'library_dirs': ['<(LIB_DIR)'],
      'libraries': [
        '-lkernel32.lib',
        '-luser32.lib',
        '-lgdi32.lib',
        '-lwinspool.lib',
        '-lcomdlg32.lib',
        '-ladvapi32.lib',
        '-lshell32.lib',
        '-lole32.lib',
        '-loleaut32.lib',
        '-luuid.lib',
        '-lodbc32.lib',
        '-lDelayImp.lib',
      ],
    },],
    [ 'OS in "freebsd openbsd netbsd solaris" or \
    (OS=="linux" and target_arch!="ia32")', {
      'cflags': ['-fPIC']
    }],
  ],
}
