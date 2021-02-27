`ifdef __DISPATCH_DSP_LDQ_V__ 

module dsp_ldq_module (
    input                                                   i_csr_trap_flush,
    input                                                   i_exu_ls_flush,
    input                                                   i_exu_mis_flush,
    input                                                   i_rob_mis_ld_vld,
    input   [`LBUFF_ID_WIDTH - 1        : 0]                i_rob_mis_ld_id,
    input                                                   i_dsp_ldq_stall,

    input   [3                          : 0]                i_dsp_ldq_req_vld,
    output  [`LBUFF_ID_WIDTH - 1        : 0]                o_dsp_ldq_req_lbuff_id_0,
    output  [`LBUFF_ID_WIDTH - 1        : 0]                o_dsp_ldq_req_lbuff_id_1,
    output  [`LBUFF_ID_WIDTH - 1        : 0]                o_dsp_ldq_req_lbuff_id_2,
    output  [`LBUFF_ID_WIDTH - 1        : 0]                o_dsp_ldq_req_lbuff_id_3,
    output  [`LBUFF_ID_WIDTH - 1        : 0]                o_dsp_ldq_req_dsp_id,
    output  [`LBUFF_ID_WIDTH - 1        : 0]                o_dsp_ldq_req_ret_id,
    
    output                                                  o_dsp_ldq_list_empty,

    input   [3                          : 0]                i_dsp_ldq_ret_vld,

    input                                                   clk,
    input                                                   rst_n
);

wire ldq_need_flush = ((i_exu_ls_flush | i_exu_mis_flush) & i_rob_mis_ld_vld);
//
localparam LDID_POOL = 6'd32;

wire [`LBUFF_ID_WIDTH - 1 : 0] ldq_wr_ptr_r, ldq_rd_ptr_r;

//
wire [2 : 0] wr_nums = {2'b0, i_dsp_ldq_req_vld[3]}
                     + {2'b0, i_dsp_ldq_req_vld[2]}
                     + {2'b0, i_dsp_ldq_req_vld[1]}
                     + {2'b0, i_dsp_ldq_req_vld[0]};
wire [2 : 0] rd_nums = {2'b0, i_dsp_ldq_ret_vld[3]}
                     + {2'b0, i_dsp_ldq_ret_vld[2]}
                     + {2'b0, i_dsp_ldq_ret_vld[1]}
                     + {2'b0, i_dsp_ldq_ret_vld[0]};

//
wire ldq_need_ret = (|i_dsp_ldq_ret_vld);
wire ldq_need_req = (|i_dsp_ldq_req_vld);

//  Modify ldq_wr_ptr_r;
wire ldq_wr_ptr_ena = (((ldq_need_req & (~o_dsp_ldq_list_empty)) & (~i_dsp_ldq_stall)) | ldq_need_flush | i_csr_trap_flush);
wire [`LBUFF_ID_WIDTH - 1 : 0] ldq_wr_ptr_nxt = i_csr_trap_flush ? `LBUFF_ID_WIDTH'd0
                                                    : ldq_need_flush ? i_rob_mis_ld_id
                                                    : ldq_wr_ptr_r + wr_nums;

gnrl_dfflr #(
    .DATA_WIDTH   (`LBUFF_ID_WIDTH),
    .INITIAL_VALUE(0)
) ldq_wr_ptr_dfflr (ldq_wr_ptr_ena, ldq_wr_ptr_nxt, ldq_wr_ptr_r, clk, rst_n);

//  Modify ldq_rd_ptr_r
wire ldq_rd_ptr_ena = (ldq_need_ret | i_csr_trap_flush);
wire [`LBUFF_ID_WIDTH - 1 : 0] ldq_rd_ptr_nxt = i_csr_trap_flush ? `LBUFF_ID_WIDTH'd0
                                                    : ldq_rd_ptr_r + rd_nums;
gnrl_dfflr #(
    .DATA_WIDTH   (`LBUFF_ID_WIDTH),
    .INITIAL_VALUE(0)
) ldq_rd_ptr_dfflr (ldq_rd_ptr_ena, ldq_rd_ptr_nxt, ldq_rd_ptr_r, clk, rst_n);

//
wire [5 : 0] ldq_free_nums = (LDID_POOL - (ldq_wr_ptr_r - ldq_rd_ptr_r));
assign o_dsp_ldq_list_empty = (ldq_free_nums < {3'd0, wr_nums});

//
assign o_dsp_ldq_req_lbuff_id_0 = ldq_wr_ptr_r;
assign o_dsp_ldq_req_lbuff_id_1 = (ldq_wr_ptr_r + {5'b0, i_dsp_ldq_req_vld[0]});
assign o_dsp_ldq_req_lbuff_id_2 = (ldq_wr_ptr_r + {5'b0, i_dsp_ldq_req_vld[0]} + {5'b0, i_dsp_ldq_req_vld[1]});
assign o_dsp_ldq_req_lbuff_id_3 = (ldq_wr_ptr_r + {5'b0, i_dsp_ldq_req_vld[0]} + {5'b0, i_dsp_ldq_req_vld[1]} + {5'b0, i_dsp_ldq_req_vld[2]});

assign o_dsp_ldq_req_dsp_id = ldq_wr_ptr_r;
assign o_dsp_ldq_req_ret_id = ldq_rd_ptr_r;

endmodule   //  dsp_ldq_module


`endif  /*  !__DISPATH_DSP_LDQ_V__!     */