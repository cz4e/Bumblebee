`ifdef __EXU_MULDIV_V__

module exu_muldiv_module (
    input                                               i_csr_trap_flush,
    input                                               i_exu_mis_flush,
    input   [`ROB_ID_WIDTH - 1          : 0]            i_exu_mis_rob_id,
    input                                               i_exu_ls_flush,
    input   [`ROB_ID_WIDTH - 1          : 0]            i_exu_ls_rob_id,
    
    input                                               i_rsv_exu_vld,
    input                                               i_rsv_exu_src1_vld,
    input   [`PRF_DATA_WIDTH - 1        : 0]            i_rsv_exu_src1_dat,
    input                                               i_rsv_exu_src2_vld,
    input   [`PRF_DATA_WIDTH - 1        : 0]            i_rsv_exu_src2_dat,
    input                                               i_rsv_exu_src3_vld,
    input   [`PRF_DATA_WIDTH - 1        : 0]            i_rsv_exu_src3_dat,
    input                                               i_rsv_exu_dst_vld,
    input   [`PRF_CODE_WIDTH - 1        : 0]            i_rsv_exu_dst_code,
    input   [`DECINFO_WIDTH - 1         : 0]            i_rsv_exu_decinfo_bus,
    input   [`EXCEPTION_CODE_WIDTH - 1  : 0]            i_rsv_exu_excp_code,
    input   [`ROB_ID_WIDTH - 1          : 0]            i_rsv_exu_rob_id,
    
    output                                              o_exu_rsv_wren,
    output  [`PRF_CODE_WIDTH - 1        : 0]            o_exu_rsv_wr_prf_code,
    output  [`PRF_DATA_WIDTH - 1        : 0]            o_exu_rsv_wr_dat,
    output                                              o_exu_rsv_busy,
    output                                              o_exu_rob_vld,
    output  [`EXCEPTION_CODE_WIDTH - 1  : 0]            o_exu_rob_excp_code,
    output  [`ROB_ID_WIDTH - 1          : 0]            o_exu_rob_rob_id,

    input                                               clk,
    input                                               rst_n
);

wire exu_mis_ls_flush = (i_exu_mis_flush | i_exu_ls_flush);
wire exu_mis_ls_flush_both = (i_exu_mis_flush & i_exu_ls_flush);
wire [`ROB_ID_WIDTH - 1 : 0] exu_mis_ls_rob_id = exu_mis_ls_flush_both ? (func_rob_old(i_exu_mis_rob_id, i_exu_ls_rob_id) ? i_exu_mis_rob_id : i_exu_ls_rob_id)
                                               : i_exu_mis_flush ? i_exu_mis_rob_id
                                               : i_exu_ls_rob_id;

wire muldiv_idle_flush = (muldiv_sta_is_idle & i_rsv_exu_vld & (func_rob_old(exu_mis_ls_rob_id, i_rsv_exu_rob_id)));
wire muldiv_exec_flush = (muldiv_sta_is_exec & func_rob_old(exu_mis_ls_rob_id, muldiv_rob_id));

wire exu_need_flush = (muldiv_idle_flush | muldiv_exec_flush | i_csr_trap_flush);

//
wire muldiv_info_ena = muldiv_sta_eixt_idle;
wire [`MULDIV_INFO_WIDTH - 1 : 0] muldiv_info_r, muldiv_info_nxt;

