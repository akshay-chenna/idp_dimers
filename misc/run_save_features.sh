source ~/apps/scripts/source_conda.sh
conda activate py310

cd $PBS_O_WORKDIR
python save_features.py
