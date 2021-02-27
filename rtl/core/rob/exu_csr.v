`ifdef __EXU_CSR_V__

module exu_csr_module (
    input                                               i_ext_csr_intr_vld,
    input   [`EXCEPTION_CODE_WIDTH - 1  : 0]            i_ext_csr_intr_code,
    input                                               i_sft_csr_intr_vld,
    input   [`EXCEPTION_CODE_WIDTH - 1  : 0]            i_sft_csr_intr_code,
    input                                               i_tmr_csr_intr_vld,
    input   [`EXCEPTION_CODE_WIDTH - 1  : 0]            i_tmr_csr_intr_code,
    input                                               i_rob_csr_vld,
    input                                               i_rob_csr_excp_vld,
    input   [`EXCEPTION_CODE_WIDTH - 1  : 0]            i_rob_csr_excp_code,
    input   [`INSTR_WIDTH - 1           : 0]            i_rob_csr_excp_instr,
    input                                               i_rob_csr_len,
    input   [`CORE_PC_WIDTH - 1         : 0]            i_rob_csr_addr,
    input                                               i_rob_csr_mret,
    input                                               i_rob_csr_sret,
    input                                               i_rob_csr_uret,
    input                                               i_rob_csr_wfi,
    input                                               i_rob_csr_sfvma_flush,
    input                                               i_exu_csr_wren,
    input   [`CSR_ADDR_WIDTH - 1        : 0]            i_exu_csr_addr,
    input   [`CSR_DATA_WIDTH - 1        : 0]            i_exu_csr_wdat,

    output  [`CSR_DATA_WIDTH - 1        : 0]            o_csr_exu_rdat,
    output                                              o_csr_trap_flush,
    output  [`CORE_PC_WIDTH - 1         : 0]            o_csr_trap_addr,
    output  [1                          : 0]            o_csr_rv_mode,
    output  [`CSR_SATP_WIDTH - 1        : 0]            o_csr_mmu_satp,
    output                                              o_csr_ext_intr_ack,

    input                                               clk,
    input                                               rst_n 
);

