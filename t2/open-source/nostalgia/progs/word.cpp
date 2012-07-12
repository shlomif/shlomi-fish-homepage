#ifndef __WORD_H
#include <word.h>
#endif


word_s::word_s(void)
{
	for(unsigned a=0;a<10;a++) words[a][0]='\0';
	word_num=0;
}

int word_divide(char * sentence, word_s & ws)
{
	strlwr(sentence);
	char * pb=sentence, * pe=sentence;
	unsigned check=0;
	while (ws.word_num<10)
	{
		while ((*pe>='a') && (*pe<='z')) pe++;
		if (*pe == ' ') *pe = 0;
		else if (*pe == 0) check = 1;
		else return 0;
		strcpy(ws.words[++(ws.word_num)-1],pb);
		pb = (++pe);
		if(check) return 1;
	}
	return 0;
}
/* returns
 1 - if okay.
 0 - if an error occured.
*/

int analyze_order(word_s & ws, order & o)
{
	unsigned a, b=20;
	if ((ws.word_num != 1) && (ws.word_num != 3) && (ws.word_num != 4) && (ws.word_num != 6) && (ws.word_num != 7)) return 0;

	for (a=0;a<4;a++) if (!strcmp(articlewords[a],ws.words[0])) return 0;
	for (a=0;a<15;a++) if (!strcmp(connectorwords[a],ws.words[0])) return 0;
	strcpy(o.verb,ws.words[0]);
	if (ws.word_num == 1) o.order_type = v_;
	if ((ws.word_num == 3) || (ws.word_num == 6))
	{
		for (a=0;a<4;a++) if (!strcmp(articlewords[a],ws.words[1])) b = a;
		if (b<20) o.articles[0] = b;
		else return 0;
		for (a=0;a<4;a++) if (!strcmp(articlewords[a],ws.words[2])) return 0;
		for (a=0;a<15;a++) if (!strcmp(connectorwords[a],ws.words[2])) return 0;
		strcpy(o.object[0],ws.words[2]);
		o.order_type = vo_;
	}
	if ((ws.word_num == 4) || (ws.word_num == 7))
	{
		for (a=0;a<4;a++) if (!strcmp(articlewords[a],ws.words[2])) b = a;
		if (b<20) o.articles[0] = b;
		else return 0;
		b = 20;
		for (a=0;a<4;a++) if (!strcmp(articlewords[a],ws.words[3])) return 0;
		for (a=0;a<15;a++) if (!strcmp(connectorwords[a],ws.words[3])) return 0;
		strcpy(o.object[0],ws.words[3]);
		for (a=0;a<15;a++) if (!strcmp(connectorwords[a],ws.words[1])) b = a;
		if (b<20) o.connectors[0] = b;
		else return 0;
		o.order_type = vco_;
	}
	if (ws.word_num > 5)
	{
		b = 20;
		for (a=0;a<15;a++) if (!strcmp(connectorwords[a],ws.words[ws.word_num-3])) b = a;
		if (b<20) o.connectors[1] = b;
		else return 0;
		for (a=0;a<4;a++) if (!strcmp(articlewords[a],ws.words[ws.word_num-2])) b = a;
		if (b<20) o.articles[1] = b;
		else return 0;
		for (a=0;a<4;a++) if (!strcmp(articlewords[a],ws.words[ws.word_num-1])) return 0;
		for (a=0;a<15;a++) if (!strcmp(connectorwords[a],ws.words[ws.word_num-1])) return 0;
		strcpy(o.object[1],ws.words[ws.word_num-1]);
		o.order_type += 2;
	}
	return 1;
}

int alphabet(const void * _key, const void * _elem)
{
	char * key = (char*)_key, * elem = (char*)_elem;
	while ((*key == *elem) && *elem)
	{
		key++;
		elem++;
	}
	return (*key - *elem);
}

verbtype::verbtype()
{
	for(unsigned a=0;a<20;a++)
	{
		name[a]=0;
		uses_type[a] = uses_conn[a][0] = uses_conn[a][1] = 0;
	}
	uses_num = 0;
}

