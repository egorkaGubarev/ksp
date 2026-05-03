local delay is 1.
local short_delay is 0.1.

local is_run is false.
local alignment_time is 10.

print("Transfer orbit ready").

until is_run {
    if not core:messages:empty {
        if core:messages:pop:content = "Enter Mun SOI" {
            set is_run to true.
        }
    }

    wait delay.
}

local ener_dencity is velocity:orbit:mag ^ 2 / 2 - body:mu / (body:radius + altitude).
local speed is sqrt(2 * (ener_dencity + body:mu / (body:radius + periapsis))).
local tdtb is (sqrt(body:mu / (periapsis + body:radius)) - speed) * ship:mass / (2 * availableThrust).

until ETA:periapsis < tdtb + alignment_time {
    print("Time to turn: " + round(ETA:periapsis - tdtb - alignment_time) + " s").
    wait delay.
    clearScreen.
}

RCS on.
local direct is facing:upVector.
lock steering to lookDirUp(retrograde:vector, direct).
print("Time to burn: " + alignment_time + " s").
wait alignment_time.
lock throttle to 1.
wait delay.
RCS off.
local orb_speed is sqrt(body:mu / (altitude + body:radius)).

until velocity:orbit:mag < orb_speed {
    print("Speed: " + round(velocity:orbit:mag) + " m / s").
    print("Orb speed: " + round(orb_speed) + " m / s").
    wait short_delay.
    clearScreen.
}

set ship:control:pilotMainThrottle to 0.
unlock throttle.
unlock steering.
processor("probe"):connection:sendMessage("Orbit achieved").