module day07p1_top ( 
    input logic clk_i,
    input logic rst_ni,
    
    input logic field_i,
    input logic eol_i,

    output logic [15:0] result_o,
    output logic ready_o
);

typedef enum logic [2:0] { 
    Start,
    InitialTachyon,
    ProcessTachyon,
    IdleSplitter,
    ProcessSplitter
} state_t;

state_t state_q, state_d;

logic eol_q, eol_d;
logic field_q, field_d;

logic [15:0] beam_splits_q, beam_splits_d;
logic [7:0] board_width_q, board_width_d;
logic [7:0] index_q, index_d;

logic [149:0] current_state_q, current_state_d;
logic [149:0] next_state_q, next_state_d;

always_comb begin
    state_d = state_q;
    eol_d = eol_q;
    field_d = field_q;
    beam_splits_d = beam_splits_q;
    board_width_d = board_width_q;
    index_d = index_q;
    current_state_d = current_state_q;
    next_state_d = next_state_q;

    case(state_q)

        Start: begin
            state_d = InitialTachyon;
        end

        InitialTachyon, IdleSplitter: begin
            state_d = (state_q == InitialTachyon ? ProcessTachyon : ProcessSplitter);
            field_d = eol_i == 1'b0 ? field_i : 1'b0;
            eol_d = eol_i;
        end

        ProcessTachyon: begin
            if(field_q == 1'b1) begin
                current_state_d = current_state_q + (150'b1 << board_width_q);
            end
            if(eol_q == 1'b1) begin
                state_d = IdleSplitter;
            end else begin
                state_d = InitialTachyon;
                board_width_d = board_width_q + 1;
            end
        end

        ProcessSplitter: begin
            if (eol_q == 1'b1) begin
                index_d = 8'b0;
                current_state_d = next_state_q;
                next_state_d = 150'b0;
            end else begin
                if((((current_state_q & (150'b1 << index_q) ) >> index_q ) & ({149'b0, field_q})) == 150'b1) begin
                    if(index_q == 8'b0) begin
                        next_state_d = next_state_q | 150'b10;
                    end else if(index_q == (board_width_q - 1)) begin
                        next_state_d = next_state_q | 150'b10;
                    end else begin
                        next_state_d = next_state_q | (150'b101 << (index_q - 1));
                    end
                    beam_splits_d = beam_splits_q + 1;
                end else if(((current_state_q & (150'b1 << index_q)) >> index_q) == 150'b1) begin
                    next_state_d = next_state_q | (150'b1 << index_q);
                end

                index_d = index_q + 8'b1;
            end
            state_d = IdleSplitter;
        end

        default: begin
            state_d = Start;
            field_d = 1'b0;
            eol_d = 1'b0;
            beam_splits_d = 16'b0;
            board_width_d = 8'b0;
            index_d = 8'b0;
            current_state_d = 150'b0;
            next_state_d = 150'b0;
        end

    endcase

end

always_ff @( posedge clk_i, negedge rst_ni ) begin
    if(rst_ni == 1'b0) begin
        state_q <= Start;
        field_q <= 1'b0;
        eol_q <= 1'b0;
        beam_splits_q <= 16'b0;
        board_width_q <= 8'b0;
        index_q <= 8'b0;
        current_state_q <= 150'b0;
        next_state_q <= 150'b0;
    end else begin
        state_q <= state_d;
        field_q <= field_d;
        eol_q <= eol_d;
        beam_splits_q <= beam_splits_d;
        board_width_q <= board_width_d;
        index_q <= index_d;
        current_state_q <= current_state_d;
        next_state_q <= next_state_d;
    end
end

assign result_o = beam_splits_q;
assign ready_o = (state_q == InitialTachyon || state_q == IdleSplitter);

endmodule