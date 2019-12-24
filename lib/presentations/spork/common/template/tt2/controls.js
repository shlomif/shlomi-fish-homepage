// BEGIN controls.js
function nextSlide() {
    window.location = '[% next_slide %]';
}

function prevSlide() {
    window.location = '[% prev_slide %]';
}

function indexSlide() {
    window.location = 'index.html';
}

function startSlide() {
    window.location = 'start.html';
}

function closeSlide() {
    window.close();
}

function handleKey(e) {
    const key = e.code;
    switch(key) {
        case 'ArrowLeft': prevSlide(); break;
        case 'Enter': nextSlide(); break;
        case 'Space': nextSlide(); break;
        // case 81: closeSlide(); break;
        case 'ArrowUp': indexSlide(); break;
        case 'PageDown': nextSlide(); break;
        case 'PageUp': prevSlide(); break;
        case 'Home': startSlide(); break;
        default: break; //xxx(e.which)
    }
}

document.addEventListener('keydown', handleKey);
[% IF mouse_controls -%]
document.onclick = nextSlide
[% END -%]
// END controls.js
