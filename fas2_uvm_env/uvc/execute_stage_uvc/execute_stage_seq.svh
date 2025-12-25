//------------------------------------------------------------------------------
// execute_stage_seq class
//
// This sequence is used to generate random parallel data with/without parirt error.
//
// The sequence has two constraints on the start bit delay and start bit length.
// The start delay must be less than 256 clocks,
// The parity error should only be weighted about 1 per 10 times data.
//
//------------------------------------------------------------------------------
import common::*;

class execute_stage_seq extends uvm_sequence #(execute_stage_seq_item);
    `uvm_object_utils(execute_stage_seq)

    rand bit [31:0] data1;
    rand bit [31:0] data2;
    rand bit [31:0] immediate_data;
    rand control_type control_in;
    rand bit compflg_in;
    rand bit [31:0] program_counter;

    // set optional constraints
	constraint c {
	  data1 dist {
	    32'h0000_0000 :/ 1,
            32'hFFFF_FFFF :/ 1,
	    32'h8000_0000 :/ 1,
	    [32'h0000_0001 : 32'hFFFF_FFFE] :/ 4
	  };
	  data2 dist {
	    32'h0000_0000 :/ 1,
            32'hFFFF_FFFF :/ 1,
	    32'h8000_0000 :/ 1,
	    [32'h0000_0001 : 32'hFFFF_FFFE] :/ 4
	  };
	  immediate_data dist {
	    32'h0000_0000 :/ 1,
            32'hFFFF_FFFF :/ 1,
	    32'h8000_0000 :/ 1,
	    [32'h0000_0001 : 32'hFFFF_FFFE] :/ 4
	  };
	}
	constraint control_c {
            control_in.alu_op <= 9;  
	    control_in.encoding <= 5;          
        }

    //------------------------------------------------------------------------------
    // The constructor for the sequence.
    //------------------------------------------------------------------------------
    function new(string name="execute_stage_seq");
        super.new(name);
    endfunction : new

    //------------------------------------------------------------------------------
    // The main task to be executed within the sequence.
    //------------------------------------------------------------------------------
    task body();
        // Create sequence
        req = execute_stage_seq_item::type_id::create("req");
        // Wait for sequencer ready
        start_item(req);
        // Randomize sequence item
        if (!(req.randomize() with {
            req.data1 == local::data1;
            req.data2 == local::data2;
            req.immediate_data == local::immediate_data;
            req.control_in == local::control_in;
            req.compflg_in == local::compflg_in;
            req.program_counter == local::program_counter;
        })) `uvm_fatal(get_name(), "Failed to randomize")
        // Send to sequencer
        finish_item(req);
        // Wait until request is completed
        get_response(rsp, req.get_transaction_id());
    endtask : body

endclass : execute_stage_seq
