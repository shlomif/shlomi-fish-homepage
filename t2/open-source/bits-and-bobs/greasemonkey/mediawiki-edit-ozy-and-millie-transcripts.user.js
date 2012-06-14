// ==UserScript==
// @name         mediawiki-edit-ozy-and-millie-transcripts
// @version      0.0.1
// @description  Provides auto-completions for the MediaWiki edit-box for aiding in transcripting the Ozy-and-Millie comics
// @author       Shlomi Fish ( http://www.shlomifish.org/ )
// @include      http://localhost/sites/mw1/index.php?title=Ozy_and_Millie_Transcripts*
// ==/UserScript==
// ===============================================================

//
// License is X11 License:
// http://www.opensource.org/licenses/mit-license.php

// Add jQuery
var GM_JQ = document.createElement('script');
GM_JQ.src = 'http://jquery.com/src/jquery-latest.js';
GM_JQ.type = 'text/javascript';
document.getElementsByTagName('head')[0].appendChild(GM_JQ);

// Check if jQuery's loaded
function GM_wait() {
    if(typeof unsafeWindow.jQuery == 'undefined') {
        window.setTimeout(GM_wait,100);
    }
    else {
        $ = unsafeWindow.jQuery;
        jQuery = unsafeWindow.jQuery;
        letsJQuery();
    }
}
GM_wait();

function myesc(s)
{
    return s.replace(/&/g,"&amp;").replace(/</g,"&lt;").replace(/>/g,"&gt;").replace(/"/g, "&quot;");
}

var timeout;

function autocomplete_box_on_press(e)
{
    clearTimeout(timeout);
    setTimeout(autocomplete_box, 10);
}

var ids_to_fullnames =
{
    "Av" : "Avery",
    "Dr" : "Dr. I. Wahnsinnig",
    "Fe" : "Felicia",
    "Is" : "Isolde",
    "Je" : "Jeremy",
    "La" : "Mr. Larnblatt",
    "Ll" : "Llewellyn",
    "Lo" : "Pirate Captain Locke",
    "Mi" : "Millie",
    "Ms" : "Ms. Mudd",
    "Oz" : "Ozy",
    "Pr" : "Principal Beau Vine",
    "So" : "Ms. Sorkowitz",
    "St" : "Stephan",
    "Ti" : "Timulty",
};

function autocomplete_box(not1, not2)
{
    var range = $("#wpTextbox1").getSelection();
    var elem = $("#wpTextbox1")[0];

    // Multiple chars selection
    if (range.start != range.end)
    {
        return;
    }

    var line_end = range.end;
    var line_start = line_end-1;

    while ((line_start >= 0) && (elem.value.substring(line_start,line_start+1) != "\n"))
    {
        line_start--;
    }
    line_start++;

    var line = elem.value.substring(line_start, line_end);

    var matches;
    if (matches = /^(\*\*?) *([A-Z][a-z])$/.exec(line))
    {
        var bullets = matches[1];
        var id = matches[2];

        if (ids_to_fullnames[id])
        {
            elem.value = elem.value.substring(0, line_start) + bullets + " " + "'''" + ids_to_fullnames[id] + "''': " + elem.value.substring(line_end);
        }
    }

    return;
}

// All your GM code must be inside this function
function letsJQuery()
{

    /*
 * jQuery plugin: fieldSelection - v0.1.0 - last change: 2006-12-16
 * (c) 2006 Alex Brem <alex@0xab.cd> - http://blog.0xab.cd
 */

(function() {

	var fieldSelection = {

		getSelection: function() {

			var e = this.jquery ? this[0] : this;

			return (

				/* mozilla / dom 3.0 */
				('selectionStart' in e && function() {
					var l = e.selectionEnd - e.selectionStart;
					return { start: e.selectionStart, end: e.selectionEnd, length: l, text: e.value.substr(e.selectionStart, l) };
				}) ||

				/* exploder */
				(document.selection && function() {

					e.focus();

					var r = document.selection.createRange();
					if (r == null) {
						return { start: 0, end: e.value.length, length: 0 }
					}

					var re = e.createTextRange();
					var rc = re.duplicate();
					re.moveToBookmark(r.getBookmark());
					rc.setEndPoint('EndToStart', re);

					return { start: rc.text.length, end: rc.text.length + r.text.length, length: r.text.length, text: r.text };
				}) ||

				/* browser not supported */
				function() {
					return { start: 0, end: e.value.length, length: 0 };
				}

			)();

		},

		replaceSelection: function() {

			var e = this.jquery ? this[0] : this;
			var text = arguments[0] || '';

			return (

				/* mozilla / dom 3.0 */
				('selectionStart' in e && function() {
					e.value = e.value.substr(0, e.selectionStart) + text + e.value.substr(e.selectionEnd, e.value.length);
					return this;
				}) ||

				/* exploder */
				(document.selection && function() {
					e.focus();
					document.selection.createRange().text = text;
					return this;
				}) ||

				/* browser not supported */
				function() {
					e.value += text;
					return this;
				}

			)();

		}

	};

	jQuery.each(fieldSelection, function(i) { jQuery.fn[i] = this; });

})();


    $("#wpTextbox1").keypress(autocomplete_box_on_press);

}

