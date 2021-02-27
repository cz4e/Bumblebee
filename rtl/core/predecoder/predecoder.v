`ifdef __PREDECODER_PREDECODER_V__

module predecoder_module (
    input                                               i_csr_trap_flush,
    input                                               i_exu_mis_flush,
    input                                               i_exu_ls_flush,
    input                                               i_cache_predec_vld,
    input                                               i_cache_predec_hit,
    input   [`ICACHE_DATA_WIDTH - 1     : 0]            i_cache_predec_way,
    input                                               i_cache_predec_bypass_vld,
    input   [`ICACHE_DATA_WIDTH - 1     : 0]            i_cache_predec_bypass_dat,
    input   [`EXCEPTION_CODE_WIDTH - 1  : 0]            i_cache_predec_excp_code,
    input   [`CORE_PC_WIDTH - 1         : 0]            i_ifu_predec_addr,
    input   [`PREDINFO_WIDTH - 1        : 0]            i_bpu_predinfo_bus,
    input                                               i_iq_bpu_vld,
    input                                               i_iq_bpu_taken,
    input                                               i_iq_bpu_new_br,
    input                                               i_iq_bpu_type,
    input   [`CORE_PC_WIDTH - 1         : 0]            i_iq_bpu_btb_addr,
    input   [`CORE_PC_WIDTH - 1         : 0]            i_iq_bpu_btb_taddr,
    input   [4                          : 0]            i_iq_bpu_btb_idx,
    input   [9                          : 0]            i_iq_bpu_pht_idx,
    input   [1                          : 0]            i_iq_bpu_pht_entry,
    input                                               i_iq_alias_err,
    input                                               i_iq_predec_stall,
    output  [3                          : 0]            o_predec_iq_vld,
    output  [`CORE_PC_WIDTH - 1         : 0]            o_predec_iq_addr_0,
    output  [`INSTR_WIDTH - 1           : 0]            o_predec_iq_instr_0,
    output  [`CORE_PC_WIDTH - 1         : 0]            o_predec_iq_addr_1,
    output  [`INSTR_WIDTH - 1           : 0]            o_predec_iq_instr_1,
    output  [`CORE_PC_WIDTH - 1         : 0]            o_predec_iq_addr_2,
    output  [`INSTR_WIDTH - 1           : 0]            o_predec_iq_instr_2,
    output  [`CORE_PC_WIDTH - 1         : 0]            o_predec_iq_addr_3,
    output  [`INSTR_WIDTH - 1           : 0]            o_predec_iq_instr_3,
    output  [3                          : 0]            o_predec_iq_len,
    output  [`PREDINFO_WIDTH - 1        : 0]            o_predec_iq_predinfo_bus,
    output  [5                          : 0]            o_predec_iq_type_0,
    output  [5                          : 0]            o_predec_iq_type_1,
    output  [5                          : 0]            o_predec_iq_type_2,
    output  [5                          : 0]            o_predec_iq_type_3,
    output  [3                          : 0]            o_predec_iq_alias_vec_0,
    output  [3                          : 0]            o_predec_iq_alias_vec_1,
    output  [3                          : 0]            o_predec_iq_alias_vec_2,
    output  [3                          : 0]            o_predec_iq_alias_vec_3,
    output  [3                          : 0]            o_predec_iq_match_vec_0,
    output  [3                          : 0]            o_predec_iq_match_vec_1,
    output  [3                          : 0]            o_predec_iq_match_vec_2,
    output  [3                          : 0]            o_predec_iq_match_vec_3,
    output  [`EXCEPTION_CODE_WIDTH - 1  : 0]            o_predec_iq_excp_code,
    output                                              o_predec_icache_16byte_done,
    output                                              o_predec_icache_64byte_done,

    input                                               clk,
    input                                               rst_n
);

//
wire predec_need_flush = (i_csr_trap_flush | i_exu_mis_flush | i_exu_ls_flush);
wire predec_instr_vld = ((i_cache_predec_vld & i_cache_predec_hit) | i_cache_predec_bypass_vld);

