'use strict';
const common = require('../common');

// This test ensures that a dynamic engine can be registered with
// crypto.setEngine() and crypto.getEngines() obtains the list for
// both builtin and dynamic engines.

if (!common.hasCrypto) {
  common.skip('missing crypto');
  return;
}

const assert = require('assert');
const crypto = require('crypto');
const fs = require('fs');
const path = require('path');

let found = 0;

// Check builtin engine exists.
// A dynamic engine is loaded by ENGINE_load_builtin_engines()
// in InitCryptoOnce().
crypto.getEngines().forEach((e) => {
  if (e.id === 'dynamic')
    found++;
});

assert.strictEqual(found, 1);

// Check set and get node test engine of
// test/fixtures/openssl_test_engine/node_test_engine.c

if (process.config.variables.node_shared_openssl) {
  common.skip('node test engine cannot be built in shared openssl');
  return;
}

if (process.config.variables.openssl_fips) {
  common.skip('node test engine cannot be built in FIPS mode.');
  return;
}

let engineLib;

if (common.isWindows) {
  engineLib = 'node_test_engine.dll';
} else if (common.isAix) {
  engineLib = 'libnode_test_engine.a';
} else if (common.isOSX) {
  engineLib = 'node_test_engine.so';
} else {
  engineLib = 'libnode_test_engine.so';
}

const testEngineId = 'node_test_engine';
const testEngineName = 'Node Test Engine for OpenSSL';
const testEngine = path.join(path.dirname(process.execPath), engineLib);

assert.doesNotThrow(function() {
  fs.accessSync(testEngine);
}, 'node test engine ' + testEngine + ' is not found.');

crypto.setEngine(testEngine);

crypto.getEngines().forEach((e) => {
  if (e.id === testEngineId && e.name === testEngineName &&
      e.flags === crypto.constants.ENGINE_METHOD_ALL)
    found++;
});

assert.strictEqual(found, 2);

// Error Tests for setEngine
assert.throws(function() {
  crypto.setEngine(true);
}, /^TypeError: "id" argument should be a string$/);

assert.throws(function() {
  crypto.setEngine('/path/to/engine', 'notANumber');
}, /^TypeError: "flags" argument should be a number, if present$/);
