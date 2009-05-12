var board_html = "";
var n = 5;
var y, x;
board_html += "<table class=\"game\">";

function button_html(x, y, value)
{
    return (
        "<img src=\"" + 
        (value ? "1.png" : "0.png") + 
        "\" alt=\"" + 
        (value ? "white" : "black") + 
        "\" id=\"button_" + x + "_" + y + "\"" + 
        "onclick=\"press_button(" + x + "," + y + "); return false;\" />"
        );
}


for (y=0 ; y < n ; y++)
{
    board_html += "<tr>";
    for(x=0 ; x < n ; x++)
    {
        board_html += "<td>" + button_html(x,y,false) + "</td>";
    }
    board_html += "</tr>";
}
board_html += "</table>\n";
$(document).ready(function() {
    $("#board").html(board_html);
    randomize_squares();
    });
