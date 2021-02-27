`ifdef __MMU_MMU_V__

module mmu_module (
	input										i_csr_trap_flush,
	input										i_exu_mis_flush,
	input	[`ROB_ID_WIDTH - 1 	: 0]			i_exu_mis_rob_id,
	input										i_exu_ls_flush,
	input	[`ROB_ID_WIDTH - 1 	: 0]			i_exu_ls_rob_id,
	input										i_rob_mmu_flush,
	input	[31				   	: 0]			i_rob_mmu_src1,
	input	[31				   	: 0]			i_rob_mmu_src2,
	input	[1					: 0]			i_csr_rv_mode,
	input	[31					: 0]			i_csr_mmu_satp,
	input										i_itlb_mmu_vld,
	input	[`VADDR_WIDTH - 1 	: 0]			i_itlb_mmu_vaddr,
	input										i_dtlb_mmu_vld,
	input	[`VADDR_WIDTH - 1 	: 0]			i_dtlb_mmu_vaddr,
	input										i_exu_mmu_ld_vld,
	input										i_exu_mmu_st_vld,
	input	[`LOAD_BUFFER_ID_WIDTH - 1 : 0]		i_exu_mmu_ld_id,
	input	[`STORE_BUFFER_ID_WIDTH - 1 : 0]	i_exu_mmu_st_id,
	input										i_exu_mem_rden,
	input	[33					: 0]			i_exu_mem_rd_addr,
	input										i_exu_mem_wren,
	input	[33					: 0]			i_exu_mem_wr_addr,
	input										i_exu_mmu_ack,
	input										i_ext_icache_rden,
	input	[33					: 0]			i_ext_icache_rd_addr,
	input										i_ext_mem_rden,
	input	[127 				: 0]			i_ext_mem_rdat,
	input										i_ext_mem_rdy,
	output										o_mmu_itlb_vld,
	output	[52					: 0]			o_mmu_itlb_tlb,
	output	[`PADDR_WIDTH - 1	: 0]			o_mmu_itlb_paddr,
	output										o_mmu_dtlb_vld,
	output	[52					: 0]			o_mmu_dtlb_tlb,
	output	[`PADDR_WIDTH - 1   : 0]			o_mmu_dtlb_paddr,
	output	[`LOAD_BUFFER_ID_WIDTH - 1 : 0]		o_mmu_exu_ld_id,
	output	[`STORE_BUFFER_ID_WIDTH - 1 : 0]	o_mmu_exu_st_id,
	output										o_mmu_exu_ld_vld,
	output										o_mmu_exu_st_vld,
	output	[`PAGE_EXCEPTION_CODE_WIDTH - 1 : 0]o_mmu_itlb_exception_code,
	output	[`PAGE_EXCEPTION_CODE_WIDTH - 1 : 0]o_mmu_dtlb_exception_code,
	output										o_mem_exu_done,
	output	[511 				: 0]			o_mem_exu_dat,
	output										o_mem_icache_vld,
	output	[511				: 0]			o_mem_icache_dat,
	output 										o_mem_ext_wren,
	output										o_mem_ext_rden,
	output	[`BYTE_MASK_WIDTH - 1 : 0]			o_mem_ext_mask,
	output	[2					: 0]			o_mem_ext_burst,
	output	[`PADDR_WIDTH - 1	: 0]			o_mem_ext_paddr,
	output	[127				: 0]			o_mem_ext_wdat,
	output										o_mem_ext_burst_start,
	output										o_mem_ext_burts_end,
	output										o_mem_ext_burst_vld,
	output										o_mem_rob_flush_done,
	output	[`PADDR_WIDTH - 1	: 0]			o_mem_cache_inv_paddr,
	output	[1					: 0]			o_mem_cache_inv_vld,
	output										o_mmu_free,

	input										clk,
	input										rst_n
);

//
wire mmu_need_flush;

