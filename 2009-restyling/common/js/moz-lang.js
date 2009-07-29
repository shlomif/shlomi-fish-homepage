function lang_load() {
$('*').each(
    function(i){
        var l = $(this)[0].getAttribute("xml:lang");
        if (l)
        {
            $(this)[0].setAttribute("lang",l);
        }
    }
);
}
