module alu_src_mux (
    input  wire        ALUSrc,
    input  wire [31:0] rs2_data,
    input  wire [31:0] imm,
    output wire [31:0] alu_in2
);

    // TODO: 一行assign，用三元运算符
    assign alu_in2 = ALUSrc ? imm : rs2_data;

endmodule