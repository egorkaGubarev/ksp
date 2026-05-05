local delay is 1.
local ver_mode is 0.

local ver_modes is lex(0: "off", 1: "pitch").

until false {
    if terminal:input:hasChar() {
        if terminal:input:getChar() = "v" {
            set ver_mode to mod(ver_mode + 1, 2).
        }

        print("Ver mode: " + ver_modes[ver_mode]).
    }

    wait delay.
}