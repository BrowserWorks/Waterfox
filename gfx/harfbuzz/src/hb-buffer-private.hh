/*
 * Copyright © 1998-2004  David Turner and Werner Lemberg
 * Copyright © 2004,2007,2009,2010  Red Hat, Inc.
 * Copyright © 2011,2012  Google, Inc.
 *
 *  This is part of HarfBuzz, a text shaping library.
 *
 * Permission is hereby granted, without written agreement and without
 * license or royalty fees, to use, copy, modify, and distribute this
 * software and its documentation for any purpose, provided that the
 * above copyright notice and the following two paragraphs appear in
 * all copies of this software.
 *
 * IN NO EVENT SHALL THE COPYRIGHT HOLDER BE LIABLE TO ANY PARTY FOR
 * DIRECT, INDIRECT, SPECIAL, INCIDENTAL, OR CONSEQUENTIAL DAMAGES
 * ARISING OUT OF THE USE OF THIS SOFTWARE AND ITS DOCUMENTATION, EVEN
 * IF THE COPYRIGHT HOLDER HAS BEEN ADVISED OF THE POSSIBILITY OF SUCH
 * DAMAGE.
 *
 * THE COPYRIGHT HOLDER SPECIFICALLY DISCLAIMS ANY WARRANTIES, INCLUDING,
 * BUT NOT LIMITED TO, THE IMPLIED WARRANTIES OF MERCHANTABILITY AND
 * FITNESS FOR A PARTICULAR PURPOSE.  THE SOFTWARE PROVIDED HEREUNDER IS
 * ON AN "AS IS" BASIS, AND THE COPYRIGHT HOLDER HAS NO OBLIGATION TO
 * PROVIDE MAINTENANCE, SUPPORT, UPDATES, ENHANCEMENTS, OR MODIFICATIONS.
 *
 * Red Hat Author(s): Owen Taylor, Behdad Esfahbod
 * Google Author(s): Behdad Esfahbod
 */

#ifndef HB_BUFFER_PRIVATE_HH
#define HB_BUFFER_PRIVATE_HH

#include "hb-private.hh"
#include "hb-object-private.hh"
#include "hb-unicode-private.hh"


#ifndef HB_BUFFER_MAX_LEN_FACTOR
#define HB_BUFFER_MAX_LEN_FACTOR 32
#endif
#ifndef HB_BUFFER_MAX_LEN_MIN
#define HB_BUFFER_MAX_LEN_MIN 8192
#endif
#ifndef HB_BUFFER_MAX_LEN_DEFAULT
#define HB_BUFFER_MAX_LEN_DEFAULT 0x3FFFFFFF /* Shaping more than a billion chars? Let us know! */
#endif

#ifndef HB_BUFFER_MAX_OPS_FACTOR
#define HB_BUFFER_MAX_OPS_FACTOR 64
#endif
#ifndef HB_BUFFER_MAX_OPS_MIN
#define HB_BUFFER_MAX_OPS_MIN 1024
#endif
#ifndef HB_BUFFER_MAX_OPS_DEFAULT
#define HB_BUFFER_MAX_OPS_DEFAULT 0x1FFFFFFF /* Shaping more than a billion operations? Let us know! */
#endif

static_assert ((sizeof (hb_glyph_info_t) == 20), "");
static_assert ((sizeof (hb_glyph_info_t) == sizeof (hb_glyph_position_t)), "");

HB_MARK_AS_FLAG_T (hb_buffer_flags_t);
HB_MARK_AS_FLAG_T (hb_buffer_serialize_flags_t);
HB_MARK_AS_FLAG_T (hb_buffer_diff_flags_t);

enum hb_buffer_scratch_flags_t {
  HB_BUFFER_SCRATCH_FLAG_DEFAULT			= 0x00000000u,
  HB_BUFFER_SCRATCH_FLAG_HAS_NON_ASCII			= 0x00000001u,
  HB_BUFFER_SCRATCH_FLAG_HAS_DEFAULT_IGNORABLES		= 0x00000002u,
  HB_BUFFER_SCRATCH_FLAG_HAS_SPACE_FALLBACK		= 0x00000004u,
  HB_BUFFER_SCRATCH_FLAG_HAS_GPOS_ATTACHMENT		= 0x00000008u,
  HB_BUFFER_SCRATCH_FLAG_HAS_UNSAFE_TO_BREAK		= 0x00000010u,
  HB_BUFFER_SCRATCH_FLAG_HAS_CGJ			= 0x00000020u,

