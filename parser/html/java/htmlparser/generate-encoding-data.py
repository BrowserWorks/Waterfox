#!/usr/bin/python

# Copyright (c) 2013-2015 Mozilla Foundation
#
# Permission is hereby granted, free of charge, to any person obtaining a 
# copy of this software and associated documentation files (the "Software"), 
# to deal in the Software without restriction, including without limitation 
# the rights to use, copy, modify, merge, publish, distribute, sublicense, 
# and/or sell copies of the Software, and to permit persons to whom the 
# Software is furnished to do so, subject to the following conditions:
#
# The above copyright notice and this permission notice shall be included in 
# all copies or substantial portions of the Software.
#
# THE SOFTWARE IS PROVIDED "AS IS", WITHOUT WARRANTY OF ANY KIND, EXPRESS OR 
# IMPLIED, INCLUDING BUT NOT LIMITED TO THE WARRANTIES OF MERCHANTABILITY, 
# FITNESS FOR A PARTICULAR PURPOSE AND NONINFRINGEMENT. IN NO EVENT SHALL 
# THE AUTHORS OR COPYRIGHT HOLDERS BE LIABLE FOR ANY CLAIM, DAMAGES OR OTHER 
# LIABILITY, WHETHER IN AN ACTION OF CONTRACT, TORT OR OTHERWISE, ARISING 
# FROM, OUT OF OR IN CONNECTION WITH THE SOFTWARE OR THE USE OR OTHER 
# DEALINGS IN THE SOFTWARE.

import json

class Label:
  def __init__(self, label, preferred):
    self.label = label
    self.preferred = preferred
  def __cmp__(self, other):
    return cmp(self.label, other.label)

# If a multi-byte encoding is on this list, it is assumed to have a
# non-generated decoder implementation class. Otherwise, the JDK default
# decoder is used as a placeholder.
MULTI_BYTE_DECODER_IMPLEMENTED = [
  u"x-user-defined",
  u"replacement",
  u"big5",
]

MULTI_BYTE_ENCODER_IMPLEMENTED = [
  u"big5",
]

preferred = []

labels = []

data = json.load(open("../encoding/encodings.json", "r"))

indexes = json.load(open("../encoding/indexes.json", "r"))

single_byte = []

multi_byte = []

def to_camel_name(name):
  if name == u"iso-8859-8-i":
    return u"Iso8I"
  if name.startswith(u"iso-8859-"):
    return name.replace(u"iso-8859-", u"Iso")
  return name.title().replace(u"X-", u"").replace(u"-", u"").replace(u"_", u"")

def to_constant_name(name):
  return name.replace(u"-", u"_").upper()

# Encoding.java

for group in data:
  if group["heading"] == "Legacy single-byte encodings":
    single_byte = group["encodings"]
  else:
    multi_byte.extend(group["encodings"])
  for encoding in group["encodings"]:
    preferred.append(encoding["name"])
    for label in encoding["labels"]:
      labels.append(Label(label, encoding["name"]))

preferred.sort()
labels.sort()

label_file = open("src/nu/validator/encoding/Encoding.java", "w")

label_file.write("""/*
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
""")

for label in labels:
  label_file.write("        \"%s\",\n" % label.label)

label_file.write("""    };
    
    private static final Encoding[] ENCODINGS_FOR_LABELS = {
""")

for label in labels:
  label_file.write("        %s.INSTANCE,\n" % to_camel_name(label.preferred))

label_file.write("""    };

    private static final Encoding[] ENCODINGS = {
""")

for label in preferred:
  label_file.write("        %s.INSTANCE,\n" % to_camel_name(label))
        
label_file.write("""    };

""")

for label in preferred:
  label_file.write("""    /**
     * The %s encoding.
     */
    public static final Encoding %s = %s.INSTANCE;

""" % (label, to_constant_name(label), to_camel_name(label)))
        
label_file.write("""
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
            if ((c == ' ') || (c == '\\n') || (c == '\\r') || (c == '\\t')
                    || (c == '\\u000C')) {
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
""")

label_file.close()

# Single-byte encodings

