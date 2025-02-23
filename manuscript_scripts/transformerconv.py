import numpy as np    
import matplotlib.pyplot as plt
import seaborn as sns

import warnings
import pyemma
import deeptime as dt
from deeptime.decomposition.deep import VAMPNet
from deeptime.util.exceptions import TrajectoryTooShortError
print(f"PyEMMA {pyemma.__version__}, deeptime {dt.__version__}")

import torch
import torch.nn as nn
from torch.utils.data import DataLoader
from torch_geometric.data import Data
from torch_geometric.data import DataLoader as PyGDataLoader

import torch.nn.functional as F
from torch.nn import Linear, ReLU, Sequential
from torch_geometric.nn import TransformerConv, global_mean_pool

import argparse
import time
from tqdm.notebook import tqdm

if torch.cuda.is_available():
        device = torch.device("cuda")
        torch.backends.cudnn.benchmark = True
else:
    device = torch.device("cpu")
torch.set_num_threads(1)

print(f"Using device {device}")

parser = argparse.ArgumentParser(description="Run VAMPNet with GNNs")
parser.add_argument('-n','--nodes', type=int)
parser.add_argument('-t','--tau', type=int)
parser.add_argument('-r','--run', type=int)
parser.add_argument('-b','--batch', type=int)
parser.add_argument('-c','--channels', type=int)
parser.add_argument('-d','--heads', type=int)
parser.add_argument('-e','--epochs', type=int)

args = parser.parse_args()

x1 = torch.load('graphs_2/2graphs_500ns.pt')
x2 = torch.load('graphs_2/2graphs_100ns.pt')
x3 = torch.load('graphs_2/2graphs_50ns.pt')
x4 = torch.load('graphs_2/2graphs_500ns_2.pt')
x = x1+x2+x3+x4
del x1,x2,x3,x4

individual_datasets = []
for i, traj in enumerate(x):
    try:
        individual_datasets.append(dt.util.data.TrajectoryDataset(args.tau,traj))
    except TrajectoryTooShortError as e:
        warnings.warn(f"Skipping trajectory {i}: {e}", UserWarning)
del x


dataset = dt.util.data.TrajectoriesDataset(individual_datasets)
n_val = int(len(dataset)*.1)
train_data, val_data = torch.utils.data.random_split(dataset, [len(dataset) - n_val, n_val])

loader_train = PyGDataLoader(train_data, batch_size=args.batch, shuffle=True, num_workers=1, prefetch_factor=1)
loader_val = PyGDataLoader(val_data, batch_size=len(val_data), shuffle=False, num_workers=1, prefetch_factor=1)

class GNN(torch.nn.Module):
    def __init__(self):
        super(GNN, self).__init__()
        # Graph convolution layers
        self.conv1 = TransformerConv(-1, args.channels, heads=args.heads, concat=False, dropouts=0, edge_dim=6)

        # MLP layers
        self.mlp = Sequential(
            Linear(280, 64),  # Input from global mean pooling, 280 node features
            ReLU(),
            Linear(64, 16),  # Input from global mean pooling, 280 node features
            ReLU(),
            Linear(16, args.nodes),  # Output layer with 16 nodes
	    torch.nn.Softmax()  # Assuming classification task, softmax at the output
        )

    def forward(self, batch):
        x, edge_index, edge_attr = batch.x, batch.edge_index, batch.edge_attr

        if x.dim() == 1:
            x = x.unsqueeze(1)

        # Message passing via graph attention with convolution
        x = self.conv1(x, edge_index, edge_attr)

        x = x.view(-1, 280)  # Reshape to (num_graphs, 280)

        # Process the reshaped features through an MLP
        x = self.mlp(x)
        return x

lobe = GNN().to(device=device)
vampnet = VAMPNet(lobe=lobe, learning_rate=1e-6, device=device)

attempts = 0
while attempts < 3:
    try:
        model = vampnet.fit(data_loader=loader_train, n_epochs=args.epochs, validation_loader=loader_val, progress=tqdm).fetch_model()
        break
    except:
        attempts += 1
        if attempts >= 3:
            break
        print('error! re-running')
        time.sleep(1)

name = 'transformerconv'+ '_t' + str(args.tau) +'_n'+ str(args.nodes)+ '_e' + str(args.epochs) + '_b' + str(args.batch) + '_c' + str(args.channels) + '_d' + str(args.heads) + '_r' + str(args.run)

plt.rcParams['font.size']='16'
plt.figure(figsize=(6,4))
plt.semilogx(*vampnet.train_scores.T, label='Training')
plt.semilogx(*vampnet.validation_scores.T, label='validation')
plt.xlabel('Step')
plt.ylabel('VAMP Score')
plt.title(name)
plt.legend();
plt.ylim([0,25])
plt.savefig(name +'.png', dpi=300, facecolor='white', bbox_inches='tight')

torch.save(model, name + '.pt')

np.save(name + '_training_scores.npy',*vampnet.train_scores.T)
np.save(name + '_validation_scores.npy',*vampnet.validation_scores.T)

## Compute state assignments
x1 = torch.load('graphs_2/2graphs_500ns.pt')
x2 = torch.load('graphs_2/2graphs_100ns.pt')
x3 = torch.load('graphs_2/2graphs_50ns.pt')
x4 = torch.load('graphs_2/2graphs_500ns_2.pt')
x = x1+x2+x3+x4
del x1,x2,x3,x4

net = model._lobe
net = net.to(device="cpu")

out = []
for traj in x:
    for frame in traj:
        out.append(net(frame.to(device=device)).cpu().detach().numpy())
del x

assignments = np.array([np.argmax(i) for i in out])
np.save(name+'_assignments.npy',assignments)

torch.cuda.empty_cache()
print("{} done".format(name))
