import pivpav

opg = pivpav.getOperator()
opg.setDatabase("../../example/gen_output/pivpav.db")
op = opg.select_by_rowid(1)
print op
print op.name
signals = op.getIOList()
print signals[0]

print op.sequential
print op["a"].name
print op["b"].life_span
