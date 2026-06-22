// File: tb_Mux2to1.sv
// 2-to-1 Mux Testbench

`timescale 1ns/1ps

module tb_Mux2to1();
    logic [7:0] in0, in1, out;
    logic sel;
   
    integer pass_count, fail_count;

    // Instantiate the 2-to-1 Mux
    Mux2to1 #(.WIDTH(8)) uut (.*);

    initial begin
        pass_count = 0;
        fail_count = 0;
       
        $display("========================================");
        $display("--- Mux 2-to-1 Unit Test Started ---");
        $display("========================================");

        in0 = 8'h11; 
        in1 = 8'h22;

        // Test Path 0
        $display("\n[Sel=0 Test]");
        sel = 0; #10;
        check_mux("Sel=0 (in0?out)", 8'h11, out);
       
        // Test Path 1
        $display("\n[Sel=1 Test]");
        sel = 1; #10;
        check_mux("Sel=1 (in1?out)", 8'h22, out);
       
        // Test with different values
        $display("\n[Different Values Test]");
        in0 = 8'hAA; 
        in1 = 8'h55;
        sel = 0; #10;
        check_mux("Sel=0 with AA/55", 8'hAA, out);
        
        sel = 1; #10;
        check_mux("Sel=1 with AA/55", 8'h55, out);
       
        // Test with zeros
        $display("\n[Zero Values Test]");
        in0 = 8'h00; 
        in1 = 8'h00;
        sel = 0; #10;
        check_mux("Sel=0 with zeros", 8'h00, out);
        
        sel = 1; #10;
        check_mux("Sel=1 with zeros", 8'h00, out);
       
        // Test Summary
        $display("\n========================================");
        $display("Test Summary: %0d PASSED, %0d FAILED", pass_count, fail_count);
        $display("========================================");
       
        if (fail_count == 0)
            $display("Mux Testbench: ALL TESTS PASSED");
        else
            $display("Mux Testbench: SOME TESTS FAILED");
       
        $stop;
    end
   
    task check_mux(input string test_name, input [7:0] expected, input [7:0] actual);
        if (expected === actual) begin
            $display(" PASS | %s | Expected=%h | Got=%h", test_name, expected, actual);
            pass_count++;
        end else begin
            $display(" FAIL | %s | Expected=%h | Got=%h", test_name, expected, actual);
            fail_count++;
        end
    endtask

endmodule