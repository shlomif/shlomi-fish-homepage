#ifndef __CCALC_H
#define __CCALC_H

#ifndef __cplusplus
#error CCALC.H requires C++
#endif

#ifndef __MATH_H
#include <math.h>
#endif

#ifndef __STRSTREA_H
#include <strstream.h>
#endif

#ifndef __STDLIB_H
#include <stdlib.h>
#endif

#define num_ numerator
#define denom_ denominator

//finds the greatest common dividor of two numbers (Euclid's algorithm)
unsigned int gcd (unsigned int number1, unsigned int number2);
unsigned long lgcd (unsigned long number1, unsigned long number2);

unsigned long factorial(unsigned int Number);
unsigned long nPr(unsigned int Base, unsigned int secondary);
unsigned long nCr(unsigned int Base, unsigned int secondary);
double prob_appear(unsigned int, unsigned int, unsigned int );
char * roman(unsigned int number);
void mix(int * Place, unsigned int maxnum);
void getmultipliers(unsigned, unsigned *, int);
void lgetmultipliers(unsigned long, unsigned long *, int);
inline double blog(double x, double base) {return (log(x)/log(base));}
inline long double blogl(long double x, long double base) {return (logl(x)/logl(base));}
int IsPrime (unsigned long);
int IsPrimef (unsigned);
int IsPrimefl (unsigned long);

template <class N> void swap(N * x, N * y)
{
	N temp;
	temp = *x;
	*x = *y;
	*y = temp;
}

template <class N> long double average(N * place, unsigned itemsnumber)
{
	long double aver;
	for(unsigned a=0;a<itemsnumber;a++)
		aver += *(place+itemsnumber)
	return (aver/itemsnumber);
}

void bwrite(void * c, unsigned int place, unsigned int value)
{
	if (value) *((unsigned char*)c+place/8) |= 1 << place%8;
	else *((unsigned char*)c+place/8) &= 255 - (1 << place%8);
}

unsigned int bread(void *c, unsigned int place)
{
	return (*((unsigned char*)c+place/8) % (1 << place%8+1)) / (1 << place%8);
}

struct fract
{
	long numerator;
	unsigned int denominator;
	fract(long newnumer, unsigned int newdenom);
	fract(int whole, unsigned int newnumer, unsigned int newdenom);
	fract(void);
	void ins(long newnumer, unsigned int newdenom);
	void optimize();
	fract operator= (fract newfract);
	fract operator= (int);
	float ToFloat();
	double ToDouble();
};

ostream & operator<<(ostream & os, fract & f);

int operator==(fract f1, fract f2);
int operator==(fract f1, double other);
int operator==(double other, fract f1);
int operator<(fract f1, fract f2);
int operator>(fract f1, fract f2);
int operator!=(fract f1, fract f2);
int operator<=(fract f1, fract f2);
int operator>=(fract f1, fract f2);
fract operator*(fract f1, fract f2);
fract operator/(fract f1, fract f2);
fract operator+(fract f1, fract f2);
fract operator-(fract f1, fract f2);
void operator*=(fract original, fract newfract);
void operator/=(fract original, fract newfract);
void operator+=(fract original, fract newfract);
void operator-=(fract original, fract newfract);
int operator!(fract AFract) {return !AFract.num_;}
double abs(fract f1);
double sin(fract f1);
double cos(fract f1);
double tan(fract f1);
double atan(fract f1);
double asin(fract f1);
double acos(fract f1);
double atan2(fract f1, fract f2);
double cosh(fract f1);
double sinh(fract f1);
double tanh(fract f1);
double sqrt(fract f1);
fract pow(fract f1, unsigned int a);

fract::fract(long newnumer, unsigned int newdenom)
{
	num_ = newnumer;
	denom_ = newdenom;
	optimize();
}

fract::fract(int whole, unsigned int newnumer, unsigned int newdenom)
{
	num_ = whole * newdenom + newnumer - 2 * newnumer * (whole < 0);
	denom_ = newdenom;
	optimize();
}

fract::fract(void)
{
	num_ = 0; denom_ = 1;
}

void fract::ins(long newnumer, unsigned int newdenom)
{
	num_ = newnumer;
	denom_ = newdenom;
}

