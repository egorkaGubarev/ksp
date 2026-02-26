local delay is 1.
local is_run is false.

print("Probe go for launch").

until is_run {
    if not core:messages:empty {
        if core:messages:pop:content = "SECO" {
            set is_run to true.
        }
    }

    wait delay.
}

processor("transfer_window"):connection:sendMessage("Ready").

until body = mun {
    wait delay.
}

processor("transfer_orbit"):connection:sendMessage("Enter Mun SOI").