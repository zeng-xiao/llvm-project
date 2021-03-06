## This test checks that llvm-dwarfdump can dump debug_macro.dwo
## section containing DW_MACRO_*_strp forms present in a dwo object.

# RUN: llvm-mc -triple x86_64-unknown-linux -filetype=obj %s -o -| \
# RUN:   llvm-dwarfdump -debug-macro - | FileCheck -strict-whitespace -match-full-lines %s

#      CHECK:.debug_macro.dwo contents:
# CHECK-NEXT:0x00000000:
# CHECK-NEXT:macro header: version = 0x0005, flags = 0x02, format = DWARF32, debug_line_offset = 0x00000000
# CHECK-NEXT:DW_MACRO_start_file - lineno: 0 filenum: 0
# CHECK-NEXT:  DW_MACRO_define_strp - lineno: 1 macro: DWARF_VERSION 5
# CHECK-NEXT:  DW_MACRO_undef_strp - lineno: 4 macro: DWARF_VERSION
# CHECK-NEXT:DW_MACRO_end_file

	.section	.debug_macro.dwo,"e",@progbits
.Lcu_macro_begin0:
	.short	5                      # Macro information version
	.byte	2                       # Flags: 32 bit, debug_line_offset present
	.long	0                       # debug_line_offset
	.byte	3                       # DW_MACRO_start_file
	.byte	0                       # Line Number
	.byte	0                       # File Number
	.byte	5                       # DW_MACRO_define_strp
	.byte	1                       # Line Number
	.long	.Linfo_string0-.debug_str.dwo   # Macro String
	.byte	6                       # DW_MACRO_undef_strp
	.byte	4                       # Line Number
	.long	.Linfo_string1-.debug_str.dwo   # Macro String
	.byte	4                       # DW_MACRO_end_file
	.byte	0                       # End Of Macro List Mark

	.section	.debug_str.dwo,"eMS",@progbits,1
.Linfo_string0:
	.asciz	"DWARF_VERSION 5"
.Linfo_string1:
	.asciz	"DWARF_VERSION"
