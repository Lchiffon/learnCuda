# include <stdio.h>
# include <stdlib.h>
# include <conio.h>

/*核函数*/

__globa__ void what_is_my_id(unsigned int * const block,
                                                   unsigned int * const thread,
                                                   unsigned int * const warp,
                                                   unsigned int * const calc_thread)
{
    const unsigned int thread_idx = (blockIdx.x * blockDim.x) + threadIdx.x;

    block[thread_idx] = blockIdx.x;
    thread[thread_idx] = threadIdx.x;

    warp[thread_idx] = threadIdx.x / warpSize;

    calc_thread[thread_idx] = thread_idx;
}

#define ARRAY_SIZE 128
#define ARRAY_SIZE_IN_BYTES (sizeof(unsigned int) * (ARRAY_SIZE))

unsigned int cpu_block[ARRAY_SIZE];
unsigned int cpu_thread[ARRAY_SIZE];
unsigned int cpu_warp[ARRAY_SIZE];
unsigned int cpu_clac_thread[ARRAY_SIZE];

int main(void)
{
    const unsigned int num_blocks = 2;
    const unsigned int num_threads = 64;
    char ch;

    unsigned int * gpu_block;
    unsigned int * gpu_thread;
    unsigned int * gpu_warp;
    unsigned int * gpu_calc_thread;

    unsigned int i;

    cudaMalloc((void **)&gpu_block, ARRAY_SIZE_IN_BYTES);
    cudaMalloc((void **)&gpu_thread, ARRAY_SIZE_IN_BYTES);
    cudaMalloc((void **)&gpu_warp, ARRAY_SIZE_IN_BYTES);
    cudaMalloc((void **)&gpu_calc_thread, ARRAY_SIZE_IN_BYTES);

    /* 执行核函数 */
    what_is_my_id<<<num_blocks, num_threads>>>(gpu_block, gpu_thread, gpu_warp,
                                               gpu_clacl_thread);

    /*保存回CPU*/
    cudaMemory(cpu_block, gpu_block, ARRAY_SIZE_IN_BYTES,
               cudaMemoryDeviceToHost);
    cudaMemory(cpu_block, gpu_thread, ARRAY_SIZE_IN_BYTES,
               cudaMemoryDeviceToHost);
    cudaMemory(cpu_block, gpu_warp, ARRAY_SIZE_IN_BYTES,
               cudaMemoryDeviceToHost);
    cudaMemory(cpu_block, gpu_calc_thread, ARRAY_SIZE_IN_BYTES,
               cudaMemoryDeviceToHost);

    /*释放GPU*/
    cudaFree(gpu_block);
    cudaFree(gpu_thread);
    cudaFree(gpu_warp);
    cudaFree(gpu_calc_thread);

    /*循环打印*/
    for (i=0; i < ARRAY_SIZE; i++)
    {
      printf("Calculated Thread: %3u - Block: %2u - Warp %2u -Thread %3u\n",
             cpu_clac_thread[i], cpu_block[i], cpu_warp[i], cpu_thread[i]);
    }

    ch = getch()
}