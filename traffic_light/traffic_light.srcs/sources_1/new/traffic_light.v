`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Institution: CINVESTAV Guadalajara Unit 
// Engineer: Emmanuel Diaz Marin
// 
// Create Date: 12.11.2024 11:14:56
// Design Name: 
// Module Name: traffic_light
// Project Name: Traffic light implementation
// Target Devices: 
// Tool Versions: 
// Description: 
// 
// Dependencies: 
// 
// Revision:
// Revision 0.01 - File Created
// Additional Comments:
// 
//////////////////////////////////////////////////////////////////////////////////


module traffic_lights (
  input clk, reset,
  input [11:0] redTimeOn, yellowTimeOn, greenTimeOn, // Time in tenths of a second
  input mode,
  input redSwitch, yellowSwitch, greenSwitch,
  output reg red, yellow, green
);

                                                    // State encoding
  localparam RED = 2'b00;
  localparam YELLOW = 2'b01;
  localparam GREEN = 2'b10;

  reg [1:0] current_state = RED;
  reg [9:0] timer = 0; 

  always @(posedge clk or posedge reset) begin
  
    if (reset) begin
      current_state <= RED;                         // Initialize to red on reset 
      timer <= 0;
      red <= 1'b1;         
      yellow <= 1'b0;
      green <= 1'b0;
    end 
    
    else if (!mode) begin                           // Normal mode
    
        case (current_state)
      
            RED: begin
                red <= 1'b1;
                yellow <= 1'b0;
                green <= 1'b0;
          
                if (timer == redTimeOn) begin
                timer <= 0;
                current_state <= GREEN;                 // Transition to green 
                end else begin
                timer <= timer + 1'b1;
                end
            end
        
            GREEN: begin                                // Green state logic
                red <= 1'b0;
                yellow <= 1'b0;
                green <= 1'b1;
          
                if (timer == greenTimeOn) begin
                timer <= 0;
                current_state <= YELLOW;
                end else begin
                timer <= timer + 1'b1;
                end
            end
        
            YELLOW: begin                               // Yellow state logic
                red <= 1'b0;
                yellow <= 1'b1;
                green <= 1'b0;
          
                if (timer == yellowTimeOn) begin
                timer <= 0;
                current_state <= RED;
                end else begin
                timer <= timer + 1'b1;
                end
            end 
        
        endcase 
    end 
    
    else if(mode) begin                                 // Maintenance mode
        red <= redSwitch;
        yellow <= yellowSwitch;
        green <= greenSwitch;        
    end
    
  end 
  
endmodule
