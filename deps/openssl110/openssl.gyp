{
  'variables':{
  'openssl_no_asm%': 0,
  },
  'conditions': [
    ['openssl_no_asm==0', {
      'includes': ['./openssl_asm.gypi'],
    }, {
      'includes': ['./openssl_no_asm.gypi'],
    },]
  ],
}
