/* gfileutils.c - File utility functions
 *
 *  Copyright 2000 Red Hat, Inc.
 *
 * GLib is free software; you can redistribute it and/or modify it
 * under the terms of the GNU Lesser General Public License as
 * published by the Free Software Foundation; either version 2 of the
 * License, or (at your option) any later version.
 *
 * GLib is distributed in the hope that it will be useful,
 * but WITHOUT ANY WARRANTY; without even the implied warranty of
 * MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the GNU
 * Lesser General Public License for more details.
 *
 * You should have received a copy of the GNU Lesser General Public
 * License along with GLib; see the file COPYING.LIB.  If not,
 * write to the Free Software Foundation, Inc., 59 Temple Place - Suite 330,
 *   Boston, MA 02111-1307, USA.
 */

#include "config.h"
#include "glibconfig.h"

#include <sys/stat.h>
#ifdef HAVE_UNISTD_H
#include <unistd.h>
#endif
#include <stdio.h>
#include <stdlib.h>
#include <stdarg.h>
#include <string.h>
#include <errno.h>
#include <sys/types.h>
#include <sys/stat.h>
#include <fcntl.h>
#include <stdlib.h>

#ifdef G_OS_WIN32
#include <windows.h>
#include <io.h>
#endif /* G_OS_WIN32 */

#ifndef S_ISLNK
#define S_ISLNK(x) 0
#endif

#ifndef O_BINARY
#define O_BINARY 0
#endif

#include "gfileutils.h"

#include "gstdio.h"
#include "glibintl.h"

#ifdef HAVE_LINUX_MAGIC_H /* for btrfs check */
#include <linux/magic.h>
#include <sys/vfs.h>
#endif


/**
 * SECTION:fileutils
 * @title: File Utilities
 * @short_description: various file-related functions
 *
 * There is a group of functions which wrap the common POSIX functions
 * dealing with filenames (g_open(), g_rename(), g_mkdir(), g_stat(),
 * g_unlink(), g_remove(), g_fopen(), g_freopen()). The point of these
 * wrappers is to make it possible to handle file names with any Unicode
 * characters in them on Windows without having to use ifdefs and the
 * wide character API in the application code.
 *
 * The pathname argument should be in the GLib file name encoding.
 * On POSIX this is the actual on-disk encoding which might correspond
 * to the locale settings of the process (or the
 * <envar>G_FILENAME_ENCODING</envar> environment variable), or not.
 *
 * On Windows the GLib file name encoding is UTF-8. Note that the
 * Microsoft C library does not use UTF-8, but has separate APIs for
 * current system code page and wide characters (UTF-16). The GLib
 * wrappers call the wide character API if present (on modern Windows
 * systems), otherwise convert to/from the system code page.
 *
 * Another group of functions allows to open and read directories
 * in the GLib file name encoding. These are g_dir_open(),
 * g_dir_read_name(), g_dir_rewind(), g_dir_close().
 */

/**
 * GFileError:
 * @G_FILE_ERROR_EXIST: Operation not permitted; only the owner of
 *     the file (or other resource) or processes with special privileges
 *     can perform the operation.
 * @G_FILE_ERROR_ISDIR: File is a directory; you cannot open a directory
 *     for writing, or create or remove hard links to it.
 * @G_FILE_ERROR_ACCES: Permission denied; the file permissions do not
 *     allow the attempted operation.
 * @G_FILE_ERROR_NAMETOOLONG: Filename too long.
 * @G_FILE_ERROR_NOENT: No such file or directory. This is a "file
 *     doesn't exist" error for ordinary files that are referenced in
 *     contexts where they are expected to already exist.
 * @G_FILE_ERROR_NOTDIR: A file that isn't a directory was specified when
 *     a directory is required.
 * @G_FILE_ERROR_NXIO: No such device or address. The system tried to
 *     use the device represented by a file you specified, and it
 *     couldn't find the device. This can mean that the device file was
 *     installed incorrectly, or that the physical device is missing or
 *     not correctly attached to the computer.
 * @G_FILE_ERROR_NODEV: The underlying file system of the specified file
 *     does not support memory mapping.
 * @G_FILE_ERROR_ROFS: The directory containing the new link can't be
 *     modified because it's on a read-only file system.
 * @G_FILE_ERROR_TXTBSY: Text file busy.
 * @G_FILE_ERROR_FAULT: You passed in a pointer to bad memory.
 *     (GLib won't reliably return this, don't pass in pointers to bad
 *     memory.)
 * @G_FILE_ERROR_LOOP: Too many levels of symbolic links were encountered
 *     in looking up a file name. This often indicates a cycle of symbolic
 *     links.
 * @G_FILE_ERROR_NOSPC: No space left on device; write operation on a
 *     file failed because the disk is full.
 * @G_FILE_ERROR_NOMEM: No memory available. The system cannot allocate
 *     more virtual memory because its capacity is full.
 * @G_FILE_ERROR_MFILE: The current process has too many files open and
 *     can't open any more. Duplicate descriptors do count toward this
 *     limit.
 * @G_FILE_ERROR_NFILE: There are too many distinct file openings in the
 *     entire system.
 * @G_FILE_ERROR_BADF: Bad file descriptor; for example, I/O on a
 *     descriptor that has been closed or reading from a descriptor open
 *     only for writing (or vice versa).
 * @G_FILE_ERROR_INVAL: Invalid argument. This is used to indicate
 *     various kinds of problems with passing the wrong argument to a
 *     library function.
 * @G_FILE_ERROR_PIPE: Broken pipe; there is no process reading from the
 *     other end of a pipe. Every library function that returns this
 *     error code also generates a 'SIGPIPE' signal; this signal
 *     terminates the program if not handled or blocked. Thus, your
 *     program will never actually see this code unless it has handled
 *     or blocked 'SIGPIPE'.
 * @G_FILE_ERROR_AGAIN: Resource temporarily unavailable; the call might
 *     work if you try again later.
 * @G_FILE_ERROR_INTR: Interrupted function call; an asynchronous signal
 *     occurred and prevented completion of the call. When this
 *     happens, you should try the call again.
 * @G_FILE_ERROR_IO: Input/output error; usually used for physical read
 *    or write errors. i.e. the disk or other physical device hardware
 *    is returning errors.
 * @G_FILE_ERROR_PERM: Operation not permitted; only the owner of the
 *    file (or other resource) or processes with special privileges can
 *    perform the operation.
 * @G_FILE_ERROR_NOSYS: Function not implemented; this indicates that
 *    the system is missing some functionality.
 * @G_FILE_ERROR_FAILED: Does not correspond to a UNIX error code; this
 *    is the standard "failed for unspecified reason" error code present
 *    in all #GError error code enumerations. Returned if no specific
 *    code applies.
 *
 * Values corresponding to @errno codes returned from file operations
 * on UNIX. Unlike @errno codes, GFileError values are available on
 * all systems, even Windows. The exact meaning of each code depends
 * on what sort of file operation you were performing; the UNIX
 * documentation gives more details. The following error code descriptions
 * come from the GNU C Library manual, and are under the copyright
 * of that manual.
 *
 * It's not very portable to make detailed assumptions about exactly
 * which errors will be returned from a given operation. Some errors
 * don't occur on some systems, etc., sometimes there are subtle
 * differences in when a system will report a given error, etc.
 */

/**
 * G_FILE_ERROR:
 *
 * Error domain for file operations. Errors in this domain will
 * be from the #GFileError enumeration. See #GError for information
 * on error domains.
 */

/**
 * GFileTest:
 * @G_FILE_TEST_IS_REGULAR: %TRUE if the file is a regular file
 *     (not a directory). Note that this test will also return %TRUE
 *     if the tested file is a symlink to a regular file.
 * @G_FILE_TEST_IS_SYMLINK: %TRUE if the file is a symlink.
 * @G_FILE_TEST_IS_DIR: %TRUE if the file is a directory.
 * @G_FILE_TEST_IS_EXECUTABLE: %TRUE if the file is executable.
 * @G_FILE_TEST_EXISTS: %TRUE if the file exists. It may or may not
 *     be a regular file.
 *
 * A test to perform on a file using g_file_test().
 */

/**
 * g_mkdir_with_parents:
 * @pathname: a pathname in the GLib file name encoding
 * @mode: permissions to use for newly created directories
 *
 * Create a directory if it doesn't already exist. Create intermediate
 * parent directories as needed, too.
 *
 * Returns: 0 if the directory already exists, or was successfully
 * created. Returns -1 if an error occurred, with errno set.
 *
 * Since: 2.8
 */
int
g_mkdir_with_parents (const gchar *pathname,
		      int          mode)
{
  gchar *fn, *p;

  if (pathname == NULL || *pathname == '\0')
    {
      errno = EINVAL;
      return -1;
    }

  fn = g_strdup (pathname);

  if (g_path_is_absolute (fn))
    p = (gchar *) g_path_skip_root (fn);
  else
    p = fn;

  do
    {
      while (*p && !G_IS_DIR_SEPARATOR (*p))
	p++;
      
      if (!*p)
	p = NULL;
      else
	*p = '\0';
      
      if (!g_file_test (fn, G_FILE_TEST_EXISTS))
	{
	  if (g_mkdir (fn, mode) == -1 && errno != EEXIST)
	    {
	      int errno_save = errno;
	      g_free (fn);
	      errno = errno_save;
	      return -1;
	    }
	}
      else if (!g_file_test (fn, G_FILE_TEST_IS_DIR))
	{
	  g_free (fn);
	  errno = ENOTDIR;
	  return -1;
	}
      if (p)
	{
	  *p++ = G_DIR_SEPARATOR;
	  while (*p && G_IS_DIR_SEPARATOR (*p))
	    p++;
	}
    }
  while (p);

  g_free (fn);

  return 0;
}

