`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date: 03/30/2025
// Design Name: 
// Module Name: dpath_tb
// Description: Testbench for datapath with PC and offset tracking
//////////////////////////////////////////////////////////////////////////////////

module dpath_tb;

    // Inputs
    reg clk;
    reg rst;

    // Outputs
    wire [31:0] ins;

    // DUT internal signal wires for monitoring
    wire [31:0] read_data1, read_data2, alu_result, imm_out, alu_b_input;
    wire [3:0] alucon;
    wire alusrc, regwrite, signext;
    wire [1:0] immsel;
    wire [4:0] rs1, rs2, rd;
    wire [31:0] pcout;
    wire pcsel;
    wire [31:0] reg10;
    wire [31:0] reg11;

    // Offset-related wires
    wire [6:0] opcode = ins[6:0];
    wire is_jump   = (opcode == 7'b1101111); // JAL
    wire is_branch = (opcode == 7'b1100011); // BEQ, BNE, etc.

 

    // Instantiate the Unit Under Test (UUT)
    dpath uut (
        .clk(clk),
        .rst(rst),
        .ins(ins)
    );

    // Clock Generation
    always #5 clk = ~clk;

    // Internal signal tapping using hierarchical references
    assign read_data1   = uut.rf_inst.read_data1;
    assign read_data2   = uut.rf_inst.read_data2;
    assign alu_result   = uut.alu_result;
    assign alucon       = uut.alucon;
    assign alusrc       = uut.alusrc;
    assign regwrite     = uut.regwrite;
    assign signext      = uut.signext;
    assign immsel       = uut.immsel;
    assign imm_out      = uut.imm_out;
    assign alu_b_input  = uut.alu_b_input;
    assign rs1          = uut.rs1;
    assign rs2          = uut.rs2;
    assign rd           = uut.rd;
    assign pcout        = uut.pc_inst.pc;              // PC output from PC module
    assign pcsel        = uut.decoder_inst.PCsel;      // PCsel from decoder module
    assign reg10        = uut.rf_inst.registers[5];   // Register x10
    assign reg11        = uut.rf_inst.registers[6];   // Register x11
    integer cycle;


    initial begin
        // Initialize Inputs
        clk = 0;
        rst = 1;
        cycle = 0;
 

        // Hold reset for 2 time units
        #2;
        rst = 0;

        // Run simulation for enough time
        #30000;

        $finish;
    end

    always @(posedge clk) begin
        if (!rst) begin
            $display("--------------------------------------------------");
            $display("Cycle:       %0d", cycle);
            $display("PC:          0x%08h", pcout);

            $display("PCSel:       %b", pcsel);
            $display("Instruction: %b", ins);
            $display("Opcode:      %b", opcode);
            $display("JAL/Branch:  %s", is_jump ? "JAL" : (is_branch ? "BRANCH" : "OTHER"));

            $display("rs1: x%0d (%0d), rs2: x%0d (%0d), rd: x%0d", rs1, read_data1, rs2, read_data2, rd);
            $display("Immediate:   %0d", imm_out);
            $display("ALU B Input: %0d", alu_b_input);
            $display("ALU Con:     %b", alucon);
            $display("ALU Result:  %0d", alu_result);
            $display("Control:     regwrite=%b, alusrc=%b, signext=%b, immsel=%b", regwrite, alusrc, signext, immsel);
             $display("x10: %0d, x11: %0d", reg10, reg11);
            $display("--------------------------------------------------\n");

            cycle = cycle + 1;
        end
    end

endmodule

