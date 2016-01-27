package HTML::Spelling::Site::Finder;

use strict;
use warnings;

use MooX (qw( late ));

use File::Find::Object;

has 'prune_cb' => (is => 'ro', isa => 'CodeRef', default => sub { return; });
has 'root_dir' => (is => 'ro', isa => 'Str', 'required' => 1,);

sub list_all_htmls
{
    my ($self) = @_;

    my $f = File::Find::Object->new({}, $self->root_dir);

    my @got;
    while (my $r = $f->next_obj())
    {
        my $path = $r->path;
        if ($self->prune_cb->($path))
        {
            $f->prune;
        }
        elsif ($r->is_file and $r->basename =~ /\.x?html\z/)
        {
            push @got, $path;
        }
    }
    use locale;
    use POSIX qw(locale_h strtod);
    setlocale(LC_COLLATE, 'C') or die "cannot set locale.";

    return [sort @got];
}

1;
