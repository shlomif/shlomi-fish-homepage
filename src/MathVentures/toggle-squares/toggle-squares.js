let N_squares = 5;
let count_of_ons = 0;

function set_N(new_n) {
    N_squares = new_n;
    count_of_ons = 0;
}

function get_min(x) {
    return Math.max(x - 1, 0);
}

function get_max(x) {
    return Math.min(x + 1, N_squares - 1);
}

let disable = false;
let disable_x = 0;
let disable_y = 0;

function press_button(x, y) {
    if (disable) {
        return;
    }
    disable = true;
    disable_x = x;
    disable_y = y;
    const min_x = get_min(x);
    const min_y = get_min(y);
    const max_x = get_max(x);
    const max_y = get_max(y);

    for (let ix=min_x; ix<=max_x; ++ix) {
        for (let iy=min_y; iy<=max_y; ++iy) {
            toggle_button(ix, iy);
        }
    }
    disable = false;
    return;
}

function toggle_button(ix, iy) {
    const button_name = 'button_' + ix + '_' + iy;
    const button_handle = $('#' + button_name);

    const old_state = button_handle.hasClass('on');
    const new_state = !old_state;

    button_handle.toggleClass('on');
    button_handle.toggleClass('off');
    if (true) { //if (! ((ix == disable_x) && (iy == disable_y))) {
        button_handle.prop('checked', new_state);
    }

    if (new_state) {
        ++count_of_ons;
        // button_handle.attr('alt', 'on');
    } else {
        --count_of_ons;
        // button_handle.attr('alt', 'off');
    }
}

function randomize_squares(new_N) {
    set_N(new_N);
    for (let x=0; x<N_squares; ++x) {
        for (let y=0; y<N_squares; ++y) {
            if (Math.random()*2 < 1) {
                press_button(x, y);
            }
        }
    }
}

function user_press_button(x, y) {
    press_button(x, y);
    if ((count_of_ons == 0) || (count_of_ons == (N_squares * N_squares))) {
        alert('Congratulations! You solved the game!');
    }
}
