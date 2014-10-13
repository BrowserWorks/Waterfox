/* GStreamer
 * Copyright (C) 2004 Ronald Bultje <rbultje@ronald.bitfreak.net>
 * Copyright (C) 2008 Sebastian Dröge <slomo@circular-chaos.org>
 *
 * gstchannelmix.c: setup of channel conversion matrices
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

#ifdef HAVE_CONFIG_H
#include "config.h"
#endif

#include <math.h>
#include <string.h>

#include "gstchannelmix.h"

/*
 * Channel matrix functions.
 */

void
gst_channel_mix_unset_matrix (AudioConvertCtx * this)
{
  gint i;

  /* don't access if nothing there */
  if (!this->matrix)
    return;

  /* free */
  for (i = 0; i < this->in.channels; i++)
    g_free (this->matrix[i]);
  g_free (this->matrix);

  this->matrix = NULL;
  g_free (this->tmp);
  this->tmp = NULL;
}

/*
 * Detect and fill in identical channels. E.g.
 * forward the left/right front channels in a
 * 5.1 to 2.0 conversion.
 */

static void
gst_channel_mix_fill_identical (AudioConvertCtx * this)
{
  gint ci, co;

  /* Apart from the compatible channel assignments, we can also have
   * same channel assignments. This is much simpler, we simply copy
   * the value from source to dest! */
  for (co = 0; co < this->out.channels; co++) {
    /* find a channel in input with same position */
    for (ci = 0; ci < this->in.channels; ci++) {
      if (this->in.position[ci] == this->out.position[co]) {
        this->matrix[ci][co] = 1.0;
      }
    }
  }
}

/*
 * Detect and fill in compatible channels. E.g.
 * forward left/right front to mono (or the other
 * way around) when going from 2.0 to 1.0.
 */

