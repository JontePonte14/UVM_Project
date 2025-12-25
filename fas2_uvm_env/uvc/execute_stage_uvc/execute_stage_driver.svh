//------------------------------------------------------------------------------
// execute_stage_driver class
//
// This class represents the driver for the parallel data interface.
// The driver handles the generation of parallel data transactions.
//
// The driver has the following functionality:
// - Get sequence item from the interface's sequencer
// - Perform the requested action and send response back.
// - Write data and set data valid signal
// - Wait one clock cycle with data valid 
//
//------------------------------------------------------------------------------
class execute_stage_driver extends uvm_driver #(execute_stage_seq_item);
    `uvm_component_param_utils(execute_stage_driver)

    // execute_stage uVC configuration object.
    execute_stage_config  m_config;

    //------------------------------------------------------------------------------
    // The constructor for the component.
    //------------------------------------------------------------------------------
    function new(string name, uvm_component parent = null);
        super.new(name, parent);
        if (!uvm_config_db #(execute_stage_config)::get(this,"","execute_stage_config", m_config)) begin
            `uvm_fatal(get_name(),"Cannot find the VC configuration!")
        end
    endfunction

    //------------------------------------------------------------------------------
    // FUNCTION: build
    // The build phase for the component.
    //------------------------------------------------------------------------------
    function void build_phase(uvm_phase phase);
        super.build_phase(phase);
    endfunction : build_phase

    //------------------------------------------------------------------------------
    // FUNCTION: run_phase
    // The run phase for the component.
    // - Main loop
    // -  Wait for sequence item.
    // -  Perform the requested action
    // -  Send a response back.
    //------------------------------------------------------------------------------
    virtual task run_phase(uvm_phase phase);
        execute_stage_seq_item seq_item;
        
        // Loop forever
        forever begin
            // Wait for sequence item
            // `uvm_info(get_name(),$sformatf("Test drive"), UVM_NONE)
            @(posedge m_config.m_vif.clk);
            seq_item_port.get(seq_item);

            `uvm_info(get_name(),$sformatf("Driver: Start execute stage interface transaction. \nData1=%0d \nData2=%0d \nImmediate data=%0d \nControl in=%0d \nComplag in=%0d \nProgram counter=%0d", seq_item.data1, seq_item.data2, seq_item.immediate_data, seq_item.control_in, seq_item.compflg_in, seq_item.program_counter),UVM_HIGH)

            // Perform the requested action and send response back.
            // Write data and set data valid signal
            m_config.m_vif.data1 <= seq_item.data1;
            m_config.m_vif.data2 <= seq_item.data2;
            m_config.m_vif.immediate_data <= seq_item.immediate_data;
            m_config.m_vif.control_in <= seq_item.control_in;
            m_config.m_vif.compflg_in <= seq_item.compflg_in;
            m_config.m_vif.program_counter <= seq_item.program_counter;
          
            seq_item_port.put(seq_item);


        end
    endtask : run_phase
endclass : execute_stage_driver
