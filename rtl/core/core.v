`ifdef __CORE_CORE_V__

module core_module ( 
    input                                   clk,
    input                                   rst_n
);

/***************** Stage 1 *********************/
wire o_ifu_icache_vld;
wire [1 : 0] o_ifu_icache_id;
wire [`CORE_PC_WIDTH - 1 : 0] o_ifu_icache_pc_addr;
wire o_ifu_bpu_vld;
wire [`CORE_PC_WIDTH - 1 : 0] o_ifu_bpu_pc_addr;
wire [`CORE_PC_WIDTH - 1 : 0] o_ifu_predec_pc_addr;

ifu_module ifu ( 
    .i_csr_trap_flush    (o_csr_trap_flush),
    .i_csr_trap_addr     (o_csr_trap_addr),
    .i_exu_mis_flush     (o_exu_mis_flush),
    .i_exu_mis_addr      (o_exu_mis_addr),
    .i_exu_mis_rob_id    (o_exu_mis_rob_id),
    .i_exu_ls_flush      (o_exu_ls_flush),
    .i_exu_ls_addr       (o_exu_ls_addr),
    .i_exu_ls_rob_id     (o_exu_ls_rob_id),
    .i_bpu_flush         (o_bpu_flush),
    .i_bpu_pc_addr       (o_bpu_pc_addr),
    .i_iq_flush          (o_iq_flush),
    .i_iq_pc_addr        (o_iq_taddr),
    .i_iq_uc_flush       (o_iq_uc_flush),
    .i_iq_uc_pc_addr     (o_iq_uc_taddr),
    .i_icache_ifu_vld    (o_cache_ifu_vld),
    .i_icache_ifu_id     (o_cache_ifu_id),
    .i_icache_ifu_stall  (o_cache_ifu_stall),
    
    .o_ifu_icache_vld    (o_ifu_icache_vld),
    .o_ifu_icache_pc_addr(o_ifu_icache_pc_addr),
    .o_ifu_icache_id     (o_ifu_icache_id),
    .o_ifu_bpu_vld       (o_ifu_bpu_vld),
    .o_ifu_bpu_pc_addr   (o_ifu_bpu_pc_addr),
    .o_ifu_predec_pc_addr(o_ifu_predec_pc_addr),
    
    .clk                 (clk),
    .rst_n               (rst_n)
);

/***************** Stage 2 *********************/
wire o_bpu_flush;
wire [`CORE_PC_WIDTH - 1 : 0] o_bpu_pc_addr;
wire [`BPU_PRED_INFO_WIDTH - 1 : 0] o_bpu_predec_pred_info;

bpu_module bpu ( 
    .i_csr_trap_flush      (o_csr_trap_flush),
    .i_exu_mis_flush       (o_exu_mis_flush),
    .i_exu_ls_flush        (o_exu_ls_flush),

    .i_ifu_bpu_vld         (o_ifu_bpu_vld),
    .i_ifu_bpu_pc_addr     (o_ifu_bpu_pc_addr),
    .i_predec_icache_done  (o_predec_icache_16byte_done),
    .i_iq_bpu_vld          (o_iq_bpu_vld),
    .i_iq_bpu_taken        (o_iq_bpu_taken),
    .i_iq_bpu_new_br       (o_iq_bpu_new_br),
    .i_iq_bpu_btb_type     (o_iq_bpu_btb_type),
    .i_iq_bpu_btb_addr     (o_iq_bpu_btb_addr),
    .i_iq_bpu_btb_taddr    (o_iq_bpu_btb_taddr),
    .i_iq_bpu_btb_idx      (o_iq_bpu_btb_idx),
    .i_iq_bpu_pht_entry    (o_iq_bpu_pht_entry),
    .i_iq_bpu_pht_idx      (o_iq_bpu_pht_idx),
    .i_iq_bpu_alias_err    (o_iq_bpu_alias_err),
    .i_iq_bpu_tsucc        (o_iq_bpu_tsucc),

    .o_bpu_flush           (o_bpu_flush),
    .o_bpu_pc_addr         (o_bpu_pc_addr),
    .o_bpu_predec_pred_info(o_bpu_predec_pred_info),

    .clk                   (clk),
    .rst_n                 (rst_n)
);

