'use strict';
const common = require('../common');
const assert = require('assert');
const fs = require('fs');

if (!common.hasCrypto) {
  console.log('1..0 # Skipped: missing crypto');
  return;
}
const https = require('https');

var pfx_withCA = fs.readFileSync(common.fixturesDir + '/keys/agent2.pfx');
var pfx_noCA = fs.readFileSync(common.fixturesDir + '/keys/agent2_noCA.pfx');

function RunTest(params) {
  if (!params.length)
    return;

  var param = params.shift();
  var options = {
    host: '127.0.0.1',
    port: common.PORT,
    servername: 'agent2',
    path: '/',
    pfx: param.pfx_server,
    passphrase: 'sample',
    requestCert: true,
    rejectUnauthorized: false
  };
  var server = https.createServer(options, function(req, res) {
    assert.equal(req.socket.authorized, param.authorized);
    res.writeHead(200);
    res.end('OK');
  });

  server.listen(options.port, options.host, function() {
    var data = '';
    options.pfx = param.pfx_client;
    https.get(options, function(res) {
      res.on('data', function(data_) { data += data_; });
      res.on('end', function() { server.close(); });
    });

    server.on('close', function() {
      assert.equal(data, 'OK');
      RunTest(params);
    });
  });
}

var test_params = [
  {pfx_server: pfx_noCA,   pfx_client: pfx_noCA,   authorized: false},
  {pfx_server: pfx_withCA, pfx_client: pfx_noCA,   authorized: true},
  {pfx_server: pfx_noCA,   pfx_client: pfx_withCA, authorized: true},
  {pfx_server: pfx_withCA, pfx_client: pfx_withCA, authorized: true}
];

RunTest(test_params);
