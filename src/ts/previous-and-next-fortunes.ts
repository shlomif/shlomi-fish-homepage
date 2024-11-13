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
        const addlink = (idx, cls, label) => {
            const previd = getid(idx);
            return (
                ' <a class="' +
                cls +
                '" href="#' +
                previd +
                '">' +
                label +
                "</a>"
            );
        };

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
