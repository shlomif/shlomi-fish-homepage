// Based on:
//
// https://stackoverflow.com/questions/6219152/jquery-reverse-an-order
//
// Thanks!

function fortunes_addlinks(): void {
    const fortunes = $(".fortunes_list > div.fortune");
    const fort = (idx) => {
        return $(fortunes[idx]);
    };
    const getid = (idx) => {
        return fort(idx).find("> .head > h3").attr("id");
    };

    for (let i = 0; i < fortunes.length; i++) {
        let html: string = "";
        if (i > 0) {
            const previd = getid(i - 1);
            html += ' <a href="#' + previd + '">[ Prev ]</a>';
        }
        if (i < fortunes.length - 1) {
            const nextid = getid(i + 1);
            html += ' <a href="#' + nextid + '">[ Next ]</a>';
        }
        fort(i).find("> .head > h3").append(html);
    }
    return;
}
