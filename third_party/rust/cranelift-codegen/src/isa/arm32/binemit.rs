//! Emitting binary ARM32 machine code.

use crate::binemit::{bad_encoding, CodeSink};
use crate::ir::{Function, Inst};
use crate::isa::TargetIsa;
use crate::regalloc::RegDiversions;

include!(concat!(env!("OUT_DIR"), "/binemit-arm32.rs"));
