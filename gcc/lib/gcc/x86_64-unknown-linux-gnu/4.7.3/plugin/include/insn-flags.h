/* Generated automatically by the program `genflags'
   from the machine description file `md'.  */

#ifndef GCC_INSN_FLAGS_H
#define GCC_INSN_FLAGS_H

#define HAVE_x86_fnstsw_1 (TARGET_80387)
#define HAVE_x86_sahf_1 (TARGET_SAHF)
#define HAVE_swapxf (TARGET_80387)
#define HAVE_zero_extendsidi2_1 (!TARGET_64BIT)
#define HAVE_zero_extendqidi2 (TARGET_64BIT)
#define HAVE_zero_extendhidi2 (TARGET_64BIT)
#define HAVE_zero_extendhisi2_and (TARGET_ZERO_EXTEND_WITH_AND && optimize_function_for_speed_p (cfun))
#define HAVE_extendsidi2_1 (!TARGET_64BIT)
#define HAVE_extendqidi2 (TARGET_64BIT)
#define HAVE_extendhidi2 (TARGET_64BIT)
#define HAVE_extendhisi2 1
#define HAVE_extendqisi2 1
#define HAVE_extendqihi2 1
#define HAVE_truncxfsf2_i387_noop (TARGET_80387 && flag_unsafe_math_optimizations)
#define HAVE_truncxfdf2_i387_noop (TARGET_80387 && flag_unsafe_math_optimizations)
#define HAVE_fix_truncsfdi_sse (TARGET_64BIT && SSE_FLOAT_MODE_P (SFmode) \
   && (!TARGET_FISTTP || TARGET_SSE_MATH))
#define HAVE_fix_truncdfdi_sse (TARGET_64BIT && SSE_FLOAT_MODE_P (DFmode) \
   && (!TARGET_FISTTP || TARGET_SSE_MATH))
#define HAVE_fix_truncsfsi_sse (SSE_FLOAT_MODE_P (SFmode) \
   && (!TARGET_FISTTP || TARGET_SSE_MATH))
#define HAVE_fix_truncdfsi_sse (SSE_FLOAT_MODE_P (DFmode) \
   && (!TARGET_FISTTP || TARGET_SSE_MATH))
#define HAVE_fix_trunchi_fisttp_i387_1 (X87_FLOAT_MODE_P (GET_MODE (operands[1])) \
   && TARGET_FISTTP \
   && !((SSE_FLOAT_MODE_P (GET_MODE (operands[1])) \
	 && (TARGET_64BIT || HImode != DImode)) \
	&& TARGET_SSE_MATH) \
   && can_create_pseudo_p ())
#define HAVE_fix_truncsi_fisttp_i387_1 (X87_FLOAT_MODE_P (GET_MODE (operands[1])) \
   && TARGET_FISTTP \
   && !((SSE_FLOAT_MODE_P (GET_MODE (operands[1])) \
	 && (TARGET_64BIT || SImode != DImode)) \
	&& TARGET_SSE_MATH) \
   && can_create_pseudo_p ())
#define HAVE_fix_truncdi_fisttp_i387_1 (X87_FLOAT_MODE_P (GET_MODE (operands[1])) \
   && TARGET_FISTTP \
   && !((SSE_FLOAT_MODE_P (GET_MODE (operands[1])) \
	 && (TARGET_64BIT || DImode != DImode)) \
	&& TARGET_SSE_MATH) \
   && can_create_pseudo_p ())
#define HAVE_fix_trunchi_i387_fisttp (X87_FLOAT_MODE_P (GET_MODE (operands[1])) \
   && TARGET_FISTTP \
   && !((SSE_FLOAT_MODE_P (GET_MODE (operands[1])) \
	 && (TARGET_64BIT || HImode != DImode)) \
	&& TARGET_SSE_MATH))
#define HAVE_fix_truncsi_i387_fisttp (X87_FLOAT_MODE_P (GET_MODE (operands[1])) \
   && TARGET_FISTTP \
   && !((SSE_FLOAT_MODE_P (GET_MODE (operands[1])) \
	 && (TARGET_64BIT || SImode != DImode)) \
	&& TARGET_SSE_MATH))
#define HAVE_fix_truncdi_i387_fisttp (X87_FLOAT_MODE_P (GET_MODE (operands[1])) \
   && TARGET_FISTTP \
   && !((SSE_FLOAT_MODE_P (GET_MODE (operands[1])) \
	 && (TARGET_64BIT || DImode != DImode)) \
	&& TARGET_SSE_MATH))
#define HAVE_fix_trunchi_i387_fisttp_with_temp (X87_FLOAT_MODE_P (GET_MODE (operands[1])) \
   && TARGET_FISTTP \
   && !((SSE_FLOAT_MODE_P (GET_MODE (operands[1])) \
	&& (TARGET_64BIT || HImode != DImode)) \
	&& TARGET_SSE_MATH))
#define HAVE_fix_truncsi_i387_fisttp_with_temp (X87_FLOAT_MODE_P (GET_MODE (operands[1])) \
   && TARGET_FISTTP \
   && !((SSE_FLOAT_MODE_P (GET_MODE (operands[1])) \
	&& (TARGET_64BIT || SImode != DImode)) \
	&& TARGET_SSE_MATH))
#define HAVE_fix_truncdi_i387_fisttp_with_temp (X87_FLOAT_MODE_P (GET_MODE (operands[1])) \
   && TARGET_FISTTP \
   && !((SSE_FLOAT_MODE_P (GET_MODE (operands[1])) \
	&& (TARGET_64BIT || DImode != DImode)) \
	&& TARGET_SSE_MATH))
#define HAVE_fix_truncdi_i387 (X87_FLOAT_MODE_P (GET_MODE (operands[1])) \
   && !TARGET_FISTTP \
   && !(TARGET_64BIT && SSE_FLOAT_MODE_P (GET_MODE (operands[1]))))
#define HAVE_fix_truncdi_i387_with_temp (X87_FLOAT_MODE_P (GET_MODE (operands[1])) \
   && !TARGET_FISTTP \
   && !(TARGET_64BIT && SSE_FLOAT_MODE_P (GET_MODE (operands[1]))))
#define HAVE_fix_trunchi_i387 (X87_FLOAT_MODE_P (GET_MODE (operands[1])) \
   && !TARGET_FISTTP \
   && !SSE_FLOAT_MODE_P (GET_MODE (operands[1])))
#define HAVE_fix_truncsi_i387 (X87_FLOAT_MODE_P (GET_MODE (operands[1])) \
   && !TARGET_FISTTP \
   && !SSE_FLOAT_MODE_P (GET_MODE (operands[1])))
#define HAVE_fix_trunchi_i387_with_temp (X87_FLOAT_MODE_P (GET_MODE (operands[1])) \
   && !TARGET_FISTTP \
   && !SSE_FLOAT_MODE_P (GET_MODE (operands[1])))
#define HAVE_fix_truncsi_i387_with_temp (X87_FLOAT_MODE_P (GET_MODE (operands[1])) \
   && !TARGET_FISTTP \
   && !SSE_FLOAT_MODE_P (GET_MODE (operands[1])))
#define HAVE_x86_fnstcw_1 (TARGET_80387)
#define HAVE_x86_fldcw_1 (TARGET_80387)
#define HAVE_floatdisf2_i387_with_xmm (TARGET_80387 && X87_ENABLE_FLOAT (SFmode, DImode) \
   && TARGET_SSE2 && TARGET_INTER_UNIT_MOVES \
   && !TARGET_64BIT && optimize_function_for_speed_p (cfun))
#define HAVE_floatdidf2_i387_with_xmm (TARGET_80387 && X87_ENABLE_FLOAT (DFmode, DImode) \
   && TARGET_SSE2 && TARGET_INTER_UNIT_MOVES \
   && !TARGET_64BIT && optimize_function_for_speed_p (cfun))
#define HAVE_floatdixf2_i387_with_xmm (TARGET_80387 && X87_ENABLE_FLOAT (XFmode, DImode) \
   && TARGET_SSE2 && TARGET_INTER_UNIT_MOVES \
   && !TARGET_64BIT && optimize_function_for_speed_p (cfun))
#define HAVE_addqi3_cc (ix86_binary_operator_ok (PLUS, QImode, operands))
#define HAVE_addsi_1_zext (TARGET_64BIT && ix86_binary_operator_ok (PLUS, SImode, operands))
#define HAVE_addqi_ext_1 (!TARGET_64BIT)
#define HAVE_divmodsi4_1 1
#define HAVE_divmoddi4_1 (TARGET_64BIT)
#define HAVE_divmodhiqi3 (TARGET_QIMODE_MATH)
#define HAVE_udivmodsi4_1 1
#define HAVE_udivmoddi4_1 (TARGET_64BIT)
#define HAVE_udivmodhiqi3 (TARGET_QIMODE_MATH)
#define HAVE_andqi_ext_0 1
#define HAVE_copysignsf3_const ((SSE_FLOAT_MODE_P (SFmode) && TARGET_SSE_MATH) \
   || (TARGET_SSE2 && (SFmode == TFmode)))
#define HAVE_copysigndf3_const ((SSE_FLOAT_MODE_P (DFmode) && TARGET_SSE_MATH) \
   || (TARGET_SSE2 && (DFmode == TFmode)))
#define HAVE_copysigntf3_const ((SSE_FLOAT_MODE_P (TFmode) && TARGET_SSE_MATH) \
   || (TARGET_SSE2 && (TFmode == TFmode)))
#define HAVE_copysignsf3_var ((SSE_FLOAT_MODE_P (SFmode) && TARGET_SSE_MATH) \
   || (TARGET_SSE2 && (SFmode == TFmode)))
#define HAVE_copysigndf3_var ((SSE_FLOAT_MODE_P (DFmode) && TARGET_SSE_MATH) \
   || (TARGET_SSE2 && (DFmode == TFmode)))
#define HAVE_copysigntf3_var ((SSE_FLOAT_MODE_P (TFmode) && TARGET_SSE_MATH) \
   || (TARGET_SSE2 && (TFmode == TFmode)))
#define HAVE_x86_64_shld (TARGET_64BIT)
#define HAVE_x86_shld 1
#define HAVE_x86_64_shrd (TARGET_64BIT)
#define HAVE_x86_shrd 1
#define HAVE_ashrdi3_cvt (TARGET_64BIT && INTVAL (operands[2]) == 63 \
   && (TARGET_USE_CLTD || optimize_function_for_size_p (cfun)) \
   && ix86_binary_operator_ok (ASHIFTRT, DImode, operands))
#define HAVE_ashrsi3_cvt (INTVAL (operands[2]) == 31 \
   && (TARGET_USE_CLTD || optimize_function_for_size_p (cfun)) \
   && ix86_binary_operator_ok (ASHIFTRT, SImode, operands))
#define HAVE_ix86_rotldi3_doubleword (!TARGET_64BIT)
#define HAVE_ix86_rotlti3_doubleword (TARGET_64BIT)
#define HAVE_ix86_rotrdi3_doubleword (!TARGET_64BIT)
#define HAVE_ix86_rotrti3_doubleword (TARGET_64BIT)
#define HAVE_setcc_sf_sse (SSE_FLOAT_MODE_P (SFmode))
#define HAVE_setcc_df_sse (SSE_FLOAT_MODE_P (DFmode))
#define HAVE_jump 1
#define HAVE_blockage 1
#define HAVE_prologue_use 1
#define HAVE_simple_return_internal (reload_completed)
#define HAVE_simple_return_internal_long (reload_completed)
#define HAVE_simple_return_pop_internal (reload_completed)
#define HAVE_simple_return_indirect_internal (reload_completed)
#define HAVE_nop 1
#define HAVE_nops (reload_completed)
#define HAVE_pad 1
#define HAVE_set_got (!TARGET_64BIT)
#define HAVE_set_got_labelled (!TARGET_64BIT)
#define HAVE_set_got_rex64 (TARGET_64BIT)
#define HAVE_set_rip_rex64 (TARGET_64BIT)
#define HAVE_set_got_offset_rex64 (TARGET_LP64)
#define HAVE_eh_return_internal 1
#define HAVE_leave (!TARGET_64BIT)
#define HAVE_leave_rex64 (TARGET_64BIT)
#define HAVE_split_stack_return 1
#define HAVE_ffssi2_no_cmove (!TARGET_CMOVE)
#define HAVE_ctzhi2 1
#define HAVE_ctzsi2 1
#define HAVE_ctzdi2 (TARGET_64BIT)
#define HAVE_clzhi2_lzcnt (TARGET_LZCNT)
#define HAVE_clzsi2_lzcnt (TARGET_LZCNT)
#define HAVE_clzdi2_lzcnt ((TARGET_LZCNT) && (TARGET_64BIT))
#define HAVE_bmi_bextr_si (TARGET_BMI)
#define HAVE_bmi_bextr_di ((TARGET_BMI) && (TARGET_64BIT))
#define HAVE_bmi2_bzhi_si3 (TARGET_BMI2)
#define HAVE_bmi2_bzhi_di3 ((TARGET_BMI2) && (TARGET_64BIT))
#define HAVE_bmi2_pdep_si3 (TARGET_BMI2)
#define HAVE_bmi2_pdep_di3 ((TARGET_BMI2) && (TARGET_64BIT))
#define HAVE_bmi2_pext_si3 (TARGET_BMI2)
#define HAVE_bmi2_pext_di3 ((TARGET_BMI2) && (TARGET_64BIT))
#define HAVE_tbm_bextri_si (TARGET_TBM)
#define HAVE_tbm_bextri_di ((TARGET_TBM) && (TARGET_64BIT))
#define HAVE_bsr_rex64 (TARGET_64BIT)
#define HAVE_bsr 1
#define HAVE_popcounthi2 (TARGET_POPCNT)
#define HAVE_popcountsi2 (TARGET_POPCNT)
#define HAVE_popcountdi2 ((TARGET_POPCNT) && (TARGET_64BIT))
#define HAVE_bswaphi_lowpart 1
#define HAVE_paritydi2_cmp (! TARGET_POPCNT)
#define HAVE_paritysi2_cmp (! TARGET_POPCNT)
#define HAVE_truncxfsf2_i387_noop_unspec (TARGET_USE_FANCY_MATH_387)
#define HAVE_truncxfdf2_i387_noop_unspec (TARGET_USE_FANCY_MATH_387)
#define HAVE_sqrtxf2 (TARGET_USE_FANCY_MATH_387)
#define HAVE_sqrt_extendsfxf2_i387 (TARGET_USE_FANCY_MATH_387)
#define HAVE_sqrt_extenddfxf2_i387 (TARGET_USE_FANCY_MATH_387)
#define HAVE_fpremxf4_i387 (TARGET_USE_FANCY_MATH_387)
#define HAVE_fprem1xf4_i387 (TARGET_USE_FANCY_MATH_387)
#define HAVE_sincosxf3 (TARGET_USE_FANCY_MATH_387 \
   && flag_unsafe_math_optimizations)
#define HAVE_sincos_extendsfxf3_i387 (TARGET_USE_FANCY_MATH_387 \
   && (!(SSE_FLOAT_MODE_P (SFmode) && TARGET_SSE_MATH) \
       || TARGET_MIX_SSE_I387) \
   && flag_unsafe_math_optimizations)
#define HAVE_sincos_extenddfxf3_i387 (TARGET_USE_FANCY_MATH_387 \
   && (!(SSE_FLOAT_MODE_P (DFmode) && TARGET_SSE_MATH) \
       || TARGET_MIX_SSE_I387) \
   && flag_unsafe_math_optimizations)
#define HAVE_fptanxf4_i387 (TARGET_USE_FANCY_MATH_387 \
   && flag_unsafe_math_optimizations \
   && standard_80387_constant_p (operands[3]) == 2)
#define HAVE_fptan_extendsfxf4_i387 (TARGET_USE_FANCY_MATH_387 \
   && (!(SSE_FLOAT_MODE_P (SFmode) && TARGET_SSE_MATH) \
       || TARGET_MIX_SSE_I387) \
   && flag_unsafe_math_optimizations \
   && standard_80387_constant_p (operands[3]) == 2)
#define HAVE_fptan_extenddfxf4_i387 (TARGET_USE_FANCY_MATH_387 \
   && (!(SSE_FLOAT_MODE_P (DFmode) && TARGET_SSE_MATH) \
       || TARGET_MIX_SSE_I387) \
   && flag_unsafe_math_optimizations \
   && standard_80387_constant_p (operands[3]) == 2)
#define HAVE_fpatan_extendsfxf3_i387 (TARGET_USE_FANCY_MATH_387 \
   && (!(SSE_FLOAT_MODE_P (SFmode) && TARGET_SSE_MATH) \
       || TARGET_MIX_SSE_I387) \
   && flag_unsafe_math_optimizations)
#define HAVE_fpatan_extenddfxf3_i387 (TARGET_USE_FANCY_MATH_387 \
   && (!(SSE_FLOAT_MODE_P (DFmode) && TARGET_SSE_MATH) \
       || TARGET_MIX_SSE_I387) \
   && flag_unsafe_math_optimizations)
#define HAVE_fyl2xxf3_i387 (TARGET_USE_FANCY_MATH_387 \
   && flag_unsafe_math_optimizations)
#define HAVE_fyl2x_extendsfxf3_i387 (TARGET_USE_FANCY_MATH_387 \
   && (!(SSE_FLOAT_MODE_P (SFmode) && TARGET_SSE_MATH) \
       || TARGET_MIX_SSE_I387) \
   && flag_unsafe_math_optimizations)
#define HAVE_fyl2x_extenddfxf3_i387 (TARGET_USE_FANCY_MATH_387 \
   && (!(SSE_FLOAT_MODE_P (DFmode) && TARGET_SSE_MATH) \
       || TARGET_MIX_SSE_I387) \
   && flag_unsafe_math_optimizations)
#define HAVE_fyl2xp1xf3_i387 (TARGET_USE_FANCY_MATH_387 \
   && flag_unsafe_math_optimizations)
#define HAVE_fyl2xp1_extendsfxf3_i387 (TARGET_USE_FANCY_MATH_387 \
   && (!(SSE_FLOAT_MODE_P (SFmode) && TARGET_SSE_MATH) \
       || TARGET_MIX_SSE_I387) \
   && flag_unsafe_math_optimizations)
#define HAVE_fyl2xp1_extenddfxf3_i387 (TARGET_USE_FANCY_MATH_387 \
   && (!(SSE_FLOAT_MODE_P (DFmode) && TARGET_SSE_MATH) \
       || TARGET_MIX_SSE_I387) \
   && flag_unsafe_math_optimizations)
#define HAVE_fxtractxf3_i387 (TARGET_USE_FANCY_MATH_387 \
   && flag_unsafe_math_optimizations)
#define HAVE_fxtract_extendsfxf3_i387 (TARGET_USE_FANCY_MATH_387 \
   && (!(SSE_FLOAT_MODE_P (SFmode) && TARGET_SSE_MATH) \
       || TARGET_MIX_SSE_I387) \
   && flag_unsafe_math_optimizations)
#define HAVE_fxtract_extenddfxf3_i387 (TARGET_USE_FANCY_MATH_387 \
   && (!(SSE_FLOAT_MODE_P (DFmode) && TARGET_SSE_MATH) \
       || TARGET_MIX_SSE_I387) \
   && flag_unsafe_math_optimizations)
#define HAVE_sse4_1_roundsf2 (TARGET_ROUND)
#define HAVE_sse4_1_rounddf2 (TARGET_ROUND)
#define HAVE_rintxf2 (TARGET_USE_FANCY_MATH_387 \
   && flag_unsafe_math_optimizations)
#define HAVE_fistdi2 (TARGET_USE_FANCY_MATH_387)
#define HAVE_fistdi2_with_temp (TARGET_USE_FANCY_MATH_387)
#define HAVE_fisthi2 (TARGET_USE_FANCY_MATH_387)
#define HAVE_fistsi2 (TARGET_USE_FANCY_MATH_387)
#define HAVE_fisthi2_with_temp (TARGET_USE_FANCY_MATH_387)
#define HAVE_fistsi2_with_temp (TARGET_USE_FANCY_MATH_387)
#define HAVE_frndintxf2_floor (TARGET_USE_FANCY_MATH_387 \
   && flag_unsafe_math_optimizations \
   && can_create_pseudo_p ())
#define HAVE_frndintxf2_floor_i387 (TARGET_USE_FANCY_MATH_387 \
   && flag_unsafe_math_optimizations)
#define HAVE_fistdi2_floor (TARGET_USE_FANCY_MATH_387 \
   && flag_unsafe_math_optimizations)
#define HAVE_fistdi2_floor_with_temp (TARGET_USE_FANCY_MATH_387 \
   && flag_unsafe_math_optimizations)
#define HAVE_fisthi2_floor (TARGET_USE_FANCY_MATH_387 \
   && flag_unsafe_math_optimizations)
#define HAVE_fistsi2_floor (TARGET_USE_FANCY_MATH_387 \
   && flag_unsafe_math_optimizations)
#define HAVE_fisthi2_floor_with_temp (TARGET_USE_FANCY_MATH_387 \
   && flag_unsafe_math_optimizations)
#define HAVE_fistsi2_floor_with_temp (TARGET_USE_FANCY_MATH_387 \
   && flag_unsafe_math_optimizations)
#define HAVE_frndintxf2_ceil (TARGET_USE_FANCY_MATH_387 \
   && flag_unsafe_math_optimizations \
   && can_create_pseudo_p ())
#define HAVE_frndintxf2_ceil_i387 (TARGET_USE_FANCY_MATH_387 \
   && flag_unsafe_math_optimizations)
#define HAVE_fistdi2_ceil (TARGET_USE_FANCY_MATH_387 \
   && flag_unsafe_math_optimizations)
#define HAVE_fistdi2_ceil_with_temp (TARGET_USE_FANCY_MATH_387 \
   && flag_unsafe_math_optimizations)
#define HAVE_fisthi2_ceil (TARGET_USE_FANCY_MATH_387 \
   && flag_unsafe_math_optimizations)
#define HAVE_fistsi2_ceil (TARGET_USE_FANCY_MATH_387 \
   && flag_unsafe_math_optimizations)
#define HAVE_fisthi2_ceil_with_temp (TARGET_USE_FANCY_MATH_387 \
   && flag_unsafe_math_optimizations)
#define HAVE_fistsi2_ceil_with_temp (TARGET_USE_FANCY_MATH_387 \
   && flag_unsafe_math_optimizations)
#define HAVE_frndintxf2_trunc (TARGET_USE_FANCY_MATH_387 \
   && flag_unsafe_math_optimizations \
   && can_create_pseudo_p ())
#define HAVE_frndintxf2_trunc_i387 (TARGET_USE_FANCY_MATH_387 \
   && flag_unsafe_math_optimizations)
#define HAVE_frndintxf2_mask_pm (TARGET_USE_FANCY_MATH_387 \
   && flag_unsafe_math_optimizations \
   && can_create_pseudo_p ())
#define HAVE_frndintxf2_mask_pm_i387 (TARGET_USE_FANCY_MATH_387 \
   && flag_unsafe_math_optimizations)
#define HAVE_fxamsf2_i387 (TARGET_USE_FANCY_MATH_387)
#define HAVE_fxamdf2_i387 (TARGET_USE_FANCY_MATH_387)
#define HAVE_fxamxf2_i387 (TARGET_USE_FANCY_MATH_387)
#define HAVE_fxamsf2_i387_with_temp (TARGET_USE_FANCY_MATH_387 \
   && can_create_pseudo_p ())
#define HAVE_fxamdf2_i387_with_temp (TARGET_USE_FANCY_MATH_387 \
   && can_create_pseudo_p ())
#define HAVE_movmsk_df (SSE_FLOAT_MODE_P (DFmode) && TARGET_SSE_MATH)
#define HAVE_cld 1
#define HAVE_smaxsf3 (SSE_FLOAT_MODE_P (SFmode) && TARGET_SSE_MATH)
#define HAVE_sminsf3 (SSE_FLOAT_MODE_P (SFmode) && TARGET_SSE_MATH)
#define HAVE_smaxdf3 (SSE_FLOAT_MODE_P (DFmode) && TARGET_SSE_MATH)
#define HAVE_smindf3 (SSE_FLOAT_MODE_P (DFmode) && TARGET_SSE_MATH)
#define HAVE_pro_epilogue_adjust_stack_si_add (Pmode == SImode)
#define HAVE_pro_epilogue_adjust_stack_di_add (Pmode == DImode)
#define HAVE_pro_epilogue_adjust_stack_si_sub (Pmode == SImode)
#define HAVE_pro_epilogue_adjust_stack_di_sub (Pmode == DImode)
#define HAVE_allocate_stack_worker_probe_si ((ix86_target_stack_probe ()) && (Pmode == SImode))
#define HAVE_allocate_stack_worker_probe_di ((ix86_target_stack_probe ()) && (Pmode == DImode))
#define HAVE_adjust_stack_and_probesi (Pmode == SImode)
#define HAVE_adjust_stack_and_probedi (Pmode == DImode)
#define HAVE_probe_stack_rangesi (Pmode == SImode)
#define HAVE_probe_stack_rangedi (Pmode == DImode)
#define HAVE_trap 1
#define HAVE_stack_protect_set_si ((!TARGET_HAS_BIONIC) && (ptr_mode == SImode))
#define HAVE_stack_protect_set_di ((!TARGET_HAS_BIONIC) && (ptr_mode == DImode))
#define HAVE_stack_tls_protect_set_si (ptr_mode == SImode)
#define HAVE_stack_tls_protect_set_di (ptr_mode == DImode)
#define HAVE_stack_protect_test_si ((!TARGET_HAS_BIONIC) && (ptr_mode == SImode))
#define HAVE_stack_protect_test_di ((!TARGET_HAS_BIONIC) && (ptr_mode == DImode))
#define HAVE_stack_tls_protect_test_si (ptr_mode == SImode)
#define HAVE_stack_tls_protect_test_di (ptr_mode == DImode)
#define HAVE_sse4_2_crc32qi (TARGET_SSE4_2 || TARGET_CRC32)
#define HAVE_sse4_2_crc32hi (TARGET_SSE4_2 || TARGET_CRC32)
#define HAVE_sse4_2_crc32si (TARGET_SSE4_2 || TARGET_CRC32)
#define HAVE_sse4_2_crc32di (TARGET_64BIT && (TARGET_SSE4_2 || TARGET_CRC32))
#define HAVE_lwp_slwpcbsi ((TARGET_LWP) && (Pmode == SImode))
#define HAVE_lwp_slwpcbdi ((TARGET_LWP) && (Pmode == DImode))
#define HAVE_rdfsbasesi (TARGET_64BIT && TARGET_FSGSBASE)
#define HAVE_rdfsbasedi ((TARGET_64BIT && TARGET_FSGSBASE) && (TARGET_64BIT))
#define HAVE_rdgsbasesi (TARGET_64BIT && TARGET_FSGSBASE)
#define HAVE_rdgsbasedi ((TARGET_64BIT && TARGET_FSGSBASE) && (TARGET_64BIT))
#define HAVE_wrfsbasesi (TARGET_64BIT && TARGET_FSGSBASE)
#define HAVE_wrfsbasedi ((TARGET_64BIT && TARGET_FSGSBASE) && (TARGET_64BIT))
#define HAVE_wrgsbasesi (TARGET_64BIT && TARGET_FSGSBASE)
#define HAVE_wrgsbasedi ((TARGET_64BIT && TARGET_FSGSBASE) && (TARGET_64BIT))
#define HAVE_rdrandhi_1 (TARGET_RDRND)
#define HAVE_rdrandsi_1 (TARGET_RDRND)
#define HAVE_rdranddi_1 ((TARGET_RDRND) && (TARGET_64BIT))
#define HAVE_sse_movntq (TARGET_SSE || TARGET_3DNOW_A)
#define HAVE_mmx_rcpv2sf2 (TARGET_3DNOW)
#define HAVE_mmx_rcpit1v2sf3 (TARGET_3DNOW)
#define HAVE_mmx_rcpit2v2sf3 (TARGET_3DNOW)
#define HAVE_mmx_rsqrtv2sf2 (TARGET_3DNOW)
#define HAVE_mmx_rsqit1v2sf3 (TARGET_3DNOW)
#define HAVE_mmx_haddv2sf3 (TARGET_3DNOW)
#define HAVE_mmx_hsubv2sf3 (TARGET_3DNOW_A)
#define HAVE_mmx_addsubv2sf3 (TARGET_3DNOW_A)
#define HAVE_mmx_gtv2sf3 (TARGET_3DNOW)
#define HAVE_mmx_gev2sf3 (TARGET_3DNOW)
#define HAVE_mmx_pf2id (TARGET_3DNOW)
#define HAVE_mmx_pf2iw (TARGET_3DNOW_A)
#define HAVE_mmx_pi2fw (TARGET_3DNOW_A)
#define HAVE_mmx_floatv2si2 (TARGET_3DNOW)
#define HAVE_mmx_pswapdv2sf2 (TARGET_3DNOW_A)
#define HAVE_mmx_ashrv4hi3 (TARGET_MMX)
#define HAVE_mmx_ashrv2si3 (TARGET_MMX)
#define HAVE_mmx_ashlv4hi3 (TARGET_MMX)
#define HAVE_mmx_lshrv4hi3 (TARGET_MMX)
#define HAVE_mmx_ashlv2si3 (TARGET_MMX)
#define HAVE_mmx_lshrv2si3 (TARGET_MMX)
#define HAVE_mmx_ashlv1di3 (TARGET_MMX)
#define HAVE_mmx_lshrv1di3 (TARGET_MMX)
#define HAVE_mmx_gtv8qi3 (TARGET_MMX)
#define HAVE_mmx_gtv4hi3 (TARGET_MMX)
#define HAVE_mmx_gtv2si3 (TARGET_MMX)
#define HAVE_mmx_andnotv8qi3 (TARGET_MMX)
#define HAVE_mmx_andnotv4hi3 (TARGET_MMX)
#define HAVE_mmx_andnotv2si3 (TARGET_MMX)
#define HAVE_mmx_packsswb (TARGET_MMX)
#define HAVE_mmx_packssdw (TARGET_MMX)
#define HAVE_mmx_packuswb (TARGET_MMX)
#define HAVE_mmx_punpckhbw (TARGET_MMX)
#define HAVE_mmx_punpcklbw (TARGET_MMX)
#define HAVE_mmx_punpckhwd (TARGET_MMX)
#define HAVE_mmx_punpcklwd (TARGET_MMX)
#define HAVE_mmx_punpckhdq (TARGET_MMX)
#define HAVE_mmx_punpckldq (TARGET_MMX)
#define HAVE_mmx_pextrw (TARGET_SSE || TARGET_3DNOW_A)
#define HAVE_mmx_pshufw_1 (TARGET_SSE || TARGET_3DNOW_A)
#define HAVE_mmx_pswapdv2si2 (TARGET_3DNOW_A)
#define HAVE_mmx_psadbw (TARGET_SSE || TARGET_3DNOW_A)
#define HAVE_mmx_pmovmskb (TARGET_SSE || TARGET_3DNOW_A)
#define HAVE_sse2_movq128 (TARGET_SSE2)
#define HAVE_movdi_to_sse (!TARGET_64BIT && TARGET_SSE2 && TARGET_INTER_UNIT_MOVES)
#define HAVE_avx_loadups256 ((TARGET_SSE) && (TARGET_AVX))
#define HAVE_sse_loadups (TARGET_SSE)
#define HAVE_avx_loadupd256 ((TARGET_SSE) && (TARGET_AVX))
#define HAVE_sse2_loadupd ((TARGET_SSE) && (TARGET_SSE2))
#define HAVE_avx_storeups256 ((TARGET_SSE) && (TARGET_AVX))
#define HAVE_sse_storeups (TARGET_SSE)
#define HAVE_avx_storeupd256 ((TARGET_SSE) && (TARGET_AVX))
#define HAVE_sse2_storeupd ((TARGET_SSE) && (TARGET_SSE2))
#define HAVE_avx_loaddqu256 ((TARGET_SSE2) && (TARGET_AVX))
#define HAVE_sse2_loaddqu (TARGET_SSE2)
#define HAVE_avx_storedqu256 ((TARGET_SSE2) && (TARGET_AVX))
#define HAVE_sse2_storedqu (TARGET_SSE2)
#define HAVE_avx_lddqu256 ((TARGET_SSE3) && (TARGET_AVX))
#define HAVE_sse3_lddqu (TARGET_SSE3)
#define HAVE_sse2_movntisi (TARGET_SSE2)
#define HAVE_sse2_movntidi ((TARGET_SSE2) && (TARGET_64BIT))
#define HAVE_avx_movntv8sf ((TARGET_SSE) && (TARGET_AVX))
#define HAVE_sse_movntv4sf (TARGET_SSE)
#define HAVE_avx_movntv4df ((TARGET_SSE) && (TARGET_AVX))
#define HAVE_sse2_movntv2df ((TARGET_SSE) && (TARGET_SSE2))
#define HAVE_avx_movntv4di ((TARGET_SSE2) && (TARGET_AVX))
#define HAVE_sse2_movntv2di (TARGET_SSE2)
#define HAVE_sse_vmaddv4sf3 (TARGET_SSE)
#define HAVE_sse_vmsubv4sf3 (TARGET_SSE)
#define HAVE_sse2_vmaddv2df3 ((TARGET_SSE) && (TARGET_SSE2))
#define HAVE_sse2_vmsubv2df3 ((TARGET_SSE) && (TARGET_SSE2))
#define HAVE_sse_vmmulv4sf3 (TARGET_SSE)
#define HAVE_sse2_vmmulv2df3 ((TARGET_SSE) && (TARGET_SSE2))
#define HAVE_avx_divv8sf3 ((TARGET_SSE) && (TARGET_AVX))
#define HAVE_sse_divv4sf3 (TARGET_SSE)
#define HAVE_avx_divv4df3 ((TARGET_SSE) && (TARGET_AVX))
#define HAVE_sse2_divv2df3 ((TARGET_SSE) && (TARGET_SSE2))
#define HAVE_sse_vmdivv4sf3 (TARGET_SSE)
#define HAVE_sse2_vmdivv2df3 ((TARGET_SSE) && (TARGET_SSE2))
#define HAVE_avx_rcpv8sf2 ((TARGET_SSE) && (TARGET_AVX))
#define HAVE_sse_rcpv4sf2 (TARGET_SSE)
#define HAVE_sse_vmrcpv4sf2 (TARGET_SSE)
#define HAVE_avx_sqrtv8sf2 ((TARGET_SSE) && (TARGET_AVX))
#define HAVE_sse_sqrtv4sf2 (TARGET_SSE)
#define HAVE_avx_sqrtv4df2 ((TARGET_SSE) && (TARGET_AVX))
#define HAVE_sse2_sqrtv2df2 ((TARGET_SSE) && (TARGET_SSE2))
#define HAVE_sse_vmsqrtv4sf2 (TARGET_SSE)
#define HAVE_sse2_vmsqrtv2df2 ((TARGET_SSE) && (TARGET_SSE2))
#define HAVE_avx_rsqrtv8sf2 ((TARGET_SSE) && (TARGET_AVX))
#define HAVE_sse_rsqrtv4sf2 (TARGET_SSE)
#define HAVE_sse_vmrsqrtv4sf2 (TARGET_SSE)
#define HAVE_sse_vmsmaxv4sf3 (TARGET_SSE)
#define HAVE_sse_vmsminv4sf3 (TARGET_SSE)
#define HAVE_sse2_vmsmaxv2df3 ((TARGET_SSE) && (TARGET_SSE2))
#define HAVE_sse2_vmsminv2df3 ((TARGET_SSE) && (TARGET_SSE2))
#define HAVE_avx_addsubv4df3 (TARGET_AVX)
#define HAVE_sse3_addsubv2df3 (TARGET_SSE3)
#define HAVE_avx_addsubv8sf3 (TARGET_AVX)
#define HAVE_sse3_addsubv4sf3 (TARGET_SSE3)
#define HAVE_avx_haddv4df3 (TARGET_AVX)
#define HAVE_avx_hsubv4df3 (TARGET_AVX)
#define HAVE_sse3_haddv2df3 (TARGET_SSE3)
#define HAVE_sse3_hsubv2df3 (TARGET_SSE3)
#define HAVE_avx_haddv8sf3 (TARGET_AVX)
#define HAVE_avx_hsubv8sf3 (TARGET_AVX)
#define HAVE_sse3_haddv4sf3 (TARGET_SSE3)
#define HAVE_sse3_hsubv4sf3 (TARGET_SSE3)
#define HAVE_avx_cmpv8sf3 (TARGET_AVX)
#define HAVE_avx_cmpv4sf3 (TARGET_AVX)
#define HAVE_avx_cmpv4df3 (TARGET_AVX)
#define HAVE_avx_cmpv2df3 ((TARGET_AVX) && (TARGET_SSE2))
#define HAVE_avx_vmcmpv4sf3 (TARGET_AVX)
#define HAVE_avx_vmcmpv2df3 ((TARGET_AVX) && (TARGET_SSE2))
#define HAVE_avx_maskcmpv8sf3 ((TARGET_SSE) && (TARGET_AVX))
#define HAVE_sse_maskcmpv4sf3 (TARGET_SSE)
#define HAVE_avx_maskcmpv4df3 ((TARGET_SSE) && (TARGET_AVX))
#define HAVE_sse2_maskcmpv2df3 ((TARGET_SSE) && (TARGET_SSE2))
#define HAVE_sse_vmmaskcmpv4sf3 (TARGET_SSE)
#define HAVE_sse2_vmmaskcmpv2df3 ((TARGET_SSE) && (TARGET_SSE2))
#define HAVE_sse_comi (SSE_FLOAT_MODE_P (SFmode))
#define HAVE_sse2_comi (SSE_FLOAT_MODE_P (DFmode))
#define HAVE_sse_ucomi (SSE_FLOAT_MODE_P (SFmode))
#define HAVE_sse2_ucomi (SSE_FLOAT_MODE_P (DFmode))
#define HAVE_avx_andnotv8sf3 ((TARGET_SSE) && (TARGET_AVX))
#define HAVE_sse_andnotv4sf3 (TARGET_SSE)
#define HAVE_avx_andnotv4df3 ((TARGET_SSE) && (TARGET_AVX))
#define HAVE_sse2_andnotv2df3 ((TARGET_SSE) && (TARGET_SSE2))
#define HAVE_sse_cvtpi2ps (TARGET_SSE)
#define HAVE_sse_cvtps2pi (TARGET_SSE)
#define HAVE_sse_cvttps2pi (TARGET_SSE)
#define HAVE_sse_cvtsi2ss (TARGET_SSE)
#define HAVE_sse_cvtsi2ssq (TARGET_SSE && TARGET_64BIT)
#define HAVE_sse_cvtss2si (TARGET_SSE)
#define HAVE_sse_cvtss2si_2 (TARGET_SSE)
#define HAVE_sse_cvtss2siq (TARGET_SSE && TARGET_64BIT)
#define HAVE_sse_cvtss2siq_2 (TARGET_SSE && TARGET_64BIT)
#define HAVE_sse_cvttss2si (TARGET_SSE)
#define HAVE_sse_cvttss2siq (TARGET_SSE && TARGET_64BIT)
#define HAVE_floatv8siv8sf2 ((TARGET_SSE2) && (TARGET_AVX))
#define HAVE_floatv4siv4sf2 (TARGET_SSE2)
#define HAVE_avx_cvtps2dq256 (TARGET_AVX)
#define HAVE_sse2_cvtps2dq (TARGET_SSE2)
#define HAVE_fix_truncv8sfv8si2 (TARGET_AVX)
#define HAVE_fix_truncv4sfv4si2 (TARGET_SSE2)
#define HAVE_sse2_cvtpi2pd (TARGET_SSE2)
#define HAVE_sse2_cvtpd2pi (TARGET_SSE2)
#define HAVE_sse2_cvttpd2pi (TARGET_SSE2)
#define HAVE_sse2_cvtsi2sd (TARGET_SSE2)
#define HAVE_sse2_cvtsi2sdq (TARGET_SSE2 && TARGET_64BIT)
#define HAVE_sse2_cvtsd2si (TARGET_SSE2)
#define HAVE_sse2_cvtsd2si_2 (TARGET_SSE2)
#define HAVE_sse2_cvtsd2siq (TARGET_SSE2 && TARGET_64BIT)
#define HAVE_sse2_cvtsd2siq_2 (TARGET_SSE2 && TARGET_64BIT)
#define HAVE_sse2_cvttsd2si (TARGET_SSE2)
#define HAVE_sse2_cvttsd2siq (TARGET_SSE2 && TARGET_64BIT)
#define HAVE_floatv4siv4df2 (TARGET_AVX)
#define HAVE_avx_cvtdq2pd256_2 (TARGET_AVX)
#define HAVE_sse2_cvtdq2pd (TARGET_SSE2)
#define HAVE_avx_cvtpd2dq256 (TARGET_AVX)
#define HAVE_fix_truncv4dfv4si2 (TARGET_AVX)
#define HAVE_sse2_cvtsd2ss (TARGET_SSE2)
#define HAVE_sse2_cvtss2sd (TARGET_SSE2)
#define HAVE_avx_cvtpd2ps256 (TARGET_AVX)
#define HAVE_avx_cvtps2pd256 (TARGET_AVX)
#define HAVE_sse2_cvtps2pd (TARGET_SSE2)
#define HAVE_sse_movhlps (TARGET_SSE && !(MEM_P (operands[1]) && MEM_P (operands[2])))
#define HAVE_sse_movlhps (TARGET_SSE && ix86_binary_operator_ok (UNKNOWN, V4SFmode, operands))
#define HAVE_avx_unpckhps256 (TARGET_AVX)
#define HAVE_vec_interleave_highv4sf (TARGET_SSE)
#define HAVE_avx_unpcklps256 (TARGET_AVX)
#define HAVE_vec_interleave_lowv4sf (TARGET_SSE)
#define HAVE_avx_movshdup256 (TARGET_AVX)
#define HAVE_sse3_movshdup (TARGET_SSE3)
#define HAVE_avx_movsldup256 (TARGET_AVX)
#define HAVE_sse3_movsldup (TARGET_SSE3)
#define HAVE_avx_shufps256_1 (TARGET_AVX \
   && (INTVAL (operands[3]) == (INTVAL (operands[7]) - 4) \
       && INTVAL (operands[4]) == (INTVAL (operands[8]) - 4) \
       && INTVAL (operands[5]) == (INTVAL (operands[9]) - 4) \
       && INTVAL (operands[6]) == (INTVAL (operands[10]) - 4)))
#define HAVE_sse_shufps_v4si (TARGET_SSE)
#define HAVE_sse_shufps_v4sf (TARGET_SSE)
#define HAVE_sse_storehps (TARGET_SSE)
#define HAVE_sse_loadhps (TARGET_SSE)
#define HAVE_sse_storelps (TARGET_SSE)
#define HAVE_sse_loadlps (TARGET_SSE)
#define HAVE_sse_movss (TARGET_SSE)
#define HAVE_avx2_vec_dupv8sf ((TARGET_AVX2) && (TARGET_AVX))
#define HAVE_avx2_vec_dupv4sf (TARGET_AVX2)
#define HAVE_vec_dupv4sf (TARGET_SSE)
#define HAVE_vec_setv4si_0 (TARGET_SSE)
#define HAVE_vec_setv4sf_0 (TARGET_SSE)
#define HAVE_sse4_1_insertps (TARGET_SSE4_1)
#define HAVE_vec_extract_lo_v4di (TARGET_AVX && !(MEM_P (operands[0]) && MEM_P (operands[1])))
#define HAVE_vec_extract_lo_v4df (TARGET_AVX && !(MEM_P (operands[0]) && MEM_P (operands[1])))
#define HAVE_vec_extract_hi_v4di (TARGET_AVX)
#define HAVE_vec_extract_hi_v4df (TARGET_AVX)
#define HAVE_vec_extract_lo_v8si (TARGET_AVX && !(MEM_P (operands[0]) && MEM_P (operands[1])))
#define HAVE_vec_extract_lo_v8sf (TARGET_AVX && !(MEM_P (operands[0]) && MEM_P (operands[1])))
#define HAVE_vec_extract_hi_v8si (TARGET_AVX)
#define HAVE_vec_extract_hi_v8sf (TARGET_AVX)
#define HAVE_vec_extract_lo_v16hi (TARGET_AVX && !(MEM_P (operands[0]) && MEM_P (operands[1])))
#define HAVE_vec_extract_hi_v16hi (TARGET_AVX)
#define HAVE_vec_extract_lo_v32qi (TARGET_AVX && !(MEM_P (operands[0]) && MEM_P (operands[1])))
#define HAVE_vec_extract_hi_v32qi (TARGET_AVX)
#define HAVE_avx_unpckhpd256 (TARGET_AVX)
#define HAVE_avx_shufpd256_1 (TARGET_AVX)
#define HAVE_avx2_interleave_highv4di (TARGET_AVX2)
#define HAVE_vec_interleave_highv2di (TARGET_SSE2)
#define HAVE_avx2_interleave_lowv4di (TARGET_AVX2)
#define HAVE_vec_interleave_lowv2di (TARGET_SSE2)
#define HAVE_sse2_shufpd_v2di (TARGET_SSE2)
#define HAVE_sse2_shufpd_v2df (TARGET_SSE2)
#define HAVE_sse2_storehpd (TARGET_SSE2 && !(MEM_P (operands[0]) && MEM_P (operands[1])))
#define HAVE_sse2_storelpd (TARGET_SSE2 && !(MEM_P (operands[0]) && MEM_P (operands[1])))
#define HAVE_sse2_loadhpd (TARGET_SSE2 && !(MEM_P (operands[1]) && MEM_P (operands[2])))
#define HAVE_sse2_loadlpd (TARGET_SSE2 && !(MEM_P (operands[1]) && MEM_P (operands[2])))
#define HAVE_sse2_movsd (TARGET_SSE2)
#define HAVE_vec_dupv2df (TARGET_SSE2)
#define HAVE_mulv32qi3 ((TARGET_SSE2 \
   && can_create_pseudo_p ()) && (TARGET_AVX2))
#define HAVE_mulv16qi3 (TARGET_SSE2 \
   && can_create_pseudo_p ())
#define HAVE_mulv4di3 ((TARGET_SSE2 \
   && can_create_pseudo_p ()) && (TARGET_AVX2))
#define HAVE_mulv2di3 (TARGET_SSE2 \
   && can_create_pseudo_p ())
#define HAVE_ashrv16hi3 ((TARGET_SSE2) && (TARGET_AVX2))
#define HAVE_ashrv8hi3 (TARGET_SSE2)
#define HAVE_ashrv8si3 ((TARGET_SSE2) && (TARGET_AVX2))
#define HAVE_ashrv4si3 (TARGET_SSE2)
#define HAVE_ashlv16hi3 ((TARGET_SSE2) && (TARGET_AVX2))
#define HAVE_lshrv16hi3 ((TARGET_SSE2) && (TARGET_AVX2))
#define HAVE_ashlv8hi3 (TARGET_SSE2)
#define HAVE_lshrv8hi3 (TARGET_SSE2)
#define HAVE_ashlv8si3 ((TARGET_SSE2) && (TARGET_AVX2))
#define HAVE_lshrv8si3 ((TARGET_SSE2) && (TARGET_AVX2))
#define HAVE_ashlv4si3 (TARGET_SSE2)
#define HAVE_lshrv4si3 (TARGET_SSE2)
#define HAVE_ashlv4di3 ((TARGET_SSE2) && (TARGET_AVX2))
#define HAVE_lshrv4di3 ((TARGET_SSE2) && (TARGET_AVX2))
#define HAVE_ashlv2di3 (TARGET_SSE2)
#define HAVE_lshrv2di3 (TARGET_SSE2)
#define HAVE_avx2_ashlv2ti3 ((TARGET_SSE2) && (TARGET_AVX2))
#define HAVE_sse2_ashlv1ti3 (TARGET_SSE2)
#define HAVE_avx2_lshrv2ti3 ((TARGET_SSE2) && (TARGET_AVX2))
#define HAVE_sse2_lshrv1ti3 (TARGET_SSE2)
#define HAVE_sse4_2_gtv2di3 (TARGET_SSE4_2)
#define HAVE_avx2_gtv32qi3 (TARGET_AVX2)
#define HAVE_avx2_gtv16hi3 (TARGET_AVX2)
#define HAVE_avx2_gtv8si3 (TARGET_AVX2)
#define HAVE_avx2_gtv4di3 (TARGET_AVX2)
#define HAVE_sse2_gtv16qi3 (TARGET_SSE2 && !TARGET_XOP)
#define HAVE_sse2_gtv8hi3 (TARGET_SSE2 && !TARGET_XOP)
#define HAVE_sse2_gtv4si3 (TARGET_SSE2 && !TARGET_XOP)
#define HAVE_avx2_packsswb ((TARGET_SSE2) && (TARGET_AVX2))
#define HAVE_sse2_packsswb (TARGET_SSE2)
#define HAVE_avx2_packssdw ((TARGET_SSE2) && (TARGET_AVX2))
#define HAVE_sse2_packssdw (TARGET_SSE2)
#define HAVE_avx2_packuswb ((TARGET_SSE2) && (TARGET_AVX2))
#define HAVE_sse2_packuswb (TARGET_SSE2)
#define HAVE_avx2_interleave_highv32qi (TARGET_AVX2)
#define HAVE_vec_interleave_highv16qi (TARGET_SSE2)
#define HAVE_avx2_interleave_lowv32qi (TARGET_AVX2)
#define HAVE_vec_interleave_lowv16qi (TARGET_SSE2)
#define HAVE_avx2_interleave_highv16hi (TARGET_AVX2)
#define HAVE_vec_interleave_highv8hi (TARGET_SSE2)
#define HAVE_avx2_interleave_lowv16hi (TARGET_AVX2)
#define HAVE_vec_interleave_lowv8hi (TARGET_SSE2)
#define HAVE_avx2_interleave_highv8si (TARGET_AVX2)
#define HAVE_vec_interleave_highv4si (TARGET_SSE2)
#define HAVE_avx2_interleave_lowv8si (TARGET_AVX2)
#define HAVE_vec_interleave_lowv4si (TARGET_SSE2)
#define HAVE_sse4_1_pinsrb ((TARGET_SSE2 \
   && ((unsigned) exact_log2 (INTVAL (operands[3])) \
       < GET_MODE_NUNITS (V16QImode))) && (TARGET_SSE4_1))
#define HAVE_sse2_pinsrw (TARGET_SSE2 \
   && ((unsigned) exact_log2 (INTVAL (operands[3])) \
       < GET_MODE_NUNITS (V8HImode)))
#define HAVE_sse4_1_pinsrd ((TARGET_SSE2 \
   && ((unsigned) exact_log2 (INTVAL (operands[3])) \
       < GET_MODE_NUNITS (V4SImode))) && (TARGET_SSE4_1))
#define HAVE_sse4_1_pinsrq ((TARGET_SSE2 \
   && ((unsigned) exact_log2 (INTVAL (operands[3])) \
       < GET_MODE_NUNITS (V2DImode))) && (TARGET_SSE4_1 && TARGET_64BIT))
#define HAVE_avx2_pshufd_1 (TARGET_AVX2 \
   && INTVAL (operands[2]) + 4 == INTVAL (operands[6]) \
   && INTVAL (operands[3]) + 4 == INTVAL (operands[7]) \
   && INTVAL (operands[4]) + 4 == INTVAL (operands[8]) \
   && INTVAL (operands[5]) + 4 == INTVAL (operands[9]))
#define HAVE_sse2_pshufd_1 (TARGET_SSE2)
#define HAVE_avx2_pshuflw_1 (TARGET_AVX2 \
   && INTVAL (operands[2]) + 8 == INTVAL (operands[6]) \
   && INTVAL (operands[3]) + 8 == INTVAL (operands[7]) \
   && INTVAL (operands[4]) + 8 == INTVAL (operands[8]) \
   && INTVAL (operands[5]) + 8 == INTVAL (operands[9]))
#define HAVE_sse2_pshuflw_1 (TARGET_SSE2)
#define HAVE_avx2_pshufhw_1 (TARGET_AVX2 \
   && INTVAL (operands[2]) + 8 == INTVAL (operands[6]) \
   && INTVAL (operands[3]) + 8 == INTVAL (operands[7]) \
   && INTVAL (operands[4]) + 8 == INTVAL (operands[8]) \
   && INTVAL (operands[5]) + 8 == INTVAL (operands[9]))
#define HAVE_sse2_pshufhw_1 (TARGET_SSE2)
#define HAVE_sse2_loadld (TARGET_SSE)
#define HAVE_sse2_stored (TARGET_SSE)
#define HAVE_vec_concatv2di (!TARGET_64BIT && TARGET_SSE)
#define HAVE_avx2_psadbw ((TARGET_SSE2) && (TARGET_AVX2))
#define HAVE_sse2_psadbw (TARGET_SSE2)
#define HAVE_avx_movmskps256 ((TARGET_SSE) && (TARGET_AVX))
#define HAVE_sse_movmskps (TARGET_SSE)
#define HAVE_avx_movmskpd256 ((TARGET_SSE) && (TARGET_AVX))
#define HAVE_sse2_movmskpd ((TARGET_SSE) && (TARGET_SSE2))
#define HAVE_avx2_pmovmskb (TARGET_AVX2)
#define HAVE_sse2_pmovmskb (TARGET_SSE2)
#define HAVE_sse_ldmxcsr (TARGET_SSE)
#define HAVE_sse_stmxcsr (TARGET_SSE)
#define HAVE_sse2_clflush (TARGET_SSE2)
#define HAVE_sse3_mwait (TARGET_SSE3)
#define HAVE_sse3_monitor (TARGET_SSE3 && !TARGET_64BIT)
#define HAVE_sse3_monitor64 (TARGET_SSE3 && TARGET_64BIT)
#define HAVE_avx2_phaddwv16hi3 (TARGET_AVX2)
#define HAVE_ssse3_phaddwv8hi3 (TARGET_SSSE3)
#define HAVE_ssse3_phaddwv4hi3 (TARGET_SSSE3)
#define HAVE_avx2_phadddv8si3 (TARGET_AVX2)
#define HAVE_ssse3_phadddv4si3 (TARGET_SSSE3)
#define HAVE_ssse3_phadddv2si3 (TARGET_SSSE3)
#define HAVE_avx2_phaddswv16hi3 (TARGET_AVX2)
#define HAVE_ssse3_phaddswv8hi3 (TARGET_SSSE3)
#define HAVE_ssse3_phaddswv4hi3 (TARGET_SSSE3)
#define HAVE_avx2_phsubwv16hi3 (TARGET_AVX2)
#define HAVE_ssse3_phsubwv8hi3 (TARGET_SSSE3)
#define HAVE_ssse3_phsubwv4hi3 (TARGET_SSSE3)
#define HAVE_avx2_phsubdv8si3 (TARGET_AVX2)
#define HAVE_ssse3_phsubdv4si3 (TARGET_SSSE3)
#define HAVE_ssse3_phsubdv2si3 (TARGET_SSSE3)
#define HAVE_avx2_phsubswv16hi3 (TARGET_AVX2)
#define HAVE_ssse3_phsubswv8hi3 (TARGET_SSSE3)
#define HAVE_ssse3_phsubswv4hi3 (TARGET_SSSE3)
#define HAVE_avx2_pmaddubsw256 (TARGET_AVX2)
#define HAVE_ssse3_pmaddubsw128 (TARGET_SSSE3)
#define HAVE_ssse3_pmaddubsw (TARGET_SSSE3)
#define HAVE_avx2_pshufbv32qi3 ((TARGET_SSSE3) && (TARGET_AVX2))
#define HAVE_ssse3_pshufbv16qi3 (TARGET_SSSE3)
#define HAVE_ssse3_pshufbv8qi3 (TARGET_SSSE3)
#define HAVE_avx2_psignv32qi3 ((TARGET_SSSE3) && (TARGET_AVX2))
#define HAVE_ssse3_psignv16qi3 (TARGET_SSSE3)
#define HAVE_avx2_psignv16hi3 ((TARGET_SSSE3) && (TARGET_AVX2))
#define HAVE_ssse3_psignv8hi3 (TARGET_SSSE3)
#define HAVE_avx2_psignv8si3 ((TARGET_SSSE3) && (TARGET_AVX2))
#define HAVE_ssse3_psignv4si3 (TARGET_SSSE3)
#define HAVE_ssse3_psignv8qi3 (TARGET_SSSE3)
#define HAVE_ssse3_psignv4hi3 (TARGET_SSSE3)
#define HAVE_ssse3_psignv2si3 (TARGET_SSSE3)
#define HAVE_avx2_palignrv2ti ((TARGET_SSSE3) && (TARGET_AVX2))
#define HAVE_ssse3_palignrti (TARGET_SSSE3)
#define HAVE_ssse3_palignrdi (TARGET_SSSE3)
#define HAVE_absv32qi2 ((TARGET_SSSE3) && (TARGET_AVX2))
#define HAVE_absv16qi2 (TARGET_SSSE3)
#define HAVE_absv16hi2 ((TARGET_SSSE3) && (TARGET_AVX2))
#define HAVE_absv8hi2 (TARGET_SSSE3)
#define HAVE_absv8si2 ((TARGET_SSSE3) && (TARGET_AVX2))
#define HAVE_absv4si2 (TARGET_SSSE3)
#define HAVE_absv8qi2 (TARGET_SSSE3)
#define HAVE_absv4hi2 (TARGET_SSSE3)
#define HAVE_absv2si2 (TARGET_SSSE3)
#define HAVE_sse4a_movntsf (TARGET_SSE4A)
#define HAVE_sse4a_movntdf (TARGET_SSE4A)
#define HAVE_sse4a_vmmovntv4sf (TARGET_SSE4A)
#define HAVE_sse4a_vmmovntv2df ((TARGET_SSE4A) && (TARGET_SSE2))
#define HAVE_sse4a_extrqi (TARGET_SSE4A)
#define HAVE_sse4a_extrq (TARGET_SSE4A)
#define HAVE_sse4a_insertqi (TARGET_SSE4A)
#define HAVE_sse4a_insertq (TARGET_SSE4A)
#define HAVE_avx_blendps256 ((TARGET_SSE4_1) && (TARGET_AVX))
#define HAVE_sse4_1_blendps (TARGET_SSE4_1)
#define HAVE_avx_blendpd256 ((TARGET_SSE4_1) && (TARGET_AVX))
#define HAVE_sse4_1_blendpd ((TARGET_SSE4_1) && (TARGET_SSE2))
#define HAVE_avx_blendvps256 ((TARGET_SSE4_1) && (TARGET_AVX))
#define HAVE_sse4_1_blendvps (TARGET_SSE4_1)
#define HAVE_avx_blendvpd256 ((TARGET_SSE4_1) && (TARGET_AVX))
#define HAVE_sse4_1_blendvpd ((TARGET_SSE4_1) && (TARGET_SSE2))
#define HAVE_avx_dpps256 ((TARGET_SSE4_1) && (TARGET_AVX))
#define HAVE_sse4_1_dpps (TARGET_SSE4_1)
#define HAVE_avx_dppd256 ((TARGET_SSE4_1) && (TARGET_AVX))
#define HAVE_sse4_1_dppd ((TARGET_SSE4_1) && (TARGET_SSE2))
#define HAVE_avx2_movntdqa ((TARGET_SSE4_1) && (TARGET_AVX2))
#define HAVE_sse4_1_movntdqa (TARGET_SSE4_1)
#define HAVE_avx2_mpsadbw ((TARGET_SSE4_1) && (TARGET_AVX2))
#define HAVE_sse4_1_mpsadbw (TARGET_SSE4_1)
#define HAVE_avx2_packusdw (TARGET_AVX2)
#define HAVE_sse4_1_packusdw (TARGET_SSE4_1)
#define HAVE_avx2_pblendvb ((TARGET_SSE4_1) && (TARGET_AVX2))
#define HAVE_sse4_1_pblendvb (TARGET_SSE4_1)
#define HAVE_sse4_1_pblendw (TARGET_SSE4_1)
#define HAVE_avx2_pblenddv8si (TARGET_AVX2)
#define HAVE_avx2_pblenddv4si (TARGET_AVX2)
#define HAVE_sse4_1_phminposuw (TARGET_SSE4_1)
#define HAVE_avx2_sign_extendv16qiv16hi2 (TARGET_AVX2)
#define HAVE_avx2_zero_extendv16qiv16hi2 (TARGET_AVX2)
#define HAVE_sse4_1_sign_extendv8qiv8hi2 (TARGET_SSE4_1)
#define HAVE_sse4_1_zero_extendv8qiv8hi2 (TARGET_SSE4_1)
#define HAVE_avx2_sign_extendv8qiv8si2 (TARGET_AVX2)
#define HAVE_avx2_zero_extendv8qiv8si2 (TARGET_AVX2)
#define HAVE_sse4_1_sign_extendv4qiv4si2 (TARGET_SSE4_1)
#define HAVE_sse4_1_zero_extendv4qiv4si2 (TARGET_SSE4_1)
#define HAVE_avx2_sign_extendv8hiv8si2 (TARGET_AVX2)
#define HAVE_avx2_zero_extendv8hiv8si2 (TARGET_AVX2)
#define HAVE_sse4_1_sign_extendv4hiv4si2 (TARGET_SSE4_1)
#define HAVE_sse4_1_zero_extendv4hiv4si2 (TARGET_SSE4_1)
#define HAVE_avx2_sign_extendv4qiv4di2 (TARGET_AVX2)
#define HAVE_avx2_zero_extendv4qiv4di2 (TARGET_AVX2)
#define HAVE_sse4_1_sign_extendv2qiv2di2 (TARGET_SSE4_1)
#define HAVE_sse4_1_zero_extendv2qiv2di2 (TARGET_SSE4_1)
#define HAVE_avx2_sign_extendv4hiv4di2 (TARGET_AVX2)
#define HAVE_avx2_zero_extendv4hiv4di2 (TARGET_AVX2)
#define HAVE_sse4_1_sign_extendv2hiv2di2 (TARGET_SSE4_1)
#define HAVE_sse4_1_zero_extendv2hiv2di2 (TARGET_SSE4_1)
#define HAVE_avx2_sign_extendv4siv4di2 (TARGET_AVX2)
#define HAVE_avx2_zero_extendv4siv4di2 (TARGET_AVX2)
#define HAVE_sse4_1_sign_extendv2siv2di2 (TARGET_SSE4_1)
#define HAVE_sse4_1_zero_extendv2siv2di2 (TARGET_SSE4_1)
#define HAVE_avx_vtestps256 (TARGET_AVX)
#define HAVE_avx_vtestps (TARGET_AVX)
#define HAVE_avx_vtestpd256 (TARGET_AVX)
#define HAVE_avx_vtestpd ((TARGET_AVX) && (TARGET_SSE2))
#define HAVE_avx_ptest256 (TARGET_AVX)
#define HAVE_sse4_1_ptest (TARGET_SSE4_1)
#define HAVE_avx_roundps256 ((TARGET_ROUND) && (TARGET_AVX))
#define HAVE_sse4_1_roundps (TARGET_ROUND)
#define HAVE_avx_roundpd256 ((TARGET_ROUND) && (TARGET_AVX))
#define HAVE_sse4_1_roundpd ((TARGET_ROUND) && (TARGET_SSE2))
#define HAVE_sse4_1_roundss (TARGET_ROUND)
#define HAVE_sse4_1_roundsd ((TARGET_ROUND) && (TARGET_SSE2))
#define HAVE_sse4_2_pcmpestr (TARGET_SSE4_2 \
   && can_create_pseudo_p ())
#define HAVE_sse4_2_pcmpestri (TARGET_SSE4_2)
#define HAVE_sse4_2_pcmpestrm (TARGET_SSE4_2)
#define HAVE_sse4_2_pcmpestr_cconly (TARGET_SSE4_2)
#define HAVE_sse4_2_pcmpistr (TARGET_SSE4_2 \
   && can_create_pseudo_p ())
#define HAVE_sse4_2_pcmpistri (TARGET_SSE4_2)
#define HAVE_sse4_2_pcmpistrm (TARGET_SSE4_2)
#define HAVE_sse4_2_pcmpistr_cconly (TARGET_SSE4_2)
#define HAVE_xop_pmacsww (TARGET_XOP)
#define HAVE_xop_pmacssww (TARGET_XOP)
#define HAVE_xop_pmacsdd (TARGET_XOP)
#define HAVE_xop_pmacssdd (TARGET_XOP)
#define HAVE_xop_pmacssdql (TARGET_XOP)
#define HAVE_xop_pmacssdqh (TARGET_XOP)
#define HAVE_xop_pmacsdql (TARGET_XOP)
#define HAVE_xop_pmacsdqh (TARGET_XOP)
#define HAVE_xop_pmacsswd (TARGET_XOP)
#define HAVE_xop_pmacswd (TARGET_XOP)
#define HAVE_xop_pmadcsswd (TARGET_XOP)
#define HAVE_xop_pmadcswd (TARGET_XOP)
#define HAVE_xop_pcmov_v32qi256 ((TARGET_XOP) && (TARGET_AVX))
#define HAVE_xop_pcmov_v16qi (TARGET_XOP)
#define HAVE_xop_pcmov_v16hi256 ((TARGET_XOP) && (TARGET_AVX))
#define HAVE_xop_pcmov_v8hi (TARGET_XOP)
#define HAVE_xop_pcmov_v8si256 ((TARGET_XOP) && (TARGET_AVX))
#define HAVE_xop_pcmov_v4si (TARGET_XOP)
#define HAVE_xop_pcmov_v4di256 ((TARGET_XOP) && (TARGET_AVX))
#define HAVE_xop_pcmov_v2di (TARGET_XOP)
#define HAVE_xop_pcmov_v8sf256 ((TARGET_XOP) && (TARGET_AVX))
#define HAVE_xop_pcmov_v4sf (TARGET_XOP)
#define HAVE_xop_pcmov_v4df256 ((TARGET_XOP) && (TARGET_AVX))
#define HAVE_xop_pcmov_v2df ((TARGET_XOP) && (TARGET_SSE2))
#define HAVE_xop_phaddbw (TARGET_XOP)
#define HAVE_xop_phaddbd (TARGET_XOP)
#define HAVE_xop_phaddbq (TARGET_XOP)
#define HAVE_xop_phaddwd (TARGET_XOP)
#define HAVE_xop_phaddwq (TARGET_XOP)
#define HAVE_xop_phadddq (TARGET_XOP)
#define HAVE_xop_phaddubw (TARGET_XOP)
#define HAVE_xop_phaddubd (TARGET_XOP)
#define HAVE_xop_phaddubq (TARGET_XOP)
#define HAVE_xop_phadduwd (TARGET_XOP)
#define HAVE_xop_phadduwq (TARGET_XOP)
#define HAVE_xop_phaddudq (TARGET_XOP)
#define HAVE_xop_phsubbw (TARGET_XOP)
#define HAVE_xop_phsubwd (TARGET_XOP)
#define HAVE_xop_phsubdq (TARGET_XOP)
#define HAVE_xop_pperm (TARGET_XOP && !(MEM_P (operands[2]) && MEM_P (operands[3])))
#define HAVE_xop_pperm_pack_v2di_v4si (TARGET_XOP && !(MEM_P (operands[2]) && MEM_P (operands[3])))
#define HAVE_xop_pperm_pack_v4si_v8hi (TARGET_XOP && !(MEM_P (operands[2]) && MEM_P (operands[3])))
#define HAVE_xop_pperm_pack_v8hi_v16qi (TARGET_XOP && !(MEM_P (operands[2]) && MEM_P (operands[3])))
#define HAVE_xop_rotlv16qi3 (TARGET_XOP)
#define HAVE_xop_rotlv8hi3 (TARGET_XOP)
#define HAVE_xop_rotlv4si3 (TARGET_XOP)
#define HAVE_xop_rotlv2di3 (TARGET_XOP)
#define HAVE_xop_rotrv16qi3 (TARGET_XOP)
#define HAVE_xop_rotrv8hi3 (TARGET_XOP)
#define HAVE_xop_rotrv4si3 (TARGET_XOP)
#define HAVE_xop_rotrv2di3 (TARGET_XOP)
#define HAVE_xop_vrotlv16qi3 (TARGET_XOP && !(MEM_P (operands[1]) && MEM_P (operands[2])))
#define HAVE_xop_vrotlv8hi3 (TARGET_XOP && !(MEM_P (operands[1]) && MEM_P (operands[2])))
#define HAVE_xop_vrotlv4si3 (TARGET_XOP && !(MEM_P (operands[1]) && MEM_P (operands[2])))
#define HAVE_xop_vrotlv2di3 (TARGET_XOP && !(MEM_P (operands[1]) && MEM_P (operands[2])))
#define HAVE_xop_shav16qi3 (TARGET_XOP && !(MEM_P (operands[1]) && MEM_P (operands[2])))
#define HAVE_xop_shav8hi3 (TARGET_XOP && !(MEM_P (operands[1]) && MEM_P (operands[2])))
#define HAVE_xop_shav4si3 (TARGET_XOP && !(MEM_P (operands[1]) && MEM_P (operands[2])))
#define HAVE_xop_shav2di3 (TARGET_XOP && !(MEM_P (operands[1]) && MEM_P (operands[2])))
#define HAVE_xop_shlv16qi3 (TARGET_XOP && !(MEM_P (operands[1]) && MEM_P (operands[2])))
#define HAVE_xop_shlv8hi3 (TARGET_XOP && !(MEM_P (operands[1]) && MEM_P (operands[2])))
#define HAVE_xop_shlv4si3 (TARGET_XOP && !(MEM_P (operands[1]) && MEM_P (operands[2])))
#define HAVE_xop_shlv2di3 (TARGET_XOP && !(MEM_P (operands[1]) && MEM_P (operands[2])))
#define HAVE_xop_frczsf2 (TARGET_XOP)
#define HAVE_xop_frczdf2 (TARGET_XOP)
#define HAVE_xop_frczv4sf2 (TARGET_XOP)
#define HAVE_xop_frczv2df2 (TARGET_XOP)
#define HAVE_xop_frczv8sf2 (TARGET_XOP)
#define HAVE_xop_frczv4df2 (TARGET_XOP)
#define HAVE_xop_maskcmpv16qi3 (TARGET_XOP)
#define HAVE_xop_maskcmpv8hi3 (TARGET_XOP)
#define HAVE_xop_maskcmpv4si3 (TARGET_XOP)
#define HAVE_xop_maskcmpv2di3 (TARGET_XOP)
#define HAVE_xop_maskcmp_unsv16qi3 (TARGET_XOP)
#define HAVE_xop_maskcmp_unsv8hi3 (TARGET_XOP)
#define HAVE_xop_maskcmp_unsv4si3 (TARGET_XOP)
#define HAVE_xop_maskcmp_unsv2di3 (TARGET_XOP)
#define HAVE_xop_maskcmp_uns2v16qi3 (TARGET_XOP)
#define HAVE_xop_maskcmp_uns2v8hi3 (TARGET_XOP)
#define HAVE_xop_maskcmp_uns2v4si3 (TARGET_XOP)
#define HAVE_xop_maskcmp_uns2v2di3 (TARGET_XOP)
#define HAVE_xop_pcom_tfv16qi3 (TARGET_XOP)
#define HAVE_xop_pcom_tfv8hi3 (TARGET_XOP)
#define HAVE_xop_pcom_tfv4si3 (TARGET_XOP)
#define HAVE_xop_pcom_tfv2di3 (TARGET_XOP)
#define HAVE_xop_vpermil2v8sf3 ((TARGET_XOP) && (TARGET_AVX))
#define HAVE_xop_vpermil2v4sf3 (TARGET_XOP)
#define HAVE_xop_vpermil2v4df3 ((TARGET_XOP) && (TARGET_AVX))
#define HAVE_xop_vpermil2v2df3 ((TARGET_XOP) && (TARGET_SSE2))
#define HAVE_aesenc (TARGET_AES)
#define HAVE_aesenclast (TARGET_AES)
#define HAVE_aesdec (TARGET_AES)
#define HAVE_aesdeclast (TARGET_AES)
#define HAVE_aesimc (TARGET_AES)
#define HAVE_aeskeygenassist (TARGET_AES)
#define HAVE_pclmulqdq (TARGET_PCLMUL)
#define HAVE_avx_vzeroupper (TARGET_AVX)
#define HAVE_avx2_pbroadcastv32qi ((TARGET_AVX2) && (TARGET_AVX))
#define HAVE_avx2_pbroadcastv16qi (TARGET_AVX2)
#define HAVE_avx2_pbroadcastv16hi ((TARGET_AVX2) && (TARGET_AVX))
#define HAVE_avx2_pbroadcastv8hi (TARGET_AVX2)
#define HAVE_avx2_pbroadcastv8si ((TARGET_AVX2) && (TARGET_AVX))
#define HAVE_avx2_pbroadcastv4si (TARGET_AVX2)
#define HAVE_avx2_pbroadcastv4di ((TARGET_AVX2) && (TARGET_AVX))
#define HAVE_avx2_pbroadcastv2di (TARGET_AVX2)
#define HAVE_avx2_permvarv8si (TARGET_AVX2)
#define HAVE_avx2_permv4df (TARGET_AVX2)
#define HAVE_avx2_permvarv8sf (TARGET_AVX2)
#define HAVE_avx2_permv4di_1 (TARGET_AVX2)
#define HAVE_avx2_permv2ti (TARGET_AVX2)
#define HAVE_avx2_vec_dupv4df (TARGET_AVX2)
#define HAVE_vec_dupv8si (TARGET_AVX)
#define HAVE_vec_dupv8sf (TARGET_AVX)
#define HAVE_vec_dupv4di (TARGET_AVX)
#define HAVE_vec_dupv4df (TARGET_AVX)
#define HAVE_avx2_vbroadcasti128_v32qi (TARGET_AVX2)
#define HAVE_avx2_vbroadcasti128_v16hi (TARGET_AVX2)
#define HAVE_avx2_vbroadcasti128_v8si (TARGET_AVX2)
#define HAVE_avx2_vbroadcasti128_v4di (TARGET_AVX2)
#define HAVE_avx_vbroadcastf128_v32qi (TARGET_AVX)
#define HAVE_avx_vbroadcastf128_v16hi (TARGET_AVX)
#define HAVE_avx_vbroadcastf128_v8si (TARGET_AVX)
#define HAVE_avx_vbroadcastf128_v4di (TARGET_AVX)
#define HAVE_avx_vbroadcastf128_v8sf (TARGET_AVX)
#define HAVE_avx_vbroadcastf128_v4df (TARGET_AVX)
#define HAVE_avx_vpermilvarv8sf3 (TARGET_AVX)
#define HAVE_avx_vpermilvarv4sf3 (TARGET_AVX)
#define HAVE_avx_vpermilvarv4df3 (TARGET_AVX)
#define HAVE_avx_vpermilvarv2df3 ((TARGET_AVX) && (TARGET_SSE2))
#define HAVE_avx2_vec_set_lo_v4di (TARGET_AVX2)
#define HAVE_avx2_vec_set_hi_v4di (TARGET_AVX2)
#define HAVE_vec_set_lo_v4di (TARGET_AVX)
#define HAVE_vec_set_lo_v4df (TARGET_AVX)
#define HAVE_vec_set_hi_v4di (TARGET_AVX)
#define HAVE_vec_set_hi_v4df (TARGET_AVX)
#define HAVE_vec_set_lo_v8si (TARGET_AVX)
#define HAVE_vec_set_lo_v8sf (TARGET_AVX)
#define HAVE_vec_set_hi_v8si (TARGET_AVX)
#define HAVE_vec_set_hi_v8sf (TARGET_AVX)
#define HAVE_vec_set_lo_v16hi (TARGET_AVX)
#define HAVE_vec_set_hi_v16hi (TARGET_AVX)
#define HAVE_vec_set_lo_v32qi (TARGET_AVX)
#define HAVE_vec_set_hi_v32qi (TARGET_AVX)
#define HAVE_avx_maskloadps (TARGET_AVX)
#define HAVE_avx_maskloadpd (TARGET_AVX)
#define HAVE_avx_maskloadps256 (TARGET_AVX)
#define HAVE_avx_maskloadpd256 (TARGET_AVX)
#define HAVE_avx2_maskloadd ((TARGET_AVX) && (TARGET_AVX2))
#define HAVE_avx2_maskloadq ((TARGET_AVX) && (TARGET_AVX2))
#define HAVE_avx2_maskloadd256 ((TARGET_AVX) && (TARGET_AVX2))
#define HAVE_avx2_maskloadq256 ((TARGET_AVX) && (TARGET_AVX2))
#define HAVE_avx_maskstoreps (TARGET_AVX)
#define HAVE_avx_maskstorepd (TARGET_AVX)
#define HAVE_avx_maskstoreps256 (TARGET_AVX)
#define HAVE_avx_maskstorepd256 (TARGET_AVX)
#define HAVE_avx2_maskstored ((TARGET_AVX) && (TARGET_AVX2))
#define HAVE_avx2_maskstoreq ((TARGET_AVX) && (TARGET_AVX2))
#define HAVE_avx2_maskstored256 ((TARGET_AVX) && (TARGET_AVX2))
#define HAVE_avx2_maskstoreq256 ((TARGET_AVX) && (TARGET_AVX2))
#define HAVE_avx_si256_si (TARGET_AVX)
#define HAVE_avx_ps256_ps (TARGET_AVX)
#define HAVE_avx_pd256_pd (TARGET_AVX)
#define HAVE_avx2_ashrvv8si (TARGET_AVX2)
#define HAVE_avx2_ashrvv4si (TARGET_AVX2)
#define HAVE_avx2_ashlvv8si (TARGET_AVX2)
#define HAVE_avx2_lshrvv8si (TARGET_AVX2)
#define HAVE_avx2_ashlvv4si (TARGET_AVX2)
#define HAVE_avx2_lshrvv4si (TARGET_AVX2)
#define HAVE_avx2_ashlvv4di (TARGET_AVX2)
#define HAVE_avx2_lshrvv4di (TARGET_AVX2)
#define HAVE_avx2_ashlvv2di (TARGET_AVX2)
#define HAVE_avx2_lshrvv2di (TARGET_AVX2)
#define HAVE_avx_vec_concatv32qi (TARGET_AVX)
#define HAVE_avx_vec_concatv16hi (TARGET_AVX)
#define HAVE_avx_vec_concatv8si (TARGET_AVX)
#define HAVE_avx_vec_concatv4di (TARGET_AVX)
#define HAVE_avx_vec_concatv8sf (TARGET_AVX)
#define HAVE_avx_vec_concatv4df (TARGET_AVX)
#define HAVE_vcvtph2ps (TARGET_F16C)
#define HAVE_vcvtph2ps256 (TARGET_F16C)
#define HAVE_vcvtps2ph256 (TARGET_F16C)
#define HAVE_mfence_sse2 (TARGET_64BIT || TARGET_SSE2)
#define HAVE_mfence_nosse (!(TARGET_64BIT || TARGET_SSE2))
#define HAVE_atomic_loaddi_fpu (!TARGET_64BIT && (TARGET_80387 || TARGET_SSE))
#define HAVE_atomic_storeqi_1 1
#define HAVE_atomic_storehi_1 1
#define HAVE_atomic_storesi_1 1
#define HAVE_atomic_storedi_1 (TARGET_64BIT)
#define HAVE_atomic_storedi_fpu (!TARGET_64BIT && (TARGET_80387 || TARGET_SSE))
#define HAVE_loaddi_via_fpu (TARGET_80387)
#define HAVE_storedi_via_fpu (TARGET_80387)
#define HAVE_atomic_compare_and_swapqi_1 (TARGET_CMPXCHG)
#define HAVE_atomic_compare_and_swaphi_1 (TARGET_CMPXCHG)
#define HAVE_atomic_compare_and_swapsi_1 (TARGET_CMPXCHG)
#define HAVE_atomic_compare_and_swapdi_1 ((TARGET_CMPXCHG) && (TARGET_64BIT))
#define HAVE_atomic_compare_and_swapdi_doubleword ((TARGET_CMPXCHG8B) && (!TARGET_64BIT))
#define HAVE_atomic_compare_and_swapti_doubleword ((TARGET_CMPXCHG16B) && (TARGET_64BIT))
#define HAVE_atomic_fetch_addqi (TARGET_XADD)
#define HAVE_atomic_fetch_addhi (TARGET_XADD)
#define HAVE_atomic_fetch_addsi (TARGET_XADD)
#define HAVE_atomic_fetch_adddi ((TARGET_XADD) && (TARGET_64BIT))
#define HAVE_atomic_exchangeqi 1
#define HAVE_atomic_exchangehi 1
#define HAVE_atomic_exchangesi 1
#define HAVE_atomic_exchangedi (TARGET_64BIT)
#define HAVE_atomic_addqi 1
#define HAVE_atomic_addhi 1
#define HAVE_atomic_addsi 1
#define HAVE_atomic_adddi (TARGET_64BIT)
#define HAVE_atomic_subqi 1
#define HAVE_atomic_subhi 1
#define HAVE_atomic_subsi 1
#define HAVE_atomic_subdi (TARGET_64BIT)
#define HAVE_atomic_andqi 1
#define HAVE_atomic_orqi 1
#define HAVE_atomic_xorqi 1
#define HAVE_atomic_andhi 1
#define HAVE_atomic_orhi 1
#define HAVE_atomic_xorhi 1
#define HAVE_atomic_andsi 1
#define HAVE_atomic_orsi 1
#define HAVE_atomic_xorsi 1
#define HAVE_atomic_anddi (TARGET_64BIT)
#define HAVE_atomic_ordi (TARGET_64BIT)
#define HAVE_atomic_xordi (TARGET_64BIT)
#define HAVE_cbranchqi4 (TARGET_QIMODE_MATH)
#define HAVE_cbranchhi4 (TARGET_HIMODE_MATH)
#define HAVE_cbranchsi4 1
#define HAVE_cbranchdi4 1
#define HAVE_cbranchti4 (TARGET_64BIT)
#define HAVE_cstoreqi4 (TARGET_QIMODE_MATH)
#define HAVE_cstorehi4 (TARGET_HIMODE_MATH)
#define HAVE_cstoresi4 1
#define HAVE_cstoredi4 (TARGET_64BIT)
#define HAVE_cmpsi_1 1
#define HAVE_cmpdi_1 (TARGET_64BIT)
#define HAVE_cmpqi_ext_3 1
#define HAVE_cbranchxf4 (TARGET_80387)
#define HAVE_cstorexf4 (TARGET_80387)
#define HAVE_cbranchsf4 (TARGET_80387 || (SSE_FLOAT_MODE_P (SFmode) && TARGET_SSE_MATH))
#define HAVE_cbranchdf4 (TARGET_80387 || (SSE_FLOAT_MODE_P (DFmode) && TARGET_SSE_MATH))
#define HAVE_cstoresf4 (TARGET_80387 || (SSE_FLOAT_MODE_P (SFmode) && TARGET_SSE_MATH))
#define HAVE_cstoredf4 (TARGET_80387 || (SSE_FLOAT_MODE_P (DFmode) && TARGET_SSE_MATH))
#define HAVE_cbranchcc4 1
#define HAVE_cstorecc4 1
#define HAVE_movoi (TARGET_AVX)
#define HAVE_movti (TARGET_64BIT || TARGET_SSE)
#define HAVE_movcdi 1
#define HAVE_movqi 1
#define HAVE_movhi 1
#define HAVE_movsi 1
#define HAVE_movdi 1
#define HAVE_reload_noff_store (TARGET_64BIT)
#define HAVE_reload_noff_load (TARGET_64BIT)
#define HAVE_movstrictqi 1
#define HAVE_movstricthi 1
#define HAVE_movsi_insv_1 1
#define HAVE_movdi_insv_1 (TARGET_64BIT)
#define HAVE_movtf (TARGET_64BIT || TARGET_SSE2)
#define HAVE_movsf 1
#define HAVE_movdf 1
#define HAVE_movxf 1
#define HAVE_zero_extendsidi2 1
#define HAVE_zero_extendhisi2 1
#define HAVE_zero_extendqihi2 1
#define HAVE_zero_extendqisi2 1
#define HAVE_extendsidi2 1
#define HAVE_extendsfdf2 (TARGET_80387 || (TARGET_SSE2 && TARGET_SSE_MATH))
#define HAVE_extendsfxf2 (TARGET_80387)
#define HAVE_extenddfxf2 (TARGET_80387)
#define HAVE_truncdfsf2 (TARGET_80387 || (TARGET_SSE2 && TARGET_SSE_MATH))
#define HAVE_truncdfsf2_with_temp 1
#define HAVE_truncxfsf2 (TARGET_80387)
#define HAVE_truncxfdf2 (TARGET_80387)
#define HAVE_fix_truncxfdi2 (TARGET_80387)
#define HAVE_fix_truncsfdi2 (TARGET_80387 || (TARGET_64BIT && SSE_FLOAT_MODE_P (SFmode)))
#define HAVE_fix_truncdfdi2 (TARGET_80387 || (TARGET_64BIT && SSE_FLOAT_MODE_P (DFmode)))
#define HAVE_fix_truncxfsi2 (TARGET_80387)
#define HAVE_fix_truncsfsi2 (TARGET_80387 || SSE_FLOAT_MODE_P (SFmode))
#define HAVE_fix_truncdfsi2 (TARGET_80387 || SSE_FLOAT_MODE_P (DFmode))
#define HAVE_fix_truncsfhi2 (TARGET_80387 \
   && !(SSE_FLOAT_MODE_P (SFmode) && (!TARGET_FISTTP || TARGET_SSE_MATH)))
#define HAVE_fix_truncdfhi2 (TARGET_80387 \
   && !(SSE_FLOAT_MODE_P (DFmode) && (!TARGET_FISTTP || TARGET_SSE_MATH)))
#define HAVE_fix_truncxfhi2 (TARGET_80387 \
   && !(SSE_FLOAT_MODE_P (XFmode) && (!TARGET_FISTTP || TARGET_SSE_MATH)))
#define HAVE_fixuns_truncsfsi2 (!TARGET_64BIT && TARGET_SSE2 && TARGET_SSE_MATH)
#define HAVE_fixuns_truncdfsi2 (!TARGET_64BIT && TARGET_SSE2 && TARGET_SSE_MATH)
#define HAVE_fixuns_truncsfhi2 (SSE_FLOAT_MODE_P (SFmode) && TARGET_SSE_MATH)
#define HAVE_fixuns_truncdfhi2 (SSE_FLOAT_MODE_P (DFmode) && TARGET_SSE_MATH)
#define HAVE_floathisf2 (TARGET_80387 \
   && (!(SSE_FLOAT_MODE_P (SFmode) && TARGET_SSE_MATH) \
       || TARGET_MIX_SSE_I387))
#define HAVE_floathidf2 (TARGET_80387 \
   && (!(SSE_FLOAT_MODE_P (DFmode) && TARGET_SSE_MATH) \
       || TARGET_MIX_SSE_I387))
#define HAVE_floathixf2 (TARGET_80387 \
   && (!(SSE_FLOAT_MODE_P (XFmode) && TARGET_SSE_MATH) \
       || TARGET_MIX_SSE_I387))
#define HAVE_floatsisf2 (TARGET_80387 \
   || ((SImode != DImode || TARGET_64BIT) \
       && SSE_FLOAT_MODE_P (SFmode) && TARGET_SSE_MATH))
#define HAVE_floatsidf2 (TARGET_80387 \
   || ((SImode != DImode || TARGET_64BIT) \
       && SSE_FLOAT_MODE_P (DFmode) && TARGET_SSE_MATH))
#define HAVE_floatsixf2 (TARGET_80387 \
   || ((SImode != DImode || TARGET_64BIT) \
       && SSE_FLOAT_MODE_P (XFmode) && TARGET_SSE_MATH))
#define HAVE_floatdisf2 (TARGET_80387 \
   || ((DImode != DImode || TARGET_64BIT) \
       && SSE_FLOAT_MODE_P (SFmode) && TARGET_SSE_MATH))
#define HAVE_floatdidf2 (TARGET_80387 \
   || ((DImode != DImode || TARGET_64BIT) \
       && SSE_FLOAT_MODE_P (DFmode) && TARGET_SSE_MATH))
#define HAVE_floatdixf2 (TARGET_80387 \
   || ((DImode != DImode || TARGET_64BIT) \
       && SSE_FLOAT_MODE_P (XFmode) && TARGET_SSE_MATH))
#define HAVE_floatunssisf2 (!TARGET_64BIT \
   && ((TARGET_80387 && X87_ENABLE_FLOAT (SFmode, DImode) \
	&& TARGET_SSE) \
       || (SSE_FLOAT_MODE_P (SFmode) && TARGET_SSE_MATH)))
#define HAVE_floatunssidf2 (!TARGET_64BIT \
   && ((TARGET_80387 && X87_ENABLE_FLOAT (DFmode, DImode) \
	&& TARGET_SSE) \
       || (SSE_FLOAT_MODE_P (DFmode) && TARGET_SSE_MATH)))
#define HAVE_floatunssixf2 (!TARGET_64BIT \
   && ((TARGET_80387 && X87_ENABLE_FLOAT (XFmode, DImode) \
	&& TARGET_SSE) \
       || (SSE_FLOAT_MODE_P (XFmode) && TARGET_SSE_MATH)))
#define HAVE_floatunsdisf2 (TARGET_64BIT && TARGET_SSE_MATH)
#define HAVE_floatunsdidf2 ((TARGET_64BIT || TARGET_KEEPS_VECTOR_ALIGNED_STACK) \
   && TARGET_SSE2 && TARGET_SSE_MATH)
#define HAVE_addqi3 (TARGET_QIMODE_MATH)
#define HAVE_addhi3 (TARGET_HIMODE_MATH)
#define HAVE_addsi3 1
#define HAVE_adddi3 1
#define HAVE_addti3 (TARGET_64BIT)
#define HAVE_subqi3 (TARGET_QIMODE_MATH)
#define HAVE_subhi3 (TARGET_HIMODE_MATH)
#define HAVE_subsi3 1
#define HAVE_subdi3 1
#define HAVE_subti3 (TARGET_64BIT)
#define HAVE_addqi3_carry (ix86_binary_operator_ok (PLUS, QImode, operands))
#define HAVE_subqi3_carry (ix86_binary_operator_ok (MINUS, QImode, operands))
#define HAVE_addhi3_carry (ix86_binary_operator_ok (PLUS, HImode, operands))
#define HAVE_subhi3_carry (ix86_binary_operator_ok (MINUS, HImode, operands))
#define HAVE_addsi3_carry (ix86_binary_operator_ok (PLUS, SImode, operands))
#define HAVE_subsi3_carry (ix86_binary_operator_ok (MINUS, SImode, operands))
#define HAVE_adddi3_carry ((ix86_binary_operator_ok (PLUS, DImode, operands)) && (TARGET_64BIT))
#define HAVE_subdi3_carry ((ix86_binary_operator_ok (MINUS, DImode, operands)) && (TARGET_64BIT))
#define HAVE_addxf3 (TARGET_80387)
#define HAVE_subxf3 (TARGET_80387)
#define HAVE_addsf3 ((TARGET_80387 && X87_ENABLE_ARITH (SFmode)) \
    || (SSE_FLOAT_MODE_P (SFmode) && TARGET_SSE_MATH))
#define HAVE_subsf3 ((TARGET_80387 && X87_ENABLE_ARITH (SFmode)) \
    || (SSE_FLOAT_MODE_P (SFmode) && TARGET_SSE_MATH))
#define HAVE_adddf3 ((TARGET_80387 && X87_ENABLE_ARITH (DFmode)) \
    || (SSE_FLOAT_MODE_P (DFmode) && TARGET_SSE_MATH))
#define HAVE_subdf3 ((TARGET_80387 && X87_ENABLE_ARITH (DFmode)) \
    || (SSE_FLOAT_MODE_P (DFmode) && TARGET_SSE_MATH))
#define HAVE_mulhi3 (TARGET_HIMODE_MATH)
#define HAVE_mulsi3 1
#define HAVE_muldi3 (TARGET_64BIT)
#define HAVE_mulqi3 (TARGET_QIMODE_MATH)
#define HAVE_mulsidi3 (!TARGET_64BIT)
#define HAVE_umulsidi3 (!TARGET_64BIT)
#define HAVE_mulditi3 (TARGET_64BIT)
#define HAVE_umulditi3 (TARGET_64BIT)
#define HAVE_mulqihi3 (TARGET_QIMODE_MATH)
#define HAVE_umulqihi3 (TARGET_QIMODE_MATH)
#define HAVE_smulsi3_highpart 1
#define HAVE_umulsi3_highpart 1
#define HAVE_smuldi3_highpart (TARGET_64BIT)
#define HAVE_umuldi3_highpart (TARGET_64BIT)
#define HAVE_mulxf3 (TARGET_80387)
#define HAVE_mulsf3 ((TARGET_80387 && X87_ENABLE_ARITH (SFmode)) \
    || (SSE_FLOAT_MODE_P (SFmode) && TARGET_SSE_MATH))
#define HAVE_muldf3 ((TARGET_80387 && X87_ENABLE_ARITH (DFmode)) \
    || (SSE_FLOAT_MODE_P (DFmode) && TARGET_SSE_MATH))
#define HAVE_divxf3 (TARGET_80387)
#define HAVE_divdf3 ((TARGET_80387 && X87_ENABLE_ARITH (DFmode)) \
    || (TARGET_SSE2 && TARGET_SSE_MATH))
#define HAVE_divsf3 ((TARGET_80387 && X87_ENABLE_ARITH (SFmode)) \
    || TARGET_SSE_MATH)
#define HAVE_divmodhi4 (TARGET_HIMODE_MATH)
#define HAVE_divmodsi4 1
#define HAVE_divmoddi4 (TARGET_64BIT)
#define HAVE_divmodqi4 (TARGET_QIMODE_MATH)
#define HAVE_udivmodhi4 (TARGET_HIMODE_MATH)
#define HAVE_udivmodsi4 1
#define HAVE_udivmoddi4 (TARGET_64BIT)
#define HAVE_udivmodqi4 (TARGET_QIMODE_MATH)
#define HAVE_testsi_ccno_1 1
#define HAVE_testqi_ccz_1 1
#define HAVE_testdi_ccno_1 (TARGET_64BIT && !(MEM_P (operands[0]) && MEM_P (operands[1])))
#define HAVE_testqi_ext_ccno_0 1
#define HAVE_andqi3 (TARGET_QIMODE_MATH)
#define HAVE_andhi3 (TARGET_HIMODE_MATH)
#define HAVE_andsi3 1
#define HAVE_anddi3 (TARGET_64BIT)
#define HAVE_iorqi3 (TARGET_QIMODE_MATH)
#define HAVE_xorqi3 (TARGET_QIMODE_MATH)
#define HAVE_iorhi3 (TARGET_HIMODE_MATH)
#define HAVE_xorhi3 (TARGET_HIMODE_MATH)
#define HAVE_iorsi3 1
#define HAVE_xorsi3 1
#define HAVE_iordi3 (TARGET_64BIT)
#define HAVE_xordi3 (TARGET_64BIT)
#define HAVE_xorqi_cc_ext_1 1
#define HAVE_negqi2 (TARGET_QIMODE_MATH)
#define HAVE_neghi2 (TARGET_HIMODE_MATH)
#define HAVE_negsi2 1
#define HAVE_negdi2 1
#define HAVE_negti2 (TARGET_64BIT)
#define HAVE_abssf2 (TARGET_80387 || (SSE_FLOAT_MODE_P (SFmode) && TARGET_SSE_MATH))
#define HAVE_negsf2 (TARGET_80387 || (SSE_FLOAT_MODE_P (SFmode) && TARGET_SSE_MATH))
#define HAVE_absdf2 (TARGET_80387 || (SSE_FLOAT_MODE_P (DFmode) && TARGET_SSE_MATH))
#define HAVE_negdf2 (TARGET_80387 || (SSE_FLOAT_MODE_P (DFmode) && TARGET_SSE_MATH))
#define HAVE_absxf2 (TARGET_80387 || (SSE_FLOAT_MODE_P (XFmode) && TARGET_SSE_MATH))
#define HAVE_negxf2 (TARGET_80387 || (SSE_FLOAT_MODE_P (XFmode) && TARGET_SSE_MATH))
#define HAVE_abstf2 (TARGET_SSE2)
#define HAVE_negtf2 (TARGET_SSE2)
#define HAVE_copysignsf3 ((SSE_FLOAT_MODE_P (SFmode) && TARGET_SSE_MATH) \
   || (TARGET_SSE2 && (SFmode == TFmode)))
#define HAVE_copysigndf3 ((SSE_FLOAT_MODE_P (DFmode) && TARGET_SSE_MATH) \
   || (TARGET_SSE2 && (DFmode == TFmode)))
#define HAVE_copysigntf3 ((SSE_FLOAT_MODE_P (TFmode) && TARGET_SSE_MATH) \
   || (TARGET_SSE2 && (TFmode == TFmode)))
#define HAVE_one_cmplqi2 (TARGET_QIMODE_MATH)
#define HAVE_one_cmplhi2 (TARGET_HIMODE_MATH)
#define HAVE_one_cmplsi2 1
#define HAVE_one_cmpldi2 (TARGET_64BIT)
#define HAVE_ashlqi3 (TARGET_QIMODE_MATH)
#define HAVE_ashlhi3 (TARGET_HIMODE_MATH)
#define HAVE_ashlsi3 1
#define HAVE_ashldi3 1
#define HAVE_ashlti3 (TARGET_64BIT)
#define HAVE_x86_shiftsi_adj_1 (TARGET_CMOVE)
#define HAVE_x86_shiftdi_adj_1 ((TARGET_CMOVE) && (TARGET_64BIT))
#define HAVE_x86_shiftsi_adj_2 1
#define HAVE_x86_shiftdi_adj_2 (TARGET_64BIT)
#define HAVE_lshrqi3 (TARGET_QIMODE_MATH)
#define HAVE_ashrqi3 (TARGET_QIMODE_MATH)
#define HAVE_lshrhi3 (TARGET_HIMODE_MATH)
#define HAVE_ashrhi3 (TARGET_HIMODE_MATH)
#define HAVE_lshrsi3 1
#define HAVE_ashrsi3 1
#define HAVE_lshrdi3 1
#define HAVE_ashrdi3 1
#define HAVE_lshrti3 (TARGET_64BIT)
#define HAVE_ashrti3 (TARGET_64BIT)
#define HAVE_x86_shiftsi_adj_3 1
#define HAVE_x86_shiftdi_adj_3 (TARGET_64BIT)
#define HAVE_rotlti3 (TARGET_64BIT)
#define HAVE_rotrti3 (TARGET_64BIT)
#define HAVE_rotldi3 1
#define HAVE_rotrdi3 1
#define HAVE_rotlqi3 (TARGET_QIMODE_MATH)
#define HAVE_rotrqi3 (TARGET_QIMODE_MATH)
#define HAVE_rotlhi3 (TARGET_HIMODE_MATH)
#define HAVE_rotrhi3 (TARGET_HIMODE_MATH)
#define HAVE_rotlsi3 1
#define HAVE_rotrsi3 1
#define HAVE_extv 1
#define HAVE_extzv 1
#define HAVE_insv 1
#define HAVE_indirect_jump 1
#define HAVE_tablejump 1
#define HAVE_call 1
#define HAVE_sibcall 1
#define HAVE_call_pop (!TARGET_64BIT)
#define HAVE_call_value 1
#define HAVE_sibcall_value 1
#define HAVE_call_value_pop (!TARGET_64BIT)
#define HAVE_untyped_call 1
#define HAVE_memory_blockage 1
#define HAVE_return (ix86_can_use_return_insn_p ())
#define HAVE_simple_return 1
#define HAVE_prologue 1
#define HAVE_epilogue 1
#define HAVE_sibcall_epilogue 1
#define HAVE_eh_return 1
#define HAVE_split_stack_prologue 1
#define HAVE_split_stack_space_check 1
#define HAVE_ffssi2 1
#define HAVE_ffsdi2 (TARGET_64BIT)
#define HAVE_clzhi2 1
#define HAVE_clzsi2 1
#define HAVE_clzdi2 (TARGET_64BIT)
#define HAVE_bswapsi2 1
#define HAVE_bswapdi2 (TARGET_64BIT)
#define HAVE_paritydi2 (! TARGET_POPCNT)
#define HAVE_paritysi2 (! TARGET_POPCNT)
#define HAVE_tls_global_dynamic_32 1
#define HAVE_tls_global_dynamic_64 1
#define HAVE_tls_local_dynamic_base_32 1
#define HAVE_tls_local_dynamic_base_64 1
#define HAVE_tls_dynamic_gnu2_32 (!TARGET_64BIT && TARGET_GNU2_TLS)
#define HAVE_tls_dynamic_gnu2_64 (TARGET_64BIT && TARGET_GNU2_TLS)
#define HAVE_rsqrtsf2 (TARGET_SSE_MATH)
#define HAVE_sqrtsf2 ((TARGET_USE_FANCY_MATH_387 && X87_ENABLE_ARITH (SFmode)) \
   || (SSE_FLOAT_MODE_P (SFmode) && TARGET_SSE_MATH))
#define HAVE_sqrtdf2 ((TARGET_USE_FANCY_MATH_387 && X87_ENABLE_ARITH (DFmode)) \
   || (SSE_FLOAT_MODE_P (DFmode) && TARGET_SSE_MATH))
#define HAVE_fmodxf3 (TARGET_USE_FANCY_MATH_387)
#define HAVE_fmodsf3 (TARGET_USE_FANCY_MATH_387)
#define HAVE_fmoddf3 (TARGET_USE_FANCY_MATH_387)
#define HAVE_remainderxf3 (TARGET_USE_FANCY_MATH_387)
#define HAVE_remaindersf3 (TARGET_USE_FANCY_MATH_387)
#define HAVE_remainderdf3 (TARGET_USE_FANCY_MATH_387)
#define HAVE_sincossf3 (TARGET_USE_FANCY_MATH_387 \
   && (!(SSE_FLOAT_MODE_P (SFmode) && TARGET_SSE_MATH) \
       || TARGET_MIX_SSE_I387) \
   && flag_unsafe_math_optimizations)
#define HAVE_sincosdf3 (TARGET_USE_FANCY_MATH_387 \
   && (!(SSE_FLOAT_MODE_P (DFmode) && TARGET_SSE_MATH) \
       || TARGET_MIX_SSE_I387) \
   && flag_unsafe_math_optimizations)
#define HAVE_tanxf2 (TARGET_USE_FANCY_MATH_387 \
   && flag_unsafe_math_optimizations)
#define HAVE_tansf2 (TARGET_USE_FANCY_MATH_387 \
   && (!(SSE_FLOAT_MODE_P (SFmode) && TARGET_SSE_MATH) \
       || TARGET_MIX_SSE_I387) \
   && flag_unsafe_math_optimizations)
#define HAVE_tandf2 (TARGET_USE_FANCY_MATH_387 \
   && (!(SSE_FLOAT_MODE_P (DFmode) && TARGET_SSE_MATH) \
       || TARGET_MIX_SSE_I387) \
   && flag_unsafe_math_optimizations)
#define HAVE_atan2xf3 (TARGET_USE_FANCY_MATH_387 \
   && flag_unsafe_math_optimizations)
#define HAVE_atan2sf3 (TARGET_USE_FANCY_MATH_387 \
   && (!(SSE_FLOAT_MODE_P (SFmode) && TARGET_SSE_MATH) \
       || TARGET_MIX_SSE_I387) \
   && flag_unsafe_math_optimizations)
#define HAVE_atan2df3 (TARGET_USE_FANCY_MATH_387 \
   && (!(SSE_FLOAT_MODE_P (DFmode) && TARGET_SSE_MATH) \
       || TARGET_MIX_SSE_I387) \
   && flag_unsafe_math_optimizations)
#define HAVE_atanxf2 (TARGET_USE_FANCY_MATH_387 \
   && flag_unsafe_math_optimizations)
#define HAVE_atansf2 (TARGET_USE_FANCY_MATH_387 \
   && (!(SSE_FLOAT_MODE_P (SFmode) && TARGET_SSE_MATH) \
       || TARGET_MIX_SSE_I387) \
   && flag_unsafe_math_optimizations)
#define HAVE_atandf2 (TARGET_USE_FANCY_MATH_387 \
   && (!(SSE_FLOAT_MODE_P (DFmode) && TARGET_SSE_MATH) \
       || TARGET_MIX_SSE_I387) \
   && flag_unsafe_math_optimizations)
#define HAVE_asinxf2 (TARGET_USE_FANCY_MATH_387 \
   && flag_unsafe_math_optimizations)
#define HAVE_asinsf2 (TARGET_USE_FANCY_MATH_387 \
   && (!(SSE_FLOAT_MODE_P (SFmode) && TARGET_SSE_MATH) \
       || TARGET_MIX_SSE_I387) \
   && flag_unsafe_math_optimizations)
#define HAVE_asindf2 (TARGET_USE_FANCY_MATH_387 \
   && (!(SSE_FLOAT_MODE_P (DFmode) && TARGET_SSE_MATH) \
       || TARGET_MIX_SSE_I387) \
   && flag_unsafe_math_optimizations)
#define HAVE_acosxf2 (TARGET_USE_FANCY_MATH_387 \
   && flag_unsafe_math_optimizations)
#define HAVE_acossf2 (TARGET_USE_FANCY_MATH_387 \
   && (!(SSE_FLOAT_MODE_P (SFmode) && TARGET_SSE_MATH) \
       || TARGET_MIX_SSE_I387) \
   && flag_unsafe_math_optimizations)
#define HAVE_acosdf2 (TARGET_USE_FANCY_MATH_387 \
   && (!(SSE_FLOAT_MODE_P (DFmode) && TARGET_SSE_MATH) \
       || TARGET_MIX_SSE_I387) \
   && flag_unsafe_math_optimizations)
#define HAVE_logxf2 (TARGET_USE_FANCY_MATH_387 \
   && flag_unsafe_math_optimizations)
#define HAVE_logsf2 (TARGET_USE_FANCY_MATH_387 \
   && (!(SSE_FLOAT_MODE_P (SFmode) && TARGET_SSE_MATH) \
       || TARGET_MIX_SSE_I387) \
   && flag_unsafe_math_optimizations)
#define HAVE_logdf2 (TARGET_USE_FANCY_MATH_387 \
   && (!(SSE_FLOAT_MODE_P (DFmode) && TARGET_SSE_MATH) \
       || TARGET_MIX_SSE_I387) \
   && flag_unsafe_math_optimizations)
#define HAVE_log10xf2 (TARGET_USE_FANCY_MATH_387 \
   && flag_unsafe_math_optimizations)
#define HAVE_log10sf2 (TARGET_USE_FANCY_MATH_387 \
   && (!(SSE_FLOAT_MODE_P (SFmode) && TARGET_SSE_MATH) \
       || TARGET_MIX_SSE_I387) \
   && flag_unsafe_math_optimizations)
#define HAVE_log10df2 (TARGET_USE_FANCY_MATH_387 \
   && (!(SSE_FLOAT_MODE_P (DFmode) && TARGET_SSE_MATH) \
       || TARGET_MIX_SSE_I387) \
   && flag_unsafe_math_optimizations)
#define HAVE_log2xf2 (TARGET_USE_FANCY_MATH_387 \
   && flag_unsafe_math_optimizations)
#define HAVE_log2sf2 (TARGET_USE_FANCY_MATH_387 \
   && (!(SSE_FLOAT_MODE_P (SFmode) && TARGET_SSE_MATH) \
       || TARGET_MIX_SSE_I387) \
   && flag_unsafe_math_optimizations)
#define HAVE_log2df2 (TARGET_USE_FANCY_MATH_387 \
   && (!(SSE_FLOAT_MODE_P (DFmode) && TARGET_SSE_MATH) \
       || TARGET_MIX_SSE_I387) \
   && flag_unsafe_math_optimizations)
#define HAVE_log1pxf2 (TARGET_USE_FANCY_MATH_387 \
   && flag_unsafe_math_optimizations)
#define HAVE_log1psf2 (TARGET_USE_FANCY_MATH_387 \
   && (!(SSE_FLOAT_MODE_P (SFmode) && TARGET_SSE_MATH) \
       || TARGET_MIX_SSE_I387) \
   && flag_unsafe_math_optimizations)
#define HAVE_log1pdf2 (TARGET_USE_FANCY_MATH_387 \
   && (!(SSE_FLOAT_MODE_P (DFmode) && TARGET_SSE_MATH) \
       || TARGET_MIX_SSE_I387) \
   && flag_unsafe_math_optimizations)
#define HAVE_logbxf2 (TARGET_USE_FANCY_MATH_387 \
   && flag_unsafe_math_optimizations)
#define HAVE_logbsf2 (TARGET_USE_FANCY_MATH_387 \
   && (!(SSE_FLOAT_MODE_P (SFmode) && TARGET_SSE_MATH) \
       || TARGET_MIX_SSE_I387) \
   && flag_unsafe_math_optimizations)
#define HAVE_logbdf2 (TARGET_USE_FANCY_MATH_387 \
   && (!(SSE_FLOAT_MODE_P (DFmode) && TARGET_SSE_MATH) \
       || TARGET_MIX_SSE_I387) \
   && flag_unsafe_math_optimizations)
#define HAVE_ilogbxf2 (TARGET_USE_FANCY_MATH_387 \
   && flag_unsafe_math_optimizations)
#define HAVE_ilogbsf2 (TARGET_USE_FANCY_MATH_387 \
   && (!(SSE_FLOAT_MODE_P (SFmode) && TARGET_SSE_MATH) \
       || TARGET_MIX_SSE_I387) \
   && flag_unsafe_math_optimizations)
#define HAVE_ilogbdf2 (TARGET_USE_FANCY_MATH_387 \
   && (!(SSE_FLOAT_MODE_P (DFmode) && TARGET_SSE_MATH) \
       || TARGET_MIX_SSE_I387) \
   && flag_unsafe_math_optimizations)
#define HAVE_expNcorexf3 (TARGET_USE_FANCY_MATH_387 \
   && flag_unsafe_math_optimizations)
#define HAVE_expxf2 (TARGET_USE_FANCY_MATH_387 \
   && flag_unsafe_math_optimizations)
#define HAVE_expsf2 (TARGET_USE_FANCY_MATH_387 \
   && (!(SSE_FLOAT_MODE_P (SFmode) && TARGET_SSE_MATH) \
       || TARGET_MIX_SSE_I387) \
   && flag_unsafe_math_optimizations)
#define HAVE_expdf2 (TARGET_USE_FANCY_MATH_387 \
   && (!(SSE_FLOAT_MODE_P (DFmode) && TARGET_SSE_MATH) \
       || TARGET_MIX_SSE_I387) \
   && flag_unsafe_math_optimizations)
#define HAVE_exp10xf2 (TARGET_USE_FANCY_MATH_387 \
   && flag_unsafe_math_optimizations)
#define HAVE_exp10sf2 (TARGET_USE_FANCY_MATH_387 \
   && (!(SSE_FLOAT_MODE_P (SFmode) && TARGET_SSE_MATH) \
       || TARGET_MIX_SSE_I387) \
   && flag_unsafe_math_optimizations)
#define HAVE_exp10df2 (TARGET_USE_FANCY_MATH_387 \
   && (!(SSE_FLOAT_MODE_P (DFmode) && TARGET_SSE_MATH) \
       || TARGET_MIX_SSE_I387) \
   && flag_unsafe_math_optimizations)
#define HAVE_exp2xf2 (TARGET_USE_FANCY_MATH_387 \
   && flag_unsafe_math_optimizations)
#define HAVE_exp2sf2 (TARGET_USE_FANCY_MATH_387 \
   && (!(SSE_FLOAT_MODE_P (SFmode) && TARGET_SSE_MATH) \
       || TARGET_MIX_SSE_I387) \
   && flag_unsafe_math_optimizations)
#define HAVE_exp2df2 (TARGET_USE_FANCY_MATH_387 \
   && (!(SSE_FLOAT_MODE_P (DFmode) && TARGET_SSE_MATH) \
       || TARGET_MIX_SSE_I387) \
   && flag_unsafe_math_optimizations)
#define HAVE_expm1xf2 (TARGET_USE_FANCY_MATH_387 \
   && flag_unsafe_math_optimizations)
#define HAVE_expm1sf2 (TARGET_USE_FANCY_MATH_387 \
   && (!(SSE_FLOAT_MODE_P (SFmode) && TARGET_SSE_MATH) \
       || TARGET_MIX_SSE_I387) \
   && flag_unsafe_math_optimizations)
#define HAVE_expm1df2 (TARGET_USE_FANCY_MATH_387 \
   && (!(SSE_FLOAT_MODE_P (DFmode) && TARGET_SSE_MATH) \
       || TARGET_MIX_SSE_I387) \
   && flag_unsafe_math_optimizations)
#define HAVE_ldexpxf3 (TARGET_USE_FANCY_MATH_387 \
   && flag_unsafe_math_optimizations)
#define HAVE_ldexpsf3 (TARGET_USE_FANCY_MATH_387 \
   && (!(SSE_FLOAT_MODE_P (SFmode) && TARGET_SSE_MATH) \
       || TARGET_MIX_SSE_I387) \
   && flag_unsafe_math_optimizations)
#define HAVE_ldexpdf3 (TARGET_USE_FANCY_MATH_387 \
   && (!(SSE_FLOAT_MODE_P (DFmode) && TARGET_SSE_MATH) \
       || TARGET_MIX_SSE_I387) \
   && flag_unsafe_math_optimizations)
#define HAVE_scalbxf3 (TARGET_USE_FANCY_MATH_387 \
   && flag_unsafe_math_optimizations)
#define HAVE_scalbsf3 (TARGET_USE_FANCY_MATH_387 \
   && (!(SSE_FLOAT_MODE_P (SFmode) && TARGET_SSE_MATH) \
       || TARGET_MIX_SSE_I387) \
   && flag_unsafe_math_optimizations)
#define HAVE_scalbdf3 (TARGET_USE_FANCY_MATH_387 \
   && (!(SSE_FLOAT_MODE_P (DFmode) && TARGET_SSE_MATH) \
       || TARGET_MIX_SSE_I387) \
   && flag_unsafe_math_optimizations)
#define HAVE_significandxf2 (TARGET_USE_FANCY_MATH_387 \
   && flag_unsafe_math_optimizations)
#define HAVE_significandsf2 (TARGET_USE_FANCY_MATH_387 \
   && (!(SSE_FLOAT_MODE_P (SFmode) && TARGET_SSE_MATH) \
       || TARGET_MIX_SSE_I387) \
   && flag_unsafe_math_optimizations)
#define HAVE_significanddf2 (TARGET_USE_FANCY_MATH_387 \
   && (!(SSE_FLOAT_MODE_P (DFmode) && TARGET_SSE_MATH) \
       || TARGET_MIX_SSE_I387) \
   && flag_unsafe_math_optimizations)
#define HAVE_rintsf2 ((TARGET_USE_FANCY_MATH_387 \
    && (!(SSE_FLOAT_MODE_P (SFmode) && TARGET_SSE_MATH) \
	|| TARGET_MIX_SSE_I387) \
    && flag_unsafe_math_optimizations) \
   || (SSE_FLOAT_MODE_P (SFmode) && TARGET_SSE_MATH \
       && !flag_trapping_math))
#define HAVE_rintdf2 ((TARGET_USE_FANCY_MATH_387 \
    && (!(SSE_FLOAT_MODE_P (DFmode) && TARGET_SSE_MATH) \
	|| TARGET_MIX_SSE_I387) \
    && flag_unsafe_math_optimizations) \
   || (SSE_FLOAT_MODE_P (DFmode) && TARGET_SSE_MATH \
       && !flag_trapping_math))
#define HAVE_roundsf2 ((TARGET_USE_FANCY_MATH_387 \
    && (!(SSE_FLOAT_MODE_P (SFmode) && TARGET_SSE_MATH) \
	|| TARGET_MIX_SSE_I387) \
    && flag_unsafe_math_optimizations) \
   || (SSE_FLOAT_MODE_P (SFmode) && TARGET_SSE_MATH \
       && !flag_trapping_math && !flag_rounding_math))
#define HAVE_rounddf2 ((TARGET_USE_FANCY_MATH_387 \
    && (!(SSE_FLOAT_MODE_P (DFmode) && TARGET_SSE_MATH) \
	|| TARGET_MIX_SSE_I387) \
    && flag_unsafe_math_optimizations) \
   || (SSE_FLOAT_MODE_P (DFmode) && TARGET_SSE_MATH \
       && !flag_trapping_math && !flag_rounding_math))
#define HAVE_roundxf2 ((TARGET_USE_FANCY_MATH_387 \
    && (!(SSE_FLOAT_MODE_P (XFmode) && TARGET_SSE_MATH) \
	|| TARGET_MIX_SSE_I387) \
    && flag_unsafe_math_optimizations) \
   || (SSE_FLOAT_MODE_P (XFmode) && TARGET_SSE_MATH \
       && !flag_trapping_math && !flag_rounding_math))
#define HAVE_lrintxfhi2 (TARGET_USE_FANCY_MATH_387)
#define HAVE_lrintxfsi2 (TARGET_USE_FANCY_MATH_387)
#define HAVE_lrintxfdi2 (TARGET_USE_FANCY_MATH_387)
#define HAVE_lrintsfsi2 (SSE_FLOAT_MODE_P (SFmode) && TARGET_SSE_MATH \
   && ((SImode != DImode) || TARGET_64BIT))
#define HAVE_lrintdfsi2 (SSE_FLOAT_MODE_P (DFmode) && TARGET_SSE_MATH \
   && ((SImode != DImode) || TARGET_64BIT))
#define HAVE_lrintsfdi2 (SSE_FLOAT_MODE_P (SFmode) && TARGET_SSE_MATH \
   && ((DImode != DImode) || TARGET_64BIT))
#define HAVE_lrintdfdi2 (SSE_FLOAT_MODE_P (DFmode) && TARGET_SSE_MATH \
   && ((DImode != DImode) || TARGET_64BIT))
#define HAVE_lroundsfhi2 ((TARGET_USE_FANCY_MATH_387 \
    && (!(SSE_FLOAT_MODE_P (SFmode) && TARGET_SSE_MATH) \
	|| TARGET_MIX_SSE_I387) \
    && flag_unsafe_math_optimizations) \
   || (SSE_FLOAT_MODE_P (SFmode) && TARGET_SSE_MATH \
       && HImode != HImode  \
       && ((HImode != DImode) || TARGET_64BIT) \
       && !flag_trapping_math && !flag_rounding_math))
#define HAVE_lrounddfhi2 ((TARGET_USE_FANCY_MATH_387 \
    && (!(SSE_FLOAT_MODE_P (DFmode) && TARGET_SSE_MATH) \
	|| TARGET_MIX_SSE_I387) \
    && flag_unsafe_math_optimizations) \
   || (SSE_FLOAT_MODE_P (DFmode) && TARGET_SSE_MATH \
       && HImode != HImode  \
       && ((HImode != DImode) || TARGET_64BIT) \
       && !flag_trapping_math && !flag_rounding_math))
#define HAVE_lroundxfhi2 ((TARGET_USE_FANCY_MATH_387 \
    && (!(SSE_FLOAT_MODE_P (XFmode) && TARGET_SSE_MATH) \
	|| TARGET_MIX_SSE_I387) \
    && flag_unsafe_math_optimizations) \
   || (SSE_FLOAT_MODE_P (XFmode) && TARGET_SSE_MATH \
       && HImode != HImode  \
       && ((HImode != DImode) || TARGET_64BIT) \
       && !flag_trapping_math && !flag_rounding_math))
#define HAVE_lroundsfsi2 ((TARGET_USE_FANCY_MATH_387 \
    && (!(SSE_FLOAT_MODE_P (SFmode) && TARGET_SSE_MATH) \
	|| TARGET_MIX_SSE_I387) \
    && flag_unsafe_math_optimizations) \
   || (SSE_FLOAT_MODE_P (SFmode) && TARGET_SSE_MATH \
       && SImode != HImode  \
       && ((SImode != DImode) || TARGET_64BIT) \
       && !flag_trapping_math && !flag_rounding_math))
#define HAVE_lrounddfsi2 ((TARGET_USE_FANCY_MATH_387 \
    && (!(SSE_FLOAT_MODE_P (DFmode) && TARGET_SSE_MATH) \
	|| TARGET_MIX_SSE_I387) \
    && flag_unsafe_math_optimizations) \
   || (SSE_FLOAT_MODE_P (DFmode) && TARGET_SSE_MATH \
       && SImode != HImode  \
       && ((SImode != DImode) || TARGET_64BIT) \
       && !flag_trapping_math && !flag_rounding_math))
#define HAVE_lroundxfsi2 ((TARGET_USE_FANCY_MATH_387 \
    && (!(SSE_FLOAT_MODE_P (XFmode) && TARGET_SSE_MATH) \
	|| TARGET_MIX_SSE_I387) \
    && flag_unsafe_math_optimizations) \
   || (SSE_FLOAT_MODE_P (XFmode) && TARGET_SSE_MATH \
       && SImode != HImode  \
       && ((SImode != DImode) || TARGET_64BIT) \
       && !flag_trapping_math && !flag_rounding_math))
#define HAVE_lroundsfdi2 ((TARGET_USE_FANCY_MATH_387 \
    && (!(SSE_FLOAT_MODE_P (SFmode) && TARGET_SSE_MATH) \
	|| TARGET_MIX_SSE_I387) \
    && flag_unsafe_math_optimizations) \
   || (SSE_FLOAT_MODE_P (SFmode) && TARGET_SSE_MATH \
       && DImode != HImode  \
       && ((DImode != DImode) || TARGET_64BIT) \
       && !flag_trapping_math && !flag_rounding_math))
#define HAVE_lrounddfdi2 ((TARGET_USE_FANCY_MATH_387 \
    && (!(SSE_FLOAT_MODE_P (DFmode) && TARGET_SSE_MATH) \
	|| TARGET_MIX_SSE_I387) \
    && flag_unsafe_math_optimizations) \
   || (SSE_FLOAT_MODE_P (DFmode) && TARGET_SSE_MATH \
       && DImode != HImode  \
       && ((DImode != DImode) || TARGET_64BIT) \
       && !flag_trapping_math && !flag_rounding_math))
#define HAVE_lroundxfdi2 ((TARGET_USE_FANCY_MATH_387 \
    && (!(SSE_FLOAT_MODE_P (XFmode) && TARGET_SSE_MATH) \
	|| TARGET_MIX_SSE_I387) \
    && flag_unsafe_math_optimizations) \
   || (SSE_FLOAT_MODE_P (XFmode) && TARGET_SSE_MATH \
       && DImode != HImode  \
       && ((DImode != DImode) || TARGET_64BIT) \
       && !flag_trapping_math && !flag_rounding_math))
#define HAVE_floorxf2 (TARGET_USE_FANCY_MATH_387 \
   && flag_unsafe_math_optimizations)
#define HAVE_floorsf2 ((TARGET_USE_FANCY_MATH_387 \
    && (!(SSE_FLOAT_MODE_P (SFmode) && TARGET_SSE_MATH) \
	|| TARGET_MIX_SSE_I387) \
    && flag_unsafe_math_optimizations) \
   || (SSE_FLOAT_MODE_P (SFmode) && TARGET_SSE_MATH \
       && !flag_trapping_math))
#define HAVE_floordf2 ((TARGET_USE_FANCY_MATH_387 \
    && (!(SSE_FLOAT_MODE_P (DFmode) && TARGET_SSE_MATH) \
	|| TARGET_MIX_SSE_I387) \
    && flag_unsafe_math_optimizations) \
   || (SSE_FLOAT_MODE_P (DFmode) && TARGET_SSE_MATH \
       && !flag_trapping_math))
#define HAVE_lfloorxfhi2 (TARGET_USE_FANCY_MATH_387 \
   && (!TARGET_SSE_MATH || TARGET_MIX_SSE_I387) \
   && flag_unsafe_math_optimizations)
#define HAVE_lfloorxfsi2 (TARGET_USE_FANCY_MATH_387 \
   && (!TARGET_SSE_MATH || TARGET_MIX_SSE_I387) \
   && flag_unsafe_math_optimizations)
#define HAVE_lfloorxfdi2 (TARGET_USE_FANCY_MATH_387 \
   && (!TARGET_SSE_MATH || TARGET_MIX_SSE_I387) \
   && flag_unsafe_math_optimizations)
#define HAVE_lfloorsfsi2 (SSE_FLOAT_MODE_P (SFmode) && TARGET_SSE_MATH \
   && !flag_trapping_math)
#define HAVE_lfloorsfdi2 ((SSE_FLOAT_MODE_P (SFmode) && TARGET_SSE_MATH \
   && !flag_trapping_math) && (TARGET_64BIT))
#define HAVE_lfloordfsi2 (SSE_FLOAT_MODE_P (DFmode) && TARGET_SSE_MATH \
   && !flag_trapping_math)
#define HAVE_lfloordfdi2 ((SSE_FLOAT_MODE_P (DFmode) && TARGET_SSE_MATH \
   && !flag_trapping_math) && (TARGET_64BIT))
#define HAVE_ceilxf2 (TARGET_USE_FANCY_MATH_387 \
   && flag_unsafe_math_optimizations)
#define HAVE_ceilsf2 ((TARGET_USE_FANCY_MATH_387 \
    && (!(SSE_FLOAT_MODE_P (SFmode) && TARGET_SSE_MATH) \
	|| TARGET_MIX_SSE_I387) \
    && flag_unsafe_math_optimizations) \
   || (SSE_FLOAT_MODE_P (SFmode) && TARGET_SSE_MATH \
       && !flag_trapping_math))
#define HAVE_ceildf2 ((TARGET_USE_FANCY_MATH_387 \
    && (!(SSE_FLOAT_MODE_P (DFmode) && TARGET_SSE_MATH) \
	|| TARGET_MIX_SSE_I387) \
    && flag_unsafe_math_optimizations) \
   || (SSE_FLOAT_MODE_P (DFmode) && TARGET_SSE_MATH \
       && !flag_trapping_math))
#define HAVE_lceilxfhi2 (TARGET_USE_FANCY_MATH_387 \
   && (!TARGET_SSE_MATH || TARGET_MIX_SSE_I387) \
   && flag_unsafe_math_optimizations)
#define HAVE_lceilxfsi2 (TARGET_USE_FANCY_MATH_387 \
   && (!TARGET_SSE_MATH || TARGET_MIX_SSE_I387) \
   && flag_unsafe_math_optimizations)
#define HAVE_lceilxfdi2 (TARGET_USE_FANCY_MATH_387 \
   && (!TARGET_SSE_MATH || TARGET_MIX_SSE_I387) \
   && flag_unsafe_math_optimizations)
#define HAVE_lceilsfsi2 (SSE_FLOAT_MODE_P (SFmode) && TARGET_SSE_MATH \
   && !flag_trapping_math)
#define HAVE_lceilsfdi2 ((SSE_FLOAT_MODE_P (SFmode) && TARGET_SSE_MATH \
   && !flag_trapping_math) && (TARGET_64BIT))
#define HAVE_lceildfsi2 (SSE_FLOAT_MODE_P (DFmode) && TARGET_SSE_MATH \
   && !flag_trapping_math)
#define HAVE_lceildfdi2 ((SSE_FLOAT_MODE_P (DFmode) && TARGET_SSE_MATH \
   && !flag_trapping_math) && (TARGET_64BIT))
#define HAVE_btruncxf2 (TARGET_USE_FANCY_MATH_387 \
   && flag_unsafe_math_optimizations)
#define HAVE_btruncsf2 ((TARGET_USE_FANCY_MATH_387 \
    && (!(SSE_FLOAT_MODE_P (SFmode) && TARGET_SSE_MATH) \
	|| TARGET_MIX_SSE_I387) \
    && flag_unsafe_math_optimizations) \
   || (SSE_FLOAT_MODE_P (SFmode) && TARGET_SSE_MATH \
       && !flag_trapping_math))
#define HAVE_btruncdf2 ((TARGET_USE_FANCY_MATH_387 \
    && (!(SSE_FLOAT_MODE_P (DFmode) && TARGET_SSE_MATH) \
	|| TARGET_MIX_SSE_I387) \
    && flag_unsafe_math_optimizations) \
   || (SSE_FLOAT_MODE_P (DFmode) && TARGET_SSE_MATH \
       && !flag_trapping_math))
#define HAVE_nearbyintxf2 (TARGET_USE_FANCY_MATH_387 \
   && flag_unsafe_math_optimizations)
#define HAVE_nearbyintsf2 (TARGET_USE_FANCY_MATH_387 \
   && (!(SSE_FLOAT_MODE_P (SFmode) && TARGET_SSE_MATH) \
       || TARGET_MIX_SSE_I387) \
   && flag_unsafe_math_optimizations)
#define HAVE_nearbyintdf2 (TARGET_USE_FANCY_MATH_387 \
   && (!(SSE_FLOAT_MODE_P (DFmode) && TARGET_SSE_MATH) \
       || TARGET_MIX_SSE_I387) \
   && flag_unsafe_math_optimizations)
#define HAVE_isinfxf2 (TARGET_USE_FANCY_MATH_387 \
   && TARGET_C99_FUNCTIONS)
#define HAVE_isinfsf2 (TARGET_USE_FANCY_MATH_387 \
   && TARGET_C99_FUNCTIONS \
   && !(SSE_FLOAT_MODE_P (SFmode) && TARGET_SSE_MATH))
#define HAVE_isinfdf2 (TARGET_USE_FANCY_MATH_387 \
   && TARGET_C99_FUNCTIONS \
   && !(SSE_FLOAT_MODE_P (DFmode) && TARGET_SSE_MATH))
#define HAVE_signbitxf2 (TARGET_USE_FANCY_MATH_387)
#define HAVE_signbitdf2 (TARGET_USE_FANCY_MATH_387 \
   || (SSE_FLOAT_MODE_P (DFmode) && TARGET_SSE_MATH))
#define HAVE_signbitsf2 (TARGET_USE_FANCY_MATH_387 \
   && !(SSE_FLOAT_MODE_P (SFmode) && TARGET_SSE_MATH))
#define HAVE_movmemsi 1
#define HAVE_movmemdi (TARGET_64BIT)
#define HAVE_strmov 1
#define HAVE_strmov_singleop 1
#define HAVE_rep_mov 1
#define HAVE_setmemsi 1
#define HAVE_setmemdi (TARGET_64BIT)
#define HAVE_strset 1
#define HAVE_strset_singleop 1
#define HAVE_rep_stos 1
#define HAVE_cmpstrnsi 1
#define HAVE_cmpintqi 1
#define HAVE_cmpstrnqi_nz_1 1
#define HAVE_cmpstrnqi_1 1
#define HAVE_strlensi (Pmode == SImode)
#define HAVE_strlendi (Pmode == DImode)
#define HAVE_strlenqi_1 1
#define HAVE_movqicc (TARGET_QIMODE_MATH)
#define HAVE_movhicc (TARGET_HIMODE_MATH)
#define HAVE_movsicc 1
#define HAVE_movdicc (TARGET_64BIT)
#define HAVE_x86_movsicc_0_m1 1
#define HAVE_x86_movdicc_0_m1 (TARGET_64BIT)
#define HAVE_movsfcc ((TARGET_80387 && TARGET_CMOVE) \
   || (SSE_FLOAT_MODE_P (SFmode) && TARGET_SSE_MATH))
#define HAVE_movdfcc ((TARGET_80387 && TARGET_CMOVE) \
   || (SSE_FLOAT_MODE_P (DFmode) && TARGET_SSE_MATH))
#define HAVE_movxfcc ((TARGET_80387 && TARGET_CMOVE) \
   || (SSE_FLOAT_MODE_P (XFmode) && TARGET_SSE_MATH))
#define HAVE_addqicc 1
#define HAVE_addhicc 1
#define HAVE_addsicc 1
#define HAVE_adddicc (TARGET_64BIT)
#define HAVE_allocate_stack (ix86_target_stack_probe ())
#define HAVE_probe_stack 1
#define HAVE_builtin_setjmp_receiver (!TARGET_64BIT && flag_pic)
#define HAVE_prefetch (TARGET_PREFETCH_SSE || TARGET_3DNOW)
#define HAVE_stack_protect_set (!TARGET_HAS_BIONIC)
#define HAVE_stack_protect_test (!TARGET_HAS_BIONIC)
#define HAVE_rdpmc 1
#define HAVE_rdtsc 1
#define HAVE_rdtscp 1
#define HAVE_lwp_llwpcb (TARGET_LWP)
#define HAVE_lwp_slwpcb (TARGET_LWP)
#define HAVE_lwp_lwpvalsi3 (TARGET_LWP)
#define HAVE_lwp_lwpvaldi3 ((TARGET_LWP) && (TARGET_64BIT))
#define HAVE_lwp_lwpinssi3 (TARGET_LWP)
#define HAVE_lwp_lwpinsdi3 ((TARGET_LWP) && (TARGET_64BIT))
#define HAVE_pause 1
#define HAVE_movv8qi (TARGET_MMX)
#define HAVE_movv4hi (TARGET_MMX)
#define HAVE_movv2si (TARGET_MMX)
#define HAVE_movv1di (TARGET_MMX)
#define HAVE_movv2sf (TARGET_MMX)
#define HAVE_pushv8qi1 (TARGET_MMX)
#define HAVE_pushv4hi1 (TARGET_MMX)
#define HAVE_pushv2si1 (TARGET_MMX)
#define HAVE_pushv1di1 (TARGET_MMX)
#define HAVE_pushv2sf1 (TARGET_MMX)
#define HAVE_movmisalignv8qi (TARGET_MMX)
#define HAVE_movmisalignv4hi (TARGET_MMX)
#define HAVE_movmisalignv2si (TARGET_MMX)
#define HAVE_movmisalignv1di (TARGET_MMX)
#define HAVE_movmisalignv2sf (TARGET_MMX)
#define HAVE_mmx_addv2sf3 (TARGET_3DNOW)
#define HAVE_mmx_subv2sf3 (TARGET_3DNOW)
#define HAVE_mmx_subrv2sf3 (TARGET_3DNOW)
#define HAVE_mmx_mulv2sf3 (TARGET_3DNOW)
#define HAVE_mmx_smaxv2sf3 (TARGET_3DNOW)
#define HAVE_mmx_sminv2sf3 (TARGET_3DNOW)
#define HAVE_mmx_eqv2sf3 (TARGET_3DNOW)
#define HAVE_vec_setv2sf (TARGET_MMX)
#define HAVE_vec_extractv2sf (TARGET_MMX)
#define HAVE_vec_initv2sf (TARGET_SSE)
#define HAVE_mmx_addv8qi3 (TARGET_MMX || (TARGET_SSE2 && V8QImode == V1DImode))
#define HAVE_mmx_subv8qi3 (TARGET_MMX || (TARGET_SSE2 && V8QImode == V1DImode))
#define HAVE_mmx_addv4hi3 (TARGET_MMX || (TARGET_SSE2 && V4HImode == V1DImode))
#define HAVE_mmx_subv4hi3 (TARGET_MMX || (TARGET_SSE2 && V4HImode == V1DImode))
#define HAVE_mmx_addv2si3 (TARGET_MMX || (TARGET_SSE2 && V2SImode == V1DImode))
#define HAVE_mmx_subv2si3 (TARGET_MMX || (TARGET_SSE2 && V2SImode == V1DImode))
#define HAVE_mmx_addv1di3 (TARGET_MMX || (TARGET_SSE2 && V1DImode == V1DImode))
#define HAVE_mmx_subv1di3 (TARGET_MMX || (TARGET_SSE2 && V1DImode == V1DImode))
#define HAVE_mmx_ssaddv8qi3 (TARGET_MMX)
#define HAVE_mmx_usaddv8qi3 (TARGET_MMX)
#define HAVE_mmx_sssubv8qi3 (TARGET_MMX)
#define HAVE_mmx_ussubv8qi3 (TARGET_MMX)
#define HAVE_mmx_ssaddv4hi3 (TARGET_MMX)
#define HAVE_mmx_usaddv4hi3 (TARGET_MMX)
#define HAVE_mmx_sssubv4hi3 (TARGET_MMX)
#define HAVE_mmx_ussubv4hi3 (TARGET_MMX)
#define HAVE_mmx_mulv4hi3 (TARGET_MMX)
#define HAVE_mmx_smulv4hi3_highpart (TARGET_MMX)
#define HAVE_mmx_umulv4hi3_highpart (TARGET_SSE || TARGET_3DNOW_A)
#define HAVE_mmx_pmaddwd (TARGET_MMX)
#define HAVE_mmx_pmulhrwv4hi3 (TARGET_3DNOW)
#define HAVE_sse2_umulv1siv1di3 (TARGET_SSE2)
#define HAVE_mmx_smaxv4hi3 (TARGET_SSE || TARGET_3DNOW_A)
#define HAVE_mmx_sminv4hi3 (TARGET_SSE || TARGET_3DNOW_A)
#define HAVE_mmx_umaxv8qi3 (TARGET_SSE || TARGET_3DNOW_A)
#define HAVE_mmx_uminv8qi3 (TARGET_SSE || TARGET_3DNOW_A)
#define HAVE_mmx_eqv8qi3 (TARGET_MMX)
#define HAVE_mmx_eqv4hi3 (TARGET_MMX)
#define HAVE_mmx_eqv2si3 (TARGET_MMX)
#define HAVE_mmx_andv8qi3 (TARGET_MMX)
#define HAVE_mmx_iorv8qi3 (TARGET_MMX)
#define HAVE_mmx_xorv8qi3 (TARGET_MMX)
#define HAVE_mmx_andv4hi3 (TARGET_MMX)
#define HAVE_mmx_iorv4hi3 (TARGET_MMX)
#define HAVE_mmx_xorv4hi3 (TARGET_MMX)
#define HAVE_mmx_andv2si3 (TARGET_MMX)
#define HAVE_mmx_iorv2si3 (TARGET_MMX)
#define HAVE_mmx_xorv2si3 (TARGET_MMX)
#define HAVE_mmx_pinsrw (TARGET_SSE || TARGET_3DNOW_A)
#define HAVE_mmx_pshufw (TARGET_SSE || TARGET_3DNOW_A)
#define HAVE_vec_setv2si (TARGET_MMX)
#define HAVE_vec_extractv2si (TARGET_MMX)
#define HAVE_vec_initv2si (TARGET_SSE)
#define HAVE_vec_setv4hi (TARGET_MMX)
#define HAVE_vec_extractv4hi (TARGET_MMX)
#define HAVE_vec_initv4hi (TARGET_SSE)
#define HAVE_vec_setv8qi (TARGET_MMX)
#define HAVE_vec_extractv8qi (TARGET_MMX)
#define HAVE_vec_initv8qi (TARGET_SSE)
#define HAVE_mmx_uavgv8qi3 (TARGET_SSE || TARGET_3DNOW)
#define HAVE_mmx_uavgv4hi3 (TARGET_SSE || TARGET_3DNOW_A)
#define HAVE_mmx_maskmovq (TARGET_SSE || TARGET_3DNOW_A)
#define HAVE_mmx_emms (TARGET_MMX)
#define HAVE_mmx_femms (TARGET_3DNOW)
#define HAVE_movv32qi ((TARGET_SSE) && (TARGET_AVX))
#define HAVE_movv16qi (TARGET_SSE)
#define HAVE_movv16hi ((TARGET_SSE) && (TARGET_AVX))
#define HAVE_movv8hi (TARGET_SSE)
#define HAVE_movv8si ((TARGET_SSE) && (TARGET_AVX))
#define HAVE_movv4si (TARGET_SSE)
#define HAVE_movv4di ((TARGET_SSE) && (TARGET_AVX))
#define HAVE_movv2di (TARGET_SSE)
#define HAVE_movv2ti ((TARGET_SSE) && (TARGET_AVX))
#define HAVE_movv1ti (TARGET_SSE)
#define HAVE_movv8sf ((TARGET_SSE) && (TARGET_AVX))
#define HAVE_movv4sf (TARGET_SSE)
#define HAVE_movv4df ((TARGET_SSE) && (TARGET_AVX))
#define HAVE_movv2df (TARGET_SSE)
#define HAVE_pushv32qi1 ((TARGET_SSE) && (TARGET_AVX))
#define HAVE_pushv16qi1 (TARGET_SSE)
#define HAVE_pushv16hi1 ((TARGET_SSE) && (TARGET_AVX))
#define HAVE_pushv8hi1 (TARGET_SSE)
#define HAVE_pushv8si1 ((TARGET_SSE) && (TARGET_AVX))
#define HAVE_pushv4si1 (TARGET_SSE)
#define HAVE_pushv4di1 ((TARGET_SSE) && (TARGET_AVX))
#define HAVE_pushv2di1 (TARGET_SSE)
#define HAVE_pushv2ti1 ((TARGET_SSE) && (TARGET_AVX))
#define HAVE_pushv1ti1 (TARGET_SSE)
#define HAVE_pushv8sf1 ((TARGET_SSE) && (TARGET_AVX))
#define HAVE_pushv4sf1 (TARGET_SSE)
#define HAVE_pushv4df1 ((TARGET_SSE) && (TARGET_AVX))
#define HAVE_pushv2df1 (TARGET_SSE)
#define HAVE_movmisalignv32qi ((TARGET_SSE) && (TARGET_AVX))
#define HAVE_movmisalignv16qi (TARGET_SSE)
#define HAVE_movmisalignv16hi ((TARGET_SSE) && (TARGET_AVX))
#define HAVE_movmisalignv8hi (TARGET_SSE)
#define HAVE_movmisalignv8si ((TARGET_SSE) && (TARGET_AVX))
#define HAVE_movmisalignv4si (TARGET_SSE)
#define HAVE_movmisalignv4di ((TARGET_SSE) && (TARGET_AVX))
#define HAVE_movmisalignv2di (TARGET_SSE)
#define HAVE_movmisalignv2ti ((TARGET_SSE) && (TARGET_AVX))
#define HAVE_movmisalignv1ti (TARGET_SSE)
#define HAVE_movmisalignv8sf ((TARGET_SSE) && (TARGET_AVX))
#define HAVE_movmisalignv4sf (TARGET_SSE)
#define HAVE_movmisalignv4df ((TARGET_SSE) && (TARGET_AVX))
#define HAVE_movmisalignv2df (TARGET_SSE)
#define HAVE_storentdi ((TARGET_SSE) && (TARGET_SSE2 && TARGET_64BIT))
#define HAVE_storentsi ((TARGET_SSE) && (TARGET_SSE2))
#define HAVE_storentsf ((TARGET_SSE) && (TARGET_SSE4A))
#define HAVE_storentdf ((TARGET_SSE) && (TARGET_SSE4A))
#define HAVE_storentv4di ((TARGET_SSE) && (TARGET_AVX))
#define HAVE_storentv2di ((TARGET_SSE) && (TARGET_SSE2))
#define HAVE_storentv8sf ((TARGET_SSE) && (TARGET_AVX))
#define HAVE_storentv4sf (TARGET_SSE)
#define HAVE_storentv4df ((TARGET_SSE) && (TARGET_AVX))
#define HAVE_storentv2df ((TARGET_SSE) && (TARGET_SSE2))
#define HAVE_absv8sf2 ((TARGET_SSE) && (TARGET_AVX))
#define HAVE_negv8sf2 ((TARGET_SSE) && (TARGET_AVX))
#define HAVE_absv4sf2 (TARGET_SSE)
#define HAVE_negv4sf2 (TARGET_SSE)
#define HAVE_absv4df2 ((TARGET_SSE) && (TARGET_AVX))
#define HAVE_negv4df2 ((TARGET_SSE) && (TARGET_AVX))
#define HAVE_absv2df2 ((TARGET_SSE) && (TARGET_SSE2))
#define HAVE_negv2df2 ((TARGET_SSE) && (TARGET_SSE2))
#define HAVE_addv8sf3 ((TARGET_SSE) && (TARGET_AVX))
#define HAVE_subv8sf3 ((TARGET_SSE) && (TARGET_AVX))
#define HAVE_addv4sf3 (TARGET_SSE)
#define HAVE_subv4sf3 (TARGET_SSE)
#define HAVE_addv4df3 ((TARGET_SSE) && (TARGET_AVX))
#define HAVE_subv4df3 ((TARGET_SSE) && (TARGET_AVX))
#define HAVE_addv2df3 ((TARGET_SSE) && (TARGET_SSE2))
#define HAVE_subv2df3 ((TARGET_SSE) && (TARGET_SSE2))
#define HAVE_mulv8sf3 ((TARGET_SSE) && (TARGET_AVX))
#define HAVE_mulv4sf3 (TARGET_SSE)
#define HAVE_mulv4df3 ((TARGET_SSE) && (TARGET_AVX))
#define HAVE_mulv2df3 ((TARGET_SSE) && (TARGET_SSE2))
#define HAVE_divv4df3 ((TARGET_SSE2) && (TARGET_AVX))
#define HAVE_divv2df3 (TARGET_SSE2)
#define HAVE_divv8sf3 ((TARGET_SSE) && (TARGET_AVX))
#define HAVE_divv4sf3 (TARGET_SSE)
#define HAVE_sqrtv4df2 ((TARGET_SSE2) && (TARGET_AVX))
#define HAVE_sqrtv2df2 (TARGET_SSE2)
#define HAVE_sqrtv8sf2 ((TARGET_SSE) && (TARGET_AVX))
#define HAVE_sqrtv4sf2 (TARGET_SSE)
#define HAVE_rsqrtv8sf2 ((TARGET_SSE_MATH) && (TARGET_AVX))
#define HAVE_rsqrtv4sf2 (TARGET_SSE_MATH)
#define HAVE_smaxv8sf3 ((TARGET_SSE) && (TARGET_AVX))
#define HAVE_sminv8sf3 ((TARGET_SSE) && (TARGET_AVX))
#define HAVE_smaxv4sf3 (TARGET_SSE)
#define HAVE_sminv4sf3 (TARGET_SSE)
#define HAVE_smaxv4df3 ((TARGET_SSE) && (TARGET_AVX))
#define HAVE_sminv4df3 ((TARGET_SSE) && (TARGET_AVX))
#define HAVE_smaxv2df3 ((TARGET_SSE) && (TARGET_SSE2))
#define HAVE_sminv2df3 ((TARGET_SSE) && (TARGET_SSE2))
#define HAVE_reduc_splus_v4df (TARGET_AVX)
#define HAVE_reduc_splus_v2df (TARGET_SSE3)
#define HAVE_reduc_splus_v8sf (TARGET_AVX)
#define HAVE_reduc_splus_v4sf (TARGET_SSE)
#define HAVE_reduc_smax_v32qi (TARGET_AVX2)
#define HAVE_reduc_smin_v32qi (TARGET_AVX2)
#define HAVE_reduc_smax_v16hi (TARGET_AVX2)
#define HAVE_reduc_smin_v16hi (TARGET_AVX2)
#define HAVE_reduc_smax_v8si (TARGET_AVX2)
#define HAVE_reduc_smin_v8si (TARGET_AVX2)
#define HAVE_reduc_smax_v4di (TARGET_AVX2)
#define HAVE_reduc_smin_v4di (TARGET_AVX2)
#define HAVE_reduc_smax_v8sf (TARGET_AVX)
#define HAVE_reduc_smin_v8sf (TARGET_AVX)
#define HAVE_reduc_smax_v4df (TARGET_AVX)
#define HAVE_reduc_smin_v4df (TARGET_AVX)
#define HAVE_reduc_smax_v4sf (TARGET_SSE)
#define HAVE_reduc_smin_v4sf (TARGET_SSE)
#define HAVE_reduc_umax_v32qi (TARGET_AVX2)
#define HAVE_reduc_umin_v32qi (TARGET_AVX2)
#define HAVE_reduc_umax_v16hi (TARGET_AVX2)
#define HAVE_reduc_umin_v16hi (TARGET_AVX2)
#define HAVE_reduc_umax_v8si (TARGET_AVX2)
#define HAVE_reduc_umin_v8si (TARGET_AVX2)
#define HAVE_reduc_umax_v4di (TARGET_AVX2)
#define HAVE_reduc_umin_v4di (TARGET_AVX2)
#define HAVE_reduc_umin_v8hi (TARGET_SSE4_1)
#define HAVE_vcondv32qiv8sf (TARGET_AVX \
   && (GET_MODE_NUNITS (V32QImode) \
       == GET_MODE_NUNITS (V8SFmode)))
#define HAVE_vcondv16hiv8sf (TARGET_AVX \
   && (GET_MODE_NUNITS (V16HImode) \
       == GET_MODE_NUNITS (V8SFmode)))
#define HAVE_vcondv8siv8sf (TARGET_AVX \
   && (GET_MODE_NUNITS (V8SImode) \
       == GET_MODE_NUNITS (V8SFmode)))
#define HAVE_vcondv4div8sf (TARGET_AVX \
   && (GET_MODE_NUNITS (V4DImode) \
       == GET_MODE_NUNITS (V8SFmode)))
#define HAVE_vcondv8sfv8sf (TARGET_AVX \
   && (GET_MODE_NUNITS (V8SFmode) \
       == GET_MODE_NUNITS (V8SFmode)))
#define HAVE_vcondv4dfv8sf (TARGET_AVX \
   && (GET_MODE_NUNITS (V4DFmode) \
       == GET_MODE_NUNITS (V8SFmode)))
#define HAVE_vcondv32qiv4df (TARGET_AVX \
   && (GET_MODE_NUNITS (V32QImode) \
       == GET_MODE_NUNITS (V4DFmode)))
#define HAVE_vcondv16hiv4df (TARGET_AVX \
   && (GET_MODE_NUNITS (V16HImode) \
       == GET_MODE_NUNITS (V4DFmode)))
#define HAVE_vcondv8siv4df (TARGET_AVX \
   && (GET_MODE_NUNITS (V8SImode) \
       == GET_MODE_NUNITS (V4DFmode)))
#define HAVE_vcondv4div4df (TARGET_AVX \
   && (GET_MODE_NUNITS (V4DImode) \
       == GET_MODE_NUNITS (V4DFmode)))
#define HAVE_vcondv8sfv4df (TARGET_AVX \
   && (GET_MODE_NUNITS (V8SFmode) \
       == GET_MODE_NUNITS (V4DFmode)))
#define HAVE_vcondv4dfv4df (TARGET_AVX \
   && (GET_MODE_NUNITS (V4DFmode) \
       == GET_MODE_NUNITS (V4DFmode)))
#define HAVE_vcondv16qiv4sf (TARGET_SSE \
   && (GET_MODE_NUNITS (V16QImode) \
       == GET_MODE_NUNITS (V4SFmode)))
#define HAVE_vcondv8hiv4sf (TARGET_SSE \
   && (GET_MODE_NUNITS (V8HImode) \
       == GET_MODE_NUNITS (V4SFmode)))
#define HAVE_vcondv4siv4sf (TARGET_SSE \
   && (GET_MODE_NUNITS (V4SImode) \
       == GET_MODE_NUNITS (V4SFmode)))
#define HAVE_vcondv2div4sf (TARGET_SSE \
   && (GET_MODE_NUNITS (V2DImode) \
       == GET_MODE_NUNITS (V4SFmode)))
#define HAVE_vcondv4sfv4sf (TARGET_SSE \
   && (GET_MODE_NUNITS (V4SFmode) \
       == GET_MODE_NUNITS (V4SFmode)))
#define HAVE_vcondv2dfv4sf ((TARGET_SSE \
   && (GET_MODE_NUNITS (V2DFmode) \
       == GET_MODE_NUNITS (V4SFmode))) && (TARGET_SSE2))
#define HAVE_vcondv16qiv2df ((TARGET_SSE \
   && (GET_MODE_NUNITS (V16QImode) \
       == GET_MODE_NUNITS (V2DFmode))) && (TARGET_SSE2))
#define HAVE_vcondv8hiv2df ((TARGET_SSE \
   && (GET_MODE_NUNITS (V8HImode) \
       == GET_MODE_NUNITS (V2DFmode))) && (TARGET_SSE2))
#define HAVE_vcondv4siv2df ((TARGET_SSE \
   && (GET_MODE_NUNITS (V4SImode) \
       == GET_MODE_NUNITS (V2DFmode))) && (TARGET_SSE2))
#define HAVE_vcondv2div2df ((TARGET_SSE \
   && (GET_MODE_NUNITS (V2DImode) \
       == GET_MODE_NUNITS (V2DFmode))) && (TARGET_SSE2))
#define HAVE_vcondv4sfv2df ((TARGET_SSE \
   && (GET_MODE_NUNITS (V4SFmode) \
       == GET_MODE_NUNITS (V2DFmode))) && (TARGET_SSE2))
#define HAVE_vcondv2dfv2df (((TARGET_SSE \
   && (GET_MODE_NUNITS (V2DFmode) \
       == GET_MODE_NUNITS (V2DFmode))) && (TARGET_SSE2)) && (TARGET_SSE2))
#define HAVE_andv8sf3 ((TARGET_SSE) && (TARGET_AVX))
#define HAVE_iorv8sf3 ((TARGET_SSE) && (TARGET_AVX))
#define HAVE_xorv8sf3 ((TARGET_SSE) && (TARGET_AVX))
#define HAVE_andv4sf3 (TARGET_SSE)
#define HAVE_iorv4sf3 (TARGET_SSE)
#define HAVE_xorv4sf3 (TARGET_SSE)
#define HAVE_andv4df3 ((TARGET_SSE) && (TARGET_AVX))
#define HAVE_iorv4df3 ((TARGET_SSE) && (TARGET_AVX))
#define HAVE_xorv4df3 ((TARGET_SSE) && (TARGET_AVX))
#define HAVE_andv2df3 ((TARGET_SSE) && (TARGET_SSE2))
#define HAVE_iorv2df3 ((TARGET_SSE) && (TARGET_SSE2))
#define HAVE_xorv2df3 ((TARGET_SSE) && (TARGET_SSE2))
#define HAVE_copysignv8sf3 ((TARGET_SSE) && (TARGET_AVX))
#define HAVE_copysignv4sf3 (TARGET_SSE)
#define HAVE_copysignv4df3 ((TARGET_SSE) && (TARGET_AVX))
#define HAVE_copysignv2df3 ((TARGET_SSE) && (TARGET_SSE2))
#define HAVE_fmasf4 ((TARGET_FMA || TARGET_FMA4) && (TARGET_SSE_MATH))
#define HAVE_fmadf4 ((TARGET_FMA || TARGET_FMA4) && (TARGET_SSE_MATH))
#define HAVE_fmav4sf4 (TARGET_FMA || TARGET_FMA4)
#define HAVE_fmav2df4 (TARGET_FMA || TARGET_FMA4)
#define HAVE_fmav8sf4 (TARGET_FMA || TARGET_FMA4)
#define HAVE_fmav4df4 (TARGET_FMA || TARGET_FMA4)
#define HAVE_fmssf4 ((TARGET_FMA || TARGET_FMA4) && (TARGET_SSE_MATH))
#define HAVE_fmsdf4 ((TARGET_FMA || TARGET_FMA4) && (TARGET_SSE_MATH))
#define HAVE_fmsv4sf4 (TARGET_FMA || TARGET_FMA4)
#define HAVE_fmsv2df4 (TARGET_FMA || TARGET_FMA4)
#define HAVE_fmsv8sf4 (TARGET_FMA || TARGET_FMA4)
#define HAVE_fmsv4df4 (TARGET_FMA || TARGET_FMA4)
#define HAVE_fnmasf4 ((TARGET_FMA || TARGET_FMA4) && (TARGET_SSE_MATH))
#define HAVE_fnmadf4 ((TARGET_FMA || TARGET_FMA4) && (TARGET_SSE_MATH))
#define HAVE_fnmav4sf4 (TARGET_FMA || TARGET_FMA4)
#define HAVE_fnmav2df4 (TARGET_FMA || TARGET_FMA4)
#define HAVE_fnmav8sf4 (TARGET_FMA || TARGET_FMA4)
#define HAVE_fnmav4df4 (TARGET_FMA || TARGET_FMA4)
#define HAVE_fnmssf4 ((TARGET_FMA || TARGET_FMA4) && (TARGET_SSE_MATH))
#define HAVE_fnmsdf4 ((TARGET_FMA || TARGET_FMA4) && (TARGET_SSE_MATH))
#define HAVE_fnmsv4sf4 (TARGET_FMA || TARGET_FMA4)
#define HAVE_fnmsv2df4 (TARGET_FMA || TARGET_FMA4)
#define HAVE_fnmsv8sf4 (TARGET_FMA || TARGET_FMA4)
#define HAVE_fnmsv4df4 (TARGET_FMA || TARGET_FMA4)
#define HAVE_fma4i_fmadd_sf (TARGET_FMA || TARGET_FMA4)
#define HAVE_fma4i_fmadd_df (TARGET_FMA || TARGET_FMA4)
#define HAVE_fma4i_fmadd_v4sf (TARGET_FMA || TARGET_FMA4)
#define HAVE_fma4i_fmadd_v2df (TARGET_FMA || TARGET_FMA4)
#define HAVE_fma4i_fmadd_v8sf (TARGET_FMA || TARGET_FMA4)
#define HAVE_fma4i_fmadd_v4df (TARGET_FMA || TARGET_FMA4)
#define HAVE_fmaddsub_v8sf ((TARGET_FMA || TARGET_FMA4) && (TARGET_AVX))
#define HAVE_fmaddsub_v4sf (TARGET_FMA || TARGET_FMA4)
#define HAVE_fmaddsub_v4df ((TARGET_FMA || TARGET_FMA4) && (TARGET_AVX))
#define HAVE_fmaddsub_v2df ((TARGET_FMA || TARGET_FMA4) && (TARGET_SSE2))
#define HAVE_fmai_vmfmadd_v4sf (TARGET_FMA)
#define HAVE_fmai_vmfmadd_v2df ((TARGET_FMA) && (TARGET_SSE2))
#define HAVE_fma4i_vmfmadd_v4sf (TARGET_FMA4)
#define HAVE_fma4i_vmfmadd_v2df ((TARGET_FMA4) && (TARGET_SSE2))
#define HAVE_floatunsv8siv8sf2 ((TARGET_SSE2 && (V8SFmode == V4SFmode || TARGET_AVX2)) && (TARGET_AVX))
#define HAVE_floatunsv4siv4sf2 (TARGET_SSE2 && (V4SFmode == V4SFmode || TARGET_AVX2))
#define HAVE_fixuns_truncv8sfv8si2 ((TARGET_SSE2) && (TARGET_AVX))
#define HAVE_fixuns_truncv4sfv4si2 (TARGET_SSE2)
#define HAVE_avx_cvtpd2dq256_2 (TARGET_AVX)
#define HAVE_sse2_cvtpd2dq (TARGET_SSE2)
#define HAVE_avx_cvttpd2dq256_2 (TARGET_AVX)
#define HAVE_sse2_cvttpd2dq (TARGET_SSE2)
#define HAVE_sse2_cvtpd2ps (TARGET_SSE2)
#define HAVE_vec_unpacks_hi_v4sf (TARGET_SSE2)
#define HAVE_vec_unpacks_hi_v8sf (TARGET_AVX)
#define HAVE_vec_unpacks_lo_v4sf (TARGET_SSE2)
#define HAVE_vec_unpacks_lo_v8sf (TARGET_AVX)
#define HAVE_vec_unpacks_float_hi_v16hi ((TARGET_SSE2) && (TARGET_AVX2))
#define HAVE_vec_unpacks_float_hi_v8hi (TARGET_SSE2)
#define HAVE_vec_unpacks_float_lo_v16hi ((TARGET_SSE2) && (TARGET_AVX2))
#define HAVE_vec_unpacks_float_lo_v8hi (TARGET_SSE2)
#define HAVE_vec_unpacku_float_hi_v16hi ((TARGET_SSE2) && (TARGET_AVX2))
#define HAVE_vec_unpacku_float_hi_v8hi (TARGET_SSE2)
#define HAVE_vec_unpacku_float_lo_v16hi ((TARGET_SSE2) && (TARGET_AVX2))
#define HAVE_vec_unpacku_float_lo_v8hi (TARGET_SSE2)
#define HAVE_vec_unpacks_float_hi_v4si (TARGET_SSE2)
#define HAVE_vec_unpacks_float_lo_v4si (TARGET_SSE2)
#define HAVE_vec_unpacks_float_hi_v8si (TARGET_AVX)
#define HAVE_vec_unpacks_float_lo_v8si (TARGET_AVX)
#define HAVE_vec_unpacku_float_hi_v4si (TARGET_SSE2)
#define HAVE_vec_unpacku_float_lo_v4si (TARGET_SSE2)
#define HAVE_vec_unpacku_float_hi_v8si (TARGET_AVX)
#define HAVE_vec_unpacku_float_lo_v8si (TARGET_AVX)
#define HAVE_vec_pack_trunc_v4df (TARGET_AVX)
#define HAVE_vec_pack_trunc_v2df (TARGET_SSE2)
#define HAVE_vec_pack_sfix_trunc_v4df (TARGET_AVX)
#define HAVE_vec_pack_sfix_trunc_v2df (TARGET_SSE2)
#define HAVE_vec_pack_ufix_trunc_v4df ((TARGET_SSE2) && (TARGET_AVX))
#define HAVE_vec_pack_ufix_trunc_v2df (TARGET_SSE2)
#define HAVE_vec_pack_sfix_v4df (TARGET_AVX)
#define HAVE_vec_pack_sfix_v2df (TARGET_SSE2)
#define HAVE_sse_movhlps_exp (TARGET_SSE)
#define HAVE_sse_movlhps_exp (TARGET_SSE)
#define HAVE_vec_interleave_highv8sf (TARGET_AVX)
#define HAVE_vec_interleave_lowv8sf (TARGET_AVX)
#define HAVE_avx_shufps256 (TARGET_AVX)
#define HAVE_sse_shufps (TARGET_SSE)
#define HAVE_sse_loadhps_exp (TARGET_SSE)
#define HAVE_sse_loadlps_exp (TARGET_SSE)
#define HAVE_vec_initv16qi (TARGET_SSE)
#define HAVE_vec_initv8hi (TARGET_SSE)
#define HAVE_vec_initv4si (TARGET_SSE)
#define HAVE_vec_initv2di (TARGET_SSE)
#define HAVE_vec_initv4sf (TARGET_SSE)
#define HAVE_vec_initv2df ((TARGET_SSE) && (TARGET_SSE2))
#define HAVE_vec_setv32qi ((TARGET_SSE) && (TARGET_AVX))
#define HAVE_vec_setv16qi (TARGET_SSE)
#define HAVE_vec_setv16hi ((TARGET_SSE) && (TARGET_AVX))
#define HAVE_vec_setv8hi (TARGET_SSE)
#define HAVE_vec_setv8si ((TARGET_SSE) && (TARGET_AVX))
#define HAVE_vec_setv4si (TARGET_SSE)
#define HAVE_vec_setv4di ((TARGET_SSE) && (TARGET_AVX))
#define HAVE_vec_setv2di (TARGET_SSE)
#define HAVE_vec_setv8sf ((TARGET_SSE) && (TARGET_AVX))
#define HAVE_vec_setv4sf (TARGET_SSE)
#define HAVE_vec_setv4df ((TARGET_SSE) && (TARGET_AVX))
#define HAVE_vec_setv2df ((TARGET_SSE) && (TARGET_SSE2))
#define HAVE_avx_vextractf128v32qi (TARGET_AVX)
#define HAVE_avx_vextractf128v16hi (TARGET_AVX)
#define HAVE_avx_vextractf128v8si (TARGET_AVX)
#define HAVE_avx_vextractf128v4di (TARGET_AVX)
#define HAVE_avx_vextractf128v8sf (TARGET_AVX)
#define HAVE_avx_vextractf128v4df (TARGET_AVX)
#define HAVE_vec_extractv32qi ((TARGET_SSE) && (TARGET_AVX))
#define HAVE_vec_extractv16qi (TARGET_SSE)
#define HAVE_vec_extractv16hi ((TARGET_SSE) && (TARGET_AVX))
#define HAVE_vec_extractv8hi (TARGET_SSE)
#define HAVE_vec_extractv8si ((TARGET_SSE) && (TARGET_AVX))
#define HAVE_vec_extractv4si (TARGET_SSE)
#define HAVE_vec_extractv4di ((TARGET_SSE) && (TARGET_AVX))
#define HAVE_vec_extractv2di (TARGET_SSE)
#define HAVE_vec_extractv8sf ((TARGET_SSE) && (TARGET_AVX))
#define HAVE_vec_extractv4sf (TARGET_SSE)
#define HAVE_vec_extractv4df ((TARGET_SSE) && (TARGET_AVX))
#define HAVE_vec_extractv2df (TARGET_SSE)
#define HAVE_vec_interleave_highv4df (TARGET_AVX)
#define HAVE_vec_interleave_highv2df (TARGET_SSE2)
#define HAVE_avx_movddup256 (TARGET_AVX)
#define HAVE_avx_unpcklpd256 (TARGET_AVX)
#define HAVE_vec_interleave_lowv4df (TARGET_AVX)
#define HAVE_vec_interleave_lowv2df (TARGET_SSE2)
#define HAVE_avx_shufpd256 (TARGET_AVX)
#define HAVE_sse2_shufpd (TARGET_SSE2)
#define HAVE_sse2_loadhpd_exp (TARGET_SSE2)
#define HAVE_sse2_loadlpd_exp (TARGET_SSE2)
#define HAVE_negv32qi2 ((TARGET_SSE2) && (TARGET_AVX2))
#define HAVE_negv16qi2 (TARGET_SSE2)
#define HAVE_negv16hi2 ((TARGET_SSE2) && (TARGET_AVX2))
#define HAVE_negv8hi2 (TARGET_SSE2)
#define HAVE_negv8si2 ((TARGET_SSE2) && (TARGET_AVX2))
#define HAVE_negv4si2 (TARGET_SSE2)
#define HAVE_negv4di2 ((TARGET_SSE2) && (TARGET_AVX2))
#define HAVE_negv2di2 (TARGET_SSE2)
#define HAVE_addv32qi3 ((TARGET_SSE2) && (TARGET_AVX2))
#define HAVE_subv32qi3 ((TARGET_SSE2) && (TARGET_AVX2))
#define HAVE_addv16qi3 (TARGET_SSE2)
#define HAVE_subv16qi3 (TARGET_SSE2)
#define HAVE_addv16hi3 ((TARGET_SSE2) && (TARGET_AVX2))
#define HAVE_subv16hi3 ((TARGET_SSE2) && (TARGET_AVX2))
#define HAVE_addv8hi3 (TARGET_SSE2)
#define HAVE_subv8hi3 (TARGET_SSE2)
#define HAVE_addv8si3 ((TARGET_SSE2) && (TARGET_AVX2))
#define HAVE_subv8si3 ((TARGET_SSE2) && (TARGET_AVX2))
#define HAVE_addv4si3 (TARGET_SSE2)
#define HAVE_subv4si3 (TARGET_SSE2)
#define HAVE_addv4di3 ((TARGET_SSE2) && (TARGET_AVX2))
#define HAVE_subv4di3 ((TARGET_SSE2) && (TARGET_AVX2))
#define HAVE_addv2di3 (TARGET_SSE2)
#define HAVE_subv2di3 (TARGET_SSE2)
#define HAVE_avx2_ssaddv32qi3 ((TARGET_SSE2) && (TARGET_AVX2))
#define HAVE_avx2_usaddv32qi3 ((TARGET_SSE2) && (TARGET_AVX2))
#define HAVE_avx2_sssubv32qi3 ((TARGET_SSE2) && (TARGET_AVX2))
#define HAVE_avx2_ussubv32qi3 ((TARGET_SSE2) && (TARGET_AVX2))
#define HAVE_sse2_ssaddv16qi3 (TARGET_SSE2)
#define HAVE_sse2_usaddv16qi3 (TARGET_SSE2)
#define HAVE_sse2_sssubv16qi3 (TARGET_SSE2)
#define HAVE_sse2_ussubv16qi3 (TARGET_SSE2)
#define HAVE_avx2_ssaddv16hi3 ((TARGET_SSE2) && (TARGET_AVX2))
#define HAVE_avx2_usaddv16hi3 ((TARGET_SSE2) && (TARGET_AVX2))
#define HAVE_avx2_sssubv16hi3 ((TARGET_SSE2) && (TARGET_AVX2))
#define HAVE_avx2_ussubv16hi3 ((TARGET_SSE2) && (TARGET_AVX2))
#define HAVE_sse2_ssaddv8hi3 (TARGET_SSE2)
#define HAVE_sse2_usaddv8hi3 (TARGET_SSE2)
#define HAVE_sse2_sssubv8hi3 (TARGET_SSE2)
#define HAVE_sse2_ussubv8hi3 (TARGET_SSE2)
#define HAVE_mulv16hi3 ((TARGET_SSE2) && (TARGET_AVX2))
#define HAVE_mulv8hi3 (TARGET_SSE2)
#define HAVE_smulv16hi3_highpart ((TARGET_SSE2) && (TARGET_AVX2))
#define HAVE_umulv16hi3_highpart ((TARGET_SSE2) && (TARGET_AVX2))
#define HAVE_smulv8hi3_highpart (TARGET_SSE2)
#define HAVE_umulv8hi3_highpart (TARGET_SSE2)
#define HAVE_avx2_umulv4siv4di3 (TARGET_AVX2)
#define HAVE_sse2_umulv2siv2di3 (TARGET_SSE2)
#define HAVE_avx2_mulv4siv4di3 (TARGET_AVX2)
#define HAVE_sse4_1_mulv2siv2di3 (TARGET_SSE4_1)
#define HAVE_avx2_pmaddwd (TARGET_AVX2)
#define HAVE_sse2_pmaddwd (TARGET_SSE2)
#define HAVE_mulv8si3 ((TARGET_SSE2) && (TARGET_AVX2))
#define HAVE_mulv4si3 (TARGET_SSE2)
#define HAVE_vec_widen_smult_hi_v16hi ((TARGET_SSE2) && (TARGET_AVX2))
#define HAVE_vec_widen_umult_hi_v16hi ((TARGET_SSE2) && (TARGET_AVX2))
#define HAVE_vec_widen_smult_hi_v8hi (TARGET_SSE2)
#define HAVE_vec_widen_umult_hi_v8hi (TARGET_SSE2)
#define HAVE_vec_widen_smult_lo_v16hi ((TARGET_SSE2) && (TARGET_AVX2))
#define HAVE_vec_widen_umult_lo_v16hi ((TARGET_SSE2) && (TARGET_AVX2))
#define HAVE_vec_widen_smult_lo_v8hi (TARGET_SSE2)
#define HAVE_vec_widen_umult_lo_v8hi (TARGET_SSE2)
#define HAVE_vec_widen_smult_hi_v8si (TARGET_AVX2)
#define HAVE_vec_widen_umult_hi_v8si (TARGET_AVX2)
#define HAVE_vec_widen_smult_lo_v8si (TARGET_AVX2)
#define HAVE_vec_widen_umult_lo_v8si (TARGET_AVX2)
#define HAVE_vec_widen_smult_hi_v4si (TARGET_SSE4_1)
#define HAVE_vec_widen_smult_lo_v4si (TARGET_SSE4_1)
#define HAVE_vec_widen_umult_hi_v4si (TARGET_SSE2)
#define HAVE_vec_widen_umult_lo_v4si (TARGET_SSE2)
#define HAVE_sdot_prodv16hi ((TARGET_SSE2) && (TARGET_AVX2))
#define HAVE_sdot_prodv8hi (TARGET_SSE2)
#define HAVE_sdot_prodv4si (SIGN_EXTEND == ZERO_EXTEND ? TARGET_SSE2 : TARGET_SSE4_1)
#define HAVE_udot_prodv4si (ZERO_EXTEND == ZERO_EXTEND ? TARGET_SSE2 : TARGET_SSE4_1)
#define HAVE_sdot_prodv8si (TARGET_AVX2)
#define HAVE_udot_prodv8si (TARGET_AVX2)
#define HAVE_vec_shl_v16qi (TARGET_SSE2)
#define HAVE_vec_shl_v8hi (TARGET_SSE2)
#define HAVE_vec_shl_v4si (TARGET_SSE2)
#define HAVE_vec_shl_v2di (TARGET_SSE2)
#define HAVE_vec_shr_v16qi (TARGET_SSE2)
#define HAVE_vec_shr_v8hi (TARGET_SSE2)
#define HAVE_vec_shr_v4si (TARGET_SSE2)
#define HAVE_vec_shr_v2di (TARGET_SSE2)
#define HAVE_smaxv32qi3 (TARGET_AVX2)
#define HAVE_sminv32qi3 (TARGET_AVX2)
#define HAVE_umaxv32qi3 (TARGET_AVX2)
#define HAVE_uminv32qi3 (TARGET_AVX2)
#define HAVE_smaxv16hi3 (TARGET_AVX2)
#define HAVE_sminv16hi3 (TARGET_AVX2)
#define HAVE_umaxv16hi3 (TARGET_AVX2)
#define HAVE_uminv16hi3 (TARGET_AVX2)
#define HAVE_smaxv8si3 (TARGET_AVX2)
#define HAVE_sminv8si3 (TARGET_AVX2)
#define HAVE_umaxv8si3 (TARGET_AVX2)
#define HAVE_uminv8si3 (TARGET_AVX2)
#define HAVE_smaxv4di3 ((TARGET_SSE4_2) && (TARGET_AVX2))
#define HAVE_sminv4di3 ((TARGET_SSE4_2) && (TARGET_AVX2))
#define HAVE_umaxv4di3 ((TARGET_SSE4_2) && (TARGET_AVX2))
#define HAVE_uminv4di3 ((TARGET_SSE4_2) && (TARGET_AVX2))
#define HAVE_smaxv2di3 (TARGET_SSE4_2)
#define HAVE_sminv2di3 (TARGET_SSE4_2)
#define HAVE_umaxv2di3 (TARGET_SSE4_2)
#define HAVE_uminv2di3 (TARGET_SSE4_2)
#define HAVE_smaxv16qi3 (TARGET_SSE2)
#define HAVE_sminv16qi3 (TARGET_SSE2)
#define HAVE_smaxv8hi3 (TARGET_SSE2)
#define HAVE_sminv8hi3 (TARGET_SSE2)
#define HAVE_smaxv4si3 (TARGET_SSE2)
#define HAVE_sminv4si3 (TARGET_SSE2)
#define HAVE_umaxv16qi3 (TARGET_SSE2)
#define HAVE_uminv16qi3 (TARGET_SSE2)
#define HAVE_umaxv8hi3 (TARGET_SSE2)
#define HAVE_uminv8hi3 (TARGET_SSE2)
#define HAVE_umaxv4si3 (TARGET_SSE2)
#define HAVE_uminv4si3 (TARGET_SSE2)
#define HAVE_avx2_eqv32qi3 (TARGET_AVX2)
#define HAVE_avx2_eqv16hi3 (TARGET_AVX2)
#define HAVE_avx2_eqv8si3 (TARGET_AVX2)
#define HAVE_avx2_eqv4di3 (TARGET_AVX2)
#define HAVE_sse2_eqv16qi3 (TARGET_SSE2 && !TARGET_XOP )
#define HAVE_sse2_eqv8hi3 (TARGET_SSE2 && !TARGET_XOP )
#define HAVE_sse2_eqv4si3 (TARGET_SSE2 && !TARGET_XOP )
#define HAVE_sse4_1_eqv2di3 (TARGET_SSE4_1)
#define HAVE_vcondv32qiv32qi (TARGET_AVX2 \
   && (GET_MODE_NUNITS (V32QImode) \
       == GET_MODE_NUNITS (V32QImode)))
#define HAVE_vcondv16hiv32qi (TARGET_AVX2 \
   && (GET_MODE_NUNITS (V16HImode) \
       == GET_MODE_NUNITS (V32QImode)))
#define HAVE_vcondv8siv32qi (TARGET_AVX2 \
   && (GET_MODE_NUNITS (V8SImode) \
       == GET_MODE_NUNITS (V32QImode)))
#define HAVE_vcondv4div32qi (TARGET_AVX2 \
   && (GET_MODE_NUNITS (V4DImode) \
       == GET_MODE_NUNITS (V32QImode)))
#define HAVE_vcondv8sfv32qi (TARGET_AVX2 \
   && (GET_MODE_NUNITS (V8SFmode) \
       == GET_MODE_NUNITS (V32QImode)))
#define HAVE_vcondv4dfv32qi (TARGET_AVX2 \
   && (GET_MODE_NUNITS (V4DFmode) \
       == GET_MODE_NUNITS (V32QImode)))
#define HAVE_vcondv32qiv16hi (TARGET_AVX2 \
   && (GET_MODE_NUNITS (V32QImode) \
       == GET_MODE_NUNITS (V16HImode)))
#define HAVE_vcondv16hiv16hi (TARGET_AVX2 \
   && (GET_MODE_NUNITS (V16HImode) \
       == GET_MODE_NUNITS (V16HImode)))
#define HAVE_vcondv8siv16hi (TARGET_AVX2 \
   && (GET_MODE_NUNITS (V8SImode) \
       == GET_MODE_NUNITS (V16HImode)))
#define HAVE_vcondv4div16hi (TARGET_AVX2 \
   && (GET_MODE_NUNITS (V4DImode) \
       == GET_MODE_NUNITS (V16HImode)))
#define HAVE_vcondv8sfv16hi (TARGET_AVX2 \
   && (GET_MODE_NUNITS (V8SFmode) \
       == GET_MODE_NUNITS (V16HImode)))
#define HAVE_vcondv4dfv16hi (TARGET_AVX2 \
   && (GET_MODE_NUNITS (V4DFmode) \
       == GET_MODE_NUNITS (V16HImode)))
#define HAVE_vcondv32qiv8si (TARGET_AVX2 \
   && (GET_MODE_NUNITS (V32QImode) \
       == GET_MODE_NUNITS (V8SImode)))
#define HAVE_vcondv16hiv8si (TARGET_AVX2 \
   && (GET_MODE_NUNITS (V16HImode) \
       == GET_MODE_NUNITS (V8SImode)))
#define HAVE_vcondv8siv8si (TARGET_AVX2 \
   && (GET_MODE_NUNITS (V8SImode) \
       == GET_MODE_NUNITS (V8SImode)))
#define HAVE_vcondv4div8si (TARGET_AVX2 \
   && (GET_MODE_NUNITS (V4DImode) \
       == GET_MODE_NUNITS (V8SImode)))
#define HAVE_vcondv8sfv8si (TARGET_AVX2 \
   && (GET_MODE_NUNITS (V8SFmode) \
       == GET_MODE_NUNITS (V8SImode)))
#define HAVE_vcondv4dfv8si (TARGET_AVX2 \
   && (GET_MODE_NUNITS (V4DFmode) \
       == GET_MODE_NUNITS (V8SImode)))
#define HAVE_vcondv32qiv4di (TARGET_AVX2 \
   && (GET_MODE_NUNITS (V32QImode) \
       == GET_MODE_NUNITS (V4DImode)))
#define HAVE_vcondv16hiv4di (TARGET_AVX2 \
   && (GET_MODE_NUNITS (V16HImode) \
       == GET_MODE_NUNITS (V4DImode)))
#define HAVE_vcondv8siv4di (TARGET_AVX2 \
   && (GET_MODE_NUNITS (V8SImode) \
       == GET_MODE_NUNITS (V4DImode)))
#define HAVE_vcondv4div4di (TARGET_AVX2 \
   && (GET_MODE_NUNITS (V4DImode) \
       == GET_MODE_NUNITS (V4DImode)))
#define HAVE_vcondv8sfv4di (TARGET_AVX2 \
   && (GET_MODE_NUNITS (V8SFmode) \
       == GET_MODE_NUNITS (V4DImode)))
#define HAVE_vcondv4dfv4di (TARGET_AVX2 \
   && (GET_MODE_NUNITS (V4DFmode) \
       == GET_MODE_NUNITS (V4DImode)))
#define HAVE_vcondv16qiv16qi (TARGET_SSE2 \
   && (GET_MODE_NUNITS (V16QImode) \
       == GET_MODE_NUNITS (V16QImode)))
#define HAVE_vcondv8hiv16qi (TARGET_SSE2 \
   && (GET_MODE_NUNITS (V8HImode) \
       == GET_MODE_NUNITS (V16QImode)))
#define HAVE_vcondv4siv16qi (TARGET_SSE2 \
   && (GET_MODE_NUNITS (V4SImode) \
       == GET_MODE_NUNITS (V16QImode)))
#define HAVE_vcondv2div16qi (TARGET_SSE2 \
   && (GET_MODE_NUNITS (V2DImode) \
       == GET_MODE_NUNITS (V16QImode)))
#define HAVE_vcondv4sfv16qi (TARGET_SSE2 \
   && (GET_MODE_NUNITS (V4SFmode) \
       == GET_MODE_NUNITS (V16QImode)))
#define HAVE_vcondv2dfv16qi ((TARGET_SSE2 \
   && (GET_MODE_NUNITS (V2DFmode) \
       == GET_MODE_NUNITS (V16QImode))) && (TARGET_SSE2))
#define HAVE_vcondv16qiv8hi (TARGET_SSE2 \
   && (GET_MODE_NUNITS (V16QImode) \
       == GET_MODE_NUNITS (V8HImode)))
#define HAVE_vcondv8hiv8hi (TARGET_SSE2 \
   && (GET_MODE_NUNITS (V8HImode) \
       == GET_MODE_NUNITS (V8HImode)))
#define HAVE_vcondv4siv8hi (TARGET_SSE2 \
   && (GET_MODE_NUNITS (V4SImode) \
       == GET_MODE_NUNITS (V8HImode)))
#define HAVE_vcondv2div8hi (TARGET_SSE2 \
   && (GET_MODE_NUNITS (V2DImode) \
       == GET_MODE_NUNITS (V8HImode)))
#define HAVE_vcondv4sfv8hi (TARGET_SSE2 \
   && (GET_MODE_NUNITS (V4SFmode) \
       == GET_MODE_NUNITS (V8HImode)))
#define HAVE_vcondv2dfv8hi ((TARGET_SSE2 \
   && (GET_MODE_NUNITS (V2DFmode) \
       == GET_MODE_NUNITS (V8HImode))) && (TARGET_SSE2))
#define HAVE_vcondv16qiv4si (TARGET_SSE2 \
   && (GET_MODE_NUNITS (V16QImode) \
       == GET_MODE_NUNITS (V4SImode)))
#define HAVE_vcondv8hiv4si (TARGET_SSE2 \
   && (GET_MODE_NUNITS (V8HImode) \
       == GET_MODE_NUNITS (V4SImode)))
#define HAVE_vcondv4siv4si (TARGET_SSE2 \
   && (GET_MODE_NUNITS (V4SImode) \
       == GET_MODE_NUNITS (V4SImode)))
#define HAVE_vcondv2div4si (TARGET_SSE2 \
   && (GET_MODE_NUNITS (V2DImode) \
       == GET_MODE_NUNITS (V4SImode)))
#define HAVE_vcondv4sfv4si (TARGET_SSE2 \
   && (GET_MODE_NUNITS (V4SFmode) \
       == GET_MODE_NUNITS (V4SImode)))
#define HAVE_vcondv2dfv4si ((TARGET_SSE2 \
   && (GET_MODE_NUNITS (V2DFmode) \
       == GET_MODE_NUNITS (V4SImode))) && (TARGET_SSE2))
#define HAVE_vcondv2div2di (TARGET_SSE4_2)
#define HAVE_vcondv2dfv2di (TARGET_SSE4_2)
#define HAVE_vconduv32qiv32qi (TARGET_AVX2 \
   && (GET_MODE_NUNITS (V32QImode) \
       == GET_MODE_NUNITS (V32QImode)))
#define HAVE_vconduv16hiv32qi (TARGET_AVX2 \
   && (GET_MODE_NUNITS (V16HImode) \
       == GET_MODE_NUNITS (V32QImode)))
#define HAVE_vconduv8siv32qi (TARGET_AVX2 \
   && (GET_MODE_NUNITS (V8SImode) \
       == GET_MODE_NUNITS (V32QImode)))
#define HAVE_vconduv4div32qi (TARGET_AVX2 \
   && (GET_MODE_NUNITS (V4DImode) \
       == GET_MODE_NUNITS (V32QImode)))
#define HAVE_vconduv8sfv32qi (TARGET_AVX2 \
   && (GET_MODE_NUNITS (V8SFmode) \
       == GET_MODE_NUNITS (V32QImode)))
#define HAVE_vconduv4dfv32qi (TARGET_AVX2 \
   && (GET_MODE_NUNITS (V4DFmode) \
       == GET_MODE_NUNITS (V32QImode)))
#define HAVE_vconduv32qiv16hi (TARGET_AVX2 \
   && (GET_MODE_NUNITS (V32QImode) \
       == GET_MODE_NUNITS (V16HImode)))
#define HAVE_vconduv16hiv16hi (TARGET_AVX2 \
   && (GET_MODE_NUNITS (V16HImode) \
       == GET_MODE_NUNITS (V16HImode)))
#define HAVE_vconduv8siv16hi (TARGET_AVX2 \
   && (GET_MODE_NUNITS (V8SImode) \
       == GET_MODE_NUNITS (V16HImode)))
#define HAVE_vconduv4div16hi (TARGET_AVX2 \
   && (GET_MODE_NUNITS (V4DImode) \
       == GET_MODE_NUNITS (V16HImode)))
#define HAVE_vconduv8sfv16hi (TARGET_AVX2 \
   && (GET_MODE_NUNITS (V8SFmode) \
       == GET_MODE_NUNITS (V16HImode)))
#define HAVE_vconduv4dfv16hi (TARGET_AVX2 \
   && (GET_MODE_NUNITS (V4DFmode) \
       == GET_MODE_NUNITS (V16HImode)))
#define HAVE_vconduv32qiv8si (TARGET_AVX2 \
   && (GET_MODE_NUNITS (V32QImode) \
       == GET_MODE_NUNITS (V8SImode)))
#define HAVE_vconduv16hiv8si (TARGET_AVX2 \
   && (GET_MODE_NUNITS (V16HImode) \
       == GET_MODE_NUNITS (V8SImode)))
#define HAVE_vconduv8siv8si (TARGET_AVX2 \
   && (GET_MODE_NUNITS (V8SImode) \
       == GET_MODE_NUNITS (V8SImode)))
#define HAVE_vconduv4div8si (TARGET_AVX2 \
   && (GET_MODE_NUNITS (V4DImode) \
       == GET_MODE_NUNITS (V8SImode)))
#define HAVE_vconduv8sfv8si (TARGET_AVX2 \
   && (GET_MODE_NUNITS (V8SFmode) \
       == GET_MODE_NUNITS (V8SImode)))
#define HAVE_vconduv4dfv8si (TARGET_AVX2 \
   && (GET_MODE_NUNITS (V4DFmode) \
       == GET_MODE_NUNITS (V8SImode)))
#define HAVE_vconduv32qiv4di (TARGET_AVX2 \
   && (GET_MODE_NUNITS (V32QImode) \
       == GET_MODE_NUNITS (V4DImode)))
#define HAVE_vconduv16hiv4di (TARGET_AVX2 \
   && (GET_MODE_NUNITS (V16HImode) \
       == GET_MODE_NUNITS (V4DImode)))
#define HAVE_vconduv8siv4di (TARGET_AVX2 \
   && (GET_MODE_NUNITS (V8SImode) \
       == GET_MODE_NUNITS (V4DImode)))
#define HAVE_vconduv4div4di (TARGET_AVX2 \
   && (GET_MODE_NUNITS (V4DImode) \
       == GET_MODE_NUNITS (V4DImode)))
#define HAVE_vconduv8sfv4di (TARGET_AVX2 \
   && (GET_MODE_NUNITS (V8SFmode) \
       == GET_MODE_NUNITS (V4DImode)))
#define HAVE_vconduv4dfv4di (TARGET_AVX2 \
   && (GET_MODE_NUNITS (V4DFmode) \
       == GET_MODE_NUNITS (V4DImode)))
#define HAVE_vconduv16qiv16qi (TARGET_SSE2 \
   && (GET_MODE_NUNITS (V16QImode) \
       == GET_MODE_NUNITS (V16QImode)))
#define HAVE_vconduv8hiv16qi (TARGET_SSE2 \
   && (GET_MODE_NUNITS (V8HImode) \
       == GET_MODE_NUNITS (V16QImode)))
#define HAVE_vconduv4siv16qi (TARGET_SSE2 \
   && (GET_MODE_NUNITS (V4SImode) \
       == GET_MODE_NUNITS (V16QImode)))
#define HAVE_vconduv2div16qi (TARGET_SSE2 \
   && (GET_MODE_NUNITS (V2DImode) \
       == GET_MODE_NUNITS (V16QImode)))
#define HAVE_vconduv4sfv16qi (TARGET_SSE2 \
   && (GET_MODE_NUNITS (V4SFmode) \
       == GET_MODE_NUNITS (V16QImode)))
#define HAVE_vconduv2dfv16qi ((TARGET_SSE2 \
   && (GET_MODE_NUNITS (V2DFmode) \
       == GET_MODE_NUNITS (V16QImode))) && (TARGET_SSE2))
#define HAVE_vconduv16qiv8hi (TARGET_SSE2 \
   && (GET_MODE_NUNITS (V16QImode) \
       == GET_MODE_NUNITS (V8HImode)))
#define HAVE_vconduv8hiv8hi (TARGET_SSE2 \
   && (GET_MODE_NUNITS (V8HImode) \
       == GET_MODE_NUNITS (V8HImode)))
#define HAVE_vconduv4siv8hi (TARGET_SSE2 \
   && (GET_MODE_NUNITS (V4SImode) \
       == GET_MODE_NUNITS (V8HImode)))
#define HAVE_vconduv2div8hi (TARGET_SSE2 \
   && (GET_MODE_NUNITS (V2DImode) \
       == GET_MODE_NUNITS (V8HImode)))
#define HAVE_vconduv4sfv8hi (TARGET_SSE2 \
   && (GET_MODE_NUNITS (V4SFmode) \
       == GET_MODE_NUNITS (V8HImode)))
#define HAVE_vconduv2dfv8hi ((TARGET_SSE2 \
   && (GET_MODE_NUNITS (V2DFmode) \
       == GET_MODE_NUNITS (V8HImode))) && (TARGET_SSE2))
#define HAVE_vconduv16qiv4si (TARGET_SSE2 \
   && (GET_MODE_NUNITS (V16QImode) \
       == GET_MODE_NUNITS (V4SImode)))
#define HAVE_vconduv8hiv4si (TARGET_SSE2 \
   && (GET_MODE_NUNITS (V8HImode) \
       == GET_MODE_NUNITS (V4SImode)))
#define HAVE_vconduv4siv4si (TARGET_SSE2 \
   && (GET_MODE_NUNITS (V4SImode) \
       == GET_MODE_NUNITS (V4SImode)))
#define HAVE_vconduv2div4si (TARGET_SSE2 \
   && (GET_MODE_NUNITS (V2DImode) \
       == GET_MODE_NUNITS (V4SImode)))
#define HAVE_vconduv4sfv4si (TARGET_SSE2 \
   && (GET_MODE_NUNITS (V4SFmode) \
       == GET_MODE_NUNITS (V4SImode)))
#define HAVE_vconduv2dfv4si ((TARGET_SSE2 \
   && (GET_MODE_NUNITS (V2DFmode) \
       == GET_MODE_NUNITS (V4SImode))) && (TARGET_SSE2))
#define HAVE_vconduv2div2di (TARGET_SSE4_2)
#define HAVE_vconduv2dfv2di (TARGET_SSE4_2)
#define HAVE_vec_permv16qi (TARGET_SSSE3 || TARGET_AVX || TARGET_XOP)
#define HAVE_vec_permv8hi (TARGET_SSSE3 || TARGET_AVX || TARGET_XOP)
#define HAVE_vec_permv4si (TARGET_SSSE3 || TARGET_AVX || TARGET_XOP)
#define HAVE_vec_permv2di (TARGET_SSSE3 || TARGET_AVX || TARGET_XOP)
#define HAVE_vec_permv4sf (TARGET_SSSE3 || TARGET_AVX || TARGET_XOP)
#define HAVE_vec_permv2df (TARGET_SSSE3 || TARGET_AVX || TARGET_XOP)
#define HAVE_vec_permv32qi ((TARGET_SSSE3 || TARGET_AVX || TARGET_XOP) && (TARGET_AVX2))
#define HAVE_vec_permv16hi ((TARGET_SSSE3 || TARGET_AVX || TARGET_XOP) && (TARGET_AVX2))
#define HAVE_vec_permv8si ((TARGET_SSSE3 || TARGET_AVX || TARGET_XOP) && (TARGET_AVX2))
#define HAVE_vec_permv4di ((TARGET_SSSE3 || TARGET_AVX || TARGET_XOP) && (TARGET_AVX2))
#define HAVE_vec_permv8sf ((TARGET_SSSE3 || TARGET_AVX || TARGET_XOP) && (TARGET_AVX2))
#define HAVE_vec_permv4df ((TARGET_SSSE3 || TARGET_AVX || TARGET_XOP) && (TARGET_AVX2))
#define HAVE_vec_perm_constv4sf (TARGET_SSE)
#define HAVE_vec_perm_constv4si (TARGET_SSE)
#define HAVE_vec_perm_constv2df (TARGET_SSE)
#define HAVE_vec_perm_constv2di (TARGET_SSE)
#define HAVE_vec_perm_constv16qi (TARGET_SSE2)
#define HAVE_vec_perm_constv8hi (TARGET_SSE2)
#define HAVE_vec_perm_constv8sf (TARGET_AVX)
#define HAVE_vec_perm_constv4df (TARGET_AVX)
#define HAVE_vec_perm_constv8si (TARGET_AVX)
#define HAVE_vec_perm_constv4di (TARGET_AVX)
#define HAVE_vec_perm_constv32qi (TARGET_AVX2)
#define HAVE_vec_perm_constv16hi (TARGET_AVX2)
#define HAVE_one_cmplv32qi2 ((TARGET_SSE) && (TARGET_AVX))
#define HAVE_one_cmplv16qi2 (TARGET_SSE)
#define HAVE_one_cmplv16hi2 ((TARGET_SSE) && (TARGET_AVX))
#define HAVE_one_cmplv8hi2 (TARGET_SSE)
#define HAVE_one_cmplv8si2 ((TARGET_SSE) && (TARGET_AVX))
#define HAVE_one_cmplv4si2 (TARGET_SSE)
#define HAVE_one_cmplv4di2 ((TARGET_SSE) && (TARGET_AVX))
#define HAVE_one_cmplv2di2 (TARGET_SSE)
#define HAVE_avx2_andnotv32qi3 ((TARGET_SSE2) && (TARGET_AVX2))
#define HAVE_sse2_andnotv16qi3 (TARGET_SSE2)
#define HAVE_avx2_andnotv16hi3 ((TARGET_SSE2) && (TARGET_AVX2))
#define HAVE_sse2_andnotv8hi3 (TARGET_SSE2)
#define HAVE_avx2_andnotv8si3 ((TARGET_SSE2) && (TARGET_AVX2))
#define HAVE_sse2_andnotv4si3 (TARGET_SSE2)
#define HAVE_avx2_andnotv4di3 ((TARGET_SSE2) && (TARGET_AVX2))
#define HAVE_sse2_andnotv2di3 (TARGET_SSE2)
#define HAVE_andv32qi3 ((TARGET_SSE) && (TARGET_AVX))
#define HAVE_iorv32qi3 ((TARGET_SSE) && (TARGET_AVX))
#define HAVE_xorv32qi3 ((TARGET_SSE) && (TARGET_AVX))
#define HAVE_andv16qi3 (TARGET_SSE)
#define HAVE_iorv16qi3 (TARGET_SSE)
#define HAVE_xorv16qi3 (TARGET_SSE)
#define HAVE_andv16hi3 ((TARGET_SSE) && (TARGET_AVX))
#define HAVE_iorv16hi3 ((TARGET_SSE) && (TARGET_AVX))
#define HAVE_xorv16hi3 ((TARGET_SSE) && (TARGET_AVX))
#define HAVE_andv8hi3 (TARGET_SSE)
#define HAVE_iorv8hi3 (TARGET_SSE)
#define HAVE_xorv8hi3 (TARGET_SSE)
#define HAVE_andv8si3 ((TARGET_SSE) && (TARGET_AVX))
#define HAVE_iorv8si3 ((TARGET_SSE) && (TARGET_AVX))
#define HAVE_xorv8si3 ((TARGET_SSE) && (TARGET_AVX))
#define HAVE_andv4si3 (TARGET_SSE)
#define HAVE_iorv4si3 (TARGET_SSE)
#define HAVE_xorv4si3 (TARGET_SSE)
#define HAVE_andv4di3 ((TARGET_SSE) && (TARGET_AVX))
#define HAVE_iorv4di3 ((TARGET_SSE) && (TARGET_AVX))
#define HAVE_xorv4di3 ((TARGET_SSE) && (TARGET_AVX))
#define HAVE_andv2di3 (TARGET_SSE)
#define HAVE_iorv2di3 (TARGET_SSE)
#define HAVE_xorv2di3 (TARGET_SSE)
#define HAVE_andtf3 (TARGET_SSE2)
#define HAVE_iortf3 (TARGET_SSE2)
#define HAVE_xortf3 (TARGET_SSE2)
#define HAVE_vec_pack_trunc_v16hi ((TARGET_SSE2) && (TARGET_AVX2))
#define HAVE_vec_pack_trunc_v8hi (TARGET_SSE2)
#define HAVE_vec_pack_trunc_v8si ((TARGET_SSE2) && (TARGET_AVX2))
#define HAVE_vec_pack_trunc_v4si (TARGET_SSE2)
#define HAVE_vec_pack_trunc_v4di ((TARGET_SSE2) && (TARGET_AVX2))
#define HAVE_vec_pack_trunc_v2di (TARGET_SSE2)
#define HAVE_vec_interleave_highv32qi (TARGET_AVX2)
#define HAVE_vec_interleave_highv16hi (TARGET_AVX2)
#define HAVE_vec_interleave_highv8si (TARGET_AVX2)
#define HAVE_vec_interleave_highv4di (TARGET_AVX2)
#define HAVE_vec_interleave_lowv32qi (TARGET_AVX2)
#define HAVE_vec_interleave_lowv16hi (TARGET_AVX2)
#define HAVE_vec_interleave_lowv8si (TARGET_AVX2)
#define HAVE_vec_interleave_lowv4di (TARGET_AVX2)
#define HAVE_avx2_pshufdv3 (TARGET_AVX2)
#define HAVE_sse2_pshufd (TARGET_SSE2)
#define HAVE_avx2_pshuflwv3 (TARGET_AVX2)
#define HAVE_sse2_pshuflw (TARGET_SSE2)
#define HAVE_avx2_pshufhwv3 (TARGET_AVX2)
#define HAVE_sse2_pshufhw (TARGET_SSE2)
#define HAVE_sse2_loadd (TARGET_SSE)
#define HAVE_sse_storeq (TARGET_SSE)
#define HAVE_vec_unpacks_lo_v32qi ((TARGET_SSE2) && (TARGET_AVX2))
#define HAVE_vec_unpacks_lo_v16qi (TARGET_SSE2)
#define HAVE_vec_unpacks_lo_v16hi ((TARGET_SSE2) && (TARGET_AVX2))
#define HAVE_vec_unpacks_lo_v8hi (TARGET_SSE2)
#define HAVE_vec_unpacks_lo_v8si ((TARGET_SSE2) && (TARGET_AVX2))
#define HAVE_vec_unpacks_lo_v4si (TARGET_SSE2)
#define HAVE_vec_unpacks_hi_v32qi ((TARGET_SSE2) && (TARGET_AVX2))
#define HAVE_vec_unpacks_hi_v16qi (TARGET_SSE2)
#define HAVE_vec_unpacks_hi_v16hi ((TARGET_SSE2) && (TARGET_AVX2))
#define HAVE_vec_unpacks_hi_v8hi (TARGET_SSE2)
#define HAVE_vec_unpacks_hi_v8si ((TARGET_SSE2) && (TARGET_AVX2))
#define HAVE_vec_unpacks_hi_v4si (TARGET_SSE2)
#define HAVE_vec_unpacku_lo_v32qi ((TARGET_SSE2) && (TARGET_AVX2))
#define HAVE_vec_unpacku_lo_v16qi (TARGET_SSE2)
#define HAVE_vec_unpacku_lo_v16hi ((TARGET_SSE2) && (TARGET_AVX2))
#define HAVE_vec_unpacku_lo_v8hi (TARGET_SSE2)
#define HAVE_vec_unpacku_lo_v8si ((TARGET_SSE2) && (TARGET_AVX2))
#define HAVE_vec_unpacku_lo_v4si (TARGET_SSE2)
#define HAVE_vec_unpacku_hi_v32qi ((TARGET_SSE2) && (TARGET_AVX2))
#define HAVE_vec_unpacku_hi_v16qi (TARGET_SSE2)
#define HAVE_vec_unpacku_hi_v16hi ((TARGET_SSE2) && (TARGET_AVX2))
#define HAVE_vec_unpacku_hi_v8hi (TARGET_SSE2)
#define HAVE_vec_unpacku_hi_v8si ((TARGET_SSE2) && (TARGET_AVX2))
#define HAVE_vec_unpacku_hi_v4si (TARGET_SSE2)
#define HAVE_avx2_uavgv32qi3 (TARGET_AVX2)
#define HAVE_sse2_uavgv16qi3 (TARGET_SSE2)
#define HAVE_avx2_uavgv16hi3 (TARGET_AVX2)
#define HAVE_sse2_uavgv8hi3 (TARGET_SSE2)
#define HAVE_sse2_maskmovdqu (TARGET_SSE2)
#define HAVE_avx2_umulhrswv16hi3 (TARGET_AVX2)
#define HAVE_ssse3_pmulhrswv8hi3 (TARGET_SSSE3)
#define HAVE_ssse3_pmulhrswv4hi3 (TARGET_SSSE3)
#define HAVE_avx2_pblendw (TARGET_AVX2)
#define HAVE_avx_roundps_sfix256 ((TARGET_ROUND) && (TARGET_AVX))
#define HAVE_sse4_1_roundps_sfix (TARGET_ROUND)
#define HAVE_avx_roundpd_vec_pack_sfix256 ((TARGET_ROUND) && (TARGET_AVX))
#define HAVE_sse4_1_roundpd_vec_pack_sfix (TARGET_ROUND)
#define HAVE_roundv8sf2 ((TARGET_ROUND && !flag_trapping_math) && (TARGET_AVX))
#define HAVE_roundv4sf2 (TARGET_ROUND && !flag_trapping_math)
#define HAVE_roundv4df2 ((TARGET_ROUND && !flag_trapping_math) && (TARGET_AVX))
#define HAVE_roundv2df2 ((TARGET_ROUND && !flag_trapping_math) && (TARGET_SSE2))
#define HAVE_roundv8sf2_sfix ((TARGET_ROUND && !flag_trapping_math) && (TARGET_AVX))
#define HAVE_roundv4sf2_sfix (TARGET_ROUND && !flag_trapping_math)
#define HAVE_roundv4df2_vec_pack_sfix ((TARGET_ROUND && !flag_trapping_math) && (TARGET_AVX))
#define HAVE_roundv2df2_vec_pack_sfix (TARGET_ROUND && !flag_trapping_math)
#define HAVE_rotlv16qi3 (TARGET_XOP)
#define HAVE_rotlv8hi3 (TARGET_XOP)
#define HAVE_rotlv4si3 (TARGET_XOP)
#define HAVE_rotlv2di3 (TARGET_XOP)
#define HAVE_rotrv16qi3 (TARGET_XOP)
#define HAVE_rotrv8hi3 (TARGET_XOP)
#define HAVE_rotrv4si3 (TARGET_XOP)
#define HAVE_rotrv2di3 (TARGET_XOP)
#define HAVE_vrotrv16qi3 (TARGET_XOP)
#define HAVE_vrotrv8hi3 (TARGET_XOP)
#define HAVE_vrotrv4si3 (TARGET_XOP)
#define HAVE_vrotrv2di3 (TARGET_XOP)
#define HAVE_vrotlv16qi3 (TARGET_XOP)
#define HAVE_vrotlv8hi3 (TARGET_XOP)
#define HAVE_vrotlv4si3 (TARGET_XOP)
#define HAVE_vrotlv2di3 (TARGET_XOP)
#define HAVE_vlshrv16qi3 (TARGET_XOP)
#define HAVE_vlshrv8hi3 (TARGET_XOP)
#define HAVE_vlshrv4si3 (TARGET_AVX2 || TARGET_XOP)
#define HAVE_vlshrv2di3 (TARGET_AVX2 || TARGET_XOP)
#define HAVE_vlshrv8si3 (TARGET_AVX2)
#define HAVE_vlshrv4di3 (TARGET_AVX2)
#define HAVE_vashrv16qi3 (TARGET_XOP)
#define HAVE_vashrv8hi3 (TARGET_XOP)
#define HAVE_vashrv2di3 (TARGET_XOP)
#define HAVE_vashrv4si3 (TARGET_AVX2 || TARGET_XOP)
#define HAVE_vashrv8si3 (TARGET_AVX2)
#define HAVE_vashlv16qi3 (TARGET_XOP)
#define HAVE_vashlv8hi3 (TARGET_XOP)
#define HAVE_vashlv4si3 (TARGET_AVX2 || TARGET_XOP)
#define HAVE_vashlv2di3 (TARGET_AVX2 || TARGET_XOP)
#define HAVE_vashlv8si3 (TARGET_AVX2)
#define HAVE_vashlv4di3 (TARGET_AVX2)
#define HAVE_ashlv16qi3 (TARGET_XOP)
#define HAVE_lshrv16qi3 (TARGET_XOP)
#define HAVE_ashrv16qi3 (TARGET_XOP)
#define HAVE_ashrv2di3 (TARGET_XOP)
#define HAVE_xop_vmfrczv4sf2 (TARGET_XOP)
#define HAVE_xop_vmfrczv2df2 ((TARGET_XOP) && (TARGET_SSE2))
#define HAVE_avx_vzeroall (TARGET_AVX)
#define HAVE_avx2_permv4di (TARGET_AVX2)
#define HAVE_avx_vpermilv4df (TARGET_AVX)
#define HAVE_avx_vpermilv2df (TARGET_AVX)
#define HAVE_avx_vpermilv8sf (TARGET_AVX)
#define HAVE_avx_vpermilv4sf (TARGET_AVX)
#define HAVE_avx_vperm2f128v8si3 (TARGET_AVX)
#define HAVE_avx_vperm2f128v8sf3 (TARGET_AVX)
#define HAVE_avx_vperm2f128v4df3 (TARGET_AVX)
#define HAVE_avx_vinsertf128v32qi (TARGET_AVX)
#define HAVE_avx_vinsertf128v16hi (TARGET_AVX)
#define HAVE_avx_vinsertf128v8si (TARGET_AVX)
#define HAVE_avx_vinsertf128v4di (TARGET_AVX)
#define HAVE_avx_vinsertf128v8sf (TARGET_AVX)
#define HAVE_avx_vinsertf128v4df (TARGET_AVX)
#define HAVE_vec_initv32qi (TARGET_AVX)
#define HAVE_vec_initv16hi (TARGET_AVX)
#define HAVE_vec_initv8si (TARGET_AVX)
#define HAVE_vec_initv4di (TARGET_AVX)
#define HAVE_vec_initv8sf (TARGET_AVX)
#define HAVE_vec_initv4df (TARGET_AVX)
#define HAVE_avx2_extracti128 (TARGET_AVX2)
#define HAVE_avx2_inserti128 (TARGET_AVX2)
#define HAVE_vcvtps2ph (TARGET_F16C)
#define HAVE_avx2_gathersiv2di (TARGET_AVX2)
#define HAVE_avx2_gathersiv2df (TARGET_AVX2)
#define HAVE_avx2_gathersiv4di (TARGET_AVX2)
#define HAVE_avx2_gathersiv4df (TARGET_AVX2)
#define HAVE_avx2_gathersiv4si (TARGET_AVX2)
#define HAVE_avx2_gathersiv4sf (TARGET_AVX2)
#define HAVE_avx2_gathersiv8si (TARGET_AVX2)
#define HAVE_avx2_gathersiv8sf (TARGET_AVX2)
#define HAVE_avx2_gatherdiv2di (TARGET_AVX2)
#define HAVE_avx2_gatherdiv2df (TARGET_AVX2)
#define HAVE_avx2_gatherdiv4di (TARGET_AVX2)
#define HAVE_avx2_gatherdiv4df (TARGET_AVX2)
#define HAVE_avx2_gatherdiv4si (TARGET_AVX2)
#define HAVE_avx2_gatherdiv4sf (TARGET_AVX2)
#define HAVE_avx2_gatherdiv8si (TARGET_AVX2)
#define HAVE_avx2_gatherdiv8sf (TARGET_AVX2)
#define HAVE_sse2_lfence (TARGET_SSE2)
#define HAVE_sse_sfence (TARGET_SSE || TARGET_3DNOW_A)
#define HAVE_sse2_mfence (TARGET_SSE2)
#define HAVE_mem_thread_fence 1
#define HAVE_atomic_loadqi 1
#define HAVE_atomic_loadhi 1
#define HAVE_atomic_loadsi 1
#define HAVE_atomic_loaddi (TARGET_64BIT || (TARGET_CMPXCHG8B && (TARGET_80387 || TARGET_SSE)))
#define HAVE_atomic_storeqi 1
#define HAVE_atomic_storehi 1
#define HAVE_atomic_storesi 1
#define HAVE_atomic_storedi (TARGET_64BIT || (TARGET_CMPXCHG8B && (TARGET_80387 || TARGET_SSE)))
#define HAVE_atomic_compare_and_swapqi (TARGET_CMPXCHG)
#define HAVE_atomic_compare_and_swaphi (TARGET_CMPXCHG)
#define HAVE_atomic_compare_and_swapsi (TARGET_CMPXCHG)
#define HAVE_atomic_compare_and_swapdi ((TARGET_CMPXCHG) && (TARGET_64BIT || TARGET_CMPXCHG8B))
#define HAVE_atomic_compare_and_swapti ((TARGET_CMPXCHG) && (TARGET_64BIT && TARGET_CMPXCHG16B))
extern rtx        gen_x86_fnstsw_1                         (rtx);
extern rtx        gen_x86_sahf_1                           (rtx);
extern rtx        gen_swapxf                               (rtx, rtx);
extern rtx        gen_zero_extendsidi2_1                   (rtx, rtx);
extern rtx        gen_zero_extendqidi2                     (rtx, rtx);
extern rtx        gen_zero_extendhidi2                     (rtx, rtx);
extern rtx        gen_zero_extendhisi2_and                 (rtx, rtx);
extern rtx        gen_extendsidi2_1                        (rtx, rtx);
extern rtx        gen_extendqidi2                          (rtx, rtx);
extern rtx        gen_extendhidi2                          (rtx, rtx);
extern rtx        gen_extendhisi2                          (rtx, rtx);
extern rtx        gen_extendqisi2                          (rtx, rtx);
extern rtx        gen_extendqihi2                          (rtx, rtx);
extern rtx        gen_truncxfsf2_i387_noop                 (rtx, rtx);
extern rtx        gen_truncxfdf2_i387_noop                 (rtx, rtx);
extern rtx        gen_fix_truncsfdi_sse                    (rtx, rtx);
extern rtx        gen_fix_truncdfdi_sse                    (rtx, rtx);
extern rtx        gen_fix_truncsfsi_sse                    (rtx, rtx);
extern rtx        gen_fix_truncdfsi_sse                    (rtx, rtx);
extern rtx        gen_fix_trunchi_fisttp_i387_1            (rtx, rtx);
extern rtx        gen_fix_truncsi_fisttp_i387_1            (rtx, rtx);
extern rtx        gen_fix_truncdi_fisttp_i387_1            (rtx, rtx);
extern rtx        gen_fix_trunchi_i387_fisttp              (rtx, rtx);
extern rtx        gen_fix_truncsi_i387_fisttp              (rtx, rtx);
extern rtx        gen_fix_truncdi_i387_fisttp              (rtx, rtx);
extern rtx        gen_fix_trunchi_i387_fisttp_with_temp    (rtx, rtx, rtx);
extern rtx        gen_fix_truncsi_i387_fisttp_with_temp    (rtx, rtx, rtx);
extern rtx        gen_fix_truncdi_i387_fisttp_with_temp    (rtx, rtx, rtx);
extern rtx        gen_fix_truncdi_i387                     (rtx, rtx, rtx, rtx);
extern rtx        gen_fix_truncdi_i387_with_temp           (rtx, rtx, rtx, rtx, rtx);
extern rtx        gen_fix_trunchi_i387                     (rtx, rtx, rtx, rtx);
extern rtx        gen_fix_truncsi_i387                     (rtx, rtx, rtx, rtx);
extern rtx        gen_fix_trunchi_i387_with_temp           (rtx, rtx, rtx, rtx, rtx);
extern rtx        gen_fix_truncsi_i387_with_temp           (rtx, rtx, rtx, rtx, rtx);
extern rtx        gen_x86_fnstcw_1                         (rtx);
extern rtx        gen_x86_fldcw_1                          (rtx);
extern rtx        gen_floatdisf2_i387_with_xmm             (rtx, rtx, rtx);
extern rtx        gen_floatdidf2_i387_with_xmm             (rtx, rtx, rtx);
extern rtx        gen_floatdixf2_i387_with_xmm             (rtx, rtx, rtx);
extern rtx        gen_addqi3_cc                            (rtx, rtx, rtx);
extern rtx        gen_addsi_1_zext                         (rtx, rtx, rtx);
extern rtx        gen_addqi_ext_1                          (rtx, rtx, rtx);
extern rtx        gen_divmodsi4_1                          (rtx, rtx, rtx, rtx);
extern rtx        gen_divmoddi4_1                          (rtx, rtx, rtx, rtx);
extern rtx        gen_divmodhiqi3                          (rtx, rtx, rtx);
extern rtx        gen_udivmodsi4_1                         (rtx, rtx, rtx, rtx);
extern rtx        gen_udivmoddi4_1                         (rtx, rtx, rtx, rtx);
extern rtx        gen_udivmodhiqi3                         (rtx, rtx, rtx);
extern rtx        gen_andqi_ext_0                          (rtx, rtx, rtx);
extern rtx        gen_copysignsf3_const                    (rtx, rtx, rtx, rtx);
extern rtx        gen_copysigndf3_const                    (rtx, rtx, rtx, rtx);
extern rtx        gen_copysigntf3_const                    (rtx, rtx, rtx, rtx);
extern rtx        gen_copysignsf3_var                      (rtx, rtx, rtx, rtx, rtx, rtx);
extern rtx        gen_copysigndf3_var                      (rtx, rtx, rtx, rtx, rtx, rtx);
extern rtx        gen_copysigntf3_var                      (rtx, rtx, rtx, rtx, rtx, rtx);
extern rtx        gen_x86_64_shld                          (rtx, rtx, rtx);
extern rtx        gen_x86_shld                             (rtx, rtx, rtx);
extern rtx        gen_x86_64_shrd                          (rtx, rtx, rtx);
extern rtx        gen_x86_shrd                             (rtx, rtx, rtx);
extern rtx        gen_ashrdi3_cvt                          (rtx, rtx, rtx);
extern rtx        gen_ashrsi3_cvt                          (rtx, rtx, rtx);
extern rtx        gen_ix86_rotldi3_doubleword              (rtx, rtx, rtx);
extern rtx        gen_ix86_rotlti3_doubleword              (rtx, rtx, rtx);
extern rtx        gen_ix86_rotrdi3_doubleword              (rtx, rtx, rtx);
extern rtx        gen_ix86_rotrti3_doubleword              (rtx, rtx, rtx);
extern rtx        gen_setcc_sf_sse                         (rtx, rtx, rtx, rtx);
extern rtx        gen_setcc_df_sse                         (rtx, rtx, rtx, rtx);
extern rtx        gen_jump                                 (rtx);
extern rtx        gen_blockage                             (void);
extern rtx        gen_prologue_use                         (rtx);
extern rtx        gen_simple_return_internal               (void);
extern rtx        gen_simple_return_internal_long          (void);
extern rtx        gen_simple_return_pop_internal           (rtx);
extern rtx        gen_simple_return_indirect_internal      (rtx);
extern rtx        gen_nop                                  (void);
extern rtx        gen_nops                                 (rtx);
extern rtx        gen_pad                                  (rtx);
extern rtx        gen_set_got                              (rtx);
extern rtx        gen_set_got_labelled                     (rtx, rtx);
extern rtx        gen_set_got_rex64                        (rtx);
extern rtx        gen_set_rip_rex64                        (rtx, rtx);
extern rtx        gen_set_got_offset_rex64                 (rtx, rtx);
extern rtx        gen_eh_return_internal                   (void);
extern rtx        gen_leave                                (void);
extern rtx        gen_leave_rex64                          (void);
extern rtx        gen_split_stack_return                   (rtx);
extern rtx        gen_ffssi2_no_cmove                      (rtx, rtx);
extern rtx        gen_ctzhi2                               (rtx, rtx);
extern rtx        gen_ctzsi2                               (rtx, rtx);
extern rtx        gen_ctzdi2                               (rtx, rtx);
extern rtx        gen_clzhi2_lzcnt                         (rtx, rtx);
extern rtx        gen_clzsi2_lzcnt                         (rtx, rtx);
extern rtx        gen_clzdi2_lzcnt                         (rtx, rtx);
extern rtx        gen_bmi_bextr_si                         (rtx, rtx, rtx);
extern rtx        gen_bmi_bextr_di                         (rtx, rtx, rtx);
extern rtx        gen_bmi2_bzhi_si3                        (rtx, rtx, rtx);
extern rtx        gen_bmi2_bzhi_di3                        (rtx, rtx, rtx);
extern rtx        gen_bmi2_pdep_si3                        (rtx, rtx, rtx);
extern rtx        gen_bmi2_pdep_di3                        (rtx, rtx, rtx);
extern rtx        gen_bmi2_pext_si3                        (rtx, rtx, rtx);
extern rtx        gen_bmi2_pext_di3                        (rtx, rtx, rtx);
extern rtx        gen_tbm_bextri_si                        (rtx, rtx, rtx, rtx);
extern rtx        gen_tbm_bextri_di                        (rtx, rtx, rtx, rtx);
extern rtx        gen_bsr_rex64                            (rtx, rtx);
extern rtx        gen_bsr                                  (rtx, rtx);
extern rtx        gen_popcounthi2                          (rtx, rtx);
extern rtx        gen_popcountsi2                          (rtx, rtx);
extern rtx        gen_popcountdi2                          (rtx, rtx);
extern rtx        gen_bswaphi_lowpart                      (rtx);
extern rtx        gen_paritydi2_cmp                        (rtx, rtx, rtx, rtx);
extern rtx        gen_paritysi2_cmp                        (rtx, rtx, rtx);
static inline rtx gen_tls_initial_exec_64_sun              (rtx, rtx);
static inline rtx
gen_tls_initial_exec_64_sun(rtx ARG_UNUSED (a), rtx ARG_UNUSED (b))
{
  return 0;
}
extern rtx        gen_truncxfsf2_i387_noop_unspec          (rtx, rtx);
extern rtx        gen_truncxfdf2_i387_noop_unspec          (rtx, rtx);
extern rtx        gen_sqrtxf2                              (rtx, rtx);
extern rtx        gen_sqrt_extendsfxf2_i387                (rtx, rtx);
extern rtx        gen_sqrt_extenddfxf2_i387                (rtx, rtx);
extern rtx        gen_fpremxf4_i387                        (rtx, rtx, rtx, rtx);
extern rtx        gen_fprem1xf4_i387                       (rtx, rtx, rtx, rtx);
extern rtx        gen_sincosxf3                            (rtx, rtx, rtx);
extern rtx        gen_sincos_extendsfxf3_i387              (rtx, rtx, rtx);
extern rtx        gen_sincos_extenddfxf3_i387              (rtx, rtx, rtx);
extern rtx        gen_fptanxf4_i387                        (rtx, rtx, rtx, rtx);
extern rtx        gen_fptan_extendsfxf4_i387               (rtx, rtx, rtx, rtx);
extern rtx        gen_fptan_extenddfxf4_i387               (rtx, rtx, rtx, rtx);
extern rtx        gen_fpatan_extendsfxf3_i387              (rtx, rtx, rtx);
extern rtx        gen_fpatan_extenddfxf3_i387              (rtx, rtx, rtx);
extern rtx        gen_fyl2xxf3_i387                        (rtx, rtx, rtx);
extern rtx        gen_fyl2x_extendsfxf3_i387               (rtx, rtx, rtx);
extern rtx        gen_fyl2x_extenddfxf3_i387               (rtx, rtx, rtx);
extern rtx        gen_fyl2xp1xf3_i387                      (rtx, rtx, rtx);
extern rtx        gen_fyl2xp1_extendsfxf3_i387             (rtx, rtx, rtx);
extern rtx        gen_fyl2xp1_extenddfxf3_i387             (rtx, rtx, rtx);
extern rtx        gen_fxtractxf3_i387                      (rtx, rtx, rtx);
extern rtx        gen_fxtract_extendsfxf3_i387             (rtx, rtx, rtx);
extern rtx        gen_fxtract_extenddfxf3_i387             (rtx, rtx, rtx);
extern rtx        gen_sse4_1_roundsf2                      (rtx, rtx, rtx);
extern rtx        gen_sse4_1_rounddf2                      (rtx, rtx, rtx);
extern rtx        gen_rintxf2                              (rtx, rtx);
extern rtx        gen_fistdi2                              (rtx, rtx);
extern rtx        gen_fistdi2_with_temp                    (rtx, rtx, rtx);
extern rtx        gen_fisthi2                              (rtx, rtx);
extern rtx        gen_fistsi2                              (rtx, rtx);
extern rtx        gen_fisthi2_with_temp                    (rtx, rtx, rtx);
extern rtx        gen_fistsi2_with_temp                    (rtx, rtx, rtx);
extern rtx        gen_frndintxf2_floor                     (rtx, rtx);
extern rtx        gen_frndintxf2_floor_i387                (rtx, rtx, rtx, rtx);
extern rtx        gen_fistdi2_floor                        (rtx, rtx, rtx, rtx);
extern rtx        gen_fistdi2_floor_with_temp              (rtx, rtx, rtx, rtx, rtx);
extern rtx        gen_fisthi2_floor                        (rtx, rtx, rtx, rtx);
extern rtx        gen_fistsi2_floor                        (rtx, rtx, rtx, rtx);
extern rtx        gen_fisthi2_floor_with_temp              (rtx, rtx, rtx, rtx, rtx);
extern rtx        gen_fistsi2_floor_with_temp              (rtx, rtx, rtx, rtx, rtx);
extern rtx        gen_frndintxf2_ceil                      (rtx, rtx);
extern rtx        gen_frndintxf2_ceil_i387                 (rtx, rtx, rtx, rtx);
extern rtx        gen_fistdi2_ceil                         (rtx, rtx, rtx, rtx);
extern rtx        gen_fistdi2_ceil_with_temp               (rtx, rtx, rtx, rtx, rtx);
extern rtx        gen_fisthi2_ceil                         (rtx, rtx, rtx, rtx);
extern rtx        gen_fistsi2_ceil                         (rtx, rtx, rtx, rtx);
extern rtx        gen_fisthi2_ceil_with_temp               (rtx, rtx, rtx, rtx, rtx);
extern rtx        gen_fistsi2_ceil_with_temp               (rtx, rtx, rtx, rtx, rtx);
extern rtx        gen_frndintxf2_trunc                     (rtx, rtx);
extern rtx        gen_frndintxf2_trunc_i387                (rtx, rtx, rtx, rtx);
extern rtx        gen_frndintxf2_mask_pm                   (rtx, rtx);
extern rtx        gen_frndintxf2_mask_pm_i387              (rtx, rtx, rtx, rtx);
extern rtx        gen_fxamsf2_i387                         (rtx, rtx);
extern rtx        gen_fxamdf2_i387                         (rtx, rtx);
extern rtx        gen_fxamxf2_i387                         (rtx, rtx);
extern rtx        gen_fxamsf2_i387_with_temp               (rtx, rtx);
extern rtx        gen_fxamdf2_i387_with_temp               (rtx, rtx);
extern rtx        gen_movmsk_df                            (rtx, rtx);
extern rtx        gen_cld                                  (void);
extern rtx        gen_smaxsf3                              (rtx, rtx, rtx);
extern rtx        gen_sminsf3                              (rtx, rtx, rtx);
extern rtx        gen_smaxdf3                              (rtx, rtx, rtx);
extern rtx        gen_smindf3                              (rtx, rtx, rtx);
extern rtx        gen_pro_epilogue_adjust_stack_si_add     (rtx, rtx, rtx);
extern rtx        gen_pro_epilogue_adjust_stack_di_add     (rtx, rtx, rtx);
extern rtx        gen_pro_epilogue_adjust_stack_si_sub     (rtx, rtx, rtx);
extern rtx        gen_pro_epilogue_adjust_stack_di_sub     (rtx, rtx, rtx);
extern rtx        gen_allocate_stack_worker_probe_si       (rtx, rtx);
extern rtx        gen_allocate_stack_worker_probe_di       (rtx, rtx);
extern rtx        gen_adjust_stack_and_probesi             (rtx, rtx, rtx);
extern rtx        gen_adjust_stack_and_probedi             (rtx, rtx, rtx);
extern rtx        gen_probe_stack_rangesi                  (rtx, rtx, rtx);
extern rtx        gen_probe_stack_rangedi                  (rtx, rtx, rtx);
extern rtx        gen_trap                                 (void);
extern rtx        gen_stack_protect_set_si                 (rtx, rtx);
extern rtx        gen_stack_protect_set_di                 (rtx, rtx);
extern rtx        gen_stack_tls_protect_set_si             (rtx, rtx);
extern rtx        gen_stack_tls_protect_set_di             (rtx, rtx);
extern rtx        gen_stack_protect_test_si                (rtx, rtx, rtx);
extern rtx        gen_stack_protect_test_di                (rtx, rtx, rtx);
extern rtx        gen_stack_tls_protect_test_si            (rtx, rtx, rtx);
extern rtx        gen_stack_tls_protect_test_di            (rtx, rtx, rtx);
extern rtx        gen_sse4_2_crc32qi                       (rtx, rtx, rtx);
extern rtx        gen_sse4_2_crc32hi                       (rtx, rtx, rtx);
extern rtx        gen_sse4_2_crc32si                       (rtx, rtx, rtx);
extern rtx        gen_sse4_2_crc32di                       (rtx, rtx, rtx);
extern rtx        gen_lwp_slwpcbsi                         (rtx);
extern rtx        gen_lwp_slwpcbdi                         (rtx);
extern rtx        gen_rdfsbasesi                           (rtx);
extern rtx        gen_rdfsbasedi                           (rtx);
extern rtx        gen_rdgsbasesi                           (rtx);
extern rtx        gen_rdgsbasedi                           (rtx);
extern rtx        gen_wrfsbasesi                           (rtx);
extern rtx        gen_wrfsbasedi                           (rtx);
extern rtx        gen_wrgsbasesi                           (rtx);
extern rtx        gen_wrgsbasedi                           (rtx);
extern rtx        gen_rdrandhi_1                           (rtx);
extern rtx        gen_rdrandsi_1                           (rtx);
extern rtx        gen_rdranddi_1                           (rtx);
extern rtx        gen_sse_movntq                           (rtx, rtx);
extern rtx        gen_mmx_rcpv2sf2                         (rtx, rtx);
extern rtx        gen_mmx_rcpit1v2sf3                      (rtx, rtx, rtx);
extern rtx        gen_mmx_rcpit2v2sf3                      (rtx, rtx, rtx);
extern rtx        gen_mmx_rsqrtv2sf2                       (rtx, rtx);
extern rtx        gen_mmx_rsqit1v2sf3                      (rtx, rtx, rtx);
extern rtx        gen_mmx_haddv2sf3                        (rtx, rtx, rtx);
extern rtx        gen_mmx_hsubv2sf3                        (rtx, rtx, rtx);
extern rtx        gen_mmx_addsubv2sf3                      (rtx, rtx, rtx);
extern rtx        gen_mmx_gtv2sf3                          (rtx, rtx, rtx);
extern rtx        gen_mmx_gev2sf3                          (rtx, rtx, rtx);
extern rtx        gen_mmx_pf2id                            (rtx, rtx);
extern rtx        gen_mmx_pf2iw                            (rtx, rtx);
extern rtx        gen_mmx_pi2fw                            (rtx, rtx);
extern rtx        gen_mmx_floatv2si2                       (rtx, rtx);
extern rtx        gen_mmx_pswapdv2sf2                      (rtx, rtx);
extern rtx        gen_mmx_ashrv4hi3                        (rtx, rtx, rtx);
extern rtx        gen_mmx_ashrv2si3                        (rtx, rtx, rtx);
extern rtx        gen_mmx_ashlv4hi3                        (rtx, rtx, rtx);
extern rtx        gen_mmx_lshrv4hi3                        (rtx, rtx, rtx);
extern rtx        gen_mmx_ashlv2si3                        (rtx, rtx, rtx);
extern rtx        gen_mmx_lshrv2si3                        (rtx, rtx, rtx);
extern rtx        gen_mmx_ashlv1di3                        (rtx, rtx, rtx);
extern rtx        gen_mmx_lshrv1di3                        (rtx, rtx, rtx);
extern rtx        gen_mmx_gtv8qi3                          (rtx, rtx, rtx);
extern rtx        gen_mmx_gtv4hi3                          (rtx, rtx, rtx);
extern rtx        gen_mmx_gtv2si3                          (rtx, rtx, rtx);
extern rtx        gen_mmx_andnotv8qi3                      (rtx, rtx, rtx);
extern rtx        gen_mmx_andnotv4hi3                      (rtx, rtx, rtx);
extern rtx        gen_mmx_andnotv2si3                      (rtx, rtx, rtx);
extern rtx        gen_mmx_packsswb                         (rtx, rtx, rtx);
extern rtx        gen_mmx_packssdw                         (rtx, rtx, rtx);
extern rtx        gen_mmx_packuswb                         (rtx, rtx, rtx);
extern rtx        gen_mmx_punpckhbw                        (rtx, rtx, rtx);
extern rtx        gen_mmx_punpcklbw                        (rtx, rtx, rtx);
extern rtx        gen_mmx_punpckhwd                        (rtx, rtx, rtx);
extern rtx        gen_mmx_punpcklwd                        (rtx, rtx, rtx);
extern rtx        gen_mmx_punpckhdq                        (rtx, rtx, rtx);
extern rtx        gen_mmx_punpckldq                        (rtx, rtx, rtx);
extern rtx        gen_mmx_pextrw                           (rtx, rtx, rtx);
extern rtx        gen_mmx_pshufw_1                         (rtx, rtx, rtx, rtx, rtx, rtx);
extern rtx        gen_mmx_pswapdv2si2                      (rtx, rtx);
extern rtx        gen_mmx_psadbw                           (rtx, rtx, rtx);
extern rtx        gen_mmx_pmovmskb                         (rtx, rtx);
extern rtx        gen_sse2_movq128                         (rtx, rtx);
extern rtx        gen_movdi_to_sse                         (rtx, rtx);
extern rtx        gen_avx_loadups256                       (rtx, rtx);
extern rtx        gen_sse_loadups                          (rtx, rtx);
extern rtx        gen_avx_loadupd256                       (rtx, rtx);
extern rtx        gen_sse2_loadupd                         (rtx, rtx);
extern rtx        gen_avx_storeups256                      (rtx, rtx);
extern rtx        gen_sse_storeups                         (rtx, rtx);
extern rtx        gen_avx_storeupd256                      (rtx, rtx);
extern rtx        gen_sse2_storeupd                        (rtx, rtx);
extern rtx        gen_avx_loaddqu256                       (rtx, rtx);
extern rtx        gen_sse2_loaddqu                         (rtx, rtx);
extern rtx        gen_avx_storedqu256                      (rtx, rtx);
extern rtx        gen_sse2_storedqu                        (rtx, rtx);
extern rtx        gen_avx_lddqu256                         (rtx, rtx);
extern rtx        gen_sse3_lddqu                           (rtx, rtx);
extern rtx        gen_sse2_movntisi                        (rtx, rtx);
extern rtx        gen_sse2_movntidi                        (rtx, rtx);
extern rtx        gen_avx_movntv8sf                        (rtx, rtx);
extern rtx        gen_sse_movntv4sf                        (rtx, rtx);
extern rtx        gen_avx_movntv4df                        (rtx, rtx);
extern rtx        gen_sse2_movntv2df                       (rtx, rtx);
extern rtx        gen_avx_movntv4di                        (rtx, rtx);
extern rtx        gen_sse2_movntv2di                       (rtx, rtx);
extern rtx        gen_sse_vmaddv4sf3                       (rtx, rtx, rtx);
extern rtx        gen_sse_vmsubv4sf3                       (rtx, rtx, rtx);
extern rtx        gen_sse2_vmaddv2df3                      (rtx, rtx, rtx);
extern rtx        gen_sse2_vmsubv2df3                      (rtx, rtx, rtx);
extern rtx        gen_sse_vmmulv4sf3                       (rtx, rtx, rtx);
extern rtx        gen_sse2_vmmulv2df3                      (rtx, rtx, rtx);
extern rtx        gen_avx_divv8sf3                         (rtx, rtx, rtx);
extern rtx        gen_sse_divv4sf3                         (rtx, rtx, rtx);
extern rtx        gen_avx_divv4df3                         (rtx, rtx, rtx);
extern rtx        gen_sse2_divv2df3                        (rtx, rtx, rtx);
extern rtx        gen_sse_vmdivv4sf3                       (rtx, rtx, rtx);
extern rtx        gen_sse2_vmdivv2df3                      (rtx, rtx, rtx);
extern rtx        gen_avx_rcpv8sf2                         (rtx, rtx);
extern rtx        gen_sse_rcpv4sf2                         (rtx, rtx);
extern rtx        gen_sse_vmrcpv4sf2                       (rtx, rtx, rtx);
extern rtx        gen_avx_sqrtv8sf2                        (rtx, rtx);
extern rtx        gen_sse_sqrtv4sf2                        (rtx, rtx);
extern rtx        gen_avx_sqrtv4df2                        (rtx, rtx);
extern rtx        gen_sse2_sqrtv2df2                       (rtx, rtx);
extern rtx        gen_sse_vmsqrtv4sf2                      (rtx, rtx, rtx);
extern rtx        gen_sse2_vmsqrtv2df2                     (rtx, rtx, rtx);
extern rtx        gen_avx_rsqrtv8sf2                       (rtx, rtx);
extern rtx        gen_sse_rsqrtv4sf2                       (rtx, rtx);
extern rtx        gen_sse_vmrsqrtv4sf2                     (rtx, rtx, rtx);
extern rtx        gen_sse_vmsmaxv4sf3                      (rtx, rtx, rtx);
extern rtx        gen_sse_vmsminv4sf3                      (rtx, rtx, rtx);
extern rtx        gen_sse2_vmsmaxv2df3                     (rtx, rtx, rtx);
extern rtx        gen_sse2_vmsminv2df3                     (rtx, rtx, rtx);
extern rtx        gen_avx_addsubv4df3                      (rtx, rtx, rtx);
extern rtx        gen_sse3_addsubv2df3                     (rtx, rtx, rtx);
extern rtx        gen_avx_addsubv8sf3                      (rtx, rtx, rtx);
extern rtx        gen_sse3_addsubv4sf3                     (rtx, rtx, rtx);
extern rtx        gen_avx_haddv4df3                        (rtx, rtx, rtx);
extern rtx        gen_avx_hsubv4df3                        (rtx, rtx, rtx);
extern rtx        gen_sse3_haddv2df3                       (rtx, rtx, rtx);
extern rtx        gen_sse3_hsubv2df3                       (rtx, rtx, rtx);
extern rtx        gen_avx_haddv8sf3                        (rtx, rtx, rtx);
extern rtx        gen_avx_hsubv8sf3                        (rtx, rtx, rtx);
extern rtx        gen_sse3_haddv4sf3                       (rtx, rtx, rtx);
extern rtx        gen_sse3_hsubv4sf3                       (rtx, rtx, rtx);
extern rtx        gen_avx_cmpv8sf3                         (rtx, rtx, rtx, rtx);
extern rtx        gen_avx_cmpv4sf3                         (rtx, rtx, rtx, rtx);
extern rtx        gen_avx_cmpv4df3                         (rtx, rtx, rtx, rtx);
extern rtx        gen_avx_cmpv2df3                         (rtx, rtx, rtx, rtx);
extern rtx        gen_avx_vmcmpv4sf3                       (rtx, rtx, rtx, rtx);
extern rtx        gen_avx_vmcmpv2df3                       (rtx, rtx, rtx, rtx);
extern rtx        gen_avx_maskcmpv8sf3                     (rtx, rtx, rtx, rtx);
extern rtx        gen_sse_maskcmpv4sf3                     (rtx, rtx, rtx, rtx);
extern rtx        gen_avx_maskcmpv4df3                     (rtx, rtx, rtx, rtx);
extern rtx        gen_sse2_maskcmpv2df3                    (rtx, rtx, rtx, rtx);
extern rtx        gen_sse_vmmaskcmpv4sf3                   (rtx, rtx, rtx, rtx);
extern rtx        gen_sse2_vmmaskcmpv2df3                  (rtx, rtx, rtx, rtx);
extern rtx        gen_sse_comi                             (rtx, rtx);
extern rtx        gen_sse2_comi                            (rtx, rtx);
extern rtx        gen_sse_ucomi                            (rtx, rtx);
extern rtx        gen_sse2_ucomi                           (rtx, rtx);
extern rtx        gen_avx_andnotv8sf3                      (rtx, rtx, rtx);
extern rtx        gen_sse_andnotv4sf3                      (rtx, rtx, rtx);
extern rtx        gen_avx_andnotv4df3                      (rtx, rtx, rtx);
extern rtx        gen_sse2_andnotv2df3                     (rtx, rtx, rtx);
extern rtx        gen_sse_cvtpi2ps                         (rtx, rtx, rtx);
extern rtx        gen_sse_cvtps2pi                         (rtx, rtx);
extern rtx        gen_sse_cvttps2pi                        (rtx, rtx);
extern rtx        gen_sse_cvtsi2ss                         (rtx, rtx, rtx);
extern rtx        gen_sse_cvtsi2ssq                        (rtx, rtx, rtx);
extern rtx        gen_sse_cvtss2si                         (rtx, rtx);
extern rtx        gen_sse_cvtss2si_2                       (rtx, rtx);
extern rtx        gen_sse_cvtss2siq                        (rtx, rtx);
extern rtx        gen_sse_cvtss2siq_2                      (rtx, rtx);
extern rtx        gen_sse_cvttss2si                        (rtx, rtx);
extern rtx        gen_sse_cvttss2siq                       (rtx, rtx);
extern rtx        gen_floatv8siv8sf2                       (rtx, rtx);
extern rtx        gen_floatv4siv4sf2                       (rtx, rtx);
extern rtx        gen_avx_cvtps2dq256                      (rtx, rtx);
extern rtx        gen_sse2_cvtps2dq                        (rtx, rtx);
extern rtx        gen_fix_truncv8sfv8si2                   (rtx, rtx);
extern rtx        gen_fix_truncv4sfv4si2                   (rtx, rtx);
extern rtx        gen_sse2_cvtpi2pd                        (rtx, rtx);
extern rtx        gen_sse2_cvtpd2pi                        (rtx, rtx);
extern rtx        gen_sse2_cvttpd2pi                       (rtx, rtx);
extern rtx        gen_sse2_cvtsi2sd                        (rtx, rtx, rtx);
extern rtx        gen_sse2_cvtsi2sdq                       (rtx, rtx, rtx);
extern rtx        gen_sse2_cvtsd2si                        (rtx, rtx);
extern rtx        gen_sse2_cvtsd2si_2                      (rtx, rtx);
extern rtx        gen_sse2_cvtsd2siq                       (rtx, rtx);
extern rtx        gen_sse2_cvtsd2siq_2                     (rtx, rtx);
extern rtx        gen_sse2_cvttsd2si                       (rtx, rtx);
extern rtx        gen_sse2_cvttsd2siq                      (rtx, rtx);
extern rtx        gen_floatv4siv4df2                       (rtx, rtx);
extern rtx        gen_avx_cvtdq2pd256_2                    (rtx, rtx);
extern rtx        gen_sse2_cvtdq2pd                        (rtx, rtx);
extern rtx        gen_avx_cvtpd2dq256                      (rtx, rtx);
extern rtx        gen_fix_truncv4dfv4si2                   (rtx, rtx);
extern rtx        gen_sse2_cvtsd2ss                        (rtx, rtx, rtx);
extern rtx        gen_sse2_cvtss2sd                        (rtx, rtx, rtx);
extern rtx        gen_avx_cvtpd2ps256                      (rtx, rtx);
extern rtx        gen_avx_cvtps2pd256                      (rtx, rtx);
extern rtx        gen_sse2_cvtps2pd                        (rtx, rtx);
extern rtx        gen_sse_movhlps                          (rtx, rtx, rtx);
extern rtx        gen_sse_movlhps                          (rtx, rtx, rtx);
extern rtx        gen_avx_unpckhps256                      (rtx, rtx, rtx);
extern rtx        gen_vec_interleave_highv4sf              (rtx, rtx, rtx);
extern rtx        gen_avx_unpcklps256                      (rtx, rtx, rtx);
extern rtx        gen_vec_interleave_lowv4sf               (rtx, rtx, rtx);
extern rtx        gen_avx_movshdup256                      (rtx, rtx);
extern rtx        gen_sse3_movshdup                        (rtx, rtx);
extern rtx        gen_avx_movsldup256                      (rtx, rtx);
extern rtx        gen_sse3_movsldup                        (rtx, rtx);
extern rtx        gen_avx_shufps256_1                      (rtx, rtx, rtx, rtx, rtx, rtx, rtx, rtx, rtx, rtx, rtx);
extern rtx        gen_sse_shufps_v4si                      (rtx, rtx, rtx, rtx, rtx, rtx, rtx);
extern rtx        gen_sse_shufps_v4sf                      (rtx, rtx, rtx, rtx, rtx, rtx, rtx);
extern rtx        gen_sse_storehps                         (rtx, rtx);
extern rtx        gen_sse_loadhps                          (rtx, rtx, rtx);
extern rtx        gen_sse_storelps                         (rtx, rtx);
extern rtx        gen_sse_loadlps                          (rtx, rtx, rtx);
extern rtx        gen_sse_movss                            (rtx, rtx, rtx);
extern rtx        gen_avx2_vec_dupv8sf                     (rtx, rtx);
extern rtx        gen_avx2_vec_dupv4sf                     (rtx, rtx);
extern rtx        gen_vec_dupv4sf                          (rtx, rtx);
extern rtx        gen_vec_setv4si_0                        (rtx, rtx, rtx);
extern rtx        gen_vec_setv4sf_0                        (rtx, rtx, rtx);
extern rtx        gen_sse4_1_insertps                      (rtx, rtx, rtx, rtx);
extern rtx        gen_vec_extract_lo_v4di                  (rtx, rtx);
extern rtx        gen_vec_extract_lo_v4df                  (rtx, rtx);
extern rtx        gen_vec_extract_hi_v4di                  (rtx, rtx);
extern rtx        gen_vec_extract_hi_v4df                  (rtx, rtx);
extern rtx        gen_vec_extract_lo_v8si                  (rtx, rtx);
extern rtx        gen_vec_extract_lo_v8sf                  (rtx, rtx);
extern rtx        gen_vec_extract_hi_v8si                  (rtx, rtx);
extern rtx        gen_vec_extract_hi_v8sf                  (rtx, rtx);
extern rtx        gen_vec_extract_lo_v16hi                 (rtx, rtx);
extern rtx        gen_vec_extract_hi_v16hi                 (rtx, rtx);
extern rtx        gen_vec_extract_lo_v32qi                 (rtx, rtx);
extern rtx        gen_vec_extract_hi_v32qi                 (rtx, rtx);
extern rtx        gen_avx_unpckhpd256                      (rtx, rtx, rtx);
extern rtx        gen_avx_shufpd256_1                      (rtx, rtx, rtx, rtx, rtx, rtx, rtx);
extern rtx        gen_avx2_interleave_highv4di             (rtx, rtx, rtx);
extern rtx        gen_vec_interleave_highv2di              (rtx, rtx, rtx);
extern rtx        gen_avx2_interleave_lowv4di              (rtx, rtx, rtx);
extern rtx        gen_vec_interleave_lowv2di               (rtx, rtx, rtx);
extern rtx        gen_sse2_shufpd_v2di                     (rtx, rtx, rtx, rtx, rtx);
extern rtx        gen_sse2_shufpd_v2df                     (rtx, rtx, rtx, rtx, rtx);
extern rtx        gen_sse2_storehpd                        (rtx, rtx);
extern rtx        gen_sse2_storelpd                        (rtx, rtx);
extern rtx        gen_sse2_loadhpd                         (rtx, rtx, rtx);
extern rtx        gen_sse2_loadlpd                         (rtx, rtx, rtx);
extern rtx        gen_sse2_movsd                           (rtx, rtx, rtx);
extern rtx        gen_vec_dupv2df                          (rtx, rtx);
extern rtx        gen_mulv32qi3                            (rtx, rtx, rtx);
extern rtx        gen_mulv16qi3                            (rtx, rtx, rtx);
extern rtx        gen_mulv4di3                             (rtx, rtx, rtx);
extern rtx        gen_mulv2di3                             (rtx, rtx, rtx);
extern rtx        gen_ashrv16hi3                           (rtx, rtx, rtx);
extern rtx        gen_ashrv8hi3                            (rtx, rtx, rtx);
extern rtx        gen_ashrv8si3                            (rtx, rtx, rtx);
extern rtx        gen_ashrv4si3                            (rtx, rtx, rtx);
extern rtx        gen_ashlv16hi3                           (rtx, rtx, rtx);
extern rtx        gen_lshrv16hi3                           (rtx, rtx, rtx);
extern rtx        gen_ashlv8hi3                            (rtx, rtx, rtx);
extern rtx        gen_lshrv8hi3                            (rtx, rtx, rtx);
extern rtx        gen_ashlv8si3                            (rtx, rtx, rtx);
extern rtx        gen_lshrv8si3                            (rtx, rtx, rtx);
extern rtx        gen_ashlv4si3                            (rtx, rtx, rtx);
extern rtx        gen_lshrv4si3                            (rtx, rtx, rtx);
extern rtx        gen_ashlv4di3                            (rtx, rtx, rtx);
extern rtx        gen_lshrv4di3                            (rtx, rtx, rtx);
extern rtx        gen_ashlv2di3                            (rtx, rtx, rtx);
extern rtx        gen_lshrv2di3                            (rtx, rtx, rtx);
extern rtx        gen_avx2_ashlv2ti3                       (rtx, rtx, rtx);
extern rtx        gen_sse2_ashlv1ti3                       (rtx, rtx, rtx);
extern rtx        gen_avx2_lshrv2ti3                       (rtx, rtx, rtx);
extern rtx        gen_sse2_lshrv1ti3                       (rtx, rtx, rtx);
extern rtx        gen_sse4_2_gtv2di3                       (rtx, rtx, rtx);
extern rtx        gen_avx2_gtv32qi3                        (rtx, rtx, rtx);
extern rtx        gen_avx2_gtv16hi3                        (rtx, rtx, rtx);
extern rtx        gen_avx2_gtv8si3                         (rtx, rtx, rtx);
extern rtx        gen_avx2_gtv4di3                         (rtx, rtx, rtx);
extern rtx        gen_sse2_gtv16qi3                        (rtx, rtx, rtx);
extern rtx        gen_sse2_gtv8hi3                         (rtx, rtx, rtx);
extern rtx        gen_sse2_gtv4si3                         (rtx, rtx, rtx);
extern rtx        gen_avx2_packsswb                        (rtx, rtx, rtx);
extern rtx        gen_sse2_packsswb                        (rtx, rtx, rtx);
extern rtx        gen_avx2_packssdw                        (rtx, rtx, rtx);
extern rtx        gen_sse2_packssdw                        (rtx, rtx, rtx);
extern rtx        gen_avx2_packuswb                        (rtx, rtx, rtx);
extern rtx        gen_sse2_packuswb                        (rtx, rtx, rtx);
extern rtx        gen_avx2_interleave_highv32qi            (rtx, rtx, rtx);
extern rtx        gen_vec_interleave_highv16qi             (rtx, rtx, rtx);
extern rtx        gen_avx2_interleave_lowv32qi             (rtx, rtx, rtx);
extern rtx        gen_vec_interleave_lowv16qi              (rtx, rtx, rtx);
extern rtx        gen_avx2_interleave_highv16hi            (rtx, rtx, rtx);
extern rtx        gen_vec_interleave_highv8hi              (rtx, rtx, rtx);
extern rtx        gen_avx2_interleave_lowv16hi             (rtx, rtx, rtx);
extern rtx        gen_vec_interleave_lowv8hi               (rtx, rtx, rtx);
extern rtx        gen_avx2_interleave_highv8si             (rtx, rtx, rtx);
extern rtx        gen_vec_interleave_highv4si              (rtx, rtx, rtx);
extern rtx        gen_avx2_interleave_lowv8si              (rtx, rtx, rtx);
extern rtx        gen_vec_interleave_lowv4si               (rtx, rtx, rtx);
extern rtx        gen_sse4_1_pinsrb                        (rtx, rtx, rtx, rtx);
extern rtx        gen_sse2_pinsrw                          (rtx, rtx, rtx, rtx);
extern rtx        gen_sse4_1_pinsrd                        (rtx, rtx, rtx, rtx);
extern rtx        gen_sse4_1_pinsrq                        (rtx, rtx, rtx, rtx);
extern rtx        gen_avx2_pshufd_1                        (rtx, rtx, rtx, rtx, rtx, rtx, rtx, rtx, rtx, rtx);
extern rtx        gen_sse2_pshufd_1                        (rtx, rtx, rtx, rtx, rtx, rtx);
extern rtx        gen_avx2_pshuflw_1                       (rtx, rtx, rtx, rtx, rtx, rtx, rtx, rtx, rtx, rtx);
extern rtx        gen_sse2_pshuflw_1                       (rtx, rtx, rtx, rtx, rtx, rtx);
extern rtx        gen_avx2_pshufhw_1                       (rtx, rtx, rtx, rtx, rtx, rtx, rtx, rtx, rtx, rtx);
extern rtx        gen_sse2_pshufhw_1                       (rtx, rtx, rtx, rtx, rtx, rtx);
extern rtx        gen_sse2_loadld                          (rtx, rtx, rtx);
extern rtx        gen_sse2_stored                          (rtx, rtx);
extern rtx        gen_vec_concatv2di                       (rtx, rtx, rtx);
extern rtx        gen_avx2_psadbw                          (rtx, rtx, rtx);
extern rtx        gen_sse2_psadbw                          (rtx, rtx, rtx);
extern rtx        gen_avx_movmskps256                      (rtx, rtx);
extern rtx        gen_sse_movmskps                         (rtx, rtx);
extern rtx        gen_avx_movmskpd256                      (rtx, rtx);
extern rtx        gen_sse2_movmskpd                        (rtx, rtx);
extern rtx        gen_avx2_pmovmskb                        (rtx, rtx);
extern rtx        gen_sse2_pmovmskb                        (rtx, rtx);
extern rtx        gen_sse_ldmxcsr                          (rtx);
extern rtx        gen_sse_stmxcsr                          (rtx);
extern rtx        gen_sse2_clflush                         (rtx);
extern rtx        gen_sse3_mwait                           (rtx, rtx);
extern rtx        gen_sse3_monitor                         (rtx, rtx, rtx);
extern rtx        gen_sse3_monitor64                       (rtx, rtx, rtx);
extern rtx        gen_avx2_phaddwv16hi3                    (rtx, rtx, rtx);
extern rtx        gen_ssse3_phaddwv8hi3                    (rtx, rtx, rtx);
extern rtx        gen_ssse3_phaddwv4hi3                    (rtx, rtx, rtx);
extern rtx        gen_avx2_phadddv8si3                     (rtx, rtx, rtx);
extern rtx        gen_ssse3_phadddv4si3                    (rtx, rtx, rtx);
extern rtx        gen_ssse3_phadddv2si3                    (rtx, rtx, rtx);
extern rtx        gen_avx2_phaddswv16hi3                   (rtx, rtx, rtx);
extern rtx        gen_ssse3_phaddswv8hi3                   (rtx, rtx, rtx);
extern rtx        gen_ssse3_phaddswv4hi3                   (rtx, rtx, rtx);
extern rtx        gen_avx2_phsubwv16hi3                    (rtx, rtx, rtx);
extern rtx        gen_ssse3_phsubwv8hi3                    (rtx, rtx, rtx);
extern rtx        gen_ssse3_phsubwv4hi3                    (rtx, rtx, rtx);
extern rtx        gen_avx2_phsubdv8si3                     (rtx, rtx, rtx);
extern rtx        gen_ssse3_phsubdv4si3                    (rtx, rtx, rtx);
extern rtx        gen_ssse3_phsubdv2si3                    (rtx, rtx, rtx);
extern rtx        gen_avx2_phsubswv16hi3                   (rtx, rtx, rtx);
extern rtx        gen_ssse3_phsubswv8hi3                   (rtx, rtx, rtx);
extern rtx        gen_ssse3_phsubswv4hi3                   (rtx, rtx, rtx);
extern rtx        gen_avx2_pmaddubsw256                    (rtx, rtx, rtx);
extern rtx        gen_ssse3_pmaddubsw128                   (rtx, rtx, rtx);
extern rtx        gen_ssse3_pmaddubsw                      (rtx, rtx, rtx);
extern rtx        gen_avx2_pshufbv32qi3                    (rtx, rtx, rtx);
extern rtx        gen_ssse3_pshufbv16qi3                   (rtx, rtx, rtx);
extern rtx        gen_ssse3_pshufbv8qi3                    (rtx, rtx, rtx);
extern rtx        gen_avx2_psignv32qi3                     (rtx, rtx, rtx);
extern rtx        gen_ssse3_psignv16qi3                    (rtx, rtx, rtx);
extern rtx        gen_avx2_psignv16hi3                     (rtx, rtx, rtx);
extern rtx        gen_ssse3_psignv8hi3                     (rtx, rtx, rtx);
extern rtx        gen_avx2_psignv8si3                      (rtx, rtx, rtx);
extern rtx        gen_ssse3_psignv4si3                     (rtx, rtx, rtx);
extern rtx        gen_ssse3_psignv8qi3                     (rtx, rtx, rtx);
extern rtx        gen_ssse3_psignv4hi3                     (rtx, rtx, rtx);
extern rtx        gen_ssse3_psignv2si3                     (rtx, rtx, rtx);
extern rtx        gen_avx2_palignrv2ti                     (rtx, rtx, rtx, rtx);
extern rtx        gen_ssse3_palignrti                      (rtx, rtx, rtx, rtx);
extern rtx        gen_ssse3_palignrdi                      (rtx, rtx, rtx, rtx);
extern rtx        gen_absv32qi2                            (rtx, rtx);
extern rtx        gen_absv16qi2                            (rtx, rtx);
extern rtx        gen_absv16hi2                            (rtx, rtx);
extern rtx        gen_absv8hi2                             (rtx, rtx);
extern rtx        gen_absv8si2                             (rtx, rtx);
extern rtx        gen_absv4si2                             (rtx, rtx);
extern rtx        gen_absv8qi2                             (rtx, rtx);
extern rtx        gen_absv4hi2                             (rtx, rtx);
extern rtx        gen_absv2si2                             (rtx, rtx);
extern rtx        gen_sse4a_movntsf                        (rtx, rtx);
extern rtx        gen_sse4a_movntdf                        (rtx, rtx);
extern rtx        gen_sse4a_vmmovntv4sf                    (rtx, rtx);
extern rtx        gen_sse4a_vmmovntv2df                    (rtx, rtx);
extern rtx        gen_sse4a_extrqi                         (rtx, rtx, rtx, rtx);
extern rtx        gen_sse4a_extrq                          (rtx, rtx, rtx);
extern rtx        gen_sse4a_insertqi                       (rtx, rtx, rtx, rtx, rtx);
extern rtx        gen_sse4a_insertq                        (rtx, rtx, rtx);
extern rtx        gen_avx_blendps256                       (rtx, rtx, rtx, rtx);
extern rtx        gen_sse4_1_blendps                       (rtx, rtx, rtx, rtx);
extern rtx        gen_avx_blendpd256                       (rtx, rtx, rtx, rtx);
extern rtx        gen_sse4_1_blendpd                       (rtx, rtx, rtx, rtx);
extern rtx        gen_avx_blendvps256                      (rtx, rtx, rtx, rtx);
extern rtx        gen_sse4_1_blendvps                      (rtx, rtx, rtx, rtx);
extern rtx        gen_avx_blendvpd256                      (rtx, rtx, rtx, rtx);
extern rtx        gen_sse4_1_blendvpd                      (rtx, rtx, rtx, rtx);
extern rtx        gen_avx_dpps256                          (rtx, rtx, rtx, rtx);
extern rtx        gen_sse4_1_dpps                          (rtx, rtx, rtx, rtx);
extern rtx        gen_avx_dppd256                          (rtx, rtx, rtx, rtx);
extern rtx        gen_sse4_1_dppd                          (rtx, rtx, rtx, rtx);
extern rtx        gen_avx2_movntdqa                        (rtx, rtx);
extern rtx        gen_sse4_1_movntdqa                      (rtx, rtx);
extern rtx        gen_avx2_mpsadbw                         (rtx, rtx, rtx, rtx);
extern rtx        gen_sse4_1_mpsadbw                       (rtx, rtx, rtx, rtx);
extern rtx        gen_avx2_packusdw                        (rtx, rtx, rtx);
extern rtx        gen_sse4_1_packusdw                      (rtx, rtx, rtx);
extern rtx        gen_avx2_pblendvb                        (rtx, rtx, rtx, rtx);
extern rtx        gen_sse4_1_pblendvb                      (rtx, rtx, rtx, rtx);
extern rtx        gen_sse4_1_pblendw                       (rtx, rtx, rtx, rtx);
extern rtx        gen_avx2_pblenddv8si                     (rtx, rtx, rtx, rtx);
extern rtx        gen_avx2_pblenddv4si                     (rtx, rtx, rtx, rtx);
extern rtx        gen_sse4_1_phminposuw                    (rtx, rtx);
extern rtx        gen_avx2_sign_extendv16qiv16hi2          (rtx, rtx);
extern rtx        gen_avx2_zero_extendv16qiv16hi2          (rtx, rtx);
extern rtx        gen_sse4_1_sign_extendv8qiv8hi2          (rtx, rtx);
extern rtx        gen_sse4_1_zero_extendv8qiv8hi2          (rtx, rtx);
extern rtx        gen_avx2_sign_extendv8qiv8si2            (rtx, rtx);
extern rtx        gen_avx2_zero_extendv8qiv8si2            (rtx, rtx);
extern rtx        gen_sse4_1_sign_extendv4qiv4si2          (rtx, rtx);
extern rtx        gen_sse4_1_zero_extendv4qiv4si2          (rtx, rtx);
extern rtx        gen_avx2_sign_extendv8hiv8si2            (rtx, rtx);
extern rtx        gen_avx2_zero_extendv8hiv8si2            (rtx, rtx);
extern rtx        gen_sse4_1_sign_extendv4hiv4si2          (rtx, rtx);
extern rtx        gen_sse4_1_zero_extendv4hiv4si2          (rtx, rtx);
extern rtx        gen_avx2_sign_extendv4qiv4di2            (rtx, rtx);
extern rtx        gen_avx2_zero_extendv4qiv4di2            (rtx, rtx);
extern rtx        gen_sse4_1_sign_extendv2qiv2di2          (rtx, rtx);
extern rtx        gen_sse4_1_zero_extendv2qiv2di2          (rtx, rtx);
extern rtx        gen_avx2_sign_extendv4hiv4di2            (rtx, rtx);
extern rtx        gen_avx2_zero_extendv4hiv4di2            (rtx, rtx);
extern rtx        gen_sse4_1_sign_extendv2hiv2di2          (rtx, rtx);
extern rtx        gen_sse4_1_zero_extendv2hiv2di2          (rtx, rtx);
extern rtx        gen_avx2_sign_extendv4siv4di2            (rtx, rtx);
extern rtx        gen_avx2_zero_extendv4siv4di2            (rtx, rtx);
extern rtx        gen_sse4_1_sign_extendv2siv2di2          (rtx, rtx);
extern rtx        gen_sse4_1_zero_extendv2siv2di2          (rtx, rtx);
extern rtx        gen_avx_vtestps256                       (rtx, rtx);
extern rtx        gen_avx_vtestps                          (rtx, rtx);
extern rtx        gen_avx_vtestpd256                       (rtx, rtx);
extern rtx        gen_avx_vtestpd                          (rtx, rtx);
extern rtx        gen_avx_ptest256                         (rtx, rtx);
extern rtx        gen_sse4_1_ptest                         (rtx, rtx);
extern rtx        gen_avx_roundps256                       (rtx, rtx, rtx);
extern rtx        gen_sse4_1_roundps                       (rtx, rtx, rtx);
extern rtx        gen_avx_roundpd256                       (rtx, rtx, rtx);
extern rtx        gen_sse4_1_roundpd                       (rtx, rtx, rtx);
extern rtx        gen_sse4_1_roundss                       (rtx, rtx, rtx, rtx);
extern rtx        gen_sse4_1_roundsd                       (rtx, rtx, rtx, rtx);
extern rtx        gen_sse4_2_pcmpestr                      (rtx, rtx, rtx, rtx, rtx, rtx, rtx);
extern rtx        gen_sse4_2_pcmpestri                     (rtx, rtx, rtx, rtx, rtx, rtx);
extern rtx        gen_sse4_2_pcmpestrm                     (rtx, rtx, rtx, rtx, rtx, rtx);
extern rtx        gen_sse4_2_pcmpestr_cconly               (rtx, rtx, rtx, rtx, rtx, rtx, rtx);
extern rtx        gen_sse4_2_pcmpistr                      (rtx, rtx, rtx, rtx, rtx);
extern rtx        gen_sse4_2_pcmpistri                     (rtx, rtx, rtx, rtx);
extern rtx        gen_sse4_2_pcmpistrm                     (rtx, rtx, rtx, rtx);
extern rtx        gen_sse4_2_pcmpistr_cconly               (rtx, rtx, rtx, rtx, rtx);
extern rtx        gen_xop_pmacsww                          (rtx, rtx, rtx, rtx);
extern rtx        gen_xop_pmacssww                         (rtx, rtx, rtx, rtx);
extern rtx        gen_xop_pmacsdd                          (rtx, rtx, rtx, rtx);
extern rtx        gen_xop_pmacssdd                         (rtx, rtx, rtx, rtx);
extern rtx        gen_xop_pmacssdql                        (rtx, rtx, rtx, rtx);
extern rtx        gen_xop_pmacssdqh                        (rtx, rtx, rtx, rtx);
extern rtx        gen_xop_pmacsdql                         (rtx, rtx, rtx, rtx);
extern rtx        gen_xop_pmacsdqh                         (rtx, rtx, rtx, rtx);
extern rtx        gen_xop_pmacsswd                         (rtx, rtx, rtx, rtx);
extern rtx        gen_xop_pmacswd                          (rtx, rtx, rtx, rtx);
extern rtx        gen_xop_pmadcsswd                        (rtx, rtx, rtx, rtx);
extern rtx        gen_xop_pmadcswd                         (rtx, rtx, rtx, rtx);
extern rtx        gen_xop_pcmov_v32qi256                   (rtx, rtx, rtx, rtx);
extern rtx        gen_xop_pcmov_v16qi                      (rtx, rtx, rtx, rtx);
extern rtx        gen_xop_pcmov_v16hi256                   (rtx, rtx, rtx, rtx);
extern rtx        gen_xop_pcmov_v8hi                       (rtx, rtx, rtx, rtx);
extern rtx        gen_xop_pcmov_v8si256                    (rtx, rtx, rtx, rtx);
extern rtx        gen_xop_pcmov_v4si                       (rtx, rtx, rtx, rtx);
extern rtx        gen_xop_pcmov_v4di256                    (rtx, rtx, rtx, rtx);
extern rtx        gen_xop_pcmov_v2di                       (rtx, rtx, rtx, rtx);
extern rtx        gen_xop_pcmov_v8sf256                    (rtx, rtx, rtx, rtx);
extern rtx        gen_xop_pcmov_v4sf                       (rtx, rtx, rtx, rtx);
extern rtx        gen_xop_pcmov_v4df256                    (rtx, rtx, rtx, rtx);
extern rtx        gen_xop_pcmov_v2df                       (rtx, rtx, rtx, rtx);
extern rtx        gen_xop_phaddbw                          (rtx, rtx);
extern rtx        gen_xop_phaddbd                          (rtx, rtx);
extern rtx        gen_xop_phaddbq                          (rtx, rtx);
extern rtx        gen_xop_phaddwd                          (rtx, rtx);
extern rtx        gen_xop_phaddwq                          (rtx, rtx);
extern rtx        gen_xop_phadddq                          (rtx, rtx);
extern rtx        gen_xop_phaddubw                         (rtx, rtx);
extern rtx        gen_xop_phaddubd                         (rtx, rtx);
extern rtx        gen_xop_phaddubq                         (rtx, rtx);
extern rtx        gen_xop_phadduwd                         (rtx, rtx);
extern rtx        gen_xop_phadduwq                         (rtx, rtx);
extern rtx        gen_xop_phaddudq                         (rtx, rtx);
extern rtx        gen_xop_phsubbw                          (rtx, rtx);
extern rtx        gen_xop_phsubwd                          (rtx, rtx);
extern rtx        gen_xop_phsubdq                          (rtx, rtx);
extern rtx        gen_xop_pperm                            (rtx, rtx, rtx, rtx);
extern rtx        gen_xop_pperm_pack_v2di_v4si             (rtx, rtx, rtx, rtx);
extern rtx        gen_xop_pperm_pack_v4si_v8hi             (rtx, rtx, rtx, rtx);
extern rtx        gen_xop_pperm_pack_v8hi_v16qi            (rtx, rtx, rtx, rtx);
extern rtx        gen_xop_rotlv16qi3                       (rtx, rtx, rtx);
extern rtx        gen_xop_rotlv8hi3                        (rtx, rtx, rtx);
extern rtx        gen_xop_rotlv4si3                        (rtx, rtx, rtx);
extern rtx        gen_xop_rotlv2di3                        (rtx, rtx, rtx);
extern rtx        gen_xop_rotrv16qi3                       (rtx, rtx, rtx);
extern rtx        gen_xop_rotrv8hi3                        (rtx, rtx, rtx);
extern rtx        gen_xop_rotrv4si3                        (rtx, rtx, rtx);
extern rtx        gen_xop_rotrv2di3                        (rtx, rtx, rtx);
extern rtx        gen_xop_vrotlv16qi3                      (rtx, rtx, rtx);
extern rtx        gen_xop_vrotlv8hi3                       (rtx, rtx, rtx);
extern rtx        gen_xop_vrotlv4si3                       (rtx, rtx, rtx);
extern rtx        gen_xop_vrotlv2di3                       (rtx, rtx, rtx);
extern rtx        gen_xop_shav16qi3                        (rtx, rtx, rtx);
extern rtx        gen_xop_shav8hi3                         (rtx, rtx, rtx);
extern rtx        gen_xop_shav4si3                         (rtx, rtx, rtx);
extern rtx        gen_xop_shav2di3                         (rtx, rtx, rtx);
extern rtx        gen_xop_shlv16qi3                        (rtx, rtx, rtx);
extern rtx        gen_xop_shlv8hi3                         (rtx, rtx, rtx);
extern rtx        gen_xop_shlv4si3                         (rtx, rtx, rtx);
extern rtx        gen_xop_shlv2di3                         (rtx, rtx, rtx);
extern rtx        gen_xop_frczsf2                          (rtx, rtx);
extern rtx        gen_xop_frczdf2                          (rtx, rtx);
extern rtx        gen_xop_frczv4sf2                        (rtx, rtx);
extern rtx        gen_xop_frczv2df2                        (rtx, rtx);
extern rtx        gen_xop_frczv8sf2                        (rtx, rtx);
extern rtx        gen_xop_frczv4df2                        (rtx, rtx);
extern rtx        gen_xop_maskcmpv16qi3                    (rtx, rtx, rtx, rtx);
extern rtx        gen_xop_maskcmpv8hi3                     (rtx, rtx, rtx, rtx);
extern rtx        gen_xop_maskcmpv4si3                     (rtx, rtx, rtx, rtx);
extern rtx        gen_xop_maskcmpv2di3                     (rtx, rtx, rtx, rtx);
extern rtx        gen_xop_maskcmp_unsv16qi3                (rtx, rtx, rtx, rtx);
extern rtx        gen_xop_maskcmp_unsv8hi3                 (rtx, rtx, rtx, rtx);
extern rtx        gen_xop_maskcmp_unsv4si3                 (rtx, rtx, rtx, rtx);
extern rtx        gen_xop_maskcmp_unsv2di3                 (rtx, rtx, rtx, rtx);
extern rtx        gen_xop_maskcmp_uns2v16qi3               (rtx, rtx, rtx, rtx);
extern rtx        gen_xop_maskcmp_uns2v8hi3                (rtx, rtx, rtx, rtx);
extern rtx        gen_xop_maskcmp_uns2v4si3                (rtx, rtx, rtx, rtx);
extern rtx        gen_xop_maskcmp_uns2v2di3                (rtx, rtx, rtx, rtx);
extern rtx        gen_xop_pcom_tfv16qi3                    (rtx, rtx, rtx, rtx);
extern rtx        gen_xop_pcom_tfv8hi3                     (rtx, rtx, rtx, rtx);
extern rtx        gen_xop_pcom_tfv4si3                     (rtx, rtx, rtx, rtx);
extern rtx        gen_xop_pcom_tfv2di3                     (rtx, rtx, rtx, rtx);
extern rtx        gen_xop_vpermil2v8sf3                    (rtx, rtx, rtx, rtx, rtx);
extern rtx        gen_xop_vpermil2v4sf3                    (rtx, rtx, rtx, rtx, rtx);
extern rtx        gen_xop_vpermil2v4df3                    (rtx, rtx, rtx, rtx, rtx);
extern rtx        gen_xop_vpermil2v2df3                    (rtx, rtx, rtx, rtx, rtx);
extern rtx        gen_aesenc                               (rtx, rtx, rtx);
extern rtx        gen_aesenclast                           (rtx, rtx, rtx);
extern rtx        gen_aesdec                               (rtx, rtx, rtx);
extern rtx        gen_aesdeclast                           (rtx, rtx, rtx);
extern rtx        gen_aesimc                               (rtx, rtx);
extern rtx        gen_aeskeygenassist                      (rtx, rtx, rtx);
extern rtx        gen_pclmulqdq                            (rtx, rtx, rtx, rtx);
extern rtx        gen_avx_vzeroupper                       (rtx);
extern rtx        gen_avx2_pbroadcastv32qi                 (rtx, rtx);
extern rtx        gen_avx2_pbroadcastv16qi                 (rtx, rtx);
extern rtx        gen_avx2_pbroadcastv16hi                 (rtx, rtx);
extern rtx        gen_avx2_pbroadcastv8hi                  (rtx, rtx);
extern rtx        gen_avx2_pbroadcastv8si                  (rtx, rtx);
extern rtx        gen_avx2_pbroadcastv4si                  (rtx, rtx);
extern rtx        gen_avx2_pbroadcastv4di                  (rtx, rtx);
extern rtx        gen_avx2_pbroadcastv2di                  (rtx, rtx);
extern rtx        gen_avx2_permvarv8si                     (rtx, rtx, rtx);
extern rtx        gen_avx2_permv4df                        (rtx, rtx, rtx);
extern rtx        gen_avx2_permvarv8sf                     (rtx, rtx, rtx);
extern rtx        gen_avx2_permv4di_1                      (rtx, rtx, rtx, rtx, rtx, rtx);
extern rtx        gen_avx2_permv2ti                        (rtx, rtx, rtx, rtx);
extern rtx        gen_avx2_vec_dupv4df                     (rtx, rtx);
extern rtx        gen_vec_dupv8si                          (rtx, rtx);
extern rtx        gen_vec_dupv8sf                          (rtx, rtx);
extern rtx        gen_vec_dupv4di                          (rtx, rtx);
extern rtx        gen_vec_dupv4df                          (rtx, rtx);
extern rtx        gen_avx2_vbroadcasti128_v32qi            (rtx, rtx);
extern rtx        gen_avx2_vbroadcasti128_v16hi            (rtx, rtx);
extern rtx        gen_avx2_vbroadcasti128_v8si             (rtx, rtx);
extern rtx        gen_avx2_vbroadcasti128_v4di             (rtx, rtx);
extern rtx        gen_avx_vbroadcastf128_v32qi             (rtx, rtx);
extern rtx        gen_avx_vbroadcastf128_v16hi             (rtx, rtx);
extern rtx        gen_avx_vbroadcastf128_v8si              (rtx, rtx);
extern rtx        gen_avx_vbroadcastf128_v4di              (rtx, rtx);
extern rtx        gen_avx_vbroadcastf128_v8sf              (rtx, rtx);
extern rtx        gen_avx_vbroadcastf128_v4df              (rtx, rtx);
extern rtx        gen_avx_vpermilvarv8sf3                  (rtx, rtx, rtx);
extern rtx        gen_avx_vpermilvarv4sf3                  (rtx, rtx, rtx);
extern rtx        gen_avx_vpermilvarv4df3                  (rtx, rtx, rtx);
extern rtx        gen_avx_vpermilvarv2df3                  (rtx, rtx, rtx);
extern rtx        gen_avx2_vec_set_lo_v4di                 (rtx, rtx, rtx);
extern rtx        gen_avx2_vec_set_hi_v4di                 (rtx, rtx, rtx);
extern rtx        gen_vec_set_lo_v4di                      (rtx, rtx, rtx);
extern rtx        gen_vec_set_lo_v4df                      (rtx, rtx, rtx);
extern rtx        gen_vec_set_hi_v4di                      (rtx, rtx, rtx);
extern rtx        gen_vec_set_hi_v4df                      (rtx, rtx, rtx);
extern rtx        gen_vec_set_lo_v8si                      (rtx, rtx, rtx);
extern rtx        gen_vec_set_lo_v8sf                      (rtx, rtx, rtx);
extern rtx        gen_vec_set_hi_v8si                      (rtx, rtx, rtx);
extern rtx        gen_vec_set_hi_v8sf                      (rtx, rtx, rtx);
extern rtx        gen_vec_set_lo_v16hi                     (rtx, rtx, rtx);
extern rtx        gen_vec_set_hi_v16hi                     (rtx, rtx, rtx);
extern rtx        gen_vec_set_lo_v32qi                     (rtx, rtx, rtx);
extern rtx        gen_vec_set_hi_v32qi                     (rtx, rtx, rtx);
extern rtx        gen_avx_maskloadps                       (rtx, rtx, rtx);
extern rtx        gen_avx_maskloadpd                       (rtx, rtx, rtx);
extern rtx        gen_avx_maskloadps256                    (rtx, rtx, rtx);
extern rtx        gen_avx_maskloadpd256                    (rtx, rtx, rtx);
extern rtx        gen_avx2_maskloadd                       (rtx, rtx, rtx);
extern rtx        gen_avx2_maskloadq                       (rtx, rtx, rtx);
extern rtx        gen_avx2_maskloadd256                    (rtx, rtx, rtx);
extern rtx        gen_avx2_maskloadq256                    (rtx, rtx, rtx);
extern rtx        gen_avx_maskstoreps                      (rtx, rtx, rtx);
extern rtx        gen_avx_maskstorepd                      (rtx, rtx, rtx);
extern rtx        gen_avx_maskstoreps256                   (rtx, rtx, rtx);
extern rtx        gen_avx_maskstorepd256                   (rtx, rtx, rtx);
extern rtx        gen_avx2_maskstored                      (rtx, rtx, rtx);
extern rtx        gen_avx2_maskstoreq                      (rtx, rtx, rtx);
extern rtx        gen_avx2_maskstored256                   (rtx, rtx, rtx);
extern rtx        gen_avx2_maskstoreq256                   (rtx, rtx, rtx);
extern rtx        gen_avx_si256_si                         (rtx, rtx);
extern rtx        gen_avx_ps256_ps                         (rtx, rtx);
extern rtx        gen_avx_pd256_pd                         (rtx, rtx);
extern rtx        gen_avx2_ashrvv8si                       (rtx, rtx, rtx);
extern rtx        gen_avx2_ashrvv4si                       (rtx, rtx, rtx);
extern rtx        gen_avx2_ashlvv8si                       (rtx, rtx, rtx);
extern rtx        gen_avx2_lshrvv8si                       (rtx, rtx, rtx);
extern rtx        gen_avx2_ashlvv4si                       (rtx, rtx, rtx);
extern rtx        gen_avx2_lshrvv4si                       (rtx, rtx, rtx);
extern rtx        gen_avx2_ashlvv4di                       (rtx, rtx, rtx);
extern rtx        gen_avx2_lshrvv4di                       (rtx, rtx, rtx);
extern rtx        gen_avx2_ashlvv2di                       (rtx, rtx, rtx);
extern rtx        gen_avx2_lshrvv2di                       (rtx, rtx, rtx);
extern rtx        gen_avx_vec_concatv32qi                  (rtx, rtx, rtx);
extern rtx        gen_avx_vec_concatv16hi                  (rtx, rtx, rtx);
extern rtx        gen_avx_vec_concatv8si                   (rtx, rtx, rtx);
extern rtx        gen_avx_vec_concatv4di                   (rtx, rtx, rtx);
extern rtx        gen_avx_vec_concatv8sf                   (rtx, rtx, rtx);
extern rtx        gen_avx_vec_concatv4df                   (rtx, rtx, rtx);
extern rtx        gen_vcvtph2ps                            (rtx, rtx);
extern rtx        gen_vcvtph2ps256                         (rtx, rtx);
extern rtx        gen_vcvtps2ph256                         (rtx, rtx, rtx);
extern rtx        gen_mfence_sse2                          (rtx);
extern rtx        gen_mfence_nosse                         (rtx);
extern rtx        gen_atomic_loaddi_fpu                    (rtx, rtx, rtx);
extern rtx        gen_atomic_storeqi_1                     (rtx, rtx, rtx);
extern rtx        gen_atomic_storehi_1                     (rtx, rtx, rtx);
extern rtx        gen_atomic_storesi_1                     (rtx, rtx, rtx);
extern rtx        gen_atomic_storedi_1                     (rtx, rtx, rtx);
extern rtx        gen_atomic_storedi_fpu                   (rtx, rtx, rtx);
extern rtx        gen_loaddi_via_fpu                       (rtx, rtx);
extern rtx        gen_storedi_via_fpu                      (rtx, rtx);
extern rtx        gen_atomic_compare_and_swapqi_1          (rtx, rtx, rtx, rtx);
extern rtx        gen_atomic_compare_and_swaphi_1          (rtx, rtx, rtx, rtx);
extern rtx        gen_atomic_compare_and_swapsi_1          (rtx, rtx, rtx, rtx);
extern rtx        gen_atomic_compare_and_swapdi_1          (rtx, rtx, rtx, rtx);
extern rtx        gen_atomic_compare_and_swapdi_doubleword (rtx, rtx, rtx, rtx, rtx, rtx, rtx);
extern rtx        gen_atomic_compare_and_swapti_doubleword (rtx, rtx, rtx, rtx, rtx, rtx, rtx);
extern rtx        gen_atomic_fetch_addqi                   (rtx, rtx, rtx, rtx);
extern rtx        gen_atomic_fetch_addhi                   (rtx, rtx, rtx, rtx);
extern rtx        gen_atomic_fetch_addsi                   (rtx, rtx, rtx, rtx);
extern rtx        gen_atomic_fetch_adddi                   (rtx, rtx, rtx, rtx);
extern rtx        gen_atomic_exchangeqi                    (rtx, rtx, rtx, rtx);
extern rtx        gen_atomic_exchangehi                    (rtx, rtx, rtx, rtx);
extern rtx        gen_atomic_exchangesi                    (rtx, rtx, rtx, rtx);
extern rtx        gen_atomic_exchangedi                    (rtx, rtx, rtx, rtx);
extern rtx        gen_atomic_addqi                         (rtx, rtx, rtx);
extern rtx        gen_atomic_addhi                         (rtx, rtx, rtx);
extern rtx        gen_atomic_addsi                         (rtx, rtx, rtx);
extern rtx        gen_atomic_adddi                         (rtx, rtx, rtx);
extern rtx        gen_atomic_subqi                         (rtx, rtx, rtx);
extern rtx        gen_atomic_subhi                         (rtx, rtx, rtx);
extern rtx        gen_atomic_subsi                         (rtx, rtx, rtx);
extern rtx        gen_atomic_subdi                         (rtx, rtx, rtx);
extern rtx        gen_atomic_andqi                         (rtx, rtx, rtx);
extern rtx        gen_atomic_orqi                          (rtx, rtx, rtx);
extern rtx        gen_atomic_xorqi                         (rtx, rtx, rtx);
extern rtx        gen_atomic_andhi                         (rtx, rtx, rtx);
extern rtx        gen_atomic_orhi                          (rtx, rtx, rtx);
extern rtx        gen_atomic_xorhi                         (rtx, rtx, rtx);
extern rtx        gen_atomic_andsi                         (rtx, rtx, rtx);
extern rtx        gen_atomic_orsi                          (rtx, rtx, rtx);
extern rtx        gen_atomic_xorsi                         (rtx, rtx, rtx);
extern rtx        gen_atomic_anddi                         (rtx, rtx, rtx);
extern rtx        gen_atomic_ordi                          (rtx, rtx, rtx);
extern rtx        gen_atomic_xordi                         (rtx, rtx, rtx);
extern rtx        gen_cbranchqi4                           (rtx, rtx, rtx, rtx);
extern rtx        gen_cbranchhi4                           (rtx, rtx, rtx, rtx);
extern rtx        gen_cbranchsi4                           (rtx, rtx, rtx, rtx);
extern rtx        gen_cbranchdi4                           (rtx, rtx, rtx, rtx);
extern rtx        gen_cbranchti4                           (rtx, rtx, rtx, rtx);
extern rtx        gen_cstoreqi4                            (rtx, rtx, rtx, rtx);
extern rtx        gen_cstorehi4                            (rtx, rtx, rtx, rtx);
extern rtx        gen_cstoresi4                            (rtx, rtx, rtx, rtx);
extern rtx        gen_cstoredi4                            (rtx, rtx, rtx, rtx);
extern rtx        gen_cmpsi_1                              (rtx, rtx);
extern rtx        gen_cmpdi_1                              (rtx, rtx);
extern rtx        gen_cmpqi_ext_3                          (rtx, rtx);
extern rtx        gen_cbranchxf4                           (rtx, rtx, rtx, rtx);
extern rtx        gen_cstorexf4                            (rtx, rtx, rtx, rtx);
extern rtx        gen_cbranchsf4                           (rtx, rtx, rtx, rtx);
extern rtx        gen_cbranchdf4                           (rtx, rtx, rtx, rtx);
extern rtx        gen_cstoresf4                            (rtx, rtx, rtx, rtx);
extern rtx        gen_cstoredf4                            (rtx, rtx, rtx, rtx);
extern rtx        gen_cbranchcc4                           (rtx, rtx, rtx, rtx);
extern rtx        gen_cstorecc4                            (rtx, rtx, rtx, rtx);
extern rtx        gen_movoi                                (rtx, rtx);
extern rtx        gen_movti                                (rtx, rtx);
extern rtx        gen_movcdi                               (rtx, rtx);
extern rtx        gen_movqi                                (rtx, rtx);
extern rtx        gen_movhi                                (rtx, rtx);
extern rtx        gen_movsi                                (rtx, rtx);
extern rtx        gen_movdi                                (rtx, rtx);
extern rtx        gen_reload_noff_store                    (rtx, rtx, rtx);
extern rtx        gen_reload_noff_load                     (rtx, rtx, rtx);
extern rtx        gen_movstrictqi                          (rtx, rtx);
extern rtx        gen_movstricthi                          (rtx, rtx);
extern rtx        gen_movsi_insv_1                         (rtx, rtx);
extern rtx        gen_movdi_insv_1                         (rtx, rtx);
extern rtx        gen_movtf                                (rtx, rtx);
extern rtx        gen_movsf                                (rtx, rtx);
extern rtx        gen_movdf                                (rtx, rtx);
extern rtx        gen_movxf                                (rtx, rtx);
extern rtx        gen_zero_extendsidi2                     (rtx, rtx);
extern rtx        gen_zero_extendhisi2                     (rtx, rtx);
extern rtx        gen_zero_extendqihi2                     (rtx, rtx);
extern rtx        gen_zero_extendqisi2                     (rtx, rtx);
extern rtx        gen_extendsidi2                          (rtx, rtx);
extern rtx        gen_extendsfdf2                          (rtx, rtx);
extern rtx        gen_extendsfxf2                          (rtx, rtx);
extern rtx        gen_extenddfxf2                          (rtx, rtx);
extern rtx        gen_truncdfsf2                           (rtx, rtx);
extern rtx        gen_truncdfsf2_with_temp                 (rtx, rtx, rtx);
extern rtx        gen_truncxfsf2                           (rtx, rtx);
extern rtx        gen_truncxfdf2                           (rtx, rtx);
extern rtx        gen_fix_truncxfdi2                       (rtx, rtx);
extern rtx        gen_fix_truncsfdi2                       (rtx, rtx);
extern rtx        gen_fix_truncdfdi2                       (rtx, rtx);
extern rtx        gen_fix_truncxfsi2                       (rtx, rtx);
extern rtx        gen_fix_truncsfsi2                       (rtx, rtx);
extern rtx        gen_fix_truncdfsi2                       (rtx, rtx);
extern rtx        gen_fix_truncsfhi2                       (rtx, rtx);
extern rtx        gen_fix_truncdfhi2                       (rtx, rtx);
extern rtx        gen_fix_truncxfhi2                       (rtx, rtx);
extern rtx        gen_fixuns_truncsfsi2                    (rtx, rtx);
extern rtx        gen_fixuns_truncdfsi2                    (rtx, rtx);
extern rtx        gen_fixuns_truncsfhi2                    (rtx, rtx);
extern rtx        gen_fixuns_truncdfhi2                    (rtx, rtx);
extern rtx        gen_floathisf2                           (rtx, rtx);
extern rtx        gen_floathidf2                           (rtx, rtx);
extern rtx        gen_floathixf2                           (rtx, rtx);
extern rtx        gen_floatsisf2                           (rtx, rtx);
extern rtx        gen_floatsidf2                           (rtx, rtx);
extern rtx        gen_floatsixf2                           (rtx, rtx);
extern rtx        gen_floatdisf2                           (rtx, rtx);
extern rtx        gen_floatdidf2                           (rtx, rtx);
extern rtx        gen_floatdixf2                           (rtx, rtx);
extern rtx        gen_floatunssisf2                        (rtx, rtx);
extern rtx        gen_floatunssidf2                        (rtx, rtx);
extern rtx        gen_floatunssixf2                        (rtx, rtx);
extern rtx        gen_floatunsdisf2                        (rtx, rtx);
extern rtx        gen_floatunsdidf2                        (rtx, rtx);
extern rtx        gen_addqi3                               (rtx, rtx, rtx);
extern rtx        gen_addhi3                               (rtx, rtx, rtx);
extern rtx        gen_addsi3                               (rtx, rtx, rtx);
extern rtx        gen_adddi3                               (rtx, rtx, rtx);
extern rtx        gen_addti3                               (rtx, rtx, rtx);
extern rtx        gen_subqi3                               (rtx, rtx, rtx);
extern rtx        gen_subhi3                               (rtx, rtx, rtx);
extern rtx        gen_subsi3                               (rtx, rtx, rtx);
extern rtx        gen_subdi3                               (rtx, rtx, rtx);
extern rtx        gen_subti3                               (rtx, rtx, rtx);
extern rtx        gen_addqi3_carry                         (rtx, rtx, rtx, rtx, rtx);
extern rtx        gen_subqi3_carry                         (rtx, rtx, rtx, rtx, rtx);
extern rtx        gen_addhi3_carry                         (rtx, rtx, rtx, rtx, rtx);
extern rtx        gen_subhi3_carry                         (rtx, rtx, rtx, rtx, rtx);
extern rtx        gen_addsi3_carry                         (rtx, rtx, rtx, rtx, rtx);
extern rtx        gen_subsi3_carry                         (rtx, rtx, rtx, rtx, rtx);
extern rtx        gen_adddi3_carry                         (rtx, rtx, rtx, rtx, rtx);
extern rtx        gen_subdi3_carry                         (rtx, rtx, rtx, rtx, rtx);
extern rtx        gen_addxf3                               (rtx, rtx, rtx);
extern rtx        gen_subxf3                               (rtx, rtx, rtx);
extern rtx        gen_addsf3                               (rtx, rtx, rtx);
extern rtx        gen_subsf3                               (rtx, rtx, rtx);
extern rtx        gen_adddf3                               (rtx, rtx, rtx);
extern rtx        gen_subdf3                               (rtx, rtx, rtx);
extern rtx        gen_mulhi3                               (rtx, rtx, rtx);
extern rtx        gen_mulsi3                               (rtx, rtx, rtx);
extern rtx        gen_muldi3                               (rtx, rtx, rtx);
extern rtx        gen_mulqi3                               (rtx, rtx, rtx);
extern rtx        gen_mulsidi3                             (rtx, rtx, rtx);
extern rtx        gen_umulsidi3                            (rtx, rtx, rtx);
extern rtx        gen_mulditi3                             (rtx, rtx, rtx);
extern rtx        gen_umulditi3                            (rtx, rtx, rtx);
extern rtx        gen_mulqihi3                             (rtx, rtx, rtx);
extern rtx        gen_umulqihi3                            (rtx, rtx, rtx);
extern rtx        gen_smulsi3_highpart                     (rtx, rtx, rtx);
extern rtx        gen_umulsi3_highpart                     (rtx, rtx, rtx);
extern rtx        gen_smuldi3_highpart                     (rtx, rtx, rtx);
extern rtx        gen_umuldi3_highpart                     (rtx, rtx, rtx);
extern rtx        gen_mulxf3                               (rtx, rtx, rtx);
extern rtx        gen_mulsf3                               (rtx, rtx, rtx);
extern rtx        gen_muldf3                               (rtx, rtx, rtx);
extern rtx        gen_divxf3                               (rtx, rtx, rtx);
extern rtx        gen_divdf3                               (rtx, rtx, rtx);
extern rtx        gen_divsf3                               (rtx, rtx, rtx);
extern rtx        gen_divmodhi4                            (rtx, rtx, rtx, rtx);
extern rtx        gen_divmodsi4                            (rtx, rtx, rtx, rtx);
extern rtx        gen_divmoddi4                            (rtx, rtx, rtx, rtx);
extern rtx        gen_divmodqi4                            (rtx, rtx, rtx, rtx);
extern rtx        gen_udivmodhi4                           (rtx, rtx, rtx, rtx);
extern rtx        gen_udivmodsi4                           (rtx, rtx, rtx, rtx);
extern rtx        gen_udivmoddi4                           (rtx, rtx, rtx, rtx);
extern rtx        gen_udivmodqi4                           (rtx, rtx, rtx, rtx);
extern rtx        gen_testsi_ccno_1                        (rtx, rtx);
extern rtx        gen_testqi_ccz_1                         (rtx, rtx);
extern rtx        gen_testdi_ccno_1                        (rtx, rtx);
extern rtx        gen_testqi_ext_ccno_0                    (rtx, rtx);
extern rtx        gen_andqi3                               (rtx, rtx, rtx);
extern rtx        gen_andhi3                               (rtx, rtx, rtx);
extern rtx        gen_andsi3                               (rtx, rtx, rtx);
extern rtx        gen_anddi3                               (rtx, rtx, rtx);
extern rtx        gen_iorqi3                               (rtx, rtx, rtx);
extern rtx        gen_xorqi3                               (rtx, rtx, rtx);
extern rtx        gen_iorhi3                               (rtx, rtx, rtx);
extern rtx        gen_xorhi3                               (rtx, rtx, rtx);
extern rtx        gen_iorsi3                               (rtx, rtx, rtx);
extern rtx        gen_xorsi3                               (rtx, rtx, rtx);
extern rtx        gen_iordi3                               (rtx, rtx, rtx);
extern rtx        gen_xordi3                               (rtx, rtx, rtx);
extern rtx        gen_xorqi_cc_ext_1                       (rtx, rtx, rtx);
extern rtx        gen_negqi2                               (rtx, rtx);
extern rtx        gen_neghi2                               (rtx, rtx);
extern rtx        gen_negsi2                               (rtx, rtx);
extern rtx        gen_negdi2                               (rtx, rtx);
extern rtx        gen_negti2                               (rtx, rtx);
extern rtx        gen_abssf2                               (rtx, rtx);
extern rtx        gen_negsf2                               (rtx, rtx);
extern rtx        gen_absdf2                               (rtx, rtx);
extern rtx        gen_negdf2                               (rtx, rtx);
extern rtx        gen_absxf2                               (rtx, rtx);
extern rtx        gen_negxf2                               (rtx, rtx);
extern rtx        gen_abstf2                               (rtx, rtx);
extern rtx        gen_negtf2                               (rtx, rtx);
extern rtx        gen_copysignsf3                          (rtx, rtx, rtx);
extern rtx        gen_copysigndf3                          (rtx, rtx, rtx);
extern rtx        gen_copysigntf3                          (rtx, rtx, rtx);
extern rtx        gen_one_cmplqi2                          (rtx, rtx);
extern rtx        gen_one_cmplhi2                          (rtx, rtx);
extern rtx        gen_one_cmplsi2                          (rtx, rtx);
extern rtx        gen_one_cmpldi2                          (rtx, rtx);
extern rtx        gen_ashlqi3                              (rtx, rtx, rtx);
extern rtx        gen_ashlhi3                              (rtx, rtx, rtx);
extern rtx        gen_ashlsi3                              (rtx, rtx, rtx);
extern rtx        gen_ashldi3                              (rtx, rtx, rtx);
extern rtx        gen_ashlti3                              (rtx, rtx, rtx);
extern rtx        gen_x86_shiftsi_adj_1                    (rtx, rtx, rtx, rtx);
extern rtx        gen_x86_shiftdi_adj_1                    (rtx, rtx, rtx, rtx);
extern rtx        gen_x86_shiftsi_adj_2                    (rtx, rtx, rtx);
extern rtx        gen_x86_shiftdi_adj_2                    (rtx, rtx, rtx);
extern rtx        gen_lshrqi3                              (rtx, rtx, rtx);
extern rtx        gen_ashrqi3                              (rtx, rtx, rtx);
extern rtx        gen_lshrhi3                              (rtx, rtx, rtx);
extern rtx        gen_ashrhi3                              (rtx, rtx, rtx);
extern rtx        gen_lshrsi3                              (rtx, rtx, rtx);
extern rtx        gen_ashrsi3                              (rtx, rtx, rtx);
extern rtx        gen_lshrdi3                              (rtx, rtx, rtx);
extern rtx        gen_ashrdi3                              (rtx, rtx, rtx);
extern rtx        gen_lshrti3                              (rtx, rtx, rtx);
extern rtx        gen_ashrti3                              (rtx, rtx, rtx);
extern rtx        gen_x86_shiftsi_adj_3                    (rtx, rtx, rtx);
extern rtx        gen_x86_shiftdi_adj_3                    (rtx, rtx, rtx);
extern rtx        gen_rotlti3                              (rtx, rtx, rtx);
extern rtx        gen_rotrti3                              (rtx, rtx, rtx);
extern rtx        gen_rotldi3                              (rtx, rtx, rtx);
extern rtx        gen_rotrdi3                              (rtx, rtx, rtx);
extern rtx        gen_rotlqi3                              (rtx, rtx, rtx);
extern rtx        gen_rotrqi3                              (rtx, rtx, rtx);
extern rtx        gen_rotlhi3                              (rtx, rtx, rtx);
extern rtx        gen_rotrhi3                              (rtx, rtx, rtx);
extern rtx        gen_rotlsi3                              (rtx, rtx, rtx);
extern rtx        gen_rotrsi3                              (rtx, rtx, rtx);
extern rtx        gen_extv                                 (rtx, rtx, rtx, rtx);
extern rtx        gen_extzv                                (rtx, rtx, rtx, rtx);
extern rtx        gen_insv                                 (rtx, rtx, rtx, rtx);
extern rtx        gen_indirect_jump                        (rtx);
extern rtx        gen_tablejump                            (rtx, rtx);
#define GEN_CALL(A, B, C, D) gen_call ((A), (B), (C))
extern rtx        gen_call                                 (rtx, rtx, rtx);
#define GEN_SIBCALL(A, B, C, D) gen_sibcall ((A), (B), (C))
extern rtx        gen_sibcall                              (rtx, rtx, rtx);
#define GEN_CALL_POP(A, B, C, D) gen_call_pop ((A), (B), (C), (D))
extern rtx        gen_call_pop                             (rtx, rtx, rtx, rtx);
#define GEN_CALL_VALUE(A, B, C, D, E) gen_call_value ((A), (B), (C), (D))
extern rtx        gen_call_value                           (rtx, rtx, rtx, rtx);
#define GEN_SIBCALL_VALUE(A, B, C, D, E) gen_sibcall_value ((A), (B), (C), (D))
extern rtx        gen_sibcall_value                        (rtx, rtx, rtx, rtx);
#define GEN_CALL_VALUE_POP(A, B, C, D, E) gen_call_value_pop ((A), (B), (C), (D), (E))
extern rtx        gen_call_value_pop                       (rtx, rtx, rtx, rtx, rtx);
extern rtx        gen_untyped_call                         (rtx, rtx, rtx);
extern rtx        gen_memory_blockage                      (void);
extern rtx        gen_return                               (void);
extern rtx        gen_simple_return                        (void);
extern rtx        gen_prologue                             (void);
extern rtx        gen_epilogue                             (void);
extern rtx        gen_sibcall_epilogue                     (void);
extern rtx        gen_eh_return                            (rtx);
extern rtx        gen_split_stack_prologue                 (void);
extern rtx        gen_split_stack_space_check              (rtx, rtx);
extern rtx        gen_ffssi2                               (rtx, rtx);
extern rtx        gen_ffsdi2                               (rtx, rtx);
extern rtx        gen_clzhi2                               (rtx, rtx);
extern rtx        gen_clzsi2                               (rtx, rtx);
extern rtx        gen_clzdi2                               (rtx, rtx);
extern rtx        gen_bswapsi2                             (rtx, rtx);
extern rtx        gen_bswapdi2                             (rtx, rtx);
extern rtx        gen_paritydi2                            (rtx, rtx);
extern rtx        gen_paritysi2                            (rtx, rtx);
extern rtx        gen_tls_global_dynamic_32                (rtx, rtx, rtx, rtx);
extern rtx        gen_tls_global_dynamic_64                (rtx, rtx, rtx);
extern rtx        gen_tls_local_dynamic_base_32            (rtx, rtx, rtx);
extern rtx        gen_tls_local_dynamic_base_64            (rtx, rtx);
extern rtx        gen_tls_dynamic_gnu2_32                  (rtx, rtx, rtx);
extern rtx        gen_tls_dynamic_gnu2_64                  (rtx, rtx);
extern rtx        gen_rsqrtsf2                             (rtx, rtx);
extern rtx        gen_sqrtsf2                              (rtx, rtx);
extern rtx        gen_sqrtdf2                              (rtx, rtx);
extern rtx        gen_fmodxf3                              (rtx, rtx, rtx);
extern rtx        gen_fmodsf3                              (rtx, rtx, rtx);
extern rtx        gen_fmoddf3                              (rtx, rtx, rtx);
extern rtx        gen_remainderxf3                         (rtx, rtx, rtx);
extern rtx        gen_remaindersf3                         (rtx, rtx, rtx);
extern rtx        gen_remainderdf3                         (rtx, rtx, rtx);
extern rtx        gen_sincossf3                            (rtx, rtx, rtx);
extern rtx        gen_sincosdf3                            (rtx, rtx, rtx);
extern rtx        gen_tanxf2                               (rtx, rtx);
extern rtx        gen_tansf2                               (rtx, rtx);
extern rtx        gen_tandf2                               (rtx, rtx);
extern rtx        gen_atan2xf3                             (rtx, rtx, rtx);
extern rtx        gen_atan2sf3                             (rtx, rtx, rtx);
extern rtx        gen_atan2df3                             (rtx, rtx, rtx);
extern rtx        gen_atanxf2                              (rtx, rtx);
extern rtx        gen_atansf2                              (rtx, rtx);
extern rtx        gen_atandf2                              (rtx, rtx);
extern rtx        gen_asinxf2                              (rtx, rtx);
extern rtx        gen_asinsf2                              (rtx, rtx);
extern rtx        gen_asindf2                              (rtx, rtx);
extern rtx        gen_acosxf2                              (rtx, rtx);
extern rtx        gen_acossf2                              (rtx, rtx);
extern rtx        gen_acosdf2                              (rtx, rtx);
extern rtx        gen_logxf2                               (rtx, rtx);
extern rtx        gen_logsf2                               (rtx, rtx);
extern rtx        gen_logdf2                               (rtx, rtx);
extern rtx        gen_log10xf2                             (rtx, rtx);
extern rtx        gen_log10sf2                             (rtx, rtx);
extern rtx        gen_log10df2                             (rtx, rtx);
extern rtx        gen_log2xf2                              (rtx, rtx);
extern rtx        gen_log2sf2                              (rtx, rtx);
extern rtx        gen_log2df2                              (rtx, rtx);
extern rtx        gen_log1pxf2                             (rtx, rtx);
extern rtx        gen_log1psf2                             (rtx, rtx);
extern rtx        gen_log1pdf2                             (rtx, rtx);
extern rtx        gen_logbxf2                              (rtx, rtx);
extern rtx        gen_logbsf2                              (rtx, rtx);
extern rtx        gen_logbdf2                              (rtx, rtx);
extern rtx        gen_ilogbxf2                             (rtx, rtx);
extern rtx        gen_ilogbsf2                             (rtx, rtx);
extern rtx        gen_ilogbdf2                             (rtx, rtx);
extern rtx        gen_expNcorexf3                          (rtx, rtx, rtx);
extern rtx        gen_expxf2                               (rtx, rtx);
extern rtx        gen_expsf2                               (rtx, rtx);
extern rtx        gen_expdf2                               (rtx, rtx);
extern rtx        gen_exp10xf2                             (rtx, rtx);
extern rtx        gen_exp10sf2                             (rtx, rtx);
extern rtx        gen_exp10df2                             (rtx, rtx);
extern rtx        gen_exp2xf2                              (rtx, rtx);
extern rtx        gen_exp2sf2                              (rtx, rtx);
extern rtx        gen_exp2df2                              (rtx, rtx);
extern rtx        gen_expm1xf2                             (rtx, rtx);
extern rtx        gen_expm1sf2                             (rtx, rtx);
extern rtx        gen_expm1df2                             (rtx, rtx);
extern rtx        gen_ldexpxf3                             (rtx, rtx, rtx);
extern rtx        gen_ldexpsf3                             (rtx, rtx, rtx);
extern rtx        gen_ldexpdf3                             (rtx, rtx, rtx);
extern rtx        gen_scalbxf3                             (rtx, rtx, rtx);
extern rtx        gen_scalbsf3                             (rtx, rtx, rtx);
extern rtx        gen_scalbdf3                             (rtx, rtx, rtx);
extern rtx        gen_significandxf2                       (rtx, rtx);
extern rtx        gen_significandsf2                       (rtx, rtx);
extern rtx        gen_significanddf2                       (rtx, rtx);
extern rtx        gen_rintsf2                              (rtx, rtx);
extern rtx        gen_rintdf2                              (rtx, rtx);
extern rtx        gen_roundsf2                             (rtx, rtx);
extern rtx        gen_rounddf2                             (rtx, rtx);
extern rtx        gen_roundxf2                             (rtx, rtx);
extern rtx        gen_lrintxfhi2                           (rtx, rtx);
extern rtx        gen_lrintxfsi2                           (rtx, rtx);
extern rtx        gen_lrintxfdi2                           (rtx, rtx);
extern rtx        gen_lrintsfsi2                           (rtx, rtx);
extern rtx        gen_lrintdfsi2                           (rtx, rtx);
extern rtx        gen_lrintsfdi2                           (rtx, rtx);
extern rtx        gen_lrintdfdi2                           (rtx, rtx);
extern rtx        gen_lroundsfhi2                          (rtx, rtx);
extern rtx        gen_lrounddfhi2                          (rtx, rtx);
extern rtx        gen_lroundxfhi2                          (rtx, rtx);
extern rtx        gen_lroundsfsi2                          (rtx, rtx);
extern rtx        gen_lrounddfsi2                          (rtx, rtx);
extern rtx        gen_lroundxfsi2                          (rtx, rtx);
extern rtx        gen_lroundsfdi2                          (rtx, rtx);
extern rtx        gen_lrounddfdi2                          (rtx, rtx);
extern rtx        gen_lroundxfdi2                          (rtx, rtx);
extern rtx        gen_floorxf2                             (rtx, rtx);
extern rtx        gen_floorsf2                             (rtx, rtx);
extern rtx        gen_floordf2                             (rtx, rtx);
extern rtx        gen_lfloorxfhi2                          (rtx, rtx);
extern rtx        gen_lfloorxfsi2                          (rtx, rtx);
extern rtx        gen_lfloorxfdi2                          (rtx, rtx);
extern rtx        gen_lfloorsfsi2                          (rtx, rtx);
extern rtx        gen_lfloorsfdi2                          (rtx, rtx);
extern rtx        gen_lfloordfsi2                          (rtx, rtx);
extern rtx        gen_lfloordfdi2                          (rtx, rtx);
extern rtx        gen_ceilxf2                              (rtx, rtx);
extern rtx        gen_ceilsf2                              (rtx, rtx);
extern rtx        gen_ceildf2                              (rtx, rtx);
extern rtx        gen_lceilxfhi2                           (rtx, rtx);
extern rtx        gen_lceilxfsi2                           (rtx, rtx);
extern rtx        gen_lceilxfdi2                           (rtx, rtx);
extern rtx        gen_lceilsfsi2                           (rtx, rtx);
extern rtx        gen_lceilsfdi2                           (rtx, rtx);
extern rtx        gen_lceildfsi2                           (rtx, rtx);
extern rtx        gen_lceildfdi2                           (rtx, rtx);
extern rtx        gen_btruncxf2                            (rtx, rtx);
extern rtx        gen_btruncsf2                            (rtx, rtx);
extern rtx        gen_btruncdf2                            (rtx, rtx);
extern rtx        gen_nearbyintxf2                         (rtx, rtx);
extern rtx        gen_nearbyintsf2                         (rtx, rtx);
extern rtx        gen_nearbyintdf2                         (rtx, rtx);
extern rtx        gen_isinfxf2                             (rtx, rtx);
extern rtx        gen_isinfsf2                             (rtx, rtx);
extern rtx        gen_isinfdf2                             (rtx, rtx);
extern rtx        gen_signbitxf2                           (rtx, rtx);
extern rtx        gen_signbitdf2                           (rtx, rtx);
extern rtx        gen_signbitsf2                           (rtx, rtx);
extern rtx        gen_movmemsi                             (rtx, rtx, rtx, rtx, rtx, rtx);
extern rtx        gen_movmemdi                             (rtx, rtx, rtx, rtx, rtx, rtx);
extern rtx        gen_strmov                               (rtx, rtx, rtx, rtx);
extern rtx        gen_strmov_singleop                      (rtx, rtx, rtx, rtx, rtx, rtx);
extern rtx        gen_rep_mov                              (rtx, rtx, rtx, rtx, rtx, rtx, rtx);
extern rtx        gen_setmemsi                             (rtx, rtx, rtx, rtx, rtx, rtx);
extern rtx        gen_setmemdi                             (rtx, rtx, rtx, rtx, rtx, rtx);
extern rtx        gen_strset                               (rtx, rtx, rtx);
extern rtx        gen_strset_singleop                      (rtx, rtx, rtx, rtx);
extern rtx        gen_rep_stos                             (rtx, rtx, rtx, rtx, rtx);
extern rtx        gen_cmpstrnsi                            (rtx, rtx, rtx, rtx, rtx);
extern rtx        gen_cmpintqi                             (rtx);
extern rtx        gen_cmpstrnqi_nz_1                       (rtx, rtx, rtx, rtx, rtx, rtx);
extern rtx        gen_cmpstrnqi_1                          (rtx, rtx, rtx, rtx, rtx, rtx);
extern rtx        gen_strlensi                             (rtx, rtx, rtx, rtx);
extern rtx        gen_strlendi                             (rtx, rtx, rtx, rtx);
extern rtx        gen_strlenqi_1                           (rtx, rtx, rtx);
extern rtx        gen_movqicc                              (rtx, rtx, rtx, rtx);
extern rtx        gen_movhicc                              (rtx, rtx, rtx, rtx);
extern rtx        gen_movsicc                              (rtx, rtx, rtx, rtx);
extern rtx        gen_movdicc                              (rtx, rtx, rtx, rtx);
extern rtx        gen_x86_movsicc_0_m1                     (rtx, rtx, rtx);
extern rtx        gen_x86_movdicc_0_m1                     (rtx, rtx, rtx);
extern rtx        gen_movsfcc                              (rtx, rtx, rtx, rtx);
extern rtx        gen_movdfcc                              (rtx, rtx, rtx, rtx);
extern rtx        gen_movxfcc                              (rtx, rtx, rtx, rtx);
extern rtx        gen_addqicc                              (rtx, rtx, rtx, rtx);
extern rtx        gen_addhicc                              (rtx, rtx, rtx, rtx);
extern rtx        gen_addsicc                              (rtx, rtx, rtx, rtx);
extern rtx        gen_adddicc                              (rtx, rtx, rtx, rtx);
extern rtx        gen_allocate_stack                       (rtx, rtx);
extern rtx        gen_probe_stack                          (rtx);
extern rtx        gen_builtin_setjmp_receiver              (rtx);
extern rtx        gen_prefetch                             (rtx, rtx, rtx);
extern rtx        gen_stack_protect_set                    (rtx, rtx);
extern rtx        gen_stack_protect_test                   (rtx, rtx, rtx);
extern rtx        gen_rdpmc                                (rtx, rtx);
extern rtx        gen_rdtsc                                (rtx);
extern rtx        gen_rdtscp                               (rtx, rtx);
extern rtx        gen_lwp_llwpcb                           (rtx);
extern rtx        gen_lwp_slwpcb                           (rtx);
extern rtx        gen_lwp_lwpvalsi3                        (rtx, rtx, rtx, rtx);
extern rtx        gen_lwp_lwpvaldi3                        (rtx, rtx, rtx, rtx);
extern rtx        gen_lwp_lwpinssi3                        (rtx, rtx, rtx, rtx);
extern rtx        gen_lwp_lwpinsdi3                        (rtx, rtx, rtx, rtx);
extern rtx        gen_pause                                (void);
extern rtx        gen_movv8qi                              (rtx, rtx);
extern rtx        gen_movv4hi                              (rtx, rtx);
extern rtx        gen_movv2si                              (rtx, rtx);
extern rtx        gen_movv1di                              (rtx, rtx);
extern rtx        gen_movv2sf                              (rtx, rtx);
extern rtx        gen_pushv8qi1                            (rtx);
extern rtx        gen_pushv4hi1                            (rtx);
extern rtx        gen_pushv2si1                            (rtx);
extern rtx        gen_pushv1di1                            (rtx);
extern rtx        gen_pushv2sf1                            (rtx);
extern rtx        gen_movmisalignv8qi                      (rtx, rtx);
extern rtx        gen_movmisalignv4hi                      (rtx, rtx);
extern rtx        gen_movmisalignv2si                      (rtx, rtx);
extern rtx        gen_movmisalignv1di                      (rtx, rtx);
extern rtx        gen_movmisalignv2sf                      (rtx, rtx);
extern rtx        gen_mmx_addv2sf3                         (rtx, rtx, rtx);
extern rtx        gen_mmx_subv2sf3                         (rtx, rtx, rtx);
extern rtx        gen_mmx_subrv2sf3                        (rtx, rtx, rtx);
extern rtx        gen_mmx_mulv2sf3                         (rtx, rtx, rtx);
extern rtx        gen_mmx_smaxv2sf3                        (rtx, rtx, rtx);
extern rtx        gen_mmx_sminv2sf3                        (rtx, rtx, rtx);
extern rtx        gen_mmx_eqv2sf3                          (rtx, rtx, rtx);
extern rtx        gen_vec_setv2sf                          (rtx, rtx, rtx);
extern rtx        gen_vec_extractv2sf                      (rtx, rtx, rtx);
extern rtx        gen_vec_initv2sf                         (rtx, rtx);
extern rtx        gen_mmx_addv8qi3                         (rtx, rtx, rtx);
extern rtx        gen_mmx_subv8qi3                         (rtx, rtx, rtx);
extern rtx        gen_mmx_addv4hi3                         (rtx, rtx, rtx);
extern rtx        gen_mmx_subv4hi3                         (rtx, rtx, rtx);
extern rtx        gen_mmx_addv2si3                         (rtx, rtx, rtx);
extern rtx        gen_mmx_subv2si3                         (rtx, rtx, rtx);
extern rtx        gen_mmx_addv1di3                         (rtx, rtx, rtx);
extern rtx        gen_mmx_subv1di3                         (rtx, rtx, rtx);
extern rtx        gen_mmx_ssaddv8qi3                       (rtx, rtx, rtx);
extern rtx        gen_mmx_usaddv8qi3                       (rtx, rtx, rtx);
extern rtx        gen_mmx_sssubv8qi3                       (rtx, rtx, rtx);
extern rtx        gen_mmx_ussubv8qi3                       (rtx, rtx, rtx);
extern rtx        gen_mmx_ssaddv4hi3                       (rtx, rtx, rtx);
extern rtx        gen_mmx_usaddv4hi3                       (rtx, rtx, rtx);
extern rtx        gen_mmx_sssubv4hi3                       (rtx, rtx, rtx);
extern rtx        gen_mmx_ussubv4hi3                       (rtx, rtx, rtx);
extern rtx        gen_mmx_mulv4hi3                         (rtx, rtx, rtx);
extern rtx        gen_mmx_smulv4hi3_highpart               (rtx, rtx, rtx);
extern rtx        gen_mmx_umulv4hi3_highpart               (rtx, rtx, rtx);
extern rtx        gen_mmx_pmaddwd                          (rtx, rtx, rtx);
extern rtx        gen_mmx_pmulhrwv4hi3                     (rtx, rtx, rtx);
extern rtx        gen_sse2_umulv1siv1di3                   (rtx, rtx, rtx);
extern rtx        gen_mmx_smaxv4hi3                        (rtx, rtx, rtx);
extern rtx        gen_mmx_sminv4hi3                        (rtx, rtx, rtx);
extern rtx        gen_mmx_umaxv8qi3                        (rtx, rtx, rtx);
extern rtx        gen_mmx_uminv8qi3                        (rtx, rtx, rtx);
extern rtx        gen_mmx_eqv8qi3                          (rtx, rtx, rtx);
extern rtx        gen_mmx_eqv4hi3                          (rtx, rtx, rtx);
extern rtx        gen_mmx_eqv2si3                          (rtx, rtx, rtx);
extern rtx        gen_mmx_andv8qi3                         (rtx, rtx, rtx);
extern rtx        gen_mmx_iorv8qi3                         (rtx, rtx, rtx);
extern rtx        gen_mmx_xorv8qi3                         (rtx, rtx, rtx);
extern rtx        gen_mmx_andv4hi3                         (rtx, rtx, rtx);
extern rtx        gen_mmx_iorv4hi3                         (rtx, rtx, rtx);
extern rtx        gen_mmx_xorv4hi3                         (rtx, rtx, rtx);
extern rtx        gen_mmx_andv2si3                         (rtx, rtx, rtx);
extern rtx        gen_mmx_iorv2si3                         (rtx, rtx, rtx);
extern rtx        gen_mmx_xorv2si3                         (rtx, rtx, rtx);
extern rtx        gen_mmx_pinsrw                           (rtx, rtx, rtx, rtx);
extern rtx        gen_mmx_pshufw                           (rtx, rtx, rtx);
extern rtx        gen_vec_setv2si                          (rtx, rtx, rtx);
extern rtx        gen_vec_extractv2si                      (rtx, rtx, rtx);
extern rtx        gen_vec_initv2si                         (rtx, rtx);
extern rtx        gen_vec_setv4hi                          (rtx, rtx, rtx);
extern rtx        gen_vec_extractv4hi                      (rtx, rtx, rtx);
extern rtx        gen_vec_initv4hi                         (rtx, rtx);
extern rtx        gen_vec_setv8qi                          (rtx, rtx, rtx);
extern rtx        gen_vec_extractv8qi                      (rtx, rtx, rtx);
extern rtx        gen_vec_initv8qi                         (rtx, rtx);
extern rtx        gen_mmx_uavgv8qi3                        (rtx, rtx, rtx);
extern rtx        gen_mmx_uavgv4hi3                        (rtx, rtx, rtx);
extern rtx        gen_mmx_maskmovq                         (rtx, rtx, rtx);
extern rtx        gen_mmx_emms                             (void);
extern rtx        gen_mmx_femms                            (void);
extern rtx        gen_movv32qi                             (rtx, rtx);
extern rtx        gen_movv16qi                             (rtx, rtx);
extern rtx        gen_movv16hi                             (rtx, rtx);
extern rtx        gen_movv8hi                              (rtx, rtx);
extern rtx        gen_movv8si                              (rtx, rtx);
extern rtx        gen_movv4si                              (rtx, rtx);
extern rtx        gen_movv4di                              (rtx, rtx);
extern rtx        gen_movv2di                              (rtx, rtx);
extern rtx        gen_movv2ti                              (rtx, rtx);
extern rtx        gen_movv1ti                              (rtx, rtx);
extern rtx        gen_movv8sf                              (rtx, rtx);
extern rtx        gen_movv4sf                              (rtx, rtx);
extern rtx        gen_movv4df                              (rtx, rtx);
extern rtx        gen_movv2df                              (rtx, rtx);
extern rtx        gen_pushv32qi1                           (rtx);
extern rtx        gen_pushv16qi1                           (rtx);
extern rtx        gen_pushv16hi1                           (rtx);
extern rtx        gen_pushv8hi1                            (rtx);
extern rtx        gen_pushv8si1                            (rtx);
extern rtx        gen_pushv4si1                            (rtx);
extern rtx        gen_pushv4di1                            (rtx);
extern rtx        gen_pushv2di1                            (rtx);
extern rtx        gen_pushv2ti1                            (rtx);
extern rtx        gen_pushv1ti1                            (rtx);
extern rtx        gen_pushv8sf1                            (rtx);
extern rtx        gen_pushv4sf1                            (rtx);
extern rtx        gen_pushv4df1                            (rtx);
extern rtx        gen_pushv2df1                            (rtx);
extern rtx        gen_movmisalignv32qi                     (rtx, rtx);
extern rtx        gen_movmisalignv16qi                     (rtx, rtx);
extern rtx        gen_movmisalignv16hi                     (rtx, rtx);
extern rtx        gen_movmisalignv8hi                      (rtx, rtx);
extern rtx        gen_movmisalignv8si                      (rtx, rtx);
extern rtx        gen_movmisalignv4si                      (rtx, rtx);
extern rtx        gen_movmisalignv4di                      (rtx, rtx);
extern rtx        gen_movmisalignv2di                      (rtx, rtx);
extern rtx        gen_movmisalignv2ti                      (rtx, rtx);
extern rtx        gen_movmisalignv1ti                      (rtx, rtx);
extern rtx        gen_movmisalignv8sf                      (rtx, rtx);
extern rtx        gen_movmisalignv4sf                      (rtx, rtx);
extern rtx        gen_movmisalignv4df                      (rtx, rtx);
extern rtx        gen_movmisalignv2df                      (rtx, rtx);
extern rtx        gen_storentdi                            (rtx, rtx);
extern rtx        gen_storentsi                            (rtx, rtx);
extern rtx        gen_storentsf                            (rtx, rtx);
extern rtx        gen_storentdf                            (rtx, rtx);
extern rtx        gen_storentv4di                          (rtx, rtx);
extern rtx        gen_storentv2di                          (rtx, rtx);
extern rtx        gen_storentv8sf                          (rtx, rtx);
extern rtx        gen_storentv4sf                          (rtx, rtx);
extern rtx        gen_storentv4df                          (rtx, rtx);
extern rtx        gen_storentv2df                          (rtx, rtx);
extern rtx        gen_absv8sf2                             (rtx, rtx);
extern rtx        gen_negv8sf2                             (rtx, rtx);
extern rtx        gen_absv4sf2                             (rtx, rtx);
extern rtx        gen_negv4sf2                             (rtx, rtx);
extern rtx        gen_absv4df2                             (rtx, rtx);
extern rtx        gen_negv4df2                             (rtx, rtx);
extern rtx        gen_absv2df2                             (rtx, rtx);
extern rtx        gen_negv2df2                             (rtx, rtx);
extern rtx        gen_addv8sf3                             (rtx, rtx, rtx);
extern rtx        gen_subv8sf3                             (rtx, rtx, rtx);
extern rtx        gen_addv4sf3                             (rtx, rtx, rtx);
extern rtx        gen_subv4sf3                             (rtx, rtx, rtx);
extern rtx        gen_addv4df3                             (rtx, rtx, rtx);
extern rtx        gen_subv4df3                             (rtx, rtx, rtx);
extern rtx        gen_addv2df3                             (rtx, rtx, rtx);
extern rtx        gen_subv2df3                             (rtx, rtx, rtx);
extern rtx        gen_mulv8sf3                             (rtx, rtx, rtx);
extern rtx        gen_mulv4sf3                             (rtx, rtx, rtx);
extern rtx        gen_mulv4df3                             (rtx, rtx, rtx);
extern rtx        gen_mulv2df3                             (rtx, rtx, rtx);
extern rtx        gen_divv4df3                             (rtx, rtx, rtx);
extern rtx        gen_divv2df3                             (rtx, rtx, rtx);
extern rtx        gen_divv8sf3                             (rtx, rtx, rtx);
extern rtx        gen_divv4sf3                             (rtx, rtx, rtx);
extern rtx        gen_sqrtv4df2                            (rtx, rtx);
extern rtx        gen_sqrtv2df2                            (rtx, rtx);
extern rtx        gen_sqrtv8sf2                            (rtx, rtx);
extern rtx        gen_sqrtv4sf2                            (rtx, rtx);
extern rtx        gen_rsqrtv8sf2                           (rtx, rtx);
extern rtx        gen_rsqrtv4sf2                           (rtx, rtx);
extern rtx        gen_smaxv8sf3                            (rtx, rtx, rtx);
extern rtx        gen_sminv8sf3                            (rtx, rtx, rtx);
extern rtx        gen_smaxv4sf3                            (rtx, rtx, rtx);
extern rtx        gen_sminv4sf3                            (rtx, rtx, rtx);
extern rtx        gen_smaxv4df3                            (rtx, rtx, rtx);
extern rtx        gen_sminv4df3                            (rtx, rtx, rtx);
extern rtx        gen_smaxv2df3                            (rtx, rtx, rtx);
extern rtx        gen_sminv2df3                            (rtx, rtx, rtx);
extern rtx        gen_reduc_splus_v4df                     (rtx, rtx);
extern rtx        gen_reduc_splus_v2df                     (rtx, rtx);
extern rtx        gen_reduc_splus_v8sf                     (rtx, rtx);
extern rtx        gen_reduc_splus_v4sf                     (rtx, rtx);
extern rtx        gen_reduc_smax_v32qi                     (rtx, rtx);
extern rtx        gen_reduc_smin_v32qi                     (rtx, rtx);
extern rtx        gen_reduc_smax_v16hi                     (rtx, rtx);
extern rtx        gen_reduc_smin_v16hi                     (rtx, rtx);
extern rtx        gen_reduc_smax_v8si                      (rtx, rtx);
extern rtx        gen_reduc_smin_v8si                      (rtx, rtx);
extern rtx        gen_reduc_smax_v4di                      (rtx, rtx);
extern rtx        gen_reduc_smin_v4di                      (rtx, rtx);
extern rtx        gen_reduc_smax_v8sf                      (rtx, rtx);
extern rtx        gen_reduc_smin_v8sf                      (rtx, rtx);
extern rtx        gen_reduc_smax_v4df                      (rtx, rtx);
extern rtx        gen_reduc_smin_v4df                      (rtx, rtx);
extern rtx        gen_reduc_smax_v4sf                      (rtx, rtx);
extern rtx        gen_reduc_smin_v4sf                      (rtx, rtx);
extern rtx        gen_reduc_umax_v32qi                     (rtx, rtx);
extern rtx        gen_reduc_umin_v32qi                     (rtx, rtx);
extern rtx        gen_reduc_umax_v16hi                     (rtx, rtx);
extern rtx        gen_reduc_umin_v16hi                     (rtx, rtx);
extern rtx        gen_reduc_umax_v8si                      (rtx, rtx);
extern rtx        gen_reduc_umin_v8si                      (rtx, rtx);
extern rtx        gen_reduc_umax_v4di                      (rtx, rtx);
extern rtx        gen_reduc_umin_v4di                      (rtx, rtx);
extern rtx        gen_reduc_umin_v8hi                      (rtx, rtx);
extern rtx        gen_vcondv32qiv8sf                       (rtx, rtx, rtx, rtx, rtx, rtx);
extern rtx        gen_vcondv16hiv8sf                       (rtx, rtx, rtx, rtx, rtx, rtx);
extern rtx        gen_vcondv8siv8sf                        (rtx, rtx, rtx, rtx, rtx, rtx);
extern rtx        gen_vcondv4div8sf                        (rtx, rtx, rtx, rtx, rtx, rtx);
extern rtx        gen_vcondv8sfv8sf                        (rtx, rtx, rtx, rtx, rtx, rtx);
extern rtx        gen_vcondv4dfv8sf                        (rtx, rtx, rtx, rtx, rtx, rtx);
extern rtx        gen_vcondv32qiv4df                       (rtx, rtx, rtx, rtx, rtx, rtx);
extern rtx        gen_vcondv16hiv4df                       (rtx, rtx, rtx, rtx, rtx, rtx);
extern rtx        gen_vcondv8siv4df                        (rtx, rtx, rtx, rtx, rtx, rtx);
extern rtx        gen_vcondv4div4df                        (rtx, rtx, rtx, rtx, rtx, rtx);
extern rtx        gen_vcondv8sfv4df                        (rtx, rtx, rtx, rtx, rtx, rtx);
extern rtx        gen_vcondv4dfv4df                        (rtx, rtx, rtx, rtx, rtx, rtx);
extern rtx        gen_vcondv16qiv4sf                       (rtx, rtx, rtx, rtx, rtx, rtx);
extern rtx        gen_vcondv8hiv4sf                        (rtx, rtx, rtx, rtx, rtx, rtx);
extern rtx        gen_vcondv4siv4sf                        (rtx, rtx, rtx, rtx, rtx, rtx);
extern rtx        gen_vcondv2div4sf                        (rtx, rtx, rtx, rtx, rtx, rtx);
extern rtx        gen_vcondv4sfv4sf                        (rtx, rtx, rtx, rtx, rtx, rtx);
extern rtx        gen_vcondv2dfv4sf                        (rtx, rtx, rtx, rtx, rtx, rtx);
extern rtx        gen_vcondv16qiv2df                       (rtx, rtx, rtx, rtx, rtx, rtx);
extern rtx        gen_vcondv8hiv2df                        (rtx, rtx, rtx, rtx, rtx, rtx);
extern rtx        gen_vcondv4siv2df                        (rtx, rtx, rtx, rtx, rtx, rtx);
extern rtx        gen_vcondv2div2df                        (rtx, rtx, rtx, rtx, rtx, rtx);
extern rtx        gen_vcondv4sfv2df                        (rtx, rtx, rtx, rtx, rtx, rtx);
extern rtx        gen_vcondv2dfv2df                        (rtx, rtx, rtx, rtx, rtx, rtx);
extern rtx        gen_andv8sf3                             (rtx, rtx, rtx);
extern rtx        gen_iorv8sf3                             (rtx, rtx, rtx);
extern rtx        gen_xorv8sf3                             (rtx, rtx, rtx);
extern rtx        gen_andv4sf3                             (rtx, rtx, rtx);
extern rtx        gen_iorv4sf3                             (rtx, rtx, rtx);
extern rtx        gen_xorv4sf3                             (rtx, rtx, rtx);
extern rtx        gen_andv4df3                             (rtx, rtx, rtx);
extern rtx        gen_iorv4df3                             (rtx, rtx, rtx);
extern rtx        gen_xorv4df3                             (rtx, rtx, rtx);
extern rtx        gen_andv2df3                             (rtx, rtx, rtx);
extern rtx        gen_iorv2df3                             (rtx, rtx, rtx);
extern rtx        gen_xorv2df3                             (rtx, rtx, rtx);
extern rtx        gen_copysignv8sf3                        (rtx, rtx, rtx);
extern rtx        gen_copysignv4sf3                        (rtx, rtx, rtx);
extern rtx        gen_copysignv4df3                        (rtx, rtx, rtx);
extern rtx        gen_copysignv2df3                        (rtx, rtx, rtx);
extern rtx        gen_fmasf4                               (rtx, rtx, rtx, rtx);
extern rtx        gen_fmadf4                               (rtx, rtx, rtx, rtx);
extern rtx        gen_fmav4sf4                             (rtx, rtx, rtx, rtx);
extern rtx        gen_fmav2df4                             (rtx, rtx, rtx, rtx);
extern rtx        gen_fmav8sf4                             (rtx, rtx, rtx, rtx);
extern rtx        gen_fmav4df4                             (rtx, rtx, rtx, rtx);
extern rtx        gen_fmssf4                               (rtx, rtx, rtx, rtx);
extern rtx        gen_fmsdf4                               (rtx, rtx, rtx, rtx);
extern rtx        gen_fmsv4sf4                             (rtx, rtx, rtx, rtx);
extern rtx        gen_fmsv2df4                             (rtx, rtx, rtx, rtx);
extern rtx        gen_fmsv8sf4                             (rtx, rtx, rtx, rtx);
extern rtx        gen_fmsv4df4                             (rtx, rtx, rtx, rtx);
extern rtx        gen_fnmasf4                              (rtx, rtx, rtx, rtx);
extern rtx        gen_fnmadf4                              (rtx, rtx, rtx, rtx);
extern rtx        gen_fnmav4sf4                            (rtx, rtx, rtx, rtx);
extern rtx        gen_fnmav2df4                            (rtx, rtx, rtx, rtx);
extern rtx        gen_fnmav8sf4                            (rtx, rtx, rtx, rtx);
extern rtx        gen_fnmav4df4                            (rtx, rtx, rtx, rtx);
extern rtx        gen_fnmssf4                              (rtx, rtx, rtx, rtx);
extern rtx        gen_fnmsdf4                              (rtx, rtx, rtx, rtx);
extern rtx        gen_fnmsv4sf4                            (rtx, rtx, rtx, rtx);
extern rtx        gen_fnmsv2df4                            (rtx, rtx, rtx, rtx);
extern rtx        gen_fnmsv8sf4                            (rtx, rtx, rtx, rtx);
extern rtx        gen_fnmsv4df4                            (rtx, rtx, rtx, rtx);
extern rtx        gen_fma4i_fmadd_sf                       (rtx, rtx, rtx, rtx);
extern rtx        gen_fma4i_fmadd_df                       (rtx, rtx, rtx, rtx);
extern rtx        gen_fma4i_fmadd_v4sf                     (rtx, rtx, rtx, rtx);
extern rtx        gen_fma4i_fmadd_v2df                     (rtx, rtx, rtx, rtx);
extern rtx        gen_fma4i_fmadd_v8sf                     (rtx, rtx, rtx, rtx);
extern rtx        gen_fma4i_fmadd_v4df                     (rtx, rtx, rtx, rtx);
extern rtx        gen_fmaddsub_v8sf                        (rtx, rtx, rtx, rtx);
extern rtx        gen_fmaddsub_v4sf                        (rtx, rtx, rtx, rtx);
extern rtx        gen_fmaddsub_v4df                        (rtx, rtx, rtx, rtx);
extern rtx        gen_fmaddsub_v2df                        (rtx, rtx, rtx, rtx);
extern rtx        gen_fmai_vmfmadd_v4sf                    (rtx, rtx, rtx, rtx);
extern rtx        gen_fmai_vmfmadd_v2df                    (rtx, rtx, rtx, rtx);
extern rtx        gen_fma4i_vmfmadd_v4sf                   (rtx, rtx, rtx, rtx);
extern rtx        gen_fma4i_vmfmadd_v2df                   (rtx, rtx, rtx, rtx);
extern rtx        gen_floatunsv8siv8sf2                    (rtx, rtx);
extern rtx        gen_floatunsv4siv4sf2                    (rtx, rtx);
extern rtx        gen_fixuns_truncv8sfv8si2                (rtx, rtx);
extern rtx        gen_fixuns_truncv4sfv4si2                (rtx, rtx);
extern rtx        gen_avx_cvtpd2dq256_2                    (rtx, rtx);
extern rtx        gen_sse2_cvtpd2dq                        (rtx, rtx);
extern rtx        gen_avx_cvttpd2dq256_2                   (rtx, rtx);
extern rtx        gen_sse2_cvttpd2dq                       (rtx, rtx);
extern rtx        gen_sse2_cvtpd2ps                        (rtx, rtx);
extern rtx        gen_vec_unpacks_hi_v4sf                  (rtx, rtx);
extern rtx        gen_vec_unpacks_hi_v8sf                  (rtx, rtx);
extern rtx        gen_vec_unpacks_lo_v4sf                  (rtx, rtx);
extern rtx        gen_vec_unpacks_lo_v8sf                  (rtx, rtx);
extern rtx        gen_vec_unpacks_float_hi_v16hi           (rtx, rtx);
extern rtx        gen_vec_unpacks_float_hi_v8hi            (rtx, rtx);
extern rtx        gen_vec_unpacks_float_lo_v16hi           (rtx, rtx);
extern rtx        gen_vec_unpacks_float_lo_v8hi            (rtx, rtx);
extern rtx        gen_vec_unpacku_float_hi_v16hi           (rtx, rtx);
extern rtx        gen_vec_unpacku_float_hi_v8hi            (rtx, rtx);
extern rtx        gen_vec_unpacku_float_lo_v16hi           (rtx, rtx);
extern rtx        gen_vec_unpacku_float_lo_v8hi            (rtx, rtx);
extern rtx        gen_vec_unpacks_float_hi_v4si            (rtx, rtx);
extern rtx        gen_vec_unpacks_float_lo_v4si            (rtx, rtx);
extern rtx        gen_vec_unpacks_float_hi_v8si            (rtx, rtx);
extern rtx        gen_vec_unpacks_float_lo_v8si            (rtx, rtx);
extern rtx        gen_vec_unpacku_float_hi_v4si            (rtx, rtx);
extern rtx        gen_vec_unpacku_float_lo_v4si            (rtx, rtx);
extern rtx        gen_vec_unpacku_float_hi_v8si            (rtx, rtx);
extern rtx        gen_vec_unpacku_float_lo_v8si            (rtx, rtx);
extern rtx        gen_vec_pack_trunc_v4df                  (rtx, rtx, rtx);
extern rtx        gen_vec_pack_trunc_v2df                  (rtx, rtx, rtx);
extern rtx        gen_vec_pack_sfix_trunc_v4df             (rtx, rtx, rtx);
extern rtx        gen_vec_pack_sfix_trunc_v2df             (rtx, rtx, rtx);
extern rtx        gen_vec_pack_ufix_trunc_v4df             (rtx, rtx, rtx);
extern rtx        gen_vec_pack_ufix_trunc_v2df             (rtx, rtx, rtx);
extern rtx        gen_vec_pack_sfix_v4df                   (rtx, rtx, rtx);
extern rtx        gen_vec_pack_sfix_v2df                   (rtx, rtx, rtx);
extern rtx        gen_sse_movhlps_exp                      (rtx, rtx, rtx);
extern rtx        gen_sse_movlhps_exp                      (rtx, rtx, rtx);
extern rtx        gen_vec_interleave_highv8sf              (rtx, rtx, rtx);
extern rtx        gen_vec_interleave_lowv8sf               (rtx, rtx, rtx);
extern rtx        gen_avx_shufps256                        (rtx, rtx, rtx, rtx);
extern rtx        gen_sse_shufps                           (rtx, rtx, rtx, rtx);
extern rtx        gen_sse_loadhps_exp                      (rtx, rtx, rtx);
extern rtx        gen_sse_loadlps_exp                      (rtx, rtx, rtx);
extern rtx        gen_vec_initv16qi                        (rtx, rtx);
extern rtx        gen_vec_initv8hi                         (rtx, rtx);
extern rtx        gen_vec_initv4si                         (rtx, rtx);
extern rtx        gen_vec_initv2di                         (rtx, rtx);
extern rtx        gen_vec_initv4sf                         (rtx, rtx);
extern rtx        gen_vec_initv2df                         (rtx, rtx);
extern rtx        gen_vec_setv32qi                         (rtx, rtx, rtx);
extern rtx        gen_vec_setv16qi                         (rtx, rtx, rtx);
extern rtx        gen_vec_setv16hi                         (rtx, rtx, rtx);
extern rtx        gen_vec_setv8hi                          (rtx, rtx, rtx);
extern rtx        gen_vec_setv8si                          (rtx, rtx, rtx);
extern rtx        gen_vec_setv4si                          (rtx, rtx, rtx);
extern rtx        gen_vec_setv4di                          (rtx, rtx, rtx);
extern rtx        gen_vec_setv2di                          (rtx, rtx, rtx);
extern rtx        gen_vec_setv8sf                          (rtx, rtx, rtx);
extern rtx        gen_vec_setv4sf                          (rtx, rtx, rtx);
extern rtx        gen_vec_setv4df                          (rtx, rtx, rtx);
extern rtx        gen_vec_setv2df                          (rtx, rtx, rtx);
extern rtx        gen_avx_vextractf128v32qi                (rtx, rtx, rtx);
extern rtx        gen_avx_vextractf128v16hi                (rtx, rtx, rtx);
extern rtx        gen_avx_vextractf128v8si                 (rtx, rtx, rtx);
extern rtx        gen_avx_vextractf128v4di                 (rtx, rtx, rtx);
extern rtx        gen_avx_vextractf128v8sf                 (rtx, rtx, rtx);
extern rtx        gen_avx_vextractf128v4df                 (rtx, rtx, rtx);
extern rtx        gen_vec_extractv32qi                     (rtx, rtx, rtx);
extern rtx        gen_vec_extractv16qi                     (rtx, rtx, rtx);
extern rtx        gen_vec_extractv16hi                     (rtx, rtx, rtx);
extern rtx        gen_vec_extractv8hi                      (rtx, rtx, rtx);
extern rtx        gen_vec_extractv8si                      (rtx, rtx, rtx);
extern rtx        gen_vec_extractv4si                      (rtx, rtx, rtx);
extern rtx        gen_vec_extractv4di                      (rtx, rtx, rtx);
extern rtx        gen_vec_extractv2di                      (rtx, rtx, rtx);
extern rtx        gen_vec_extractv8sf                      (rtx, rtx, rtx);
extern rtx        gen_vec_extractv4sf                      (rtx, rtx, rtx);
extern rtx        gen_vec_extractv4df                      (rtx, rtx, rtx);
extern rtx        gen_vec_extractv2df                      (rtx, rtx, rtx);
extern rtx        gen_vec_interleave_highv4df              (rtx, rtx, rtx);
extern rtx        gen_vec_interleave_highv2df              (rtx, rtx, rtx);
extern rtx        gen_avx_movddup256                       (rtx, rtx);
extern rtx        gen_avx_unpcklpd256                      (rtx, rtx, rtx);
extern rtx        gen_vec_interleave_lowv4df               (rtx, rtx, rtx);
extern rtx        gen_vec_interleave_lowv2df               (rtx, rtx, rtx);
extern rtx        gen_avx_shufpd256                        (rtx, rtx, rtx, rtx);
extern rtx        gen_sse2_shufpd                          (rtx, rtx, rtx, rtx);
extern rtx        gen_sse2_loadhpd_exp                     (rtx, rtx, rtx);
extern rtx        gen_sse2_loadlpd_exp                     (rtx, rtx, rtx);
extern rtx        gen_negv32qi2                            (rtx, rtx);
extern rtx        gen_negv16qi2                            (rtx, rtx);
extern rtx        gen_negv16hi2                            (rtx, rtx);
extern rtx        gen_negv8hi2                             (rtx, rtx);
extern rtx        gen_negv8si2                             (rtx, rtx);
extern rtx        gen_negv4si2                             (rtx, rtx);
extern rtx        gen_negv4di2                             (rtx, rtx);
extern rtx        gen_negv2di2                             (rtx, rtx);
extern rtx        gen_addv32qi3                            (rtx, rtx, rtx);
extern rtx        gen_subv32qi3                            (rtx, rtx, rtx);
extern rtx        gen_addv16qi3                            (rtx, rtx, rtx);
extern rtx        gen_subv16qi3                            (rtx, rtx, rtx);
extern rtx        gen_addv16hi3                            (rtx, rtx, rtx);
extern rtx        gen_subv16hi3                            (rtx, rtx, rtx);
extern rtx        gen_addv8hi3                             (rtx, rtx, rtx);
extern rtx        gen_subv8hi3                             (rtx, rtx, rtx);
extern rtx        gen_addv8si3                             (rtx, rtx, rtx);
extern rtx        gen_subv8si3                             (rtx, rtx, rtx);
extern rtx        gen_addv4si3                             (rtx, rtx, rtx);
extern rtx        gen_subv4si3                             (rtx, rtx, rtx);
extern rtx        gen_addv4di3                             (rtx, rtx, rtx);
extern rtx        gen_subv4di3                             (rtx, rtx, rtx);
extern rtx        gen_addv2di3                             (rtx, rtx, rtx);
extern rtx        gen_subv2di3                             (rtx, rtx, rtx);
extern rtx        gen_avx2_ssaddv32qi3                     (rtx, rtx, rtx);
extern rtx        gen_avx2_usaddv32qi3                     (rtx, rtx, rtx);
extern rtx        gen_avx2_sssubv32qi3                     (rtx, rtx, rtx);
extern rtx        gen_avx2_ussubv32qi3                     (rtx, rtx, rtx);
extern rtx        gen_sse2_ssaddv16qi3                     (rtx, rtx, rtx);
extern rtx        gen_sse2_usaddv16qi3                     (rtx, rtx, rtx);
extern rtx        gen_sse2_sssubv16qi3                     (rtx, rtx, rtx);
extern rtx        gen_sse2_ussubv16qi3                     (rtx, rtx, rtx);
extern rtx        gen_avx2_ssaddv16hi3                     (rtx, rtx, rtx);
extern rtx        gen_avx2_usaddv16hi3                     (rtx, rtx, rtx);
extern rtx        gen_avx2_sssubv16hi3                     (rtx, rtx, rtx);
extern rtx        gen_avx2_ussubv16hi3                     (rtx, rtx, rtx);
extern rtx        gen_sse2_ssaddv8hi3                      (rtx, rtx, rtx);
extern rtx        gen_sse2_usaddv8hi3                      (rtx, rtx, rtx);
extern rtx        gen_sse2_sssubv8hi3                      (rtx, rtx, rtx);
extern rtx        gen_sse2_ussubv8hi3                      (rtx, rtx, rtx);
extern rtx        gen_mulv16hi3                            (rtx, rtx, rtx);
extern rtx        gen_mulv8hi3                             (rtx, rtx, rtx);
extern rtx        gen_smulv16hi3_highpart                  (rtx, rtx, rtx);
extern rtx        gen_umulv16hi3_highpart                  (rtx, rtx, rtx);
extern rtx        gen_smulv8hi3_highpart                   (rtx, rtx, rtx);
extern rtx        gen_umulv8hi3_highpart                   (rtx, rtx, rtx);
extern rtx        gen_avx2_umulv4siv4di3                   (rtx, rtx, rtx);
extern rtx        gen_sse2_umulv2siv2di3                   (rtx, rtx, rtx);
extern rtx        gen_avx2_mulv4siv4di3                    (rtx, rtx, rtx);
extern rtx        gen_sse4_1_mulv2siv2di3                  (rtx, rtx, rtx);
extern rtx        gen_avx2_pmaddwd                         (rtx, rtx, rtx);
extern rtx        gen_sse2_pmaddwd                         (rtx, rtx, rtx);
extern rtx        gen_mulv8si3                             (rtx, rtx, rtx);
extern rtx        gen_mulv4si3                             (rtx, rtx, rtx);
extern rtx        gen_vec_widen_smult_hi_v16hi             (rtx, rtx, rtx);
extern rtx        gen_vec_widen_umult_hi_v16hi             (rtx, rtx, rtx);
extern rtx        gen_vec_widen_smult_hi_v8hi              (rtx, rtx, rtx);
extern rtx        gen_vec_widen_umult_hi_v8hi              (rtx, rtx, rtx);
extern rtx        gen_vec_widen_smult_lo_v16hi             (rtx, rtx, rtx);
extern rtx        gen_vec_widen_umult_lo_v16hi             (rtx, rtx, rtx);
extern rtx        gen_vec_widen_smult_lo_v8hi              (rtx, rtx, rtx);
extern rtx        gen_vec_widen_umult_lo_v8hi              (rtx, rtx, rtx);
extern rtx        gen_vec_widen_smult_hi_v8si              (rtx, rtx, rtx);
extern rtx        gen_vec_widen_umult_hi_v8si              (rtx, rtx, rtx);
extern rtx        gen_vec_widen_smult_lo_v8si              (rtx, rtx, rtx);
extern rtx        gen_vec_widen_umult_lo_v8si              (rtx, rtx, rtx);
extern rtx        gen_vec_widen_smult_hi_v4si              (rtx, rtx, rtx);
extern rtx        gen_vec_widen_smult_lo_v4si              (rtx, rtx, rtx);
extern rtx        gen_vec_widen_umult_hi_v4si              (rtx, rtx, rtx);
extern rtx        gen_vec_widen_umult_lo_v4si              (rtx, rtx, rtx);
extern rtx        gen_sdot_prodv16hi                       (rtx, rtx, rtx, rtx);
extern rtx        gen_sdot_prodv8hi                        (rtx, rtx, rtx, rtx);
extern rtx        gen_sdot_prodv4si                        (rtx, rtx, rtx, rtx);
extern rtx        gen_udot_prodv4si                        (rtx, rtx, rtx, rtx);
extern rtx        gen_sdot_prodv8si                        (rtx, rtx, rtx, rtx);
extern rtx        gen_udot_prodv8si                        (rtx, rtx, rtx, rtx);
extern rtx        gen_vec_shl_v16qi                        (rtx, rtx, rtx);
extern rtx        gen_vec_shl_v8hi                         (rtx, rtx, rtx);
extern rtx        gen_vec_shl_v4si                         (rtx, rtx, rtx);
extern rtx        gen_vec_shl_v2di                         (rtx, rtx, rtx);
extern rtx        gen_vec_shr_v16qi                        (rtx, rtx, rtx);
extern rtx        gen_vec_shr_v8hi                         (rtx, rtx, rtx);
extern rtx        gen_vec_shr_v4si                         (rtx, rtx, rtx);
extern rtx        gen_vec_shr_v2di                         (rtx, rtx, rtx);
extern rtx        gen_smaxv32qi3                           (rtx, rtx, rtx);
extern rtx        gen_sminv32qi3                           (rtx, rtx, rtx);
extern rtx        gen_umaxv32qi3                           (rtx, rtx, rtx);
extern rtx        gen_uminv32qi3                           (rtx, rtx, rtx);
extern rtx        gen_smaxv16hi3                           (rtx, rtx, rtx);
extern rtx        gen_sminv16hi3                           (rtx, rtx, rtx);
extern rtx        gen_umaxv16hi3                           (rtx, rtx, rtx);
extern rtx        gen_uminv16hi3                           (rtx, rtx, rtx);
extern rtx        gen_smaxv8si3                            (rtx, rtx, rtx);
extern rtx        gen_sminv8si3                            (rtx, rtx, rtx);
extern rtx        gen_umaxv8si3                            (rtx, rtx, rtx);
extern rtx        gen_uminv8si3                            (rtx, rtx, rtx);
extern rtx        gen_smaxv4di3                            (rtx, rtx, rtx);
extern rtx        gen_sminv4di3                            (rtx, rtx, rtx);
extern rtx        gen_umaxv4di3                            (rtx, rtx, rtx);
extern rtx        gen_uminv4di3                            (rtx, rtx, rtx);
extern rtx        gen_smaxv2di3                            (rtx, rtx, rtx);
extern rtx        gen_sminv2di3                            (rtx, rtx, rtx);
extern rtx        gen_umaxv2di3                            (rtx, rtx, rtx);
extern rtx        gen_uminv2di3                            (rtx, rtx, rtx);
extern rtx        gen_smaxv16qi3                           (rtx, rtx, rtx);
extern rtx        gen_sminv16qi3                           (rtx, rtx, rtx);
extern rtx        gen_smaxv8hi3                            (rtx, rtx, rtx);
extern rtx        gen_sminv8hi3                            (rtx, rtx, rtx);
extern rtx        gen_smaxv4si3                            (rtx, rtx, rtx);
extern rtx        gen_sminv4si3                            (rtx, rtx, rtx);
extern rtx        gen_umaxv16qi3                           (rtx, rtx, rtx);
extern rtx        gen_uminv16qi3                           (rtx, rtx, rtx);
extern rtx        gen_umaxv8hi3                            (rtx, rtx, rtx);
extern rtx        gen_uminv8hi3                            (rtx, rtx, rtx);
extern rtx        gen_umaxv4si3                            (rtx, rtx, rtx);
extern rtx        gen_uminv4si3                            (rtx, rtx, rtx);
extern rtx        gen_avx2_eqv32qi3                        (rtx, rtx, rtx);
extern rtx        gen_avx2_eqv16hi3                        (rtx, rtx, rtx);
extern rtx        gen_avx2_eqv8si3                         (rtx, rtx, rtx);
extern rtx        gen_avx2_eqv4di3                         (rtx, rtx, rtx);
extern rtx        gen_sse2_eqv16qi3                        (rtx, rtx, rtx);
extern rtx        gen_sse2_eqv8hi3                         (rtx, rtx, rtx);
extern rtx        gen_sse2_eqv4si3                         (rtx, rtx, rtx);
extern rtx        gen_sse4_1_eqv2di3                       (rtx, rtx, rtx);
extern rtx        gen_vcondv32qiv32qi                      (rtx, rtx, rtx, rtx, rtx, rtx);
extern rtx        gen_vcondv16hiv32qi                      (rtx, rtx, rtx, rtx, rtx, rtx);
extern rtx        gen_vcondv8siv32qi                       (rtx, rtx, rtx, rtx, rtx, rtx);
extern rtx        gen_vcondv4div32qi                       (rtx, rtx, rtx, rtx, rtx, rtx);
extern rtx        gen_vcondv8sfv32qi                       (rtx, rtx, rtx, rtx, rtx, rtx);
extern rtx        gen_vcondv4dfv32qi                       (rtx, rtx, rtx, rtx, rtx, rtx);
extern rtx        gen_vcondv32qiv16hi                      (rtx, rtx, rtx, rtx, rtx, rtx);
extern rtx        gen_vcondv16hiv16hi                      (rtx, rtx, rtx, rtx, rtx, rtx);
extern rtx        gen_vcondv8siv16hi                       (rtx, rtx, rtx, rtx, rtx, rtx);
extern rtx        gen_vcondv4div16hi                       (rtx, rtx, rtx, rtx, rtx, rtx);
extern rtx        gen_vcondv8sfv16hi                       (rtx, rtx, rtx, rtx, rtx, rtx);
extern rtx        gen_vcondv4dfv16hi                       (rtx, rtx, rtx, rtx, rtx, rtx);
extern rtx        gen_vcondv32qiv8si                       (rtx, rtx, rtx, rtx, rtx, rtx);
extern rtx        gen_vcondv16hiv8si                       (rtx, rtx, rtx, rtx, rtx, rtx);
extern rtx        gen_vcondv8siv8si                        (rtx, rtx, rtx, rtx, rtx, rtx);
extern rtx        gen_vcondv4div8si                        (rtx, rtx, rtx, rtx, rtx, rtx);
extern rtx        gen_vcondv8sfv8si                        (rtx, rtx, rtx, rtx, rtx, rtx);
extern rtx        gen_vcondv4dfv8si                        (rtx, rtx, rtx, rtx, rtx, rtx);
extern rtx        gen_vcondv32qiv4di                       (rtx, rtx, rtx, rtx, rtx, rtx);
extern rtx        gen_vcondv16hiv4di                       (rtx, rtx, rtx, rtx, rtx, rtx);
extern rtx        gen_vcondv8siv4di                        (rtx, rtx, rtx, rtx, rtx, rtx);
extern rtx        gen_vcondv4div4di                        (rtx, rtx, rtx, rtx, rtx, rtx);
extern rtx        gen_vcondv8sfv4di                        (rtx, rtx, rtx, rtx, rtx, rtx);
extern rtx        gen_vcondv4dfv4di                        (rtx, rtx, rtx, rtx, rtx, rtx);
extern rtx        gen_vcondv16qiv16qi                      (rtx, rtx, rtx, rtx, rtx, rtx);
extern rtx        gen_vcondv8hiv16qi                       (rtx, rtx, rtx, rtx, rtx, rtx);
extern rtx        gen_vcondv4siv16qi                       (rtx, rtx, rtx, rtx, rtx, rtx);
extern rtx        gen_vcondv2div16qi                       (rtx, rtx, rtx, rtx, rtx, rtx);
extern rtx        gen_vcondv4sfv16qi                       (rtx, rtx, rtx, rtx, rtx, rtx);
extern rtx        gen_vcondv2dfv16qi                       (rtx, rtx, rtx, rtx, rtx, rtx);
extern rtx        gen_vcondv16qiv8hi                       (rtx, rtx, rtx, rtx, rtx, rtx);
extern rtx        gen_vcondv8hiv8hi                        (rtx, rtx, rtx, rtx, rtx, rtx);
extern rtx        gen_vcondv4siv8hi                        (rtx, rtx, rtx, rtx, rtx, rtx);
extern rtx        gen_vcondv2div8hi                        (rtx, rtx, rtx, rtx, rtx, rtx);
extern rtx        gen_vcondv4sfv8hi                        (rtx, rtx, rtx, rtx, rtx, rtx);
extern rtx        gen_vcondv2dfv8hi                        (rtx, rtx, rtx, rtx, rtx, rtx);
extern rtx        gen_vcondv16qiv4si                       (rtx, rtx, rtx, rtx, rtx, rtx);
extern rtx        gen_vcondv8hiv4si                        (rtx, rtx, rtx, rtx, rtx, rtx);
extern rtx        gen_vcondv4siv4si                        (rtx, rtx, rtx, rtx, rtx, rtx);
extern rtx        gen_vcondv2div4si                        (rtx, rtx, rtx, rtx, rtx, rtx);
extern rtx        gen_vcondv4sfv4si                        (rtx, rtx, rtx, rtx, rtx, rtx);
extern rtx        gen_vcondv2dfv4si                        (rtx, rtx, rtx, rtx, rtx, rtx);
extern rtx        gen_vcondv2div2di                        (rtx, rtx, rtx, rtx, rtx, rtx);
extern rtx        gen_vcondv2dfv2di                        (rtx, rtx, rtx, rtx, rtx, rtx);
extern rtx        gen_vconduv32qiv32qi                     (rtx, rtx, rtx, rtx, rtx, rtx);
extern rtx        gen_vconduv16hiv32qi                     (rtx, rtx, rtx, rtx, rtx, rtx);
extern rtx        gen_vconduv8siv32qi                      (rtx, rtx, rtx, rtx, rtx, rtx);
extern rtx        gen_vconduv4div32qi                      (rtx, rtx, rtx, rtx, rtx, rtx);
extern rtx        gen_vconduv8sfv32qi                      (rtx, rtx, rtx, rtx, rtx, rtx);
extern rtx        gen_vconduv4dfv32qi                      (rtx, rtx, rtx, rtx, rtx, rtx);
extern rtx        gen_vconduv32qiv16hi                     (rtx, rtx, rtx, rtx, rtx, rtx);
extern rtx        gen_vconduv16hiv16hi                     (rtx, rtx, rtx, rtx, rtx, rtx);
extern rtx        gen_vconduv8siv16hi                      (rtx, rtx, rtx, rtx, rtx, rtx);
extern rtx        gen_vconduv4div16hi                      (rtx, rtx, rtx, rtx, rtx, rtx);
extern rtx        gen_vconduv8sfv16hi                      (rtx, rtx, rtx, rtx, rtx, rtx);
extern rtx        gen_vconduv4dfv16hi                      (rtx, rtx, rtx, rtx, rtx, rtx);
extern rtx        gen_vconduv32qiv8si                      (rtx, rtx, rtx, rtx, rtx, rtx);
extern rtx        gen_vconduv16hiv8si                      (rtx, rtx, rtx, rtx, rtx, rtx);
extern rtx        gen_vconduv8siv8si                       (rtx, rtx, rtx, rtx, rtx, rtx);
extern rtx        gen_vconduv4div8si                       (rtx, rtx, rtx, rtx, rtx, rtx);
extern rtx        gen_vconduv8sfv8si                       (rtx, rtx, rtx, rtx, rtx, rtx);
extern rtx        gen_vconduv4dfv8si                       (rtx, rtx, rtx, rtx, rtx, rtx);
extern rtx        gen_vconduv32qiv4di                      (rtx, rtx, rtx, rtx, rtx, rtx);
extern rtx        gen_vconduv16hiv4di                      (rtx, rtx, rtx, rtx, rtx, rtx);
extern rtx        gen_vconduv8siv4di                       (rtx, rtx, rtx, rtx, rtx, rtx);
extern rtx        gen_vconduv4div4di                       (rtx, rtx, rtx, rtx, rtx, rtx);
extern rtx        gen_vconduv8sfv4di                       (rtx, rtx, rtx, rtx, rtx, rtx);
extern rtx        gen_vconduv4dfv4di                       (rtx, rtx, rtx, rtx, rtx, rtx);
extern rtx        gen_vconduv16qiv16qi                     (rtx, rtx, rtx, rtx, rtx, rtx);
extern rtx        gen_vconduv8hiv16qi                      (rtx, rtx, rtx, rtx, rtx, rtx);
extern rtx        gen_vconduv4siv16qi                      (rtx, rtx, rtx, rtx, rtx, rtx);
extern rtx        gen_vconduv2div16qi                      (rtx, rtx, rtx, rtx, rtx, rtx);
extern rtx        gen_vconduv4sfv16qi                      (rtx, rtx, rtx, rtx, rtx, rtx);
extern rtx        gen_vconduv2dfv16qi                      (rtx, rtx, rtx, rtx, rtx, rtx);
extern rtx        gen_vconduv16qiv8hi                      (rtx, rtx, rtx, rtx, rtx, rtx);
extern rtx        gen_vconduv8hiv8hi                       (rtx, rtx, rtx, rtx, rtx, rtx);
extern rtx        gen_vconduv4siv8hi                       (rtx, rtx, rtx, rtx, rtx, rtx);
extern rtx        gen_vconduv2div8hi                       (rtx, rtx, rtx, rtx, rtx, rtx);
extern rtx        gen_vconduv4sfv8hi                       (rtx, rtx, rtx, rtx, rtx, rtx);
extern rtx        gen_vconduv2dfv8hi                       (rtx, rtx, rtx, rtx, rtx, rtx);
extern rtx        gen_vconduv16qiv4si                      (rtx, rtx, rtx, rtx, rtx, rtx);
extern rtx        gen_vconduv8hiv4si                       (rtx, rtx, rtx, rtx, rtx, rtx);
extern rtx        gen_vconduv4siv4si                       (rtx, rtx, rtx, rtx, rtx, rtx);
extern rtx        gen_vconduv2div4si                       (rtx, rtx, rtx, rtx, rtx, rtx);
extern rtx        gen_vconduv4sfv4si                       (rtx, rtx, rtx, rtx, rtx, rtx);
extern rtx        gen_vconduv2dfv4si                       (rtx, rtx, rtx, rtx, rtx, rtx);
extern rtx        gen_vconduv2div2di                       (rtx, rtx, rtx, rtx, rtx, rtx);
extern rtx        gen_vconduv2dfv2di                       (rtx, rtx, rtx, rtx, rtx, rtx);
extern rtx        gen_vec_permv16qi                        (rtx, rtx, rtx, rtx);
extern rtx        gen_vec_permv8hi                         (rtx, rtx, rtx, rtx);
extern rtx        gen_vec_permv4si                         (rtx, rtx, rtx, rtx);
extern rtx        gen_vec_permv2di                         (rtx, rtx, rtx, rtx);
extern rtx        gen_vec_permv4sf                         (rtx, rtx, rtx, rtx);
extern rtx        gen_vec_permv2df                         (rtx, rtx, rtx, rtx);
extern rtx        gen_vec_permv32qi                        (rtx, rtx, rtx, rtx);
extern rtx        gen_vec_permv16hi                        (rtx, rtx, rtx, rtx);
extern rtx        gen_vec_permv8si                         (rtx, rtx, rtx, rtx);
extern rtx        gen_vec_permv4di                         (rtx, rtx, rtx, rtx);
extern rtx        gen_vec_permv8sf                         (rtx, rtx, rtx, rtx);
extern rtx        gen_vec_permv4df                         (rtx, rtx, rtx, rtx);
extern rtx        gen_vec_perm_constv4sf                   (rtx, rtx, rtx, rtx);
extern rtx        gen_vec_perm_constv4si                   (rtx, rtx, rtx, rtx);
extern rtx        gen_vec_perm_constv2df                   (rtx, rtx, rtx, rtx);
extern rtx        gen_vec_perm_constv2di                   (rtx, rtx, rtx, rtx);
extern rtx        gen_vec_perm_constv16qi                  (rtx, rtx, rtx, rtx);
extern rtx        gen_vec_perm_constv8hi                   (rtx, rtx, rtx, rtx);
extern rtx        gen_vec_perm_constv8sf                   (rtx, rtx, rtx, rtx);
extern rtx        gen_vec_perm_constv4df                   (rtx, rtx, rtx, rtx);
extern rtx        gen_vec_perm_constv8si                   (rtx, rtx, rtx, rtx);
extern rtx        gen_vec_perm_constv4di                   (rtx, rtx, rtx, rtx);
extern rtx        gen_vec_perm_constv32qi                  (rtx, rtx, rtx, rtx);
extern rtx        gen_vec_perm_constv16hi                  (rtx, rtx, rtx, rtx);
extern rtx        gen_one_cmplv32qi2                       (rtx, rtx);
extern rtx        gen_one_cmplv16qi2                       (rtx, rtx);
extern rtx        gen_one_cmplv16hi2                       (rtx, rtx);
extern rtx        gen_one_cmplv8hi2                        (rtx, rtx);
extern rtx        gen_one_cmplv8si2                        (rtx, rtx);
extern rtx        gen_one_cmplv4si2                        (rtx, rtx);
extern rtx        gen_one_cmplv4di2                        (rtx, rtx);
extern rtx        gen_one_cmplv2di2                        (rtx, rtx);
extern rtx        gen_avx2_andnotv32qi3                    (rtx, rtx, rtx);
extern rtx        gen_sse2_andnotv16qi3                    (rtx, rtx, rtx);
extern rtx        gen_avx2_andnotv16hi3                    (rtx, rtx, rtx);
extern rtx        gen_sse2_andnotv8hi3                     (rtx, rtx, rtx);
extern rtx        gen_avx2_andnotv8si3                     (rtx, rtx, rtx);
extern rtx        gen_sse2_andnotv4si3                     (rtx, rtx, rtx);
extern rtx        gen_avx2_andnotv4di3                     (rtx, rtx, rtx);
extern rtx        gen_sse2_andnotv2di3                     (rtx, rtx, rtx);
extern rtx        gen_andv32qi3                            (rtx, rtx, rtx);
extern rtx        gen_iorv32qi3                            (rtx, rtx, rtx);
extern rtx        gen_xorv32qi3                            (rtx, rtx, rtx);
extern rtx        gen_andv16qi3                            (rtx, rtx, rtx);
extern rtx        gen_iorv16qi3                            (rtx, rtx, rtx);
extern rtx        gen_xorv16qi3                            (rtx, rtx, rtx);
extern rtx        gen_andv16hi3                            (rtx, rtx, rtx);
extern rtx        gen_iorv16hi3                            (rtx, rtx, rtx);
extern rtx        gen_xorv16hi3                            (rtx, rtx, rtx);
extern rtx        gen_andv8hi3                             (rtx, rtx, rtx);
extern rtx        gen_iorv8hi3                             (rtx, rtx, rtx);
extern rtx        gen_xorv8hi3                             (rtx, rtx, rtx);
extern rtx        gen_andv8si3                             (rtx, rtx, rtx);
extern rtx        gen_iorv8si3                             (rtx, rtx, rtx);
extern rtx        gen_xorv8si3                             (rtx, rtx, rtx);
extern rtx        gen_andv4si3                             (rtx, rtx, rtx);
extern rtx        gen_iorv4si3                             (rtx, rtx, rtx);
extern rtx        gen_xorv4si3                             (rtx, rtx, rtx);
extern rtx        gen_andv4di3                             (rtx, rtx, rtx);
extern rtx        gen_iorv4di3                             (rtx, rtx, rtx);
extern rtx        gen_xorv4di3                             (rtx, rtx, rtx);
extern rtx        gen_andv2di3                             (rtx, rtx, rtx);
extern rtx        gen_iorv2di3                             (rtx, rtx, rtx);
extern rtx        gen_xorv2di3                             (rtx, rtx, rtx);
extern rtx        gen_andtf3                               (rtx, rtx, rtx);
extern rtx        gen_iortf3                               (rtx, rtx, rtx);
extern rtx        gen_xortf3                               (rtx, rtx, rtx);
extern rtx        gen_vec_pack_trunc_v16hi                 (rtx, rtx, rtx);
extern rtx        gen_vec_pack_trunc_v8hi                  (rtx, rtx, rtx);
extern rtx        gen_vec_pack_trunc_v8si                  (rtx, rtx, rtx);
extern rtx        gen_vec_pack_trunc_v4si                  (rtx, rtx, rtx);
extern rtx        gen_vec_pack_trunc_v4di                  (rtx, rtx, rtx);
extern rtx        gen_vec_pack_trunc_v2di                  (rtx, rtx, rtx);
extern rtx        gen_vec_interleave_highv32qi             (rtx, rtx, rtx);
extern rtx        gen_vec_interleave_highv16hi             (rtx, rtx, rtx);
extern rtx        gen_vec_interleave_highv8si              (rtx, rtx, rtx);
extern rtx        gen_vec_interleave_highv4di              (rtx, rtx, rtx);
extern rtx        gen_vec_interleave_lowv32qi              (rtx, rtx, rtx);
extern rtx        gen_vec_interleave_lowv16hi              (rtx, rtx, rtx);
extern rtx        gen_vec_interleave_lowv8si               (rtx, rtx, rtx);
extern rtx        gen_vec_interleave_lowv4di               (rtx, rtx, rtx);
extern rtx        gen_avx2_pshufdv3                        (rtx, rtx, rtx);
extern rtx        gen_sse2_pshufd                          (rtx, rtx, rtx);
extern rtx        gen_avx2_pshuflwv3                       (rtx, rtx, rtx);
extern rtx        gen_sse2_pshuflw                         (rtx, rtx, rtx);
extern rtx        gen_avx2_pshufhwv3                       (rtx, rtx, rtx);
extern rtx        gen_sse2_pshufhw                         (rtx, rtx, rtx);
extern rtx        gen_sse2_loadd                           (rtx, rtx);
extern rtx        gen_sse_storeq                           (rtx, rtx);
extern rtx        gen_vec_unpacks_lo_v32qi                 (rtx, rtx);
extern rtx        gen_vec_unpacks_lo_v16qi                 (rtx, rtx);
extern rtx        gen_vec_unpacks_lo_v16hi                 (rtx, rtx);
extern rtx        gen_vec_unpacks_lo_v8hi                  (rtx, rtx);
extern rtx        gen_vec_unpacks_lo_v8si                  (rtx, rtx);
extern rtx        gen_vec_unpacks_lo_v4si                  (rtx, rtx);
extern rtx        gen_vec_unpacks_hi_v32qi                 (rtx, rtx);
extern rtx        gen_vec_unpacks_hi_v16qi                 (rtx, rtx);
extern rtx        gen_vec_unpacks_hi_v16hi                 (rtx, rtx);
extern rtx        gen_vec_unpacks_hi_v8hi                  (rtx, rtx);
extern rtx        gen_vec_unpacks_hi_v8si                  (rtx, rtx);
extern rtx        gen_vec_unpacks_hi_v4si                  (rtx, rtx);
extern rtx        gen_vec_unpacku_lo_v32qi                 (rtx, rtx);
extern rtx        gen_vec_unpacku_lo_v16qi                 (rtx, rtx);
extern rtx        gen_vec_unpacku_lo_v16hi                 (rtx, rtx);
extern rtx        gen_vec_unpacku_lo_v8hi                  (rtx, rtx);
extern rtx        gen_vec_unpacku_lo_v8si                  (rtx, rtx);
extern rtx        gen_vec_unpacku_lo_v4si                  (rtx, rtx);
extern rtx        gen_vec_unpacku_hi_v32qi                 (rtx, rtx);
extern rtx        gen_vec_unpacku_hi_v16qi                 (rtx, rtx);
extern rtx        gen_vec_unpacku_hi_v16hi                 (rtx, rtx);
extern rtx        gen_vec_unpacku_hi_v8hi                  (rtx, rtx);
extern rtx        gen_vec_unpacku_hi_v8si                  (rtx, rtx);
extern rtx        gen_vec_unpacku_hi_v4si                  (rtx, rtx);
extern rtx        gen_avx2_uavgv32qi3                      (rtx, rtx, rtx);
extern rtx        gen_sse2_uavgv16qi3                      (rtx, rtx, rtx);
extern rtx        gen_avx2_uavgv16hi3                      (rtx, rtx, rtx);
extern rtx        gen_sse2_uavgv8hi3                       (rtx, rtx, rtx);
extern rtx        gen_sse2_maskmovdqu                      (rtx, rtx, rtx);
extern rtx        gen_avx2_umulhrswv16hi3                  (rtx, rtx, rtx);
extern rtx        gen_ssse3_pmulhrswv8hi3                  (rtx, rtx, rtx);
extern rtx        gen_ssse3_pmulhrswv4hi3                  (rtx, rtx, rtx);
extern rtx        gen_avx2_pblendw                         (rtx, rtx, rtx, rtx);
extern rtx        gen_avx_roundps_sfix256                  (rtx, rtx, rtx);
extern rtx        gen_sse4_1_roundps_sfix                  (rtx, rtx, rtx);
extern rtx        gen_avx_roundpd_vec_pack_sfix256         (rtx, rtx, rtx, rtx);
extern rtx        gen_sse4_1_roundpd_vec_pack_sfix         (rtx, rtx, rtx, rtx);
extern rtx        gen_roundv8sf2                           (rtx, rtx);
extern rtx        gen_roundv4sf2                           (rtx, rtx);
extern rtx        gen_roundv4df2                           (rtx, rtx);
extern rtx        gen_roundv2df2                           (rtx, rtx);
extern rtx        gen_roundv8sf2_sfix                      (rtx, rtx);
extern rtx        gen_roundv4sf2_sfix                      (rtx, rtx);
extern rtx        gen_roundv4df2_vec_pack_sfix             (rtx, rtx, rtx);
extern rtx        gen_roundv2df2_vec_pack_sfix             (rtx, rtx, rtx);
extern rtx        gen_rotlv16qi3                           (rtx, rtx, rtx);
extern rtx        gen_rotlv8hi3                            (rtx, rtx, rtx);
extern rtx        gen_rotlv4si3                            (rtx, rtx, rtx);
extern rtx        gen_rotlv2di3                            (rtx, rtx, rtx);
extern rtx        gen_rotrv16qi3                           (rtx, rtx, rtx);
extern rtx        gen_rotrv8hi3                            (rtx, rtx, rtx);
extern rtx        gen_rotrv4si3                            (rtx, rtx, rtx);
extern rtx        gen_rotrv2di3                            (rtx, rtx, rtx);
extern rtx        gen_vrotrv16qi3                          (rtx, rtx, rtx);
extern rtx        gen_vrotrv8hi3                           (rtx, rtx, rtx);
extern rtx        gen_vrotrv4si3                           (rtx, rtx, rtx);
extern rtx        gen_vrotrv2di3                           (rtx, rtx, rtx);
extern rtx        gen_vrotlv16qi3                          (rtx, rtx, rtx);
extern rtx        gen_vrotlv8hi3                           (rtx, rtx, rtx);
extern rtx        gen_vrotlv4si3                           (rtx, rtx, rtx);
extern rtx        gen_vrotlv2di3                           (rtx, rtx, rtx);
extern rtx        gen_vlshrv16qi3                          (rtx, rtx, rtx);
extern rtx        gen_vlshrv8hi3                           (rtx, rtx, rtx);
extern rtx        gen_vlshrv4si3                           (rtx, rtx, rtx);
extern rtx        gen_vlshrv2di3                           (rtx, rtx, rtx);
extern rtx        gen_vlshrv8si3                           (rtx, rtx, rtx);
extern rtx        gen_vlshrv4di3                           (rtx, rtx, rtx);
extern rtx        gen_vashrv16qi3                          (rtx, rtx, rtx);
extern rtx        gen_vashrv8hi3                           (rtx, rtx, rtx);
extern rtx        gen_vashrv2di3                           (rtx, rtx, rtx);
extern rtx        gen_vashrv4si3                           (rtx, rtx, rtx);
extern rtx        gen_vashrv8si3                           (rtx, rtx, rtx);
extern rtx        gen_vashlv16qi3                          (rtx, rtx, rtx);
extern rtx        gen_vashlv8hi3                           (rtx, rtx, rtx);
extern rtx        gen_vashlv4si3                           (rtx, rtx, rtx);
extern rtx        gen_vashlv2di3                           (rtx, rtx, rtx);
extern rtx        gen_vashlv8si3                           (rtx, rtx, rtx);
extern rtx        gen_vashlv4di3                           (rtx, rtx, rtx);
extern rtx        gen_ashlv16qi3                           (rtx, rtx, rtx);
extern rtx        gen_lshrv16qi3                           (rtx, rtx, rtx);
extern rtx        gen_ashrv16qi3                           (rtx, rtx, rtx);
extern rtx        gen_ashrv2di3                            (rtx, rtx, rtx);
extern rtx        gen_xop_vmfrczv4sf2                      (rtx, rtx);
extern rtx        gen_xop_vmfrczv2df2                      (rtx, rtx);
extern rtx        gen_avx_vzeroall                         (void);
extern rtx        gen_avx2_permv4di                        (rtx, rtx, rtx);
extern rtx        gen_avx_vpermilv4df                      (rtx, rtx, rtx);
extern rtx        gen_avx_vpermilv2df                      (rtx, rtx, rtx);
extern rtx        gen_avx_vpermilv8sf                      (rtx, rtx, rtx);
extern rtx        gen_avx_vpermilv4sf                      (rtx, rtx, rtx);
extern rtx        gen_avx_vperm2f128v8si3                  (rtx, rtx, rtx, rtx);
extern rtx        gen_avx_vperm2f128v8sf3                  (rtx, rtx, rtx, rtx);
extern rtx        gen_avx_vperm2f128v4df3                  (rtx, rtx, rtx, rtx);
extern rtx        gen_avx_vinsertf128v32qi                 (rtx, rtx, rtx, rtx);
extern rtx        gen_avx_vinsertf128v16hi                 (rtx, rtx, rtx, rtx);
extern rtx        gen_avx_vinsertf128v8si                  (rtx, rtx, rtx, rtx);
extern rtx        gen_avx_vinsertf128v4di                  (rtx, rtx, rtx, rtx);
extern rtx        gen_avx_vinsertf128v8sf                  (rtx, rtx, rtx, rtx);
extern rtx        gen_avx_vinsertf128v4df                  (rtx, rtx, rtx, rtx);
extern rtx        gen_vec_initv32qi                        (rtx, rtx);
extern rtx        gen_vec_initv16hi                        (rtx, rtx);
extern rtx        gen_vec_initv8si                         (rtx, rtx);
extern rtx        gen_vec_initv4di                         (rtx, rtx);
extern rtx        gen_vec_initv8sf                         (rtx, rtx);
extern rtx        gen_vec_initv4df                         (rtx, rtx);
extern rtx        gen_avx2_extracti128                     (rtx, rtx, rtx);
extern rtx        gen_avx2_inserti128                      (rtx, rtx, rtx, rtx);
extern rtx        gen_vcvtps2ph                            (rtx, rtx, rtx);
extern rtx        gen_avx2_gathersiv2di                    (rtx, rtx, rtx, rtx, rtx, rtx);
extern rtx        gen_avx2_gathersiv2df                    (rtx, rtx, rtx, rtx, rtx, rtx);
extern rtx        gen_avx2_gathersiv4di                    (rtx, rtx, rtx, rtx, rtx, rtx);
extern rtx        gen_avx2_gathersiv4df                    (rtx, rtx, rtx, rtx, rtx, rtx);
extern rtx        gen_avx2_gathersiv4si                    (rtx, rtx, rtx, rtx, rtx, rtx);
extern rtx        gen_avx2_gathersiv4sf                    (rtx, rtx, rtx, rtx, rtx, rtx);
extern rtx        gen_avx2_gathersiv8si                    (rtx, rtx, rtx, rtx, rtx, rtx);
extern rtx        gen_avx2_gathersiv8sf                    (rtx, rtx, rtx, rtx, rtx, rtx);
extern rtx        gen_avx2_gatherdiv2di                    (rtx, rtx, rtx, rtx, rtx, rtx);
extern rtx        gen_avx2_gatherdiv2df                    (rtx, rtx, rtx, rtx, rtx, rtx);
extern rtx        gen_avx2_gatherdiv4di                    (rtx, rtx, rtx, rtx, rtx, rtx);
extern rtx        gen_avx2_gatherdiv4df                    (rtx, rtx, rtx, rtx, rtx, rtx);
extern rtx        gen_avx2_gatherdiv4si                    (rtx, rtx, rtx, rtx, rtx, rtx);
extern rtx        gen_avx2_gatherdiv4sf                    (rtx, rtx, rtx, rtx, rtx, rtx);
extern rtx        gen_avx2_gatherdiv8si                    (rtx, rtx, rtx, rtx, rtx, rtx);
extern rtx        gen_avx2_gatherdiv8sf                    (rtx, rtx, rtx, rtx, rtx, rtx);
extern rtx        gen_sse2_lfence                          (void);
extern rtx        gen_sse_sfence                           (void);
extern rtx        gen_sse2_mfence                          (void);
extern rtx        gen_mem_thread_fence                     (rtx);
extern rtx        gen_atomic_loadqi                        (rtx, rtx, rtx);
extern rtx        gen_atomic_loadhi                        (rtx, rtx, rtx);
extern rtx        gen_atomic_loadsi                        (rtx, rtx, rtx);
extern rtx        gen_atomic_loaddi                        (rtx, rtx, rtx);
extern rtx        gen_atomic_storeqi                       (rtx, rtx, rtx);
extern rtx        gen_atomic_storehi                       (rtx, rtx, rtx);
extern rtx        gen_atomic_storesi                       (rtx, rtx, rtx);
extern rtx        gen_atomic_storedi                       (rtx, rtx, rtx);
extern rtx        gen_atomic_compare_and_swapqi            (rtx, rtx, rtx, rtx, rtx, rtx, rtx, rtx);
extern rtx        gen_atomic_compare_and_swaphi            (rtx, rtx, rtx, rtx, rtx, rtx, rtx, rtx);
extern rtx        gen_atomic_compare_and_swapsi            (rtx, rtx, rtx, rtx, rtx, rtx, rtx, rtx);
extern rtx        gen_atomic_compare_and_swapdi            (rtx, rtx, rtx, rtx, rtx, rtx, rtx, rtx);
extern rtx        gen_atomic_compare_and_swapti            (rtx, rtx, rtx, rtx, rtx, rtx, rtx, rtx);

#endif /* GCC_INSN_FLAGS_H */
