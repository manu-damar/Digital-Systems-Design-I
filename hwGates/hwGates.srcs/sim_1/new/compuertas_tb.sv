`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date: 08.11.2024 21:07:07
// Design Name: 
// Module Name: compuertas_tb
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

// 2 procesos que randomizen (std::randomize) las a y b respectivamente ( 5 ciclos )
// imprimiendo con otros procesos concurrentes a, b, (and) cada flanco de reloj en el siguiente orden (1- and, 2- b, 3- a) ( 5 ciclos )
 
module tb_compuertas#(parameter WIDTH = 4);
 
	// Declaracion de variables //
  bit clk; 
  reg [WIDTH-1:0] a = 4'b0000;
  reg [WIDTH-1:0] b = 4'b0000;
  reg [WIDTH-1:0] bitwise_and;
  reg [WIDTH-1:0] bitwise_or;
  reg [WIDTH-1:0] bitwise_xor;
  integer i=0;
  event a_ev;
  event b_ev;
  event and_ev;
  event printedb_ev;
  event printedc_ev;
	
	                               
  always #10ns clk=!clk;           // Proceso de la señal de reloj
 
  initial begin 				   // Proceso 1
	   forever begin 			   // Debe llevar el forever si no, solo se ejecuta una vez
	   @(posedge clk); 	           // El @ es un operador para esperar un evento
	   std::randomize(a);          // Randomizamos a utilizando la libreria standard
	   ->a_ev; 					   // Triggers el evento por 1 timestep
	   end
  end
 
  always begin 					   // Proceso 2
  @(posedge clk); 	               // El @ es un operador para esperar un evento
  std::randomize(b);               // Randomizamos a utilizando la libreria standard
  ->b_ev; 					       // Triggers el evento por 1 timestep
  ->and_ev; 				       // Triggers el evento por 1 timestep
  end
 
  initial begin                    // Se ejecuta en t=0
 
  fork
 
  begin                            // Proceso 3
    repeat(5) begin
    @(posedge clk); 	           // El @ es un operador para esperar un evento
    wait(a_ev.triggered);
    wait(printedb_ev.triggered);
    $display("a: %b", a);          // Tercero a ser visto
    end
  end
 
  begin                            // Proceso 4
   repeat(5) begin
   @(posedge clk); 	               // El @ es un operador para esperar un evento
   wait(b_ev.triggered);
   wait(printedc_ev.triggered);
   $display("b: %b", b);           // Segundo a ser visto
   ->printedb_ev;
   end
  end
 
  begin                               // Proceso 5
   repeat(5) begin
   @(posedge clk); 	                  // El @ es un operador para esperar un evento
   wait(and_ev.triggered);
   $display("and: %b", bitwise_and);  // Primero a ser visto
   ->printedc_ev;
   end
  end
 
 join
 
end
 
 
  // instanciación del modulo y asingacion de entradas y salidas
  compuertas #(.WIDTH(4)) DUT (
    .a(a),
    .b(b),
    .bitwise_and(bitwise_and),
    .bitwise_or(bitwise_or),
    .bitwise_xor(bitwise_xor)
  );
 
  initial begin 
    $dumpfile("filel.vcd");
    $dumpvars;
  end
 
endmodule
