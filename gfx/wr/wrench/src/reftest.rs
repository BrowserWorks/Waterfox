/* This Source Code Form is subject to the terms of the Mozilla Public
 * License, v. 2.0. If a copy of the MPL was not distributed with this
 * file, You can obtain one at http://mozilla.org/MPL/2.0/. */

use crate::{WindowWrapper, NotifierEvent};
use base64::Engine as _;
use image::load as load_piston_image;
use image::png::PNGEncoder;
use image::{ColorType, ImageFormat};
use crate::parse_function::parse_function;
use crate::png::save_flipped;
use std::{cmp, env};
use std::fmt::{Display, Error, Formatter};
use std::fs::File;
use std::io::{BufRead, BufReader};
use std::path::{Path, PathBuf};
use std::process::Command;
use std::sync::mpsc::Receiver;
use webrender::RenderResults;
use webrender::api::*;
use webrender::render_api::*;
use webrender::api::units::*;
use crate::wrench::{Wrench, WrenchThing};
use crate::yaml_frame_reader::YamlFrameReader;


const OPTION_DISABLE_SUBPX: &str = "disable-subpixel";
const OPTION_DISABLE_AA: &str = "disable-aa";
const OPTION_ALLOW_MIPMAPS: &str = "allow-mipmaps";

/// Split a manifest line into whitespace-separated tokens, but treat any
/// parenthesized or bracketed argument list as part of a single token so that
/// options such as `scale(1.0, 1.5, 2.0)` may contain spaces between arguments.
fn split_manifest_tokens(s: &str) -> Vec<&str> {
    let mut tokens = Vec::new();
    let mut depth = 0i32;
    let mut start = None;
    for (i, c) in s.char_indices() {
        match c {
            '(' | '[' => depth += 1,
            ')' | ']' => depth = (depth - 1).max(0),
            _ => {}
        }
        if c.is_whitespace() && depth == 0 {
            if let Some(begin) = start.take() {
                tokens.push(&s[begin .. i]);
            }
        } else if start.is_none() {
            start = Some(i);
        }
    }
    if let Some(begin) = start {
        tokens.push(&s[begin ..]);
    }
    tokens
}

/// Resolve the png reference to load for a given device pixel scale. Looks for
/// a scale-specific variant `<name>-scale:<scale>.png` next to `reference` and
/// falls back to `reference` itself when that variant doesn't exist. Non-png
/// references and the default 1.0 scale are returned unchanged.
fn scaled_reference_path(reference: &Path, device_pixel_scale: f32) -> PathBuf {
    if device_pixel_scale == 1.0 ||
        reference.extension().and_then(|e| e.to_str()) != Some("png") {
        return reference.to_path_buf();
    }

    let stem = reference.file_stem().unwrap().to_str().unwrap();
    let scaled = reference.with_file_name(format!("{}-scale{}.png", stem, device_pixel_scale));
    if scaled.exists() {
        scaled
    } else {
        reference.to_path_buf()
    }
}

pub struct ReftestOptions {
    // These override values that are lower.
    pub allow_max_difference: usize,
    pub allow_num_differences: usize,
}

impl ReftestOptions {
    pub fn default() -> Self {
        ReftestOptions {
            allow_max_difference: 0,
            allow_num_differences: 0,
        }
    }
}

#[derive(Debug, Copy, Clone)]
pub enum ReftestOp {
    /// Expect that the images match the reference
    Equal,
    /// Expect that the images *don't* match the reference
    NotEqual,
    /// Expect that drawing the reference at different tiles sizes gives the same pixel exact result.
    Accurate,
    /// Expect that drawing the reference at different tiles sizes gives a *different* pixel exact result.
    Inaccurate,
}

impl Display for ReftestOp {
    fn fmt(&self, f: &mut Formatter) -> Result<(), Error> {
        write!(
            f,
            "{}",
            match *self {
                ReftestOp::Equal => "==".to_owned(),
                ReftestOp::NotEqual => "!=".to_owned(),
                ReftestOp::Accurate => "**".to_owned(),
                ReftestOp::Inaccurate => "!*".to_owned(),
            }
        )
    }
}

#[derive(Debug)]
enum ExtraCheck {
    DrawCalls(usize),
    AlphaTargets(usize),
    ColorTargets(usize),
}

impl ExtraCheck {
    fn run(&self, results: &[RenderResults]) -> bool {
        match *self {
            ExtraCheck::DrawCalls(x) =>
                x == results.last().unwrap().stats.total_draw_calls,
            ExtraCheck::AlphaTargets(x) =>
                x == results.last().unwrap().stats.alpha_target_count,
            ExtraCheck::ColorTargets(x) =>
                x == results.last().unwrap().stats.color_target_count,
        }
    }
}

#[derive(Clone, Copy)]
pub struct RefTestFuzzy {
    max_difference: usize,
    num_differences: usize,
}

