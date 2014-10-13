/*
 * GStreamer
 * Copyright (c) 2002 Tom Barry  All rights reserved.
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
 * Relicensed for GStreamer from GPL to LGPL with permit from Tom Barry.
 * See: http://bugzilla.gnome.org/show_bug.cgi?id=163578
 */


#ifndef TopFirst
#define TopFirst IsOdd
#endif

#ifdef SEFUNC
#undef SEFUNC
#endif

#if defined(IS_MMXEXT)
#define SEFUNC(x) Search_Effort_MMXEXT_##x(int src_pitch, int dst_pitch, int rowsize, const unsigned char *pWeaveSrc, const unsigned char *pWeaveSrcP, unsigned char *pWeaveDest, int IsOdd, const unsigned char *pCopySrc, const unsigned char *pCopySrcP, int FldHeight)
#elif defined(IS_3DNOW)
#define SEFUNC(x) Search_Effort_3DNOW_##x(int src_pitch, int dst_pitch, int rowsize, const unsigned char *pWeaveSrc, const unsigned char *pWeaveSrcP, unsigned char *pWeaveDest, int IsOdd, const unsigned char *pCopySrc, const unsigned char *pCopySrcP, int FldHeight)
#elif defined(IS_MMX)
#define SEFUNC(x) Search_Effort_MMX_##x(int src_pitch, int dst_pitch, int rowsize, const unsigned char *pWeaveSrc, const unsigned char *pWeaveSrcP, unsigned char *pWeaveDest, int IsOdd, const unsigned char *pCopySrc, const unsigned char *pCopySrcP, int FldHeight)
#else
#define SEFUNC(x) Search_Effort_C_##x(int src_pitch, int dst_pitch, int rowsize, const unsigned char *pWeaveSrc, const unsigned char *pWeaveSrcP, unsigned char *pWeaveDest, int IsOdd, const unsigned char *pCopySrc, const unsigned char *pCopySrcP, int FldHeight)
#endif

#include "TomsMoCompAll2.inc"

#define USE_STRANGE_BOB

#include "TomsMoCompAll2.inc"

#undef USE_STRANGE_BOB

#undef SEFUNC
#if defined(IS_MMXEXT)
#define SEFUNC(x) Search_Effort_MMXEXT_##x(src_pitch, dst_pitch, rowsize, pWeaveSrc, pWeaveSrcP, pWeaveDest, IsOdd, pCopySrc, pCopySrcP, FldHeight)
#elif defined(IS_3DNOW)
#define SEFUNC(x) Search_Effort_3DNOW_##x(src_pitch, dst_pitch, rowsize, pWeaveSrc, pWeaveSrcP, pWeaveDest, IsOdd, pCopySrc, pCopySrcP, FldHeight)
#elif defined(IS_MMX)
#define SEFUNC(x) Search_Effort_MMX_##x(src_pitch, dst_pitch, rowsize, pWeaveSrc, pWeaveSrcP, pWeaveDest, IsOdd, pCopySrc, pCopySrcP, FldHeight)
#else
#define SEFUNC(x) Search_Effort_C_##x(src_pitch, dst_pitch, rowsize, pWeaveSrc, pWeaveSrcP, pWeaveDest, IsOdd, pCopySrc, pCopySrcP, FldHeight)
#endif

