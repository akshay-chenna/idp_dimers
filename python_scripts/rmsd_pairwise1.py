#!/usr/bin/env python
# coding: utf-8
# ## Interface RMSD of 2 wrt 1
import MDAnalysis as mda
from MDAnalysis.analysis import rms
import numpy as np
import matplotlib.pyplot as plt
import seaborn as sb
import matplotlib

u = mda.Universe("1/mdframe.pdb","1/md_corrected.xtc")
v = mda.Universe("2/mdframe.pdb", "2/md_corrected.xtc")

interface = '((around 7.5 chainID B) and backbone) or ((around 7.5 chainID A) and backbone)'
x = np.zeros([len(u.trajectory), len(u.trajectory)])
for i in range(0,len(u.trajectory)):
    
    u.trajectory[i]
    t = u.select_atoms(interface)
    lst = []
    for l in t.indices:
        temp = "index " + str(l)
        lst.append(temp)
    selection = tuple(lst)
    
    r = rms.RMSD(v, u, select=(selection,selection), ref_frame=i).run()
    x[i,:] = r.rmsd[:,2]

np.save('rmsd_2wrt1.npy',x)
cmap = matplotlib.cm.get_cmap("jet", 6)
plt.figure(figsize=(12,8))
sb.heatmap(x, cmap = cmap, vmax=15)
plt.xlabel('Mobile')
plt.ylabel('Reference')
plt.title('Frame-wise interface Backbone RMSD  ($\AA$)')
plt.savefig('rmsd_cross2wrt1.jpg')