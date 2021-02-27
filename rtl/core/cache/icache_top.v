`ifdef __CACHE_ICACHE_TOP_V__

module icache_top_module ( 
    input                                   i_csr_trap_flush,
    input                                   i_exu_mis_flush,
    input                                   i_exu_ls_flush,
    input                                   i_bpu_flush,
    input                                   i_iq_flush,
    input                                   i_iq_uc_flush,
    input                                   i_rob_itlb_flush,
    input   [31                     : 0]    i_rob_itlb_src1,
    input   [31                     : 0]    i_rob_itlb_src2,
    input   [`CSR_SATP_WIDTH - 1    : 0]    i_csr_mmu_satp,
    input   [1                      : 0]    i_csr_rv_mode,

    input                                   i_ifu_icache_vld,
    input   [`CORE_PC_WIDTH - 1     : 0]    i_ifu_icache_pc_addr,
    input   [1                      : 0]    i_ifu_icache_id,
    input                                   i_predec_icache_done,
    input                                   i_mmu_itlb_vld,
    input   [52                     : 0]    i_mmu_itlb_tlb,
    input   [`PHY_ADDR_WIDTH - 1    : 0]    i_mmu_itlb_paddr,
    input   [2                      : 0]    i_mmu_itlb_excp_code,
    input                                   i_mem_icache_vld,
    input   [511                    : 0]    i_mem_icache_data,
    input   [1                      : 0]    i_mmu_icache_inv_vld,
    input   [`PHY_ADDR_WIDTH - 1    : 0]    i_mmu_icache_inv_paddr,

    output                                  o_itlb_mmu_vld,
    output  [`CORE_PC_WIDTH - 1     : 0]    o_itlb_mmu_vaddr,
    output                                  o_icache_mem_vld,
    output  [`PHY_ADDR_WIDTH - 1    : 0]    o_icache_mem_paddr,
    output                                  o_cache_predec_vld,
    output                                  o_cache_predec_hit,
    output  [511                    : 0]    o_cache_predec_way,
    output                                  o_cache_predec_bypass_vld,
    output  [511                    : 0]    o_cache_predec_bypass,
    output  [2                      : 0]    o_cache_predec_excp_code,
    output                                  o_cache_ifu_vld,
    output  [2                      : 0]    o_cache_ifu_id,
    output                                  o_cache_ifu_stall,
    output                                  o_itlb_rob_ifu_done,
    output                                  o_itlb_rob_flush_done,

    input                                   clk,
    input                                   rst_n
);

//
wire cache_need_flush = (i_csr_trap_flush 
                      |  i_exu_mis_flush 
                      |  i_exu_ls_flush 
                      |  i_bpu_flush
                      |  i_iq_flush
                      |  i_iq_uc_flush);

//  ITLB
wire i_itlb_req = (i_ifu_icache_vld & (~cache_need_flush));
wire [`ITLB_IDX_WIDTH - 1 : 0] i_itlb_ridx = i_ifu_icache_pc_addr[14 : 12];
wire [`ITLB_TAG_WIDTH - 1 : 0] i_itlb_rtag = {i_csr_mmu_satp[30 : 22], i_csr_rv_mode[1 : 0]};

wire o_itlb_hit;
wire [`ITLB_DATA_WIDTH - 1 : 0] o_itlb_rdat;

wire i_itlb_wren = (i_mmu_itlb_vld & (~(|i_mmu_itlb_excp_code)));
wire [`ITLB_TAG_WIDTH - 1 : 0] i_itlb_wtag;
wire [`ITLB_IDX_WIDTH - 1 : 0] i_itlb_widx;

assign {
            i_itlb_widx
        ,   i_itlb_wtag
        ,   i_itlb_wdat
} = {
        i_itlb_ridx
    ,   i_mmu_itlb_tlb
};

