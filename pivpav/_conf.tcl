#!/usr/bin/env xtclsh

if {  [ namespace exists "::CONFIG" ] } { return }
namespace eval ::CONFIG ""
# ===================================================================== #
# other dirs directories
# ===================================================================== #


# Power reporting seems to be different with newer Xilinx ISE versions
# and I couldn't figure out how to make it work again. If the scripts
# fail, try to disable this.
# If you need this, have a look at xpwr. It can generate a pwr report
# from the ncd and pcf file. However, the format seems to be quite
# different, so I won't look into that.
set ::CONFIG::with_power_report 0


# ===================================================================== #
# database
# ===================================================================== #
set ::CONFIG::db_dir             "library"
set ::CONFIG::db_data_dir        "${::CONFIG::db_dir}/data"
set ::CONFIG::db_extract_dir     "${::CONFIG::db_dir}/extract_scripts"
set ::CONFIG::db_file            "${::CONFIG::db_dir}/circuits.db"
set ::CONFIG::db_file            "../example/gen_output/pivpav.db"
set ::CONFIG::db_sql_schema_file "${::CONFIG::db_data_dir}/schema.sql"
set ::CONFIG::db_sql_view_file   "${::CONFIG::db_data_dir}/create_view.sql"
set ::CONFIG::db_insert_cir_file "${::CONFIG::db_dir}/insert-circuit.tcl"
set ::CONFIG::db_extr_file       "${::CONFIG::db_extract_dir}/extract-files.tcl"
set ::CONFIG::db_extr_cir_file   "${::CONFIG::db_extract_dir}/extract-circuit.tcl"

set ::CONFIG::db_debug           1
set ::CONFIG::db_debug           0

# ===================================================================== #
# ise configuration
# ===================================================================== #
# default settings for hardware device when using ise.tcl
namespace eval SET {
  set _devicefamily zynq
  set _device       XC7Z020
  # We have a Zynq with clg400 package, but that doesn't have enough pins for
  # the temporary models used by pivpav.
  set _package      clg484
  set _speedgrade  -1
}
# not supported for Zynq
set ::CONFIG::with_power_reduction 0

set ::CONFIG::bench_dir               "benchmark"
set ::CONFIG::ise_file                "${::CONFIG::bench_dir}/ise.tcl"
set ::CONFIG::ise_design_goal_dir     "${::CONFIG::bench_dir}/design_goals"
set ::CONFIG::ise_db_api_file         "ise_db_store.txt"
set ::CONFIG::ise_design_goal_default "timing_with_phys_synt"

if {$::CONFIG::with_power_report} {
  set ::CONFIG::vhdl_compile_cmd [list  "Check Syntax" "Synthesize - XST" "Translate" "Map" "Place & Route" "Generate Power Data" ] 
} else {
  set ::CONFIG::vhdl_compile_cmd [list  "Check Syntax" "Synthesize - XST" "Translate" "Map" "Place & Route" ]
}
set ::CONFIG::xco_compile_cmd [list  "Regenerate Core" ]
set ::CONFIG::wrapper_ise_error_code    13


# ===================================================================== #
# measure
# ===================================================================== #
set ::CONFIG::measure_dir "../example/gen_output/_db_circuits"
set ::CONFIG::measure_db_api_file "measure_db_store.txt"
set ::CONFIG::measure_ise_dir     "ise"


# ===================================================================== #
# vhdl
# ===================================================================== #
set ::CONFIG::vhdl_dir             "misc/vhdl"
set ::CONFIG::vhdl_parse_api_file  "${::CONFIG::vhdl_dir}/parse_api.tcl"
set ::CONFIG::vhdl_ports_api_file  "${::CONFIG::vhdl_dir}/ports_api.tcl"

# ===================================================================== #
# other files
# ===================================================================== #
set ::CONFIG::utils_file      "misc/utils_api.tcl"


# ===================================================================== #
# CIRCUITS FACTORY 
# ===================================================================== #
set ::CONFIG::circuit_dir "factory"

# circuits - generator configuration - COREGEN
# ================================== #
set ::CONFIG::gen_cg_dir          "${::CONFIG::circuit_dir}/gen_coregen"
set ::CONFIG::gen_cg_maps_dir     "${::CONFIG::gen_cg_dir}/xco_maps"
set ::CONFIG::gen_cg_lib_dir      "${::CONFIG::gen_cg_dir}/lib"
set ::CONFIG::gen_cg_compile_dir  "../example/gen_output/_db_circuits"
set ::CONFIG::gen_cg_work_dir     "compile"

  # under that path work_dir will be establish and the following files will be placed:
  # work_dir = ${::CONFIG::gen_cg_compile_dir}/circuit_name
  # ${::CONFIG::gen_cg_compile_dir}/circuit_name/${::CONFIG::gen_cg_work_dir}
  # ${::CONFIG::gen_cg_compile_dir}/circuit_name/circuit_name.xco
  # ${::CONFIG::gen_cg_compile_dir}/circuit_name/circuit_name_xst.log

set ::CONFIG::gen_cg_op_file          "${::CONFIG::gen_cg_dir}/operator.tcl"
set ::CONFIG::gen_cg_xco_parser_file  "${::CONFIG::gen_cg_lib_dir}/xco_parser.tcl"
set ::CONFIG::gen_cg_xco_maps_file    "${::CONFIG::gen_cg_lib_dir}/xco_maps.tcl"

  # the files bellow will be stored in work_dir
set ::CONFIG::gen_cg_time_file        "gen_cg_time.txt"
set ::CONFIG::gen_cg_db_api_file      "gen_cg_db_store.txt"
set ::CONFIG::gen_cg_stdout_dup_file  "stdout.log"
set ::CONFIG::gen_cg_stderr_dup_file  "stderr.log"

