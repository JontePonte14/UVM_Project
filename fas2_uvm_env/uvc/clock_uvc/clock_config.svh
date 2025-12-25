//------------------------------------------------------------------------------
// clock_config class
//
// The configuration of clock.
// This class contains the configuration of clock, and the virtual interface.
//
// The configuration of clock includes:
//  is_active - indicate whether the sequencer and driver are activated.
//  clock_period - the clock period.
//
// The virtual interface includes:
//  m_vif - the clock uVC virtual clock_if interface.
//
//------------------------------------------------------------------------------
class clock_config extends uvm_object;

    // The Sequencer and driver are activated
    bit is_active=1;
    // The clock period
    int unsigned  clock_period=100;
    // clock uVC virtual CLOCK_IF interface.
    virtual clock_if  m_vif;

    `uvm_object_utils_begin(clock_config)
    `uvm_field_int(is_active,UVM_ALL_ON|UVM_DEC)
    `uvm_field_int(clock_period,UVM_ALL_ON|UVM_DEC)
    `uvm_object_utils_end

    //------------------------------------------------------------------------------
    // The constructor for the component.
    //------------------------------------------------------------------------------
    function new (string name = "clock_config");
        super.new(name);
    endfunction : new

endclass : clock_config
