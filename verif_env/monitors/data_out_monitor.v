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


//----------------Monitors----------------

//DATA_OUT MONITOR

module DATA_OUT_MONITOR(m_clk, m_res, m_out_0, m_out_1);
input m_clk, m_res;
input [15:0] m_out_0, m_out_1;

reg res_was_active;
integer i;

integer fh;

always @ (posedge m_clk)
if(m_res)
	res_was_active = 1;
else
	if(res_was_active)
	begin
		if(fh === 32'bx)
			fh = $fopen("data_out_monitor.out");
			
		for (i = 0; i < 16; i = i + 1)
		begin
			if ((m_out_0[i] === 1'bx) || (m_out_0[i] === 1'bz))
				$fdisplay(fh, "%0d ERROR: OUT_0[%0d] doesn't have a valid value (%b)", $time, i, m_out_0[i]);
			if ((m_out_1[i] === 1'bx) || (m_out_1[i] === 1'bz))
				$fdisplay(fh, "%0d ERROR: OUT_1[%0d] doesn't have a valid value (%b)", $time, i, m_out_1[i]);
		end
		
		//$fclose(fh);
	end

endmodule
