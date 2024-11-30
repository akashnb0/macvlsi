module frame_receiver_tb;

    // Testbench signals
    reg clk;
    reg reset;
    reg [7:0] frame_data;
    reg [7:0] crc_received;
    wire crc_valid;

    // Instantiate the receiver module
    frame_receiver uut (
        .frame_data(frame_data),
        .crc_received(crc_received),
        .crc_valid(crc_valid),
        .clk(clk),
        .reset(reset)
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
        frame_data = 8'h00;
        crc_received = 8'h00;

        // Reset the DUT
        reset = 1;
        #10 reset = 0;

        // Send a sequence of frame data and CRC for validation
        frame_data = 8'h01;
        crc_received = 8'h01; // Simulate correct CRC
        #10 frame_data = 8'h02; 
        crc_received = 8'h03; // Simulate correct CRC update
        #10 frame_data = 8'h10; // Last byte
        crc_received = 8'h11; // Final CRC for the complete frame

        // Wait for validation
        #10;

        // End simulation
        $finish;
    end

    // Dump the waveform (including crc_valid)
    initial begin
        $dumpfile("frame_receiver_tb.vcd");
        $dumpvars(0, frame_receiver_tb);
    end
endmodule
