`timescale 1ns / 1ps
`default_nettype none

// Praktikum EL3011 Arsitektur Sistem Komputer
// Modul         : 2
// Tugas         : 1
// Tanggal       : 12 November 2026
// Kelompok      : 8
// Rombongan     : -
// Nama (NIM)    : Yozia Gedalya Marcho Ginting (13224001)
// Nama File     : tb_brancher_rv32i.sv
// Deskripsi     : Pengujian brancher

module tb_brancher_rv32i;

  logic [31:0] PC_new, PC_branch;
  logic signed [31:0] in1, in2;
  logic cu_branch;
  logic [2:0] cu_branchtype;
  logic [31:0] PC_in;
  logic [31:0] expected;
  int checks = 0;

  logic [31:0] values[0:9];

  brancher_rv32i dut (
      .PC_new(PC_new),
      .PC_branch(PC_branch),
      .in1(in1),
      .in2(in2),
      .cu_branch(cu_branch),
      .cu_branchtype(cu_branchtype),
      .PC_in(PC_in)
  );

  task automatic check_result(input string label);
    #1;

    expected = PC_new;
    if (cu_branch) begin
      case (cu_branchtype)
        3'b000:  if (in1 == in2) expected = PC_branch;
        3'b001:  if (in1 != in2) expected = PC_branch;
        3'b010:  if (in1 < in2) expected = PC_branch;
        3'b011:  if (in1 >= in2) expected = PC_branch;
        3'b100:  if ($unsigned(in1) < $unsigned(in2)) expected = PC_branch;
        3'b101:  if ($unsigned(in1) >= $unsigned(in2)) expected = PC_branch;
        default: expected = PC_new;
      endcase
    end

    checks++;
    assert (PC_in === expected)
    else
      $fatal(
          1,
          "%s failed: branch=%b type=%b in1=%h in2=%h expected PC=%h got=%h",
          label,
          cu_branch,
          cu_branchtype,
          in1,
          in2,
          expected,
          PC_in
      );
  endtask

  initial begin
    PC_new    = 32'h0000_0100;
    PC_branch = 32'h0000_0200;

    values[0] = 32'h0000_0000;
    values[1] = 32'h0000_0001;
    values[2] = 32'h0000_0002;
    values[3] = 32'h7FFF_FFFF;
    values[4] = 32'h8000_0000;
    values[5] = 32'h8000_0001;
    values[6] = 32'hFFFF_FFFE;
    values[7] = 32'hFFFF_FFFF;
    values[8] = 32'h5555_AAAA;
    values[9] = 32'hAAAA_5555;

    for (int i = 0; i < 10; i++) begin
      for (int j = 0; j < 10; j++) begin
        in1 = values[i];
        in2 = values[j];
        cu_branch = 1'b1;

        for (int branch_type = 0; branch_type < 6; branch_type++) begin
          cu_branchtype = branch_type[2:0];
          check_result("boundary pair");
        end
      end
    end

    in1 = 32'hFFFF_FFFF;
    in2 = 32'h0000_0001;
    cu_branch = 1'b0;
    for (int branch_type = 0; branch_type < 8; branch_type++) begin
      cu_branchtype = branch_type[2:0];
      check_result("branch disabled");
    end

    cu_branch = 1'b1;
    cu_branchtype = 3'b110;
    check_result("invalid branch type 110");
    cu_branchtype = 3'b111;
    check_result("invalid branch type 111");

    $display("PASS: %0d brancher checks completed.", checks);
    $finish;
  end

endmodule

`default_nettype wire
