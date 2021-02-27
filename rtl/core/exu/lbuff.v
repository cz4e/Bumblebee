`ifdef __EXU_LBUFF_V__

module lbuff_module (
    input                                           i_csr_trap_flush,
    input                                           i_exu_mis_flush,
    input   [`ROB_ID_WIDTH - 1          : 0]        i_exu_mis_rob_id,

    input   [3                          : 0]        i_dsp_rsv_vld,
    input   [`ROB_ID_WIDTH - 1          : 0]        i_dsp_rsv_rob_id_0,
    input                                           i_dsp_rsv_ld_vld_0,
    input   [`LBUFF_ID_WIDTH - 1        : 0]        i_dsp_rsv_ld_id_0,
    input                                           i_dsp_rsv_dst_vld_0,
    input   [`PRF_CODE_WIDTH - 1        : 0]        i_dsp_rsv_dst_code_0,
    input   [`ROB_ID_WIDTH - 1          : 0]        i_dsp_rsv_rob_id_1,
    input                                           i_dsp_rsv_ld_vld_1,
    input   [`LBUFF_ID_WIDTH - 1        : 0]        i_dsp_rsv_ld_id_1,
    input                                           i_dsp_rsv_dst_vld_1,
    input   [`PRF_CODE_WIDTH - 1        : 0]        i_dsp_rsv_dst_code_1,
    input   [`ROB_ID_WIDTH - 1          : 0]        i_dsp_rsv_rob_id_2,
    input                                           i_dsp_rsv_ld_vld_2,
    input   [`LBUFF_ID_WIDTH - 1        : 0]        i_dsp_rsv_ld_id_2,
    input                                           i_dsp_rsv_dst_vld_2,
    input   [`PRF_CODE_WIDTH - 1        : 0]        i_dsp_rsv_dst_code_2,
    input   [`ROB_ID_WIDTH - 1          : 0]        i_dsp_rsv_rob_id_3,
    input                                           i_dsp_rsv_ld_vld_3,
    input   [`LBUFF_ID_WIDTH - 1        : 0]        i_dsp_rsv_ld_id_3,
    input                                           i_dsp_rsv_dst_vld_3,
    input   [`PRF_CODE_WIDTH - 1        : 0]        i_dsp_rsv_dst_code_3,

    input   [`LBUFF_ID_WIDTH - 1        : 0]        i_dsp_exu_ld_ret_ptr,

    input                                           i_rsv_exu_vld,
    input                                           i_rsv_exu_ld_vld,
    input   [`LBUFF_ID_WIDTH - 1        : 0]        i_rsv_exu_ld_id,

    input                                           i_agu_exec_1_vld,
    input   [`CORE_PC_WIDTH - 1         : 0]        i_agu_exec_1_vaddr,
    input   [43                         : 0]        i_agu_exec_1_paddr,
    input                                           i_agu_exec_1_fs_vld,
    input   [`SBUFF_ID_WIDTH - 1        : 0]        i_agu_exec_1_fs_id,
    input                                           i_agu_exec_2_vld,
    input   [`PRF_DATA_WIDTH - 1        : 0]        i_agu_exec_2_data,
    input   [`EXCEPTION_CODE_WIDTH - 1  : 0]        i_agu_exec_2_excp_code,

    input   [3                          : 0]        i_rob_exu_ret_vld,
    input                                           i_rob_exu_ret_ld_vld_0,
    input   [`LBUFF_ID_WIDTH - 1        : 0]        i_rob_exu_ret_ld_id_0,
    input                                           i_rob_exu_ret_ld_vld_1,
    input   [`LBUFF_ID_WIDTH - 1        : 0]        i_rob_exu_ret_ld_id_1,
    input                                           i_rob_exu_ret_ld_vld_2,
    input   [`LBUFF_ID_WIDTH - 1        : 0]        i_rob_exu_ret_ld_id_2,
    input                                           i_rob_exu_ret_ld_vld_3,
    input   [`LBUFF_ID_WIDTH - 1        : 0]        i_rob_exu_ret_ld_id_3,
    input   [ `CORE_PC_WIDTH - 1        : 0]        i_rob_exu_ls_addr,

    input                                           i_sbuff_ret_vld,
    input   [`SBUFF_ID_WIDTH - 1        : 0]        i_sbuff_ret_st_id,
    input   [43                         : 0]        i_sbuff_ret_paddr,

    output                                          o_lbuff_old,
    output                                          o_lbuff_dst_vld,
    output  [`PRF_CODE_WIDTH - 1        : 0]        o_lbuff_dst_code,
    output                                          o_exu_ls_flush,
    output  [`CORE_PC_WIDTH - 1         : 0]        o_exu_ls_addr,
    output  [`ROB_ID_WIDTH - 1          : 0]        o_exu_ls_rob_id,

    input                                           clk,
    input                                           rst_n
);

wire [31                         : 0] lbuff_vld_r;
wire [`LBUFF_ID_WIDTH - 1        : 0] lbuff_ld_id_r [31 : 0];
wire [31                         : 0] lbuff_done_r;
wire [`LBUFF_INFO_WIDTH - 1      : 0] lbuff_info_r [31 : 0];
wire [`ROB_ID_WIDTH - 1          : 0] lbuff_rob_id_r  [31 : 0];
wire [43                         : 0] lbuff_paddr_r   [31 : 0];
wire [31                         : 0] lbuff_fs_vld_r;
wire [`SBUFF_ID_WIDTH - 1        : 0] lbuff_fs_id_r [31 : 0];
wire [`EXCEPTION_CODE_WIDTH - 1  : 0] lbuff_excp_code_r [31 : 0];

