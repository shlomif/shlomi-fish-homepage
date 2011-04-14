=begin removed

BEGIN
{
    if (hostname() =~ m{heptagon})
    {
        eval <<'EOF';
use lib "/home/shlomifish/apps/perl5/lib/perl5";

use local::lib  "/home/shlomifish/apps/perl5/lib/perl5";
EOF
    }
}

=end removed

=cut

