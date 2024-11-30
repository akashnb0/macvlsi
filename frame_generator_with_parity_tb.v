module frame_generator_with_parity_tb;

    reg clk;
    reg reset;
    reg start;
    reg [7:0] frame_data_in0, frame_data_in1, frame_data_in2, frame_data_in3, frame_data_in4;
    reg [7:0] frame_data_in5, frame_data_in6, frame_data_in7, frame_data_in8, frame_data_in9;
    reg [7:0] frame_data_in10, frame_data_in11, frame_data_in12, frame_data_in13, frame_data_in14;
    reg [7:0] frame_data_in15;
    wire [8:0] frame_data_with_parity;

    // Instantiate frame generator with parity
    frame_generator_with_parity uut (
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
        .frame_data_in15(frame_data_in15),
        .frame_data_with_parity(frame_data_with_parity)
    );

    // Clock generation
    always begin
        #5 clk = ~clk;
    end

    // Test sequence
    initial begin
        clk = 0;
        reset = 0;
        start = 0;
        // Initialize frame data
        frame_data_in0 = 8'hAA; frame_data_in1 = 8'hBB; frame_data_in2 = 8'hCC;
        frame_data_in3 = 8'hDD; frame_data_in4 = 8'hEE; frame_data_in5 = 8'hFF;
        frame_data_in6 = 8'h01; frame_data_in7 = 8'h02; frame_data_in8 = 8'h03;
        frame_data_in9 = 8'h04; frame_data_in10 = 8'h05; frame_data_in11 = 8'h06;
        frame_data_in12 = 8'h07; frame_data_in13 = 8'h08; frame_data_in14 = 8'h09;
        frame_data_in15 = 8'h0A;

        // Apply reset
        reset = 1;
        #10 reset = 0;

        // Start frame generation
        start = 1;
        #10 start = 0;
        #100 $finish;
    end

    // Dump waveforms
    initial begin
        $dumpfile("frame_generator_with_parity_tb.vcd");
        $dumpvars(0, frame_generator_with_parity_tb);
    end
endmodule
