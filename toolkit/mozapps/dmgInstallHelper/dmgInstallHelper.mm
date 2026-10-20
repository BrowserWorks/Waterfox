/* This Source Code Form is subject to the terms of the Mozilla Public
 * License, v. 2.0. If a copy of the MPL was not distributed with this
 * file, You can obtain one at http://mozilla.org/MPL/2.0/. */

#include <CoreFoundation/CFBase.h>
#include <CoreFoundation/CFDictionary.h>
#import <Foundation/Foundation.h>
#include <Security/SecCode.h>
#include <Security/SecBase.h>
#include <Security/SecStaticCode.h>
#include <MacTypes.h>
#include <sys/syslimits.h>
#include <Security/CSCommon.h>

#include <mach-o/getsect.h>
#include <mach-o/ldsyms.h>
#include <sys/stat.h>

#import <CoreServices/CoreServices.h>
#import <OSLog/OSLog.h>
#import <Security/Security.h>

#import "dmgInstallProtocol.h"

static bool PerformInstallationFromDMG(NSString* bundlePath,
                                       NSString* destPath);
static void LaunchTask(NSString* aPath, NSArray* aArguments);
static void RegisterAppWithLaunchServices(NSString* aBundlePath);
static void StripQuarantineBit(NSString* aBundlePath);
static void SetGroupOwnershipAndPermissions(NSString* appDir);
static NSString* requirementsStringFromEmbeddedPList();
static SecRequirementRef createRequirementFromString(
    NSString* requirementString);

// auditToken is private API but we can add it here so it can be called from
// objc.
@interface NSXPCConnection (PrivateAuditToken)
@property(nonatomic, readonly) audit_token_t auditToken;
@end

@interface DMGInstaller : NSObject <DMGInstallProtocol>
@end

@interface ListenerDelegate : NSObject <NSXPCListenerDelegate>
@end

#define MOZ_RUNINIT __attribute__((annotate("moz_global_var")))
MOZ_RUNINIT static os_log_t logger =
    os_log_create("org.mozilla.dmgInstallHelper", "main");

// This will work as a standalone app for testing purposes in a debug
// environment. pass the test app bundle as the only parameter.
int main(int argc, char* argv[]) {
  os_log_info(logger, "Started DMG Installer");

#ifdef MOZ_DEBUG
  if (argc != 2) {
    os_log_error(logger,
                 "Incorrect testing parameters: %{public}s <BUNDLE.APP>",
                 argv[0]);
    return 1;
  }

  if (!PerformInstallationFromDMG(
          [NSString stringWithCString:argv[1] encoding:NSUTF8StringEncoding],
          @"/tmp/")) {
    os_log_error(logger, "Error testing install");
    return 2;
  }
#endif

  ListenerDelegate* delegate = [[ListenerDelegate alloc] init];
  NSXPCListener* listener = [[NSXPCListener alloc]
      initWithMachServiceName:@"org.mozilla.dmgInstallHelper"];

  if (listener != nil) {
    os_log_info(logger, "Got listener");
  } else {
    os_log_error(logger, "No listener");
    return 1;
  }

  [listener setDelegate:delegate];

  [listener resume];

  [[NSRunLoop currentRunLoop] run];  // This will never return
}

@implementation ListenerDelegate

