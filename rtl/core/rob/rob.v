`ifdef __ROB_ROB_V__

module rob_module (
    input                                               i_csr_trap_flush,
    input   [1                          : 0]            i_csr_rv_mode,
    input                                               i_exu_mis_flush,
    input   [`ROB_ID_WIDTH - 1          : 0]            i_exu_mis_rob_id,
    input                                               i_exu_ls_flush,
    input   [`ROB_ID_WIDTH - 1          : 0]            i_exu_ls_rob_id,
    
    input   [3                          : 0]            i_dsp_rob_vld,
    input   [`ROB_ID_WIDTH - 1          : 0]            i_dsp_rob_rob_id_0,
    input                                               i_dsp_rob_ld_vld_0,
    input   [`LBUFF_ID_WIDTH - 1        : 0]            i_dsp_rob_ld_id_0,
    input                                               i_dsp_rob_st_vld_0,
    input   [`SBUFF_ID_WIDTH - 1        : 0]            i_dsp_rob_st_id_0,

    input   [`ROB_ID_WIDTH - 1          : 0]            i_dsp_rob_rob_id_1,
    input                                               i_dsp_rob_ld_vld_1,
    input   [`LBUFF_ID_WIDTH - 1        : 0]            i_dsp_rob_ld_id_1,
    input                                               i_dsp_rob_st_vld_1,
    input   [`SBUFF_ID_WIDTH - 1        : 0]            i_dsp_rob_st_id_1,

    input   [`ROB_ID_WIDTH - 1          : 0]            i_dsp_rob_rob_id_2,
    input                                               i_dsp_rob_ld_vld_2,
    input   [`LBUFF_ID_WIDTH - 1        : 0]            i_dsp_rob_ld_id_2,
    input                                               i_dsp_rob_st_vld_2,
    input   [`SBUFF_ID_WIDTH - 1        : 0]            i_dsp_rob_st_id_2,

    input   [`ROB_ID_WIDTH - 1          : 0]            i_dsp_rob_rob_id_3,
    input                                               i_dsp_rob_ld_vld_3,
    input   [`LBUFF_ID_WIDTH - 1        : 0]            i_dsp_rob_ld_id_3,
    input                                               i_dsp_rob_st_vld_3,
    input   [`SBUFF_ID_WIDTH - 1        : 0]            i_dsp_rob_st_id_3,

    input   [3                          : 0]            i_dsp_rob_len,
    input                                               i_dsp_rob_dst_vld_0,
    input                                               i_dsp_rob_dst_vld_1,
    input                                               i_dsp_rob_dst_vld_2,
    input                                               i_dsp_rob_dst_vld_3,
    input   [`ARF_CODE_WIDTH - 1        : 0]            i_dsp_rob_dst_arf_code_0,
    input   [`ARF_CODE_WIDTH - 1        : 0]            i_dsp_rob_dst_arf_code_1,
    input   [`ARF_CODE_WIDTH - 1        : 0]            i_dsp_rob_dst_arf_code_2,
    input   [`ARF_CODE_WIDTH - 1        : 0]            i_dsp_rob_dst_arf_code_3,
    input   [`PRF_CODE_WIDTH - 1        : 0]            i_dsp_rob_dst_prf_code_0,
    input   [`PRF_CODE_WIDTH - 1        : 0]            i_dsp_rob_dst_prf_code_1,
    input   [`PRF_CODE_WIDTH - 1        : 0]            i_dsp_rob_dst_prf_code_2,
    input   [`PRF_CODE_WIDTH - 1        : 0]            i_dsp_rob_dst_prf_code_3,
    input   [`PRF_CODE_WIDTH - 1        : 0]            i_dsp_rob_dst_pprf_code_0,
    input   [`PRF_CODE_WIDTH - 1        : 0]            i_dsp_rob_dst_pprf_code_1,
    input   [`PRF_CODE_WIDTH - 1        : 0]            i_dsp_rob_dst_pprf_code_2,
    input   [`PRF_CODE_WIDTH - 1        : 0]            i_dsp_rob_dst_pprf_code_3,
    input   [`DECINFO_WIDTH - 1         : 0]            i_dsp_rob_decinfo_bus_0,
    input   [`DECINFO_WIDTH - 1         : 0]            i_dsp_rob_decinfo_bus_1,
    input   [`DECINFO_WIDTH - 1         : 0]            i_dsp_rob_decinfo_bus_2,
    input   [`DECINFO_WIDTH - 1         : 0]            i_dsp_rob_decinfo_bus_3,
    input   [`PREDINFO_WIDTH - 1        : 0]            i_dsp_rob_predinfo_bus_0,
    input   [`PREDINFO_WIDTH - 1        : 0]            i_dsp_rob_predinfo_bus_1,
    input   [`PREDINFO_WIDTH - 1        : 0]            i_dsp_rob_predinfo_bus_2,
    input   [`PREDINFO_WIDTH - 1        : 0]            i_dsp_rob_predinfo_bus_3,
    input   [`ROB_ID_WIDTH - 1          : 0]            i_dsp_rob_dsp_id,
    input   [`ROB_ID_WIDTH - 1          : 0]            i_dsp_rob_ret_id,
    input   [`CORE_PC_WIDTH - 1         : 0]            i_dsp_rob_addr_0,
    input   [`CORE_PC_WIDTH - 1         : 0]            i_dsp_rob_addr_1,
    input   [`CORE_PC_WIDTH - 1         : 0]            i_dsp_rob_addr_2,
    input   [`CORE_PC_WIDTH - 1         : 0]            i_dsp_rob_addr_3,
    input   [`CORE_PC_WIDTH - 1         : 0]            i_dsp_rob_taddr_0,
    input   [`CORE_PC_WIDTH - 1         : 0]            i_dsp_rob_taddr_1,
    input   [`CORE_PC_WIDTH - 1         : 0]            i_dsp_rob_taddr_2,
    input   [`CORE_PC_WIDTH - 1         : 0]            i_dsp_rob_taddr_3,
    input   [`INSTR_WIDTH - 1           : 0]            i_dsp_rob_instr_0,
    input   [`INSTR_WIDTH - 1           : 0]            i_dsp_rob_instr_1,
    input   [`INSTR_WIDTH - 1           : 0]            i_dsp_rob_instr_2,
    input   [`INSTR_WIDTH - 1           : 0]            i_dsp_rob_instr_3,

    input                                               i_exu_rob_vld_0,
    input                                               i_exu_rob_vld_1,
    input                                               i_exu_rob_vld_2,
    input                                               i_exu_rob_vld_3,
    input   [`ROB_ID_WIDTH - 1          : 0]            i_exu_rob_rob_id_0,
    input   [`ROB_ID_WIDTH - 1          : 0]            i_exu_rob_rob_id_1,
    input   [`ROB_ID_WIDTH - 1          : 0]            i_exu_rob_rob_id_2,
    input   [`ROB_ID_WIDTH - 1          : 0]            i_exu_rob_rob_id_3,
    input                                               i_exu_rob_done_0,
    input                                               i_exu_rob_done_1,
    input                                               i_exu_rob_done_2,
    input                                               i_exu_rob_done_3,
    input   [`EXCEPTION_CODE_WIDTH - 1  : 0]            i_exu_rob_excp_code_0,
    input   [`EXCEPTION_CODE_WIDTH - 1  : 0]            i_exu_rob_excp_code_1,
    input   [`EXCEPTION_CODE_WIDTH - 1  : 0]            i_exu_rob_excp_code_2,
    input   [`EXCEPTION_CODE_WIDTH - 1  : 0]            i_exu_rob_excp_code_3,
    input   [31                         : 0]            i_exu_rob_fence_src1,
    input   [31                         : 0]            i_exu_rob_fence_src2,
    input   [`ROB_ID_WIDTH - 1          : 0]            i_exu_rob_rob_id_addr_0,
    input   [`ROB_ID_WIDTH - 1          : 0]            i_exu_rob_rob_id_addr_1,
    input   [`ROB_ID_WIDTH - 1          : 0]            i_exu_rob_rob_id_addr_3,

    input                                               i_itlb_rob_flush_done,
    input                                               i_dtlb_rob_flush_done,
    input                                               i_mmu_rob_flush_done,
    input                                               i_exu_rob_st_ret_done,                 
    
    output  [3                          : 0]            o_rob_ren_ret_vld,
    output                                              o_rob_ren_ret_dst_vld_0,
    output  [`ARF_CODE_WIDTH - 1        : 0]            o_rob_ren_ret_arf_code_0,
    output  [`PRF_CODE_WIDTH - 1        : 0]            o_rob_ren_ret_prf_code_0,
    output                                              o_rob_ren_ret_dst_vld_1,
    output  [`ARF_CODE_WIDTH - 1        : 0]            o_rob_ren_ret_arf_code_1,
    output  [`PRF_CODE_WIDTH - 1        : 0]            o_rob_ren_ret_prf_code_1,
    output                                              o_rob_ren_ret_dst_vld_2,
    output  [`ARF_CODE_WIDTH - 1        : 0]            o_rob_ren_ret_arf_code_2,
    output  [`PRF_CODE_WIDTH - 1        : 0]            o_rob_ren_ret_prf_code_2,
    output                                              o_rob_ren_ret_dst_vld_3,
    output  [`ARF_CODE_WIDTH - 1        : 0]            o_rob_ren_ret_arf_code_3,
    output  [`PRF_CODE_WIDTH - 1        : 0]            o_rob_ren_ret_prf_code_3,

    output  [3                          : 0]            o_rob_ren_rec_vld,
    output  [`ARF_CODE_WIDTH - 1        : 0]            o_rob_ren_rec_arf_code_0,
    output  [`PRF_CODE_WIDTH - 1        : 0]            o_rob_ren_rec_prf_code_0,
    output  [`ARF_CODE_WIDTH - 1        : 0]            o_rob_ren_rec_arf_code_1,
    output  [`PRF_CODE_WIDTH - 1        : 0]            o_rob_ren_rec_prf_code_1,
    output  [`ARF_CODE_WIDTH - 1        : 0]            o_rob_ren_rec_arf_code_2,
    output  [`PRF_CODE_WIDTH - 1        : 0]            o_rob_ren_rec_prf_code_2,
    output  [`ARF_CODE_WIDTH - 1        : 0]            o_rob_ren_rec_arf_code_3,
    output  [`PRF_CODE_WIDTH - 1        : 0]            o_rob_ren_rec_prf_code_3,

    output  [3                          : 0]            o_rob_ren_mis_vld,
    output  [`ARF_CODE_WIDTH - 1        : 0]            o_rob_ren_mis_arf_code_0,
    output  [`PRF_CODE_WIDTH - 1        : 0]            o_rob_ren_mis_prf_code_0,
    output  [`ARF_CODE_WIDTH - 1        : 0]            o_rob_ren_mis_arf_code_1,
    output  [`PRF_CODE_WIDTH - 1        : 0]            o_rob_ren_mis_prf_code_1,
    output  [`ARF_CODE_WIDTH - 1        : 0]            o_rob_ren_mis_arf_code_2,
    output  [`PRF_CODE_WIDTH - 1        : 0]            o_rob_ren_mis_prf_code_2,
    output  [`ARF_CODE_WIDTH - 1        : 0]            o_rob_ren_mis_arf_code_3,
    output  [`PRF_CODE_WIDTH - 1        : 0]            o_rob_ren_mis_prf_code_3,

    output                                              o_rob_rsv_csr_ret,
    output                                              o_rob_rsv_fence_ret,
    output                                              o_rob_csr_int_vld,
    output                                              o_rob_csr_exc_vld,
    output  [`EXCEPTION_CODE_WIDTH - 1  : 0]            o_rob_csr_excp_code,
    output                                              o_rob_csr_len,
    output                                              o_rob_csr_mret,
    output                                              o_rob_csr_sret,
    output                                              o_rob_csr_uret,
    output                                              o_rob_csr_wfi,
    
    output  [3                          : 0]            o_rob_dsp_ret_vld,
    output  [`ROB_ID_WIDTH - 1          : 0]            o_rob_dsp_ret_rob_id_0,
    output                                              o_rob_dsp_ret_ld_vld_0,
    output  [`LBUFF_ID_WIDTH - 1        : 0]            o_rob_dsp_ret_ld_id_0,
    output                                              o_rob_dsp_ret_st_vld_0,
    output  [`SBUFF_ID_WIDTH - 1        : 0]            o_rob_dsp_ret_st_id_0,
    output  [`ROB_ID_WIDTH - 1          : 0]            o_rob_dsp_ret_rob_id_1,
    output                                              o_rob_dsp_ret_ld_vld_1,
    output  [`LBUFF_ID_WIDTH - 1        : 0]            o_rob_dsp_ret_ld_id_1,
    output                                              o_rob_dsp_ret_st_vld_1,
    output  [`SBUFF_ID_WIDTH - 1        : 0]            o_rob_dsp_ret_st_id_1,
    output  [`ROB_ID_WIDTH - 1          : 0]            o_rob_dsp_ret_rob_id_2,
    output                                              o_rob_dsp_ret_ld_vld_2,
    output  [`LBUFF_ID_WIDTH - 1        : 0]            o_rob_dsp_ret_ld_id_2,
    output                                              o_rob_dsp_ret_st_vld_2,
    output  [`SBUFF_ID_WIDTH - 1        : 0]            o_rob_dsp_ret_st_id_2,
    output  [`ROB_ID_WIDTH - 1          : 0]            o_rob_dsp_ret_rob_id_3,
    output                                              o_rob_dsp_ret_ld_vld_3,
    output  [`LBUFF_ID_WIDTH - 1        : 0]            o_rob_dsp_ret_ld_id_3,
    output                                              o_rob_dsp_ret_st_vld_3,
    output  [`SBUFF_ID_WIDTH - 1        : 0]            o_rob_dsp_ret_st_id_3,

    output                                              o_rob_dsp_mis_ld_vld,
    output  [`LBUFF_ID_WIDTH - 1        : 0]            o_rob_dsp_mis_ld_id,
    output                                              o_rob_dsp_mis_st_vld,
    output  [`SBUFF_ID_WIDTH - 1        : 0]            o_rob_dsp_mis_st_id,

    
    output  [`CORE_PC_WIDTH - 1         : 0]            o_rob_exu_addr_0,
    output  [`CORE_PC_WIDTH - 1         : 0]            o_rob_exu_addr_1,
    output  [`CORE_PC_WIDTH - 1         : 0]            o_rob_exu_addr_3,
    output  [`CORE_PC_WIDTH - 1         : 0]            o_rob_csr_trap_addr,
    output  [`CORE_PC_WIDTH - 1         : 0]            o_rob_exu_ls_addr,
    output  [`INSTR_WIDTH - 1           : 0]            o_rob_csr_instr,
    output                                              o_low_power_state,
    output                                              o_rob_itlb_flush,
    output  [31                         : 0]            o_rob_itlb_src1,
    output  [31                         : 0]            o_rob_itlb_src2,
    output                                              o_rob_dtlb_flush,
    output  [31                         : 0]            o_rob_dtlb_src1,
    output  [31                         : 0]            o_rob_dtlb_src2,
    output                                              o_rob_mmu_flush,
    output  [31                         : 0]            o_rob_mmu_src1,
    output  [31                         : 0]            o_rob_mmu_src2,
    output                                              o_rob_csr_sfence_vma_flush,
    output                                              o_rob_exu_s_ret,

    input                                               clk,
    input                                               rst_n
);
wire [127                       : 0] rob_vld_r;
wire [`ROB_INST_INFO_WIDTH - 1  : 0] rob_inst_info_r [127 : 0];
wire [`ROB_ID_WIDTH - 1         : 0] rob_rob_id_r [127 : 0];
wire [127                       : 0] rob_done_r;
wire [`EXCEPTION_CODE_WIDTH - 1 : 0] rob_excp_r [127 : 0];
wire [2 * `CORE_PC_WIDTH - 1    : 0] rob_addr_r [127 : 0];

//
wire i_exu_mis_ls_flush = (i_exu_mis_flush | i_exu_ls_flush);
wire i_exu_mis_ls_both = (i_exu_mis_flush & i_exu_ls_flush);
wire [`ROB_ID_WIDTH - 1 : 0] i_exu_mis_ls_rob_id = i_exu_mis_ls_both ? (func_rob_old(i_exu_mis_rob_id, i_exu_ls_rob_id) ? i_exu_mis_rob_id : i_exu_ls_rob_id)
                                                 : i_exu_mis_flush ? i_exu_mis_rob_id
                                                 : i_exu_ls_rob_id;