for encoding in single_byte:
  name = encoding["name"]
  labels = encoding["labels"]
  labels.sort()
  class_name = to_camel_name(name)
  mapping_name = name
  if mapping_name == u"iso-8859-8-i":
    mapping_name = u"iso-8859-8"
  mapping = indexes[mapping_name]
  class_file = open("src/nu/validator/encoding/%s.java" % class_name, "w")
  class_file.write('''/*
 * Copyright (c) 2013-2015 Mozilla Foundation
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

/*
 * THIS IS A GENERATED FILE. PLEASE DO NOT EDIT.
 * Instead, please regenerate using generate-encoding-data.py
 */

package nu.validator.encoding;

import java.nio.charset.CharsetDecoder;

class ''')
  class_file.write(class_name)
  class_file.write(''' extends Encoding {

    private static final char[] TABLE = {''')
  fallible = False
  comma = False
  for code_point in mapping:
    # XXX should we have error reporting?
    if not code_point:
      code_point = 0xFFFD
      fallible = True
    if comma:
      class_file.write(",")
    class_file.write("\n        '\u%04x'" % code_point);
    comma = True    
  class_file.write('''
    };
    
    private static final String[] LABELS = {''')

  comma = False
  for label in labels:
    if comma:
      class_file.write(",")
    class_file.write("\n        \"%s\"" % label);
    comma = True    
  class_file.write('''
    };
    
    private static final String NAME = "''')
  class_file.write(name)
  class_file.write('''";
    
    static final Encoding INSTANCE = new ''')
  class_file.write(class_name)
  class_file.write('''();
    
    private ''')
  class_file.write(class_name)
  class_file.write('''() {
        super(NAME, LABELS);
    }

    @Override public CharsetDecoder newDecoder() {
        return new ''')
  class_file.write("Fallible" if fallible else "Infallible")
  class_file.write('''SingleByteDecoder(this, TABLE);
    }

}
''')
  class_file.close()

# Multi-byte encodings

for encoding in multi_byte:
  name = encoding["name"]
  labels = encoding["labels"]
  labels.sort()
  class_name = to_camel_name(name)
  class_file = open("src/nu/validator/encoding/%s.java" % class_name, "w")
  class_file.write('''/*
 * Copyright (c) 2013-2015 Mozilla Foundation
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

/*
 * THIS IS A GENERATED FILE. PLEASE DO NOT EDIT.
 * Instead, please regenerate using generate-encoding-data.py
 */

package nu.validator.encoding;

import java.nio.charset.Charset;
import java.nio.charset.CharsetDecoder;
import java.nio.charset.CharsetEncoder;

class ''')
  class_file.write(class_name)
  class_file.write(''' extends Encoding {

    private static final String[] LABELS = {''')

  comma = False
  for label in labels:
    if comma:
      class_file.write(",")
    class_file.write("\n        \"%s\"" % label);
    comma = True    
  class_file.write('''
    };
    
    private static final String NAME = "''')
  class_file.write(name)
  class_file.write('''";
    
    static final ''')
  class_file.write(class_name)
  class_file.write(''' INSTANCE = new ''')
  class_file.write(class_name)
  class_file.write('''();
    
    private ''')
  class_file.write(class_name)
  class_file.write('''() {
        super(NAME, LABELS);
    }

    @Override public CharsetDecoder newDecoder() {
        ''')
  if name == "gbk":
    class_file.write('''return Charset.forName("gb18030").newDecoder();''')    
  elif name in MULTI_BYTE_DECODER_IMPLEMENTED:
    class_file.write("return new %sDecoder(this);" % class_name)
  else:
    class_file.write('''return Charset.forName(NAME).newDecoder();''')
  class_file.write('''
    }

    @Override public CharsetEncoder newEncoder() {
        ''')
  if name in MULTI_BYTE_ENCODER_IMPLEMENTED:
    class_file.write("return new %sEncoder(this);" % class_name)
  else:
    class_file.write('''return Charset.forName(NAME).newEncoder();''')
  class_file.write('''
    }
}
''')
  class_file.close()

# Big5

def null_to_zero(code_point):
  if not code_point:
    code_point = 0
  return code_point

index = []

for code_point in indexes["big5"]:
  index.append(null_to_zero(code_point))  

# There are four major gaps consisting of more than 4 consecutive invalid pointers
gaps = []
consecutive = 0
consecutive_start = 0
offset = 0
for code_point in index:
  if code_point == 0:
    if consecutive == 0:
      consecutive_start = offset
    consecutive +=1
  else:
    if consecutive > 4:
      gaps.append((consecutive_start, consecutive_start + consecutive))
    consecutive = 0
  offset += 1

