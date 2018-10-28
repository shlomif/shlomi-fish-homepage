#!/bin/bash
perl -C `which markdent-html` --dialects GitHub --file t2/lecture/Perl/Newbies/lecture5-notes.txt |
(
        cat <<'EOF'
<?xml version="1.0" encoding="utf-8"?>
<!DOCTYPE html>
<html xmlns="http://www.w3.org/1999/xhtml" xml:lang="he" dir="rtl">
<head>
<title>Shlomi Fish’s Homepage</title>
<meta charset="utf-8" />
<meta name="description" content="Perl for Newbies Lecture 5: Hebrew Notes" />
<style>
body { direction: rtl; text-align: right; }
</style>
</head>
<body>
EOF
    cat -
    cat <<'EOF'
</body>
</html>
EOF
)