wire csr_sft_intr_enable = (i_sft_csr_intr_vld
                         & (((i_sft_csr_intr_code == `EXCEPTION_CODE_WIDTH'd3 ) & csr_mie_msie_r)
                         |  ((i_sft_csr_intr_code == `EXCEPTION_CODE_WIDTH'd1 ) & csr_mie_ssie_r)));
wire csr_tmr_intr_enable = (i_tmr_csr_intr_vld 
                         & (((i_tmr_csr_intr_code == `EXCEPTION_CODE_WIDTH'd7 ) & csr_mie_mtie_r)
                         |  ((i_tmr_csr_intr_code == `EXCEPTION_CODE_WIDTH'd5 ) & csr_mie_stie_r)));
wire csr_ext_intr_enable = (i_ext_csr_intr_vld
                         & (((i_ext_csr_intr_code == `EXCEPTION_CODE_WIDTH'd9 ) & csr_mie_meie_r) 
                         |  ((i_ext_csr_intr_code == `EXCEPTION_CODE_WIDTH'd11) & csr_mie_seie_r)));

wire csr_intrs = (csr_sft_intr_enable | csr_tmr_intr_enable | csr_ext_intr_enable);
wire csr_excps = i_rob_csr_excp_vld;
wire csr_traps = (csr_intrs | csr_excps);

wire csr_excp_brkp       = (i_rob_csr_excp_code == `EXCEPTION_CODE_WIDTH'd3);
wire csr_excp_misaligned = ((i_rob_csr_excp_code == `EXCEPTION_CODE_WIDTH'd0)
                         |  (i_rob_csr_excp_code == `EXCEPTION_CODE_WIDTH'd4)
                         |  (i_rob_csr_excp_code == `EXCEPTION_CODE_WIDTH'd6));
wire csr_excp_acc_fault  = ((i_rob_csr_excp_code == `EXCEPTION_CODE_WIDTH'd1)
                         |  (i_rob_csr_excp_code == `EXCEPTION_CODE_WIDTH'd5)
                         |  (i_rob_csr_excp_code == `EXCEPTION_CODE_WIDTH'd7));
wire csr_excp_page_fault = ((i_rob_csr_excp_code == `EXCEPTION_CODE_WIDTH'd12)
                         |  (i_rob_csr_excp_code == `EXCEPTION_CODE_WIDTH'd13)
                         |  (i_rob_csr_excp_code == `EXCEPTION_CODE_WIDTH'd15));
wire csr_excp_ilgl_instr = (i_rob_csr_excp_code == `EXCEPTION_CODE_WIDTH'd2); 


//  Control
localparam  CORE_MODE_WIDTH = 3;
localparam  CORE_MODE_M     = 3'b011,
            CORE_MODE_LM    = 3'b111,
            CORE_MODE_S     = 3'b001,
            CORE_MODE_LS    = 3'b101,
            CORE_MODE_U     = 3'b000,
            CORE_MODE_LU    = 3'b100;

wire [CORE_MODE_WIDTH - 1 : 0] core_mode_cur_r, core_mode_nxt;


wire core_mode_is_m    = (core_mode_cur_r == CORE_MODE_M );
wire core_mode_is_lm   = (core_mode_cur_r == CORE_MODE_LM);
wire core_mode_is_s    = (core_mode_cur_r == CORE_MODE_S );
wire core_mode_is_ls   = (core_mode_cur_r == CORE_MODE_LS);
wire core_mode_is_u    = (core_mode_cur_r == CORE_MODE_U );
wire core_mode_is_lu   = (core_mode_cur_r == CORE_MODE_LU);
wire core_mode_is_m_lm = (core_mode_is_m | core_mode_is_lm);
wire core_mode_is_s_ls = (core_mode_is_s | core_mode_is_ls);
wire core_mode_is_u_lu = (core_mode_is_u | core_mode_is_lu);

wire csr_delegate_traps = ((csr_medeleg_r[i_rob_csr_excp_code] & i_rob_csr_excp_vld)
                        |  (csr_mideleg_r[i_ext_csr_intr_code] & i_ext_csr_intr_vld)
                        |  (csr_mideleg_r[i_sft_csr_intr_code] & i_sft_csr_intr_vld)
                        |  (csr_mideleg_r[i_tmr_csr_intr_code] & i_tmr_csr_intr_vld));


wire core_mode_m2m  = ((csr_traps 
                    | (i_rob_csr_mret & (csr_mstatus_mpp_r == 2'b11)))
                    & core_mode_is_m);
wire core_mode_m2s  = ((i_rob_csr_mret
                    &  (csr_mstatus_mpp_r == 2'b01))
                    &  core_mode_is_m);
wire core_mode_m2u  = ((i_rob_csr_mret
                    &  (csr_mstatus_mpp_r == 2'b00))
                    &  core_mode_is_m);
wire core_mode_lm2m = (csr_intrs & core_mode_is_lm);
wire core_mode_s2m  = (csr_traps & core_mode_is_s);
wire core_mode_s2s  = (csr_delegate_traps & core_mode_is_s);
wire core_mode_s2u  = ((i_rob_csr_sret
                    &  (csr_mstatus_spp_r == 2'b00))
                    &  core_mode_is_s);
wire core_mode_ls2s = (csr_intrs & core_mode_is_ls);
wire core_mode_u2m  = (csr_traps & core_mode_is_u);
wire core_mode_u2s  = (csr_delegate_traps & core_mode_is_u);
wire core_mode_lu2u = (csr_intrs & core_mode_is_lu);

wire core_mode_enter_lm = (i_rob_csr_wfi & core_mode_is_m);
wire core_mode_enter_ls = (i_rob_csr_wfi & core_mode_is_s);
wire core_mode_enter_lu = (i_rob_csr_wfi & core_mode_is_u);
wire core_mode_enter_m  = (core_mode_m2m | core_mode_s2m | core_mode_u2m | core_mode_lm2m);
wire core_mode_enter_s  = (core_mode_m2s | core_mode_s2s | core_mode_u2s | core_mode_ls2s);
wire core_mode_enter_u  = (core_mode_m2u | core_mode_s2u | core_mode_lu2u);

wire core_mode_ena = (core_mode_enter_lm
                   |  core_mode_enter_ls
                   |  core_mode_enter_lu
                   |  core_mode_enter_m
                   |  core_mode_enter_s
                   |  core_mode_enter_u);

assign core_mode_nxt = ({CORE_MODE_WIDTH{core_mode_enter_lm}}   & CORE_MODE_LM)
                     | ({CORE_MODE_WIDTH{core_mode_enter_ls}}   & CORE_MODE_LS)
                     | ({CORE_MODE_WIDTH{core_mode_enter_lu}}   & CORE_MODE_LU)
                     | ({CORE_MODE_WIDTH{core_mode_enter_m }}   & CORE_MODE_M )
                     | ({CORE_MODE_WIDTH{core_mode_enter_s }}   & CORE_MODE_S )
                     | ({CORE_MODE_WIDTH{core_mode_enter_u }}   & CORE_MODE_U );

gnrl_dfflr #(
    .DATA_WIDTH   (CORE_MODE_WIDTH),
    .INITIAL_VALUE(CORE_MODE_M)
) core_mode_dfflr (core_mode_ena, core_mode_nxt, core_mode_cur_r, clk, rst_n);

//
wire csr_sel_mvendorid = (i_exu_csr_addr == `CSR_MVENDORID_ADDR);
wire [31 : 0] csr_mvendorid = 32'd0;

wire csr_sel_marchid = (i_exu_csr_addr == `CSR_MARCHID_ADDR);
wire [`CSR_MXLEN - 1 : 0] csr_marchid = `CSR_MXLEN'd0;

wire csr_sel_mimpid = (i_exu_csr_addr == `CSR_MIMPID_ADDR);
wire [`CSR_MXLEN - 1 : 0] csr_mimpid = `CSR_MXLEN'd0;

wire csr_sel_mhartid = (i_exu_csr_addr == `CSR_MHARTID_ADDR);
wire [`CSR_MXLEN - 1 : 0] csr_mhartid = `CSR_MXLEN'd0;

wire csr_sel_misa = (i_exu_csr_addr == `CSR_MISA_ADDR);
wire [`CSR_MXLEN - 1 : 0]  csr_misa = {           //  NAME    DESCRIBTION                         SUPPORT
                                            2'd1  //  MXL     MXLEN bits wide                     MXLEN == 32
                                        ,  36'b0  //  WLRL    Reserved                            False
                                        ,  1'b0   //  Z       Reserved                            False
                                        ,  1'b0   //  Y       Reserved                            False
                                        ,  1'b0   //  X       Non-standard extsions present       False
                                        ,  1'b0   //  W       Reserved                            False
                                        ,  1'b0   //  V       Vector extensions                   False
                                        ,  1'b1   //  U       User mode implemented               True
                                        ,  1'b0   //  T       Tentatively reserved                False
                                        ,  1'b1   //  S       Supervisor mode implemented         True
                                        ,  1'b0   //  R       Reserved                            False
                                        ,  1'b0   //  Q       Quad-precision                      False
                                        ,  1'b0   //  P       Tentatively reserved                False
                                        ,  1'b0   //  O       Reserved                            False
                                        ,  1'b1   //  N       User-Level interrupts supported     True
                                        ,  1'b1   //  M       Integer Multiply/Divide             True
                                        ,  1'b0   //  L       Tentatively reserved                False
                                        ,  1'b0   //  K       Reserved                            False
                                        ,  1'b0   //  J       Tentatively reserved                False
                                        ,  1'b1   //  I       RV32I/64I/128I                      True
                                        ,  1'b0   //  H       Hypervisor extention                False
                                        ,  1'b0   //  G       Reserved                            False
                                        ,  1'b1   //  F       Single-precision                    True
                                        ,  1'b0   //  E       RV32E                               False
                                        ,  1'b0   //  D       RV32D                               False
                                        ,  1'b1   //  C       Compressed extention                True
                                        ,  1'b0   //  B       Tentatively reserved                False
                                        ,  1'b0   //  A       Atomic extension                    False
                                        };
//
wire csr_sel_mstatus = (i_exu_csr_addr == `CSR_MSTATUS_ADDR);
wire csr_mstatus_wren = ((csr_sel_mstatus & i_exu_csr_wren) & core_mode_is_m_lm);


wire csr_mstatus_tsr_ena = csr_mstatus_wren;
wire csr_mstatus_tsr_r, csr_mstatus_tsr_nxt;

assign csr_mstatus_tsr_nxt = i_exu_csr_wdat[22];

gnrl_dfflr#(
    .DATA_WIDTH   (1),
    .INITIAL_VALUE(0)
) csr_mstatus_tsr_dfflr (csr_mstatus_tsr_ena, csr_mstatus_tsr_nxt, csr_mstatus_tsr_r, clk, rst_n);

wire csr_mstatus_tw_ena = csr_mstatus_wren;
wire csr_mstatus_tw_r, csr_mstatus_tw_nxt;

assign csr_mstatus_tw_nxt = i_exu_csr_wdat[21];

gnrl_dfflr #(
    .DATA_WIDTH   (1),
    .INITIAL_VALUE(0)
) csr_mstatus_tw_dfflr (csr_mstatus_tw_ena, csr_mstatus_tw_nxt, csr_mstatus_tw_r, clk, rst_n);

wire csr_mstatus_tvm_ena = csr_mstatus_wren;
wire csr_mstatus_tvm_r, csr_mstatus_tvm_nxt;

assign csr_mstatus_tvm_nxt = i_exu_csr_wdat[20];

gnrl_dfflr #(
    .DATA_WIDTH   (1),
    .INITIAL_VALUE(0)
) csr_mstatus_tvm_dfflr (csr_mstatus_tvm_ena, csr_mstatus_tvm_nxt, csr_mstatus_tvm_r, clk, rst_n);

wire csr_mstatus_mxr_ena = csr_mstatus_wren;
wire csr_mstatus_mxr_r, csr_mstatus_mxr_nxt;

assign csr_mstatus_mxr_nxt = i_exu_csr_wdat[19];

gnrl_dfflr #(
    .DATA_WIDTH   (1),
    .INITIAL_VALUE(0)
) csr_mstatus_mxr_dfflr (csr_mstatus_mxr_ena, csr_mstatus_mxr_nxt, csr_mstatus_mxr_r, clk, rst_n);

wire csr_mstatus_sum_ena = csr_mstatus_wren;
wire csr_mstatus_sum_r, csr_mstatus_sum_nxt;

assign csr_mstatus_sum_nxt = i_exu_csr_wdat[18];

gnrl_dfflr #(
    .DATA_WIDTH   (1),
    .INITIAL_VALUE(0)
) csr_mstatus_sum_dfflr (csr_mstatus_sum_ena, csr_mstatus_sum_nxt, csr_mstatus_sum_r, clk, rst_n);

wire csr_mstatus_mprv_ena = (csr_mstatus_wren | (i_rob_csr_mret & (csr_mstatus_mpp_r != 2'b11)) | i_rob_csr_sret);
wire csr_mstatus_mprv_r, csr_mstatus_mprv_nxt;

assign csr_mstatus_mprv_nxt = (i_rob_csr_mret | i_rob_csr_sret) ? 1'b0
                            : i_exu_csr_wdat[17];

gnrl_dfflr #(
    .DATA_WIDTH   (1),
    .INITIAL_VALUE(0)
) csr_mstatus_mprv_dfflr (csr_mstatus_mprv_ena, csr_mstatus_mprv_nxt, csr_mstatus_mprv_r, clk, rst_n);

wire [1 : 0] csr_mstatus_xs_r = 2'b00;
wire [1 : 0] csr_mstatus_fs_r = 2'b00;

wire csr_mstatus_mpp_ena = (csr_mstatus_wren | (csr_traps & (~csr_delegate_traps)));
wire [1 : 0] csr_mstatus_mpp_r, csr_mstatus_mpp_nxt;

assign csr_mstatus_mpp_nxt = csr_traps ? core_mode_cur_r [1 : 0]
                           : i_rob_csr_mret ? 2'b00 //  xPP is set to U
                           : i_exu_csr_wdat[12 : 11];

gnrl_dfflr #(
    .DATA_WIDTH   (2),
    .INITIAL_VALUE(3)
) csr_mstatus_mpp_dfflr (csr_mstatus_mpp_ena, csr_mstatus_mpp_nxt, csr_mstatus_mpp_r, clk, rst_n);

wire csr_mstatus_mie_ena = csr_mstatus_mpp_ena;
wire csr_mstatus_mie_r, csr_mstatus_mie_nxt;

assign csr_mstatus_mie_nxt = csr_traps ? 1'b0
                           : i_rob_csr_mret ? csr_mstatus_mpie_r
                           : i_exu_csr_wdat[3];

gnrl_dfflr #(
    .DATA_WIDTH   (1),
    .INITIAL_VALUE(0)
) csr_mstatus_mie_dfflr (csr_mstatus_mie_ena, csr_mstatus_mie_nxt, csr_mstatus_mie_r, clk, rst_n);

wire csr_mstatus_mpie_ena = csr_mstatus_mie_ena;
wire csr_mstatus_mpie_r, csr_mstatus_mpie_nxt;

assign csr_mstatus_mpie_nxt = csr_traps ? csr_mstatus_mie_r
                            : i_rob_csr_mret ? 1'b1
                            : i_exu_csr_wdat[7];

gnrl_dfflr #(
    .DATA_WIDTH   (1),
    .INITIAL_VALUE(0)
) csr_mstatus_mpie_dfflr (csr_mstatus_mpie_ena, csr_mstatus_mpie_nxt, csr_mstatus_mpie_r, clk, rst_n);


wire csr_mstatus_spp_ena = (csr_mstatus_wren | (csr_traps & csr_delegate_traps) | i_rob_csr_sret);
wire csr_mstatus_spp_r, csr_mstatus_spp_nxt;

assign csr_mstatus_spp_nxt = csr_traps ? core_mode_cur_r[0]
                           : i_rob_csr_sret ? 1'b0  //  xPP is set to U
                           : i_exu_csr_wdat[8];

gnrl_dfflr #(
    .DATA_WIDTH   (1),
    .INITIAL_VALUE(0)
) csr_mstatus_spp_dfflr (csr_mstatus_spp_ena, csr_mstatus_spp_nxt, csr_mstatus_spp_r, clk, rst_n);


wire csr_mstatus_sie_ena = csr_mstatus_spp_ena;
wire csr_mstatus_sie_r, csr_mstatus_sie_nxt;

assign csr_mstatus_sie_nxt = csr_traps ? 1'b0
                           : i_rob_csr_sret ? csr_mstatus_spie_r
                           : i_exu_csr_wdat[1];

gnrl_dfflr #(
    .DATA_WIDTH   (1),
    .INITIAL_VALUE(0)
) csr_mstatus_sie_dfflr (csr_mstatus_sie_ena, csr_mstatus_sie_nxt, csr_mstatus_sie_r, clk, rst_n);

wire csr_mstatus_spie_ena = csr_mstatus_sie_ena;
wire csr_mstatus_spie_r, csr_mstatus_spie_nxt;

assign csr_mstatus_spie_nxt = csr_traps ? csr_mstatus_sie_r
                            : i_rob_csr_sret ? 1'b1
                            : i_exu_csr_wdat[5];
gnrl_dfflr #(
    .DATA_WIDTH   (1),
    .INITIAL_VALUE(0)
) csr_mstatus_spie_dfflr (csr_mstatus_spie_ena, csr_mstatus_spie_nxt, csr_mstatus_spie_r, clk, rst_n);

wire [31 : 0] csr_mstatus = {
                                ((csr_mstatus_fs_r == 2'b11) | (csr_mstatus_xs_r == 2'b11))
                            ,   8'd0
                            ,   csr_mstatus_tsr_r
                            ,   csr_mstatus_tw_r
                            ,   csr_mstatus_tvm_r
                            ,   csr_mstatus_mxr_r
                            ,   csr_mstatus_sum_r
                            ,   csr_mstatus_mprv_r
                            ,   csr_mstatus_xs_r 
                            ,   csr_mstatus_fs_r 
                            ,   csr_mstatus_mpp_r
                            ,   2'b00
                            ,   csr_mstatus_spp_r
                            ,   csr_mstatus_mpie_r
                            ,   1'b0
                            ,   csr_mstatus_spie_r
                            ,   1'b0
                            ,   csr_mstatus_mie_r 
                            ,   1'b0
                            ,   csr_mstatus_sie_r 
                            ,   1'b0
                          };
//
wire csr_sel_mepc = (i_exu_csr_addr == `CSR_MEPC_ADDR);
wire csr_mepc_wren = ((csr_sel_mepc & i_exu_csr_wren) & core_mode_is_m_lm);

wire csr_mepc_ena = (csr_mepc_wren | (csr_traps & (~csr_delegate_traps)));
wire [`CSR_MXLEN - 1 : 0] csr_mepc_r, csr_mepc_nxt;

wire [`CORE_PC_WIDTH - 1 : 0] csr_mepc_nxt_addr = i_rob_csr_addr + (i_rob_csr_len ? `CORE_PC_WIDTH'd4 : `CORE_PC_WIDTH'd2);

assign csr_mepc_nxt = csr_excps ? {i_rob_csr_addr[`CORE_PC_WIDTH - 1 : 1], 1'b0}
                    : csr_intrs ? {csr_mepc_nxt_addr[`CORE_PC_WIDTH - 1 : 1], 1'b0}
                    : {i_exu_csr_wdat[`CORE_PC_WIDTH - 1 : 1], 1'b0};

gnrl_dfflr #(
    .DATA_WIDTH   (`CSR_MXLEN),
    .INITIAL_VALUE(0)
) csr_mepc_dfflr (csr_mepc_ena, csr_mepc_nxt, csr_mepc_r, clk, rst_n);

//
wire csr_sel_mtvec = (i_exu_csr_addr == `CSR_MTVEC_ADDR);
wire csr_mtvec_wren = ((csr_sel_mtvec & i_exu_csr_wren) & core_mode_is_m_lm);

wire csr_mtvec_ena = csr_mtvec_wren;
wire [`CSR_MXLEN - 1 : 0] csr_mtvec_r, csr_mtvec_nxt;


assign csr_mtvec_nxt = i_exu_csr_wdat[31 : 0];

gnrl_dfflr #(
    .DATA_WIDTH   (`CSR_MXLEN),
    .INITIAL_VALUE(0)
) csr_mtvec_dfflr (csr_mtvec_ena, csr_mtvec_nxt, csr_mtvec_r, clk, rst_n);

//
wire csr_sel_mtval = (i_exu_csr_addr == `CSR_MTVAL_ADDR);
wire csr_mtval_wren = ((csr_sel_mtval & i_exu_csr_wren) & core_mode_is_m_lm);

wire csr_mtval_ena = (csr_mtval_wren  | (csr_traps& (~csr_delegate_traps)));
wire [`CSR_MXLEN - 1 : 0] csr_mtval_r, csr_mtval_nxt;

wire csr_mtval_fault_addr = (csr_excp_brkp
                          |  csr_excp_misaligned
                          |  csr_excp_acc_fault
                          |  csr_excp_page_fault);
wire csr_mtval_instr = csr_excp_ilgl_instr;

wire csr_mtval_trap_val = csr_mtval_instr ? i_rob_csr_excp_instr
                        : csr_mtval_fault_addr ? i_rob_csr_addr
                        : `CSR_MXLEN'd0;

assign csr_mtval_nxt = csr_traps ? csr_mtval_trap_val
                     : i_exu_csr_wdat[31 : 0];

gnrl_dfflr #(
    .DATA_WIDTH   (`CSR_MXLEN),
    .INITIAL_VALUE(0)
) csr_mtval_dfflr (csr_mtval_ena, csr_mtval_nxt, csr_mtval_r, clk, rst_n);

//  
wire csr_sel_medeleg = (i_exu_csr_addr == `CSR_MEDELEG_ADDR);
wire csr_medeleg_wren = ((csr_sel_medeleg & i_exu_csr_wren) & core_mode_is_m_lm); 

wire csr_medeleg_ena = csr_medeleg_wren;
wire [`CSR_MXLEN - 1 : 0] csr_medeleg_r, csr_medeleg_nxt;

assign csr_medeleg_nxt = i_exu_csr_wdat[31 : 0];

gnrl_dfflr #(
    .DATA_WIDTH   (`CSR_MXLEN),
    .INITIAL_VALUE(0)
) csr_medeleg_dfflr (csr_medeleg_ena, csr_medeleg_nxt, csr_medeleg_r, clk, rst_n);

wire csr_sel_mideleg = (i_exu_csr_addr == `CSR_MIDELEG_ADDR);
wire csr_mideleg_wren = ((csr_sel_mideleg & i_exu_csr_wren) & core_mode_is_m_lm);

wire csr_mideleg_ena = csr_mideleg_wren;
wire [`CSR_MXLEN - 1 : 0] csr_mideleg_r, csr_mideleg_nxt;

assign csr_mideleg_nxt = i_exu_csr_wdat[31 : 0];

gnrl_dfflr #(
    .DATA_WIDTH   (`CSR_DATA_WIDTH),
    .INITIAL_VALUE(0)
) csr_mideleg_dfflr (csr_mideleg_ena, csr_mideleg_nxt, csr_mideleg_r, clk, rst_n);

//
wire csr_sel_mip = (i_exu_csr_addr == `CSR_MIP_ADDR);

wire csr_mip_meip_r, csr_mip_meip_nxt;

assign csr_mip_meip_nxt = (i_ext_csr_intr_vld & (i_ext_csr_intr_code == 'd11));

gnrl_dffr #(
    .DATA_WIDTH   (1),
    .INITIAL_VALUE(0)
) csr_mip_meip_dffr (csr_mip_meip_nxt, csr_mip_meip_r, clk, rst_n);

wire csr_mip_mtip_r, csr_mip_mtip_nxt;

assign csr_mip_mtip_nxt = (i_tmr_csr_intr_vld & (i_tmr_csr_intr_code == 'd7));

gnrl_dffr #(
    .DATA_WIDTH   (1),
    .INITIAL_VALUE(0)
) csr_mip_mtip_dffr (csr_mip_mtip_nxt, csr_mip_mtip_r, clk, rst_n);

wire csr_mip_msip_r, csr_mip_msip_nxt;

assign csr_mip_msip_nxt = (i_sft_csr_intr_vld & (i_sft_csr_intr_code == 'd3));

gnrl_dffr #(
    .DATA_WIDTH   (1),
    .INITIAL_VALUE(0)
) csr_mip_msip_dffr (csr_mip_msip_nxt, csr_mip_msip_r, clk, rst_n);


wire csr_mip_seip_r, csr_mip_seip_nxt;

assign csr_mip_seip_nxt = (i_ext_csr_intr_vld & (i_ext_csr_intr_code == 'd9));

gnrl_dffr #(
    .DATA_WIDTH   (1),
    .INITIAL_VALUE(0)
) csr_mip_seip_dffr (csr_mip_seip_nxt, csr_mip_seip_r, clk, rst_n);

wire csr_mip_stip_r, csr_mip_stip_nxt;

assign csr_mip_stip_nxt = (i_tmr_csr_intr_vld & (i_tmr_csr_intr_code == 'd5));

gnrl_dffr #(
    .DATA_WIDTH   (1),
    .INITIAL_VALUE(0)
) csr_mip_stip_dffr (csr_mip_stip_nxt, csr_mip_stip_r, clk, rst_n);

wire csr_mip_ssip_r, csr_miip_ssip_nxt;

assign csr_mip_ssip_nxt = (i_sft_csr_intr_vld & (i_sft_csr_intr_code == 'd1));

gnrl_dffr #(
    .DATA_WIDTH   (1),
    .INITIAL_VALUE(0)
) csr_mip_ssip_dffr (csr_mip_ssip_nxt, csr_mip_ssip_r, clk, rst_n);

wire [`CSR_MXLEN - 1 : 0] csr_mip = {
                                        16'd0
                                    ,   csr_mip_meip_r
                                    ,   1'b0
                                    ,   csr_mip_seip_r
                                    ,   1'b0
                                    ,   csr_mip_mtip_r 
                                    ,   1'b0 
                                    ,   csr_mip_stip_r
                                    ,   1'b0 
                                    ,   csr_mip_msip_r 
                                    ,   1'b0
                                    ,   csr_mip_ssip_r
                                    ,   1'b0
                                  };

//
wire csr_sel_mie = (i_exu_csr_addr == `CSR_MIE_ADDR);
wire csr_mie_wren = ((csr_sel_mie & i_exu_csr_wren) & core_mode_is_m_lm);

wire csr_mie_ena = csr_mie_wren;
wire csr_mie_meie_r, csr_mie_meie_nxt;

assign csr_mie_meie_nxt = i_exu_csr_wdat[11];

gnrl_dfflr #(
    .DATA_WIDTH   (1),
    .INITIAL_VALUE(0)
) csr_mie_meie_dfflr (csr_mie_ena, csr_mie_meie_nxt, csr_mie_meie_r, clk, rst_n);

wire csr_mie_mtie_r, csr_mie_mtie_nxt;

assign csr_mie_mtie_nxt = i_exu_csr_wdat[7];

gnrl_dfflr #(
    .DATA_WIDTH   (1),
    .INITIAL_VALUE(0)
) csr_mie_mtie_dfflr (csr_mie_ena, csr_mie_mtie_nxt, csr_mie_mtie_r, clk, rst_n);

wire csr_mie_msie_r, csr_mie_msie_nxt;

assign csr_mie_msie_nxt = i_exu_csr_wdat[3];

gnrl_dfflr #(
    .DATA_WIDTH   (1),
    .INITIAL_VALUE(0)
) csr_mie_msie_dfflr (csr_mie_ena, csr_mie_msie_nxt, csr_mie_msie_r, clk, rst_n);

wire csr_mie_seie_r, csr_mie_seie_nxt;

assign csr_mie_seie_nxt = i_exu_csr_wdat[9];

gnrl_dfflr #(
    .DATA_WIDTH   (1),
    .INITIAL_VALUE(0)
) csr_mie_seie_dfflr (csr_mie_ena, csr_mie_seie_nxt, csr_mie_seie_r, clk, rst_n);

wire csr_mie_stie_r, csr_mie_stie_nxt;

assign csr_mie_stie_nxt = i_exu_csr_wdat[5];

gnrl_dfflr #(
    .DATA_WIDTH   (1),
    .INITIAL_VALUE(0)
) csr_mie_stie_dfflr (csr_mie_ena, csr_mie_stie_nxt, csr_mie_stie_r, clk, rst_n);

wire csr_mie_ssie_r, csr_mie_ssie_nxt;

assign csr_mie_ssie_nxt = i_exu_csr_wdat[1];

gnrl_dfflr #(
    .DATA_WIDTH   (1),
    .INITIAL_VALUE(0)
) csr_mie_ssie_dfflr (csr_mie_ena, csr_mie_ssie_nxt, csr_mie_ssie_r, clk, rst_n);


wire [`CSR_MXLEN - 1 : 0] csr_mie = {
                                        16'd0
                                    ,   csr_mie_meie_r
                                    ,   1'b0
                                    ,   csr_mie_seie_r
                                    ,   1'b0
                                    ,   csr_mie_mtie_r 
                                    ,   1'b0 
                                    ,   csr_mie_stie_r
                                    ,   1'b0 
                                    ,   csr_mie_msie_r 
                                    ,   1'b0
                                    ,   csr_mie_ssie_r
                                    ,   1'b0
                                };
//
wire csr_sel_mcycle = (i_exu_csr_addr == `CSR_MCYCLE_ADDR);
wire csr_mcycle_wren = ((csr_sel_mcycle & i_exu_csr_wren) & core_mode_is_m_lm);

wire csr_mcycle_ena = ((~csr_mcountinhibit_r[0]) | csr_mcycle_wren);
wire [31 : 0] csr_mcycle_r, csr_mcycle_nxt;

assign csr_mcycle_nxt = csr_mcycle_wren ? i_exu_csr_wdat[31 : 0]
                      : csr_mcycle_r + 1'b1;

gnrl_dfflr #(
    .DATA_WIDTH   (32),
    .INITIAL_VALUE(0)
) csr_mcycle_dfflr (csr_mcycle_ena, csr_mcycle_nxt, csr_mcycle_r, clk, rst_n);

wire csr_sel_mcycleh = (i_exu_csr_addr == `CSR_MCYCLEH_ADDR);
wire csr_mcycleh_wren = ((csr_sel_mcycleh & i_exu_csr_wren) & core_mode_is_m_lm);

wire csr_mcycleh_ena = (((~csr_mcountinhibit_r[0]) & (csr_mcycle_r == (~32'd0))) | csr_mcycleh_wren);
wire [31 : 0] csr_mcycleh_r, csr_mcycleh_nxt;

assign csr_mcycleh_nxt = csr_mcycleh_wren ? i_exu_csr_wdat[31 : 0]
                       : csr_mcycleh_r + 1'b1;

gnrl_dfflr #(
    .DATA_WIDTH   (32),
    .INITIAL_VALUE(0)
) csr_mcycleh_dfflr (csr_mcycleh_ena, csr_mcycleh_nxt, csr_mcycleh_r, clk, rst_n);

wire csr_sel_minstret = (i_exu_csr_addr == `CSR_MINSTRET_ADDR);
wire csr_minstret_wren = ((csr_sel_minstret & i_exu_csr_wren) & core_mode_is_m_lm);

wire csr_minstret_ena = (csr_minstret_wren | (i_rob_csr_vld & (~csr_mcountinhibit_r[2])));
wire [31 : 0] csr_minstret_r, csr_minstret_nxt;

assign csr_minstret_nxt = csr_minstret_wren ? i_exu_csr_wdat[31 : 0]
                        : csr_minstret_r + 1'b1;

gnrl_dfflr #(
    .DATA_WIDTH   (32),
    .INITIAL_VALUE(0)
) csr_minstret_dfflr (csr_minstret_ena, csr_minstret_nxt, csr_minstret_r, clk, rst_n);


wire csr_sel_minstreth = (i_exu_csr_addr == `CSR_MINSTRETH_ADDR);
wire csr_minstreth_wren = ((csr_sel_minstreth & i_exu_csr_wren) & core_mode_is_m_lm);

wire csr_minstreth_ena = (csr_minstreth_wren | (i_rob_csr_vld & (csr_minstret_r == (~32'd0)) & (~csr_mcountinhibit_r[2])));
wire [31 : 0] csr_minstreth_r, csr_minstreth_nxt;

assign csr_minstreth_nxt = i_exu_csr_wren ? i_exu_csr_wdat[31 : 0]
                         : csr_minstreth_r + 1'b1;
gnrl_dfflr #(
    .DATA_WIDTH   (32),
    .INITIAL_VALUE(0)
) csr_minstreth_dfflr (csr_minstreth_ena, csr_minstreth_nxt, csr_minstreth_r, clk, rst_n);

//
wire csr_sel_mcounteren = (i_exu_csr_addr == `CSR_MCOUNTEREN_ADDR);
wire csr_mcounteren_wren = ((csr_sel_mcounteren & i_rob_csr_vld) & core_mode_is_m_lm);

wire csr_mcounteren_ena = csr_mcounteren_wren;
wire [31 : 0] csr_mcounteren_r, csr_mcounteren_nxt;

assign csr_mcounteren_nxt = i_exu_csr_wdat[31 : 0];

gnrl_dfflr #(
    .DATA_WIDTH   (32),
    .INITIAL_VALUE(0)
) csr_mcounteren_dfflr (csr_mcounteren_ena, csr_mcounteren_nxt, csr_mcounteren_r, clk, rst_n);

//
wire csr_sel_mcountinhibit = (i_exu_csr_addr == `CSR_MCOUNTINHIBIT_ADDR);
wire csr_mcountinhibit_wren = ((csr_sel_mcountinhibit & i_exu_csr_wren) & core_mode_is_m_lm);

wire [31 : 0] csr_mcountinhibit_r, csr_mcountinhibit_nxt;

assign csr_mcountinhibit_nxt = {
                                i_exu_csr_wdat[31 : 2]
                            ,   1'b0
                            ,   i_exu_csr_wdat[0]
                            };

gnrl_dfflr #(
    .DATA_WIDTH   (32),
    .INITIAL_VALUE(0)
) csr_mcountinhibit_dfflr (csr_mcountinhibit_ena, csr_mcountinhibit_nxt, csr_mcountinhibit_r, clk, rst_n);


//
wire csr_sel_mscratch = (i_exu_csr_addr == `CSR_MSCRATCH_ADDR);
wire csr_mscratch_wren = ((csr_sel_mscratch & i_exu_csr_wren) & core_mode_is_m_lm);

wire csr_mscratch_ena = csr_mscratch_wren;
wire [`CSR_MXLEN - 1 : 0] csr_mscratch_r, csr_mscratch_nxt;

assign csr_mscratch_nxt = i_exu_csr_wdat[31 : 0];

gnrl_dfflr #(
    .DATA_WIDTH   (`CSR_MXLEN),
    .INITIAL_VALUE(0)
) csr_mscratch_dffl (csr_mscratch_ena, csr_mscratch_nxt, csr_mscratch_r, clk, rst_n);

//
wire csr_sel_mcause = (i_exu_csr_addr == `CSR_MCAUSE_ADDR);
wire csr_mcause_wren = ((csr_sel_mcause & i_exu_csr_wren) & core_mode_is_m_lm);

wire [4 : 0] csr_mcause_excp_code = i_rob_csr_excp_code[4 : 0];
wire [4 : 0] csr_mcause_intr_code = i_sft_csr_intr_vld ? i_sft_csr_intr_code[4 : 0]
                                  : i_tmr_csr_intr_vld ? i_tmr_csr_intr_code[4 : 0]
                                  : i_ext_csr_intr_vld ? i_ext_csr_intr_code[4 : 0]
                                  : 5'd0;

wire csr_mcause_ena = (csr_mcause_wren | (csr_traps & (~csr_delegate_traps)));
wire [`CSR_MXLEN - 1 : 0] csr_mcause_r, csr_mcause_nxt;

assign csr_mcause_nxt = i_rob_csr_excp_vld ? {1'b0, 26'd0, csr_mcause_excp_code}
                      : {1'b1, 26'd0, csr_mcause_intr_code};

gnrl_dfflr #(
    .DATA_WIDTH   (`CSR_MXLEN),
    .INITIAL_VALUE(0)
) csr_mcause_dfflr (csr_mcause_ena, csr_mcause_nxt, csr_mcause_r, clk, rst_n);

//
wire core_mode_enter_s_ls = (core_mode_enter_s | core_mode_enter_ls);

wire csr_sel_sstatus = (i_exu_csr_addr == `CSR_SSTATUS_ADDR);
wire csr_sstatus_wren = ((csr_sel_sstatus & i_exu_csr_wren) & core_mode_is_s_ls);

wire csr_sstatus_mxr_ena = csr_sstatus_wren;
wire csr_sstauts_mxr_r, csr_sstatus_mxr_nxt;

assign csr_sstatus_mxr_nxt = i_exu_csr_wdat[19];

gnrl_dfflr #(
    .DATA_WIDTH   (1),
    .INITIAL_VALUE(0)
) csr_sstatus_mxr_dfflr (csr_sstatus_mxr_ena, csr_sstatus_mxr_nxt, csr_sstatus_mxr_r, clk, rst_n);

wire csr_sstatus_sum_ena = csr_sstatus_wren;
wire csr_sstatus_sum_r, csr_sstatus_sum_nxt;

assign csr_sstatus_sum_nxt = i_exu_csr_wdat[18];

gnrl_dfflr #(
    .DATA_WIDTH   (1),
    .INITIAL_VALUE(0)
) csr_sstatus_sum_dfflr (csr_sstatus_sum_ena, csr_sstatus_sum_nxt, csr_sstatus_sum_r, clk, rst_n);

wire csr_sstatus_xs_r = 2'b00;
wire csr_sstatus_fs_r = 2'b00;

wire csr_sstatus_spp_ena = (csr_sstatus_wren | core_mode_enter_s_ls);
wire csr_sstatus_spp_r, csr_status_spp_nxt;

assign csr_sstatus_spp_nxt = (core_mode_s2s | core_mode_ls2s) ? 1'b1
                           : (core_mode_u2s | i_rob_csr_sret) ? 1'b0
                           : i_exu_csr_wdat[8];
gnrl_dfflr #(
    .DATA_WIDTH   (1),
    .INITIAL_VALUE(0)
) csr_sstatus_spp_dfflr (csr_sstatus_spp_ena, csr_sstatus_spp_nxt, csr_sstatus_spp_r, clk, rst_n);

wire csr_sstatus_spie_ena = csr_sstatus_spp_ena;
wire csr_sstatus_spie_r, csr_sstatus_spie_nxt;

assign csr_sstatus_spie_nxt = csr_traps ? csr_sstatus_sie_r
                            : i_rob_csr_sret ? 1'b1
                            : i_exu_csr_wdat[5];

gnrl_dfflr #(
    .DATA_WIDTH   (1),
    .INITIAL_VALUE(0)
) csr_sstatus_spie_dfflr (csr_sstatus_spie_ena, csr_sstatus_spie_nxt, csr_sstatus_spie_r, clk, rst_n);

wire csr_sstatus_sie_ena = csr_sstatus_spie_ena;
wire csr_sstatus_sie_r, csr_status_sie_nxt;

assign csr_sstatus_sie_nxt = csr_traps ? 1'b0
                           : i_rob_csr_sret ? csr_sstatus_spie_r
                           : i_exu_csr_wdat[1];

gnrl_dfflr #(
    .DATA_WIDTH   (1),
    .INITIAL_VALUE(0)
) csr_sstatus_sie_dfflr (csr_sstatus_sie_ena, csr_sstatus_sie_nxt, csr_sstatus_sie_r, clk, rst_n);

