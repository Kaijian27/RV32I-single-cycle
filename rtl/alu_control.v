module alu_control (
    input  wire [1:0] ALUOp,
    input  wire [2:0] funct3,
    input  wire [6:0] funct7,
    output reg  [3:0] ALUControl
);

    // TODO: combinational logic
    // if ALUOp == 00 -> always add (lw/sw/addi)
    // if ALUOp == 01 -> always subtract (beq)
    // if ALUOp == 10 -> look at funct3 (and funct7 for add/sub distinction) to decide
always @(*) begin
    case(ALUOp)
    2'b00 : begin
        ALUControl = 4'b0010; //means add

    end

    2'b01 : begin
        ALUControl = 4'b0110;//means subtract

    end

    2'b10 : begin
        case(funct3)
            3'b000 : begin //only can depend func7(add or sub)
                if(funct7 == 7'b0000000)begin
                    ALUControl = 4'b0010; //means add
                end
                else if(funct7 == 7'b0100000)begin
                    ALUControl = 4'b0110; //means subtract
                end
                else begin
                    ALUControl = 4'b0000;//just ensure predictable
                end
            end

            3'b111 : begin //means and
                ALUControl = 4'b0000;
            end

            3'b110 : begin //means or
                ALUControl = 4'b0001;
            end

            3'b010 : begin//means slt
                ALUControl = 4'b0111;
            end

            default: begin
                ALUControl = 4'b0000; //just ensure predictable
            end
        endcase
    end

    default: begin
        ALUControl = 4'b0000;//just ensure predictable
    end

    endcase
end
endmodule