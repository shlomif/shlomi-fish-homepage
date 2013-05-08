$(function() {
    $(".sub_menu ul.nav_links li a img").mouseover(function() {
            var src = $(this).attr("src").replace(/\.svg$/, "-pressed.svg");
            $(this).attr("src", src);
        })
        .mouseout(function() {
            var src = $(this).attr("src").replace("-pressed.svg", ".svg");
            $(this).attr("src", src);
        });
});
