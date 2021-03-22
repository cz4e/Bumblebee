`ifdef __EXU_AGU_V__

module exu_agu_module (
    input                                           i_csr_trap_flush,
    input                                           i_exu_mis_flush,
    input   [`ROB_ID_WIDTH - 1          : 0]        i_exu_mis_rob_id,
    input   [1                          : 0]        i_csr_rv_mode,
    input   [`CSR_SATP_WIDTH - 1        : 0]        i_csr_mmu_satp,

    input   [3                          : 0]        i_dsp_rsv_vld,
    input   [`ROB_ID_WIDTH - 1          : 0]        i_dsp_rsv_rob_id_0,
    input                                           i_dsp_rsv_ld_vld_0,
    input   [`LBUFF_ID_WIDTH - 1        : 0]        i_dsp_rsv_ld_id_0,
    input                                           i_dsp_rsv_st_vld_0,
    input   [`SBUFF_ID_WIDTH - 1        : 0]        i_dsp_rsv_st_id_0,
    input                                           i_dsp_rsv_dst_vld_0,
    input   [`PRF_CODE_WIDTH - 1        : 0]        i_dsp_rsv_dst_code_0,
    input   [`DECINFO_WIDTH - 1         : 0]        i_dsp_rsv_decinfo_bus_0,
    input   [`ROB_ID_WIDTH - 1          : 0]        i_dsp_rsv_rob_id_1,
    input                                           i_dsp_rsv_ld_vld_1,
    input   [`LBUFF_ID_WIDTH - 1        : 0]        i_dsp_rsv_ld_id_1,
    input                                           i_dsp_rsv_st_vld_1,
    input   [`SBUFF_ID_WIDTH - 1        : 0]        i_dsp_rsv_st_id_1,
    input                                           i_dsp_rsv_dst_vld_1,
    input   [`PRF_CODE_WIDTH - 1        : 0]        i_dsp_rsv_dst_code_1,
    input   [`DECINFO_WIDTH - 1         : 0]        i_dsp_rsv_decinfo_bus_1,
    input   [`ROB_ID_WIDTH - 1          : 0]        i_dsp_rsv_rob_id_2,
    input                                           i_dsp_rsv_ld_vld_2,
    input   [`LBUFF_ID_WIDTH - 1        : 0]        i_dsp_rsv_ld_id_2,
    input                                           i_dsp_rsv_st_vld_2,
    input   [`SBUFF_ID_WIDTH - 1        : 0]        i_dsp_rsv_st_id_2,
    input                                           i_dsp_rsv_dst_vld_2,
    input   [`PRF_CODE_WIDTH - 1        : 0]        i_dsp_rsv_dst_code_2,
    input   [`DECINFO_WIDTH - 1         : 0]        i_dsp_rsv_decinfo_bus_2,
    input   [`ROB_ID_WIDTH - 1          : 0]        i_dsp_rsv_rob_id_3,
    input                                           i_dsp_rsv_ld_vld_3,
    input   [`LBUFF_ID_WIDTH - 1        : 0]        i_dsp_rsv_ld_id_3,
    input                                           i_dsp_rsv_st_vld_3,
    input   [`SBUFF_ID_WIDTH - 1        : 0]        i_dsp_rsv_st_id_3,
    input                                           i_dsp_rsv_dst_vld_3,
    input   [`PRF_CODE_WIDTH - 1        : 0]        i_dsp_rsv_dst_code_3,
    input   [`DECINFO_WIDTH - 1         : 0]        i_dsp_rsv_decinfo_bus_3,
    input   [`LBUFF_ID_WIDTH - 1        : 0]        i_dsp_exu_ld_dsp_ptr,
    input   [`LBUFF_ID_WIDTH - 1        : 0]        i_dsp_exu_ld_ret_ptr,
    input   [`SBUFF_ID_WIDTH - 1        : 0]        i_dsp_exu_st_dsp_ptr,
    input   [`SBUFF_ID_WIDTH - 1        : 0]        i_dsp_exu_st_ret_ptr,
    input   [`SBUFF_ID_WIDTH - 1        : 0]        i_dsp_exu_st_ret_cptr,


    input   [3                          : 0]        i_rob_exu_ret_vld,
    input                                           i_rob_exu_ret_ld_vld_0,
    input   [`LBUFF_ID_WIDTH - 1        : 0]        i_rob_exu_ret_ld_id_0,
    input                                           i_rob_exu_ret_st_vld_0,
    input   [`SBUFF_ID_WIDTH - 1        : 0]        i_rob_exu_ret_st_id_0,
    input                                           i_rob_exu_ret_ld_vld_1,
    input   [`LBUFF_ID_WIDTH - 1        : 0]        i_rob_exu_ret_ld_id_1,
    input                                           i_rob_exu_ret_st_vld_1,
    input   [`SBUFF_ID_WIDTH - 1        : 0]        i_rob_exu_ret_st_id_1,
    input                                           i_rob_exu_ret_ld_vld_2,
    input   [`LBUFF_ID_WIDTH - 1        : 0]        i_rob_exu_ret_ld_id_2,
    input                                           i_rob_exu_ret_st_vld_2,
    input   [`SBUFF_ID_WIDTH - 1        : 0]        i_rob_exu_ret_st_id_2,
    input                                           i_rob_exu_ret_ld_vld_3,
    input   [`LBUFF_ID_WIDTH - 1        : 0]        i_rob_exu_ret_ld_id_3,
    input                                           i_rob_exu_ret_st_vld_3,
    input   [`SBUFF_ID_WIDTH - 1        : 0]        i_rob_exu_ret_st_id_3,
    input   [`CORE_PC_WIDTH - 1         : 0]        i_rob_exu_ls_addr,
    input                                           i_rob_dtlb_flush,
    input   [31                         : 0]        i_rob_dtlb_src1,
    input   [31                         : 0]        i_rob_dtlb_src2,

    input                                           i_rsv_exu_vld,
    input                                           i_rsv_exu_src1_vld,
    input   [`PRF_DATA_WIDTH - 1        : 0]        i_rsv_exu_src1_dat
    input                                           i_rsv_exu_src2_vld,
    input   [`PRF_DATA_WIDTH - 1        : 0]        i_rsv_exu_src2_dat,
    input                                           i_rsv_exu_src3_vld,
    input   [`PRF_DATA_WIDTH - 1        : 0]        i_rsv_exu_src3_dat,
    input                                           i_rsv_exu_dst_vld,
    input   [`PRF_CODE_WIDTH - 1        : 0]        i_rsv_exu_dst_code,
    input   [`ROB_ID_WIDTH - 1          : 0]        i_rsv_exu_rob_id,
    input                                           i_rsv_exu_ld_vld,
    input   [`LBUFF_ID_WIDTH - 1        : 0]        i_rsv_exu_ld_id,
    input                                           i_rsv_exu_st_vld,
    input   [`SBUFF_ID_WIDTH - 1        : 0]        i_rsv_exu_st_id,
    input   [`DECINFO_WIDTH - 1         : 0]        i_rsv_exu_decinfo_bus,
    input   [`IMM_WIDTH - 1             : 0]        i_rsv_exu_imm,
    input                                           i_mmu_busy,
    input                                           i_mmu_dtlb_vld,
    input   [52                         : 0]        i_mmu_dtlb_tlb,
    input   [2                          : 0]        i_mmu_dtlb_excp_code,
    input                                           i_mmu_dcache_vld,
    input   [`DCACHE_DATA_WIDTH - 1     : 0]        i_mmu_dcache_dat,
    input                                           i_mmu_exu_done,


    output                                          o_exu_rsv_wren,
    output  [`PRF_CODE_WIDTH - 1        : 0]        o_exu_rsv_wr_prf_code,
    output  [`PRF_DATA_WIDTH - 1        : 0]        o_exu_rsv_wr_dat,
    output                                          o_exu_rsv_busy,
    output                                          o_exu_rob_vld,
    output  [`EXCEPTION_CODE_WIDTH - 1  : 0]        o_exu_rob_excp_code,
    output  [`ROB_ID_WIDTH - 1          : 0]        o_exu_rob_rob_id,
    output                                          o_exu_ls_flush,
    output  [`ROB_ID_WIDTH - 1          : 0]        o_exu_ls_rob_id,
    output  [`CORE_PC_WIDTH - 1         : 0]        o_exu_ls_addr,
    output                                          o_dtlb_mmu_vld,
    output  [`CORE_PC_WIDTH - 1         : 0]        o_dtlb_mmu_vaddr,
    output                                          o_exu_mem_rd_vld,
    output  [`PHY_ADDR_WIDTH - 1        : 0]        o_exu_mem_rd_paddr,
    output                                          o_exu_mem_wr_vld,
    output  [`DCACHE_DATA_WIDTH - 1     : 0]        o_exu_mem_wdat,
    output  [`PHY_ADDR_WIDTH - 1        : 0]        o_exu_mem_wr_paddr,
    output                                          o_exu_dsp_s_ret,
    output                                          o_exu_rob_s_ret_done,

    input                                           clk,
    input                                           rst_n
);

wire agu_need_flush = (i_csr_trap_flush | i_exu_mis_flush);
//
wire [`AGU_INFO_WIDTH - 1 : 0] agu_info_r, agu_info_nxt;