//
wire rob_req = (|i_dsp_rob_vld);
wire rob_ret = (|o_rob_dsp_ret_vld);

//
wire [127 : 0] rob_vld_set;
wire [127 : 0] rob_vld_clr;

genvar i;
generate
    for(i = 0; i < 128; i = i + 1) begin
        assign rob_vld_set[i] = (i_dsp_rob_vld[0] & (i == i_dsp_rob_rob_id_0[`ROB_ID_WIDTH - 2 : 0]))
                              | (i_dsp_rob_vld[1] & (i == i_dsp_rob_rob_id_1[`ROB_ID_WIDTH - 2 : 0]))
                              | (i_dsp_rob_vld[2] & (i == i_dsp_rob_rob_id_2[`ROB_ID_WIDTH - 2 : 0]))
                              | (i_dsp_rob_vld[3] & (i == i_dsp_rob_rob_id_3[`ROB_ID_WIDTH - 2 : 0]));
        assign rob_vld_clr[i] = (o_rob_dsp_ret_vld[0] & (i == o_rob_dsp_ret_rob_id_0[`ROB_ID_WIDTH - 2 : 0]))
                              | (o_rob_dsp_ret_vld[1] & (i == o_rob_dsp_ret_rob_id_1[`ROB_ID_WIDTH - 2 : 0]))
                              | (o_rob_dsp_ret_vld[2] & (i == o_rob_dsp_ret_rob_id_2[`ROB_ID_WIDTH - 2 : 0]))
                              | (o_rob_dsp_ret_vld[3] & (i == o_rob_dsp_ret_rob_id_3[`ROB_ID_WIDTH - 2 : 0]))
                              | (i_exu_mis_ls_flush & func_rob_old(i_exu_mis_ls_rob_id, rob_rob_id_r[i]) & rob_vld_r[i])
                              | i_csr_trap_flush;
    end