int get_numorder(order o, numorder & no)
{
	int a, b;
	verbtype * v = (verbtype *)bsearch(o.verb, verbs, VerbsNum, sizeof(verbtype), &alphabet);
	if (strcmp(v->name, o.verb)) return 0;
	for(a=0 ;a<v->uses_num; a++)
	{
		if (v->uses_type[a] == o.order_type)
		{
			b = 1;
			if (((o.order_type == vco_) || (o.order_type == vcoco_)) && (o.connectors[0] != v->uses_conn[a][0]))
				b=0;
			if (((o.order_type == voco_) || (o.order_type == vcoco_)) && (o.connectors[1] != v->uses_conn[a][1]))
				b=0;
			if (b == 1) break;
		}
	}
	if (a == v->uses_num) return 0;
	char pl[2] = {0,0};
	char * obj[2] = {(char*)bsearch(o.object[0], objects_sing, ObjectsNum, 20, &alphabet), (char*)bsearch(o.object[1], objects_sing, ObjectsNum, 20, &alphabet)};
	for (b = 0;b<2;b++)
	{
		if (((b==0) && (o.order_type == v_)) || ((b==1) && ((o.order_type == vo_) || (o.order_type == vco_) || (o.order_type == v_))))
			break;
		if (strcmp(obj[b], o.object[b]))
		{
			obj[b] = (char*)bsearch(o.object[b], objects_plur, ObjectsNum, 20, &alphabet);
			pl[b] = 1;
			if (strcmp(obj[b],o.object[b]))
				return 0;
		}
	}
	no.verb = (v - &verbs[0]);
	no.use = a;
	for(a=0;a<2;a++)
	{
		if (((a==0) && (o.order_type == v_)) || ((a==1) && ((o.order_type == vo_) || (o.order_type == vco_) || (o.order_type == v_))))
		{
			no.object[a] = no.articles[a] = 0;
			continue;
		}
		if (pl[a]) {
			no.object[a] = (obj[a] - &objects_plur[0][0])/20;
			switch(o.articles[a])
			{
				case 2 : no.articles[a] = 2;break;
				case 3 : no.articles[a] = 3;break;
				default : return 0;
			}
		}
		else {
			no.object[a] = (obj[a] - &objects_sing[0][0])/20;;
			switch(o.articles[a])
			{
				case 0 :
					if ((o.object[a][0] == 'a') || (o.object[a][0] == 'e') || (o.object[a][0] == 'i') || (o.object[a][0] == 'o') || (o.object[a][0] == 'u'))
						return 0;
					no.articles[a] = 0; break;
				case 1 :
					if ((o.object[a][0] != 'a') && (o.object[a][0] != 'e') && (o.object[a][0] != 'i') && (o.object[a][0] != 'o') && (o.object[a][0] != 'u'))
						return 0;
					no.articles[a] = 0; break;
				case 3 :
					no.articles[a] = 1; break;
				default: return 0;
			}
		}
	}
	return 1;
}

unsigned str_bsearch(void * place, void * newo, unsigned number, unsigned length, unsigned str)
{
	unsigned low = 0, high = number, checked, a=0,b;
	while (high-low!=1)
	{
		checked = (high+low)/2; a = 0;
		while ((*((char*)place+length*checked+str+a)==*((char*)newo+str+a))&&(*((char*)place+length*checked+str+a)!=0))
			a++;
		if (*((char*)place+length*checked+str+a)>*((char*)newo+str+a))
			high = checked;
		else if (*((char*)place+length*checked+str+a)<*((char*)newo+str+a))
			low = checked;
		else return 65535;
	}
	if (high > 1) return high;
	else {
		while ((*((char*)place+str+a)==*((char*)newo+str+a))&&(*((char*)place+str+a)!=0))
			a++;
		if (*((char*)place+str+a)>*((char*)newo+str+a))
			return 0;
		else return 1;
	}
}

int addobject(char * sing, char * plur)
{
	char * place, memory[20], mem2[20];
	unsigned a,b;
	a = str_bsearch(objects_sing, sing, ObjectsNum, 20, 0);
	b =str_bsearch(objects_plur, plur, ObjectsNum, 20, 0);
	if (ObjectsNum == MaxObjectsNum) return 1;
	if (a == 65535) return 2;
	if (b==65535) return 3;
	place = &objects_sing[a][0];
	strcpy(memory,place);
	strcpy(place,sing);
	place+=20;
	while (place != (char*)&objects_sing[ObjectsNum]+20)
	{
		strcpy(mem2, place);
		strcpy(place, memory);
		strcpy(memory, mem2);
		place+=20;
	}
	place = &objects_plur[b][0];
	strcpy(memory,place);
	strcpy(place,plur);
	place+=20;
	while (place != (char*)&objects_plur[ObjectsNum]+20)
	{
		strcpy(mem2, place);
		strcpy(place, memory);
		strcpy(memory, mem2);
		place+=20;
	}
	ObjectsNum++;
	return 0;
}