- (BOOL)shouldAcceptConnection:(NSXPCConnection*)connection {
  // auditToken is private API, and thus Apple is free to remove it at any time
  // without warning. This is unlikely because it is the only method to safely
  // verify the identity of incoming connections, and everyone uses (and Apple
  // tech support have hinted that it should be used). However, just to be on
  // the safe side, we check it hasn't been removed.
  if (![connection respondsToSelector:@selector(auditToken)]) {
    os_log_error(logger, "NSXPCConnection does not respond to auditToken. "
                         "Cannot verify connection. Aborting");
    return NO;
  }

  audit_token_t auditToken = connection.auditToken;
  NSData* tokenData = [NSData dataWithBytes:&auditToken
                                     length:sizeof(audit_token_t)];
  NSDictionary* attributes =
      @{(__bridge NSString*)kSecGuestAttributeAudit : tokenData};
  SecCodeRef code = NULL;

  if (SecCodeCopyGuestWithAttributes(NULL, (__bridge CFDictionaryRef)attributes,
                                     kSecCSDefaultFlags,
                                     &code) != errSecSuccess) {
    os_log_error(logger, "SecCodeCopyGuest failed");
    return NO;
  }

  // Check the client's code can't be tampered with while running
  CFDictionaryRef csInfo = NULL;
  if (SecCodeCopySigningInformation(code, kSecCSDynamicInformation, &csInfo) !=
      errSecSuccess) {
    os_log_error(logger, "SecCodeCopySigningInformation failed");
    CFRelease(code);
    return NO;
  } else {
    NSDictionary* infoDict = (__bridge NSDictionary*)csInfo;
    NSNumber* infoStatus = infoDict[(__bridge NSString*)kSecCodeInfoStatus];
    SecCodeStatus csFlags = [infoStatus unsignedIntValue];
    CFRelease(csInfo);

    if ((csFlags & (kSecCodeStatusHard | kSecCodeStatusKill)) !=
        (kSecCodeStatusHard | kSecCodeStatusKill)) {
      os_log_error(logger, "Code signing flags are incorrectly set");
      CFRelease(code);
      return NO;
    }
  }

  NSString* requirementString = requirementsStringFromEmbeddedPList();
  if (requirementString == nil) {
    os_log_error(logger, "Missing requirements string");
    CFRelease(code);
    return NO;
  }

  SecRequirementRef requirement =
      createRequirementFromString(requirementString);

  if (requirement == nullptr) {
    os_log_error(logger, "SecRequirementCreate failed");
    CFRelease(code);
    return NO;
  }

  // Check the client matches the requirements
  OSStatus status = SecCodeCheckValidity(code, kSecCSDefaultFlags, requirement);
  CFRelease(code);
  CFRelease(requirement);

  if (status != errSecSuccess) {
    os_log_error(logger, "Connection didn't meet requirements: %{public}@",
                 requirementString);
    return NO;
  }

  return YES;
}

- (BOOL)listener:(NSXPCListener*)listener
    shouldAcceptNewConnection:(NSXPCConnection*)newConnection {
  os_log_info(logger, "Got new connection");

  if (![self shouldAcceptConnection:newConnection]) {
    os_log_error(logger, "Invalid connection - rejecting");
    return NO;
  } else {
    os_log_info(logger, "Accepting connection");
  }

  DMGInstaller* dmgInstaller = [[DMGInstaller alloc] init];
  NSXPCInterface* dmgInterface =
      [NSXPCInterface interfaceWithProtocol:@protocol(DMGInstallProtocol)];
  newConnection.exportedInterface = dmgInterface;
  newConnection.exportedObject = dmgInstaller;

  newConnection.invalidationHandler = ^() {
    os_log_error(logger, "Connection invalidated");
  };

  newConnection.interruptionHandler = ^() {
    os_log_error(logger, "Connection interrupted");
  };

  [newConnection resume];

  return YES;
}

@end

@implementation DMGInstaller

static NSData* GetCdHashFromSecCode(SecStaticCodeRef code) {
  CFDictionaryRef csInfo = NULL;
  OSStatus status =
      SecCodeCopySigningInformation(code, kSecCSDefaultFlags, &csInfo);
  if (status != errSecSuccess) {
    os_log_error(logger, "SecCodeCopySigningInformation failed: %{public}d",
                 status);
    return nil;
  }

  NSDictionary* infoDict = (__bridge NSDictionary*)csInfo;
  NSData* cdHash = infoDict[(__bridge NSString*)kSecCodeInfoUnique];
  CFRelease(csInfo);

  return cdHash;
}

