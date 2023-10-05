// Based on:
//
// https://stackoverflow.com/questions/6219152/jquery-reverse-an-order
//
// Thanks!

function jq_reverse(parent_sel: string, child_sel: string): void {
    // body...
    $(parent_sel).append(
        $(parent_sel + " " + child_sel)
            .get()
            .reverse(),
    );
    return;
}

function fortunes_reverse(): void {
    jq_reverse(".fortunes_list", "div.fortune");
    jq_reverse("section.h3 > ul", "> li");
    return;
}
