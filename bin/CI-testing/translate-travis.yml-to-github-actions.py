#! /usr/bin/env python3
# -*- coding: utf-8 -*-
# vim:fenc=utf-8
#
# Copyright © 2021 Shlomi Fish < https://www.shlomifish.org/ >
#
# Licensed under the terms of the MIT license.

"""
bin/CI-testing/translate-travis.yml-to-github-actions.py :

(based on https://is.gd/G1N1oD .)

This program translates fc-solve's .travis.yml to GitHub actions
and ACT workflows ( https://github.com/nektos/act ).

While ostensibly FOSS, it most probably is not generic enough
for your use cases.

"""

import re
import subprocess

import yaml


def _add_condition_while_excluding_gh_actions(job_dict, is_act):
    """
    See:

    https://github.com/actions/runner/issues/480

    Workflow level `env` does not work properly in all fields. · Issue #480

    """
    if is_act:
        job_dict['if'] = \
            "${{ ! contains(env.ACT_SKIP, matrix.env.WHAT) }}"


def generate(output_path, is_act):
    """docstring for main"""
    env_keys = set()

    def _process_env(env):
        ret = {}
        for line in env:
            m = re.match(
                '\\A([A-Za-z0-9_]+)=([A-Za-z0-9_]+)\\Z',
                line)
            key = m.group(1)
            val = m.group(2)
            assert key not in ret
            ret[key] = val
            env_keys.add(key)
        return ret
    with open("./.travis.yml", "rt") as infh:
        data = yaml.safe_load(infh)
    steps = []
    steps.append({"uses": ("actions/checkout@v2"), })
    if 0:
        steps.append({
            "run":
            ("cd workflow ; (ls -lrtA ; false)"), })
    elif 0:
        steps.append({
            "run":
            ("cd . ; (ls -lrtA ; false)"), })
    steps.append({"run": ("sudo apt-get update -qq"), })
    steps.append({
        "run": ("sudo apt-get --no-install-recommends install -y " +
                " ".join(["eatmydata"])
                ),
        }
    )
    pkgs = sorted(
        data['addons']['apt']['packages'] +
        [
            "golang", "libxslt1-dev", "nodejs", "npm",
            "rsync", "ruby", "ruby-dev", "vim",
        ]
    )
    # print(pkgs)
    steps.append({
        "run": ("sudo eatmydata apt-get --no-install-recommends install -y " +
                " ".join(pkgs)
                ),
        }
    )
    local_lib_shim = 'local_lib_shim() { eval "$(perl ' + \
        '-Mlocal::lib=$HOME/' + \
        'perl_modules)"; PATH="$PATH:$GOBIN:$GOPATH/bin:$HOME/go/bin"; } ' + \
        '; local_lib_shim ; '
    local_lib_shim = '. bin/CI-testing/common-env-shim.sh ; '

    def gen_steps(arr):
        steps = []
        for command in data[arr]:
            if command == 'systemctl --user start dbus' or \
                    command.startswith('export DBUS_'):
                continue
            command = re.sub(
                "\\.travis\\.bash",
                ".ci-github-actions.bash",
                command
            )
            steps.append({"run": local_lib_shim + command})
        return steps
    steps += gen_steps('before_install')
    steps += gen_steps('install')
    for s in gen_steps('script'):
        steps.append({
            'name': 'xvfb-headless tests',
            'uses': 'GabrielBB/xvfb-action@v1',
            'with': s,
        })
    job = 'test-fc-solve'
    o = {'jobs': {job: {'runs-on': 'ubuntu-latest',
         'steps': steps, }},
         'name': 'use-github-actions', 'on': ['push', ], }
    if 'matrix' in data:
        if 'include' in data['matrix']:
            o['jobs'][job]['strategy'] = {'matrix': {'include': [
                {'env': _process_env(x['env']), }
                for x in data['matrix']['include']
            ], }, }
            o['jobs'][job]['env'] = {
                x: "${{ matrix.env." + x + " }}"
                for x in env_keys
            }
            _add_condition_while_excluding_gh_actions(
                job_dict=o['jobs'][job],
                is_act=is_act,
            )
        else:
            assert False
    with open(output_path, "wt") as outfh:
        # yaml.safe_dump(o, outfh)
        yaml.safe_dump(o, stream=outfh, canonical=False, indent=4, )


