`ifdef __DISPATCH_DSP_TOP_V__

module dsp_top_module (
    input                                       i_csr_trap_flush,
    input                                       i_exu_mis_flush,
    input   [`ROB_ID_WIDTH - 1          : 0]    i_exu_mis_rob_id,
    input                                       i_exu_ls_flush,
    input   [`ROB_ID_WIDTH - 1          : 0]    i_exu_ls_rob_id,

    input   [3                          : 0]    i_dec_dsp_vld,
    input                                       i_dec_dsp_src1_vld_0,
    input   [`PRF_CODE_WIDTH - 1        : 0]    i_dec_dsp_src1_prf_code_0,
    input                                       i_dec_dsp_src2_vld_0,
    input   [`PRF_CODE_WIDTH - 1        : 0]    i_dec_dsp_src2_prf_code_0,
    input                                       i_dec_dsp_src3_vld_0,
    input   [`PRF_CODE_WIDTH - 1        : 0]    i_dec_dsp_src3_prf_code_0,
    input                                       i_dec_dsp_dst_vld_0,
    input   [`PRF_CODE_WIDTH - 1        : 0]    i_dec_dsp_dst_prf_code_0,
    input   [`PRF_CODE_WIDTH - 1        : 0]    i_dec_dsp_dst_pprf_code_0,
    input                                       i_dec_dsp_src1_vld_1,
    input   [`PRF_CODE_WIDTH - 1        : 0]    i_dec_dsp_src1_prf_code_1,
    input                                       i_dec_dsp_src2_vld_1,
    input   [`PRF_CODE_WIDTH - 1        : 0]    i_dec_dsp_src2_prf_code_1,
    input                                       i_dec_dsp_src3_vld_1,
    input   [`PRF_CODE_WIDTH - 1        : 0]    i_dec_dsp_src3_prf_code_1,
    input                                       i_dec_dsp_dst_vld_1,
    input   [`PRF_CODE_WIDTH - 1        : 0]    i_dec_dsp_dst_prf_code_1,
    input   [`PRF_CODE_WIDTH - 1        : 0]    i_dec_dsp_dst_pprf_code_1,
    input                                       i_dec_dsp_src1_vld_2,
    input   [`PRF_CODE_WIDTH - 1        : 0]    i_dec_dsp_src1_prf_code_2,
    input                                       i_dec_dsp_src2_vld_2,
    input   [`PRF_CODE_WIDTH - 1        : 0]    i_dec_dsp_src2_prf_code_2,
    input                                       i_dec_dsp_src3_vld_2,
    input   [`PRF_CODE_WIDTH - 1        : 0]    i_dec_dsp_src3_prf_code_2,
    input                                       i_dec_dsp_dst_vld_2,
    input   [`PRF_CODE_WIDTH - 1        : 0]    i_dec_dsp_dst_prf_code_2,
    input   [`PRF_CODE_WIDTH - 1        : 0]    i_dec_dsp_dst_pprf_code_2,
    input                                       i_dec_dsp_src1_vld_3,
    input   [`PRF_CODE_WIDTH - 1        : 0]    i_dec_dsp_src1_prf_code_3,
    input                                       i_dec_dsp_src2_vld_3,
    input   [`PRF_CODE_WIDTH - 1        : 0]    i_dec_dsp_src2_prf_code_3,
    input                                       i_dec_dsp_src3_vld_3,
    input   [`PRF_CODE_WIDTH - 1        : 0]    i_dec_dsp_src3_prf_code_3,
    input                                       i_dec_dsp_dst_vld_3,
    input   [`PRF_CODE_WIDTH - 1        : 0]    i_dec_dsp_dst_prf_code_3,
    input   [`PRF_CODE_WIDTH - 1        : 0]    i_dec_dsp_dst_pprf_code_3,
    input   [3                          : 0]    i_dec_dsp_len,
    input   [`DECINFO_WIDTH - 1         : 0]    i_dec_dsp_decinfo_bus_0,
    input   [`DECINFO_WIDTH - 1         : 0]    i_dec_dsp_decinfo_bus_1,
    input   [`DECINFO_WIDTH - 1         : 0]    i_dec_dsp_decinfo_bus_2,
    input   [`DECINFO_WIDTH - 1         : 0]    i_dec_dsp_decinfo_bus_3,
    input   [`PREDINFO_WIDTH - 1        : 0]    i_dec_dsp_predinfo_bus_0,
    input   [`PREDINFO_WIDTH - 1        : 0]    i_dec_dsp_predinfo_bus_1,
    input   [`PREDINFO_WIDTH - 1        : 0]    i_dec_dsp_predinfo_bus_2,
    input   [`PREDINFO_WIDTH - 1        : 0]    i_dec_dsp_predinfo_bus_3,
    input   [`INSTR_WIDTH - 1           : 0]    i_dec_dsp_instr_0,
    input   [`INSTR_WIDTH - 1           : 0]    i_dec_dsp_instr_1,
    input   [`INSTR_WIDTH - 1           : 0]    i_dec_dsp_instr_2,
    input   [`INSTR_WIDTH - 1           : 0]    i_dec_dsp_instr_3,
    input   [`CORE_PC_WIDTH - 1         : 0]    i_dec_dsp_addr_0,
    input   [`CORE_PC_WIDTH - 1         : 0]    i_dec_dsp_addr_1,
    input   [`CORE_PC_WIDTH - 1         : 0]    i_dec_dsp_addr_2,
    input   [`CORE_PC_WIDTH - 1         : 0]    i_dec_dsp_addr_3,
    input   [`CORE_PC_WIDTH - 1         : 0]    i_dec_dsp_taddr_0,
    input   [`CORE_PC_WIDTH - 1         : 0]    i_dec_dsp_taddr_1,
    input   [`CORE_PC_WIDTH - 1         : 0]    i_dec_dsp_taddr_2,
    input   [`CORE_PC_WIDTH - 1         : 0]    i_dec_dsp_taddr_3,
    
    input                                       i_rsv_dsp_free_vld_0,
    input   [`RSV_IDX_WIDTH - 1         : 0]    i_rsv_dsp_free_entry_0,
    input                                       i_rsv_dsp_free_vld_1,
    input   [`RSV_IDX_WIDTH - 1         : 0]    i_rsv_dsp_free_entry_1,
    input                                       i_rsv_dsp_free_vld_2,
    input   [`RSV_IDX_WIDTH - 1         : 0]    i_rsv_dsp_free_entry_2,
    input                                       i_rsv_dsp_free_vld_3,
    input   [`RSV_IDX_WIDTH - 1         : 0]    i_rsv_dsp_free_entry_3,

    input                                       i_rob_dsp_mis_ld_vld,
    input   [`LBUFF_ID_WIDTH - 1        : 0]    i_rob_dsp_mis_ld_id,
    input                                       i_rob_dsp_mis_st_vld,
    input   [`SBUFF_ID_WIDTH - 1        : 0]    i_rob_dsp_mis_st_id,
    input   [3                          : 0]    i_rob_dsp_ret_vld,
    input   [`ROB_ID_WIDTH - 1          : 0]    i_rob_dsp_ret_rob_id_0,
    input                                       i_rob_dsp_ret_ld_vld_0,
    input                                       i_rob_dsp_ret_st_vld_0,
    input   [`ROB_ID_WIDTH - 1          : 0]    i_rob_dsp_ret_rob_id_1,
    input                                       i_rob_dsp_ret_ld_vld_1,
    input                                       i_rob_dsp_ret_st_vld_1,
    input   [`ROB_ID_WIDTH - 1          : 0]    i_rob_dsp_ret_rob_id_2,
    input                                       i_rob_dsp_ret_ld_vld_2,
    input                                       i_rob_dsp_ret_st_vld_2,
    input   [`ROB_ID_WIDTH - 1          : 0]    i_rob_dsp_ret_rob_id_3,
    input                                       i_rob_dsp_ret_ld_vld_3,
    input                                       i_rob_dsp_ret_st_vld_3,
    
    input                                       i_exu_dsp_s_ret,
    input                                       i_rob_dsp_sync_csr_ret,
    input                                       i_rob_dsp_sync_fence_ret,
    
    output  [3                          : 0]    o_dsp_rsv_vld,
    output                                      o_dsp_rsv_src1_vld_0,
    output  [`PRF_CODE_WIDTH - 1        : 0]    o_dsp_rsv_src1_prf_code_0,
    output                                      o_dsp_rsv_src2_vld_0,
    output  [`PRF_CODE_WIDTH - 1        : 0]    o_dsp_rsv_src2_prf_code_0,
    output                                      o_dsp_rsv_src3_vld_0,
    output  [`PRF_CODE_WIDTH - 1        : 0]    o_dsp_rsv_src3_prf_code_0,
    output                                      o_dsp_rsv_dst_vld_0,
    output  [`PRF_CODE_WIDTH - 1        : 0]    o_dsp_rsv_dst_prf_code_0,
    output  [`PRF_CODE_WIDTH - 1        : 0]    o_dsp_rsv_dst_pprf_code_0,
    output                                      o_dsp_rsv_src1_vld_1,
    output  [`PRF_CODE_WIDTH - 1        : 0]    o_dsp_rsv_src1_prf_code_1,
    output                                      o_dsp_rsv_src2_vld_1,
    output  [`PRF_CODE_WIDTH - 1        : 0]    o_dsp_rsv_src2_prf_code_1,
    output                                      o_dsp_rsv_src3_vld_1,
    output  [`PRF_CODE_WIDTH - 1        : 0]    o_dsp_rsv_src3_prf_code_1,
    output                                      o_dsp_rsv_dst_vld_1,
    output  [`PRF_CODE_WIDTH - 1        : 0]    o_dsp_rsv_dst_prf_code_1,
    output  [`PRF_CODE_WIDTH - 1        : 0]    o_dsp_rsv_dst_pprf_code_1,
    output                                      o_dsp_rsv_src1_vld_2,
    output  [`PRF_CODE_WIDTH - 1        : 0]    o_dsp_rsv_src1_prf_code_2,
    output                                      o_dsp_rsv_src2_vld_2,
    output  [`PRF_CODE_WIDTH - 1        : 0]    o_dsp_rsv_src2_prf_code_2,
    output                                      o_dsp_rsv_src3_vld_2,
    output  [`PRF_CODE_WIDTH - 1        : 0]    o_dsp_rsv_src3_prf_code_2,
    output                                      o_dsp_rsv_dst_vld_2,
    output  [`PRF_CODE_WIDTH - 1        : 0]    o_dsp_rsv_dst_prf_code_2,
    output  [`PRF_CODE_WIDTH - 1        : 0]    o_dsp_rsv_dst_pprf_code_2,
    output                                      o_dsp_rsv_src1_vld_3,
    output  [`PRF_CODE_WIDTH - 1        : 0]    o_dsp_rsv_src1_prf_code_3,
    output                                      o_dsp_rsv_src2_vld_3,
    output  [`PRF_CODE_WIDTH - 1        : 0]    o_dsp_rsv_src2_prf_code_3,
    output                                      o_dsp_rsv_src3_vld_3,
    output  [`PRF_CODE_WIDTH - 1        : 0]    o_dsp_rsv_src3_prf_code_3,
    output                                      o_dsp_rsv_dst_vld_3,
    output  [`PRF_CODE_WIDTH - 1        : 0]    o_dsp_rsv_dst_prf_code_3,
    output  [`PRF_CODE_WIDTH - 1        : 0]    o_dsp_rsv_dst_pprf_code_3,
    output  [3                          : 0]    o_dsp_rsv_len,
    output  [`DECINFO_WIDTH - 1         : 0]    o_dsp_rsv_decinfo_bus_0,
    output  [`DECINFO_WIDTH - 1         : 0]    o_dsp_rsv_decinfo_bus_1,
    output  [`DECINFO_WIDTH - 1         : 0]    o_dsp_rsv_decinfo_bus_2,
    output  [`DECINFO_WIDTH - 1         : 0]    o_dsp_rsv_decinfo_bus_3,
    output  [`PREDINFO_WIDTH - 1        : 0]    o_dsp_rsv_predinfo_bus_0,
    output  [`PREDINFO_WIDTH - 1        : 0]    o_dsp_rsv_predinfo_bus_1,
    output  [`PREDINFO_WIDTH - 1        : 0]    o_dsp_rsv_predinfo_bus_2,
    output  [`PREDINFO_WIDTH - 1        : 0]    o_dsp_rsv_predinfo_bus_3,
    output  [`RSV_IDX_WIDTH - 1         : 0]    o_dsp_rsv_free_entry_0,
    output  [`RSV_IDX_WIDTH - 1         : 0]    o_dsp_rsv_free_entry_1,
    output  [`RSV_IDX_WIDTH - 1         : 0]    o_dsp_rsv_free_entry_2,
    output  [`RSV_IDX_WIDTH - 1         : 0]    o_dsp_rsv_free_entry_3,
    output  [`ROB_ID_WIDTH - 1          : 0]    o_dsp_rsv_rob_id_0,
    output                                      o_dsp_rsv_ld_vld_0,
    output  [`LBUFF_ID_WIDTH - 1        : 0]    o_dsp_rsv_ld_id_0,
    output                                      o_dsp_rsv_st_vld_0,
    output  [`SBUFF_ID_WIDTH - 1        : 0]    o_dsp_rsv_st_id_0,
    output  [`ROB_ID_WIDTH - 1          : 0]    o_dsp_rsv_rob_id_1,
    output                                      o_dsp_rsv_ld_vld_1,
    output  [`LBUFF_ID_WIDTH - 1        : 0]    o_dsp_rsv_ld_id_1,
    output                                      o_dsp_rsv_st_vld_1,
    output  [`SBUFF_ID_WIDTH - 1        : 0]    o_dsp_rsv_st_id_1,
    output  [`ROB_ID_WIDTH - 1          : 0]    o_dsp_rsv_rob_id_2,
    output                                      o_dsp_rsv_ld_vld_2,
    output  [`LBUFF_ID_WIDTH - 1        : 0]    o_dsp_rsv_ld_id_2,
    output                                      o_dsp_rsv_st_vld_2,
    output  [`SBUFF_ID_WIDTH - 1        : 0]    o_dsp_rsv_st_id_2,
    output  [`ROB_ID_WIDTH - 1          : 0]    o_dsp_rsv_rob_id_3,
    output                                      o_dsp_rsv_ld_vld_3,
    output  [`LBUFF_ID_WIDTH - 1        : 0]    o_dsp_rsv_ld_id_3,
    output                                      o_dsp_rsv_st_vld_3,
    output  [`SBUFF_ID_WIDTH - 1        : 0]    o_dsp_rsv_st_id_3,
    output  [`ROB_ID_WIDTH - 1          : 0]    o_dsp_rsv_rob_dsp_id,
    output  [`ROB_ID_WIDTH - 1          : 0]    o_dsp_rsv_rob_ret_id,
    output  [`SBUFF_ID_WIDTH - 1        : 0]    o_dsp_rsv_st_dsp_id,
    output  [`SBUFF_ID_WIDTH - 1        : 0]    o_dsp_rsv_st_ret_id,
    output  [`SBUFF_ID_WIDTH - 1        : 0]    o_dsp_rsv_st_rec_id,
    output  [`LBUFF_ID_WIDTH - 1        : 0]    o_dsp_rsv_ld_dsp_id,
    output  [`LBUFF_ID_WIDTH - 1        : 0]    o_dsp_rsv_ld_ret_id,
    output  [`INSTR_WIDTH - 1           : 0]    o_dsp_rob_instr_0,
    output  [`INSTR_WIDTH - 1           : 0]    o_dsp_rob_instr_1,
    output  [`INSTR_WIDTH - 1           : 0]    o_dsp_rob_instr_2,
    output  [`INSTR_WIDTH - 1           : 0]    o_dsp_rob_instr_3,
    output  [`CORE_PC_WIDTH - 1         : 0]    o_dsp_rob_addr_0,
    output  [`CORE_PC_WIDTH - 1         : 0]    o_dsp_rob_addr_1,
    output  [`CORE_PC_WIDTH - 1         : 0]    o_dsp_rob_addr_2,
    output  [`CORE_PC_WIDTH - 1         : 0]    o_dsp_rob_addr_3,
    output  [`CORE_PC_WIDTH - 1         : 0]    o_dsp_rob_taddr_0,
    output  [`CORE_PC_WIDTH - 1         : 0]    o_dsp_rob_taddr_1,
    output  [`CORE_PC_WIDTH - 1         : 0]    o_dsp_rob_taddr_2,
    output  [`CORE_PC_WIDTH - 1         : 0]    o_dsp_rob_taddr_3,
    

    output                                      o_dsp_ren_stall,

    input                                       clk,
    input                                       rst_n
);

assign o_dsp_rsv_vld = {
                            (i_dec_dsp_vld[3] & (~o_dec_iq_stall))
                        ,   (i_dec_dsp_vld[2] & (~o_dec_iq_stall))
                        ,   (i_dec_dsp_vld[1] & (~o_dec_iq_stall))
                        ,   (i_dec_dsp_vld[0] & ((dsp_sync_stall & (~dsp_sync_flag_r)) | (~dsp_res_stall)))
                    };

assign {
        o_dsp_rsv_src1_vld_0
    ,   o_dsp_rsv_src1_prf_code_0
    ,   o_dsp_rsv_src2_vld_0
    ,   o_dsp_rsv_src2_prf_code_0
    ,   o_dsp_rsv_src3_vld_0
    ,   o_dsp_rsv_src3_prf_code_0
    ,   o_dsp_rsv_dst_vld_0
    ,   o_dsp_rsv_dst_prf_code_0
    ,   o_dsp_rsv_dst_pprf_code_0
    ,   o_dsp_rsv_src1_vld_1
    ,   o_dsp_rsv_src1_prf_code_1
    ,   o_dsp_rsv_src2_vld_1
    ,   o_dsp_rsv_src2_prf_code_1
    ,   o_dsp_rsv_src3_vld_1
    ,   o_dsp_rsv_src3_prf_code_1
    ,   o_dsp_rsv_dst_vld_1
    ,   o_dsp_rsv_dst_prf_code_1
    ,   o_dsp_rsv_dst_pprf_code_1
    ,   o_dsp_rsv_src1_vld_2
    ,   o_dsp_rsv_src1_prf_code_2
    ,   o_dsp_rsv_src2_vld_2
    ,   o_dsp_rsv_src2_prf_code_2
    ,   o_dsp_rsv_src3_vld_2
    ,   o_dsp_rsv_src3_prf_code_2
    ,   o_dsp_rsv_dst_vld_2
    ,   o_dsp_rsv_dst_prf_code_2
    ,   o_dsp_rsv_dst_pprf_code_2
    ,   o_dsp_rsv_src1_vld_3
    ,   o_dsp_rsv_src1_prf_code_3
    ,   o_dsp_rsv_src2_vld_3
    ,   o_dsp_rsv_src2_prf_code_3
    ,   o_dsp_rsv_src3_vld_3
    ,   o_dsp_rsv_src3_prf_code_3
    ,   o_dsp_rsv_dst_vld_3
    ,   o_dsp_rsv_dst_prf_code_3
    ,   o_dsp_rsv_dst_pprf_code_3
    ,   o_dsp_rsv_decinfo_bus_1
    ,   o_dsp_rsv_decinfo_bus_2
    ,   o_dsp_rsv_decinfo_bus_3
    ,   o_dsp_rsv_predinfo_bus_0
    ,   o_dsp_rsv_predinfo_bus_1
    ,   o_dsp_rsv_predinfo_bus_2
    ,   o_dsp_rsv_predinfo_bus_3
    ,   o_dsp_rob_taddr_0 
    ,   o_dsp_rob_taddr_1 
    ,   o_dsp_rob_taddr_2
    ,   o_dsp_rob_taddr_3
    ,   o_dsp_rob_addr_0
    ,   o_dsp_rob_addr_1
    ,   o_dsp_rob_addr_2
    ,   o_dsp_rob_addr_3
    ,   o_dsp_rob_instr_0
    ,   o_dsp_rob_instr_1
    ,   o_dsp_rob_instr_2
    ,   o_dsp_rob_instr_3
    ,   o_dsp_rsv_len
} = {
        i_dec_dsp_src1_vld_0
    ,   i_dec_dsp_src1_prf_code_0
    ,   i_dec_dsp_src2_vld_0
    ,   i_dec_dsp_src2_prf_code_0
    ,   i_dec_dsp_src3_vld_0
    ,   i_dec_dsp_src3_prf_code_0
    ,   i_dec_dsp_dst_vld_0
    ,   i_dec_dsp_dst_prf_code_0
    ,   i_dec_dsp_dst_pprf_code_0
    ,   i_dec_dsp_src1_vld_1
    ,   i_dec_dsp_src1_prf_code_1
    ,   i_dec_dsp_src2_vld_1
    ,   i_dec_dsp_src2_prf_code_1
    ,   i_dec_dsp_src3_vld_1
    ,   i_dec_dsp_src3_prf_code_1
    ,   i_dec_dsp_dst_vld_1
    ,   i_dec_dsp_dst_prf_code_1
    ,   i_dec_dsp_dst_pprf_code_1
    ,   i_dec_dsp_src1_vld_2
    ,   i_dec_dsp_src1_prf_code_2
    ,   i_dec_dsp_src2_vld_2
    ,   i_dec_dsp_src2_prf_code_2
    ,   i_dec_dsp_src3_vld_2
    ,   i_dec_dsp_src3_prf_code_2
    ,   i_dec_dsp_dst_vld_2
    ,   i_dec_dsp_dst_prf_code_2
    ,   i_dec_dsp_dst_pprf_code_2
    ,   i_dec_dsp_src1_vld_3
    ,   i_dec_dsp_src1_prf_code_3
    ,   i_dec_dsp_src2_vld_3
    ,   i_dec_dsp_src2_prf_code_3
    ,   i_dec_dsp_src3_vld_3
    ,   i_dec_dsp_src3_prf_code_3
    ,   i_dec_dsp_dst_vld_3
    ,   i_dec_dsp_dst_prf_code_3
    ,   i_dec_dsp_dst_pprf_code_3
    ,   i_dec_dsp_decinfo_bus_1
    ,   i_dec_dsp_decinfo_bus_2
    ,   i_dec_dsp_decinfo_bus_3
    ,   i_dec_dsp_predinfo_bus_0
    ,   i_dec_dsp_predinfo_bus_1
    ,   i_dec_dsp_predinfo_bus_2
    ,   i_dec_dsp_predinfo_bus_3
    ,   i_dsp_rob_taddr_0
    ,   i_dsp_rob_taddr_1
    ,   i_dsp_rob_taddr_2
    ,   i_dsp_rob_taddr_3
    ,   i_dsp_rob_addr_0
    ,   i_dsp_rob_addr_1
    ,   i_dsp_rob_addr_2
    ,   i_dsp_rob_addr_3
    ,   i_dec_dsp_instr_0
    ,   i_dec_dsp_instr_1
    ,   i_dec_dsp_instr_2
    ,   i_dec_dsp_instr_3
    ,   i_dec_dsp_len
};

