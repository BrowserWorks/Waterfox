use crate::bitset::BitSet;
use crate::ir;
use crate::isa::TargetIsa;
use alloc::vec::Vec;

type Num = u32;
const NUM_BITS: usize = core::mem::size_of::<Num>() * 8;

/// A stack map is a bitmap with one bit per machine word on the stack. Stack
/// maps are created at `safepoint` instructions and record all live reference
/// values that are on the stack. All slot kinds, except `OutgoingArg` are
/// captured in a stack map. The `OutgoingArg`'s will be captured in the callee
/// function as `IncomingArg`'s.
///
/// The first value in the bitmap is of the lowest addressed slot on the stack.
/// As all stacks in Isa's supported by Cranelift grow down, this means that
/// first value is of the top of the stack and values proceed down the stack.
#[derive(Clone, Debug)]
pub struct Stackmap {
    bitmap: Vec<BitSet<Num>>,
    mapped_words: u32,
}

impl Stackmap {
    /// Create a stackmap based on where references are located on a function's stack.
    pub fn from_values(
        args: &[ir::entities::Value],
        func: &ir::Function,
        isa: &dyn TargetIsa,
    ) -> Self {
        let loc = &func.locations;
        let mut live_ref_in_stack_slot = crate::HashSet::new();
        // References can be in registers, and live registers values are pushed onto the stack before calls and traps.
        // TODO: Implement register maps. If a register containing a reference is spilled and reused after a safepoint,
        // it could contain a stale reference value if the garbage collector relocated the value.
        for val in args {
            if let Some(value_loc) = loc.get(*val) {
                match *value_loc {
                    ir::ValueLoc::Stack(stack_slot) => {
                        live_ref_in_stack_slot.insert(stack_slot);
                    }
                    _ => {}
                }
            }
        }

        let stack = &func.stack_slots;
        let info = func.stack_slots.layout_info.unwrap();

        // Refer to the doc comment for `Stackmap` above to understand the
        // bitmap representation used here.
        let map_size = (info.frame_size + info.inbound_args_size) as usize;
        let word_size = isa.pointer_bytes() as usize;
        let num_words = map_size / word_size;

        let mut vec = alloc::vec::Vec::with_capacity(num_words);
        vec.resize(num_words, false);

        for (ss, ssd) in stack.iter() {
            if !live_ref_in_stack_slot.contains(&ss)
                || ssd.kind == ir::stackslot::StackSlotKind::OutgoingArg
            {
                continue;
            }

            debug_assert!(ssd.size as usize == word_size);
            let bytes_from_bottom = info.frame_size as i32 + ssd.offset.unwrap();
            let words_from_bottom = (bytes_from_bottom as usize) / word_size;
            vec[words_from_bottom] = true;
        }

        Self::from_slice(&vec)
    }

    /// Create a vec of Bitsets from a slice of bools.
    pub fn from_slice(vec: &[bool]) -> Self {
        let len = vec.len();
        let num_word = len / NUM_BITS + (len % NUM_BITS != 0) as usize;
        let mut bitmap = Vec::with_capacity(num_word);

        for segment in vec.chunks(NUM_BITS) {
            let mut curr_word = 0;
            for (i, set) in segment.iter().enumerate() {
                if *set {
                    curr_word |= 1 << i;
                }
            }
            bitmap.push(BitSet(curr_word));
        }
        Self {
            mapped_words: len as u32,
            bitmap,
        }
    }

    /// Returns a specified bit.
    pub fn get_bit(&self, bit_index: usize) -> bool {
        assert!(bit_index < NUM_BITS * self.bitmap.len());
        let word_index = bit_index / NUM_BITS;
        let word_offset = (bit_index % NUM_BITS) as u8;
        self.bitmap[word_index].contains(word_offset)
    }

    /// Returns the raw bitmap that represents this stack map.
    pub fn as_slice(&self) -> &[BitSet<u32>] {
        &self.bitmap
    }

    /// Returns the number of words represented by this stack map.
    pub fn mapped_words(&self) -> u32 {
        self.mapped_words
    }
}

#[cfg(test)]
mod tests {
    use super::*;

    #[test]
    fn stackmaps() {
        let vec: Vec<bool> = Vec::new();
        assert!(Stackmap::from_slice(&vec).bitmap.is_empty());

        let mut vec: [bool; NUM_BITS] = Default::default();
        let set_true_idx = [5, 7, 24, 31];

        for &idx in &set_true_idx {
            vec[idx] = true;
        }

        let mut vec = vec.to_vec();
        assert_eq!(
            vec![BitSet::<Num>(2164261024)],
            Stackmap::from_slice(&vec).bitmap
        );

        vec.push(false);
        vec.push(true);
        let res = Stackmap::from_slice(&vec);
        assert_eq!(
            vec![BitSet::<Num>(2164261024), BitSet::<Num>(2)],
            res.bitmap
        );

        assert!(res.get_bit(5));
        assert!(res.get_bit(31));
        assert!(res.get_bit(33));
        assert!(!res.get_bit(1));
    }
}
