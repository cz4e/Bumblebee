`ifdef __EXU_EXU_ALU_V__

module alu_module (
    input                                           i_csr_trap_flush,
    input                                           i_exu_mis_flush,
    input   [`ROB_ID_WIDTH - 1          : 0]        i_exu_mis_rob_id,
    input                                           i_exu_ls_flush,
    input   [`ROB_ID_WIDTH - 1          : 0]        i_exu_ls_rob_id,

    input                                           i_rsv_exu_vld,
    input                                           i_rsv_exu_src1_vld,
    input   [`PRF_DATA_WIDTH - 1        : 0]        i_rsv_exu_src1_dat,
    input                                           i_rsv_exu_src2_vld,
    input   [`PRF_DATA_WIDTH - 1        : 0]        i_rsv_exu_src2_dat,
    input                                           i_rsv_exu_src3_vld,
    input   [`PRF_DATA_WIDTH - 1        : 0]        i_rsv_exu_src3_dat,
    input                                           i_rsv_exu_dst_vld,
    input   [`PRF_CODE_WIDTH - 1        : 0]        i_rsv_exu_dst_code,
    input   [`IMM_WIDTH - 1             : 0]        i_rsv_exu_imm,

    input   [`ROB_ID_WIDTH - 1          : 0]        i_rsv_exu_rob_id,
    input   [`DECINFO_WIDTH - 1         : 0]        i_rsv_exu_decinfo_bus,
    input                                           i_rsv_exu_len,
    input   [`CORE_PC_WIDTH - 1         : 0]        i_rob_exu_addr,
    input   [`EXCEPTION_CODE_WIDTH - 1  : 0]        i_rsv_exu_excp_code,
    input   [`PRF_DATA_WIDTH - 1        : 0]        i_csr_exu_rdat,

    output  [`CSR_ADDR_WIDTH - 1        : 0]        o_exu_csr_addr,
    output                                          o_exu_csr_wren,
    output  [`PRF_DATA_WIDTH - 1        : 0]        o_exu_csr_wdat,

    output                                          o_exu_rsv_wren,
    output  [`PRF_CODE_WIDTH - 1        : 0]        o_exu_rsv_wr_prf_code,
    output  [31                         : 0]        o_exu_rsv_wdat,
    output                                          o_exu_rsv_busy,
    output                                          o_exu_rob_vld,
    output  [`CSR_EXCEPT_WIDTH - 1      : 0]        o_exu_rob_excp_code,
    output                                          o_exu_rob_done,
    output  [`ROB_ID_WIDTH - 1          : 0]        o_exu_rob_rob_id,
    output  [31                         : 0]        o_exu_rob_fence_src1,
    output  [31                         : 0]        o_exu_rob_fence_src2,

    input                                           clk,
    input                                           rst_n
);

wire exu_mis_ls_flush = (i_exu_mis_flush | i_exu_ls_flush);
wire exu_mis_ls_flush_both = (i_exu_mis_flush & i_exu_ls_flush);
wire [`ROB_ID_WIDTH - 1 : 0] exu_mis_ls_rob_id = exu_mis_ls_flush_both ? (func_rob_old(i_exu_mis_rob_id, i_exu_ls_rob_id) ? i_exu_mis_rob_id : i_exu_ls_rob_id)
                                               : i_exu_mis_flush ? i_exu_mis_rob_id
                                               : i_exu_ls_rob_id;

wire alu_idle_flush = (alu_sta_is_idle & i_rsv_exu_vld & (func_rob_old(exu_mis_ls_rob_id, i_rsv_exu_rob_id)));
wire alu_exec_flush = (alu_sta_is_exec & func_rob_old(exu_mis_ls_rob_id, alu_rob_id));
//
wire alu_info_ena = alu_sta_exit_idle;
wire [`ALU_INFO_WIDTH - 1 : 0] alu_info_r, alu_info_nxt;

