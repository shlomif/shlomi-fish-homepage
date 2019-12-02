
const unsigned BindiNum = 10000;
const unsigned NindiNum = 100;
const unsigned SindiNum = 30;
const unsigned MaxOrdersNum = 500;

char B_indicators[BindiNum];  // Binary indicators
char N_indicators[NindiNum];  // Numeral indicators
char S_indicators[SindiNum][30]; // String indicators

struct order_index
{
	numorder no;
	void * ptr;
}

class Screen
{
	protected:
	unsigned orders_num;
	order_index indexes[MaxOrdersNum];
	char order_data[MaxOrdersNum * 15];
	void * picture;
}
