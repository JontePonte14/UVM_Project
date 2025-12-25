vlog -sv -cover bcs -timescale 1ns/1ns +acc=pr \
        +incdir+uvc/clock_uvc+uvc/execute_stage_uvc+uvc/out_execute_stage_uvc+execute_stage/tb \
        execute_stage/dut/common.sv \
        uvc/execute_stage_uvc/execute_stage_if.sv uvc/out_execute_stage_uvc/out_execute_stage_if.sv uvc/clock_uvc/clock_if.sv \
        execute_stage/dut/alu.sv execute_stage/dut/execute_stage.sv execute_stage/tb/tb_pkg.sv execute_stage/tb/tb_top.sv \
	#execute_stage/reference_model/execute_stage_ref.c
        #execute_stage/dut/alu.sv
        #REMOVED TB_PACKGE FROM ROW 5
#vsim -i work.tb_top -coverage +UVM_NO_RELNOTES +UVM_VERBOSITY=UVM_HIGH +UVM_TESTNAME=basic_test -do "
 #   run 2000 ns
#
#-coverage +UVM_NO_RELNOTES +UVM_VERBOSITY=UVM_HIGH +UVM_TESTNAME=basic_test

vsim -i work.tb_top \
	-sv_lib execute_stage/dpi/libexecute_stage_ref \
	-sv_seed 7979700 -coverage +UVM_NO_RELNOTES +UVM_VERBOSITY=UVM_HIGH +UVM_TESTNAME=basic_test -do "
    run 2000 ns"
