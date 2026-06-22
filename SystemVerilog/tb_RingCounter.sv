// File: tb_RingCounter.sv
// Ring Counter Testbench

`timescale 1ns/1ps

module tb_RingCounter();
    logic clk, reset;
    logic [5:0] T;
   
    integer pass_count, fail_count;
    integer step;

    // Instantiate Ring Counter
    RingCounter uut (.*);

    // Clock Generation
    always #5 clk = ~clk;

    initial begin
        pass_count = 0;
        fail_count = 0;
       
        $display("========================================");
        $display("--- Ring Counter Unit Test Started ---");
        $display("========================================");

        // Monitor signal changes
        $monitor("Time=%t | T=%b (T5 T4 T3 T2 T1 T0)", 
                 $time, T);

        // 1. Reset Test
        $display("\n[Reset Test]");
        clk = 0; 
        reset = 1; 
        #15;
        check_ring("After Reset", 6'b000001, T);
        reset = 0;

        // 2. Sequence Test (Full Cycle)
        $display("\n[Sequence Test]");
       
        step = 0;
        repeat(8) begin
            @(posedge clk); #2;
            case (step)
                0: check_ring("T0 ? T1", 6'b000010, T);
                1: check_ring("T1 ? T2", 6'b000100, T);
                2: check_ring("T2 ? T3", 6'b001000, T);
                3: check_ring("T3 ? T4", 6'b010000, T);
                4: check_ring("T4 ? T5", 6'b100000, T);
                5: check_ring("T5 ? T0", 6'b000001, T);
                6: check_ring("T0 ? T1 again", 6'b000010, T);
                7: check_ring("T1 ? T2 again", 6'b000100, T);
            endcase
            step++;
        end

        // 3. Reset During Operation Test
        $display("\n[Reset During Operation Test]");
        reset = 1; 
        #15;
        check_ring("Reset during operation", 6'b000001, T);
        reset = 0;

        @(posedge clk); #2;
        check_ring("After reset ? T1", 6'b000010, T);

        // Test Summary
        $display("\n========================================");
        $display("Test Summary: %0d PASSED, %0d FAILED", pass_count, fail_count);
        $display("========================================");
       
        if (fail_count == 0)
            $display("RingCounter Testbench: ALL TESTS PASSED");
        else
            $display("RingCounter Testbench: SOME TESTS FAILED");
       
        $stop;
    end
   
    task check_ring(input string test_name, input [5:0] expected, input [5:0] actual);
        if (expected === actual) begin
            $display(" PASS | %s | Expected=%b | Got=%b", test_name, expected, actual);
            pass_count++;
        end else begin
            $display(" FAIL | %s | Expected=%b | Got=%b", test_name, expected, actual);
            fail_count++;
        end
    endtask

endmodule