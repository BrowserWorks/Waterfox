/* Generated automatically by the program 'build/genpreds'
   from the machine description file '../../gcc-4.7.3/gcc/config/i386/i386.md'.  */

#ifndef GCC_TM_PREDS_H
#define GCC_TM_PREDS_H

#ifdef HAVE_MACHINE_MODES
extern int general_operand (rtx, enum machine_mode);
extern int address_operand (rtx, enum machine_mode);
extern int register_operand (rtx, enum machine_mode);
extern int pmode_register_operand (rtx, enum machine_mode);
extern int scratch_operand (rtx, enum machine_mode);
extern int immediate_operand (rtx, enum machine_mode);
extern int const_int_operand (rtx, enum machine_mode);
extern int const_double_operand (rtx, enum machine_mode);
extern int nonimmediate_operand (rtx, enum machine_mode);
extern int nonmemory_operand (rtx, enum machine_mode);
extern int push_operand (rtx, enum machine_mode);
extern int pop_operand (rtx, enum machine_mode);
extern int memory_operand (rtx, enum machine_mode);
extern int indirect_operand (rtx, enum machine_mode);
extern int ordered_comparison_operator (rtx, enum machine_mode);
extern int comparison_operator (rtx, enum machine_mode);
extern int any_fp_register_operand (rtx, enum machine_mode);
extern int fp_register_operand (rtx, enum machine_mode);
extern int register_and_not_any_fp_reg_operand (rtx, enum machine_mode);
extern int register_and_not_fp_reg_operand (rtx, enum machine_mode);
extern int mmx_reg_operand (rtx, enum machine_mode);
extern int sse_reg_operand (rtx, enum machine_mode);
extern int q_regs_operand (rtx, enum machine_mode);
extern int ext_register_operand (rtx, enum machine_mode);
extern int ax_reg_operand (rtx, enum machine_mode);
extern int flags_reg_operand (rtx, enum machine_mode);
extern int QIreg_operand (rtx, enum machine_mode);
extern int ext_QIreg_operand (rtx, enum machine_mode);
extern int reg_not_xmm0_operand (rtx, enum machine_mode);
extern int nonimm_not_xmm0_operand (rtx, enum machine_mode);
extern int reg_not_xmm0_operand_maybe_avx (rtx, enum machine_mode);
extern int nonimm_not_xmm0_operand_maybe_avx (rtx, enum machine_mode);
extern int x86_64_immediate_operand (rtx, enum machine_mode);
extern int x86_64_zext_immediate_operand (rtx, enum machine_mode);
extern int x86_64_general_operand (rtx, enum machine_mode);
extern int x86_64_szext_general_operand (rtx, enum machine_mode);
extern int x86_64_nonmemory_operand (rtx, enum machine_mode);
extern int x86_64_szext_nonmemory_operand (rtx, enum machine_mode);
extern int pic_32bit_operand (rtx, enum machine_mode);
extern int x86_64_movabs_operand (rtx, enum machine_mode);
extern int symbolic_operand (rtx, enum machine_mode);
extern int local_symbolic_operand (rtx, enum machine_mode);
extern int gotoff_operand (rtx, enum machine_mode);
extern int tls_symbolic_operand (rtx, enum machine_mode);
extern int tls_modbase_operand (rtx, enum machine_mode);
extern int constant_call_address_operand (rtx, enum machine_mode);
extern int call_register_no_elim_operand (rtx, enum machine_mode);
extern int register_no_elim_operand (rtx, enum machine_mode);
extern int index_register_operand (rtx, enum machine_mode);
extern int general_no_elim_operand (rtx, enum machine_mode);
extern int nonmemory_no_elim_operand (rtx, enum machine_mode);
extern int indirect_branch_operand (rtx, enum machine_mode);
extern int call_insn_operand (rtx, enum machine_mode);
extern int sibcall_insn_operand (rtx, enum machine_mode);
extern int const0_operand (rtx, enum machine_mode);
extern int const1_operand (rtx, enum machine_mode);
extern int const8_operand (rtx, enum machine_mode);
extern int const128_operand (rtx, enum machine_mode);
extern int const_32bit_mask (rtx, enum machine_mode);
extern int const248_operand (rtx, enum machine_mode);
extern int const1248_operand (rtx, enum machine_mode);
extern int const359_operand (rtx, enum machine_mode);
extern int const_0_to_1_operand (rtx, enum machine_mode);
extern int const_0_to_3_operand (rtx, enum machine_mode);
extern int const_0_to_7_operand (rtx, enum machine_mode);
extern int const_0_to_15_operand (rtx, enum machine_mode);
extern int const_0_to_31_operand (rtx, enum machine_mode);
extern int const_0_to_63_operand (rtx, enum machine_mode);
extern int const_0_to_255_operand (rtx, enum machine_mode);
extern int const_0_to_255_mul_8_operand (rtx, enum machine_mode);
extern int const_1_to_31_operand (rtx, enum machine_mode);
extern int const_1_to_63_operand (rtx, enum machine_mode);
extern int const_2_to_3_operand (rtx, enum machine_mode);
extern int const_4_to_5_operand (rtx, enum machine_mode);
extern int const_4_to_7_operand (rtx, enum machine_mode);
extern int const_6_to_7_operand (rtx, enum machine_mode);
extern int const_8_to_11_operand (rtx, enum machine_mode);
extern int const_12_to_15_operand (rtx, enum machine_mode);
extern int incdec_operand (rtx, enum machine_mode);
extern int reg_or_pm1_operand (rtx, enum machine_mode);
extern int shiftdi_operand (rtx, enum machine_mode);
extern int ashldi_input_operand (rtx, enum machine_mode);
extern int zero_extended_scalar_load_operand (rtx, enum machine_mode);
extern int vector_all_ones_operand (rtx, enum machine_mode);
extern int vector_move_operand (rtx, enum machine_mode);
extern int nonimmediate_or_sse_const_operand (rtx, enum machine_mode);
extern int reg_or_0_operand (rtx, enum machine_mode);
extern int lea_address_operand (rtx, enum machine_mode);
extern int SImode_address_operand (rtx, enum machine_mode);
extern int vsib_address_operand (rtx, enum machine_mode);
extern int vsib_mem_operator (rtx, enum machine_mode);
extern int aligned_operand (rtx, enum machine_mode);
extern int memory_displacement_operand (rtx, enum machine_mode);
extern int memory_displacement_only_operand (rtx, enum machine_mode);
extern int cmpxchg8b_pic_memory_operand (rtx, enum machine_mode);
extern int long_memory_operand (rtx, enum machine_mode);
extern int fcmov_comparison_operator (rtx, enum machine_mode);
extern int sse_comparison_operator (rtx, enum machine_mode);
extern int ix86_comparison_int_operator (rtx, enum machine_mode);
extern int ix86_comparison_uns_operator (rtx, enum machine_mode);
extern int bt_comparison_operator (rtx, enum machine_mode);
extern int ix86_comparison_operator (rtx, enum machine_mode);
extern int ix86_carry_flag_operator (rtx, enum machine_mode);
extern int ix86_trivial_fp_comparison_operator (rtx, enum machine_mode);
extern int ix86_fp_comparison_operator (rtx, enum machine_mode);
extern int ix86_swapped_fp_comparison_operator (rtx, enum machine_mode);
extern int cmp_fp_expander_operand (rtx, enum machine_mode);
extern int binary_fp_operator (rtx, enum machine_mode);
extern int mult_operator (rtx, enum machine_mode);
extern int div_operator (rtx, enum machine_mode);
extern int plusminuslogic_operator (rtx, enum machine_mode);
extern int float_operator (rtx, enum machine_mode);
extern int arith_or_logical_operator (rtx, enum machine_mode);
extern int commutative_operator (rtx, enum machine_mode);
extern int promotable_binary_operator (rtx, enum machine_mode);
extern int compare_operator (rtx, enum machine_mode);
extern int absneg_operator (rtx, enum machine_mode);
extern int misaligned_operand (rtx, enum machine_mode);
extern int emms_operation (rtx, enum machine_mode);
extern int vzeroall_operation (rtx, enum machine_mode);
extern int avx_vbroadcast_operand (rtx, enum machine_mode);
extern int avx2_pblendw_operand (rtx, enum machine_mode);
#endif /* HAVE_MACHINE_MODES */

