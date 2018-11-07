'use strict';

let toggle_sect_key = 'shlomifish.org_section_navigation_menu_shown';
let toggle_main_key = 'shlomifish.org_main_navigation_menu_shown';

function build_sect_nav_menu_toggler() {
    build_toggler({
        ls_key: toggle_sect_key,
        toggler_selector: '#toggle_sect_menu',
        toggled_selector: '#sect_menu_wrapper',
        toggled_class: 'novis',
        hide_text: 'Hide',
        show_text: 'Show',
        default_state: false,
    });
}

function build_main_nav_menu_toggler() {
    build_toggler({
        ls_key: toggle_main_key,
        toggler_selector: '#show_navbar',
        toggled_selector: '#navbar , #navbar_wrapper, #main',
        toggled_class: 'novis',
        hide_text: 'Hide NavBar ⬈',
        show_text: '<img src="/images/evilphish.png" alt="EvilPHish by Illiad" class="logo" /> Show NavBar ⬋',
        default_state: false,
    });
}

$(document).ready(function() {
    $('#sect_menu_wrapper > ul').treeview({
        persist: 'location',
        collapsed: false,
        unique: false,
    });

    build_sect_nav_menu_toggler();
    build_main_nav_menu_toggler();
});
