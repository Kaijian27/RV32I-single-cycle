module alu (
    input  wire [31:0] a,
    input  wire [31:0] b,
    input  wire [3:0]  ALUControl,
    output reg  [31:0] result,
    output wire         zero
);

    // TODO 1: combinational always block with case(ALUControl), 
    // implementing AND/OR/ADD/SUB/SLT. Add a default too.
always@(*) begin
    case(ALUControl) 
    4'b0000: result = a & b;          // AND
    4'b0001: result = a | b;          // OR
    4'b0010: result = a + b;          // ADD
    4'b0110: result = a - b;          // SUB
    4'b0111: result = (a < b) ? 32'd1 : 32'd0;// SLT
    default: result = 32'd0;

    endcase
end

    // TODO 2: zero output — think about what "zero" means (result == 0),
    // and whether this needs always/case or can be a simple one-line assign.
    assign zero = (result == 32'd0);

endmodule