static void
gst_channel_mix_fill_compatible (AudioConvertCtx * this)
{
  /* Conversions from one-channel to compatible two-channel configs */
  struct
  {
    GstAudioChannelPosition pos1[2];
    GstAudioChannelPosition pos2[1];
  } conv[] = {
    /* front: mono <-> stereo */
    { {
    GST_AUDIO_CHANNEL_POSITION_FRONT_LEFT,
            GST_AUDIO_CHANNEL_POSITION_FRONT_RIGHT}, {
    GST_AUDIO_CHANNEL_POSITION_MONO}},
        /* front center: 2 <-> 1 */
    { {
    GST_AUDIO_CHANNEL_POSITION_FRONT_LEFT_OF_CENTER,
            GST_AUDIO_CHANNEL_POSITION_FRONT_RIGHT_OF_CENTER}, {
    GST_AUDIO_CHANNEL_POSITION_FRONT_CENTER}},
        /* rear: 2 <-> 1 */
    { {
    GST_AUDIO_CHANNEL_POSITION_REAR_LEFT,
            GST_AUDIO_CHANNEL_POSITION_REAR_RIGHT}, {
    GST_AUDIO_CHANNEL_POSITION_REAR_CENTER}}, { {
    GST_AUDIO_CHANNEL_POSITION_INVALID}}
  };
  gint c;

  /* conversions from compatible (but not the same) channel schemes */
  for (c = 0; conv[c].pos1[0] != GST_AUDIO_CHANNEL_POSITION_INVALID; c++) {
    gint pos1_0 = -1, pos1_1 = -1, pos1_2 = -1;
    gint pos2_0 = -1, pos2_1 = -1, pos2_2 = -1;
    gint n;

    for (n = 0; n < this->in.channels; n++) {
      if (this->in.position[n] == conv[c].pos1[0])
        pos1_0 = n;
      else if (this->in.position[n] == conv[c].pos1[1])
        pos1_1 = n;
      else if (this->in.position[n] == conv[c].pos2[0])
        pos1_2 = n;
    }
    for (n = 0; n < this->out.channels; n++) {
      if (this->out.position[n] == conv[c].pos1[0])
        pos2_0 = n;
      else if (this->out.position[n] == conv[c].pos1[1])
        pos2_1 = n;
      else if (this->out.position[n] == conv[c].pos2[0])
        pos2_2 = n;
    }

    /* The general idea here is to fill in channels from the same position
     * as good as possible. This means mixing left<->center and right<->center.
     */

    /* left -> center */
    if (pos1_0 != -1 && pos1_2 == -1 && pos2_0 == -1 && pos2_2 != -1)
      this->matrix[pos1_0][pos2_2] = 1.0;
    else if (pos1_0 != -1 && pos1_2 != -1 && pos2_0 == -1 && pos2_2 != -1)
      this->matrix[pos1_0][pos2_2] = 0.5;
    else if (pos1_0 != -1 && pos1_2 == -1 && pos2_0 != -1 && pos2_2 != -1)
      this->matrix[pos1_0][pos2_2] = 1.0;

    /* right -> center */
    if (pos1_1 != -1 && pos1_2 == -1 && pos2_1 == -1 && pos2_2 != -1)
      this->matrix[pos1_1][pos2_2] = 1.0;
    else if (pos1_1 != -1 && pos1_2 != -1 && pos2_1 == -1 && pos2_2 != -1)
      this->matrix[pos1_1][pos2_2] = 0.5;
    else if (pos1_1 != -1 && pos1_2 == -1 && pos2_1 != -1 && pos2_2 != -1)
      this->matrix[pos1_1][pos2_2] = 1.0;

    /* center -> left */
    if (pos1_2 != -1 && pos1_0 == -1 && pos2_2 == -1 && pos2_0 != -1)
      this->matrix[pos1_2][pos2_0] = 1.0;
    else if (pos1_2 != -1 && pos1_0 != -1 && pos2_2 == -1 && pos2_0 != -1)
      this->matrix[pos1_2][pos2_0] = 0.5;
    else if (pos1_2 != -1 && pos1_0 == -1 && pos2_2 != -1 && pos2_0 != -1)
      this->matrix[pos1_2][pos2_0] = 1.0;

    /* center -> right */
    if (pos1_2 != -1 && pos1_1 == -1 && pos2_2 == -1 && pos2_1 != -1)
      this->matrix[pos1_2][pos2_1] = 1.0;
    else if (pos1_2 != -1 && pos1_1 != -1 && pos2_2 == -1 && pos2_1 != -1)
      this->matrix[pos1_2][pos2_1] = 0.5;
    else if (pos1_2 != -1 && pos1_1 == -1 && pos2_2 != -1 && pos2_1 != -1)
      this->matrix[pos1_2][pos2_1] = 1.0;
  }
}

/*
 * Detect and fill in channels not handled by the
 * above two, e.g. center to left/right front in
 * 5.1 to 2.0 (or the other way around).
 *
 * Unfortunately, limited to static conversions
 * for now.
 */