//
wire lbuff_need_flush = (i_csr_trap_flush | i_exu_mis_flush);
wire lbuff_need_req   = (|i_dsp_rsv_vld);
wire lbuff_need_ret   = (|i_rob_exu_ret_vld);

//  Modify lbuff_vld_r
wire lbuff_vld_ena = (lbuff_need_flush | lbuff_need_req | lbuff_need_ret);
wire [31 : 0] lbuff_vld_flush_free;
wire [31 : 0] lbuff_vld_free;

genvar i;
generate
    for(i = 0; i < 32; i = i + 1) begin
        assign lbuff_vld_flush_free[i] = ((func_rob_old(i_exu_mis_rob_id, lbuff_rob_id_r[i]) & i_exu_mis_flush) | i_csr_trap_flush);
        assign lbuff_vld_free[i] = ((i == i_rob_exu_ret_ld_id_0[4 : 0]) & i_rob_exu_ret_vld[0] & i_rob_exu_ret_ld_vld_0)
                                 | ((i == i_rob_exu_ret_ld_id_1[4 : 0]) & i_rob_exu_ret_vld[1] & i_rob_exu_ret_ld_vld_1)
                                 | ((i == i_rob_exu_ret_ld_id_2[4 : 0]) & i_rob_exu_ret_vld[2] & i_rob_exu_ret_ld_vld_2)
                                 | ((i == i_rob_exu_ret_ld_id_3[4 : 0]) & i_rob_exu_ret_vld[3] & i_rob_exu_ret_ld_vld_3);
    end
endgenerate

wire [31 : 0] lbuff_vld_nxt = (lbuff_vld_r
                            | ({32{(i_dsp_rsv_vld[0] & i_dsp_rsv_ld_vld_0)}} & func_vec32(i_dsp_rsv_ld_id_0[4 : 0]))
                            | ({32{(i_dsp_rsv_vld[1] & i_dsp_rsv_ld_vld_1)}} & func_vec32(i_dsp_rsv_ld_id_1[4 : 0]))
                            | ({32{(i_dsp_rsv_vld[2] & i_dsp_rsv_ld_vld_2)}} & func_vec32(i_dsp_rsv_ld_id_2[4 : 0]))
                            | ({32{(i_dsp_rsv_vld[3] & i_dsp_rsv_ld_vld_3)}} & func_vec32(i_dsp_rsv_ld_id_3[4 : 0])))
                            & (~(lbuff_vld_flush_free | lbuff_vld_free));

gnrl_dfflr #( 
    .DATA_WIDTH   (32),
    .INITIAL_VALUE(0)
) lbuff_vld_dfflr (lbuff_vld_ena, lbuff_vld_nxt, lbuff_vld_r, clk, rst_n);

