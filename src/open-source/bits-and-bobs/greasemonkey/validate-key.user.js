// ==UserScript==
// @name         validate-key
// @version      0.0.1
// @description  Use the "v" keyboard key to validate an HTML page
// @author       Shlomi Fish ( http://www.shlomifish.org/ )
// @include      https://*.shlomifish.org/*
// @include      https://perl-begin.org/*
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

        switch (e.key) {
            case "v":
            case "V":
                window.open('http://validator.w3.org/check?uri='+encodeURIComponent(window.location));
                e.preventDefault();
                return;
        }
    }
    );
}
