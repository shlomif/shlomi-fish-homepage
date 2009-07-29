#include <constrea.h>
#include <dos.h>

unsigned WINDOW_HEIGHT = 20;
constream AnnoiCon;

const unsigned MAX_DISKS_NUM = 10;



class Annoi_Towers
{
	protected:
	unsigned disks_num;
	char towers[3][MAX_DISKS_NUM];
	unsigned long move_num;
	void(*present_move)(unsigned,unsigned,unsigned);
	public:
	Annoi_Towers(unsigned,void(*)(unsigned,unsigned,unsigned));
	void move_disk();
	void creat_1p_tower(unsigned);
	void move_all_disks();
};

Annoi_Towers::Annoi_Towers(unsigned new_disks_num, void(*new_pm)(unsigned,unsigned,unsigned))
{
	disks_num=new_disks_num;
	present_move = new_pm;               //   The direction is upwards:
	for(unsigned a=0;a<disks_num;a++)    //                /^\ 5
	{                                    //                 |  4   (cells, not
		towers[0][a]=disks_num-a;         //                 |  3    disks!)
		towers[1][a]=towers[2][a]=0;      //                 |  2
		(*present_move)(0,a,disks_num-a); //                 |  1
	}                                    //                 |  0
	move_num=1;
}

/*
	if a n-disks tower was already constructed it will be on
	tower 2-n%2. thus for the moves recorded so far:
	Origin == 0; Target = 2-n%2;Third=n%2+1;
	After the nth stone was put, the object is to move the stones
	from the 2-n%2 tower to the 1+n%2 tower.Thus:
	Origin == 2-n%2;Target=1+n%2;Third==0;
*/

void Annoi_Towers::move_disk()
{
	int from=0, to, n=1;
	unsigned from_high,to_high;
	unsigned long _movenum = move_num;
	while(_movenum%2==0)
	{
		_movenum>>=1;
		n++;
	}
	to = 2-n%2;
	_movenum>>=1;n++;
	while(_movenum)
	{
		if (n%2)
		{
			to-=_movenum%2;from-=_movenum%2;
		}
		else {
			to+=_movenum%2;from+=_movenum%2;
		}
		_movenum>>=1;n++;
	}
	to=(to+3000)%3;from=(from+3000)%3; // In case from or to are negative.
	for(from_high=0;from_high<disks_num;from_high++)
	{
		if(towers[from][from_high]==0)
			break;
	}
	from_high--;
	for(to_high=0;towers[to][to_high]!=0;to_high++) ;
	getch();
	towers[to][to_high]=towers[from][from_high];
	(*present_move)(to,to_high,towers[from][from_high]);
	towers[from][from_high]=0;
	(*present_move)(from,from_high,0);
	move_num++;
}

/*
	if a n-disks tower was already constructed it will be on
	tower 2-n%2. thus for the moves recorded so far:
	Origin == 0; Target = 2-n%2;Third=n%2+1;
	After the nth stone was put, the object is to move the stones
	from the 2-n%2 tower to the 1+n%2 tower.Thus:
	Origin == 2-n%2;Target=1+n%2;Third==0;
*/


void Annoi_Towers::creat_1p_tower(unsigned num)
{
	if (move_num == (1<<(num-1)))
	{
		for(move_num=move_num;move_num<=(1<<num)-1;move_disk()) ;
	}
}

void Annoi_Towers::move_all_disks()
{
	for(unsigned a = 1;a<=disks_num;a++)
		creat_1p_tower(a);
}

void AnnoiConMove(unsigned tower,unsigned place,unsigned new_disk)
{
	(AnnoiCon.rdbuf())->gotoxy(tower*2+1,WINDOW_HEIGHT-place);
	if (new_disk)
	{
		(AnnoiCon.rdbuf())->textcolor(new_disk);
		AnnoiCon << (char)('0'+new_disk);
	}
	else AnnoiCon << ' ';
}

int main()
{
	AnnoiCon.window(1,1,80,25);AnnoiCon.clrscr();
	AnnoiCon.window(1,1,8,WINDOW_HEIGHT);
	Annoi_Towers annoi(9,&AnnoiConMove);
	annoi.move_all_disks();
	getch();
	return 0;
}