//
wire o_itlb_mmu_vld;
wire [`CORE_PC_WIDTH - 1 : 0] o_itlb_mmu_vaddr;
wire o_icache_mem_vld;
wire [`PHY_ADDR_WIDTH - 1 : 0] o_icache_mem_paddr;
wire o_cache_predec_vld;
wire o_cache_predec_hit;
wire [`ICACHE_DATA_WIDTH - 1 : 0] o_cache_predec_way;
wire o_cache_predec_bypass_vld;
wire [`ICACHE_DATA_WIDTH - 1 : 0] o_cache_predec_bypass;
wire [`EXCEPTION_CODE_WIDTH - 1 : 0] o_cache_predec_excp_code;
wire o_cache_ifu_vld;
wire [1 : 0] o_cache_ifu_id;
wire o_cache_ifu_stall;
wire o_itlb_rob_ifu_done;

icache_top_module icache ( 
    .i_csr_trap_flush         (o_csr_trap_flush),
    .i_exu_mis_flush          (o_exu_mis_flush),
    .i_exu_ls_flush           (o_exu_ls_flush),

    .i_bpu_flush              (o_bpu_flush),
    .i_iq_flush               (o_iq_flush),
    .i_iq_uc_flush            (o_iq_uc_flush),
    .i_rob_itlb_flush         (o_rob_itlb_flush),
    .i_rob_itlb_src1          (o_rob_itlb_src1),
    .i_rob_itlb_src2          (o_rob_itlb_src2),
    .i_csr_mmu_satp           (o_csr_mmu_satp),
    .i_csr_rv_mode            (o_csr_rv_mode),
    .i_ifu_icache_vld         (o_ifu_icache_vld),
    .i_ifu_icache_pc_addr     (o_ifu_icache_pc_addr),
    .i_ifu_icache_id          (o_ifu_icache_id),
    .i_predec_icache_done     (o_predec_icache_16byte_done),
    .i_mmu_itlb_vld           (o_mmu_itlb_vld),
    .i_mmu_itlb_tlb           (o_mmu_itlb_tlb),
    .i_mmu_itlb_paddr         (o_mmu_itlb_paddr),
    .i_mmu_itlb_excp_code     (o_mmu_itlb_excp_code),
    .i_mmu_icache_vld         (o_mem_icache_vld),
    .i_mmu_icache_data        (o_mem_icache_dat),
    .i_mmu_icache_inv_vld     (o_mem_cache_inv_vld),
    .i_mmu_icache_inv_paddr   (o_mem_icache_dat),

    .o_itlb_mmu_vld           (o_itlb_mmu_vld),
    .o_itlb_mmu_vaddr         (o_itlb_mmu_vaddr),
    .o_icache_mem_vld         (o_icache_mem_vld),
    .o_icache_mem_paddr       (o_icache_mem_paddr),
    .o_cache_predec_vld       (o_cache_predec_vld),
    .o_cache_predec_hit       (o_cache_predec_hit),
    .o_cache_predec_way       (o_cache_predec_way),
    .o_cache_predec_bypass_vld(o_cache_predec_bypass_vld),
    .o_cache_predec_bypass    (o_cache_predec_bypass),
    .o_cache_predec_excp_code (o_cache_predec_excp_code),
    .o_cache_ifu_vld          (o_cache_ifu_vld),
    .o_cache_ifu_id           (o_cache_ifu_id),
    .o_cache_ifu_stall        (o_cache_ifu_stall),
    .o_itlb_rob_ifu_done      (o_itlb_rob_ifu_done),
    
    .clk                      (clk),
    .rst_n                    (rst_n)
);

/***************** Stage 3 *********************/
wire [3 : 0] o_predec_iq_vld;
wire [`CORE_PC_WIDTH - 1 : 0] o_predec_iq_addr_0;
wire [`INSTR_WIDTH - 1 : 0] o_predec_iq_instr_0;
wire [`CORE_PC_WIDTH - 1 : 0] o_predec_iq_addr_1;
wire [`INSTR_WIDTH - 1 : 0] o_predec_iq_instr_1;
wire [`CORE_PC_WIDTH - 1 : 0] o_predec_iq_addr_2;
wire [`INSTR_WIDTH - 1 : 0] o_predec_iq_instr_2;
wire [`CORE_PC_WIDTH - 1 : 0] o_predec_iq_addr_3;
wire [`INSTR_WIDTH - 1 : 0] o_predec_iq_instr_3;
wire [3 : 0] o_predec_iq_len;
wire [`PREDINFO_WIDTH - 1 : 0] o_predec_iq_predinfo_bus;
wire [] o_predec_iq_type_0;
wire [] o_predec_iq_type_1;
wire [] o_predec_iq_type_2;
wire [] o_predec_iq_type_3;
wire [3 : 0] o_predec_iq_alias_vec_0;
wire [3 : 0] o_predec_iq_alias_vec_1;
wire [3 : 0] o_predec_iq_alias_vec_2;
wire [3 : 0] o_predec_iq_alias_vec_3;
wire [3 : 0] o_predec_iq_match_vec_0;
wire [3 : 0] o_predec_iq_match_vec_1;
wire [3 : 0] o_predec_iq_match_vec_2;
wire [3 : 0] o_predec_iq_match_vec_3;
wire [`EXCEPTION_CODE_WIDTH - 1 : 0] o_predec_iq_excp_code;
wire o_predec_icache_16byte_done;

predecoder_module predecoder ( 
    .i_csr_trap_flush           (o_csr_trap_flush),
    .i_exu_mis_flush            (o_exu_mis_flush),
    .i_exu_ls_flush             (o_exu_ls_flush),

    .i_cache_predec_vld         (o_cache_predec_vld),
    .i_cache_predec_hit         (o_cache_predec_hit),
    .i_cache_predec_way         (o_cache_predec_way),
    .i_cache_predec_bypass_vld  (o_cache_predec_bypass_vld),
    .i_cache_predec_bypass_dat  (o_cache_predec_bypass),
    .i_cache_predec_excp_code   (o_cache_predec_excp_code),
    .i_ifu_predec_addr          (o_ifu_predec_pc_addr),
    .i_bpu_predinfo_bus         (o_bpu_predec_pred_info),
    .i_iq_bpu_vld               (o_iq_bpu_vld),
    .i_iq_bpu_taken             (o_iq_bpu_taken),
    .i_iq_bpu_new_br            (o_iq_bpu_new_br),
    .i_iq_bpu_type              (o_iq_bpu_type),
    .i_iq_bpu_btb_addr          (o_iq_bpu_btb_addr),
    .i_iq_bpu_btb_taddr         (o_iq_bpu_btb_taddr),
    .i_iq_bpu_btb_idx           (o_iq_bpu_btb_idx),
    .i_iq_bpu_pht_idx           (o_iq_bpu_pht_idx),
    .i_iq_bpu_pht_entry         (o_iq_bpu_pht_entry),
    .i_iq_alias_err             (o_iq_bpu_alias_err),
    .i_iq_predec_stall          (o_iq_predec_stall),
    
    .o_predec_iq_vld            (o_predec_iq_vld),
    .o_predec_iq_addr_0         (o_predec_iq_addr_0),
    .o_predec_iq_instr_0        (o_predec_iq_instr_0),
    .o_predec_iq_addr_1         (o_predec_iq_addr_1),
    .o_predec_iq_instr_1        (o_predec_iq_instr_1),
    .o_predec_iq_addr_2         (o_predec_iq_addr_2),
    .o_predec_iq_instr_2        (o_predec_iq_instr_2),
    .o_predec_iq_addr_3         (o_predec_iq_addr_3),
    .o_predec_iq_instr_3        (o_predec_iq_instr_3),
    .o_predec_iq_len            (o_predec_iq_len),
    .o_predec_iq_predinfo_bus   (o_predec_iq_predinfo_bus),
    .o_predec_iq_type_0         (o_predec_iq_type_0),
    .o_predec_iq_type_1         (o_predec_iq_type_1),
    .o_predec_iq_type_2         (o_predec_iq_type_2),
    .o_predec_iq_type_3         (o_predec_iq_type_3),
    .o_predec_iq_alias_vec_0    (o_predec_iq_alias_vec_0),
    .o_predec_iq_alias_vec_1    (o_predec_iq_alias_vec_1),
    .o_predec_iq_alias_vec_2    (o_predec_iq_alias_vec_2),
    .o_predec_iq_alias_vec_3    (o_predec_iq_alias_vec_3),
    .o_predec_iq_match_vec_0    (o_predec_iq_match_vec_0),
    .o_predec_iq_match_vec_1    (o_predec_iq_match_vec_1),
    .o_predec_iq_match_vec_2    (o_predec_iq_match_vec_2),
    .o_predec_iq_match_vec_3    (o_predec_iq_match_vec_3),
    .o_predec_iq_excp_code      (o_predec_iq_excp_code),
    .o_predec_icache_16byte_done(o_predec_icache_16byte_done),

    .clk                        (clk),
    .rst_n                      (rst_n)
);

/***************** Stage 4 *********************/
wire [3 : 0] o_iq_dec_vld;
wire [`INSTR_WIDTH - 1 : 0] o_iq_dec_instr_0;
wire [`CORE_PC_WIDTH - 1 : 0] o_iq_dec_taddr_0;
wire [`CORE_PC_WIDTH - 1 : 0] o_iq_dec_addr_0;
wire [`PREDINFO_WIDTH - 1 : 0] o_iq_dec_predinfo_bus_0;
wire [`EXCEPTION_CODE_WIDTH - 1 : 0] o_iq_dec_excp_code_0;
wire [`INSTR_WIDTH - 1 : 0] o_iq_dec_instr_1;
wire [`CORE_PC_WIDTH - 1 : 0] o_iq_dec_taddr_1;
wire [`CORE_PC_WIDTH - 1 : 0] o_iq_dec_addr_1;
wire [`PREDINFO_WIDTH - 1 : 0] o_iq_dec_predinfo_bus_1;
wire [`EXCEPTION_CODE_WIDTH - 1 : 0] o_iq_dec_excp_code_1;
wire [`INSTR_WIDTH - 1 : 0] o_iq_dec_instr_2;
wire [`CORE_PC_WIDTH - 1 : 0] o_iq_dec_taddr_2;
wire [`CORE_PC_WIDTH - 1 : 0] o_iq_dec_addr_2;
wire [`PREDINFO_WIDTH - 1 : 0] o_iq_dec_predinfo_bus_2;
wire [`EXCEPTION_CODE_WIDTH - 1 : 0] o_iq_dec_excp_code_2;
wire [`INSTR_WIDTH - 1 : 0] o_iq_dec_instr_3;
wire [`CORE_PC_WIDTH - 1 : 0] o_iq_dec_taddr_3;
wire [`CORE_PC_WIDTH - 1 : 0] o_iq_dec_addr_3;
wire [`PREDINFO_WIDTH - 1 : 0] o_iq_dec_predinfo_bus_3;
wire [`EXCEPTION_CODE_WIDTH - 1 : 0] o_iq_dec_excp_code_3;
wire [3 : 0] o_iq_dec_len;
wire o_iq_bpu_vld;
wire o_iq_bpu_taken;
wire o_iq_bpu_new_br;
wire o_iq_bpu_type;
wire [`CORE_PC_WIDTH - 1 : 0] o_iq_bpu_btb_addr;
wire [`CORE_PC_WIDTH - 1 : 0] o_iq_bpu_btb_taddr;
wire [`BTB_IDX_WIDTH - 1 : 0] o_iq_bpu_btb_idx;
wire [`GHR_PHT_WIDTH - 1 : 0] o_iq_bpu_pht_idx;
wire [1 : 0] o_iq_bpu_pht_entry;
wire o_iq_bpu_alias_err;
wire o_iq_bpu_tsucc;
wire o_iq_predec_stall;
wire o_iq_flush;
wire [`CORE_PC_WIDTH - 1 : 0] o_iq_taddr;
wire o_iq_uc_flush;
wire [`CORE_PC_WIDTH - 1 : 0] o_iq_uc_taddr;

iq_module iq ( 
    .i_csr_trap_flush        (o_csr_trap_flush),
    .i_exu_mis_flush         (o_exu_mis_flush),
    .i_exu_ls_flush          (o_exu_ls_flush),
    .i_exu_rv_mode           (o_csr_rv_mode),
    
    .i_predec_iq_vld         (o_predec_iq_vld),
    .i_predec_iq_instr_0     (o_predec_iq_instr_0),
    .i_predec_iq_addr_0      (o_predec_iq_addr_0),
    .i_predec_iq_type_0      (o_predec_iq_type_0),
    .i_predec_iq_alias_vec_0 (o_predec_iq_alias_vec_0),
    .i_predec_iq_match_vec_0 (o_predec_iq_match_vec_0),
    .i_predec_iq_instr_1     (o_predec_iq_instr_1),
    .i_predec_iq_addr_1      (o_predec_iq_addr_1),
    .i_predec_iq_type_1      (o_predec_iq_type_1),
    .i_predec_iq_alias_vec_1 (o_predec_iq_alias_vec_1),
    .i_predec_iq_match_vec_1 (o_predec_iq_match_vec_1),
    .i_predec_iq_instr_2     (o_predec_iq_instr_2),
    .i_predec_iq_addr_2      (o_predec_iq_addr_2),
    .i_predec_iq_type_2      (o_predec_iq_type_2),
    .i_predec_iq_alias_vec_2 (o_predec_iq_alias_vec_2),
    .i_predec_iq_match_vec_2 (o_predec_iq_match_vec_2),
    .i_predec_iq_instr_3     (o_predec_iq_instr_3),
    .i_predec_iq_addr_3      (o_predec_iq_addr_3),
    .i_predec_iq_type_3      (o_predec_iq_type_3),
    .i_predec_iq_alias_vec_3 (o_predec_iq_alias_vec_3),
    .i_predec_iq_match_vec_3 (o_predec_iq_match_vec_3),
    .i_predec_iq_len         (o_predec_iq_len),
    .i_predec_iq_predinfo_bus(o_predec_iq_predinfo_bus),
    .i_predec_iq_excp_code   (o_predec_iq_excp_code),
    .i_exu_iq_btac_vld       (o_exu_iq_btac_vld),
    .i_exu_iq_btac_taken     (o_exu_iq_btac_taken),
    .i_exu_iq_new_br         (o_exu_iq_btac_new_br),
    .i_exu_iq_btac_addr      (o_exu_iq_btac_addr),
    .i_exu_iq_btac_taddr     (o_exu_iq_btac_taddr),
    .i_exu_iq_btac_idx       (o_exu_iq_btac_idx),
    .i_exu_iq_pht_idx        (o_exu_iq_pht_idx),
    .i_exu_iq_pht_entry      (o_exu_iq_pht_status),
    .i_exu_iq_len            (o_exu_iq_len),
    .i_exu_iq_tsucc          (o_exu_iq_tsucc),
    .i_dec_iq_stall          (o_dec_iq_stall),
    
    .o_iq_dec_vld            (o_iq_dec_vld),
    .o_iq_dec_instr_0        (o_iq_dec_instr_0),
    .o_iq_dec_taddr_0        (o_iq_dec_taddr_0),
    .o_iq_dec_addr_0         (o_iq_dec_addr_0),
    .o_iq_dec_predinfo_bus_0 (o_iq_dec_predinfo_bus_0),
    .o_iq_dec_excp_code_0    (o_iq_dec_excp_code_0),
    .o_iq_dec_instr_1        (o_iq_dec_instr_1),
    .o_iq_dec_taddr_1        (o_iq_dec_taddr_1),
    .o_iq_dec_addr_1         (o_iq_dec_addr_1),
    .o_iq_dec_predinfo_bus_1 (o_iq_dec_predinfo_bus_1),
    .o_iq_dec_excp_code_1    (o_iq_dec_excp_code_1),
    .o_iq_dec_instr_2        (o_iq_dec_instr_2),
    .o_iq_dec_taddr_2        (o_iq_dec_taddr_2),
    .o_iq_dec_addr_2         (o_iq_dec_addr_2),
    .o_iq_dec_predinfo_bus_2 (o_iq_dec_predinfo_bus_2),
    .o_iq_dec_excp_code_2    (o_iq_dec_excp_code_2),
    .o_iq_dec_instr_3        (o_iq_dec_instr_3),
    .o_iq_dec_taddr_3        (o_iq_dec_taddr_3),
    .o_iq_dec_addr_3         (o_iq_dec_addr_3),
    .o_iq_dec_predinfo_bus_3 (o_iq_dec_predinfo_bus_3),
    .o_iq_dec_excp_code_3    (o_iq_dec_excp_code_3),
    .o_iq_dec_len            (o_iq_dec_len),
    .o_iq_bpu_vld            (o_iq_bpu_vld),
    .o_iq_bpu_taken          (o_iq_bpu_taken),
    .o_iq_bpu_new_br         (o_iq_bpu_new_br),
    .o_iq_bpu_type           (o_iq_bpu_type),
    .o_iq_bpu_btb_addr       (o_iq_bpu_btb_addr),
    .o_iq_bpu_btb_taddr      (o_iq_bpu_btb_taddr),
    .o_iq_bpu_btb_idx        (o_iq_bpu_btb_idx),
    .o_iq_bpu_pht_idx        (o_iq_bpu_pht_idx),
    .o_iq_bpu_pht_entry      (o_iq_bpu_pht_entry),
    .o_iq_bpu_alias_err      (o_iq_bpu_alias_err),
    .o_iq_bpu_tsucc          (o_iq_bpu_tsucc),
    .o_iq_predec_stall       (o_iq_predec_stall),
    .o_iq_flush              (o_iq_flush),
    .o_iq_taddr              (o_iq_taddr),
    .o_iq_uc_flush           (o_iq_uc_flush),
    .o_iq_uc_taddr           (o_iq_uc_taddr)

    .clk                     (clk),
    .rst_n                   (rst_n)
);

/***************** Stage 5 *********************/
wire [3 : 0] o_dec_dsp_vld;
wire [`EXCEPTION_CODE_WIDTH - 1 : 0] o_dec_dsp_excp_code_0;
wire o_dec_dsp_ilgl_0;
wire o_dec_dsp_len_0;
wire [`PRF_CODE_WIDTH - 1 : 0] o_dec_dsp_src1_code_0;
wire [`PRF_CODE_WIDTH - 1 : 0] o_dec_dsp_src2_code_0;
wire [`PRF_CODE_WIDTH - 1 : 0] o_dec_dsp_src3_code_0;
wire [`PRF_CODE_WIDTH - 1 : 0] o_dec_dsp_dst_code_0;
wire [`IMM_WIDTH - 1 : 0] o_dec_dsp_imm_0;
wire [`DECINFO_WIDTH - 1 : 0] o_dec_dsp_decinfo_bus_0;
wire [`PREDINFO_WIDTH - 1 : 0] o_dec_dsp_predinfo_bus_0;
wire [`EXCEPTION_CODE_WIDTH - 1 : 0] o_dec_dsp_excp_code_1;
wire o_dec_dsp_ilgl_1;
wire o_dec_dsp_len_1;
wire [`PRF_CODE_WIDTH - 1 : 0] o_dec_dsp_src1_code_1;
wire [`PRF_CODE_WIDTH - 1 : 0] o_dec_dsp_src2_code_1;
wire [`PRF_CODE_WIDTH - 1 : 0] o_dec_dsp_src3_code_1;
wire [`PRF_CODE_WIDTH - 1 : 0] o_dec_dsp_dst_code_1;
wire [`IMM_WIDTH - 1 : 0] o_dec_dsp_imm_1;
wire [`DECINFO_WIDTH - 1 : 0] o_dec_dsp_decinfo_bus_1;
wire [`PREDINFO_WIDTH - 1 : 0] o_dec_dsp_predinfo_bus_1;
wire [`EXCEPTION_CODE_WIDTH - 1 : 0] o_dec_dsp_excp_code_2;
wire o_dec_dsp_ilgl_2;
wire o_dec_dsp_len_2;
wire [`PRF_CODE_WIDTH - 1 : 0] o_dec_dsp_src1_code_2;
wire [`PRF_CODE_WIDTH - 1 : 0] o_dec_dsp_src2_code_2;
wire [`PRF_CODE_WIDTH - 1 : 0] o_dec_dsp_src3_code_2;
wire [`PRF_CODE_WIDTH - 1 : 0] o_dec_dsp_dst_code_2;
wire [`IMM_WIDTH - 1 : 0] o_dec_dsp_imm_2;
wire [`DECINFO_WIDTH - 1 : 0] o_dec_dsp_decinfo_bus_2;
wire [`PREDINFO_WIDTH - 1 : 0] o_dec_dsp_predinfo_bus_2;
wire [`EXCEPTION_CODE_WIDTH - 1 : 0] o_dec_dsp_excp_code_3;
wire o_dec_dsp_ilgl_3;
wire o_dec_dsp_len_3;
wire [`PRF_CODE_WIDTH - 1 : 0] o_dec_dsp_src1_code_3;
wire [`PRF_CODE_WIDTH - 1 : 0] o_dec_dsp_src2_code_3;
wire [`PRF_CODE_WIDTH - 1 : 0] o_dec_dsp_src3_code_3;
wire [`PRF_CODE_WIDTH - 1 : 0] o_dec_dsp_dst_code_3;
wire [`IMM_WIDTH - 1 : 0] o_dec_dsp_imm_3;
wire [`DECINFO_WIDTH - 1 : 0] o_dec_dsp_decinfo_bus_3;
wire [`PREDINFO_WIDTH - 1 : 0] o_dec_dsp_predinfo_bus_3;

wire [`PRF_CODE_WIDTH - 1 : 0] o_dec_dsp_pprf_code_0;
wire [`PRF_CODE_WIDTH - 1 : 0] o_dec_dsp_pprf_code_1;
wire [`PRF_CODE_WIDTH - 1 : 0] o_dec_dsp_pprf_code_2;
wire [`PRF_CODE_WIDTH - 1 : 0] o_dec_dsp_pprf_code_3;

wire o_dec_iq_stall;

wire o_dec_prf_free_req_0;
wire o_dec_prf_free_req_1;
wire o_dec_prf_free_req_2;
wire o_dec_prf_free_req_3;
wire [`PRF_CODE_WIDTH - 1 : 0] o_dec_prf_code_0;
wire [`PRF_CODE_WIDTH - 1 : 0] o_dec_prf_code_1;
wire [`PRF_CODE_WIDTH - 1 : 0] o_dec_prf_code_2;
wire [`PRF_CODE_WIDTH - 1 : 0] o_dec_prf_code_3;

wire [`INSTR_WIDTH - 1 : 0] o_dec_dsp_instr_0;
wire [`INSTR_WIDTH - 1 : 0] o_dec_dsp_instr_1;
wire [`INSTR_WIDTH - 1 : 0] o_dec_dsp_instr_2;
wire [`INSTR_WIDTH - 1 : 0] o_dec_dsp_instr_3;

wire [`CORE_PC_WIDTH - 1 : 0] o_dec_dsp_addr_0;
wire [`CORE_PC_WIDTH - 1 : 0] o_dec_dsp_addr_1;
wire [`CORE_PC_WIDTH - 1 : 0] o_dec_dsp_addr_2;
wire [`CORE_PC_WIDTH - 1 : 0] o_dec_dsp_addr_3;
wire [`CORE_PC_WIDTH - 1 : 0] o_dec_dsp_taddr_0;
wire [`CORE_PC_WIDTH - 1 : 0] o_dec_dsp_taddr_1;
wire [`CORE_PC_WIDTH - 1 : 0] o_dec_dsp_taddr_2;
wire [`CORE_PC_WIDTH - 1 : 0] o_dec_dsp_taddr_3;


dec_decode_module dec_decode ( 
    .i_csr_trap_flush        (o_csr_trap_flush),
    .i_exu_mis_flush         (o_exu_mis_flush),
    .i_exu_ls_flush          (o_exu_ls_flush),
    
    .i_iq_dec_vld            (o_iq_dec_vld),
    .i_iq_dec_excp_code_0    (o_iq_dec_excp_code_0),
    .i_iq_dec_excp_code_1    (o_iq_dec_excp_code_1),
    .i_iq_dec_excp_code_2    (o_iq_dec_excp_code_2),
    .i_iq_dec_excp_code_3    (o_iq_dec_excp_code_3),
    .i_iq_dec_instr_0        (o_iq_dec_instr_0),
    .i_iq_dec_instr_1        (o_iq_dec_instr_1),
    .i_iq_dec_instr_2        (o_iq_dec_instr_2),
    .i_iq_dec_instr_3        (o_iq_dec_instr_3),
    .i_iq_dec_addr_0         (o_iq_dec_addr_0),
    .i_iq_dec_addr_1         (o_iq_dec_addr_1),
    .i_iq_dec_addr_2         (o_iq_dec_addr_2),
    .i_iq_dec_addr_3         (o_iq_dec_addr_3),
    .i_iq_dec_taddr_0        (o_iq_dec_taddr_0),
    .i_iq_dec_taddr_1        (o_iq_dec_taddr_1),
    .i_iq_dec_taddr_2        (o_iq_dec_taddr_2),
    .i_iq_dec_taddr_3        (o_iq_dec_taddr_3),
    .i_iq_dec_predinfo_bus_0 (o_iq_dec_predinfo_bus_0),
    .i_iq_dec_predinfo_bus_1 (o_iq_dec_predinfo_bus_1),
    .i_iq_dec_predinfo_bus_2 (o_iq_dec_predinfo_bus_2),
    .i_iq_dec_predinfo_bus_3 (o_iq_dec_predinfo_bus_3),

    .i_dsp_dec_stall         (o_dsp_ren_stall),

    .i_rob_dec_ret_vld       (o_rob_ren_ret_vld),
    .i_rob_dec_ret_arf_code_0(o_rob_ren_ret_arf_code_0),
    .i_rob_dec_ret_prf_code_0(o_rob_ren_ret_prf_code_0),
    .i_rob_dec_ret_arf_code_1(o_rob_ren_ret_arf_code_1),
    .i_rob_dec_ret_prf_code_1(o_rob_ren_ret_prf_code_1),
    .i_rob_dec_ret_arf_code_2(o_rob_ren_ret_arf_code_2),
    .i_rob_dec_ret_prf_code_2(o_rob_ren_ret_prf_code_2),
    .i_rob_dec_ret_arf_code_3(o_rob_ren_ret_arf_code_3),
    .i_rob_dec_ret_prf_code_3(o_rob_ren_ret_prf_code_3),

    .i_rob_dec_rec_vld       (o_rob_ren_rec_vld),
    .i_rob_dec_rec_arf_code_0(o_rob_ren_rec_arf_code_0),
    .i_rob_dec_rec_prf_code_0(o_rob_ren_rec_prf_code_0),
    .i_rob_dec_rec_arf_code_1(o_rob_ren_rec_arf_code_1),
    .i_rob_dec_rec_prf_code_1(o_rob_ren_rec_prf_code_1),
    .i_rob_dec_rec_arf_code_2(o_rob_ren_rec_arf_code_2),
    .i_rob_dec_rec_prf_code_2(o_rob_ren_rec_prf_code_2),
    .i_rob_dec_rec_arf_code_3(o_rob_ren_rec_arf_code_3),
    .i_rob_dec_rec_prf_code_3(o_rob_ren_rec_prf_code_3),

    .i_rob_dec_mis_vld       (o_rob_ren_mis_vld),
    .i_rob_dec_mis_arf_code_0(o_rob_ren_mis_arf_code_0),
    .i_rob_dec_mis_prf_code_0(o_rob_ren_mis_prf_code_0),
    .i_rob_dec_mis_arf_code_1(o_rob_ren_mis_arf_code_1),
    .i_rob_dec_mis_prf_code_1(o_rob_ren_mis_prf_code_1),
    .i_rob_dec_mis_arf_code_2(o_rob_ren_mis_arf_code_2),
    .i_rob_dec_mis_prf_code_2(o_rob_ren_mis_prf_code_2),
    .i_rob_dec_mis_arf_code_3(o_rob_ren_mis_arf_code_3),
    .i_rob_dec_mis_prf_code_3(o_rob_ren_mis_prf_code_3),

    .o_dec_dsp_vld           (o_dec_dsp_vld),
    .o_dec_dsp_excp_code_0   (o_dec_dsp_excp_code_0),
    .o_dec_dsp_ilgl_0        (o_dec_dsp_ilgl_0),
    .o_dec_dsp_len_0         (o_dec_dsp_len_0),
    .o_dec_dsp_src1_vld_0    (o_dec_dsp_src1_vld_0),
    .o_dec_dsp_src1_code_0   (o_dec_dsp_src1_code_0),
    .o_dec_dsp_src2_vld_0    (o_dec_dsp_src2_vld_0),
    .o_dec_dsp_src2_code_0   (o_dec_dsp_src2_code_0),
    .o_dec_dsp_src3_vld_0    (o_dec_dsp_src3_vld_0),
    .o_dec_dsp_src3_code_0   (o_dec_dsp_src3_code_0),
    .o_dec_dsp_dst_vld_0     (o_dec_dsp_dst_vld_0),
    .o_dec_dsp_dst_code_0    (o_dec_dsp_dst_code_0),
    .o_dec_dsp_imm_0         (o_dec_dsp_imm_0),
    .o_dec_dsp_decinfo_bus_0 (o_dec_dsp_decinfo_bus_0),
    .o_dec_dsp_predinfo_bus_0(o_dec_dsp_predinfo_bus_0),
    .o_dec_dsp_excp_code_1   (o_dec_dsp_excp_code_1),
    .o_dec_dsp_ilgl_1        (o_dec_dsp_ilgl_1),
    .o_dec_dsp_src1_vld_1    (o_dec_dsp_src1_vld_1),
    .o_dec_dsp_src1_code_1   (o_dec_dsp_src1_code_1),
    .o_dec_dsp_src2_vld_1    (o_dec_dsp_src2_vld_1),
    .o_dec_dsp_src2_code_1   (o_dec_dsp_src2_code_1),
    .o_dec_dsp_src3_vld_1    (o_dec_dsp_src3_vld_1),
    .o_dec_dsp_src3_code_1   (o_dec_dsp_src3_code_1),
    .o_dec_dsp_dst_vld_1     (o_dec_dsp_dst_vld_1),
    .o_dec_dsp_dst_code_1    (o_dec_dsp_dst_code_1),
    .o_dec_dsp_imm_1         (o_dec_dsp_imm_1),
    .o_dec_dsp_decinfo_bus_1 (o_dec_dsp_decinfo_bus_1),
    .o_dec_dsp_predinfo_bus_1(o_dec_dsp_predinfo_bus_1),
    .o_dec_dsp_excp_code_2   (o_dec_dsp_excp_code_2),
    .o_dec_dsp_ilgl_2        (o_dec_dsp_ilgl_2),
    .o_dec_dsp_src1_vld_2    (o_dec_dsp_src1_vld_2),
    .o_dec_dsp_src1_code_2   (o_dec_dsp_src1_code_2),
    .o_dec_dsp_src2_vld_2    (o_dec_dsp_src2_vld_2),
    .o_dec_dsp_src2_code_2   (o_dec_dsp_src2_code_2),
    .o_dec_dsp_src3_vld_2    (o_dec_dsp_src3_vld_2),
    .o_dec_dsp_src3_code_2   (o_dec_dsp_src3_code_2),
    .o_dec_dsp_dst_vld_2     (o_dec_dsp_dst_vld_2),
    .o_dec_dsp_dst_code_2    (o_dec_dsp_dst_code_2),
    .o_dec_dsp_imm_2         (o_dec_dsp_imm_2),
    .o_dec_dsp_decinfo_bus_2 (o_dec_dsp_decinfo_bus_2),
    .o_dec_dsp_predinfo_bus_2(o_dec_dsp_predinfo_bus_2),
    .o_dec_dsp_excp_code_3   (o_dec_dsp_excp_code_3),
    .o_dec_dsp_ilgl_3        (o_dec_dsp_ilgl_3),
    .o_dec_dsp_src1_vld_3    (o_dec_dsp_src1_vld_3),
    .o_dec_dsp_src1_code_3   (o_dec_dsp_src1_code_3),
    .o_dec_dsp_src2_vld_3    (o_dec_dsp_src2_vld_3),
    .o_dec_dsp_src2_code_3   (o_dec_dsp_src2_code_3),
    .o_dec_dsp_src3_vld_3    (o_dec_dsp_src3_vld_3),
    .o_dec_dsp_src3_code_3   (o_dec_dsp_src3_code_3),
    .o_dec_dsp_dst_vld_3     (o_dec_dsp_dst_vld_3),
    .o_dec_dsp_dst_code_3    (o_dec_dsp_dst_code_3),
    .o_dec_dsp_imm_3         (o_dec_dsp_imm_3),
    .o_dec_dsp_decinfo_bus_3 (o_dec_dsp_decinfo_bus_3),
    .o_dec_dsp_predinfo_bus_3(o_dec_dsp_predinfo_bus_3),

    .o_dec_dsp_pprf_code_0   (o_dec_dsp_pprf_code_0),
    .o_dec_dsp_pprf_code_1   (o_dec_dsp_pprf_code_1),
    .o_dec_dsp_pprf_code_2   (o_dec_dsp_pprf_code_2),
    .o_dec_dsp_pprf_code_3   (o_dec_dsp_pprf_code_3),
    
    .o_dec_iq_stall          (o_dec_iq_stall),

    .o_dec_prf_free_req_0    (o_dec_prf_free_req_0),
    .o_dec_prf_free_req_1    (o_dec_prf_free_req_1),
    .o_dec_prf_free_req_2    (o_dec_prf_free_req_2),
    .o_dec_prf_free_req_3    (o_dec_prf_free_req_3),
    .o_dec_prf_code_0        (o_dec_prf_code_0),
    .o_dec_prf_code_1        (o_dec_prf_code_1),
    .o_dec_prf_code_2        (o_dec_prf_code_2),
    .o_dec_prf_code_3        (o_dec_prf_code_3),

    .o_dec_dsp_instr_0       (o_dec_dsp_instr_0),
    .o_dec_dsp_instr_1       (o_dec_dsp_instr_1),
    .o_dec_dsp_instr_2       (o_dec_dsp_instr_2),
    .o_dec_dsp_instr_3       (o_dec_dsp_instr_3),

    .o_dec_dsp_addr_0        (o_dec_dsp_addr_0),
    .o_dec_dsp_addr_1        (o_dec_dsp_addr_1),
    .o_dec_dsp_addr_2        (o_dec_dsp_addr_2),
    .o_dec_dsp_addr_3        (o_dec_dsp_addr_3),
    .o_dec_dsp_taddr_0       (o_dec_dsp_taddr_0),
    .o_dec_dsp_taddr_1       (o_dec_dsp_taddr_1),
    .o_dec_dsp_taddr_2       (o_dec_dsp_taddr_2),
    .o_dec_dsp_taddr_3       (o_dec_dsp_taddr_3),

    .clk                     (clk),
    .rst_n                   (rst_n)
);

/***************** Stage 6 *********************/
wire [3 : 0] o_dec_dsp_len = {
                                o_dec_dsp_len_3
                            ,   o_dec_dsp_len_2 
                            ,   o_dec_dsp_len_1 
                            ,   o_dec_dsp_len_0
                            };

wire [3 : 0] o_dsp_rsv_vld;
wire o_dsp_rsv_src1_vld_0;
wire [`PRF_CODE_WIDTH - 1 : 0] o_dsp_rsv_src1_prf_code_0;
wire o_dsp_rsv_src2_vld_0;
wire [`PRF_CODE_WIDTH - 1 : 0] o_dsp_rsv_src2_prf_code_0;
wire o_dsp_rsv_src3_vld_0;
wire [`PRF_CODE_WIDTH - 1 : 0] o_dsp_rsv_src3_prf_code_0;
wire o_dsp_rsv_dst_vld_0;
wire [`PRF_CODE_WIDTH - 1 : 0] o_dsp_rsv_dst_prf_code_0;
wire [`PRF_CODE_WIDTH - 1 : 0] o_dsp_rsv_dst_pprf_code_0;
wire o_dsp_rsv_src1_vld_1;
wire [`PRF_CODE_WIDTH - 1 : 0] o_dsp_rsv_src1_prf_code_1;
wire o_dsp_rsv_src2_vld_1;
wire [`PRF_CODE_WIDTH - 1 : 0] o_dsp_rsv_src2_prf_code_1;
wire o_dsp_rsv_src3_vld_1;
wire [`PRF_CODE_WIDTH - 1 : 0] o_dsp_rsv_src3_prf_code_1;
wire o_dsp_rsv_dst_vld_1;
wire [`PRF_CODE_WIDTH - 1 : 0] o_dsp_rsv_dst_prf_code_1;
wire [`PRF_CODE_WIDTH - 1 : 0] o_dsp_rsv_dst_pprf_code_1;
wire o_dsp_rsv_src1_vld_2;
wire [`PRF_CODE_WIDTH - 1 : 0] o_dsp_rsv_src1_prf_code_2;
wire o_dsp_rsv_src2_vld_2;
wire [`PRF_CODE_WIDTH - 1 : 0] o_dsp_rsv_src2_prf_code_2;
wire o_dsp_rsv_src3_vld_2;
wire [`PRF_CODE_WIDTH - 1 : 0] o_dsp_rsv_src3_prf_code_2;
wire o_dsp_rsv_dst_vld_2;
wire [`PRF_CODE_WIDTH - 1 : 0] o_dsp_rsv_dst_prf_code_2;
wire [`PRF_CODE_WIDTH - 1 : 0] o_dsp_rsv_dst_pprf_code_2;
wire o_dsp_rsv_src1_vld_3;
wire [`PRF_CODE_WIDTH - 1 : 0] o_dsp_rsv_src1_prf_code_3;
wire o_dsp_rsv_src2_vld_3;
wire [`PRF_CODE_WIDTH - 1 : 0] o_dsp_rsv_src2_prf_code_3;
wire o_dsp_rsv_src3_vld_3;
wire [`PRF_CODE_WIDTH - 1 : 0] o_dsp_rsv_src3_prf_code_3;
wire o_dsp_rsv_dst_vld_3;
wire [`PRF_CODE_WIDTH - 1 : 0] o_dsp_rsv_dst_prf_code_3;
wire [`PRF_CODE_WIDTH - 1 : 0] o_dsp_rsv_dst_pprf_code_3;
wire [3 : 0] o_dsp_rsv_len;
wire [`DECINFO_WIDTH - 1 : 0] o_dsp_rsv_decinfo_bus_0;
wire [`DECINFO_WIDTH - 1 : 0] o_dsp_rsv_decinfo_bus_1;
wire [`DECINFO_WIDTH - 1 : 0] o_dsp_rsv_decinfo_bus_2;
wire [`DECINFO_WIDTH - 1 : 0] o_dsp_rsv_decinfo_bus_3;
wire [`RSV_IDX_WIDTH - 1 : 0] o_dsp_rsv_free_entry_0;
wire [`RSV_IDX_WIDTH - 1 : 0] o_dsp_rsv_free_entry_1;
wire [`RSV_IDX_WIDTH - 1 : 0] o_dsp_rsv_free_entry_2;
wire [`RSV_IDX_WIDTH - 1 : 0] o_dsp_rsv_free_entry_3;
wire [`ROB_ID_WIDTH - 1 : 0] o_dsp_rsv_rob_id_0;
wire o_dsp_rsv_ld_vld_0;
wire [`LBUFF_ID_WIDTH - 1 : 0] o_dsp_rsv_ld_id_0;
wire o_dsp_rsv_st_vld_0;
wire [`SBUFF_ID_WIDTH - 1 : 0] o_dsp_rsv_st_id_0;
wire [`ROB_ID_WIDTH - 1 : 0] o_dsp_rsv_rob_id_1;
wire o_dsp_rsv_ld_vld_1;
wire [`LBUFF_ID_WIDTH - 1 : 0] o_dsp_rsv_ld_id_1;
wire o_dsp_rsv_st_vld_1;
wire [`SBUFF_ID_WIDTH - 1 : 0] o_dsp_rsv_st_id_1;
wire [`ROB_ID_WIDTH - 1 : 0] o_dsp_rsv_rob_id_2;
wire o_dsp_rsv_ld_vld_2;
wire [`LBUFF_ID_WIDTH - 1 : 0] o_dsp_rsv_ld_id_2;
wire o_dsp_rsv_st_vld_2;
wire [`SBUFF_ID_WIDTH - 1 : 0] o_dsp_rsv_st_id_2;
wire [`ROB_ID_WIDTH - 1 : 0] o_dsp_rsv_rob_id_3;
wire o_dsp_rsv_ld_vld_3;
wire [`LBUFF_ID_WIDTH - 1 : 0] o_dsp_rsv_ld_id_3;
wire o_dsp_rsv_st_vld_3;
wire [`SBUFF_ID_WIDTH - 1 : 0] o_dsp_rsv_st_id_3;
wire [`ROB_ID_WIDTH - 1 : 0] o_dsp_rsv_rob_dsp_id; 
wire [`ROB_ID_WIDTH - 1 : 0] o_dsp_rsv_rob_ret_id;
wire [`SBUFF_ID_WIDTH - 1 : 0] o_dsp_rsv_st_dsp_id;
wire [`SBUFF_ID_WIDTH - 1 : 0] o_dsp_rsv_st_ret_id;
wire [`SBUFF_ID_WIDTH - 1 : 0] o_dsp_rsv_st_rec_id;
wire [`LBUFF_ID_WIDTH - 1 : 0] o_dsp_rsv_ld_dsp_id;
wire [`LBUFF_ID_WIDTH - 1 : 0] o_dsp_rsv_ld_ret_id;
wire [`INSTR_WIDTH - 1 : 0] o_dsp_rob_instr_0;
wire [`INSTR_WIDTH - 1 : 0] o_dsp_rob_instr_1;
wire [`INSTR_WIDTH - 1 : 0] o_dsp_rob_instr_2;
wire [`INSTR_WIDTH - 1 : 0] o_dsp_rob_instr_3;
wire [`CORE_PC_WIDTH - 1 : 0] o_dsp_rob_addr_0;
wire [`CORE_PC_WIDTH - 1 : 0] o_dsp_rob_addr_1;
wire [`CORE_PC_WIDTH - 1 : 0] o_dsp_rob_addr_2;
wire [`CORE_PC_WIDTH - 1 : 0] o_dsp_rob_addr_3;
wire [`CORE_PC_WIDTH - 1 : 0] o_dsp_rob_taddr_0;
wire [`CORE_PC_WIDTH - 1 : 0] o_dsp_rob_taddr_1;
wire [`CORE_PC_WIDTH - 1 : 0] o_dsp_rob_taddr_2;
wire [`CORE_PC_WIDTH - 1 : 0] o_dsp_rob_taddr_3;