assign agu_info_nxt = {
                            i_rsv_exu_src1_vld
                        ,   i_rsv_exu_src1_dat
                        ,   i_rsv_exu_src2_vld
                        ,   i_rsv_exu_src2_dat
                        ,   i_rsv_exu_src3_vld
                        ,   i_rsv_exu_src3_dat
                        ,   i_rsv_exu_dst_vld
                        ,   i_rsv_exu_dst_code
                        ,   i_rsv_exu_rob_id
                        ,   i_rsv_exu_ld_vld
                        ,   i_rsv_exu_ld_id
                        ,   i_rsv_exu_st_vld
                        ,   i_rsv_exu_st_id
                        ,   i_rsv_exu_decinfo_bus
                        ,   i_rsv_exu_excp_code
                        ,   i_rsv_exu_imm
                    };

wire agu_info_ena = (i_rsv_exu_vld & agu_sta_is_idle & (i_exu_mis_flush ? func_rob_old(i_rsv_exu_rob_id, i_exu_mis_rob_id) : 1'b1) & (~o_sbuff_ret_vld));
gnrl_dffl #( 
    .DATA_WIDTH(`AGU_INFO_WIDTH)
) agu_info_dffl (agu_info_ena, agu_info_nxt, agu_info_r, clk);

wire                           agu_src1_vld;
wire [`PRF_DATA_WIDTH - 1 : 0] agu_src1_dat;
wire                           agu_src2_vld;
wire [`PRF_DATA_WIDTH - 1 : 0] agu_src2_dat;
wire                           agu_src3_vld;
wire [`PRF_DATA_WIDTH - 1 : 0] agu_src3_dat;
wire                           agu_dst_vld; 
wire [`PRF_CODE_WIDTH - 1 : 0] agu_dst_code;
wire [`ROB_ID_WIDTH - 1   : 0] agu_rob_id;
wire                           agu_ld_vld;
wire [`LBUFF_ID_WIDTH - 1 : 0] agu_ld_id;
wire                           agu_st_vld;
wire [`SBUFF_ID_WIDTH - 1 : 0] agu_st_id;
wire [`DECINFO_WIDTH - 1  : 0] agu_decinfo_bus;
wire [`EXCEPTION_CODE_WIDTH - 1 : 0] agu_excp_code;
wire [`IMM_WIDTH - 1      : 0] agu_imm;

assign {
            agu_src1_vld
        ,   agu_src1_dat
        ,   agu_src2_vld
        ,   agu_src2_dat
        ,   agu_src3_vld
        ,   agu_src3_dat
        ,   agu_dst_vld
        ,   agu_dst_code
        ,   agu_rob_id
        ,   agu_ld_vld
        ,   agu_ld_id 
        ,   agu_st_vld
        ,   agu_st_id
        ,   agu_decinfo_bus
        ,   agu_excp_code
        ,   agu_imm
        ,   agu_vld
} = {
        agu_info_r
    ,   (~agu_sta_is_idle)
};

//  Extract info
wire agu_load = agu_decinfo_bus[`UOPINFO_AGU_LOAD ];
wire agu_store= agu_decinfo_bus[`UOPINFO_AGU_STORE];
wire agu_size = agu_decinfo_bus[`UOPINFO_AGU_SIZE ];
wire agu_usign= agu_decinfo_bus[`UOPINFO_AGU_USIGN];

`ifdef __CORE_SUPPORT_RV32A__
wire agu_amoswapw = agu_decinfo_bus[`UOPINFO_AGU_AMOSWAPW];
wire agu_amoaddw  = agu_decinfo_bus[`UOPINFO_AGU_AMOADDW];
wire agu_amoxorw  = agu_decinfo_bus[`UOPINFO_AGU_AMOXORW];
wire agu_amoandw  = agu_decinfo_bus[`UOPINFO_AGU_AMOANDW];
wire agu_amoorw   = agu_decinfo_bus[`UOPINFO_AGU_AMOORW];
wire agu_amominw  = agu_decinfo_bus[`UOPINFO_AGU_AMOMINW];
wire agu_amomaxw  = agu_decinfo_bus[`UOPINFO_AGU_AMOMAXW];
wire agu_amominuw = agu_decinfo_bus[`UOPINFO_AGU_AMOMINUW];
wire agu_amomaxuw = agu_decinfo_bus[`UOPINFO_AGU_AMOMAXUW];
`endif //   __CORE_SUPPORT_RV32A__

//  Control
localparam  AGU_STATE_WIDTH = 4;
localparam  AGU_STATE_IDLE   = 4'b0001,
            AGU_STATE_EXEC_1 = 4'b0010,
            AGU_STATE_EXEC_2 = 4'b0100,
            AGU_STATE_EXEC_3 = 4'b1000;

wire [AGU_STATE_WIDTH - 1 : 0] agu_sta_cur_r, agu_sta_nxt;

wire agu_sta_is_idle  = (agu_sta_cur_r == AGU_STATE_IDLE);
wire agu_sta_is_exec_1= (agu_sta_cur_r == AGU_STATE_EXEC_1);
wire agu_sta_is_exec_2= (agu_sta_cur_r == AGU_STATE_EXEC_2);
wire agu_sta_is_exec_3= (agu_sta_cur_r == AGU_STATE_EXEC_3);

wire agu_sta_exit_idle  = agu_info_ena;
wire agu_sta_exit_exec_1= (agu_sta_is_exec_1 & ((agu_exec_1_delay_r & i_mmu_dtlb_vld) | ((~agu_exec_1_delay_r) & o_dtlb_hit)));
wire agu_sta_exit_exec_2= (agu_sta_is_exec_2 & ((agu_exec_1_delay_r & i_mmu_dcache_vld) | ((~agu_exec_2_delay_r) & o_dcache_hit)));
wire agu_sta_exit_exec_3= (agu_sta_is_exec_3);

wire agu_sta_enter_exec_1 = (agu_sta_exit_idle & (~agu_need_flush));
wire agu_sta_enter_exec_2 = (agu_sta_exit_exec_1 & (~(agu_need_flush & agu_store)));
wire agu_sta_enter_exec_3 = (agu_sta_exit_exec_2 & (~agu_need_flush));
wire agu_sta_enter_idle   = (agu_sta_exit_exec_3 | agu_need_flush | (agu_sta_is_exec_1 & agu_store));

wire agu_sta_ena = (agu_sta_exit_idle
                 |  agu_sta_exit_exec_1
                 |  agu_sta_exit_exec_2
                 |  agu_sta_exit_exec_3);

assign agu_sta_nxt = ({AGU_STATE_WIDTH{agu_sta_enter_idle  }} & AGU_STATE_IDLE  )
                   | ({AGU_STATE_WIDTH{agu_sta_enter_exec_1}} & AGU_STATE_EXEC_1)
                   | ({AGU_STATE_WIDTH{agu_sta_enter_exec_2}} & AGU_STATE_EXEC_2)
                   | ({AGU_STATE_WIDTH{agu_sta_enter_exec_3}} & AGU_STATE_EXEC_3);

gnrl_dfflr #( 
    .DATA_WIDTH   (AGU_STATE_WIDTH),
    .INITIAL_VALUE(AGU_STATE_IDLE)
) agu_sta_dfflr (agu_sta_ena, agu_sta_nxt, agu_sta_cur_r, clk, rst_n);

//  EXEC 1
wire [`CORE_PC_WIDTH - 1 : 0] agu_mem_addr = (agu_src1_dat + agu_imm);
wire [`CORE_PC_WIDTH - 1 : 0] agu_cr_vaddr = {(agu_mem_addr[31 : 12] + 12'h1), 12'h0};

wire agu_cr_vld = ((agu_mem_addr[11 : 0] == 12'hfff) & (agu_size != 2'b00))
                | ((agu_mem_addr[11 : 0] == 12'hfff) & (agu_size != 2'b00))
                | ((agu_mem_addr[11 : 0] == 12'hfff) & (agu_size != 2'b00));

wire agu_exec_1_delay_r;
wire agu_exec_1_delay_set = (agu_sta_is_exec_1 & (o_dtlb_hit | i_mmu_dtlb_vld) & agu_cr_vld & (~agu_exec_1_delay_r));
wire agu_exec_1_delay_clr = (agu_sta_is_exec_1 & (o_dtlb_hit | i_mmu_dtlb_vld) & agu_exec_1_delay_r);
wire agu_exec_1_delay_ena = (agu_exec_1_delay_set | agu_exec_1_delay_clr);
wire agu_exec_1_delay_nxt = (agu_exec_1_delay_set | (~agu_exec_1_delay_clr));

gnrl_dfflr #( 
    .DATA_WIDTH   (1),
    .INITIAL_VALUE(0)
) agu_exec_1_delay_dfflr (agu_exec_1_delay_ena, agu_exec_1_delay_nxt, agu_exec_1_delay_r, clk, rst_n);

wire [`CORE_PC_WIDTH - 1 : 0] agu_vaddr = ({`CORE_PC_WIDTH{(~agu_exec_1_delay_r)}} & agu_mem_addr)
                                        | ({`CORE_PC_WIDTH{agu_exec_1_delay_r   }} & agu_cr_vaddr);

//  DTLB
wire i_dtlb_rden = agu_sta_is_exec_1;
wire [`CORE_PC_WIDTH - 1 : 0] i_dtlb_rtag = {i_csr_mmu_satp[30 : 22], i_csr_rv_mode[1 : 0], agu_vaddr[31 : 15]};
wire [`CORE_PC_WIDTH - 1 : 0] i_dtlb_ridx = agu_vaddr[14 : 12];

wire o_dtlb_hit;
wire [`DTLB_DATA_WIDTH - 1 : 0] o_dtlb_rdat;

wire i_dtlb_wren = ((~i_dtlb_rden) & i_mmu_dtlb_vld);
wire [`DTLB_TAG_WIDTH - 1 : 0] i_dtlb_wtag;
wire [11 : 0] i_dtlb_vaddr_lo;
wire [`DTLB_DATA_WIDTH - 1 : 0] i_dtlb_wdat;

assign {
            i_dtlb_wtag
        ,   i_dtlb_vaddr_lo
        ,   i_dtlb_wdat
} = i_mmu_dtlb_tlb;

dtlb_module dtlb (
    .i_dtlb_rden(i_dtlb_rden),
    .i_dtlb_rtag(i_dtlb_rtag),
    .i_dtlb_ridx(i_dtlb_ridx),
    .i_dtlb_wren(i_dtlb_wren),
    .i_dtlb_widx(i_dtlb_ridx),
    .i_dtlb_wtag(i_dtlb_wtag),
    .i_dtlb_wdat(i_dtlb_wdat),

    .o_dtlb_hit (o_dtlb_hit),
    .o_dtlb_rdat(o_dtlb_rdat),

    .clk        (clk),
    .rst_n      (rst_n)
);

assign o_dtlb_mmu_vld    = (agu_sta_is_exec_1 & (~o_dtlb_hit));
assign o_dtlb_mmu_vaddr  = agu_vaddr;
assign o_dtlb_mmu_ld_vld = agu_ld_vld;
assign o_dtlb_mmu_ld_id  = agu_ld_id;
assign o_dtlb_mmu_st_vld = agu_st_vld;
assign o_dtlb_mmu_st_id  = agu_st_id;

wire [21 : 0] agu_paddr_1, agu_paddr_0;
assign agu_paddr_1 = ({22{o_dtlb_hit                      }} & o_dtlb_rdat[21 : 0])
                   | ({22{((~o_dtlb_hit) & i_mmu_dtlb_vld)}} & i_dtlb_wdat[21 : 0]);
wire agu_paddr_ena = agu_exec_1_delay_set;

gnrl_dfflr #( 
    .DATA_WIDTH   (22),
    .INITIAL_VALUE(0)
) agu_paddr_dfflr (agu_paddr_ena, agu_paddr_1, agu_paddr_0, clk, rst_n);

wire i_agu_exec_1_vld = (agu_sta_nxt == AGU_STATE_EXEC_2);
wire [43 : 0] i_agu_exec_1_paddr = ({44{(~agu_cr_vld)}} & {22'h0,       agu_paddr_1})
                                 | ({44{agu_cr_vld   }} & {agu_paddr_1, agu_paddr_0});
wire [`PRF_DATA_WIDTH - 1 : 0] i_agu_exec_1_data = agu_src2_dat;
wire i_agu_exec_2_vld = (agu_sta_nxt == AGU_STATE_EXEC_3);

//  Load buffer
wire i_lbuff_exec_1_vld = (i_agu_exec_1_vld & agu_load);
wire o_lbuff_old;

lbuff_module lbuff (
    .i_csr_trap_flush      (i_csr_trap_flush), 
    .i_exu_mis_flush       (i_exu_mis_flush),
    .i_exu_mis_rob_id      (i_exu_mis_rob_id),

    .i_dsp_rsv_vld         (i_dsp_rsv_vld),
    .i_dsp_rsv_rob_id_0    (i_dsp_rsv_rob_id_0),
    .i_dsp_rsv_ld_vld_0    (i_dsp_rsv_ld_vld_0), 
    .i_dsp_rsv_ld_id_0     (i_dsp_rsv_ld_id_0),
    .i_dsp_rsv_dst_vld_0   (i_dsp_rsv_dst_vld_0),
    .i_dsp_rsv_dst_code_0  (i_dsp_rsv_dst_code_0),
    .i_dsp_rsv_rob_id_1    (i_dsp_rsv_rob_id_1),
    .i_dsp_rsv_ld_vld_1    (i_dsp_rsv_ld_vld_1),
    .i_dsp_rsv_ld_id_1     (i_dsp_rsv_ld_id_1),
    .i_dsp_rsv_dst_vld_1   (i_dsp_rsv_dst_vld_1),
    .i_dsp_rsv_dst_code_1  (i_dsp_rsv_dst_code_1),
    .i_dsp_rsv_rob_id_2    (i_dsp_rsv_rob_id_2),
    .i_dsp_rsv_ld_vld_2    (i_dsp_rsv_ld_vld_2),
    .i_dsp_rsv_ld_id_2     (i_dsp_rsv_ld_id_2),
    .i_dsp_rsv_dst_vld_2   (i_dsp_rsv_dst_vld_2),
    .i_dsp_rsv_dst_code_2  (i_dsp_rsv_dst_code_2),
    .i_dsp_rsv_rob_id_3    (i_dsp_rsv_rob_id_3),
    .i_dsp_rsv_ld_vld_3    (i_dsp_rsv_ld_vld_3),
    .i_dsp_rsv_ld_id_3     (i_dsp_rsv_ld_id_3),
    .i_dsp_rsv_dst_vld_3   (i_dsp_rsv_dst_vld_3),
    .i_dsp_rsv_dst_code_3  (i_dsp_rsv_dst_code_3),
    .i_dsp_exu_ld_ret_ptr  (i_dsp_exu_ld_ret_ptr),
    .i_rsv_exu_vld         (agu_vld),
    .i_rsv_exu_ld_vld      (agu_ld_vld),
    .i_rsv_exu_ld_id       (agu_ld_id),
    .i_agu_exec_1_vld      (i_lbuff_exec_1_vld),
    .i_agu_exec_1_paddr    (i_agu_exec_1_paddr),
    .i_agu_exec_1_fs_vld   (o_sbuff_fs_vld),
    .i_agu_exec_1_fs_id    (o_sbuff_fs_id),
    .i_agu_exec_2_vld      (i_agu_exec_2_vld), 
    .i_agu_exec_2_excp_code(i_mmu_dtlb_excp_code),
    .i_rob_exu_ret_vld     (i_rob_exu_ret_vld),
    .i_rob_exu_ret_ld_vld_0(i_rob_exu_ret_ld_vld_0),
    .i_rob_exu_ret_ld_id_0 (i_rob_exu_ret_ld_id_0),
    .i_rob_exu_ret_ld_vld_1(i_rob_exu_ret_ld_vld_1),
    .i_rob_exu_ret_ld_id_1 (i_rob_exu_ret_ld_id_1),
    .i_rob_exu_ret_ld_vld_2(i_rob_exu_ret_ld_vld_2),
    .i_rob_exu_ret_ld_id_2 (i_rob_exu_ret_ld_id_2),
    .i_rob_exu_ret_ld_vld_3(i_rob_exu_ret_ld_vld_3),
    .i_rob_exu_ret_ld_id_3 (i_rob_exu_ret_ld_id_3),
    .i_rob_exu_ls_addr     (i_rob_exu_ls_addr),
    .i_sbuff_ret_vld       (o_sbuff_ret_vld),
    .i_sbuff_ret_st_id     (i_dsp_exu_st_ret_ptr),
    .i_sbuff_ret_paddr     (o_sbuff_ret_paddr),

    .o_lbuff_old           (o_lbuff_old),
    .o_exu_ls_flush        (o_exu_ls_flush),
    .o_exu_ls_addr         (o_exu_ls_addr),
    .o_exu_ls_rob_id       (o_exu_ls_rob_id),

    .clk                   (clk),
    .rst_n                 (rst_n)
);

//  Store buffer
wire i_sbuff_exec_1_vld = (i_agu_exec_1_vld & agu_store);
wire o_sbuff_fs_vld;
wire [`SBUFF_ID_WIDTH - 1 : 0] o_sbuff_fs_id;
wire o_sbuff_ret_vld;
wire [`ROB_ID_WIDTH - 1 : 0] o_sbuff_ret_rob_id;
wire o_sbuff_ret_cr_vld;
wire o_sbuff_ret_dst_vld;
wire [`PRF_CODE_WIDTH - 1 : 0] o_sbuff_ret_dst_code;
wire [`DECINFO_WIDTH - 1 : 0] o_sbuff_ret_decinfo_bus;
wire [`PRF_DATA_WIDTH - 1 : 0] o_sbuff_ret_dat;
wire o_sbuff_ret_vld;
wire [43 : 0] o_sbuff_ret_paddr;

sbuff_module sbuff (
    .i_csr_trap_flush       (i_csr_trap_flush),
    .i_exu_mis_flush        (i_exu_mis_flush),
    .i_exu_mis_rob_id       (i_exu_mis_rob_id),

    .i_dsp_rsv_vld          (i_dsp_rsv_vld),
    .i_dsp_rsv_rob_id_0     (i_dsp_rsv_rob_id_0),
    .i_dsp_rsv_st_vld_0     (i_dsp_rsv_st_vld_0),
    .i_dsp_rsv_st_id_0      (i_dsp_rsv_st_id_0),
    .i_dsp_rsv_dst_vld_0    (i_dsp_rsv_dst_vld_0),
    .i_dsp_rsv_dst_code_0   (i_dsp_rsv_dst_code_0),
    .i_dsp_rsv_decinfo_bus_0(i_dsp_rsv_decinfo_bus_0),
    .i_dsp_rsv_rob_id_1     (i_dsp_rsv_rob_id_1),
    .i_dsp_rsv_st_vld_1     (i_dsp_rsv_st_vld_1),
    .i_dsp_rsv_st_id_1      (i_dsp_rsv_st_id_1),
    .i_dsp_rsv_dst_vld_1    (i_dsp_rsv_dst_vld_1),
    .i_dsp_rsv_dst_code_1   (i_dsp_rsv_dst_code_1),
    .i_dsp_rsv_decinfo_bus_1(i_dsp_rsv_decinfo_bus_1),
    .i_dsp_rsv_rob_id_2     (i_dsp_rsv_rob_id_2),
    .i_dsp_rsv_st_vld_2     (i_dsp_rsv_st_vld_2),
    .i_dsp_rsv_st_id_2      (i_dsp_rsv_st_id_2),
    .i_dsp_rsv_dst_vld_2    (i_dsp_rsv_dst_vld_2),
    .i_dsp_rsv_dst_code_2   (i_dsp_rsv_dst_code_2),
    .i_dsp_rsv_decinfo_bus_2(i_dsp_rsv_decinfo_bus_2),
    .i_dsp_rsv_rob_id_3     (i_dsp_rsv_rob_id_3),
    .i_dsp_rsv_st_vld_3     (i_dsp_rsv_st_vld_3),
    .i_dsp_rsv_st_id_3      (i_dsp_rsv_st_id_3),
    .i_dsp_rsv_dst_vld_3    (i_dsp_rsv_dst_vld_3),
    .i_dsp_rsv_dst_code_3   (i_dsp_rsv_dst_code_3),
    .i_dsp_rsv_decinfo_bus_3(i_dsp_rsv_decinfo_bus_3),
    .i_dsp_exu_st_ret_ptr   (i_dsp_exu_st_ret_ptr),
    .i_dsp_exu_st_ret_cptr  (i_dsp_exu_st_ret_cptr),
    .i_rsv_exu_vld          (agu_vld),
    .i_rsv_exu_ld_vld       (agu_ld_vld),
    .i_rsv_exu_ld_id        (agu_ld_id),
    .i_rsv_exu_st_vld       (agu_st_vld),
    .i_rsv_exu_st_id        (agu_st_id),
    .i_sbuff_old            (o_lbuff_old),
    .i_agu_exec_1_vld       (i_sbuff_exec_1_vld),
    .i_agu_exec_1_vaddr     (i_agu_exec_1_vaddr),
    .i_agu_exec_1_paddr     (i_agu_exec_1_paddr), 
    .i_agu_exec_1_data      (i_agu_exec_1_data),
    .i_agu_exec_2_vld       (i_sbuff_exec_2_vld),
    .i_agu_exec_2_excp_code (i_agu_exec_2_excp_code),
    .i_rob_exu_ret_vld      (i_rob_exu_ret_vld),
    .i_rob_exu_ret_st_vld_0 (i_rob_exu_ret_st_vld_0),
    .i_rob_exu_ret_st_id_0  (i_rob_exu_ret_st_id_0),
    .i_rob_exu_ret_st_vld_1 (i_rob_exu_ret_st_vld_1),
    .i_rob_exu_ret_st_id_1  (i_rob_exu_ret_st_id_1),
    .i_rob_exu_ret_st_vld_2 (i_rob_exu_ret_st_vld_2), 
    .i_rob_exu_ret_st_id_2  (i_rob_exu_ret_st_id_2),
    .i_rob_exu_ret_st_vld_3 (i_rob_exu_ret_st_vld_3),
    .i_rob_exu_ret_st_id_3  (i_rob_exu_ret_st_id_3),
    .i_sbuff_ret_done       (o_exu_dsp_s_ret),

    .o_sbuff_fs_vld         (o_sbuff_fs_vld),
    .o_sbuff_fs_id          (o_sbuff_fs_id),
    .o_sbuff_ret_vld        (o_sbuff_ret_vld),
    .o_sbuff_ret_rob_id     (o_sbuff_ret_rob_id),
    .o_sbuff_ret_cr_vld     (o_sbuff_ret_cr_vld),
    .o_sbuff_ret_dst_vld    (o_sbuff_ret_dst_vld),
    .o_sbuff_ret_dst_code   (o_sbuff_ret_dst_code),
    .o_sbuff_ret_mem_size   (o_sbuff_ret_mem_size),
    .o_sbuff_ret_vaddr      (o_sbuff_ret_vaddr),
    .o_sbuff_ret_paddr      (o_sbuff_ret_paddr),
    .o_sbuff_ret_data       (o_sbuff_ret_data),

    .clk                    (clk),
    .rst_n                  (rst_n)
);


//  EXEC 2
wire agu_exec_2_info_ena = i_agu_exec_1_vld;
wire [`AGU_EXEC_2_INFO_WIDTH - 1 : 0] agu_exec_2_info_r, agu_exec_2_info_nxt;

assign agu_info_nxt = {
                            agu_mem_addr[11 : 0]
                        ,   i_agu_exec_1_paddr
                    };
gnrl_dfflr #( 
    .DATA_WIDTH   (44),
    .INITIAL_VALUE(0)
) agu_exec_2_info_dfflr (agu_exec_2_info_ena, agu_exec_2_info_nxt, agu_exec_2_info_r, clk, rst_n);

wire agu_exec_2_delay_r;
wire agu_exec_2_delay_set = (agu_sta_is_exec_2 & (o_dcache_hit | i_mmu_dcache_vld) & agu_cr_vld & (~agu_exec_2_delay_r));
wire agu_exec_2_delay_clr = (agu_sta_is_exec_2 & (o_dcache_hit | i_mmu_dcache_vld) & agu_exec_2_delay_r);
wire agu_exec_2_delay_ena = (agu_exec_2_delay_set | agu_exec_2_delay_clr);
wire agu_exec_2_delay_nxt = (agu_exec_2_delay_set | (~agu_exec_2_delay_clr));

gnrl_dfflr #( 
    .DATA_WIDTH   (1),
    .INITIAL_VALUE(0)
) agu_exec_2_delay_dfflr (agu_exec_2_delay_ena, agu_exec_2_delay_nxt, agu_exec_2_delay_r, clk, rst_n);

wire [11 : 0] agu_exec_2_paddr_lo;
wire [43 : 0] agu_exec_2_paddr_hi;

assign {
            agu_exec_2_paddr_lo
        ,   agu_exec_2_paddr_hi
} = agu_exec_2_info_r;

wire [`PHY_ADDR_WIDTH - 1 : 0] agu_paddr = ({`PHY_ADDR_WIDTH{(~agu_exec_2_delay_r)}} & {agu_exec_2_paddr_hi[21 : 0], agu_exec_2_paddr_lo[11 : 0]})
                                         | ({`PHY_ADDR_WIDTH{agu_exec_2_delay_r   }} & {agu_exec_2_paddr_hi[43 : 22],                      12'h0});
wire i_dcache_rden = agu_sta_is_exec_2;
wire [`DCACHE_TAG_WIDTH - 1 : 0] i_dcache_rtag = agu_paddr[13 : 6];
wire [`DCACHE_IDX_WIDTH - 1 : 0] i_dcache_ridx = agu_paddr[33 : 14];

wire o_dcache_hit;
wire [`DCACHE_DATA_WIDTH - 1 : 0] o_dcache_rdat;
wire o_dcache_dirty;

wire agu_exec_2_wr_delay_r;
wire agu_exec_2_wr_delay_set = (agu_sta_is_exec_2 & o_sbuff_ret_cr_vld & (~agu_exec_2_wr_delay_r));
wire agu_exec_2_wr_delay_clr = (agu_sta_is_exec_2 & agu_exec_2_wr_delay_r & ((~o_dcache_dirty) | i_mmu_exu_done));
wire agu_exec_2_wr_delay_ena = (agu_exec_2_wr_delay_set | agu_exec_2_wr_delay_clr);
wire agu_exec_2_wr_delay_nxt = (agu_exec_2_wr_delay_set | (~agu_exec_2_wr_delay_clr));

gnrl_dfflr #( 
    .DATA_WIDTH   (1),
    .INITIAL_VALUE(0)
) agu_exec_2_wr_delay_dfflr (agu_exec_2_wr_delay_ena, agu_exec_2_wr_delay_nxt, agu_exec_2_wr_delay_r, clk, rst_n);

wire [`PHY_ADDR_WIDTH - 1 : 0] agu_wr_paddr = ({`PHY_ADDR_WIDTH{(~agu_exec_2_wr_delay_r)}} & {o_sbuff_ret_paddr[21 : 0], o_sbuff_ret_paddr[11 : 0]})
                                            | ({`PHY_ADDR_WIDTH{agu_exec_2_wr_delay_r   }} & {o_sbuff_ret_paddr[43 : 22],                    12'h0});

wire i_dcache_wren = (o_sbuff_ret_vld & (~agu_sta_is_idle));
wire [`DCACHE_TAG_WIDTH - 1 : 0] i_dcache_wtag = agu_wr_paddr[13 : 6];
wire [`DCACHE_IDX_WIDTH - 1 : 0] i_dcache_widx = agu_wr_paddr[33 : 14];
wire [`DCACHE_MASK_WIDTH - 1 : 0] i_dcache_wmask;

wire [5 : 0] agu_offset = ({6{(agu_size[1 : 0] == 2'b00)}} & 6'd0)
                        | ({6{(agu_size[1 : 0] == 2'b01)}} & 6'd1)
                        | ({6{(agu_size[1 : 0] == 2'b10)}} & 6'd3);
genvar wmask_idx;
generate
    for(wmask_idx = 0; wmask_idx < 64; wmask_idx = wmask_idx + 1) begin
        assign i_dcache_wmask[wmask_idx] = ((wmask_idx >= agu_paddr[5 : 0]) & (wmask_idx <= (agu_paddr[5 : 0] + (agu_offset))));        
    end
endgenerate



wire [`PHY_ADDR_WIDTH - 1 : 0] o_dcache_wb_addr;

dcache_module dcache ( 
    .i_dcache_rden   (i_dcache_rden),
    .i_dcache_rtag   (i_dcache_rtag),
    .i_dcache_ridx   (i_dcache_ridx),
    .i_dcache_wren   (i_dcache_wren),
    .i_dcache_widx   (i_dcache_widx),
    .i_dcache_wtag   (i_dcache_wtag),
    .i_dcache_wmask  (i_dcache_wmask),
    .i_dcache_wdat   (o_sbuff_ret_dat),
    .i_dcache_rep    (i_mmu_dcache_vld),
    .i_dcache_rep_dat(i_mmu_cache_data),
    .o_dcache_hit    (o_dcache_hit),
    .o_dcache_rdat   (o_dcache_rdat),
    .o_dcache_wb     (o_dcache_wb),
    .o_dcache_wb_addr(o_dcache_wb_addr),
    .o_dcache_wb_dat (o_dcache_wb_dat),

    .clk             (clk),
    .rst_n           (rst_n)
);

wire agu_dcache_part_ena = (agu_sta_is_exec_2 & agu_cr_vld & (((~agu_exec_2_delay_r) & o_dcache_hit) | i_mmu_dcache_vld));
wire [`DCACHE_DATA_WIDTH - 1 : 0] agu_dcache_part_dat_1, agu_dcache_part_dat_0;

assign agu_dcache_part_dat_1 = ({`DCACHE_DATA_WIDTH{((~o_dcache_hit) & i_mmu_dcache_vld)}} & i_mmu_cache_data)
                             | ({`DCACHE_DATA_WIDTH{o_dcache_hit                        }} & o_dcache_rdat   );

gnrl_dffl #( 
    .DATA_WIDTH(`DCACHE_DATA_WIDTH)
) agu_dcache_part_dat_dffl (agu_dcache_part_ena, agu_dcache_part_dat_1, agu_dcache_part_dat_0, clk);

wire [2 * `DCACHE_DATA_WIDTH - 1 : 0] agu_dcache_dat = ({(2 * `DCACHE_DATA_WIDTH){agu_cr_vld   }} & {agu_dcache_part_dat_1, agu_dcache_part_dat_0})
                                                     | ({(2 * `DCACHE_DATA_WIDTH){(~agu_cr_vld)}} & {`DCACHE_DATA_WIDTH'd0, agu_dcache_part_dat_1});

wire [`PRF_DATA_WIDTH - 1 : 0] agu_wr_data  = ({`PRF_DATA_WIDTH{(agu_paddr[5 : 0] == 6'd0 )}} & agu_dcache_dat[31  :  0] )
                                            | ({`PRF_DATA_WIDTH{(agu_paddr[5 : 0] == 6'd1 )}} & agu_dcache_dat[39  :  8] )
                                            | ({`PRF_DATA_WIDTH{(agu_paddr[5 : 0] == 6'd2 )}} & agu_dcache_dat[47  :  16])
                                            | ({`PRF_DATA_WIDTH{(agu_paddr[5 : 0] == 6'd3 )}} & agu_dcache_dat[55  :  24])
                                            | ({`PRF_DATA_WIDTH{(agu_paddr[5 : 0] == 6'd4 )}} & agu_dcache_dat[63  :  32])
                                            | ({`PRF_DATA_WIDTH{(agu_paddr[5 : 0] == 6'd5 )}} & agu_dcache_dat[71  :  40])
                                            | ({`PRF_DATA_WIDTH{(agu_paddr[5 : 0] == 6'd6 )}} & agu_dcache_dat[79  :  48])
                                            | ({`PRF_DATA_WIDTH{(agu_paddr[5 : 0] == 6'd7 )}} & agu_dcache_dat[87  :  56])
                                            | ({`PRF_DATA_WIDTH{(agu_paddr[5 : 0] == 6'd8 )}} & agu_dcache_dat[95  :  64])
                                            | ({`PRF_DATA_WIDTH{(agu_paddr[5 : 0] == 6'd9 )}} & agu_dcache_dat[103 :  72])
                                            | ({`PRF_DATA_WIDTH{(agu_paddr[5 : 0] == 6'd10)}} & agu_dcache_dat[111 :  80])
                                            | ({`PRF_DATA_WIDTH{(agu_paddr[5 : 0] == 6'd11)}} & agu_dcache_dat[119 :  88])
                                            | ({`PRF_DATA_WIDTH{(agu_paddr[5 : 0] == 6'd12)}} & agu_dcache_dat[127 :  96])
                                            | ({`PRF_DATA_WIDTH{(agu_paddr[5 : 0] == 6'd13)}} & agu_dcache_dat[135 : 104])
                                            | ({`PRF_DATA_WIDTH{(agu_paddr[5 : 0] == 6'd14)}} & agu_dcache_dat[143 : 112])
                                            | ({`PRF_DATA_WIDTH{(agu_paddr[5 : 0] == 6'd15)}} & agu_dcache_dat[151 : 120])
                                            | ({`PRF_DATA_WIDTH{(agu_paddr[5 : 0] == 6'd16)}} & agu_dcache_dat[159 : 128])
                                            | ({`PRF_DATA_WIDTH{(agu_paddr[5 : 0] == 6'd17)}} & agu_dcache_dat[167 : 136])
                                            | ({`PRF_DATA_WIDTH{(agu_paddr[5 : 0] == 6'd18)}} & agu_dcache_dat[175 : 144])
                                            | ({`PRF_DATA_WIDTH{(agu_paddr[5 : 0] == 6'd19)}} & agu_dcache_dat[183 : 152])
                                            | ({`PRF_DATA_WIDTH{(agu_paddr[5 : 0] == 6'd20)}} & agu_dcache_dat[191 : 160])
                                            | ({`PRF_DATA_WIDTH{(agu_paddr[5 : 0] == 6'd21)}} & agu_dcache_dat[199 : 168])
                                            | ({`PRF_DATA_WIDTH{(agu_paddr[5 : 0] == 6'd22)}} & agu_dcache_dat[207 : 176])
                                            | ({`PRF_DATA_WIDTH{(agu_paddr[5 : 0] == 6'd23)}} & agu_dcache_dat[215 : 184])
                                            | ({`PRF_DATA_WIDTH{(agu_paddr[5 : 0] == 6'd24)}} & agu_dcache_dat[223 : 192])
                                            | ({`PRF_DATA_WIDTH{(agu_paddr[5 : 0] == 6'd25)}} & agu_dcache_dat[231 : 200])
                                            | ({`PRF_DATA_WIDTH{(agu_paddr[5 : 0] == 6'd26)}} & agu_dcache_dat[239 : 208])
                                            | ({`PRF_DATA_WIDTH{(agu_paddr[5 : 0] == 6'd27)}} & agu_dcache_dat[247 : 216])
                                            | ({`PRF_DATA_WIDTH{(agu_paddr[5 : 0] == 6'd28)}} & agu_dcache_dat[255 : 224])
                                            | ({`PRF_DATA_WIDTH{(agu_paddr[5 : 0] == 6'd29)}} & agu_dcache_dat[263 : 232])
                                            | ({`PRF_DATA_WIDTH{(agu_paddr[5 : 0] == 6'd30)}} & agu_dcache_dat[271 : 240])
                                            | ({`PRF_DATA_WIDTH{(agu_paddr[5 : 0] == 6'd31)}} & agu_dcache_dat[279 : 248])
                                            | ({`PRF_DATA_WIDTH{(agu_paddr[5 : 0] == 6'd32)}} & agu_dcache_dat[287 : 256])
                                            | ({`PRF_DATA_WIDTH{(agu_paddr[5 : 0] == 6'd33)}} & agu_dcache_dat[295 : 264])
                                            | ({`PRF_DATA_WIDTH{(agu_paddr[5 : 0] == 6'd34)}} & agu_dcache_dat[303 : 272])
                                            | ({`PRF_DATA_WIDTH{(agu_paddr[5 : 0] == 6'd35)}} & agu_dcache_dat[311 : 280])
                                            | ({`PRF_DATA_WIDTH{(agu_paddr[5 : 0] == 6'd36)}} & agu_dcache_dat[319 : 288])
                                            | ({`PRF_DATA_WIDTH{(agu_paddr[5 : 0] == 6'd37)}} & agu_dcache_dat[327 : 296])
                                            | ({`PRF_DATA_WIDTH{(agu_paddr[5 : 0] == 6'd38)}} & agu_dcache_dat[335 : 304])
                                            | ({`PRF_DATA_WIDTH{(agu_paddr[5 : 0] == 6'd39)}} & agu_dcache_dat[343 : 312])
                                            | ({`PRF_DATA_WIDTH{(agu_paddr[5 : 0] == 6'd40)}} & agu_dcache_dat[351 : 320])
                                            | ({`PRF_DATA_WIDTH{(agu_paddr[5 : 0] == 6'd41)}} & agu_dcache_dat[359 : 328])
                                            | ({`PRF_DATA_WIDTH{(agu_paddr[5 : 0] == 6'd42)}} & agu_dcache_dat[367 : 336])
                                            | ({`PRF_DATA_WIDTH{(agu_paddr[5 : 0] == 6'd43)}} & agu_dcache_dat[375 : 344])
                                            | ({`PRF_DATA_WIDTH{(agu_paddr[5 : 0] == 6'd44)}} & agu_dcache_dat[383 : 352])
                                            | ({`PRF_DATA_WIDTH{(agu_paddr[5 : 0] == 6'd45)}} & agu_dcache_dat[391 : 360])
                                            | ({`PRF_DATA_WIDTH{(agu_paddr[5 : 0] == 6'd46)}} & agu_dcache_dat[399 : 368])
                                            | ({`PRF_DATA_WIDTH{(agu_paddr[5 : 0] == 6'd47)}} & agu_dcache_dat[407 : 376])
                                            | ({`PRF_DATA_WIDTH{(agu_paddr[5 : 0] == 6'd48)}} & agu_dcache_dat[415 : 384])
                                            | ({`PRF_DATA_WIDTH{(agu_paddr[5 : 0] == 6'd49)}} & agu_dcache_dat[423 : 392])
                                            | ({`PRF_DATA_WIDTH{(agu_paddr[5 : 0] == 6'd50)}} & agu_dcache_dat[431 : 400])
                                            | ({`PRF_DATA_WIDTH{(agu_paddr[5 : 0] == 6'd51)}} & agu_dcache_dat[439 : 408])
                                            | ({`PRF_DATA_WIDTH{(agu_paddr[5 : 0] == 6'd52)}} & agu_dcache_dat[447 : 416])
                                            | ({`PRF_DATA_WIDTH{(agu_paddr[5 : 0] == 6'd53)}} & agu_dcache_dat[455 : 424])
                                            | ({`PRF_DATA_WIDTH{(agu_paddr[5 : 0] == 6'd54)}} & agu_dcache_dat[463 : 432])
                                            | ({`PRF_DATA_WIDTH{(agu_paddr[5 : 0] == 6'd55)}} & agu_dcache_dat[471 : 440])
                                            | ({`PRF_DATA_WIDTH{(agu_paddr[5 : 0] == 6'd56)}} & agu_dcache_dat[479 : 448])
                                            | ({`PRF_DATA_WIDTH{(agu_paddr[5 : 0] == 6'd57)}} & agu_dcache_dat[487 : 456])
                                            | ({`PRF_DATA_WIDTH{(agu_paddr[5 : 0] == 6'd58)}} & agu_dcache_dat[495 : 464])
                                            | ({`PRF_DATA_WIDTH{(agu_paddr[5 : 0] == 6'd59)}} & agu_dcache_dat[503 : 472])
                                            | ({`PRF_DATA_WIDTH{(agu_paddr[5 : 0] == 6'd60)}} & agu_dcache_dat[511 : 480])
                                            | ({`PRF_DATA_WIDTH{(agu_paddr[5 : 0] == 6'd61)}} & agu_dcache_dat[519 : 488])
                                            | ({`PRF_DATA_WIDTH{(agu_paddr[5 : 0] == 6'd62)}} & agu_dcache_dat[527 : 496])
                                            | ({`PRF_DATA_WIDTH{(agu_paddr[5 : 0] == 6'd63)}} & agu_dcache_dat[535 : 504]);

//  EXEC 3
wire agu_exec_3_wr_data_ena = (agu_sta_nxt == AGU_STATE_EXEC_3);
assign agu_exec_3_wr_data_nxt = ({`PRF_DATA_WIDTH{(agu_usign & (agu_size == 2'b00))   }} & {24'h0, agu_wr_data[7 : 0]}                 )
                              | ({`PRF_DATA_WIDTH{(agu_usign & (agu_size == 2'b01))   }} & {16'h0, agu_wr_data[15 : 0]}                )
                              | ({`PRF_DATA_WIDTH{(agu_size == 2'b10)                 }} & agu_wr_data[31 : 0]                         )
                              | ({`PRF_DATA_WIDTH{((~agu_usign) & (agu_size == 2'b00))}} & {{24{agu_wr_data[7]}}, agu_wr_data[7 : 0]}  )
                              | ({`PRF_DATA_WIDTH{((~agu_usign) & (agu_size == 2'b01))}} & {{16{agu_wr_data[15]}}, agu_wr_data[15 : 0]});


gnrl_dffl #( 
    .DATA_WIDTH(`PRF_DATA_WIDTH)
) agu_exec_3_wr_data_dffl (agu_exec_3_wr_data_ena, agu_exec_3_wr_data_nxt, o_exu_rsv_wr_dat, clk);


assign o_exu_rsv_wren = (agu_sta_is_exec_3 & agu_dst_vld);
assign o_exu_rsv_wr_prf_code = agu_dst_code;

assign o_exu_rsv_busy      = agu_vld;
assign o_exu_rob_vld       = (agu_sta_is_exec_3 | (agu_sta_is_exec_1 & agu_store));
assign o_exu_rob_rob_id    = ((agu_vld & agu_load) ? agu_rob_id : o_sbuff_ret_rob_id);
assign o_exu_rob_excp_code = i_mmu_dtlb_excp_code;


//
assign o_exu_dsp_s_ret = (o_sbuff_ret_vld & ((~o_dcache_dirty) | i_mmu_exu_done));
assign o_exu_rob_s_ret_done = o_exu_dsp_s_ret;
assign o_dtlb_mmu_vld = (i_dtlb_rden & (~o_dtlb_hit));
assign o_dtlb_mmu_vaddr = agu_vaddr;
assign o_exu_mem_rd_vld = (i_dcache_rden & (~o_dcache_hit));
assign o_exu_mem_rd_paddr = {agu_wr_paddr[33 : 6], 6'h0};
assign o_exu_mem_wr_vld = o_dcache_wb;
assign o_exu_mem_wr_paddr = o_dcache_wb_dat;
endmodule   //  exu_agu_module

`endif  /*  !__EXU_AGU_V__! */