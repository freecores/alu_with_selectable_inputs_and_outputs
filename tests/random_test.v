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


//TEST MODULE - RANDOM TEST

module proj_random_test;
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

parameter NO_OF_TRANSACTIONS = 10;
integer i;

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
	SEL = 2'b00;
	DATA_VALID_IN = 0;
	DATA_IN_0 = 10'b0; DATA_IN_1 = 10'b0; DATA_IN_2 = 10'b0;
end

initial
begin
	$monitor($time, " CLK = %b, RES = %b, STB = %b, SEL = %b, DATA_IN_0 = %b, DATA_IN_1 = %b, DATA_IN_2 = %b, VALID_0 = %b, VALID_1 = %b, OUT_0 = %b, OUT_1 = %b, PARITY_0 = %b, PARITY_1 = %b", 
		CLK, RES, STB, SEL, DATA_IN_0, DATA_IN_1, DATA_IN_2, VALID_0, VALID_1, OUT_0, OUT_1, PARITY_0, PARITY_1);
	
	
	#20 RES = 1;
	#20 RES = 0;
	
	for(i = 0; i < NO_OF_TRANSACTIONS; i = i + 1)
	begin

		#30 STB = 1;
		$display("Transaction no: %0d", i);
		DATA_VALID_IN = 1;
		SEL = {$random} % 3;
		OPERATOR_TYPE = {$random} % 10;
		case(OPERATOR_TYPE)
		'd0: //Arithmetic
			OPERATOR_SYMBOL = {$random} % 5;
		'd1: //Logical
			OPERATOR_SYMBOL = {$random} % 3;
		'd2: //Relational
			OPERATOR_SYMBOL = {$random} % 4;
		'd3: //Equality
			OPERATOR_SYMBOL = {$random} % 4;
		'd4: //Bitwise
			OPERATOR_SYMBOL = {$random} % 6;
		'd5: //Reduction
			OPERATOR_SYMBOL = {$random} % 7;
		'd6: //Shift
			OPERATOR_SYMBOL = {$random} % 2;
		'd7: //Concatenation
			OPERATOR_SYMBOL = {$random} % 1; //or OPERATOR_SYMBOL = 0;
		'd8: //Replication
			OPERATOR_SYMBOL = {$random} % 1; //or OPERATOR_SYMBOL = 0;
		'd9: //Conditional
			OPERATOR_SYMBOL = {$random} % 1; //or OPERATOR_SYMBOL = 0;
		endcase
		OUTPUT_CHANNEL = {$random} % 2;

		case(SEL[1:0])
				2'b00: DATA_IN_0 = {OPERATOR_TYPE, OPERATOR_SYMBOL, OUTPUT_CHANNEL};
				2'b01: DATA_IN_1 = {OPERATOR_TYPE, OPERATOR_SYMBOL, OUTPUT_CHANNEL};
				2'b10: DATA_IN_2 = {OPERATOR_TYPE, OPERATOR_SYMBOL, OUTPUT_CHANNEL};
		endcase

		#10 STB = 0;

		//if at least only one operand is required - there always exists at least one operand
		case(SEL[1:0])
				2'b00: DATA_IN_0 = $random;
				2'b01: DATA_IN_1 = $random;
				2'b10: DATA_IN_2 = $random;
		endcase

		//if at least two operands are required
		if((OPERATOR_TYPE === 'd0) || //Arithmetic
					((OPERATOR_TYPE === 'd1) && (OPERATOR_SYMBOL >=  'd1) && (OPERATOR_SYMBOL <=  'd2)) || //Logical
					(OPERATOR_TYPE === 'd2) || //Relational
					(OPERATOR_TYPE === 'd3) || //Equality
					((OPERATOR_TYPE === 'd4) && (OPERATOR_SYMBOL >=  'd1) && (OPERATOR_SYMBOL <=  'd5)) || //Bitwise
					(OPERATOR_TYPE === 'd6) || //Shift
					(OPERATOR_TYPE === 'd7) || //Concatenation
					(OPERATOR_TYPE === 'd9))   //Conditional
		begin
			#10
			case(SEL[1:0])
				2'b00: DATA_IN_0 = $random;
				2'b01: DATA_IN_1 = $random;
				2'b10: DATA_IN_2 = $random;
			endcase
		end

		//if three operands are required
		if(OPERATOR_TYPE === 'd9) //Conditional
		begin
			#10
			case(SEL[1:0])
				2'b00: DATA_IN_0 = $random;
				2'b01: DATA_IN_1 = $random;
				2'b10: DATA_IN_2 = $random;
			endcase
		end

		#10 DATA_VALID_IN = 0;

	end
	
	#50 $finish;
end

initial
begin

	$shm_open("../run/waves/waves_random_test");  // Open database named "waves"
	$shm_probe(proj_random_test, "AS"); // Record tb scope and all sub hierarchy
	//<or> $shm_probe(proj_random_test.top, "A"); // Record only those signals at proj_random_test.top scope
	
	/*
	After your simulation run, you would invoke the waveform viewer with "simwave waves" or "simvision waves" 
	and all the signals you asked to be recorded should be present. You don't need the NC gui at all.
	*/
end

/*
//for waveform viewing with GTKWave
initial
begin
	$dumpfile ("proj_random_test.dump") ;
	$dumpvars;
	$dumpon;
	//$dumpall;
end
*/

endmodule
