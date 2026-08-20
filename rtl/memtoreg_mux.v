module memtoreg_mux (
    input  wire        MemtoReg,
    input  wire [31:0] alu_result,
    input  wire [31:0] mem_read_data,
    output wire [31:0] write_back_data
);

    // TODO: 一行assign
    // 想一下：MemtoReg=0该选哪个？MemtoReg=1呢？(回想control table：lw是MemtoReg=1)
    assign write_back_data = MemtoReg ? mem_read_data : alu_result;

endmodule