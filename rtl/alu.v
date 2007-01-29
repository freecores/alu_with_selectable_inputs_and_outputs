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


//ALU

module ALU(clk, res, alu_stb_in,
	alu_data_in, alu_data_valid_in,
	alu_result, result_parity,
	output_channel,
	alu_stb_out);

input clk, res, alu_stb_in;
input [7:0] alu_data_in;
input alu_data_valid_in;
output [15:0] alu_result;
output result_parity;
output output_channel;
output alu_stb_out;

reg [15:0] alu_result;
reg result_parity;
reg [3:0] operator_type;
reg [2:0] operator_symbol;
reg output_channel;
reg [7:0] alu_memory [0:15];
reg alu_stb_out;

integer i;
integer j;
reg executed_case_once;
	
always @ (posedge clk or posedge res)
if(res)
begin
	alu_result = 16'b0;
	result_parity = 1'b0;
	operator_type = 4'b1111;
	operator_symbol = 3'b111;
	output_channel = 1'b0;
	for(i = 0; i < 15; i = i + 1)
		alu_memory[i] = 8'b0;
	i = 0;
	j = 0;
	executed_case_once = 1'b0;
end
else
begin
	if(alu_stb_in)
	begin
		operator_type = alu_data_in[7:4];
		operator_symbol = alu_data_in[3:1];
		output_channel = alu_data_in[0];
		executed_case_once = 1'b0;
	end
	if((alu_data_valid_in) && (! alu_stb_in))
	begin
		alu_memory[i] = alu_data_in;
		i = i + 1;
	end
	if((! alu_data_valid_in) && (! alu_stb_in) && (! executed_case_once))
	begin
		executed_case_once = 1'b1;
		if(i !== 0)
			for(j=i;j<16; j=j+1)
				alu_memory[j] = 8'b0;
		i = 0;
		case (operator_type)
		'd0: //Arithmetic
		begin
			$display("Arithmetic operator");
			case(operator_symbol)
			'd0: //Multiply
			begin
				alu_result = (alu_memory[0] * alu_memory[1]);
				$display("OPERATION * (Multiply): alu_memory[0]=%b, alu_memory[1]=%b, alu_result=%b", 
					alu_memory[0], alu_memory[1], alu_result);
			end
			'd1: //Divide
			begin
				alu_result = (alu_memory[0] / alu_memory[1]);
				$display("OPERATION / (Divide): alu_memory[0]=%b, alu_memory[1]=%b, alu_result=%b", 
					alu_memory[0], alu_memory[1], alu_result);
			end
			'd2: //Add
			begin
				alu_result = (alu_memory[0] + alu_memory[1]);
				$display("OPERATION + (Add): alu_memory[0]=%b, alu_memory[1]=%b, alu_result=%b", 
					alu_memory[0], alu_memory[1], alu_result);
			end
			'd3: //Substract
			begin
				alu_result = (alu_memory[0] - alu_memory[1]);
				$display("OPERATION - (Substract): alu_memory[0]=%b, alu_memory[1]=%b, alu_result=%b", 
					alu_memory[0], alu_memory[1], alu_result);
			end
			'd4: //Modulus
			begin
				alu_result = (alu_memory[0] % alu_memory[1]);
				$display("OPERATION  (Modulus): alu_memory[0]=%b, alu_memory[1]=%b, alu_result=%b", 
					alu_memory[0], alu_memory[1], alu_result);
			end
			endcase
		end
		'd1: //Logical
		begin
			$display("Logical operator");
			case(operator_symbol)
			'd0: //Logical negation
			begin
				alu_result = (!alu_memory[0]);
				$display("OPERATION ! (Logical negation): alu_memory[0]=%b, alu_result=%b", 
					alu_memory[0], alu_result);
			end
			'd1: //Logical and
			begin
				alu_result = (alu_memory[0] && alu_memory[1]);
				$display("OPERATION && (Logical and): alu_memory[0]=%b, alu_memory[1]=%b, alu_result=%b", 
					alu_memory[0], alu_memory[1], alu_result);
			end
			'd2: //Logical or
			begin
				alu_result = (alu_memory[0] || alu_memory[1]);
				$display("OPERATION || (Logical or): alu_memory[0]=%b, alu_memory[1]=%b, alu_result=%b", 
					alu_memory[0], alu_memory[1], alu_result);
			end
			endcase
		end
		'd2: //Relational
		begin
			$display("Relational operator");
			case(operator_symbol)
			'd0: //Greater than
			begin
				alu_result = (alu_memory[0] > alu_memory[1]);
				$display("OPERATION > (Greater than): alu_memory[0]=%b, alu_memory[1]=%b, alu_result=%b", 
					alu_memory[0], alu_memory[1], alu_result);
			end
			'd1: //Less than
			begin
				alu_result = (alu_memory[0] < alu_memory[1]);
				$display("OPERATION < (Less than): alu_memory[0]=%b, alu_memory[1]=%b, alu_result=%b", 
					alu_memory[0], alu_memory[1], alu_result);
			end
			'd2: //Greater than or equal
			begin
				alu_result = (alu_memory[0] >= alu_memory[1]);
				$display("OPERATION >= (Greater than or equal): alu_memory[0]=%b, alu_memory[1]=%b, alu_result=%b", 
					alu_memory[0], alu_memory[1], alu_result);
			end
			'd3: //Less than or equal
			begin
				alu_result = (alu_memory[0] <= alu_memory[1]);
				$display("OPERATION <= (Less than or equal): alu_memory[0]=%b, alu_memory[1]=%b, alu_result=%b", 
					alu_memory[0], alu_memory[1], alu_result);
			end
			endcase
		end
		'd3: //Equality
		begin
			$display("Equality operator");
			case(operator_symbol)
			'd0: //Equality
			begin
				alu_result = (alu_memory[0] == alu_memory[1]);
				$display("OPERATION == (Equality): alu_memory[0]=%b, alu_memory[1]=%b, alu_result=%b", 
					alu_memory[0], alu_memory[1], alu_result);
			end
			'd1: //Inequality
			begin
				alu_result = (alu_memory[0] != alu_memory[1]);
				$display("OPERATION != (Inequality): alu_memory[0]=%b, alu_memory[1]=%b, alu_result=%b", 
					alu_memory[0], alu_memory[1], alu_result);
			end
			'd2: //Case equality
			begin
				alu_result = (alu_memory[0] === alu_memory[1]);
				$display("OPERATION === (Case equality): alu_memory[0]=%b, alu_memory[1]=%b, alu_result=%b", 
					alu_memory[0], alu_memory[1], alu_result);
			end
			'd3: //Case inequality
			begin
				alu_result = (alu_memory[0] !== alu_memory[1]);
				$display("OPERATION !== (Case inequality): alu_memory[0]=%b, alu_memory[1]=%b, alu_result=%b", 
					alu_memory[0], alu_memory[1], alu_result);
			end
			endcase
		end
		'd4: //Bitwise
		begin
			$display("Bitwise operator");
			case(operator_symbol)
			'd0: //Bitwise negation
			begin
				alu_result = (~ alu_memory[0]);
				$display("OPERATION ~ (Bitwise negation): alu_memory[0]=%b, alu_result=%b", 
					alu_memory[0], alu_result);
			end
			'd1: //Bitwise and
			begin
				alu_result = (alu_memory[0] & alu_memory[1]);
				$display("OPERATION & (Bitwise and): alu_memory[0]=%b, alu_memory[1]=%b, alu_result=%b", 
					alu_memory[0], alu_memory[1], alu_result);
			end
			'd2: //Bitwise or
			begin
				alu_result = (alu_memory[0] | alu_memory[1]);
				$display("OPERATION | (Bitwise or): alu_memory[0]=%b, alu_memory[1]=%b, alu_result=%b", 
					alu_memory[0], alu_memory[1], alu_result);
			end
			'd3: //Bitwise xor
			begin
				alu_result = (alu_memory[0] ^ alu_memory[1]);
				$display("OPERATION ^ (Bitwise xor): alu_memory[0]=%b, alu_memory[1]=%b, alu_result=%b", 
					alu_memory[0], alu_memory[1], alu_result);
			end
			'd4: //Bitwise xnor (1st operator symbol)
			begin
				alu_result = (alu_memory[0] ^~ alu_memory[1]);
				$display("OPERATION ^~ (Bitwise xnor (1st operator symbol)): alu_memory[0]=%b, alu_memory[1]=%b, alu_result=%b", 
					alu_memory[0], alu_memory[1], alu_result);
			end
			'd5: //Bitwise xnor (2nd operator symbol)
			begin
				alu_result = (alu_memory[0] ~^ alu_memory[1]);
				$display("OPERATION ~^ (Bitwise xnor (2nd operator symbol)): alu_memory[0]=%b, alu_memory[1]=%b, alu_result=%b", 
					alu_memory[0], alu_memory[1], alu_result);
			end
			endcase
		end
		'd5: //Reduction
		begin
			$display("Reduction operator");
			case(operator_symbol)
			'd0: //Reduction and
			begin
				alu_result = (& alu_memory[0]);
				$display("OPERATION & (Reduction and): alu_memory[0]=%b, alu_result=%b", 
					alu_memory[0], alu_result);
			end
			'd1: //Reduction nand
			begin
				alu_result = (~& alu_memory[0]);
				$display("OPERATION ~& (Reduction nand): alu_memory[0]=%b, alu_result=%b", 
					alu_memory[0], alu_result);
			end
			'd2: //Reduction or
			begin
				alu_result = (| alu_memory[0]);
				$display("OPERATION | (Reduction or): alu_memory[0]=%b, alu_result=%b", 
					alu_memory[0], alu_result);
			end
			'd3: //Reduction nor
			begin
				alu_result = (~| alu_memory[0]);
				$display("OPERATION ~| (Reduction nor): alu_memory[0]=%b, alu_result=%b", 
					alu_memory[0], alu_result);
			end
			'd4: //Reduction xor
			begin
				alu_result = (^ alu_memory[0]);
				$display("OPERATION ^ (Reduction xor): alu_memory[0]=%b, alu_result=%b", 
					alu_memory[0], alu_result);
			end
			'd5: //Reduction xnor (1st operator symbol)
			begin
				alu_result = (^~ alu_memory[0]);
				$display("OPERATION ^~ (Reduction xnor (1st operator symbol)): alu_memory[0]=%b, alu_result=%b", 
					alu_memory[0], alu_result);
			end
			'd6: //Reduction xnor (2nd operator symbol)
			begin
				alu_result = (~^ alu_memory[0]);
				$display("OPERATION ~^ (Reduction xnor (2nd operator symbol)): alu_memory[0]=%b, alu_result=%b", 
					alu_memory[0], alu_result);
			end
			endcase
		end
		'd6: //Shift
		begin
			$display("Shift operator");
			case(operator_symbol)
			'd0: //Right shift
			begin
				alu_result = (alu_memory[0] >> alu_memory[1]);
				$display("OPERATION >> (Right shift): alu_memory[0]=%b, alu_memory[1]=%b, alu_result=%b", 
					alu_memory[0], alu_memory[1], alu_result);
			end
			'd1: //Left shift
			begin
				alu_result = (alu_memory[0] << alu_memory[1]);
				$display("OPERATION << (Left shift): alu_memory[0]=%b, alu_memory[1]=%b, alu_result=%b", 
					alu_memory[0], alu_memory[1], alu_result);
			end
			endcase
		end
		'd7: //Concatenation
		begin
			//$display("Concatenation operator");
			case(operator_symbol)
			'd0: //Concatenation
			begin
				alu_result = {alu_memory[0], alu_memory[1]};
				$display("OPERATION {} (Concatenation): alu_memory[0]=%b, alu_memory[1]=%b, alu_result=%b",
					alu_memory[0], alu_memory[1], alu_result);
			end
			endcase
		end
		'd8: //Replication
		begin
			$display("Replication operator");
			case(operator_symbol)
			'd0: //Replication
			begin
				alu_result = { 2 {alu_memory[0]} };
				$display("OPERATION { { } } (Replication): alu_memory[0]=%b - replicated twice: alu_result=%b", 
					alu_memory[0], alu_result);
			end
			endcase
		end
		'd9: //Conditional
		begin
			$display("Conditional operator");
			case(operator_symbol)
			'd0: //Conditional
			begin
				alu_result = (alu_memory[0] ? alu_memory[1] : alu_memory[2]);
				$display("OPERATION ?: (Conditional): alu_memory[0]=%b, alu_memory[1]=%b, alu_memory[2]=%b, alu_result=%b", 
					alu_memory[0], alu_memory[1], alu_memory[2], alu_result);
			end
			endcase
		end
		endcase
		result_parity = ^alu_result; //Parity = XOR of all result's bits
	end
end

always @ (posedge clk)
	alu_stb_out = alu_stb_in;

endmodule
