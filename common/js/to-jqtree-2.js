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
            var has_ls = (typeof localStorage !== "undefined" && localStorage !== null);
            var storage_key = 'shlomifish.org_main_nav_menu_data';
            var was_storage_already_populated = false;
            if (has_ls) {
                was_storage_already_populated = (localStorage.getItem(storage_key) ? true : false);
            }
            nav_menu.tree({
                autoEscape: false,
                autoOpen: false,
                saveState: storage_key,
                data: calc_jqtree_data_from_html_w_nav_menu_json(
                    {
                        input: json_input,
                        rel_path: page_path
                    }
                )
            });

            if (! was_storage_already_populated) {
                var about_myself_node_id = "2";
                var art_node_id = "120";
                var essays_node_id = "235";
                var humour_node_id = "13";
                var lectures_node_id = "193";
                var meta_node_id = "311";
                var soft_node_id = "127";

                [about_myself_node_id, art_node_id, essays_node_id, humour_node_id, lectures_node_id, meta_node_id, soft_node_id].forEach(function (node_id) {
                    var node = nav_menu.tree('getNodeById', node_id);
                    nav_menu.tree('openNode', node, false);
                });
            }
        }
    );
}
