module instr_decoder (
    input  wire [31:0] instr,
    output wire [6:0]  opcode,
    output wire [4:0]  rd,
    output wire [2:0]  funct3,
    output wire [4:0]  rs1,
    output wire [4:0]  rs2,
    output wire [6:0]  funct7,
    output wire [31:0] imm_i,     // I-type immediate, sign-extended to 32-bit (先不管sign-extend，我们下一步讲)
    output wire [31:0] imm_s,     // S-type
    output wire [31:0] imm_b
);

    // bit-slice for R-type
    assign opcode = instr[6:0];
    assign rd = instr[11:7];
    assign funct3 = instr[14:12];
    assign rs1 = instr[19:15];
    assign rs2 = instr[24:20];
    assign funct7 = instr[31:25];


    // I type — 先直接assign成instr[31:20]，宽度只有12-bit + 剩余的sign-extension
    assign imm_i = { {20{instr[31]}} , instr[31:20] };

     // S type
    assign imm_s =  { {20{instr[31]}} , instr[31:25], instr[11:7] };


    // B type
    assign imm_b = { {19{instr[31]}}, instr[31], instr[7], instr[30:25], instr[11:8], 1'b0 };



endmodule