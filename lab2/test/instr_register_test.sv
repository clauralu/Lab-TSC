/***********************************************************************
 * A SystemVerilog testbench for an instruction register.
 * The course labs will convert this to an object-oriented testbench
 * with constrained random test generation, functional coverage, and
 * a scoreboard for self-verification.
 **********************************************************************/

module instr_register_test

import instr_register_pkg::*;  // user-defined types are defined in instr_register_pkg.sv
  (
    tb_ifc.TEST lab2_if
  );
include "instr_register_class.svh";

initial begin
  first_test ft;
  ft=new(lab2_if);
  ft.run();
end

endmodule: instr_register_test
