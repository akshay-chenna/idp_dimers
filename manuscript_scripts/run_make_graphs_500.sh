cd $PBS_O_WORKDIR
source ~/apps/scripts/source_conda.sh
conda activate py310

python make_graphs_500ns.py 
