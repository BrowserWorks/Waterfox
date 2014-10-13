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

#ifndef _GST_CMS_H_
#define _GST_CMS_H_

#include <gst/gst.h>

G_BEGIN_DECLS

typedef struct _Color Color;
typedef struct _ColorMatrix ColorMatrix;

struct _Color
{
  double v[3];
};

struct _ColorMatrix
{
  double m[4][4];
};

void color_xyY_to_XYZ (Color * c);
void color_XYZ_to_xyY (Color * c);
void color_set (Color * c, double x, double y, double z);
void color_matrix_set_identity (ColorMatrix * m);
void color_matrix_dump (ColorMatrix * m);
void color_matrix_multiply (ColorMatrix * dst, ColorMatrix * a, ColorMatrix * b);
void color_matrix_apply (ColorMatrix * m, Color * dest, Color * src);
void color_matrix_offset_components (ColorMatrix * m, double a1, double a2,
    double a3);
void color_matrix_scale_components (ColorMatrix * m, double a1, double a2, double a3);
void color_matrix_YCbCr_to_RGB (ColorMatrix * m, double Kr, double Kb);
void color_matrix_RGB_to_YCbCr (ColorMatrix * m, double Kr, double Kb);
void color_matrix_build_yuv_to_rgb_601 (ColorMatrix * dst);
void color_matrix_build_bt709_to_bt601 (ColorMatrix * dst);
void color_matrix_build_rgb_to_yuv_601 (ColorMatrix * dst);
void color_matrix_invert (ColorMatrix * m);
void color_matrix_copy (ColorMatrix * dest, ColorMatrix * src);
void color_matrix_transpose (ColorMatrix * m);
void color_matrix_build_XYZ (ColorMatrix * dst,
    double rx, double ry,
    double gx, double gy, double bx, double by, double wx, double wy);
void color_matrix_build_rgb_to_XYZ_601 (ColorMatrix * dst);
void color_matrix_build_XYZ_to_rgb_709 (ColorMatrix * dst);
void color_matrix_build_XYZ_to_rgb_dell (ColorMatrix * dst);
void color_transfer_function_apply (Color * dest, Color * src);
void color_transfer_function_unapply (Color * dest, Color * src);
void color_gamut_clamp (Color * dest, Color * src);

G_END_DECLS

#endif

