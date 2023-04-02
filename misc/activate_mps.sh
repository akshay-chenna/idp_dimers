export CUDA_MPS_PIPE_DIRECTORY=$PWD
mkdir -p $CUDA_MPS_PIPE_DIRECTORY
nvidia-cuda-mps-control -d