//
wire dsp_ld_vld_0 = ((i_dec_dsp_decinfo_bus_0[`DECINFO_EXEC_UNIT] == `UOPINFO_AGU) & i_dec_dsp_decinfo_bus_0[`DECINFO_AGU_LOAD]);
wire dsp_st_vld_0 = ((i_dec_dsp_decinfo_bus_0[`DECINFO_EXEC_UNIT] == `UOPINFO_AGU) & i_dec_dsp_decinfo_bus_0[`DECINFO_AGU_STORE]);
wire dsp_ld_vld_1 = ((i_dec_dsp_decinfo_bus_1[`DECINFO_EXEC_UNIT] == `UOPINFO_AGU) & i_dec_dsp_decinfo_bus_1[`DECINFO_AGU_LOAD]);
wire dsp_st_vld_1 = ((i_dec_dsp_decinfo_bus_1[`DECINFO_EXEC_UNIT] == `UOPINFO_AGU) & i_dec_dsp_decinfo_bus_1[`DECINFO_AGU_STORE]);
wire dsp_ld_vld_2 = ((i_dec_dsp_decinfo_bus_2[`DECINFO_EXEC_UNIT] == `UOPINFO_AGU) & i_dec_dsp_decinfo_bus_2[`DECINFO_AGU_LOAD]);
wire dsp_st_vld_2 = ((i_dec_dsp_decinfo_bus_2[`DECINFO_EXEC_UNIT] == `UOPINFO_AGU) & i_dec_dsp_decinfo_bus_2[`DECINFO_AGU_STORE]);
wire dsp_ld_vld_3 = ((i_dec_dsp_decinfo_bus_3[`DECINFO_EXEC_UNIT] == `UOPINFO_AGU) & i_dec_dsp_decinfo_bus_3[`DECINFO_AGU_LOAD]);
wire dsp_st_vld_3 = ((i_dec_dsp_decinfo_bus_3[`DECINFO_EXEC_UNIT] == `UOPINFO_AGU) & i_dec_dsp_decinfo_bus_3[`DECINFO_AGU_STORE]);