pub struct Reftest {
    op: ReftestOp,
    test: Vec<PathBuf>,
    reference: PathBuf,
    font_render_mode: Option<FontRenderMode>,
    fuzziness: Vec<RefTestFuzzy>,
    /// Fuzziness overrides that only apply when running at a specific device
    /// pixel scale (via `fuzzy-if(scale(X), ...)` / `fuzzy-range-if(scale(X),
    /// ...)`). Each entry is already finalized for its scale. Looked up in
    /// `fuzziness_for_scale`; falls back to `fuzziness` when no scale matches.
    scale_fuzziness: Vec<(f32, Vec<RefTestFuzzy>)>,
    extra_checks: Vec<ExtraCheck>,
    allow_mipmaps: bool,
    force_subpixel_aa_where_possible: Option<bool>,
    max_surface_override: Option<usize>,
    /// Device pixel scales at which to run this test. Defaults to a single
    /// `1.0` entry. When more than one is specified (via the `scale(...)`
    /// reftest option) the test is run once per scale.
    scales: Vec<f32>,
}

impl Reftest {
    /// The fuzziness to use when running at the given device pixel scale. Uses a
    /// scale-specific override if one was provided, otherwise the default.
    fn fuzziness_for_scale(&self, device_pixel_scale: f32) -> &[RefTestFuzzy] {
        self.scale_fuzziness
            .iter()
            .find(|(scale, _)| *scale == device_pixel_scale)
            .map(|(_, fuzziness)| fuzziness.as_slice())
            .unwrap_or(&self.fuzziness)
    }

    /// Check the positive case (expecting equality) and report details if different
    fn check_and_report_equality_failure(
        &self,
        comparison: ReftestImageComparison,
        test: &ReftestImage,
        reference: &ReftestImage,
        fuzziness: &[RefTestFuzzy],
        test_name: &str,
    ) -> bool {
        match comparison {
            ReftestImageComparison::Equal => {
                true
            }
            ReftestImageComparison::NotEqual { difference_histogram, max_difference, count_different } => {
                // Each entry in the sorted self.fuzziness list represents a bucket which
                // allows at most num_differences pixels with a difference of at most
                // max_difference -- but with the caveat that a difference which is small
                // enough to be less than a max_difference of an earlier bucket, must be
                // counted against that bucket.
                //
                // Thus the test will fail if the number of pixels with a difference
                // > fuzzy[j-1].max_difference and <= fuzzy[j].max_difference
                // exceeds fuzzy[j].num_differences.
                //
                // (For the first entry, consider fuzzy[j-1] to allow zero pixels of zero
                // difference).
                //
                // For example, say we have this histogram of differences:
                //
                //       | [0] [1] [2] [3] [4] [5] [6] ... [255]
                // ------+------------------------------------------
                // Hist. |  0   3   2   1   6   2   0  ...   0
                //
                // Ie. image comparison found 3 pixels that differ by 1, 2 that differ by 2, etc.
                // (Note that entry 0 is always zero, we don't count matching pixels.)
                //
                // First we calculate an inclusive prefix sum:
                //
                //       | [0] [1] [2] [3] [4] [5] [6] ... [255]
                // ------+------------------------------------------
                // Hist. |  0   3   2   1   6   2   0  ...   0
                // Sum   |  0   3   5   6  12  14  14  ...  14
                //
                // Let's say the fuzzy statements are:
                // Fuzzy( 2, 6 )    -- allow up to 6 pixels that differ by 2 or less
                // Fuzzy( 4, 8 )    -- allow up to 8 pixels that differ by 4 or less _but_
                //                     also by more than 2 (= by 3 or 4).
                //
                // The first  check is Sum[2] <= max 6  which passes: 5 <= 6.
                // The second check is Sum[4] - Sum[2] <= max 8  which passes: 12-5 <= 8.
                // Finally we check if there are any pixels that exceed the max difference (4)
                // by checking Sum[255] - Sum[4] which shows there are 14-12 == 2 so we fail.

                let prefix_sum = difference_histogram.iter()
                                                     .scan(0, |sum, i| { *sum += i; Some(*sum) })
                                                     .collect::<Vec<_>>();

                // check each fuzzy statement for violations.
                assert_eq!(0, difference_histogram[0]);
                assert_eq!(0, prefix_sum[0]);

                // loop invariant: this is the max_difference of the previous iteration's 'fuzzy'
                let mut previous_max_diff = 0;

                // loop invariant: this is the number of pixels to ignore as they have been counted
                // against previous iterations' fuzzy statements.
                let mut previous_sum_fail = 0;  // ==  prefix_sum[previous_max_diff]

                let mut is_failing = false;
                let mut fail_text = String::new();

                for fuzzy in fuzziness {
                    let fuzzy_max_difference = cmp::min(255, fuzzy.max_difference);
                    let num_differences = prefix_sum[fuzzy_max_difference] - previous_sum_fail;
                    if num_differences > fuzzy.num_differences {
                        fail_text.push_str(
                            &format!("{} differences > {} and <= {} (allowed {}); ",
                                     num_differences,
                                     previous_max_diff, fuzzy_max_difference,
                                     fuzzy.num_differences));
                        is_failing = true;
                    }
                    previous_max_diff = fuzzy_max_difference;
                    previous_sum_fail = prefix_sum[previous_max_diff];
                }
                // do we have any pixels with a difference above the highest allowed
                // max difference? if so, we fail the test:
                let num_differences = prefix_sum[255] - previous_sum_fail;
                if num_differences > 0 {
                    fail_text.push_str(
                        &format!("{} num_differences > {} and <= {} (allowed {}); ",
                                num_differences,
                                previous_max_diff, 255,
                                0));
                    is_failing = true;
                }

                if is_failing {
                    println!(
                        "REFTEST TEST-UNEXPECTED-FAIL | {} | \
                         image comparison, max difference: {}, number of differing pixels: {} | {}",
                        test_name,
                        max_difference,
                        count_different,
                        fail_text,
                    );
                    println!("REFTEST   IMAGE 1 (TEST): {}", test.clone().create_data_uri());
                    println!(
                        "REFTEST   IMAGE 2 (REFERENCE): {}",
                        reference.clone().create_data_uri()
                    );
                    println!("REFTEST TEST-END | {}", test_name);

                    false
                } else {
                    true
                }
            }
        }
    }

