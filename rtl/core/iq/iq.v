`ifdef __IQ_IQ_V__

module iq_module (
    input                                               i_csr_trap_flush,
    input                                               i_exu_mis_flush,
    input                                               i_exu_ls_flush,
    input   [1                          : 0]            i_csr_rv_mode,
    
    input   [3                          : 0]            i_predec_iq_vld,
    input   [`INSTR_WIDTH - 1           : 0]            i_predec_iq_instr_0,
    input   [`CORE_PC_WIDTH - 1         : 0]            i_predec_iq_addr_0,
    input   [5                          : 0]            i_predec_iq_type_0,
    input   [3                          : 0]            i_predec_iq_alias_vec_0,
    input   [3                          : 0]            i_predec_iq_match_vec_0,
    input   [`INSTR_WIDTH - 1           : 0]            i_predec_iq_instr_1,
    input   [`CORE_PC_WIDTH - 1         : 0]            i_predec_iq_addr_1,
    input   [5                          : 0]            i_predec_iq_type_1,
    input   [3                          : 0]            i_predec_iq_alias_vec_1,
    input   [3                          : 0]            i_predec_iq_match_vec_1,
    input   [`INSTR_WIDTH - 1           : 0]            i_predec_iq_instr_2,
    input   [`CORE_PC_WIDTH - 1         : 0]            i_predec_iq_addr_2,
    input   [5                          : 0]            i_predec_iq_type_2,
    input   [3                          : 0]            i_predec_iq_alias_vec_2,
    input   [3                          : 0]            i_predec_iq_match_vec_2,
    input   [`INSTR_WIDTH - 1           : 0]            i_predec_iq_instr_3,
    input   [`CORE_PC_WIDTH - 1         : 0]            i_predec_iq_addr_3,
    input   [5                          : 0]            i_predec_iq_type_3,
    input   [3                          : 0]            i_predec_iq_alias_vec_3,
    input   [3                          : 0]            i_predec_iq_match_vec_3,
    input   [3                          : 0]            i_predec_iq_len,
    input   [`PREDINFO_WIDTH - 1        : 0]            i_predec_iq_predinfo_bus,
    input   [`EXCEPTION_CODE_WIDTH - 1  : 0]            i_predec_iq_excp_code,
    input                                               i_exu_iq_btac_vld,
    input                                               i_exu_iq_btac_taken,
    input                                               i_exu_iq_new_br,
    input                                               i_exu_iq_type,
    input   [`CORE_PC_WIDTH - 1         : 0]            i_exu_iq_btac_addr,
    input   [`CORE_PC_WIDTH - 1         : 0]            i_exu_iq_btac_taddr,
    input   [1                          : 0]            i_exu_iq_btac_idx,
    input   [10                         : 0]            i_exu_iq_pht_idx,
    input   [1                          : 0]            i_exu_iq_pht_entry,
    input                                               i_exu_iq_len,
    input                                               i_exu_iq_tsucc,
    input                                               i_dec_iq_stall,
    
    output  [3                          : 0]            o_iq_dec_vld,
    output  [`INSTR_WIDTH - 1           : 0]            o_iq_dec_instr_0,
    output  [`CORE_PC_WIDTH - 1         : 0]            o_iq_dec_taddr_0,
    output  [`CORE_PC_WIDTH - 1         : 0]            o_iq_dec_addr_0,
    output  [`PREDINFO_WIDTH - 1        : 0]            o_iq_dec_predinfo_bus_0,
    output  [`EXCEPTION_CODE_WIDTH - 1  : 0]            o_iq_dec_excp_code_0,
    output  [`INSTR_WIDTH - 1           : 0]            o_iq_dec_instr_1,
    output  [`CORE_PC_WIDTH - 1         : 0]            o_iq_dec_taddr_1,
    output  [`CORE_PC_WIDTH - 1         : 0]            o_iq_dec_addr_1,
    output  [`PREDINFO_WIDTH - 1        : 0]            o_iq_dec_predinfo_bus_1,
    output  [`EXCEPTION_CODE_WIDTH - 1  : 0]            o_iq_dec_excp_code_1,
    output  [`INSTR_WIDTH - 1           : 0]            o_iq_dec_instr_2,
    output  [`CORE_PC_WIDTH - 1         : 0]            o_iq_dec_taddr_2,
    output  [`CORE_PC_WIDTH - 1         : 0]            o_iq_dec_addr_2,
    output  [`PREDINFO_WIDTH - 1        : 0]            o_iq_dec_predinfo_bus_2,
    output  [`EXCEPTION_CODE_WIDTH - 1  : 0]            o_iq_dec_excp_code_2,
    output  [`INSTR_WIDTH - 1           : 0]            o_iq_dec_instr_3,
    output  [`CORE_PC_WIDTH - 1         : 0]            o_iq_dec_taddr_3,
    output  [`CORE_PC_WIDTH - 1         : 0]            o_iq_dec_addr_3,
    output  [`PREDINFO_WIDTH - 1        : 0]            o_iq_dec_predinfo_bus_3,
    output  [`EXCEPTION_CODE_WIDTH - 1  : 0]            o_iq_dec_excp_code_3,
    output  [3                          : 0]            o_iq_dec_len,
    output                                              o_iq_bpu_vld,
    output                                              o_iq_bpu_taken,
    output                                              o_iq_bpu_new_br,
    output                                              o_iq_bpu_type,
    output  [`CORE_PC_WIDTH - 1         : 0]            o_iq_bpu_btb_addr,
    output  [`CORE_PC_WIDTH - 1         : 0]            o_iq_bpu_btb_taddr,
    output  [4                          : 0]            o_iq_bpu_btb_idx,
    output  [10                         : 0]            o_iq_bpu_pht_idx,
    output  [1                          : 0]            o_iq_bpu_pht_entry,
    output                                              o_iq_bpu_alias_err,
    output                                              o_iq_bpu_tsucc,
    output                                              o_iq_predec_stall,
    output                                              o_iq_flush,
    output  [`CORE_PC_WIDTH - 1         : 0]            o_iq_taddr,
    output                                              o_iq_uc_flush,
    output  [`CORE_PC_WIDTH - 1         : 0]            o_iq_uc_taddr,

    input                                               clk,
    input                                               rst_n
);

wire iq_need_flush = (i_exu_ls_flush | i_exu_mis_flush | i_csr_trap_flush);

//
wire [`IMM_WIDTH - 1 : 0] iq_jal_imm_0 = {
                                           {11{i_predec_iq_instr_0[31]}}
                                          , i_predec_iq_instr_0[31]
                                          , i_predec_iq_instr_0[19:12]
                                          , i_predec_iq_instr_0[20]
                                          , i_predec_iq_instr_0[30:21]
                                          , 1'b0
                                          };