endgenerate

wire [127 : 0] rob_vld_nxt = ((rob_vld_r | rob_vld_set) & (~rob_vld_clr));

wire rob_vld_ena = (rob_req | rob_ret);
gnrl_dfflr #( 
    .DATA_WIDTH   (128),
    .INITIAL_VALUE(0)
) rob_vld_dfflr (rob_vld_ena, rob_vld_nxt, rob_vld_r, clk, rst_n);


//  Modify rob_inst_info_r
wire [`ROB_INST_INFO_WIDTH - 1 : 0] rob_inst_info_wdat_0 = {
                                                                i_dsp_rob_dst_vld_0
                                                            ,   i_dsp_rob_dst_arf_code_0
                                                            ,   i_dsp_rob_dst_prf_code_0
                                                            ,   i_dsp_rob_dst_pprf_code_0
                                                            ,   i_dsp_rob_ld_vld_0
                                                            ,   i_dsp_rob_ld_id_0
                                                            ,   i_dsp_rob_st_vld_0
                                                            ,   i_dsp_rob_st_id_0
                                                            ,   i_dsp_rob_decinfo_bus_0
                                                            ,   i_dsp_rob_predinfo_bus_0
                                                            ,   i_dsp_rob_len[0]
                                                            ,   i_dsp_rob_instr_0
                                                        };

wire [`ROB_INST_INFO_WIDTH - 1 : 0] rob_inst_info_wdat_1 = {
                                                                i_dsp_rob_dst_vld_1
                                                            ,   i_dsp_rob_dst_arf_code_1
                                                            ,   i_dsp_rob_dst_prf_code_1
                                                            ,   i_dsp_rob_dst_pprf_code_1
                                                            ,   i_dsp_rob_ld_vld_1
                                                            ,   i_dsp_rob_ld_id_1
                                                            ,   i_dsp_rob_st_vld_1
                                                            ,   i_dsp_rob_st_id_1
                                                            ,   i_dsp_rob_decinfo_bus_1
                                                            ,   i_dsp_rob_predinfo_bus_1
                                                            ,   i_dsp_rob_len[1]
                                                            ,   i_dsp_rob_instr_1
                                                        };

wire [`ROB_INST_INFO_WIDTH - 1 : 0] rob_inst_info_wdat_2 = {
                                                                i_dsp_rob_dst_vld_2
                                                            ,   i_dsp_rob_dst_arf_code_2
                                                            ,   i_dsp_rob_dst_prf_code_2
                                                            ,   i_dsp_rob_dst_pprf_code_2
                                                            ,   i_dsp_rob_ld_vld_2
                                                            ,   i_dsp_rob_ld_id_2
                                                            ,   i_dsp_rob_st_vld_2
                                                            ,   i_dsp_rob_st_id_2
                                                            ,   i_dsp_rob_decinfo_bus_2
                                                            ,   i_dsp_rob_predinfo_bus_2
                                                            ,   i_dsp_rob_len[2]
                                                            ,   i_dsp_rob_instr_2
                                                        };

wire [`ROB_INST_INFO_WIDTH - 1 : 0] rob_inst_info_wdat_3 = {
                                                                i_dsp_rob_dst_vld_3
                                                            ,   i_dsp_rob_dst_arf_code_3
                                                            ,   i_dsp_rob_dst_prf_code_3
                                                            ,   i_dsp_rob_dst_pprf_code_3
                                                            ,   i_dsp_rob_ld_vld_3
                                                            ,   i_dsp_rob_ld_id_3
                                                            ,   i_dsp_rob_st_vld_3
                                                            ,   i_dsp_rob_st_id_3
                                                            ,   i_dsp_rob_decinfo_bus_3
                                                            ,   i_dsp_rob_predinfo_bus_3
                                                            ,   i_dsp_rob_len[3]
                                                            ,   i_dsp_rob_instr_3
                                                        };

wire [2 * `CORE_PC_WIDTH - 1 : 0] rob_addr_wdat_0 = { 
                                                            i_dsp_rob_taddr_0
                                                        ,   i_dsp_rob_addr_0
                                                    };
wire [2 * `CORE_PC_WIDTH - 1 : 0] rob_addr_wdat_1 = { 
                                                            i_dsp_rob_taddr_1
                                                        ,   i_dsp_rob_addr_1
                                                    };
wire [2 * `CORE_PC_WIDTH - 1 : 0] rob_addr_wdat_2 = { 
                                                            i_dsp_rob_taddr_2
                                                        ,   i_dsp_rob_addr_2
                                                    };
wire [2 * `CORE_PC_WIDTH - 1 : 0] rob_addr_wdat_3 = { 
                                                            i_dsp_rob_taddr_3
                                                        ,   i_dsp_rob_addr_3
                                                    };

