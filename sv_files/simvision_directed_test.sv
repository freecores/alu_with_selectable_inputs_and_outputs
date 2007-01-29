# SimVision Command Script (Sat Jan 06 15:05:30 EET 2007)
#
# Version 05.50.s003
#
# You can restore this configuration with:
#
# simvision -input simvision_ac.sv
# or
# simvision -input simvision_ac.sv database1 database2 ...
#

#
# preferences
#
preferences set signal-type-colors {
	group #0000FF
	overlay #0000FF
	input #FFFF00
	output #FFA500
	inout #00FFFF
	internal #00FF00
	fiber #FF99FF
	errorsignal #FF0000
	assertion #FF0000
	unknown #FFFFFF
}
preferences set sb-syntax-types {
    {-name "VHDL/VHDL-AMS" -cleanname "vhdl" -extensions {.vhd .vhdl}}
    {-name "Verilog/Verilog-AMS" -cleanname "verilog" -extensions {.v .vams .vms .va}}
    {-name "C" -cleanname "c" -extensions {.c}}
    {-name "C++" -cleanname "c++" -extensions {.h .hpp .cc .cpp .CC}}
    {-name "SystemC" -cleanname "systemc" -extensions {.h .hpp .cc .cpp .CC}}
}
preferences set toolbar-Windows-SrcBrowser {
  usual
  hide icheck
}
preferences set key-bindings {
	Edit>Undo "Ctrl+Z"
	Edit>Redo "Ctrl+Y"
	Edit>Copy "Ctrl+C"
	Edit>Cut "Ctrl+X"
	Edit>Paste "Ctrl+V"
	Edit>Delete "Del"
        Select>All "Ctrl+A"
        Edit>Select>All "Ctrl+A"
        Edit>SelectAll "Ctrl+A"
      	openDB "Ctrl+O"
        Simulation>Run "F2"
        Simulation>Next "F6"
        Simulation>Step "F5"
        #Schematic window
        View>Zoom>Fit "Alt+="
        View>Zoom>In "Alt+I"
        View>Zoom>Out "Alt+O"
        #Waveform Window
	View>Zoom>InX "Alt+I"
	View>Zoom>OutX "Alt+O"
	View>Zoom>FullX "Alt+="
	View>Zoom>InX_widget "I"
	View>Zoom>OutX_widget "O"
	View>Zoom>FullX_widget "="
	View>Zoom>FullY_widget "Y"
	View>Zoom>Cursor-Baseline "Alt+Z"
	View>Center "Alt+C"
	View>ExpandSequenceTime>AtCursor "Alt+X"
	View>CollapseSequenceTime>AtCursor "Alt+S"
	Edit>Create>Group "Ctrl+G"
	Edit>Ungroup "Ctrl+Shift+G"
	Edit>Create>Marker "Ctrl+M"
	Edit>Create>Condition "Ctrl+E"
	Edit>Create>Bus "Ctrl+W"
	Explore>NextEdge "Ctrl+]"
	Explore>PreviousEdge "Ctrl+["
	ScrollRight "Right arrow"
	ScrollLeft "Left arrow"
	ScrollUp "Up arrow"
	ScrollDown "Down arrow"
	PageUp "PageUp"
	PageDown "PageDown"
	TopOfPage "Home"
	BottomOfPage "End"
}
preferences set toolbar-Windows-WaveWindow {
  usual
  hide icheck
  position -pos 3
}
preferences set toolbar-Windows-WatchList {
  usual
  hide icheck
}

#
# databases
#
database require waves -hints {
#	file ./waves/waves.trn
#	file /home/student/pvlsi/dragos/proj_new1/waves/waves.trn
#	file ./waves_directed_test/waves_directed_test.trn
	file ../waves/waves_directed_test/waves_directed_test.trn
}

#
# groups
#

