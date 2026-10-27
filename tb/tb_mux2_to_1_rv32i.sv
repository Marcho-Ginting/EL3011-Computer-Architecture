`timescale 1ns / 1ps
`default_nettype none

// Praktikum EL3011 Arsitektur Sistem Komputer
// Modul         : 1
// Tugas         : 1
// Tanggal       : 28 Oktober 2026
// Kelompok      : -
// Rombongan     : -
// Nama (NIM)    : Yozia Gedalya Marcho Ginting (13224001)
// Nama File     : tb_mux2_to_1_rv32i.sv
// Deskripsi     : Test bench untuk multiplexer 2 ke 1 dengan lebar data 32-bit

module tb_mux2_to_1_rv32i;

  // Testbench signals
  logic [31:0] A;
  logic [31:0] B;
  logic sel;
  wire [31:0] D;

  // Device Under Test (DUT)
  mux2_to_1_rv32i dut (
      .A  (A),
      .B  (B),
      .sel(sel),
      .D  (D)
  );

  // Apply test vectors
  initial begin

    // Test 1: Select Input A
    A   = 32'h12345678;
    B   = 32'hABCDEF00;
    sel = 1'b0;

    #10;
    assert (D === A)
    else $fatal(1, "Test 1 failed: D should equal A");

    // Test 2: Select Input B
    sel = 1'b1;

    #10;
    assert (D === B)
    else $fatal(1, "Test 2 failed: D should equal B");
    // Test 3: Change the selected input B
    B = 32'hDEADBEEF;

    #10;
    assert (D === B)
    else $fatal(1, "Test 3 failed: D should follow B");

    // Test 4: Change the unselected input A
    A = 32'hFFFFFFFF;

    #10;
    assert (D === B)
    else $fatal(1, "Test 4 failed: D should remain B");

    $display("All functional tests passed.");
    $finish;
  end

endmodule

`default_nettype wire