//  GEN
wire o_dsp_gen_ldq_list_empty;
wire o_dsp_gen_stq_list_empty;
wire o_dsp_gen_robid_list_empty;


wire [3 : 0] i_dsp_gen_ld_vld = {
                                    (dsp_ld_vld_3 & i_dec_dsp_vld[3])
                                ,   (dsp_ld_vld_2 & i_dec_dsp_vld[2])
                                ,   (dsp_ld_vld_1 & i_dec_dsp_vld[1])
                                ,   (dsp_ld_vld_0 & i_dec_dsp_vld[0])
                                };
wire [3 : 0] i_dsp_gen_st_vld = {
                                    (dsp_st_vld_3 & i_dec_dsp_vld[3])
                                ,   (dsp_st_vld_2 & i_dec_dsp_vld[2])
                                ,   (dsp_st_vld_1 & i_dec_dsp_vld[1])
                                ,   (dsp_st_vld_0 & i_dec_dsp_vld[0])
                                };

wire [3 : 0] i_dsp_gen_ret_ld_vld = {
                                    (i_rob_dsp_ret_vld[3] & i_rob_dsp_ret_ld_vld_3)
                                ,   (i_rob_dsp_ret_vld[2] & i_rob_dsp_ret_ld_vld_2)
                                ,   (i_rob_dsp_ret_vld[1] & i_rob_dsp_ret_ld_vld_1)
                                ,   (i_rob_dsp_ret_vld[0] & i_rob_dsp_ret_ld_vld_0)
                                };

