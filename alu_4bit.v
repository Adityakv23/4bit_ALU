module alu_4bit(
    input wire [3:0] a,        // First operand
    input wire [3:0] b,        // Second operand
    input wire [2:0] opcode,   // Operation code
    input wire cin,             // Carry in
    output reg [3:0] result,   // ALU result
    output reg cout,            // Carry out
    output reg zero,            // Zero flag
    output reg negative,        // Negative flag
    output reg overflow         // Overflow flag
);

    // Operation codes
    localparam ADD  = 3'b000;  // Addition
    localparam SUB  = 3'b001;  // Subtraction
    localparam AND  = 3'b010;  // AND
    localparam OR   = 3'b011;  // OR
    localparam XOR  = 3'b100;  // XOR
    localparam NOT  = 3'b101;  // NOT (of A)
    localparam SLT  = 3'b110;  // Set if less than
    localparam SLL  = 3'b111;  // Shift left logical

    // Internal signals
    wire [4:0] add_result;
    wire [4:0] sub_result;
    wire [3:0] logical_result;
    wire [3:0] shift_result;
    wire [3:0] slt_result;

    // Addition operation
    assign add_result = a + b + cin;
    
    // Subtraction operation
    assign sub_result = a - b - cin;
    
    // Logical operations
    assign logical_result = (opcode == AND) ? (a & b) :
                           (opcode == OR)  ? (a | b) :
                           (opcode == XOR) ? (a ^ b) :
                           (opcode == NOT) ? (~a) : 4'b0000;
    
    // Shift left logical
    assign shift_result = (opcode == SLL) ? {a[2:0], 1'b0} : 4'b0000;
    
    // Set if less than
    assign slt_result = (opcode == SLT) ? ((a < b) ? 4'b0001 : 4'b0000) : 4'b0000;

    // Main ALU logic
    always @(*) begin
        case (opcode)
            ADD: begin
                result = add_result[3:0];
                cout = add_result[4];
                overflow = (a[3] == b[3]) && (result[3] != a[3]);
            end
            
            SUB: begin
                result = sub_result[3:0];
                cout = sub_result[4];
                overflow = (a[3] != b[3]) && (result[3] == b[3]);
            end
            
            AND, OR, XOR, NOT: begin
                result = logical_result;
                cout = 1'b0;
                overflow = 1'b0;
            end
            
            SLT: begin
                result = slt_result;
                cout = 1'b0;
                overflow = 1'b0;
            end
            
            SLL: begin
                result = shift_result;
                cout = a[3];  // MSB becomes carry out
                overflow = 1'b0;
            end
            
            default: begin
                result = 4'b0000;
                cout = 1'b0;
                overflow = 1'b0;
            end
        endcase
        
        // Set flags
        zero = (result == 4'b0000);
        negative = result[3];
    end

endmodule 