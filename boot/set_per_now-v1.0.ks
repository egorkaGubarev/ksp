local delay is 1.
local short_delay is 1.
local alignment_time is 10.
local per is 2863000.

print("Periapsis correction ready").
local recieved is false.

until recieved {
    if not core:messages:empty {
        if core:messages:pop:content = "Ready" {
            set recieved to true.
        }
    }

    wait delay.
}

RCS on.
wait delay.
lock steering to lookDirUp(-velocity:orbit, facing:upVector).
print("Burn in " + alignment_time + " s").
wait alignment_time.
set ship:control:fore to 1.
wait short_delay.

until periapsis < per {
    print("Targ per: " + round(per / 1000) + " km").
    print("Per: " + round(periapsis / 1000) + " km").

    wait short_delay.
    clearScreen.
}

set ship:control:fore to 0.
RCS off.
wait delay.
unlock steering.
processor("probe"):connection:sendMessage("Per corr").