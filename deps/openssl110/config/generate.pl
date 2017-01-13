#! /usr/bin/env perl
use configdata;

my $asm = $ARGV[0];
my $arch = $ARGV[1];

my $is_win = ($arch =~/^VC-WIN/);
my $makefile;

if ($is_win) {
    $makefile = "../config/Makefile_$arch";
} else {
    $makefile = 'Makefile';
}

my $base_dir = "../config/archs/$arch/$asm";

my $cmd1 = "
cd ../openssl; make -f $makefile build_generated crypto/buildinf.h;
if [ ! -d $base_dir/crypto/include/internal ]; then mkdir -p $base_dir/crypto/include/internal ; fi
if [ ! -d $base_dir/include/openssl ]; then mkdir -p $base_dir/include/openssl ; fi
cp ../openssl/configdata.pm $base_dir/;
cp ../openssl/include/openssl/opensslconf.h $base_dir/include/openssl/;
mv ../openssl/crypto/include/internal/bn_conf.h $base_dir/crypto/include/internal/;
mv ../openssl/crypto/include/internal/dso_conf.h $base_dir/crypto/include/internal/;
cp ../openssl/crypto/buildinf.h $base_dir/crypto/;
";

my $ret1 = system($cmd1);

my @libssl_srcs = ();
foreach my $obj (@{$unified_info{sources}->{libssl}}) {
    push(@libssl_srcs, ${$unified_info{sources}->{$obj}}[0]);
}

my @libcrypto_srcs = ();
my @generated_srcs = ();
foreach my $obj (@{$unified_info{sources}->{libcrypto}}) {
    my $src = ${$unified_info{sources}->{$obj}}[0];
    # .S files should be proprocessed into .s
    if ($unified_info{generate}->{$src}) {
        # .S or .s files should be proprocessed into .asm for WIN
        if ($is_win) {
            $src =~ s\.[sS]$\.asm\;
        }
        push(@generated_srcs, $src);
    } else {
        push(@libcrypto_srcs, $src);
    }
}

my @apps_openssl = ();
foreach my $obj (@{$unified_info{sources}->{'apps/openssl'}}) {
    push(@apps_openssl_srcs, ${$unified_info{sources}->{$obj}}[0]);
}

foreach my $src (@generated_srcs) {
    $cmd = "cd ../openssl; CC=gcc ASM=nasm make -f $makefile $src; cp --parents $src ../config/archs/$arch/$asm; cd ../config";
    system("$cmd");
}

open(GYPI, "> ../config/archs/$arch/$asm/openssl.gypi");

print GYPI "{
  'variables': {
    'openssl_sources': [\n";

foreach my $src (@libssl_srcs) {
    print GYPI "      'openssl/$src',\n";
}

foreach my $src (@libcrypto_srcs) {
    print GYPI "      'openssl/$src',\n";
}

print GYPI "    ],\n";

print GYPI "    'openssl_sources_$arch': [\n";
foreach my $src (@generated_srcs) {
    print GYPI "      './config/archs/$arch/$asm/$src',\n";
}
print GYPI "    ],\n";

print GYPI "    'openssl_defines_$arch': [\n";
foreach my $define (@{$config{defines}}) {
    print GYPI "      '$define',\n";
}
print GYPI "    ],\n";
print GYPI "    'openssl_cflags_$arch': [\n";
print GYPI "      '$target{cflags}',\n";
print GYPI "    ],\n";
print GYPI "    'openssl_ex_libs_$arch': [\n";
print GYPI "      '$target{ex_libs}',\n";
print GYPI "    ],\n";
print GYPI "  },\n";
print GYPI "  'include_dirs': [\n";
print GYPI "    '.',\n";
print GYPI "    './include',\n";
print GYPI "    './crypto',\n";
print GYPI "    './crypto/include/internal',\n";
print GYPI "  ],\n";
print GYPI "  'defines': ['<@(openssl_defines_$arch)'],\n";
print GYPI "  'cflags' : ['<@(openssl_cflags_$arch)'],\n" unless ($is_win);
print GYPI "  'libraries': ['<@(openssl_ex_libs_$arch)'],\n" unless ($is_win);
print GYPI "  'sources': ['<@(openssl_sources)', '<@(openssl_sources_$arch)'],\n";
print GYPI "}\n";

close(GYPI);

open(CLGYPI, "> ../config/archs/$arch/$asm/openssl-cl.gypi");
print CLGYPI "{
  'variables': {\n";
print CLGYPI "    'openssl_defines_$arch': [\n";
foreach my $define (@{$config{defines}}) {
    print CLGYPI "      '$define',\n";
}
print CLGYPI "    ],\n";

print CLGYPI "    'openssl_cflags_$arch': [\n";
print CLGYPI "      '$target{cflags}',\n";
print CLGYPI "    ],\n";

print CLGYPI "    'openssl_ex_libs_$arch': [\n";
print CLGYPI "      '$target{ex_libs}',\n";
print CLGYPI "    ],\n";

print CLGYPI "    'openssl_cli_srcs_$arch': [\n";
foreach my $src (@apps_openssl_srcs) {
    print CLGYPI "      'openssl/$src',\n";
}
print CLGYPI "    ],\n";
print CLGYPI "  },\n";
print CLGYPI "  'defines': ['<@(openssl_defines_$arch)'],\n";
print CLGYPI "  'cflags' : ['<@(openssl_cflags_$arch)'],\n" unless ($is_win);
print CLGYPI "  'libraries': ['<@(openssl_ex_libs_$arch)'],\n" unless ($is_win);
print CLGYPI "  'sources': ['<@(openssl_cli_srcs_$arch)'],\n";
print CLGYPI "}\n";

close(CLGYPI);

my $cmd2 ="cd ../openssl; make -f $makefile clean; make -f $makefile distclean; find ../openssl/crypto \\( -name \*.S -o -name \*.s -o -name \*.asm \\) -exec rm '{}' \\;";
my $ret2 = system($cmd2);
