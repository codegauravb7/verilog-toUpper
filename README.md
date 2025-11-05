# Project 1 — Gate-level Implementation of `toUpper()`

**Author:** Gaurav Banepali  
**Course:** CSC 211000 – Digital Design  
**Date:** November 2025  

---

## 🧠 Overview
This project demonstrates how the `toUpper()` function — typically used in software — can be implemented purely in hardware using **primitive logic gates** in Verilog.  
The circuit converts lowercase ASCII letters (`a–z`) to uppercase (`A–Z`) while leaving all other characters unchanged.  
It also explores how propagation delays and timing constraints affect the reliability of digital circuits.

---

## ⚙️ Implementation
The design was written in Verilog and built entirely from primitive gate components:

| Gate Type | Delay (#) |
|------------|-----------|
| NOT | #5 |
| AND, OR | #10 |
| NAND, NOR | #12 |
| XOR, XNOR | #15 |
| BUF | #4 |

**Files included:**
- `toUpper_gates.v` → main Verilog module  
- `tb_toUpper_gates.v` → testbench with input vectors and timing control  
- `Project1_Report_GauravBanepali.pdf` → full report including waveform screenshots and timing analysis  

Simulation was done using **Icarus Verilog** (`iverilog`, `vvp`), and waveforms were analyzed in **GTKWave**.

---

## 📊 Results Summary

| Input Interval (ns) | Result |
|----------------------|---------|
| 40 | Correct behavior |
| 20 | Correct behavior |
| 12 | Correct behavior |
| **10** | ✅ Minimum passing interval |
| **8** | ❌ Failing interval (unstable output) |

The circuit remained fully functional down to **10 ns** between input changes.  
At **8 ns**, outputs began to glitch, confirming that gate propagation delay limits circuit performance.

---

## 📷 Waveform Screenshots
- **Figure 1:** Normal operation (40 ns interval)  
- **Figure 2:** Minimum passing delay (10 ns)  
- **Figure 3:** Failing delay (8 ns)

All waveform images are embedded in the PDF report.

---

## 🧩 Conclusion
This project shows how a simple text-processing function can be modeled in hardware using primitive gates.  
It reinforces the importance of **timing analysis**, as propagation delay determines the maximum reliable operating speed of digital circuits.

---

## 📁 Repository Contents
