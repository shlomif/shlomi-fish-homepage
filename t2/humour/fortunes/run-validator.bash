cur_dir="$(pwd)"

filename="$1"
shift

(
    ~/apps/perl/perl-5.8.x-latest/bin/perl \
    -MXML::Grammar::Fortune \
    -e 'exit(XML::Grammar::Fortune->new(
        {mode => "validate"})->run({input => shift(@ARGV)}));' \
       "$cur_dir/$filename"
)

