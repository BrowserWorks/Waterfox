/* vim: set ts=8 sw=8 noexpandtab: */
//  qcms
//  Copyright (C) 2009 Mozilla Corporation
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

#include <stdlib.h>
#include <math.h>
#include <assert.h>
#include <string.h> //memcpy
#include "qcmsint.h"
#include "chain.h"
#include "matrix.h"
#include "transform_util.h"

/* for MSVC, GCC, Intel, and Sun compilers */
#if defined(_M_IX86) || defined(__i386__) || defined(__i386) || defined(_M_AMD64) || defined(__x86_64__) || defined(__x86_64)
#define X86
#endif /* _M_IX86 || __i386__ || __i386 || _M_AMD64 || __x86_64__ || __x86_64 */

/**
 * AltiVec detection for PowerPC CPUs
 * In case we have a method of detecting do the runtime detection.
 * Otherwise statically choose the AltiVec path in case the compiler
 * was told to build with AltiVec support.
 */
#if (defined(__POWERPC__) || defined(__powerpc__))
#if defined(__linux__)
#include <unistd.h>
#include <fcntl.h>
#include <stdio.h>
#include <elf.h>
#include <linux/auxvec.h>
#include <asm/cputable.h>
#include <link.h>

static inline bool have_altivec() {
	static int available = -1;
	int new_avail = 0;
        ElfW(auxv_t) auxv;
	ssize_t count;
	int fd, i;

	if (available != -1)
		return (available != 0 ? true : false);

	fd = open("/proc/self/auxv", O_RDONLY);
	if (fd < 0)
		goto out;
	do {
		count = read(fd, &auxv, sizeof(auxv));
		if (count < 0)
			goto out_close;

		if (auxv.a_type == AT_HWCAP) {
			new_avail = !!(auxv.a_un.a_val & PPC_FEATURE_HAS_ALTIVEC);
			goto out_close;
		}
	} while (auxv.a_type != AT_NULL);

out_close:
	close(fd);
out:
	available = new_avail;
	return (available != 0 ? true : false);
}
#elif defined(__APPLE__) && defined(__MACH__)
#include <sys/sysctl.h>

/**
 * rip-off from ffmpeg AltiVec detection code.
 * this code also appears on Apple's AltiVec pages.
 */
static inline bool have_altivec() {
	int sels[2] = {CTL_HW, HW_VECTORUNIT};
	static int available = -1;
	size_t len = sizeof(available);
	int err;

	if (available != -1)
		return (available != 0 ? true : false);

	err = sysctl(sels, 2, &available, &len, NULL, 0);

	if (err == 0)
		if (available != 0)
			return true;

	return false;
}
#elif defined(__ALTIVEC__) || defined(__APPLE_ALTIVEC__)
#define have_altivec() true
#else
#define have_altivec() false
#endif
#endif // (defined(__POWERPC__) || defined(__powerpc__))

// Build a White point, primary chromas transfer matrix from RGB to CIE XYZ
// This is just an approximation, I am not handling all the non-linear
// aspects of the RGB to XYZ process, and assumming that the gamma correction
// has transitive property in the tranformation chain.
//
// the alghoritm:
//
//            - First I build the absolute conversion matrix using
//              primaries in XYZ. This matrix is next inverted
//            - Then I eval the source white point across this matrix
//              obtaining the coeficients of the transformation
//            - Then, I apply these coeficients to the original matrix
static struct matrix build_RGB_to_XYZ_transfer_matrix(qcms_CIE_xyY white, qcms_CIE_xyYTRIPLE primrs)
{
	struct matrix primaries;
	struct matrix primaries_invert;
	struct matrix result;
	struct vector white_point;
	struct vector coefs;

	double xn, yn;
	double xr, yr;
	double xg, yg;
	double xb, yb;

	xn = white.x;
	yn = white.y;

	if (yn == 0.0)
		return matrix_invalid();

	xr = primrs.red.x;
	yr = primrs.red.y;
	xg = primrs.green.x;
	yg = primrs.green.y;
	xb = primrs.blue.x;
	yb = primrs.blue.y;

	primaries.m[0][0] = xr;
	primaries.m[0][1] = xg;
	primaries.m[0][2] = xb;

	primaries.m[1][0] = yr;
	primaries.m[1][1] = yg;
	primaries.m[1][2] = yb;

	primaries.m[2][0] = 1 - xr - yr;
	primaries.m[2][1] = 1 - xg - yg;
	primaries.m[2][2] = 1 - xb - yb;
	primaries.invalid = false;

	white_point.v[0] = xn/yn;
	white_point.v[1] = 1.;
	white_point.v[2] = (1.0-xn-yn)/yn;

	primaries_invert = matrix_invert(primaries);
	if (primaries_invert.invalid) {
		return matrix_invalid();
	}

	coefs = matrix_eval(primaries_invert, white_point);

	result.m[0][0] = coefs.v[0]*xr;
	result.m[0][1] = coefs.v[1]*xg;
	result.m[0][2] = coefs.v[2]*xb;

	result.m[1][0] = coefs.v[0]*yr;
	result.m[1][1] = coefs.v[1]*yg;
	result.m[1][2] = coefs.v[2]*yb;

	result.m[2][0] = coefs.v[0]*(1.-xr-yr);
	result.m[2][1] = coefs.v[1]*(1.-xg-yg);
	result.m[2][2] = coefs.v[2]*(1.-xb-yb);
	result.invalid = primaries_invert.invalid;

	return result;
}

struct CIE_XYZ {
	double X;
	double Y;
	double Z;
};

/* CIE Illuminant D50 */
static const struct CIE_XYZ D50_XYZ = {
	0.9642,
	1.0000,
	0.8249
};

/* from lcms: xyY2XYZ()
 * corresponds to argyll: icmYxy2XYZ() */
static struct CIE_XYZ xyY2XYZ(qcms_CIE_xyY source)
{
	struct CIE_XYZ dest;
	dest.X = (source.x / source.y) * source.Y;
	dest.Y = source.Y;
	dest.Z = ((1 - source.x - source.y) / source.y) * source.Y;
	return dest;
}

/* from lcms: ComputeChromaticAdaption */
// Compute chromatic adaption matrix using chad as cone matrix
static struct matrix
compute_chromatic_adaption(struct CIE_XYZ source_white_point,
                           struct CIE_XYZ dest_white_point,
                           struct matrix chad)
{
	struct matrix chad_inv;
	struct vector cone_source_XYZ, cone_source_rgb;
	struct vector cone_dest_XYZ, cone_dest_rgb;
	struct matrix cone, tmp;

	tmp = chad;
	chad_inv = matrix_invert(tmp);
	if (chad_inv.invalid) {
		return matrix_invalid();
	}

	cone_source_XYZ.v[0] = source_white_point.X;
	cone_source_XYZ.v[1] = source_white_point.Y;
	cone_source_XYZ.v[2] = source_white_point.Z;

	cone_dest_XYZ.v[0] = dest_white_point.X;
	cone_dest_XYZ.v[1] = dest_white_point.Y;
	cone_dest_XYZ.v[2] = dest_white_point.Z;

	cone_source_rgb = matrix_eval(chad, cone_source_XYZ);
	cone_dest_rgb   = matrix_eval(chad, cone_dest_XYZ);

	cone.m[0][0] = cone_dest_rgb.v[0]/cone_source_rgb.v[0];
	cone.m[0][1] = 0;
	cone.m[0][2] = 0;
	cone.m[1][0] = 0;
	cone.m[1][1] = cone_dest_rgb.v[1]/cone_source_rgb.v[1];
	cone.m[1][2] = 0;
	cone.m[2][0] = 0;
	cone.m[2][1] = 0;
	cone.m[2][2] = cone_dest_rgb.v[2]/cone_source_rgb.v[2];
	cone.invalid = false;

