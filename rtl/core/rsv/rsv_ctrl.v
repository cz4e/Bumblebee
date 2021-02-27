`ifdef __RSV_RSV_CTRL_V__

module rsv_ctrl_module (
    input                                           i_csr_trap_flush,
    input                                           i_exu_mis_flush,
    input   [`ROB_ID_WIDTH - 1      : 0]            i_exu_mis_rob_id,
    input                                           i_exu_ls_flush,
    input   [`ROB_ID_WIDTH - 1      : 0]            i_exu_ls_rob_id,

    input   [3                      : 0]            i_dsp_rsv_vld,
    input   [`RSV_IDX_WIDTH - 1     : 0]            i_dsp_rsv_free_entry_0,
    input   [`RSV_IDX_WIDTH - 1     : 0]            i_dsp_rsv_free_entry_1,
    input   [`RSV_IDX_WIDTH - 1     : 0]            i_dsp_rsv_free_entry_2,
    input   [`RSV_IDX_WIDTH - 1     : 0]            i_dsp_rsv_free_entry_3,
    input   [`ROB_ID_WIDTH - 1      : 0]            i_dsp_rsv_rob_id_0,
    input   [`ROB_ID_WIDTH - 1      : 0]            i_dsp_rsv_rob_id_1,
    input   [`ROB_ID_WIDTH - 1      : 0]            i_dsp_rsv_rob_id_2,
    input   [`ROB_ID_WIDTH - 1      : 0]            i_dsp_rsv_rob_id_3,
    input   [`EXEC_UNIT_WIDTH - 1   : 0]            i_dsp_rsv_exec_unit_0,
    input   [`EXEC_UNIT_WIDTH - 1   : 0]            i_dsp_rsv_exec_unit_1,
    input   [`EXEC_UNIT_WIDTH - 1   : 0]            i_dsp_rsv_exec_unit_2,
    input   [`EXEC_UNIT_WIDTH - 1   : 0]            i_dsp_rsv_exec_unit_3,

    input   [`RSV_ENTRY_NUMS - 1    : 0]            i_oldest_rsv_vec_0,
    input   [`RSV_ENTRY_NUMS - 1    : 0]            i_oldest_rsv_vec_1,
    input   [`RSV_ENTRY_NUMS - 1    : 0]            i_oldest_rsv_vec_2,
    input   [`RSV_ENTRY_NUMS - 1    : 0]            i_oldest_rsv_vec_3,

    input                                           i_rsv_arb_stall_0,
    input                                           i_rsv_arb_stall_1,
    input                                           i_rsv_arb_stall_2,
    input                                           i_rsv_arb_stall_3,    

    input   [`RSV_ENTRY_NUMS - 1    : 0]            i_rsv_src1_rdy_vec,
    input   [`RSV_ENTRY_NUMS - 1    : 0]            i_rsv_src2_rdy_vec,
    input   [`RSV_ENTRY_NUMS - 1    : 0]            i_rsv_src3_rdy_vec,

    output                                          o_rsv_issue_vld_0,
    output  [`RSV_ENTRY_NUMS - 1    : 0]            o_rsv_entry_vld_vec_0,
    output                                          o_rsv_issue_vld_1,
    output  [`RSV_ENTRY_NUMS - 1    : 0]            o_rsv_entry_vld_vec_1,
    output                                          o_rsv_issue_vld_2,
    output  [`RSV_ENTRY_NUMS - 1    : 0]            o_rsv_entry_vld_vec_2,
    output                                          o_rsv_issue_vld_3,
    output  [`RSV_ENTRY_NUMS - 1    : 0]            o_rsv_entry_vld_vec_3,
    
    output                                          o_rsv_dsp_free_vld_0,
    output  [`RSV_IDX_WIDTH - 1     : 0]            o_rsv_dsp_free_entry_0,
    output                                          o_rsv_dsp_free_vld_1,
    output  [`RSV_IDX_WIDTH - 1     : 0]            o_rsv_dsp_free_entry_1,
    output                                          o_rsv_dsp_free_vld_2,
    output  [`RSV_IDX_WIDTH - 1     : 0]            o_rsv_dsp_free_entry_2,
    output                                          o_rsv_dsp_free_vld_3,
    output  [`RSV_IDX_WIDTH - 1     : 0]            o_rsv_dsp_free_entry_3,

    input                                           clk,
    input                                           rst_n
);

