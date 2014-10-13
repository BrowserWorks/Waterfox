/* Quicktime muxer documentation
 * Copyright (C) 2008-2010 Thiago Santos <thiagoss@embedded.ufcg.edu.br>
 * Copyright (C) 2008 Mark Nauwelaerts <mnauw@users.sf.net>
 * Copyright (C) 2010 Nokia Corporation. All rights reserved.
 * Contact: Stefan Kost <stefan.kost@nokia.com>
 *
 * This library is free software; you can redistribute it and/or
 * modify it under the terms of the GNU Library General Public
 * License as published by the Free Software Foundation; either
 * version 2 of the License, or (at your option) any later version.
 *
 * This library is distributed in the hope that it will be useful,
 * but WITHOUT ANY WARRANTY; without even the implied warranty of
 * MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the GNU
 * Library General Public License for more details.
 *
 * You should have received a copy of the GNU Library General Public
 * License along with this library; if not, write to the
 * Free Software Foundation, Inc., 51 Franklin St, Fifth Floor,
 * Boston, MA 02110-1301, USA.
 */
/*
 * Unless otherwise indicated, Source Code is licensed under MIT license.
 * See further explanation attached in License Statement (distributed in the file
 * LICENSE).
 *
 * Permission is hereby granted, free of charge, to any person obtaining a copy of
 * this software and associated documentation files (the "Software"), to deal in
 * the Software without restriction, including without limitation the rights to
 * use, copy, modify, merge, publish, distribute, sublicense, and/or sell copies
 * of the Software, and to permit persons to whom the Software is furnished to do
 * so, subject to the following conditions:
 *
 * The above copyright notice and this permission notice shall be included in all
 * copies or substantial portions of the Software.
 *
 * THE SOFTWARE IS PROVIDED "AS IS", WITHOUT WARRANTY OF ANY KIND, EXPRESS OR
 * IMPLIED, INCLUDING BUT NOT LIMITED TO THE WARRANTIES OF MERCHANTABILITY,
 * FITNESS FOR A PARTICULAR PURPOSE AND NONINFRINGEMENT. IN NO EVENT SHALL THE
 * AUTHORS OR COPYRIGHT HOLDERS BE LIABLE FOR ANY CLAIM, DAMAGES OR OTHER
 * LIABILITY, WHETHER IN AN ACTION OF CONTRACT, TORT OR OTHERWISE, ARISING FROM,
 * OUT OF OR IN CONNECTION WITH THE SOFTWARE OR THE USE OR OTHER DEALINGS IN THE
 * SOFTWARE.
 */

/* ============================= mp4mux ==================================== */

/**
 * SECTION:element-mp4mux
 * @short_description: Muxer for ISO MPEG-4 (.mp4) files
 *
 * This element merges streams (audio and video) into ISO MPEG-4 (.mp4) files.
 *
 * The following background intends to explain why various similar muxers
 * are present in this plugin.
 *
 * The <ulink url="http://www.apple.com/quicktime/resources/qtfileformat.pdf">
 * QuickTime file format specification</ulink> served as basis for the MP4 file
 * format specification (mp4mux), and as such the QuickTime file structure is
 * nearly identical to the so-called ISO Base Media file format defined in
 * ISO 14496-12 (except for some media specific parts).
 * In turn, the latter ISO Base Media format was further specialized as a
 * Motion JPEG-2000 file format in ISO 15444-3 (mj2mux)
 * and in various 3GPP(2) specs (3gppmux).
 * The fragmented file features defined (only) in ISO Base Media are used by
 * ISMV files making up (a.o.) Smooth Streaming (ismlmux).
 *
 * A few properties (#GstMp4Mux:movie-timescale, #GstMp4Mux:trak-timescale)
 * allow adjusting some technical parameters, which might be useful in (rare)
 * cases to resolve compatibility issues in some situations.
 *
 * Some other properties influence the result more fundamentally.
 * A typical mov/mp4 file's metadata (aka moov) is located at the end of the
 * file, somewhat contrary to this usually being called "the header".
 * However, a #GstMp4Mux:faststart file will (with some effort) arrange this to
 * be located near start of the file, which then allows it e.g. to be played
 * while downloading. Alternatively, rather than having one chunk of metadata at
 * start (or end), there can be some metadata at start and most of the other
 * data can be spread out into fragments of #GstMp4Mux:fragment-duration.
 * If such fragmented layout is intended for streaming purposes, then
 * #GstMp4Mux:streamable allows foregoing to add index metadata (at the end of
 * file).
 *
 * <refsect2>
 * <title>Example pipelines</title>
 * |[
 * gst-launch-1.0 gst-launch-1.0 v4l2src num-buffers=50 ! queue ! x264enc ! mp4mux ! filesink location=video.mp4
 * ]|
 * Records a video stream captured from a v4l2 device, encodes it into H.264
 * and muxes it into an mp4 file.
 * </refsect2>
 */

