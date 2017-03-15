/* -*- Mode: C++; tab-width: 4; indent-tabs-mode: nil; c-basic-offset: 4 -*-
 *
 * This Source Code Form is subject to the terms of the Mozilla Public
 * License, v. 2.0. If a copy of the MPL was not distributed with this
 * file, You can obtain one at http://mozilla.org/MPL/2.0/. */

#include "nsCOMPtr.h"

#include "nsPrintingPromptService.h"
#include "nsIPrintingPromptService.h"
#include "nsIFactory.h"
#include "nsPIDOMWindow.h"
#include "nsReadableUtils.h"
#include "nsIEmbeddingSiteWindow.h"
#include "nsIServiceManager.h"
#include "nsIWebBrowserChrome.h"
#include "nsIWindowWatcher.h"
#include "nsPrintDialogUtil.h"

// Printing Progress Includes
#include "nsPrintProgress.h"
#include "nsPrintProgressParams.h"
#include "nsIWebProgressListener.h"

// XP Dialog includes
#include "nsArray.h"
#include "nsIDialogParamBlock.h"
#include "nsISupportsUtils.h"

// Includes need to locate the native Window
#include "nsIWidget.h"
#include "nsIBaseWindow.h"
#include "nsIWebBrowserChrome.h"
#include "nsIDocShellTreeOwner.h"
#include "nsIDocShellTreeItem.h"
#include "nsIDocShell.h"
#include "nsIInterfaceRequestorUtils.h"


static const char *kPrintProgressDialogURL  = "chrome://global/content/printProgress.xul";
static const char *kPrtPrvProgressDialogURL = "chrome://global/content/printPreviewProgress.xul";
static const char *kPageSetupDialogURL      = "chrome://global/content/printPageSetup.xul";

/****************************************************************
 ************************* ParamBlock ***************************
 ****************************************************************/

class ParamBlock {

public:
    ParamBlock() 
    {
        mBlock = 0;
    }
    ~ParamBlock() 
    {
        NS_IF_RELEASE(mBlock);
    }
    nsresult Init() {
      return CallCreateInstance(NS_DIALOGPARAMBLOCK_CONTRACTID, &mBlock);
    }
    nsIDialogParamBlock * operator->() const MOZ_NO_ADDREF_RELEASE_ON_RETURN { return mBlock; }
    operator nsIDialogParamBlock * const ()  { return mBlock; }

private:
    nsIDialogParamBlock *mBlock;
};

//*****************************************************************************   

NS_IMPL_ISUPPORTS(nsPrintingPromptService, nsIPrintingPromptService, nsIWebProgressListener)

nsPrintingPromptService::nsPrintingPromptService() 
{
}

//-----------------------------------------------------------
nsPrintingPromptService::~nsPrintingPromptService()
{
}

//-----------------------------------------------------------
nsresult
nsPrintingPromptService::Init()
{
    nsresult rv;
    mWatcher = do_GetService(NS_WINDOWWATCHER_CONTRACTID, &rv);
    return rv;
}

//-----------------------------------------------------------
HWND
nsPrintingPromptService::GetHWNDForDOMWindow(mozIDOMWindowProxy *aWindow)
{
    nsCOMPtr<nsIWebBrowserChrome> chrome;

    // We might be embedded so check this path first
    if (mWatcher) {
        nsCOMPtr<mozIDOMWindowProxy> fosterParent;
        if (!aWindow) 
        {   // it will be a dependent window. try to find a foster parent.
            mWatcher->GetActiveWindow(getter_AddRefs(fosterParent));
            aWindow = fosterParent;
        }
        mWatcher->GetChromeForWindow(aWindow, getter_AddRefs(chrome));
    }

    if (chrome) {
        nsCOMPtr<nsIEmbeddingSiteWindow> site(do_QueryInterface(chrome));
        if (site) 
        {
            HWND w;
            site->GetSiteWindow(reinterpret_cast<void **>(&w));
            return w;
        }
    }

    // Now we might be the Browser so check this path
    nsCOMPtr<nsPIDOMWindowOuter> window = nsPIDOMWindowOuter::From(aWindow);

    nsCOMPtr<nsIDocShellTreeItem> treeItem =
        do_QueryInterface(window->GetDocShell());
    if (!treeItem) return nullptr;

    nsCOMPtr<nsIDocShellTreeOwner> treeOwner;
    treeItem->GetTreeOwner(getter_AddRefs(treeOwner));
    if (!treeOwner) return nullptr;

    nsCOMPtr<nsIWebBrowserChrome> webBrowserChrome(do_GetInterface(treeOwner));
    if (!webBrowserChrome) return nullptr;

    nsCOMPtr<nsIBaseWindow> baseWin(do_QueryInterface(webBrowserChrome));
    if (!baseWin) return nullptr;

    nsCOMPtr<nsIWidget> widget;
    baseWin->GetMainWidget(getter_AddRefs(widget));
    if (!widget) return nullptr;

    return (HWND)widget->GetNativeData(NS_NATIVE_TMP_WINDOW);

}


