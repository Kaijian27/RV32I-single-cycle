module pc_reg (
    input  wire        clk,
    input  wire        rst,        // reset，让PC归零，方便testbench重新开始
    input  wire [31:0] pc_next,    // 下一个PC的值（我们之后决定是PC+4还是branch目标）
    output reg  [31:0] pc_current  // 当前PC，给Instruction Memory当地址用
);

    // TODO: sequential logic
    // 如果 rst == 1，pc_current 归零
    // 否则，pc_current 更新成 pc_next

    always @(posedge clk) begin
        if(rst)begin
            pc_current <= 0;
        end
        else begin
            pc_current <= pc_next;
        end
    end
endmodule