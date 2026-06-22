// File: tb_ALU.sv
`timescale 1ns/1ps

module tb_ALU();
    logic [7:0] A, B, Out;
    logic Su;
    
    logic [7:0] expected;
    integer pass_count, fail_count;

    // Connect the ALU
    ALU #(.WIDTH(8)) uut (.*, .ALU_Out(Out));

    initial begin
        pass_count = 0;
        fail_count = 0;

        $display("--- Starting ALU Unit Test ---");
  

        // Test 1: Basic Addition
        A = 8'd10; B = 8'd5; Su = 0; expected = 8'd15; #10;
        check_result("ADD Basic", expected, Out);

        // Test 2: Basic Subtraction
        A = 8'd10; B = 8'd5; Su = 1; expected = 8'd5; #10;
        check_result("SUB Basic", expected, Out);

        // Test 3: Add with zero
        A = 8'd0; B = 8'd5; Su = 0; expected = 8'd5; #10;
        check_result("ADD with Zero", expected, Out);

        // Test 4: Subtraction giving zero
        A = 8'd5; B = 8'd5; Su = 1; expected = 8'd0; #10;
        check_result("SUB to Zero", expected, Out);

        // Test 5: Negative result (2's complement)
        A = 8'd5; B = 8'd10; Su = 1; expected = 8'd251; #10;
        check_result("SUB Negative", expected, Out);

        // Test 6: Overflow addition
        A = 8'd200; B = 8'd60; Su = 0; expected = 8'd4; #10;
        $display("Overflow Test: 200+60 = %d (should be 4)", Out);

        // Test 7: Max value +1 overflow
        A = 8'hFF; B = 8'd1; Su = 0; expected = 8'd0; #10;
        check_result("255 + 1 Overflow", expected, Out);

       
        $display("Test Summary: %0d PASSED, %0d FAILED", pass_count, fail_count);

        
        if (fail_count == 0)
            $display("ALU Testbench: ALL TESTS PASSED");
        else
            $display("ALU Testbench: SOME TESTS FAILED");
        
        $stop;
    end
    
    // Check if result is correct
    task check_result(input string test_name, input [7:0] expected, input [7:0] actual);
        if (expected === actual) begin
            $display("PASS %s: Expected=%0d, Got=%0d", test_name, expected, actual);
            pass_count++;
        end else begin
            $display("FAIL %s: Expected=%0d, Got=%0d", test_name, expected, actual);
            fail_count++;
        end
    endtask

endmodule