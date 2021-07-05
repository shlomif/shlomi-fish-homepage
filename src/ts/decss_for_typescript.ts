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

let encode_map = new Map<string, string>([
    ["\b", "b"],
    ["\f", "f"],
    ["\n", "n"],
    ["\r", "r"],
    ["\t", "t"],
    ["\\", "\\"],
    ['"', '"'],
]);
function encode_string_with_escape_sequences(
    str: string,
    on_one_line: boolean,
): string {
    const len: number = str.length;
    let ret: string = "";

    for (let a = 0; a < len; ++a) {
        const c = str.charAt(a);
        const found = encode_map.has(c);
        if (found) {
            ret += "\\" + encode_map.get(c);
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

const my0: number = "0".charCodeAt(0);
function char_to_digit(str: string): number {
    return str.charCodeAt(0) - my0;
}

function decode_a_string_with_escape_sequences(str: string): string {
    let ret: string = "";
    const len = str.length;

    for (let char_index = 0; char_index < len; ++char_index) {
        let char_val: string = str.charAt(char_index);
        if (char_val == "\n" || char_val == "\r") {
            // We ignore newlines so skip to the next character
            continue;
        }

        if (char_val != "\\") {
            ret += char_val;
        } else {
            ++char_index;
            char_val = str.charAt(char_index);
            let c_code = char_to_digit(char_val);
            const is_digit = () => {
                return c_code >= 0 && c_code <= 9;
            };
            if (char_val == "n") {
                ret += "\n";
            } else if (char_val == "r") {
                ret += "\r";
            } else if (char_val == "a") {
                ret += "a";
            } else if (char_val == "t") {
                ret += "\t";
            } else if (char_val == "b") {
                ret += "\b";
            } else if (char_val == "f") {
                ret += "\f";
            } else if (is_digit()) {
                let total: number = 0;
                let num: number = 1;

                while (is_digit() && num < 3) {
                    total = total * 10 + c_code;

                    ++char_index;
                    ++num;
                    char_val = str.charAt(char_index);
                    c_code = char_val.charCodeAt(0);
                }

                ret += String.fromCharCode(total);
            } else {
                ret += char_val;
            }
        }
    }

    return ret;
}
