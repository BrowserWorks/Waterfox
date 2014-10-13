// -*- c++ -*-

// Searches 3 pixels to the left and right, in both the old
//  and new fields, but takes averages. These are odd
// pixel addresses. Any chroma match will not be used. (YUY2)
        MERGE4PIXavg("-6(%%"XDI")", "6(%%"XSI", %%"XCX", 2)")  // up left, down right
        MERGE4PIXavg("6(%%"XDI")", "-6(%%"XSI", %%"XCX", 2)")  // up right, down left
        MERGE4PIXavg("-6(%%"XDI", %%"XCX")", "6(%%"XSI", %%"XCX")") // left, right
        MERGE4PIXavg("6(%%"XDI", %%"XCX")", "-6(%%"XSI", %%"XCX")") // right, left
        MERGE4PIXavg("-6(%%"XDI", %%"XCX", 2)", "6(%%"XSI")")   // down left, up right
        MERGE4PIXavg("6(%%"XDI", %%"XCX", 2)", "-6(%%"XSI")")   // down right, up left