static void
gst_channel_mix_detect_pos (GstAudioInfo * info,
    gint * f, gboolean * has_f,
    gint * c, gboolean * has_c, gint * r, gboolean * has_r,
    gint * s, gboolean * has_s, gint * b, gboolean * has_b)
{
  gint n;

  for (n = 0; n < info->channels; n++) {
    switch (info->position[n]) {
      case GST_AUDIO_CHANNEL_POSITION_MONO:
        f[1] = n;
        *has_f = TRUE;
        break;
      case GST_AUDIO_CHANNEL_POSITION_FRONT_LEFT:
        f[0] = n;
        *has_f = TRUE;
        break;
      case GST_AUDIO_CHANNEL_POSITION_FRONT_RIGHT:
        f[2] = n;
        *has_f = TRUE;
        break;
      case GST_AUDIO_CHANNEL_POSITION_FRONT_CENTER:
        c[1] = n;
        *has_c = TRUE;
        break;
      case GST_AUDIO_CHANNEL_POSITION_FRONT_LEFT_OF_CENTER:
        c[0] = n;
        *has_c = TRUE;
        break;
      case GST_AUDIO_CHANNEL_POSITION_FRONT_RIGHT_OF_CENTER:
        c[2] = n;
        *has_c = TRUE;
        break;
      case GST_AUDIO_CHANNEL_POSITION_REAR_CENTER:
        r[1] = n;
        *has_r = TRUE;
        break;
      case GST_AUDIO_CHANNEL_POSITION_REAR_LEFT:
        r[0] = n;
        *has_r = TRUE;
        break;
      case GST_AUDIO_CHANNEL_POSITION_REAR_RIGHT:
        r[2] = n;
        *has_r = TRUE;
        break;
      case GST_AUDIO_CHANNEL_POSITION_SIDE_LEFT:
        s[0] = n;
        *has_s = TRUE;
        break;
      case GST_AUDIO_CHANNEL_POSITION_SIDE_RIGHT:
        s[2] = n;
        *has_s = TRUE;
        break;
      case GST_AUDIO_CHANNEL_POSITION_LFE1:
        *has_b = TRUE;
        b[1] = n;
        break;
      default:
        break;
    }
  }
}

static void
gst_channel_mix_fill_one_other (gfloat ** matrix,
    GstAudioInfo * from_info, gint * from_idx,
    GstAudioInfo * to_info, gint * to_idx, gfloat ratio)
{

  /* src & dst have center => passthrough */
  if (from_idx[1] != -1 && to_idx[1] != -1) {
    matrix[from_idx[1]][to_idx[1]] = ratio;
  }

  /* src & dst have left => passthrough */
  if (from_idx[0] != -1 && to_idx[0] != -1) {
    matrix[from_idx[0]][to_idx[0]] = ratio;
  }

  /* src & dst have right => passthrough */
  if (from_idx[2] != -1 && to_idx[2] != -1) {
    matrix[from_idx[2]][to_idx[2]] = ratio;
  }

  /* src has left & dst has center => put into center */
  if (from_idx[0] != -1 && to_idx[1] != -1 && from_idx[1] != -1) {
    matrix[from_idx[0]][to_idx[1]] = 0.5 * ratio;
  } else if (from_idx[0] != -1 && to_idx[1] != -1 && from_idx[1] == -1) {
    matrix[from_idx[0]][to_idx[1]] = ratio;
  }

  /* src has right & dst has center => put into center */
  if (from_idx[2] != -1 && to_idx[1] != -1 && from_idx[1] != -1) {
    matrix[from_idx[2]][to_idx[1]] = 0.5 * ratio;
  } else if (from_idx[2] != -1 && to_idx[1] != -1 && from_idx[1] == -1) {
    matrix[from_idx[2]][to_idx[1]] = ratio;
  }

  /* src has center & dst has left => passthrough */
  if (from_idx[1] != -1 && to_idx[0] != -1 && from_idx[0] != -1) {
    matrix[from_idx[1]][to_idx[0]] = 0.5 * ratio;
  } else if (from_idx[1] != -1 && to_idx[0] != -1 && from_idx[0] == -1) {
    matrix[from_idx[1]][to_idx[0]] = ratio;
  }

  /* src has center & dst has right => passthrough */
  if (from_idx[1] != -1 && to_idx[2] != -1 && from_idx[2] != -1) {
    matrix[from_idx[1]][to_idx[2]] = 0.5 * ratio;
  } else if (from_idx[1] != -1 && to_idx[2] != -1 && from_idx[2] == -1) {
    matrix[from_idx[1]][to_idx[2]] = ratio;
  }
}

#define RATIO_CENTER_FRONT (1.0 / sqrt (2.0))
#define RATIO_CENTER_SIDE (1.0 / 2.0)
#define RATIO_CENTER_REAR (1.0 / sqrt (8.0))

#define RATIO_FRONT_CENTER (1.0 / sqrt (2.0))
#define RATIO_FRONT_SIDE (1.0 / sqrt (2.0))
#define RATIO_FRONT_REAR (1.0 / 2.0)

