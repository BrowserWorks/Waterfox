/* Quicktime muxer plugin for GStreamer
 * Copyright (C) 2010 Thiago Santos <thiago.sousa.santos@collabora.co.uk>
 *
 * This library is free software; you can redistribute it and/or
 * modify it under the terms of the GNU Library General Public
 * License as published by the Free Software Foundation; either
 * version 2 of the License, or (at your option) any later version.
 *
 * This library is distributed in the hope that it will be useful,
 * but WITHOUT ANY WARRANTY; without even the implied warranty of
 * MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the GNU
 * Library General Public License for more details.
 *
 * You should have received a copy of the GNU Library General Public
 * License along with this library; if not, write to the
 * Free Software Foundation, Inc., 51 Franklin St, Fifth Floor,
 * Boston, MA 02110-1301, USA.
 */
/*
 * Unless otherwise indicated, Source Code is licensed under MIT license.
 * See further explanation attached in License Statement (distributed in the file
 * LICENSE).
 *
 * Permission is hereby granted, free of charge, to any person obtaining a copy of
 * this software and associated documentation files (the "Software"), to deal in
 * the Software without restriction, including without limitation the rights to
 * use, copy, modify, merge, publish, distribute, sublicense, and/or sell copies
 * of the Software, and to permit persons to whom the Software is furnished to do
 * so, subject to the following conditions:
 *
 * The above copyright notice and this permission notice shall be included in all
 * copies or substantial portions of the Software.
 *
 * THE SOFTWARE IS PROVIDED "AS IS", WITHOUT WARRANTY OF ANY KIND, EXPRESS OR
 * IMPLIED, INCLUDING BUT NOT LIMITED TO THE WARRANTIES OF MERCHANTABILITY,
 * FITNESS FOR A PARTICULAR PURPOSE AND NONINFRINGEMENT. IN NO EVENT SHALL THE
 * AUTHORS OR COPYRIGHT HOLDERS BE LIABLE FOR ANY CLAIM, DAMAGES OR OTHER
 * LIABILITY, WHETHER IN AN ACTION OF CONTRACT, TORT OR OTHERWISE, ARISING FROM,
 * OUT OF OR IN CONNECTION WITH THE SOFTWARE OR THE USE OR OTHER DEALINGS IN THE
 * SOFTWARE.
 */


/**
 * SECTION:element-qtmoovrecover
 * @short_description: Utility element for recovering unfinished quicktime files
 *
 * <refsect2>
 * <para>
 * This element recovers quicktime files created with qtmux using the moov
 * recovery feature.
 * </para>
 * <title>Example pipelines</title>
 * <para>
 * <programlisting>
 * TODO
 * </programlisting>
 * </para>
 * </refsect2>
 */

#ifdef HAVE_CONFIG_H
#include "config.h"
#endif

#include <glib/gstdio.h>
#include <gst/gst.h>

#include "gstqtmoovrecover.h"

GST_DEBUG_CATEGORY_STATIC (gst_qt_moov_recover_debug);
#define GST_CAT_DEFAULT gst_qt_moov_recover_debug

/* QTMoovRecover signals and args */
enum
{
  /* FILL ME */
  LAST_SIGNAL
};

enum
{
  PROP_0,
  PROP_RECOVERY_INPUT,
  PROP_BROKEN_INPUT,
  PROP_FIXED_OUTPUT,
  PROP_FAST_START_MODE
};

#define gst_qt_moov_recover_parent_class parent_class
G_DEFINE_TYPE (GstQTMoovRecover, gst_qt_moov_recover, GST_TYPE_PIPELINE);

/* property functions */
static void gst_qt_moov_recover_set_property (GObject * object,
    guint prop_id, const GValue * value, GParamSpec * pspec);
static void gst_qt_moov_recover_get_property (GObject * object,
    guint prop_id, GValue * value, GParamSpec * pspec);

static GstStateChangeReturn gst_qt_moov_recover_change_state (GstElement *
    element, GstStateChange transition);

static void gst_qt_moov_recover_finalize (GObject * object);

