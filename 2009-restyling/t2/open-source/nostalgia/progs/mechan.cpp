#include <math.h>
#include <iostream.h>
#include <dos.h>
#include <graphics.h>

enum vect_input {Cartezian=0, Polar=1};

double deg = 180 / M_PI;

class vector
{
	protected:
	double x, y; // coordinates
	public:
	vector(double,double,int);
	void recalc(double,double,int);
	// output functions
	double getx() {return x;}
	double gety() {return y;}
	double get_r() {return sqrt(x*x+y*y);}
	double get_teta() {return (atan2(y,x)*deg);}
	vector operator +=(vector);
	vector operator -=(vector);
};

// vector operations
vector operator+(vector, vector);
vector operator-(vector, vector);
vector operator*(vector, double);
vector operator*(double scal, vector v) {return (v*scal);}

vector::vector(double a, double b, int RC = Cartezian)
{
	if (RC) {
		x = cos(b/deg)*a;
		y = sin(b/deg)*a;
	}
	else {
		x = a;
		y = b;
	}
};

void vector::recalc(double a, double b, int RC = Cartezian)
{
	if (RC) {
		x = cos(b/deg)*a;
		y = sin(b/deg)*a;
	}
	else {
		x = a;
		y = b;
	}
}

vector operator+(vector a,vector b)
{
	vector c(a.getx()+b.getx(),a.gety()+b.gety());
	return c;
}

vector operator-(vector a,vector b)
{
	vector c(a.getx()-b.getx(),a.gety()-b.gety());
	return c;
}

vector operator*(vector v, double scal)
{
	v.recalc(v.getx()*scal, v.gety()*scal);
	return v;
}

vector vector::operator+=(vector v2)
{
	x+=v2.getx();y+=v2.gety();
	return *this;
}

vector vector::operator-=(vector v2)
{
	x-=v2.getx();y-=v2.gety();
	return *this;
}

class r;
class V;
class a;

class r : public vector
{
	protected:
	V * velo;
	public:
	r(double,double,int);
	void set_velocity(V *);
	void recalc(double a,double b, int RC) {vector::recalc(a,b,RC);}
	void recalc(double);
	void addto(r);
};

class V : public vector
{
	protected:
	a * accler;
	public:
	V(double,double,int);
	void set_accler(a*);
	void recalc(double a,double b, int RC) {vector::recalc(a,b,RC);}
	void recalc(double);
	void addto(V);
};

class a : public vector
{
	public:
	a(double,double,int);
	void recalc(double aa, double b, int RC) {vector::recalc(aa,b,RC);}
	void addto(a);
};

r::r(double a, double b, int RC) : vector(a,b,RC) {}

void r::set_velocity(V * new_velo)
{
	velo = new_velo;
}

void r::recalc(double time)
{
	(*this) += (*velo * time);
	velo->recalc(time);
}

void r::addto(r delta)
{
	(*this) += delta;
}

V::V(double a, double b, int RC) : vector(a,b,RC) {}

void V::set_accler(a * new_accler)
{
	accler = new_accler;
}

void V::recalc(double time)
{
	(*this) += (*accler) * time;
}

void V::addto(V delta)
{
	(*this) += delta;
}

a::a(double aa, double b, int RC) : vector(aa,b,RC) {}

void a::addto(a delta)
{
	(*this) += delta;
}

int main()
{
	int c=DETECT, b;
	initgraph(&c,&b,"c:\\tc\\bgi");
	r r1 (100,100,Cartezian);
	V v1 (10,0,Cartezian);
	a a1 (0,2,Cartezian);
	r1.set_velocity(&v1);
	v1.set_accler(&a1);
	for(c=0;c<100;c++)
	{
		putpixel((int)r1.getx(), (int)r1.gety(), 1);
		delay(200);
		putpixel((int)r1.getx(), (int)r1.gety(), 0);
		r1.recalc(0.005);
		a1.recalc(2,v1.get_teta()-90,Polar);
	}
	return 0;
}