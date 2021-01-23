/* -*- Mode: c; tab-width: 8; c-basic-offset: 4; indent-tabs-mode: t; -*- */
/* cairo - a vector graphics library with display and print output
 *
 * Copyright © 2002 University of Southern California
 * Copyright © 2005 Red Hat, Inc.
 *
 * This library is free software; you can redistribute it and/or
 * modify it either under the terms of the GNU Lesser General Public
 * License version 2.1 as published by the Free Software Foundation
 * (the "LGPL") or, at your option, under the terms of the Mozilla
 * Public License Version 1.1 (the "MPL"). If you do not alter this
 * notice, a recipient may use your version of this file under either
 * the MPL or the LGPL.
 *
 * You should have received a copy of the LGPL along with this library
 * in the file COPYING-LGPL-2.1; if not, write to the Free Software
 * Foundation, Inc., 51 Franklin Street, Suite 500, Boston, MA 02110-1335, USA
 * You should have received a copy of the MPL along with this library
 * in the file COPYING-MPL-1.1
 *
 * The contents of this file are subject to the Mozilla Public License
 * Version 1.1 (the "License"); you may not use this file except in
 * compliance with the License. You may obtain a copy of the License at
 * http://www.mozilla.org/MPL/
 *
 * This software is distributed on an "AS IS" basis, WITHOUT WARRANTY
 * OF ANY KIND, either express or implied. See the LGPL or the MPL for
 * the specific language governing rights and limitations.
 *
 * The Original Code is the cairo graphics library.
 *
 * The Initial Developer of the Original Code is University of Southern
 * California.
 *
 * Contributor(s):
 *	Carl D. Worth <cworth@cworth.org>
 */

#ifndef CAIRO_TYPES_PRIVATE_H
#define CAIRO_TYPES_PRIVATE_H

#include "cairo.h"
#include "cairo-fixed-type-private.h"
#include "cairo-list-private.h"
#include "cairo-reference-count-private.h"

/**
 * SECTION:cairo-types
 * @Title: Types
 * @Short_Description: Generic data types
 *
 * This section lists generic data types used in the cairo API.
 */

typedef struct _cairo_array cairo_array_t;
typedef struct _cairo_backend cairo_backend_t;
typedef struct _cairo_boxes_t cairo_boxes_t;
typedef struct _cairo_cache cairo_cache_t;
typedef struct _cairo_composite_rectangles cairo_composite_rectangles_t;
typedef struct _cairo_clip cairo_clip_t;
typedef struct _cairo_clip_path cairo_clip_path_t;
typedef struct _cairo_color cairo_color_t;
typedef struct _cairo_color_stop cairo_color_stop_t;
typedef struct _cairo_device_backend cairo_device_backend_t;
typedef struct _cairo_font_face_backend     cairo_font_face_backend_t;
typedef struct _cairo_gstate cairo_gstate_t;
typedef struct _cairo_hash_entry cairo_hash_entry_t;
typedef struct _cairo_hash_table cairo_hash_table_t;
typedef struct _cairo_image_surface cairo_image_surface_t;
typedef struct _cairo_mime_data cairo_mime_data_t;
typedef struct _cairo_observer cairo_observer_t;
typedef struct _cairo_output_stream cairo_output_stream_t;
typedef struct _cairo_paginated_surface_backend cairo_paginated_surface_backend_t;
typedef struct _cairo_path_fixed cairo_path_fixed_t;
typedef struct _cairo_rectangle_int16 cairo_glyph_size_t;
typedef struct _cairo_scaled_font_backend   cairo_scaled_font_backend_t;
typedef struct _cairo_scaled_font_subsets cairo_scaled_font_subsets_t;
typedef struct _cairo_solid_pattern cairo_solid_pattern_t;
typedef struct _cairo_surface_backend cairo_surface_backend_t;
typedef struct _cairo_surface_snapshot cairo_surface_snapshot_t;
typedef struct _cairo_surface_subsurface cairo_surface_subsurface_t;
typedef struct _cairo_surface_wrapper cairo_surface_wrapper_t;
typedef struct _cairo_unscaled_font_backend cairo_unscaled_font_backend_t;
typedef struct _cairo_xlib_screen_info cairo_xlib_screen_info_t;

