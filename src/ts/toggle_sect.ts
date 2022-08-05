"use strict";

const toggle_sect_key: string = "shlomifish.org_section_navigation_menu_shown";
const toggle_main_key: string = "shlomifish.org_main_navigation_menu_shown";
const toggle_toc_details_key: string = "shlomifish.org_toc_details_open";

function build_sect_nav_menu_toggler(): void {
    build_toggler({
        default_state: false,
        hide_text: "Hide",
        ls_key: toggle_sect_key,
        show_text: "Show",
        toggled_class: "novis",
        toggled_selector: "#sect_menu_wrapper",
        toggler_selector: "#toggle_sect_menu",
    });
}

function build_main_nav_menu_toggler() {
    const el = $(".leading_path a:first");
    const s = el.attr("href");
    build_toggler({
        default_state: false,
        hide_text: "Hide NavBar ⬈",
        ls_key: toggle_main_key,
        show_text:
            '<img src="' +
            (s ? s : "/") +
            'images/evilphish.png" alt="EvilPHish by Illiad" class="logo" /> Show NavBar ⬋',
        toggled_class: "novis",
        toggled_selector: "#navbar , #main",
        toggler_selector: "#show_navbar",
    });
}

function build__toc_details__toggler() {
    build_toggler({
        default_state: false,
        hide_text: "fail",
        ls_key: toggle_toc_details_key,
        show_text: "fail",
        toggled_class: "novis",
        toggled_selector: "details#toc",
        toggled_type: "details",
        toggler_selector: "details#toc",
    });
}

$(document).ready(function (): void {
    /*
    if (false) {
        $('#sect_menu_wrapper > ul').tree({
            autoEscape: false,
            autoOpen: false,
        });
    }
    */

    build_sect_nav_menu_toggler();
    build_main_nav_menu_toggler();
    build__toc_details__toggler();
});
