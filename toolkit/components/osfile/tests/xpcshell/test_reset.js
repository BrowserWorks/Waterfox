/* Any copyright is dedicated to the Public Domain.
 * http://creativecommons.org/publicdomain/zero/1.0/ */

var Path = OS.Constants.Path;

add_task(async function init() {
  do_get_profile();
});

add_task(async function reset_before_launching() {
  do_print("Reset without launching OS.File, it shouldn't break");
  await OS.File.resetWorker();
});

add_task(async function transparent_reset() {
  for (let i = 1; i < 3; ++i) {
    do_print("Do stome stuff before and after " + i + " reset(s), " +
             "it shouldn't break");
    let CONTENT = "some content " + i;
    let path = OS.Path.join(Path.profileDir, "tmp");
    await OS.File.writeAtomic(path, CONTENT);
    for (let j = 0; j < i; ++j) {
      await OS.File.resetWorker();
    }
    let data = await OS.File.read(path);
    let string = (new TextDecoder()).decode(data);
    do_check_eq(string, CONTENT);
  }
});

add_task(async function file_open_cannot_reset() {
  let TEST_FILE = OS.Path.join(Path.profileDir, "tmp-" + Math.random());
  do_print("Leaking file descriptor " + TEST_FILE + ", we shouldn't be able to reset");
  let openedFile = await OS.File.open(TEST_FILE, { create: true} );
  let thrown = false;
  try {
    await OS.File.resetWorker();
  } catch (ex if ex.message.indexOf(OS.Path.basename(TEST_FILE)) != -1 ) {
    thrown = true;
  }
  do_check_true(thrown);

  do_print("Closing the file, we should now be able to reset");
  await openedFile.close();
  await OS.File.resetWorker();
});

add_task(async function dir_open_cannot_reset() {
  let TEST_DIR = await OS.File.getCurrentDirectory();
  do_print("Leaking directory " + TEST_DIR + ", we shouldn't be able to reset");
  let iterator = new OS.File.DirectoryIterator(TEST_DIR);
  let thrown = false;
  try {
    await OS.File.resetWorker();
  } catch (ex if ex.message.indexOf(OS.Path.basename(TEST_DIR)) != -1 ) {
    thrown = true;
  }
  do_check_true(thrown);

  do_print("Closing the directory, we should now be able to reset");
  await iterator.close();
  await OS.File.resetWorker();
});

add_task(async function race_against_itself() {
  do_print("Attempt to get resetWorker() to race against itself");
  // Arbitrary operation, just to wake up the worker
  try {
    await OS.File.read("/foo");
  } catch (ex) {
  }

  let all = [];
  for (let i = 0; i < 100; ++i) {
    all.push(OS.File.resetWorker());
  }

  await Promise.all(all);
});


add_task(async function finish_with_a_reset() {
  do_print("Reset without waiting for the result");
  // Arbitrary operation, just to wake up the worker
  try {
    await OS.File.read("/foo");
  } catch (ex) {
  }
  // Now reset
  /*don't yield*/ OS.File.resetWorker();
});

function run_test() {
  run_next_test();
}