typedef cairo_array_t cairo_user_data_array_t;

struct _cairo_observer {
    cairo_list_t link;
    void (*callback) (cairo_observer_t *self, void *arg);
};

/**
 * cairo_hash_entry_t:
 *
 * A #cairo_hash_entry_t contains both a key and a value for
 * #cairo_hash_table_t. User-derived types for #cairo_hash_entry_t must
 * be type-compatible with this structure (eg. they must have an
 * unsigned long as the first parameter. The easiest way to get this
 * is to use:
 *
 * 	typedef _my_entry {
 *	    cairo_hash_entry_t base;
 *	    ... Remainder of key and value fields here ..
 *	} my_entry_t;
 *
 * which then allows a pointer to my_entry_t to be passed to any of
 * the #cairo_hash_table_t functions as follows without requiring a cast:
 *
 *	_cairo_hash_table_insert (hash_table, &my_entry->base);
 *
 * IMPORTANT: The caller is reponsible for initializing
 * my_entry->base.hash with a hash code derived from the key. The
 * essential property of the hash code is that keys_equal must never
 * return %TRUE for two keys that have different hashes. The best hash
 * code will reduce the frequency of two keys with the same code for
 * which keys_equal returns %FALSE.
 *
 * Which parts of the entry make up the "key" and which part make up
 * the value are entirely up to the caller, (as determined by the
 * computation going into base.hash as well as the keys_equal
 * function). A few of the #cairo_hash_table_t functions accept an entry
 * which will be used exclusively as a "key", (indicated by a
 * parameter name of key). In these cases, the value-related fields of
 * the entry need not be initialized if so desired.
 **/
struct _cairo_hash_entry {
    unsigned long hash;
};

struct _cairo_array {
    unsigned int size;
    unsigned int num_elements;
    unsigned int element_size;
    char **elements;

    cairo_bool_t is_snapshot;
};

typedef enum _cairo_round_glyph_positions {
    CAIRO_ROUND_GLYPH_POS_DEFAULT,
    CAIRO_ROUND_GLYPH_POS_ON,
    CAIRO_ROUND_GLYPH_POS_OFF
} cairo_round_glyph_positions_t;

struct _cairo_font_options {
    cairo_antialias_t antialias;
    cairo_subpixel_order_t subpixel_order;
    cairo_lcd_filter_t lcd_filter;
    cairo_hint_style_t hint_style;
    cairo_hint_metrics_t hint_metrics;
    cairo_round_glyph_positions_t round_glyph_positions;
};

/* XXX: Right now, the _cairo_color structure puts unpremultiplied
   color in the doubles and premultiplied color in the shorts. Yes,
   this is crazy insane, (but at least we don't export this
   madness). I'm still working on a cleaner API, but in the meantime,
   at least this does prevent precision loss in color when changing
   alpha. */
struct _cairo_color {
    double red;
    double green;
    double blue;
    double alpha;

    unsigned short red_short;
    unsigned short green_short;
    unsigned short blue_short;
    unsigned short alpha_short;
};

struct _cairo_color_stop {
    /* unpremultiplied */
    double red;
    double green;
    double blue;
    double alpha;

    /* unpremultipled, for convenience */
    uint16_t red_short;
    uint16_t green_short;
    uint16_t blue_short;
    uint16_t alpha_short;
};

typedef enum _cairo_paginated_mode {
    CAIRO_PAGINATED_MODE_ANALYZE,	/* analyze page regions */
    CAIRO_PAGINATED_MODE_RENDER,	/* render page contents */
    CAIRO_PAGINATED_MODE_FALLBACK 	/* paint fallback images */
} cairo_paginated_mode_t;

/* Sure wish C had a real enum type so that this would be distinct
 * from #cairo_status_t. Oh well, without that, I'll use this bogus 100
 * offset.  We want to keep it fit in int8_t as the compiler may choose
 * that for #cairo_status_t */
typedef enum _cairo_int_status {
    CAIRO_INT_STATUS_UNSUPPORTED = 100,
    CAIRO_INT_STATUS_DEGENERATE,
    CAIRO_INT_STATUS_NOTHING_TO_DO,
    CAIRO_INT_STATUS_FLATTEN_TRANSPARENCY,
    CAIRO_INT_STATUS_IMAGE_FALLBACK,
    CAIRO_INT_STATUS_ANALYZE_RECORDING_SURFACE_PATTERN,

    CAIRO_INT_STATUS_LAST_STATUS
} cairo_int_status_t;

