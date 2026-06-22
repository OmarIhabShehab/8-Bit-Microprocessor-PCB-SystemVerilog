// File: RingCounter.sv
module RingCounter (
    input  logic clk,
    input  logic reset,
    output logic [5:0] T // Assuming 6 states for a full cycle
);

always_ff @(negedge clk or posedge reset) begin
    if (reset)
        T <= 6'b000001;
    else begin
        case (T)
            6'b000001: T <= 6'b000010;
            6'b000010: T <= 6'b000100;
            6'b000100: T <= 6'b001000;
            6'b001000: T <= 6'b010000;
            6'b010000: T <= 6'b100000;
            6'b100000: T <= 6'b000001;
            default:   T <= 6'b000001;
        endcase
    end
end

endmodule

