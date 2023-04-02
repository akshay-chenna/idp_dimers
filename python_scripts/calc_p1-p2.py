# 17-July 2022,  Obtain P1 and P2 vectors from a trajectory

import numpy as np
import MDAnalysis as mda
from MDAnalysis.analysis.base import (AnalysisBase, AnalysisFromFunction, analysis_class)
import sys

a = sys.argv[1] # Load topology
b = sys.argv[2] # Load trajectory

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
    
u = mda.Universe(a,b)
dimer = u.select_atoms("protein and name CA")
orientation_params = AnalysisFromFunction(order_params, u.trajectory, dimer)
orientation_params.run();

np.savetxt('p1.txt', orientation_params.results['timeseries'][:,0], fmt='%.2f')
np.savetxt('p2.txt', orientation_params.results['timeseries'][:,1], fmt='%.2f')