wire [`CSR_SXLEN - 1 : 0] csr_sstatus = {
                                            ((csr_sstatus_xs_r == 2'b11) | (csr_sstatus_fs_r == 2'b11))
                                        ,   11'b0
                                        ,   csr_sstatus_mxr_r
                                        ,   csr_sstatus_sum_r
                                        ,   1'b0
                                        ,   csr_sstatus_xs_r
                                        ,   csr_sstatus_fs_r
                                        ,   4'b0
                                        ,   csr_sstatus_spp_r
                                        ,   1'b0
                                        ,   1'b0
                                        ,   csr_sstatus_spie_r
                                        ,   3'b0
                                        ,   csr_sstatus_sie_r 
                                        ,   1'b0     
                                      };
//
wire csr_sel_sepc = (i_exu_csr_addr == `CSR_SEPC_ADDR);
wire csr_sepc_wren = ((csr_sel_sepc & i_exu_csr_wren) & core_mode_is_s_ls);

wire csr_sepc_ena = (csr_sepc_wren | (csr_traps & core_mode_enter_s_ls));
wire [`CSR_SXLEN - 1 : 0] csr_sepc_r, csr_sepc_nxt;

assign csr_sepc_nxt = csr_mepc_nxt;

gnrl_dfflr #(
    .DATA_WIDTH   (`CSR_SXLEN),
    .INITIAL_VALUE(0)
) csr_sepc_dfflr (csr_sepc_ena, csr_sepc_nxt, csr_sepc_r, clk, rst_n);