///////////////////////////////////////////////////////////////////////////////
// nsIPrintingPromptService

//-----------------------------------------------------------
NS_IMETHODIMP 
nsPrintingPromptService::ShowPrintDialog(mozIDOMWindowProxy *parent, nsIWebBrowserPrint *webBrowserPrint, nsIPrintSettings *printSettings)
{
    NS_ENSURE_ARG(parent);

    HWND hWnd = GetHWNDForDOMWindow(parent);
    NS_ASSERTION(hWnd, "Couldn't get native window for PRint Dialog!");

    return NativeShowPrintDialog(hWnd, webBrowserPrint, printSettings);
}


NS_IMETHODIMP 
nsPrintingPromptService::ShowProgress(mozIDOMWindowProxy*      parent, 
                                      nsIWebBrowserPrint*      webBrowserPrint,    // ok to be null
                                      nsIPrintSettings*        printSettings,      // ok to be null
                                      nsIObserver*             openDialogObserver, // ok to be null
                                      bool                     isForPrinting,
                                      nsIWebProgressListener** webProgressListener,
                                      nsIPrintProgressParams** printProgressParams,
                                      bool*                  notifyOnOpen)
{
    NS_ENSURE_ARG(webProgressListener);
    NS_ENSURE_ARG(printProgressParams);
    NS_ENSURE_ARG(notifyOnOpen);

    *notifyOnOpen = false;
    if (mPrintProgress) {
        *webProgressListener = nullptr;
        *printProgressParams = nullptr;
        return NS_ERROR_FAILURE;
    }

    nsPrintProgress* prtProgress = new nsPrintProgress();
    mPrintProgress = prtProgress;
    mWebProgressListener = prtProgress;

    nsCOMPtr<nsIPrintProgressParams> prtProgressParams = new nsPrintProgressParams();

    nsCOMPtr<mozIDOMWindowProxy> parentWindow = parent;

    if (mWatcher && !parentWindow) {
        mWatcher->GetActiveWindow(getter_AddRefs(parentWindow));
    }

    if (parentWindow) {
        mPrintProgress->OpenProgressDialog(parentWindow,
                                           isForPrinting ? kPrintProgressDialogURL : kPrtPrvProgressDialogURL,
                                           prtProgressParams, openDialogObserver, notifyOnOpen);
    }

    prtProgressParams.forget(printProgressParams);
    NS_ADDREF(*webProgressListener = this);

    return NS_OK;
}

NS_IMETHODIMP 
nsPrintingPromptService::ShowPageSetup(mozIDOMWindowProxy *parent, nsIPrintSettings *printSettings, nsIObserver *aObs)
{
    NS_ENSURE_ARG(printSettings);

    ParamBlock block;
    nsresult rv = block.Init();
    if (NS_FAILED(rv))
      return rv;

    block->SetInt(0, 0);
    rv = DoDialog(parent, block, printSettings, kPageSetupDialogURL);

    // if aWebBrowserPrint is not null then we are printing
    // so we want to pass back NS_ERROR_ABORT on cancel
    if (NS_SUCCEEDED(rv)) 
    {
      int32_t status;
      block->GetInt(0, &status);
      return status == 0?NS_ERROR_ABORT:NS_OK;
    }

    return rv;
}

NS_IMETHODIMP 
nsPrintingPromptService::ShowPrinterProperties(mozIDOMWindowProxy *parent, const char16_t *printerName, nsIPrintSettings *printSettings)
{
    return NS_ERROR_NOT_IMPLEMENTED;
}

