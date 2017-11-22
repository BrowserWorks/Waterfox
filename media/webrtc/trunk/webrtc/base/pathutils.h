/*
 *  Copyright 2004 The WebRTC Project Authors. All rights reserved.
 *
 *  Use of this source code is governed by a BSD-style license
 *  that can be found in the LICENSE file in the root of the source
 *  tree. An additional intellectual property rights grant can be found
 *  in the file PATENTS.  All contributing project authors may
 *  be found in the AUTHORS file in the root of the source tree.
 */

#ifndef WEBRTC_BASE_PATHUTILS_H__
#define WEBRTC_BASE_PATHUTILS_H__

#include <string>

#include "webrtc/base/checks.h"

namespace rtc {

///////////////////////////////////////////////////////////////////////////////
// Pathname - parsing of pathnames into components, and vice versa.
//
// To establish consistent terminology, a filename never contains a folder
// component.  A folder never contains a filename.  A pathname may include
// a folder and/or filename component.  Here are some examples:
//
//   pathname()      /home/john/example.txt
//   folder()        /home/john/
//   filename()                 example.txt
//   parent_folder() /home/
//   folder_name()         john/
//   basename()                 example
//   extension()                       .txt
//
// Basename may begin, end, and/or include periods, but no folder delimiters.
// If extension exists, it consists of a period followed by zero or more
// non-period/non-delimiter characters, and basename is non-empty.
///////////////////////////////////////////////////////////////////////////////

class Pathname {
public:
  // Folder delimiters are slash and backslash
  static bool IsFolderDelimiter(char ch);
  static char DefaultFolderDelimiter();

  Pathname();
  Pathname(const Pathname&);
  Pathname(Pathname&&);
  Pathname(const std::string& pathname);
  Pathname(const std::string& folder, const std::string& filename);

  Pathname& operator=(const Pathname&);
  Pathname& operator=(Pathname&&);

  // Set's the default folder delimiter for this Pathname
  char folder_delimiter() const { return folder_delimiter_; }
  void SetFolderDelimiter(char delimiter);

  // Normalize changes all folder delimiters to folder_delimiter()
  void Normalize();

  // Reset to the empty pathname
  void clear();

  // Returns true if the pathname is empty.  Note: this->pathname().empty()
  // is always false.
  bool empty() const;

  // Returns the folder and filename components.  If the pathname is empty,
  // returns a string representing the current directory (as a relative path,
  // i.e., ".").
  std::string pathname() const;
  void SetPathname(const std::string& pathname);
  void SetPathname(const std::string& folder, const std::string& filename);

  // Append pathname to the current folder (if any).  Any existing filename
  // will be discarded.
  void AppendPathname(const std::string& pathname);

  std::string folder() const;
  std::string folder_name() const;
  std::string parent_folder() const;
  // SetFolder and AppendFolder will append a folder delimiter, if needed.
  void SetFolder(const std::string& folder);
  void AppendFolder(const std::string& folder);

  std::string basename() const;
  bool SetBasename(const std::string& basename);

  std::string extension() const;
  // SetExtension will prefix a period, if needed.
  bool SetExtension(const std::string& extension);

  std::string filename() const;
  bool SetFilename(const std::string& filename);

#if defined(WEBRTC_WIN)
  bool GetDrive(char* drive, uint32_t bytes) const;
  static bool GetDrive(char* drive,
                       uint32_t bytes,
                       const std::string& pathname);
#endif

private:
  std::string folder_, basename_, extension_;
  char folder_delimiter_;
};

}  // namespace rtc

#endif // WEBRTC_BASE_PATHUTILS_H__
