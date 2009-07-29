/*
	GTOJ.H (Gregorian to Jewishcalender conversion header)
	Programmed by Shlomi Fish
	Programming Start - 24th of June 1993 - ‚"™š„ †…š '„
	Programming End   - 9th of July 1993 - ‚"™š„ †…š '‹
	MCMXCIII
*/

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
	hours += (parts/1080) % 65535; // parts/1080 is considered long
	parts %= 1080;
	days += hours / 24;
	hours %= 24;
	days %= 7;
}

// operators overloading for JewDay

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

inline int operator>=(JewDay l, JewDay r) {return l.parts_val() >= r.parts_val();}

const JewDay
	MoladToho(2,5,204), // The "Epoch" - 1 of Tishrey, year 1.
	MakhzorModul(2,16,595), // the modular of a makhzor
	RegYModul(4,8,876), // regular year modular
	LeapYModul(5,21,589), // leap year modular
	GT_RD(3,9,204), //only in a regular year
	TO_TKPT(2,15,589); // only after a leap year

const int leap[19] = {0,0,1,0,0,1,0,1,0,0,1,0,0,1,0,0,1,0,1};

unsigned getLeapYnum(unsigned YSM)
{
	unsigned a, b=0;
	for (a=0;a<YSM;a++) b+= leap[a];
	return b;
}

unsigned FindRoshHashana (unsigned year)
{
	JewDay Precise;
	unsigned int y = (year-1)%19;
	// y = the number of years since the makzur's beginning.
	// calculating the precise JewDay (days, hours, and parts) of RoshHashana
	Precise = MoladToho +
		MakhzorModul * ((year-1)/19) +
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
	day_delta += 7 * (day_delta<0); // case more than 7
	if (leap[(year-1)%19] == 0) // a regular year
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

int findYJDate(unsigned days, unsigned year, unsigned & jday, unsigned & jmonth, unsigned & jyear, unsigned & wday)
{
	int month_L[13] = {30,29,29,29,30,29,29,30,29,30,29,30,29}, year_L = getYlength(year),m=0, return_=1;
	jday = days;
	// if Kesidra or Shlema
	if (days<year_L) // out of the year's range - an error
	{
		if (year_L > ((year_L<360) ? 353 : 383)) month_L[2]++; // Kesidra or Shlema
		if (year_L > ((year_L<360) ? 354 : 384)) month_L[1]++; // Shlema
		if (year_L>360) month_L[5]++; // a leap year - Adar Alef has 30 days
		while ((signed int)jday-month_L[m] >= 0)
		{
			jday-= month_L[m];
			m+= 1 + ((year_L<360) && (m==5)); // if not a leap year-skip Adar Beit(month 5)
		}
		jmonth = m+(m==6)*6-(m>6); // stuff with Adar Alef and Adar Beit...
		jyear = year;
		wday = (FindRoshHashana(year)+days)%7;
	}
	else return_ = 0; // error
	return return_;
}

const unsigned long ML = 179876755l;

int findTotalJdate(unsigned long days /* since 1 Tishrey 5739*/,unsigned & jday, unsigned & jmonth, unsigned & jyear, unsigned & wday)
{ // 235M in a makhzur
	unsigned year=0;
	unsigned long temp_parts= 11*1080+614,temp_days;
	// temp_parts - the exact date of the makzor beginning in parts.
	int td;
	// finds the makzor beginning of the given day
	while (temp_parts/(24*1080) <= days)
	{
		year += 19;
		temp_parts += ML;
	}
	year+= 5720; temp_parts -= ML;
	temp_days = temp_parts/(24*1080);
	// finds the date of RoshHashana
	td = FindRoshHashana(year)-(MoladToho+MakhzorModul*((year-1)/19)).days;
	temp_days += td + (td<0) * 7;
	if (temp_days > days) // if RoshHashana is after the given day - return to the previous makzor
	{
		year-= 19;temp_parts -= ML;
		temp_days = temp_parts/(24*1080);
		td = FindRoshHashana(year)-(MoladToho+MakhzorModul*((year-1)/19)).days;
		temp_days += td + (td<0) * 7;
	}
	// finds the year
	while (temp_days <= days)
	{
		temp_days += getYlength(year);
		year++;
	}
	year--;
	temp_days -= getYlength(year);
	// calls findYJDate to find the month and the year
	return findYJDate(days-temp_days,year, jday,jmonth,jyear,wday);
}

inline unsigned long GdateTotalDays(unsigned year, unsigned month, unsigned day) //since 1.1.1978;
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
	// calls findTotalJdate to find the jewish date; 273 - the number of days between 1.1.1978 and 1 of Tishrey, 5739.
	int return_ = findTotalJdate(GdateTotalDays(year,month,day)-273,jday,jmonth,jyear,wday);
	unsigned yl = getYlength(jyear);
	// checks if a holiday (not the summer vacation)
	if (((jmonth == 0) && (jday < 2)) || ((jmonth==11) && (jday == 28))) strcpy(occasion , "„™„ ™€˜");
	else if ((jmonth == 0) && (jday >7) && (jday <10)) strcpy(occasion , "˜…”‰‹-…‰");
	else if  ((jmonth == 0) && (jday > 12) && (jday < 23)) strcpy(occasion , "š…‹…‘");
	else if  (((jmonth == 2) && (jday > 24)) || ((jmonth == 3) && (jday < ((yl > ((yl<360) ? 353 : 383)) ? 2 : 3)))) strcpy(occasion , "„‹…‡");
	else if  ((jmonth == 4) && (jday == 14)) strcpy(occasion , "ˆ™ …ˆ");
	else if  ((jmonth == ((yl<360) ? 5 : 12)) && (jday > 12) && (jday < 16)) strcpy(occasion , "‰˜…”");
	else if  ((jmonth == 6) && (jday > 4) && (jday < 22)) strcpy(occasion , "‡‘”");
	else if  ((jmonth == 7) && (jday == 4)) strcpy(occasion , "š…€–’");
	else if  ((jmonth == 7) && (jday == 17)) strcpy(occasion , "˜…’ ‚Œ");
	else if  ((jmonth == 8) && (jday > 3) && (jday < 7)) strcpy(occasion , "š…’…™");
	if (*occasion != 0) return_ = 2; // if a holiday returns 2
	return return_;
}
