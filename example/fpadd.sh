#!/bin/bash

#NOTE Other values are NOT possible because
#     this value is hardcoded in some tools!
DBNAME=gen_output/pivpav.db

set -e

mkdir -p "$(dirname $DBNAME)"
if [ ! -e "$DBNAME" ] ; then
	../pivpav/library/create-schema.tcl | sqlite3 $DBNAME
fi

ARGS="$*"
if [ -z "$ARGS" ] ; then
	ARGS="fpadd fraction 53 exponent 11"
fi

../pivpav/factory/gen_coregen.tcl -db "$DBNAME" -write_rowid "rowid" $ARGS
ROWID="$(cat rowid)"
../pivpav/benchmark/bench.tcl $ROWID
../pivpav/library/insert-measure.tcl -db "$DBNAME" -write_rowid "m_rowid" gen_output/_db_circuits/measure_db_store.txt
M_ROWID="$(cat m_rowid)"
../pivpav/library/insert-reports.tcl -m_id $M_ROWID -db $DBNAME gen_output/_db_circuits/ise
