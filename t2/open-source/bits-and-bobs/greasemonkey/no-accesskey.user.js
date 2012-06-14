/*
no-accesskey - remove Access Keys.

Changelog:
* 2005-04-28 - First version.

* 2006-01-12 -
    1. Converted elems[i].accessKey = "" to
    elems[i].setAttribute('accesskey', '').
    2. Calling the function directly instead of using window.onload.
*/
function accesskeys()
{
    var elems = document.getElementsByTagName("*");
    for (var i=0; i<elems.length; i++)
    {
        elems[i].setAttribute('accesskey','');
    }
}
accesskeys();
// window.onload = accesskeys;

