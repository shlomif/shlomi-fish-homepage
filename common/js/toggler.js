"use strict";

function build_toggler(args) {
    var has_ls = (typeof localStorage !== "undefined" && localStorage !== null);
    var toggle_sect_key = args['ls_key'];
    var toggler_selector = args['toggler_selector'];
    var toggled_selector = args['toggled_selector'];
    var toggled_class = args['toggled_class'];
    var hide_text = args['hide_text'];
    var show_text = args['show_text'];

    var toggle_sect_menu = function() {
        var elem = $(toggler_selector);

        if (elem.hasClass("off")) {
            elem.text(hide_text);
            if (has_ls) {
                localStorage.setItem(toggle_sect_key, "1");
            }
        }
        else {
            elem.text(show_text);
            if (has_ls) {
                localStorage.removeItem(toggle_sect_key);
            }
        }
        $(toggled_selector).toggleClass(toggled_class);
        elem.toggleClass("off");
        elem.toggleClass("on");
    };

    var elem = $(toggler_selector);

    elem.on("click", function (event) { toggle_sect_menu(); });

    $(document).ready(function() {

        if (has_ls) {
            var in_storage = localStorage.getItem(toggle_sect_key);
            var in_elem = elem.hasClass("on");

            if ((in_storage && (!in_elem)) || ((!in_storage) && in_elem)) {
                toggle_sect_menu();
            }
        }
    });

    return;
}
