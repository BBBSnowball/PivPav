#!/bin/bash

#NOTE Other values are NOT possible because
#     this value is hardcoded in some tools!
DBNAME=gen_output/pivpav.db

set -e

mkdir -p "$(dirname $DBNAME)"
../pivpav/library/create-schema.tcl | sqlite3 $DBNAME
../pivpav/factory/gen_coregen.tcl -db $DBNAME fpadd fraction 53 exponent 11
../pivpav/benchmark/bench.tcl 1
../pivpav/library/insert-measure.tcl -db gen_output/pivpav.db gen_output/_db_circuits/measure_db_store.txt
../pivpav/library/insert-reports.tcl -m_id 1 -db $DBNAME gen_output/_db_circuits/ise