//-----------------------------------------------------------
// Helper to Fly XP Dialog
nsresult
nsPrintingPromptService::DoDialog(mozIDOMWindowProxy *aParent,
                                  nsIDialogParamBlock *aParamBlock, 
                                  nsIPrintSettings* aPS,
                                  const char *aChromeURL)
{
    NS_ENSURE_ARG(aParamBlock);
    NS_ENSURE_ARG(aPS);
    NS_ENSURE_ARG(aChromeURL);

    if (!mWatcher)
        return NS_ERROR_FAILURE;

    // get a parent, if at all possible
    // (though we'd rather this didn't fail, it's OK if it does. so there's
    // no failure or null check.)
    nsCOMPtr<mozIDOMWindowProxy> activeParent; // retain ownership for method lifetime
    if (!aParent) 
    {
        mWatcher->GetActiveWindow(getter_AddRefs(activeParent));
        aParent = activeParent;
    }

    // create a nsIMutableArray of the parameters 
    // being passed to the window
    nsCOMPtr<nsIMutableArray> array = nsArray::Create();

    nsCOMPtr<nsISupports> psSupports(do_QueryInterface(aPS));
    NS_ASSERTION(psSupports, "PrintSettings must be a supports");
    array->AppendElement(psSupports, /*weak =*/ false);

    nsCOMPtr<nsISupports> blkSupps(do_QueryInterface(aParamBlock));
    NS_ASSERTION(blkSupps, "IOBlk must be a supports");
    array->AppendElement(blkSupps, /*weak =*/ false);

    nsCOMPtr<mozIDOMWindowProxy> dialog;
    nsresult rv = mWatcher->OpenWindow(aParent, aChromeURL, "_blank",
                              "centerscreen,chrome,modal,titlebar", array,
                              getter_AddRefs(dialog));

    return rv;
}

//////////////////////////////////////////////////////////////////////
// nsIWebProgressListener
//////////////////////////////////////////////////////////////////////

NS_IMETHODIMP 
nsPrintingPromptService::OnStateChange(nsIWebProgress *aWebProgress, nsIRequest *aRequest, uint32_t aStateFlags, nsresult aStatus)
{
    if ((aStateFlags & STATE_STOP) && mWebProgressListener) 
    {
        mWebProgressListener->OnStateChange(aWebProgress, aRequest, aStateFlags, aStatus);
        if (mPrintProgress) 
        {
            mPrintProgress->CloseProgressDialog(true);
        }
        mPrintProgress       = nullptr;
        mWebProgressListener = nullptr;
    }
    return NS_OK;
}

NS_IMETHODIMP 
nsPrintingPromptService::OnProgressChange(nsIWebProgress *aWebProgress, nsIRequest *aRequest, int32_t aCurSelfProgress, int32_t aMaxSelfProgress, int32_t aCurTotalProgress, int32_t aMaxTotalProgress)
{
  if (mWebProgressListener) 
  {
      return mWebProgressListener->OnProgressChange(aWebProgress, aRequest, aCurSelfProgress, aMaxSelfProgress, aCurTotalProgress, aMaxTotalProgress);
  }
  return NS_ERROR_FAILURE;
}

NS_IMETHODIMP 
nsPrintingPromptService::OnLocationChange(nsIWebProgress *aWebProgress, nsIRequest *aRequest, nsIURI *location, uint32_t aFlags)
{
  if (mWebProgressListener) 
  {
      return mWebProgressListener->OnLocationChange(aWebProgress, aRequest, location, aFlags);
  }
  return NS_ERROR_FAILURE;
}

NS_IMETHODIMP 
nsPrintingPromptService::OnStatusChange(nsIWebProgress *aWebProgress, nsIRequest *aRequest, nsresult aStatus, const char16_t *aMessage)
{
  if (mWebProgressListener) 
  {
      return mWebProgressListener->OnStatusChange(aWebProgress, aRequest, aStatus, aMessage);
  }
  return NS_ERROR_FAILURE;
}

NS_IMETHODIMP 
nsPrintingPromptService::OnSecurityChange(nsIWebProgress *aWebProgress, nsIRequest *aRequest, uint32_t state)
{
  if (mWebProgressListener) 
  {
      return mWebProgressListener->OnSecurityChange(aWebProgress, aRequest, state);
  }
  return NS_ERROR_FAILURE;
}


