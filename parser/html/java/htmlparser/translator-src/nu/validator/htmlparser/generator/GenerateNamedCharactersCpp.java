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
 * The Original Code is HTML Parser C++ Translator code.
 *
 * The Initial Developer of the Original Code is
 * Mozilla Foundation.
 * Portions created by the Initial Developer are Copyright (C) 2008
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

package nu.validator.htmlparser.generator;

import java.io.BufferedReader;
import java.io.File;
import java.io.FileInputStream;
import java.io.FileOutputStream;
import java.io.IOException;
import java.io.InputStreamReader;
import java.io.OutputStreamWriter;
import java.io.Writer;
import java.util.Map;
import java.util.TreeMap;
import java.util.regex.Matcher;
import java.util.regex.Pattern;

import nu.validator.htmlparser.cpptranslate.CppTypes;

public class GenerateNamedCharactersCpp {

    /**
     * The license for the output of this program except for data files.
     */
    private static final String OUTPUT_LICENSE = "/*\n"
            + " * Copyright (c) 2008-2010 Mozilla Foundation\n"
            + " *\n"
            + " * Permission is hereby granted, free of charge, to any person obtaining a \n"
            + " * copy of this software and associated documentation files (the \"Software\"), \n"
            + " * to deal in the Software without restriction, including without limitation \n"
            + " * the rights to use, copy, modify, merge, publish, distribute, sublicense, \n"
            + " * and/or sell copies of the Software, and to permit persons to whom the \n"
            + " * Software is furnished to do so, subject to the following conditions:\n"
            + " *\n"
            + " * The above copyright notice and this permission notice shall be included in \n"
            + " * all copies or substantial portions of the Software.\n"
            + " *\n"
            + " * THE SOFTWARE IS PROVIDED \"AS IS\", WITHOUT WARRANTY OF ANY KIND, EXPRESS OR \n"
            + " * IMPLIED, INCLUDING BUT NOT LIMITED TO THE WARRANTIES OF MERCHANTABILITY, \n"
            + " * FITNESS FOR A PARTICULAR PURPOSE AND NONINFRINGEMENT. IN NO EVENT SHALL \n"
            + " * THE AUTHORS OR COPYRIGHT HOLDERS BE LIABLE FOR ANY CLAIM, DAMAGES OR OTHER \n"
            + " * LIABILITY, WHETHER IN AN ACTION OF CONTRACT, TORT OR OTHERWISE, ARISING \n"
            + " * FROM, OUT OF OR IN CONNECTION WITH THE SOFTWARE OR THE USE OR OTHER \n"
            + " * DEALINGS IN THE SOFTWARE.\n" + " */\n\n";
    
    /**
     * The license for the generated data files.
     */
    private static final String DATA_LICENSE = "/*\n"
            + " * Copyright 2004-2010 Apple Computer, Inc., Mozilla Foundation, and Opera \n"
            + " * Software ASA.\n"
            + " * \n"
            + " * You are granted a license to use, reproduce and create derivative works of \n"
            + " * this document.\n" + " */\n\n";

    private static final int LEAD_OFFSET = 0xD800 - (0x10000 >> 10);

    private static final Pattern LINE_PATTERN = Pattern.compile("<td> <code title=\"\">([^<]*)</code> </td> <td> U\\+(\\S*) (?:U\\+(\\S*) )?</td>");

    private static String toHexString(int c) {
        String hexString = Integer.toHexString(c);
        switch (hexString.length()) {
            case 1:
                return "0x000" + hexString;
            case 2:
                return "0x00" + hexString;
            case 3:
                return "0x0" + hexString;
            case 4:
                return "0x" + hexString;
            default:
                throw new RuntimeException("Unreachable.");
        }
    }

    /**
     * @param args
     * @throws IOException
     */
    public static void main(String[] args) throws IOException {
        TreeMap<String, String> entities = new TreeMap<String, String>();
        BufferedReader reader = new BufferedReader(new InputStreamReader(
                new FileInputStream(args[0]), "utf-8"));
        String line;
        while ((line = reader.readLine()) != null) {
            Matcher m = LINE_PATTERN.matcher(line);
            while (m.find()) {
                String value;
                if (m.group(3) != null) {
                    // two BMP chars
                    int firstIntVal = Integer.parseInt(m.group(2), 16);
                    int secondIntVal = Integer.parseInt(m.group(3), 16);
                    value = ("" + (char)firstIntVal) + (char)secondIntVal;
                } else {
                    // one code point
                    int intVal = Integer.parseInt(m.group(2), 16);
                    if (intVal <= 0xFFFF) {
                        value = "" + (char)intVal;
                    } else {
                        int high = (LEAD_OFFSET + (intVal >> 10));
                        int low = (0xDC00 + (intVal & 0x3FF));
                        value = ("" + (char)high) + (char)low;
                    }
                }
                entities.put(m.group(1), value);
            }
        }

        CppTypes cppTypes = new CppTypes(null);
        File targetDirectory = new File(args[1]);

        generateH(targetDirectory, cppTypes, entities);
        generateInclude(targetDirectory, cppTypes, entities);
        generateCpp(targetDirectory, cppTypes, entities);
        generateAccelH(targetDirectory, cppTypes, entities);
        generateAccelCpp(targetDirectory, cppTypes, entities);
    }

