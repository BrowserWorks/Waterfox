/* This Source Code Form is subject to the terms of the Mozilla Public
 * License, v. 2.0. If a copy of the MPL was not distributed with this
 * file, You can obtain one at http://mozilla.org/MPL/2.0/. */

#![deny(warnings)]

extern crate webrender;
extern crate webrender_api;
extern crate euclid;
extern crate app_units;
extern crate gleam;
extern crate rayon;
extern crate thread_profiler;

#[allow(non_snake_case)]
pub mod bindings;
pub mod moz2d_renderer;