//  Modify lbuff_info_r

wire [`LBUFF_INFO_WIDTH - 1 : 0] lbuff_winfo_0 = {
                                                    i_dsp_rsv_dst_vld_0
                                                ,   i_dsp_rsv_dst_code_0
                                                };

wire [`LBUFF_INFO_WIDTH - 1 : 0] lbuff_winfo_1 = {
                                                    i_dsp_rsv_dst_vld_1
                                                ,   i_dsp_rsv_dst_code_1
                                                };

wire [`LBUFF_INFO_WIDTH - 1 : 0] lbuff_winfo_2 = {
                                                    i_dsp_rsv_dst_vld_2
                                                ,   i_dsp_rsv_dst_code_2
                                                };

wire [`LBUFF_INFO_WIDTH - 1 : 0] lbuff_winfo_3 = {
                                                    i_dsp_rsv_dst_vld_3
                                                ,   i_dsp_rsv_dst_code_3
                                                };

wire [31 : 0] lbuff_rob_ena;
wire [`ROB_ID_WIDTH - 1 : 0] lbuff_rob_id_nxt [31 : 0];
wire [`LBUFF_INFO_WIDTH - 1 : 0] lbuff_info_nxt [31 : 0];
wire [`LBUFF_ID_WIDTH - 1 : 0] lbuff_ld_id_nxt [31 : 0];

genvar rob_idx;
generate
    for(rob_idx = 0; rob_idx < 32; rob_idx = rob_idx + 1) begin
        assign lbuff_rob_ena[rob_idx] = ((rob_idx == i_dsp_rsv_ld_id_0[4 : 0]) & i_dsp_rsv_vld[0] & i_dsp_rsv_ld_vld_0)
                                      | ((rob_idx == i_dsp_rsv_ld_id_1[4 : 0]) & i_dsp_rsv_vld[1] & i_dsp_rsv_ld_vld_1)
                                      | ((rob_idx == i_dsp_rsv_ld_id_2[4 : 0]) & i_dsp_rsv_vld[2] & i_dsp_rsv_ld_vld_2)
                                      | ((rob_idx == i_dsp_rsv_ld_id_3[4 : 0]) & i_dsp_rsv_vld[3] & i_dsp_rsv_ld_vld_3);
        assign lbuff_rob_id_nxt[rob_idx] = ({`ROB_ID_WIDTH{(rob_idx == i_dsp_rsv_ld_id_0[4 : 0])}} & i_dsp_rsv_rob_id_0)
                                         | ({`ROB_ID_WIDTH{(rob_idx == i_dsp_rsv_ld_id_1[4 : 0])}} & i_dsp_rsv_rob_id_1)
                                         | ({`ROB_ID_WIDTH{(rob_idx == i_dsp_rsv_ld_id_2[4 : 0])}} & i_dsp_rsv_rob_id_2)
                                         | ({`ROB_ID_WIDTH{(rob_idx == i_dsp_rsv_ld_id_3[4 : 0])}} & i_dsp_rsv_rob_id_3);
        gnrl_dffl #(
            .DATA_WIDTH(`ROB_ID_WIDTH)
        ) lbuff_rob_id_dffl (lbuff_rob_ena[rob_idx], lbuff_rob_id_nxt[rob_idx], lbuff_rob_id_r[rob_idx], clk);

        assign lbuff_info_nxt[rob_idx] = ({`LBUFF_INFO_WIDTH{(rob_idx == i_dsp_rsv_ld_id_0[4 : 0])}} & lbuff_winfo_0)
                                       | ({`LBUFF_INFO_WIDTH{(rob_idx == i_dsp_rsv_ld_id_1[4 : 0])}} & lbuff_winfo_1)
                                       | ({`LBUFF_INFO_WIDTH{(rob_idx == i_dsp_rsv_ld_id_2[4 : 0])}} & lbuff_winfo_2)
                                       | ({`LBUFF_INFO_WIDTH{(rob_idx == i_dsp_rsv_ld_id_3[4 : 0])}} & lbuff_winfo_3);
        gnrl_dffl #( 
            .DATA_WIDTH(`LBUFF_INFO_WIDTH)
        ) lbuff_info_dffl (lbuff_rob_ena[rob_idx], lbuff_info_nxt[rob_idx], lbuff_info_r[rob_idx], clk);

        assign lbuff_ld_id_nxt[rob_idx] = ({`LBUFF_ID_WIDTH{(rob_idx == i_dsp_rsv_ld_id_0[4 : 0])}} & i_dsp_rsv_ld_id_0)
                                        | ({`LBUFF_ID_WIDTH{(rob_idx == i_dsp_rsv_ld_id_1[4 : 0])}} & i_dsp_rsv_ld_id_1)
                                        | ({`LBUFF_ID_WIDTH{(rob_idx == i_dsp_rsv_ld_id_2[4 : 0])}} & i_dsp_rsv_ld_id_2)
                                        | ({`LBUFF_ID_WIDTH{(rob_idx == i_dsp_rsv_ld_id_3[4 : 0])}} & i_dsp_rsv_ld_id_3);
        gnrl_dffl #( 
            .DATA_WIDTH(`LBUFF_ID_WIDTH)
        ) lbuff_ld_id_dffl (lbuff_rob_ena[rob_idx], lbuff_ld_id_nxt[rob_idx], lbuff_ld_id_r[rob_idx], clk);
    end
