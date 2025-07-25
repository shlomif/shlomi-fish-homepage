"use strict";
function shlomif_load_nav(page_path: string): void {
    $(() => {
        const footer = $("body > footer");
        const old_footer_nav_links_markup: string = "";
        footer.prepend(
            old_footer_nav_links_markup +
                '<p class="page_source_link"><a href="https://github.com/shlomif/shlomi-fish-homepage/tree/master/src/' +
                page_path +
                (page_path === "" || /\/$/.test(page_path) ? "" : ".tt2") +
                '">Page source</a></p>',
        );
    });
    $.getJSON(
        get_relative_path({
            rel_path: page_path,
            to: "_data/n.json",
        }),
        function (compressed_json) {
            const keys_map = {
                b: "bool",
                c: "capt",
                e: "expand",
                h: "host",
                i: "id",
                k: "skip",
                r: "re",
                s: "subs",
                t: "title",
                u: "url",
                x: "text",
            };
            function _expand(input_val: any): any {
                if (Array.isArray(input_val)) {
                    return input_val.map(_expand);
                }
                if ($.isPlainObject(input_val)) {
                    const ret: any = {};
                    for (const [k, v] of Object.entries(input_val)) {
                        ret[keys_map[k]] = _expand(v);
                    }
                    return ret;
                }
                return input_val;
            }
            const json_input: any = _expand(compressed_json);
            const nav_menu = $("#nav_menu");
            const has_ls: boolean =
                typeof localStorage !== "undefined" && localStorage !== null;
            const storage_key: string = "shlomifish.org_main_nav_menu_data";
            let was_storage_already_populated: boolean = false;
            if (has_ls) {
                was_storage_already_populated = localStorage.getItem(
                    storage_key,
                )
                    ? true
                    : false;
            }
            (nav_menu as any).tree({
                autoEscape: false,
                autoOpen: false,
                saveState: storage_key,
                data: calc_jqtree_data_from_html_w_nav_menu_json({
                    input: json_input,
                    rel_path: page_path,
                }),
            });

            if (!was_storage_already_populated) {
                const about_myself_node_id: string = "2";
                const art_node_id: string = "120";
                const essays_node_id: string = "235";
                const humour_node_id: string = "13";
                const lectures_node_id: string = "193";
                const meta_node_id: string = "311";
                const soft_node_id: string = "127";

                for (const node_id of [
                    about_myself_node_id,
                    art_node_id,
                    essays_node_id,
                    humour_node_id,
                    lectures_node_id,
                    meta_node_id,
                    soft_node_id,
                ]) {
                    (nav_menu as any).tree(
                        "openNode",
                        (nav_menu as any).tree("getNodeById", node_id),
                        false,
                    );
                }
            }
        },
    );
}