itlb_module itlb ( 
    .i_itlb_flush(i_rob_itlb_flush),
    .i_itlb_src1 (i_rob_itlb_src1),
    .i_itlb_src2 (i_rob_itlb_src2),

    .i_itlb_req  (i_itlb_req),
    .i_itlb_rtag (i_itlb_rtag),
    .i_itlb_ridx (i_itlb_ridx),
    .i_itlb_wren (i_itlb_wren),
    .i_itlb_widx (i_itlb_widx),
    .i_itlb_wtag (i_itlb_wtag),
    .i_itlb_wdat (i_itlb_wdat),

    .o_itlb_hit  (o_itlb_hit),
    .o_itlb_rdat (o_itlb_rdat),
    
    .clk         (clk),
    .rst_n       (rst_n)
);

assign o_itlb_mmu_vld = (~o_itlb_hit);
assign o_itlb_mmu_vaddr = i_ifu_icache_pc_addr;

//  ICACHE
wire i_icache_req = i_itlb_req;
wire [`PHY_ADDR_WIDTH - 1 : 0] icache_paddr = o_itlb_hit ? {o_itlb_rdat[21 : 0], i_ifu_icache_pc_addr[11 : 0]}
                                            : {i_mmu_itlb_paddr[33 : 12], i_ifu_icache_pc_addr[11 : 0]};

wire [`ICACHE_IDX_WIDTH - 1 : 0] i_icache_ridx = icache_paddr[13 : 6];
wire [`ICACHE_TAG_WIDTH - 1 : 0] i_icache_rtag = icache_paddr[33 : 14];

wire o_icache_hit;
wire [`ICACHE_DATA_WIDTH - 1 : 0] o_icache_rdat;

wire i_icache_wren = i_mem_icache_vld;
wire [`ICACHE_IDX_WIDTH - 1 : 0] i_icache_widx;
wire [`ICACHE_TAG_WIDTH - 1 : 0] i_icache_wtag;
wire [`ICACHE_DATA_WIDTH - 1 : 0] i_icache_wdat;

assign {
        i_icache_widx
    ,   i_icache_wtag
    ,   i_icache_wdat
} = {
        i_icache_ridx
    ,   i_icache_rtag
    ,   i_mem_icache_data
};

icache_module icache ( 
    .i_icache_inv_vld  (i_mmu_icache_inv_vld),
    .i_icache_inv_paddr(i_mmu_icache_inv_paddr),

    .i_icache_req      (i_icache_req),
    .i_icache_rtag     (i_icache_rtag),
    .i_icache_ridx     (i_icache_ridx),
    .i_icache_wren     (i_icache_wren),
    .i_icache_widx     (i_icache_widx),
    .i_icache_wtag     (i_icache_wtag),
    .i_icache_wdat     (i_icache_wdat),

    .o_icache_hit      (o_icache_hit),
    .o_icache_rdat     (o_icache_rdat),

    .clk               (clk),
    .rst_n             (rst_n)
);

assign o_icache_mem_vld = (i_icache_req & (~o_icache_hit));
assign o_icache_mem_paddr = icache_paddr;

//
assign o_cache_predec_vld = (o_cache_predec_hit | o_cache_predec_bypass_vld);
assign o_cache_predec_hit = o_icache_hit;
assign o_cache_predec_way = o_icache_rdat;

assign o_cache_predec_bypass_vld = i_mem_icache_vld;
assign o_cache_predec_bypass     = i_mem_icache_data;
assign o_cache_predec_excp_code  = (o_itlb_hit ? 3'd0 : i_mmu_itlb_excp_code);

//
assign o_cache_ifu_stall = (i_ifu_icache_vld & ((~(o_itlb_hit | i_mmu_itlb_vld)) | (~(o_icache_hit | i_mem_icache_vld))));
assign o_cache_ifu_vld   = i_predec_icache_done;
assign o_cache_ifu_id    = (i_ifu_icache_id + 2'd1);

//
gnrl_dffr #( 
    .DATA_WIDTH   (1),
    .INITIAL_VALUE(0)
) itlb_rob_ifu_done_dffr (i_itlb_flush, o_itlb_rob_ifu_done, clk, rst_n);

endmodule   //  icache_top_module

`endif  /*  !__CACHE_ICACHE_TOP_V__!    */