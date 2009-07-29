function toggle_sect_menu()
{
    var wrapper = document.getElementById("sect_menu_wrapper");
    var action_link = document.getElementById("toggle_sect_menu");
    if (wrapper.getAttribute("class") == "hide")
    {
        wrapper.setAttribute("class", "");
        action_link.innerHTML = "Hide";
    }
    else
    {
        wrapper.setAttribute("class", "hide");
        action_link.innerHTML = "Show";
    }
}

