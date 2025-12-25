module day01p1_top ( 
    input logic clk_i,
    input logic rst_ni,
    
    // 0: left, 1: right
    input logic direction_i, 
    input logic [15:0] amount_i,

    output logic [15:0] result_o,
    output logic ready_o
);

typedef enum logic [1:0] { 
    Start,
    Idle, 
    Process,
    Evaluate
} state_t;

state_t state_q, state_d;

logic [15:0] dial_q, dial_d;

logic dir_q, dir_d;
logic [15:0] amount_q, amount_d;

logic [15:0] zero_cntr_q, zero_cntr_d;

always_comb begin
    state_d = state_q;
    dial_d = dial_q;
    dir_d = dir_q;
    amount_d = amount_q;
    zero_cntr_d = zero_cntr_q;

    case (state_q)

        Start: begin
            state_d = Idle;
            dial_d = 16'd50;
            dir_d = 1'b0;
            amount_d = 16'b0;
            zero_cntr_d = 16'b0;
        end

        // Wait for input and process afterwards
        Idle: begin
            if (amount_i != 16'b0) begin
                state_d = Process;
                dir_d = direction_i;
                amount_d = amount_i;  
            end
        end

        // Apply rotation or reduce if not in range
        Process: begin 
            if ( amount_q > 16'd100 ) begin
                amount_d = amount_q - 16'd100;
                state_d = Process;
            end else if( dir_q == 1'b0 && amount_q <= dial_q ) begin
                dial_d = dial_q - amount_q;
                state_d = Evaluate;
            end else if( dir_q == 1'b1 && (dial_q + amount_q < 17'd100) ) begin
                dial_d = dial_q + amount_q;
                state_d = Evaluate;
            end else if (dir_q == 1'b0) begin
                dial_d = dial_q + 16'd100 - amount_q;
                state_d = Evaluate;
            end else if (dir_q == 1'b1) begin 
                dial_d = dial_q + amount_q - 16'd100;
                state_d = Evaluate;
            end
        end

        // Only count up if landed at zero, otherwise idle
        Evaluate: begin
            if ( dial_q == 16'b0 ) begin
                zero_cntr_d = zero_cntr_q + 16'b1;
            end
            state_d = Idle;
        end
        
    endcase
end

always_ff @( posedge clk_i, negedge rst_ni ) begin
    if(rst_ni == 1'b0) begin
        state_q <= Start;
        dial_q <= 16'd50;
        dir_q <= 1'b0;
        amount_q <= 16'b0;
        zero_cntr_q <= 16'b0;
    end else begin
        state_q <= state_d;
        dial_q <= dial_d;
        dir_q <= dir_d;
        amount_q <= amount_d;
        zero_cntr_q <= zero_cntr_d;
    end
end

assign result_o = zero_cntr_q;
assign ready_o = (state_q == Idle);

endmodule