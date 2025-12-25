//------------------------------------------------------------------------------
// tb_env class
//
// This class represents the environment of the TB (Test Bench) which is
// composed by the different agents and the scoreboard
// The environment is initialized by getting the TB configuration from the UVM
// database and then creating all the components
//
// The environment connects the monitor analysis ports of the agents to the
// scoreboard
//
//------------------------------------------------------------------------------
class tb_env extends uvm_env;
    `uvm_component_utils(tb_env)

    // TB configuration object with all setup for the TB environment
    top_config   m_top_config;
    // execute_stage instance with execute_stage uVC.
    // clock instance with clock uVC.
    clock_agent  m_clock_agent;
    execute_stage_agent m_execute_stage_agent;
    out_execute_stage_agent m_out_execute_stage_agent;
    // scoreboard scoreboard.
    scoreboard   m_scoreboard;

    //------------------------------------------------------------------------------
    // Creates and initializes an instance of this class using the normal
    // constructor arguments for uvm_component.
    //------------------------------------------------------------------------------
    function new (string name = "tb_env" , uvm_component parent = null);
        super.new(name,parent);
        // Get TOP TB configuration from UVM DB
        if ((uvm_config_db #(top_config)::get(null, "tb_top", "top_config", m_top_config))==0) begin
            `uvm_fatal(get_name(),"Cannot find <top_config> TB configuration!")
        end
    endfunction : new

    //------------------------------------------------------------------------------
    // Build all the components in the TB environment
    //------------------------------------------------------------------------------
    function void build_phase(uvm_phase phase);
        super.build_phase(phase);
        // Build all TB VC's
        uvm_config_db #(execute_stage_config)::set(this,"m_execute_stage_agent*","config", m_top_config.m_execute_stage_config);
        uvm_config_db #(out_execute_stage_config)::set(this,"m_out_execute_stage_agent*","config", m_top_config.m_out_execute_stage_config);
        uvm_config_db #(clock_config)::set(this,"m_clock_agent*","config", m_top_config.m_clock_config);
        
        m_clock_agent = clock_agent::type_id::create("m_clock_agent",this);
        m_execute_stage_agent = execute_stage_agent::type_id::create("m_execute_stage_agent",this);
        m_out_execute_stage_agent = out_execute_stage_agent::type_id::create("m_out_execute_stage_agent",this);

        // Build scoreboard components
        m_scoreboard = scoreboard::type_id::create("m_scoreboard",this);
    endfunction : build_phase

    //------------------------------------------------------------------------------
    // This function is used to connection the uVC monitor analysis ports to the scoreboard
    //------------------------------------------------------------------------------
    function void connect_phase(uvm_phase phase);
        super.connect_phase(phase);
        // Making all connection all analysis ports to scoreboard
        m_execute_stage_agent.m_monitor.m_analysis_port.connect(m_scoreboard.m_execute_stage);
        m_out_execute_stage_agent.m_monitor.m_analysis_port.connect(m_scoreboard.m_out_execute_stage);

    endfunction : connect_phase

endclass : tb_env
