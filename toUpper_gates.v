`timescale 1ns / 1ps
// Gate-level ASCII toUpper() using ONLY primitive gates + per-gate delays.
// Allowed gates: NOT(#5), AND/OR(#10), NAND/NOR(#12), XOR/XNOR(#15), BUF(#4).
// No assign statements; no behavioral operators in the DUT.

module toUpper(
  input  [7:0] x,
  output [7:0] y
);
  // Bit aliases
  wire b7 = x[7], b6 = x[6], b5 = x[5], b4 = x[4], b3 = x[3], b2 = x[2], b1 = x[1], b0 = x[0];

  // Inverters (NOT #5)
  wire nb7, nb6, nb5, nb4, nb3, nb2, nb1, nb0;
  not #5 N7(nb7, b7);
  not #5 N6(nb6, b6);
  not #5 N5(nb5, b5);
  not #5 N4(nb4, b4);
  not #5 N3(nb3, b3);
  not #5 N2(nb2, b2);
  not #5 N1(nb1, b1);
  not #5 N0(nb0, b0);

  // Base qualifier for lowercase: (~b7) & b6 & b5  -> t1
  wire nb7_and_b6, t1;
  and #10 A1(nb7_and_b6, nb7, b6);
  and #10 A2(t1, nb7_and_b6, b5);

  // Lower-nibble validity for 'a'..'z' (0x61..0x7A):
  // valid_low = NOT( (~b4 & ~b3 & ~b2 & ~b1 & ~b0)                   // excludes 0x60 '`'
  //                | ( b4 & ( (b3 & b2) | (b3 & ~b2 & b1 & b0) ) ) ) // excludes 0x6B–0x6F? Nope—this term catches 0x7B–0x7F (>=1011 when b4=1)
  //
  // Build zero_low = ~b4 & ~b3 & ~b2 & ~b1 & ~b0
  wire nb3nb2, nb1nb0, nb3nb2_nb1nb0, zero_low;
  and #10 A3(nb3nb2, nb3, nb2);
  and #10 A4(nb1nb0, nb1, nb0);
  and #10 A5(nb3nb2_nb1nb0, nb3nb2, nb1nb0);
  and #10 A6(zero_low, nb4, nb3nb2_nb1nb0);

  // term_a =  b3 & b2
  wire term_a;
  and #10 A7(term_a, b3, b2);

  // term_b =  b3 & ~b2 & b1 & b0
  wire nb2_b1, nb2b1b0, term_b_p1, term_b;
  and #10 A8(nb2_b1, nb2, b1);
  and #10 A9(nb2b1b0, nb2_b1, b0);
  and #10 A10(term_b_p1, b3, nb2b1b0);
  // You can also directly AND four inputs using a small tree:
  buf #4 Btmp(term_b, term_b_p1); // simple buffer to respect allowed primitives

  // hi_invalid = b4 & (term_a | term_b)
  wire term_a_or_term_b, hi_invalid;
  or  #10 O1(term_a_or_term_b, term_a, term_b);
  and #10 A11(hi_invalid, b4, term_a_or_term_b);

  // invalid = zero_low | hi_invalid
  wire invalid, valid_low;
  or  #10 O2(invalid, zero_low, hi_invalid);
  not #5  Nvalid(valid_low, invalid);

  // is_lower = t1 & valid_low
  wire is_lower;
  and #10 A12(is_lower, t1, valid_low);

  // Clear bit5 iff lowercase: y5 = b5 & ~is_lower
  wire nis_lower, b5_and_nis_lower;
  not #5 Nisl(nis_lower, is_lower);
  and #10 A13(b5_and_nis_lower, b5, nis_lower);

  // Outputs: all bits buffered; bit 5 uses the gated version
  buf #4 BY7(y[7], b7);
  buf #4 BY6(y[6], b6);
  buf #4 BY5(y[5], b5_and_nis_lower);
  buf #4 BY4(y[4], b4);
  buf #4 BY3(y[3], b3);
  buf #4 BY2(y[2], b2);
  buf #4 BY1(y[1], b1);
  buf #4 BY0(y[0], b0);

endmodule
