# 4-Bit ALU (Arithmetic Logic Unit) Project

## Overview

This project implements a comprehensive 4-bit Arithmetic Logic Unit (ALU) in Verilog. The ALU supports 8 different operations including arithmetic, logical, and shift operations. It also includes status flags for zero, negative, carry out, and overflow detection.

## Features

### Supported Operations

| Opcode | Operation | Description |
|--------|-----------|-------------|
| 000    | ADD       | Addition (A + B + Cin) |
| 001    | SUB       | Subtraction (A - B - Cin) |
| 010    | AND       | Logical AND (A & B) |
| 011    | OR        | Logical OR (A \| B) |
| 100    | XOR       | Logical XOR (A ^ B) |
| 101    | NOT       | Logical NOT (~A) |
| 110    | SLT       | Set if Less Than (A < B ? 1 : 0) |
| 111    | SLL       | Shift Left Logical (A << 1) |

### Status Flags

- **Zero Flag**: Set when result equals zero
- **Negative Flag**: Set when result is negative (MSB = 1)
- **Carry Out**: Set when arithmetic operation produces carry
- **Overflow Flag**: Set when arithmetic operation causes overflow

## Project Structure

```
4bit_alu_project/
├── alu_4bit.v          # Main ALU module
├── alu_testbench.v     # Comprehensive testbench
├── Makefile            # Build and simulation automation
├── README.md           # This documentation
└── alu_simulation.vcd  # Generated waveform file (after simulation)
```

## Module Interface

### Inputs
- `a[3:0]`: First operand (4-bit)
- `b[3:0]`: Second operand (4-bit)
- `opcode[2:0]`: Operation selection (3-bit)
- `cin`: Carry input (1-bit)

### Outputs
- `result[3:0]`: ALU result (4-bit)
- `cout`: Carry output (1-bit)
- `zero`: Zero flag (1-bit)
- `negative`: Negative flag (1-bit)
- `overflow`: Overflow flag (1-bit)

## Installation and Setup

### Prerequisites

You need to install Icarus Verilog and GTKWave for simulation:

#### On Ubuntu/Debian:
```bash
sudo apt-get update
sudo apt-get install iverilog gtkwave
```

#### On macOS (with Homebrew):
```bash
brew install icarus-verilog gtkwave
```

#### On Windows:
Download and install from:
- Icarus Verilog: http://bleyer.org/icarus/
- GTKWave: http://gtkwave.sourceforge.net/

### Quick Start

1. **Check dependencies**:
   ```bash
   make check_iverilog
   make check_gtkwave
   ```

2. **Run simulation**:
   ```bash
   make all
   ```

3. **Run with waveform viewer**:
   ```bash
   make wave
   ```

4. **Clean generated files**:
   ```bash
   make clean
   ```

## Usage Examples

### Basic Simulation
```bash
# Compile and run
make run

# View results in terminal
```

### Waveform Analysis
```bash
# Generate and view waveforms
make wave

# GTKWave will open automatically
```

### Individual Operations
```bash
# Compile only
make compile

# Run simulation only (if already compiled)
./alu_sim
```

## Test Cases

The testbench includes comprehensive test cases for all operations:

### Arithmetic Operations
- **Addition**: Tests normal addition, overflow conditions
- **Subtraction**: Tests normal subtraction, negative results, underflow

### Logical Operations
- **AND**: Tests bitwise AND with various input combinations
- **OR**: Tests bitwise OR operations
- **XOR**: Tests exclusive OR operations
- **NOT**: Tests bitwise complement of operand A

### Comparison Operations
- **SLT**: Tests "set if less than" with positive and negative numbers

### Shift Operations
- **SLL**: Tests logical left shift by 1 bit

### Edge Cases
- Overflow conditions
- Zero results
- Negative results
- Undefined opcodes

## Technical Details

### Number Representation
- **4-bit signed numbers**: Range from -8 to +7
- **Two's complement**: Used for negative number representation

### Overflow Detection
- **Addition**: Detected when adding two numbers of same sign produces result of opposite sign
- **Subtraction**: Detected when subtracting numbers of opposite signs produces result of same sign as subtrahend

### Carry Logic
- **Addition**: Carry out when sum exceeds 4 bits
- **Subtraction**: Carry out when borrow is needed
- **Logical operations**: No carry generated
- **Shift operations**: MSB becomes carry out

## Expected Results

### Sample Test Output
```
=== Testing Addition Operations ===
ADD: 0010 + 0011 + 0 = 0101 (Cout=0, Zero=0, Neg=0, Ovr=0)
ADD: 1111 + 0001 + 0 = 0000 (Cout=1, Zero=1, Neg=0, Ovr=1)

=== Testing AND Operations ===
AND: 1010 & 1100 = 1000 (Zero=0, Neg=1)
AND: 1111 & 0000 = 0000 (Zero=1, Neg=0)
```

## Troubleshooting

### Common Issues

1. **"iverilog: command not found"**
   - Install Icarus Verilog using the installation commands above

2. **"gtkwave: command not found"**
   - Install GTKWave using the installation commands above

3. **Compilation errors**
   - Check that all Verilog files are in the same directory
   - Ensure proper syntax in Verilog files

4. **Simulation not running**
   - Run `make clean` and try again
   - Check that the testbench file is properly formatted

### Debug Tips

- Use `make compile` to check for syntax errors
- Run `make run` to see detailed simulation output
- Use `make wave` to visualize signal behavior
- Check the generated VCD file for waveform analysis

## Extensions and Modifications

### Adding New Operations
To add new operations:

1. Define new opcode in `alu_4bit.v`
2. Add operation logic in the `always @(*)` block
3. Update testbench with new test cases
4. Update documentation

### Modifying Bit Width
To change from 4-bit to 8-bit or other widths:

1. Update all signal declarations
2. Modify arithmetic operations
3. Adjust overflow detection logic
4. Update testbench accordingly

## Contributing

Feel free to contribute improvements:
- Add new operations
- Enhance test coverage
- Improve documentation
- Optimize performance

## License

This project is open source and available under the MIT License.

## Contact

For questions or issues, please refer to the project documentation or create an issue in the repository. 