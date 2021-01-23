/* -*- Mode: C++; tab-width: 2; indent-tabs-mode: nil; c-basic-offset: 2 -*- */
/* This Source Code Form is subject to the terms of the Mozilla Public
 * License, v. 2.0. If a copy of the MPL was not distributed with this
 * file, You can obtain one at http://mozilla.org/MPL/2.0/. */

#include "nsDeviceContextSpecWin.h"

#include "mozilla/ArrayUtils.h"
#include "mozilla/gfx/PrintTargetPDF.h"
#include "mozilla/gfx/PrintTargetWindows.h"
#include "mozilla/Logging.h"
#include "mozilla/Preferences.h"
#include "mozilla/RefPtr.h"
#include "mozilla/Telemetry.h"

#include <winspool.h>

#include "nsIWidget.h"

#include "nsTArray.h"
#include "nsIPrintSettingsWin.h"

#include "nsString.h"
#include "nsReadableUtils.h"
#include "nsStringEnumerator.h"

#include "gfxWindowsSurface.h"

#include "nsIFileStreams.h"
#include "nsWindowsHelpers.h"

#include "mozilla/gfx/Logging.h"

#ifdef MOZ_ENABLE_SKIA_PDF
#  include "mozilla/gfx/PrintTargetSkPDF.h"
#  include "mozilla/gfx/PrintTargetEMF.h"
#  include "nsIUUIDGenerator.h"
#  include "nsDirectoryServiceDefs.h"
#  include "nsPrintfCString.h"
#  include "nsThreadUtils.h"
#endif

static mozilla::LazyLogModule kWidgetPrintingLogMod("printing-widget");
#define PR_PL(_p1) MOZ_LOG(kWidgetPrintingLogMod, mozilla::LogLevel::Debug, _p1)

using namespace mozilla;
using namespace mozilla::gfx;

#ifdef MOZ_ENABLE_SKIA_PDF
using namespace mozilla::widget;
#endif

static const wchar_t kDriverName[] = L"WINSPOOL";

//----------------------------------------------------------------------------------
// The printer data is shared between the PrinterEnumerator and the
// nsDeviceContextSpecWin The PrinterEnumerator creates the printer info but the
// nsDeviceContextSpecWin cleans it up If it gets created (via the Page Setup
// Dialog) but the user never prints anything then it will never be delete, so
// this class takes care of that.
class GlobalPrinters {
 public:
  static GlobalPrinters* GetInstance() { return &mGlobalPrinters; }
  ~GlobalPrinters() { FreeGlobalPrinters(); }

  void FreeGlobalPrinters();

  bool PrintersAreAllocated() { return mPrinters != nullptr; }
  LPWSTR GetItemFromList(int32_t aInx) {
    return mPrinters ? mPrinters->ElementAt(aInx) : nullptr;
  }
  nsresult EnumeratePrinterList();
  void GetDefaultPrinterName(nsAString& aDefaultPrinterName);
  uint32_t GetNumPrinters() { return mPrinters ? mPrinters->Length() : 0; }

 protected:
  GlobalPrinters() {}
  nsresult EnumerateNativePrinters();
  void ReallocatePrinters();

  static GlobalPrinters mGlobalPrinters;
  static nsTArray<LPWSTR>* mPrinters;
};
//---------------
// static members
GlobalPrinters GlobalPrinters::mGlobalPrinters;
nsTArray<LPWSTR>* GlobalPrinters::mPrinters = nullptr;

struct AutoFreeGlobalPrinters {
  ~AutoFreeGlobalPrinters() {
    GlobalPrinters::GetInstance()->FreeGlobalPrinters();
  }
};

//----------------------------------------------------------------------------------
nsDeviceContextSpecWin::nsDeviceContextSpecWin()
    : mDevMode(nullptr)
#ifdef MOZ_ENABLE_SKIA_PDF
      ,
      mPrintViaSkPDF(false)
#endif
{
}

//----------------------------------------------------------------------------------

NS_IMPL_ISUPPORTS(nsDeviceContextSpecWin, nsIDeviceContextSpec)

nsDeviceContextSpecWin::~nsDeviceContextSpecWin() {
  SetDevMode(nullptr);

  nsCOMPtr<nsIPrintSettingsWin> psWin(do_QueryInterface(mPrintSettings));
  if (psWin) {
    psWin->SetDeviceName(EmptyString());
    psWin->SetDriverName(EmptyString());
    psWin->SetDevMode(nullptr);
  }

  // Free them, we won't need them for a while
  GlobalPrinters::GetInstance()->FreeGlobalPrinters();
}