	// Normalize
	return matrix_multiply(chad_inv, matrix_multiply(cone, chad));
}

/* from lcms: cmsAdaptionMatrix */
// Returns the final chrmatic adaptation from illuminant FromIll to Illuminant ToIll
// Bradford is assumed
static struct matrix
adaption_matrix(struct CIE_XYZ source_illumination, struct CIE_XYZ target_illumination)
{
	struct matrix lam_rigg = {{ // Bradford matrix
	                         {  0.8951f,  0.2664f, -0.1614f },
	                         { -0.7502f,  1.7135f,  0.0367f },
	                         {  0.0389f, -0.0685f,  1.0296f }
	                         }};
	return compute_chromatic_adaption(source_illumination, target_illumination, lam_rigg);
}

/* from lcms: cmsAdaptMatrixToD50 */
static struct matrix adapt_matrix_to_D50(struct matrix r, qcms_CIE_xyY source_white_pt)
{
	struct CIE_XYZ Dn;
	struct matrix Bradford;

	if (source_white_pt.y == 0.0) {
		return matrix_invalid();
	}

	Dn = xyY2XYZ(source_white_pt);

	Bradford = adaption_matrix(Dn, D50_XYZ);
	if (Bradford.invalid) {
		return matrix_invalid();
	}
	return matrix_multiply(Bradford, r);
}

bool set_rgb_colorants(qcms_profile *profile, qcms_CIE_xyY white_point, qcms_CIE_xyYTRIPLE primaries)
{
	struct matrix colorants;
	colorants = build_RGB_to_XYZ_transfer_matrix(white_point, primaries);
	colorants = adapt_matrix_to_D50(colorants, white_point);

	if (colorants.invalid)
		return false;

	/* note: there's a transpose type of operation going on here */
	profile->redColorant.X = double_to_s15Fixed16Number(colorants.m[0][0]);
	profile->redColorant.Y = double_to_s15Fixed16Number(colorants.m[1][0]);
	profile->redColorant.Z = double_to_s15Fixed16Number(colorants.m[2][0]);

	profile->greenColorant.X = double_to_s15Fixed16Number(colorants.m[0][1]);
	profile->greenColorant.Y = double_to_s15Fixed16Number(colorants.m[1][1]);
	profile->greenColorant.Z = double_to_s15Fixed16Number(colorants.m[2][1]);

	profile->blueColorant.X = double_to_s15Fixed16Number(colorants.m[0][2]);
	profile->blueColorant.Y = double_to_s15Fixed16Number(colorants.m[1][2]);
	profile->blueColorant.Z = double_to_s15Fixed16Number(colorants.m[2][2]);

	return true;
}

bool get_rgb_colorants(struct matrix *colorants, qcms_CIE_xyY white_point, qcms_CIE_xyYTRIPLE primaries)
{
	*colorants = build_RGB_to_XYZ_transfer_matrix(white_point, primaries);
	*colorants = adapt_matrix_to_D50(*colorants, white_point);

	return (colorants->invalid ? true : false);
}

#if 0
static void qcms_transform_data_rgb_out_pow(const qcms_transform *transform, const unsigned char *src, unsigned char *dest, size_t length)
{
	int i;
	const float (*mat)[4] = transform->matrix;
	for (i=0; i<length; i++) {
		unsigned char device_r = *src++;
		unsigned char device_g = *src++;
		unsigned char device_b = *src++;

		float linear_r = transform->input_gamma_table_r[device_r];
		float linear_g = transform->input_gamma_table_g[device_g];
		float linear_b = transform->input_gamma_table_b[device_b];

		float out_linear_r = mat[0][0]*linear_r + mat[1][0]*linear_g + mat[2][0]*linear_b;
		float out_linear_g = mat[0][1]*linear_r + mat[1][1]*linear_g + mat[2][1]*linear_b;
		float out_linear_b = mat[0][2]*linear_r + mat[1][2]*linear_g + mat[2][2]*linear_b;

		float out_device_r = pow(out_linear_r, transform->out_gamma_r);
		float out_device_g = pow(out_linear_g, transform->out_gamma_g);
		float out_device_b = pow(out_linear_b, transform->out_gamma_b);

		dest[OUTPUT_R_INDEX] = clamp_u8(255*out_device_r);
		dest[OUTPUT_G_INDEX] = clamp_u8(255*out_device_g);
		dest[OUTPUT_B_INDEX] = clamp_u8(255*out_device_b);
		dest += RGB_OUTPUT_COMPONENTS;
	}
}
#endif

/* Alpha is not corrected.
   A rationale for this is found in Alvy Ray's "Should Alpha Be Nonlinear If
   RGB Is?" Tech Memo 17 (December 14, 1998).
	See: ftp://ftp.alvyray.com/Acrobat/17_Nonln.pdf
*/

template <size_t kRIndex, size_t kGIndex, size_t kBIndex,
          size_t kInAIndex = NO_A_INDEX, size_t kOutAIndex = kInAIndex>
static void qcms_transform_data_gray_template_lut(const qcms_transform *transform, const unsigned char *src, unsigned char *dest, size_t length)
{
	const unsigned int components = A_INDEX_COMPONENTS(kOutAIndex);
	unsigned int i;
	for (i = 0; i < length; i++) {
		float out_device_r, out_device_g, out_device_b;
		unsigned char device = *src++;
		unsigned char alpha = 0xFF;
		if (kInAIndex != NO_A_INDEX) {
			alpha = *src++;
		}

		float linear = transform->input_gamma_table_gray[device];

                out_device_r = lut_interp_linear(linear, transform->output_gamma_lut_r, transform->output_gamma_lut_r_length);
		out_device_g = lut_interp_linear(linear, transform->output_gamma_lut_g, transform->output_gamma_lut_g_length);
		out_device_b = lut_interp_linear(linear, transform->output_gamma_lut_b, transform->output_gamma_lut_b_length);

		dest[kRIndex] = clamp_u8(out_device_r*255);
		dest[kGIndex] = clamp_u8(out_device_g*255);
		dest[kBIndex] = clamp_u8(out_device_b*255);
		if (kOutAIndex != NO_A_INDEX) {
			dest[kOutAIndex] = alpha;
		}
		dest += components;
	}
}

static void qcms_transform_data_gray_out_lut(const qcms_transform *transform, const unsigned char *src, unsigned char *dest, size_t length)
{
	qcms_transform_data_gray_template_lut<RGBA_R_INDEX, RGBA_G_INDEX, RGBA_B_INDEX>(transform, src, dest, length);
}

static void qcms_transform_data_gray_rgba_out_lut(const qcms_transform *transform, const unsigned char *src, unsigned char *dest, size_t length)
{
	qcms_transform_data_gray_template_lut<RGBA_R_INDEX, RGBA_G_INDEX, RGBA_B_INDEX, NO_A_INDEX, RGBA_A_INDEX>(transform, src, dest, length);
}

static void qcms_transform_data_gray_bgra_out_lut(const qcms_transform *transform, const unsigned char *src, unsigned char *dest, size_t length)
{
	qcms_transform_data_gray_template_lut<BGRA_R_INDEX, BGRA_G_INDEX, BGRA_B_INDEX, NO_A_INDEX, BGRA_A_INDEX>(transform, src, dest, length);
}

static void qcms_transform_data_graya_rgba_out_lut(const qcms_transform *transform, const unsigned char *src, unsigned char *dest, size_t length)
{
	qcms_transform_data_gray_template_lut<RGBA_R_INDEX, RGBA_G_INDEX, RGBA_B_INDEX, RGBA_A_INDEX>(transform, src, dest, length);
}

static void qcms_transform_data_graya_bgra_out_lut(const qcms_transform *transform, const unsigned char *src, unsigned char *dest, size_t length)
{
	qcms_transform_data_gray_template_lut<BGRA_R_INDEX, BGRA_G_INDEX, BGRA_B_INDEX, BGRA_A_INDEX>(transform, src, dest, length);
}

