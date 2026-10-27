`timescale 1ns / 1ps
`default_nettype none
// Praktikum EL3011 Arsitektur Sistem Komputer
// Modul         : 1
// Tugas         : 7
// Tanggal       : 28 Oktober 2026
// Kelompok      : -
// Rombongan     : -
// Nama (NIM)    : Yozia Gedalya Marcho Ginting (13224001)
// Nama File     : tb_reg_file.sv
// Deskripsi     : Pengujian program counter 32-bit

module tb_reg_file_rv32i;

  logic        clock;
  logic        cu_rdwrite;
  logic [ 4:0] rs1_addr;
  logic [ 4:0] rs2_addr;
  logic [ 4:0] rd_addr;
  logic [31:0] rd_in;
  logic [31:0] rs1;
  logic [31:0] rs2;
  logic        failed;

  reg_file_rv32i dut (
      .clock     (clock),
      .cu_rdwrite(cu_rdwrite),
      .rs1_addr  (rs1_addr),
      .rs2_addr  (rs2_addr),
      .rd_addr   (rd_addr),
      .rd_in     (rd_in),
      .rs1       (rs1),
      .rs2       (rs2)
  );

  // Ten-nanosecond period
  initial begin
    clock = 1'b0;
    forever #5 clock = ~clock;
  end

  task automatic write_register(input logic [4:0] address, input logic [31:0] data);
    begin
      rd_addr    = address;
      rd_in      = data;
      cu_rdwrite = 1'b1;
      @(posedge clock);
      #1;
    end
  endtask

  task automatic check_reads(input logic [4:0] address_1, input logic [31:0] expected_1,
                             input logic [4:0] address_2, input logic [31:0] expected_2);
    begin
      rs1_addr = address_1;
      rs2_addr = address_2;

      @(negedge clock);
      #1;

      if (rs1 !== expected_1) begin
        $error("FAIL: rs1 address x%0d, actual = %h, expected = %h", address_1, rs1, expected_1);
        failed = 1'b1;
      end

      if (rs2 !== expected_2) begin
        $error("FAIL: rs2 address x%0d, actual = %h, expected = %h", address_2, rs2, expected_2);
        failed = 1'b1;
      end
    end
  endtask

  initial begin
    cu_rdwrite = 1'b0;
    rs1_addr   = 5'd0;
    rs2_addr   = 5'd0;
    rd_addr    = 5'd0;
    rd_in      = 32'h0000_0000;
    failed     = 1'b0;

    write_register(5'd1, 32'h0000_0011);
    write_register(5'd2, 32'h0000_0022);
    write_register(5'd3, 32'h0000_0033);
    write_register(5'd4, 32'h0000_0044);

    write_register(5'd0, 32'hDEAD_BEEF);
    cu_rdwrite = 1'b0;

    check_reads(5'd0, 32'h0000_0000, 5'd1, 32'h0000_0011);
    check_reads(5'd2, 32'h0000_0022, 5'd3, 32'h0000_0033);
    check_reads(5'd4, 32'h0000_0044, 5'd5, 32'h0000_0000);
    check_reads(5'd6, 32'h0000_0000, 5'd7, 32'h0000_0000);
    check_reads(5'd8, 32'h0000_0000, 5'd9, 32'h0000_0000);

    if (failed) $fatal(1, "Register-file testbench FAILED.");
    else $display("PASS: all register-file checks succeeded.");

    $finish;
  end

endmodule

`default_nettype wire
