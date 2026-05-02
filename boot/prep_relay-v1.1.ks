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
local ant_tags is list("relay", "downlink").

print("Probe go for launch").
wait_message("SECO", delay).
panels on.
wait delay.

for tag in ant_tags {
    ship:partsTagged(tag)[0]:getModule("moduleRTAntenna"):doEvent("activate").
    wait delay.
}

processor("transfer_window"):connection:sendMessage("Ready").
wait_message("Transfer burn completed", delay).
processor("transfer_orbit"):connection:sendMessage("Ready").
wait_message("Circ compl", delay).
stage.
wait delay.