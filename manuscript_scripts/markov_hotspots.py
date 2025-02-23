# # Markov Clustering

import sys
import numpy as np 
import pandas as pd 
from biopandas.pdb import PandasPdb 
from scipy.spatial import distance
import freesasa
import markov_clustering as mc
import networkx as nx
from scipy import sparse
import matplotlib.pyplot as plt
import seaborn as sb

get_ipython().system('mkdir outputs')
pdb_path = sys.argv[1]
pandas_pdb = PandasPdb().read_pdb(pdb_path)

if pandas_pdb.df['ATOM'].chain_id.unique()=='':
    pandas_pdb.df['ATOM'].chain_id='A'
    pandas_pdb.to_pdb(path=pdb_path[pdb_path.rfind('/')+1:])
else:
    get_ipython().system('cp {pdb_path} .')

new_path = pdb_path[pdb_path.rfind('/')+1:]
pandas_pdb = PandasPdb().read_pdb(new_path)

for chains in pandas_pdb.df['ATOM'].chain_id.unique():
    
    #1. Determine Structural alphabets

    coordinates = np.zeros((pandas_pdb.df['ATOM'][pandas_pdb.df['ATOM']['chain_id'] == chains].residue_number.max(),3))
    coordinates[:,0] = pandas_pdb.df['ATOM'][(pandas_pdb.df['ATOM']['chain_id'] == chains) & (pandas_pdb.df['ATOM']['atom_name'] == 'CA')].x_coord.to_numpy()
    coordinates[:,1] = pandas_pdb.df['ATOM'][(pandas_pdb.df['ATOM']['chain_id'] == chains) & (pandas_pdb.df['ATOM']['atom_name'] == 'CA')].y_coord.to_numpy()
    coordinates[:,2] = pandas_pdb.df['ATOM'][(pandas_pdb.df['ATOM']['chain_id'] == chains) & (pandas_pdb.df['ATOM']['atom_name'] == 'CA')].z_coord.to_numpy()

    sa_vectors = np.zeros((pandas_pdb.df['ATOM'][pandas_pdb.df['ATOM']['chain_id'] == chains].residue_number.max()-3,4))
    sa = np.zeros(len(sa_vectors)) 

    for residues in range(pandas_pdb.df['ATOM'][pandas_pdb.df['ATOM']['chain_id'] == chains].residue_number.max()-3):
        sa_vectors[residues,0] = np.linalg.norm(coordinates[residues+2,:]-coordinates[residues,:])
        sa_vectors[residues,1] = np.linalg.norm(coordinates[residues+3,:]-coordinates[residues,:])
        sa_vectors[residues,2] = np.linalg.norm(coordinates[residues+3,:]-coordinates[residues+1,:])

        v = np.zeros((3,3))
        v[0,:] = coordinates[residues+1,:]-coordinates[residues,:]
        v[1,:] = coordinates[residues+2,:]-coordinates[residues+1,:]
        v[2,:] = coordinates[residues+3,:]-coordinates[residues+2,:]
        sa_vectors[residues,3] = np.linalg.det(v)/(np.linalg.norm(v[:,0])*np.linalg.norm(v[:,1]))

        sa_definitions = np.loadtxt('sa.in',delimiter=',')

        sa_value = np.zeros(len(sa_definitions))
        for i in np.arange(len(sa_definitions)):
            sa_value[i] = distance.cosine(sa_vectors[residues,:],sa_definitions[i,:])   
        sa[residues] = np.argmin(sa_value)+1    
        
    np.savetxt("outputs/"+new_path[new_path.rfind('/')+1:]+'.'+chains+".conformer_SA.txt", sa, fmt='%1d')
    
    # Structure alphabets 23-27 are beta, remainder have a propensity for beta
    sa[sa<=10] = 0
    sa[(sa>=15) & (sa<=19)] = 0
    sa[sa>0] = 1
    
    #1.1 Save structural alphabets for sequence identity analysis
    sa_save = sa.copy()
    sa_save = sa_save - 10
    sa_save[sa_save < 0 ] = 0

    # 2. Determine surface exposure of structural alphabets
    
    structure = freesasa.Structure(new_path)
    rsa = np.zeros(pandas_pdb.df['ATOM'][pandas_pdb.df['ATOM']['chain_id'] == chains].residue_number.max())
    sasa = np.zeros(pandas_pdb.df['ATOM'][pandas_pdb.df['ATOM']['chain_id'] == chains].residue_number.max())
    for residues in range(pandas_pdb.df['ATOM'][pandas_pdb.df['ATOM']['chain_id'] == chains].residue_number.max()):
        rsa[residues] = freesasa.calc(structure).residueAreas()[chains][str(residues+1)].relativeTotal
        sasa[residues] = freesasa.calc(structure).residueAreas()[chains][str(residues+1)].total
    exposed_residues = rsa.copy()
    exposed_residues[exposed_residues<0.5] = 0
    exposed_residues[exposed_residues!=0] = 1
    
    np.savetxt("outputs/"+new_path[new_path.rfind('/')+1:]+'.'+chains+".rsa.txt", rsa, fmt='%.2f')
    np.savetxt("outputs/"+new_path[new_path.rfind('/')+1:]+'.'+chains+".sasa.txt", sasa, fmt='%.2f')    
   
    exposed = np.zeros(len(exposed_residues)-3)
    for sas in range(pandas_pdb.df['ATOM'][pandas_pdb.df['ATOM']['chain_id'] == chains].residue_number.max()-3):
        exposed[sas] = exposed_residues[sas:sas+4].sum()
    exposed[exposed<4] = 0
    exposed[exposed!=0] = 1

    #3. Determine surface surface SAs that are beta-formed or beta-propensity
    
    beta_exposed = np.logical_and(sa,exposed)
    np.savetxt("outputs/"+new_path[new_path.rfind('/')+1:]+'.'+chains+".sequence_SA.txt", sa_save*exposed, fmt='%1d')
    
    #5. Run voronota to find the CSAs
    
    get_ipython().system("bash voronota.sh {pdb_path[pdb_path.rfind('/')+1:]}")
    
    #6. Load the contact surface area matrix
 
    atom_areas = np.genfromtxt("outputs/"+pdb_path[pdb_path.rfind('/')+1:]+'.atom_contact_areas.txt')

    for i in range(len(atom_areas[:,1])):
        if np.isnan(atom_areas[i,1]):
            atom_areas[i,1] = atom_areas[i,0]

    residue_contact_areas = np.zeros((len(atom_areas),3))

    residues = np.unique(atom_areas[:,0]).astype(int)
    count = 0
    for i in residues:
        sub_matrix = atom_areas[atom_areas[:,0] == i,:]
        contact_residues = np.unique(sub_matrix[:,1])
        for c in contact_residues:
            residue_contact_areas[count,0] = i
            residue_contact_areas[count,1] = c        
            residue_contact_areas[count,2] = sub_matrix[np.where(sub_matrix[:,1] == c),2].sum()
            count += 1

    residue_contact_areas = np.delete(residue_contact_areas,np.arange(count,len(residue_contact_areas)),0)

    sa_contact_map = np.zeros([int(residue_contact_areas[:,0].max())-3,int(residue_contact_areas[:,0].max())-3])
    for i in residues[:-3]:
        sub_matrix = residue_contact_areas[(residue_contact_areas[:,0] == i) | (residue_contact_areas[:,0] == i+1) | (residue_contact_areas[:,0] == i+2) | (residue_contact_areas[:,0] == i+3),:]
        contact_residues = np.unique(sub_matrix[:,1]).astype(int)
        for c in contact_residues:
            if c == 1:
                sa_contact_map[i-1,c-1] = sa_contact_map[i-1,c-1] + sub_matrix[sub_matrix[:,1] == c,2].sum()
            elif c == 2:
                sa_contact_map[i-1,c-1] = sa_contact_map[i-1,c-1] + sub_matrix[sub_matrix[:,1] == c,2].sum()
                sa_contact_map[i-1,c-2] = sa_contact_map[i-1,c-2] + sub_matrix[sub_matrix[:,1] == c,2].sum()
            elif c == 3:
                sa_contact_map[i-1,c-1] = sa_contact_map[i-1,c-1] + sub_matrix[sub_matrix[:,1] == c,2].sum()
                sa_contact_map[i-1,c-2] = sa_contact_map[i-1,c-2] + sub_matrix[sub_matrix[:,1] == c,2].sum()
                sa_contact_map[i-1,c-3] = sa_contact_map[i-1,c-3] + sub_matrix[sub_matrix[:,1] == c,2].sum()
            elif c == max(residues)-2:
                sa_contact_map[i-1,c-2] = sa_contact_map[i-1,c-2] + sub_matrix[sub_matrix[:,1] == c,2].sum()
                sa_contact_map[i-1,c-3] = sa_contact_map[i-1,c-3] + sub_matrix[sub_matrix[:,1] == c,2].sum()
                sa_contact_map[i-1,c-4] = sa_contact_map[i-1,c-4] + sub_matrix[sub_matrix[:,1] == c,2].sum()
            elif c == max(residues)-1:
                sa_contact_map[i-1,c-3] = sa_contact_map[i-1,c-3] + sub_matrix[sub_matrix[:,1] == c,2].sum()
                sa_contact_map[i-1,c-4] = sa_contact_map[i-1,c-4] + sub_matrix[sub_matrix[:,1] == c,2].sum()
            elif c == max(residues):
                sa_contact_map[i-1,c-4] = sa_contact_map[i-1,c-4] + sub_matrix[sub_matrix[:,1] == c,2].sum()
            else:
                sa_contact_map[i-1,c-1] = sa_contact_map[i-1,c-1] + sub_matrix[sub_matrix[:,1] == c,2].sum()
                sa_contact_map[i-1,c-2] = sa_contact_map[i-1,c-2] + sub_matrix[sub_matrix[:,1] == c,2].sum()
                sa_contact_map[i-1,c-3] = sa_contact_map[i-1,c-3] + sub_matrix[sub_matrix[:,1] == c,2].sum()
                sa_contact_map[i-1,c-4] = sa_contact_map[i-1,c-4] + sub_matrix[sub_matrix[:,1] == c,2].sum()

    sa_contact_map = np.tril(sa_contact_map.T,1) + sa_contact_map
    contact_map = sa_contact_map[beta_exposed, :][:,beta_exposed]
    
    plt.figure(figsize=(15,10)).patch.set_facecolor('white')
    sb.heatmap(contact_map, linewidths=1, cmap='RdPu')
    
    plt.savefig("outputs/"+new_path[new_path.rfind('/')+1:]+'.'+chains+'.map.jpg', dpi=600, format='jpg')
    
    
    #7. Cluster using CSAs (contact surface areas)
    sp_matrix = sparse.csr_matrix(contact_map)
    
    inflation_range = np.arange(1.05,3.05,0.05)
    Q = np.empty(inflation_range.shape[0])
    i = 0
    for inflation in inflation_range:
        result = mc.run_mcl(sp_matrix, inflation=inflation)
        clusters = mc.get_clusters(result)
        Q[i] = mc.modularity(matrix=result, clusters=clusters)
        i += 1

    inflation = inflation_range[Q.argmax()]
    result = mc.run_mcl(sp_matrix, inflation=inflation)
    clusters = mc.get_clusters(result)
    
    # Save cluster member information
    cluster_sa = []
    with open("outputs/"+new_path[new_path.rfind('/')+1:]+'.'+chains+'.clusters', 'w') as f:
        for i in range(len(clusters)):
            cluster_sa = np.where(beta_exposed == True)[0][np.array(clusters[i])]
            res_sa = np.empty((len(cluster_sa),4))
            k = 0
            for j in cluster_sa:
                res_sa[k,:] = range(j,j+4)
                k += 1
            to_print = (np.unique(res_sa.flatten())+1).astype(int)
            f.write("%s\n" % to_print)
            
    #8. Perform cluster analysis and assign scores
    SA = np.genfromtxt("outputs/"+new_path[new_path.rfind('/')+1:]+'.'+chains+".conformer_SA.txt")
    sasa = np.genfromtxt("outputs/"+new_path[new_path.rfind('/')+1:]+'.'+chains+".sasa.txt")

    # Find number of clusters            
    count = len(clusters)
    
    # Save the structural alphabets and sasa for each cluster /cluster element
    with open("outputs/"+new_path[new_path.rfind('/')+1:]+'.'+chains+'.clusters') as fp:
        text = fp.read().replace("\n","").replace("]","]\n").split("\n")
        for line in range(count):
            cluster = np.fromstring(text[line].strip().strip("[]"), dtype=int, sep=' ')
            with open("outputs/"+new_path[new_path.rfind('/')+1:]+'.'+chains+".cluster_sasa.txt",'a') as st:
                np.savetxt(st,np.sum(sasa[cluster], keepdims=True), fmt="%.2f")
            with open("outputs/"+new_path[new_path.rfind('/')+1:]+'.'+chains+".cluster_SA.txt",'a') as cs:
                cs.write("%s\n" % SA[cluster[:-3]].astype(int))

    # Count the number of structural alphabets
    count_SA = np.empty((count,3))
    with open("outputs/"+new_path[new_path.rfind('/')+1:]+'.'+chains+".cluster_SA.txt") as sc:
        i = 0
        text = sc.read().replace("\n","").replace("]","]\n").split("\n")
        for line in range(count):
            cluster_SA = np.fromstring(text[line].strip().strip("[]"), dtype=int, sep=' ')
            count_SA[i,0] = len(cluster_SA)
            count_SA[i,1] = len(cluster_SA[cluster_SA >= 23])
            count_SA[i,2] = len(cluster_SA[cluster_SA < 23])
            i += 1
        np.savetxt("outputs/"+new_path[new_path.rfind('/')+1:]+'.'+chains+".count_SA.txt", count_SA, delimiter="\t", header="Total\tBeta\tBeta-propensity", fmt='%.d')

    # Find and save the cluster scores
    beta_probability = np.genfromtxt("transition_probability.in", skip_header=1)
    cluster_score = np.empty((count,1))
    with open("outputs/"+new_path[new_path.rfind('/')+1:]+'.'+chains+".cluster_SA.txt") as sc:
        i = 0
        text = sc.read().replace("\n","").replace("]","]\n").split("\n")
        for line in range(count):
            cluster_SA = np.fromstring(text[line].strip().strip("[]"), dtype=int, sep=' ')
            sasa_SA = np.empty(len(cluster_SA))
            for j in range(0,len(cluster_SA)):
                sasa_SA[j] = sasa[cluster_SA[j]:cluster_SA[j]+3].sum()
            beta_cluster_propensity = beta_probability[cluster_SA,1]
            cluster_score[i] = (sasa_SA*beta_cluster_propensity.T).sum()
            i += 1
    score_matrix = np.vstack((np.arange(1,count+1),cluster_score[:,0]))
    np.savetxt("outputs/"+new_path[new_path.rfind('/')+1:]+'.'+chains+".cluster_score.txt", score_matrix.T, header="\tScore", fmt='%d \t %.3f')     
