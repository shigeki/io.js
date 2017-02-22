'use strict';
const common = require('../common');

// Check cert chain is received by client, and is completed with the ca cert
// known to the client.

if (!common.opensslCli) {
  common.skip('node compiled without OpenSSL CLI.');
  return;
}

const join = require('path').join;
const {
  assert, connect, debug, keys
} = require(join(common.fixturesDir, 'tls-connect'))();

// peer Cert
const agen6_info = common.getCertInfo(common.fixturesDir +
                                    '/keys/agent6-cert.pem');
// issuer Cert
const ca3_info = common.getCertInfo(common.fixturesDir +
                                    '/keys/ca3-cert.pem');
// root Cert
const ca1_info = common.getCertInfo(common.fixturesDir +
                                    '/keys/ca1-cert.pem');

// agent6-cert.pem includes cert for agent6 and ca3
connect({
  client: {
    checkServerIdentity: (servername, cert) => { },
    ca: keys.agent6.ca,
  },
  server: {
    cert: keys.agent6.cert,
    key: keys.agent6.key,
  },
}, function(err, pair, cleanup) {
  assert.ifError(err);

  const peer = pair.client.conn.getPeerCertificate();
  debug('peer:\n', peer);
  assert.strictEqual(peer.subject.emailAddress, 'adam.lippai@tresorit.com');
  assert.strictEqual(peer.subject.CN, 'Ádám Lippai'),
  assert.strictEqual(peer.issuer.CN, 'ca3');
  assert.strictEqual(peer.serialNumber, agen6_info.serial);

  const next = pair.client.conn.getPeerCertificate(true).issuerCertificate;
  const root = next.issuerCertificate;
  delete next.issuerCertificate;
  debug('next:\n', next);
  assert.strictEqual(next.subject.CN, 'ca3');
  assert.strictEqual(next.issuer.CN, 'ca1');
  assert.strictEqual(next.serialNumber, ca3_info.serial);

  debug('root:\n', root);
  assert.strictEqual(root.subject.CN, 'ca1');
  assert.strictEqual(root.issuer.CN, 'ca1');
  assert.strictEqual(root.serialNumber, ca1_info.serial);

  // No client cert, so empty object returned.
  assert.deepStrictEqual(pair.server.conn.getPeerCertificate(), {});
  assert.deepStrictEqual(pair.server.conn.getPeerCertificate(true), {});

  return cleanup();
});
