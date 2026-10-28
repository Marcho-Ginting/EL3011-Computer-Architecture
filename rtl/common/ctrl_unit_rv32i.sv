`timescale 1ns / 1ps
`default_nettype none
// Praktikum EL3011 Arsitektur Sistem Komputer
// Modul         : 1
// Tugas         : 1
// Tanggal       : 28 Oktober 2026
// Kelompok      : -
// Rombongan     : -
// Nama (NIM)    : Yozia Gedalya Marcho Ginting (13224001)
// Nama File     : ctrl_unit_rv32i.sv
// Deskripsi     : Implementasi Control Unit (CU)

module ctrl_unit_rv32i (
    input wire logic [6:0] opcode,
    input wire logic [2:0] funct3,
    input wire logic [6:0] funct7,

    output logic       cu_ALU1src,
    output logic       cu_ALU2src,
    output logic [2:0] cu_immtype,
    output logic [1:0] cu_ALUtype,
    output logic       cu_adtype,
    output logic [1:0] cu_gatype,
    output logic [1:0] cu_shiftype,
    output logic       cu_slttype,
    output logic [1:0] cu_rdtype,
    output logic       cu_rdwrite,
    output logic [2:0] cu_loadtype,
    output logic       cu_store,
    output logic [1:0] cu_storetype,
    output logic       cu_branch,
    output logic [2:0] cu_branchtype,
    output logic       cu_jump
);

  always_comb begin
    // Safe defaults
    cu_ALU1src    = 1'b0;
    cu_ALU2src    = 1'b0;
    cu_immtype    = 3'b000;
    cu_ALUtype    = 2'b00;
    cu_adtype     = 1'b0;
    cu_gatype     = 2'b00;
    cu_shiftype   = 2'b00;
    cu_slttype    = 1'b0;
    cu_rdtype     = 2'b00;
    cu_rdwrite    = 1'b0;
    cu_loadtype   = 3'b000;
    cu_store      = 1'b0;
    cu_storetype  = 2'b00;
    cu_branch     = 1'b0;
    cu_branchtype = 3'b000;
    cu_jump       = 1'b0;

    case (opcode)

      // R-type: add, sub, xor, or, and, shifts, slt, sltu
      7'h33: begin
        cu_rdwrite = 1'b1;

        case (funct3)
          3'h0: begin
            if (funct7 == 7'h20) cu_adtype = 1'b1;  // sub
          end

          3'h1: begin  // sll
            cu_ALUtype  = 2'b10;
            cu_shiftype = 2'b00;
          end

          3'h2: begin  // slt
            cu_ALUtype = 2'b11;
            cu_slttype = 1'b0;
          end

          3'h3: begin  // sltu
            cu_ALUtype = 2'b11;
            cu_slttype = 1'b1;
          end

          3'h4: begin  // xor
            cu_ALUtype = 2'b01;
            cu_gatype  = 2'b00;
          end

          3'h5: begin  // srl / sra
            cu_ALUtype = 2'b10;
            if (funct7 == 7'h20) cu_shiftype = 2'b10;  // sra
            else cu_shiftype = 2'b01;  // srl
          end

          3'h6: begin  // or
            cu_ALUtype = 2'b01;
            cu_gatype  = 2'b01;
          end

          3'h7: begin  // and
            cu_ALUtype = 2'b01;
            cu_gatype  = 2'b10;
          end
        endcase
      end

      // I-type ALU: addi, xori, ori, andi, shifts, slti, sltiu
      7'h13: begin
        cu_ALU2src = 1'b1;
        cu_rdwrite = 1'b1;

        case (funct3)
          3'h0: begin
          end  // addi: default adder

          3'h1: begin  // slli
            cu_ALUtype  = 2'b10;
            cu_shiftype = 2'b00;
          end

          3'h2: begin  // slti
            cu_ALUtype = 2'b11;
            cu_slttype = 1'b0;
          end

          3'h3: begin  // sltiu
            cu_ALUtype = 2'b11;
            cu_slttype = 1'b1;
          end

          3'h4: begin  // xori
            cu_ALUtype = 2'b01;
            cu_gatype  = 2'b00;
          end

          3'h5: begin  // srli / srai
            cu_ALUtype = 2'b10;
            if (funct7 == 7'h20) cu_shiftype = 2'b10;  // srai
            else cu_shiftype = 2'b01;  // srli
          end

          3'h6: begin  // ori
            cu_ALUtype = 2'b01;
            cu_gatype  = 2'b01;
          end

          3'h7: begin  // andi
            cu_ALUtype = 2'b01;
            cu_gatype  = 2'b10;
          end
        endcase
      end

      // Loads: lb, lh, lw, lbu, lhu
      7'h03: begin
        cu_ALU2src = 1'b1;
        cu_rdtype  = 2'b01;
        cu_rdwrite = 1'b1;

        case (funct3)
          3'h0: cu_loadtype = 3'b000;  // lb
          3'h1: cu_loadtype = 3'b001;  // lh
          3'h2: cu_loadtype = 3'b010;  // lw
          3'h4: cu_loadtype = 3'b011;  // lbu
          3'h5: cu_loadtype = 3'b100;  // lhu
        endcase
      end

      // Stores: sb, sh, sw
      7'h23: begin
        cu_ALU2src = 1'b1;
        cu_immtype = 3'b001;
        cu_store   = 1'b1;

        case (funct3)
          3'h0: cu_storetype = 2'b00;  // sb
          3'h1: cu_storetype = 2'b01;  // sh
          3'h2: cu_storetype = 2'b10;  // sw
        endcase
      end

      // Conditional branches
      7'h63: begin
        cu_ALU1src = 1'b1;
        cu_ALU2src = 1'b1;
        cu_immtype = 3'b010;
        cu_branch  = 1'b1;

        case (funct3)
          3'h0: cu_branchtype = 3'b000;  // beq
          3'h1: cu_branchtype = 3'b001;  // bne
          3'h4: cu_branchtype = 3'b010;  // blt
          3'h5: cu_branchtype = 3'b011;  // bge
          3'h6: cu_branchtype = 3'b100;  // bltu
          3'h7: cu_branchtype = 3'b101;  // bgeu
        endcase
      end

      // Add upper immediate to PC
      7'h17: begin  // auipc
        cu_ALU1src = 1'b1;
        cu_ALU2src = 1'b1;
        cu_immtype = 3'b011;
        cu_rdwrite = 1'b1;
      end

      // Load upper immediate
      7'h37: begin  // lui
        cu_ALU2src = 1'b1;
        cu_immtype = 3'b011;
        cu_rdtype  = 2'b11;
        cu_rdwrite = 1'b1;
      end

      // Jump and link
      7'h6F: begin  // jal
        cu_ALU1src = 1'b1;
        cu_ALU2src = 1'b1;
        cu_immtype = 3'b100;
        cu_rdtype  = 2'b10;
        cu_rdwrite = 1'b1;
        cu_jump    = 1'b1;
      end

      // Jump and link register
      7'h67: begin  // jalr
        cu_ALU2src = 1'b1;
        cu_rdtype  = 2'b10;
        cu_rdwrite = 1'b1;
        cu_jump    = 1'b1;
      end

      default: begin
      end
    endcase
  end

endmodule

`default_nettype wire