/**
 * g_file_test:
 * @filename: a filename to test in the GLib file name encoding
 * @test: bitfield of #GFileTest flags
 * 
 * Returns %TRUE if any of the tests in the bitfield @test are
 * %TRUE. For example, <literal>(G_FILE_TEST_EXISTS | 
 * G_FILE_TEST_IS_DIR)</literal> will return %TRUE if the file exists; 
 * the check whether it's a directory doesn't matter since the existence 
 * test is %TRUE. With the current set of available tests, there's no point
 * passing in more than one test at a time.
 * 
 * Apart from %G_FILE_TEST_IS_SYMLINK all tests follow symbolic links,
 * so for a symbolic link to a regular file g_file_test() will return
 * %TRUE for both %G_FILE_TEST_IS_SYMLINK and %G_FILE_TEST_IS_REGULAR.
 *
 * Note, that for a dangling symbolic link g_file_test() will return
 * %TRUE for %G_FILE_TEST_IS_SYMLINK and %FALSE for all other flags.
 *
 * You should never use g_file_test() to test whether it is safe
 * to perform an operation, because there is always the possibility
 * of the condition changing before you actually perform the operation.
 * For example, you might think you could use %G_FILE_TEST_IS_SYMLINK
 * to know whether it is safe to write to a file without being
 * tricked into writing into a different location. It doesn't work!
 * |[
 * /&ast; DON'T DO THIS &ast;/
 *  if (!g_file_test (filename, G_FILE_TEST_IS_SYMLINK)) 
 *    {
 *      fd = g_open (filename, O_WRONLY);
 *      /&ast; write to fd &ast;/
 *    }
 * ]|
 *
 * Another thing to note is that %G_FILE_TEST_EXISTS and
 * %G_FILE_TEST_IS_EXECUTABLE are implemented using the access()
 * system call. This usually doesn't matter, but if your program
 * is setuid or setgid it means that these tests will give you
 * the answer for the real user ID and group ID, rather than the
 * effective user ID and group ID.
 *
 * On Windows, there are no symlinks, so testing for
 * %G_FILE_TEST_IS_SYMLINK will always return %FALSE. Testing for
 * %G_FILE_TEST_IS_EXECUTABLE will just check that the file exists and
 * its name indicates that it is executable, checking for well-known
 * extensions and those listed in the <envar>PATHEXT</envar> environment variable.
 *
 * Return value: whether a test was %TRUE
 **/
gboolean
g_file_test (const gchar *filename,
             GFileTest    test)
{
#ifdef G_OS_WIN32
/* stuff missing in std vc6 api */
#  ifndef INVALID_FILE_ATTRIBUTES
#    define INVALID_FILE_ATTRIBUTES -1
#  endif
#  ifndef FILE_ATTRIBUTE_DEVICE
#    define FILE_ATTRIBUTE_DEVICE 64
#  endif
  int attributes;
  wchar_t *wfilename = g_utf8_to_utf16 (filename, -1, NULL, NULL, NULL);

  if (wfilename == NULL)
    return FALSE;

  attributes = GetFileAttributesW (wfilename);

  g_free (wfilename);

  if (attributes == INVALID_FILE_ATTRIBUTES)
    return FALSE;

  if (test & G_FILE_TEST_EXISTS)
    return TRUE;
      
  if (test & G_FILE_TEST_IS_REGULAR)
    {
      if ((attributes & (FILE_ATTRIBUTE_DIRECTORY | FILE_ATTRIBUTE_DEVICE)) == 0)
	return TRUE;
    }

  if (test & G_FILE_TEST_IS_DIR)
    {
      if ((attributes & FILE_ATTRIBUTE_DIRECTORY) != 0)
	return TRUE;
    }

  /* "while" so that we can exit this "loop" with a simple "break" */
  while (test & G_FILE_TEST_IS_EXECUTABLE)
    {
      const gchar *lastdot = strrchr (filename, '.');
      const gchar *pathext = NULL, *p;
      int extlen;

      if (lastdot == NULL)
        break;

      if (_stricmp (lastdot, ".exe") == 0 ||
	  _stricmp (lastdot, ".cmd") == 0 ||
	  _stricmp (lastdot, ".bat") == 0 ||
	  _stricmp (lastdot, ".com") == 0)
	return TRUE;

      /* Check if it is one of the types listed in %PATHEXT% */

      pathext = g_getenv ("PATHEXT");
      if (pathext == NULL)
        break;

      pathext = g_utf8_casefold (pathext, -1);

      lastdot = g_utf8_casefold (lastdot, -1);
      extlen = strlen (lastdot);

      p = pathext;
      while (TRUE)
	{
	  const gchar *q = strchr (p, ';');
	  if (q == NULL)
	    q = p + strlen (p);
	  if (extlen == q - p &&
	      memcmp (lastdot, p, extlen) == 0)
	    {
	      g_free ((gchar *) pathext);
	      g_free ((gchar *) lastdot);
	      return TRUE;
	    }
	  if (*q)
	    p = q + 1;
	  else
	    break;
	}

      g_free ((gchar *) pathext);
      g_free ((gchar *) lastdot);
      break;
    }

  return FALSE;
#else
  if ((test & G_FILE_TEST_EXISTS) && (access (filename, F_OK) == 0))
    return TRUE;
  
  if ((test & G_FILE_TEST_IS_EXECUTABLE) && (access (filename, X_OK) == 0))
    {
      if (getuid () != 0)
	return TRUE;

      /* For root, on some POSIX systems, access (filename, X_OK)
       * will succeed even if no executable bits are set on the
       * file. We fall through to a stat test to avoid that.
       */
    }
  else
    test &= ~G_FILE_TEST_IS_EXECUTABLE;

  if (test & G_FILE_TEST_IS_SYMLINK)
    {
      struct stat s;

      if ((lstat (filename, &s) == 0) && S_ISLNK (s.st_mode))
        return TRUE;
    }
  
  if (test & (G_FILE_TEST_IS_REGULAR |
	      G_FILE_TEST_IS_DIR |
	      G_FILE_TEST_IS_EXECUTABLE))
    {
      struct stat s;
      
      if (stat (filename, &s) == 0)
	{
	  if ((test & G_FILE_TEST_IS_REGULAR) && S_ISREG (s.st_mode))
	    return TRUE;
	  
	  if ((test & G_FILE_TEST_IS_DIR) && S_ISDIR (s.st_mode))
	    return TRUE;

	  /* The extra test for root when access (file, X_OK) succeeds.
	   */
	  if ((test & G_FILE_TEST_IS_EXECUTABLE) &&
	      ((s.st_mode & S_IXOTH) ||
	       (s.st_mode & S_IXUSR) ||
	       (s.st_mode & S_IXGRP)))
	    return TRUE;
	}
    }

  return FALSE;
#endif
}

G_DEFINE_QUARK (g-file-error-quark, g_file_error)

/**
 * g_file_error_from_errno:
 * @err_no: an "errno" value
 * 
 * Gets a #GFileError constant based on the passed-in @err_no.
 * For example, if you pass in <literal>EEXIST</literal> this function returns
 * #G_FILE_ERROR_EXIST. Unlike <literal>errno</literal> values, you can portably
 * assume that all #GFileError values will exist.
 *
 * Normally a #GFileError value goes into a #GError returned
 * from a function that manipulates files. So you would use
 * g_file_error_from_errno() when constructing a #GError.
 * 
 * Return value: #GFileError corresponding to the given @errno
 **/
