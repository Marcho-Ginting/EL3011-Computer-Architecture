`timescale 1ns / 1ps
`default_nettype none

// Praktikum EL3011 Arsitektur Sistem Komputer
// Modul         : 2
// Tugas         : 4 (Tugas Pendahuluan)
// Tanggal       : 12 November 2026
// Kelompok      : 8
// Rombongan     : -
// Nama (NIM)    : Yozia Gedalya Marcho Ginting (13224001)
// Nama File     : alu_shifter_rv32i.sv
// Deskripsi     : Implementasi ALU shifter

module alu_shifter_rv32i (
    input wire logic [31:0] in,
    input wire logic [31:0] shamt,
    input wire logic [1:0] shiftype,
    output logic [31:0] out
);

  always_comb begin
    case (shiftype)
      2'b00:   out = in << shamt[4:0];
      2'b01:   out = in >> shamt[4:0];
      2'b10:   out = $signed(in) >>> shamt[4:0];
      default: out = 32'b0;
    endcase
  end

endmodule

`default_nettype wire
