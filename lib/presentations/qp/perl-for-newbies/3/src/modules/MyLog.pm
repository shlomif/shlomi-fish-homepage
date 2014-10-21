# File : MyLog.pm
#

package MyLog;

use strict;
use warnings;

BEGIN
{
    open MYLOG, ">", "mylog.txt";
}

sub log
{
    my $what = shift;

    # Strip the string of newline characters
    $what =~ s/\n//g;

    # The MYLOG filehandle is already open by virtue of the BEGIN
    # block.
    print MYLOG $what, "\n";
}

END
{
    close(MYLOG);
}

1;

