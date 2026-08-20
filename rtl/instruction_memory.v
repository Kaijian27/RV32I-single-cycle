module instruction_memory (
    input  wire [31:0] addr,
    output wire [31:0] instr
);

    // declare memory array. (256 words ,Each word is 32-bit)
    reg [31:0] words [0:255];  // 256个word，每个word 32-bit
    

    // read logic (combinational)
    // PC会给byte address的形式，memory自己是word by word读的，
    // 所以byte换算word要除4
    assign instr = words[addr >> 2]; //word_index = addr/4;

endmodule