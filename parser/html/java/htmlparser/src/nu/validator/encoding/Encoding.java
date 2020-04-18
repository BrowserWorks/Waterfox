/*
 * Copyright (c) 2015 Mozilla Foundation
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

package nu.validator.encoding;

import java.nio.charset.Charset;
import java.nio.charset.CharsetEncoder;
import java.nio.charset.IllegalCharsetNameException;
import java.nio.charset.UnsupportedCharsetException;
import java.nio.charset.spi.CharsetProvider;
import java.util.Arrays;
import java.util.Collections;
import java.util.SortedMap;
import java.util.TreeMap;

/**
 * Represents an <a href="https://encoding.spec.whatwg.org/#encoding">encoding</a>
 * as defined in the <a href="https://encoding.spec.whatwg.org/">Encoding
 * Standard</a>, provides access to each encoding defined in the Encoding
 * Standard via a static constant and provides the 
 * "<a href="https://encoding.spec.whatwg.org/#concept-encoding-get">get an 
 * encoding</a>" algorithm defined in the Encoding Standard.
 * 
 * <p>This class inherits from {@link Charset} to allow the Encoding 
 * Standard-compliant encodings to be used in contexts that support
 * <code>Charset</code> instances. However, by design, the Encoding 
 * Standard-compliant encodings are not supplied via a {@link CharsetProvider}
 * and, therefore, are not available via and do not interfere with the static
 * methods provided by <code>Charset</code>. (This class provides methods of
 * the same name to hide each static method of <code>Charset</code> to help
 * avoid accidental calls to the static methods of the superclass when working
 * with Encoding Standard-compliant encodings.)
 * 
 * <p>When an application needs to use a particular encoding, such as utf-8
 * or windows-1252, the corresponding constant, i.e.
 * {@link #UTF_8 Encoding.UTF_8} and {@link #WINDOWS_1252 Encoding.WINDOWS_1252}
 * respectively, should be used. However, when the application receives an
 * encoding label from external input, the method {@link #forName(String) 
 * forName()} should be used to obtain the object representing the encoding 
 * identified by the label. In contexts where labels that map to the 
 * <a href="https://encoding.spec.whatwg.org/#replacement">replacement
 * encoding</a> should be treated as unknown, the method {@link
 * #forNameNoReplacement(String) forNameNoReplacement()} should be used instead.
 * 
 * 
 * @author hsivonen
 */
public abstract class Encoding extends Charset {