bool ValidateBundleAtPath(NSString* bundlePath) {
  // Get the current xpc connection to validate against
  NSXPCConnection* currentConnection = [NSXPCConnection currentConnection];

  OSStatus status;

  audit_token_t auditToken = currentConnection.auditToken;
  NSData* tokenData = [NSData dataWithBytes:&auditToken
                                     length:sizeof(audit_token_t)];
  NSDictionary* attributes =
      @{(__bridge NSString*)kSecGuestAttributeAudit : tokenData};
  SecCodeRef code = NULL;

  status = SecCodeCopyGuestWithAttributes(
      NULL, (__bridge CFDictionaryRef)attributes, kSecCSDefaultFlags, &code);
  if (status != errSecSuccess) {
    os_log_error(logger, "SecCodeCopyGuest failed: %{public}d", status);
    return false;
  }

  // Get the cdhash for Firefox
  NSData* fxCdHash = GetCdHashFromSecCode(code);
  CFRelease(code);

  if (fxCdHash == nil) {
    os_log_error(logger, "Failed to get Firefox CdHash");
    return false;
  }

  // Get the cdhash from the bundle
  NSURL* bundleUrl = [NSURL fileURLWithPath:bundlePath];
  SecStaticCodeRef bundleCode;
  status = SecStaticCodeCreateWithPath((__bridge CFURLRef)bundleUrl,
                                       kSecCSDefaultFlags, &bundleCode);
  if (status != errSecSuccess) {
    os_log_error(logger, "SecStaticCodeCreateWithPath failed: %{public}d",
                 status);
    return false;
  }

  // Validate the bundle on disk
  NSString* requirementString = requirementsStringFromEmbeddedPList();
  if (requirementString == nil) {
    os_log_error(logger, "Missing requirements string");
    CFRelease(bundleCode);
    return false;
  }

  SecRequirementRef requirement =
      createRequirementFromString(requirementString);

  if (requirement == nullptr) {
    os_log_error(logger, "SecRequirementCreate failed");
    CFRelease(bundleCode);
    return false;
  }

  status = SecStaticCodeCheckValidity(
      bundleCode,
      kSecCSConsiderExpiration | kSecCSCheckAllArchitectures |
          kSecCSCheckNestedCode | kSecCSStrictValidate | kSecCSRestrictSymlinks,
      requirement);

  CFRelease(requirement);
  if (status != errSecSuccess) {
    os_log_error(logger, "Failed bundle validity check: %{public}d", status);
    CFRelease(bundleCode);
    return false;
  }

  NSData* bundleCdHash = GetCdHashFromSecCode(bundleCode);
  CFRelease(bundleCode);

  if (bundleCdHash == nil) {
    os_log_error(logger, "Failed to get bundle CdHash");
    return false;
  }

  BOOL result = [fxCdHash isEqualToData:bundleCdHash];

  if (result) {
    os_log_info(logger, "Passed code signature verification");
  }

  return result;
}

static void RemoveStagingDir(NSString* stagingPath) {
  NSError* error = nil;
  if (![[NSFileManager defaultManager] removeItemAtPath:stagingPath
                                                  error:&error]) {
    os_log_error(logger, "Error cleaning up staging dir %{public}@", error);
  }
}

