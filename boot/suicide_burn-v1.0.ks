local alt_stop is 70000.
local act_speed is 1.
local delay is 1.
local short_delay is 0.1.
local turn_time is 10.
local azimuth is 90.
local pitch to 90.
local par_alt is 2000.

local dist_burn is 1000.
local dt is 0.1.
local phys_dt is 0.1.

local eng is ship:partsTagged("land_eng")[0].
print("Burn ready").

until verticalSpeed < -act_speed {
    print("Vertical speed: " + round(verticalSpeed) + " m / s").
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

local force is eng:possibleThrust.
local start_mass is ship:mass.
local flow is eng:maxMassFlow.
local rad is body:radius.
local mu is body:mu.
local spec_en is verticalSpeed ^ 2 / 2 - mu / (rad + altitude).
local eps is sqrt(2 * (mu / (rad + alt_stop) + spec_en)) * phys_dt.
local err is 2 * eps.

until abs(err) < eps {
    clearScreen.
    print("Tolerance: " + round(eps) + " m").
    local t is 0.
    local altit is alt_stop + dist_burn.
    local speed is sqrt(2 * (mu / (rad + altit) + spec_en)).
    print("Burn alt: " + round(altit) + " m").
    wait delay.

    until speed < 0 {
        clearScreen.
        set speed to speed - (force / (start_mass - flow * t) - mu / (rad + altit) ^ 2) * dt.
        set altit to altit - speed * dt.
        set t to t + dt.
        print("Altitude: " + round(altit) + " m").
    }

    wait delay.
    print("Stop alt: " + round(altit) + " m").
    set err to altit - alt_stop - eps.
    set dist_burn to dist_burn - err.
    wait delay.
}

lock steering to heading(azimuth, pitch).
wait turn_time.

until altitude < alt_stop + dist_burn {
    wait short_delay.
}

lock throttle to 1.

until verticalSpeed > 0 {
    wait short_delay.
}

unlock throttle.
set ship:control:pilotMainThrottle to 0.
rcs off.

until alt:radar < par_alt {
    wait delay.
}

stage.