GFileError
g_file_error_from_errno (gint err_no)
{
  switch (err_no)
    {
#ifdef EEXIST
    case EEXIST:
      return G_FILE_ERROR_EXIST;
      break;
#endif

#ifdef EISDIR
    case EISDIR:
      return G_FILE_ERROR_ISDIR;
      break;
#endif

#ifdef EACCES
    case EACCES:
      return G_FILE_ERROR_ACCES;
      break;
#endif

#ifdef ENAMETOOLONG
    case ENAMETOOLONG:
      return G_FILE_ERROR_NAMETOOLONG;
      break;
#endif

#ifdef ENOENT
    case ENOENT:
      return G_FILE_ERROR_NOENT;
      break;
#endif

#ifdef ENOTDIR
    case ENOTDIR:
      return G_FILE_ERROR_NOTDIR;
      break;
#endif

#ifdef ENXIO
    case ENXIO:
      return G_FILE_ERROR_NXIO;
      break;
#endif

#ifdef ENODEV
    case ENODEV:
      return G_FILE_ERROR_NODEV;
      break;
#endif

#ifdef EROFS
    case EROFS:
      return G_FILE_ERROR_ROFS;
      break;
#endif

#ifdef ETXTBSY
    case ETXTBSY:
      return G_FILE_ERROR_TXTBSY;
      break;
#endif

#ifdef EFAULT
    case EFAULT:
      return G_FILE_ERROR_FAULT;
      break;
#endif

#ifdef ELOOP
    case ELOOP:
      return G_FILE_ERROR_LOOP;
      break;
#endif

#ifdef ENOSPC
    case ENOSPC:
      return G_FILE_ERROR_NOSPC;
      break;
#endif

#ifdef ENOMEM
    case ENOMEM:
      return G_FILE_ERROR_NOMEM;
      break;
#endif

#ifdef EMFILE
    case EMFILE:
      return G_FILE_ERROR_MFILE;
      break;
#endif

#ifdef ENFILE
    case ENFILE:
      return G_FILE_ERROR_NFILE;
      break;
#endif

#ifdef EBADF
    case EBADF:
      return G_FILE_ERROR_BADF;
      break;
#endif

#ifdef EINVAL
    case EINVAL:
      return G_FILE_ERROR_INVAL;
      break;
#endif

#ifdef EPIPE
    case EPIPE:
      return G_FILE_ERROR_PIPE;
      break;
#endif

#ifdef EAGAIN
    case EAGAIN:
      return G_FILE_ERROR_AGAIN;
      break;
#endif

#ifdef EINTR
    case EINTR:
      return G_FILE_ERROR_INTR;
      break;
#endif

#ifdef EIO
    case EIO:
      return G_FILE_ERROR_IO;
      break;
#endif

#ifdef EPERM
    case EPERM:
      return G_FILE_ERROR_PERM;
      break;
#endif

#ifdef ENOSYS
    case ENOSYS:
      return G_FILE_ERROR_NOSYS;
      break;
#endif

    default:
      return G_FILE_ERROR_FAILED;
      break;
    }
}

static gboolean
get_contents_stdio (const gchar  *display_filename,
                    FILE         *f,
                    gchar       **contents,
                    gsize        *length,
                    GError      **error)
{
  gchar buf[4096];
  gsize bytes;
  gchar *str = NULL;
  gsize total_bytes = 0;
  gsize total_allocated = 0;
  gchar *tmp;

  g_assert (f != NULL);

  while (!feof (f))
    {
      gint save_errno;

      bytes = fread (buf, 1, sizeof (buf), f);
      save_errno = errno;

      while ((total_bytes + bytes + 1) > total_allocated)
        {
          if (str)
            total_allocated *= 2;
          else
            total_allocated = MIN (bytes + 1, sizeof (buf));

          tmp = g_try_realloc (str, total_allocated);

          if (tmp == NULL)
            {
              g_set_error (error,
                           G_FILE_ERROR,
                           G_FILE_ERROR_NOMEM,
                           g_dngettext (GETTEXT_PACKAGE, "Could not allocate %lu byte to read file \"%s\"", "Could not allocate %lu bytes to read file \"%s\"", (gulong)total_allocated),
                           (gulong) total_allocated,
			   display_filename);

              goto error;
            }

	  str = tmp;
        }

      if (ferror (f))
        {
          g_set_error (error,
                       G_FILE_ERROR,
                       g_file_error_from_errno (save_errno),
                       _("Error reading file '%s': %s"),
                       display_filename,
		       g_strerror (save_errno));

          goto error;
        }

      memcpy (str + total_bytes, buf, bytes);

      if (total_bytes + bytes < total_bytes) 
        {
          g_set_error (error,
                       G_FILE_ERROR,
                       G_FILE_ERROR_FAILED,
                       _("File \"%s\" is too large"),
                       display_filename);

          goto error;
        }

      total_bytes += bytes;
    }

  fclose (f);

  if (total_allocated == 0)
    {
      str = g_new (gchar, 1);
      total_bytes = 0;
    }

  str[total_bytes] = '\0';

  if (length)
    *length = total_bytes;

  *contents = str;

  return TRUE;

 error:

  g_free (str);
  fclose (f);

  return FALSE;
}

#ifndef G_OS_WIN32

static gboolean
get_contents_regfile (const gchar  *display_filename,
                      struct stat  *stat_buf,
                      gint          fd,
                      gchar       **contents,
                      gsize        *length,
                      GError      **error)
{
  gchar *buf;
  gsize bytes_read;
  gsize size;
  gsize alloc_size;
  
  size = stat_buf->st_size;

  alloc_size = size + 1;
  buf = g_try_malloc (alloc_size);

  if (buf == NULL)
    {
      g_set_error (error,
                   G_FILE_ERROR,
                   G_FILE_ERROR_NOMEM,
                           g_dngettext (GETTEXT_PACKAGE, "Could not allocate %lu byte to read file \"%s\"", "Could not allocate %lu bytes to read file \"%s\"", (gulong)alloc_size),
                   (gulong) alloc_size, 
		   display_filename);

      goto error;
    }
  
  bytes_read = 0;
  while (bytes_read < size)
    {
      gssize rc;
          
      rc = read (fd, buf + bytes_read, size - bytes_read);

      if (rc < 0)
        {
          if (errno != EINTR) 
            {
	      int save_errno = errno;

              g_free (buf);
              g_set_error (error,
                           G_FILE_ERROR,
                           g_file_error_from_errno (save_errno),
                           _("Failed to read from file '%s': %s"),
                           display_filename, 
			   g_strerror (save_errno));

	      goto error;
            }
        }
      else if (rc == 0)
        break;
      else
        bytes_read += rc;
    }
      
  buf[bytes_read] = '\0';

  if (length)
    *length = bytes_read;
  
  *contents = buf;

  close (fd);

  return TRUE;

 error:

  close (fd);
  
  return FALSE;
}

static gboolean
get_contents_posix (const gchar  *filename,
                    gchar       **contents,
                    gsize        *length,
                    GError      **error)
{
  struct stat stat_buf;
  gint fd;
  gchar *display_filename = g_filename_display_name (filename);

  /* O_BINARY useful on Cygwin */
  fd = open (filename, O_RDONLY|O_BINARY);

  if (fd < 0)
    {
      int save_errno = errno;

      g_set_error (error,
                   G_FILE_ERROR,
                   g_file_error_from_errno (save_errno),
                   _("Failed to open file '%s': %s"),
                   display_filename, 
		   g_strerror (save_errno));
      g_free (display_filename);

      return FALSE;
    }

  /* I don't think this will ever fail, aside from ENOMEM, but. */
  if (fstat (fd, &stat_buf) < 0)
    {
      int save_errno = errno;

      close (fd);
      g_set_error (error,
                   G_FILE_ERROR,
                   g_file_error_from_errno (save_errno),
                   _("Failed to get attributes of file '%s': fstat() failed: %s"),
                   display_filename, 
		   g_strerror (save_errno));
      g_free (display_filename);

      return FALSE;
    }

  if (stat_buf.st_size > 0 && S_ISREG (stat_buf.st_mode))
    {
      gboolean retval = get_contents_regfile (display_filename,
					      &stat_buf,
					      fd,
					      contents,
					      length,
					      error);
      g_free (display_filename);

      return retval;
    }
  else
    {
      FILE *f;
      gboolean retval;

      f = fdopen (fd, "r");
      
      if (f == NULL)
        {
	  int save_errno = errno;

          g_set_error (error,
                       G_FILE_ERROR,
                       g_file_error_from_errno (save_errno),
                       _("Failed to open file '%s': fdopen() failed: %s"),
                       display_filename, 
		       g_strerror (save_errno));
          g_free (display_filename);

          return FALSE;
        }
  
      retval = get_contents_stdio (display_filename, f, contents, length, error);
      g_free (display_filename);

      return retval;
    }
}

#else  /* G_OS_WIN32 */

static gboolean
get_contents_win32 (const gchar  *filename,
		    gchar       **contents,
		    gsize        *length,
		    GError      **error)
{
  FILE *f;
  gboolean retval;
  gchar *display_filename = g_filename_display_name (filename);
  int save_errno;
  
  f = g_fopen (filename, "rb");
  save_errno = errno;

  if (f == NULL)
    {
      g_set_error (error,
                   G_FILE_ERROR,
                   g_file_error_from_errno (save_errno),
                   _("Failed to open file '%s': %s"),
                   display_filename,
		   g_strerror (save_errno));
      g_free (display_filename);

      return FALSE;
    }
  
  retval = get_contents_stdio (display_filename, f, contents, length, error);
  g_free (display_filename);

  return retval;
}

#endif

/**
 * g_file_get_contents:
 * @filename: (type filename): name of a file to read contents from, in the GLib file name encoding
 * @contents: (out) (array length=length) (element-type guint8): location to store an allocated string, use g_free() to free
 *     the returned string
 * @length: (allow-none): location to store length in bytes of the contents, or %NULL
 * @error: return location for a #GError, or %NULL
 *
 * Reads an entire file into allocated memory, with good error
 * checking.
 *
 * If the call was successful, it returns %TRUE and sets @contents to the file
 * contents and @length to the length of the file contents in bytes. The string
 * stored in @contents will be nul-terminated, so for text files you can pass
 * %NULL for the @length argument. If the call was not successful, it returns
 * %FALSE and sets @error. The error domain is #G_FILE_ERROR. Possible error
 * codes are those in the #GFileError enumeration. In the error case,
 * @contents is set to %NULL and @length is set to zero.
 *
 * Return value: %TRUE on success, %FALSE if an error occurred
 **/
