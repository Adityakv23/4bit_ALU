#!/usr/bin/env python3
"""
ALU Visualizer and Test Case Generator
A Python script to help understand and visualize 4-bit ALU operations.
"""

import sys
from typing import List, Tuple

class ALUVisualizer:
    def __init__(self):
        self.operations = {
            '000': ('ADD', 'Addition'),
            '001': ('SUB', 'Subtraction'),
            '010': ('AND', 'Logical AND'),
            '011': ('OR', 'Logical OR'),
            '100': ('XOR', 'Logical XOR'),
            '101': ('NOT', 'Logical NOT'),
            '110': ('SLT', 'Set if Less Than'),
            '111': ('SLL', 'Shift Left Logical')
        }
    
    def to_signed(self, value: int) -> int:
        """Convert 4-bit unsigned to signed (-8 to 7)"""
        if value >= 8:
            return value - 16
        return value
    
    def to_unsigned(self, value: int) -> int:
        """Convert signed to 4-bit unsigned"""
        if value < 0:
            return value + 16
        return value
    
    def format_binary(self, value: int, width: int = 4) -> str:
        """Format integer as binary string"""
        return f"{value:0{width}b}"
    
    def simulate_alu(self, a: int, b: int, opcode: str, cin: int = 0) -> dict:
        """Simulate ALU operation"""
        a_signed = self.to_signed(a)
        b_signed = self.to_signed(b)
        
        if opcode == '000':  # ADD
            result = a_signed + b_signed + cin
            cout = 1 if result > 7 or result < -8 else 0
            overflow = (a_signed >= 0 and b_signed >= 0 and result < 0) or \
                      (a_signed < 0 and b_signed < 0 and result >= 0)
            result = self.to_unsigned(result)
            
        elif opcode == '001':  # SUB
            result = a_signed - b_signed - cin
            cout = 1 if result < -8 else 0
            overflow = (a_signed >= 0 and b_signed < 0 and result < 0) or \
                      (a_signed < 0 and b_signed >= 0 and result >= 0)
            result = self.to_unsigned(result)
            
        elif opcode == '010':  # AND
            result = a & b
            cout = 0
            overflow = 0
            
        elif opcode == '011':  # OR
            result = a | b
            cout = 0
            overflow = 0
            
        elif opcode == '100':  # XOR
            result = a ^ b
            cout = 0
            overflow = 0
            
        elif opcode == '101':  # NOT
            result = (~a) & 0xF
            cout = 0
            overflow = 0
            
        elif opcode == '110':  # SLT
            result = 1 if a_signed < b_signed else 0
            cout = 0
            overflow = 0
            
        elif opcode == '111':  # SLL
            result = ((a << 1) & 0xF)
            cout = (a >> 3) & 1
            overflow = 0
            
        else:
            result = 0
            cout = 0
            overflow = 0
        
        zero = (result == 0)
        negative = (result & 8) != 0
        
        return {
            'result': result,
            'cout': cout,
            'zero': zero,
            'negative': negative,
            'overflow': overflow
        }
    
    def print_operation_table(self):
        """Print operation code table"""
        print("ALU Operation Codes:")
        print("=" * 50)
        print(f"{'Opcode':<8} {'Operation':<12} {'Description'}")
        print("-" * 50)
        for opcode, (op, desc) in self.operations.items():
            print(f"{opcode:<8} {op:<12} {desc}")
        print()
    
    def test_single_operation(self, a: int, b: int, opcode: str, cin: int = 0):
        """Test and display a single ALU operation"""
        a_signed = self.to_signed(a)
        b_signed = self.to_signed(b)
        
        result = self.simulate_alu(a, b, opcode, cin)
        op_name = self.operations[opcode][0]
        
        print(f"Operation: {op_name}")
        print(f"Inputs: A={self.format_binary(a)} ({a_signed:2d}), B={self.format_binary(b)} ({b_signed:2d}), Cin={cin}")
        print(f"Result: {self.format_binary(result['result'])} ({self.to_signed(result['result']):2d})")
        print(f"Flags: Cout={result['cout']}, Zero={result['zero']}, Neg={result['negative']}, Ovr={result['overflow']}")
        print("-" * 50)
    
    def generate_test_cases(self) -> List[Tuple]:
        """Generate comprehensive test cases"""
        test_cases = []
        
        # Addition tests
        test_cases.extend([
            (2, 3, '000', 0),   # Normal addition
            (7, 7, '000', 0),   # Overflow test
            (15, 1, '000', 0),  # Wrap around
            (-8, -8, '000', 0), # Negative overflow
        ])
        
        # Subtraction tests
        test_cases.extend([
            (4, 2, '001', 0),   # Normal subtraction
            (2, 4, '001', 0),   # Negative result
            (0, 1, '001', 0),   # Borrow needed
            (-8, 1, '001', 0),  # Underflow
        ])
        
        # Logical tests
        test_cases.extend([
            (10, 12, '010', 0), # AND
            (10, 12, '011', 0), # OR
            (10, 12, '100', 0), # XOR
            (10, 0, '101', 0),  # NOT
        ])
        
        # Comparison tests
        test_cases.extend([
            (2, 4, '110', 0),   # SLT true
            (4, 2, '110', 0),   # SLT false
            (-8, 1, '110', 0),  # SLT with negative
        ])
        
        # Shift tests
        test_cases.extend([
            (10, 0, '111', 0),  # SLL
            (1, 0, '111', 0),   # SLL small number
            (8, 0, '111', 0),   # SLL with carry
        ])
        
        return test_cases
    
    def run_comprehensive_test(self):
        """Run comprehensive test suite"""
        print("Comprehensive ALU Test Suite")
        print("=" * 60)
        
        test_cases = self.generate_test_cases()
        
        for i, (a, b, opcode, cin) in enumerate(test_cases, 1):
            print(f"Test Case {i}:")
            self.test_single_operation(a, b, opcode, cin)
    
    def interactive_mode(self):
        """Interactive mode for testing operations"""
        print("Interactive ALU Testing Mode")
        print("Enter 'quit' to exit")
        print("Format: a b opcode [cin]")
        print("Example: 2 3 000 0")
        print("-" * 40)
        
        while True:
            try:
                user_input = input("Enter operation: ").strip()
                if user_input.lower() == 'quit':
                    break
                
                parts = user_input.split()
                if len(parts) < 3:
                    print("Error: Need at least 3 values (a b opcode)")
                    continue
                
                a = int(parts[0])
                b = int(parts[1])
                opcode = parts[2]
                cin = int(parts[3]) if len(parts) > 3 else 0
                
                if a < 0 or a > 15 or b < 0 or b > 15:
                    print("Error: Values must be 0-15")
                    continue
                
                if opcode not in self.operations:
                    print("Error: Invalid opcode")
                    continue
                
                self.test_single_operation(a, b, opcode, cin)
                
            except ValueError:
                print("Error: Invalid input format")
            except KeyboardInterrupt:
                print("\nExiting...")
                break

def main():
    visualizer = ALUVisualizer()
    
    if len(sys.argv) > 1:
        if sys.argv[1] == 'table':
            visualizer.print_operation_table()
        elif sys.argv[1] == 'test':
            visualizer.run_comprehensive_test()
        elif sys.argv[1] == 'interactive':
            visualizer.interactive_mode()
        else:
            print("Usage: python alu_visualizer.py [table|test|interactive]")
    else:
        print("ALU Visualizer")
        print("=" * 20)
        visualizer.print_operation_table()
        print("Run with 'test' for comprehensive tests")
        print("Run with 'interactive' for interactive mode")

if __name__ == "__main__":
    main() 