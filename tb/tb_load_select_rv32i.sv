`timescale 1ns / 1ps
`default_nettype none

// Praktikum EL3011 Arsitektur Sistem Komputer
// Modul         : 2
// Tugas         : 6 (Tugas Pendahuluan)
// Tanggal       : 12 November 2026
// Kelompok      : 8
// Rombongan     : -
// Nama (NIM)    : Yozia Gedalya Marcho Ginting (13224001)
// Nama File     : tb_load_select_rv32i.sv
// Deskripsi     : Pengujian load select

module tb_load_select_rv32i;

  logic [ 2:0] cu_loadtype;
  logic [31:0] dmem_out;
  logic [31:0] load_out, expected;
  int checks = 0;

  load_select_rv32i dut (
      .cu_loadtype(cu_loadtype),
      .dmem_out(dmem_out),
      .load_out(load_out)
  );

  task automatic check_result(input string label);
    #1;
    case (cu_loadtype)
      3'b000:  expected = {{24{dmem_out[7]}}, dmem_out[7:0]};
      3'b001:  expected = {{16{dmem_out[15]}}, dmem_out[15:0]};
      3'b010:  expected = dmem_out;
      3'b011:  expected = {24'b0, dmem_out[7:0]};
      3'b100:  expected = {16'b0, dmem_out[15:0]};
      default: expected = 32'b0;
    endcase

    checks++;
    assert (load_out === expected)
    else
      $fatal(
          1,
          "%s failed: type=%b dmem_out=%h expected=%h got=%h",
          label,
          cu_loadtype,
          dmem_out,
          expected,
          load_out
      );
  endtask

  initial begin
    dmem_out = 32'h0000_007F;
    for (int t = 0; t < 8; t++) begin
      cu_loadtype = t[2:0];
      check_result("low byte positive boundary");
    end

    dmem_out = 32'h0000_0080;
    for (int t = 0; t < 8; t++) begin
      cu_loadtype = t[2:0];
      check_result("low byte negative boundary");
    end

    dmem_out = 32'h0000_7FFF;
    for (int t = 0; t < 8; t++) begin
      cu_loadtype = t[2:0];
      check_result("low halfword positive boundary");
    end

    dmem_out = 32'h0000_8000;
    for (int t = 0; t < 8; t++) begin
      cu_loadtype = t[2:0];
      check_result("low halfword negative boundary");
    end

    dmem_out = 32'hDEAD_BEEF;
    for (int t = 0; t < 8; t++) begin
      cu_loadtype = t[2:0];
      check_result("distinctive word pattern");
    end

    dmem_out = 32'hFFFF_FFFF;
    for (int t = 0; t < 8; t++) begin
      cu_loadtype = t[2:0];
      check_result("all ones");
    end

    $display("PASS: %0d load-selector checks completed.", checks);
    $finish;
  end

endmodule

`default_nettype wire
