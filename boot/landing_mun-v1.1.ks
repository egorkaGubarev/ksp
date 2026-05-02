local delay is 1.
local short_delay is 0.1.
local turn_time is 20.

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