`ifdef __EXU_SBUFF_V__

module sbuff_module (
    input                                           i_csr_trap_flush,
    input                                           i_exu_mis_flush,
    input   [`ROB_ID_WIDTH - 1          : 0]        i_exu_mis_rob_id,

    input   [3                          : 0]        i_dsp_rsv_vld,
    input   [`ROB_ID_WIDTH - 1          : 0]        i_dsp_rsv_rob_id_0,
    input                                           i_dsp_rsv_st_vld_0,
    input   [`SBUFF_ID_WIDTH - 1        : 0]        i_dsp_rsv_st_id_0,
    input                                           i_dsp_rsv_dst_vld_0,
    input   [`PRF_CODE_WIDTH - 1        : 0]        i_dsp_rsv_dst_code_0,
    input   [`DECINFO_WIDTH - 1         : 0]        i_dsp_rsv_decinfo_bus_0,
    input   [`ROB_ID_WIDTH - 1          : 0]        i_dsp_rsv_rob_id_1,
    input                                           i_dsp_rsv_st_vld_1,
    input   [`SBUFF_ID_WIDTH - 1        : 0]        i_dsp_rsv_st_id_1,
    input                                           i_dsp_rsv_dst_vld_1,
    input   [`PRF_CODE_WIDTH - 1        : 0]        i_dsp_rsv_dst_code_1,
    input   [`DECINFO_WIDTH - 1         : 0]        i_dsp_rsv_decinfo_bus_1,
    input   [`ROB_ID_WIDTH - 1          : 0]        i_dsp_rsv_rob_id_2,
    input                                           i_dsp_rsv_st_vld_2,
    input   [`SBUFF_ID_WIDTH - 1        : 0]        i_dsp_rsv_st_id_2,
    input                                           i_dsp_rsv_dst_vld_2,
    input   [`PRF_CODE_WIDTH - 1        : 0]        i_dsp_rsv_dst_code_2,
    input   [`DECINFO_WIDTH - 1         : 0]        i_dsp_rsv_decinfo_bus_2,
    input   [`ROB_ID_WIDTH - 1          : 0]        i_dsp_rsv_rob_id_3,
    input                                           i_dsp_rsv_st_vld_3,
    input   [`SBUFF_ID_WIDTH - 1        : 0]        i_dsp_rsv_st_id_3,
    input                                           i_dsp_rsv_dst_vld_3,
    input   [`PRF_CODE_WIDTH - 1        : 0]        i_dsp_rsv_dst_code_3,
    input   [`DECINFO_WIDTH - 1         : 0]        i_dsp_rsv_decinfo_bus_3,

    input   [`SBUFF_ID_WIDTH - 1        : 0]        i_dsp_exu_st_ret_ptr,
    input   [`SBUFF_ID_WIDTH - 1        : 0]        i_dsp_exu_st_ret_cptr,

    input                                           i_rsv_exu_vld,
    input                                           i_rsv_exu_ld_vld,
    input   [`LBUFF_ID_WIDTH - 1        : 0]        i_rsv_exu_ld_id,
    input                                           i_rsv_exu_st_vld,
    input   [`LBUFF_ID_WIDTH - 1        : 0]        i_rsv_exu_st_id,

    input                                           i_agu_exec_1_vld,
    input   [`CORE_PC_WIDTH - 1         : 0]        i_agu_exec_1_vaddr,
    input   [43                         : 0]        i_agu_exec_1_paddr,
    input   [`PRF_DATA_WIDTH - 1        : 0]        i_agu_exec_1_data,
    input                                           i_agu_exec_2_vld,
    input   [`EXCEPTION_CODE_WIDTH - 1  : 0]        i_agu_exec_2_excp_code,

    input   [3                          : 0]        i_rob_exu_ret_vld,
    input                                           i_rob_exu_ret_st_vld_0,
    input   [`SBUFF_ID_WIDTH - 1        : 0]        i_rob_exu_ret_st_id_0,
    input                                           i_rob_exu_ret_st_vld_1,
    input   [`SBUFF_ID_WIDTH - 1        : 0]        i_rob_exu_ret_st_id_1,
    input                                           i_rob_exu_ret_st_vld_2,
    input   [`SBUFF_ID_WIDTH - 1        : 0]        i_rob_exu_ret_st_id_2,
    input                                           i_rob_exu_ret_st_vld_3,
    input   [`SBUFF_ID_WIDTH - 1        : 0]        i_rob_exu_ret_st_id_3,

    output                                          o_sbuff_fs_vld,
    output  [`SBUFF_ID_WIDTH - 1        : 0]        o_sbuff_fs_id,
    output                                          o_sbuff_dst_vld,
    output  [`PRF_CODE_WIDTH - 1        : 0]        o_sbuff_dst_code,
    output  [`DECINFO_WIDTH - 1         : 0]        o_sbuff_decinfo_bus,
    output  [`PRF_DATA_WIDTH - 1        : 0]        o_sbuff_data,
    output                                          o_sbuff_ret_vld,
    output                                          o_sbuff_ret_cr_vld,
    output  [`MEM_SIZE_WIDTH - 1        : 0]        o_sbuff_ret_mem_size,
    output  [`CORE_PC_WIDTH - 1         : 0]        o_sbuff_ret_vaddr,
    output  [43                         : 0]        o_sbuff_ret_paddr,
    output  [`PRF_DATA_WIDTH - 1        : 0]        o_sbuff_ret_data,
    
    input                                           clk,
    input                                           rst_n
);

