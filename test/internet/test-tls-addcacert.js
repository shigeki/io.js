'use strict';
const common = require('../common');

if (!common.hasCrypto) {
  common.skip('missing crypto');
  return;
}

const assert = require('assert');
const tls = require('tls');
const fs = require('fs');

function filenamePEM(n) {
  return require('path').join(common.fixturesDir, 'keys', n + '.pem');
}

function loadPEM(n) {
  return fs.readFileSync(filenamePEM(n));
}

const caCert = loadPEM('ca1-cert');

var opts = {
  host: 'www.nodejs.org',
  port: 443,
  rejectUnauthorized: true
};

const client1 = tls.connect(opts, common.mustCall(() => {
  client1.end();
}));

// SecureContext.addCACert() overwrites exisiting root store with
// preserving root cert entries. But option.ca is applied without
// SecureContext.addRootCerts() so that exiting root store are
// empty. This checks if built-in root CAs are not included in case
// of options.ca.
opts.ca = [caCert];
const client2 = tls.connect(opts);
client2.on('error', common.mustCall((err) => {
  assert.strictEqual(err.message, 'unable to get local issuer certificate');
}));