static void
gst_qt_moov_recover_class_init (GstQTMoovRecoverClass * klass)
{
  GObjectClass *gobject_class;
  GstElementClass *gstelement_class;

  gobject_class = (GObjectClass *) klass;
  gstelement_class = (GstElementClass *) klass;

  parent_class = g_type_class_peek_parent (klass);

  gobject_class->finalize = gst_qt_moov_recover_finalize;
  gobject_class->get_property = gst_qt_moov_recover_get_property;
  gobject_class->set_property = gst_qt_moov_recover_set_property;

  gstelement_class->change_state = gst_qt_moov_recover_change_state;

  g_object_class_install_property (gobject_class, PROP_FIXED_OUTPUT,
      g_param_spec_string ("fixed-output",
          "Path to write the fixed file",
          "Path to write the fixed file to (used as output)",
          NULL, G_PARAM_READWRITE | G_PARAM_STATIC_STRINGS));
  g_object_class_install_property (gobject_class, PROP_BROKEN_INPUT,
      g_param_spec_string ("broken-input",
          "Path to broken input file",
          "Path to broken input file. (If qtmux was on faststart mode, this "
          "file is the faststart file)", NULL,
          G_PARAM_READWRITE | G_PARAM_STATIC_STRINGS));
  g_object_class_install_property (gobject_class, PROP_RECOVERY_INPUT,
      g_param_spec_string ("recovery-input",
          "Path to recovery file",
          "Path to recovery file (used as input)", NULL,
          G_PARAM_READWRITE | G_PARAM_STATIC_STRINGS));
  g_object_class_install_property (gobject_class, PROP_FAST_START_MODE,
      g_param_spec_boolean ("faststart-mode",
          "If the broken input is from faststart mode",
          "If the broken input is from faststart mode",
          FALSE, G_PARAM_READWRITE | G_PARAM_STATIC_STRINGS));

  GST_DEBUG_CATEGORY_INIT (gst_qt_moov_recover_debug, "qtmoovrecover", 0,
      "QT Moovie Recover");

  gst_element_class_set_static_metadata (gstelement_class, "QT Moov Recover",
      "Util", "Recovers unfinished qtmux files",
      "Thiago Santos <thiago.sousa.santos@collabora.co.uk>");
}

static void
gst_qt_moov_recover_init (GstQTMoovRecover * qtmr)
{
}

static void
gst_qt_moov_recover_finalize (GObject * object)
{
  G_OBJECT_CLASS (parent_class)->finalize (object);
}

static void
gst_qt_moov_recover_run (void *data)
{
  FILE *moovrec = NULL;
  FILE *mdatinput = NULL;
  FILE *output = NULL;
  MdatRecovFile *mdat_recov = NULL;
  MoovRecovFile *moov_recov = NULL;
  GstQTMoovRecover *qtmr = GST_QT_MOOV_RECOVER_CAST (data);
  GError *err = NULL;

  GST_LOG_OBJECT (qtmr, "Starting task");

  GST_DEBUG_OBJECT (qtmr, "Validating properties");
  GST_OBJECT_LOCK (qtmr);
  /* validate properties */
  if (qtmr->broken_input == NULL) {
    GST_OBJECT_UNLOCK (qtmr);
    GST_ELEMENT_ERROR (qtmr, RESOURCE, SETTINGS,
        ("Please set broken-input property"), (NULL));
    goto end;
  }
  if (qtmr->recovery_input == NULL) {
    GST_OBJECT_UNLOCK (qtmr);
    GST_ELEMENT_ERROR (qtmr, RESOURCE, SETTINGS,
        ("Please set recovery-input property"), (NULL));
    goto end;
  }
  if (qtmr->fixed_output == NULL) {
    GST_OBJECT_UNLOCK (qtmr);
    GST_ELEMENT_ERROR (qtmr, RESOURCE, SETTINGS,
        ("Please set fixed-output property"), (NULL));
    goto end;
  }

  GST_DEBUG_OBJECT (qtmr, "Opening input/output files");
  /* open files */
  moovrec = g_fopen (qtmr->recovery_input, "rb");
  if (moovrec == NULL) {
    GST_OBJECT_UNLOCK (qtmr);
    GST_ELEMENT_ERROR (qtmr, RESOURCE, OPEN_READ,
        ("Failed to open recovery-input file"), (NULL));
    goto end;
  }

  mdatinput = g_fopen (qtmr->broken_input, "rb");
  if (mdatinput == NULL) {
    GST_OBJECT_UNLOCK (qtmr);
    GST_ELEMENT_ERROR (qtmr, RESOURCE, OPEN_READ,
        ("Failed to open broken-input file"), (NULL));
    goto end;
  }
  output = g_fopen (qtmr->fixed_output, "wb+");
  if (output == NULL) {
    GST_OBJECT_UNLOCK (qtmr);
    GST_ELEMENT_ERROR (qtmr, RESOURCE, OPEN_READ_WRITE,
        ("Failed to open fixed-output file"), (NULL));
    goto end;
  }
  GST_OBJECT_UNLOCK (qtmr);

  GST_DEBUG_OBJECT (qtmr, "Parsing input files");
  /* now create our structures */
  mdat_recov = mdat_recov_file_create (mdatinput, qtmr->faststart_mode, &err);
  mdatinput = NULL;
  if (mdat_recov == NULL) {
    GST_ELEMENT_ERROR (qtmr, RESOURCE, FAILED,
        ("Broken file could not be parsed correctly"), (NULL));
    goto end;
  }
  moov_recov = moov_recov_file_create (moovrec, &err);
  moovrec = NULL;
  if (moov_recov == NULL) {
    GST_ELEMENT_ERROR (qtmr, RESOURCE, FAILED,
        ("Recovery file could not be parsed correctly"), (NULL));
    goto end;
  }

  /* now parse the buffers data from moovrec */
  if (!moov_recov_parse_buffers (moov_recov, mdat_recov, &err)) {
    goto end;
  }

  GST_DEBUG_OBJECT (qtmr, "Writing fixed file to output");
  if (!moov_recov_write_file (moov_recov, mdat_recov, output, &err)) {
    goto end;
  }

  /* here means success */
  GST_DEBUG_OBJECT (qtmr, "Finished successfully, posting EOS");
  gst_element_post_message (GST_ELEMENT_CAST (qtmr),
      gst_message_new_eos (GST_OBJECT_CAST (qtmr)));

end:
  GST_LOG_OBJECT (qtmr, "Finalizing task");
  if (err) {
    GST_ELEMENT_ERROR (qtmr, RESOURCE, FAILED, ("%s", err->message), (NULL));
    g_error_free (err);
  }

  if (moov_recov)
    moov_recov_file_free (moov_recov);
  if (moovrec)
    fclose (moovrec);

  if (mdat_recov)
    mdat_recov_file_free (mdat_recov);
  if (mdatinput)
    fclose (mdatinput);

  if (output)
    fclose (output);
  GST_LOG_OBJECT (qtmr, "Leaving task");
  gst_task_stop (qtmr->task);
}

