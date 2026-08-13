// Based on:
//
// https://stackoverflow.com/questions/6219152/jquery-reverse-an-order
//
// Thanks!

function fortunes_addlinks({ clearMarkup }: { clearMarkup: boolean }): void {
    const fortunes = $(".fortunes_list > div.fortune");
    const fort = (idx: number) => {
        return fortunes.slice(idx, idx + 1);
    };
    const getid = (idx: number) => {
        return fort(idx).find("> .head > h3").attr("id");
    };
    const container_class: string = "fortunes_addlinks";
    const getcontainer = (idx: number) => {
        return fort(idx).find("> .head > h3 > span." + container_class);
    };
    const addlink = (idx: number, cls: string, label: string) => {
        const link_end_id = getid(idx);
        const ret =
            ' <a class="' +
            cls +
            '" href="#' +
            link_end_id +
            '">' +
            label +
            "</a>";
        return ret;
    };

    for (let i = 0; i < fortunes.length; i++) {
        let html: string = "";

        if (i > 0) {
            html += addlink(i - 1, "previous", "Previous");
        }
        if (i < fortunes.length - 1) {
            html += addlink(i + 1, "next", "Next");
        }
        let container = getcontainer(i);
        if (!container.length) {
            fort(i)
                .find("> .head > h3")
                .append('<span class="' + container_class + '"></span>');
            container = getcontainer(i);
        }
        container.html(clearMarkup ? "" : html);
    }
    return;
}

$(() => {
    fortunes_addlinks({ clearMarkup: false });
});
