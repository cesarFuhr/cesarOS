#!/bin/python3
import subprocess

def screens():
    output = [l for l in subprocess.check_output(["xrandr"]).decode("utf-8").splitlines()]
    return [l.split()[0] for l in output if " connected " in l]

displays = screens()

hasHDMI = False
for display in displays:
    if display == "HDMI-0":
        hasHDMI = True

if hasHDMI == True:
    subprocess.run(["xrandr", "--output", "HDMI-0", "--mode", "3840x2160", "--primary"])
    subprocess.run(["xrandr", "--output", "DP-4", "--off"])