    private static void generateAccelCpp(File targetDirectory,
            CppTypes cppTypes, TreeMap<String, String> entities) throws IOException {
        String includeFile = cppTypes.classPrefix()
                + "NamedCharactersInclude.h";
        File cppFile = new File(targetDirectory, cppTypes.classPrefix()
                + "NamedCharactersAccel.cpp");
        Writer out = new OutputStreamWriter(new FileOutputStream(cppFile),
                "utf-8");

        out.write(DATA_LICENSE);
        out.write('\n');
        out.write("#include \"" + cppTypes.classPrefix()
                + "NamedCharactersAccel.h\"\n");
        out.write("\n");

        // Java initializes arrays to zero. Zero is our magic value for no hilo
        // value.
        int[][] hiLoTable = new int['z' + 1]['Z' - 'A' + 1 + 'z' - 'a' + 1];

        String firstName = entities.entrySet().iterator().next().getKey();
        int firstKey = charToIndex(firstName.charAt(0));
        int secondKey = firstName.charAt(1);
        int row = 0;
        int lo = 0;

        for (Map.Entry<String, String> entity : entities.entrySet()) {
            String name = entity.getKey();
            int newFirst = charToIndex(name.charAt(0));
            int newSecond = name.charAt(1);
            assert !(newFirst == 0 && newSecond == 0) : "Not prepared for name starting with AA";
            if (firstKey != newFirst || secondKey != newSecond) {
                hiLoTable[secondKey][firstKey] = ((row - 1) << 16) | lo;
                lo = row;
                firstKey = newFirst;
                secondKey = newSecond;
            }
            row++;
        }

        hiLoTable[secondKey][firstKey] = ((entities.size() - 1) << 16) | lo;

        for (int i = 0; i < hiLoTable.length; i++) {
            if (!allZero(hiLoTable[i])) {
                out.write("static " + cppTypes.intType() + " const HILO_ACCEL_"
                        + i + "[] = {\n");
                for (int j = 0; j < hiLoTable[i].length; j++) {
                    if (j != 0) {
                        out.write(", ");
                    }
                    out.write("" + hiLoTable[i][j]);
                }
                out.write("\n};\n\n");
            }
        }

        out.write("const int32_t* const " + cppTypes.classPrefix()
                + "NamedCharactersAccel::HILO_ACCEL[] = {\n");
        for (int i = 0; i < hiLoTable.length; i++) {
            if (i != 0) {
                out.write(",\n");
            }
            if (allZero(hiLoTable[i])) {
                out.write("  0");
            } else {
                out.write("  HILO_ACCEL_" + i);
            }
        }
        out.write("\n};\n\n");

        out.flush();
        out.close();
    }

    private static void generateAccelH(File targetDirectory, CppTypes cppTypes,
            TreeMap<String, String> entities) throws IOException {
        File hFile = new File(targetDirectory, cppTypes.classPrefix()
                + "NamedCharactersAccel.h");
        Writer out = new OutputStreamWriter(new FileOutputStream(hFile),
                "utf-8");
        out.write(DATA_LICENSE);
        out.write("#ifndef " + cppTypes.classPrefix() + "NamedCharactersAccel_h\n");
        out.write("#define " + cppTypes.classPrefix() + "NamedCharactersAccel_h\n");
        out.write('\n');

        String[] includes = cppTypes.namedCharactersIncludes();
        for (int i = 0; i < includes.length; i++) {
            String include = includes[i];
            out.write("#include \"" + include + ".h\"\n");
        }

        out.write('\n');

        out.write("class " + cppTypes.classPrefix() + "NamedCharactersAccel\n");
        out.write("{\n");
        out.write("  public:\n");
        out.write("    static const " + cppTypes.intType()
                + "* const HILO_ACCEL[];\n");
        out.write("};\n");

        out.write("\n#endif // " + cppTypes.classPrefix()
                + "NamedCharactersAccel_h\n");
        out.flush();
        out.close();
    }

