# Local jxl-rs 0.6.0 patches

## Provenance and review status

The baseline is the published crates.io release of `jxl`, `jxl_macros`,
`jxl_simd`, and `jxl_transforms` version 0.6.0, corresponding to upstream revision
`fbed310bda2496c97672f7f427ca7a2aebe035d4` in
<https://github.com/libjxl/jxl-rs>.

The `jxl` and `jxl_simd` directories contain **locally patched copies**, rather
than the unmodified audited release. Root `[patch.crates-io]` entries select
these copies. Their root lockfile entries are path-sourced and therefore have
no registry source or checksum. `jxl_macros` and `jxl_transforms` remain
unmodified published crates.

The Google audits imported by the Firefox update apply exclusively to the
published 0.6.0 baseline. `audit-as-crates-io = true` follows the existing
local-patch policy and allows cargo-vet to use those baseline audits; it does
not certify the local changes. **The backport delta still requires local
supply-chain and code review.** No new audit or exemption is asserted here.
A cargo-vet result must not be interpreted as a review of this patch series.

The `.cargo_vcs_info.json` files retain the published release revision. Each
`.cargo-checksum.json` retains the SHA-256 of the published package archive in
`package`; its `files` map hashes the actual vendored bytes, including local
production changes. The archive checksum identifies
the baseline, not a newly published patched package.

| Published archive | SHA-256 |
| --- | --- |
| jxl-0.6.0.crate | `7b36e70efc347a34540f61ae91b7dc304ab0bb69bd6ac62fae182389c2788016` |
| jxl_macros-0.6.0.crate | `96f637cf167445cc64f12f59869e2d2dd4225f1db7e37ec33d1738c2c334d448` |
| jxl_simd-0.6.0.crate | `7fb521e862fff1898373196c7c884f563210d2dba066d5dc08f36fc6cab35f17` |
| jxl_transforms-0.6.0.crate | `77097b14a98fa6f8bde99bd16dcd19e15a8ecceaba42a8d539138090e92dcf27` |

## Base update

The Firefox bug 2064595 series was downloaded over HTTPS from
`https://github.com/mozilla-firefox/firefox/commit/<revision>.patch` and applied
with scoped `git apply --include` filters, rather than cherry-picked:

1. `8d56afaee49d384b7be7887bea98d4b92958af12`: temporarily remove the SIMD workaround.
2. `a81f63e62e89182c581ff391d1259566ebd8a641`: vendor published 0.6.0 and import its audits.
3. `33829f650c7729d7157f0aa4611a6aa7b6f7be21`: restore the SIMD workaround.

The wrapper manifest was updated as part of the Gecko integration described
below. The existing root SIMD path override was retained throughout, as the
removal and restoration sequence produces no net change to it. The supply-chain
policy's baseline version was updated manually because the neighbouring local
policies differ from upstream.

`00-macos-simd-workaround.patch` records the vendored portion of the third
patch. The AVX/AVX-512 sources are byte-for-byte identical to their pre-update
versions, including the macOS and Rust-before-1.95 conditions and existing
safety comments. The `rustversion` dependency and root SIMD path override are
preserved.

## Backports in application order

All revisions below are from `libjxl/jxl-rs`; the original patches are available
at `https://github.com/libjxl/jxl-rs/commit/<revision>.patch`. The numbered patch
files retain upstream authorship and commit messages, subject to the scope and
adaptations described below.

| Patch | Upstream revision | Purpose / dependency |
| --- | --- | --- |
| 01 | `a61dfa7647e095a2cef15d4ad58f1e06c8222b92` | Avoid unwrapping an absent type for unused greyscale VarDCT scratch channels. |
| 02 | `dcc3e816e89f985352d3d3fa752cd1ba32fc9e3c` | Compute the histogram count in `usize`, allowing cluster index 255. |
| 03 | `2742954e351fb1926c1ee5da17147e010bad0eb2` | Normalise empty local palette buffers to allocated 0x0 dimensions. |
| 04 | `ba5cac0ed4ab6fdc7467ce256801a3bafa761ef5` | Require LZ77 to be enabled before selecting the modular RLE fast path. |
| 05 | `0f41860125174b6d08cf2826dd2836135664cc69` | Bug 2068500: validate custom primaries; reject ICC tag arithmetic overflow and narrowing. |
| 06 | `2f46629097983db35aabe85f7b1b4d82997ce9a2` | Bug 2068500 follow-up: use the selected standard white point and validate custom white points. Requires 05. |
| 07 | `1bf44e6f6366723a563771a0bbdd723421808fc2` | Bug 2068521: return an image-size error on allocation-size or layout overflow. |
| 08 | `450fef016d5d9c848a92b041b29f844a008f1e78` | Bug 2070259: construct ready rectangles lazily to avoid subtraction overflow for rejected rectangles. |
| 09 | `964211a1aeecb023482a84509ce248e1239ec52c` | Scheduler follow-up: clamp and order boundary points, and reject zero-area rectangles. Requires 08; the test-only Shuttle replay adjustment is omitted. |
| 10 | `5dfeb9e5fddb1ffebb709745f9c4739ec0cc2e82` | Bug 2070572: account for both horizontal borders in per-stage row-buffer capacity. |
| 11 | `744d81865ebe251804c63b3dbf0ec9ced0e9719a` | Bug 2070572 follow-up: also enlarge input row buffers. Complements 10. |
| 12 | `00c67ce711fe074d1783fd5e8bd6d6de1797b91d` | Return the actual missing TOC byte count rather than an inflated refill estimate. |
| 13 | `17d0b7205cf6eba2325fde8786a7d72c290259e8` | Skip exhausted or empty buffered out-of-order jxlp boxes before exposing input. |