def generate_windows_yaml(plat, output_path, is_act):
    """docstring for main"""
    env_keys = set()

    def _process_env(env):
        ret = {}
        for line in env:
            m = re.match(
                '\\A([A-Za-z0-9_]+)=([A-Za-z0-9_]+)\\Z',
                line)
            key = m.group(1)
            val = m.group(2)
            assert key not in ret
            ret[key] = val
            env_keys.add(key)
        return ret
    with open("./.appveyor.yml", "rt") as infh:
        data = yaml.safe_load(infh)
    with open("./fc-solve/CI-testing/gh-actions--" +
              "windows-yml--from-p5-UV.yml", "rt") as infh:
        skel = yaml.safe_load(infh)
    steps = skel['jobs']['perl']['steps']
    while steps[-1]['name'] != 'perl -V':
        steps.pop()

    cpanm_step = {
        "name": "install cpanm and mult modules",
        "uses": "perl-actions/install-with-cpanm@v1",
    }
    steps.append(cpanm_step)
    # if True:  # plat == 'x86':
    if plat == 'x86':
        mingw = {
            "name": "Set up MinGW",
            "uses": "egor-tensin/setup-mingw@v2",
            "with": {
                "platform": plat,
            },
        }
        steps.append(mingw)

    def _calc_batch_code(cmds):
        batch = ""
        batch += "@echo on\n"
        for k, v in sorted(data['environment'].items()):
            # batch += "SET " + k + "=\"" + v + "\"\n"
            batch += "SET " + k + "=" + v + "\n"
        if plat == 'x86':
            start = 'mkdir pkg-build-win64'
            end = "^cpack -G WIX"
        else:
            start = 'mkdir pkg-build'
            end = "^7z a"
        start_idx = [
            i for i, cmd in enumerate(cmds)
            if cmd == "cd .." and
            cmds[i+1] == start
        ][0]
        end_idx = start_idx + 1
        while not re.search(end, cmds[end_idx]):
            end_idx += 1
        cmds = cmds[:start_idx] + cmds[(end_idx+1):]
        if plat == 'x86':
            idx = len(cmds) - 1
            while cmds[idx] != 'cd ..':
                idx -= 1
            cmds.insert(idx, "SET CXX=c++")
            cmds.insert(idx, "SET CC=cc")

        for cmd in cmds:
            if cmd.startswith("cpanm "):
                words = cmd.split(' ')[1:]
                dw = []
                for w in words:
                    if not w.startswith("-"):
                        dw.append(w)
                nonlocal cpanm_step
                cpanm_step['with'] = {"install": "\n".join(dw), }
                continue
            if re.search("copy.*?python\\.exe", cmd):
                continue
            if "choco install strawberryperl" not in cmd:
                if 0:
                    r = re.sub(
                        "curl\\s+-o\\s+(\\S+)\\s+(\\S+)",
                        "lwp-download \\2 \\1",
                        cmd)
                elif plat == 'x86':
                    if cmd.startswith("perl ../source/run-tests.pl"):
                        continue
                    r = re.sub(
                        "--dbm=kaztree",
                        "--dbm=none",
                        cmd
                    )
                else:
                    r = cmd
                # See:
                # https://serverfault.com/questions/157173
                shim = ''
                if not (r.lower().startswith("set ")):
                    shim = " || ( echo Failed & exit /B 1 )"
                batch += r + shim + "\n"
        return batch

    if 0:
        steps.append({'name': "install code", "run": _calc_batch_code(
            cmds=data['install']), "shell": "cmd", })
    steps.append({
        'name': "install and test_script code",
        "run": _calc_batch_code(
            cmds=(data['install']+data['test_script'])
        ),
        "shell": "cmd",
    })

    def _myfilt(path):
        is32 = ("\\pkg-build\\" in path)
        return (is32 if plat == 'x86' else (not is32))
    steps += [{
        'name': "upload build artifacts - " + art['name'],
        'uses': "actions/upload-artifact@v2",
        'with': art
    } for art in data['artifacts'] if _myfilt(art['path'])]
    skel['name'] = ("windows-x86" if plat == 'x86' else 'windows-x64')
    skel['on'] = ['push']
    with open(output_path, "wt") as outfh:
        # yaml.safe_dump(o, outfh)
        outfh.write(
            "# This file is GENERATED BY\n" +
            "# fc-solve/CI-testing/" +
            "translate-travis.yml-to-github-actions.py\n")
        yaml.safe_dump(skel, stream=outfh, canonical=False, indent=4, )


def main():
    generate(
        output_path=".github/workflows/use-github-actions.yml",
        is_act=False,
    )
    generate(
        output_path=".act-github/workflows/use-github-actions.yml",
        is_act=True,
    )
    subprocess.check_call(
            [
                "bash", "-ce",
                "perl -lpE 's/^( *)gem/$1sudo gem/;$_=q#    (set -e -x;" +
                " mkdir -p $HOME/src ; cd $HOME/src ; " +
                "git clone https://github.com/tdewolff/minify.git " +
                "; cd minify ; make SHELL=/bin/bash install ; cd .. ; " +
                "rm -fr minify ; which minify ; )#" +
                " if /^ *go get.*minify/'" +
                " < .travis.bash > " +
                ".ci-github-actions.bash"
            ])
    if False:
        generate_windows_yaml(
            plat='x86',
            output_path=".github/workflows/windows-x86.yml",
            is_act=False,
        )
        generate_windows_yaml(
            plat='x64',
            output_path=".github/workflows/windows-x64.yml",
            is_act=False,
        )


if __name__ == "__main__":
    main()
