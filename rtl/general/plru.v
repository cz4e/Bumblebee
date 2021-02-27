`ifdef __GNRL_PLRU_V__

module plru_module (
    input                               plru_hit,
    input   [5 : 0]                     plru_hit_idx,
    input                               plru_req,
    output  [5 : 0]                     plru_replace_idx,
    input                               clk,
    input                               rst_n
);

wire [62 : 0] plru_status, plru_status_nxt;
wire [63 : 0] plru_cacheline_sel;

//  Tree
assign plru_cacheline_sel[0]  = (~plru_status[0]) & (~plru_status[1]) & (~plru_status[3]) & (~plru_status[7]) & (~plru_status[15]) & (~plru_status[31]);
assign plru_cacheline_sel[1]  = (~plru_status[0]) & (~plru_status[1]) & (~plru_status[3]) & (~plru_status[7]) & (~plru_status[15]) & plru_status[31];
assign plru_cacheline_sel[2]  = (~plru_status[0]) & (~plru_status[1]) & (~plru_status[3]) & (~plru_status[7]) & plru_status[15] & (~plru_status[32]);
assign plru_cacheline_sel[3]  = (~plru_status[0]) & (~plru_status[1]) & (~plru_status[3]) & (~plru_status[7]) & plru_status[15] & plru_status[32];
assign plru_cacheline_sel[4]  = (~plru_status[0]) & (~plru_status[1]) & (~plru_status[3]) & plru_status[7] & (~plru_status[16]) & (~plru_status[33]);
assign plru_cacheline_sel[5]  = (~plru_status[0]) & (~plru_status[1]) & (~plru_status[3]) & plru_status[7] & (~plru_status[16]) & plru_status[33];
assign plru_cacheline_sel[6]  = (~plru_status[0]) & (~plru_status[1]) & (~plru_status[3]) & plru_status[7] & plru_status[16] & (~plru_status[34]);
assign plru_cacheline_sel[7]  = (~plru_status[0]) & (~plru_status[1]) & (~plru_status[3]) & plru_status[7] & plru_status[16] & plru_status[34];
assign plru_cacheline_sel[8]  = (~plru_status[0]) & (~plru_status[1]) & plru_status[3] & (~plru_status[8]) & (~plru_status[17]) & (~plru_status[35]);
assign plru_cacheline_sel[9]  = (~plru_status[0]) & (~plru_status[1]) & plru_status[3] & (~plru_status[8]) & (~plru_status[17]) & plru_status[35];
assign plru_cacheline_sel[10] = (~plru_status[0]) & (~plru_status[1]) & plru_status[3] & (~plru_status[8]) & plru_status[17] & (~plru_status[36]);
assign plru_cacheline_sel[11] = (~plru_status[0]) & (~plru_status[1]) & plru_status[3] & (~plru_status[8]) & plru_status[17] & plru_status[36];
assign plru_cacheline_sel[12] = (~plru_status[0]) & (~plru_status[1]) & plru_status[3] & plru_status[8] & (~plru_status[18]) & (~plru_status[37]);
assign plru_cacheline_sel[13] = (~plru_status[0]) & (~plru_status[1]) & plru_status[3] & plru_status[8] & (~plru_status[18]) & plru_status[37];
assign plru_cacheline_sel[14] = (~plru_status[0]) & (~plru_status[1]) & plru_status[3] & plru_status[8] & plru_status[18] & (~plru_status[38]);
assign plru_cacheline_sel[15] = (~plru_status[0]) & (~plru_status[1]) & plru_status[3] & plru_status[8] & plru_status[18] & plru_status[38];
assign plru_cacheline_sel[16] = (~plru_status[0]) & plru_status[1] & (~plru_status[4]) & (~plru_status[9]) & (~plru_status[19]) & (~plru_status[39]);
assign plru_cacheline_sel[17] = (~plru_status[0]) & plru_status[1] & (~plru_status[4]) & (~plru_status[9]) & (~plru_status[19]) & plru_status[39];
assign plru_cacheline_sel[18] = (~plru_status[0]) & plru_status[1] & (~plru_status[4]) & (~plru_status[9]) & plru_status[19] & (~plru_status[40]);
assign plru_cacheline_sel[19] = (~plru_status[0]) & plru_status[1] & (~plru_status[4]) & (~plru_status[9]) & plru_status[19] & plru_status[40];
assign plru_cacheline_sel[20] = (~plru_status[0]) & plru_status[1] & (~plru_status[4]) & plru_status[9] & (~plru_status[20]) & (~plru_status[41]);
assign plru_cacheline_sel[21] = (~plru_status[0]) & plru_status[1] & (~plru_status[4]) & plru_status[9] & (~plru_status[20]) & plru_status[41];
assign plru_cacheline_sel[22] = (~plru_status[0]) & plru_status[1] & (~plru_status[4]) & plru_status[9] & plru_status[20] & (~plru_status[42]);
assign plru_cacheline_sel[23] = (~plru_status[0]) & plru_status[1] & (~plru_status[4]) & plru_status[9] & plru_status[20] & plru_status[42];
assign plru_cacheline_sel[24] = (~plru_status[0]) & plru_status[1] & plru_status[4] & (~plru_status[10]) & (~plru_status[21]) & (~plru_status[43]);
assign plru_cacheline_sel[25] = (~plru_status[0]) & plru_status[1] & plru_status[4] & (~plru_status[10]) & (~plru_status[21]) & plru_status[43];
assign plru_cacheline_sel[26] = (~plru_status[0]) & plru_status[1] & plru_status[4] & (~plru_status[10]) & plru_status[21] & (~plru_status[44]);
assign plru_cacheline_sel[27] = (~plru_status[0]) & plru_status[1] & plru_status[4] & (~plru_status[10]) & plru_status[21] & plru_status[44];
assign plru_cacheline_sel[28] = (~plru_status[0]) & plru_status[1] & plru_status[4] & plru_status[10] & (~plru_status[22]) & (~plru_status[45]);
assign plru_cacheline_sel[29] = (~plru_status[0]) & plru_status[1] & plru_status[4] & plru_status[10] & (~plru_status[22]) & plru_status[45];
assign plru_cacheline_sel[30] = (~plru_status[0]) & plru_status[1] & plru_status[4] & plru_status[10] & plru_status[22] & (~plru_status[46]);
assign plru_cacheline_sel[31] = (~plru_status[0]) & plru_status[1] & plru_status[4] & plru_status[10] & plru_status[22] & plru_status[46];
assign plru_cacheline_sel[32] = plru_status[0] & (~plru_status[2]) & (~plru_status[5]) & (~plru_status[11]) & (~plru_status[23]) & (~plru_status[47]);
assign plru_cacheline_sel[33] = plru_status[0] & (~plru_status[2]) & (~plru_status[5]) & (~plru_status[11]) & (~plru_status[23]) & plru_status[47];
assign plru_cacheline_sel[34] = plru_status[0] & (~plru_status[2]) & (~plru_status[5]) & (~plru_status[11]) & plru_status[23] & (~plru_status[48]);
assign plru_cacheline_sel[35] = plru_status[0] & (~plru_status[2]) & (~plru_status[5]) & (~plru_status[11]) & plru_status[23] & plru_status[48];
assign plru_cacheline_sel[36] = plru_status[0] & (~plru_status[2]) & (~plru_status[5]) & plru_status[11] & (~plru_status[24]) & (~plru_status[49]);
assign plru_cacheline_sel[37] = plru_status[0] & (~plru_status[2]) & (~plru_status[5]) & plru_status[11] & (~plru_status[24]) & plru_status[49];
assign plru_cacheline_sel[38] = plru_status[0] & (~plru_status[2]) & (~plru_status[5]) & plru_status[11] & plru_status[24] & (~plru_status[50]);
assign plru_cacheline_sel[39] = plru_status[0] & (~plru_status[2]) & (~plru_status[5]) & plru_status[11] & plru_status[24] & plru_status[50];
assign plru_cacheline_sel[40] = plru_status[0] & (~plru_status[2]) & plru_status[5] & (~plru_status[12]) & (~plru_status[25]) & (~plru_status[51]);
assign plru_cacheline_sel[41] = plru_status[0] & (~plru_status[2]) & plru_status[5] & (~plru_status[12]) & (~plru_status[25]) & plru_status[51];
assign plru_cacheline_sel[42] = plru_status[0] & (~plru_status[2]) & plru_status[5] & (~plru_status[12]) & plru_status[25] & (~plru_status[52]);
assign plru_cacheline_sel[43] = plru_status[0] & (~plru_status[2]) & plru_status[5] & (~plru_status[12]) & plru_status[25] & plru_status[52];
assign plru_cacheline_sel[44] = plru_status[0] & (~plru_status[2]) & plru_status[5] & plru_status[12] & (~plru_status[26]) & (~plru_status[53]);
assign plru_cacheline_sel[45] = plru_status[0] & (~plru_status[2]) & plru_status[5] & plru_status[12] & (~plru_status[26]) & plru_status[53];
assign plru_cacheline_sel[46] = plru_status[0] & (~plru_status[2]) & plru_status[5] & plru_status[12] & plru_status[26] & (~plru_status[54]);
assign plru_cacheline_sel[47] = plru_status[0] & (~plru_status[2]) & plru_status[5] & plru_status[12] & plru_status[26] & plru_status[54];
assign plru_cacheline_sel[48] = plru_status[0] & plru_status[2] & (~plru_status[6]) & (~plru_status[13]) & (~plru_status[27]) & (~plru_status[55]);
assign plru_cacheline_sel[49] = plru_status[0] & plru_status[2] & (~plru_status[6]) & (~plru_status[13]) & (~plru_status[27]) & plru_status[55];
assign plru_cacheline_sel[50] = plru_status[0] & plru_status[2] & (~plru_status[6]) & (~plru_status[13]) & plru_status[27] & (~plru_status[56]);
assign plru_cacheline_sel[51] = plru_status[0] & plru_status[2] & (~plru_status[6]) & (~plru_status[13]) & plru_status[27] & plru_status[56];
assign plru_cacheline_sel[52] = plru_status[0] & plru_status[2] & (~plru_status[6]) & plru_status[13] & (~plru_status[28]) & (~plru_status[57]);
assign plru_cacheline_sel[53] = plru_status[0] & plru_status[2] & (~plru_status[6]) & plru_status[13] & (~plru_status[28]) & plru_status[57];
assign plru_cacheline_sel[54] = plru_status[0] & plru_status[2] & (~plru_status[6]) & plru_status[13] & plru_status[28] & (~plru_status[58]);
assign plru_cacheline_sel[55] = plru_status[0] & plru_status[2] & (~plru_status[6]) & plru_status[13] & plru_status[28] & plru_status[58];
assign plru_cacheline_sel[56] = plru_status[0] & plru_status[2] & plru_status[6] & (~plru_status[14]) & (~plru_status[29]) & (~plru_status[59]);
assign plru_cacheline_sel[57] = plru_status[0] & plru_status[2] & plru_status[6] & (~plru_status[14]) & (~plru_status[29]) & plru_status[59];
assign plru_cacheline_sel[58] = plru_status[0] & plru_status[2] & plru_status[6] & (~plru_status[14]) & plru_status[29] & (~plru_status[60]);
assign plru_cacheline_sel[59] = plru_status[0] & plru_status[2] & plru_status[6] & (~plru_status[14]) & plru_status[29] & plru_status[60];
assign plru_cacheline_sel[60] = plru_status[0] & plru_status[2] & plru_status[6] & plru_status[14] & (~plru_status[30]) & (~plru_status[61]);
assign plru_cacheline_sel[61] = plru_status[0] & plru_status[2] & plru_status[6] & plru_status[14] & (~plru_status[30]) & plru_status[61];
assign plru_cacheline_sel[62] = plru_status[0] & plru_status[2] & plru_status[6] & plru_status[14] & plru_status[30] & (~plru_status[62]);
assign plru_cacheline_sel[63] = plru_status[0] & plru_status[2] & plru_status[6] & plru_status[14] & plru_status[30] & plru_status[62];


//  Update status
wire [5 : 0] plru_update_idx = plru_hit ? plru_hit_idx : plru_replace_idx;
wire [63 : 0] plru_update_idx_sel;

genvar j;
generate
    for(j = 0; j < 64; j = j + 1) begin
       assign plru_update_idx_sel[j] = (plru_update_idx == j);
    end
endgenerate

//
wire [62 : 0] plru_update_status_sel;
assign plru_update_status_sel[31] = plru_update_idx_sel[0]  | plru_update_idx_sel[1];
assign plru_update_status_sel[32] = plru_update_idx_sel[2]  | plru_update_idx_sel[3];
assign plru_update_status_sel[33] = plru_update_idx_sel[4]  | plru_update_idx_sel[5];
assign plru_update_status_sel[34] = plru_update_idx_sel[6]  | plru_update_idx_sel[7];
assign plru_update_status_sel[35] = plru_update_idx_sel[8]  | plru_update_idx_sel[9];
assign plru_update_status_sel[36] = plru_update_idx_sel[10] | plru_update_idx_sel[11];
assign plru_update_status_sel[37] = plru_update_idx_sel[12] | plru_update_idx_sel[13];
assign plru_update_status_sel[38] = plru_update_idx_sel[14] | plru_update_idx_sel[15];
assign plru_update_status_sel[39] = plru_update_idx_sel[16] | plru_update_idx_sel[17];
assign plru_update_status_sel[40] = plru_update_idx_sel[18] | plru_update_idx_sel[19];
assign plru_update_status_sel[41] = plru_update_idx_sel[20] | plru_update_idx_sel[21];
assign plru_update_status_sel[42] = plru_update_idx_sel[22] | plru_update_idx_sel[23];
assign plru_update_status_sel[43] = plru_update_idx_sel[24] | plru_update_idx_sel[25];
assign plru_update_status_sel[44] = plru_update_idx_sel[26] | plru_update_idx_sel[27];
assign plru_update_status_sel[45] = plru_update_idx_sel[28] | plru_update_idx_sel[29];
assign plru_update_status_sel[46] = plru_update_idx_sel[30] | plru_update_idx_sel[31];
assign plru_update_status_sel[47] = plru_update_idx_sel[32] | plru_update_idx_sel[33];
assign plru_update_status_sel[48] = plru_update_idx_sel[34] | plru_update_idx_sel[35];
assign plru_update_status_sel[49] = plru_update_idx_sel[36] | plru_update_idx_sel[37];
assign plru_update_status_sel[50] = plru_update_idx_sel[38] | plru_update_idx_sel[39];
assign plru_update_status_sel[51] = plru_update_idx_sel[40] | plru_update_idx_sel[41];
assign plru_update_status_sel[52] = plru_update_idx_sel[42] | plru_update_idx_sel[43];
assign plru_update_status_sel[53] = plru_update_idx_sel[44] | plru_update_idx_sel[45];
assign plru_update_status_sel[54] = plru_update_idx_sel[46] | plru_update_idx_sel[47];
assign plru_update_status_sel[55] = plru_update_idx_sel[48] | plru_update_idx_sel[49];
assign plru_update_status_sel[56] = plru_update_idx_sel[50] | plru_update_idx_sel[51];
assign plru_update_status_sel[57] = plru_update_idx_sel[52] | plru_update_idx_sel[53];
assign plru_update_status_sel[58] = plru_update_idx_sel[54] | plru_update_idx_sel[55];
assign plru_update_status_sel[59] = plru_update_idx_sel[56] | plru_update_idx_sel[57];
assign plru_update_status_sel[60] = plru_update_idx_sel[58] | plru_update_idx_sel[59];
assign plru_update_status_sel[61] = plru_update_idx_sel[60] | plru_update_idx_sel[61];
assign plru_update_status_sel[62] = plru_update_idx_sel[62] | plru_update_idx_sel[63];

assign plru_update_status_sel[15] = plru_update_status_sel[31] | plru_update_status_sel[32];
assign plru_update_status_sel[16] = plru_update_status_sel[33] | plru_update_status_sel[34];
assign plru_update_status_sel[17] = plru_update_status_sel[35] | plru_update_status_sel[36];
assign plru_update_status_sel[18] = plru_update_status_sel[37] | plru_update_status_sel[38];
assign plru_update_status_sel[19] = plru_update_status_sel[39] | plru_update_status_sel[40];
assign plru_update_status_sel[20] = plru_update_status_sel[41] | plru_update_status_sel[42];
assign plru_update_status_sel[21] = plru_update_status_sel[43] | plru_update_status_sel[44];
assign plru_update_status_sel[22] = plru_update_status_sel[45] | plru_update_status_sel[46];
assign plru_update_status_sel[23] = plru_update_status_sel[47] | plru_update_status_sel[48];
assign plru_update_status_sel[24] = plru_update_status_sel[49] | plru_update_status_sel[50];
assign plru_update_status_sel[25] = plru_update_status_sel[51] | plru_update_status_sel[52];
assign plru_update_status_sel[26] = plru_update_status_sel[53] | plru_update_status_sel[54];
assign plru_update_status_sel[27] = plru_update_status_sel[55] | plru_update_status_sel[56];
assign plru_update_status_sel[28] = plru_update_status_sel[57] | plru_update_status_sel[58];
assign plru_update_status_sel[29] = plru_update_status_sel[59] | plru_update_status_sel[60];
assign plru_update_status_sel[30] = plru_update_status_sel[61] | plru_update_status_sel[62];

assign plru_update_status_sel[7]  = plru_update_status_sel[15] | plru_update_status_sel[16];
assign plru_update_status_sel[8]  = plru_update_status_sel[17] | plru_update_status_sel[18];
assign plru_update_status_sel[9]  = plru_update_status_sel[19] | plru_update_status_sel[20];
assign plru_update_status_sel[10] = plru_update_status_sel[21] | plru_update_status_sel[22];
assign plru_update_status_sel[11] = plru_update_status_sel[23] | plru_update_status_sel[24];
assign plru_update_status_sel[12] = plru_update_status_sel[25] | plru_update_status_sel[26];
assign plru_update_status_sel[13] = plru_update_status_sel[27] | plru_update_status_sel[28];
assign plru_update_status_sel[14] = plru_update_status_sel[29] | plru_update_status_sel[30];

assign plru_update_status_sel[3] = plru_update_status_sel[7] | plru_update_status_sel[8];
assign plru_update_status_sel[4] = plru_update_status_sel[9] | plru_update_status_sel[10];
assign plru_update_status_sel[5] = plru_update_status_sel[11] | plru_update_status_sel[12];
assign plru_update_status_sel[6] = plru_update_status_sel[13] | plru_update_status_sel[14];

assign plru_update_status_sel[1] = plru_update_status_sel[3] | plru_update_status_sel[4];
assign plru_update_status_sel[2] = plru_update_status_sel[5] | plru_update_status_sel[6];

assign plru_update_status_sel[0] = plru_update_status_sel[1] | plru_update_status_sel[2];


//  Update Logic
integer i;
reg match;
reg [5 : 0] plru_match_idx, plru_last_idx;

always @(*) begin
    match = 1'b0;
    if(plru_req) begin
        for(i = 0; i < 64; i = i + 1) begin
            if(plru_cacheline_sel[i] && !match) begin
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
    .DATA_WIDTH(63),
    .INITIAL_VALUE(0)
) plru_status_dfflr (plru_update_ena, plru_status_nxt, plru_status, clk, rst_n);

endmodule

`endif  /*  !__GNRL_PLRU_V__!    */
