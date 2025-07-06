@echo off
echo 4-Bit ALU Simulation Runner
echo ===========================

REM Check if Icarus Verilog is installed
where iverilog >nul 2>nul
if %errorlevel% neq 0 (
    echo Error: Icarus Verilog not found!
    echo Please install Icarus Verilog from: http://bleyer.org/icarus/
    echo.
    echo For Windows, you can also use:
    echo 1. Download from: http://bleyer.org/icarus/
    echo 2. Add to PATH environment variable
    pause
    exit /b 1
)

echo Icarus Verilog found. Compiling...

REM Compile the design
iverilog -o alu_sim alu_4bit.v alu_testbench.v
if %errorlevel% neq 0 (
    echo Compilation failed!
    pause
    exit /b 1
)

echo Compilation successful. Running simulation...

REM Run simulation
vvp alu_sim -vcd alu_simulation.vcd
if %errorlevel% neq 0 (
    echo Simulation failed!
    pause
    exit /b 1
)

echo.
echo Simulation completed successfully!
echo.

REM Check if GTKWave is available
where gtkwave >nul 2>nul
if %errorlevel% equ 0 (
    echo GTKWave found. Opening waveform viewer...
    start gtkwave alu_simulation.vcd
) else (
    echo GTKWave not found. Install from: http://gtkwave.sourceforge.net/
    echo VCD file generated: alu_simulation.vcd
)

echo.
echo Press any key to exit...
pause >nul 