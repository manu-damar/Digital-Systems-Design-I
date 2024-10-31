module tb_multiplicator;
  
  parameter WIDTH = 5;
  integer counter=0, sync=0;
  bit clk;
  
  reg [WIDTH-1:0] a, b, c;
  wire [WIDTH*3-1:0] multiplication;
  
  multiplicator #(WIDTH) dut (
    .a(a),
    .b(b),
    .c(c),
    .multiplication(multiplication)
  );
  
  initial begin
    $dumpfile("dump.vcd");
    $dumpvars;
  end
  
  
  always #5ns clk = !clk; 		//Clock signal
  
  always @(posedge clk) begin	// Stopper
    counter = counter + 1;
    if (counter >= 10)
      $stop;
  end
  
  always @(posedge clk) begin	//Sync signal
    sync = sync + 1;
    if (sync > 3)
      sync = 1;
  end
  
  
  
  always @(sync) begin		//Process 1
    if (sync == 3) begin
    	a = $urandom;
    	$write("Process 1. A: %4d,   0b%b\n", a, a);
    end
  end 
  
  always @(sync) begin		//Process 2
    if (sync == 2) begin
    	b = $urandom;
    	$write("Process 2. B: %4d,   0b%b\n", b, b);
    end
  end 
  
  always @(sync) begin		//Process 3
    if (sync == 1) begin
    	c = $urandom;
    	$write("Process 3. C: %4d,   0b%b\n", c, c);
    end
  end
  

  
  
  
endmodule