gboolean
g_file_get_contents (const gchar  *filename,
                     gchar       **contents,
                     gsize        *length,
                     GError      **error)
{  
  g_return_val_if_fail (filename != NULL, FALSE);
  g_return_val_if_fail (contents != NULL, FALSE);

  *contents = NULL;
  if (length)
    *length = 0;

#ifdef G_OS_WIN32
  return get_contents_win32 (filename, contents, length, error);
#else
  return get_contents_posix (filename, contents, length, error);
#endif
}

static gboolean
rename_file (const char  *old_name,
	     const char  *new_name,
	     GError     **err)
{
  errno = 0;
  if (g_rename (old_name, new_name) == -1)
    {
      int save_errno = errno;
      gchar *display_old_name = g_filename_display_name (old_name);
      gchar *display_new_name = g_filename_display_name (new_name);

      g_set_error (err,
		   G_FILE_ERROR,
		   g_file_error_from_errno (save_errno),
		   _("Failed to rename file '%s' to '%s': g_rename() failed: %s"),
		   display_old_name,
		   display_new_name,
		   g_strerror (save_errno));

      g_free (display_old_name);
      g_free (display_new_name);
      
      return FALSE;
    }
  
  return TRUE;
}

static char *
format_error_message (const gchar  *filename,
                      const gchar  *format_string) G_GNUC_FORMAT(2);

#pragma GCC diagnostic push
#pragma GCC diagnostic ignored "-Wformat-nonliteral"

static char *
format_error_message (const gchar  *filename,
                      const gchar  *format_string)
{
  gint saved_errno = errno;
  gchar *display_name;
  gchar *msg;

  display_name = g_filename_display_name (filename);
  msg = g_strdup_printf (format_string, display_name, g_strerror (saved_errno));
  g_free (display_name);

  return msg;
}

#pragma GCC diagnostic pop

/* format string must have two '%s':
 *
 *   - the place for the filename
 *   - the place for the strerror
 */
static void
set_file_error (GError      **error,
                const gchar  *filename,
                const gchar  *format_string)
                      
{
  int saved_errno = errno;
  char *msg = format_error_message (filename, format_string);

  g_set_error_literal (error, G_FILE_ERROR, g_file_error_from_errno (saved_errno),
                       msg);
  g_free (msg);
}

static gchar *
write_to_temp_file (const gchar  *contents,
		    gssize        length,
		    const gchar  *dest_file,
		    GError      **err)
{
  gchar *tmp_name;
  gchar *retval;
  gint fd;

  retval = NULL;

  tmp_name = g_strdup_printf ("%s.XXXXXX", dest_file);

  errno = 0;
  fd = g_mkstemp_full (tmp_name, O_RDWR | O_BINARY, 0666);

  if (fd == -1)
    {
      set_file_error (err, tmp_name, _("Failed to create file '%s': %s"));
      goto out;
    }

#ifdef HAVE_FALLOCATE
  if (length > 0)
    {
      /* We do this on a 'best effort' basis... It may not be supported
       * on the underlying filesystem.
       */
      (void) fallocate (fd, 0, 0, length);
    }
#endif
  while (length > 0)
    {
      gssize s;

      s = write (fd, contents, length);

      if (s < 0)
        {
          if (errno == EINTR)
            continue;

          set_file_error (err, tmp_name, _("Failed to write file '%s': write() failed: %s"));
          close (fd);
          g_unlink (tmp_name);

          goto out;
        }

      g_assert (s <= length);

      contents += s;
      length -= s;
    }

#ifdef BTRFS_SUPER_MAGIC
  {
    struct statfs buf;

    /* On Linux, on btrfs, skip the fsync since rename-over-existing is
     * guaranteed to be atomic and this is the only case in which we
     * would fsync() anyway.
     */

    if (fstatfs (fd, &buf) == 0 && buf.f_type == BTRFS_SUPER_MAGIC)
      goto no_fsync;
  }
#endif

#ifdef HAVE_FSYNC
  {
    struct stat statbuf;

    errno = 0;
    /* If the final destination exists and is > 0 bytes, we want to sync the
     * newly written file to ensure the data is on disk when we rename over
     * the destination. Otherwise if we get a system crash we can lose both
     * the new and the old file on some filesystems. (I.E. those that don't
     * guarantee the data is written to the disk before the metadata.)
     */
    if (g_lstat (dest_file, &statbuf) == 0 && statbuf.st_size > 0 && fsync (fd) != 0)
      {
        set_file_error (err, tmp_name, _("Failed to write file '%s': fsync() failed: %s"));
        close (fd);
        g_unlink (tmp_name);

        goto out;
      }
  }
#endif

#ifdef BTRFS_SUPER_MAGIC
 no_fsync:
#endif

  errno = 0;
  if (!g_close (fd, err))
    {
      g_unlink (tmp_name);

      goto out;
    }

  retval = g_strdup (tmp_name);

 out:
  g_free (tmp_name);

  return retval;
}

/**
 * g_file_set_contents:
 * @filename: (type filename): name of a file to write @contents to, in the GLib file name
 *   encoding
 * @contents: (array length=length) (element-type guint8): string to write to the file
 * @length: length of @contents, or -1 if @contents is a nul-terminated string
 * @error: return location for a #GError, or %NULL
 *
 * Writes all of @contents to a file named @filename, with good error checking.
 * If a file called @filename already exists it will be overwritten.
 *
 * This write is atomic in the sense that it is first written to a temporary
 * file which is then renamed to the final name. Notes:
 * <itemizedlist>
 * <listitem>
 *    On Unix, if @filename already exists hard links to @filename will break.
 *    Also since the file is recreated, existing permissions, access control
 *    lists, metadata etc. may be lost. If @filename is a symbolic link,
 *    the link itself will be replaced, not the linked file.
 * </listitem>
 * <listitem>
 *   On Windows renaming a file will not remove an existing file with the
 *   new name, so on Windows there is a race condition between the existing
 *   file being removed and the temporary file being renamed.
 * </listitem>
 * <listitem>
 *   On Windows there is no way to remove a file that is open to some
 *   process, or mapped into memory. Thus, this function will fail if
 *   @filename already exists and is open.
 * </listitem>
 * </itemizedlist>
 *
 * If the call was successful, it returns %TRUE. If the call was not successful,
 * it returns %FALSE and sets @error. The error domain is #G_FILE_ERROR.
 * Possible error codes are those in the #GFileError enumeration.
 *
 * Note that the name for the temporary file is constructed by appending up
 * to 7 characters to @filename.
 *
 * Return value: %TRUE on success, %FALSE if an error occurred
 *
 * Since: 2.8
 **/
gboolean
g_file_set_contents (const gchar  *filename,
		     const gchar  *contents,
		     gssize	   length,
		     GError	 **error)
{
  gchar *tmp_filename;
  gboolean retval;
  GError *rename_error = NULL;
  
  g_return_val_if_fail (filename != NULL, FALSE);
  g_return_val_if_fail (error == NULL || *error == NULL, FALSE);
  g_return_val_if_fail (contents != NULL || length == 0, FALSE);
  g_return_val_if_fail (length >= -1, FALSE);
  
  if (length == -1)
    length = strlen (contents);

  tmp_filename = write_to_temp_file (contents, length, filename, error);
  
  if (!tmp_filename)
    {
      retval = FALSE;
      goto out;
    }

  if (!rename_file (tmp_filename, filename, &rename_error))
    {
#ifndef G_OS_WIN32

      g_unlink (tmp_filename);
      g_propagate_error (error, rename_error);
      retval = FALSE;
      goto out;

#else /* G_OS_WIN32 */
      
      /* Renaming failed, but on Windows this may just mean
       * the file already exists. So if the target file
       * exists, try deleting it and do the rename again.
       */
      if (!g_file_test (filename, G_FILE_TEST_EXISTS))
	{
	  g_unlink (tmp_filename);
	  g_propagate_error (error, rename_error);
	  retval = FALSE;
	  goto out;
	}

      g_error_free (rename_error);
      
      if (g_unlink (filename) == -1)
	{
          gchar *display_filename = g_filename_display_name (filename);

	  int save_errno = errno;
	  
	  g_set_error (error,
		       G_FILE_ERROR,
		       g_file_error_from_errno (save_errno),
		       _("Existing file '%s' could not be removed: g_unlink() failed: %s"),
		       display_filename,
		       g_strerror (save_errno));

	  g_free (display_filename);
	  g_unlink (tmp_filename);
	  retval = FALSE;
	  goto out;
	}
      
      if (!rename_file (tmp_filename, filename, error))
	{
	  g_unlink (tmp_filename);
	  retval = FALSE;
	  goto out;
	}

#endif
    }

  retval = TRUE;
  
 out:
  g_free (tmp_filename);
  return retval;
}

/*
 * get_tmp_file based on the mkstemp implementation from the GNU C library.
 * Copyright (C) 1991,92,93,94,95,96,97,98,99 Free Software Foundation, Inc.
 */
typedef gint (*GTmpFileCallback) (const gchar *, gint, gint);

