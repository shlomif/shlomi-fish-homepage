/*
	JTOG.H (Jewish to Gregorian calender conversion header)
	Programmed by Shlomi Fish
	Programming Start - 24th of June 1993 - ‚"™š„ †…š '„
	Programming End   - 8th of July 1993 - ‚"™š„ †…š 'ˆ‰
	MCMXCIII
*/

#include <iostream.h>
#ifndef __STRING_H
#include <string.h>
#endif

struct JewDay
{
	unsigned long days,hours;
	unsigned long parts;
	JewDay() {;}
	JewDay(unsigned newd, unsigned newh, unsigned newp);
	void optimize();
	unsigned long parts_val() {return (((unsigned long)days*24+hours)*1080+parts);}
	void operator =(JewDay);
};

JewDay::JewDay(unsigned newd, unsigned newh, unsigned newp)
{
	days = newd;
	hours = newh;
	parts = newp;
	optimize();
}

void JewDay::optimize()
{
	hours += (parts/1080) % 65535;
	parts %= 1080;
	days += hours / 24;
	hours %= 24;
	days %= 7;
}

// operators redeclarations for JewDay

void JewDay::operator =(JewDay rval)
{
	days = rval.days;
	hours = rval.hours;
	parts = rval.parts;
}

JewDay operator+(JewDay one, JewDay two)
{
	JewDay sum(0,0,0);
	one.optimize();two.optimize();
	sum.days = one.days + two.days;
	sum.hours = one.hours + two.hours;
	sum.parts = one.parts + two.parts;
	sum.optimize();
	return sum;
}

JewDay operator*(JewDay JD, unsigned num)
{
	JD.optimize();
	unsigned long total_parts = (JD.parts_val() * num) % (24*7*1080);
	JD.parts = total_parts;
	JD.hours = JD.days = 0;
	JD.optimize();
	return JD;
}

JewDay operator*(unsigned int num, JewDay JD)
{return JD * num;}

int operator>=(JewDay l, JewDay r) {return l.parts_val() >= r.parts_val();}

const JewDay
	MoladToho(2,5,204),
	MakhzorModul(2,16,595),
	RegYModul(4,8,876),
	LeapYModul(5,21,589),
	GT_RD(3,9,204), //only in a regular year
	TO_TKPT(2,15,589); // only after an extended year

const int PONE = 1;
const int leap[19] = {0,0,1,0,0,1,0,1,0,0,1,0,0,1,0,0,1,0,1};

enum year_type { Khasera = 0, Kesidra = 1, Shlema = 2 };

unsigned getLeapYnum(unsigned YSM)
{
	unsigned a, b=0;
	for (a=0;a<YSM;a++) b+= leap[a];
	return b;
}

unsigned FindRoshHashana (unsigned int year)
{
	JewDay Precise;
	unsigned int y = (year-PONE)%19;
	Precise = MoladToho +
		MakhzorModul * ((year-PONE)/19) +
		RegYModul * (y-getLeapYnum(y)) +
		LeapYModul * (getLeapYnum(y));
	Precise.optimize();
	unsigned int stday = Precise.days;
	// "Mulad Zaken" - after midday
	if (Precise.hours >= 18) stday++;
	else
	{// GT_RD - in Tuesday between three o'clock and 204 parts to midday in a regular year
		if ((Precise.days==3) && (Precise >= GT_RD) && !leap[y]) stday++;
		// TO_TKPT - in Monday, after a leap year
		if ((Precise.days==2) && (Precise >= TO_TKPT) && leap[y-1+(y==0)*19]) stday++;
	}
	// Regular - not in Sunday, Wednesday or Friday
	if ((stday == 1) || (stday == 4) || (stday == 6)) stday++;
	return stday%7;
}

unsigned getYlength (unsigned year)
{
	unsigned length=0;
	int day_delta = (FindRoshHashana(year+1) - FindRoshHashana(year));
	day_delta += 7 * (day_delta<0);
	if (leap[(year-PONE)%19] == 0) // a regular year
	{
		switch (day_delta)
		{

			case 5 : length++;
			case 4 : length++;
			case 3 : length += 353;
		};
	}
	else // a leap year
	{
		switch (day_delta)
		{
			case 0 : length++;
			case 6 : length++;
			case 5 : length += 383;
		};
	}
	return length;
}

int findMonthDay(unsigned day, unsigned year, unsigned & jday, unsigned & jmonth, unsigned & jyear, unsigned & wday)
{
	int month_L[13] = {30,29,29,29,30,29,29,30,29,30,29,30,29}, year_L = getYlength(year),m=0, return_=1;
	jday = day;
	// if Kesidra or Shlema
	if (day<year_L)
	{
		if (year_L > ((year_L<360) ? 353 : 383)) month_L[2]++;
		if (year_L > ((year_L<360) ? 354 : 384)) month_L[1]++;
		if (year_L>360) month_L[5]++;
		while ((signed int)jday-month_L[m] >= 0)
		{
			jday-= month_L[m];
			m+= 1 + ((year_L<360) && (m==5));
		}
		jmonth = m+(m==6)*6-(m>6); // stuff with Adar Alef and Adar Beit...
		jyear = year;
		wday = (FindRoshHashana(year)+day)%7;
	}
	else return_ = 0;
	return return_;
}