wire o_dsp_ren_stall;


dsp_top_module dsp ( 
    .i_csr_trap_flush         (o_csr_trap_flush),
    .i_exu_mis_flush          (o_exu_mis_flush),
    .i_exu_ls_flush           (o_exu_ls_flush),

    .i_dec_dsp_vld            (o_dec_dsp_vld),
    .i_dec_dsp_src1_vld_0     (o_dec_dsp_src1_vld_0),
    .i_dec_dsp_src1_prf_code_0(o_dec_dsp_src1_code_0),
    .i_dec_dsp_src2_vld_0     (o_dec_dsp_src2_vld_0),
    .i_dec_dsp_src2_prf_code_0(o_dec_dsp_src2_code_0),
    .i_dec_dsp_src3_vld_0     (o_dec_dsp_src3_vld_0),
    .i_dec_dsp_src3_prf_code_0(o_dec_dsp_src3_code_0),
    .i_dec_dsp_dst_vld_0      (o_dec_dsp_dst_vld_0),
    .i_dec_dsp_dst_prf_code_0 (o_dec_dsp_dst_code_0),
    .i_dec_dsp_dst_pprf_code_0(o_dec_dsp_pprf_code_0),
    .i_dec_dsp_src1_vld_1     (o_dec_dsp_src1_vld_1),
    .i_dec_dsp_src1_prf_code_1(o_dec_dsp_src1_code_1),
    .i_dec_dsp_src2_vld_1     (o_dec_dsp_src2_vld_1),
    .i_dec_dsp_src2_prf_code_1(o_dec_dsp_src2_code_1),
    .i_dec_dsp_src3_vld_1     (o_dec_dsp_src3_vld_1),
    .i_dec_dsp_src3_prf_code_1(o_dec_dsp_src3_code_1),
    .i_dec_dsp_dst_vld_1      (o_dec_dsp_dst_vld_1),
    .i_dec_dsp_dst_prf_code_1 (o_dec_dsp_dst_code_1),
    .i_dec_dsp_dst_pprf_code_1(o_dec_dsp_pprf_code_1),
    .i_dec_dsp_src1_vld_2     (o_dec_dsp_src1_vld_2),
    .i_dec_dsp_src1_prf_code_2(o_dec_dsp_src1_code_2),
    .i_dec_dsp_src2_vld_2     (o_dec_dsp_src2_vld_2),
    .i_dec_dsp_src2_prf_code_2(o_dec_dsp_src2_code_2),
    .i_dec_dsp_src3_vld_2     (o_dec_dsp_src3_vld_2),
    .i_dec_dsp_src3_prf_code_2(o_dec_dsp_src3_code_2),
    .i_dec_dsp_dst_vld_2      (o_dec_dsp_dst_vld_2),
    .i_dec_dsp_dst_prf_code_2 (o_dec_dsp_dst_code_2),
    .i_dec_dsp_dst_pprf_code_2(o_dec_dsp_pprf_code_2),
    .i_dec_dsp_src1_vld_3     (o_dec_dsp_src1_vld_3),
    .i_dec_dsp_src1_prf_code_3(o_dec_dsp_src1_code_3),
    .i_dec_dsp_src2_vld_3     (o_dec_dsp_src2_vld_3),
    .i_dec_dsp_src2_prf_code_3(o_dec_dsp_src2_code_3),
    .i_dec_dsp_src3_vld_3     (o_dec_dsp_src3_vld_3),
    .i_dec_dsp_src3_prf_code_3(o_dec_dsp_src3_code_3),
    .i_dec_dsp_dst_vld_3      (o_dec_dsp_dst_vld_3),
    .i_dec_dsp_dst_prf_code_3 (o_dec_dsp_dst_code_3),
    .i_dec_dsp_dst_pprf_code_3(o_dec_dsp_pprf_code_3),
    .i_dec_dsp_len            (o_dec_dsp_len),
    .i_dec_dsp_decinfo_bus_0  (o_dec_dsp_decinfo_bus_0),
    .i_dec_dsp_decinfo_bus_1  (o_dec_dsp_decinfo_bus_1),
    .i_dec_dsp_decinfo_bus_2  (o_dec_dsp_decinfo_bus_2),
    .i_dec_dsp_decinfo_bus_3  (o_dec_dsp_decinfo_bus_3),
    .i_dec_dsp_instr_0        (o_dec_dsp_instr_0),
    .i_dec_dsp_instr_1        (o_dec_dsp_instr_1),
    .i_dec_dsp_instr_2        (o_dec_dsp_instr_2),
    .i_dec_dsp_instr_3        (o_dec_dsp_instr_3),
    .i_dec_dsp_addr_0         (o_dec_dsp_addr_0),
    .i_dec_dsp_addr_1         (o_dec_dsp_addr_1),
    .i_dec_dsp_addr_2         (o_dec_dsp_addr_2),
    .i_dec_dsp_addr_3         (o_dec_dsp_addr_3),
    .i_dec_dsp_taddr_0        (o_dec_dsp_taddr_0),
    .i_dec_dsp_taddr_1        (o_dec_dsp_taddr_1),
    .i_dec_dsp_taddr_2        (o_dec_dsp_taddr_2),
    .i_dec_dsp_taddr_3        (o_dec_dsp_taddr_3),

    .i_rsv_dsp_free_vld_0     (o_rsv_dsp_free_vld_0),
    .i_rsv_dsp_free_entry_0   (o_rsv_dsp_free_entry_0),
    .i_rsv_dsp_free_vld_1     (o_rsv_dsp_free_vld_1),
    .i_rsv_dsp_free_entry_1   (o_rsv_dsp_free_entry_1),
    .i_rsv_dsp_free_vld_2     (o_rsv_dsp_free_vld_2),
    .i_rsv_dsp_free_entry_2   (o_rsv_dsp_free_entry_2),
    .i_rsv_dsp_free_vld_3     (o_rsv_dsp_free_vld_3),
    .i_rsv_dsp_free_entry_3   (o_rsv_dsp_free_entry_3),
    
    .i_rob_dsp_mis_ld_vld     (o_rob_dsp_mis_ld_vld),
    .i_rob_dsp_mis_ld_id      (o_rob_dsp_mis_ld_id),
    .i_rob_dsp_mis_st_vld     (o_rob_dsp_mis_st_vld),
    .i_rob_dsp_mis_st_id      (o_rob_dsp_mis_st_id),
    
    .i_rob_dsp_ret_vld        (o_rob_dsp_ret_vld),
    .i_rob_dsp_ret_rob_id_0   (o_rob_dsp_ret_rob_id_0),
    .i_rob_dsp_ret_ld_vld_0   (o_rob_dsp_ret_ld_vld_0),
    .i_rob_dsp_ret_st_vld_0   (o_rob_dsp_ret_st_vld_0),
    .i_rob_dsp_ret_rob_id_1   (o_rob_dsp_ret_rob_id_1),
    .i_rob_dsp_ret_ld_vld_1   (o_rob_dsp_ret_ld_vld_1),
    .i_rob_dsp_ret_st_vld_1   (o_rob_dsp_ret_st_vld_1),
    .i_rob_dsp_ret_rob_id_2   (o_rob_dsp_ret_rob_id_2),
    .i_rob_dsp_ret_ld_vld_2   (o_rob_dsp_ret_ld_vld_2),
    .i_rob_dsp_ret_st_vld_2   (o_rob_dsp_ret_st_vld_2),
    .i_rob_dsp_ret_rob_id_3   (o_rob_dsp_ret_rob_id_3),
    .i_rob_dsp_ret_ld_vld_3   (o_rob_dsp_ret_ld_vld_3),
    .i_rob_dsp_ret_st_vld_3   (o_rob_dsp_ret_st_vld_3),

    .i_exu_dsp_s_ret          (o_exu_dsp_s_ret),
    
    .o_dsp_rsv_vld            (o_dsp_rsv_vld),
    .o_dsp_rsv_src1_vld_0     (o_dsp_rsv_src1_vld_0),
    .o_dsp_rsv_src1_prf_code_0(o_dsp_rsv_src1_prf_code_0),
    .o_dsp_rsv_src2_vld_0     (o_dsp_rsv_src2_vld_0),
    .o_dsp_rsv_src2_prf_code_0(o_dsp_rsv_src2_prf_code_0),
    .o_dsp_rsv_src3_vld_0     (o_dsp_rsv_src3_vld_0),
    .o_dsp_rsv_src3_prf_code_0(o_dsp_rsv_src3_prf_code_0),
    .o_dsp_rsv_dst_vld_0      (o_dsp_rsv_dst_vld_0),
    .o_dsp_rsv_dst_prf_code_0 (o_dsp_rsv_dst_prf_code_0),
    .o_dsp_rsv_dst_pprf_code_0(o_dsp_rsv_dst_pprf_code_0),
    .o_dsp_rsv_src1_vld_1     (o_dsp_rsv_src1_vld_1),
    .o_dsp_rsv_src1_prf_code_1(o_dsp_rsv_src1_prf_code_1),
    .o_dsp_rsv_src2_vld_1     (o_dsp_rsv_src2_vld_1),
    .o_dsp_rsv_src2_prf_code_1(o_dsp_rsv_src2_prf_code_1),
    .o_dsp_rsv_src3_vld_1     (o_dsp_rsv_src3_vld_1),
    .o_dsp_rsv_src3_prf_code_1(o_dsp_rsv_src3_prf_code_1),
    .o_dsp_rsv_dst_vld_1      (o_dsp_rsv_dst_vld_1),
    .o_dsp_rsv_dst_prf_code_1 (o_dsp_rsv_dst_prf_code_1),
    .o_dsp_rsv_dst_pprf_code_1(o_dsp_rsv_dst_pprf_code_1),
    .o_dsp_rsv_src1_vld_2     (o_dsp_rsv_src1_vld_2),
    .o_dsp_rsv_src1_prf_code_2(o_dsp_rsv_src1_prf_code_2),
    .o_dsp_rsv_src2_vld_2     (o_dsp_rsv_src2_vld_2),
    .o_dsp_rsv_src2_prf_code_2(o_dsp_rsv_src2_prf_code_2),
    .o_dsp_rsv_src3_vld_2     (o_dsp_rsv_src3_vld_2),
    .o_dsp_rsv_src3_prf_code_2(o_dsp_rsv_src3_prf_code_2),
    .o_dsp_rsv_dst_vld_2      (o_dsp_rsv_dst_vld_2),
    .o_dsp_rsv_dst_prf_code_2 (o_dsp_rsv_dst_prf_code_2),
    .o_dsp_rsv_dst_pprf_code_2(o_dsp_rsv_dst_pprf_code_2),
    .o_dsp_rsv_src1_vld_3     (o_dsp_rsv_src1_vld_3),
    .o_dsp_rsv_src1_prf_code_3(o_dsp_rsv_src1_prf_code_3),
    .o_dsp_rsv_src2_vld_3     (o_dsp_rsv_src2_vld_3),
    .o_dsp_rsv_src2_prf_code_3(o_dsp_rsv_src2_prf_code_3),
    .o_dsp_rsv_src3_vld_3     (o_dsp_rsv_src3_vld_3),
    .o_dsp_rsv_src3_prf_code_3(o_dsp_rsv_src3_prf_code_3),
    .o_dsp_rsv_dst_vld_3      (o_dsp_rsv_dst_vld_3),
    .o_dsp_rsv_dst_prf_code_3 (o_dsp_rsv_dst_prf_code_3),
    .o_dsp_rsv_dst_pprf_code_3(o_dsp_rsv_dst_pprf_code_3),
    .o_dsp_rsv_len            (o_dsp_rsv_len),
    .o_dsp_rsv_decinfo_bus_0  (o_dsp_rsv_decinfo_bus_0),
    .o_dsp_rsv_decinfo_bus_1  (o_dsp_rsv_decinfo_bus_1),
    .o_dsp_rsv_decinfo_bus_2  (o_dsp_rsv_decinfo_bus_2),
    .o_dsp_rsv_decinfo_bus_3  (o_dsp_rsv_decinfo_bus_3),
    .o_dsp_rsv_free_entry_0   (o_dsp_rsv_free_entry_0),
    .o_dsp_rsv_free_entry_1   (o_dsp_rsv_free_entry_1),
    .o_dsp_rsv_free_entry_2   (o_dsp_rsv_free_entry_2),
    .o_dsp_rsv_free_entry_3   (o_dsp_rsv_free_entry_3),
    .o_dsp_rsv_rob_id_0       (o_dsp_rsv_rob_id_0),
    .o_dsp_rsv_ld_vld_0       (o_dsp_rsv_ld_vld_0),
    .o_dsp_rsv_ld_id_0        (o_dsp_rsv_ld_id_0),
    .o_dsp_rsv_st_vld_0       (o_dsp_rsv_st_vld_0),
    .o_dsp_rsv_st_id_0        (o_dsp_rsv_st_id_0),
    .o_dsp_rsv_rob_id_1       (o_dsp_rsv_rob_id_1),
    .o_dsp_rsv_ld_vld_1       (o_dsp_rsv_ld_vld_1),
    .o_dsp_rsv_ld_id_1        (o_dsp_rsv_ld_id_1),
    .o_dsp_rsv_st_vld_1       (o_dsp_rsv_st_vld_1),
    .o_dsp_rsv_st_id_1        (o_dsp_rsv_st_id_1),
    .o_dsp_rsv_rob_id_2       (o_dsp_rsv_rob_id_2),
    .o_dsp_rsv_ld_vld_2       (o_dsp_rsv_ld_vld_2),
    .o_dsp_rsv_ld_id_2        (o_dsp_rsv_ld_id_2),
    .o_dsp_rsv_st_vld_2       (o_dsp_rsv_st_vld_2),
    .o_dsp_rsv_st_id_2        (o_dsp_rsv_st_id_2),
    .o_dsp_rsv_rob_id_3       (o_dsp_rsv_rob_id_3),
    .o_dsp_rsv_ld_vld_3       (o_dsp_rsv_ld_vld_3),
    .o_dsp_rsv_ld_id_3        (o_dsp_rsv_ld_id_3),
    .o_dsp_rsv_st_vld_3       (o_dsp_rsv_st_vld_3),
    .o_dsp_rsv_st_id_3        (o_dsp_rsv_st_id_3),
    .o_dsp_rsv_rob_dsp_id     (o_dsp_rsv_rob_dsp_id),
    .o_dsp_rsv_rob_ret_id     (o_dsp_rsv_rob_ret_id),
    .o_dsp_rsv_st_dsp_id      (o_dsp_rsv_st_dsp_id),
    .o_dsp_rsv_st_ret_id      (o_dsp_rsv_st_ret_id),
    .o_dsp_rsv_st_rec_id      (o_dsp_rsv_st_rec_id),
    .o_dsp_rsv_ld_dsp_id      (o_dsp_rsv_ld_dsp_id),
    .o_dsp_rsv_ld_ret_id      (o_dsp_rsv_ld_ret_id),
    .o_dsp_rob_instr_0        (o_dsp_rob_instr_0),
    .o_dsp_rob_instr_1        (o_dsp_rob_instr_1),
    .o_dsp_rob_instr_2        (o_dsp_rob_instr_2),
    .o_dsp_rob_instr_3        (o_dsp_rob_instr_3),
    .o_dsp_rob_addr_0         (o_dsp_rob_addr_0),
    .o_dsp_rob_addr_1         (o_dsp_rob_addr_1),
    .o_dsp_rob_addr_2         (o_dsp_rob_addr_2),
    .o_dsp_rob_addr_3         (o_dsp_rob_addr_3),
    .o_dsp_rob_taddr_0        (o_dsp_rob_taddr_0),
    .o_dsp_rob_taddr_1        (o_dsp_rob_taddr_1),
    .o_dsp_rob_taddr_2        (o_dsp_rob_taddr_2),
    .o_dsp_rob_taddr_3        (o_dsp_rob_taddr_3),

    .o_dsp_ren_stall          (o_dsp_ren_stall),

    .clk                      (clk),
    .rst_n                    (rst_n)
);