wire [127 : 0] rob_inst_ena;
wire [`ROB_INST_INFO_WIDTH - 1 : 0] rob_inst_nxt [127 : 0];
wire [`ROB_ID_WIDTH - 1 : 0] rob_rob_id_nxt [127 : 0];
wire [2 * `CORE_PC_WIDTH - 1 : 0] rob_addr_nxt [127 : 0];

genvar inst_idx;
generate
    for(inst_idx = 0; inst_idx < 128; inst_idx = inst_idx + 1) begin
        assign rob_inst_ena[inst_idx] = (rob_req 
                                      & ((inst_idx == i_dsp_rob_rob_id_0[`ROB_ID_WIDTH - 2 : 0])
                                      |  (inst_idx == i_dsp_rob_rob_id_1[`ROB_ID_WIDTH - 2 : 0])
                                      |  (inst_idx == i_dsp_rob_rob_id_2[`ROB_ID_WIDTH - 2 : 0])
                                      |  (inst_idx == i_dsp_rob_rob_id_3[`ROB_ID_WIDTH - 2 : 0])));
        assign rob_inst_nxt[inst_idx] = ({`ROB_INST_INFO_WIDTH{(inst_idx == i_dsp_rob_rob_id_0[`ROB_ID_WIDTH - 2 : 0])}} & rob_inst_info_wdat_0)
                                      | ({`ROB_INST_INFO_WIDTH{(inst_idx == i_dsp_rob_rob_id_1[`ROB_ID_WIDTH - 2 : 0])}} & rob_inst_info_wdat_1)
                                      | ({`ROB_INST_INFO_WIDTH{(inst_idx == i_dsp_rob_rob_id_2[`ROB_ID_WIDTH - 2 : 0])}} & rob_inst_info_wdat_2)
                                      | ({`ROB_INST_INFO_WIDTH{(inst_idx == i_dsp_rob_rob_id_3[`ROB_ID_WIDTH - 2 : 0])}} & rob_inst_info_wdat_3);
        gnrl_dffl #( 
            .DATA_WIDTH(`ROB_INST_INFO_WIDTH)
        ) rob_inst_dffl (rob_inst_ena[inst_idx], rob_inst_nxt[inst_idx], rob_inst_info_r[inst_idx], clk);

        assign rob_rob_id_nxt[inst_idx] = ({`ROB_ID_WIDTH{(inst_idx == i_dsp_rob_rob_id_0[`ROB_ID_WIDTH - 2 : 0])}} & i_dsp_rob_rob_id_0)
                                        | ({`ROB_ID_WIDTH{(inst_idx == i_dsp_rob_rob_id_1[`ROB_ID_WIDTH - 2 : 0])}} & i_dsp_rob_rob_id_1)
                                        | ({`ROB_ID_WIDTH{(inst_idx == i_dsp_rob_rob_id_2[`ROB_ID_WIDTH - 2 : 0])}} & i_dsp_rob_rob_id_2)
                                        | ({`ROB_ID_WIDTH{(inst_idx == i_dsp_rob_rob_id_3[`ROB_ID_WIDTH - 2 : 0])}} & i_dsp_rob_rob_id_3);
        gnrl_dffl #( 
            .DATA_WIDTH(`ROB_ID_WIDTH)
        ) rob_rob_id_dffl (rob_inst_ena[inst_idx], rob_rob_id_nxt[inst_idx], rob_rob_id_r[inst_idx], clk);
    
        assign rob_addr_nxt[inst_idx] = ({(2 * `CORE_PC_WIDTH){(inst_idx == i_dsp_rob_rob_id_0[`ROB_ID_WIDTH - 2 : 0])}} & rob_addr_wdat_0)
                                      | ({(2 * `CORE_PC_WIDTH){(inst_idx == i_dsp_rob_rob_id_1[`ROB_ID_WIDTH - 2 : 0])}} & rob_addr_wdat_1)
                                      | ({(2 * `CORE_PC_WIDTH){(inst_idx == i_dsp_rob_rob_id_2[`ROB_ID_WIDTH - 2 : 0])}} & rob_addr_wdat_2)
                                      | ({(2 * `CORE_PC_WIDTH){(inst_idx == i_dsp_rob_rob_id_3[`ROB_ID_WIDTH - 2 : 0])}} & rob_addr_wdat_3);
        gnrl_dffl #( 
            .DATA_WIDTH(2 * `CORE_PC_WIDTH)
        ) rob_addr_dffl (rob_inst_ena[inst_idx], rob_rob_id_nxt[inst_idx], rob_rob_id_r[inst_idx], clk);
    end
endgenerate

//  Modify rob_excp_r
wire [127 : 0] rob_excp_ena;
wire [`EXCEPTION_CODE_WIDTH - 1 : 0] rob_excp_nxt [127 : 0];

genvar excp_idx;
generate
    for(excp_idx = 0; excp_idx < 128; excp_idx = excp_idx + 1) begin
        assign rob_excp_ena[excp_idx] = ((i_exu_rob_vld_0 & (excp_idx == i_exu_rob_rob_id_0[`ROB_ID_WIDTH - 2 : 0]))
                                      |  (i_exu_rob_vld_1 & (excp_idx == i_exu_rob_rob_id_1[`ROB_ID_WIDTH - 2 : 0]))
                                      |  (i_exu_rob_vld_2 & (excp_idx == i_exu_rob_rob_id_2[`ROB_ID_WIDTH - 2 : 0]))
                                      |  (i_exu_rob_vld_3 & (excp_idx == i_exu_rob_rob_id_3[`ROB_ID_WIDTH - 2 : 0]))
                                      |  (i_exu_mis_ls_flush & func_rob_old(i_exu_mis_ls_rob_id, rob_rob_id_r[excp_idx]) & rob_vld_r[excp_idx])
                                      |  i_csr_trap_flush);
        assign rob_excp_nxt[excp_idx] = (i_csr_trap_flush | i_exu_mis_ls_flush) ? `EXCEPTION_CODE_WIDTH'd0
                                      : ({`EXCEPTION_CODE_WIDTH{(excp_idx == i_exu_rob_rob_id_0[`ROB_ID_WIDTH - 2 : 0])}} & i_exu_rob_excp_code_0)
                                      | ({`EXCEPTION_CODE_WIDTH{(excp_idx == i_exu_rob_rob_id_1[`ROB_ID_WIDTH - 2 : 0])}} & i_exu_rob_excp_code_1)
                                      | ({`EXCEPTION_CODE_WIDTH{(excp_idx == i_exu_rob_rob_id_2[`ROB_ID_WIDTH - 2 : 0])}} & i_exu_rob_excp_code_2)
                                      | ({`EXCEPTION_CODE_WIDTH{(excp_idx == i_exu_rob_rob_id_3[`ROB_ID_WIDTH - 2 : 0])}} & i_exu_rob_excp_code_3);
        gnrl_dfflr #( 
            .DATA_WIDTH   (`EXCEPTION_CODE_WIDTH),
            .INITIAL_VALUE(0)
        ) rob_excp_dfflr (rob_excp_ena[excp_idx], rob_excp_nxt[excp_idx], rob_excp_r[excp_idx], clk, rst_n);
    end
endgenerate

//
wire [127 : 0] rob_done_set;
wire [127 : 0] rob_done_clr;

genvar j;
generate
    for(j = 0; j < 128; j = j + 1) begin
        assign rob_done_set[j] = (i_exu_rob_vld_0 & (j == i_exu_rob_rob_id_0[`ROB_ID_WIDTH - 2 : 0]))
                               | (i_exu_rob_vld_1 & (j == i_exu_rob_rob_id_1[`ROB_ID_WIDTH - 2 : 0]))
                               | (i_exu_rob_vld_2 & (j == i_exu_rob_rob_id_2[`ROB_ID_WIDTH - 2 : 0]))
                               | (i_exu_rob_vld_3 & (j == i_exu_rob_rob_id_3[`ROB_ID_WIDTH - 2 : 0]));
        assign rob_done_clr[j] = (i_csr_trap_flush
                               | (i_dsp_rob_vld[0] & (j == i_dsp_rob_rob_id_0[`ROB_ID_WIDTH - 2 : 0]))
                               | (i_dsp_rob_vld[1] & (j == i_dsp_rob_rob_id_1[`ROB_ID_WIDTH - 2 : 0]))
                               | (i_dsp_rob_vld[2] & (j == i_dsp_rob_rob_id_2[`ROB_ID_WIDTH - 2 : 0]))
                               | (i_dsp_rob_vld[3] & (j == i_dsp_rob_rob_id_3[`ROB_ID_WIDTH - 2 : 0])));
    end
endgenerate

wire [127 : 0] rob_done_nxt = ((rob_done_r | rob_done_set) & (~rob_done_clr));

wire rob_done_ena = (rob_req | (i_exu_rob_vld_0 | i_exu_rob_vld_1 | i_exu_rob_vld_2 | i_exu_rob_vld_3));

gnrl_dfflr #( 
    .DATA_WIDTH   (128),
    .INITIAL_VALUE(0)
) rob_done_dfflr (rob_done_ena, rob_done_nxt, rob_done_r, clk, rst_n);


//
assign o_rob_exu_addr_0 = rob_addr_r[i_exu_rob_rob_id_addr_0[`ROB_ID_WIDTH - 2 : 0]][`CORE_PC_WIDTH - 1 : 0];
assign o_rob_exu_addr_1 = rob_addr_r[i_exu_rob_rob_id_addr_1[`ROB_ID_WIDTH - 2 : 0]][`CORE_PC_WIDTH - 1 : 0];
assign o_rob_exu_addr_2 = rob_addr_r[i_exu_rob_rob_id_addr_2[`ROB_ID_WIDTH - 2 : 0]][`CORE_PC_WIDTH - 1 : 0];
wire [2 * `CORE_PC_WIDTH - 1 : 0] rob_rob_addr = rob_addr_r[rob_ret_ptr[`ROB_ID_WIDTH - 2 : 0]];
assign o_rob_csr_instr = rob_inst_info_r[rob_ret_ptr[`ROB_ID_WIDTH - 2 : 0]][`INSTR_WIDTH - 1 : 0];

//
wire [`ROB_ID_WIDTH - 1 : 0] rob_alloc_ptr, rob_ret_ptr;

assign rob_alloc_ptr = i_dsp_rob_dsp_id;
assign rob_ret_ptr = i_dsp_rob_ret_id;

