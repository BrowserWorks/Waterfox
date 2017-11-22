/* This Source Code Form is subject to the terms of the Mozilla Public
 * License, v. 2.0. If a copy of the MPL was not distributed with this
 * file, You can obtain one at http://mozilla.org/MPL/2.0/. */
#define TH_UNICODE

#include <stdlib.h>
#include <stdint.h>
#include <assert.h>
#include "th_char.h"
#define th_isalpha(c)   (((c)>='a'&&(c)<='z')||((c)>='A'&&(c)<='Z'))
#define th_isspace(c)   ((c)==' '||(c)=='\t')


/*
/////////////////////////////////////////////////
// Thai character type array
*/

typedef unsigned short twb_t;
extern const twb_t _TwbType[0x100-0xa0];

/*
// bit definition
*/

#define VRS 0x0001
#define VRE 0x0002
#define VRX 0x0004

#define VRA 0x0008

#define VLA 0x0010
#define VLO 0x0020
#define VLI 0x0040

#define VC 0x0080

#define CC 0x0100
#define CS 0x0200

#define C2 0x0400
#define CHB 0x0800
#define CHE 0x1000

#define MT 0x2000
/*
//_#define me 0x2000
*/
#define M 0x4000

#define T 0x8000

#define VL	(VLA|VLO|VLI)
#define VR	(VRS|VRE|VRX)
#define NE	(VL|VRS)
#define NB	(VR|M)
#define V	(VL|VR)
#define CX	(CC|CS)
#define C	(CX|VC)
#define A (C|V|M)

#define twbtype(c)	(_TwbType[th_zcode(c)])

#ifndef TRUE
#define TRUE 1
#define FALSE 0
#endif
#define RETURN(b) return (b)


/*
/////////////////////////////////////////////////
*/

int TrbWordBreakPos(const th_char *pstr, int left,
                    const th_char *rstr, int right)
