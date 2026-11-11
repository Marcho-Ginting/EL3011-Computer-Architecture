`timescale 1ns / 1ps
`default_nettype none

// Praktikum EL3011 Arsitektur Sistem Komputer
// Modul         : 2
// Tugas         : 2 (Tugas Pendahuluan)
// Tanggal       : 12 November 2026
// Kelompok      : 8
// Rombongan     : -
// Nama (NIM)    : Yozia Gedalya Marcho Ginting (13224001)
// Nama File     : tb_alu_adder_rv32i.sv
// Deskripsi     : Pengujian ALU

module tb_alu_adder_rv32i;

  logic [31:0] in1, in2;
  logic        sub;
  logic [31:0] out;
  logic [31:0] expected;
  int          checks = 0;

  alu_adder_rv32i dut (
      .in1(in1),
      .in2(in2),
      .sub(sub),
      .out(out)
  );

  task automatic check_result(input string label);
    #1;
    expected = sub ? (in1 - in2) : (in1 + in2);
    checks++;
    assert (out === expected)
    else
      $fatal(
          1,
          "%s failed: sub=%b in1=%h in2=%h expected=%h got=%h",
          label,
          sub,
          in1,
          in2,
          expected,
          out
      );
  endtask

  initial begin
    // Carry, borrow, zero, sign-bit, and wraparound cases.
    in1 = 0;
    in2 = 0;
    sub = 0;
    check_result("zero + zero");
    in1 = 32'hFFFF_FFFF;
    in2 = 1;
    sub = 0;
    check_result("addition wraparound");
    in1 = 32'h7FFF_FFFF;
    in2 = 1;
    sub = 0;
    check_result("positive overflow bit pattern");
    in1 = 32'h8000_0000;
    in2 = 32'h8000_0000;
    sub = 0;
    check_result("sign-bit carry");
    in1 = 0;
    in2 = 1;
    sub = 1;
    check_result("zero minus one");
    in1 = 5;
    in2 = 5;
    sub = 1;
    check_result("equal subtraction");
    in1 = 32'h8000_0000;
    in2 = 1;
    sub = 1;
    check_result("subtraction boundary");
    in1 = 32'hFFFF_FFFF;
    in2 = 32'hFFFF_FFFF;
    sub = 1;
    check_result("same maximum bit pattern");

    // For each bit, test a one-hot operand pair in both modes,
    // then a zero-versus-one pair to exercise carry/borrow propagation.
    for (int bit_index = 0; bit_index < 32; bit_index++) begin
      in1 = 32'b1 << bit_index;
      in2 = 32'b1 << bit_index;

      sub = 0;
      check_result("matching walking ones add");
      sub = 1;
      check_result("matching walking ones subtract");

      in1 = 32'b1 << bit_index;
      in2 = 1;
      sub = 0;
      check_result("walking one plus one");
      sub = 1;
      check_result("walking one minus one");

      in1 = 0;
      in2 = 32'b1 << bit_index;
      sub = 0;
      check_result("zero plus walking one");
      sub = 1;
      check_result("zero minus walking one");

      in1 = ~(32'b1 << bit_index);
      in2 = 1;
      sub = 0;
      check_result("carry propagation");
      sub = 1;
      check_result("borrow propagation");
    end

    $display("PASS: %0d adder checks completed.", checks);
    $finish;
  end

endmodule

`default_nettype wire
