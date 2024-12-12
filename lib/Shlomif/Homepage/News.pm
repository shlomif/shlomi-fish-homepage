package Shlomif::Homepage::News;

use strict;
use warnings;
use utf8;

use Carp       ();
use MooX       qw( late );
use DateTime   ();
use Path::Tiny qw( path );

has 'dir' => (
    is       => 'ro',
    isa      => 'Str',
    required => 1,
);

has 'num_on_front' => ( is => 'ro', isa => 'Int', default => sub { 7; } );

has 'items' => (
    is      => 'ro',
    isa     => 'ArrayRef',
    default => sub {
        return shift->calc_items();
    },
);

my @old_news_items = (
    {
        'date' => DateTime->new( year => 2005, month => 3, day => 22 ),
        'body' => <<"EOF",
<p class="newsitem">
I added a <a href="links.html#pictures">section to my links collection with
links to my favourite collections of pictures and wallpapers</a>. Otherwise,
I now <a href="http://www.livejournal.com/users/shlomif/">cross-post my
weblog</a> in
<a href="http://www.livejournal.com/">LiveJournal.com</a> and you can use
its commenting system to post comments to its entries.
</p>

<p class="newsitem">
<a href="http://jmikmod.shlomifish.org/">MikMod for Java has moved to a new
homepage</a> at Berlios where I hope other people would be able to
contribute to it more efficiently than before.
<a href="http://www.shlomifish.org/gimp-test/">The Gimp Automated Testing
Framework</a> is a new project of mine. Check it out if you’re interested.
</p>
EOF
    },
    {
        'date' => DateTime->new( year => 2005, month => 5, day => 19 ),
        'body' => <<"EOF",
<p class="newsitem">
The full but incomplete text of <a href="humour/human-hacking/"><i>The Human
Hacking Field Guide</i></a> is now available online for your reading pleasure.
</p>
EOF
    },
    {
        'date' => DateTime->new( year => 2005, month => 5, day => 22 ),
        'body' => <<"EOF",
<p class="newsitem">
I now have <a href="./me/personal-ad.html">a personal ad</a>. I’m
looking for a girlfriend who lives in Central Israel.
</p>
EOF
    },
    {
        'date' => DateTime->new( year => 2005, month => 6, day => 26 ),
        'body' => <<"EOF",
<p class="newsitem">
Several new additions were added to the site. The <a href="./art/">art
section</a> now contains two new pieces. I also added
<a href="./open-source/bits.html#old_pmwiki_revert">a new script</a>
to the Open Source Bits and Bobs section. Several new programs were
added to <a href="./open-source/favourite/">my favourite
free software</a>. Some new languages were added to
<a href="./humour/ways_to_do_it.html">the “Ways to do it” according
to the programming languages of the World</a> page.
</p>

<p class="newsitem">
Some of my newer projects are now mentioned in my resumés. I added
a link to <a href="./lecture/LAMP/slides/">a presentation about Web
Publishing using LAMP</a>. Finally,
<a href="./philosophy/obj-oss/">the Objectivism and Open Source</a>
essay was expanded with two new chapters.
</p>
EOF
    },
    {
        'date' => DateTime->new( year => 2005, month => 10, day => 5 ),
        'body' => <<"EOF",
<p class="newsitem">
Added <a href="./philosophy/computers/when-c-is-best/">the “When C is the
Best” essay</a>. Also now that the software patents threat in Europe has
been eliminated, I have removed the notice box, and replaced my top-left
icon with <a href="./images/shlomif-homepage-logo.png">a personal
logo</a> based on <a href="http://ars.userfriendly.org/cartoons/?id=20030803&amp;mode=classic">EvilPHish
from UserFriendly</a>.
</p>

<p class="newsitem">
Finally, several fortunes were added to
<a href="http://www.shlomifish.org/humour/fortunes/">the fortune
cookies collection</a> and it now also contains a collection of quotes by
<a href="http://www.paulgraham.com/">Paul Graham</a>.
</p>

EOF
    },
    {
        'date' => DateTime->new( year => 2005, month => 10, day => 15 ),
        'body' => <<"EOF",
<p class="newsitem">
The past few days have seen the move to a new hosting provider with much
better bandwidth to outside Israel. It should be much more faster and
responsive to most people. Other than that, the web-site has seen many
style and content changes:
</p>

<ol class="newsitem">
<li>
A computer music file that I created when I was in high school, with my
friend, was added to the <a href="./art/">art section</a>.
</li>
<li>
New section navigation menus were added to
<a href="./philosophy/">the Essays
and Articles section</a>, <a href="./open-source/">the Software
section</a>, and <a href="http://www.shlomifish.org/lecture/">the
Lectures section</a>. They will allow the main navigation menu to be
less crowded, and will give way for a faster update of the site.
</li>
<li>
Many typos were corrected in <a href="./DeCSS/">the DeCSS page</a>.
</li>
<li>
The <a href="./links.html">Links Page</a> was updated.
</li>
<li>
Several new essays and articles are now part of
the <a href="./philosophy/">Philosophy
section</a>. Especially note
<a href="./philosophy/computers/when-c-is-best/">the “When C is the
Best” essay</a> which started
<a href="http://osnews.com/comment.php?news_id=12189">an active discussion
in OSNews</a>.
</li>
<li>
I now have <a href="./philosophy/books-recommends/">a list of recommended
books</a>.
</li>
</ol>

<p class="newsitem">
There’s still some more ground to cover on my part, but the homepage should
still be much better than it was 10 days ago.
</p>
EOF
    },
);