void fract::optimize()
{
	unsigned long t = lgcd(labs(num_), denom_);
	num_ /= t;
	denom_ /= (t % 32768l);
}

fract fract::operator= (fract newfract)
{
	num_ = newfract.num_; denom_ = newfract.denom_;
	return newfract;
}

fract fract::operator= (int intval)
{
	fract newfract(intval,1);
	num_  =newfract.num_; denom_ = newfract.denom_;
	return newfract;
}
float fract::ToFloat()
{
	float a = num_, b = denom_;
	return a/b;
}

double fract::ToDouble()
{
	double a = num_, b = denom_;
	return a/b;
}

ostream & operator<<(ostream & os, fract & f)
{
	if (labs(f.num_ / f.denom_) > 0) os << f.num_ / f.denom_ << " ";
	if (labs(f.num_ % f.denom_) > 0) {
		if (f.num_ / f.denom_ > 0) os << labs(f.num_% f.denom_);
		else os << f.num_ % f.denom_;
		os << "/" << f.denom_;
	}
	return os;
}

int operator==(fract f1, fract f2)
{
	f1.optimize();f2.optimize();
	return ((f1.num_ == f2.num_) || (f1.denom_ == f2.denom_));
}

int operator==(fract f1, double other)
{
	return (f1.ToDouble() == other);
}

int operator==(double other, fract f1)
{	return (f1 == other);}

int operator<(fract f1, fract f2)
{  return (f1.ToDouble() < f2.ToDouble());}

int operator>(fract f1, fract f2)
{  return (f2 < f1);}

int operator!=(fract f1, fract f2)
{  return (!(f1 == f2));}

int operator<=(fract f1, fract f2)
{	return (!(f1 > f2));}

int operator>=(fract f1, fract f2)
{	return (!(f1 < f2));}

fract operator*(fract f1, fract f2)
{
	f1.optimize();f2.optimize();
	fract f3(f1.num_ * f2.num_, f1.denom_ * f2.denom_);
	f3.optimize();
	return f3;
}

fract operator/(fract f1, fract f2)
{
	fract f3;
	f1.optimize();f2.optimize();
	if (f1.denom_ * f2.num_ < 32768l)
	{
		f3.ins(f1.num_ * f2.denom_, (f1.denom_ * f2.num_) % 32768l);
		f3.optimize();
	} else {cerr << "The two fractions are too complex to be divided!\n";}
	return f3;
}

fract operator+(fract f1, fract f2)
{
	f1.optimize();
	f2.optimize();
	fract f3((f1.num_ * f2.denom_) + (f1.denom_ * f2.num_), f1.denom_ * f2.denom_);
	return f3;
}

fract operator-(fract f1, fract f2)
{
	f2.num_ = f2.num_ * -1;
	return (f1 + f2);
}

void operator*=(fract original, fract newfract) {original = newfract * original;}
void operator/=(fract original, fract newfract) {original = original / newfract;}
void operator+=(fract original, fract newfract) {original = newfract + original;}
void operator-=(fract original, fract newfract) {original = original - newfract;}

double sin(fract f1) {return sin(f1.ToDouble());}
double cos(fract f1) {return cos(f1.ToDouble());}
double tan(fract f1) {return tan(f1.ToDouble());}
double atan(fract f1) {return atan(f1.ToDouble());}
double asin(fract f1) {return asin(f1.ToDouble());}
double acos(fract f1) {return acos(f1.ToDouble());}
double atan2(fract f1, fract f2) {return atan2(f1.ToDouble(), f2.ToDouble());}
double cosh(fract f1) {return cosh(f1.ToDouble());}
double sinh(fract f1) {return sinh(f1.ToDouble());}
double tanh(fract f1) {return tanh(f1.ToDouble());}
double sqrt(fract f1) {return sqrt(f1.ToDouble());}
fract frprob_appear(unsigned int , unsigned int , unsigned int );

struct exp_t
{
	char mpandexp[3];
	int getmp();
	int getexp();
};

int exp_t::getmp()
{return *((unsigned *)&mpandexp[0]);}

int exp_t::getexp()
{return *((unsigned char *)&mpandexp[2]);}

struct lexp_t
{
	char mpandexp[5];
	unsigned long getmp();
	int getexp();
};

