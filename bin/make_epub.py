#! /usr/bin/env python3
# -*- coding: utf-8 -*-
# vim:fenc=utf-8
#
# Copyright © 2020 Shlomi Fish <shlomif@cpan.org>
#
# Distributed under the MIT license.

from zipfile import ZIP_DEFLATED

import click

from rebookmaker import EbookMaker


@click.command()
@click.option("--output", help='the output EPub path')
@click.argument("jsonfn")
def main(output, jsonfn):
    EbookMaker(compression=ZIP_DEFLATED).make_epub(jsonfn, output)


if __name__ == '__main__':
    main()
