if {![package vsatisfies [package provide Tcl] 8]} return
if {[info sharedlibextension] != ".dll"} return
if {[info exists ::tcl_platform(debug)]} {
    package ifneeded registry 1.2.2 \
            [list load [file join $dir tclreg12g.dll] registry]
} else {
    package ifneeded registry 1.2.2 \
            [list load [file join $dir tclreg12.dll] registry]
}