unsigned long lexp_t::getmp()
{return *((unsigned long *)&mpandexp[0]);}

int lexp_t::getexp()
{return *((unsigned char *)&mpandexp[4]);}

void cgetmultipliers(unsigned , exp_t * );
void lcgetmultipliers(unsigned long, lexp_t * mps);


fract pow(fract f1, unsigned int a)
{
	f1.num_ = (long)pow(f1.num_, a);
	f1.denom_ = (unsigned int)pow(f1.denom_, a);
	return f1;
}

unsigned int gcd(unsigned int number1, unsigned int number2)
{
	unsigned int temp;
	if (number1 < number2)
	{
		temp = number1;
		number1 = number2;
		number2 = temp;
	}
	while (number1 % number2 != 0)
	{
		temp = number1 % number2;
		number1 = number2;
		number2 = temp;
	}
	return number2;
}

unsigned long lgcd(unsigned long number1, unsigned long number2)
{
	unsigned long temp;
	if (number1 < number2)
	{
		temp = number1 ;
		number1 = number2;
		number2 = temp;
	}
	while (number1 % number2 != 0)
	{
		temp = number1 % number2;
		number1 = number2;
		number2 = temp;
	}
	return number2;
}

unsigned long factorial(unsigned int Number)
{
	unsigned long Result = 1;
	for(int a=1;a<=Number;a++) Result *= a;
	return Result;
}

unsigned long nPr(unsigned int Base, unsigned int secondary)
{
	unsigned long Result = 1;
	if (Base >= secondary) {
		for (int a = 0;a<secondary;a++) Result *= Base - a;
		return Result;
	} else return 0;
}

unsigned long nCr(unsigned int Base, unsigned int secondary)
{
	return (nPr(Base,secondary) / factorial(secondary));
}

char * roman(unsigned int number)
{
	char * Roman = "";
	ostrstream os;
	if (number > 3999) cerr << "The number given to roman() is too big";
	else
	{
		switch(number / 1000) {
			case 0 : break;
			case 1 : os << "M";break;
			case 2 : os << "MM";break;
			case 3 : os << "MMM";
		}
		switch((number % 1000) / 100) {
			case 0 : break;
			case 3 : os << "C";
			case 2 : os << "C";
			case 1 : os << "C";break;
			case 4 : os << "C";
			case 5 : os << "D";break;
			case 6 : os << "DC"; break;
			case 7 : os << "DCC"; break;
			case 8 : os << "DCCC"; break;
			case 9 : os << "CM";
		}
		switch((number % 100) / 10) {
			case 0 : break;
			case 3 : os << "X";
			case 2 : os << "X";
			case 1 : os << "X";break;
			case 4 : os << "X";
			case 5 : os << "L";break;
			case 6 : os << "LX"; break;
			case 7 : os << "LXX"; break;
			case 8 : os << "LXXX"; break;
			case 9 : os << "XC";
		}
		switch(number % 10) {
			case 0 : break;
			case 3 : os << "I";
			case 2 : os << "I";
			case 1 : os << "I";break;
			case 4 : os << "I";
			case 5 : os << "V";break;
			case 6 : os << "VI"; break;
			case 7 : os << "VII"; break;
			case 8 : os << "VIII"; break;
			case 9 : os << "IX";
		}
	}
	Roman = os.str();
	*(Roman+os.pcount()) = '\0';
	return Roman;
}

void mix(int * Place, unsigned int maxnum)
{
	int T = -1;
	for (int a = 0;a<maxnum;a++) *(Place+a) = 0;
	randomize();
	for (a = 1;a<=maxnum;a++)
	{
		for (int b = 0;b<=random(maxnum-a+1);b++)
		{
			T++;
			while(*(Place+T) != 0) T++;
		}
		*(Place+T) = a;
		T=-1;
	}
}

double get1stroot(double a, double b, double c)
{
	double d;
	if ((a != 0) && (b*b-4*a*c>=0))
	{
		d = (-b + sqrt(b*b-4*a*c)) / (2*a);
	} else {
		cerr << "There is an error in the parameters of function get1stroot()!";
		d = 0;
	}
	return d;
}