typedef enum _cairo_internal_surface_type {
    CAIRO_INTERNAL_SURFACE_TYPE_SNAPSHOT = 0x1000,
    CAIRO_INTERNAL_SURFACE_TYPE_PAGINATED,
    CAIRO_INTERNAL_SURFACE_TYPE_ANALYSIS,
    CAIRO_INTERNAL_SURFACE_TYPE_TEST_FALLBACK,
    CAIRO_INTERNAL_SURFACE_TYPE_TEST_PAGINATED,
    CAIRO_INTERNAL_SURFACE_TYPE_TEST_WRAPPING,
    CAIRO_INTERNAL_SURFACE_TYPE_NULL,
    CAIRO_INTERNAL_SURFACE_TYPE_TYPE3_GLYPH
} cairo_internal_surface_type_t;

#define CAIRO_HAS_TEST_PAGINATED_SURFACE 1
#define CAIRO_HAS_TEST_NULL_SURFACE 1
#define CAIRO_HAS_TEST_WRAPPING_SURFACE 1

typedef struct _cairo_slope {
    cairo_fixed_t dx;
    cairo_fixed_t dy;
} cairo_slope_t, cairo_distance_t;

typedef struct _cairo_point_double {
    double x;
    double y;
} cairo_point_double_t;

typedef struct _cairo_distance_double {
    double dx;
    double dy;
} cairo_distance_double_t;

typedef struct _cairo_line {
    cairo_point_t p1;
    cairo_point_t p2;
} cairo_line_t, cairo_box_t;

typedef struct _cairo_trapezoid {
    cairo_fixed_t top, bottom;
    cairo_line_t left, right;
} cairo_trapezoid_t;

typedef struct _cairo_point_int {
    int x, y;
} cairo_point_int_t;

#define CAIRO_RECT_INT_MIN (INT_MIN >> CAIRO_FIXED_FRAC_BITS)
#define CAIRO_RECT_INT_MAX (INT_MAX >> CAIRO_FIXED_FRAC_BITS)

typedef enum _cairo_direction {
    CAIRO_DIRECTION_FORWARD,
    CAIRO_DIRECTION_REVERSE
} cairo_direction_t;

typedef struct _cairo_edge {
    cairo_line_t line;
    int top, bottom;
    int dir;
} cairo_edge_t;

typedef struct _cairo_polygon {
    cairo_status_t status;

    cairo_point_t first_point;
    cairo_point_t last_point;
    cairo_point_t current_point;
    cairo_slope_t current_edge;
    cairo_bool_t has_current_point;
    cairo_bool_t has_current_edge;

    cairo_box_t extents;
    cairo_box_t limit;
    const cairo_box_t *limits;
    int num_limits;

    int num_edges;
    int edges_size;
    cairo_edge_t *edges;
    cairo_edge_t  edges_embedded[32];
} cairo_polygon_t;

typedef cairo_warn cairo_status_t
(*cairo_spline_add_point_func_t) (void *closure,
				  const cairo_point_t *point);

typedef struct _cairo_spline_knots {
    cairo_point_t a, b, c, d;
} cairo_spline_knots_t;

typedef struct _cairo_spline {
    cairo_spline_add_point_func_t add_point_func;
    void *closure;

    cairo_spline_knots_t knots;

    cairo_slope_t initial_slope;
    cairo_slope_t final_slope;

    cairo_bool_t has_point;
    cairo_point_t last_point;
} cairo_spline_t;

typedef struct _cairo_pen_vertex {
    cairo_point_t point;

    cairo_slope_t slope_ccw;
    cairo_slope_t slope_cw;
} cairo_pen_vertex_t;

typedef struct _cairo_pen {
    double radius;
    double tolerance;

    int num_vertices;
    cairo_pen_vertex_t *vertices;
    cairo_pen_vertex_t  vertices_embedded[32];
} cairo_pen_t;

typedef struct _cairo_stroke_style {
    double		 line_width;
    cairo_line_cap_t	 line_cap;
    cairo_line_join_t	 line_join;
    double		 miter_limit;
    double		*dash;
    unsigned int	 num_dashes;
    double		 dash_offset;
} cairo_stroke_style_t;

