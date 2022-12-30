$(document).ready(function (): void {
    $(".fortunes_list table.info").each(function () {
        const t = $(this);
        t.find("tr").each(function () {
            const tr = $(this);
            const f: string = tr.find("td.field").first().html();
            if (f == "Published") {
                const td = tr.find("td.value").first();
                const d: string = td.html();
                if (!/^[0-9]+-[0-9]+-[0-9]+$/.test(d)) {
                    alert(d);
                }
                td.html('<time datetime="' + d + '">' + d + "</time>");
            }
        });
    });
});