/***************** Stage 7 *********************/
wire o_rsv_dsp_free_vld_0;
wire [`RSV_IDX_WIDTH - 1 : 0] o_rsv_dsp_free_vld_0;
wire o_rsv_dsp_free_vld_1;
wire [`RSV_IDX_WIDTH - 1 : 0] o_rsv_dsp_free_vld_1;
wire o_rsv_dsp_free_vld_2;
wire [`RSV_IDX_WIDTH - 1 : 0] o_rsv_dsp_free_vld_2;
wire o_rsv_dsp_free_vld_3;
wire [`RSV_IDX_WIDTH - 1 : 0] o_rsv_dsp_free_vld_3;


wire o_rsv_rob_dst_vld_0;
wire o_rsv_rob_dst_vld_1;
wire o_rsv_rob_dst_vld_2;
wire o_rsv_rob_dst_vld_3;
wire [`ARF_CODE_WIDTH - 1 : 0] o_rsv_rob_dst_arf_code_0;
wire [`ARF_CODE_WIDTH - 1 : 0] o_rsv_rob_dst_arf_code_1;
wire [`ARF_CODE_WIDTH - 1 : 0] o_rsv_rob_dst_arf_code_2;
wire [`ARF_CODE_WIDTH - 1 : 0] o_rsv_rob_dst_arf_code_3;
wire [`PRF_CODE_WIDTH - 1 : 0] o_rsv_rob_dst_prf_code_0;
wire [`PRF_CODE_WIDTH - 1 : 0] o_rsv_rob_dst_prf_code_1;
wire [`PRF_CODE_WIDTH - 1 : 0] o_rsv_rob_dst_prf_code_2;
wire [`PRF_CODE_WIDTH - 1 : 0] o_rsv_rob_dst_prf_code_3;
wire [`PRF_CODE_WIDTH - 1 : 0] o_rsv_rob_dst_pprf_code_0;
wire [`PRF_CODE_WIDTH - 1 : 0] o_rsv_rob_dst_pprf_code_1;
wire [`PRF_CODE_WIDTH - 1 : 0] o_rsv_rob_dst_pprf_code_2;
wire [`PRF_CODE_WIDTH - 1 : 0] o_rsv_rob_dst_pprf_code_3;
wire [`MEM_SIZE_WIDTH - 1 : 0] o_rsv_rob_mem_size_0;
wire [`MEM_SIZE_WIDTH - 1 : 0] o_rsv_rob_mem_size_1;
wire [`MEM_SIZE_WIDTH - 1 : 0] o_rsv_rob_mem_size_2;
wire [`MEM_SIZE_WIDTH - 1 : 0] o_rsv_rob_mem_size_3;
wire [`DECINFO_WIDTH - 1 : 0] o_rsv_rob_decinfo_bus_0;
wire [`DECINFO_WIDTH - 1 : 0] o_rsv_rob_decinfo_bus_1;
wire [`DECINFO_WIDTH - 1 : 0] o_rsv_rob_decinfo_bus_2;
wire [`DECINFO_WIDTH - 1 : 0] o_rsv_rob_decinfo_bus_3;
wire [`PREDINFO_WIDTH - 1 : 0] o_rsv_rob_predinfo_bus_0;
wire [`PREDINFO_WIDTH - 1 : 0] o_rsv_rob_predinfo_bus_1;
wire [`PREDINFO_WIDTH - 1 : 0] o_rsv_rob_predinfo_bus_2;
wire [`PREDINFO_WIDTH - 1 : 0] o_rsv_rob_predinfo_bus_3;
wire [3 : 0] o_rsv_rob_len;
wire [`CORE_PC_WIDTH - 1 : 0] o_rsv_rob_addr_0;
wire [`CORE_PC_WIDTH - 1 : 0] o_rsv_rob_taddr_0;
wire [`CORE_PC_WIDTH - 1 : 0] o_rsv_rob_addr_1;
wire [`CORE_PC_WIDTH - 1 : 0] o_rsv_rob_taddr_1;
wire [`CORE_PC_WIDTH - 1 : 0] o_rsv_rob_addr_2;
wire [`CORE_PC_WIDTH - 1 : 0] o_rsv_rob_taddr_2;
wire [`CORE_PC_WIDTH - 1 : 0] o_rsv_rob_addr_3;
wire [`CORE_PC_WIDTH - 1 : 0] o_rsv_rob_taddr_3;

