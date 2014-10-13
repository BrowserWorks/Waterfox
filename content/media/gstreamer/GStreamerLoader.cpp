/* vim:set ts=2 sw=2 sts=2 et cindent: */
/* This Source Code Form is subject to the terms of the Mozilla Public
 * License, v. 2.0. If a copy of the MPL was not distributed with this file,
 * You can obtain one at http://mozilla.org/MPL/2.0/. */

#include <dlfcn.h>
#include <stdio.h>

#include "prlog.h"
#include "nsDebug.h"
#include "mozilla/NullPtr.h"

#include "GStreamerLoader.h"

#define LIBGSTREAMER 0
#define LIBGSTAPP 1
#define LIBGSTVIDEO 2

#ifdef __OpenBSD__
#define LIB_GST_SUFFIX ".so"
#else
#define LIB_GST_SUFFIX ".so.0"
#endif

#ifdef PR_LOGGING
extern PRLogModuleInfo* gMediaDecoderLog;
#define LOG(type, msg) PR_LOG(gMediaDecoderLog, type, msg)
#else
#define LOG(type, msg)
#endif

namespace mozilla {

/*
 * Declare our function pointers using the types from the global gstreamer
 * definitions.
 */
#define GST_FUNC(_, func) typeof(::func)* func;
#define REPLACE_FUNC(func) GST_FUNC(-1, func)
#include "GStreamerFunctionList.h"
#undef GST_FUNC
#undef REPLACE_FUNC

/*
 * Redefinitions of functions that have been defined in the gstreamer headers to
 * stop them calling the gstreamer functions in global scope.
 */
GstBuffer * gst_buffer_ref_impl(GstBuffer *buf);
void gst_buffer_unref_impl(GstBuffer *buf);
void gst_message_unref_impl(GstMessage *msg);
void gst_caps_unref_impl(GstCaps *caps);

#if GST_VERSION_MAJOR == 1
void gst_sample_unref_impl(GstSample *sample);
#endif

#ifndef SYSTEM_GSTREAMER
extern "C" {
 GST_PLUGIN_STATIC_DECLARE(coreelements);
 GST_PLUGIN_STATIC_DECLARE(typefindfunctions);
 GST_PLUGIN_STATIC_DECLARE(app);
 GST_PLUGIN_STATIC_DECLARE(playback);
 GST_PLUGIN_STATIC_DECLARE(audioconvert);
 GST_PLUGIN_STATIC_DECLARE(audioresample);
 GST_PLUGIN_STATIC_DECLARE(volume);
 GST_PLUGIN_STATIC_DECLARE(videoconvert);
 GST_PLUGIN_STATIC_DECLARE(videoscale);
 GST_PLUGIN_STATIC_DECLARE(isomp4);
 GST_PLUGIN_STATIC_DECLARE(id3demux);
 GST_PLUGIN_STATIC_DECLARE(audioparsers);
 GST_PLUGIN_STATIC_DECLARE(videoparsersbad);
 GST_PLUGIN_STATIC_DECLARE(applemedia);
}
#endif

static bool
init_gstreamer()
{
 GError* error = nullptr;
 if (!gst_init_check(0, 0, &error)) {
 LOG(PR_LOG_ERROR, ("gst initialization failed: %s", error->message));
 g_error_free(error);
 return false;
 }

#ifndef SYSTEM_GSTREAMER
 GST_PLUGIN_STATIC_REGISTER(coreelements);
 GST_PLUGIN_STATIC_REGISTER(typefindfunctions);
 GST_PLUGIN_STATIC_REGISTER(app);
 GST_PLUGIN_STATIC_REGISTER(playback);
 GST_PLUGIN_STATIC_REGISTER(audioconvert);
 GST_PLUGIN_STATIC_REGISTER(audioresample);
 GST_PLUGIN_STATIC_REGISTER(volume);
 GST_PLUGIN_STATIC_REGISTER(videoconvert);
 GST_PLUGIN_STATIC_REGISTER(videoscale);
 GST_PLUGIN_STATIC_REGISTER(isomp4);
 GST_PLUGIN_STATIC_REGISTER(id3demux);
 GST_PLUGIN_STATIC_REGISTER(audioparsers);
 GST_PLUGIN_STATIC_REGISTER(videoparsersbad);
 GST_PLUGIN_STATIC_REGISTER(applemedia);
#endif

 return true;
}

bool
load_gstreamer()
{
  static bool loaded = false;

  if (loaded) {
    return true;
  }

#if defined(__APPLE__) || !defined(SYSTEM_GSTREAMER)
 loaded = true;
 return init_gstreamer();
#endif

  void *gstreamerLib = nullptr;
  guint major = 0;
  guint minor = 0;
  guint micro, nano;

  typedef typeof(::gst_version) VersionFuncType;
  if (VersionFuncType *versionFunc = (VersionFuncType*)dlsym(RTLD_DEFAULT, "gst_version")) {
    versionFunc(&major, &minor, &micro, &nano);
  }

  if (major == GST_VERSION_MAJOR && minor == GST_VERSION_MINOR) {
    gstreamerLib = RTLD_DEFAULT;
  } else {
    gstreamerLib = dlopen("libgstreamer-" GST_API_VERSION LIB_GST_SUFFIX, RTLD_NOW | RTLD_LOCAL);
  }

  void *handles[3] = {
    gstreamerLib,
    dlopen("libgstapp-" GST_API_VERSION LIB_GST_SUFFIX, RTLD_NOW | RTLD_LOCAL),
    dlopen("libgstvideo-" GST_API_VERSION LIB_GST_SUFFIX, RTLD_NOW | RTLD_LOCAL)
  };

  for (size_t i = 0; i < sizeof(handles) / sizeof(handles[0]); i++) {
    if (!handles[i]) {
      NS_WARNING("Couldn't link gstreamer libraries");
      goto fail;
    }
  }

#define GST_FUNC(lib, symbol) \
  if (!(symbol = (typeof(symbol))dlsym(handles[lib], #symbol))) { \
    NS_WARNING("Couldn't link symbol " #symbol); \
    goto fail; \
  }
#define REPLACE_FUNC(symbol) symbol = symbol##_impl;
#include "GStreamerFunctionList.h"
#undef GST_FUNC
#undef REPLACE_FUNC

  loaded = true;
  return init_gstreamer();

fail:

  for (size_t i = 0; i < sizeof(handles) / sizeof(handles[0]); i++) {
    if (handles[i] && handles[i] != RTLD_DEFAULT) {
      dlclose(handles[i]);
    }
  }

  return false;
}

GstBuffer *
gst_buffer_ref_impl(GstBuffer *buf)
{
  return (GstBuffer *)gst_mini_object_ref(GST_MINI_OBJECT_CAST(buf));
}

void
gst_buffer_unref_impl(GstBuffer *buf)
{
  gst_mini_object_unref(GST_MINI_OBJECT_CAST(buf));
}

void
gst_message_unref_impl(GstMessage *msg)
{
  gst_mini_object_unref(GST_MINI_OBJECT_CAST(msg));
}

#if GST_VERSION_MAJOR == 1
void
gst_sample_unref_impl(GstSample *sample)
{
  gst_mini_object_unref(GST_MINI_OBJECT_CAST(sample));
}
#endif

void
gst_caps_unref_impl(GstCaps *caps)
{
  gst_mini_object_unref(GST_MINI_OBJECT_CAST(caps));
}

}
