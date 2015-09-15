'use strict';
var common = require('../common');
var assert = require('assert');

if (!common.hasCrypto) {
  console.log('1..0 # Skipped: missing crypto');
  return;
}
var tls = require('tls');

var fs = require('fs');

var clientConnected = 0;
var serverConnected = 0;
var serverCloseCallbacks = 0;
var serverCloseEvents = 0;
var rootCA1 = fs.readFileSync(common.fixturesDir + '/keys/ca1-cert.pem');
var options = {
  key: fs.readFileSync(common.fixturesDir + '/keys/agent8-key.pem'),
  ca: fs.readFileSync(common.fixturesDir + '/keys/ca3-cert.pem'),
  cert: fs.readFileSync(common.fixturesDir + '/keys/agent8-cert.pem')
};

var server = tls.Server(options, function(socket) {
  if (++serverConnected === 1) {
    server.close(function() {
      ++serverCloseCallbacks;
    });
    server.on('close', function() {
      ++serverCloseEvents;
    });
  }
});

server.listen(common.PORT, function() {
  tls.RootCA = [rootCA1];
  var client1 = tls.connect({
    port: common.PORT
  }, function() {
    clientConnected++;
    client1.end();
  });
});

process.on('exit', function() {
  assert.equal(clientConnected, 1);
  assert.equal(serverConnected, 1);
  assert.equal(serverCloseCallbacks, 1);
  assert.equal(serverCloseEvents, 1);
});
