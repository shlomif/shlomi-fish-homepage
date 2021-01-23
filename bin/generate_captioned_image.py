#! /usr/bin/env python3
# -*- coding: utf-8 -*-
# vim:fenc=utf-8
#
# Copyright © 2020 Shlomi Fish < https://www.shlomifish.org/ >
#
# Licensed under the terms of the MIT license.
"""
Source filter (or C pre-processor) for removing the max_num_played feature
from black-hole-solver's C code.
"""

import argparse
import os
import re
import shutil
import subprocess
import sys
from pathlib import Path


def _newlinify(text, match_object):
    start = text.rindex("\n", 0, match_object.start(0)+1)
    end = text.index("\n", match_object.end(0)-1, -1)
    prefix = text[0:start] + "".join(x for x in text[start:end] if x == '\n')
    return (prefix, text[end:])


def _remove(text, pat):
    match_object = re.search(pat, text, flags=(re.M | re.S))
    assert match_object
    return _newlinify(text, match_object)


def _multi_remove(text, patterns_list):
    ret = []
    remaining_text = text
    for pat in patterns_list:
        prefix, remaining_text = _remove(remaining_text, pat)
        ret.append(prefix)
    ret.append(remaining_text)
    return "".join(ret)


def _process_black_hole_solver_h(text):
    """process include/black-hole-solver/black_hole_solver.h"""
    return _multi_remove(
        text,
        [
            "^// Added.*?DLLEXPORT extern unsigned " +
            "long black_hole_solver_get_max_num_played_cards" +
            "\\(.*?(?:\\n){2,2}",
        ]
    )


def _clear_all_individual_lines(text, pat):
    return re.sub(
        '^[^\\n]*?(?:'+pat+')[^\\n]*?$', '', text, flags=(re.M | re.S)
    )


def _process_lib_c(text):
    """process lib.c"""
    out_text = _multi_remove(
        text,
        [
         "^ *var_AUTO\\(\\s*max_reached_depths_stack_len.*?\\);$",
         "^ *while \\(current_depths_stack_len.*?^ *\\}$",
         "^( *)if \\(was_moved\\).*?^\\1\\}$",
         ("^DLLEXPORT extern[^\n]+\n" +
             "black_hole_solver_get_max_num_played_cards.*?^\\}"),
        ]
    )
    return _clear_all_individual_lines(
        out_text, "(?:depths_stack|max_num_played|prev_len|was_moved)"
    )


def _process_solver_common_h(text):
    """process solver_common.h"""
    out_text = _multi_remove(
        text,
        [
         ("^ *else if \\(unlikely\\(" +
          "\n[^\\n]*\"--show-max-num-played-cards\".*?^ *\\}$"),
         ("^ *if \\(unlikely\\(settings\\." +
          "show_max_num_played_cards.*?^ *\\}$"),
        ]
    )
    return _clear_all_individual_lines(out_text, "max_num_played")


class SourceFilter:
    """docstring for SourceFilter:"""
    def __init__(self, should_process, target, exe_path):
        self.exe_path = exe_path
        self.should_process = should_process
        self.target = Path(target)

    def _git_add(self, basenames):
        subprocess.check_call(
            [
                "/bin/sh",
                "-exc",
                "cd {} && git add {}".format(self.target, ' '.join(basenames))
            ]
        )

    def process_file_or_copy(self, basename, callback):
        """optionally filter the file in 'basename' using 'callback'"""
        src_fn = Path(self.exe_path).parent.parent / basename
        dest_fn = Path(".") / "generated" / basename

        dest_parent = dest_fn.parent
        if not dest_parent.exists():
            dest_parent.mkdir(parents=True)
        with open(dest_fn, "wt") as ofh:
            with open(src_fn, "rt") as ifh:
                text = ifh.read()
                ofh.write(callback(text) if self.should_process else text)

    def move_and_process(self, src_bn, dest_bn, callback):
        """optionally filter the file in 'basename' using 'callback'"""
        src_fn = self.target / src_bn
        dest_fn = self.target / dest_bn

        dest_parent = dest_fn.parent
        if not dest_parent.exists():
            dest_parent.mkdir(parents=True)
        with open(dest_fn, "wt") as ofh:
            with open(src_fn, "rt") as ifh:
                text = ifh.read()
                ofh.write(callback(text) if self.should_process else text)
        self._git_add([dest_bn])
        os.unlink(src_fn)

    def run(self):
        """docstring for run"""
        shutil.copytree(
            "captioned-image--emma-watson-doesnt-need-a-wand",
            self.target)
        shutil.rmtree(Path(self.target) / ".git")
        subprocess.check_call(
            ["/bin/sh", "-exc", "cd {} && git init .".format(self.target)]
        )

        bn = "Arnold_Schwarzenegger_by_Gage_Skidmore_4.jpg"
        shutil.copyfile(Path(os.getenv("HOME")) / bn, self.target / bn)

        def svg_cb(text):
            return text
        orig_svg_bn = "emma-watson-wandless.svg"
        renamed_svg_bn = "gotta-be-a-badass-to-play-one.svg"
        self.move_and_process(
                src_bn=orig_svg_bn,
                dest_bn=renamed_svg_bn,
                callback=svg_cb,
        )

        self._git_add([bn])
        return

        self.process_file_or_copy(
            "solver_common.h",
            _process_solver_common_h
        )

        self.process_file_or_copy(
            "lib.c",
            _process_lib_c
        )


def main():
    """main function"""
    parser = argparse.ArgumentParser()
    parser.add_argument(
        '--process', action='store', dest='process_mode',
        help='The processing mode',
        required=True
    )
    results = parser.parse_args()

    arg = results.process_mode
    if arg == 'no_max_num_played':
        should_process = True
    elif arg == 'none':
        should_process = False
    else:
        raise Exception("wrong invocation")

    SourceFilter(
        exe_path=sys.argv[0],
        should_process=should_process,
        target="Captioned-Image-Badass-Schwarzenegger",
    ).run()


main()
