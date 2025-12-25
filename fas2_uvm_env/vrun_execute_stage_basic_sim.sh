vlog -sv execute_stage/dut/execute_stage.sv execute_stage/dut/common.sv execute_stage/dut/alu.sv execute_stage/tb/tb_top.sv
        #+incdir+uvc/execute_stage_uvc+execute_stage/tb \
        #uvc/parallel_data_uvc/parallel_data_if.sv uvc/execute_stage_uvc/data_fifo_if.sv \
        #REMOVED TB_PACKGE FROM ROW 5
vsim -i work.tb_top -do "
    run 2000 ns
"
#-coverage +UVM_NO_RELNOTES +UVM_VERBOSITY=UVM_HIGH +UVM_TESTNAME=basic_test