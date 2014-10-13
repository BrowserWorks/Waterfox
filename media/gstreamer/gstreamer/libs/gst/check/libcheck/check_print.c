/*
 * Check: a unit test framework for C
 * Copyright (C) 2001, 2002 Arien Malec
 *
 * This library is free software; you can redistribute it and/or
 * modify it under the terms of the GNU Lesser General Public
 * License as published by the Free Software Foundation; either
 * version 2.1 of the License, or (at your option) any later version.
 *
 * This library is distributed in the hope that it will be useful,
 * but WITHOUT ANY WARRANTY; without even the implied warranty of
 * MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the GNU
 * Lesser General Public License for more details.
 *
 * You should have received a copy of the GNU Lesser General Public
 * License along with this library; if not, write to the
 * Free Software Foundation, Inc., 51 Franklin St, Fifth Floor,
 * Boston, MA 02110-1301, USA.
 */

#include "config.h"

#include <stdio.h>
#include <string.h>
#include <stdlib.h>

#include "check.h"
#include "check_list.h"
#include "check_impl.h"
#include "check_str.h"
#include "check_print.h"

static void srunner_fprint_summary (FILE * file, SRunner * sr,
    enum print_output print_mode);
static void srunner_fprint_results (FILE * file, SRunner * sr,
    enum print_output print_mode);


void
srunner_print (SRunner * sr, enum print_output print_mode)
{
  srunner_fprint (stdout, sr, print_mode);
}

void
srunner_fprint (FILE * file, SRunner * sr, enum print_output print_mode)
{
  if (print_mode == CK_ENV) {
    print_mode = get_env_printmode ();
  }

  srunner_fprint_summary (file, sr, print_mode);
  srunner_fprint_results (file, sr, print_mode);
}

static void
srunner_fprint_summary (FILE * file, SRunner * sr, enum print_output print_mode)
{
#if ENABLE_SUBUNIT
  if (print_mode == CK_SUBUNIT)
    return;
#endif

  if (print_mode >= CK_MINIMAL) {
    char *str;

    str = sr_stat_str (sr);
    fprintf (file, "%s\n", str);
    free (str);
  }
  return;
}

static void
srunner_fprint_results (FILE * file, SRunner * sr, enum print_output print_mode)
{
  List *resultlst;

#if ENABLE_SUBUNIT
  if (print_mode == CK_SUBUNIT)
    return;
#endif

  resultlst = sr->resultlst;

  for (list_front (resultlst); !list_at_end (resultlst);
      list_advance (resultlst)) {
    TestResult *tr = list_val (resultlst);
    tr_fprint (file, tr, print_mode);
  }
  return;
}

void
tr_fprint (FILE * file, TestResult * tr, enum print_output print_mode)
{
  if (print_mode == CK_ENV) {
    print_mode = get_env_printmode ();
  }

  if ((print_mode >= CK_VERBOSE && tr->rtype == CK_PASS) ||
      (tr->rtype != CK_PASS && print_mode >= CK_NORMAL)) {
    char *trstr = tr_str (tr);
    fprintf (file, "%s\n", trstr);
    free (trstr);
  }
}

static void
fprint_xml_esc (FILE * file, const char *str)
{
  for (; *str != '\0'; str++) {

    switch (*str) {

        /* handle special characters that must be escaped */
      case '"':
        fputs ("&quot;", file);
        break;
      case '\'':
        fputs ("&apos;", file);
        break;
      case '<':
        fputs ("&lt;", file);
        break;
      case '>':
        fputs ("&gt;", file);
        break;
      case '&':
        fputs ("&amp;", file);
        break;

        /* regular characters, print as is */
      default:
        fputc (*str, file);
        break;
    }
  }
}

void
tr_xmlprint (FILE * file, TestResult * tr,
    enum print_output print_mode CK_ATTRIBUTE_UNUSED)
{
  char result[10];
  char *path_name;
  char *file_name;
  char *slash;

  switch (tr->rtype) {
    case CK_PASS:
      strcpy (result, "success");
      break;
    case CK_FAILURE:
      strcpy (result, "failure");
      break;
    case CK_ERROR:
      strcpy (result, "error");
      break;
    case CK_TEST_RESULT_INVALID:
    default:
      abort ();
      break;
  }

  slash = strrchr (tr->file, '/');
  if (slash == NULL) {
    path_name = (char *) ".";
    file_name = tr->file;
  } else {
    path_name = strdup (tr->file);
    path_name[slash - tr->file] = 0;    /* Terminate the temporary string. */
    file_name = slash + 1;
  }


  fprintf (file, "    <test result=\"%s\">\n", result);
  fprintf (file, "      <path>%s</path>\n", path_name);
  fprintf (file, "      <fn>%s:%d</fn>\n", file_name, tr->line);
  fprintf (file, "      <id>%s</id>\n", tr->tname);
  fprintf (file, "      <iteration>%d</iteration>\n", tr->iter);
  fprintf (file, "      <description>");
  fprint_xml_esc (file, tr->tcname);
  fprintf (file, "</description>\n");
  fprintf (file, "      <message>");
  fprint_xml_esc (file, tr->msg);
  fprintf (file, "</message>\n");
  fprintf (file, "    </test>\n");

  if (slash != NULL) {
    free (path_name);
  }
}

enum print_output
get_env_printmode (void)
{
  char *env = getenv ("CK_VERBOSITY");
  if (env == NULL)
    return CK_NORMAL;
  if (strcmp (env, "silent") == 0)
    return CK_SILENT;
  if (strcmp (env, "minimal") == 0)
    return CK_MINIMAL;
  if (strcmp (env, "verbose") == 0)
    return CK_VERBOSE;
  return CK_NORMAL;
}
