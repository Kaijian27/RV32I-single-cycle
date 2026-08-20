module data_memory (
    input  wire        clk,
    input  wire        we,
    input  wire [31:0] addr,      // byte address
    input  wire [31:0] write_data,
    output wire [31:0] read_data
);

    // TODO 1: declare memory array (256 words, 32-bit each)
    reg [31:0] words [0:255];


    // TODO 2: write logic (synchronous, posedge clk, only if we==1)
    always @(posedge clk) begin
        if (we) begin
            words[addr >> 2] <= write_data; //word_index = addr/4;
        end
    end
    
    // TODO 3: read logic (combinational)
    assign read_data = words[addr >> 2];

endmodule