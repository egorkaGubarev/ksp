local delay is 1.
local short_delay is 0.1.
local alignment_delay is 10.

local azim is 90.
local trnazit_altit is 20000.

print("Transfer burn ready").
local is_run is false.

until is_run {
    if not core:messages:empty {
        if core:messages:pop:content = "Window ready" {
            set is_run to true.
        }
    }

    wait delay.
}

RCS on.
lock steering to lookDirUp(heading(azim, 0):vector, facing:upVector).
local burn_time is time:seconds + alignment_delay.

until time:seconds > burn_time {
    print("Time to burn: " + round(burn_time - time:seconds) + " s").
    wait delay.
    clearScreen.
}

local target_apoaps is mun:orbit:semiMajorAxis - kerbin:radius.
lock throttle to 1.
stage.
wait delay.
RCS off.

until orbit:hasNextPatch {
    print("Target apoapsis: " + round(target_apoaps / 1000) + " km").
    print("Apoapsis: " + round(apoapsis / 1000) + " km").

    wait short_delay.
    clearScreen.
}

set ship:control:pilotMainThrottle to 0.
unlock throttle.
wait delay.
RCS on.
wait delay.
set ship:control:fore to 1.

until orbit:nextPatch:periapsis < trnazit_altit {
    print("Target tranzit altitude: " + round(trnazit_altit / 1000) + " km").
    print("Tranzit altitude: " + round(orbit:nextPatch:periapsis / 1000) + " km").

    wait short_delay.
    clearScreen.
}

set ship:control:fore to 0.
RCS off.
wait delay.
unlock steering.