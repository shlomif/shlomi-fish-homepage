Follow the following steps to build the homesite:

1. Install Mercurial - http://mercurial.selenic.com/ .

2. Install git - http://git-scm.com/ .

3. Install perl 5.16.x (or later) in case it's not already installed. You
should have a package for for your system.

4. Install Website Meta Language (version 2.0.12 or later):

https://bitbucket.org/shlomif/website-meta-language/downloads

5. Run and configure CPAN (see - http://perl-begin.org/topics/cpan/ )
and type:

```bash
export PERL_MM_USE_DEFAULT=1
perl -MCPAN -e 'install Task::Sites::ShlomiFish'
```

```bash
export PERL_MM_USE_DEFAULT=1
perl -MCPANPLUS -e 'install Task::Sites::ShlomiFish'
```

6. Install Latemp:

See http://web-cpan.shlomifish.org/latemp/ and https://github.com/thewml/latemp .

7. Add Latemp to the beginning of your path:

```bash
PATH="$HOME/apps/latemp/bin:$PATH"
```

8. Install the latest version of Quad-Pres from:

See http://www.shlomifish.org/quad-pres/ and
https://github.com/shlomif/quad-pres

```bash
git clone https://github.com/shlomif/quad-pres
cd quad-pres/installer
```

See its INSTALL file. Put a working `quadp` executable in your shell's PATH.

9. Install the wml-affiliations.

```bash
git clone https://github.com/shlomif/wml-affiliations trunk
cd trunk/wml
bash Install.bash
```

10. Install the wml-extended-apis:

```bash
git clone https://github.com/thewml/wml-extended-apis trunk
cd trunk/xhtml/1.x/
bash Install.bash
```

11. Install [inkscape](http://inkscape.org/) and put its executable in
the path.

12. Install jing and put it in the path:

http://www.thaiopensource.com/relaxng/jing.html

13. Install Apache FOP and put it in the path:

http://xmlgraphics.apache.org/fop/

14. Install [optipng](http://optipng.sourceforge.net/) and put it in the path

15. Put the XHTML 1.1 DTDs , the XHTML 1.0 DTDs , etc. in your
`XML_CATALOG_FILES` environment variable.

An easy way to do that is to do:

```bash
git clone https://github.com/w3c/markup-validator.git
```

And set `XML_CATALOG_FILES` to "/etc/xml/catalog $(pwd)/markup-validator/htdocs/sgml-lib/catalog.xml"

16. Do the following to build the site, after all dependencies were installed:

```bash
git clone https://github.com/shlomif/shlomi-fish-homepage.git trunk
cd trunk
./gen-helpers.pl
make
```
