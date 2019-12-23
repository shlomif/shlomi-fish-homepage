Follow the following steps to build the homesite:

1. Install git - http://git-scm.com/ .

2. Install perl 5.16.x (or later) in case it's not already installed. You
should have a package for it for your system.

3. Install Website Meta Language (version 2.24.0 or later):

https://github.com/thewml/website-meta-language/releases

4. Run and configure CPAN (see - https://perl-begin.org/topics/cpan/ )
and type:

```bash
export PERL_MM_USE_DEFAULT=1
perl -MCPAN -e 'install App::Deps::Verify Task::Sites::ShlomiFish'
```

```bash
export PERL_MM_USE_DEFAULT=1
perl -MCPANPLUS -e 'install App::Deps::Verify Task::Sites::ShlomiFish'
```

5. Install Latemp:

See https://web-cpan.shlomifish.org/latemp/ and https://github.com/thewml/latemp .

6. Add Latemp to the beginning of your path:

```bash
PATH="$HOME/apps/latemp/bin:$PATH"
```

7. Install the latest version of Quad-Pres from:

See https://www.shlomifish.org/quad-pres/ and
https://github.com/shlomif/quad-pres

```bash
git clone https://github.com/shlomif/quad-pres
cd quad-pres/installer
```

See its INSTALL file. Put a working `quadp` executable in your shell's PATH.

8. Install the wml-affiliations.

```bash
git clone https://github.com/shlomif/wml-affiliations trunk
cd trunk/wml
bash Install.bash
```

9. Install the wml-extended-apis:

```bash
git clone https://github.com/thewml/wml-extended-apis trunk
cd trunk/xhtml/1.x/
bash Install.bash
```

10. Install [inkscape](https://inkscape.org/) and put its executable in
the path.

11. Install jing and put it in the path:

http://www.thaiopensource.com/relaxng/jing.html

12. Install Apache FOP and put it in the path:

http://xmlgraphics.apache.org/fop/

13. Install [optipng](http://optipng.sourceforge.net/) and put it in the path

14. Put the XHTML 1.1 DTDs , the XHTML 1.0 DTDs , etc. in your
`XML_CATALOG_FILES` environment variable.

An easy way to do that is to do:

```bash
git clone https://github.com/w3c/markup-validator.git
```

And set `XML_CATALOG_FILES` to "/etc/xml/catalog $(pwd)/markup-validator/htdocs/sgml-lib/catalog.xml"

15. Do the following to build the site, after all dependencies were installed:

```bash
git clone https://github.com/shlomif/shlomi-fish-homepage.git trunk
cd trunk
./gen-helpers
gmake
gmake docbook_extended
gmake test
```

The site should be in `dest/post-incs/t2/` .
