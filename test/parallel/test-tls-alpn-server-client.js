'use strict';

if (!process.features.tls_alpn) {
  console.error('Skipping because node compiled without OpenSSL or ' +
                'with old OpenSSL version.');
  process.exit(0);
}

var common = require('../common'),
    assert = require('assert'),
    fs = require('fs'),
    tls = require('tls');

function filenamePEM(n) {
  return require('path').join(common.fixturesDir, 'keys', n + '.pem');
}

function loadPEM(n) {
  return fs.readFileSync(filenamePEM(n));
}

var serverPort = common.PORT;
var serverIP = common.localhostIPv4;

var serverOptions = {
  key: loadPEM('agent2-key'),
  cert: loadPEM('agent2-cert'),
  ALPNProtocols: ['a', 'b', 'c']
};

var clientsOptions = [{
  // test0: 'a' selected
  port: serverPort,
  host: serverIP,
  key: serverOptions.key,
  cert: serverOptions.cert,
  ALPNProtocols: ['a', 'b', 'c'],
  rejectUnauthorized: false
}, {
  // test1: 'b' selected
  port: serverPort,
  host: serverIP,
  key: serverOptions.key,
  cert: serverOptions.cert,
  ALPNProtocols: ['c', 'b', 'e'],
  rejectUnauthorized: false
}, {
  // test2: nothing selected
  port: serverPort,
  host: serverIP,
  key: serverOptions.key,
  cert: serverOptions.cert,
  ALPNProtocols: ['first-priority-unsupported', 'x', 'y'],
  rejectUnauthorized: false
}];

var serverResults = [], clientsResults = [];

var server = tls.createServer(serverOptions, function(c) {
  serverResults.push(c.alpnProtocol);
});

server.listen(serverPort, serverIP, function() {
  connectClient(clientsOptions);
});


function connectClient(options) {
  var opt = options.shift();
  var client = tls.connect(opt, function() {
    clientsResults.push(client.alpnProtocol);
    client.destroy();

    if (options.length) {
      connectClient(options);
    } else {
      server.close();
    }
  });
};


process.on('exit', function() {
  // test0: 'a' selected
  assert.strictEqual(clientsResults[0], 'a');
  assert.strictEqual(serverResults[0], clientsResults[0]);
  // test1: 'b' selected
  assert.strictEqual(clientsResults[1], 'b');
  assert.strictEqual(serverResults[1], clientsResults[1]);
  // test2: nothing selected
  assert.strictEqual(serverResults[2], false);
  assert.strictEqual(clientsResults[2], false);
});
