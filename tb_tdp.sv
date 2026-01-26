`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date: 25.01.2026 12:47:02
// Design Name: 
// Module Name: tb_tdp
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


module tb_tdp_fixed;

  logic clk;
  initial clk = 0;
  always #5 clk = ~clk;

  logic       ena;
  logic [0:0] wea;
  logic [3:0] addra;
  logic [3:0] dina;
  logic [3:0] douta;

  logic       enb;
  logic [3:0] addrb;
  logic [3:0] doutb;

  tdp dut (
    .clk   (clk),
    .ena   (ena),
    .wea   (wea),
    .addra (addra),
    .dina  (dina),
    .douta (douta),
    .enb   (enb),
    .addrb (addrb),
    .doutb (doutb)
  );

  task automatic wrA(input logic [3:0] a, input logic [3:0] d);
    @(posedge clk);
    ena=1; wea=1; addra=a; dina=d;
    @(posedge clk);
    ena=0; wea=0; addra='0; dina='0;
  endtask

  // HOLD enb for 2 cycles, sample after that
  task automatic rdB_strong(input logic [3:0] a, output logic [3:0] q);
    @(posedge clk);
    enb=1; addrb=a;
    @(posedge clk);
    enb=1; addrb=a;
    @(posedge clk);
    q = doutb;
    enb=0; addrb='0;
  endtask

  task automatic rdA_strong(input logic [3:0] a, output logic [3:0] q);
    @(posedge clk);
    ena=1; wea=0; addra=a;
    @(posedge clk);
    ena=1; wea=0; addra=a;
    @(posedge clk);
    q = douta;
    ena=0; addra='0;
  endtask

  task automatic rdAB_parallel_strong(
    input  logic [3:0] aA,
    input  logic [3:0] aB,
    output logic [3:0] qA,
    output logic [3:0] qB
  );
    @(posedge clk);
    ena=1; wea=0; addra=aA;
    enb=1;       addrb=aB;

    @(posedge clk);
    ena=1; wea=0; addra=aA;
    enb=1;       addrb=aB;

    @(posedge clk);
    qA = douta;
    qB = doutb;

    ena=0; enb=0; addra='0; addrb='0;
  endtask

  logic [3:0] qa, qb;

  initial begin
    ena=0; wea=0; addra=0; dina=0;
    enb=0; addrb=0;

    repeat(2) @(posedge clk);

    // write data
    wrA(4'h1, 4'h3);
    wrA(4'h2, 4'h6);
    wrA(4'h4, 4'h9);
    wrA(4'h8, 4'hC);

    // single reads (sanity)
    rdB_strong(4'h1, qb); if (qb !== 4'h3) $fatal;
    rdB_strong(4'h2, qb); if (qb !== 4'h6) $fatal;

    // parallel reads (A+B)
    rdAB_parallel_strong(4'h4, 4'h8, qa, qb);
    if (qa !== 4'h9) $fatal;
    if (qb !== 4'hC) $fatal;
    #50
    $finish;
  end

endmodule


