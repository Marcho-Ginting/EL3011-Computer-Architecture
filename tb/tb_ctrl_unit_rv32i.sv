`timescale 1ns / 1ps
`default_nettype none
// Praktikum EL3011 Arsitektur Sistem Komputer
// Modul         : 1
// Tugas         : 1
// Tanggal       : 28 Oktober 2026
// Kelompok      : -
// Rombongan     : -
// Nama (NIM)    : Yozia Gedalya Marcho Ginting (13224001)
// Nama File     : tb_ctrl_unit_rv32i.sv
// Deskripsi     : Pengujian Control Unit (CU) terhadap setiap instruksi

module tb_ctrl_unit_rv32i;

  logic [6:0] opcode;
  logic [2:0] funct3;
  logic [6:0] funct7;

  logic       cu_ALU1src;
  logic       cu_ALU2src;
  logic [2:0] cu_immtype;
  logic [1:0] cu_ALUtype;
  logic       cu_adtype;
  logic [1:0] cu_gatype;
  logic [1:0] cu_shiftype;
  logic       cu_slttype;
  logic [1:0] cu_rdtype;
  logic       cu_rdwrite;
  logic [2:0] cu_loadtype;
  logic       cu_store;
  logic [1:0] cu_storetype;
  logic       cu_branch;
  logic [2:0] cu_branchtype;
  logic       cu_jump;

  logic       failed;

  ctrl_unit_rv32i dut (
      .opcode       (opcode),
      .funct3       (funct3),
      .funct7       (funct7),
      .cu_ALU1src   (cu_ALU1src),
      .cu_ALU2src   (cu_ALU2src),
      .cu_immtype   (cu_immtype),
      .cu_ALUtype   (cu_ALUtype),
      .cu_adtype    (cu_adtype),
      .cu_gatype    (cu_gatype),
      .cu_shiftype  (cu_shiftype),
      .cu_slttype   (cu_slttype),
      .cu_rdtype    (cu_rdtype),
      .cu_rdwrite   (cu_rdwrite),
      .cu_loadtype  (cu_loadtype),
      .cu_store     (cu_store),
      .cu_storetype (cu_storetype),
      .cu_branch    (cu_branch),
      .cu_branchtype(cu_branchtype),
      .cu_jump      (cu_jump)
  );

  // Packs all 16 control outputs into one 27-bit expected value.
  function automatic logic [26:0] ctrl(
      input logic alu1src, input logic alu2src, input logic [2:0] immtype,
      input logic [1:0] alutype, input logic adtype, input logic [1:0] gatype,
      input logic [1:0] shiftype, input logic slttype, input logic [1:0] rdtype,
      input logic rdwrite, input logic [2:0] loadtype, input logic store,
      input logic [1:0] storetype, input logic branch, input logic [2:0] branchtype,
      input logic jump);
    ctrl = {
      alu1src,
      alu2src,
      immtype,
      alutype,
      adtype,
      gatype,
      shiftype,
      slttype,
      rdtype,
      rdwrite,
      loadtype,
      store,
      storetype,
      branch,
      branchtype,
      jump
    };
  endfunction

  localparam logic [26:0] C_DEFAULT = ctrl(
      0, 0, 3'b000, 2'b00, 0, 2'b00, 2'b00, 0, 2'b00, 0, 3'b000, 0, 2'b00, 0, 3'b000, 0
  );

  localparam logic [26:0] C_ADD = ctrl(
      0, 0, 3'b000, 2'b00, 0, 2'b00, 2'b00, 0, 2'b00, 1, 3'b000, 0, 2'b00, 0, 3'b000, 0
  );

  localparam logic [26:0] C_SUB = ctrl(
      0, 0, 3'b000, 2'b00, 1, 2'b00, 2'b00, 0, 2'b00, 1, 3'b000, 0, 2'b00, 0, 3'b000, 0
  );

  localparam logic [26:0] C_XOR = ctrl(
      0, 0, 3'b000, 2'b01, 0, 2'b00, 2'b00, 0, 2'b00, 1, 3'b000, 0, 2'b00, 0, 3'b000, 0
  );

  localparam logic [26:0] C_OR = ctrl(
      0, 0, 3'b000, 2'b01, 0, 2'b01, 2'b00, 0, 2'b00, 1, 3'b000, 0, 2'b00, 0, 3'b000, 0
  );

  localparam logic [26:0] C_AND = ctrl(
      0, 0, 3'b000, 2'b01, 0, 2'b10, 2'b00, 0, 2'b00, 1, 3'b000, 0, 2'b00, 0, 3'b000, 0
  );

  localparam logic [26:0] C_SLL = ctrl(
      0, 0, 3'b000, 2'b10, 0, 2'b00, 2'b00, 0, 2'b00, 1, 3'b000, 0, 2'b00, 0, 3'b000, 0
  );

  localparam logic [26:0] C_SRL = ctrl(
      0, 0, 3'b000, 2'b10, 0, 2'b00, 2'b01, 0, 2'b00, 1, 3'b000, 0, 2'b00, 0, 3'b000, 0
  );

  localparam logic [26:0] C_SRA = ctrl(
      0, 0, 3'b000, 2'b10, 0, 2'b00, 2'b10, 0, 2'b00, 1, 3'b000, 0, 2'b00, 0, 3'b000, 0
  );

  localparam logic [26:0] C_SLT = ctrl(
      0, 0, 3'b000, 2'b11, 0, 2'b00, 2'b00, 0, 2'b00, 1, 3'b000, 0, 2'b00, 0, 3'b000, 0
  );

  localparam logic [26:0] C_SLTU = ctrl(
      0, 0, 3'b000, 2'b11, 0, 2'b00, 2'b00, 1, 2'b00, 1, 3'b000, 0, 2'b00, 0, 3'b000, 0
  );

  localparam logic [26:0] C_ADDI = ctrl(
      0, 1, 3'b000, 2'b00, 0, 2'b00, 2'b00, 0, 2'b00, 1, 3'b000, 0, 2'b00, 0, 3'b000, 0
  );

  localparam logic [26:0] C_XORI = ctrl(
      0, 1, 3'b000, 2'b01, 0, 2'b00, 2'b00, 0, 2'b00, 1, 3'b000, 0, 2'b00, 0, 3'b000, 0
  );

  localparam logic [26:0] C_ORI = ctrl(
      0, 1, 3'b000, 2'b01, 0, 2'b01, 2'b00, 0, 2'b00, 1, 3'b000, 0, 2'b00, 0, 3'b000, 0
  );

  localparam logic [26:0] C_ANDI = ctrl(
      0, 1, 3'b000, 2'b01, 0, 2'b10, 2'b00, 0, 2'b00, 1, 3'b000, 0, 2'b00, 0, 3'b000, 0
  );

  localparam logic [26:0] C_SLLI = ctrl(
      0, 1, 3'b000, 2'b10, 0, 2'b00, 2'b00, 0, 2'b00, 1, 3'b000, 0, 2'b00, 0, 3'b000, 0
  );

  localparam logic [26:0] C_SRLI = ctrl(
      0, 1, 3'b000, 2'b10, 0, 2'b00, 2'b01, 0, 2'b00, 1, 3'b000, 0, 2'b00, 0, 3'b000, 0
  );

  localparam logic [26:0] C_SRAI = ctrl(
      0, 1, 3'b000, 2'b10, 0, 2'b00, 2'b10, 0, 2'b00, 1, 3'b000, 0, 2'b00, 0, 3'b000, 0
  );

  localparam logic [26:0] C_SLTI = ctrl(
      0, 1, 3'b000, 2'b11, 0, 2'b00, 2'b00, 0, 2'b00, 1, 3'b000, 0, 2'b00, 0, 3'b000, 0
  );

  localparam logic [26:0] C_SLTIU = ctrl(
      0, 1, 3'b000, 2'b11, 0, 2'b00, 2'b00, 1, 2'b00, 1, 3'b000, 0, 2'b00, 0, 3'b000, 0
  );

  localparam logic [26:0] C_LB = ctrl(
      0, 1, 3'b000, 2'b00, 0, 2'b00, 2'b00, 0, 2'b01, 1, 3'b000, 0, 2'b00, 0, 3'b000, 0
  );

  localparam logic [26:0] C_LH = ctrl(
      0, 1, 3'b000, 2'b00, 0, 2'b00, 2'b00, 0, 2'b01, 1, 3'b001, 0, 2'b00, 0, 3'b000, 0
  );

  localparam logic [26:0] C_LW = ctrl(
      0, 1, 3'b000, 2'b00, 0, 2'b00, 2'b00, 0, 2'b01, 1, 3'b010, 0, 2'b00, 0, 3'b000, 0
  );

  localparam logic [26:0] C_LBU = ctrl(
      0, 1, 3'b000, 2'b00, 0, 2'b00, 2'b00, 0, 2'b01, 1, 3'b011, 0, 2'b00, 0, 3'b000, 0
  );

  localparam logic [26:0] C_LHU = ctrl(
      0, 1, 3'b000, 2'b00, 0, 2'b00, 2'b00, 0, 2'b01, 1, 3'b100, 0, 2'b00, 0, 3'b000, 0
  );

  localparam logic [26:0] C_SB = ctrl(
      0, 1, 3'b001, 2'b00, 0, 2'b00, 2'b00, 0, 2'b00, 0, 3'b000, 1, 2'b00, 0, 3'b000, 0
  );

  localparam logic [26:0] C_SH = ctrl(
      0, 1, 3'b001, 2'b00, 0, 2'b00, 2'b00, 0, 2'b00, 0, 3'b000, 1, 2'b01, 0, 3'b000, 0
  );

  localparam logic [26:0] C_SW = ctrl(
      0, 1, 3'b001, 2'b00, 0, 2'b00, 2'b00, 0, 2'b00, 0, 3'b000, 1, 2'b10, 0, 3'b000, 0
  );

  localparam logic [26:0] C_BEQ = ctrl(
      1, 1, 3'b010, 2'b00, 0, 2'b00, 2'b00, 0, 2'b00, 0, 3'b000, 0, 2'b00, 1, 3'b000, 0
  );

  localparam logic [26:0] C_BNE = ctrl(
      1, 1, 3'b010, 2'b00, 0, 2'b00, 2'b00, 0, 2'b00, 0, 3'b000, 0, 2'b00, 1, 3'b001, 0
  );

  localparam logic [26:0] C_BLT = ctrl(
      1, 1, 3'b010, 2'b00, 0, 2'b00, 2'b00, 0, 2'b00, 0, 3'b000, 0, 2'b00, 1, 3'b010, 0
  );

  localparam logic [26:0] C_BGE = ctrl(
      1, 1, 3'b010, 2'b00, 0, 2'b00, 2'b00, 0, 2'b00, 0, 3'b000, 0, 2'b00, 1, 3'b011, 0
  );

  localparam logic [26:0] C_BLTU = ctrl(
      1, 1, 3'b010, 2'b00, 0, 2'b00, 2'b00, 0, 2'b00, 0, 3'b000, 0, 2'b00, 1, 3'b100, 0
  );

  localparam logic [26:0] C_BGEU = ctrl(
      1, 1, 3'b010, 2'b00, 0, 2'b00, 2'b00, 0, 2'b00, 0, 3'b000, 0, 2'b00, 1, 3'b101, 0
  );

  localparam logic [26:0] C_AUIPC = ctrl(
      1, 1, 3'b011, 2'b00, 0, 2'b00, 2'b00, 0, 2'b00, 1, 3'b000, 0, 2'b00, 0, 3'b000, 0
  );

  localparam logic [26:0] C_LUI = ctrl(
      0, 1, 3'b011, 2'b00, 0, 2'b00, 2'b00, 0, 2'b11, 1, 3'b000, 0, 2'b00, 0, 3'b000, 0
  );

  localparam logic [26:0] C_JAL = ctrl(
      1, 1, 3'b100, 2'b00, 0, 2'b00, 2'b00, 0, 2'b10, 1, 3'b000, 0, 2'b00, 0, 3'b000, 1
  );

  localparam logic [26:0] C_JALR = ctrl(
      0, 1, 3'b000, 2'b00, 0, 2'b00, 2'b00, 0, 2'b10, 1, 3'b000, 0, 2'b00, 0, 3'b000, 1
  );

  task automatic check(input string name, input logic [6:0] opcode_in, input logic [2:0] funct3_in,
                       input logic [6:0] funct7_in, input logic [26:0] expected);
    logic [26:0] actual;
    begin
      opcode = opcode_in;
      funct3 = funct3_in;
      funct7 = funct7_in;
      #10;

      actual = {
        cu_ALU1src,
        cu_ALU2src,
        cu_immtype,
        cu_ALUtype,
        cu_adtype,
        cu_gatype,
        cu_shiftype,
        cu_slttype,
        cu_rdtype,
        cu_rdwrite,
        cu_loadtype,
        cu_store,
        cu_storetype,
        cu_branch,
        cu_branchtype,
        cu_jump
      };

      if (actual !== expected) begin
        $error("FAIL: %s | actual = %h | expected = %h", name, actual, expected);
        failed = 1'b1;
      end else begin
        $display("PASS: %s", name);
      end
    end
  endtask

  initial begin
    failed = 1'b0;

    // R-type
    check("ADD", 7'h33, 3'h0, 7'h00, C_ADD);
    check("SUB", 7'h33, 3'h0, 7'h20, C_SUB);
    check("SLL", 7'h33, 3'h1, 7'h00, C_SLL);
    check("SLT", 7'h33, 3'h2, 7'h00, C_SLT);
    check("SLTU", 7'h33, 3'h3, 7'h00, C_SLTU);
    check("XOR", 7'h33, 3'h4, 7'h00, C_XOR);
    check("SRL", 7'h33, 3'h5, 7'h00, C_SRL);
    check("SRA", 7'h33, 3'h5, 7'h20, C_SRA);
    check("OR", 7'h33, 3'h6, 7'h00, C_OR);
    check("AND", 7'h33, 3'h7, 7'h00, C_AND);

    // I-type ALU
    check("ADDI", 7'h13, 3'h0, 7'h00, C_ADDI);
    check("SLLI", 7'h13, 3'h1, 7'h00, C_SLLI);
    check("SLTI", 7'h13, 3'h2, 7'h00, C_SLTI);
    check("SLTIU", 7'h13, 3'h3, 7'h00, C_SLTIU);
    check("XORI", 7'h13, 3'h4, 7'h00, C_XORI);
    check("SRLI", 7'h13, 3'h5, 7'h00, C_SRLI);
    check("SRAI", 7'h13, 3'h5, 7'h20, C_SRAI);
    check("ORI", 7'h13, 3'h6, 7'h00, C_ORI);
    check("ANDI", 7'h13, 3'h7, 7'h00, C_ANDI);

    // Loads
    check("LB", 7'h03, 3'h0, 7'h00, C_LB);
    check("LH", 7'h03, 3'h1, 7'h00, C_LH);
    check("LW", 7'h03, 3'h2, 7'h00, C_LW);
    check("LBU", 7'h03, 3'h4, 7'h00, C_LBU);
    check("LHU", 7'h03, 3'h5, 7'h00, C_LHU);

    // Stores
    check("SB", 7'h23, 3'h0, 7'h00, C_SB);
    check("SH", 7'h23, 3'h1, 7'h00, C_SH);
    check("SW", 7'h23, 3'h2, 7'h00, C_SW);

    // Branches
    check("BEQ", 7'h63, 3'h0, 7'h00, C_BEQ);
    check("BNE", 7'h63, 3'h1, 7'h00, C_BNE);
    check("BLT", 7'h63, 3'h4, 7'h00, C_BLT);
    check("BGE", 7'h63, 3'h5, 7'h00, C_BGE);
    check("BLTU", 7'h63, 3'h6, 7'h00, C_BLTU);
    check("BGEU", 7'h63, 3'h7, 7'h00, C_BGEU);

    // Upper-immediate and jump instructions
    check("AUIPC", 7'h17, 3'h0, 7'h00, C_AUIPC);
    check("LUI", 7'h37, 3'h0, 7'h00, C_LUI);
    check("JAL", 7'h6F, 3'h0, 7'h00, C_JAL);
    check("JALR", 7'h67, 3'h0, 7'h00, C_JALR);

    // Unsupported opcode
    check("INVALID OPCODE", 7'h00, 3'h0, 7'h00, C_DEFAULT);

    if (failed) $fatal(1, "Control-unit testbench FAILED.");
    else $display("PASS: all 37 supported RV32I instruction decodes passed.");

    $finish;
  end

endmodule

`default_nettype wire
