/*
   check_codes.c

   This program calculates the number of possible binary codes of
   length n, so that if the code is broadcasted continously, it can
   be verified without knowing where it's start is.

   I.e: 0100 is essentially the same as 0010 because when broadcasted
   they both become: 0100010001000100010001000... and cannot
   be distinguished.

*/

#include <stdio.h>

/* A typedef for an integer that can hold a whole code. */
typedef unsigned long Mytype;

/*
   This function calculates the number of codes for a given number
   by enumerating all possible codes and counting them.
*/

Mytype stupid_get_num_codes (int number)
{
   Mytype code, perm, num_codes, max_code;
   int shift;

   num_codes = 0;
   max_code = 1 << number;
   for (code = 0; code < max_code; code++)
   {
      /* The code is counted only if none of its permutations was
         already taken into account */
      perm = code;
      for (shift = 0; shift < number - 1; shift++)
      {
         perm = ((perm & 1) << (number - 1)) + (perm >> 1);
         if (perm < code) /* If the permutation is lower then */
         	break;        /* it was already scanned by this loop. */
      }
      if (shift == number - 1)
      {
	      num_codes++;
      }
   }

   return num_codes;
}

#define T(n) ((1<<(n)) - 2)

Mytype unique_codes(int number)
{
   int div;
   Mytype codes_num;

   if (number == 1)
   	return 2;
   codes_num = T(number);
   for(div=2;div<number;div++)
   {
      if (number % div == 0)
      	codes_num -= unique_codes(div);
   }
   return codes_num;
}

Mytype get_num_codes(int number)
{
   int div;
   Mytype codes_num;

   codes_num = 0;
   for(div=1;div<=number;div++)
   {
      if (number % div == 0)
      {
         codes_num += (unique_codes(div)/div);
      }
   }
   return codes_num;
}

int main (int argc, char * argv[])
{
  int num;
  Mytype perms_number1, perms_number2;

  for (num=1 ; num<=24; num++)
  {
     perms_number1 = stupid_get_num_codes(num);
     perms_number2 = get_num_codes(num);
     printf("%i: # of codes = %li, %li\n", num, perms_number1, perms_number2);
  }

  return 0;
}
