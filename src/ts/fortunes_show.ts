let altDown: boolean = false;

document.addEventListener("keydown", (ev) => {
    if (ev.keyCode === 18) {
        altDown = true;
    } else if (ev.keyCode === 82 && altDown) {
        gotoRandom();
    }
});

document.addEventListener("keyup", (ev) => {
    if (ev.keyCode == 18) {
        altDown = false;
    }
});

function gotoRandom(): void {
    window.location.href = "?mode=random";
}
