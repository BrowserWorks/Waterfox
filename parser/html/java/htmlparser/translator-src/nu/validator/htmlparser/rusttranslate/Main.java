/* ***** BEGIN LICENSE BLOCK *****
 * Version: MPL 1.1/GPL 2.0/LGPL 2.1
 *
 * The contents of this file are subject to the Mozilla Public License Version
 * 1.1 (the "License"); you may not use this file except in compliance with
 * the License. You may obtain a copy of the License at
 * http://www.mozilla.org/MPL/
 *
 * Software distributed under the License is distributed on an "AS IS" basis,
 * WITHOUT WARRANTY OF ANY KIND, either express or implied. See the License
 * for the specific language governing rights and limitations under the
 * License.
 *
 * The Original Code is HTML Parser Rust Translator code.
 *
 * The Initial Developer of the Original Code is
 * Mozilla Foundation.
 * Portions created by the Initial Developer are Copyright (C) 2012
 * the Initial Developer. All Rights Reserved.
 *
 * Contributor(s):
 *   Henri Sivonen <hsivonen@iki.fi>
 *
 * Alternatively, the contents of this file may be used under the terms of
 * either the GNU General Public License Version 2 or later (the "GPL"), or
 * the GNU Lesser General Public License Version 2.1 or later (the "LGPL"),
 * in which case the provisions of the GPL or the LGPL are applicable instead
 * of those above. If you wish to allow use of your version of this file only
 * under the terms of either the GPL or the LGPL, and not to allow others to
 * use your version of this file under the terms of the MPL, indicate your
 * decision by deleting the provisions above and replace them with the notice
 * and other provisions required by the GPL or the LGPL. If you do not delete
 * the provisions above, a recipient may use your version of this file under
 * the terms of any one of the MPL, the GPL or the LGPL.
 *
 * ***** END LICENSE BLOCK ***** */

package nu.validator.htmlparser.rusttranslate;

import japa.parser.JavaParser;
import japa.parser.ParseException;
import japa.parser.ast.CompilationUnit;
import japa.parser.ast.visitor.DumpVisitor;

import java.io.File;
import java.io.FileInputStream;
import java.io.FileNotFoundException;
import java.io.FileOutputStream;
import java.io.IOException;
import java.io.InputStreamReader;
import java.io.OutputStreamWriter;
import java.io.UnsupportedEncodingException;

import nu.validator.htmlparser.cpptranslate.CppOnlyInputStream;
import nu.validator.htmlparser.cpptranslate.LicenseExtractor;
import nu.validator.htmlparser.cpptranslate.NoCppInputStream;

public class Main {

    private static final String[] CLASSLIST = {
        "Tokenizer",
        "TreeBuilder",
        "MetaScanner",
        "AttributeName",
        "ElementName",
        "HtmlAttributes",
        "StackNode",
        "UTF16Buffer",
        "StateSnapshot",
    };
    
    /**
     * @param args
     * @throws ParseException 
     * @throws IOException 
     */
    public static void main(String[] args) throws ParseException, IOException {
        File javaDirectory = new File(args[0]);
        File targetDirectory = new File(args[1]);
        
        for (int i = 0; i < CLASSLIST.length; i++) {
            parseFile(javaDirectory, targetDirectory, CLASSLIST[i], ".java");
        }
    }

    private static void parseFile(File javaDirectory,
            File targetDirectory, String className, String fne)
            throws FileNotFoundException, UnsupportedEncodingException,
            IOException {
        File file = null;
//        try {
//            file = new File(javaDirectory, className + ".java");
//            String license = new LicenseExtractor(file).extract();
//            CompilationUnit cu = JavaParser.parse(new FileInputStream(file), "utf-8");
//
//            ModeFallThroughRemover mftr = new ModeFallThroughRemover();
//            cu.accept(mftr, null);
//
//            DuplicatingFallThroughRemover dftr = new DuplicatingFallThroughRemover();
//            cu.accept(dftr, null);
//            
//            JavaVisitor visitor = new JavaVisitor();
//            cu.accept(visitor, null);
//            FileOutputStream out = new FileOutputStream(new File(targetDirectory,
//                    className + fne));
//            OutputStreamWriter w = new OutputStreamWriter(out, "utf-8");
//            w.write(license);
//            w.write("\n\n/*\n * THIS IS A GENERATED FILE. PLEASE DO NOT EDIT.\n * Please edit "
//                    + className + ".java instead and regenerate.\n */\n\n");
//            w.write(visitor.getSource());
//            w.close();
//        } catch (ParseException e) {
//            System.err.println(file);
//            e.printStackTrace();
//        }
        try {
            file = new File(javaDirectory, className + ".java");
            String license = new LicenseExtractor(file).extract();
            CompilationUnit cu = JavaParser.parse(new NoCppInputStream(
                    new CppOnlyInputStream(new FileInputStream(file))), "utf-8");

            ModeFallThroughRemover mftr = new ModeFallThroughRemover();
            cu.accept(mftr, null);

            DuplicatingFallThroughRemover dftr = new DuplicatingFallThroughRemover();
            cu.accept(dftr, null);
            
            RustVisitor visitor = new RustVisitor();
            cu.accept(visitor, null);
            FileOutputStream out = new FileOutputStream(new File(targetDirectory,
                    className + ".rs"));
            OutputStreamWriter w = new OutputStreamWriter(out, "utf-8");
            w.write(license);
            w.write("\n\n/*\n * THIS IS A GENERATED FILE. PLEASE DO NOT EDIT.\n * Please edit "
                    + className + ".java instead and regenerate.\n */\n\n");
            w.write(visitor.getSource());
            w.close();
        } catch (ParseException e) {
            System.err.println(file);
            e.printStackTrace();
        }
    }

}
