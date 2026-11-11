`timescale 1ns / 1ps
`default_nettype none

// Praktikum EL3011 Arsitektur Sistem Komputer
// Modul         : 2
// Tugas         : 5 (Tugas Pendahuluan)
// Tanggal       : 12 November 2026
// Kelompok      : 8
// Rombongan     : -
// Nama (NIM)    : Yozia Gedalya Marcho Ginting (13224001)
// Nama File     : tb_alu_slt_rv32i.sv
// Deskripsi     : Pengujian ALU set less than

module tb_alu_slt_rv32i;

  logic [31:0] in1, in2;
  logic sltype;
  logic [31:0] out, expected;
  int checks = 0;

  alu_slt_rv32i dut (
      .in1(in1),
      .in2(in2),
      .sltype(sltype),
      .out(out)
  );

  task automatic check_result(input string label);
    #1;
    if (sltype == 1'b0) expected = ($signed(in1) < $signed(in2)) ? 32'd1 : 32'd0;
    else expected = (in1 < in2) ? 32'd1 : 32'd0;

    checks++;
    assert (out === expected)
    else
      $fatal(
          1,
          "%s failed: mode=%s in1=%h in2=%h expected=%h got=%h",
          label,
          sltype ? "unsigned" : "signed",
          in1,
          in2,
          expected,
          out
      );
  endtask

  logic [31:0] edge_values[0:7];

  initial begin
    edge_values[0] = 32'h0000_0000;
    edge_values[1] = 32'h0000_0001;
    edge_values[2] = 32'h0000_0002;
    edge_values[3] = 32'h7FFF_FFFF;
    edge_values[4] = 32'h8000_0000;
    edge_values[5] = 32'h8000_0001;
    edge_values[6] = 32'hFFFF_FFFE;
    edge_values[7] = 32'hFFFF_FFFF;

    for (int i = 0; i < 8; i++) begin
      for (int j = 0; j < 8; j++) begin
        in1 = edge_values[i];
        in2 = edge_values[j];

        sltype = 1'b0;
        check_result("signed edge pair");

        sltype = 1'b1;
        check_result("unsigned edge pair");
      end
    end

    in1 = 32'd10;
    in2 = 32'd20;
    sltype = 1'b0;
    check_result("10 less than 20 signed");
    sltype = 1'b1;
    check_result("10 less than 20 unsigned");

    in1 = 32'd20;
    in2 = 32'd10;
    sltype = 1'b0;
    check_result("20 less than 10 signed");
    sltype = 1'b1;
    check_result("20 less than 10 unsigned");

    $display("PASS: %0d SLT checks completed.", checks);
    $finish;
  end

endmodule

`default_nettype wire
