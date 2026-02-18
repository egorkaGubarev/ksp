set delay to 1.
set separ_speed to -1.
set par_alt to 2000.
set epsilon to 0.1.
set azimuth to 90.
set turn_rate to 1 / 100.
set ignition_speed to 100.

until aG1 {
    wait delay.
}

aG1 off.
stage.
wait delay.
stage.

until ship:availableThrust < epsilon {
    lock steering to lookDirUp(heading(azimuth, 90 - turn_rate * alt:radar):vector, ship:up:vector).
}

until ship:airSpeed < ignition_speed {
    wait delay.
}

stage.
wait delay.
stage.

until ship:availableThrust < epsilon {
    wait delay.
}

unlock steering.

until verticalSpeed < separ_speed {
    wait delay.
}

stage.

until alt:radar < par_alt {
    wait delay.
}

stage.