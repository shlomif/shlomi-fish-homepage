function setActiveStyleSheet() {  // select the stylesheet
    $('link').each(function (i, e) {
        var l = $(this);
        if (l.attr('media') == 'print') {
            e.disabled = false;
        } else {
            l.attr('disabled', 'disabled');
        }
    });
}

function addLoadEvent(func) {
    var oldonload = window.onload;
    if (typeof window.onload != 'function') {
        window.onload = func;
    } else {
        window.onload = function() {
            if (oldonload) {
                oldonload();
            }
            func();
        }
    }
}

addLoadEvent(function() {
    /* more code to run on page load */
    if (document.getElementById){
        //     add extra functions to page tools list
        var print_page = document.getElementById('print_preview');

        //     create print link
        var print_function = document.createElement('p');
        // print_function.setAttribute('class', 'print');
        //IE doesn't like this
        var print_function_link = document. createElement('a');
        print_function_link.onclick = function() { print_preview(); return false; }
        print_function_link.setAttribute('href', '#');
        var print_function_link_text = document.createTextNode('Print the Page');

        print_function_link.appendChild (print_function_link_text);
        print_function.appendChild (print_function_link);
        print_page.appendChild(print_function);
    }
});

function print_preview() {
    // Switch the stylesheet
    setActiveStyleSheet();

    // Create preview message
    add_preview_message();

    // Print the page
    window.print();
}

function add_preview_message(){
    var main_content = document.getElementById('content');
    var main_body = main_content.parentNode;

    if (document.getElementById){

        var preview_message = document.createElement  ('div');
        preview_message.id = 'preview-message';

        // Create Heading
        var preview_header = document.createElement('h3');
        var preview_header_text = document. createTextNode('This is a print preview of this page');
        preview_header.appendChild(preview_header_text);

        // Create paragraph
        var preview_para = document.createElement('p');
        var preview_para_text = document.createTextNode ('Without this message of course. ');

        var cancel_function_link = document.  createElement('a');
        cancel_function_link.onclick = function() { cancel_print_preview(); return false; };
        cancel_function_link.setAttribute('href',   '#');
        var cancel_function_link_text = document. createTextNode('Return to the existing page.');
        cancel_function_link.appendChild (cancel_function_link_text);
        preview_para.appendChild(preview_para_text); //
        preview_para.appendChild(cancel_function_link);

        // Put it all together
        preview_message.appendChild(preview_header);
        preview_message.appendChild(preview_para);
        main_body.insertBefore(preview_message,  main_content);

    }
}

function cancel_print_preview() {
}

$('#prnt_ver').html('<a href="#" id="prnt_ver_link">Print Version</a>');
$('#prnt_ver_link').click(function() {
    alert("The page is printable as it is. Just hit print preview and you'll be able to print it.");
});
