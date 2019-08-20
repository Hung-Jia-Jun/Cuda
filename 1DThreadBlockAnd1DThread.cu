#include <iostream>
#include <cuda_runtime.h>
#include <device_launch_parameters.h>
#include "time.h"
#define N 1024

__global__ void add(int *a, int *b, int *c)
{
	int tid = blockIdx.x * blockDim.x + threadIdx.x;
	printf("tid = %d \n", tid);
	c[tid] = a[tid] + b[tid];
	//printf("gridDim.x = %d blockDim.x = %d \n ", gridDim.x , blockDim.x);
	tid += gridDim.x * blockDim.x;
}
int main(void)
{
	int *a, *b, *c;
	int *dev_a, *dev_b, *dev_c;
	clock_t start, end;
	double duration;
	a = (int *)malloc(N * sizeof(int));
	b = (int *)malloc(N * sizeof(int));
	c = (int *)malloc(N * sizeof(int));

	cudaMalloc((void * *)&dev_a, N * sizeof(int));
	cudaMalloc((void * *)&dev_b, N * sizeof(int));
	cudaMalloc((void * *)&dev_c, N * sizeof(int));

	for (int i = 0; i < N; i++)
	{
		a[i] = i;
		b[i] = 2 * i;
	}

	//dev_a <== a ½Æ»s¤è¦V
	cudaMemcpy(dev_a, a, N * sizeof(int), cudaMemcpyHostToDevice);
	cudaMemcpy(dev_b, b, N * sizeof(int), cudaMemcpyHostToDevice);
	start = clock();
	add << <10/*block*/, 10/*thread*/ >> > (dev_a, dev_b, dev_c);
	cudaMemcpy(c, dev_c, N * sizeof(int), cudaMemcpyDeviceToHost);

	for (int i = 0; i < N; i++)
	{
		if ((a[i] + b[i] == c[i]))
		{
			printf("%d + %d = %d\n", a[i], b[i], c[i]);
		}
	}
	cudaDeviceSynchronize();
	end = clock();

	duration = (double)(end - start) / CLOCKS_PER_SEC;
	//printf(" %f ¬í \n", duration);
	cudaFree(dev_a);
	cudaFree(dev_b);
	cudaFree(dev_c);
	free(a);
	free(b);
	free(c);

	getchar();
	return 0;


}