wire [`ICACHE_DATA_WIDTH - 1 : 0] predec_instr = ({`ICACHE_DATA_WIDTH{i_cache_predec_bypass_vld}} & i_cache_predec_bypass_dat)
                                               | ({`ICACHE_DATA_WIDTH{i_cache_predec_hit       }} & i_cache_predec_way       );

//
localparam  PREDEC_CTR_0 = 2'd0,
            PREDEC_CTR_1 = 2'd1,
            PREDEC_CTR_2 = 2'd2;

wire [1 : 0] predec_ctr_r;
wire predec_ctr_set = (predec_sta_ena & (predec_sta_nxt == PREDEC_STATE_DEC0));
wire predec_ctr_inc = (predec_need_2cycles_r & (~predec_last_cycle) & (~i_iq_predec_stall));
wire predec_ctr_clr = predec_need_flush;
wire predec_ctr_ena = (predec_ctr_set | predec_ctr_inc | predec_ctr_clr);
wire [1 : 0] predec_ctr_nxt = predec_ctr_clr ? 2'd0
                            : predec_ctr_set ? PREDEC_CTR_1
                            : (predec_ctr_r + 1'b1);

gnrl_dfflr #(
    .DATA_WIDTH   (2),
    .INITIAL_VALUE(0)
) predec_ctr_dfflr (predec_ctr_ena, predec_ctr_nxt, predec_ctr_r, clk, rst_n);


wire predec_1th = (predec_ctr_r == PREDEC_CTR_1);
wire predec_2th = (predec_ctr_r == PREDEC_CTR_2);
wire predec_last_cycle = ((predec_need_2cycles_r & predec_2th)
                       | ((~predec_need_2cycles_r) & predec_1th));

wire predec_iq_vld = (predec_1th | predec_2th);
assign o_predec_iq_vld = {
                            (predec_iq_vld) & (|o_predec_iq_instr_3)
                        ,   (predec_iq_vld) & (|o_predec_iq_instr_2)
                        ,   (predec_iq_vld) & (|o_predec_iq_instr_1)
                        ,   (predec_iq_vld) & (|o_predec_iq_instr_0)
                       };
//
localparam  PREDEC_CNT_WIDTH = 3;

wire [PREDEC_CNT_WIDTH - 1 : 0] predec_cnt_r;
wire predec_cnt_set = (predec_instr_vld & (~i_iq_predec_stall));
wire predec_cnt_sub = (o_predec_icache_16byte_done & (predec_cnt_r != 3'd0) & (~i_iq_predec_stall));
wire predec_cnt_clr = predec_need_flush;
wire predec_cnt_ena = (predec_cnt_set | predec_cnt_clr | predec_cnt_sub);
wire [PREDEC_CNT_WIDTH - 1 : 0] predec_cnt_nxt = predec_cnt_clr ? 3'd0
                                               : predec_cnt_set ? (({PREDEC_CNT_WIDTH{(i_ifu_predec_addr[5 : 4] == 2'b00)}} & 3'd4)
                                                                |  ({PREDEC_CNT_WIDTH{(i_ifu_predec_addr[5 : 4] == 2'b01)}} & 3'd3)
                                                                |  ({PREDEC_CNT_WIDTH{(i_ifu_predec_addr[5 : 4] == 2'b10)}} & 3'd2)
                                                                |  ({PREDEC_CNT_WIDTH{(i_ifu_predec_addr[5 : 4] == 2'b11)}} & 3'd1))
                                               : (predec_cnt_r - 1'd1);
gnrl_dfflr #(
    .DATA_WIDTH   (PREDEC_CNT_WIDTH),
    .INITIAL_VALUE(0)
) predec_cnt_dfflr (predec_cnt_ena, predec_cnt_nxt, predec_cnt_r, clk, rst_n);

//
wire predec_buf_flag_r;
wire predec_buf_flag_set = predec_cnt_set;
wire predec_buf_flag_clr = (o_predec_icache_64byte_done | predec_need_flush);
wire predec_buf_flag_ena = (predec_buf_flag_set | predec_buf_flag_clr);
wire predec_buf_flag_nxt = (predec_buf_flag_set | (~predec_buf_flag_clr));

gnrl_dfflr #(
    .DATA_WIDTH   (1),
    .INITIAL_VALUE(0)
) predec_buf_flag_dfflr (predec_buf_flag_ena, predec_buf_flag_nxt, predec_buf_flag_r, clk, rst_n);

//
localparam  PREDEC_STATE_WIDTH = 3;
localparam  PREDEC_STATE_IDLE = 3'd1,
            PREDEC_STATE_DEC0 = 3'd2,
            PREDEC_STATE_DEC1 = 3'd4;

wire [PREDEC_STATE_WIDTH - 1 : 0] predec_sta_cur_r, predec_sta_nxt;

wire predec_sta_idle = (predec_sta_cur_r == PREDEC_STATE_IDLE);
wire predec_sta_dec0 = (predec_sta_cur_r == PREDEC_STATE_DEC0);
wire predec_sta_dec1 = (predec_sta_cur_r == PREDEC_STATE_DEC1);

wire predec_sta_exit_idle_ena = (predec_sta_idle & predec_instr_vld);
wire [PREDEC_STATE_WIDTH - 1 : 0] predec_sta_exit_idle_nxt = PREDEC_STATE_DEC0;

wire predec_sta_exit_dec0_ena = (predec_sta_dec0 & (predec_need_flush | predec_need_2cycles_r | predec_last_cycle));
wire [PREDEC_STATE_WIDTH - 1 : 0] predec_sta_exit_dec0_nxt = (predec_need_flush | predec_last_cycle) ? PREDEC_STATE_IDLE
                                                           : PREDEC_STATE_DEC1;

wire predec_sta_exit_dec1_ena = predec_sta_dec1;
wire [PREDEC_STATE_WIDTH - 1 : 0] predec_sta_exit_dec1_nxt = (predec_need_flush | o_predec_icache_64byte_done) ? PREDEC_STATE_IDLE
                                                           : PREDEC_STATE_DEC0;

wire predec_sta_enter_dec0 = (predec_sta_nxt == PREDEC_STATE_DEC0);

assign predec_sta_nxt = ({PREDEC_STATE_WIDTH{predec_sta_exit_idle_ena}} & predec_sta_exit_idle_nxt)
                      | ({PREDEC_STATE_WIDTH{predec_sta_exit_dec0_ena}} & predec_sta_exit_dec0_nxt)
                      | ({PREDEC_STATE_WIDTH{predec_sta_exit_dec1_ena}} & predec_sta_exit_dec1_nxt);

wire predec_sta_ena = ((predec_sta_exit_idle_ena | predec_sta_exit_dec0_ena | predec_sta_exit_dec1_ena) & (~i_iq_predec_stall));

gnrl_dfflr #(
    .DATA_WIDTH   (PREDEC_STATE_WIDTH),
    .INITIAL_VALUE(PREDEC_STATE_IDLE)
) predec_sta_dfflr (predec_sta_ena, predec_sta_nxt, predec_sta_cur_r, clk, rst_n);

//
wire predec_instr_buf_ena = predec_cnt_set;
wire [383 : 0] predec_instr_buf_r, predec_instr_buf_nxt;

assign predec_instr_buf_nxt = predec_instr[511 : 128];

gnrl_dffl #(
    .DATA_WIDTH   (384)
) predec_instr_buf_dffl (predec_instr_buf_ena, predec_instr_buf_nxt, predec_instr_buf_r, clk);

//
wire predec_left_buf_ena = ((predec_instr_vld | predec_last_cycle) & (~i_iq_predec_stall));
wire [15 : 0] predec_left_buf_r, predec_left_buf_nxt;

assign predec_left_buf_nxt = predec_instr_16[127 : 112];

gnrl_dffl #(
    .DATA_WIDTH   (16)
) predec_left_buf_dffl (predec_left_buf_ena, predec_left_buf_nxt, predec_left_buf_r, clk);
//
wire predec_cross_instr_ena = predec_left_buf_ena;
wire predec_cross_instr_r, predec_cross_instr_nxt;

gnrl_dfflr #(
    .DATA_WIDTH   (1),
    .INITIAL_VALUE(0)
) predec_cross_instr_dfflr (predec_cross_instr_ena, predec_cross_instr_nxt, predec_cross_instr_r, clk, rst_n);

//
wire [127 : 0] predec_instr_16 = ({128{ (i_ifu_predec_addr[5 : 4] == 2'b00)                          }} & predec_instr[127 : 0]        )
                               | ({128{((i_ifu_predec_addr[5 : 4] == 2'b01) & predec_buf_flag_r   )}} & predec_instr[255 : 128]      )
                               | ({128{((i_ifu_predec_addr[5 : 4] == 2'b01) & (~predec_buf_flag_r))}} & predec_instr_buf_r[127 : 0]  )
                               | ({128{((i_ifu_predec_addr[5 : 4] == 2'b10) & predec_buf_flag_r)   }} & predec_instr[383 : 256]      )
                               | ({128{((i_ifu_predec_addr[5 : 4] == 2'b10) & (~predec_buf_flag_r))}} & predec_instr_buf_r[255 : 128])
                               | ({128{((i_ifu_predec_addr[5 : 4] == 2'b11) & predec_buf_flag_r   )}} & predec_instr[511 : 384]      )
                               | ({128{((i_ifu_predec_addr[5 : 4] == 2'b11) & (~predec_buf_flag_r))}} & predec_instr_buf_r[383 : 128]);

wire [15 : 0] predec_instr_0, predec_instr_1, predec_instr_2, predec_instr_3;
wire [15 : 0] predec_instr_4, predec_instr_5, predec_instr_6, predec_instr_7;

assign {
        predec_instr_7
    ,   predec_instr_6
    ,   predec_instr_5
    ,   predec_instr_4
    ,   predec_instr_3
    ,   predec_instr_2
    ,   predec_instr_1
    ,   predec_instr_0
} = predec_instr_16;

wire predec_instr_7_4b = (predec_instr_7[1 : 0] == 2'b11);
wire predec_instr_6_4b = (predec_instr_6[1 : 0] == 2'b11);
wire predec_instr_5_4b = (predec_instr_5[1 : 0] == 2'b11);
wire predec_instr_4_4b = (predec_instr_4[1 : 0] == 2'b11);
wire predec_instr_3_4b = (predec_instr_3[1 : 0] == 2'b11);
wire predec_instr_2_4b = (predec_instr_2[1 : 0] == 2'b11);
wire predec_instr_1_4b = (predec_instr_1[1 : 0] == 2'b11);
wire predec_instr_0_4b = (predec_instr_0[1 : 0] == 2'b11);

wire predec_instr_7_2b = (~predec_instr_7_4b);
wire predec_instr_6_2b = (~predec_instr_6_4b);
wire predec_instr_5_2b = (~predec_instr_5_4b);
wire predec_instr_4_2b = (~predec_instr_4_4b);
wire predec_instr_3_2b = (~predec_instr_3_4b);
wire predec_instr_2_2b = (~predec_instr_2_4b);
wire predec_instr_1_2b = (~predec_instr_1_4b);
wire predec_instr_0_2b = (~predec_instr_0_4b);

wire predec_left_buf_4b = (predec_cross_instr_r);
wire predec_left_buf_2b = (~predec_left_buf_4b);

//
wire [88 : 0] predec_case;
assign predec_case[0]	 = predec_left_buf_2b & predec_instr_0_2b & predec_instr_1_2b & predec_instr_2_2b & predec_instr_3_2b & predec_instr_4_2b & predec_instr_5_2b & predec_instr_6_2b & predec_instr_7_2b;
assign predec_case[1]	 = predec_left_buf_2b & predec_instr_0_2b & predec_instr_1_2b & predec_instr_2_2b & predec_instr_3_2b & predec_instr_4_2b & predec_instr_5_2b & predec_instr_6_2b & predec_instr_7_4b;
assign predec_case[2]	 = predec_left_buf_2b & predec_instr_0_2b & predec_instr_1_2b & predec_instr_2_2b & predec_instr_3_2b & predec_instr_4_2b & predec_instr_5_2b & predec_instr_6_4b;
assign predec_case[3]	 = predec_left_buf_2b & predec_instr_0_2b & predec_instr_1_2b & predec_instr_2_2b & predec_instr_3_2b & predec_instr_4_2b & predec_instr_5_4b & predec_instr_7_2b;
assign predec_case[4]	 = predec_left_buf_2b & predec_instr_0_2b & predec_instr_1_2b & predec_instr_2_2b & predec_instr_3_2b & predec_instr_4_2b & predec_instr_5_4b & predec_instr_7_4b;
assign predec_case[5]	 = predec_left_buf_2b & predec_instr_0_2b & predec_instr_1_2b & predec_instr_2_2b & predec_instr_3_2b & predec_instr_4_4b & predec_instr_6_2b & predec_instr_7_2b;
assign predec_case[6]	 = predec_left_buf_2b & predec_instr_0_2b & predec_instr_1_2b & predec_instr_2_2b & predec_instr_3_2b & predec_instr_4_4b & predec_instr_6_2b & predec_instr_7_4b;
assign predec_case[7]	 = predec_left_buf_2b & predec_instr_0_2b & predec_instr_1_2b & predec_instr_2_2b & predec_instr_3_2b & predec_instr_4_4b & predec_instr_6_4b;
assign predec_case[8]	 = predec_left_buf_2b & predec_instr_0_2b & predec_instr_1_2b & predec_instr_2_2b & predec_instr_3_4b & predec_instr_5_2b & predec_instr_6_2b & predec_instr_7_2b;
assign predec_case[9]	 = predec_left_buf_2b & predec_instr_0_2b & predec_instr_1_2b & predec_instr_2_2b & predec_instr_3_4b & predec_instr_5_2b & predec_instr_6_2b & predec_instr_7_4b;
assign predec_case[10]	 = predec_left_buf_2b & predec_instr_0_2b & predec_instr_1_2b & predec_instr_2_2b & predec_instr_3_4b & predec_instr_5_2b & predec_instr_6_4b;
assign predec_case[11]	 = predec_left_buf_2b & predec_instr_0_2b & predec_instr_1_2b & predec_instr_2_2b & predec_instr_3_4b & predec_instr_5_4b & predec_instr_7_2b;
assign predec_case[12]	 = predec_left_buf_2b & predec_instr_0_2b & predec_instr_1_2b & predec_instr_2_2b & predec_instr_3_4b & predec_instr_5_4b & predec_instr_7_4b;
assign predec_case[13]	 = predec_left_buf_2b & predec_instr_0_2b & predec_instr_1_2b & predec_instr_2_4b & predec_instr_4_2b & predec_instr_5_2b & predec_instr_6_2b & predec_instr_7_2b;
assign predec_case[14]	 = predec_left_buf_2b & predec_instr_0_2b & predec_instr_1_2b & predec_instr_2_4b & predec_instr_4_2b & predec_instr_5_2b & predec_instr_6_2b & predec_instr_7_4b;
assign predec_case[15]	 = predec_left_buf_2b & predec_instr_0_2b & predec_instr_1_2b & predec_instr_2_4b & predec_instr_4_2b & predec_instr_5_2b & predec_instr_6_4b;
assign predec_case[16]	 = predec_left_buf_2b & predec_instr_0_2b & predec_instr_1_2b & predec_instr_2_4b & predec_instr_4_2b & predec_instr_5_4b & predec_instr_7_2b;
assign predec_case[17]	 = predec_left_buf_2b & predec_instr_0_2b & predec_instr_1_2b & predec_instr_2_4b & predec_instr_4_2b & predec_instr_5_4b & predec_instr_7_4b;
assign predec_case[18]	 = predec_left_buf_2b & predec_instr_0_2b & predec_instr_1_2b & predec_instr_2_4b & predec_instr_4_4b & predec_instr_6_2b & predec_instr_7_2b;
assign predec_case[19]	 = predec_left_buf_2b & predec_instr_0_2b & predec_instr_1_2b & predec_instr_2_4b & predec_instr_4_4b & predec_instr_6_2b & predec_instr_7_4b;
assign predec_case[20]	 = predec_left_buf_2b & predec_instr_0_2b & predec_instr_1_2b & predec_instr_2_4b & predec_instr_4_4b & predec_instr_6_4b;
assign predec_case[21]	 = predec_left_buf_2b & predec_instr_0_2b & predec_instr_1_4b & predec_instr_3_2b & predec_instr_4_2b & predec_instr_5_2b & predec_instr_6_2b & predec_instr_7_2b;
assign predec_case[22]	 = predec_left_buf_2b & predec_instr_0_2b & predec_instr_1_4b & predec_instr_3_2b & predec_instr_4_2b & predec_instr_5_2b & predec_instr_6_2b & predec_instr_7_4b;
assign predec_case[23]	 = predec_left_buf_2b & predec_instr_0_2b & predec_instr_1_4b & predec_instr_3_2b & predec_instr_4_2b & predec_instr_5_2b & predec_instr_6_4b;
assign predec_case[24]	 = predec_left_buf_2b & predec_instr_0_2b & predec_instr_1_4b & predec_instr_3_2b & predec_instr_4_2b & predec_instr_5_4b & predec_instr_7_2b;
assign predec_case[25]	 = predec_left_buf_2b & predec_instr_0_2b & predec_instr_1_4b & predec_instr_3_2b & predec_instr_4_2b & predec_instr_5_4b & predec_instr_7_4b;
assign predec_case[26]	 = predec_left_buf_2b & predec_instr_0_2b & predec_instr_1_4b & predec_instr_3_2b & predec_instr_4_4b & predec_instr_6_2b & predec_instr_7_2b;
assign predec_case[27]	 = predec_left_buf_2b & predec_instr_0_2b & predec_instr_1_4b & predec_instr_3_2b & predec_instr_4_4b & predec_instr_6_2b & predec_instr_7_4b;
assign predec_case[28]	 = predec_left_buf_2b & predec_instr_0_2b & predec_instr_1_4b & predec_instr_3_2b & predec_instr_4_4b & predec_instr_6_4b;
assign predec_case[29]	 = predec_left_buf_2b & predec_instr_0_2b & predec_instr_1_4b & predec_instr_3_4b & predec_instr_5_2b & predec_instr_6_2b & predec_instr_7_2b;
assign predec_case[30]	 = predec_left_buf_2b & predec_instr_0_2b & predec_instr_1_4b & predec_instr_3_4b & predec_instr_5_2b & predec_instr_6_2b & predec_instr_7_4b;
assign predec_case[31]	 = predec_left_buf_2b & predec_instr_0_2b & predec_instr_1_4b & predec_instr_3_4b & predec_instr_5_2b & predec_instr_6_4b;
assign predec_case[32]	 = predec_left_buf_2b & predec_instr_0_2b & predec_instr_1_4b & predec_instr_3_4b & predec_instr_5_4b & predec_instr_7_2b;
assign predec_case[33]	 = predec_left_buf_2b & predec_instr_0_2b & predec_instr_1_4b & predec_instr_3_4b & predec_instr_5_4b & predec_instr_7_4b;
assign predec_case[34]	 = predec_left_buf_2b & predec_instr_0_4b & predec_instr_2_2b & predec_instr_3_2b & predec_instr_4_2b & predec_instr_5_2b & predec_instr_6_2b & predec_instr_7_2b;
assign predec_case[35]	 = predec_left_buf_2b & predec_instr_0_4b & predec_instr_2_2b & predec_instr_3_2b & predec_instr_4_2b & predec_instr_5_2b & predec_instr_6_2b & predec_instr_7_4b;
assign predec_case[36]	 = predec_left_buf_2b & predec_instr_0_4b & predec_instr_2_2b & predec_instr_3_2b & predec_instr_4_2b & predec_instr_5_2b & predec_instr_6_4b;
assign predec_case[37]	 = predec_left_buf_2b & predec_instr_0_4b & predec_instr_2_2b & predec_instr_3_2b & predec_instr_4_2b & predec_instr_5_4b & predec_instr_7_2b;
assign predec_case[38]	 = predec_left_buf_2b & predec_instr_0_4b & predec_instr_2_2b & predec_instr_3_2b & predec_instr_4_2b & predec_instr_5_4b & predec_instr_7_4b;
assign predec_case[39]	 = predec_left_buf_2b & predec_instr_0_4b & predec_instr_2_2b & predec_instr_3_2b & predec_instr_4_4b & predec_instr_6_2b & predec_instr_7_2b;
assign predec_case[40]	 = predec_left_buf_2b & predec_instr_0_4b & predec_instr_2_2b & predec_instr_3_2b & predec_instr_4_4b & predec_instr_6_2b & predec_instr_7_4b;
assign predec_case[41]	 = predec_left_buf_2b & predec_instr_0_4b & predec_instr_2_2b & predec_instr_3_2b & predec_instr_4_4b & predec_instr_6_4b;
assign predec_case[42]	 = predec_left_buf_2b & predec_instr_0_4b & predec_instr_2_2b & predec_instr_3_4b & predec_instr_5_2b & predec_instr_6_2b & predec_instr_7_2b;
assign predec_case[43]	 = predec_left_buf_2b & predec_instr_0_4b & predec_instr_2_2b & predec_instr_3_4b & predec_instr_5_2b & predec_instr_6_2b & predec_instr_7_4b;
assign predec_case[44]	 = predec_left_buf_2b & predec_instr_0_4b & predec_instr_2_2b & predec_instr_3_4b & predec_instr_5_2b & predec_instr_6_4b;
assign predec_case[45]	 = predec_left_buf_2b & predec_instr_0_4b & predec_instr_2_2b & predec_instr_3_4b & predec_instr_5_4b & predec_instr_7_2b;
assign predec_case[46]	 = predec_left_buf_2b & predec_instr_0_4b & predec_instr_2_2b & predec_instr_3_4b & predec_instr_5_4b & predec_instr_7_4b;
assign predec_case[47]	 = predec_left_buf_2b & predec_instr_0_4b & predec_instr_2_4b & predec_instr_4_2b & predec_instr_5_2b & predec_instr_6_2b & predec_instr_7_2b;
assign predec_case[48]	 = predec_left_buf_2b & predec_instr_0_4b & predec_instr_2_4b & predec_instr_4_2b & predec_instr_5_2b & predec_instr_6_2b & predec_instr_7_4b;
assign predec_case[49]	 = predec_left_buf_2b & predec_instr_0_4b & predec_instr_2_4b & predec_instr_4_2b & predec_instr_5_2b & predec_instr_6_4b;
assign predec_case[50]	 = predec_left_buf_2b & predec_instr_0_4b & predec_instr_2_4b & predec_instr_4_2b & predec_instr_5_4b & predec_instr_7_2b;
assign predec_case[51]	 = predec_left_buf_2b & predec_instr_0_4b & predec_instr_2_4b & predec_instr_4_2b & predec_instr_5_4b & predec_instr_7_4b;
assign predec_case[52]	 = predec_left_buf_2b & predec_instr_0_4b & predec_instr_2_4b & predec_instr_4_4b & predec_instr_6_2b & predec_instr_7_2b;
assign predec_case[53]	 = predec_left_buf_2b & predec_instr_0_4b & predec_instr_2_4b & predec_instr_4_4b & predec_instr_6_2b & predec_instr_7_4b;
assign predec_case[54]	 = predec_left_buf_2b & predec_instr_0_4b & predec_instr_2_4b & predec_instr_4_4b & predec_instr_6_4b;
assign predec_case[55]	 = predec_left_buf_4b & predec_instr_1_2b & predec_instr_2_2b & predec_instr_3_2b & predec_instr_4_2b & predec_instr_5_2b & predec_instr_6_2b & predec_instr_7_2b;
assign predec_case[56]	 = predec_left_buf_4b & predec_instr_1_2b & predec_instr_2_2b & predec_instr_3_2b & predec_instr_4_2b & predec_instr_5_2b & predec_instr_6_2b & predec_instr_7_4b;
assign predec_case[57]	 = predec_left_buf_4b & predec_instr_1_2b & predec_instr_2_2b & predec_instr_3_2b & predec_instr_4_2b & predec_instr_5_2b & predec_instr_6_4b;
assign predec_case[58]	 = predec_left_buf_4b & predec_instr_1_2b & predec_instr_2_2b & predec_instr_3_2b & predec_instr_4_2b & predec_instr_5_4b & predec_instr_7_2b;
assign predec_case[59]	 = predec_left_buf_4b & predec_instr_1_2b & predec_instr_2_2b & predec_instr_3_2b & predec_instr_4_2b & predec_instr_5_4b & predec_instr_7_4b;
assign predec_case[60]	 = predec_left_buf_4b & predec_instr_1_2b & predec_instr_2_2b & predec_instr_3_2b & predec_instr_4_4b & predec_instr_6_2b & predec_instr_7_2b;
assign predec_case[61]	 = predec_left_buf_4b & predec_instr_1_2b & predec_instr_2_2b & predec_instr_3_2b & predec_instr_4_4b & predec_instr_6_2b & predec_instr_7_4b;
assign predec_case[62]	 = predec_left_buf_4b & predec_instr_1_2b & predec_instr_2_2b & predec_instr_3_2b & predec_instr_4_4b & predec_instr_6_4b;
assign predec_case[63]	 = predec_left_buf_4b & predec_instr_1_2b & predec_instr_2_2b & predec_instr_3_4b & predec_instr_5_2b & predec_instr_6_2b & predec_instr_7_2b;
assign predec_case[64]	 = predec_left_buf_4b & predec_instr_1_2b & predec_instr_2_2b & predec_instr_3_4b & predec_instr_5_2b & predec_instr_6_2b & predec_instr_7_4b;
assign predec_case[65]	 = predec_left_buf_4b & predec_instr_1_2b & predec_instr_2_2b & predec_instr_3_4b & predec_instr_5_2b & predec_instr_6_4b;
assign predec_case[66]	 = predec_left_buf_4b & predec_instr_1_2b & predec_instr_2_2b & predec_instr_3_4b & predec_instr_5_4b & predec_instr_7_2b;
assign predec_case[67]	 = predec_left_buf_4b & predec_instr_1_2b & predec_instr_2_2b & predec_instr_3_4b & predec_instr_5_4b & predec_instr_7_4b;
assign predec_case[68]	 = predec_left_buf_4b & predec_instr_1_2b & predec_instr_2_4b & predec_instr_4_2b & predec_instr_5_2b & predec_instr_6_2b & predec_instr_7_2b;
assign predec_case[69]	 = predec_left_buf_4b & predec_instr_1_2b & predec_instr_2_4b & predec_instr_4_2b & predec_instr_5_2b & predec_instr_6_2b & predec_instr_7_4b;
assign predec_case[70]	 = predec_left_buf_4b & predec_instr_1_2b & predec_instr_2_4b & predec_instr_4_2b & predec_instr_5_2b & predec_instr_6_4b;
assign predec_case[71]	 = predec_left_buf_4b & predec_instr_1_2b & predec_instr_2_4b & predec_instr_4_2b & predec_instr_5_4b & predec_instr_7_2b;
assign predec_case[72]	 = predec_left_buf_4b & predec_instr_1_2b & predec_instr_2_4b & predec_instr_4_2b & predec_instr_5_4b & predec_instr_7_4b;
assign predec_case[73]	 = predec_left_buf_4b & predec_instr_1_2b & predec_instr_2_4b & predec_instr_4_4b & predec_instr_6_2b & predec_instr_7_2b;
assign predec_case[74]	 = predec_left_buf_4b & predec_instr_1_2b & predec_instr_2_4b & predec_instr_4_4b & predec_instr_6_2b & predec_instr_7_4b;
assign predec_case[75]	 = predec_left_buf_4b & predec_instr_1_2b & predec_instr_2_4b & predec_instr_4_4b & predec_instr_6_4b;
assign predec_case[76]	 = predec_left_buf_4b & predec_instr_1_4b & predec_instr_3_2b & predec_instr_4_2b & predec_instr_5_2b & predec_instr_6_2b & predec_instr_7_2b;
assign predec_case[77]	 = predec_left_buf_4b & predec_instr_1_4b & predec_instr_3_2b & predec_instr_4_2b & predec_instr_5_2b & predec_instr_6_2b & predec_instr_7_4b;
assign predec_case[78]	 = predec_left_buf_4b & predec_instr_1_4b & predec_instr_3_2b & predec_instr_4_2b & predec_instr_5_2b & predec_instr_6_4b;
assign predec_case[79]	 = predec_left_buf_4b & predec_instr_1_4b & predec_instr_3_2b & predec_instr_4_2b & predec_instr_5_4b & predec_instr_7_2b;
assign predec_case[80]	 = predec_left_buf_4b & predec_instr_1_4b & predec_instr_3_2b & predec_instr_4_2b & predec_instr_5_4b & predec_instr_7_4b;
assign predec_case[81]	 = predec_left_buf_4b & predec_instr_1_4b & predec_instr_3_2b & predec_instr_4_4b & predec_instr_6_2b & predec_instr_7_2b;
assign predec_case[82]	 = predec_left_buf_4b & predec_instr_1_4b & predec_instr_3_2b & predec_instr_4_4b & predec_instr_6_2b & predec_instr_7_4b;
assign predec_case[83]	 = predec_left_buf_4b & predec_instr_1_4b & predec_instr_3_2b & predec_instr_4_4b & predec_instr_6_4b;
assign predec_case[84]	 = predec_left_buf_4b & predec_instr_1_4b & predec_instr_3_4b & predec_instr_5_2b & predec_instr_6_2b & predec_instr_7_2b;
assign predec_case[85]	 = predec_left_buf_4b & predec_instr_1_4b & predec_instr_3_4b & predec_instr_5_2b & predec_instr_6_2b & predec_instr_7_4b;
assign predec_case[86]	 = predec_left_buf_4b & predec_instr_1_4b & predec_instr_3_4b & predec_instr_5_2b & predec_instr_6_4b;
assign predec_case[87]	 = predec_left_buf_4b & predec_instr_1_4b & predec_instr_3_4b & predec_instr_5_4b & predec_instr_7_2b;
assign predec_case[88]	 = predec_left_buf_4b & predec_instr_1_4b & predec_instr_3_4b & predec_instr_5_4b & predec_instr_7_4b;

//
assign predec_cross_instr_nxt = (predec_case[1] | predec_case[4]  | predec_case[6] 
                              | predec_case[9]  | predec_case[12] | predec_case[14] 
                              | predec_case[17] | predec_case[19] | predec_case[22] 
                              | predec_case[25] | predec_case[27] | predec_case[30] 
                              | predec_case[33] | predec_case[35] | predec_case[38] 
                              | predec_case[40] | predec_case[43] | predec_case[46] 
                              | predec_case[48] | predec_case[51] | predec_case[53] 
                              | predec_case[56] | predec_case[59] | predec_case[61] 
                              | predec_case[64] | predec_case[67] | predec_case[69] 
                              | predec_case[72] | predec_case[74] | predec_case[77] 
                              | predec_case[80] | predec_case[82] | predec_case[85] 
                              | predec_case[88]); 

wire predec_need_2cycles_nxt = (predec_buf_flag_r | predec_instr_vld) ?  (~(((i_ifu_predec_addr[3 : 0] == 4'd0) & (predec_case[33] | predec_case[46] | predec_case[51] | predec_case[53] | predec_case[88]))
                         |  ((i_ifu_predec_addr[3 : 0] == 4'd2) & (predec_case[12] | predec_case[17] | predec_case[19] | predec_case[25] | predec_case[27]
                                                                |  predec_case[30] | predec_case[38] | predec_case[40] | predec_case[43] | predec_case[48]
                                                                |  predec_case[67] | predec_case[72] | predec_case[74] | predec_case[80] | predec_case[82] | predec_case[85]))
                         |  ((i_ifu_predec_addr[3 : 0] == 4'd4) & (predec_case[4]  | predec_case[6]  | predec_case[9]  | predec_case[14] | predec_case[22] 
                                                                |  predec_case[38] | predec_case[40] | predec_case[43] | predec_case[48] | predec_case[59] 
                                                                |  predec_case[61] | predec_case[64] | predec_case[69] | predec_case[77]))
                         |  ((i_ifu_predec_addr[3 : 0] == 4'd6) & (predec_case[1]  | predec_case[22] | predec_case[35] | predec_case[56] | predec_case[77]))))
                            : 1'b0;

wire predec_need_2cycles_ena = predec_sta_enter_dec0;
wire predec_need_2cycles_r;

gnrl_dfflr #(
    .DATA_WIDTH   (1),
    .INITIAL_VALUE(0)
) predec_need_2cycles_dfflr (predec_need_2cycles_ena, predec_need_2cycles_nxt, predec_need_2cycles_r, clk, rst_n);

//
wire [15 : 0] predec_offset_0_case_0_vec  = 16'b1010_1010_1010_1010;
wire [15 : 0] predec_offset_0_case_1_vec  = 16'b0010_1010_1010_1010;
wire [15 : 0] predec_offset_0_case_2_vec  = 16'b1000_1010_1010_1010;
wire [15 : 0] predec_offset_0_case_3_vec  = 16'b1010_0010_1010_1010;
wire [15 : 0] predec_offset_0_case_4_vec  = 16'b0010_0010_1010_1010;
wire [15 : 0] predec_offset_0_case_5_vec  = 16'b1010_1000_1010_1010;
wire [15 : 0] predec_offset_0_case_6_vec  = 16'b0010_1000_1010_1010;
wire [15 : 0] predec_offset_0_case_7_vec  = 16'b1000_1000_1010_1010;
wire [15 : 0] predec_offset_0_case_8_vec  = 16'b1010_1010_0010_1010;
wire [15 : 0] predec_offset_0_case_9_vec  = 16'b0010_1010_0010_1010;
wire [15 : 0] predec_offset_0_case_10_vec = 16'b1000_1010_0010_1010;
wire [15 : 0] predec_offset_0_case_11_vec = 16'b1010_0010_0010_1010;
wire [15 : 0] predec_offset_0_case_12_vec = 16'b0010_0010_0010_1010;
wire [15 : 0] predec_offset_0_case_13_vec = 16'b1010_1010_1000_1010;
wire [15 : 0] predec_offset_0_case_14_vec = 16'b0010_1010_1000_1010;
wire [15 : 0] predec_offset_0_case_15_vec = 16'b1000_1010_1000_1010;
wire [15 : 0] predec_offset_0_case_16_vec = 16'b1010_0010_1000_1010;
wire [15 : 0] predec_offset_0_case_17_vec = 16'b0010_0010_1000_1010;
wire [15 : 0] predec_offset_0_case_18_vec = 16'b1010_1000_1000_1010;
wire [15 : 0] predec_offset_0_case_19_vec = 16'b0010_1000_1000_1010;
wire [15 : 0] predec_offset_0_case_20_vec = 16'b1000_1000_1000_1010;
wire [15 : 0] predec_offset_0_case_21_vec = 16'b1010_1010_1010_0010;
wire [15 : 0] predec_offset_0_case_22_vec = 16'b0010_1010_1010_0010;
wire [15 : 0] predec_offset_0_case_23_vec = 16'b1000_1010_1010_0010;
wire [15 : 0] predec_offset_0_case_24_vec = 16'b1010_0010_1010_0010;
wire [15 : 0] predec_offset_0_case_25_vec = 16'b0010_0010_1010_0010;
wire [15 : 0] predec_offset_0_case_26_vec = 16'b1010_1000_1010_0010;
wire [15 : 0] predec_offset_0_case_27_vec = 16'b0010_1000_1010_0010;
wire [15 : 0] predec_offset_0_case_28_vec = 16'b1000_1000_1010_0010;
wire [15 : 0] predec_offset_0_case_29_vec = 16'b1010_1010_0010_0010;
wire [15 : 0] predec_offset_0_case_30_vec = 16'b0010_1010_0010_0010;
wire [15 : 0] predec_offset_0_case_31_vec = 16'b1000_1010_0010_0010;
wire [15 : 0] predec_offset_0_case_32_vec = 16'b1010_0010_0010_0010;
wire [15 : 0] predec_offset_0_case_33_vec = 16'b0010_0010_0010_0010;
wire [15 : 0] predec_offset_0_case_34_vec = 16'b1010_1010_1010_1000;
wire [15 : 0] predec_offset_0_case_35_vec = 16'b0010_1010_1010_1000;
wire [15 : 0] predec_offset_0_case_36_vec = 16'b1000_1010_1010_1000;
wire [15 : 0] predec_offset_0_case_37_vec = 16'b1010_0010_1010_1000;
wire [15 : 0] predec_offset_0_case_38_vec = 16'b0010_0010_1010_1000;
wire [15 : 0] predec_offset_0_case_39_vec = 16'b1010_1000_1010_1000;
wire [15 : 0] predec_offset_0_case_40_vec = 16'b0010_1000_1010_1000;
wire [15 : 0] predec_offset_0_case_41_vec = 16'b1000_1000_1010_1000;
wire [15 : 0] predec_offset_0_case_42_vec = 16'b1010_1010_0010_1000;
wire [15 : 0] predec_offset_0_case_43_vec = 16'b0010_1010_0010_1000;
wire [15 : 0] predec_offset_0_case_44_vec = 16'b1000_1010_0010_1000;
wire [15 : 0] predec_offset_0_case_45_vec = 16'b1010_0010_0010_1000;
wire [15 : 0] predec_offset_0_case_46_vec = 16'b0010_0010_0010_1000;
wire [15 : 0] predec_offset_0_case_47_vec = 16'b1010_1010_1000_1000;
wire [15 : 0] predec_offset_0_case_48_vec = 16'b0010_1010_1000_1000;
wire [15 : 0] predec_offset_0_case_49_vec = 16'b1000_1010_1000_1000;
wire [15 : 0] predec_offset_0_case_50_vec = 16'b1010_0010_1000_1000;
wire [15 : 0] predec_offset_0_case_51_vec = 16'b0010_0010_1000_1000;
wire [15 : 0] predec_offset_0_case_52_vec = 16'b1010_1000_1000_1000;
wire [15 : 0] predec_offset_0_case_53_vec = 16'b0010_1000_1000_1000;
wire [15 : 0] predec_offset_0_case_54_vec = 16'b1000_1000_1000_1000;

wire [15 : 0] predec_offset_0_vec   = ({16{(predec_case[0] | predec_case[55])}} & predec_offset_0_case_0_vec ) 
                                    | ({16{(predec_case[1] | predec_case[56])}} & predec_offset_0_case_1_vec ) 
                                    | ({16{(predec_case[2] | predec_case[57])}} & predec_offset_0_case_2_vec ) 
                                    | ({16{(predec_case[3] | predec_case[58])}} & predec_offset_0_case_3_vec ) 
                                    | ({16{(predec_case[4] | predec_case[59])}} & predec_offset_0_case_4_vec ) 
                                    | ({16{(predec_case[5] | predec_case[60])}} & predec_offset_0_case_5_vec ) 
                                    | ({16{(predec_case[6] | predec_case[61])}} & predec_offset_0_case_6_vec ) 
                                    | ({16{(predec_case[7] | predec_case[62])}} & predec_offset_0_case_7_vec ) 
                                    | ({16{(predec_case[8] | predec_case[63])}} & predec_offset_0_case_8_vec ) 
                                    | ({16{(predec_case[9] | predec_case[64])}} & predec_offset_0_case_9_vec ) 
                                    | ({16{(predec_case[10]| predec_case[65])}} & predec_offset_0_case_10_vec) 
                                    | ({16{(predec_case[11]| predec_case[66])}} & predec_offset_0_case_11_vec) 
                                    | ({16{(predec_case[12]| predec_case[67])}} & predec_offset_0_case_12_vec) 
                                    | ({16{(predec_case[13]| predec_case[68])}} & predec_offset_0_case_13_vec) 
                                    | ({16{(predec_case[14]| predec_case[69])}} & predec_offset_0_case_14_vec) 
                                    | ({16{(predec_case[15]| predec_case[70])}} & predec_offset_0_case_15_vec) 
                                    | ({16{(predec_case[16]| predec_case[71])}} & predec_offset_0_case_16_vec) 
                                    | ({16{(predec_case[17]| predec_case[72])}} & predec_offset_0_case_17_vec) 
                                    | ({16{(predec_case[18]| predec_case[73])}} & predec_offset_0_case_18_vec) 
                                    | ({16{(predec_case[19]| predec_case[74])}} & predec_offset_0_case_19_vec) 
                                    | ({16{(predec_case[20]| predec_case[75])}} & predec_offset_0_case_20_vec) 
                                    | ({16{(predec_case[21]| predec_case[76])}} & predec_offset_0_case_21_vec) 
                                    | ({16{(predec_case[22]| predec_case[77])}} & predec_offset_0_case_22_vec) 
                                    | ({16{(predec_case[23]| predec_case[78])}} & predec_offset_0_case_23_vec) 
                                    | ({16{(predec_case[24]| predec_case[79])}} & predec_offset_0_case_24_vec) 
                                    | ({16{(predec_case[25]| predec_case[80])}} & predec_offset_0_case_25_vec) 
                                    | ({16{(predec_case[26]| predec_case[81])}} & predec_offset_0_case_26_vec) 
                                    | ({16{(predec_case[27]| predec_case[82])}} & predec_offset_0_case_27_vec) 
                                    | ({16{(predec_case[28]| predec_case[83])}} & predec_offset_0_case_28_vec) 
                                    | ({16{(predec_case[29]| predec_case[84])}} & predec_offset_0_case_29_vec) 
                                    | ({16{(predec_case[30]| predec_case[85])}} & predec_offset_0_case_30_vec) 
                                    | ({16{(predec_case[31]| predec_case[86])}} & predec_offset_0_case_31_vec) 
                                    | ({16{(predec_case[32]| predec_case[87])}} & predec_offset_0_case_32_vec) 
                                    | ({16{(predec_case[33]| predec_case[88])}} & predec_offset_0_case_33_vec) 
                                    | ({16{predec_case[34]                   }} & predec_offset_0_case_34_vec) 
                                    | ({16{predec_case[35]                   }}	& predec_offset_0_case_35_vec) 
                                    | ({16{predec_case[36]                   }}	& predec_offset_0_case_36_vec) 
                                    | ({16{predec_case[37]                   }}	& predec_offset_0_case_37_vec) 
                                    | ({16{predec_case[38]                   }}	& predec_offset_0_case_38_vec) 
                                    | ({16{predec_case[39]                   }}	& predec_offset_0_case_39_vec) 
                                    | ({16{predec_case[40]                   }}	& predec_offset_0_case_40_vec) 
                                    | ({16{predec_case[41]                   }}	& predec_offset_0_case_41_vec) 
                                    | ({16{predec_case[42]                   }}	& predec_offset_0_case_42_vec) 
                                    | ({16{predec_case[43]                   }}	& predec_offset_0_case_43_vec) 
                                    | ({16{predec_case[44]                   }}	& predec_offset_0_case_44_vec) 
                                    | ({16{predec_case[45]                   }}	& predec_offset_0_case_45_vec) 
                                    | ({16{predec_case[46]                   }}	& predec_offset_0_case_46_vec) 
                                    | ({16{predec_case[47]                   }}	& predec_offset_0_case_47_vec) 
                                    | ({16{predec_case[48]                   }}	& predec_offset_0_case_48_vec) 
                                    | ({16{predec_case[49]                   }}	& predec_offset_0_case_49_vec) 
                                    | ({16{predec_case[50]                   }}	& predec_offset_0_case_50_vec) 
                                    | ({16{predec_case[51]                   }}	& predec_offset_0_case_51_vec) 
                                    | ({16{predec_case[52]                   }}	& predec_offset_0_case_52_vec) 
                                    | ({16{predec_case[53]                   }}	& predec_offset_0_case_53_vec) 
                                    | ({16{predec_case[54]                   }}	& predec_offset_0_case_54_vec);

wire [15 : 0] predec_offset_2_vec  = {predec_offset_0_vec[15 :  2],  2'd0};
wire [15 : 0] predec_offset_4_vec  = {predec_offset_0_vec[15 :  4],  4'd0};
wire [15 : 0] predec_offset_6_vec  = {predec_offset_0_vec[15 :  6],  6'd0};
wire [15 : 0] predec_offset_8_vec  = {predec_offset_0_vec[15 :  8],  8'd0};
wire [15 : 0] predec_offset_10_vec = {predec_offset_0_vec[15 : 10], 10'd0};
wire [15 : 0] predec_offset_12_vec = {predec_offset_0_vec[15 : 12], 12'd0};
wire [15 : 0] predec_offset_14_vec = {predec_offset_0_vec[15 : 14], 14'd0};

wire [15 : 0] predec_case_vec = ({16{(i_ifu_predec_addr[3 : 0] == 4'd0 )}} & predec_offset_0_vec )
                              | ({16{(i_ifu_predec_addr[3 : 0] == 4'd2 )}} & predec_offset_2_vec )
                              | ({16{(i_ifu_predec_addr[3 : 0] == 4'd4 )}} & predec_offset_4_vec )
                              | ({16{(i_ifu_predec_addr[3 : 0] == 4'd8 )}} & predec_offset_8_vec )
                              | ({16{(i_ifu_predec_addr[3 : 0] == 4'd10)}} & predec_offset_10_vec)
                              | ({16{(i_ifu_predec_addr[3 : 0] == 4'd12)}} & predec_offset_12_vec)
                              | ({16{(i_ifu_predec_addr[3 : 0] == 4'd14)}} & predec_offset_14_vec);


wire [15 : 0] predec_alias_check_vec = (func_vec16(i_bpu_predinfo_bus[`PREDINFO_OFFSET]) & (~predec_case_vec));
wire [15 : 0] predec_match_check_vec = (func_vec16(i_bpu_predinfo_bus[`PREDINFO_OFFSET]) & predec_case_vec);

wire [3 : 0] predec_alias_check_vec_0 = ({4{predec_instr_0_len    & predec_sta_dec0}} & {predec_alias_check_vec[1 : 0], 2'b00  })
                                      | ({4{(~predec_instr_0_len) & predec_sta_dec0}} & {2'b00, predec_alias_check_vec[1 : 0]  })
                                      | ({4{predec_instr_4_len    & predec_sta_dec1}} & {predec_alias_check_vec[9 : 8], 2'b00  })
                                      | ({4{(~predec_instr_4_len) & predec_sta_dec1}} & {2'b00, predec_alias_check_vec[9 : 8]  });
wire [3 : 0] predec_alias_check_vec_1 = ({4{predec_instr_1_len    & predec_sta_dec0}} & {predec_alias_check_vec[3 : 2], 2'b00  })
                                      | ({4{(~predec_instr_1_len) & predec_sta_dec0}} & {2'b00, predec_alias_check_vec[3 : 2]  })
                                      | ({4{predec_instr_5_len    & predec_sta_dec1}} & {predec_alias_check_vec[11 : 10], 2'b00})
                                      | ({4{(~predec_instr_5_len) & predec_sta_dec1}} & {2'b00, predec_alias_check_vec[11 : 10]});
wire [3 : 0] predec_alias_check_vec_2 = ({4{predec_instr_2_len    & predec_sta_dec0}} & {predec_alias_check_vec[5 : 4], 2'b00  })
                                      | ({4{(~predec_instr_2_len) & predec_sta_dec0}} & {2'b00, predec_alias_check_vec[5 : 4]  })
                                      | ({4{predec_instr_6_len    & predec_sta_dec1}} & {predec_alias_check_vec[13 : 12], 2'b00})
                                      | ({4{(~predec_instr_6_len) & predec_sta_dec1}} & {2'b00, predec_alias_check_vec[13 : 12]});
wire [3 : 0] predec_alias_check_vec_3 = ({4{predec_instr_3_len    & predec_sta_dec0}} & {predec_alias_check_vec[7 : 6], 2'b00  })
                                      | ({4{(~predec_instr_3_len) & predec_sta_dec0}} & {2'b00, predec_alias_check_vec[7 : 6]  })
                                      | ({4{predec_instr_7_len    & predec_sta_dec1}} & {predec_alias_check_vec[15 : 14], 2'b00})
                                      | ({4{(~predec_instr_7_len) & predec_sta_dec1}} & {2'b00, predec_alias_check_vec[15 : 14]});

wire [3 : 0] predec_match_check_vec_0 = ({4{predec_instr_0_len    & predec_sta_dec0}} & {predec_match_check_vec[1 : 0], 2'b00  })
                                      | ({4{(~predec_instr_0_len) & predec_sta_dec0}} & {2'b00, predec_match_check_vec[1 : 0]  })
                                      | ({4{predec_instr_4_len    & predec_sta_dec1}} & {predec_match_check_vec[9 : 8], 2'b00  })
                                      | ({4{(~predec_instr_4_len) & predec_sta_dec1}} & {2'b00, predec_match_check_vec[9 : 8]  });
wire [3 : 0] predec_match_check_vec_1 = ({4{predec_instr_1_len    & predec_sta_dec0}} & {predec_match_check_vec[3 : 2], 2'b00  })
                                      | ({4{(~predec_instr_1_len) & predec_sta_dec0}} & {2'b00, predec_match_check_vec[3 : 2]  })
                                      | ({4{predec_instr_5_len    & predec_sta_dec1}} & {predec_match_check_vec[11 : 10], 2'b00})
                                      | ({4{(~predec_instr_5_len) & predec_sta_dec1}} & {2'b00, predec_match_check_vec[11 : 10]});
wire [3 : 0] predec_match_check_vec_2 = ({4{predec_instr_2_len    & predec_sta_dec0}} & {predec_match_check_vec[5 : 4], 2'b00  })
                                      | ({4{(~predec_instr_2_len) & predec_sta_dec0}} & {2'b00, predec_match_check_vec[5 : 4]  })
                                      | ({4{predec_instr_6_len    & predec_sta_dec1}} & {predec_match_check_vec[13 : 12], 2'b00})
                                      | ({4{(~predec_instr_6_len) & predec_sta_dec1}} & {2'b00, predec_match_check_vec[13 : 12]});
wire [3 : 0] predec_match_check_vec_3 = ({4{predec_instr_3_len    & predec_sta_dec0}} & {predec_match_check_vec[7 : 6], 2'b00  })
                                      | ({4{(~predec_instr_3_len) & predec_sta_dec0}} & {2'b00, predec_match_check_vec[7 : 6]  })
                                      | ({4{predec_instr_7_len    & predec_sta_dec1}} & {predec_match_check_vec[15 : 14], 2'b00})
                                      | ({4{(~predec_instr_7_len) & predec_sta_dec1}} & {2'b00, predec_match_check_vec[15 : 14]});



assign o_predec_iq_alias_vec_0 = predec_alias_check_vec_0;
assign o_predec_iq_alias_vec_1 = predec_alias_check_vec_1;
assign o_predec_iq_alias_vec_2 = predec_alias_check_vec_2;
assign o_predec_iq_alias_vec_3 = predec_alias_check_vec_3;

assign o_predec_iq_match_vec_0 = predec_match_check_vec_0;
assign o_predec_iq_match_vec_1 = predec_match_check_vec_1;
assign o_predec_iq_match_vec_2 = predec_match_check_vec_2;
assign o_predec_iq_match_vec_3 = predec_match_check_vec_3;

//
wire predec_instr_0_len = (((|predec_case[88 : 34])) | (~((|predec_case[33 : 0]))));

wire predec_instr_1_len = (((|predec_case[34 : 21]) | (|predec_case[54 : 47]) | (|predec_case[88 : 76])) 
                        | (~((|predec_case[20 : 0]) | (|predec_case[46 : 34]) | (|predec_case[75 : 55]))));

wire predec_instr_2_len = (((|predec_case[20 : 13]) | (|predec_case[33 : 29]) | (|predec_case[46 : 42]) 
                        |   (|predec_case[54 : 52]) | (|predec_case[75 : 68]) | (|predec_case[88 : 84])) 
                        | (~((|predec_case[12 : 0]) | (|predec_case[28 : 21]) | (|predec_case[41 : 34]) 
                        |   (|predec_case[51 : 47]) | (|predec_case[67 : 55]) | (|predec_case[83 : 76]))));

wire predec_instr_3_len = (((|predec_case[12 :  8]) | (|predec_case[20 : 18]) | (|predec_case[28 : 26]) 
                        |   (|predec_case[33 : 32]) | (|predec_case[41 : 39]) | (|predec_case[46 : 45]) 
                        |   (|predec_case[51 : 50]) |   predec_case[54]       | (|predec_case[67 : 63]) 
                        |   (|predec_case[75 : 73]) | (|predec_case[83 : 81]) | (|predec_case[88 : 87])) 
                        | (~((|predec_case[7 :  0]) | (|predec_case[17 : 13]) | (|predec_case[25 : 21]) 
                        |   (|predec_case[31 : 29]) | (|predec_case[38 : 34]) | (|predec_case[44 : 42]) 
                        |   (|predec_case[49 : 47]) | (|predec_case[53 : 52]) | (|predec_case[62 : 55]) 
                        |   (|predec_case[72 : 68]) | (|predec_case[80 : 76]) | (|predec_case[86 : 84]))));

wire predec_instr_4_len = (((|predec_case[7 : 5]) | (|predec_case[12 : 11]) | (|predec_case[17 : 16]) 
                        |     predec_case[20]     | (|predec_case[25 : 24]) |   predec_case[28] 
                        |     predec_case[31]     |   predec_case[33]       | (|predec_case[38 : 37]) 
                        |     predec_case[41]     |   predec_case[44]       |   predec_case[46] 
                        |     predec_case[49]     |   predec_case[51]       |   predec_case[53] 
                        | (|predec_case[62 : 60]) | (|predec_case[67 : 66]) | (|predec_case[72 : 71]) 
                        |     predec_case[75]     | (|predec_case[80 : 79]) | predec_case[83] 
                        |     predec_case[86]     | predec_case[88])
                        | (~((|predec_case[4 : 0])) | (|predec_case[10 : 8]) | (|predec_case[15 : 13]) 
                        | (|predec_case[19 : 18]) | (|predec_case[22 : 21]) | (|predec_case[23 : 21]) 
                        | (|predec_case[27 : 26]) | (|predec_case[30 : 29]) |   predec_case[32] 
                        | (|predec_case[36 : 34]) | (|predec_case[40 : 39]) | (|predec_case[43 : 42]) 
                        |   predec_case[45]       | (|predec_case[48 : 47]) |   predec_case[50] 
                        |   predec_case[52]       | (|predec_case[59 : 55]) | (|predec_case[65 : 63]) 
                        | (|predec_case[70 : 68]) | (|predec_case[74 : 73]) | (|predec_case[78 : 76]) 
                        | (|predec_case[82 : 81]) | (|predec_case[85 : 84]) | predec_case[87]));

wire predec_instr_5_len = (((|predec_case[4 : 3]) |   predec_case[7]        |   predec_case[10] 
                        |     predec_case[12]     |   predec_case[15]       |   predec_case[17] 
                        |     predec_case[19]     |   predec_case[23]       |   predec_case[25] 
                        |     predec_case[27]     |   predec_case[30]       |   predec_case[36] 
                        |     predec_case[38]     |   predec_case[40]       |   predec_case[43] 
                        |     predec_case[48]     | (|predec_case[59 : 58]) |   predec_case[62] 
                        |     predec_case[65]     |   predec_case[67]       |   predec_case[70] 
                        |     predec_case[72]     |   predec_case[74]       |   predec_case[78] 
                        |     predec_case[80]     |   predec_case[82]       |   predec_case[85])
                        | (~((|predec_case[2 : 0])| (|predec_case[6 : 5])   | (|predec_case[9 : 8]) 
                        |     predec_case[11]     | (|predec_case[14 : 13]) |   predec_case[16] 
                        |     predec_case[18]     | (|predec_case[22 : 21]) |   predec_case[24] 
                        |     predec_case[26]     |   predec_case[29]       | (|predec_case[35 : 34]) 
                        |     predec_case[37]     |   predec_case[39]       |   predec_case[42] 
                        |     predec_case[47]     | (|predec_case[57 : 55]) | (|predec_case[61 : 60]) 
                        | (|predec_case[64 : 63]) |   predec_case[66]         | (|predec_case[69 : 68]) 
                        |     predec_case[71]     |   predec_case[73]       | (|predec_case[77 : 76]) 
                        |     predec_case[79]     |   predec_case[81]       |   predec_case[84])));

wire predec_instr_6_len = ((predec_case[2]  |   predec_case[4]        | predec_case[6] 
                        |   predec_case[9]  |   predec_case[14]       | predec_case[22] 
                        |   predec_case[35] |   predec_case[57]       | predec_case[59] 
                        |   predec_case[61] |   predec_case[64]       | predec_case[69] | predec_case[77])
                        |  (~((|predec_case[1 : 0]) | predec_case[3]  | predec_case[5] 
                        |   predec_case[8]  |   predec_case[13]       | predec_case[21] 
                        |   predec_case[34] | (|predec_case[56 : 55]) | predec_case[58] 
                        |   predec_case[60] |   predec_case[63]       | predec_case[68] | predec_case[76])));

wire predec_instr_7_len = ((predec_case[1]   | predec_case[56])
                        |  (~(predec_case[0] | predec_case[55])));


assign o_predec_iq_len[0] = ({1{((i_ifu_predec_addr[3 : 0] == 4'd0 ) & predec_sta_dec0)}} & predec_instr_0_len)
                          | ({1{((i_ifu_predec_addr[3 : 0] == 4'd2 ) & predec_sta_dec0)}} & predec_instr_1_len)
                          | ({1{((i_ifu_predec_addr[3 : 0] == 4'd4 ) & predec_sta_dec0)}} & predec_instr_2_len)
                          | ({1{((i_ifu_predec_addr[3 : 0] == 4'd6 ) & predec_sta_dec0)}} & predec_instr_3_len)
                          | ({1{((i_ifu_predec_addr[3 : 0] == 4'd8 ) & predec_sta_dec0)}} & predec_instr_4_len)
                          | ({1{((i_ifu_predec_addr[3 : 0] == 4'd10) & predec_sta_dec0)}} & predec_instr_5_len)
                          | ({1{((i_ifu_predec_addr[3 : 0] == 4'd12) & predec_sta_dec0)}} & predec_instr_6_len)
                          | ({1{((i_ifu_predec_addr[3 : 0] == 4'd14) & predec_sta_dec0)}} & predec_instr_7_len)
                          | ({1{((i_ifu_predec_addr[3 : 0] == 4'd0 ) & predec_sta_dec1)}} & predec_instr_4_len)
                          | ({1{((i_ifu_predec_addr[3 : 0] == 4'd2 ) & predec_sta_dec1)}} & predec_instr_5_len)
                          | ({1{((i_ifu_predec_addr[3 : 0] == 4'd4 ) & predec_sta_dec1)}} & predec_instr_6_len)
                          | ({1{((i_ifu_predec_addr[3 : 0] == 4'd6 ) & predec_sta_dec1)}} & predec_instr_7_len);
assign o_predec_iq_len[1] = ({1{((i_ifu_predec_addr[3 : 0] == 4'd0 ) & predec_sta_dec0)}} & predec_instr_1_len)
                          | ({1{((i_ifu_predec_addr[3 : 0] == 4'd2 ) & predec_sta_dec0)}} & predec_instr_2_len)
                          | ({1{((i_ifu_predec_addr[3 : 0] == 4'd4 ) & predec_sta_dec0)}} & predec_instr_3_len)
                          | ({1{((i_ifu_predec_addr[3 : 0] == 4'd6 ) & predec_sta_dec0)}} & predec_instr_4_len)
                          | ({1{((i_ifu_predec_addr[3 : 0] == 4'd8 ) & predec_sta_dec0)}} & predec_instr_5_len)
                          | ({1{((i_ifu_predec_addr[3 : 0] == 4'd10) & predec_sta_dec0)}} & predec_instr_6_len)
                          | ({1{((i_ifu_predec_addr[3 : 0] == 4'd12) & predec_sta_dec0)}} & predec_instr_7_len)
                          | ({1{((i_ifu_predec_addr[3 : 0] == 4'd0 ) & predec_sta_dec1)}} & predec_instr_5_len)
                          | ({1{((i_ifu_predec_addr[3 : 0] == 4'd2 ) & predec_sta_dec1)}} & predec_instr_6_len)
                          | ({1{((i_ifu_predec_addr[3 : 0] == 4'd4 ) & predec_sta_dec1)}} & predec_instr_7_len);
assign o_predec_iq_len[2] = ({1{((i_ifu_predec_addr[3 : 0] == 4'd0 ) & predec_sta_dec0)}} & predec_instr_2_len)
                          | ({1{((i_ifu_predec_addr[3 : 0] == 4'd2 ) & predec_sta_dec0)}} & predec_instr_3_len)
                          | ({1{((i_ifu_predec_addr[3 : 0] == 4'd4 ) & predec_sta_dec0)}} & predec_instr_4_len)
                          | ({1{((i_ifu_predec_addr[3 : 0] == 4'd6 ) & predec_sta_dec0)}} & predec_instr_5_len)
                          | ({1{((i_ifu_predec_addr[3 : 0] == 4'd8 ) & predec_sta_dec0)}} & predec_instr_6_len)
                          | ({1{((i_ifu_predec_addr[3 : 0] == 4'd10) & predec_sta_dec0)}} & predec_instr_7_len)
                          | ({1{((i_ifu_predec_addr[3 : 0] == 4'd0 ) & predec_sta_dec1)}} & predec_instr_6_len)
                          | ({1{((i_ifu_predec_addr[3 : 0] == 4'd2 ) & predec_sta_dec1)}} & predec_instr_7_len);
assign o_predec_iq_len[3] = ({1{((i_ifu_predec_addr[3 : 0] == 4'd0 ) & predec_sta_dec0)}} & predec_instr_3_len)
                          | ({1{((i_ifu_predec_addr[3 : 0] == 4'd2 ) & predec_sta_dec0)}} & predec_instr_4_len)
                          | ({1{((i_ifu_predec_addr[3 : 0] == 4'd4 ) & predec_sta_dec0)}} & predec_instr_5_len)
                          | ({1{((i_ifu_predec_addr[3 : 0] == 4'd6 ) & predec_sta_dec0)}} & predec_instr_6_len)
                          | ({1{((i_ifu_predec_addr[3 : 0] == 4'd8 ) & predec_sta_dec0)}} & predec_instr_7_len)
                          | ({1{((i_ifu_predec_addr[3 : 0] == 4'd0 ) & predec_sta_dec1)}} & predec_instr_7_len);

//
wire predec_iq_instr_7_scheme_0 = (predec_case[0] | predec_case[55]);
wire [`INSTR_WIDTH - 1 : 0] predec_iq_instr_7 = ({`INSTR_WIDTH{predec_iq_instr_7_scheme_0}} & {16'h0, predec_instr_7});

wire predec_iq_instr_6_scheme_0 = (predec_iq_instr_7_scheme_0 | predec_case[1] | predec_case[56]);
wire predec_iq_instr_6_scheme_1 = (predec_case[3] | predec_case[5] | predec_case[8]
                                |  predec_case[13]| predec_case[21]| predec_case[34]
                                |  predec_case[58]| predec_case[60]| predec_case[63] 
                                |  predec_case[68]| predec_case[76]);
wire predec_iq_instr_6_scheme_2 = (predec_case[2] | predec_case[57]);
wire [`INSTR_WIDTH - 1 : 0] predec_iq_instr_6 = ({`INSTR_WIDTH{predec_iq_instr_6_scheme_0}} & {16'b0,          predec_instr_6})
                                              | ({`INSTR_WIDTH{predec_iq_instr_6_scheme_1}} & {16'h0,          predec_instr_7})
                                              | ({`INSTR_WIDTH{predec_iq_instr_6_scheme_2}} & {predec_instr_7, predec_instr_6});

wire predec_iq_instr_5_scheme_0 = (predec_iq_instr_6_scheme_0 | predec_case[2] | predec_case[57]);
wire predec_iq_instr_5_scheme_1 = (((~predec_case[3]) & predec_iq_instr_6_scheme_1) | predec_case[6] | predec_case[9]
                                |  predec_case[14] | predec_case[22] | predec_case[35] | predec_case[61]
                                |  predec_case[64] | predec_case[69] | predec_case[77]);
wire predec_iq_instr_5_scheme_2 = (predec_case[11] | predec_case[16] | predec_case[18]
                                |  predec_case[24] | predec_case[26] | predec_case[29]
                                |  predec_case[37] | predec_case[39] | predec_case[42]
                                |  predec_case[47] | predec_case[66] | predec_case[71]
                                |  predec_case[73] | predec_case[79] | predec_case[81] | predec_case[84]);
wire predec_iq_instr_5_scheme_3 = (predec_case[3] | predec_case[4] | predec_case[58] | predec_case[59]);
wire predec_iq_instr_5_scheme_4 = (predec_case[7] | predec_case[10]| predec_case[15] 
                                |  predec_case[23]| predec_case[36]| predec_case[62]
                                |  predec_case[65]| predec_case[70]| predec_case[78]);
wire [`INSTR_WIDTH - 1 : 0] predec_iq_instr_5 = ({`INSTR_WIDTH{predec_iq_instr_5_scheme_0}} & {16'h0,          predec_instr_5})
                                              | ({`INSTR_WIDTH{predec_iq_instr_5_scheme_1}} & {16'h0,          predec_instr_6})
                                              | ({`INSTR_WIDTH{predec_iq_instr_5_scheme_2}} & {16'h0,          predec_instr_7})
                                              | ({`INSTR_WIDTH{predec_iq_instr_5_scheme_3}} & {predec_instr_6, predec_instr_5})
                                              | ({`INSTR_WIDTH{predec_iq_instr_5_scheme_4}} & {predec_instr_7, predec_instr_6});

wire predec_iq_instr_4_scheme_0 = (predec_iq_instr_5_scheme_0 | predec_case[3] | predec_case[4] | predec_case[58] | predec_case[59]);
wire predec_iq_instr_4_scheme_1 = (predec_case[8] | predec_case[9] | predec_case[10]
                                |  predec_case[13]| predec_case[14]| predec_case[15]
                                |  predec_case[21]| predec_case[22]| predec_case[23]
                                |  predec_case[34]| predec_case[35]| predec_case[36]
                                |  predec_case[63]| predec_case[64]| predec_case[65]
                                |  predec_case[68]| predec_case[68]| predec_case[69]
                                |  predec_case[70]| predec_case[76]| predec_case[77] | predec_case[78]);
wire predec_iq_instr_4_scheme_2 = (predec_case[18] | predec_case[19] | predec_case[26]
                                |  predec_case[27] | predec_case[29] | predec_case[30]
                                |  predec_case[39] | predec_case[40] | predec_case[42]
                                |  predec_case[43] | predec_case[47] | predec_case[48]
                                |  predec_case[73] | predec_case[74] | predec_case[81]
                                |  predec_case[82] | predec_case[84] | predec_case[85]);
wire predec_iq_instr_4_scheme_3 = (predec_case[32] | predec_case[45] | predec_case[50] | predec_case[52] | predec_case[87]);
wire predec_iq_instr_4_scheme_4 = (predec_case[5] | predec_case[6] | predec_case[7] | predec_case[60] | predec_case[61] | predec_case[62]);
wire predec_iq_instr_4_scheme_5 = (predec_case[11] | predec_case[12] | predec_case[16]
                                |  predec_case[17] | predec_case[24] | predec_case[25]
                                |  predec_case[37] | predec_case[38] | predec_case[66]
                                |  predec_case[67] | predec_case[71] | predec_case[72]
                                |  predec_case[79] | predec_case[80]);
wire predec_iq_instr_4_scheme_6 = (predec_case[20] | predec_case[28] | predec_case[31]
                                |  predec_case[41] | predec_case[44] | predec_case[49]
                                |  predec_case[75] | predec_case[83] | predec_case[86]);
wire [`INSTR_WIDTH - 1 : 0] predec_iq_instr_4 = ({`INSTR_WIDTH{predec_iq_instr_4_scheme_0}} & {16'h0,          predec_instr_4})
                                              | ({`INSTR_WIDTH{predec_iq_instr_4_scheme_1}} & {16'h0,          predec_instr_5})
                                              | ({`INSTR_WIDTH{predec_iq_instr_4_scheme_2}} & {16'h0,          predec_instr_6})
                                              | ({`INSTR_WIDTH{predec_iq_instr_4_scheme_3}} & {16'h0,          predec_instr_7})
                                              | ({`INSTR_WIDTH{predec_iq_instr_4_scheme_4}} & {predec_instr_5, predec_instr_4})
                                              | ({`INSTR_WIDTH{predec_iq_instr_4_scheme_5}} & {predec_instr_6, predec_instr_5})
                                              | ({`INSTR_WIDTH{predec_iq_instr_4_scheme_6}} & {predec_instr_7, predec_instr_6});

wire predec_iq_instr_3_scheme_0 = ((|predec_case[7 : 0]) | (|predec_case[62 : 55]));
wire predec_iq_instr_3_scheme_1 = ((|predec_case[25 : 13]) | (|predec_case[38 : 34]) | (|predec_case[72 : 68]) | (|predec_case[80 : 76]));
wire predec_iq_instr_3_scheme_2 = ((|predec_case[31 : 29]) | (|predec_case[44 : 42]) | (|predec_case[49 : 47]) | (|predec_case[86 : 84]));
wire predec_iq_instr_3_scheme_3 = (predec_case[52] | predec_case[53]);
wire predec_iq_instr_3_scheme_4 = ((|predec_case[12 : 8]) | (|predec_case[67 : 63]));
wire predec_iq_instr_3_scheme_5 = ((|predec_case[20 : 18]) | (|predec_case[28 : 26]) | (|predec_case[41 : 39]) | (|predec_case[75 : 73]) | (|predec_case[83 : 81]));
wire predec_iq_instr_3_scheme_6 = (predec_case[32] | predec_case[33] | predec_case[45] | predec_case[46] | predec_case[50] | predec_case[51] | predec_case[87] | predec_case[88]);
wire predec_iq_instr_3_scheme_7 = (predec_case[54]);
wire [`INSTR_WIDTH - 1 : 0] predec_iq_instr_3 = ({`INSTR_WIDTH{predec_iq_instr_3_scheme_0}} & {16'h0,          predec_instr_3})
                                              | ({`INSTR_WIDTH{predec_iq_instr_3_scheme_1}} & {16'h0,          predec_instr_4})
                                              | ({`INSTR_WIDTH{predec_iq_instr_3_scheme_2}} & {16'h0,          predec_instr_5})
                                              | ({`INSTR_WIDTH{predec_iq_instr_3_scheme_3}} & {16'h0,          predec_instr_6})
                                              | ({`INSTR_WIDTH{predec_iq_instr_3_scheme_4}} & {predec_instr_4, predec_instr_3})
                                              | ({`INSTR_WIDTH{predec_iq_instr_3_scheme_5}} & {predec_instr_5, predec_instr_4})
                                              | ({`INSTR_WIDTH{predec_iq_instr_3_scheme_6}} & {predec_instr_6, predec_instr_5})
                                              | ({`INSTR_WIDTH{predec_iq_instr_3_scheme_7}} & {predec_instr_7, predec_instr_6});

wire predec_iq_instr_2_scheme_0 = ((|predec_case[12 : 0]) | (|predec_case[67 : 55]));
wire predec_iq_instr_2_scheme_1 = ((|predec_case[28 : 21])| (|predec_case[41 : 34]) | (|predec_case[83 : 76]));
wire predec_iq_instr_2_scheme_2 = ((|predec_case[51 : 47]));
wire predce_iq_instr_2_scheme_3 = ((|predec_case[20 : 13]) | (|predec_case[75 : 68]));
wire predec_iq_instr_2_scheme_4 = ((|predec_case[33 : 29]) | (|predec_case[46 : 42]) | (|predec_case[88 : 84]));
wire predec_iq_instr_2_scheme_5 = (|predec_case[54 : 52]);
wire [`INSTR_WIDTH - 1 : 0] predec_iq_instr_2 = ({`INSTR_WIDTH{predec_iq_instr_2_scheme_0}} & {16'h0,          predec_instr_2})
                                              | ({`INSTR_WIDTH{predec_iq_instr_2_scheme_1}} & {16'h0,          predec_instr_3})
                                              | ({`INSTR_WIDTH{predec_iq_instr_2_scheme_2}} & {16'h0,          predec_instr_4})
                                              | ({`INSTR_WIDTH{predce_iq_instr_2_scheme_3}} & {predec_instr_3, predec_instr_2})
                                              | ({`INSTR_WIDTH{predec_iq_instr_2_scheme_4}} & {predec_instr_4, predec_instr_3})
                                              | ({`INSTR_WIDTH{predec_iq_instr_2_scheme_5}} & {predec_instr_5, predec_instr_4});

wire predec_iq_instr_1_scheme_0 = (predec_iq_instr_2_scheme_0 | (|predec_case[20 : 13]) | (|predec_case[75 : 68]));
wire predec_iq_instr_1_scheme_1 = (|predec_case[46 : 34]);
wire predec_iq_instr_1_scheme_2 = ((|predec_case[33 : 21]) | (|predec_case[54 : 47]) | (|predec_case[88 : 76]));
wire predec_iq_instr_1_scheme_3 = (|predec_case[54 : 47]);
wire [`INSTR_WIDTH - 1 : 0] predec_iq_instr_1 = ({`INSTR_WIDTH{predec_iq_instr_1_scheme_0}} & {16'h0,          predec_instr_1})
                                              | ({`INSTR_WIDTH{predec_iq_instr_1_scheme_1}} & {16'h0,          predec_instr_2})
                                              | ({`INSTR_WIDTH{predec_iq_instr_1_scheme_2}} & {predec_instr_2, predec_instr_1})
                                              | ({`INSTR_WIDTH{predec_iq_instr_1_scheme_3}} & {predec_instr_3, predec_instr_2});

wire [`INSTR_WIDTH - 1 : 0] predec_iq_instr_0 = ({`INSTR_WIDTH{((predec_case_vec[1 : 0] == 2'b10) & (predec_cross_instr_r)) }} & {predec_instr_0, predec_left_buf_r})
                                              | ({`INSTR_WIDTH{((predec_case_vec[1 : 0] == 2'b10) & (~predec_cross_instr_r))}} & {16'h0,          predec_instr_0   })
                                              | ({`INSTR_WIDTH{((predec_case_vec[1 : 0] == 2'b00) & predec_instr_0_len     )}} & {predec_instr_1, predec_instr_0   });
//

assign o_predec_iq_instr_0 = ({`INSTR_WIDTH{((i_ifu_predec_addr[3 : 0] == 4'd0 ) & predec_sta_dec0)}} & predec_iq_instr_0)
                           | ({`INSTR_WIDTH{((i_ifu_predec_addr[3 : 0] == 4'd2 ) & predec_sta_dec0)}} & predec_iq_instr_1)
                           | ({`INSTR_WIDTH{((i_ifu_predec_addr[3 : 0] == 4'd4 ) & predec_sta_dec0)}} & predec_iq_instr_2)
                           | ({`INSTR_WIDTH{((i_ifu_predec_addr[3 : 0] == 4'd6 ) & predec_sta_dec0)}} & predec_iq_instr_3)
                           | ({`INSTR_WIDTH{((i_ifu_predec_addr[3 : 0] == 4'd8 ) & predec_sta_dec0)}} & predec_iq_instr_4)
                           | ({`INSTR_WIDTH{((i_ifu_predec_addr[3 : 0] == 4'd10) & predec_sta_dec0)}} & predec_iq_instr_5)
                           | ({`INSTR_WIDTH{((i_ifu_predec_addr[3 : 0] == 4'd12) & predec_sta_dec0)}} & predec_iq_instr_6)
                           | ({`INSTR_WIDTH{((i_ifu_predec_addr[3 : 0] == 4'd14) & predec_sta_dec0)}} & predec_iq_instr_7)
                           | ({`INSTR_WIDTH{((i_ifu_predec_addr[3 : 0] == 4'd0 ) & predec_sta_dec1)}} & predec_iq_instr_4)
                           | ({`INSTR_WIDTH{((i_ifu_predec_addr[3 : 0] == 4'd2 ) & predec_sta_dec1)}} & predec_iq_instr_5)
                           | ({`INSTR_WIDTH{((i_ifu_predec_addr[3 : 0] == 4'd4 ) & predec_sta_dec1)}} & predec_iq_instr_6)
                           | ({`INSTR_WIDTH{((i_ifu_predec_addr[3 : 0] == 4'd8 ) & predec_sta_dec1)}} & predec_iq_instr_7);
assign o_predec_iq_instr_1 = ({`INSTR_WIDTH{((i_ifu_predec_addr[3 : 0] == 4'd0 ) & predec_sta_dec0)}} & predec_iq_instr_1)
                           | ({`INSTR_WIDTH{((i_ifu_predec_addr[3 : 0] == 4'd2 ) & predec_sta_dec0)}} & predec_iq_instr_2)
                           | ({`INSTR_WIDTH{((i_ifu_predec_addr[3 : 0] == 4'd4 ) & predec_sta_dec0)}} & predec_iq_instr_3)
                           | ({`INSTR_WIDTH{((i_ifu_predec_addr[3 : 0] == 4'd6 ) & predec_sta_dec0)}} & predec_iq_instr_4)
                           | ({`INSTR_WIDTH{((i_ifu_predec_addr[3 : 0] == 4'd8 ) & predec_sta_dec0)}} & predec_iq_instr_5)
                           | ({`INSTR_WIDTH{((i_ifu_predec_addr[3 : 0] == 4'd10) & predec_sta_dec0)}} & predec_iq_instr_6)
                           | ({`INSTR_WIDTH{((i_ifu_predec_addr[3 : 0] == 4'd12) & predec_sta_dec0)}} & predec_iq_instr_7)
                           | ({`INSTR_WIDTH{((i_ifu_predec_addr[3 : 0] == 4'd0 ) & predec_sta_dec1)}} & predec_iq_instr_5)
                           | ({`INSTR_WIDTH{((i_ifu_predec_addr[3 : 0] == 4'd2 ) & predec_sta_dec1)}} & predec_iq_instr_6)
                           | ({`INSTR_WIDTH{((i_ifu_predec_addr[3 : 0] == 4'd4 ) & predec_sta_dec1)}} & predec_iq_instr_7);
assign o_predec_iq_instr_2 = ({`INSTR_WIDTH{((i_ifu_predec_addr[3 : 0] == 4'd0 ) & predec_sta_dec0)}} & predec_iq_instr_2)
                           | ({`INSTR_WIDTH{((i_ifu_predec_addr[3 : 0] == 4'd2 ) & predec_sta_dec0)}} & predec_iq_instr_3)
                           | ({`INSTR_WIDTH{((i_ifu_predec_addr[3 : 0] == 4'd4 ) & predec_sta_dec0)}} & predec_iq_instr_4)
                           | ({`INSTR_WIDTH{((i_ifu_predec_addr[3 : 0] == 4'd6 ) & predec_sta_dec0)}} & predec_iq_instr_5)
                           | ({`INSTR_WIDTH{((i_ifu_predec_addr[3 : 0] == 4'd8 ) & predec_sta_dec0)}} & predec_iq_instr_6)
                           | ({`INSTR_WIDTH{((i_ifu_predec_addr[3 : 0] == 4'd10) & predec_sta_dec0)}} & predec_iq_instr_7)
                           | ({`INSTR_WIDTH{((i_ifu_predec_addr[3 : 0] == 4'd0 ) & predec_sta_dec1)}} & predec_iq_instr_6)
                           | ({`INSTR_WIDTH{((i_ifu_predec_addr[3 : 0] == 4'd2 ) & predec_sta_dec1)}} & predec_iq_instr_7);
assign o_predec_iq_instr_3 = ({`INSTR_WIDTH{((i_ifu_predec_addr[3 : 0] == 4'd0 ) & predec_sta_dec0)}} & predec_iq_instr_3)
                           | ({`INSTR_WIDTH{((i_ifu_predec_addr[3 : 0] == 4'd2 ) & predec_sta_dec0)}} & predec_iq_instr_4)
                           | ({`INSTR_WIDTH{((i_ifu_predec_addr[3 : 0] == 4'd4 ) & predec_sta_dec0)}} & predec_iq_instr_5)
                           | ({`INSTR_WIDTH{((i_ifu_predec_addr[3 : 0] == 4'd6 ) & predec_sta_dec0)}} & predec_iq_instr_6)
                           | ({`INSTR_WIDTH{((i_ifu_predec_addr[3 : 0] == 4'd8 ) & predec_sta_dec0)}} & predec_iq_instr_7)
                           | ({`INSTR_WIDTH{((i_ifu_predec_addr[3 : 0] == 4'd0 ) & predec_sta_dec1)}} & predec_iq_instr_7);

//


//
assign o_predec_iq_type_0[0] = ((o_predec_iq_instr_0[6 : 0] == 7'b1110011)
                             & ((o_predec_iq_instr_0[14 : 12] != 3'b000) 
                             |  (o_predec_iq_instr_0[14 : 12] != 3'b100)));
assign o_predec_iq_type_0[1] = (((o_predec_iq_instr_0[31 : 25] == 7'b0001001) 
                             &   (o_predec_iq_instr_0[14 : 0] == 15'b000000001110011))
                             |  ((o_predec_iq_instr_0[14 : 13] == 2'b00)
                             &   (o_predec_iq_instr_0[6 : 0] == 7'b0001111)));
assign o_predec_iq_type_0[2] = ((o_predec_iq_instr_0[6 : 0] == 7'b1101111) 
                             | ((o_predec_iq_instr_0[6 : 0] == 7'b1100111)
                             &  (o_predec_iq_instr_0[14 : 12] == 3'b000)
                             &  (o_predec_iq_instr_0[11 : 7] != 5'b00000)));
assign o_predec_iq_type_0[3] = (((o_predec_iq_instr_0[1 : 0] == 2'b01)
                             &   (o_predec_iq_instr_0[14 : 13] == 2'b01))
                             |  ((o_predec_iq_instr_0[6 : 0] == 7'b0000010)
                             &   (o_predec_iq_instr_0[15 : 13] == 3'b100)
                             &   (o_predec_iq_instr_0[11 : 7] != 5'b00000)));
assign o_predec_iq_type_0[4] = ((o_predec_iq_instr_0[6 : 0] == 7'b1100011)
                             &  (o_predec_iq_instr_0[14 : 12] != 3'b010)
                             &  (o_predec_iq_instr_0[14 : 12] != 3'b011));
assign o_predec_iq_type_0[5] = ((o_predec_iq_instr_0[1 : 0] == 2'b01)
                             &  (o_predec_iq_instr_0[15 : 14] == 2'b11)); 


assign o_predec_iq_type_1[0] = ((o_predec_iq_instr_1[6 : 0] == 7'b1110011)
                             & ((o_predec_iq_instr_1[14 : 12] != 3'b000) 
                             |  (o_predec_iq_instr_1[14 : 12] != 3'b100)));
assign o_predec_iq_type_1[1] = (((o_predec_iq_instr_1[31 : 25] == 7'b0001001) 
                             &   (o_predec_iq_instr_1[14 : 0] == 15'b000000001110011))
                             |  ((o_predec_iq_instr_1[14 : 13] == 2'b00)
                             &   (o_predec_iq_instr_1[6 : 0] == 7'b0001111)));
assign o_predec_iq_type_1[2] = ((o_predec_iq_instr_1[6 : 0] == 7'b1101111) 
                             | ((o_predec_iq_instr_1[6 : 0] == 7'b1100111)
                             &  (o_predec_iq_instr_1[14 : 12] == 3'b000)
                             &  (o_predec_iq_instr_1[11 : 7] != 5'b00000)));
assign o_predec_iq_type_1[3] = (((o_predec_iq_instr_1[1 : 0] == 2'b01)
                             &   (o_predec_iq_instr_1[14 : 13] == 2'b01))
                             |  ((o_predec_iq_instr_1[6 : 0] == 7'b0000010)
                             &   (o_predec_iq_instr_1[15 : 13] == 3'b100)
                             &   (o_predec_iq_instr_1[11 : 7] != 5'b00000)));
assign o_predec_iq_type_1[4] = ((o_predec_iq_instr_1[6 : 0] == 7'b1100011)
                             &  (o_predec_iq_instr_1[14 : 12] != 3'b010)
                             &  (o_predec_iq_instr_1[14 : 12] != 3'b011));
assign o_predec_iq_type_1[5] = ((o_predec_iq_instr_1[1 : 0] == 2'b01)
                             &  (o_predec_iq_instr_1[15 : 14] == 2'b11)); 

assign o_predec_iq_type_2[0] = ((o_predec_iq_instr_2[6 : 0] == 7'b1110011)
                             & ((o_predec_iq_instr_2[14 : 12] != 3'b000) 
                             |  (o_predec_iq_instr_2[14 : 12] != 3'b100)));
assign o_predec_iq_type_2[1] = (((o_predec_iq_instr_2[31 : 25] == 7'b0001001) 
                             &   (o_predec_iq_instr_2[14 : 0] == 15'b000000001110011))
                             |  ((o_predec_iq_instr_2[14 : 13] == 2'b00)
                             &   (o_predec_iq_instr_2[6 : 0] == 7'b0001111)));
assign o_predec_iq_type_2[2] = ((o_predec_iq_instr_2[6 : 0] == 7'b1101111) 
                             | ((o_predec_iq_instr_2[6 : 0] == 7'b1100111)
                             &  (o_predec_iq_instr_2[14 : 12] == 3'b000)
                             &  (o_predec_iq_instr_2[11 : 7] != 5'b00000)));
assign o_predec_iq_type_2[3] = (((o_predec_iq_instr_2[1 : 0] == 2'b01)
                             &   (o_predec_iq_instr_2[14 : 13] == 2'b01))
                             |  ((o_predec_iq_instr_2[6 : 0] == 7'b0000010)
                             &   (o_predec_iq_instr_2[15 : 13] == 3'b100)
                             &   (o_predec_iq_instr_2[11 : 7] != 5'b00000)));
assign o_predec_iq_type_2[4] = ((o_predec_iq_instr_2[6 : 0] == 7'b1100011)
                             &  (o_predec_iq_instr_2[14 : 12] != 3'b010)
                             &  (o_predec_iq_instr_2[14 : 12] != 3'b011));
assign o_predec_iq_type_2[5] = ((o_predec_iq_instr_2[1 : 0] == 2'b01)
                             &  (o_predec_iq_instr_2[15 : 14] == 2'b11)); 

assign o_predec_iq_type_3[0] = ((o_predec_iq_instr_3[6 : 0] == 7'b1110011)
                             & ((o_predec_iq_instr_3[14 : 12] != 3'b000) 
                             |  (o_predec_iq_instr_3[14 : 12] != 3'b100)));
assign o_predec_iq_type_3[1] = (((o_predec_iq_instr_3[31 : 25] == 7'b0001001) 
                             &   (o_predec_iq_instr_3[14 : 0] == 15'b000000001110011))
                             |  ((o_predec_iq_instr_3[14 : 13] == 2'b00)
                             &   (o_predec_iq_instr_3[6 : 0] == 7'b0001111)));
assign o_predec_iq_type_3[2] = ((o_predec_iq_instr_3[6 : 0] == 7'b1101111) 
                             | ((o_predec_iq_instr_3[6 : 0] == 7'b1100111)
                             &  (o_predec_iq_instr_3[14 : 12] == 3'b000)
                             &  (o_predec_iq_instr_3[11 : 7] != 5'b00000)));
assign o_predec_iq_type_3[3] = (((o_predec_iq_instr_3[1 : 0] == 2'b01)
                             &   (o_predec_iq_instr_3[14 : 13] == 2'b01))
                             |  ((o_predec_iq_instr_3[6 : 0] == 7'b0000010)
                             &   (o_predec_iq_instr_3[15 : 13] == 3'b100)
                             &   (o_predec_iq_instr_3[11 : 7] != 5'b00000)));
assign o_predec_iq_type_3[4] = ((o_predec_iq_instr_3[6 : 0] == 7'b1100011)
                             &  (o_predec_iq_instr_3[14 : 12] != 3'b010)
                             &  (o_predec_iq_instr_3[14 : 12] != 3'b011));
assign o_predec_iq_type_3[5] = ((o_predec_iq_instr_3[1 : 0] == 2'b01)
                             &  (o_predec_iq_instr_3[15 : 14] == 2'b11)); 
//
assign o_predec_iq_addr_0 = i_ifu_predec_addr  - (predec_cross_instr_r ? `CORE_PC_WIDTH'd2 : `CORE_PC_WIDTH'd0);
assign o_predec_iq_addr_1 = o_predec_iq_addr_0 + (o_predec_iq_len[0]   ? `CORE_PC_WIDTH'd4 : `CORE_PC_WIDTH'd2);
assign o_predec_iq_addr_2 = o_predec_iq_addr_1 + (o_predec_iq_len[1]   ? `CORE_PC_WIDTH'd4 : `CORE_PC_WIDTH'd2);
assign o_predec_iq_addr_3 = o_predec_iq_addr_2 + (o_predec_iq_len[2]   ? `CORE_PC_WIDTH'd4 : `CORE_PC_WIDTH'd2);

//
wire predec_bpu_pred_update = ((i_iq_bpu_vld & (i_iq_bpu_type == 1'b1) & (~i_iq_alias_err))
                            &  (i_iq_bpu_btb_addr[31 : 4] == i_bpu_predinfo_bus[`PREDINFO_ADDR])
                            &  (i_iq_bpu_btb_addr[3 : 0] >= i_bpu_predinfo_bus[`PREDINFO_OFFSET]));
wire [`PREDINFO_WIDTH - 1 : 0] predec_updated_predinfo;
assign predec_updated_predinfo = {
                                    i_iq_bpu_new_br 
                                ,   i_iq_bpu_taken 
                                ,   i_iq_bpu_btb_addr[`CORE_PC_WIDTH - 1 : 4] 
                                ,   i_bpu_predinfo_bus[`PREDINFO_OFFSET] 
                                ,   i_iq_bpu_btb_taddr 
                                ,   i_iq_bpu_type      
                                ,   i_iq_bpu_btb_idx   
                                ,   i_iq_bpu_pht_idx   
                                ,   i_iq_bpu_pht_entry 
                               };


assign o_predec_iq_predinfo_bus = ({`PREDINFO_WIDTH{predec_bpu_pred_update   }} & predec_updated_predinfo)
                                | ({`PREDINFO_WIDTH{(~predec_bpu_pred_update)}} & i_bpu_predinfo_bus     );

//
assign o_predec_icache_16byte_done = (predec_buf_flag_r & predec_last_cycle);
assign o_predec_icache_64byte_done = (o_predec_icache_16byte_done & (predec_cnt_r == 3'd1));


//
assign o_predec_iq_excp_code = i_cache_predec_excp_code;


//  Functions
function [15 : 0] func_vec16;
    input [3 : 0] index;
    case (index)
        4'b0000: func_vec16 = 16'b0000000000000001;
        4'b0001: func_vec16 = 16'b0000000000000010;
        4'b0010: func_vec16 = 16'b0000000000000100;
        4'b0011: func_vec16 = 16'b0000000000001000;
        4'b0100: func_vec16 = 16'b0000000000010000;
        4'b0101: func_vec16 = 16'b0000000000100000;
        4'b0110: func_vec16 = 16'b0000000001000000;
        4'b0111: func_vec16 = 16'b0000000010000000;
        4'b1000: func_vec16 = 16'b0000000100000000;
        4'b1001: func_vec16 = 16'b0000001000000000;
        4'b1010: func_vec16 = 16'b0000010000000000;
        4'b1011: func_vec16 = 16'b0000100000000000;
        4'b1100: func_vec16 = 16'b0001000000000000;
        4'b1101: func_vec16 = 16'b0010000000000000;
        4'b1110: func_vec16 = 16'b0100000000000000;
        4'b1111: func_vec16 = 16'b1000000000000000;
        default: begin
            func_vec16 = 16'b0000000000000000;
        end
    endcase
endfunction

endmodule   //  predecoder_module

`endif  /*  !__PREDECODER_PREDECODER_V__!   */