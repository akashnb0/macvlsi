module frame_generator_tb;

    // Testbench signals
    reg clk;
    reg reset;
    reg start;
    reg [7:0] frame_data_in0, frame_data_in1, frame_data_in2, frame_data_in3;
    reg [7:0] frame_data_in4, frame_data_in5, frame_data_in6, frame_data_in7;
    reg [7:0] frame_data_in8, frame_data_in9, frame_data_in10, frame_data_in11;
    reg [7:0] frame_data_in12, frame_data_in13, frame_data_in14, frame_data_in15;
    wire [7:0] frame_data;
    wire [7:0] crc;

    // Instantiate the frame generator module
    frame_generator uut (
        .frame_data(frame_data),
        .crc(crc),
        .clk(clk),
        .reset(reset),
        .start(start),
        .frame_data_in0(frame_data_in0),
        .frame_data_in1(frame_data_in1),
        .frame_data_in2(frame_data_in2),
        .frame_data_in3(frame_data_in3),
        .frame_data_in4(frame_data_in4),
        .frame_data_in5(frame_data_in5),
        .frame_data_in6(frame_data_in6),
        .frame_data_in7(frame_data_in7),
        .frame_data_in8(frame_data_in8),
        .frame_data_in9(frame_data_in9),
        .frame_data_in10(frame_data_in10),
        .frame_data_in11(frame_data_in11),
        .frame_data_in12(frame_data_in12),
        .frame_data_in13(frame_data_in13),
        .frame_data_in14(frame_data_in14),
        .frame_data_in15(frame_data_in15)
    );

    // Clock generation
    always begin
        #5 clk = ~clk;  // 10ns clock period
    end

    // Test sequence
    initial begin
        // Initialize signals
        clk = 0;
        reset = 0;
        start = 0;
        frame_data_in0 = 8'h01; frame_data_in1 = 8'h02; frame_data_in2 = 8'h03; frame_data_in3 = 8'h04;
        frame_data_in4 = 8'h05; frame_data_in5 = 8'h06; frame_data_in6 = 8'h07; frame_data_in7 = 8'h08;
        frame_data_in8 = 8'h09; frame_data_in9 = 8'h0A; frame_data_in10 = 8'h0B; frame_data_in11 = 8'h0C;
        frame_data_in12 = 8'h0D; frame_data_in13 = 8'h0E; frame_data_in14 = 8'h0F; frame_data_in15 = 8'h10;

        // Reset the DUT
        reset = 1;
        #10 reset = 0;

        // Start frame generation
        start = 1;
        #10 start = 0;

        // Wait for a few cycles to let the frame generation complete
        #160;

        // End of simulation
        $finish;
    end

    // Dump the waveform (including frame_data and crc)
    initial begin
        $dumpfile("frame_generator_tb.vcd");
        $dumpvars(0, frame_generator_tb);
    end
endmodule
