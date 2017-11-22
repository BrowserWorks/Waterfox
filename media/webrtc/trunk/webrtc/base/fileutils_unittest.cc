/*
 *  Copyright 2004 The WebRTC Project Authors. All rights reserved.
 *
 *  Use of this source code is governed by a BSD-style license
 *  that can be found in the LICENSE file in the root of the source
 *  tree. An additional intellectual property rights grant can be found
 *  in the file PATENTS.  All contributing project authors may
 *  be found in the AUTHORS file in the root of the source tree.
 */

#include <memory>

#include "webrtc/base/fileutils.h"
#include "webrtc/base/gunit.h"
#include "webrtc/base/pathutils.h"
#include "webrtc/base/stream.h"

namespace rtc {

#if defined (WEBRTC_ANDROID)
// Fails on Android: https://bugs.chromium.org/p/webrtc/issues/detail?id=4364.
#define MAYBE_FilesystemTest DISABLED_FilesystemTest
#else
#define MAYBE_FilesystemTest FilesystemTest
#endif

// Make sure we can get a temp folder for the later tests.
TEST(MAYBE_FilesystemTest, GetTemporaryFolder) {
  Pathname path;
  EXPECT_TRUE(Filesystem::GetTemporaryFolder(path, true, NULL));
}

// Test creating a temp file, reading it back in, and deleting it.
TEST(MAYBE_FilesystemTest, TestOpenFile) {
  Pathname path;
  EXPECT_TRUE(Filesystem::GetTemporaryFolder(path, true, NULL));
  path.SetPathname(Filesystem::TempFilename(path, "ut"));

  FileStream* fs;
  char buf[256];
  size_t bytes;

  fs = Filesystem::OpenFile(path, "wb");
  ASSERT_TRUE(fs != NULL);
  EXPECT_EQ(SR_SUCCESS, fs->Write("test", 4, &bytes, NULL));
  EXPECT_EQ(4U, bytes);
  delete fs;

  EXPECT_TRUE(Filesystem::IsFile(path));

  fs = Filesystem::OpenFile(path, "rb");
  ASSERT_TRUE(fs != NULL);
  EXPECT_EQ(SR_SUCCESS, fs->Read(buf, sizeof(buf), &bytes, NULL));
  EXPECT_EQ(4U, bytes);
  delete fs;

  EXPECT_TRUE(Filesystem::DeleteFile(path));
  EXPECT_FALSE(Filesystem::IsFile(path));
}

// Test opening a non-existent file.
TEST(MAYBE_FilesystemTest, TestOpenBadFile) {
  Pathname path;
  EXPECT_TRUE(Filesystem::GetTemporaryFolder(path, true, NULL));
  path.SetFilename("not an actual file");

  EXPECT_FALSE(Filesystem::IsFile(path));

  FileStream* fs = Filesystem::OpenFile(path, "rb");
  EXPECT_FALSE(fs != NULL);
}

// Test checking for free disk space.
TEST(MAYBE_FilesystemTest, TestGetDiskFreeSpace) {
  // Note that we should avoid picking any file/folder which could be located
  // at the remotely mounted drive/device.
  Pathname path;
  ASSERT_TRUE(Filesystem::GetAppDataFolder(&path, true));

  int64_t free1 = 0;
  EXPECT_TRUE(Filesystem::IsFolder(path));
  EXPECT_FALSE(Filesystem::IsFile(path));
  EXPECT_TRUE(Filesystem::GetDiskFreeSpace(path, &free1));
  EXPECT_GT(free1, 0);

  int64_t free2 = 0;
  path.AppendFolder("this_folder_doesnt_exist");
  EXPECT_FALSE(Filesystem::IsFolder(path));
  EXPECT_TRUE(Filesystem::IsAbsent(path));
  EXPECT_TRUE(Filesystem::GetDiskFreeSpace(path, &free2));
  // These should be the same disk, and disk free space should not have changed
  // by more than 1% between the two calls.
  EXPECT_LT(static_cast<int64_t>(free1 * .9), free2);
  EXPECT_LT(free2, static_cast<int64_t>(free1 * 1.1));

  int64_t free3 = 0;
  path.clear();
  EXPECT_TRUE(path.empty());
  EXPECT_TRUE(Filesystem::GetDiskFreeSpace(path, &free3));
  // Current working directory may not be where exe is.
  // EXPECT_LT(static_cast<int64_t>(free1 * .9), free3);
  // EXPECT_LT(free3, static_cast<int64_t>(free1 * 1.1));
  EXPECT_GT(free3, 0);
}

}  // namespace rtc