if {[catch {group new -name SELECTOR -overlay 0}] != ""} {
    group using SELECTOR
    group set -overlay 0
    group set -comment {}
    group clear 0 end
}
group insert \
    proj_directed_test.dut.selector.clk \
    proj_directed_test.dut.selector.res \
    proj_directed_test.dut.selector.stb \
    proj_directed_test.dut.selector.data_valid_in \
    {proj_directed_test.dut.selector.sel[1:0]} \
    {proj_directed_test.dut.selector.data_in_0[7:0]} \
    {proj_directed_test.dut.selector.data_in_1[7:0]} \
    {proj_directed_test.dut.selector.data_in_2[7:0]} \
    {proj_directed_test.dut.selector.data_out[7:0]} \
    proj_directed_test.dut.selector.data_valid_out \
    {proj_directed_test.dut.selector.reg_sel[1:0]} \
    proj_directed_test.dut.selector.stb_out

if {[catch {group new -name ALU -overlay 0}] != ""} {
    group using ALU
    group set -overlay 0
    group set -comment {}
    group clear 0 end
}
group insert \
    proj_directed_test.dut.alu.clk \
    proj_directed_test.dut.alu.res \
    proj_directed_test.dut.alu.alu_stb_in \
    proj_directed_test.dut.alu.alu_data_valid_in \
    {proj_directed_test.dut.alu.operator_type[3:0]} \
    {proj_directed_test.dut.alu.operator_symbol[2:0]} \
    {proj_directed_test.dut.alu.alu_data_in[7:0]} \
    {proj_directed_test.dut.alu.alu_result[15:0]} \
    proj_directed_test.dut.alu.result_parity \
    proj_directed_test.dut.alu.output_channel \
    proj_directed_test.dut.alu.alu_stb_out \
    proj_directed_test.dut.alu.executed_case_once \
    proj_directed_test.dut.alu.i \
    proj_directed_test.dut.alu.j

if {[catch {group new -name {Group 3} -overlay 0}] != ""} {
    group using {Group 3}
    group set -overlay 0
    group set -comment {}
    group clear 0 end
}
group insert \
    {proj_directed_test.dut.dmux.alu_result[15:0]} \
    proj_directed_test.dut.dmux.clk \
    proj_directed_test.dut.dmux.dmux_stb_in \
    {proj_directed_test.dut.dmux.out_0[15:0]} \
    {proj_directed_test.dut.dmux.out_1[15:0]} \
    proj_directed_test.dut.dmux.output_channel \
    proj_directed_test.dut.dmux.parity_0 \
    proj_directed_test.dut.dmux.parity_1 \
    proj_directed_test.dut.dmux.res \
    proj_directed_test.dut.dmux.result_parity \
    proj_directed_test.dut.dmux.valid_0 \
    proj_directed_test.dut.dmux.valid_1

if {[catch {group new -name DMUX -overlay 0}] != ""} {
    group using DMUX
    group set -overlay 0
    group set -comment {}
    group clear 0 end
}
group insert \
    proj_directed_test.dut.dmux.clk \
    proj_directed_test.dut.dmux.res \
    proj_directed_test.dut.dmux.dmux_stb_in \
    proj_directed_test.dut.dmux.output_channel \
    {proj_directed_test.dut.dmux.alu_result[15:0]} \
    proj_directed_test.dut.dmux.result_parity \
    {proj_directed_test.dut.dmux.out_0[15:0]} \
    {proj_directed_test.dut.dmux.out_1[15:0]} \
    proj_directed_test.dut.dmux.parity_0 \
    proj_directed_test.dut.dmux.parity_1 \
    proj_directed_test.dut.dmux.valid_0 \
    proj_directed_test.dut.dmux.valid_1

#
# mmaps
#
mmap new -reuse -name {Boolean as Logic} -contents {
{%c=FALSE -edgepriority 1 -shape low}
{%c=TRUE -edgepriority 1 -shape high}
}
mmap new -reuse -name {Example Map} -contents {
{%b=11???? -bgcolor orange -label REG:%x -linecolor yellow -shape bus}
{%x=1F -bgcolor red -label ERROR -linecolor white -shape EVENT}
{%x=2C -bgcolor red -label ERROR -linecolor white -shape EVENT}
{%x=* -label %x -linecolor gray -shape bus}
}

#
# Design Browser windows
#
if {[catch {window new WatchList -name "Design Browser 1" -geometry 1265x915+0+0}] != ""} {
    window geometry "Design Browser 1" 1265x915+0+0
}
window target "Design Browser 1" on
browser using {Design Browser 1}
browser set \
    -scope proj_directed_test.dut.dmux
browser yview see proj_directed_test.dut.dmux
browser timecontrol set -lock 0

#
# Waveform windows
#
if {[catch {window new WaveWindow -name "Waveform 1" -geometry 1278x915+0+0}] != ""} {
    window geometry "Waveform 1" 1278x915+0+0
}
window target "Waveform 1" on
waveform using {Waveform 1}
waveform sidebar visibility partial
waveform set \
    -primarycursor TimeA \
    -signalnames name \
    -signalwidth 175 \
    -units ns \
    -valuewidth 116
cursor set -using TimeA -time 115ns
waveform baseline set -time 0

set groupId [waveform add -groups SELECTOR]
set glist [waveform hierarchy contents $groupId]
set id [lindex $glist 0]
foreach {name attrs} {
    proj_directed_test.dut.selector.clk {}
    proj_directed_test.dut.selector.res {}
    proj_directed_test.dut.selector.stb {}
    proj_directed_test.dut.selector.data_valid_in {}
    proj_directed_test.dut.selector.sel {}
    proj_directed_test.dut.selector.data_in_0 {}
    proj_directed_test.dut.selector.data_in_1 {}
    proj_directed_test.dut.selector.data_in_2 {-radix %x}
    proj_directed_test.dut.selector.data_out {-radix %x}
    proj_directed_test.dut.selector.data_valid_out {}
    proj_directed_test.dut.selector.reg_sel {}
    proj_directed_test.dut.selector.stb_out {}
} {
    set expected [ join [waveform signals -format native $id] ]
    if {[string equal $name $expected]} {
        if {$attrs != ""} {
            eval waveform format $id $attrs
        }
        set glist [lrange $glist 1 end]
        set id [lindex $glist 0]
    }
}

set groupId [waveform add -groups ALU]
set glist [waveform hierarchy contents $groupId]
set id [lindex $glist 0]
foreach {name attrs} {
    proj_directed_test.dut.alu.clk {}
    proj_directed_test.dut.alu.res {}
    proj_directed_test.dut.alu.alu_stb_in {}
    proj_directed_test.dut.alu.alu_data_valid_in {}
    proj_directed_test.dut.alu.operator_type {}
    proj_directed_test.dut.alu.operator_symbol {}
    proj_directed_test.dut.alu.alu_data_in {-radix %x}
    proj_directed_test.dut.alu.alu_result {-radix %x}
    proj_directed_test.dut.alu.result_parity {}
    proj_directed_test.dut.alu.output_channel {}
    proj_directed_test.dut.alu.alu_stb_out {}
    proj_directed_test.dut.alu.executed_case_once {}
    proj_directed_test.dut.alu.i {}
    proj_directed_test.dut.alu.j {}
} {
    set expected [ join [waveform signals -format native $id] ]
    if {[string equal $name $expected]} {
        if {$attrs != ""} {
            eval waveform format $id $attrs
        }
        set glist [lrange $glist 1 end]
        set id [lindex $glist 0]
    }
}

set groupId [waveform add -groups DMUX]

set id [waveform add -signals [list proj_directed_test.dut.dmux.i \
	proj_directed_test.dut.dmux.dmux_stb_in_was_1 ]]

waveform xview limits 0 200ns
