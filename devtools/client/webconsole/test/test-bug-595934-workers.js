/* -*- indent-tabs-mode: nil; js-indent-level: 2 -*- */
/* vim: set ft=javascript ts=2 et sw=2 tw=80: */
/* Any copyright is dedicated to the Public Domain.
 * http://creativecommons.org/publicdomain/zero/1.0/ */

/* global fooBarWorker*/
/* eslint-disable no-unused-vars*/

"use strict";

var onmessage = function () {
  fooBarWorker();
};

