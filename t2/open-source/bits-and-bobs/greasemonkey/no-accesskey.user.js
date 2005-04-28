function accesskeys()
{
    var elems = document.getElementsByTagName("*");
    for (var i=0; i<elems.length; i++)
    {
        elems[i].accessKey = "";
    }
}
window.onload = accesskeys;

