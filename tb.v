//`timescale 1ns/1ps
//`include "alu_design.v"
//`include "ref_design.v"
/*
module tb_alu_verify;

  parameter width     = 8;
  parameter cmd_width = 4;
  parameter out_width = 2*width;

  reg [width-1:0] OPA, OPB;
  reg CLK, RST, CE, MODE, CIN;
  reg [1:0] inp_valid;
  reg [cmd_width-1:0] CMD;

  // Reference model outputs
  wire [out_width-1:0] REF_RES;
  wire REF_COUT, REF_OFLOW, REF_G, REF_E, REF_L, REF_ERR;

  // DUT outputs
  wire [out_width-1:0] DUT_RES;
  wire DUT_COUT, DUT_OFLOW, DUT_G, DUT_E, DUT_L, DUT_ERR;

  // Instantiate reference model
  alu_reference_model #(width, cmd_width, out_width) ref_model (
    .OPA(OPA), .OPB(OPB), .clk(CLK), .rst(RST), .CE(CE),
    .MODE(MODE), .CIN(CIN), .inp_valid(inp_valid), .CMD(CMD),
    .RES(REF_RES), .COUT(REF_COUT), .OFLOW(REF_OFLOW),
    .G(REF_G), .E(REF_E), .L(REF_L), .ERR(REF_ERR)
  );

  // Instantiate DUT
  alu_design #(width, width, cmd_width) dut (
    .OPA(OPA), .OPB(OPB), .CLK(CLK), .RST(RST), .CE(CE),
    .MODE(MODE), .CIN(CIN), .INP_VALID(inp_valid), .CMD(CMD),
    .RES(DUT_RES), .COUT(DUT_COUT), .OFLOW(DUT_OFLOW),
    .G(DUT_G), .E(DUT_E), .L(DUT_L), .ERR(DUT_ERR)
  );

  initial CLK = 0;
  always #5 CLK = ~CLK;

  // Compare task
   task compare;
    input [127:0] test_name;
    begin
      @(posedge CLK); // wait for next posedge  both DUT and ref update here
      #1;             // small delay so outputs settle after posedge
      $display("--- %0s ---", test_name);
      if (DUT_RES === REF_RES)
        $display("  RES   : DUT=%0d REF=%0d PASS", DUT_RES, REF_RES);
      else
        $display("  RES   : DUT=%0d REF=%0d FAIL", DUT_RES, REF_RES);
      if (DUT_COUT === REF_COUT)
        $display("  COUT  : DUT=%0d REF=%0d PASS", DUT_COUT, REF_COUT);
      else
        $display("  COUT  : DUT=%0d REF=%0d FAIL", DUT_COUT, REF_COUT);
      if (DUT_OFLOW === REF_OFLOW)
        $display("  OFLOW : DUT=%0d REF=%0d PASS", DUT_OFLOW, REF_OFLOW);
      else
        $display("  OFLOW : DUT=%0d REF=%0d FAIL", DUT_OFLOW, REF_OFLOW);
      if (DUT_G === REF_G)
        $display("  G     : DUT=%0d REF=%0d PASS", DUT_G, REF_G);
      else
        $display("  G     : DUT=%0d REF=%0d FAIL", DUT_G, REF_G);
      if (DUT_E === REF_E)
        $display("  E     : DUT=%0d REF=%0d PASS", DUT_E, REF_E);
      else
        $display("  E     : DUT=%0d REF=%0d FAIL", DUT_E, REF_E);
      if (DUT_L === REF_L)
        $display("  L     : DUT=%0d REF=%0d PASS", DUT_L, REF_L);
      else
        $display("  L     : DUT=%0d REF=%0d FAIL", DUT_L, REF_L);
      if (DUT_ERR === REF_ERR)
        $display("  ERR   : DUT=%0d REF=%0d PASS", DUT_ERR, REF_ERR);
      else
        $display("  ERR   : DUT=%0d REF=%0d FAIL", DUT_ERR, REF_ERR);
    end
  endtask

 task mul_compare;
    input [127:0] test_name;
    begin
      @(posedge CLK); // wait for next posedge  both DUT and ref update here
      @(posedge CLK); // wait for next posedge  both DUT and ref update here
      @(posedge CLK); // wait for next posedge  both DUT and ref update here
      #1;             // small delay so outputs settle after posedge
      $display("--- %0s ---", test_name);
      if (DUT_RES === REF_RES)
        $display("  RES   : DUT=%0d REF=%0d PASS", DUT_RES, REF_RES);
      else
        $display("  RES   : DUT=%0d REF=%0d FAIL", DUT_RES, REF_RES);
      if (DUT_COUT === REF_COUT)
        $display("  COUT  : DUT=%0d REF=%0d PASS", DUT_COUT, REF_COUT);
      else
        $display("  COUT  : DUT=%0d REF=%0d FAIL", DUT_COUT, REF_COUT);
      if (DUT_OFLOW === REF_OFLOW)
        $display("  OFLOW : DUT=%0d REF=%0d PASS", DUT_OFLOW, REF_OFLOW);
      else
        $display("  OFLOW : DUT=%0d REF=%0d FAIL", DUT_OFLOW, REF_OFLOW);
      if (DUT_G === REF_G)
        $display("  G     : DUT=%0d REF=%0d PASS", DUT_G, REF_G);
      else
        $display("  G     : DUT=%0d REF=%0d FAIL", DUT_G, REF_G);
      if (DUT_E === REF_E)
        $display("  E     : DUT=%0d REF=%0d PASS", DUT_E, REF_E);
      else
        $display("  E     : DUT=%0d REF=%0d FAIL", DUT_E, REF_E);
      if (DUT_L === REF_L)
        $display("  L     : DUT=%0d REF=%0d PASS", DUT_L, REF_L);
      else
        $display("  L     : DUT=%0d REF=%0d FAIL", DUT_L, REF_L);
      if (DUT_ERR === REF_ERR)
        $display("  ERR   : DUT=%0d REF=%0d PASS", DUT_ERR, REF_ERR);
      else
        $display("  ERR   : DUT=%0d REF=%0d FAIL", DUT_ERR, REF_ERR);
    end
  endtask

  initial begin
    CE = 1; RST = 1; MODE = 0; CIN = 0;
    OPA = 0; OPB = 0; CMD = 0; inp_valid = 0;
    #10;
    RST = 0;

 // =====================================================
    // TC1  CLK toggle (just observed in waveform)
    // =====================================================
    $display("=== TC1: CLK toggle observed in waveform ===");

    // =====================================================
    // TC2  RST async assert/deassert during idle
    // =====================================================
    $display("=== TC2: RST async assert deassert ===");
    @(negedge CLK) begin OPA=5; OPB=3; CMD=4'b0000; inp_valid=2'b11; MODE=1; end
    #3; RST=1; #2; RST=0;  // assert RST mid-cycle asynchronously
    @(posedge CLK); #1;
    $display("  RST deassert: DUT_RES=%0d DUT_ERR=%0d (expect 0)", DUT_RES, DUT_ERR);

    // =====================================================
    // TC3  RST during operation
    // =====================================================
    $display("=== TC3: RST during operation ===");
    @(negedge CLK) begin OPA=7; OPB=2; CMD=4'b0000; inp_valid=2'b11; MODE=1; end
    #3; RST=1;  // assert RST mid-operation
    @(posedge CLK); #1;
    $display("  RST mid-op: DUT_RES=%0d (expect 0)", DUT_RES);
    RST=0;

    // =====================================================
    // TC4  CE enable
    // =====================================================
    $display("=== TC4: CE enable ===");
    @(negedge CLK) begin CE=1; OPA=5; OPB=3; CMD=4'b0000; inp_valid=2'b11; MODE=1; end
    compare("CE_ENABLE_ADD");

    // CE=0  output should not update
    $display("=== TC4b: CE=0 no update ===");
    @(negedge CLK) begin CE=0; OPA=7; OPB=7; CMD=4'b0000; inp_valid=2'b11; MODE=1; end
    @(posedge CLK); #1;
    $display("  CE=0: DUT_RES=%0d (expect same as before, no update)", DUT_RES);
    CE=1;

    // ================= ARITHMETIC =================
    MODE = 1;
    #1;

    @(negedge CLK) begin OPA=0; OPB=0; CMD=4'b0000; inp_valid=2'b00; end
    compare("ARITH_INP_VALID_00_ERR");

    @(negedge CLK) begin OPA=5; OPB=3; CMD=4'b0000; inp_valid=2'b11; end
    compare("ADD");

    @(negedge CLK) begin OPA=5; OPB=4; CMD=4'b0001; inp_valid=2'b11; end
    compare("SUB");

    @(negedge CLK) begin OPA=5; OPB=4; CIN=1; CMD=4'b0010; inp_valid=2'b11; end
    compare("ADD_CIN");

    @(negedge CLK) begin OPA=5; OPB=3; CIN=1; CMD=4'b0011; inp_valid=2'b11; end
    compare("SUB_CIN");

    @(negedge CLK) begin OPA=5; OPB=0; CIN=0; CMD=4'b0100; inp_valid=2'b01; end
    compare("INC_A_01");

    @(negedge CLK) begin OPA=5; OPB=0; CMD=4'b0100; inp_valid=2'b11; end
    compare("INC_A_11");

    @(negedge CLK) begin OPA=5; OPB=0; CMD=4'b0101; inp_valid=2'b01; end
    compare("DEC_A_01");

    @(negedge CLK) begin OPA=5; OPB=0; CMD=4'b0101; inp_valid=2'b11; end
    compare("DEC_A_11");

    @(negedge CLK) begin OPA=0; OPB=3; CMD=4'b0110; inp_valid=2'b10; end
    compare("INC_B_10");

    @(negedge CLK) begin OPA=0; OPB=3; CMD=4'b0110; inp_valid=2'b11; end
    compare("INC_B_11");

    @(negedge CLK) begin OPA=0; OPB=3; CMD=4'b0111; inp_valid=2'b10; end
    compare("DEC_B_10");

    @(negedge CLK) begin OPA=0; OPB=3; CMD=4'b0111; inp_valid=2'b11; end
    compare("DEC_B_11");

    @(negedge CLK) begin OPA=5; OPB=5; CMD=4'b1000; inp_valid=2'b11; end
    compare("CMP_EQUAL");

    @(negedge CLK) begin OPA=7; OPB=3; CMD=4'b1000; inp_valid=2'b11; end
    compare("CMP_GREATER");

    @(negedge CLK) begin OPA=3; OPB=7; CMD=4'b1000; inp_valid=2'b11; end
    compare("CMP_LESS");

    @(negedge CLK) begin OPA=2; OPB=3; CMD=4'b1001; inp_valid=2'b11; end
  mul_compare("MUL");

    @(negedge CLK) begin OPA=2; OPB=3; CMD=4'b1010; inp_valid=2'b11; end
    mul_compare("MUL_SHL");

    @(negedge CLK) begin OPA=5; OPB=3; CMD=4'b1011; inp_valid=2'b11; end
    compare("SIGNED_ADD");

    @(negedge CLK) begin OPA=7; OPB=3; CMD=4'b1100; inp_valid=2'b11; end
    compare("SIGNED_SUB");

    @(negedge CLK) begin OPA=1; OPB=1; CMD=4'b1111; inp_valid=2'b11; end
    compare("ARITH_DEFAULT_ERR");

    // ================= LOGICAL =================
    MODE = 0;

    @(negedge CLK) begin OPA=0; OPB=0; CMD=4'b0000; inp_valid=2'b00; end
    compare("LOGIC_INP_VALID_00_ERR");

    @(negedge CLK) begin OPA=4'b1010; OPB=4'b1100; CMD=4'b0000; inp_valid=2'b11; end
    compare("AND");

    @(negedge CLK) begin OPA=4'b1010; OPB=4'b1100; CMD=4'b0001; inp_valid=2'b11; end
    compare("NAND");

    @(negedge CLK) begin OPA=4'b1010; OPB=4'b1100; CMD=4'b0010; inp_valid=2'b11; end
    compare("OR");

    @(negedge CLK) begin OPA=4'b1010; OPB=4'b1100; CMD=4'b0011; inp_valid=2'b11; end
    compare("NOR");

    @(negedge CLK) begin OPA=4'b1010; OPB=4'b1100; CMD=4'b0100; inp_valid=2'b11; end
    compare("XOR");

    @(negedge CLK) begin OPA=4'b1010; OPB=4'b1100; CMD=4'b0101; inp_valid=2'b11; end
    compare("XNOR");

    @(negedge CLK) begin OPA=4'b1010; OPB=0; CMD=4'b0110; inp_valid=2'b01; end
    compare("NOT_A_01");

    @(negedge CLK) begin OPA=4'b1010; OPB=0; CMD=4'b0110; inp_valid=2'b11; end
    compare("NOT_A_11");

    @(negedge CLK) begin OPA=0; OPB=4'b1100; CMD=4'b0111; inp_valid=2'b10; end
    compare("NOT_B_10");

    @(negedge CLK) begin OPA=0; OPB=4'b1100; CMD=4'b0111; inp_valid=2'b11; end
    compare("NOT_B_11");

    @(negedge CLK) begin OPA=4'b1010; OPB=0; CMD=4'b1000; inp_valid=2'b01; end
    compare("SHR_A_01");

    @(negedge CLK) begin OPA=4'b1010; OPB=0; CMD=4'b1000; inp_valid=2'b11; end
    compare("SHR_A_11");

    @(negedge CLK) begin OPA=4'b0101; OPB=0; CMD=4'b1001; inp_valid=2'b01; end
    compare("SHL_A_01");

    @(negedge CLK) begin OPA=4'b0101; OPB=0; CMD=4'b1001; inp_valid=2'b11; end
    compare("SHL_A_11");

    @(negedge CLK) begin OPA=0; OPB=4'b1100; CMD=4'b1010; inp_valid=2'b10; end
    compare("SHR_B_10");

    @(negedge CLK) begin OPA=0; OPB=4'b1100; CMD=4'b1010; inp_valid=2'b11; end
    compare("SHR_B_11");

    @(negedge CLK) begin OPA=0; OPB=4'b0011; CMD=4'b1011; inp_valid=2'b10; end
    compare("SHL_B_10");

    @(negedge CLK) begin OPA=0; OPB=4'b0011; CMD=4'b1011; inp_valid=2'b11; end
    compare("SHL_B_11");

    @(negedge CLK) begin OPA=4'b1010; OPB=1; CMD=4'b1100; inp_valid=2'b11; end
    compare("ROL");

    @(negedge CLK) begin OPA=4'b1010; OPB=16; CMD=4'b1100; inp_valid=2'b11; end
    compare("ROL_ERR");

    @(negedge CLK) begin OPA=4'b1010; OPB=1; CMD=4'b1101; inp_valid=2'b11; end
    compare("ROR");

    @(negedge CLK) begin OPA=4'b1010; OPB=16; CMD=4'b1101; inp_valid=2'b11; end
    compare("ROR_ERR");

    @(negedge CLK) begin OPA=1; OPB=1; CMD=4'b1110; inp_valid=2'b11; end
    compare("LOGIC_DEFAULT_ERR");

//corner case
  
  @(negedge CLK) begin OPA={width{1'b1}}; OPB=1; CMD=4'b0000; inp_valid=2'b11; end
    compare("TC53_ADD_MAX_OVERFLOW")
Looking at your TB, here are additional edge cases to boost coverage beyond 69%:
verilog// =====================================================
// ADDITIONAL EDGE CASES FOR COVERAGE
// =====================================================

// --- CE=0 during various operations ---
$display("=== CE=0 DURING OPERATIONS ===");
@(negedge CLK) begin CE=0; OPA=5; OPB=3; CMD=4'b0000; inp_valid=2'b11; MODE=1; end
compare("CE0_ARITH_ADD_NO_UPDATE");
@(negedge CLK) begin CE=0; OPA=5; OPB=3; CMD=4'b0001; inp_valid=2'b11; MODE=1; end
compare("CE0_ARITH_SUB_NO_UPDATE");
@(negedge CLK) begin CE=0; OPA=5; OPB=3; CMD=4'b0000; inp_valid=2'b11; MODE=0; end
compare("CE0_LOGIC_AND_NO_UPDATE");
CE=1;

// --- RST during each MODE ---
$display("=== RST DURING ARITHMETIC ===");
MODE=1;
@(negedge CLK) begin OPA=7; OPB=5; CMD=4'b0000; inp_valid=2'b11; end
#2; RST=1; #3; RST=0;
@(posedge CLK); #1;
$display("  RST_ARITH: DUT_RES=%0d (expect 0)", DUT_RES);

$display("=== RST DURING LOGICAL ===");
MODE=0;
@(negedge CLK) begin OPA=4'b1010; OPB=4'b1100; CMD=4'b0000; inp_valid=2'b11; end
#2; RST=1; #3; RST=0;
@(posedge CLK); #1;
$display("  RST_LOGIC: DUT_RES=%0d (expect 0)", DUT_RES);
MODE=1;

// --- ADD boundary cases ---
$display("=== ADD BOUNDARY ===");
// 0+0=0
@(negedge CLK) begin OPA=0; OPB=0; CMD=4'b0000; inp_valid=2'b11; MODE=1; end
compare("ADD_ZERO_ZERO");
// max+max
@(negedge CLK) begin OPA={width{1'b1}}; OPB={width{1'b1}}; CMD=4'b0000; inp_valid=2'b11; end
compare("ADD_MAX_MAX");
// 0+max
@(negedge CLK) begin OPA=0; OPB={width{1'b1}}; CMD=4'b0000; inp_valid=2'b11; end
compare("ADD_ZERO_MAX");

// --- SUB boundary cases ---
$display("=== SUB BOUNDARY ===");
// max-max=0
@(negedge CLK) begin OPA={width{1'b1}}; OPB={width{1'b1}}; CMD=4'b0001; inp_valid=2'b11; end
compare("SUB_MAX_MAX_ZERO");
// max-0=max
@(negedge CLK) begin OPA={width{1'b1}}; OPB=0; CMD=4'b0001; inp_valid=2'b11; end
compare("SUB_MAX_ZERO");
// 0-0=0
@(negedge CLK) begin OPA=0; OPB=0; CMD=4'b0001; inp_valid=2'b11; end
compare("SUB_ZERO_ZERO");

// --- ADD_CIN boundary cases ---
$display("=== ADD_CIN BOUNDARY ===");
// max+max+1
@(negedge CLK) begin OPA={width{1'b1}}; OPB={width{1'b1}}; CIN=1; CMD=4'b0010; inp_valid=2'b11; end
compare("ADD_CIN_MAX_MAX_1");
// 0+0+0
@(negedge CLK) begin OPA=0; OPB=0; CIN=0; CMD=4'b0010; inp_valid=2'b11; end
compare("ADD_CIN_ZERO_ZERO_0");
// 0+0+1
@(negedge CLK) begin OPA=0; OPB=0; CIN=1; CMD=4'b0010; inp_valid=2'b11; end
compare("ADD_CIN_ZERO_ZERO_1");

// --- SUB_CIN boundary cases ---
$display("=== SUB_CIN BOUNDARY ===");
// 0-0-0
@(negedge CLK) begin OPA=0; OPB=0; CIN=0; CMD=4'b0011; inp_valid=2'b11; end
compare("SUB_CIN_ZERO_ZERO_0");
// 0-0-1 underflow
@(negedge CLK) begin OPA=0; OPB=0; CIN=1; CMD=4'b0011; inp_valid=2'b11; end
compare("SUB_CIN_ZERO_ZERO_1_UFLOW");
// max-0-0=max
@(negedge CLK) begin OPA={width{1'b1}}; OPB=0; CIN=0; CMD=4'b0011; inp_valid=2'b11; end
compare("SUB_CIN_MAX_ZERO_0");

// --- INC/DEC all inp_valid combinations ---
$display("=== INC DEC ALL INP_VALID ===");
// INC_A with inp_valid=10 ? ERR (only 01 and 11 valid)
@(negedge CLK) begin OPA=5; OPB=0; CMD=4'b0100; inp_valid=2'b10; MODE=1; end
compare("INC_A_INV10_ERR");
// DEC_A with inp_valid=10 ? ERR
@(negedge CLK) begin OPA=5; OPB=0; CMD=4'b0101; inp_valid=2'b10; end
compare("DEC_A_INV10_ERR");
// INC_B with inp_valid=01 ? ERR (only 10 and 11 valid)
@(negedge CLK) begin OPA=0; OPB=3; CMD=4'b0110; inp_valid=2'b01; end
compare("INC_B_INV01_ERR");
// DEC_B with inp_valid=01 ? ERR
@(negedge CLK) begin OPA=0; OPB=3; CMD=4'b0111; inp_valid=2'b01; end
compare("DEC_B_INV01_ERR");

// --- CMP boundary ---
$display("=== CMP BOUNDARY ===");
// 0 vs 0
@(negedge CLK) begin OPA=0; OPB=0; CMD=4'b1000; inp_valid=2'b11; end
compare("CMP_ZERO_ZERO");
// max vs max
@(negedge CLK) begin OPA={width{1'b1}}; OPB={width{1'b1}}; CMD=4'b1000; inp_valid=2'b11; end
compare("CMP_MAX_MAX");
// 0 vs max
@(negedge CLK) begin OPA=0; OPB={width{1'b1}}; CMD=4'b1000; inp_valid=2'b11; end
compare("CMP_ZERO_MAX_LESS");
// max vs 0
@(negedge CLK) begin OPA={width{1'b1}}; OPB=0; CMD=4'b1000; inp_valid=2'b11; end
compare("CMP_MAX_ZERO_GREATER");

// --- MUL boundary ---
$display("=== MUL BOUNDARY ===");
// 0*0=0
@(negedge CLK) begin OPA=0; OPB=0; CMD=4'b1001; inp_valid=2'b11; end
compare_mul("MUL_ZERO_ZERO");
// (0+1)*(0+1)=1
@(negedge CLK) begin OPA=0; OPB=0; CMD=4'b1001; inp_valid=2'b11; end
compare_mul("MUL_INC_ZERO");
// max*max
@(negedge CLK) begin OPA={width{1'b1}}; OPB={width{1'b1}}; CMD=4'b1001; inp_valid=2'b11; end
compare_mul("MUL_MAX_MAX");

// --- MUL_SHL boundary ---
$display("=== MUL_SHL BOUNDARY ===");
// (0<<1)*0=0
@(negedge CLK) begin OPA=0; OPB=0; CMD=4'b1010; inp_valid=2'b11; end
compare_mul("MUL_SHL_ZERO_ZERO");
// (1<<1)*1=2
@(negedge CLK) begin OPA=1; OPB=1; CMD=4'b1010; inp_valid=2'b11; end
compare_mul("MUL_SHL_ONE_ONE");

// --- SIGNED ADD boundary ---
$display("=== SIGNED ADD BOUNDARY ===");
// 0+0=0
@(negedge CLK) begin OPA=0; OPB=0; CMD=4'b1011; inp_valid=2'b11; end
compare("SADD_ZERO_ZERO");
// negative+negative overflow: -1 + -1 (all 1s + all 1s)
@(negedge CLK) begin OPA={width{1'b1}}; OPB={width{1'b1}}; CMD=4'b1011; inp_valid=2'b11; end
compare("SADD_NEG_NEG");
// positive+negative=0: max_pos + 1 (which is min_neg in signed)
@(negedge CLK) begin OPA={1'b0,{width-1{1'b1}}}; OPB={1'b1,{width-1{1'b0}}}; CMD=4'b1011; inp_valid=2'b11; end
compare("SADD_POS_NEG_ZERO");

// --- SIGNED SUB boundary ---
$display("=== SIGNED SUB BOUNDARY ===");
// 0-0=0
@(negedge CLK) begin OPA=0; OPB=0; CMD=4'b1100; inp_valid=2'b11; end
compare("SSUB_ZERO_ZERO");
// min_neg - pos = overflow: 1000_0000 - 0000_0001
@(negedge CLK) begin OPA={1'b1,{width-1{1'b0}}}; OPB=1; CMD=4'b1100; inp_valid=2'b11; end
compare("SSUB_MINNEG_ONE_OFLOW");
// equal values: G=0 E=1 L=0
@(negedge CLK) begin OPA=4; OPB=4; CMD=4'b1100; inp_valid=2'b11; end
compare("SSUB_EQUAL");

// --- SIGNED operations inp_valid ERR ---
$display("=== SIGNED INP_VALID ERR ===");
@(negedge CLK) begin OPA=5; OPB=3; CMD=4'b1011; inp_valid=2'b00; end
compare("SADD_INV00_ERR");
@(negedge CLK) begin OPA=5; OPB=3; CMD=4'b1011; inp_valid=2'b01; end
compare("SADD_INV01_ERR");
@(negedge CLK) begin OPA=5; OPB=3; CMD=4'b1011; inp_valid=2'b10; end
compare("SADD_INV10_ERR");
@(negedge CLK) begin OPA=5; OPB=3; CMD=4'b1100; inp_valid=2'b00; end
compare("SSUB_INV00_ERR");
@(negedge CLK) begin OPA=5; OPB=3; CMD=4'b1100; inp_valid=2'b01; end
compare("SSUB_INV01_ERR");
@(negedge CLK) begin OPA=5; OPB=3; CMD=4'b1100; inp_valid=2'b10; end
compare("SSUB_INV10_ERR");

// --- MUL inp_valid ERR ---
$display("=== MUL INP_VALID ERR ===");
@(negedge CLK) begin OPA=2; OPB=3; CMD=4'b1001; inp_valid=2'b00; end
compare_mul("MUL_INV00_ERR");
@(negedge CLK) begin OPA=2; OPB=3; CMD=4'b1001; inp_valid=2'b01; end
compare_mul("MUL_INV01_ERR");
@(negedge CLK) begin OPA=2; OPB=3; CMD=4'b1001; inp_valid=2'b10; end
compare_mul("MUL_INV10_ERR");
@(negedge CLK) begin OPA=2; OPB=3; CMD=4'b1010; inp_valid=2'b00; end
compare_mul("MULSHL_INV00_ERR");
@(negedge CLK) begin OPA=2; OPB=3; CMD=4'b1010; inp_valid=2'b01; end
compare_mul("MULSHL_INV01_ERR");
@(negedge CLK) begin OPA=2; OPB=3; CMD=4'b1010; inp_valid=2'b10; end
compare_mul("MULSHL_INV10_ERR");

// --- AND/OR/XOR boundary ---
$display("=== LOGIC BOUNDARY ===");
MODE=0;
// all zeros
@(negedge CLK) begin OPA=0; OPB=0; CMD=4'b0000; inp_valid=2'b11; end
compare("AND_ZERO_ZERO");
@(negedge CLK) begin OPA=0; OPB=0; CMD=4'b0010; inp_valid=2'b11; end
compare("OR_ZERO_ZERO");
@(negedge CLK) begin OPA=0; OPB=0; CMD=4'b0100; inp_valid=2'b11; end
compare("XOR_ZERO_ZERO");
// all ones
@(negedge CLK) begin OPA={width{1'b1}}; OPB={width{1'b1}}; CMD=4'b0000; inp_valid=2'b11; end
compare("AND_MAX_MAX");
@(negedge CLK) begin OPA={width{1'b1}}; OPB={width{1'b1}}; CMD=4'b0010; inp_valid=2'b11; end
compare("OR_MAX_MAX");
@(negedge CLK) begin OPA={width{1'b1}}; OPB={width{1'b1}}; CMD=4'b0100; inp_valid=2'b11; end
compare("XOR_MAX_MAX_ZERO");
// A with 0
@(negedge CLK) begin OPA={width{1'b1}}; OPB=0; CMD=4'b0000; inp_valid=2'b11; end
compare("AND_MAX_ZERO");
@(negedge CLK) begin OPA={width{1'b1}}; OPB=0; CMD=4'b0010; inp_valid=2'b11; end
compare("OR_MAX_ZERO");
@(negedge CLK) begin OPA={width{1'b1}}; OPB=0; CMD=4'b0100; inp_valid=2'b11; end
compare("XOR_MAX_ZERO");

// --- NOT boundary ---
$display("=== NOT BOUNDARY ===");
// NOT 0 = max
@(negedge CLK) begin OPA=0; OPB=0; CMD=4'b0110; inp_valid=2'b11; end
compare("NOT_A_ZERO");
@(negedge CLK) begin OPA=0; OPB=0; CMD=4'b0111; inp_valid=2'b11; end
compare("NOT_B_ZERO");
// NOT max = 0
@(negedge CLK) begin OPA={width{1'b1}}; OPB=0; CMD=4'b0110; inp_valid=2'b11; end
compare("NOT_A_MAX");
@(negedge CLK) begin OPA=0; OPB={width{1'b1}}; CMD=4'b0111; inp_valid=2'b11; end
compare("NOT_B_MAX");

// --- SHR/SHL boundary ---
$display("=== SHIFT BOUNDARY ===");
// SHR 0 = 0
@(negedge CLK) begin OPA=0; OPB=0; CMD=4'b1000; inp_valid=2'b11; end
compare("SHR_A_ZERO");
// SHL 0 = 0
@(negedge CLK) begin OPA=0; OPB=0; CMD=4'b1001; inp_valid=2'b11; end
compare("SHL_A_ZERO");
// SHR 1 = 0 (LSB drops off)
@(negedge CLK) begin OPA=1; OPB=0; CMD=4'b1000; inp_valid=2'b11; end
compare("SHR_A_ONE");
// SHL max = max-1 shifted (MSB drops off)
@(negedge CLK) begin OPA={width{1'b1}}; OPB=0; CMD=4'b1001; inp_valid=2'b11; end
compare("SHL_A_MAX");
// same for B
@(negedge CLK) begin OPA=0; OPB=0; CMD=4'b1010; inp_valid=2'b11; end
compare("SHR_B_ZERO");
@(negedge CLK) begin OPA=0; OPB=0; CMD=4'b1011; inp_valid=2'b11; end
compare("SHL_B_ZERO");
@(negedge CLK) begin OPA=0; OPB=1; CMD=4'b1010; inp_valid=2'b11; end
compare("SHR_B_ONE");
@(negedge CLK) begin OPA=0; OPB={width{1'b1}}; CMD=4'b1011; inp_valid=2'b11; end
compare("SHL_B_MAX");

// --- ROL boundary ---
$display("=== ROL ROR BOUNDARY ===");
MODE=0;
// ROL by 0 = same value
@(negedge CLK) begin OPA=4'b1010; OPB=0; CMD=4'b1100; inp_valid=2'b11; end
compare("ROL_BY_0_SAME");
// ROR by 0 = same value
@(negedge CLK) begin OPA=4'b1010; OPB=0; CMD=4'b1101; inp_valid=2'b11; end
compare("ROR_BY_0_SAME");
// ROL all zeros = 0
@(negedge CLK) begin OPA=0; OPB=3; CMD=4'b1100; inp_valid=2'b11; end
compare("ROL_ZERO_OPA");
// ROR all zeros = 0
@(negedge CLK) begin OPA=0; OPB=3; CMD=4'b1101; inp_valid=2'b11; end
compare("ROR_ZERO_OPA");
// ROL all ones = all ones
@(negedge CLK) begin OPA={width{1'b1}}; OPB=3; CMD=4'b1100; inp_valid=2'b11; end
compare("ROL_MAX_OPA");
// ROR all ones = all ones
@(negedge CLK) begin OPA={width{1'b1}}; OPB=3; CMD=4'b1101; inp_valid=2'b11; end
compare("ROR_MAX_OPA");
// ROL/ROR by width = same value (full rotation)
@(negedge CLK) begin OPA=4'b1010; OPB=width; CMD=4'b1100; inp_valid=2'b11; end
compare("ROL_BY_WIDTH_SAME");
@(negedge CLK) begin OPA=4'b1010; OPB=width; CMD=4'b1101; inp_valid=2'b11; end
compare("ROR_BY_WIDTH_SAME");

// --- ROL ROR all OPB values 1-7 ---
$display("=== ROL ROR ALL SHIFTS ===");
@(negedge CLK) begin OPA=4'b1011; OPB=1; CMD=4'b1100; inp_valid=2'b11; end
compare("ROL_1011_BY_1");
@(negedge CLK) begin OPA=4'b1011; OPB=2; CMD=4'b1100; inp_valid=2'b11; end
compare("ROL_1011_BY_2");
@(negedge CLK) begin OPA=4'b1011; OPB=5; CMD=4'b1100; inp_valid=2'b11; end
compare("ROL_1011_BY_5");
@(negedge CLK) begin OPA=4'b1011; OPB=6; CMD=4'b1100; inp_valid=2'b11; end
compare("ROL_1011_BY_6");
@(negedge CLK) begin OPA=4'b1011; OPB=1; CMD=4'b1101; inp_valid=2'b11; end
compare("ROR_1011_BY_1");
@(negedge CLK) begin OPA=4'b1011; OPB=5; CMD=4'b1101; inp_valid=2'b11; end
compare("ROR_1011_BY_5");
@(negedge CLK) begin OPA=4'b1011; OPB=6; CMD=4'b1101; inp_valid=2'b11; end
compare("ROR_1011_BY_6");

// --- NAND NOR XNOR boundary ---
$display("=== NAND NOR XNOR BOUNDARY ===");
@(negedge CLK) begin OPA=0; OPB=0; CMD=4'b0001; inp_valid=2'b11; end
compare("NAND_ZERO_ZERO");
@(negedge CLK) begin OPA={width{1'b1}}; OPB={width{1'b1}}; CMD=4'b0001; inp_valid=2'b11; end
compare("NAND_MAX_MAX");
@(negedge CLK) begin OPA=0; OPB=0; CMD=4'b0011; inp_valid=2'b11; end
compare("NOR_ZERO_ZERO");
@(negedge CLK) begin OPA={width{1'b1}}; OPB={width{1'b1}}; CMD=4'b0011; inp_valid=2'b11; end
compare("NOR_MAX_MAX");
@(negedge CLK) begin OPA=0; OPB=0; CMD=4'b0101; inp_valid=2'b11; end
compare("XNOR_ZERO_ZERO");
@(negedge CLK) begin OPA={width{1'b1}}; OPB={width{1'b1}}; CMD=4'b0101; inp_valid=2'b11; end
compare("XNOR_MAX_MAX");

// --- MODE switch mid-simulation ---
$display("=== MODE SWITCH ===");
@(negedge CLK) begin OPA=5; OPB=3; CMD=4'b0000; inp_valid=2'b11; MODE=1; end
compare("MODE_ARITH_ADD");
@(negedge CLK) begin OPA=5; OPB=3; CMD=4'b0000; inp_valid=2'b11; MODE=0; end
compare("MODE_LOGIC_AND_SAME_CMD");
@(negedge CLK) begin OPA=5; OPB=3; CMD=4'b0000; inp_valid=2'b11; MODE=1; end
compare("MODE_BACK_TO_ARITH");

// --- alternating CIN values ---
$display("=== CIN TOGGLE ===");
MODE=1;
@(negedge CLK) begin OPA=5; OPB=3; CIN=0; CMD=4'b0010; inp_valid=2'b11; end
compare("ADD_CIN0");
@(negedge CLK) begin OPA=5; OPB=3; CIN=1; CMD=4'b0010; inp_valid=2'b11; end
compare("ADD_CIN1");
@(negedge CLK) begin OPA=5; OPB=3; CIN=0; CMD=4'b0011; inp_valid=2'b11; end
compare("SUB_CIN0");
@(negedge CLK) begin OPA=5; OPB=3; CIN=1; CMD=4'b0011; inp_valid=2'b11; end
compare("SUB_CIN1");

// =====================================================
// SIGNED ADD OVERFLOW CASES
// =====================================================
$display("=== SIGNED ADD OVERFLOW ===");

// Positive + Positive = Negative (overflow)
// max_pos + max_pos : 0111...1 + 0111...1
@(negedge CLK) begin
    OPA = {1'b0, {(width-1){1'b1}}};   // +127 (for 8-bit)
    OPB = {1'b0, {(width-1){1'b1}}};   // +127
    CMD = 4'b1011;
    inp_valid = 2'b11;
    MODE = 1;
end
compare("SADD_POSPOS_OFLOW");

// Positive + 1 from max_pos ? overflow
// 0111...1 + 0000...1
@(negedge CLK) begin
    OPA = {1'b0, {(width-1){1'b1}}};   // +127
    OPB = {{(width-1){1'b0}}, 1'b1};   // +1
    CMD = 4'b1011;
    inp_valid = 2'b11;
end
compare("SADD_MAXPOS_ONE_OFLOW");

// Negative + Negative = Positive (overflow)
// min_neg + min_neg : 1000...0 + 1000...0
@(negedge CLK) begin
    OPA = {1'b1, {(width-1){1'b0}}};   // -128 (for 8-bit)
    OPB = {1'b1, {(width-1){1'b0}}};   // -128
    CMD = 4'b1011;
    inp_valid = 2'b11;
end
compare("SADD_NEGNEG_OFLOW");

// min_neg + (-1)
// 1000...0 + 1111...1
@(negedge CLK) begin
    OPA = {1'b1, {(width-1){1'b0}}};   // -128
    OPB = {width{1'b1}};               // -1
    CMD = 4'b1011;
    inp_valid = 2'b11;
end
compare("SADD_MINNEG_NEG1_OFLOW");

// No overflow boundary: max_pos + 0 = max_pos (no overflow)
@(negedge CLK) begin
    OPA = {1'b0, {(width-1){1'b1}}};   // +127
    OPB = {width{1'b0}};               // 0
    CMD = 4'b1011;
    inp_valid = 2'b11;
end
compare("SADD_MAXPOS_ZERO_NOOFLOW");

// No overflow boundary: min_neg + 0 = min_neg (no overflow)
@(negedge CLK) begin
    OPA = {1'b1, {(width-1){1'b0}}};   // -128
    OPB = {width{1'b0}};               // 0
    CMD = 4'b1011;
    inp_valid = 2'b11;
end
compare("SADD_MINNEG_ZERO_NOOFLOW");

// =====================================================
// SIGNED SUB OVERFLOW CASES
// =====================================================
$display("=== SIGNED SUB OVERFLOW ===");

// Positive - Negative = overflow
// max_pos - min_neg : 0111...1 - 1000...0
@(negedge CLK) begin
    OPA = {1'b0, {(width-1){1'b1}}};   // +127
    OPB = {1'b1, {(width-1){1'b0}}};   // -128
    CMD = 4'b1100;
    inp_valid = 2'b11;
    MODE = 1;
end
compare("SSUB_MAXPOS_MINNEG_OFLOW");

// max_pos - (-1) ? overflow
// 0111...1 - 1111...1
@(negedge CLK) begin
    OPA = {1'b0, {(width-1){1'b1}}};   // +127
    OPB = {width{1'b1}};               // -1
    CMD = 4'b1100;
    inp_valid = 2'b11;
end
compare("SSUB_MAXPOS_NEG1_OFLOW");

// Negative - Positive = overflow
// min_neg - 1 : 1000...0 - 0000...1
@(negedge CLK) begin
    OPA = {1'b1, {(width-1){1'b0}}};   // -128
    OPB = {{(width-1){1'b0}}, 1'b1};   // +1
    CMD = 4'b1100;
    inp_valid = 2'b11;
end
compare("SSUB_MINNEG_ONE_OFLOW");

// min_neg - max_pos : 1000...0 - 0111...1
@(negedge CLK) begin
    OPA = {1'b1, {(width-1){1'b0}}};   // -128
    OPB = {1'b0, {(width-1){1'b1}}};   // +127
    CMD = 4'b1100;
    inp_valid = 2'b11;
end
compare("SSUB_MINNEG_MAXPOS_OFLOW");

// No overflow boundary: max_pos - 0 = max_pos (no overflow)
@(negedge CLK) begin
    OPA = {1'b0, {(width-1){1'b1}}};   // +127
    OPB = {width{1'b0}};               // 0
    CMD = 4'b1100;
    inp_valid = 2'b11;
end
compare("SSUB_MAXPOS_ZERO_NOOFLOW");

// No overflow: min_neg - 0 = min_neg (no overflow)
@(negedge CLK) begin
    OPA = {1'b1, {(width-1){1'b0}}};   // -128
    OPB = {width{1'b0}};               // 0
    CMD = 4'b1100;
    inp_valid = 2'b11;
end
compare("SSUB_MINNEG_ZERO_NOOFLOW");

// No overflow: 0 - 0 = 0
@(negedge CLK) begin
    OPA = {width{1'b0}};
    OPB = {width{1'b0}};
    CMD = 4'b1100;
    inp_valid = 2'b11;
end
compare("SSUB_ZERO_ZERO_NOOFLOW");



    #80;
    $finish;
  end
endmodule   */


