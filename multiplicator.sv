module multiplicator #(parameter WIDTH = 4) (
  input wire [WIDTH-1:0] a, b, c,
  output wire [WIDTH*3-1:0] multiplication
);

  assign multiplication = a * b * c;
endmodule
