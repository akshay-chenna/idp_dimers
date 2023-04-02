import numpy as np
from scipy.spatial.distance import cosine

def dotproduct(comp1, chainA1, chainB1, comp2, chainA2, chainB2):
    dimer1 = np.load(comp1)
    cha1 = np.load(chainA1)
    chb1 = np.load(chainB1)
    delsasa_cha1 = cha1 - dimer1[:,0:140]
    delsasa_chb1 = chb1 - dimer1[:,140:]
    
    dimer2 = np.load(comp2)
    cha2 = np.load(chainA2)
    chb2 = np.load(chainB2)
    delsasa_cha2 = cha2 - dimer2[:,0:140]
    delsasa_chb2 = chb2 - dimer2[:,140:]
    
    # Cosine distance for chain A
    dotA1A2 = np.zeros((delsasa_cha1.shape[0],delsasa_cha2.shape[0]))
    for i in range(0,delsasa_cha1.shape[0]):
        for j in range(0,delsasa_cha2.shape[0]):
            dotA1A2[i,j] = 1 - cosine(delsasa_cha1[i,:],delsasa_cha2[j,:])
            
    dotB1B2 = np.zeros((delsasa_chb1.shape[0],delsasa_chb2.shape[0]))
    for i in range(0,delsasa_chb1.shape[0]):
        for j in range(0,delsasa_chb2.shape[0]):
            dotB1B2[i,j] = 1 - cosine(delsasa_chb1[i,:],delsasa_chb2[j,:])
           
    
    return dotA1A2, dotB1B2

x,y = dotproduct("1/sasa_complex.npy","1/sasa_cha.npy","1/sasa_chb.npy","2/sasa_complex.npy","2/sasa_cha.npy","2/sasa_chb.npy")

np.save("dotA1A2",x)
np.save("dotB1B2",y)
