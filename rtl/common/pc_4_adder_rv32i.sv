`timescale 1ns / 1ps
`default_nettype none
// Praktikum EL3011 Arsitektur Sistem Komputer
// Modul         : 1
// Tugas         : 2
// Tanggal       : 28 Oktober 2026
// Kelompok      : -
// Rombongan     : -
// Nama (NIM)    : Yozia Gedalya Marcho Ginting (13224001)
// Nama File     : pc_4_adder_rv32i.sv
// Deskripsi     : Implementasi program counter 32-bit

module pc_4_adder_rv32i (
    input wire logic [31:0] PC_old,
    output logic [31:0] PC_4_add
);

  assign PC_4_add = PC_old + 32'd4;

endmodule

`default_nettype wire
