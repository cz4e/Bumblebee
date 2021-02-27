`ifdef __CACHE_ITLB_V__

module itlb_module ( 
    input   [31                         : 0]        i_csr_mmu_satp,
    input   [1                          : 0]        i_csr_rv_mode,

    input                                           i_itlb_flush,
    input   [31                         : 0]        i_itlb_src1,
    input   [31                         : 0]        i_itlb_src2,

    input                                           i_itlb_req,
    input   [`ITLB_TAG_WIDTH - 1        : 0]        i_itlb_rtag,
    input   [`ITLB_IDX_WIDTH - 1        : 0]        i_itlb_ridx,
    input                                           i_itlb_wren,
    input   [`ITLB_IDX_WIDTH - 1        : 0]        i_itlb_widx,
    input   [`ITLB_TAG_WIDTH - 1        : 0]        i_itlb_wtag,
    input   [`ITLB_DATA_WIDTH - 1       : 0]        i_itlb_wdat,

    output                                          o_itlb_hit,
    output  [`ITLB_DATA_WIDTH - 1       : 0]        o_itlb_rdat,

    input                                           clk,
    input                                           rst_n
);

//
wire [15 : 0] itlb_wr_vld = {
                                itlb_vld_way_15[i_itlb_widx]
                            ,   itlb_vld_way_14[i_itlb_widx]
                            ,   itlb_vld_way_13[i_itlb_widx]
                            ,   itlb_vld_way_12[i_itlb_widx]
                            ,   itlb_vld_way_11[i_itlb_widx]
                            ,   itlb_vld_way_10[i_itlb_widx]
                            ,   itlb_vld_way_9[i_itlb_widx]
                            ,   itlb_vld_way_8[i_itlb_widx]
                            ,   itlb_vld_way_7[i_itlb_widx]
                            ,   itlb_vld_way_6[i_itlb_widx]
                            ,   itlb_vld_way_5[i_itlb_widx]
                            ,   itlb_vld_way_4[i_itlb_widx]
                            ,   itlb_vld_way_3[i_itlb_widx]
                            ,   itlb_vld_way_2[i_itlb_widx]
                            ,   itlb_vld_way_1[i_itlb_widx]
                            ,   itlb_vld_way_0[i_itlb_widx]
                            };
wire itlb_need_replace = (~(&itlb_wr_vld));

wire [3 : 0] itlb_wr_way = ({4{itlb_need_replace   }} & o_plru_replace_idx         )
                         | ({4{(~itlb_need_replace)}} & func_find_free(itlb_wr_vld));
//
wire fencevm_flush_0 = (i_itlb_flush & (i_itlb_src1 == 32'h0) & (i_itlb_src2[8 : 0] == 9'h0));
wire [1 : 0] fencevm_flush_tag_0 = i_csr_rv_mode[1 : 0];

wire fencevm_flush_1 = (i_itlb_flush & (i_itlb_src1 != 32'h0) & (i_itlb_src2[8 : 0] == 9'h0));
wire [13 : 0] fencevm_flush_tag_1 = {i_csr_rv_mode[1 : 0], i_itlb_src1[31 : 20]};

wire fencevm_flush_2 = (i_itlb_flush & (i_itlb_src1 == 32'h0) & (i_itlb_src2[8 : 0] != 9'h0));
wire [10 : 0] fencevm_flush_tag_2 = {i_itlb_src2[8 : 0],  i_csr_rv_mode[1 : 0]};

wire fencevm_flush_3 = (i_itlb_flush & (i_itlb_src1 != 32'h0) & (i_itlb_src2[8 : 0] != 9'h0));
wire [`ITLB_TAG_WIDTH - 1 : 0] fencevm_flush_tag_3 = {i_itlb_src2[8 : 0], i_csr_rv_mode[1 : 0], i_itlb_src1[31 : 20]};

wire [7 : 0] itlb_flush_vec_0;
wire [7 : 0] itlb_flush_vec_1;
wire [7 : 0] itlb_flush_vec_2;
wire [7 : 0] itlb_flush_vec_3;
wire [7 : 0] itlb_flush_vec_4;
wire [7 : 0] itlb_flush_vec_5;
wire [7 : 0] itlb_flush_vec_6;
wire [7 : 0] itlb_flush_vec_7;
wire [7 : 0] itlb_flush_vec_8;
wire [7 : 0] itlb_flush_vec_9;
wire [7 : 0] itlb_flush_vec_10;
wire [7 : 0] itlb_flush_vec_11;
wire [7 : 0] itlb_flush_vec_12;
wire [7 : 0] itlb_flush_vec_13;
wire [7 : 0] itlb_flush_vec_14;
wire [7 : 0] itlb_flush_vec_15;

genvar i;
generate
    for(i = 0; i < 8; i = i + 1) begin
        assign itlb_flush_vec_0[i] = (fencevm_flush_0 & (itlb_tag_way_0[i][13 : 12] == fencevm_flush_tag_0))
                                   | (fencevm_flush_1 & (itlb_tag_way_0[i][13 :  0] == fencevm_flush_tag_1))
                                   | (fencevm_flush_2 & (itlb_tag_way_0[i][20 : 12] == fencevm_flush_tag_2))
                                   | (fencevm_flush_3 & (itlb_tag_way_0[i]          == fencevm_flush_tag_3));
        assign itlb_flush_vec_1[i] = (fencevm_flush_0 & (itlb_tag_way_1[i][13 : 12] == fencevm_flush_tag_0))
                                   | (fencevm_flush_1 & (itlb_tag_way_1[i][13 :  0] == fencevm_flush_tag_1))
                                   | (fencevm_flush_2 & (itlb_tag_way_1[i][20 : 12] == fencevm_flush_tag_2))
                                   | (fencevm_flush_3 & (itlb_tag_way_1[i]          == fencevm_flush_tag_3));
        assign itlb_flush_vec_2[i] = (fencevm_flush_0 & (itlb_tag_way_2[i][13 : 12] == fencevm_flush_tag_0))
                                   | (fencevm_flush_1 & (itlb_tag_way_2[i][13 :  0] == fencevm_flush_tag_1))
                                   | (fencevm_flush_2 & (itlb_tag_way_2[i][20 : 12] == fencevm_flush_tag_2))
                                   | (fencevm_flush_3 & (itlb_tag_way_2[i]          == fencevm_flush_tag_3));
        assign itlb_flush_vec_3[i] = (fencevm_flush_0 & (itlb_tag_way_3[i][13 : 12] == fencevm_flush_tag_0))
                                   | (fencevm_flush_1 & (itlb_tag_way_3[i][13 :  0] == fencevm_flush_tag_1))
                                   | (fencevm_flush_2 & (itlb_tag_way_3[i][20 : 12] == fencevm_flush_tag_2))
                                   | (fencevm_flush_3 & (itlb_tag_way_3[i]          == fencevm_flush_tag_3));
        assign itlb_flush_vec_4[i] = (fencevm_flush_0 & (itlb_tag_way_4[i][13 : 12] == fencevm_flush_tag_0))
                                   | (fencevm_flush_1 & (itlb_tag_way_4[i][13 :  0] == fencevm_flush_tag_1))
                                   | (fencevm_flush_2 & (itlb_tag_way_4[i][20 : 12] == fencevm_flush_tag_2))
                                   | (fencevm_flush_3 & (itlb_tag_way_4[i]          == fencevm_flush_tag_3));
        assign itlb_flush_vec_5[i] = (fencevm_flush_0 & (itlb_tag_way_5[i][13 : 12] == fencevm_flush_tag_0))
                                   | (fencevm_flush_1 & (itlb_tag_way_5[i][13 :  0] == fencevm_flush_tag_1))
                                   | (fencevm_flush_2 & (itlb_tag_way_5[i][20 : 12] == fencevm_flush_tag_2))
                                   | (fencevm_flush_3 & (itlb_tag_way_5[i]          == fencevm_flush_tag_3));
        assign itlb_flush_vec_6[i] = (fencevm_flush_0 & (itlb_tag_way_6[i][13 : 12] == fencevm_flush_tag_0))
                                   | (fencevm_flush_1 & (itlb_tag_way_6[i][13 :  0] == fencevm_flush_tag_1))
                                   | (fencevm_flush_2 & (itlb_tag_way_6[i][20 : 12] == fencevm_flush_tag_2))
                                   | (fencevm_flush_3 & (itlb_tag_way_6[i]          == fencevm_flush_tag_3));
        assign itlb_flush_vec_7[i] = (fencevm_flush_0 & (itlb_tag_way_7[i][13 : 12] == fencevm_flush_tag_0))
                                   | (fencevm_flush_1 & (itlb_tag_way_7[i][13 :  0] == fencevm_flush_tag_1))
                                   | (fencevm_flush_2 & (itlb_tag_way_7[i][20 : 12] == fencevm_flush_tag_2))
                                   | (fencevm_flush_3 & (itlb_tag_way_7[i]          == fencevm_flush_tag_3));
        assign itlb_flush_vec_8[i] = (fencevm_flush_0 & (itlb_tag_way_8[i][13 : 12] == fencevm_flush_tag_0))
                                   | (fencevm_flush_1 & (itlb_tag_way_8[i][13 :  0] == fencevm_flush_tag_1))
                                   | (fencevm_flush_2 & (itlb_tag_way_8[i][20 : 12] == fencevm_flush_tag_2))
                                   | (fencevm_flush_3 & (itlb_tag_way_8[i]          == fencevm_flush_tag_3));
        assign itlb_flush_vec_9[i] = (fencevm_flush_0 & (itlb_tag_way_9[i][13 : 12] == fencevm_flush_tag_0))
                                   | (fencevm_flush_1 & (itlb_tag_way_9[i][13 :  0] == fencevm_flush_tag_1))
                                   | (fencevm_flush_2 & (itlb_tag_way_9[i][20 : 12] == fencevm_flush_tag_2))
                                   | (fencevm_flush_3 & (itlb_tag_way_9[i]          == fencevm_flush_tag_3));
        assign itlb_flush_vec_10[i] = (fencevm_flush_0 & (itlb_tag_way_10[i][13 : 12] == fencevm_flush_tag_0))
                                    | (fencevm_flush_1 & (itlb_tag_way_10[i][13 :  0] == fencevm_flush_tag_1))
                                    | (fencevm_flush_2 & (itlb_tag_way_10[i][20 : 12] == fencevm_flush_tag_2))
                                    | (fencevm_flush_3 & (itlb_tag_way_10[i]          == fencevm_flush_tag_3));
        assign itlb_flush_vec_11[i] = (fencevm_flush_0 & (itlb_tag_way_11[i][13 : 12] == fencevm_flush_tag_0))
                                    | (fencevm_flush_1 & (itlb_tag_way_11[i][13 :  0] == fencevm_flush_tag_1))
                                    | (fencevm_flush_2 & (itlb_tag_way_11[i][20 : 12] == fencevm_flush_tag_2))
                                    | (fencevm_flush_3 & (itlb_tag_way_11[i]          == fencevm_flush_tag_3));
        assign itlb_flush_vec_12[i] = (fencevm_flush_0 & (itlb_tag_way_12[i][13 : 12] == fencevm_flush_tag_0))
                                    | (fencevm_flush_1 & (itlb_tag_way_12[i][13 :  0] == fencevm_flush_tag_1))
                                    | (fencevm_flush_2 & (itlb_tag_way_12[i][20 : 12] == fencevm_flush_tag_2))
                                    | (fencevm_flush_3 & (itlb_tag_way_12[i]          == fencevm_flush_tag_3));
        assign itlb_flush_vec_13[i] = (fencevm_flush_0 & (itlb_tag_way_13[i][13 : 12] == fencevm_flush_tag_0))
                                    | (fencevm_flush_1 & (itlb_tag_way_13[i][13 :  0] == fencevm_flush_tag_1))
                                    | (fencevm_flush_2 & (itlb_tag_way_13[i][20 : 12] == fencevm_flush_tag_2))
                                    | (fencevm_flush_3 & (itlb_tag_way_13[i]          == fencevm_flush_tag_3));
        assign itlb_flush_vec_14[i] = (fencevm_flush_0 & (itlb_tag_way_14[i][13 : 12] == fencevm_flush_tag_0))
                                    | (fencevm_flush_1 & (itlb_tag_way_14[i][13 :  0] == fencevm_flush_tag_1))
                                    | (fencevm_flush_2 & (itlb_tag_way_14[i][20 : 12] == fencevm_flush_tag_2))
                                    | (fencevm_flush_3 & (itlb_tag_way_14[i]          == fencevm_flush_tag_3));
        assign itlb_flush_vec_15[i] = (fencevm_flush_0 & (itlb_tag_way_15[i][13 : 12] == fencevm_flush_tag_0))
                                    | (fencevm_flush_1 & (itlb_tag_way_15[i][13 :  0] == fencevm_flush_tag_1))
                                    | (fencevm_flush_2 & (itlb_tag_way_15[i][20 : 12] == fencevm_flush_tag_2))
                                    | (fencevm_flush_3 & (itlb_tag_way_15[i]          == fencevm_flush_tag_3));               

    end
endgenerate

//  Way 0
wire [7 : 0] itlb_vld_way_0;
wire [`ITLB_TAG_WIDTH - 1 : 0] itlb_tag_way_0 [7 : 0];
wire [`ITLB_DATA_WIDTH - 1 : 0] itlb_data_way_0 [7 : 0];

wire [7 : 0] itlb_vld_way_0_nxt = (itlb_vld_way_0 | ({8{(i_itlb_wren & (itlb_wr_way == 4'd0))}} & func_vec8(i_itlb_widx)))
                                & (~itlb_flush_vec_0);

wire itlb_vld_way_0_ena = ((i_itlb_wren & (itlb_wr_way == 4'd0)) | i_itlb_flush);

gnrl_dfflr #( 
    .DATA_WIDTH   (8),
    .INITIAL_VALUE(0)
) itlb_vld_way_0_dfflr (itlb_vld_way_0_ena, itlb_vld_way_0_nxt, itlb_vld_way_0, clk, rst_n);

genvar way_0_idx;
generate
    for(way_0_idx = 0; way_0_idx < 8; way_0_idx = way_0_idx + 1) begin
        gnrl_dffl #( 
            .DATA_WIDTH(`ITLB_TAG_WIDTH)
        ) itlb_tag_way_0_dffl (itlb_vld_way_0_ena, i_itlb_wtag, itlb_tag_way_0[way_0_idx], clk);

        gnrl_dffl #( 
            .DATA_WIDTH(`ITLB_DATA_WIDTH)
        ) itlb_data_way_0_dffl (itlb_vld_way_0_ena, i_itlb_wdat, itlb_data_way_0[way_0_idx], clk);
    end    
endgenerate

//  Way 1
wire [7 : 0] itlb_vld_way_1;
wire [`ITLB_TAG_WIDTH - 1 : 0] itlb_tag_way_1 [7 : 0];
wire [`ITLB_DATA_WIDTH - 1 : 0] itlb_data_way_1 [7 : 0];

wire [7 : 0] itlb_vld_way_1_nxt = (itlb_vld_way_1 | ({8{(i_itlb_wren & (itlb_wr_way == 4'd1))}} & func_vec8(i_itlb_widx)))
                                & (~itlb_flush_vec_1);

wire itlb_vld_way_1_ena = ((i_itlb_wren & (itlb_wr_way == 4'd1)) | i_itlb_flush);

gnrl_dfflr #( 
    .DATA_WIDTH   (8),
    .INITIAL_VALUE(0)
) itlb_vld_way_1_dfflr (itlb_vld_way_1_ena, itlb_vld_way_1_nxt, itlb_vld_way_1, clk, rst_n);

genvar way_1_idx;
generate
    for(way_1_idx = 0; way_1_idx < 8; way_1_idx = way_1_idx + 1) begin
        gnrl_dffl #( 
            .DATA_WIDTH(`ITLB_TAG_WIDTH)
        ) itlb_tag_way_1_dffl (itlb_vld_way_1_ena, i_itlb_wtag, itlb_tag_way_1[way_1_idx], clk);

        gnrl_dffl #( 
            .DATA_WIDTH(`ITLB_DATA_WIDTH)
        ) itlb_data_way_1_dffl (itlb_vld_way_1_ena, i_itlb_wdat, itlb_data_way_1[way_1_idx], clk);
    end    
endgenerate

//  Way 2
wire [7 : 0] itlb_vld_way_2;
wire [`ITLB_TAG_WIDTH - 1 : 0] itlb_tag_way_2 [7 : 0];
wire [`ITLB_DATA_WIDTH - 1 : 0] itlb_data_way_2 [7 : 0];

wire [7 : 0] itlb_vld_way_2_nxt = (itlb_vld_way_2 | ({8{(i_itlb_wren & (itlb_wr_way == 4'd2))}} & func_vec8(i_itlb_widx)))
                                & (~itlb_flush_vec_2);

wire itlb_vld_way_2_ena = ((i_itlb_wren & (itlb_wr_way == 4'd2)) | i_itlb_flush);

gnrl_dfflr #( 
    .DATA_WIDTH   (8),
    .INITIAL_VALUE(0)
) itlb_vld_way_2_dfflr (itlb_vld_way_2_ena, itlb_vld_way_2_nxt, itlb_vld_way_2, clk, rst_n);

genvar way_2_idx;
generate
    for(way_2_idx = 0; way_2_idx < 8; way_2_idx = way_2_idx + 1) begin
        gnrl_dffl #( 
            .DATA_WIDTH(`ITLB_TAG_WIDTH)
        ) itlb_tag_way_2_dffl (itlb_vld_way_2_ena, i_itlb_wtag, itlb_tag_way_2[way_2_idx], clk);

        gnrl_dffl #( 
            .DATA_WIDTH(`ITLB_DATA_WIDTH)
        ) itlb_data_way_2_dffl (itlb_vld_way_2_ena, i_itlb_wdat, itlb_data_way_2[way_2_idx], clk);
    end    
endgenerate

//  Way 3
wire [7 : 0] itlb_vld_way_3;
wire [`ITLB_TAG_WIDTH - 1 : 0] itlb_tag_way_3 [7 : 0];
wire [`ITLB_DATA_WIDTH - 1 : 0] itlb_data_way_3 [7 : 0];

wire [7 : 0] itlb_vld_way_3_nxt = (itlb_vld_way_3 | ({8{(i_itlb_wren & (itlb_wr_way == 4'd3))}} & func_vec8(i_itlb_widx)));

wire itlb_vld_way_3_ena = ((i_itlb_wren & (itlb_wr_way == 4'd3)) | i_itlb_flush);

gnrl_dfflr #( 
    .DATA_WIDTH   (8),
    .INITIAL_VALUE(0)
) itlb_vld_way_3_dfflr (itlb_vld_way_3_ena, itlb_vld_way_3_nxt, itlb_vld_way_3, clk, rst_n);

genvar way_3_idx;
generate
    for(way_3_idx = 0; way_3_idx < 8; way_3_idx = way_3_idx + 1) begin
        gnrl_dffl #( 
            .DATA_WIDTH(`ITLB_TAG_WIDTH)
        ) itlb_tag_way_3_dffl (itlb_vld_way_3_ena, i_itlb_wtag, itlb_tag_way_3[way_3_idx], clk);

        gnrl_dffl #( 
            .DATA_WIDTH(`ITLB_DATA_WIDTH)
        ) itlb_data_way_3_dffl (itlb_vld_way_3_ena, i_itlb_wdat, itlb_data_way_3[way_3_idx], clk);
    end    
endgenerate

//  Way 4
wire [7 : 0] itlb_vld_way_4;
wire [`ITLB_TAG_WIDTH - 1 : 0] itlb_tag_way_4 [7 : 0];
wire [`ITLB_DATA_WIDTH - 1 : 0] itlb_data_way_4 [7 : 0];

wire [7 : 0] itlb_vld_way_4_nxt = (itlb_vld_way_4 | ({8{(i_itlb_wren & (itlb_wr_way == 4'd4))}} & func_vec8(i_itlb_widx)))
                                & (~itlb_flush_vec_4);

wire itlb_vld_way_4_ena = ((i_itlb_wren & (itlb_wr_way == 4'd4)) | i_itlb_flush);

gnrl_dfflr #( 
    .DATA_WIDTH   (8),
    .INITIAL_VALUE(0)
) itlb_vld_way_4_dfflr (itlb_vld_way_4_ena, itlb_vld_way_4_nxt, itlb_vld_way_4, clk, rst_n);

genvar way_4_idx;
generate
    for(way_4_idx = 0; way_4_idx < 8; way_4_idx = way_4_idx + 1) begin
        gnrl_dffl #( 
            .DATA_WIDTH(`ITLB_TAG_WIDTH)
        ) itlb_tag_way_4_dffl (itlb_vld_way_4_ena, i_itlb_wtag, itlb_tag_way_4[way_4_idx], clk);

        gnrl_dffl #( 
            .DATA_WIDTH(`ITLB_DATA_WIDTH)
        ) itlb_data_way_4_dffl (itlb_vld_way_4_ena, i_itlb_wdat, itlb_data_way_4[way_4_idx], clk);
    end    
endgenerate

//  Way 5
wire [7 : 0] itlb_vld_way_5;
wire [`ITLB_TAG_WIDTH - 1 : 0] itlb_tag_way_5 [7 : 0];
wire [`ITLB_DATA_WIDTH - 1 : 0] itlb_data_way_5 [7 : 0];

wire [7 : 0] itlb_vld_way_5_nxt = (itlb_vld_way_5 | ({8{(i_itlb_wren & (itlb_wr_way == 4'd5))}} & func_vec8(i_itlb_widx)))
                                & (~itlb_flush_vec_5);

wire itlb_vld_way_5_ena = ((i_itlb_wren & (itlb_wr_way == 4'd5)) | i_itlb_flush);

gnrl_dfflr #( 
    .DATA_WIDTH   (8),
    .INITIAL_VALUE(0)
) itlb_vld_way_5_dfflr (itlb_vld_way_5_ena, itlb_vld_way_5_nxt, itlb_vld_way_5, clk, rst_n);

genvar way_5_idx;
generate
    for(way_5_idx = 0; way_5_idx < 8; way_5_idx = way_5_idx + 1) begin
        gnrl_dffl #( 
            .DATA_WIDTH(`ITLB_TAG_WIDTH)
        ) itlb_tag_way_5_dffl (itlb_vld_way_5_ena, i_itlb_wtag, itlb_tag_way_5[way_5_idx], clk);

        gnrl_dffl #( 
            .DATA_WIDTH(`ITLB_DATA_WIDTH)
        ) itlb_data_way_5_dffl (itlb_vld_way_5_ena, i_itlb_wdat, itlb_data_way_5[way_5_idx], clk);
    end    
endgenerate

//  Way 6
wire [7 : 0] itlb_vld_way_6;
wire [`ITLB_TAG_WIDTH - 1 : 0] itlb_tag_way_6 [7 : 0];
wire [`ITLB_DATA_WIDTH - 1 : 0] itlb_data_way_6 [7 : 0];

wire [7 : 0] itlb_vld_way_6_nxt = (itlb_vld_way_6 | ({8{(i_itlb_wren & (itlb_wr_way == 4'd6))}} & func_vec8(i_itlb_widx)))
                                & (~itlb_flush_vec_6);

wire itlb_vld_way_6_ena = ((i_itlb_wren & (itlb_wr_way == 4'd6)) | i_itlb_flush);

gnrl_dfflr #( 
    .DATA_WIDTH   (8),
    .INITIAL_VALUE(0)
) itlb_vld_way_6_dfflr (itlb_vld_way_6_ena, itlb_vld_way_6_nxt, itlb_vld_way_6, clk, rst_n);

genvar way_6_idx;
generate
    for(way_6_idx = 0; way_6_idx < 8; way_6_idx = way_6_idx + 1) begin
        gnrl_dffl #( 
            .DATA_WIDTH(`ITLB_TAG_WIDTH)
        ) itlb_tag_way_6_dffl (itlb_vld_way_6_ena, i_itlb_wtag, itlb_tag_way_6[way_6_idx], clk);

        gnrl_dffl #( 
            .DATA_WIDTH(`ITLB_DATA_WIDTH)
        ) itlb_data_way_6_dffl (itlb_vld_way_6_ena, i_itlb_wdat, itlb_data_way_6[way_6_idx], clk);
    end    
endgenerate

//  Way 7
wire [7 : 0] itlb_vld_way_7;
wire [`ITLB_TAG_WIDTH - 1 : 0] itlb_tag_way_7 [7 : 0];
wire [`ITLB_DATA_WIDTH - 1 : 0] itlb_data_way_7 [7 : 0];

wire [7 : 0] itlb_vld_way_7_nxt = (itlb_vld_way_7 | ({8{(i_itlb_wren & (itlb_wr_way == 4'd7))}} & func_vec8(i_itlb_widx)))
                                & (~itlb_flush_vec_7);

wire itlb_vld_way_7_ena = ((i_itlb_wren & (itlb_wr_way == 4'd7)) | i_itlb_flush);

gnrl_dfflr #( 
    .DATA_WIDTH   (8),
    .INITIAL_VALUE(0)
) itlb_vld_way_7_dfflr (itlb_vld_way_7_ena, itlb_vld_way_7_nxt, itlb_vld_way_7, clk, rst_n);

genvar way_7_idx;
generate
    for(way_7_idx = 0; way_7_idx < 8; way_7_idx = way_7_idx + 1) begin
        gnrl_dffl #( 
            .DATA_WIDTH(`ITLB_TAG_WIDTH)
        ) itlb_tag_way_7_dffl (itlb_vld_way_7_ena, i_itlb_wtag, itlb_tag_way_7[way_7_idx], clk);

        gnrl_dffl #( 
            .DATA_WIDTH(`ITLB_DATA_WIDTH)
        ) itlb_data_way_7_dffl (itlb_vld_way_7_ena, i_itlb_wdat, itlb_data_way_7[way_7_idx], clk);
    end    
endgenerate

//  Way 8
wire [7 : 0] itlb_vld_way_8;
wire [`ITLB_TAG_WIDTH - 1 : 0] itlb_tag_way_8 [7 : 0];
wire [`ITLB_DATA_WIDTH - 1 : 0] itlb_data_way_8 [7 : 0];

wire [7 : 0] itlb_vld_way_8_nxt = (itlb_vld_way_8 | ({8{(i_itlb_wren & (itlb_wr_way == 4'd8))}} & func_vec8(i_itlb_widx)))
                                & (~itlb_flush_vec_8);

wire itlb_vld_way_8_ena = ((i_itlb_wren & (itlb_wr_way == 4'd8)) | i_itlb_flush);

gnrl_dfflr #( 
    .DATA_WIDTH   (8),
    .INITIAL_VALUE(0)
) itlb_vld_way_8_dfflr (itlb_vld_way_8_ena, itlb_vld_way_8_nxt, itlb_vld_way_8, clk, rst_n);

genvar way_8_idx;
generate
    for(way_8_idx = 0; way_8_idx < 8; way_8_idx = way_8_idx + 1) begin
        gnrl_dffl #( 
            .DATA_WIDTH(`ITLB_TAG_WIDTH)
        ) itlb_tag_way_8_dffl (itlb_vld_way_8_ena, i_itlb_wtag, itlb_tag_way_8[way_8_idx], clk);

        gnrl_dffl #( 
            .DATA_WIDTH(`ITLB_DATA_WIDTH)
        ) itlb_data_way_8_dffl (itlb_vld_way_8_ena, i_itlb_wdat, itlb_data_way_8[way_8_idx], clk);
    end    
endgenerate

//  Way 9
wire [7 : 0] itlb_vld_way_9;
wire [`ITLB_TAG_WIDTH - 1 : 0] itlb_tag_way_9 [7 : 0];
wire [`ITLB_DATA_WIDTH - 1 : 0] itlb_data_way_9 [7 : 0];


wire [7 : 0] itlb_vld_way_9_nxt = (itlb_vld_way_9 | ({8{(i_itlb_wren & (itlb_wr_way == 4'd9))}} & func_vec8(i_itlb_widx)))
                                & (~itlb_flush_vec_9);

wire itlb_vld_way_9_ena = ((i_itlb_wren & (itlb_wr_way == 4'd9)) | i_itlb_flush);

gnrl_dfflr #( 
    .DATA_WIDTH   (8),
    .INITIAL_VALUE(0)
) itlb_vld_way_9_dfflr (itlb_vld_way_9_ena, itlb_vld_way_9_nxt, itlb_vld_way_9, clk, rst_n);

genvar way_9_idx;
generate
    for(way_9_idx = 0; way_9_idx < 8; way_9_idx = way_9_idx + 1) begin
        gnrl_dffl #( 
            .DATA_WIDTH(`ITLB_TAG_WIDTH)
        ) itlb_tag_way_9_dffl (itlb_vld_way_9_ena, i_itlb_wtag, itlb_tag_way_9[way_9_idx], clk);

        gnrl_dffl #( 
            .DATA_WIDTH(`ITLB_DATA_WIDTH)
        ) itlb_data_way_9_dffl (itlb_vld_way_9_ena, i_itlb_wdat, itlb_data_way_9[way_9_idx], clk);
    end    
endgenerate

//  Way 10
wire [7 : 0] itlb_vld_way_10;
wire [`ITLB_TAG_WIDTH - 1 : 0] itlb_tag_way_10 [7 : 0];
wire [`ITLB_DATA_WIDTH - 1 : 0] itlb_data_way_10 [7 : 0];

wire [7 : 0] itlb_vld_way_10_nxt = (itlb_vld_way_10 | ({8{(i_itlb_wren & (itlb_wr_way == 4'd10))}} & func_vec8(i_itlb_widx)))
                                 & (~itlb_flush_vec_10);

wire itlb_vld_way_10_ena = ((i_itlb_wren & (itlb_wr_way == 4'd10)) | i_itlb_flush);

gnrl_dfflr #( 
    .DATA_WIDTH   (8),
    .INITIAL_VALUE(0)
) itlb_vld_way_10_dfflr (itlb_vld_way_10_ena, itlb_vld_way_10_nxt, itlb_vld_way_10, clk, rst_n);

genvar way_10_idx;
generate
    for(way_10_idx = 0; way_10_idx < 8; way_10_idx = way_10_idx + 1) begin
        gnrl_dffl #( 
            .DATA_WIDTH(`ITLB_TAG_WIDTH)
        ) itlb_tag_way_10_dffl (itlb_vld_way_10_ena, i_itlb_wtag, itlb_tag_way_10[way_10_idx], clk);

        gnrl_dffl #( 
            .DATA_WIDTH(`ITLB_DATA_WIDTH)
        ) itlb_data_way_10_dffl (itlb_vld_way_10_ena, i_itlb_wdat, itlb_data_way_10[way_10_idx], clk);
    end    
endgenerate

//  Way 11
wire [7 : 0] itlb_vld_way_11;
wire [`ITLB_TAG_WIDTH - 1 : 0] itlb_tag_way_11 [7 : 0];
wire [`ITLB_DATA_WIDTH - 1 : 0] itlb_data_way_11 [7 : 0];

wire [7 : 0] itlb_vld_way_11_nxt = (itlb_vld_way_11 | ({8{(i_itlb_wren & (itlb_wr_way == 4'd11))}} & func_vec8(i_itlb_widx)))
                                 & (~itlb_flush_vec_11);

wire itlb_vld_way_11_ena = ((i_itlb_wren & (itlb_wr_way == 4'd11)) | i_itlb_flush);

gnrl_dfflr #( 
    .DATA_WIDTH   (8),
    .INITIAL_VALUE(0)
) itlb_vld_way_11_dfflr (itlb_vld_way_11_ena, itlb_vld_way_11_nxt, itlb_vld_way_11, clk, rst_n);

genvar way_11_idx;
generate
    for(way_11_idx = 0; way_11_idx < 8; way_11_idx = way_11_idx + 1) begin
        gnrl_dffl #( 
            .DATA_WIDTH(`ITLB_TAG_WIDTH)
        ) itlb_tag_way_11_dffl (itlb_vld_way_11_ena, i_itlb_wtag, itlb_tag_way_11[way_11_idx], clk);

        gnrl_dffl #( 
            .DATA_WIDTH(`ITLB_DATA_WIDTH)
        ) itlb_data_way_11_dffl (itlb_vld_way_11_ena, i_itlb_wdat, itlb_data_way_11[way_11_idx], clk);
    end    
endgenerate

//  Way 12
wire [7 : 0] itlb_vld_way_12;
wire [`ITLB_TAG_WIDTH - 1 : 0] itlb_tag_way_12 [7 : 0];
wire [`ITLB_DATA_WIDTH - 1 : 0] itlb_data_way_12 [7 : 0];

wire [7 : 0] itlb_vld_way_12_nxt = (itlb_vld_way_12 | ({8{(i_itlb_wren & (itlb_wr_way == 4'd12))}} & func_vec8(i_itlb_widx)))
                                 & (~itlb_flush_vec_12);

wire itlb_vld_way_12_ena = ((i_itlb_wren & (itlb_wr_way == 4'd12)) | i_itlb_flush);

gnrl_dfflr #( 
    .DATA_WIDTH   (8),
    .INITIAL_VALUE(0)
) itlb_vld_way_12_dfflr (itlb_vld_way_12_ena, itlb_vld_way_12_nxt, itlb_vld_way_12, clk, rst_n);

genvar way_12_idx;
generate
    for(way_12_idx = 0; way_12_idx < 8; way_12_idx = way_12_idx + 1) begin
        gnrl_dffl #( 
            .DATA_WIDTH(`ITLB_TAG_WIDTH)
        ) itlb_tag_way_12_dffl (itlb_vld_way_12_ena, i_itlb_wtag, itlb_tag_way_12[way_12_idx], clk);

        gnrl_dffl #( 
            .DATA_WIDTH(`ITLB_DATA_WIDTH)
        ) itlb_data_way_12_dffl (itlb_vld_way_12_ena, i_itlb_wdat, itlb_data_way_12[way_12_idx], clk);
    end    
endgenerate

//  Way 13
wire [7 : 0] itlb_vld_way_13;
wire [`ITLB_TAG_WIDTH - 1 : 0] itlb_tag_way_13 [7 : 0];
wire [`ITLB_DATA_WIDTH - 1 : 0] itlb_data_way_13 [7 : 0];

wire [7 : 0] itlb_vld_way_13_nxt = (itlb_vld_way_13 | ({8{(i_itlb_wren & (itlb_wr_way == 4'd13))}} & func_vec8(i_itlb_widx)))
                                 & (~itlb_flush_vec_13);

wire itlb_vld_way_13_ena = ((i_itlb_wren & (itlb_wr_way == 4'd13)) | i_itlb_flush);

gnrl_dfflr #( 
    .DATA_WIDTH   (8),
    .INITIAL_VALUE(0)
) itlb_vld_way_13_dfflr (itlb_vld_way_13_ena, itlb_vld_way_13_nxt, itlb_vld_way_13, clk, rst_n);

genvar way_13_idx;
generate
    for(way_13_idx = 0; way_13_idx < 8; way_13_idx = way_13_idx + 1) begin
        gnrl_dffl #( 
            .DATA_WIDTH(`ITLB_TAG_WIDTH)
        ) itlb_tag_way_13_dffl (itlb_vld_way_13_ena, i_itlb_wtag, itlb_tag_way_13[way_13_idx], clk);

        gnrl_dffl #( 
            .DATA_WIDTH(`ITLB_DATA_WIDTH)
        ) itlb_data_way_13_dffl (itlb_vld_way_13_ena, i_itlb_wdat, itlb_data_way_13[way_13_idx], clk);
    end    
endgenerate

//  Way 14
wire [7 : 0] itlb_vld_way_14;
wire [`ITLB_TAG_WIDTH - 1 : 0] itlb_tag_way_14 [7 : 0];
wire [`ITLB_DATA_WIDTH - 1 : 0] itlb_data_way_14 [7 : 0];

wire [7 : 0] itlb_vld_way_14_nxt = (itlb_vld_way_14 | ({8{(i_itlb_wren & (itlb_wr_way == 4'd14))}} & func_vec8(i_itlb_widx)))
                                 & (~itlb_flush_vec_14);

wire itlb_vld_way_14_ena = ((i_itlb_wren & (itlb_wr_way == 4'd14)) | i_itlb_flush);

gnrl_dfflr #( 
    .DATA_WIDTH   (8),
    .INITIAL_VALUE(0)
) itlb_vld_way_14_dfflr (itlb_vld_way_14_ena, itlb_vld_way_14_nxt, itlb_vld_way_14, clk, rst_n);

genvar way_14_idx;
generate
    for(way_14_idx = 0; way_14_idx < 8; way_14_idx = way_14_idx + 1) begin
        gnrl_dffl #( 
            .DATA_WIDTH(`ITLB_TAG_WIDTH)
        ) itlb_tag_way_14_dffl (itlb_vld_way_14_ena, i_itlb_wtag, itlb_tag_way_14[way_14_idx], clk);

        gnrl_dffl #( 
            .DATA_WIDTH(`ITLB_DATA_WIDTH)
        ) itlb_data_way_14_dffl (itlb_vld_way_14_ena, i_itlb_wdat, itlb_data_way_14[way_14_idx], clk);
    end    
endgenerate

//  Way 15
wire [7 : 0] itlb_vld_way_15;
wire [`ITLB_TAG_WIDTH - 1 : 0] itlb_tag_way_15 [7 : 0];
wire [`ITLB_DATA_WIDTH - 1 : 0] itlb_data_way_15 [7 : 0];

wire [7 : 0] itlb_vld_way_15_nxt = (itlb_vld_way_15 | ({8{(i_itlb_wren & (itlb_wr_way == 4'd15))}} & func_vec8(i_itlb_widx)))
                                 & (~itlb_flush_vec_15);

wire itlb_vld_way_15_ena = ((i_itlb_wren & (itlb_wr_way == 4'd15)) | i_itlb_flush);

gnrl_dfflr #( 
    .DATA_WIDTH   (8),
    .INITIAL_VALUE(0)
) itlb_vld_way_15_dfflr (itlb_vld_way_15_ena, itlb_vld_way_15_nxt, itlb_vld_way_15, clk, rst_n);

genvar way_15_idx;
generate
    for(way_15_idx = 0; way_15_idx < 8; way_15_idx = way_15_idx + 1) begin
        gnrl_dffl #( 
            .DATA_WIDTH(`ITLB_TAG_WIDTH)
        ) itlb_tag_way_15_dffl (itlb_vld_way_15_ena, i_itlb_wtag, itlb_tag_way_15[way_15_idx], clk);

        gnrl_dffl #( 
            .DATA_WIDTH(`ITLB_DATA_WIDTH)
        ) itlb_data_way_15_dffl (itlb_vld_way_15_ena, i_itlb_wdat, itlb_data_way_15[way_15_idx], clk);
    end    
endgenerate
//

wire [15 : 0] itlb_hit = {
                            (i_itlb_req & itlb_vld_way_15[i_itlb_ridx] & (itlb_tag_way_15[i_itlb_ridx] == i_itlb_rtag))
                        ,   (i_itlb_req & itlb_vld_way_14[i_itlb_ridx] & (itlb_tag_way_14[i_itlb_ridx] == i_itlb_rtag))
                        ,   (i_itlb_req & itlb_vld_way_13[i_itlb_ridx] & (itlb_tag_way_13[i_itlb_ridx] == i_itlb_rtag))
                        ,   (i_itlb_req & itlb_vld_way_12[i_itlb_ridx] & (itlb_tag_way_12[i_itlb_ridx] == i_itlb_rtag))
                        ,   (i_itlb_req & itlb_vld_way_11[i_itlb_ridx] & (itlb_tag_way_11[i_itlb_ridx] == i_itlb_rtag))
                        ,   (i_itlb_req & itlb_vld_way_10[i_itlb_ridx] & (itlb_tag_way_10[i_itlb_ridx] == i_itlb_rtag))
                        ,   (i_itlb_req & itlb_vld_way_9[i_itlb_ridx]  & (itlb_tag_way_9[i_itlb_ridx]  == i_itlb_rtag))
                        ,   (i_itlb_req & itlb_vld_way_8[i_itlb_ridx]  & (itlb_tag_way_8[i_itlb_ridx]  == i_itlb_rtag))
                        ,   (i_itlb_req & itlb_vld_way_7[i_itlb_ridx]  & (itlb_tag_way_7[i_itlb_ridx]  == i_itlb_rtag))
                        ,   (i_itlb_req & itlb_vld_way_6[i_itlb_ridx]  & (itlb_tag_way_6[i_itlb_ridx]  == i_itlb_rtag))
                        ,   (i_itlb_req & itlb_vld_way_5[i_itlb_ridx]  & (itlb_tag_way_5[i_itlb_ridx]  == i_itlb_rtag))
                        ,   (i_itlb_req & itlb_vld_way_4[i_itlb_ridx]  & (itlb_tag_way_4[i_itlb_ridx]  == i_itlb_rtag))
                        ,   (i_itlb_req & itlb_vld_way_3[i_itlb_ridx]  & (itlb_tag_way_3[i_itlb_ridx]  == i_itlb_rtag))
                        ,   (i_itlb_req & itlb_vld_way_2[i_itlb_ridx]  & (itlb_tag_way_2[i_itlb_ridx]  == i_itlb_rtag))
                        ,   (i_itlb_req & itlb_vld_way_1[i_itlb_ridx]  & (itlb_tag_way_1[i_itlb_ridx]  == i_itlb_rtag))
                        ,   (i_itlb_req & itlb_vld_way_0[i_itlb_ridx]  & (itlb_tag_way_0[i_itlb_ridx]  == i_itlb_rtag))
                        
                    };

assign o_itlb_hit = (|itlb_hit);
assign o_itlb_rdat= ({`ITLB_DATA_WIDTH{itlb_hit[ 0]}} & itlb_data_way_0[i_itlb_ridx] )
                  | ({`ITLB_DATA_WIDTH{itlb_hit[ 1]}} & itlb_data_way_1[i_itlb_ridx] )
                  | ({`ITLB_DATA_WIDTH{itlb_hit[ 2]}} & itlb_data_way_2[i_itlb_ridx] )
                  | ({`ITLB_DATA_WIDTH{itlb_hit[ 3]}} & itlb_data_way_3[i_itlb_ridx] )
                  | ({`ITLB_DATA_WIDTH{itlb_hit[ 4]}} & itlb_data_way_4[i_itlb_ridx] )
                  | ({`ITLB_DATA_WIDTH{itlb_hit[ 5]}} & itlb_data_way_5[i_itlb_ridx] )
                  | ({`ITLB_DATA_WIDTH{itlb_hit[ 6]}} & itlb_data_way_6[i_itlb_ridx] )
                  | ({`ITLB_DATA_WIDTH{itlb_hit[ 7]}} & itlb_data_way_7[i_itlb_ridx] )
                  | ({`ITLB_DATA_WIDTH{itlb_hit[ 8]}} & itlb_data_way_8[i_itlb_ridx] )
                  | ({`ITLB_DATA_WIDTH{itlb_hit[ 9]}} & itlb_data_way_9[i_itlb_ridx] )
                  | ({`ITLB_DATA_WIDTH{itlb_hit[10]}} & itlb_data_way_10[i_itlb_ridx])
                  | ({`ITLB_DATA_WIDTH{itlb_hit[11]}} & itlb_data_way_11[i_itlb_ridx])
                  | ({`ITLB_DATA_WIDTH{itlb_hit[12]}} & itlb_data_way_12[i_itlb_ridx])
                  | ({`ITLB_DATA_WIDTH{itlb_hit[13]}} & itlb_data_way_13[i_itlb_ridx])
                  | ({`ITLB_DATA_WIDTH{itlb_hit[14]}} & itlb_data_way_14[i_itlb_ridx])
                  | ({`ITLB_DATA_WIDTH{itlb_hit[15]}} & itlb_data_way_15[i_itlb_ridx]);


//  Replace
wire [3 : 0] i_plru_hit_idx = func_vec16r(itlb_hit);
wire i_plru_req = (i_itlb_wren & itlb_need_replace);
wire [3 : 0] o_plru_replace_idx;

plru16_module plru16 (
    .plru_hit        (o_itlb_hit),
    .plru_hit_idx    (i_plru_hit_idx),
    .plru_req        (i_plru_req),
    .plru_replace_idx(o_plru_replace_idx),

    .clk               (clk),
    .rst_n             (rst_n)
);

//  Functions
function [3 : 0] func_vec16r;
    input   [15 : 0] bit_map;
    
    case (bit_map)
        16'b0000_0000_0000_0001 : func_vec16r = 4'd0;
        16'b0000_0000_0000_0010 : func_vec16r = 4'd1;
        16'b0000_0000_0000_0100 : func_vec16r = 4'd2;
        16'b0000_0000_0000_1000 : func_vec16r = 4'd3;
        16'b0000_0000_0001_0000 : func_vec16r = 4'd4;
        16'b0000_0000_0010_0000 : func_vec16r = 4'd5;
        16'b0000_0000_0100_0000 : func_vec16r = 4'd6;
        16'b0000_0000_1000_0000 : func_vec16r = 4'd7;
        16'b0000_0001_0000_0000 : func_vec16r = 4'd8;
        16'b0000_0010_0000_0000 : func_vec16r = 4'd9;
        16'b0000_0100_0000_0000 : func_vec16r = 4'd10;
        16'b0000_1000_0000_0000 : func_vec16r = 4'd11;
        16'b0001_0000_0000_0000 : func_vec16r = 4'd12;
        16'b0010_0000_0000_0000 : func_vec16r = 4'd13;
        16'b0100_0000_0000_0000 : func_vec16r = 4'd14;
        16'b1000_0000_0000_0000 : func_vec16r = 4'd15; 
    endcase 

endfunction

function [3 : 0] func_find_free;
    input [15 : 0] bit_map;

    casex (bit_map)
        16'bxxxx_xxxx_xxxx_xxx0: func_find_free = 4'd0;
        16'bxxxx_xxxx_xxxx_xx01: func_find_free = 4'd1;
        16'bxxxx_xxxx_xxxx_x011: func_find_free = 4'd2;
        16'bxxxx_xxxx_xxxx_0111: func_find_free = 4'd3;
        16'bxxxx_xxxx_xxx0_1111: func_find_free = 4'd4;
        16'bxxxx_xxxx_xx01_1111: func_find_free = 4'd5;
        16'bxxxx_xxxx_x011_1111: func_find_free = 4'd6;
        16'bxxxx_xxxx_0111_1111: func_find_free = 4'd7;
        16'bxxxx_xxx0_1111_1111: func_find_free = 4'd8;
        16'bxxxx_xx01_1111_1111: func_find_free = 4'd9;
        16'bxxxx_x011_1111_1111: func_find_free = 4'd10;
        16'bxxxx_0111_1111_1111: func_find_free = 4'd11;
        16'bxxx0_1111_1111_1111: func_find_free = 4'd12;
        16'bxx01_1111_1111_1111: func_find_free = 4'd13;
        16'bx011_1111_1111_1111: func_find_free = 4'd14;
        16'b0111_1111_1111_1111: func_find_free = 4'd15;
        default: 
            func_find_free = 4'd0;
    endcase

endfunction

function [7 : 0] func_vec8;
    input [2 : 0] index;

    case (index)
        3'b000: func_vec8 = 8'b0000_0001;
        3'b001: func_vec8 = 8'b0000_0010;
        3'b010: func_vec8 = 8'b0000_0100;
        3'b011: func_vec8 = 8'b0000_1000;
        3'b100: func_vec8 = 8'b0001_0000;
        3'b101: func_vec8 = 8'b0010_0000;
        3'b110: func_vec8 = 8'b0100_0000;
        3'b111: func_vec8 = 8'b1000_0000;
        default: 
                func_vec8 = 8'b0000_0000;
    endcase

endfunction

endmodule   //  itlb_module

`endif  /*  !__CACHE_ITLB_V__!  */