`timescale 1ns/1ps

module tb_ControlUnit();

    logic [3:0] opcode;
    logic [5:0] T;
    logic reset;

    logic Cp, MAR_sel, WE, Li, LB, LA, Su, Lo, HALT, Reset_ring;

    integer pass_count, fail_count;

    ControlUnit uut (.*);

    // ================= TASK =================
    task check_signal(
        input string test_name,
        input logic actual,
        input logic expected
    );
        #2; // stronger stability than #1
        if (actual === expected) begin
            $display("PASS: %s", test_name);
            pass_count++;
        end else begin
            $display("FAIL: %s (exp=%0d got=%0d)",
                     test_name, expected, actual);
            fail_count++;
        end
    endtask

    // ================= TEST =================
    initial begin

        pass_count = 0;
        fail_count = 0;

        reset = 1;
        opcode = 0;
        T = 0;

        #10 reset = 0;

        $display("\n=== CONTROL UNIT TEST START ===");

        // ================= FETCH =================
        $display("\n[FETCH]");

        T = 6'b000001; #5;
        check_signal("T0 MAR_sel=0", MAR_sel, 0);
        check_signal("T0 Li=1", Li, 1);

        T = 6'b000010; #5;
        check_signal("T1 Cp=1", Cp, 1);

        // ================= LDA =================
        $display("\n[LDA]");
        opcode = 4'b0001;

        T = 6'b000100; #5;
        check_signal("T2 MAR_sel=1", MAR_sel, 1);

        T = 6'b001000; #5;
        check_signal("T3 LA=1", LA, 1);

        // ================= ADD =================
        $display("\n[ADD]");
        opcode = 4'b0010;

        T = 6'b000100; #5;
        check_signal("T2 MAR_sel=1", MAR_sel, 1);

        T = 6'b001000; #5;
        check_signal("T3 LB=1", LB, 1);

        T = 6'b010000; #5;
        check_signal("T4 Su=0", Su, 0);
        check_signal("T4 LA=1", LA, 1);

        // ================= SUB =================
        $display("\n[SUB]");
        opcode = 4'b0011;

        T = 6'b000100; #5;
        check_signal("T2 MAR_sel=1", MAR_sel, 1);

        T = 6'b001000; #5;
        check_signal("T3 LB=1", LB, 1);

        T = 6'b010000; #5;
        check_signal("T4 Su=1", Su, 1);
        check_signal("T4 LA=1", LA, 1);

        // ================= STA =================
        $display("\n[STA]");
        opcode = 4'b0100;

        T = 6'b000100; #5;
        check_signal("T2 MAR_sel=1", MAR_sel, 1);

        T = 6'b001000; #5;
        check_signal("T3 WE=1", WE, 1);

        // ================= OUT =================
        $display("\n[OUT]");
        opcode = 4'b0101;

        T = 6'b000100; #5;
        check_signal("T2 Lo=1", Lo, 1);

        // ================= JMP =================
        $display("\n[JMP]");
        opcode = 4'b0110;

        T = 6'b000100; #5;
        check_signal("T2 Cp=1", Cp, 1);

        // ================= HALT =================
        $display("\n[HALT]");
        opcode = 4'b1111;

        T = 6'b000100; #5;
        check_signal("T2 HALT=1", HALT, 1);
        check_signal("T2 Reset_ring=1", Reset_ring, 1);

        // ================= SUMMARY =================
        $display("\n====================");
        $display("PASS=%0d FAIL=%0d", pass_count, fail_count);
        $display("====================");

        if (fail_count == 0)
            $display("ALL TESTS PASSED");
        else
            $display("SOME TESTS FAILED");

        $stop;
    end

endmodule