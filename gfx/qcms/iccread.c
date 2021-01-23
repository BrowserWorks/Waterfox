/* vim: set ts=8 sw=8 noexpandtab: */
//  qcms
//  Copyright (C) 2009 Mozilla Foundation
//  Copyright (C) 1998-2007 Marti Maria
//
// Permission is hereby granted, free of charge, to any person obtaining 
// a copy of this software and associated documentation files (the "Software"), 
// to deal in the Software without restriction, including without limitation 
// the rights to use, copy, modify, merge, publish, distribute, sublicense, 
// and/or sell copies of the Software, and to permit persons to whom the Software 
// is furnished to do so, subject to the following conditions:
//
// The above copyright notice and this permission notice shall be included in 
// all copies or substantial portions of the Software.
//
// THE SOFTWARE IS PROVIDED "AS IS", WITHOUT WARRANTY OF ANY KIND, 
// EXPRESS OR IMPLIED, INCLUDING BUT NOT LIMITED TO 
// THE WARRANTIES OF MERCHANTABILITY, FITNESS FOR A PARTICULAR PURPOSE AND 
// NONINFRINGEMENT. IN NO EVENT SHALL THE AUTHORS OR COPYRIGHT HOLDERS BE 
// LIABLE FOR ANY CLAIM, DAMAGES OR OTHER LIABILITY, WHETHER IN AN ACTION 
// OF CONTRACT, TORT OR OTHERWISE, ARISING FROM, OUT OF OR IN CONNECTION 
// WITH THE SOFTWARE OR THE USE OR OTHER DEALINGS IN THE SOFTWARE.

#include <math.h>
#include <assert.h>
#include <stdlib.h>
#include <string.h> //memset
#include "qcmsint.h"

/* It might be worth having a unified limit on content controlled
 * allocation per profile. This would remove the need for many
 * of the arbitrary limits that we used */

typedef uint32_t be32;
typedef uint16_t be16;

static be32 cpu_to_be32(uint32_t v)
{
#ifdef IS_LITTLE_ENDIAN
	return ((v & 0xff) << 24) | ((v & 0xff00) << 8) | ((v & 0xff0000) >> 8) | ((v & 0xff000000) >> 24);
#else
	return v;
#endif
}

static be16 cpu_to_be16(uint16_t v)
{
#ifdef IS_LITTLE_ENDIAN
	return ((v & 0xff) << 8) | ((v & 0xff00) >> 8);
#else
	return v;
#endif
}

static uint32_t be32_to_cpu(be32 v)
{
#ifdef IS_LITTLE_ENDIAN
	return ((v & 0xff) << 24) | ((v & 0xff00) << 8) | ((v & 0xff0000) >> 8) | ((v & 0xff000000) >> 24);
	//return __builtin_bswap32(v);
#else
	return v;
#endif
}

static uint16_t be16_to_cpu(be16 v)
{
#ifdef IS_LITTLE_ENDIAN
	return ((v & 0xff) << 8) | ((v & 0xff00) >> 8);
#else
	return v;
#endif
}

/* a wrapper around the memory that we are going to parse
 * into a qcms_profile */
struct mem_source
{
	const unsigned char *buf;
	size_t size;
	bool valid;
	const char *invalid_reason;
};

static void invalid_source(struct mem_source *mem, const char *reason)
{
	mem->valid = false;
	mem->invalid_reason = reason;
}

static uint32_t read_u32(struct mem_source *mem, size_t offset)
{
	/* Subtract from mem->size instead of the more intuitive adding to offset.
	 * This avoids overflowing offset. The subtraction is safe because
	 * mem->size is guaranteed to be > 4 */
	if (offset > mem->size - 4) {
		invalid_source(mem, "Invalid offset");
		return 0;
	} else {
		be32 k;
		memcpy(&k, mem->buf + offset, sizeof(k));
		return be32_to_cpu(k);
	}
}

static uint16_t read_u16(struct mem_source *mem, size_t offset)
{
	if (offset > mem->size - 2) {
		invalid_source(mem, "Invalid offset");
		return 0;
	} else {
		be16 k;
		memcpy(&k, mem->buf + offset, sizeof(k));
		return be16_to_cpu(k);
	}
}

static uint8_t read_u8(struct mem_source *mem, size_t offset)
{
	if (offset > mem->size - 1) {
		invalid_source(mem, "Invalid offset");
		return 0;
	} else {
		return *(uint8_t*)(mem->buf + offset);
	}
}

static s15Fixed16Number read_s15Fixed16Number(struct mem_source *mem, size_t offset)
{
	return read_u32(mem, offset);
}

static uInt8Number read_uInt8Number(struct mem_source *mem, size_t offset)
{
	return read_u8(mem, offset);
}

static uInt16Number read_uInt16Number(struct mem_source *mem, size_t offset)
{
	return read_u16(mem, offset);
}

static void write_u32(void *mem, size_t offset, uint32_t value)
{
    *((uint32_t *)((unsigned char*)mem + offset)) = cpu_to_be32(value);
}

static void write_u16(void *mem, size_t offset, uint16_t value)
{
    *((uint16_t *)((unsigned char*)mem + offset)) = cpu_to_be16(value);
}

#define BAD_VALUE_PROFILE NULL
#define INVALID_PROFILE NULL
#define NO_MEM_PROFILE NULL

/* An arbitrary 4MB limit on profile size */
#define MAX_PROFILE_SIZE 1024*1024*4
#define MAX_TAG_COUNT 1024

static void check_CMM_type_signature(struct mem_source *src)
{
	//uint32_t CMM_type_signature = read_u32(src, 4);
	//TODO: do the check?

}

static void check_profile_version(struct mem_source *src)
{

	/*
	uint8_t major_revision = read_u8(src, 8 + 0);
	uint8_t minor_revision = read_u8(src, 8 + 1);
	*/
	uint8_t reserved1      = read_u8(src, 8 + 2);
	uint8_t reserved2      = read_u8(src, 8 + 3);
	/* Checking the version doesn't buy us anything
	if (major_revision != 0x4) {
		if (major_revision > 0x2)
			invalid_source(src, "Unsupported major revision");
		if (minor_revision > 0x40)
			invalid_source(src, "Unsupported minor revision");
	}
	*/
	if (reserved1 != 0 || reserved2 != 0)
		invalid_source(src, "Invalid reserved bytes");
}

