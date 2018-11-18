set -e -x
git clean -dxf lib/presentations/spork/
./gen-helpers
make
rm -fr d
touch t2/humour/index.xhtml.wml
make test
cp -a dest/post-incs/t2/lecture/Perl/Lightning d
fd \\.html ./d | xargs rename .html .xhtml
java -jar /home/shlomif/Download/unpack/net/www/validator/build/dist/vnu.jar --format json --Werror --skip-non-html d 2>&1 | json_pp - | gvim -
