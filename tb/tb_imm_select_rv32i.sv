`timescale 1ns / 1ps
`default_nettype none

// Praktikum EL3011 Arsitektur Sistem Komputer
// Modul         : 2
// Tugas         : 3
// Tanggal       : 12 November 2026
// Kelompok      : 8
// Rombongan     : -
// Nama (NIM)    : Yozia Gedalya Marcho Ginting (13224001)
// Nama File     : tb_imm_select_rv32i.sv
// Deskripsi     : Pengujian immediate selector

module tb_imm_select_rv32i;

  logic [31:7] trimmed_instr;
  logic [ 2:0] cu_immtype;
  logic [31:0] imm, expected;
  int checks = 0;

  imm_select_rv32i dut (
      .trimmed_instr(trimmed_instr),
      .cu_immtype(cu_immtype),
      .imm(imm)
  );

  task automatic check_result(input string label);
    #1;
    case (cu_immtype)
      3'b000: expected = {{20{trimmed_instr[31]}}, trimmed_instr[31:20]};
      3'b001: expected = {{20{trimmed_instr[31]}}, trimmed_instr[31:25], trimmed_instr[11:7]};
      3'b010:
      expected = {
        {19{trimmed_instr[31]}},
        trimmed_instr[31],
        trimmed_instr[7],
        trimmed_instr[30:25],
        trimmed_instr[11:8],
        1'b0
      };
      3'b011: expected = {trimmed_instr[31:12], 12'b0};
      3'b100:
      expected = {
        {11{trimmed_instr[31]}},
        trimmed_instr[31],
        trimmed_instr[19:12],
        trimmed_instr[20],
        trimmed_instr[30:21],
        1'b0
      };
      default: expected = 32'b0;
    endcase

    checks++;
    assert (imm === expected)
    else
      $fatal(
          1,
          "%s failed: type=%b trimmed_instr=%h expected=%h got=%h",
          label,
          cu_immtype,
          trimmed_instr,
          expected,
          imm
      );
  endtask

  initial begin
    // Deterministic patterns expose misplaced or omitted instruction bits.
    trimmed_instr = 25'h0000000;
    for (int t = 0; t < 8; t++) begin
      cu_immtype = t[2:0];
      check_result("all-zero instruction fields");
    end

    trimmed_instr = 25'h1FFFFFF;
    for (int t = 0; t < 8; t++) begin
      cu_immtype = t[2:0];
      check_result("all-one instruction fields");
    end

    trimmed_instr = 25'h1555555;
    for (int t = 0; t < 8; t++) begin
      cu_immtype = t[2:0];
      check_result("alternating instruction fields");
    end

    trimmed_instr = 25'h0AAAAAA;
    for (int t = 0; t < 8; t++) begin
      cu_immtype = t[2:0];
      check_result("complementary alternating fields");
    end

    // Walk a one through all 25 input bits for each valid format.
    for (int bit_index = 0; bit_index < 25; bit_index++) begin
      trimmed_instr = 25'b1 << bit_index;
      for (int t = 0; t < 5; t++) begin
        cu_immtype = t[2:0];
        check_result("walking one");
      end
    end

    // Walk a zero through all 25 input bits.
    for (int bit_index = 0; bit_index < 25; bit_index++) begin
      trimmed_instr = {25{1'b1}};
      trimmed_instr[bit_index+7] = 1'b0;
      for (int t = 0; t < 5; t++) begin
        cu_immtype = t[2:0];
        check_result("walking zero");
      end
    end

    $display("PASS: %0d immediate-selector checks completed.", checks);
    $finish;
  end

endmodule

`default_nettype wire
