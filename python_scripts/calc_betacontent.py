# July 17th 2022, This script calculates the beta content of a given protein

import mdtraj as md
import numpy as np
import sys

a = sys.argv[1] # Load Trajectory
b = sys.argv[2] # Load topology

u = md.load(a, top=b)
x = md.compute_dssp(u) 								# Gives H,E,C for each frame over all the residues.
es = np.array([ np.size(np.where(x[i,:]=='E')) for i in range(x.shape[0]) ])    # Find the number of 'E's.
np.savetxt('beta_content.txt', es, fmt='%d') 					# Save Es
