/*
 * Copyright (c) 2006 Henri Sivonen
 * Copyright (c) 2008 Mozilla Foundation
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

package nu.validator.htmlparser.io;

import java.io.ByteArrayInputStream;
import java.io.IOException;
import java.io.InputStreamReader;
import java.io.Reader;
import java.nio.charset.Charset;
import java.nio.charset.CharsetDecoder;
import java.nio.charset.CharsetEncoder;
import java.nio.charset.CoderMalfunctionError;
import java.nio.charset.CodingErrorAction;
import java.nio.charset.UnsupportedCharsetException;
import java.util.Arrays;
import java.util.HashMap;
import java.util.HashSet;
import java.util.Map;
import java.util.Set;
import java.util.SortedMap;

public class Encoding {

    public static final Encoding UTF8;

    public static final Encoding UTF16;

    public static final Encoding UTF16LE;

    public static final Encoding UTF16BE;

    public static final Encoding WINDOWS1252;

    private static String[] SHOULD_NOT = { "jisx02121990", "xjis0208" };

    private static String[] BANNED = { "bocu1", "cesu8", "compoundtext",
            "iscii91", "macarabic", "maccentraleurroman", "maccroatian",
            "maccyrillic", "macdevanagari", "macfarsi", "macgreek",
            "macgujarati", "macgurmukhi", "machebrew", "macicelandic",
            "macroman", "macromanian", "macthai", "macturkish", "macukranian",
            "scsu", "utf32", "utf32be", "utf32le", "utf7", "ximapmailboxname",
            "xjisautodetect", "xutf16bebom", "xutf16lebom", "xutf32bebom",
            "xutf32lebom", "xutf16oppositeendian", "xutf16platformendian",
            "xutf32oppositeendian", "xutf32platformendian" };

    private static String[] NOT_OBSCURE = { "big5", "big5hkscs", "eucjp",
            "euckr", "gb18030", "gbk", "iso2022jp", "iso2022kr", "iso88591",
            "iso885913", "iso885915", "iso88592", "iso88593", "iso88594",
            "iso88595", "iso88596", "iso88597", "iso88598", "iso88599",
            "koi8r", "shiftjis", "tis620", "usascii", "utf16", "utf16be",
            "utf16le", "utf8", "windows1250", "windows1251", "windows1252",
            "windows1253", "windows1254", "windows1255", "windows1256",
            "windows1257", "windows1258" };

    private static Map<String, Encoding> encodingByCookedName = new HashMap<String, Encoding>();

    private final String canonName;

    private final Charset charset;

    private final boolean asciiSuperset;

    private final boolean obscure;

    private final boolean shouldNot;

    private final boolean likelyEbcdic;

    private Encoding actualHtmlEncoding = null;

    static {
        byte[] testBuf = new byte[0x7F];
        for (int i = 0; i < 0x7F; i++) {
            if (isAsciiSupersetnessSensitive(i)) {
                testBuf[i] = (byte) i;
            } else {
                testBuf[i] = (byte) 0x20;
            }
        }

        Set<Encoding> encodings = new HashSet<Encoding>();

        SortedMap<String, Charset> charsets = Charset.availableCharsets();
        for (Map.Entry<String, Charset> entry : charsets.entrySet()) {
            Charset cs = entry.getValue();
            String name = toNameKey(cs.name());
            String canonName = toAsciiLowerCase(cs.name());
            if (!isBanned(name)) {
                name = name.intern();
                boolean asciiSuperset = asciiMapsToBasicLatin(testBuf, cs);
                Encoding enc = new Encoding(canonName.intern(), cs,
                        asciiSuperset, isObscure(name), isShouldNot(name),
                        isLikelyEbcdic(name, asciiSuperset));
                encodings.add(enc);
                Set<String> aliases = cs.aliases();
                for (String alias : aliases) {
                    encodingByCookedName.put(toNameKey(alias).intern(), enc);
                }
            }
        }
        // Overwrite possible overlapping aliases with the real things--just in
        // case
        for (Encoding encoding : encodings) {
            encodingByCookedName.put(toNameKey(encoding.getCanonName()),
                    encoding);
        }
        UTF8 = forName("utf-8");
        UTF16 = forName("utf-16");
        UTF16BE = forName("utf-16be");
        UTF16LE = forName("utf-16le");
        WINDOWS1252 = forName("windows-1252");
        try {
            forName("iso-8859-1").actualHtmlEncoding = forName("windows-1252");
        } catch (UnsupportedCharsetException e) {
        }
        try {
            forName("iso-8859-9").actualHtmlEncoding = forName("windows-1254");
        } catch (UnsupportedCharsetException e) {
        }
        try {
            forName("iso-8859-11").actualHtmlEncoding = forName("windows-874");
        } catch (UnsupportedCharsetException e) {
        }
        try {
            forName("x-iso-8859-11").actualHtmlEncoding = forName("windows-874");
        } catch (UnsupportedCharsetException e) {
        }
        try {
            forName("tis-620").actualHtmlEncoding = forName("windows-874");
        } catch (UnsupportedCharsetException e) {
        }
        try {
            forName("gb_2312-80").actualHtmlEncoding = forName("gbk");
        } catch (UnsupportedCharsetException e) {
        }
        try {
            forName("gb2312").actualHtmlEncoding = forName("gbk");
        } catch (UnsupportedCharsetException e) {
        }
        try {
            encodingByCookedName.put("x-x-big5", forName("big5"));
        } catch (UnsupportedCharsetException e) {
        }
        try {
            encodingByCookedName.put("euc-kr", forName("windows-949"));
        } catch (UnsupportedCharsetException e) {
        }
        try {
            encodingByCookedName.put("ks_c_5601-1987", forName("windows-949"));
        } catch (UnsupportedCharsetException e) {
        }
    }

    private static boolean isAsciiSupersetnessSensitive(int c) {
        return (c >= 0x09 && c <= 0x0D) || (c >= 0x20 && c <= 0x22)
                || (c >= 0x26 && c <= 0x27) || (c >= 0x2C && c <= 0x3F)
                || (c >= 0x41 && c <= 0x5A) || (c >= 0x61 && c <= 0x7A);
    }

    private static boolean isObscure(String lowerCasePreferredIanaName) {
        return !(Arrays.binarySearch(NOT_OBSCURE, lowerCasePreferredIanaName) > -1);
    }

    private static boolean isBanned(String lowerCasePreferredIanaName) {
        if (lowerCasePreferredIanaName.startsWith("xibm")) {
            return true;
        }
        return (Arrays.binarySearch(BANNED, lowerCasePreferredIanaName) > -1);
    }

    private static boolean isShouldNot(String lowerCasePreferredIanaName) {
        return (Arrays.binarySearch(SHOULD_NOT, lowerCasePreferredIanaName) > -1);
    }

    /**
     * @param testBuf
     * @param cs
     */
    private static boolean asciiMapsToBasicLatin(byte[] testBuf, Charset cs) {
        CharsetDecoder dec = cs.newDecoder();
        dec.onMalformedInput(CodingErrorAction.REPORT);
        dec.onUnmappableCharacter(CodingErrorAction.REPORT);
        Reader r = new InputStreamReader(new ByteArrayInputStream(testBuf), dec);
        try {
            for (int i = 0; i < 0x7F; i++) {
                if (isAsciiSupersetnessSensitive(i)) {
                    if (r.read() != i) {
                        return false;
                    }
                } else {
                    if (r.read() != 0x20) {
                        return false;
                    }
                }
            }
        } catch (IOException e) {
            return false;
        } catch (Exception e) {
            return false;
        } catch (CoderMalfunctionError e) {
            return false;
        }

        return true;
    }

    private static boolean isLikelyEbcdic(String canonName,
            boolean asciiSuperset) {
        if (!asciiSuperset) {
            return (canonName.startsWith("cp") || canonName.startsWith("ibm") || canonName.startsWith("xibm"));
        } else {
            return false;
        }
    }

    public static Encoding forName(String name) {
        Encoding rv = encodingByCookedName.get(toNameKey(name));
        if (rv == null) {
            throw new UnsupportedCharsetException(name);
        } else {
            return rv;
        }
    }

    public static String toNameKey(String str) {
        if (str == null) {
            return null;
        }
        int j = 0;
        char[] buf = new char[str.length()];
        for (int i = 0; i < str.length(); i++) {
            char c = str.charAt(i);
            if (c >= 'A' && c <= 'Z') {
                c += 0x20;
            }
            if (!((c >= '\t' && c <= '\r') || (c >= '\u0020' && c <= '\u002F')
                    || (c >= '\u003A' && c <= '\u0040')
                    || (c >= '\u005B' && c <= '\u0060') || (c >= '\u007B' && c <= '\u007E'))) {
                buf[j] = c;
                j++;
            }
        }
        return new String(buf, 0, j);
    }

    public static String toAsciiLowerCase(String str) {
        if (str == null) {
            return null;
        }
        char[] buf = new char[str.length()];
        for (int i = 0; i < str.length(); i++) {
            char c = str.charAt(i);
            if (c >= 'A' && c <= 'Z') {
                c += 0x20;
            }
            buf[i] = c;
        }
        return new String(buf);
    }

    /**
     * @param canonName
     * @param charset
     * @param asciiSuperset
     * @param obscure
     * @param shouldNot
     * @param likelyEbcdic
     */
    private Encoding(final String canonName, final Charset charset,
            final boolean asciiSuperset, final boolean obscure,
            final boolean shouldNot, final boolean likelyEbcdic) {
        this.canonName = canonName;
        this.charset = charset;
        this.asciiSuperset = asciiSuperset;
        this.obscure = obscure;
        this.shouldNot = shouldNot;
        this.likelyEbcdic = likelyEbcdic;
    }

    /**
     * Returns the asciiSuperset.
     * 
     * @return the asciiSuperset
     */
    public boolean isAsciiSuperset() {
        return asciiSuperset;
    }

    /**
     * Returns the canonName.
     * 
     * @return the canonName
     */
    public String getCanonName() {
        return canonName;
    }

    /**
     * Returns the likelyEbcdic.
     * 
     * @return the likelyEbcdic
     */
    public boolean isLikelyEbcdic() {
        return likelyEbcdic;
    }

    /**
     * Returns the obscure.
     * 
     * @return the obscure
     */
    public boolean isObscure() {
        return obscure;
    }

    /**
     * Returns the shouldNot.
     * 
     * @return the shouldNot
     */
    public boolean isShouldNot() {
        return shouldNot;
    }

    public boolean isRegistered() {
        return !canonName.startsWith("x-");
    }

    /**
     * @return
     * @see java.nio.charset.Charset#canEncode()
     */
    public boolean canEncode() {
        return charset.canEncode();
    }

    /**
     * @return
     * @see java.nio.charset.Charset#newDecoder()
     */
    public CharsetDecoder newDecoder() {
        return charset.newDecoder();
    }

    /**
     * @return
     * @see java.nio.charset.Charset#newEncoder()
     */
    public CharsetEncoder newEncoder() {
        return charset.newEncoder();
    }

    /**
     * Returns the actualHtmlEncoding.
     * 
     * @return the actualHtmlEncoding
     */
    public Encoding getActualHtmlEncoding() {
        return actualHtmlEncoding;
    }

    public static void main(String[] args) {
        for (Map.Entry<String, Encoding> entry : encodingByCookedName.entrySet()) {
            String name = entry.getKey();
            Encoding enc = entry.getValue();
            System.out.printf(
                    "%21s: canon %21s, obs %5s, reg %5s, asc %5s, ebc %5s\n",
                    name, enc.getCanonName(), enc.isObscure(),
                    enc.isRegistered(), enc.isAsciiSuperset(),
                    enc.isLikelyEbcdic());
        }
    }

}