static gint
get_tmp_file (gchar            *tmpl,
              GTmpFileCallback  f,
              int               flags,
              int               mode)
{
  char *XXXXXX;
  int count, fd;
  static const char letters[] =
    "ABCDEFGHIJKLMNOPQRSTUVWXYZ0123456789";
  static const int NLETTERS = sizeof (letters) - 1;
  glong value;
  GTimeVal tv;
  static int counter = 0;

  g_return_val_if_fail (tmpl != NULL, -1);

  /* find the last occurrence of "XXXXXX" */
  XXXXXX = g_strrstr (tmpl, "XXXXXX");

  if (!XXXXXX || strncmp (XXXXXX, "XXXXXX", 6))
    {
      errno = EINVAL;
      return -1;
    }

  /* Get some more or less random data.  */
  g_get_current_time (&tv);
  value = (tv.tv_usec ^ tv.tv_sec) + counter++;

  for (count = 0; count < 100; value += 7777, ++count)
    {
      glong v = value;

      /* Fill in the random bits.  */
      XXXXXX[0] = letters[v % NLETTERS];
      v /= NLETTERS;
      XXXXXX[1] = letters[v % NLETTERS];
      v /= NLETTERS;
      XXXXXX[2] = letters[v % NLETTERS];
      v /= NLETTERS;
      XXXXXX[3] = letters[v % NLETTERS];
      v /= NLETTERS;
      XXXXXX[4] = letters[v % NLETTERS];
      v /= NLETTERS;
      XXXXXX[5] = letters[v % NLETTERS];

      fd = f (tmpl, flags, mode);

      if (fd >= 0)
        return fd;
      else if (errno != EEXIST)
        /* Any other error will apply also to other names we might
         *  try, and there are 2^32 or so of them, so give up now.
         */
        return -1;
    }

  /* We got out of the loop because we ran out of combinations to try.  */
  errno = EEXIST;
  return -1;
}

/* Some GTmpFileCallback implementations.
 *
 * Note: we cannot use open() or g_open() directly because even though
 * they appear compatible, they may be vararg functions and calling
 * varargs functions through a non-varargs type is undefined.
 */
static gint
wrap_g_mkdir (const gchar *filename,
              int          flags G_GNUC_UNUSED,
              int          mode)
{
  /* tmpl is in UTF-8 on Windows, thus use g_mkdir() */
  return g_mkdir (filename, mode);
}

static gint
wrap_g_open (const gchar *filename,
                int          flags,
                int          mode)
{
  return g_open (filename, flags, mode);
}

/**
 * g_mkdtemp_full:
 * @tmpl: (type filename): template directory name
 * @mode: permissions to create the temporary directory with
 *
 * Creates a temporary directory. See the mkdtemp() documentation
 * on most UNIX-like systems.
 *
 * The parameter is a string that should follow the rules for
 * mkdtemp() templates, i.e. contain the string "XXXXXX".
 * g_mkdtemp() is slightly more flexible than mkdtemp() in that the
 * sequence does not have to occur at the very end of the template
 * and you can pass a @mode. The X string will be modified to form
 * the name of a directory that didn't exist. The string should be
 * in the GLib file name encoding. Most importantly, on Windows it
 * should be in UTF-8.
 *
 * Return value: A pointer to @tmpl, which has been modified
 *     to hold the directory name. In case of errors, %NULL is
 *     returned, and %errno will be set.
 *
 * Since: 2.30
 */
gchar *
g_mkdtemp_full (gchar *tmpl,
                gint   mode)
{
  if (get_tmp_file (tmpl, wrap_g_mkdir, 0, mode) == -1)
    return NULL;
  else
    return tmpl;
}

/**
 * g_mkdtemp:
 * @tmpl: (type filename): template directory name
 *
 * Creates a temporary directory. See the mkdtemp() documentation
 * on most UNIX-like systems.
 *
 * The parameter is a string that should follow the rules for
 * mkdtemp() templates, i.e. contain the string "XXXXXX".
 * g_mkdtemp() is slightly more flexible than mkdtemp() in that the
 * sequence does not have to occur at the very end of the template
 * and you can pass a @mode and additional @flags. The X string will
 * be modified to form the name of a directory that didn't exist.
 * The string should be in the GLib file name encoding. Most importantly,
 * on Windows it should be in UTF-8.
 *
 * Return value: A pointer to @tmpl, which has been modified
 *     to hold the directory name.  In case of errors, %NULL is
 *     returned and %errno will be set.
 *
 * Since: 2.30
 */
gchar *
g_mkdtemp (gchar *tmpl)
{
  return g_mkdtemp_full (tmpl, 0700);
}

/**
 * g_mkstemp_full:
 * @tmpl: (type filename): template filename
 * @flags: flags to pass to an open() call in addition to O_EXCL
 *     and O_CREAT, which are passed automatically
 * @mode: permissions to create the temporary file with
 *
 * Opens a temporary file. See the mkstemp() documentation
 * on most UNIX-like systems.
 *
 * The parameter is a string that should follow the rules for
 * mkstemp() templates, i.e. contain the string "XXXXXX".
 * g_mkstemp_full() is slightly more flexible than mkstemp()
 * in that the sequence does not have to occur at the very end of the
 * template and you can pass a @mode and additional @flags. The X
 * string will be modified to form the name of a file that didn't exist.
 * The string should be in the GLib file name encoding. Most importantly,
 * on Windows it should be in UTF-8.
 *
 * Return value: A file handle (as from open()) to the file
 *     opened for reading and writing. The file handle should be
 *     closed with close(). In case of errors, -1 is returned
 *     and %errno will be set.
 *
 * Since: 2.22
 */
gint
g_mkstemp_full (gchar *tmpl,
                gint   flags,
                gint   mode)
{
  /* tmpl is in UTF-8 on Windows, thus use g_open() */
  return get_tmp_file (tmpl, wrap_g_open,
                       flags | O_CREAT | O_EXCL, mode);
}

/**
 * g_mkstemp:
 * @tmpl: (type filename): template filename
 *
 * Opens a temporary file. See the mkstemp() documentation
 * on most UNIX-like systems.
 *
 * The parameter is a string that should follow the rules for
 * mkstemp() templates, i.e. contain the string "XXXXXX".
 * g_mkstemp() is slightly more flexible than mkstemp() in that the
 * sequence does not have to occur at the very end of the template.
 * The X string will be modified to form the name of a file that
 * didn't exist. The string should be in the GLib file name encoding.
 * Most importantly, on Windows it should be in UTF-8.
 *
 * Return value: A file handle (as from open()) to the file
 *     opened for reading and writing. The file is opened in binary
 *     mode on platforms where there is a difference. The file handle
 *     should be closed with close(). In case of errors, -1 is
 *     returned and %errno will be set.
 */
gint
g_mkstemp (gchar *tmpl)
{
  return g_mkstemp_full (tmpl, O_RDWR | O_BINARY, 0600);
}

static gint
g_get_tmp_name (const gchar      *tmpl,
                gchar           **name_used,
                GTmpFileCallback  f,
                gint              flags,
                gint              mode,
                GError          **error)
{
  int retval;
  const char *tmpdir;
  const char *sep;
  char *fulltemplate;
  const char *slash;

  if (tmpl == NULL)
    tmpl = ".XXXXXX";

  if ((slash = strchr (tmpl, G_DIR_SEPARATOR)) != NULL
#ifdef G_OS_WIN32
      || (strchr (tmpl, '/') != NULL && (slash = "/"))
#endif
      )
    {
      gchar *display_tmpl = g_filename_display_name (tmpl);
      char c[2];
      c[0] = *slash;
      c[1] = '\0';

      g_set_error (error,
                   G_FILE_ERROR,
                   G_FILE_ERROR_FAILED,
                   _("Template '%s' invalid, should not contain a '%s'"),
                   display_tmpl, c);
      g_free (display_tmpl);

      return -1;
    }

  if (strstr (tmpl, "XXXXXX") == NULL)
    {
      gchar *display_tmpl = g_filename_display_name (tmpl);
      g_set_error (error,
                   G_FILE_ERROR,
                   G_FILE_ERROR_FAILED,
                   _("Template '%s' doesn't contain XXXXXX"),
                   display_tmpl);
      g_free (display_tmpl);
      return -1;
    }

  tmpdir = g_get_tmp_dir ();

  if (G_IS_DIR_SEPARATOR (tmpdir [strlen (tmpdir) - 1]))
    sep = "";
  else
    sep = G_DIR_SEPARATOR_S;

  fulltemplate = g_strconcat (tmpdir, sep, tmpl, NULL);

  retval = get_tmp_file (fulltemplate, f, flags, mode);
  if (retval == -1)
    {
      int save_errno = errno;
      gchar *display_fulltemplate = g_filename_display_name (fulltemplate);

      g_set_error (error,
                   G_FILE_ERROR,
                   g_file_error_from_errno (save_errno),
                   _("Failed to create file '%s': %s"),
                   display_fulltemplate, g_strerror (save_errno));
      g_free (display_fulltemplate);
      g_free (fulltemplate);
      return -1;
    }

  *name_used = fulltemplate;

  return retval;
}