/* ============================= 3gppmux ==================================== */

/**
 * SECTION:element-3gppmux
 * @short_description: Muxer for 3GPP (.3gp) files
 *
 * This element merges streams (audio and video) into 3GPP (.3gp) files.
 *
 * The following background intends to explain why various similar muxers
 * are present in this plugin.
 *
 * The <ulink url="http://www.apple.com/quicktime/resources/qtfileformat.pdf">
 * QuickTime file format specification</ulink> served as basis for the MP4 file
 * format specification (mp4mux), and as such the QuickTime file structure is
 * nearly identical to the so-called ISO Base Media file format defined in
 * ISO 14496-12 (except for some media specific parts).
 * In turn, the latter ISO Base Media format was further specialized as a
 * Motion JPEG-2000 file format in ISO 15444-3 (mj2mux)
 * and in various 3GPP(2) specs (3gppmux).
 * The fragmented file features defined (only) in ISO Base Media are used by
 * ISMV files making up (a.o.) Smooth Streaming (ismlmux).
 *
 * A few properties (#Gst3GPPMux:movie-timescale, #Gst3GPPMux:trak-timescale)
 * allow adjusting some technical parameters, which might be useful in (rare)
 * cases to resolve compatibility issues in some situations.
 *
 * Some other properties influence the result more fundamentally.
 * A typical mov/mp4 file's metadata (aka moov) is located at the end of the file,
 * somewhat contrary to this usually being called "the header". However, a
 * #Gst3GPPMux:faststart file will (with some effort) arrange this to be located
 * near start of the file, which then allows it e.g. to be played while
 * downloading. Alternatively, rather than having one chunk of metadata at start
 * (or end), there can be some metadata at start and most of the other data can
 * be spread out into fragments of #Gst3GPPMux:fragment-duration. If such
 * fragmented layout is intended for streaming purposes, then
 * #Gst3GPPMux:streamable allows foregoing to add index metadata (at the end of
 * file).
 *
 * <refsect2>
 * <title>Example pipelines</title>
 * |[
 * gst-launch-1.0 v4l2src num-buffers=50 ! queue ! ffenc_h263 ! 3gppmux ! filesink location=video.3gp
 * ]|
 * Records a video stream captured from a v4l2 device, encodes it into H.263
 * and muxes it into an 3gp file.
 * </refsect2>
 *
 * Documentation last reviewed on 2011-04-21
 */

/* ============================= mj2pmux ==================================== */

