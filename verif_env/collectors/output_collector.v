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

//OUTPUT COLLECTOR

module OUTPUT_COLLECTOR(oc_clk, oc_res,
	oc_valid_0, oc_valid_1,
	oc_out_0, oc_out_1,
	oc_parity_0, oc_parity_1,
	oc_data,
	oc_parity,
	oc_data_collected);

input oc_clk, oc_res;
input oc_valid_0, oc_valid_1;
input [15:0] oc_out_0, oc_out_1;
input oc_parity_0, oc_parity_1;
output [15:0] oc_data;
output oc_parity;
output [0:127] oc_data_collected;

reg [15:0] oc_data;
reg oc_parity;
reg [0:127] oc_data_collected;

integer i;
integer fh;

always @ (posedge oc_clk or posedge oc_res)
if(oc_res)
begin
	i = 0;
	oc_data = 0;
	oc_parity = 0;
	oc_data_collected = 0;
end
else
begin
	if(oc_valid_0)
	begin
		oc_data = oc_out_0;
		oc_parity = oc_parity_0;
		oc_data_collected[i] = 1;
		i = i + 1;
	end
	if(oc_valid_1)
	begin
		oc_data = oc_out_1;
		oc_parity = oc_parity_1;
		oc_data_collected[i] = 1;
		i = i + 1;
	end
end

//Print OUTPUT COLLECTOR buffer contents
always @ (i)
begin
	if(fh === 32'bx)
		fh = $fopen("output_collector.out");

	$fdisplay(fh, "%0d INFO: Output Transaction no: %0d", $time, i);
	$fdisplay(fh, "%0d INFO: oc_data = %b", $time, oc_data);
	$fdisplay(fh, "%0d INFO: oc_parity = %b\n", $time, oc_parity);

	//$fclose(fh);
end

endmodule
