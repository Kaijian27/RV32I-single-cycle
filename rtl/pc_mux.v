module pc_mux (
    input  wire        Branch,
    input  wire        zero,
    input  wire [31:0] pc_plus4,
    input  wire [31:0] branch_target,
    output wire [31:0] pc_next
);

    // TODO: 想一下select condition是什么（Branch AND zero），
    // 然后用三元运算符 ? : 来选 pc_plus4 还是 branch_target

    assign pc_next = (Branch && zero) ? branch_target : pc_plus4;


endmodule