wire [31                        : 0] sbuff_vld_r;
wire [`SBUFF_ID_WIDTH - 1       : 0] sbuff_st_id_r [31 : 0];
wire [31                        : 0] sbuff_cr_vld_r;
wire [31                        : 0] sbuff_done_r;
wire [31                        : 0] sbuff_retired_r;
wire [`SBUFF_INFO_WIDTH - 1     : 0] sbuff_info_r [31 : 0];
wire [`ROB_ID_WIDTH - 1         : 0] sbuff_rob_id_r [31 : 0];
wire [`CORE_PC_WIDTH - 1        : 0] sbuff_vaddr_r [31 : 0];
wire [43                        : 0] sbuff_paddr_r [31 : 0];
wire [`PRF_DATA_WIDTH - 1       : 0] sbuff_data_r [31 : 0];
wire [`EXCEPTION_CODE_WIDTH - 1 : 0] sbuff_excp_code_r [31 : 0];

//
wire sbuff_need_flush = (i_csr_trap_flush | i_exu_mis_flush);
wire sbuff_need_req = (|i_dsp_rsv_vld);
wire sbuff_need_ret = (|i_rob_exu_ret_vld);

//  Modify sbuff_vld_r
wire sbuff_vld_ena = (sbuff_need_flush | sbuff_need_req | sbuff_need_req);
wire [31 : 0] sbuff_vld_flush_free;
wire [31 : 0] sbuff_vld_free;

genvar i;
generate
    for(i = 0; i < 32; i = i + 1) begin
        assign sbuff_vld_flush_free[i] = ((func_rob_old(i_exu_mis_rob_id, sbuff_rob_id_r[i]) & i_exu_mis_flush) | i_csr_trap_flush);
        assign sbuff_vld_free[i] = ((i == i_rob_exu_ret_st_id_0[4 : 0]) & i_rob_exu_ret_vld[0] & i_rob_exu_ret_st_vld_0)
                                 | ((i == i_rob_exu_ret_st_id_1[4 : 0]) & i_rob_exu_ret_vld[1] & i_rob_exu_ret_st_vld_1)
                                 | ((i == i_rob_exu_ret_st_id_2[4 : 0]) & i_rob_exu_ret_vld[2] & i_rob_exu_ret_st_vld_2)
                                 | ((i == i_rob_exu_ret_st_id_3[4 : 0]) & i_rob_exu_ret_vld[3] & i_rob_exu_ret_st_vld_3);
    end
endgenerate

