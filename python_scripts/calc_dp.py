import numpy as np
from scipy.spatial.distance import cosine
import matplotlib.pyplot as plt

def dotproduct(comp, chainA):
    dimer = np.load(comp)
    cha = np.load(chainA)
    delsasa_cha = np.abs(cha - dimer[:,0:70])
    nsp7 = np.abs(np.genfromtxt('../nsp7_cluster1area.txt'))
    
    # Cosine distance for chain A
    dotAA = np.zeros(delsasa_cha.shape[0])
    for i in range(0,delsasa_cha.shape[0]):
        dotAA[i] = 1 - cosine(nsp7,delsasa_cha[i,:])    
    
    return dotAA

x = dotproduct("sasa_complex.npy","sasa_chb.npy")
np.save("dot",x)

#plt.style.use(['nature','no-latex'])
plt.figure(figsize=(4.5,3.5))
plt.xlabel('Time (ps)')
plt.ylabel('dot-product')
plt.title('Peptide-NSP7 complex')
plt.plot(x)
plt.savefig('dot.jpg', dpi=600)
