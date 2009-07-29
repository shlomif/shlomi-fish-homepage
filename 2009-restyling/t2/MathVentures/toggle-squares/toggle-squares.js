var N_squares = 5;
var count_of_ons = 0;

function set_N(new_n)
{
    N_squares = new_n;
    count_of_ons = 0;
}

function get_min(x)
{
    if (x - 1 < 0)
    {
        return 0;
    }
    else
    {
        return x - 1;
    }
}

function get_max(x)
{
    if (x + 1 > N_squares - 1)
    {
        return N_squares-1;
    }
    else
    {
        return x + 1;
    }
}

function press_button(x, y)
{
    var min_x, max_x, min_y, max_y;
    var ix, iy;

    min_x = get_min(x);
    min_y = get_min(y);
    max_x = get_max(x);
    max_y = get_max(y);

    //document.mydebug.out.value += "Entering Press button (" + x + "," + y + ")\n";

    for(ix=min_x;ix<=max_x;ix++)
    {        
        for(iy=min_y;iy<=max_y;iy++)
        {
            //document.mydebug.out.value += "(" + ix + "," + iy + ")\n";
            toggle_button(ix,iy);
        }
    }
}

function toggle_button(ix,iy)
{
    var button_name = "button_" + ix + "_" + iy;
    var button_handle = $("#" + button_name);

    //document.mydebug.out.value += "SRC = " + button_handle.src + "\n";
    var old_src = button_handle.attr("src");
    //document.mydebug.out.value += "old_src_last = " + old_src_last + "\n";
    
    var old_state = (old_src == "1.png")
    var new_state = !old_state;

    if (new_state)
    {
        button_handle.attr("src", "1.png");
        count_of_ons++;
        button_handle.attr("alt", "on");
    }
    else
    {   
        button_handle.attr("src", "0.png");
        count_of_ons--;
        button_handle.attr("alt", "off");
    }
}

function randomize_squares(new_N)
{
    set_N(new_N);
    var x,y;
    for(x=0;x<N_squares;x++)
    {
        for(y=0;y<N_squares;y++)
        {
            if (Math.random()*2 < 1)
            {                
                press_button(x,y);
            }
        }
    }
}

function user_press_button(x, y)
{
    press_button(x, y);
    if ((count_of_ons == 0) || (count_of_ons == (N_squares * N_squares)))
    {
        alert("Congratulations! You solved the game!");
    }
}
