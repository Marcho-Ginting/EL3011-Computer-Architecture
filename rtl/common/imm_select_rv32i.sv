`timescale 1ns / 1ps
`default_nettype none

// Praktikum EL3011 Arsitektur Sistem Komputer
// Modul         : 2
// Tugas         : 3
// Tanggal       : 12 November 2026
// Kelompok      : 8
// Rombongan     : -
// Nama (NIM)    : Yozia Gedalya Marcho Ginting (13224001)
// Nama File     : imm_select_rv32i.sv
// Deskripsi     : Implementasi immediate selector

module imm_select_rv32i (
    input wire logic [31:7] trimmed_instr,
    input wire logic [2:0] cu_immtype,  // 000 I, 001 S, 010 B, 011 U, 100 J
    output logic [31:0] imm
);

  always_comb begin
    case (cu_immtype)
      3'b000:  // I-type: sign-extend inst[31:20]
      imm = {{20{trimmed_instr[31]}}, trimmed_instr[31:20]};

      3'b001:  // S-type: sign bit and inst[30:25], inst[11:7]
      imm = {{20{trimmed_instr[31]}}, trimmed_instr[31:25], trimmed_instr[11:7]};

      3'b010:  // B-type: reconstruct branch offset; bit 0 is implicit zero
      imm = {
        {19{trimmed_instr[31]}},
        trimmed_instr[31],
        trimmed_instr[7],
        trimmed_instr[30:25],
        trimmed_instr[11:8],
        1'b0
      };

      3'b011:  // U-type: upper immediate, low 12 bits are zero
      imm = {trimmed_instr[31:12], 12'b0};

      3'b100:  // J-type: reconstruct jump offset; bit 0 is implicit zero
      imm = {
        {11{trimmed_instr[31]}},
        trimmed_instr[31],
        trimmed_instr[19:12],
        trimmed_instr[20],
        trimmed_instr[30:21],
        1'b0
      };

      default: imm = 32'b0;
    endcase
  end

endmodule

`default_nettype wire
