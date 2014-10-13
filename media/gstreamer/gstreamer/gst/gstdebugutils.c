/* GStreamer
 * Copyright (C) 2007 Stefan Kost <ensonic@users.sf.net>
 *
 * gstdebugutils.c: debugging and analysis utillities
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
/* TODO:
 * edge [ constraint=false ];
 *   this creates strange graphs ("minlen=0" is better)
 * try puting src/sink ghostpads for each bin into invisible clusters
 *
 * for more compact nodes, try
 * - changing node-shape from box into record
 * - use labels like : element [ label="{element | <src> src | <sink> sink}"]
 * - point to record-connectors : element1:src -> element2:sink
 * - we use head/tail labels for pad-caps right now
 *   - this does not work well, as dot seems to not look at their size when
 *     doing the layout
 *   - we could add the caps to the pad itself, then we should use one line per
 *     caps (simple caps = one line)
 */

#include "gst_private.h"
#include "gstdebugutils.h"

#ifndef GST_DISABLE_GST_DEBUG

#include <stdlib.h>
#include <stdio.h>
#include <string.h>
#include <errno.h>

#include "gstinfo.h"
#include "gstbin.h"
#include "gstobject.h"
#include "gstghostpad.h"
#include "gstpad.h"
#include "gstutils.h"
#include "gstvalue.h"

/*** PIPELINE GRAPHS **********************************************************/

extern const gchar *priv_gst_dump_dot_dir;      /* NULL *//* set from gst.c */

const gchar spaces[] = {
  "                                "    /* 32 */
      "                                "        /* 64 */
      "                                "        /* 96 */
      "                                "        /* 128 */
};

extern GstClockTime _priv_gst_info_start_time;

static gchar *
debug_dump_make_object_name (GstObject * obj)
{
  return g_strcanon (g_strdup_printf ("%s_%p", GST_OBJECT_NAME (obj), obj),
      G_CSET_A_2_Z G_CSET_a_2_z G_CSET_DIGITS "_", '_');
}

static gchar *
debug_dump_get_element_state (GstElement * element)
{
  gchar *state_name = NULL;
  const gchar *state_icons = "~0-=>";
  GstState state = GST_STATE_VOID_PENDING, pending = GST_STATE_VOID_PENDING;

  gst_element_get_state (element, &state, &pending, 0);
  if (pending == GST_STATE_VOID_PENDING) {
    gboolean is_locked = gst_element_is_locked_state (element);
    state_name = g_strdup_printf ("\\n[%c]%s", state_icons[state],
        (is_locked ? "(locked)" : ""));
  } else {
    state_name = g_strdup_printf ("\\n[%c] -> [%c]", state_icons[state],
        state_icons[pending]);
  }
  return state_name;
}

static gchar *
debug_dump_get_element_params (GstElement * element)
{
  gchar *param_name = NULL;
  GParamSpec **properties, *property;
  GValue value = { 0, };
  guint i, number_of_properties;
  gchar *tmp, *value_str;

  /* get paramspecs and show non-default properties */
  properties =
      g_object_class_list_properties (G_OBJECT_CLASS (GST_ELEMENT_GET_CLASS
          (element)), &number_of_properties);
  if (properties) {
    for (i = 0; i < number_of_properties; i++) {
      property = properties[i];

      /* ski some properties */
      if (!(property->flags & G_PARAM_READABLE))
        continue;
      if (!strcmp (property->name, "name"))
        continue;

      g_value_init (&value, property->value_type);
      g_object_get_property (G_OBJECT (element), property->name, &value);
      if (!(g_param_value_defaults (property, &value))) {
        tmp = g_strdup_value_contents (&value);
        value_str = g_strescape (tmp, NULL);
        g_free (tmp);
        if (param_name) {
          tmp = param_name;
          param_name = g_strdup_printf ("%s\\n%s=%s",
              tmp, property->name, value_str);
          g_free (tmp);
        } else {
          param_name = g_strdup_printf ("\\n%s=%s", property->name, value_str);
        }
        g_free (value_str);
      }
      g_value_unset (&value);
    }
    g_free (properties);
  }
  return param_name;
}

