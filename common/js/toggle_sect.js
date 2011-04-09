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

$(document).ready(function(){
	// first example
	$("#sect_menu_wrapper > ul").treeview({
		persist: "location",
		collapsed: false,
		unique: false
	});
})
