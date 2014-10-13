/* GStreamer
 * Copyright (C) 2008 David Schleef <ds@entropywave.com>
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

#include <gst/gst.h>
#include <gst/math-compat.h>
#include "gstcms.h"

#include <stdio.h>
#include <string.h>
#include <math.h>


/* our simple CMS */

void
color_xyY_to_XYZ (Color * c)
{
  if (c->v[1] == 0) {
    c->v[0] = 0;
    c->v[1] = 0;
    c->v[2] = 0;
  } else {
    double X, Y, Z;
    X = c->v[0] * c->v[2] / c->v[1];
    Y = c->v[2];
    Z = (1.0 - c->v[0] - c->v[1]) * c->v[2] / c->v[1];
    c->v[0] = X;
    c->v[1] = Y;
    c->v[2] = Z;
  }
}

void
color_XYZ_to_xyY (Color * c)
{
  double d;
  d = c->v[0] + c->v[1] + c->v[2];
  if (d == 0) {
    c->v[0] = 0.3128;
    c->v[1] = 0.3290;
    c->v[2] = 0;
  } else {
    double x, y, Y;
    x = c->v[0] / d;
    y = c->v[1] / d;
    Y = c->v[1];
    c->v[0] = x;
    c->v[1] = y;
    c->v[2] = Y;
  }
}

void
color_set (Color * c, double x, double y, double z)
{
  c->v[0] = x;
  c->v[1] = y;
  c->v[2] = z;
}

void
color_matrix_set_identity (ColorMatrix * m)
{
  int i, j;

  for (i = 0; i < 4; i++) {
    for (j = 0; j < 4; j++) {
      m->m[i][j] = (i == j);
    }
  }
}

/* Prettyprint a 4x4 matrix @m@ */
void
color_matrix_dump (ColorMatrix * m)
{
  int i, j;

  printf ("[\n");
  for (i = 0; i < 4; i++) {
    printf ("  ");
    for (j = 0; j < 4; j++) {
      printf (" %8.5g", m->m[i][j]);
    }
    printf ("\n");
  }
  printf ("]\n");
}

/* Perform 4x4 matrix multiplication:
 *  - @dst@ = @a@ * @b@
 *  - @dst@ may be a pointer to @a@ andor @b@
 */
void
color_matrix_multiply (ColorMatrix * dst, ColorMatrix * a, ColorMatrix * b)
{
  ColorMatrix tmp;
  int i, j, k;

  for (i = 0; i < 4; i++) {
    for (j = 0; j < 4; j++) {
      double x = 0;
      for (k = 0; k < 4; k++) {
        x += a->m[i][k] * b->m[k][j];
      }
      tmp.m[i][j] = x;
    }
  }

  memcpy (dst, &tmp, sizeof (ColorMatrix));
}

void
color_matrix_apply (ColorMatrix * m, Color * dest, Color * src)
{
  int i;
  Color tmp;

  for (i = 0; i < 3; i++) {
    double x = 0;
    x += m->m[i][0] * src->v[0];
    x += m->m[i][1] * src->v[1];
    x += m->m[i][2] * src->v[2];
    x += m->m[i][3];
    tmp.v[i] = x;
  }
  memcpy (dest, &tmp, sizeof (tmp));
}

void
color_matrix_offset_components (ColorMatrix * m, double a1, double a2,
    double a3)
{
  ColorMatrix a;

  color_matrix_set_identity (&a);
  a.m[0][3] = a1;
  a.m[1][3] = a2;
  a.m[2][3] = a3;
  color_matrix_multiply (m, &a, m);
}

void
color_matrix_scale_components (ColorMatrix * m, double a1, double a2, double a3)
{
  ColorMatrix a;

  color_matrix_set_identity (&a);
  a.m[0][0] = a1;
  a.m[1][1] = a2;
  a.m[2][2] = a3;
  color_matrix_multiply (m, &a, m);
}

void
color_matrix_YCbCr_to_RGB (ColorMatrix * m, double Kr, double Kb)
{
  double Kg = 1.0 - Kr - Kb;
  ColorMatrix k = {
    {
          {1., 0., 2 * (1 - Kr), 0.},
          {1., -2 * Kb * (1 - Kb) / Kg, -2 * Kr * (1 - Kr) / Kg, 0.},
          {1., 2 * (1 - Kb), 0., 0.},
          {0., 0., 0., 1.},
        }
  };

  color_matrix_multiply (m, &k, m);
}

