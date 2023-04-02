# 17-July 2022,  Obtain P1 and P2 vectors from a trajectory

import numpy as np
import MDAnalysis as mda
from MDAnalysis.analysis.base import (AnalysisBase, AnalysisFromFunction, analysis_class)

def order_params(atomgroup):
    num_CAs_chain = int(len(atomgroup.positions)/2)
    
    x = atomgroup.positions[num_CAs_chain-1,:] - atomgroup.positions[0,:]
    y = atomgroup.positions[-1,:] - atomgroup.positions[num_CAs_chain,:]
    
    q = np.empty([3, 3])
    for i in range(0,3):
        for j in range(i,3):
            q[i,j] = 0.25*( (3*np.dot(x[i],x[j])) + (3*np.dot(y[i],y[j])) )
            q[j,i] = q[i,j]
            
    e, v = np.linalg.eig(q)
    d = v[np.argmax(e),:]

    x_norm = x/np.linalg.norm(x)
    y_norm = y/np.linalg.norm(y)
    
    p2 = 0.25*( (3*(np.dot(x_norm, d)**2) -1 ) + (3*(np.dot(y_norm, d)**2) -1) )
    p1 = 0.5*( (np.dot(x_norm,d)) + (np.dot(y_norm,d)) )
    
    return abs(p1), abs(p2)
    
u = mda.Universe("../1/mdframe_1.pdb","../1/md_corrected_1.xtc")
dimer = u.select_atoms("protein and name CA")
orientation_params = AnalysisFromFunction(order_params, u.trajectory, dimer)
orientation_params.run();

np.savetxt('p1.txt', orientation_params.results['timeseries'][:,0])
np.savetxt('p2.txt', orientation_params.results['timeseries'][:,1])

'''
sb.set_context("poster")

plt.rcParams.update({'font.size': 22})
plt.figure(figsize=(8, 8))
plt.plot(orientation_params.results['timeseries'][:,0])
plt.title('Strand polarity')
plt.xlabel('Simulation Time (ps)')
plt.ylabel('P1')
plt.grid(axis='y')

plt.rcParams.update({'font.size': 22})
plt.figure(figsize=(8, 8))
plt.plot(orientation_params.results['timeseries'][:,1])
plt.title('Orderness')
plt.xlabel('Simulation Time (ps)')
plt.ylabel('P2')
plt.grid(axis='y')


plt.rcParams.update({'font.size': 22})
plt.figure(figsize=(8, 8))
plt.scatter(orientation_params.results['timeseries'][:,0],orientation_params.results['timeseries'][:,1], c=range(0,len(orientation_params.results['timeseries'])))

plt.title('Map')
plt.xlabel('Polarity')
plt.ylabel('Orderness')
plt.grid(axis='y')
plt.grid(axis='x')


# In[3]:


heatmap, xedges, yedges = np.histogram2d(orientation_params.results['timeseries'][:,0], orientation_params.results['timeseries'][:,1], bins=50)
extent = [xedges[0], xedges[-1], yedges[0], yedges[-1]]
plt.rcParams.update({'font.size': 22})
plt.figure(figsize=(8, 8))
plt.imshow(heatmap.T, extent=extent, origin='lower', cmap='gist_yarg')
plt.title('Map')
plt.xlabel('Polarity')
plt.ylabel('Orderness')
plt.grid(axis='y')
plt.grid(axis='x')


# In[32]:


plt.rcParams.update({'font.size': 22})
plt.figure(figsize=(15, 12))
plt.hexbin(orientation_params.results['timeseries'][:,0], orientation_params.results['timeseries'][:,1], gridsize=30, cmap='turbo')
plt.title('Population landscape (~130 ns dimer)')
plt.xlabel('Polarity (P1)')
plt.ylabel('Orderness (P2)')
plt.axhline(y=0.7, color='w')
plt.axvline(x=0.4, color='w')
plt.axvline(x=0.7, color='w')
plt.text(0.1,0.75,'Ordered', color='w')
plt.text(0.35,0.02,'Anti-parallel', color='w', rotation=90)
plt.text(0.72, 0.02,'Parallel', color='w', rotation=90)
plt.colorbar()


# In[ ]:
'''