double get2ndroot(double a, double b, double c)
{
	double d;
	if ((a != 0) && (b*b-4*a*c>=0))
	{
		d = (-b - sqrt(b*b-4*a*c)) / (2*a);
	} else {
		cerr << "There is an error in the parameters of function get1stroot()!";
		d=0;
	}
	return d;
}

double prob_appear(unsigned int range, unsigned int Dnumber, unsigned int lowest)
{
	double Return;
	if (!range || !Dnumber || !lowest || (lowest > range))
	{
		cerr << "Bad parameters in function prob_appear()";
		Return = 0;
	} else
	{
		Return = 1 - pow(lowest-1, Dnumber)/pow(range,Dnumber);
	}
	return Return;
}

fract frprob_appear(unsigned int range, unsigned int number, unsigned int lowest)
{
	fract Return;
	if (!range || !number || !lowest || (lowest > range))
	{
		cerr << "Bad parameters in function frprob_appear()";
	} else
	{
		Return.ins((long)pow(lowest-1, number),(unsigned int)pow(range,number));
		Return.ins(labs(Return.denom_-Return.num_),Return.denom_);
		Return.optimize();
	}
	return Return;
}

void getmultipliers(unsigned number, unsigned * mps, int with_exp = 0)
{
	unsigned a, exp;
	if (with_exp)
	{
		for (a=2; a<=number; a++)
		{
			if (number%a == 0)
			{
				*mps = a;
				mps++;
				exp = 0;
				while (number%a == 0)
				{
					number/= a;
					exp++;
				}
				*mps=exp;
				mps++;
	}	}	}
	else {
		for (a=2; a<=number; a++)
		{
			while (number%a == 0)
			{
				*mps = a;
				mps++;
				number/= a;
	}	}	}
	*mps = 0;
}

void lgetmultipliers(unsigned long number, unsigned long * mps, int with_exp = 0)
{
	unsigned long a, exp;
	if (with_exp)
	{
		for (a=2; a<=number; a++)
		{
			if (number%a == 0)
			{
				*mps = a;
				mps++;
				exp = 0;
				while (number%a == 0)
				{
					number/= a;
					exp++;
				}
				*mps=exp;
				mps++;
	}	}	}
	else {
		for (a=2; a<=number; a++)
		{
			while (number%a == 0)
			{
				*mps = a;
				mps++;
				number/= a;
	}	}	}
	*mps = 0;
}

void cgetmultipliers(unsigned number, exp_t * mps)
{
	unsigned a;
	unsigned char exp;
	for (a=2; a<=number; a++)
	{
		if (number%a == 0)
		{
			*((unsigned int * )mps) = a;
			exp = 0;
			while (number%a == 0)
			{
				number/= a;
				exp++;
			}
			mps->mpandexp[2]=exp;
			mps++;
	}	}
	*((unsigned int * )mps) = 0;
}

void lcgetmultipliers(unsigned long number, lexp_t * mps)
{
	unsigned long a;
	unsigned char exp;
	for (a=2; a<=number; a++)
	{
		if (number%a == 0)
		{
			*((unsigned long * )mps) = a;
			exp = 0;
			while (number%a == 0)
			{
				number/= a;
				exp++;
			}
			mps->mpandexp[4]=exp;
			mps++;
	}	}
	*((unsigned long * )mps) = 0;
}

int IsPrime(unsigned long number)
{
	unsigned long a, max = (unsigned long)sqrt(number);
	for (a=2;a<=max;a++)
		if (number%a == 0)
		{
			return 0;
		}
	return 1;
}

int IsPrimef(unsigned number)
{
	unsigned long remains[32], total_rem=1, temp1=number;
	long temp2;
	unsigned a;
	if (number<3)
		return 1;
	else
	{
		remains[0]=2;
		for (a=1;a<=blogl(number,2);a++)
			remains[a] = (remains[a-1]*remains[a-1])%number;
		for (a=(unsigned)blogl(number,2);temp1>0;a--)
		{
			temp2 = (unsigned long)pow(2,a);
			if ((long)(temp1-temp2)>=0)
			{
				total_rem = (total_rem * remains[a]) % number;
				temp1 -= temp2;
			}
		}
		return (total_rem == 2);
	}
}