template <size_t kRIndex, size_t kGIndex, size_t kBIndex,
          size_t kInAIndex = NO_A_INDEX, size_t kOutAIndex = kInAIndex>
static void qcms_transform_data_gray_template_precache(const qcms_transform *transform, const unsigned char *src, unsigned char *dest, size_t length)
{
	const unsigned int components = A_INDEX_COMPONENTS(kOutAIndex);
	unsigned int i;
	for (i = 0; i < length; i++) {
		unsigned char device = *src++;
		unsigned char alpha = 0xFF;
		if (kInAIndex != NO_A_INDEX) {
		       alpha = *src++;
		}
		uint16_t gray;

		float linear = transform->input_gamma_table_gray[device];

		/* we could round here... */
		gray = linear * PRECACHE_OUTPUT_MAX;

		dest[kRIndex] = transform->output_table_r->data[gray];
		dest[kGIndex] = transform->output_table_g->data[gray];
		dest[kBIndex] = transform->output_table_b->data[gray];
		if (kOutAIndex != NO_A_INDEX) {
			dest[kOutAIndex] = alpha;
		}
		dest += components;
	}
}

static void qcms_transform_data_gray_out_precache(const qcms_transform *transform, const unsigned char *src, unsigned char *dest, size_t length)
{
	qcms_transform_data_gray_template_precache<RGBA_R_INDEX, RGBA_G_INDEX, RGBA_B_INDEX>(transform, src, dest, length);
}

static void qcms_transform_data_gray_rgba_out_precache(const qcms_transform *transform, const unsigned char *src, unsigned char *dest, size_t length)
{
	qcms_transform_data_gray_template_precache<RGBA_R_INDEX, RGBA_G_INDEX, RGBA_B_INDEX, NO_A_INDEX, RGBA_A_INDEX>(transform, src, dest, length);
}

static void qcms_transform_data_gray_bgra_out_precache(const qcms_transform *transform, const unsigned char *src, unsigned char *dest, size_t length)
{
	qcms_transform_data_gray_template_precache<BGRA_R_INDEX, BGRA_G_INDEX, BGRA_B_INDEX, NO_A_INDEX, BGRA_A_INDEX>(transform, src, dest, length);
}

static void qcms_transform_data_graya_rgba_out_precache(const qcms_transform *transform, const unsigned char *src, unsigned char *dest, size_t length)
{
	qcms_transform_data_gray_template_precache<RGBA_R_INDEX, RGBA_G_INDEX, RGBA_B_INDEX, RGBA_A_INDEX>(transform, src, dest, length);
}

static void qcms_transform_data_graya_bgra_out_precache(const qcms_transform *transform, const unsigned char *src, unsigned char *dest, size_t length)
{
	qcms_transform_data_gray_template_precache<BGRA_R_INDEX, BGRA_G_INDEX, BGRA_B_INDEX, BGRA_A_INDEX>(transform, src, dest, length);
}

template <size_t kRIndex, size_t kGIndex, size_t kBIndex, size_t kAIndex = NO_A_INDEX>
static void qcms_transform_data_template_lut_precache(const qcms_transform *transform, const unsigned char *src, unsigned char *dest, size_t length)
{
	const unsigned int components = A_INDEX_COMPONENTS(kAIndex);
	unsigned int i;
	const float (*mat)[4] = transform->matrix;
	for (i = 0; i < length; i++) {
		unsigned char device_r = src[kRIndex];
		unsigned char device_g = src[kGIndex];
		unsigned char device_b = src[kBIndex];
		unsigned char alpha;
		if (kAIndex != NO_A_INDEX) {
			alpha = src[kAIndex];
		}
		src += components;
		uint16_t r, g, b;

		float linear_r = transform->input_gamma_table_r[device_r];
		float linear_g = transform->input_gamma_table_g[device_g];
		float linear_b = transform->input_gamma_table_b[device_b];

		float out_linear_r = mat[0][0]*linear_r + mat[1][0]*linear_g + mat[2][0]*linear_b;
		float out_linear_g = mat[0][1]*linear_r + mat[1][1]*linear_g + mat[2][1]*linear_b;
		float out_linear_b = mat[0][2]*linear_r + mat[1][2]*linear_g + mat[2][2]*linear_b;

		out_linear_r = clamp_float(out_linear_r);
		out_linear_g = clamp_float(out_linear_g);
		out_linear_b = clamp_float(out_linear_b);

		/* we could round here... */
		r = out_linear_r * PRECACHE_OUTPUT_MAX;
		g = out_linear_g * PRECACHE_OUTPUT_MAX;
		b = out_linear_b * PRECACHE_OUTPUT_MAX;

		dest[kRIndex] = transform->output_table_r->data[r];
		dest[kGIndex] = transform->output_table_g->data[g];
		dest[kBIndex] = transform->output_table_b->data[b];
		if (kAIndex != NO_A_INDEX) {
			dest[kAIndex] = alpha;
		}
		dest += components;
	}
}

void qcms_transform_data_rgb_out_lut_precache(const qcms_transform *transform, const unsigned char *src, unsigned char *dest, size_t length)
{
	qcms_transform_data_template_lut_precache<RGBA_R_INDEX, RGBA_G_INDEX, RGBA_B_INDEX>(transform, src, dest, length);
}

void qcms_transform_data_rgba_out_lut_precache(const qcms_transform *transform, const unsigned char *src, unsigned char *dest, size_t length)
{
	qcms_transform_data_template_lut_precache<RGBA_R_INDEX, RGBA_G_INDEX, RGBA_B_INDEX, RGBA_A_INDEX>(transform, src, dest, length);
}

void qcms_transform_data_bgra_out_lut_precache(const qcms_transform *transform, const unsigned char *src, unsigned char *dest, size_t length)
{
	qcms_transform_data_template_lut_precache<BGRA_R_INDEX, BGRA_G_INDEX, BGRA_B_INDEX, BGRA_A_INDEX>(transform, src, dest, length);
}

// Not used
/* 
static void qcms_transform_data_clut(const qcms_transform *transform, const unsigned char *src, unsigned char *dest, size_t length) {
	unsigned int i;
	int xy_len = 1;
	int x_len = transform->grid_size;
	int len = x_len * x_len;
	const float* r_table = transform->r_clut;
	const float* g_table = transform->g_clut;
	const float* b_table = transform->b_clut;
  
	for (i = 0; i < length; i++) {
		unsigned char in_r = *src++;
		unsigned char in_g = *src++;
		unsigned char in_b = *src++;
		float linear_r = in_r/255.0f, linear_g=in_g/255.0f, linear_b = in_b/255.0f;

		int x = floorf(linear_r * (transform->grid_size-1));
		int y = floorf(linear_g * (transform->grid_size-1));
		int z = floorf(linear_b * (transform->grid_size-1));
		int x_n = ceilf(linear_r * (transform->grid_size-1));
		int y_n = ceilf(linear_g * (transform->grid_size-1));
		int z_n = ceilf(linear_b * (transform->grid_size-1));
		float x_d = linear_r * (transform->grid_size-1) - x; 
		float y_d = linear_g * (transform->grid_size-1) - y;
		float z_d = linear_b * (transform->grid_size-1) - z; 

		float r_x1 = lerp(CLU(r_table,x,y,z), CLU(r_table,x_n,y,z), x_d);
		float r_x2 = lerp(CLU(r_table,x,y_n,z), CLU(r_table,x_n,y_n,z), x_d);
		float r_y1 = lerp(r_x1, r_x2, y_d);
		float r_x3 = lerp(CLU(r_table,x,y,z_n), CLU(r_table,x_n,y,z_n), x_d);
		float r_x4 = lerp(CLU(r_table,x,y_n,z_n), CLU(r_table,x_n,y_n,z_n), x_d);
		float r_y2 = lerp(r_x3, r_x4, y_d);
		float clut_r = lerp(r_y1, r_y2, z_d);

		float g_x1 = lerp(CLU(g_table,x,y,z), CLU(g_table,x_n,y,z), x_d);
		float g_x2 = lerp(CLU(g_table,x,y_n,z), CLU(g_table,x_n,y_n,z), x_d);
		float g_y1 = lerp(g_x1, g_x2, y_d);
		float g_x3 = lerp(CLU(g_table,x,y,z_n), CLU(g_table,x_n,y,z_n), x_d);
		float g_x4 = lerp(CLU(g_table,x,y_n,z_n), CLU(g_table,x_n,y_n,z_n), x_d);
		float g_y2 = lerp(g_x3, g_x4, y_d);
		float clut_g = lerp(g_y1, g_y2, z_d);

		float b_x1 = lerp(CLU(b_table,x,y,z), CLU(b_table,x_n,y,z), x_d);
		float b_x2 = lerp(CLU(b_table,x,y_n,z), CLU(b_table,x_n,y_n,z), x_d);
		float b_y1 = lerp(b_x1, b_x2, y_d);
		float b_x3 = lerp(CLU(b_table,x,y,z_n), CLU(b_table,x_n,y,z_n), x_d);
		float b_x4 = lerp(CLU(b_table,x,y_n,z_n), CLU(b_table,x_n,y_n,z_n), x_d);
		float b_y2 = lerp(b_x3, b_x4, y_d);
		float clut_b = lerp(b_y1, b_y2, z_d);

		*dest++ = clamp_u8(clut_r*255.0f);
		*dest++ = clamp_u8(clut_g*255.0f);
		*dest++ = clamp_u8(clut_b*255.0f);
	}	
}
*/

