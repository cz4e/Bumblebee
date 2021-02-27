`ifdef __EXU_EXU_BJP_V__

module bjp_module (
    input                                                       i_csr_trap_flush,
    input                                                       i_exu_ls_flush,
    input   [`ROB_ID_WIDTH - 1          : 0]                    i_exu_ls_rob_id,

    input                                                       i_rsv_exu_vld,
    input   [`ROB_ID_WIDTH - 1          : 0]                    i_rsv_exu_rob_id,
    input   [`EXCEPTION_CODE_WIDTH - 1  : 0]                    i_rsv_exu_excp_code,
    input                                                       i_rsv_exu_src1_vld,
    input   [`PRF_DATA_WIDTH - 1        : 0]                    i_rsv_exu_src1_dat,
    input                                                       i_rsv_exu_src2_vld,
    input   [`PRF_DATA_WIDTH - 1        : 0]                    i_rsv_exu_src2_dat,
    input                                                       i_rsv_exu_src3_vld,
    input   [`PRF_DATA_WIDTH - 1        : 0]                    i_rsv_exu_src3_dat,
    input                                                       i_rsv_exu_dst_vld,
    input   [`PRF_CODE_WIDTH - 1        : 0]                    i_rsv_exu_dst_code,
    input   [`IMM_WIDTH - 1             : 0]                    i_rsv_exu_imm,
    input   [`DECINFO_WIDTH - 1         : 0]                    i_rsv_exu_decinfo_bus,
    input   [`PREDINFO_WIDTH - 1        : 0]                    i_rsv_exu_predinfo_bus,
    input                                                       i_rsv_exu_len,
    input   [`CORE_PC_WIDTH - 1         : 0]                    i_rob_exu_addr,
    input   [`CORE_PC_WIDTH - 1         : 0]                    i_rob_exu_taddr,

    output                                                      o_exu_rsv_wren,
    output  [`PRF_CODE_WIDTH - 1        : 0]                    o_exu_rsv_wr_prf_code,
    output  [`PRF_DATA_WIDTH - 1        : 0]                    o_exu_rsv_wr_dat,
    output                                                      o_exu_rsv_busy,
    output                                                      o_exu_rob_vld,
    output  [`EXCEPTION_CODE_WIDTH - 1  : 0]                    o_exu_rob_excp_code,
    output  [`ROB_ID_WIDTH - 1          : 0]                    o_exu_rob_rob_id,
    output                                                      o_exu_mis_flush,
    output  [`ROB_ID_WIDTH - 1          : 0]                    o_exu_mis_rob_id,
    output  [`CORE_PC_WIDTH - 1         : 0]                    o_exu_mis_addr,
    output                                                      o_exu_iq_btac_vld,
    output                                                      o_exu_iq_btac_taken,
    output                                                      o_exu_iq_btac_new_br,
    output                                                      o_exu_iq_type,
    output  [`CORE_PC_WIDTH - 1         : 0]                    o_exu_iq_btac_addr,
    output  [`CORE_PC_WIDTH - 1         : 0]                    o_exu_iq_btac_taddr,
    output  [1                          : 0]                    o_exu_iq_btac_idx,
    output  [11                         : 0]                    o_exu_iq_pht_idx,
    output  [1                          : 0]                    o_exu_iq_pht_status,
    output                                                      o_exu_iq_len,
    output                                                      o_exu_iq_tsucc,

    input                                                       clk,
    input                                                       rst_n
);

wire exu_idle_ls_flush = (func_rob_old(i_exu_ls_rob_id, i_rsv_exu_rob_id) & i_rsv_exu_vld);
wire exu_exec_ls_flush = (func_rob_old(i_exu_ls_rob_id, bjp_rob_id));

//
wire bjp_info_ena = bjp_sta_exit_idle;
wire [`BJP_INFO_WIDTH - 1 : 0] bjp_info_r, bjp_info_nxt;

assign bjp_info_nxt = {
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
                        ,   i_rsv_exu_predinfo_bus
                        ,   i_rsv_exu_excp_code
                        ,   i_rsv_exu_len
                        ,   i_rob_exu_addr
                        ,   i_rob_exu_taddr
                    };

gnrl_dffl #(
    .DATA_WIDTH(`BJP_INFO_WIDTH)
) bjp_info_dffl (bjp_info_ena, bjp_info_nxt, bjp_info_r, clk, rst_n);


//
wire                                 bjp_src1_vld;
wire [`PRF_DATA_WIDTH - 1       : 0] bjp_src1_dat;
wire                                 bjp_src2_vld;
wire [`PRF_DATA_WIDTH - 1       : 0] bjp_src2_dat;
wire                                 bjp_src3_vld;
wire [`PRF_DATA_WIDTH - 1       : 0] bjp_src3_dat;
wire                                 bjp_dst_vld;
wire [`PRF_CODE_WIDTH - 1       : 0] bjp_dst_code;
wire [`IMM_WIDTH - 1            : 0] bjp_imm;
wire [`ROB_ID_WIDTH - 1         : 0] bjp_rob_id;
wire [`DECINFO_WIDTH - 1        : 0] bjp_decinfo_bus;
wire [`PREDINFO_WIDTH - 1       : 0] bjp_predinfo_bus;
wire [`EXCEPTION_CODE_WIDTH - 1 : 0] bjp_excp_code;
wire                                 bjp_len;
wire [`CORE_PC_WIDTH - 1        : 0] bjp_addr;
wire [`CORE_PC_WIDTH - 1        : 0] bjp_taddr;

