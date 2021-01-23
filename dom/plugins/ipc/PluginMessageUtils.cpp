/* -*- Mode: C++; c-basic-offset: 2; indent-tabs-mode: nil; tab-width: 8; -*- */
/* vim: set sw=2 ts=8 et tw=80 : */
/* This Source Code Form is subject to the terms of the Mozilla Public
 * License, v. 2.0. If a copy of the MPL was not distributed with this
 * file, You can obtain one at http://mozilla.org/MPL/2.0/. */

#include "PluginMessageUtils.h"
#include "nsThreadUtils.h"

#include "PluginInstanceParent.h"
#include "PluginInstanceChild.h"
#include "PluginScriptableObjectParent.h"
#include "PluginScriptableObjectChild.h"

using std::string;

using mozilla::ipc::MessageChannel;

namespace {

class DeferNPObjectReleaseRunnable : public mozilla::Runnable {
 public:
  DeferNPObjectReleaseRunnable(const NPNetscapeFuncs* f, NPObject* o)
      : Runnable("DeferNPObjectReleaseRunnable"), mFuncs(f), mObject(o) {
    NS_ASSERTION(o, "no release null objects");
  }

  NS_IMETHOD Run() override;

 private:
  const NPNetscapeFuncs* mFuncs;
  NPObject* mObject;
};

NS_IMETHODIMP
DeferNPObjectReleaseRunnable::Run() {
  mFuncs->releaseobject(mObject);
  return NS_OK;
}

}  // namespace

namespace mozilla {
namespace plugins {

NPRemoteWindow::NPRemoteWindow()
    : window(0),
      x(0),
      y(0),
      width(0),
      height(0),
      type(NPWindowTypeDrawable)
#if defined(MOZ_X11) && defined(XP_UNIX) && !defined(XP_MACOSX)
      ,
      visualID(0),
      colormap(0)
#endif /* XP_UNIX */
#if defined(XP_MACOSX)
      ,
      contentsScaleFactor(1.0)
#endif
{
  clipRect.top = 0;
  clipRect.left = 0;
  clipRect.bottom = 0;
  clipRect.right = 0;
}

ipc::RacyInterruptPolicy MediateRace(const MessageChannel::MessageInfo& parent,
                                     const MessageChannel::MessageInfo& child) {
  switch (parent.type()) {
    case PPluginInstance::Msg_Paint__ID:
    case PPluginInstance::Msg_NPP_SetWindow__ID:
    case PPluginInstance::Msg_NPP_HandleEvent_Shmem__ID:
    case PPluginInstance::Msg_NPP_HandleEvent_IOSurface__ID:
      // our code relies on the frame list not changing during paints and
      // reflows
      return ipc::RIPParentWins;

    default:
      return ipc::RIPChildWins;
  }
}

#if defined(OS_LINUX) || defined(OS_SOLARIS)
static string ReplaceAll(const string& haystack, const string& needle,
                         const string& with) {
  string munged = haystack;
  string::size_type i = 0;

  while (string::npos != (i = munged.find(needle, i))) {
    munged.replace(i, needle.length(), with);
    i += with.length();
  }

  return munged;
}
#endif

string MungePluginDsoPath(const string& path) {
#if defined(OS_LINUX) || defined(OS_SOLARIS)
  // https://bugzilla.mozilla.org/show_bug.cgi?id=519601
  return ReplaceAll(path, "netscape", "netsc@pe");
#else
  return path;
#endif
}

string UnmungePluginDsoPath(const string& munged) {
#if defined(OS_LINUX) || defined(OS_SOLARIS)
  return ReplaceAll(munged, "netsc@pe", "netscape");
#else
  return munged;
#endif
}

LogModule* GetPluginLog() {
  static LazyLogModule sLog("IPCPlugins");
  return sLog;
}

void DeferNPObjectLastRelease(const NPNetscapeFuncs* f, NPObject* o) {
  if (!o) return;

  if (o->referenceCount > 1) {
    f->releaseobject(o);
    return;
  }

  NS_DispatchToCurrentThread(new DeferNPObjectReleaseRunnable(f, o));
}

void DeferNPVariantLastRelease(const NPNetscapeFuncs* f, NPVariant* v) {
  if (!NPVARIANT_IS_OBJECT(*v)) {
    f->releasevariantvalue(v);
    return;
  }
  DeferNPObjectLastRelease(f, v->value.objectValue);
  VOID_TO_NPVARIANT(*v);
}

}  // namespace plugins
}  // namespace mozilla
