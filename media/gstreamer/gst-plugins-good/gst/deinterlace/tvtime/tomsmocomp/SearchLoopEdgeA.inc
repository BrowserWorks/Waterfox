// -*- c++ -*-

// Searches 2 pixel to the left and right, in both the old
//  and new fields, but takes averages. These are even
// pixel addresses. Chroma match will be used. (YUY2)
        MERGE4PIXavg("-4(%%"XDI")", "4(%%"XSI", %%"XCX", 2)")  // up left, down right
        MERGE4PIXavg("4(%%"XDI")", "-4(%%"XSI", %%"XCX", 2)")  // up right, down left
        MERGE4PIXavg("-4(%%"XDI", %%"XCX")", "4(%%"XSI", %%"XCX")") // left, right
        MERGE4PIXavg("4(%%"XDI", %%"XCX")", "-4(%%"XSI", %%"XCX")") // right, left
        MERGE4PIXavg("-4(%%"XDI", %%"XCX", 2)", "4(%%"XSI")")   // down left, up right
        MERGE4PIXavg("4(%%"XDI", %%"XCX", 2)", "-4(%%"XSI")")   // down right, up left
