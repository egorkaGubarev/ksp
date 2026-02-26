local delay is 1.

local is_run is false.
local azim is 90.
local atmos_height is 70000.
local alignment_time is 60.

print("Second stage orbit ready").

until is_run {
    if not core:messages:empty {
        if core:messages:pop:content = "Fairing separation" {
            set is_run to true.
        }
    }

    wait delay.
}

local ener_dencity is velocity:orbit:mag ^ 2 / 2 - body:mu / (body:radius + altitude).
local apoaps_speed is sqrt(2 * (ener_dencity + body:mu / (body:radius + apoapsis))).
local tdtb is (sqrt(body:mu / (apoapsis + body:radius)) - apoaps_speed) * ship:mass / (2 * availableThrust).

until ETA:apoapsis < tdtb + alignment_time {
    wait delay.
}

RCS on.
local direct is facing:upVector.
lock steering to lookDirUp(heading(azim, 0):vector, direct).

until ETA:apoapsis < tdtb {
    print("Time to burn: " + round(ETA:apoapsis - tdtb, 0) + " s").
    wait delay.
    clearScreen.
}

lock throttle to 1.
wait delay.
RCS off.

until periapsis > atmos_height {
    wait delay.
}

set ship:control:pilotMainThrottle to 0.
unlock throttle.
unlock steering.
processor("probe"):connection:sendMessage("SECO").