static int int_div_ceil(int value, int div) {
	return ((value  + div - 1) / div);
}

// Using lcms' tetra interpolation algorithm.
template <size_t kRIndex, size_t kGIndex, size_t kBIndex, size_t kAIndex = NO_A_INDEX>
static void qcms_transform_data_tetra_clut_template(const qcms_transform *transform, const unsigned char *src, unsigned char *dest, size_t length) {
	const unsigned int components = A_INDEX_COMPONENTS(kAIndex);
	unsigned int i;
	int xy_len = 1;
	int x_len = transform->grid_size;
	int len = x_len * x_len;
	float* r_table = transform->r_clut;
	float* g_table = transform->g_clut;
	float* b_table = transform->b_clut;
	float c0_r, c1_r, c2_r, c3_r;
	float c0_g, c1_g, c2_g, c3_g;
	float c0_b, c1_b, c2_b, c3_b;
	float clut_r, clut_g, clut_b;
	for (i = 0; i < length; i++) {
		unsigned char in_r = src[kRIndex];
		unsigned char in_g = src[kGIndex];
		unsigned char in_b = src[kBIndex];
		unsigned char in_a;
		if (kAIndex != NO_A_INDEX) {
			in_a = src[kAIndex];
		}
		src += components;
		float linear_r = in_r/255.0f, linear_g=in_g/255.0f, linear_b = in_b/255.0f;

		int x = in_r * (transform->grid_size-1) / 255;
		int y = in_g * (transform->grid_size-1) / 255;
		int z = in_b * (transform->grid_size-1) / 255;
		int x_n = int_div_ceil(in_r * (transform->grid_size-1), 255);
		int y_n = int_div_ceil(in_g * (transform->grid_size-1), 255);
		int z_n = int_div_ceil(in_b * (transform->grid_size-1), 255);
		float rx = linear_r * (transform->grid_size-1) - x; 
		float ry = linear_g * (transform->grid_size-1) - y;
		float rz = linear_b * (transform->grid_size-1) - z; 

		c0_r = CLU(r_table, x, y, z);
		c0_g = CLU(g_table, x, y, z);
		c0_b = CLU(b_table, x, y, z);

		if( rx >= ry ) {
			if (ry >= rz) { //rx >= ry && ry >= rz
				c1_r = CLU(r_table, x_n, y, z) - c0_r;
				c2_r = CLU(r_table, x_n, y_n, z) - CLU(r_table, x_n, y, z);
				c3_r = CLU(r_table, x_n, y_n, z_n) - CLU(r_table, x_n, y_n, z);
				c1_g = CLU(g_table, x_n, y, z) - c0_g;
				c2_g = CLU(g_table, x_n, y_n, z) - CLU(g_table, x_n, y, z);
				c3_g = CLU(g_table, x_n, y_n, z_n) - CLU(g_table, x_n, y_n, z);
				c1_b = CLU(b_table, x_n, y, z) - c0_b;
				c2_b = CLU(b_table, x_n, y_n, z) - CLU(b_table, x_n, y, z);
				c3_b = CLU(b_table, x_n, y_n, z_n) - CLU(b_table, x_n, y_n, z);
			} else { 
				if (rx >= rz) { //rx >= rz && rz >= ry
					c1_r = CLU(r_table, x_n, y, z) - c0_r;
					c2_r = CLU(r_table, x_n, y_n, z_n) - CLU(r_table, x_n, y, z_n);
					c3_r = CLU(r_table, x_n, y, z_n) - CLU(r_table, x_n, y, z);
					c1_g = CLU(g_table, x_n, y, z) - c0_g;
					c2_g = CLU(g_table, x_n, y_n, z_n) - CLU(g_table, x_n, y, z_n);
					c3_g = CLU(g_table, x_n, y, z_n) - CLU(g_table, x_n, y, z);
					c1_b = CLU(b_table, x_n, y, z) - c0_b;
					c2_b = CLU(b_table, x_n, y_n, z_n) - CLU(b_table, x_n, y, z_n);
					c3_b = CLU(b_table, x_n, y, z_n) - CLU(b_table, x_n, y, z);
				} else { //rz > rx && rx >= ry
					c1_r = CLU(r_table, x_n, y, z_n) - CLU(r_table, x, y, z_n);
					c2_r = CLU(r_table, x_n, y_n, z_n) - CLU(r_table, x_n, y, z_n);
					c3_r = CLU(r_table, x, y, z_n) - c0_r;
					c1_g = CLU(g_table, x_n, y, z_n) - CLU(g_table, x, y, z_n);
					c2_g = CLU(g_table, x_n, y_n, z_n) - CLU(g_table, x_n, y, z_n);
					c3_g = CLU(g_table, x, y, z_n) - c0_g;
					c1_b = CLU(b_table, x_n, y, z_n) - CLU(b_table, x, y, z_n);
					c2_b = CLU(b_table, x_n, y_n, z_n) - CLU(b_table, x_n, y, z_n);
					c3_b = CLU(b_table, x, y, z_n) - c0_b;
				}
			}
		} else {
			if (rx >= rz) { //ry > rx && rx >= rz
				c1_r = CLU(r_table, x_n, y_n, z) - CLU(r_table, x, y_n, z);
				c2_r = CLU(r_table, x, y_n, z) - c0_r;
				c3_r = CLU(r_table, x_n, y_n, z_n) - CLU(r_table, x_n, y_n, z);
				c1_g = CLU(g_table, x_n, y_n, z) - CLU(g_table, x, y_n, z);
				c2_g = CLU(g_table, x, y_n, z) - c0_g;
				c3_g = CLU(g_table, x_n, y_n, z_n) - CLU(g_table, x_n, y_n, z);
				c1_b = CLU(b_table, x_n, y_n, z) - CLU(b_table, x, y_n, z);
				c2_b = CLU(b_table, x, y_n, z) - c0_b;
				c3_b = CLU(b_table, x_n, y_n, z_n) - CLU(b_table, x_n, y_n, z);
			} else {
				if (ry >= rz) { //ry >= rz && rz > rx 
					c1_r = CLU(r_table, x_n, y_n, z_n) - CLU(r_table, x, y_n, z_n);
					c2_r = CLU(r_table, x, y_n, z) - c0_r;
					c3_r = CLU(r_table, x, y_n, z_n) - CLU(r_table, x, y_n, z);
					c1_g = CLU(g_table, x_n, y_n, z_n) - CLU(g_table, x, y_n, z_n);
					c2_g = CLU(g_table, x, y_n, z) - c0_g;
					c3_g = CLU(g_table, x, y_n, z_n) - CLU(g_table, x, y_n, z);
					c1_b = CLU(b_table, x_n, y_n, z_n) - CLU(b_table, x, y_n, z_n);
					c2_b = CLU(b_table, x, y_n, z) - c0_b;
					c3_b = CLU(b_table, x, y_n, z_n) - CLU(b_table, x, y_n, z);
				} else { //rz > ry && ry > rx
					c1_r = CLU(r_table, x_n, y_n, z_n) - CLU(r_table, x, y_n, z_n);
					c2_r = CLU(r_table, x, y_n, z_n) - CLU(r_table, x, y, z_n);
					c3_r = CLU(r_table, x, y, z_n) - c0_r;
					c1_g = CLU(g_table, x_n, y_n, z_n) - CLU(g_table, x, y_n, z_n);
					c2_g = CLU(g_table, x, y_n, z_n) - CLU(g_table, x, y, z_n);
					c3_g = CLU(g_table, x, y, z_n) - c0_g;
					c1_b = CLU(b_table, x_n, y_n, z_n) - CLU(b_table, x, y_n, z_n);
					c2_b = CLU(b_table, x, y_n, z_n) - CLU(b_table, x, y, z_n);
					c3_b = CLU(b_table, x, y, z_n) - c0_b;
				}
			}
		}
				
		clut_r = c0_r + c1_r*rx + c2_r*ry + c3_r*rz;
		clut_g = c0_g + c1_g*rx + c2_g*ry + c3_g*rz;
		clut_b = c0_b + c1_b*rx + c2_b*ry + c3_b*rz;

		dest[kRIndex] = clamp_u8(clut_r*255.0f);
		dest[kGIndex] = clamp_u8(clut_g*255.0f);
		dest[kBIndex] = clamp_u8(clut_b*255.0f);
		if (kAIndex != NO_A_INDEX) {
			dest[kAIndex] = in_a;
		}
		dest += components;
	}	
}

