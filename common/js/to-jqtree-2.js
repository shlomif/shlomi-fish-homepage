"use strict";
function shlomif_load_nav (page_path) {
    var b = 'http://www.shlomifish.org/';
    $.getJSON(
        get_relative_path({
            rel_path: page_path,
            to: '_data/nav.json',
        }),
        function(json_input) {
            var nav_menu = $('#nav_menu');
            nav_menu.tree({
                autoEscape: false,
                autoOpen: false,
                saveState: true,
                data: calc_jqtree_data_from_html_w_nav_menu_json(
                    {
                        input: json_input,
                        rel_path: page_path
                    }
                )
            });
            var about_myself_node_id = "2";
            var meta_node_id = "311";
            [meta_node_id].forEach(function (node_id) {
                var node = nav_menu.tree('getNodeById', node_id);
                nav_menu.tree('openNode', node, false);
            });
        }
    );
}
