/* -*- Mode: C++; tab-width: 2; indent-tabs-mode: nil; c-basic-offset: 2 -*- */
/* This Source Code Form is subject to the terms of the Mozilla Public
 * License, v. 2.0. If a copy of the MPL was not distributed with this
 * file, You can obtain one at http://mozilla.org/MPL/2.0/. */
#ifndef nsPrintEngine_h___
#define nsPrintEngine_h___

#include "mozilla/Attributes.h"
#include "mozilla/UniquePtr.h"

#include "nsCOMPtr.h"

#include "nsPrintObject.h"
#include "nsPrintData.h"
#include "nsFrameList.h"
#include "nsIFrame.h"
#include "nsIWebProgress.h"
#include "mozilla/dom/HTMLCanvasElement.h"
#include "nsIWebProgressListener.h"
#include "nsWeakReference.h"

// Interfaces
#include "nsIObserver.h"

// Classes
class nsPagePrintTimer;
class nsIDocShell;
class nsIDocument;
class nsIDocumentViewerPrint;
class nsPrintObject;
class nsIDocShell;
class nsIPageSequenceFrame;

//------------------------------------------------------------------------
// nsPrintEngine Class
//
//------------------------------------------------------------------------
class nsPrintEngine final : public nsIObserver,
                            public nsIWebProgressListener,
                            public nsSupportsWeakReference
{
public:
  // nsISupports interface...
  NS_DECL_ISUPPORTS

  // nsIObserver
  NS_DECL_NSIOBSERVER

  NS_DECL_NSIWEBPROGRESSLISTENER

  // Old nsIWebBrowserPrint methods; not cleaned up yet
  NS_IMETHOD Print(nsIPrintSettings*       aPrintSettings,
                   nsIWebProgressListener* aWebProgressListener);
  NS_IMETHOD PrintPreview(nsIPrintSettings* aPrintSettings,
                          mozIDOMWindowProxy* aChildDOMWin,
                          nsIWebProgressListener* aWebProgressListener);
  NS_IMETHOD GetIsFramesetDocument(bool *aIsFramesetDocument);
  NS_IMETHOD GetIsIFrameSelected(bool *aIsIFrameSelected);
  NS_IMETHOD GetIsRangeSelection(bool *aIsRangeSelection);
  NS_IMETHOD GetIsFramesetFrameSelected(bool *aIsFramesetFrameSelected);
  NS_IMETHOD GetPrintPreviewNumPages(int32_t *aPrintPreviewNumPages);
  NS_IMETHOD EnumerateDocumentNames(uint32_t* aCount, char16_t*** aResult);
  static nsresult GetGlobalPrintSettings(nsIPrintSettings** aPrintSettings);
  NS_IMETHOD GetDoingPrint(bool *aDoingPrint);
  NS_IMETHOD GetDoingPrintPreview(bool *aDoingPrintPreview);
  NS_IMETHOD GetCurrentPrintSettings(nsIPrintSettings **aCurrentPrintSettings);


  // This enum tells indicates what the default should be for the title
  // if the title from the document is null
  enum eDocTitleDefault {
    eDocTitleDefBlank,
    eDocTitleDefURLDoc
  };

  nsPrintEngine();

  void Destroy();
  void DestroyPrintingData();

  nsresult Initialize(nsIDocumentViewerPrint* aDocViewerPrint, 
                      nsIDocShell*            aContainer,
                      nsIDocument*            aDocument,
                      float                   aScreenDPI,
                      FILE*                   aDebugFile);

  nsresult GetSeqFrameAndCountPages(nsIFrame*& aSeqFrame, int32_t& aCount);

  //
  // The following three methods are used for printing...
  //
  nsresult DocumentReadyForPrinting();
  nsresult GetSelectionDocument(nsIDeviceContextSpec * aDevSpec,
                                nsIDocument ** aNewDoc);

  nsresult SetupToPrintContent();
  nsresult EnablePOsForPrinting();
  nsPrintObject* FindSmallestSTF();

  bool     PrintDocContent(nsPrintObject* aPO, nsresult& aStatus);
  nsresult DoPrint(nsPrintObject * aPO);

  void SetPrintPO(nsPrintObject* aPO, bool aPrint);

  void TurnScriptingOn(bool aDoTurnOn);
  bool CheckDocumentForPPCaching();
  void InstallPrintPreviewListener();

  // nsIDocumentViewerPrint Printing Methods
  bool     HasPrintCallbackCanvas();
  bool     PrePrintPage();
  bool     PrintPage(nsPrintObject* aPOect, bool& aInRange);
  bool     DonePrintingPages(nsPrintObject* aPO, nsresult aResult);

  //---------------------------------------------------------------------
  void BuildDocTree(nsIDocShell *      aParentNode,
                    nsTArray<nsPrintObject*> * aDocList,
                    nsPrintObject *            aPO);
  nsresult ReflowDocList(nsPrintObject * aPO, bool aSetPixelScale);

  nsresult ReflowPrintObject(nsPrintObject * aPO);

  void CheckForChildFrameSets(nsPrintObject* aPO);

  void CalcNumPrintablePages(int32_t& aNumPages);
  void ShowPrintProgress(bool aIsForPrinting, bool& aDoNotify);
  nsresult CleanupOnFailure(nsresult aResult, bool aIsPrinting);
  // If FinishPrintPreview() fails, caller may need to reset the state of the
  // object, for example by calling CleanupOnFailure().
  nsresult FinishPrintPreview();
  static void CloseProgressDialog(nsIWebProgressListener* aWebProgressListener);
  void SetDocAndURLIntoProgress(nsPrintObject* aPO,
                                nsIPrintProgressParams* aParams);
  void EllipseLongString(nsAString& aStr, const uint32_t aLen, bool aDoFront);
  nsresult CheckForPrinters(nsIPrintSettings* aPrintSettings);
  void CleanupDocTitleArray(char16_t**& aArray, int32_t& aCount);

  bool IsThereARangeSelection(nsPIDOMWindowOuter* aDOMWin);

  void FirePrintingErrorEvent(nsresult aPrintError);
  //---------------------------------------------------------------------


  // Timer Methods
  nsresult StartPagePrintTimer(nsPrintObject* aPO);

  bool IsWindowsInOurSubTree(nsPIDOMWindowOuter* aDOMWindow);
  static bool IsParentAFrameSet(nsIDocShell * aParent);
  bool IsThereAnIFrameSelected(nsIDocShell* aDocShell,
                               nsPIDOMWindowOuter* aDOMWin,
                               bool& aIsParentFrameSet);

  static nsPrintObject* FindPrintObjectByDOMWin(nsPrintObject* aParentObject,
                                                nsPIDOMWindowOuter* aDOMWin);

  // get the currently infocus frame for the document viewer
  already_AddRefed<nsPIDOMWindowOuter> FindFocusedDOMWindow();

  //---------------------------------------------------------------------
  // Static Methods
  //---------------------------------------------------------------------
  static void GetDocumentTitleAndURL(nsIDocument* aDoc,
                                     nsAString&   aTitle,
                                     nsAString&   aURLStr);
  void GetDisplayTitleAndURL(nsPrintObject*   aPO,
                             nsAString&       aTitle,
                             nsAString&       aURLStr,
                             eDocTitleDefault aDefType);

  static bool HasFramesetChild(nsIContent* aContent);

  bool     CheckBeforeDestroy();
  nsresult Cancelled();

  nsIPresShell* GetPrintPreviewPresShell() {return mPrtPreview->mPrintObject->mPresShell;}

  float GetPrintPreviewScale() { return mPrtPreview->mPrintObject->
                                        mPresContext->GetPrintPreviewScale(); }
  
  static nsIPresShell* GetPresShellFor(nsIDocShell* aDocShell);

  // These calls also update the DocViewer
  void SetIsPrinting(bool aIsPrinting);
  bool GetIsPrinting()
  {
    return mIsDoingPrinting;
  }
  void SetIsPrintPreview(bool aIsPrintPreview);
  bool GetIsPrintPreview()
  {
    return mIsDoingPrintPreview;
  }
  void SetIsCreatingPrintPreview(bool aIsCreatingPrintPreview)
  {
    mIsCreatingPrintPreview = aIsCreatingPrintPreview;
  }
  bool GetIsCreatingPrintPreview()
  {
    return mIsCreatingPrintPreview;
  }

  void SetDisallowSelectionPrint(bool aDisallowSelectionPrint)
  {
    mDisallowSelectionPrint = aDisallowSelectionPrint;
  }

protected:
  ~nsPrintEngine();

  nsresult CommonPrint(bool aIsPrintPreview, nsIPrintSettings* aPrintSettings,
                       nsIWebProgressListener* aWebProgressListener,
                       nsIDOMDocument* aDoc);

  nsresult DoCommonPrint(bool aIsPrintPreview, nsIPrintSettings* aPrintSettings,
                         nsIWebProgressListener* aWebProgressListener,
                         nsIDOMDocument* aDoc);

  void FirePrintCompletionEvent();
  static nsresult GetSeqFrameAndCountPagesInternal(nsPrintObject*  aPO,
                                                   nsIFrame*&      aSeqFrame,
                                                   int32_t&        aCount);

  static nsresult FindSelectionBoundsWithList(nsFrameList::Enumerator& aChildFrames,
                                              nsIFrame *      aParentFrame,
                                              nsRect&         aRect,
                                              nsIFrame *&     aStartFrame,
                                              nsRect&         aStartRect,
                                              nsIFrame *&     aEndFrame,
                                              nsRect&         aEndRect);

  static nsresult FindSelectionBounds(nsIFrame *      aParentFrame,
                                      nsRect&         aRect,
                                      nsIFrame *&     aStartFrame,
                                      nsRect&         aStartRect,
                                      nsIFrame *&     aEndFrame,
                                      nsRect&         aEndRect);

  static nsresult GetPageRangeForSelection(nsIPageSequenceFrame* aPageSeqFrame,
                                           nsIFrame**            aStartFrame,
                                           int32_t&              aStartPageNum,
                                           nsRect&               aStartRect,
                                           nsIFrame**            aEndFrame,
                                           int32_t&              aEndPageNum,
                                           nsRect&               aEndRect);

  static void MapContentForPO(nsPrintObject* aPO, nsIContent* aContent);

  static void MapContentToWebShells(nsPrintObject* aRootPO, nsPrintObject* aPO);

  static void SetPrintAsIs(nsPrintObject* aPO, bool aAsIs = true);

  void DisconnectPagePrintTimer();

  // Static member variables
  bool mIsCreatingPrintPreview;
  bool mIsDoingPrinting;
  bool mIsDoingPrintPreview; // per DocumentViewer
  bool mProgressDialogIsShown;

  nsCOMPtr<nsIDocumentViewerPrint> mDocViewerPrint;
  nsWeakPtr               mContainer;
  float                   mScreenDPI;
  
  mozilla::UniquePtr<nsPrintData> mPrt;
  nsPagePrintTimer*       mPagePrintTimer;
  nsWeakFrame             mPageSeqFrame;

  // Print Preview
  mozilla::UniquePtr<nsPrintData> mPrtPreview;
  mozilla::UniquePtr<nsPrintData> mOldPrtPreview;

  nsCOMPtr<nsIDocument>   mDocument;

  FILE* mDebugFile;

  int32_t mLoadCounter;
  bool mDidLoadDataForPrinting;
  bool mIsDestroying;
  bool mDisallowSelectionPrint;

  nsresult AfterNetworkPrint(bool aHandleError);

  nsresult SetRootView(nsPrintObject* aPO,
                       bool& aDoReturn,
                       bool& aDocumentIsTopLevel,
                       nsSize& aAdjSize);
  nsView* GetParentViewForRoot();
  bool DoSetPixelScale();
  void UpdateZoomRatio(nsPrintObject* aPO, bool aSetPixelScale);
  nsresult ReconstructAndReflow(bool aDoSetPixelScale);
  nsresult UpdateSelectionAndShrinkPrintObject(nsPrintObject* aPO,
                                               bool aDocumentIsTopLevel);
  nsresult InitPrintDocConstruction(bool aHandleError);
  void FirePrintPreviewUpdateEvent();
private:
  nsPrintEngine& operator=(const nsPrintEngine& aOther) = delete;
};

#endif /* nsPrintEngine_h___ */
