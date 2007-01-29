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


//----------------BFMs----------------

//DATA_IN BFM

module DATA_IN_BFM(bfm_stb, bfm_sel, bfm_data_in_0, bfm_data_in_1, bfm_data_in_2, bfm_data_valid_in);
output bfm_stb;
output [1:0] bfm_sel;
output [7:0] bfm_data_in_0, bfm_data_in_1, bfm_data_in_2;
output bfm_data_valid_in;

reg bfm_stb;
reg [1:0] bfm_sel;
reg[7:0] bfm_data_in_0, bfm_data_in_1, bfm_data_in_2;
reg bfm_data_valid_in;

reg [3:0] bfm_operator_type;
reg [2:0] bfm_operator_symbol;
reg bfm_output_channel;

parameter NO_OF_TRANSACTIONS = 10;
integer i;

integer fh;

initial
begin
	fh = $fopen("data_in_bfm.out");

	$fmonitor(fh, "%0d INFO: bfm_stb=%b, bfm_sel=%b, bfm_data_in_0=%b, bfm_data_in_1=%b, bfm_data_in_2=%b",
		$time, bfm_stb, bfm_sel, bfm_data_in_0, bfm_data_in_1, bfm_data_in_2);
	
	bfm_stb = 0;
	bfm_sel = 2'b00;
	bfm_data_valid_in = 0;
	bfm_data_in_0 = 10'b0;
	bfm_data_in_1 = 10'b0;
	bfm_data_in_2 = 10'b0;
	
	#50

	for(i=0; i<NO_OF_TRANSACTIONS; i=i+1)
	begin

		#30 bfm_stb = 1;
		$display("Transaction no: %0d", i);
		bfm_data_valid_in = 1;
		bfm_sel = {$random} % 3;
		bfm_operator_type = {$random} % 10;
		case(bfm_operator_type)
		'd0: //Arithmetic
			bfm_operator_symbol = {$random} % 5;
		'd1: //Logical
			bfm_operator_symbol = {$random} % 3;
		'd2: //Relational
			bfm_operator_symbol = {$random} % 4;
		'd3: //Equality
			bfm_operator_symbol = {$random} % 4;
		'd4: //Bitwise
			bfm_operator_symbol = {$random} % 6;
		'd5: //Reduction
			bfm_operator_symbol = {$random} % 7;
		'd6: //Shift
			bfm_operator_symbol = {$random} % 2;
		'd7: //Concatenation
			bfm_operator_symbol = {$random} % 1; //or bfm_operator_symbol = 0;
		'd8: //Replication
			bfm_operator_symbol = {$random} % 1; //or bfm_operator_symbol = 0;
		'd9: //Conditional
			bfm_operator_symbol = {$random} % 1; //or bfm_operator_symbol = 0;
		endcase
		bfm_output_channel = {$random} % 2;

		case(bfm_sel[1:0])
				2'b00: bfm_data_in_0 = {bfm_operator_type, bfm_operator_symbol, bfm_output_channel};
				2'b01: bfm_data_in_1 = {bfm_operator_type, bfm_operator_symbol, bfm_output_channel};
				2'b10: bfm_data_in_2 = {bfm_operator_type, bfm_operator_symbol, bfm_output_channel};
		endcase

		#10 bfm_stb = 0;

		//if at least only one operand is required - there always exists at least one operand
		case(bfm_sel[1:0])
				2'b00: bfm_data_in_0 = $random;
				2'b01: bfm_data_in_1 = $random;
				2'b10: bfm_data_in_2 = $random;
		endcase

		//if at least two operands are required
		if((bfm_operator_type === 'd0) || //Arithmetic
					((bfm_operator_type === 'd1) && (bfm_operator_symbol >= 'd1) && (bfm_operator_symbol <= 'd2)) || //Logical
					(bfm_operator_type === 'd2) || //Relational
					(bfm_operator_type === 'd3) || //Equality
					((bfm_operator_type === 'd4) && (bfm_operator_symbol >= 'd1) && (bfm_operator_symbol <= 'd5)) || //Bitwise
					(bfm_operator_type === 'd6) || //Shift
					(bfm_operator_type === 'd7) || //Concatenation
					(bfm_operator_type === 'd9))   //Conditional
		begin
			#10
			case(bfm_sel[1:0])
				2'b00: bfm_data_in_0 = $random;
				2'b01: bfm_data_in_1 = $random;
				2'b10: bfm_data_in_2 = $random;
			endcase
		end

		//if three operands are required
		if(bfm_operator_type === 'd9) //Conditional
		begin
			#10
			case(bfm_sel[1:0])
				2'b00: bfm_data_in_0 = $random;
				2'b01: bfm_data_in_1 = $random;
				2'b10: bfm_data_in_2 = $random;
			endcase
		end

		#10 bfm_data_valid_in = 0;

	end
	
	#100 
	
	$fclose(fh);

	$finish;
end

endmodule
