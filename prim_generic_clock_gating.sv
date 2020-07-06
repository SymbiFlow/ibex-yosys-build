// Copyright lowRISC contributors.
// Licensed under the Apache License, Version 2.0, see LICENSE for details.
// SPDX-License-Identifier: Apache-2.0
//
// Common Library: Clock Gating cell

module prim_generic_clock_gating (
  input        clk_i,
  input        en_i,
  input        test_en_i,
  output logic clk_o
);
  assign clk_o = clk_i;

endmodule