int IsPrimefl (unsigned long number)
{
	unsigned long exps[100], mods[100], temp_mod, temp_exp, mod_base,a,ptr=1;
	if(number<4) return 1;
	else
	{
		temp_mod = (1l << (temp_exp = (unsigned)blogl(number,2)+1)) % number;
		while (temp_mod>65535l)
		{
			temp_mod = (temp_mod << 1) % number;
			temp_exp+=1;
		}
		mods[0] = temp_mod; exps[0] = temp_exp;
		while(temp_exp<number>>1)
		{
			if (temp_mod == 1)
			{
				number %= temp_exp;
				break;
			}
			a = (unsigned long)blogl(4294967295l, temp_mod);
			temp_mod = (unsigned long)pow(temp_mod,a) % number;
			temp_exp *= a;
			while (temp_mod>65535l)
			{
				temp_mod = (temp_mod << 1) % number;
				temp_exp+=1;
			}
			mods[ptr] = temp_mod; exps[ptr] = temp_exp;
			//cout << exps[ptr] << ":" << mods[ptr] << "\n";
			ptr++;
		}
		temp_mod = 1; temp_exp = number;
		for(a=ptr-1;a!=0;a--)
		{
			while (temp_exp>=exps[a])
			{
				temp_mod = (temp_mod * mods[a]) % number;
				temp_exp -= exps[a];
			}
			while ((temp_mod>65535l) && temp_exp)
			{
				temp_mod = (temp_mod << 1) % number;
				temp_exp -=1;
			}
		}
		for(a=0;a<temp_exp;a++)
			temp_mod = (temp_mod << 1) % number;
	}
	return (temp_mod == 2);
}

void PrimeMap(unsigned int n, void * mp)
{
	unsigned int pr;
	unsigned long muls;
	for(pr=2;pr<n;pr++)
		bwrite(mp,pr,1);
	for(pr=2;pr<=(unsigned int)sqrt(n);pr++)
		if (bread(mp,pr))
			for (muls=pr*pr;muls<n;muls+=pr)
				bwrite(mp,muls,0);
}

int a_d_v(unsigned n, unsigned max_,unsigned char * ea, unsigned long * max)
{
	if (n>=max_) return 0;
	(*ea)++;
	if ((*ea)>(*max))
	{
		*ea = 0;
		return a_d_v (n+1,max_,ea+1,max+2);
	}
	return 1;
}

void getdividors(unsigned long number, unsigned long * diva)
{
	unsigned long mps[50], mnum=0,a,tot;
	unsigned char which[35];
	lgetmultipliers(number,mps,1);
	while	(mps[mnum*2]) mnum++;
	for (a=0;a<35;a++) which[a]=0;
	do
	{
		tot=1;
		for (a=0;a<mnum;a++)
			tot *= (unsigned long)pow(mps[a*2],which[a]);
		*diva = tot;
		diva++;
	} while (a_d_v(0,mnum,&(which[0]),&(mps[1])));
	*diva=0;
}

int Npoly(unsigned int terms,unsigned exp,unsigned * combi)
{
	unsigned long sum=0;
	for(unsigned a=0;a<terms;sum+=*(combi+a),a++) ;
	if ((sum != exp) || (sum > 12))
		return 0;
	sum = factorial(exp);
	for(a=0;a<terms;sum/=factorial(*(combi+a)),a++) ;
	return sum;
}

#endif // CCALC_H

// Stastical functions, templates and classes
struct Stat_Info
{
	unsigned n;
	double Sx, Sx2;
	double mean, SD_entire, SD;
};

template <class T> void add_data(Stat_Info & stat, T * data, unsigned n)
{
	for(unsigned a=0;a<n;a++)
	{
		stat.Sx += (double)(*data);
		stat.Sx2 += (double)(*data)*(double)(*data);
		data++;
	}
	n = (stat.n+=n);
	stat.mean = stat.Sx/n;
	stat.SD_entire = sqrt((stat.Sx2-n*stat.mean*stat.mean)/n);
	stat.SD = sqrt((stat.Sx2-n*stat.mean*stat.mean)/(n-1));
}

