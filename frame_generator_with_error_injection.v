module frame_generator_with_error_injection(
    output reg [7:0] frame_data, 
    output reg valid,            
    input wire clk,
    input wire reset,
    input wire start,
    input wire [7:0] frame_data_in0, frame_data_in1, frame_data_in2, frame_data_in3,
    input wire [7:0] frame_data_in4, frame_data_in5, frame_data_in6, frame_data_in7,
    input wire [7:0] frame_data_in8, frame_data_in9, frame_data_in10, frame_data_in11,
    input wire [7:0] frame_data_in12, frame_data_in13, frame_data_in14, frame_data_in15,
    input wire error_injection, // Error injection control signal
    input wire [7:0] error_position // Bit position to flip
);

    reg [3:0] byte_counter;
    reg transmitting;
    reg [7:0] frame_buffer [0:15]; 
    integer frame_length; 
    reg [7:0] injected_frame_data;

    // Start of Frame and End of Frame markers
    localparam SOF = 8'h7E;
    localparam EOF = 8'h7F;
    localparam MIN_FRAME_SIZE = 64; 

    always @(posedge clk or posedge reset) begin
        if (reset) begin
            frame_data <= 8'h00;
            valid <= 0;
            byte_counter <= 4'b0000;
            transmitting <= 1'b0;
            frame_length <= 0;
        end else if (start && !transmitting) begin
            transmitting <= 1'b1;
            byte_counter <= 4'b0000;
            frame_length <= 0;
            valid <= 1;
            frame_buffer[0] <= frame_data_in0;
            frame_buffer[1] <= frame_data_in1;
            frame_buffer[2] <= frame_data_in2;
            frame_buffer[3] <= frame_data_in3;
            frame_buffer[4] <= frame_data_in4;
            frame_buffer[5] <= frame_data_in5;
            frame_buffer[6] <= frame_data_in6;
            frame_buffer[7] <= frame_data_in7;
            frame_buffer[8] <= frame_data_in8;
            frame_buffer[9] <= frame_data_in9;
            frame_buffer[10] <= frame_data_in10;
            frame_buffer[11] <= frame_data_in11;
            frame_buffer[12] <= frame_data_in12;
            frame_buffer[13] <= frame_data_in13;
            frame_buffer[14] <= frame_data_in14;
            frame_buffer[15] <= frame_data_in15;
        end else if (transmitting) begin
            // Inject errors if enabled
            if (error_injection && byte_counter < 16) begin
                injected_frame_data = frame_buffer[byte_counter];
                // Inject error by flipping the specified bit in the byte
                injected_frame_data = injected_frame_data ^ (1 << error_position);
                frame_data <= injected_frame_data;
            end else if (byte_counter == 0) begin
                frame_data <= SOF; // Start of Frame
            end else if (byte_counter <= 15) begin
                frame_data <= frame_buffer[byte_counter]; // Send frame data
            end else if (byte_counter == 16) begin
                // Add padding if necessary (ensure minimum 64 bytes)
                if (frame_length < MIN_FRAME_SIZE) begin
                    frame_data <= 8'h00; // Padding byte
                end else begin
                    frame_data <= EOF; // End of Frame
                end
            end else begin
                valid <= 0; // Stop transmitting after frame is sent
                transmitting <= 1'b0;
            end

            byte_counter <= byte_counter + 1;
            frame_length <= frame_length + 1; // Increment frame length as we transmit
        end
    end
endmodule
