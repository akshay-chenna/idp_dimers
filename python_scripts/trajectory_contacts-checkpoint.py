################### MANY IMPORTANT CODES ########################
# # Computations for nsp7 residue contacts
# * This script calculates the number of residue contacts on nsp7.
# * An implementation of the JCTC 2021, RPM's paper: See figure S.3.B ?

# 21-10-2022

# ## Calculate the number of residue contacts
import numpy as np
import matplotlib.pyplot as plt
import MDAnalysis as mda

def residue_contacts(topology, trajectory):
    u = mda.Universe(topology,trajectory)
    interface = '((around 5 (chainID A and not name H*)) and (chainID B and not name H*))' 
    contacts = []
    for i in range(len(u.trajectory)):
        u.trajectory[i]
        contacts.append(np.unique(u.select_atoms(interface).resids))  #Resids start from 1
    return contacts

with open('mmlist.txt','r') as f:
    files = f.readlines()
for f in files:
    contacts = residue_contacts(f.strip()+'/em1.pdb', f.strip()+'/md_corrected.xtc')
    np.save(f.strip()+'/contacts_residue_nsp7.npy',contacts)

# ## Compute fraction of native contacts
import numpy as np
import matplotlib.pyplot as plt
nsp7_native_contacts = np.genfromtxt('/home/chemical/phd/chz198152/scratch/covid/cyclic_docked/reu_docked/getcontactspy/nsp12_nsp7/nsp7residues_in_contact.txt')
num_native_contacts = len(nsp7_native_contacts)
with open('mmlist.txt', 'r') as f:
    files = f.readlines()
for f in files:
    contacts = np.load(f.strip()+'/contacts_residue_nsp7.npy', allow_pickle=True)
    fcc = []
    for l in contacts:
        fcc.append(len(np.intersect1d(l,nsp7_native_contacts))/num_native_contacts)
    np.save(f.strip()+'/fcc_residue_nsp7.npy',fcc)

# ## Plot Fcc
'''
import numpy as np
import matplotlib.pyplot as plt

with open('mmlist.txt', 'r') as f:
    files = f.readlines()

plt.rcParams['font.size'] = '16'
fig, axes = plt.subplots(4,5,figsize=(24,16), sharex=True, sharey=True)
for i, ax in enumerate(axes.flatten()):
    fcc = np.load(files[i].strip()+'/fcc_residue_nsp7.npy')
    ax.plot(fcc)
    ax.plot([0, 1000],[0.1,.1], 'k')
    ax.text(100,0.4,str(i+1))
    ax.text(900,0.4,str(fcc[-500:].mean())[:4])
plt.tight_layout()
fig.text(0.45, 1, '10ns MD of rosetta design')
fig.text(0.5,0, "#Frames")
fig.text(-0.01, 0.5, "FCC (receptor)", rotation='vertical')
plt.savefig('fcc_residue_nsp7.jpg', dpi=300, bbox_inches='tight')
'''
# # Computations for nsp7 atom level contacts
# ## Compute FCC
import numpy as np
import matplotlib.pyplot as plt
import MDAnalysis as mda

def atom_fcc(topology, trajectory, reference):
    u = mda.Universe(topology,trajectory)
    v = mda.Universe(reference, reference)
    interface_u = '((around 5 (chainID A and not name H*)) and (chainID B and not name H*))'
    interface_v = '(around 5 (chainID A and not (name H* or name [1-9]H*))) and (chainID C and not ( name H* or name [1-9]H*))'
    
    ref_atoms = v.select_atoms(interface_v)
    ref_names = [str(i)+j for i,j in zip (ref_atoms.resids-1,ref_atoms.names)]
    num_atoms_ref = len(ref_names)
    fcc = []
    for i in range(len(u.trajectory)):
        u.trajectory[i]
        u_atoms = u.select_atoms(interface_u)
        u_names = [str(i)+j for i,j in zip (u_atoms.resids,u_atoms.names)]
        fcc.append(len(set(u_names).intersection(set(ref_names)))/num_atoms_ref)
    return fcc

with open('mmlist.txt','r') as f:
    files = f.readlines()
for f in files:
    fcc = atom_fcc(f.strip()+'/em1.pdb', f.strip()+'/md_corrected.xtc','/home/chemical/phd/chz198152/scratch/covid/cyclic_docked/reu_docked/getcontactspy/nsp12_nsp7/ch4342.pdb')
    np.save(f.strip()+'/fcc_atom_nsp7.npy',fcc)

# ## Plot FCC
'''
import numpy as np
import matplotlib.pyplot as plt

with open('mmlist.txt', 'r') as f:
    files = f.readlines()

plt.rcParams['font.size'] = '16'
fig, axes = plt.subplots(4,5,figsize=(24,16), sharex=True, sharey=True)
for i, ax in enumerate(axes.flatten()):
    fcc = np.load(files[i].strip()+'/fcc_atom_nsp7.npy')
    ax.plot(fcc)
    #ax.plot([0, 1000],[0.1,.1], 'k')
    ax.text(100,0.15,str(i+1))
    ax.text(900,0.15,str(fcc[-500:].mean())[:4])
plt.tight_layout()
fig.text(0.45, 1, '10ns MD of rosetta design')
fig.text(0.5,0, "#Frames")
fig.text(-0.01, 0.5, "FCC (receptor)", rotation='vertical')
plt.savefig('fcc_atom_nsp7.jpg', dpi=300, bbox_inches='tight')
'''

# # Find independent contacts
import numpy as np
import matplotlib.pyplot as plt
import MDAnalysis as mda
from MDAnalysis.analysis import contacts,distances
from scipy.optimize import linprog

