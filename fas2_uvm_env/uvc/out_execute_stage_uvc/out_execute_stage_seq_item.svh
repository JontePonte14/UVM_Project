//------------------------------------------------------------------------------
// out_execute_stage_seq_item class
//
// This class represents a sequence item for parallel data transmission.
// 
// A sequence item contains:
// - start_delay: clock delay before sending data
// - data: the data to be sent
// - parity_error: indicates if a parity error occurred during transmission
// 
//------------------------------------------------------------------------------
class out_execute_stage_seq_item extends uvm_sequence_item;

    rand bit [31:0] alu_data;
    rand bit [31:0] memory_data;
    rand bit overflow_flag;
    rand bit compflg_out;
    rand control_type control_out;

    // Specify how variables shall be printed out
    `uvm_object_utils_begin(out_execute_stage_seq_item)
    `uvm_field_int(alu_data,UVM_ALL_ON|UVM_DEC)
    `uvm_field_int(memory_data,UVM_ALL_ON|UVM_DEC)
    `uvm_field_int(overflow_flag,UVM_ALL_ON|UVM_DEC)
    `uvm_field_int(compflg_out,UVM_ALL_ON|UVM_DEC)
    `uvm_object_utils_end

    //------------------------------------------------------------------------------
    // The constructor for the component.
    //------------------------------------------------------------------------------
    function new (string name = "out_execute_stage_seq_item");
        super.new(name);
    endfunction : new

endclass : out_execute_stage_seq_item
