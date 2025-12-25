//------------------------------------------------------------------------------
// out_execute_stage_monitor class
//
// This class is used to monitor the parallel data interface and check its validity.
// It monitors the data_valid and data signals. Before the monitor starts it waits
// for reset is released and every time reset is activated it reset the monitor state.
//
// The class checks if the data_valid signal is asserted, and if so, it creates a new
// out_execute_stage_seq_item object with the data and parity_error fields filled in.
// The object is then written to the analysis port.
//
//------------------------------------------------------------------------------
class out_execute_stage_monitor  extends uvm_monitor;
    `uvm_component_param_utils(out_execute_stage_monitor)

    // out_execute_stage uVC configuration object.
    out_execute_stage_config  m_config;
    // Monitor analysis port.
    uvm_analysis_port #(out_execute_stage_seq_item)  m_analysis_port;

    //------------------------------------------------------------------------------
    // The constructor for the component.
    //------------------------------------------------------------------------------
    function new(string name, uvm_component parent = null);
        super.new(name, parent);
        if (!uvm_config_db #(out_execute_stage_config)::get(this,"","out_execute_stage_config", m_config)) begin
            `uvm_fatal(get_name(),"Cannot find the VC configuration!")
        end
        m_analysis_port = new("m_out_execute_stage_analysis_port", this);
    endfunction

    //------------------------------------------------------------------------------
    // The build phase for the component.
    //------------------------------------------------------------------------------
    function void build_phase(uvm_phase phase);
        super.build_phase(phase);
    endfunction : build_phase

    //------------------------------------------------------------------------------
    // The run phase for the monitor.
    //------------------------------------------------------------------------------
    task run_phase(uvm_phase phase);
        process check_process;

        out_execute_stage_seq_item  seq_item = out_execute_stage_seq_item::type_id::create("seq_item");
        `uvm_info(get_name(),$sformatf("Starting out_execute_stage monitoring"),UVM_HIGH)
        @(negedge m_config.m_vif.clk);
        forever begin
            @(negedge m_config.m_vif.clk);
            // Create a new execute_stage sequence item with expected data
            `uvm_info(get_name(),$sformatf("Monitor received \nalu_data=%0d \nmemory_data=%0d \noverflow_flag=%0d \ncompflg_out=%0d", m_config.m_vif.alu_data, m_config.m_vif.memory_data, m_config.m_vif.overflow_flag, m_config.m_vif.compflg_out),UVM_HIGH)
            
            seq_item.alu_data= m_config.m_vif.alu_data;
            seq_item.memory_data= m_config.m_vif.memory_data;
            seq_item.overflow_flag= m_config.m_vif.overflow_flag;
            seq_item.compflg_out= m_config.m_vif.compflg_out;

            m_analysis_port.write(seq_item);
    
        end
    endtask : run_phase
endclass : out_execute_stage_monitor