set ::CONFIG::gen_debug               1

# circuits - generator configuration FLOPOCO
# ================================== #
set ::CONFIG::gen_flo_dir      "${::CONFIG::circuit_dir}/gen_flopoco"
set ::CONFIG::gen_flo_bin_file "flopoco"
# set ::CONFIG::gen_flo_bin_md5_file "md5"
set ::CONFIG::gen_flo_bin_md5_file "md5sum"
set ::CONFIG::gen_flo_bin_time_file "time"

# circuits - custom
# ================================== #
set ::CONFIG::add_cust_cir_file "${::CONFIG::circuit_dir}/addCustomCircuit.tcl"
set ::CONFIG::add_cust_cir_db_api_file    "db_store.txt"


# ===================================================================== #
# wrapper configuration
# ===================================================================== #
set ::CONFIG::wrapper_bin_file          "bin/wrapper"
set ::CONFIG::wrapper_clock_freq        "10"

# ===================================================================== #
# reports configuration
# ===================================================================== #
set ::CONFIG::report_dir "${::CONFIG::bench_dir}/reports"
set ::CONFIG::report_schema_file "${::CONFIG::report_dir}/schema.tcl"

# we are searching variables which names begin with report_for_*
set ::CONFIG::report_xst_file "${::CONFIG::report_dir}/report_xst.tcl" 
set ::CONFIG::report_xst_mask "syr gir"
set ::CONFIG::report_map_file "${::CONFIG::report_dir}/report_map.tcl"
set ::CONFIG::report_map_mask "map"
set ::CONFIG::report_par_file "${::CONFIG::report_dir}/report_par.tcl" 
set ::CONFIG::report_par_mask "par"
set ::CONFIG::report_trc_file "${::CONFIG::report_dir}/report_trc.tcl"
set ::CONFIG::report_trc_mask "twr"
if {$::CONFIG::with_power_report} {
  set ::CONFIG::report_pwr_file "${::CONFIG::report_dir}/report_pwr.tcl"
  set ::CONFIG::report_pwr_mask "pwr"
}

set ::CONFIG::report_col_num    5
set ::CONFIG::report_field_size 22


# ===================================================================== #
set ::CONFIG::bash_config_file "_conf.sh"


# ===================================================================== #
# C libraries
# ===================================================================== #
if {[file isfile "/usr/share/tcl8.5/sqlite3/libtclsqlite3.so"]} {
  # VMWARE:
  load /usr/share/tcl8.5/sqlite3/libtclsqlite3.so Sqlite3
} elseif {[file isfile "/usr/lib64/tcl8.5/sqlite3/libtclsqlite3.so"]} {
  load /usr/lib64/tcl8.5/sqlite3/libtclsqlite3.so Sqlite3
} elseif {[file isfile "/scratch/mgrad/localtools/installed/lib/libtclsqlite3.so"]} {
  load /scratch/mgrad/localtools/installed/lib/libtclsqlite3.so
} elseif {[file isfile "/home-pc2/user/mgrad/tools/lib/libtclsqlite3.so"]} {
  # pvc203:
  load /home-pc2/user/mgrad/tools/lib/libtclsqlite3.so
} elseif {[file isfile "/usr/lib/tcltk/sqlite3/libtclsqlite3.so"]} {
  # Ubuntu 12.04
  # (may work for other versions of Debian and Ubuntu)
  load /usr/lib/tcltk/sqlite3/libtclsqlite3.so
} else {
  puts stderr "ERROR: Couldn't find sqlite3 library for TCL!"
  puts stderr "Please edit pivpav/_conf.tcl to change its path."
  exit 1
}


# ===================================================================== #
# others
# ===================================================================== #
set ::CONFIG::comment_line "# ======================================================================================= #"



# ===================================================================== #
# --- parse this configuration variables and for each create  ---
# --- duplicate with suffix _full and value proceed with      ---
# --- the full path e.g.:
# ---  ::CONFIG::report_trc_file       = reports/report_trc.tcl
# ---  ::CONFIG::report_trc_file_full  = /scratch/mgrad/Work/scripts/reports/report_trc.tcl
# ===================================================================== #

proc set_full_path {pat} {
  # this is absolut directory to _conf.tcl script
  set abs_dir_to_conf [ file normalize [ file dirname [ info script ] ] ] 
  set rel_dir_to_conf [ file dirname [ info script ]] 

  # all values found bellowe will be at the begging proceed with the $abs_dir
  foreach v [ info vars ::CONFIG::*${pat} ] {
    set val [ set $v ]
    set first_char [ string range $val 0 0 ]
  
    # remove " if found (when it's the 1st elem of list)
    regsub -all {\"} $val {} val

    if { [ string compare  $first_char "/" ] != 0  } {
      set ${v}_full "$abs_dir_to_conf/$val"
    } else {
      set ${v}_full $val
      set ${v} [ regsub "$abs_dir_to_conf/" $val {} ]
    }

    # we change here $v that it would be relative to executed script
    set ${v}_rel "$rel_dir_to_conf/[set ${v}]"

#    puts "${v}      = [ set ${v} ]"
#    puts "${v}_rel  = [ set ${v}_rel ]"
#    puts "${v}_full = [ set ${v}_full ]\n"
  }
}

proc create_config_for_bash {} {
  set fid [ open $::CONFIG::bash_config_file w ]
  foreach v [ info vars ::CONFIG::* ] {
    set val [ set $v ]
    regsub -all {::} $v {_} v
    puts $fid "export  ${v}=\"${val}\""
  }
  close $fid
}

set_full_path dir 
set_full_path file
create_config_for_bash
