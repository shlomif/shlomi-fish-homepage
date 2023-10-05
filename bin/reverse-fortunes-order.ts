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
jq_reverse(".fortunes_list", "div.fortune");
