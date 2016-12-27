MAKE    = make
PERL    = perl
CONFIGURE = ./Configure
COPT = no-shared no-threads

ARCHS = aix-gcc aix64-gcc BSD-x86 BSD-x86_64 \
darwin64-x86_64-cc darwin-i386-cc linux-aarch64 \
linux-armv4 linux-elf linux-x32 linux-x86_64 linux-ppc \
linux-ppc64 linux32-s390x linux64-s390x solaris-x86-gcc \
solaris64-x86_64-gcc

# Temporary remove VC-WIN32 VC-WIN64A for NASM support

CFG = opensslconf.h
OPSSL_SRC = ../openssl
SRC_CFG = $(OPSSL_SRC)/include/openssl/$(CFG)
INT_CFGS = bn_conf.h dso_conf.h
INT_CFG_DIR = $(OPSSL_SRC)/crypto/include/internal

BACKUP_FILES = ../openssl/Makefile ../openssl/Makefile.bak $(SRC_CFG)
BACKUP_EXT = nodebackup

# OPENSSL_CPUID_OBJ is defined in openssl.gypi for use --openssl-no-asm
CPUIDFIX = 's/\#define OPENSSL_CPUID_OBJ$$//;'

PHONY = all clean backup restore
.PHONY: $(PHONY)

all: $(ARCHS) replace

$(ARCHS):
	cd ../openssl; $(PERL) $(CONFIGURE) $(COPT) $@ > /dev/null; \
	$(MAKE) build_generated crypto/buildinf.h > /dev/null
	if [ ! -d ./archs/$@ ]; then mkdir ./archs/$@ ; fi
	$(PERL) -p -e $(CPUIDFIX) $(SRC_CFG) > ./archs/$@/$(CFG)
	@for c in $(INT_CFGS); do \
	    mv $(INT_CFG_DIR)/$$c ./archs/$@/$$c; \
	done
	cp $(OPSSL_SRC)/crypto/buildinf.h ../config/archs/$@/
	cp $(OPSSL_SRC)/configdata.pm ./archs/$@/
	./generate.pl $@
	cd ../openssl; make clean > /dev/null; make distclean > /dev/null
	cd ../openssl; find crypto \( -name \*.S \) -exec rm "{}" \;
replace:
	cp ./$(CFG).tmpl $(SRC_CFG)
	@for c in $(INT_CFGS); do \
	    cp ./$$c.tmpl $(INT_CFG_DIR)/$$c; \
	done

# backup files to avoid to be overwritten
backup:
	@for f in $(BACKUP_FILES); do \
	    mv $$f $$f.$(BACKUP_EXT); \
	done

restore:
	@for f in $(BACKUP_FILES); do \
	    mv $$f.$(BACKUP_EXT) $$f ; \
	done

# remove unnecessary files create by Configure
cleanconf:
	cd ../openssl; make distclean

clean:
	find archs \( -name \*.S -o -name \*.s -o -name \*.gypi -o -name \*.h -o -name \*.pm \) -exec rm "{}" \;
