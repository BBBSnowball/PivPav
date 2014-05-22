%module pivpav

%{
#include "getOperator.h"
%}

%include "std_string.i"
%include "std_vector.i"

%ignore verbose;

%rename(input)   in;
%rename(output)  out;
%rename(printIt) print;

%template(SignalVector) std::vector< Signal* >;

%include "getOperator.h"
%include "hw_write.h"
%include "Operator.hpp"
%include "Signal.hpp"
%include "debug.h"
%include "sql.h"
%include "utils.h"
//%include "wrapper.h"

%extend Operator {
	%pythoncode %{
		__swig_setmethods__["copyright_string"] = setCopyrightString
		if _newclass: copyright_string = property(None, setCopyrightString)
		__swig_setmethods__["name"]             = setName
		__swig_getmethods__["name"]             = getName
		if _newclass: name             = property(getName, setName)
		__swig_setmethods__["cycle"]            = setCycle
		if _newclass: cycle            = property(None, setCycle)
		__swig_getmethods__["sequential"]       = isSequential
		__swig_setmethods__["sequential"]       = setSequential
		if _newclass: sequential       = property(isSequential, setSequential)
		__swig_setmethods__["combinatorial"]    = setCombinatorial
		if _newclass: combinatorial    = property(None, setCombinatorial)
		__swig_setmethods__["clk_name"]         = setClk
		__swig_getmethods__["clk_name"]         = getClkName
		if _newclass: clk_name         = property(getClkName, setClk)
		__swig_getmethods__["rst_name"]         = getRstName
		if _newclass: rst_name         = property(getRstName)
		__swig_getmethods__["c_e_name"]         = getCEName
		if _newclass: c_e_name         = property(getCEName)
		__swig_getmethods__["io_list_size"]     = getIOListSize
		if _newclass: io_list_size     = property(getIOListSize)
		__swig_getmethods__["io_list"]          = getIOList
		if _newclass: io_list          = property(getIOList)
		__swig_setmethods__["pipeline_depth"]   = setPipelineDepth
		__swig_getmethods__["pipeline_depth"]   = getPipelineDepth
		if _newclass: pipeline_depth   = property(getPipelineDepth, setPipelineDepth)

		def __getitem__(self, signal_name):
			return self.getSignalByName(signal_name)
	%}
};

%extend Signal {
	%pythoncode %{
		__swig_getmethods__["name"]                      = getName
		if _newclass: name                      = property(getName)
		__swig_getmethods__["exception"]                 = getException
		if _newclass: exception                 = property(getException)
		__swig_getmethods__["sign"]                      = getSign
		if _newclass: sign                      = property(getSign)
		__swig_getmethods__["exponent"]                  = getExponent
		if _newclass: exponent                  = property(getExponent)
		__swig_getmethods__["mantissa"]                  = getMantissa
		if _newclass: mantissa                  = property(getMantissa)
		__swig_getmethods__["cycle"]                     = getCycle
		__swig_setmethods__["cycle"]                     = setCycle
		if _newclass: cycle                     = property(getCycle,                  setCycle)
		__swig_getmethods__["life_span"]                 = getLifeSpan
		__swig_setmethods__["life_span"]                 = updateLifeSpan
		if _newclass: life_span                 = property(getLifeSpan,               updateLifeSpan)
		__swig_getmethods__["number_of_possible_values"] = getNumberOfPossibleValues
		__swig_setmethods__["number_of_possible_values"] = setNumberOfPossibleValues
		if _newclass: number_of_possible_values = property(getNumberOfPossibleValues, setNumberOfPossibleValues)
		__swig_getmethods__["clk"]                       = isClk
		__swig_setmethods__["clk"]                       = setClk
		if _newclass: clk                       = property(isClk,                     setClk)
		__swig_getmethods__["rst"]                       = isRst
		__swig_setmethods__["rst"]                       = setRst
		if _newclass: rst                       = property(isRst,                     setRst)
		__swig_getmethods__["ce"]                        = isCE
		__swig_setmethods__["ce"]                        = setCE
		if _newclass: ce                        = property(isCE,                      setCE)
		__swig_getmethods__["signed"]                    = isSigned
		__swig_setmethods__["signed"]                    = setSigned
		if _newclass: signed                    = property(isSigned,                  setSigned)
		__swig_getmethods__["unsigned"]                  = isUnsigned
		__swig_setmethods__["unsigned"]                  = setUnsigned
		if _newclass: unsigned                  = property(isUnsigned,                setUnsigned)
		__swig_getmethods__["registered"]                = isRegistered
		__swig_setmethods__["registered"]                = setRegistered
		if _newclass: registered                = property(isRegistered,              setRegistered)
	%}
};


%extend Operator {
	%pythoncode %{
		def __str__(self):
			return "%s(%r)" % (self.__class__.__name__, self.name)

		def __repr__(self):
			properties = ["name", "sequential", "clk_name", "rst_name", "c_e_name",
				"io_list_size", "pipeline_depth" ]
			property_values = [ "%s=%r" % (property, getattr(self, property)) for property in properties ]
			
			return "%s(%s)" % (self.__class__.__name__, ", ".join(property_values))
	%}
}

%extend Signal {
	%pythoncode %{
		def __str__(self):
			return "%s(%r)" % (self.__class__.__name__, self.name)

		def __repr__(self):
			properties = [ "name", "exception", "sign", "exponent", "mantissa", "cycle", "life_span",
				"number_of_possible_values", "clk", "rst", "ce", "signed", "unsigned", "registered" ]
			property_values = [ "%s=%r" % (property, getattr(self, property)) for property in properties ]
			
			return "%s(%s)" % (self.__class__.__name__, ", ".join(property_values))
	%}
}

%extend std::vector<Signal*> {
	%pythoncode %{
		def __str__(self, child_to_string=str):
			return "[ %s ]" % (", ".join(map(child_to_string, self)))

		def __repr__(self, child_to_string=repr):
			return self.__str__(child_to_string)
	%}
}
