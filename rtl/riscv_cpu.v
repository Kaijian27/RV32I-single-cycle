module riscv_cpu (
    input wire clk,
    input wire rst
);

    // PC相关
    wire [31:0] pc_current, pc_next, pc_plus4, branch_target;

    // Instruction
    wire [31:0] instr;

    // Decoder输出
    wire [6:0] opcode, funct7;
    wire [4:0] rd, rs1, rs2;
    wire [2:0] funct3;
    wire [31:0] imm_i, imm_s, imm_b;
    wire [31:0] imm_selected;
    

    // Control Unit输出
    wire RegWrite, MemWrite, MemtoReg, ALUSrc, Branch;
    wire [1:0] ALUOp;

    assign imm_selected = MemWrite ? imm_s : imm_i;

    // ALU Control输出
    wire [3:0] ALUControl;

    // Register File输出
    wire [31:0] rs1_data, rs2_data;

    // ALU
    wire [31:0] alu_in2, alu_result;
    wire zero;

    // Data Memory
    wire [31:0] mem_read_data;

    // Write-back
    wire [31:0] write_back_data;



    pc_reg u_pc (
        .clk(clk),
        .rst(rst),
        .pc_next(pc_next),
        .pc_current(pc_current)
    );

    pc_adder u_pc_adder (
        .pc_current(pc_current),
        .pc_plus4(pc_plus4)
    );

    instruction_memory u_imem (
        .addr(pc_current),
        .instr(instr)
    );

    instr_decoder u_decoder (
        .instr(instr),
        .opcode(opcode),
        .rd(rd),
        .funct3(funct3),
        .rs1(rs1),
        .rs2(rs2),
        .funct7(funct7),
        .imm_i(imm_i),
        .imm_s(imm_s),
        .imm_b(imm_b)
    );

    control_unit u_control (
        .opcode(opcode),
        .RegWrite(RegWrite),
        .MemWrite(MemWrite),
        .MemtoReg(MemtoReg),
        .ALUSrc(ALUSrc),
        .Branch(Branch),
        .ALUOp(ALUOp)
    );

    register_file u_regfile (
        .clk(clk),
        .we(RegWrite),          // 提示：Control Unit的哪个输出决定要不要写Register File？
        .rs1_addr(rs1),
        .rs2_addr(rs2),
        .rd_addr(rd),
        .rd_data(write_back_data),     // 提示：写回Register File的值，是我们哪个wire？(还没接的那个)
        .rs1_data(rs1_data),
        .rs2_data(rs2_data)
    );

    alu_control u_alu_control (
        .ALUOp(ALUOp),
        .funct3(funct3),
        .funct7(funct7),
        .ALUControl(ALUControl)
    );

    alu_src_mux u_alu_src_mux (
        .ALUSrc(ALUSrc),
        .rs2_data(rs2_data),
        .imm(imm_selected),      // 提示：ALUSrc mux的imm input只有一个，但我们有imm_i, imm_s, imm_b三种immediate可选，这里先接哪一个？(想一下：ALUSrc=1的情况是哪些指令？addi, lw, sw——它们用的是哪种immediate格式？)
        .alu_in2(alu_in2)
    );

    alu u_alu (
        .a(rs1_data),        // 提示：ALU第一个operand，永远是从Register File的rs1读出来的值
        .b(alu_in2),
        .ALUControl(ALUControl),
        .result(alu_result),
        .zero(zero)
    );

    data_memory u_dmem (
        .clk(clk),
        .we(MemWrite),              // 提示：哪个control signal决定要不要写Data Memory？
        .addr(alu_result),            // 提示：Data Memory的地址，是ALU算出来的(rs1+offset)，不是PC！
        .write_data(rs2_data),      // 提示：sw要存进memory的值，是从哪个register读出来的？(rs1还是rs2?)
        .read_data(mem_read_data)
    );

    memtoreg_mux u_memtoreg_mux (
        .MemtoReg(MemtoReg),
        .alu_result(alu_result),
        .mem_read_data(mem_read_data),
        .write_back_data(write_back_data)
    );

    branch_adder u_branch_adder (
        .pc_current(pc_current),
        .imm_b(imm_b),
        .branch_target(branch_target)
    );

    pc_mux u_pc_mux (
        .Branch(Branch),
        .zero(zero),
        .pc_plus4(pc_plus4),
        .branch_target(branch_target),
        .pc_next(pc_next)
    );



endmodule