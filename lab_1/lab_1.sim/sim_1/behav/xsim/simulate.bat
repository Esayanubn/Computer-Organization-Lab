@echo off
REM ****************************************************************************
REM Vivado (TM) v2021.2 (64-bit)
REM
REM Filename    : simulate.bat
REM Simulator   : Xilinx Vivado Simulator
REM Description : Script for simulating the design by launching the simulator
REM
REM Generated by Vivado on Tue Apr 11 23:40:07 +0800 2023
REM SW Build 3367213 on Tue Oct 19 02:48:09 MDT 2021
REM
REM IP Build 3369179 on Thu Oct 21 08:25:16 MDT 2021
REM
REM usage: simulate.bat
REM
REM ****************************************************************************
REM simulate design
echo "xsim testBench_behav -key {Behavioral:sim_1:Functional:testBench} -tclbatch testBench.tcl -view D:/Computer_Org_Lab/lab_1/simresult/testBench_behav_1testAll.wcfg -log simulate.log"
call xsim  testBench_behav -key {Behavioral:sim_1:Functional:testBench} -tclbatch testBench.tcl -view D:/Computer_Org_Lab/lab_1/simresult/testBench_behav_1testAll.wcfg -log simulate.log
if "%errorlevel%"=="0" goto SUCCESS
if "%errorlevel%"=="1" goto END
:END
exit 1
:SUCCESS
exit 0
