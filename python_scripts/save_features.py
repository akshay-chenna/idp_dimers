# March 02, 2023
## Extracts features from a trajectory and saves them as a numpy file
### See dimensional_reduction.ipynb for more details

import pyemma
import numpy as np

topology = './mdframe.pdb'
with open("x1") as f:
	x = f.read().splitlines()
traj_list = ['{}/md_corrected.xtc'.format(i) for i in x]

'''
feataurizer = pyemma.coordinates.featurizer(topology)
ca_distance_pairs = featurizer.pairs(featurizer.select_Ca())
featurizer.add_distances(ca_distance_pairs, periodic=False)
coord_data = pyemma.coordinates.load(traj_list, features=featurizer,stride=10) # Extracts every 100 ps
np.save('cadist_data.npy',coord_data)
'''

featurizer = pyemma.coordinates.featurizer(topology)
ca_distance_pairs = featurizer.pairs(featurizer.select_Ca())
featurizer.add_inverse_distances(ca_distance_pairs, periodic=False)
coord_data = pyemma.coordinates.load(traj_list, features=featurizer,stride=10) # Extracts every 100 ps
np.save('invcadist_data.npy',coord_data)

#featurizer.add_selection(featurizer.select_Ca()) # Selects coordinates of Ca
