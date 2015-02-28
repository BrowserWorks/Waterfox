KDiff3-Readme for Windows
=========================

Author: Joachim Eibl  (joachim.eibl@gmx.de)
Copyright: (C) 2002-2014 by Joachim Eibl
KDiff3-Version: 0.9.98
Homepage: http://kdiff3.sourceforge.net

KDiff3 is a program that
- compares and merges two or three input files or directories,
- shows the differences line by line and character by character (!),
- provides an automatic merge-facility and
- an integrated editor for comfortable solving of merge-conflicts
- and has an intuitive graphical user interface.

Now KDiff3-strings are translated into some languages by the KDE-I18N-team. 
(*.qm-files in the KDiff3-directory)

See the Changelog.txt for a list of fixed bugs and new features.


Windows-specific information for the precompiled KDiff3 version:
================================================================

This executable is provided for the convenience of users who don't have a
compiler at hand.

You may redistribute it under the terms of the GNU GENERAL PUBLIC LICENCE.

Note that there is NO WARRANTY for this program.

Installation:
- The installer was initially created by Sebastien Fricker (sebastien.fricker@web.de).
  It is based on the Nullsoft Scriptable Install System (http://nsis.sourceforge.net)

- You can place the directory where you want it. But don't separate the file
  kdiff3.exe from the others, since they are needed for correct execution.  
  (Using kdiff3.exe standalone is possible except for translations and help.)

- Integration with WinCVS: When selected the installer sets KDiff3 to be the
  default diff-tool for WinCVS if available.
  Registry HKEY_CURRENT_USER\Software\WinCvs\wincvs\CVS settings: "P_Extdiff" and "P_DiffUseExtDiff"

- Integration with TortoiseSVN: When selected the installer sets KDiff3 to be the
  default diff-tool for TortoiseSVN if available.
  Registry HKEY_CURRENT_USER\Software\TortoiseSVN: "Diff" and "Merge"

- Integration with Explorer (1): When selected KDiff3 will be added to the "Send To"
  menu in the context menu. If you then select two files or two directories and
  choose "Send To"->"KDiff3" then KDiff3 will start and compare the specified files.

- Integration with Explorer (2): When selected Diff-Ext-For-KDiff3 will be installed.
  This is a Shell-Extension which adds an entry "KDiff3" into the context menu of 
  Windows Explorer. (e.g. when right-clicking a file or directory) With this it
  is possible to select files and directories sequentially and in separate directories 
  for comparison with KDiff3. This is based on Diff-Ext by Sergey Zorin 
  (http://diff-ext.sourceforge.net) with extensions for KDiff3 by Joachim Eibl. 
  This extension is not under GPL but under a BSD-style licence. (See file DIFF-EXT-LICENSE.txt.)
  On 64 bit systems both a 64 bit and a 32 bit version of this library will be installed, so
  that the shell context menu of 32 bit programs also show this sub menu.

- SVN Merge Tool: Allows to use KDiff3 for explicit graphical merges with Subversion.
  This installation option copies a file diff3_cmd.bat into your Application Data subdirectory.
  (C:\Documents and Settings\Username\Application Data\Subversion\diff3_cmd.bat)
  (Installation is disabled by default) 

- Integration with Rational ClearCase from IBM: Allows to use KDiff3 as comparison 
  and merge tool for text files under Clearcase. KDiff3 tries to locate the "map"-file 
  (e.g.: C:\Program Files\Rational\Clearcase\lib\mgrs\map) which tells clearcase 
  which tool to use for which filetype and operation. KDiff3 stores a backup in 
  map.preKDiff3Install (if is doesn't exist yet) and modifies the map file so that 
  KDiff3 is used for text files. On KDiff3-uninstallation the entries containing 
  "KDiff3" are restored. The map-file is normal text, so you can also adjust it 
  yourself. (Installation for ClearCase is disabled by default) 

- Utilities: GNU sed, diff, diff3, cmp, sdiff are provided for convenience.
  Installed in "bin"-subdir next to the kdiff3.exe.
  sed is a powerful preprocessing tool: KDiff3 will use this version if you just 
  type "sed" + your expression.
  diff.exe is a command line diff, diff3.exe is a command line 3-way merge, 
  cmp.exe is a simple file comparison tool, sdiff.exe prints diff results side by side.
  Documentation:  http://www.gnu.org/s/diffutils/manual
  
Since this program was actually developed for GNU/Linux, there might be Windows
specific problems I don't know of yet. Please write me about problems you encounter.

Known bugs:
- Links are not handled correctly. (This is because links in Windows are not
  the same as under Un*x-filesystems.)
- Comparing very big files causes KDiff3 to crash. Even if your machine has enough 
  memory, the internal structures can only handle up to 2 GB in text comparison mode.

Licence:
    GNU GENERAL PUBLIC LICENSE, Version 2, June 1991
    This program is free software; you can redistribute it and/or modify
    it under the terms of the GNU General Public License as published by
    the Free Software Foundation; either version 2 of the License, or
    (at your option) any later version.

    This program is distributed in the hope that it will be useful,
    but WITHOUT ANY WARRANTY; without even the implied warranty of
    MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the
    GNU General Public License for more details.

    You should have received a copy of the GNU General Public License
    along with this program; if not, write to the Free Software
    Foundation, Inc., 59 Temple Place, Suite 330, Boston, MA  02111-1307  USA

    For details see file "COPYING".


Start from commandline:
- Comparing 2 files:       kdiff3 file1 file2
- Merging 2 files:         kdiff3 file1 file2 -o outputfile
- Comparing 3 files:       kdiff3 file1 file2 file3
- Merging 3 files:         kdiff3 file1 file2 file3 -o outputfile
     Note that file1 will be treated as base of file2 and file3.

If all files have the same name but are in different directories, you can
reduce typework by specifying the filename only for the first file. E.g.:
- Comparing 3 files:     kdiff3 dir1/filename dir2 dir3
(This also works in the open-dialog.)

- Comparing 2 directories: kdiff3 dir1 dir2
- Merging 2 directories:   kdiff3 dir1 dir2-o destinationdir
- Comparing 3 directories: kdiff3 dir1 dir2 dir3
- Merging 3 directories:   kdiff3 dir1 dir2 dir3 -o destinationdir
(Please read the documentation about comparing/merging directories,
especially before you start merging.)

If you start without arguments, then a dialog will appear where you can
select your files and directories via a filebrowser.

For more documentation, see the help-menu or the subdirectory doc.

Have fun!
