let n = -1;

function button_html(x, y, value) {
    return (
        "<img src=\"" +
        (value ? "1.png" : "0.png") +
        "\" alt=\"" +
        (value ? "white" : "black") +
        "\" id=\"button_" + x + "_" + y + "\" " +
        "onclick=\"user_press_button(" + x + "," + y + "); return false;\" />"
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
