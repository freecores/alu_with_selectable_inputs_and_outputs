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


//CHECKER

module CHECKER(c_clk, c_res,
	ic_data_0, ic_data_1, ic_data_2, ic_data_3,
	oc_data,
	oc_parity,
	ic_data_collected,
	oc_data_collected);

input c_clk, c_res;
input [7:0] ic_data_0, ic_data_1, ic_data_2, ic_data_3;
input [15:0] oc_data;
input oc_parity;
input [0:127] ic_data_collected, oc_data_collected;

integer i, j;

reg [15:0] checker_result;
reg checker_result_parity;
reg [3:0] checker_operator_type;
reg [2:0] checker_operator_symbol;

integer fh;

always @ (posedge c_clk or posedge c_res)
if(c_res)
begin
	i = 0;
	j = 0;
	checker_result = 16'b0;
	checker_result_parity = 1'b0;
	checker_operator_type = 4'b1111;
	checker_operator_symbol = 3'b111;
end

always @ (ic_data_collected[i])
if(ic_data_collected[i])
begin
		#1
		if(fh === 32'bx)
			fh = $fopen("checker.out"); 

		$fdisplay(fh, "%0d INFO: Collected IN transaction no %0d: ic_data_0 = %b, ic_data_1 = %b, ic_data_2 = %b, ic_data_3 = %b",
			$time, i, ic_data_0, ic_data_1, ic_data_2, ic_data_3);

		//calculate checker's alu result
		checker_operator_type = ic_data_0[7:4];
		checker_operator_symbol = ic_data_0[3:1];

		case (checker_operator_type)
		'd0: //Arithmetic
		begin
			$fdisplay(fh, "Arithmetic operator");
			case(checker_operator_symbol)
			'd0: //Multiply
			begin
				checker_result = (ic_data_1 * ic_data_2);
				$fdisplay(fh, "OPERATION * (Multiply): ic_data_1 = %b, ic_data_2 = %b, checker_result = %b", 
					ic_data_1, ic_data_2, checker_result);
			end
			'd1: //Divide
			begin
				checker_result = (ic_data_1 / ic_data_2);
				$fdisplay(fh, "OPERATION / (Divide): ic_data_1 = %b, ic_data_2 = %b, checker_result = %b", 
					ic_data_1, ic_data_2, checker_result);
			end
			'd2: //Add
			begin
				checker_result = (ic_data_1 + ic_data_2);
				$fdisplay(fh, "OPERATION + (Add): ic_data_1 = %b, ic_data_2 = %b, checker_result = %b", 
					ic_data_1, ic_data_2, checker_result);
			end
			'd3: //Substract
			begin
				checker_result = (ic_data_1 - ic_data_2);
				$fdisplay(fh, "OPERATION - (Substract): ic_data_1 = %b, ic_data_2 = %b, checker_result = %b", 
					ic_data_1, ic_data_2, checker_result);
			end
			'd4: //Modulus
			begin
				checker_result = (ic_data_1 % ic_data_2);
				$fdisplay(fh, "OPERATION  (Modulus): ic_data_1 = %b, ic_data_2 = %b, checker_result = %b", 
					ic_data_1, ic_data_2, checker_result);
			end
			endcase
		end
		'd1: //Logical
		begin
			$fdisplay(fh, "Logical operator");
			case(checker_operator_symbol)
			'd0: //Logical negation
			begin
				checker_result = (!ic_data_1);
				$fdisplay(fh, "OPERATION ! (Logical negation): ic_data_1 = %b, checker_result = %b", 
					ic_data_1, checker_result);
			end
			'd1: //Logical and
			begin
				checker_result = (ic_data_1 && ic_data_2);
				$fdisplay(fh, "OPERATION && (Logical and): ic_data_1 = %b, ic_data_2 = %b, checker_result = %b", 
					ic_data_1, ic_data_2, checker_result);
			end
			'd2: //Logical or
			begin
				checker_result = (ic_data_1 || ic_data_2);
				$fdisplay(fh, "OPERATION || (Logical or): ic_data_1 = %b, ic_data_2 = %b, checker_result = %b", 
					ic_data_1, ic_data_2, checker_result);
			end
			endcase
		end
		'd2: //Relational
		begin
			$fdisplay(fh, "Relational operator");
			case(checker_operator_symbol)
			'd0: //Greater than
			begin
				checker_result = (ic_data_1 > ic_data_2);
				$fdisplay(fh, "OPERATION > (Greater than): ic_data_1 = %b, ic_data_2 = %b, checker_result = %b", 
					ic_data_1, ic_data_2, checker_result);
			end
			'd1: //Less than
			begin
				checker_result = (ic_data_1 < ic_data_2);
				$fdisplay(fh, "OPERATION < (Less than): ic_data_1 = %b, ic_data_2 = %b, checker_result = %b", 
					ic_data_1, ic_data_2, checker_result);
			end
			'd2: //Greater than or equal
			begin
				checker_result = (ic_data_1 >= ic_data_2);
				$fdisplay(fh, "OPERATION >= (Greater than or equal): ic_data_1 = %b, ic_data_2 = %b, checker_result = %b", 
					ic_data_1, ic_data_2, checker_result);
			end
			'd3: //Less than or equal
			begin
				checker_result = (ic_data_1 <= ic_data_2);
				$fdisplay(fh, "OPERATION <= (Less than or equal): ic_data_1 = %b, ic_data_2 = %b, checker_result = %b", 
					ic_data_1, ic_data_2, checker_result);
			end
			endcase
		end
		'd3: //Equality
		begin
			$fdisplay(fh, "Equality operator");
			case(checker_operator_symbol)
			'd0: //Equality
			begin
				checker_result = (ic_data_1 == ic_data_2);
				$fdisplay(fh, "OPERATION == (Equality): ic_data_1 = %b, ic_data_2 = %b, checker_result = %b", 
					ic_data_1, ic_data_2, checker_result);
			end
			'd1: //Inequality
			begin
				checker_result = (ic_data_1 != ic_data_2);
				$fdisplay(fh, "OPERATION != (Inequality): ic_data_1 = %b, ic_data_2 = %b, checker_result = %b", 
					ic_data_1, ic_data_2, checker_result);
			end
			'd2: //Case equality
			begin
				checker_result = (ic_data_1 === ic_data_2);
				$fdisplay(fh, "OPERATION === (Case equality): ic_data_1 = %b, ic_data_2 = %b, checker_result = %b", 
					ic_data_1, ic_data_2, checker_result);
			end
			'd3: //Case inequality
			begin
				checker_result = (ic_data_1 !== ic_data_2);
				$fdisplay(fh, "OPERATION !== (Case inequality): ic_data_1 = %b, ic_data_2 = %b, checker_result = %b", 
					ic_data_1, ic_data_2, checker_result);
			end
			endcase
		end
		'd4: //Bitwise
		begin
			$fdisplay(fh, "Bitwise operator");
			case(checker_operator_symbol)
			'd0: //Bitwise negation
			begin
				checker_result = (~ ic_data_1);
				$fdisplay(fh, "OPERATION ~ (Bitwise negation): ic_data_1 = %b, checker_result = %b", 
					ic_data_1, checker_result);
			end
			'd1: //Bitwise and
			begin
				checker_result = (ic_data_1 & ic_data_2);
				$fdisplay(fh, "OPERATION & (Bitwise and): ic_data_1 = %b, ic_data_2 = %b, checker_result = %b", 
					ic_data_1, ic_data_2, checker_result);
			end
			'd2: //Bitwise or
			begin
				checker_result = (ic_data_1 | ic_data_2);
				$fdisplay(fh, "OPERATION | (Bitwise or): ic_data_1 = %b, ic_data_2 = %b, checker_result = %b", 
					ic_data_1, ic_data_2, checker_result);
			end
			'd3: //Bitwise xor
			begin
				checker_result = (ic_data_1 ^ ic_data_2);
				$fdisplay(fh, "OPERATION ^ (Bitwise xor): ic_data_1 = %b, ic_data_2 = %b, checker_result = %b", 
					ic_data_1, ic_data_2, checker_result);
			end
			'd4: //Bitwise xnor (1st operator symbol)
			begin
				checker_result = (ic_data_1 ^~ ic_data_2);
				$fdisplay(fh, "OPERATION ^~ (Bitwise xnor (1st operator symbol)): ic_data_1 = %b, ic_data_2 = %b, checker_result = %b", 
					ic_data_1, ic_data_2, checker_result);
			end
			'd5: //Bitwise xnor (2nd operator symbol)
			begin
				checker_result = (ic_data_1 ~^ ic_data_2);
				$fdisplay(fh, "OPERATION ~^ (Bitwise xnor (2nd operator symbol)): ic_data_1 = %b, ic_data_2 = %b, checker_result = %b", 
					ic_data_1, ic_data_2, checker_result);
			end
			endcase
		end
		'd5: //Reduction
		begin
			$fdisplay(fh, "Reduction operator");
			case(checker_operator_symbol)
			'd0: //Reduction and
			begin
				checker_result = (& ic_data_1);
				$fdisplay(fh, "OPERATION & (Reduction and): ic_data_1 = %b, checker_result = %b", 
					ic_data_1, checker_result);
			end
			'd1: //Reduction nand
			begin
				checker_result = (~& ic_data_1);
				$fdisplay(fh, "OPERATION ~& (Reduction nand): ic_data_1 = %b, checker_result = %b", 
					ic_data_1, checker_result);
			end
			'd2: //Reduction or
			begin
				checker_result = (| ic_data_1);
				$fdisplay(fh, "OPERATION | (Reduction or): ic_data_1 = %b, checker_result = %b", 
					ic_data_1, checker_result);
			end
			'd3: //Reduction nor
			begin
				checker_result = (~| ic_data_1);
				$fdisplay(fh, "OPERATION ~| (Reduction nor): ic_data_1 = %b, checker_result = %b", 
					ic_data_1, checker_result);
			end
			'd4: //Reduction xor
			begin
				checker_result = (^ ic_data_1);
				$fdisplay(fh, "OPERATION ^ (Reduction xor): ic_data_1 = %b, checker_result = %b", 
					ic_data_1, checker_result);
			end
			'd5: //Reduction xnor (1st operator symbol)
			begin
				checker_result = (^~ ic_data_1);
				$fdisplay(fh, "OPERATION ^~ (Reduction xnor (1st operator symbol)): ic_data_1 = %b, checker_result = %b", 
					ic_data_1, checker_result);
			end
			'd6: //Reduction xnor (2nd operator symbol)
			begin
				checker_result = (~^ ic_data_1);
				$fdisplay(fh, "OPERATION ~^ (Reduction xnor (2nd operator symbol)): ic_data_1 = %b, checker_result = %b", 
					ic_data_1, checker_result);
			end
			endcase
		end
		'd6: //Shift
		begin
			$fdisplay(fh, "Shift operator");
			case(checker_operator_symbol)
			'd0: //Right shift
			begin
				checker_result = (ic_data_1 >> ic_data_2);
				$fdisplay(fh, "OPERATION >> (Right shift): ic_data_1 = %b, ic_data_2 = %b, checker_result = %b", 
					ic_data_1, ic_data_2, checker_result);
			end
			'd1: //Left shift
			begin
				checker_result = (ic_data_1 << ic_data_2);
				$fdisplay(fh, "OPERATION << (Left shift): ic_data_1 = %b, ic_data_2 = %b, checker_result = %b", 
					ic_data_1, ic_data_2, checker_result);
			end
			endcase
		end
		'd7: //Concatenation
		begin
			$fdisplay(fh, "Concatenation operator");
			case(checker_operator_symbol)
			'd0: //Concatenation
			begin
				checker_result = {ic_data_1, ic_data_2};
				$fdisplay(fh, "OPERATION {} (Concatenation): ic_data_1 = %b, ic_data_2 = %b, checker_result = %b",
					ic_data_1, ic_data_2, checker_result);
			end
			endcase
		end
		'd8: //Replication
		begin
			$fdisplay(fh, "Replication operator");
			case(checker_operator_symbol)
			'd0: //Replication
			begin
				checker_result = { 2 {ic_data_1} };
				$fdisplay(fh, "OPERATION { { } } (Replication): ic_data_1 = %b - replicated twice: checker_result = %b", 
					ic_data_1, checker_result);
			end
			endcase
		end
		'd9: //Conditional
		begin
			$fdisplay(fh, "Conditional operator");
			case(checker_operator_symbol)
			'd0: //Conditional
			begin
				checker_result = (ic_data_1 ? ic_data_2 : ic_data_3);
				$fdisplay(fh, "OPERATION ?: (Conditional): ic_data_1 = %b, ic_data_2 = %b, ic_data_3=%b, checker_result = %b", 
					ic_data_1, ic_data_2, ic_data_3, checker_result);
			end
			endcase
		end
		endcase
		checker_result_parity = ^checker_result; //Parity = XOR of all result's bits
		i = i + 1;
		
		//$fclose(fh);
end

always @ (oc_data_collected[j])
begin
	if(oc_data_collected[j])
	begin
		$fdisplay(fh, "%0d INFO: Collected OUT transaction no %0d: %b", $time, j, oc_data);
		//checker result
		if(checker_result[15:0] === oc_data[15:0])
			$fdisplay(fh, "%0d INFO: Calculus of data for transaction no. %0d match! (%b - %b)", 
				$time, j, checker_result[15:0], oc_data[15:0]);
		else
			$fdisplay(fh, "%0d ERROR: Calculus of data for transaction no. %0d DO NOT match! (%b - %b)", 
				$time, j, checker_result[15:0], oc_data[15:0]);
		//checker parity
		if(checker_result_parity === oc_parity)
			$fdisplay(fh, "%0d INFO: Calculus of parity for transaction no. %0d match! (%b - %b)\n", 
				$time, j, checker_result_parity, oc_parity);
		else
			$fdisplay(fh, "%0d ERROR: Calculus of parity for transaction no. %0d DO NOT match! (%b - %b)\n", 
				$time, j, checker_result_parity, oc_parity);
		j = j + 1;
	end
end

endmodule