#define INPUT_DEVICE_PROFILE   0x73636e72 // 'scnr'
#define DISPLAY_DEVICE_PROFILE 0x6d6e7472 // 'mntr'
#define OUTPUT_DEVICE_PROFILE  0x70727472 // 'prtr'
#define DEVICE_LINK_PROFILE    0x6c696e6b // 'link'
#define COLOR_SPACE_PROFILE    0x73706163 // 'spac'
#define ABSTRACT_PROFILE       0x61627374 // 'abst'
#define NAMED_COLOR_PROFILE    0x6e6d636c // 'nmcl'

static void read_class_signature(qcms_profile *profile, struct mem_source *mem)
{
	profile->class_type = read_u32(mem, 12);
	switch (profile->class_type) {
		case DISPLAY_DEVICE_PROFILE:
		case INPUT_DEVICE_PROFILE:
		case OUTPUT_DEVICE_PROFILE:
		case COLOR_SPACE_PROFILE:
			break;
		default:
			invalid_source(mem, "Invalid  Profile/Device Class signature");
	}
}

static void read_color_space(qcms_profile *profile, struct mem_source *mem)
{
	profile->color_space = read_u32(mem, 16);
	switch (profile->color_space) {
		case RGB_SIGNATURE:
		case GRAY_SIGNATURE:
			break;
		default:
			invalid_source(mem, "Unsupported colorspace");
	}
}

static void read_pcs(qcms_profile *profile, struct mem_source *mem)
{
	profile->pcs = read_u32(mem, 20);
	switch (profile->pcs) {
		case XYZ_SIGNATURE:
		case LAB_SIGNATURE:
			break;
		default:
			invalid_source(mem, "Unsupported pcs");
	}
}

struct tag
{
	uint32_t signature;
	uint32_t offset;
	uint32_t size;
};

struct tag_index {
	uint32_t count;
	struct tag *tags;
};

static struct tag_index read_tag_table(qcms_profile *profile, struct mem_source *mem)
{
	struct tag_index index = {0, NULL};
	unsigned int i;

	index.count = read_u32(mem, 128);
	if (index.count > MAX_TAG_COUNT) {
		invalid_source(mem, "max number of tags exceeded");
		return index;
	}

	index.tags = malloc(sizeof(struct tag)*index.count);
	if (index.tags) {
		for (i = 0; i < index.count; i++) {
			index.tags[i].signature = read_u32(mem, 128 + 4 + 4*i*3);
			index.tags[i].offset    = read_u32(mem, 128 + 4 + 4*i*3 + 4);
			index.tags[i].size      = read_u32(mem, 128 + 4 + 4*i*3 + 8);
		}
	}

	return index;
}

// Checks a profile for obvious inconsistencies and returns
// true if the profile looks bogus and should probably be
// ignored.
bool qcms_profile_is_bogus(qcms_profile *profile)
{
       float sum[3], target[3], tolerance[3];
       float rX, rY, rZ, gX, gY, gZ, bX, bY, bZ;
       bool negative;
       unsigned i;

       // We currently only check the bogosity of RGB profiles
       if (profile->color_space != RGB_SIGNATURE)
	       return false;

       if (profile->A2B0 || profile->B2A0 || profile->mAB || profile->mBA)
               return false;

       rX = s15Fixed16Number_to_float(profile->redColorant.X);
       rY = s15Fixed16Number_to_float(profile->redColorant.Y);
       rZ = s15Fixed16Number_to_float(profile->redColorant.Z);

       gX = s15Fixed16Number_to_float(profile->greenColorant.X);
       gY = s15Fixed16Number_to_float(profile->greenColorant.Y);
       gZ = s15Fixed16Number_to_float(profile->greenColorant.Z);

       bX = s15Fixed16Number_to_float(profile->blueColorant.X);
       bY = s15Fixed16Number_to_float(profile->blueColorant.Y);
       bZ = s15Fixed16Number_to_float(profile->blueColorant.Z);

       // Sum the values; they should add up to something close to white
       sum[0] = rX + gX + bX;
       sum[1] = rY + gY + bY;
       sum[2] = rZ + gZ + bZ;

       // Build our target vector (see mozilla bug 460629)
       target[0] = 0.96420f;
       target[1] = 1.00000f;
       target[2] = 0.82491f;

       // Our tolerance vector - Recommended by Chris Murphy based on
       // conversion from the LAB space criterion of no more than 3 in any one
       // channel. This is similar to, but slightly more tolerant than Adobe's
       // criterion.
       tolerance[0] = 0.02f;
       tolerance[1] = 0.02f;
       tolerance[2] = 0.04f;

       // Compare with our tolerance
       for (i = 0; i < 3; ++i) {
           if (!(((sum[i] - tolerance[i]) <= target[i]) &&
                 ((sum[i] + tolerance[i]) >= target[i])))
               return true;
       }

#ifndef __APPLE__
       // Check if any of the XYZ values are negative (see mozilla bug 498245)
       // CIEXYZ tristimulus values cannot be negative according to the spec.

       negative =
	       (rX < 0) || (rY < 0) || (rZ < 0) ||
	       (gX < 0) || (gY < 0) || (gZ < 0) ||
	       (bX < 0) || (bY < 0) || (bZ < 0);

#else
       // Chromatic adaption to D50 can result in negative XYZ, but the white
       // point D50 tolerance test has passed. Accept negative values herein.
       // See https://bugzilla.mozilla.org/show_bug.cgi?id=498245#c18 onwards
       // for discussion about whether profile XYZ can or cannot be negative,
       // per the spec. Also the https://bugzil.la/450923 user report.

       // FIXME: allow this relaxation on all ports?
       negative = false;
#endif
       if (negative)
	       return true; // bogus

       // All Good
       return false;
}

#define TAG_bXYZ 0x6258595a
#define TAG_gXYZ 0x6758595a
#define TAG_rXYZ 0x7258595a
#define TAG_rTRC 0x72545243
#define TAG_bTRC 0x62545243
#define TAG_gTRC 0x67545243
#define TAG_kTRC 0x6b545243
#define TAG_A2B0 0x41324230
#define TAG_B2A0 0x42324130
#define TAG_CHAD 0x63686164

static struct tag *find_tag(struct tag_index index, uint32_t tag_id)
{
	unsigned int i;
	struct tag *tag = NULL;
	for (i = 0; i < index.count; i++) {
		if (index.tags[i].signature == tag_id) {
			return &index.tags[i];
		}
	}
	return tag;
}

