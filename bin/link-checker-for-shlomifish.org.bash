perl -Ilib scripts/link-checker --base='http://localhost/shlomif/homepage-local/' \
    --before-insert-skip='\.(?:js|epub|zip|diff|pl|xsl|xslt|txt|raw\.html)\z' \
    --before-insert-skip='art/by-others/(?:BertycoX/BertycoX-dirs|Yachar/Yachar-dirs)/\z' \
    --before-insert-skip='/lm-solve/\z' \
    --before-insert-skip='/me/blogs/agg/[\w\-]*\.xml\z' \
    --before-insert-skip='/lecture/WebMetaLecture/.*\.wml\z' \
    --before-insert-skip='/lecture/WebMetaLecture/slides/examples/frames/' \
    --before-insert-skip='/open-source/projects/conf/vim/current/\z' \
    --before-insert-skip='/open-source/projects/yjobs' \
    --before-insert-skip='/js/MathJax/' \
    --before-insert-skip='\.htaccess\z' \
    --before-insert-skip='/humour/fortunes/show\.cgi' \
    --before-insert-skip='/humour/fortunes/show-cgi\.txt\z' \
    --before-insert-skip='/humour/fortunes/(?:bbt|friends|joel-on-software|nyh-sigs|osp_rules|paul-graham|sharp-perl|sharp-programming|shlomif|shlomif-factoids|shlomif-fav|subversion|tinic)\z' \
    ;