wire [`ROB_ID_WIDTH - 2 : 0] rob_ret_sel_0 = rob_ret_ptr[`ROB_ID_WIDTH - 2 : 0];
wire [`ROB_ID_WIDTH - 2 : 0] rob_ret_sel_1 = (rob_ret_ptr[`ROB_ID_WIDTH - 2 : 0] + (`ROB_ID_WIDTH - 1)'d1);
wire [`ROB_ID_WIDTH - 2 : 0] rob_ret_sel_2 = (rob_ret_ptr[`ROB_ID_WIDTH - 2 : 0] + (`ROB_ID_WIDTH - 1)'d2);
wire [`ROB_ID_WIDTH - 2 : 0] rob_ret_sel_3 = (rob_ret_ptr[`ROB_ID_WIDTH - 2 : 0] + (`ROB_ID_WIDTH - 1)'d3);

wire [3 : 0] rob_ret_constraint;
assign rob_ret_constraint[3] = (((rob_inst_info_r[rob_ret_sel_3][`ROB_INST_INFO_DECINFO_EXEC_UNIT] == `UOPINFO_ALU) 
                             &   (rob_inst_info_r[rob_ret_sel_3][`ROB_INST_INFO_DECINFO_ALU_ECALL] 
                             |    rob_inst_info_r[rob_ret_sel_3][`ROB_INST_INFO_DECINFO_ALU_EBRK] 
                             |    rob_inst_info_r[rob_ret_sel_3][`ROB_INST_INFO_DECINFO_ALU_WFI] ))
                             |  ((rob_inst_info_r[rob_ret_sel_3][`ROB_INST_INFO_DECINFO_EXEC_UNIT] == `UOPINFO_BJP) 
                             & (rob_inst_info_r[rob_ret_sel_3][`ROB_INST_INFO_DECINFO_BJP_MRET]  
                             | rob_inst_info_r[rob_ret_sel_3][`ROB_INST_INFO_DECINFO_BJP_SRET] 
                             | rob_inst_info_r[rob_ret_sel_3][`ROB_INST_INFO_DECINFO_BJP_URET]))
                             |    rob_inst_info_r[rob_ret_sel_3][`ROB_INST_INFO_DECINFO_ILGL]);
assign rob_ret_constraint[2] = (((rob_inst_info_r[rob_ret_sel_2][`ROB_INST_INFO_DECINFO_EXEC_UNIT] == `UOPINFO_ALU) 
                             &   (rob_inst_info_r[rob_ret_sel_2][`ROB_INST_INFO_DECINFO_ALU_ECALL] 
                             |    rob_inst_info_r[rob_ret_sel_2][`ROB_INST_INFO_DECINFO_ALU_EBRK]
                             |    rob_inst_info_r[rob_ret_sel_2][`ROB_INST_INFO_DECINFO_ALU_WFI]))
                             |  ((rob_inst_info_r[rob_ret_sel_2][`ROB_INST_INFO_DECINFO_EXEC_UNIT] == `UOPINFO_BJP)
                             &   (rob_inst_info_r[rob_ret_sel_2][`ROB_INST_INFO_DECINFO_BJP_MRET]
                             |    rob_inst_info_r[rob_ret_sel_2][`ROB_INST_INFO_DECINFO_BJP_SRET]
                             |    rob_inst_info_r[rob_ret_sel_2][`ROB_INST_INFO_DECINFO_BJP_URET]))
                             |    rob_inst_info_r[rob_ret_sel_2][`ROB_INST_INFO_DECINFO_ILGL]);
assign rob_ret_constraint[1] = (((rob_inst_info_r[rob_ret_sel_1][`ROB_INST_INFO_DECINFO_EXEC_UNIT] == `UOPINFO_ALU) 
                             &   (rob_inst_info_r[rob_ret_sel_1][`ROB_INST_INFO_DECINFO_ALU_ECALL] 
                             |    rob_inst_info_r[rob_ret_sel_1][`ROB_INST_INFO_DECINFO_ALU_EBRK]
                             |    rob_inst_info_r[rob_ret_sel_1][`ROB_INST_INFO_DECINFO_ALU_WFI]))
                             |  ((rob_inst_info_r[rob_ret_sel_1][`ROB_INST_INFO_DECINFO_EXEC_UNIT] == `UOPINFO_BJP)
                             &   (rob_inst_info_r[rob_ret_sel_1][`ROB_INST_INFO_DECINFO_BJP_MRET]
                             |    rob_inst_info_r[rob_ret_sel_1][`ROB_INST_INFO_DECINFO_BJP_SRET]
                             |    rob_inst_info_r[rob_ret_sel_1][`ROB_INST_INFO_DECINFO_BJP_URET]))
                             |    rob_inst_info_r[rob_ret_sel_1][`ROB_INST_INFO_DECINFO_ILGL]);
assign rob_ret_constraint[0] = (((rob_inst_info_r[rob_ret_sel_0][`ROB_INST_INFO_DECINFO_EXEC_UNIT] == `UOPINFO_ALU) 
                             &   (rob_inst_info_r[rob_ret_sel_0][`ROB_INST_INFO_DECINFO_ALU_ECALL] 
                             |    rob_inst_info_r[rob_ret_sel_0][`ROB_INST_INFO_DECINFO_ALU_EBRK]
                             |    rob_inst_info_r[rob_ret_sel_0][`ROB_INST_INFO_DECINFO_ALU_WFI]))
                             |  ((rob_inst_info_r[rob_ret_sel_0][`ROB_INST_INFO_DECINFO_EXEC_UNIT] == `UOPINFO_BJP)
                             &   (rob_inst_info_r[rob_ret_sel_0][`ROB_INST_INFO_DECINFO_BJP_MRET]
                             |    rob_inst_info_r[rob_ret_sel_0][`ROB_INST_INFO_DECINFO_BJP_SRET]
                             |    rob_inst_info_r[rob_ret_sel_0][`ROB_INST_INFO_DECINFO_BJP_URET]))
                             |    rob_inst_info_r[rob_ret_sel_0][`ROB_INST_INFO_DECINFO_ILGL]);

//
wire rob_ret_rdy_0 = (rob_vld_r[rob_ret_sel_0] & rob_done_r[rob_ret_sel_0] & (~(|rob_excp_r[rob_ret_sel_0])));
wire rob_ret_rdy_1 = (rob_ret_rdy_0 & (~(|rob_ret_constraint[1 : 0]))
                   &  rob_vld_r[rob_ret_sel_1]
                   &  rob_done_r[rob_ret_sel_1]
                   & (~(|rob_excp_r[rob_ret_sel_1])));
wire rob_ret_rdy_2 = (rob_ret_rdy_1 & (~rob_ret_constraint[2])
                   &  rob_vld_r[rob_ret_sel_2]
                   &  rob_done_r[rob_ret_sel_2]
                   & (~(|rob_excp_r[rob_ret_sel_2])));
wire rob_ret_rdy_3 = (rob_ret_rdy_2 & (~rob_ret_constraint[3])
                   &  rob_vld_r[rob_ret_sel_3]
                   &  rob_done_r[rob_ret_sel_3]
                   & (~(|rob_excp_r[rob_ret_sel_3])));

assign o_rob_csr_trap_addr = rob_rob_addr[`CORE_PC_WIDTH - 1 : 0];

//
assign o_rob_ren_ret_vld = { 
                                (rob_ret_rdy_3 & (rob_inst_info_r[rob_ret_sel_3][`ROB_INST_INFO_DST_VLD]) & (~rob_sta_rec_r))
                            ,   (rob_ret_rdy_2 & (rob_inst_info_r[rob_ret_sel_2][`ROB_INST_INFO_DST_VLD]) & (~rob_sta_rec_r))
                            ,   (rob_ret_rdy_1 & (rob_inst_info_r[rob_ret_sel_1][`ROB_INST_INFO_DST_VLD]) & (~rob_sta_rec_r))
                            ,   (rob_ret_rdy_0 & (rob_inst_info_r[rob_ret_sel_0][`ROB_INST_INFO_DST_VLD]) & (~rob_sta_rec_r))
                        };

assign o_rob_ren_ret_dst_vld_0  = rob_inst_info_r[rob_ret_sel_0][`ROB_INST_INFO_DST_VLD];
assign o_rob_ren_ret_arf_code_0 = rob_inst_info_r[rob_ret_sel_0][`ROB_INST_INFO_DST_ARF_CODE];
assign o_rob_ren_ret_prf_code_0 = rob_inst_info_r[rob_ret_sel_0][`ROB_INST_INFO_DST_PRF_CODE];
assign o_rob_ren_ret_dst_vld_1  = rob_inst_info_r[rob_ret_sel_1][`ROB_INST_INFO_DST_VLD];
assign o_rob_ren_ret_arf_code_1 = rob_inst_info_r[rob_ret_sel_1][`ROB_INST_INFO_DST_ARF_CODE];
assign o_rob_ren_ret_prf_code_1 = rob_inst_info_r[rob_ret_sel_1][`ROB_INST_INFO_DST_PRF_CODE];
assign o_rob_ren_ret_dst_vld_2  = rob_inst_info_r[rob_ret_sel_2][`ROB_INST_INFO_DST_VLD];
assign o_rob_ren_ret_arf_code_2 = rob_inst_info_r[rob_ret_sel_2][`ROB_INST_INFO_DST_ARF_CODE];
assign o_rob_ren_ret_prf_code_2 = rob_inst_info_r[rob_ret_sel_2][`ROB_INST_INFO_DST_PRF_CODE];
assign o_rob_ren_ret_dst_vld_3  = rob_inst_info_r[rob_ret_sel_3][`ROB_INST_INFO_DST_VLD];
assign o_rob_ren_ret_arf_code_3 = rob_inst_info_r[rob_ret_sel_3][`ROB_INST_INFO_DST_ARF_CODE];
assign o_rob_ren_ret_prf_code_3 = rob_inst_info_r[rob_ret_sel_3][`ROB_INST_INFO_DST_PRF_CODE];

//
wire rob_sta_rec_r;
wire rob_sta_rec_set = i_exu_mis_ls_flush;
wire rob_sta_rec_clr = rob_rec_done;
wire rob_sta_rec_ena = (rob_sta_rec_set | rob_sta_rec_clr);
wire rob_sta_rec_nxt = (rob_sta_rec_set | (~rob_sta_rec_clr));

gnrl_dfflr #(
    .DATA_WIDTH   (1),
    .INITIAL_VALUE(0)
) rob_sta_rec_dfflr (rob_sta_rec_ena, rob_sta_rec_nxt, rob_sta_rec_r, clk, rst_n);

//
wire [`ROB_ID_WIDTH - 1 : 0] rob_rec_ptr_r, rob_rec_ptr_nxt;

wire rob_rec_ptr_ena = (i_exu_mis_ls_flush | ((~rob_rec_done) & rob_sta_rec_r));
assign rob_rec_ptr_nxt = i_exu_mis_ls_flush ? i_exu_mis_ls_rob_id + `ROB_ID_WIDTH'd1
                       : rob_rec_ptr_r + `ROB_ID_WIDTH'd4;

gnrl_dffl #(
    .DATA_WIDTH(`ROB_ID_WIDTH)
) rob_rec_ptr_dffl (rob_rec_ptr_ena, rob_rec_ptr_nxt, rob_rec_ptr_r, clk);

//
wire [31 : 0] rob_rec_vec_r, rob_rec_vec_nxt;

wire [`ROB_ID_WIDTH - 1 : 0] rob_rec_sel_0 = rob_rec_ptr_r;
wire [`ROB_ID_WIDTH - 1 : 0] rob_rec_sel_1 = (rob_rec_ptr_r + `ROB_ID_WIDTH'd1);
wire [`ROB_ID_WIDTH - 1 : 0] rob_rec_sel_2 = (rob_rec_ptr_r + `ROB_ID_WIDTH'd2);
wire [`ROB_ID_WIDTH - 1 : 0] rob_rec_sel_3 = (rob_rec_ptr_r + `ROB_ID_WIDTH'd3);

assign rob_rec_vec_nxt = i_exu_mis_ls_flush ? 32'd0
                       : ({32{(o_rob_ren_rec_vld[0] & (~rob_inst_info_r[rob_rec_sel_0[`ROB_ID_WIDTH - 2 : 0]][`ROB_INST_INFO_DST_ARF_CODE]))}} & func_vec32(rob_inst_info_r[rob_rec_sel_0[`ROB_ID_WIDTH - 2 : 0]][`ROB_INST_INFO_DST_ARF_CODE]))
                       | ({32{(o_rob_ren_rec_vld[1] & (~rob_inst_info_r[rob_rec_sel_1[`ROB_ID_WIDTH - 2 : 0]][`ROB_INST_INFO_DST_ARF_CODE]))}} & func_vec32(rob_inst_info_r[rob_rec_sel_1[`ROB_ID_WIDTH - 2 : 0]][`ROB_INST_INFO_DST_ARF_CODE]))
                       | ({32{(o_rob_ren_rec_vld[2] & (~rob_inst_info_r[rob_rec_sel_2[`ROB_ID_WIDTH - 2 : 0]][`ROB_INST_INFO_DST_ARF_CODE]))}} & func_vec32(rob_inst_info_r[rob_rec_sel_2[`ROB_ID_WIDTH - 2 : 0]][`ROB_INST_INFO_DST_ARF_CODE]))
                       | ({32{(o_rob_ren_rec_vld[3] & (~rob_inst_info_r[rob_rec_sel_3[`ROB_ID_WIDTH - 2 : 0]][`ROB_INST_INFO_DST_ARF_CODE]))}} & func_vec32(rob_inst_info_r[rob_rec_sel_3[`ROB_ID_WIDTH - 2 : 0]][`ROB_INST_INFO_DST_ARF_CODE]));

gnrl_dffl #( 
    .DATA_WIDTH(32)
) rob_rec_vec_dffl (rob_rec_ptr_ena, rob_rec_vec_nxt, rob_rec_vec_r, clk);


wire rob_rec_done = (~func_rob_old(rob_rec_ptr_r, rob_alloc_ptr));

//
assign o_rob_ren_rec_vld = {
                                ((func_rob_old(rob_rec_sel_3, rob_alloc_ptr) & rob_vld_r[rob_rec_sel_3[`ROB_ID_WIDTH - 2 : 0]] & rob_inst_info_r[rob_rec_sel_3[`ROB_ID_WIDTH - 2 : 0]][`ROB_INST_INFO_DST_VLD] & (~rob_rec_vec_r[rob_inst_info_r[rob_rec_sel_3[`ROB_ID_WIDTH - 2 : 0]][`ROB_INST_INFO_DST_ARF_CODE]]) & rob_sta_rec_r))
                            ,   ((func_rob_old(rob_rec_sel_2, rob_alloc_ptr) & rob_vld_r[rob_rec_sel_2[`ROB_ID_WIDTH - 2 : 0]] & rob_inst_info_r[rob_rec_sel_2[`ROB_ID_WIDTH - 2 : 0]][`ROB_INST_INFO_DST_VLD] & (~rob_rec_vec_r[rob_inst_info_r[rob_rec_sel_2[`ROB_ID_WIDTH - 2 : 0]][`ROB_INST_INFO_DST_ARF_CODE]]) & rob_sta_rec_r))
                            ,   ((func_rob_old(rob_rec_sel_1, rob_alloc_ptr) & rob_vld_r[rob_rec_sel_1[`ROB_ID_WIDTH - 2 : 0]] & rob_inst_info_r[rob_rec_sel_1[`ROB_ID_WIDTH - 2 : 0]][`ROB_INST_INFO_DST_VLD] & (~rob_rec_vec_r[rob_inst_info_r[rob_rec_sel_1[`ROB_ID_WIDTH - 2 : 0]][`ROB_INST_INFO_DST_ARF_CODE]]) & rob_sta_rec_r))
                            ,   ((func_rob_old(rob_rec_sel_0, rob_alloc_ptr) & rob_vld_r[rob_rec_sel_0[`ROB_ID_WIDTH - 2 : 0]] & rob_inst_info_r[rob_rec_sel_0[`ROB_ID_WIDTH - 2 : 0]][`ROB_INST_INFO_DST_VLD] & (~rob_rec_vec_r[rob_inst_info_r[rob_rec_sel_0[`ROB_ID_WIDTH - 2 : 0]][`ROB_INST_INFO_DST_ARF_CODE]]) & rob_sta_rec_r))
                            };

assign o_rob_ren_rec_arf_code_0 = rob_inst_info_r[rob_rec_sel_0[`ROB_ID_WIDTH - 2 : 0]][`ROB_INST_INFO_DST_ARF_CODE];
assign o_rob_ren_rec_prf_code_0 = rob_inst_info_r[rob_rec_sel_0[`ROB_ID_WIDTH - 2 : 0]][`ROB_INST_INFO_DST_PPRF_CODE];
assign o_rob_ren_rec_arf_code_1 = rob_inst_info_r[rob_rec_sel_1[`ROB_ID_WIDTH - 2 : 0]][`ROB_INST_INFO_DST_ARF_CODE];
assign o_rob_ren_rec_prf_code_1 = rob_inst_info_r[rob_rec_sel_1[`ROB_ID_WIDTH - 2 : 0]][`ROB_INST_INFO_DST_PPRF_CODE];
assign o_rob_ren_rec_arf_code_2 = rob_inst_info_r[rob_rec_sel_2[`ROB_ID_WIDTH - 2 : 0]][`ROB_INST_INFO_DST_ARF_CODE];
assign o_rob_ren_rec_prf_code_2 = rob_inst_info_r[rob_rec_sel_2[`ROB_ID_WIDTH - 2 : 0]][`ROB_INST_INFO_DST_PPRF_CODE];
assign o_rob_ren_rec_arf_code_3 = rob_inst_info_r[rob_rec_sel_3[`ROB_ID_WIDTH - 2 : 0]][`ROB_INST_INFO_DST_ARF_CODE];
assign o_rob_ren_rec_prf_code_3 = rob_inst_info_r[rob_rec_sel_3[`ROB_ID_WIDTH - 2 : 0]][`ROB_INST_INFO_DST_PPRF_CODE];

assign o_rob_ren_mis_vld = {
                                ((func_rob_old(rob_rec_sel_3, rob_alloc_ptr)) & rob_inst_info_r[rob_rec_sel_3[`ROB_ID_WIDTH - 2 : 0]][`ROB_INST_INFO_DST_VLD] & rob_sta_rec_r)
                            ,   ((func_rob_old(rob_rec_sel_2, rob_alloc_ptr)) & rob_inst_info_r[rob_rec_sel_2[`ROB_ID_WIDTH - 2 : 0]][`ROB_INST_INFO_DST_VLD] & rob_sta_rec_r)
                            ,   ((func_rob_old(rob_rec_sel_1, rob_alloc_ptr)) & rob_inst_info_r[rob_rec_sel_1[`ROB_ID_WIDTH - 2 : 0]][`ROB_INST_INFO_DST_VLD] & rob_sta_rec_r)
                            ,   ((func_rob_old(rob_rec_sel_0, rob_alloc_ptr)) & rob_inst_info_r[rob_rec_sel_0[`ROB_ID_WIDTH - 2 : 0]][`ROB_INST_INFO_DST_VLD] & rob_sta_rec_r)
                            };

assign o_rob_ren_mis_arf_code_0 = o_rob_ren_rec_arf_code_0;
assign o_rob_ren_mis_prf_code_0 = rob_inst_info_r[rob_rec_sel_0[`ROB_ID_WIDTH - 2 : 0]][`ROB_INST_INFO_DST_PRF_CODE];
assign o_rob_ren_mis_arf_code_1 = o_rob_ren_rec_arf_code_1;
assign o_rob_ren_mis_prf_code_1 = rob_inst_info_r[rob_rec_sel_1[`ROB_ID_WIDTH - 2 : 0]][`ROB_INST_INFO_DST_PRF_CODE];
assign o_rob_ren_mis_arf_code_2 = o_rob_ren_rec_arf_code_2;
assign o_rob_ren_mis_prf_code_2 = rob_inst_info_r[rob_rec_sel_2[`ROB_ID_WIDTH - 2 : 0]][`ROB_INST_INFO_DST_PRF_CODE];
assign o_rob_ren_mis_arf_code_3 = o_rob_ren_rec_arf_code_3;
assign o_rob_ren_mis_prf_code_3 = rob_inst_info_r[rob_rec_sel_3[`ROB_ID_WIDTH - 2 : 0]][`ROB_INST_INFO_DST_PRF_CODE];

//
assign o_rob_dsp_mis_ld_vld = rob_inst_info_r[i_exu_mis_rob_id[`ROB_ID_WIDTH - 2 : 0]][`ROB_INST_INFO_LD_VLD];
assign o_rob_dsp_mis_ld_id  = rob_inst_info_r[i_exu_mis_rob_id[`ROB_ID_WIDTH - 2 : 0]][`ROB_INST_INFO_LD_ID ];
assign o_rob_dsp_mis_st_vld = rob_inst_info_r[i_exu_mis_rob_id[`ROB_ID_WIDTH - 2 : 0]][`ROB_INST_INFO_ST_VLD];
assign o_rob_dsp_mis_st_id  = rob_inst_info_r[i_exu_mis_rob_id[`ROB_ID_WIDTH - 2 : 0]][`ROB_INST_INFO_ST_ID ];

assign o_rob_exu_ls_addr = rob_addr_r[i_exu_ls_rob_id[`ROB_ID_WIDTH - 2 : 0]][`CORE_PC_WIDTH - 1 : 0];

assign o_rob_dsp_ret_vld      = o_rob_ren_ret_vld;
assign o_rob_dsp_ret_rob_id_0 = rob_ret_sel_0;
assign o_rob_dsp_ret_ld_vld_0 = rob_inst_info_r[rob_ret_sel_0[`ROB_ID_WIDTH - 2 : 0]][`ROB_INST_INFO_LD_VLD];
assign o_rob_dsp_ret_ld_id_0  = rob_inst_info_r[rob_ret_sel_0[`ROB_ID_WIDTH - 2 : 0]][`ROB_INST_INFO_LD_ID];
assign o_rob_dsp_ret_st_vld_0 = rob_inst_info_r[rob_ret_sel_0[`ROB_ID_WIDTH - 2 : 0]][`ROB_INST_INFO_ST_VLD];
assign o_rob_dsp_ret_st_id_0  = rob_inst_info_r[rob_ret_sel_0[`ROB_ID_WIDTH - 2 : 0]][`ROB_INST_INFO_ST_ID];
assign o_rob_dsp_ret_rob_id_1 = rob_ret_sel_1;
assign o_rob_dsp_ret_ld_vld_1 = rob_inst_info_r[rob_ret_sel_1[`ROB_ID_WIDTH - 2 : 0]][`ROB_INST_INFO_LD_VLD];
assign o_rob_dsp_ret_ld_id_1  = rob_inst_info_r[rob_ret_sel_1[`ROB_ID_WIDTH - 2 : 0]][`ROB_INST_INFO_LD_ID];
assign o_rob_dsp_ret_st_vld_1 = rob_inst_info_r[rob_ret_sel_1[`ROB_ID_WIDTH - 2 : 0]][`ROB_INST_INFO_ST_VLD];
assign o_rob_dsp_ret_st_id_1  = rob_inst_info_r[rob_ret_sel_1[`ROB_ID_WIDTH - 2 : 0]][`ROB_INST_INFO_ST_ID];
assign o_rob_dsp_ret_rob_id_2 = rob_ret_sel_2;
assign o_rob_dsp_ret_ld_vld_2 = rob_inst_info_r[rob_ret_sel_2[`ROB_ID_WIDTH - 2 : 0]][`ROB_INST_INFO_LD_VLD];
assign o_rob_dsp_ret_ld_id_2  = rob_inst_info_r[rob_ret_sel_2[`ROB_ID_WIDTH - 2 : 0]][`ROB_INST_INFO_LD_ID];
assign o_rob_dsp_ret_st_vld_2 = rob_inst_info_r[rob_ret_sel_2[`ROB_ID_WIDTH - 2 : 0]][`ROB_INST_INFO_ST_VLD];
assign o_rob_dsp_ret_st_id_2  = rob_inst_info_r[rob_ret_sel_2[`ROB_ID_WIDTH - 2 : 0]][`ROB_INST_INFO_ST_ID];
assign o_rob_dsp_ret_rob_id_3 = rob_ret_sel_3;
assign o_rob_dsp_ret_ld_vld_3 = rob_inst_info_r[rob_ret_sel_3[`ROB_ID_WIDTH - 2 : 0]][`ROB_INST_INFO_LD_VLD];
assign o_rob_dsp_ret_ld_id_3  = rob_inst_info_r[rob_ret_sel_3[`ROB_ID_WIDTH - 2 : 0]][`ROB_INST_INFO_LD_ID];
assign o_rob_dsp_ret_st_vld_3 = rob_inst_info_r[rob_ret_sel_3[`ROB_ID_WIDTH - 2 : 0]][`ROB_INST_INFO_ST_VLD];
assign o_rob_dsp_ret_st_id_3  = rob_inst_info_r[rob_ret_sel_3[`ROB_ID_WIDTH - 2 : 0]][`ROB_INST_INFO_ST_ID];

//
wire o_low_power_state = ((rob_inst_info_r[rob_ret_sel_0[`ROB_ID_WIDTH - 2 : 0]][`ROB_INST_INFO_DECINFO_EXEC_UNIT] == `UOPINFO_ALU) 
                         & (rob_inst_info_r[rob_ret_sel_0[`ROB_ID_WIDTH - 2 : 0]][`ROB_INST_INFO_DECINFO_ALU_WFI])
                         & o_rob_ren_ret_vld[0]);

