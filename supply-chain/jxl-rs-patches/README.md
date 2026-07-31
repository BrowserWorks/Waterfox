# jxl-rs 0.7.4 backport

Production changes from [Firefox bug 2073321](https://bugzilla.mozilla.org/show_bug.cgi?id=2073321):
upstream [0.7.4](https://github.com/libjxl/jxl-rs/releases/tag/v0.7.4)
(non-444 LF upscaling fix, missing squeeze tiles treated as zero, TOC decode guard),
with the local integration and test adaptations below.

## Local differences

- The old macOS x86_64 SIMD workaround is omitted.
- Decoder integration uses the upstream sequential runner fallback.
- Web-platform test tolerances and references are updated, and vendor regression fixtures are included.
- Vendored tests are adapted to auxiliary-box construction, buffer recycling, and runner thread-count APIs.
