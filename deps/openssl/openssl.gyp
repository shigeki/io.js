# Copyright (c) 2012 The Chromium Authors. All rights reserved.
# Use of this source code is governed by a BSD-style license that can be
# found in the LICENSE file.

{
  'variables': {
    'is_clang': 0,
    'gcc_version': 0,
    'openssl_no_asm%': 0
  },
  'includes': ['openssl.gypi'],
  'targets': [
    {
      'target_name': 'openssl',
      'type': '<(library)',
      'sources': ['<@(openssl_sources)'],
      'direct_dependent_settings': {
        'include_dirs': ['openssl/include'],
      },
      'conditions': [
        ['openssl_no_asm!=0', {
          # Disable asm
          'sources': ['<@(openssl_sources_no_asm)'],
        }, {
          # "else if" was supported in https://codereview.chromium.org/601353002
          'conditions': [
            ['target_arch=="arm"', {
              'sources': ['<@(openssl_sources_arm_void_gas)'],
            }, 'target_arch=="ia32" and OS=="mac"', {
              'sources': ['<@(openssl_sources_ia32_mac_gas)'],
            }, 'target_arch=="ia32" and OS=="win"', {
              'sources': ['<@(openssl_sources_ia32_win32_masm)'],
            }, 'target_arch=="ia32"', {
              # Linux or others
              'sources': ['<@(openssl_sources_ia32_elf_gas)'],
            }, 'target_arch=="x64" and OS=="mac"', {
              'sources': ['<@(openssl_sources_x64_mac_gas)'],
            }, 'target_arch=="x64" and OS=="win"', {
              'sources': ['<@(openssl_sources_x64_win32_masm)'],
            }, 'target_arch=="x64"', {
              # Linux or others
              'sources': ['<@(openssl_sources_x64_elf_gas)'],
            }, { # else other archtectures does not use asm
              'sources': ['<@(openssl_sources_no_asm)'],
            }],
          ],
        }],
        # masm rules for Win
        ['OS=="win"', {
          'includes': ['masm_compile.gypi',],
        }],
      ],
    },{
      # openssl-cli
      'includes': ['openssl-cli.gypi',],
    }
  ],
  'target_defaults': {
    'include_dirs': ['<@(openssl_include_dirs)'],
    'conditions': [
      ['openssl_no_asm!=0', {
        'defines': ['<@(openssl_defines_no_asm)'],
      }, {
        'conditions': [
          ['target_arch=="arm"', {
            'defines': ['<@(openssl_defines_arm)'],
          }, 'target_arch=="ia32" and OS=="mac"', {
            'defines': ['<@(openssl_defines_ia32_mac)'],
          }, 'target_arch=="ia32" and OS=="win"', {
            'defines': ['<@(openssl_defines_ia32_win)'],
          }, 'target_arch=="ia32"', {
            'defines': ['<@(openssl_defines_ia32_linux)'],
          }, 'target_arch=="x64" and OS=="mac"', {
            'defines': ['<@(openssl_defines_x64_mac)'],
          }, 'target_arch=="x64" and OS=="win"', {
            'defines': ['<@(openssl_defines_x64_win)'],
          }, 'target_arch=="x64"', {
            'defines': ['<@(openssl_defines_x64_linux)'],
          }, {
            'defines': ['<@(openssl_defines_no_asm)'],
          }],
        ],
      }],
      ['OS=="win"', {
        'msvs_disabled_warnings': ['<@(msvs_disabled_warnings)'],
        'link_settings': {
          'libraries': ['<@(openssl_default_libraries_win)'],
        }
      }, {
          'cflags': ['<@(openssl_cflags_unix)'],
      }],
      ['OS=="solaris"', {
        'defines': ['<@(openssl_defines_solaris)'],
      }],
    ],
  }, #end of target_defaults
}

# Local Variables:
# tab-width:2
# indent-tabs-mode:nil
# End:
# vim: set expandtab tabstop=2 shiftwidth=2:
