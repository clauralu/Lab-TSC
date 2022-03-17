onerror {resume}
quietly WaveActivateNextPane {} 0
add wave -noupdate /top/test_clk
add wave -noupdate /top/clk
add wave -noupdate /top/lab2_if/clk
add wave -noupdate /top/lab2_if/load_en
add wave -noupdate /top/lab2_if/reset_n
add wave -noupdate /top/lab2_if/opcode
add wave -noupdate /top/lab2_if/operand_a
add wave -noupdate /top/lab2_if/operand_b
add wave -noupdate /top/lab2_if/write_pointer
add wave -noupdate /top/lab2_if/read_pointer
add wave -noupdate /top/lab2_if/instruction_word
TreeUpdate [SetDefaultTree]
WaveRestoreCursors {{Cursor 1} {44 ps} 0}
configure wave -namecolwidth 150
configure wave -valuecolwidth 100
configure wave -justifyvalue left
configure wave -signalnamewidth 0
configure wave -snapdistance 10
configure wave -datasetprefix 0
configure wave -rowmargin 4
configure wave -childrowmargin 2
configure wave -gridoffset 0
configure wave -gridperiod 1
configure wave -griddelta 40
configure wave -timeline 0
configure wave -timelineunits ps
update
WaveRestoreZoom {0 ps} {110 ps}
