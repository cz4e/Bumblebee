`ifdef __DECODE_DEC_FREELIST_V__

module dec_freelist_module ( 
    input                                       i_fl_req_0,
    input                                       i_fl_req_1,
    input                                       i_fl_req_2,
    input                                       i_fl_req_3,
    
    output  [`PRF_CODE_WIDTH - 1    : 0]        o_fl_prf_code_0,
    output  [`PRF_CODE_WIDTH - 1    : 0]        o_fl_prf_code_1,
    output  [`PRF_CODE_WIDTH - 1    : 0]        o_fl_prf_code_2,
    output  [`PRF_CODE_WIDTH - 1    : 0]        o_fl_prf_code_3,
    
    output                                      o_fl_stall,

    input                                       i_fl_wren_0,
    input                                       i_fl_wren_1,
    input                                       i_fl_wren_2,
    input                                       i_fl_wren_3,
    
    input   [`PRF_CODE_WIDTH - 1     : 0]       i_fl_wr_prf_code_0,
    input   [`PRF_CODE_WIDTH - 1     : 0]       i_fl_wr_prf_code_1,
    input   [`PRF_CODE_WIDTH - 1     : 0]       i_fl_wr_prf_code_2,
    input   [`PRF_CODE_WIDTH - 1     : 0]       i_fl_wr_prf_code_3,

    input                                       clk,
    input                                       rst_n
);

wire [127 : 0] fl_bit_map_r;
wire [7 : 0] fl_pool_r;
//
wire [6 : 0] pecdr_start = 'd0;
wire [6 : 0] pecdr_sel_0, pecdr_sel_1, pecdr_sel_2, pecdr_sel_3;

gnrl_priecdr128_module pecdr0 (
    .i_pecdr_ena  (i_fl_req_0),
    .i_pecdr_map  (fl_bit_map_r),
    .i_pecdr_start(pecdr_start),
    .o_pecdr_sel  (pecdr_sel_0)
);

//
wire [6 : 0] pecdr_sel0_w   = i_fl_req_0 ? pecdr_sel_0 + 1 : pecdr_sel_0;
gnrl_priecdr128_module pecdr1 (
    .i_pecdr_ena  (i_fl_req_1),
    .i_pecdr_map  (fl_bit_map_r),
    .i_pecdr_start(pecdr_sel0_w),
    .o_pecdr_sel  (pecdr_sel_1)
);

//
wire [6 : 0] pecdr_sel1_w   = i_fl_req_1 ? pecdr_sel_1 + 1 : pecdr_sel_1;
gnrl_priecdr128_module pecdr2 (
    .i_pecdr_ena  (i_fl_req_2),
    .i_pecdr_map  (fl_bit_map_r),
    .i_pecdr_start(pecdr_sel1_w),
    .o_pecdr_sel  (pecdr_sel_2)
);

//
wire [6 : 0] pecdr_sel2_w   = i_fl_req_2 ? pecdr_sel_2 + 1 : pecdr_sel_2;
gnrl_priecdr128_module pecdr3 (
    .i_pecdr_ena  (i_fl_req_3),
    .i_pecdr_map  (fl_bit_map_r),
    .i_pecdr_start(pecdr_sel2_w),
    .o_pecdr_sel  (pecdr_sel_3)
);

//
wire fl_rden = (i_fl_req_0 | i_fl_req_1 | i_fl_req_2 | i_fl_req_3);
wire fl_wren = (i_fl_wren_0  | i_fl_wren_1  | i_fl_wren_2  | i_fl_wren_3);

wire [2 : 0] rd_nums, wr_nums;

assign rd_nums = ({2'b0, i_fl_req_0} + {2'b0, i_fl_req_1} + {2'b0, i_fl_req_2} + {2'b0, i_fl_req_3});
assign wr_nums = ({2'b0, i_fl_wren_0}  + {2'b0, i_fl_wren1}  + {2'b0, i_fl_wren_2}  + {2'b0, i_fl_wren_3});

//
wire [127 : 0] fl_bit_map_set;

genvar i;
generate
    for(i = 0; i < 128; i = i + 1) begin
        assign fl_bit_map_set[i] = (i_fl_wren_0 & (i == i_fl_wr_prf_code_0))
                                 | (i_fl_wren_1 & (i == i_fl_wr_prf_code_1))
                                 | (i_fl_wren_2 & (i == i_fl_wr_prf_code_2))
                                 | (i_fl_wren_3 & (i == i_fl_wr_prf_code_3));
    end
endgenerate

//
wire [127 : 0] fl_bit_map_clr;

genvar j;
generate
    for(j = 0; j < 128; j = j + 1) begin
        assign fl_bit_map_clr[j] = (i_fl_req_0 & (j == o_fl_prf_code_0))
                                 | (i_fl_req_1 & (j == o_fl_prf_code_1))
                                 | (i_fl_req_2 & (j == o_fl_prf_code_2))
                                 | (i_fl_req_3 & (j == o_fl_prf_code_3));
    end
endgenerate

//
localparam  BIT_MAP_VALUE = 128'hffffffff_ffffffff_ffffffff_ffffffe;
wire fl_bit_map_ena = ((fl_rden | fl_wren) & (~o_fl_stall));
wire [127 : 0] fl_bit_map_nxt = ((fl_bit_map_r | fl_bit_map_set) & (~fl_bit_map_clr));

gnrl_dfflr #( 
    .DATA_WIDTH   (128),
    .INITIAL_VALUE(BIT_MAP_VALUE)
) fl_bit_map_dfflr (fl_bit_map_ena, fl_bit_map_nxt, fl_bit_map_r, clk, rst_n);

//
wire i_fl_pool_ena = ((fl_rden & (~o_fl_stall)) | fl_wren);
wire [7 : 0] i_fl_pool_nxt = (fl_pool_r + {5'd0, wr_nums} - {5'd0, rd_nums});

gnrl_dfflr #( 
    .DATA_WIDTH   (8),
    .INITIAL_VALUE(127)
) fl_pool_dfflr (i_fl_pool_ena, i_fl_pool_nxt, fl_pool_r, clk, rst_n);

assign o_fl_prf_code_0 = pecdr_sel_0;
assign o_fl_prf_code_1 = pecdr_sel_1;
assign o_fl_prf_code_2 = pecdr_sel_2;
assign o_fl_prf_code_3 = pecdr_sel_3;

assign o_fl_stall = (fl_pool_r < {5'd0, rd_nums});

endmodule   //  dec_freelist_module

`endif  /*  !__DECODE_DEC_FREELIST_V__! */