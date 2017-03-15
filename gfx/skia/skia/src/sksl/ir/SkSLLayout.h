/*
 * Copyright 2016 Google Inc.
 *
 * Use of this source code is governed by a BSD-style license that can be
 * found in the LICENSE file.
 */
 
#ifndef SKSL_LAYOUT
#define SKSL_LAYOUT

namespace SkSL {

/**
 * Represents a layout block appearing before a variable declaration, as in:
 *
 * layout (location = 0) int x;
 */
struct Layout {
    Layout(const ASTLayout& layout)
    : fLocation(layout.fLocation)
    , fBinding(layout.fBinding)
    , fIndex(layout.fIndex)
    , fSet(layout.fSet)
    , fBuiltin(layout.fBuiltin)
    , fOriginUpperLeft(layout.fOriginUpperLeft) {}

    Layout(int location, int binding, int index, int set, int builtin, bool originUpperLeft)
    : fLocation(location)
    , fBinding(binding)
    , fIndex(index)
    , fSet(set)
    , fBuiltin(builtin)
    , fOriginUpperLeft(originUpperLeft) {}

    std::string description() const {
        std::string result;
        std::string separator;
        if (fLocation >= 0) {
            result += separator + "location = " + to_string(fLocation);
            separator = ", ";
        }
        if (fBinding >= 0) {
            result += separator + "binding = " + to_string(fBinding);
            separator = ", ";
        }
        if (fIndex >= 0) {
            result += separator + "index = " + to_string(fIndex);
            separator = ", ";
        }
        if (fSet >= 0) {
            result += separator + "set = " + to_string(fSet);
            separator = ", ";
        }
        if (fBuiltin >= 0) {
            result += separator + "builtin = " + to_string(fBuiltin);
            separator = ", ";
        }
        if (fOriginUpperLeft) {
            result += separator + "origin_upper_left";
            separator = ", ";
        }
        if (result.length() > 0) {
            result = "layout (" + result + ")";
        }
        return result;
    }

    bool operator==(const Layout& other) const {
        return fLocation == other.fLocation &&
               fBinding  == other.fBinding &&
               fIndex    == other.fIndex &&
               fSet      == other.fSet &&
               fBuiltin  == other.fBuiltin;
    }

    bool operator!=(const Layout& other) const {
        return !(*this == other);
    }

    // everything but builtin is in the GLSL spec; builtin comes from SPIR-V and identifies which
    // particular builtin value this object represents.
    int fLocation;
    int fBinding;
    int fIndex;
    int fSet;
    int fBuiltin;
    bool fOriginUpperLeft;
};

} // namespace

#endif
