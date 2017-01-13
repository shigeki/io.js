MAKE    = make
PERL    = perl
CONFIGURE = ./Configure
COPTS = no-shared no-comp no-ssl3 no-afalgeng no-threads
ARCHS = aix-gcc aix64-gcc BSD-x86_64 \
darwin64-x86_64-cc darwin-i386-cc linux-aarch64 \
linux-armv4 linux-elf linux-x32 linux-x86_64 linux-ppc \
linux-ppc64 linux32-s390x linux64-s390x solaris-x86-gcc \
solaris64-x86_64-gcc VC-WIN64A VC-WIN32

CFG = opensslconf.h
OPSSL_SRC = ../openssl
SRC_CFG = $(OPSSL_SRC)/include/openssl/$(CFG)
INT_CFGS = bn_conf.h dso_conf.h
INT_CFG_DIR = $(OPSSL_SRC)/crypto/include/internal

PHONY = all clean restore
.PHONY: $(PHONY)

all: $(ARCHS) replace

$(ARCHS):
	if [ -e ../openssl/.gitignore ]; then rm ../openssl/.gitignore ; fi
	cd ../openssl; $(PERL) ./Configure $(COPTS) $@;
	$(PERL) -I../openssl ./generate.pl asm $@
	cd ../openssl; $(PERL) ./Configure $(COPTS) no-asm $@;
	$(PERL) -I../openssl ./generate.pl no-asm $@

replace:
	cp ./$(CFG).tmpl $(SRC_CFG)
	@for c in $(INT_CFGS); do \
	    cp ./$$c.tmpl $(INT_CFG_DIR)/$$c; \
	done

clean:
	find archs \( -name \*.S -o -name \*.s -o -name \*.gypi -o -name \*.h -o -name \*.pm \) -exec rm "{}" \;
