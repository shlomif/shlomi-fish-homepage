function shf_expand (sel, slicePoint) {
    $(document).ready(function() {
        $(sel).expander({
                        slicePoint: slicePoint,
                        expandText: 'Read more',
                        expandPrefix: ' …',
        });
        return;
    });
    return;
}