//
wire csr_sel_scause = (i_exu_csr_addr == `CSR_SCAUSE_ADDR);
wire csr_scause_wren = ((csr_sel_scause & i_exu_csr_wren) & core_mode_is_s_ls);

wire csr_scause_ena = (csr_scause_wren | (csr_traps & core_mode_enter_s_ls));
wire [`CSR_SXLEN - 1 : 0] csr_scause_r, csr_scause_nxt;

assign csr_scause_nxt = csr_mcause_nxt;
gnrl_dfflr #(
    .DATA_WIDTH   (`CSR_SXLEN),
    .INITIAL_VALUE(0)
) csr_scause_dfflr (csr_scause_ena, csr_scause_nxt, csr_scause_r, clk, rst_n);

//
wire csr_sel_stvec = (i_exu_csr_addr == `CSR_STVEC_ADDR);
wire csr_stvec_wren = ((csr_sel_stvec & i_exu_csr_wren) & core_mode_is_s_ls);

wire csr_stvec_ena = csr_stvec_wren;
wire [`CSR_SXLEN - 1 : 0] csr_stvec_r, csr_stvec_nxt;

assign csr_stvec_nxt = i_exu_csr_wdat[31 : 0];

gnrl_dfflr #(
    .DATA_WIDTH   (`CSR_SXLEN),
    .INITIAL_VALUE(0)
) csr_stvec_dfflr (csr_stvec_ena, csr_stvec_nxt, csr_stvec_r, clk, rst_n);