    /// Report details of the negative case
    fn report_unexpected_equality(&self, test_name: &str) {
        println!("REFTEST TEST-UNEXPECTED-FAIL | {} | image comparison", test_name);
        println!("REFTEST TEST-END | {}", test_name);
    }
}

impl Display for Reftest {
    fn fmt(&self, f: &mut Formatter) -> Result<(), Error> {
        let paths: Vec<String> = self.test.iter().map(|t| t.display().to_string()).collect();
        write!(
            f,
            "{} {} {}",
            paths.join(", "),
            self.op,
            self.reference.display()
        )
    }
}

#[derive(Clone)]
pub struct ReftestImage {
    pub data: Vec<u8>,
    pub size: DeviceIntSize,
}

#[derive(Debug, Clone)]
pub enum ReftestImageComparison {
    Equal,
    NotEqual {
        /// entry[j] = number of pixels with a difference of exactly j
        difference_histogram: Vec<usize>,
        max_difference: usize,
        count_different: usize,
    },
}

impl ReftestImage {
    pub fn compare(&self, other: &ReftestImage) -> ReftestImageComparison {
        assert_eq!(self.size, other.size);
        assert_eq!(self.data.len(), other.data.len());
        assert_eq!(self.data.len() % 4, 0);

        let mut histogram = [0usize; 256];
        let mut count = 0;
        let mut max = 0;

        for (a, b) in self.data.chunks(4).zip(other.data.chunks(4)) {
            if a != b {
                let pixel_max = a.iter()
                    .zip(b.iter())
                    .map(|(x, y)| (*x as isize - *y as isize).abs() as usize)
                    .max()
                    .unwrap();

                count += 1;
                assert!(pixel_max < 256, "pixel values are not 8 bit, update the histogram binning code");
                // deliberately avoid counting pixels that match --
                // histogram[0] stays at zero.
                // this helps our prefix sum later during analysis to
                // only count actual differences.
                histogram[pixel_max as usize] += 1;
                max = cmp::max(max, pixel_max);
            }
        }

        if count != 0 {
            ReftestImageComparison::NotEqual {
                difference_histogram: histogram.to_vec(),
                max_difference: max,
                count_different: count,
            }
        } else {
            ReftestImageComparison::Equal
        }
    }

    pub fn create_data_uri(mut self) -> String {
        let width = self.size.width;
        let height = self.size.height;

        // flip image vertically (texture is upside down)
        let orig_pixels = self.data.clone();
        let stride = width as usize * 4;
        for y in 0 .. height as usize {
            let dst_start = y * stride;
            let src_start = (height as usize - y - 1) * stride;
            let src_slice = &orig_pixels[src_start .. src_start + stride];
            (&mut self.data[dst_start .. dst_start + stride])
                .clone_from_slice(&src_slice[.. stride]);
        }

        let mut png: Vec<u8> = vec![];
        {
            let encoder = PNGEncoder::new(&mut png);
            encoder
                .encode(&self.data[..], width as u32, height as u32, ColorType::Rgba8)
                .expect("Unable to encode PNG!");
        }
        let png_base64 = base64::engine::general_purpose::STANDARD.encode(&png);
        format!("data:image/png;base64,{}", png_base64)
    }
}