    private static void generateH(File targetDirectory, CppTypes cppTypes,
            Map<String, String> entities) throws IOException {
        File hFile = new File(targetDirectory, cppTypes.classPrefix()
                + "NamedCharacters.h");
        Writer out = new OutputStreamWriter(new FileOutputStream(hFile),
                "utf-8");
        out.write(OUTPUT_LICENSE);
        out.write("#ifndef " + cppTypes.classPrefix() + "NamedCharacters_h\n");
        out.write("#define " + cppTypes.classPrefix() + "NamedCharacters_h\n");
        out.write('\n');

        String[] includes = cppTypes.namedCharactersIncludes();
        for (int i = 0; i < includes.length; i++) {
            String include = includes[i];
            out.write("#include \"" + include + ".h\"\n");
        }

        out.write("\nstruct ");
        out.write(cppTypes.characterNameTypeDeclaration());
        out.write(" {\n  ");
        out.write(cppTypes.unsignedShortType());
        out.write(" nameStart;\n  ");
        out.write(cppTypes.unsignedShortType());
        out.write(" nameLen;\n  #ifdef DEBUG\n  ");
        out.write(cppTypes.intType());
        out.write(" n;\n  #endif\n  ");
        out.write(cppTypes.intType());
        out.write(" length() const;\n  ");
        out.write(cppTypes.charType());
        out.write(" charAt(");
        out.write(cppTypes.intType());
        out.write(" index) const;\n};\n\n");

        out.write("class " + cppTypes.classPrefix() + "NamedCharacters\n");
        out.write("{\n");
        out.write("  public:\n");
        out.write("    static const " + cppTypes.characterNameTypeDeclaration() + " NAMES[];\n");
        out.write("    static const " + cppTypes.charType() + " VALUES[][2];\n");
        out.write("    static " + cppTypes.charType() + "** WINDOWS_1252;\n");
        out.write("    static void initializeStatics();\n");
        out.write("    static void releaseStatics();\n");
        out.write("};\n");

        out.write("\n#endif // " + cppTypes.classPrefix()
                + "NamedCharacters_h\n");
        out.flush();
        out.close();
    }

    private static void generateInclude(File targetDirectory,
            CppTypes cppTypes, Map<String, String> entities) throws IOException {
        File includeFile = new File(targetDirectory, cppTypes.classPrefix()
                + "NamedCharactersInclude.h");
        Writer out = new OutputStreamWriter(new FileOutputStream(includeFile),
                "utf-8");

        out.write(DATA_LICENSE);
        out.write("/* Data generated from the table of named character references found at\n");
        out.write(" *\n");
        out.write(" *   http://www.whatwg.org/specs/web-apps/current-work/multipage/named-character-references.html#named-character-references\n");
        out.write(" *\n");
        out.write(" * Files that #include this file must #define NAMED_CHARACTER_REFERENCE as a\n");
        out.write(" * macro of four parameters:\n");
        out.write(" *\n");
        out.write(" *   1.  a unique integer N identifying the Nth [0,1,..] macro expansion in this file,\n");
        out.write(" *   2.  a comma-separated sequence of characters comprising the character name,\n");
        out.write(" *       without the first two letters or 0 if the sequence would be empty. \n");
        out.write(" *       See Tokenizer.java.\n");
        out.write(" *   3.  the length of this sequence of characters,\n");
        out.write(" *   4.  placeholder flag (0 if argument #is not a placeholder and 1 if it is),\n");
        out.write(" *   5.  a comma-separated sequence of char16_t literals corresponding\n");
        out.write(" *       to the code-point(s) of the named character.\n");
        out.write(" *\n");
        out.write(" * The macro expansion doesn't have to refer to all or any of these parameters,\n");
        out.write(" * but common sense dictates that it should involve at least one of them.\n");
        out.write(" */\n");
        out.write("\n");
        out.write("// This #define allows the NAMED_CHARACTER_REFERENCE macro to accept comma-\n");
        out.write("// separated sequences as single macro arguments.  Using commas directly would\n");
        out.write("// split the sequence into multiple macro arguments.\n");
        out.write("#define _ ,\n");
        out.write("\n");

        int i = 0;
        for (Map.Entry<String, String> entity : entities.entrySet()) {
            out.write("NAMED_CHARACTER_REFERENCE(" + i++ + ", ");
            String name = entity.getKey();
            writeNameInitializer(out, name, " _ ");
            out.write(", " + (name.length() - 2) + ", ");
            out.write((name.length() == 2 ? "1" : "0") + ", ");
            writeValueInitializer(out, entity.getValue(), " _ ");
            out.write(")\n");
        }

        out.write("\n");
        out.write("#undef _\n");

        out.flush();
        out.close();
    }

