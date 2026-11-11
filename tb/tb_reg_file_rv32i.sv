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
  ADDR  = 32'h0000_0000;
  reset = 1'b0;

  // Allow Xilinx global startup reset and the timing netlist to settle.
  #120;

  // Create an explicit reset rising edge after startup.
  reset = 1'b1;

  // Wait two clock edges before checking the delayed implementation.
  @(posedge clock);
  @(posedge clock);
  #1;

  assert (INSTR === 32'h0000_0013)
    else $fatal(1, "FAIL: reset did not produce RV32I NOP");

  reset = 1'b0;

  check_instruction(32'h0000_0000, 32'h0010_0293);
  check_instruction(32'h0000_0004, 32'h0000_0313);
  check_instruction(32'h0000_0008, 32'h00A0_0393);
  check_instruction(32'h0000_0014, 32'h0053_0333);
  check_instruction(32'h0000_001C, 32'h0000_0513);
  check_instruction(32'h0000_0020, 32'h0000_0013);

  $display("PASS: all instruction-ROM checks succeeded.");
  $finish;
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

  task automatic check_instruction (
    input logic [31:0] address,
    input logic [31:0] expected
);
  begin
    ADDR = address;

    // First rising edge captures the selected ROM word.
    @(posedge clock);

    // Wait one complete cycle. The output from the first capture
    // has enough time to propagate through the implemented design.
    @(posedge clock);
    #1;

    assert (INSTR === expected)
      else $fatal(
          1,
          "FAIL: ADDR = %h, INSTR = %h, expected = %h",
          address, INSTR, expected
      );
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
