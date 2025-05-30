base='http://localhost/shlomif/homepage-local/'
base='http://localhost:2400/sites/hp/'
ocs="--only-check-site-flow"
args=""
if test "$1" = "$ocs"
then
    shift
    args+=" $ocs"
fi
if ! gmake docbook_extended
then
    "gmake docbook_extended failed"
    exit 1
fi
perl -I lib -MWWW::LinkChecker::Internal::App -e 'WWW::LinkChecker::Internal::App->run()' -- check --base="${base}" $args \
    --before-insert-skip='//.+?//' \
    --before-insert-skip='/Files/files/video/[^/]+\.webm\z' \
    --before-insert-skip='/\.htaccess\z' \
    --before-insert-skip='/art/by-others/(?:BertycoX/BertycoX-dirs|Yachar/Yachar-dirs)/\z' \
    --before-insert-skip='/humour/fortunes/(?:bbt|friends|joel-on-software|nyh-sigs|osp_rules|paul-graham|sharp-perl|sharp-programming|shlomif|shlomif-factoids|shlomif-fav|subversion|tinic)\z' \
    --before-insert-skip='/humour/fortunes/fortunes_show\.(?:cgi|py)\z' \
    --before-insert-skip='/humour/fortunes/show\.cgi' \
    --before-insert-skip='/js/MathJax/' \
    --before-insert-skip='/lecture/WebMetaLecture/.*\.(?:wml|css)\z' \
    --before-insert-skip='/lecture/WebMetaLecture/all-in' \
    --before-insert-skip='/lecture/WebMetaLecture/slides--all-in' \
    --before-insert-skip='/lecture/WebMetaLecture/slides/examples/frames/' \
    --before-insert-skip='/lm-solve/\z' \
    --before-insert-skip='/me/blogs/agg/[\w\-]*\.xml\z' \
    --before-insert-skip='/open-source/projects/conf/vim/current/\z' \
    --before-insert-skip='/open-source/projects/yjobs-on-mozilla/downloads/\S*\.pl\.gz\z' \
    --before-insert-skip='/philosophy/solving/' \
    --before-insert-skip='\.(?:diff|epub|js|pl|raw\.html|rtf|tar\.xz|txt|zip|xsl|xslt)\z' \
    ;

    # --before-insert-skip='/humour/fortunes/show-cgi\.txt\z' \

    # --before-insert-skip='/open-source/projects/yjobs' \
