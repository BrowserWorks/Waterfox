#! /bin/sh
# A script for uninstalling dmgInstallHelper during development
sudo launchctl unload /Library/LaunchDaemons/org.mozilla.dmgInstallHelper.plist
sudo rm /Library/LaunchDaemons/org.mozilla.dmgInstallHelper.plist
sudo rm /Library/PrivilegedHelperTools/org.mozilla.dmgInstallHelper