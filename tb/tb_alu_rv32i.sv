`timescale 1ns / 1ps
`default_nettype none

// Praktikum EL3011 Arsitektur Sistem Komputer
// Modul         : 2
// Tugas         : 2
// Tanggal       : 12 November 2026
// Kelompok      : 8
// Rombongan     : -
// Nama (NIM)    : Yozia Gedalya Marcho Ginting (13224001)
// Nama File     : tb_alu_rv32i.sv
// Deskripsi     : Pengujian ALU

module tb_alu_rv32i;

  logic [31:0] in1, in2;
  logic [1:0] cu_ALUtype;
  logic cu_adtype;
  logic [1:0] cu_gatype, cu_shiftype;
  logic cu_sltype;
  logic [31:0] out, expected;
  logic signed [31:0] signed_in1;
  int checks = 0;

  logic [31:0] values[0:9];

  alu_rv32i dut (
      .in1(in1),
      .in2(in2),
      .cu_ALUtype(cu_ALUtype),
      .cu_adtype(cu_adtype),
      .cu_gatype(cu_gatype),
      .cu_shiftype(cu_shiftype),
      .cu_sltype(cu_sltype),
      .out(out)
  );

  task automatic check_result;
    #1;
    signed_in1 = in1;

    case (cu_ALUtype)
      2'b00: begin  // Adder
        if (cu_adtype == 1'b0) expected = in1 + in2;
        else expected = in1 - in2;
      end

      2'b01: begin  // Gate
        case (cu_gatype)
          2'b00:   expected = in1 ^ in2;
          2'b01:   expected = in1 | in2;
          2'b10:   expected = in1 & in2;
          default: expected = 32'b0;
        endcase
      end

      2'b10: begin  // Shifter
        case (cu_shiftype)
          2'b00:   expected = in1 << in2[4:0];  // sll
          2'b01:   expected = in1 >> in2[4:0];  // srl
          2'b10:   expected = signed_in1 >>> in2[4:0];  //sra
          default: expected = 32'b0;
        endcase
      end

      2'b11: begin  // Set less than
        if (cu_sltype == 1'b0) expected = ($signed(in1) < $signed(in2)) ? 32'd1 : 32'd0;
        else expected = (in1 < in2) ? 32'd1 : 32'd0;
      end
    endcase

    checks++;
    assert (out === expected)
    else
      $fatal(
          1,
          "ALU mismatch: ALUtype=%b ad=%b gate=%b shift=%b sl=%b in1=%h in2=%h expected=%h got=%h",
          cu_ALUtype,
          cu_adtype,
          cu_gatype,
          cu_shiftype,
          cu_sltype,
          in1,
          in2,
          expected,
          out
      );
  endtask

  initial begin
    values[0] = 32'h0000_000C;
    values[1] = 32'h0000_0001;
    values[2] = 32'h0000_0002;
    values[3] = 32'h0000_001F;  // shift amount 31
    values[4] = 32'h7FFF_FFFF;  // largest signed positive
    values[5] = 32'h8000_0000;  // most negative signed
    values[6] = 32'h8000_0001;
    values[7] = 32'hFFFF_FFFE;
    values[8] = 32'hFFFF_FFFF;  // -1 signed, max unsigned
    values[9] = 32'hAAAA_5555;

    // Test all operand pairs and every combination of control encodings.
    for (int i = 0; i < 10; i++) begin
      for (int j = 0; j < 10; j++) begin
        in1 = values[i];
        in2 = values[j];

        for (int alu_type = 0; alu_type < 4; alu_type++) begin
          cu_ALUtype = alu_type[1:0];

          for (int ad_type = 0; ad_type < 2; ad_type++) begin
            cu_adtype = ad_type[0];

            for (int gate_type = 0; gate_type < 4; gate_type++) begin
              cu_gatype = gate_type[1:0];

              for (int shift_type = 0; shift_type < 4; shift_type++) begin
                cu_shiftype = shift_type[1:0];

                for (int sl_type = 0; sl_type < 2; sl_type++) begin
                  cu_sltype = sl_type[0];
                  check_result();
                end
              end
            end
          end
        end
      end
    end

    $display("PASS: %0d ALU checks completed.", checks);
    $finish;
  end

endmodule

`default_nettype wire
