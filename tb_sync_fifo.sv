`timescale 1ns/1ps
module tb_sync_fifo;
    localparam int DATA_WIDTH = 8;
    localparam int DEPTH = 8;

    logic clk = 0;
    logic rst_n = 0;
    logic wr_en = 0, rd_en = 0;
    logic [DATA_WIDTH-1:0] din = 0;
    logic [DATA_WIDTH-1:0] dout;
    logic full, empty;

    sync_fifo #(.DATA_WIDTH(DATA_WIDTH), .DEPTH(DEPTH)) dut (.*);
    always #5 clk = ~clk;

    task automatic tick;
        @(posedge clk); #1;
    endtask

    task automatic push(input logic [7:0] value);
        @(negedge clk);
        din = value; wr_en = 1; rd_en = 0;
        tick();
        wr_en = 0;
    endtask

    task automatic pop_expect(input logic [7:0] expected);
        @(negedge clk);
        wr_en = 0; rd_en = 1;
        tick();
        if (dout !== expected)
            $fatal(1, "FAIL: expected %02h, got %02h", expected, dout);
        rd_en = 0;
    endtask

    initial begin
        $dumpfile("fifo.vcd");
        $dumpvars(0, tb_sync_fifo);
        $display("Starting synchronous FIFO checks");

        repeat (2) tick();
        rst_n = 1;
        tick();
        if (!empty || full) $fatal(1, "FAIL: reset flags incorrect");

        // Fill to capacity and confirm full.
        for (int i = 0; i < DEPTH; i++) push(8'hA0 + i);
        if (!full || empty) $fatal(1, "FAIL: FIFO should be full");

        // Extra write while full must be ignored.
        @(negedge clk); din = 8'hFF; wr_en = 1; rd_en = 0;
        tick(); wr_en = 0;
        if (!full) $fatal(1, "FAIL: overflow changed occupancy");

        // Drain in order and confirm empty.
        for (int i = 0; i < DEPTH; i++) pop_expect(8'hA0 + i);
        if (!empty || full) $fatal(1, "FAIL: FIFO should be empty");

        // Extra read while empty must be ignored.
        @(negedge clk); wr_en = 0; rd_en = 1;
        tick(); rd_en = 0;
        if (!empty) $fatal(1, "FAIL: underflow changed occupancy");

        // Simultaneous accepted read/write preserves occupancy and ordering.
        push(8'h31); push(8'h32);
        @(negedge clk); din = 8'h33; wr_en = 1; rd_en = 1;
        tick(); wr_en = 0; rd_en = 0;
        if (dout !== 8'h31) $fatal(1, "FAIL: simultaneous read data mismatch");
        pop_expect(8'h32);
        pop_expect(8'h33);
        if (!empty) $fatal(1, "FAIL: final FIFO should be empty");

        $display("PASS: reset, fill/full, overflow, ordered drain, underflow, simultaneous read/write");
        $finish;
    end
endmodule