wire o_rsv_exu_issue_vld_0;
wire o_rsv_exu_issue_vld_1;
wire o_rsv_exu_issue_vld_2;
wire o_rsv_exu_issue_vld_3;
wire o_rsv_exu_src1_vld_0;
wire [`PRF_DATA_WIDTH - 1 : 0] o_rsv_exu_src1_dat_0;
wire o_rsv_exu_src1_vld_1;
wire [`PRF_DATA_WIDTH - 1 : 0] o_rsv_exu_src1_dat_1;
wire o_rsv_exu_src1_vld_2;
wire [`PRF_DATA_WIDTH - 1 : 0] o_rsv_exu_src1_dat_2;
wire o_rsv_exu_src1_vld_3;
wire [`PRF_DATA_WIDTH - 1 : 0] o_rsv_exu_src1_dat_3;
wire o_rsv_exu_dst_vld_0;
wire o_rsv_exu_dst_vld_1;
wire o_rsv_exu_dst_vld_2;
wire o_rsv_exu_dst_vld_3;
wire [`PRF_CODE_WIDTH - 1 : 0] o_rsv_exu_dst_prf_code_0;
wire [`PRF_CODE_WIDTH - 1 : 0] o_rsv_exu_dst_prf_code_1;
wire [`PRF_CODE_WIDTH - 1 : 0] o_rsv_exu_dst_prf_code_2;
wire [`PRF_CODE_WIDTH - 1 : 0] o_rsv_exu_dst_prf_code_3;
wire [`EXCEPTION_CODE_WIDTH - 1 : 0] o_rsv_exu_excp_code_0;
wire [`EXCEPTION_CODE_WIDTH - 1 : 0] o_rsv_exu_excp_code_1;
wire [`EXCEPTION_CODE_WIDTH - 1 : 0] o_rsv_exu_excp_code_2;
wire [`EXCEPTION_CODE_WIDTH - 1 : 0] o_rsv_exu_excp_code_3;
wire [`DECINFO_WIDTH - 1 : 0] o_rsv_exu_decinfo_bus_0;
wire [`DECINFO_WIDTH - 1 : 0] o_rsv_exu_decinfo_bus_1;
wire [`DECINFO_WIDTH - 1 : 0] o_rsv_exu_decinfo_bus_2;
wire [`DECINFO_WIDTH - 1 : 0] o_rsv_exu_decinfo_bus_3;
wire [`PREDINFO_WIDTH - 1 : 0] o_rsv_exu_predinfo_bus_1;
wire [`IMM_WIDTH - 1 : 0] o_rsv_exu_imm_0;
wire [`IMM_WIDTH - 1 : 0] o_rsv_exu_imm_1;
wire [`IMM_WIDTH - 1 : 0] o_rsv_exu_imm_2;
wire [`IMM_WIDTH - 1 : 0] o_rsv_exu_imm_3;
wire o_rsv_exu_len_0;
wire o_rsv_exu_len_1;
wire o_rsv_exu_len_2;
wire o_rsv_exu_len_3;
wire [`ROB_ID_WIDTH - 1 : 0] o_rsv_exu_rob_id_0;
wire [`ROB_ID_WIDTH - 1 : 0] o_rsv_exu_rob_id_1;
wire [`ROB_ID_WIDTH - 1 : 0] o_rsv_exu_rob_id_2;
wire [`ROB_ID_WIDTH - 1 : 0] o_rsv_exu_rob_id_3;
wire [`MEM_SIZE_WIDTH - 1 : 0] o_rsv_exu_mem_size_3;
wire o_rsv_exu_ld_vld_3;
wire [`LBUFF_ID_WIDTH - 1 : 0] o_rsv_exu_ld_id_3;
wire o_rsv_exu_st_vld_3;
wire [`SBUFF_ID_WIDTH - 1 : 0] o_rsv_exu_st_id_3;


rsv_module rsv ( 
    .i_csr_trap_flush         (o_csr_trap_flush),
    .i_exu_mis_flush          (o_exu_mis_flush),
    .i_exu_mis_rob_id         (o_exu_mis_rob_id),
    .i_exu_ls_flush           (o_exu_ls_flush),
    .i_exu_ls_rob_id          (o_exu_ls_rob_id),

    .i_dsp_rsv_vld            (o_dsp_rsv_vld),
    .i_dsp_rsv_decinfo_bus_0  (o_dsp_rsv_decinfo_bus_0),
    .i_dsp_rsv_decinfo_bus_1  (o_dsp_rsv_decinfo_bus_1),
    .i_dsp_rsv_decinfo_bus_2  (o_dsp_rsv_decinfo_bus_2),
    .i_dsp_rsv_decinfo_bus_3  (o_dsp_rsv_decinfo_bus_3),
    .i_dsp_rsv_predinfo_bus_0 (o_dsp_rsv_predinfo_bus_0),
    .i_dsp_rsv_predinfo_bus_1 (o_dsp_rsv_predinfo_bus_1),
    .i_dsp_rsv_predinfo_bus_2 (o_dsp_rsv_predinfo_bus_2),
    .i_dsp_rsv_predinfo_bus_3 (o_dsp_rsv_predinfo_bus_3),
    .i_dsp_rsv_len            (o_dsp_rsv_len),
    .i_dsp_rsv_src1_vld_0     (o_dsp_rsv_src1_vld_0),
    .i_dsp_rsv_src1_prf_code_0(o_dsp_rsv_src1_prf_code_0),
    .i_dsp_rsv_src2_vld_0     (o_dsp_rsv_src2_vld_0),
    .i_dsp_rsv_src2_prf_code_0(o_dsp_rsv_src2_prf_code_0),
    .i_dsp_rsv_src3_vld_0     (o_dsp_rsv_src3_vld_0),
    .i_dsp_rsv_src3_prf_code_0(o_dsp_rsv_src3_prf_code_0),
    .i_dsp_rsv_dst_vld_0      (o_dsp_rsv_dst_vld_0),
    .i_dsp_rsv_dst_prf_code_0 (o_dsp_rsv_dst_prf_code_0),
    .i_dsp_rsv_dst_pprf_code_0(o_dsp_rsv_dst_pprf_code_0),
    .i_dsp_rsv_src1_vld_1     (o_dsp_rsv_src1_vld_1),
    .i_dsp_rsv_src1_prf_code_1(o_dsp_rsv_src1_prf_code_1),
    .i_dsp_rsv_src2_vld_1     (o_dsp_rsv_src2_vld_1),
    .i_dsp_rsv_src2_prf_code_1(o_dsp_rsv_src2_prf_code_1),
    .i_dsp_rsv_src3_vld_1     (o_dsp_rsv_src3_vld_1),
    .i_dsp_rsv_src3_prf_code_1(o_dsp_rsv_src3_prf_code_1),
    .i_dsp_rsv_dst_vld_1      (o_dsp_rsv_dst_vld_1),
    .i_dsp_rsv_dst_prf_code_1 (o_dsp_rsv_dst_prf_code_1),
    .i_dsp_rsv_dst_pprf_code_1(o_dsp_rsv_dst_pprf_code_1),
    .i_dsp_rsv_src1_vld_2     (o_dsp_rsv_src1_vld_2),
    .i_dsp_rsv_src1_prf_code_2(o_dsp_rsv_src1_prf_code_2),
    .i_dsp_rsv_src2_vld_2     (o_dsp_rsv_src2_vld_2),
    .i_dsp_rsv_src2_prf_code_2(o_dsp_rsv_src2_prf_code_2),
    .i_dsp_rsv_src3_vld_2     (o_dsp_rsv_src3_vld_2),
    .i_dsp_rsv_src3_prf_code_2(o_dsp_rsv_src3_prf_code_2),
    .i_dsp_rsv_dst_vld_2      (o_dsp_rsv_dst_vld_2),
    .i_dsp_rsv_dst_prf_code_2 (o_dsp_rsv_dst_prf_code_2),
    .i_dsp_rsv_dst_pprf_code_2(o_dsp_rsv_dst_pprf_code_2),
    .i_dsp_rsv_src1_vld_3     (o_dsp_rsv_src1_vld_3),
    .i_dsp_rsv_src1_prf_code_3(o_dsp_rsv_src1_prf_code_3),
    .i_dsp_rsv_src2_vld_3     (o_dsp_rsv_src2_vld_3),
    .i_dsp_rsv_src2_prf_code_3(o_dsp_rsv_src2_prf_code_3),
    .i_dsp_rsv_src3_vld_3     (o_dsp_rsv_src3_vld_3),
    .i_dsp_rsv_src3_prf_code_3(o_dsp_rsv_src3_prf_code_3),
    .i_dsp_rsv_dst_vld_3      (o_dsp_rsv_dst_vld_3),
    .i_dsp_rsv_dst_prf_code_3 (o_dsp_rsv_dst_prf_code_3),
    .i_dsp_rsv_dst_pprf_code_3(o_dsp_rsv_dst_pprf_code_3),
    .i_dsp_rsv_free_entry_0   (o_dsp_rsv_free_entry_0),
    .i_dsp_rsv_free_entry_1   (o_dsp_rsv_free_entry_1),
    .i_dsp_rsv_free_entry_2   (o_dsp_rsv_free_entry_2),
    .i_dsp_rsv_free_entry_3   (o_dsp_rsv_free_entry_3),
    .i_dsp_rsv_rob_id_0       (o_dsp_rsv_rob_id_0),
    .i_dsp_rsv_ld_vld_0       (o_dsp_rsv_ld_vld_0),
    .i_dsp_rsv_ld_id_0        (o_dsp_rsv_ld_id_0),
    .i_dsp_rsv_st_vld_0       (o_dsp_rsv_st_vld_0),
    .i_dsp_rsv_st_id_0        (o_dsp_rsv_st_id_0),
    .i_dsp_rsv_rob_id_1       (o_dsp_rsv_rob_id_1),
    .i_dsp_rsv_ld_vld_1       (o_dsp_rsv_ld_vld_1),
    .i_dsp_rsv_ld_id_1        (o_dsp_rsv_ld_id_1),
    .i_dsp_rsv_st_vld_1       (o_dsp_rsv_st_vld_1),
    .i_dsp_rsv_st_id_1        (o_dsp_rsv_st_id_1),
    .i_dsp_rsv_rob_id_2       (o_dsp_rsv_rob_id_2),
    .i_dsp_rsv_ld_vld_2       (o_dsp_rsv_ld_vld_2),
    .i_dsp_rsv_ld_id_2        (o_dsp_rsv_ld_id_2),
    .i_dsp_rsv_st_vld_2       (o_dsp_rsv_st_vld_2),
    .i_dsp_rsv_st_id_2        (o_dsp_rsv_st_id_2),
    .i_dsp_rsv_rob_id_3       (o_dsp_rsv_rob_id_3),
    .i_dsp_rsv_ld_vld_3       (o_dsp_rsv_ld_vld_3),
    .i_dsp_rsv_ld_id_3        (o_dsp_rsv_ld_id_3),
    .i_dsp_rsv_st_vld_3       (o_dsp_rsv_st_vld_3),
    .i_dsp_rsv_st_id_3        (o_dsp_rsv_st_id_3),

    .i_ren_prf_free_req_0     (o_dec_prf_free_req_0),
    .i_ren_prf_free_req_1     (o_dec_prf_free_req_1),
    .i_ren_prf_free_req_2     (o_dec_prf_free_req_2),
    .i_ren_prf_free_req_3     (o_dec_prf_free_req_3),
    .i_ren_prf_free_prf_code_0(o_dec_prf_code_0),
    .i_ren_prf_free_prf_code_1(o_dec_prf_code_1),
    .i_ren_prf_free_prf_code_2(o_dec_prf_code_2),
    .i_ren_prf_free_prf_code_3(o_dec_prf_code_3),
    
    .i_exu_rsv_wb_vld_0       (o_exu_rsv_wren_0),
    .i_exu_rsv_wb_prf_code_0  (o_exu_rsv_wr_prf_code_0),
    .i_exu_rsv_wb_dat_0       (o_exu_rsv_wr_dat_0),
    .i_exu_rsv_wb_vld_1       (i_exu_rsv_wb_vld_1),
    .i_exu_rsv_wb_prf_code_1  (i_exu_rsv_wb_prf_code_1),
    .i_exu_rsv_wb_dat_1       (i_exu_rsv_wb_dat_1),
    .i_exu_rsv_wb_vld_2       (i_exu_rsv_wb_vld_2),
    .i_exu_rsv_wb_prf_code_2  (i_exu_rsv_wb_prf_code_2),
    .i_exu_rsv_wb_dat_2       (i_exu_rsv_wb_dat_2),
    .i_exu_rsv_wb_vld_3       (i_exu_rsv_wb_vld_3),
    .i_exu_rsv_wb_prf_code_3  (i_exu_rsv_wb_prf_code_3),
    .i_exu_rsv_wb_dat_3       (i_exu_rsv_wb_dat_3),

    .o_rsv_dsp_free_vld_0     (o_rsv_dsp_free_vld_0),
    .o_rsv_dsp_free_entry_0   (o_rsv_dsp_free_entry_0),
    .o_rsv_dsp_free_vld_1     (o_rsv_dsp_free_vld_1),
    .o_rsv_dsp_free_entry_1   (o_rsv_dsp_free_entry_1),
    .o_rsv_dsp_free_vld_2     (o_rsv_dsp_free_vld_2),
    .o_rsv_dsp_free_entry_2   (o_rsv_dsp_free_entry_2),
    .o_rsv_dsp_free_vld_3     (o_rsv_dsp_free_vld_3),
    .o_rsv_dsp_free_entry_3   (o_rsv_dsp_free_entry_3),

    .o_rsv_rob_len            (o_rsv_rob_len),
    .o_rsv_exu_issue_vld_0    (o_rsv_exu_issue_vld_0),
    .o_rsv_exu_issue_vld_1    (o_rsv_exu_issue_vld_1),
    .o_rsv_exu_issue_vld_2    (o_rsv_exu_issue_vld_2),
    .o_rsv_exu_issue_vld_3    (o_rsv_exu_issue_vld_3),
    .o_rsv_exu_src1_vld_0     (o_rsv_exu_src1_vld_0),
    .o_rsv_exu_src1_dat_0     (o_rsv_exu_src1_dat_0),
    .o_rsv_exu_src2_vld_0     (o_rsv_exu_src2_vld_0),
    .o_rsv_exu_src2_dat_0     (o_rsv_exu_src2_dat_0),
    .o_rsv_exu_src3_vld_0     (o_rsv_exu_src3_vld_0),
    .o_rsv_exu_src3_dat_0     (o_rsv_exu_src3_dat_0),
    .o_rsv_exu_dst_vld_0      (o_rsv_exu_dst_vld_0),
    .o_rsv_exu_dst_prf_code_0 (o_rsv_exu_dst_prf_code_0),
    .o_rsv_exu_excp_code_0    (o_rsv_exu_excp_code_0),
    .o_rsv_exu_decinfo_bus_0  (o_rsv_exu_decinfo_bus_0),
    .o_rsv_exu_imm_0          (o_rsv_exu_imm_0),
    .o_rsv_exu_len_0          (o_rsv_exu_len_0),
    .o_rsv_exu_rob_id_0       (o_rsv_exu_rob_id_0),
    .o_rsv_exu_src1_vld_1     (o_rsv_exu_src1_vld_1),
    .o_rsv_exu_src1_dat_1     (o_rsv_exu_src1_dat_1),
    .o_rsv_exu_src2_vld_1     (o_rsv_exu_src2_vld_1),
    .o_rsv_exu_src2_dat_1     (o_rsv_exu_src2_dat_1),
    .o_rsv_exu_src3_vld_1     (o_rsv_exu_src3_vld_1),
    .o_rsv_exu_src3_dat_1     (o_rsv_exu_src3_dat_1),
    .o_rsv_exu_dst_vld_1      (o_rsv_exu_dst_vld_1),
    .o_rsv_exu_dst_prf_code_1 (o_rsv_exu_dst_prf_code_1),
    .o_rsv_exu_excp_code_1    (o_rsv_exu_excp_code_1),
    .o_rsv_exu_predinfo_bus_1 (o_rsv_exu_predinfo_bus_1),
    .o_rsv_exu_decinfo_bus_1  (o_rsv_exu_decinfo_bus_1),
    .o_rsv_exu_imm_1          (o_rsv_exu_imm_1),
    .o_rsv_exu_len_1          (o_rsv_exu_len_1),
    .o_rsv_exu_rob_id_1       (o_rsv_exu_rob_id_1),
    .o_rsv_exu_src1_vld_2     (o_rsv_exu_src1_vld_2),
    .o_rsv_exu_src1_dat_2     (o_rsv_exu_src1_dat_2),
    .o_rsv_exu_src2_vld_2     (o_rsv_exu_src2_vld_2),
    .o_rsv_exu_src2_dat_2     (o_rsv_exu_src2_dat_2),
    .o_rsv_exu_src3_vld_2     (o_rsv_exu_src3_vld_2),
    .o_rsv_exu_src3_dat_2     (o_rsv_exu_src3_dat_2),
    .o_rsv_exu_dst_vld_2      (o_rsv_exu_dst_vld_2),
    .o_rsv_exu_dst_prf_code_2 (o_rsv_exu_dst_prf_code_2),
    .o_rsv_exu_excp_code_2    (o_rsv_exu_excp_code_2),
    .o_rsv_exu_decinfo_bus_2  (o_rsv_exu_decinfo_bus_2),
    .o_rsv_exu_imm_2          (o_rsv_exu_imm_2),
    .o_rsv_exu_len_2          (o_rsv_exu_len_2),
    .o_rsv_exu_rob_id_2       (o_rsv_exu_rob_id_2),
    .o_rsv_exu_src1_vld_3     (o_rsv_exu_src1_vld_3),
    .o_rsv_exu_src1_dat_3     (o_rsv_exu_src1_dat_3),
    .o_rsv_exu_src2_vld_3     (o_rsv_exu_src2_vld_3),
    .o_rsv_exu_src2_dat_3     (o_rsv_exu_src2_dat_3),
    .o_rsv_exu_src3_vld_3     (o_rsv_exu_src3_vld_3),
    .o_rsv_exu_src3_dat_3     (o_rsv_exu_src3_dat_3),
    .o_rsv_exu_dst_vld_3      (o_rsv_exu_dst_vld_3),
    .o_rsv_exu_dst_prf_code_3 (o_rsv_exu_dst_prf_code_3),
    .o_rsv_exu_excp_code_3    (o_rsv_exu_excp_code_3),
    .o_rsv_exu_decinfo_bus_3  (o_rsv_exu_decinfo_bus_3),
    .o_rsv_exu_imm_3          (o_rsv_exu_imm_3),
    .o_rsv_exu_len_3          (o_rsv_exu_len_3),
    .o_rsv_exu_rob_id_3       (o_rsv_exu_rob_id_3),
    .o_rsv_exu_ld_vld_3       (o_rsv_exu_ld_vld_3),
    .o_rsv_exu_ld_id_3        (o_rsv_exu_ld_id_3),
    .o_rsv_exu_st_vld_3       (o_rsv_exu_st_vld_3),
    .o_rsv_exu_st_id_3        (o_rsv_exu_st_id_3),

    .clk                      (clk),
    .rst_n                    (rst_n)
);

