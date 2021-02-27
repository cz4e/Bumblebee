`ifdef __GNRL_PLRU_4_V__

module plru4_module (
    input                           i_plru_hit,
    input   [1 : 0]                 i_plru_hit_idx,
    input                           i_plru_req,
    output  [1 : 0]                 o_plru_replace_idx,
    input                           clk,
    input                           rst_n
);


wire [2: 0] plru_status, plru_status_nxt;
wire [3 : 0] plru_way_sel;

assign plru_way_sel[0] = (~plru_status[0]) & (~plru_status[1]);
assign plru_way_sel[1] = (~plru_status[0]) & plru_status[1];
assign plru_way_sel[2] = plru_status[0] & (~plru_status[2]);
assign plru_way_sel[3] = plru_status[0] & plru_status[2];

wire [1 : 0] plru_update_idx = i_plru_hit ? i_plru_hit_idx : o_plru_replace_idx;
wire [3 : 0] plru_update_idx_sel;


genvar i;
generate
    for(i = 0; i < 4; i = i + 1) begin
        assign plru_update_idx_sel[i] = (plru_update_idx == i);
    end
endgenerate

//
wire [2 : 0] plru_update_status_sel;
assign plru_update_status_sel[1] = plru_update_idx_sel[0] | plru_update_idx_sel[1];
assign plru_update_status_sel[2] = plru_update_idx_sel[2] | plru_update_idx_sel[3];

assign plru_update_status_sel[0] = plru_update_status_sel[1] | plru_update_status_sel[2];

//  Update Logic
integer j;
reg match;
reg [1 : 0] plru_match_idx;

always @(*) begin
    match = 1'b0;
    if(i_plru_req) begin
        for(j = 0; j < 4; j = j + 1) begin
            if(plru_way_sel[j] && !match) begin
                plru_match_idx = j;
                match = 1'b1;
            end
        end
    end
end

assign o_plru_replace_idx = plru_match_idx;

wire plru_update_ena = (i_plru_req | i_plru_hit );
assign plru_status_nxt = plru_update_ena ? plru_update_status_sel ^ plru_status : plru_status;

gnrl_dfflr #(
    .DATA_WIDTH(3),
    .INITIAL_VALUE(0)
) plru_status_dfflr (plru_update_ena, plru_status_nxt, plru_status, clk, rst_n);

endmodule   //  plru4_module

`endif  /*  !__GNRL_PLRU_4_V__! */
