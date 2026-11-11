`timescale 1ns / 1ps
`default_nettype none

// Praktikum EL3011 Arsitektur Sistem Komputer
// Modul         : 2
// Tugas         : 5 (Tugas Pendahuluan)
// Tanggal       : 12 November 2026
// Kelompok      : 8
// Rombongan     : -
// Nama (NIM)    : Yozia Gedalya Marcho Ginting (13224001)
// Nama File     : alu_slt_rv32i.sv
// Deskripsi     : Implementasi ALU set less than

module alu_slt_rv32i (
    input  wire logic [31:0] in1,
    input  wire logic [31:0] in2,
    input  wire logic        sltype,  // 0: signed SLT, 1: unsigned SLTU
    output logic      [31:0] out
);

  always_comb begin
    if (sltype == 1'b0) out = ($signed(in1) < $signed(in2)) ? 32'd1 : 32'd0;
    else out = (in1 < in2) ? 32'd1 : 32'd0;
  end

endmodule

`default_nettype wire
