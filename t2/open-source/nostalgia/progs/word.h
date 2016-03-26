/*
	WORD.H - Sentence analyzing utility for text adventure games.
	Written by Shlomi Fish.
	1994, MCMXCIV Ç"êôöÑ
*/

#ifndef __STRING_H
#include <string.h>
#endif
#ifndef __SEARCH_H
#include <search.h>
#endif
#define __WORD_H

char articlewords[4][5] = {"a", "an", "some", "the"};
char connectorwords[15][7] = {"about", "at", "away", "back", "by", "for", "in", "into", "off", "on", "out", "over", "up", "to", "with"};
enum OrderType {v_, vo_, vco_, voco_, vcoco_};

const unsigned MaxVerbsNum = 40;
const unsigned MaxObjectsNum = 1000;
unsigned VerbsNum;
unsigned ObjectsNum;

struct word_s
{
	char words[10][20];
	int word_num;
	word_s(void);
};

struct order
{
	char verb[20], object[2][20];
	unsigned articles[2], connectors[2], order_type;
};

struct verbtype
{
	char name[20];
	unsigned uses_num;
	unsigned uses_type[10];
	unsigned uses_conn[10][2]; // The connectors
	verbtype();
};

struct numorder
{
	char verb;
	char use;
	unsigned object[2];
	char articles[2]; // (x div 2) : 0 - singular, 1 - plural.
};                   // (x mod 2) : 0 - indefinite, 1 - definite.

verbtype verbs[MaxVerbsNum];
char objects_sing[MaxObjectsNum][20] = {"box", "cup", "fork","man" ,"pen", "soap", "trident"};
char objects_plur[MaxObjectsNum][20] = {"boxes", "cups", "forks" , "men", "pens" , "soaps", "tridents"}; // The objects' names in the plural.

int word_divide(char * sentence, word_s & ws);
int analyze_order(word_s & ws, order & o);
int get_numorder(order o, numorder & no);

unsigned str_bsearch(void * place, void * newo, unsigned number, unsigned length, unsigned str);
int alphabet(const void * _key, const void * _elem);

int addobject(char * sing, char * plur);
int addverb(char * name);
int adduse(unsigned verb, unsigned type, unsigned con1=0, unsigned con2=0);
inline int adduse(char * verb, unsigned type, unsigned con1 = 0, unsigned con2 = 0);
/*
	Return Values:
				  |    0    |     1      |     2-3                                |
	addobject  | Success | Array Full | Duplicate (2 - Singular, 3 - Singular) |
				  |         |            |                                        |
	addverb    |         |            | Duplicate                              |
				  |         |            |                                        |
	adduse     |         |            | XXX                                    |   |
------------------------------------------------------------------------------|
*/

int remobject(char * sing, char * plur);
int remverb(char * verb_name);
int remuse(unsigned verb, unsigned use);
/*
	Return Values:
				 |    0    |    1               |         2        |
	remobject | Success | Singular Not Found | Plural Not Found |
				 |         |                    |                  |
	remverb   |         | Verb Not Found     | XXX              |
				 |         |                    |                  |
	remuse    |         | Number too large   | XXX              |
	-------------------------------------------------------------
*/