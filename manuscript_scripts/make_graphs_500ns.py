#Converts a flattened pairwise 2d contact map from pyemma to a pytorch graph with gaussian distances as edge features

import numpy as np
import torch
from torch_geometric.data import Data
from torch_geometric.data import DataLoader

def convert_flat_pyG(arr,nodes=280,cut=0.8):
    '''
    Converts a flattened pairwise 2d contact map from pyemma to a pytorch graph
    Default cutoff for neighbours = 0.8
    Default levels for gaussian distances = 6
    '''
    mat_2d = np.zeros((nodes,nodes))
    k = 0
    for i in range(nodes):
        for j in range(i + 3, nodes):
            mat_2d[i][j] = arr[k]
            k += 1
    mat_2d = mat_2d.T + mat_2d
    mat_2d[mat_2d >= cut] = cut

    #Edges
    adjacency_matrix = torch.tensor(mat_2d < cut, dtype=torch.float32)
    coo = adjacency_matrix.to_sparse_coo()
    edge_indices = coo.indices()

    mat_2d = torch.tensor(mat_2d, dtype=torch.float, device='cpu')
    flattened_dist_matrix = mat_2d[edge_indices[0], edge_indices[1]]

    #Edge features
    gaussian_distances = torch.zeros(edge_indices.size(1), 6, device='cpu')
    sigma = (cut - 0) / 6
    mu = torch.linspace(cut, 0, 6, device='cpu')
    for t in range(6):
        gaussian_distances[:, t] = torch.exp(-((flattened_dist_matrix - mu[t]) ** 2) / (2 * sigma ** 2))
	
    node_emb = torch.arange(1,nodes+1)
    node_emb = node_emb.float()

    return Data(x=node_emb, edge_index=edge_indices, edge_attr=gaussian_distances)

data = np.load('cadist_500ns_2.npy',allow_pickle=True)

out_list = []
for traj in data:
    in_list = []
    for frame in traj:
        in_list.append(convert_flat_pyG(frame))
    out_list.append(in_list)

torch.save(out_list,'2graphs_500ns_2.pt')
