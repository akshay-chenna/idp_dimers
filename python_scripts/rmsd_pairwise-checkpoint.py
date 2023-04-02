#!/usr/bin/env python
# coding: utf-8
# ## The code below aligns the interface to each frame in the row. Therefore the y axis is the reference frame and x axis is the mobile trajectory. Unlike traj_interface_rmsd.py which aligns only to the first frame.

import MDAnalysis as mda
from MDAnalysis.analysis import rms
import numpy as np
import matplotlib.pyplot as plt
import seaborn as sb
import matplotlib

u = mda.Universe("mdframe.pdb","md_corrected.xtc")
v = u

interface = '((around 7.5 chainID B) and backbone) or ((around 7.5 chainID A) and backbone)'
x = np.zeros([len(u.trajectory), len(u.trajectory)])
for i in range(0,len(u.trajectory)):
    v.trajectory[i]
    r = rms.RMSD(u, v, select=interface, ref_frame=i).run()
    x[i,:] = r.rmsd[:,2]

cmap = matplotlib.cm.get_cmap("jet", 6)
plt.figure(figsize=(12,8))
sb.heatmap(x, cmap = cmap, vmax=15)
plt.xlabel('Mobile')
plt.ylabel('Reference')
plt.title('Frame-wise interface Backbone RMSD  ($\AA$)')
plt.savefig('rmsd_map.jpg')

