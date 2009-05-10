var board_html = "";
var n = 5;
var y, x;
board_html += "<table border=\"1\">";
for (y=0 ; y < n ; y++)
{
    board_html += "<tr>\n"
    for(x=0 ; x < n ; x++)
    {
        board_html += "<td>Hello";
        board_html += "</td>\n";
    }
    board_html += "</tr>\n";
}
board_html += "</table>\n";
$(document).ready(function() {
    $("#board").html(board_html);
    });
