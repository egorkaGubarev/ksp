local stop is false.
local active is false.
local delay is 10.

local start_charge is 20.
local stop_charge is 80.

local total is ship:partsTagged("bat")[0]:resources[0]:amount.
lock current to ship:partsTagged("bat")[0]:resources[0]:amount * 100 / total.

local cell is ship:partsTagged("cell")[0]:getModule("moduleResourceConverter").

until stop {
    clearScreen.
    print("Charge: " + round(current) + " %").

    if active {
        print("Charge").

        if current > stop_charge {
            cell:doEvent("Stop Fuel Cell").
            set active to false.
        }
    } else {
        print("Stop").

        if current < start_charge {
            cell:doEvent("Start Fuel Cell").
            set active to true.
        }
    }

    wait delay.
}