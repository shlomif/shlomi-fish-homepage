function toggle_sect_menu() {
    var elem = $("#toggle_sect_menu");

    if (elem.hasClass("off")) {
        elem.text("Hide");
    }
    else {
        elem.text("Show");
    }
    $("#sect_menu_wrapper").toggleClass("novis");
    elem.toggleClass("off");
    elem.toggleClass("on");
}
