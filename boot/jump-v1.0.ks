local delay is 1.
local short_delay is 0.1.

local azim is 90.
local pitch is 90.
local target_alt is 200.
local p is 1 / 10.
local d is 1 / 10.

local landing_fuel_ratio is 0.3.
local descet_altit_per_speed is 10.
local legs_deploy_altit is 10.
local landing_speed is 1.

until aG1 {
    wait delay.
}

aG1 off.
local max_fuel is ship:liquidFuel.
lock throttle to 1.
stage.
wait delay.
lock steering to heading(azim, pitch).
stage.

until ship:liquidFuel < landing_fuel_ratio * max_fuel {
    local thrust_offset is (target_alt - altitude) * p.
    local speed_offset is -verticalSpeed * d.
    local base_throttle is ship:mass * body:mu / ((body:radius + altitude) ^ 2 * availableThrust).
    lock throttle to base_throttle * (1 + thrust_offset + speed_offset).
    wait short_delay.
}

until alt:radar < legs_deploy_altit {
    local speed_offset is -(verticalSpeed + alt:radar / descet_altit_per_speed) * d.
    local base_throttle is ship:mass * body:mu / ((body:radius + altitude) ^ 2 * availableThrust).
    lock throttle to base_throttle * (1 + speed_offset).
    wait short_delay.
}

gear on.

until status = "landed" {
    local speed_offset is -(verticalSpeed + landing_speed) * d.
    local base_throttle is ship:mass * body:mu / ((body:radius + altitude) ^ 2 * availableThrust).
    lock throttle to base_throttle * (1 + speed_offset).
    wait short_delay.
}

unlock throttle.
set ship:control:pilotMainThrottle to 0.
unlock steering.