template <class T> void rem_data(Stat_Info & stat, T * data, unsigned n)
{
	for(unsigned a=0;a<n;a++)
	{
		stat.Sx -= (double)(*data);
		stat.Sx2 -= (double)(*data)*(double)(*data);
		data++;
	}
	n = (stat.n-=n);
	stat.mean = stat.Sx/n;
	stat.SD_entire = sqrt((stat.Sx2-n*stat.mean*stat.mean)/n);
	stat.SD = sqrt((stat.Sx2-n*stat.mean*stat.mean)/(n-1));
}

template <class T> Stat_Info getStat(T * data, unsigned n)
{
	Stat_Info stat;
	stat.n = 0;
	stat.Sx = 0;stat.Sx2 = 0;
	add_data(stat, data, n);
	return stat;
}

struct Stat_InfoXY
{
	unsigned n;
	double Sx, Sx2;
	double meanx, SD_entirex, SDx;
	double Sy, Sy2;
	double meany, SD_entirey, SDy;
	double Sxy;
};

template <class T> void add_dataXY(Stat_InfoXY & stat, T * data, unsigned n)
{
	for(unsigned a=0;a<n;a++)
	{
		stat.Sx += (double)(*data);
		stat.Sx2 += (double)(*data)*(double)(*data);
		data++;
		stat.Sy += (double)(*data);
		stat.Sy2 += (double)(*data)*(double)(*data);
		stat.Sxy += (double)(*data)*(double)(*(data-1));
		data++;
	}
	n = (stat.n+=n);
	stat.meanx = stat.Sx/n;
	stat.SD_entirex = sqrt((stat.Sx2-n*stat.meanx*stat.meanx)/n);
	stat.SDx = sqrt((stat.Sx2-n*stat.meanx*stat.meanx)/(n-1));
	stat.meany = stat.Sy/n;
	stat.SD_entirey = sqrt((stat.Sy2-n*stat.meany*stat.meany)/n);
	stat.SDy = sqrt((stat.Sy2-n*stat.meany*stat.meany)/(n-1));
}

template <class T> Stat_InfoXY getStatXY(T * data, unsigned n)
{
	Stat_InfoXY stat;
	stat.n = 0;
	stat.Sx = 0;stat.Sx2 = 0;stat.Sy = 0;stat.Sy2 = 0;stat.Sxy = 0;
	add_dataXY(stat, data, n);
	return stat;
}

template <class T> void rem_dataXY(Stat_InfoXY & stat, T * data, unsigned n)
{
	for(unsigned a=0;a<n;a++)
	{
		stat.Sx -= (double)(*data);
		stat.Sx2 -= (double)(*data)*(double)(*data);
		data++;
		stat.Sy -= (double)(*data);
		stat.Sy2 -= (double)(*data)*(double)(*data);
		stat.Sxy -= (double)(*data)*(double)(*(data-1));
		data++;
	}
	n = (stat.n-=n);
	stat.meanx = stat.Sx/n;
	stat.SD_entirex = sqrt((stat.Sx2-n*stat.meanx*stat.meanx)/n);
	stat.SDx = sqrt((stat.Sx2-n*stat.meanx*stat.meanx)/(n-1));
	stat.meany = stat.Sy/n;
	stat.SD_entirey = sqrt((stat.Sy2-n*stat.meany*stat.meany)/n);
	stat.SDy = sqrt((stat.Sy2-n*stat.meany*stat.meany)/(n-1));
}

void Fadd_dataXY(unsigned n, unsigned size, Stat_InfoXY * stat, void * vdata, double (*fX)(void *), double (*fY)(void *))
{
	double x, y; char * data = (char*)vdata;
	for(unsigned a=0;a<n;a++)
	{
		x = (*fX)(data); y = (*fY)(data+size);
		stat->Sx += x;
		stat->Sx2 += x*x;
		stat->Sy += y;
		stat->Sy2 += y*y;
		stat->Sxy += x*y;
		data += size*2;
	}
	n = (stat->n+=n);
	stat->meanx = stat->Sx/n;
	stat->SD_entirex = sqrt((stat->Sx2-n*stat->meanx*stat->meanx)/n);
	stat->SDx = sqrt((stat->Sx2-n*stat->meanx*stat->meanx)/(n-1));
	stat->meany = stat->Sy/n;
	stat->SD_entirey = sqrt((stat->Sy2-n*stat->meany*stat->meany)/n);
	stat->SDy = sqrt((stat->Sy2-n*stat->meany*stat->meany)/(n-1));
}