static void qcms_transform_data_tetra_clut_rgb(const qcms_transform *transform, const unsigned char *src, unsigned char *dest, size_t length) {
	qcms_transform_data_tetra_clut_template<RGBA_R_INDEX, RGBA_G_INDEX, RGBA_B_INDEX>(transform, src, dest, length);
}

static void qcms_transform_data_tetra_clut_rgba(const qcms_transform *transform, const unsigned char *src, unsigned char *dest, size_t length) {
	qcms_transform_data_tetra_clut_template<RGBA_R_INDEX, RGBA_G_INDEX, RGBA_B_INDEX, RGBA_A_INDEX>(transform, src, dest, length);
}

static void qcms_transform_data_tetra_clut_bgra(const qcms_transform *transform, const unsigned char *src, unsigned char *dest, size_t length) {
	qcms_transform_data_tetra_clut_template<BGRA_R_INDEX, BGRA_G_INDEX, BGRA_B_INDEX, BGRA_A_INDEX>(transform, src, dest, length);
}

template <size_t kRIndex, size_t kGIndex, size_t kBIndex, size_t kAIndex = NO_A_INDEX>
static void qcms_transform_data_template_lut(const qcms_transform *transform, const unsigned char *src, unsigned char *dest, size_t length)
{
	const unsigned int components = A_INDEX_COMPONENTS(kAIndex);
	unsigned int i;
	const float (*mat)[4] = transform->matrix;
	for (i = 0; i < length; i++) {
		unsigned char device_r = src[kRIndex];
		unsigned char device_g = src[kGIndex];
		unsigned char device_b = src[kBIndex];
		unsigned char alpha;
		if (kAIndex != NO_A_INDEX) {
			alpha = src[kAIndex];
		}
		src += components;
		float out_device_r, out_device_g, out_device_b;

		float linear_r = transform->input_gamma_table_r[device_r];
		float linear_g = transform->input_gamma_table_g[device_g];
		float linear_b = transform->input_gamma_table_b[device_b];

		float out_linear_r = mat[0][0]*linear_r + mat[1][0]*linear_g + mat[2][0]*linear_b;
		float out_linear_g = mat[0][1]*linear_r + mat[1][1]*linear_g + mat[2][1]*linear_b;
		float out_linear_b = mat[0][2]*linear_r + mat[1][2]*linear_g + mat[2][2]*linear_b;

		out_linear_r = clamp_float(out_linear_r);
		out_linear_g = clamp_float(out_linear_g);
		out_linear_b = clamp_float(out_linear_b);

		out_device_r = lut_interp_linear(out_linear_r, 
				transform->output_gamma_lut_r, transform->output_gamma_lut_r_length);
		out_device_g = lut_interp_linear(out_linear_g, 
				transform->output_gamma_lut_g, transform->output_gamma_lut_g_length);
		out_device_b = lut_interp_linear(out_linear_b, 
				transform->output_gamma_lut_b, transform->output_gamma_lut_b_length);

		dest[kRIndex] = clamp_u8(out_device_r*255);
		dest[kGIndex] = clamp_u8(out_device_g*255);
		dest[kBIndex] = clamp_u8(out_device_b*255);
		if (kAIndex != NO_A_INDEX) {
			dest[kAIndex] = alpha;
		}
		dest += components;
	}
}

void qcms_transform_data_rgb_out_lut(const qcms_transform *transform, const unsigned char *src, unsigned char *dest, size_t length)
{
	qcms_transform_data_template_lut<RGBA_R_INDEX, RGBA_G_INDEX, RGBA_B_INDEX>(transform, src, dest, length);
}

void qcms_transform_data_rgba_out_lut(const qcms_transform *transform, const unsigned char *src, unsigned char *dest, size_t length)
{
	qcms_transform_data_template_lut<RGBA_R_INDEX, RGBA_G_INDEX, RGBA_B_INDEX, RGBA_A_INDEX>(transform, src, dest, length);
}

void qcms_transform_data_bgra_out_lut(const qcms_transform *transform, const unsigned char *src, unsigned char *dest, size_t length)
{
	qcms_transform_data_template_lut<BGRA_R_INDEX, BGRA_G_INDEX, BGRA_B_INDEX, BGRA_A_INDEX>(transform, src, dest, length);
}

#if 0
static void qcms_transform_data_rgb_out_linear(const qcms_transform *transform, const unsigned char *src, unsigned char *dest, size_t length)
{
	int i;
	const float (*mat)[4] = transform->matrix;
	for (i = 0; i < length; i++) {
		unsigned char device_r = *src++;
		unsigned char device_g = *src++;
		unsigned char device_b = *src++;

		float linear_r = transform->input_gamma_table_r[device_r];
		float linear_g = transform->input_gamma_table_g[device_g];
		float linear_b = transform->input_gamma_table_b[device_b];

		float out_linear_r = mat[0][0]*linear_r + mat[1][0]*linear_g + mat[2][0]*linear_b;
		float out_linear_g = mat[0][1]*linear_r + mat[1][1]*linear_g + mat[2][1]*linear_b;
		float out_linear_b = mat[0][2]*linear_r + mat[1][2]*linear_g + mat[2][2]*linear_b;

		*dest++ = clamp_u8(out_linear_r*255);
		*dest++ = clamp_u8(out_linear_g*255);
		*dest++ = clamp_u8(out_linear_b*255);
	}
}
#endif

