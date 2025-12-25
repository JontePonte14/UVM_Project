//------------------------------------------------------------------------------
// Scoreboard for the TBUVM TB.
//
// This class is an implementation of the scoreboard that monitors the TBUVM
// testbench and checks the behavior of the DUT with regard to the
// serial-to-parallel conversion. It provides the following features:
//
// - Monitors the input serial data and the output parallel data of the DUT.
// - Checks if the output data of the DUT is correct with regard to the
//   input serial data.
// - Checks if the DUT is in the correct state during the transmission of data.
// - Provides functional coverage for the transmission of data and the
//   activation of the DUT's output.
// - Provides error reporting for any errors that are detected during the simulation.
//
// This class is derived from the `uvm_component` class and implements the
// `uvm_analysis_imp_scoreboard_reset`, `uvm_analysis_imp_scoreboard_serial_data`
// and `uvm_analysis_imp_scoreboard_parallel_data` analysis ports.
//
// The functional coverage is provided by the `data_fifo_covergrp`
// coverage group.
//
//------------------------------------------------------------------------------
// Instance analysis defines
import common::*;
import "DPI-C" function void execute_stage_ref(
    input int data1,
    input int data2,
    input int immediate_data,
    input int compflg_in,
    input int alu_op,
    input int alu_src,
    input int encoding,
    output int alu_data,
    output int memory_data,
    output int overflow_flag,
    output int compflg_out
);

