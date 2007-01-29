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


//DMUX

module DMUX(clk, res, dmux_stb_in,
	alu_result, result_parity,
	output_channel,
	valid_0, valid_1,
	out_0, out_1,
	parity_0, parity_1);

input clk, res, dmux_stb_in;
input [15:0] alu_result;
input result_parity;
input output_channel;
output valid_0, valid_1;
output [15:0] out_0, out_1;
output parity_0, parity_1;

reg valid_0, valid_1;
reg [15:0] out_0, out_1;
reg parity_0, parity_1;

reg dmux_stb_in_was_1;
integer i;

always @ (posedge clk or posedge res)
begin
	if(res)
	begin
		valid_0 = 0;
		valid_1 = 0;
		out_0 = 16'b0;
		out_1 = 16'b0;
		parity_0 = 0;
		parity_1 = 0;
		dmux_stb_in_was_1 = 0;
		i = 0;
	end
	else
	begin
		if(valid_0 === 1) 
			valid_0 = 0;
		if(valid_1 === 1)
			valid_1 = 0;
	end
end

always @ (posedge clk)
begin
	if(dmux_stb_in === 1)
		dmux_stb_in_was_1 = 1;
	if(dmux_stb_in_was_1 === 1)
		i = i + 1;
end

always @ (i)
if (i === 5)
begin
		case(output_channel)
		1'b0: 
		begin
			out_0 = alu_result;
			parity_0 = result_parity;
			valid_0 = 1;
		end
		1'b1:
		begin
			out_1 = alu_result;
			parity_1 = result_parity;
			valid_1 = 1;
		end
	endcase
	i = 0;
	dmux_stb_in_was_1 = 0;
end
	
endmodule
