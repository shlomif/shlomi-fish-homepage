/* LOGIC.H
	Programming Start date - The 13th of October , 1993.
	Programming End date - The 9th of November, 1993.
	Programmed by Shlomi Fish.
*/

enum Connection {O=0, X=1, V=2};

class LTable
{
	protected:
	unsigned int traits, itemsnum;
	char con[100][100];
	public:
	//LTable(unsigned,unsigned);
	void clear(unsigned,unsigned);
	int setcon(unsigned,unsigned,unsigned,unsigned,unsigned);
	unsigned getcon(unsigned,unsigned,unsigned,unsigned);
	void print_all();
};

class LTable_LFAN : public LTable // LTable whose Last Field has an Alternate Number
{
	protected:
	unsigned last_t;
	public:
	//LTable_LFAN(unsigned,unsigned,unsigned);
	void clear(unsigned,unsigned,unsigned);
	unsigned getcon(unsigned,unsigned,unsigned,unsigned);
	int setcon(unsigned,unsigned,unsigned,unsigned,unsigned);
	virtual int checkit(unsigned,unsigned,unsigned);
	virtual int checkitX(unsigned,unsigned,unsigned);
	void print_all();
};

/* NOTE!!!
	con[last_t*itemsnum+a][t1*itemsnum] represnets the number of items
	which (currently) have the a quality from the last group.
	Graphically it represnts the number of V ticks in its row or column.
*/

class LTable_LFIAN : public LTable_LFAN // LTable whose Last Field's Items has Alternate Numbers (of ticks)
{
	protected:
	unsigned lfi_ticksnum[10];
	public:
	//LTable_LFIAN(unsigned,unsigned,unsigned,unsigned*);
	void clear(unsigned,unsigned,unsigned,unsigned*);
	int checkit(unsigned,unsigned,unsigned);
	int checkitX(unsigned,unsigned,unsigned);
};

enum NTable_type {normal_nt = 0, lfan_nt = 1, lfian_nt = 2};

class NameTable
{
	protected:
	unsigned itemsnum, traits, lttype;
	char cell[10][10];
	unsigned last_ti[11];
	public:
	//NameTable(unsigned i,unsigned t,unsigned ltt,unsigned* lti) {clear(i,t,ltt,lti);}
	void clear(unsigned,unsigned,unsigned,unsigned*);
	unsigned getitem(unsigned,unsigned);
	int setitem(unsigned,unsigned,unsigned);
};

/* NOTE!!!
	A cell with a 10 in it means nothing is written in it.
	last_ti[10] represents the number of possibilities in the last traits.
	(for ltt = 1 and for ltt = 2).
*/

class LogicStats
{
	protected:
	unsigned stats_num;
	char statements[50];
	public:
	//LogicStats(unsigned n) {clear(n);}
	void clear(unsigned);
	void set_stat(unsigned,unsigned);
	unsigned get_stat(unsigned);
};