    private static final String[] LABELS = {
        "866",
        "ansi_x3.4-1968",
        "arabic",
        "ascii",
        "asmo-708",
        "big5",
        "big5-hkscs",
        "chinese",
        "cn-big5",
        "cp1250",
        "cp1251",
        "cp1252",
        "cp1253",
        "cp1254",
        "cp1255",
        "cp1256",
        "cp1257",
        "cp1258",
        "cp819",
        "cp866",
        "csbig5",
        "cseuckr",
        "cseucpkdfmtjapanese",
        "csgb2312",
        "csibm866",
        "csiso2022jp",
        "csiso2022kr",
        "csiso58gb231280",
        "csiso88596e",
        "csiso88596i",
        "csiso88598e",
        "csiso88598i",
        "csisolatin1",
        "csisolatin2",
        "csisolatin3",
        "csisolatin4",
        "csisolatin5",
        "csisolatin6",
        "csisolatin9",
        "csisolatinarabic",
        "csisolatincyrillic",
        "csisolatingreek",
        "csisolatinhebrew",
        "cskoi8r",
        "csksc56011987",
        "csmacintosh",
        "csshiftjis",
        "cyrillic",
        "dos-874",
        "ecma-114",
        "ecma-118",
        "elot_928",
        "euc-jp",
        "euc-kr",
        "gb18030",
        "gb2312",
        "gb_2312",
        "gb_2312-80",
        "gbk",
        "greek",
        "greek8",
        "hebrew",
        "hz-gb-2312",
        "ibm819",
        "ibm866",
        "iso-2022-cn",
        "iso-2022-cn-ext",
        "iso-2022-jp",
        "iso-2022-kr",
        "iso-8859-1",
        "iso-8859-10",
        "iso-8859-11",
        "iso-8859-13",
        "iso-8859-14",
        "iso-8859-15",
        "iso-8859-16",
        "iso-8859-2",
        "iso-8859-3",
        "iso-8859-4",
        "iso-8859-5",
        "iso-8859-6",
        "iso-8859-6-e",
        "iso-8859-6-i",
        "iso-8859-7",
        "iso-8859-8",
        "iso-8859-8-e",
        "iso-8859-8-i",
        "iso-8859-9",
        "iso-ir-100",
        "iso-ir-101",
        "iso-ir-109",
        "iso-ir-110",
        "iso-ir-126",
        "iso-ir-127",
        "iso-ir-138",
        "iso-ir-144",
        "iso-ir-148",
        "iso-ir-149",
        "iso-ir-157",
        "iso-ir-58",
        "iso8859-1",
        "iso8859-10",
        "iso8859-11",
        "iso8859-13",
        "iso8859-14",
        "iso8859-15",
        "iso8859-2",
        "iso8859-3",
        "iso8859-4",
        "iso8859-5",
        "iso8859-6",
        "iso8859-7",
        "iso8859-8",
        "iso8859-9",
        "iso88591",
        "iso885910",
        "iso885911",
        "iso885913",
        "iso885914",
        "iso885915",
        "iso88592",
        "iso88593",
        "iso88594",
        "iso88595",
        "iso88596",
        "iso88597",
        "iso88598",
        "iso88599",
        "iso_8859-1",
        "iso_8859-15",
        "iso_8859-1:1987",
        "iso_8859-2",
        "iso_8859-2:1987",
        "iso_8859-3",
        "iso_8859-3:1988",
        "iso_8859-4",
        "iso_8859-4:1988",
        "iso_8859-5",
        "iso_8859-5:1988",
        "iso_8859-6",
        "iso_8859-6:1987",
        "iso_8859-7",
        "iso_8859-7:1987",
        "iso_8859-8",
        "iso_8859-8:1988",
        "iso_8859-9",
        "iso_8859-9:1989",
        "koi",
        "koi8",
        "koi8-r",
        "koi8-ru",
        "koi8-u",
        "koi8_r",
        "korean",
        "ks_c_5601-1987",
        "ks_c_5601-1989",
        "ksc5601",
        "ksc_5601",
        "l1",
        "l2",
        "l3",
        "l4",
        "l5",
        "l6",
        "l9",
        "latin1",
        "latin2",
        "latin3",
        "latin4",
        "latin5",
        "latin6",
        "logical",
        "mac",
        "macintosh",
        "ms932",
        "ms_kanji",
        "shift-jis",
        "shift_jis",
        "sjis",
        "sun_eu_greek",
        "tis-620",
        "unicode-1-1-utf-8",
        "us-ascii",
        "utf-16",
        "utf-16be",
        "utf-16le",
        "utf-8",
        "utf8",
        "visual",
        "windows-1250",
        "windows-1251",
        "windows-1252",
        "windows-1253",
        "windows-1254",
        "windows-1255",
        "windows-1256",
        "windows-1257",
        "windows-1258",
        "windows-31j",
        "windows-874",
        "windows-949",
        "x-cp1250",
        "x-cp1251",
        "x-cp1252",
        "x-cp1253",
        "x-cp1254",
        "x-cp1255",
        "x-cp1256",
        "x-cp1257",
        "x-cp1258",
        "x-euc-jp",
        "x-gbk",
        "x-mac-cyrillic",
        "x-mac-roman",
        "x-mac-ukrainian",
        "x-sjis",
        "x-user-defined",
        "x-x-big5",
    };
    