//
wire rob_fencei_flush = (rob_inst_info_r[rob_ret_sel_0[`ROB_ID_WIDTH - 2 : 0]][`ROB_INST_INFO_DECINFO_EXEC_UNIT] === `UOPINFO_ALU)
                      & (rob_inst_info_r[rob_ret_sel_0[`ROB_ID_WIDTH - 2 : 0]][`ROB_INST_INFO_DECNIFO_ALU_FENCE_I])
                      & o_rob_ren_ret_vld[0];
//
assign o_rob_itlb_flush = (((rob_inst_info_r[rob_ret_sel_0[`ROB_ID_WIDTH - 2 : 0]][`ROB_INST_INFO_DECINFO_EXEC_UNIT] === `UOPINFO_ALU)
                        &   (rob_inst_info_r[rob_ret_sel_0[`ROB_ID_WIDTH - 2 : 0]][`ROB_INST_INFO_DECINFO_ALU_SFENCEVMA]))
                        |    rob_fencei_flush);
assign o_rob_itlb_src1  = ({32{(~rob_fencei_flush)}} & i_exu_rob_fence_src1);
assign o_rob_itlb_src2  = ({32{(~rob_fencei_flush)}} & i_exu_rob_fence_src2);
assign o_rob_dtlb_flush = o_rob_itlb_flush;
assign o_rob_dtlb_src1  = o_rob_itlb_src1;
assign o_rob_dtlb_src2  = o_rob_itlb_src2;
assign o_rob_mmu_flush  = o_rob_dtlb_flush;
assign o_rob_mmu_src1   = o_rob_dtlb_src1;
assign o_rob_mmu_src2   = o_rob_dtlb_src2;

