var offlineByDefault = {
  defaultValue: false,
  prefBranch: SpecialPowers.Cc["@mozilla.org/preferences-service;1"].getService(SpecialPowers.Ci.nsIPrefBranch),
  set(allow) {
    this.defaultValue = this.prefBranch.getBoolPref("offline-apps.allow_by_default", false);
    this.prefBranch.setBoolPref("offline-apps.allow_by_default", allow);
  },
  reset() {
    this.prefBranch.setBoolPref("offline-apps.allow_by_default", this.defaultValue);
  }
}

offlineByDefault.set(false);
