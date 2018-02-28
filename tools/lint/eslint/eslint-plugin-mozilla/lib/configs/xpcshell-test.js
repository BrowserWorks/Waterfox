// Parent config file for all xpcshell files.
"use strict";

module.exports = {
  // All globals made available in the test environment.
  "globals": {
    "Assert": false,
    "PromiseDebugging": false,
    "_TEST_FILE": false,
    "add_task": false,
    "add_test": false,
    "deepEqual": false,
    "do_await_remote_message": false,
    "do_check_eq": false,
    "do_check_false": false,
    "do_check_instanceof": false,
    "do_check_matches": false,
    "do_check_neq": false,
    "do_check_null": false,
    "do_check_true": false,
    "do_execute_soon": false,
    "do_get_cwd": false,
    "do_get_file": false,
    "do_get_idle": false,
    "do_get_profile": false,
    "do_get_tempdir": false,
    "do_load_child_test_harness": false,
    "do_load_manifest": false,
    "do_load_module": false,
    "do_parse_document": false,
    "do_print": false,
    "do_register_cleanup": false,
    "do_report_unexpected_exception": false,
    "do_send_remote_message": false,
    "do_test_finished": false,
    "do_test_pending": false,
    "do_throw": false,
    "do_timeout": false,
    "equal": false,
    // XPCShell specific function, see XPCShellEnvironment.cpp
    "gczeal": false,
    "greater": false,
    "greaterOrEqual": false,
    "less": false,
    "lessOrEqual": false,
    "load": false,
    "mozinfo": false,
    "notDeepEqual": false,
    "notEqual": false,
    "notStrictEqual": false,
    "ok": false,
    "run_next_test": false,
    "run_test": false,
    "run_test_in_child": false,
    "runningInParent": false,
    // Defined in XPCShellImpl.
    "sendCommand": false,
    "strictEqual": false,
    "throws": false,
    "todo": false,
    "todo_check_false": false,
    "todo_check_true": false,
    // Firefox specific function.
    // eslint-disable-next-line max-len
    // https://developer.mozilla.org/en-US/docs/Web/JavaScript/Reference/Global_Objects/uneval
    "uneval": false
  },

  rules: {
    "mozilla/import-headjs-globals": "warn",
    "mozilla/mark-test-function-used": "warn",
    "mozilla/no-arbitrary-setTimeout": "error",
    "no-shadow": "error"
  }
};
