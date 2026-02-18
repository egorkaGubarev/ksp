local delay is 1.
local is_run is false.

print("Transfer module go for launch").

until is_run {
    if not core:messages:empty {
        if core:messages:pop:content = "Ready" {
            set is_run to true.
        }
    }

    wait delay.
}

local mun_angular_speed is 2 * constant:pi / mun:orbit:period.