//	Control
localparam	MMU_STATE_WIDTH = 3;
localparam 	MMU_STATE_IDLE   = 3'd1,
			MMU_STATE_SRCH_1 = 3'd2,
			MMU_STATE_SRCH_2 = 3'd4;

wire [MMU_STATE_WIDTH - 1 : 0] mmu_sta_cur_r, mmu_sta_nxt;

wire mmu_sta_is_idle   = (mmu_sta_cur_r == MMU_STATE_IDLE);
wire mmu_sta_is_srch_1 = (mmu_sta_cur_r == MMU_STATE_SRCH_1);
wire mmu_sta_is_srch_2 = (mmu_sta_cur_r == MMU_STATE_SRCH_2);

wire mmu_sta_exit_idle   = (mmu_sta_is_idle & (i_dtlb_mmu_vld | i_itlb_mmu_vld));
wire mmu_sta_exit_srch_1 = ;
wire mmu_sta_exit_srch_2 = (mmu_sta_is_srch_2 & );

wire mmu_sta_enter_idle = ( | mmu_sta_exit_srch_2);
wire mmu_sta_enter_srch_1 = (mmu_sta_exit_idle & (~mmu_need_flush));
wire mmu_sta_enter_srch_2 = (mmu_sta_exit_srch_1 & (~mmu_need_flush));

assign mmu_sta_nxt = ({MMU_STATE_WIDTH{mmu_sta_enter_idle  }} & MMU_STATE_IDLE	)
				   | ({MMU_STATE_WIDTH{mmu_sta_enter_srch_1}} & MMU_STATE_SRCH_1)
				   | ({MMU_STATE_WIDTH{mmu_sta_enter_srch_2}} & MMU_STATE_SRCH_2);

wire mmu_sta_ena = (mmu_sta_exit_idle
				 |  mmu_sta_exit_srch_1
				 |  mmu_sta_exit_srch_2);
gnrl_dfflr #( 
	.DATA_WIDTH   (MMU_STATE_WIDTH),
	.INITIAL_VALUE(MMU_STATE_IDLE)
) mmu_sta_dfflr (mmu_sta_ena, mmu_sta_nxt, mmu_sta_cur_r, clk, rst_n);

//
wire [1 : 0] mmu_rr_arb_r, mmu_rr_arb_nxt;

assign mmu_rr_arb_nxt = ((i_itlb_mmu_vld & mmu_rr_arb_r[0]) | (i_dtlb_mmu_vld & mmu_rr_arb_r[1])) ? {mmu_rr_arb_r[0], mmu_rr_arb_r[1]} : mmu_rr_arb_r;

wire mmu_rr_arb_ena = ();

gnrl_dfflr #( 
	.DATA_WIDTH   (2),
	.INITIAL_VALUE(1)
) mmu_rr_arb_dfflr (mmu_rr_arb_ena, mmu_rr_arb_nxt, mmu_rr_arb_r, clk, rst_n);

