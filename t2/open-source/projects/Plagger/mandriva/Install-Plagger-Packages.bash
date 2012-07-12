#!/bin/bash
cat /home/shlomi/progs/Rpms/SPECS/perl-Plagger.spec | grep Requires | grep -vP '^ *#' | perl -0777 -nle '@a=/perl\([\w:]+\)/g; for(@a){s{^perl\(}{};s{\)$}{};}print join("\n", @a);' | sort | uniq | perl -pe 's!::!-!g' | perl -pe '$_="perl-$_"' |
    grep -vP '^perl-(LWP-Parallel-UserAgent|Locale-Language|Test-More|XMLRPC-Lite|XML-LibXML-SAX|LWP|Class-Accessor-Fast|POE-Component-Client-HTTP|JSON-Syck|DateTime-Format-(ICal|Strptime)|Date-Parse|MIME-Parser|HTML-FormatText|POE-Component-IKC-Client|Net-DNS-Resolver)$' \
    | (echo "urpmi " ; cat)
