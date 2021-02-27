`ifdef __BPU_BPU_V__

module bpu_module ( 
    input                                               i_csr_trap_flush,
    input                                               i_exu_mis_flush,
    input                                               i_exu_ls_flush,
    
    input                                               i_ifu_bpu_vld,
    input   [`CORE_PC_WIDTH - 1         : 0]            i_ifu_bpu_pc_addr,
    input                                               i_predec_icache_done,
    input                                               i_iq_bpu_vld,
    input                                               i_iq_bpu_taken,
    input                                               i_iq_bpu_new_br,
    input                                               i_iq_bpu_btb_type,
    input   [`CORE_PC_WIDTH - 1         : 0]            i_iq_bpu_btb_addr,
    input   [`CORE_PC_WIDTH - 1         : 0]            i_iq_bpu_btb_taddr,
    input   [`BTB_IDX_WIDTH - 1         : 0]            i_iq_bpu_btb_idx,
    input   [1                          : 0]            i_iq_bpu_pht_entry,
    input   [`PHT_IDX_WIDTH - 1         : 0]            i_iq_bpu_pht_idx,
    input                                               i_iq_bpu_alias_err,
    input                                               i_iq_bpu_tsucc,
    
    output                                              o_bpu_flush,
    output  [`CORE_PC_WIDTH  - 1        : 0]            o_bpu_pc_addr,
    output  [`BPU_PRED_INFO_WIDTH - 1   : 0]            o_bpu_predec_predinfo_bus,
    
    input                                               clk,
    input                                               rst_n
);

wire bpu_need_flush = (i_csr_trap_flush | i_exu_mis_flush | i_exu_ls_flush);

wire bpu_btb_clr_ena    = (i_iq_bpu_vld) & (~i_iq_bpu_new_br) & (i_iq_bpu_alias_err);
wire bpu_btb_new_br_ena = (i_iq_bpu_vld) & (i_iq_bpu_new_br);
wire bpu_btb_mispred_ena= (i_iq_bpu_vld) & (~i_iq_bpu_new_br) & (i_iq_bpu_tsucc) & (~i_iq_bpu_alias_err);
wire bpu_gs_update_ena  = (i_iq_bpu_vld) & (~i_iq_bpu_new_br) & (i_iq_bpu_tsucc) & (~i_iq_bpu_alias_err);

/******************* GSHARE **********************/
wire i_bpu_gs_wren = ((~bpu_need_flush) & bpu_gs_update_ena);
wire o_bpu_gs_pred_taken;
wire [1 : 0] o_bpu_gs_pht_entry;
wire [`GHR_PHT_IDX_WIDTH - 1 : 0] o_bpu_gs_pht_idx;

bpu_gshare_module gshare ( 
    .i_gs_pc_addr         (i_ifu_bpu_pc_addr),
    .o_gs_pred_taken      (o_bpu_gs_pred_taken),
    .o_gs_pht_entry       (o_bpu_gs_pht_entry),
    .o_gs_pht_idx         (o_bpu_gs_pht_idx),
    .i_gs_wren            (i_bpu_gs_wren),
    .i_gs_tsucc           (i_iq_bpu_tsucc),
    .i_gs_update_pht_idx  (i_iq_bpu_pht_idx),
    .i_gs_update_pht_entry(i_iq_bpu_pht_entry),
    .clk                  (clk),
    .rst_n                (rst_n)
);

/********************* BTB *************************/
wire i_bpu_btb_rden = ((~bpu_need_flush) & (i_ifu_bpu_vld | i_predec_icache_done));
wire o_bpu_btb_match;
wire [`BTB_IDX_WIDTH - 1 : 0] o_bpu_btb_idx;
wire [`CORE_PC_WIDTH - 1 : 0] o_bpu_btb_taddr;
wire [3 : 0] o_bpu_btb_offset;
wire o_bpu_btb_type;

wire i_bpu_btb_clr_ena = bpu_btb_clr_ena;
wire i_bpu_btb_mis_ena = bpu_btb_mispred_ena;
wire i_bpu_btb_new_br_ena = bpu_btb_new_br_ena;

btb_module btb ( 
    .i_btb_rden       (i_bpu_btb_rden),
    .i_btb_pc_addr    (i_ifu_bpu_pc_addr),
    .o_btb_match      (o_bpu_btb_match),
    .o_btb_idx        (o_bpu_btb_idx),
    .o_btb_taddr      (o_bpu_btb_taddr),
    .o_btb_offset     (o_bpu_btb_offset),
    .o_btb_type       (o_bpu_btb_type),
    .i_btb_clr        (i_bpu_btb_clr_ena),
    .i_btb_clr_idx    (i_iq_bpu_btb_idx),
    .i_btb_mispred    (i_bpu_btb_mis_ena),
    .i_btb_mis_idx    (i_iq_bpu_btb_idx),
    .i_btb_mis_taddr  (i_iq_bpu_btb_taddr),
    .i_btb_new_br     (i_bpu_btb_new_br_ena),
    .i_btb_new_pc_addr(i_iq_bpu_btb_addr),
    .i_btb_new_taddr  (i_iq_bpu_btb_taddr),
    .i_btb_new_type   (i_iq_bpu_btb_type),
    .clk              (clk),
    .rst_n            (rst_n)
);

//
assign o_bpu_flush  = (o_bpu_btb_match
                    & (i_ifu_bpu_pc_addr[3 : 0] <= o_bpu_btb_offset)
                    & ((~o_bpu_btb_type) | (o_bpu_btb_type & o_bpu_gs_pred_taken))
                    & (i_ifu_bpu_vld));
assign o_bpu_pc_addr = o_bpu_btb_taddr;
assign o_bpu_predec_predinfo_bus = {
                                        o_bpu_btb_match
                                    ,    o_bpu_flush
                                    ,    i_ifu_bpu_pc_addr[`CORE_PC_WIDTH - 1 : 4]
                                    ,    o_bpu_btb_offset
                                    ,    o_bpu_btb_type
                                    ,    o_bpu_btb_taddr
                                    ,    o_bpu_btb_idx
                                    ,    o_bpu_gs_pht_idx
                                    ,    o_bpu_gs_pht_entry
                                    ,    (o_bpu_btb_type & o_bpu_gs_pred_taken)
                                 };

endmodule   //  bpu_module

`endif  /*  !__BPU_BPU_V__! */