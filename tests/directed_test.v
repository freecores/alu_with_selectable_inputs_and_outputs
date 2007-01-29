/////////////////////////////////////////////////////////////////////
////                                                             ////
////      This project has been provided to you on behalf of:    ////
////                                                             ////
////      	S.C. ASICArt S.R.L.                              ////
////				www.asicart.com                  ////
////				eli_f@asicart.com                ////
////                                                             ////
////        Author: Dragos Constantin Doncean                    ////
////        Email: doncean@asicart.com                           ////
////        Mobile: +40-740-936997                               ////
////                                                             ////
////      Downloaded from: http://www.opencores.org/             ////
////                                                             ////
/////////////////////////////////////////////////////////////////////
////                                                             ////
//// Copyright (C) 2007 Dragos Constantin Doncean                ////
////                         www.asicart.com                     ////
////                         doncean@asicart.com                 ////
////                                                             ////
//// This source file may be used and distributed without        ////
//// restriction provided that this copyright statement is not   ////
//// removed from the file and that any derivative work contains ////
//// the original copyright notice and the associated disclaimer.////
////                                                             ////
////     THIS SOFTWARE IS PROVIDED ``AS IS'' AND WITHOUT ANY     ////
//// EXPRESS OR IMPLIED WARRANTIES, INCLUDING, BUT NOT LIMITED   ////
//// TO, THE IMPLIED WARRANTIES OF MERCHANTABILITY AND FITNESS   ////
//// FOR A PARTICULAR PURPOSE. IN NO EVENT SHALL THE AUTHOR      ////
//// OR CONTRIBUTORS BE LIABLE FOR ANY DIRECT, INDIRECT,         ////
//// INCIDENTAL, SPECIAL, EXEMPLARY, OR CONSEQUENTIAL DAMAGES    ////
//// (INCLUDING, BUT NOT LIMITED TO, PROCUREMENT OF SUBSTITUTE   ////
//// GOODS OR SERVICES; LOSS OF USE, DATA, OR PROFITS; OR        ////
//// BUSINESS INTERRUPTION) HOWEVER CAUSED AND ON ANY THEORY OF  ////
//// LIABILITY, WHETHER IN  CONTRACT, STRICT LIABILITY, OR TORT  ////
//// (INCLUDING NEGLIGENCE OR OTHERWISE) ARISING IN ANY WAY OUT  ////
//// OF THE USE OF THIS SOFTWARE, EVEN IF ADVISED OF THE         ////
//// POSSIBILITY OF SUCH DAMAGE.                                 ////
////                                                             ////
/////////////////////////////////////////////////////////////////////


//TEST MODULE - DIRECTED TEST

module proj_directed_test;
reg CLK, RES, STB;
reg [1:0] SEL;
reg[7:0] DATA_IN_0, DATA_IN_1, DATA_IN_2;
reg [3:0] OPERATOR_TYPE;
reg [2:0] OPERATOR_SYMBOL;
reg OUTPUT_CHANNEL;
reg DATA_VALID_IN;

wire VALID_0, VALID_1;
wire [15:0] OUT_0, OUT_1;
wire PARITY_0, PARITY_1;

DUT dut(.dut_clk(CLK), .dut_res(RES), .dut_stb(STB),
		.dut_sel(SEL), 
		.dut_data_in_0(DATA_IN_0), .dut_data_in_1(DATA_IN_1), .dut_data_in_2(DATA_IN_2),
		.dut_data_valid_in(DATA_VALID_IN),
		.dut_valid_0(VALID_0), .dut_valid_1(VALID_1),
		.dut_out_0(OUT_0), .dut_out_1(OUT_1),
		.dut_parity_0(PARITY_0), .dut_parity_1(PARITY_1));

initial
begin
	CLK = 0;
	forever #5 CLK = ~CLK;
end

initial
begin
	RES = 0; STB = 0;
	DATA_VALID_IN = 0;
	DATA_IN_0 = 10'b0; DATA_IN_1 = 10'b0; DATA_IN_2 = 10'b0;
end