/**
 * g_file_open_tmp:
 * @tmpl: (type filename) (allow-none): Template for file name, as in
 *     g_mkstemp(), basename only, or %NULL for a default template
 * @name_used: (out) (type filename): location to store actual name used,
 *     or %NULL
 * @error: return location for a #GError
 *
 * Opens a file for writing in the preferred directory for temporary
 * files (as returned by g_get_tmp_dir()).
 *
 * @tmpl should be a string in the GLib file name encoding containing
 * a sequence of six 'X' characters, as the parameter to g_mkstemp().
 * However, unlike these functions, the template should only be a
 * basename, no directory components are allowed. If template is
 * %NULL, a default template is used.
 *
 * Note that in contrast to g_mkstemp() (and mkstemp()) @tmpl is not
 * modified, and might thus be a read-only literal string.
 *
 * Upon success, and if @name_used is non-%NULL, the actual name used
 * is returned in @name_used. This string should be freed with g_free()
 * when not needed any longer. The returned name is in the GLib file
 * name encoding.
 *
 * Return value: A file handle (as from open()) to the file opened for
 *     reading and writing. The file is opened in binary mode on platforms
 *     where there is a difference. The file handle should be closed with
 *     close(). In case of errors, -1 is returned and @error will be set.
 */
gint
g_file_open_tmp (const gchar  *tmpl,
                 gchar       **name_used,
                 GError      **error)
{
  gchar *fulltemplate;
  gint result;

  result = g_get_tmp_name (tmpl, &fulltemplate,
                           wrap_g_open,
                           O_CREAT | O_EXCL | O_RDWR | O_BINARY,
                           0600,
                           error);
  if (result != -1)
    {
      if (name_used)
        *name_used = fulltemplate;
      else
        g_free (fulltemplate);
    }

  return result;
}

/**
 * g_dir_make_tmp:
 * @tmpl: (type filename) (allow-none): Template for directory name,
 *     as in g_mkdtemp(), basename only, or %NULL for a default template
 * @error: return location for a #GError
 *
 * Creates a subdirectory in the preferred directory for temporary
 * files (as returned by g_get_tmp_dir()).
 *
 * @tmpl should be a string in the GLib file name encoding containing
 * a sequence of six 'X' characters, as the parameter to g_mkstemp().
 * However, unlike these functions, the template should only be a
 * basename, no directory components are allowed. If template is
 * %NULL, a default template is used.
 *
 * Note that in contrast to g_mkdtemp() (and mkdtemp()) @tmpl is not
 * modified, and might thus be a read-only literal string.
 *
 * Return value: (type filename): The actual name used. This string
 *     should be freed with g_free() when not needed any longer and is
 *     is in the GLib file name encoding. In case of errors, %NULL is
 *     returned and @error will be set.
 *
 * Since: 2.30
 */
gchar *
g_dir_make_tmp (const gchar  *tmpl,
                GError      **error)
{
  gchar *fulltemplate;

  if (g_get_tmp_name (tmpl, &fulltemplate, wrap_g_mkdir, 0, 0700, error) == -1)
    return NULL;
  else
    return fulltemplate;
}

static gchar *
g_build_path_va (const gchar  *separator,
		 const gchar  *first_element,
		 va_list      *args,
		 gchar       **str_array)
{
  GString *result;
  gint separator_len = strlen (separator);
  gboolean is_first = TRUE;
  gboolean have_leading = FALSE;
  const gchar *single_element = NULL;
  const gchar *next_element;
  const gchar *last_trailing = NULL;
  gint i = 0;

  result = g_string_new (NULL);

  if (str_array)
    next_element = str_array[i++];
  else
    next_element = first_element;

  while (TRUE)
    {
      const gchar *element;
      const gchar *start;
      const gchar *end;

      if (next_element)
	{
	  element = next_element;
	  if (str_array)
	    next_element = str_array[i++];
	  else
	    next_element = va_arg (*args, gchar *);
	}
      else
	break;

      /* Ignore empty elements */
      if (!*element)
	continue;
      
      start = element;

      if (separator_len)
	{
	  while (strncmp (start, separator, separator_len) == 0)
	    start += separator_len;
      	}

      end = start + strlen (start);
      
      if (separator_len)
	{
	  while (end >= start + separator_len &&
		 strncmp (end - separator_len, separator, separator_len) == 0)
	    end -= separator_len;
	  
	  last_trailing = end;
	  while (last_trailing >= element + separator_len &&
		 strncmp (last_trailing - separator_len, separator, separator_len) == 0)
	    last_trailing -= separator_len;

	  if (!have_leading)
	    {
	      /* If the leading and trailing separator strings are in the
	       * same element and overlap, the result is exactly that element
	       */
	      if (last_trailing <= start)
		single_element = element;
		  
	      g_string_append_len (result, element, start - element);
	      have_leading = TRUE;
	    }
	  else
	    single_element = NULL;
	}

      if (end == start)
	continue;

      if (!is_first)
	g_string_append (result, separator);
      
      g_string_append_len (result, start, end - start);
      is_first = FALSE;
    }

  if (single_element)
    {
      g_string_free (result, TRUE);
      return g_strdup (single_element);
    }
  else
    {
      if (last_trailing)
	g_string_append (result, last_trailing);
  
      return g_string_free (result, FALSE);
    }
}

/**
 * g_build_pathv:
 * @separator: a string used to separator the elements of the path.
 * @args: (array zero-terminated=1): %NULL-terminated array of strings containing the path elements.
 * 
 * Behaves exactly like g_build_path(), but takes the path elements 
 * as a string array, instead of varargs. This function is mainly
 * meant for language bindings.
 *
 * Return value: a newly-allocated string that must be freed with g_free().
 *
 * Since: 2.8
 */
gchar *
g_build_pathv (const gchar  *separator,
	       gchar       **args)
{
  if (!args)
    return NULL;

  return g_build_path_va (separator, NULL, NULL, args);
}


/**
 * g_build_path:
 * @separator: a string used to separator the elements of the path.
 * @first_element: the first element in the path
 * @...: remaining elements in path, terminated by %NULL
 * 
 * Creates a path from a series of elements using @separator as the
 * separator between elements. At the boundary between two elements,
 * any trailing occurrences of separator in the first element, or
 * leading occurrences of separator in the second element are removed
 * and exactly one copy of the separator is inserted.
 *
 * Empty elements are ignored.
 *
 * The number of leading copies of the separator on the result is
 * the same as the number of leading copies of the separator on
 * the first non-empty element.
 *
 * The number of trailing copies of the separator on the result is
 * the same as the number of trailing copies of the separator on
 * the last non-empty element. (Determination of the number of
 * trailing copies is done without stripping leading copies, so
 * if the separator is <literal>ABA</literal>, <literal>ABABA</literal>
 * has 1 trailing copy.)
 *
 * However, if there is only a single non-empty element, and there
 * are no characters in that element not part of the leading or
 * trailing separators, then the result is exactly the original value
 * of that element.
 *
 * Other than for determination of the number of leading and trailing
 * copies of the separator, elements consisting only of copies
 * of the separator are ignored.
 * 
 * Return value: a newly-allocated string that must be freed with g_free().
 **/
gchar *
g_build_path (const gchar *separator,
	      const gchar *first_element,
	      ...)
{
  gchar *str;
  va_list args;

  g_return_val_if_fail (separator != NULL, NULL);

  va_start (args, first_element);
  str = g_build_path_va (separator, first_element, &args, NULL);
  va_end (args);

  return str;
}

#ifdef G_OS_WIN32

static gchar *
g_build_pathname_va (const gchar  *first_element,
		     va_list      *args,
		     gchar       **str_array)
{
  /* Code copied from g_build_pathv(), and modified to use two
   * alternative single-character separators.
   */
  GString *result;
  gboolean is_first = TRUE;
  gboolean have_leading = FALSE;
  const gchar *single_element = NULL;
  const gchar *next_element;
  const gchar *last_trailing = NULL;
  gchar current_separator = '\\';
  gint i = 0;

  result = g_string_new (NULL);

  if (str_array)
    next_element = str_array[i++];
  else
    next_element = first_element;
  
  while (TRUE)
    {
      const gchar *element;
      const gchar *start;
      const gchar *end;

      if (next_element)
	{
	  element = next_element;
	  if (str_array)
	    next_element = str_array[i++];
	  else
	    next_element = va_arg (*args, gchar *);
	}
      else
	break;

      /* Ignore empty elements */
      if (!*element)
	continue;
      
      start = element;

      if (TRUE)
	{
	  while (start &&
		 (*start == '\\' || *start == '/'))
	    {
	      current_separator = *start;
	      start++;
	    }
	}

      end = start + strlen (start);
      
      if (TRUE)
	{
	  while (end >= start + 1 &&
		 (end[-1] == '\\' || end[-1] == '/'))
	    {
	      current_separator = end[-1];
	      end--;
	    }
	  
	  last_trailing = end;
	  while (last_trailing >= element + 1 &&
		 (last_trailing[-1] == '\\' || last_trailing[-1] == '/'))
	    last_trailing--;

	  if (!have_leading)
	    {
	      /* If the leading and trailing separator strings are in the
	       * same element and overlap, the result is exactly that element
	       */
	      if (last_trailing <= start)
		single_element = element;
		  
	      g_string_append_len (result, element, start - element);
	      have_leading = TRUE;
	    }
	  else
	    single_element = NULL;
	}

      if (end == start)
	continue;

      if (!is_first)
	g_string_append_len (result, &current_separator, 1);
      
      g_string_append_len (result, start, end - start);
      is_first = FALSE;
    }

  if (single_element)
    {
      g_string_free (result, TRUE);
      return g_strdup (single_element);
    }
  else
    {
      if (last_trailing)
	g_string_append (result, last_trailing);
  
      return g_string_free (result, FALSE);
    }
}

