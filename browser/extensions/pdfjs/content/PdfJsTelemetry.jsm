/* Copyright 2013 Mozilla Foundation
 *
 * Licensed under the Apache License, Version 2.0 (the "License");
 * you may not use this file except in compliance with the License.
 * You may obtain a copy of the License at
 *
 *     http://www.apache.org/licenses/LICENSE-2.0
 *
 * Unless required by applicable law or agreed to in writing, software
 * distributed under the License is distributed on an "AS IS" BASIS,
 * WITHOUT WARRANTIES OR CONDITIONS OF ANY KIND, either express or implied.
 * See the License for the specific language governing permissions and
 * limitations under the License.
 */
/* eslint max-len: ["error", 100] */

"use strict";

this.EXPORTED_SYMBOLS = ["PdfJsTelemetry"];

const Cu = Components.utils;
Cu.import("resource://gre/modules/Services.jsm");

this.PdfJsTelemetry = {
  onViewerIsUsed() {
    let histogram = Services.telemetry.getHistogramById("PDF_VIEWER_USED");
    histogram.add(true);
  },
  onFallback() {
    let histogram = Services.telemetry.getHistogramById("PDF_VIEWER_FALLBACK_SHOWN");
    histogram.add(true);
  },
  onDocumentSize(size) {
    let histogram = Services.telemetry.getHistogramById("PDF_VIEWER_DOCUMENT_SIZE_KB");
    histogram.add(size / 1024);
  },
  onDocumentVersion(versionId) {
    let histogram = Services.telemetry.getHistogramById("PDF_VIEWER_DOCUMENT_VERSION");
    histogram.add(versionId);
  },
  onDocumentGenerator(generatorId) {
    let histogram = Services.telemetry.getHistogramById("PDF_VIEWER_DOCUMENT_GENERATOR");
    histogram.add(generatorId);
  },
  onEmbed(isObject) {
    let histogram = Services.telemetry.getHistogramById("PDF_VIEWER_EMBED");
    histogram.add(isObject);
  },
  onFontType(fontTypeId) {
    let histogram = Services.telemetry.getHistogramById("PDF_VIEWER_FONT_TYPES");
    histogram.add(fontTypeId);
  },
  onForm(isAcroform) {
    let histogram = Services.telemetry.getHistogramById("PDF_VIEWER_FORM");
    histogram.add(isAcroform);
  },
  onPrint() {
    let histogram = Services.telemetry.getHistogramById("PDF_VIEWER_PRINT");
    histogram.add(true);
  },
  onStreamType(streamTypeId) {
    let histogram = Services.telemetry.getHistogramById("PDF_VIEWER_STREAM_TYPES");
    histogram.add(streamTypeId);
  },
  onTimeToView(ms) {
    let histogram = Services.telemetry.getHistogramById("PDF_VIEWER_TIME_TO_VIEW_MS");
    histogram.add(ms);
  },
};