wire rsv_need_flush = (i_csr_trap_flush 
                    |  i_exu_mis_flush
                    |  i_exu_ls_flush);
wire rsv_arb_stall = (i_rsv_arb_stall_3
                   |  i_rsv_arb_stall_2
                   |  i_rsv_arb_stall_1
                   |  i_rsv_arb_stall_0);

//
wire [`RSV_ENTRY_NUMS - 1     : 0]  rsv_rdy;
wire [`EXEC_UNIT_WIDTH - 1    : 0]  rsv_exec_unit_r [`RSV_ENTRY_NUMS - 1 : 0];
wire [`ROB_ID_WIDTH - 1       : 0]  rsv_rob_id_r [`RSV_ENTRY_NUMS - 1 : 0];
wire [`RSV_ENTRY_NUMS - 1     : 0]  rsv_entry_vld_vec_r;
//

//  Modify rsv_exec_unit_r, rsv_rob_id_r
wire [`RSV_ENTRY_NUMS - 1 : 0] rsv_rob_id_ena;
wire [`ROB_ID_WIDTH - 1 : 0] rsv_rob_id_nxt [`RSV_ENTRY_NUMS - 1 : 0];
wire [`EXEC_UNIT_WIDTH - 1 : 0] rsv_exec_unit_nxt [`RSV_ENTRY_NUMS  - 1 : 0];

genvar i;
generate
    for(i = 0; i < `RSV_ENTRY_NUMS; i = i + 1) begin
        assign rsv_rob_id_ena[i] = (((i == i_dsp_rsv_free_entry_0) & i_dsp_rsv_vld[0])
                                 |  ((i == i_dsp_rsv_free_entry_1) & i_dsp_rsv_vld[1])
                                 |  ((i == i_dsp_rsv_free_entry_2) & i_dsp_rsv_vld[2])
                                 |  ((i == i_dsp_rsv_free_entry_3) & i_dsp_rsv_vld[3])) & (~rsv_need_flush);
        assign rsv_rob_id_nxt[i] = ({`ROB_ID_WIDTH{(i == i_dsp_rsv_free_entry_0)}} & i_dsp_rsv_rob_id_0)
                                 | ({`ROB_ID_WIDTH{(i == i_dsp_rsv_free_entry_1)}} & i_dsp_rsv_rob_id_1)
                                 | ({`ROB_ID_WIDTH{(i == i_dsp_rsv_free_entry_2)}} & i_dsp_rsv_rob_id_2)
                                 | ({`ROB_ID_WIDTH{(i == i_dsp_rsv_free_entry_3)}} & i_dsp_rsv_rob_id_3);
        gnrl_dfflr #(
            .DATA_WIDTH   (`ROB_ID_WIDTH),
            .INITIAL_VALUE(0)
        ) rsv_rob_id_dfflr (rsv_rob_id_ena[i], rsv_rob_id_nxt[i], rsv_rob_id_r[i], clk, rst_n);
    
        assign rsv_exec_unit_nxt[i] = ({`EXEC_UNIT_WIDTH{(i == i_dsp_rsv_free_entry_0)}} & i_dsp_rsv_exec_unit_0)
                                    | ({`EXEC_UNIT_WIDTH{(i == i_dsp_rsv_free_entry_1)}} & i_dsp_rsv_exec_unit_1)
                                    | ({`EXEC_UNIT_WIDTH{(i == i_dsp_rsv_free_entry_2)}} & i_dsp_rsv_exec_unit_2)
                                    | ({`EXEC_UNIT_WIDTH{(i == i_dsp_rsv_free_entry_3)}} & i_dsp_rsv_exec_unit_3);
        gnrl_dfflr #(
            .DATA_WIDTH   (`EXEC_UNIT_WIDTH),
            .INITIAL_VALUE(0)
        ) rsv_exec_unit_dfflr (rsv_rob_id_ena[i], rsv_exec_unit_nxt[i], rsv_exec_unit_r[i], clk, rst_n);
    end
endgenerate