static bool PerformInstallationFromDMG(NSString* bundlePath,
                                       NSString* destinationDir) {
  if (![bundlePath isAbsolutePath]) {
    os_log_info(logger, "Bundle path is relative: %{public}@", bundlePath);
    return false;
  }

  if (![bundlePath hasSuffix:@".app"]) {
    os_log_info(logger, "Bundle path is not an app bundle");
    return false;
  }

  // Standardize path to remove ~ and ..
  const char* bundlePathCStr = [[bundlePath stringByStandardizingPath]
      cStringUsingEncoding:NSUTF8StringEncoding];
  struct stat buf;

  if (lstat(bundlePathCStr, &buf) == -1) {
    os_log_error(logger, "Bundle path stat failed: %{public}d", errno);
    return false;
  }

  if (S_ISLNK(buf.st_mode) || !S_ISDIR(buf.st_mode)) {
    os_log_error(logger, "Bundle path is %{public}s: %{public}@",
                 S_ISLNK(buf.st_mode) ? "link" : "file", bundlePath);
    return false;
  }

  NSString* bundleName = [bundlePath lastPathComponent];
  NSString* destinationPath =
      [NSString pathWithComponents:@[ destinationDir, bundleName ]];

  os_log_info(logger, "Install requested %{public}@ -> %{public}@", bundlePath,
              destinationPath);

  NSString* stagingFolderTemplate = [NSString pathWithComponents:@[
    destinationDir, @".FirefoxDMGInstall.stage.XXXXXX"
  ]];
  char stagingPathCStr[PATH_MAX];
  if (![stagingFolderTemplate getCString:stagingPathCStr
                               maxLength:PATH_MAX
                                encoding:NSUTF8StringEncoding]) {
    os_log_error(logger, "Can't get cstring from staging");
    return false;
  }

  os_log_info(logger, "Staging path: %{public}s", stagingPathCStr);
  if (mkdtemp(stagingPathCStr) == NULL) {
    os_log_error(logger, "mkdtemp failed: %{public}d", errno);
    return false;
  }

  NSError* error = nil;

  // NSFileManager won't copy bundlePath to the staging folder, because mkdtemp
  // already created it, so we need to copy the contents of bundlePath into
  // the temporary folder. Luckily the contents of a macOS app bundle is just
  // a single folder called Contents, so it's not much extra work.
  NSString* stagingPath = [NSString stringWithCString:stagingPathCStr
                                             encoding:NSASCIIStringEncoding];

  NSString* stagingContentsPath =
      [stagingPath stringByAppendingPathComponent:@"Contents"];

  NSFileManager* fm = [NSFileManager defaultManager];
  NSString* contentsPath =
      [bundlePath stringByAppendingPathComponent:@"Contents"];
  [fm copyItemAtPath:contentsPath toPath:stagingContentsPath error:&error];
  if (error != nil) {
    os_log_error(logger, "File manager staging copy: %{public}@", error);
    RemoveStagingDir(stagingPath);
    return false;
  }

  if (!ValidateBundleAtPath(stagingPath)) {
    os_log_error(logger, "Staged bundle failed signature verification");
    RemoveStagingDir(stagingPath);
    return false;
  }

  if (rename([stagingPath cStringUsingEncoding:NSASCIIStringEncoding],
             [destinationPath cStringUsingEncoding:NSASCIIStringEncoding]) ==
      -1) {
    os_log_error(logger, "Rename failed: %{public}d", errno);
    RemoveStagingDir(stagingPath);
    return false;
  }

  StripQuarantineBit(destinationPath);
  SetGroupOwnershipAndPermissions(destinationPath);
  RegisterAppWithLaunchServices(destinationPath);

  return true;
}

- (void)installDMGFromPath:(NSString*)bundlePath
                 withReply:(void (^)(BOOL))reply {
  // Hardcode /Applications when installing through XPC
  reply(PerformInstallationFromDMG(bundlePath, @"/Applications"));
}

// Terminate and clean up after ourselves by removing the various launchd
// artifacts while we still have elevated permissions
- (void)terminateDMGInstallHelper {
  os_log_info(logger, "Terminated!");

  NSFileManager* manager = [NSFileManager defaultManager];
  [manager removeItemAtPath:
               @"/Library/PrivilegedHelperTools/org.mozilla.dmgInstallHelper"
                      error:nil];
  [manager removeItemAtPath:
               @"/Library/LaunchDaemons/org.mozilla.dmgInstallHelper.plist"
                      error:nil];

  // The following call will terminate the current process due to the "remove"
  // argument.
  LaunchTask(@"/bin/launchctl",
             @[ @"remove", @"org.mozilla.dmgInstallHelper" ]);

  exit(0);
}

@end

// Read the requirements from the Info.plist that is compiled into the final
// binary
static NSString* requirementsStringFromEmbeddedPList() {
  unsigned long size = 0;
  uint8_t* data =
      getsectiondata(&_mh_execute_header, "__TEXT", "__info_plist", &size);
  if (data == nullptr) {
    os_log_error(logger, "No embedded plist data");
    return nil;
  }

  NSData* plistData = [NSData dataWithBytes:data length:size];
  NSError* error = nil;

  id plist =
      [NSPropertyListSerialization propertyListWithData:plistData
                                                options:NSPropertyListImmutable
                                                 format:nil
                                                  error:&error];

  if (error != nil) {
    os_log_error(logger, "Error parsing plist: %{public}@", error);
    return nil;
  }

  id clients = [plist objectForKey:@"SMAuthorizedClients"];
  if ([clients count] != 1) {
    os_log_error(logger, "Number of requirements != 1");
    return nil;
  }

  id requirements = clients[0];
  if (![requirements isKindOfClass:[NSString class]]) {
    os_log_error(logger, "Requirements is not a string");
    return nil;
  }

  return (NSString*)requirements;
}

