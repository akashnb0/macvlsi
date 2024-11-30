module frame_generator_with_sync(
    output reg [9:0] frame_data_with_sync,  // Frame data + Start/Stop bits (10 bits)
    input wire clk,                          // Clock input
    input wire reset,                        // Reset input
    input wire start,                        // Start signal for frame generation
    input wire [7:0] frame_data_in0,         // Frame data byte 0
    input wire [7:0] frame_data_in1,         // Frame data byte 1
    input wire [7:0] frame_data_in2,         // Frame data byte 2
    input wire [7:0] frame_data_in3,         // Frame data byte 3
    input wire [7:0] frame_data_in4,         // Frame data byte 4
    input wire [7:0] frame_data_in5,         // Frame data byte 5
    input wire [7:0] frame_data_in6,         // Frame data byte 6
    input wire [7:0] frame_data_in7,         // Frame data byte 7
    input wire [7:0] frame_data_in8,         // Frame data byte 8
    input wire [7:0] frame_data_in9,         // Frame data byte 9
    input wire [7:0] frame_data_in10,        // Frame data byte 10
    input wire [7:0] frame_data_in11,        // Frame data byte 11
    input wire [7:0] frame_data_in12,        // Frame data byte 12
    input wire [7:0] frame_data_in13,        // Frame data byte 13
    input wire [7:0] frame_data_in14,        // Frame data byte 14
    input wire [7:0] frame_data_in15         // Frame data byte 15
);

    reg [3:0] byte_counter;                 // Byte counter to track frame progress
    reg transmitting;                        // Flag for transmission
    reg start_bit;                           // Start bit (low-active)
    reg stop_bit;                            // Stop bit (high-active)
    
    // Always block to control frame generation and add start/stop bits
    always @(posedge clk or posedge reset) begin
        if (reset) begin
            frame_data_with_sync <= 10'h000;
            byte_counter <= 4'b0000;
            transmitting <= 1'b0;
            start_bit <= 1'b0;   // Start bit (0)
            stop_bit <= 1'b1;    // Stop bit (1)
        end else if (start && !transmitting) begin
            transmitting <= 1'b1;
            byte_counter <= 4'b0000;  // Start from first byte
        end else if (transmitting) begin
            // Insert start bit before the frame byte and stop bit after
            case(byte_counter)
                4'b0000: frame_data_with_sync <= {stop_bit, frame_data_in0, start_bit};
                4'b0001: frame_data_with_sync <= {stop_bit, frame_data_in1, start_bit};
                4'b0010: frame_data_with_sync <= {stop_bit, frame_data_in2, start_bit};
                4'b0011: frame_data_with_sync <= {stop_bit, frame_data_in3, start_bit};
                4'b0100: frame_data_with_sync <= {stop_bit, frame_data_in4, start_bit};
                4'b0101: frame_data_with_sync <= {stop_bit, frame_data_in5, start_bit};
                4'b0110: frame_data_with_sync <= {stop_bit, frame_data_in6, start_bit};
                4'b0111: frame_data_with_sync <= {stop_bit, frame_data_in7, start_bit};
                4'b1000: frame_data_with_sync <= {stop_bit, frame_data_in8, start_bit};
                4'b1001: frame_data_with_sync <= {stop_bit, frame_data_in9, start_bit};
                4'b1010: frame_data_with_sync <= {stop_bit, frame_data_in10, start_bit};
                4'b1011: frame_data_with_sync <= {stop_bit, frame_data_in11, start_bit};
                4'b1100: frame_data_with_sync <= {stop_bit, frame_data_in12, start_bit};
                4'b1101: frame_data_with_sync <= {stop_bit, frame_data_in13, start_bit};
                4'b1110: frame_data_with_sync <= {stop_bit, frame_data_in14, start_bit};
                4'b1111: frame_data_with_sync <= {stop_bit, frame_data_in15, start_bit};
                default: frame_data_with_sync <= 10'h000;
            endcase

            byte_counter <= byte_counter + 1;
            if (byte_counter == 4'b1111) begin
                transmitting <= 1'b0;  // End transmission
            end
        end
    end
endmodule