assign muldiv_info_nxt = {
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
    .DATA_WIDTH   (`MULDIV_INFO_WIDTH)
) muldiv_info_dffl (muldiv_info_ena, muldiv_info_nxt, muldiv_info_r, clk, rst_n);

//
wire                                 muldiv_src1_vld;
wire [`PRF_DATA_WIDTH - 1       : 0] muldiv_src1_dat;
wire                                 muldiv_src2_vld;
wire [`PRF_DATA_WIDTH - 1       : 0] muldiv_src2_dat;
wire                                 muldiv_src3_vld;
wire [`PRF_DATA_WIDTH - 1       : 0] muldiv_src3_dat;
wire                                 muldiv_dst_vld;
wire [`PRF_CODE_WIDTH - 1       : 0] muldiv_dst_code;
wire [`IMM_WIDTH - 1            : 0] muldiv_imm;
wire [`ROB_ID_WIDTH - 1         : 0] muldiv_rob_id;
wire [`DECINFO_WIDTH - 1        : 0] muldiv_decinfo_bus;
wire [`CORE_PC_WIDTH - 1        : 0] muldiv_addr;
wire [`EXCEPTION_CODE_WIDTH - 1 : 0] muldiv_excp_code;

assign {
            muldiv_src1_vld
        ,   muldiv_src1_dat
        ,   muldiv_src2_vld
        ,   muldiv_src2_dat
        ,   muldiv_src3_vld
        ,   muldiv_src3_dat
        ,   muldiv_dst_vld
        ,   muldiv_dst_code
        ,   muldiv_imm
        ,   muldiv_rob_id
        ,   muldiv_decinfo_bus
        ,   muldiv_addr
        ,   muldiv_excp_code
} = muldiv_info_r;
//
wire muldiv_mul   = muldiv_decinfo_bus[`UOPINFO_MULDIV_MUL   ];
wire muldiv_mulh  = muldiv_decinfo_bus[`UOPINFO_MULDIV_MULH  ];
wire muldiv_mulhu = muldiv_decinfo_bus[`UOPINFO_MULDIV_MULHU ];
wire muldiv_mulhsu= muldiv_decinfo_bus[`UOPINFO_MULDIV_MULHSU];
wire muldiv_div   = muldiv_decinfo_bus[`UOPINFO_MULDIV_DIV   ];
wire muldiv_divu  = muldiv_decinfo_bus[`UOPINFO_MULDIV_DIVU  ];
wire muldiv_rem   = muldiv_decinfo_bus[`UOPINFO_MULDIV_REM   ];
wire muldiv_remu  = muldiv_decinfo_bus[`UOPINFO_MULDIV_REMU  ];
wire muldiv_ilgl  = i_rsv_exu_decinfo_bus[`UOPINFO_MULDIV_ILGL];

wire muldiv_excp = (|i_rsv_exu_excp_code);
wire muldiv_divisor_is_zero = (i_rsv_exu_src2_dat == `PRF_DATA_WIDTH'd0);
wire muldiv_ilegl_op = ((muldiv_div_op | muldiv_rem_op) & muldiv_divisor_is_zero)
wire muldiv_0cycle_inst = (muldiv_ilgl | muldiv_excp | muldiv_ilegl_op);

//
wire muldiv_mul_op = (muldiv_mul 
                   |  muldiv_mulh
                   |  muldiv_mulhu
                   |  muldiv_mulhsu);
wire muldiv_div_op = (muldiv_div | muldiv_divu);
wire muldiv_rem_op = (muldiv_rem | muldiv_remu);

wire muldiv_res_sel_hi = (muldiv_mulh
                       |  muldiv_mulhu
                       |  muldiv_mulhsu
                       |  muldiv_divu
                       |  muldiv_remu);
wire muldiv_res_sel_lo = (~muldiv_res_sel_hi);

wire muldiv_src1_sign = (muldiv_mulhu | muldiv_divu | muldiv_remu);
wire muldiv_src2_sign = (muldiv_mulhsu | muldiv_mulhu | muldiv_divu);
wire muldiv_src1_sign_bit = (muldiv_src1_sign ? muldiv_src1_dat[`PRF_DATA_WIDTH - 1] : 1'b0);
wire muldiv_src2_sign_bit = (muldiv_src2_sign ? muldiv_src2_dat[`PRF_DATA_WIDTH - 1] : 1'b0);


//
localparam  MULDIV_STATE_WIDTH = 2;
localparam  MULDIV_STATE_IDLE = 2'b01,
            MULDIV_STATE_EXEC = 2'b10;

wire [MULDIV_STATE_WIDTH - 1 : 0] muldiv_sta_cur_r, muldiv_sta_nxt;

wire muldiv_sta_is_idle = (muldiv_sta_cur_r == MULDIV_STATE_IDLE);
wire muldiv_sta_is_exec = (muldiv_sta_cur_r == MULDIV_STATE_EXEC);

wire muldiv_sta_exit_idle = (muldiv_sta_is_idle & i_rsv_exu_vld & (~muldiv_0cycle_inst) & (~exu_need_flush));
wire muldiv_sta_exit_exec = (muldiv_sta_is_exec & (muldiv_last_cycle | muldiv_exec_flush));

assign muldiv_sta_nxt = ({MULDIV_STATE_WIDTH{muldiv_sta_exit_idle}} & MULDIV_STATE_EXEC)
                      | ({MULDIV_STATE_WIDTH{muldiv_sta_exit_exec}} & MULDIV_STATE_IDLE);

wire muldiv_sta_ena = (muldiv_sta_exit_idle | muldiv_sta_exit_exec);

gnrl_dfflr #(
    .DATA_WIDTH   (MULDIV_STATE_WIDTH),
    .INITIAL_VALUE(MULDIV_STATE_IDLE)
) muldiv_sta_dfflr (muldiv_sta_ena, muldiv_sta_nxt, muldiv_sta_cur_r, clk, rst_n);

//
localparam  MULDIV_CTR_WIDTH = 6,
            MULDIV_CTR_0     = 6'd0,
            MULDIV_CTR_1     = 6'd1,
            MULDIV_CTR_16    = 6'd16,
            MULDIV_CTR_33    = 6'd33;

wire [MULDIV_CTR_WIDTH - 1 : 0] muldiv_ctr_r;
wire muldiv_ctr_set = muldiv_sta_exit_idle;
wire muldiv_ctr_inc = (muldiv_sta_is_exec & (~muldiv_last_cycle));
wire muldiv_ctr_ena = (muldiv_ctr_set | muldiv_ctr_inc);

wire [MULDIV_CTR_WIDTH - 1 : 0] muldiv_ctr_nxt = muldiv_ctr_set ? MULDIV_CTR_0 : (muldiv_ctr_r + 1'b1);

gnrl_dfflr #( 
    .DATA_WIDTH   (MULDIV_CTR_WIDTH),
    .INITIAL_VALUE(0)
) muldiv_ctr_dfflr (muldiv_ctr_ena, muldiv_ctr_nxt, muldiv_ctr_r, clk, rst_n);

wire muldiv_0th  = (muldiv_ctr_r == MULDIV_CTR_0);
wire muldiv_16th = (muldiv_ctr_r == MULDIV_CTR_16);
wire muldiv_33th = (muldiv_ctr_r == MULDIV_CTR_33);
wire muldiv_mul_last_cycle = muldiv_16th;
wire muldiv_div_last_cycle = muldiv_33th;
wire muldiv_last_cycle = (muldiv_mul_op ? muldiv_mul_last_cycle : muldiv_div_last_cycle);

wire muldiv_is_calculating = (muldiv_ctr_set | muldiv_ctr_inc);

//  Radix-4 Booth Coding
wire [32 : 0] part_prdt_hi_r;
wire [32 : 0] part_prdt_lo_r;
wire part_prdt_shift_r;

wire [2 : 0] booth_code = muldiv_0th  ? {muldiv_src1_dat[1 : 0], 1'b0}
                        : muldiv_16th ? {muldiv_src1_sign_bit, part_prdt_lo_r[0], part_prdt_shift_r}
                        : {part_prdt_lo_r[1 : 0], part_prdt_shift_r};

wire booth_code_scheme_zero = (booth_code == 3'b000) | (booth_code == 3'b111);
wire booth_code_scheme_two  = (booth_code == 3'b011) | (booth_code == 3'b100);
wire booth_code_scheme_one  = (~booth_code_scheme_zero) & (~booth_code_scheme_two);
wire booth_code_scheme_sub  = booth_code[2];

wire [`MULDIV_ADDER_WIDTH - 1 : 0] mul_exu_op_1 = muldiv_0th ? {`MULDIV_ADDER_WIDTH{1'b0}}
                                                : {part_prdt_hi_r[32], part_prdt_hi_r[32], part_prdt_hi_r};
wire [`MULDIV_ADDER_WIDTH - 1 : 0] mul_exu_op_2 = ({`MULDIV_ADDER_WIDTH{booth_code_scheme_zero}}    & {`MULDIV_ADDER_WIDTH{1'b0}})
                                                | ({`MULDIV_ADDER_WIDTH{booth_code_scheme_one }}    & {muldiv_src2_sign_bit, muldiv_src2_sign_bit, exu_src2_sign_bit, muldiv_src2_dat})
                                                | ({`MULDIV_ADDER_WIDTH{booth_code_scheme_two }}    & {muldiv_src2_sign_bit, muldiv_src2_sign_bit, muldiv_src2_dat, 1'b0});

wire [`MULDIV_ADDER_WIDTH - 1 : 0] mul_adder_op_1 = mul_exu_op_1;
wire [`MULDIV_ADDER_WIDTH - 1 : 0] mul_adder_op_2 = booth_code_scheme_sub ? (~mul_exu_op_2) : mul_exu_op_2;
wire [`MULDIV_ADDER_WIDTH - 1 : 0] mul_exu_res = mul_adder_op_1 + mul_adder_op_2 + booth_code_scheme_sub;

wire [32 : 0] part_prdt_hi_nxt = mul_exu_res[`MULDIV_ADDER_WIDTH - 1 : 2];
wire [32 : 0] part_prdt_lo_nxt = {
                                  mul_exu_res[1 : 0]
                                , (muldiv_0th ? {muldiv_src1_sign_bit, muldiv_src1_dat[31 : 2]} : part_prdt_lo_r[32 : 2])
                              };

wire part_prdt_hi_ena = exu_is_calculating & exu_mul_op;
gnrl_dffl #(
  .DATA_WIDTH(33)
) part_prdt_hi_dffl (part_prdt_hi_ena, part_prdt_hi_nxt, part_prdt_hi_r, clk);

wire part_prdt_lo_ena = part_prdt_hi_ena;
gnrl_dffl #(
  .DATA_WIDTH(33)
) part_prdt_lo_dffl (part_prdt_lo_ena, part_prdt_lo_nxt, part_prdt_lo_r, clk);

wire part_prdt_shift_ena = part_prdt_lo_ena;
wire part_prdt_shift_nxt = exu_muldiv_0th ? muldiv_src1_dat[1] : part_prdt_lo_r[1];
gnrl_dfflr #(
  .DATA_WIDTH   (1),
  .INITIAL_VALUE(0)
) part_prdt_shift_dfflr (part_prdt_shift_ena, part_prdt_shift_nxt, part_prdt_shift_r, clk, rst_n);


//  Dividor
wire [`PRF_DATA_WIDTH - 1 : 0] part_quot_r, part_remd_r;

wire [`PRF_DATA_WIDTH - 1 : 0] muldiv_div_divident = muldiv_src1_sign_bit ? (~muldiv_src1_dat + 1'b1) : muldiv_src1_dat;
wire [`PRF_DATA_WIDTH - 1 : 0] muldiv_div_divisor = muldiv_src2_sign_bit ? (~muldiv_src2_dat + 1'b1) : muldiv_src2_dat;
wire [`PRF_DATA_WIDTH : 0] muldiv_div_diff = ({part_remd_r[`PRF_DATA_WIDTH - 2 : 0], part_quot_r[`PRF_DATA_WIDTH - 1]} - muldiv_div_divisor);

wire part_quot_ena = muldiv_is_calculating & (muldiv_div_op | muldiv_rem_op);
wire [`PRF_DATA_WIDTH - 1 : 0] part_quot_nxt = muldiv_0th ? muldiv_div_divident : {part_quot_r[`PRF_DATA_WIDTH - 2 : 0], ~muldiv_div_diff[`PRF_DATA_WIDTH]};

gnrl_dfflr #(
  .DATA_WIDTH   (`PRF_DATA_WIDTH),
  .INITIAL_VALUE(0)
) part_quot_dfflr (part_quot_ena, part_quot_nxt, part_quot_r, clk, rst_n);

wire part_remd_ena = part_quot_ena;
wire [`PRF_DATA_WIDTH - 1 : 0] part_remd_nxt = muldiv_0th ? {`PRF_DATA_WIDTH{1'b0}}
                                             : muldiv_div_diff[`PRF_DATA_WIDTH] ? {part_remd_r[`PRF_DATA_WIDTH - 2 : 0], part_quot_r[`PRF_DATA_WIDTH - 1]}
                                             : muldiv_div_diff[`PRF_DATA_WIDTH - 1 : 0];
gnrl_dfflr #(
  .DATA_WIDTH   (`PRF_DATA_WIDTH),
  .INITIAL_VALUE(0)
) part_remd_dfflr (part_remd_ena, part_remd_nxt, part_remd_r, clk, rst_n);

wire [`PRF_DATA_WIDTH - 1 : 0] muldiv_div_quot_res = (muldiv_src1_sign_bit ^ muldiv_src2_sign_bit) ? (~part_quot_r + 1'b1) : part_quot_r;
wire [`PRF_DATA_WIDTH - 1 : 0] muldiv_div_remd_res = muldiv_src1_sign_bit ? (~part_remd_r + 1'b1) : part_remd_r;

//  Result
assign o_exu_rob_vld      = (muldiv_last_cycle & (~muldiv_ilgl));
assign o_exu_rob_excp_code= muldiv_0cycle_inst ? i_rsv_exu_excp_code
                          : muldiv_excp_code;

assign o_exu_rsv_wren        = (muldiv_dst_vld & muldiv_last_cycle);
assign o_exu_rsv_wr_prf_code = muldiv_dst_code;
assign o_exu_rsv_wr_dat      = ({`PRF_DATA_WIDTH{muldiv_mul_op & muldiv_mul_res_sel_hi}}  & mul_exu_res[31 : 0]   )
                             | ({`PRF_DATA_WIDTH{muldiv_mul_op & muldiv_mul_res_sel_lo}}  & part_prdt_lo_r[32 : 1])
                             | ({`PRF_DATA_WIDTH{muldiv_div_op                        }}  & muldiv_div_quot_res   )
                             | ({`PRF_DATA_WIDTH{muldiv_rem_op                        }}  & muldiv_div_remd_res   );
assign o_exu_rsv_busy = muldiv_sta_is_idle;

//  Functions
function func_rob_old;
    input [7 : 0]   func_rob_id0;
    input [7 : 0]   func_rob_id1;
    //  If func_rob_id0 OLDER than func_rob_id1, return HIGH level;
    func_rob_old = (func_rob_id0[7] ^ func_rob_id1[7]) ? (func_rob_id0[6 : 0] >= func_rob_id1[6 : 0])
                 : (func_rob_id0[6 : 0] < func_rob_id1[6 : 0]);
endfunction

endmodule   //  exu_muldiv_module

`endif  /*  !__EXU_MULDIV_V__!  */