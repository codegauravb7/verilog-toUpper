`timescale 1ns/1ps

module tb_toUpper;

  // Adjustable delay between inputs (used for timing analysis)
  parameter integer INTERVAL_NS = 10;

  reg  [7:0] x;
  wire [7:0] y;

  // DUT
  toUpper dut (.x(x), .y(y));

  // Pretty printer
  task apply_and_log(input [7:0] val);
    begin
      x = val;
      #(INTERVAL_NS/2);
      $display("t=%0t ns | IN:  dec=%-3d hex=%02h bin=%08b chr=%s  || OUT: dec=%-3d hex=%02h bin=%08b chr=%s",
               $time,
               x, x, x, (x>=8'h20 && x<=8'h7E)? {x}:"?",
               y, y, y, (y>=8'h20 && y<=8'h7E)? {y}:"?");
      #(INTERVAL_NS/2);
    end
  endtask

  integer i;

  initial begin
    x = 8'h00;

    // VCD dump for GTKWave
    $dumpfile("toUpper_gates.vcd");
    $dumpvars(0, tb_toUpper);

    $display("INTERVAL_NS = %0d ns", INTERVAL_NS);

    // ---------- SCREENSHOT MODE: show letters nicely ----------
    // A..Z
    for (i = 8'h41; i <= 8'h5A; i = i + 1) begin
      apply_and_log(i[7:0]);
    end
    // a..z
    for (i = 8'h61; i <= 8'h7A; i = i + 1) begin
      apply_and_log(i[7:0]);
    end

    // ---------- FULL SWEEP (uncomment to test all 256 values) ----------
    // for (i = 0; i < 256; i = i + 1) begin
    //   apply_and_log(i[7:0]);
    // end

    #100;
    $finish;
  end

endmodule
