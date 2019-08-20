#include <iostream>
#include <cuda_runtime.h>

__device__ int add_d(int a, int b)
{
	printf("Hellow world_3\n");
	return a * b;
}

__global__ void add2(int a, int b, int *c)
{
	printf("Hellow world_2\n");
	*c = add_d(a, b);
	printf("Hellow world_4\n");
}
int main2(void)
{
	int c;
	int *ptr;
	cudaMalloc((void * *)&ptr, sizeof(int));
	printf("Hellow world_1\n");
	//�iGPU�}�l�p��F
	add2 << < 1, 1 >> > (12, 12, ptr);

	//�Ȯ����CPU�u�{
	cudaDeviceSynchronize();

	//�B�槹GPU�A�^��CPU�~���
	printf("Hellow world_5\n");
	cudaMemcpy(&c, ptr, sizeof(int), cudaMemcpyDeviceToHost);
	printf("Hellow world_6\n");
	printf("12*12 = %d\n", c);
	cudaFree(ptr);
	getchar();
	return 0;
}