assign alu_info_nxt = {
                        i_rsv_exu_src1_vld
                    ,   i_rsv_exu_src1_dat
                    ,   i_rsv_exu_src2_vld
                    ,   i_rsv_exu_src2_dat
                    ,   i_rsv_exu_src3_vld
                    ,   i_rsv_exu_src3_dat
                    ,   i_rsv_exu_dst_vld
                    ,   i_rsv_exu_dst_code
                    ,   i_rsv_exu_imm
                    ,   i_rsv_exu_rob_id
                    ,   i_rsv_exu_decinfo_bus
                    ,   i_rob_exu_addr
                    ,   i_rsv_exu_excp_code
                    };

gnrl_dffl #(
    .DATA_WIDTH   (`ALU_INFO_WIDTH)
) alu_info_dffl (alu_info_ena, alu_info_nxt, alu_info_r, clk, rst_n);

//
wire                                 alu_src1_vld;
wire [`PRF_DATA_WIDTH - 1       : 0] alu_src1_dat;
wire                                 alu_src2_vld;
wire [`PRF_DATA_WIDTH - 1       : 0] alu_src2_dat;
wire                                 alu_src3_vld;
wire [`PRF_DATA_WIDTH - 1       : 0] alu_src3_dat;
wire                                 alu_dst_vld;
wire [`PRF_CODE_WIDTH - 1       : 0] alu_dst_code;
wire [`IMM_WIDTH - 1            : 0] alu_imm;
wire [`ROB_ID_WIDTH - 1         : 0] alu_rob_id;
wire [`DECINFO_WIDTH - 1        : 0] alu_decinfo_bus;
wire [`CORE_PC_WIDTH - 1        : 0] alu_addr;
wire [`EXCEPTION_CODE_WIDTH - 1 : 0] alu_excp_code;

assign {
            alu_src1_vld
        ,   alu_src1_dat
        ,   alu_src2_vld
        ,   alu_src2_dat
        ,   alu_src3_vld
        ,   alu_src3_dat
        ,   alu_dst_vld
        ,   alu_dst_code
        ,   alu_imm
        ,   alu_rob_id
        ,   alu_decinfo_bus
        ,   alu_addr
        ,   alu_excp_code
} = alu_info_r;

//
localparam  ALU_STATE_WIDTH = 2;
localparam  ALU_STATE_IDLE = 2'b01,
            ALU_STATE_EXEC = 2'b10;

wire [ALU_STATE_WIDTH - 1 : 0] alu_sta_cur_r, alu_sta_nxt;

wire alu_sta_is_idle = (alu_sta_cur_r == ALU_STATE_IDLE);
wire alu_sta_is_exec = (alu_sta_cur_r == ALU_STATE_EXEC);

wire alu_need_exec = ((~alu_idle_flush) & (~alu_0cycle_inst));

wire alu_sta_exit_idle = (alu_sta_is_idle & alu_need_exec);
wire alu_sta_exit_exec = (alu_sta_is_exec & (o_exu_rob_done | alu_exec_flush));

assign alu_sta_nxt = ({ALU_STATE_WIDTH{alu_sta_exit_exec}} & ALU_STATE_IDLE)
                   | ({ALU_STATE_WIDTH{alu_sta_exit_idle}} & ALU_STATE_EXEC);

wire alu_sta_ena = (alu_sta_exit_idle | alu_sta_exit_exec);

gnrl_dfflr #(
    .DATA_WIDTH   (ALU_STATE_WIDTH),
    .INITIAL_VALUE(ALU_STATE_IDLE)
) alu_sta_dfflr (alu_sta_ena, alu_sta_nxt, alu_sta_cur_r, clk, rst_n);

//

