`timescale 1ns / 1ps
`default_nettype none
// Praktikum EL3011 Arsitektur Sistem Komputer
// Modul         : 1
// Tugas         : 1
// Tanggal       : 28 Oktober 2026
// Kelompok      : -
// Rombongan     : -
// Nama (NIM)    : Yozia Gedalya Marcho Ginting (13224001)
// Nama File     : instr_rom_rv32i.sv
// Deskripsi     : Implementasi instruction memory

module instr_rom_rv32i (
    input  wire logic [31:0] ADDR,
    input  wire logic        clock,
    input  wire logic        reset,
    output logic      [31:0] INSTR
);

  logic [31:0] mem[0:31];
  logic [4:0] waddr;
  integer i;

  assign waddr = ADDR[6:2];

  initial begin
    // Default value: RV32I NOP = addi x0, x0, 0
    for (i = 0; i < 32; i = i + 1) mem[i] = 32'h0000_0013;

    mem[0] = 32'h0010_0293;  // addi t0, zero, 1
    mem[1] = 32'h0000_0313;  // addi t1, zero, 0
    mem[2] = 32'h00A0_0393;  // addi t2, zero, 10
    mem[3] = 32'h0070_4463;  // blt  zero, t2, loop
    mem[4] = 32'h0012_8293;  // addi t0, t0, 1
    mem[5] = 32'h0053_0333;  // add  t1, t1, t0
    mem[6] = 32'hFE72_CCE3;  // blt  t0, t2, increment
    mem[7] = 32'h0000_0513;  // addi a0, zero, 0
  end

  always @(posedge clock or posedge reset) begin
    if (reset) INSTR <= 32'h0000_0013;
    else INSTR <= mem[waddr];
  end

endmodule

`default_nettype wire