#define CONSTRAINT_NUM_DEFINED_P 1
enum constraint_num
{
  CONSTRAINT__UNKNOWN = 0,
  CONSTRAINT_R,
  CONSTRAINT_q,
  CONSTRAINT_Q,
  CONSTRAINT_l,
  CONSTRAINT_a,
  CONSTRAINT_b,
  CONSTRAINT_c,
  CONSTRAINT_d,
  CONSTRAINT_S,
  CONSTRAINT_D,
  CONSTRAINT_A,
  CONSTRAINT_U,
  CONSTRAINT_f,
  CONSTRAINT_t,
  CONSTRAINT_u,
  CONSTRAINT_y,
  CONSTRAINT_x,
  CONSTRAINT_Yz,
  CONSTRAINT_Yi,
  CONSTRAINT_Ym,
  CONSTRAINT_Yp,
  CONSTRAINT_Yd,
  CONSTRAINT_Yx,
  CONSTRAINT_Yf,
  CONSTRAINT_z,
  CONSTRAINT_w,
  CONSTRAINT_I,
  CONSTRAINT_J,
  CONSTRAINT_K,
  CONSTRAINT_L,
  CONSTRAINT_M,
  CONSTRAINT_N,
  CONSTRAINT_O,
  CONSTRAINT_G,
  CONSTRAINT_C,
  CONSTRAINT_e,
  CONSTRAINT_Z,
  CONSTRAINT__LIMIT
};

extern enum constraint_num lookup_constraint (const char *);
extern bool constraint_satisfied_p (rtx, enum constraint_num);

static inline size_t
insn_constraint_len (char fc, const char *str ATTRIBUTE_UNUSED)
{
  switch (fc)
    {
    case 'Y': return 2;
    default: break;
    }
  return 1;
}

#define CONSTRAINT_LEN(c_,s_) insn_constraint_len (c_,s_)

extern enum reg_class regclass_for_constraint (enum constraint_num);
#define REG_CLASS_FROM_CONSTRAINT(c_,s_) \
    regclass_for_constraint (lookup_constraint (s_))
#define REG_CLASS_FOR_CONSTRAINT(x_) \
    regclass_for_constraint (x_)

extern bool insn_const_int_ok_for_constraint (HOST_WIDE_INT, enum constraint_num);
#define CONST_OK_FOR_CONSTRAINT_P(v_,c_,s_) \
    insn_const_int_ok_for_constraint (v_, lookup_constraint (s_))

#define CONST_DOUBLE_OK_FOR_CONSTRAINT_P(v_,c_,s_) \
    constraint_satisfied_p (v_, lookup_constraint (s_))

#define EXTRA_CONSTRAINT_STR(v_,c_,s_) \
    constraint_satisfied_p (v_, lookup_constraint (s_))

#define EXTRA_MEMORY_CONSTRAINT(c_,s_) false

#define EXTRA_ADDRESS_CONSTRAINT(c_,s_) false

#endif /* tm-preds.h */