sub file_to_news_item
{
    my $self     = shift;
    my $filename = shift;
    my $text     = path( $self->dir() . "/" . $filename )->slurp_utf8;
    my $title    = '';
    if ( $text =~ s{\A<!-- TITLE=(.*?)-->\n}{} )
    {
        $title = $1;
    }
    $title =~ s#&#&amp;#g;

=begin Removed

Removing because we no longer want such excessive "newsitem" classes in the
text.

    $text =~ s!<p>!<p class="newsitem">!g;
    $text =~ s!<ol>!<ol class="newsitem">!g;
    $text =~ s!<ul>!<ul class="newsitem">!g;
=end Removed

=cut

    my ( $y, $m, $d ) =
        $filename =~ /\A([0-9]{4})-([0-9]{2})-([0-9]{2})\.html\z/
        or Carp::confess("cannot extract date from filename '$filename'!");
    my $date = DateTime->new( year => $y, month => $m, day => $d );

# (sprintf("%.2d", $date->day()) . "-" . $date->month_abbr(). "-" . $date->year()),
    return +{
        'date'  => $date,
        'body'  => $text,
        'title' => $title,
    };
}

sub calc_rss_items
{
    my $self = shift;

    opendir my $dir, $self->dir();
    my @files = readdir($dir);
    closedir($dir);
    @files = ( grep { /\A[0-9]{4}-[0-9]{2}-[0-9]{2}\.html\z/ } @files );
    @files = sort { $a cmp $b } @files;
    return [ map { $self->file_to_news_item($_) } @files ];
}

sub calc_items
{
    my $self = shift;
    return [ @old_news_items, @{ $self->calc_rss_items() } ];
}

sub _tt2_process_body
{
    return (
        shift(@_) =~
s{\Qhttp://www.reddit.com/r/TMNT/comments/2d9fo7/postrelease_movie_discussion_thread_2/ck3khga\E}{https://is.gd/m4kZrJ}gr
    );
}

sub _format_date_human
{
    my ( $self, $date ) = @_;

    return (
              sprintf( "%.2d", $date->day() ) . "-"
            . $date->month_abbr() . "-"
            . $date->year() );
}

sub get_item_html
{
    my $self = shift;
    my $item = shift;

    my $date  = $item->{date};
    my $title = $item->{title};

    # my $article      = $self->_is_html5 ? 'article' : 'div';
    # my $article_attr = $self->_is_html5 ? ''        : ' class="news_item"';

    my $article      = 'article';
    my $article_attr = ' class="news_item"';

    return
          qq{<$article$article_attr><header><h3 class="newsitem" id="}
        . $date->strftime(q{shlomifish.org_news_%Y_%m_%d}) . q{">}
        . $self->_format_date_human($date)
        . ( defined($title) ? ": $title" : "" )
        . "</h3></header>\n\n"
        . _tt2_process_body( $item->{'body'} )
        . qq{\n</$article>\n};
}

sub render_items
{
    my $self  = shift;
    my $items = shift;
    return join( "\n\n", ( map { $self->get_item_html($_) } @$items ) );
}

sub render_front_page
{
    my $self  = shift;
    my @items = reverse( @{ $self->items() } );
    my $ret =
        $self->render_items( [ @items[ 0 .. ( $self->num_on_front() - 1 ) ] ] );
    return $ret;
}

sub render_old_news
{
    my $self  = shift;
    my @items = @{ $self->items() };
    return $self->render_items(
        [ reverse( @items[ 0 .. ( @items - $self->num_on_front() ) ] ) ] );
}

1;
