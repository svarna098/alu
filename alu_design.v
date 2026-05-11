 //`timescale 1ns / 1ps
/*
module Eight_bit_ALU_rtl_design #(
    parameter width = 8, 
    parameter cmd_width = 4, 
    parameter out_width = 2*width
) (
    input [(width-1):0] OPA, OPB,
    input CLK, RST, CE, MODE, CIN,
    input [1:0] inp_valid,
    input [(cmd_width-1):0] CMD,
    
    output reg [(out_width-1):0] RES,
    output reg COUT, OFLOW, G, E, L, ERR
);
    
    reg signed [(out_width-1):0] temp_signed;
    reg [(out_width-1):0] temp_res;
    reg temp_cout, temp_oflow, temp_g, temp_e, temp_l, temp_err;
    reg signed [width-1:0] A_signed, B_signed;
    reg[3:0] count = 1;
    reg [3:0] count1 = 1;
    
    // --- Sequential Logic: Output Registering ---
    always @(posedge CLK or posedge RST) begin
        if (RST) begin
            RES <= 0; COUT <= 0; OFLOW <= 0; G <= 0; E <= 0; L <= 0; ERR <= 0;
        end else if (CE) begin
            if (MODE && (CMD == 4'b1001)) begin
                if (count == 3) begin 
                RES <= temp_res; 
                ERR <= temp_err; end
                else if(count == 2) 
                RES <= {out_width{1'bx}};
            end 
            else if (MODE && (CMD == 4'b1010)) begin
                if (count1 == 3) begin 
                RES <= temp_res;
                 ERR <= temp_err; end
                else if(count1 == 2) 
                RES <= {out_width{1'bx}};
            end
            
            else begin
                RES   <= temp_res;
                COUT  <= temp_cout;
                OFLOW <= temp_oflow;
                G     <= temp_g;
                E     <= temp_e;
                L     <= temp_l;
                ERR   <= temp_err;
            end
        end
    end

    always @(*) begin
        temp_res = 0;
         temp_cout = 0;
          temp_oflow = 0;
        temp_g = 0;
         temp_e = 0; 
         temp_l = 0; 
         temp_err = 0;
        temp_signed = 0;
        A_signed = 0;
         B_signed = 0;

        if (MODE) begin
            case (CMD)
                4'b0000: begin // CMD 0: ADD
                    if(inp_valid == 2'b11) begin
                        temp_res = OPA + OPB;
                        temp_cout = temp_res[width]; 
                    end else temp_err = 1'b1;
                end
                
                4'b0001: begin // CMD 1: SUB
                    if(inp_valid == 2'b11) begin
                        temp_res = OPA - OPB;
                        temp_oflow = (OPA < OPB);
                    end else temp_err = 1'b1;
                end
                
                4'b0010: begin // CMD 2: ADD_CIN
                    if(inp_valid == 2'b11) begin
                        temp_res = OPA + OPB + CIN;
                        temp_cout = temp_res[width];
                    end else temp_err = 1'b1;
                end
                
                4'b0011: begin // CMD 3: SUB_CIN
                    if(inp_valid == 2'b11) begin
                        temp_res = OPA - OPB - CIN;
                        temp_oflow = (OPA < (OPB + CIN));
                    end else temp_err = 1'b1;
                end
                4'b0100: if(inp_valid[0]) temp_res = OPA + 1'b1; else temp_err = 1'b1;
                4'b0101: if(inp_valid[0]) temp_res = OPA - 1'b1; else temp_err = 1'b1;
                4'b0110: if(inp_valid[1]) temp_res = OPB + 1'b1; else temp_err = 1'b1;
                4'b0111: if(inp_valid[1]) temp_res = OPB - 1'b1; else temp_err = 1'b1;
                4'b1000: if(inp_valid == 2'b11) begin
                            temp_e = (OPA == OPB); 
                            temp_g = (OPA > OPB); 
                            temp_l = (OPA < OPB);
                         end else temp_err = 1'b1;
                4'b1001: if(inp_valid == 2'b11) 
                                temp_res = (OPA + 1'b1) * (OPB + 1'b1); 
                            else
                                temp_err = 1'b1;
                4'b1010: if(inp_valid == 2'b11) 
                                temp_res = (OPA << 1) * OPB;
                            else
                                temp_err = 1'b1;
                4'b1011: if(inp_valid == 2'b11) begin 
                            A_signed = OPA; 
                            B_signed = OPB;
                            temp_signed = A_signed + B_signed;
                            temp_res = temp_signed;
                            if(A_signed[width-1] ==B_signed[width-1] && temp_res[width-1] !=A_signed[width-1]) begin
                                 temp_oflow = 1'b1; end
                            temp_e = (A_signed == B_signed);
                            temp_l = (A_signed < B_signed);
                            temp_g = (A_signed > B_signed);
                         end 
                         else
                             temp_err = 1'b1;
                4'b1100: if(inp_valid == 2'b11) begin 
                            A_signed = OPA;
                             B_signed = OPB;
                            temp_signed = A_signed - B_signed; 
                            temp_res = temp_signed;
                            if(A_signed[width-1] !=B_signed[width-1] && temp_res[width-1] !=A_signed[width-1]) begin
                                  temp_oflow = 1'b1; end
                            temp_e = (A_signed == B_signed);
                            temp_l = (A_signed < B_signed);
                            temp_g = (A_signed > B_signed);
                         end
                          else 
                            temp_err = 1'b1;
                default: temp_err = 1'b1;
            endcase
        end 
        else begin
            case (CMD)
                4'b0000: if(inp_valid == 2'b11) 
                             temp_res = {{width{1'b0}}, OPA & OPB};
                         else
                             temp_err = 1'b1;
                4'b0001: if(inp_valid == 2'b11)
                             temp_res = {{width{1'b0}}, ~(OPA & OPB)}; 
                         else
                             temp_err = 1'b1;
                4'b0010: if(inp_valid == 2'b11)
                             temp_res = {{width{1'b0}}, OPA | OPB};
                         else   
                             temp_err = 1'b1;
                4'b0011: if(inp_valid == 2'b11)
                             temp_res = {{width{1'b0}}, ~(OPA | OPB)};
                         else
                             temp_err = 1'b1;
                4'b0100: if(inp_valid == 2'b11) 
                             temp_res = {{width{1'b0}}, OPA ^ OPB};
                         else
                             temp_err = 1'b1;
                4'b0101: if(inp_valid == 2'b11)
                             temp_res = {{width{1'b0}}, ~(OPA ^ OPB)};
                         else
                             temp_err = 1'b1;
                4'b0110: if(inp_valid[0])
                             temp_res = {{width{1'b0}}, ~OPA};
                         else   
                             temp_err = 1'b1;
                4'b0111: if(inp_valid[1])
                             temp_res = {{width{1'b0}}, ~OPB}; 
                         else
                             temp_err = 1'b1;
                4'b1000: if(inp_valid[0])
                             temp_res = {{width{1'b0}}, OPA >> 1};
                         else
                             temp_err = 1'b1;
                4'b1001: if(inp_valid[0])
                             temp_res = {{width{1'b0}}, OPA << 1}; 
                        else
                             temp_err = 1'b1;
                4'b1010: if(inp_valid[1])
                             temp_res = {{width{1'b0}}, OPB >> 1};
                        else
                             temp_err = 1'b1;
                4'b1011: if(inp_valid[1])
                             temp_res = {{width{1'b0}}, OPB << 1};
                        else    
                             temp_err = 1'b1;
                4'b1100: if(inp_valid == 2'b11) begin
            if  (OPB >> 4)
             temp_err = 1'b1; 
            else 
              temp_res = {{width{1'b0}}, (OPA << OPB[2:0]) | (OPA >> (width - OPB[2:0]))};
         end
          else 
               temp_err = 1'b1;
4'b1101: if(inp_valid == 2'b11) begin
            if (OPB >> 4)
              temp_err = 1'b1; 
            else 
              temp_res = {{width{1'b0}}, (OPA >> OPB[2:0]) | (OPA << (width - OPB[2:0]))};
         end 
         else
              temp_err = 1'b1;
                default: temp_err = 1'b1;
            endcase
        end
    end

    always @(posedge CLK or posedge RST) begin
        if (RST) count <= 1;
        else if (CE && MODE && CMD == 4'b1001)
             count <= (count >= 3) ? 1 : count + 1;
        else count <= 1;
    end

    always @(posedge CLK or posedge RST) begin
        if (RST) count1 <= 1;
        else if (CE && MODE && CMD == 4'b1010)
             count1 <= (count1 >= 3) ? 1 : count1 + 1;
        else count1 <= 1;
    end

endmodule*/
// ALU_DESIGN

