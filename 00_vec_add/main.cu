/**
 * @ Author: Meet Patel
 * @ Create Time: 2025-12-21 15:40:05
 * @ Modified by: Your name
 * @ Modified time: 2025-12-28 04:58:05
 * @ Description:
 */

#include <cuda_runtime.h>
#include <iostream>

__global__
void addVec(const float* d_input1, const float* d_input2, float* d_output, size_t n){
    int idx = blockIdx.x * blockDim.x + threadIdx.x;

    if(idx < n){
        d_output[idx] = d_input1[idx] + d_input2[idx];
    }
}


// Note: d_input1, d_input2, d_output are all device pointers to float32 arrays
extern "C" void solution(const float* d_input1, const float* d_input2, float* d_output, size_t n) {
    int threads_per_block = 256;
    dim3 threadsPerBlock(threads_per_block);
    dim3 blocksPerGrid((n + threads_per_block - 1) / threads_per_block);
    addVec<<<blocksPerGrid, threadsPerBlock>>>(d_input1, d_input2, d_output, n);
}

int main(){
    int total_nums = 100000;
    float* h_input1 = (float*)malloc(total_nums * sizeof(float));
    float* h_input2 = (float*)malloc(total_nums * sizeof(float));
    float* h_output = (float*)malloc(total_nums * sizeof(float));

    for(int i=0; i<total_nums; i++){
        h_input1[i] = i;
        h_input2[i] = -i;
        h_output[i] = 10;
    }

    float *d_input1, *d_input2, *d_output;
    cudaMalloc((void**) &d_input1, total_nums * sizeof(float));
    cudaMalloc((void**) &d_input2, total_nums * sizeof(float));
    cudaMalloc((void**) &d_output, total_nums * sizeof(float));

    cudaMemcpy(d_input1, h_input1, total_nums * sizeof(float), cudaMemcpyHostToDevice);
    cudaMemcpy(d_input2, h_input2, total_nums * sizeof(float), cudaMemcpyHostToDevice);

    solution(d_input1, d_input2, d_output, total_nums);

    cudaMemcpy(h_output, d_output, total_nums * sizeof(float), cudaMemcpyDeviceToHost);

    if(h_output[0] == 0){
        std::cout << "Correct answer." << std::endl;
    }else{
        std::cout << "Wrong answer." << std::endl;
    }

    cudaFree(d_input1);
    cudaFree(d_input2);
    cudaFree(d_output);

    free(h_input1);
    free(h_input2);
    free(h_output);
}