void
color_matrix_RGB_to_YCbCr (ColorMatrix * m, double Kr, double Kb)
{
  double Kg = 1.0 - Kr - Kb;
  ColorMatrix k;
  double x;

  k.m[0][0] = Kr;
  k.m[0][1] = Kg;
  k.m[0][2] = Kb;
  k.m[0][3] = 0;

  x = 1 / (2 * (1 - Kb));
  k.m[1][0] = -x * Kr;
  k.m[1][1] = -x * Kg;
  k.m[1][2] = x * (1 - Kb);
  k.m[1][3] = 0;

  x = 1 / (2 * (1 - Kr));
  k.m[2][0] = x * (1 - Kr);
  k.m[2][1] = -x * Kg;
  k.m[2][2] = -x * Kb;
  k.m[2][3] = 0;

  k.m[3][0] = 0;
  k.m[3][1] = 0;
  k.m[3][2] = 0;
  k.m[3][3] = 1;

  color_matrix_multiply (m, &k, m);
}

void
color_matrix_build_yuv_to_rgb_601 (ColorMatrix * dst)
{
  /*
   * At this point, everything is in YCbCr
   * All components are in the range [0,255]
   */
  color_matrix_set_identity (dst);

  /* offset required to get input video black to (0.,0.,0.) */
  color_matrix_offset_components (dst, -16, -128, -128);

  /* scale required to get input video black to (0.,0.,0.) */
  color_matrix_scale_components (dst, (1 / 219.0), (1 / 224.0), (1 / 224.0));

  /* colour matrix, YCbCr -> RGB */
  /* Requires Y in [0,1.0], Cb&Cr in [-0.5,0.5] */
  color_matrix_YCbCr_to_RGB (dst, 0.2990, 0.1140);      /* SD */

  /*
   * We are now in RGB space
   */

#if 0
  /* scale to output range. */
  color_matrix_scale_components (dst, 255.0, 255.0, 255.0);
#endif
}

void
color_matrix_build_bt709_to_bt601 (ColorMatrix * dst)
{
  color_matrix_set_identity (dst);

  /* offset required to get input video black to (0.,0.,0.) */
  color_matrix_offset_components (dst, -16, -128, -128);

  /* scale required to get input video black to (0.,0.,0.) */
  color_matrix_scale_components (dst, (1 / 219.0), (1 / 224.0), (1 / 224.0));

  /* colour matrix, YCbCr -> RGB */
  /* Requires Y in [0,1.0], Cb&Cr in [-0.5,0.5] */
  color_matrix_YCbCr_to_RGB (dst, 0.2126, 0.0722);      /* HD */

  color_matrix_RGB_to_YCbCr (dst, 0.2990, 0.1140);      /* SD */

  color_matrix_scale_components (dst, 219.0, 224.0, 224.0);

  color_matrix_offset_components (dst, 16, 128, 128);
}

void
color_matrix_build_rgb_to_yuv_601 (ColorMatrix * dst)
{
  color_matrix_set_identity (dst);

  color_matrix_RGB_to_YCbCr (dst, 0.2990, 0.1140);      /* SD */

  color_matrix_scale_components (dst, 219.0, 224.0, 224.0);

  color_matrix_offset_components (dst, 16, 128, 128);

  {
    Color c;
    int i;
    for (i = 7; i >= 0; i--) {
      color_set (&c, (i & 2) ? 0.75 : 0.0, (i & 4) ? 0.75 : 0.0,
          (i & 1) ? 0.75 : 0.0);
      color_matrix_apply (dst, &c, &c);
      g_print ("  { %g, %g, %g },\n", rint (c.v[0]), rint (c.v[1]),
          rint (c.v[2]));
    }
    color_set (&c, -0.075, -0.075, -0.075);
    color_matrix_apply (dst, &c, &c);
    g_print ("  { %g, %g, %g },\n", rint (c.v[0]), rint (c.v[1]),
        rint (c.v[2]));
    color_set (&c, 0.075, 0.075, 0.075);
    color_matrix_apply (dst, &c, &c);
    g_print ("  { %g, %g, %g },\n", rint (c.v[0]), rint (c.v[1]),
        rint (c.v[2]));
  }
}

void
color_matrix_invert (ColorMatrix * m)
{
  ColorMatrix tmp;
  int i, j;
  double det;

  color_matrix_set_identity (&tmp);
  for (j = 0; j < 3; j++) {
    for (i = 0; i < 3; i++) {
      tmp.m[j][i] =
          m->m[(i + 1) % 3][(j + 1) % 3] * m->m[(i + 2) % 3][(j + 2) % 3] -
          m->m[(i + 1) % 3][(j + 2) % 3] * m->m[(i + 2) % 3][(j + 1) % 3];
    }
  }
  det =
      tmp.m[0][0] * m->m[0][0] + tmp.m[0][1] * m->m[1][0] +
      tmp.m[0][2] * m->m[2][0];
  for (j = 0; j < 3; j++) {
    for (i = 0; i < 3; i++) {
      tmp.m[i][j] /= det;
    }
  }
  memcpy (m, &tmp, sizeof (tmp));
}

