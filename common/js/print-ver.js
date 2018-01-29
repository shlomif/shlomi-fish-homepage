$('#prnt_ver').html('<button id="prnt_ver_link">' +
    '<img src="/images/printer_icon.png" alt="Printer Icon" /> ' +
    'Print Version</button>');
$('#prnt_ver_link').click(function() {
    alert('The page is printable as it is. Just hit print preview and ' +
          'you\'ll be able to print it.');
});
