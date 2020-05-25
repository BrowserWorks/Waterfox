/*
 * Copyright (c) 2008-2009 Mozilla Foundation
 *
 * Permission is hereby granted, free of charge, to any person obtaining a 
 * copy of this software and associated documentation files (the "Software"), 
 * to deal in the Software without restriction, including without limitation 
 * the rights to use, copy, modify, merge, publish, distribute, sublicense, 
 * and/or sell copies of the Software, and to permit persons to whom the 
 * Software is furnished to do so, subject to the following conditions:
 *
 * The above copyright notice and this permission notice shall be included in 
 * all copies or substantial portions of the Software.
 *
 * THE SOFTWARE IS PROVIDED "AS IS", WITHOUT WARRANTY OF ANY KIND, EXPRESS OR 
 * IMPLIED, INCLUDING BUT NOT LIMITED TO THE WARRANTIES OF MERCHANTABILITY, 
 * FITNESS FOR A PARTICULAR PURPOSE AND NONINFRINGEMENT. IN NO EVENT SHALL 
 * THE AUTHORS OR COPYRIGHT HOLDERS BE LIABLE FOR ANY CLAIM, DAMAGES OR OTHER 
 * LIABILITY, WHETHER IN AN ACTION OF CONTRACT, TORT OR OTHERWISE, ARISING 
 * FROM, OUT OF OR IN CONNECTION WITH THE SOFTWARE OR THE USE OR OTHER 
 * DEALINGS IN THE SOFTWARE.
 */

package nu.validator.htmlparser.generator;

import java.io.BufferedReader;
import java.io.IOException;
import java.io.InputStreamReader;
import java.util.Map;
import java.util.TreeMap;
import java.util.regex.Matcher;
import java.util.regex.Pattern;

public class GenerateNamedCharacters {
    
    private static final int LEAD_OFFSET = 0xD800 - (0x10000 >> 10);

    private static final Pattern LINE_PATTERN = Pattern.compile("<td> <code title=\"\">([^<]*)</code> </td> <td> U\\+(\\S*) (?:U\\+(\\S*) )?</td>");

    private static String toUString(int c) {
        String hexString = Integer.toHexString(c);
        switch (hexString.length()) {
            case 1:
                return "\\u000" + hexString;
            case 2:
                return "\\u00" + hexString;
            case 3:
                return "\\u0" + hexString;
            case 4:
                return "\\u" + hexString;
            default:
                throw new RuntimeException("Unreachable.");
        }
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

    /**
     * @param args
     * @throws IOException
     */
    public static void main(String[] args) throws IOException {
        TreeMap<String, String> entities = new TreeMap<String, String>();
        BufferedReader reader = new BufferedReader(new InputStreamReader(
                System.in, "utf-8"));
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

        // Java initializes arrays to zero. Zero is our magic value for no hilo
        // value.
        int[][] hiLoTable = new int['z' + 1]['Z' - 'A' + 1 + 'z' - 'a' + 1];

        String firstName = entities.entrySet().iterator().next().getKey();
        int firstKey = charToIndex(firstName.charAt(0));
        int secondKey = firstName.charAt(1);
        int row = 0;
        int lo = 0;

        System.out.print("static final @NoLength @CharacterName String[] NAMES = {\n");
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
            System.out.print("\"");
            System.out.print(name.substring(2));
            System.out.print("\",\n");
            row++;
        }
        System.out.print("};\n");

        hiLoTable[secondKey][firstKey] = ((entities.size() - 1) << 16) | lo;

        System.out.print("static final @NoLength char[][] VALUES = {\n");
        for (Map.Entry<String, String> entity : entities.entrySet()) {
            String value = entity.getValue();
            System.out.print("{");
            if (value.length() == 1) {
                char c = value.charAt(0);
                if (c == '\'') {
                    System.out.print("\'\\\'\'");
                } else if (c == '\n') {
                    System.out.print("\'\\n\'");
                } else if (c == '\\') {
                    System.out.print("\'\\\\\'");
                } else if (c <= 0xFFFF) {
                    System.out.print("\'");
                    System.out.print(toUString(c));
                    System.out.print("\'");
                }
            } else {
                System.out.print("\'");
                System.out.print(toUString(value.charAt(0)));
                System.out.print("\', \'");
                System.out.print(toUString(value.charAt(1)));
                System.out.print("\'");                
            }
            System.out.print("},\n");
        }
        System.out.print("};\n");

        System.out.print("static final @NoLength int[][] HILO_ACCEL = {\n");
        for (int i = 0; i < hiLoTable.length; i++) {
            if (allZero(hiLoTable[i])) {
                System.out.print("null,\n");
            } else {
                System.out.print("{");
                for (int j = 0; j < hiLoTable[i].length; j++) {
                    System.out.print(hiLoTable[i][j]);
                    System.out.print(", ");
                }
                System.out.print("},\n");
            }
        }
        System.out.print("};\n");
    }

}
