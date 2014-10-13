// -*- c++ -*-

// Searches 4 pixel to the left and right, in both the old
//  and new fields, but takes averages. These are even
// pixel addresses. Chroma match will be used. (YUY2)
        MERGE4PIXavg("-8(%%"XDI")", "8(%%"XSI", %%"XCX", 2)")  // up left, down right
        MERGE4PIXavg("8(%%"XDI")", "-8(%%"XSI", %%"XCX", 2)")  // up right, down left
        MERGE4PIXavg("-8(%%"XDI", %%"XCX")", "8(%%"XSI", %%"XCX")") // left, right
        MERGE4PIXavg("8(%%"XDI", %%"XCX")", "-8(%%"XSI", %%"XCX")") // right, left
        MERGE4PIXavg("-8(%%"XDI", %%"XCX", 2)", "8(%%"XSI")")   // down left, up right
        MERGE4PIXavg("8(%%"XDI", %%"XCX", 2)", "-8(%%"XSI")")   // down right, up left

