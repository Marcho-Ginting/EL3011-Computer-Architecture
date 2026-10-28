`timescale 1ns / 1ps
`default_nettype none
// Praktikum EL3011 Arsitektur Sistem Komputer
// Modul         : 1
// Tugas         : 1
// Tanggal       : 28 Oktober 2026
// Kelompok      : -
// Rombongan     : -
// Nama (NIM)    : Yozia Gedalya Marcho Ginting (13224001)
// Nama File     : tb_data_mem_rv32i.sv
// Deskripsi     : Pengujian data memory

module tb_data_mem_rv32i;

  logic        clock;
  logic        cu_store;
  logic [ 1:0] cu_storetype;
  logic [31:0] dmem_addr;
  logic [31:0] rs2;
  logic [31:0] dmem_out;
  logic        failed;

  data_mem_rv32i dut (
      .clock       (clock),
      .cu_store    (cu_store),
      .cu_storetype(cu_storetype),
      .dmem_addr   (dmem_addr),
      .rs2         (rs2),
      .dmem_out    (dmem_out)
  );

  // Ten-nanosecond period
  initial begin
    clock = 1'b0;
    forever #5 clock = ~clock;
  end

  task automatic store(input logic [1:0] storetype, input logic [31:0] address,
                       input logic [31:0] data);
    begin
      cu_storetype = storetype;
      dmem_addr    = address;
      rs2          = data;
      cu_store     = 1'b1;

      @(negedge clock);
      #1;
      cu_store = 1'b0;
    end
  endtask

  task automatic check_word(input logic [31:0] address, input logic [31:0] expected);
    begin
      dmem_addr = address;
      #1;  // No clock edge: proves that the read is asynchronous.

      if (dmem_out !== expected) begin
        $error("FAIL: address = %h, actual = %h, expected = %h", address, dmem_out, expected);
        failed = 1'b1;
      end else begin
        $display("PASS: address = %h, word = %h", address, dmem_out);
      end
    end
  endtask

  initial begin
    cu_store     = 1'b0;
    cu_storetype = 2'b00;
    dmem_addr    = 32'h0000_0000;
    rs2          = 32'h0000_0000;
    failed       = 1'b0;

    // Memory is initialized to zero.
    check_word(32'h0000_0000, 32'h0000_0000);

    // SW: write an entire word at byte address 0.
    store(2'b10, 32'h0000_0000, 32'hAABB_CCDD);
    check_word(32'h0000_0000, 32'hAABB_CCDD);

    // SB: test all four byte lanes, preserving all other bytes.
    store(2'b00, 32'h0000_0000, 32'h0000_0011);
    check_word(32'h0000_0000, 32'hAABB_CC11);

    store(2'b00, 32'h0000_0001, 32'h0000_0022);
    check_word(32'h0000_0000, 32'hAABB_2211);

    store(2'b00, 32'h0000_0002, 32'h0000_0033);
    check_word(32'h0000_0000, 32'hAA33_2211);

    store(2'b00, 32'h0000_0003, 32'h0000_0044);
    check_word(32'h0000_0000, 32'h4433_2211);

    // SH: lower halfword, then upper halfword.
    store(2'b01, 32'h0000_0000, 32'h0000_5566);
    check_word(32'h0000_0000, 32'h4433_5566);

    store(2'b01, 32'h0000_0002, 32'h0000_7788);
    check_word(32'h0000_0000, 32'h7788_5566);

    // cu_store = 0 means that no data may be written.
    cu_store     = 1'b0;
    cu_storetype = 2'b10;
    dmem_addr    = 32'h0000_0004;
    rs2          = 32'hDEAD_BEEF;

    @(negedge clock);
    #1;
    check_word(32'h0000_0004, 32'h0000_0000);

    // Changing only the address immediately selects another memory word.
    check_word(32'h0000_0000, 32'h7788_5566);

    if (failed) $fatal(1, "Data-memory testbench FAILED.");
    else $display("PASS: all data-memory tests succeeded.");

    $finish;
  end

endmodule

`default_nettype wire
