'use strict';
var common = require('../common');
var assert = require('assert');

var net = require('net');

function errorClient() {
  var client = net.connect(common.PORT);
  client.on('error', function(e) {
    // ignore error
  });
  client.on('data', function(c) {
    client.destroy();
  });
}

function writeDelayedData(s) {
  setTimeout(function() {
    s.write('a');
  }, 10);
  s.write('a');
}

// Server: one clientError listener
// Server socket: no error listener
// The clientError listner gets socket error.
function Test1() {
  var server = net.createServer(function(s) {
    server.on('clientError', function(err, socket) {
      assert.strictEqual(err.code, 'EPIPE');
      server.close();
      Test2();
    });
    writeDelayedData(s);
  });
  server.listen(common.PORT, function() {
    errorClient();
  });
}

// Server: one clientError listener
// Server socket: one error listener
// The both clientError and error listner gets socket error.
function Test2() {
  var server = net.createServer(function(s) {
    s.on('error', function(err) {
      assert.strictEqual(err.code, 'EPIPE');
    });
    writeDelayedData(s);
  });
  server.on('clientError', function(err, socket) {
    assert.strictEqual(err.code, 'EPIPE');
    server.close();
    Test3();
  });
  server.listen(common.PORT, function() {
    errorClient();
  });
}

// Server: no clientError listener
// Server socket: one error listener
// The error listner gets socket error.
function Test3() {
  var server = net.createServer(function(s) {
    s.on('error', function(err) {
      assert.strictEqual(err.code, 'EPIPE');
      server.close();
      Test4();
    });
    writeDelayedData(s);
  });
  server.listen(common.PORT, function() {
    errorClient();
  });
}

// Server: no clientError listener
// Server socket: no error listener
// The server is never termiated with unhandled error.
function Test4() {
  assert.doesNotThrow(function() {
    var server = net.createServer(function(s) {
      writeDelayedData(s);
      s.on('close', function() {
        server.close();
      });
    });
    server.listen(common.PORT, function() {
      errorClient();
    });
  });
}


Test1();
