#!/usr/bin/env python
# coding: utf-8
# ## This code find the distance RMSD matrix between two trajectories

import MDAnalysis as mda
import numpy as np
import matplotlib.pyplot as plt
import seaborn as sb
from MDAnalysis.analysis import encore
from MDAnalysis.analysis.encore.clustering import ClusteringMethod as clm


u = mda.Universe("1/mdframe.pdb","1/md_corrected.xtc")
v = mda.Universe("2/mdframe.pdb","2/md_corrected.xtc")

interface = '((around 7.5 chainID B) and backbone) or ((around 7.5 chainID A) and backbone)'

rmsd_matrix1 = encore.get_distance_matrix(encore.utils.merge_universes([u, v]), select=interface, superimposition_subset=interface, save_matrix="rmsd_interfacebb.npz", n_jobs=6 )

rmsd_matrix2 = encore.get_distance_matrix(encore.utils.merge_universes([u, v]), select='backbone', superimposition_subset='backbone', save_matrix="rmsd_bb.npz", n_jobs=6 )
