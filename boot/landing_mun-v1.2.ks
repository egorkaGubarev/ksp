local delay is 1.
local short_delay is 0.1.
local turn_time is 20.
local phys_dt is 0.1.
local dt is 0.1.

local azim is 90.
local pitch is 90.
local d is 1 / 10.

local landing_sun_angle is 45.
local descet_altit_per_speed is 10.
local legs_deploy_altit is 10.
local landing_speed is 1.

function wait_message {
    parameter message.
    parameter delay_time.

    local recieved is false.

    until recieved {
        if not core:messages:empty {
            if core:messages:pop:content = message {
                set recieved to true.
            }
        }

        wait delay_time.
    }
}

local eng is ship:partsTagged("land_eng")[0].
print("Lander go for launch").

wait_message("SECO", delay).
processor("transfer_window"):connection:sendMessage("Ready").

until body = mun {
    wait delay.
}

processor("transfer_orbit"):connection:sendMessage("Enter Mun SOI").
wait_message("Orbit achieved", delay).

stage.
wait delay.
lock sun_angle to vAng(ship:position - body:position, body("sun"):position - body:position).

until sun_angle < landing_sun_angle {
    print("Sun angle: " + round(sun_angle) + " deg").
    print("Target angle: " + round(landing_sun_angle) + " deg").

    wait delay.
    clearScreen.
}

stage.
wait delay.
RCS on.
lock hor_speed to vXcl(up:vector, velocity:surface).
lock steering to lookDirUp(-hor_speed, Up:Vector).
wait turn_time.
lock throttle to 1.

until hor_speed:mag < 10 {
    wait short_delay.
}

lock throttle to 0.1.

until hor_speed:mag < 0.5 {
    wait short_delay.
}

lock throttle to 0.
lock steering to heading(azim, pitch).
wait turn_time.

local alt_stop is ship:geoPosition:terrainHeight.
local force is eng:possibleThrust.
local start_mass is ship:mass.
local flow is eng:maxMassFlow.
local rad is body:radius.
local mu is body:mu.
local spec_en is verticalSpeed ^ 2 / 2 - mu / (rad + altitude).
local eps is sqrt(2 * (mu / (rad + alt_stop) + spec_en)) * phys_dt.
local err is 2 * eps.
local dist_burn is 1000.

until abs(err) < eps {
    clearScreen.
    local t is 0.
    local altit is alt_stop + dist_burn.
    local speed is sqrt(2 * (mu / (rad + altit) + spec_en)).
    print("Burn alt: " + round(altit) + " m").
    wait delay.

    until speed < 0 {
        set speed to speed - (force / (start_mass - flow * t) - mu / (rad + altit) ^ 2) * dt.
        set altit to altit - speed * dt.
        set t to t + dt.
    }

    wait delay.
    print("Stop alt: " + round(altit) + " m").
    set err to altit - alt_stop - eps.
    set dist_burn to dist_burn - err.
    wait delay.
}

print("Accepted").

until altitude < alt_stop + dist_burn {
    wait short_delay.
}

lock throttle to 1.

until verticalSpeed > 0 {
    wait short_delay.
}

unlock throttle.
set ship:control:pilotMainThrottle to 0.

until alt:radar < legs_deploy_altit {
    local speed_offset is -(verticalSpeed + alt:radar / descet_altit_per_speed) * d.
    local base_throttle is ship:mass * body:mu / ((body:radius + altitude) ^ 2 * availableThrust).
    lock throttle to base_throttle + speed_offset.
    wait short_delay.
}

gear on.

until status = "landed" {
    local speed_offset is -(verticalSpeed + landing_speed) * d.
    local base_throttle is ship:mass * body:mu / ((body:radius + altitude) ^ 2 * availableThrust).
    lock throttle to base_throttle + speed_offset.
    wait short_delay.
}

RCS off.

unlock throttle.
set ship:control:pilotMainThrottle to 0.
unlock steering.