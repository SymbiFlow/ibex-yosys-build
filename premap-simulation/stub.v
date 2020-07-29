/*
 * This is part of cells_sim.v file which belongs to Yosys project.
 * (techlibs/xilinx/cells_sim.v)
 */

// See Xilinx UG953 and UG474 for a description of the cell types below.
// http://www.xilinx.com/support/documentation/user_guides/ug474_7Series_CLB.pdf
// http://www.xilinx.com/support/documentation/sw_manuals/xilinx2014_4/ug953-vivado-7series-libraries.pdf
(* abc9_box, lib_whitebox *)
module CARRY4_COUT(
    output [3:0] O,
    (* abc9_carry *)
    output COUT,
    (* abc9_carry *)
    input CI,
    input CYINIT,
    input [3:0] DI, S);
  wire CI0 = CYINIT | CI;

  wire [3:0] CO;

  assign O = S ^ {CO[2:0], CI0};
  assign CO[0] = S[0] ? CI0 : DI[0];
  assign CO[1] = S[1] ? CO[0] : DI[1];
  assign CO[2] = S[2] ? CO[1] : DI[2];
  wire CO_TOP  = S[3] ? CO[2] : DI[3];
  assign CO[3] = CO_TOP;
  assign COUT = CO_TOP;
  specify
    (CYINIT => O[0]) = 482;
    (S[0]   => O[0]) = 223;
    (CI     => O[0]) = 222;
    (CYINIT => O[1]) = 598;
    (DI[0]  => O[1]) = 407;
    (S[0]   => O[1]) = 400;
    (S[1]   => O[1]) = 205;
    (CI     => O[1]) = 334;
    (CYINIT => O[2]) = 584;
    (DI[0]  => O[2]) = 556;
    (DI[1]  => O[2]) = 537;
    (S[0]   => O[2]) = 523;
    (S[1]   => O[2]) = 558;
    (S[2]   => O[2]) = 226;
    (CI     => O[2]) = 239;
    (CYINIT => O[3]) = 642;
    (DI[0]  => O[3]) = 615;
    (DI[1]  => O[3]) = 596;
    (DI[2]  => O[3]) = 438;
    (S[0]   => O[3]) = 582;
    (S[1]   => O[3]) = 618;
    (S[2]   => O[3]) = 330;
    (S[3]   => O[3]) = 227;
    (CI     => O[3]) = 313;
    (CYINIT => COUT) = 580;
    (DI[0]  => COUT) = 526;
    (DI[1]  => COUT) = 507;
    (DI[2]  => COUT) = 398;
    (DI[3]  => COUT) = 385;
    (S[0]   => COUT) = 508;
    (S[1]   => COUT) = 528;
    (S[2]   => COUT) = 378;
    (S[3]   => COUT) = 380;
    (CI     => COUT) = 114;
  endspecify
endmodule

(* abc9_box, blackbox *)
module CARRY_COUT_PLUG(input CIN, output COUT);

  assign COUT = CIN;
  specify
    (CIN => COUT) = 0;
  endspecify

endmodule