def invert_ranges(ranges, cap):
  inverted = []
  invert_start = 0
  for (start, end) in ranges:
    if start != 0:
      inverted.append((invert_start, start))
    invert_start = end
  inverted.append((invert_start, cap))
  return inverted

cap = len(index)
ranges = invert_ranges(gaps, cap)

# Now compute a compressed lookup table for astralness

gaps = []
consecutive = 0
consecutive_start = 0
offset = 0
for code_point in index:
  if code_point <= 0xFFFF:
    if consecutive == 0:
      consecutive_start = offset
    consecutive +=1
  else:
    if consecutive > 40:
      gaps.append((consecutive_start, consecutive_start + consecutive))
    consecutive = 0
  offset += 1

astral_ranges = invert_ranges(gaps, cap)

class_file = open("src/nu/validator/encoding/Big5Data.java", "w")
class_file.write('''/*
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

/*
 * THIS IS A GENERATED FILE. PLEASE DO NOT EDIT.
 * Instead, please regenerate using generate-encoding-data.py
 */

package nu.validator.encoding;

final class Big5Data {

    private static final String ASTRALNESS = "''')

bits = []
for (low, high) in astral_ranges:
  for i in xrange(low, high):
    bits.append(1 if index[i] > 0xFFFF else 0)
# pad length to multiple of 16
for j in xrange(16 - (len(bits) % 16)):
  bits.append(0)

i = 0
while i < len(bits):
  accu = 0
  for j in xrange(16):
    accu |= bits[i + j] << j
  if accu == 0x22:
    class_file.write('\\"')
  else:
    class_file.write('\\u%04X' % accu)
  i += 16

class_file.write('''";

''')

j = 0
for (low, high) in ranges:
  class_file.write('''    private static final String TABLE%d = "''' % j)
  for i in xrange(low, high):
    class_file.write('\\u%04X' % (index[i] & 0xFFFF))
  class_file.write('''";

''')
  j += 1

class_file.write('''    private static boolean readBit(int i) {
        return (ASTRALNESS.charAt(i >> 4) & (1 << (i & 0xF))) != 0;
    }

    static char lowBits(int pointer) {
''')

j = 0
for (low, high) in ranges:
  class_file.write('''        if (pointer < %d) {
            return '\\u0000';
        }
        if (pointer < %d) {
            return TABLE%d.charAt(pointer - %d);
        }
''' % (low, high, j, low))
  j += 1

class_file.write('''        return '\\u0000';
    }

    static boolean isAstral(int pointer) {
''')

base = 0
for (low, high) in astral_ranges:
  if high - low == 1:
    class_file.write('''        if (pointer < %d) {
            return false;
        }
        if (pointer == %d) {
            return true;
        }
''' % (low, low))
  else:
    class_file.write('''        if (pointer < %d) {
            return false;
        }
        if (pointer < %d) {
            return readBit(%d + (pointer - %d));
        }
''' % (low, high, base, low))
  base += (high - low)

class_file.write('''        return false;
    }

    public static int findPointer(char lowBits, boolean isAstral) {
        if (!isAstral) {
            switch (lowBits) {
''')

hkscs_bound = (0xA1 - 0x81) * 157

prefer_last = [
  0x2550,
  0x255E,
  0x2561,
  0x256A,
  0x5341,
  0x5345,
]

for code_point in prefer_last:
  # Python lists don't have .rindex() :-(
  for i in xrange(len(index) - 1, -1, -1):
    candidate = index[i]
    if candidate == code_point:
       class_file.write('''                case 0x%04X:
                    return %d;
''' % (code_point, i))
       break

class_file.write('''                default:
                    break;
            }
        }''')

j = 0
for (low, high) in ranges:
  if high > hkscs_bound:
    start = 0
    if low <= hkscs_bound and hkscs_bound < high:
      # This is the first range we don't ignore and the
      # range that contains the first non-HKSCS pointer.
      # Avoid searching HKSCS.
      start = hkscs_bound - low
    class_file.write('''
        for (int i = %d; i < TABLE%d.length(); i++) {
            if (TABLE%d.charAt(i) == lowBits) {
                int pointer = i + %d;
                if (isAstral == isAstral(pointer)) {
                    return pointer;
                }
            }
        }''' % (start, j, j, low))
  j += 1

class_file.write('''
        return 0;
    }
}
''')
class_file.close()