wire [31 : 0] sbuff_vld_nxt = (sbuff_vld_r
                            | ({32{(i_dsp_rsv_vld[0] & i_dsp_rsv_st_vld_0)}} & func_vec32(i_dsp_rsv_rob_id_0))
                            | ({32{(i_dsp_rsv_vld[1] & i_dsp_rsv_st_vld_1)}} & func_vec32(i_dsp_rsv_rob_id_1))
                            | ({32{(i_dsp_rsv_vld[2] & i_dsp_rsv_st_vld_2)}} & func_vec32(i_dsp_rsv_rob_id_2))
                            | ({32{(i_dsp_rsv_vld[3] & i_dsp_rsv_st_vld_3)}} & func_vec32(i_dsp_rsv_rob_id_3)))
                            & (~(sbuff_vld_flush_free | sbuff_vld_free));

gnrl_dfflr #( 
    .DATA_WIDTH   (32),
    .INITIAL_VALUE(0)
) sbuff_vld_dfflr (sbuff_vld_ena, sbuff_vld_nxt, sbuff_vld_r, clk, rst_n);

//  Modify sbuff_info_r
wire [`SBUFF_INFO_WIDTH - 1 : 0] sbuff_info_0 = {
                                                    i_dsp_rsv_dst_vld_0
                                                ,   i_dsp_rsv_dst_code_0
                                                ,   i_dsp_rsv_decinfo_bus_0
                                            };

wire [`SBUFF_INFO_WIDTH - 1 : 0] sbuff_info_1 = {
                                                    i_dsp_rsv_dst_vld_1
                                                ,   i_dsp_rsv_dst_code_1
                                                ,   i_dsp_rsv_decinfo_bus_1
                                            };

wire [`SBUFF_INFO_WIDTH - 1 : 0] sbuff_info_2 = {
                                                    i_dsp_rsv_dst_vld_2
                                                ,   i_dsp_rsv_dst_code_2
                                                ,   i_dsp_rsv_decinfo_bus_2
                                            };

wire [`SBUFF_INFO_WIDTH - 1 : 0] sbuff_info_3 = {
                                                    i_dsp_rsv_dst_vld_3
                                                ,   i_dsp_rsv_dst_code_3
                                                ,   i_dsp_rsv_decinfo_bus_3
                                            };

