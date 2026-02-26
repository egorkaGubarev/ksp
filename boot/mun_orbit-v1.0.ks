local delay is 1.
local short_delay is 0.1.

local is_run is false.
local target_orbit is 10000.
local safe_periapsis is 5000.
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
    wait delay.
}

RCS on.
local direct is facing:upVector.
lock steering to lookDirUp(retrograde:vector, direct).

until ETA:periapsis < tdtb {
    print("Time to burn: " + round(ETA:periapsis - tdtb, 0) + " s").
    wait delay.
    clearScreen.
}

lock throttle to 1.
wait delay.
RCS off.

until apoapsis < target_orbit or periapsis < safe_periapsis {
    print("Apoapsis: " + round(apoapsis / 1000) + " km").
    print("Periapsis: " + round(periapsis / 1000) + " km").
    print("Target orbit: " + round(target_orbit / 1000) + " km").
    print("Safe periapsis: " + round(safe_periapsis / 1000) + " km").
    wait short_delay.
}

set ship:control:pilotMainThrottle to 0.
unlock throttle.
unlock steering.