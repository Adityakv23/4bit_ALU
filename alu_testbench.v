`timescale 1ns / 1ps

module alu_testbench();

    // Testbench signals
    reg [3:0] a, b;
    reg [2:0] opcode;
    reg cin;
    wire [3:0] result;
    wire cout, zero, negative, overflow;

    // Instantiate the ALU
    alu_4bit alu_inst(
        .a(a),
        .b(b),
        .opcode(opcode),
        .cin(cin),
        .result(result),
        .cout(cout),
        .zero(zero),
        .negative(negative),
        .overflow(overflow)
    );

    // Test stimulus
    initial begin
        // Initialize signals
        a = 4'b0000;
        b = 4'b0000;
        opcode = 3'b000;
        cin = 1'b0;

        // Wait for initial setup
        #10;

        // Test 1: Addition operations
        $display("=== Testing Addition Operations ===");
        test_addition(4'b0010, 4'b0011, 1'b0);  // 2 + 3 = 5
        test_addition(4'b1111, 4'b0001, 1'b0);  // 15 + 1 = 0 (overflow)
        test_addition(4'b0111, 4'b0111, 1'b0);  // 7 + 7 = 14
        test_addition(4'b1000, 4'b1000, 1'b0);  // -8 + (-8) = 0 (overflow)

        // Test 2: Subtraction operations
        $display("\n=== Testing Subtraction Operations ===");
        test_subtraction(4'b0100, 4'b0010, 1'b0);  // 4 - 2 = 2
        test_subtraction(4'b0010, 4'b0100, 1'b0);  // 2 - 4 = -2
        test_subtraction(4'b0000, 4'b0001, 1'b0);  // 0 - 1 = -1
        test_subtraction(4'b1000, 4'b0001, 1'b0);  // -8 - 1 = -9

        // Test 3: Logical AND operations
        $display("\n=== Testing AND Operations ===");
        test_logical(4'b1010, 4'b1100, 3'b010);  // 1010 & 1100 = 1000
        test_logical(4'b1111, 4'b0000, 3'b010);  // 1111 & 0000 = 0000
        test_logical(4'b1010, 4'b1010, 3'b010);  // 1010 & 1010 = 1010

        // Test 4: Logical OR operations
        $display("\n=== Testing OR Operations ===");
        test_logical(4'b1010, 4'b1100, 3'b011);  // 1010 | 1100 = 1110
        test_logical(4'b0000, 4'b1111, 3'b011);  // 0000 | 1111 = 1111
        test_logical(4'b1010, 4'b0101, 3'b011);  // 1010 | 0101 = 1111

        // Test 5: Logical XOR operations
        $display("\n=== Testing XOR Operations ===");
        test_logical(4'b1010, 4'b1100, 3'b100);  // 1010 ^ 1100 = 0110
        test_logical(4'b1111, 4'b1111, 3'b100);  // 1111 ^ 1111 = 0000
        test_logical(4'b1010, 4'b0101, 3'b100);  // 1010 ^ 0101 = 1111

        // Test 6: NOT operations
        $display("\n=== Testing NOT Operations ===");
        test_not(4'b1010);  // ~1010 = 0101
        test_not(4'b1111);  // ~1111 = 0000
        test_not(4'b0000);  // ~0000 = 1111

        // Test 7: Set Less Than operations
        $display("\n=== Testing SLT Operations ===");
        test_slt(4'b0010, 4'b0100);  // 2 < 4 = 1
        test_slt(4'b0100, 4'b0010);  // 4 < 2 = 0
        test_slt(4'b1000, 4'b0001);  // -8 < 1 = 1
        test_slt(4'b0001, 4'b1000);  // 1 < -8 = 0

        // Test 8: Shift Left Logical operations
        $display("\n=== Testing SLL Operations ===");
        test_sll(4'b1010);  // 1010 << 1 = 0100
        test_sll(4'b0001);  // 0001 << 1 = 0010
        test_sll(4'b1000);  // 1000 << 1 = 0000

        // Test 9: Edge cases
        $display("\n=== Testing Edge Cases ===");
        test_edge_cases();

        $display("\n=== All Tests Completed ===");
        $finish;
    end

    // Task for testing addition
    task test_addition;
        input [3:0] a_val, b_val;
        input cin_val;
        begin
            a = a_val;
            b = b_val;
            cin = cin_val;
            opcode = 3'b000;
            #5;
            $display("ADD: %b + %b + %b = %b (Cout=%b, Zero=%b, Neg=%b, Ovr=%b)", 
                     a, b, cin, result, cout, zero, negative, overflow);
        end
    endtask

    // Task for testing subtraction
    task test_subtraction;
        input [3:0] a_val, b_val;
        input cin_val;
        begin
            a = a_val;
            b = b_val;
            cin = cin_val;
            opcode = 3'b001;
            #5;
            $display("SUB: %b - %b - %b = %b (Cout=%b, Zero=%b, Neg=%b, Ovr=%b)", 
                     a, b, cin, result, cout, zero, negative, overflow);
        end
    endtask

    // Task for testing logical operations
    task test_logical;
        input [3:0] a_val, b_val;
        input [2:0] op;
        begin
            a = a_val;
            b = b_val;
            cin = 1'b0;
            opcode = op;
            #5;
            case(op)
                3'b010: $display("AND: %b & %b = %b (Zero=%b, Neg=%b)", a, b, result, zero, negative);
                3'b011: $display("OR:  %b | %b = %b (Zero=%b, Neg=%b)", a, b, result, zero, negative);
                3'b100: $display("XOR: %b ^ %b = %b (Zero=%b, Neg=%b)", a, b, result, zero, negative);
            endcase
        end
    endtask

    // Task for testing NOT operation
    task test_not;
        input [3:0] a_val;
        begin
            a = a_val;
            b = 4'b0000;
            cin = 1'b0;
            opcode = 3'b101;
            #5;
            $display("NOT: ~%b = %b (Zero=%b, Neg=%b)", a, result, zero, negative);
        end
    endtask

    // Task for testing SLT operation
    task test_slt;
        input [3:0] a_val, b_val;
        begin
            a = a_val;
            b = b_val;
            cin = 1'b0;
            opcode = 3'b110;
            #5;
            $display("SLT: %b < %b = %b (Zero=%b, Neg=%b)", a, b, result, zero, negative);
        end
    endtask

    // Task for testing SLL operation
    task test_sll;
        input [3:0] a_val;
        begin
            a = a_val;
            b = 4'b0000;
            cin = 1'b0;
            opcode = 3'b111;
            #5;
            $display("SLL: %b << 1 = %b (Cout=%b, Zero=%b, Neg=%b)", a, result, cout, zero, negative);
        end
    endtask

    // Task for testing edge cases
    task test_edge_cases;
        begin
            // Test with undefined opcode
            a = 4'b1010;
            b = 4'b0101;
            cin = 1'b0;
            opcode = 3'b111;  // This will be handled by default case
            #5;
            $display("Edge Case: Undefined opcode with a=%b, b=%b = %b", a, b, result);
        end
    endtask

    // Monitor changes
    initial begin
        $monitor("Time=%0t a=%b b=%b opcode=%b cin=%b result=%b cout=%b zero=%b neg=%b ovr=%b",
                 $time, a, b, opcode, cin, result, cout, zero, negative, overflow);
    end

endmodule 