wire [`CORE_PC_WIDTH - 1 : 0] mmu_vaddr = (i_dtlb_mmu_vld & i_itlb_mmu_vld) ? (({`CORE_PC_WIDTH{mmu_rr_arb_r[0]}} & i_itlb_mmu_vaddr) | ({`CORE_PC_WIDTH{mmu_rr_arb_r[1]}} & i_dtlb_mmu_vaddr))
										: i_itlb_mmu_vld ? i_itlb_mmu_vaddr
										: i_dtlb_mmu_vaddr;

wire [`PHY_ADDR_WIDTH - 1 : 0] pte_addr_0 = ({i_csr_mmu_satp[21 : 0], 12'h0} + {22'h0, mmu_vaddr[31 : 22], 2'h0});

//	L2TLB
wire i_l2tlb_rden = (i_dtlb_mmu_vld | i_itlb_mmu_vld);

wire l2tlb_hit;
wire [`L2TLB_TLB_WIDTH - 1 : 0] l2tlb_tlb;
wire [`PHY_ADDR_WIDTH - 1 : 0] l2tlb_paddr;

l2tlb_module l2tlb ( 
	.i_csr_rv_mode(i_csr_rv_mode),
	.i_l2tlb_satp (i_csr_mmu_satp), 
	.i_l2tlb_rden (i_l2tlb_rden),
	.i_l2tlb_vaddr(mmu_vaddr),
	.i_l2tlb_wren (),
	.i_l2tlb_pte  (),
	.i_l2tlb_paddr(),
	
	.o_l2tlb_hit  (l2tlb_hit),
	.o_l2tlb_tlb  (l2tlb_tlb),
	.o_l2tlb_paddr(l2tlb_paddr),

	.clk		  (clk),
	.rst_n		  (rst_n)
);


//	PTE_CACHE
wire i_pte_cache_rden = (i_dtlb_mmu_vld | i_itlb_mmu_vld);

wire pte_cache_hit;
wire [`PTE_CACHE_DATA_WIDTH - 1 : 0] pte_cache_rdat;
pte_cache_module pte_cache ( 
	.i_csr_rv_mode		  (i_csr_rv_mode),
	.i_pte_cache_satp	  (i_csr_mmu_satp),
	.i_pte_cache_mmu_flush(i_rob_mmu_flush),
	.i_pte_cache_rden	  (i_pte_cache_rden),
	.i_pte_cache_vaddr	  (mmu_vaddr), 
	.i_pte_cache_wren	  (),
	.i_pte_cache_level	  (),
	.i_pte_cache_pte	  (),
	.i_pte_cache_mmu_src1 (i_rob_mmu_src1),
	.i_pte_cache_mmu_src2 (i_rob_mmu_src2),

	.o_pte_cache_hit	  (pte_cache_hit),
	.o_pte_cache_rdata	  (pte_cache_rdat),

	.clk	 			  (clk),
	.rst_n				  (rst_n)
);

//
wire [`PTE_WIDTH - 1 : 0] pte_level_0 = i_ext_mem_rdat[`PTE_WIDTH - 1 : 0];
wire [2 : 0] mmu_tlb_excp_vec;

assign mmu_tlb_excp_vec[0] = ((pte_level_0[`PTE_V] == 1'b0) | ((pte_level_0[`PTE_R] == 1'b0) & (pte_level_0[`PTE_W] == 1'b1)));

wire pte_1_level_page_table = ((pte_level_0[`PTE_V] == 1'b1) & ((pte_level_0[`PTE_R] | pte_level_0[`PTE_W])));
wire pte_2_level_page_table = ((pte_level_0[`PTE_V] == 1'b1) & (((~pte_level_0[`PTE_X]) & (~pte_level_0[`PTE_W]) & (~pte_level_0[`PTE_R]))));

wire [`PHY_ADDR_WIDTH - 1 : 0] pte_addr_1 = ({pte_level_0[31 : 10], 12'h0} + {22'h0, mmu_vaddr[21: 12], 2'h0});
assign mmu_tlb_excp_vec[1] = ((pte_level_1[`PTE_V] == 1'b0) | ((pte_level_1[`PTE_R] == 1'b0) & (pte_level_1[`PTE_W] == 1'b1)));
assign mmu_tlb_excp_vec[2] = ((pte_level_1[`PTE_V] == 1'b1) & (((~pte_level_1[`PTE_X]) & (~pte_level_1[`PTE_W]) & (~pte_level_1[`PTE_R]))));

wire [`PTE_WIDTH - 1 : 0] pte_level_1 = i_ext_mem_rdat[`PTE_WIDTH - 1 : 0];

wire [`PHY_ADDR_WIDTH - 1 : 0] mmu_paddr = {pte_level_1[31 : 10], mmu_vaddr[11 : 0]};


//	LOAD_ARB
wire [2 : 0] mmu_load_arb_r, mmu_load_arb_nxt;

endmodule 	//	mmu_module

`endif 	/*	!__MMU_MMU_V__!		*/