//  Modify rsv_vld_r
wire rsv_mis_ls_flush = (i_exu_mis_flush | i_exu_ls_flush);
wire rsv_mis_ls_flush_both = (i_exu_mis_flush & i_exu_ls_flush);
wire [`ROB_ID_WIDTH - 1 : 0] rsv_flush_rob_id = rsv_mis_ls_flush_both ? (func_rob_old(i_exu_mis_rob_id, i_exu_ls_rob_id) ? i_exu_mis_rob_id : i_exu_ls_rob_id)
                                              : i_exu_mis_flush ? i_exu_mis_rob_id
                                              : i_exu_ls_rob_id;


wire [`RSV_ENTRY_NUMS - 1 : 0] rsv_flush_free;

genvar j;
generate
    for(j = 0; j < `RSV_ENTRY_NUMS; j = j + 1) begin
        assign rsv_flush_free[j] = ((rsv_mis_ls_flush & func_rob_old(rsv_flush_rob_id, rsv_rob_id_r[j])) | i_csr_trap_flush);
    end
endgenerate



//
assign rsv_rdy = (i_rsv_src1_rdy_vec & i_rsv_src2_rdy_vec & i_rsv_src3_rdy_vec);
//

wire [`RSV_ENTRY_NUMS - 1 : 0] rsv_free_0 = (i_oldest_rsv_vec_0 & ({`RSV_ENTRY_NUMS{(~i_rsv_arb_stall_0)}}));
wire [`RSV_ENTRY_NUMS - 1 : 0] rsv_free_1 = (i_oldest_rsv_vec_1 & ({`RSV_ENTRY_NUMS{(~i_rsv_arb_stall_1)}}));
wire [`RSV_ENTRY_NUMS - 1 : 0] rsv_free_2 = (i_oldest_rsv_vec_2 & ({`RSV_ENTRY_NUMS{(~i_rsv_arb_stall_2)}}));
wire [`RSV_ENTRY_NUMS - 1 : 0] rsv_free_3 = (i_oldest_rsv_vec_3 & ({`RSV_ENTRY_NUMS{(~i_rsv_arb_stall_3)}}));

wire [`RSV_ENTRY_NUMS - 1 : 0] rsv_free_vec_r;

wire [`RSV_ENTRY_NUMS + 5 : 0] rsv_refree_0 = func_find_vec(rsv_free_vec_r);
wire [`RSV_ENTRY_NUMS + 5 : 0] rsv_refree_1 = func_find_vec((rsv_free_vec_r & (~rsv_refree_0[`RSV_ENTRY_NUMS + 5 : 6])));
wire [`RSV_ENTRY_NUMS + 5 : 0] rsv_refree_2 = func_find_vec((rsv_free_vec_r & (~rsv_refree_0[`RSV_ENTRY_NUMS + 5 : 6]) & (~rsv_refree_1[`RSV_ENTRY_NUMS + 5 : 6])));
wire [`RSV_ENTRY_NUMS + 5 : 0] rsv_refree_3 = func_find_vec((rsv_free_vec_r & (~rsv_refree_0[`RSV_ENTRY_NUMS + 5 : 6]) & (~rsv_refree_1[`RSV_ENTRY_NUMS + 5 : 6]) & (~rsv_refree_2[`RSV_ENTRY_NUMS + 5 : 6])));

wire rsv_free_vec_ena = (((|i_dsp_rsv_vld) & (~rsv_arb_stall)) | (rsv_need_flush));
wire [`RSV_ENTRY_NUMS - 1 : 0] rsv_free_vec_nxt = ((rsv_free_vec_r 
                                                & (~rsv_refree_0[69 : 6]) 
                                                & (~rsv_refree_1[69 : 6])
                                                & (~rsv_refree_2[69 : 6])
                                                & (~rsv_refree_3[69 : 6]))
                                                | rsv_free_0
                                                | rsv_free_1
                                                | rsv_free_2
                                                | rsv_free_3
                                                | rsv_flush_free);
gnrl_dfflr #(
    .DATA_WIDTH   (`RSV_ENTRY_NUMS),
    .INITIAL_VALUE(64'hffff_ffff_ffff_ffff)
) rsv_free_vec_dfflr (rsv_free_vec_ena, rsv_free_vec_nxt, rsv_free_vec_r, clk, rst_n);
//

assign o_rsv_dsp_free_vld_0   = (|rsv_refree_0[`RSV_ENTRY_NUMS + 5 : 6]);
assign o_rsv_dsp_free_entry_0 = rsv_refree_0[5 : 0];
assign o_rsv_dsp_free_vld_1   = (|rsv_refree_1[`RSV_ENTRY_NUMS + 5 : 6]);
assign o_rsv_dsp_free_entry_1 = rsv_refree_1[5 : 0];
assign o_rsv_dsp_free_vld_2   = (|rsv_refree_2[`RSV_ENTRY_NUMS + 5 : 6]);
assign o_rsv_dsp_free_entry_2 = rsv_refree_2[5 : 0];
assign o_rsv_dsp_free_vld_3   = (|rsv_refree_3[`RSV_ENTRY_NUMS + 5 : 6]);
assign o_rsv_dsp_free_entry_3 = rsv_refree_3[5 : 0];

//
wire rsv_entry_vld_vec_ena = rsv_free_vec_ena;
wire [`RSV_ENTRY_NUMS - 1 : 0] rsv_entry_vld_vec_nxt;

assign rsv_entry_vld_vec_nxt = (rsv_entry_vld_vec_r
                             |  ({`RSV_ENTRY_NUMS{i_dsp_rsv_vld[0]}} & func_vec64(i_dsp_rsv_free_entry_0))
                             |  ({`RSV_ENTRY_NUMS{i_dsp_rsv_vld[1]}} & func_vec64(i_dsp_rsv_free_entry_1))
                             |  ({`RSV_ENTRY_NUMS{i_dsp_rsv_vld[2]}} & func_vec64(i_dsp_rsv_free_entry_2))
                             |  ({`RSV_ENTRY_NUMS{i_dsp_rsv_vld[3]}} & func_vec64(i_dsp_rsv_free_entry_3)))
                             & (~(rsv_free_0
                             |    rsv_free_1
                             |    rsv_free_2
                             |    rsv_free_3
                             |    rsv_flush_free));
gnrl_dfflr #(
    .DATA_WIDTH   (`RSV_ENTRY_NUMS),
    .INITIAL_VALUE(0)
) rsv_entry_vld_dfflr (rsv_entry_vld_ena, rsv_entry_vld_vec_nxt, rsv_entry_vld_vec_r, clk, rst_n);

//
wire [`RSV_ENTRY_NUMS - 1 : 0] rsv_exec_unit_vec_0;
wire [`RSV_ENTRY_NUMS - 1 : 0] rsv_exec_unit_vec_1;
wire [`RSV_ENTRY_NUMS - 1 : 0] rsv_exec_unit_vec_2;
wire [`RSV_ENTRY_NUMS - 1 : 0] rsv_exec_unit_vec_3;

genvar k;
generate
    for(k = 0; k < `RSV_ENTRY_NUMS; k = k + 1) begin
        assign rsv_exec_unit_vec_0[k] = (rsv_exec_unit_r[k] == `UOPINFO_ALU)
                                      | (rsv_exec_unit_r[k] == `UOPINFO_CSR);
        assign rsv_exec_unit_vec_1[k] = (rsv_exec_unit_r[k] == `UOPINFO_BJP);
        assign rsv_exec_unit_vec_2[k] = (rsv_exec_unit_r[k] == `UOPINFO_MULDIV);
        assign rsv_exec_unit_vec_3[k] = (rsv_exec_unit_r[k] == `UOPINFO_AGU)
                                      | (rsv_exec_unit_r[k] == `UOPINFO_AMO);
    end
endgenerate


assign o_rsv_entry_vld_vec_0 = ((rsv_entry_vld_vec_r & rsv_exec_unit_vec_0) & rsv_rdy);
assign o_rsv_entry_vld_vec_1 = ((rsv_entry_vld_vec_r & rsv_exec_unit_vec_1) & rsv_rdy);
assign o_rsv_entry_vld_vec_2 = ((rsv_entry_vld_vec_r & rsv_exec_unit_vec_2) & rsv_rdy);
assign o_rsv_entry_vld_vec_3 = ((rsv_entry_vld_vec_r & rsv_exec_unit_vec_3) & rsv_rdy);

assign o_rsv_issue_vld_0 = (|o_rsv_entry_vld_vec_0);
assign o_rsv_issue_vld_1 = (|o_rsv_entry_vld_vec_1);
assign o_rsv_issue_vld_2 = (|o_rsv_entry_vld_vec_2);
assign o_rsv_issue_vld_3 = (|o_rsv_entry_vld_vec_3);

//  Functions
function func_rob_old;
    input [`ROB_ID_WIDTH - 1 : 0]   func_rob_id0;
    input [`ROB_ID_WIDTH - 1 : 0]   func_rob_id1;
    //  If func_rob_id0 OLDER than func_rob_id1, return HIGH level;
    func_rob_old = (func_rob_id0[7] ^ func_rob_id1[7]) ? (func_rob_id0[6 : 0] >= func_rob_id1[6 : 0])
                 : (func_rob_id0[6 : 0] < func_rob_id1[6 : 0]);
endfunction

function [63 : 0] func_vec64;
    input [5 : 0] index;
    case (index)
        6'b000000:	func_vec64 = 64'd1;		    
        6'b000001:	func_vec64 = 64'd2;		    
        6'b000010:	func_vec64 = 64'd4;		    
        6'b000011:	func_vec64 = 64'd8;		    
        6'b000100:	func_vec64 = 64'd16;		 
        6'b000101:	func_vec64 = 64'd32;		 
        6'b000110:	func_vec64 = 64'd64;		 
        6'b000111:	func_vec64 = 64'd128;		 
        6'b001000:	func_vec64 = 64'd256;		 
        6'b001001:	func_vec64 = 64'd512;		 
        6'b001010:	func_vec64 = 64'd1024;		 
        6'b001011:	func_vec64 = 64'd2048;		 
        6'b001100:	func_vec64 = 64'd4096;		 
        6'b001101:	func_vec64 = 64'd8192;		 
        6'b001110:	func_vec64 = 64'd16384;		 
        6'b001111:	func_vec64 = 64'd32768;		 
        6'b010000:	func_vec64 = 64'd65536;		 
        6'b010001:	func_vec64 = 64'd131072;		 
        6'b010010:	func_vec64 = 64'd262144;		 
        6'b010011:	func_vec64 = 64'd524288;		 
        6'b010100:	func_vec64 = 64'd1048576;		 
        6'b010101:	func_vec64 = 64'd2097152;		 
        6'b010110:	func_vec64 = 64'd4194304;		 
        6'b010111:	func_vec64 = 64'd8388608;		 
        6'b011000:	func_vec64 = 64'd16777216;		 
        6'b011001:	func_vec64 = 64'd33554432;		 
        6'b011010:	func_vec64 = 64'd67108864;		 
        6'b011011:	func_vec64 = 64'd134217728;		 
        6'b011100:	func_vec64 = 64'd268435456;		 
        6'b011101:	func_vec64 = 64'd536870912;		 
        6'b011110:	func_vec64 = 64'd1073741824;		 
        6'b011111:	func_vec64 = 64'd2147483648;		 
        6'b100000:	func_vec64 = 64'd4294967296;		 
        6'b100001:	func_vec64 = 64'd8589934592;		 
        6'b100010:	func_vec64 = 64'd17179869184;		 
        6'b100011:	func_vec64 = 64'd34359738368;		 
        6'b100100:	func_vec64 = 64'd68719476736;		 
        6'b100101:	func_vec64 = 64'd137438953472;		 
        6'b100110:	func_vec64 = 64'd274877906944;		 
        6'b100111:	func_vec64 = 64'd549755813888;		 
        6'b101000:	func_vec64 = 64'd1099511627776;		 
        6'b101001:	func_vec64 = 64'd2199023255552;		 
        6'b101010:	func_vec64 = 64'd4398046511104;		 
        6'b101011:	func_vec64 = 64'd8796093022208;		 
        6'b101100:	func_vec64 = 64'd17592186044416;		 
        6'b101101:	func_vec64 = 64'd35184372088832;		 
        6'b101110:	func_vec64 = 64'd70368744177664;		 
        6'b101111:	func_vec64 = 64'd140737488355328;		 
        6'b110000:	func_vec64 = 64'd281474976710656;		 
        6'b110001:	func_vec64 = 64'd562949953421312;		 
        6'b110010:	func_vec64 = 64'd1125899906842624;		 
        6'b110011:	func_vec64 = 64'd2251799813685248;		 
        6'b110100:	func_vec64 = 64'd4503599627370496;		 
        6'b110101:	func_vec64 = 64'd9007199254740992;		 
        6'b110110:	func_vec64 = 64'd18014398509481984;		 
        6'b110111:	func_vec64 = 64'd36028797018963968;		     
        6'b111000:	func_vec64 = 64'd72057594037927936;		     
        6'b111001:	func_vec64 = 64'd144115188075855872;		 
        6'b111010:	func_vec64 = 64'd288230376151711744;		 
        6'b111011:	func_vec64 = 64'd576460752303423488;		 
        6'b111100:	func_vec64 = 64'd1152921504606846976;		 
        6'b111101:	func_vec64 = 64'd2305843009213693952;		 
        6'b111110:	func_vec64 = 64'd4611686018427387904;		 
        6'b111111:	func_vec64 = 64'd9223372036854775808;	
        default: 
                    func_vec64 = 16'd0;	
    endcase
endfunction

function [69 : 0] func_find_vec;
    input [`RSV_ENTRY_NUMS - 1 : 0] func_index;
    
    casex (func_index)
        64'bxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxx1: func_find_vec = {64'd1, 6'd0};
        64'bxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxx10: func_find_vec = {64'd2, 6'd1};
        64'bxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxx100: func_find_vec = {64'd4, 6'd2};
        64'bxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxx1000: func_find_vec = {64'd8, 6'd3};
        64'bxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxx10000: func_find_vec = {64'd16, 6'd4};
        64'bxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxx100000: func_find_vec = {64'd32, 6'd5};
        64'bxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxx1000000: func_find_vec = {64'd64, 6'd6};
        64'bxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxx10000000: func_find_vec = {64'd128, 6'd7};
        64'bxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxx100000000: func_find_vec = {64'd256, 6'd8};
        64'bxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxx1000000000: func_find_vec = {64'd512, 6'd9};
        64'bxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxx10000000000: func_find_vec = {64'd1024, 6'd10};
        64'bxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxx100000000000: func_find_vec = {64'd2048, 6'd11};
        64'bxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxx1000000000000: func_find_vec = {64'd4096, 6'd12};
        64'bxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxx10000000000000: func_find_vec = {64'd8192, 6'd13};
        64'bxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxx100000000000000: func_find_vec = {64'd16384, 6'd14};
        64'bxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxx1000000000000000: func_find_vec = {64'd32768, 6'd15};
        64'bxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxx10000000000000000: func_find_vec = {64'd65536, 6'd16};
        64'bxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxx100000000000000000: func_find_vec = {64'd131072, 6'd17};
        64'bxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxx1000000000000000000: func_find_vec = {64'd262144, 6'd18};
        64'bxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxx10000000000000000000: func_find_vec = {64'd524288, 6'd19};
        64'bxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxx100000000000000000000: func_find_vec = {64'd1048576, 6'd20};
        64'bxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxx1000000000000000000000: func_find_vec = {64'd2097152, 6'd21};
        64'bxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxx10000000000000000000000: func_find_vec = {64'd4194304, 6'd22};
        64'bxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxx100000000000000000000000: func_find_vec = {64'd8388608, 6'd23};
        64'bxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxx1000000000000000000000000: func_find_vec = {64'd16777216, 6'd24};
        64'bxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxx10000000000000000000000000: func_find_vec = {64'd33554432, 6'd25};
        64'bxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxx100000000000000000000000000: func_find_vec = {64'd67108864, 6'd26};
        64'bxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxx1000000000000000000000000000: func_find_vec = {64'd134217728, 6'd27};
        64'bxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxx10000000000000000000000000000: func_find_vec = {64'd268435456, 6'd28};
        64'bxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxx100000000000000000000000000000: func_find_vec = {64'd536870912, 6'd29};
        64'bxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxx1000000000000000000000000000000: func_find_vec = {64'd1073741824, 6'd30};
        64'bxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxx10000000000000000000000000000000: func_find_vec = {64'd2147483648, 6'd31};
        64'bxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxx100000000000000000000000000000000: func_find_vec = {64'd4294967296, 6'd32};
        64'bxxxxxxxxxxxxxxxxxxxxxxxxxxxxxx1000000000000000000000000000000000: func_find_vec = {64'd8589934592, 6'd33};
        64'bxxxxxxxxxxxxxxxxxxxxxxxxxxxxx10000000000000000000000000000000000: func_find_vec = {64'd17179869184, 6'd34};
        64'bxxxxxxxxxxxxxxxxxxxxxxxxxxxx100000000000000000000000000000000000: func_find_vec = {64'd34359738368, 6'd35};
        64'bxxxxxxxxxxxxxxxxxxxxxxxxxxx1000000000000000000000000000000000000: func_find_vec = {64'd68719476736, 6'd36};
        64'bxxxxxxxxxxxxxxxxxxxxxxxxxx10000000000000000000000000000000000000: func_find_vec = {64'd137438953472, 6'd37};
        64'bxxxxxxxxxxxxxxxxxxxxxxxxx100000000000000000000000000000000000000: func_find_vec = {64'd274877906944, 6'd38};
        64'bxxxxxxxxxxxxxxxxxxxxxxxx1000000000000000000000000000000000000000: func_find_vec = {64'd549755813888, 6'd39};
        64'bxxxxxxxxxxxxxxxxxxxxxxx10000000000000000000000000000000000000000: func_find_vec = {64'd1099511627776, 6'd40};
        64'bxxxxxxxxxxxxxxxxxxxxxx100000000000000000000000000000000000000000: func_find_vec = {64'd2199023255552, 6'd41};
        64'bxxxxxxxxxxxxxxxxxxxxx1000000000000000000000000000000000000000000: func_find_vec = {64'd4398046511104, 6'd42};
        64'bxxxxxxxxxxxxxxxxxxxx10000000000000000000000000000000000000000000: func_find_vec = {64'd8796093022208, 6'd43};
        64'bxxxxxxxxxxxxxxxxxxx100000000000000000000000000000000000000000000: func_find_vec = {64'd17592186044416, 6'd44};
        64'bxxxxxxxxxxxxxxxxxx1000000000000000000000000000000000000000000000: func_find_vec = {64'd35184372088832, 6'd45};
        64'bxxxxxxxxxxxxxxxxx10000000000000000000000000000000000000000000000: func_find_vec = {64'd70368744177664, 6'd46};
        64'bxxxxxxxxxxxxxxxx100000000000000000000000000000000000000000000000: func_find_vec = {64'd140737488355328, 6'd47};
        64'bxxxxxxxxxxxxxxx1000000000000000000000000000000000000000000000000: func_find_vec = {64'd281474976710656, 6'd48};
        64'bxxxxxxxxxxxxxx10000000000000000000000000000000000000000000000000: func_find_vec = {64'd562949953421312, 6'd49};
        64'bxxxxxxxxxxxxx100000000000000000000000000000000000000000000000000: func_find_vec = {64'd1125899906842624, 6'd50};
        64'bxxxxxxxxxxxx1000000000000000000000000000000000000000000000000000: func_find_vec = {64'd2251799813685248, 6'd51};
        64'bxxxxxxxxxxx10000000000000000000000000000000000000000000000000000: func_find_vec = {64'd4503599627370496, 6'd52};
        64'bxxxxxxxxxx100000000000000000000000000000000000000000000000000000: func_find_vec = {64'd9007199254740992, 6'd53};
        64'bxxxxxxxxx1000000000000000000000000000000000000000000000000000000: func_find_vec = {64'd18014398509481984, 6'd54};
        64'bxxxxxxxx10000000000000000000000000000000000000000000000000000000: func_find_vec = {64'd36028797018963968, 6'd55};
        64'bxxxxxxx100000000000000000000000000000000000000000000000000000000: func_find_vec = {64'd72057594037927936, 6'd56};
        64'bxxxxxx1000000000000000000000000000000000000000000000000000000000: func_find_vec = {64'd144115188075855872, 6'd57};
        64'bxxxxx10000000000000000000000000000000000000000000000000000000000: func_find_vec = {64'd288230376151711744, 6'd58};
        64'bxxxx100000000000000000000000000000000000000000000000000000000000: func_find_vec = {64'd576460752303423488, 6'd59};
        64'bxxx1000000000000000000000000000000000000000000000000000000000000: func_find_vec = {64'd1152921504606846976, 6'd60};
        64'bxx10000000000000000000000000000000000000000000000000000000000000: func_find_vec = {64'd2305843009213693952, 6'd61};
        64'bx100000000000000000000000000000000000000000000000000000000000000: func_find_vec = {64'd4611686018427387904, 6'd62};
        64'b1000000000000000000000000000000000000000000000000000000000000000: func_find_vec = {64'd9223372036854775808, 6'd63};
        64'b0000000000000000000000000000000000000000000000000000000000000000: func_find_vec = {64'd0, 6'd0};
        default: begin
            func_find_vec = {64'd0, 6'd0};
        end
    endcase

endfunction

endmodule   //  rsv_ctrl_module

`endif /*   !__RSV_RSV_CTRL_V__!    */