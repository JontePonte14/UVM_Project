//------------------------------------------------------------------------------
// out_execute_stage_agent class
//
// This is the top-level uVC agent for the execute_stage interface.
//
// It reads the uvc configuration from the uvm config database and sets the
// configuration in the uvc driver. It creates the driver if the configuration
// is active and the creates monitor if the configuration has_monitor enabled.
//
//------------------------------------------------------------------------------
class out_execute_stage_agent  extends uvm_agent;
    `uvm_component_param_utils(out_execute_stage_agent)

    // uVC monitor.
    out_execute_stage_monitor m_monitor;
    // uVC configuration object.
    out_execute_stage_config m_config;

    //------------------------------------------------------------------------------
    // The constructor for the component.
    //------------------------------------------------------------------------------
    function new(string name = "", uvm_component parent = null);
        super.new(name, parent);
    endfunction : new
    
    //------------------------------------------------------------------------------
    // The build phase for the uVC.
    //------------------------------------------------------------------------------
    function void build_phase(uvm_phase phase);
        super.build_phase(phase);
        // Read the uVC configuration object from UVM config DB.
        if (!uvm_config_db #(out_execute_stage_config)::get(this,"*","config",m_config)) begin
            `uvm_fatal(get_name(),"Cannot find <config> agent configuration!")
        end
        // Store uVC configuration into UVM config DB used by the uVC.
        uvm_config_db #(out_execute_stage_config)::set(this,"*","out_execute_stage_config",m_config);
        // Store uVC agent into UVM config DB
        if (m_config.is_active == UVM_ACTIVE) begin

        end
        if (m_config.has_monitor) begin
            // Create uVC monitor
            m_monitor = out_execute_stage_monitor::type_id::create("out_execute_stage_monitor",this);
        end
    endfunction : build_phase

    //------------------------------------------------------------------------------
    // The connection phase for the uVC.
    //------------------------------------------------------------------------------
    function void connect_phase(uvm_phase phase);
        super.connect_phase(phase);
        // If driver active connect then sequencer to the driver.
        if (m_config.is_active == UVM_ACTIVE) begin
            //m_driver.seq_item_port.connect(m_sequencer.seq_item_export);
        end
    endfunction : connect_phase

    //------------------------------------------------------------------------------
    // The end of elaboration phase for the uVC
    //------------------------------------------------------------------------------
    function void end_of_elaboration_phase(uvm_phase phase);
        super.end_of_elaboration_phase(phase);
        `uvm_info(get_name(),$sformatf("out_execute_stage agent is alive...."), UVM_LOW)
    endfunction : end_of_elaboration_phase
  
endclass: out_execute_stage_agent