    private static void writeNameInitializer(Writer out,
            String name, String separator)
            throws IOException {
        out.write("/* " + name.charAt(0) + " " + name.charAt(1) + " */ ");
        if (name.length() == 2) {
            out.write("0");
        } else {
            for (int i = 2; i < name.length(); i++) {
                out.write("'" + name.charAt(i) + "'");
                if (i < name.length() - 1)
                    out.write(separator);
            }            
        }
    }

    private static void writeValueInitializer(Writer out,
            String value, String separator)
            throws IOException {
        if (value.length() == 1) {
            out.write(toHexString(value.charAt(0)));
            out.write(separator);
            out.write("0");
        } else {
            out.write(toHexString(value.charAt(0)));
            out.write(separator);
            out.write(toHexString(value.charAt(1)));
        }
    }

    private static void defineMacroAndInclude(Writer out, String expansion,
            String includeFile) throws IOException {
        out.write("#define NAMED_CHARACTER_REFERENCE(N, CHARS, LEN, FLAG, VALUE) \\\n"
                + expansion + "\n");
        out.write("#include \"" + includeFile + "\"\n");
        out.write("#undef NAMED_CHARACTER_REFERENCE\n");
    }

    private static void defineMacroAndInclude(Writer out, String expansion,
            String debugExpansion, String includeFile) throws IOException {
        out.write("#ifdef DEBUG\n");
        out.write("  #define NAMED_CHARACTER_REFERENCE(N, CHARS, LEN, FLAG, VALUE) \\\n"
                + debugExpansion + "\n");
        out.write("#else\n");
        out.write("  #define NAMED_CHARACTER_REFERENCE(N, CHARS, LEN, FLAG, VALUE) \\\n"
                + expansion + "\n");
        out.write("#endif\n");
        out.write("#include \"" + includeFile + "\"\n");
        out.write("#undef NAMED_CHARACTER_REFERENCE\n");
    }

    private static void writeStaticMemberDeclaration(Writer out,
            CppTypes cppTypes, String type, String name) throws IOException {
        out.write(type + " " + cppTypes.classPrefix() + "NamedCharacters::"
                + name + ";\n");
    }

    private static int charToIndex(char c) {
        if (c >= 'a' && c <= 'z') {
            return c - 'a' + 26;
        } else if (c >= 'A' && c <= 'Z') {
            return c - 'A';
        }
        throw new IllegalArgumentException("Bad char in named character name: "
                + c);
    }

    private static boolean allZero(int[] arr) {
        for (int i = 0; i < arr.length; i++) {
            if (arr[i] != 0) {
                return false;
            }
        }
        return true;
    }

