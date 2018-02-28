/* This Source Code Form is subject to the terms of the Mozilla Public
 * License, v. 2.0. If a copy of the MPL was not distributed with this
 * file, You can obtain one at http://mozilla.org/MPL/2.0/. */

#ifndef UPDATEDEFINES_H
#define UPDATEDEFINES_H

#include "readstrings.h"

#ifndef MAXPATHLEN
# ifdef PATH_MAX
#  define MAXPATHLEN PATH_MAX
# elif defined(MAX_PATH)
#  define MAXPATHLEN MAX_PATH
# elif defined(_MAX_PATH)
#  define MAXPATHLEN _MAX_PATH
# elif defined(CCHMAXPATH)
#  define MAXPATHLEN CCHMAXPATH
# else
#  define MAXPATHLEN 1024
# endif
#endif

#if defined(XP_WIN)
# include <windows.h>
# include <shlwapi.h>
# include <direct.h>
# include <io.h>
# include <stdio.h>
# include <stdarg.h>

# ifndef F_OK
#   define F_OK 00
# endif
# ifndef W_OK
#   define W_OK 02
# endif
# ifndef R_OK
#   define R_OK 04
# endif
# define S_ISDIR(s) (((s) & _S_IFMT) == _S_IFDIR)
# define S_ISREG(s) (((s) & _S_IFMT) == _S_IFREG)

# define access _access

# define putenv _putenv
# if defined(_MSC_VER) && _MSC_VER < 1900
#  define stat _stat
# endif
# define DELETE_DIR L"tobedeleted"
# define CALLBACK_BACKUP_EXT L".moz-callback"

# define LOG_S "%S"
# define NS_T(str) L ## str
# define NS_SLASH NS_T('\\')

static inline int mywcsprintf(WCHAR* dest, size_t count, const WCHAR* fmt, ...)
{
  size_t _count = count - 1;
  va_list varargs;
  va_start(varargs, fmt);
  int result = _vsnwprintf(dest, count - 1, fmt, varargs);
  va_end(varargs);
  dest[_count] = L'\0';
  return result;
}
#define NS_tsnprintf mywcsprintf
# define NS_taccess _waccess
# define NS_tatoi _wtoi64
# define NS_tchdir _wchdir
# define NS_tchmod _wchmod
# define NS_tfopen _wfopen
# define NS_tmkdir(path, perms) _wmkdir(path)
# define NS_tpid __int64
# define NS_tremove _wremove
// _wrename is used to avoid the link tracking service.
# define NS_trename _wrename
# define NS_trmdir _wrmdir
# define NS_tstat _wstat
# define NS_tlstat _wstat // No symlinks on Windows
# define NS_tstat_t _stat
# define NS_tstrcat wcscat
# define NS_tstrcmp wcscmp
# define NS_tstricmp wcsicmp
# define NS_tstrcpy wcscpy
# define NS_tstrncpy wcsncpy
# define NS_tstrlen wcslen
# define NS_tstrchr wcschr
# define NS_tstrrchr wcsrchr
# define NS_tstrstr wcsstr
# include "win_dirent.h"
# define NS_tDIR DIR
# define NS_tdirent dirent
# define NS_topendir opendir
# define NS_tclosedir closedir
# define NS_treaddir readdir
#else
# include <sys/wait.h>
# include <unistd.h>

#ifdef SOLARIS
# include <sys/stat.h>
#else
# include <fts.h>
#endif
# include <dirent.h>

#ifdef XP_MACOSX
# include <sys/time.h>
#endif

# define LOG_S "%s"
# define NS_T(str) str
# define NS_SLASH NS_T('/')
# define NS_tsnprintf snprintf
# define NS_taccess access
# define NS_tatoi atoi
# define NS_tchdir chdir
# define NS_tchmod chmod
# define NS_tfopen fopen
# define NS_tmkdir mkdir
# define NS_tpid int
# define NS_tremove remove
# define NS_trename rename
# define NS_trmdir rmdir
# define NS_tstat stat
# define NS_tstat_t stat
# define NS_tlstat lstat
# define NS_tstrcat strcat
# define NS_tstrcmp strcmp
# define NS_tstricmp strcasecmp
# define NS_tstrcpy strcpy
# define NS_tstrncpy strncpy
# define NS_tstrlen strlen
# define NS_tstrrchr strrchr
# define NS_tstrstr strstr
# define NS_tDIR DIR
# define NS_tdirent dirent
# define NS_topendir opendir
# define NS_tclosedir closedir
# define NS_treaddir readdir
#endif

#define BACKUP_EXT NS_T(".moz-backup")

#endif
