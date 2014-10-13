// -*- c++ -*-

#ifdef SEARCH_EFFORT_FUNC
#undef SEARCH_EFFORT_FUNC
#endif

#ifdef USE_STRANGE_BOB
#define SEARCH_EFFORT_FUNC(n) SEFUNC(n##SB)
#else
#define SEARCH_EFFORT_FUNC(n) SEFUNC(n)
#endif

static inline int SEARCH_EFFORT_FUNC(0)		// we don't try at all ;-)
{
		//see Search_Effort_Max() for comments
#define SKIP_SEARCH
#include "SearchLoopTop.inc"
#include "SearchLoopBottom.inc"
#undef SKIP_SEARCH
}

static inline int SEARCH_EFFORT_FUNC(1)
{
#ifdef IS_C
#define SKIP_SEARCH
#include "SearchLoopTop.inc"
#include "SearchLoopBottom.inc"
#undef SKIP_SEARCH
#else
		//see Search_Effort_Max() for comments
#include "SearchLoopTop.inc"
	RESET_CHROMA		// pretend chroma diffs was 255 each
#include "SearchLoop0A.inc"
#include "SearchLoopBottom.inc"
#endif
}

static inline int SEARCH_EFFORT_FUNC(3)
{
#ifdef IS_C
#define SKIP_SEARCH
#include "SearchLoopTop.inc"
#include "SearchLoopBottom.inc"
#undef SKIP_SEARCH
#else
		//see Search_Effort_Max() for comments
#include "SearchLoopTop.inc"
#include "SearchLoopOddA2.inc"
	RESET_CHROMA		// pretend chroma diffs was 255 each
#include "SearchLoop0A.inc"
#include "SearchLoopBottom.inc"
#endif
}

static inline int SEARCH_EFFORT_FUNC(5)
{
#ifdef IS_C
#define SKIP_SEARCH
#include "SearchLoopTop.inc"
#include "SearchLoopBottom.inc"
#undef SKIP_SEARCH
#else
		//see Search_Effort_Max() for comments
#include "SearchLoopTop.inc"
#include "SearchLoopOddA2.inc"
#include "SearchLoopOddAH2.inc"
	RESET_CHROMA		// pretend chroma diffs was 255 each
#include "SearchLoop0A.inc"
#include "SearchLoopBottom.inc"
#endif
}

// 3x3 search
static inline int SEARCH_EFFORT_FUNC(9)
{
#ifdef IS_C
#define SKIP_SEARCH
#include "SearchLoopTop.inc"
#include "SearchLoopBottom.inc"
#undef SKIP_SEARCH
#else
		//see SearchEffortMax() for comments
#include "SearchLoopTop.inc"
#include "SearchLoopOddA.inc"
	RESET_CHROMA			// pretend chroma diffs was 255 each
#include "SearchLoopVA.inc"
#include "SearchLoop0A.inc"
#include "SearchLoopBottom.inc"
#endif
}

// Search 9 with 2 H-half pels added
static inline int SEARCH_EFFORT_FUNC(11)
{
#ifdef IS_C
#define SKIP_SEARCH
#include "SearchLoopTop.inc"
#include "SearchLoopBottom.inc"
#undef SKIP_SEARCH
#else
		//see SearchEffortMax() for comments
#include "SearchLoopTop.inc"
#include "SearchLoopOddA.inc"
#include "SearchLoopOddAH2.inc"
	RESET_CHROMA			// pretend chroma diffs was 255 each
#include "SearchLoopVA.inc"
#include "SearchLoop0A.inc"
#include "SearchLoopBottom.inc"
#endif
}

// Search 11 with 2 V-half pels added
static inline int SEARCH_EFFORT_FUNC(13)
{
#ifdef IS_C
#define SKIP_SEARCH
#include "SearchLoopTop.inc"
#include "SearchLoopBottom.inc"
#undef SKIP_SEARCH
#else
		//see SearchEffortMax() for comments
#include "SearchLoopTop.inc"
#include "SearchLoopOddA.inc"
#include "SearchLoopOddAH2.inc"
	RESET_CHROMA			// pretend chroma diffs was 255 each
#include "SearchLoopVAH.inc"
#include "SearchLoopVA.inc"
#include "SearchLoop0A.inc"
#include "SearchLoopBottom.inc"
#endif
}

