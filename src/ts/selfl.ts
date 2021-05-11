function add_self_links(): void {
    const myclass: string = "self_link";
    if (!$("body").hasClass(myclass)) {
        $("h1[id],h2[id],h3[id],h4[id],h5[id],h6[id]").each(function (i) {
            const that = this;
            $(that).append(
                '<span class="selfl"> <a href="#' +
                    that.id +
                    '" title="Get an anchor to this part of the page">¶</a></span>',
            );
        });
        $("body").addClass(myclass);
    }
}

$(add_self_links);