static void
debug_dump_pad (GstPad * pad, const gchar * color_name,
    const gchar * element_name, GstDebugGraphDetails details, FILE * out,
    const gint indent)
{
  GstPadTemplate *pad_templ;
  GstPadPresence presence;
  gchar *pad_name;
  const gchar *style_name;
  const gchar *spc = &spaces[MAX (sizeof (spaces) - (1 + indent * 2), 0)];

  pad_name = debug_dump_make_object_name (GST_OBJECT (pad));

  /* pad availability */
  style_name = "filled,solid";
  if ((pad_templ = gst_pad_get_pad_template (pad))) {
    presence = GST_PAD_TEMPLATE_PRESENCE (pad_templ);
    gst_object_unref (pad_templ);
    if (presence == GST_PAD_SOMETIMES) {
      style_name = "filled,dotted";
    } else if (presence == GST_PAD_REQUEST) {
      style_name = "filled,dashed";
    }
  }
  if (details & GST_DEBUG_GRAPH_SHOW_STATES) {
    gchar pad_flags[4];
    const gchar *activation_mode = "-><";
    const gchar *task_mode = "";
    GstTask *task;

    GST_OBJECT_LOCK (pad);
    task = GST_PAD_TASK (pad);
    if (task) {
      switch (gst_task_get_state (task)) {
        case GST_TASK_STARTED:
          task_mode = "[T]";
          break;
        case GST_TASK_PAUSED:
          task_mode = "[t]";
          break;
        default:
          /* Invalid task state, ignoring */
          break;
      }
    }
    GST_OBJECT_UNLOCK (pad);

    /* check if pad flags */
    pad_flags[0] =
        GST_OBJECT_FLAG_IS_SET (pad, GST_PAD_FLAG_BLOCKED) ? 'B' : 'b';
    pad_flags[1] =
        GST_OBJECT_FLAG_IS_SET (pad, GST_PAD_FLAG_FLUSHING) ? 'F' : 'f';
    pad_flags[2] =
        GST_OBJECT_FLAG_IS_SET (pad, GST_PAD_FLAG_BLOCKING) ? 'B' : 'b';
    pad_flags[3] = '\0';

    fprintf (out,
        "%s  %s_%s [color=black, fillcolor=\"%s\", label=\"%s\\n[%c][%s]%s\", height=\"0.2\", style=\"%s\"];\n",
        spc, element_name, pad_name, color_name, GST_OBJECT_NAME (pad),
        activation_mode[pad->mode], pad_flags, task_mode, style_name);
  } else {
    fprintf (out,
        "%s  %s_%s [color=black, fillcolor=\"%s\", label=\"%s\", height=\"0.2\", style=\"%s\"];\n",
        spc, element_name, pad_name, color_name, GST_OBJECT_NAME (pad),
        style_name);
  }

  g_free (pad_name);
}

