# Step 1: Compile each C file to .rel object files
sdcc -mstm8 -c main.c
sdcc -mstm8 -c tim.c

# Step 2: Link into one firmware .ihx
sdcc -mstm8 main.rel tim.rel -o firmware.ihx

# Step 3: Convert .ihx to .hex
packihx firmware.ihx > firmware.hex