    private static final Encoding[] ENCODINGS_FOR_LABELS = {
        Ibm866.INSTANCE,
        Windows1252.INSTANCE,
        Iso6.INSTANCE,
        Windows1252.INSTANCE,
        Iso6.INSTANCE,
        Big5.INSTANCE,
        Big5.INSTANCE,
        Gbk.INSTANCE,
        Big5.INSTANCE,
        Windows1250.INSTANCE,
        Windows1251.INSTANCE,
        Windows1252.INSTANCE,
        Windows1253.INSTANCE,
        Windows1254.INSTANCE,
        Windows1255.INSTANCE,
        Windows1256.INSTANCE,
        Windows1257.INSTANCE,
        Windows1258.INSTANCE,
        Windows1252.INSTANCE,
        Ibm866.INSTANCE,
        Big5.INSTANCE,
        EucKr.INSTANCE,
        EucJp.INSTANCE,
        Gbk.INSTANCE,
        Ibm866.INSTANCE,
        Iso2022Jp.INSTANCE,
        Replacement.INSTANCE,
        Gbk.INSTANCE,
        Iso6.INSTANCE,
        Iso6.INSTANCE,
        Iso8.INSTANCE,
        Iso8I.INSTANCE,
        Windows1252.INSTANCE,
        Iso2.INSTANCE,
        Iso3.INSTANCE,
        Iso4.INSTANCE,
        Windows1254.INSTANCE,
        Iso10.INSTANCE,
        Iso15.INSTANCE,
        Iso6.INSTANCE,
        Iso5.INSTANCE,
        Iso7.INSTANCE,
        Iso8.INSTANCE,
        Koi8R.INSTANCE,
        EucKr.INSTANCE,
        Macintosh.INSTANCE,
        ShiftJis.INSTANCE,
        Iso5.INSTANCE,
        Windows874.INSTANCE,
        Iso6.INSTANCE,
        Iso7.INSTANCE,
        Iso7.INSTANCE,
        EucJp.INSTANCE,
        EucKr.INSTANCE,
        Gb18030.INSTANCE,
        Gbk.INSTANCE,
        Gbk.INSTANCE,
        Gbk.INSTANCE,
        Gbk.INSTANCE,
        Iso7.INSTANCE,
        Iso7.INSTANCE,
        Iso8.INSTANCE,
        Replacement.INSTANCE,
        Windows1252.INSTANCE,
        Ibm866.INSTANCE,
        Replacement.INSTANCE,
        Replacement.INSTANCE,
        Iso2022Jp.INSTANCE,
        Replacement.INSTANCE,
        Windows1252.INSTANCE,
        Iso10.INSTANCE,
        Windows874.INSTANCE,
        Iso13.INSTANCE,
        Iso14.INSTANCE,
        Iso15.INSTANCE,
        Iso16.INSTANCE,
        Iso2.INSTANCE,
        Iso3.INSTANCE,
        Iso4.INSTANCE,
        Iso5.INSTANCE,
        Iso6.INSTANCE,
        Iso6.INSTANCE,
        Iso6.INSTANCE,
        Iso7.INSTANCE,
        Iso8.INSTANCE,
        Iso8.INSTANCE,
        Iso8I.INSTANCE,
        Windows1254.INSTANCE,
        Windows1252.INSTANCE,
        Iso2.INSTANCE,
        Iso3.INSTANCE,
        Iso4.INSTANCE,
        Iso7.INSTANCE,
        Iso6.INSTANCE,
        Iso8.INSTANCE,
        Iso5.INSTANCE,
        Windows1254.INSTANCE,
        EucKr.INSTANCE,
        Iso10.INSTANCE,
        Gbk.INSTANCE,
        Windows1252.INSTANCE,
        Iso10.INSTANCE,
        Windows874.INSTANCE,
        Iso13.INSTANCE,
        Iso14.INSTANCE,
        Iso15.INSTANCE,
        Iso2.INSTANCE,
        Iso3.INSTANCE,
        Iso4.INSTANCE,
        Iso5.INSTANCE,
        Iso6.INSTANCE,
        Iso7.INSTANCE,
        Iso8.INSTANCE,
        Windows1254.INSTANCE,
        Windows1252.INSTANCE,
        Iso10.INSTANCE,
        Windows874.INSTANCE,
        Iso13.INSTANCE,
        Iso14.INSTANCE,
        Iso15.INSTANCE,
        Iso2.INSTANCE,
        Iso3.INSTANCE,
        Iso4.INSTANCE,
        Iso5.INSTANCE,
        Iso6.INSTANCE,
        Iso7.INSTANCE,
        Iso8.INSTANCE,
        Windows1254.INSTANCE,
        Windows1252.INSTANCE,
        Iso15.INSTANCE,
        Windows1252.INSTANCE,
        Iso2.INSTANCE,
        Iso2.INSTANCE,
        Iso3.INSTANCE,
        Iso3.INSTANCE,
        Iso4.INSTANCE,
        Iso4.INSTANCE,
        Iso5.INSTANCE,
        Iso5.INSTANCE,
        Iso6.INSTANCE,
        Iso6.INSTANCE,
        Iso7.INSTANCE,
        Iso7.INSTANCE,
        Iso8.INSTANCE,
        Iso8.INSTANCE,
        Windows1254.INSTANCE,
        Windows1254.INSTANCE,
        Koi8R.INSTANCE,
        Koi8R.INSTANCE,
        Koi8R.INSTANCE,
        Koi8U.INSTANCE,
        Koi8U.INSTANCE,
        Koi8R.INSTANCE,
        EucKr.INSTANCE,
        EucKr.INSTANCE,
        EucKr.INSTANCE,
        EucKr.INSTANCE,
        EucKr.INSTANCE,
        Windows1252.INSTANCE,
        Iso2.INSTANCE,
        Iso3.INSTANCE,
        Iso4.INSTANCE,
        Windows1254.INSTANCE,
        Iso10.INSTANCE,
        Iso15.INSTANCE,
        Windows1252.INSTANCE,
        Iso2.INSTANCE,
        Iso3.INSTANCE,
        Iso4.INSTANCE,
        Windows1254.INSTANCE,
        Iso10.INSTANCE,
        Iso8I.INSTANCE,
        Macintosh.INSTANCE,
        Macintosh.INSTANCE,
        ShiftJis.INSTANCE,
        ShiftJis.INSTANCE,
        ShiftJis.INSTANCE,
        ShiftJis.INSTANCE,
        ShiftJis.INSTANCE,
        Iso7.INSTANCE,
        Windows874.INSTANCE,
        Utf8.INSTANCE,
        Windows1252.INSTANCE,
        Utf16Le.INSTANCE,
        Utf16Be.INSTANCE,
        Utf16Le.INSTANCE,
        Utf8.INSTANCE,
        Utf8.INSTANCE,
        Iso8.INSTANCE,
        Windows1250.INSTANCE,
        Windows1251.INSTANCE,
        Windows1252.INSTANCE,
        Windows1253.INSTANCE,
        Windows1254.INSTANCE,
        Windows1255.INSTANCE,
        Windows1256.INSTANCE,
        Windows1257.INSTANCE,
        Windows1258.INSTANCE,
        ShiftJis.INSTANCE,
        Windows874.INSTANCE,
        EucKr.INSTANCE,
        Windows1250.INSTANCE,
        Windows1251.INSTANCE,
        Windows1252.INSTANCE,
        Windows1253.INSTANCE,
        Windows1254.INSTANCE,
        Windows1255.INSTANCE,
        Windows1256.INSTANCE,
        Windows1257.INSTANCE,
        Windows1258.INSTANCE,
        EucJp.INSTANCE,
        Gbk.INSTANCE,
        MacCyrillic.INSTANCE,
        Macintosh.INSTANCE,
        MacCyrillic.INSTANCE,
        ShiftJis.INSTANCE,
        UserDefined.INSTANCE,
        Big5.INSTANCE,
    };

