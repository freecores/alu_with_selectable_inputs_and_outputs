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

//PARITY MONITOR

module PARITY_MONITOR(m_clk, m_res, m_parity_0, m_parity_1);
input m_clk, m_res;
input m_parity_0, m_parity_1;

reg res_was_active;

integer fh0, fh1;

always @ (posedge m_clk)
if(m_res)
	res_was_active = 1;
else
	if(res_was_active)
	begin
		if(fh0 === 32'bx)
			fh0 = $fopen("parity_0_monitor.out");
		if(fh1 === 32'bx)
			fh1 = $fopen("parity_1_monitor.out");
			
		if ((m_parity_0 === 1'bx) || (m_parity_0 === 1'bz))
			$fdisplay(fh0, "%0d ERROR: PARITY_0 doesn't have a valid value (%b)", $time, m_parity_0);
		if ((m_parity_1 === 1'bx) || (m_parity_1 === 1'bz))
			$fdisplay(fh1, " ERROR: PARITY_1 doesn't have a valid value (%b)", $time, m_parity_1);
		
		//$fclose(fh0);
		//$fclose(fh1);
	end

endmodule