/*
 * If users create and destroy objects on different threads, even if the same
 * objects aren't used on different threads at the same time, we can still run
 * in to trouble with refcounts if they aren't atomic.
 *
 * This can lead to us prematurely deleting the precache if threads get unlucky
 * and write the wrong value to the ref count.
 */
static struct precache_output *precache_reference(struct precache_output *p)
{
	qcms_atomic_increment(p->ref_count);
	return p;
}

static struct precache_output *precache_create()
{
	struct precache_output *p = (struct precache_output*)malloc(sizeof(struct precache_output));
	if (p)
		p->ref_count = 1;
	return p;
}

void precache_release(struct precache_output *p)
{
	if (qcms_atomic_decrement(p->ref_count) == 0) {
		free(p);
	}
}

#ifdef HAVE_POSIX_MEMALIGN
static qcms_transform *transform_alloc(void)
{
	qcms_transform *t;

	void *allocated_memory;
	if (!posix_memalign(&allocated_memory, 16, sizeof(qcms_transform))) {
		/* Doing a memset to initialise all bits to 'zero'*/
		memset(allocated_memory, 0, sizeof(qcms_transform));
		t = (qcms_transform*)allocated_memory;
		return t;
	} else {
		return NULL;
	}
}
static void transform_free(qcms_transform *t)
{
	free(t);
}
#else
static qcms_transform *transform_alloc(void)
{
	/* transform needs to be aligned on a 16byte boundrary */
	char *original_block = (char *)calloc(sizeof(qcms_transform) + sizeof(void*) + 16, 1);
	/* make room for a pointer to the block returned by calloc */
	void *transform_start = original_block + sizeof(void*);
	/* align transform_start */
	qcms_transform *transform_aligned = (qcms_transform*)(((uintptr_t)transform_start + 15) & ~0xf);

	/* store a pointer to the block returned by calloc so that we can free it later */
	void **(original_block_ptr) = (void**)transform_aligned;
	if (!original_block)
		return NULL;
	original_block_ptr--;
	*original_block_ptr = original_block;

	return transform_aligned;
}
static void transform_free(qcms_transform *t)
{
	/* get at the pointer to the unaligned block returned by calloc */
	void **p = (void**)t;
	p--;
	free(*p);
}
#endif

void qcms_transform_release(qcms_transform *t)
{
	/* ensure we only free the gamma tables once even if there are
	 * multiple references to the same data */

	if (t->output_table_r)
		precache_release(t->output_table_r);
	if (t->output_table_g)
		precache_release(t->output_table_g);
	if (t->output_table_b)
		precache_release(t->output_table_b);

	free(t->input_gamma_table_r);
	if (t->input_gamma_table_g != t->input_gamma_table_r)
		free(t->input_gamma_table_g);
	if (t->input_gamma_table_g != t->input_gamma_table_r &&
	    t->input_gamma_table_g != t->input_gamma_table_b)
		free(t->input_gamma_table_b);

	free(t->input_gamma_table_gray);

	free(t->output_gamma_lut_r);
	free(t->output_gamma_lut_g);
	free(t->output_gamma_lut_b);

	/* r_clut points to beginning of buffer allocated in qcms_transform_precacheLUT_float */
	if (t->r_clut)
		free(t->r_clut);

	transform_free(t);
}

#ifdef X86
// Determine if we can build with SSE2 (this was partly copied from jmorecfg.h in
// mozilla/jpeg)
 // -------------------------------------------------------------------------
#if defined(_M_IX86) && defined(_MSC_VER)
#define HAS_CPUID
/* Get us a CPUID function. Avoid clobbering EBX because sometimes it's the PIC
   register - I'm not sure if that ever happens on windows, but cpuid isn't
   on the critical path so we just preserve the register to be safe and to be
   consistent with the non-windows version. */
static void cpuid(uint32_t fxn, uint32_t *a, uint32_t *b, uint32_t *c, uint32_t *d) {
       uint32_t a_, b_, c_, d_;
       __asm {
              xchg   ebx, esi
              mov    eax, fxn
              cpuid
              mov    a_, eax
              mov    b_, ebx
              mov    c_, ecx
              mov    d_, edx
              xchg   ebx, esi
       }
       *a = a_;
       *b = b_;
       *c = c_;
       *d = d_;
}
#elif (defined(__GNUC__) || defined(__SUNPRO_C)) && (defined(__i386__) || defined(__i386))
#define HAS_CPUID
/* Get us a CPUID function. We can't use ebx because it's the PIC register on
   some platforms, so we use ESI instead and save ebx to avoid clobbering it. */
static void cpuid(uint32_t fxn, uint32_t *a, uint32_t *b, uint32_t *c, uint32_t *d) {

	uint32_t a_, b_, c_, d_;
       __asm__ __volatile__ ("xchgl %%ebx, %%esi; cpuid; xchgl %%ebx, %%esi;" 
                             : "=a" (a_), "=S" (b_), "=c" (c_), "=d" (d_) : "a" (fxn));
	   *a = a_;
	   *b = b_;
	   *c = c_;
	   *d = d_;
}
#endif

// -------------------------Runtime SSEx Detection-----------------------------

/* MMX is always supported per
 *  Gecko v1.9.1 minimum CPU requirements */
#define SSE1_EDX_MASK (1UL << 25)
#define SSE2_EDX_MASK (1UL << 26)
#define SSE3_ECX_MASK (1UL <<  0)

static int sse_version_available(void)
{
#if defined(__x86_64__) || defined(__x86_64) || defined(_M_AMD64)
	/* we know at build time that 64-bit CPUs always have SSE2
	 * this tells the compiler that non-SSE2 branches will never be
	 * taken (i.e. OK to optimze away the SSE1 and non-SIMD code */
	return 2;
#elif defined(HAS_CPUID)
	static int sse_version = -1;
	uint32_t a, b, c, d;
	uint32_t function = 0x00000001;

	if (sse_version == -1) {
		sse_version = 0;
		cpuid(function, &a, &b, &c, &d);
		if (c & SSE3_ECX_MASK)
			sse_version = 3;
		else if (d & SSE2_EDX_MASK)
			sse_version = 2;
		else if (d & SSE1_EDX_MASK)
			sse_version = 1;
	}

	return sse_version;
#else
	return 0;
#endif
}
#endif

static const struct matrix bradford_matrix = {{	{ 0.8951f, 0.2664f,-0.1614f},
						{-0.7502f, 1.7135f, 0.0367f},
						{ 0.0389f,-0.0685f, 1.0296f}}, 
						false};

static const struct matrix bradford_matrix_inv = {{ { 0.9869929f,-0.1470543f, 0.1599627f},
						    { 0.4323053f, 0.5183603f, 0.0492912f},
						    {-0.0085287f, 0.0400428f, 0.9684867f}}, 
						    false};

// See ICCv4 E.3
struct matrix compute_whitepoint_adaption(float X, float Y, float Z) {
	float p = (0.96422f*bradford_matrix.m[0][0] + 1.000f*bradford_matrix.m[1][0] + 0.82521f*bradford_matrix.m[2][0]) /
		  (X*bradford_matrix.m[0][0]      + Y*bradford_matrix.m[1][0]      + Z*bradford_matrix.m[2][0]     );
	float y = (0.96422f*bradford_matrix.m[0][1] + 1.000f*bradford_matrix.m[1][1] + 0.82521f*bradford_matrix.m[2][1]) /
		  (X*bradford_matrix.m[0][1]      + Y*bradford_matrix.m[1][1]      + Z*bradford_matrix.m[2][1]     );
	float b = (0.96422f*bradford_matrix.m[0][2] + 1.000f*bradford_matrix.m[1][2] + 0.82521f*bradford_matrix.m[2][2]) /
		  (X*bradford_matrix.m[0][2]      + Y*bradford_matrix.m[1][2]      + Z*bradford_matrix.m[2][2]     );
	struct matrix white_adaption = {{ {p,0,0}, {0,y,0}, {0,0,b}}, false};
	return matrix_multiply( bradford_matrix_inv, matrix_multiply(white_adaption, bradford_matrix) );
}

