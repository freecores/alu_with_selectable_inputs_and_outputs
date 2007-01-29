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


//TEST MODULE - IMPROVED TEST

module proj_improved_test;

wire test_clk, test_res, test_stb;
wire [1:0] test_sel;
wire [7:0] test_data_in_0, test_data_in_1, test_data_in_2;
wire test_data_valid_in;
wire test_valid_0, test_valid_1;
wire [15:0] test_out_0, test_out_1;
wire test_parity_0, test_parity_1;
wire [7:0] test_ic_data_0, test_ic_data_1, test_ic_data_2, test_ic_data_3;
wire [15:0] test_oc_data;
wire test_oc_parity;
wire [0:127] test_ic_data_collected, test_oc_data_collected;

//DUT instantiation
DUT dut(.dut_clk(test_clk), .dut_res(test_res), .dut_stb(test_stb),
		.dut_sel(test_sel), 
		.dut_data_in_0(test_data_in_0), .dut_data_in_1(test_data_in_1), .dut_data_in_2(test_data_in_2),
		.dut_data_valid_in(test_data_valid_in),
		.dut_valid_0(test_valid_0), .dut_valid_1(test_valid_1),
		.dut_out_0(test_out_0), .dut_out_1(test_out_1),
		.dut_parity_0(test_parity_0), .dut_parity_1(test_parity_1));

//DUT VERIFICATION ENVIRONMENT
//Contains CLK generator, monitors, BFMs, collectors and the checker
//They are instantiated here, in the test module

//--------BFMs' instantiations--------
CLK_GEN clk_gen(.gen_clk(test_clk));

RES_BFM res_bfm(.bfm_res(test_res));

DATA_IN_BFM data_in_bfm(.bfm_stb(test_stb),
	.bfm_sel(test_sel),
	.bfm_data_in_0(test_data_in_0), .bfm_data_in_1(test_data_in_1), .bfm_data_in_2(test_data_in_2),
	.bfm_data_valid_in(test_data_valid_in));

//--------Monitors' instantiations--------
CLK_MONITOR clk_monitor(.m_clk(test_clk));

RES_MONITOR res_monitor(.m_res(test_res));

STB_MONITOR stb_monitor(.m_clk(test_clk), .m_stb(test_stb));

SEL_MONITOR sel_monitor(.m_clk(test_clk), .m_stb(test_stb), .m_sel(test_sel));

DATA_IN_MONITOR data_in_monitor(.m_clk(test_clk), .m_stb(test_stb),
	.m_data_in_0(test_data_in_0), .m_data_in_1(test_data_in_1), .m_data_in_2(test_data_in_2));

DATA_VALID_IN_MONITOR data_valid_in_monitor(.m_clk(test_clk), .m_stb(test_stb),
	.m_data_valid_in(test_data_valid_in));

VALID_MONITOR valid_monitor(.m_clk(test_clk), .m_res(test_res),
	.m_valid_0(test_valid_0), .m_valid_1(test_valid_1));

DATA_OUT_MONITOR data_out_monitor(.m_clk(test_clk), .m_res(test_res), 
	.m_out_0(test_out_0), .m_out_1(test_out_1));

PARITY_MONITOR parity_monitor(.m_clk(test_clk), .m_res(test_res),
	.m_parity_0(test_parity_0), .m_parity_1(test_parity_1));

//--------Collectors' instantiations--------
INPUT_COLLECTOR input_collector(.ic_clk(test_clk), .ic_res(test_res), .ic_stb(test_stb),
	.ic_sel(test_sel),
	.ic_data_in_0(test_data_in_0), .ic_data_in_1(test_data_in_1), .ic_data_in_2(test_data_in_2),
	.ic_data_valid_in(test_data_valid_in),
	.ic_data_out_0(test_ic_data_0), .ic_data_out_1(test_ic_data_1), .ic_data_out_2(test_ic_data_2), .ic_data_out_3(test_ic_data_3),
	.ic_data_collected(test_ic_data_collected));

OUTPUT_COLLECTOR output_collector(.oc_clk(test_clk), .oc_res(test_res),
	.oc_valid_0(test_valid_0), .oc_valid_1(test_valid_1),
	.oc_out_0(test_out_0), .oc_out_1(test_out_1),
	.oc_parity_0(test_parity_0), .oc_parity_1(test_parity_1),
	.oc_data(test_oc_data),
	.oc_parity(test_oc_parity),
	.oc_data_collected(test_oc_data_collected));

//--------Checker's instantiation--------
CHECKER checker(.c_clk(test_clk), .c_res(test_res),
	.ic_data_0(test_ic_data_0), .ic_data_1(test_ic_data_1), .ic_data_2(test_ic_data_2), .ic_data_3(test_ic_data_3),
	.oc_data(test_oc_data),
	.oc_parity(test_oc_parity),
	.ic_data_collected(test_ic_data_collected),
	.oc_data_collected(test_oc_data_collected));

//Waveform database
initial
begin

	$shm_open("../run/waves/waves_improved_test");  // Open database named "waves"
	$shm_probe(proj_improved_test, "AS"); // Record tb scope and all sub hierarchy
end

/*
//for waveform viewing with GTKWave
initial
begin
	$dumpfile ("proj0.dump") ;
	$dumpvars;
	$dumpon;
	//$dumpall;
end
*/

endmodule