wire [31 : 0] sbuff_info_ena;
wire [`SBUFF_INFO_WIDTH - 1 : 0] sbuff_info_nxt [31 : 0];
wire [`ROB_ID_WIDTH - 1 : 0] sbuff_rob_id_nxt [31 : 0];
wire [`SBUFF_ID_WIDTH - 1 : 0] sbuff_st_id_nxt [31 : 0];

genvar info_idx;
generate
    for(info_idx = 0; info_idx < 32; info_idx = info_idx + 1) begin
        assign sbuff_info_ena[info_idx] = ((info_idx == i_dsp_rsv_st_id_0[4 : 0]) & i_dsp_rsv_vld[0] & i_dsp_rsv_st_vld_0)
                                        | ((info_idx == i_dsp_rsv_st_id_1[4 : 0]) & i_dsp_rsv_vld[1] & i_dsp_rsv_st_vld_1)
                                        | ((info_idx == i_dsp_rsv_st_id_2[4 : 0]) & i_dsp_rsv_vld[2] & i_dsp_rsv_st_vld_2)
                                        | ((info_idx == i_dsp_rsv_st_id_3[4 : 0]) & i_dsp_rsv_vld[3] & i_dsp_rsv_st_vld_3);
        assign sbuff_info_nxt[info_idx] = ({`SBUFF_INFO_WIDTH{(info_idx == i_dsp_rsv_st_id_0[4 : 0])}} & sbuff_info_0)
                                        | ({`SBUFF_INFO_WIDTH{(info_idx == i_dsp_rsv_st_id_1[4 : 0])}} & sbuff_info_1)
                                        | ({`SBUFF_INFO_WIDTH{(info_idx == i_dsp_rsv_st_id_2[4 : 0])}} & sbuff_info_2)
                                        | ({`SBUFF_INFO_WIDTH{(info_idx == i_dsp_rsv_st_id_3[4 : 0])}} & sbuff_info_3);
        gnrl_dffl #( 
            .DATA_WIDTH(`SBUFF_INFO_WIDTH)
        ) sbuff_info_dffl (sbuff_info_ena[info_idx], sbuff_info_nxt[info_idx], sbuff_info_r[info_idx], clk);
    
        assign sbuff_rob_id_nxt[info_idx] = ({`ROB_ID_WIDTH{(info_idx == i_dsp_rsv_st_id_0[4 : 0])}} & i_dsp_rsv_rob_id_0)
                                          | ({`ROB_ID_WIDTH{(info_idx == i_dsp_rsv_st_id_1[4 : 0])}} & i_dsp_rsv_rob_id_1)
                                          | ({`ROB_ID_WIDTH{(info_idx == i_dsp_rsv_st_id_2[4 : 0])}} & i_dsp_rsv_rob_id_2)
                                          | ({`ROB_ID_WIDTH{(info_idx == i_dsp_rsv_st_id_3[4 : 0])}} & i_dsp_rsv_rob_id_3);
        gnrl_dffl #( 
            .DATA_WIDTH(`ROB_ID_WIDTH)
        ) sbuff_rob_id_dffl (sbuff_info_ena[info_idx], sbuff_rob_id_nxt[info_idx], sbuff_rob_id_r[info_idx], clk);

        assign sbuff_st_id_nxt[info_idx] = ({`ROB_ID_WIDTH{(info_idx == i_dsp_rsv_st_id_0[4 : 0])}} & i_dsp_rsv_st_id_0)
                                         | ({`ROB_ID_WIDTH{(info_idx == i_dsp_rsv_st_id_1[4 : 0])}} & i_dsp_rsv_st_id_1)
                                         | ({`ROB_ID_WIDTH{(info_idx == i_dsp_rsv_st_id_2[4 : 0])}} & i_dsp_rsv_st_id_2)
                                         | ({`ROB_ID_WIDTH{(info_idx == i_dsp_rsv_st_id_3[4 : 0])}} & i_dsp_rsv_st_id_3);
        gnrl_dffl #( 
            .DATA_WIDTH(`SBUFF_ID_WIDTH)
        ) sbuff_st_id_dffl (sbuff_info_ena[info_idx], sbuff_st_id_nxt[info_idx], sbuff_st_id_r[info_idx], clk);
    end
endgenerate

//  Modify sbuff_cr_vld_r
wire sbuff_cr_vld_ena = (i_rsv_exu_vld & i_rsv_exu_st_vld & i_agu_exec_1_vld);
wire [31 : 0] sbuff_cr_vld_nxt = (sbuff_cr_vld | ({32{sbuff_cr_vld_ena & i_agu_cr_vld}} & func_vec32(i_rsv_exu_st_id[4 : 0])))
                               & (~(sbuff_vld_free | sbuff_vld_flush_free));

gnrl_dfflr #( 
    .DATA_WIDTH   (32),
    .INITIAL_VALUE(0)
) sbuff_cr_vld_dfflr (sbuff_cr_vld_ena, sbuff_cr_vld_nxt, sbuff_cr_vld_r, clk, rst_n);

//  Modify sbuff_done_r
wire sbuff_done_ena = (sbuff_need_flush | sbuff_need_ret | (i_rsv_exu_vld & i_rsv_exu_ld_vld & i_agu_exec_1_vld));
wire [31 : 0] sbuff_done_nxt = (sbuff_done_r
                             | ({32{(i_rsv_exu_vld & i_rsv_exu_ld_vld & i_agu_exec_1_vld)}} & func_vec32(i_rsv_exu_ld_id[4 : 0])))
                             & (~(sbuff_vld_flush_free | sbuff_vld_free));
gnrl_dfflr #( 
    .DATA_WIDTH   (32),
    .INITIAL_VALUE(0)
) sbuff_done_dfflr (sbuff_done_ena, sbuff_done_nxt, sbuff_done_r, clk, rst_n);

