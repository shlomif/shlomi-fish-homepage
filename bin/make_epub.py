#! /usr/bin/env python3
# -*- coding: utf-8 -*-
# vim:fenc=utf-8
#
# Copyright © 2020 Shlomi Fish <shlomif@cpan.org>
#
# Distributed under the MIT license.

import click

from rebookmaker import EbookMaker


@click.command()
@click.option("--output", help='the output EPub path')
@click.argument("jsonfn")
def main(output, jsonfn):
    EbookMaker().make_epub(jsonfn, output)


if __name__ == '__main__':
    main()
