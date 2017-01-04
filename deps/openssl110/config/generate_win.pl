#! /usr/bin/env perl
use lib "./archs/$ARGV[1]/$ARGV[0]/";
use configdata;

$conf_opt = $ARGV[0];
$arch = $ARGV[1];

my @libssl_srcs = ();
foreach my $obj (@{$unified_info{sources}->{libssl}}) {
    push(@libssl_srcs, ${$unified_info{sources}->{$obj}}[0]);
}

my @libcrypto_srcs = ();
my @generated_srcs = ();
foreach my $obj (@{$unified_info{sources}->{libcrypto}}) {
    my $src = ${$unified_info{sources}->{$obj}}[0];

    if ($unified_info{generate}->{$src}) {
        # .S or .s files should be proprocessed into .asm
        $src =~ s\.[sS]$\.asm\;
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
    $cmd = "cd ../openssl; CC=gcc ASM=nasm make -f ../config/Makefile_VC-WIN64A $src; cp --parents $src ../config/archs/$arch/$conf_opt; cd ../config";
    system("$cmd");
}

open(GYPI, "> ../config/archs/$arch/$conf_opt/openssl.gypi");

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
    print GYPI "      './config/archs/$arch/$conf_opt/$src',\n";
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
print GYPI "  'cflags' : ['<@(openssl_cflags_$arch)'],\n";
print GYPI "  'libraries': ['<@(openssl_ex_libs_$arch)'],\n";
print GYPI "  'sources': ['<@(openssl_sources)', '<@(openssl_sources_$arch)'],\n";
print GYPI "}\n";

close(GYPI);

open(CLGYPI, "> ../config/archs/$arch/$conf_opt/openssl-cl.gypi");
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
print CLGYPI "  'cflags' : ['<@(openssl_cflags_$arch)'],\n";
print CLGYPI "  'libraries': ['<@(openssl_ex_libs_$arch)'],\n";
print CLGYPI "  'sources': ['<@(openssl_cli_srcs_$arch)'],\n";
print CLGYPI "}\n";

close(CLGYPI);