//
wire csr_sel_sip = (i_exu_csr_addr == `CSR_SIP_ADDR);

wire csr_sip_seip_r, csr_sip_seip_nxt;
assign csr_sip_seip_nxt = (i_ext_csr_intr_vld & (i_ext_csr_intr_code == 'd11));

gnrl_dffr #(
    .DATA_WIDTH   (1),
    .INITIAL_VALUE(0)
) csr_sip_seip_dffr (csr_sip_seip_nxt, csr_sip_seip_r, clk, rst_n);

wire csr_sip_stip_r, csr_sip_stip_nxt;
assign csr_sip_stip_nxt = (i_tmr_csr_intr_vld & (i_tmr_csr_intr_code == 'd5));

gnrl_dffr #(
    .DATA_WIDTH   (1),
    .INITIAL_VALUE(0) 
) csr_sip_stip_dffr (csr_sip_stip_nxt, csr_sip_stip_r, clk, rst_n);

wire csr_sip_ssip_r, csr_sip_ssip_nxt;
assign csr_sip_ssip_nxt = (i_sft_csr_intr_vld & (i_sft_csr_intr_code == 'd1));

gnrl_dffr #(
    .DATA_WIDTH   (1),
    .INITIAL_VALUE(0)
) csr_sip_ssip_dffr (csr_sip_ssip_nxt,csr_sip_ssip_r, clk, rst_n);

wire [31: 0] csr_sip = {
                        16'd0
                    ,   6'd0
                    ,   csr_sip_seip_r
                    ,   3'd0
                    ,   csr_sip_stip_r
                    ,   3'd0
                    ,   csr_sip_ssip_r
                    ,   1'b0
                    };

wire csr_sel_sie = (i_exu_csr_addr == `CSR_SIE_ADDR);

