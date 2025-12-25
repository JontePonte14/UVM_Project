//------------------------------------------------------------------------------
// clock_driver class
//
// This class generates a clock at a given period.
//
// The configuration object for this class is clock_config. It must be
// passed in through the uvm_config_db at the creation of this component.
//
//------------------------------------------------------------------------------
class clock_driver extends uvm_driver;
    `uvm_component_utils(clock_driver)

    // CLOCK uVC configuration object.
    clock_config  m_config;

    //------------------------------------------------------------------------------
    // The constructor for the component.
    //------------------------------------------------------------------------------
    function new(string name, uvm_component parent = null);
        super.new(name, parent);
        if (!uvm_config_db #(clock_config)::get(this,"","clock_config", m_config)) begin
            `uvm_fatal(get_name(),"Cannot find the VC configuration!")
        end
    endfunction

    //------------------------------------------------------------------------------
    // The build phase for the component.
    //------------------------------------------------------------------------------
    function void build_phase(uvm_phase phase);
        super.build_phase(phase);
    endfunction : build_phase

    //------------------------------------------------------------------------------
    // The run phase for the component.
    //------------------------------------------------------------------------------
    virtual task run_phase(uvm_phase phase);
        // Perform the requested action and send response back.
        `uvm_info("clock_driver",$sformatf("Start clock with period %0d", m_config.clock_period),UVM_MEDIUM)
        // Reset signal
        m_config.m_vif.clock <= 0;
        // Generate clock
        forever begin
            #(m_config.clock_period/2);
            m_config.m_vif.clock <= ~m_config.m_vif.clock;
        end
    endtask : run_phase

endclass : clock_driver
