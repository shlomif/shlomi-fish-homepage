/*
 * Based on:
 *
 * https://stackoverflow.com/questions/21868789/dynamically-resize-iframe
 *
 * Thanks!
 * */
$(function () {
    //setup these vars only once since they are static
    let myIFRAME = $(".iframe-class"); //unless this collection of elements changes over time, you only need to select them once
    const ogWidth = 700;
    const ogHeight = 500;
    const ogRatio = ogHeight / ogWidth;
    let windowWidth = 0; //store windowWidth here, this is just a different way to store this data

    function setIFrameSize() {
        // if (windowWidth < 480) {
        if (true) {
            let parentDivWidth = myIFRAME.parent().width(); //be aware this will still only get the height of the first element in this set of elements, you'll have to loop over them if you want to support more than one iframe on a page
            let newHeight = parentDivWidth * ogRatio;

            const maxh = 600;
            if (newHeight > maxh) {
                const r = maxh / newHeight;
                newHeight *= r;
                parentDivWidth *= r;
            }

            myIFRAME
                .addClass("iframe-class-resize")
                .css({ height: newHeight, width: parentDivWidth });
        } else {
            myIFRAME
                .removeClass("iframe-class-resize")
                .css({ width: "", height: "" });
        }
    }
    {
        let resizeTimer = null;
        resizeTimer = setTimeout(function () {
            //make sure to update windowWidth before calling resize function
            windowWidth = $(window).width();

            setIFrameSize();
            clearTimeout(resizeTimer);
        }, 75);
    }

    {
        let resizeTimer = null;
        $(window)
            .resize(function () {
                //only run this once per resize event, if a user drags the window to a different size, this will wait until they finish, then run the resize function
                //this way you don't blow up someone's browser with your resize function running hundreds of times a second
                clearTimeout(resizeTimer);
                resizeTimer = setTimeout(function () {
                    //make sure to update windowWidth before calling resize function
                    windowWidth = $(window).width();

                    setIFrameSize();
                }, 75);
            })
            .trigger("click"); //run this once initially, just a different way to initialize
    }
});
