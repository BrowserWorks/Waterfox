/* -*- Mode: C++; tab-width: 2; indent-tabs-mode: nil; c-basic-offset: 2 -*- */
/* vim:set ts=2 sw=2 sts=2 et cindent: */
/* This Source Code Form is subject to the terms of the Mozilla Public
 * License, v. 2.0. If a copy of the MPL was not distributed with this
 * file, You can obtain one at http://mozilla.org/MPL/2.0/. */

#include "nsXREDirProvider.h"
#include "gtest/gtest.h"

#if defined(MOZ_WIDGET_GTK)

#  include <stdlib.h>
#  include <unistd.h>
#  include <sys/stat.h>

// Remove @path and all its subdirs.
static void cleanup(const std::string& path) {
  nsresult rv;
  nsCOMPtr<nsIFile> localDir;
  rv = NS_NewNativeLocalFile(nsDependentCString((char*)path.c_str()), true,
                             getter_AddRefs(localDir));
  EXPECT_EQ(NS_OK, rv);
  rv = localDir->Remove(true);
  EXPECT_EQ(NS_OK, rv);
}

// Create a temp dir and set HOME to it.
// Upon successful completion, return the string with the path of the homedir.
static std::string getNewHome() {
  char tmpHomedir[] = "/tmp/mozilla-tmp.XXXXXX";
  std::string homedir = mkdtemp(tmpHomedir);
  // Bypass the value of `gDataDirProfileLocal` and `gDataDirProfile`.
  nsXREDirProvider tempProvider;
  tempProvider.DoShutdown();
  EXPECT_EQ(0, setenv("HOME", (char*)homedir.c_str(), 1));
  return homedir;
}

// Check if '$HOME/.mozilla' is used when it exists.
TEST(toolkit_xre, LegacyAppUserDir)
{
  nsCOMPtr<nsIFile> localDir;
  nsresult rv;
  nsAutoCString cwd;
  std::string homedir = getNewHome();
  ASSERT_EQ(0, mkdir((char*)(homedir + "/.mozilla").c_str(), S_IRWXU));
  rv = nsXREDirProvider::GetUserAppDataDirectory(getter_AddRefs(localDir));
  ASSERT_EQ(NS_OK, rv);
  localDir->GetNativePath(cwd);
  std::string expectedAppDir = homedir + "/.mozilla/firefox";
  std::string appDir = cwd.get();
  ASSERT_EQ(expectedAppDir, appDir);
  cleanup(homedir);
}

// Check if '$HOME/.mozilla' is used when the env
// variable MOZ_LEGACY_HOME is set.
TEST(toolkit_xre, ForceLegacyAppUserDir)
{
  nsCOMPtr<nsIFile> localDir;
  nsresult rv;
  nsAutoCString cwd;
  std::string homedir = getNewHome();
  ASSERT_EQ(0, setenv("MOZ_LEGACY_HOME", "is set", 1));
  rv = nsXREDirProvider::GetUserAppDataDirectory(getter_AddRefs(localDir));
  ASSERT_EQ(NS_OK, rv);
  localDir->GetNativePath(cwd);
  std::string expectedAppDir = homedir + "/.mozilla/firefox";
  std::string appDir = cwd.get();
  ASSERT_EQ(expectedAppDir, appDir);
  ASSERT_EQ(0, unsetenv("MOZ_LEGACY_HOME"));
  cleanup(homedir);
}

// Check if '$HOME/.config/mozilla' is used
// if $HOME/.mozilla does not exist and the env
// variable XDG_CONFIG_HOME is not set.
TEST(toolkit_xre, XDGDefaultAppUserDir)
{
  nsCOMPtr<nsIFile> localDir;
  nsresult rv;
  nsAutoCString cwd;
  std::string homedir = getNewHome();
  ASSERT_EQ(0, unsetenv("XDG_CONFIG_HOME"));
  rv = nsXREDirProvider::GetUserAppDataDirectory(getter_AddRefs(localDir));
  ASSERT_EQ(NS_OK, rv);
  localDir->GetNativePath(cwd);
  std::string expectedAppDir = homedir + "/.config/mozilla/firefox";
  std::string appDir = cwd.get();
  ASSERT_EQ(expectedAppDir, appDir);
  cleanup(homedir);
}

// Check if '$XDG_CONFIG_HOME/mozilla' is
// used if '$HOME/.mozilla' does not exist
// and the env variable XDG_CONFIG_HOME is set.
TEST(toolkit_xre, XDGAppUserDir)
{
  nsCOMPtr<nsIFile> localDir;
  nsresult rv;
  nsAutoCString cwd;
  std::string homedir = getNewHome();
  ASSERT_EQ(0, setenv("XDG_CONFIG_HOME", (char*)homedir.c_str(), 1));
  rv = nsXREDirProvider::GetUserAppDataDirectory(getter_AddRefs(localDir));
  ASSERT_EQ(NS_OK, rv);
  localDir->GetNativePath(cwd);
  std::string expectedAppDir = homedir + "/mozilla/firefox";
  std::string appDir = cwd.get();
  ASSERT_EQ(expectedAppDir, appDir);
  cleanup(homedir);
}

// Check if '$HOME/.cache/mozilla' is
// used when '$XDG_CACHE_HOME' is not set.
TEST(toolkit_xre, DefaultLocalDataDir)
{
  nsCOMPtr<nsIFile> localDir;
  nsresult rv;
  nsAutoCString cwd;
  std::string homedir = getNewHome();
  ASSERT_EQ(0, unsetenv("XDG_CACHE_HOME"));
  rv = nsXREDirProvider::GetUserLocalDataDirectory(getter_AddRefs(localDir));
  ASSERT_EQ(NS_OK, rv);
  localDir->GetNativePath(cwd);
  std::string expectedAppDir = homedir + "/.cache/mozilla/firefox";
  std::string appDir = cwd.get();
  ASSERT_EQ(expectedAppDir, appDir);
  cleanup(homedir);
}

// Check if '$XDG_CACHE_HOME/mozilla' is
// used when '$XDG_CACHE_HOME' is set.
TEST(toolkit_xre, XDGLocalDataDir)
{
  nsCOMPtr<nsIFile> localDir;
  nsresult rv;
  nsAutoCString cwd;
  std::string homedir = getNewHome();
  ASSERT_EQ(0, setenv("XDG_CACHE_HOME", (char*)homedir.c_str(), 1));
  rv = nsXREDirProvider::GetUserLocalDataDirectory(getter_AddRefs(localDir));
  ASSERT_EQ(NS_OK, rv);
  localDir->GetNativePath(cwd);
  std::string expectedAppDir = homedir + "/mozilla/firefox";
  std::string appDir = cwd.get();
  ASSERT_EQ(expectedAppDir, appDir);
  cleanup(homedir);
}
#endif