//----------------------------------------------------------------------------------
NS_IMETHODIMP nsDeviceContextSpecWin::Init(nsIWidget* aWidget,
                                           nsIPrintSettings* aPrintSettings,
                                           bool aIsPrintPreview) {
  mPrintSettings = aPrintSettings;

  // Get the Printer Name to be used and output format.
  nsAutoString printerName;
  if (mPrintSettings) {
    mPrintSettings->GetOutputFormat(&mOutputFormat);
    mPrintSettings->GetPrinterName(printerName);
  }

  // If there is no name then use the default printer
  if (printerName.IsEmpty()) {
    GlobalPrinters::GetInstance()->GetDefaultPrinterName(printerName);
  }

  // Gather telemetry on the print target type.
  //
  // Unfortunately, if we're not using our own internal save-to-pdf codepaths,
  // there isn't a good way to determine whether a print is going to be to a
  // physical printer or to a file or some other non-physical output. We do our
  // best by checking for what seems to be the most common save-to-PDF virtual
  // printers.
  //
  // We use StringBeginsWith below, since printer names are often followed by a
  // version number or other product differentiating string.  (True for doPDF,
  // novaPDF, PDF-XChange and Soda PDF, for example.)
  if (mOutputFormat == nsIPrintSettings::kOutputFormatPDF) {
    Telemetry::ScalarAdd(Telemetry::ScalarID::PRINTING_TARGET_TYPE,
                         NS_LITERAL_STRING("pdf_file"), 1);
  } else if (StringBeginsWith(printerName,
                              NS_LITERAL_STRING("Microsoft Print to PDF")) ||
             StringBeginsWith(printerName, NS_LITERAL_STRING("Adobe PDF")) ||
             StringBeginsWith(printerName,
                              NS_LITERAL_STRING("Bullzip PDF Printer")) ||
             StringBeginsWith(printerName,
                              NS_LITERAL_STRING("CutePDF Writer")) ||
             StringBeginsWith(printerName, NS_LITERAL_STRING("doPDF")) ||
             StringBeginsWith(printerName,
                              NS_LITERAL_STRING("Foxit Reader PDF Printer")) ||
             StringBeginsWith(printerName,
                              NS_LITERAL_STRING("Nitro PDF Creator")) ||
             StringBeginsWith(printerName, NS_LITERAL_STRING("novaPDF")) ||
             StringBeginsWith(printerName, NS_LITERAL_STRING("PDF-XChange")) ||
             StringBeginsWith(printerName, NS_LITERAL_STRING("PDF24 PDF")) ||
             StringBeginsWith(printerName, NS_LITERAL_STRING("PDFCreator")) ||
             StringBeginsWith(printerName, NS_LITERAL_STRING("PrimoPDF")) ||
             StringBeginsWith(printerName, NS_LITERAL_STRING("Soda PDF")) ||
             StringBeginsWith(printerName,
                              NS_LITERAL_STRING("Solid PDF Creator")) ||
             StringBeginsWith(
                 printerName,
                 NS_LITERAL_STRING("Universal Document Converter"))) {
    Telemetry::ScalarAdd(Telemetry::ScalarID::PRINTING_TARGET_TYPE,
                         NS_LITERAL_STRING("pdf_file"), 1);
  } else if (printerName.EqualsLiteral("Microsoft XPS Document Writer")) {
    Telemetry::ScalarAdd(Telemetry::ScalarID::PRINTING_TARGET_TYPE,
                         NS_LITERAL_STRING("xps_file"), 1);
  } else {
    nsAString::const_iterator start, end;
    printerName.BeginReading(start);
    printerName.EndReading(end);
    if (CaseInsensitiveFindInReadable(NS_LITERAL_STRING("pdf"), start, end)) {
      Telemetry::ScalarAdd(Telemetry::ScalarID::PRINTING_TARGET_TYPE,
                           NS_LITERAL_STRING("pdf_unknown"), 1);
    } else {
      Telemetry::ScalarAdd(Telemetry::ScalarID::PRINTING_TARGET_TYPE,
                           NS_LITERAL_STRING("unknown"), 1);
    }
  }

  nsresult rv = NS_ERROR_GFX_PRINTER_NO_PRINTER_AVAILABLE;
  if (aPrintSettings) {
#ifdef MOZ_ENABLE_SKIA_PDF
    nsAutoString printViaPdf;
    Preferences::GetString("print.print_via_pdf_encoder", printViaPdf);
    if (printViaPdf.EqualsLiteral("skia-pdf")) {
      mPrintViaSkPDF = true;
    }
#endif

    // If we're in the child and printing via the parent or we're printing to
    // PDF we only need information from the print settings.
    if ((XRE_IsContentProcess() &&
         Preferences::GetBool("print.print_via_parent")) ||
        mOutputFormat == nsIPrintSettings::kOutputFormatPDF) {
      return NS_OK;
    }

    nsCOMPtr<nsIPrintSettingsWin> psWin(do_QueryInterface(aPrintSettings));
    if (psWin) {
      nsAutoString deviceName;
      nsAutoString driverName;
      psWin->GetDeviceName(deviceName);
      psWin->GetDriverName(driverName);

      LPDEVMODEW devMode;
      psWin->GetDevMode(&devMode);  // creates new memory (makes a copy)

      if (!deviceName.IsEmpty() && !driverName.IsEmpty() && devMode) {
        // Scaling is special, it is one of the few
        // devMode items that we control in layout
        if (devMode->dmFields & DM_SCALE) {
          double scale = double(devMode->dmScale) / 100.0f;
          if (scale != 1.0) {
            aPrintSettings->SetScaling(scale);
            devMode->dmScale = 100;
          }
        }

        SetDeviceName(deviceName);
        SetDriverName(driverName);
        SetDevMode(devMode);

        return NS_OK;
      } else {
        PR_PL(
            ("***** nsDeviceContextSpecWin::Init - "
             "deviceName/driverName/devMode was NULL!\n"));
        if (devMode) ::HeapFree(::GetProcessHeap(), 0, devMode);
      }
    }
  } else {
    PR_PL(("***** nsDeviceContextSpecWin::Init - aPrintSettingswas NULL!\n"));
  }

  if (printerName.IsEmpty()) {
    return rv;
  }

  return GetDataFromPrinter(printerName, mPrintSettings);
}

