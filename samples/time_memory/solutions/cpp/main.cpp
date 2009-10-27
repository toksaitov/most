#include <iostream>

using namespace std;

void main()
{
	// Testing MemoryOut
	long long *bigArray = new long long[10000000];

	// Prevent compiler optimization
	for (int i = 0; i < 10000000; i++)
	{
		bigArray[i] = 100;
	}

	// Testing Timeout
	while (true)
	{
		cout << "Infinite loop..." << endl;
	}
}