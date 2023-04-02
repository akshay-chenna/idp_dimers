import numpy as np
from scipy.spatial.distance import cosine

def dotproduct(comp, chainA, chainB):
    dimer = np.load(comp)
    cha = np.load(chainA)
    chb = np.load(chainB)
    delsasa_cha = cha - dimer[:,0:140]
    delsasa_chb = chb - dimer[:,140:]
    
    
    # Cosine distance for chain A
    dotAA = np.zeros((delsasa_cha.shape[0],delsasa_cha.shape[0]))
    for i in range(0,delsasa_cha.shape[0]):
        for j in range(0,i):
            dotAA[i,j] = 1 - cosine(delsasa_cha[i,:],delsasa_cha[j,:])
            
    dotBB = np.zeros((delsasa_chb.shape[0],delsasa_chb.shape[0]))
    for i in range(0,delsasa_chb.shape[0]):
        for j in range(0,i):
            dotBB[i,j] = 1 - cosine(delsasa_chb[i,:],delsasa_chb[j,:])
            
    dotAB = np.zeros((delsasa_cha.shape[0],delsasa_chb.shape[0]))
    for i in range(0,delsasa_cha.shape[0]):
        for j in range(0,delsasa_chb.shape[0]):
            dotAA[i,j] = 1 - cosine(delsasa_cha[i,:],delsasa_chb[j,:])
           
    
    return dotAA, dotBB, dotAB

x,y,z = dotproduct("sasa_complex.npy","sasa_cha.npy","sasa_chb.npy")
np.save("dotAA",x)
np.save("dotBB",y)
np.save("dotAB",z)
