const _calc_footer_nav_links_markup__browser_side = () => {
    const prev_page = $('#navbar .nav_links a[accesskey="p"]');
    const next_page = $('#navbar .nav_links a[accesskey="n"]');
    let markup: string = "";
    markup += "<p>";
    if (prev_page) {
        markup +=
            '<a class="bottom_nav previous" href="' +
            escape_html(prev_page.attr("href")) +
            '">' +
            "Previous Page" +
            "</a>";
    }
    if (next_page) {
        markup +=
            '<a class="bottom_nav next" href="' +
            escape_html(next_page.attr("href")) +
            '">' +
            "Next Page" +
            "</a>";
    }
    markup += "</p>";
    return markup;
};
const old_footer_nav_links_markup: string = _calc_footer_nav_links_markup__browser_side();