#define RATIO_SIDE_CENTER (1.0 / 2.0)
#define RATIO_SIDE_FRONT (1.0 / sqrt (2.0))
#define RATIO_SIDE_REAR (1.0 / sqrt (2.0))

#define RATIO_CENTER_BASS (1.0 / sqrt (2.0))
#define RATIO_FRONT_BASS (1.0)
#define RATIO_SIDE_BASS (1.0 / sqrt (2.0))
#define RATIO_REAR_BASS (1.0 / sqrt (2.0))

static void
gst_channel_mix_fill_others (AudioConvertCtx * this)
{
  gboolean in_has_front = FALSE, out_has_front = FALSE,
      in_has_center = FALSE, out_has_center = FALSE,
      in_has_rear = FALSE, out_has_rear = FALSE,
      in_has_side = FALSE, out_has_side = FALSE,
      in_has_bass = FALSE, out_has_bass = FALSE;
  /* LEFT, RIGHT, MONO */
  gint in_f[3] = { -1, -1, -1 };
  gint out_f[3] = { -1, -1, -1 };
  /* LOC, ROC, CENTER */
  gint in_c[3] = { -1, -1, -1 };
  gint out_c[3] = { -1, -1, -1 };
  /* RLEFT, RRIGHT, RCENTER */
  gint in_r[3] = { -1, -1, -1 };
  gint out_r[3] = { -1, -1, -1 };
  /* SLEFT, INVALID, SRIGHT */
  gint in_s[3] = { -1, -1, -1 };
  gint out_s[3] = { -1, -1, -1 };
  /* INVALID, LFE, INVALID */
  gint in_b[3] = { -1, -1, -1 };
  gint out_b[3] = { -1, -1, -1 };

  /* First see where (if at all) the various channels from/to
   * which we want to convert are located in our matrix/array. */
  gst_channel_mix_detect_pos (&this->in,
      in_f, &in_has_front,
      in_c, &in_has_center, in_r, &in_has_rear,
      in_s, &in_has_side, in_b, &in_has_bass);
  gst_channel_mix_detect_pos (&this->out,
      out_f, &out_has_front,
      out_c, &out_has_center, out_r, &out_has_rear,
      out_s, &out_has_side, out_b, &out_has_bass);

  /* The general idea here is:
   * - if the source has a channel that the destination doesn't have mix
   *   it into the nearest available destination channel
   * - if the destination has a channel that the source doesn't have mix
   *   the nearest source channel into the destination channel
   *
   * The ratio for the mixing becomes lower as the distance between the
   * channels gets larger
   */

  /* center <-> front/side/rear */
  if (!in_has_center && in_has_front && out_has_center) {
    gst_channel_mix_fill_one_other (this->matrix,
        &this->in, in_f, &this->out, out_c, RATIO_CENTER_FRONT);
  } else if (!in_has_center && !in_has_front && in_has_side && out_has_center) {
    gst_channel_mix_fill_one_other (this->matrix,
        &this->in, in_s, &this->out, out_c, RATIO_CENTER_SIDE);
  } else if (!in_has_center && !in_has_front && !in_has_side && in_has_rear
      && out_has_center) {
    gst_channel_mix_fill_one_other (this->matrix, &this->in, in_r, &this->out,
        out_c, RATIO_CENTER_REAR);
  } else if (in_has_center && !out_has_center && out_has_front) {
    gst_channel_mix_fill_one_other (this->matrix,
        &this->in, in_c, &this->out, out_f, RATIO_CENTER_FRONT);
  } else if (in_has_center && !out_has_center && !out_has_front && out_has_side) {
    gst_channel_mix_fill_one_other (this->matrix,
        &this->in, in_c, &this->out, out_s, RATIO_CENTER_SIDE);
  } else if (in_has_center && !out_has_center && !out_has_front && !out_has_side
      && out_has_rear) {
    gst_channel_mix_fill_one_other (this->matrix, &this->in, in_c, &this->out,
        out_r, RATIO_CENTER_REAR);
  }

  /* front <-> center/side/rear */
  if (!in_has_front && in_has_center && !in_has_side && out_has_front) {
    gst_channel_mix_fill_one_other (this->matrix,
        &this->in, in_c, &this->out, out_f, RATIO_CENTER_FRONT);
  } else if (!in_has_front && !in_has_center && in_has_side && out_has_front) {
    gst_channel_mix_fill_one_other (this->matrix,
        &this->in, in_s, &this->out, out_f, RATIO_FRONT_SIDE);
  } else if (!in_has_front && in_has_center && in_has_side && out_has_front) {
    gst_channel_mix_fill_one_other (this->matrix,
        &this->in, in_c, &this->out, out_f, 0.5 * RATIO_CENTER_FRONT);
    gst_channel_mix_fill_one_other (this->matrix,
        &this->in, in_s, &this->out, out_f, 0.5 * RATIO_FRONT_SIDE);
  } else if (!in_has_front && !in_has_center && !in_has_side && in_has_rear
      && out_has_front) {
    gst_channel_mix_fill_one_other (this->matrix, &this->in, in_r, &this->out,
        out_f, RATIO_FRONT_REAR);
  } else if (in_has_front && out_has_center && !out_has_side && !out_has_front) {
    gst_channel_mix_fill_one_other (this->matrix,
        &this->in, in_f, &this->out, out_c, RATIO_CENTER_FRONT);
  } else if (in_has_front && !out_has_center && out_has_side && !out_has_front) {
    gst_channel_mix_fill_one_other (this->matrix,
        &this->in, in_f, &this->out, out_s, RATIO_FRONT_SIDE);
  } else if (in_has_front && out_has_center && out_has_side && !out_has_front) {
    gst_channel_mix_fill_one_other (this->matrix,
        &this->in, in_f, &this->out, out_c, 0.5 * RATIO_CENTER_FRONT);
    gst_channel_mix_fill_one_other (this->matrix,
        &this->in, in_f, &this->out, out_s, 0.5 * RATIO_FRONT_SIDE);
  } else if (in_has_front && !out_has_center && !out_has_side && !out_has_front
      && out_has_rear) {
    gst_channel_mix_fill_one_other (this->matrix, &this->in, in_f, &this->out,
        out_r, RATIO_FRONT_REAR);
  }

  /* side <-> center/front/rear */
  if (!in_has_side && in_has_front && !in_has_rear && out_has_side) {
    gst_channel_mix_fill_one_other (this->matrix,
        &this->in, in_f, &this->out, out_s, RATIO_FRONT_SIDE);
  } else if (!in_has_side && !in_has_front && in_has_rear && out_has_side) {
    gst_channel_mix_fill_one_other (this->matrix,
        &this->in, in_r, &this->out, out_s, RATIO_SIDE_REAR);
  } else if (!in_has_side && in_has_front && in_has_rear && out_has_side) {
    gst_channel_mix_fill_one_other (this->matrix,
        &this->in, in_f, &this->out, out_s, 0.5 * RATIO_FRONT_SIDE);
    gst_channel_mix_fill_one_other (this->matrix,
        &this->in, in_r, &this->out, out_s, 0.5 * RATIO_SIDE_REAR);
  } else if (!in_has_side && !in_has_front && !in_has_rear && in_has_center
      && out_has_side) {
    gst_channel_mix_fill_one_other (this->matrix, &this->in, in_c, &this->out,
        out_s, RATIO_CENTER_SIDE);
  } else if (in_has_side && out_has_front && !out_has_rear && !out_has_side) {
    gst_channel_mix_fill_one_other (this->matrix,
        &this->in, in_s, &this->out, out_f, RATIO_FRONT_SIDE);
  } else if (in_has_side && !out_has_front && out_has_rear && !out_has_side) {
    gst_channel_mix_fill_one_other (this->matrix,
        &this->in, in_s, &this->out, out_r, RATIO_SIDE_REAR);
  } else if (in_has_side && out_has_front && out_has_rear && !out_has_side) {
    gst_channel_mix_fill_one_other (this->matrix,
        &this->in, in_s, &this->out, out_f, 0.5 * RATIO_FRONT_SIDE);
    gst_channel_mix_fill_one_other (this->matrix,
        &this->in, in_s, &this->out, out_r, 0.5 * RATIO_SIDE_REAR);
  } else if (in_has_side && !out_has_front && !out_has_rear && out_has_center
      && !out_has_side) {
    gst_channel_mix_fill_one_other (this->matrix, &this->in, in_s, &this->out,
        out_c, RATIO_CENTER_SIDE);
  }

  /* rear <-> center/front/side */
  if (!in_has_rear && in_has_side && out_has_rear) {
    gst_channel_mix_fill_one_other (this->matrix,
        &this->in, in_s, &this->out, out_r, RATIO_SIDE_REAR);
  } else if (!in_has_rear && !in_has_side && in_has_front && out_has_rear) {
    gst_channel_mix_fill_one_other (this->matrix,
        &this->in, in_f, &this->out, out_r, RATIO_FRONT_REAR);
  } else if (!in_has_rear && !in_has_side && !in_has_front && in_has_center
      && out_has_rear) {
    gst_channel_mix_fill_one_other (this->matrix, &this->in, in_c, &this->out,
        out_r, RATIO_CENTER_REAR);
  } else if (in_has_rear && !out_has_rear && out_has_side) {
    gst_channel_mix_fill_one_other (this->matrix,
        &this->in, in_r, &this->out, out_s, RATIO_SIDE_REAR);
  } else if (in_has_rear && !out_has_rear && !out_has_side && out_has_front) {
    gst_channel_mix_fill_one_other (this->matrix,
        &this->in, in_r, &this->out, out_f, RATIO_FRONT_REAR);
  } else if (in_has_rear && !out_has_rear && !out_has_side && !out_has_front
      && out_has_center) {
    gst_channel_mix_fill_one_other (this->matrix, &this->in, in_r, &this->out,
        out_c, RATIO_CENTER_REAR);
  }

  /* bass <-> any */
  if (in_has_bass && !out_has_bass) {
    if (out_has_center) {
      gst_channel_mix_fill_one_other (this->matrix,
          &this->in, in_b, &this->out, out_c, RATIO_CENTER_BASS);
    }
    if (out_has_front) {
      gst_channel_mix_fill_one_other (this->matrix,
          &this->in, in_b, &this->out, out_f, RATIO_FRONT_BASS);
    }
    if (out_has_side) {
      gst_channel_mix_fill_one_other (this->matrix,
          &this->in, in_b, &this->out, out_s, RATIO_SIDE_BASS);
    }
    if (out_has_rear) {
      gst_channel_mix_fill_one_other (this->matrix,
          &this->in, in_b, &this->out, out_r, RATIO_REAR_BASS);
    }
  } else if (!in_has_bass && out_has_bass) {
    if (in_has_center) {
      gst_channel_mix_fill_one_other (this->matrix,
          &this->in, in_c, &this->out, out_b, RATIO_CENTER_BASS);
    }
    if (in_has_front) {
      gst_channel_mix_fill_one_other (this->matrix,
          &this->in, in_f, &this->out, out_b, RATIO_FRONT_BASS);
    }
    if (in_has_side) {
      gst_channel_mix_fill_one_other (this->matrix,
          &this->in, in_s, &this->out, out_b, RATIO_REAR_BASS);
    }
    if (in_has_rear) {
      gst_channel_mix_fill_one_other (this->matrix,
          &this->in, in_r, &this->out, out_b, RATIO_REAR_BASS);
    }
  }
}

