`ifdef __EXU_DTLB_V__

module dtlb_module (
    input                                       i_dtlb_rden,
    input   [`DTLB_TAG_WIDTH - 1    : 0]        i_dtlb_rtag,
    input   [`DTLB_IDX_WIDTH - 1    : 0]        i_dtlb_ridx,
    input                                       i_dtlb_wren,
    input   [`DTLB_IDX_WIDTH - 1    : 0]        i_dtlb_widx,
    input   [`DTLB_TAG_WIDTH - 1    : 0]        i_dtlb_wtag,
    input   [`DTLB_DATA_WIDTH - 1   : 0]        i_dtlb_wdat,

    output                                      o_dtlb_hit,
    output  [`DTLB_DATA_WIDTH - 1   : 0]        o_dtlb_rdat,

    input                                       clk,
    input                                       rst_n
);

//
wire [15 : 0] dtlb_wr_vld = {
                                dtlb_vld_way_15[i_dtlb_widx]
                            ,   dtlb_vld_way_14[i_dtlb_widx]
                            ,   dtlb_vld_way_13[i_dtlb_widx]
                            ,   dtlb_vld_way_12[i_dtlb_widx]
                            ,   dtlb_vld_way_11[i_dtlb_widx]
                            ,   dtlb_vld_way_10[i_dtlb_widx]
                            ,   dtlb_vld_way_9[i_dtlb_widx]
                            ,   dtlb_vld_way_8[i_dtlb_widx]
                            ,   dtlb_vld_way_7[i_dtlb_widx]
                            ,   dtlb_vld_way_6[i_dtlb_widx]
                            ,   dtlb_vld_way_5[i_dtlb_widx]
                            ,   dtlb_vld_way_4[i_dtlb_widx]
                            ,   dtlb_vld_way_3[i_dtlb_widx]
                            ,   dtlb_vld_way_2[i_dtlb_widx]
                            ,   dtlb_vld_way_1[i_dtlb_widx]
                            ,   dtlb_vld_way_0[i_dtlb_widx]
                            };
wire dtlb_need_replace = (~(&dtlb_wr_vld));

wire [3 : 0] dtlb_wr_way = ({4{dtlb_need_replace   }} & o_plru_replace_idx         )
                         | ({4{(~dtlb_need_replace)}} & func_find_free(dtlb_wr_vld));
//  Way 0
wire [7 : 0] dtlb_vld_way_0;
wire [`DTLB_TAG_WIDTH - 1 : 0] dtlb_tag_way_0 [7 : 0];
wire [`DTLB_DATA_WIDTH - 1 : 0] dtlb_data_way_0 [7 : 0];

wire [7 : 0] dtlb_vld_way_0_nxt = (dtlb_vld_way_0 | ({8{dtlb_vld_way_0_ena}} & func_vec8(i_dtlb_widx)));

wire dtlb_vld_way_0_ena = (i_dtlb_wren & (dtlb_wr_way == 4'd0));

gnrl_dfflr #( 
    .DATA_WIDTH   (8),
    .INITIAL_VALUE(0)
) dtlb_vld_way_0_dfflr (dtlb_vld_way_0_ena, dtlb_vld_way_0_nxt, dtlb_vld_way_0, clk, rst_n);

genvar way_0_idx;
generate
    for(way_0_idx = 0; way_0_idx < 8; way_0_idx = way_0_idx + 1) begin
        gnrl_dffl #( 
            .DATA_WIDTH(`DTLB_TAG_WIDTH)
        ) dtlb_tag_way_0_dffl (dtlb_vld_way_0_ena, i_dtlb_wtag, dtlb_tag_way_0[way_0_idx], clk);

        gnrl_dffl #( 
            .DATA_WIDTH(`DTLB_DATA_WIDTH)
        ) dtlb_data_way_0_dffl (dtlb_vld_way_0_ena, i_dtlb_wdat, dtlb_data_way_0[way_0_idx], clk);
    end    
endgenerate

//  Way 1
wire [7 : 0] dtlb_vld_way_1;
wire [`DTLB_TAG_WIDTH - 1 : 0] dtlb_tag_way_1 [7 : 0];
wire [`DTLB_DATA_WIDTH - 1 : 0] dtlb_data_way_1 [7 : 0];

wire [7 : 0] dtlb_vld_way_1_nxt = (dtlb_vld_way_1 | ({8{dtlb_vld_way_1_ena}} & func_vec8(i_dtlb_widx)));

wire dtlb_vld_way_1_ena = (i_dtlb_wren & (dtlb_wr_way == 4'd1));

gnrl_dfflr #( 
    .DATA_WIDTH   (8),
    .INITIAL_VALUE(0)
) dtlb_vld_way_1_dfflr (dtlb_vld_way_1_ena, dtlb_vld_way_1_nxt, dtlb_vld_way_1, clk, rst_n);

genvar way_1_idx;
generate
    for(way_1_idx = 0; way_1_idx < 8; way_1_idx = way_1_idx + 1) begin
        gnrl_dffl #( 
            .DATA_WIDTH(`DTLB_TAG_WIDTH)
        ) dtlb_tag_way_1_dffl (dtlb_vld_way_1_ena, i_dtlb_wtag, dtlb_tag_way_1[way_1_idx], clk);

        gnrl_dffl #( 
            .DATA_WIDTH(`DTLB_DATA_WIDTH)
        ) dtlb_data_way_1_dffl (dtlb_vld_way_1_ena, i_dtlb_wdat, dtlb_data_way_1[way_1_idx], clk);
    end    
endgenerate

//  Way 2
wire [7 : 0] dtlb_vld_way_2;
wire [`DTLB_TAG_WIDTH - 1 : 0] dtlb_tag_way_2 [7 : 0];
wire [`DTLB_DATA_WIDTH - 1 : 0] dtlb_data_way_2 [7 : 0];

wire [7 : 0] dtlb_vld_way_2_nxt = (dtlb_vld_way_2 | ({8{dtlb_vld_way_2_ena}} & func_vec8(i_dtlb_widx)));

wire dtlb_vld_way_2_ena = (i_dtlb_wren & (dtlb_wr_way == 4'd2));

gnrl_dfflr #( 
    .DATA_WIDTH   (8),
    .INITIAL_VALUE(0)
) dtlb_vld_way_2_dfflr (dtlb_vld_way_2_ena, dtlb_vld_way_2_nxt, dtlb_vld_way_2, clk, rst_n);

genvar way_2_idx;
generate
    for(way_2_idx = 0; way_2_idx < 8; way_2_idx = way_2_idx + 1) begin
        gnrl_dffl #( 
            .DATA_WIDTH(`DTLB_TAG_WIDTH)
        ) dtlb_tag_way_2_dffl (dtlb_vld_way_2_ena, i_dtlb_wtag, dtlb_tag_way_2[way_2_idx], clk);

        gnrl_dffl #( 
            .DATA_WIDTH(`DTLB_DATA_WIDTH)
        ) dtlb_data_way_2_dffl (dtlb_vld_way_2_ena, i_dtlb_wdat, dtlb_data_way_2[way_2_idx], clk);
    end    
endgenerate

//  Way 3
wire [7 : 0] dtlb_vld_way_3;
wire [`DTLB_TAG_WIDTH - 1 : 0] dtlb_tag_way_3 [7 : 0];
wire [`DTLB_DATA_WIDTH - 1 : 0] dtlb_data_way_3 [7 : 0];

wire [7 : 0] dtlb_vld_way_3_nxt = (dtlb_vld_way_3 | ({8{dtlb_vld_way_3_ena}} & func_vec8(i_dtlb_widx)));

wire dtlb_vld_way_3_ena = (i_dtlb_wren & (dtlb_wr_way == 4'd3));

gnrl_dfflr #( 
    .DATA_WIDTH   (8),
    .INITIAL_VALUE(0)
) dtlb_vld_way_3_dfflr (dtlb_vld_way_3_ena, dtlb_vld_way_3_nxt, dtlb_vld_way_3, clk, rst_n);

genvar way_3_idx;
generate
    for(way_3_idx = 0; way_3_idx < 8; way_3_idx = way_3_idx + 1) begin
        gnrl_dffl #( 
            .DATA_WIDTH(`DTLB_TAG_WIDTH)
        ) dtlb_tag_way_3_dffl (dtlb_vld_way_3_ena, i_dtlb_wtag, dtlb_tag_way_3[way_3_idx], clk);

        gnrl_dffl #( 
            .DATA_WIDTH(`DTLB_DATA_WIDTH)
        ) dtlb_data_way_3_dffl (dtlb_vld_way_3_ena, i_dtlb_wdat, dtlb_data_way_3[way_3_idx], clk);
    end    
endgenerate

//  Way 4
wire [7 : 0] dtlb_vld_way_4;
wire [`DTLB_TAG_WIDTH - 1 : 0] dtlb_tag_way_4 [7 : 0];
wire [`DTLB_DATA_WIDTH - 1 : 0] dtlb_data_way_4 [7 : 0];

wire [7 : 0] dtlb_vld_way_4_nxt = (dtlb_vld_way_4 | ({8{dtlb_vld_way_4_ena}} & func_vec8(i_dtlb_widx)));

wire dtlb_vld_way_4_ena = (i_dtlb_wren & (dtlb_wr_way == 4'd4));

gnrl_dfflr #( 
    .DATA_WIDTH   (8),
    .INITIAL_VALUE(0)
) dtlb_vld_way_4_dfflr (dtlb_vld_way_4_ena, dtlb_vld_way_4_nxt, dtlb_vld_way_4, clk, rst_n);

genvar way_4_idx;
generate
    for(way_4_idx = 0; way_4_idx < 8; way_4_idx = way_4_idx + 1) begin
        gnrl_dffl #( 
            .DATA_WIDTH(`DTLB_TAG_WIDTH)
        ) dtlb_tag_way_4_dffl (dtlb_vld_way_4_ena, i_dtlb_wtag, dtlb_tag_way_4[way_4_idx], clk);

        gnrl_dffl #( 
            .DATA_WIDTH(`DTLB_DATA_WIDTH)
        ) dtlb_data_way_4_dffl (dtlb_vld_way_4_ena, i_dtlb_wdat, dtlb_data_way_4[way_4_idx], clk);
    end    
endgenerate

//  Way 5
wire [7 : 0] dtlb_vld_way_5;
wire [`DTLB_TAG_WIDTH - 1 : 0] dtlb_tag_way_5 [7 : 0];
wire [`DTLB_DATA_WIDTH - 1 : 0] dtlb_data_way_5 [7 : 0];

wire [7 : 0] dtlb_vld_way_5_nxt = (dtlb_vld_way_5 | ({8{dtlb_vld_way_5_ena}} & func_vec8(i_dtlb_widx)));

wire dtlb_vld_way_5_ena = (i_dtlb_wren & (dtlb_wr_way == 4'd5));

gnrl_dfflr #( 
    .DATA_WIDTH   (8),
    .INITIAL_VALUE(0)
) dtlb_vld_way_5_dfflr (dtlb_vld_way_5_ena, dtlb_vld_way_5_nxt, dtlb_vld_way_5, clk, rst_n);

genvar way_5_idx;
generate
    for(way_5_idx = 0; way_5_idx < 8; way_5_idx = way_5_idx + 1) begin
        gnrl_dffl #( 
            .DATA_WIDTH(`DTLB_TAG_WIDTH)
        ) dtlb_tag_way_5_dffl (dtlb_vld_way_5_ena, i_dtlb_wtag, dtlb_tag_way_5[way_5_idx], clk);

        gnrl_dffl #( 
            .DATA_WIDTH(`DTLB_DATA_WIDTH)
        ) dtlb_data_way_5_dffl (dtlb_vld_way_5_ena, i_dtlb_wdat, dtlb_data_way_5[way_5_idx], clk);
    end    
endgenerate

//  Way 6
wire [7 : 0] dtlb_vld_way_6;
wire [`DTLB_TAG_WIDTH - 1 : 0] dtlb_tag_way_6 [7 : 0];
wire [`DTLB_DATA_WIDTH - 1 : 0] dtlb_data_way_6 [7 : 0];

wire [7 : 0] dtlb_vld_way_6_nxt = (dtlb_vld_way_6 | ({8{dtlb_vld_way_6_ena}} & func_vec8(i_dtlb_widx)));

wire dtlb_vld_way_6_ena = (i_dtlb_wren & (dtlb_wr_way == 4'd6));

gnrl_dfflr #( 
    .DATA_WIDTH   (8),
    .INITIAL_VALUE(0)
) dtlb_vld_way_6_dfflr (dtlb_vld_way_6_ena, dtlb_vld_way_6_nxt, dtlb_vld_way_6, clk, rst_n);

genvar way_6_idx;
generate
    for(way_6_idx = 0; way_6_idx < 8; way_6_idx = way_6_idx + 1) begin
        gnrl_dffl #( 
            .DATA_WIDTH(`DTLB_TAG_WIDTH)
        ) dtlb_tag_way_6_dffl (dtlb_vld_way_6_ena, i_dtlb_wtag, dtlb_tag_way_6[way_6_idx], clk);

        gnrl_dffl #( 
            .DATA_WIDTH(`DTLB_DATA_WIDTH)
        ) dtlb_data_way_6_dffl (dtlb_vld_way_6_ena, i_dtlb_wdat, dtlb_data_way_6[way_6_idx], clk);
    end    
endgenerate

//  Way 7
wire [7 : 0] dtlb_vld_way_7;
wire [`DTLB_TAG_WIDTH - 1 : 0] dtlb_tag_way_7 [7 : 0];
wire [`DTLB_DATA_WIDTH - 1 : 0] dtlb_data_way_7 [7 : 0];

wire [7 : 0] dtlb_vld_way_7_nxt = (dtlb_vld_way_7 | ({8{dtlb_vld_way_7_ena}} & func_vec8(i_dtlb_widx)));

wire dtlb_vld_way_7_ena = (i_dtlb_wren & (dtlb_wr_way == 4'd7));

gnrl_dfflr #( 
    .DATA_WIDTH   (8),
    .INITIAL_VALUE(0)
) dtlb_vld_way_7_dfflr (dtlb_vld_way_7_ena, dtlb_vld_way_7_nxt, dtlb_vld_way_7, clk, rst_n);

genvar way_7_idx;
generate
    for(way_7_idx = 0; way_7_idx < 8; way_7_idx = way_7_idx + 1) begin
        gnrl_dffl #( 
            .DATA_WIDTH(`DTLB_TAG_WIDTH)
        ) dtlb_tag_way_7_dffl (dtlb_vld_way_7_ena, i_dtlb_wtag, dtlb_tag_way_7[way_7_idx], clk);

        gnrl_dffl #( 
            .DATA_WIDTH(`DTLB_DATA_WIDTH)
        ) dtlb_data_way_7_dffl (dtlb_vld_way_7_ena, i_dtlb_wdat, dtlb_data_way_7[way_7_idx], clk);
    end    
endgenerate

//  Way 8
wire [7 : 0] dtlb_vld_way_8;
wire [`DTLB_TAG_WIDTH - 1 : 0] dtlb_tag_way_8 [7 : 0];
wire [`DTLB_DATA_WIDTH - 1 : 0] dtlb_data_way_8 [7 : 0];

wire [7 : 0] dtlb_vld_way_8_nxt = (dtlb_vld_way_8 | ({8{dtlb_vld_way_8_ena}} & func_vec8(i_dtlb_widx)));

wire dtlb_vld_way_8_ena = (i_dtlb_wren & (dtlb_wr_way == 4'd8));

gnrl_dfflr #( 
    .DATA_WIDTH   (8),
    .INITIAL_VALUE(0)
) dtlb_vld_way_8_dfflr (dtlb_vld_way_8_ena, dtlb_vld_way_8_nxt, dtlb_vld_way_8, clk, rst_n);

genvar way_8_idx;
generate
    for(way_8_idx = 0; way_8_idx < 8; way_8_idx = way_8_idx + 1) begin
        gnrl_dffl #( 
            .DATA_WIDTH(`DTLB_TAG_WIDTH)
        ) dtlb_tag_way_8_dffl (dtlb_vld_way_8_ena, i_dtlb_wtag, dtlb_tag_way_8[way_8_idx], clk);

        gnrl_dffl #( 
            .DATA_WIDTH(`DTLB_DATA_WIDTH)
        ) dtlb_data_way_8_dffl (dtlb_vld_way_8_ena, i_dtlb_wdat, dtlb_data_way_8[way_8_idx], clk);
    end    
endgenerate

//  Way 9
wire [7 : 0] dtlb_vld_way_9;
wire [`DTLB_TAG_WIDTH - 1 : 0] dtlb_tag_way_9 [7 : 0];
wire [`DTLB_DATA_WIDTH - 1 : 0] dtlb_data_way_9 [7 : 0];


wire [7 : 0] dtlb_vld_way_9_nxt = (dtlb_vld_way_9 | ({8{dtlb_vld_way_9_ena}} & func_vec8(i_dtlb_widx)));

wire dtlb_vld_way_9_ena = (i_dtlb_wren & (dtlb_wr_way == 4'd9));

gnrl_dfflr #( 
    .DATA_WIDTH   (8),
    .INITIAL_VALUE(0)
) dtlb_vld_way_9_dfflr (dtlb_vld_way_9_ena, dtlb_vld_way_9_nxt, dtlb_vld_way_9, clk, rst_n);

genvar way_9_idx;
generate
    for(way_9_idx = 0; way_9_idx < 8; way_9_idx = way_9_idx + 1) begin
        gnrl_dffl #( 
            .DATA_WIDTH(`DTLB_TAG_WIDTH)
        ) dtlb_tag_way_9_dffl (dtlb_vld_way_9_ena, i_dtlb_wtag, dtlb_tag_way_9[way_9_idx], clk);

        gnrl_dffl #( 
            .DATA_WIDTH(`DTLB_DATA_WIDTH)
        ) dtlb_data_way_9_dffl (dtlb_vld_way_9_ena, i_dtlb_wdat, dtlb_data_way_9[way_9_idx], clk);
    end    
endgenerate

//  Way 10
wire [7 : 0] dtlb_vld_way_10;
wire [`DTLB_TAG_WIDTH - 1 : 0] dtlb_tag_way_10 [7 : 0];
wire [`DTLB_DATA_WIDTH - 1 : 0] dtlb_data_way_10 [7 : 0];

wire [7 : 0] dtlb_vld_way_10_nxt = (dtlb_vld_way_10 | ({8{dtlb_vld_way_10_ena}} & func_vec8(i_dtlb_widx)));

wire dtlb_vld_way_10_ena = (i_dtlb_wren & (dtlb_wr_way == 4'd10));

gnrl_dfflr #( 
    .DATA_WIDTH   (8),
    .INITIAL_VALUE(0)
) dtlb_vld_way_10_dfflr (dtlb_vld_way_10_ena, dtlb_vld_way_10_nxt, dtlb_vld_way_10, clk, rst_n);

genvar way_10_idx;
generate
    for(way_10_idx = 0; way_10_idx < 8; way_10_idx = way_10_idx + 1) begin
        gnrl_dffl #( 
            .DATA_WIDTH(`DTLB_TAG_WIDTH)
        ) dtlb_tag_way_10_dffl (dtlb_vld_way_10_ena, i_dtlb_wtag, dtlb_tag_way_10[way_10_idx], clk);

        gnrl_dffl #( 
            .DATA_WIDTH(`DTLB_DATA_WIDTH)
        ) dtlb_data_way_10_dffl (dtlb_vld_way_10_ena, i_dtlb_wdat, dtlb_data_way_10[way_10_idx], clk);
    end    
endgenerate

//  Way 11
wire [7 : 0] dtlb_vld_way_11;
wire [`DTLB_TAG_WIDTH - 1 : 0] dtlb_tag_way_11 [7 : 0];
wire [`DTLB_DATA_WIDTH - 1 : 0] dtlb_data_way_11 [7 : 0];

wire [7 : 0] dtlb_vld_way_11_nxt = (dtlb_vld_way_11 | ({8{dtlb_vld_way_11_ena}} & func_vec8(i_dtlb_widx)));

wire dtlb_vld_way_11_ena = (i_dtlb_wren & (dtlb_wr_way == 4'd11));

gnrl_dfflr #( 
    .DATA_WIDTH   (8),
    .INITIAL_VALUE(0)
) dtlb_vld_way_11_dfflr (dtlb_vld_way_11_ena, dtlb_vld_way_11_nxt, dtlb_vld_way_11, clk, rst_n);

genvar way_11_idx;
generate
    for(way_11_idx = 0; way_11_idx < 8; way_11_idx = way_11_idx + 1) begin
        gnrl_dffl #( 
            .DATA_WIDTH(`DTLB_TAG_WIDTH)
        ) dtlb_tag_way_11_dffl (dtlb_vld_way_11_ena, i_dtlb_wtag, dtlb_tag_way_11[way_11_idx], clk);

        gnrl_dffl #( 
            .DATA_WIDTH(`DTLB_DATA_WIDTH)
        ) dtlb_data_way_11_dffl (dtlb_vld_way_11_ena, i_dtlb_wdat, dtlb_data_way_11[way_11_idx], clk);
    end    
endgenerate

//  Way 12
wire [7 : 0] dtlb_vld_way_12;
wire [`DTLB_TAG_WIDTH - 1 : 0] dtlb_tag_way_12 [7 : 0];
wire [`DTLB_DATA_WIDTH - 1 : 0] dtlb_data_way_12 [7 : 0];

wire [7 : 0] dtlb_vld_way_12_nxt = (dtlb_vld_way_12 | ({8{dtlb_vld_way_12_ena}} & func_vec8(i_dtlb_widx)));

wire dtlb_vld_way_12_ena = (i_dtlb_wren & (dtlb_wr_way == 4'd12));

gnrl_dfflr #( 
    .DATA_WIDTH   (8),
    .INITIAL_VALUE(0)
) dtlb_vld_way_12_dfflr (dtlb_vld_way_12_ena, dtlb_vld_way_12_nxt, dtlb_vld_way_12, clk, rst_n);

genvar way_12_idx;
generate
    for(way_12_idx = 0; way_12_idx < 8; way_12_idx = way_12_idx + 1) begin
        gnrl_dffl #( 
            .DATA_WIDTH(`DTLB_TAG_WIDTH)
        ) dtlb_tag_way_12_dffl (dtlb_vld_way_12_ena, i_dtlb_wtag, dtlb_tag_way_12[way_12_idx], clk);

        gnrl_dffl #( 
            .DATA_WIDTH(`DTLB_DATA_WIDTH)
        ) dtlb_data_way_12_dffl (dtlb_vld_way_12_ena, i_dtlb_wdat, dtlb_data_way_12[way_12_idx], clk);
    end    
endgenerate

//  Way 13
wire [7 : 0] dtlb_vld_way_13;
wire [`DTLB_TAG_WIDTH - 1 : 0] dtlb_tag_way_13 [7 : 0];
wire [`DTLB_DATA_WIDTH - 1 : 0] dtlb_data_way_13 [7 : 0];

wire [7 : 0] dtlb_vld_way_13_nxt = (dtlb_vld_way_13 | ({8{dtlb_vld_way_13_ena}} & func_vec8(i_dtlb_widx)));

wire dtlb_vld_way_13_ena = (i_dtlb_wren & (dtlb_wr_way == 4'd13));

gnrl_dfflr #( 
    .DATA_WIDTH   (8),
    .INITIAL_VALUE(0)
) dtlb_vld_way_13_dfflr (dtlb_vld_way_13_ena, dtlb_vld_way_13_nxt, dtlb_vld_way_13, clk, rst_n);

genvar way_13_idx;
generate
    for(way_13_idx = 0; way_13_idx < 8; way_13_idx = way_13_idx + 1) begin
        gnrl_dffl #( 
            .DATA_WIDTH(`DTLB_TAG_WIDTH)
        ) dtlb_tag_way_13_dffl (dtlb_vld_way_13_ena, i_dtlb_wtag, dtlb_tag_way_13[way_13_idx], clk);

        gnrl_dffl #( 
            .DATA_WIDTH(`DTLB_DATA_WIDTH)
        ) dtlb_data_way_13_dffl (dtlb_vld_way_13_ena, i_dtlb_wdat, dtlb_data_way_13[way_13_idx], clk);
    end    
endgenerate

//  Way 14
wire [7 : 0] dtlb_vld_way_14;
wire [`DTLB_TAG_WIDTH - 1 : 0] dtlb_tag_way_14 [7 : 0];
wire [`DTLB_DATA_WIDTH - 1 : 0] dtlb_data_way_14 [7 : 0];

wire [7 : 0] dtlb_vld_way_14_nxt = (dtlb_vld_way_14 | ({8{dtlb_vld_way_14_ena}} & func_vec8(i_dtlb_widx)));

wire dtlb_vld_way_14_ena = (i_dtlb_wren & (dtlb_wr_way == 4'd14));

gnrl_dfflr #( 
    .DATA_WIDTH   (8),
    .INITIAL_VALUE(0)
) dtlb_vld_way_14_dfflr (dtlb_vld_way_14_ena, dtlb_vld_way_14_nxt, dtlb_vld_way_14, clk, rst_n);

genvar way_14_idx;
generate
    for(way_14_idx = 0; way_14_idx < 8; way_14_idx = way_14_idx + 1) begin
        gnrl_dffl #( 
            .DATA_WIDTH(`DTLB_TAG_WIDTH)
        ) dtlb_tag_way_14_dffl (dtlb_vld_way_14_ena, i_dtlb_wtag, dtlb_tag_way_14[way_14_idx], clk);

        gnrl_dffl #( 
            .DATA_WIDTH(`DTLB_DATA_WIDTH)
        ) dtlb_data_way_14_dffl (dtlb_vld_way_14_ena, i_dtlb_wdat, dtlb_data_way_14[way_14_idx], clk);
    end    
endgenerate

//  Way 15
wire [7 : 0] dtlb_vld_way_15;
wire [`DTLB_TAG_WIDTH - 1 : 0] dtlb_tag_way_15 [7 : 0];
wire [`DTLB_DATA_WIDTH - 1 : 0] dtlb_data_way_15 [7 : 0];

wire [7 : 0] dtlb_vld_way_15_nxt = (dtlb_vld_way_15 | ({8{dtlb_vld_way_15_ena}} & func_vec8(i_dtlb_widx)));

wire dtlb_vld_way_15_ena = (i_dtlb_wren & (dtlb_wr_way == 4'd15));

gnrl_dfflr #( 
    .DATA_WIDTH   (8),
    .INITIAL_VALUE(0)
) dtlb_vld_way_15_dfflr (dtlb_vld_way_15_ena, dtlb_vld_way_15_nxt, dtlb_vld_way_15, clk, rst_n);

genvar way_15_idx;
generate
    for(way_15_idx = 0; way_15_idx < 8; way_15_idx = way_15_idx + 1) begin
        gnrl_dffl #( 
            .DATA_WIDTH(`DTLB_TAG_WIDTH)
        ) dtlb_tag_way_15_dffl (dtlb_vld_way_15_ena, i_dtlb_wtag, dtlb_tag_way_15[way_15_idx], clk);

        gnrl_dffl #( 
            .DATA_WIDTH(`DTLB_DATA_WIDTH)
        ) dtlb_data_way_15_dffl (dtlb_vld_way_15_ena, i_dtlb_wdat, dtlb_data_way_15[way_15_idx], clk);
    end    
endgenerate
//

wire [15 : 0] dtlb_hit = {
                            (i_dtlb_rden & dtlb_vld_way_15[i_dtlb_ridx] & (dtlb_tag_way_15[i_dtlb_ridx] == i_dtlb_rtag))
                        ,   (i_dtlb_rden & dtlb_vld_way_14[i_dtlb_ridx] & (dtlb_tag_way_14[i_dtlb_ridx] == i_dtlb_rtag))
                        ,   (i_dtlb_rden & dtlb_vld_way_13[i_dtlb_ridx] & (dtlb_tag_way_13[i_dtlb_ridx] == i_dtlb_rtag))
                        ,   (i_dtlb_rden & dtlb_vld_way_12[i_dtlb_ridx] & (dtlb_tag_way_12[i_dtlb_ridx] == i_dtlb_rtag))
                        ,   (i_dtlb_rden & dtlb_vld_way_11[i_dtlb_ridx] & (dtlb_tag_way_11[i_dtlb_ridx] == i_dtlb_rtag))
                        ,   (i_dtlb_rden & dtlb_vld_way_10[i_dtlb_ridx] & (dtlb_tag_way_10[i_dtlb_ridx] == i_dtlb_rtag))
                        ,   (i_dtlb_rden & dtlb_vld_way_9[i_dtlb_ridx]  & (dtlb_tag_way_9[i_dtlb_ridx]  == i_dtlb_rtag))
                        ,   (i_dtlb_rden & dtlb_vld_way_8[i_dtlb_ridx]  & (dtlb_tag_way_8[i_dtlb_ridx]  == i_dtlb_rtag))
                        ,   (i_dtlb_rden & dtlb_vld_way_7[i_dtlb_ridx]  & (dtlb_tag_way_7[i_dtlb_ridx]  == i_dtlb_rtag))
                        ,   (i_dtlb_rden & dtlb_vld_way_6[i_dtlb_ridx]  & (dtlb_tag_way_6[i_dtlb_ridx]  == i_dtlb_rtag))
                        ,   (i_dtlb_rden & dtlb_vld_way_5[i_dtlb_ridx]  & (dtlb_tag_way_5[i_dtlb_ridx]  == i_dtlb_rtag))
                        ,   (i_dtlb_rden & dtlb_vld_way_4[i_dtlb_ridx]  & (dtlb_tag_way_4[i_dtlb_ridx]  == i_dtlb_rtag))
                        ,   (i_dtlb_rden & dtlb_vld_way_3[i_dtlb_ridx]  & (dtlb_tag_way_3[i_dtlb_ridx]  == i_dtlb_rtag))
                        ,   (i_dtlb_rden & dtlb_vld_way_2[i_dtlb_ridx]  & (dtlb_tag_way_2[i_dtlb_ridx]  == i_dtlb_rtag))
                        ,   (i_dtlb_rden & dtlb_vld_way_1[i_dtlb_ridx]  & (dtlb_tag_way_1[i_dtlb_ridx]  == i_dtlb_rtag))
                        ,   (i_dtlb_rden & dtlb_vld_way_0[i_dtlb_ridx]  & (dtlb_tag_way_0[i_dtlb_ridx]  == i_dtlb_rtag))
                        
                    };

assign o_dtlb_hit = (|dtlb_hit);
assign o_dtlb_rdat= ({`DTLB_DATA_WIDTH{dtlb_hit[ 0]}} & dtlb_data_way_0[i_dtlb_ridx] )
                  | ({`DTLB_DATA_WIDTH{dtlb_hit[ 1]}} & dtlb_data_way_1[i_dtlb_ridx] )
                  | ({`DTLB_DATA_WIDTH{dtlb_hit[ 2]}} & dtlb_data_way_2[i_dtlb_ridx] )
                  | ({`DTLB_DATA_WIDTH{dtlb_hit[ 3]}} & dtlb_data_way_3[i_dtlb_ridx] )
                  | ({`DTLB_DATA_WIDTH{dtlb_hit[ 4]}} & dtlb_data_way_4[i_dtlb_ridx] )
                  | ({`DTLB_DATA_WIDTH{dtlb_hit[ 5]}} & dtlb_data_way_5[i_dtlb_ridx] )
                  | ({`DTLB_DATA_WIDTH{dtlb_hit[ 6]}} & dtlb_data_way_6[i_dtlb_ridx] )
                  | ({`DTLB_DATA_WIDTH{dtlb_hit[ 7]}} & dtlb_data_way_7[i_dtlb_ridx] )
                  | ({`DTLB_DATA_WIDTH{dtlb_hit[ 8]}} & dtlb_data_way_8[i_dtlb_ridx] )
                  | ({`DTLB_DATA_WIDTH{dtlb_hit[ 9]}} & dtlb_data_way_9[i_dtlb_ridx] )
                  | ({`DTLB_DATA_WIDTH{dtlb_hit[10]}} & dtlb_data_way_10[i_dtlb_ridx])
                  | ({`DTLB_DATA_WIDTH{dtlb_hit[11]}} & dtlb_data_way_11[i_dtlb_ridx])
                  | ({`DTLB_DATA_WIDTH{dtlb_hit[12]}} & dtlb_data_way_12[i_dtlb_ridx])
                  | ({`DTLB_DATA_WIDTH{dtlb_hit[13]}} & dtlb_data_way_13[i_dtlb_ridx])
                  | ({`DTLB_DATA_WIDTH{dtlb_hit[14]}} & dtlb_data_way_14[i_dtlb_ridx])
                  | ({`DTLB_DATA_WIDTH{dtlb_hit[15]}} & dtlb_data_way_15[i_dtlb_ridx]);


//  Replace
wire [3 : 0] i_plru_hit_idx = func_vec16r(dtlb_hit);
wire i_plru_req = (i_dtlb_wren & dtlb_need_replace);
wire [3 : 0] o_plru_replace_idx;

plru16_module plru16 (
    .plru_hit        (o_dtlb_hit),
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

endmodule   //  dtlb_module

`endif  /*  !__EXU_DTLB_V__!    */