def common_independent_contacts(topology, trajectory, reference):
    u = mda.Universe(topology, trajectory)
    ref = mda.Universe(reference, reference)
    
    interface_ref = '(around 5 (chainID A and not (name H* or name [1-9]H*))) and (chainID C and not ( name H* or name [1-9]H*))'
    int_ref_atoms = ref.select_atoms(interface_ref)
    int_ref_names = np.array([str(i)+j for i,j in zip (int_ref_atoms.resids-1,int_ref_atoms.names)])
    
    interface_u = '((around 5 (chainID A and not name H*)) and (chainID B and not name H*))'
    heavy_u = 'chainID B and not name H*'
    heavy_u_atoms = u.select_atoms(heavy_u)
    heavy_u_names = np.array([str(i)+j for i,j in zip (heavy_u_atoms.resids,heavy_u_atoms.names)])

    independent_common_contacts = []
    for i in range(len(u.trajectory)):
        try:
            u.trajectory[i]
            u_atoms = u.select_atoms(interface_u)
            u_names = np.array([str(i)+j for i,j in zip (u_atoms.resids,u_atoms.names)])

            dist = distances.distance_array(heavy_u_atoms.positions, heavy_u_atoms.positions)
            neighbour_contact_matrix = distances.contact_matrix(heavy_u_atoms.positions, 6)

            contact_indices = np.where(np.in1d(heavy_u_names, int_ref_names))[0]
            u_indices = np.where(np.in1d(heavy_u_names, u_names))[0]

            reduced_neighbours = neighbour_contact_matrix[u_indices,:][:,contact_indices]
            matrix_indices = np.where(np.any(reduced_neighbours, axis=1))[0]
            selected_nodes = u_indices[matrix_indices]
            ilp_matrix = neighbour_contact_matrix[selected_nodes,:][:,selected_nodes].astype(int)

            if ilp_matrix.size == 0:
                independent_common_contacts.append(0)
            else:
                A = -1 * ilp_matrix
                b = -1 * np.ones(len(ilp_matrix))
                f = np.ones(len(ilp_matrix))
                bnd = [(0,1)]*len(ilp_matrix)
                integers = np.ones(len(ilp_matrix))
                opt = linprog(c=f, A_ub = A, b_ub = b, bounds=bnd, integrality = integers)
                independent_common_contacts.append(sum(opt.x))
        except:
            independent_common_contacts.append(0)
    return np.array(independent_common_contacts)

with open('mmlist.txt','r') as f:
    files = f.readlines()

reference = '/home/chemical/phd/chz198152/scratch/covid/cyclic_docked/reu_docked/getcontactspy/nsp12_nsp7/ch4342.pdb'
for f in files:
    contacts = common_independent_contacts(f.strip()+'/em1.pdb',f.strip()+'/md_corrected.xtc', reference)
    np.save(f.strip()+'/common_independent_contacts.npy', contacts)

# ## Plot independent common contacts
'''
import numpy as np
import matplotlib.pyplot as plt

with open('mmlist.txt', 'r') as f:
    files = f.readlines()

plt.rcParams['font.size'] = '16'
fig, axes = plt.subplots(4,5,figsize=(24,16), sharex=True, sharey=True)
for i, ax in enumerate(axes.flatten()):
    contacts = np.load(files[i].strip()+'/common_independent_contacts.npy')
    ax.plot(contacts)
    ax.text(50,6.7,str(i+1))
    ax.text(900,2,str(contacts[-500:].mean())[:4])
plt.tight_layout()
fig.text(0.45, 1, '10ns MD of rosetta design')
fig.text(0.5,0, "#Frames")
fig.text(-0.01, 0.5, "Common Independent contacts (receptor)", rotation='vertical')
plt.savefig('common_independent_atomcontacts_nsp7.jpg', dpi=300, bbox_inches='tight')
'''

# # Cyclotide contacts (atom-level)
# ## Compute FCC
import numpy as np
import matplotlib.pyplot as plt
import MDAnalysis as mda

def cyclotide_native_contacts(topology, trajectory, reference):
    u = mda.Universe(topology, trajectory)
    ref = mda.Universe(topology, reference)
    interface = '(around 5 (chainID B and not name H*)) and (chainID A and not name H*)'
    ref_contacts = ref.select_atoms(interface).indices
    num_ref_contacts = len(ref_contacts)
    fcc = []
    for i in range(len(u.trajectory)):
        u.trajectory[i]
        fcc.append(len(np.intersect1d(u.select_atoms(interface).indices, ref_contacts))/num_ref_contacts)
    return fcc

with open('mmlist.txt','r') as f:
    files = f.readlines()
    
for f in files:
    fcc = cyclotide_native_contacts(f.strip()+'/em1.pdb', f.strip()+'/md_corrected.xtc',f.strip()+'/em1.pdb')
    np.save(f.strip()+'/fcc_atom_cyclotide.npy', np.array(fcc))

# ## Plot fcc
'''
import numpy as np
import matplotlib.pyplot as plt

with open('mmlist.txt', 'r') as f:
    files = f.readlines()

plt.rcParams['font.size'] = 16
fig, axes = plt.subplots(4,5, figsize=(24,16), sharex=True, sharey=True)

for i, ax in enumerate(axes.flatten()):
    fcc = np.load(files[i].strip()+'/fcc_atom_cyclotide.npy')
    ax.plot(fcc)
    ax.text(100,0.1,str(i+1))
    ax.text(900,0.1,str(fcc[-500:].mean())[:4])
    ax.set_ylim([0, 1])
plt.tight_layout()
fig.text(0.45, 1, '10ns MD of rosetta design')
fig.text(0.5,0, "#Frames")
fig.text(-0.01, 0.5, "FCC (Ligand)", rotation='vertical')
plt.savefig('fcc_atom_cyclotide.jpg', dpi=300, bbox_inches='tight')
'''
