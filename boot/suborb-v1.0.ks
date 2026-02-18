set delay to 1.
set separ_speed to -1.
set par_alt to 2000.

until aG1 {
    wait delay.
}

aG1 off.
stage.

until verticalSpeed < separ_speed {
    wait delay.
}

stage.

until alt:radar < par_alt {
    wait delay.
}

stage.