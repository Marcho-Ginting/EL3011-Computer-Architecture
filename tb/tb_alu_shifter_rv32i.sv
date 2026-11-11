`timescale 1ns / 1ps
`default_nettype none

// Praktikum EL3011 Arsitektur Sistem Komputer
// Modul         : 2
// Tugas         : 4 (Tugas Pendahuluan)
// Tanggal       : 12 November 2026
// Kelompok      : 8
// Rombongan     : -
// Nama (NIM)    : Yozia Gedalya Marcho Ginting (13224001)
// Nama File     : alu_shifter_rv32i.sv
// Deskripsi     : Pengujian ALU shifter

module tb_alu_shifter_rv32i;

  logic [31:0] in, shamt;
  logic [1:0] shiftype;
  logic [31:0] out, expected;
  logic signed [31:0] signed_in;
  int checks = 0;

  alu_shifter_rv32i dut (
      .in(in),
      .shamt(shamt),
      .shiftype(shiftype),
      .out(out)
  );

  task automatic check_result(input string label);
    #1;
    signed_in = in;
    case (shiftype)
      2'b00:   expected = in << shamt[4:0];
      2'b01:   expected = in >> shamt[4:0];
      2'b10:   expected = signed_in >>> shamt[4:0];
      default: expected = 32'b0;
    endcase

    checks++;
    assert (out === expected)
    else
      $fatal(
          1,
          "%s failed: type=%b in=%h shamt=%0d expected=%h got=%h",
          label,
          shiftype,
          in,
          shamt[4:0],
          expected,
          out
      );
  endtask

  initial begin
    // Sweep every legal RV32I shift amount for representative patterns.
    for (int amount = 0; amount < 32; amount++) begin
      shamt = amount;

      in = 32'h0000_0000;
      for (int op = 0; op < 4; op++) begin
        shiftype = op[1:0];
        check_result("zero input");
      end

      in = 32'hFFFF_FFFF;
      for (int op = 0; op < 4; op++) begin
        shiftype = op[1:0];
        check_result("all ones input");
      end

      in = 32'h8000_0001;
      for (int op = 0; op < 3; op++) begin
        shiftype = op[1:0];
        check_result("sign and edge bits");
      end

      in = 32'hAAAA_5555;
      for (int op = 0; op < 3; op++) begin
        shiftype = op[1:0];
        check_result("alternating pattern");
      end

      in = 32'h7FFF_FFFF;
      for (int op = 0; op < 3; op++) begin
        shiftype = op[1:0];
        check_result("positive signed pattern");
      end
    end

    // High shift-amount bits must be ignored; only shamt[4:0] matters.
    in = 32'h8123_4567;
    shamt = 32'hFFFF_FFE3;  // low five bits are 3
    for (int op = 0; op < 3; op++) begin
      shiftype = op[1:0];
      check_result("high shift bits ignored");
    end

    $display("PASS: %0d shifter checks completed.", checks);
    $finish;
  end

endmodule

`default_nettype wire
