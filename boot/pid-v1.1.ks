local end is false.

local delay is 1.
local short_delay is 0.1.

local azim is 90.
local pitch is 90.
local target_alt is 200.
local p is 1 / 10.
local d is 1 / 10.

until aG1 {
    wait delay.
}

aG1 off.
lock throttle to 1.
stage.
wait delay.
lock steering to heading(azim, pitch).
stage.

until end {
    local thrust_offset is (target_alt - altitude) * p.
    local speed_offset is -verticalSpeed * d.
    local base_throttle is ship:mass * body:mu / ((body:radius + altitude) ^ 2 * availableThrust).
    lock throttle to base_throttle * (1 + thrust_offset + speed_offset).
    wait short_delay.
}