//----------------------------------------------------------

already_AddRefed<PrintTarget> nsDeviceContextSpecWin::MakePrintTarget() {
  NS_ASSERTION(mDevMode || mOutputFormat == nsIPrintSettings::kOutputFormatPDF,
               "DevMode can't be NULL here unless we're printing to PDF.");

#ifdef MOZ_ENABLE_SKIA_PDF
  if (mPrintViaSkPDF) {
    double width, height;
    mPrintSettings->GetEffectivePageSize(&width, &height);
    if (width <= 0 || height <= 0) {
      return nullptr;
    }

    // convert twips to points
    width /= TWIPS_PER_POINT_FLOAT;
    height /= TWIPS_PER_POINT_FLOAT;
    IntSize size = IntSize::Truncate(width, height);

    if (mOutputFormat == nsIPrintSettings::kOutputFormatPDF) {
      nsString filename;
      mPrintSettings->GetToFileName(filename);

      nsAutoCString printFile(NS_ConvertUTF16toUTF8(filename).get());
      auto skStream = MakeUnique<SkFILEWStream>(printFile.get());
      return PrintTargetSkPDF::CreateOrNull(std::move(skStream), size);
    }

    if (mDevMode) {
      NS_WARNING_ASSERTION(!mDriverName.IsEmpty(), "No driver!");
      HDC dc =
          ::CreateDCW(mDriverName.get(), mDeviceName.get(), nullptr, mDevMode);
      if (!dc) {
        gfxCriticalError(gfxCriticalError::DefaultOptions(false))
            << "Failed to create device context in GetSurfaceForPrinter";
        return nullptr;
      }
      return PrintTargetEMF::CreateOrNull(dc, size);
    }
  }
#endif

  if (mOutputFormat == nsIPrintSettings::kOutputFormatPDF) {
    nsString filename;
    mPrintSettings->GetToFileName(filename);

    double width, height;
    mPrintSettings->GetEffectivePageSize(&width, &height);
    if (width <= 0 || height <= 0) {
      return nullptr;
    }

    // convert twips to points
    width /= TWIPS_PER_POINT_FLOAT;
    height /= TWIPS_PER_POINT_FLOAT;

    nsCOMPtr<nsIFile> file = do_CreateInstance("@mozilla.org/file/local;1");
    nsresult rv = file->InitWithPath(filename);
    if (NS_FAILED(rv)) {
      return nullptr;
    }

    nsCOMPtr<nsIFileOutputStream> stream =
        do_CreateInstance("@mozilla.org/network/file-output-stream;1");
    rv = stream->Init(file, -1, -1, 0);
    if (NS_FAILED(rv)) {
      return nullptr;
    }

    return PrintTargetPDF::CreateOrNull(stream,
                                        IntSize::Truncate(width, height));
  }

  if (mDevMode) {
    NS_WARNING_ASSERTION(!mDriverName.IsEmpty(), "No driver!");
    HDC dc =
        ::CreateDCW(mDriverName.get(), mDeviceName.get(), nullptr, mDevMode);
    if (!dc) {
      gfxCriticalError(gfxCriticalError::DefaultOptions(false))
          << "Failed to create device context in GetSurfaceForPrinter";
      return nullptr;
    }

    // The PrintTargetWindows takes over ownership of this DC
    return PrintTargetWindows::CreateOrNull(dc);
  }

  return nullptr;
}

