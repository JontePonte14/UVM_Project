//------------------------------------------------------------------------------
// execute_stage_seq_item class
//
// This class represents a sequence item for parallel data transmission.
// 
// A sequence item contains:
// - start_delay: clock delay before sending data
// - data: the data to be sent
// - parity_error: indicates if a parity error occurred during transmission
// 
//------------------------------------------------------------------------------
import common::*;

class execute_stage_seq_item extends uvm_sequence_item;

    rand bit [31:0] data1;
    rand bit [31:0] data2;
    rand bit [31:0] immediate_data;
    rand control_type control_in;
    rand bit compflg_in;
    rand bit [31:0] program_counter;

    // Specify how variables shall be printed out
    `uvm_object_utils_begin(execute_stage_seq_item)
    `uvm_field_int(data1,UVM_ALL_ON|UVM_DEC)
    `uvm_field_int(data2,UVM_ALL_ON|UVM_DEC)
    `uvm_field_int(immediate_data,UVM_ALL_ON|UVM_DEC)
    `uvm_field_int(control_in,UVM_ALL_ON|UVM_DEC)
    `uvm_field_int(compflg_in,UVM_ALL_ON|UVM_DEC)
    `uvm_field_int(program_counter,UVM_ALL_ON|UVM_DEC)
    `uvm_object_utils_end

    //------------------------------------------------------------------------------
    // The constructor for the component.
    //------------------------------------------------------------------------------
    function new (string name = "execute_stage_seq_item");
        super.new(name);
    endfunction : new

endclass : execute_stage_seq_item