int addverb(char * name)
{
	verbtype * place, memory, mem2,verb;
	unsigned a = str_bsearch(verbs, name, VerbsNum, 82, 0);
	if (VerbsNum == MaxVerbsNum) return 1;
	else if (a == 65535) return 2;
	strcpy(verb.name,name);
	verb.uses_num = 0;
	memory=*place;
	*place=verb;
	place++;
	while (place != &verbs[VerbsNum]+1)
	{
		mem2 = *place;
		*place = memory;
		memory = mem2;
		place++;
	}
	VerbsNum++;
	return 0;
}

int adduse(unsigned verb, unsigned type, unsigned con1, unsigned con2)
{
	if (verbs[verb].uses_num != 9)
	{
		verbs[verb].uses_type[verbs[verb].uses_num]=type;
		verbs[verb].uses_conn[verbs[verb].uses_num][0]=con1;
		verbs[verb].uses_conn[verbs[verb].uses_num][1]=con2;
		verbs[verb].uses_num++;
		return 0;
	}
	else return 1;
}

inline int adduse(char * verb, unsigned type, unsigned con1, unsigned con2)
{
	unsigned v = ((verbtype *)bsearch((void*)verb, verbs, VerbsNum, 82, &alphabet)-&verbs[0]);
	if (strcmp(verbs[v].name,verb)) return 2;
	return adduse(v,type,con1,con2);
}

int remobject(char * sing, char * plur)
{
	char * object1 = (char*)bsearch(sing, objects_sing, ObjectsNum, 20, &alphabet)+20;
	char * object2 = (char *)bsearch(plur,objects_plur, ObjectsNum, 20, &alphabet)+20;
	if (strcmp(object1,sing)) return 1;
	if (strcmp(object2,plur)) return 2;
	while (object1 != &objects_sing[ObjectsNum][0])
	{
		*(object1-20) = *object1;
		object1++;
	}
	for(int a = -1;a>=-20;a--)
		*(object1+a) = 0;
	while (object2 != &objects_plur[ObjectsNum][0])
	{
		*(object2-20) = *object2;
		object2++;
	}
	for(a = -1;a>-20;a--)
		*(object2+a) = 0;
	ObjectsNum--;
	return 0;
}

int remverb(char * verb_name)
{
	char * verb = (char*)bsearch(verb_name, verbs, VerbsNum, 82, &alphabet)+82;
	if (strcmp(verb_name,verb)) return 1;
	while (verb != &(verbs[VerbsNum].name[0]))
	{
		*(verb-82) = *verb;
		verb++;
	}
	for(int a = -1;a>=-82;a--)
		*(verb+a) = 0;
	VerbsNum--;
	return 0;
}

int remmean(unsigned verb, unsigned use)
{
	unsigned a;
	if (use<verbs[verb].uses_num)
	{
		if (use < 9)
		{
			for(a=use+1;a<10;a++)
			{
				verbs[verb].uses_type[a-1] = verbs[verb].uses_type[a];
				verbs[verb].uses_conn[a-1][0] = verbs[verb].uses_conn[a][0];
				verbs[verb].uses_conn[a-1][1] = verbs[verb].uses_conn[a][1];
			}
		}
		verbs[verb].uses_num--;
		return 0;
	}
	else return 1;
}

/*int main()
{
	strcpy(verbs[0].name,"look");verbs[0].uses_num=1;verbs[0].uses_type[0] = vco_;verbs[2].uses_conn[0][0] = 0;
	strcpy(verbs[1].name,"take");verbs[1].uses_num=1;verbs[1].uses_type[0] = vo_;
	strcpy(verbs[2].name,"talk");verbs[2].uses_num=2;verbs[2].uses_type[0] = vco_;verbs[2].uses_conn[0][0] = 13; verbs[2].uses_type[1] = vcoco_; verbs[2].uses_conn[1][0] = 13; verbs[2].uses_conn[1][0] = 0;
	strcpy(verbs[3].name,"use");verbs[3].uses_num=1;verbs[3].uses_type[0] = voco_;verbs[3].uses_conn[0][1] = 14;
	ObjectsNum = 7; VerbsNum = 4;
	word_s ws;
	order o;
	numorder no;
	unsigned a;
	char s[100]=";;;", s2[100];
	while (s[0] > 0)
	{
		gets(s);//gets(s2);
		remverb(s);
		for(a=0;a<VerbsNum;a++)
			cout << verbs[a].name << ", ";
		cout <<"\n";
	}
	return 0;
} */