void
color_matrix_copy (ColorMatrix * dest, ColorMatrix * src)
{
  memcpy (dest, src, sizeof (ColorMatrix));
}

void
color_matrix_transpose (ColorMatrix * m)
{
  int i, j;
  ColorMatrix tmp;

  color_matrix_set_identity (&tmp);
  for (i = 0; i < 3; i++) {
    for (j = 0; j < 3; j++) {
      tmp.m[i][j] = m->m[j][i];
    }
  }
  memcpy (m, &tmp, sizeof (ColorMatrix));
}

void
color_matrix_build_XYZ (ColorMatrix * dst,
    double rx, double ry,
    double gx, double gy, double bx, double by, double wx, double wy)
{
  Color r, g, b, w, scale;
  ColorMatrix m;

  color_set (&r, rx, ry, 1.0);
  color_xyY_to_XYZ (&r);
  color_set (&g, gx, gy, 1.0);
  color_xyY_to_XYZ (&g);
  color_set (&b, bx, by, 1.0);
  color_xyY_to_XYZ (&b);
  color_set (&w, wx, wy, 1.0);
  color_xyY_to_XYZ (&w);

  color_matrix_set_identity (dst);

  dst->m[0][0] = r.v[0];
  dst->m[0][1] = r.v[1];
  dst->m[0][2] = r.v[2];
  dst->m[1][0] = g.v[0];
  dst->m[1][1] = g.v[1];
  dst->m[1][2] = g.v[2];
  dst->m[2][0] = b.v[0];
  dst->m[2][1] = b.v[1];
  dst->m[2][2] = b.v[2];

  color_matrix_dump (dst);
  color_matrix_copy (&m, dst);
  color_matrix_invert (&m);
  color_matrix_dump (&m);

  color_matrix_transpose (&m);
  color_matrix_apply (&m, &scale, &w);
  g_print ("%g %g %g\n", scale.v[0], scale.v[1], scale.v[2]);

  dst->m[0][0] = r.v[0] * scale.v[0];
  dst->m[0][1] = r.v[1] * scale.v[0];
  dst->m[0][2] = r.v[2] * scale.v[0];
  dst->m[1][0] = g.v[0] * scale.v[1];
  dst->m[1][1] = g.v[1] * scale.v[1];
  dst->m[1][2] = g.v[2] * scale.v[1];
  dst->m[2][0] = b.v[0] * scale.v[2];
  dst->m[2][1] = b.v[1] * scale.v[2];
  dst->m[2][2] = b.v[2] * scale.v[2];

  color_matrix_transpose (dst);
  color_matrix_dump (dst);

  color_set (&scale, 1, 1, 1);
  color_matrix_apply (dst, &scale, &scale);
  color_XYZ_to_xyY (&scale);
  g_print ("white %g %g %g\n", scale.v[0], scale.v[1], scale.v[2]);

}

void
color_matrix_build_rgb_to_XYZ_601 (ColorMatrix * dst)
{
  /* SMPTE C primaries, SMPTE 170M-2004 */
  color_matrix_build_XYZ (dst,
      0.630, 0.340, 0.310, 0.595, 0.155, 0.070, 0.3127, 0.3290);
#if 0
  /* NTSC 1953 primaries, SMPTE 170M-2004 */
  color_matrix_build_XYZ (dst,
      0.67, 0.33, 0.21, 0.71, 0.14, 0.08, 0.3127, 0.3290);
#endif
}

void
color_matrix_build_XYZ_to_rgb_709 (ColorMatrix * dst)
{
  /* Rec. ITU-R BT.709-5 */
  color_matrix_build_XYZ (dst,
      0.640, 0.330, 0.300, 0.600, 0.150, 0.060, 0.3127, 0.3290);
}

void
color_matrix_build_XYZ_to_rgb_dell (ColorMatrix * dst)
{
  /* Dell monitor */
#if 1
  color_matrix_build_XYZ (dst,
      0.662, 0.329, 0.205, 0.683, 0.146, 0.077, 0.3135, 0.3290);
#endif
#if 0
  color_matrix_build_XYZ (dst,
      0.630, 0.340, 0.310, 0.595, 0.155, 0.070, 0.3127, 0.3290);
#endif
  color_matrix_invert (dst);
}

