cur_dir="$(pwd)"

filename="$1"
shift

(
    perl \
    -MXML::Grammar::Fortune \
    -e 'XML::Grammar::Fortune->new(
    {mode => "validate"})->run({input => shift(@ARGV)});exit(0);' \
       "$cur_dir/$filename"
)

