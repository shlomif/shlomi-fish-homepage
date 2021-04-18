"use strict";

class TogglerWrapper {
    constructor(public toggle_cb: () => void, public apply_state_cb: () => void, public calc_in_elem: () => boolean) {
        return;
    }
};

function build_toggler(args) {
    function _is_null (x: any): boolean {
        return ((typeof x === "undefined") || (x === undefined) || (x === null));
    }

    const has_ls: boolean = !_is_null( localStorage );
    const toggled_type: string = (('toggled_type' in args) ? args['toggled_type'] : 'class');
    const is_class: boolean = (toggled_type == 'class');
    const toggle_sect_key = args['ls_key'];
    const toggler_selector = args['toggler_selector'];
    const toggled_selector = args['toggled_selector'];
    const toggled_class = args['toggled_class'];
    const hide_text: string = args['hide_text'];
    const show_text: string = args['show_text'];
    const default_state: boolean = (('default_state' in args) ? args['default_state'] : true);

    function toggle_sect_menu() {
        const elem = $(toggler_selector);

        const was_off = elem.hasClass("off");
        const was_on = !was_off;
        const is_on_now = !was_on;

        elem.html(was_off ? hide_text : show_text);
        $(toggled_selector).toggleClass(toggled_class);
        elem.toggleClass("off");
        elem.toggleClass("on");
        if (has_ls) {
            if (is_on_now === default_state) {
                localStorage.removeItem(toggle_sect_key);
            } else {
                localStorage.setItem(toggle_sect_key, (is_on_now ? "1" : "0"));
            }
        }
    }

    const toggled_attr = 'open';

    function _calc__is_on_now (elem) {
        const was_off = (!elem.attr(toggled_attr));
        const was_on = !was_off;
        // NOTE THE DIFFERENCE FROM toggle_sect_menu!!!
        const is_on_now = was_on;
        return is_on_now;
    }
    function apply_details_state() {
        const elem = $(toggler_selector);
        const is_on_now = _calc__is_on_now(elem);
        if (is_on_now) {
            elem.removeAttr(toggled_attr);
        } else {
            elem.attr(toggled_attr, "open");
        }
    }

    function toggle_details() {
        const elem = $(toggler_selector);
        const is_on_now = _calc__is_on_now(elem);


        // elem.html(was_off ? hide_text : show_text);
        // $(toggled_selector).toggleClass(toggled_class);
        // elem.toggleClass("off");
        // elem.toggleClass("on");
        if (has_ls) {
            if (is_on_now === default_state) {
                localStorage.removeItem(toggle_sect_key);
            } else {
                localStorage.setItem(toggle_sect_key, (is_on_now ? "1" : "0"));
            }
        }
    }
    const elem = $(toggler_selector);
    const toggler_wrapper: TogglerWrapper = (is_class ?
        (new TogglerWrapper(toggle_sect_menu, toggle_sect_menu, (function() { return elem.hasClass('on');}))) :
        (new TogglerWrapper(toggle_details, apply_details_state, (function() { return _calc__is_on_now(elem);})))
    )

    elem.on((is_class ? "click" : "toggle"), function (event) { toggler_wrapper.toggle_cb(); });

    $(document).ready(function() {

        if (! has_ls) {
            return;
        }
        const in_storage_s:string = localStorage.getItem(toggle_sect_key);

        const in_storage: boolean = (
            _is_null(in_storage_s) ? default_state
            : ((in_storage_s == "1") ? true : false)
        );

        const in_elem: boolean = toggler_wrapper.calc_in_elem();

        if ((in_storage && (!in_elem)) || ((!in_storage) && in_elem)) {
            toggler_wrapper.apply_state_cb();
        }
    });
}