static void
gst_qt_moov_recover_get_property (GObject * object,
    guint prop_id, GValue * value, GParamSpec * pspec)
{
  GstQTMoovRecover *qtmr = GST_QT_MOOV_RECOVER_CAST (object);

  GST_OBJECT_LOCK (qtmr);
  switch (prop_id) {
    case PROP_FAST_START_MODE:
      g_value_set_boolean (value, qtmr->faststart_mode);
      break;
    case PROP_BROKEN_INPUT:
      g_value_set_string (value, qtmr->broken_input);
      break;
    case PROP_RECOVERY_INPUT:
      g_value_set_string (value, qtmr->recovery_input);
      break;
    case PROP_FIXED_OUTPUT:
      g_value_set_string (value, qtmr->fixed_output);
      break;
    default:
      G_OBJECT_WARN_INVALID_PROPERTY_ID (object, prop_id, pspec);
      break;
  }
  GST_OBJECT_UNLOCK (qtmr);
}

static void
gst_qt_moov_recover_set_property (GObject * object,
    guint prop_id, const GValue * value, GParamSpec * pspec)
{
  GstQTMoovRecover *qtmr = GST_QT_MOOV_RECOVER_CAST (object);

  GST_OBJECT_LOCK (qtmr);
  switch (prop_id) {
    case PROP_FAST_START_MODE:
      qtmr->faststart_mode = g_value_get_boolean (value);
      break;
    case PROP_BROKEN_INPUT:
      g_free (qtmr->broken_input);
      qtmr->broken_input = g_value_dup_string (value);
      break;
    case PROP_RECOVERY_INPUT:
      g_free (qtmr->recovery_input);
      qtmr->recovery_input = g_value_dup_string (value);
      break;
    case PROP_FIXED_OUTPUT:
      g_free (qtmr->fixed_output);
      qtmr->fixed_output = g_value_dup_string (value);
      break;
    default:
      G_OBJECT_WARN_INVALID_PROPERTY_ID (object, prop_id, pspec);
      break;
  }
  GST_OBJECT_UNLOCK (qtmr);
}

static GstStateChangeReturn
gst_qt_moov_recover_change_state (GstElement * element,
    GstStateChange transition)
{
  GstStateChangeReturn ret;
  GstQTMoovRecover *qtmr = GST_QT_MOOV_RECOVER_CAST (element);

  switch (transition) {
    case GST_STATE_CHANGE_NULL_TO_READY:
      qtmr->task = gst_task_new (gst_qt_moov_recover_run, qtmr, NULL);
      g_rec_mutex_init (&qtmr->task_mutex);
      gst_task_set_lock (qtmr->task, &qtmr->task_mutex);
      break;
    case GST_STATE_CHANGE_PAUSED_TO_PLAYING:
      gst_task_start (qtmr->task);
      break;
    default:
      break;
  }

  ret = GST_ELEMENT_CLASS (parent_class)->change_state (element, transition);

  switch (transition) {
    case GST_STATE_CHANGE_PLAYING_TO_PAUSED:
      gst_task_stop (qtmr->task);
      gst_task_join (qtmr->task);
      break;
    case GST_STATE_CHANGE_READY_TO_NULL:
      if (gst_task_get_state (qtmr->task) != GST_TASK_STOPPED)
        GST_ERROR ("task %p should be stopped by now", qtmr->task);
      gst_object_unref (qtmr->task);
      qtmr->task = NULL;
      g_rec_mutex_clear (&qtmr->task_mutex);
      break;
    default:
      break;
  }
  return ret;
}


gboolean
gst_qt_moov_recover_register (GstPlugin * plugin)
{
  return gst_element_register (plugin, "qtmoovrecover", GST_RANK_NONE,
      GST_TYPE_QT_MOOV_RECOVER);
}