void
color_transfer_function_apply (Color * dest, Color * src)
{
  int i;

  for (i = 0; i < 3; i++) {
    if (src->v[i] < 0.0812) {
      dest->v[i] = src->v[i] / 4.500;
    } else {
      dest->v[i] = pow (src->v[i] + 0.099, 1 / 0.4500);
    }
  }
}

void
color_transfer_function_unapply (Color * dest, Color * src)
{
  int i;

  for (i = 0; i < 3; i++) {
    if (src->v[i] < 0.0812 / 4.500) {
      dest->v[i] = src->v[i] * 4.500;
    } else {
      dest->v[i] = pow (src->v[i], 0.4500) - 0.099;
    }
  }
}

void
color_gamut_clamp (Color * dest, Color * src)
{
  dest->v[0] = CLAMP (src->v[0], 0.0, 1.0);
  dest->v[1] = CLAMP (src->v[1], 0.0, 1.0);
  dest->v[2] = CLAMP (src->v[2], 0.0, 1.0);
}

#if 0
static guint8 *
get_color_transform_table (void)
{
  static guint8 *color_transform_table = NULL;

#if 1
  if (!color_transform_table) {
    ColorMatrix bt601_to_rgb;
    ColorMatrix bt601_to_yuv;
    ColorMatrix bt601_rgb_to_XYZ;
    ColorMatrix dell_XYZ_to_rgb;
    guint8 *table_y;
    guint8 *table_u;
    guint8 *table_v;
    int y, u, v;

    color_matrix_build_yuv_to_rgb_601 (&bt601_to_rgb);
    color_matrix_build_rgb_to_yuv_601 (&bt601_to_yuv);
    color_matrix_build_rgb_to_XYZ_601 (&bt601_rgb_to_XYZ);
    color_matrix_build_XYZ_to_rgb_dell (&dell_XYZ_to_rgb);

    color_transform_table = g_malloc (0x1000000 * 3);

    table_y = COG_OFFSET (color_transform_table, 0 * 0x1000000);
    table_u = COG_OFFSET (color_transform_table, 1 * 0x1000000);
    table_v = COG_OFFSET (color_transform_table, 2 * 0x1000000);

    for (y = 0; y < 256; y++) {
      for (u = 0; u < 256; u++) {
        for (v = 0; v < 256; v++) {
          Color c;

          c.v[0] = y;
          c.v[1] = u;
          c.v[2] = v;
          color_matrix_apply (&bt601_to_rgb, &c, &c);
          color_gamut_clamp (&c, &c);
          color_transfer_function_apply (&c, &c);
          color_matrix_apply (&bt601_rgb_to_XYZ, &c, &c);
          color_matrix_apply (&dell_XYZ_to_rgb, &c, &c);
          color_transfer_function_unapply (&c, &c);
          color_gamut_clamp (&c, &c);
          color_matrix_apply (&bt601_to_yuv, &c, &c);

          table_y[(y << 16) | (u << 8) | (v)] = rint (c.v[0]);
          table_u[(y << 16) | (u << 8) | (v)] = rint (c.v[1]);
          table_v[(y << 16) | (u << 8) | (v)] = rint (c.v[2]);
        }
      }
    }
  }
#endif
#if 0
  if (!color_transform_table) {
    ColorMatrix bt709_to_bt601;
    guint8 *table_y;
    guint8 *table_u;
    guint8 *table_v;
    int y, u, v;

    color_matrix_build_bt709_to_bt601 (&bt709_to_bt601);

    color_transform_table = g_malloc (0x1000000 * 3);

    table_y = COG_OFFSET (color_transform_table, 0 * 0x1000000);
    table_u = COG_OFFSET (color_transform_table, 1 * 0x1000000);
    table_v = COG_OFFSET (color_transform_table, 2 * 0x1000000);

    for (y = 0; y < 256; y++) {
      for (u = 0; u < 256; u++) {
        for (v = 0; v < 256; v++) {
          Color c;

          c.v[0] = y;
          c.v[1] = u;
          c.v[2] = v;
          color_matrix_apply (&bt709_to_bt601, &c, &c);

          table_y[(y << 16) | (u << 8) | (v)] = rint (c.v[0]);
          table_u[(y << 16) | (u << 8) | (v)] = rint (c.v[1]);
          table_v[(y << 16) | (u << 8) | (v)] = rint (c.v[2]);
        }
      }
    }
  }
#endif

  return color_transform_table;
}
#endif