endgenerate

//  Modify lbuff_fs_*
wire lbuff_fs_vld_ena = (i_rsv_exu_vld & i_rsv_exu_ld_vld & i_agu_exec_1_vld);
wire [31 : 0] lbuff_fs_vld_nxt = ((lbuff_fs_vld_r 
                               |  ({32{lbuff_fs_vld_ena}} & func_vec32(i_rsv_exu_ld_id[4 : 0]))) 
                               &  (~(lbuff_vld_flush_free | lbuff_vld_free)));

gnrl_dfflr #(
    .DATA_WIDTH   (32),
    .INITIAL_VALUE(0)
) lbuff_fs_vld_dfflr (lbuff_fs_vld_ena, lbuff_fs_vld_nxt, lbuff_fs_vld_r, clk, rst_n);

//
wire [31 : 0] lbuff_fs_id_ena;

genvar fs_idx;
generate
    for(fs_idx = 0; fs_idx < 32; fs_idx = fs_idx + 1) begin
        assign lbuff_fs_id_ena[fs_idx] = (lbuff_fs_vld_ena & (fs_idx == i_rsv_exu_ld_id[4 : 0]));
        gnrl_dffl #( 
            .DATA_WIDTH(`SBUFF_ID_WIDTH)
        ) lbuff_fs_id_dffl (lbuff_fs_id_ena[fs_idx], i_agu_exec_1_fs_id, lbuff_fs_id_r[fs_idx], clk);
    end
endgenerate

//  Modify lbuff_done_r
wire lbuff_done_ena = (lbuff_need_flush | lbuff_need_ret | (i_rsv_exu_vld & i_rsv_exu_ld_vld & i_agu_exec_2_vld));
wire [31 : 0] lbuff_done_nxt = (lbuff_done_r
                             | ({32{(i_rsv_exu_vld & i_rsv_exu_ld_vld & i_agu_exec_2_vld)}} & func_vec32(i_rsv_exu_ld_id[4 : 0])))
                             & (~(lbuff_vld_flush_free | lbuff_vld_free));

gnrl_dfflr #( 
    .DATA_WIDTH   (32),
    .INITIAL_VALUE(0)
) lbuff_done_dfflr (lbuff_done_ena, lbuff_done_nxt, lbuff_done_r, clk, rst_n);

//  Modify lbuff_excp_code_r
wire [31 : 0] lbuff_excp_code_ena;
genvar excp_idx;
generate
    for(excp_idx = 0; excp_idx < 32; excp_idx = excp_idx + 1) begin
        assign lbuff_excp_code_ena[excp_idx] = (i_agu_exec_2_vld & (excp_idx == i_rsv_exu_ld_id[4 : 0]));
        gnrl_dfflr #( 
            .DATA_WIDTH   (`EXCEPTION_CODE_WIDTH),
            .INITIAL_VALUE(0)
        ) lbuff_excp_code_dfflr (lbuff_excp_code_ena[excp_idx], i_agu_exec_2_excp_code, lbuff_excp_code_r[excp_idx], clk, rst_n);
    end