#define XYZ_TYPE		0x58595a20 // 'XYZ '
#define CURVE_TYPE		0x63757276 // 'curv'
#define PARAMETRIC_CURVE_TYPE	0x70617261 // 'para'
#define LUT16_TYPE		0x6d667432 // 'mft2'
#define LUT8_TYPE		0x6d667431 // 'mft1'
#define LUT_MAB_TYPE		0x6d414220 // 'mAB '
#define LUT_MBA_TYPE		0x6d424120 // 'mBA '
#define CHROMATIC_TYPE		0x73663332 // 'sf32'

static struct matrix read_tag_s15Fixed16ArrayType(struct mem_source *src, struct tag_index index, uint32_t tag_id)
{
	struct tag *tag = find_tag(index, tag_id);
	struct matrix matrix;
	if (tag) {
		uint8_t i;
		uint32_t offset = tag->offset;
		uint32_t type = read_u32(src, offset);

		// Check mandatory type signature for s16Fixed16ArrayType
		if (type != CHROMATIC_TYPE) {
			invalid_source(src, "unexpected type, expected 'sf32'");
		}

		for (i = 0; i < 9; i++) {
			matrix.m[i/3][i%3] = s15Fixed16Number_to_float(read_s15Fixed16Number(src, offset+8+i*4));
		}
		matrix.invalid = false;
	} else {
		matrix.invalid = true;
		invalid_source(src, "missing sf32tag");
	}
	return matrix;
}

static struct XYZNumber read_tag_XYZType(struct mem_source *src, struct tag_index index, uint32_t tag_id)
{
	struct XYZNumber num = {0, 0, 0};
	struct tag *tag = find_tag(index, tag_id);
	if (tag) {
		uint32_t offset = tag->offset;

		uint32_t type = read_u32(src, offset);
		if (type != XYZ_TYPE)
			invalid_source(src, "unexpected type, expected XYZ");
		num.X = read_s15Fixed16Number(src, offset+8);
		num.Y = read_s15Fixed16Number(src, offset+12);
		num.Z = read_s15Fixed16Number(src, offset+16);
	} else {
		invalid_source(src, "missing xyztag");
	}
	return num;
}

// Read the tag at a given offset rather then the tag_index. 
// This method is used when reading mAB tags where nested curveType are
// present that are not part of the tag_index.
static struct curveType *read_curveType(struct mem_source *src, uint32_t offset, uint32_t *len)
{
	static const uint32_t COUNT_TO_LENGTH[5] = {1, 3, 4, 5, 7};
	struct curveType *curve = NULL;
	uint32_t type = read_u32(src, offset);
	uint32_t count;
	uint32_t i;

	if (type != CURVE_TYPE && type != PARAMETRIC_CURVE_TYPE) {
		invalid_source(src, "unexpected type, expected CURV or PARA");
		return NULL;
	}

	if (type == CURVE_TYPE) {
		count = read_u32(src, offset+8);

#define MAX_CURVE_ENTRIES 40000 //arbitrary
		if (count > MAX_CURVE_ENTRIES) {
			invalid_source(src, "curve size too large");
			return NULL;
		}
		curve = malloc(sizeof(struct curveType) + sizeof(uInt16Number)*count);
		if (!curve)
			return NULL;

		curve->count = count;
		curve->type = CURVE_TYPE;

		for (i=0; i<count; i++) {
			curve->data[i] = read_u16(src, offset + 12 + i*2);
		}
		*len = 12 + count * 2;
	} else { //PARAMETRIC_CURVE_TYPE
		count = read_u16(src, offset+8);

		if (count > 4) {
			invalid_source(src, "parametric function type not supported.");
			return NULL;
		}

		curve = malloc(sizeof(struct curveType));
		if (!curve)
			return NULL;

		curve->count = count;
		curve->type = PARAMETRIC_CURVE_TYPE;

		for (i=0; i < COUNT_TO_LENGTH[count]; i++) {
			curve->parameter[i] = s15Fixed16Number_to_float(read_s15Fixed16Number(src, offset + 12 + i*4));	
		}
		*len = 12 + COUNT_TO_LENGTH[count] * 4;

		if ((count == 1 || count == 2)) {
			/* we have a type 1 or type 2 function that has a division by 'a' */
			float a = curve->parameter[1];
			if (a == 0.f)
				invalid_source(src, "parametricCurve definition causes division by zero.");
		}
	}

	return curve;
}

static struct curveType *read_tag_curveType(struct mem_source *src, struct tag_index index, uint32_t tag_id)
{
	struct tag *tag = find_tag(index, tag_id);
	struct curveType *curve = NULL;
	if (tag) {
		uint32_t len;
		return read_curveType(src, tag->offset, &len);
	} else {
		invalid_source(src, "missing curvetag");
	}

	return curve;
}

#define MAX_CLUT_SIZE 500000 // arbitrary
#define MAX_CHANNELS 10 // arbitrary
static void read_nested_curveType(struct mem_source *src, struct curveType *(*curveArray)[MAX_CHANNELS], uint8_t num_channels, uint32_t curve_offset)
{
	uint32_t channel_offset = 0;
	int i;
	for (i = 0; i < num_channels; i++) {
		uint32_t tag_len;

		(*curveArray)[i] = read_curveType(src, curve_offset + channel_offset, &tag_len);
		if (!(*curveArray)[i]) {
			invalid_source(src, "invalid nested curveType curve");
			break;
		}

		channel_offset += tag_len;
		// 4 byte aligned
		if ((tag_len % 4) != 0)
			channel_offset += 4 - (tag_len % 4);
	}

}

static void mAB_release(struct lutmABType *lut)
{
	uint8_t i;

	for (i = 0; i < lut->num_in_channels; i++){
		free(lut->a_curves[i]);
	}
	for (i = 0; i < lut->num_out_channels; i++){
		free(lut->b_curves[i]);
		free(lut->m_curves[i]);
	}
	free(lut);
}

/* See section 10.10 for specs */
static struct lutmABType *read_tag_lutmABType(struct mem_source *src, struct tag_index index, uint32_t tag_id)
{
	struct tag *tag = find_tag(index, tag_id);
	uint32_t offset = tag->offset;
	uint32_t a_curve_offset, b_curve_offset, m_curve_offset;
	uint32_t matrix_offset;
	uint32_t clut_offset;
	uint32_t clut_size = 1;
	uint8_t clut_precision;
	uint32_t type = read_u32(src, offset);
	uint8_t num_in_channels, num_out_channels;
	struct lutmABType *lut;
	uint32_t i;