// 5x3
static inline int SEARCH_EFFORT_FUNC(15)
{
#ifdef IS_C
#define SKIP_SEARCH
#include "SearchLoopTop.inc"
#include "SearchLoopBottom.inc"
#undef SKIP_SEARCH
#else
		//see SearchEffortMax() for comments
#include "SearchLoopTop.inc"
#include "SearchLoopOddA.inc"
	RESET_CHROMA			// pretend chroma diffs was 255 each
#include "SearchLoopEdgeA.inc"
#include "SearchLoopVA.inc"
#include "SearchLoop0A.inc"
#include "SearchLoopBottom.inc"
#endif
}

// 5x3 + 4 half pels
static inline int SEARCH_EFFORT_FUNC(19)
{
#ifdef IS_C
#define SKIP_SEARCH
#include "SearchLoopTop.inc"
#include "SearchLoopBottom.inc"
#undef SKIP_SEARCH
#else
		//see SearchEffortMax() for comments
#include "SearchLoopTop.inc"
#include "SearchLoopOddA.inc"
#include "SearchLoopOddAH2.inc"
	RESET_CHROMA			// pretend chroma diffs was 255 each
#include "SearchLoopEdgeA.inc"
#include "SearchLoopVAH.inc"
#include "SearchLoopVA.inc"
#include "SearchLoop0A.inc"
#include "SearchLoopBottom.inc"
#endif
}

// Handle one 4x1 block of pixels
// Search a 7x3 area, no half pels

static inline int SEARCH_EFFORT_FUNC(21)
{
#ifdef IS_C
#define SKIP_SEARCH
#include "SearchLoopTop.inc"
#include "SearchLoopBottom.inc"
#undef SKIP_SEARCH
#else
		//see SearchLoopTop.inc for comments
#include "SearchLoopTop.inc"

		// odd addresses -- the pixels at odd address wouldn't generate
		// good luma values but we will mask those off

#include "SearchLoopOddA6.inc"  // 4 odd v half pels, 3 to left & right
#include "SearchLoopOddA.inc"   // 6 odd pels, 1 to left & right

	RESET_CHROMA		// pretend chroma diffs was 255 each

		// even addresses -- use both luma and chroma from these
		// search averages of 2 pixels left and right
#include "SearchLoopEdgeA.inc"
		// search vertical line and averages, -1,0,+1
#include "SearchLoopVA.inc"
		// blend our results and loop
#include "SearchLoop0A.inc"
#include "SearchLoopBottom.inc"
#endif
}

// Handle one 4x1 block of pixels
// Search a 9x3 area, no half pels
static inline int SEARCH_EFFORT_FUNC(Max)
{
#ifdef IS_C
#define SKIP_SEARCH
#include "SearchLoopTop.inc"
#include "SearchLoopBottom.inc"
#undef SKIP_SEARCH
#else
		//see SearchLoopTop.inc for comments
#include "SearchLoopTop.inc"

		// odd addresses -- the pixels at odd address wouldn't generate
		// good luma values but we will mask those off

#include "SearchLoopOddA6.inc"  // 4 odd v half pels, 3 to left & right
#include "SearchLoopOddA.inc"   // 6 odd pels, 1 to left & right

	RESET_CHROMA		// pretend chroma diffs was 255 each

		// even addresses -- use both luma and chroma from these
		// search averages of 4 pixels left and right
#include "SearchLoopEdgeA8.inc"
		// search averages of 2 pixels left and right
#include "SearchLoopEdgeA.inc"
		// search vertical line and averages, -1,0,+1
#include "SearchLoopVA.inc"
		// blend our results and loop
#include "SearchLoop0A.inc"
#include "SearchLoopBottom.inc"
#endif
}

#undef SEARCH_EFFORT_FUNC

