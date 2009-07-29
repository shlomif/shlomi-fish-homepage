#include <logic.cpp>
#ifndef __IOSTREAM_H
#include <iostream.h>
#endif

int main()
{
	unsigned i1,i2,t1,t2,con, exit=1,array[3]={2,2,1};
	LTable_LFIAN l;
	l.clear(3,5,3,array);
	while(exit)
	{
		l.print_all();
		cout << "\nPlease enter the values-";
		cin >> t1 >> i1 >> t2 >> i2 >> con;
		l.setcon(t1,i1,t2,i2,con);
	}
	return 0;
}