`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Institution: CINVESTAV Guadalajara Unit 
// Engineer: Emmanuel Diaz Marin
// 
// Create Date: 17.11.2024 20:53:37
// Design Name: 
// Module Name: traffic_lights_tb
// Project Name: 
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


module traffic_lights_tb();

 bit clk;
 trafficLightsInterface tlInterface(.clk(clk));        // Interface instantiation
 
 traffic_lights DUT(
  .clk(tlInterface.clk),
  .reset(tlInterface.reset),
  .redTimeOn(tlInterface.redTimeOn),
  .yellowTimeOn(tlInterface.yellowTimeOn),
  .greenTimeOn(tlInterface.greenTimeOn),
  .mode(tlInterface.mode),
  .redSwitch(tlInterface.redSwitch),
  .yellowSwitch(tlInterface.yellowSwitch),
  .greenSwitch(tlInterface.greenSwitch),
  .red(tlInterface.red),
  .yellow(tlInterface.yellow),
  .green(tlInterface.green)
 );
  
 
 always #1ns clk = !clk;                                      // Divided clock 
 
 //_________________________________________________________ Test Definitions
 `define NORMAL_MODE
 //`define MAINTENANCE_MODE 
 
 
 `ifdef NORMAL_MODE
    initial begin
    tlInterface.defaultDuration(10, 5, 25);             // Red, yellow, green time
    end
 `endif   
 
 `ifdef MAINTENANCE_MODE
     //______________________________________________________ Events declaration
    event redFlag;
    event yellowFlag;
    event greenFlag;
    
 
    initial begin
        tlInterface.maintenanceMode();
        tlInterface.redSwitch = '1;
        repeat(100) begin
         @(posedge clk);
        end
        tlInterface.redSwitch = '0;
        ->redFlag;
    end    
        
    initial begin
        wait(redFlag.triggered);
        tlInterface.greenSwitch = '1;
        repeat(250) begin
         @(posedge clk);
        end
        tlInterface.greenSwitch = '0;
        ->greenFlag;
    end
    
    initial begin
        wait(greenFlag.triggered);
        tlInterface.yellowSwitch = '1;
        repeat(250) begin
         @(posedge clk);
        end
        tlInterface.yellowSwitch = '0;
        ->yellowFlag;
    end  
 
 
 `endif
 

endmodule: traffic_lights_tb





//____________________________________________________________________ Interface DUT
interface trafficLightsInterface (input clk);
logic reset;
logic [11:0] redTimeOn;
logic [11:0] yellowTimeOn;
logic [11:0] greenTimeOn;
logic mode;                                             // 0: Normal, 1:Maintenance
logic redSwitch, yellowSwitch, greenSwitch;
logic red, yellow, green;    
  
//_____________________________________________________________________ BFM - Bus Functional Model 
                                                                    // Conjunto de tasks & functions que permiten
                                                                    // generar estimulos validos para el DUT
  

function defaultDuration(int red, yellow, green);
    mode = '0;
    reset = '0;
    redTimeOn = red;
    yellowTimeOn = yellow;
    greenTimeOn = green;
    redSwitch = '0;
    yellowSwitch = '0;
    greenSwitch = '0;

endfunction

function maintenanceMode();
    mode = '1;
    reset = '0;
    redSwitch = '0;
    yellowSwitch = '0;
    greenSwitch = '0;

endfunction
  
 
endinterface: trafficLightsInterface