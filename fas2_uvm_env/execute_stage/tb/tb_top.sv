`timescale 1ns / 1ps
import common::*;

module tb_top;

    // Include basic packages
    import uvm_pkg::*;
    `include "uvm_macros.svh"

    // Include optional packages
    import tb_pkg::*;


// DUT inputs
logic        tb_clk;
logic        tb_reset_n;
logic [31:0] tb_data1;
logic [31:0] tb_data2;
logic [31:0] tb_immediate_data;
control_type tb_control_in;
logic        tb_compflg_in;
logic [31:0] tb_program_counter;

// DUT outputs
control_type tb_control_out;
logic [31:0] tb_alu_data;
logic [31:0] tb_memory_data;
logic        tb_overflow_flag;
logic        tb_compflg_out;

// DUT instance
execute_stage dut (
    // CLK AND RESET_N NOT DRIVEN NOW
    .clk             (tb_clk),
    .reset_n         (tb_reset_n),
    .data1           (tb_data1),
    .data2           (tb_data2),
    .immediate_data  (tb_immediate_data),
    .control_in      (tb_control_in),
    .compflg_in      (tb_compflg_in),
    .program_counter (tb_program_counter),
    .control_out     (tb_control_out),
    .alu_data        (tb_alu_data),
    .memory_data     (tb_memory_data),
    .overflow_flag   (tb_overflow_flag),
    .compflg_out     (tb_compflg_out)
);

    // Instantiation of CLOCK uVC interface signal
    clock_if  i_clock_if();
    assign tb_clk = i_clock_if.clock;

        // Instantiation of execute_stage uVC interface signal
    execute_stage_if  i_execute_stage_if(.clk(tb_clk),.rst_n(tb_reset_n));
    assign tb_data1           = i_execute_stage_if.data1;
    assign tb_data2           = i_execute_stage_if.data2;
    assign tb_immediate_data  = i_execute_stage_if.immediate_data;
    assign tb_control_in      = i_execute_stage_if.control_in;
    assign tb_compflg_in      = i_execute_stage_if.compflg_in;
    assign tb_program_counter = i_execute_stage_if.program_counter;


    // Instantiation of out_exectute_stage uVC interface signal
    out_execute_stage_if  i_out_execute_stage_if(.clk(tb_clk),.rst_n(tb_reset_n));
    assign i_out_execute_stage_if.control_out   = tb_control_out;
    assign i_out_execute_stage_if.alu_data      = tb_alu_data;
    assign i_out_execute_stage_if.memory_data   = tb_memory_data;
    assign i_out_execute_stage_if.overflow_flag = tb_overflow_flag;
    assign i_out_execute_stage_if.compflg_out   = tb_compflg_out;

    initial begin
        top_config  m_top_config;
        m_top_config = new("m_top_config");
        uvm_config_db #(top_config)::set(null,"tb_top","top_config", m_top_config);
        m_top_config.m_execute_stage_config.m_vif = i_execute_stage_if;
        m_top_config.m_out_execute_stage_config.m_vif = i_out_execute_stage_if;
        m_top_config.m_clock_config.m_vif = i_clock_if;

    end

    initial begin
        run_test("basic_test");
    end

endmodule