//  Modify sbuff_excp_code_r
wire [31 : 0] sbuff_excp_code_ena;
genvar excp_idx;
generate
    for(excp_idx = 0; excp_idx < 32; excp_idx = excp_idx + 1) begin
        assign sbuff_excp_code_ena[excp_idx] = (i_agu_exec_2_vld & (excp_idx == i_rsv_exu_st_id[4 : 0]));
        gnrl_dfflr #( 
            .DATA_WIDTH   (`EXCEPTION_CODE_WIDTH),
            .INITIAL_VALUE(0)
        ) sbuff_excp_code_dfflr (sbuff_excp_code_ena[excp_idx], i_agu_exec_2_excp_code, sbuff_excp_code_r[excp_idx], clk, rst_n);
    end
endgenerate

//  Modify sbuff_vaddr_r
wire [31 : 0] sbuff_vaddr_ena;

genvar vaddr_idx;
generate
    for(vaddr_idx = 0; vaddr_idx < 32; vaddr_idx = vaddr_idx + 1) begin
        assign sbuff_vaddr_ena[vaddr_idx] = (i_rsv_exu_vld & i_rsv_exu_ld_vld & i_agu_exec_1_vld & (vaddr_idx == i_rsv_exu_ld_id[4 : 0]));
        gnrl_dffl #( 
            .DATA_WIDTH(`CORE_PC_WIDTH)
        ) sbuff_vaddr_dfflr (sbuff_vaddr_ena[vaddr_idx], i_agu_exec_1_vaddr, sbuff_vaddr_r[vaddr_idx], clk);
    end
endgenerate

//  Modify sbuff_paddr_r
wire [31 : 0] sbuff_pa_done_ena;

genvar pa_idx;
generate
    for(pa_idx = 0; pa_idx < 32; pa_idx = pa_idx + 1) begin
        assign sbuff_pa_ena[pa_idx] = (i_rsv_exu_vld
                                         &  i_rsv_exu_ld_vld
                                         &  i_agu_exec_1_vld
                                         &  (pa_idx == i_rsv_exu_ld_id[4 : 0]));
        gnrl_dffl #( 
            .DATA_WIDTH(44)
        ) sbuff_paddr_dffl (sbuff_pa_ena[pa_idx], i_agu_exec_1_paddr, sbuff_paddr_r[pa_idx], clk);
    end
endgenerate


//  Modify sbuff_data_r
wire [31 : 0] sbuff_data_ena;