/**
 * SECTION:element-mj2mux
 * @short_description: Muxer for Motion JPEG-2000 (.mj2) files
 *
 * This element merges streams (audio and video) into MJ2 (.mj2) files.
 *
 * The following background intends to explain why various similar muxers
 * are present in this plugin.
 *
 * The <ulink url="http://www.apple.com/quicktime/resources/qtfileformat.pdf">
 * QuickTime file format specification</ulink> served as basis for the MP4 file
 * format specification (mp4mux), and as such the QuickTime file structure is
 * nearly identical to the so-called ISO Base Media file format defined in
 * ISO 14496-12 (except for some media specific parts).
 * In turn, the latter ISO Base Media format was further specialized as a
 * Motion JPEG-2000 file format in ISO 15444-3 (mj2mux)
 * and in various 3GPP(2) specs (3gppmux).
 * The fragmented file features defined (only) in ISO Base Media are used by
 * ISMV files making up (a.o.) Smooth Streaming (ismlmux).
 *
 * A few properties (#GstMJ2Mux:movie-timescale, #GstMJ2Mux:trak-timescale)
 * allow adjusting some technical parameters, which might be useful in (rare)
 * cases to resolve compatibility issues in some situations.
 *
 * Some other properties influence the result more fundamentally.
 * A typical mov/mp4 file's metadata (aka moov) is located at the end of the file,
 * somewhat contrary to this usually being called "the header". However, a
 * #GstMJ2Mux:faststart file will (with some effort) arrange this to be located
 * near start of the file, which then allows it e.g. to be played while
 * downloading. Alternatively, rather than having one chunk of metadata at start
 * (or end), there can be some metadata at start and most of the other data can
 * be spread out into fragments of #GstMJ2Mux:fragment-duration. If such
 * fragmented layout is intended for streaming purposes, then
 * #GstMJ2Mux:streamable allows foregoing to add index metadata (at the end of
 * file).
 *
 * <refsect2>
 * <title>Example pipelines</title>
 * |[
 * gst-launch-1.0 v4l2src num-buffers=50 ! queue ! jp2kenc ! mj2mux ! filesink location=video.mj2
 * ]|
 * Records a video stream captured from a v4l2 device, encodes it into JPEG-2000
 * and muxes it into an mj2 file.
 * </refsect2>
 *
 * Documentation last reviewed on 2011-04-21
 */

/* ============================= ismlmux ==================================== */

/**
 * SECTION:element-ismlmux
 * @short_description: Muxer for ISML smooth streaming (.isml) files
 *
 * This element merges streams (audio and video) into MJ2 (.mj2) files.
 *
 * The following background intends to explain why various similar muxers
 * are present in this plugin.
 *
 * The <ulink url="http://www.apple.com/quicktime/resources/qtfileformat.pdf">
 * QuickTime file format specification</ulink> served as basis for the MP4 file
 * format specification (mp4mux), and as such the QuickTime file structure is
 * nearly identical to the so-called ISO Base Media file format defined in
 * ISO 14496-12 (except for some media specific parts).
 * In turn, the latter ISO Base Media format was further specialized as a
 * Motion JPEG-2000 file format in ISO 15444-3 (mj2mux)
 * and in various 3GPP(2) specs (3gppmux).
 * The fragmented file features defined (only) in ISO Base Media are used by
 * ISMV files making up (a.o.) Smooth Streaming (ismlmux).
 *
 * A few properties (#GstISMLMux:movie-timescale, #GstISMLMux:trak-timescale)
 * allow adjusting some technical parameters, which might be useful in (rare)
 * cases to resolve compatibility issues in some situations.
 *
 * Some other properties influence the result more fundamentally.
 * A typical mov/mp4 file's metadata (aka moov) is located at the end of the file,
 * somewhat contrary to this usually being called "the header". However, a
 * #GstISMLMux:faststart file will (with some effort) arrange this to be located
 * near start of the file, which then allows it e.g. to be played while
 * downloading. Alternatively, rather than having one chunk of metadata at start
 * (or end), there can be some metadata at start and most of the other data can
 * be spread out into fragments of #GstISMLMux:fragment-duration. If such
 * fragmented layout is intended for streaming purposes, then
 * #GstISMLMux:streamable allows foregoing to add index metadata (at the end of
 * file).
 *
 * <refsect2>
 * <title>Example pipelines</title>
 * |[
 * gst-launch-1.0 v4l2src num-buffers=50 ! queue ! jp2kenc ! mj2mux ! filesink location=video.mj2
 * ]|
 * Records a video stream captured from a v4l2 device, encodes it into JPEG-2000
 * and muxes it into an mj2 file.
 * </refsect2>
 *
 * Documentation last reviewed on 2011-04-21
 */
