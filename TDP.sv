`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date: 25.01.2026 12:05:47
// Design Name: 
// Module Name: TDP
// Project Name: 
// Target Devices: 
// Tool Versions: 
// Description: 
// 
// Dependencies: 
// 
// Revision:
// Revision 0.01 - File Created
// Additional Comments:
// 
//////////////////////////////////////////////////////////////////////////////////


module tdp (
  input  logic        clk,

  // Port A (RW)
  input  logic        ena,
  input  logic [0:0]  wea,
  input  logic [3:0]  addra,
  input  logic [3:0]  dina,
  output logic [3:0]  douta,

  // Port B (R only)
  input  logic        enb,
  input  logic [3:0]  addrb,
  output logic [3:0]  doutb
);

  blk_mem_gen_0 u_bram (
    .clka  (clk),
    .ena   (ena),
    .wea   (wea),
    .addra (addra),
    .dina  (dina),
    .douta (douta),

    .clkb  (clk),
    .enb   (enb),
    .web   (1'b0),   // OK: 1-bit connects to [0:0]
    .addrb (addrb),
    .dinb  (4'b0),
    .doutb (doutb)
  );

endmodule
