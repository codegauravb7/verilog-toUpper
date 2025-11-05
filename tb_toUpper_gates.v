`timescale 1ns / 1ps

module tb_toUpper;
  // Parameterize inter-input delay to stress timing
  parameter integer INTERVAL_NS = 8; // start conservatively; decrease to find threshold

  reg  [7:0] x;
  wire [7:0] y;

  toUpper dut (.x(x), .y(y));

  // Helper task to apply a byte and print before/after
  task apply_and_log(input [7:0] val);
    begin
      x = val;
      #(INTERVAL_NS/2); // allow part of the network to respond
      $display("t=%0t ns | IN:  dec=%-3d  hex=%02h  bin=%b  chr=%s  || OUT: dec=%-3d  hex=%02h  bin=%b  chr=%s",
               $time, x, x, x, (x>=8'h20 && x<=8'h7E)? {x}:"?",
               y, y, y, (y>=8'h20 && y<=8'h7E)? {y}:"?");
      #(INTERVAL_NS/2);
    end
  endtask

  integer i;
  reg [7:0] vecs [0:18];

  initial begin
    // Stimulus set from the assignment (decimal → symbol):
    // 40 '(' , 72 'H', 183 '·', 131 'ƒ', 124 '|', 20 DC4, 235 ë, 97 'a',
    // 65 'A', 122 'z', 71 'G', 109 'm', 146 ''', 48 '0', 207 'Ï', 58 ':',
    // 123 '{', 148 '”', 127 DEL
    vecs[ 0]=8'd40;  vecs[ 1]=8'd72;  vecs[ 2]=8'd183; vecs[ 3]=8'd131; vecs[ 4]=8'd124;
    vecs[ 5]=8'd20;  vecs[ 6]=8'd235; vecs[ 7]=8'd97;  vecs[ 8]=8'd65;  vecs[ 9]=8'd122;
    vecs[10]=8'd71;  vecs[11]=8'd109; vecs[12]=8'd146; vecs[13]=8'd48;  vecs[14]=8'd207;
    vecs[15]=8'd58;  vecs[16]=8'd123; vecs[17]=8'd148; vecs[18]=8'd127;

    // VCD for GTKWave
    $dumpfile("toUpper_gates.vcd");
    $dumpvars(0, tb_toUpper);

    $display("INTERVAL_NS = %0d ns", INTERVAL_NS);
    // Run vectors
    for (i=0; i<19; i=i+1) begin
      apply_and_log(vecs[i]);
    end

    // Hold last value a bit so waveforms are clear
    #100;
    $finish;
  end
endmodule
