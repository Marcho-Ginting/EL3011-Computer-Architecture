`timescale 1ns / 1ps
`default_nettype none

// Praktikum EL3011 Arsitektur Sistem Komputer
// Modul         : 2
// Tugas         : 6 (Tugas Pendahuluan)
// Tanggal       : 12 November 2026
// Kelompok      : 8
// Rombongan     : -
// Nama (NIM)    : Yozia Gedalya Marcho Ginting (13224001)
// Nama File     : load_select_rv32i.sv
// Deskripsi     : Implementasi load select

module load_select_rv32i (
    input wire logic [2:0] cu_loadtype,
    input wire logic [31:0] dmem_out,
    output logic [31:0] load_out
);

  always_comb begin
    case (cu_loadtype)
      3'b000:  // LB: sign-extend low byte
      load_out = {{24{dmem_out[7]}}, dmem_out[7:0]};

      3'b001:  // LH: sign-extend low halfword
      load_out = {{16{dmem_out[15]}}, dmem_out[15:0]};

      3'b010:  // LW: use all 32 bits
      load_out = dmem_out;

      3'b011:  // LBU: zero-extend low byte
      load_out = {24'b0, dmem_out[7:0]};

      3'b100:  // LHU: zero-extend low halfword
      load_out = {16'b0, dmem_out[15:0]};

      default: load_out = 32'b0;
    endcase
  end

endmodule

`default_nettype wire
