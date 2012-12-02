function add_self_links()
{
    var myclass = "self_link";
    if (! $("body").hasClass(myclass))
    {
        $("h1[id],h2[id],h3[id],h4[id],h5[id],h6[id]").each(function(i){ $(this).append( ' <span class="selfl">[<a href="#' + this.id + '">link</a>]</span>' ) })
        $("body").addClass(myclass);
    }
}

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