struct ReftestManifest {
    reftests: Vec<Reftest>,
}
impl ReftestManifest {
    fn new(manifest: &Path, environment: &ReftestEnvironment, options: &ReftestOptions) -> ReftestManifest {
        let dir = manifest.parent().unwrap();
        let f =
            File::open(manifest).unwrap_or_else(|_| panic!("couldn't open manifest: {}", manifest.display()));
        let file = BufReader::new(&f);

        let mut reftests = Vec::new();

        for line in file.lines() {
            let l = line.unwrap();

            let expect_usize = &|opt: Option<usize>, msg| {
                match opt {
                    Some(val) => val,
                    None => {
                        panic!("Parsing error in {}. {:?}: {:?}", msg, manifest, l)
                    }
                }
            };
            let expect_bool = &|opt: Option<bool>, msg| {
                match opt {
                    Some(val) => val,
                    None => {
                        panic!("Parsing error in {}. {:?}: {:?}", msg, manifest, l)
                    }
                }
            };

            // strip the comments
            let s = &l[0 .. l.find('#').unwrap_or(l.len())];
            let s = s.trim();
            if s.is_empty() {
                continue;
            }

            // Split on whitespace, but keep parenthesized/bracketed argument
            // lists together so options like `scale(1.0, 1.5, 2.0)` may contain
            // spaces between their arguments.
            let tokens: Vec<&str> = split_manifest_tokens(s);

            let mut fuzziness = Vec::new();
            let mut op = None;
            let mut font_render_mode = None;
            let mut extra_checks = vec![];
            let mut allow_mipmaps = false;
            let mut force_subpixel_aa_where_possible = None;
            let mut max_surface_override = None;
            let mut scales = Vec::new();
            // Fuzziness overrides gated on a specific device pixel scale, e.g.
            // `fuzzy-if(scale(0.5), 10, 20)`. Deferred to run time (the scale is
            // only known then) rather than evaluated as an environment condition.
            let mut scale_fuzziness_raw: Vec<(f32, RefTestFuzzy)> = Vec::new();

            // Returns Some(scale) if `cond` is a `scale(X)` condition.
            let scale_condition = |cond: &str| -> Option<f32> {
                if cond.starts_with("scale(") {
                    let (_, args, _) = parse_function(cond);
                    Some(args[0].parse().expect("invalid scale condition"))
                } else {
                    None
                }
            };

            let mut parse_command = |token: &str| -> bool {
                match token {
                    function if function.starts_with("force_subpixel_aa_where_possible(") => {
                        let (_, args, _) = parse_function(function);
                        force_subpixel_aa_where_possible = Some(args[0].parse().unwrap());
                    }
                    function if function.starts_with("fuzzy-range(") ||
                                function.starts_with("fuzzy-range-if(") => {
                        let (_, mut args, _) = parse_function(function);
                        let mut scale = None;
                        if function.starts_with("fuzzy-range-if(") {
                            let cond = args.remove(0);
                            match scale_condition(cond) {
                                Some(s) => scale = Some(s),
                                None => {
                                    if !expect_bool(environment.parse_condition(cond), "unknown condition") {
                                        return true;
                                    }
                                    fuzziness.clear();
                                }
                            }
                        }
                        let num_range = args.len() / 2;
                        for range in 0..num_range {
                            let mut max = args[range * 2    ];
                            let mut num = args[range * 2 + 1];
                            if max.starts_with("<=") { // trim_start_matches would allow <=<=123
                                max = &max[2..];
                            }
                            if num.starts_with('*') {
                                num = &num[1..];
                            }
                            let max_difference  = max.parse().unwrap();
                            let num_differences = num.parse().unwrap();
                            let fuzzy = RefTestFuzzy { max_difference, num_differences };
                            match scale {
                                Some(s) => scale_fuzziness_raw.push((s, fuzzy)),
                                None => fuzziness.push(fuzzy),
                            }
                        }
                    }
                    function if function.starts_with("fuzzy(") ||
                                function.starts_with("fuzzy-if(") => {
                        let (_, mut args, _) = parse_function(function);
                        let mut scale = None;
                        if function.starts_with("fuzzy-if(") {
                            let cond = args.remove(0);
                            match scale_condition(cond) {
                                Some(s) => scale = Some(s),
                                None => {
                                    if !expect_bool(environment.parse_condition(cond), "unknown condition") {
                                        return true;
                                    }
                                    fuzziness.clear();
                                }
                            }
                        }
                        let max_difference = expect_usize(args[0].parse().ok(), "max difference");
                        let num_differences = expect_usize(args[1].parse().ok(), "num differing pixels");
                        let fuzzy = RefTestFuzzy { max_difference, num_differences };
                        match scale {
                            Some(s) => scale_fuzziness_raw.push((s, fuzzy)),
                            None => {
                                assert!(fuzziness.is_empty()); // if this fires, consider fuzzy-range instead
                                fuzziness.push(fuzzy);
                            }
                        }
                    }
                    function if function.starts_with("draw_calls(") => {
                        let (_, args, _) = parse_function(function);
                        extra_checks.push(ExtraCheck::DrawCalls(args[0].parse().unwrap()));
                    }
                    function if function.starts_with("alpha_targets(") => {
                        let (_, args, _) = parse_function(function);
                        extra_checks.push(ExtraCheck::AlphaTargets(args[0].parse().unwrap()));
                    }
                    function if function.starts_with("color_targets(") => {
                        let (_, args, _) = parse_function(function);
                        extra_checks.push(ExtraCheck::ColorTargets(args[0].parse().unwrap()));
                    }
                    function if function.starts_with("max_surface_size(") => {
                        let (_, args, _) = parse_function(function);
                        max_surface_override = Some(args[0].parse().unwrap());
                    }
                    function if function.starts_with("scale(") => {
                        let (_, args, _) = parse_function(function);
                        // `scale(*)` is shorthand for a standard set of scales,
                        // including fractional ones that stress snapping.
                        if args == ["*"] {
                            scales = vec![1.0, 2.0, 1.51, 0.51];
                        } else {
                            scales = args.iter().map(|arg| arg.parse().unwrap()).collect();
                        }
                    }
                    options if options.starts_with("options(") => {
                        let (_, args, _) = parse_function(options);
                        if args.iter().any(|arg| arg == &OPTION_DISABLE_SUBPX) {
                            font_render_mode = Some(FontRenderMode::Alpha);
                        }
                        if args.iter().any(|arg| arg == &OPTION_DISABLE_AA) {
                            font_render_mode = Some(FontRenderMode::Mono);
                        }
                        if args.iter().any(|arg| arg == &OPTION_ALLOW_MIPMAPS) {
                            allow_mipmaps = true;
                        }
                    }
                    _ => return false,
                }
                true
            };

            let mut paths = vec![];
            for (i, token) in tokens.iter().enumerate() {
                match *token {
                    "include" => {
                        assert!(i == 0, "include must be by itself");
                        let include = dir.join(tokens[1]);

                        reftests.append(
                            &mut ReftestManifest::new(include.as_path(), environment, options).reftests,
                        );

                        break;
                    }
                    "==" => {
                        op = Some(ReftestOp::Equal);
                    }
                    "!=" => {
                        op = Some(ReftestOp::NotEqual);
                    }
                    "**" => {
                        op = Some(ReftestOp::Accurate);
                    }
                    "!*" => {
                        op = Some(ReftestOp::Inaccurate);
                    }
                    cond if cond.starts_with("if(") => {
                        let (_, args, _) = parse_function(cond);
                        if expect_bool(environment.parse_condition(args[0]), "unknown condition") {
                            for command in &args[1..] {
                                parse_command(command);
                            }
                        }
                    }
                    command if parse_command(command) => {}
                    _ => {
                        match environment.parse_condition(*token) {
                            Some(true) => {}
                            Some(false) => break,
                            _ => paths.push(dir.join(*token)),
                        }
                    }
                }
            }

            // Don't try to add tests for include lines.
            if op.is_none() {
                assert!(paths.is_empty(), "paths = {:?}", paths);
                continue;
            }
            let op = op.unwrap();

            // The reference is the last path provided. If multiple paths are
            // passed for the test, they render sequentially before being
            // compared to the reference, which is useful for testing
            // invalidation.
            let reference = paths.pop().unwrap();
            let test = paths;

            // Finalize a raw fuzziness list: add the small default fuzz used on
            // non-linux/swgl platforms, merge with the harness-wide allowances,
            // and sort so the comparison can count violations cheaply.
            let finalize_fuzziness = |mut fuzziness: Vec<RefTestFuzzy>| -> Vec<RefTestFuzzy> {
                if environment.platform != "linux" || environment.platform == "swgl" {
                    // Add some fuzz on every platform except linux.
                    // First remove the ranges with difference <= 5, otherwise they might cause the
                    // test to fail before the new range is picked up.
                    fuzziness.retain(|fuzzy| fuzzy.max_difference > 5);
                    fuzziness.push(RefTestFuzzy { max_difference: 5, num_differences: std::usize::MAX });
                }

                // to avoid changing the meaning of existing tests, the case of
                // only a single (or no) 'fuzzy' keyword means we use the max
                // of that fuzzy and options.allow_.. (we don't want that to
                // turn into a test that allows fuzzy.allow_ *plus* options.allow_):
                match fuzziness.len() {
                    0 => fuzziness.push(RefTestFuzzy {
                            max_difference: options.allow_max_difference,
                            num_differences: options.allow_num_differences }),
                    1 => {
                        let fuzzy = &mut fuzziness[0];
                        fuzzy.max_difference = cmp::max(fuzzy.max_difference, options.allow_max_difference);
                        fuzzy.num_differences = cmp::max(fuzzy.num_differences, options.allow_num_differences);
                    },
                    _ => {
                        // ignore options, use multiple fuzzy keywords instead. make sure
                        // the list is sorted to speed up counting violations.
                        fuzziness.sort_by(|a, b| a.max_difference.cmp(&b.max_difference));
                        for pair in fuzziness.windows(2) {
                            if pair[0].max_difference == pair[1].max_difference {
                                println!("Warning: repeated fuzzy of max_difference {} ignored.",
                                         pair[1].max_difference);
                            }
                        }
                    }
                }
                fuzziness
            };

            if scales.is_empty() {
                scales.push(1.0);
            }

            // The default fuzziness, used at any scale without an override.
            let default_fuzziness = finalize_fuzziness(fuzziness.clone());

            // For each scale that has a `fuzzy-if(scale(X), ...)` override,
            // combine the base fuzziness with that scale's extra entries and
            // finalize the result for that scale.
            let mut scale_fuzziness = Vec::new();
            for &scale in &scales {
                let extra: Vec<RefTestFuzzy> = scale_fuzziness_raw
                    .iter()
                    .filter(|(s, _)| *s == scale)
                    .map(|(_, fuzzy)| *fuzzy)
                    .collect();
                if !extra.is_empty() {
                    let mut combined = fuzziness.clone();
                    combined.extend(extra);
                    scale_fuzziness.push((scale, finalize_fuzziness(combined)));
                }
            }

            reftests.push(Reftest {
                op,
                test,
                reference,
                font_render_mode,
                fuzziness: default_fuzziness,
                scale_fuzziness,
                extra_checks,
                allow_mipmaps,
                force_subpixel_aa_where_possible,
                max_surface_override,
                scales,
            });
        }

        ReftestManifest { reftests }
    }

