function lang_load() {
$('*').each(
    function(i) {
        var e = $(this)[0];
        var l = e.getAttribute('xml:lang');
        if (l) {
            e.setAttribute('lang', l);
        }
    }
);
}
