module branch_adder (
    input  wire [31:0] pc_current,
    input  wire [31:0] imm_b,
    output wire [31:0] branch_target
);

    // TODO: 一行 assign
    assign branch_target = pc_current + imm_b;

endmodule