  /* Reserved for complex shapers' internal use. */
  HB_BUFFER_SCRATCH_FLAG_COMPLEX0			= 0x01000000u,
  HB_BUFFER_SCRATCH_FLAG_COMPLEX1			= 0x02000000u,
  HB_BUFFER_SCRATCH_FLAG_COMPLEX2			= 0x04000000u,
  HB_BUFFER_SCRATCH_FLAG_COMPLEX3			= 0x08000000u,
};
HB_MARK_AS_FLAG_T (hb_buffer_scratch_flags_t);


/*
 * hb_buffer_t
 */

struct hb_buffer_t {
  hb_object_header_t header;
  ASSERT_POD ();

  /* Information about how the text in the buffer should be treated */
  hb_unicode_funcs_t *unicode; /* Unicode functions */
  hb_buffer_flags_t flags; /* BOT / EOT / etc. */
  hb_buffer_cluster_level_t cluster_level;
  hb_codepoint_t replacement; /* U+FFFD or something else. */
  hb_buffer_scratch_flags_t scratch_flags; /* Have space-fallback, etc. */
  unsigned int max_len; /* Maximum allowed len. */
  int max_ops; /* Maximum allowed operations. */

  /* Buffer contents */
  hb_buffer_content_type_t content_type;
  hb_segment_properties_t props; /* Script, language, direction */

  bool in_error; /* Allocation failed */
  bool have_output; /* Whether we have an output buffer going on */
  bool have_positions; /* Whether we have positions */

  unsigned int idx; /* Cursor into ->info and ->pos arrays */
  unsigned int len; /* Length of ->info and ->pos arrays */
  unsigned int out_len; /* Length of ->out array if have_output */

  unsigned int allocated; /* Length of allocated arrays */
  hb_glyph_info_t     *info;
  hb_glyph_info_t     *out_info;
  hb_glyph_position_t *pos;

  unsigned int serial;

  /* Text before / after the main buffer contents.
   * Always in Unicode, and ordered outward.
   * Index 0 is for "pre-context", 1 for "post-context". */
  static const unsigned int CONTEXT_LENGTH = 5;
  hb_codepoint_t context[2][CONTEXT_LENGTH];
  unsigned int context_len[2];

  /* Debugging API */
  hb_buffer_message_func_t message_func;
  void *message_data;
  hb_destroy_func_t message_destroy;

  /* Internal debugging. */
  /* The bits here reflect current allocations of the bytes in glyph_info_t's var1 and var2. */
#ifndef HB_NDEBUG
  uint8_t allocated_var_bits;
#endif


  /* Methods */

  inline void allocate_var (unsigned int start, unsigned int count)
  {
#ifndef HB_NDEBUG
    unsigned int end = start + count;
    assert (end <= 8);
    unsigned int bits = (1u<<end) - (1u<<start);
    assert (0 == (allocated_var_bits & bits));
    allocated_var_bits |= bits;
#endif
  }
  inline void deallocate_var (unsigned int start, unsigned int count)
  {
#ifndef HB_NDEBUG
    unsigned int end = start + count;
    assert (end <= 8);
    unsigned int bits = (1u<<end) - (1u<<start);
    assert (bits == (allocated_var_bits & bits));
    allocated_var_bits &= ~bits;
#endif
  }
  inline void assert_var (unsigned int start, unsigned int count)
  {
#ifndef HB_NDEBUG
    unsigned int end = start + count;
    assert (end <= 8);
    unsigned int bits = (1u<<end) - (1u<<start);
    assert (bits == (allocated_var_bits & bits));
#endif
  }
  inline void deallocate_var_all (void)
  {
#ifndef HB_NDEBUG
    allocated_var_bits = 0;
#endif
  }

  inline hb_glyph_info_t &cur (unsigned int i = 0) { return info[idx + i]; }
  inline hb_glyph_info_t cur (unsigned int i = 0) const { return info[idx + i]; }

