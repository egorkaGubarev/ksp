set delay to 1.
set par_alt to 3000.
set epsilon to 0.1.
set azimuth to 90.
set turn_rate to 1 / 10.
set min_pitch to 20.
set separ_alt to 70000.

until aG1 {
    wait delay.
}

aG1 off.
lock throttle to 1.
wait delay.
stage.
wait delay.
stage.

until ship:availableThrust < epsilon {
    lock steering to heading(azimuth, max(90 - turn_rate * ship:airSpeed, min_pitch)).
}

unlock steering.
lock throttle to 0.

until alt:radar > separ_alt {
    wait delay.
}

stage.
wait delay.
stage.
wait delay.
stage.

until alt:radar < par_alt {
    wait delay.
}

stage.