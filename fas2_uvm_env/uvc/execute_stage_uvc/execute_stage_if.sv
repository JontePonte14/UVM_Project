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

interface execute_stage_if (input logic clk, input logic rst_n);

    logic [31:0] data1;

    logic [31:0] data2;

    logic [31:0] immediate_data;

    control_type control_in;

    logic compflg_in;

    logic [31:0] program_counter;
endinterface : execute_stage_if
