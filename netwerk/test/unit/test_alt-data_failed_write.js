/* Any copyright is dedicated to the Public Domain.
 * http://creativecommons.org/publicdomain/zero/1.0/ */

"use strict";

// When an alt-data writer fails, alt-data readers that are already open must
// see the failure rather than a successful EOF after a prefix.  Readers of the
// regular data are unaffected.

const ALT_TYPE = "text/failed-alt-write";
const CHUNK_SIZE = 256 * 1024;
const CHUNK_LIMIT_PREF = "browser.cache.disk.max_chunks_memory_usage";

function openEntry(name, where) {
  return new Promise(resolve => {
    asyncOpenCacheEntry(
      "http://failed-alt-write/" + name,
      where,
      Ci.nsICacheStorage.OPEN_TRUNCATE,
      null,
      (status, entry) => {
        Assert.equal(status, Cr.NS_OK);
        resolve(entry);
      }
    );
  });
}

function write(output, data) {
  Assert.equal(output.write(data, data.length), data.length);
}

function read(input, count) {
  let binary = Cc["@mozilla.org/binaryinputstream;1"].createInstance(
    Ci.nsIBinaryInputStream
  );
  binary.setInputStream(input);
  return binary.readBytes(count);
}

function openAltInput(entry, offset = 0) {
  let input = entry.openAlternativeInputStream(ALT_TYPE);
  if (offset) {
    input
      .QueryInterface(Ci.nsISeekableStream)
      .seek(Ci.nsISeekableStream.NS_SEEK_SET, offset);
  }
  return input.QueryInterface(Ci.nsIAsyncInputStream);
}

// Reads the input to the end the way a channel does and resolves with the
// final status.
function pumpInput(input) {
  return new Promise(resolve => {
    let pump = Cc["@mozilla.org/network/input-stream-pump;1"].createInstance(
      Ci.nsIInputStreamPump
    );
    pump.init(input, 0, 0, true);
    pump.asyncRead({
      onStartRequest() {},
      onDataAvailable(request, stream, offset, count) {
        read(stream, count);
      },
      onStopRequest(request, status) {
        resolve(status);
      },
    });
  });
}

function checkFailed(input, status) {
  let expected = e => e.result === status;
  Assert.throws(() => input.available(), expected, "available() fails");
  Assert.throws(() => read(input, 1), expected, "read fails");
  input.close();
}

async function seedEntry(name, where, source) {
  let entry = await openEntry(name, where);
  let output = entry.openOutputStream(0, -1);
  write(output, source);
  output.close();
  return entry;
}

add_setup(function () {
  do_get_profile();
});

add_task(async function test_failed_close() {
  const source = "source";
  const prefix = "prefix";
  let entry = await seedEntry("close", "memory", source);
  let regular = entry.openInputStream(0);

  let output = entry
    .openAlternativeOutputStream(ALT_TYPE, -1)
    .QueryInterface(Ci.nsIAsyncOutputStream);
  write(output, prefix);

  // Holds the prefix chunk.
  let buffered = openAltInput(entry);
  Assert.equal(read(buffered, 1), prefix[0]);
  let statuses = Promise.all([
    pumpInput(openAltInput(entry)),
    // Waits for the writer to append to the prefix chunk.
    pumpInput(openAltInput(entry, prefix.length)),
    // Waits for a chunk the writer never creates.
    pumpInput(openAltInput(entry, 2 * CHUNK_SIZE)),
  ]);

  output.closeWithStatus(Cr.NS_ERROR_FAILURE);
  checkFailed(buffered, Cr.NS_ERROR_FAILURE);
  for (let status of await statuses) {
    Assert.equal(status, Cr.NS_ERROR_FAILURE, "pumped reader fails");
  }

  Assert.equal(read(regular, source.length), source);
  Assert.throws(
    () => regular.available(),
    e => e.result === Cr.NS_BASE_STREAM_CLOSED,
    "regular data ends normally"
  );
  regular.close();
});

add_task(async function test_chunk_allocation_failure() {
  registerCleanupFunction(() => Services.prefs.clearUserPref(CHUNK_LIMIT_PREF));
  Services.prefs.setIntPref(CHUNK_LIMIT_PREF, 0);

  // Make the regular data exactly one chunk, so the alt-data starts a chunk.
  let entry = await seedEntry("budget", "disk", "s".repeat(CHUNK_SIZE));
  let output = entry.openAlternativeOutputStream(ALT_TYPE, -1);
  write(output, "a");

  // Opened before the chunk is complete, so the chunk stays cached once it is
  // written and the synchronous read below can't block on a disk read.
  let buffered = openAltInput(entry);
  write(output, "a".repeat(CHUNK_SIZE - 1));
  Assert.equal(read(buffered, 1), "a");
  // Waits for the next chunk, whose allocation fails.
  let status = pumpInput(openAltInput(entry, CHUNK_SIZE));

  Services.prefs.setIntPref(CHUNK_LIMIT_PREF, 1);
  Assert.throws(
    () => output.write("b", 1),
    e => e.result === Cr.NS_ERROR_OUT_OF_MEMORY
  );
  checkFailed(buffered, Cr.NS_ERROR_OUT_OF_MEMORY);
  Assert.equal(await status, Cr.NS_ERROR_OUT_OF_MEMORY, "pumped reader fails");
  output.close();
});
