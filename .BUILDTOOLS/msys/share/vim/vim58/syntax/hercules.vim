" Vim syntax file
" Language:	Hercules (Avant! Corporation)
" Maintainer:	Dana Edwards <Dana_Edwards@avanticorp.com>
" Extensions:   *.vc,*.ev,*.rs,*.sum,*.errsum
" Last change:  03/01/2001
" Comment:      Hercules physical IC design verification software ensures
"		that an IC's physical design matches its logical design and
"		satisfies manufacturing rules.

" For version 5.x: Clear all syntax items
" For version 6.x: Quit when a syntax file was already loaded
if version < 600
  syntax clear
elseif exists("b:current_syntax")
  finish
endif

" Ignore case
syn case ignore

" Hercules runset sections
syn match   herculesType        "^\s*\t*header"
syn match   herculesType        "^\s*\t*options"
syn match   herculesType        "^\s*\t*alias"
syn match   herculesType        "^\s*\t*assign"
syn match   herculesType        "^\s*\t*assign_property"
syn match   herculesType        "^\s*\t*waiver"
syn match   herculesType        "^\s*\t*.*_options"
syn match   herculesType        "^\s*\t*check_point"
syn match   herculesType        "^\s*\t*compare_group"
syn match   herculesType        "^\s*\t*environment"
syn match   herculesType        "^\s*\t*grid_check"
syn match   herculesType        "^\s*\t*include"
syn match   herculesType        "^\s*\t*layer_stats"
syn match   herculesType        "^\s*\t*load_group"
syn match   herculesType        "^\s*\t*.*run_only"
syn match   herculesType        "^\s*\t*restart"
syn match   herculesType        "^\s*\t*self_intersect"
syn match   herculesType        "^\s*\t*set "
syn match   herculesType        "^\s*\t*set\t"
syn match   herculesType        "^\s*\t*snap"
syn match   herculesType        "^\s*\t*system"
syn match   herculesType        "^\s*\t*variable"

" Hercules commands and keywords
syn match   herculesstatement   "^ *\(attach_property\|boolean\|cell_extent\)"
syn match   herculesstatement   "^ *\(common_hierarchy\|connection_points\|size_rect\)"
syn match   herculesstatement   "^ *\(copy\|data_filter\|alternate\|delete\)"
syn match   herculesstatement   "^ *\(explode\|explode_all\|find_net\|flatten\)"
syn match   herculesstatement   "^ *\(fill_pattern\|rectangles\|select_contains\)"
syn match   herculesstatement   "^ *\(level\|negate\|polygon_features\|push\)"
syn match   herculesstatement   "^ *\(relocate\|remove_overlap\|reverse\|select\)"
syn match   herculesstatement   "^ *\(select_cell\|select_edge\|select_net\|size\)"
syn match   herculesstatement   "^ *\(text_polygon\|text_property\|area\|cut\|notch\)"
syn match   herculesstatement   "^ *\(center_to_center\|inductor\|write_milkyway\)"
syn match   herculesstatement   "^ *\(density\|enclose\|enc\|external\|ext\|inside_edge\)"
syn match   herculesstatement   "^ *\(internal\|int\|vectorize\|select_vector\)"
syn match   herculesstatement   "^ *\(length\|mask_align\|moscheck\|rescheck\)"
syn match   herculesstatement   "^ *\(analysis\|buildsub\|init_lpe_db\|capacitor\)"
syn match   herculesstatement   "^ *\(device\|gendev\|nmos\|pmos\|diode\|npn\|pnp\)"
syn match   herculesstatement   "^ *\(resistor\|set_param\|save_property\|cap\|text	\)"
syn match   herculesstatement   "^ *\(res\|connect\|disconnect\|text \|text_boolean\)"
syn match   herculesstatement   "^ *\(replace_text\|create_ports\|label\|graphics\)"
syn match   herculesstatement   "^ *\(save_netlist_database\|lpe_stats\|netlist\)"
syn match   herculesstatement   "^ *\(spice\|graphics_property\|graphics_netlist\)"
syn match   herculesstatement   "^ *\(vertex\|if\|error_property\|equate\|compare\)"
syn match   herculesstatement   "^ *\(antenna_fix\|c_thru\|dev_connect_check\)"
syn match   herculesstatement   "^ *\(dev_net_count\|device_count\|net_filter\)"
syn match   herculesstatement   "^ *\(net_path_check\|ratio\|process_text_opens\)"
syn match   herculesstatement   "^ *\(classify_edges\|write_extract_view\)"