All six additional candidates were applicable; none of their library fixes
was excluded. The two colour-validation patches form a pair: 05 alone
mishandles custom primaries with standard white points. The rectangle and
row-capacity follow-ups are also retained, rather than treating the initial
patches as complete fixes.

### Adaptations and exclusions

- 04: omit the repository-level `AUTHORS` hunk, which is outside the vendored
  crate's scope. Authorship remains in the patch header.
- 05 and 06: adjust only the import-hunk context for 0.6.0's grouped imports;
  the new imports and functional changes are unchanged. Their colour-matrix
  helpers already exist in 0.6.0, so no additional API implementation is needed.
- Retained production hunks apply in the listed order without functional adaptation.
- Omit all backport-added tests, eight binary fixtures, and test-only Shuttle
  changes, including the embedded regression tests in 06 and 08. Tests already
  present in the published 0.6.0 crates remain unchanged. The numbered patches
  record these omissions so re-vendoring does not restore the removed additions.
- Do not enable Shuttle or vendor its dependencies.
- Wrapper manifests, decoder wrappers, and the root `jxl_decoder` package entry
  are outside this library patch series; they are covered by the Gecko
  integration below.

## Gecko integration and surrounding-fix audit

Audit cutoff: 10 September 2026. The initial Waterfox backport was
`7519ef80c187c11dcc3d54144296f399fc1cd074` (0.5.1).

The following changes were present before this update:

- Bugs 2043090, 2058416, and 2058355: macOS SIMD workaround, API compatibility,
  vendored 0.5.1, and licence metadata.
- Bug 2052703 (`3086965daacfdc5f1686ec058a7354fe3b919f18`): widen the CMYK
  K-buffer allocation multiplication.
- Bug 2063994 (`309e88ef43bc511f52065cd3777e884f10eea526`): widen pixel-loop
  and index arithmetic.
- Earlier progressive, frame-scan, animation, and CMS corrections, including
  bugs 2032788, 2033688, 2034408, 2034974, 2034983/4, 2036329, and 2037396.

The two overflow bugs are not publicly readable in Bugzilla; their public
upstream patches match the local changes. This does not establish comprehensive
coverage of restricted bugs or undisclosed vulnerabilities.

Additional Firefox revisions incorporated from `mozilla-firefox/firefox`:

| Bug | Revision | Change |
| --- | --- | --- |

| 2055820 | `75cf81c81496713701c84e93d361ffe38ef571cc` | Preserve f16 precision through qcms CLUT interpolation; omit the test-only benchmark. |
| 2064595 | `f39d0f94e1cc4ae2deb7da49f2891b0a6a20244c` | Adapt the three decoder calls to the 0.6.0 parallel-runner API, combined with the runner wiring below. |
| 2064595 | `d12d8165951ae4152e6b9a7d6e418f7f269626d5` | Update dithering tolerances in eight WPTs. Move local fuzzy-only metadata into HTML to avoid overriding the new tolerances. |
| 2065753 | `6af1ede335ea7e77db4fe538fa9cc053ba55133c` | Incorporate the final relanded dedicated SharedThreadPool implementation, Rust dependencies, cbindgen forward declaration, and shutdown wiring. |

The runner wiring is adapted to the older wrapper without importing optional
logging bug 2055221 or restoring the removed `num_completed_passes` API.
The optional CICP fast path (2055222/2055224) and telemetry (2055229) are not
prerequisites and are not included.

To keep the backport focused on production fixes, the test-only revisions for
2054317 (`a4a84a8497f6e0bb85643fd3e86bc57a11ae6a6f`) and 2065753
(`cdce7a837da92c6cb830e268b6d3ffd26763b848`) are omitted, along with their binary
fixtures. The library fix for 2054317 was already in 0.5.1. Existing Gecko tests
and the expectation adjustments for 0.6.0 dithering are retained.

One local correction to the relanded pool implementation snapshots the resolved
participant count in each `PoolRunner` and passes it to both pool acquisition
and helper scheduling. Re-reading the live preference between these operations
could otherwise create and permanently cache a zero-thread pool when switching
to serial decoding. The C++ boundary also rejects zero-thread requests. The
snapshot is per `process_data`/`flush_pixels` call, not per entire incremental
image. The backport-specific boundary test is omitted with the other test
additions.

Parallel decoding remains **disabled by default**, with
`image.jxl.decode_participants = 1`. The separate enablement bug 2069326
(`93222b3aae1f8632d42cd4dea1ce9b9ca6ddd9b6`) is deliberately not applied.
The row-buffer fixes associated with 2070572 are included, but upstream had
not confirmed resolution of its original AVX-512 crash at the cutoff. Serial
mode reduces exposure; it does not replace the incremental-decoding fixes above.

This is a patched 0.6.0 backport, not Firefox's as-yet-unlanded 0.7.x update
(bug 2069212). It should not be interpreted as a claim that every possible
decoder crash has been fixed.
