//------------------------------------------------------------------------------
// parallel_data interface
//
// This parallel data interface is to be used for communication between DUT and TB top
// It includes the following signals:
// - clk: the clock signal for the interface.
// - rst_n: the active-low reset signal for the interface.
// - data_valid: a signal that indicates when data is valid.
// - data: an 8-bit data signal.
// - parity_error: a signal that indicates if there is a parity error in the data.
//
//------------------------------------------------------------------------------
import common::*;

interface out_execute_stage_if (input logic clk, input logic rst_n);
    control_type control_out;
    
    logic [31:0] alu_data;

    logic [31:0] memory_data;

    logic overflow_flag;

    logic compflg_out;

endinterface : out_execute_stage_if
