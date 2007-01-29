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


//SELECTOR

module SELECTOR(clk, res, stb,
	sel,
	data_in_0, data_in_1, data_in_2,
	data_valid_in,
	data_out, data_valid_out,
	stb_out);

input clk, res, stb;
input [1:0] sel;
input [7:0] data_in_0, data_in_1, data_in_2;
input data_valid_in;
output [7:0] data_out;
output data_valid_out;
output stb_out;

reg [1:0] reg_sel;
reg [7:0] data_out;
reg data_valid_out;
reg stb_out;

always @ (posedge clk or posedge res)
begin
	if(res)
	begin
		reg_sel = 1'b0;
		data_out = 8'b0;
		data_valid_out = 1'b0;
		stb_out = 1'b0;
	end
	else
	begin
		if(stb)
			reg_sel = sel;
		case(reg_sel[1:0])
				2'b00: data_out = data_in_0;
				2'b01: data_out = data_in_1;
				2'b10: data_out = data_in_2;
		endcase
		data_valid_out = data_valid_in;
		stb_out = stb;
	end
end

endmodule