float nsDeviceContextSpecWin::GetDPI() {
  // To match the previous printing code we need to return 72 when printing to
  // PDF and 144 when printing to a Windows surface.
#ifdef MOZ_ENABLE_SKIA_PDF
  if (mPrintViaSkPDF) {
    return 72.0f;
  }
#endif
  return mOutputFormat == nsIPrintSettings::kOutputFormatPDF ? 72.0f : 144.0f;
}

float nsDeviceContextSpecWin::GetPrintingScale() {
  MOZ_ASSERT(mPrintSettings);
#ifdef MOZ_ENABLE_SKIA_PDF
  if (mPrintViaSkPDF) {
    return 1.0f;  // PDF is vector based, so we don't need a scale
  }
#endif
  // To match the previous printing code there is no scaling for PDF.
  if (mOutputFormat == nsIPrintSettings::kOutputFormatPDF) {
    return 1.0f;
  }

  // The print settings will have the resolution stored from the real device.
  int32_t resolution;
  mPrintSettings->GetResolution(&resolution);
  return float(resolution) / GetDPI();
}

gfxPoint nsDeviceContextSpecWin::GetPrintingTranslate() {
  // The underlying surface on windows is the size of the printable region. When
  // the region is smaller than the actual paper size the (0, 0) coordinate
  // refers top-left of that unwritable region. To instead have (0, 0) become
  // the top-left of the actual paper, translate it's coordinate system by the
  // unprintable region's width.
  double marginTop, marginLeft;
  mPrintSettings->GetUnwriteableMarginTop(&marginTop);
  mPrintSettings->GetUnwriteableMarginLeft(&marginLeft);
  int32_t resolution;
  mPrintSettings->GetResolution(&resolution);
  return gfxPoint(-marginLeft * resolution, -marginTop * resolution);
}

//----------------------------------------------------------------------------------
void nsDeviceContextSpecWin::SetDeviceName(const nsAString& aDeviceName) {
  mDeviceName = aDeviceName;
}

//----------------------------------------------------------------------------------
void nsDeviceContextSpecWin::SetDriverName(const nsAString& aDriverName) {
  mDriverName = aDriverName;
}

//----------------------------------------------------------------------------------
void nsDeviceContextSpecWin::SetDevMode(LPDEVMODEW aDevMode) {
  if (mDevMode) {
    ::HeapFree(::GetProcessHeap(), 0, mDevMode);
  }

  mDevMode = aDevMode;
}

//------------------------------------------------------------------
void nsDeviceContextSpecWin::GetDevMode(LPDEVMODEW& aDevMode) {
  aDevMode = mDevMode;
}

#define DISPLAY_LAST_ERROR