//`timescale 1ns / 1ps
module tb_alu_verify;

  parameter width     = 8;
  parameter cmd_width = 4;
  parameter out_width = 2*width;

  reg [width-1:0] OPA, OPB;
  reg CLK, RST, CE, MODE, CIN;
  reg [1:0] inp_valid;
  reg [cmd_width-1:0] CMD;

  wire [out_width-1:0] REF_RES, DUT_RES;
  wire REF_COUT, REF_OFLOW, REF_G, REF_E, REF_L, REF_ERR;
  wire DUT_COUT, DUT_OFLOW, DUT_G, DUT_E, DUT_L, DUT_ERR;

  alu_reference_model #(width, cmd_width, out_width) ref_model (
    .OPA(OPA), .OPB(OPB), .clk(CLK), .rst(RST), .CE(CE),
    .MODE(MODE), .CIN(CIN), .inp_valid(inp_valid), .CMD(CMD),
    .RES(REF_RES), .COUT(REF_COUT), .OFLOW(REF_OFLOW),
    .G(REF_G), .E(REF_E), .L(REF_L), .ERR(REF_ERR)
  );

  alu_design #(width, width, cmd_width) dut (
    .OPA(OPA), .OPB(OPB), .CLK(CLK), .RST(RST), .CE(CE),
    .MODE(MODE), .CIN(CIN), .INP_VALID(inp_valid), .CMD(CMD),
    .RES(DUT_RES), .COUT(DUT_COUT), .OFLOW(DUT_OFLOW),
    .G(DUT_G), .E(DUT_E), .L(DUT_L), .ERR(DUT_ERR)
  );