/*
 * Normalize output values.
 */

static void
gst_channel_mix_fill_normalize (AudioConvertCtx * this)
{
  gfloat sum, top = 0;
  gint i, j;

  for (j = 0; j < this->out.channels; j++) {
    /* calculate sum */
    sum = 0.0;
    for (i = 0; i < this->in.channels; i++) {
      sum += fabs (this->matrix[i][j]);
    }
    if (sum > top) {
      top = sum;
    }
  }

  /* normalize to this */
  if (top == 0.0)
    return;

  for (j = 0; j < this->out.channels; j++) {
    for (i = 0; i < this->in.channels; i++) {
      this->matrix[i][j] /= top;
    }
  }
}

static gboolean
gst_channel_mix_fill_special (AudioConvertCtx * this)
{
  GstAudioInfo *in = &this->in, *out = &this->out;

  /* Special, standard conversions here */

  /* Mono<->Stereo, just a fast-path */
  if (in->channels == 2 && out->channels == 1 &&
      ((in->position[0] == GST_AUDIO_CHANNEL_POSITION_FRONT_LEFT &&
              in->position[1] == GST_AUDIO_CHANNEL_POSITION_FRONT_RIGHT) ||
          (in->position[0] == GST_AUDIO_CHANNEL_POSITION_FRONT_RIGHT &&
              in->position[1] == GST_AUDIO_CHANNEL_POSITION_FRONT_LEFT)) &&
      out->position[0] == GST_AUDIO_CHANNEL_POSITION_MONO) {
    this->matrix[0][0] = 0.5;
    this->matrix[1][0] = 0.5;
    return TRUE;
  } else if (in->channels == 1 && out->channels == 2 &&
      ((out->position[0] == GST_AUDIO_CHANNEL_POSITION_FRONT_LEFT &&
              out->position[1] == GST_AUDIO_CHANNEL_POSITION_FRONT_RIGHT) ||
          (out->position[0] == GST_AUDIO_CHANNEL_POSITION_FRONT_RIGHT &&
              out->position[1] == GST_AUDIO_CHANNEL_POSITION_FRONT_LEFT)) &&
      in->position[0] == GST_AUDIO_CHANNEL_POSITION_MONO) {
    this->matrix[0][0] = 1.0;
    this->matrix[0][1] = 1.0;
    return TRUE;
  }

  /* TODO: 5.1 <-> Stereo and other standard conversions */

  return FALSE;
}

