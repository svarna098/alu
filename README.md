# ALU Design and Verification

>  280+ test cases verified using self-checking testbench  
>  Covers functional, boundary, error, and timing scenarios  

---

## Overview
This project implements and verifies a **parameterized Arithmetic Logic Unit (ALU)** using Verilog.  
The ALU supports arithmetic, logical, comparison, shift, and multi-cycle operations.

A **self-checking testbench** is used to automatically compare the DUT (Design Under Test) with a reference model and generate PASS/FAIL results.

---

## ⚙️ ALU Features

###  Arithmetic Operations
- Addition (ADD)
- Subtraction (SUB)
- Addition with Carry (ADD_CIN)
- Subtraction with Carry (SUB_CIN)
- Increment / Decrement (A & B)

###  Logical Operations
- AND, OR, XOR
- NAND, NOR, XNOR
- NOT (A & B)

###  Shift & Rotate
- Shift Left / Right (SHL, SHR)
- Rotate Left / Right (ROL, ROR)

###  Comparison
- Equal (E)
- Greater (G)
- Less (L)

###  Signed Operations
- Signed Addition
- Signed Subtraction
- Overflow detection

###  Multi-cycle Operations
- Multiplication (MUL)
- Multiply with Shift (MUL_SHL)

###  Control Signals
- CLK → Clock  
- RST → Asynchronous Reset  
- CE → Clock Enable  
- MODE → Arithmetic / Logical mode select  
- CIN → Carry input  
- inp_valid → Input validity control  

---

##  Verification Methodology

### Self-Checking Testbench
- A **reference model** is used to generate expected outputs  
- DUT outputs are compared automatically using:
  - `compare()` → for single-cycle operations  
  - `mul_compare()` → for multi-cycle operations  

###  Signals Verified
- RES (Result)
- COUT (Carry Out)
- OFLOW (Overflow)
- G, E, L (Comparison flags)
- ERR (Error flag)

---
coverage Report

The ALU design was verified using QuestaSim coverage analysis with the following results:

- **Total Coverage: 94.38%**
- Statement Coverage: 97.22%
- Branch Coverage: 96.72%
- Expression Coverage: 100%
- Condition Coverage: 100%
- Toggle Coverage: 84.86%
- FSM Coverage: 87.50%
  - State Coverage: 100%
  - Transition Coverage: 75%

The high overall coverage demonstrates thorough verification of the ALU functionality.  
Remaining coverage gaps are primarily in toggle activity and FSM transitions, indicating areas for further test enhancement.

##  Test Coverage

The testbench includes **280+ test cases** covering:

###  Functional Testing
- All arithmetic, logical, and comparison operations  

###  Boundary Testing
- Zero values  
- Maximum values (all 1s)  
- Overflow and underflow cases  

###  Error Conditions
- Invalid commands  
- Invalid `inp_valid` combinations  

###  Control Signal Testing
- Reset during operation  
- Clock enable (CE=0 behavior)  
- Mode switching  

###  Multi-cycle Testing
- CMD change during MUL  
- Input change during execution  
- Mode change mid-operation  

---


##  Reference Model Notes
- A minor inconsistency was observed in a boundary test case due to stale data  
- Most mismatches are due to DUT design limitations  

---

##  Results Summary

- Basic arithmetic operations →  PASS  
- Logical operations →  PASS  
- Shift and rotate →  PASS  
- Signed operations →  Partial FAIL  
- Multi-cycle operations →  FAIL  

---

##  Future Improvements

- Fix reset priority logic  
- Correct signed arithmetic flag handling  
- Implement FSM for multi-cycle operations  
- Improve error handling logic  
- Ensure consistent bit-width handling  

---

