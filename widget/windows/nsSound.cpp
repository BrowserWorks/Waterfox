/*
 * This Source Code Form is subject to the terms of the Mozilla Public
 * License, v. 2.0. If a copy of the MPL was not distributed with this
 * file, You can obtain one at http://mozilla.org/MPL/2.0/. */

#include <windows.h>
// mmsystem.h is needed to build with WIN32_LEAN_AND_MEAN
#include <mmsystem.h>

#include "HeadlessSound.h"
#include "gfxPlatform.h"
#include "mozilla/Atomics.h"
#include "mozilla/ClearOnShutdown.h"
#include "nsSound.h"

// Hackaround for bug 1644240
// When we call PlaySound for the first time in the process, winmm.dll creates
// a new thread and starts a message loop in winmm!mciwindow.  After that,
// every call of PlaySound communicates with that thread via Window messages.
// It seems that Warsaw application hooks USER32!GetMessageA, and there is
// a timing window where they free their trampoline region without reverting
// the hook on USER32!GetMessageA, resulting in crash when winmm!mciwindow
// receives a message because it tries to jump to a freed buffer.
// Based on the crash reports, it happened on all versions of Windows x64, and
// the possible condition was wslbdhm64.dll was loaded but wslbscrwh64.dll was
// unloaded.  Therefore we suppress playing a sound under such a condition.
static bool ShouldSuppressPlaySound() {
#if defined(_M_AMD64)
  if (::GetModuleHandle(L"wslbdhm64.dll") &&
      !::GetModuleHandle(L"wslbscrwh64.dll")) {
    return true;
  }
#endif  // defined(_M_AMD64)
  return false;
}

// PlaySoundW can block indefinitely (bug 1869124), so allow only one call at a
// time. Otherwise a hung audio stack would tie up another thread pool thread
// for every sound.
static mozilla::Atomic<bool> sPlaying(false);

static const wchar_t* GetEventSoundAlias(uint32_t aEventId) {
  switch (aEventId) {
    case nsISound::EVENT_NEW_MAIL_RECEIVED:
      return L"MailBeep";
    case nsISound::EVENT_ALERT_DIALOG_OPEN:
      return L"SystemExclamation";
    case nsISound::EVENT_CONFIRM_DIALOG_OPEN:
      return L"SystemQuestion";
    case nsISound::EVENT_MENU_EXECUTE:
      return L"MenuCommand";
    case nsISound::EVENT_MENU_POPUP:
      return L"MenuPopup";
    case nsISound::EVENT_EDITOR_MAX_LEN:
      return L".Default";
    default:
      // Win32 plays no sounds at NS_SYSSOUND_PROMPT_DIALOG and
      // NS_SYSSOUND_SELECT_DIALOG.
      return nullptr;
  }
}

static void CALLBACK PlayEventSoundCallback(PTP_CALLBACK_INSTANCE,
                                            void* aEventId) {
  if (!ShouldSuppressPlaySound()) {
    // PlaySoundW stops any sound this process is still playing, as we do not
    // pass SND_NOSTOP.
    auto eventId = static_cast<uint32_t>(reinterpret_cast<uintptr_t>(aEventId));
    ::PlaySoundW(GetEventSoundAlias(eventId), nullptr,
                 SND_ALIAS | SND_ASYNC | SND_NODEFAULT);
  }
  sPlaying = false;
}

mozilla::StaticRefPtr<nsISound> nsSound::sInstance;

/* static */
already_AddRefed<nsISound> nsSound::GetInstance() {
  if (!sInstance) {
    if (gfxPlatform::IsHeadless()) {
      sInstance = mozilla::MakeRefPtr<mozilla::widget::HeadlessSound>();
    } else {
      sInstance = mozilla::MakeRefPtr<nsSound>();
    }
    ClearOnShutdown(&sInstance);
  }

  RefPtr<nsISound> service = sInstance;
  return service.forget();
}

NS_IMPL_ISUPPORTS(nsSound, nsISound)

NS_IMETHODIMP nsSound::Beep() {
  ::MessageBeep(0);

  return NS_OK;
}

NS_IMETHODIMP nsSound::Init() { return NS_OK; }

NS_IMETHODIMP nsSound::PlayEventSound(uint32_t aEventId) {
  if (!GetEventSoundAlias(aEventId)) {
    return NS_OK;
  }

  // PlaySoundW can block for a long time, e.g. while loading the audio stack or
  // when it hangs (bug 1869124). Call it on the Windows thread pool, which
  // shutdown never waits for, unlike Gecko threads. The callback only gets the
  // event ID by value, so it is safe to outlive XPCOM.
  if (sPlaying.exchange(true)) {
    return NS_OK;
  }
  if (!::TrySubmitThreadpoolCallback(
          PlayEventSoundCallback,
          reinterpret_cast<void*>(static_cast<uintptr_t>(aEventId)), nullptr)) {
    sPlaying = false;
    return NS_ERROR_FAILURE;
  }
  return NS_OK;
}