//----------------------------------------------------------------------------------
// Setup the object's data member with the selected printer's data
nsresult nsDeviceContextSpecWin::GetDataFromPrinter(const nsAString& aName,
                                                    nsIPrintSettings* aPS) {
  nsresult rv = NS_ERROR_FAILURE;

  if (!GlobalPrinters::GetInstance()->PrintersAreAllocated()) {
    rv = GlobalPrinters::GetInstance()->EnumeratePrinterList();
    if (NS_FAILED(rv)) {
      PR_PL(
          ("***** nsDeviceContextSpecWin::GetDataFromPrinter - Couldn't "
           "enumerate printers!\n"));
      DISPLAY_LAST_ERROR
    }
    NS_ENSURE_SUCCESS(rv, rv);
  }

  nsHPRINTER hPrinter = nullptr;
  const nsString& flat = PromiseFlatString(aName);
  wchar_t* name =
      (wchar_t*)flat.get();  // Windows APIs use non-const name argument

  BOOL status = ::OpenPrinterW(name, &hPrinter, nullptr);
  if (status) {
    nsAutoPrinter autoPrinter(hPrinter);

    LPDEVMODEW pDevMode;

    // Allocate a buffer of the correct size.
    LONG needed =
        ::DocumentPropertiesW(nullptr, hPrinter, name, nullptr, nullptr, 0);
    if (needed < 0) {
      PR_PL(
          ("**** nsDeviceContextSpecWin::GetDataFromPrinter - Couldn't get "
           "size of DEVMODE using DocumentPropertiesW(pDeviceName = \"%s\"). "
           "GetLastEror() = %08x\n",
           NS_ConvertUTF16toUTF8(aName).get(), GetLastError()));
      return NS_ERROR_FAILURE;
    }

    pDevMode =
        (LPDEVMODEW)::HeapAlloc(::GetProcessHeap(), HEAP_ZERO_MEMORY, needed);
    if (!pDevMode) return NS_ERROR_FAILURE;

    // Get the default DevMode for the printer and modify it for our needs.
    LONG ret = ::DocumentPropertiesW(nullptr, hPrinter, name, pDevMode, nullptr,
                                     DM_OUT_BUFFER);

    if (ret == IDOK && aPS) {
      nsCOMPtr<nsIPrintSettingsWin> psWin = do_QueryInterface(aPS);
      MOZ_ASSERT(psWin);
      psWin->CopyToNative(pDevMode);
      // Sets back the changes we made to the DevMode into the Printer Driver
      ret = ::DocumentPropertiesW(nullptr, hPrinter, name, pDevMode, pDevMode,
                                  DM_IN_BUFFER | DM_OUT_BUFFER);

      // We need to copy the final DEVMODE settings back to our print settings,
      // because they may have been set from invalid prefs.
      if (ret == IDOK) {
        // We need to get information from the device as well.
        nsAutoHDC printerDC(::CreateICW(kDriverName, name, nullptr, pDevMode));
        if (NS_WARN_IF(!printerDC)) {
          ::HeapFree(::GetProcessHeap(), 0, pDevMode);
          return NS_ERROR_FAILURE;
        }

        psWin->CopyFromNative(printerDC, pDevMode);
      }
    }

    if (ret != IDOK) {
      ::HeapFree(::GetProcessHeap(), 0, pDevMode);
      PR_PL(
          ("***** nsDeviceContextSpecWin::GetDataFromPrinter - "
           "DocumentProperties call failed code: %d/0x%x\n",
           ret, ret));
      DISPLAY_LAST_ERROR
      return NS_ERROR_FAILURE;
    }

    SetDevMode(
        pDevMode);  // cache the pointer and takes responsibility for the memory

    SetDeviceName(aName);

    SetDriverName(nsDependentString(kDriverName));

    rv = NS_OK;
  } else {
    rv = NS_ERROR_GFX_PRINTER_NAME_NOT_FOUND;
    PR_PL(
        ("***** nsDeviceContextSpecWin::GetDataFromPrinter - Couldn't open "
         "printer: [%s]\n",
         NS_ConvertUTF16toUTF8(aName).get()));
    DISPLAY_LAST_ERROR
  }
  return rv;
}

//***********************************************************
//  Printer Enumerator
//***********************************************************
nsPrinterEnumeratorWin::nsPrinterEnumeratorWin() {}

nsPrinterEnumeratorWin::~nsPrinterEnumeratorWin() {
  // Do not free printers here
  // GlobalPrinters::GetInstance()->FreeGlobalPrinters();
}

NS_IMPL_ISUPPORTS(nsPrinterEnumeratorWin, nsIPrinterEnumerator)

