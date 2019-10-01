async function check_webm(v, enabled) {
  function check(type, expected) {
    is(v.canPlayType(type), enabled ? expected : "", type + "='" + expected + "'");
  }

  // WebM types
  check("video/webm", "maybe");
  check("audio/webm", "maybe");

  var video = ['vp8', 'vp8.0', 'vp9', 'vp9.0'];
  var audio = ['vorbis', 'opus'];
  // Check for FxOS case.
  // Since we want to use OMX webm HW acceleration to speed up vp8 decoding,
  // we enabled it after Android version 16(JB) as MOZ_OMX_WEBM_DECODER
  // defined in moz.build. More information is on Bug 986381.
  // Currently OMX (KK included) webm decoders can only support vp8 and vorbis,
  // so only vp8 and vorbis will be tested when OMX webm decoder is enabled.
  if (navigator.userAgent.indexOf("Mobile") != -1 &&
      navigator.userAgent.indexOf("Android") == -1) {
    // See nsSystemInfo.cpp, the getProperty('version') and
    // getProperty('sdk_version') are different.
    var androidSDKVer = SpecialPowers.Cc['@mozilla.org/system-info;1']
                                     .getService(SpecialPowers.Ci.nsIPropertyBag2)
                                     .getProperty('sdk_version');
    info("android version:"+androidSDKVer);

    // Since from Android KK, vp9 sw decoder is supported.
    if (androidSDKVer > 18) {
      video = ['vp8', 'vp8.0', 'vp9', 'vp9.0'];
      audio = ['vorbis'];
    } else if (androidSDKVer > 15) {
      video = ['vp8', 'vp8.0'];
      audio = ['vorbis'];
    }

  }

  audio.forEach(function(acodec) {
    check("audio/webm; codecs=" + acodec, "probably");
    check("video/webm; codecs=" + acodec, "probably");
  });
  video.forEach(function(vcodec) {
    check("video/webm; codecs=" + vcodec, "probably");
    audio.forEach(function(acodec) {
        check("video/webm; codecs=\"" + vcodec + ", " + acodec + "\"", "probably");
        check("video/webm; codecs=\"" + acodec + ", " + vcodec + "\"", "probably");
    });
  });

  // Unsupported WebM codecs
  check("video/webm; codecs=xyz", "");
  check("video/webm; codecs=xyz,vorbis", "");
  check("video/webm; codecs=vorbis,xyz", "");

  function getPref(name) {
    var pref = false;
    try {
      pref = SpecialPowers.getBoolPref(name);
    } catch(ex) { }
    return pref;
  }

  function isWindows32() {
    return navigator.userAgent.includes("Windows") &&
           !navigator.userAgent.includes("Win64");
  }

  function isAndroid() {
    return navigator.userAgent.includes("Android");
  }

  const haveAv1 = getPref("media.av1.enabled");
  check("video/webm; codecs=\"av1\"", haveAv1 ? "probably" : "");

  await SpecialPowers.pushPrefEnv({"set": [["media.av1.enabled", true]]});
  // AV1 is disabled on Windows 32 bits (bug 1475564) and Android (bug 1368843)
  check("video/webm; codecs=\"av1\"", (isWindows32() || isAndroid()) ? "" : "probably");

  await SpecialPowers.pushPrefEnv({"set": [["media.av1.enabled", false]]});
  check("video/webm; codecs=\"av1\"", "");
}