/*
 * Automagically generate conversion matrix.
 */

static void
gst_channel_mix_fill_matrix (AudioConvertCtx * this)
{
  if (gst_channel_mix_fill_special (this))
    return;

  gst_channel_mix_fill_identical (this);

  if (!GST_AUDIO_INFO_IS_UNPOSITIONED (&this->in)) {
    gst_channel_mix_fill_compatible (this);
    gst_channel_mix_fill_others (this);
    gst_channel_mix_fill_normalize (this);
  }
}

/* only call after this->out and this->in are filled in */
void
gst_channel_mix_setup_matrix (AudioConvertCtx * this)
{
  gint i, j;

  /* don't lose memory */
  gst_channel_mix_unset_matrix (this);

  /* temp storage */
  if (GST_AUDIO_FORMAT_INFO_IS_INTEGER (this->in.finfo) ||
      GST_AUDIO_FORMAT_INFO_IS_INTEGER (this->out.finfo)) {
    this->tmp = (gpointer) g_new (gint32, this->out.channels);
  } else {
    this->tmp = (gpointer) g_new (gdouble, this->out.channels);
  }

  /* allocate */
  this->matrix = g_new0 (gfloat *, this->in.channels);
  for (i = 0; i < this->in.channels; i++) {
    this->matrix[i] = g_new (gfloat, this->out.channels);
    for (j = 0; j < this->out.channels; j++)
      this->matrix[i][j] = 0.;
  }

  /* setup the matrix' internal values */
  gst_channel_mix_fill_matrix (this);

#ifndef GST_DISABLE_GST_DEBUG
  /* debug */
  {
    GString *s;
    s = g_string_new ("Matrix for");
    g_string_append_printf (s, " %d -> %d: ",
        this->in.channels, this->out.channels);
    g_string_append (s, "{");
    for (i = 0; i < this->in.channels; i++) {
      if (i != 0)
        g_string_append (s, ",");
      g_string_append (s, " {");
      for (j = 0; j < this->out.channels; j++) {
        if (j != 0)
          g_string_append (s, ",");
        g_string_append_printf (s, " %f", this->matrix[i][j]);
      }
      g_string_append (s, " }");
    }
    g_string_append (s, " }");
    GST_DEBUG ("%s", s->str);
    g_string_free (s, TRUE);
  }
#endif
}