//----------------------------------------------------------------------------------
// Return the Default Printer name
NS_IMETHODIMP
nsPrinterEnumeratorWin::GetDefaultPrinterName(nsAString& aDefaultPrinterName) {
  GlobalPrinters::GetInstance()->GetDefaultPrinterName(aDefaultPrinterName);
  return NS_OK;
}

NS_IMETHODIMP
nsPrinterEnumeratorWin::InitPrintSettingsFromPrinter(
    const nsAString& aPrinterName, nsIPrintSettings* aPrintSettings) {
  NS_ENSURE_ARG_POINTER(aPrintSettings);

  if (aPrinterName.IsEmpty()) {
    return NS_OK;
  }

  // When printing to PDF on Windows there is no associated printer driver.
  int16_t outputFormat;
  aPrintSettings->GetOutputFormat(&outputFormat);
  if (outputFormat == nsIPrintSettings::kOutputFormatPDF) {
    return NS_OK;
  }

  RefPtr<nsDeviceContextSpecWin> devSpecWin = new nsDeviceContextSpecWin();
  if (!devSpecWin) return NS_ERROR_OUT_OF_MEMORY;

  if (NS_FAILED(GlobalPrinters::GetInstance()->EnumeratePrinterList())) {
    return NS_ERROR_FAILURE;
  }

  AutoFreeGlobalPrinters autoFreeGlobalPrinters;

  // If the settings have already been initialized from prefs then pass these to
  // GetDataFromPrinter, so that they are saved to the printer.
  bool initializedFromPrefs;
  nsresult rv =
      aPrintSettings->GetIsInitializedFromPrefs(&initializedFromPrefs);
  if (NS_WARN_IF(NS_FAILED(rv))) {
    return rv;
  }
  if (initializedFromPrefs) {
    // If we pass in print settings to GetDataFromPrinter it already copies
    // things back to the settings, so we can return here.
    return devSpecWin->GetDataFromPrinter(aPrinterName, aPrintSettings);
  }

  devSpecWin->GetDataFromPrinter(aPrinterName);

  LPDEVMODEW devmode;
  devSpecWin->GetDevMode(devmode);
  if (NS_WARN_IF(!devmode)) {
    return NS_ERROR_FAILURE;
  }

  aPrintSettings->SetPrinterName(aPrinterName);

  // We need to get information from the device as well.
  const nsString& flat = PromiseFlatString(aPrinterName);
  char16ptr_t printerName = flat.get();
  HDC dc = ::CreateICW(kDriverName, printerName, nullptr, devmode);
  if (NS_WARN_IF(!dc)) {
    return NS_ERROR_FAILURE;
  }

  nsCOMPtr<nsIPrintSettingsWin> psWin = do_QueryInterface(aPrintSettings);
  MOZ_ASSERT(psWin);
  psWin->CopyFromNative(dc, devmode);
  ::DeleteDC(dc);

  return NS_OK;
}

//----------------------------------------------------------------------------------
// Enumerate all the Printers from the global array and pass their
// names back (usually to script)
NS_IMETHODIMP
nsPrinterEnumeratorWin::GetPrinterNameList(
    nsIStringEnumerator** aPrinterNameList) {
  NS_ENSURE_ARG_POINTER(aPrinterNameList);
  *aPrinterNameList = nullptr;

  nsresult rv = GlobalPrinters::GetInstance()->EnumeratePrinterList();
  if (NS_FAILED(rv)) {
    PR_PL(
        ("***** nsDeviceContextSpecWin::GetPrinterNameList - Couldn't "
         "enumerate printers!\n"));
    return rv;
  }

  uint32_t numPrinters = GlobalPrinters::GetInstance()->GetNumPrinters();
  nsTArray<nsString>* printers = new nsTArray<nsString>(numPrinters);
  if (!printers) return NS_ERROR_OUT_OF_MEMORY;

  nsString* names = printers->AppendElements(numPrinters);
  for (uint32_t printerInx = 0; printerInx < numPrinters; ++printerInx) {
    LPWSTR name = GlobalPrinters::GetInstance()->GetItemFromList(printerInx);
    names[printerInx].Assign(name);
  }

  return NS_NewAdoptingStringEnumerator(aPrinterNameList, printers);
}

//----------------------------------------------------------------------------------
//-- Global Printers
//----------------------------------------------------------------------------------

