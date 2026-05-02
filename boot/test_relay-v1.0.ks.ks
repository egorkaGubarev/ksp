local delay is 1.
local ant_tags is list("relay", "downlink").

print("Probe go for test").

until terminal:input:getChar() = " " {
    wait delay.
}

panels on.
wait delay.

for tag in ant_tags {
    ship:partsTagged(tag)[0]:getModule("moduleRTAntenna"):doEvent("activate").
    wait delay.
}