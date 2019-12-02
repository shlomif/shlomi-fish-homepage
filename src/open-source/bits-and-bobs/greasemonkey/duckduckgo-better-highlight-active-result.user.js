// ==UserScript==
// @name         duckduckgo-better-highlight-active-result
// @version      0.0.1
// @description  more visible red border
// @author       Shlomi Fish ( http://www.shlomifish.org/ )
// @include      https://duckduckgo.com/*
// ==/UserScript==
// ===============================================================

// //require https://ajax.googleapis.com/ajax/libs/jquery/3.3.1/jquery.min.js
//
// License is Expat License:
// http://www.opensource.org/licenses/mit-license.php

(function() {
    'use strict';
    document.styleSheets[0].insertRule(".result.highlight { border-color: red !important;}", 0);
})();
