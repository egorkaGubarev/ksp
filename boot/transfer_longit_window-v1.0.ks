local delay is 1.

local burn_angle_toler is 1.
local burn_angle_offset is 3.

local target_long is 0.

print("Transfer window calculation ready").
local is_run is false.
local base_long is geoPosition:lng.

until is_run {
    if not core:messages:empty {
        if core:messages:pop:content = "Ready" {
            set is_run to true.
        }
    }

    wait delay.
}

local sync_rad is (body:mu * body:rotationPeriod ^ 2 / (4 * constant:pi ^ 2)) ^ (1 / 3).
local semi_major_axis is (orbit:semiMajorAxis + sync_rad) / 2.
local period is mun:orbit:period * (semi_major_axis / mun:orbit:semiMajorAxis) ^ (3 / 2).
local burn_angle is 180 * (1 - period / body:rotationPeriod).
lock mun_vector to mun:position - kerbin:position.
lock is_approaching to vAng(mun_vector, velocity:orbit) < 90.
local current_angle is 0.

if is_approaching {
    set current_angle to vAng(mun_vector, ship:position - kerbin:position).
} else {
    set current_angle to 360 - vAng(mun_vector, ship:position - kerbin:position).
}

local target_absol_longit is base_long + target_long.

if target_absol_longit > 180:


local current_angle is geoPosition:lng - target_absol_longit.

stage.
wait delay.

until is_approaching and abs(current_angle - burn_angle - burn_angle_offset) < burn_angle_toler {
    if is_approaching {
        set current_angle to vAng(mun_vector, ship:position - kerbin:position).
    } else {
        set current_angle to 360 - vAng(mun_vector, ship:position - kerbin:position).
    }

    print("Burn angle: " + round(burn_angle) + " deg").
    print("Current angle: " + round(current_angle) + " deg").

    wait delay.
    clearScreen.
}

processor("transfer_burn"):connection:sendMessage("Window ready").