//  Common
wire alu_add = alu_decinfo_bus[`UOPINFO_ALU_ADD ];
wire alu_sub = alu_decinfo_bus[`UOPINFO_ALU_SUB ];
wire alu_slt = alu_decinfo_bus[`UOPINFO_ALU_SLT ];
wire alu_sltu= alu_decinfo_bus[`UOPINFO_ALU_SLTU];
wire alu_xor = alu_decinfo_bus[`UOPINFO_ALU_XOR ];
wire alu_sll = alu_decinfo_bus[`UOPINFO_ALU_SLL ];
wire alu_srl = alu_decinfo_bus[`UOPINFO_ALU_SRL ];
wire alu_sra = alu_decinfo_bus[`UOPINFO_ALU_SRA ];
wire alu_or  = alu_decinfo_bus[`UOPINFO_ALU_OR  ];
wire alu_and = alu_decinfo_bus[`UOPINFO_ALU_AND ];
wire alu_lui = alu_decinfo_bus[`UOPINFO_ALU_LUI ];

wire alu_wfi = i_rsv_exu_decinfo_bus[`UOPINFO_BJP_WFI ];
wire alu_nop = i_rsv_exu_decinfo_bus[`UOPINFO_ALU_NOP ];

wire alu_opimm = alu_decinfo_bus[`UOPINFO_ALU_OPIMM];

wire alu_ilgl = i_rsv_exu_decinfo_bus[`UOPINFO_ALU_ILGL];

//  FENCE & FENCEI & SFENCE.VMA
wire alu_fence      = i_rsv_exu_decinfo_bus[`UOPINFO_ALU_FENCE    ];
wire alu_fencei     = i_rsv_exu_decinfo_bus[`UOPINFO_ALU_FENCEI   ];
wire alu_sfencevma  = i_rsv_exu_decinfo_bus[`UOPINFO_ALU_SFENCEVMA];

wire alu_excp = (|i_rsv_exu_excp_code);

wire alu_0cycle_inst = (alu_fence 
                     |  alu_fencei 
                     |  alu_sfencevma
                     |  alu_nop
                     |  alu_ilgl
                     |  alu_wfi
                     |  alu_excp);

//  Counter
localparam  ALU_CTR_WIDTH = 1;
localparam  ALU_CTR_0 = 1'b0,
            ALU_CTR_1 = 1'b1;

wire [ALU_CTR_WIDTH - 1 : 0] alu_ctr_r, alu_ctr_nxt;
wire alu_ctr_set = alu_sta_exit_idle;
wire alu_ctr_inc = (~alu_last_cycle);
wire alu_ctr_ena = (alu_ctr_set | alu_ctr_inc);

assign alu_ctr_nxt = alu_ctr_set ? ALU_CTR_0
                   : (alu_ctr_r + 1'b1);

gnrl_dfflr #(
    .DATA_WIDTH   (ALU_CTR_WIDTH),
    .INITIAL_VALUE(0)
) alu_ctr_dfflr (alu_ctr_ena, alu_ctr_nxt, alu_ctr_r, clk, rst_n);

wire alu_1th = (alu_ctr_r == ALU_CTR_1);
wire alu_last_cycle = (alu_0cycle_inst | alu_1th);
//

//
wire [`PRF_DATA_WIDTH - 1 : 0] alu_op_1 = alu_src1_vld ? alu_src1_dat
                                        : alu_addr;
wire [`PRF_DATA_WIDTH - 1 : 0] alu_op_2 = alu_opimm ? alu_imm
                                        : alu_src2_dat;

//
wire alu_addsub = (alu_sub | alu_add);
wire alu_adder_sub  = (alu_sub);

wire [`PRF_DATA_WIDTH - 1 : 0] alu_adder_op_1 = alu_op_1;
wire [`PRF_DATA_WIDTH - 1 : 0] alu_adder_op_2 = alu_adder_sub ? (~alu_op_2) : alu_op_2;
wire [`PRF_DATA_WIDTH - 1 : 0] alu_adder_res = alu_adder_op_1 + alu_adder_op_2 + alu_adder_sub;

//
wire alu_slt_res  = ($signed(alu_op_1) < $signed(alu_op_2));
wire alu_sltu_res = (alu_op_1 < alu_op_2); 

wire [`PRF_DATA_WIDTH - 1 : 0] alu_slt_sltu_res = {
                                                    31'h0
                                                ,   (alu_slt & alu_slt_res) | (alu_sltu & alu_slt_sltu_res) 
                                                };
