local delay is 1.
local short_delay is 1.
local alignment_time is 10.
local per is 20000.

RCS on.
wait delay.

if periapsis > per {
    lock steering to lookDirUp(-vXcl(up:vector, velocity:orbit), facing:upVector).
} else {
    lock steering to lookDirUp(vXcl(up:vector, velocity:orbit), facing:upVector).
}

print("Burn in " + alignment_time + " s").
wait alignment_time.
set ship:control:fore to 1.
wait short_delay.

if periapsis > per {
    until periapsis < per {
        print("Targ per: " + round(per / 1000) + " km").
        print("Per: " + round(periapsis / 1000) + " km").

        wait short_delay.
        clearScreen.
    }
} else {
    until periapsis > per {
        print("Targ per: " + round(per / 1000) + " km").
        print("Per: " + round(periapsis / 1000) + " km").

        wait short_delay.
        clearScreen.
    }
}


set ship:control:fore to 0.
RCS off.
wait delay.
unlock steering.