static void FUNCT_NAME(GstDeinterlaceMethod *d_method,
	const GstDeinterlaceField* history, guint history_count,
	GstVideoFrame *outframe, int cur_field_idx)
{
  GstDeinterlaceMethodTomsMoComp *self = GST_DEINTERLACE_METHOD_TOMSMOCOMP (d_method);
  glong SearchEffort = self->search_effort;
  gint UseStrangeBob = self->strange_bob;
  gint IsOdd;
  const guint8 *pWeaveSrc;
  const guint8 *pWeaveSrcP;
  guint8 *pWeaveDest;
  const guint8 *pCopySrc;
  const guint8 *pCopySrcP;
  guint8 *pCopyDest;
  gint src_pitch;
  gint dst_pitch;
  gint rowsize;
  gint FldHeight;

  if (cur_field_idx + 2 > history_count || cur_field_idx < 1) {
    GstDeinterlaceMethod *backup_method;
    
    backup_method = g_object_new (gst_deinterlace_method_linear_get_type(),
        NULL);

    gst_deinterlace_method_setup (backup_method, d_method->vinfo);
    gst_deinterlace_method_deinterlace_frame (backup_method,
        history, history_count, outframe, cur_field_idx);

    g_object_unref (backup_method);
    return;
  }

  /* double stride do address just every odd/even scanline */
  src_pitch = GST_VIDEO_FRAME_PLANE_STRIDE (outframe, 0) * 2;
  dst_pitch = GST_VIDEO_FRAME_PLANE_STRIDE (outframe, 0);
  rowsize = GST_VIDEO_FRAME_PLANE_STRIDE (outframe, 0);

  FldHeight = GST_VIDEO_INFO_HEIGHT (self->parent.vinfo) / 2;

  pCopySrc   = GST_VIDEO_FRAME_PLANE_DATA (history[history_count-1].frame, 0);
  if (history[history_count - 1].flags & PICTURE_INTERLACED_BOTTOM)
    pCopySrc += GST_VIDEO_FRAME_PLANE_STRIDE (history[history_count-1].frame, 0);
  pCopySrcP  = GST_VIDEO_FRAME_PLANE_DATA (history[history_count-3].frame, 0);
  if (history[history_count - 3].flags & PICTURE_INTERLACED_BOTTOM)
    pCopySrcP += GST_VIDEO_FRAME_PLANE_STRIDE (history[history_count-3].frame, 0);
  pWeaveSrc  = GST_VIDEO_FRAME_PLANE_DATA (history[history_count-2].frame, 0);
  if (history[history_count - 2].flags & PICTURE_INTERLACED_BOTTOM)
    pWeaveSrc += GST_VIDEO_FRAME_PLANE_STRIDE (history[history_count-2].frame, 0);
  pWeaveSrcP = GST_VIDEO_FRAME_PLANE_DATA (history[history_count-4].frame, 0);
  if (history[history_count - 4].flags & PICTURE_INTERLACED_BOTTOM)
    pWeaveSrcP += GST_VIDEO_FRAME_PLANE_STRIDE (history[history_count-4].frame, 0);

  /* use bottom field and interlace top field */
  if (history[history_count-2].flags == PICTURE_INTERLACED_BOTTOM) {
    IsOdd      = 1;

    // if we have an odd field we copy an even field and weave an odd field
    pCopyDest = GST_VIDEO_FRAME_PLANE_DATA (outframe, 0);
    pWeaveDest = pCopyDest + dst_pitch;
  }
  /* do it vice verca */
  else {

    IsOdd      = 0;
    // if we have an even field we copy an odd field and weave an even field
    pCopyDest = (guint8 *) GST_VIDEO_FRAME_PLANE_DATA (outframe, 0) + dst_pitch;
    pWeaveDest = GST_VIDEO_FRAME_PLANE_DATA (outframe, 0);
  }

  
  // copy 1st and last weave lines 
  Fieldcopy(pWeaveDest, pCopySrc, rowsize,		
	    1, dst_pitch*2, src_pitch);
  Fieldcopy(pWeaveDest+(FldHeight-1)*dst_pitch*2,
	    pCopySrc+(FldHeight-1)*src_pitch, rowsize, 
	    1, dst_pitch*2, src_pitch);
  
#ifdef USE_VERTICAL_FILTER
  // Vertical Filter currently not implemented for DScaler !!
  // copy 1st and last lines the copy field
  Fieldcopy(pCopyDest, pCopySrc, rowsize, 
	    1, dst_pitch*2, src_pitch);
  Fieldcopy(pCopyDest+(FldHeight-1)*dst_pitch*2,
	    pCopySrc+(FldHeight-1)*src_pitch, rowsize, 
	    1, dst_pitch*2, src_pitch);
#else
  
  // copy all of the copy field
  Fieldcopy(pCopyDest, pCopySrc, rowsize, 
	    FldHeight, dst_pitch*2, src_pitch);
#endif	
  // then go fill in the hard part, being variously lazy depending upon
  // SearchEffort

  if(!UseStrangeBob) {
    if (SearchEffort == 0)
      {
	SEFUNC(0);
      }
    else if (SearchEffort <= 1)
      {
	SEFUNC(1);
      }
    /*	else if (SearchEffort <= 2)
	{
	SEFUNC(2);
	}
    */
    else if (SearchEffort <= 3)
      {
	SEFUNC(3);
      }
    else if (SearchEffort <= 5)
      {
	SEFUNC(5);
      }
    else if (SearchEffort <= 9)
      {
	SEFUNC(9);
      }
    else if (SearchEffort <= 11)
      {
	SEFUNC(11);
      }
    else if (SearchEffort <= 13)
      {
	SEFUNC(13);
      }
    else if (SearchEffort <= 15)
      {
	SEFUNC(15);
      }
    else if (SearchEffort <= 19)
      {
	SEFUNC(19);
      }
    else if (SearchEffort <= 21)
      {
	SEFUNC(21);
      }
    else 
      {
	SEFUNC(Max);
      }
  }
  else
    {
      if (SearchEffort == 0)
	{
	  SEFUNC(0SB);
	}
      else if (SearchEffort <= 1)
	{
	  SEFUNC(1SB);
	}
      /*	else if (SearchEffort <= 2)
		{
		SEFUNC(2SB);
		}
      */
      else if (SearchEffort <= 3)
	{
	  SEFUNC(3SB);
	}
      else if (SearchEffort <= 5)
	{
	  SEFUNC(5SB);
	}
      else if (SearchEffort <= 9)
	{
	  SEFUNC(9SB);
	}
      else if (SearchEffort <= 11)
	{
	  SEFUNC(11SB);
	}
      else if (SearchEffort <= 13)
	{
	  SEFUNC(13SB);
	}
      else if (SearchEffort <= 15)
	{
	  SEFUNC(15SB);
	}
      else if (SearchEffort <= 19)
	{
	  SEFUNC(19SB);
	}
      else if (SearchEffort <= 21)
	{
	  SEFUNC(21SB);
	}
      else 
	{
	  SEFUNC(MaxSB);
	}
    }

#if defined(BUILD_X86_ASM) && !defined(IS_C)
  __asm__ __volatile__("emms");
#endif
}
