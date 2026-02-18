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

processor("transfer"):connection:sendMessage("Ready").