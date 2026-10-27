`timescale 1ns / 1ps
`default_nettype none
// Praktikum EL3011 Arsitektur Sistem Komputer
// Modul         : 1
// Tugas         : 1
// Tanggal       : 28 Oktober 2026
// Kelompok      : -
// Rombongan     : -
// Nama (NIM)    : Yozia Gedalya Marcho Ginting (13224001)
// Nama File     : tb_instr_rom_rv32i.sv
// Deskripsi     : Pengujian instruction memory

module tb_instr_rom_rv32i;

  logic [31:0] ADDR;
  logic        clock;
  logic        reset;
  logic [31:0] INSTR;

  instr_rom_rv32i dut (
      .ADDR (ADDR),
      .clock(clock),
      .reset(reset),
      .INSTR(INSTR)
  );

  // Ten-nanosecond clock period
  initial begin
    clock = 1'b0;
    forever #5 clock = ~clock;
  end

  task automatic check_instruction(input logic [31:0] address, input logic [31:0] expected);
    begin
      ADDR = address;
      @(posedge clock);
      #1;

      assert (INSTR === expected)
      else $fatal(1, "FAIL: ADDR = %h, INSTR = %h, expected = %h", address, INSTR, expected);
    end
  endtask

  initial begin
    ADDR  = 32'h0000_0000;
    reset = 1'b1;

    // Reset is asynchronous
    #1;
    assert (INSTR === 32'h0000_0013)
    else $fatal(1, "FAIL: reset did not produce RV32I NOP");

    reset = 1'b0;

    // Check byte address
    check_instruction(32'h0000_0000, 32'h0010_0293);  // mem[0]
    check_instruction(32'h0000_0004, 32'h0000_0313);  // mem[1]
    check_instruction(32'h0000_0008, 32'h00A0_0393);  // mem[2]
    check_instruction(32'h0000_0014, 32'h0053_0333);  // mem[5]
    check_instruction(32'h0000_001C, 32'h0000_0513);  // mem[7]

    // Unused memory location contain the default NOP.
    check_instruction(32'h0000_0020, 32'h0000_0013);  // mem[8]

    $display("PASS: all instruction-ROM checks succeeded.");
    $finish;
  end

endmodule

`default_nettype wire