    fn find(&self, prefix: &Path) -> Vec<&Reftest> {
        self.reftests
            .iter()
            .filter(|x| {
                x.test.iter().any(|t| t.starts_with(prefix)) || x.reference.starts_with(prefix)
            })
            .collect()
    }
}

struct YamlRenderOutput {
    image: ReftestImage,
    results: RenderResults,
}

struct ReftestEnvironment {
    pub platform: &'static str,
    pub version: Option<semver::Version>,
    pub mode: &'static str,
}

impl ReftestEnvironment {
    fn new(wrench: &Wrench, window: &WindowWrapper) -> Self {
        Self {
            platform: Self::platform(wrench, window),
            version: Self::version(wrench, window),
            mode: Self::mode(),
        }
    }

    fn has(&self, condition: &str) -> bool {
        if self.platform == condition || self.mode == condition {
            return true;
        }
        if let (Some(v), Ok(r)) = (&self.version, &semver::VersionReq::parse(condition)) {
            if r.matches(v) {
                return true;
            }
        }
        let envkey = format!("WRENCH_REFTEST_CONDITION_{}", condition.to_uppercase());
        env::var(envkey).is_ok()
    }

    fn platform(_wrench: &Wrench, window: &WindowWrapper) -> &'static str {
        if window.is_software() {
            "swgl"
        } else if cfg!(target_os = "windows") {
            "win"
        } else if cfg!(target_os = "linux") {
            "linux"
        } else if cfg!(target_os = "macos") {
            "mac"
        } else if cfg!(target_os = "android") {
            "android"
        } else {
            "other"
        }
    }

    fn version(_wrench: &Wrench, window: &WindowWrapper) -> Option<semver::Version> {
        if window.is_software() {
            None
        } else if cfg!(target_os = "macos") {
            use std::str;
            let version_bytes = Command::new("defaults")
                .arg("read")
                .arg("loginwindow")
                .arg("SystemVersionStampAsString")
                .output()
                .expect("Failed to get macOS version")
                .stdout;
            let mut version_string = str::from_utf8(&version_bytes)
                .expect("Failed to read macOS version")
                .trim()
                .to_string();
            // On some machines this produces just the major.minor and on
            // some machines this gives major.minor.patch. But semver requires
            // the patch so we fake one if it's not there.
            if version_string.chars().filter(|c| *c == '.').count() == 1 {
                version_string.push_str(".0");
            }
            Some(semver::Version::parse(&version_string)
                 .unwrap_or_else(|_| panic!("Failed to parse macOS version {}", version_string)))
        } else {
            None
        }
    }

    fn mode() -> &'static str {
        if cfg!(debug_assertions) {
            "debug"
        } else {
            "release"
        }
    }

    fn parse_condition(&self, token: &str) -> Option<bool> {
        match token {
            platform if platform.starts_with("skip_on(") => {
                // e.g. skip_on(android,debug) will skip only when
                // running on a debug android build.
                let (_, args, _) = parse_function(platform);
                Some(!args.iter().all(|arg| self.has(arg)))
            }
            platform if platform.starts_with("env(") => {
                // non-negated version of skip_on for nested conditions
                let (_, args, _) = parse_function(platform);
                Some(args.iter().all(|arg| self.has(arg)))
            }
            platform if platform.starts_with("platform(") => {
                let (_, args, _) = parse_function(platform);
                // Skip due to platform not matching
                Some(args.iter().any(|arg| arg == &self.platform))
            }
            op if op.starts_with("not(") => {
                let (_, args, _) = parse_function(op);
                Some(!self.parse_condition(args[0])?)
            }
            op if op.starts_with("or(") => {
                let (_, args, _) = parse_function(op);
                if args.is_empty() {
                    return None;
                }
                let mut any = false;
                for arg in args.iter() {
                    any = any | self.parse_condition(arg)?
                }
                Some(any)
            }
            op if op.starts_with("and(") => {
                let (_, args, _) = parse_function(op);
                if args.is_empty() {
                    return None;
                }
                let mut all = true;
                for arg in args.iter() {
                    all = all & self.parse_condition(arg)?
                }
                Some(all)
            }
            _ => None,
        }
    }
}

