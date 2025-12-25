module day03p1_top ( 
    input logic clk_i,
    input logic rst_ni,
    
    input logic [3:0] digit_i,
    input logic eol_i,

    output logic [63:0] result_o,
    output logic ready_o
);

typedef enum logic [1:0] { 
    Start,
    Idle,
    Process,
    Sum
} state_t;

state_t state_q, state_d;

logic [63:0] joltage_q, joltage_d;

logic [3:0] digit_q, digit_d;
logic [3:0] left_digit_q, left_digit_d;
logic [3:0] right_digit_q, right_digit_d;

always_comb begin
    state_d = state_q;
    joltage_d = joltage_q;
    digit_d = digit_q;
    left_digit_d = left_digit_q;
    right_digit_d = right_digit_q;
    case(state_q)
        Start: begin
            state_d = Idle;
            joltage_d = 64'b0;
            digit_d = 4'b0;
            left_digit_d = 4'b0;
            right_digit_d = 4'b0;
        end
        Idle: begin
            if (eol_i == 1'b1) begin
                state_d = Sum;
            end else if (digit_i != 4'b0) begin
                state_d = Process;
                digit_d = digit_i;
            end
        end
        Process: begin
            if(left_digit_q < right_digit_q) begin
                left_digit_d = right_digit_q;
                right_digit_d = digit_q;
            end else if(digit_q > right_digit_q) begin
                right_digit_d = digit_q;
            end
            state_d = Idle;
        end
        Sum: begin
            joltage_d = joltage_q + 8'd10 * left_digit_q + {60'b0, right_digit_d};
            digit_d = 4'b0;
            left_digit_d = 4'b0;
            right_digit_d = 4'b0;
            state_d = Idle;
        end
    endcase
end

always_ff @( posedge clk_i, negedge rst_ni ) begin
    if(rst_ni == 1'b0) begin
        state_q <= Start;
        joltage_q <= 64'b0;
        digit_q <= 4'b0;
        left_digit_q <= 4'b0;
        right_digit_q <= 4'b0;
    end else begin
        state_q <= state_d;
        joltage_q <= joltage_d;
        digit_q <= digit_d;
        left_digit_q <= left_digit_d;
        right_digit_q <= right_digit_d;
    end
end

assign result_o = joltage_q;
assign ready_o = (state_q == Idle);

endmodule