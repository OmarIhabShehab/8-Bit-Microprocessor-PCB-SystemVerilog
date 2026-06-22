`timescale 1ns/1ps

module ARM_I_TB();

    logic clk;
    logic reset;
    logic [7:0] out_display;
    
    // Debug signals
    logic [7:0] dbg_pc, dbg_ir, dbg_ac, dbg_b, dbg_alu, dbg_mem_out, dbg_addr;
    logic [5:0] dbg_T;
    logic dbg_halt, dbg_lb, dbg_la, dbg_li, dbg_we;

    ARM_I_Top uut (
        .clk(clk),
        .reset(reset),
        .out_display(out_display),
        .dbg_pc(dbg_pc),
        .dbg_ir(dbg_ir),
        .dbg_ac(dbg_ac),
        .dbg_b(dbg_b),
        .dbg_alu(dbg_alu),
        .dbg_T(dbg_T),
        .dbg_halt(dbg_halt),
        .dbg_mem_out(dbg_mem_out),
        .dbg_lb(dbg_lb),
        .dbg_la(dbg_la),
        .dbg_li(dbg_li),
        .dbg_we(dbg_we),
        .dbg_addr(dbg_addr)
    );

    always #5 clk = ~clk;

    initial begin
        clk = 0;
        reset = 1;
        #20 reset = 0;

        // Run for 5 microseconds
        #500000;

        $display("=== SIMULATION COMPLETED ===");
        $display("Final OUT = %0d", out_display);
        $stop;
    end

    // Detailed monitor with all debug signals
    initial begin
        $monitor("T=%0t | PC=%0h | IR=%0h | AC=%0d | B=%0d | ALU=%0d | MEM_OUT=%0d | ADDR=%0h | T=%b | LB=%b | LA=%b | LI=%b | WE=%b | HALT=%b | OUT=%0d",
                 $time, dbg_pc, dbg_ir, dbg_ac, dbg_b, dbg_alu, dbg_mem_out, dbg_addr, dbg_T, 
                 dbg_lb, dbg_la, dbg_li, dbg_we, dbg_halt, out_display);
    end

    initial begin
        $dumpfile("ARM_I_Top.vcd");
        $dumpvars(0, ARM_I_TB);
    end

endmodule