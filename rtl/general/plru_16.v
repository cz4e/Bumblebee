`ifdef __GNRL_PLRU_16_V__

module plru16_module (
    input                               plru_hit,
    input   [3 : 0]                     plru_hit_idx,
    input                               plru_req,
    output  [3 : 0]                     plru_replace_idx,
    input                               clk,
    input                               rst_n
);

wire [14 : 0] plru_status, plru_status_nxt;
wire [15 : 0] plru_way_sel;

assign plru_way_sel[0]  = (~plru_status[0]) & (~plru_status[1]) & (~plru_status[3]) & (~plru_status[7]);
assign plru_way_sel[1]  = (~plru_status[0]) & (~plru_status[1]) & (~plru_status[3]) & plru_status[7];
assign plru_way_sel[2]  = (~plru_status[0]) & (~plru_status[1]) & plru_status[3] & (~plru_status[8]);
assign plru_way_sel[3]  = (~plru_status[0]) & (~plru_status[1]) & plru_status[3] & plru_status[8];
assign plru_way_sel[4]  = (~plru_status[0]) & plru_status[1] & (~plru_status[4]) & (~plru_status[9]);
assign plru_way_sel[5]  = (~plru_status[0]) & plru_status[1] & (~plru_status[4]) & plru_status[9];
assign plru_way_sel[6]  = (~plru_status[0]) & plru_status[1] & plru_status[4] & (~plru_status[10]);
assign plru_way_sel[7]  = (~plru_status[0]) & plru_status[1] & plru_status[4] & plru_status[10];
assign plru_way_sel[8]  = plru_status[0] & (~plru_status[2]) & (~plru_status[5]) & (~plru_status[11]);
assign plru_way_sel[9]  = plru_status[0] & (~plru_status[2]) & (~plru_status[5]) & plru_status[11];
assign plru_way_sel[10] = plru_status[0] & (~plru_status[2]) & plru_status[5] & (~plru_status[12]);
assign plru_way_sel[11] = plru_status[0] & (~plru_status[2]) & plru_status[5] & plru_status[12];
assign plru_way_sel[12] = plru_status[0] & plru_status[2] & (~plru_status[6]) & (~plru_status[13]);
assign plru_way_sel[13] = plru_status[0] & plru_status[2] & (~plru_status[6]) & plru_status[13];
assign plru_way_sel[14] = plru_status[0] & plru_status[2] & plru_status[6] & (~plru_status[14]);
assign plru_way_sel[15] = plru_status[0] & plru_status[2] & plru_status[6] & plru_status[14];

//  Update status
wire [5 : 0] plru_update_idx = plru_hit ? plru_hit_idx : plru_replace_idx;
wire [15 : 0] plru_update_idx_sel;

genvar j;
generate
    for(j = 0; j < 16; j = j + 1) begin
        assign plru_update_idx_sel[j] = (plru_update_idx == j);
    end
endgenerate

//
wire [14 : 0] plru_update_status_sel;
assign plru_update_status_sel[7]   = plru_update_idx_sel[0] | plru_update_idx_sel[1];
assign plru_update_status_sel[8]   = plru_update_idx_sel[2] | plru_update_idx_sel[3];
assign plru_update_status_sel[9]   = plru_update_idx_sel[4] | plru_update_idx_sel[5];
assign plru_update_status_sel[10]  = plru_update_idx_sel[6] | plru_update_idx_sel[7];
assign plru_update_status_sel[11]  = plru_update_idx_sel[8] | plru_update_idx_sel[9];
assign plru_update_status_sel[12]  = plru_update_idx_sel[10] | plru_update_idx_sel[11];
assign plru_update_status_sel[13]  = plru_update_idx_sel[12] | plru_update_idx_sel[13];
assign plru_update_status_sel[14]  = plru_update_idx_sel[14] | plru_update_idx_sel[15];

assign plru_update_status_sel[3]   = plru_update_idx_sel[7] | plru_update_idx_sel[8];
assign plru_update_status_sel[4]   = plru_update_idx_sel[9] | plru_update_idx_sel[10];
assign plru_update_status_sel[5]   = plru_update_idx_sel[11] | plru_update_idx_sel[12];
assign plru_update_status_sel[6]   = plru_update_idx_sel[13] | plru_update_idx_sel[14];

assign plru_update_status_sel[1]   = plru_update_idx_sel[3] | plru_update_idx_sel[4];
assign plru_update_status_sel[2]   = plru_update_idx_sel[5] | plru_update_idx_sel[6];

assign plru_update_status_sel[0]   = plru_update_status_sel[1] | plru_update_status_sel[2];



//  Update Logic
integer i;
reg match;
reg [5 : 0] plru_match_idx, plru_last_idx;

always @(*) begin
    match = 1'b0;
    if(plru_req) begin
        for(i = 0; i < 64; i = i + 1) begin
            if(plru_way_sel[i] && !match) begin
                plru_last_idx = plru_replace_idx;
                plru_match_idx = i;
                match = 1'b1;
            end
        end
    end
end

assign plru_replace_idx = plru_match_idx;

wire plru_update_ena = plru_req | (plru_hit & (plru_last_idx != plru_hit_idx));
assign plru_status_nxt = plru_update_ena ? plru_update_status_sel ^ plru_status : plru_status;

gnrl_dfflr #(
    .DATA_WIDTH(15),
    .INITIAL_VALUE(0)
) plru_status_dfflr (plru_update_ena, plru_status_nxt, plru_status, clk, rst_n);

endmodule   //  plru16_module

`endif  /*  !__GNRL_PLRU_16_V__!     */
