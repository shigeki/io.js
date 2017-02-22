'use strict';
const common = require('../common');

// Verify that detailed getPeerCertificate() return value has all certs.

if (!common.opensslCli) {
  common.skip('node compiled without OpenSSL CLI.');
  return;
}

const join = require('path').join;
const {
  assert, connect, debug, keys
} = require(join(common.fixturesDir, 'tls-connect'))();

const agent1_info = common.getCertInfo(common.fixturesDir +
                                       '/keys/agent1-cert.pem');
const ca1_info = common.getCertInfo(common.fixturesDir +
                                    '/keys/ca1-cert.pem');

connect({
  client: {rejectUnauthorized: false},
  server: keys.agent1,
}, function(err, pair, cleanup) {
  assert.ifError(err);
  const socket = pair.client.conn;
  let peerCert = socket.getPeerCertificate();
  assert.ok(!peerCert.issuerCertificate);

  peerCert = socket.getPeerCertificate(true);
  debug('peerCert:\n', peerCert);

  assert.ok(peerCert.issuerCertificate);
  assert.strictEqual(peerCert.subject.emailAddress, 'ry@tinyclouds.org');
  assert.strictEqual(peerCert.serialNumber, agent1_info.serial);
  assert.strictEqual(peerCert.exponent, '0x10001');
  assert.strictEqual(
    peerCert.fingerprint,
    agent1_info.fingerprint
  );
  assert.deepStrictEqual(peerCert.infoAccess['OCSP - URI'],
                         [ 'http://ocsp.nodejs.org/' ]);

  const issuer = peerCert.issuerCertificate;
  assert.strictEqual(issuer.issuerCertificate, issuer);
  assert.strictEqual(issuer.serialNumber, ca1_info.serial);

  return cleanup();
});