`uvm_analysis_imp_decl(_scoreboard_execute_stage)
`uvm_analysis_imp_decl(_scoreboard_out_execute_stage)
class scoreboard extends uvm_component;
    `uvm_component_utils(scoreboard)

    // parallel_data fifo analysis connection
    uvm_analysis_imp_scoreboard_execute_stage #(execute_stage_seq_item, scoreboard) m_execute_stage;
    // data_fifo fifo analysis connection
    uvm_analysis_imp_scoreboard_out_execute_stage #(out_execute_stage_seq_item, scoreboard) m_out_execute_stage;

    /////////////// INPUTS //////////////
    bit [31:0] data1;
    bit [31:0] data2;
    bit [31:0] immediate_data;
    control_type control_in;
    bit compflg_in;
    bit [31:0] program_counter;

    /////////////// OUTPUTS //////////////
    control_type control_out;
    bit [31:0] alu_data;
    bit [31:0] memory_data;
    bit overflow_flag;
    bit compflg_out;


    /////////////// Internal variables //////////////
    int check_counter = 0;
    int error_alu_data = 0;
    int error_memory_data = 0;
    int error_overflow_flag = 0;
    int error_compflg_out = 0;


    //------------------------------------------------------------------------------
    // Functional coverage definitions
    //------------------------------------------------------------------------------
    //covergroup data_fifo_covergrp;
    //    reset : coverpoint reset_value iff (reset_valid) {
    //        bins reset = { 0 };
    //        bins run   = { 1 };
    //    }
    //endgroup
    covergroup covergrp;
        input_comp : coverpoint compflg_in {
            bins active = { 1 };
            bins not_active = { 0 };
        }

	input_data1 : coverpoint data1 {
	    bins zero = { '0 };
	    bins max = { '1 };
    	    bins msb_only = { 32'h80000000 };
	    bins other = { [32'h1 : 32'h7FFF_FFFF],
               [32'h8000_0001 : 32'hFFFF_FFFE] };
	}

	input_data2 : coverpoint data2 {
	    bins zero = { '0 };
	    bins max = { '1 };
    	    bins msb_only = { 32'h80000000 };
	    bins other = { [32'h1 : 32'h7FFF_FFFF],
               [32'h8000_0001 : 32'hFFFF_FFFE] };
	}

	input_immediate_data : coverpoint immediate_data {
	    bins zero = { '0 };
	    bins max = { '1 };
    	    bins msb_only = { 32'h80000000 };
	    bins other = { [32'h1 : 32'h7FFF_FFFF],
               [32'h8000_0001 : 32'hFFFF_FFFE] };
	}

	alu_src : coverpoint control_in.alu_src {
	    bins zero = { 0 };
    	    bins one = { 1 };
	    bins two = { 2 };
    	    bins three = { 3 };
	}

	encoding_types : coverpoint control_in.encoding {
	    bins r_type = { R_TYPE };
	    bins i_type = { I_TYPE };
	    bins s_type = { S_TYPE };
	    bins b_type = { B_TYPE };
	    bins u_type = { U_TYPE };
	    bins j_type = { J_TYPE };
	    bins undefinded = default;
	}

	alu_op : coverpoint control_in.alu_op {
	    bins add = { ALU_ADD };
	    bins sub = { ALU_SUB };
	    bins xor_op = { ALU_XOR };
	    bins or_op  = { ALU_OR };
	    bins and_op = { ALU_AND };
	    bins sll = { ALU_SLL };
	    bins sr  = { ALU_SRL };
	    bins sra = { ALU_SRA };
	    bins slt = { ALU_SLT };
	    bins sltu = { ALU_SLTU };
	    bins undefined = default;
	}

	// Outputs coverpoint
	output_alu_data : coverpoint alu_data {
	    bins zero = { '0 };
	    bins max = { '1 };
    	    bins msb_only = { 32'h80000000 };
	    bins other = default;
	}

	output_memory_data : coverpoint memory_data {
	    bins zero = { '0 };
	    bins max = { '1 };
    	    bins msb_only = { 32'h80000000 };
	    bins other = default;
	}

	overflow : coverpoint overflow_flag  {
	    bins ok = { 0 };
    	    bins overflow = { 1 };
	}

        output_comp : coverpoint compflg_out {
            bins active = { 1 };
            bins not_active = { 0 };
        }

	// Cross coverage
	
	//in_data_cross : cross input_data1, input_immediate_data;
	inout_data_cross : cross input_data1, output_alu_data, input_data2;
	op_cross : cross input_comp, alu_op, encoding_types, alu_src;
	op_data_cross : cross input_data1, input_immediate_data, alu_op;
	
	overflow_cross_add_sub : cross overflow, input_data1, alu_op, input_immediate_data {
	    ignore_bins ign = !binsof(alu_op) intersect {0,1} || !binsof(input_data1.other) || !binsof(input_immediate_data.other);	//Check if overflow happens at add and sub instructions
	}
	overflow_cross_other_op : cross overflow, input_data1, alu_op, input_immediate_data {
	    ignore_bins ign = !binsof(alu_op) intersect {2,9} || !binsof(input_data1) || !binsof(input_immediate_data) || !binsof(overflow.ok);	//Check if overflow happens at add and sub instructions
	}
    endgroup

    

    //------------------------------------------------------------------------------
    // CHECKER - Checks the DUT result with the reference model
    //------------------------------------------------------------------------------
    function void check_result();
    /////////////// EXPECTED OUTPUTS //////////////
        int exp_alu_data;
        int exp_memory_data;
        int exp_overflow_flag;
        int exp_compflg_out;

        int alu_op_int = control_in.alu_op;
        int alu_src_int = control_in.alu_src;
        int encoding_int = control_in.encoding;

	int error_found = 0;
        execute_stage_ref(
            data1,
            data2,
            immediate_data,
            compflg_in,
            alu_op_int,
            alu_src_int,
            encoding_int,
            exp_alu_data,
            exp_memory_data,
            exp_overflow_flag,
            exp_compflg_out
        );
	// Comparing values
        if (alu_data != exp_alu_data) begin
            `uvm_error(get_name(), $sformatf("alu data mismatch!!! DUT=%0d REF=%0d", alu_data, exp_alu_data))
             error_alu_data++;
	     error_found = 1;
    	end

        if (memory_data != exp_memory_data) begin
            `uvm_error(get_name(), $sformatf("memory data mismatch!!! DUT=%0d REF=%0d", memory_data, exp_memory_data))
	    error_memory_data++;
	    error_found = 1;
    	end

        if (overflow_flag != exp_overflow_flag) begin
            `uvm_error(get_name(), $sformatf("overflow signal mismatch!!! DUT=%0d REF=%0d", overflow_flag, exp_overflow_flag))
	    error_overflow_flag++;
	    error_found = 1;
        end

        if (compflg_out != exp_compflg_out) begin
            `uvm_error(get_name(), $sformatf("compressed signal mismatch!!! DUT=%0d REF=%0d", compflg_out, exp_compflg_out))
	    error_compflg_out++;
	    error_found = 1;
        end
	if (error_found == 1) begin
	    $display("	ERROR::INPUT_DATA data1=%0d, data2=%0d, immediate_data=%0d, alu_op_int=%0d, alu_src_int=%0d, encoding_int=%0d, compflg_in=%0d, program_counter=%0d", data1, data2, immediate_data, alu_op_int, alu_src_int, encoding_int, compflg_in, program_counter);
    	    $display("	ERROR::DUT_OUTPUT_DATA alu_data=%0d, memory_data=%0d, overflow_flag=%0d, compflg_out=%0d", alu_data, memory_data, overflow_flag, compflg_out);
    	    $display("	ERROR::REF_OUTPUT_DATA exp_alu_data=%0d, exp_memory_data=%0d, exp_overflow_flag=%0d, exp_compflg_out=%0d", exp_alu_data, exp_memory_data, exp_overflow_flag, exp_compflg_out);
    	end

	check_counter = check_counter + 1;
        $display("check_counter=%0d", check_counter);
	`uvm_info(get_name(),$sformatf("REF result: \nexp_alu_data=%0d \nexp_memory_data=%0d \nexp_overflow_flag=%0d \nexp_compflg_out=%0d", exp_alu_data, exp_memory_data, exp_overflow_flag, exp_compflg_out),UVM_HIGH)
    endfunction

    //------------------------------------------------------------------------------
    // The constructor for the component.
    //------------------------------------------------------------------------------
    function new(string name = "scoreboard", uvm_component parent = null);
        super.new(name,parent);
        // Create coverage group
        //data_fifo_covergrp = new();
        covergrp = new();
	//output_covergrp = new();

	
    endfunction : new

    //------------------------------------------------------------------------------
    // The build for the component.
    //------------------------------------------------------------------------------
    function void build_phase(uvm_phase phase);
        super.build_phase(phase);
        // Create analysis connections
        m_execute_stage = new("m_execute_stage_fido", this);
        m_out_execute_stage = new("m_out_execute_stage_fido", this);
    endfunction : build_phase

    //------------------------------------------------------------------------------
    // The connection phase for the component.
    //------------------------------------------------------------------------------
    virtual function void connect_phase(uvm_phase phase);
        super.connect_phase(phase);
    endfunction : connect_phase

    //------------------------------------------------------------------------------
    // Write implementation for write_execute_stage analyze port.
    //------------------------------------------------------------------------------
    virtual function void write_scoreboard_execute_stage(execute_stage_seq_item item);
        `uvm_info(get_name(),$sformatf("write execute:\n%s",item.sprint()),UVM_HIGH)
        data1 = item.data1;
        data2 = item.data2;
        immediate_data = item.immediate_data;
        control_in = item.control_in;
        compflg_in = item.compflg_in;
        program_counter = item.program_counter;
        //input_covergrp.sample();
    endfunction :  write_scoreboard_execute_stage
    
    //------------------------------------------------------------------------------
    // Write implementation for write_out_execute_stage analyze port.
    // maybe change function signature to just write(...)
    //------------------------------------------------------------------------------
    virtual function void write_scoreboard_out_execute_stage(out_execute_stage_seq_item item);
        `uvm_info(get_name(),$sformatf("write out_execute:\n%s",item.sprint()),UVM_HIGH)
        control_out = item.control_out;
        alu_data = item.alu_data;
        memory_data = item.memory_data;
        overflow_flag = item.overflow_flag;
        compflg_out = item.compflg_out;
        check_result();
        covergrp.sample();
    endfunction :  write_scoreboard_out_execute_stage


    //------------------------------------------------------------------------------
    // UVM check phase
    //------------------------------------------------------------------------------
    virtual function void check_phase(uvm_phase phase);
        super.check_phase(phase);
        // Complete simulation
        $display("*****************************************************");
	//$display("CHECK PHASE");
        $display("Number of checked data %0d", check_counter);
	$display("Number of error alu_data %0d", error_alu_data);
	$display("Number of error memory_data %0d", error_memory_data);
	$display("Number of error overflow_flag %0d", error_overflow_flag);
	$display("Number of error compflg_out %0d", error_compflg_out);
        $display("*****************************************************");
        //if (serial_to_parallel_covergrp.get_coverage() == 100.0) begin
        //    $display("FUNCTIONAL COVERAGE (100.0%%) PASSED....");
        //end
        //else begin
        //    $display("FUNCTIONAL COVERAGE FAILED!!!!!!!!!!!!!!!!!");
        //    $display("Coverage = %0f", serial_to_parallel_covergrp.get_coverage());
        //end
        $display("*****************************************************");
    endfunction : check_phase

endclass : scoreboard
