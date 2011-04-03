package Shlomif::Homepage::Amazon;

use Moose;

use Term::ReadPassword;

has 'wml_dir' => (isa => 'Str', is => 'ro');
has 'ps' => (isa => 'XML::Grammar::ProductsSyndication', is => 'ro');

sub process
{
    my ($self) = @_;

    $self->ps->update_cover_images(
        {
            'size' => "l",
            'resize_to' => { 'width' => 150, 'height' => 250 },
            'name_cb' =>
            sub
            {
                my $args = shift;
                return $self->wml_dir() . "/images/$args->{id}.jpg";
            },
            'amazon_token' => "0VRRHTFJECHSKYNYD282",
            'amazon_associate' => "shlomifishhom-20",
            'amazon_sak' => read_password('Secret Access Key: '),
        }
    );

    return;
}

1;