//----------------------------------------------------------------------------------
// THe array hold the name and port for each printer
void GlobalPrinters::ReallocatePrinters() {
  if (PrintersAreAllocated()) {
    FreeGlobalPrinters();
  }
  mPrinters = new nsTArray<LPWSTR>();
  NS_ASSERTION(mPrinters, "Printers Array is NULL!");
}

//----------------------------------------------------------------------------------
void GlobalPrinters::FreeGlobalPrinters() {
  if (mPrinters != nullptr) {
    for (uint32_t i = 0; i < mPrinters->Length(); i++) {
      free(mPrinters->ElementAt(i));
    }
    delete mPrinters;
    mPrinters = nullptr;
  }
}

//----------------------------------------------------------------------------------
nsresult GlobalPrinters::EnumerateNativePrinters() {
  nsresult rv = NS_ERROR_GFX_PRINTER_NO_PRINTER_AVAILABLE;
  PR_PL(("-----------------------\n"));
  PR_PL(("EnumerateNativePrinters\n"));

  WCHAR szDefaultPrinterName[1024];
  DWORD status = GetProfileStringW(L"devices", 0, L",", szDefaultPrinterName,
                                   ArrayLength(szDefaultPrinterName));
  if (status > 0) {
    DWORD count = 0;
    LPWSTR sPtr = szDefaultPrinterName;
    LPWSTR ePtr = szDefaultPrinterName + status;
    LPWSTR prvPtr = sPtr;
    while (sPtr < ePtr) {
      if (*sPtr == 0) {
        LPWSTR name = wcsdup(prvPtr);
        mPrinters->AppendElement(name);
        PR_PL(("Printer Name:    %s\n", prvPtr));
        prvPtr = sPtr + 1;
        count++;
      }
      sPtr++;
    }
    rv = NS_OK;
  }
  PR_PL(("-----------------------\n"));
  return rv;
}

//------------------------------------------------------------------
// Uses the GetProfileString to get the default printer from the registry
void GlobalPrinters::GetDefaultPrinterName(nsAString& aDefaultPrinterName) {
  aDefaultPrinterName.Truncate();
  WCHAR szDefaultPrinterName[1024];
  DWORD status =
      GetProfileStringW(L"windows", L"device", 0, szDefaultPrinterName,
                        ArrayLength(szDefaultPrinterName));
  if (status > 0) {
    WCHAR comma = ',';
    LPWSTR sPtr = szDefaultPrinterName;
    while (*sPtr != comma && *sPtr != 0) sPtr++;
    if (*sPtr == comma) {
      *sPtr = 0;
    }
    aDefaultPrinterName = szDefaultPrinterName;
  } else {
    aDefaultPrinterName = EmptyString();
  }

  PR_PL(
      ("DEFAULT PRINTER [%s]\n", PromiseFlatString(aDefaultPrinterName).get()));
}

//----------------------------------------------------------------------------------
// This goes and gets the list of available printers and puts
// the default printer at the beginning of the list
nsresult GlobalPrinters::EnumeratePrinterList() {
  // reallocate and get a new list each time it is asked for
  // this deletes the list and re-allocates them
  ReallocatePrinters();

  // any of these could only fail with an OUT_MEMORY_ERROR
  // PRINTER_ENUM_LOCAL should get the network printers on Win95
  nsresult rv = EnumerateNativePrinters();
  if (NS_FAILED(rv)) return rv;

  // get the name of the default printer
  nsAutoString defPrinterName;
  GetDefaultPrinterName(defPrinterName);

  // put the default printer at the beginning of list
  if (!defPrinterName.IsEmpty()) {
    for (uint32_t i = 0; i < mPrinters->Length(); i++) {
      LPWSTR name = mPrinters->ElementAt(i);
      if (defPrinterName.Equals(name)) {
        if (i > 0) {
          LPWSTR ptr = mPrinters->ElementAt(0);
          mPrinters->ElementAt(0) = name;
          mPrinters->ElementAt(i) = ptr;
        }
        break;
      }
    }
  }

  // make sure we at least tried to get the printers
  if (!PrintersAreAllocated()) {
    PR_PL(
        ("***** nsDeviceContextSpecWin::EnumeratePrinterList - Printers aren`t "
         "allocated\n"));
    return NS_ERROR_FAILURE;
  }

  return NS_OK;
}
