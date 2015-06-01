'use strict';
var common = require('../common');
var assert = require('assert');

if (!common.hasCrypto) {
  console.log('1..0 # Skipped: missing crypto');
  process.exit();
}

var net = require('net');
var tls = require('tls');
var fs = require('fs');


function filenamePEM(n) {
  return require('path').join(common.fixturesDir, 'keys', n + '.pem');
}

function loadPEM(n) {
  return fs.readFileSync(filenamePEM(n));
}

var opts = {
  key: loadPEM('agent2-key'),
  cert:loadPEM('agent2-cert')
};

function invalidTLSClient() {
  var socket = net.connect(common.PORT);
  var client = tls.connect({
    socket: socket,
    rejectUnauthorized: false
  }, function() {
    socket.write('a');
    client.end();
  });
  client.on('error', function(err) {
    assert(/SSL alert number 70/.test(err.message));
  });
  return client;
}

// Server : one clientError Listener
// Server socket: no error Listener
// The clientError listner gets TLS error.
function Test1() {
  var server = tls.Server(opts);
  server.on('clientError', function(err, socket) {
    assert(/wrong version number/.test(err.message));
    server.close();
    Test2();
  });
  server.listen(common.PORT, function() {
    invalidTLSClient();
  });
}

// Server : one clientError Listener
// Server socket: one error Listener
// The both clientError and error listner gets TLS error.
function Test2() {
  var server = tls.Server(opts, function(s) {
    s.on('error', function(err) {
      assert(/wrong version number/.test(err.message));
    });
  });
  server.on('clientError', function(err, socket) {
    assert(/wrong version number/.test(err.message));
    server.close();
    Test3();
  });
  server.listen(common.PORT, function() {
    invalidTLSClient();
  });
}

// Server : no clientError Listener
// Server socket: one error Listener
// The error listner gets TLS error.
function Test3() {
  var server = tls.Server(opts, function(s) {
    s.on('error', function(err) {
      assert(/wrong version number/.test(err.message));
      server.close();
      Test4();
    });
  });
  server.listen(common.PORT, function() {
    invalidTLSClient();
  });
}

// Server : no clientError Listener
// Server socket: no error Listener
// The server is never termiated with unhandled error.
function Test4() {
  assert.doesNotThrow(function() {
    var server = tls.Server(opts);
    server.listen(common.PORT, function() {
      var client = invalidTLSClient();
      client.on('close', function() {
        server.close();
      });
    });
  });
}


Test1();