/***************** Stage 8 *********************/
wire o_exu_mis_flush;
wire [`CORE_PC_WIDTH - 1 : 0] o_exu_mis_addr;
wire [`ROB_ID_WIDTH - 1 : 0] o_exu_mis_rob_id;

wire o_exu_ls_flush;
wire [`CORE_PC_WIDTH - 1 : 0] o_exu_ls_addr;
wire [`ROB_ID_WIDTH - 1 : 0] o_exu_ls_rob_id;

wire [`CSR_ADDR_WIDTH - 1 : 0] o_exu_csr_addr;
wire o_exu_csr_wren;
wire [`PRF_DATA_WIDTH - 1 : 0] o_exu_csr_wdat;
wire o_exu_rsv_wren_0;
wire [`PRF_CODE_WIDTH - 1 : 0] o_exu_rsv_wr_prf_code_0;
wire [`PRF_DATA_WIDTH - 1 : 0] o_exu_rsv_wr_dat_0;
wire o_exu_rsv_busy_0;
wire o_exu_rob_vld_0;
wire [`EXCEPTION_CODE_WIDTH - 1 : 0] o_exu_rob_excp_code_0;
wire [`ROB_ID_WIDTH - 1 : 0] o_exu_rob_rob_id_0;
wire [31 : 0] o_exu_rob_fence_src1;
wire [31 : 0] o_exu_rob_fence_src2;

wire o_exu_rsv_wren_1;
wire [`PRF_CODE_WIDTH - 1 : 0] o_exu_rsv_wr_prf_code_1;
wire [`PRF_DATA_WIDTH - 1 : 0] o_exu_rsv_wr_dat_1;
wire o_exu_rsv_busy_1;
wire o_exu_rob_vld_1;
wire [`EXCEPTION_CODE_WIDTH - 1 : 0] o_exu_rob_excp_code_0;
wire o_exu_iq_btac_vld;
wire o_exu_iq_btac_taken;
wire o_exu_iq_btac_new_br;
wire o_exu_iq_type;
wire [`CORE_PC_WIDTH - 1 : 0] o_exu_iq_btac_addr;
wire [`CORE_PC_WIDTH - 1 : 0] o_exu_iq_btac_taddr;
wire [`BTAC_IDX_WIDTH - 1 : 0] o_exu_iq_btac_idx;
wire [`PHT_IDX_WIDTH - 1 : 0] o_exu_iq_pht_idx;
wire [1 : 0] o_exu_iq_pht_status;
wire o_exu_iq_len;
wire o_exu_iq_tsucc;

wire o_exu_rsv_wren_2;
wire [`PRF_CODE_WIDTH - 1 : 0] o_exu_rsv_wr_prf_code_2;
wire [`PRF_DATA_WIDTH - 1 : 0] o_exu_rsv_wr_dat_2;
wire o_exu_rsv_busy_2;
wire o_exu_rob_vld_2;
wire [`ROB_ID_WIDTH - 1 : 0] o_exu_rob_rob_id_2;

wire o_exu_rsv_wren_3;
wire [`PRF_CODE_WIDTH - 1 : 0] o_exu_rsv_wr_prf_code_3;
wire [`PRF_DATA_WIDTH - 1 : 0] o_exu_rsv_wr_dat_3;
wire o_exu_rsv_busy_3;
wire o_exu_rob_vld_3;
wire [`EXCEPTION_CODE_WIDTH - 1 : 0] o_exu_rob_excp_code_3;
wire [`ROB_ID_WIDTH - 1 : 0] o_exu_rob_rob_id_3;
wire o_dtlb_mmu_vld;
wire [`CORE_PC_WIDTH - 1 : 0] o_dtlb_mmu_vaddr;
wire o_exu_mem_rd_vld;
wire [`PHY_ADDR_WIDTH - 1 : 0] o_exu_mem_wr_paddr;
wire o_exu_dsp_s_ret;
wire o_exu_rob_s_ret_done;

exu_top_module exu ( 
    .i_csr_trap_flush       (o_csr_trap_flush),
    .i_csr_rv_mode          (o_csr_rv_mode),
    .i_csr_mmu_satp         (o_csr_mmu_satp),

    .i_rsv_exu_vld_0        (o_rsv_exu_issue_vld_0),
    .i_rsv_exu_src1_vld_0   (o_rsv_exu_src1_vld_0),
    .i_rsv_exu_src1_dat_0   (o_rsv_exu_src1_dat_0),
    .i_rsv_exu_src2_vld_0   (o_rsv_exu_src2_vld_0),
    .i_rsv_exu_src2_dat_0   (o_rsv_exu_src2_dat_0),
    .i_rsv_exu_src3_vld_0   (o_rsv_exu_src3_vld_0),
    .i_rsv_exu_src3_dat_0   (o_rsv_exu_src3_dat_0),
    .i_rsv_exu_dst_vld_0    (o_rsv_exu_dst_vld_0),
    .i_rsv_exu_dst_code_0   (o_rsv_exu_dst_prf_code_0),
    .i_rsv_exu_imm_0        (o_rsv_exu_imm_0),
    .i_rsv_exu_rob_id_0     (o_rsv_exu_rob_id_0),
    .i_rsv_exu_decinfo_bus_0(o_rsv_exu_decinfo_bus_0),
    .i_rsv_exu_len_0        (o_rsv_exu_len_0),
    .i_rob_exu_addr_0       (o_rob_exu_addr_0),
    .i_rsv_exu_excp_code_0  (o_rsv_exu_excp_code_0),
    .i_csr_exu_rdat_0       (o_csr_exu_rdat),

    .i_rsv_exu_vld_1        (o_rsv_exu_issue_vld_1),
    .i_rsv_exu_src1_vld_1   (o_rsv_exu_src1_vld_1),
    .i_rsv_exu_src1_dat_1   (o_rsv_exu_src1_dat_1),
    .i_rsv_exu_src2_vld_1   (o_rsv_exu_src2_vld_1),
    .i_rsv_exu_src2_dat_1   (o_rsv_exu_src2_dat_1),
    .i_rsv_exu_src3_vld_1   (o_rsv_exu_src3_vld_1),
    .i_rsv_exu_src3_dat_1   (o_rsv_exu_src3_dat_1),
    .i_rsv_exu_dst_vld_1    (o_rsv_exu_dst_vld_1),
    .i_rsv_exu_dst_code_1   (o_rsv_exu_dst_prf_code_0),
    .i_rsv_exu_imm_1        (o_rsv_exu_imm_1),
    .i_rsv_exu_rob_id_1     (o_rsv_exu_rob_id_1),
    .i_rsv_exu_decinfo_bus_1(o_rsv_exu_decinfo_bus_1),
    .i_rsv_exu_predinfo_bus_1(o_rsv_exu_predinfo_bus_1),
    .i_rsv_exu_len_1        (o_rsv_exu_len_1),
    .i_rob_exu_addr_1       (o_rob_exu_addr_1),
    .i_rob_exu_taddr_1      (o_rob_exu_taddr_1),
    .i_rsv_exu_excp_code_1  (o_rsv_exu_excp_code_1),

    .i_rsv_exu_vld_2        (o_rsv_exu_issue_vld_2),
    .i_rsv_exu_src1_vld_2   (o_rsv_exu_src1_vld_2),
    .i_rsv_exu_src1_dat_2   (o_rsv_exu_src1_dat_2),
    .i_rsv_exu_src2_vld_2   (o_rsv_exu_src2_vld_2),
    .i_rsv_exu_src2_dat_2   (o_rsv_exu_src2_dat_2),
    .i_rsv_exu_src3_vld_2   (o_rsv_exu_src3_vld_2),
    .i_rsv_exu_src3_dat_2   (o_rsv_exu_src3_dat_2),
    .i_rsv_exu_dst_vld_2    (o_rsv_exu_dst_vld_2),
    .i_rsv_exu_dst_code_2   (o_rsv_exu_dst_prf_code_2),
    .i_rsv_exu_imm_2        (o_rsv_exu_imm_2),
    .i_rsv_exu_rob_id_2     (o_rsv_exu_rob_id_2),
    .i_rsv_exu_decinfo_bus_2(o_rsv_exu_decinfo_bus_2),
    .i_rsv_exu_len_2        (o_rsv_exu_len_2),
    .i_rsv_exu_excp_code_2  (o_rsv_exu_excp_code_2),

    .i_rsv_exu_vld_3        (o_rsv_exu_issue_vld_3),
    .i_rsv_exu_src1_vld_3   (o_rsv_exu_src1_vld_3),
    .i_rsv_exu_src1_dat_3   (o_rsv_exu_src1_dat_3),
    .i_rsv_exu_src2_vld_3   (o_rsv_exu_src2_vld_3),
    .i_rsv_exu_src2_dat_3   (o_rsv_exu_src2_dat_3),
    .i_rsv_exu_src3_vld_3   (o_rsv_exu_src3_vld_3),
    .i_rsv_exu_src3_dat_3   (o_rsv_exu_src3_dat_3),
    .i_rsv_exu_dst_vld_3    (o_rsv_exu_dst_vld_3),
    .i_rsv_exu_dst_code_3   (o_rsv_exu_dst_prf_code_3),
    .i_rsv_exu_rob_id_3     (o_rsv_exu_rob_id_3),
    .i_rsv_exu_ld_vld_3     (o_rsv_exu_ld_vld_3),
    .i_rsv_exu_ld_id_3      (o_rsv_exu_ld_id_3),
    .i_rsv_exu_st_vld_3     (o_rsv_exu_st_vld_3),
    .i_rsv_exu_st_id_3      (o_rsv_exu_st_id_3),
    .i_rsv_exu_decinfo_bus_3(o_rsv_exu_decinfo_bus_3),
    .i_rsv_exu_imm_3        (o_rsv_exu_imm_3),

    .i_dsp_rsv_vld          (o_dsp_rsv_vld),
    .i_dsp_rsv_rob_id_0     (o_dsp_rsv_rob_id_0),
    .i_dsp_rsv_ld_vld_0     (o_dsp_rsv_ld_vld_0),
    .i_dsp_rsv_ld_id_0      (o_dsp_rsv_ld_id_0),
    .i_dsp_rsv_st_vld_0     (o_dsp_rsv_st_vld_0),
    .i_dsp_rsv_st_id_0      (o_dsp_rsv_st_id_0),
    .i_dsp_rsv_dst_vld_0    (o_dsp_rsv_dst_vld_0),
    .i_dsp_rsv_dst_code_0   (o_dsp_rsv_dst_prf_code_0),
    .i_dsp_rsv_decinfo_bus_0(o_dsp_rsv_decinfo_bus_0),
    .i_dsp_rsv_rob_id_1     (o_dsp_rsv_rob_id_1),
    .i_dsp_rsv_ld_vld_1     (o_dsp_rsv_ld_vld_1),
    .i_dsp_rsv_ld_id_1      (o_dsp_rsv_ld_id_1),
    .i_dsp_rsv_st_vld_1     (o_dsp_rsv_st_vld_1),
    .i_dsp_rsv_st_id_1      (o_dsp_rsv_st_id_1),
    .i_dsp_rsv_dst_vld_1    (o_dsp_rsv_dst_vld_1),
    .i_dsp_rsv_dst_code_1   (o_dsp_rsv_dst_prf_code_1),
    .i_dsp_rsv_decinfo_bus_1(o_dsp_rsv_decinfo_bus_1),
    .i_dsp_rsv_rob_id_2     (o_dsp_rsv_rob_id_2),
    .i_dsp_rsv_ld_vld_2     (o_dsp_rsv_ld_vld_2),
    .i_dsp_rsv_ld_id_2      (o_dsp_rsv_ld_id_2),
    .i_dsp_rsv_st_vld_2     (o_dsp_rsv_st_vld_2),
    .i_dsp_rsv_st_id_2      (o_dsp_rsv_st_id_2),
    .i_dsp_rsv_dst_vld_2    (o_dsp_rsv_dst_vld_2),
    .i_dsp_rsv_dst_code_2   (o_dsp_rsv_dst_prf_code_2),
    .i_dsp_rsv_decinfo_bus_2(o_dsp_rsv_decinfo_bus_2),
    .i_dsp_rsv_rob_id_3     (o_dsp_rsv_rob_id_3),
    .i_dsp_rsv_ld_vld_3     (o_dsp_rsv_ld_vld_3),
    .i_dsp_rsv_ld_id_3      (o_dsp_rsv_ld_id_3),
    .i_dsp_rsv_st_vld_3     (o_dsp_rsv_st_vld_3),
    .i_dsp_rsv_st_id_3      (o_dsp_rsv_st_id_3),
    .i_dsp_rsv_dst_vld_3    (o_dsp_rsv_dst_vld_3),
    .i_dsp_rsv_dst_code_3   (o_dsp_rsv_dst_prf_code_3),
    .i_dsp_rsv_decinfo_bus_3(o_dsp_rsv_decinfo_bus_3),
    .i_dsp_exu_ld_dsp_ptr   (o_dsp_rsv_ld_dsp_id),
    .i_dsp_exu_ld_ret_ptr   (o_dsp_rsv_ld_ret_id),
    .i_dsp_exu_st_dsp_ptr   (o_dsp_rsv_st_dsp_id),
    .i_dsp_exu_st_ret_ptr   (o_dsp_rsv_st_ret_id),
    .i_dsp_exu_st_ret_cptr  (o_dsp_rsv_st_rec_id),
    .i_rob_exu_ret_vld      (o_rob_dsp_ret_vld),
    .i_rob_exu_ret_ld_vld_0 (o_rob_dsp_ret_ld_vld_0),
    .i_rob_exu_ret_ld_id_0  (o_rob_dsp_ret_ld_id_0),
    .i_rob_exu_ret_st_vld_0 (o_rob_dsp_ret_st_vld_0),
    .i_rob_exu_ret_st_id_0  (o_rob_dsp_ret_st_id_0),
    .i_rob_exu_ret_ld_vld_1 (o_rob_dsp_ret_ld_vld_1),
    .i_rob_exu_ret_ld_id_1  (o_rob_dsp_ret_ld_id_1),
    .i_rob_exu_ret_st_vld_1 (o_rob_dsp_ret_st_vld_1),
    .i_rob_exu_ret_st_id_1  (o_rob_dsp_ret_st_id_1),
    .i_rob_exu_ret_ld_vld_2 (o_rob_dsp_ret_ld_vld_2),
    .i_rob_exu_ret_ld_id_2  (o_rob_dsp_ret_ld_id_2),
    .i_rob_exu_ret_st_vld_2 (o_rob_dsp_ret_st_vld_2),
    .i_rob_exu_ret_st_id_2  (o_rob_dsp_ret_st_id_2),
    .i_rob_exu_ret_ld_vld_3 (o_rob_dsp_ret_ld_vld_3),
    .i_rob_exu_ret_ld_id_3  (o_rob_dsp_ret_ld_id_3),
    .i_rob_exu_ret_st_vld_3 (o_rob_dsp_ret_st_vld_3),
    .i_rob_exu_ret_st_id_3  (o_rob_dsp_ret_st_id_3),
    .i_rob_exu_ls_addr      (o_rob_exu_ls_addr),
    .i_rob_dtlb_flush       (o_rob_dtlb_flush),
    .i_rob_dtlb_src1        (o_rob_dtlb_src1),
    .i_rob_dtlb_src2        (o_rob_dtlb_src2),
    .i_mmu_busy             (o_mmu_busy),
    .i_mmu_dtlb_vld         (o_mmu_dtlb_vld),
    .i_mmu_dtlb_tlb         (o_mmu_dtlb_tlb),
    .i_mmu_dtlb_excp_code   (o_mmu_dtlb_excp_code),
    .i_mmu_dcache_vld       (o_mem_exu_vld),
    .i_mmu_dcache_dat       (o_mem_exu_dat),
    .i_mmu_exu_done         (o_mem_exu_done),

    .o_exu_csr_addr         (o_exu_csr_addr),
    .o_exu_csr_wren         (o_exu_csr_wren),
    .o_exu_csr_wdat         (o_exu_csr_wdat),
    .o_exu_rsv_wren_0       (o_exu_rsv_wren_0),
    .o_exu_rsv_wr_prf_code_0(o_exu_rsv_wr_prf_code_0),
    .o_exu_rsv_wr_dat_0     (o_exu_rsv_wr_dat_0),
    .o_exu_rsv_busy_0       (o_exu_rsv_busy_0),
    .o_exu_rob_vld_0        (o_exu_rob_vld_0),
    .o_exu_rob_excp_code_0  (o_exu_rob_excp_code_0),
    .o_exu_rob_rob_id_0     (o_exu_rob_rob_id_0),
    .o_exu_rob_fence_src1   (o_exu_rob_fence_src1),
    .o_exu_rob_fence_src2   (o_exu_rob_fence_src2),

    .o_exu_rsv_wren_1       (o_exu_rsv_wren_1),
    .o_exu_rsv_wr_prf_code_1(o_exu_rsv_wr_prf_code_1),
    .o_exu_rsv_wr_dat_1     (o_exu_rsv_wr_dat_1),
    .o_exu_rsv_busy_1       (o_exu_rsv_busy_1),
    .o_exu_rob_vld_1        (o_exu_rob_vld_1),
    .o_exu_rob_excp_code_1  (o_exu_rob_excp_code_1),
    .o_exu_rob_rob_id_1     (o_exu_rob_rob_id_1),
    .o_exu_mis_flush        (o_exu_mis_flush),
    .o_exu_mis_rob_id       (o_exu_mis_rob_id),
    .o_exu_mis_addr         (o_exu_mis_addr),
    .o_exu_iq_btac_vld      (o_exu_iq_btac_vld),
    .o_exu_iq_btac_taken    (o_exu_iq_btac_taken),
    .o_exu_iq_btac_new_br   (o_exu_iq_btac_new_br),
    .o_exu_iq_type          (o_exu_iq_type),
    .o_exu_iq_btac_addr     (o_exu_iq_btac_addr),
    .o_exu_iq_btac_taddr    (o_exu_iq_btac_taddr),
    .o_exu_iq_btac_idx      (o_exu_iq_btac_idx),
    .o_exu_iq_pht_idx       (o_exu_iq_pht_idx),
    .o_exu_iq_pht_status    (o_exu_iq_pht_status),
    .o_exu_iq_len           (o_exu_iq_len),
    .o_exu_iq_tsucc         (o_exu_iq_tsucc),

    .o_exu_rsv_wren_2       (o_exu_rsv_wren_2),
    .o_exu_rsv_wr_prf_code_2(o_exu_rsv_wr_prf_code_2),
    .o_exu_rsv_wr_dat_2     (o_exu_rsv_wr_dat_2),
    .o_exu_rsv_busy_2       (o_exu_rsv_busy_2),
    .o_exu_rob_vld_2        (o_exu_rob_vld_2),
    .o_exu_rob_excp_code_2  (o_exu_rob_excp_code_2),
    .o_exu_rob_rob_id_2     (o_exu_rob_rob_id_2),

    .o_exu_rsv_wren_3       (o_exu_rsv_wren_3),
    .o_exu_rsv_wr_prf_code_3(o_exu_rsv_wr_prf_code_3),
    .o_exu_rsv_wr_dat_3     (o_exu_rsv_wr_dat_3),
    .o_exu_rsv_busy_3       (o_exu_rsv_busy_3),
    .o_exu_rob_vld_3        (o_exu_rob_vld_3),
    .o_exu_rob_excp_code_3  (o_exu_rob_excp_code_3),
    .o_exu_rob_rob_id_3     (o_exu_rob_rob_id_3),
    .o_exu_ls_flush         (o_exu_ls_flush),
    .o_exu_ls_rob_id        (o_exu_ls_rob_id),
    .o_exu_ls_addr          (o_exu_ls_addr),
    .o_dtlb_mmu_vld         (o_dtlb_mmu_vld),
    .o_dtlb_mmu_vaddr       (o_dtlb_mmu_vaddr),
    .o_exu_mem_rd_vld       (o_exu_mem_rd_vld),
    .o_exu_mem_rd_paddr     (o_exu_mem_rd_paddr),
    .o_exu_mem_wr_vld       (o_exu_mem_wr_vld),
    .o_exu_mem_wdat         (o_exu_mem_wdat),
    .o_exu_mem_wr_paddr     (o_exu_mem_wr_paddr),
    .o_exu_dsp_s_ret        (o_exu_dsp_s_ret),
    .o_exu_rob_s_ret_done   (o_exu_rob_s_ret_done),

    .clk                    (clk),
    .rst_n                  (rst_n)
);

