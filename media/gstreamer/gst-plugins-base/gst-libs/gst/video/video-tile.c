/* GStreamer
 * Copyright (C) <2013> Wim Taymans <wim.taymans@gmail.com>
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

#include <gst/video/video-tile.h>

/**
 * gst_video_tile_get_index:
 * @mode: a #GstVideoTileMode
 * @x: x coordinate
 * @y: y coordinate
 * @x_tiles: number of horizintal tiles
 * @y_tiles: number of vertical tiles
 *
 * Get the tile index of the tile at coordinates @x and @y in the tiled
 * image of @x_tiles by @y_tiles.
 *
 * Use this method when @mode is of type %GST_VIDEO_TILE_MODE_INDEXED.
 *
 * Returns: the index of the tile at @x and @y in the tiled image of
 *   @x_tiles by @y_tiles.
 *
 * Since: 1.4
 */
guint
gst_video_tile_get_index (GstVideoTileMode mode, gint x, gint y,
    gint x_tiles, gint y_tiles)
{
  gsize offset;

  g_return_val_if_fail (GST_VIDEO_TILE_MODE_IS_INDEXED (mode), 0);

  switch (mode) {
    case GST_VIDEO_TILE_MODE_ZFLIPZ_2X2:
      /* Due to the zigzag pattern we know that tiles are numbered like:
       * (see http://linuxtv.org/downloads/v4l-dvb-apis/re31.html)
       *
       *         |             Column (x)
       *         |   0    1    2    3    4    5    6    7
       *  -------|---------------------------------------
       *       0 |   0    1    6    7    8    9   14   15
       *    R  1 |   2    3    4    5   10   11   12   13
       *    o  2 |  16   17   22   23   24   25   30   31
       *    w  3 |  18   19   20   21   26   27   28   29
       *       4 |  32   33   38   39   40   41   46   47
       *   (y) 5 |  34   35   36   37   42   43   44   45
       *       6 |  48   49   50   51   52   53   54   55
       *
       * From this we can see that:
       *
       * For even rows:
       * - The first block in a row is always mapped to memory block 'y * width'.
       * - For all even rows, except for the last one when 'y' is odd, from the first
       *   block number an offset is then added to obtain the block number for
       *   the other blocks in the row. The offset is 'x' plus the corresponding
       *   number in the series [0, 0, 4, 4, 4, 4, 8, 8, 8, 8, 12, ...], which can be
       *   expressed as 'GST_ROUND_DOWN_4 (x + 2)'.
       *       f(x,y,width,height) = y * width + x + GST_ROUND_DOWN_4 (x + 2)
       *
       * - For the last row when 'y' is odd the offset is simply 'x'.
       *       f(x,y,width,height) = y * width + x
       * - Note that 'y' is even, so 'GST_ROUNDOWN_2 (y) == y' in this case
       *
       *  For odd rows:
       * - The first block in the row is always mapped to memory block
       *   'GST_ROUND_DOWN_2(y) * width + 2'.
       * - From the first block number an offset is then added to obtain the block
       *   number for the other blocks in the row. The offset is 'x' plus the
       *   corresponding number in the series [0, 0, 0, 0, 4, 4, 4, 4, 8, 8, 8, 8, 12, ...],
       *   which can be  expressed as GST_ROUND_DOWN_4 (x).
       *       f(x,y,width,height) = GST_ROUND_DOWN_2 (y) * width + bx 2 + GST_ROUND_DOWN_4 (x)
       */
      /* Common to all cases */
      offset = GST_ROUND_DOWN_2 (y) * x_tiles + x;

      if (y & 1) {
        /* For odd row */
        offset += 2 + GST_ROUND_DOWN_4 (x);
      } else if ((y_tiles & 1) == 0 || y != (y_tiles - 1)) {
        /* For even row except for the last row when odd height */
        offset += GST_ROUND_DOWN_4 (x + 2);
      }
      break;
    default:
      offset = 0;
      break;
  }
  return offset;
}
