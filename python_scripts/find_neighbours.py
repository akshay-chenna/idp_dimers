import mdtraj as md
t = md.load('ch4342.pdb')
top = t.topology
nsp_CA = top.select('chainid 1 and name CA')
t.restrict_atoms(nsp_CA)
neighbors = [md.compute_neighbors(t,0.6,[i], np.arange(70)) for i in range(70)]
list_neighbors = [list(neighbors[i][0]+1) for i,_ in enumerate(neighbors)]
with open('neighbors.txt','w') as f:
	for item in list_neighbors:
		f.write("%s \n" %str(item)[1:-1])
exit()
