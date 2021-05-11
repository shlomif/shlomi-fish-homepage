$(function (): void {
    $(".sub_menu ul.nav_links li a img")
        .mouseover(function (): void {
            const e = $(this);
            e.attr("src", e.attr("src").replace(/\.svg$/, "-pressed.svg"));
        })
        .mouseout(function (): void {
            const e = $(this);
            e.attr("src", e.attr("src").replace("-pressed.svg", ".svg"));
        });
});
