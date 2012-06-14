package Contents;

use strict;

my $contents =
{
    'title' => "Linux' Basic Use",
    'subs' =>
    [
        {
            'url' => "x",
            'title' => "X-Windows and KDE",
            'subs' =>
            [
                {
                    'url' => "similarities.html",
                    'title' => "Similarities to Windows",
                },
                {
                    'url' => "workspaces.html",
                    'title' => "The Workspaces",
                },
                {
                    'url' => "show_desktop.html",
                    'title' => "Show the Desktop",
                },
                {
                    'url' => "cut_n_paste",
                    'title' => "Cut and Paste in X-Windows",
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
            'url' => "console",
            'title' => "The Linux Console",
            'subs' =>
            [
                {
                    'url' => "opening.html",
                    'title' => "Opening a Console Window",
                },
                {
                    'url' => "exiting.html",
                    'title' => "Exiting from a Console Window",
                },
                {
                    'url' => "cmd_loop.html",
                    'title' => "The Command Loop",
                },
                {
                    'url' => "goodies.html",
                    'title' => "Shell Goodies",
                },
                {
                    'url' => "filesystem.html",
                    'title' => "Filesystem Basics",
                },
                {
                    'url' => "common_cmds.html",
                    'title' => "Common Commands",
                },
            ],
            'images' => [ "konsole.png" ],
        },
        {
            'url' => "help",
            'title' => "Getting Help",
            'subs' =>
            [
                {
                    'url' => "man.html",
                    'title' => "The Man Pages",
                },
                {
                    'url' => "apropos.html",
                    'title' => "Apropos",
                },
                {
                    'url' => "info.html",
                    'title' => "The \"Info\" manuals",
                },
                {
                    'url' => "howtos.html",
                    'title' => "The on-line HOWTO's",
                },
                {
                    'url' => "internet.html",
                    'title' => "Internet Resources",
                },
            ],
        },
        {
            'url' => "config",
            'title' => "Configration Tools",
            'subs' =>
            [
                {
                    'url' => "mandrake.html",
                    'title' => "On Mandrake",
                },
                {
                    'url' => "redhat.html",
                    'title' => "On Red Hat",
                },
            ],
        },
        {
            'url' => "vi",
            'title' => "Editing with Vi",
            'subs' =>
            [
                {
                    'url' => "invocation.html",
                    'title' => "Invoking Vi",
                },
                {
                    'url' => "cmd_and_edit.html",
                    'title' => "Command Mode and Editing Mode",
                },
                {
                    'url' => "exiting.html",
                    'title' => "Exiting from Vi",
                },
                {
                    'url' => "edit_mode.html",
                    'title' => "Entering and Exiting from Editing Mode",
                },
                {
                    'url' => "deleting.html",
                    'title' => "Deleting Text",
                },
                {
                    'url' => "saving.html",
                    'title' => "Saving the File",
                },
                {
                    'url' => "rollback.html",
                    'title' => "Exiting without saving changes",
                },
                {
                    'url' => "copy_and_paste.html",
                    'title' => "Copy and Paste",
                },
            ],
        },
        {
            'url' => "links.html",
            'title' => "Links and References",
        },
    ],
    'images' =>
    [
        'style.css',
    ],
};

sub get_contents
{
    return $contents;
}
