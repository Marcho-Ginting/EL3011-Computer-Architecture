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

module mux2_to_1_rv32i (
    input  wire logic [31:0] A,
    input  wire logic [31:0] B,
    input  wire logic        sel,
    output logic      [31:0] D
);

  always_comb begin
    if (sel == 1'b0) begin
      D = A;
    end else begin
      D = B;
    end
  end

endmodule

`default_nettype wire
