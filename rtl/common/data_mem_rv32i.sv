`timescale 1ns / 1ps
`default_nettype none
// Praktikum EL3011 Arsitektur Sistem Komputer
// Modul         : 1
// Tugas         : 1
// Tanggal       : 28 Oktober 2026
// Kelompok      : -
// Rombongan     : -
// Nama (NIM)    : Yozia Gedalya Marcho Ginting (13224001)
// Nama File     : data_mem_rv32i.sv
// Deskripsi     : Implementasi memory data

module data_mem_rv32i (
    input  wire logic        clock,
    input  wire logic        cu_store,
    input  wire logic [ 1:0] cu_storetype,
    input  wire logic [31:0] dmem_addr,
    input  wire logic [31:0] rs2,
    output wire logic [31:0] dmem_out
);

  logic [31:0] mem[0:255];
  logic [7:0] waddr;
  integer i;

  // The address from the CPU is a byte address.
  // Four adjacent byte addresses refer to one 32-bit memory word.
  assign waddr = dmem_addr[9:2];

  // Initialisation
  initial begin
    for (i = 0; i < 256; i = i + 1) mem[i] = 32'h0000_0000;
  end

  // Asynchronous full-word read.
  assign dmem_out = mem[waddr];

  // Store occurs on the falling edge.
  always @(negedge clock) begin
    if (cu_store) begin
      case (cu_storetype)

        2'b00: begin  // SB: store least-significant byte of rs2
          case (dmem_addr[1:0])
            2'b00: mem[waddr][7:0] <= rs2[7:0];
            2'b01: mem[waddr][15:8] <= rs2[7:0];
            2'b10: mem[waddr][23:16] <= rs2[7:0];
            2'b11: mem[waddr][31:24] <= rs2[7:0];
          endcase
        end

        2'b01: begin  // SH: store least-significant halfword of rs2
          if (dmem_addr[1] == 1'b0) mem[waddr][15:0] <= rs2[15:0];
          else mem[waddr][31:16] <= rs2[15:0];
        end

        2'b10: begin  // SW: store complete 32-bit word
          mem[waddr] <= rs2;
        end

        default: begin
        end
      endcase
    end
  end

endmodule

`default_nettype wire
