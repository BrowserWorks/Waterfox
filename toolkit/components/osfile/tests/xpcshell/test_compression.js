/* Any copyright is dedicated to the Public Domain.
 * http://creativecommons.org/publicdomain/zero/1.0/ */

"use strict";

Components.utils.import("resource://gre/modules/osfile.jsm");

function run_test() {
  do_test_pending();
  run_next_test();
}

add_task(function test_compress_lz4() {
  let path = OS.Path.join(OS.Constants.Path.tmpDir, "compression.lz");
  let length = 1024;
  let array = new Uint8Array(length);
  for (let i = 0; i < array.byteLength; ++i) {
    array[i] = i;
  }
  let arrayAsString = Array.prototype.join.call(array);

  do_print("Writing data with lz4 compression");
  let bytes = yield OS.File.writeAtomic(path, array, { compression: "lz4" });
  do_print("Compressed " + length + " bytes into " + bytes);

  do_print("Reading back with lz4 decompression");
  let decompressed = yield OS.File.read(path, { compression: "lz4" });
  do_print("Decompressed into " + decompressed.byteLength + " bytes");
  do_check_eq(arrayAsString, Array.prototype.join.call(decompressed));
});

add_task(function test_uncompressed() {
  do_print("Writing data without compression");
  let path = OS.Path.join(OS.Constants.Path.tmpDir, "no_compression.tmp");
  let array = new Uint8Array(1024);
  for (let i = 0; i < array.byteLength; ++i) {
    array[i] = i;
  }
  let bytes = yield OS.File.writeAtomic(path, array); // No compression

  let exn;
  // Force decompression, reading should fail
  try {
    yield OS.File.read(path, { compression: "lz4" });
  } catch (ex) {
    exn = ex;
  }
  do_check_true(!!exn);
  // Check the exception message (and that it contains the file name)
  do_check_true(exn.message.indexOf(`Invalid header (no magic number) - Data: ${ path }`) != -1);
});

add_task(function test_no_header() {
  let path = OS.Path.join(OS.Constants.Path.tmpDir, "no_header.tmp");
  let array = new Uint8Array(8).fill(0,0);  // Small array with no header

  do_print("Writing data with no header");

  let bytes = yield OS.File.writeAtomic(path, array); // No compression
  let exn;
  // Force decompression, reading should fail
  try {
    yield OS.File.read(path, { compression: "lz4" });
  } catch (ex) {
    exn = ex;
  }
  do_check_true(!!exn);
  // Check the exception message (and that it contains the file name)
  do_check_true(exn.message.indexOf(`Buffer is too short (no header) - Data: ${ path }`) != -1);
});

add_task(function test_invalid_content() {
  let path = OS.Path.join(OS.Constants.Path.tmpDir, "invalid_content.tmp");
  let arr1 = new Uint8Array([109, 111, 122, 76, 122, 52, 48, 0]);
  let arr2 = new Uint8Array(248).fill(1,0);

  let array = new Uint8Array(arr1.length + arr2.length);
  array.set(arr1);
  array.set(arr2, arr1.length);

  do_print("Writing invalid data (with a valid header and only ones after that)");

  let bytes = yield OS.File.writeAtomic(path, array); // No compression
  let exn;
  // Force decompression, reading should fail
  try {
    yield OS.File.read(path, { compression: "lz4" });
  } catch (ex) {
    exn = ex;
  }
  do_check_true(!!exn);
  // Check the exception message (and that it contains the file name)
  do_check_true(exn.message.indexOf(`Invalid content: Decompression stopped at 0 - Data: ${ path }`) != -1);
});

add_task(function() {
  do_test_finished();
});