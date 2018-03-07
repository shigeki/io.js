## Upgrading OpenSSL-1.1.0

### Requirements
- perl (perl5. Not tested perl6 yet.)
- nasm (http://www.nasm.us/)  The version of 2.10 or higher is needed.
- makedepend command
- Linux enviroment (Only CentOS7.1 and Ubuntu16 are tested)

### 1. obtain and extract new OpenSS sources.

Get a new source from  https://www.openssl.org/source/ and extract
them into `deps/openssl/openssl`. Then commit them.

### 2. execute `make` in `deps/openssl/config` directory.

This generates all platform dependent files into
`deps/openssl/config/archs` directory.

```
$ make
if [ -e ../openssl/.gitignore ]; then rm ../openssl/.gitignore; fi
cd ../openssl; perl ./Configure no-shared no-comp no-ssl3 no-afalgeng
aix-gcc;
rm -f configdata.pm
rm -f makefile
rm -f NUL
make[1]: Leaving directory
`/home/sotsu/github/shigeki/node/deps/openssl/openssl'
cp ./opensslconf.h.tmpl ../openssl/include/openssl/opensslconf.h
$
```

### 3. Check diffs

Check diffs if updates are right. When sources files or build options
are updated, check if they also updates Windows(VC-WIN64A and
VC-WIN32). If not, update `Makefile_VC-WIN64A` and `Makefile_VC-WIN32`
by hand and re-execute `make`.

Even if no updates, `buildinf.h` files are updates for they have a
timestamp of its update.

### 4. Commits and make test

Commits updates and make test. Do not forget to git add or remove
files if they are changed before commit.