	if (type != LUT_MAB_TYPE && type != LUT_MBA_TYPE) {
		return NULL;
	}

	num_in_channels = read_u8(src, offset + 8);
	num_out_channels = read_u8(src, offset + 9);
	if (num_in_channels > MAX_CHANNELS || num_out_channels > MAX_CHANNELS)
		return NULL;

	// We require 3in/out channels since we only support RGB->XYZ (or RGB->LAB)
	// XXX: If we remove this restriction make sure that the number of channels
	//      is less or equal to the maximum number of mAB curves in qcmsint.h
	//      also check for clut_size overflow. Also make sure it's != 0
	if (num_in_channels != 3 || num_out_channels != 3)
		return NULL;

	// some of this data is optional and is denoted by a zero offset
	// we also use this to track their existance
	a_curve_offset = read_u32(src, offset + 28);
	clut_offset = read_u32(src, offset + 24);
	m_curve_offset = read_u32(src, offset + 20);
	matrix_offset = read_u32(src, offset + 16);
	b_curve_offset = read_u32(src, offset + 12);

	// Convert offsets relative to the tag to relative to the profile
	// preserve zero for optional fields
	if (a_curve_offset)
		a_curve_offset += offset;
	if (clut_offset)
		clut_offset += offset;
	if (m_curve_offset)
		m_curve_offset += offset;
	if (matrix_offset)
		matrix_offset += offset;
	if (b_curve_offset)
		b_curve_offset += offset;

	if (clut_offset) {
		assert (num_in_channels == 3);
		// clut_size can not overflow since lg(256^num_in_channels) = 24 bits.
		for (i = 0; i < num_in_channels; i++) {
			clut_size *= read_u8(src, clut_offset + i);
			if (clut_size == 0) {
				invalid_source(src, "bad clut_size");
			}
		}
	} else {
		clut_size = 0;
	}

	// 24bits * 3 won't overflow either
	clut_size = clut_size * num_out_channels;

	if (clut_size > MAX_CLUT_SIZE)
		return NULL;

	lut = malloc(sizeof(struct lutmABType) + (clut_size) * sizeof(float));
	if (!lut)
		return NULL;
	// we'll fill in the rest below
	memset(lut, 0, sizeof(struct lutmABType));
	lut->clut_table   = &lut->clut_table_data[0];

        if (clut_offset) {
		for (i = 0; i < num_in_channels; i++) {
			lut->num_grid_points[i] = read_u8(src, clut_offset + i);
			if (lut->num_grid_points[i] == 0) {
				invalid_source(src, "bad grid_points");
			}
		}
        }

	// Reverse the processing of transformation elements for mBA type.
	lut->reversed = (type == LUT_MBA_TYPE);

	lut->num_in_channels = num_in_channels;
	lut->num_out_channels = num_out_channels;

	if (matrix_offset) {
		// read the matrix if we have it
		lut->e00 = read_s15Fixed16Number(src, matrix_offset+4*0);
		lut->e01 = read_s15Fixed16Number(src, matrix_offset+4*1);
		lut->e02 = read_s15Fixed16Number(src, matrix_offset+4*2);
		lut->e10 = read_s15Fixed16Number(src, matrix_offset+4*3);
		lut->e11 = read_s15Fixed16Number(src, matrix_offset+4*4);
		lut->e12 = read_s15Fixed16Number(src, matrix_offset+4*5);
		lut->e20 = read_s15Fixed16Number(src, matrix_offset+4*6);
		lut->e21 = read_s15Fixed16Number(src, matrix_offset+4*7);
		lut->e22 = read_s15Fixed16Number(src, matrix_offset+4*8);
		lut->e03 = read_s15Fixed16Number(src, matrix_offset+4*9);
		lut->e13 = read_s15Fixed16Number(src, matrix_offset+4*10);
		lut->e23 = read_s15Fixed16Number(src, matrix_offset+4*11);
	}

	if (a_curve_offset) {
		read_nested_curveType(src, &lut->a_curves, num_in_channels, a_curve_offset);
	}
	if (m_curve_offset) {
		read_nested_curveType(src, &lut->m_curves, num_out_channels, m_curve_offset);
	}
	if (b_curve_offset) {
		read_nested_curveType(src, &lut->b_curves, num_out_channels, b_curve_offset);
	} else {
		invalid_source(src, "B curves required");
	}

	if (clut_offset) {
		clut_precision = read_u8(src, clut_offset + 16);
		if (clut_precision == 1) {
			for (i = 0; i < clut_size; i++) {
				lut->clut_table[i] = uInt8Number_to_float(read_uInt8Number(src, clut_offset + 20 + i*1));
			}
		} else if (clut_precision == 2) {
			for (i = 0; i < clut_size; i++) {
				lut->clut_table[i] = uInt16Number_to_float(read_uInt16Number(src, clut_offset + 20 + i*2));
			}
		} else {
			invalid_source(src, "Invalid clut precision");
		}
	}

	if (!src->valid) {
		mAB_release(lut);
		return NULL;
	}

	return lut;
}

static struct lutType *read_tag_lutType(struct mem_source *src, struct tag_index index, uint32_t tag_id)
{
	struct tag *tag = find_tag(index, tag_id);
	uint32_t offset = tag->offset;
	uint32_t type = read_u32(src, offset);
	uint16_t num_input_table_entries;
	uint16_t num_output_table_entries;
	uint8_t in_chan, grid_points, out_chan;
	uint32_t input_offset, clut_offset, output_offset;
	uint32_t clut_size;
	size_t entry_size;
	struct lutType *lut;
	uint32_t i;

	if (type == LUT8_TYPE) {
		num_input_table_entries = 256;
		num_output_table_entries = 256;
		entry_size = 1;
		input_offset = 48;
	} else if (type == LUT16_TYPE) {
		num_input_table_entries  = read_u16(src, offset + 48);
		num_output_table_entries = read_u16(src, offset + 50);
		if (num_input_table_entries == 0 || num_output_table_entries == 0) {
			invalid_source(src, "Bad channel count");
			return NULL;
		}
		entry_size = 2;
		input_offset = 52;
	} else {
		assert(0); // the caller checks that this doesn't happen
		invalid_source(src, "Unexpected lut type");
		return NULL;
	}