    private static final Encoding[] ENCODINGS = {
        Big5.INSTANCE,
        EucJp.INSTANCE,
        EucKr.INSTANCE,
        Gb18030.INSTANCE,
        Gbk.INSTANCE,
        Ibm866.INSTANCE,
        Iso2022Jp.INSTANCE,
        Iso10.INSTANCE,
        Iso13.INSTANCE,
        Iso14.INSTANCE,
        Iso15.INSTANCE,
        Iso16.INSTANCE,
        Iso2.INSTANCE,
        Iso3.INSTANCE,
        Iso4.INSTANCE,
        Iso5.INSTANCE,
        Iso6.INSTANCE,
        Iso7.INSTANCE,
        Iso8.INSTANCE,
        Iso8I.INSTANCE,
        Koi8R.INSTANCE,
        Koi8U.INSTANCE,
        Macintosh.INSTANCE,
        Replacement.INSTANCE,
        ShiftJis.INSTANCE,
        Utf16Be.INSTANCE,
        Utf16Le.INSTANCE,
        Utf8.INSTANCE,
        Windows1250.INSTANCE,
        Windows1251.INSTANCE,
        Windows1252.INSTANCE,
        Windows1253.INSTANCE,
        Windows1254.INSTANCE,
        Windows1255.INSTANCE,
        Windows1256.INSTANCE,
        Windows1257.INSTANCE,
        Windows1258.INSTANCE,
        Windows874.INSTANCE,
        MacCyrillic.INSTANCE,
        UserDefined.INSTANCE,
    };

    /**
     * The big5 encoding.
     */
    public static final Encoding BIG5 = Big5.INSTANCE;