gboolean
gst_channel_mix_passthrough (AudioConvertCtx * this)
{
  gint i;
  guint64 in_mask, out_mask;

  /* only NxN matrices can be identities */
  if (this->in.channels != this->out.channels)
    return FALSE;

  /* passthrough for 1->1 channels (MONO and NONE position are the same here) */
  if (this->in.channels == 1 && this->out.channels == 1)
    return TRUE;

  /* passthrough if both channel masks are the same */
  in_mask = out_mask = 0;
  for (i = 0; i < this->in.channels; i++) {
    in_mask |= this->in.position[i];
    out_mask |= this->out.position[i];
  }

  return in_mask == out_mask;
}

/* IMPORTANT: out_data == in_data is possible, make sure to not overwrite data
 * you might need later on! */
void
gst_channel_mix_mix_int (AudioConvertCtx * this,
    gint32 * in_data, gint32 * out_data, gint samples)
{
  gint in, out, n;
  gint64 res;
  gboolean backwards;
  gint inchannels, outchannels;
  gint32 *tmp = (gint32 *) this->tmp;

  g_return_if_fail (this->matrix != NULL);
  g_return_if_fail (this->tmp != NULL);

  inchannels = this->in.channels;
  outchannels = this->out.channels;
  backwards = outchannels > inchannels;

  /* FIXME: use orc here? */
  for (n = (backwards ? samples - 1 : 0); n < samples && n >= 0;
      backwards ? n-- : n++) {
    for (out = 0; out < outchannels; out++) {
      /* convert */
      res = 0;
      for (in = 0; in < inchannels; in++) {
        res += in_data[n * inchannels + in] * this->matrix[in][out];
      }

      /* clip (shouldn't we use doubles instead as intermediate format?) */
      if (res < G_MININT32)
        res = G_MININT32;
      else if (res > G_MAXINT32)
        res = G_MAXINT32;
      tmp[out] = res;
    }
    memcpy (&out_data[n * outchannels], this->tmp,
        sizeof (gint32) * outchannels);
  }
}

void
gst_channel_mix_mix_float (AudioConvertCtx * this,
    gdouble * in_data, gdouble * out_data, gint samples)
{
  gint in, out, n;
  gdouble res;
  gboolean backwards;
  gint inchannels, outchannels;
  gdouble *tmp = (gdouble *) this->tmp;

  g_return_if_fail (this->matrix != NULL);
  g_return_if_fail (this->tmp != NULL);

  inchannels = this->in.channels;
  outchannels = this->out.channels;
  backwards = outchannels > inchannels;

  /* FIXME: use liboil here? */
  for (n = (backwards ? samples - 1 : 0); n < samples && n >= 0;
      backwards ? n-- : n++) {
    for (out = 0; out < outchannels; out++) {
      /* convert */
      res = 0.0;
      for (in = 0; in < inchannels; in++) {
        res += in_data[n * inchannels + in] * this->matrix[in][out];
      }

      /* clip (shouldn't we use doubles instead as intermediate format?) */
      if (res < -1.0)
        res = -1.0;
      else if (res > 1.0)
        res = 1.0;
      tmp[out] = res;
    }
    memcpy (&out_data[n * outchannels], this->tmp,
        sizeof (gdouble) * outchannels);
  }
}
