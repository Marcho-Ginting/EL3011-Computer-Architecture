`timescale 1ns / 1ps
`default_nettype none

// Praktikum EL3011 Arsitektur Sistem Komputer
// Modul         : 2
// Tugas         : 1 (Tugas Pendahuluan)
// Tanggal       : 12 November 2026
// Kelompok      : 8
// Rombongan     : -
// Nama (NIM)    : Yozia Gedalya Marcho Ginting (13224001)
// Nama File     : mux4_to_1_rv32i.sv
// Deskripsi     : Pengujian multiplexer 4 to 1

module tb_mux4_to_1_rv32i;

  logic [31:0] W, X, Y, Z;
  logic [1:0] sel;
  logic [31:0] D;

  int checks = 0;

  mux4_to_1_rv32i dut (
      .W  (W),
      .X  (X),
      .Y  (Y),
      .Z  (Z),
      .sel(sel),
      .D  (D)
  );

  task automatic check_output(input logic [31:0] expected, input string label);
    #1;
    checks++;
    assert (D === expected)
    else $fatal(1, "%s failed: sel=%b expected=%h got=%h", label, sel, expected, D);
  endtask

  initial begin
    W = 32'h0123_4567;
    X = 32'h89AB_CDEF;
    Y = 32'hDEAD_BEEF;
    Z = 32'hA5A5_5A5A;

    for (int s = 0; s < 4; s++) begin
      sel = s[1:0];
      case (s)
        0: check_output(W, "select W");
        1: check_output(X, "select X");
        2: check_output(Y, "select Y");
        3: check_output(Z, "select Z");
      endcase
    end

    for (int input_index = 0; input_index < 4; input_index++) begin
      for (int bit_index = 0; bit_index < 32; bit_index++) begin
        W = 0;
        X = 0;
        Y = 0;
        Z = 0;
        case (input_index)
          0: W[bit_index] = 1'b1;
          1: X[bit_index] = 1'b1;
          2: Y[bit_index] = 1'b1;
          3: Z[bit_index] = 1'b1;
        endcase
        sel = input_index[1:0];
        check_output(32'b1 << bit_index, "walking one");

        W = '1;
        X = '1;
        Y = '1;
        Z = '1;
        case (input_index)
          0: W[bit_index] = 1'b0;
          1: X[bit_index] = 1'b0;
          2: Y[bit_index] = 1'b0;
          3: Z[bit_index] = 1'b0;
        endcase
        check_output(~(32'b1 << bit_index), "walking zero");
      end
    end

    // Changing an unselected input must not affect the output.
    W   = 32'h1357_9BDF;
    X   = 32'h2468_ACE0;
    Y   = 32'h0F0F_F0F0;
    Z   = 32'hF0F0_0F0F;
    sel = 2'b01;
    check_output(X, "baseline before unselected change");

    W = ~W;
    Y = ~Y;
    Z = ~Z;
    check_output(X, "unselected inputs changed");

    $display("PASS: %0d checks completed.", checks);
    $finish;
  end

endmodule

`default_nettype wire