  inline hb_glyph_position_t &cur_pos (unsigned int i = 0) { return pos[idx + i]; }
  inline hb_glyph_position_t cur_pos (unsigned int i = 0) const { return pos[idx + i]; }

  inline hb_glyph_info_t &prev (void) { return out_info[out_len ? out_len - 1 : 0]; }
  inline hb_glyph_info_t prev (void) const { return out_info[out_len ? out_len - 1 : 0]; }

  inline bool has_separate_output (void) const { return info != out_info; }


  HB_INTERNAL void reset (void);
  HB_INTERNAL void clear (void);

  inline unsigned int backtrack_len (void) const
  { return have_output? out_len : idx; }
  inline unsigned int lookahead_len (void) const
  { return len - idx; }
  inline unsigned int next_serial (void) { return serial++; }

  HB_INTERNAL void add (hb_codepoint_t  codepoint,
			unsigned int    cluster);
  HB_INTERNAL void add_info (const hb_glyph_info_t &glyph_info);

  HB_INTERNAL void reverse_range (unsigned int start, unsigned int end);
  HB_INTERNAL void reverse (void);
  HB_INTERNAL void reverse_clusters (void);
  HB_INTERNAL void guess_segment_properties (void);

  HB_INTERNAL void swap_buffers (void);
  HB_INTERNAL void remove_output (void);
  HB_INTERNAL void clear_output (void);
  HB_INTERNAL void clear_positions (void);

  HB_INTERNAL void replace_glyphs (unsigned int num_in,
				   unsigned int num_out,
				   const hb_codepoint_t *glyph_data);

  HB_INTERNAL void replace_glyph (hb_codepoint_t glyph_index);
  /* Makes a copy of the glyph at idx to output and replace glyph_index */
  HB_INTERNAL void output_glyph (hb_codepoint_t glyph_index);
  HB_INTERNAL void output_info (const hb_glyph_info_t &glyph_info);
  /* Copies glyph at idx to output but doesn't advance idx */
  HB_INTERNAL void copy_glyph (void);
  HB_INTERNAL bool move_to (unsigned int i); /* i is output-buffer index. */
  /* Copies glyph at idx to output and advance idx.
   * If there's no output, just advance idx. */
  inline void
  next_glyph (void)
  {
    if (have_output)
    {
      if (unlikely (out_info != info || out_len != idx)) {
	if (unlikely (!make_room_for (1, 1))) return;
	out_info[out_len] = info[idx];
      }
      out_len++;
    }

    idx++;
  }

  /* Advance idx without copying to output. */
  inline void skip_glyph (void) { idx++; }

  inline void reset_masks (hb_mask_t mask)
  {
    for (unsigned int j = 0; j < len; j++)
      info[j].mask = mask;
  }
  inline void add_masks (hb_mask_t mask)
  {
    for (unsigned int j = 0; j < len; j++)
      info[j].mask |= mask;
  }
  HB_INTERNAL void set_masks (hb_mask_t value, hb_mask_t mask,
			      unsigned int cluster_start, unsigned int cluster_end);

  inline void merge_clusters (unsigned int start, unsigned int end)
  {
    if (end - start < 2)
      return;
    merge_clusters_impl (start, end);
  }
  HB_INTERNAL void merge_clusters_impl (unsigned int start, unsigned int end);
  HB_INTERNAL void merge_out_clusters (unsigned int start, unsigned int end);
  /* Merge clusters for deleting current glyph, and skip it. */
  HB_INTERNAL void delete_glyph (void);

  inline void unsafe_to_break (unsigned int start,
			       unsigned int end)
  {
    if (end - start < 2)
      return;
    unsafe_to_break_impl (start, end);
  }
  HB_INTERNAL void unsafe_to_break_impl (unsigned int start, unsigned int end);
  HB_INTERNAL void unsafe_to_break_from_outbuffer (unsigned int start, unsigned int end);


  /* Internal methods */
  HB_INTERNAL bool enlarge (unsigned int size);

  inline bool ensure (unsigned int size)
  { return likely (!size || size < allocated) ? true : enlarge (size); }

  inline bool ensure_inplace (unsigned int size)
  { return likely (!size || size < allocated); }

