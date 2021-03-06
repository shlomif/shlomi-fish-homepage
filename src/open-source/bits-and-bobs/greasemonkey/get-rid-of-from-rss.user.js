// ==UserScript==
// @name         get-rid-of-from-rss
// @version      0.0.3
// @description  get rid of the &from=rss GET parameters in URLs.
// @author       Shlomi Fish ( http://www.shlomifish.org/ )
// @include      http://use.perl.org/*
// @include      http://*.slashdot.org/*
// ==/UserScript==
// ===============================================================

//
// License is the Expat License:
// http://www.opensource.org/licenses/mit-license.php

var loc = window.location.href;
var new_loc = loc.replace(/[&?]from=rss.*$/, "").replace(/%2F/gi, "/");
if (new_loc != loc)
{
    window.location = new_loc;
}
