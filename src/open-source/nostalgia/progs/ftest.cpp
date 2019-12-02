#include <fstream.h>

int main()
{
	int i1, i2;
	float f1;
	unsigned	char c='[';
	ofstream fo;
	ifstream fi;
	fo.open("input.txt");
	while	(c!='n')
	{
		cout << "Please enter the number- ";
		cin >> i1;
		cout << "Please enter the oppsite- ";
		cin >> i2;
		cout << "Please enter the second root- ";
		cin >> f1;
		fo << i1 << '\n' << i2 << '\n' << f1 << '\n';
		cout << "Would you like to enter another record? ";
		cin >> c;
	}
	fo.close();
	fi.open("input.txt");
	cout<< "Reading from file...\n\n";
	while (c=='[')
	{
		fi >> i1 >> i2 >> f1;
		if (*(char*)(&i1)==255) break;
		cout << i1 << ": " << i2 << " , " << f1 << '\n';
	}
	_AX = 1;asm int 0x16;
	return 0;
}
