// Any copyright is dedicated to the Public Domain.
// http://creativecommons.org/publicdomain/zero/1.0/
//
// ServiceWorker equivalent of worker_wrapper.js.

var client;

function ok(a, msg) {
  dump("OK: " + !!a + "  =>  " + a + ": " + msg + "\n");
  client.postMessage({type: 'status', status: !!a, msg: a + ": " + msg });
}

function is(a, b, msg) {
  dump("IS: " + (a===b) + "  =>  " + a + " | " + b + ": " + msg + "\n");
  client.postMessage({type: 'status', status: a === b, msg: a + " === " + b + ": " + msg });
}

function workerTestArrayEquals(a, b) {
  if (!Array.isArray(a) || !Array.isArray(b) || a.length != b.length) {
    return false;
  }
  for (var i = 0, n = a.length; i < n; ++i) {
    if (a[i] !== b[i]) {
      return false;
    }
  }
  return true;
}

function workerTestDone() {
  client.postMessage({ type: 'finish' });
}

function workerTestGetVersion(cb) {
  addEventListener('message', function workerTestGetVersionCB(e) {
    if (e.data.type !== 'returnVersion') {
      return;
    }
    removeEventListener('message', workerTestGetVersionCB);
    cb(e.data.result);
  });
  client.postMessage({
    type: 'getVersion'
  });
}

function workerTestGetUserAgent(cb) {
  addEventListener('message', function workerTestGetUserAgentCB(e) {
    if (e.data.type !== 'returnUserAgent') {
      return;
    }
    removeEventListener('message', workerTestGetUserAgentCB);
    cb(e.data.result);
  });
  client.postMessage({
    type: 'getUserAgent'
  });
}

function workerTestGetOSCPU(cb) {
  addEventListener('message', function workerTestGetOSCPUCB(e) {
    if (e.data.type !== 'returnOSCPU') {
      return;
    }
    removeEventListener('message', workerTestGetOSCPUCB);
    cb(e.data.result);
  });
  client.postMessage({
    type: 'getOSCPU'
  });
}

function workerTestGetStorageManager(cb) {
  addEventListener('message', function workerTestGetStorageManagerCB(e) {
    if (e.data.type !== 'returnStorageManager') {
      return;
    }
    removeEventListener('message', workerTestGetStorageManagerCB);
    cb(e.data.result);
  });
  client.postMessage({
    type: 'getStorageManager'
  });
}

addEventListener('message', function workerWrapperOnMessage(e) {
  removeEventListener('message', workerWrapperOnMessage);
  var data = e.data;
  self.clients.matchAll().then(function(clients) {
    client = clients[0];
    try {
      importScripts(data.script);
    } catch(e) {
      client.postMessage({
        type: 'status',
        status: false,
        msg: 'worker failed to import ' + data.script + "; error: " + e.message
      });
    }
  });
});
