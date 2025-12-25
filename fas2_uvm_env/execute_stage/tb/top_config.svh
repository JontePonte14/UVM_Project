//------------------------------------------------------------------------------
// top_config class
//
// Top level configuration object for top level component.
// This class is intended to be used by the UVM configuration database.
//
// It contains the configuration objects for each agent in the system and
// configures them appropriately for the test.
//
//------------------------------------------------------------------------------
class top_config extends uvm_object;
    `uvm_object_param_utils(top_config)
    // clock configuration instance for clock agent uVC.
    clock_config m_clock_config;
    // execute_stage configuration instance for execute_stage agent uVC.
    execute_stage_config m_execute_stage_config;
    out_execute_stage_config m_out_execute_stage_config;


    //------------------------------------------------------------------------------
    // The constructor for the component.
    //------------------------------------------------------------------------------
    function new (string name="top_config");
        super.new(name);
        // Create and configure clock uVC with 10ns clock generation
        m_clock_config = new("m_clock_config");
        m_clock_config.is_active = 1;
        m_clock_config.clock_period = 10;
        // Create and configure data uVC configuration with only monitor
        m_execute_stage_config = new("m_execute_stage_config");
        m_execute_stage_config.is_active = 1;
        m_execute_stage_config.has_monitor = 1;

        // We have no driver, is_active does nothing
        m_out_execute_stage_config = new("m_out_execute_stage_config");
        m_out_execute_stage_config.is_active = 0;
        m_out_execute_stage_config.has_monitor = 1;
    endfunction : new

endclass : top_config
