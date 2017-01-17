'use strict';
const common = require('../common');

if (!common.hasCrypto) {
  common.skip('missing crypto');
  return;
}

if (!common.opensslCli) {
  common.skip('node compiled without OpenSSL CLI.');
  return;
}

const assert = require('assert');
const crypto = require('crypto');
const fs = require('fs');
const path = require('path');

let found = 0;

// check at least one builtin engine exists.
crypto.getEngines().forEach((e) => {
  if (e.id === 'dynamic')
    found++;
});

assert.strictEqual(found, 1);

// check set and get test dynamic engine of
// test/fixtures/openssl_test_engine/node_test_engine.c
let engine_path;

if (common.isWindows) {
  engine_path = 'node_test_engine.dll';
} else if (common.isAix) {
  engine_path = 'libnode_test_engine.a';
} else if (process.platform === 'darwin') {
  engine_path = 'node_test_engine.so';
} else {
  engine_path = 'libnode_test_engine.so';
}

const test_engine_id = 'node_test_engine';
const test_engine_name = 'Node Test Engine for OpenSSL';
const test_engine = path.join(path.dirname(process.execPath), engine_path);

assert.doesNotThrow(function() {
  fs.accessSync(test_engine);
}, 'node test engine ' + test_engine + ' is not found.');

crypto.setEngine(test_engine);

crypto.getEngines().forEach((e) => {
  if (e.id === test_engine_id && e.name === test_engine_name)
    found++;
});

assert.strictEqual(found, 2);