wire [`IMM_WIDTH - 1 : 0] iq_cj_cjal_imm_0 = {
                                            {20{i_predec_iq_instr_0[12]}}
                                            , i_predec_iq_instr_0[12]
                                            , i_predec_iq_instr_0[8]
                                            , i_predec_iq_instr_0[10:9]
                                            , i_predec_iq_instr_0[6]
                                            , i_predec_iq_instr_0[7]
                                            , i_predec_iq_instr_0[2]
                                            , i_predec_iq_instr_0[11]
                                            , i_predec_iq_instr_0[5:3]
                                            , 1'b0
                                            };
wire [`IMM_WIDTH - 1 : 0] iq_imm_0 = ({`IMM_WIDTH{i_predec_iq_type_0[3]}} & iq_cj_cjal_imm_0)
                                   | ({`IMM_WIDTH{i_predec_iq_type_0[2]}} & iq_jal_imm_0    );


wire [`IMM_WIDTH - 1 : 0] iq_jal_imm_1 = {
                                           {11{i_predec_iq_instr_1[31]}}
                                          , i_predec_iq_instr_1[31]
                                          , i_predec_iq_instr_1[19:12]
                                          , i_predec_iq_instr_1[20]
                                          , i_predec_iq_instr_1[30:21]
                                          , 1'b0
                                          };
wire [`IMM_WIDTH - 1 : 0] iq_cj_cjal_imm_1 = {
                                            {20{i_predec_iq_instr_1[12]}}
                                            , i_predec_iq_instr_1[12]
                                            , i_predec_iq_instr_1[8]
                                            , i_predec_iq_instr_1[10:9]
                                            , i_predec_iq_instr_1[6]
                                            , i_predec_iq_instr_1[7]
                                            , i_predec_iq_instr_1[2]
                                            , i_predec_iq_instr_1[11]
                                            , i_predec_iq_instr_1[5:3]
                                            , 1'b0
                                            };
