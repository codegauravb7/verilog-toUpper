`timescale 1ns/1ps
// Gate-level ASCII toUpper(): minimal K-map SOP for y[5]
// Allowed primitive gates only with propagation delays.

module toUpper(
    input  [7:0] x,
    output [7:0] y
);

    // ----------------------------------------------------
    // Inverters (NOT #5)
    // ----------------------------------------------------
    wire nx7, nx6, nx5, nx4, nx3, nx2, nx1, nx0;
    not #5 N7 (nx7, x[7]);
    not #5 N6 (nx6, x[6]);
    not #5 N5 (nx5, x[5]);
    not #5 N4 (nx4, x[4]);
    not #5 N3 (nx3, x[3]);
    not #5 N2 (nx2, x[2]);
    not #5 N1 (nx1, x[1]);
    not #5 N0 (nx0, x[0]);

    // ----------------------------------------------------
    // Minimal SOP for output bit y5 (derived from 16×16 K-map)
    //
    // y5 = F0 + F1 + F2 + F3 + F4
    //
    // F0 =  x5 & x7
    // F1 =  x5 & ~x6 & ~x7
    // F2 = ~x7 & x6 & x5 & x4 & x3 & x2
    // F3 = ~x7 & x5 & ~x4 & ~x3 & ~x2 & ~x1 & ~x0
    // F4 = ~x7 & x6 & x5 & x4 & x3 & ~x2 & x1 & x0
    // ----------------------------------------------------
    wire F0, F1, F2, F3, F4;

    and #10 AND0 (F0, x[5], x[7]);
    and #10 AND1 (F1, x[5], nx6, nx7);
    and #10 AND2 (F2, nx7, x[6], x[5], x[4], x[3], x[2]);
    and #10 AND3 (F3, nx7, x[5], nx4, nx3, nx2, nx1, nx0);
    and #10 AND4 (F4, nx7, x[6], x[5], x[4], x[3], nx2, x[1], x[0]);

    // OR terms → y5 (OR #10)
    or #10 OR5 (y[5], F0, F1, F2, F3, F4);

    // ----------------------------------------------------
    // Pass-through bits using buffers (BUF #4)
    // ----------------------------------------------------
    buf #4 B7 (y[7], x[7]);
    buf #4 B6 (y[6], x[6]);
    buf #4 B4 (y[4], x[4]);
    buf #4 B3 (y[3], x[3]);
    buf #4 B2 (y[2], x[2]);
    buf #4 B1 (y[1], x[1]);
    buf #4 B0 (y[0], x[0]);

endmodule
