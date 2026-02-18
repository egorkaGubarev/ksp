local delay is 1.

local azim is 90.
local min_pitch is 30.
local turn_rate is 1 / 10.

print("First stage go for lauch").

until terminal:input:getChar() = " " {
    wait delay.
}

lock throttle to 1.
lock steering to lookDirUp(heading(azim, max(min_pitch, 90 - velocity:surface:mag * turn_rate)):vector, facing:upvector).
stage.
wait delay.
stage.

until availableThrust = 0 {
    wait delay.
}

set ship:control:pilotMainThrottle to 0.
unlock throttle.
processor("2_stage_ascent"):connection:sendMessage("MECO").