`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Institution: CINVESTAV Guadalajara Unit
// Engineer: Emmanuel Diaz Marin
// 
// Create Date: 09.11.2024 10:55:33
// Design Name: Activity 2
// Module Name: adder_tb
// Project Name: Test plan design for DUT   
// Description: A test plan for a DUT
// 
// Dependencies: 
// 
// Revision:
// Revision 0.01 - File Created
// Additional Comments:
// 
//////////////////////////////////////////////////////////////////////////////////
 
 
 
  
  /* Logica que genera estimulos */
 
  /* Logica que checa que el comportamiento del DUT haga match con base en la spec */
  
  /* Logica que me dice que tanto del DUT se ha ejercitado */
  

module adder_tb #(parameter WIDTH = 8);
 
 
  adderInterface #(WIDTH) adderInterfaceA();             // Creamos la instancia de la interface
 
  adder #(WIDTH) DUT (
    .a(adderInterfaceA.a),
    .b(adderInterfaceA.b),
    .sum(adderInterfaceA.sum)
  );
  
  event Test1;
  event Test2;
  event Test3;

//_____________________________________________________ Test definitions
  `define TEST1
  `define TEST2
  `define TEST3
  `define TEST4
  //`define TEST5
  
  
  
  
  `ifdef TEST1 //______________________________________ Test 1
    //////////////////////////////////////////////
    // 1. Generar una suma de 0                 //
    // 2. Generar 1000 sumas con valores random //
    // 3. Generar una suma de 0                 //
    //////////////////////////////////////////////
    initial begin
    $display("___________ TEST 1 _____________");
    $display("      ");
    $display("___________ zeros _____________");
    adderInterfaceA.add_a_b_zero();
    #10;
    $display("a: %d, b: %d, Expected sum: %d, Actual sum: %d", adderInterfaceA.a, adderInterfaceA.b, adderInterfaceA.a + adderInterfaceA.b, DUT.sum);
    $display("__________ A zero B random _____________");
    repeat(10) begin
        adderInterfaceA.add_a_zero_b_random();
        #10;
        $display("a: %d, b: %d, Expected sum: %d, Actual sum: %d", adderInterfaceA.a, adderInterfaceA.b, adderInterfaceA.a + adderInterfaceA.b, DUT.sum);
        end
    #10;
    $display("___________ zeros _____________");
    adderInterfaceA.add_a_b_zero();
    #10;
    $display("a: %d, b: %d, Expected sum: %d, Actual sum: %d", adderInterfaceA.a, adderInterfaceA.b, adderInterfaceA.a + adderInterfaceA.b, DUT.sum);
    ->Test1;
    
    //$finish;
    end
  `endif
  
 
   `ifdef TEST2 //______________________________________ Test 2
    //////////////////////////////////////////////////
    // 1. values in the middle of the range         //
    // 2. Edge test case                           //
    // 3. Addition Zero                             //
    //////////////////////////////////////////////////
    initial begin
    wait(Test1.triggered);
    $display("___________ TEST 2 _____________");
    $display("      ");    
    $display("_____ Middle range values ______");
    adderInterfaceA.middleRangeValues();
    #10;
    $display("a: %d, b: %d, Expected sum: %d, Actual sum: %d", adderInterfaceA.a, adderInterfaceA.b, adderInterfaceA.a + adderInterfaceA.b, DUT.sum);
    $display("_____ Edge Values Cases ______");
    adderInterfaceA.edgeCaseValues();
    #10;
    $display("a: %d, b: %d, Expected sum: %d, Actual sum: %d", adderInterfaceA.a, adderInterfaceA.b, adderInterfaceA.a + adderInterfaceA.b, DUT.sum);
    $display("_____ Adding Zero values ______");
    adderInterfaceA.add_a_b_zero();
    #10;
    $display("a: %d, b: %d, Expected sum: %d, Actual sum: %d", adderInterfaceA.a, adderInterfaceA.b, adderInterfaceA.a + adderInterfaceA.b, DUT.sum);
    
    ->Test2;
    //$finish;
    end
    
  `endif
 
 
 `ifdef TEST3 //______________________________________ Test 3
    //////////////////////////////////////////////////
    // 1.Alternating bits test                      //
    //                                              //
    //                                              //
    //////////////////////////////////////////////////
    initial begin
    wait(Test2.triggered);
    $display("___________ TEST 3 _____________");
    $display("      ");
    $display("_____ Alternating Bits Test ______");
    adderInterfaceA.alternatingBits();
    #10;
    $display("a: %d, b: %d, Expected sum: %d, Actual sum: %d", adderInterfaceA.a, adderInterfaceA.b, adderInterfaceA.a + adderInterfaceA.b, DUT.sum);
    ->Test3;
    end
  `endif
 
 
  `ifdef TEST4 //______________________________________ Test 4
    //////////////////////////////////////////////////
    // 1. Exhaustive Test                           //
    //   (Every value of a and b)                   //
    //                                              //
    //////////////////////////////////////////////////
    initial begin
    wait(Test3.triggered);
    $display("___________ TEST 4 _____________");
    $display("      ");    
    $display("_____ Exhaustive Test ______");
    adderInterfaceA.exhaustiveTest();
    #10;
    
    $finish;
    end
  `endif
 
 
endmodule: adder_tb





//____________________________________________________________________ Interface DUT
interface adderInterface #(parameter WIDTH = 8) ();

  logic [WIDTH-1:0] a;
  logic [WIDTH-1:0] b;
  logic [WIDTH-1:0] sum;
  
  modport DUT (input a, b, output sum);
  
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
            #10;
            $display("a: %d, b: %d, Expected sum: %d,
            Actual sum: %d", a, b, a + b, DUT.sum);
        end 
    end
    endtask
  
  
 
endinterface: adderInterface
