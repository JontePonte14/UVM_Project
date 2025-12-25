`timescale 1ns / 1ps
import common::*;
// when should overflow occour?
// What is all allowed input signals on control_in? do they have a excel sheet or similar?
// what are the values of immediate data depending on what instruction it is (what control signals are set)? 
// When should data appear on what output (memory_data, alu_data), dependending on how control signals are set?
// What is data1, data2, immediate_data and control_in in the case of compressed instruction? do you have a table?

module execute_stage(
    input clk,
    input reset_n,
    input [31:0] data1,
    input [31:0] data2,
    input [31:0] immediate_data,
    input control_type control_in,
    input logic compflg_in,
    input [31:0] program_counter,
    output control_type control_out,
    output logic [31:0] alu_data,
    output logic [31:0] memory_data,
    output logic overflow_flag,
    output logic compflg_out
);

    logic zero_flag;
    
    logic [31:0] left_operand;
    logic [31:0] right_operand;
    
    
    always_comb begin: operand_selector
        left_operand = data1;
        right_operand = data2;
        case(control_in.alu_src) 
        2'b01: begin
            right_operand = immediate_data;
        end
        2'b10:  begin   //JAL, JALR rd = PC + 4
            case(control_in.encoding)
                J_TYPE: begin
                    left_operand = compflg_in?32'd2 : 32'd4;
                end
                I_TYPE: begin
                    left_operand = compflg_in?32'd2 : 32'd4;
                end
                U_TYPE: begin
                    left_operand = immediate_data << 12; //AUIPC
                end
            endcase
        end
        2'b11: begin   //U-type //LUI
            left_operand = immediate_data;
            right_operand = 32'd0;
        end
        
        default:    begin 
        end
        endcase
    end   
    
    alu inst_alu(
        .control(control_in.alu_op),
        .left_operand(left_operand), 
        .right_operand(right_operand),
        .zero_flag(zero_flag),
        .result(alu_data),
        .overflow_flag(overflow_flag)
    );
    
    assign control_out = control_in;
    assign compflg_out = compflg_in;
    assign memory_data = data2;
    
endmodule