/* GStreamer
 * Copyright (C) <2007> Sebastian Dröge <slomo@circular-chaos.org>
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

/**
 * SECTION:gstfft
 * @short_description: General FFT functions and declarations
 * 
 * This library includes general definitions and functions, useful for
 * all typed FFT classes.
 */
#ifdef HAVE_CONFIG_H
#include "config.h"
#endif

#include <glib.h>

#include "gstfft.h"
#include "kiss_fft_s16.h"

/**
 * gst_fft_next_fast_length:
 * @n: Number for which the next fast length should be returned
 *
 * Returns the next number to @n that is entirely a product
 * of 2, 3 and 5. Using this as the @len parameter for
 * the different GstFFT types will provide the best performance.
 *
 * Returns: the next fast FFT length.
 *
 */
gint
gst_fft_next_fast_length (gint n)
{
  gint half = (n + 1) / 2;

  /* It's the same for all data types so call the s16
   * version */

  /* The real FFT needs an even length so calculate that */
  return 2 * kiss_fft_s16_next_fast_size (half);
}
