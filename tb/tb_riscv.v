module tb_riscv;
    reg clk;
    reg rst;
    integer i;
    integer errors;
    

riscv_cpu dut(
    .clk(clk),
    .rst(rst)
);

always #10 clk = ~clk;


//这里dut要是你instantiateriscv_cpu时取的instance名字，
//u_imem是你在riscv_cpu里给instruction_memory取的instance名字——照你自己代码里实际用的名字改）
initial begin
    clk = 0;
    rst = 1;  
    errors = 0;
    
    @(posedge clk);

    dut.u_imem.words[0] = 32'h00500093;   // addi x1,x0,5
    dut.u_imem.words[1] = 32'h00300113;   // addi x2,x0,3
    dut.u_imem.words[2] = 32'h002081B3;   // add x3,x1,x2
    dut.u_imem.words[3] = 32'h00302023;   // sw x3,0(x0)
    dut.u_imem.words[4] = 32'h00002203;   // lw x4,0(x0)
    dut.u_imem.words[5] = 32'h00418463;   // beq x3,x4,8
    dut.u_imem.words[6] = 32'h06300293;   // addi x5,x0,99 (should be skipped)
    dut.u_imem.words[7] = 32'h00100313;   // addi x6,x0,1 (branch target)

    @(posedge clk);
    rst = 0;

    
    for (i = 0; i < 7; i = i + 1) begin
        @(posedge clk);
        #1;

        $display("Cycle %0d: PC=%h", i, dut.pc_current);

        // Check branch: PC 20 should jump to PC 28
        if (i == 5) begin
            if (dut.pc_current !== 32'd28) begin
                $display("[FAIL] BEQ branch incorrect");
                errors = errors + 1;
            end else begin
                $display("[PASS] BEQ branch taken correctly");
            end
        end
    end

    // Check register results
    if (dut.u_regfile.words[1] !== 32'd5) begin
        $display("[FAIL] x1 incorrect");
        errors = errors + 1;
    end

    if (dut.u_regfile.words[2] !== 32'd3) begin
        $display("[FAIL] x2 incorrect");
        errors = errors + 1;
    end

    if (dut.u_regfile.words[3] !== 32'd8) begin
        $display("[FAIL] x3 incorrect");
        errors = errors + 1;
    end

    if (dut.u_regfile.words[4] !== 32'd8) begin
        $display("[FAIL] x4 incorrect");
        errors = errors + 1;
    end

    if (dut.u_regfile.words[6] !== 32'd1) begin
        $display("[FAIL] x6 incorrect");
        errors = errors + 1;
    end

    // Check memory store
    if (dut.u_dmem.words[0] !== 32'd8) begin
        $display("[FAIL] Memory store incorrect");
        errors = errors + 1;
    end


    $display ("x0= %h\nx1= %h\nx2= %h\nx3= %h\nx4= %h\nx5= %h\nx6= %h\nx7= %h\n", dut.u_regfile.words[0],dut.u_regfile.words[1],
            dut.u_regfile.words[2],dut.u_regfile.words[3],dut.u_regfile.words[4],dut.u_regfile.words[5]
            ,dut.u_regfile.words[6], dut.u_regfile.words[7]
             );
             
    if (errors == 0) begin
    $display("----------------------------------");
    $display("[TEST PASSED] All CPU tests passed!");
    $display("----------------------------------");
    end else begin
        $display("----------------------------------");
        $display("[TEST FAILED] Errors = %0d", errors);
        $display("----------------------------------");
end

    $finish;
end




endmodule