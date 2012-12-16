"use strict";
function shlomif_load_nav (page_path) {
    $.getJSON(
        '/_data/nav.json',
        function(json_input) {
            var b = 'http://www.shlomifish.org/';
            $('#nav_menu').tree({
                autoEscape: false,
                autoOpen: true,
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
