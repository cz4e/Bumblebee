`ifdef __DISPATCH_DSP_STQ_V__

module dsp_stq_module (
    input                                                   i_csr_trap_flush,
    input                                                   i_exu_ls_flush,
    input                                                   i_exu_mis_flush,
    input                                                   i_rob_mis_st_vld,
    input   [`SBUFF_ID_WIDTH - 1        : 0]                i_rob_mis_st_id,
    input                                                   i_dsp_stq_stall,

    input   [3                          : 0]                i_dsp_stq_req_vld,
    output  [`SBUFF_ID_WIDTH - 1        : 0]                o_dsp_stq_req_sbuff_id_0,
    output  [`SBUFF_ID_WIDTH - 1        : 0]                o_dsp_stq_req_sbuff_id_1,
    output  [`SBUFF_ID_WIDTH - 1        : 0]                o_dsp_stq_req_sbuff_id_2,
    output  [`SBUFF_ID_WIDTH - 1        : 0]                o_dsp_stq_req_sbuff_id_3,
    output  [`SBUFF_ID_WIDTH - 1        : 0]                o_dsp_stq_req_dsp_id,
    output  [`SBUFF_ID_WIDTH - 1        : 0]                o_dsp_stq_req_ret_id,
    output  [`SBUFF_ID_WIDTH - 1        : 0]                o_dsp_stq_req_rec_id,

    output                                                  o_dsp_stq_list_empty,

    input                                                   i_exu_dsp_s_ret,
    input   [3                          : 0]                i_dsp_stq_ret_vld,

    input                                                   clk,
    input                                                   rst_n
);

wire stq_need_flush = ((i_exu_ls_flush | i_exu_mis_flush) & i_rob_mis_st_vld);

//
localparam  STID_POOL = 6'd32;

wire [`SBUFF_ID_WIDTH - 1 : 0] stq_wr_ptr_r, stq_rd_ptr_r, stq_rec_ptr_r;

//
wire [2 : 0] wr_nums = {2'b0, i_dsp_stq_req_vld[3]}
                     + {2'b0, i_dsp_stq_req_vld[2]}
                     + {2'b0, i_dsp_stq_req_vld[1]}
                     + {2'b0, i_dsp_stq_req_vld[0]};
wire [2 : 0] rd_nums = {2'b0, i_dsp_stq_ret_vld[3]}
                     + {2'b0, i_dsp_stq_ret_vld[2]}
                     + {2'b0, i_dsp_stq_ret_vld[1]}
                     + {2'b0, i_dsp_stq_ret_vld[0]};

//
wire stq_need_req = (|i_dsp_stq_req_vld);
wire stq_need_ret = (|i_dsp_stq_ret_vld);


//  Modify stq_wr_ptr_r;
wire stq_wr_ptr_ena = (((stq_need_req & (~o_dsp_stq_list_empty)) & (~i_dsp_stq_stall)) | stq_need_flush | i_csr_trap_flush);
wire [`SBUFF_ID_WIDTH - 1 : 0] stq_wr_ptr_nxt = i_csr_trap_flush ? `SBUFF_ID_WIDTH'd0
                                                     : stq_need_flush ? i_rob_mis_st_id
                                                     : (stq_wr_ptr_r + wr_nums);

gnrl_dfflr #(
    .DATA_WIDTH   (`SBUFF_ID_WIDTH),
    .INITIAL_VALUE(0)
) stq_wr_ptr_dfflr (stq_wr_ptr_ena, stq_wr_ptr_nxt, stq_wr_ptr_r, clk, rst_n);

//  Modify stq_rd_ptr_r
wire stq_rd_ptr_ena = (i_exu_dsp_s_ret | i_csr_trap_flush);
wire [`SBUFF_ID_WIDTH - 1 : 0] stq_rd_ptr_nxt = i_csr_trap_flush ? `SBUFF_ID_WIDTH'd0
                                                     : (stq_rd_ptr_r + {5'd0, i_exu_dsp_s_ret});

gnrl_dfflr #(
    .DATA_WIDTH   (`SBUFF_ID_WIDTH),
    .INITIAL_VALUE(0)
) stq_rd_ptr_dfflr (stq_rd_ptr_ena, stq_rd_ptr_nxt, stq_rd_ptr_r, clk, rst_n);

//  Modify stq_rec_ptr_r
wire stq_rec_ptr_ena = (stq_need_ret | i_csr_trap_flush);
wire [`SBUFF_ID_WIDTH - 1 : 0] stq_rec_ptr_nxt = i_csr_trap_flush ? `SBUFF_ID_WIDTH'd0
                                                      : (stq_rec_ptr_r + rd_nums);
gnrl_dfflr #(
    .DATA_WIDTH   (`SBUFF_ID_WIDTH),
    .INITIAL_VALUE(0)
) stq_rec_ptr_dfflr (stq_rec_ptr_ena, stq_rec_ptr_nxt, stq_rec_ptr_r, clk, rst_n);


//
wire [5 : 0] stq_free_nums = (STID_POOL - (stq_wr_ptr_r - stq_rd_ptr_r));
assign o_dsp_stq_list_empty = (stq_free_nums < {3'b0, wr_nums});

//
assign o_dsp_stq_req_sbuff_id_0 = stq_wr_ptr_r;
assign o_dsp_stq_req_sbuff_id_1 = (stq_wr_ptr_r + {5'b0, i_dsp_stq_req_vld[0]});
assign o_dsp_stq_req_sbuff_id_2 = (stq_wr_ptr_r + {5'b0, i_dsp_stq_req_vld[0]} + {5'b0, i_dsp_stq_req_vld[1]});
assign o_dsp_stq_req_sbuff_id_3 = (stq_wr_ptr_r + {5'b0, i_dsp_stq_req_vld[0]} + {5'b0, i_dsp_stq_req_vld[1]} + {5'b0, i_dsp_stq_req_vld[2]});
assign o_dsp_stq_req_dsp_id     = stq_wr_ptr_r;
assign o_dsp_stq_req_ret_id     = stq_rd_ptr_r;
assign o_dsp_stq_req_rec_id     = stq_rec_ptr_r;

endmodule   //  dsp_stq_module

`endif  /*  !__DISPATCH_DSP_STQ_V__!    */