" Hercules commands and keywords
syn keyword herculesStatement   black_box_file block compare_dir equivalence
syn keyword herculesStatement   format gdsin_dir group_dir group_dir_usage
syn keyword herculesStatement   inlib layout_path outlib output_format
syn keyword herculesStatement   output_layout_path schematic schematic_format
syn keyword herculesStatement   scheme_file output_block else
syn keyword herculesstatement   and or not xor andoverlap inside outside by to
syn keyword herculesstatement   with connected connected_all texted_with texted
syn keyword herculesstatement   by_property cutting edge_touch enclosing inside
syn keyword herculesstatement   equations inside_hole interact touching vertex

" Hercules comments
syn region herculesComment           start="/\*" end="\*/" contains=herculesTodo
syn match herculesComment            "//.*" contains=herculesTodo

" Preprocessor directives
syn match   herculesPreProc "^#.*"
syn match   herculesPreProc "^@.*"
syn match   herculesPreProc "macros"

" Hercules COMMENT option
syn match  herculesCmdCmnt "comment.*=.*"

" Spacings, Resolutions, Ranges, Ratios, etc.
syn match  herculesNumber          "-\=\<[0-9]\+L\=\>\|0[xX][0-9]\+\>"

" Parenthesis sanity checker
syn region herculesZone       matchgroup=Delimiter start="(" matchgroup=Delimiter end=")" transparent contains=ALLBUT,herculesError,herculesBraceError,herculesCurlyError
syn region herculesZone       matchgroup=Delimiter start="{" matchgroup=Delimiter end="}" transparent contains=ALLBUT,herculesError,herculesBraceError,herculesParenError
syn region herculesZone       matchgroup=Delimiter start="\[" matchgroup=Delimiter end="]" transparent contains=ALLBUT,herculesError,herculesCurlyError,herculesParenError
syn match  herculesError      "[)\]}]"
syn match  herculesBraceError "[)}]"  contained
syn match  herculesCurlyError "[)\]]" contained
syn match  herculesParenError "[\]}]" contained

" Hercules output format
syn match  herculesOutput "([0-9].*)"
syn match  herculesOutput "([0-9].*\;.*)"
syn match  herculesOutput "perm.*=.*"
syn match  herculesOutput "temp.*=.*"
syn match  herculesOutput "error\s*=\s*(.*)"

"Modify the following as needed.  The trade-off is performance versus functionality.
syn sync lines=100

" Define the default highlighting.
" For version 5.7 and earlier: only when not done already
" For version 5.8 and later: only when an item doesn't have highlighting yet
if version >= 508 || !exists("did_hercules_syntax_inits")
  if version < 508
    let did_hercules_syntax_inits = 1
    command -nargs=+ HiLink hi link <args>
  else
    command -nargs=+ HiLink hi def link <args>
  endif

  HiLink herculesStatement  Statement
  HiLink herculesType       Type
  HiLink herculesComment    Comment
  HiLink herculesPreProc    PreProc
  HiLink herculesTodo       Todo
  HiLink herculesOutput     Include
  HiLink herculesCmdCmnt    Identifier
  HiLink herculesNumber     Number
  HiLink herculesBraceError herculesError
  HiLink herculesCurlyError herculesError
  HiLink herculesParenError herculesError
  HiLink herculesError      Error

  delcommand HiLink
endif

let b:current_syntax = "hercules"

" vim: ts=8
