// -*- c++ -*-

// Searches 1 pixel to the left and right, in both the old
//  and new fields, but takes averages. These are odd
// pixel addresses. Any chroma match will not be used. (YUY2)
        MERGE4PIXavg("-2(%%"XDI")", "2(%%"XSI", %%"XCX", 2)")  // up left, down right
        MERGE4PIXavg("2(%%"XDI")", "-2(%%"XSI", %%"XCX", 2)")  // up right, down left
        MERGE4PIXavg("-2(%%"XDI", %%"XCX", 2)", "2(%%"XSI")")   // down left, up right
        MERGE4PIXavg("2(%%"XDI", %%"XCX", 2)", "-2(%%"XSI")")   // down right, up left   
#include "SearchLoopOddA2.inc"
