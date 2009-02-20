cur_dir="$(pwd)" 
filename="$1"
shift
(
    cd $HOME/progs/perl/cpan/XML/Grammar/Fortune/trunk/XML-Grammar-Fortune/module ;
    ~/apps/perl/perl-5.8.8-debug/bin/perl \
    -Mblib -MXML::Grammar::Fortune \
    -e 'exit(XML::Grammar::Fortune->new(
        {mode => "validate", input => shift(@ARGV)})->run());'
       ' \
       "$cur_dir/$filename"
)