pub struct ReftestHarness<'a> {
    wrench: &'a mut Wrench,
    window: &'a mut WindowWrapper,
    rx: &'a Receiver<NotifierEvent>,
    environment: ReftestEnvironment,
}
impl<'a> ReftestHarness<'a> {
    pub fn new(wrench: &'a mut Wrench, window: &'a mut WindowWrapper, rx: &'a Receiver<NotifierEvent>) -> Self {
        let environment = ReftestEnvironment::new(wrench, window);
        ReftestHarness { wrench, window, rx, environment }
    }

    pub fn run(mut self, base_manifest: &Path, reftests: Option<&Path>, options: &ReftestOptions) -> usize {
        let manifest = ReftestManifest::new(base_manifest, &self.environment, options);
        let reftests = manifest.find(reftests.unwrap_or(&PathBuf::new()));

        let mut total_passing = 0;
        let mut failing = Vec::new();

        for t in reftests {
            if self.run_reftest(t) {
                total_passing += 1;
            } else {
                failing.push(t);
            }
        }

        println!(
            "REFTEST INFO | {} passing, {} failing",
            total_passing,
            failing.len()
        );

        if !failing.is_empty() {
            println!("\nReftests with unexpected results:");

            for reftest in &failing {
                println!("\t{}", reftest);
            }
        }

        failing.len()
    }

