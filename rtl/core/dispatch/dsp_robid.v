`ifdef __DISPATCH_DSP_ROBID_V__

module dsp_robid_module (
    input                                   i_csr_trap_flush,
    input                                   i_exu_mis_ls_flush,
    input   [`ROB_ID_WIDTH - 1      : 0]    i_exu_mis_ls_rob_id,
    input                                   i_dsp_robid_stall,

    input   [3                      : 0]    i_dsp_robid_req_vld,
    output  [`ROB_ID_WIDTH - 1      : 0]    o_dsp_robid_id_0,
    output  [`ROB_ID_WIDTH - 1      : 0]    o_dsp_robid_id_1,
    output  [`ROB_ID_WIDTH - 1      : 0]    o_dsp_robid_id_2,
    output  [`ROB_ID_WIDTH - 1      : 0]    o_dsp_robid_id_3,
    output  [`ROB_ID_WIDTH - 1      : 0]    o_dsp_robid_dsp_id,
    output  [`ROB_ID_WIDTH - 1      : 0]    o_dsp_robid_ret_id,
    
    output                                  o_dsp_robid_list_empty,

    input   [3                      : 0]    i_dsp_robid_ret_vld,

    input                                   clk,
    input                                   rst_n
);

wire robid_need_flush = (i_csr_trap_flush | i_exu_mis_ls_flush);
//

localparam  ROBID_POOL = 8'd128;

wire [`ROB_ID_WIDTH - 1 : 0] robid_wr_ptr_r, robid_rd_ptr_r;

// 
wire [2 : 0] wr_nums = {2'b0, i_dsp_robid_req_vld[3]}
                     + {2'b0, i_dsp_robid_req_vld[2]}
                     + {2'b0, i_dsp_robid_req_vld[1]}
                     + {2'b0, i_dsp_robid_req_vld[0]};
wire [2 : 0] rd_nums = {2'b0, i_dsp_robid_ret_vld[3]}
                     + {2'b0, i_dsp_robid_ret_vld[2]}
                     + {2'b0, i_dsp_robid_ret_vld[1]}
                     + {2'b0, i_dsp_robid_ret_vld[0]};

//
wire robid_need_ret = (|i_dsp_robid_ret_vld);
wire robid_need_req = (|i_dsp_robid_req_vld);

//  Modify robid_wr_ptr_r
wire robid_wr_ptr_ena = (((robid_need_req & (~o_dsp_robid_list_empty)) & (~i_dsp_robid_stall)) | robid_need_flush);
wire [`ROB_ID_WIDTH - 1 : 0] robid_wr_ptr_nxt = i_csr_trap_flush ? `ROB_ID_WIDTH'd0 
                                              : i_exu_mis_ls_flush ? (i_exu_mis_ls_rob_id + `ROB_ID_WIDTH'd1) 
                                              : robid_wr_ptr_r + wr_nums;
gnrl_dfflr #(
    .DATA_WIDTH   (`ROB_ID_WIDTH),
    .INITIAL_VALUE(0)
) robid_wr_ptr_dfflr (robid_wr_ptr_ena, robid_wr_ptr_nxt, robid_wr_ptr_r, clk, rst_n);


//  Modify robid_rd_ptr_r
wire robid_rd_ptr_ena = (robid_need_ret | robid_need_flush);
wire [`ROB_ID_WIDTH - 1 : 0] robid_rd_ptr_nxt = i_csr_trap_flush ? `ROB_ID_WIDTH'd0
                                              : robid_rd_ptr_r + rd_nums;
gnrl_dfflr #(
    .DATA_WIDTH   (`ROB_ID_WIDTH),
    .INITIAL_VALUE(0)
) robid_rd_ptr_dfflr (robid_rd_ptr_ena, robid_rd_ptr_nxt, robid_rd_ptr_r, clk, rst_n);

//
wire [7 : 0] robid_free_nums = (ROBID_POOL - (robid_wr_ptr_r - robid_rd_ptr_r));
assign o_dsp_robid_list_empty = (robid_free_nums < {5'd0, wr_nums});

//
assign o_dsp_robid_dsp_id = robid_wr_ptr_r;
assign o_dsp_robid_ret_id = robid_rd_ptr_r;

//
assign o_dsp_robid_id_0 = robid_wr_ptr_r;
assign o_dsp_robid_id_1 = (robid_wr_ptr_r + `ROB_ID_WIDTH'd1);
assign o_dsp_robid_id_2 = (robid_wr_ptr_r + `ROB_ID_WIDTH'd2);
assign o_dsp_robid_id_3 = (robid_wr_ptr_r + `ROB_ID_WIDTH'd3);

endmodule   //  dsp_robid_module

`endif  /*  !__DISPATCH_DSP_ROBID_V__!  */