module alu_design #(
//PARAMETERS
parameter A = 8,
parameter B = 8,
parameter C = 4
)
//INPUT OUTPUTS
(
	//Contoelpins
	input wire CLK, RST,
	input wire [1:0]INP_VALID,//00_no 01_A 10_B 11_AB VALIDD
	input wire MODE,// 1 arithmetic 0 logical
	input wire [C-1:0]CMD,
	input wire CE,
	
	// Data pins
	input wire [A-1:0]OPA, 
	input wire [B-1:0]OPB,
	input wire CIN,
	
	// Outputs
	output reg ERR,
	output reg [(A+B)-1:0]RES,
	output reg OFLOW,COUT,G,L,E
);

//Count reg
	reg [1:0]cnt_9 =0;
	reg [1:0]cnt_10 =0;

//temp variables
reg [A-1:0]OPA_1;
reg [B-1:0]OPB_1;
reg [A-1:0]OPA_L1;

	//signed reg
	wire signed [A-1:0]sOPA = OPA;
	wire signed [B-1:0]sOPB = OPB;
	//signes calculus
	wire signed [A-1:0] s_add = sOPA + sOPB;
	wire signed [A-1:0] s_sub = sOPA - sOPB;

always@(posedge CLK or posedge RST)
begin

	if (RST)				// 1st priority
	begin
		ERR <= 0;
		RES <= 0;
		COUT <= 0;
		OFLOW <= 0;
		G <= 0;	L <= 0;	E <= 0;
		cnt_9 <= 0;
		cnt_10 <= 0;
	end
	else if (CE)			// 2nd priority
	begin
			G <= 0;	L <= 0;	E <= 0;
			OFLOW <= 0;
			COUT <= 0;
			ERR <= 0;
			RES <= 0;
		
		if (MODE)			// 3rd priority
		// MODE HIGH ARITHMETIC
		begin
			case (CMD)
				4'd0	:	begin	//ADD
								if (INP_VALID == 2'b11)
									{COUT,RES[A-1:0]} <= OPA + OPB;
								else begin	RES <= 0;	ERR <= 1;	end
							end
				4'd1	:	begin	//SUB
								if (INP_VALID == 2'b11)
								begin
									if(OPB > OPA)
									begin
										OFLOW <= 1;
										RES[A-1:0] <= OPA - OPB;
									end
									else
										RES[A-1:0] <= OPA - OPB;
								end
								else
									begin	ERR <= 1;	RES <= 0;	end
							end
				4'd2	:	begin 	//ADD_CIN
								if (INP_VALID == 2'b11)
									{COUT,RES[A-1:0]} <= OPA + OPB + CIN;
								else begin	ERR <= 1;	RES <= 0;	end
							end
				4'd3	:	begin	//SUB_CIN
								if (INP_VALID == 2'b11)
								begin
									if((OPB + CIN) > OPA)
									begin
										OFLOW <= 1;
										RES[A-1:0] <= OPA - OPB - CIN;
									end
									else
										RES[A-1:0] <= OPA - OPB - CIN;
								end	
								else begin	ERR <= 1;	RES <= 0;	end
							end
				4'd4	:	begin 	//INC_A
								if (INP_VALID == 2'b11 || INP_VALID == 2'b01)
									RES[A-1:0] <= OPA + 1;
								else begin	ERR <= 1;	RES <= 0;	end
							end
				4'd5	:	begin	//DEC_A
								if (INP_VALID == 2'b11 || INP_VALID == 2'b01)
									RES[A-1:0] <= OPA - 1;
								else begin	ERR <= 1; 	RES <= 0;	end
							end
				4'd6	:	begin 	//INC_B
								if (INP_VALID == 2'b11 || INP_VALID == 2'b10)
									RES[A-1:0] <= OPB + 1;
								else begin ERR <= 1;	RES <= 0;	end
							end
				4'd7	:	begin	//DEC_B
								if (INP_VALID == 2'b11 || INP_VALID == 2'b10)
									RES[A-1:0] <= OPB - 1;
								else begin	ERR <= 1;	RES <= 0;	end
							end
				4'd8	:	begin	//CMP
								if (INP_VALID == 2'b11)
									begin
										E <= (OPA == OPB);
										L <= (OPA < OPB);
										G <= (OPA > OPB);
										RES <= 0;
									end
								else begin	ERR <= 1;	RES <= 0;	end
							end
				4'd9	:	begin	// A+1 B+1 nA * nB
								if (INP_VALID == 2'b11)
								begin
									if (cnt_9 == 0) 	begin cnt_9 <= cnt_9 +1;	end
									else if (cnt_9 == 1)	begin	OPA_1 <= OPA + 1; OPB_1 <= OPB + 1; 	cnt_9 <= cnt_9 +1;	end
									else if (cnt_9 == 2)	begin	RES <= OPA_1 * OPB_1; 	cnt_9 <= 0;	end
									else cnt_9 <= 0;
								end
								else begin 	ERR <= 1; 	RES <= 0;	end
							end
				4'd10	:	begin	// A<<1 nA * B
								if (INP_VALID == 2'b11)
								begin
									if (cnt_10 == 0) 	begin cnt_10 <= cnt_10 +1;	end
									else if (cnt_10 == 1)	begin	OPA_L1 <= OPA << 1; 	cnt_10 <= cnt_10 +1;	end
									else if (cnt_10 == 2)	begin	RES <= OPA_L1 * OPB; 	cnt_10 <= 0;	end
									else cnt_10 <= 0;
								end
								else begin	ERR <= 1;	RES <= 0;	end
							end
				4'd11	:	begin	//A n B signed A+B
								if( INP_VALID == 2'b11)
									begin
										RES[A-1:0] <= s_add;
										OFLOW <= ( (OPA[A-1] == OPB[A-1]) && (s_add[A-1] != OPA[A-1]) );
									end// msb opa = msb opb msb opa is not equal msb res then oflow high
								else	begin	ERR <= 1;	RES <= 0;	end
							end
				4'd12	:	begin	//A n B signed A-B
								if( INP_VALID == 2'b11)
									begin
										RES[A-1:0] <= s_sub;
										OFLOW <= ( (OPA[A-1] != OPB[A-1]) && (s_sub[A-1] != OPA[A-1]) );
									end// msb opa ~= msb opb msb opa is not equal msb res then oflow high
								else	begin	ERR <= 1;	RES <= 0;	end
							end	
				default	:	begin ERR <= 1; RES <= 0;	end
			endcase
		end
		else
		// MODE LOW LOGICAL
		begin
			case (CMD)
				4'd0	:	begin 	//AND
								if (INP_VALID == 2'b11)
									RES <= OPA & OPB;
								else begin	ERR <= 1;	RES <= 0;	end
							end
				4'd1	:	begin	//NAND
								if (INP_VALID == 2'b11)
									RES <= ~(OPA & OPB);
								else	begin	ERR <= 1;	RES <= 0;	end
							end
				4'd2	:	begin	//OR
								if (INP_VALID == 2'b11)
									RES <= OPA | OPB;
								else begin 	ERR <= 1;	RES <= 0;	end
							end
				4'd3	:	begin 	//NOR
								if (INP_VALID == 2'b11)
									RES <= ~(OPA | OPB);
								else begin 	ERR <= 1;	RES <= 0;	end
							end
								
				4'd4	:	begin	//XOR
								if (INP_VALID == 2'b11)
									RES <= OPA ^ OPB;
								else begin	ERR <= 1;	RES <= 0;	end
							end
				4'd5	:	begin	//XNOR
								if (INP_VALID == 2'b11)
									RES <= ~(OPA ^ OPB);
								else begin	ERR <= 1;	RES <= 0;	end
							end
				4'd6	:	begin	//NOT_A
								if (INP_VALID == 2'b11 || INP_VALID == 2'b01)
									RES <= ~OPA;
								else begin	ERR <= 1;	RES <= 0;	end
							end
				4'd7	:	begin 	//NOT_B
								if (INP_VALID == 2'b11 || INP_VALID == 2'b10)
									RES <= ~OPB;
								else begin	ERR <= 1;	RES <= 0;	end
							end
				4'd8	:	begin	//SHR1_A
								if (INP_VALID == 2'b11 || INP_VALID == 2'b01)
									RES <= OPA >> 1;
								else begin	ERR <= 1;	RES <= 0;	end
							end
				4'd9	:	begin	//SHL1_A
								if (INP_VALID == 2'b11 || INP_VALID == 2'b01)
									RES <= OPA << 1;
								else begin	ERR <= 1;	RES <= 0;	end
							end
				4'd10	:	begin	//SHR1_B
								if (INP_VALID == 2'b11 || INP_VALID == 2'b10)
									RES <= OPB >> 1;
								else begin	ERR <= 1;	RES <= 0;	end
							end
				4'd11	:	begin	//SHL1_B
								if (INP_VALID == 2'b11 || INP_VALID == 2'b10)
									RES <= OPB << 1;
								else begin	ERR <= 1;	RES <= 0;	end
							end
				4'd12	:	begin	//ROL_A_B
								if (INP_VALID == 2'b11)
								begin
									casez(OPB[2:0])
										'b000	:	RES[A-1:0] <= OPA;
										'b001	:	RES[A-1:0] <= {OPA[A-2:0],OPA[A-1]};
										'b010	:	RES[A-1:0] <= {OPA[A-3:0],OPA[A-1:A-2]};
										'b011	:	RES[A-1:0] <= {OPA[A-4:0],OPA[A-1:A-3]};
										'b100	:	RES[A-1:0] <= {OPA[A-5:0],OPA[A-1:A-4]};
										'b101	:	RES[A-1:0] <= {OPA[A-6:0],OPA[A-1:A-5]};
										'b110	:	RES[A-1:0] <= {OPA[A-7:0],OPA[A-1:A-6]};
										'b111	:	RES[A-1:0] <= {OPA[A-8:0],OPA[A-1:A-7]};
										default :	RES[A-1:0] <= 0;
							         endcase
									ERR <= (OPB[7:4])?1:0;
							     end
								else	begin	ERR <= 1; RES <= 0; end
					       end
				4'd13	:	begin	//ROR_A_B
								if (INP_VALID == 2'b11)
								begin
									casez(OPB[2:0])
										'b000	:	RES[A-1:0] <= OPA;										
										'b001 : RES[A-1:0] <= {OPA[0],   OPA[A-1:1]};
										'b010 : RES[A-1:0] <= {OPA[1:0], OPA[A-1:2]};
										'b011 : RES[A-1:0] <= {OPA[2:0], OPA[A-1:3]};
										'b100 : RES[A-1:0] <= {OPA[3:0], OPA[A-1:4]};
										'b101 : RES[A-1:0] <= {OPA[4:0], OPA[A-1:5]};
										'b110 : RES[A-1:0] <= {OPA[5:0], OPA[A-1:6]};
										'b111 : RES[A-1:0] <= {OPA[6:0], OPA[A-1:7]};
										default :	RES[A-1:0] <= 0;
							         endcase
									ERR <= (OPB[7:4])?1:0;
							     end
								else	begin	ERR <= 1; RES <= 0; end
							end
				default	:	begin 	ERR <= 1; RES <= 0;	end
			endcase	
		end
end
end
endmodule
 
