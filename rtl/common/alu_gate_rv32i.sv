`timescale 1ns / 1ps
`default_nettype none

// Praktikum EL3011 Arsitektur Sistem Komputer
// Modul         : 2
// Tugas         : 3 (Tugas Pendahuluan)
// Tanggal       : 12 November 2026
// Kelompok      : 8
// Rombongan     : -
// Nama (NIM)    : Yozia Gedalya Marcho Ginting (13224001)
// Nama File     : alu_gate_rv32i.sv
// Deskripsi     : Implementasi ALU gate

module alu_gate_rv32i (
    input wire logic [31:0] in1,
    input wire logic [31:0] in2,
    input wire logic [1:0] gate_type,
    output logic [31:0] out
);

  always_comb begin
    case (gate_type)
      2'b00:   out = in1 ^ in2;
      2'b01:   out = in1 | in2;
      2'b10:   out = in1 & in2;
      default: out = 32'b0;
    endcase
  end

endmodule

`default_nettype wire
