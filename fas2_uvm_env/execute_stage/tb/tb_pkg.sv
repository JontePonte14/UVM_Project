//------------------------------------------------------------------------------
// Testbench package.
//
// The tb_pkg package provides a collection of files and
// uVCs that are used for testbench development
//
// It includes:
// - Clock uVC
// - Reset uVC
// - Serial Data uVC
// - Parallel Data uVC
// - Test Environment
// - Scoreboard
// - Tests
//
// The package also imports the UVM package and includes
// the necessary UVM macros to support UVM-based testbenches
//
//------------------------------------------------------------------------------
`timescale 1ns/1ns 
package tb_pkg;
    // Import from UVM package
    import uvm_pkg::*;
    `include "uvm_macros.svh"
    // Include files from the clock uVC
    `include "clock_config.svh"
    `include "clock_driver.svh"
    `include "clock_agent.svh"
    // Include files from the parallel data uVC
    `include "execute_stage_seq_item.svh"
    `include "execute_stage_seq.svh"
    `include "execute_stage_config.svh"
    `include "execute_stage_driver.svh"
    `include "execute_stage_monitor.svh"
    `include "execute_stage_agent.svh"
    // Include files from the data fifo uVC
    `include "out_execute_stage_seq_item.svh"
    `include "out_execute_stage_config.svh"
    `include "out_execute_stage_monitor.svh"
    `include "out_execute_stage_agent.svh"
    // Include files from the TB
    `include "scoreboard.svh"
    `include "top_config.svh"
    `include "tb_env.svh"
    `include "base_test.svh"
    `include "basic_test.svh"
endpackage: tb_pkg
