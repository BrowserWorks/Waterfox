# DMG Install Helper

When the user runs Firefox from inside the downloaded DMG we ask them if they want to install Firefox into /Applications. This is done because a new user sometimes doesn't know how to install an application on macOS, assuming it to be like Windows. The second reason is because Firefox data is tied to the executable's file system location, so confusion about why bookmarks, settings and tabs have disappeared or reset can occur. Data loss is also possible. For these reasons, running from a DMG (and any location other than /Applications) is strongly discouraged unless you know what you're doing.

When the user acknowledges that they do want Firefox installed into /Applications the app bundle is simply copied from the DMG into /Applications. If /Applications is not writable by the user, however, the DMG Install Helper comes into play.

The DMG Install Helper is a simple helper application that is run by launchd with elevated permissions, and all it does is copy the given app bundle into /Applications.

## Debugging

Debugging elevated launchd applications is tricky and a few things need to be set up first.

* You need an official Mozilla signing certificate for `org.mozilla.nightly` (see instructions on [firefox-source-docs](https://firefox-source-docs.mozilla.org/contributing/signing/configure_development_certificate.html))
* You need these two options in mozconfig
```
ac_add_options --enable-mac-elevated-updates-with-generic-certs
ac_add_options --enable-dmg-install-helper-debug
```
* You need to turn off `--enable-debug` in mozconfig (`--enable-debug` sets the bundleid to `org.mozilla.nightlydebug` and the certificate obtained in the first step is only for `org.mozilla.nightly`)
* No app called `Nightly.app` in `/Applications` (If `/Applications/Nightly.app` exists, Firefox will offer to launch it instead of installing over the top of it.)
* After building, you need to create a Firefox package, mount it, take `Nightly.app` out, sign the app bundle and then create a new DMG with the signed binary. You'll want to make a script to do this

```
#! /bin/bash

# package
./mach package

# remove previous attempts
umount /Volumes/Nightly
umount /Volumes/DMGInstallTest
rm -rf /tmp/Nightly.app
rm -f /tmp/tmp.dmg

# move the built Fx out of DMG, so it can be signed
hdiutil attach <path-to-firefox-dmg>
cp -R /Volumes/Nightly/Nightly.app /tmp/

umount /Volumes/Nightly

# sign the Fx app bundle
./mach macos-sign -a /tmp/Nightly.app -s <your-signing-certificate-id> -e production

# repack signed Fx bundle into a new DMG
hdiutil create -fs HFS+ -volname DMGInstallTest -srcfolder /tmp/Nightly.app /tmp/tmp.dmg

open /tmp/tmp.dmg
```

After that the DMG install path will be enabled at start up, and running from DMG will offer to install it.

To force the elevated DMG installer (so that you don't have to change the permissions on `/Applications`) you can set an environment variable before launching Firefox:

`launchctl setenv MOZ_DMG_INSTALL_HELPER_ALWAYS_ELEVATE 1`

You can turn this off again with

`launchctl unsetenv MOZ_DMG_INSTALL_HELPER_ALWAYS_ELEVATE`

## Uninstalling

The DMG Install Helper should clean up after itself, but if it doesn't you can run the following script. If you've been making changes to the DMG Install Helper and aren't seeing them executed, then it's possible that launchd is still using the older version because it didn't clean up correctly. This script will fix that.

```
#! /bin/sh

sudo launchctl unload /Library/LaunchDaemons/org.mozilla.dmgInstallHelper.plist
sudo rm /Library/LaunchDaemons/org.mozilla.dmgInstallHelper.plist
sudo rm /Library/PrivilegedHelperTools/org.mozilla.dmgInstallHelper
```
