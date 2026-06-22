// File: Register.sv
module Register #(parameter WIDTH = 8) (
    input  logic             clk,
    input  logic             reset,
    input  logic             load,
    input  logic [WIDTH-1:0] data_in,
    output logic [WIDTH-1:0] data_out
);

    always_ff @(posedge clk or posedge reset) begin
        if (reset)
            data_out <= 0;
        else if (load)
            data_out <= data_in;
    end

endmodule
