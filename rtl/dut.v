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


//DUT

module DUT(dut_clk, dut_res, dut_stb,
	dut_sel,
	dut_data_in_0, dut_data_in_1, dut_data_in_2,
	dut_data_valid_in, 
	dut_valid_0, dut_valid_1,
	dut_out_0, dut_out_1,
	dut_parity_0, dut_parity_1);

input dut_clk, dut_res, dut_stb;
input [1:0] dut_sel;
input [7:0] dut_data_in_0, dut_data_in_1, dut_data_in_2;
input dut_data_valid_in;
output dut_valid_0, dut_valid_1;
output [15:0] dut_out_0, dut_out_1;
output dut_parity_0, dut_parity_1;

wire [7:0] dut_data_out;
wire dut_data_valid_out;
wire dut_selector_alu_stb;
wire dut_alu_dmux_stb;
wire [15:0] dut_alu_result;
wire dut_parity;
wire dut_output_channel;
wire dut_parity_0, dut_parity_1;

//Modules' instantiations

SELECTOR selector(.clk(dut_clk), .res(dut_res), .stb(dut_stb),
		.sel(dut_sel),
		.data_in_0(dut_data_in_0), .data_in_1(dut_data_in_1), .data_in_2(dut_data_in_2),
		.data_valid_in(dut_data_valid_in),
		.data_out(dut_data_out), .data_valid_out(dut_data_valid_out),
		.stb_out(dut_selector_alu_stb));

ALU alu(.clk(dut_clk), .res(dut_res), .alu_stb_in(dut_selector_alu_stb),
		.alu_data_in(dut_data_out), .alu_data_valid_in(dut_data_valid_out), 
		.alu_result(dut_alu_result), .result_parity(dut_parity),
		.output_channel(dut_output_channel),
		.alu_stb_out(dut_alu_dmux_stb));

DMUX dmux(.clk(dut_clk), .res(dut_res), .dmux_stb_in(dut_alu_dmux_stb),
		.alu_result(dut_alu_result), .result_parity(dut_parity), 
		.output_channel(dut_output_channel),
		.valid_0(dut_valid_0), .valid_1(dut_valid_1),
		.out_0(dut_out_0), .out_1(dut_out_1), 
		.parity_0(dut_parity_0), .parity_1(dut_parity_1));

endmodule
