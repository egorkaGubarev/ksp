local delay is 1.
local long_delay is 10.

local meco is false.
local azim is 90.
local pitch is 30.
local target_apoaps is 75000.
local atmos_height is 70000.

print("Second stage ascent ready").

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
processor("2_stage_orbit"):connection:sendMessage("Fairing separation").