wire [3 : 0] i_dsp_gen_ret_st_vld = {
                                    (i_rob_dsp_ret_vld[3] & i_rob_dsp_ret_st_vld_3)
                                ,   (i_rob_dsp_ret_vld[2] & i_rob_dsp_ret_st_vld_2)
                                ,   (i_rob_dsp_ret_vld[1] & i_rob_dsp_ret_st_vld_1)
                                ,   (i_rob_dsp_ret_vld[0] & i_rob_dsp_ret_st_vld_0)
                                };

dsp_gen_module dsp_gen (
    .i_csr_trap_flush          (i_csr_trap_flush),
    .i_exu_mis_flush           (i_exu_mis_flush),
    .i_exu_mis_rob_id          (i_exu_mis_rob_id),
    .i_exu_ls_flush            (i_exu_ls_flush),
    .i_exu_ls_rob_id           (i_exu_ls_rob_id),

    .i_dsp_gen_mis_ld_vld      (i_rob_dsp_mis_ld_vld),
    .i_dsp_gen_mis_ld_id       (i_rob_dsp_mis_ld_id),
    .i_dsp_gen_mis_st_vld      (i_rob_dsp_mis_st_vld),
    .i_dsp_gen_mis_st_id       (i_rob_dsp_mis_st_id),
    .i_dsp_gen_stall           (o_dsp_ren_stall),
    .i_dsp_gen_vld             (i_dec_dsp_vld),
    .i_dsp_gen_ld_vld          (i_dsp_gen_ld_vld),
    .i_dsp_gen_st_vld          (i_dsp_gen_st_vld),
    .i_dsp_gen_ret_vld         (i_rob_dsp_ret_vld),
    .i_dsp_gen_ret_ld_vld      (i_dsp_gen_ret_ld_vld),
    .i_dsp_gen_ret_st_vld      (i_dsp_gen_ret_st_vld),
    .i_dsp_gen_s_ret           (i_exu_dsp_s_ret),
    .o_dsp_gen_rob_id_0        (o_dsp_rsv_rob_id_0),
    .o_dsp_gen_rob_id_1        (o_dsp_rsv_rob_id_1),
    .o_dsp_gen_rob_id_2        (o_dsp_rsv_rob_id_2),
    .o_dsp_gen_rob_id_3        (o_dsp_rsv_rob_id_3),
    .o_dsp_gen_rob_dsp_id      (o_dsp_rsv_rob_dsp_id),
    .o_dsp_gen_rob_ret_id      (o_dsp_rsv_rob_ret_id),
    .o_dsp_gen_lbuff_id_0      (o_dsp_rsv_ld_id_0),
    .o_dsp_gen_lbuff_id_1      (o_dsp_rsv_ld_id_1),
    .o_dsp_gen_lbuff_id_2      (o_dsp_rsv_ld_id_2),
    .o_dsp_gen_lbuff_id_3      (o_dsp_rsv_ld_id_3),
    .o_dsp_gen_ldq_dsp_id      (o_dsp_rsv_ld_dsp_id),
    .o_dsp_gen_ldq_ret_id      (o_dsp_rsv_ld_ret_id),
    .o_dsp_gen_sbuff_id_0      (o_dsp_rsv_st_id_0),
    .o_dsp_gen_sbuff_id_1      (o_dsp_rsv_st_id_1),
    .o_dsp_gen_sbuff_id_2      (o_dsp_rsv_st_id_2),
    .o_dsp_gen_sbuff_id_3      (o_dsp_rsv_st_id_3),
    .o_dsp_gen_stq_dsp_id      (o_dsp_rsv_st_dsp_id),
    .o_dsp_gen_stq_ret_id      (o_dsp_rsv_st_ret_id),
    .o_dsp_gen_stq_rec_id      (o_dsp_rsv_st_rec_id),
    .o_dsp_gen_robid_list_empty(o_dsp_gen_robid_list_empty),
    .o_dsp_gen_ldq_list_empty  (o_dsp_gen_ldq_list_empty),
    .o_dsp_gen_stq_list_empty  (o_dsp_gen_stq_list_empty),
    .clk                       (clk),
    .rst_n                     (rst_n)
);


