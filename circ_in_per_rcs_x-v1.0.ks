local delay is 1.
local short_delay is 0.1.

local alignment_time is 10.
local rcs_thrust is 0.4.

local ener_dencity is velocity:orbit:mag ^ 2 / 2 - body:mu / (body:radius + altitude).
local s is sqrt(2 * (ener_dencity + body:mu / (body:radius + periapsis))).
local bt is time:seconds + ETA:periapsis - (sqrt(body:mu / (periapsis + body:radius)) - s) * ship:mass / (2 * rcs_thrust).

until time:seconds > bt - alignment_time {
    print("Time to alignment: " + round(bt - alignment_time - time:seconds) + " s").
    wait delay.
    clearScreen.
}

RCS on.
local direct is facing:upVector.
lock steering to lookDirUp(retrograde:vector, direct).

until time:seconds > bt {
    print("Time to burn: " + round(bt - time:seconds) + " s").
    wait delay.
    clearScreen.
}

set ship:control:fore to 1.
wait short_delay.
local orb_speed is sqrt(body:mu / (altitude + body:radius)).

until velocity:orbit:mag < orb_speed {
    print("Speed: " + round(velocity:orbit:mag) + " m / s").
    print("Orb speed: " + round(orb_speed) + " m / s").

    wait short_delay.
    clearScreen.
}

set ship:control:neutralize to true.
RCS off.
unlock steering.
wait delay.