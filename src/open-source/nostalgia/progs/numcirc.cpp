#include <iostream.h>
#include "b:\prog\ccalc.cpp"

const unsigned MAX_NUMBER = 65534;
const unsigned MAX_CIRC_NUM = 40;
const unsigned MAX_NUM_PER_CIRC = 500;

void initall(char * num_check, unsigned * circles)
{
	for(unsigned a=0;a<(MAX_NUMBER/8+1);a++)
		num_check[a] = 0;
	for(a=0;a<MAX_CIRC_NUM;a++)
		for(unsigned b=0;b<MAX_NUM_PER_CIRC;b++)
			circles[a*MAX_NUM_PER_CIRC+b] = 0;
}

unsigned getcircles(unsigned base_num, unsigned & circ_num, unsigned * circles)
{
	char num_check[MAX_NUMBER/8+1];
	unsigned a,b,c;
	if ((base_num%2==0)||(base_num<4)||(base_num>MAX_NUMBER)) return 0;
	circ_num = 0;
	initall(num_check,circles);
	do {
		for(a=0;bread(num_check,a)==1;a++) ;
		if (a>=base_num) break;
		b = a;c = 0;
		do {
			circles[circ_num*MAX_NUM_PER_CIRC+c] = a;
			bwrite(num_check,a,1);
			a = (a*2)%base_num; c++;
		} while (a != b);
		circ_num++;
	} while (circ_num); // This loop will stop only with the break statement;
	return 1;
}

unsigned getnumcircles(unsigned base_num, unsigned * numin)
{
	unsigned char num_check[MAX_NUMBER/8+1];
	unsigned a,b,c,circ_num;
	if ((base_num%2==0)||(base_num<4)||(base_num>MAX_NUMBER)) return 0;
	circ_num = 0;
	for(a=0;a<base_num/8+1;a++) num_check[a] = 0;
	do {
		for(a=0;bread(num_check,a)==1;a++) ;
		if (a>=base_num) break;
		b = a;c = 0;
		do {
			a = ((unsigned long)a*2)%base_num; // advances to the next number
			bwrite(num_check,a,1);
			c++;
		} while (a != b);
		*numin = c; // records the number of numbers in the current circle
		numin++;
		circ_num++;
	} while (circ_num); // This loop will stop only with the break statement
	return circ_num; // returns the number of circles
}

int comp_func(const void * pi1, const void * pi2)
{
	unsigned i1 = *(unsigned*)pi1, i2 = *(unsigned*)pi2;
	return ((i1>i2)-(i2>i1));
}

int main()
{
	unsigned num1, num2, circles[MAX_NUMBER/8+1];
	unsigned circ_num,a,b;
	char ch;
	do {
		num1 = num2 = 0;
		cout << "\nPlease enter the first number - ";
		do cin >> num1; while ((num1<4)||(num1%2==0)||(num1>MAX_NUMBER));
		cout << "\nPlease enter the second number - ";
		do cin >> num2; while ((num2<4)||(num2%2==0)||(num2>MAX_NUMBER));
		// first number
		circ_num = getnumcircles(num1,circles);
		qsort(circles, circ_num, 2, &comp_func);
		cout << "\nFirst Number, " << num1 << ":\nCircles' lengthes - ";
		for (a=0;a<circ_num;a++)
			cout << circles[a] << ", ";
		cout << "\nNumber of circles - " << circ_num << '\n';
		// second number
		circ_num = getnumcircles(num2,circles);
		qsort(circles, circ_num, 2, &comp_func);
		cout << "\nSecond Number, " << num2 << ":\nCircles' lengthes - ";
		for (a=0;a<circ_num;a++)
			cout << circles[a] << ", ";
		cout << "\nNumber of circles - " << circ_num << '\n';
		// multiplication
		circ_num = getnumcircles(num1*num2,circles);
		qsort(circles, circ_num, 2, &comp_func);
		cout << "\nThe Multiplication, " << num1*num2 << ":\nCircles' lengthes - ";
		for (a=0;a<circ_num;a++)
			cout << circles[a] << ", ";
		cout << "\nNumber of circles - " << circ_num << '\n';
		// To continue or not to continue - that is the question
		cout << "Press \'x\' to exit. Other key to continue.";
		_AX = 1;asm int 0x16;
		ch = _AX;
	} while (ch != 'x');
	return 0;
}

/*int main()
{
	unsigned base_num, circles[MAX_CIRC_NUM][MAX_NUM_PER_CIRC];
	unsigned circ_num,a,b;
	char ch;
	do {
		base_num = 0;
		cout << "\nPlease enter the number - ";
		do cin >> base_num; while ((base_num<4)||(base_num%2==0)||(base_num>MAX_NUMBER));
		getcircles(base_num,circ_num,&circles[0][0]);
		for (a=0;a<circ_num;a++)
		{
			b=0;
			if (circles[a][0] == 0) cout << "0 [END]\n";
			else
			{
				while(circles[a][b]!=0)
				{
					cout << circles[a][b] << " - ";
					b++;
				}
				cout << "\b\b[END]\nNumber of numbers - " << b << '\n';
			}
		}
		cout << "\nNumber of circles - " << circ_num << '\n';
		// To continue or not to continue - that is the question
		cout << "Press \'x\' to exit. Other key to continue.";
		_AX = 1;asm int 0x16;
		ch = _AX;
	} while (ch != 'x');
	return 0;
} */