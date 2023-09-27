#ifndef TASK_RUNNER_H
#define TASK_RUNNER_H

#define TASK_PARAMTER_MAX_SIZE 128
#define MAX_TASK_COUNT 128

typedef struct Task
{
	int (*function)(unsigned char* data);
	unsigned char data[TASK_PARAMTER_MAX_SIZE];
}Task;

typedef struct TaskData
{
	__int64 frameCounter;
}TaskData;

typedef struct TaskQueue
{
	Task* queue;
	int* queuedCount;
}TaskQueue;

void InitTaskRunner();
void RunTasks(Task* taskQueue, int* queuedTasks);
int AddTaskToQueue(Task taskToAdd, Task* taskQueue, int* queuedTasks);

#endif