/***************** Stage 9 *********************/

wire [3 : 0] o_rob_ren_ret_vld;
wire o_rob_ren_ret_dst_vld_0;
wire [`ARF_CODE_WIDTH - 1 : 0] o_rob_ren_ret_arf_code_0;
wire [`PRF_CODE_WIDTH - 1 : 0] o_rob_ren_ret_prf_code_0;
wire o_rob_ren_ret_dst_vld_1;
wire [`ARF_CODE_WIDTH - 1 : 0] o_rob_ren_ret_arf_code_1;
wire [`PRF_CODE_WIDTH - 1 : 0] o_rob_ren_ret_prf_code_1;
wire o_rob_ren_ret_dst_vld_2;
wire [`ARF_CODE_WIDTH - 1 : 0] o_rob_ren_ret_arf_code_2;
wire [`PRF_CODE_WIDTH - 1 : 0] o_rob_ren_ret_prf_code_2;
wire o_rob_ren_ret_dst_vld_3;
wire [`ARF_CODE_WIDTH - 1 : 0] o_rob_ren_ret_arf_code_3;
wire [`PRF_CODE_WIDTH - 1 : 0] o_rob_ren_ret_prf_code_3;

wire [3 : 0] o_rob_ren_rec_vld;
wire o_rob_ren_rec_dst_vld_0;
wire [`ARF_CODE_WIDTH - 1 : 0] o_rob_ren_rec_arf_code_0;
wire [`PRF_CODE_WIDTH - 1 : 0] o_rob_ren_rec_prf_code_0;
wire o_rob_ren_rec_dst_vld_1;
wire [`ARF_CODE_WIDTH - 1 : 0] o_rob_ren_rec_arf_code_1;
wire [`PRF_CODE_WIDTH - 1 : 0] o_rob_ren_rec_prf_code_1;
wire o_rob_ren_rec_dst_vld_2;
wire [`ARF_CODE_WIDTH - 1 : 0] o_rob_ren_rec_arf_code_2;
wire [`PRF_CODE_WIDTH - 1 : 0] o_rob_ren_rec_prf_code_2;
wire o_rob_ren_rec_dst_vld_3;
wire [`ARF_CODE_WIDTH - 1 : 0] o_rob_ren_rec_arf_code_3;
wire [`PRF_CODE_WIDTH - 1 : 0] o_rob_ren_rec_prf_code_3;

wire [3 : 0] o_rob_ren_mis_vld;
wire o_rob_ren_mis_dst_vld_0;
wire [`ARF_CODE_WIDTH - 1 : 0] o_rob_ren_mis_arf_code_0;
wire [`PRF_CODE_WIDTH - 1 : 0] o_rob_ren_mis_prf_code_0;
wire o_rob_ren_mis_dst_vld_1;
wire [`ARF_CODE_WIDTH - 1 : 0] o_rob_ren_mis_arf_code_1;
wire [`PRF_CODE_WIDTH - 1 : 0] o_rob_ren_mis_prf_code_1;
wire o_rob_ren_mis_dst_vld_2;
wire [`ARF_CODE_WIDTH - 1 : 0] o_rob_ren_mis_arf_code_2;
wire [`PRF_CODE_WIDTH - 1 : 0] o_rob_ren_mis_prf_code_2;
wire o_rob_ren_mis_dst_vld_3;
wire [`ARF_CODE_WIDTH - 1 : 0] o_rob_ren_mis_arf_code_3;
wire [`PRF_CODE_WIDTH - 1 : 0] o_rob_ren_mis_prf_code_3;

wire o_rob_rsv_csr_ret;
wire o_rob_rsv_fence_ret;
wire o_rob_csr_int_vld;
wire o_rob_csr_exc_vld;
wire [`EXCEPTION_CODE_WIDTH - 1 : 0] o_rob_csr_excp_code;
wire o_rob_csr_len;
wire o_rob_csr_mret;
wire o_rob_csr_sret;
wire o_rob_csr_uret;
wire o_rob_csr_wfi;

wire [3 : 0] o_rob_dsp_ret_vld;
wire [`ROB_ID_WIDTH - 1 : 0] o_rob_dsp_ret_rob_id_0;
wire o_rob_dsp_ret_ld_vld_0;
wire o_rob_dsp_ret_st_vld_0;
wire [`ROB_ID_WIDTH - 1 : 0] o_rob_dsp_ret_rob_id_1;
wire o_rob_dsp_ret_ld_vld_1;
wire o_rob_dsp_ret_st_vld_1;
wire [`ROB_ID_WIDTH - 1 : 0] o_rob_dsp_ret_rob_id_2;
wire o_rob_dsp_ret_ld_vld_2;
wire o_rob_dsp_ret_st_vld_2;
wire [`ROB_ID_WIDTH - 1 : 0] o_rob_dsp_ret_rob_id_3;
wire o_rob_dsp_ret_ld_vld_3;
wire o_rob_dsp_ret_st_vld_3;

wire o_rob_dsp_mis_ld_vld;
wire [`LBUFF_ID_WIDTH - 1 : 0] o_rob_dsp_mis_ld_id;
wire o_rob_dsp_mis_st_vld;
wire [`SBUFF_ID_WIDTH - 1 : 0] o_rob_dsp_mis_st_id;

wire [`CORE_PC_WIDTH - 1 : 0] o_rob_exu_addr_0;
wire [`CORE_PC_WIDTH - 1 : 0] o_rob_exu_addr_1;
wire [`CORE_PC_WIDTH - 1 : 0] o_rob_exu_addr_3;
wire [`CORE_PC_WIDTH - 1 : 0] o_rob_csr_trap_addr;
wire [`CORE_PC_WIDTH - 1 : 0] o_rob_exu_ls_addr;
wire o_low_power_state;
wire o_rob_itlb_flush;
wire [31 : 0] o_rob_itlb_src1;
wire [31 : 0] o_rob_itlb_src2;
wire o_rob_dtlb_flush;
wire [31 : 0] o_rob_dtlb_src1;
wire [31 : 0] o_rob_dtlb_src2;
wire o_rob_csr_fencevm_flush;
wire o_rob_exu_s_ret;


