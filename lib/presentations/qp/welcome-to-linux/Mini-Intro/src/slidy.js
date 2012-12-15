/* slidy.js

   Copyright (c) 2005 W3C (MIT, ERCIM, Keio), All Rights Reserved.
   W3C liability, trademark, document use and software licensing
   rules apply, see:

   http://www.w3.org/Consortium/Legal/copyright-documents
   http://www.w3.org/Consortium/Legal/copyright-software

   Modified by Shlomi Fish - rights disclaimed.
*/

window.onload = startup; // equivalent to onload on body element

var rtl_keys = false;
var lastShown = null; // last incrementally shown item
var lastShownBeginning = false;
var lastShownEnd = false;

/* general initialization */
function startup()
{
   lastShownBeginning = true;

   setVisibilityAllIncremental("hidden");

   document.onkeydown = keyDown;
}

function cancel(event)
{
  if (event)
  {
     event.cancel = true;
     event.returnValue = false;

    if (event.preventDefault)
      event.preventDefault();
  }

  return false;
}

function follow_link(accessor)
{
    var mylink = document.evaluate(
            "//a[@accesskey='" + accessor + "']",
            document.body, null,
            XPathResult.FIRST_ORDERED_NODE_TYPE,
            null
            );

    window.location = mylink.singleNodeValue.href;
}

//  See e.g. http://www.quirksmode.org/js/events/keys.html for keycodes
function keyDown(event)
{
    var key;

    if (!event)
      var event = window.event;

    // kludge around NS/IE differences
    if (window.event)
       key = window.event.keyCode;
    else if (event.which)
       key = event.which;
    else
       return true; // Yikes! unknown browser

    // ignore event if key value is zero
    // as for alt on Opera and Konqueror
    if (!key)
       return true;

    // check for concurrent control/command/alt key
    // but are these only present on mouse events?

    if (event.ctrlKey || event.altKey || event.metaKey)
       return true;

    if (key == 37) // Left arrow
    {
        lastShown = (!rtl_keys)
            ? hidePreviousItem(lastShown)
            : revealNextItem(lastShown)
            ;
       return cancel(event);
    }
    else if (key == 39) // Right arrow
    {
        lastShown = (!rtl_keys)
           ? revealNextItem(lastShown)
           : hidePreviousItem(lastShown)
           ;
       return cancel(event);
    }
    else if (key == 78) // N key
    {
        follow_link("n");
    }
    else if (key == 80) // P key
    {
        follow_link("p");
    }

    return true;
}

function getClassList(element)
{
  if (typeof window.pageYOffset =='undefined')
    return element.getAttribute("className");

  return element.getAttribute("class");
}

function hasClass(element, name)
{
  var regexp = new RegExp("(^| )" + name + "\W*");

  if (regexp.test(getClassList(element)))
    return true;

  return false;

}

// left to right traversal of root's content
function nextNode(root, node)
{
   if (node == null)
      return root.firstChild;

   if (node.firstChild)
      return node.firstChild;

   if (node.nextSibling)
      return node.nextSibling;

   for (;;)
   {
      node = node.parentNode;

      if (!node || node == root)
         break;

      if (node && node.nextSibling)
         return node.nextSibling;
   }

   return null;
}

// right to left traversal of root's content
function previousNode(root, node)
{
   if (node == null)
   {
      node = root.lastChild;

      if (node)
      {
         while (node.lastChild)
            node = node.lastChild;
      }

      return node;
   }

   if (node.previousSibling)
   {
      node = node.previousSibling;

      while (node.lastChild)
         node = node.lastChild;

      return node;
   }

   if (node.parentNode != root)
      return node.parentNode;

   return null;
}

function isIncrementalNode(node)
{
    if (node.nodeType == 1)  // ELEMENT
    {
        if (node.nodeName == "LI")
        {
            var ancestor = node;

            while (ancestor != document.body)
            {
                if (hasClass(ancestor, "point"))
                {
                    return true;
                }
                ancestor = ancestor.parentNode;
            }
        }
    }
    return false;
}

function nextIncrementalItem(node)
{
   for (;;)
   {
      node = nextNode(document.body, node);

      if (node == null || node.parentNode == null)
         break;

      if (isIncrementalNode(node))
      {
          return node;
      }
   }

   return node;
}

function previousIncrementalItem(node)
{
   for (;;)
   {
      node = previousNode(document.body, node);

      if (node == null || node.parentNode == null)
         break;

      if (isIncrementalNode(node))
      {
          return node;
      }
   }

   return node;
}

// set visibility for all elements on current slide with
// a parent element with attribute class="incremental"
function setVisibilityAllIncremental(value)
{
   var node = nextIncrementalItem(null);

   while (node)
   {
      node.style.visibility = value;
      node = nextIncrementalItem(node);
   }
}

// reveal the next hidden item on the slide
// node is null or the node that was last revealed
function revealNextItem(node)
{
   if (lastShownEnd)
   {
       return null;
   }
   node = nextIncrementalItem(node);
   lastShownBeginning = false;

   if (node && node.nodeType == 1)  // an element
      node.style.visibility = "visible";

   if (! node)
   {
        lastShownEnd = true;
   }

   return node;
}


// exact inverse of revealNextItem(node)
function hidePreviousItem(node)
{
   if (lastShownBeginning)
   {
       return null;
   }
   else if (lastShownEnd)
   {
       node = previousIncrementalItem(node);
   }

   if (node && node.nodeType == 1)  // an element
      node.style.visibility = "hidden";

   node = previousIncrementalItem(node);

   lastShownEnd = false;

   if (! node)
   {
       lastShownBeginning = true;
   }

   return node;
}