static void
debug_dump_element_pad (GstPad * pad, GstElement * element,
    GstDebugGraphDetails details, FILE * out, const gint indent)
{
  GstElement *target_element;
  GstPad *target_pad, *tmp_pad;
  GstPadDirection dir;
  gchar *element_name;
  gchar *target_element_name;
  const gchar *color_name;

  dir = gst_pad_get_direction (pad);
  element_name = debug_dump_make_object_name (GST_OBJECT (element));
  if (GST_IS_GHOST_PAD (pad)) {
    color_name =
        (dir == GST_PAD_SRC) ? "#ffdddd" : ((dir ==
            GST_PAD_SINK) ? "#ddddff" : "#ffffff");
    /* output target-pad so that it belongs to this element */
    if ((tmp_pad = gst_ghost_pad_get_target (GST_GHOST_PAD (pad)))) {
      if ((target_pad = gst_pad_get_peer (tmp_pad))) {
        gchar *pad_name, *target_pad_name;
        const gchar *spc = &spaces[MAX (sizeof (spaces) - (1 + indent * 2), 0)];

        if ((target_element = gst_pad_get_parent_element (target_pad))) {
          target_element_name =
              debug_dump_make_object_name (GST_OBJECT (target_element));
        } else {
          target_element_name = g_strdup ("");
        }
        debug_dump_pad (target_pad, color_name, target_element_name, details,
            out, indent);
        /* src ghostpad relationship */
        pad_name = debug_dump_make_object_name (GST_OBJECT (pad));
        target_pad_name = debug_dump_make_object_name (GST_OBJECT (target_pad));
        if (dir == GST_PAD_SRC) {
          fprintf (out, "%s%s_%s -> %s_%s [style=dashed, minlen=0]\n", spc,
              target_element_name, target_pad_name, element_name, pad_name);
        } else {
          fprintf (out, "%s%s_%s -> %s_%s [style=dashed, minlen=0]\n", spc,
              element_name, pad_name, target_element_name, target_pad_name);
        }
        g_free (target_pad_name);
        g_free (target_element_name);
        if (target_element)
          gst_object_unref (target_element);
        gst_object_unref (target_pad);
        g_free (pad_name);
      }
      gst_object_unref (tmp_pad);
    }
  } else {
    color_name =
        (dir == GST_PAD_SRC) ? "#ffaaaa" : ((dir ==
            GST_PAD_SINK) ? "#aaaaff" : "#cccccc");
  }
  /* pads */
  debug_dump_pad (pad, color_name, element_name, details, out, indent);
  g_free (element_name);
}

static gboolean
string_append_field (GQuark field, const GValue * value, gpointer ptr)
{
  GString *str = (GString *) ptr;
  gchar *value_str = gst_value_serialize (value);
  gchar *esc_value_str;

  if (value_str == NULL) {
    g_string_append_printf (str, "  %18s: NULL\\l", g_quark_to_string (field));
    return TRUE;
  }

  /* some enums can become really long */
  if (strlen (value_str) > 25) {
    gint pos = 24;

    /* truncate */
    value_str[25] = '\0';

    /* mirror any brackets and quotes */
    if (value_str[0] == '<')
      value_str[pos--] = '>';
    if (value_str[0] == '[')
      value_str[pos--] = ']';
    if (value_str[0] == '(')
      value_str[pos--] = ')';
    if (value_str[0] == '{')
      value_str[pos--] = '}';
    if (value_str[0] == '"')
      value_str[pos--] = '"';
    if (pos != 24)
      value_str[pos--] = ' ';
    /* elippsize */
    value_str[pos--] = '.';
    value_str[pos--] = '.';
    value_str[pos--] = '.';
  }
  esc_value_str = g_strescape (value_str, NULL);

  g_string_append_printf (str, "  %18s: %s\\l", g_quark_to_string (field),
      esc_value_str);

  g_free (value_str);
  g_free (esc_value_str);
  return TRUE;
}

static gchar *
debug_dump_describe_caps (GstCaps * caps, GstDebugGraphDetails details)
{
  gchar *media = NULL;

  if (details & GST_DEBUG_GRAPH_SHOW_CAPS_DETAILS) {

    if (gst_caps_is_any (caps) || gst_caps_is_empty (caps)) {
      media = gst_caps_to_string (caps);

    } else {
      GString *str = NULL;
      guint i;
      guint slen = 0;

      for (i = 0; i < gst_caps_get_size (caps); i++) {
        slen += 25 +
            STRUCTURE_ESTIMATED_STRING_LEN (gst_caps_get_structure (caps, i));
      }

      str = g_string_sized_new (slen);
      for (i = 0; i < gst_caps_get_size (caps); i++) {
        GstStructure *structure = gst_caps_get_structure (caps, i);

        g_string_append (str, gst_structure_get_name (structure));
        g_string_append (str, "\\l");

        gst_structure_foreach (structure, string_append_field, (gpointer) str);
      }

      media = g_string_free (str, FALSE);
    }

  } else {
    if (GST_CAPS_IS_SIMPLE (caps))
      media =
          g_strdup (gst_structure_get_name (gst_caps_get_structure (caps, 0)));
    else
      media = g_strdup ("*");
  }
  return media;
}