	in_chan     = read_u8(src, offset + 8);
	out_chan    = read_u8(src, offset + 9);
	grid_points = read_u8(src, offset + 10);

	clut_size = pow(grid_points, in_chan);
	if (clut_size > MAX_CLUT_SIZE) {
		invalid_source(src, "CLUT too large");
		return NULL;
	}

	if (clut_size <= 0) {
		invalid_source(src, "CLUT must not be empty.");
		return NULL;
	}

	if (in_chan != 3 || out_chan != 3) {
		invalid_source(src, "CLUT only supports RGB");
		return NULL;
	}

	lut = malloc(sizeof(struct lutType) + (num_input_table_entries * in_chan + clut_size*out_chan + num_output_table_entries * out_chan)*sizeof(float));
	if (!lut) {
		invalid_source(src, "CLUT too large");
		return NULL;
	}

	/* compute the offsets of tables */
	lut->input_table  = &lut->table_data[0];
	lut->clut_table   = &lut->table_data[in_chan*num_input_table_entries];
	lut->output_table = &lut->table_data[in_chan*num_input_table_entries + clut_size*out_chan];

	lut->num_input_table_entries  = num_input_table_entries;
	lut->num_output_table_entries = num_output_table_entries;
	lut->num_input_channels   = in_chan;
	lut->num_output_channels  = out_chan;
	lut->num_clut_grid_points = grid_points;
	lut->e00 = read_s15Fixed16Number(src, offset+12);
	lut->e01 = read_s15Fixed16Number(src, offset+16);
	lut->e02 = read_s15Fixed16Number(src, offset+20);
	lut->e10 = read_s15Fixed16Number(src, offset+24);
	lut->e11 = read_s15Fixed16Number(src, offset+28);
	lut->e12 = read_s15Fixed16Number(src, offset+32);
	lut->e20 = read_s15Fixed16Number(src, offset+36);
	lut->e21 = read_s15Fixed16Number(src, offset+40);
	lut->e22 = read_s15Fixed16Number(src, offset+44);

	for (i = 0; i < (uint32_t)(lut->num_input_table_entries * in_chan); i++) {
		if (type == LUT8_TYPE) {
			lut->input_table[i] = uInt8Number_to_float(read_uInt8Number(src, offset + input_offset + i * entry_size));
		} else {
			lut->input_table[i] = uInt16Number_to_float(read_uInt16Number(src, offset + input_offset + i * entry_size));
		}
	}

	clut_offset = offset + input_offset + lut->num_input_table_entries * in_chan * entry_size;
	for (i = 0; i < clut_size * out_chan; i+=3) {
		if (type == LUT8_TYPE) {
			lut->clut_table[i+0] = uInt8Number_to_float(read_uInt8Number(src, clut_offset + i*entry_size + 0));
			lut->clut_table[i+1] = uInt8Number_to_float(read_uInt8Number(src, clut_offset + i*entry_size + 1));
			lut->clut_table[i+2] = uInt8Number_to_float(read_uInt8Number(src, clut_offset + i*entry_size + 2));
		} else {
			lut->clut_table[i+0] = uInt16Number_to_float(read_uInt16Number(src, clut_offset + i*entry_size + 0));
			lut->clut_table[i+1] = uInt16Number_to_float(read_uInt16Number(src, clut_offset + i*entry_size + 2));
			lut->clut_table[i+2] = uInt16Number_to_float(read_uInt16Number(src, clut_offset + i*entry_size + 4));
		}
	}

	output_offset = clut_offset + clut_size * out_chan * entry_size;
	for (i = 0; i < (uint32_t)(lut->num_output_table_entries * out_chan); i++) {
		if (type == LUT8_TYPE) {
			lut->output_table[i] = uInt8Number_to_float(read_uInt8Number(src, output_offset + i*entry_size));
		} else {
			lut->output_table[i] = uInt16Number_to_float(read_uInt16Number(src, output_offset + i*entry_size));
		}
	}

	return lut;
}

static void read_rendering_intent(qcms_profile *profile, struct mem_source *src)
{
	profile->rendering_intent = read_u32(src, 64);
	switch (profile->rendering_intent) {
		case QCMS_INTENT_PERCEPTUAL:
		case QCMS_INTENT_SATURATION:
		case QCMS_INTENT_RELATIVE_COLORIMETRIC:
		case QCMS_INTENT_ABSOLUTE_COLORIMETRIC:
			break;
		default:
			invalid_source(src, "unknown rendering intent");
	}
}

qcms_profile *qcms_profile_create(void)
{
	return calloc(sizeof(qcms_profile), 1);
}



/* build sRGB gamma table */
/* based on cmsBuildParametricGamma() */
static uint16_t *build_sRGB_gamma_table(int num_entries)
{
	int i;
	/* taken from lcms: Build_sRGBGamma() */
	double gamma = 2.4;
	double a = 1./1.055;
	double b = 0.055/1.055;
	double c = 1./12.92;
	double d = 0.04045;

	uint16_t *table = malloc(sizeof(uint16_t) * num_entries);
	if (!table)
		return NULL;

	for (i=0; i<num_entries; i++) {
		double x = (double)i / (num_entries-1);
		double y, output;
		// IEC 61966-2.1 (sRGB)
		// Y = (aX + b)^Gamma | X >= d
		// Y = cX             | X < d
		if (x >= d) {
			double e = (a*x + b);
			if (e > 0)
				y = pow(e, gamma);
			else
				y = 0;
		} else {
			y = c*x;
		}

		// Saturate -- this could likely move to a separate function
		output = y * 65535. + .5;
		if (output > 65535.)
			output = 65535;
		if (output < 0)
			output = 0;
		table[i] = (uint16_t)floor(output);
	}
	return table;
}

static struct curveType *curve_from_table(uint16_t *table, int num_entries)
{
	struct curveType *curve;
	int i;
	curve = malloc(sizeof(struct curveType) + sizeof(uInt16Number)*num_entries);
	if (!curve)
		return NULL;
	curve->type = CURVE_TYPE;
	curve->count = num_entries;
	for (i = 0; i < num_entries; i++) {
		curve->data[i] = table[i];
	}
	return curve;
}

