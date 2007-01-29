#! /usr/bin/perl -w


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


use Getopt::Long;
use IO::Handle;

######################################################################
# the help print
######################################################################
my $help = <<EndHelp;
Usage:
RunTest.pl <test_name>  [-help|-h]
			[-log|-l <log filename>]

The arguments meaning:
----------------------

<test_name>                             - the test name (can be with or without the extention .vr)
[-help|-h]                              - print this help screen
[-log|-l <log filename>]                - the test name

EndHelp

######################################################################
# check the arguments
######################################################################
$result = &GetOptions(\%optctl, "help|h", "log|l=s");

if($result == 0 || $#ARGV == -1 || defined($optctl{help})){
  print $help;
  exit 0;
}

$test_name = $ARGV[0];
$test_name =~ s/\.v$//;
$test_file = "$test_name" . ".v";

unless (-e $test_file) {
  die "\n       Test file $test_file does not exist!!!\n" .
      "         exiting ...\n";
}

if(defined($optctl{"log"})){
  $log_file = $optctl{"log"};
}
else{
  $log_file = $test_name . ".log";
}

######################################################################
# open the log file, create cds.lib and hdl.var
######################################################################
open (LOG_FILE, "> $log_file") or die " Can not open file $log_file\n\n";
autoflush LOG_FILE;
SystemCmd("date");
close (LOG_FILE);

######################################################################
# compile the test
######################################################################
my $test_compile_cmd = "verilog -c $test_file";
SystemCmd("$test_compile_cmd");

######################################################################
# clean the test directory
######################################################################
SystemCmd("make clean");

######################################################################
# run the simulation
######################################################################
my $sim_cmd = "make TEST_TYPE=$test_file";
SystemCmd("$sim_cmd");

######################################################################
# Execute system command
######################################################################
sub SystemCmd  # Arg: Command string
{
  my($command_line) = @_;
  open (LOG_FILE, ">> $log_file") or die "Can not create $log_file file\n";
  autoflush LOG_FILE;
  print LOG_FILE "\nExecuting '$command_line >> $log_file 2>&1'\n";
  close(LOG_FILE);
  sleep 1;
  system "$command_line >> $log_file 2>&1";
  my $rc = $?/256;
  sleep 1;
  open (LOG_FILE, ">> $log_file") or die "Can not create $log_file file\n";
  autoflush LOG_FILE;
  if ($rc != 0) {
    print LOG_FILE "\nWARNING: Return code of system command $command_line >> $log_file > 2>&1 = $rc != 0\n";
  }
  close (LOG_FILE);
  $rc;
}
