from enum import Enum


def execute_stage_ref(data1, data2, immediate_data, compflg_in,
                      alu_op, alu_src, encoding):
    # Outputs
    alu_data = 0
    memory_data = data2
    overflow_flag = 0
    compflg_out = compflg_in
    
    # Internal signals
    left_operand = data1
    right_operand = data2
    encoding_in = encoding_type(encoding)

    if (alu_src == 1):
        right_operand = immediate_data
    
    elif (alu_src == 2):
        if ((encoding_in == encoding_type.J_TYPE) or (encoding_in == encoding_type.I_TYPE)): # How is JALR and JAL different?
            left_operand = 2 if compflg_in else 4 

        elif (encoding_in == encoding_type.U_TYPE):
            left_operand = immediate_data << 12 # AUIPC
    
    elif (alu_src == 3): # U-type
        left_operand = immediate_data
        right_operand = 0
    
    alu_data, overflow_flag = _alu(left_operand, right_operand, alu_op)
    return (alu_data, memory_data, overflow_flag, compflg_out)


class encoding_type(Enum):
    R_TYPE = 0
    I_TYPE = 1
    S_TYPE = 2
    B_TYPE = 3
    U_TYPE = 4
    J_TYPE = 5    


class ALU_Op(Enum):
    ADD = 0
    SUB = 1
    XOR = 2
    OR = 3
    AND = 4
    SLL = 5
    SRL = 6
    SRA = 7
    SLT = 8
    SLTU = 9


def _sign_extend(value):
    sign_bit = 1 << 31
    return (value & (sign_bit - 1)) - (value & sign_bit)


def _alu(left_operand, right_operand, op):
    op = ALU_Op(op)
    result = 0
    overflow_flag = False
    left_operand = left_operand & 0xFFFFFFFF
    right_operand = right_operand & 0xFFFFFFFF

    if (op == ALU_Op.ADD):
        result = left_operand + right_operand

        # Overflow detection - Not the same as in SUB
        signed_left = _sign_extend(left_operand)
        signed_right = _sign_extend(right_operand)
        signed_result = _sign_extend(result)

        if ((signed_left >= 0 and signed_right >= 0 and signed_result < 0) 
            or (signed_left < 0 and signed_right < 0 and signed_result >= 0)):
            overflow_flag = True

    elif (op == ALU_Op.SUB):
        result = left_operand - right_operand
        
        # Overflow detection - Not the same as in ADD
        signed_left = _sign_extend(left_operand)
        signed_right = _sign_extend(right_operand)
        signed_result = _sign_extend(result)

        if ((signed_left >= 0 and signed_right < 0 and signed_result < 0) 
            or (signed_left < 0 and signed_right >= 0 and signed_result >= 0)):
            overflow_flag = True

    elif (op == ALU_Op.XOR):
        result = left_operand ^ right_operand

    elif (op == ALU_Op.OR):
        result = left_operand | right_operand

    elif (op == ALU_Op.AND):
        result = left_operand & right_operand

    elif (op == ALU_Op.SLL):
        result = left_operand << (right_operand & 0x1F)

    elif (op == ALU_Op.SRL):
        result = left_operand >> (right_operand & 0x1F)

    elif (op == ALU_Op.SRA):
        result = _sign_extend(left_operand) >> (right_operand & 0x1F)

    elif (op == ALU_Op.SLT):
        result = int (_sign_extend(left_operand) < _sign_extend(right_operand))

    elif (op == ALU_Op.SLTU):
        result = int (left_operand < right_operand)

    else:
        result = left_operand + right_operand
    
    result = result & 0xFFFFFFFF

    return (result, overflow_flag)