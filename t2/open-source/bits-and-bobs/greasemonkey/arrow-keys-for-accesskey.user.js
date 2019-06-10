// ==UserScript==
// @name         arrow-keys-for-accesskeys
// @version      0.0.1
// @description  provide self links for headers (h1, h2, etc.) with id=""'s.
// @author       Shlomi Fish ( http://www.shlomifish.org/ )
// @include      https://*.shlomifish.org/*
// @include      http://localhost/shlomif/homepage-local/*
// @include      https://*.begin-site.org/*
// @require https://ajax.googleapis.com/ajax/libs/jquery/3.3.1/jquery.min.js
// ==/UserScript==
// ===============================================================

//
// License is X11 License:
// http://www.opensource.org/licenses/mit-license.php

// Add jQuery
letsJQuery();

// All your GM code must be inside this function
function letsJQuery() {
    $(document).keydown(function(e) {
        if (e.ctrlKey || e.altKey || e.metaKey) {
            return;
        }

        let href = undefined;
        switch (e.key) {
            case "ArrowLeft": // left
                href = $("a[accesskey=\"p\"]").attr("href");
                if (! href) {
                    href = $("link[rel=\"prev\"]").attr("href");
                }
                // $("link[accesskey=\"p\"]").attr("href");
                break;
            case "ArrowRight": // right
                href = $("a[accesskey=\"n\"]").attr("href");
                if (! href) {
                    href = $("link[rel=\"next\"]").attr("href");
                }
                // $("link[accesskey=\"n\"]").attr("href");
                break;
            default:
                return;
        }
        if (! href) {
            return;
        }
        window.location = href;
        e.preventDefault();
    }
    );
}