typedef struct _cairo_format_masks {
    int bpp;
    unsigned long alpha_mask;
    unsigned long red_mask;
    unsigned long green_mask;
    unsigned long blue_mask;
} cairo_format_masks_t;

typedef enum {
    CAIRO_STOCK_WHITE,
    CAIRO_STOCK_BLACK,
    CAIRO_STOCK_TRANSPARENT,
    CAIRO_STOCK_NUM_COLORS,
} cairo_stock_t;

typedef enum _cairo_image_transparency {
    CAIRO_IMAGE_IS_OPAQUE,
    CAIRO_IMAGE_HAS_BILEVEL_ALPHA,
    CAIRO_IMAGE_HAS_ALPHA,
    CAIRO_IMAGE_UNKNOWN
} cairo_image_transparency_t;

struct _cairo_mime_data {
    cairo_reference_count_t ref_count;
    unsigned char *data;
    unsigned long length;
    cairo_destroy_func_t destroy;
    void *closure;
};

struct _cairo_pattern {
    cairo_pattern_type_t	type;
    cairo_reference_count_t	ref_count;
    cairo_status_t		status;
    cairo_user_data_array_t	user_data;

    cairo_matrix_t		matrix;
    cairo_filter_t		filter;
    cairo_extend_t		extend;

    cairo_bool_t		has_component_alpha;
};

struct _cairo_solid_pattern {
    cairo_pattern_t base;
    cairo_color_t color;
};

typedef struct _cairo_surface_pattern {
    cairo_pattern_t base;

    cairo_surface_t *surface;
} cairo_surface_pattern_t;

typedef struct _cairo_gradient_stop {
    double offset;
    cairo_color_stop_t color;
} cairo_gradient_stop_t;

typedef struct _cairo_gradient_pattern {
    cairo_pattern_t base;

    unsigned int	    n_stops;
    unsigned int	    stops_size;
    cairo_gradient_stop_t  *stops;
    cairo_gradient_stop_t   stops_embedded[2];
} cairo_gradient_pattern_t;

typedef struct _cairo_linear_pattern {
    cairo_gradient_pattern_t base;

    cairo_point_t p1;
    cairo_point_t p2;
} cairo_linear_pattern_t;

typedef struct _cairo_radial_pattern {
    cairo_gradient_pattern_t base;

    cairo_point_t c1;
    cairo_fixed_t r1;
    cairo_point_t c2;
    cairo_fixed_t r2;
} cairo_radial_pattern_t;

typedef union {
    cairo_gradient_pattern_t base;

    cairo_linear_pattern_t linear;
    cairo_radial_pattern_t radial;
} cairo_gradient_pattern_union_t;

typedef union {
    cairo_pattern_type_t	    type;
    cairo_pattern_t		    base;

    cairo_solid_pattern_t	    solid;
    cairo_surface_pattern_t	    surface;
    cairo_gradient_pattern_union_t  gradient;
} cairo_pattern_union_t;

/*
 * A #cairo_unscaled_font_t is just an opaque handle we use in the
 * glyph cache.
 */
typedef struct _cairo_unscaled_font {
    cairo_hash_entry_t			 hash_entry;
    cairo_reference_count_t		 ref_count;
    const cairo_unscaled_font_backend_t	*backend;
} cairo_unscaled_font_t;

typedef struct _cairo_scaled_glyph {
    cairo_hash_entry_t hash_entry;

    cairo_text_extents_t    metrics;		/* user-space metrics */
    cairo_text_extents_t    fs_metrics;		/* font-space metrics */
    cairo_box_t		    bbox;		/* device-space bounds */
    int16_t                 x_advance;		/* device-space rounded X advance */
    int16_t                 y_advance;		/* device-space rounded Y advance */

    unsigned int	    has_info;
    cairo_image_surface_t   *surface;		/* device-space image */
    cairo_path_fixed_t	    *path;		/* device-space outline */
    cairo_surface_t         *recording_surface;	/* device-space recording-surface */

    void		    *surface_private;	/* for the surface backend */
} cairo_scaled_glyph_t;
#endif /* CAIRO_TYPES_PRIVATE_H */
