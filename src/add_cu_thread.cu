#include <iostream>
#include <math.h>
#include <stdio.h>

// function to add the elements of two arrarys
__global__
void add(int n, float *x, float *y)
{

  int index = threadIdx.x;
  int stride = blockDim.x;
  printf("%d Index, %d blockDim, %d blockIdx\n", index, stride,blockIdx.x);
  for(int i = index; i < n ; i += stride)
    y[i] = x[i] + y[i];
}

int main(void)
{
  int N = 1<<20;

  float *x, *y;
  cudaMallocManaged(&x, N*sizeof(float));
  cudaMallocManaged(&y, N*sizeof(float));

  for(int i = 0; i < N; i++) {
    x[i] = 1.0f;
    y[i] = 2.0f;
  }

  add<<<1, 256>>>(N, x, y);

  cudaDeviceSynchronize();
  float maxError = 0.0f;
  for(int i = 0; i < N; i++)
    maxError = fmax(maxError, fabs(y[i] - 3.0f));
  std::cout << "Max error: " << maxError << std::endl;

  //free
  //delete [] x;
  //delete [] y;
  cudaFree(x);
  cudaFree(y);

  return 0;
}