static void
debug_dump_element_pad_link (GstPad * pad, GstElement * element,
    GstDebugGraphDetails details, FILE * out, const gint indent)
{
  GstElement *peer_element;
  GstPad *peer_pad;
  GstCaps *caps, *peer_caps;
  gchar *media = NULL;
  gchar *media_src = NULL, *media_sink = NULL;
  gchar *pad_name, *element_name;
  gchar *peer_pad_name, *peer_element_name;
  const gchar *spc = &spaces[MAX (sizeof (spaces) - (1 + indent * 2), 0)];

  if ((peer_pad = gst_pad_get_peer (pad))) {
    if ((details & GST_DEBUG_GRAPH_SHOW_MEDIA_TYPE) ||
        (details & GST_DEBUG_GRAPH_SHOW_CAPS_DETAILS)
        ) {
      caps = gst_pad_get_current_caps (pad);
      if (!caps)
        caps = gst_pad_get_pad_template_caps (pad);
      peer_caps = gst_pad_get_current_caps (peer_pad);
      if (!peer_caps)
        peer_caps = gst_pad_get_pad_template_caps (peer_pad);

      media = debug_dump_describe_caps (caps, details);
      /* check if peer caps are different */
      if (peer_caps && !gst_caps_is_equal (caps, peer_caps)) {
        gchar *tmp;

        tmp = debug_dump_describe_caps (peer_caps, details);
        if (gst_pad_get_direction (pad) == GST_PAD_SRC) {
          media_src = media;
          media_sink = tmp;
        } else {
          media_src = tmp;
          media_sink = media;
        }
        media = NULL;
      }
      gst_caps_unref (peer_caps);
      gst_caps_unref (caps);
    }

    pad_name = debug_dump_make_object_name (GST_OBJECT (pad));
    if (element) {
      element_name = debug_dump_make_object_name (GST_OBJECT (element));
    } else {
      element_name = g_strdup ("");
    }
    peer_pad_name = debug_dump_make_object_name (GST_OBJECT (peer_pad));
    if ((peer_element = gst_pad_get_parent_element (peer_pad))) {
      peer_element_name =
          debug_dump_make_object_name (GST_OBJECT (peer_element));
    } else {
      peer_element_name = g_strdup ("");
    }

    /* pad link */
    if (media) {
      fprintf (out, "%s%s_%s -> %s_%s [label=\"%s\"]\n", spc,
          element_name, pad_name, peer_element_name, peer_pad_name, media);
      g_free (media);
    } else if (media_src && media_sink) {
      /* dot has some issues with placement of head and taillabels,
       * we need an empty label to make space */
      fprintf (out, "%s%s_%s -> %s_%s [labeldistance=\"10\", labelangle=\"0\", "
          "label=\"                                                  \", "
          "taillabel=\"%s\", headlabel=\"%s\"]\n",
          spc, element_name, pad_name, peer_element_name, peer_pad_name,
          media_src, media_sink);
      g_free (media_src);
      g_free (media_sink);
    } else {
      fprintf (out, "%s%s_%s -> %s_%s\n", spc,
          element_name, pad_name, peer_element_name, peer_pad_name);
    }

    g_free (pad_name);
    g_free (element_name);
    g_free (peer_pad_name);
    g_free (peer_element_name);
    if (peer_element)
      gst_object_unref (peer_element);
    gst_object_unref (peer_pad);
  }
}

