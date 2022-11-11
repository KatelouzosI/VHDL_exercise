file delete -force work
vlib work
vmap work work

# Compile all

vcom -work work -2008 -explicit -stats=none fifo.vhd
vcom -work work -2008 -explicit -stats=none main_tb.vhd


vsim main_tb

# Add Waves

add wave -position insertpoint -group TB sim:/main_tb/*
add wave -position insertpoint -group DUT sim:/main_tb/DUT/*

# Run Simulation
run 1 ms