+-------------------------------------------------------------------------------+
|  Java 1.5 parser and Abstract Syntax Tree.                                    |
+-------------------------------------------------------------------------------+
|  Copyright (C) 2007 Júlio Vilmar Gesser                                       |
|  jgesser@gmail.com                                                            |
|  http://code.google.com/p/javaparser/                                         |
+-------------------------------------------------------------------------------+
|  This program is free software: you can redistribute it and/or modify         |
|  it under the terms of the GNU Lesser General Public License as published by  |
|  the Free Software Foundation, either version 3 of the License, or            |
|  (at your option) any later version.                                          |
|                                                                               |
|  This program is distributed in the hope that it will be useful,              |
|  but WITHOUT ANY WARRANTY; without even the implied warranty of               |
|  MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the                |
|  GNU Lesser General Public License for more details.                          |
|                                                                               |
|  You should have received a copy of the GNU Lesser General Public License     |
|  along with this program.  If not, see <http://www.gnu.org/licenses/>.        |
+-------------------------------------------------------------------------------+    

This package contains a Java 1.5 Parser with AST generation and visitor support. 
The AST records the source code structure, javadoc and comments. Soon will be 
possible change the AST nodes or create new ones to modify source code like refactoring.
This parser is based on Sreenivasa Viswanadha Java 1.5 parser.

Visit the project site, there you can get help, view some sample codes, report 
bugs and feature enhacement and download the latest version:
 	http://code.google.com/p/javaparser/


Version history
---------------

1.0.6 (2009-01-11)
- Issue 11 fixed: changed method get/setPakage to get/setPackage in the class CompilationUnit
- Created new visitor adapter to help AST modification: ModifierVisitorAdapter
- Changed visitor adapters to abstract  

1.0.5 (2008-10-26)
- Created simplified constructors in the nodes of the AST (without positional arguments) 
- Created ASTHelper class with some helpful methods (more methods are still needed)

1.0.4 (2008-10-07)
- Moved to javacc 4.1.
- The java_1_5.jj can be build alone without compilation errors

1.0.3 (2008-09-06)
- Removed SuperMemberAccessExpr class, it was no longer used
- Removed the methods get/setTypeArgs() from ArrayCreationExpr, this node shouldn't have these methods.
- Fixed the bug with start/end position of the nodes IntegerLiteralMinValueExpr and LongLiteralMinValueExpr  
- The methods get/setAnnotations() from all BodyDeclaration subclasses were pushed down to BodyDeclaration class 

1.0.2 (2008-07-20)
  Issue fixed: Issue 1: Add support for editing AST nodes or create new ones

1.0.1 (2008-07-01)
- Issue fixed: Issue 5: end line and end column equal to begin line and begin column

1.0.0 (2008-06-25)
- Changed version numbering, starting version 1.0.0
- Javadoc done for packages:
    - japa.parser
    - japa.parser.ast
- Corrected bug when parsing in multithread: 
    - JavaParser.setCacheParser(false) must be called before to use the parser concurrent 

2008-06-19
- No code changes, added binary distribution to download page 

2008-06-11
- Bug corrected: NPE in VoidVisitorAdapter 
	- http://code.google.com/p/javaparser/issues/detail?id=2

2008-06-09
- Added Adapters for de visitors

2008-05-28
- This project now is published at Google Code:
	- http://code.google.com/p/javaparser/

2008-05-25
- Added support for comments and javadoc to the tree. 
	- Javadocs are stored directly to members (BodyDeclaration and all deriveds (classes, methods, fields, etc.)), accessible by the method getJavadoc().
	- All comments are stored in the CompilationUnit, accessible by the method getComments().

2008-04-01
- Changed all nodes public attributes to be private and created getters to access them
- Changed the methods of the Node getLine e getColumn to getBeginLine and getBeginColumn
- Added the methods getEndLine and getEndColumn to the Node class (works only in the BlockNode)

2007-12-22
- Corrected ConditionalExpression bug

2007-10-21
- Added LGPL License

2007-10-21
- Bugs corrected:  
  - Created PackageDeclaration member of CompilationUnit to add suport for annotations in the package declaration
  - Parameterized anonymous constructor invocation
  - Explicit constructor invotation Type Arguments
  - ctrl+z ("\u001A") ar end of compilation unit

2007-10-09
- EnumConstantDeclaration annotation support corrected
- Parssing Java Unicode escape characters suport added

2007-10-03
- Bug corrected: "MotifComboPopup.this.super()" statement was generating parser error
	                    
2007-10-01
- Bug corrected: Casting signed primitive values
	double d = (double) -1;
	                    ^

2007-08-06
- Bug with the ingle line comments in the final of the unit corrected

2007-07-31
- Fixed the bug with the following expression:
	Class c = (int.class);

2007-06-26
- Bug fixes from Leon Poyyayil work
	- suport for hex floating point
	- unicode digits in indentifier 
	- MemberValueArrayInitializer

2007-03-09
- Long and Integer literal MIN_VALUE bug	

2007-02-24
- '\0' bug fixed	

2007-02-01
- Many bug fixes
- Added line/column to nodes