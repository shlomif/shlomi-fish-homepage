#! /usr/bin/env python3
# -*- coding: utf-8 -*-
# vim:fenc=utf-8
#
# Copyright © 2020 Shlomi Fish <shlomif@cpan.org>
#
# SPDX-License-Identifier: Apache-2.0

# calc_dice_average.py - a program that calculates the average of a roll
# of dice in which a certain number of the minimal dice values are omitted.
#
# Part of the Math-Ventures article:
# "Combinatorics and the Art of Dungeons and Dragons".

"""

"""

from heapq import nlargest

import click

PosInt = click.IntRange(min=1)
@click.command()
@click.option('--sides', required=True, type=PosInt,
              help='The number of sides in each die')
@click.option('--num-dice', required=True, type=PosInt,
              help='The number of dice thrown')
@click.option('--num-removed', required=True, type=PosInt,
              help='The number of minimal dice removed')
def main(sides, num_dice, num_removed):
    total_sum = 0
    dice = [1 for _ in range(num_dice)]
    num_max_dice = num_dice - num_removed
    increment_ptr = 0
    while increment_ptr < num_dice:
        total_sum += sum(nlargest(num_max_dice, dice))
        increment_ptr = 0
        while increment_ptr < num_dice and dice[increment_ptr] == sides:
            dice[increment_ptr] = 1
            increment_ptr += 1
        if increment_ptr < num_dice:
            dice[increment_ptr] += 1
    total_count = sides ** num_dice
    print("Total sum = {}\nNum throws = {}\nAverage throw value = {}\n".format(
        total_sum, total_count, total_sum / total_count), end='')


if __name__ == '__main__':
    main()