initial
begin
	$monitor($time, " CLK = %b, RES = %b, STB = %b, SEL = %b, DATA_IN_0 = %b, DATA_IN_1 = %b, DATA_IN_2 = %b, VALID_0 = %b, VALID_1 = %b, OUT_0 = %b, OUT_1 = %b, PARITY_0 = %b, PARITY_1 = %b", 
		CLK, RES, STB, SEL, DATA_IN_0, DATA_IN_1, DATA_IN_2, VALID_0, VALID_1, OUT_0, OUT_1, PARITY_0, PARITY_1);
	
	
	#20 RES = 1;
	#20 RES = 0;
	
	//1st transaction
	#20 STB = 1;
	SEL = 2'b01;
	DATA_VALID_IN = 1;
	$display("\n-------------1st transaction-------------");
	$display("-------------SEL = Ch 1, OPERATOR_TYPE = Arithmetic, OPERATOR_SYMBOL = Multiply, OUTPUT_CHANNEL = Ch 0-------------\n");
	OPERATOR_TYPE = 4'd0;
	OPERATOR_SYMBOL = 3'd0;
	OUTPUT_CHANNEL = 1'd0;
	DATA_IN_1 = {OPERATOR_TYPE, OPERATOR_SYMBOL, OUTPUT_CHANNEL};
	#10 STB = 0;
	DATA_IN_1 = 8'd2;
	#10 DATA_IN_1 = 8'd4;
	#10 DATA_VALID_IN = 0;
	
	//2nd transaction
	#32 STB = 1;
	DATA_VALID_IN = 1;
	$display("-------------2nd transaction-------------");
	$display("-------------SEL = Ch 1, OPERATOR_TYPE = Arithmetic, OPERATOR_SYMBOL = Divide, OUTPUT_CHANNEL = Ch 1-------------\n");
	OPERATOR_TYPE = 4'd0;
	OPERATOR_SYMBOL = 3'd1;
	OUTPUT_CHANNEL = 1'd1;
	DATA_IN_1 = {OPERATOR_TYPE, OPERATOR_SYMBOL, OUTPUT_CHANNEL};
	#10 STB = 0;
	DATA_IN_1 = 8'd18;
	#10 DATA_IN_1 = 8'd9;
	#10 DATA_VALID_IN = 0;

	//3rd transaction
	#30 STB = 1;
	SEL = 2'd0;
	DATA_VALID_IN = 1;
	$display("-------------3rd transaction-------------");
	$display("-------------SEL = Ch 0, OPERATOR_TYPE = Arithmetic, OPERATOR_SYMBOL = Add, OUTPUT_CHANNEL = Ch 0-------------\n");
	OPERATOR_TYPE = 4'd0;
	OPERATOR_SYMBOL = 3'd2;
	OUTPUT_CHANNEL = 1'd0;
	DATA_IN_0 = {OPERATOR_TYPE, OPERATOR_SYMBOL, OUTPUT_CHANNEL};
	#10 STB = 0;
	DATA_IN_0 = 8'd15;
	#10 DATA_IN_0 = 8'd10;
	#10 DATA_VALID_IN = 0;
	
	//4th transaction
	#40 STB = 1;
	SEL = 2'd2;
	DATA_VALID_IN = 1;
	$display("-------------4th transaction-------------");
	$display("-------------SEL = Ch 2, OPERATOR_TYPE = Logical, OPERATOR_SYMBOL = Logical negation, OUTPUT_CHANNEL = Ch 1-------------\n");
	OPERATOR_TYPE = 4'd1;
	OPERATOR_SYMBOL = 3'd0;
	OUTPUT_CHANNEL = 1'd1;
	DATA_IN_2 = {OPERATOR_TYPE, OPERATOR_SYMBOL, OUTPUT_CHANNEL};
	#10 STB = 0;
	DATA_IN_2 = 8'd35;
	#10 DATA_VALID_IN = 0;
	
	//5th transaction
	#30 STB = 1;
	SEL = 2'd2;
	DATA_VALID_IN = 1;
	$display("-------------5th transaction-------------");
	$display("-------------SEL = Ch 2, OPERATOR_TYPE = Bitwise, OPERATOR_SYMBOL = Bitwise negation, OUTPUT_CHANNEL = Ch 1-------------\n");
	OPERATOR_TYPE = 4'd4;
	OPERATOR_SYMBOL = 3'd0;
	OUTPUT_CHANNEL = 1'd1;
	DATA_IN_2 = {OPERATOR_TYPE, OPERATOR_SYMBOL, OUTPUT_CHANNEL};
	#10 STB = 0;
	DATA_IN_2 = 8'd21;
	#10 DATA_VALID_IN = 0;
	
	//6th transaction
	#30 STB = 1;
	SEL = 2'd0;
	DATA_VALID_IN = 1;
	$display("-------------6th transaction-------------");
	$display("-------------SEL = Ch 0, OPERATOR_TYPE = Shift, OPERATOR_SYMBOL = Right shift, OUTPUT_CHANNEL = Ch 0-------------\n");
	OPERATOR_TYPE = 4'd6;
	OPERATOR_SYMBOL = 3'd0;
	OUTPUT_CHANNEL = 1'd0;
	DATA_IN_0 = {OPERATOR_TYPE, OPERATOR_SYMBOL, OUTPUT_CHANNEL};
	#10 STB = 0;
	DATA_IN_0 = 8'd16;
	#10 DATA_IN_0 = 8'd2;
	#10 DATA_VALID_IN = 0;
	
	//7th transaction
	#50 STB = 1;
	SEL = 2'd2;
	DATA_VALID_IN = 1;
	$display("-------------7th transaction-------------");
	$display("-------------SEL = Ch 2, OPERATOR_TYPE = Concatenation, OPERATOR_SYMBOL = Concatenation, OUTPUT_CHANNEL = Ch 1-------------\n");
	OPERATOR_TYPE = 4'd7;
	OPERATOR_SYMBOL = 3'd0;
	OUTPUT_CHANNEL = 1'd1;
	DATA_IN_2 = {OPERATOR_TYPE, OPERATOR_SYMBOL, OUTPUT_CHANNEL};
	#10 STB = 0;
	DATA_IN_2 = 8'd1;
	#10 DATA_IN_2 = 8'd3;
	#10 DATA_VALID_IN = 0;

	//8th transaction
	#30 STB = 1;
	SEL = 2'd1;
	DATA_VALID_IN = 1;
	$display("-------------8th transaction-------------");
	$display("-------------SEL = Ch 1, OPERATOR_TYPE = Replication, OPERATOR_SYMBOL = Replication, OUTPUT_CHANNEL = Ch 0-------------\n");
	OPERATOR_TYPE = 4'd8;
	OPERATOR_SYMBOL = 3'd0;
	OUTPUT_CHANNEL = 1'd0;
	DATA_IN_1 = {OPERATOR_TYPE, OPERATOR_SYMBOL, OUTPUT_CHANNEL};
	#10 STB = 0;
	DATA_IN_1 = 8'd14;
	#10 DATA_VALID_IN = 0;

	//9th transaction
	#30 STB = 1;
	SEL = 2'd0;
	DATA_VALID_IN = 1;
	$display("-------------9th transaction-------------");
	$display("-------------SEL = Ch 0, OPERATOR_TYPE = Conditional, OPERATOR_SYMBOL = Conditional, OUTPUT_CHANNEL = Ch 0-------------\n");
	OPERATOR_TYPE = 4'd9;
	OPERATOR_SYMBOL = 3'd0;
	OUTPUT_CHANNEL = 1'd0;
	DATA_IN_0 = {OPERATOR_TYPE, OPERATOR_SYMBOL, OUTPUT_CHANNEL};
	#10 STB = 0;
	DATA_IN_0 = 8'd0;
	#10 DATA_IN_0 = 8'd2;
	#10 DATA_IN_0 = 8'd3;
	#10 DATA_VALID_IN = 0;

	/*
	//10th transaction - reserved values: circuit behaviour is impredictible, reserved values must not be used
	#40 STB = 1;
	SEL = 2'd3;
	DATA_VALID_IN = 1;
	$display("\n-------------10th transaction - reserved values for SEL -------------");
	$display("-------------SEL = Reserved ('d4), OPERATOR_TYPE = Reserved('d10), OPERATOR_SYMBOL = Reserved ('d0), OUTPUT_CHANNEL = Ch 0-------------\n");
	OPERATOR_TYPE = 4'd10;
	OPERATOR_SYMBOL = 3'd0;
	OUTPUT_CHANNEL = 1'd0;
	DATA_IN_0 = {OPERATOR_TYPE, OPERATOR_SYMBOL, OUTPUT_CHANNEL};
	#10 STB = 0;
	DATA_IN_0 = 8'hCC;
	DATA_IN_1 = 8'hCC;
	DATA_IN_2 = 8'hCC;
	#10 DATA_VALID_IN = 0;
	*/
	#50 $finish;
end

initial
begin

	$shm_open("../run/waves/waves_directed_test");  // Open database named "waves"
	$shm_probe(proj_directed_test, "AS"); // Record tb scope and all sub hierarchy
	//<or> $shm_probe(proj_directed_test.top, "A"); // Record only those signals at proj1_test.top scope
	
	/*
	After your simulation run, you would invoke the waveform viewer with "simwave waves" or "simvision waves" 
	and all the signals you asked to be recorded should be present. You don't need the NC gui at all.
	*/
end

/*
//for waveform viewing - ICARUS VERILOG and GTKWave
initial
begin
	$dumpfile ("proj_directed_test.dump") ;
	$dumpvars;
	$dumpon;
	//$dumpall;
end
*/

endmodule
