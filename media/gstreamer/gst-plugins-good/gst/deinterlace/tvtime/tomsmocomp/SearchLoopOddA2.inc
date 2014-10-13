// Searches 1 pixel to the left and right, in both the old
// and new fields, but takes averages. These are odd
// pixel addresses. Any chroma match will not be used. (YUY2)
        MERGE4PIXavg("-2(%%"XDI", %%"XCX")", "2(%%"XSI", %%"XCX")") // left, right
        MERGE4PIXavg("2(%%"XDI", %%"XCX")", "-2(%%"XSI", %%"XCX")") // right, left
