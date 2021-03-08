`ifdef __MMU_MMU_V__ 

module mmu_module ( 
	input										    i_csr_trap_flush,
	input										    i_exu_mis_flush,
	input										    i_exu_ls_flush,

	input										    i_rob_mmu_flush,
	input	[31				   	    : 0]			i_rob_mmu_src1,
	input	[31				   	    : 0]			i_rob_mmu_src2,
	input	[1					    : 0]			i_csr_rv_mode,
	input	[31					    : 0]			i_csr_mmu_satp,
	
    input										    i_itlb_mmu_vld,
	input	[`CORE_PC_WIDTH - 1 	: 0]			i_itlb_mmu_vaddr,
	input										    i_dtlb_mmu_vld,
	input	[`CORE_PC_WIDTH - 1 	: 0]			i_dtlb_mmu_vaddr,
	input										    i_exu_mem_rden,     //  DCACHE
	input	[`PHY_ADDR_WIDTH - 1	: 0]			i_exu_mem_raddr,
	input										    i_exu_mem_wren,
	input	[`PHY_ADDR_WIDTH - 1	: 0]			i_exu_mem_waddr,
	input 	[`DCACHE_MASK_WIDTH - 1	: 0]			i_exu_mem_wmask,
	input 	[`DCACHE_DATA_WIDTH - 1	: 0]			i_exu_mem_wdat,
	input										    i_exu_mmu_ack,
	input										    i_icache_mem_rden,  //  ICACHE
	input	[`PHY_ADDR_WIDTH - 1	: 0]			i_icache_mem_raddr,
	input 											i_ext_mmu_rd_ack,
	input 	[`MEM_SIZE_WIDTH - 1	: 0]			i_ext_mmu_rdat,
	input 											i_ext_mmu_wr_ack,
	input 											i_ext_mmu_rdy,

	output										    o_mmu_itlb_vld,
	output	[52					    : 0]			o_mmu_itlb_tlb,
	output	[`PHY_ADDR_WIDTH - 1	: 0]			o_mmu_itlb_paddr,
    output  [2                      : 0]            o_mmu_itlb_excp_code,
	output										    o_mmu_dtlb_vld,
	output	[52					    : 0]			o_mmu_dtlb_tlb,
	output	[`PHY_ADDR_WIDTH - 1    : 0]			o_mmu_dtlb_paddr,
    output  [2                      : 0]            o_mmu_dtlb_excp_code,
	output										    o_mem_exu_done,
	output	[511 				    : 0]			o_mem_exu_dat,
	output										    o_mem_icache_vld,
	output	[511				    : 0]			o_mem_icache_dat,
	output 										    o_mem_ext_wren,
	output										    o_mem_ext_rden,
	output	[`BYTE_MASK_WIDTH - 1   : 0]			o_mem_ext_mask,
	output	[2					    : 0]			o_mem_ext_burst,
	output	[`PHY_ADDR_WIDTH - 1	: 0]			o_mem_ext_paddr,
	output	[127				    : 0]			o_mem_ext_wdat,
	output										    o_mem_ext_burst_start,
	output										    o_mem_ext_burts_end,
	output										    o_mem_ext_burst_vld,
	output										    o_mem_rob_flush_done,
	output	[`PHY_ADDR_WIDTH - 1	: 0]			o_mem_cache_inv_paddr,
	output	[1					    : 0]			o_mem_cache_inv_vld,
	output										    o_mmu_busy,

	input											clk,
	input											rst_n
);

//
wire mmu_need_flush = (i_csr_trap_flush | i_exu_mis_flush | i_exu_ls_flush);

//  Control
localparam  MMU_STATE_WIDTH = 3;
localparam  MMU_STATE_IDLE  = 3'd1,
            MMU_STATE_SRCH_1= 3'd2,
            MMU_STATE_SRCH_2= 3'd4;

wire [MMU_STATE_WIDTH - 1 : 0] mmu_sta_cur_r, mmu_sta_nxt;

wire mmu_sta_is_idle   = (mmu_sta_cur_r == MMU_STATE_IDLE);
wire mmu_sta_is_srch_1 = (mmu_sta_cur_r == MMU_STATE_SRCH_1);
wire mmu_sta_is_srch_2 = (mmu_sta_cur_r == MMU_STATE_SRCH_2);

