`timescale 1ns / 1ps
`default_nettype none

// Praktikum EL3011 Arsitektur Sistem Komputer
// Modul         : 2
// Tugas         : 1
// Tanggal       : 12 November 2026
// Kelompok      : 8
// Rombongan     : -
// Nama (NIM)    : Yozia Gedalya Marcho Ginting (13224001)
// Nama File     : brancher_rv32i.sv
// Deskripsi     : Implementasi brancher

module brancher_rv32i (
    input  wire logic        [31:0] PC_new,         // Normal next PC
    input  wire logic        [31:0] PC_branch,      // Branch target address
    input  wire logic signed [31:0] in1,            // Value from rs1
    input  wire logic signed [31:0] in2,            // Value from rs2
    input  wire logic               cu_branch,      // Enables conditional branch
    input  wire logic        [ 2:0] cu_branchtype,  // Selects branch condition
    output logic             [31:0] PC_in
);

  always_comb begin
    PC_in = PC_new;

    if (cu_branch) begin
      case (cu_branchtype)
        3'b000: PC_in = (in1 == in2) ? PC_branch : PC_new;  // BEQ
        3'b001: PC_in = (in1 != in2) ? PC_branch : PC_new;  // BNE
        3'b010: PC_in = (in1 < in2) ? PC_branch : PC_new;  // BLT
        3'b011: PC_in = (in1 >= in2) ? PC_branch : PC_new;  // BGE

        3'b100: PC_in = ($unsigned(in1) < $unsigned(in2)) ? PC_branch : PC_new;  // BLTU
        3'b101: PC_in = ($unsigned(in1) >= $unsigned(in2)) ? PC_branch : PC_new;  // BGEU

        default: PC_in = PC_new;
      endcase
    end
  end

endmodule

`default_nettype wire
