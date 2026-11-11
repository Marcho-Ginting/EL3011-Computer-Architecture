`timescale 1ns / 1ps
`default_nettype none

// Praktikum EL3011 Arsitektur Sistem Komputer
// Modul         : 2
// Tugas         : 1 (Tugas Pendahuluan)
// Tanggal       : 12 November 2026
// Kelompok      : 8
// Rombongan     : -
// Nama (NIM)    : Yozia Gedalya Marcho Ginting (13224001)
// Nama File     : mux4_to_1_rv32i.sv
// Deskripsi     : Implementasi multiplexer 4 to 1

module mux4_to_1_rv32i (
    input wire logic [31:0] W,
    input wire logic [31:0] X,
    input wire logic [31:0] Y,
    input wire logic [31:0] Z,
    input wire logic [1:0] sel,
    output logic [31:0] D
);

  always_comb begin
    case (sel)
      2'b00:   D = W;
      2'b01:   D = X;
      2'b10:   D = Y;
      2'b11:   D = Z;
      default: D = 32'b0;
    endcase
  end

endmodule

`default_nettype wire
