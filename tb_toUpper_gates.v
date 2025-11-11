`timescale 1ns/1ps

module tb_toUpper;

    // ----------------------------------------------------
    // Adjustable delay between inputs (default = 10 ns)
    // Change using:
    // vvp toUpper_test +INTERVAL_NS=40
    // ----------------------------------------------------
    parameter integer INTERVAL_NS = 8;

    reg  [7:0] x;
    wire [7:0] y;

    // DUT
    toUpper dut (.x(x), .y(y));

    // ----------------------------------------------------
    // Function to compute correct expected ASCII value
    // ----------------------------------------------------
    function automatic [7:0] exp_upper(input [7:0] c);
        if (c >= "a" && c <= "z")
            exp_upper = c - 8'h20;     // Clear bit 5
        else
            exp_upper = c;
    endfunction

    // ----------------------------------------------------
    // Task: Apply input, wait, display, compare to expected
    // ----------------------------------------------------
    task apply_and_check(input [7:0] val);
        reg [7:0] expected;
        begin
            x = val;
            expected = exp_upper(val);

            #(INTERVAL_NS);

            if (y !== expected) begin
                $display("**ERROR** t=%0dns  IN=%s(0x%02h)  y=0x%02h  exp=0x%02h",
                         $time,
                         (val>=8'h20 && val<=8'h7E)? {val}:"?",
                         val, y, expected);
            end else begin
                $display("t=%0dns | IN: 0x%02h (%s)  || OUT: 0x%02h (%s)  || EXP: 0x%02h (%s)",
                         $time,
                         val,
                         (val>=8'h20 && val<=8'h7E)? {val}:"?",
                         y,
                         (y>=8'h20 && y<=8'h7E)? {y}:"?",
                         expected,
                         (expected>=8'h20 && expected<=8'h7E)? {expected}:"?"
                        );
            end
        end
    endtask

    integer i;

    // ----------------------------------------------------
    // Test all 256 ASCII values
    // ----------------------------------------------------
    initial begin
        $dumpfile("toUpper_gates.vcd");
        $dumpvars(0, tb_toUpper);

        $display("INTERVAL_NS = %0d ns", INTERVAL_NS);

        for (i = 0; i < 256; i = i + 1) begin
            apply_and_check(i[7:0]);
        end

        #100;
        $finish;
    end

endmodule