static uint16_t float_to_u8Fixed8Number(float a)
{
	if (a > (255.f + 255.f/256))
		return 0xffff;
	else if (a < 0.f)
		return 0;
	else
		return floorf(a*256.f + .5f);
}

static struct curveType *curve_from_gamma(float gamma)
{
	struct curveType *curve;
	int num_entries = 1;
	curve = malloc(sizeof(struct curveType) + sizeof(uInt16Number)*num_entries);
	if (!curve)
		return NULL;
	curve->count = num_entries;
	curve->data[0] = float_to_u8Fixed8Number(gamma);
  	curve->type = CURVE_TYPE;
	return curve;
}

//XXX: it would be nice if we had a way of ensuring
// everything in a profile was initialized regardless of how it was created

//XXX: should this also be taking a black_point?
/* similar to CGColorSpaceCreateCalibratedRGB */
qcms_profile* qcms_profile_create_rgb_with_gamma_set(
		qcms_CIE_xyY white_point,
		qcms_CIE_xyYTRIPLE primaries,
		float redGamma,
		float greenGamma,
		float blueGamma)
{
	qcms_profile* profile = qcms_profile_create();
	if (!profile)
		return NO_MEM_PROFILE;

	//XXX: should store the whitepoint
	if (!set_rgb_colorants(profile, white_point, primaries)) {
		qcms_profile_release(profile);
		return INVALID_PROFILE;
	}

	profile->redTRC = curve_from_gamma(redGamma);
	profile->blueTRC = curve_from_gamma(blueGamma);
	profile->greenTRC = curve_from_gamma(greenGamma);

	if (!profile->redTRC || !profile->blueTRC || !profile->greenTRC) {
		qcms_profile_release(profile);
		return NO_MEM_PROFILE;
	}
	profile->class_type = DISPLAY_DEVICE_PROFILE;
	profile->rendering_intent = QCMS_INTENT_PERCEPTUAL;
	profile->color_space = RGB_SIGNATURE;
        profile->pcs = XYZ_SIGNATURE;
	return profile;
}

qcms_profile* qcms_profile_create_rgb_with_gamma(
		qcms_CIE_xyY white_point,
		qcms_CIE_xyYTRIPLE primaries,
		float gamma)
{
	return qcms_profile_create_rgb_with_gamma_set(white_point, primaries, gamma, gamma, gamma);
}

qcms_profile* qcms_profile_create_rgb_with_table(
		qcms_CIE_xyY white_point,
		qcms_CIE_xyYTRIPLE primaries,
		uint16_t *table, int num_entries)
{
	qcms_profile* profile = qcms_profile_create();
	if (!profile)
		return NO_MEM_PROFILE;

	//XXX: should store the whitepoint
	if (!set_rgb_colorants(profile, white_point, primaries)) {
		qcms_profile_release(profile);
		return INVALID_PROFILE;
	}

	profile->redTRC = curve_from_table(table, num_entries);
	profile->blueTRC = curve_from_table(table, num_entries);
	profile->greenTRC = curve_from_table(table, num_entries);

	if (!profile->redTRC || !profile->blueTRC || !profile->greenTRC) {
		qcms_profile_release(profile);
		return NO_MEM_PROFILE;
	}
	profile->class_type = DISPLAY_DEVICE_PROFILE;
	profile->rendering_intent = QCMS_INTENT_PERCEPTUAL;
	profile->color_space = RGB_SIGNATURE;
        profile->pcs = XYZ_SIGNATURE;
	return profile;
}

/* from lcms: cmsWhitePointFromTemp */
/* tempK must be >= 4000. and <= 25000.
 * Invalid values of tempK will return
 * (x,y,Y) = (-1.0, -1.0, -1.0)
 * similar to argyll: icx_DTEMP2XYZ() */
static qcms_CIE_xyY white_point_from_temp(int temp_K)
{
	qcms_CIE_xyY white_point;
	double x, y;
	double T, T2, T3;
	// double M1, M2;

	// No optimization provided.
	T = temp_K;
	T2 = T*T;            // Square
	T3 = T2*T;           // Cube

	// For correlated color temperature (T) between 4000K and 7000K:
	if (T >= 4000. && T <= 7000.) {
		x = -4.6070*(1E9/T3) + 2.9678*(1E6/T2) + 0.09911*(1E3/T) + 0.244063;
	} else {
		// or for correlated color temperature (T) between 7000K and 25000K:
		if (T > 7000.0 && T <= 25000.0) {
			x = -2.0064*(1E9/T3) + 1.9018*(1E6/T2) + 0.24748*(1E3/T) + 0.237040;
		} else {
			// Invalid tempK
			white_point.x = -1.0;
			white_point.y = -1.0;
			white_point.Y = -1.0;

			assert(0 && "invalid temp");

			return white_point;
		}
	}

	// Obtain y(x)

	y = -3.000*(x*x) + 2.870*x - 0.275;

	// wave factors (not used, but here for futures extensions)

	// M1 = (-1.3515 - 1.7703*x + 5.9114 *y)/(0.0241 + 0.2562*x - 0.7341*y);
	// M2 = (0.0300 - 31.4424*x + 30.0717*y)/(0.0241 + 0.2562*x - 0.7341*y);

	// Fill white_point struct
	white_point.x = x;
	white_point.y = y;
	white_point.Y = 1.0;

	return white_point;
}

qcms_CIE_xyY qcms_white_point_sRGB(void)
{
	return white_point_from_temp(6504);
}

qcms_profile* qcms_profile_sRGB(void)
{
	qcms_profile *profile;
	uint16_t *table;

	qcms_CIE_xyYTRIPLE Rec709Primaries = {
		{0.6400, 0.3300, 1.0},
		{0.3000, 0.6000, 1.0},
		{0.1500, 0.0600, 1.0}
	};
	qcms_CIE_xyY D65;

	D65 = qcms_white_point_sRGB();

	table = build_sRGB_gamma_table(1024);

	if (!table)
		return NO_MEM_PROFILE;

	profile = qcms_profile_create_rgb_with_table(D65, Rec709Primaries, table, 1024);
	free(table);
	return profile;
}


