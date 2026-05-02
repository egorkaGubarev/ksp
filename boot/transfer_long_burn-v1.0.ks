local delay is 1.
local short_delay is 0.1.
local alignment_delay is 10.

local azim is 90.

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

lock throttle to 1.
stage.
wait delay.
RCS off.

local targ_ap is (body:mu * body:rotationPeriod ^ 2 / (4 * constant:pi ^ 2)) ^ (1 / 3) - body:radius.
until apoapsis > targ_ap {
    print("Target apoapsis: " + round(targ_ap / 1000) + " km").
    print("Apoapsis: " + round(apoapsis / 1000) + " km").

    wait short_delay.
    clearScreen.
}

set ship:control:pilotMainThrottle to 0.
unlock throttle.
processor("probe"):connection:sendMessage("Transfer burn completed").