Services.prefs.setBoolPref("browser.preferences.instantApply", true);

registerCleanupFunction(function() {
  Services.prefs.clearUserPref("browser.preferences.instantApply");
});

add_task(async function() {
  await openPreferencesViaOpenPreferencesAPI("paneContent", null, {leaveOpen: true});
  let doc = gBrowser.contentDocument;
  var langGroup = Services.prefs.getComplexValue("font.language.group", Ci.nsIPrefLocalizedString).data
  is(doc.getElementById("font.language.group").value, langGroup,
     "Language group should be set correctly.");

  let defaultFontType = Services.prefs.getCharPref("font.default." + langGroup);
  let fontFamily = Services.prefs.getCharPref("font.name." + defaultFontType + "." + langGroup);
  let fontFamilyField = doc.getElementById("defaultFont");
  is(fontFamilyField.value, fontFamily, "Font family should be set correctly.");

  let defaultFontSize = Services.prefs.getIntPref("font.size.variable." + langGroup);
  let fontSizeField = doc.getElementById("defaultFontSize");
  is(fontSizeField.value, defaultFontSize, "Font size should be set correctly.");

  let promiseSubDialogLoaded = promiseLoadSubDialog("chrome://browser/content/preferences/fonts.xul");
  doc.getElementById("advancedFonts").click();
  let win = await promiseSubDialogLoaded;
  doc = win.document;

  // Simulate a dumb font backend.
  win.FontBuilder._enumerator = {
    _list: ["MockedFont1", "MockedFont2", "MockedFont3"],
    _defaultFont: null,
    EnumerateFonts(lang, type, list) {
      return this._list;
    },
    EnumerateAllFonts() {
      return this._list;
    },
    getDefaultFont() { return this._defaultFont; },
    getStandardFamilyName(name) { return name; },
  };
  win.FontBuilder._allFonts = null;
  win.FontBuilder._langGroupSupported = false;

  let langGroupElement = doc.getElementById("font.language.group");
  let selectLangsField = doc.getElementById("selectLangs");
  let serifField = doc.getElementById("serif");
  let armenian = "x-armn";
  let western = "x-western";

  langGroupElement.value = armenian;
  selectLangsField.value = armenian;
  is(serifField.value, "", "Font family should not be set.");

  let armenianSerifElement = doc.getElementById("font.name.serif.x-armn");

  langGroupElement.value = western;
  selectLangsField.value = western;

  // Simulate a font backend supporting language-specific enumeration.
  // NB: FontBuilder has cached the return value from EnumerateAllFonts(),
  // so _allFonts will always have 3 elements regardless of subsequent
  // _list changes.
  win.FontBuilder._enumerator._list = ["MockedFont2"];

  langGroupElement.value = armenian;
  selectLangsField.value = armenian;
  is(serifField.value, "", "Font family should still be empty for indicating using 'default' font.");

  langGroupElement.value = western;
  selectLangsField.value = western;

  // Simulate a system that has no fonts for the specified language.
  win.FontBuilder._enumerator._list = [];

  langGroupElement.value = armenian;
  selectLangsField.value = armenian;
  is(serifField.value, "", "Font family should not be set.");

  // Setting default font to "MockedFont3".  Then, when serifField.value is
  // empty, it should indicate using "MockedFont3" but it shouldn't be saved
  // to "MockedFont3" in the pref.  It should be resolved at runtime.
  win.FontBuilder._enumerator._list = ["MockedFont1", "MockedFont2", "MockedFont3"];
  win.FontBuilder._enumerator._defaultFont = "MockedFont3";
  langGroupElement.value = armenian;
  selectLangsField.value = armenian;
  is(serifField.value, "", "Font family should be empty even if there is a default font.");

  armenianSerifElement.value = "MockedFont2";
  serifField.value = "MockedFont2";
  is(serifField.value, "MockedFont2", "Font family should be \"MockedFont2\" for now.");

  langGroupElement.value = western;
  selectLangsField.value = western;
  is(serifField.value, "", "Font family of other language should not be set.");

  langGroupElement.value = armenian;
  selectLangsField.value = armenian;
  is(serifField.value, "MockedFont2", "Font family should not be changed even after switching the language.");

  // If MochedFont2 is removed from the system, the value should be treated
  // as empty (i.e., 'default' font) after rebuilding the font list.
  win.FontBuilder._enumerator._list = ["MockedFont1", "MockedFont3"];
  win.FontBuilder._enumerator._allFonts = ["MockedFont1", "MockedFont3"];
  serifField.removeAllItems(); // This will cause rebuilding the font list from available fonts.
  langGroupElement.value = armenian;
  selectLangsField.value = armenian;
  is(serifField.value, "", "Font family should become empty due to the font uninstalled.");

  gBrowser.removeCurrentTab();
});
