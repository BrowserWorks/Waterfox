// -*- c++ -*-

// Searches the center vertical line above center and below, in both the old 
// and new fields, but takes averages.  These are even pixel addresses.
        MERGE4PIXavgH("(%%"XDI", %%"XCX", 2)", "(%%"XDI", %%"XCX")", "(%%"XSI", %%"XCX")", "(%%"XSI")")	// down, up
        MERGE4PIXavgH("(%%"XDI")", "(%%"XDI", %%"XCX")", "(%%"XSI", %%"XCX")", "(%%"XSI", %%"XCX", 2)")	// up, down