wire csr_sie_ena = ((csr_sel_sie & i_exu_csr_wren) | core_mode_is_s_ls);

wire csr_sie_seie_r, csr_sie_seie_nxt;
assign csr_sie_seie_nxt = i_exu_csr_wdat[9];

gnrl_dfflr #(
    .DATA_WIDTH   (1),
    .INITIAL_VALUE(0)
) csr_sie_seie_dfflr (csr_sie_ena, csr_sie_seie_nxt, csr_sie_seie_r, clk, rst_n);

wire csr_sie_stie_r, csr_sie_stie_nxt;
assign csr_sie_stie_nxt = i_exu_csr_wdat[5];

gnrl_dfflr #(
    .DATA_WIDTH   (1),
    .INITIAL_VALUE(0)
) csr_sie_stie_dfflr (csr_sie_ena, csr_sie_stie_nxt, csr_sie_stie_r, clk, rst_n);

wire csr_sie_ssie_r, csr_sie_ssie_nxt;
assign csr_sie_ssie_nxt = i_exu_csr_wdat[1];

gnrl_dfflr #(
    .DATA_WIDTH   (1),
    .INITIAL_VALUE(0)
) csr_sie_ssie_dfflr (csr_sie_ena, csr_sie_ssie_nxt, csr_sie_ssie_r, clk, rst_n);

wire [31: 0] csr_sie = {
                        16'd0
                    ,   6'd0
                    ,   csr_sie_seie_r
                    ,   3'd0
                    ,   csr_sie_stie_r
                    ,   3'd0
                    ,   csr_sie_ssie_r
                    ,   1'b0
                    };
//
wire csr_sel_sscratch = (i_exu_csr_addr == `CSR_SSCRATCH_ADDR);
wire csr_sscratch_wren = ((csr_sel_sscratch & i_exu_csr_wren) & core_mode_is_s_ls);

wire csr_sscratch_ena = csr_sscratch_wren;
wire [`CSR_SXLEN - 1 : 0] csr_sscratch_r, csr_sscratch_nxt;

assign csr_sscratch_nxt = i_exu_csr_wdat[31 : 0];

gnrl_dfflr #(
    .DATA_WIDTH   (`CSR_SXLEN),
    .INITIAL_VALUE(0)
) csr_sscratch_dfflr (csr_sscratch_ena, csr_sscratch_nxt, csr_sscratch_r, clk, rst_n);

//
wire csr_sel_stval = (i_exu_csr_addr == `CSR_STVAL_ADDR);
wire csr_stval_wren = ((csr_sel_stval & i_exu_csr_wren) & core_mode_is_s_ls);

wire csr_stval_ena = (csr_stval_wren | (csr_traps & core_mode_enter_s_ls));
wire [`CSR_SXLEN - 1 : 0] csr_stval_r, csr_stval_nxt;

assign csr_stval_nxt = csr_mtval_nxt;

gnrl_dfflr #(
    .DATA_WIDTH   (`CSR_SXLEN),
    .INITIAL_VALUE(0)
) csr_stval_dfflr (csr_stval_ena, csr_stval_nxt, csr_stval_r, clk, rst_n);

//
wire csr_sel_satp = (i_exu_csr_addr == `CSR_SATP_ADDR);
wire csr_satp_wren = ((csr_sel_satp & i_exu_csr_wren) & core_mode_is_s_ls);

wire csr_satp_ena = csr_satp_wren;
wire [31 : 0] csr_satp_r, csr_satp_nxt;

assign csr_satp_nxt = i_exu_csr_wdat[31 : 0];

gnrl_dfflr #(
    .DATA_WIDTH   (32),
    .INITIAL_VALUE(0)
) csr_satp_dfflr (csr_satp_ena, csr_satp_nxt, csr_satp_r, clk, rst_n);
//

wire csr_sel_scounteren = (i_exu_csr_addr == `CSR_SCOUNTEREN_ADDR);
wire csr_scounteren_wren = ((csr_sel_scounteren & i_exu_csr_wren) & core_mode_is_s_ls);

wire csr_scounteren_ena = csr_scounteren_wren;
wire [31 : 0] csr_scounteren_r, csr_scounteren_nxt;

assign csr_scounteren_nxt = i_exu_csr_wdat[31 : 0];

gnrl_dfflr #(
    .DATA_WIDTH   (32),
    .INITIAL_VALUE(7)
) csr_scounteren_dfflr (csr_scounteren_ena, csr_scounteren_nxt, csr_scounteren_r, clk, rst_n);
//

