'use strict';
const common = require('../common');
if (!common.hasCrypto)
  common.skip('missing crypto');

const assert = require('assert');
const tls = require('tls');
const fixtures = require('../common/fixtures');

let finished = 0;

function loadPEM(n) {
  return fixtures.readKey(`${n}.pem`);
}

const testCases = [
  { // agent10 is signed by fake-startcom-root with notBefore of
    // May 31 23:59:59 2016 GMT. It fails cert check.
    serverOpts: {
      key: loadPEM('agent10-key'),
      cert: loadPEM('agent10-cert')
    },
    clientOpts: {
      ca: loadPEM('fake-symantec-root-cert'),
      port: undefined,
      rejectUnauthorized: true
    },
    errorCode: 'CERT_REVOKED'
  },
  { // agent11 is signed by fake-startcom-root with notBefore of
    // June 1 00:00:01 2016 GMT. It pass cert check.
    serverOpts: {
      key: loadPEM('agent11-key'),
      cert: loadPEM('agent11-cert')
    },
    clientOpts: {
      ca: loadPEM('fake-symantec-root-cert'),
      port: undefined,
      rejectUnauthorized: true
    },
    errorCode: 'CERT_REVOKED'
  }
];


function runNextTest(server, tindex) {
  server.close(function() {
    finished++;
    runTest(tindex + 1);
  });
}


function runTest(tindex) {
  const tcase = testCases[tindex];

  if (!tcase) return;

  const server = tls.createServer(tcase.serverOpts, function(s) {
    s.resume();
  }).listen(0, function() {
    tcase.clientOpts.port = this.address().port;
    const client = tls.connect(tcase.clientOpts);
    client.on('error', function(e) {
      assert.strictEqual(e.code, tcase.errorCode);
      runNextTest(server, tindex);
    });

    client.on('secureConnect', function() {
      // agent8 can pass StartCom/WoSign check so that the secureConnect
      // is established.
      assert.strictEqual(tcase.errorCode, 'CERT_REVOKED');
      client.end();
      runNextTest(server, tindex);
    });
  });
}


runTest(0);

process.on('exit', function() {
  assert.strictEqual(finished, testCases.length);
});
