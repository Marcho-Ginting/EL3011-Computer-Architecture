`timescale 1ns / 1ps
`default_nettype none

module tb_instr_rom_rv32i;

  logic [31:0] ADDR;
  logic        clock;
  logic        reset;
  logic [31:0] INSTR;

  instr_rom_rv32i dut (
      .ADDR  (ADDR),
      .clock (clock),
      .reset (reset),
      .INSTR (INSTR)
  );

  // The one and only clock generator.
  initial begin
    clock = 1'b0;
    forever #5 clock = ~clock;
  end

  task automatic check_instruction (
      input logic [31:0] address,
      input logic [31:0] expected
  );
    begin
      ADDR = address;

      // Capture the ROM output on one rising edge.
      @(posedge clock);

      // Check one full clock period later, after implementation delay.
      @(posedge clock);
      #1;

      assert (INSTR === expected)
        else $fatal(
            1,
            "FAIL: ADDR = %h, INSTR = %h, expected = %h",
            address, INSTR, expected
        );
    end
  endtask

  // The one and only test sequence.
  initial begin
    ADDR  = 32'h0000_0000;
    reset = 1'b0;

    // Let Xilinx startup behavior settle before testing.
    #120;

    // Create a real 0-to-1 reset transition.
    reset = 1'b1;

    // Wait for delayed reset propagation.
    @(posedge clock);
    @(posedge clock);
    #1;

    assert (INSTR === 32'h0000_0013)
      else $fatal(1, "FAIL: reset did not produce RV32I NOP");

    reset = 1'b0;

    check_instruction(32'h0000_0000, 32'h0010_0293);
    check_instruction(32'h0000_0004, 32'h0000_0313);
    check_instruction(32'h0000_0008, 32'h00A0_0393);
    check_instruction(32'h0000_0014, 32'h0053_0333);
    check_instruction(32'h0000_001C, 32'h0000_0513);
    check_instruction(32'h0000_0020, 32'h0000_0013);

    $display("PASS: all instruction-ROM checks succeeded.");
    $finish;
  end

endmodule

`default_nettype wire