wire mmu_sta_exit_idle   = (mmu_sta_is_idle & (i_dtlb_mmu_vld | i_itlb_mmu_vld));
wire mmu_sta_exit_srch_1 = (mmu_sta_is_srch_1 & ((o_l2tlb_hit | o_pte_cache_hit | (pte[`PTE_V] & (pte[`PTE_R] | pte[`PTE_X]))) | ((~o_l2tlb_hit) & (~o_pte_cache_hit) & (pte[`PTE_V] & ((~pte[`PTE_X]) & (~pte[`PTE_W]) & (~pte[`PTE_R])))));
wire mmu_sta_exit_srch_2 = (mmu_sta_is_srch_2 & (pte[`PTE_V] & (pte[`PTE_R] | pte[`PTE_X])));

wire mmu_sta_enter_idle   = (mmu_need_flush | mmu_sta_exit_srch_2 | (mmu_sta_is_srch_1 & (o_l2tlb_hit | o_pte_cache_hit | (pte[`PTE_V] & (pte[`PTE_R] | pte[`PTE_X])))));
wire mmu_sta_enter_srch_1 = (mmu_sta_exit_idle & (~mmu_need_flush))
wire mmu_sta_enter_srch_2 = (mmu_sta_is_srch_1 & ((~o_l2tlb_hit) & (~o_pte_cache_hit) & (pte[`PTE_V] & ((~pte[`PTE_X]) & (~pte[`PTE_W]) & (~pte[`PTE_R])))) & (~mmu_need_flush));

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

wire mmu_rr_arb_ena = mmu_trans_done;

gnrl_dfflr #( 
	.DATA_WIDTH   (2),
	.INITIAL_VALUE(1)
) mmu_rr_arb_dfflr (mmu_rr_arb_ena, mmu_rr_arb_nxt, mmu_rr_arb_r, clk, rst_n);

wire [`CORE_PC_WIDTH - 1 : 0] mmu_vaddr_nxt = (i_dtlb_mmu_vld & i_itlb_mmu_vld) ? (({`CORE_PC_WIDTH{mmu_rr_arb_r[0]}} & i_itlb_mmu_vaddr) | ({`CORE_PC_WIDTH{mmu_rr_arb_r[1]}} & i_dtlb_mmu_vaddr))
										    : i_itlb_mmu_vld ? i_itlb_mmu_vaddr
											: i_dtlb_mmu_vaddr;

wire mmu_vaddr_ena = (mmu_sta_is_idle & (i_dtlb_mmu_vld | i_itlb_mmu_vld));
wire [`CORE_PC_WIDTH - 1 : 0] mmu_vaddr_r;

gnrl_dffl #( 
	.DATA_WIDTH(`CORE_PC_WIDTH)
) mmu_vaddr_dffl (mmu_vaddr_ena, mmu_vaddr_nxt, mmu_vaddr_r, clk);

wire [`PHY_ADDR_WIDTH - 1 : 0] pte_addr_0 = ({i_csr_mmu_satp[21 : 0], 12'h0} + {22'h0, mmu_vaddr_r[31 : 22], 2'h0});
wire [`PHY_ADDR_WIDTH - 1 : 0] pte_addr_1 = ({pte[31 : 10], 12'h0} + {22'h0, mmu_vaddr_r[31 : 22], 2'h0});

assign o_mem_ext_paddr = ({`PHY_ADDR_WIDTH{mmu_sta_is_srch_1}} & pte_addr_0)
					   | ({`PHY_ADDR_WIDTH{mmu_sta_is_srch_2}} & pte_addr_1);


wire [1 : 0] mmu_rr_port_r;
wire [1 : 0] mmu_rr_port_nxt = (i_dtlb_mmu_vld & i_itlb_mmu_vld) ? mmu_rr_arb_r
							 : i_itlb_mmu_vld ? 2'd1 
							 : 2'd2;
wire mmu_rr_port_ena = mmu_rr_arb_ena;

gnrl_dfflr #( 
	.DATA_WIDTH   (2),
	.INITIAL_VALUE(0)
) mmu_rr_port_dfflr (mmu_rr_port_ena, mmu_rr_port_nxt, mmu_rr_port_r, clk, rst_n);

//	L2TLB
wire i_l2tlb_rden = (i_dtlb_mmu_vld | i_itlb_mmu_vld);
wire [`CORE_PC_WIDTH - 1 : 0] i_l2tlb_vaddr = mmu_vaddr_r;
wire i_l2tlb_wren;
wire [`PTE_WIDTH - 1 : 0] i_l2tlb_pte;
wire [`PHY_ADDR_WIDTH - 1 : 0] i_l2tlb_paddr;

wire o_l2tlb_hit;
wire [`L2TLB_TLB_WIDTH - 1 : 0] o_l2tlb_tlb;
wire [`PHY_ADDR_WIDTH - 1 : 0] o_l2tlb_paddr;

l2tlb_module l2tlb ( 
	.i_csr_rv_mode(i_csr_rv_mode),
	.i_l2tlb_satp (i_csr_mmu_satp), 

	.i_l2tlb_rden (i_l2tlb_rden),
	.i_l2tlb_vaddr(i_l2tlb_vaddr),
	.i_l2tlb_wren (i_l2tlb_wren),
	.i_l2tlb_pte  (i_l2tlb_pte),
	.i_l2tlb_paddr(i_l2tlb_paddr),
	
	.o_l2tlb_hit  (o_l2tlb_hit),
	.o_l2tlb_tlb  (o_l2tlb_tlb),
	.o_l2tlb_paddr(o_l2tlb_paddr),

	.clk		  (clk),
	.rst_n		  (rst_n)
);

//	PTE_CACHE
wire i_pte_cache_rden = (i_dtlb_mmu_vld | i_itlb_mmu_vld);
wire [`CORE_PC_WIDTH - 1 : 0] i_pte_cache_vaddr = mmu_vaddr_r;
wire i_pte_cache_wren;
wire [1 : 0] i_pte_cache_level;
wire [`PTE_WIDTH - 1 : 0] i_pte_cache_pte;

wire o_pte_cache_hit;
wire [`PTE_CACHE_DATA_WIDTH - 1 : 0] o_pte_cache_rdat;
pte_cache_module pte_cache ( 
	.i_csr_rv_mode		  (i_csr_rv_mode),
	.i_pte_cache_satp	  (i_csr_mmu_satp),
	.i_pte_cache_mmu_flush(i_rob_mmu_flush),
	.i_pte_cache_mmu_src1 (i_rob_mmu_src1),
	.i_pte_cache_mmu_src2 (i_rob_mmu_src2),

	.i_pte_cache_rden	  (i_pte_cache_rden),
	.i_pte_cache_vaddr	  (i_pte_cache_vaddr), 
	.i_pte_cache_wren	  (i_pte_cache_wren),
	.i_pte_cache_level	  (i_pte_cache_level),
	.i_pte_cache_pte	  (i_pte_cache_pte),

	.o_pte_cache_hit	  (o_pte_cache_hit),
	.o_pte_cache_rdata	  (o_pte_cache_rdata),

	.clk	 			  (clk),
	.rst_n				  (rst_n)
);

//
wire [`PTE_WIDTH - 1 : 0] pte = i_ext_mem_rdat[`PTE_WIDTH - 1 : 0];
wire pte_level_1 = ((pte[`PTE_V] == 1'b1) & ((pte[`PTE_R] == 1'b1) | (pte[`PTE_W] == 1'b1)));

wire [2 : 0] mmu_tlb_excp_vec;

wire mmu_tlb_excp_0_ena = (mmu_sta_nxt == MMU_STATE_SRCH_2);
wire mmu_tlb_excp_0_r, mmu_tlb_excp_0_nxt;

assign mmu_tlb_excp_0_nxt = ((pte[`PTE_V] == 1'b0) | ((pte[`PTE_R] == 1'b0) & (pte[`PTE_W] == 1'b1)));

gnrl_dffl #( 
	.DATA_WIDTH(1)
) mmu_tlb_excp_0_dffl (mmu_tlb_excp_0_ena, mmu_tlb_excp_0_nxt, mmu_tlb_excp_0_r, clk);

wire [1 : 0] mmu_tlb_excp_1_vec = {
									((pte[`PTE_V] == 1'b1) & ((pte[`PTE_R] == 1'b0) & (pte[`PTE_W] == 1'b0) & (pte[`PTE_X] == 1'b0)))
								,	((pte[`PTE_V] == 1'b0) | ((pte[`PTE_R] == 1'b0) & (pte[`PTE_W] == 1'b1)))
								};

assign mmu_tlb_excp_vec = {
							((~pte_level_1) & mmu_tlb_excp_1_vec)
						,	(pte_level_1 ? mmu_tlb_excp_0_nxt : mmu_tlb_excp_0_r)
						};

wire [`PHY_ADDR_WIDTH - 1 : 0] mmu_paddr = {pte[31 : 10], mmu_vaddr_r[11 : 0]};

assign o_mmu_itlb_paddr = mmu_paddr;
assign o_mmu_dtlb_paddr = mmu_paddr;

wire mmu_trans_done = ((mmu_sta_is_srch_1 | mmu_sta_is_srch_2) & mmu_sta_enter_idle & (~mmu_need_flush));

assign o_mmu_itlb_vld = (mmu_trans_done & mmu_rr_port_r[0]);
assign o_mmu_dtlb_vld = (mmu_trans_done & mmu_rr_port_r[1]);

wire [`L2TLB_TLB_WIDTH - 1 : 0] mmu_tlb = {
											pte[7 : 0]
										,	i_csr_mmu_satp[30 : 22]
										,	i_csr_rv_mode[1 : 0]
										,	mmu_vaddr_r[31 : 15]
										,	mmu_paddr[33 : 12]
										};
assign o_mmu_itlb_tlb = o_l2tlb_hit ? o_l2tlb_tlb : mmu_tlb;
assign o_mmu_dtlb_tlb = o_mmu_itlb_tlb;

assign o_mmu_itlb_excp_code = mmu_tlb_excp_vec;
assign o_mmu_dtlb_excp_code = mmu_tlb_excp_vec;
//
assign o_mmu_busy = (~mmu_sta_is_idle);
//
wire [1 : 0] mmu_load_arb_r, mmu_load_arb_nxt;

assign mmu_load_arb_nxt = ((i_icache_mem_rden & mmu_load_arb_r[0]) | (i_exu_mem_rden & mmu_load_arb_r[0])) ? {mmu_load_arb_r[0], mmu_load_arb_r[1]} : mmu_load_arb_r; 

wire mmu_load_arb_ena = (mmu_sta_is_srch_2 & );

gnrl_dfflr #( 
	.DATA_WIDTH   (2),
	.INITIAL_VALUE(1)
) mmu_load_arb_dfflr (mmu_load_arb_ena, mmu_load_arb_nxt, mmu_load_arb_r, clk, rst_n);



endmodule   //  mmu_module

`endif /*   !__MMU_MMU_V__! */