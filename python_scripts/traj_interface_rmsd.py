#!/usr/bin/env python
# coding: utf-8

# # Scripts to calculate interface RMSD

# ## Interface RMSD from a trajectory: ALIGNS ONLY TO THE FIRST FRAME

import sys
import MDAnalysis as mda
from MDAnalysis.analysis import align, rms, diffusionmap
import numpy as np
import matplotlib.pyplot as plt
import seaborn as sb
from matplotlib import cm
import matplotlib
from matplotlib.ticker import StrMethodFormatter
from matplotlib.colors import ListedColormap, LinearSegmentedColormap

a = sys.argv[1] # Load topology
b = sys.argv[2] # Load Trajectory
c = sys.argv[3] # Definition for interface in angstroms distance from the other chain
d = '((around '+c+' chainID B) and backbone) or (around '+c+' chainID A) and backbone' # Select interface atoms


u = mda.Universe(a,b)
aligner = align.AlignTraj(u, u, select=d, in_memory=True).run() # Align the trajectories with frame-wise reference
matrix = diffusionmap.DistanceMatrix(u, select=d).run() # Find the rmsd

# Plot RMSD

custom_map = cm.get_cmap('jet')
newcolors = custom_map(np.linspace(0,1,6))
new_cmp = ListedColormap(newcolors)

matplotlib.rcParams.update({'font.size': 22})
plt.figure(figsize=(15,10)).patch.set_facecolor('white')
sb.heatmap(matrix.dist_matrix, cmap=new_cmp, vmax=15)
plt.title("Interface backbone RMSD (10ns)")
plt.xlabel('Frame')
plt.ylabel('Frame')
plt.savefig('interface_rmsd.jpg')

