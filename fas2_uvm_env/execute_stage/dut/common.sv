
package common;

    typedef enum logic [3:0] 
    {
        ALU_ADD = 4'b0000,
        ALU_SUB = 4'b0001,
        ALU_XOR = 4'b0010,
        ALU_OR = 4'b0011,
        ALU_AND = 4'b0100,
        ALU_SLL = 4'b0101,
        ALU_SRL = 4'b0110,
        ALU_SRA = 4'b0111,
        ALU_SLT = 4'b1000,
        ALU_SLTU = 4'b1001

    } alu_op_type;
    
    
    typedef enum logic [2:0]
    {
        R_TYPE,
        I_TYPE,
        S_TYPE,
        B_TYPE,
        U_TYPE,
        J_TYPE
    } encoding_type;
    
    typedef enum logic [2:0]
    {
        CR_TYPE,
        CI_TYPE,
        CSS_TYPE,
        CA_TYPE,
        CL_TYPE,
        CS_TYPE,
        CB_TYPE,
        CJ_TYPE
    } compressed_encoding_type;
    
    typedef struct packed
    {
        alu_op_type alu_op;
        encoding_type encoding;
        logic [1:0] alu_src;
        logic mem_read;
        logic mem_write;
        logic reg_write;
        logic mem_to_reg;
        logic is_branch;
        logic [2:0] funct3;
    } control_type;
    
    
    typedef struct packed
    {
        logic [6:0] funct7;
        logic [4:0] rs2;
        logic [4:0] rs1;
        logic [2:0] funct3;
        logic [4:0] rd;
        logic [6:0] opcode;
    } instruction_type;
    
        
    typedef struct  packed
    {
        logic [31:0] pc;
        instruction_type instruction;
        logic compflg;
    } if_id_type;
    
    
    typedef struct packed
    {
        logic [4:0] reg_rd_id;
        logic [31:0] data1;
        logic [31:0] data2;
        logic [31:0] immediate_data;
        control_type control;
        logic compflg;
    } id_ex_type;
    

    typedef struct packed
    {
        logic [4:0] reg_rd_id;
        control_type control;
        logic [31:0] alu_data;
        logic [31:0] memory_data;
        logic compflg;
    } ex_mem_type;
    
    
    typedef struct packed
    {
        logic [4:0] reg_rd_id;
        logic [31:0] memory_data;
        logic [31:0] alu_data;
        control_type control;
    //  logic compflg;
    } mem_wb_type;


    function [31:0] immediate_extension(instruction_type instruction, encoding_type inst_encoding);
        case (inst_encoding)
            I_TYPE: immediate_extension = { {20{instruction.funct7[6]}}, {instruction.funct7, instruction.rs2} };
            S_TYPE: immediate_extension = { {20{instruction.funct7[6]}}, {instruction.funct7, instruction.rd} };
            U_TYPE: immediate_extension = {{instruction.funct7, instruction.rs2, instruction.rs1, instruction.funct3}, {12'd0} };
            B_TYPE: immediate_extension = 
                { {19{instruction.funct7[6]}}, {instruction.funct7[6], instruction.rd[0], instruction.funct7[5:0], instruction.rd[4:1], 1'b0} };
            J_TYPE: immediate_extension = 
                { {11{instruction.funct7[6]}}, {instruction.funct7[6], instruction.rs1, instruction.funct3, instruction.rs2[0],instruction.funct7[5:0], instruction.rs2[4:1]}, 1'b0};
            default: immediate_extension = { {20{instruction.funct7[6]}}, {instruction.funct7, instruction.rs2} };
        endcase 
    endfunction
    
     function logic [31:0] compressed_extension(logic [15:0] instruction, compressed_encoding_type inst_encoding);
        case (inst_encoding)
            CI_TYPE: compressed_extension = {{ 27{instruction[12]}}, instruction[6:2] };
            CSS_TYPE: compressed_extension = { 24'd0, instruction[8:7], instruction[12:9],2'd0 };           //done
    //        CIW_TYPE: compressed_extension = { 22'd0, instruction.inst_data[9:7],instruction.inst_data[12:11], instruction.inst_data[5],instruction.inst_data[6],2'd0 }; //done
            CL_TYPE: compressed_extension = { 25'd0, instruction[5] ,  instruction[12:10], instruction[6], 2'd0};  //done
            CS_TYPE: compressed_extension = { 25'd0, instruction[5] ,  instruction[12:10], instruction[6], 2'd0};  //done
            CB_TYPE: compressed_extension = (instruction[15:13]!=3'b100)?{ {24{instruction[12]}},  {instruction[6:5], instruction[2], instruction[11:10], instruction[4:3]},1'b0}:{ 26'd0,{{instruction[12]}},instruction[6:2]}; //done
            CJ_TYPE: compressed_extension = { {21{instruction[12]}}, instruction[5], instruction[10], instruction[9], instruction[11], instruction[7], instruction[8], instruction[4:2], instruction[6], 1'd0}; // done
            default: compressed_extension = '0;
        endcase
    endfunction
    
endpackage