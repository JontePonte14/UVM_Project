`timescale 1ns / 1ps

import common::*;


module alu(
    input logic [3:0] control,
    input logic [31:0] left_operand, 
    input logic [31:0] right_operand,
    output logic zero_flag,
    output logic [31:0] result,
    output logic overflow_flag
);
    //logic ovf_tmp;
    always_comb begin
        overflow_flag = 1'b0;
        result = 32'b0;
        case (control)
            ALU_ADD: begin
                result = left_operand + right_operand;
                overflow_flag = ~left_operand[31] & ~right_operand[31] & result[31] | left_operand[31] & right_operand[31] & ~result[31];
            end
            ALU_SUB: begin
                result = left_operand + ~(right_operand) + 1;
                overflow_flag = ~left_operand[31] & right_operand[31] & result[31] | left_operand[31] & right_operand[31] & ~result[31];
            end
            ALU_XOR: result = left_operand ^ right_operand;
            ALU_OR: result = left_operand | right_operand;
            ALU_AND: result = left_operand & right_operand;
            ALU_SLL: result = left_operand << right_operand[4:0];
            ALU_SRL: result = left_operand >> right_operand[4:0];
            ALU_SRA: result = $signed(left_operand) >>> right_operand[4:0];                 // Check this to see if casting done properly $signed
            ALU_SLT: result = $signed(left_operand) < $signed(right_operand) ? 1 : 0;       // Check this to see if casting done properly $signed
            ALU_SLTU: result = left_operand < right_operand ? 1 : 0;
            default: result = left_operand + right_operand;
        endcase
    end
    

    // when x"a" =>
    //       tmp_out <= std_logic_vector(unsigned(A(7)&A) + unsigned(B(7)&B));
    // when x"b" =>
    //       tmp_out <= std_logic_vector(unsigned(A(7)&A) + unsigned(not(B(7)&B)) + 1);
            
  
    assign zero_flag = 1'b1 ? result == 0 : 1'b0;

endmodule