static void
debug_dump_element_pads (GstIterator * pad_iter, GstPad * pad,
    GstElement * element, GstDebugGraphDetails details, FILE * out,
    const gint indent, guint * src_pads, guint * sink_pads)
{
  GValue item = { 0, };
  gboolean pads_done;
  GstPadDirection dir;

  pads_done = FALSE;
  while (!pads_done) {
    switch (gst_iterator_next (pad_iter, &item)) {
      case GST_ITERATOR_OK:
        pad = g_value_get_object (&item);
        debug_dump_element_pad (pad, element, details, out, indent);
        dir = gst_pad_get_direction (pad);
        if (dir == GST_PAD_SRC)
          (*src_pads)++;
        else if (dir == GST_PAD_SINK)
          (*sink_pads)++;
        g_value_reset (&item);
        break;
      case GST_ITERATOR_RESYNC:
        gst_iterator_resync (pad_iter);
        break;
      case GST_ITERATOR_ERROR:
      case GST_ITERATOR_DONE:
        pads_done = TRUE;
        break;
    }
  }
}

/*
 * debug_dump_element:
 * @bin: the bin that should be analyzed
 * @out: file to write to
 * @indent: level of graph indentation
 *
 * Helper for gst_debug_bin_to_dot_file() to recursively dump a pipeline.
 */