assign {
            bjp_src1_vld
        ,   bjp_src1_dat
        ,   bjp_src2_vld
        ,   bjp_src2_dat
        ,   bjp_src3_vld
        ,   bjp_src3_dat
        ,   bjp_dst_vld
        ,   bjp_dst_code
        ,   bjp_imm
        ,   bjp_rob_id
        ,   bjp_decinfo_bus
        ,   bjp_predinfo_bus
        ,   bjp_excp_code
        ,   bjp_len
        ,   bjp_addr
        ,   bjp_taddr
} = bjp_info_r;

//  Control 
localparam  BJP_STATE_WIDTH = 2;
localparam  BJP_STATE_IDLE = 2'd1,
            BJP_STATE_EXEC = 2'd2;

wire [BJP_STATE_WIDTH - 1 : 0] bjp_sta_cur_r, bjp_sta_nxt;

wire bjp_sta_is_idle = (bjp_sta_cur_r == BJP_STATE_IDLE);
wire bjp_sta_is_exec = (bjp_sta_cur_r == BJP_STATE_EXEC);

wire bjp_need_exec = ((~exu_idle_ls_flush) & (~bjp_0cycle_inst));

wire bjp_sta_exit_idle = (bjp_sta_is_idle & bjp_need_exec);
wire bjp_sta_exit_exec = (bjp_sta_is_exec & (o_exu_rob_done | exu_exec_ls_flush));

assign bjp_sta_nxt = ({BJP_STATE_WIDTH{bjp_sta_exit_idle}} & BJP_STATE_EXEC)
                   | ({BJP_STATE_WIDTH{bjp_sta_exit_exec}} & BJP_STATE_IDLE);

wire bjp_sta_ena = (bjp_sta_exit_idle | bjp_sta_exit_exec);

gnrl_dfflr #( 
    .DATA_WIDTH   (BJP_STATE_WIDTH),
    .INITIAL_VALUE(BJP_STATE_IDLE)
) bjp_sta_dfflr (bjp_sta_ena, bjp_sta_nxt, bjp_sta_cur_r, clk, rst_n);

//  Extract instruction's info.
wire bjp_jmp  = bjp_decinfo_bus[`UOPINFO_BJP_JUMP];
wire bjp_beq  = bjp_decinfo_bus[`UOPINFO_BJP_BEQ ];
wire bjp_bne  = bjp_decinfo_bus[`UOPINFO_BJP_BNE ];
wire bjp_blt  = bjp_decinfo_bus[`UOPINFO_BJP_BLT ];
wire bjp_bltu = bjp_decinfo_bus[`UOPINFO_BJP_BLTU];
wire bjp_bge  = bjp_decinfo_bus[`UOPINFO_BJP_BGE ];
wire bjp_bgeu = bjp_decinfo_bus[`UOPINFO_BJP_BGEU];
wire bjp_bxx  = bjp_decinfo_bus[`UOPINFO_BJP_BXX ];
wire bjp_mret = i_rsv_exu_decinfo_bus[`UOPINFO_BJP_MRET];
wire bjp_sret = i_rsv_exu_decinfo_bus[`UOPINFO_BJP_SRET];
wire bjp_uret = i_rsv_exu_decinfo_bus[`UOPINFO_BJP_URET];
wire bjp_ilgl = i_rsv_exu_decinfo_bus[`UOPINFO_BJP_ILGL];

wire bjp_excp = (|i_rsv_exu_excp_code);

wire bjp_0cycle_inst = (bjp_mret
                    |   bjp_sret
                    |   bjp_uret
                    |   bjp_ilgl
                    |   bjp_excp);

//  Counter
localparam  BJP_CTR_WIDTH = 1;
localparam  BJP_CTR_0 = 1'd0,
            BJP_CTR_1 = 1'd1;

wire [BJP_CTR_WIDTH - 1 : 0] bjp_ctr_r, bjp_ctr_nxt;
wire bjp_ctr_set = bjp_sta_exit_idle;
wire bjp_ctr_inc = (~bjp_last_cycle);
wire bjp_ctr_ena = (bjp_ctr_set | bjp_ctr_inc);

assign bjp_ctr_nxt = bjp_ctr_set ? BJP_CTR_0
                   : (bjp_ctr_r + 1'b1);

gnrl_dfflr #(
    .DATA_WIDTH   (BJP_CTR_WIDTH),
    .INITIAL_VALUE(0)
) bjp_ctr_dfflr (bjp_ctr_ena, bjp_ctr_nxt, bjp_ctr_r, clk, rst_n);

