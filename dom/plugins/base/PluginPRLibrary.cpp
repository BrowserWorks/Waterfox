/* -*- Mode: C++; tab-width: 8; indent-tabs-mode: nil; c-basic-offset: 2 -*-
 * vim: sw=2 ts=8 et :
 * This Source Code Form is subject to the terms of the Mozilla Public
 * License, v. 2.0. If a copy of the MPL was not distributed with this
 * file, You can obtain one at http://mozilla.org/MPL/2.0/. */

#include "mozilla/PluginPRLibrary.h"
#include "nsNPAPIPluginInstance.h"

// Some plugins on Windows, notably Quake Live, implement NP_Initialize using
// cdecl instead of the documented stdcall. In order to work around this,
// we force the caller to use a frame pointer.
#if defined(XP_WIN) && defined(_M_IX86)
#include <malloc.h>

// gNotOptimized exists so that the compiler will not optimize the alloca
// below.
static int gNotOptimized;
#define CALLING_CONVENTION_HACK void* foo = _alloca(gNotOptimized);
#else
#define CALLING_CONVENTION_HACK
#endif

using namespace mozilla::layers;

namespace mozilla {
#if defined(XP_UNIX) && !defined(XP_MACOSX)
nsresult
PluginPRLibrary::NP_Initialize(NPNetscapeFuncs* bFuncs,
                               NPPluginFuncs* pFuncs, NPError* error)
{
  if (mNP_Initialize) {
    *error = mNP_Initialize(bFuncs, pFuncs);
  } else {
    NP_InitializeFunc pfNP_Initialize = (NP_InitializeFunc)
      PR_FindFunctionSymbol(mLibrary, "NP_Initialize");
    if (!pfNP_Initialize)
      return NS_ERROR_FAILURE;
    *error = pfNP_Initialize(bFuncs, pFuncs);
  }


  // Save pointers to functions that get called through PluginLibrary itself.
  mNPP_New = pFuncs->newp;
  mNPP_ClearSiteData = pFuncs->clearsitedata;
  mNPP_GetSitesWithData = pFuncs->getsiteswithdata;
  return NS_OK;
}
#else
nsresult
PluginPRLibrary::NP_Initialize(NPNetscapeFuncs* bFuncs, NPError* error)
{
  CALLING_CONVENTION_HACK

  if (mNP_Initialize) {
    *error = mNP_Initialize(bFuncs);
  } else {
    NP_InitializeFunc pfNP_Initialize = (NP_InitializeFunc)
      PR_FindFunctionSymbol(mLibrary, "NP_Initialize");
    if (!pfNP_Initialize)
      return NS_ERROR_FAILURE;
    *error = pfNP_Initialize(bFuncs);
  }

  return NS_OK;
}
#endif

nsresult
PluginPRLibrary::NP_Shutdown(NPError* error)
{
  CALLING_CONVENTION_HACK

  if (mNP_Shutdown) {
    *error = mNP_Shutdown();
  } else {
    NP_ShutdownFunc pfNP_Shutdown = (NP_ShutdownFunc)
      PR_FindFunctionSymbol(mLibrary, "NP_Shutdown");
    if (!pfNP_Shutdown)
      return NS_ERROR_FAILURE;
    *error = pfNP_Shutdown();
  }

  return NS_OK;
}

nsresult
PluginPRLibrary::NP_GetMIMEDescription(const char** mimeDesc)
{
  CALLING_CONVENTION_HACK

  if (mNP_GetMIMEDescription) {
    *mimeDesc = mNP_GetMIMEDescription();
  }
  else {
    NP_GetMIMEDescriptionFunc pfNP_GetMIMEDescription =
      (NP_GetMIMEDescriptionFunc)
      PR_FindFunctionSymbol(mLibrary, "NP_GetMIMEDescription");
    if (!pfNP_GetMIMEDescription) {
      *mimeDesc = "";
      return NS_ERROR_FAILURE;
    }
    *mimeDesc = pfNP_GetMIMEDescription();
  }

  return NS_OK;
}

nsresult
PluginPRLibrary::NP_GetValue(void *future, NPPVariable aVariable,
			     void *aValue, NPError* error)
{
#if defined(XP_UNIX) && !defined(XP_MACOSX)
  if (mNP_GetValue) {
    *error = mNP_GetValue(future, aVariable, aValue);
  } else {
    NP_GetValueFunc pfNP_GetValue = (NP_GetValueFunc)PR_FindFunctionSymbol(mLibrary, "NP_GetValue");
    if (!pfNP_GetValue)
      return NS_ERROR_FAILURE;
    *error = pfNP_GetValue(future, aVariable, aValue);
  }
  return NS_OK;
#else
  return NS_ERROR_NOT_IMPLEMENTED;
#endif
}

#if defined(XP_WIN) || defined(XP_MACOSX)
nsresult
PluginPRLibrary::NP_GetEntryPoints(NPPluginFuncs* pFuncs, NPError* error)
{
  CALLING_CONVENTION_HACK

  if (mNP_GetEntryPoints) {
    *error = mNP_GetEntryPoints(pFuncs);
  } else {
    NP_GetEntryPointsFunc pfNP_GetEntryPoints = (NP_GetEntryPointsFunc)
      PR_FindFunctionSymbol(mLibrary, "NP_GetEntryPoints");
    if (!pfNP_GetEntryPoints)
      return NS_ERROR_FAILURE;
    *error = pfNP_GetEntryPoints(pFuncs);
  }

  // Save pointers to functions that get called through PluginLibrary itself.
  mNPP_New = pFuncs->newp;
  mNPP_ClearSiteData = pFuncs->clearsitedata;
  mNPP_GetSitesWithData = pFuncs->getsiteswithdata;
  return NS_OK;
}
#endif

nsresult
PluginPRLibrary::NPP_New(NPMIMEType pluginType, NPP instance,
			 int16_t argc, char* argn[],
			 char* argv[], NPSavedData* saved,
			 NPError* error)
{
  if (!mNPP_New)
    return NS_ERROR_FAILURE;

  *error = mNPP_New(pluginType, instance, NP_EMBED, argc, argn, argv, saved);
  return NS_OK;
}

nsresult
PluginPRLibrary::NPP_ClearSiteData(const char* site, uint64_t flags,
                                   uint64_t maxAge, nsCOMPtr<nsIClearSiteDataCallback> callback)
{
  if (!mNPP_ClearSiteData) {
    return NS_ERROR_NOT_AVAILABLE;
  }

  NPError result = mNPP_ClearSiteData(site, flags, maxAge);

  nsresult rv;
  switch (result) {
  case NPERR_NO_ERROR:
    rv = NS_OK;
    break;
  case NPERR_TIME_RANGE_NOT_SUPPORTED:
    rv = NS_ERROR_PLUGIN_TIME_RANGE_NOT_SUPPORTED;
    break;
  case NPERR_MALFORMED_SITE:
    rv = NS_ERROR_INVALID_ARG;
    break;
  default:
    rv = NS_ERROR_FAILURE;
  }
  callback->Callback(rv);
  return NS_OK;
}

nsresult
PluginPRLibrary::NPP_GetSitesWithData(nsCOMPtr<nsIGetSitesWithDataCallback> callback)
{
  if (!mNPP_GetSitesWithData) {
    return NS_ERROR_NOT_AVAILABLE;
  }

  char** sites = mNPP_GetSitesWithData();
  if (!sites) {
    return NS_OK;
  }
  InfallibleTArray<nsCString> result;
  char** iterator = sites;
  while (*iterator) {
    result.AppendElement(*iterator);
    free(*iterator);
    ++iterator;
  }
  callback->SitesWithData(result);
  free(sites);

  return NS_OK;
}

nsresult
PluginPRLibrary::AsyncSetWindow(NPP instance, NPWindow* window)
{
  nsNPAPIPluginInstance* inst = (nsNPAPIPluginInstance*)instance->ndata;
  NS_ENSURE_TRUE(inst, NS_ERROR_NULL_POINTER);
  return NS_ERROR_NOT_IMPLEMENTED;
}

nsresult
PluginPRLibrary::GetImageContainer(NPP instance, ImageContainer** aContainer)
{
  return NS_ERROR_NOT_IMPLEMENTED;
}

#if defined(XP_MACOSX)
nsresult
PluginPRLibrary::IsRemoteDrawingCoreAnimation(NPP instance, bool *aDrawing)
{
  nsNPAPIPluginInstance* inst = (nsNPAPIPluginInstance*)instance->ndata;
  NS_ENSURE_TRUE(inst, NS_ERROR_NULL_POINTER);
  *aDrawing = false;
  return NS_OK;
}
#endif
#if defined(XP_MACOSX) || defined(XP_WIN)
nsresult
PluginPRLibrary::ContentsScaleFactorChanged(NPP instance, double aContentsScaleFactor)
{
  nsNPAPIPluginInstance* inst = (nsNPAPIPluginInstance*)instance->ndata;
  NS_ENSURE_TRUE(inst, NS_ERROR_NULL_POINTER);
  return NS_OK;
}
#endif

nsresult
PluginPRLibrary::GetImageSize(NPP instance, nsIntSize* aSize)
{
  return NS_ERROR_NOT_IMPLEMENTED;
}

nsresult
PluginPRLibrary::SetBackgroundUnknown(NPP instance)
{
  nsNPAPIPluginInstance* inst = (nsNPAPIPluginInstance*)instance->ndata;
  NS_ENSURE_TRUE(inst, NS_ERROR_NULL_POINTER);
  NS_ERROR("Unexpected use of async APIs for in-process plugin.");
  return NS_ERROR_NOT_IMPLEMENTED;
}

nsresult
PluginPRLibrary::BeginUpdateBackground(NPP instance, const nsIntRect&,
                                       DrawTarget** aDrawTarget)
{
  nsNPAPIPluginInstance* inst = (nsNPAPIPluginInstance*)instance->ndata;
  NS_ENSURE_TRUE(inst, NS_ERROR_NULL_POINTER);
  NS_ERROR("Unexpected use of async APIs for in-process plugin.");
  *aDrawTarget = nullptr;
  return NS_OK;
}

nsresult
PluginPRLibrary::EndUpdateBackground(NPP instance, const nsIntRect&)
{
  MOZ_CRASH("This should never be called");
  return NS_ERROR_NOT_AVAILABLE;
}

#if defined(XP_WIN)
nsresult
PluginPRLibrary::GetScrollCaptureContainer(NPP aInstance, ImageContainer** aContainer)
{
  return NS_ERROR_NOT_IMPLEMENTED;
}
#endif

nsresult
PluginPRLibrary::HandledWindowedPluginKeyEvent(
                   NPP aInstance,
                   const NativeEventData& aNativeKeyData,
                   bool aIsConsumed)
{
  nsNPAPIPluginInstance* instance = (nsNPAPIPluginInstance*)aInstance->ndata;
  if (NS_WARN_IF(!instance)) {
    return NS_ERROR_NULL_POINTER;
  }
  return NS_OK;
}

} // namespace mozilla
