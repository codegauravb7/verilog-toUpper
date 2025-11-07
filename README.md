# Project 1 — Gate-Level Implementation of `toUpper()`

**Author:** Gaurav Banepali
**Course:** CSC 211000 – Digital Design
**Date:** November 2025

---

## 🧠 Overview

This project demonstrates how the `toUpper()` function — normally implemented in software — can be recreated entirely in **hardware** using primitive logic gates in Verilog.
The circuit converts lowercase ASCII letters (`a–z`) to uppercase (`A–Z`) while leaving all other characters unchanged.
It also explores how **propagation delays** and **timing constraints** affect circuit stability and performance.

---

## ⚙️ Implementation

The design was written in Verilog using only **primitive digital gates**. No `assign` statements or behavioral modeling were used.

| Gate Type | Delay (#) | Description                          |
| --------- | --------- | ------------------------------------ |
| NOT       | #5        | Inverts a single bit                 |
| AND, OR   | #10       | Basic combinational logic            |
| NAND, NOR | #12       | Inverted logic combinations          |
| XOR, XNOR | #15       | Used for comparison and parity       |
| BUF       | #4        | Buffers or stabilizes output signals |

**Files included in the repository:**

* `toUpper_gates.v` → main Verilog module (gate-level circuit)
* `tb_toUpper_gates.v` → testbench providing ASCII inputs and timing intervals
* `toUpper_gates.vcd` → waveform dump for GTKWave visualization
* `wave_correct.png` → correct 40 ns operation
* `wave_min_pass.png` → minimum passing 10 ns interval
* `wave_max_fail.png` → failing 8 ns interval
* `kmap_handdrawn.png` → hand-drawn 16×16 K-map showing active ASCII region
* `Project1_Report_GauravBanepali.pdf` → complete report with analysis and results

Simulations were compiled and executed using **Icarus Verilog (`iverilog`, `vvp`)** and visualized in **GTKWave**.

---

## 🧩 K-Map Analysis

To detect when input ASCII codes fall in the lowercase range (97–122 → `01100001₂`–`01111010₂`), a full **8-bit (16×16) K-Map** was created using Gray-code ordering.
The map highlights logic 1 for all lowercase letters `'a'–'z'` and 0 elsewhere.
This detection signal is expressed as:

[
L(x_7..x_0)=1 \text{ for 97 ≤ ASCII ≤ 122}
]

which drives the **bit-5 clearing logic**:

[
y_5 = x_5 \cdot \lnot L
]

**K-Map illustration:**
![K-map](kmap_handdrawn.png)

---

## 📊 Simulation Results

| Input Interval (ns) | Behavior                   | Notes                       |
| ------------------- | -------------------------- | --------------------------- |
| 40                  | ✅ Correct                  | Normal operation            |
| 20                  | ✅ Correct                  | Stable output               |
| 12                  | ✅ Correct                  | Stable output               |
| **10**              | ✅ Minimum Passing Interval | Smallest safe delay         |
| **8**               | ❌ Failing Interval         | Unstable / incorrect output |

**Waveform Screenshots:**

* **Figure 1:** Normal operation at 40 ns
* **Figure 2:** Minimum valid interval (10 ns)
* **Figure 3:** Failing interval (8 ns)

---

## 🧠 Observations

* The circuit behaves correctly as long as gate outputs have enough time to settle.
* At ≤ 10 ns, propagation delays overlap, producing glitches in some output bits.
* This confirms that **hardware speed is limited by gate-level timing.**

---

## 🧾 Conclusion

The `toUpper()` Verilog implementation successfully demonstrates how primitive gates can replicate a text-processing function at the hardware level.
Through simulation and stress testing, it was verified that the design remains stable at 10 ns or greater input spacing and fails below this threshold.
This highlights the relationship between **timing analysis** and **reliable digital design.**

---

## 📁 Repository Contents

```
verilog-toUpper/
│
├── toUpper_gates.v
├── tb_toUpper_gates.v
├── toUpper_gates.vcd
├── wave_correct.png
├── wave_min_pass.png
├── wave_max_fail.png
├── kmap_handdrawn.png
├── Project1_Report_GauravBanepali.pdf
└── README.md
```