/*
Eight_bit_ALU_rtl_design #(
    .width(width),
    .cmd_width(cmd_width),
    .out_width(2*width)
) dut (
    .OPA(OPA), 
    .OPB(OPB), 
    .CLK(CLK), 
    .RST(RST), 
    .CE(CE),
    .MODE(MODE), 
    .CIN(CIN), 
    .inp_valid(inp_valid),   // FIX: case-sensitive
    .CMD(CMD),
    .RES(DUT_RES), 
    .COUT(DUT_COUT), 
    .OFLOW(DUT_OFLOW),
    .G(DUT_G), 
    .E(DUT_E), 
    .L(DUT_L), 
    .ERR(DUT_ERR)
);*/
  initial CLK = 0;
  always #5 CLK = ~CLK;

  task compare;
    input [127:0] test_name;
    begin
      @(posedge CLK); #1;
      $display("--- %0s ---", test_name);
      $display("  RES   : DUT=%0d REF=%0d %0s", DUT_RES,   REF_RES,   (DUT_RES===REF_RES)     ? "PASS":"FAIL");
      $display("  COUT  : DUT=%0d REF=%0d %0s", DUT_COUT,  REF_COUT,  (DUT_COUT===REF_COUT)   ? "PASS":"FAIL");
      $display("  OFLOW : DUT=%0d REF=%0d %0s", DUT_OFLOW, REF_OFLOW, (DUT_OFLOW===REF_OFLOW) ? "PASS":"FAIL");
      $display("  G     : DUT=%0d REF=%0d %0s", DUT_G,     REF_G,     (DUT_G===REF_G)         ? "PASS":"FAIL");
      $display("  E     : DUT=%0d REF=%0d %0s", DUT_E,     REF_E,     (DUT_E===REF_E)         ? "PASS":"FAIL");
      $display("  L     : DUT=%0d REF=%0d %0s", DUT_L,     REF_L,     (DUT_L===REF_L)         ? "PASS":"FAIL");
      $display("  ERR   : DUT=%0d REF=%0d %0s", DUT_ERR,   REF_ERR,   (DUT_ERR===REF_ERR)     ? "PASS":"FAIL");
      $display("  OPA   : DUT=%0d REF=%0d %0s", OPA,   OPB,   (OPA===OPA)&&(OPB==OPB)     ? "PASS":"FAIL");
    end
  endtask

  task compare_mul;
    input [127:0] test_name;
    begin
      @(posedge CLK); @(posedge CLK); @(posedge CLK); #1;
      $display("--- %0s ---", test_name);
      $display("  RES   : DUT=%0d REF=%0d %0s", DUT_RES,   REF_RES,   (DUT_RES===REF_RES)     ? "PASS":"FAIL");
      $display("  COUT  : DUT=%0d REF=%0d %0s", DUT_COUT,  REF_COUT,  (DUT_COUT===REF_COUT)   ? "PASS":"FAIL");
      $display("  OFLOW : DUT=%0d REF=%0d %0s", DUT_OFLOW, REF_OFLOW, (DUT_OFLOW===REF_OFLOW) ? "PASS":"FAIL");
      $display("  G     : DUT=%0d REF=%0d %0s", DUT_G,     REF_G,     (DUT_G===REF_G)         ? "PASS":"FAIL");
      $display("  E     : DUT=%0d REF=%0d %0s", DUT_E,     REF_E,     (DUT_E===REF_E)         ? "PASS":"FAIL");
      $display("  L     : DUT=%0d REF=%0d %0s", DUT_L,     REF_L,     (DUT_L===REF_L)         ? "PASS":"FAIL");
      $display("  ERR   : DUT=%0d REF=%0d %0s", DUT_ERR,   REF_ERR,   (DUT_ERR===REF_ERR)     ? "PASS":"FAIL");
    end
  endtask

  initial begin
    CE=1; RST=1; MODE=0; CIN=0;
    OPA=0; OPB=0; CMD=0; inp_valid=0;
    #10; RST=0;

    // =====================================================
    // TC1  CLK toggle (just observed in waveform)
    // =====================================================
    $display("=== TC1: CLK toggle observed in waveform ===");

    // =====================================================
    // TC2  RST async assert/deassert during idle
    // =====================================================
    $display("=== TC2: RST async assert deassert ===");
    @(negedge CLK) begin OPA=5; OPB=3; CMD=4'b0000; inp_valid=2'b11; MODE=1; end compare("rst_async");
    #3; RST=1;   // assert RST mid-cycle asynchronously
    compare("rst_async");
    @(posedge CLK); #1;RST=0;
    $display("  RST deassert: DUT_RES=%0d DUT_ERR=%0d (expect 0)", DUT_RES, DUT_ERR);

    // =====================================================
    // TC3  RST during operation
    // =====================================================
    $display("=== TC3: RST during operation ===");
    @(negedge CLK) begin OPA=7; OPB=2; CMD=4'b0000; inp_valid=2'b11; MODE=1; end compare("rst_during_opr");
    #3; RST=1;  // assert RST mid-operation 