wire csr_sel_ustatus = (i_exu_csr_addr == `CSR_USTATUS_ADDR);
wire core_mode_enter_u_lu = (core_mode_enter_u | core_mode_enter_lu);
wire csr_ustatus_wren = ((csr_sel_ustatus & i_exu_csr_wren) & core_mode_is_u_lu);

wire csr_ustatus_upie_ena = (csr_ustatus_wren | (csr_traps & core_mode_enter_u_lu));
wire csr_ustatus_upie_r, csr_ustatus_upie_nxt;

assign csr_ustatus_upie_nxt = csr_traps ? csr_ustatus_uie_r 
                            : i_rob_csr_uret ? 1'b1
                            : i_exu_csr_wdat[4];

gnrl_dfflr #(
    .DATA_WIDTH   (1),
    .INITIAL_VALUE(0)
) csr_ustatus_upie_dfflr (csr_ustatus_upie_ena, csr_ustatus_upie_nxt, csr_ustatus_upie_r, clk, rst_n);


wire csr_ustatus_uie_ena = csr_ustatus_upie_ena;
wire csr_ustatus_uie_r, csr_ustatus_uie_nxt;

assign csr_ustatus_uie_nxt = csr_traps ? 1'b0 
                           : i_rob_csr_uret ? 1'b1
                           : i_exu_csr_wdat[0];

gnrl_dfflr #(
    .DATA_WIDTH   (1),
    .INITIAL_VALUE(0)
) csr_ustatus_uie_dfflr (csr_ustatus_uie_ena, csr_ustatus_uie_nxt, csr_ustatus_uie_r, clk, rst_n);

wire [`CSR_UXLEN - 1 : 0] csr_ustatus = {
                                            27'd0
                                        ,   csr_ustatus_upie_r
                                        ,   3'd0
                                        ,   csr_ustatus_uie_r
                                      };
//

wire csr_sel_uip = (i_exu_csr_addr == `CSR_UIP_ADDR);

wire csr_uip_ueip_r, csr_uip_ueip_nxt;

assign csr_uip_ueip_nxt = (i_ext_csr_intr_vld & (i_ext_csr_intr_code == `EXCEPTION_CODE_WIDTH'd9));

gnrl_dffr #(
    .DATA_WIDTH   (1),
    .INITIAL_VALUE(0)
) csr_uip_ueip_dffr (csr_uip_ueip_nxt, csr_uip_ueip_r, clk, rst_n);


wire csr_uip_utip_r, csr_uip_utip_nxt;

assign csr_uip_utip_nxt = (i_tmr_csr_intr_vld & (i_tmr_csr_intr_code == `EXCEPTION_CODE_WIDTH'd5));

gnrl_dffr #(
    .DATA_WIDTH   (1),
    .INITIAL_VALUE(0)
) csr_uip_utip_dffr (csr_uip_utip_nxt, csr_uip_utip_r, clk, rst_n);

wire csr_uip_usip_r, csr_uip_usip_nxt;

assign csr_uip_usip_nxt = (i_sft_csr_intr_vld & (i_sft_csr_intr_code == `EXCEPTION_CODE_WIDTH'd1));

gnrl_dffr #(
    .DATA_WIDTH   (1),
    .INITIAL_VALUE(0)
) csr_uip_usip_dffr (csr_uip_usip_nxt, csr_uip_usip_r, clk, rst_n);


wire [`CSR_UXLEN - 1 : 0] csr_uip = {
                                        23'd0
                                    ,   csr_uip_ueip_r
                                    ,   3'd0
                                    ,   csr_uip_utip_r
                                    ,   3'd0
                                    ,   csr_uip_usip_r
                                  };

wire csr_sel_uie = (i_exu_csr_addr == `CSR_UIE_ADDR);
wire csr_uie_wren = ((csr_sel_uie & i_exu_csr_wren) & core_mode_is_u_lu);

wire csr_uie_ena = csr_uie_wren;
wire csr_uie_ueie_r, csr_uie_ueie_nxt;

assign csr_uie_ueie_nxt = i_exu_csr_wdat[8];

gnrl_dfflr #(
    .DATA_WIDTH   (1),
    .INITIAL_VALUE(0)
) csr_uie_ueie_dfflr (csr_uie_ena, csr_uie_ueie_nxt, csr_uie_ueie_r, clk, rst_n);

wire csr_uie_utie_r, csr_uie_utie_nxt;

assign csr_uie_utie_nxt = i_exu_csr_wdat[4];

gnrl_dfflr #(
    .DATA_WIDTH   (1),
    .INITIAL_VALUE(0)
) csr_uie_utie_dfflr (csr_uie_ena, csr_uie_utie_nxt, csr_uie_utie_r, clk, rst_n);

wire csr_uie_usie_r, csr_uie_usie_nxt;

assign csr_uie_usie_nxt = i_exu_csr_wdat[0];

gnrl_dfflr #(
    .DATA_WIDTH   (1),
    .INITIAL_VALUE(0)
) csr_uie_usie_dfflr (csr_uie_ena, csr_uie_usie_nxt, csr_uie_usie_r, clk, rst_n);

wire [`CSR_UXLEN - 1 : 0] csr_uie = {
                                        23'd0
                                    ,   csr_uie_ueie_r
                                    ,   3'd0
                                    ,   csr_uie_utie_r
                                    ,   3'd0
                                    ,   csr_uie_usie_r
                                   };
//

wire csr_sel_uscratch = (i_exu_csr_addr == `CSR_USCRATCH_ADDR);
wire csr_uscratch_wren = ((csr_sel_uscratch & i_exu_csr_wren) & core_mode_is_u_lu);

wire csr_uscratch_ena = csr_uscratch_wren;
wire [`CSR_UXLEN - 1 : 0] csr_uscratch_r, csr_uscratch_nxt;

assign csr_uscratch_nxt = i_exu_csr_wdat[31 : 0];

gnrl_dfflr #(
    .DATA_WIDTH   (`CSR_UXLEN),
    .INITIAL_VALUE(0)
) csr_uscratch_dfflr (csr_uscratch_ena, csr_uscratch_nxt, csr_uscratch_r, clk, rst_n);

//
wire csr_sel_uepc = (i_exu_csr_addr == `CSR_UEPC_ADDR);
wire csr_uepc_wren = ((csr_sel_uepc & i_exu_csr_wren) & core_mode_is_u_lu);

wire csr_uepc_ena = (csr_uepc_wren | (csr_traps & core_mode_enter_u_lu));
wire [`CSR_UXLEN - 1 : 0] csr_uepc_r, csr_uepc_nxt;

assign csr_uepc_nxt = csr_sepc_nxt;

gnrl_dfflr #(
    .DATA_WIDTH   (`CSR_UXLEN),
    .INITIAL_VALUE(0)
) csr_uepc_dfflr (csr_uepc_ena, csr_uepc_nxt, csr_uepc_r, clk, rst_n);

//
wire csr_sel_ucause = (i_exu_csr_addr == `CSR_UCAUSE_ADDR);
wire csr_ucause_wren = ((csr_sel_ucause & i_exu_csr_wren) & core_mode_is_u_lu);

wire csr_ucause_ena = (csr_ucause_wren | (csr_traps & core_mode_enter_u_lu));
wire [`CSR_UXLEN - 1 : 0] csr_ucause_r, csr_ucause_nxt;

assign csr_ucause_nxt = csr_scause_nxt;
gnrl_dfflr #(
    .DATA_WIDTH   (`CSR_UXLEN),
    .INITIAL_VALUE(0)
) csr_ucause_dfflr (csr_ucause_ena, csr_ucause_nxt, csr_ucause_r, clk, rst_n);

//
wire csr_sel_utval = (i_exu_csr_addr == `CSR_UTVAL_ADDR);
wire csr_utval_wren = ((csr_sel_utval & i_exu_csr_wren) & core_mode_is_u_lu);

wire csr_utval_ena = (csr_utval_wren | (csr_traps & core_mode_enter_u_lu));
wire [`CSR_UXLEN - 1 : 0] csr_utval_r, csr_utval_nxt;

assign csr_utval_nxt = csr_stval_nxt;

gnrl_dfflr #(
    .DATA_WIDTH   (`CSR_UXLEN),
    .INITIAL_VALUE(0)
) csr_utval_dfflr (csr_utval_ena, csr_utval_nxt, csr_utval_r, clk, rst_n);

//
wire csr_sel_utvec = (i_exu_csr_addr == `CSR_UTVEC_ADDR);
wire csr_utvec_wren = ((csr_sel_utvec & i_exu_csr_wren) & core_mode_is_u_lu);

wire csr_utvec_ena = csr_utvec_wren;
wire [`CSR_UXLEN - 1 : 0] csr_utvec_r, csr_utvec_nxt;

assign csr_utvec_nxt = i_exu_csr_wdat[31 : 0];

gnrl_dfflr #(
    .DATA_WIDTH   (`CSR_UXLEN),
    .INITIAL_VALUE(0)
) csr_utvec_dfflr (csr_utvec_ena, csr_utvec_nxt, csr_utvec_r, clk, rst_n);
//