// 
wire rob_itlb_flush_flag_r;
wire rob_itlb_flush_flag_set = i_itlb_rob_flush_done;
wire rob_itlb_flush_flag_clr = o_rob_csr_sfence_vma_flush;
wire rob_itlb_flush_flag_ena = (rob_itlb_flush_flag_set | rob_itlb_flush_flag_clr);
wire rob_itlb_flush_flag_nxt = (rob_itlb_flush_flag_set | (~rob_itlb_flush_flag_clr));

gnrl_dfflr #(
    .DATA_WIDTH   (1),
    .INITIAL_VALUE(0)
) rob_itlb_flush_flag_dfflr (rob_itlb_flush_flag_ena, rob_itlb_flush_flag_nxt, rob_itlb_flush_flag_r, clk, rst_n);

//
wire rob_dtlb_flush_flag_r;
wire rob_dtlb_flush_flag_set = i_dtlb_rob_flush_done;
wire rob_dtlb_flush_flag_clr = o_rob_csr_sfence_vma_flush;
wire rob_dtlb_flush_flag_ena = (rob_dtlb_flush_flag_set | rob_dtlb_flush_flag_clr);
wire rob_dtlb_flush_flag_nxt = (rob_dtlb_flush_flag_set | (~rob_dtlb_flush_flag_clr));

