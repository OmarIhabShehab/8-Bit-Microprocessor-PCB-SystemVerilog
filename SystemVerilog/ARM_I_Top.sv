`timescale 1ns/1ps

module ARM_I_Top (
    input  logic clk,
    input  logic reset,
    output logic [7:0] out_display,
    // Debug outputs
    output logic [7:0] dbg_pc,
    output logic [7:0] dbg_ir,
    output logic [7:0] dbg_ac,
    output logic [7:0] dbg_b,
    output logic [7:0] dbg_alu,
    output logic [5:0] dbg_T,
    output logic       dbg_halt,
    output logic [7:0] dbg_mem_out,
    output logic       dbg_lb,
    output logic       dbg_la,
    output logic       dbg_li,
    output logic       dbg_we,
    output logic [7:0] dbg_addr
);

    // ================= INTERNAL SIGNALS =================
    logic [7:0] pc;
    logic [7:0] pc_next;
    logic [7:0] ir_out;
    logic [7:0] ram_out;
    logic [7:0] reg_a;
    logic [7:0] reg_b;
    logic [7:0] alu_res;
    logic [5:0] T;
    logic [3:0] current_opcode;

    // Control signals
    logic cp, mar_sel, we, li, lb, la, su, lo, halt, reset_ring;

    // ================= ADDRESS MUX =================
    logic [7:0] current_addr;
    assign current_addr = (mar_sel) ? {4'b0000, ir_out[3:0]} : pc;
    
    // ================= PC NEXT VALUE =================
    assign pc_next = pc + 8'd1;

    // ================= DEBUG ASSIGNMENTS =================
    assign dbg_pc = pc;
    assign dbg_ir = ir_out;
    assign dbg_ac = reg_a;
    assign dbg_b = reg_b;
    assign dbg_alu = alu_res;
    assign dbg_T = T;
    assign dbg_halt = halt;
    assign dbg_mem_out = ram_out;
    assign dbg_lb = lb;
    assign dbg_la = la;
    assign dbg_li = li;
    assign dbg_we = we;
    assign dbg_addr = current_addr;

    // ================= MEMORY =================
    Memory #(8,8) mem (
        .clk(clk),
        .WE(we),
        .addr(current_addr),
        .wd(reg_a),
        .rd(ram_out)
    );

    // ================= CONTROL UNIT =================
    ControlUnit cu (
        .opcode(ir_out[7:4]),
        .T(T),
        .reset(reset),
        .Cp(cp),
        .MAR_sel(mar_sel),
        .WE(we),
        .Li(li),
        .LB(lb),
        .LA(la),
        .Su(su),
        .Lo(lo),
        .HALT(halt),
        .Reset_ring(reset_ring)
    );

    // ================= ALU =================
    ALU #(8) alu (
        .A(reg_a),
        .B(reg_b),
        .Su(su),
        .ALU_Out(alu_res)
    );

    // ================= RING COUNTER =================
    RingCounter rc (
        .clk(clk),
        .reset(reset || reset_ring),
        .T(T)
    );

    // ================= PC REGISTER =================
    Register #(.WIDTH(8)) PC_REG (
        .clk(clk),
        .reset(reset),
        .load(cp && !halt),
        .data_in(pc_next),
        .data_out(pc)
    );

    // ================= IR REGISTER =================
    Register #(.WIDTH(8)) IR_REG (
        .clk(clk),
        .reset(reset),
        .load(li),
        .data_in(ram_out),
        .data_out(ir_out)
    );

    // ================= CURRENT OPCODE REGISTER =================
    always_ff @(posedge clk or posedge reset) begin
        if (reset)
            current_opcode <= 0;
        else if (li)
            current_opcode <= ram_out[7:4];
    end

    // ================= AC REGISTER (Accumulator) =================
    always_ff @(posedge clk or posedge reset) begin
        if (reset)
            reg_a <= 0;
        else if (la) begin
            if (current_opcode == 4'b0001)  // LDA instruction
                reg_a <= ram_out;
            else                              // ADD or SUB instruction
                reg_a <= alu_res;
        end
    end

    // ================= B REGISTER =================
    always_ff @(posedge clk or posedge reset) begin
        if (reset)
            reg_b <= 0;
        else if (lb)
            reg_b <= ram_out;
    end

    // ================= OUTPUT REGISTER =================
    always_ff @(posedge clk or posedge reset) begin
        if (reset)
            out_display <= 0;
        else if (lo)
            out_display <= reg_a;
    end

endmodule