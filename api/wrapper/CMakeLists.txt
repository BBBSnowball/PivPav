project (WRAPPER CXX)

message("# Creating Makefile for '${PROJECT_NAME}'")
cmake_minimum_required(VERSION 2.6)

include("${CMAKE_CURRENT_SOURCE_DIR}/../dir.conf")


include_directories(${DIR_UTILS})
include_directories(${DIR_HWWRITE})
include_directories(${DIR_SQL})
include_directories(${DIR_GETOPERATOR})

SUBDIRS(${DIR_UTILS})
SUBDIRS(${DIR_HWWRITE})
SUBDIRS(${DIR_SQL})
SUBDIRS(${DIR_GETOPERATOR})

find_library(SQLITE3_LIB      NAMES sqlite3 )

add_library(libwrapper            SHARED libwrapper)
set_target_properties(libwrapper  PROPERTIES OUTPUT_NAME "wrapper")
add_executable(wrapper            main)
target_link_libraries(wrapper     libwrapper libgetOperator libsql ${SQLITE3_LIB} libhw_write libutils)


FIND_PACKAGE(SWIG REQUIRED 2.0)
INCLUDE(${SWIG_USE_FILE})

SET(CMAKE_SWIG_FLAGS "")

FIND_PACKAGE(PythonLibs)
INCLUDE_DIRECTORIES(${PYTHON_INCLUDE_PATH})

set(cxx_debug "-g")

set(SWIG_SOURCES_DIR ${DIR_PYTHON_WRAPPER})

# The SWIG cmake target doesn't like ".." in paths, so we copy the file to the build directory
# and create a directory to put the *.cxx file into.
add_custom_command(OUTPUT ${CMAKE_BINARY_DIR}/pivpav-wrapper.i DEPENDS ${SWIG_SOURCES_DIR}/pivpav-wrapper.i PRE_BUILD
	COMMAND ${CMAKE_COMMAND} -E
		copy ${SWIG_SOURCES_DIR}/pivpav-wrapper.i ${CMAKE_BINARY_DIR}/pivpav-wrapper.i)
set(SWIG_MODULE_pivpav_EXTRA_DEPS ${CMAKE_BINARY_DIR}/pivpav-wrapper.i)
GET_FILENAME_COMPONENT(SWIG_CXX_OUTPUT_DIR ${CMAKE_BINARY_DIR} NAME)	# just a crude guess, unfortunately...
file(MAKE_DIRECTORY ${CMAKE_BINARY_DIR}/${SWIG_CXX_OUTPUT_DIR})

# We need at least one C++ source file, so we create an empty one.
set(SWIG_CXX_DUMMY ${CMAKE_BINARY_DIR}/dummy.cpp)
IF(NOT(EXISTS(${SWIG_CXX_DUMMY})))
	FILE(WRITE ${SWIG_CXX_DUMMY} "" )
ENDIF(NOT(EXISTS(${SWIG_CXX_DUMMY})))

SET_SOURCE_FILES_PROPERTIES(${CMAKE_BINARY_DIR}/pivpav-wrapper.i PROPERTIES CPLUSPLUS ON)
SWIG_ADD_MODULE(pivpav python ${CMAKE_BINARY_DIR}/pivpav-wrapper.i ${SWIG_CXX_DUMMY})
SWIG_LINK_LIBRARIES(pivpav ${PYTHON_LIBRARIES} libwrapper libgetOperator libsql ${SQLITE3_LIB} libhw_write libutils)
set_property(TARGET _pivpav PROPERTY COMPILE_FLAGS "${cxx_debug}")
