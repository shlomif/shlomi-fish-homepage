a="$(pwd)" 
(
    cd $HOME/progs/perl/cpan/XML/Grammar/Fortune/trunk/XML-Grammar-Fortune/module ;
    ~/apps/perl/perl-5.8.8-debug/bin/perl \
    -Mblib -MXML::Grammar::Fortune \
    -e 'XML::Grammar::Fortune->new(
        {mode => "validate", input => shift(@ARGV)})->run();
       ' \
    "$a/shlomif.xml"
)

