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
* `kmap_y5.png` → handwritten 16×16 K-map showing output bit y₅ mapping
* `Project1_Report_GauravBanepali.pdf` → complete report with analysis and results

Simulations were compiled and executed using **Icarus Verilog (`iverilog`, `vvp`)** and visualized in **GTKWave**.

---

## 🧩 K-Map Analysis

The K-map represents the **output bit `y₅(x₇..x₀)`** directly, which determines whether bit 5 should remain high or be cleared for each ASCII input.
Cells are filled according to this rule:

* **0** when `x₅ = 0`
* **1** when `x₅ = 1`, **except** for ASCII 97–122 (`'a'–'z'`), where the cell is **0**

This configuration ensures that bit 5 is cleared automatically for lowercase letters, performing the uppercase conversion within the hardware itself.
The derived sum-of-products (SOP) expression for `y₅` defines the gate-level implementation used in the circuit.

**Handwritten K-Map Illustration:**
![K-map for y5](kmap_y5.png)

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
* This confirms that **hardware speed is limited by gate-level timing**.

---

## 🧾 Conclusion

The `toUpper()` Verilog implementation successfully demonstrates how primitive gates can replicate a text-processing function at the hardware level.
Through simulation and timing analysis, it was verified that the design remains stable at 10 ns or greater input spacing and fails below this threshold.
The implemented K-map for `y₅` achieves the correct uppercase conversion by clearing bit 5 for lowercase letters and leaving all other characters unchanged.

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
├── kmap_y5.png
├── Project1_Report_GauravBanepali.pdf
└── README.md
```
