MAKE    = make
PERL    = perl
CONFIGURE = ./Configure
COPT = no-shared no-comp no-ssl3 no-afalgeng no-threads

ARCHS = aix-gcc aix64-gcc BSD-x86_64 \
darwin64-x86_64-cc darwin-i386-cc linux-aarch64 \
linux-armv4 linux-elf linux-x32 linux-x86_64 linux-ppc \
linux-ppc64 linux32-s390x linux64-s390x solaris-x86-gcc \
solaris64-x86_64-gcc

ARCHS_WIN = VC-WIN64A VC-WIN32

CFG = opensslconf.h
OPSSL_SRC = ../openssl
SRC_CFG = $(OPSSL_SRC)/include/openssl/$(CFG)
INT_CFGS = bn_conf.h dso_conf.h
INT_CFG_DIR = $(OPSSL_SRC)/crypto/include/internal

PHONY = all clean backup restore
.PHONY: $(PHONY)

all: $(ARCHS) $(ARCHS_WIN) replace

$(ARCHS):
	if [ -e ../openssl/.gitignore ]; then rm ../openssl/.gitignore ; fi
	if [ ! -d ./archs/$@/asm/crypto/include/internal ]; then mkdir -p ./archs/$@/asm/crypto/include/internal ; fi
	if [ ! -d ./archs/$@/asm/include/openssl ]; then mkdir -p ./archs/$@/asm/include/openssl ; fi
	cd ../openssl; $(PERL) $(CONFIGURE) $(COPT) $@ > /dev/null; \
	$(MAKE) build_generated crypto/buildinf.h > /dev/null;
	cp $(SRC_CFG) ./archs/$@/asm/include/openssl/;
	@for c in $(INT_CFGS); do \
	    mv $(INT_CFG_DIR)/$$c ./archs/$@/asm/crypto/include/internal/$$c; \
	done
	cp $(OPSSL_SRC)/crypto/buildinf.h ./archs/$@/asm/crypto/
	cp $(OPSSL_SRC)/configdata.pm ./archs/$@/asm/
	./generate.pl asm $@
	cd ../openssl; make clean > /dev/null; make distclean > /dev/null
	cd ../openssl; find crypto \( -name \*.S \) -exec rm "{}" \;
# NO_ASM
	if [ ! -d ./archs/$@/no-asm/crypto/include/internal ]; then mkdir -p ./archs/$@/no-asm/crypto/include/internal ; fi
	if [ ! -d ./archs/$@/no-asm/include/openssl ]; then mkdir -p ./archs/$@/no-asm/include/openssl ; fi
	cd ../openssl; $(PERL) $(CONFIGURE) $(COPT) no-asm $@ > /dev/null; \
	$(MAKE) build_generated crypto/buildinf.h > /dev/null
	cp $(SRC_CFG) ./archs/$@/no-asm/include/openssl/
	@for c in $(INT_CFGS); do \
	    mv $(INT_CFG_DIR)/$$c ./archs/$@/no-asm/crypto/include/internal/$$c; \
	done
	cp $(OPSSL_SRC)/crypto/buildinf.h ./archs/$@/no-asm/crypto/
	cp $(OPSSL_SRC)/configdata.pm ./archs/$@/no-asm/
	./generate.pl no-asm $@
	cd ../openssl; make clean > /dev/null; make distclean > /dev/null
	cd ../openssl; find crypto \( -name \*.S \) -exec rm "{}" \;

$(ARCHS_WIN):
	if [ ! -d ./archs/$@/asm/crypto/include/internal ]; then mkdir -p ./archs/$@/asm/crypto/include/internal ; fi
	if [ ! -d ./archs/$@/asm/include/openssl ]; then mkdir -p ./archs/$@/asm/include/openssl ; fi
	cd ../openssl; $(PERL) $(CONFIGURE) $(COPT) $@ > /dev/null; \
	$(MAKE) -f ../config/Makefile_$@ build_generated crypto/buildinf.h > /dev/null;
	cp $(SRC_CFG) ./archs/$@/asm/include/openssl/;
	@for c in $(INT_CFGS); do \
	    mv $(INT_CFG_DIR)/$$c ./archs/$@/asm/crypto/include/internal/$$c; \
	done
	cp $(OPSSL_SRC)/crypto/buildinf.h ./archs/$@/asm/crypto/
	cp $(OPSSL_SRC)/configdata.pm ./archs/$@/asm/
	./generate_win.pl asm $@
	cd ../openssl; make -f ../config/Makefile_$@ clean > /dev/null
	cd ../openssl; find crypto \( -name \*.S \) -exec rm "{}" \;
# NO_ASM
	if [ ! -d ./archs/$@/no-asm/crypto/include/internal ]; then mkdir -p ./archs/$@/no-asm/crypto/include/internal ; fi
	if [ ! -d ./archs/$@/no-asm/include/openssl ]; then mkdir -p ./archs/$@/no-asm/include/openssl ; fi
	cd ../openssl; $(PERL) $(CONFIGURE) $(COPT) no-asm $@ > /dev/null; \
	$(MAKE) -f ../config/Makefile_$@ build_generated crypto/buildinf.h > /dev/null
	cp $(SRC_CFG) ./archs/$@/no-asm/include/openssl/;
	@for c in $(INT_CFGS); do \
	    mv $(INT_CFG_DIR)/$$c ./archs/$@/no-asm/crypto/include/internal/$$c; \
	done
	cp $(OPSSL_SRC)/crypto/buildinf.h ./archs/$@/no-asm/crypto/
	cp $(OPSSL_SRC)/configdata.pm ./archs/$@/no-asm/
	./generate_win.pl no-asm $@
	cd ../openssl; make -f ../config/Makefile_$@ clean > /dev/null
	cd ../openssl; find crypto \( -name \*.S \) -exec rm "{}" \;

replace:
	cp ./$(CFG).tmpl $(SRC_CFG)
	@for c in $(INT_CFGS); do \
	    cp ./$$c.tmpl $(INT_CFG_DIR)/$$c; \
	done

clean:
	find archs \( -name \*.S -o -name \*.s -o -name \*.gypi -o -name \*.h -o -name \*.pm \) -exec rm "{}" \;
