// -*- c++ -*-

// Searches the center vertical line above center and below, in both the old 
// and new fields, but takes averages.  These are even pixel addresses.
        MERGE4PIXavg("(%%"XDI", %%"XCX", 2)", "(%%"XSI")")	// down, up
        MERGE4PIXavg("(%%"XDI")", "(%%"XSI", %%"XCX", 2)")	// up, down
