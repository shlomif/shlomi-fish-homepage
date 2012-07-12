/*
   calc_dice_average.c - a program that calculates the average of a roll
   of dice in which a certain number of the minimal dice values are omitted.

   Programmed by Shlomi Fish, 1997
   Part of Math-Ventures' article: "Combinatorics and the Art of Dungeons
   and Dragons".
*/

#include <stdlib.h>
#include <stdio.h>
#include <math.h>

#define MAX_DICE 100

/* A function that compares two integers. Used by qsort() */

int int_compare(const void * a, const void * b)
{
	if (*(const int *)a > *(const int *)b)
		return 1;
	else if (*(const int *)a < *(const int *)b)
		return -1;
	else
		return 0;
}

int main()
{
	int a, b;
	unsigned dice[MAX_DICE];
	unsigned sorted_dice[MAX_DICE];

	unsigned num_dice, max_die_value, dice_to_remove;

	unsigned long grand_total;

	/* Input the values of the parameters */
	printf("Please enter the number of sides that every die has:\n");
	scanf("%u", &max_die_value);
	printf("Please enter the number of dice that are thrown:\n");
	scanf("%u", &num_dice);
	printf("Please enter the number of dice with minimal values"
	" to be removed from a throw total:\n");
	scanf("%u", &dice_to_remove);

	/* Some verifications */
	if (num_dice > MAX_DICE)
	{
		fprintf(stderr, "Sorry, but the number of dice cannot exceed %u!\n", MAX_DICE);
		return -1;
	}

	if (dice_to_remove > num_dice)
	{
		fprintf(stderr, "Sorry, but the number of dice to remove cannot be greater that the number of dice thrown!\n");
		return -1;
	}

	/* Initiliaze the dice to the first permutation */
	for(a=0;a<num_dice;a++)
		dice[a] = 1;

	/*
		Okay, this program uses a pseudo-recursion algorithm to iterate
		over all the possible throws. The basic idea is that every throw
		is represented by an array, where every member designates one
		die.

		At the end of every iteration we increment the first die by one,
		switching it to its next possible state. If it is already equal to
		num_dice however we reset it to one, and increment the next_die
		instead, and so on. This process is analogous to incrementing a
		number written in a digital form by 1.

		The process stops after the iteration in which all the dice are
		equal to num_dice. Implementing the loop with real recursion would
		have been much more time and memory consuming, because of the
		frequent function calls and exits.
	*/

	grand_total = 0;
	do
	{
		/* Copy the values of the dice in this permutation to
		   a separate array that will be used for sorting. */
		for(a=0 ; a < num_dice ; a++)
			sorted_dice[a] = dice[a];

		/* Sort them */
		qsort(sorted_dice, num_dice, sizeof(dice[0]), int_compare);

		/* Add the values of the maximal dice to the grand total */
		for(a = dice_to_remove ; a < num_dice ; a++)
			grand_total += sorted_dice[a];

		/* Move on to the next permutation */
		for(a=0 ; (dice[a] == max_die_value) && (a < num_dice) ; a++)
			dice[a] = 1;
		if (a < num_dice)
			dice[a]++;
		/* If a == num_dice it means we have just finished the
		   last permutation, so it's time to terminate the loop */
	} while (a < num_dice );

	printf ("The average throw value is %lf.\n",
		(double)(grand_total / pow(max_die_value, num_dice)) );

	return 0;
}

