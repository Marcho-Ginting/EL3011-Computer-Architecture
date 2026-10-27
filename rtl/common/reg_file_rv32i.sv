`timescale 1ns / 1ps
`default_nettype none

module reg_file_rv32i (
    input  wire logic        clock,
    input  wire logic        cu_rdwrite,
    input  wire logic [ 4:0] rs1_addr,
    input  wire logic [ 4:0] rs2_addr,
    input  wire logic [ 4:0] rd_addr,
    input  wire logic [31:0] rd_in,
    output logic      [31:0] rs1,
    output logic      [31:0] rs2
);

  logic [31:0] rf[0:31];
  integer i;

  initial begin
    for (i = 0; i < 32; i = i + 1) rf[i] = 32'h0000_0000;
  end

  // Write on the rising edge. x0 is never writable.
  always @(posedge clock) begin
    if (cu_rdwrite && (rd_addr != 5'd0)) rf[rd_addr] <= rd_in;

    rf[0] <= 32'h0000_0000;
  end

  always @(negedge clock) begin
    rs1 <= (rs1_addr == 5'd0) ? 32'h0000_0000 : rf[rs1_addr];
    rs2 <= (rs2_addr == 5'd0) ? 32'h0000_0000 : rf[rs2_addr];
  end

endmodule

`default_nettype wire
