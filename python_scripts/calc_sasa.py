import numpy as np
import mdtraj as md


u = md.load('md_corrected.xtc', top='mdframe.pdb')
#sasa = md.shrake_rupley(u, mode='residue')
#np.save('sasa_complex',sasa)

#selection = u.topology.select('chainid 0')
#u.restrict_atoms(selection)
#sasa_chA = md.shrake_rupley(u, mode='residue')
#np.save('sasa_cha',sasa_chA)
                                      
selection = u.topology.select('chainid 1')
u.restrict_atoms(selection)
sasa_chB = md.shrake_rupley(u, mode='residue')
np.save('sasa_chb',sasa_chB)