static void
debug_dump_element (GstBin * bin, GstDebugGraphDetails details, FILE * out,
    const gint indent)
{
  GstIterator *element_iter, *pad_iter;
  gboolean elements_done, pads_done;
  GValue item = { 0, };
  GValue item2 = { 0, };
  GstElement *element;
  GstPad *pad = NULL;
  guint src_pads, sink_pads;
  gchar *element_name;
  gchar *state_name = NULL;
  gchar *param_name = NULL;
  const gchar *spc = &spaces[MAX (sizeof (spaces) - (1 + indent * 2), 0)];

  element_iter = gst_bin_iterate_elements (bin);
  elements_done = FALSE;
  while (!elements_done) {
    switch (gst_iterator_next (element_iter, &item)) {
      case GST_ITERATOR_OK:
        element = g_value_get_object (&item);
        element_name = debug_dump_make_object_name (GST_OBJECT (element));

        if (details & GST_DEBUG_GRAPH_SHOW_STATES) {
          state_name = debug_dump_get_element_state (GST_ELEMENT (element));
        }
        if (details & GST_DEBUG_GRAPH_SHOW_NON_DEFAULT_PARAMS) {
          param_name = debug_dump_get_element_params (GST_ELEMENT (element));
        }
        /* elements */
        fprintf (out, "%ssubgraph cluster_%s {\n", spc, element_name);
        fprintf (out, "%s  fontname=\"Bitstream Vera Sans\";\n", spc);
        fprintf (out, "%s  fontsize=\"8\";\n", spc);
        fprintf (out, "%s  style=filled;\n", spc);
        fprintf (out, "%s  color=black;\n\n", spc);
        fprintf (out, "%s  label=\"%s\\n%s%s%s\";\n", spc,
            G_OBJECT_TYPE_NAME (element), GST_OBJECT_NAME (element),
            (state_name ? state_name : ""), (param_name ? param_name : "")
            );
        if (state_name) {
          g_free (state_name);
          state_name = NULL;
        }
        if (param_name) {
          g_free (param_name);
          param_name = NULL;
        }
        g_free (element_name);

        src_pads = sink_pads = 0;
        if ((pad_iter = gst_element_iterate_sink_pads (element))) {
          debug_dump_element_pads (pad_iter, pad, element, details, out, indent,
              &src_pads, &sink_pads);
          gst_iterator_free (pad_iter);
        }
        if ((pad_iter = gst_element_iterate_src_pads (element))) {
          debug_dump_element_pads (pad_iter, pad, element, details, out, indent,
              &src_pads, &sink_pads);
          gst_iterator_free (pad_iter);
        }
        if (GST_IS_BIN (element)) {
          fprintf (out, "%s  fillcolor=\"#ffffff\";\n", spc);
          /* recurse */
          debug_dump_element (GST_BIN (element), details, out, indent + 1);
        } else {
          if (src_pads && !sink_pads)
            fprintf (out, "%s  fillcolor=\"#ffaaaa\";\n", spc);
          else if (!src_pads && sink_pads)
            fprintf (out, "%s  fillcolor=\"#aaaaff\";\n", spc);
          else if (src_pads && sink_pads)
            fprintf (out, "%s  fillcolor=\"#aaffaa\";\n", spc);
          else
            fprintf (out, "%s  fillcolor=\"#ffffff\";\n", spc);
        }
        fprintf (out, "%s}\n\n", spc);
        if ((pad_iter = gst_element_iterate_pads (element))) {
          pads_done = FALSE;
          while (!pads_done) {
            switch (gst_iterator_next (pad_iter, &item2)) {
              case GST_ITERATOR_OK:
                pad = g_value_get_object (&item2);
                if (gst_pad_is_linked (pad)) {
                  if (gst_pad_get_direction (pad) == GST_PAD_SRC) {
                    debug_dump_element_pad_link (pad, element, details, out,
                        indent);
                  } else {
                    GstPad *peer_pad = gst_pad_get_peer (pad);

                    if (peer_pad) {
                      if (!GST_IS_GHOST_PAD (peer_pad)
                          && GST_IS_PROXY_PAD (peer_pad)) {
                        debug_dump_element_pad_link (peer_pad, NULL, details,
                            out, indent);
                      }
                      gst_object_unref (peer_pad);
                    }
                  }
                }
                g_value_reset (&item2);
                break;
              case GST_ITERATOR_RESYNC:
                gst_iterator_resync (pad_iter);
                break;
              case GST_ITERATOR_ERROR:
              case GST_ITERATOR_DONE:
                pads_done = TRUE;
                break;
            }
          }
          g_value_unset (&item2);
          gst_iterator_free (pad_iter);
        }
        g_value_reset (&item);
        break;
      case GST_ITERATOR_RESYNC:
        gst_iterator_resync (element_iter);
        break;
      case GST_ITERATOR_ERROR:
      case GST_ITERATOR_DONE:
        elements_done = TRUE;
        break;
    }
  }

  g_value_unset (&item);
  gst_iterator_free (element_iter);
}

/*
 * gst_debug_bin_to_dot_file:
 * @bin: the top-level pipeline that should be analyzed
 * @file_name: output base filename (e.g. "myplayer")
 *
 * To aid debugging applications one can use this method to write out the whole
 * network of gstreamer elements that form the pipeline into an dot file.
 * This file can be processed with graphviz to get an image.
 * <informalexample><programlisting>
 *  dot -Tpng -oimage.png graph_lowlevel.dot
 * </programlisting></informalexample>
 */
