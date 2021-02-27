`ifdef __DISPATCH_DSP_GEN_V__

module dsp_gen_module (
    input                                           i_csr_trap_flush,
    input                                           i_exu_mis_flush,
    input   [`ROB_ID_WIDTH - 1          : 0]        i_exu_mis_rob_id,
    input                                           i_exu_ls_flush,
    input   [`ROB_ID_WIDTH - 1          : 0]        i_exu_ls_rob_id,
    input                                           i_dsp_gen_mis_ld_vld,
    input   [`LOAD_BUFFER_ID_WIDTH - 1  : 0]        i_dsp_gen_mis_ld_id,
    input                                           i_dsp_gen_mis_st_vld,
    input   [`STORE_BUFFER_ID_WIDTH - 1 : 0]        i_dsp_gen_mis_st_id,
    input                                           i_dsp_gen_stall,


    input   [3                          : 0]        i_dsp_gen_vld,
    input   [3                          : 0]        i_dsp_gen_ld_vld,
    input   [3                          : 0]        i_dsp_gen_st_vld,
    input   [3                          : 0]        i_dsp_gen_ret_vld,
    input   [3                          : 0]        i_dsp_gen_ret_ld_vld,
    input   [3                          : 0]        i_dsp_gen_ret_st_vld,
    input                                           i_dsp_gen_s_ret,

    output  [`ROB_ID_WIDTH - 1          : 0]        o_dsp_gen_rob_id_0,
    output  [`ROB_ID_WIDTH - 1          : 0]        o_dsp_gen_rob_id_1,
    output  [`ROB_ID_WIDTH - 1          : 0]        o_dsp_gen_rob_id_2,
    output  [`ROB_ID_WIDTH - 1          : 0]        o_dsp_gen_rob_id_3,
    output  [`ROB_ID_WIDTH - 1          : 0]        o_dsp_gen_rob_dsp_id,
    output  [`ROB_ID_WIDTH - 1          : 0]        o_dsp_gen_rob_ret_id,
    output  [`LOAD_BUFFER_ID_WIDTH - 1  : 0]        o_dsp_gen_lbuff_id_0,
    output  [`LOAD_BUFFER_ID_WIDTH - 1  : 0]        o_dsp_gen_lbuff_id_1,
    output  [`LOAD_BUFFER_ID_WIDTH - 1  : 0]        o_dsp_gen_lbuff_id_2,
    output  [`LOAD_BUFFER_ID_WIDTH - 1  : 0]        o_dsp_gen_lbuff_id_3,
    output  [`LOAD_BUFFER_ID_WIDTH - 1  : 0]        o_dsp_gen_ldq_dsp_id,
    output  [`LOAD_BUFFER_ID_WIDTH - 1  : 0]        o_dsp_gen_ldq_ret_id,
    output  [`STORE_BUFFER_ID_WIDTH - 1 : 0]        o_dsp_gen_sbuff_id_0,
    output  [`STORE_BUFFER_ID_WIDTH - 1 : 0]        o_dsp_gen_sbuff_id_1,
    output  [`STORE_BUFFER_ID_WIDTH - 1 : 0]        o_dsp_gen_sbuff_id_2,
    output  [`STORE_BUFFER_ID_WIDTH - 1 : 0]        o_dsp_gen_sbuff_id_3,
    output  [`STORE_BUFFER_ID_WIDTH - 1 : 0]        o_dsp_gen_stq_dsp_id,
    output  [`STORE_BUFFER_ID_WIDTH - 1 : 0]        o_dsp_gen_stq_ret_id,
    output  [`STORE_BUFFER_ID_WIDTH - 1 : 0]        o_dsp_gen_stq_rec_id,

    output                                          o_dsp_gen_robid_list_empty,
    output                                          o_dsp_gen_ldq_list_empty,
    output                                          o_dsp_gen_stq_list_empty,

    input                                           clk,
    input                                           rst_n
);

wire i_exu_mis_ls_flush = (i_exu_mis_flush | i_exu_ls_flush);

wire exu_mis_ls_flush_both = (i_exu_mis_flush & i_exu_ls_flush);