    private static void generateCpp(File targetDirectory, CppTypes cppTypes,
            Map<String, String> entities) throws IOException {
        String includeFile = cppTypes.classPrefix()
                + "NamedCharactersInclude.h";
        File cppFile = new File(targetDirectory, cppTypes.classPrefix()
                + "NamedCharacters.cpp");
        Writer out = new OutputStreamWriter(new FileOutputStream(cppFile),
                "utf-8");

        out.write(OUTPUT_LICENSE);
        out.write("#define " + cppTypes.classPrefix()
                + "NamedCharacters_cpp_\n");

        String[] includes = cppTypes.namedCharactersIncludes();
        for (int i = 0; i < includes.length; i++) {
            String include = includes[i];
            out.write("#include \"" + include + ".h\"\n");
        }

        out.write('\n');
        out.write("#include \"" + cppTypes.classPrefix()
                + "NamedCharacters.h\"\n");
        out.write("\n");

        out.write("const " + cppTypes.charType() + " " + cppTypes.classPrefix()
                + "NamedCharacters::VALUES[][2] = {\n");
        defineMacroAndInclude(out, "{ VALUE },", includeFile);
        // The useless terminator entry makes the above macro simpler with
        // compilers that whine about a comma after the last item
        out.write("{0, 0} };\n\n");

        String staticMemberType = cppTypes.charType() + "**";
        writeStaticMemberDeclaration(out, cppTypes, staticMemberType,
                "WINDOWS_1252");

        out.write("static " + cppTypes.charType()
                + " const WINDOWS_1252_DATA[] = {\n");
        out.write("  0x20AC,\n");
        out.write("  0x0081,\n");
        out.write("  0x201A,\n");
        out.write("  0x0192,\n");
        out.write("  0x201E,\n");
        out.write("  0x2026,\n");
        out.write("  0x2020,\n");
        out.write("  0x2021,\n");
        out.write("  0x02C6,\n");
        out.write("  0x2030,\n");
        out.write("  0x0160,\n");
        out.write("  0x2039,\n");
        out.write("  0x0152,\n");
        out.write("  0x008D,\n");
        out.write("  0x017D,\n");
        out.write("  0x008F,\n");
        out.write("  0x0090,\n");
        out.write("  0x2018,\n");
        out.write("  0x2019,\n");
        out.write("  0x201C,\n");
        out.write("  0x201D,\n");
        out.write("  0x2022,\n");
        out.write("  0x2013,\n");
        out.write("  0x2014,\n");
        out.write("  0x02DC,\n");
        out.write("  0x2122,\n");
        out.write("  0x0161,\n");
        out.write("  0x203A,\n");
        out.write("  0x0153,\n");
        out.write("  0x009D,\n");
        out.write("  0x017E,\n");
        out.write("  0x0178\n");
        out.write("};\n\n");

        out.write("/**\n");
        out.write(" * To avoid having lots of pointers in the |charData| array, below,\n");
        out.write(" * which would cause us to have to do lots of relocations at library\n");
        out.write(" * load time, store all the string data for the names in one big array.\n");
        out.write(" * Then use tricks with enums to help us build an array that contains\n");
        out.write(" * the positions of each within the big arrays.\n");
        out.write(" */\n\n");

        out.write("static const " + cppTypes.byteType() + " ALL_NAMES[] = {\n");

        defineMacroAndInclude(out, "CHARS ,", includeFile);

        out.write("};\n\n");        
        
        out.write("enum NamePositions {\n");
        out.write("  DUMMY_INITIAL_NAME_POSITION = 0,\n");

        out.write("/* enums don't take up space, so generate _START and _END */\n");
        defineMacroAndInclude(out,
                "NAME_##N##_DUMMY, /* automatically one higher than previous */ \\\n"
                        + "NAME_##N##_START = NAME_##N##_DUMMY - 1, \\\n"
                        + "NAME_##N##_END = NAME_##N##_START + LEN + FLAG,",
                includeFile);

        out.write("  DUMMY_FINAL_NAME_VALUE\n");
        out.write("};\n\n");

        String arrayLengthMacro = cppTypes.arrayLengthMacro();
        String staticAssert = cppTypes.staticAssert();
        if (staticAssert != null && arrayLengthMacro != null) {
            out.write("/* check that the start positions will fit in 16 bits */\n");
            out.write(staticAssert + "(" + arrayLengthMacro
                    + "(ALL_NAMES) < 0x10000);\n\n");
        }
        
        out.write("const " + cppTypes.characterNameTypeDeclaration() + " " + cppTypes.classPrefix()
                + "NamedCharacters::NAMES[] = {\n");
        defineMacroAndInclude(out, "{ NAME_##N##_START, LEN, },", "{ NAME_##N##_START, LEN, N },", includeFile);
        out.write("};\n\n");

        out.write(cppTypes.intType());
        out.write("\n");
        out.write(cppTypes.characterNameTypeDeclaration());
        out.write("::length() const\n{\n  return nameLen;\n}\n\n");
        out.write(cppTypes.charType());
        out.write("\n");
        out.write(cppTypes.characterNameTypeDeclaration());
        out.write("::charAt(");
        out.write("int32_t");
        out.write(" index) const\n{\n  return static_cast<");
        out.write(cppTypes.charType());
        out.write("> (ALL_NAMES[nameStart + index]);\n}\n\n");
        
        out.write("void\n");
        out.write(cppTypes.classPrefix()
                + "NamedCharacters::initializeStatics()\n");
        out.write("{\n");
        out.write("  WINDOWS_1252 = new " + cppTypes.charType() + "*[32];\n");
        out.write("  for (" + cppTypes.intType() + " i = 0; i < 32; ++i) {\n");
        out.write("    WINDOWS_1252[i] = (" + cppTypes.charType()
                + "*)&(WINDOWS_1252_DATA[i]);\n");
        out.write("  }\n");
        out.write("}\n");
        out.write("\n");

        out.write("void\n");
        out.write(cppTypes.classPrefix()
                + "NamedCharacters::releaseStatics()\n");
        out.write("{\n");
        out.write("  delete[] WINDOWS_1252;\n");
        out.write("}\n");
        out.flush();
        out.close();
    }
}
