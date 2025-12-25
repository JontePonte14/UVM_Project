# UVM project on a RISC V execute stage
This project is a UVM test bench from a earlier course ([ICP1](https://github.com/JontePonte14/ICP1-riscV)). The execute stage from that course but from another group was verfiefied using UVM. 

The DUT can be found in "fas2_uvm_env/execute_stage/dut and the reference model of the DUT can be found in "fas2_uvm_env/execute_stage/reference_model".

The verication process uses varoius constraints with covergroups, and a Python reference module of the DUT to verify that it works. 


## Setup
To run the testbench there are certain things that must be done first. 

1. First clone this repo and jump to the folder within. "fas2_uvm_env".

   ```bash
   git clone <your-repo-url>
   cd UVM_Project/fas2_uvm_env

2. Make sure you can run QuestaSim, otherwise the scripts that run the actual UVM won't work.

3. The reference model is made in Python but is needed to be wrapped in a C wrapper to be imported to SystemVerilog. To use the reference model, the C-code needs to be compiled this can be done with following commands. The compiled file will be saved in "dpi" folder.
   ```bash
   cd fas2_uvm_env/reference_model
   make 

## Running the testbench
When running the actual testbench there are a few alterantive  scripts that can be run. All of these are bash scripts that offer slightly different functionalites. They need to be run in the folder "fas2_uvm_env". Let's go through them

### vrun_test.sh
This runs the testbench in QuestaSim and lanches the GUI, additional simulates the first 2000 ns

### run_and_report.sh
This runs the testbench in QuestaSim without a GUI, and reports all the error between the DUT and reference model in a text file called "report.txt". The text file will be overwritten every time run_and_report.sh is run.