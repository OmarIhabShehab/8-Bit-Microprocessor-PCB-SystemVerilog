// File: Memory.sv
// Synchronous Write, Asynchronous Read Memory

`timescale 1ns/1ps

module Memory #(
    parameter ADDR_WIDTH = 8,
    parameter DATA_WIDTH = 8
)(
    input  logic                   clk,
    input  logic                   WE,
    input  logic [ADDR_WIDTH-1:0]  addr,
    input  logic [DATA_WIDTH-1:0]  wd,
    output logic [DATA_WIDTH-1:0]  rd
);

    logic [DATA_WIDTH-1:0] RAM [0:(2**ADDR_WIDTH)-1];

    // Synchronous Write
    always_ff @(posedge clk) begin
        if (WE)
            RAM[addr] <= wd;
    end

    // Asynchronous Read
    assign rd = RAM[addr];

    // Initial Program & Data Loading
    initial begin

        // Instruction Set:
        // 0X -> LDA (Load AC from Memory)
        // 2X -> ADD (Add Memory to AC)
        // 3X -> STA (Store AC to Memory)
        // 4X -> OUT (Output AC)
        // FX -> HALT

        // Program: AC = 5 + 3 = 8
        RAM[0] = 8'h09;  // LDA 9  (Load value from address 9 into AC)
        RAM[1] = 8'h2A;  // ADD A  (Add value from address 0A to AC) - Opcode 2 = ADD
        RAM[2] = 8'h3B;  // STA B  (Store AC to address 0B)
        RAM[3] = 8'h40;  // OUT    (Output AC to display)
        RAM[4] = 8'hF0;  // HALT   (Stop execution)

        // Data Section
        RAM[8'h09] = 8'd5;  // Operand 1 at address 09
        RAM[8'h0A] = 8'd3;  // Operand 2 at address 0A
        RAM[8'h0B] = 8'd0;  // Result location at address 0B

    end

endmodule