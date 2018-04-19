#!/usr/bin/perl

use strict;
use warnings;

use Path::Tiny qw/ path /;

my @filenames;
my @ad_filenames;
foreach my $fn (@ARGV)
{
    my $_f = sub {
        return path($fn);
    };

    eval {
        my $orig_text = $_f->()->slurp_utf8;
        my $text      = $orig_text;

        if ( !$ENV{NO_I} )
        {
            $text =~
s#^\({5}include "([^"]+)"\){5}\n#path("lib/$1")->slurp_utf8#egms;
            $text =~
s#\({5}chomp_inc='([^']+)'\){5}#my ($l) = path("lib/$1")->lines_utf8({count => 1});chomp$l;$l#egms;
        }

        if ( $ENV{F} )
        {
            foreach my $class (qw(info irc-conversation))
            {
                my $table_from = qq{<table class="$class">};
                my $table_to   = qq{<table class="$class" summary="">};

                $text =~ s#\Q$table_from\E#$table_to#g;
            }
        }

        $text =~ s# +$##gms;
        $text =~ s#(</div>|</li>|</html>)\n\n#$1\n#g;

        # Remove surrounding space of tags.
        $text =~
            s#\s*(</?(?:body|(?:br /)|div|head|li|ol|p|title|ul)>)\s*#$1#gms;

        # Remove document trailing space.
        $text =~ s#\s+\z##ms;

        my $minify = $ENV{ALWAYS_MIN};
        if ( $text ne $orig_text )
        {
            $_f->()->spew_utf8($text);
            $minify //= 1;
        }
        if ($minify)
        {
            push @filenames, $fn;
        }
        elsif ( $ENV{APPLY_ADS} )
        {
            push @ad_filenames, $fn;
        }
    };
    if ( my $err = $@ )
    {
        # In case there's an error - fail and need to rebuild.
        $_f->()->remove();
        die $err;
    }
}
system(
    'bin/batch-inplace-html-minifier',
    '-c', 'bin/html-min-cli-config-file.conf',
    '--keep-closing-slash', @filenames
) and die "html-min $!";

if ( $ENV{APPLY_ADS} )
{
    my $PW_TEXT1 = <<'EOF' =~ s#\n\z##r;
<!-- Project Wonderful Ad Box Loader -->
<script type="text/javascript">
(function(){function pw_load(){if(arguments.callee.z)return;else arguments.callee.z=true;var d=document;var s=d.createElement('script');var x=d.getElementsByTagName('script')[0];s.type='text/javascript';s.async=true;s.src='//www.projectwonderful.com/pwa.js';x.parentNode.insertBefore(s,x);}if (window.attachEvent){window.attachEvent('DOMContentLoaded',pw_load);window.attachEvent('onload',pw_load);}else{window.addEventListener('DOMContentLoaded',pw_load,false);window.addEventListener('load',pw_load,false);}})();
</script>
<!-- End Project Wonderful Ad Box Loader -->
<!-- Project Wonderful Ad Box Code -->
<div id="pw_adbox_42457_1_0"></div><script type="text/javascript"></script>
<noscript><div><map id="admap42457"><area href="http://www.projectwonderful.com/out_nojs.php?r=0&amp;c=0&amp;id=42457&amp;type=1" shape="rect" coords="0,0,468,60" title="" alt="" /></map></div><table summary=""><tr><td><img src="http://www.projectwonderful.com/nojs.php?id=42457&amp;type=1" height="60" usemap="admap42457" alt="" /></td></tr><tr><td colspan="1"><div class="cen"><a style="font-size:10px;color:#0000ff;text-decoration:none;line-height:1.2;font-weight:bold;font-family:Tahoma, verdana,arial,helvetica,sans-serif;text-transform: none;letter-spacing:normal;text-shadow:none;white-space:normal;word-spacing:normal;" href="http://www.projectwonderful.com/advertisehere.php?id=42457&amp;type=1">Ads by Project Wonderful! Your ad here, right now: $0.02</a></div></td></tr><tr><td colspan="1" style="height:3px;font-size:1px;padding:0px;max-height:3px;vertical-align:top;"></td></tr></table>
</noscript>
<!-- End Project Wonderful Ad Box Code -->
<script type="text/javascript" src="http://www.projectwonderful.com/ad_display.js"></script>
<!-- End of Project Wonderful ad code. -->
EOF

    my $PW_TEXT2 = <<'EOF' =~ s#\n\z##r;
<!-- Project Wonderful Ad Box Code -->
<div id="pw_adbox_42545_3_0"></div><script type="text/javascript"></script>
<noscript><div><map id="admap42545"><area href="http://www.projectwonderful.com/out_nojs.php?r=0&amp;c=0&amp;id=42545&amp;type=3" shape="rect" coords="0,0,160,600" title="" alt="" /></map></div><table summary=""><tr><td><img src="http://www.projectwonderful.com/nojs.php?id=42545&amp;type=3" width="160" height="600" usemap="admap42545" alt="" /></td></tr><tr><td colspan="1"><div class="cen"><a style="font-size:10px;color:#0000ff;text-decoration:none;line-height:1.2;font-weight:bold;font-family:Tahoma, verdana,arial,helvetica,sans-serif;text-transform: none;letter-spacing:normal;text-shadow:none;white-space:normal;word-spacing:normal;" href="http://www.projectwonderful.com/advertisehere.php?id=42545&amp;type=3">Ads by Project Wonderful! Your ad here, right now: $0.02</a></div></td></tr><tr><td colspan="1" style="height:3px;font-size:1px;padding:0px;max-height:3px;vertical-align:top;"></td></tr></table>
</noscript>
<!-- End Project Wonderful Ad Box Code -->
EOF

    foreach my $fn ( @filenames, @ad_filenames )
    {
        path($fn)->edit_utf8(
            sub {
s%<div id="project_wonderful_top_proto">Placeholder</div>%\n$PW_TEXT1%ms;
s%<div id="project_wonderful_code_side_proto">Placeholder</div>%\n$PW_TEXT2%ms;
            }
        );
    }
}
