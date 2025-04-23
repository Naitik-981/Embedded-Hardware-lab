module stack (
    input clk, reset, load, push, pop,
    input [15:0] d,
    output reg [15:0] qtop,
    output reg [15:0] qnext
);
    reg [15:0] stack_mem [0:15]; // 16-depth stack
    reg [3:0] sp; // Stack pointer (4-bit for 16-depth stack)

    always @(posedge clk or posedge reset) begin
        if (reset) begin
            sp <= 4'b0;
            qtop <= 16'b0;
            qnext <= 16'b0;
        end else begin
            if (push && sp < 15) begin
                stack_mem[sp] <= d;
                sp <= sp + 1;
            end

            if (pop && sp > 0) begin
                sp <= sp - 1;
            end

            if (sp > 0) begin
                qtop <= stack_mem[sp - 1];
            end else begin
                qtop <= 16'b0; // Default value when stack is empty
            end

            if (sp > 1) begin
                qnext <= stack_mem[sp - 2];
            end else begin
                qnext <= 16'b0;
            end
        end
    end
endmodule
