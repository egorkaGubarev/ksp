local delay is 1.
local short_delay is 0.1.

local azim is 102.
local target_speed is 50.
local p_speed is 1 / 100.

local landing_fuel_ratio is 0.3.

until aG2 {
    wait delay.
}

aG2 off.
print("Steering on").
local direct_vector is heading(azim, 0):vector.
local max_fuel is ship:liquidFuel.
local target_vector is up:vector + (target_speed * direct_vector - vXcl(up:vector, velocity:surface)) * p_speed.
lock steering to lookDirUp(target_vector, ship:up:vector).

until ship:liquidFuel < landing_fuel_ratio * max_fuel {
    set target_vector to up:vector + (target_speed * direct_vector - vXcl(up:vector, velocity:surface)) * p_speed.
    wait short_delay.
}

until status = "landed" {
    set target_vector to up:vector - vXcl(up:vector, velocity:surface) * p_speed.
    wait short_delay.
}

unlock steering.