`timescale 1ns / 1ps
`default_nettype none
// Praktikum EL3011 Arsitektur Sistem Komputer
// Modul         : 1
// Tugas         : 3
// Tanggal       : 28 Oktober 2026
// Kelompok      : -
// Rombongan     : -
// Nama (NIM)    : Yozia Gedalya Marcho Ginting (13224001)
// Nama File     : tb_pc_rv32i.sv
// Deskripsi     : Pengujian program counter 32-bit

module tb_pc_rv32i;

  logic        clock;
  logic        reset;
  logic [31:0] PC_in;
  wire  [31:0] PC_out;

  pc_rv32i dut (
      .clock (clock),
      .reset (reset),
      .PC_in (PC_in),
      .PC_out(PC_out)
  );

  // 10 ns period
  initial begin
    clock = 1'b0;
    forever #5 clock = ~clock;
  end

  initial begin
    // Test 1: synchronous reset takes effect on a rising edge.
    reset = 1'b1;
    PC_in = 32'h1234_5678;
    @(posedge clock);
    #1;
    assert (PC_out === 32'h0000_0000)
    else $fatal(1, "Test 1 failed: reset did not clear PC_out");

    // Test 2: without reset, PC stores PC_in on a rising edge.
    reset = 1'b0;
    PC_in = 32'h0000_0004;
    @(posedge clock);
    #1;
    assert (PC_out === 32'h0000_0004)
    else $fatal(1, "Test 2 failed: PC did not load PC_in");

    // Test 3: PC_out holds its value between rising edges.
    PC_in = 32'h0000_0008;
    #2;
    assert (PC_out === 32'h0000_0004)
    else $fatal(1, "Test 3 failed: PC changed between clock edges");

    // Test 4: it loads the new input at the next rising edge.
    @(posedge clock);
    #1;
    assert (PC_out === 32'h0000_0008)
    else $fatal(1, "Test 4 failed: PC did not update at clock edge");

    // Test 5: reset overrides PC_in at the next rising edge.
    reset = 1'b1;
    PC_in = 32'hFFFF_FFFF;
    @(posedge clock);
    #1;
    assert (PC_out === 32'h0000_0000)
    else $fatal(1, "Test 5 failed: reset did not override PC_in");

    $display("All synchronous PC tests passed.");
    $finish;
  end

endmodule

`default_nettype wire
