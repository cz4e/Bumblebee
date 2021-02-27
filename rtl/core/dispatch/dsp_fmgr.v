`ifdef __DISPATCH_DSP_FMGR_V__

module dsp_fmgr_module (
    input                                   i_csr_trap_flush,
    input                                   i_dsp_fmgr_stall,
    input                                   i_dsp_fmgr_free_req_0,
    input                                   i_dsp_fmgr_free_req_1,
    input                                   i_dsp_fmgr_free_req_2,
    input                                   i_dsp_fmgr_free_req_3,

    output  [`RSV_IDX_WIDTH - 1 : 0]        o_dsp_fmgr_free_entry_0,
    output  [`RSV_IDX_WIDTH - 1 : 0]        o_dsp_fmgr_free_entry_1,
    output  [`RSV_IDX_WIDTH - 1 : 0]        o_dsp_fmgr_free_entry_2,
    output  [`RSV_IDX_WIDTH - 1 : 0]        o_dsp_fmgr_free_entry_3,

    input   [3                  : 0]        i_dsp_fmgr_ret_vld,
    input   [`RSV_IDX_WIDTH - 1 : 0]        i_dsp_fmgr_ret_entry_0,
    input   [`RSV_IDX_WIDTH - 1 : 0]        i_dsp_fmgr_ret_entry_1,
    input   [`RSV_IDX_WIDTH - 1 : 0]        i_dsp_fmgr_ret_entry_2,
    input   [`RSV_IDX_WIDTH - 1 : 0]        i_dsp_fmgr_ret_entry_3,

    output                                  o_dsp_fmgr_list_empty,

    input                                   clk,
    input                                   rst_n
);

wire [63 : 0] dsp_fmgr_bit_map_r;
wire [6 : 0] dsp_fmgr_pool_r;

wire [5 : 0] pecdr_start = 'd0;
wire [5 : 0] pecdr_sel_0, pecdr_sel_1, pecdr_sel_2, pecdr_sel_3;

gnrl_pecdr_64sel4_module gnrl_pecdr (
    .i_pecdr_bit_map(dsp_fmgr_bit_map_r),
    .o_pecdr_sel_0  (pecdr_sel_0),
    .o_pecdr_sel_1  (pecdr_sel_1),
    .o_pecdr_sel_2  (pecdr_sel_2),
    .o_pecdr_sel_3  (pecdr_sel_3)
);

wire dsp_fmgr_rden = (i_dsp_fmgr_free_req_3
                   |  i_dsp_fmgr_free_req_2
                   |  i_dsp_fmgr_free_req_1
                   |  i_dsp_fmgr_free_req_0);
wire dsp_fmgr_wren = (|i_dsp_fmgr_ret_vld);

wire [2 : 0] rd_nums, wr_nums;

assign rd_nums = {2'b0, i_dsp_fmgr_free_req_3}
               + {2'b0, i_dsp_fmgr_free_req_2}
               + {2'b0, i_dsp_fmgr_free_req_1}
               + {2'b0, i_dsp_fmgr_free_req_0};

assign wr_nums =  {2'b0, i_dsp_fmgr_ret_vld[3]}
                + {2'b0, i_dsp_fmgr_ret_vld[2]}
                + {2'b0, i_dsp_fmgr_ret_vld[1]}
                + {2'b0, i_dsp_fmgr_ret_vld[0]};

//
wire [63 : 0] dsp_fmgr_bit_map_ena;
wire [63 : 0] dsp_fmgr_bit_map_nxt;

genvar i;
generate
    for(i = 0; i < 64; i = i + 1) begin
        assign dsp_fmgr_bit_map_ena[i] = ((i_csr_trap_flush) 
                                       | (((i_dsp_fmgr_free_req_0 & (i == pecdr_sel_0))
                                       |   (i_dsp_fmgr_free_req_1 & (i == pecdr_sel_1))
                                       |   (i_dsp_fmgr_free_req_2 & (i == pecdr_sel_2))
                                       |   (i_dsp_fmgr_free_req_3 & (i == pecdr_sel_3)))
                                       &   (~o_dsp_fmgr_list_empty)) 
                                       |  ((i_dsp_fmgr_ret_vld[0] & (i == i_dsp_fmgr_ret_entry_0)) 
                                       |   (i_dsp_fmgr_ret_vld[1] & (i == i_dsp_fmgr_ret_entry_1))
                                       |   (i_dsp_fmgr_ret_vld[2] & (i == i_dsp_fmgr_ret_entry_2))
                                       |   (i_dsp_fmgr_ret_vld[3] & (i == i_dsp_fmgr_ret_entry_3)))) & (~i_dsp_fmgr_stall);

        assign dsp_fmgr_bit_map_nxt[i] = i_csr_trap_flush 
                                       | ((i_dsp_fmgr_ret_vld[0] & (i == i_dsp_fmgr_ret_entry_0))
                                       |  (i_dsp_fmgr_ret_vld[1] & (i == i_dsp_fmgr_ret_entry_1))
                                       |  (i_dsp_fmgr_ret_vld[2] & (i == i_dsp_fmgr_ret_entry_2))
                                       |  (i_dsp_fmgr_ret_vld[3] & (i == i_dsp_fmgr_ret_entry_3))) ? 1'b1
                                       : 1'b0;
        gnrl_dfflr #(
            .DATA_WIDTH   (1),
            .INITIAL_VALUE(1)
        ) dsp_fmgr_bit_map_dfflr (dsp_fmgr_bit_map_ena[i], dsp_fmgr_bit_map_nxt[i], dsp_fmgr_bit_map_r[i], clk, rst_n);
    end
endgenerate

wire dsp_fmgr_pool_ena = ((dsp_fmgr_wren | (dsp_fmgr_rden & (~o_dsp_fmgr_list_empty))) & (~i_dsp_fmgr_stall));
wire [3 : 0] dsp_fmgr_pool_op2 = o_dsp_fmgr_list_empty ? wr_nums
                               : wr_nums - rd_nums;
wire [6 : 0] dsp_fmgr_pool_nxt = dsp_fmgr_pool_r + dsp_fmgr_pool_op2;

gnrl_dfflr #(
    .DATA_WIDTH   (7),
    .INITIAL_VALUE(64)
) dsp_fmgr_pool_dfflr (dsp_fmgr_pool_ena, dsp_fmgr_pool_nxt, dsp_fmgr_pool_r, clk, rst_n);

assign o_dsp_fmgr_list_empty = (dsp_fmgr_pool_r < {4'b0, rd_nums});

assign o_dsp_fmgr_free_entry_0 = pecdr_sel_0;
assign o_dsp_fmgr_free_entry_1 = pecdr_sel_1;
assign o_dsp_fmgr_free_entry_2 = pecdr_sel_2;
assign o_dsp_fmgr_free_entry_3 = pecdr_sel_3;

endmodule   //  dsp_fmgr_module


`endif  /*  !__DISPATCH_DSP_FMGR_V__!  */