/* qcms_profile_from_memory does not hold a reference to the memory passed in */
qcms_profile* qcms_profile_from_memory(const void *mem, size_t size)
{
	uint32_t length;
	struct mem_source source;
	struct mem_source *src = &source;
	struct tag_index index;
	qcms_profile *profile;

	source.buf = mem;
	source.size = size;
	source.valid = true;

	if (size < 4)
		return INVALID_PROFILE;

	length = read_u32(src, 0);
	if (length <= size) {
		// shrink the area that we can read if appropriate
		source.size = length;
	} else {
		return INVALID_PROFILE;
	}

	/* ensure that the profile size is sane so it's easier to reason about */
	if (source.size <= 64 || source.size >= MAX_PROFILE_SIZE)
		return INVALID_PROFILE;

	profile = qcms_profile_create();
	if (!profile)
		return NO_MEM_PROFILE;

	check_CMM_type_signature(src);
	check_profile_version(src);
	read_class_signature(profile, src);
	read_rendering_intent(profile, src);
	read_color_space(profile, src);
	read_pcs(profile, src);
	//TODO read rest of profile stuff

	if (!src->valid)
		goto invalid_profile;

	index = read_tag_table(profile, src);
	if (!src->valid || !index.tags)
		goto invalid_tag_table;

	if (find_tag(index, TAG_CHAD)) {
		profile->chromaticAdaption = read_tag_s15Fixed16ArrayType(src, index, TAG_CHAD);
	} else {
		profile->chromaticAdaption.invalid = true; //Signal the data is not present
	}

	if (profile->class_type == DISPLAY_DEVICE_PROFILE || profile->class_type == INPUT_DEVICE_PROFILE ||
            profile->class_type == OUTPUT_DEVICE_PROFILE  || profile->class_type == COLOR_SPACE_PROFILE) {
		if (profile->color_space == RGB_SIGNATURE) {
			if (find_tag(index, TAG_A2B0)) {
				if (read_u32(src, find_tag(index, TAG_A2B0)->offset) == LUT8_TYPE ||
				    read_u32(src, find_tag(index, TAG_A2B0)->offset) == LUT16_TYPE) {
					profile->A2B0 = read_tag_lutType(src, index, TAG_A2B0);
				} else if (read_u32(src, find_tag(index, TAG_A2B0)->offset) == LUT_MAB_TYPE) {
					profile->mAB = read_tag_lutmABType(src, index, TAG_A2B0);
				}
			}
			if (find_tag(index, TAG_B2A0)) {
				if (read_u32(src, find_tag(index, TAG_B2A0)->offset) == LUT8_TYPE ||
				    read_u32(src, find_tag(index, TAG_B2A0)->offset) == LUT16_TYPE) {
					profile->B2A0 = read_tag_lutType(src, index, TAG_B2A0);
				} else if (read_u32(src, find_tag(index, TAG_B2A0)->offset) == LUT_MBA_TYPE) {
					profile->mBA = read_tag_lutmABType(src, index, TAG_B2A0);
				}
			}
			if (find_tag(index, TAG_rXYZ) || !qcms_supports_iccv4) {
				profile->redColorant = read_tag_XYZType(src, index, TAG_rXYZ);
				profile->greenColorant = read_tag_XYZType(src, index, TAG_gXYZ);
				profile->blueColorant = read_tag_XYZType(src, index, TAG_bXYZ);
			}

			if (!src->valid)
				goto invalid_tag_table;

			if (find_tag(index, TAG_rTRC) || !qcms_supports_iccv4) {
				profile->redTRC = read_tag_curveType(src, index, TAG_rTRC);
				profile->greenTRC = read_tag_curveType(src, index, TAG_gTRC);
				profile->blueTRC = read_tag_curveType(src, index, TAG_bTRC);

				if (!profile->redTRC || !profile->blueTRC || !profile->greenTRC)
					goto invalid_tag_table;
			}
		} else if (profile->color_space == GRAY_SIGNATURE) {

			profile->grayTRC = read_tag_curveType(src, index, TAG_kTRC);
			if (!profile->grayTRC)
				goto invalid_tag_table;

		} else {
			assert(0 && "read_color_space protects against entering here");
			goto invalid_tag_table;
		}
	} else {
		goto invalid_tag_table;
	}

	if (!src->valid)
		goto invalid_tag_table;

	free(index.tags);

	return profile;

invalid_tag_table:
	free(index.tags);
invalid_profile:
	qcms_profile_release(profile);
	return INVALID_PROFILE;
}

qcms_intent qcms_profile_get_rendering_intent(qcms_profile *profile)
{
	return profile->rendering_intent;
}

icColorSpaceSignature
qcms_profile_get_color_space(qcms_profile *profile)
{
	return profile->color_space;
}

static void lut_release(struct lutType *lut)
{
	free(lut);
}

void qcms_profile_release(qcms_profile *profile)
{
	if (profile->output_table_r)
		precache_release(profile->output_table_r);
	if (profile->output_table_g)
		precache_release(profile->output_table_g);
	if (profile->output_table_b)
		precache_release(profile->output_table_b);

	if (profile->A2B0)
		lut_release(profile->A2B0);
	if (profile->B2A0)
		lut_release(profile->B2A0);

	if (profile->mAB)
		mAB_release(profile->mAB);
	if (profile->mBA)
		mAB_release(profile->mBA);

	free(profile->redTRC);
	free(profile->blueTRC);
	free(profile->greenTRC);
	free(profile->grayTRC);
	free(profile);
}


#include <stdio.h>
static void qcms_data_from_file(FILE *file, void **mem, size_t *size)
{
	uint32_t length, remaining_length;
	size_t read_length;
	be32 length_be;
	void *data;

	*mem = NULL;
	*size = 0;

	if (fread(&length_be, 1, sizeof(length_be), file) != sizeof(length_be))
		return;

	length = be32_to_cpu(length_be);
	if (length > MAX_PROFILE_SIZE || length < sizeof(length_be))
		return;

	/* allocate room for the entire profile */
	data = malloc(length);
	if (!data)
		return;

	/* copy in length to the front so that the buffer will contain the entire profile */
	*((be32*)data) = length_be;
	remaining_length = length - sizeof(length_be);

	/* read the rest profile */
	read_length = fread((unsigned char*)data + sizeof(length_be), 1, remaining_length, file);
	if (read_length != remaining_length) {
		free(data);
		return;
	}

	/* successfully get the profile.*/
	*mem = data;
	*size = length;
}

qcms_profile* qcms_profile_from_file(FILE *file)
{
	size_t length;
	qcms_profile *profile;
	void *data;

	qcms_data_from_file(file, &data, &length);
	if ((data == NULL) || (length == 0))
		return INVALID_PROFILE;

	profile = qcms_profile_from_memory(data, length);
	free(data);
	return profile;
}