rob_module rob ( 
    .i_csr_trap_flush        (o_csr_trap_flush),
    .i_csr_rv_mode           (o_csr_rv_mode),
    .i_exu_mis_flush         (o_exu_mis_flush),
    .i_exu_mis_rob_id        (o_exu_mis_rob_id),
    .i_exu_ls_flush          (o_exu_ls_flush),
    .i_exu_ls_rob_id         (o_exu_ls_rob_id),
    
    .i_dsp_rob_vld           (o_dsp_rsv_vld),
    .i_dsp_rob_rob_id_0      (o_dsp_rsv_rob_id_0),
    .i_dsp_rob_ld_vld_0      (o_dsp_rsv_ld_vld_0),
    .i_dsp_rob_ld_id_0       (o_dsp_rsv_ld_id_0),
    .i_dsp_rob_st_vld_0      (o_dsp_rsv_st_vld_0),
    .i_dsp_rob_st_id_0       (o_dsp_rsv_st_id_0),
    .i_dsp_rob_rob_id_1      (o_dsp_rsv_rob_id_1),
    .i_dsp_rob_ld_vld_1      (o_dsp_rsv_ld_vld_1),
    .i_dsp_rob_ld_id_1       (o_dsp_rsv_ld_id_1),
    .i_dsp_rob_st_vld_1      (o_dsp_rsv_st_vld_1),
    .i_dsp_rob_st_id_1       (o_dsp_rsv_st_id_1),
    .i_dsp_rob_rob_id_2      (o_dsp_rsv_rob_id_2),
    .i_dsp_rob_ld_vld_2      (o_dsp_rsv_ld_vld_2),
    .i_dsp_rob_ld_id_2       (o_dsp_rsv_ld_id_2),
    .i_dsp_rob_st_vld_2      (o_dsp_rsv_st_vld_2),
    .i_dsp_rob_st_id_2       (o_dsp_rsv_st_id_2),
    .i_dsp_rob_rob_id_3      (o_dsp_rsv_rob_id_3),
    .i_dsp_rob_ld_vld_3      (o_dsp_rsv_ld_vld_3),
    .i_dsp_rob_ld_id_3       (o_dsp_rsv_ld_id_3),
    .i_dsp_rob_st_vld_3      (o_dsp_rsv_st_vld_3),
    .i_dsp_rob_st_id_3       (o_dsp_rsv_st_id_3),
    .i_dsp_rob_len           (o_dsp_rsv_len),
    .i_dsp_rob_dst_vld_0     (o_dsp_rsv_dst_vld_0),
    .i_dsp_rob_dst_vld_1     (o_dsp_rsv_dst_vld_1),
    .i_dsp_rob_dst_vld_2     (o_dsp_rsv_dst_vld_2),
    .i_dsp_rob_dst_vld_3     (o_dsp_rsv_dst_vld_3),
    .i_dsp_rob_dst_arf_code_0(o_dsp_rsv_dst_arf_code_0),
    .i_dsp_rob_dst_arf_code_1(o_dsp_rsv_dst_arf_code_1),
    .i_dsp_rob_dst_arf_code_2(o_dsp_rsv_dst_arf_code_2),
    .i_dsp_rob_dst_arf_code_3(o_dsp_rsv_dst_arf_code_3),
    .i_dsp_rob_dst_prf_code_0(o_dsp_rsv_dst_prf_code_0),
    .i_dsp_rob_dst_prf_code_1(o_dsp_rsv_dst_prf_code_1),
    .i_dsp_rob_dst_prf_code_2(o_dsp_rsv_dst_prf_code_2),
    .i_dsp_rob_dst_prf_code_3(o_dsp_rsv_dst_prf_code_3),
    .i_dsp_rob_decinfo_bus_0 (o_dsp_rsv_decinfo_bus_0),
    .i_dsp_rob_decinfo_bus_1 (o_dsp_rsv_decinfo_bus_1),
    .i_dsp_rob_decinfo_bus_2 (o_dsp_rsv_decinfo_bus_2),
    .i_dsp_rob_decinfo_bus_3 (o_dsp_rsv_decinfo_bus_3),
    .i_dsp_rob_predinfo_bus_0(o_dsp_rsv_predinfo_bus_0),
    .i_dsp_rob_predinfo_bus_1(o_dsp_rsv_predinfo_bus_1),
    .i_dsp_rob_predinfo_bus_2(o_dsp_rsv_predinfo_bus_2),
    .i_dsp_rob_predinfo_bus_3(o_dsp_rsv_predinfo_bus_3),
    .i_dsp_rob_dsp_id        (o_dsp_rsv_rob_dsp_id),
    .i_dsp_rob_ret_id        (o_dsp_rsv_rob_ret_id),
    .i_dsp_rob_addr_0        (o_dsp_rob_addr_0),
    .i_dsp_rob_addr_1        (o_dsp_rob_addr_1),
    .i_dsp_rob_addr_2        (o_dsp_rob_addr_2),
    .i_dsp_rob_addr_3        (o_dsp_rob_addr_3),
    .i_dsp_rob_taddr_0       (o_dsp_rob_taddr_0),
    .i_dsp_rob_taddr_1       (o_dsp_rob_taddr_1),
    .i_dsp_rob_taddr_2       (o_dsp_rob_taddr_2),
    .i_dsp_rob_taddr_3       (o_dsp_rob_taddr_3),
    .i_dsp_rob_instr_0       (o_dsp_rob_instr_0),
    .i_dsp_rob_instr_1       (o_dsp_rob_instr_1),
    .i_dsp_rob_instr_2       (o_dsp_rob_instr_2),
    .i_dsp_rob_instr_3       (o_dsp_rob_instr_3),

    .i_exu_rob_vld_0         (o_exu_rob_vld_0),
    .i_exu_rob_vld_1         (o_exu_rob_vld_1),
    .i_exu_rob_vld_2         (o_exu_rob_vld_2),
    .i_exu_rob_vld_3         (o_exu_rob_vld_3),
    .i_exu_rob_rob_id_0      (o_exu_rob_rob_id_0),
    .i_exu_rob_rob_id_1      (o_exu_rob_rob_id_1),
    .i_exu_rob_rob_id_2      (o_exu_rob_rob_id_2),
    .i_exu_rob_rob_id_3      (o_exu_rob_rob_id_3),
    .i_exu_rob_excp_code_0   (o_exu_rob_excp_code_0),
    .i_exu_rob_excp_code_1   (o_exu_rob_excp_code_1),
    .i_exu_rob_excp_code_2   (o_exu_rob_excp_code_2),
    .i_exu_rob_excp_code_3   (o_exu_rob_excp_code_3),
    .i_exu_rob_fence_src1    (o_exu_rob_fence_src1),
    .i_exu_rob_fence_src2    (o_exu_rob_fence_src2),
    .i_exu_rob_rob_id_addr_0 (o_rsv_exu_rob_id_0),
    .i_exu_rob_rob_id_addr_1 (o_rsv_exu_rob_id_1),
    .i_exu_rob_rob_id_addr_3 (o_rsv_exu_rob_id_3),

    .i_itlb_rob_flush_done   (o_itlb_rob_flush_done),
    .i_dtlb_rob_flush_done   (o_dtlb_rob_flush_done),
    .i_mmu_rob_flush_done    (o_mmu_rob_flush_done),
    .i_exu_rob_st_ret_done   (o_exu_rob_s_ret_done),

    .o_rob_ren_ret_vld       (o_rob_ren_ret_vld),
    .o_rob_ren_ret_dst_vld_0 (o_rob_ren_ret_dst_vld_0),
    .o_rob_ren_ret_arf_code_0(o_rob_ren_ret_arf_code_0),
    .o_rob_ren_ret_prf_code_0(o_rob_ren_ret_prf_code_0),
    .o_rob_ren_ret_dst_vld_1 (o_rob_ren_ret_dst_vld_1),
    .o_rob_ren_ret_arf_code_1(o_rob_ren_ret_arf_code_1),
    .o_rob_ren_ret_prf_code_1(o_rob_ren_ret_prf_code_1),
    .o_rob_ren_ret_dst_vld_2 (o_rob_ren_ret_dst_vld_2),
    .o_rob_ren_ret_arf_code_2(o_rob_ren_ret_arf_code_2),
    .o_rob_ren_ret_prf_code_2(o_rob_ren_ret_prf_code_2),
    .o_rob_ren_ret_dst_vld_3 (o_rob_ren_ret_dst_vld_3),
    .o_rob_ren_ret_arf_code_3(o_rob_ren_ret_arf_code_3),
    .o_rob_ren_ret_prf_code_3(o_rob_ren_ret_prf_code_3),
    
    .o_rob_ren_rec_vld       (o_rob_ren_rec_vld),
    .o_rob_ren_rec_arf_code_0(o_rob_ren_rec_arf_code_0),
    .o_rob_ren_rec_prf_code_0(o_rob_ren_rec_prf_code_0),
    .o_rob_ren_rec_arf_code_1(o_rob_ren_rec_arf_code_1),
    .o_rob_ren_rec_prf_code_1(o_rob_ren_rec_prf_code_1),
    .o_rob_ren_rec_arf_code_2(o_rob_ren_rec_arf_code_2),
    .o_rob_ren_rec_prf_code_2(o_rob_ren_rec_prf_code_2),
    .o_rob_ren_rec_arf_code_3(o_rob_ren_rec_arf_code_3),
    .o_rob_ren_rec_prf_code_3(o_rob_ren_rec_prf_code_3),

    .o_rob_ren_mis_vld       (o_rob_ren_mis_vld),
    .o_rob_ren_mis_arf_code_0(o_rob_ren_mis_arf_code_0),
    .o_rob_ren_mis_prf_code_0(o_rob_ren_mis_prf_code_0),
    .o_rob_ren_mis_arf_code_1(o_rob_ren_mis_arf_code_1),
    .o_rob_ren_mis_prf_code_1(o_rob_ren_mis_prf_code_1),
    .o_rob_ren_mis_arf_code_2(o_rob_ren_mis_arf_code_2),
    .o_rob_ren_mis_prf_code_2(o_rob_ren_mis_prf_code_2),
    .o_rob_ren_mis_arf_code_3(o_rob_ren_mis_arf_code_3),
    .o_rob_ren_mis_prf_code_3(o_rob_ren_mis_prf_code_3),

    .o_rob_rsv_csr_ret       (o_rob_rsv_csr_ret),
    .o_rob_rsv_fence_ret     (o_rob_rsv_fence_ret),
    .o_rob_csr_int_vld       (o_rob_csr_int_vld),
    .o_rob_csr_exc_vld       (o_rob_csr_exc_vld),
    .o_rob_csr_excp_code     (o_rob_csr_excp_code),
    .o_rob_csr_len           (o_rob_csr_len),
    .o_rob_csr_mret          (o_rob_csr_mret),
    .o_rob_csr_sret          (o_rob_csr_sret),
    .o_rob_csr_uret          (o_rob_csr_uret),
    .o_rob_csr_wfi           (o_rob_csr_wfi),

    .o_rob_dsp_ret_vld       (o_rob_dsp_ret_vld),
    .o_rob_dsp_ret_rob_id_0  (o_rob_dsp_ret_rob_id_0),
    .o_rob_dsp_ret_ld_vld_0  (o_rob_dsp_ret_ld_vld_0),
    .o_rob_dsp_ret_ld_id_0   (o_rob_dsp_ret_ld_id_0),
    .o_rob_dsp_ret_st_vld_0  (o_rob_dsp_ret_st_vld_0),
    .o_rob_dsp_ret_st_id_0   (o_rob_dsp_ret_st_id_0),
    .o_rob_dsp_ret_rob_id_1  (o_rob_dsp_ret_rob_id_1),
    .o_rob_dsp_ret_ld_vld_1  (o_rob_dsp_ret_ld_vld_1),
    .o_rob_dsp_ret_ld_id_1   (o_rob_dsp_ret_ld_id_1),
    .o_rob_dsp_ret_st_vld_1  (o_rob_dsp_ret_st_vld_1),
    .o_rob_dsp_ret_st_id_1   (o_rob_dsp_ret_st_id_1),
    .o_rob_dsp_ret_rob_id_2  (o_rob_dsp_ret_rob_id_2),
    .o_rob_dsp_ret_ld_vld_2  (o_rob_dsp_ret_ld_vld_2),
    .o_rob_dsp_ret_ld_id_2   (o_rob_dsp_ret_ld_id_2),
    .o_rob_dsp_ret_st_vld_2  (o_rob_dsp_ret_st_vld_2),
    .o_rob_dsp_ret_st_id_2   (o_rob_dsp_ret_st_id_2),
    .o_rob_dsp_ret_rob_id_3  (o_rob_dsp_ret_rob_id_3),
    .o_rob_dsp_ret_ld_vld_3  (o_rob_dsp_ret_ld_vld_3),
    .o_rob_dsp_ret_ld_id_3   (o_rob_dsp_ret_ld_id_3),
    .o_rob_dsp_ret_st_vld_3  (o_rob_dsp_ret_st_vld_3),
    .o_rob_dsp_ret_st_ld_3   (o_rob_dsp_ret_st_id_3),

    .o_rob_dsp_mis_ld_vld    (o_rob_dsp_mis_ld_vld),
    .o_rob_dsp_mis_ld_id     (o_rob_dsp_mis_ld_id),
    .o_rob_dsp_mis_st_vld    (o_rob_dsp_mis_st_vld),
    .o_rob_dsp_mis_st_id     (o_rob_dsp_mis_st_id), 

    .o_rob_exu_addr_0        (o_rob_exu_addr_0),
    .o_rob_exu_addr_1        (o_rob_exu_addr_1),
    .o_rob_exu_addr_3        (o_rob_exu_addr_3),
    .o_rob_csr_trap_addr     (o_rob_csr_trap_addr),
    .o_rob_exu_ls_addr       (o_rob_exu_ls_addr),
    .o_low_power_state       (o_low_power_state),
    .o_rob_itlb_flush        (o_rob_itlb_flush),
    .o_rob_itlb_src1         (o_rob_itlb_src1),
    .o_rob_itlb_src2         (o_rob_itlb_src2),
    .o_rob_dtlb_flush        (o_rob_dtlb_flush),
    .o_rob_dtlb_src1         (o_rob_dtlb_src1),
    .o_rob_dtlb_src2         (o_rob_dtlb_src2),
    .o_rob_mmu_flush         (o_rob_mmu_flush),
    .o_rob_mmu_src1          (o_rob_mmu_src1),
    .o_rob_mmu_src2          (o_rob_mmu_src2),
    .o_rob_csr_fencevm_flush (o_rob_csr_fencevm_flush),
    .o_rob_exu_s_ret         (o_rob_exu_s_ret),

    .clk                     (clk),
    .rst_n                   (rst_n)
);

//
wire o_csr_trap_flush;
wire [`CORE_PC_WIDTH - 1 : 0] o_csr_trap_addr;
wire [1 : 0] o_csr_rv_mode;
wire [`CSR_SATP_WIDTH - 1 : 0] o_csr_mmu_satp;

wire [`PRF_DATA_WIDTH - 1 : 0] o_csr_exu_rdat;
wire o_csr_ext_intr_ack;

exu_csr_module csr ( 
    .i_ext_csr_intr_vld   (),
    .i_ext_csr_intr_code  (),
    .i_sft_csr_intr_vld   (),
    .i_sft_csr_intr_code  (),
    .i_tmr_csr_intr_vld   (),
    .i_tmr_csr_intr_code  (),
    .i_rob_csr_vld        (o_rob_csr_int_vld),
    .i_rob_csr_excp_vld   (o_rob_csr_exc_vld),
    .i_rob_csr_excp_code  (o_rob_csr_excp_code),
    .i_rob_csr_excp_instr (o_rob_csr_excp_inst),
    .i_rob_csr_len        (o_rob_csr_len),
    .i_rob_csr_addr       (o_rob_csr_trap_addr),
    .i_rob_csr_mret       (o_rob_csr_mret),
    .i_rob_csr_sret       (o_rob_csr_sret),
    .i_rob_csr_uret       (o_rob_csr_uret),
    .i_rob_csr_wfi        (o_rob_csr_wfi),
    .i_rob_csr_sfvma_flush(o_rob_csr_fencevm_flush),
    .i_exu_csr_wren       (o_exu_csr_wren),
    .i_exu_csr_addr       (o_exu_csr_addr),
    .i_exu_csr_wdat       (o_exu_csr_wdat),

    .o_csr_exu_rdat       (o_csr_exu_rdat),
    .o_csr_trap_flush     (o_csr_trap_flush),
    .o_csr_trap_addr      (o_csr_trap_addr),
    .o_csr_rv_mode        (o_csr_rv_mode),
    .o_csr_mmu_satp       (o_csr_mmu_satp),
    .o_csr_ext_intr_ack   (o_csr_ext_intr_ack),

    .clk                  (clk),
    .rst_n                (rst_n)
);

/***************** Stage 10 ********************/
wire o_mmu_itlb_vld;
wire [`ITLB_TLB_WIDTH - 1 : 0] o_mmu_itlb_tlb;
wire [`PHY_ADDR_WIDTH - 1 : 0] o_mmu_itlb_paddr;
wire [`EXCEPTION_CODE_WIDTH - 1 : 0] o_mmu_itlb_excp_code;
wire o_mmu_dtlb_vld;
wire [`DTLB_TLB_WIDTH - 1 : 0] o_mmu_dtlb_tlb;
wire [`PHY_ADDR_WIDTH - 1 : 0] o_mmu_dtlb_paddr;
wire [`EXCEPTION_CODE_WIDTH - 1 : 0] o_mmu_dtlb_excp_code;
wire o_mem_exu_vld;
wire o_mem_exu_done;
wire [511 : 0] o_mem_exu_dat;
wire o_mem_icache_vld;
wire [511 : 0] o_mem_icache_dat;
wire o_mem_cache_inv_vld;
wire [`PHY_ADDR_WIDTH - 1 : 0] o_mem_icache_dat;
wire o_mmu_busy;

mmu_module mmu ( 
    .i_csr_trap_flush     (o_csr_trap_flush),
    .i_exu_mis_flush      (o_exu_mis_flush),
    .i_exu_ls_flush       (o_exu_ls_flush),
    .i_rob_mmu_flush      (o_rob_mmu_flush),
    .i_rob_mmu_src1       (o_rob_mmu_src1),
    .i_rob_mmu_src2       (o_rob_mmu_src2),
    .i_csr_rv_mode        (o_csr_rv_mode),
    .i_csr_mmu_satp       (o_csr_mmu_satp),

    .i_itlb_mmu_vld       (o_itlb_mmu_vld),
    .i_itlb_mmu_vaddr     (o_itlb_mmu_vaddr),
    .i_dtlb_mmu_vld       (o_dtlb_mmu_vld),
    .i_dtlb_mmu_vaddr     (o_dtlb_mmu_vaddr),
    .i_exu_mem_rden       (o_exu_mem_rd_vld),
    .i_exu_mem_raddr      (o_exu_mem_rd_paddr),
    .i_exu_mem_wren       (o_exu_mem_wr_vld),
    .i_exu_mem_waddr      (o_exu_mem_wr_paddr),
    .i_exu_mmu_ack        (o_exu_mmu_ack),
    .i_icache_mem_rden    (o_icache_mem_vld),
    .i_icache_mem_raddr   (o_icache_mem_paddr),

    .o_mmu_itlb_vld       (o_mmu_itlb_vld),
    .o_mmu_itlb_tlb       (o_mmu_itlb_tlb),
    .o_mmu_itlb_paddr     (o_mmu_itlb_paddr),
    .o_mmu_itlb_excp_code (o_mmu_itlb_excp_code),
    .o_mmu_dtlb_vld       (o_mmu_dtlb_vld),
    .o_mmu_dtlb_tlb       (o_mmu_dtlb_tlb),
    .o_mmu_dtlb_paddr     (o_mmu_dtlb_paddr),
    .o_mmu_dtlb_excp_code (o_mmu_dtlb_excp_code),
    .o_mem_exu_vld        (o_mem_exu_vld),
    .o_mem_exu_done       (o_mem_exu_done),
    .o_mem_exu_dat        (o_mem_exu_dat),
    .o_mem_icache_vld     (o_mem_icache_vld),
    .o_mem_icache_dat     (o_mem_icache_dat),
    .o_mem_ext_wren       (),
    .o_mem_ext_rden       (),
    .o_mem_ext_mask       (),
    .o_mem_ext_burst      (),
    .o_mem_ext_wdat       (),
    .o_mem_ext_burst_start(),
    .o_mem_ext_burst_end  (),
    .o_mem_ext_burst_vld  (),
    .o_mem_rob_flush_done (),
    .o_mem_cache_inv_paddr(),
    .o_mem_cache_inv_vld  (),
    .o_mmu_busy           (o_mmu_busy),

    .clk                  (clk),
    .rst_n                (rst_n)
);

mem_module #(

) mem ( 
    .i_cs       (),
    .i_wren     (),
    .i_din      (),
    .i_addr     (),
    .i_byte_mask(),
    .o_dout     (),
    .clk        (clk),
    .rst_n      (rst_n)
);


//  PLIC

//  CLINT
endmodule   //  core_module

`endif  /*  !__CORE_CORE_V__!   */