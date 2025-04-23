// Based on:
//
// https://stackoverflow.com/questions/6219152/jquery-reverse-an-order
//
// Thanks!

function factoids_addlinks({ clearMarkup }: { clearMarkup: boolean }): void {
    const fortunes = $(".main_facts_list > ul > li.fact");
    const fort = (idx) => {
        return fortunes.slice(idx, idx + 1);
    };
    const getid = (idx) => {
        return "shlomif-fact-chuck-" + (idx + 1);
        return fort(idx).find("> .head > h3").attr("id");
    };
    const container_class: string = "factoids_addlinks";
    const getcontainer = (idx) => {
        return fort(idx).find("> blockquote > span." + container_class);
    };
    const addlink = (idx, cls, label) => {
        const link_end_id = getid(idx);
        const link_end = "/humour/fortunes/show.cgi?id=" + link_end_id;
        const ret =
            ' <a class="' + cls + '" href="' + link_end + '">' + label + "</a>";
        return ret;
    };

    for (let i = 0; i < fortunes.length; i++) {
        let html: string = "";

        html += addlink(i, "fact_node", "[ Node ]");
        let container = getcontainer(i);
        if (!container.length) {
            fort(i)
                .find("> blockquote")
                .append('<span class="' + container_class + '"></span>');
            container = getcontainer(i);
        }
        container.html(clearMarkup ? "" : html);
    }
    return;
}

$(() => {
    factoids_addlinks({ clearMarkup: false });
});
