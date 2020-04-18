These scripts export the Java-to-C++ translator and the java source files that
implement the HTML5 parser.  The exported translator may be used (with no
external dependencies) to translate the exported java source files into Gecko-
compatible C++.

Hacking the translator itself still requires a working copy of the Java HTML5
parser repository, but hacking the parser (modifying the Java source files and
performing the translation) should now be possible using only files committed
to the mozilla source tree.

Run any of these scripts without arguments to receive usage instructions.

  make-translator-jar.sh: compiles the Java-to-C++ translator into a .jar file
  export-java-srcs.sh:    exports minimal java source files implementing the
                          HTML5 parser
  export-translator.sh:   exports the compiled translator and javaparser.jar
  export-all.sh:          runs the previous two scripts
  util.sh:                provides various shell utility functions to the
                          scripts listed above (does nothing if run directly)

All path arguments may be either absolute or relative.  This includes the path
to the script itself ($0), so the directory from which you run these scripts
doesn't matter.

Ben Newman (7 July 2009)
