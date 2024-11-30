module frame_receiver(
    input wire [7:0] frame_data,   // Frame data input from the sender
    input wire [7:0] crc_received, // Received CRC
    input wire clk,                 // Clock
    input wire reset,               // Reset
    output reg crc_valid           // Signal indicating CRC validity
);

    reg [7:0] received_crc;        // Store calculated CRC

    // Always block to simulate CRC checking at each byte reception
    always @(posedge clk or posedge reset) begin
        if (reset) begin
            received_crc <= 8'h00;
            crc_valid <= 0;
        end else begin
            // Compute CRC (simple check here for demonstration)
            received_crc <= received_crc ^ frame_data;  // XOR each byte (just for simplicity)
            
            // After the last byte, validate CRC
            if (frame_data == 8'h10) begin // If last byte is received (example condition)
                if (received_crc == crc_received) begin
                    crc_valid <= 1;  // CRC is valid
                end else begin
                    crc_valid <= 0;  // CRC mismatch
                end
            end
        end
    end
endmodule
