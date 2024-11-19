`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Institution: CINVESTAV Unidad Guadalajara 
// Engineer: Emmanuel Díaz Marín
// 
// Create Date: 13.11.2024 16:25:36
// Design Name: 
// Module Name: adderTestBench
// Project Name: Assertion planning
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



module adder_tb #(parameter WIDTH = 8);
  bit clk;
 
  adderInterface #(WIDTH) adderInterfaceA(.clk(clk));//___________ Interface instantiation
 
 //_______________________________________________________________ DUT instantiation
  adderWithCarryOut #(WIDTH) DUT (                  
    .a(adderInterfaceA.a),
    .b(adderInterfaceA.b),
    .carryOut(adderInterfaceA.carryOut),
    .result(adderInterfaceA.result)
  );
  
  
  //______________________________________________________________ Assertion definitions 
  
  property resultCheck;                                        // Basic operation check (adding a and b)
    @(posedge clk) (adderInterfaceA.a + adderInterfaceA.b) == DUT.result; 
  endproperty
  ast_result_correctly_computed: assert property (resultCheck) else $error("Assertion violation: ast_result_correctly_computed failed"); 
  
  
  property zeroInputCheck;                                     // Comprobation on zero adding
    @(posedge clk) 
        (adderInterfaceA.a == 0 && adderInterfaceA.b == 0) |-> (adderInterfaceA.result == 0 && adderInterfaceA.carryOut == 0);
    endproperty
  ast_zeros_addition: assert property (zeroInputCheck) else $error("Assertion violation: ast_zeros_addition failed");
  
  
  property carryGenerationCheck;                               // Carry Out == 1 comprobation 
    @(posedge clk)
        (adderInterfaceA.a + adderInterfaceA.b) >= (2**WIDTH) |-> (adderInterfaceA.carryOut == 1); 
  endproperty
  ast_carry_out_generation: assert property (carryGenerationCheck) else $error("Assertion violation: ast_carry_out_generation failed");
 
  property noCarryCheck;                                       // Carry out == 0 comprobation
    @(posedge clk)
        (adderInterfaceA.a + adderInterfaceA.b) < (2**WIDTH) |-> (adderInterfaceA.carryOut == 0); 
  endproperty
  ast_no_carry_generation: assert property (noCarryCheck) else $error("Assertion violation: ast_no_carry_generation failed");
  
  
  property evenAdditionCheck;                                   // Even addition comprobation, result LSB == 0
    @(posedge clk)
        (adderInterfaceA.a[0] == 0 && adderInterfaceA.b[0] == 0) |-> (adderInterfaceA.result[0] == 0); 
  endproperty
  ast_even_addition_correctly_computed :assert property (evenAdditionCheck) else $error("Assertion violation: ast_even_addition_correctly_computed failed");
  
  
  



  always #1ns clk = !clk;                               // Clock Definitions
  

//_____________________________________________________ Test definitions
  `define TEST1
  `define TEST2
  `define TEST3
  `define TEST4
  //`define TEST5
    
    
    initial begin
        
    `ifdef TEST1 //______________________________________ Test 1
    //////////////////////////////////////////////
    // 1. Generar una suma de 0                 //
    // 2. Generar 1000 sumas con valores random //
    // 3. Generar una suma de 0                 //
    //////////////////////////////////////////////

    $display("___________ TEST 1 _____________");
    $display("      ");
    $display("___________ zeros _____________");
    adderInterfaceA.add_a_b_zero();
    @(posedge clk);
    $display("a: %d, b: %d, Expected sum: %d, Actual sum: %d", adderInterfaceA.a, adderInterfaceA.b, adderInterfaceA.a + adderInterfaceA.b, DUT.result);
    $display("__________ A zero B random _____________");
    repeat(10) begin
        adderInterfaceA.add_a_zero_b_random();
        @(posedge clk);
        $display("a: %d, b: %d, Expected sum: %d, Actual sum: %d", adderInterfaceA.a, adderInterfaceA.b, adderInterfaceA.a + adderInterfaceA.b, DUT.result);
        end
    @(posedge clk);
    $display("___________ zeros _____________");
    adderInterfaceA.add_a_b_zero();
    @(posedge clk);
    $display("a: %d, b: %d, Expected sum: %d, Actual sum: %d", adderInterfaceA.a, adderInterfaceA.b, adderInterfaceA.a + adderInterfaceA.b, DUT.result);
    
    `endif
  
    `ifdef TEST2 //______________________________________ Test 2
    //////////////////////////////////////////////////
    // 1. values in the middle of the range         //
    // 2. Edge test case                           //
    // 3. Addition Zero                             //
    //////////////////////////////////////////////////

    $display("___________ TEST 2 _____________");
    $display("      ");    
    $display("_____ Middle range values ______");
    adderInterfaceA.middleRangeValues();
    @(posedge clk);
    $display("a: %d, b: %d, Expected sum: %d, Actual sum: %d", adderInterfaceA.a, adderInterfaceA.b, adderInterfaceA.a + adderInterfaceA.b, DUT.result);
    $display("_____ Edge Values Cases ______");
    adderInterfaceA.edgeCaseValues();
    @(posedge clk);
    $display("a: %d, b: %d, Expected sum: %d, Actual sum: %d", adderInterfaceA.a, adderInterfaceA.b, adderInterfaceA.a + adderInterfaceA.b, DUT.result);
    $display("_____ Adding Zero values ______");
    adderInterfaceA.add_a_b_zero();
    @(posedge clk);
    $display("a: %d, b: %d, Expected sum: %d, Actual sum: %d", adderInterfaceA.a, adderInterfaceA.b, adderInterfaceA.a + adderInterfaceA.b, DUT.result);
        
  `endif
  
    `ifdef TEST3 //______________________________________ Test 3
    //////////////////////////////////////////////////
    // 1.Alternating bits test                      //
    //                                              //
    //                                              //
    //////////////////////////////////////////////////
    
    $display("___________ TEST 3 _____________");
    $display("      ");
    $display("_____ Alternating Bits Test ______");
    adderInterfaceA.alternatingBits();
    @(posedge clk);
    $display("a: %d, b: %d, Expected sum: %d, Actual sum: %d", adderInterfaceA.a, adderInterfaceA.b, adderInterfaceA.a + adderInterfaceA.b, DUT.result);
  `endif
 
 
  `ifdef TEST4 //______________________________________ Test 4
    //////////////////////////////////////////////////
    // 1. Exhaustive Test                           //
    //   (Every value of a and b)                   //
    //                                              //
    //////////////////////////////////////////////////
    $display("___________ TEST 4 _____________");
    $display("      ");    
    $display("_____ Exhaustive Test ______");
    adderInterfaceA.exhaustiveTest();
    @(posedge clk);
  `endif
 
  $finish;      
 end
    
 