const unsigned long ML = 765433l;

int TotalFindDay(unsigned long days /* since 1 Tishrey 5739*/,unsigned & jday, unsigned & jmonth, unsigned & jyear, unsigned & wday)
{ // 235M in a makhzur
	unsigned year=0;
	unsigned long temp_parts= 11*1080+614,temp_days;
	int td;
	while (temp_parts/(24*1080) <= days)
	{
		year += 19;
		temp_parts += ML*235;
	}
	year+= 5720; temp_parts -= ML*235;
	temp_days = temp_parts/(24*1080);
	td = FindRoshHashana(year)-(MoladToho+MakhzorModul*((year-PONE)/19)).days;
	temp_days += td + (td<0) * 7;
	if (temp_days > days)
	{
		year-= 19;temp_parts -= ML*235;
		temp_days = temp_parts/(24*1080);
		td = FindRoshHashana(year)-(MoladToho+MakhzorModul*((year-PONE)/19)).days;
		temp_days += td + (td<0) * 7;
	}
	while (temp_days <= days)
	{
		temp_days += getYlength(year);
		year++;
	}
	year--;
	temp_days -= getYlength(year);
	return findMonthDay(days-temp_days,year, jday,jmonth,jyear,wday);
}

inline unsigned long FindTotalDays(unsigned year, unsigned month, unsigned day) //since 1.1.1978;
{
	unsigned long return_;
	return_ = (year - 1978) * 365;
	return_ +=	(year - 1981)/4;
	return_ +=((month>1)+(month>3)+(month>5)+(month>7)+(month>8)+(month>10)) * 31;
	return_ +=	((month>4)+(month>6)+(month>9)+(month>11)) * 30;
	return_ +=	(month>2) * ((year%4 == 0) ? 29 : 28); // February
	return_ += day-1;
	return return_;
}

int g2j(unsigned day, unsigned month, unsigned year, unsigned & jday, unsigned & jmonth, unsigned & jyear, unsigned & wday, char * occasion)
{
	*occasion = 0;
	int return_ = TotalFindDay(FindTotalDays(year,month,day)-273,jday,jmonth,jyear,wday);
	unsigned yl = getYlength(jyear);
	if (((jmonth == 0) && (jday < 2)) || ((jmonth==11) && (jday == 28))) strcpy(occasion , "„™„ ™€˜");
	if ((jmonth == 0) && (jday >7) && (jday <10)) strcpy(occasion , "˜…”‰‹-…‰");
	if ((jmonth == 0) && (jday > 12) && (jday < 23)) strcpy(occasion , "š…‹…‘");
	if (((jmonth == 2) && (jday > 24)) || ((jmonth == 3) && (jday < ((yl > ((yl<360) ? 353 : 383)) ? 2 : 3)))) strcpy(occasion , "„‹…‡");
	if ((jmonth == 4) && (jday == 14)) strcpy(occasion , "ˆ™ …ˆ");
	if ((jmonth == ((yl<360) ? 5 : 12)) && (jday > 12) && (jday < 16)) strcpy(occasion , "‰˜…”");
	if ((jmonth == 6) && (jday > 4) && (jday < 22)) strcpy(occasion , "‡‘”");
	if ((jmonth == 7) && (jday == 4)) strcpy(occasion , "š…€–’");
	if ((jmonth == 7) && (jday == 17)) strcpy(occasion , "˜…’ ‚Œ");
	if ((jmonth == 8) && (jday > 3) && (jday < 7)) strcpy(occasion , "š…’…™");
	if (*occasion != 0) return_ = 2;
	return return_;
}

/*
int g2j(uint gday, uint gmonth, uint gyear, uint & jday, uint & jmonth, uint & jyear, uint & wday, char * occasion);
// 0 - error
// 1 - regular
// 2 - holiday
*/

int main()
{
	int r;
	unsigned gday, gmonth, gyear, jday, jmonth, jyear, wday;
	char o[50];
	while (gday)
	{
		cout << "Please enter the day, month, and year of the gregorian year-\n";
		cin >> gday >> gmonth >> gyear;
		r = g2j(gday,gmonth,gyear,jday,jmonth,jyear,wday,o);
		cout << "It's day " << jday+1 << " in month " << jmonth+1 << " in year " << jyear << ", day " << wday << " of the week.\n";
		if (r==2) cout << "It's " << o << "!";
	}
	return 0;
}
