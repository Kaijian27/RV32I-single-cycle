module register_file (
    input  wire        clk,
    input  wire         we,        // write enable
    input  wire [4:0]  rs1_addr,  // read port 1 address
    input  wire [4:0]  rs2_addr,  // read port 2 address
    input  wire [4:0]  rd_addr,   // write port address  -- 地址 2^5 can represent 32个address
    input  wire [31:0] rd_data,   // data to write
    output wire [31:0] rs1_data,  // read port 1 output
    output wire [31:0] rs2_data   // read port 2 output
);

    // 第一个[31:0]：每个register是32-bit宽（bit 31到bit 0）不关address
    // 第二个[0:31]：说的是有几个格子，也就是index从0到31，总共32个格子
    reg [31:0] words [0:31];

    // TODO: write logic (synchronous, posedge clk)
    always@(posedge clk) begin
      if(we)begin
        if(rd_addr != 0)begin
            words[rd_addr] <= rd_data; //rd_data - 32 bit save into words[address]
        end
      end //[31:0]（第①层）→ 每个格子32-bit宽 —— 跟地址无关 | [0:31]（第②层）→ 总共32个格子     
    end   //地址需要几个bit，只取决于格子数量：2^5 =32 所以5-bit地址（[4:0]）刚好够用

    // TODO: read logic (combinational)
    // remember: reading x0 should always return 0, regardless of array content
    assign rs1_data = (rs1_addr==0) ? 0 : words[rs1_addr];
    assign rs2_data = (rs2_addr==0) ? 0 : words[rs2_addr];

endmodule