void
gst_debug_bin_to_dot_file (GstBin * bin, GstDebugGraphDetails details,
    const gchar * file_name)
{
  gchar *full_file_name = NULL;
  FILE *out;

  g_return_if_fail (GST_IS_BIN (bin));

  if (G_LIKELY (priv_gst_dump_dot_dir == NULL))
    return;

  if (!file_name) {
    file_name = g_get_application_name ();
    if (!file_name)
      file_name = "unnamed";
  }

  full_file_name = g_strdup_printf ("%s" G_DIR_SEPARATOR_S "%s.dot",
      priv_gst_dump_dot_dir, file_name);

  if ((out = fopen (full_file_name, "wb"))) {
    gchar *state_name = NULL;
    gchar *param_name = NULL;

    if (details & GST_DEBUG_GRAPH_SHOW_STATES) {
      state_name = debug_dump_get_element_state (GST_ELEMENT (bin));
    }
    if (details & GST_DEBUG_GRAPH_SHOW_NON_DEFAULT_PARAMS) {
      param_name = debug_dump_get_element_params (GST_ELEMENT (bin));
    }

    /* write header */
    fprintf (out,
        "digraph pipeline {\n"
        "  rankdir=LR;\n"
        "  fontname=\"sans\";\n"
        "  fontsize=\"10\";\n"
        "  labelloc=t;\n"
        "  nodesep=.1;\n"
        "  ranksep=.2;\n"
        "  label=\"<%s>\\n%s%s%s\";\n"
        "  node [style=filled, shape=box, fontsize=\"9\", fontname=\"sans\", margin=\"0.0,0.0\"];\n"
        "  edge [labelfontsize=\"6\", fontsize=\"9\", fontname=\"monospace\"];\n"
        "  \n"
        "  legend [\n"
        "    pos=\"0,0!\",\n"
        "    margin=\"0.05,0.05\",\n"
        "    label=\"Legend\\lElement-States: [~] void-pending, [0] null, [-] ready, [=] paused, [>] playing\\lPad-Activation: [-] none, [>] push, [<] pull\\lPad-Flags: [b]locked, [f]lushing, [b]locking; upper-case is set\\lPad-Task: [T] has started task, [t] has paused task\\l\"\n,"
        "  ];"
        "\n", G_OBJECT_TYPE_NAME (bin), GST_OBJECT_NAME (bin),
        (state_name ? state_name : ""), (param_name ? param_name : "")
        );
    if (state_name)
      g_free (state_name);
    if (param_name)
      g_free (param_name);

    debug_dump_element (bin, details, out, 1);

    /* write footer */
    fprintf (out, "}\n");
    fclose (out);
    GST_INFO ("wrote bin graph to : '%s'", full_file_name);
  } else {
    GST_WARNING ("Failed to open file '%s' for writing: %s", full_file_name,
        g_strerror (errno));
  }
  g_free (full_file_name);
}

/*
 * gst_debug_bin_to_dot_file_with_ts:
 * @bin: the top-level pipeline that should be analyzed
 * @file_name: output base filename (e.g. "myplayer")
 *
 * This works like gst_debug_bin_to_dot_file(), but adds the current timestamp
 * to the filename, so that it can be used to take multiple snapshots.
 */
void
gst_debug_bin_to_dot_file_with_ts (GstBin * bin,
    GstDebugGraphDetails details, const gchar * file_name)
{
  gchar *ts_file_name = NULL;
  GstClockTime elapsed;

  g_return_if_fail (GST_IS_BIN (bin));

  if (!file_name) {
    file_name = g_get_application_name ();
    if (!file_name)
      file_name = "unnamed";
  }

  /* add timestamp */
  elapsed = GST_CLOCK_DIFF (_priv_gst_info_start_time,
      gst_util_get_timestamp ());

  /* we don't use GST_TIME_FORMAT as such filenames would fail on some
   * filesystems like fat */
  ts_file_name =
      g_strdup_printf ("%u.%02u.%02u.%09u-%s", GST_TIME_ARGS (elapsed),
      file_name);

  gst_debug_bin_to_dot_file (bin, details, ts_file_name);
  g_free (ts_file_name);
}
#else /* !GST_DISABLE_GST_DEBUG */
#ifndef GST_REMOVE_DISABLED
void
gst_debug_bin_to_dot_file (GstBin * bin, GstDebugGraphDetails details,
    const gchar * file_name)
{
}

void
gst_debug_bin_to_dot_file_with_ts (GstBin * bin, GstDebugGraphDetails details,
    const gchar * file_name)
{
}
#endif /* GST_REMOVE_DISABLED */
#endif /* GST_DISABLE_GST_DEBUG */
