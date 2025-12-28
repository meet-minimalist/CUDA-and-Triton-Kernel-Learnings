##############################################
# Author: Meet Patel
# Create Time: 2025-12-21 15:56:03
# Modified by: Your name
# Modified time: 2025-12-28 05:00:22
# Description:
##############################################

../setup.sh
tensara init ./ -p vector-addition -l "CUDA C++"
tensara checker -g T4 -p vector-addition -s main.cu
tensara submit -g T4 -p vector-addition -s main.cu