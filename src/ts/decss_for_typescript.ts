"use strict";
//
// Fake DeCSS for JavaScript - A hack of Hackers-IL
// version 0.2.2
//
// This code descrypts according to Julius Caesar's method of adding 3
// to the character code.
//

//
//    scrambled_input_str and key are both strings
//
function css_descramble(scrambled_input_str: string, key: string): string {
    let ret: string = "";

    for (const c of scrambled_input_str) {
        ret += String.fromCharCode((c.charCodeAt(0) - 3 + 256) % 256);
    }

    return ret;
}

function encode_string_with_escape_sequences(
    str: string,
    on_one_line: boolean,
): string {
    const len: number = str.length;
    let ret: string = "";

    for (let a = 0; a < len; ++a) {
        const c = str.charAt(a);
        if (c == "\n") {
            ret += "\\n";
        } else if (c == '"') {
            ret += '\\"';
        } else if (c == "\r") {
            ret += "\\r";
        } else if (c == "\f") {
            ret += "\\f";
        } else if (c == "\t") {
            ret += "\\t";
        } else if (c == "\b") {
            ret += "\\b";
        } else if (c == "\\") {
            ret += "\\\\";
        } else {
            const c_code = c.charCodeAt(0);
            if (c_code < 32 || c_code > 127) {
                // I'm using Octal notation even though I hate it because
                // it's easier than hex.
                ret +=
                    "\\" +
                    Math.floor(c_code / 64) +
                    (Math.floor(c_code / 8) % 8) +
                    (c_code % 8);
            } else {
                ret += c;
            }
        }

        if (!on_one_line) {
            // Add a newline every 20 characters
            if (a % 20 == 0 && a > 0) {
                ret += "\n";
            }
        }
    }

    return ret;
}

function char_to_digit(str: string): number {
    const my0: string = "0";
    return str.charCodeAt(0) - my0.charCodeAt(0);
}

function decode_a_string_with_escape_sequences(str: string): string {
    let ret: string = "";
    const len = str.length;

    for (let a = 0; a < len; ++a) {
        let c = str.charAt(a);
        if (c == "\n" || c == "\r") {
            // We ignore newlines so skip to the next character
            continue;
        }

        if (c != "\\") {
            ret += c;
        } else {
            ++a;
            c = str.charAt(a);
            let c_code = char_to_digit(c);
            const is_digit = () => {
                return c_code >= 0 && c_code <= 9;
            };
            if (c == "n") {
                ret += "\n";
            } else if (c == "r") {
                ret += "\r";
            } else if (c == "a") {
                ret += "a";
            } else if (c == "t") {
                ret += "\t";
            } else if (c == "b") {
                ret += "\b";
            } else if (c == "f") {
                ret += "\f";
            } else if (is_digit()) {
                let total: number = 0;
                let num: number = 1;

                while (is_digit() && num < 3) {
                    total = total * 10 + c_code;

                    ++a;
                    ++num;
                    c = str.charAt(a);
                    c_code = c.charCodeAt(0);
                }

                ret += String.fromCharCode(total);
            } else {
                ret += c;
            }
        }
    }

    return ret;
}
