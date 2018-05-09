#! /bin/sh
#
# t.sh
# Copyright (C) 2018 shlomif <shlomif@cpan.org>
#
# Distributed under terms of the MIT license.
#

perl bin/gen-rpm-for-build-deps -o f.spec
rpmbuild -ba f.spec
sudo urpmi --auto --keep --resume --noclean --no-recommends --downloader wget --wget-options -c /home/shlomif/progs/Rpms/RPMS/noarch/task-shlomif-homesite-0.0.1-1.mga7.noarch.rpm