static SecRequirementRef createRequirementFromString(
    NSString* requirementString) {
  SecRequirementRef requirement;
  if (SecRequirementCreateWithString((__bridge CFStringRef)requirementString,
                                     kSecCSDefaultFlags,
                                     &requirement) != errSecSuccess) {
    return nullptr;
  }

  return requirement;
}

/**
 * Helper to launch macOS tasks via NSTask and wait for the launched task to
 * terminate.
 */
static void LaunchTask(NSString* aPath, NSArray* aArguments) {
  NSTask* task = [[NSTask alloc] init];
  [task setExecutableURL:[NSURL fileURLWithPath:aPath]];
  if (aArguments) {
    [task setArguments:aArguments];
  }

  NSError* error = nil;
  if (![task launchAndReturnError:&error]) {
    os_log_error(logger, "Error launching %{public}@ - %{public}@", aPath,
                 error);
  }
  [task waitUntilExit];
}

static void RegisterAppWithLaunchServices(NSString* aBundlePath) {
  @try {
    OSStatus status = LSRegisterURL(
        (__bridge CFURLRef)[NSURL fileURLWithPath:aBundlePath], YES);
    if (status != noErr) {
      os_log_error(
          logger,
          "We failed to register the app in the Launch Services database, "
          "which may lead to a failure to launch the app. Launch path: "
          "%{public}@",
          aBundlePath);
    }
  } @catch (NSException* e) {
    os_log_error(logger, "%{public}@: %{public}@", e.name, e.reason);
  }
}

static void StripQuarantineBit(NSString* aBundlePath) {
  NSArray* arguments = @[ @"-dr", @"com.apple.quarantine", aBundlePath ];
  LaunchTask(@"/usr/bin/xattr", arguments);
}

static void SetGroupOwnershipAndPermissions(NSString* appDir) {
  NSFileManager* fileManager = [NSFileManager defaultManager];
  NSError* error = nil;
  NSArray* paths = [fileManager subpathsOfDirectoryAtPath:appDir error:&error];
  if (error) {
    return;
  }

  // Set group ownership of Firefox.app to 80 ("admin") and permissions to
  // 0775.
  if (![fileManager setAttributes:@{
        NSFileGroupOwnerAccountID : @(80),
        NSFilePosixPermissions : @(0775)
      }
                     ofItemAtPath:appDir
                            error:&error] ||
      error) {
    return;
  }

  NSArray* permKeys = [NSArray
      arrayWithObjects:NSFileGroupOwnerAccountID, NSFilePosixPermissions, nil];
  // For all descendants of Firefox.app, set group ownership to 80 ("admin") and
  // ensure write permission for the group.
  for (NSString* currPath in paths) {
    NSString* child = [appDir stringByAppendingPathComponent:currPath];
    NSDictionary* oldAttributes = [fileManager attributesOfItemAtPath:child
                                                                error:&error];
    if (error) {
      return;
    }
    // Skip symlinks, since they could be pointing to files outside of the .app
    // bundle.
    if ([oldAttributes fileType] == NSFileTypeSymbolicLink) {
      continue;
    }
    NSNumber* oldPerms =
        (NSNumber*)[oldAttributes valueForKey:NSFilePosixPermissions];
    NSArray* permObjects = [NSArray
        arrayWithObjects:[NSNumber numberWithUnsignedLong:80],
                         [NSNumber
                             numberWithUnsignedLong:[oldPerms shortValue] |
                                                    020],
                         nil];
    NSDictionary* attributes = [NSDictionary dictionaryWithObjects:permObjects
                                                           forKeys:permKeys];
    if (![fileManager setAttributes:attributes
                       ofItemAtPath:child
                              error:&error] ||
        error) {
      return;
    }
  }
}