assign o_csr_exu_rdat = ({`CSR_DATA_WIDTH{csr_sel_mvendorid     }}      & csr_mvendorid      )
                      | ({`CSR_DATA_WIDTH{csr_sel_marchid       }}      & csr_marchid        )
                      | ({`CSR_DATA_WIDTH{csr_sel_mimpid        }}      & csr_mimpid         )
                      | ({`CSR_DATA_WIDTH{csr_sel_mhartid       }}      & csr_mhartid        )
                      | ({`CSR_DATA_WIDTH{csr_sel_misa          }}      & csr_misa           )
                      | ({`CSR_DATA_WIDTH{csr_sel_mstatus       }}      & csr_mstatus        )
                      | ({`CSR_DATA_WIDTH{csr_sel_mepc          }}      & csr_mepc_r         )
                      | ({`CSR_DATA_WIDTH{csr_sel_mtvec         }}      & csr_mtvec_r        )
                      | ({`CSR_DATA_WIDTH{csr_sel_mtval         }}      & csr_mtval_r        )
                      | ({`CSR_DATA_WIDTH{csr_sel_medeleg       }}      & csr_medeleg_r      )
                      | ({`CSR_DATA_WIDTH{csr_sel_mideleg       }}      & csr_mideleg_r      )
                      | ({`CSR_DATA_WIDTH{csr_sel_mip           }}      & csr_mip            )
                      | ({`CSR_DATA_WIDTH{csr_sel_mie           }}      & csr_mie            )
                      | ({`CSR_DATA_WIDTH{csr_sel_mcycle        }}      & csr_mcycle_r       )
                      | ({`CSR_DATA_WIDTH{csr_sel_mcycleh       }}      & csr_mcycleh_r      )
                      | ({`CSR_DATA_WIDTH{csr_sel_minstret      }}      & csr_minstret_r     )
                      | ({`CSR_DATA_WIDTH{csr_sel_minstreth     }}      & csr_minstreth_r    )
                      | ({`CSR_DATA_WIDTH{csr_sel_mcounteren    }}      & csr_mcounteren_r   )
                      | ({`CSR_DATA_WIDTH{csr_sel_mcountinhibit }}      & csr_mcountinhibit_r)
                      | ({`CSR_DATA_WIDTH{csr_sel_mscratch      }}      & csr_mscratch_r     )
                      | ({`CSR_DATA_WIDTH{csr_sel_mcause        }}      & csr_mcause_r       )
                      | ({`CSR_DATA_WIDTH{csr_sel_sstatus       }}      & csr_sstatus        )
                      | ({`CSR_DATA_WIDTH{csr_sel_sepc          }}      & csr_sepc_r         )
                      | ({`CSR_DATA_WIDTH{csr_sel_scause        }}      & csr_scause_r       )
                      | ({`CSR_DATA_WIDTH{csr_sel_stvec         }}      & csr_stvec_r        )
                      | ({`CSR_DATA_WIDTH{csr_sel_sip           }}      & csr_sip            )
                      | ({`CSR_DATA_WIDTH{csr_sel_sie           }}      & csr_sie            )
                      | ({`CSR_DATA_WIDTH{csr_sel_sscratch      }}      & csr_sscratch_r     )
                      | ({`CSR_DATA_WIDTH{csr_sel_stval         }}      & csr_stval_r        )
                      | ({`CSR_DATA_WIDTH{csr_sel_satp          }}      & csr_satp_r         )
                      | ({`CSR_DATA_WIDTH{csr_sel_scounteren    }}      & csr_scounteren_r   )
                      | ({`CSR_DATA_WIDTH{csr_sel_ustatus       }}      & csr_ustatus        )
                      | ({`CSR_DATA_WIDTH{csr_sel_uip           }}      & csr_uip            )
                      | ({`CSR_DATA_WIDTH{csr_sel_uie           }}      & csr_uie            )
                      | ({`CSR_DATA_WIDTH{csr_sel_uscratch      }}      & csr_uscratch_r     )
                      | ({`CSR_DATA_WIDTH{csr_sel_uepc          }}      & csr_uepc_r         )
                      | ({`CSR_DATA_WIDTH{csr_sel_ucause        }}      & csr_ucause_r       )
                      | ({`CSR_DATA_WIDTH{csr_sel_utval         }}      & csr_utval_r        )
                      | ({`CSR_DATA_WIDTH{csr_sel_utvec         }}      & csr_utvec_r        );


wire [`CORE_PC_WIDTH - 1 : 0] csr_trap_addr_m = ({`CORE_PC_WIDTH{(csr_mtvec_r[1 : 0] == 2'b00)               }} & csr_mtvec_r                                                         )
                                              | ({`CORE_PC_WIDTH{(csr_mtvec_r[1 : 0] == 2'b01) & (~csr_intrs)}} & {csr_mtvec_r[31 : 2], 2'b00}                                        )
                                              | ({`CORE_PC_WIDTH{(csr_mtvec_r[1 : 0] == 2'b01) & csr_intrs   }} & ({csr_mtvec_r[31 : 2], 2'b00} + {24'd0, csr_mcause_r[5 : 0], 2'b00}));
wire [`CORE_PC_WIDTH - 1 : 0] csr_trap_addr_s = ({`CORE_PC_WIDTH{(csr_stvec_r[1 : 0] == 2'b00)               }} & csr_stvec_r                                                         )
                                              | ({`CORE_PC_WIDTH{(csr_stvec_r[1 : 0] == 2'b01) & (~csr_intrs)}} & {csr_stvec_r[31 : 2], 2'b00}                                        )
                                              | ({`CORE_PC_WIDTH{(csr_stvec_r[1 : 0] == 2'b01) & csr_intrs   }} & ({csr_stvec_r[31 : 2], 2'b00} + {24'd0, csr_scause_r[5 : 0], 2'b00}));
wire [`CORE_PC_WIDTH - 1 : 0] csr_trap_addr = csr_delegate_traps ? csr_trap_addr_s
                                            : csr_trap_addr_m;
wire csr_trap_flush = csr_traps;

wire csr_trap_ret_flush = (i_rob_csr_mret | i_rob_csr_sret | i_rob_csr_uret);
wire [`CORE_PC_WIDTH - 1 : 0] csr_trap_ret_addr = ({`CORE_PC_WIDTH{core_mode_is_m_lm}}       & csr_mepc_r)
                                                | ({`CORE_PC_WIDTH{core_mode_is_s_ls}}       & csr_sepc_r);

wire csr_modify_flush = ((
                            (csr_sel_ustatus & (i_exu_csr_wdat != csr_ustatus))
                        |   (csr_sel_utvec   & (i_exu_csr_wdat != csr_utvec_r))
                        |   (csr_sel_uepc    & (i_exu_csr_wdat != csr_uepc_r ))
                        |   (csr_sel_sstatus & (i_exu_csr_wdat != csr_sstatus))
                        |   (csr_sel_stvec   & (i_exu_csr_wdat != csr_stvec_r))
                        |   (csr_sel_sepc    & (i_exu_csr_wdat != csr_sepc_r ))
                        |   (csr_sel_satp    & (i_exu_csr_wdat != csr_satp_r ))
                        |   (csr_sel_mstatus & (i_exu_csr_wdat != csr_mstatus))
                        |   (csr_sel_mtvec   & (i_exu_csr_wdat != csr_mtvec_r))
                        |   (csr_sel_mepc    & (i_exu_csr_wdat != csr_mepc_r ))
                        ) & i_exu_csr_wren);
wire [`CORE_PC_WIDTH - 1 : 0] csr_modify_addr = csr_mepc_nxt_addr;

assign o_csr_trap_flush = (csr_trap_flush
                        |  csr_trap_ret_flush
                        |  csr_modify_flush
                        |  i_rob_csr_sfvma_flush);
assign o_csr_trap_addr  = ({`CORE_PC_WIDTH{csr_trap_flush                                                }} & csr_trap_addr    )
                        | ({`CORE_PC_WIDTH{(~csr_trap_flush) & csr_trap_ret_flush                        }} & csr_trap_ret_addr)
                        | ({`CORE_PC_WIDTH{(~csr_trap_flush) & (csr_modify_flush | i_rob_csr_sfvma_flush)}} & csr_modify_addr  );

assign o_csr_rv_mode = core_mode_cur_r[1 : 0];
assign o_csr_mmu_satp = csr_satp_r;

assign o_csr_ext_intr_ack = csr_trap_ret_flush;

endmodule   //  exu_csr_module

`endif  /*  !__EXU_CSR_V__! */