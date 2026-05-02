set delay to 1.
set separ_speed to -1.
local azim is 0.
local start_pitch is 90.
local turn_rate is 1 / 10.
local final_pitch is 80.

print("First stage go for lauch").

until terminal:input:getChar() = " " {
    wait delay.
}

lock steering to heading(azim, max(start_pitch - velocity:surface:mag * turn_rate, final_pitch)).
stage.
wait delay.
stage.

until verticalSpeed < separ_speed {
    wait delay.
}

stage.
wait delay.
processor("probe"):connection:sendMessage("Descent").
unlock steering.