//  FMGR
wire i_dsp_fmgr_free_req_0 = ((((~dsp_ld_vld_0) & (~dsp_st_vld_0))
                           |  (dsp_ld_vld_0 & (~o_dsp_gen_ldq_list_empty))
                           |  (dsp_st_vld_0 & (~o_dsp_gen_stq_list_empty))
                           |  (~o_dsp_gen_robid_list_empty)) 
                           & i_dec_dsp_vld[0]);
wire i_dsp_fmgr_free_req_1 = ((((~dsp_ld_vld_1) & (~dsp_st_vld_1))
                           |  (dsp_ld_vld_1 & (~o_dsp_gen_ldq_list_empty))
                           |  (dsp_st_vld_1 & (~o_dsp_gen_stq_list_empty))
                           |  (~o_dsp_gen_robid_list_empty))
                           & i_dec_dsp_vld[1]);
wire i_dsp_fmgr_free_req_2 = ((((~dsp_ld_vld_2) & (~dsp_st_vld_2))
                           |  (dsp_ld_vld_2 & (~o_dsp_gen_ldq_list_empty))
                           |  (dsp_st_vld_2 & (~o_dsp_gen_stq_list_empty))
                           |  (~o_dsp_gen_robid_list_empty))
                           & i_dec_dsp_vld[2]);
