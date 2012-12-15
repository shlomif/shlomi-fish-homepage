$("h1[id],h2[id],h3[id],h4[id],h5[id],h6[id]").each(function(i){ $(this).append( ' <span class="selfl">[<a href="#' + this.id + '">link</a>]</span>' ) })