/*                 const ThBreakIterator *it, const th_char **p)*/
{
	/*
	//int left, right;
	//const th_char *s = *p;
	*/
    const th_char *lstr = pstr + left;
	th_char _c[6];
	twb_t _t[6];
	#define c(i) (_c[(i)+3])
	#define t(i) (_t[(i)+3])
	int i, j;

	/*
	//left = s - it->begin;
	*/
	if(left < 0) return -1;
	/*
        //right = (it->end == NULL) ? 4 : it->begin - s;
	*/
	if(right < 1) return -1;

        /*
	// get c(0), t(0)
        */
	c(0) = rstr[0]; /* may be '\0' */
    if(!th_isthai(c(0))) return -1;
	t(0) = twbtype(c(0));
	if(!(t(0) & A)) return -1;

        /*
	// get c(-1), t(-1)
        */
	if(left >= 1) {
		c(-1) = lstr[-1];
		if(!th_isthai(c(-1))) return 0;
		t(-1) = twbtype(c(-1));
		if(!(t(-1) & A)) return 0;	/* handle punctuation marks here */
	} else { c(-1) = 0; t(-1) = 0; }

	/*
	// get c(1..2), t(1..2)
	*/
	for(i = 1; i <= 2; i++) {
		if(i >= right) { c(i) = 0; t(i) = 0; }
		else {
			c(i) = rstr[i]; /* may be '\0'; */
			if(!th_isthai(c(i))) right = i--;
			else {
				t(i) = twbtype(c(i));
				if(!(t(i) & A)) right = i--;
			}
		}
	}
	/*
	// get c(-2..-3), t(-2..-3)
	*/
	for(i = -2, j = -2; i >= -3 ; j--) {
		if(j < -left) { c(i) = 0; t(i) = 0; i--; }
		else {
			c(i) = lstr[j];
			if(!th_isthai(c(i))) left = 0;
			else {
				t(i) = (twb_t)(th_isthai(c(i)) ? twbtype(c(i)) : 0);
				if(!(t(i) & A)) left = 0;
				else {
					if((t(i+1) & MT) && ((t(i) & VR) || (t(i+2) & VR))) {
						c(i+1) = c(i); t(i+1) = t(i);
					} else i--;
				}
			}
		}
	}

	/*
	// prohibit the unlikely
	*/
	if((t(-1) & C) && (t(0) & C)) {
	  if((t(-1) & CHE) || (t(0) & CHB)) return -1;
	}
	/*
	// special case : vlao, C/ sara_a|aa, !sara_a
	*/
	if((t(-3) & (VLA|VLO)) && (t(-2) & C) && (c(0) != TH_SARA_A) &&
		(c(-1) == TH_SARA_A || c(-0) == TH_SARA_AA)) return 0;

	/*
	// prohibit break
	*/
	if(t(0) & NB) return -1;
	if(t(-1) & NE) return -1;


  /*
	// apply 100% rules
  */
	if(t(-1) & VRE) {
		if(c(-2) == TH_SARA_AA && c(-1) == TH_SARA_A) return 0;
		return -1; /* usually too short syllable, part of word */
	}

	if(t(-2) & VRE) return -1;

	if((t(0) & C) && (t(1) & (VR|MT)) && (c(2) != TH_THANTHAKHAT)) { /*?C, NB */
		if((t(-1) & (VRS|VRX))  && c(1) == TH_SARA_I) return -1; /* exception */
		if(t(-1) & (V|M)) return 0; /* !C/ C, NB */
		if(t(-2) & VRS) return 0;	/* VRS, C / C, NB */
		if(!(t(0) & C2) && c(1) == TH_SARA_I) {	/*	/ !C2 or /c, sara_i */
			if(t(-2) & VRX) return 0; /* VRX, C / C, NB ? 100%? */
			if(t(-2) & VC) return 0;	/* VC, C / C, NB ? 100% */
		}
	}
	if((t(-1) & VRX) && (t(0) & CC)) return 0;				/* VRX/ CC */
	if((t(-2) & VRS) && (t(-1) & C) && (t(0) & (V|M))) return 0;/* VRS, C/ !C */


	if((t(0) & CX) && (t(1) & C2) && (c(2) != TH_THANTHAKHAT)) {
		if((t(-2) & A) && (t(-1) & CX)) return 0; /* A, CX / CX, C2 */
		if((t(-2) & CX) && (t(-1) & MT)) return 0; /* CX, MT / CX, C2 */
	}
	/*
	// apply 90% rules
	*/
	if(t(0) & VL) return 0;
	if(t(1) & VL) return -1;
	if(c(-1) == TH_THANTHAKHAT && c(-2) != TH_RORUA && c(-2) != TH_LOLING) return 0;

	/*
	//return -1;
	// apply 80% rules
	*/
	if(t(0) & CHE) {
		if((t(-2) & VRS) && (t(-1) & C)) return 0;	/* VRS, C/ CHE */
		/*if(t(-1) & VRX) return 0;					// VRX/ CHE */
		if(t(-1) & VC) return 0;					/* VC/ CHE */
	}
	if(t(-1) & CHB) {
		if((t(0) & C) && (t(1) & VR)) return 0;	/* CHB/ CC, VR */
		if(t(0) & VC) return 0;					/* CHB/ VC */
	}

	if((t(-2) & VL) && (t(1) & VR)) { /* VL, C? C, VR */
		if(t(-2) & VLI) return 0;  /* VLI,C/C,VR .*/
		else { /* vlao, C ? C , VR */
			if(c(1) == TH_SARA_A) return 2; /* vlao, C, C, sara_a/ */
			if(t(-2) & VLO) return 0; /* VLO, C/ C, !sara_a */
			if(!(t(1) & VRA)) return 0;	/* VLA, C/ C, !vca */
		}
	}
	/* C,MT,C */
	if((t(-2) & C) && (t(-1) & MT) && (t(0) & CX)) return 1;

	return -1;
}


