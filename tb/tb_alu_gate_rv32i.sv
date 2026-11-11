`timescale 1ns / 1ps
`default_nettype none

// Praktikum EL3011 Arsitektur Sistem Komputer
// Modul         : 2
// Tugas         : 3 (Tugas Pendahuluan)
// Tanggal       : 12 November 2026
// Kelompok      : 8
// Rombongan     : -
// Nama (NIM)    : Yozia Gedalya Marcho Ginting (13224001)
// Nama File     : tb_alu_gate_rv32i.sv
// Deskripsi     : Pengujian ALU gate

module tb_alu_gate_rv32i;

  logic [31:0] in1, in2;
  logic [1:0] gate_type;
  logic [31:0] out, expected;
  int checks = 0;

  alu_gate_rv32i dut (
      .in1(in1),
      .in2(in2),
      .gate_type(gate_type),
      .out(out)
  );

  task automatic check_result(input string label);
    #1;
    case (gate_type)
      2'b00:   expected = in1 ^ in2;
      2'b01:   expected = in1 | in2;
      2'b10:   expected = in1 & in2;
      default: expected = 32'b0;
    endcase

    checks++;
    assert (out === expected)
    else
      $fatal(
          1,
          "%s failed: type=%b in1=%h in2=%h expected=%h got=%h",
          label,
          gate_type,
          in1,
          in2,
          expected,
          out
      );
  endtask

  initial begin
    in1 = 32'hAAAA_5555;
    in2 = 32'h0F0F_F0F0;
    for (int op = 0; op < 4; op++) begin
      gate_type = op[1:0];
      check_result("distinctive operands");
    end

    in1 = 32'hFFFF_FFFF;
    in2 = 32'hFFFF_FFFF;
    gate_type = 2'b00;
    check_result("all ones XOR all ones");
    gate_type = 2'b01;
    check_result("all ones OR all ones");
    gate_type = 2'b10;
    check_result("all ones AND all ones");
    gate_type = 2'b11;
    check_result("reserved selector");

    in1 = 32'hAAAA_AAAA;
    in2 = 32'h5555_5555;
    gate_type = 2'b00;
    check_result("disjoint XOR");
    gate_type = 2'b01;
    check_result("disjoint OR");
    gate_type = 2'b10;
    check_result("disjoint AND");

    for (int bit_index = 0; bit_index < 32; bit_index++) begin
      for (int op = 0; op < 3; op++) begin
        gate_type = op[1:0];

        in1 = 32'b1 << bit_index;
        in2 = 0;
        check_result("walking one in in1");

        in1 = 0;
        in2 = 32'b1 << bit_index;
        check_result("walking one in in2");

        in1 = ~(32'b1 << bit_index);
        in2 = 32'hFFFF_FFFF;
        check_result("walking zero in in1");

        in1 = 32'hFFFF_FFFF;
        in2 = ~(32'b1 << bit_index);
        check_result("walking zero in in2");
      end
    end

    $display("PASS: %0d gate checks completed.", checks);
    $finish;
  end

endmodule

`default_nettype wire
