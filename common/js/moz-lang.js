function langLoad() {
$('*').each(
    function(i) {
        let e = $(this)[0];
        const l = e.getAttribute('xml:lang');
        if (l) {
            e.setAttribute('lang', l);
        }
    }
);
}
