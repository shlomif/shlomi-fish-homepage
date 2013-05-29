//
// Fake DeCSS for JavaScript - A hack of Hackers-IL
// version 0.2.2
//
// This code descrypts according to Julius Caesar's method of adding 3
// to the character code.
//


//
//    sec and key are both strings
//
function CSSdescramble(sec, key)
{
    var a;
    var ret = "";
    var c_code

    for (a = 0; a < sec.length ; a++)
    {
    	c_code = sec.charCodeAt(a);
    	ret += String.fromCharCode((c_code-3)%256);
    }

    return ret;
}

function encode_string_with_escape_sequences(str, on_one_line)
{
    var a;
    var len = str.length;
    var ret = "";
    var c, c_code;

    for( a = 0; a < len ; a++ )
    {
        c = str.charAt(a);
        if (c == "\n")
        {
            ret += "\\n";
        }
        else if (c == "\"")
        {
            ret += "\\\"";
        }
        else if (c == "\r")
        {
            ret += "\\r";
        }
        else if (c == "\f")
        {
            ret += "\\f";
        }
        else if (c == "\f")
        {
            ret += "\\f";
        }
        else if (c == "\t")
        {
            ret += "\\t";
        }
        else if (c == "\b")
        {
            ret += "\\b";
        }
        else if (c == "\\")
        {
            ret += "\\\\";
        }
        else
        {
            c_code = c.charCodeAt(0);
            if ((c_code < 32) || (c_code > 127))
            {
                // I'm using Octal notation even though I hate it because
                // it's easier than hex.
                ret += "\\" + Math.floor(c_code/64) + (Math.floor(c_code/8)%8) + (c_code % 8);
            }
            else
            {
                ret += c;
            }
        }

        if (! on_one_line)
        {
            // Add a newline every 20 characters
            if ((a % 20 == 0) && (a > 0))
            {
                ret += "\n";
            }
        }
    }

    return ret;
}

function char_to_digit(str)
{
    var my0 = "0";
    return str.charCodeAt(0) - my0.charCodeAt(0);
}

function decode_a_string_with_escape_sequences(str)
{
    var a;
    var c;
    var c_code;
    var ret = "";

    for(a=0;a<str.length;a++)
    {
        c = str.charAt(a);
        if ((c == "\n") || (c == "\r"))
        {
            // We ignore newlines so skip to the next character
            continue;
        }

        if (c != "\\")
        {
            ret += c;
        }
        else
        {
            a++;
            c = str.charAt(a);
            c_code = char_to_digit(c);
            if (c == "n")
            {
                ret += "\n";
            }
            else if (c == "r")
            {
                ret += "\r";
            }
            else if (c == "a")
            {
                ret += "\a";
            }
            else if (c == "t")
            {
                ret += "\t";
            }
            else if (c == "b")
            {
                ret += "\b";
            }
            else if (c == "f")
            {
                ret += "\f";
            }
            else if ((c_code >= 0) && (c_code <= 9))
            {
                var total;
                var num;

                total = 0;
                num = 1;

                while (((c_code >= 0) && (c_code <= 9)) && (num < 3))
                {
                    total = total*10 + c_code;

                    a++;
                    num++;
                    c = str.charAt(a);
                    c_code = c.charCodeAt(0);
                }

                ret += fromCharCode(total);
            }
            else
            {
                ret += c;
            }
        }
    }

    return ret;
}

