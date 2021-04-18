"use strict";
function shlomif_load_nav (page_path) {
    $.getJSON(
        get_relative_path({
            rel_path: page_path,
            to: '_data/n.json',
        }),
        function(got_json_input) {
            const keys_map={s:'subs',i:'id',t:'title',u:'url',x:'text',e:'expand',r:'re',k:'skip',b:'bool',h:'host',c:'capt',};
            function _expand (val) {
                if (Array.isArray(val)) {
                    return val.map(_expand);
                }
                if ($.isPlainObject(val)) {
                    const ret = {};
                    for (const [k, v] of Object.entries(val)) {
                        ret[keys_map[k]] = _expand(v);
                    }
                    return ret;
                }
                return val;
            }
            const json_input = _expand(got_json_input);
            const nav_menu = $('#nav_menu');
            const has_ls = (typeof localStorage !== "undefined" && localStorage !== null);
            const storage_key = 'shlomifish.org_main_nav_menu_data';
            let was_storage_already_populated = false;
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
                const about_myself_node_id = "2";
                const art_node_id = "120";
                const essays_node_id = "235";
                const humour_node_id = "13";
                const lectures_node_id = "193";
                const meta_node_id = "311";
                const soft_node_id = "127";

                [about_myself_node_id, art_node_id, essays_node_id, humour_node_id, lectures_node_id, meta_node_id, soft_node_id].forEach(function (node_id) {
                    nav_menu.tree('openNode', nav_menu.tree('getNodeById', node_id), false);
                });
            }
        }
    );
}
