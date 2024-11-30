module frame_generator_with_parity(
    output reg [8:0] frame_data_with_parity, // Frame data + Parity bit (9 bits total)
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
    reg parity_bit;                          // Parity bit (calculated for each byte)
    
    // Function to calculate parity (even parity)
    function calculate_parity;
        input [7:0] data;
        integer count;
        begin
            count = 0;
            for (integer i = 0; i < 8; i = i + 1) begin
                if (data[i] == 1'b1) count = count + 1;
            end
            calculate_parity = (count % 2 == 0) ? 1'b0 : 1'b1;  // Even parity
        end
    endfunction

    // Always block to control frame generation and add parity bit
    always @(posedge clk or posedge reset) begin
        if (reset) begin
            frame_data_with_parity <= 9'h000;
            byte_counter <= 4'b0000;
            transmitting <= 1'b0;
            parity_bit <= 1'b0;
        end else if (start && !transmitting) begin
            transmitting <= 1'b1;
            byte_counter <= 4'b0000;  // Start from first byte
        end else if (transmitting) begin
            // Select frame byte and calculate parity
            case(byte_counter)
                4'b0000: begin
                    parity_bit <= calculate_parity(frame_data_in0);
                    frame_data_with_parity <= {parity_bit, frame_data_in0};
                end
                4'b0001: begin
                    parity_bit <= calculate_parity(frame_data_in1);
                    frame_data_with_parity <= {parity_bit, frame_data_in1};
                end
                4'b0010: begin
                    parity_bit <= calculate_parity(frame_data_in2);
                    frame_data_with_parity <= {parity_bit, frame_data_in2};
                end
                4'b0011: begin
                    parity_bit <= calculate_parity(frame_data_in3);
                    frame_data_with_parity <= {parity_bit, frame_data_in3};
                end
                // Add remaining bytes similarly...
                default: frame_data_with_parity <= 9'h000;
            endcase

            byte_counter <= byte_counter + 1;
            if (byte_counter == 4'b1111) begin
                transmitting <= 1'b0;  // End transmission
            end
        end
    end
endmodule
