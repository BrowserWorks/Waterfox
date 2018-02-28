/* This Source Code Form is subject to the terms of the Mozilla Public
 * License, v. 2.0. If a copy of the MPL was not distributed with this
 * file, You can obtain one at http://mozilla.org/MPL/2.0/. */

#include "nsHtml5SpeculativeLoad.h"
#include "nsHtml5TreeOpExecutor.h"

nsHtml5SpeculativeLoad::nsHtml5SpeculativeLoad()
  :
#ifdef DEBUG
  mOpCode(eSpeculativeLoadUninitialized),
#endif
  mIsAsync(false),
  mIsDefer(false)
{
  MOZ_COUNT_CTOR(nsHtml5SpeculativeLoad);
}

nsHtml5SpeculativeLoad::~nsHtml5SpeculativeLoad()
{
  MOZ_COUNT_DTOR(nsHtml5SpeculativeLoad);
  NS_ASSERTION(mOpCode != eSpeculativeLoadUninitialized,
               "Uninitialized speculative load.");
}

void
nsHtml5SpeculativeLoad::Perform(nsHtml5TreeOpExecutor* aExecutor)
{
  switch (mOpCode) {
    case eSpeculativeLoadBase:
      aExecutor->SetSpeculationBase(mUrl);
      break;
    case eSpeculativeLoadCSP:
      aExecutor->AddSpeculationCSP(mMetaCSP);
      break;
    case eSpeculativeLoadMetaReferrer:
      aExecutor->SetSpeculationReferrerPolicy(mReferrerPolicy);
      break;
    case eSpeculativeLoadImage:
      aExecutor->PreloadImage(mUrl, mCrossOrigin, mSrcset, mSizes, mReferrerPolicy);
      break;
    case eSpeculativeLoadOpenPicture:
      aExecutor->PreloadOpenPicture();
      break;
    case eSpeculativeLoadEndPicture:
      aExecutor->PreloadEndPicture();
      break;
    case eSpeculativeLoadPictureSource:
      aExecutor->PreloadPictureSource(mSrcset, mSizes, mTypeOrCharsetSourceOrDocumentMode,
                                      mMedia);
      break;
    case eSpeculativeLoadScript:
      aExecutor->PreloadScript(mUrl, mCharset, mTypeOrCharsetSourceOrDocumentMode,
                               mCrossOrigin, mIntegrity, false, mIsAsync, mIsDefer);
      break;
    case eSpeculativeLoadScriptFromHead:
      aExecutor->PreloadScript(mUrl, mCharset, mTypeOrCharsetSourceOrDocumentMode,
                               mCrossOrigin, mIntegrity, true, mIsAsync, mIsDefer);
      break;
    case eSpeculativeLoadStyle:
      aExecutor->PreloadStyle(mUrl, mCharset, mCrossOrigin, mIntegrity);
      break;
    case eSpeculativeLoadManifest:  
      aExecutor->ProcessOfflineManifest(mUrl);
      break;
    case eSpeculativeLoadSetDocumentCharset: {
        nsAutoCString narrowName;
        CopyUTF16toUTF8(mCharset, narrowName);
        NS_ASSERTION(mTypeOrCharsetSourceOrDocumentMode.Length() == 1,
            "Unexpected charset source string");
        int32_t intSource = (int32_t)mTypeOrCharsetSourceOrDocumentMode.First();
        aExecutor->SetDocumentCharsetAndSource(Encoding::ForName(narrowName),
                                               intSource);
      }
      break;
    case eSpeculativeLoadSetDocumentMode: {
        NS_ASSERTION(mTypeOrCharsetSourceOrDocumentMode.Length() == 1,
            "Unexpected document mode string");
        nsHtml5DocumentMode mode =
            (nsHtml5DocumentMode)mTypeOrCharsetSourceOrDocumentMode.First();
        aExecutor->SetDocumentMode(mode);
      }
      break;
    case eSpeculativeLoadPreconnect:
      aExecutor->Preconnect(mUrl, mCrossOrigin);
      break;
    default:
      NS_NOTREACHED("Bogus speculative load.");
      break;
  }
}