wire bjp_1th = (bjp_ctr_r == BJP_CTR_1);
wire bjp_last_cycle = (bjp_0cycle_inst | bjp_1th);



//  Generate Target Address.
wire [31 : 0] bjp_taddr_adder_op_1 = (bjp_bxx | (bjp_jmp & bjp_src1_vld)) ? bjp_src1_dat
                                   : bjp_addr;
wire [31 : 0] bjp_taddr_adder_op_2 = bjp_taddr_adder_sub ? (~bjp_imm) : bjp_imm;
wire [31 : 0] bjp_taddr_addr_res   = bjp_taddr_adder_op_1 + bjp_taddr_adder_op_2;

//  Generate PC Address
wire [`CORE_PC_WIDTH - 1 : 0] bjp_pc_addr  = (bjp_addr + {{29{1'b0}}, i_rsv_exu_len, (~i_rsv_exu_len), 1'b0});

//  Branch instructions
wire bjp_cmp_eq  = (i_rsv_exu_src1_dat == i_rsv_exu_src2_dat);
wire bjp_cmp_lt  = ($signed(i_rsv_exu_src1_dat) < $signed(i_rsv_exu_src2_dat));
wire bjp_cmp_ltu = (i_rsv_exu_src1_dat < i_rsv_exu_src2_dat);

wire bjp_cmp_ne  = (~bjp_cmp_eq);
wire bjp_cmp_ge  = bjp_cmp_ne & (~bjp_cmp_lt );
wire bjp_cmp_geu = bjp_cmp_ne & (~bjp_cmp_ltu);

wire bjp_cmp = (bjp_cmp_eq  & bjp_beq )
             | (bjp_cmp_ne  & bjp_bne )
             | (bjp_cmp_lt  & bjp_blt )
             | (bjp_cmp_ltu & bjp_bltu)
             | (bjp_cmp_ge  & bjp_bge )
             | (bjp_cmp_geu & bjp_bgeu);
wire bjp_ncmp = ((~bjp_cmp) & bjp_bxx);
//

wire bjp_taken  = bjp_predinfo_bus[0];
wire bjp_ntaken = (~bjp_taken);

//  Check if need flush
wire bjp_mispred = ((bjp_taddr_addr_res != bjp_taddr) 
                 &  (bjp_jmp | (bjp_cmp & bjp_taken)));

assign o_exu_mis_flush = (bjp_mispred | (bjp_cmp ^ bjp_taken));
assign o_exu_mis_rob_id= i_rsv_exu_rob_id;
assign o_exu_mis_addr  = (({`CORE_PC_WIDTH{bjp_ncmp & bjp_taken                }}       & bjp_pc_addr        )
                       |  ({`CORE_PC_WIDTH{(bjp_cmp & bjp_ntaken) | bjp_mispred}}       & bjp_taddr_addr_res ));

//  Forword info
assign o_exu_rsv_wren     = (bjp_sta_is_exec & bjp_dst_vld & (~exu_exec_ls_flush));
assign o_exu_rsv_wr_dat     = bjp_pc_addr;
assign o_exu_rsv_wr_prf_code= bjp_dst_code;
assign o_exu_rsv_busy       = bjp_sta_is_idle;

//  
assign o_exu_rob_vld       = ((bjp_0cycle_inst | alu_sta_is_exec) & (~exu_exec_ls_flush));
assign o_exu_rob_excp_code = bjp_excp_code;
assign o_exu_rob_rob_id    = bjp_rob_id;

//  BTAC
assign o_exu_iq_btac_vld    = (bjp_last_cycle & (~exu_exec_ls_flush));
assign o_exu_iq_btac_taken  = (bjp_cmp | bjp_jmp);
assign o_exu_iq_btac_new_br = (~bjp_predinfo_bus[18]);
assign o_exu_iq_type        = bjp_jmp;
assign o_exu_iq_btac_addr   = bjp_addr;
assign o_exu_iq_btac_taddr= bjp_taddr_addr_res;
assign o_exu_iq_btac_idx    = bjp_predinfo_bus[16 : 15];
assign o_exu_iq_pht_idx     = bjp_predinfo_bus[14 : 4];
assign o_exu_iq_pht_status  = bjp_predinfo_bus[3 : 2];
assign o_exu_iq_len         = bjp_len;
assign o_exu_iq_tsucc       = ((bjp_taddr_addr_res == bjp_taddr) & bjp_cmp & bjp_taken) | (bjp_ncmp & bjp_ntaken) ;

//  Functions
function func_rob_old;
    input [7 : 0]   func_rob_id0;
    input [7 : 0]   func_rob_id1;
    //  If func_rob_id0 OLDER than func_rob_id1, return HIGH level;
    func_rob_old = (func_rob_id0[7] ^ func_rob_id1[7]) ? (func_rob_id0[6 : 0] >= func_rob_id1[6 : 0])
                 : (func_rob_id0[6 : 0] < func_rob_id1[6 : 0]);
endfunction

endmodule   //  bjp_module

`endif  /*  !__EXU_EXU_BJP_V__! */