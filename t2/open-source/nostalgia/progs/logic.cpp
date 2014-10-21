/* LOGIC.CPP
	Programming Start date - The 13th of October , 1993.
	Programming End date - The 9th of November, 1993.
	Programmed by Shlomi Fish.
*/

#include <logic.h>
#include <iostream.h>

//LTable::LTable(unsigned i, unsigned t)
//{clear(t,i);}

void LTable::clear(unsigned t, unsigned i)
{
	traits=t;itemsnum=i;
	for(t=0;t<100;t++)
		for(i=0;i<100;i++)
			con[t][i]=0;
}

int LTable::setcon(unsigned t1,unsigned i1,unsigned t2,unsigned i2,unsigned val)
{
	if (val>2) {cerr << "Error in LTAble::setcon()! What value is this?";return 2;}
	unsigned int a, check_var[2] = {1,1};
	if (val==2)
	{
		for(a=0;a<itemsnum;a++)
			if (((con[t1*itemsnum+a][t2*itemsnum+i2] == V) && (i1!=a))
			|| ((con[t1*itemsnum+i1][t2*itemsnum+a] == V) && (i2!=a)))
			{
				return 1;
			}
	}
	else if (val == 1)
	{
		for(a=0;a<itemsnum;a++)
		{
			if ((con[t1*itemsnum+a][t2*itemsnum+i2] != X) && (i1!=a))
			{
				check_var[0] = 0;
			}
			if ((con[t1*itemsnum+i1][t2*itemsnum+a] != X) && (i2!=a))
			{
				check_var[1] = 0;
			}
			if (!(check_var[0]+check_var[1])) break;
		}
		if (check_var[0] || check_var[1]) return 1;
	}
	con[t1*itemsnum+i1][t2*itemsnum+i2]=val;
	con[t2*itemsnum+i2][t1*itemsnum+i1]=val;
	return 0;
}

unsigned LTable::getcon(unsigned t1,unsigned i1,unsigned t2,unsigned i2)
{
	return con[t1*itemsnum+i1][t2*itemsnum+i2];
}

void LTable::print_all()
{
	cout << "\n";
	for(unsigned a=0;a<3;a++)
	{
		for (unsigned b=0;b<3;b++)
		{
			switch(con[a][3+b])
			{
				case 0:cout << 'O';break;
				case 1:cout << 'X';break;
				case 2:cout << 'V';break;
			}
			cout << ' ';
		}
		for (b=0;b<3;b++)
		{
			switch(con[a][6+b])
			{
				case 0:cout << 'O';break;
				case 1:cout << 'X';break;
				case 2:cout << 'V';break;
			}
			cout << ' ';
		}
		cout<<'\n';
	}
	for (a=0;a<3;a++)
	{
		for (unsigned b=0;b<3;b++)
		{
			switch(con[6+a][3+b])
			{
				case 0:cout << 'O';break;
				case 1:cout << 'X';break;
				case 2:cout << 'V';break;
			}
			cout << ' ';
		}
		cout << '\n';
	}
}

void LTable_LFAN::clear(unsigned i,unsigned t, unsigned last_t_)
{
	LTable::clear(i,t);
	last_t=last_t_;
};

/* NOTE!!!
	con[last_t*itemsnum+a][t1*itemsnum] represnets the number of items
	which (currently) have the a quality from the last group.
	Graphically it represnts the number of V ticks in its row or column.

	con[last_t*itemsnum+a][t1*itemsnum+1] represents the number of items
	which (currently) cannot have the quality from the last group.
	Graphically it represents the number of X ticks in its row or column.
*/

unsigned LTable_LFAN::getcon(unsigned t1,unsigned i1,unsigned t2,unsigned i2)
{
	unsigned a;
	if (t1 == traits-1)
	{
		a=t1;t1=t2;t2=a; //swaps the traits
		a=i1;i1=i2;i2=a; //swaps the items
	}
	return LTable::getcon(t1,i1,t2,i2);
}

int LTable_LFAN::setcon(unsigned t1,unsigned i1,unsigned t2,unsigned i2,unsigned val)
{
	if (val>2) {cerr << "Error in LTable::setcon()! What value is this?";return 2;}
	unsigned a,b;
	if (t1 == traits-1)
	{
		a=t1;t1=t2;t2=a; //swaps the traits
		a=i1;i1=i2;i2=a; //swaps the items
	}
	if (t2 == traits-1) //last field stuff
	{
		b=getcon(t1,i1,t2,i2);  //assigning check argument
		if ((val == 2) && checkit(t1,i1,i2) && (b!=2)) return 2;
		else if ((val == 1) && checkitX(t1,i1,i2)) return 2;
		else
		{
			con[t1*itemsnum+i1][t2*itemsnum+i2] = val;
			con[t2*itemsnum+i2][t1*itemsnum+2-val] += ((b!=val) && val);
			con[t2*itemsnum+i2][t1*itemsnum+2-b] -= ((b!=val) && b);
		}
		return 0;
	}
	else return LTable::setcon(t1,i1,t2,i2,val);
}

int LTable_LFAN::checkit(unsigned int t1, unsigned int i1,unsigned int i2)
{
/*	unsigned a, lt_total;
	for(a=0;a<last_t;a++)
		lt_total+=con[(traits-1)*itemsnum+a][t1*itemsnum];*/
	i2++;
	for (unsigned a=0;a<last_t;a++)
		if (con[t1*itemsnum+i1][(traits-1)*itemsnum+a]==2) return 1;
	return 0;
} // return 1 if not good.