void qcms_profile_precache_output_transform(qcms_profile *profile)
{
	/* we only support precaching on rgb profiles */
	if (profile->color_space != RGB_SIGNATURE)
		return;

	if (qcms_supports_iccv4) {
		/* don't precache since we will use the B2A LUT */
		if (profile->B2A0)
			return;

		/* don't precache since we will use the mBA LUT */
		if (profile->mBA)
			return;
	}

	/* don't precache if we do not have the TRC curves */
	if (!profile->redTRC || !profile->greenTRC || !profile->blueTRC)
		return;

	if (!profile->output_table_r) {
		profile->output_table_r = precache_create();
		if (profile->output_table_r &&
				!compute_precache(profile->redTRC, profile->output_table_r->data)) {
			precache_release(profile->output_table_r);
			profile->output_table_r = NULL;
		}
	}
	if (!profile->output_table_g) {
		profile->output_table_g = precache_create();
		if (profile->output_table_g &&
				!compute_precache(profile->greenTRC, profile->output_table_g->data)) {
			precache_release(profile->output_table_g);
			profile->output_table_g = NULL;
		}
	}
	if (!profile->output_table_b) {
		profile->output_table_b = precache_create();
		if (profile->output_table_b &&
				!compute_precache(profile->blueTRC, profile->output_table_b->data)) {
			precache_release(profile->output_table_b);
			profile->output_table_b = NULL;
		}
	}
}

/* Replace the current transformation with a LUT transformation using a given number of sample points */
qcms_transform* qcms_transform_precacheLUT_float(qcms_transform *transform, qcms_profile *in, qcms_profile *out, 
                                                 int samples, qcms_data_type in_type)
{
	/* The range between which 2 consecutive sample points can be used to interpolate */
	uint16_t x,y,z;
	uint32_t l;
	uint32_t lutSize = 3 * samples * samples * samples;
	float* src = NULL;
	float* dest = NULL;
	float* lut = NULL;

	src = (float*)malloc(lutSize*sizeof(float));
	dest = (float*)malloc(lutSize*sizeof(float));

	if (src && dest) {
		/* Prepare a list of points we want to sample */
		l = 0;
		for (x = 0; x < samples; x++) {
			for (y = 0; y < samples; y++) {
				for (z = 0; z < samples; z++) {
					src[l++] = x / (float)(samples-1);
					src[l++] = y / (float)(samples-1);
					src[l++] = z / (float)(samples-1);
				}
			}
		}

		lut = qcms_chain_transform(in, out, src, dest, lutSize);
		if (lut) {
			transform->r_clut = &lut[0];
			transform->g_clut = &lut[1];
			transform->b_clut = &lut[2];
			transform->grid_size = samples;
			if (in_type == QCMS_DATA_RGBA_8) {
				transform->transform_fn = qcms_transform_data_tetra_clut_rgba;
			} else if (in_type == QCMS_DATA_BGRA_8) {
				transform->transform_fn = qcms_transform_data_tetra_clut_bgra;
			} else if (in_type == QCMS_DATA_RGB_8) {
				transform->transform_fn = qcms_transform_data_tetra_clut_rgb;
			}
			assert(transform->transform_fn);
		}
	}


	//XXX: qcms_modular_transform_data may return either the src or dest buffer. If so it must not be free-ed
	// It will be stored in r_clut, which will be cleaned up in qcms_transform_release.
	if (src && lut != src) {
		free(src);
	}
	if (dest && lut != dest) {
		free(dest);
	}

	if (lut == NULL) {
		return NULL;
	}
	return transform;
}

#define NO_MEM_TRANSFORM NULL

