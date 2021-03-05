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

assign o_plru_replace_idx = func_vec4r(plru_way_sel);

//
wire [1 : 0] plru_update_idx = i_plru_hit ? i_plru_hit_idx : o_plru_replace_idx;
wire [3 : 0] plru_update_idx_sel = func_vec4(plru_update_idx);


//
wire [2 : 0] plru_update_status_sel;
assign plru_update_status_sel[1] = plru_update_idx_sel[0] | plru_update_idx_sel[1];
assign plru_update_status_sel[2] = plru_update_idx_sel[2] | plru_update_idx_sel[3];

assign plru_update_status_sel[0] = plru_update_status_sel[1] | plru_update_status_sel[2];

wire plru_update_ena = (i_plru_req | i_plru_hit );
assign plru_status_nxt = plru_update_ena ? plru_update_status_sel ^ plru_status : plru_status;

gnrl_dfflr #(
    .DATA_WIDTH(3),
    .INITIAL_VALUE(0)
) plru_status_dfflr (plru_update_ena, plru_status_nxt, plru_status, clk, rst_n);

//  Functions
function [3 : 0] func_vec4;
    input [1 : 0] i_index;

    case (i_index)
        2'd0: func_vec4 = 4'b0001;
        2'd1: func_vec4 = 4'b0010;
        2'd2: func_vec4 = 4'b0100;
        2'd3: func_vec4 = 4'b1000;
        default: func_vec4 = 4'd0;
    endcase
endfunction

function [1 : 0] func_vec4r;
    input [3 : 0] bit_map;

    case (bit_map)
        4'b0001: func_vec4r = 2'd0;
        4'b0010: func_vec4r = 2'd1;
        4'b0100: func_vec4r = 2'd2;
        4'b1000: func_vec4r = 2'd3;
        default: func_vec4r = 2'd0;
    endcase
endfunction


endmodule   //  plru4_module

`endif  /*  !__GNRL_PLRU_4_V__! */
