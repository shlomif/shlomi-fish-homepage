"use strict";
function shlomif_load_nav (page_path) {
    var b = 'http://www.shlomifish.org/';
    $.getJSON(
        get_relative_path({
            base: b,
            current: b + page_path,
            to: '_data/nav.json',
        }),
        function(json_input) {
            $('#nav_menu').tree({
                autoEscape: false,
                autoOpen: false,
                data: [ calc_jqtree_data_from_html_w_nav_menu_json(
                    {
                        input: json_input,
                base: b,
                current: b + page_path
                    }
                ) ]
            });
        }
    );
}