int LTable_LFAN::checkitX(unsigned t1, unsigned i1, unsigned i2)
{
	for (unsigned a=0;a<last_t;a++)
		if ((a!=i2) && (con[t1*itemsnum+i1][(traits-1)*itemsnum+a] != 1))
			return 0;
	return 1;
} // return 1 if not good.


void LTable_LFAN::print_all()
{
	cout<<"\n";
	unsigned x,y;
	for(y=0;y<5;y++)
	{
		for(x=0;x<5;x++)
		{
			switch(getcon(1,x,0,y))
			{
				case X : cout << "X ";break;
				case V : cout << "V ";break;
				case O : cout << "O ";break;
			}
		}
		for(x=0;x<3;x++)
		{
			switch(getcon(2,x,0,y))
			{
				case X : cout << "X ";break;
				case V : cout << "V ";break;
				case O : cout << "O ";break;
			}
		}
		cout << "\n";
	}
	for(y=0;y<3;y++)
	{
		for(x=0;x<5;x++)
		{
			switch(getcon(2,y,1,x))
			{
				case X : cout << "X ";break;
				case V : cout << "V ";break;
				case O : cout << "O ";break;
			}
		}
		cout << "\n";
	}
	cout << '\n';
}

void LTable_LFIAN::clear(unsigned i, unsigned t, unsigned last_t_, unsigned * newlfit)
{
	LTable_LFAN::clear(i,t,last_t_);
	unsigned total=0;
	for (unsigned a = 0;a<last_t;a++)
		total += (lfi_ticksnum[a] = *(newlfit+a));
	if ((total!=itemsnum) || (last_t>itemsnum))
		cerr << "Error in input to LTable_LFIAN!";
}

int LTable_LFIAN::checkit(unsigned t1, unsigned i1,unsigned i2)
{
	return (LTable_LFAN::checkit(t1,i1,i2) || (con[(traits-1)*itemsnum+i2][t1*itemsnum]==lfi_ticksnum[i2]));
}

int LTable_LFIAN::checkitX(unsigned t1, unsigned i1,unsigned i2)
{
	return (LTable_LFAN::checkitX(t1,i1,i2) || (con[(traits-1)*itemsnum+i2][t1*itemsnum+1]==itemsnum-lfi_ticksnum[i2]));
}

void NameTable::clear(unsigned i,unsigned t, unsigned ltt, unsigned *lti)
{
	unsigned total=0;
	itemsnum=i;traits=t;lttype=ltt,last_ti[10]=traits;
	if (ltt > 0)
	{
		last_ti[10]=*lti;lti++;
		if (ltt>1)
		{
		for (i= 0;i<last_ti[10];i++)
			total += (last_ti[i] = *(lti+i));
		if ((total!=itemsnum) || (last_ti[10]>itemsnum))
			cerr << "Error in input to NameTable::clear()!";
		}
	}
	for(i=0;i<10;i++)
		for(t=0;t<10;t++) cell[i][t] = 10;
}

/* NOTE!!!
	A cell with a 10 in it means nothing is written in it.
	last_ti[10] represents the number of possibilities in the last traits.
	(for ltt = 1 and for ltt = 2).
*/

unsigned NameTable::getitem(unsigned number, unsigned trait_)
{
	if ((number<itemsnum) && (trait_<(lttype ? (traits -1) : traits)))
		return cell[number][trait_];
	else {
		cerr << "Error in function NameTable::getitem()!\nParameter are too large!";
		return 0;
	}
}

int NameTable::setitem(unsigned number, unsigned trait_, unsigned newval)
{
	unsigned a,total=0;
	if (newval > last_ti[10])
		cell[number][trait_]=10;
	else
	switch(lttype)
	{
		case lfan_nt :
			if (trait_ == traits-1)
			{
				cell[number][trait_] = newval;
				break;
			}
		case normal_nt :
			label_one:
			for(a=0;a<itemsnum;a++)
				if ((cell[a][trait_]==newval) && (a != number))
					return 1;
			cell[number][trait_] = newval;
			break;
		case lfian_nt :
			if (trait_ == traits-1)
			{
				for(a=0;a<itemsnum;a++)
					total+=(cell[a][trait_]==newval);
				if ((total == last_ti[newval]) && (cell[number][trait_]!=2)) return 1;
				else cell[number][trait_]=newval;
			}
			else goto label_one;
	}
	return 0;
}

void LogicStats::clear(unsigned newnum)
{
	stats_num = newnum;
	for(newnum=0;newnum<50;newnum++)
		statements[newnum]=O;
	if (stats_num>50)
	{
		stats_num = 50;
		cerr << "Error in input to LogicStats::clear()!";
	}
}

void LogicStats::set_stat(unsigned sn,unsigned newval)
{
	if ((sn>=stats_num)||(newval>2)) cerr << "Error in input to LogicStats::setstat()!";
	else statements[sn]=newval;
}

unsigned LogicStats::get_stat(unsigned sn)
{
	if (sn>=stats_num) {
		cerr << "Error in input to LogicStats::setstat()!";
		return 4;
	}
	else return statements[sn];
}