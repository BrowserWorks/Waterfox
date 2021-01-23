/* This Source Code Form is subject to the terms of the Mozilla Public
 * License, v. 2.0. If a copy of the MPL was not distributed with this
 * file, You can obtain one at http://mozilla.org/MPL/2.0/. */

#[macro_use]
extern crate js;

use js::jsapi::root::JS_NewGlobalObject;
use js::jsapi::root::JS::OnNewGlobalHookOption;
use js::jsapi::root::JS::RealmOptions;
use js::jsval::UndefinedValue;
use js::rust::{Runtime, SIMPLE_GLOBAL_CLASS};

use std::ptr;

#[test]
fn is_symbol() {
    let rt = Runtime::new(false).unwrap();
    let cx = rt.cx();

    unsafe {
        rooted!(in(cx) let global =
            JS_NewGlobalObject(cx, &SIMPLE_GLOBAL_CLASS, ptr::null_mut(),
                               OnNewGlobalHookOption::FireOnNewGlobalHook,
                               &RealmOptions::default())
        );
        rooted!(in(cx) let mut rval = UndefinedValue());
        assert!(rt
            .evaluate_script(
                global.handle(),
                "Symbol('test')",
                "test",
                1,
                rval.handle_mut()
            )
            .is_ok());
        assert!(rval.is_symbol());
    }
}

#[test]
fn is_not_symbol() {
    let rt = Runtime::new(false).unwrap();
    let cx = rt.cx();

    unsafe {
        rooted!(in(cx) let global =
            JS_NewGlobalObject(cx, &SIMPLE_GLOBAL_CLASS, ptr::null_mut(),
                               OnNewGlobalHookOption::FireOnNewGlobalHook,
                               &RealmOptions::default())
        );
        rooted!(in(cx) let mut rval = UndefinedValue());
        assert!(rt
            .evaluate_script(
                global.handle(),
                "'not a symbol'",
                "test",
                1,
                rval.handle_mut()
            )
            .is_ok());
        assert!(!rval.is_symbol());
    }
}