    /**
     * The euc-jp encoding.
     */
    public static final Encoding EUC_JP = EucJp.INSTANCE;

    /**
     * The euc-kr encoding.
     */
    public static final Encoding EUC_KR = EucKr.INSTANCE;

    /**
     * The gb18030 encoding.
     */
    public static final Encoding GB18030 = Gb18030.INSTANCE;

    /**
     * The gbk encoding.
     */
    public static final Encoding GBK = Gbk.INSTANCE;

    /**
     * The ibm866 encoding.
     */
    public static final Encoding IBM866 = Ibm866.INSTANCE;

    /**
     * The iso-2022-jp encoding.
     */
    public static final Encoding ISO_2022_JP = Iso2022Jp.INSTANCE;

    /**
     * The iso-8859-10 encoding.
     */
    public static final Encoding ISO_8859_10 = Iso10.INSTANCE;

    /**
     * The iso-8859-13 encoding.
     */
    public static final Encoding ISO_8859_13 = Iso13.INSTANCE;

    /**
     * The iso-8859-14 encoding.
     */
    public static final Encoding ISO_8859_14 = Iso14.INSTANCE;

    /**
     * The iso-8859-15 encoding.
     */
    public static final Encoding ISO_8859_15 = Iso15.INSTANCE;

    /**
     * The iso-8859-16 encoding.
     */
    public static final Encoding ISO_8859_16 = Iso16.INSTANCE;

    /**
     * The iso-8859-2 encoding.
     */
    public static final Encoding ISO_8859_2 = Iso2.INSTANCE;

    /**
     * The iso-8859-3 encoding.
     */
    public static final Encoding ISO_8859_3 = Iso3.INSTANCE;

    /**
     * The iso-8859-4 encoding.
     */
    public static final Encoding ISO_8859_4 = Iso4.INSTANCE;

    /**
     * The iso-8859-5 encoding.
     */
    public static final Encoding ISO_8859_5 = Iso5.INSTANCE;

    /**
     * The iso-8859-6 encoding.
     */
    public static final Encoding ISO_8859_6 = Iso6.INSTANCE;

    /**
     * The iso-8859-7 encoding.
     */
    public static final Encoding ISO_8859_7 = Iso7.INSTANCE;

    /**
     * The iso-8859-8 encoding.
     */
    public static final Encoding ISO_8859_8 = Iso8.INSTANCE;

    /**
     * The iso-8859-8-i encoding.
     */
    public static final Encoding ISO_8859_8_I = Iso8I.INSTANCE;

    /**
     * The koi8-r encoding.
     */
    public static final Encoding KOI8_R = Koi8R.INSTANCE;

    /**
     * The koi8-u encoding.
     */
    public static final Encoding KOI8_U = Koi8U.INSTANCE;

    /**
     * The macintosh encoding.
     */
    public static final Encoding MACINTOSH = Macintosh.INSTANCE;

    /**
     * The replacement encoding.
     */
    public static final Encoding REPLACEMENT = Replacement.INSTANCE;

    /**
     * The shift_jis encoding.
     */
    public static final Encoding SHIFT_JIS = ShiftJis.INSTANCE;

    /**
     * The utf-16be encoding.
     */
    public static final Encoding UTF_16BE = Utf16Be.INSTANCE;

    /**
     * The utf-16le encoding.
     */
    public static final Encoding UTF_16LE = Utf16Le.INSTANCE;

    /**
     * The utf-8 encoding.
     */
    public static final Encoding UTF_8 = Utf8.INSTANCE;

    /**
     * The windows-1250 encoding.
     */
    public static final Encoding WINDOWS_1250 = Windows1250.INSTANCE;

    /**
     * The windows-1251 encoding.
     */
    public static final Encoding WINDOWS_1251 = Windows1251.INSTANCE;

    /**
     * The windows-1252 encoding.
     */
    public static final Encoding WINDOWS_1252 = Windows1252.INSTANCE;

    /**
     * The windows-1253 encoding.
     */
    public static final Encoding WINDOWS_1253 = Windows1253.INSTANCE;

    /**
     * The windows-1254 encoding.
     */
    public static final Encoding WINDOWS_1254 = Windows1254.INSTANCE;

    /**
     * The windows-1255 encoding.
     */
    public static final Encoding WINDOWS_1255 = Windows1255.INSTANCE;