endgenerate


//  Modify lbuff_paddr_r
wire [31 : 0] lbuff_pa_ena;

genvar pa_idx;
generate
    for(pa_idx = 0; pa_idx < 32; pa_idx = pa_idx + 1) begin
        assign lbuff_pa_ena[pa_idx] = (i_rsv_exu_vld 
                                    &  i_rsv_exu_ld_vld 
                                    &  i_agu_exec_2_vld
                                    &  (pa_idx == i_rsv_exu_ld_id[4 : 0]));
        gnrl_dffl #( 
            .DATA_WIDTH(44)
        ) lbuff_paddr_dffl (lbuff_pa_done_ena[pa_idx], i_agu_exec_1_paddr, lbuff_paddr_r[pa_idx], clk);
    end
endgenerate

//
wire [31 : 0] lbuff_old;
genvar j;
generate
    for(j = 0; j < 32; j = j + 1) begin
        assign lbuff_old[j] = (lbuff_vld_r[j] & func_rob_old(lbuff_ld_id_r[j], i_sbuff_ret_st_id) & (~lbuff_done_r[j]));
    end
endgenerate

assign o_lbuff_old = (|lbuff_old);

//
wire [31 : 0] lbuff_ret_cmp;

genvar k;
generate
    for(k = 0; k < 32; k = k + 1) begin
        assign lbuff_ret_cmp[k] = (i_sbuff_ret_vld 
                                &  lbuff_vld_r[k]
                                &  lbuff_done_r[k]
                                &  ((lbuff_fs_vld_r[k] & (func_lbuff_old(i_sbuff_ret_st_id, lbuff_fs_id_r[k])))
                                |   (~lbuff_fs_vld_r[k])) 
                                & (lbuff_pa_done_r[k] & (lbuff_paddr_r[k] == i_sbuff_ret_paddr)));
    end
endgenerate

wire lbuff_ret_cmp_scheme_0 = (|(lbuff_ret_cmp << i_dsp_exu_ld_ret_ptr[4 : 0]));
wire [31 : 0] ret_cmp = ({32{lbuff_ret_cmp_scheme_0   }} & (lbuff_ret_cmp & func_mask(i_dsp_exu_ld_ret_ptr[4 : 0]))   )
                      | ({32{(~lbuff_ret_cmp_scheme_0)}} & (lbuff_ret_cmp & (~func_mask(i_dsp_exu_ld_ret_ptr[4 : 0]))));

wire [4 : 0] lbuff_ls_flush_id = func_find_vec(ret_cmp);

wire exu_ls_flush_nxt = ((|lbuff_ret_cmp) & i_sbuff_ret_vld);
gnrl_dffr #( 
    .DATA_WIDTH   (1),
    .INITIAL_VALUE(0)
) exu_ls_flush_dffr (exu_ls_flush_nxt, o_exu_ls_flush, clk, rst_n);

//
wire [`ROB_ID_WIDTH - 1 : 0] exu_ls_rob_id_nxt = lbuff_rob_id_r[lbuff_ls_flush_id];

gnrl_dffr #( 
    .DATA_WIDTH   (`ROB_ID_WIDTH),
    .INITIAL_VALUE(0)
) exu_ls_rob_id_dffr (exu_ls_rob_id_nxt, o_exu_ls_rob_id, clk, rst_n);

assign o_exu_ls_addr = i_rob_exu_ls_addr;

//
assign {
        o_lbuff_dst_vld 
    ,   o_lbuff_dst_code
} = lbuff_info_r[i_rsv_exu_ld_id[4 : 0]];

