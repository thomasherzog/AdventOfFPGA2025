module day03p2_top ( 
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
logic [11:0][3:0] twelve_digits_q, twelve_digits_d;

logic [3:0] index_q, index_d;
logic [63:0] power_q, power_d;

always_comb begin
    state_d = state_q;
    joltage_d = joltage_q;
    digit_d = digit_q;
    twelve_digits_d = twelve_digits_q;
    index_d = index_q;
    power_d = power_q;

    case(state_q)

        Start: begin
            state_d = Idle;
            joltage_d = 64'b0;
            digit_d = 4'b0;
            foreach (twelve_digits_d[i]) begin
                twelve_digits_d[i] = 4'b0;
            end
            index_d = 4'b0;
            power_d = 64'b0;
        end

        Idle: begin
            if (eol_i == 1'b1) begin
                state_d = Sum;
                index_d = 4'd0;
                power_d = 64'b1;
            end else if (digit_i != 4'b0) begin
                state_d = Process;
                digit_d = digit_i;
                index_d = 4'd11;
            end
        end

        Process: begin
            if (index_q == 4'b0) begin
                if(digit_q > twelve_digits_q[0]) begin
                    twelve_digits_d[0] = digit_q;
                end
                state_d = Idle;
            end else begin
                if (twelve_digits_q[index_q] < twelve_digits_q[index_q - 1]) begin
                    twelve_digits_d[index_q] = twelve_digits_q[index_q-1];
                    twelve_digits_d[index_q-1] = 0;
                end
                index_d = index_q - 4'b1;
                state_d = Process;
            end
        end

        Sum: begin
            if(index_q == 4'd12) begin
                digit_d = 4'b0;
                foreach (twelve_digits_d[i]) begin
                    twelve_digits_d[i] = 4'b0;
                end
                state_d = Idle;
            end else begin
                joltage_d = joltage_q + twelve_digits_d[index_d] * power_q;
                power_d = power_q * 64'd10;
                index_d = index_q + 4'b1;
                state_d = Sum;
            end
        end

    endcase
end

always_ff @( posedge clk_i, negedge rst_ni ) begin
    if(rst_ni == 1'b0) begin
        state_q <= Start;
        joltage_q <= 64'b0;
        digit_q <= 4'b0;
        foreach (twelve_digits_q[i]) begin
            twelve_digits_q[i] <= 4'b0;
        end
        index_q <= 4'b0;
        power_q <= 64'b0;
    end else begin
        state_q <= state_d;
        joltage_q <= joltage_d;
        digit_q <= digit_d;
        twelve_digits_q <= twelve_digits_d;
        index_q <= index_d;
        power_q <= power_d;
    end
end

assign result_o = joltage_q;
assign ready_o = (state_q == Idle);

endmodule