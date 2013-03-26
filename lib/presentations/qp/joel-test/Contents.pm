package Contents;

use strict;
use utf8;

my $contents =
{
    'title' => "מבחן יואל",
    'subs' =>
    [
        {
            'title' => "האם שמעתם על SEMA?",
            'url' => "sema.html",
        },
        {
            'title' => "מבחן יואל",
            'url' => "joel-test",
            'subs' =>
            [
                {
                    'url' => "version-control.html",
                    'title' => "האם אתם משתמשים במערכת ניהול גרסאות?",
                },
                {
                    'url' => "build-in-one-step.html",
                    'title' => "האם אתם מסוגלים לבנות גרסה בצעד אחד?",
                },
                {
                    url => "daily-builds.html",
                    'title' => "האם אתם בונים גרסה בכל יום?",
                },
                {
                    url => "bug-database.html",
                    'title' => "האם יש לכם בסיס נתוני באגים?",
                },
                {
                    url => "fix-bugs-before-new-code.html",
                    title => "האם אתם מתקנים באגים לפני כתיבת קוד חדש?",
                },
                {
                    url => "schedules.html",
                    title => "האם יש לכם לוחות זמנים מעודכנים?",
                },
                {
                    url => "specs.html",
                    title => "האם יש לכם מפרט?",
                },
                {
                    url => "quiet-working-env.html",
                    title => "האם יש למתכנתים סביבת עבודה שקטה?",
                },
                {
                    url => "best-tools.html",
                    title => "האם אתם משתמשים בכלים הטובים ביותר שניתן לקנות?",
                },
                {
                    url => "testers.html",
                    title => "האם יש לכם בודקי-תוכנה?",
                },
                {
                    url => "write-code-in-interview.html",
                    title => "האם מועמדים לעבודה כותבים קוד בזמן הראיון?",
                },
                {
                    url => "hallway-testing.html",
                    title => "האם אתם מבצעים בדיקות שימושיות ב\"מסדרון\"?",
                },
            ],
        },
        {
            url => "thanks.html",
            title => "תודה!",
        },
    ],
    'images' =>
    [
        'style.css',
        'slidy.js',
    ],
};

sub get_contents
{
    return $contents;
}

1;