compare("rst_during_opr");
     @(negedge CLK)
    $display("  RST mid-op: DUT_RES=%0d (expect 0)", DUT_RES);
    RST=0;

    // =====================================================
    // TC4  CE enable
    // =====================================================
    $display("=== TC4: CE enable ===");
    @(negedge CLK) begin CE=1; OPA=5; OPB=3; CMD=4'b0000; inp_valid=2'b11; MODE=1; end
    compare("CE_ENABLE_ADD");

    // CE=0  output should not update
    $display("=== TC4b: CE=0 no update ===");
    @(negedge CLK) begin CE=0; OPA=7; OPB=7; CMD=4'b0000; inp_valid=2'b11; MODE=1; end compare("ce=0");
    @(negedge CLK); 
    $display("  CE=0: DUT_RES=%0d (expect same as before, no update)", DUT_RES);
    CE=1;compare("ce=1");

    // =====================================================
    // ARITHMETIC MODE
    // =====================================================
    $display("=== ARITHMETIC MODE ===");
    MODE=1;#1;

    // TC5  ADD
    @(negedge CLK) begin OPA=5; OPB=3; CMD=4'b0000; inp_valid=2'b11; end
    compare("TC5_ADD");

    // TC5  ADD boundary: 255+1=0 carry out (width=4: 15+1=0 COUT=1)
    @(negedge CLK)  begin OPA={width{1'b1}}; OPB=1; CMD=4'b0000; inp_valid=2'b11; end
    compare("TC53_ADD_MAX_OVERFLOW");

    // TC6  SUB
    @(negedge CLK)  begin OPA=5; OPB=4; CMD=4'b0001; inp_valid=2'b11; end
    compare("TC6_SUB");

    // TC54  SUB boundary: 0-1 = underflow
    @(negedge CLK)  begin OPA=0; OPB=1; CMD=4'b0001; inp_valid=2'b11; end
    compare("TC54_SUB_ZERO_MINUS_ONE");

    // TC36  SUB smaller from larger ? OFLOW
    @(negedge CLK) begin OPA=3; OPB=7; CMD=4'b0001; inp_valid=2'b11; end
    compare("TC36_SUB_OFLOW");

    // TC7  ADD_CIN
    @(negedge CLK) begin OPA=5; OPB=4; CIN=1; CMD=4'b0010; inp_valid=2'b11; end
    compare("TC7_ADD_CIN");

    // TC8  SUB_CIN
    @(negedge CLK)  begin OPA=5; OPB=3; CIN=1; CMD=4'b0011; inp_valid=2'b11; end
    compare("TC8_SUB_CIN");

    // TC9  INC_A
    @(negedge CLK) begin OPA=5; OPB=0; CIN=0; CMD=4'b0100; inp_valid=2'b01; end
    compare("TC9_INC_A_01");
    @(negedge CLK) begin OPA=5; OPB=0; CMD=4'b0100; inp_valid=2'b11; end
    compare("TC9_INC_A_11");

    // TC33  INC_A at max value wraps to 0
    @(negedge CLK) begin OPA={width{1'b1}}; OPB=0; CMD=4'b0100; inp_valid=2'b01; end
    compare("TC33_INC_A_MAX_WRAP");

    // TC11  DEC_A
    @(negedge CLK) begin OPA=5; OPB=0; CMD=4'b0101; inp_valid=2'b01; end
    compare("TC11_DEC_A_01");
    @(negedge CLK) begin OPA=5; OPB=0; CMD=4'b0101; inp_valid=2'b11; end
    compare("TC11_DEC_A_11");

    // TC34  DEC_A at 0 wraps to max
    @(negedge CLK) begin OPA=0; OPB=0; CMD=4'b0101; inp_valid=2'b01; end
    compare("TC34_DEC_A_ZERO_WRAP");

    // TC10  INC_B
    @(negedge CLK) begin OPA=0; OPB=3; CMD=4'b0110; inp_valid=2'b10; end
    compare("TC10_INC_B_10");
    @(negedge CLK) begin OPA=0; OPB=3; CMD=4'b0110; inp_valid=2'b11; end
    compare("TC10_INC_B_11");

    // TC33  INC_B at max wraps to 0
    @(negedge CLK) begin OPA=0; OPB={width{1'b1}}; CMD=4'b0110; inp_valid=2'b10; end
    compare("TC33_INC_B_MAX_WRAP");

    // TC12  DEC_B
    @(negedge CLK) begin OPA=0; OPB=3; CMD=4'b0111; inp_valid=2'b10; end
    compare("TC12_DEC_B_10");
    @(negedge CLK) begin OPA=0; OPB=3; CMD=4'b0111; inp_valid=2'b11; end
    compare("TC12_DEC_B_11");

    // TC34  DEC_B at 0 wraps to max
    @(negedge CLK) begin OPA=0; OPB=0; CMD=4'b0111; inp_valid=2'b10; end
    compare("TC34_DEC_B_ZERO_WRAP");

    // TC14  CMP
    @(negedge CLK) begin OPA=5; OPB=5; CMD=4'b1000; inp_valid=2'b11; end
    compare("TC14_CMP_EQUAL");
    @(negedge CLK) begin OPA=7; OPB=3; CMD=4'b1000; inp_valid=2'b11; end
    compare("TC14_CMP_GREATER");
    @(negedge CLK) begin OPA=3; OPB=7; CMD=4'b1000; inp_valid=2'b11; end
    compare("TC14_CMP_LESS");

    // TC13  MUL (OPA+1)*(OPB+1)
    @(negedge CLK) begin OPA=2; OPB=3; CMD=4'b1001; inp_valid=2'b11; end
    compare_mul("TC13_MUL");

    // TC15  MUL_SHL (OPA<<1)*OPB
    @(negedge CLK) begin OPA=2; OPB=3; CMD=4'b1010; inp_valid=2'b11; end
    compare_mul("TC15_MUL_SHL");

    // TC16  SIGNED_ADD no overflow
    @(negedge CLK) begin OPA=5; OPB=3; CMD=4'b1011; inp_valid=2'b11; end
    compare("TC16_SIGNED_ADD");

    // TC37  SIGNED_ADD overflow (both positive, result overflows signed)
    @(negedge CLK) begin OPA={1'b0,{width-1{1'b1}}}; OPB=1; CMD=4'b1011; inp_valid=2'b11; end
    compare("TC37_SIGNED_ADD_OFLOW");

    // TC17  SIGNED_SUB no overflow
    @(negedge CLK) begin OPA=7; OPB=3; CMD=4'b1100; inp_valid=2'b11; end
    compare("TC17_SIGNED_SUB");

    // TC42  default CMD (13,14,15 ? ERR)
    @(negedge CLK) begin OPA=1; OPB=1; CMD=4'b1101; inp_valid=2'b11; end
    compare("TC42_ARITH_CMD13_ERR");
    @(negedge CLK) begin OPA=1; OPB=1; CMD=4'b1110; inp_valid=2'b11; end
    compare("TC42_ARITH_CMD14_ERR");
    @(negedge CLK) begin OPA=1; OPB=1; CMD=4'b1111; inp_valid=2'b11; end
    compare("TC42_ARITH_CMD15_ERR");

    // TC44  inp_valid ERR for CMD 0,1,2,3,8,9,10,11,12 when not 2'b11
    @(negedge CLK) begin OPA=5; OPB=3; CMD=4'b0000; inp_valid=2'b00; end
    compare("TC44_ADD_INV00_ERR");
    @(negedge CLK) begin OPA=5; OPB=3; CMD=4'b0000; inp_valid=2'b01; end
    compare("TC44_ADD_INV01_ERR");
    @(negedge CLK) begin OPA=5; OPB=3; CMD=4'b0000; inp_valid=2'b10; end
    compare("TC44_ADD_INV10_ERR");
    @(negedge CLK) begin OPA=5; OPB=3; CMD=4'b0001; inp_valid=2'b00; end
    compare("TC44_SUB_INV00_ERR");
    @(negedge CLK) begin OPA=5; OPB=3; CMD=4'b1000; inp_valid=2'b00; end
    compare("TC44_CMP_INV00_ERR");
    @(negedge CLK) begin OPA=5; OPB=3; CMD=4'b1000; inp_valid=2'b01; end
    compare("TC44_CMP_INV01_ERR");
    @(negedge CLK) begin OPA=5; OPB=3; CMD=4'b1000; inp_valid=2'b10; end
    compare("TC44_CMP_INV10_ERR");

    // TC45  inp_valid ERR for CMD 4,5,6,7 when inp_valid=2'b00
    @(negedge CLK) begin OPA=5; OPB=0; CMD=4'b0100; inp_valid=2'b00; end
    compare("TC45_INC_A_INV00_ERR");
    @(negedge CLK) begin OPA=5; OPB=0; CMD=4'b0101; inp_valid=2'b00; end
    compare("TC45_DEC_A_INV00_ERR");
    @(negedge CLK) begin OPA=0; OPB=3; CMD=4'b0110; inp_valid=2'b00; end
    compare("TC45_INC_B_INV00_ERR");
    @(negedge CLK) begin OPA=0; OPB=3; CMD=4'b0111; inp_valid=2'b00; end
    compare("TC45_DEC_B_INV00_ERR");

    // TC35  OPA max, OPB not given (inp_valid=01)
    @(negedge CLK) begin OPA={width{1'b1}}; OPB=0; CMD=4'b0100; inp_valid=2'b01; end
    compare("TC35_OPA_MAX_INC_NO_OPB");

    // TC48  MUL: inp_valid not 11 at 2nd posedge ? ERR
    // Apply MUL then change inp_valid at 2nd posedge
    @(negedge CLK) begin OPA=2; OPB=3; CMD=4'b1001; inp_valid=2'b11; end
    @(posedge CLK); // 1st posedge
    @(negedge CLK) begin inp_valid=2'b00; end // change at 2nd posedge
    @(posedge CLK); @(posedge CLK);
compare_mul ("inp_invalid");
    $display("--- TC48_MUL_INV_2ND_POSEDGE ---");
    $display("  ERR: DUT=%0d REF=%0d %0s", DUT_ERR, REF_ERR, (DUT_ERR===REF_ERR)?"PASS":"FAIL");

    @(negedge CLK) begin OPA=2; OPB=3; CMD=4'b1001; inp_valid=2'b11; end
    @(posedge CLK);
    @(negedge CLK) begin inp_valid=2'b01; end
    @(posedge CLK); @(posedge CLK);
	compare_mul ("inp_invalid");
    $display("--- TC48_MUL_INV01_2ND_POSEDGE ---");
    $display("  ERR: DUT=%0d REF=%0d %0s", DUT_ERR, REF_ERR, (DUT_ERR===REF_ERR)?"PASS":"FAIL");

    // TC49  MUL_SHL: inp_valid not 11 at 2nd posedge ? ERR
    @(negedge CLK) begin OPA=2; OPB=3; CMD=4'b1010; inp_valid=2'b11; end
    @(posedge CLK);
    @(negedge CLK) begin inp_valid=2'b10; end
    @(posedge CLK); @(posedge CLK); 
    $display("--- TC49_MULSHL_INV_2ND_POSEDGE ---");
    $display("  ERR: DUT=%0d REF=%0d %0s", DUT_ERR, REF_ERR, (DUT_ERR===REF_ERR)?"PASS":"FAIL");

    // TC50  MUL: CMD changes at 2nd posedge ? output updated for new CMD
    @(negedge CLK) begin OPA=2; OPB=3; CMD=4'b1001; inp_valid=2'b11; end
    @(posedge CLK);
    @(negedge CLK) begin CMD=4'b0000; end // change to ADD at 2nd posedge
    @(posedge CLK); @(posedge CLK); 
    $display("--- TC50_MUL_CMD_CHANGE_2ND_POSEDGE ---");
    $display("  RES: DUT=%0d REF=%0d %0s", DUT_RES, REF_RES, (DUT_RES===REF_RES)?"PASS":"FAIL");

    // TC51  MUL_SHL: MODE changes at 2nd posedge
    @(negedge CLK) begin OPA=2; OPB=3; CMD=4'b1010; inp_valid=2'b11; MODE=1; end
    @(posedge CLK);
    @(negedge CLK) begin MODE=0; end // switch to logical mode
    @(posedge CLK); @(posedge CLK);
    $display("--- TC51_MULSHL_MODE_CHANGE_2ND_POSEDGE ---");
    $display("  RES: DUT=%0d REF=%0d %0s", DUT_RES, REF_RES, (DUT_RES===REF_RES)?"PASS":"FAIL");
    MODE=1;

    // TC52  MUL: input changes at 2nd posedge same CMD ? output for original input
    @(negedge CLK) begin OPA=2; OPB=3; CMD=4'b1001; inp_valid=2'b11; end
    @(posedge CLK);
    @(negedge CLK) begin OPA=5; OPB=5; end // change inputs same CMD
    @(posedge CLK); @(posedge CLK); 
    $display("--- TC52_MUL_INPUT_CHANGE_2ND_POSEDGE ---");
    $display("  RES: DUT=%0d REF=%0d %0s (expect result for OPA=2 OPB=3)", DUT_RES, REF_RES, (DUT_RES===REF_RES)?"PASS":"FAIL");

    // =====================================================
    // LOGICAL MODE
    // =====================================================
    $display("=== LOGICAL MODE ===");
    MODE=0;

    @(negedge CLK) begin OPA=0; OPB=0; CMD=4'b0000; inp_valid=2'b00; end
    compare("LOGIC_INP_VALID_00_ERR");

    // TC18  AND
    @(negedge CLK) begin OPA=4'b1010; OPB=4'b1100; CMD=4'b0000; inp_valid=2'b11; end
    compare("TC18_AND");

    // TC19  NAND
    @(negedge CLK) begin OPA=4'b1010; OPB=4'b1100; CMD=4'b0001; inp_valid=2'b11; end
    compare("TC19_NAND");

    // TC20  OR
    @(negedge CLK) begin OPA=4'b1010; OPB=4'b1100; CMD=4'b0010; inp_valid=2'b11; end
    compare("TC20_OR");

    // TC21  NOR
    @(negedge CLK) begin OPA=4'b1010; OPB=4'b1100; CMD=4'b0011; inp_valid=2'b11; end
    compare("TC21_NOR");

    // TC22  XOR
    @(negedge CLK) begin OPA=4'b1010; OPB=4'b1100; CMD=4'b0100; inp_valid=2'b11; end
    compare("TC22_XOR");

    // TC23  XNOR
    @(negedge CLK) begin OPA=4'b1010; OPB=4'b1100; CMD=4'b0101; inp_valid=2'b11; end
    compare("TC23_XNOR");

    // TC24  NOT_A
    @(negedge CLK) begin OPA=4'b1010; OPB=0; CMD=4'b0110; inp_valid=2'b01; end
    compare("TC24_NOT_A_01");
    @(negedge CLK) begin OPA=4'b1010; OPB=0; CMD=4'b0110; inp_valid=2'b11; end
    compare("TC24_NOT_A_11");

    // TC25  NOT_B
    @(negedge CLK) begin OPA=0; OPB=4'b1100; CMD=4'b0111; inp_valid=2'b10; end
    compare("TC25_NOT_B_10");
    @(negedge CLK) begin OPA=0; OPB=4'b1100; CMD=4'b0111; inp_valid=2'b11; end
    compare("TC25_NOT_B_11");

    // TC26  SHR_A
    @(negedge CLK) begin OPA=4'b1010; OPB=0; CMD=4'b1000; inp_valid=2'b01; end
    compare("TC26_SHR_A_01");
    @(negedge CLK) begin OPA=4'b1010; OPB=0; CMD=4'b1000; inp_valid=2'b11; end
    compare("TC26_SHR_A_11");

    // TC38  SHR_A at max value ? MSB becomes 0
    @(negedge CLK) begin OPA={width{1'b1}}; OPB=0; CMD=4'b1000; inp_valid=2'b11; end
    compare("TC38_SHR_A_MAX");

    // TC27  SHL_A
    @(negedge CLK) begin OPA=4'b0101; OPB=0; CMD=4'b1001; inp_valid=2'b01; end
    compare("TC27_SHL_A_01");
    @(negedge CLK) begin OPA=4'b0101; OPB=0; CMD=4'b1001; inp_valid=2'b11; end
    compare("TC27_SHL_A_11");

    // TC39  SHL_A at 0 ? shifts in 0, result still 0... use 1 to see shift
    @(negedge CLK) begin OPA={width{1'b0}}; OPB=0; CMD=4'b1001; inp_valid=2'b11; end
    compare("TC39_SHL_A_ZERO");

    // TC28  SHR_B
    @(negedge CLK) begin OPA=0; OPB=4'b1100; CMD=4'b1010; inp_valid=2'b10; end
    compare("TC28_SHR_B_10");
    @(negedge CLK) begin OPA=0; OPB=4'b1100; CMD=4'b1010; inp_valid=2'b11; end
    compare("TC28_SHR_B_11");

    // TC40  SHR_B at max
    @(negedge CLK) begin OPA=0; OPB={width{1'b1}}; CMD=4'b1010; inp_valid=2'b11; end
    compare("TC40_SHR_B_MAX");

    // TC29  SHL_B
    @(negedge CLK) begin OPA=0; OPB=4'b0011; CMD=4'b1011; inp_valid=2'b10; end
    compare("TC29_SHL_B_10");
    @(negedge CLK) begin OPA=0; OPB=4'b0011; CMD=4'b1011; inp_valid=2'b11; end
    compare("TC29_SHL_B_11");

    // TC41  SHL_B at 0
    @(negedge CLK) begin OPA=0; OPB={width{1'b0}}; CMD=4'b1011; inp_valid=2'b11; end
    compare("TC41_SHL_B_ZERO");

    // TC30/TC31  ROL by 1,2,3 ... 7
    @(negedge CLK) begin OPA=4'b1010; OPB=1; CMD=4'b1100; inp_valid=2'b11; end
    compare("TC30_ROL_BY_1");
    @(negedge CLK) begin OPA=4'b1010; OPB=2; CMD=4'b1100; inp_valid=2'b11; end
    compare("TC31_ROL_BY_2");
    @(negedge CLK) begin OPA=4'b1010; OPB=3; CMD=4'b1100; inp_valid=2'b11; end
    compare("TC31_ROL_BY_3");
    @(negedge CLK) begin OPA=4'b1010; OPB=4; CMD=4'b1100; inp_valid=2'b11; end
    compare("TC31_ROL_BY_4");
    @(negedge CLK) begin OPA=4'b1010; OPB=7; CMD=4'b1100; inp_valid=2'b11; end
    compare("TC31_ROL_BY_7");

    // TC43  ROL: OPB MSB set (xxxx_1xxx) ? ERR
    @(negedge CLK) begin OPA=4'b1010; OPB=4'b1000; CMD=4'b1100; inp_valid=2'b11; end
    compare("TC43_ROL_OPB_MSB_ERR");

    // TC55  ROL: OPB 8-15 ? ignore bit3, use LSB 3 bits
    @(negedge CLK) begin OPA=4'b1010; OPB=9;  CMD=4'b1100; inp_valid=2'b11; end
    compare("TC55_ROL_OPB_9_IGNORE_BIT3");
    @(negedge CLK) begin OPA=4'b1010; OPB=10; CMD=4'b1100; inp_valid=2'b11; end
    compare("TC55_ROL_OPB_10_IGNORE_BIT3");
    @(negedge CLK) begin OPA=4'b1010; OPB=15; CMD=4'b1100; inp_valid=2'b11; end
    compare("TC55_ROL_OPB_15_IGNORE_BIT3");

    // ROL ERR: OPB >= 16
    @(negedge CLK) begin OPA=4'b1010; OPB=16; CMD=4'b1100; inp_valid=2'b11; end
    compare("ROL_OPB16_ERR");

    // TC32  ROR
    @(negedge CLK) begin OPA=4'b1010; OPB=1; CMD=4'b1101; inp_valid=2'b11; end
    compare("TC32_ROR_BY_1");
    @(negedge CLK) begin OPA=4'b1010; OPB=2; CMD=4'b1101; inp_valid=2'b11; end
    compare("TC32_ROR_BY_2");
    @(negedge CLK) begin OPA=4'b1010; OPB=3; CMD=4'b1101; inp_valid=2'b11; end
    compare("TC32_ROR_BY_3");
    @(negedge CLK) begin OPA=4'b1010; OPB=7; CMD=4'b1101; inp_valid=2'b11; end
    compare("TC32_ROR_BY_7");

    // TC56  ROR: OPB 8-15 ? ignore bit3, use LSB 3 bits
    @(negedge CLK) begin OPA=4'b1010; OPB=9;  CMD=4'b1101; inp_valid=2'b11; end
    compare("TC56_ROR_OPB_9_IGNORE_BIT3");
    @(negedge CLK) begin OPA=4'b1010; OPB=15; CMD=4'b1101; inp_valid=2'b11; end
    compare("TC56_ROR_OPB_15_IGNORE_BIT3");

    // ROR ERR: OPB >= 16
    @(negedge CLK) begin OPA=4'b1010; OPB=16; CMD=4'b1101; inp_valid=2'b11; end
    compare("ROR_OPB16_ERR");

    // TC46  LOGIC inp_valid ERR for all CMD except 6,7 when not 2'b11
    @(negedge CLK) begin OPA=4'b1010; OPB=4'b1100; CMD=4'b0000; inp_valid=2'b00; end
    compare("TC46_AND_INV00_ERR");
    @(negedge CLK) begin OPA=4'b1010; OPB=4'b1100; CMD=4'b0000; inp_valid=2'b01; end
    compare("TC46_AND_INV01_ERR");
    @(negedge CLK) begin OPA=4'b1010; OPB=4'b1100; CMD=4'b0000; inp_valid=2'b10; end
    compare("TC46_AND_INV10_ERR");
    @(negedge CLK) begin OPA=4'b1010; OPB=4'b1100; CMD=4'b0100; inp_valid=2'b00; end
    compare("TC46_XOR_INV00_ERR");
    @(negedge CLK) begin OPA=4'b1010; OPB=4'b1100; CMD=4'b1000; inp_valid=2'b00; end
    compare("TC46_SHRA_INV00_ERR");

    // TC47  LOGIC CMD 6,7 (NOT) ERR when inp_valid=2'b00
    @(negedge CLK) begin OPA=4'b1010; OPB=0; CMD=4'b0110; inp_valid=2'b00; end
    compare("TC47_NOT_A_INV00_ERR");
    @(negedge CLK) begin OPA=0; OPB=4'b1100; CMD=4'b0111; inp_valid=2'b00; end
    compare("TC47_NOT_B_INV00_ERR");

    // TC42  default CMD in logical mode
    @(negedge CLK) begin OPA=1; OPB=1; CMD=4'b1110; inp_valid=2'b11; end
    compare("TC42_LOGIC_DEFAULT_ERR");
    @(negedge CLK) begin OPA=1; OPB=1; CMD=4'b1111; inp_valid=2'b11; end
    compare("TC42_LOGIC_CMD15_ERR");


// --- CE=0 during various operations ---
$display("=== CE=0 DURING OPERATIONS ===");
@(negedge CLK) begin CE=0; OPA=5; OPB=3; CMD=4'b0000; inp_valid=2'b11; MODE=1; end
compare("CE0_ARITH_ADD_NO_UPDATE");
@(negedge CLK) begin CE=0; OPA=5; OPB=3; CMD=4'b0001; inp_valid=2'b11; MODE=1; end
compare("CE0_ARITH_SUB_NO_UPDATE");
@(negedge CLK) begin CE=0; OPA=5; OPB=3; CMD=4'b0000; inp_valid=2'b11; MODE=0; end
compare("CE0_LOGIC_AND_NO_UPDATE");
CE=1;

// --- RST during each MODE ---
$display("=== RST DURING ARITHMETIC ===");
MODE=1;
@(negedge CLK) begin OPA=7; OPB=5; CMD=4'b0000; inp_valid=2'b11; end
#2; RST=1; #3; RST=0;
@(posedge CLK); #1;
$display("  RST_ARITH: DUT_RES=%0d (expect 0)", DUT_RES);

$display("=== RST DURING LOGICAL ===");
MODE=0;
@(negedge CLK) begin OPA=4'b1010; OPB=4'b1100; CMD=4'b0000; inp_valid=2'b11; end
#2; RST=1; #3; RST=0;
@(posedge CLK); #1;
$display("  RST_LOGIC: DUT_RES=%0d (expect 0)", DUT_RES);
MODE=1;

// --- ADD boundary cases ---
$display("=== ADD BOUNDARY ===");
// 0+0=0
@(negedge CLK) begin OPA=0; OPB=0; CMD=4'b0000; inp_valid=2'b11; MODE=1; end
compare("ADD_ZERO_ZERO");
// max+max
@(negedge CLK) begin OPA={width{1'b1}}; OPB={width{1'b1}}; CMD=4'b0000; inp_valid=2'b11; end
compare("ADD_MAX_MAX");
// 0+max
@(negedge CLK) begin OPA=0; OPB={width{1'b1}}; CMD=4'b0000; inp_valid=2'b11; end
compare("ADD_ZERO_MAX");

// --- SUB boundary cases ---
$display("=== SUB BOUNDARY ===");
// max-max=0
@(negedge CLK) begin OPA={width{1'b1}}; OPB={width{1'b1}}; CMD=4'b0001; inp_valid=2'b11; end
compare("SUB_MAX_MAX_ZERO");
// max-0=max
@(negedge CLK) begin OPA={width{1'b1}}; OPB=0; CMD=4'b0001; inp_valid=2'b11; end
compare("SUB_MAX_ZERO");
// 0-0=0
@(negedge CLK) begin OPA=0; OPB=0; CMD=4'b0001; inp_valid=2'b11; end
compare("SUB_ZERO_ZERO");

// --- ADD_CIN boundary cases ---
$display("=== ADD_CIN BOUNDARY ===");
// max+max+1
@(negedge CLK) begin OPA={width{1'b1}}; OPB={width{1'b1}}; CIN=1; CMD=4'b0010; inp_valid=2'b11; end
compare("ADD_CIN_MAX_MAX_1");
// 0+0+0
@(negedge CLK) begin OPA=0; OPB=0; CIN=0; CMD=4'b0010; inp_valid=2'b11; end
compare("ADD_CIN_ZERO_ZERO_0");
// 0+0+1
@(negedge CLK) begin OPA=0; OPB=0; CIN=1; CMD=4'b0010; inp_valid=2'b11; end
compare("ADD_CIN_ZERO_ZERO_1");

// --- SUB_CIN boundary cases ---
$display("=== SUB_CIN BOUNDARY ===");
// 0-0-0
@(negedge CLK) begin OPA=0; OPB=0; CIN=0; CMD=4'b0011; inp_valid=2'b11; end
compare("SUB_CIN_ZERO_ZERO_0");
// 0-0-1 underflow
@(negedge CLK) begin OPA=0; OPB=0; CIN=1; CMD=4'b0011; inp_valid=2'b11; end
compare("SUB_CIN_ZERO_ZERO_1_UFLOW");
// max-0-0=max
@(negedge CLK) begin OPA={width{1'b1}}; OPB=0; CIN=0; CMD=4'b0011; inp_valid=2'b11; end
compare("SUB_CIN_MAX_ZERO_0");

// --- INC/DEC all inp_valid combinations ---
$display("=== INC DEC ALL INP_VALID ===");
// INC_A with inp_valid=10 ? ERR (only 01 and 11 valid)
@(negedge CLK) begin OPA=5; OPB=0; CMD=4'b0100; inp_valid=2'b10; MODE=1; end
compare("INC_A_INV10_ERR");
// DEC_A with inp_valid=10 ? ERR
@(negedge CLK) begin OPA=5; OPB=0; CMD=4'b0101; inp_valid=2'b10; end
compare("DEC_A_INV10_ERR");
// INC_B with inp_valid=01 ? ERR (only 10 and 11 valid)
@(negedge CLK) begin OPA=0; OPB=3; CMD=4'b0110; inp_valid=2'b01; end
compare("INC_B_INV01_ERR");
// DEC_B with inp_valid=01 ? ERR
@(negedge CLK) begin OPA=0; OPB=3; CMD=4'b0111; inp_valid=2'b01; end
compare("DEC_B_INV01_ERR");

// --- CMP boundary ---
$display("=== CMP BOUNDARY ===");
// 0 vs 0
@(negedge CLK) begin OPA=0; OPB=0; CMD=4'b1000; inp_valid=2'b11; end
compare("CMP_ZERO_ZERO");
// max vs max
@(negedge CLK) begin OPA={width{1'b1}}; OPB={width{1'b1}}; CMD=4'b1000; inp_valid=2'b11; end
compare("CMP_MAX_MAX");
// 0 vs max
@(negedge CLK) begin OPA=0; OPB={width{1'b1}}; CMD=4'b1000; inp_valid=2'b11; end
compare("CMP_ZERO_MAX_LESS");
// max vs 0
@(negedge CLK) begin OPA={width{1'b1}}; OPB=0; CMD=4'b1000; inp_valid=2'b11; end
compare("CMP_MAX_ZERO_GREATER");

// --- MUL boundary ---
$display("=== MUL BOUNDARY ===");
// 0*0=0
@(negedge CLK) begin OPA=0; OPB=0; CMD=4'b1001; inp_valid=2'b11; end
compare_mul("MUL_ZERO_ZERO");
// (0+1)*(0+1)=1
@(negedge CLK) begin OPA=0; OPB=0; CMD=4'b1001; inp_valid=2'b11; end
compare_mul("MUL_INC_ZERO");
// max*max
@(negedge CLK) begin OPA={width{1'b1}}; OPB={width{1'b1}}; CMD=4'b1001; inp_valid=2'b11; end
compare_mul("MUL_MAX_MAX");

// --- MUL_SHL boundary ---
$display("=== MUL_SHL BOUNDARY ===");
// (0<<1)*0=0
@(negedge CLK) begin OPA=0; OPB=0; CMD=4'b1010; inp_valid=2'b11; end
compare_mul("MUL_SHL_ZERO_ZERO");
// (1<<1)*1=2
@(negedge CLK) begin OPA=1; OPB=1; CMD=4'b1010; inp_valid=2'b11; end
compare_mul("MUL_SHL_ONE_ONE");

// --- SIGNED ADD boundary ---
$display("=== SIGNED ADD BOUNDARY ===");
// 0+0=0
@(negedge CLK) begin OPA=0; OPB=0; CMD=4'b1011; inp_valid=2'b11; end
compare("SADD_ZERO_ZERO");
// negative+negative overflow: -1 + -1 (all 1s + all 1s)
@(negedge CLK) begin OPA={width{1'b1}}; OPB={width{1'b1}}; CMD=4'b1011; inp_valid=2'b11; end
compare("SADD_NEG_NEG");
// positive+negative=0: max_pos + 1 (which is min_neg in signed)
@(negedge CLK) begin OPA={1'b0,{width-1{1'b1}}}; OPB={1'b1,{width-1{1'b0}}}; CMD=4'b1011; inp_valid=2'b11; end
compare("SADD_POS_NEG_ZERO");

// --- SIGNED SUB boundary ---
$display("=== SIGNED SUB BOUNDARY ===");
// 0-0=0
@(negedge CLK) begin OPA=0; OPB=0; CMD=4'b1100; inp_valid=2'b11; end
compare("SSUB_ZERO_ZERO");
// min_neg - pos = overflow: 1000_0000 - 0000_0001
@(negedge CLK) begin OPA={1'b1,{width-1{1'b0}}}; OPB=1; CMD=4'b1100; inp_valid=2'b11; end
compare("SSUB_MINNEG_ONE_OFLOW");
// equal values: G=0 E=1 L=0
@(negedge CLK) begin OPA=4; OPB=4; CMD=4'b1100; inp_valid=2'b11; end
compare("SSUB_EQUAL");

// --- SIGNED operations inp_valid ERR ---
$display("=== SIGNED INP_VALID ERR ===");
@(negedge CLK) begin OPA=5; OPB=3; CMD=4'b1011; inp_valid=2'b00; end
compare("SADD_INV00_ERR");
@(negedge CLK) begin OPA=5; OPB=3; CMD=4'b1011; inp_valid=2'b01; end
compare("SADD_INV01_ERR");
@(negedge CLK) begin OPA=5; OPB=3; CMD=4'b1011; inp_valid=2'b10; end
compare("SADD_INV10_ERR");
@(negedge CLK) begin OPA=5; OPB=3; CMD=4'b1100; inp_valid=2'b00; end
compare("SSUB_INV00_ERR");
@(negedge CLK) begin OPA=5; OPB=3; CMD=4'b1100; inp_valid=2'b01; end
compare("SSUB_INV01_ERR");
@(negedge CLK) begin OPA=5; OPB=3; CMD=4'b1100; inp_valid=2'b10; end
compare("SSUB_INV10_ERR");

// --- MUL inp_valid ERR ---
$display("=== MUL INP_VALID ERR ===");
@(negedge CLK) begin OPA=2; OPB=3; CMD=4'b1001; inp_valid=2'b00; end
compare_mul("MUL_INV00_ERR");
@(negedge CLK) begin OPA=2; OPB=3; CMD=4'b1001; inp_valid=2'b01; end
compare_mul("MUL_INV01_ERR");
@(negedge CLK) begin OPA=2; OPB=3; CMD=4'b1001; inp_valid=2'b10; end
compare_mul("MUL_INV10_ERR");
@(negedge CLK) begin OPA=2; OPB=3; CMD=4'b1010; inp_valid=2'b00; end
compare_mul("MULSHL_INV00_ERR");
@(negedge CLK) begin OPA=2; OPB=3; CMD=4'b1010; inp_valid=2'b01; end
compare_mul("MULSHL_INV01_ERR");
@(negedge CLK) begin OPA=2; OPB=3; CMD=4'b1010; inp_valid=2'b10; end
compare_mul("MULSHL_INV10_ERR");

// --- AND/OR/XOR boundary ---
$display("=== LOGIC BOUNDARY ===");
MODE=0;
// all zeros
@(negedge CLK) begin OPA=0; OPB=0; CMD=4'b0000; inp_valid=2'b11; end
compare("AND_ZERO_ZERO");
@(negedge CLK) begin OPA=0; OPB=0; CMD=4'b0010; inp_valid=2'b11; end
compare("OR_ZERO_ZERO");
@(negedge CLK) begin OPA=0; OPB=0; CMD=4'b0100; inp_valid=2'b11; end
compare("XOR_ZERO_ZERO");
// all ones
@(negedge CLK) begin OPA={width{1'b1}}; OPB={width{1'b1}}; CMD=4'b0000; inp_valid=2'b11; end
compare("AND_MAX_MAX");
@(negedge CLK) begin OPA={width{1'b1}}; OPB={width{1'b1}}; CMD=4'b0010; inp_valid=2'b11; end
compare("OR_MAX_MAX");
@(negedge CLK) begin OPA={width{1'b1}}; OPB={width{1'b1}}; CMD=4'b0100; inp_valid=2'b11; end
compare("XOR_MAX_MAX_ZERO");
// A with 0
@(negedge CLK) begin OPA={width{1'b1}}; OPB=0; CMD=4'b0000; inp_valid=2'b11; end
compare("AND_MAX_ZERO");
@(negedge CLK) begin OPA={width{1'b1}}; OPB=0; CMD=4'b0010; inp_valid=2'b11; end
compare("OR_MAX_ZERO");
@(negedge CLK) begin OPA={width{1'b1}}; OPB=0; CMD=4'b0100; inp_valid=2'b11; end
compare("XOR_MAX_ZERO");

// --- NOT boundary ---
$display("=== NOT BOUNDARY ===");
// NOT 0 = max
@(negedge CLK) begin OPA=0; OPB=0; CMD=4'b0110; inp_valid=2'b11; end
compare("NOT_A_ZERO");
@(negedge CLK) begin OPA=0; OPB=0; CMD=4'b0111; inp_valid=2'b11; end
compare("NOT_B_ZERO");
// NOT max = 0
@(negedge CLK) begin OPA={width{1'b1}}; OPB=0; CMD=4'b0110; inp_valid=2'b11; end
compare("NOT_A_MAX");
@(negedge CLK) begin OPA=0; OPB={width{1'b1}}; CMD=4'b0111; inp_valid=2'b11; end
compare("NOT_B_MAX");

// --- SHR/SHL boundary ---
$display("=== SHIFT BOUNDARY ===");
// SHR 0 = 0
@(negedge CLK) begin OPA=0; OPB=0; CMD=4'b1000; inp_valid=2'b11; end
compare("SHR_A_ZERO");
// SHL 0 = 0
@(negedge CLK) begin OPA=0; OPB=0; CMD=4'b1001; inp_valid=2'b11; end
compare("SHL_A_ZERO");
// SHR 1 = 0 (LSB drops off)
@(negedge CLK) begin OPA=1; OPB=0; CMD=4'b1000; inp_valid=2'b11; end
compare("SHR_A_ONE");
// SHL max = max-1 shifted (MSB drops off)
@(negedge CLK) begin OPA={width{1'b1}}; OPB=0; CMD=4'b1001; inp_valid=2'b11; end
compare("SHL_A_MAX");
// same for B
@(negedge CLK) begin OPA=0; OPB=0; CMD=4'b1010; inp_valid=2'b11; end
compare("SHR_B_ZERO");
@(negedge CLK) begin OPA=0; OPB=0; CMD=4'b1011; inp_valid=2'b11; end
compare("SHL_B_ZERO");
@(negedge CLK) begin OPA=0; OPB=1; CMD=4'b1010; inp_valid=2'b11; end
compare("SHR_B_ONE");
@(negedge CLK) begin OPA=0; OPB={width{1'b1}}; CMD=4'b1011; inp_valid=2'b11; end
compare("SHL_B_MAX");

// --- ROL boundary ---
$display("=== ROL ROR BOUNDARY ===");
MODE=0;
// ROL by 0 = same value
@(negedge CLK) begin OPA=4'b1010; OPB=0; CMD=4'b1100; inp_valid=2'b11; end
compare("ROL_BY_0_SAME");
// ROR by 0 = same value
@(negedge CLK) begin OPA=4'b1010; OPB=0; CMD=4'b1101; inp_valid=2'b11; end
compare("ROR_BY_0_SAME");
// ROL all zeros = 0
@(negedge CLK) begin OPA=0; OPB=3; CMD=4'b1100; inp_valid=2'b11; end
compare("ROL_ZERO_OPA");
// ROR all zeros = 0
@(negedge CLK) begin OPA=0; OPB=3; CMD=4'b1101; inp_valid=2'b11; end
compare("ROR_ZERO_OPA");
// ROL all ones = all ones
@(negedge CLK) begin OPA={width{1'b1}}; OPB=3; CMD=4'b1100; inp_valid=2'b11; end
compare("ROL_MAX_OPA");
// ROR all ones = all ones
@(negedge CLK) begin OPA={width{1'b1}}; OPB=3; CMD=4'b1101; inp_valid=2'b11; end
compare("ROR_MAX_OPA");
// ROL/ROR by width = same value (full rotation)
@(negedge CLK) begin OPA=4'b1010; OPB=width; CMD=4'b1100; inp_valid=2'b11; end
compare("ROL_BY_WIDTH_SAME");
@(negedge CLK) begin OPA=4'b1010; OPB=width; CMD=4'b1101; inp_valid=2'b11; end
compare("ROR_BY_WIDTH_SAME");

// --- ROL ROR all OPB values 1-7 ---
$display("=== ROL ROR ALL SHIFTS ===");
@(negedge CLK) begin OPA=4'b1011; OPB=1; CMD=4'b1100; inp_valid=2'b11; end
compare("ROL_1011_BY_1");
@(negedge CLK) begin OPA=4'b1011; OPB=2; CMD=4'b1100; inp_valid=2'b11; end
compare("ROL_1011_BY_2");
@(negedge CLK) begin OPA=4'b1011; OPB=5; CMD=4'b1100; inp_valid=2'b11; end
compare("ROL_1011_BY_5");
@(negedge CLK) begin OPA=4'b1011; OPB=6; CMD=4'b1100; inp_valid=2'b11; end
compare("ROL_1011_BY_6");
@(negedge CLK) begin OPA=4'b1011; OPB=1; CMD=4'b1101; inp_valid=2'b11; end
compare("ROR_1011_BY_1");
@(negedge CLK) begin OPA=4'b1011; OPB=5; CMD=4'b1101; inp_valid=2'b11; end
compare("ROR_1011_BY_5");
@(negedge CLK) begin OPA=4'b1011; OPB=6; CMD=4'b1101; inp_valid=2'b11; end
compare("ROR_1011_BY_6");

// --- NAND NOR XNOR boundary ---
$display("=== NAND NOR XNOR BOUNDARY ===");
@(negedge CLK) begin OPA=0; OPB=0; CMD=4'b0001; inp_valid=2'b11; end
compare("NAND_ZERO_ZERO");
@(negedge CLK) begin OPA={width{1'b1}}; OPB={width{1'b1}}; CMD=4'b0001; inp_valid=2'b11; end
compare("NAND_MAX_MAX");
@(negedge CLK) begin OPA=0; OPB=0; CMD=4'b0011; inp_valid=2'b11; end
compare("NOR_ZERO_ZERO");
@(negedge CLK) begin OPA={width{1'b1}}; OPB={width{1'b1}}; CMD=4'b0011; inp_valid=2'b11; end
compare("NOR_MAX_MAX");
@(negedge CLK) begin OPA=0; OPB=0; CMD=4'b0101; inp_valid=2'b11; end
compare("XNOR_ZERO_ZERO");
@(negedge CLK) begin OPA={width{1'b1}}; OPB={width{1'b1}}; CMD=4'b0101; inp_valid=2'b11; end
compare("XNOR_MAX_MAX");

// --- MODE switch mid-simulation ---
$display("=== MODE SWITCH ===");
@(negedge CLK) begin OPA=5; OPB=3; CMD=4'b0000; inp_valid=2'b11; MODE=1; end
compare("MODE_ARITH_ADD");
@(negedge CLK) begin OPA=5; OPB=3; CMD=4'b0000; inp_valid=2'b11; MODE=0; end
compare("MODE_LOGIC_AND_SAME_CMD");
@(negedge CLK) begin OPA=5; OPB=3; CMD=4'b0000; inp_valid=2'b11; MODE=1; end
compare("MODE_BACK_TO_ARITH");

// --- alternating CIN values ---
$display("=== CIN TOGGLE ===");
MODE=1;
@(negedge CLK) begin OPA=5; OPB=3; CIN=0; CMD=4'b0010; inp_valid=2'b11; end
compare("ADD_CIN0");
@(negedge CLK) begin OPA=5; OPB=3; CIN=1; CMD=4'b0010; inp_valid=2'b11; end
compare("ADD_CIN1");
@(negedge CLK) begin OPA=5; OPB=3; CIN=0; CMD=4'b0011; inp_valid=2'b11; end
compare("SUB_CIN0");
@(negedge CLK) begin OPA=5; OPB=3; CIN=1; CMD=4'b0011; inp_valid=2'b11; end
compare("SUB_CIN1");

// =====================================================
// SIGNED ADD OVERFLOW CASES
// =====================================================
$display("=== SIGNED ADD OVERFLOW ===");

// Positive + Positive = Negative (overflow)
// max_pos + max_pos : 0111...1 + 0111...1
@(negedge CLK) begin
    OPA = {1'b0, {(width-1){1'b1}}};   // +127 (for 8-bit)
    OPB = {1'b0, {(width-1){1'b1}}};   // +127
    CMD = 4'b1011;
    inp_valid = 2'b11;
    MODE = 1;
end
compare("SADD_POSPOS_OFLOW");

// Positive + 1 from max_pos ? overflow
// 0111...1 + 0000...1
@(negedge CLK) begin
    OPA = {1'b0, {(width-1){1'b1}}};   // +127
    OPB = {{(width-1){1'b0}}, 1'b1};   // +1
    CMD = 4'b1011;
    inp_valid = 2'b11;
end
compare("SADD_MAXPOS_ONE_OFLOW");

// Negative + Negative = Positive (overflow)
// min_neg + min_neg : 1000...0 + 1000...0
@(negedge CLK) begin
    OPA = {1'b1, {(width-1){1'b0}}};   // -128 (for 8-bit)
    OPB = {1'b1, {(width-1){1'b0}}};   // -128
    CMD = 4'b1011;
    inp_valid = 2'b11;
end
compare("SADD_NEGNEG_OFLOW");

// min_neg + (-1)
// 1000...0 + 1111...1
@(negedge CLK) begin
    OPA = {1'b1, {(width-1){1'b0}}};   // -128
    OPB = {width{1'b1}};               // -1
    CMD = 4'b1011;
    inp_valid = 2'b11;
end
compare("SADD_MINNEG_NEG1_OFLOW");

// No overflow boundary: max_pos + 0 = max_pos (no overflow)
@(negedge CLK) begin
    OPA = {1'b0, {(width-1){1'b1}}};   // +127
    OPB = {width{1'b0}};               // 0
    CMD = 4'b1011;
    inp_valid = 2'b11;
end
compare("SADD_MAXPOS_ZERO_NOOFLOW");

// No overflow boundary: min_neg + 0 = min_neg (no overflow)
@(negedge CLK) begin
    OPA = {1'b1, {(width-1){1'b0}}};   // -128
    OPB = {width{1'b0}};               // 0
    CMD = 4'b1011;
    inp_valid = 2'b11;
end
compare("SADD_MINNEG_ZERO_NOOFLOW");

// =====================================================
// SIGNED SUB OVERFLOW CASES
// =====================================================
$display("=== SIGNED SUB OVERFLOW ===");

// Positive - Negative = overflow
// max_pos - min_neg : 0111...1 - 1000...0
@(negedge CLK) begin
    OPA = {1'b0, {(width-1){1'b1}}};   // +127
    OPB = {1'b1, {(width-1){1'b0}}};   // -128
    CMD = 4'b1100;
    inp_valid = 2'b11;
    MODE = 1;
end
compare("SSUB_MAXPOS_MINNEG_OFLOW");

// max_pos - (-1) ? overflow
// 0111...1 - 1111...1
@(negedge CLK) begin
    OPA = {1'b0, {(width-1){1'b1}}};   // +127
    OPB = {width{1'b1}};               // -1
    CMD = 4'b1100;
    inp_valid = 2'b11;
end
compare("SSUB_MAXPOS_NEG1_OFLOW");

// Negative - Positive = overflow
// min_neg - 1 : 1000...0 - 0000...1
@(negedge CLK) begin
    OPA = {1'b1, {(width-1){1'b0}}};   // -128
    OPB = {{(width-1){1'b0}}, 1'b1};   // +1
    CMD = 4'b1100;
    inp_valid = 2'b11;
end
compare("SSUB_MINNEG_ONE_OFLOW");

// min_neg - max_pos : 1000...0 - 0111...1
@(negedge CLK) begin
    OPA = {1'b1, {(width-1){1'b0}}};   // -128
    OPB = {1'b0, {(width-1){1'b1}}};   // +127
    CMD = 4'b1100;
    inp_valid = 2'b11;
end
compare("SSUB_MINNEG_MAXPOS_OFLOW");

// No overflow boundary: max_pos - 0 = max_pos (no overflow)
@(negedge CLK) begin
    OPA = {1'b0, {(width-1){1'b1}}};   // +127
    OPB = {width{1'b0}};               // 0
    CMD = 4'b1100;
    inp_valid = 2'b11;
end
compare("SSUB_MAXPOS_ZERO_NOOFLOW");

// No overflow: min_neg - 0 = min_neg (no overflow)
@(negedge CLK) begin
    OPA = {1'b1, {(width-1){1'b0}}};   // -128
    OPB = {width{1'b0}};               // 0
    CMD = 4'b1100;
    inp_valid = 2'b11;
end
compare("SSUB_MINNEG_ZERO_NOOFLOW");

// No overflow: 0 - 0 = 0
@(negedge CLK) begin
    OPA = {width{1'b0}};
    OPB = {width{1'b0}};
    CMD = 4'b1100;
    inp_valid = 2'b11;
end
compare("SSUB_ZERO_ZERO_NOOFLOW");

// =====================================================
// 1. SIGNED SUB OVERFLOW (OPA[7]!=OPB[7] && s_sub[7]!=OPA[7])
// Need: both terms TRUE simultaneously
// =====================================================
$display("=== SSUB OVERFLOW FEC ===");

// pos - neg = overflow: OPA[7]=0, OPB[7]=1, result[7]=1
// OPA[7]!=OPB[7] ? true, s_sub[7]!=OPA[7] ? true
@(negedge CLK) begin
    OPA = {1'b0, {(width-1){1'b1}}};   // +127
    OPB = {1'b1, {(width-1){1'b0}}};   // -128
    CMD = 4'b1100; inp_valid = 2'b11; MODE = 1;
end
compare("SSUB_FEC_OFLOW_ROW2_ROW3_ROW4");

// neg - pos = overflow: OPA[7]=1, OPB[7]=0, result[7]=0
@(negedge CLK) begin
    OPA = {1'b1, {(width-1){1'b0}}};   // -128
    OPB = {1'b0, {(width-1){1'b1}}};   // +127
    CMD = 4'b1100; inp_valid = 2'b11;
end
compare("SSUB_FEC_NEGNEG_OFLOW");

// =====================================================
// 2. INP_VALID ERR ELSE BRANCHES
// Need: INP_VALID != 11 to hit ERR branch
// Covers all the if(INP_VALID==2'b11) ELSE ZERO hits
// =====================================================
$display("=== INP_VALID ERR ELSE BRANCHES ===");

// SUB_CIN: OPB+CIN > OPA (underflow branch)
@(negedge CLK) begin
    OPA = 0; OPB = 5; CIN = 1;
    CMD = 4'b0011; inp_valid = 2'b11; MODE = 1;
end
compare("SUBCIN_BORROW_BRANCH");

// All invalid inp_valid for each CMD that had 50% coverage
// CMD=0000 (ADD) invalid
@(negedge CLK) begin
    OPA = 5; OPB = 3; CMD = 4'b0000;
    inp_valid = 2'b00; MODE = 1;
end
compare("ADD_INV00_ERR_ELSE");

@(negedge CLK) begin
    OPA = 5; OPB = 3; CMD = 4'b0000;
    inp_valid = 2'b01; MODE = 1;
end
compare("ADD_INV01_ERR_ELSE");

@(negedge CLK) begin
    OPA = 5; OPB = 3; CMD = 4'b0000;
    inp_valid = 2'b10; MODE = 1;
end
compare("ADD_INV10_ERR_ELSE");

// CMD=0001 (SUB) invalid
@(negedge CLK) begin
    OPA = 5; OPB = 3; CMD = 4'b0001;
    inp_valid = 2'b00; MODE = 1;
end
compare("SUB_INV00_ERR_ELSE");

@(negedge CLK) begin
    OPA = 5; OPB = 3; CMD = 4'b0001;
    inp_valid = 2'b01; MODE = 1;
end
compare("SUB_INV01_ERR_ELSE");

@(negedge CLK) begin
    OPA = 5; OPB = 3; CMD = 4'b0001;
    inp_valid = 2'b10; MODE = 1;
end
compare("SUB_INV10_ERR_ELSE");

// CMD=0010 (ADD_CIN) invalid
@(negedge CLK) begin
    OPA = 5; OPB = 3; CIN = 0; CMD = 4'b0010;
    inp_valid = 2'b00; MODE = 1;
end
compare("ADDCIN_INV00_ERR_ELSE");

@(negedge CLK) begin
    OPA = 5; OPB = 3; CIN = 0; CMD = 4'b0010;
    inp_valid = 2'b01; MODE = 1;
end
compare("ADDCIN_INV01_ERR_ELSE");

@(negedge CLK) begin
    OPA = 5; OPB = 3; CIN = 0; CMD = 4'b0010;
    inp_valid = 2'b10; MODE = 1;
end
compare("ADDCIN_INV10_ERR_ELSE");

// CMD=0011 (SUB_CIN) invalid
@(negedge CLK) begin
    OPA = 5; OPB = 3; CIN = 0; CMD = 4'b0011;
    inp_valid = 2'b00; MODE = 1;
end
compare("SUBCIN_INV00_ERR_ELSE");

@(negedge CLK) begin
    OPA = 5; OPB = 3; CIN = 0; CMD = 4'b0011;
    inp_valid = 2'b01; MODE = 1;
end
compare("SUBCIN_INV01_ERR_ELSE");

@(negedge CLK) begin
    OPA = 5; OPB = 3; CIN = 0; CMD = 4'b0011;
    inp_valid = 2'b10; MODE = 1;
end
compare("SUBCIN_INV10_ERR_ELSE");

// CMD=1000 (CMP) invalid
@(negedge CLK) begin
    OPA = 5; OPB = 3; CMD = 4'b1000;
    inp_valid = 2'b00; MODE = 1;
end
compare("CMP_INV00_ERR_ELSE");

@(negedge CLK) begin
    OPA = 5; OPB = 3; CMD = 4'b1000;
    inp_valid = 2'b01; MODE = 1;
end
compare("CMP_INV01_ERR_ELSE");

@(negedge CLK) begin
    OPA = 5; OPB = 3; CMD = 4'b1000;
    inp_valid = 2'b10; MODE = 1;
end
compare("CMP_INV10_ERR_ELSE");

$display("=== FEC INP_VALID CONDITION FALSE ===");

// INC_A (CMD=0100): need INP_VALID=00 and INP_VALID=10
// to make (INP_VALID==3)_0 and (INP_VALID==1)_0 hit
@(negedge CLK) begin
    OPA = 5; OPB = 0; CMD = 4'b0100;
    inp_valid = 2'b00; MODE = 1;
end
compare("INCA_INV00_FEC_0");

// INC_B (CMD=0110): need INP_VALID=00 and INP_VALID=01
@(negedge CLK) begin
    OPA = 0; OPB = 5; CMD = 4'b0110;
    inp_valid = 2'b00; MODE = 1;
end
compare("INCB_INV00_FEC_0");

// DEC_A (CMD=0101)
@(negedge CLK) begin
    OPA = 5; OPB = 0; CMD = 4'b0101;
    inp_valid = 2'b00; MODE = 1;
end
compare("DECA_INV00_FEC_0");

// DEC_B (CMD=0111)
@(negedge CLK) begin
    OPA = 0; OPB = 5; CMD = 4'b0111;
    inp_valid = 2'b00; MODE = 1;
end
compare("DECB_INV00_FEC_0");


$display("=== CNT9 CNT10 FSM ST1->ST0 TRANSITION ===");

// First MUL: cnt goes 0->1 (st0->st1)
@(negedge CLK) begin
    OPA = 3; OPB = 2; CMD = 4'b1001;
    inp_valid = 2'b11; MODE = 1;
end
compare_mul("MUL_CNT_ST0_TO_ST1");

// Immediately another MUL: cnt already 1, so else fires ? cnt=0 (st1->st0)
@(negedge CLK) begin
    OPA = 4; OPB = 2; CMD = 4'b1001;
    inp_valid = 2'b11; MODE = 1;
end
compare_mul("MUL_CNT9_ST1_TO_ST0");

// Same for cnt_10 (MUL_SHL)
@(negedge CLK) begin
    OPA = 3; OPB = 2; CMD = 4'b1010;
    inp_valid = 2'b11; MODE = 1;
end
compare_mul("MULSHL_CNT_ST0_TO_ST1");

@(negedge CLK) begin
    OPA = 4; OPB = 2; CMD = 4'b1010;
    inp_valid = 2'b11; MODE = 1;
end
compare_mul("MULSHL_CNT10_ST1_TO_ST0");

$display("=== FEC INP_VALID==3||INP_VALID==1 _0 ROWS ===");

// INC_A CMD=4'd4: need INP_VALID=00 (neither 3 nor 1)
@(negedge CLK) begin
    OPA=5; OPB=0; CMD=4'd4;
    inp_valid=2'b00; MODE=1; CE=1;
end
compare("INCA_INV00_FEC_ROW1_ROW3");

// INC_A CMD=4'd4: need INP_VALID=10 (not 3, not 1)
@(negedge CLK) begin
    OPA=5; OPB=0; CMD=4'd4;
    inp_valid=2'b10; MODE=1;
end
compare("INCA_INV10_FEC_ROW1");

// DEC_A CMD=4'd5: INP_VALID=00
@(negedge CLK) begin
    OPA=5; OPB=0; CMD=4'd5;
    inp_valid=2'b00; MODE=1;
end
compare("DECA_INV00_FEC_ROW1_ROW3");

// DEC_A CMD=4'd5: INP_VALID=10
@(negedge CLK) begin
    OPA=5; OPB=0; CMD=4'd5;
    inp_valid=2'b10; MODE=1;
end
compare("DECA_INV10_FEC_ROW1");

// LOGICAL NOT_A CMD=4'd6 MODE=0: INP_VALID=00
@(negedge CLK) begin
    OPA=5; OPB=0; CMD=4'd6;
    inp_valid=2'b00; MODE=0;
end
compare("NOTA_INV00_FEC_ROW1_ROW3");

// LOGICAL NOT_A CMD=4'd6 MODE=0: INP_VALID=10
@(negedge CLK) begin
    OPA=5; OPB=0; CMD=4'd6;
    inp_valid=2'b10; MODE=0;
end
compare("NOTA_INV10_FEC_ROW1");

// LOGICAL SHR_A CMD=4'd8 MODE=0: INP_VALID=00
@(negedge CLK) begin
    OPA=5; OPB=0; CMD=4'd8;
    inp_valid=2'b00; MODE=0;
end
compare("SHRA_INV00_FEC_ROW1_ROW3");

// LOGICAL SHR_A CMD=4'd8: INP_VALID=10
@(negedge CLK) begin
    OPA=5; OPB=0; CMD=4'd8;
    inp_valid=2'b10; MODE=0;
end
compare("SHRA_INV10_FEC_ROW1");

// LOGICAL SHL_A CMD=4'd9 MODE=0: INP_VALID=00
@(negedge CLK) begin
    OPA=5; OPB=0; CMD=4'd9;
    inp_valid=2'b00; MODE=0;
end
compare("SHLA_INV00_FEC_ROW1_ROW3");

// LOGICAL SHL_A CMD=4'd9: INP_VALID=10
@(negedge CLK) begin
    OPA=5; OPB=0; CMD=4'd9;
    inp_valid=2'b10; MODE=0;
end
compare("SHLA_INV10_FEC_ROW1");

$display("=== FEC INP_VALID==3||INP_VALID==2 _0 ROWS ===");

// INC_B CMD=4'd6 ARITH: INP_VALID=00
@(negedge CLK) begin
    OPA=0; OPB=5; CMD=4'd6;
    inp_valid=2'b00; MODE=1;
end
compare("INCB_INV00_FEC_ROW1_ROW3");

// INC_B CMD=4'd6: INP_VALID=01
@(negedge CLK) begin
    OPA=0; OPB=5; CMD=4'd6;
    inp_valid=2'b01; MODE=1;
end
compare("INCB_INV01_FEC_ROW3");

// DEC_B CMD=4'd7 ARITH: INP_VALID=00
@(negedge CLK) begin
    OPA=0; OPB=5; CMD=4'd7;
    inp_valid=2'b00; MODE=1;
end
compare("DECB_INV00_FEC_ROW1_ROW3");

// DEC_B CMD=4'd7: INP_VALID=01
@(negedge CLK) begin
    OPA=0; OPB=5; CMD=4'd7;
    inp_valid=2'b01; MODE=1;
end
compare("DECB_INV01_FEC_ROW3");

// LOGICAL NOT_B CMD=4'd7 MODE=0: INP_VALID=00
@(negedge CLK) begin
    OPA=0; OPB=5; CMD=4'd7;
    inp_valid=2'b00; MODE=0;
end
compare("NOTB_INV00_FEC_ROW1_ROW3");

// LOGICAL NOT_B: INP_VALID=01
@(negedge CLK) begin
    OPA=0; OPB=5; CMD=4'd7;
    inp_valid=2'b01; MODE=0;
end
compare("NOTB_INV01_FEC_ROW3");

// LOGICAL SHR_B CMD=4'd10: INP_VALID=00
@(negedge CLK) begin
    OPA=0; OPB=5; CMD=4'd10;
    inp_valid=2'b00; MODE=0;
end
compare("SHRB_INV00_FEC_ROW1_ROW3");

// LOGICAL SHR_B: INP_VALID=01
@(negedge CLK) begin
    OPA=0; OPB=5; CMD=4'd10;
    inp_valid=2'b01; MODE=0;
end
compare("SHRB_INV01_FEC_ROW3");

// LOGICAL SHL_B CMD=4'd11: INP_VALID=00
@(negedge CLK) begin
    OPA=0; OPB=5; CMD=4'd11;
    inp_valid=2'b00; MODE=0;
end
compare("SHLB_INV00_FEC_ROW1_ROW3");

// LOGICAL SHL_B: INP_VALID=01
@(negedge CLK) begin
    OPA=0; OPB=5; CMD=4'd11;
    inp_valid=2'b01; MODE=0;
end
compare("SHLB_INV01_FEC_ROW3");

$display("=== ERR ELSE BRANCHES - STATEMENT ZEROS ===");

// Line 143: ADD (4'd0) ARITH ERR
@(negedge CLK) begin OPA=5; OPB=3; CMD=4'd0; inp_valid=2'b00; MODE=1; end
compare("ADD_INV00_ERR");
@(negedge CLK) begin OPA=5; OPB=3; CMD=4'd0; inp_valid=2'b01; MODE=1; end
compare("ADD_INV01_ERR");
@(negedge CLK) begin OPA=5; OPB=3; CMD=4'd0; inp_valid=2'b10; MODE=1; end
compare("ADD_INV10_ERR");

// Line 153: SUB (4'd1) ARITH ERR
@(negedge CLK) begin OPA=5; OPB=3; CMD=4'd1; inp_valid=2'b00; MODE=1; end
compare("SUB_INV00_ERR");
@(negedge CLK) begin OPA=5; OPB=3; CMD=4'd1; inp_valid=2'b01; MODE=1; end
compare("SUB_INV01_ERR");
@(negedge CLK) begin OPA=5; OPB=3; CMD=4'd1; inp_valid=2'b10; MODE=1; end
compare("SUB_INV10_ERR");

// Line 188: ADD_CIN (4'd2) ERR
@(negedge CLK) begin OPA=5; OPB=3; CIN=0; CMD=4'd2; inp_valid=2'b00; MODE=1; end
compare("ADDCIN_INV00_ERR");
@(negedge CLK) begin OPA=5; OPB=3; CIN=0; CMD=4'd2; inp_valid=2'b01; MODE=1; end
compare("ADDCIN_INV01_ERR");
@(negedge CLK) begin OPA=5; OPB=3; CIN=0; CMD=4'd2; inp_valid=2'b10; MODE=1; end
compare("ADDCIN_INV10_ERR");

// Line 193: SUB_CIN (4'd3) ERR
@(negedge CLK) begin OPA=5; OPB=3; CIN=0; CMD=4'd3; inp_valid=2'b00; MODE=1; end
compare("SUBCIN_INV00_ERR");
@(negedge CLK) begin OPA=5; OPB=3; CIN=0; CMD=4'd3; inp_valid=2'b01; MODE=1; end
compare("SUBCIN_INV01_ERR");
@(negedge CLK) begin OPA=5; OPB=3; CIN=0; CMD=4'd3; inp_valid=2'b10; MODE=1; end
compare("SUBCIN_INV10_ERR");

// Line 198: SUB_CIN OFLOW branch ? (OPB+CIN) > OPA
@(negedge CLK) begin
    OPA=8'd2; OPB=8'd5; CIN=1;     // 5+1=6 > 2 ? OFLOW
    CMD=4'd3; inp_valid=2'b11; MODE=1;
end
compare("SUBCIN_OFLOW_BRANCH");

// Also: 0 - 0 - 1 underflow
@(negedge CLK) begin
    OPA=8'd0; OPB=8'd0; CIN=1;     // 0+1=1 > 0 ? OFLOW
    CMD=4'd3; inp_valid=2'b11; MODE=1;
end
compare("SUBCIN_ZERO_CIN1_OFLOW");

// Line 209: CMP (4'd8) ERR
@(negedge CLK) begin OPA=5; OPB=3; CMD=4'd8; inp_valid=2'b00; MODE=1; end
compare("CMP_INV00_ERR");
@(negedge CLK) begin OPA=5; OPB=3; CMD=4'd8; inp_valid=2'b01; MODE=1; end
compare("CMP_INV01_ERR");
@(negedge CLK) begin OPA=5; OPB=3; CMD=4'd8; inp_valid=2'b10; MODE=1; end
compare("CMP_INV10_ERR");

// Lines 229,234: SADD (4'd11) ERR
@(negedge CLK) begin OPA=5; OPB=3; CMD=4'd11; inp_valid=2'b00; MODE=1; end
compare("SADD_INV00_ERR");
@(negedge CLK) begin OPA=5; OPB=3; CMD=4'd11; inp_valid=2'b01; MODE=1; end
compare("SADD_INV01_ERR");
@(negedge CLK) begin OPA=5; OPB=3; CMD=4'd11; inp_valid=2'b10; MODE=1; end
compare("SADD_INV10_ERR");

// Lines 239,253: SSUB (4'd12) ERR
@(negedge CLK) begin OPA=5; OPB=3; CMD=4'd12; inp_valid=2'b00; MODE=1; end
compare("SSUB_INV00_ERR");
@(negedge CLK) begin OPA=5; OPB=3; CMD=4'd12; inp_valid=2'b01; MODE=1; end
compare("SSUB_INV01_ERR");
@(negedge CLK) begin OPA=5; OPB=3; CMD=4'd12; inp_valid=2'b10; MODE=1; end
compare("SSUB_INV10_ERR");

// Lines 257,267: LOGICAL AND(4'd0) OR(4'd2) NOR(4'd3) XOR(4'd4) XNOR(4'd5) ERR
@(negedge CLK) begin OPA=5; OPB=3; CMD=4'd0; inp_valid=2'b00; MODE=0; end
compare("LOGIC_AND_INV00_ERR");
@(negedge CLK) begin OPA=5; OPB=3; CMD=4'd0; inp_valid=2'b01; MODE=0; end
compare("LOGIC_AND_INV01_ERR");
@(negedge CLK) begin OPA=5; OPB=3; CMD=4'd0; inp_valid=2'b10; MODE=0; end
compare("LOGIC_AND_INV10_ERR");

@(negedge CLK) begin OPA=5; OPB=3; CMD=4'd1; inp_valid=2'b00; MODE=0; end
compare("LOGIC_NAND_INV00_ERR");
@(negedge CLK) begin OPA=5; OPB=3; CMD=4'd2; inp_valid=2'b00; MODE=0; end
compare("LOGIC_OR_INV00_ERR");
@(negedge CLK) begin OPA=5; OPB=3; CMD=4'd3; inp_valid=2'b00; MODE=0; end
compare("LOGIC_NOR_INV00_ERR");
@(negedge CLK) begin OPA=5; OPB=3; CMD=4'd4; inp_valid=2'b00; MODE=0; end
compare("LOGIC_XOR_INV00_ERR");
@(negedge CLK) begin OPA=5; OPB=3; CMD=4'd5; inp_valid=2'b00; MODE=0; end
compare("LOGIC_XNOR_INV00_ERR");

// Lines 271,275: ROL/ROR ERR (INP_VALID != 11)
@(negedge CLK) begin OPA=8'hAB; OPB=2; CMD=4'd12; inp_valid=2'b00; MODE=0; end
compare("ROL_INV00_ERR");
@(negedge CLK) begin OPA=8'hAB; OPB=2; CMD=4'd12; inp_valid=2'b01; MODE=0; end
compare("ROL_INV01_ERR");
@(negedge CLK) begin OPA=8'hAB; OPB=2; CMD=4'd12; inp_valid=2'b10; MODE=0; end
compare("ROL_INV10_ERR");

@(negedge CLK) begin OPA=8'hAB; OPB=2; CMD=4'd13; inp_valid=2'b00; MODE=0; end
compare("ROR_INV00_ERR");
@(negedge CLK) begin OPA=8'hAB; OPB=2; CMD=4'd13; inp_valid=2'b01; MODE=0; end
compare("ROR_INV01_ERR");
@(negedge CLK) begin OPA=8'hAB; OPB=2; CMD=4'd13; inp_valid=2'b10; MODE=0; end
compare("ROR_INV10_ERR");


$display("=== ROL DEFAULT + ROR MISSING BRANCHES ===");

// ROR missing 'b100 (rotate right by 4)
@(negedge CLK) begin
    OPA=8'b1010_1011; OPB=8'd4;    // OPB[2:0]=100
    CMD=4'd13; inp_valid=2'b11; MODE=0;
end
compare("ROR_BY_4_MISSING_BRANCH");
    #80;
    $finish;
  end
endmodule