    /**
     * The windows-1256 encoding.
     */
    public static final Encoding WINDOWS_1256 = Windows1256.INSTANCE;

    /**
     * The windows-1257 encoding.
     */
    public static final Encoding WINDOWS_1257 = Windows1257.INSTANCE;

    /**
     * The windows-1258 encoding.
     */
    public static final Encoding WINDOWS_1258 = Windows1258.INSTANCE;

    /**
     * The windows-874 encoding.
     */
    public static final Encoding WINDOWS_874 = Windows874.INSTANCE;

    /**
     * The x-mac-cyrillic encoding.
     */
    public static final Encoding X_MAC_CYRILLIC = MacCyrillic.INSTANCE;

    /**
     * The x-user-defined encoding.
     */
    public static final Encoding X_USER_DEFINED = UserDefined.INSTANCE;


private static SortedMap<String, Charset> encodings = null;

    protected Encoding(String canonicalName, String[] aliases) {
        super(canonicalName, aliases);
    }

    private enum State {
        HEAD, LABEL, TAIL
    };

    public static Encoding forName(String label) {
        if (label == null) {
            throw new IllegalArgumentException("Label must not be null.");
        }
        if (label.length() == 0) {
            throw new IllegalCharsetNameException(label);
        }
        // First try the fast path
        int index = Arrays.binarySearch(LABELS, label);
        if (index >= 0) {
            return ENCODINGS_FOR_LABELS[index];
        }
        // Else, slow path
        StringBuilder sb = new StringBuilder();
        State state = State.HEAD;
        for (int i = 0; i < label.length(); i++) {
            char c = label.charAt(i);
            if ((c == ' ') || (c == '\n') || (c == '\r') || (c == '\t')
                    || (c == '\u000C')) {
                if (state == State.LABEL) {
                    state = State.TAIL;
                }
                continue;
            }
            if ((c >= 'a' && c <= 'z') || (c >= '0' && c <= '9')) {
                switch (state) {
                    case HEAD:
                        state = State.LABEL;
                        // Fall through
                    case LABEL:
                        sb.append(c);
                        continue;
                    case TAIL:
                        throw new IllegalCharsetNameException(label);
                }
            }
            if (c >= 'A' && c <= 'Z') {
                c += 0x20;
                switch (state) {
                    case HEAD:
                        state = State.LABEL;
                        // Fall through
                    case LABEL:
                        sb.append(c);
                        continue;
                    case TAIL:
                        throw new IllegalCharsetNameException(label);
                }
            }
            if ((c == '-') || (c == '+') || (c == '.') || (c == ':')
                    || (c == '_')) {
                switch (state) {
                    case LABEL:
                        sb.append(c);
                        continue;
                    case HEAD:
                    case TAIL:
                        throw new IllegalCharsetNameException(label);
                }
            }
            throw new IllegalCharsetNameException(label);
        }
        index = Arrays.binarySearch(LABELS, sb.toString());
        if (index >= 0) {
            return ENCODINGS_FOR_LABELS[index];
        }
        throw new UnsupportedCharsetException(label);
    }

    public static Encoding forNameNoReplacement(String label) {
        Encoding encoding = Encoding.forName(label);
        if (encoding == Encoding.REPLACEMENT) {
            throw new UnsupportedCharsetException(label);            
        }
        return encoding;
    }

    public static boolean isSupported(String label) {
        try {
            Encoding.forName(label);
        } catch (UnsupportedCharsetException e) {
            return false;
        }
        return true;
    }

    public static boolean isSupportedNoReplacement(String label) {
        try {
            Encoding.forNameNoReplacement(label);
        } catch (UnsupportedCharsetException e) {
            return false;
        }
        return true;
    }

    public static SortedMap<String, Charset> availableCharsets() {
        if (encodings == null) {
            TreeMap<String, Charset> map = new TreeMap<String, Charset>();
            for (Encoding encoding : ENCODINGS) {
                map.put(encoding.name(), encoding);
            }
            encodings = Collections.unmodifiableSortedMap(map);
        }
        return encodings;
    }

    public static Encoding defaultCharset() {
        return WINDOWS_1252;
    }

    @Override public boolean canEncode() {
        return false;
    }

    @Override public boolean contains(Charset cs) {
        return false;
    }

    @Override public CharsetEncoder newEncoder() {
        throw new UnsupportedOperationException("Encoder not implemented.");
    }
}
