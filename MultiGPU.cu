#include <iostream>
#include <cuda_runtime.h>
#include <device_launch_parameters.h>

__global__ void add3(int *a, int *b, int *c)
{
	int tid = threadIdx.x;
	c[tid] = a[tid] + b[tid];
	printf("gridDim : %d\n", gridDim.x);
}
int main3(void)
{
	int a[10], b[10], c[10];
	int *dev_a, *dev_b, *dev_c;
	cudaMalloc((void * *)&dev_a, 10 * sizeof(int));
	cudaMalloc((void * *)&dev_b, 10 * sizeof(int));
	cudaMalloc((void * *)&dev_c, 10 * sizeof(int));
	for (int i = 0; i < 10; i++)
	{
		a[i] = i;
		b[i] = i + 2;
	}
	
	//
	cudaMemcpy(dev_a/*目標指針*/, a/*源指針*/, 10 * sizeof(int), cudaMemcpyHostToDevice);
	cudaMemcpy(dev_b/*目標指針*/, b/*源指針*/, 10 * sizeof(int), cudaMemcpyHostToDevice);
	add3 << < 1/*線程塊*/, 10/*線程*/ >> > (dev_a, dev_b, dev_c);
	cudaMemcpy(c/*目標指針*/, dev_c/*源指針*/, 10 * sizeof(int), cudaMemcpyDeviceToHost);

	for (int i = 0; i < 10; i++)
	{
		//printf("%d + %d = %d\n", a[i], b[i], c[i]);
	}
	cudaFree(dev_a);
	cudaFree(dev_b);
	cudaFree(dev_c);
	getchar();
	return 0;

}