`timescale 1ns / 1ps
`default_nettype none
// Praktikum EL3011 Arsitektur Sistem Komputer
// Modul         : 1
// Tugas         : 1
// Tanggal       : 28 Oktober 2026
// Kelompok      : -
// Rombongan     : -
// Nama (NIM)    : Yozia Gedalya Marcho Ginting (13224001)
// Nama File     : mux2_to_1_rv32i.sv
// Deskripsi     : Implementasi multiplexer 2 ke 1 dengan lebar data 32-bit

module tb_pc_4_adder_rv32i;
  logic [31:0] PC_old;
  wire  [31:0] PC_4_add;

  // Device under test: the adder we're checking.
  pc_4_adder_rv32i dut (
      .PC_old  (PC_old),
      .PC_4_add(PC_4_add)
  );

  initial begin
    PC_old = 32'h0000_0000;
    #10;
    assert (PC_4_add === 32'h0000_0004)
    else $fatal(1, "Test 1 failed: PC = 0");

    PC_old = 32'h0000_0004;
    #10;
    assert (PC_4_add === 32'h0000_0008)
    else $fatal(1, "Test 2 failed: PC = 4");

    PC_old = 32'h0000_00FC;
    #10;
    assert (PC_4_add === 32'h0000_0100)
    else $fatal(1, "Test 3 failed: carry across bits");

    PC_old = 32'hFFFF_FFFC;
    #10;
    assert (PC_4_add === 32'h0000_0000)
    else $fatal(1, "Test 4 failed: 32-bit wraparound");

    $display("All PC + 4 functional tests passed.");
    $finish;
  end

endmodule
`default_nettype wire