wire i_dsp_fmgr_free_req_3 = ((((~dsp_ld_vld_3) & (~dsp_st_vld_3))
                           |  (dsp_ld_vld_3 & (~o_dsp_gen_ldq_list_empty))
                           |  (dsp_st_vld_3 & (~o_dsp_gen_stq_list_empty))
                           |  (~o_dsp_gen_robid_list_empty))
                           & i_dec_dsp_vld[3]);

wire [3 : 0] i_dsp_fmgr_ret_vld = {
                                    i_rsv_dsp_free_vld_3
                                ,   i_rsv_dsp_free_vld_2
                                ,   i_rsv_dsp_free_vld_1
                                ,   i_rsv_dsp_free_vld_0    
                                };
wire o_dsp_fmgr_list_empty;

dsp_fmgr_module dsp_fmgr (
    .i_csr_trap_flush       (i_csr_trap_flush),
    .i_dsp_fmgr_stall       (o_dsp_ren_stall),
    .i_dsp_fmgr_free_req_0  (i_dsp_fmgr_free_req_0),
    .i_dsp_fmgr_free_req_1  (i_dsp_fmgr_free_req_1),
    .i_dsp_fmgr_free_req_2  (i_dsp_fmgr_free_req_2),
    .i_dsp_fmgr_free_req_3  (i_dsp_fmgr_free_req_3),
    .o_dsp_fmgr_free_entry_0(o_dsp_rsv_free_entry_0),
    .o_dsp_fmgr_free_entry_1(o_dsp_rsv_free_entry_1),
    .o_dsp_fmgr_free_entry_2(o_dsp_rsv_free_entry_2),
    .o_dsp_fmgr_free_entry_3(o_dsp_rsv_free_entry_3),
    .i_dsp_fmgr_ret_vld     (i_dsp_fmgr_ret_vld),
    .i_dsp_fmgr_ret_entry_0 (i_rsv_dsp_free_entry_0),
    .i_dsp_fmgr_ret_entry_1 (i_rsv_dsp_free_entry_1),
    .i_dsp_fmgr_ret_entry_2 (i_rsv_dsp_free_entry_2),
    .i_dsp_fmgr_ret_entry_3 (i_rsv_dsp_free_entry_3),
    .o_dsp_fmgr_list_empty  (o_dsp_fmgr_list_empty),
    .clk                    (clk),
    .rst_n                  (rst_n)
);

