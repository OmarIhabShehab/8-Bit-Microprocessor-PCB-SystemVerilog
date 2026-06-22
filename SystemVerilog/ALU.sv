// File: ALU.sv
// Description: 8-bit ALU with Add/Subtract and future expansion

`timescale 1ns/1ps

module ALU #(parameter WIDTH = 8) (
    input  logic [WIDTH-1:0] A,
    input  logic [WIDTH-1:0] B,
    input  logic             Su,     // 0=ADD, 1=SUBTRACT
    output logic [WIDTH-1:0] ALU_Out
);

    always_comb begin
        case (Su)
            1'b0: ALU_Out = A + B;   // Addition
            1'b1: ALU_Out = A - B;   // Subtraction
            default: ALU_Out = 8'b0;
        endcase
    end

endmodule