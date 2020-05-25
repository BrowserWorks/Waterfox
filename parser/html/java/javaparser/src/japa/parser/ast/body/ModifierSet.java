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
package japa.parser.ast.body;

/**
 * Class to hold modifiers.
 */
public final class ModifierSet {

    /* Definitions of the bits in the modifiers field.  */
    public static final int PUBLIC = 0x0001;

    public static final int PROTECTED = 0x0002;

    public static final int PRIVATE = 0x0004;

    public static final int ABSTRACT = 0x0008;

    public static final int STATIC = 0x0010;

    public static final int FINAL = 0x0020;

    public static final int SYNCHRONIZED = 0x0040;

    public static final int NATIVE = 0x0080;

    public static final int TRANSIENT = 0x0100;

    public static final int VOLATILE = 0x0200;

    public static final int STRICTFP = 0x1000;

    /**
     * Adds the given modifier.
     */
    public static int addModifier(int modifiers, int mod) {
        return modifiers |= mod;
    }

    public static boolean hasModifier(int modifiers, int modifier) {
        return (modifiers & modifier) != 0;
    }

    public static boolean isAbstract(int modifiers) {
        return (modifiers & ABSTRACT) != 0;
    }

    public static boolean isFinal(int modifiers) {
        return (modifiers & FINAL) != 0;
    }

    public static boolean isNative(int modifiers) {
        return (modifiers & NATIVE) != 0;
    }

    public static boolean isPrivate(int modifiers) {
        return (modifiers & PRIVATE) != 0;
    }

    public static boolean isProtected(int modifiers) {
        return (modifiers & PROTECTED) != 0;
    }

    /**
     * A set of accessors that indicate whether the specified modifier is in the
     * set.
     */

    public static boolean isPublic(int modifiers) {
        return (modifiers & PUBLIC) != 0;
    }

    public static boolean isStatic(int modifiers) {
        return (modifiers & STATIC) != 0;
    }

    public static boolean isStrictfp(int modifiers) {
        return (modifiers & STRICTFP) != 0;
    }

    public static boolean isSynchronized(int modifiers) {
        return (modifiers & SYNCHRONIZED) != 0;
    }

    public static boolean isTransient(int modifiers) {
        return (modifiers & TRANSIENT) != 0;
    }

    public static boolean isVolatile(int modifiers) {
        return (modifiers & VOLATILE) != 0;
    }

    /**
     * Removes the given modifier.
     */
    public static int removeModifier(int modifiers, int mod) {
        return modifiers &= ~mod;
    }

    private ModifierSet() {
    }
}