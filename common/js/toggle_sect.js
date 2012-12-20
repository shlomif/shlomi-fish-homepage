var toggle_sect_key = "shlomifish.org_section_navigation_menu_shown";

var has_ls = (typeof localStorage !== "undefined" && localStorage !== null);

function toggle_sect_menu() {
    var elem = $("#toggle_sect_menu");

    if (elem.hasClass("off")) {
        elem.text("Hide");
        if (has_ls) {
            localStorage.setItem(toggle_sect_key, "1");
        }
    }
    else {
        elem.text("Show");
        if (has_ls) {
            localStorage.removeItem(toggle_sect_key);
        }
    }
    $("#sect_menu_wrapper").toggleClass("novis");
    elem.toggleClass("off");
    elem.toggleClass("on");
}

$(document).ready(function(){
	$("#sect_menu_wrapper > ul").treeview({
		persist: "location",
		collapsed: false,
		unique: false
	});

    if (has_ls) {
        var in_storage = localStorage.getItem(toggle_sect_key);
        var in_elem = $("#toggle_sect_menu").hasClass("on");

        if ((in_storage && (!in_elem)) || ((!in_storage) && in_elem)) {
            toggle_sect_menu();
        }
    }
})
