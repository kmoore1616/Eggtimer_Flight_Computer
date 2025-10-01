sdcc -mstm8 -c main.c -o tmp/main.rel
sdcc -mstm8 -c tim.c  -o tmp/tim.rel

sdcc -mstm8 tmp/main.rel tmp/tim.rel -o tmp/firmware.ihx

packihx tmp/firmware.ihx 
