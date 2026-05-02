local delay is 1.
local short_delay is 0.1.

local is_run is false.
local azim is 90.
local alignment_time is 10.

print("Circularization ready").

until is_run {
    if not core:messages:empty {
        if core:messages:pop:content = "Ready" {
            set is_run to true.
        }
    }

    wait delay.
}

local ener_dencity is velocity:orbit:mag ^ 2 / 2 - body:mu / (body:radius + altitude).
local apoaps_speed is sqrt(2 * (ener_dencity + body:mu / (body:radius + apoapsis))).
local orb_speed is sqrt(body:mu / (apoapsis + body:radius)).
local tdtb is (orb_speed - apoaps_speed) * ship:mass / (2 * availableThrust).

until ETA:apoapsis < tdtb + alignment_time {
    print("Time to burn: " + round(ETA:apoapsis - tdtb - alignment_time) + " s").
    wait delay.
    clearScreen.
}

RCS on.
local direct is facing:upVector.
lock steering to lookDirUp(heading(azim, 0):vector, direct).

until ETA:apoapsis < tdtb {
    print("Time to burn: " + round(ETA:apoapsis - tdtb) + " s").
    wait delay.
    clearScreen.
}

lock throttle to 1.
wait delay.
RCS off.

until velocity:orbit:mag > orb_speed {
    print("Speed: " + round(velocity:orbit:mag) + " m / s").
    print("Orbit speed: " + round(orb_speed) + " m / s").
    wait short_delay.
    clearScreen.
}

set ship:control:pilotMainThrottle to 0.
unlock throttle.
unlock steering.
processor("probe"):connection:sendMessage("Circ compl").