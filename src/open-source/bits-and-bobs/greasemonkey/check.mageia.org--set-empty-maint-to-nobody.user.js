// ==UserScript==
// @name         check.mageia.org--set-empty-maint-to-nobody
// @version      0.0.1
// @description  Set empty check.mageia.org maintainers to “nobody”
// @author       Shlomi Fish ( http://www.shlomifish.org/ )
// @include      http://check.mageia.org/cauldron/updates.html
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
    $('tr').each(function (idx) {
        const td = $(this).find('td:eq(2)');
        if (td && (td.text().length === 0)) {
            td.text('nobody');
        }
    });
}
