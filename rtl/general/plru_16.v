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

assign plru_replace_idx = func_vec16r(plru_way_sel);

//  Update status
wire [5 : 0] plru_update_idx = plru_hit ? plru_hit_idx : plru_replace_idx;
wire [15 : 0] plru_update_idx_sel = func_vec16(plru_update_idx);


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


wire plru_update_ena = plru_req | (plru_hit & (plru_last_idx != plru_hit_idx));
assign plru_status_nxt = plru_update_ena ? plru_update_status_sel ^ plru_status : plru_status;

gnrl_dfflr #(
    .DATA_WIDTH(15),
    .INITIAL_VALUE(0)
) plru_status_dfflr (plru_update_ena, plru_status_nxt, plru_status, clk, rst_n);

//  Functions
function [15 : 0] func_vec16;
    input [3 : 0] i_index;
    
    case (i_index)
        4'd0  : func_vec16 = 16'b0000_0000_0000_0001;
        4'd1  : func_vec16 = 16'b0000_0000_0000_0010;
        4'd2  : func_vec16 = 16'b0000_0000_0000_0100;
        4'd3  : func_vec16 = 16'b0000_0000_0000_1000;
        4'd4  : func_vec16 = 16'b0000_0000_0001_0000;
        4'd5  : func_vec16 = 16'b0000_0000_0010_0000;
        4'd6  : func_vec16 = 16'b0000_0000_0100_0000;
        4'd7  : func_vec16 = 16'b0000_0000_1000_0000;
        4'd8  : func_vec16 = 16'b0000_0001_0000_0000;
        4'd9  : func_vec16 = 16'b0000_0010_0000_0000;
        4'd10 : func_vec16 = 16'b0000_0100_0000_0000;
        4'd11 : func_vec16 = 16'b0000_1000_0000_0000;
        4'd12 : func_vec16 = 16'b0001_0000_0000_0000;
        4'd13 : func_vec16 = 16'b0010_0000_0000_0000;
        4'd14 : func_vec16 = 16'b0100_0000_0000_0000;
        4'd15 : func_vec16 = 16'b1000_0000_0000_0000;    
        default: 
                func_vec16 = 16'b0000_0000_0000_0000;
    endcase

endfunction 

function [3 : 0] func_vec16r;
    input   [15 : 0] bit_map;

    case (bit_map)
        16'b0000_0000_0000_0001 : func_vec16r = 4'd0;
        16'b0000_0000_0000_0010 : func_vec16r = 4'd1;
        16'b0000_0000_0000_0100 : func_vec16r = 4'd2;
        16'b0000_0000_0000_1000 : func_vec16r = 4'd3;
        16'b0000_0000_0001_0000 : func_vec16r = 4'd4;
        16'b0000_0000_0010_0000 : func_vec16r = 4'd5;
        16'b0000_0000_0100_0000 : func_vec16r = 4'd6;
        16'b0000_0000_1000_0000 : func_vec16r = 4'd7;
        16'b0000_0001_0000_0000 : func_vec16r = 4'd8;
        16'b0000_0010_0000_0000 : func_vec16r = 4'd9;
        16'b0000_0100_0000_0000 : func_vec16r = 4'd10;
        16'b0000_1000_0000_0000 : func_vec16r = 4'd11;
        16'b0001_0000_0000_0000 : func_vec16r = 4'd12;
        16'b0010_0000_0000_0000 : func_vec16r = 4'd13;
        16'b0100_0000_0000_0000 : func_vec16r = 4'd14;
        16'b1000_0000_0000_0000 : func_vec16r = 4'd15;
        default: func_vec16r = 4'd0;
    endcase

endfunction

endmodule   //  plru16_module

`endif  /*  !__GNRL_PLRU_16_V__!     */