genvar data_idx;
generate
    for(data_idx = 0; data_idx < 32; data_idx = data_idx + 1) begin
        assign sbuff_data_ena[data_idx] = (i_rsv_exu_vld
                                        &  i_rsv_exu_ld_vld
                                        &  i_agu_exec_1_vld
                                        &  (data_idx == i_rsv_exu_ld_id[4 : 0]));
        gnrl_dffl #( 
            .DATA_WIDTH(`PRF_DATA_WIDTH)
        ) sbuff_data_dffl (sbuff_data_ena[data_idx], i_agu_exec_1_data, sbuff_data_r[data_idx], clk);
    end
endgenerate

//
wire [31 : 0] sbuff_ld_cmp;

genvar j;
generate
    for(j = 0; j < 32; j = j + 1) begin
        assign sbuff_ld_cmp[j] = (i_rsv_exu_vld
                               &  i_rsv_exu_ld_vld 
                               &  sbuff_done_r[j]
                               &  (i_rsv_exu_vaddr == sbuff_vaddr_r[j])
                               &  (i_rsv_exu_mem_size <= sbuff_info_r[j][8 : 7]));
    end
endgenerate

wire sbuff_ld_cmp_scheme_0 = (|(sbuff_ld_cmp << i_dsp_exu_st_ret_ptr[4 : 0]));
wire [31 : 0] ret_cmp = ({32{(~sbuff_ld_cmp_scheme_0)}} & (sbuff_ld_cmp & func_mask(i_dsp_exu_st_ret_ptr[4 : 0]))   )
                      | ({32{sbuff_ld_cmp_scheme_0   }} & (sbuff_ld_cmp & (~func_mask(i_dsp_exu_st_ret_ptr[4 : 0]))));

wire [4 : 0] sbuff_fs_id = func_find_vec_r(ret_cmp);
assign o_sbuff_fs_vld = (|sbuff_ld_cmp);
assign o_sbuff_fs_id  = (sbuff_fs_st_id_r[sbuff_fs_id]);

assign {
        o_sbuff_dst_vld
    ,   o_sbuff_dst_code
    ,   o_sbuff_decinfo_bus
    ,   o_sbuff_data
} = {
        sbuff_info_r[i_dsp_exu_st_ret_cptr[4 : 0]]
    ,   sbuff_data_r[i_dsp_exu_st_ret_cptr[4 : 0]]
};

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

function [4 : 0] func_find_vec_r;
    input   [31 : 0] bit_map;

    casex (bit_map)
        32'b1xxxxxxxxxxxxxxxxxxxxxxxxxxxxxxx : func_find_vec_r = 5'd31;
        32'b01xxxxxxxxxxxxxxxxxxxxxxxxxxxxxx : func_find_vec_r = 5'd30;
        32'b001xxxxxxxxxxxxxxxxxxxxxxxxxxxxx : func_find_vec_r = 5'd29;
        32'b0001xxxxxxxxxxxxxxxxxxxxxxxxxxxx : func_find_vec_r = 5'd28;
        32'b00001xxxxxxxxxxxxxxxxxxxxxxxxxxx : func_find_vec_r = 5'd27;
        32'b000001xxxxxxxxxxxxxxxxxxxxxxxxxx : func_find_vec_r = 5'd26;
        32'b0000001xxxxxxxxxxxxxxxxxxxxxxxxx : func_find_vec_r = 5'd25;
        32'b00000001xxxxxxxxxxxxxxxxxxxxxxxx : func_find_vec_r = 5'd24;
        32'b000000001xxxxxxxxxxxxxxxxxxxxxxx : func_find_vec_r = 5'd23;
        32'b0000000001xxxxxxxxxxxxxxxxxxxxxx : func_find_vec_r = 5'd22;
        32'b00000000001xxxxxxxxxxxxxxxxxxxxx : func_find_vec_r = 5'd21;
        32'b000000000001xxxxxxxxxxxxxxxxxxxx : func_find_vec_r = 5'd20;
        32'b0000000000001xxxxxxxxxxxxxxxxxxx : func_find_vec_r = 5'd19;
        32'b00000000000001xxxxxxxxxxxxxxxxxx : func_find_vec_r = 5'd18;
        32'b000000000000001xxxxxxxxxxxxxxxxx : func_find_vec_r = 5'd17;
        32'b0000000000000001xxxxxxxxxxxxxxxx : func_find_vec_r = 5'd16;
        32'b00000000000000001xxxxxxxxxxxxxxx : func_find_vec_r = 5'd15;
        32'b000000000000000001xxxxxxxxxxxxxx : func_find_vec_r = 5'd14;
        32'b0000000000000000001xxxxxxxxxxxxx : func_find_vec_r = 5'd13;
        32'b00000000000000000001xxxxxxxxxxxx : func_find_vec_r = 5'd12;
        32'b000000000000000000001xxxxxxxxxxx : func_find_vec_r = 5'd11;
        32'b0000000000000000000001xxxxxxxxxx : func_find_vec_r = 5'd10;
        32'b00000000000000000000001xxxxxxxxx : func_find_vec_r = 5'd9;
        32'b000000000000000000000001xxxxxxxx : func_find_vec_r = 5'd8;
        32'b0000000000000000000000001xxxxxxx : func_find_vec_r = 5'd7;
        32'b00000000000000000000000001xxxxxx : func_find_vec_r = 5'd6;
        32'b000000000000000000000000001xxxxx : func_find_vec_r = 5'd5;
        32'b0000000000000000000000000001xxxx : func_find_vec_r = 5'd4;
        32'b00000000000000000000000000001xxx : func_find_vec_r = 5'd3;
        32'b000000000000000000000000000001xx : func_find_vec_r = 5'd2;
        32'b0000000000000000000000000000001x : func_find_vec_r = 5'd1;
        32'b00000000000000000000000000000001 : func_find_vec_r = 5'd0;
        default: begin
            func_find_vec_r = 5'd0; 
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

endmodule   //  sbuff_module


`endif  /*  !__EXU_SBUFF_V__!   */