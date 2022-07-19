let altDown = false;

document.addEventListener("keydown", (ev) => {
    if (ev.keyCode === 18) {
        altDown = true;
    } else if (ev.keyCode === 82 && altDown) {
        pressRandomButton();
    }
});

document.addEventListener("keyup", (ev) => {
    if (ev.keyCode == 18) {
        altDown = false;
    }
});

function pressRandomButton() {
    // console.log("Random button pressed!");
    window.location.href = "?mode=random";
}
