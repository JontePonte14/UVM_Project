//------------------------------------------------------------------------------
// execute_stage_monitor class
//
// This class is used to monitor the parallel data interface and check its validity.
// It monitors the data_valid and data signals. Before the monitor starts it waits
// for reset is released and every time reset is activated it reset the monitor state.
//
// The class checks if the data_valid signal is asserted, and if so, it creates a new
// execute_stage_seq_item object with the data and parity_error fields filled in.
// The object is then written to the analysis port.
//
//------------------------------------------------------------------------------
class execute_stage_monitor  extends uvm_monitor;
    `uvm_component_param_utils(execute_stage_monitor)

    // execute_stage uVC configuration object.
    execute_stage_config  m_config;
    // Monitor analysis port.
    uvm_analysis_port #(execute_stage_seq_item)  m_analysis_port;

    //------------------------------------------------------------------------------
    // The constructor for the component.
    //------------------------------------------------------------------------------
    function new(string name, uvm_component parent = null);
        super.new(name, parent);
        if (!uvm_config_db #(execute_stage_config)::get(this,"","execute_stage_config", m_config)) begin
            `uvm_fatal(get_name(),"Cannot find the VC configuration!")
        end
        m_analysis_port = new("m_execute_stage_analysis_port", this);
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

        execute_stage_seq_item  seq_item = execute_stage_seq_item::type_id::create("seq_item");
        `uvm_info(get_name(),$sformatf("Starting execute_stage monitor"),UVM_HIGH);
        @(negedge m_config.m_vif.clk);
        forever begin
            @(negedge m_config.m_vif.clk);

            // Create a new execute_stage sequence item with expected data
            `uvm_info(get_name(),$sformatf("Monitor received  \nData1=%0d \nData2=%0d \nImmediate data=%0d \nControl in=%0d \nComplag in=%0d \nProgram counter=%0d",m_config.m_vif.data1, m_config.m_vif.data2, m_config.m_vif.immediate_data, m_config.m_vif.control_in, m_config.m_vif.compflg_in, m_config.m_vif.program_counter),UVM_HIGH)
            
            seq_item.data1= m_config.m_vif.data1;
            seq_item.data2= m_config.m_vif.data2;
            seq_item.immediate_data= m_config.m_vif.immediate_data;
            seq_item.control_in= m_config.m_vif.control_in;
            seq_item.compflg_in= m_config.m_vif.compflg_in;
            seq_item.program_counter= m_config.m_vif.program_counter;

            m_analysis_port.write(seq_item);
    
        end
    endtask : run_phase
endclass : execute_stage_monitor
