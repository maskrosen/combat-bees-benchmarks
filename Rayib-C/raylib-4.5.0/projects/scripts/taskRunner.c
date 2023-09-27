#include "taskRunner.h"
#define NOGDI             // All GDI defines and routines
#define NOUSER            // All USER defines and routines
#include <windows.h>
#undef near
#undef far
#undef PlaySound

static HANDLE modifyTaskQueueMutex;

void InitTaskRunner()
{
	modifyTaskQueueMutex = CreateMutex(NULL, FALSE, NULL);
}

void SetThreadDone(int* threadDoneCounter)
{
	InterlockedIncrement(threadDoneCounter);
}

int GetTaskThreadSafe(Task* taskQueue, int* queuedTasks, Task* task)
{
	DWORD dwWaitResult;
	
	dwWaitResult = WaitForSingleObject(
		modifyTaskQueueMutex,    // handle to mutex
		INFINITE);  // no time-out interval

	int result = 0;

	if (dwWaitResult == WAIT_OBJECT_0)
	{
		if (*queuedTasks > 0)
		{
			result = 1;
			*task = taskQueue[0];
			(*queuedTasks)--;
			for (int i = 0; i < *queuedTasks; i++)
			{
				taskQueue[i] = taskQueue[i + 1];
			}
		}
	}
	else
	{
		//Error, just crash
		Task temp = { 0 };
		temp.function(temp.data); //This should crash
	}
	ReleaseMutex(modifyTaskQueueMutex);
	return result;
}

void RunTasks(TaskQueue queue)
{
	while (1)
	{
		Task* taskQueue = queue.queue;
		int* queuedTasks = queue.queuedCount;
		Task taskToRun = { 0 };
		if (GetTaskThreadSafe(taskQueue, queuedTasks, &taskToRun))
		{
			if (!taskToRun.function(taskToRun.data))
			{
				while (!AddTaskToQueue(taskToRun, taskQueue, queuedTasks))
				{
					//Queue is full try again after waiting for a while
					Sleep(10);
				}
			}
		}
		else
		{
			//Sleep for a while since there are no task to run right now
			Sleep(1);
		}
	}
}

int AddTaskToQueue(Task taskToAdd, Task* taskQueue, int* queuedTasks)
{
	DWORD dwWaitResult;

	dwWaitResult = WaitForSingleObject(
		modifyTaskQueueMutex,    // handle to mutex
		INFINITE);  // no time-out interval

	int result = 0;

	if (dwWaitResult == WAIT_OBJECT_0)
	{
		if (*queuedTasks < MAX_TASK_COUNT)
		{
			result = 1;
			taskQueue[*queuedTasks] = taskToAdd;
			(*queuedTasks)++;
		}
	}
	else
	{
		//Error, just crash
		Task temp = { 0 };
		temp.function(temp.data); //This should crash
	}
	ReleaseMutex(modifyTaskQueueMutex);
	return result;
}