//  Functions
function [31 : 0] func_vec32;
    input [4 : 0] index;

    case (index)
        5'b00000: func_vec32 = 32'd1;
        5'b00001: func_vec32 = 32'd2;
        5'b00010: func_vec32 = 32'd4;
        5'b00011: func_vec32 = 32'd8;
        5'b00100: func_vec32 = 32'd16;
        5'b00101: func_vec32 = 32'd32;
        5'b00110: func_vec32 = 32'd64;
        5'b00111: func_vec32 = 32'd128;
        5'b01000: func_vec32 = 32'd256;
        5'b01001: func_vec32 = 32'd512;
        5'b01010: func_vec32 = 32'd1024;
        5'b01011: func_vec32 = 32'd2048;
        5'b01100: func_vec32 = 32'd4096;
        5'b01101: func_vec32 = 32'd8192;
        5'b01110: func_vec32 = 32'd16384;
        5'b01111: func_vec32 = 32'd32768;
        5'b10000: func_vec32 = 32'd65536;
        5'b10001: func_vec32 = 32'd131072;
        5'b10010: func_vec32 = 32'd262144;
        5'b10011: func_vec32 = 32'd524288;
        5'b10100: func_vec32 = 32'd1048576;
        5'b10101: func_vec32 = 32'd2097152;
        5'b10110: func_vec32 = 32'd4194304;
        5'b10111: func_vec32 = 32'd8388608;
        5'b11000: func_vec32 = 32'd16777216;
        5'b11001: func_vec32 = 32'd33554432;
        5'b11010: func_vec32 = 32'd67108864;
        5'b11011: func_vec32 = 32'd134217728;
        5'b11100: func_vec32 = 32'd268435456;
        5'b11101: func_vec32 = 32'd536870912;
        5'b11110: func_vec32 = 32'd1073741824;
        5'b11111: func_vec32 = 32'd2147483648;
        default: 
                func_vec32 = 32'd0;
    endcase
endfunction

function func_rob_old;
    input [7 : 0]   func_rob_id0;
    input [7 : 0]   func_rob_id1;
    //  If func_rob_id0 OLDER than func_rob_id1, return HIGH level;
    func_rob_old = (func_rob_id0[7] ^ func_rob_id1[7]) ? (func_rob_id0[6 : 0] >= func_rob_id1[6 : 0])
                 : (func_rob_id0[6 : 0] < func_rob_id1[6 : 0]);
endfunction

function func_lbuff_old;
    input [5 : 0] func_lbuff_id0;
    input [5 : 0] func_lbuff_id1;

    func_lbuff_old = (func_lbuff_id0[5] ^ func_lbuff_id1[5]) ? (func_lbuff_id0[4 : 0] >= func_lbuff_id1[4 : 0])
                   : (func_lbuff_id0[4 : 0] < func_lbuff_id1[4 : 0]);
endfunction


function [4 : 0] func_find_vec;
    input [31 : 0] bit_map;

    casex (bit_map)
        32'bxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxx1 : func_find_vec = 5'd0;
        32'bxxxxxxxxxxxxxxxxxxxxxxxxxxxxxx10 : func_find_vec = 5'd1;
        32'bxxxxxxxxxxxxxxxxxxxxxxxxxxxxx100 : func_find_vec = 5'd2;
        32'bxxxxxxxxxxxxxxxxxxxxxxxxxxxx1000 : func_find_vec = 5'd3;
        32'bxxxxxxxxxxxxxxxxxxxxxxxxxxx10000 : func_find_vec = 5'd4;
        32'bxxxxxxxxxxxxxxxxxxxxxxxxxx100000 : func_find_vec = 5'd5;
        32'bxxxxxxxxxxxxxxxxxxxxxxxxx1000000 : func_find_vec = 5'd6;
        32'bxxxxxxxxxxxxxxxxxxxxxxxx10000000 : func_find_vec = 5'd7;
        32'bxxxxxxxxxxxxxxxxxxxxxxx100000000 : func_find_vec = 5'd8;
        32'bxxxxxxxxxxxxxxxxxxxxxx1000000000 : func_find_vec = 5'd9;
        32'bxxxxxxxxxxxxxxxxxxxxx10000000000 : func_find_vec = 5'd10;
        32'bxxxxxxxxxxxxxxxxxxxx100000000000 : func_find_vec = 5'd11;
        32'bxxxxxxxxxxxxxxxxxxx1000000000000 : func_find_vec = 5'd12;
        32'bxxxxxxxxxxxxxxxxxx10000000000000 : func_find_vec = 5'd13;
        32'bxxxxxxxxxxxxxxxxx100000000000000 : func_find_vec = 5'd14;
        32'bxxxxxxxxxxxxxxxx1000000000000000 : func_find_vec = 5'd15;
        32'bxxxxxxxxxxxxxxx10000000000000000 : func_find_vec = 5'd16;
        32'bxxxxxxxxxxxxxx100000000000000000 : func_find_vec = 5'd17;
        32'bxxxxxxxxxxxxx1000000000000000000 : func_find_vec = 5'd18;
        32'bxxxxxxxxxxxx10000000000000000000 : func_find_vec = 5'd19;
        32'bxxxxxxxxxxx100000000000000000000 : func_find_vec = 5'd20;
        32'bxxxxxxxxxx1000000000000000000000 : func_find_vec = 5'd21;
        32'bxxxxxxxxx10000000000000000000000 : func_find_vec = 5'd22;
        32'bxxxxxxxx100000000000000000000000 : func_find_vec = 5'd23;
        32'bxxxxxxx1000000000000000000000000 : func_find_vec = 5'd24;
        32'bxxxxxx10000000000000000000000000 : func_find_vec = 5'd25;
        32'bxxxxx100000000000000000000000000 : func_find_vec = 5'd26;
        32'bxxxx1000000000000000000000000000 : func_find_vec = 5'd27;
        32'bxxx10000000000000000000000000000 : func_find_vec = 5'd28;
        32'bxx100000000000000000000000000000 : func_find_vec = 5'd29;
        32'bx1000000000000000000000000000000 : func_find_vec = 5'd30;
        32'b10000000000000000000000000000000 : func_find_vec = 5'd31;
        default: begin 
            func_find_vec = 5'd0;
        end
    endcase