#endif

/**
 * g_build_filenamev:
 * @args: (array zero-terminated=1): %NULL-terminated array of strings containing the path elements.
 * 
 * Behaves exactly like g_build_filename(), but takes the path elements 
 * as a string array, instead of varargs. This function is mainly
 * meant for language bindings.
 *
 * Return value: a newly-allocated string that must be freed with g_free().
 * 
 * Since: 2.8
 */
gchar *
g_build_filenamev (gchar **args)
{
  gchar *str;

#ifndef G_OS_WIN32
  str = g_build_path_va (G_DIR_SEPARATOR_S, NULL, NULL, args);
#else
  str = g_build_pathname_va (NULL, NULL, args);
#endif

  return str;
}

/**
 * g_build_filename:
 * @first_element: the first element in the path
 * @...: remaining elements in path, terminated by %NULL
 * 
 * Creates a filename from a series of elements using the correct
 * separator for filenames.
 *
 * On Unix, this function behaves identically to <literal>g_build_path
 * (G_DIR_SEPARATOR_S, first_element, ....)</literal>.
 *
 * On Windows, it takes into account that either the backslash
 * (<literal>\</literal> or slash (<literal>/</literal>) can be used
 * as separator in filenames, but otherwise behaves as on Unix. When
 * file pathname separators need to be inserted, the one that last
 * previously occurred in the parameters (reading from left to right)
 * is used.
 *
 * No attempt is made to force the resulting filename to be an absolute
 * path. If the first element is a relative path, the result will
 * be a relative path. 
 * 
 * Return value: a newly-allocated string that must be freed with g_free().
 **/
gchar *
g_build_filename (const gchar *first_element, 
		  ...)
{
  gchar *str;
  va_list args;

  va_start (args, first_element);
#ifndef G_OS_WIN32
  str = g_build_path_va (G_DIR_SEPARATOR_S, first_element, &args, NULL);
#else
  str = g_build_pathname_va (first_element, &args, NULL);
#endif
  va_end (args);

  return str;
}

/**
 * g_file_read_link:
 * @filename: the symbolic link
 * @error: return location for a #GError
 *
 * Reads the contents of the symbolic link @filename like the POSIX
 * readlink() function.  The returned string is in the encoding used
 * for filenames. Use g_filename_to_utf8() to convert it to UTF-8.
 *
 * Returns: A newly-allocated string with the contents of the symbolic link, 
 *          or %NULL if an error occurred.
 *
 * Since: 2.4
 */
gchar *
g_file_read_link (const gchar  *filename,
	          GError      **error)
{
#ifdef HAVE_READLINK
  gchar *buffer;
  guint size;
  gint read_size;    
  
  size = 256; 
  buffer = g_malloc (size);
  
  while (TRUE) 
    {
      read_size = readlink (filename, buffer, size);
      if (read_size < 0) {
	int save_errno = errno;
	gchar *display_filename = g_filename_display_name (filename);

	g_free (buffer);
	g_set_error (error,
		     G_FILE_ERROR,
		     g_file_error_from_errno (save_errno),
		     _("Failed to read the symbolic link '%s': %s"),
		     display_filename, 
		     g_strerror (save_errno));
	g_free (display_filename);
	
	return NULL;
      }
    
      if (read_size < size) 
	{
	  buffer[read_size] = 0;
	  return buffer;
	}
      
      size *= 2;
      buffer = g_realloc (buffer, size);
    }
#else
  g_set_error_literal (error,
                       G_FILE_ERROR,
                       G_FILE_ERROR_INVAL,
                       _("Symbolic links not supported"));
	
  return NULL;
#endif
}

/**
 * g_path_is_absolute:
 * @file_name: a file name
 *
 * Returns %TRUE if the given @file_name is an absolute file name.
 * Note that this is a somewhat vague concept on Windows.
 *
 * On POSIX systems, an absolute file name is well-defined. It always
 * starts from the single root directory. For example "/usr/local".
 *
 * On Windows, the concepts of current drive and drive-specific
 * current directory introduce vagueness. This function interprets as
 * an absolute file name one that either begins with a directory
 * separator such as "\Users\tml" or begins with the root on a drive,
 * for example "C:\Windows". The first case also includes UNC paths
 * such as "\\myserver\docs\foo". In all cases, either slashes or
 * backslashes are accepted.
 *
 * Note that a file name relative to the current drive root does not
 * truly specify a file uniquely over time and across processes, as
 * the current drive is a per-process value and can be changed.
 *
 * File names relative the current directory on some specific drive,
 * such as "D:foo/bar", are not interpreted as absolute by this
 * function, but they obviously are not relative to the normal current
 * directory as returned by getcwd() or g_get_current_dir()
 * either. Such paths should be avoided, or need to be handled using
 * Windows-specific code.
 *
 * Returns: %TRUE if @file_name is absolute
 */
gboolean
g_path_is_absolute (const gchar *file_name)
{
  g_return_val_if_fail (file_name != NULL, FALSE);

  if (G_IS_DIR_SEPARATOR (file_name[0]))
    return TRUE;

#ifdef G_OS_WIN32
  /* Recognize drive letter on native Windows */
  if (g_ascii_isalpha (file_name[0]) &&
      file_name[1] == ':' && G_IS_DIR_SEPARATOR (file_name[2]))
    return TRUE;
#endif

  return FALSE;
}

/**
 * g_path_skip_root:
 * @file_name: a file name
 *
 * Returns a pointer into @file_name after the root component,
 * i.e. after the "/" in UNIX or "C:\" under Windows. If @file_name
 * is not an absolute path it returns %NULL.
 *
 * Returns: a pointer into @file_name after the root component
 */
const gchar *
g_path_skip_root (const gchar *file_name)
{
  g_return_val_if_fail (file_name != NULL, NULL);

#ifdef G_PLATFORM_WIN32
  /* Skip \\server\share or //server/share */
  if (G_IS_DIR_SEPARATOR (file_name[0]) &&
      G_IS_DIR_SEPARATOR (file_name[1]) &&
      file_name[2] &&
      !G_IS_DIR_SEPARATOR (file_name[2]))
    {
      gchar *p;
      p = strchr (file_name + 2, G_DIR_SEPARATOR);

#ifdef G_OS_WIN32
      {
        gchar *q;

        q = strchr (file_name + 2, '/');
        if (p == NULL || (q != NULL && q < p))
        p = q;
      }
#endif

      if (p && p > file_name + 2 && p[1])
        {
          file_name = p + 1;

          while (file_name[0] && !G_IS_DIR_SEPARATOR (file_name[0]))
            file_name++;

          /* Possibly skip a backslash after the share name */
          if (G_IS_DIR_SEPARATOR (file_name[0]))
            file_name++;

          return (gchar *)file_name;
        }
    }
#endif

  /* Skip initial slashes */
  if (G_IS_DIR_SEPARATOR (file_name[0]))
    {
      while (G_IS_DIR_SEPARATOR (file_name[0]))
        file_name++;
      return (gchar *)file_name;
    }

#ifdef G_OS_WIN32
  /* Skip X:\ */
  if (g_ascii_isalpha (file_name[0]) &&
      file_name[1] == ':' &&
      G_IS_DIR_SEPARATOR (file_name[2]))
    return (gchar *)file_name + 3;
#endif

  return NULL;
}

/**
 * g_basename:
 * @file_name: the name of the file
 *
 * Gets the name of the file without any leading directory
 * components. It returns a pointer into the given file name
 * string.
 *
 * Return value: the name of the file without any leading
 *     directory components
 *
 * Deprecated:2.2: Use g_path_get_basename() instead, but notice
 *     that g_path_get_basename() allocates new memory for the
 *     returned string, unlike this function which returns a pointer
 *     into the argument.
 */
const gchar *
g_basename (const gchar *file_name)
{
  gchar *base;

  g_return_val_if_fail (file_name != NULL, NULL);

  base = strrchr (file_name, G_DIR_SEPARATOR);

#ifdef G_OS_WIN32
  {
    gchar *q;
    q = strrchr (file_name, '/');
    if (base == NULL || (q != NULL && q > base))
      base = q;
  }
#endif

  if (base)
    return base + 1;

#ifdef G_OS_WIN32
  if (g_ascii_isalpha (file_name[0]) && file_name[1] == ':')
    return (gchar*) file_name + 2;
#endif

  return (gchar*) file_name;
}

/**
 * g_path_get_basename:
 * @file_name: the name of the file
 *
 * Gets the last component of the filename.
 *
 * If @file_name ends with a directory separator it gets the component
 * before the last slash. If @file_name consists only of directory
 * separators (and on Windows, possibly a drive letter), a single
 * separator is returned. If @file_name is empty, it gets ".".
 *
 * Return value: a newly allocated string containing the last
 *    component of the filename
 */