endmodule: adder_tb





//____________________________________________________________________ Interface DUT
interface adderInterface #(parameter WIDTH = 8) (input bit clk);

  logic [WIDTH-1:0] a;
  logic [WIDTH-1:0] b;
  logic carryOut;
  logic [WIDTH-1:0] result;
  
//_____________________________________________________________________ BFM - Bus Functional Model 
                                                                    // Conjunto de tasks & functions que permiten
                                                                    // generar estimulos validos para el DUT
  

  
  function void add_a_zero_b_random();
    a = '0;
    std::randomize(b);
  endfunction
  
  function void add_b_zero_a_random();
    b = '0;
    std::randomize(a);
  endfunction
  
  function void add_a_b_random();
    std::randomize(a);
    std::randomize(b);

  endfunction
 
  function void add_a_b_zero();
    a = '0;
    b = '0;
  endfunction
  
  function void middleRangeValues();
    a = ((2**WIDTH)/2);
    b = (2**WIDTH)/2;
  endfunction
  
  function void edgeCaseValues();
    a = (2**WIDTH)-1;
    b = 1;
  endfunction
  
  function void alternatingBits();
    for(int i=0; i<WIDTH; i=i+1) begin
        if(i & 1'b0 == 1'b0)begin
            a[i] = 1'b0;
            b[i] = 1'b1;
        end else begin
            a[i] = 1'b1;
            b[i] = 1'b0;
        end 
    end
   endfunction 
    
    
    task exhaustiveTest();
    for(int i = 0; i<2**WIDTH; i = i+1)begin
        for(int j = 0; j <2**WIDTH; j = j + 1)begin
            a = i;
            b = j;
            @(posedge clk);
            $display("a: %d, b: %d, Expected sum: %d, Actual sum: %d", a, b, a + b, DUT.result);
        end 
    end
    endtask
  
  
 
  
 
endinterface: adderInterface