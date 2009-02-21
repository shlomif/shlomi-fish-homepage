cur_dir="$(pwd)"

filename="$1"
shift

(
    perl \
    -MXML::Grammar::Fortune \
    -e 'exit(XML::Grammar::Fortune->new(
        {mode => "validate"})->run({input => shift(@ARGV)}));' \
       "$cur_dir/$filename"
)

