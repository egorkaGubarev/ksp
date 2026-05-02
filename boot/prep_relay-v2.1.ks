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

local delay is 1.

print("Probe go for launch").
wait_message("SECO", delay).
panels on.
wait delay.
ship:partsTagged("downlink")[0]:getModule("moduleRTAntenna"):doEvent("activate").
wait delay.
processor("transfer_window"):connection:sendMessage("Ready").
wait_message("Transfer burn completed", delay).
processor("transfer_orbit"):connection:sendMessage("Ready").
wait_message("Circ compl", delay).
stage.
wait delay.
processor("set_per"):connection:sendMessage("Ready").
wait_message("Per corr", delay).
processor("circ"):connection:sendMessage("Ready").
wait_message("Circ", delay).
ship:partsTagged("relay")[0]:getModule("moduleRTAntenna"):doEvent("activate").
wait delay.