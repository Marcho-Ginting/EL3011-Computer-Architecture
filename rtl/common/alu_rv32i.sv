`timescale 1ns / 1ps
`default_nettype none

// Praktikum EL3011 Arsitektur Sistem Komputer
// Modul         : 2
// Tugas         : 2
// Tanggal       : 12 November 2026
// Kelompok      : 8
// Rombongan     : -
// Nama (NIM)    : Yozia Gedalya Marcho Ginting (13224001)
// Nama File     : alu_rv32i.sv
// Deskripsi     : Implementasi ALU

module alu_rv32i (
    input wire logic [31:0] in1,
    input wire logic [31:0] in2,

    input wire logic [1:0] cu_ALUtype,   // 00 adder, 01 gate, 10 shifter, 11 SLT
    input wire logic       cu_adtype,    // 0 add, 1 subtract
    input wire logic [1:0] cu_gatype,    // 00 XOR, 01 OR, 10 AND
    input wire logic [1:0] cu_shiftype,  // 00 SLL, 01 SRL, 10 SRA
    input wire logic       cu_sltype,    // 0 signed SLT, 1 unsigned SLTU

    output logic [31:0] out
);

  logic [31:0] adder_out;
  logic [31:0] gate_out;
  logic [31:0] shifter_out;
  logic [31:0] slt_out;

  alu_adder_rv32i subblock_adder (
      .in1(in1),
      .in2(in2),
      .sub(cu_adtype),
      .out(adder_out)
  );

  alu_gate_rv32i subblock_gate (
      .in1      (in1),
      .in2      (in2),
      .gate_type(cu_gatype),
      .out      (gate_out)
  );

  alu_shifter_rv32i subblock_shifter (
      .in      (in1),
      .shamt   (in2),
      .shiftype(cu_shiftype),
      .out     (shifter_out)
  );

  alu_slt_rv32i subblock_slt (
      .in1   (in1),
      .in2   (in2),
      .sltype(cu_sltype),
      .out   (slt_out)
  );

  always_comb begin
    case (cu_ALUtype)
      2'b00:   out = adder_out;
      2'b01:   out = gate_out;
      2'b10:   out = shifter_out;
      2'b11:   out = slt_out;
      default: out = 32'b0;
    endcase
  end

endmodule

`default_nettype wire
