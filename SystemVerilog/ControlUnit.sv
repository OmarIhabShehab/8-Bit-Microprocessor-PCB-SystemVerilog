`timescale 1ns/1ps

module ControlUnit (
    input  logic [3:0] opcode,
    input  logic [5:0] T,
    input  logic reset,

    output logic Cp,
    output logic MAR_sel,
    output logic WE,
    output logic Li,
    output logic LB,
    output logic LA,
    output logic Su,
    output logic Lo,
    output logic HALT,
    output logic Reset_ring
);

always_comb begin

    // ===== DEFAULT VALUES =====
    Cp = 0;
    MAR_sel = 0;
    WE = 0;
    Li = 0;
    LB = 0;
    LA = 0;
    Su = 0;
    Lo = 0;
    HALT = 0;
    Reset_ring = 0;

    // ===== RESET OVERRIDE =====
    if (reset) begin
        Cp = 0;
        MAR_sel = 0;
        WE = 0;
        Li = 0;
        LB = 0;
        LA = 0;
        Su = 0;
        Lo = 0;
        HALT = 0;
        Reset_ring = 0;
    end
    else begin

        // FETCH
        if (T[0]) begin
            MAR_sel = 0;
            Li = 1;
        end

        if (T[1]) begin
            Cp = 1;
        end

        case (opcode)

            // LDA
            4'b0001: begin
                if (T[2]) MAR_sel = 1;
                if (T[3]) LA = 1;
            end

// ADD
4'b0010: begin
    if (T[2]) MAR_sel = 1;
    if (T[3]) begin
        MAR_sel = 1;  // ???
        LB = 1;
    end
    if (T[4]) begin
        MAR_sel = 1;  // ???
        Su = 0;
        LA = 1;
    end
end
            // SUB
            4'b0011: begin
                if (T[2]) MAR_sel = 1;
                if (T[3]) LB = 1;
                if (T[4]) begin
                    Su = 1;
                    LA = 1;
                end
            end

            // STA
            4'b0100: begin
                if (T[2]) MAR_sel = 1;
                if (T[3]) WE = 1;
            end

            // OUT
            4'b0101: begin
                if (T[2]) Lo = 1;
            end

            // JMP
            4'b0110: begin
                if (T[2]) Cp = 1;
            end

            // HALT
            4'b1111: begin
                if (T[2]) begin
                    HALT = 1;
                    Reset_ring = 1;
                end
            end

        endcase
    end
end

endmodule