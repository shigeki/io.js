var common = require('../common');
var assert = require('assert');
var spawn = require('child_process').spawn;

if (process.platform === 'win32') {
  console.log('Skipping test, platform not supported.');
  return;
}

var isAndroid = process.platform === 'android';

var shell;
if (isAndroid) {
  shell = '/system/bin/sh';
} else {
  shell = '/bin/sh';
}

if (process.argv[2] === 'child') {
  process.stdout.write('stdout', function() {
    process.stderr.write('stderr', function() {
      process.exit(42);
    });
  });
  return;
}

// Run the script in a shell but close stdout and stderr.
var cmd = '"' + process.execPath + '" "' + __filename + '" child 1>&- 2>&-';
var proc = spawn(shell, ['-c', cmd], { stdio: 'inherit' });

proc.on('exit', common.mustCall(function(exitCode) {
  assert.equal(exitCode, 42);
}));
