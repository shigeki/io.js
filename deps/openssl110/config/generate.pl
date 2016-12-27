#! /usr/bin/env perl
use lib "./archs/$ARGV[0]";
use configdata;

$arch = $ARGV[0];
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
       $src =~ s/\.S$/\.s/;
        push(@generated_srcs, $src);
    } else {
       $src =~ s/\.S$/\.s/;
        push(@libcrypto_srcs, $src);
    }
}

my @apps_openssl = ();
foreach my $obj (@{$unified_info{sources}->{'apps/openssl'}}) {
    push(@apps_openssl_srcs, ${$unified_info{sources}->{$obj}}[0]);
}

my $configdir = "../config";
my $archdir = "$configdir/archs/$arch";
unless (-d $archdir) {
    mkdir($archdir);
}

my $asmdir = "$archdir/asm";
unless (-d $asmdir) {
    mkdir($asmdir);
}

foreach my $src (@generated_srcs) {
    $cmd = "cd ../openssl; CC=gcc ASM=nasm make $src; cp --parents $src $asmdir; cd ../config";
    system("$cmd 2>$configdir/cms.err 1>$configdir/cms.out");
}

open(GYPI, "> archs/$arch/openssl_asm.gypi");

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
    print GYPI "      'config/archs/$arch/asm/$src',\n";
}
print GYPI "    ],\n";

print GYPI "    'openssl_defines_$arch': [\n";
foreach my $define (@{$config{defines}}) {
    print GYPI "      '$define',\n";
}
print GYPI "    ],\n";
print GYPI "  }
}\n";

close(GYPI);

# foreach my $src (@apps_openssl_srcs) {
#    print $src, "\n";
#}
