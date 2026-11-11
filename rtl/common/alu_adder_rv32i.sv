`timescale 1ns / 1ps
`default_nettype none

// Praktikum EL3011 Arsitektur Sistem Komputer
// Modul         : 2
// Tugas         : 2 (Tugas Pendahuluan)
// Tanggal       : 12 November 2026
// Kelompok      : 8
// Rombongan     : -
// Nama (NIM)    : Yozia Gedalya Marcho Ginting (13224001)
// Nama File     : alu_adder_rv32i.sv
// Deskripsi     : Implementasi ALU

module alu_adder_rv32i (
    input  wire logic [31:0] in1,
    input  wire logic [31:0] in2,
    input  wire logic        sub,  // 0: add, 1: subtract
    output logic      [31:0] out
);

  always_comb begin
    out = in1 + (in2 ^ {32{sub}}) + {31'b0, sub};
  end

endmodule

`default_nettype wire
