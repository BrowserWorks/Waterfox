// Searches 1 pixel to the left and right, in both the old
//  and new fields, but takes v-half pel averages. These are odd
// pixel addresses. Any chroma match will not be used. (YUY2)
		__asm
		{
        MERGE4PIXavgH("XDI"-2, "XDI"+"XCX"-2, "XSI"+"XCX"+2, "XSI"+2*"XCX"+2)  // up left, down right
        MERGE4PIXavgH("XDI"+2, "XDI"+"XCX"+2, "XSI"+"XCX"-2, "XSI"+2*"XCX"-2)   // up right, down left
        MERGE4PIXavgH("XDI"+2*"XCX"-2, "XDI"+"XCX"-2, "XSI"+"XCX"+2, "XSI"+2)   // down left, up right
        MERGE4PIXavgH("XDI"+2*"XCX"+2, "XDI"+"XCX"+2, "XSI"+"XCX"-2, "XSI"-2)   // down right, up left   
		}