int TrbFollowing(const th_char *begin, int length, int offset)
/*
//(ThBreakIterator *this, int offset)
*/
{
	const th_char *w = begin + offset;
    const th_char *end = begin + length;
	while(w < end && *w && !th_isthai(*w) && th_isspace(*w)) w++;

	if(w < end && *w && !th_isthai(*w)) {
		int english = FALSE;
		while(w < end && *w && !th_isthai(*w) && !th_isspace(*w)) {
			if(th_isalpha(*w)) english = TRUE;
			w++;
		}
		if(english || w == end ||
            (!th_isthai(*w) && th_isspace(*w))) return w - begin;
	}
	if(w == end || *w == 0 || !th_isthai(*w)) return w - begin;
	w++;
	if(w < end && *w && th_isthai(*w)) {
		int brk = TrbWordBreakPos(begin, w-begin, w, end-w);
		while (brk < 0) {
			w++;
			if(w == end || *w == 0 || !th_isthai(*w)) break;
			brk = TrbWordBreakPos(begin, w-begin, w, end-w);
		}
        if (brk > 0) w += brk;
	}
	if(w < end && *w && !th_isthai(*w)) {
		while(w < end && *w && !th_isthai(*w) &&
            !th_isalpha(*w) && !th_isspace(*w)) w++;
	}
	return w - begin;
}


/*
/////////////////////////////////////////////////
*/
const twb_t  _TwbType[0x100-0xa0] = {
#if 0
/* 80 � */	T,
/* 81-8f */	0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,
/* 90 � */	T,
/* 91-9f */	0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,
#endif
/* a0 � */	0,
/* a1 � */	CS,
/* a2 � */	CS | CHE,
/* a3 � */	CC | CHE,
/* a4 � */	CS | CHE,
/* a5 � */	CC | CHE,
/* a6 � */	CS,
/* a7 � */	CS | CHB,
/* a8 � */	CS,
/* a9 � */	CC | CHE,
/* aa � */	CS,
/* ab � */	CC | CHE,
/* ac � */	CC | CHB | CHE,
/* ad � */	CS | CHB,
/* ae � */	CS | CHB,
/* af � */	CS | CHB,
/* b0 � */	CS,
/* b1 � */	CS | CHB | CHE,
/* b2 � */	CS | CHB | CHE,
/* b3 � */	CS | CHB,
/* b4 � */	CS,
/* b5 � */	CS,
/* b6 � */	CS,
/* b7 � */	CS,
/* b8 � */	CS,
/* b9 � */	CS,
/* ba � */	CS,
/* bb � */	CS,
/* bc � */	CC | CHE,
/* bd � */	CC | CHE,
/* be � */	CS,
/* bf � */	CS,
/* c0 � */	CS | CHE,
/* c1 � */	CS,
/* c2 � */	CS,
/* c3 � */	CS | C2 | CHE, /* ? add CHE  */
/* c4 � */	VC | CHE,
/* c5 � */	CS | C2,
/* c6 � */	VC | CHE,
/* c7 � */	VC | C2,
/* c8 � */	CS,
/* c9 � */	CS | CHB,
/* ca � */	CS | CHE,
/* cb � */	CC | CHE,
/* CC � */	CS | CHB | CHE,
/* cd � */	VC,
/* ce � */	CC | CHE,
/* cf � */	T,
/* d0 � */	VRE | VRA,
/* d1  � */	VRS,
/* d2 � */	VRX | VRA,
/* d3  � */	VRE,
/* d4  � */	VRX | VRA,
/* d5  � */	VRX | VRA,
/* d6  � */	VRS,
/* d7  � */	VRS | VRA,
/* d8  � */	VRX,
/* d9  � */	VRX,
/* da  � */	T,
/* db � */ 0,
/* dc � */ 0,
/* dd � */ 0,
/* de � */ 0,
/* df � */	T,
/* e0 � */	VLA,
/* e1 � */	VLO,
/* e2 � */	VLO,
/* e3 � */	VLI,
/* e4 � */	VLI,
/* e5 � */	VRE,
/* e6 � */	M,
/* e7  � */	M,
/* e8  � */	M | MT,
/* e9  � */	M | MT,
/* ea  � */	M | MT,
/* eb  � */	M | MT,
/* ec  � */	M,
/* ed  � */	T,
/* ee  � */	T,
/* ef � */	T,
/* f0 � */	T,
/* f1 � */	T,
/* f2 � */	T,
/* f3 � */	T,
/* f4 � */	T,
/* f5 � */	T,
/* f6 � */	T,
/* f7 � */	T,
/* f8 � */	T,
/* f9 � */	T,
/* fa � */	T,
/* fb � */	T,
/* fc � */ 0,
/* fd � */ 0,
/* fe � */ 0,
/* ff � */ 0
};
