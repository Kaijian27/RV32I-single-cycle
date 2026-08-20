module control_unit (
    input  wire [6:0] opcode,
    output reg        RegWrite,
    output reg        MemWrite,
    output reg        MemtoReg,
    output reg        ALUSrc,
    output reg        Branch,
    output reg [1:0]  ALUOp
);

    // TODO: combinational logic (always @(*)) with a case statement on opcode
    // Fill in each of the 5 instruction types using the table above
    always@(*)begin
    // = for combinational logic    
        case(opcode)
        7'b0110011 : begin //R-type(add,subs)
        RegWrite =1;
        MemWrite =0;
        MemtoReg =0;
        ALUSrc = 0;
        Branch = 0;
        ALUOp = 2'b10;

        end

        7'b0010011 : begin//addi(I-type)
        RegWrite = 1;
        MemWrite = 0;
        MemtoReg = 0;
        ALUSrc =  1;
        Branch =  0;
        ALUOp =  2'b00;

        end

        7'b0000011 : begin//lw - lw x1, 0(x2)
        RegWrite = 1;
        MemWrite = 0;
        MemtoReg = 1;
        ALUSrc =  1;
        Branch =  0;
        ALUOp =  2'b00;

        end

        7'b0100011 : begin//sw -sw x1, 0(x2)
        RegWrite = 0;
        MemWrite = 1;
        MemtoReg = 1'bx ;//既然根本不写寄存器，这个信号是 0 还是 1 都无所谓don't care，随便电路怎么连。
        ALUSrc =  1;
        Branch =  0;
        ALUOp =  2'b00;

        end

        7'b1100011 : begin//beq - beq x1, x2, offset
        RegWrite = 0;
        MemWrite = 0;
        MemtoReg = 1'bx;
        ALUSrc =  0;
        Branch =  1;
        ALUOp =  2'b01;
        
        end

        default: begin
        RegWrite = 0;
        MemWrite = 0;
        MemtoReg = 0;
        ALUSrc   = 0;
        Branch   = 0;
        ALUOp    = 2'b00;

        end

        endcase
    end

endmodule