wire [`IMM_WIDTH - 1 : 0] iq_imm_1 = ({`IMM_WIDTH{i_predec_iq_type_1[3]}} & iq_cj_cjal_imm_1)
                                   | ({`IMM_WIDTH{i_predec_iq_type_1[2]}} & iq_jal_imm_1    );


wire [`IMM_WIDTH - 1 : 0] iq_jal_imm_2 = {
                                           {11{i_predec_iq_instr_2[31]}}
                                          , i_predec_iq_instr_2[31]
                                          , i_predec_iq_instr_2[19:12]
                                          , i_predec_iq_instr_2[20]
                                          , i_predec_iq_instr_2[30:21]
                                          , 1'b0
                                          };
wire [`IMM_WIDTH - 1 : 0] iq_cj_cjal_imm_2 = {
                                            {20{i_predec_iq_instr_2[12]}}
                                            , i_predec_iq_instr_2[12]
                                            , i_predec_iq_instr_2[8]
                                            , i_predec_iq_instr_2[10:9]
                                            , i_predec_iq_instr_2[6]
                                            , i_predec_iq_instr_2[7]
                                            , i_predec_iq_instr_2[2]
                                            , i_predec_iq_instr_2[11]
                                            , i_predec_iq_instr_2[5:3]
                                            , 1'b0
                                            };
wire [`IMM_WIDTH - 1 : 0] iq_imm_2 = ({`IMM_WIDTH{i_predec_iq_type_2[3]}} & iq_cj_cjal_imm_2)
                                   | ({`IMM_WIDTH{i_predec_iq_type_2[2]}} & iq_jal_imm_2    );

wire [`IMM_WIDTH - 1 : 0] iq_jal_imm_3 = {
                                           {11{i_predec_iq_instr_3[31]}}
                                          , i_predec_iq_instr_3[31]
                                          , i_predec_iq_instr_3[19:12]
                                          , i_predec_iq_instr_3[20]
                                          , i_predec_iq_instr_3[30:21]
                                          , 1'b0
                                          };
wire [`IMM_WIDTH - 1 : 0] iq_cj_cjal_imm_3 = {
                                            {20{i_predec_iq_instr_3[12]}}
                                            , i_predec_iq_instr_3[12]
                                            , i_predec_iq_instr_3[8]
                                            , i_predec_iq_instr_3[10:9]
                                            , i_predec_iq_instr_3[6]
                                            , i_predec_iq_instr_3[7]
                                            , i_predec_iq_instr_3[2]
                                            , i_predec_iq_instr_3[11]
                                            , i_predec_iq_instr_3[5:3]
                                            , 1'b0
                                            };
wire [`IMM_WIDTH - 1 : 0] iq_imm_3 = ({`IMM_WIDTH{i_predec_iq_type_3[3]}} & iq_cj_cjal_imm_3)
                                   | ({`IMM_WIDTH{i_predec_iq_type_3[2]}} & iq_jal_imm_3    );

//
//  Inst 0 alias error check
wire iq_alias_err_0_off_alias = (((~i_predec_iq_len[0]) & i_predec_iq_alias_vec_0[0])
                              | (i_predec_iq_len[0] & (|i_predec_iq_alias_vec_0[2 : 0])));
wire iq_alias_err_0_uc_alias = (((~i_predec_iq_len[0]) & i_predec_iq_match_vec_0[1] & (~(|i_predec_iq_type_0[5 : 2])))
                             |  (i_predec_iq_len[0] & i_predec_iq_match_vec_0[3] & (~(|i_predec_iq_type_0[5 : 2]))));
wire iq_alias_err_0_cond_alias = (((~i_predec_iq_len[0]) & i_predec_iq_match_vec_0[1] 
                               & (((|i_predec_iq_type_0[3 : 2]) & (i_predec_iq_predinfo_bus[`PREDINFO_TYPE] == 1'b1)) 
                               | ((|i_predec_iq_type_0[5 : 4]) & (i_predec_iq_predinfo_bus[`PREDINFO_TYPE] == 1'b0))))
                               |  (i_predec_iq_len[0] & i_predec_iq_match_vec_0[3] 
                               & (((|i_predec_iq_type_0[3 : 2]) & (i_predec_iq_predinfo_bus[`PREDINFO_TYPE] == 1'b1)) 
                               | ((|i_predec_iq_type_0[5 : 4]) & (i_predec_iq_predinfo_bus[`PREDINFO_TYPE] == 1'b0)))));
wire iq_alias_err_0 = (iq_alias_err_0_off_alias
                    |  iq_alias_err_0_uc_alias
                    |  iq_alias_err_0_cond_alias);

wire [1 : 0] iq_alias_err_0_off_op2 = ({2{i_predec_iq_alias_vec_0[1]}} & 2'd1)
                                    | ({2{i_predec_iq_alias_vec_0[2]}} & 2'd2);
wire [1 : 0] iq_alias_err_0_uc_cond_op2 = i_predec_iq_len[0] ? 2'd3
                                        : 2'd1;
wire [1 : 0] iq_alias_err_0_op2 = iq_alias_err_0_off_alias ? iq_alias_err_0_off_op2
                                : iq_alias_err_0_uc_cond_op2;

//  Inst 1 alias error check
wire iq_alias_err_1_off_alias = (((~i_predec_iq_len[1]) & i_predec_iq_alias_vec_1[0])
                              | (i_predec_iq_len[1] & (|i_predec_iq_alias_vec_1[2 : 0])));
wire iq_alias_err_1_uc_alias = (((~i_predec_iq_len[1]) & i_predec_iq_match_vec_1[1] & (~(|i_predec_iq_type_1[5 : 2])))
                             |  (i_predec_iq_len[1] & i_predec_iq_match_vec_1[3] & (~(|i_predec_iq_type_1[5 : 2]))));
wire iq_alias_err_1_cond_alias = (((~i_predec_iq_len[1]) & i_predec_iq_match_vec_1[1] 
                               & (((|i_predec_iq_type_1[3 : 2]) & (i_predec_iq_predinfo_bus[`PREDINFO_TYPE] == 1'b1)) 
                               | ((|i_predec_iq_type_1[5 : 4]) & (i_predec_iq_predinfo_bus[`PREDINFO_TYPE] == 1'b0))))
                               |  (i_predec_iq_len[1] & i_predec_iq_match_vec_1[3] 
                               & (((|i_predec_iq_type_1[3 : 2]) & (i_predec_iq_predinfo_bus[`PREDINFO_TYPE] == 1'b1)) 
                               | ((|i_predec_iq_type_1[5 : 4]) & (i_predec_iq_predinfo_bus[`PREDINFO_TYPE] == 1'b0)))));
wire iq_alias_err_1 = (iq_alias_err_1_off_alias
                    |  iq_alias_err_1_uc_alias
                    |  iq_alias_err_1_cond_alias);

wire [1 : 0] iq_alias_err_1_off_op2 = ({2{i_predec_iq_alias_vec_1[1]}} & 2'd1)
                                    | ({2{i_predec_iq_alias_vec_1[2]}} & 2'd2);
wire [1 : 0] iq_alias_err_1_uc_cond_op2 = i_predec_iq_len[1] ? 2'd3
                                        : 2'd1;
wire [1 : 0] iq_alias_err_1_op2 = iq_alias_err_1_off_alias ? iq_alias_err_1_off_op2
                                : iq_alias_err_1_uc_cond_op2;

wire iq_alias_err_2_off_alias = (((~i_predec_iq_len[2]) & i_predec_iq_alias_vec_2[0])
                              | (i_predec_iq_len[2] & (|i_predec_iq_alias_vec_2[2 : 0])));
wire iq_alias_err_2_uc_alias = (((~i_predec_iq_len[2]) & i_predec_iq_match_vec_2[1] & (~(|i_predec_iq_type_2[5 : 2])))
                             |  (i_predec_iq_len[2] & i_predec_iq_match_vec_2[3] & (~(|i_predec_iq_type_2[5 : 2]))));
wire iq_alias_err_2_cond_alias = (((~i_predec_iq_len[2]) & i_predec_iq_match_vec_2[1] 
                               & (((|i_predec_iq_type_2[3 : 2]) & (i_predec_iq_predinfo_bus[`PREDINFO_TYPE] == 1'b1)) 
                               | ((|i_predec_iq_type_2[5 : 4]) & (i_predec_iq_predinfo_bus[`PREDINFO_TYPE] == 1'b0))))
                               |  (i_predec_iq_len[2] & i_predec_iq_match_vec_2[3] 
                               & (((|i_predec_iq_type_2[3 : 2]) & (i_predec_iq_predinfo_bus[`PREDINFO_TYPE] == 1'b1)) 
                               | ((|i_predec_iq_type_2[5 : 4]) & (i_predec_iq_predinfo_bus[`PREDINFO_TYPE] == 1'b0)))));
wire iq_alias_err_2 = (iq_alias_err_2_off_alias
                    |  iq_alias_err_2_uc_alias
                    |  iq_alias_err_2_cond_alias);
wire [1 : 0] iq_alias_err_2_off_op2 = ({2{i_predec_iq_alias_vec_2[1]}} & 2'd1)
                                    | ({2{i_predec_iq_alias_vec_2[2]}} & 2'd2);
wire [1 : 0] iq_alias_err_2_uc_cond_op2 = i_predec_iq_len[2] ? 2'd3
                                        : 2'd1;
wire [1 : 0] iq_alias_err_2_op2 = iq_alias_err_2_off_alias ? iq_alias_err_2_off_op2
                                : iq_alias_err_2_uc_cond_op2;

//  Inst 3 error check
wire iq_alias_err_3_off_alias = (((~i_predec_iq_len[3]) & i_predec_iq_alias_vec_3[0])
                              | (i_predec_iq_len[3] & (|i_predec_iq_alias_vec_3[2 : 0])));
wire iq_alias_err_3_uc_alias = (((~i_predec_iq_len[3]) & i_predec_iq_match_vec_3[1] & (~(|i_predec_iq_type_3[5 : 2])))
                             |  (i_predec_iq_len[3] & i_predec_iq_match_vec_3[3] & (~(|i_predec_iq_type_3[5 : 2]))));
wire iq_alias_err_3_cond_alias = (((~i_predec_iq_len[3]) & i_predec_iq_match_vec_3[1] 
                               & (((|i_predec_iq_type_3[3 : 2]) & (i_predec_iq_predinfo_bus[`PREDINFO_TYPE] == 1'b1)) 
                               | ((|i_predec_iq_type_3[5 : 4]) & (i_predec_iq_predinfo_bus[`PREDINFO_TYPE] == 1'b0))))
                               |  (i_predec_iq_len[3] & i_predec_iq_match_vec_3[3] 
                               & (((|i_predec_iq_type_3[3 : 2]) & (i_predec_iq_predinfo_bus[`PREDINFO_TYPE] == 1'b1)) 
                               | ((|i_predec_iq_type_3[5 : 4]) & (i_predec_iq_predinfo_bus[`PREDINFO_TYPE] == 1'b0)))));
wire iq_alias_err_3 = (iq_alias_err_3_off_alias
                    |  iq_alias_err_3_uc_alias
                    |  iq_alias_err_3_cond_alias);
wire [1 : 0] iq_alias_err_3_off_op2 = ({2{i_predec_iq_alias_vec_3[1]}} & 2'd1)
                                    | ({2{i_predec_iq_alias_vec_3[2]}} & 2'd2);
wire [1 : 0] iq_alias_err_3_uc_cond_op2 = i_predec_iq_len[3] ? 2'd3
                                        : 2'd1;
wire [1 : 0] iq_alias_err_3_op2 = iq_alias_err_3_off_alias ? iq_alias_err_3_off_op2
                                : iq_alias_err_3_uc_cond_op2;

//
wire [1 : 0] iq_alias_err_op2 = ({2{iq_alias_err_0                                                            }} & iq_alias_err_0_op2)
                              | ({2{iq_alias_err_1 & (~iq_alias_err_0)                                        }} & iq_alias_err_1_op2)
                              | ({2{iq_alias_err_2 & (~iq_alias_err_0) & (~iq_alias_err_1)                    }} & iq_alias_err_2_op2)
                              | ({2{iq_alias_err_3 & (~iq_alias_err_0) & (~iq_alias_err_1) & (~iq_alias_err_2)}} & iq_alias_err_3_op2);

wire [`CORE_PC_WIDTH - 1 : 0] iq_alias_err_taddr = i_predec_iq_predinfo_bus[`PREDINFO_ADDR] + i_predec_iq_predinfo_bus[`PREDINFO_OFFSET] - iq_alias_err_op2;

assign o_iq_bpu_alias_err = ((i_predec_iq_vld[3] & iq_alias_err_3)
                          |  (i_predec_iq_vld[2] & iq_alias_err_2)
                          |  (i_predec_iq_vld[1] & iq_alias_err_1)
                          |  (i_predec_iq_vld[0] & iq_alias_err_0));

//  BTAC Read 
wire i_btac_rden_0;
wire i_btac_rden_1;
wire i_btac_rden_2;
wire i_btac_rden_3;

assign {
      i_btac_rden_3
    , i_btac_rden_2
    , i_btac_rden_1
    , i_btac_rden_0
    } = i_predec_iq_vld;


wire [25 : 0] i_btac_rtag_0 = {
                                i_predec_iq_addr_0[`CORE_PC_WIDTH - 1 : 9]
                              , i_predec_iq_len[0]
                              , i_csr_rv_mode[1 : 0]
                            };

wire [25 : 0] i_btac_rtag_1 = {
                                i_predec_iq_addr_1[`CORE_PC_WIDTH - 1 : 9]
                              , i_predec_iq_len[1]
                              , i_csr_rv_mode[1 : 0]
                            };

wire [25 : 0] i_btac_rtag_2 = {
                                i_predec_iq_addr_2[`CORE_PC_WIDTH - 1 : 9]
                              , i_predec_iq_len[2]
                              , i_csr_rv_mode[1 : 0]
                            };

wire [25 : 0] i_btac_rtag_3 = {
                                i_predec_iq_addr_3[`CORE_PC_WIDTH - 1 : 9]
                              , i_predec_iq_len[3]
                              , i_csr_rv_mode[1 : 0]
                            };

wire [7 : 0] i_btac_ridx_0 = (i_predec_iq_addr_0[8 : 1]);
wire [7 : 0] i_btac_ridx_1 = (i_predec_iq_addr_1[8 : 1]);
wire [7 : 0] i_btac_ridx_2 = (i_predec_iq_addr_2[8 : 1]);
wire [7 : 0] i_btac_ridx_3 = (i_predec_iq_addr_3[8 : 1]);

wire o_btac_rd_hit_0, o_btac_rd_hit_1, o_btac_rd_hit_2, o_btac_rd_hit_3;
wire [1 : 0] o_btac_rd_way_0, o_btac_rd_way_1, o_btac_rd_way_2, o_btac_rd_way_3;
wire [32 : 0] o_btac_rdat_0, o_btac_rdat_1, o_btac_rdat_2, o_btac_rdat_3;


//  BTAC Write
wire i_btac_wren = (i_exu_iq_btac_vld & i_exu_iq_new_br & (~i_exu_iq_tsucc));
wire [7 : 0] i_btac_widx = i_exu_iq_btac_addr[8 : 1];
wire [25 : 0] i_btac_wtag = {
                              i_exu_iq_btac_addr[`CORE_PC_WIDTH - 1 : 9]
                            , i_exu_iq_len
                            , i_csr_rv_mode[1 : 0]
                          };
wire [32 : 0] i_btac_wdat = {
                              i_exu_iq_btac_taddr
                            , i_exu_iq_type
                          };

//  BTAC Update
wire i_btac_updt = (i_exu_iq_btac_vld & (~i_exu_iq_new_br) & (~i_exu_iq_tsucc));
wire [7 : 0] i_btac_updt_idx = i_exu_iq_btac_addr[8 : 1];
wire [1 : 0] i_btac_updt_way_idx = i_exu_iq_btac_idx;


btac_module btac (
  .i_btac_rden_0      (i_btac_rden_0),
  .i_btac_ridx_0      (i_btac_ridx_0),
  .i_btac_rtag_0      (i_btac_rtag_0),
  .o_btac_rd_hit_0    (o_btac_rd_hit_0),
  .o_btac_rd_way_0    (o_btac_rd_way_0),
  .o_btac_rdat_0      (o_btac_rdat_0),
  .i_btac_rden_1      (i_btac_rden_1),
  .i_btac_ridx_1      (i_btac_ridx_1),
  .i_btac_rtag_1      (i_btac_rtag_1),
  .o_btac_rd_hit_1    (o_btac_rd_hit_1),
  .o_btac_rd_way_1    (o_btac_rd_way_1),
  .o_btac_rdat_1      (o_btac_rdat_1),
  .i_btac_rden_2      (i_btac_rden_2),
  .i_btac_ridx_2      (i_btac_ridx_2),
  .i_btac_rtag_2      (i_btac_rtag_2),
  .o_btac_rd_hit_2    (o_btac_rd_hit_2),
  .o_btac_rd_way_2    (o_btac_rd_way_2),
  .o_btac_rdat_2      (o_btac_rdat_2),
  .i_btac_rden_3      (i_btac_rden_3),
  .i_btac_ridx_3      (i_btac_ridx_3),
  .i_btac_rtag_3      (i_btac_rtag_3),
  .o_btac_rd_hit_3    (o_btac_rd_hit_3),
  .o_btac_rd_way_3    (o_btac_rd_way_3),
  .o_btac_rdat_3      (o_btac_rdat_3),
  .i_btac_wren        (i_btac_wren),
  .i_btac_widx        (i_btac_widx),
  .i_btac_wtag        (i_btac_wtag),
  .i_btac_wdat        (i_btac_wdat),
  .i_btac_updt        (i_btac_updt),
  .i_btac_updt_idx    (i_btac_updt_idx),
  .i_btac_updt_way_idx(i_btac_updt_way_idx),
  .clk                (clk),
  .rst_n              (rst_n)
);


//  PHT Read
localparam  PHT_ST  = 2'b11,
            PHT_WT  = 2'b10,
            PHT_WNT = 2'b01,
            PHT_SNT = 2'b00;

wire [10 : 0] i_pht_ridx_0 = (i_predec_iq_addr_0[21 : 11] ^ i_predec_iq_addr_0[10 : 0]);
wire [10 : 0] i_pht_ridx_1 = (i_predec_iq_addr_1[21 : 11] ^ i_predec_iq_addr_1[10 : 0]);
wire [10 : 0] i_pht_ridx_2 = (i_predec_iq_addr_2[21 : 11] ^ i_predec_iq_addr_2[10 : 0]);
wire [10 : 0] i_pht_ridx_3 = (i_predec_iq_addr_3[21 : 11] ^ i_predec_iq_addr_3[10 : 0]);

wire [1 : 0] o_pht_rd_entry_0, o_pht_rd_entry_1, o_pht_rd_entry_2, o_pht_rd_entry_3;

//  PHT Write
wire i_pht_wren = (i_btac_wren | i_btac_updt);
wire [10 : 0] i_pht_widx = i_exu_iq_pht_idx;
wire [1 : 0] i_pht_wr_entry = i_exu_iq_pht_entry;

pht_module pht (
  .i_pht_ridx_0    (i_pht_ridx_0),
  .o_pht_rd_entry_0(o_pht_rd_entry_0),
  .i_pht_ridx_1    (i_pht_ridx_1),
  .o_pht_rd_entry_1(o_pht_rd_entry_1),
  .i_pht_ridx_2    (i_pht_ridx_2),
  .o_pht_rd_entry_2(o_pht_rd_entry_2),
  .i_pht_ridx_3    (i_pht_ridx_3),
  .o_pht_rd_entry_3(o_pht_rd_entry_3),
  .i_pht_wren      (i_pht_wren),
  .i_pht_widx      (i_pht_widx),
  .i_pht_wr_entry  (i_pht_wr_entry),
  .clk             (clk),
  .rst_n           (rst_n)
);

wire iq_pht_taken_0 = ((o_pht_rd_entry_0 == PHT_ST) | (o_pht_rd_entry_0 == PHT_WT));
wire iq_pht_taken_1 = ((o_pht_rd_entry_1 == PHT_ST) | (o_pht_rd_entry_1 == PHT_WT));
wire iq_pht_taken_2 = ((o_pht_rd_entry_2 == PHT_ST) | (o_pht_rd_entry_2 == PHT_WT));
wire iq_pht_taken_3 = ((o_pht_rd_entry_3 == PHT_ST) | (o_pht_rd_entry_3 == PHT_WT));

wire iq_btac_uc_0 = ((o_btac_rdat_0[0] == 1'b0) & o_btac_rd_hit_0);
wire iq_btac_uc_1 = ((o_btac_rdat_1[0] == 1'b0) & o_btac_rd_hit_1);
wire iq_btac_uc_2 = ((o_btac_rdat_2[0] == 1'b0) & o_btac_rd_hit_2);
wire iq_btac_uc_3 = ((o_btac_rdat_3[0] == 1'b0) & o_btac_rd_hit_3);

wire iq_btac_uc_taken = (iq_btac_uc_0 | iq_btac_uc_1 | iq_btac_uc_2 | iq_btac_uc_3);

wire iq_btac_taken_0 = (iq_btac_uc_0 | (((o_btac_rdat_0[0] == 1'b1) & iq_pht_taken_0) & o_btac_rd_hit_0));
wire iq_btac_taken_1 = (iq_btac_uc_1 | (((o_btac_rdat_1[0] == 1'b1) & iq_pht_taken_1) & o_btac_rd_hit_1));
wire iq_btac_taken_2 = (iq_btac_uc_2 | (((o_btac_rdat_2[0] == 1'b1) & iq_pht_taken_2) & o_btac_rd_hit_2));
wire iq_btac_taken_3 = (iq_btac_uc_3 | (((o_btac_rdat_3[0] == 1'b1) & iq_pht_taken_3) & o_btac_rd_hit_3));


wire iq_taken_0 = ((|i_predec_iq_type_0[3 : 2]) | iq_btac_taken_0);
wire iq_taken_1 = ((|i_predec_iq_type_1[3 : 2]) | iq_btac_taken_1);
wire iq_taken_2 = ((|i_predec_iq_type_2[3 : 2]) | iq_btac_taken_2);
wire iq_taken_3 = ((|i_predec_iq_type_3[3 : 2]) | iq_btac_taken_3);


wire [`CORE_PC_WIDTH - 1 : 0] iq_btac_taddr_0 = o_btac_rdat_0[32 : 1];
wire [`CORE_PC_WIDTH - 1 : 0] iq_btac_taddr_1 = iq_taken_0 ? iq_btac_taddr_0
                                              : o_btac_rdat_1[32 : 1];
wire [`CORE_PC_WIDTH - 1 : 0] iq_btac_taddr_2 = (iq_taken_0 | iq_taken_1) ? iq_btac_taddr_1
                                              : o_btac_rdat_2[32 : 1];
wire [`CORE_PC_WIDTH - 1 : 0] iq_btac_taddr_3 = (iq_taken_0 | iq_taken_1 | iq_taken_2) ? iq_btac_taddr_2
                                              : o_btac_rdat_3[32 : 1];


wire [`IQ_PREDINFO_WIDTH - 1 : 0] btac_predinfo_0 = {
                                                      o_btac_rd_hit_0
                                                    , o_btac_rd_way_0
                                                    , i_pht_ridx_0
                                                    , o_pht_rd_entry_0
                                                    , i_predec_iq_len[0]
                                                    , o_btac_rdat_0[0]
                                                    , iq_taken_0
                                                  };
wire [`IQ_PREDINFO_WIDTH - 1 : 0] btac_predinfo_1 = {
                                                      o_btac_rd_hit_1
                                                    , o_btac_rd_way_1
                                                    , i_pht_ridx_1
                                                    , o_pht_rd_entry_1
                                                    , i_predec_iq_len[1]
                                                    , o_btac_rdat_1[0]
                                                    , iq_taken_1
                                                  };
wire [`IQ_PREDINFO_WIDTH - 1 : 0] btac_predinfo_2 = {
                                                      o_btac_rd_hit_2
                                                    , o_btac_rd_way_2
                                                    , i_pht_ridx_2
                                                    , o_pht_rd_entry_2
                                                    , i_predec_iq_len[2]
                                                    , o_btac_rdat_2[0]
                                                    , iq_taken_2
                                                  };
wire [`IQ_PREDINFO_WIDTH - 1 : 0] btac_predinfo_3 = {
                                                      o_btac_rd_hit_3
                                                    , o_btac_rd_way_3
                                                    , i_pht_ridx_3
                                                    , o_pht_rd_entry_3
                                                    , i_predec_iq_len[3]
                                                    , o_btac_rdat_3[0]
                                                    , iq_btac_taken_3
                                                  };
//  Instruction Queue
wire [3 : 0] iq_wr_vld;
assign iq_wr_vld[0] = (i_predec_iq_vld[0] & (~iq_alias_err_0) & (|i_predec_iq_excp_code));
assign iq_wr_vld[1] = (i_predec_iq_vld[1] & (~iq_alias_err_0) & (~iq_alias_err_1) & (~iq_taken_0));
assign iq_wr_vld[2] = (i_predec_iq_vld[2] & (~iq_alias_err_0) & (~iq_alias_err_1) & (~iq_alias_err_2) 
                    & (~(|i_predec_iq_type_0[3 : 2])) & (~iq_taken_0) & (~iq_taken_1));
assign iq_wr_vld[3] = (i_predec_iq_vld[3] & (~iq_alias_err_0) & (~iq_alias_err_1) & (~iq_alias_err_2) & (~iq_alias_err_3)
                    & (~iq_taken_0) & (~iq_taken_1) & (~iq_taken_2));

//  Write PTR
wire [3 : 0] iq_wr_ptr_r;
wire [3 : 0] iq_wr_nums = {3'd0, iq_wr_vld[0]} 
                        + {3'd0, iq_wr_vld[1]}
                        + {3'd0, iq_wr_vld[2]}
                        + {3'd0, iq_wr_vld[3]};

wire iq_wr_ptr_ena = (|iq_wr_vld);
wire [3 : 0] iq_wr_ptr_nxt = iq_need_flush ? 4'd0 
                           : (iq_wr_ptr_r + iq_wr_nums);

gnrl_dfflr #(
  .DATA_WIDTH   (4),
  .INITIAL_VALUE(0)
) iq_wr_ptr_dfflr (iq_wr_ptr_ena, iq_wr_ptr_nxt, iq_wr_ptr_r, clk, rst_n);

//  Read PTR
wire [3 : 0] iq_rd_ptr_r;
wire [3 : 0] iq_rd_nums = {3'd0, o_iq_dec_vld[0]}
                        + {3'd0, o_iq_dec_vld[1]}
                        + {3'd0, o_iq_dec_vld[2]}
                        + {3'd0, o_iq_dec_vld[3]};

wire [3 : 0] inst_nums = iq_wr_ptr_r - iq_rd_ptr_r;

wire [3 : 0] iq_rd_ptr_0 = iq_rd_ptr_r;
wire [3 : 0] iq_rd_ptr_1 = iq_rd_ptr_r + 4'd1;
wire [3 : 0] iq_rd_ptr_2 = iq_rd_ptr_r + 4'd2;
wire [3 : 0] iq_rd_ptr_3 = iq_rd_ptr_r + 4'd3;

wire [3 : 0] iq_sched_1_vld;
assign iq_sched_1_vld[0] = (inst_nums > 4'd0);
assign iq_sched_1_vld[1] = ((inst_nums > 4'd1) & (~iq_instq_r[iq_rd_ptr_0][0]));
assign iq_sched_1_vld[2] = ((inst_nums > 4'd2) & (~iq_instq_r[iq_rd_ptr_0][0]) & (~iq_instq_r[iq_rd_ptr_1][0]));
assign iq_sched_1_vld[3] = ((inst_nums > 4'd3) & (~iq_instq_r[iq_rd_ptr_0][0]) & (~iq_instq_r[iq_rd_ptr_1][0]) & (~iq_instq_r[iq_rd_ptr_2][0]));

wire [3 : 0] iq_sched_2_vld;
assign iq_sched_2_vld[0] = ((inst_nums == 4'd0) & iq_wr_vld[0]);
assign iq_sched_2_vld[1] = ((inst_nums == 4'd0) & iq_wr_vld[1] & (~(|i_predec_iq_type_0[1 : 0])));
assign iq_sched_2_vld[2] = ((inst_nums == 4'd0) & iq_wr_vld[2] & (~(|i_predec_iq_type_0[1 : 0])) & (~(|i_predec_iq_type_1[1 : 0])));
assign iq_sched_2_vld[3] = ((inst_nums == 4'd0) & iq_wr_vld[3] & (~(|i_predec_iq_type_0[1 : 0])) & (~(|i_predec_iq_type_1[1 : 0])) & (~(|i_predec_iq_type_3[1 : 0])));

wire iq_rd_ptr_ena = (|o_iq_dec_vld);
wire [3 : 0] iq_rd_ptr_nxt = iq_need_flush ? 4'd0 
                           : (iq_rd_ptr_r + iq_rd_nums);

gnrl_dfflr #(
  .DATA_WIDTH   (4),
  .INITIAL_VALUE(0)
) iq_rd_ptr_dfflr (iq_rd_ptr_ena, iq_rd_ptr_nxt, iq_rd_ptr_r, clk, rst_n);

//  Instructions Queue
wire [`IQ_ENTRY_WIDTH - 1 : 0] iq_instq_r [15 : 0];

wire [15 : 0] iq_instq_ena;
wire [`IQ_ENTRY_WIDTH - 1 : 0] iq_instq_nxt [15 : 0];

wire [3 : 0] iq_wr_ptr_0 = iq_wr_ptr_r;
wire [3 : 0] iq_wr_ptr_1 = iq_wr_ptr_r + 4'd1;
wire [3 : 0] iq_wr_ptr_2 = iq_wr_ptr_r + 4'd2;
wire [3 : 0] iq_wr_ptr_3 = iq_wr_ptr_r + 4'd3;

wire [`IQ_ENTRY_WIDTH - 1 : 0] iq_instq_0 = {
                                              i_predec_iq_instr_0
                                            , i_predec_iq_addr_0
                                            , iq_btac_taddr_0
                                            , btac_predinfo_0
                                            , i_predec_iq_excp_code
                                            , (|i_predec_iq_type_0[1 : 0])
                                          };
wire [`IQ_ENTRY_WIDTH - 1 : 0] iq_instq_1 = {
                                              i_predec_iq_instr_1
                                            , i_predec_iq_addr_1
                                            , iq_btac_taddr_1
                                            , btac_predinfo_1
                                            , `EXCEPTION_CODE_WIDTH'd0 
                                            , (|i_predec_iq_type_1[1 : 0])
                                          };
wire [`IQ_ENTRY_WIDTH - 1 : 0] iq_instq_2 = {
                                              i_predec_iq_instr_2
                                            , i_predec_iq_addr_2
                                            , iq_btac_taddr_2 
                                            , btac_predinfo_2
                                            , `EXCEPTION_CODE_WIDTH'd0 
                                            , (|i_predec_iq_type_2[1 : 0])
                                          };
wire [`IQ_ENTRY_WIDTH - 1 : 0] iq_instq_3 = {
                                              i_predec_iq_instr_3
                                            , i_predec_iq_addr_3
                                            , iq_btac_taddr_3
                                            , btac_predinfo_3
                                            , `EXCEPTION_CODE_WIDTH'd0 
                                            , (|i_predec_iq_type_3[1 : 0])
                                          };

wire iq_available = (iq_wr_nums <= inst_nums);

genvar i;
generate
  for(i = 0; i < 16; i = i + 1) begin
    assign iq_instq_ena[i] = (iq_available
                           & (((i == iq_wr_ptr_0) & iq_wr_vld[0])
                           |  ((i == iq_wr_ptr_1) & iq_wr_vld[1])
                           |  ((i == iq_wr_ptr_2) & iq_wr_vld[2])
                           |  ((i == iq_wr_ptr_3) & iq_wr_vld[3])));
    assign iq_instq_nxt[i] = ({`IQ_ENTRY_WIDTH{(i == iq_wr_ptr_0) & iq_wr_vld[0]}} & iq_instq_0)
                           | ({`IQ_ENTRY_WIDTH{(i == iq_wr_ptr_1) & iq_wr_vld[1]}} & iq_instq_1)
                           | ({`IQ_ENTRY_WIDTH{(i == iq_wr_ptr_2) & iq_wr_vld[2]}} & iq_instq_2)
                           | ({`IQ_ENTRY_WIDTH{(i == iq_wr_ptr_3) & iq_wr_vld[3]}} & iq_instq_3);
    gnrl_dffl #(
      .DATA_WIDTH(`IQ_ENTRY_WIDTH)
    ) iq_instq_dffl (iq_instq_ena[i], iq_instq_nxt[i], iq_instq_r[i], clk);
  end 
endgenerate

//
assign o_iq_dec_vld = ((iq_sched_1_vld | iq_sched_2_vld) & ({4{~i_dec_iq_stall}}));

assign {
          o_iq_dec_instr_0
        , o_iq_dec_addr_0
        , o_iq_dec_taddr_0
        , o_iq_dec_predinfo_bus_0
        , o_iq_dec_excp_code_0
      } = iq_instq_r[iq_rd_ptr_0][`IQ_ENTRY_WIDTH - 1 : 1];

assign {
          o_iq_dec_instr_1
        , o_iq_dec_addr_1
        , o_iq_dec_taddr_1
        , o_iq_dec_predinfo_bus_1
        , o_iq_dec_excp_code_1
      } = iq_instq_r[iq_rd_ptr_1][`IQ_ENTRY_WIDTH - 1 : 1];

assign {
          o_iq_dec_instr_2
        , o_iq_dec_addr_2
        , o_iq_dec_taddr_2
        , o_iq_dec_predinfo_bus_2
        , o_iq_dec_excp_code_2
      } = iq_instq_r[iq_rd_ptr_2][`IQ_ENTRY_WIDTH - 1 : 1];

assign {
          o_iq_dec_instr_3
        , o_iq_dec_addr_3
        , o_iq_dec_taddr_3
        , o_iq_dec_predinfo_bus_3
        , o_iq_dec_excp_code_3
      } = iq_instq_r[iq_rd_ptr_3][`IQ_ENTRY_WIDTH - 1 : 1];


assign o_iq_dec_len = {
                        o_iq_dec_predinfo_bus_3[1]
                      , o_iq_dec_predinfo_bus_2[1]
                      , o_iq_dec_predinfo_bus_1[1]
                      , o_iq_dec_predinfo_bus_0[1]
                    };

assign o_iq_predec_stall = (i_dec_iq_stall | (~iq_available));
//

wire iq_uc_inst_0 = (|i_predec_iq_type_0[3 : 2]);
wire iq_uc_inst_1 = (|i_predec_iq_type_1[3 : 2]);
wire iq_uc_inst_2 = (|i_predec_iq_type_2[3 : 2]);
wire iq_uc_inst_3 = (|i_predec_iq_type_3[3 : 2]);

wire [`CORE_PC_WIDTH - 1 : 0] iq_uc_taddr_0 = (i_predec_iq_addr_0 + iq_imm_0);
wire [`CORE_PC_WIDTH - 1 : 0] iq_uc_taddr_1 = (i_predec_iq_addr_1 + iq_imm_1);
wire [`CORE_PC_WIDTH - 1 : 0] iq_uc_taddr_2 = (i_predec_iq_addr_2 + iq_imm_2);
wire [`CORE_PC_WIDTH - 1 : 0] iq_uc_taddr_3 = (i_predec_iq_addr_3 + iq_imm_3);

assign o_iq_uc_flush = ( iq_uc_inst_3
                     |   iq_uc_inst_2
                     |   iq_uc_inst_1
                     |   iq_uc_inst_0
                     |   o_iq_bpu_alias_err) & (|i_predec_iq_vld);
assign o_iq_uc_taddr = ({`CORE_PC_WIDTH{o_iq_bpu_alias_err                                                                        }} & iq_alias_err_taddr)
                     | ({`CORE_PC_WIDTH{iq_uc_inst_0 & (~o_iq_bpu_alias_err)                                                      }} &      iq_uc_taddr_0)
                     | ({`CORE_PC_WIDTH{iq_uc_inst_1 & (~o_iq_bpu_alias_err) & (~iq_uc_inst_0)                                    }} &      iq_uc_taddr_1)
                     | ({`CORE_PC_WIDTH{iq_uc_inst_2 & (~o_iq_bpu_alias_err) & (~iq_uc_inst_0) & (~iq_uc_inst_1)                  }} &      iq_uc_taddr_2)
                     | ({`CORE_PC_WIDTH{iq_uc_inst_3 & (~o_iq_bpu_alias_err) & (~iq_uc_inst_0) & (~iq_uc_inst_1) & (~iq_uc_inst_2)}} &      iq_uc_taddr_3); 

assign o_iq_flush = (iq_btac_taken_3
                  |  iq_btac_taken_2 
                  |  iq_btac_taken_1 
                  |  iq_btac_taken_0) & (|i_predec_iq_vld);
assign o_iq_taddr = ({`CORE_PC_WIDTH{iq_btac_taken_0                                                               }} & o_btac_rdat_0[32 : 1])
                  | ({`CORE_PC_WIDTH{iq_btac_taken_1 & (~iq_btac_taken_0)                                          }} & o_btac_rdat_1[32 : 1])
                  | ({`CORE_PC_WIDTH{iq_btac_taken_2 & (~iq_btac_taken_0) & (~iq_btac_taken_1)                     }} & o_btac_rdat_2[32 : 1])
                  | ({`CORE_PC_WIDTH{iq_btac_taken_3 & (~iq_btac_taken_0) & (~iq_btac_taken_1) & (~iq_btac_taken_2)}} & o_btac_rdat_3[32 : 1]);

//
wire [1 : 0] iq_bpu_taken_pht_entry = ({2{((i_predec_iq_predinfo_bus[`PREDINFO_PHT_ENTRY] == PHT_WT)  & o_iq_bpu_taken)}} & PHT_ST )
                                    | ({2{((i_predec_iq_predinfo_bus[`PREDINFO_PHT_ENTRY] == PHT_WNT) & o_iq_bpu_taken)}} & PHT_WT )
                                    | ({2{((i_predec_iq_predinfo_bus[`PREDINFO_PHT_ENTRY] == PHT_SNT) & o_iq_bpu_taken)}} & PHT_WNT);

wire [1 : 0] iq_bpu_ntaken_pht_entry = ({2{((i_predec_iq_predinfo_bus[`PREDINFO_PHT_ENTRY] == PHT_ST)  & (~o_iq_bpu_taken))}} & PHT_WT )
                                     | ({2{((i_predec_iq_predinfo_bus[`PREDINFO_PHT_ENTRY] == PHT_WT)  & (~o_iq_bpu_taken))}} & PHT_WNT)
                                     | ({2{((i_predec_iq_predinfo_bus[`PREDINFO_PHT_ENTRY] == PHT_WNT) & (~o_iq_bpu_taken))}} & PHT_SNT);

assign o_iq_bpu_vld       = (o_iq_uc_flush | o_iq_flush);
assign o_iq_bpu_taken     = (iq_taken_0 | iq_taken_1 | iq_taken_2 | iq_taken_3) & (|i_predec_iq_vld);
assign o_iq_bpu_new_br    = (~(i_predec_iq_predinfo_bus[`PREDINFO_HIT]));
assign o_iq_bpu_type      = (~(o_iq_uc_flush | iq_btac_uc_taken));
assign o_iq_bpu_btb_idx   = (i_predec_iq_predinfo_bus[`PREDINFO_BTB_IDX]);
assign o_iq_bpu_btb_addr  = (i_predec_iq_predinfo_bus[`PREDINFO_ADDR]);
assign o_iq_bpu_btb_taddr = o_iq_uc_flush ? o_iq_uc_taddr
                          : o_iq_taddr;
assign o_iq_bpu_pht_idx   = (i_predec_iq_predinfo_bus[`PREDINFO_PHT_IDX]);
assign o_iq_bpu_pht_entry = o_iq_bpu_taken ? iq_bpu_taken_pht_entry
                          : iq_bpu_ntaken_pht_entry;
assign o_iq_bpu_tsucc     = (o_iq_bpu_btb_taddr == i_predec_iq_predinfo_bus[`PREDINFO_TADDR]);

endmodule   //  iq_module

`endif  /*  !__IQ_IQ_V__!   */