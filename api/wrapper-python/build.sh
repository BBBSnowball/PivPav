#!/bin/sh

set -e

INCLUDE_DIRS="-I../getOperator -I../include -I../utils -I../hw_write -I../sqlite-c -I../wrapper"

swig $INCLUDE_DIRS -c++ -python pivpav-wrapper.i

g++ -o _pivpav.so -shared -fPIC                              \
	$INCLUDE_DIRS                                            \
	pivpav-wrapper_wrap.cxx                                  \
	-L ../wrapper/build/ -l wrapper                          \
	-L ../wrapper/build/getOperator -l getOperator           \
	-L ../wrapper/build/getOperator/sqlite-c -l sql          \
	-l sqlite3                                               \
	-L ../wrapper/build/getOperator/hw_write -l hw_write     \
	-L ../wrapper/build/getOperator/sqlite-c/utils -l utils  \
	$(pkg-config --cflags --libs python)

rm -rf wrapper-libs ; mkdir wrapper-libs
find ../wrapper/build -name "*.so" -exec cp {} wrapper-libs/ \;
LD_LIBRARY_PATH=wrapper-libs python test.py
