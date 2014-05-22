import pivpav

opg = pivpav.getOperator()
opg.setDatabase("../../example/gen_output/pivpav.db")
op = opg.select_by_rowid(1)
print op
print op.name
signals = op.getIOList()
print signals[0]

print op.io_list

print op.sequential
print op["s_axis_a_tdata"].name
print op["s_axis_b_tvalid"].life_span