qcms_profile* qcms_profile_from_path(const char *path)
{
	qcms_profile *profile = NULL;
	FILE *file = fopen(path, "rb");
	if (file) {
		profile = qcms_profile_from_file(file);
		fclose(file);
	}
	return profile;
}

void qcms_data_from_path(const char *path, void **mem, size_t *size)
{
	FILE *file = NULL;
	*mem = NULL;
	*size  = 0;
	
	file = fopen(path, "rb");
	if (file) {
		qcms_data_from_file(file, mem, size);
		fclose(file);
	}
}

#ifdef _WIN32
/* Unicode path version */
qcms_profile* qcms_profile_from_unicode_path(const wchar_t *path)
{
	qcms_profile *profile = NULL;
	FILE *file = _wfopen(path, L"rb");
	if (file) {
		profile = qcms_profile_from_file(file);
		fclose(file);
	}
	return profile;
}

void qcms_data_from_unicode_path(const wchar_t *path, void **mem, size_t *size)
{
	FILE *file = NULL;
	*mem = NULL;
	*size  = 0;
	
	file = _wfopen(path, L"rb");
	if (file) {
		qcms_data_from_file(file, mem, size);
		fclose(file);
	}
}
#endif

/*
* This function constructs an ICC profile memory with given header and tag data,
* which can be read via qcms_profile_from_memory(). that means, we must satisfy
* the profiler header type check (which seems not complete till now) and proper
* information to read data from the tag table and tag data elements memory.
* 
* To construct a valid ICC profile, its divided into three steps :
*	(1) construct the r/g/bXYZ part
*	(2) construct the r/g/bTRC part
*	(3) construct the profile header
* this is a hardcode step just for "create_rgb_with_gamma", it is the only
* requirement till now, maybe we can make this method more general in future,
*
* NOTE : some of the parameters below are hardcode, please refer to the ICC documentation.
*/
#define ICC_PROFILE_HEADER_LENGTH 128
void qcms_data_create_rgb_with_gamma(qcms_CIE_xyY white_point, qcms_CIE_xyYTRIPLE primaries, float gamma, void **mem, size_t *size)
{
	uint32_t length, index, xyz_count, trc_count;
	size_t tag_table_offset, tag_data_offset;
	void *data;
	struct matrix colorants;

	uint32_t TAG_XYZ[3] = {TAG_rXYZ, TAG_gXYZ, TAG_bXYZ};
	uint32_t TAG_TRC[3] = {TAG_rTRC, TAG_gTRC, TAG_bTRC};

	if ((mem == NULL) || (size == NULL))
		return;

	*mem = NULL;
	*size = 0;

	/* 
	* total length = icc profile header(128) + tag count(4) + 
	* (tag table item (12) * total tag (6 = 3 rTRC + 3 rXYZ)) + rTRC elements data (3 * 20)
	* + rXYZ elements data (3*16), and all tag data elements must start at the 4-byte boundary.
	*/
	xyz_count = 3; // rXYZ, gXYZ, bXYZ
	trc_count = 3; // rTRC, gTRC, bTRC
	length =  ICC_PROFILE_HEADER_LENGTH + 4 + (12 * (xyz_count + trc_count)) + (xyz_count * 20) + (trc_count * 16);
	
	// reserve the total memory.
	data = malloc(length);
	if (!data)
		return;
	memset(data, 0, length);

	// Part1 : write rXYZ, gXYZ and bXYZ
	if (!get_rgb_colorants(&colorants, white_point, primaries)) {
		free(data);
		return;
	}

	 // the position of first tag's signature in tag table
	tag_table_offset = ICC_PROFILE_HEADER_LENGTH + 4;
	tag_data_offset = ICC_PROFILE_HEADER_LENGTH + 4 +
	   (12 * (xyz_count + trc_count)); // the start of tag data elements.

	for (index = 0; index < xyz_count; ++index) {
		// tag table
		write_u32(data, tag_table_offset, TAG_XYZ[index]);
		write_u32(data, tag_table_offset+4, tag_data_offset);
		write_u32(data, tag_table_offset+8, 20); // 20 bytes per TAG_(r/g/b)XYZ tag element

		// tag data element
		write_u32(data, tag_data_offset, XYZ_TYPE);
		// reserved 4 bytes.
		write_u32(data, tag_data_offset+8, double_to_s15Fixed16Number(colorants.m[0][index]));
		write_u32(data, tag_data_offset+12, double_to_s15Fixed16Number(colorants.m[1][index]));
		write_u32(data, tag_data_offset+16, double_to_s15Fixed16Number(colorants.m[2][index]));

		tag_table_offset += 12;
		tag_data_offset += 20;
	}

	// Part2 : write rTRC, gTRC and bTRC
	for (index = 0; index < trc_count; ++index) {
		// tag table
		write_u32(data, tag_table_offset, TAG_TRC[index]);
		write_u32(data, tag_table_offset+4, tag_data_offset);
		write_u32(data, tag_table_offset+8, 14); // 14 bytes per TAG_(r/g/b)TRC element

		// tag data element
		write_u32(data, tag_data_offset, CURVE_TYPE);
		// reserved 4 bytes.
		write_u32(data, tag_data_offset+8, 1); // count
		write_u16(data, tag_data_offset+12, float_to_u8Fixed8Number(gamma));

		tag_table_offset += 12;
		tag_data_offset += 16;
	}

	/* Part3 : write profile header
	 *
	 * Important header fields are left empty. This generates a profile for internal use only.
	 * We should be generating: Profile version (04300000h), Profile signature (acsp), 
	 * PCS illumiant field. Likewise mandatory profile tags are omitted.
	 */
	write_u32(data, 0, length); // the total length of this memory
	write_u32(data, 12, DISPLAY_DEVICE_PROFILE); // profile->class_type
	write_u32(data, 16, RGB_SIGNATURE); // profile->color_space
	write_u32(data, 20, XYZ_SIGNATURE); // profile->pcs
	write_u32(data, 64, QCMS_INTENT_PERCEPTUAL); // profile->rendering_intent

	write_u32(data, ICC_PROFILE_HEADER_LENGTH, 6); // total tag count

	// prepare the result
	*mem = data;
	*size = length;
}