qcms_transform* qcms_transform_create(
		qcms_profile *in, qcms_data_type in_type,
		qcms_profile *out, qcms_data_type out_type,
		qcms_intent intent)
{
	// Ensure the requested input and output types make sense.
	bool match = false;
	if (in_type == QCMS_DATA_RGB_8) {
		match = out_type == QCMS_DATA_RGB_8;
	} else if (in_type == QCMS_DATA_RGBA_8) {
		match = out_type == QCMS_DATA_RGBA_8;
	} else if (in_type == QCMS_DATA_BGRA_8) {
		match = out_type == QCMS_DATA_BGRA_8;
	} else if (in_type == QCMS_DATA_GRAY_8) {
		match = out_type == QCMS_DATA_RGB_8 || out_type == QCMS_DATA_RGBA_8 || out_type == QCMS_DATA_BGRA_8;
	} else if (in_type == QCMS_DATA_GRAYA_8) {
		match = out_type == QCMS_DATA_RGBA_8 || out_type == QCMS_DATA_BGRA_8;
	}
	if (!match) {
		assert(0 && "input/output type");
		return NULL;
	}

        qcms_transform *transform = transform_alloc();
        if (!transform) {
		return NULL;
	}

	bool precache = false;
	if (out->output_table_r &&
			out->output_table_g &&
			out->output_table_b) {
		precache = true;
	}

	// This precache assumes RGB_SIGNATURE (fails on GRAY_SIGNATURE, for instance)
	if (qcms_supports_iccv4 &&
			(in_type == QCMS_DATA_RGB_8 || in_type == QCMS_DATA_RGBA_8 || in_type == QCMS_DATA_BGRA_8) &&
			(in->A2B0 || out->B2A0 || in->mAB || out->mAB))
		{
		// Precache the transformation to a CLUT 33x33x33 in size.
		// 33 is used by many profiles and works well in pratice. 
		// This evenly divides 256 into blocks of 8x8x8.
		// TODO For transforming small data sets of about 200x200 or less
		// precaching should be avoided.
		qcms_transform *result = qcms_transform_precacheLUT_float(transform, in, out, 33, in_type);
		if (!result) {
            		assert(0 && "precacheLUT failed");
			qcms_transform_release(transform);
			return NULL;
		}
		return result;
	}

	if (precache) {
		transform->output_table_r = precache_reference(out->output_table_r);
		transform->output_table_g = precache_reference(out->output_table_g);
		transform->output_table_b = precache_reference(out->output_table_b);
	} else {
		if (!out->redTRC || !out->greenTRC || !out->blueTRC) {
			qcms_transform_release(transform);
			return NO_MEM_TRANSFORM;
		}
		build_output_lut(out->redTRC, &transform->output_gamma_lut_r, &transform->output_gamma_lut_r_length);
		build_output_lut(out->greenTRC, &transform->output_gamma_lut_g, &transform->output_gamma_lut_g_length);
		build_output_lut(out->blueTRC, &transform->output_gamma_lut_b, &transform->output_gamma_lut_b_length);
		if (!transform->output_gamma_lut_r || !transform->output_gamma_lut_g || !transform->output_gamma_lut_b) {
			qcms_transform_release(transform);
			return NO_MEM_TRANSFORM;
		}
	}

        if (in->color_space == RGB_SIGNATURE) {
		struct matrix in_matrix, out_matrix, result;
		if (precache) {
#ifdef X86
                    if (qcms_supports_avx) {
			    if (in_type == QCMS_DATA_RGB_8) {
				    transform->transform_fn = qcms_transform_data_rgb_out_lut_avx;
			    } else if (in_type == QCMS_DATA_RGBA_8) {
				    transform->transform_fn = qcms_transform_data_rgba_out_lut_avx;
			    } else if (in_type == QCMS_DATA_BGRA_8) {
				    transform->transform_fn = qcms_transform_data_bgra_out_lut_avx;
			    }
		    } else if (sse_version_available() >= 2) {
			    if (in_type == QCMS_DATA_RGB_8) {
				    transform->transform_fn = qcms_transform_data_rgb_out_lut_sse2;
			    } else if (in_type == QCMS_DATA_RGBA_8) {
				    transform->transform_fn = qcms_transform_data_rgba_out_lut_sse2;
			    } else if (in_type == QCMS_DATA_BGRA_8) {
				    transform->transform_fn = qcms_transform_data_bgra_out_lut_sse2;
			    }

#if !(defined(_MSC_VER) && defined(_M_AMD64))
                    /* Microsoft Compiler for x64 doesn't support MMX.
                     * SSE code uses MMX so that we disable on x64 */
		    } else
		    if (sse_version_available() >= 1) {
			    if (in_type == QCMS_DATA_RGB_8) {
				    transform->transform_fn = qcms_transform_data_rgb_out_lut_sse1;
			    } else if (in_type == QCMS_DATA_RGBA_8) {
				    transform->transform_fn = qcms_transform_data_rgba_out_lut_sse1;
			    } else if (in_type == QCMS_DATA_BGRA_8) {
				    transform->transform_fn = qcms_transform_data_bgra_out_lut_sse1;
			    }
#endif
		    } else
#endif
#if defined(__arm__) || defined(__aarch64__)
                    if (qcms_supports_neon) {
			    if (in_type == QCMS_DATA_RGB_8) {
				    transform->transform_fn = qcms_transform_data_rgb_out_lut_neon;
			    } else if (in_type == QCMS_DATA_RGBA_8) {
				    transform->transform_fn = qcms_transform_data_rgba_out_lut_neon;
			    } else if (in_type == QCMS_DATA_BGRA_8) {
				    transform->transform_fn = qcms_transform_data_bgra_out_lut_neon;
			    }
                    } else
#endif
#if (defined(__POWERPC__) || defined(__powerpc__) && !defined(__NO_FPRS__))
		    if (have_altivec()) {
			    if (in_type == QCMS_DATA_RGB_8) {
				    transform->transform_fn = qcms_transform_data_rgb_out_lut_altivec;
			    } else if (in_type == QCMS_DATA_RGBA_8) {
				    transform->transform_fn = qcms_transform_data_rgba_out_lut_altivec;
			    } else if (in_type == QCMS_DATA_BGRA_8) {
				    transform->transform_fn = qcms_transform_data_bgra_out_lut_altivec;
			    }
		    } else
#endif
			{
				if (in_type == QCMS_DATA_RGB_8) {
					transform->transform_fn = qcms_transform_data_rgb_out_lut_precache;
				} else if (in_type == QCMS_DATA_RGBA_8) {
					transform->transform_fn = qcms_transform_data_rgba_out_lut_precache;
				} else if (in_type == QCMS_DATA_BGRA_8) {
					transform->transform_fn = qcms_transform_data_bgra_out_lut_precache;
				}
			}
		} else {
			if (in_type == QCMS_DATA_RGB_8) {
				transform->transform_fn = qcms_transform_data_rgb_out_lut;
			} else if (in_type == QCMS_DATA_RGBA_8) {
				transform->transform_fn = qcms_transform_data_rgba_out_lut;
			} else if (in_type == QCMS_DATA_BGRA_8) {
				transform->transform_fn = qcms_transform_data_bgra_out_lut;
			}
		}

		//XXX: avoid duplicating tables if we can
		transform->input_gamma_table_r = build_input_gamma_table(in->redTRC);
		transform->input_gamma_table_g = build_input_gamma_table(in->greenTRC);
		transform->input_gamma_table_b = build_input_gamma_table(in->blueTRC);
		if (!transform->input_gamma_table_r || !transform->input_gamma_table_g || !transform->input_gamma_table_b) {
			qcms_transform_release(transform);
			return NO_MEM_TRANSFORM;
		}


		/* build combined colorant matrix */
		in_matrix = build_colorant_matrix(in);
		out_matrix = build_colorant_matrix(out);
		out_matrix = matrix_invert(out_matrix);
		if (out_matrix.invalid) {
			qcms_transform_release(transform);
			return NULL;
		}
		result = matrix_multiply(out_matrix, in_matrix);

		/* check for NaN values in the matrix and bail if we find any */
		for (unsigned i = 0 ; i < 3 ; ++i) {
			for (unsigned j = 0 ; j < 3 ; ++j) {
				if (result.m[i][j] != result.m[i][j]) {
					qcms_transform_release(transform);
					return NULL;
				}
			}
		}

		/* store the results in column major mode
		 * this makes doing the multiplication with sse easier */
		transform->matrix[0][0] = result.m[0][0];
		transform->matrix[1][0] = result.m[0][1];
		transform->matrix[2][0] = result.m[0][2];
		transform->matrix[0][1] = result.m[1][0];
		transform->matrix[1][1] = result.m[1][1];
		transform->matrix[2][1] = result.m[1][2];
		transform->matrix[0][2] = result.m[2][0];
		transform->matrix[1][2] = result.m[2][1];
		transform->matrix[2][2] = result.m[2][2];

	} else if (in->color_space == GRAY_SIGNATURE) {
		transform->input_gamma_table_gray = build_input_gamma_table(in->grayTRC);
		if (!transform->input_gamma_table_gray) {
			qcms_transform_release(transform);
			return NO_MEM_TRANSFORM;
		}

		if (precache) {
			if (out_type == QCMS_DATA_RGB_8) {
				transform->transform_fn = qcms_transform_data_gray_out_precache;
			} else if (out_type == QCMS_DATA_RGBA_8) {
				if (in_type == QCMS_DATA_GRAY_8) {
					transform->transform_fn = qcms_transform_data_gray_rgba_out_precache;
				} else {
					transform->transform_fn = qcms_transform_data_graya_rgba_out_precache;
				}
			} else if (out_type == QCMS_DATA_BGRA_8) {
				if (in_type == QCMS_DATA_GRAY_8) {
					transform->transform_fn = qcms_transform_data_gray_bgra_out_precache;
				} else {
					transform->transform_fn = qcms_transform_data_graya_bgra_out_precache;
				}
			}
		} else {
			if (out_type == QCMS_DATA_RGB_8) {
				transform->transform_fn = qcms_transform_data_gray_out_lut;
			} else if (out_type == QCMS_DATA_RGBA_8) {
				if (in_type == QCMS_DATA_GRAY_8) {
					transform->transform_fn = qcms_transform_data_gray_rgba_out_lut;
				} else {
					transform->transform_fn = qcms_transform_data_graya_rgba_out_lut;
				}
			} else if (out_type == QCMS_DATA_BGRA_8) {
				if (in_type == QCMS_DATA_GRAY_8) {
					transform->transform_fn = qcms_transform_data_gray_bgra_out_lut;
				} else {
					transform->transform_fn = qcms_transform_data_graya_bgra_out_lut;
				}
			}
		}
	} else {
		assert(0 && "unexpected colorspace");
		qcms_transform_release(transform);
		return NULL;
	}
	assert(transform->transform_fn);
	return transform;
}

#if defined(__GNUC__) && defined(__i386__)
/* we need this to avoid crashes when gcc assumes the stack is 128bit aligned */
__attribute__((__force_align_arg_pointer__))
#endif
void qcms_transform_data(qcms_transform *transform, const void *src, void *dest, size_t length)
{
	transform->transform_fn(transform, (const unsigned char*)src, (unsigned char*)dest, length);
}

bool qcms_supports_iccv4;
void qcms_enable_iccv4()
{
	qcms_supports_iccv4 = true;
}

#if defined(__arm__) || defined(__aarch64__)
bool qcms_supports_neon;
#endif
void qcms_enable_neon()
{
#if defined(__arm__) || defined(__aarch64__)
	qcms_supports_neon = true;
#endif
}

#if defined(X86)
bool qcms_supports_avx;
#endif
void qcms_enable_avx()
{
#if defined(X86)
	qcms_supports_avx = true;
#endif
}
