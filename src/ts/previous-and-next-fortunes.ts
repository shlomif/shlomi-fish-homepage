// Based on:
//
// https://stackoverflow.com/questions/6219152/jquery-reverse-an-order
//
// Thanks!

function fortunes_addlinks(): void {
    const fortunes = $(".fortunes_list > div.fortune");
    const fort = (idx) => {
        return fortunes.slice(idx, idx + 1);
    };
    const getid = (idx) => {
        return fort(idx).find("> .head > h3").attr("id");
    };
    const addlink = (idx, cls, label) => {
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
        fort(i).find("> .head > h3").append(html);
    }
    return;
}
