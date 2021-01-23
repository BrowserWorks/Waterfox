/* -*- Mode: C++; tab-width: 2; indent-tabs-mode: nil; c-basic-offset: 2 -*- */
/* This Source Code Form is subject to the terms of the Mozilla Public
 * License, v. 2.0. If a copy of the MPL was not distributed with this
 * file, You can obtain one at http://mozilla.org/MPL/2.0/. */

#ifndef nsPrintSettingsServiceX_h
#define nsPrintSettingsServiceX_h

#include "nsPrintSettingsService.h"

namespace mozilla {
namespace embedding {
class PrintData;
}  // namespace embedding
}  // namespace mozilla

class nsPrintSettingsServiceX final : public nsPrintSettingsService {
 public:
  nsPrintSettingsServiceX() {}

  /**
   * These serialize and deserialize methods are not symmetrical in that
   * printSettingsX != deserialize(serialize(printSettingsX)). This is because
   * the native print settings stored in the nsPrintSettingsX's NSPrintInfo
   * object are not fully serialized. Only the values needed for successful
   * printing are.
   */
  NS_IMETHODIMP SerializeToPrintData(
      nsIPrintSettings* aSettings,
      mozilla::embedding::PrintData* data) override;

  NS_IMETHODIMP DeserializeToPrintSettings(
      const mozilla::embedding::PrintData& data,
      nsIPrintSettings* settings) override;

 protected:
  nsresult ReadPrefs(nsIPrintSettings* aPS, const nsAString& aPrinterName,
                     uint32_t aFlags) override;

  nsresult WritePrefs(nsIPrintSettings* aPS, const nsAString& aPrinterName,
                      uint32_t aFlags) override;

  nsresult _CreatePrintSettings(nsIPrintSettings** _retval) override;

 private:
  /* Serialization done in parent to be deserialized in the child */
  nsresult SerializeToPrintDataParent(nsIPrintSettings* aSettings,
                                      mozilla::embedding::PrintData* data);
};

#endif  // nsPrintSettingsServiceX_h
