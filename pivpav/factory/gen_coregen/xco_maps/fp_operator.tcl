# ====================================================================
# mappings for add component between xco file (coregen) and
# general parameters. They overwrite lib/xco_maps.tcl default settings.
# ====================================================================

namespace eval XCO_MAP {


proc xco_get {param args} {
  switch -glob $param {
    operation    { 
      set op $::CSET::_operation_type
      switch -regexp -- $op {

        "Add_Subtract" { 
            set sub_op  $::CSET::_add_sub_value 
            switch -regexp -- $sub_op {
              "Both" { return "fpadd_sub" }
              "Add"  { return "fpadd" }
              "Sub"  { return "fpsub" }
              Default { exit 1 }
            }
        }

        "Divide"         { return "fpdiv" }
        "Multiply"       { return "fpmul" }
        "Square_root"    { return "fpsqrt" }
        "Float_to_fixed" { return "fp_float2int" }
        "Fixed_to_float" { return "fp_int2float" }
        "Compare"        { 
          set sub_op $::CSET::_c_compare_operation
          switch -regexp -- $sub_op {
            "Less_Than"             { return "fpcmp_ls" }
            "Equal"                 { return "fpcmp_eq" }
            "Less_Than_Or_Equal"    { return "fpcmp_ls_eq" }
            "Greater_Than"          { return "fpcmp_gr" }
            "Not_Equal"             { return "fpcmp_neq" }
            "Greater_Than_Or_Equal" { return "fpcmp_gr_eq" }
            "Condition_Code"        { return "fpcmp_condition" }
            "Unordered"             { return "fpcmp_unordered" }
            "Programmable"          { return "fpcmp_program" }
          }
          return "fpcmp"
        }
      }
      return $op
    }
    inputs_rate { 
      set op $::CSET::_operation_type
      if {[regexp {Divide|Square_root} $op]} {
        return $::CSET::_c_rate 
      }
      return 0;
    }

    latency  { return $::CSET::_c_latency }
    fraction { return $::CSET::_c_a_fraction_width }
    exponent { return $::CSET::_c_a_exponent_width }
    size     { return [ expr $::CSET::_c_a_fraction_width + $::CSET::_c_a_exponent_width ] }

    # when there is mapping 1:1
    default      { 
      set varname [ XCO_MAP::xco_defmap $param $args ] 
      if {[string compare $varname "" ] != 0 } {
        return [ set $varname ]
      }
      return ""
    }
  }

}

proc xco_set {param value} {
  switch -glob $param {
    name         { set CSET::_component_name  $value }
    latency { 
      switch $value {
        maximum {
          # WARNING: This will probably not work!
          set CSET::_c_latency -1
          set CSET::_maximum_latency true
        }
        default {
          set CSET::_c_latency         $value
          if { $value == 0 } { 
            set CSET::_has_ce "false"
          }
        }
      }
    }
    fraction {
      set ::CSET::_c_a_fraction_width      $value
      set ::CSET::_c_result_fraction_width $value
      set ::CSET::_a_precision_type        "Custom"
      set ::CSET::_result_precision_type   "Custom"
    }
    exponent {
      set ::CSET::_c_a_exponent_width      $value
      set ::CSET::_c_result_exponent_width $value
      set ::CSET::_a_precision_type        "Custom"
      set ::CSET::_result_precision_type   "Custom"
    }
    default     { 
      set varname [ xco_defmap $param ]
      if { [ string compare $varname "" ] == 0 } {
        puts stderr "No variables found for parameter: $param";
        exit 1
      } else {
        set $varname $value
      }
    }
  }
}
# ===================================================================== #
# this signals have always fixed types

rename ::XCO_MAP::getType ::XCO_MAP::getType_def
proc getType {port_name isIn} {
  switch -- $port_name {
    "operation"      { return [\list 0 0 0 0 0 ] } 
    "operation_nd"   { return [\list 0 0 0 0 0 ] }
    "sclr"           { return [\list 0 0 0 0 0 ] } 
    "ce"             { return [\list 0 0 0 0 0 ] } 
    "clk"            { return [\list 0 0 0 0 0 ] } 

    "operation_rfd"  { return [\list 0 0 0 0 0 ] }
    "underflow"      { return [\list 0 0 0 0 0 ] }
    "overflow"       { return [\list 0 0 0 0 0 ] }
    "invalid_op"     { return [\list 0 0 0 0 0 ] }
    "divice_by_zero" { return [\list 0 0 0 0 0 ] } 
    "rdy"            { return [\list 0 0 0 0 0 ] }

    default         { return [ ::XCO_MAP::getType_def $port_name $isIn ] }
  }
}

# end of namespace
}
