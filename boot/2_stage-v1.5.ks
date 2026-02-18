local delay is 1.
local long_delay is 10.

local meco is false.
local azim is 90.
local pitch is 30.
local target_apoaps is 75000.
local atmos_height is 70000.
local alignment_time is 60.

until meco {
    if not core:messages:empty {
        if core:messages:pop:content = "MECO" {
            set meco to true.
        }
    }

    wait delay.
}

lock throttle to 1.
lock steering to lookDirUp(heading(azim, pitch):vector, facing:upvector).
RCS on.
stage.
wait delay.
stage.

until apoapsis > target_apoaps {
    wait delay.
}

set ship:control:pilotMainThrottle to 0.
unlock throttle.
lock steering to lookDirUp(velocity:surface, facing:upvector).

until altitude > atmos_height {
    wait delay.
}

RCS off.
stage.
wait long_delay.
local ener_dencity is velocity:orbit:mag ^ 2 / 2 - body:mu / (body:radius + altitude).
local apoaps_speed is sqrt(2 * (ener_dencity + body:mu / (body:radius + apoapsis))).
local tdtb is (sqrt(body:mu / (apoapsis + body:radius)) - apoaps_speed) * ship:mass / (2 * availableThrust).

until ETA:apoapsis < tdtb + alignment_time {
    wait delay.
}

RCS on.
lock steering to lookDirUp(heading(azim, 0):vector, facing:upvector).

until ETA:apoapsis < tdtb {
    clearScreen.
    print("Time to burn: " + round(ETA:apoapsis - tdtb, 0) + " s").
    wait delay.
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