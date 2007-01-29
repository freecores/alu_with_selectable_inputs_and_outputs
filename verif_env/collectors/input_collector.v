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


//----------------Collectors----------------

//INPUT COLLECTOR

module INPUT_COLLECTOR(ic_clk, ic_res, ic_stb,
	ic_sel,
	ic_data_in_0, ic_data_in_1, ic_data_in_2,
	ic_data_valid_in,
	ic_data_out_0, ic_data_out_1, ic_data_out_2, ic_data_out_3,
	ic_data_collected);

input ic_clk, ic_res, ic_stb;
input [1:0] ic_sel;
input [7:0] ic_data_in_0, ic_data_in_1, ic_data_in_2;
input ic_data_valid_in;
output [7:0] ic_data_out_0, ic_data_out_1, ic_data_out_2, ic_data_out_3;
output [0:127] ic_data_collected;

reg ic_stb_was_1;

reg [7:0] ic_data_out_0, ic_data_out_1, ic_data_out_2, ic_data_out_3;
reg [0:127] ic_data_collected;

reg [7:0] ic_data[0:3];
integer i, j, k;

integer fh;

always @ (posedge ic_clk or posedge ic_res)
if(ic_res)
begin
	ic_stb_was_1 = 0;
	ic_data_out_0 = 0;
	ic_data_out_1 = 0;
	ic_data_out_2 = 0;
	ic_data_out_3 = 0;
	ic_data_collected = 0;
	for(j = 0; j < 4; j = j + 1)
		ic_data[j] = 0;
	i = 0;
	j = 0;
	k = 0;
end
else
begin
	if(ic_stb)
		ic_stb_was_1 = 1;
	if(ic_data_valid_in)
	begin
		case(ic_sel)
			'd0: ic_data[k] = ic_data_in_0;
			'd1: ic_data[k] = ic_data_in_1;
			'd2: ic_data[k] = ic_data_in_2;
		endcase
		k = k + 1;
	end
	else
	begin
		if(ic_stb_was_1)
		begin
			k = 0;
			for(j = 0; j < 4; j = j + 1)
				case(j)
					'd0: ic_data_out_0 = ic_data[j];
					'd1: ic_data_out_1 = ic_data[j];
					'd2: ic_data_out_2 = ic_data[j];
					'd3: ic_data_out_3 = ic_data[j];
				endcase
		end
		if(ic_stb_was_1)
		begin
			ic_data_collected[i] = 1;
			i = i + 1;
			ic_stb_was_1 = 0;
		end
	end
end

//Print INPUT COLLECTOR buffer contents
always @ (i)
begin
	if(fh === 32'bx)
		fh = $fopen("input_collector.out");

	$fdisplay(fh, "%0d INFO: Input Transaction no: %0d", $time, i);
	$fdisplay(fh, "%0d INFO: ic_data_out_0 = %b", $time, ic_data_out_0);
	// split ic_data_out_0
	$fdisplay(fh, "\tINFO: operator type = %0d", ic_data_out_0[7:4]);
	$fdisplay(fh, "\tINFO: operator symbol = %0d", ic_data_out_0[3:1]);
	$fdisplay(fh, "\tINFO: output channel = %0d", ic_data_out_0[0]);
	//
	$fdisplay(fh, "%0d INFO: ic_data_out_1 = %b", $time, ic_data_out_1);
	$fdisplay(fh, "%0d INFO: ic_data_out_2 = %b", $time, ic_data_out_2);
	$fdisplay(fh, "%0d INFO: ic_data_out_3 = %b\n", $time, ic_data_out_3);
	
	//$fclose(fh);
end

endmodule
