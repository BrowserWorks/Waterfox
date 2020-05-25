/*
 * Copyright (C) 2008 Júlio Vilmar Gesser.
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
 * Created on 05/10/2006
 */
package japa.parser;

import japa.parser.ast.CompilationUnit;

import java.io.File;
import java.io.FileInputStream;
import java.io.IOException;
import java.io.InputStream;

/**
 * <p>This class was generated automatically by javacc, do not edit.</p>
 * <p>Parse Java 1.5 source code and creates Abstract Syntax Tree classes.</p>
 * <p><b>Note:</b> To use this parser asynchronously, disable de parser cache
 * by calling the method {@link setCacheParser} with <code>false</code>
 * as argument.</p>
 *
 * @author Júlio Vilmar Gesser
 */
public final class JavaParser {

    private static ASTParser parser;

    private static boolean cacheParser = true;

    private JavaParser() {
        // hide the constructor
    }

    /**
     * Changes the way that the parser acts when starts to parse. If the 
     * parser cache is enabled, only one insance of this object will be 
     * used in every call to parse methods.
     * If this parser is intend to be used asynchonously, the cache must 
     * be disabled setting this flag to <code>false</code>.
     * By default, the cache is enabled.
     * @param value <code>false</code> to disable the parser instance cache. 
     */
    public static void setCacheParser(boolean value) {
        cacheParser = value;
        if (!value) {
            parser = null;
        }
    }

    /**
     * Parses the Java code contained in the {@link InputStream} and returns 
     * a {@link CompilationUnit} that represents it. 
     * @param in {@link InputStream} containing Java source code
     * @param encoding encoding of the source code
     * @return CompilationUnit representing the Java source code
     * @throws ParseException if the source code has parser errors
     */
    public static CompilationUnit parse(InputStream in, String encoding) throws ParseException {
        if (cacheParser) {
            if (parser == null) {
                parser = new ASTParser(in, encoding);
            } else {
                parser.reset(in, encoding);
            }
            return parser.CompilationUnit();
        }
        return new ASTParser(in, encoding).CompilationUnit();
    }

    /**
     * Parses the Java code contained in the {@link InputStream} and returns 
     * a {@link CompilationUnit} that represents it. 
     * @param in {@link InputStream} containing Java source code
     * @return CompilationUnit representing the Java source code
     * @throws ParseException if the source code has parser errors
     */
    public static CompilationUnit parse(InputStream in) throws ParseException {
        return parse(in, null);
    }

    /**
     * Parses the Java code contained in a {@link File} and returns 
     * a {@link CompilationUnit} that represents it. 
     * @param file {@link File} containing Java source code
     * @param encoding encoding of the source code
     * @return CompilationUnit representing the Java source code
     * @throws ParseException if the source code has parser errors
     * @throws IOException 
     */
    public static CompilationUnit parse(File file, String encoding) throws ParseException, IOException {
        FileInputStream in = new FileInputStream(file);
        try {
            return parse(in, encoding);
        } finally {
            in.close();
        }
    }

    /**
     * Parses the Java code contained in a {@link File} and returns 
     * a {@link CompilationUnit} that represents it. 
     * @param file {@link File} containing Java source code
     * @return CompilationUnit representing the Java source code
     * @throws ParseException if the source code has parser errors
     * @throws IOException 
     */
    public static CompilationUnit parse(File file) throws ParseException, IOException {
        return parse(file, null);
    }
}
