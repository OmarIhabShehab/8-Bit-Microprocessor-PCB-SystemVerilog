// File: tb_Register.sv
// Register Testbench

`timescale 1ns/1ps

module tb_Register();
    logic clk, reset, load;
    logic [7:0] data_in, data_out;
   
    integer pass_count, fail_count;

    // Instantiate the Register
    Register #(.WIDTH(8)) uut (.*);

    // Clock Generation (100 MHz)
    always #5 clk = ~clk;

    initial begin
        pass_count = 0;
        fail_count = 0;
       
        $display("========================================");
        $display("--- Register Unit Test Started ---");
        $display("========================================");

        // Initialize signals
        clk = 0;
        reset = 1;
        load = 0;
        data_in = 8'h00;

        // 1. Reset Test
        $display("\n[Reset Test]");
        #15;
        reset = 0;
        check_register("After Reset", 8'h00, data_out);

        // 2. Load Disabled Test
        $display("\n[Load Disabled Test]");
        data_in = 8'hAA;
        #10;
        @(posedge clk); #2;
        check_register("Load=0 (Should Not Change)", 8'h00, data_out);

        // 3. Load Enabled Test
        $display("\n[Load Enabled Test]");
        load = 1;
        @(posedge clk); #2;
        load = 0;
        @(posedge clk); #2;
        check_register("Load=1 (Load 0xAA)", 8'hAA, data_out);

        // 4. Hold Value Test
        $display("\n[Hold Test]");
        data_in = 8'hFF;
        #10;
        check_register("Hold Value (Load=0)", 8'hAA, data_out);

        // 5. Second Load Test
        $display("\n[Second Load Test]");
        data_in = 8'h55;
        load = 1;
        @(posedge clk); #2;
        load = 0;
        @(posedge clk); #2;
        check_register("Load 0x55", 8'h55, data_out);

        // 6. Reset Again Test
        $display("\n[Reset Again Test]");
        reset = 1;
        #10;
        check_register("Reset to Zero", 8'h00, data_out);
        reset = 0;

        // Test Summary
        $display("\n========================================");
        $display("Test Summary: %0d PASSED, %0d FAILED", pass_count, fail_count);
        $display("========================================");
       
        if (fail_count == 0)
            $display("Register Testbench: ALL TESTS PASSED");
        else
            $display("Register Testbench: SOME TESTS FAILED");
       
        $stop;
    end
   
    task check_register(input string test_name, input [7:0] expected, input [7:0] actual);
        #2;
        if (expected === actual) begin
            $display("%s: PASS (Expected=%h, Got=%h)", test_name, expected, actual);
            pass_count++;
        end else begin
            $display("%s: FAIL (Expected=%h, Got=%h)", test_name, expected, actual);
            fail_count++;
        end
    endtask

endmodule