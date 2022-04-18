class first_test;

    virtual tb_ifc.TEST lab2_if;
   //timeunit 1ns/1ns;
    //int seed = 789;
    //parameter NR_OF_TRANSACTIONS = 100;
    int NR_OF_TRANSACTIONS;
    int errors;

    covergroup my_func_coverage;
      coverpoint lab2_if.cb.operand_a {
        bins op_A_values_neg[] = {[-15:-1]};
        bins op_A_values_zero = {0};
        bins op_A_values_pos[] = {[1:15]};
      }
      coverpoint lab2_if.cb.operand_b {
        bins op_B_values_zero = {0};
        bins op_B_values_pos[] = {[1:15]};
        }
        coverpoint lab2_if.cb.opcode {
        bins opcode_values_zero = {0};
        bins opcode_values_pos[] = {[1:7]};
        }
    endgroup

    function new(virtual tb_ifc.TEST ifc);
        lab2_if = ifc;
        errors = 0;
        my_func_coverage = new();
    endfunction
    
  


  //initial begin
    task run();

    if (!$value$plusargs("NR_OF_TRANSACTIONS=%0d", NR_OF_TRANSACTIONS)) begin
      NR_OF_TRANSACTIONS = 10;
    end

    $display("\n\n***********************************************************");
    $display(    "***  THIS IS NOT A SELF-CHECKING TESTBENCH (YET).  YOU  ***");
    $display(    "***  NEED TO VISUALLY VERIFY THAT THE OUTPUT VALUES     ***");
    $display(    "***  MATCH THE INPUT VALUES FOR EACH REGISTER LOCATION  ***");
    $display(    "***********************************************************");
    $display("first header");

    $display("\nReseting the instruction register...");
    lab2_if.cb.write_pointer  <= 5'h00;         // initialize write pointer
    lab2_if.cb.read_pointer   <= 5'h1F;         // initialize read pointer
    lab2_if.cb.load_en        <= 1'b0;          // initialize load control line
    lab2_if.cb.reset_n       <= 1'b0;          // assert reset_n (active low) 
    repeat (2) @(posedge lab2_if.cb) ;     // hold in reset for 2 clock cycles
    lab2_if.cb.reset_n        <= 1'b1;          // deassert reset_n (active low)

    $display("\nWriting values to register stack...");
    @(posedge lab2_if.cb) lab2_if.cb.load_en <= 1'b1;  // enable writing to register
    repeat (NR_OF_TRANSACTIONS) begin
      @(posedge lab2_if.cb) randomize_transaction;
      @(negedge lab2_if.cb) print_transaction; //negedge lab2_if.clk
      my_func_coverage.sample();
    end
    @(posedge lab2_if.cb) lab2_if.cb.load_en <= 1'b0;  // turn-off writing to register

    // read back and display same three register locations
    $display("\nReading back the same register locations written...");
    for (int i = 0; i < NR_OF_TRANSACTIONS; i++) begin
    //repeat (NR_OF_TRANSACTIONS) begin
      // later labs will replace this loop with iterating through a
      // scoreboard to determine which addresses were written and
      // the expected values to be read back
      //@(posedge lab2_if.cb) lab2_if.cb.read_pointer <= $unsigned($random)%10;
      @(posedge lab2_if.cb) lab2_if.cb.read_pointer <= i;
      @(negedge lab2_if.cb) print_results; //negedge lab2_if.clk
    end

    @(posedge lab2_if.cb) ;
    $display("\n***********************************************************");
    $display(  "***  THIS IS NOT A SELF-CHECKING TESTBENCH (YET).  YOU  ***");
    $display(  "***  NEED TO VISUALLY VERIFY THAT THE OUTPUT VALUES     ***");
    $display(  "***  MATCH THE INPUT VALUES FOR EACH REGISTER LOCATION  ***");
    $display(  "***********************************************************\n");
    
    if (errors == 0) begin
      $display("TEST PASSED\n");
    end else if (errors > 0) begin
      $display("TEST FAILED: %0d errors!\n", errors);
    end

    $finish;
  //end
    endtask

  function void randomize_transaction;
    // A later lab will replace this function with SystemVerilog
    // constrained random values
    //
    // The stactic temp variable is required in order to write to fixed
    // addresses of 0, 1 and 2.  This will be replaceed with randomizeed
    // write_pointer values in a later lab
    //
    static int temp = 0;
    lab2_if.cb.operand_a     <= ($signed($urandom))%16;                 // between -15 and 15
    lab2_if.cb.operand_b     <= $unsigned($urandom)%16;            // between 0 and 15
    lab2_if.cb.opcode        <= opcode_t'($unsigned($urandom)%8);  // between 0 and 7, cast to opcode_t type
    lab2_if.cb.write_pointer <= temp++;
  endfunction: randomize_transaction

  function void print_transaction;
    $display("Writing to register location %0d: ", lab2_if.cb.write_pointer);
    $display("  opcode    = %0d (%s)", lab2_if.cb.opcode, lab2_if.cb.opcode.name);
    $display("  operand_a = %0d",   lab2_if.cb.operand_a);
    $display("  operand_b = %0d\n", lab2_if.cb.operand_b);
  endfunction: print_transaction

  function void print_results;
    //instruction word(e o structura) e generat de dut
    $display("Read from register location %0d: ", lab2_if.cb.read_pointer);
    $display("  opcode    = %0d (%s)", lab2_if.cb.instruction_word.opc, lab2_if.cb.instruction_word.opc.name);
    $display("  operand_a = %0d",   lab2_if.cb.instruction_word.op_a);
    $display("  operand_b = %0d", lab2_if.cb.instruction_word.op_b);
    $display("  result    = %0d\n", lab2_if.cb.instruction_word.res);
    checker_results;
  endfunction: print_results

  function void checker_results;
    case (lab2_if.cb.instruction_word.opc.name)
      "PASSA" : begin
        if (lab2_if.cb.instruction_word.res != lab2_if.cb.instruction_word.op_a) begin
          $error("PASSA operation error: Expected result = %0d, Actual result = %0d\n", lab2_if.cb.instruction_word.op_a, lab2_if.cb.instruction_word.res);
          errors++;
        end
      end
      "PASSB" : begin
        if (lab2_if.cb.instruction_word.res != lab2_if.cb.instruction_word.op_b) begin
          $error("PASSB operation error: Expected result = %0d, Actual result = %0d\n", lab2_if.cb.instruction_word.op_b, lab2_if.cb.instruction_word.res);
          errors++;
        end
      end
      "ADD" : begin
        if (lab2_if.cb.instruction_word.res != $signed(lab2_if.cb.instruction_word.op_a + lab2_if.cb.instruction_word.op_b)) begin
          $error("ADD operation error: Expected result = %0d, Actual result = %0d\n", $signed(lab2_if.cb.instruction_word.op_a + lab2_if.cb.instruction_word.op_b), lab2_if.cb.instruction_word.res);
          errors++;
        end
      end
      "SUB" : begin
        if (lab2_if.cb.instruction_word.res != $signed(lab2_if.cb.instruction_word.op_a - lab2_if.cb.instruction_word.op_b)) begin
          $error("SUB operation error: Expected result = %0d, Actual result = %0d\n", $signed(lab2_if.cb.instruction_word.op_a - lab2_if.cb.instruction_word.op_b), lab2_if.cb.instruction_word.res);
          errors++;
        end
      end
      "MULT" : begin
        if (lab2_if.cb.instruction_word.res != $signed(lab2_if.cb.instruction_word.op_a * lab2_if.cb.instruction_word.op_b)) begin
          $error("MULT operation error: Expected result = %0d, Actual result = %0d\n", $signed(lab2_if.cb.instruction_word.op_a * lab2_if.cb.instruction_word.op_b), lab2_if.cb.instruction_word.res);
          errors++;
        end
      end
      "DIV" : begin
        if (lab2_if.cb.instruction_word.res != $signed(lab2_if.cb.instruction_word.op_a / lab2_if.cb.instruction_word.op_b)) begin
          $error("DIV operation error: Expected result = %0d, Actual result = %0d\n", $signed(lab2_if.cb.instruction_word.op_a / lab2_if.cb.instruction_word.op_b), lab2_if.cb.instruction_word.res);
          errors++;
        end
      end
      "MOD" : begin
        if (lab2_if.cb.instruction_word.res != $signed(lab2_if.cb.instruction_word.op_a % lab2_if.cb.instruction_word.op_b)) begin
          $error("MOD operation error: Expected result = %0d, Actual result = %0d\n", $signed(lab2_if.cb.instruction_word.op_a % lab2_if.cb.instruction_word.op_b), lab2_if.cb.instruction_word.res);
          errors++;
        end
      end
    endcase
  endfunction: checker_results

endclass: first_test