wire alu_slt_sltu = (alu_slt | alu_sltu);

//  Logic
wire [`PRF_DATA_WIDTH - 1 : 0] alu_xor_res = (alu_op_1 ^ alu_op_2);
wire [`PRF_DATA_WIDTH - 1 : 0] alu_sll_res = (alu_op_1 << alu_op_2[4 : 0]);
wire [`PRF_DATA_WIDTH - 1 : 0] alu_srl_res = (alu_op_1 >> alu_op_2[4 : 0]);
wire [`PRF_DATA_WIDTH - 1 : 0] alu_sra_res = ($signed(alu_op_1) >>> alu_op_2[4 : 0]);
wire [`PRF_DATA_WIDTH - 1 : 0] alu_or_res  = (alu_op_1 | alu_op_2);
wire [`PRF_DATA_WIDTH - 1 : 0] alu_and_res = (alu_op_1 & alu_op_2);

wire [`PRF_DATA_WIDTH - 1 : 0] alu_lui_res = {i_rsv_exu_imm[19 : 0], 12'b0};

wire [`PRF_DATA_WIDTH - 1 : 0] alu_logic_res = ({`PRF_DATA_WIDTH{alu_xor}}  & alu_xor_res)
                                             | ({`PRF_DATA_WIDTH{alu_sll}}  & alu_sll_res)
                                             | ({`PRF_DATA_WIDTH{alu_srl}}  & alu_srl_res)
                                             | ({`PRF_DATA_WIDTH{alu_sra}}  & alu_sra_res)
                                             | ({`PRF_DATA_WIDTH{alu_or }}  & alu_or_res ) 
                                             | ({`PRF_DATA_WIDTH{alu_and}}  & alu_and_res)
                                             | ({`PRF_DATA_WIDTH{alu_lui}}  & alu_lui_res);

wire alu_loigc_op = (alu_xor
                  |  alu_sll
                  |  alu_srl
                  |  alu_sra
                  |  alu_or
                  |  alu_and
                  |  alu_lui);
//  CSR
wire alu_csr_op = (alu_decinfo_bus[`DECINFO_EXEC_UNIT] == `UOPINFO_CSR);

wire alu_csr_csrrw         = alu_decinfo_bus[`DECINFO_CSR_CSRRW];
wire alu_csr_csrrs         = alu_decinfo_bus[`DECINFO_CSR_CSRRS];
wire alu_csr_csrrc         = alu_decinfo_bus[`DECINFO_CSR_CSRRC];
wire alu_csr_csrrwi        = alu_decinfo_bus[`DECINFO_CSR_CSRRWI];
wire alu_csr_csrrwi        = alu_decinfo_bus[`DECINFO_CSR_CSRRSI];
wire alu_csr_csrrci        = alu_decinfo_bus[`DECINFO_CSR_CSRRCI];
wire [4 : 0] alu_csr_zimm  = alu_decinfo_bus[`DECINFO_CSR_ZIMM];
wire alu_csr_rs1isx0       = alu_decinfo_bus[`DECINFO_CSR_RS1IS0];
wire alu_csr_rdisx0        = alu_decinfo_bus[`DECINFO_CSR_RD1IS0];
wire alu_csr_zimmis0       = (~(|alu_csr_zimm));
wire [11 : 0] alu_csr_addr = alu_decinfo_bus[`DECINFO_CSR_ADDR];

wire alu_csr_csrrw_wr  = (alu_csr_csrrw & alu_csr_rdisx0);
wire alu_csr_csrrw_rw  = (alu_csr_csrrw & (~alu_csr_rdisx0));
wire alu_csr_csrrsc_rd = ((alu_csr_csrrs | alu_csr_csrrc) & alu_csr_rs1isx0);
wire alu_csr_csrrsc_rw = ((alu_csr_csrrs | alu_csr_csrrc) & (~alu_csr_rs1isx0)); 
wire alu_csr_csrrwi_wr = (alu_csr_csrrwi & alu_csr_rdisx0);
wire alu_csr_csrrwi_rw = (alu_csr_csrrwi & (~alu_csr_rdisx0));
wire alu_csr_csrrsci_rd= ((alu_csr_csrrsi | alu_csr_csrrci) & alu_csr_zimmis0);
wire alu_csr_csrrsci_rw= ((alu_csr_csrrsi | alu_csr_csrrci) & (~alu_csr_zimmis0));

assign o_exu_csr_wren = (alu_csr_csrrw_wr
                      |  alu_csr_csrrw_rw
                      |  alu_csr_csrrsc_rw
                      |  alu_csr_csrrsci_rw);
assign o_exu_csr_addr = alu_csr_addr;

wire [`PRF_DATA_WIDTH - 1 : 0] alu_csrrs_dat = (alu_src1_dat | i_csr_exu_rdat);
wire [`PRF_DATA_WIDTH - 1 : 0] alu_csrrc_dat = ((~alu_src1_dat) & i_csr_exu_rdat);

assign o_exu_csr_wdat = ({`PRF_DATA_WIDTH{alu_csr_csrrw                   }} & alu_src1_dat     )
                      | ({`PRF_DATA_WIDTH{alu_csr_csrrwi                  }} & {27'h0, alu_csr_zimm})
                      | ({`PRF_DATA_WIDTH{(alu_csr_csrrs | alu_csr_csrrsi)}} & alu_csrrs_dat        )
                      | ({`PRF_DATA_WIDTH{(alu_csr_csrrc | alu_csr_csrrci)}} & alu_csrrc_dat        );
//
assign o_exu_rob_vld  = (alu_0cycle_inst | alu_sta_is_exec);
assign o_exu_rob_done = alu_last_cycle;
assign o_exu_rob_rob_id   = alu_0cycle_inst ? i_rsv_exu_rob_id
                      : alu_rob_id;

assign o_exu_rob_fence_src1 = i_rsv_exu_src1_dat;
assign o_exu_rob_fence_src2 = i_rsv_exu_src2_dat;

assign o_exu_rob_excp_code = alu_0cycle_inst ? i_rsv_exu_excp_code
                           : alu_excp_code;

//
assign o_exu_rsv_wr_vld     = (alu_sta_is_exec & alu_dst_vld);
assign o_exu_rsv_wr_prf_code= alu_dst_code;
assign o_exu_rsv_wdat       = ({`PRF_DATA_WIDTH{alu_addsub  }}  & alu_adder_res   )
                            | ({`PRF_DATA_WIDTH{alu_slt_sltu}}  & alu_slt_sltu_res)
                            | ({`PRF_DATA_WIDTH{alu_loigc_op}}  & alu_logic_res   )
                            | ({`PRF_DATA_WIDTH{alu_csr_op  }}  & i_csr_exu_rdat  ); 
assign o_exu_rsv_busy = alu_sta_is_idle;

//  Functions
function func_rob_old;
    input [7 : 0]   func_rob_id0;
    input [7 : 0]   func_rob_id1;
    //  If func_rob_id0 OLDER than func_rob_id1, return HIGH level;
    func_rob_old = (func_rob_id0[7] ^ func_rob_id1[7]) ? (func_rob_id0[6 : 0] >= func_rob_id1[6 : 0])
                 : (func_rob_id0[6 : 0] < func_rob_id1[6 : 0]);
endfunction

endmodule   //  alu_module

`endif  /*  !__EXU_EXU_ALU_V__! */