Stat_InfoXY FgetStatXY(unsigned n, unsigned size, void * data, double (*fX)(void *), double (*fY)(void *))
{
	Stat_InfoXY stat;
	stat.n = 0;
	stat.Sx = 0;stat.Sx2 = 0;stat.Sy = 0;stat.Sy2 = 0;stat.Sxy = 0;
	Fadd_dataXY(n,size,&stat,data,fX,fY);
	return stat;
}

void Frem_dataXY(unsigned n, unsigned size, Stat_InfoXY * stat, void * vdata, double (*fX)(void *), double (*fY)(void *))
{
	double x, y; char * data = (char*)vdata;
	for(unsigned a=0;a<n;a++)
	{
		x = (*fX)(data); y = (*fY)(data+size);
		stat->Sx -= x;
		stat->Sx2 -= x*x;
		stat->Sy -= y;
		stat->Sy2 -= y*y;
		stat->Sxy -= x*y;
		data += size*2;
	}
	n = (stat->n-=n);
	stat->meanx = stat->Sx/n;
	stat->SD_entirex = sqrt((stat->Sx2-n*stat->meanx*stat->meanx)/n);
	stat->SDx = sqrt((stat->Sx2-n*stat->meanx*stat->meanx)/(n-1));
	stat->meany = stat->Sy/n;
	stat->SD_entirey = sqrt((stat->Sy2-n*stat->meany*stat->meany)/n);
	stat->SDy = sqrt((stat->Sy2-n*stat->meany*stat->meany)/(n-1));
}

struct RgrsInfo
{
	double a, b, r;
	double estY(double X) {return a+b*X;}
	double estX(double Y) {return (Y-a)/b;}
	double devi_perc(double X, double Y) {return abs((Y-estY(X))/estY(X))*100;}
};

RgrsInfo regress(Stat_InfoXY i)
{
	RgrsInfo rgrs;
	rgrs.a = (i.Sy*i.Sx2-i.Sx*i.Sxy)/(i.n*i.Sx2-i.Sx*i.Sx);
	rgrs.b = (i.n*i.Sxy-i.Sx*i.Sy)/(i.n*i.Sx2-i.Sx*i.Sx);
	rgrs.r = (i.n*i.Sxy-i.Sx*i.Sy)/sqrt((i.n*i.Sx2-i.Sx*i.Sx)*(i.n*i.Sy2-i.Sy*i.Sy));
	return rgrs;
}

typedef double tt;
double LMS_nochange(void * p) {return (double)(*(tt*)p);}
double LMS_ln(void * p) {return log((*(tt*)p));}
double LMS_reci(void * p) {return 1/(double)(*(tt*)p);}
#define LINEAR_LMS 	&LMS_nochange, &LMS_nochange
#define EXPO_LMS 		&LMS_nochange, &LMS_ln
#define LOG_LMS 		&LMS_ln, &LMS_nochange
#define POWER_LMS 	&LMS_ln, &LMS_ln
#define INVERSE_LMS 	&LMS_reci, &LMS_nochange

template <class N> double getgeomean(N * data, unsigned n)
{
	double logtot=0;
	for(unsigned a=0;a<n;a++)
	{
		if (data[a]==0)
			return 0;
		else
			logtot+=log(fabs(data[a]));
	}
	return exp(logtot/n);
}


/*int main()
{
	long double data[200], inx, iny;
	unsigned n, NMAX = 7;
	cout << "Enter the values x,y (one by one) - ";
	for(n=0;n<NMAX;n++)
	{
		cin >> inx;
		data[n] = inx;
	}
	cout.precision(13);
	cout << "The geometric mean of the numbers is " << getgeomean(data,n);
	_AX = 1; asm int 0x16;
	return 0;
}

/*unsigned long s[500],a=0,number;
	while (_exit != 'n')
	{
	cout << "Please enter a number- ";
	cin >> number;
	getdividors(number,s);a=0;
	while (s[a])
{		cout<<s[a]<<" ";a++;}
	cout << "\nWould you like to do it again? ";
	cin >> _exit;
	}*/