gnrl_dfflr #(
    .DATA_WIDTH   (1),
    .INITIAL_VALUE(0)
) rob_dtlb_flush_flag_dfflr (rob_dtlb_flush_flag_ena, rob_dtlb_flush_flag_nxt, rob_dtlb_flush_flag_r, clk, rst_n);

//
wire rob_mmu_flush_flag_r;
wire rob_mmu_flush_flag_set = i_mmu_rob_flush_done;
wire rob_mmu_flush_flag_clr = o_rob_csr_sfence_vma_flush;
wire rob_mmu_flush_flag_ena = (rob_mmu_flush_flag_set | rob_mmu_flush_flag_clr);
wire rob_mmu_flush_flag_nxt = (rob_mmu_flush_flag_set | (~rob_mmu_flush_flag_clr));

gnrl_dfflr #(
    .DATA_WIDTH   (1),
    .INITIAL_VALUE(0)
) rob_mmu_flush_flag_dfflr (rob_mmu_flush_flag_ena, rob_mmu_flush_flag_nxt, rob_mmu_flush_flag_r, clk, rst_n);

assign o_rob_csr_sfence_vma_flush = (rob_itlb_flush_flag_r & rob_dtlb_flush_flag_r & rob_mmu_flush_flag_r);


//

assign o_rob_rsv_csr_ret   = ((rob_inst_info_r[rob_ret_sel_0[`ROB_ID_WIDTH - 2 : 0]][`ROB_INST_INFO_DECINFO_EXEC_UNIT] == `UOPINFO_CSR)
                           &  o_rob_ren_ret_vld[0]);
assign o_rob_rsv_fence_ret = ((rob_inst_info_r[rob_ret_sel_0[`ROB_ID_WIDTH - 2 : 0]][`ROB_INST_INFO_DECINFO_EXEC_UNIT] == `UOPINFO_ALU)
                           &  (rob_inst_info_r[rob_ret_sel_0[`ROB_ID_WIDTH - 2 : 0]][`ROB_INST_INFO_DECINFO_ALU_FENCE]
                           |   rob_inst_info_r[rob_ret_sel_0[`ROB_ID_WIDTH - 2 : 0]][`ROB_INST_INFO_DECNIFO_ALU_FENCE_I])
                           &  o_rob_ren_ret_vld[0]); 

assign o_rob_csr_len  = rob_inst_info_r[rob_ret_sel_0[`ROB_ID_WIDTH - 2 : 0]][`ROB_INST_INFO_LEN];
assign o_rob_csr_mret = (rob_inst_info_r[rob_ret_sel_0[`ROB_ID_WIDTH - 2 : 0]][`ROB_INST_INFO_DECINFO_EXEC_UNIT] == `UOPINFO_BJP)
                      & (rob_inst_info_r[rob_ret_sel_0[`ROB_ID_WIDTH - 2 : 0]][`ROB_INST_INFO_DECINFO_BJP_MRET])
                      & o_rob_ren_ret_vld[0];
assign o_rob_csr_sret = (rob_inst_info_r[rob_ret_sel_0[`ROB_ID_WIDTH - 2 : 0]][`ROB_INST_INFO_DECINFO_EXEC_UNIT] == `UOPINFO_BJP)
                      & (rob_inst_info_r[rob_ret_sel_0[`ROB_ID_WIDTH - 2 : 0]][`ROB_INST_INFO_DECINFO_BJP_SRET])
                      & o_rob_ren_ret_vld[0];
assign o_rob_csr_uret = (rob_inst_info_r[rob_ret_sel_0[`ROB_ID_WIDTH - 2 : 0]][`ROB_INST_INFO_DECINFO_EXEC_UNIT] == `UOPINFO_BJP)
                      & (rob_inst_info_r[rob_ret_sel_0[`ROB_ID_WIDTH - 2 : 0]][`ROB_INST_INFO_DECINFO_BJP_URET])
                      & o_rob_ren_ret_vld[0];
assign o_rob_csr_wfi  = (rob_inst_info_r[rob_ret_sel_0[`ROB_ID_WIDTH - 2 : 0]][`ROB_INST_INFO_DECINFO_EXEC_UNIT] == `UOPINFO_ALU)
                      & (rob_inst_info_r[rob_ret_sel_0[`ROB_ID_WIDTH - 2 : 0]][`ROB_INST_INFO_DECINFO_ALU_WFI])
                      & o_rob_ren_ret_vld[0];
assign o_rob_csr_int_vld = (rob_status_info_r[rob_ret_sel_0[`ROB_ID_WIDTH - 2 : 0]]);
assign o_rob_csr_excp_code = (rob_inst_info_r[rob_ret_sel_0[`ROB_ID_WIDTH - 2 : 0]][`ROB_INST_INFO_EXCEPTION_CODE]);
assign o_rob_csr_exc_vld = (|o_rob_csr_excp_code);
assign o_rob_exu_s_ret = i_exu_rob_st_ret_done;


//  Functions
function func_rob_old;
    input [7 : 0] rob_id_a;
    input [7 : 0] rob_id_b;

    func_rob_old = (rob_id_a[7] ^ rob_id_b[7]) ? (rob_id_a[6 : 0] >= rob_id_b[6 : 0]) : (rob_id_a[6 : 0] < rob_id_b[6 : 0]);
    
endfunction

function [31 : 0] func_vec32;
    input [4 : 0] index;

    case (index)
        5'd0  : func_vec32 = 32'b00000000000000000000000000000001;
        5'd1  : func_vec32 = 32'b00000000000000000000000000000010;
        5'd2  : func_vec32 = 32'b00000000000000000000000000000100;
        5'd3  : func_vec32 = 32'b00000000000000000000000000001000;
        5'd4  : func_vec32 = 32'b00000000000000000000000000010000;
        5'd5  : func_vec32 = 32'b00000000000000000000000000100000;
        5'd6  : func_vec32 = 32'b00000000000000000000000001000000;
        5'd7  : func_vec32 = 32'b00000000000000000000000010000000;
        5'd8  : func_vec32 = 32'b00000000000000000000000100000000;
        5'd9  : func_vec32 = 32'b00000000000000000000001000000000;
        5'd10 : func_vec32 = 32'b00000000000000000000010000000000;
        5'd11 : func_vec32 = 32'b00000000000000000000100000000000;
        5'd12 : func_vec32 = 32'b00000000000000000001000000000000;
        5'd13 : func_vec32 = 32'b00000000000000000010000000000000;
        5'd14 : func_vec32 = 32'b00000000000000000100000000000000;
        5'd15 : func_vec32 = 32'b00000000000000001000000000000000;
        5'd16 : func_vec32 = 32'b00000000000000010000000000000000;
        5'd17 : func_vec32 = 32'b00000000000000100000000000000000;
        5'd18 : func_vec32 = 32'b00000000000001000000000000000000;
        5'd19 : func_vec32 = 32'b00000000000010000000000000000000;
        5'd20 : func_vec32 = 32'b00000000000100000000000000000000;
        5'd21 : func_vec32 = 32'b00000000001000000000000000000000;
        5'd22 : func_vec32 = 32'b00000000010000000000000000000000;
        5'd23 : func_vec32 = 32'b00000000100000000000000000000000;
        5'd24 : func_vec32 = 32'b00000001000000000000000000000000;
        5'd25 : func_vec32 = 32'b00000010000000000000000000000000;
        5'd26 : func_vec32 = 32'b00000100000000000000000000000000;
        5'd27 : func_vec32 = 32'b00001000000000000000000000000000;
        5'd28 : func_vec32 = 32'b00010000000000000000000000000000;
        5'd29 : func_vec32 = 32'b00100000000000000000000000000000;
        5'd30 : func_vec32 = 32'b01000000000000000000000000000000;
        5'd31 : func_vec32 = 32'b10000000000000000000000000000000;
        default: 
            func_vec32 = 32'd0;
    endcase

endfunction

endmodule   //  rob_module

`endif  /*  !__ROB_ROB_V__!     */
