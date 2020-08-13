let n = -1;

function button_html(x, y, value) {
    return (
        "<input type=\"checkbox\" class=\"" +
        (value ? "on" : "off") +
        "\" " + (value ? " checked=\"checked\" " : "") +
        " id=\"button_" + x + "_" + y + "\" " +
        // "onchange=\"user_press_button(" + x + "," + y + "); return false;\" onclick=\"return false;\" />"
        "onclick=\"user_press_button(" + x + "," + y + "); return true;\" onchange=\"return true;\" />"
        );
}


function generate_board() {
    let board_html = "";

    n = parseInt($("#num_squares").val());

    board_html += "<table class=\"game\">";

    for (let y=0; y < n; y++) {
        board_html += "<tr>";
        for (let x=0; x < n; x++) {
            board_html += "<td>" + button_html(x, y, false) + "</td>";
        }
        board_html += "</tr>";
    }

    board_html += "</table>";

    $("#board").html(board_html);
    randomize_squares(n);
}

$(document).ready(function() {
        generate_board();
    });