    fn run_reftest(&mut self, t: &Reftest) -> bool {
        // Run the test once per requested device pixel scale (defaults to a
        // single 1.0 entry). The test only passes if it passes at every scale.
        let mut all_passed = true;
        for scale in &t.scales {
            all_passed &= self.run_reftest_with_scale(t, *scale);
        }
        all_passed
    }

    fn run_reftest_with_scale(&mut self, t: &Reftest, device_pixel_scale: f32) -> bool {
        // Only yaml paths are rendered at the requested scale; png references
        // are fixed images, so don't tag them with a scale.
        let with_scale = |path: &Path| {
            if path.extension().and_then(|e| e.to_str()) == Some("yaml") && device_pixel_scale != 1.0 {
                format!("{}(scale: {})", path.display(), device_pixel_scale)
            } else {
                path.display().to_string()
            }
        };
        let test_paths: Vec<String> = t.test.iter().map(|p| with_scale(p)).collect();
        let reference_path = scaled_reference_path(&t.reference, device_pixel_scale);
        let test_name = format!("{} {} {}", test_paths.join(", "), t.op, with_scale(&reference_path));
        println!("REFTEST {}", test_name);
        profile_scope!("wrench reftest", text: &test_name);

        self.wrench
            .api
            .send_debug_cmd(
                DebugCommand::ClearCaches(ClearCache::all())
            );

        let quality_settings = QualitySettings {
            force_subpixel_aa_where_possible: t.force_subpixel_aa_where_possible.unwrap_or_default(),
        };

        self.wrench.set_quality_settings(quality_settings);

        if let Some(max_surface_override) = t.max_surface_override {
            self.wrench
                .api
                .send_debug_cmd(
                    DebugCommand::SetMaximumSurfaceSize(Some(max_surface_override))
                );
        }

        let window_size = self.window.get_inner_size();
        // A png reference may provide a scale-specific variant on disk (e.g.
        // `foo-scale:0.5.png`), otherwise the base `foo.png` is used.
        let reference_image = match reference_path.extension().unwrap().to_str().unwrap() {
            "yaml" => None,
            "png" => Some(self.load_image(reference_path.as_path(), ImageFormat::Png)),
            other => panic!("Unknown reftest extension: {}", other),
        };
        let test_size = reference_image.as_ref().map_or(window_size, |img| img.size);

        // The reference can be smaller than the window size, in which case
        // we only compare the intersection.
        //
        // Note also that, when we have multiple test scenes in sequence, we
        // want to test the picture caching machinery. But since picture caching
        // only takes effect after the result has been the same several frames in
        // a row, we need to render the scene multiple times.
        let mut images = vec![];
        let mut results = vec![];

        match t.op {
            ReftestOp::Equal | ReftestOp::NotEqual => {
                // For equality tests, render each test image and store result
                for filename in t.test.iter() {
                    let output = self.render_yaml(
                        filename,
                        test_size,
                        t.font_render_mode,
                        t.allow_mipmaps,
                        device_pixel_scale,
                    );
                    images.push(output.image);
                    results.push(output.results);
                }
            }
            ReftestOp::Accurate | ReftestOp::Inaccurate => {
                // For accuracy tests, render the reference yaml at an arbitrary series
                // of tile sizes, and compare to the reference drawn at normal tile size.
                let tile_sizes = [
                    DeviceIntSize::new(128, 128),
                    DeviceIntSize::new(256, 256),
                    DeviceIntSize::new(512, 512),
                ];

                for tile_size in &tile_sizes {
                    self.wrench
                        .api
                        .send_debug_cmd(
                            DebugCommand::SetPictureTileSize(Some(*tile_size))
                        );

                    let output = self.render_yaml(
                        &t.reference,
                        test_size,
                        t.font_render_mode,
                        t.allow_mipmaps,
                        device_pixel_scale,
                    );
                    images.push(output.image);
                    results.push(output.results);
                }

                self.wrench
                    .api
                    .send_debug_cmd(
                        DebugCommand::SetPictureTileSize(None)
                    );
            }
        }

        let reference = if let Some(image) = reference_image {
            let save_all_png = false; // flip to true to update all the tests!
            if save_all_png {
                let img = images.last().unwrap();
                save_flipped(&reference_path, img.data.clone(), img.size);
            }
            image
        } else {
            let output = self.render_yaml(
                &t.reference,
                test_size,
                t.font_render_mode,
                t.allow_mipmaps,
                device_pixel_scale,
            );
            output.image
        };

        if let Some(_) = t.max_surface_override {
            self.wrench
                .api
                .send_debug_cmd(
                    DebugCommand::SetMaximumSurfaceSize(None)
                );
        }

        for extra_check in t.extra_checks.iter() {
            if !extra_check.run(&results) {
                println!(
                    "REFTEST TEST-UNEXPECTED-FAIL | {} | Failing Check: {:?} | Actual Results: {:?}",
                    t,
                    extra_check,
                    results,
                );
                println!("REFTEST TEST-END | {}", t);
                return false;
            }
        }

        match t.op {
            ReftestOp::Equal => {
                // Ensure that the final image matches the reference
                let test = images.pop().unwrap();
                let comparison = test.compare(&reference);
                t.check_and_report_equality_failure(
                    comparison,
                    &test,
                    &reference,
                    t.fuzziness_for_scale(device_pixel_scale),
                    &test_name,
                )
            }
            ReftestOp::NotEqual => {
                // Ensure that the final image *doesn't* match the reference
                let test = images.pop().unwrap();
                let comparison = test.compare(&reference);
                match comparison {
                    ReftestImageComparison::Equal => {
                        t.report_unexpected_equality(&test_name);
                        false
                    }
                    ReftestImageComparison::NotEqual { .. } => {
                        true
                    }
                }
            }
            ReftestOp::Accurate => {
                // Ensure that *all* images match the reference
                for test in images.drain(..) {
                    let comparison = test.compare(&reference);

                    if !t.check_and_report_equality_failure(
                        comparison,
                        &test,
                        &reference,
                        t.fuzziness_for_scale(device_pixel_scale),
                        &test_name,
                    ) {
                        return false;
                    }
                }

                true
            }
            ReftestOp::Inaccurate => {
                // Ensure that at least one of the images doesn't match the reference
                let all_same = images.iter().all(|image| {
                    match image.compare(&reference) {
                        ReftestImageComparison::Equal => true,
                        ReftestImageComparison::NotEqual { .. } => false,
                    }
                });

                if all_same {
                    t.report_unexpected_equality(&test_name);
                }

                !all_same
            }
        }
    }

