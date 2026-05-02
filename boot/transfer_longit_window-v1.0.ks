local delay is 1.

local burn_angle_toler is 1.
local burn_angle_offset is 3.

local target_long is 180.

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
local target_absol_longit is base_long + target_long.

if target_absol_longit > 180 {
    set target_absol_longit to target_absol_longit - 360.
} else {
    if target_absol_longit < -180 {
        set target_absol_longit to target_absol_longit + 360.
    }
}

lock current_angle to mod(target_absol_longit - geoPosition:lng + 360, 360).
stage.
wait delay.

until abs(current_angle - burn_angle - burn_angle_offset) < burn_angle_toler {
    print("Burn angle: " + round(burn_angle) + " deg").
    print("Current angle: " + round(current_angle) + " deg").

    wait delay.
    clearScreen.
}

processor("transfer_burn"):connection:sendMessage("Window ready").