wire [`ROB_ID_WIDTH - 1 : 0] i_exu_mis_ls_rob_id = exu_mis_ls_flush_both ? (func_rob_old(i_exu_mis_rob_id, i_exu_ls_rob_id) ? i_exu_mis_rob_id : i_exu_ls_rob_id)
                                                 : i_exu_mis_flush ? i_exu_mis_rob_id
                                                 : i_exu_ls_rob_id;

//  ROB ID GEN
dsp_robid_module dsp_robid (
    .i_csr_trap_flush      (i_csr_trap_flush),
    .i_exu_mis_ls_flush    (i_exu_mis_ls_flush),
    .i_exu_mis_ls_rob_id   (i_exu_mis_ls_rob_id),
    .i_dsp_robid_stall     (i_dsp_gen_stall),
    .i_dsp_robid_req_vld   (i_dsp_gen_vld),
    .o_dsp_robid_id_0      (o_dsp_gen_rob_id_0),
    .o_dsp_robid_id_1      (o_dsp_gen_rob_id_1),
    .o_dsp_robid_id_2      (o_dsp_gen_rob_id_2),
    .o_dsp_robid_id_3      (o_dsp_gen_rob_id_3),
    .o_dsp_robid_dsp_id    (o_dsp_gen_rob_dsp_id),
    .o_dsp_robid_ret_id    (o_dsp_gen_rob_ret_id),
    .o_dsp_robid_list_empty(o_dsp_gen_robid_list_empty),
    .i_dsp_robid_ret_vld   (i_dsp_gen_ret_vld),
    .clk                   (clk),
    .rst_n                 (rst_n)
);

//  LD ID GEN
dsp_ldq_module dsp_ldq (
    .i_csr_trap_flush        (i_csr_trap_flush),
    .i_exu_mis_flush         (i_exu_mis_flush),
    .i_exu_ls_flush          (i_exu_ls_flush),
    .i_rob_mis_ld_vld        (i_dsp_gen_mis_ld_vld),
    .i_rob_mis_ld_id         (i_dsp_gen_mis_ld_id),
    .i_dsp_ldq_stall         (i_dsp_gen_stall),
    .i_dsp_ldq_req_vld       (i_dsp_gen_ld_vld),
    .o_dsp_ldq_req_lbuff_id_0(o_dsp_gen_lbuff_id_0),
    .o_dsp_ldq_req_lbuff_id_1(o_dsp_gen_lbuff_id_1),
    .o_dsp_ldq_req_lbuff_id_2(o_dsp_gen_lbuff_id_2),
    .o_dsp_ldq_req_lbuff_id_3(o_dsp_gen_lbuff_id_3),
    .o_dsp_ldq_req_dsp_id    (o_dsp_gen_ldq_dsp_id),
    .o_dsp_ldq_req_ret_id    (o_dsp_gen_ldq_ret_id),
    .o_dsp_ldq_list_empty    (o_dsp_gen_ldq_list_empty),

    .i_dsp_ldq_ret_vld       (i_dsp_gen_ret_ld_vld),
    .clk                     (clk),
    .rst_n                   (rst_n)
);

//  ST ID GEN
dsp_stq_module dsp_stq (
    .i_csr_trap_flush        (i_csr_trap_flush),
    .i_exu_mis_flush         (i_exu_mis_flush),
    .i_exu_ls_flush          (i_exu_ls_flush),
    .i_rob_mis_st_vld        (i_dsp_gen_mis_st_vld),
    .i_rob_mis_st_id         (i_dsp_gen_mis_st_id),
    .i_dsp_stq_stall         (i_dsp_gen_stall),
    .i_dsp_stq_req_vld       (i_dsp_gen_st_vld),
    .o_dsp_stq_req_sbuff_id_0(o_dsp_gen_sbuff_id_0),
    .o_dsp_stq_req_sbuff_id_1(o_dsp_gen_sbuff_id_1),
    .o_dsp_stq_req_sbuff_id_2(o_dsp_gen_sbuff_id_2),
    .o_dsp_stq_req_sbuff_id_3(o_dsp_gen_sbuff_id_3),
    .o_dsp_stq_req_dsp_id    (o_dsp_gen_stq_dsp_id),
    .o_dsp_stq_req_ret_id    (o_dsp_gen_stq_ret_id),
    .o_dsp_stq_req_rec_id    (o_dsp_gen_stq_rec_id),
    .o_dsp_stq_list_empty    (o_dsp_gen_stq_list_empty),

    .i_exu_dsp_s_ret         (i_dsp_gen_s_ret),
    .i_dsp_stq_ret_vld       (i_dsp_gen_ret_st_vld),
    .clk                     (clk),
    .rst_n                   (rst_n)
);

//  Functions
function func_rob_old;
    input       [7 : 0] rob_id_a;
    input       [7 : 0] rob_id_b;

    func_rob_old = (rob_id_a[7] ^ rob_id_b[7]) ? (rob_id_a[6 : 0] >= rob_id_b[6 : 0])
                 : (rob_id_a[6 : 0] < rob_id_b[6 : 0]);
    
endfunction

endmodule   //  dsp_gen_module

`endif  /*  !__DISPATCH_DSP_GEN_V__!   */