endfunction

function [31 : 0] func_mask;
    input [4 : 0] index;

    case (index)
        5'd0  : func_mask = 32'b11111111111111111111111111111111;
        5'd1  : func_mask = 32'b01111111111111111111111111111111;
        5'd2  : func_mask = 32'b00111111111111111111111111111111;
        5'd3  : func_mask = 32'b00011111111111111111111111111111;
        5'd4  : func_mask = 32'b00001111111111111111111111111111;
        5'd5  : func_mask = 32'b00000111111111111111111111111111;
        5'd6  : func_mask = 32'b00000011111111111111111111111111;
        5'd7  : func_mask = 32'b00000001111111111111111111111111;
        5'd8  : func_mask = 32'b00000000111111111111111111111111;
        5'd9  : func_mask = 32'b00000000011111111111111111111111;
        5'd10 : func_mask = 32'b00000000001111111111111111111111;
        5'd11 : func_mask = 32'b00000000000111111111111111111111;
        5'd12 : func_mask = 32'b00000000000011111111111111111111;
        5'd13 : func_mask = 32'b00000000000001111111111111111111;
        5'd14 : func_mask = 32'b00000000000000111111111111111111;
        5'd15 : func_mask = 32'b00000000000000011111111111111111;
        5'd16 : func_mask = 32'b00000000000000001111111111111111;
        5'd17 : func_mask = 32'b00000000000000000111111111111111;
        5'd18 : func_mask = 32'b00000000000000000011111111111111;
        5'd19 : func_mask = 32'b00000000000000000001111111111111;
        5'd20 : func_mask = 32'b00000000000000000000111111111111;
        5'd21 : func_mask = 32'b00000000000000000000011111111111;
        5'd22 : func_mask = 32'b00000000000000000000001111111111;
        5'd23 : func_mask = 32'b00000000000000000000000111111111;
        5'd24 : func_mask = 32'b00000000000000000000000011111111;
        5'd25 : func_mask = 32'b00000000000000000000000001111111;
        5'd26 : func_mask = 32'b00000000000000000000000000111111;
        5'd27 : func_mask = 32'b00000000000000000000000000011111;
        5'd28 : func_mask = 32'b00000000000000000000000000001111;
        5'd29 : func_mask = 32'b00000000000000000000000000000111;
        5'd30 : func_mask = 32'b00000000000000000000000000000011;
        5'd31 : func_mask = 32'b00000000000000000000000000000001;
        default: begin
            func_mask = 32'd0;
        end
    endcase
endfunction

endmodule   //  lbuff_module

`endif  /*  !__EXU_LBUFF_V__!   */