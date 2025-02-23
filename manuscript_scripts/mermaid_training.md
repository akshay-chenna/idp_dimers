---
config:
  layout: fixed
---
flowchart TB
 subgraph s1["STEP 1: Input Data"]
    direction TB
        A["3D Coordinates<br> (from XTC)"]
  end
 subgraph s2["STEP 2: Graph Construction"]
    direction TB
        B["Compute distance matrix<br>mat_2d ∈ ℝ^(N×N)<br>(from flattened arr)"]
        eq1["Adjacency:<br>adj(i, j) = 1 if dist(i, j) <br> &lt; 0.8 nm, else 0"]
        eq2["Gaussian edge features:<br>gᵢⱼ(k) = exp(-((dᵢⱼ − µₖ)²)/(2σ²))"]
        C["Construct PyG Data:<br>- edge_index<br>- edge_attr (6D Gaussian)<br>- x (node_emb)"]
  end
 subgraph s3["STEP 3: Graph Transformer"]
    direction TB
        D["TransformerConv<br>(edge_dim=6,<br> two-head attention and <br> single channel)"]
        R["Reshape output<br>→ (batch_size, 280)"]
  end
 subgraph s4["STEP 4: MLP + Softmax"]
    direction TB
        E["MLP:<br>Linear(280→64)+ReLU,<br>Linear(64→16)+ReLU,<br>Linear(16→6)"]
        F["Softmax<br>(Output)"]
  end
 subgraph s5["STEP 5: Soft State Assignment"]
    direction TB
        G["Assign states/classes<br>(based on softmax)"]
  end
 subgraph s6["STEP 6: Training with VAMP Score"]
    direction TB
        H["Compute VAMP <br>Score (τ=10 ns) and<br>Backprop through<br>entire architecture"]
  end
    A --> B
    B --> eq1 & eq2
    eq1 --> C
    eq2 --> C
    D --> R
    R --> s4
    E --> F
    s2 --> s3
    s4 --> s5
    G --> H