gchar *
g_path_get_basename (const gchar *file_name)
{
  gssize base;
  gssize last_nonslash;
  gsize len;
  gchar *retval;

  g_return_val_if_fail (file_name != NULL, NULL);

  if (file_name[0] == '\0')
    return g_strdup (".");

  last_nonslash = strlen (file_name) - 1;

  while (last_nonslash >= 0 && G_IS_DIR_SEPARATOR (file_name [last_nonslash]))
    last_nonslash--;

  if (last_nonslash == -1)
    /* string only containing slashes */
    return g_strdup (G_DIR_SEPARATOR_S);

#ifdef G_OS_WIN32
  if (last_nonslash == 1 &&
      g_ascii_isalpha (file_name[0]) &&
      file_name[1] == ':')
    /* string only containing slashes and a drive */
    return g_strdup (G_DIR_SEPARATOR_S);
#endif
  base = last_nonslash;

  while (base >=0 && !G_IS_DIR_SEPARATOR (file_name [base]))
    base--;

#ifdef G_OS_WIN32
  if (base == -1 &&
      g_ascii_isalpha (file_name[0]) &&
      file_name[1] == ':')
    base = 1;
#endif /* G_OS_WIN32 */

  len = last_nonslash - base;
  retval = g_malloc (len + 1);
  memcpy (retval, file_name + base + 1, len);
  retval [len] = '\0';

  return retval;
}

/**
 * g_dirname:
 * @file_name: the name of the file
 *
 * Gets the directory components of a file name.
 *
 * If the file name has no directory components "." is returned.
 * The returned string should be freed when no longer needed.
 *
 * Returns: the directory components of the file
 *
 * Deprecated: use g_path_get_dirname() instead
 */

/**
 * g_path_get_dirname:
 * @file_name: the name of the file
 *
 * Gets the directory components of a file name.
 *
 * If the file name has no directory components "." is returned.
 * The returned string should be freed when no longer needed.
 *
 * Returns: the directory components of the file
 */
gchar *
g_path_get_dirname (const gchar *file_name)
{
  gchar *base;
  gsize len;

  g_return_val_if_fail (file_name != NULL, NULL);

  base = strrchr (file_name, G_DIR_SEPARATOR);

#ifdef G_OS_WIN32
  {
    gchar *q;
    q = strrchr (file_name, '/');
    if (base == NULL || (q != NULL && q > base))
      base = q;
  }
#endif

  if (!base)
    {
#ifdef G_OS_WIN32
      if (g_ascii_isalpha (file_name[0]) && file_name[1] == ':')
        {
          gchar drive_colon_dot[4];

          drive_colon_dot[0] = file_name[0];
          drive_colon_dot[1] = ':';
          drive_colon_dot[2] = '.';
          drive_colon_dot[3] = '\0';

          return g_strdup (drive_colon_dot);
        }
#endif
    return g_strdup (".");
    }

  while (base > file_name && G_IS_DIR_SEPARATOR (*base))
    base--;

#ifdef G_OS_WIN32
  /* base points to the char before the last slash.
   *
   * In case file_name is the root of a drive (X:\) or a child of the
   * root of a drive (X:\foo), include the slash.
   *
   * In case file_name is the root share of an UNC path
   * (\\server\share), add a slash, returning \\server\share\ .
   *
   * In case file_name is a direct child of a share in an UNC path
   * (\\server\share\foo), include the slash after the share name,
   * returning \\server\share\ .
   */
  if (base == file_name + 1 &&
      g_ascii_isalpha (file_name[0]) &&
      file_name[1] == ':')
    base++;
  else if (G_IS_DIR_SEPARATOR (file_name[0]) &&
           G_IS_DIR_SEPARATOR (file_name[1]) &&
           file_name[2] &&
           !G_IS_DIR_SEPARATOR (file_name[2]) &&
           base >= file_name + 2)
    {
      const gchar *p = file_name + 2;
      while (*p && !G_IS_DIR_SEPARATOR (*p))
        p++;
      if (p == base + 1)
        {
          len = (guint) strlen (file_name) + 1;
          base = g_new (gchar, len + 1);
          strcpy (base, file_name);
          base[len-1] = G_DIR_SEPARATOR;
          base[len] = 0;
          return base;
        }
      if (G_IS_DIR_SEPARATOR (*p))
        {
          p++;
          while (*p && !G_IS_DIR_SEPARATOR (*p))
            p++;
          if (p == base + 1)
            base++;
        }
    }
#endif

  len = (guint) 1 + base - file_name;
  base = g_new (gchar, len + 1);
  g_memmove (base, file_name, len);
  base[len] = 0;

  return base;
}

#if defined(MAXPATHLEN)
#define G_PATH_LENGTH MAXPATHLEN
#elif defined(PATH_MAX)
#define G_PATH_LENGTH PATH_MAX
#elif defined(_PC_PATH_MAX)
#define G_PATH_LENGTH sysconf(_PC_PATH_MAX)
#else
#define G_PATH_LENGTH 2048
#endif

/**
 * g_get_current_dir:
 *
 * Gets the current directory.
 *
 * The returned string should be freed when no longer needed.
 * The encoding of the returned string is system defined.
 * On Windows, it is always UTF-8.
 *
 * Returns: the current directory
 */
gchar *
g_get_current_dir (void)
{
#ifdef G_OS_WIN32

  gchar *dir = NULL;
  wchar_t dummy[2], *wdir;
  int len;

  len = GetCurrentDirectoryW (2, dummy);
  wdir = g_new (wchar_t, len);

  if (GetCurrentDirectoryW (len, wdir) == len - 1)
    dir = g_utf16_to_utf8 (wdir, -1, NULL, NULL, NULL);

  g_free (wdir);

  if (dir == NULL)
    dir = g_strdup ("\\");

  return dir;

#else

  gchar *buffer = NULL;
  gchar *dir = NULL;
  static gulong max_len = 0;

  if (max_len == 0)
    max_len = (G_PATH_LENGTH == -1) ? 2048 : G_PATH_LENGTH;

  /* We don't use getcwd(3) on SUNOS, because, it does a popen("pwd")
   * and, if that wasn't bad enough, hangs in doing so.
   */
#if (defined (sun) && !defined (__SVR4)) || !defined(HAVE_GETCWD)
  buffer = g_new (gchar, max_len + 1);
  *buffer = 0;
  dir = getwd (buffer);
#else
  while (max_len < G_MAXULONG / 2)
    {
      g_free (buffer);
      buffer = g_new (gchar, max_len + 1);
      *buffer = 0;
      dir = getcwd (buffer, max_len);

      if (dir || errno != ERANGE)
        break;

      max_len *= 2;
    }
#endif  /* !sun || !HAVE_GETCWD */

  if (!dir || !*buffer)
    {
      /* hm, should we g_error() out here?
       * this can happen if e.g. "./" has mode \0000
       */
      buffer[0] = G_DIR_SEPARATOR;
      buffer[1] = 0;
    }

  dir = g_strdup (buffer);
  g_free (buffer);

  return dir;

#endif /* !G_OS_WIN32 */
}


/* NOTE : Keep this part last to ensure nothing in this file uses thn
 * below binary compatibility versions.
 */
#if defined (G_OS_WIN32) && !defined (_WIN64)

/* Binary compatibility versions. Will be called by code compiled
 * against quite old (pre-2.8, I think) headers only, not from more
 * recently compiled code.
 */

#undef g_file_test

gboolean
g_file_test (const gchar *filename,
             GFileTest    test)
{
  gchar *utf8_filename = g_locale_to_utf8 (filename, -1, NULL, NULL, NULL);
  gboolean retval;

  if (utf8_filename == NULL)
    return FALSE;

  retval = g_file_test_utf8 (utf8_filename, test);

  g_free (utf8_filename);

  return retval;
}

#undef g_file_get_contents

gboolean
g_file_get_contents (const gchar  *filename,
                     gchar       **contents,
                     gsize        *length,
                     GError      **error)
{
  gchar *utf8_filename = g_locale_to_utf8 (filename, -1, NULL, NULL, error);
  gboolean retval;

  if (utf8_filename == NULL)
    return FALSE;

  retval = g_file_get_contents_utf8 (utf8_filename, contents, length, error);

  g_free (utf8_filename);

  return retval;
}

#undef g_mkstemp

static gint
wrap_libc_open (const gchar *filename,
                int          flags,
                int          mode)
{
  return open (filename, flags, mode);
}

gint
g_mkstemp (gchar *tmpl)
{
  /* This is the backward compatibility system codepage version,
   * thus use normal open().
   */
  return get_tmp_file (tmpl, wrap_libc_open,
		       O_RDWR | O_CREAT | O_EXCL, 0600);
}

#undef g_file_open_tmp

gint
g_file_open_tmp (const gchar  *tmpl,
		 gchar       **name_used,
		 GError      **error)
{
  gchar *utf8_tmpl = g_locale_to_utf8 (tmpl, -1, NULL, NULL, error);
  gchar *utf8_name_used;
  gint retval;

  if (utf8_tmpl == NULL)
    return -1;

  retval = g_file_open_tmp_utf8 (utf8_tmpl, &utf8_name_used, error);
  
  if (retval == -1)
    return -1;

  if (name_used)
    *name_used = g_locale_from_utf8 (utf8_name_used, -1, NULL, NULL, NULL);

  g_free (utf8_name_used);

  return retval;
}

#undef g_get_current_dir

gchar *
g_get_current_dir (void)
{
  gchar *utf8_dir = g_get_current_dir_utf8 ();
  gchar *dir = g_locale_from_utf8 (utf8_dir, -1, NULL, NULL, NULL);
  g_free (utf8_dir);
  return dir;
}

#endif

