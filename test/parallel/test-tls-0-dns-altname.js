'use strict';
const common = require('../common');
const assert = require('assert');

if (!common.hasCrypto) {
  common.skip('missing crypto');
  return;
}

/*
  This test is skipped due to failure in checking signature strength
  of 0-dns-key.pem that is Signature Algorithm: rsaEncryption with openssl-1.1.x
*/
if (!common.isOpenSSL10) {
  common.skip('due to openssl-' + process.versions.openssl);
  return;
}

const tls = require('tls');

const fs = require('fs');

const server = tls.createServer({
  key: fs.readFileSync(common.fixturesDir + '/keys/0-dns-key.pem'),
  cert: fs.readFileSync(common.fixturesDir + '/keys/0-dns-cert.pem')
}, function(c) {
  c.once('data', function() {
    c.destroy();
    server.close();
  });
}).listen(0, common.mustCall(function() {
  const c = tls.connect(this.address().port, {
    rejectUnauthorized: false
  }, common.mustCall(function() {
    const cert = c.getPeerCertificate();
    assert.strictEqual(cert.subjectaltname,
                       'DNS:google.com\0.evil.com, ' +
                           'DNS:just-another.com, ' +
                           'IP Address:8.8.8.8, ' +
                           'IP Address:8.8.4.4, ' +
                           'DNS:last.com');
    c.write('ok');
  }));
}));
