$(function() {
    $('.sub_menu ul.nav_links li a img').mouseover(function() {
        let e = $(this);
        e.attr('src', e.attr('src').replace(/\.svg$/, '-pressed.svg'));
        })
        .mouseout(function() {
            let e = $(this);
            e.attr('src', e.attr('src').replace('-pressed.svg', '.svg'));
        });
});
