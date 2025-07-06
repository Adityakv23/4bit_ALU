# Makefile for 4-bit ALU Project
# Supports Icarus Verilog (iverilog) and GTKWave for simulation

# Compiler and simulator
IVERILOG = iverilog
VVP = vvp
GTKWAVE = gtkwave

# Source files
SOURCES = alu_4bit.v
TESTBENCH = alu_testbench.v
TOP_MODULE = alu_testbench

# Output files
VCD_FILE = alu_simulation.vcd
EXECUTABLE = alu_sim

# Default target
all: compile run

# Compile the design
compile:
	@echo "Compiling 4-bit ALU design..."
	$(IVERILOG) -o $(EXECUTABLE) $(SOURCES) $(TESTBENCH)
	@echo "Compilation completed successfully!"

# Run the simulation
run: compile
	@echo "Running simulation..."
	$(VVP) $(EXECUTABLE) -vcd $(VCD_FILE)
	@echo "Simulation completed!"

# Run simulation with waveform generation
wave: run
	@echo "Opening waveform viewer..."
	$(GTKWAVE) $(VCD_FILE) &
	@echo "Waveform viewer opened!"

# Clean generated files
clean:
	@echo "Cleaning generated files..."
	rm -f $(EXECUTABLE) $(VCD_FILE)
	@echo "Clean completed!"

# Help target
help:
	@echo "4-bit ALU Project Makefile"
	@echo "=========================="
	@echo "Available targets:"
	@echo "  all     - Compile and run simulation"
	@echo "  compile - Compile the design only"
	@echo "  run     - Compile and run simulation"
	@echo "  wave    - Compile, run, and open waveform viewer"
	@echo "  clean   - Remove generated files"
	@echo "  help    - Show this help message"
	@echo ""
	@echo "Usage examples:"
	@echo "  make all     # Full simulation"
	@echo "  make wave    # Simulation with waveform viewer"
	@echo "  make clean   # Clean up files"

# Check if Icarus Verilog is installed
check_iverilog:
	@which $(IVERILOG) > /dev/null || (echo "Error: Icarus Verilog not found. Please install it first." && exit 1)
	@echo "Icarus Verilog found: $(shell which $(IVERILOG))"

# Check if GTKWave is installed
check_gtkwave:
	@which $(GTKWAVE) > /dev/null || (echo "Warning: GTKWave not found. Waveform viewing will not work." && exit 0)
	@echo "GTKWave found: $(shell which $(GTKWAVE))"

# Install dependencies (for Ubuntu/Debian)
install_deps:
	@echo "Installing dependencies..."
	sudo apt-get update
	sudo apt-get install -y iverilog gtkwave
	@echo "Dependencies installed!"

# Install dependencies (for macOS with Homebrew)
install_deps_mac:
	@echo "Installing dependencies for macOS..."
	brew install icarus-verilog gtkwave
	@echo "Dependencies installed!"

.PHONY: all compile run wave clean help check_iverilog check_gtkwave install_deps install_deps_mac 