    fn load_image(&mut self, filename: &Path, format: ImageFormat) -> ReftestImage {
        let file = BufReader::new(File::open(filename).unwrap());
        let img_raw = load_piston_image(file, format).unwrap();
        let img = img_raw.flipv().to_rgba();
        let size = img.dimensions();
        ReftestImage {
            data: img.into_raw(),
            size: DeviceIntSize::new(size.0 as i32, size.1 as i32),
        }
    }

    fn render_yaml(
        &mut self,
        filename: &Path,
        size: DeviceIntSize,
        font_render_mode: Option<FontRenderMode>,
        allow_mipmaps: bool,
        device_pixel_scale: f32,
    ) -> YamlRenderOutput {
        let mut reader = YamlFrameReader::new(filename);
        reader.set_font_render_mode(font_render_mode);
        reader.allow_mipmaps(allow_mipmaps);
        reader.set_device_pixel_scale(device_pixel_scale);
        reader.do_frame(self.wrench);

        self.wrench.api.flush_scene_builder();

        // wait for the frame
        self.rx.recv().unwrap();
        let results = self.wrench.render();

        let window_size = self.window.get_inner_size();
        assert!(
            size.width <= window_size.width &&
            size.height <= window_size.height,
            "size={:?} ws={:?}", size, window_size
        );

        // taking the bottom left sub-rectangle
        let rect = FramebufferIntRect::from_origin_and_size(
            FramebufferIntPoint::new(0, window_size.height - size.height),
            FramebufferIntSize::new(size.width, size.height),
        );
        let pixels = self.wrench.renderer.read_pixels_rgba8(rect);
        self.window.swap_buffers();

        let write_debug_images = false;
        if write_debug_images {
            let debug_path = filename.with_extension("yaml.png");
            save_flipped(debug_path, pixels.clone(), size);
        }

        reader.deinit(self.wrench);

        YamlRenderOutput {
            image: ReftestImage { data: pixels, size },
            results,
        }
    }
}
