`timescale 1ns / 1ps
`default_nettype none
// Praktikum EL3011 Arsitektur Sistem Komputer
// Modul         : 1
// Tugas         : 3
// Tanggal       : 28 Oktober 2026
// Kelompok      : -
// Rombongan     : -
// Nama (NIM)    : Yozia Gedalya Marcho Ginting (13224001)
// Nama File     : pc_rv32i.sv
// Deskripsi     : Implementasi program counter 32-bit

module pc_rv32i (
    input wire logic clock,
    input wire logic reset,  //< Active-high synchronous
    input wire logic [31:0] PC_in,
    output logic [31:0] PC_out
);

  always_ff @(posedge clock) begin
    if (reset) PC_out <= 32'h0000_0000;
    else PC_out <= PC_in;
  end

endmodule

`default_nettype none
