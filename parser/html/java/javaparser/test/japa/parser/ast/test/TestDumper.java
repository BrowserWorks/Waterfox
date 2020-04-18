/*
 * Copyright (C) 2007 Júlio Vilmar Gesser.
 * 
 * This file is part of Java 1.5 parser and Abstract Syntax Tree.
 *
 * Java 1.5 parser and Abstract Syntax Tree is free software: you can redistribute it and/or modify
 * it under the terms of the GNU Lesser General Public License as published by
 * the Free Software Foundation, either version 3 of the License, or
 * (at your option) any later version.
 *
 * Java 1.5 parser and Abstract Syntax Tree is distributed in the hope that it will be useful,
 * but WITHOUT ANY WARRANTY; without even the implied warranty of
 * MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the
 * GNU Lesser General Public License for more details.
 *
 * You should have received a copy of the GNU Lesser General Public License
 * along with Java 1.5 parser and Abstract Syntax Tree.  If not, see <http://www.gnu.org/licenses/>.
 */
/*
 * Created on 22/11/2006
 */
package japa.parser.ast.test;

import japa.parser.ast.CompilationUnit;
import japa.parser.ast.test.classes.DumperTestClass;
import japa.parser.ast.test.classes.JavadocTestClass;
import junit.framework.TestCase;

/**
 * @author Julio Vilmar Gesser
 */
public class TestDumper extends TestCase {

    public void testDumpVisitor() throws Exception {
        String source = TestHelper.readClass("./test", DumperTestClass.class);
        CompilationUnit cu = TestHelper.parserString(source);
        assertEquals(source, cu.toString());
    }

    public void testJavadoc() throws Exception {
        String source = TestHelper.readClass("./test", JavadocTestClass.class);
        CompilationUnit cu = TestHelper.parserString(source);
        assertEquals(source, cu.toString());
        assertEquals(19, cu.getComments().size());
    }

    public void testComments() throws Exception {
        final String source_with_comment = //
        "package japa.parser.javacc;\n" + //
                "public class Teste {\n" + //
                "//line comment\n" + //
                "int a = 0;" + //
                "//line comment\r\n" + //
                "int b = 0;" + //
                "//line comment\r" + //
                "int c = 0;" + //
                "/* multi-line\n comment\n*/" + //
                "int d = 0;" + //
                "/** multi-line\r\n javadoc\n*/" + //
                "int e = 0;" + //
                "}\n" + //
                "//final comment" + //
                "";
        final String source_without_comment = //
        "package japa.parser.javacc;\n" + //
                "\n" + //
                "public class Teste {\n" + //
                "\n" + //
                "    int a = 0;\n" + //
                "\n" + //
                "    int b = 0;\n" + //
                "\n" + //
                "    int c = 0;\n" + //
                "\n" + //
                "    int d = 0;\n" + //
                "\n" + //
                "    /** multi-line\r\n javadoc\n*/\n" + //
                "    int e = 0;\n" + //
                "}\n" + //
                "";

        CompilationUnit cu = TestHelper.parserString(source_with_comment);
        assertEquals(source_without_comment, cu.toString());
        assertEquals(6, cu.getComments().size());
    }
}