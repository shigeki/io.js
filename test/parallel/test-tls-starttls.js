'use strict';
const common = require('../common');

// testing TLSSocket.startTLS() with echo back STARTTLS server.

const net = require('net');
const tls = require('tls');
const fs = require('fs');

const key = fs.readFileSync(common.fixturesDir + '/keys/agent1-key.pem');
const cert = fs.readFileSync(common.fixturesDir + '/keys/agent1-cert.pem');
const token = 'STARTTLS';

function BufStringMatch(string, buf_list) {
  return Buffer.concat(buf_list).toString().match(string);
}

const server = net.Server(common.mustCall((socket) => {
  const buf_list = [];
  socket.encrypted = false;
  socket.on('data', (buf) => {
    if (socket.encrypted)
      return;

    buf_list.push(buf);
    if (BufStringMatch(token, buf_list)) {
      socket.encrypted = true;
      socket.write(token);
      server.emit('starttls', socket);
    }
  });
}));

server.on('starttls', (socket) => {
  const tls_socket = new tls.TLSSocket(socket, {
    isServer: true,
    requestCert: false,
    secureContext: tls.createSecureContext({cert: cert, key: key})
  });
  // echo back after TLS handshake completed
  tls_socket.pipe(tls_socket);
});

server.listen(0, () => {
  const port = server.address().port;
  const raw = net.connect({port: port}, common.mustCall(() => {
    raw.write('plain text\n');
    raw.write(token);
  }));
  const buf_list = [];
  raw.encrypted = false;
  raw.on('data', (buf) => {
    if (raw.encrypted)
      return;
    buf_list.push(buf);
    if (BufStringMatch(token, buf_list)) {
      raw.encrypted = true;
      raw.emit('starttls');
    }
  });

  raw.on('starttls', () => {
    const tls_socket = new tls.TLSSocket(raw, {rejectUnauthorized: false});
    tls_socket.startTLS(() => {
      tls_socket.write('encrypted data\n');
      tls_socket.write('done');
    });
    tls_socket.on('secureConnect', function() {
      const buf_list = [];
      tls_socket.on('data', (buf) => {
        buf_list.push(buf);
        if (BufStringMatch('done', buf_list)) {
          tls_socket.end();
          server.close();
        }
      });
    });
  });
});
