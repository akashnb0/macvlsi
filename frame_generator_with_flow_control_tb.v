module frame_generator_with_flow_control_tb;

    reg clk;
    reg reset;
    reg start;
    reg flow_control_enable;
    reg [7:0] frame_data_in0, frame_data_in1, frame_data_in2, frame_data_in3, frame_data_in4;
    reg [7:0] frame_data_in5, frame_data_in6, frame_data_in7, frame_data_in8, frame_data_in9;
    reg [7:0] frame_data_in10, frame_data_in11, frame_data_in12, frame_data_in13, frame_data_in14;
    reg [7:0] frame_data_in15;
    wire [9:0] frame_data_with_sync;

    // Instantiate frame generator with flow control
    frame_generator_with_flow_control uut (
        .clk(clk),
        .reset(reset),
        .start(start),
        .flow_control_enable(flow_control_enable),
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
        .frame_data_with_sync(frame_data_with_sync)
    );

    // Clock generation
    always begin
        #5 clk = ~clk;
    end

    // VCD Dump
    initial begin
        // Open VCD file for waveform dump
        $dumpfile("frame_generator_with_flow_control_tb.vcd");
        $dumpvars(0, frame_generator_with_flow_control_tb);

        // Initialize signals
        clk = 0;
        reset = 0;
        start = 0;
        flow_control_enable = 0;
        frame_data_in0 = 8'hAA; frame_data_in1 = 8'hBB; frame_data_in2 = 8'hCC;
        frame_data_in3 = 8'hDD; frame_data_in4 = 8'hEE; frame_data_in5 = 8'hFF;
        frame_data_in6 = 8'h01; frame_data_in7 = 8'h02; frame_data_in8 = 8'h03;
        frame_data_in9 = 8'h04; frame_data_in10 = 8'h05; frame_data_in11 = 8'h06;
        frame_data_in12 = 8'h07; frame_data_in13 = 8'h08; frame_data_in14 = 8'h09;
        frame_data_in15 = 8'h10;

        // Test sequence
        reset = 1; #10 reset = 0; // Apply reset
        start = 1; #10 start = 0;  // Start transmission
        #100 flow_control_enable = 1; // Enable flow control after 100ns
        #50 flow_control_enable = 0;  // Disable flow control

        // Finish the simulation after a while
        #200 $finish;
    end

endmodule
