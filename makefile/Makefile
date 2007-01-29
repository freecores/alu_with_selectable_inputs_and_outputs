#/////////////////////////////////////////////////////////////////////
#////                                                             ////
#////      This project has been provided to you on behalf of:    ////
#////                                                             ////
#////      	S.C. ASICArt S.R.L.                               ////
#////				www.asicart.com                   ////
#////				eli_f@asicart.com                 ////
#////                                                             ////
#////        Author: Dragos Constantin Doncean                    ////
#////        Email: doncean@asicart.com                           ////
#////        Mobile: +40-740-936997                               ////
#////                                                             ////
#////      Downloaded from: http://www.opencores.org/             ////
#////                                                             ////
#/////////////////////////////////////////////////////////////////////
#////                                                             ////
#//// Copyright (C) 2007 Dragos Constantin Doncean                ////
#////                         www.asicart.com                     ////
#////                         doncean@asicart.com                 ////
#////                                                             ////
#//// This source file may be used and distributed without        ////
#//// restriction provided that this copyright statement is not   ////
#//// removed from the file and that any derivative work contains ////
#//// the original copyright notice and the associated disclaimer.////
#////                                                             ////
#////     THIS SOFTWARE IS PROVIDED ``AS IS'' AND WITHOUT ANY     ////
#//// EXPRESS OR IMPLIED WARRANTIES, INCLUDING, BUT NOT LIMITED   ////
#//// TO, THE IMPLIED WARRANTIES OF MERCHANTABILITY AND FITNESS   ////
#//// FOR A PARTICULAR PURPOSE. IN NO EVENT SHALL THE AUTHOR      ////
#//// OR CONTRIBUTORS BE LIABLE FOR ANY DIRECT, INDIRECT,         ////
#//// INCIDENTAL, SPECIAL, EXEMPLARY, OR CONSEQUENTIAL DAMAGES    ////
#//// (INCLUDING, BUT NOT LIMITED TO, PROCUREMENT OF SUBSTITUTE   ////
#//// GOODS OR SERVICES; LOSS OF USE, DATA, OR PROFITS; OR        ////
#//// BUSINESS INTERRUPTION) HOWEVER CAUSED AND ON ANY THEORY OF  ////
#//// LIABILITY, WHETHER IN  CONTRACT, STRICT LIABILITY, OR TORT  ////
#//// (INCLUDING NEGLIGENCE OR OTHERWISE) ARISING IN ANY WAY OUT  ////
#//// OF THE USE OF THIS SOFTWARE, EVEN IF ADVISED OF THE         ////
#//// POSSIBILITY OF SUCH DAMAGE.                                 ////
#////                                                             ////
#/////////////////////////////////////////////////////////////////////

all: sim

_RTL_ = 	../rtl/dut.v \
		../rtl/selector.v \
		../rtl/alu.v \
		../rtl/dmux.v

TEST_TYPE = 

ifeq ($(TEST_TYPE), improved_test.v)

_TEST_ =	../tests/improved_test.v

_BFMS_ =	../verif_env/bfms/clk_gen.v \
		../verif_env/bfms/res_bfm.v \
		../verif_env/bfms/data_in_bfm.v

_MONITORS_ =	../verif_env/monitors/clk_monitor.v \
		../verif_env/monitors/res_monitor.v \
		../verif_env/monitors/stb_monitor.v \
		../verif_env/monitors/sel_monitor.v \
		../verif_env/monitors/data_valid_in_monitor.v \
		../verif_env/monitors/data_in_monitor.v \
		../verif_env/monitors/data_out_monitor.v \
		../verif_env/monitors/parity_monitor.v \
		../verif_env/monitors/valid_monitor.v

_COLLECTORS_ =	../verif_env/collectors/input_collector.v \
		../verif_env/collectors/output_collector.v

_CHECKER_ =	../verif_env/checker/checker.v

SOURCE_FILES =	$(_RTL_) $(_BFMS_) $(_MONITORS_) $(_COLLECTORS_) $(_CHECKER_) $(_TEST_)

endif

ifeq ($(TEST_TYPE), directed_test.v)
	_TEST_ =	../tests/directed_test.v
	SOURCE_FILES =	$(_RTL_) $(_TEST_)
endif

ifeq ($(TEST_TYPE), random_test.v)
	_TEST_ =	../tests/random_test.v
	SOURCE_FILES =	$(_RTL_) $(_TEST_)
endif

RUN_COMMAND = verilog

sim:
	$(RUN_COMMAND) $(SOURCE_FILES)

clean :
	rm -f *.log
	rm -f *.out
	rm -rf waves/*
