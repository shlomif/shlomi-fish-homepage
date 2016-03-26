package Contents;

use strict;
use utf8;

my $contents =
{
    'title' => "מבוא ללינוקס",
    'subs' =>
    [
        {
            'url' => "intro",
            'title' => "הקדמה",
            'subs' =>
            [
                {
                    'url' => "distributions.html",
                    'title' => "מהן \"הפצות\"?",
                },
            ],
        },
        {
            'url' => "x",
            'title' => "X-Windows ו-KDE",
            'subs' =>
            [
                {
                    'url' => "similarities.html",
                    'title' => "הדמיון לחלונות",
                },
                {
                    'url' => "workspaces.html",
                    'title' => "מרחבי העבודה",
                },
                {
                    'url' => "show_desktop.html",
                    'title' => "הראה את שולחן העבודה",
                },
                {
                    'url' => "cut_n_paste",
                    'title' => "העתקה והדבקה ב-X-Windows",
                    'subs' =>
                    [
                        {
                            'url' => "klipper.html",
                            'title' => "Klipper",
                        }
                    ],
                    'images' =>
                    [
                        "klipper.png",
                    ],
                },
            ],
            'images' => [ "k.png", "folder_home.png", "workspaces_pager.png", "desktop.png", ],
        },
        {
            'url' => "equivalents",
            'title' => "מקבילות בלינוקס לתוכנות בעולם החלונות",
            'subs' =>
            [
                {
                    'url' => "web-browsers.html",
                    'title' => "דפדפני ווב",
                },
                {
                    'url' => "email-clients.html",
                    'title' => "לקוחות דואר אלקטרוני",
                },
                {
                    'url' => "office.html",
                    'title' => "תוכנות משרדיות",
                },
                {
                    'url' => "instant-messaging.html",
                    'title' => "מסרים מיידיים",
                },
                {
                    'url' => "image-editing.html",
                    'title' => "תוכנות לגרפיקה",
                },
                {
                    'url' => "IDEs.html",
                    'title' => "סביבות פיתוח משולבות",
                },
                {
                    'url' => "multimedia.html",
                    'title' => "נגני מולטימדיה",
                },
                {
                    'url' => "games.html",
                    'title' => "משחקים",
                },
            ],
            'images' => [ "firefox-1.png", "firefox-1-thumb.png",
                "mdk91-scr7-s.jpg", "konq_navigate-thumb.png",
                "gimp-screenshot-thumb.png", "gimp-screenshot.png",
                "kmail_main-thumb.png", "thunderbird-thumb.png",
                "evolution-thumb.png", "ooo-thumb.png",
                "kspread-thumb.png", "licq-thumb.png", "pidgin-thumb.png",
                "xmms-thumb.jpg", "mplayer-thumb.jpg", "xine-thumb.png",
                "ogle-thumb.jpg", "amarok-thumb.png", "totem-thumb.png",
                "kaffeine-thumb.png", "kaffeine.jpg",
                "inkscape-0.47-spiro-typography.png",
                "inkscape-thumb.png",
                ],
        },
        {
            'url' => "help",
            'title' => "קבלת עזרה",
            'subs' =>
            [
                {
                    'url' => "man.html",
                    'title' => "דפי ה-Man",
                },
                {
                    'url' => "apropos.html",
                    'title' => "Apropos",
                },
                {
                    'url' => "info.html",
                    'title' => "מדריכי ה-\"Info\"",
                },
                {
                    'url' => "howtos.html",
                    'title' => "הכיצדריכים המקוונים",
                },
                {
                    'url' => "internet.html",
                    'title' => "משאבים באינטרנט",
                },
            ],
        },
        {
            'url' => "config",
            'title' => "כלי קונפיגורציה",
            'subs' =>
            [
                {
                    'url' => "mandriva.html",
                    'title' => "במנדריבה",
                },
                {
                    'url' => "fedora.html",
                    'title' => "בפדורה",
                },
                {
                    'url' => "ubuntu.html",
                    'title' => "באובונטו/קובונטו",
                },
            ],
        },
        {
            'url' => "foss-philosophy",
            'title' => "פילוסופיית הקוד הפתוח והתוכנה החופשית",
            'subs' =>
            [
                {
                    'url' => "free-software-definition.html",
                    'title' => "הגדרת התוכנה החופשית",
                },
                {
                    'url' => "copyleft.html",
                    'title' => "מהו Copyleft?",
                },
                {
                    'url' => "community.html",
                    'title' => "השתתפות הקהילה בפיתוח",
                },
                {
                    'url' => "more-info.html",
                    'title' => "למידע נוסף",
                },
            ],
        },
        {
            'url' => "links.html",
            'title' => "קישורים ומראי מקום",
        },
    ],
    'images' =>
    [
        'help.html',
        'slidy.js',
        'style.css',
    ],
};

sub get_contents
{
    return $contents;
}

1;

