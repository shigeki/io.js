SED     = sed
PERL    = perl
CONFIGURE = ./Configure
CONFIGOPT = no-shared no-symlinks
ARCS = BSD-x86 BSD-x86_64 VC-WIN32 VC-WIN64A darwin64-x86_64-cc darwin-i386-cc linux-armv4 linux-elf linux-x86_64 solaris-x86-gcc solaris64-x86_64-gcc

OPENSSLDIR =
BACKUP_FILES = ../openssl/Makefile ../openssl/Makefile.bak ../openssl/crypto/opensslconf.h
BACKUP_EXT = iojsbackup

PHONY = all clean backup restore
.PHONY: $(PHONY)

all: backup $(ARCS) linux-x32 cleanconf fixdarwin64 fixwin restore

$(ARCS):
	cd ../openssl; $(PERL) $(CONFIGURE) $(CONFIGOPT) $@ > /dev/null
	$(SED) -e 's/#define OPENSSL_CPUID_OBJ//' ../openssl/crypto/opensslconf.h > ./archs/$@/opensslconf.h

# linux-x32 was made by comparing define values of opensslconf.h which
# was generated `Configure linux-x32' in openssl-1.0.2a
linux-x32:
	cd ../openssl; $(PERL) $(CONFIGURE) $(CONFIGOPT) linux-x86_64 > /dev/null;
	$(SED) -e 's/#define OPENSSL_CPUID_OBJ//' -e 's/#define RC4_CHUNK unsigned long/#define RC4_CHUNK unsigned long long/' -e 's/#define SIXTY_FOUR_BIT_LONG/#undef SIXTY_FOUR_BIT_LONG/' -e 's/#undef SIXTY_FOUR_BI/#define SIXTY_FOUR_BIT/' ../openssl/crypto/opensslconf.h > ./archs/$@/opensslconf.h

# The current openssl relase does not use RC4 asm since it explicitly
# specified as `$asm=~s/rc4\-[^:]+//;` in
# https://github.com/openssl/openssl/blob/OpenSSL_1_0_1-stable/Configure#L584
# But iojs has used RC4 asm on MacOS for long time. Fix type of RC4_INT
# into `unsinged int` in opensslconf.h of darwin64-x86_64-cc to work on
# the RC4 asm.
fixdarwin64:
	$(SED) -i -e 's/#define RC4_INT unsigned char/\/* Fixed by Makefile *\/\n#define RC4_INT unsigned int\n\/* end of Fix *\//' ./archs/darwin64-x86_64-cc/opensslconf.h


# OPENSSL_NO_DYNAMIC_ENGINE is needed for building static
# library. OPENSSL_NO_CAPIENG is needed to avoid build errors on
# Win. See the comments in `deps/openssl/openssl/engines/e_capi.c` for
# detail.
fixwin:
	$(SED) -i -e 's/#ifndef OPENSSL_DOING_MAKEDEPEND/#ifndef OPENSSL_DOING_MAKEDEPEND\n\n\/* Fixed by Makefile *\/\n#ifndef OPENSSL_NO_DYNAMIC_ENGINE\n# define OPENSSL_NO_DYNAMIC_ENGINE\n#endif\n#ifndef OPENSSL_NO_CAPIENG\n# define OPENSSL_NO_CAPIENG\n#endif\n\/* end of Fix *\//' ./archs/VC-WIN32/opensslconf.h ./archs/VC-WIN64A/opensslconf.h


backup:
	@for f in $(BACKUP_FILES); do \
	    mv $$f $$f.$(BACKUP_EXT); \
	done

restore:
	@for f in $(BACKUP_FILES); do \
	    mv $$f.$(BACKUP_EXT) $$f ; \
	done

cleanconf:
	@rm ../openssl/crypto/opensslconf.h
	@rm ../openssl/Makefile
	@rm ../openssl/apps/CA.pl.bak
	@rm ../openssl/crypto/buildinf.h
	@rm ../openssl/crypto/opensslconf.h.bak
	@rm ../openssl/ms/version32.rc
	@rm ../openssl/tools/c_rehash.bak

clean:
	find archs -name opensslconf.h -exec rm "{}" \;