//
assign {
        o_dsp_rsv_ld_vld_3
    ,   o_dsp_rsv_ld_vld_2
    ,   o_dsp_rsv_ld_vld_1
    ,   o_dsp_rsv_ld_vld_0
} = i_dsp_gen_ld_vld;

assign {
        o_dsp_rsv_st_vld_3
    ,   o_dsp_rsv_st_vld_2
    ,   o_dsp_rsv_st_vld_1
    ,   o_dsp_rsv_st_vld_0
    } = i_dsp_gen_st_vld;

//
wire csr_stall_detect = ((i_dec_dsp_vld[0] & (i_dec_dsp_decinfo_bus_0[`DECINFO_EXEC_UNIT] == `DECINFO_CSR)) & (~i_rob_dsp_sync_csr_ret));
wire fence_stall_detect = ((i_dec_dsp_vld[0] 
                        &  (i_dec_dsp_decinfo_bus_0[`DECINFO_ALU_FENCE]
                        |   i_dec_dsp_decinfo_bus_0[`DECINFO_ALU_FENCE_I]
                        |   i_dec_dsp_decinfo_bus_0[`DECINFO_ALU_SFENCE_VMA]))
                        & (~i_rob_dsp_sync_fence_ret));

wire dsp_res_stall = (o_dsp_fmgr_list_empty 
                   |  o_dsp_gen_robid_list_empty 
                   |  o_dsp_gen_ldq_list_empty 
                   |  o_dsp_gen_stq_list_empty);
wire dsp_sync_stall = (csr_stall_detect | fence_stall_detect);

assign o_dsp_ren_stall = (dsp_res_stall | dsp_sync_stall);

wire dsp_sync_flag_r;
wire dsp_sync_flag_set = (dsp_sync_stall & (~dsp_sync_flag_r));
wire dsp_sync_flag_clr = (i_rob_dsp_sync_fence_ret | i_rob_dsp_sync_csr_ret);
wire dsp_sync_flag_ena = (dsp_sync_flag_set | dsp_sync_flag_clr);
wire dsp_sync_flag_nxt = (dsp_sync_flag_set | (~dsp_sync_flag_clr));

gnrl_dfflr #( 
    .DATA_WIDTH   (1),
    .INITIAL_VALUE(0)
) dsp_sync_flag_dfflr (dsp_sync_flag_ena, dsp_sync_flag_nxt, dsp_sync_flag_r, clk, rst_n);

//
wire [`DECINFO_WIDTH - 1 : 0] csr_sync_inst = {
                                                8'd0
                                            ,   1'b1 // sync_csr
                                            ,   17'd0
                                            ,   `DECINFO_CSR
                                            };
wire [`DECINFO_WIDTH - 1 : 0] fence_sync_inst = {
                                                    8'd0 
                                                ,   1'b1 // sync_fence
                                                ,   17'd0
                                                ,   `DECINFO_ALU 
                                            };

assign o_dsp_rsv_reninfo_bus_0   = ({`DECINFO_WIDTH{(~(csr_stall_detect | fence_stall_detect))}} & i_dec_dsp_decinfo_bus_0)                                                          )
                                 | ({`DECINFO_WIDTH{csr_stall_detect                          }} & csr_sync_inst          )
                                 | ({`DECINFO_WIDTH{fence_stall_detect                        }} & fence_sync_inst        );

endmodule   //  dsp_top_module

`endif  /*  !__DISPATCH_DSP_TOP_V__!    */