  HB_INTERNAL bool make_room_for (unsigned int num_in, unsigned int num_out);
  HB_INTERNAL bool shift_forward (unsigned int count);

  typedef long scratch_buffer_t;
  HB_INTERNAL scratch_buffer_t *get_scratch_buffer (unsigned int *size);

  inline void clear_context (unsigned int side) { context_len[side] = 0; }

  HB_INTERNAL void sort (unsigned int start, unsigned int end, int(*compar)(const hb_glyph_info_t *, const hb_glyph_info_t *));

  inline bool messaging (void) { return unlikely (message_func); }
  inline bool message (hb_font_t *font, const char *fmt, ...) HB_PRINTF_FUNC(3, 4)
  {
    if (!messaging ())
      return true;
    va_list ap;
    va_start (ap, fmt);
    bool ret = message_impl (font, fmt, ap);
    va_end (ap);
    return ret;
  }
  HB_INTERNAL bool message_impl (hb_font_t *font, const char *fmt, va_list ap) HB_PRINTF_FUNC(3, 0);

  static inline void
  set_cluster (hb_glyph_info_t &inf, unsigned int cluster, unsigned int mask = 0)
  {
    if (inf.cluster != cluster)
    {
      if (mask & HB_GLYPH_FLAG_UNSAFE_TO_BREAK)
	inf.mask |= HB_GLYPH_FLAG_UNSAFE_TO_BREAK;
      else
	inf.mask &= ~HB_GLYPH_FLAG_UNSAFE_TO_BREAK;
    }
    inf.cluster = cluster;
  }

  inline int
  _unsafe_to_break_find_min_cluster (const hb_glyph_info_t *infos,
				     unsigned int start, unsigned int end,
				     unsigned int cluster) const
  {
    for (unsigned int i = start; i < end; i++)
      cluster = MIN<unsigned int> (cluster, infos[i].cluster);
    return cluster;
  }
  inline void
  _unsafe_to_break_set_mask (hb_glyph_info_t *infos,
			     unsigned int start, unsigned int end,
			     unsigned int cluster)
  {
    for (unsigned int i = start; i < end; i++)
      if (cluster != infos[i].cluster)
      {
	scratch_flags |= HB_BUFFER_SCRATCH_FLAG_HAS_UNSAFE_TO_BREAK;
	infos[i].mask |= HB_GLYPH_FLAG_UNSAFE_TO_BREAK;
      }
  }

  inline void
  unsafe_to_break_all (void)
  {
    unsafe_to_break_impl (0, len);
  }
  inline void
  safe_to_break_all (void)
  {
    for (unsigned int i = 0; i < len; i++)
      info[i].mask &= ~HB_GLYPH_FLAG_UNSAFE_TO_BREAK;
  }
};


/* Loop over clusters. Duplicated in foreach_syllable(). */
#define foreach_cluster(buffer, start, end) \
  for (unsigned int \
       _count = buffer->len, \
       start = 0, end = _count ? _next_cluster (buffer, 0) : 0; \
       start < _count; \
       start = end, end = _next_cluster (buffer, start))

static inline unsigned int
_next_cluster (hb_buffer_t *buffer, unsigned int start)
{
  hb_glyph_info_t *info = buffer->info;
  unsigned int count = buffer->len;

  unsigned int cluster = info[start].cluster;
  while (++start < count && cluster == info[start].cluster)
    ;

  return start;
}


#define HB_BUFFER_XALLOCATE_VAR(b, func, var) \
  b->func (offsetof (hb_glyph_info_t, var) - offsetof(hb_glyph_info_t, var1), \
	   sizeof (b->info[0].var))
#define HB_BUFFER_ALLOCATE_VAR(b, var)		HB_BUFFER_XALLOCATE_VAR (b, allocate_var,   var ())
#define HB_BUFFER_DEALLOCATE_VAR(b, var)	HB_BUFFER_XALLOCATE_VAR (b, deallocate_var, var ())
#define HB_BUFFER_ASSERT_VAR(b, var)		HB_BUFFER_XALLOCATE_VAR (b, assert_var,     var ())


#endif /* HB_BUFFER_PRIVATE_HH */
