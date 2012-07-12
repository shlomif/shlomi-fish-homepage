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
                    'title' => "דפדפני וו'ב",
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
                    'title' => "תוכנות לעיבוד תמונה",
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
                "kspread-thumb.png", "licq-thumb.png", "gaim-thumb.png",
                "xmms-thumb.jpg", "mplayer-thumb.jpg", "xine-thumb.png",
                "ogle-thumb.jpg",
                ],
        },
        {
            'url' => "console",
            'title' => "חלון הפקודות של לינוקס",
            'subs' =>
            [
                {
                    'url' => "opening.html",
                    'title' => "פתיחת חלון מסוף",
                },
                {
                    'url' => "exiting.html",
                    'title' => "יציאה מחלון המסוף",
                },
                {
                    'url' => "cmd_loop.html",
                    'title' => "מחזור הפקודה",
                },
                {
                    'url' => "goodies.html",
                    'title' => "תכונות נחמדות של המעטפת",
                },
                {
                    'url' => "filesystem.html",
                    'title' => "מאפיינים בסיסיים של מערכת הקבצים",
                },
                {
                    'url' => "common_cmds.html",
                    'title' => "פקודות נפוצות",
                },
            ],
            'images' => [ "konsole.png" ],
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
            'url' => "packages",
            'title' => "התקנת חבילות",
            'subs' =>
            [
                {
                    'url' => "rpm.html",
                    'title' => "בשימוש בפקודה rpm",
                },
                {
                    'url' => "yum.html",
                    'title' => "בשימשו בפקודה yum",
                },
                {
                    'url' => "apt.html",
                    'title' => "בשימוש בפקודה apt",
                },
                {
                    'url' => "urpmi.html",
                    'title' => "בשימוש בפקודה urpmi",
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
                    'url' => "bazaar.html",
                    'title' => "מודל פיתוח הבזאר",
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
        'slidy.js',
        'style.css',
    ],
};

sub get_contents
{
    return $contents;
}

1;

