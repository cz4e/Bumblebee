`ifdef __EXU_DCACHE_V__

module dcache_module ( 
    input                                           i_dcache_rden,
    input   [`DCACHE_TAG_WIDTH - 1  : 0]            i_dcache_rtag,
    input   [`DCACHE_IDX_WIDTH - 1  : 0]            i_dcache_ridx,

    input                                           i_dcache_wren,
    input   [`DCACHE_IDX_WIDTH - 1  : 0]            i_dcache_widx,
    input   [`DCACHE_TAG_WIDTH - 1  : 0]            i_dcache_wtag,
    input   [`DCACHE_MASK_WIDTH - 1 : 0]            i_dcache_wmask,
    input   [`DCACHE_DATA_WIDTH - 1 : 0]            i_dcache_wdat,

    input                                           i_dcache_rep,
    input   [`DCACHE_DATA_WIDTH - 1 : 0]            i_dcache_rep_dat,

    output                                          o_dcache_hit,
    output  [`DCACHE_DATA_WIDTH - 1 : 0]            o_dcache_rdat,

    output                                          o_dcache_wb,
    output  [`PHY_ADDR_WIDTH - 1    : 0]            o_dcache_wb_addr,
    output  [`DCACHE_DATA_WIDTH - 1 : 0]            o_dcache_wb_dat,

    input                                           clk,
    input                                           rst_n
);

//  Way 0
wire [255 : 0] dcache_vld_way_0;
wire [255 : 0] dcache_dirty_way_0;
wire [`DCACHE_TAG_WIDTH - 1 : 0] dcache_tag_way_0 [255 : 0];
reg  [`DCACHE_DATA_WIDTH - 1 : 0] dcache_data_way_0_r [255 : 0];


//  Way 1
wire [255 : 0] dcache_vld_way_1;
wire [255 : 0] dcache_dirty_way_1;
wire [`DCACHE_TAG_WIDTH - 1 : 0] dcache_tag_way_1 [255 : 0];
reg  [`DCACHE_DATA_WIDTH - 1 : 0] dcache_data_way_1_r [255 : 0];

//  Way 2
wire [255 : 0] dcache_vld_way_2;
wire [255 : 0] dcache_dirty_way_2;
wire [`DCACHE_TAG_WIDTH - 1 : 0] dcache_tag_way_2 [255 : 0];
reg  [`DCACHE_DATA_WIDTH - 1 : 0] dcache_data_way_2_r [255 : 0];

//  Way 3
wire [255 : 0] dcache_vld_way_3;
wire [255 : 0] dcache_dirty_way_3;
wire [`DCACHE_TAG_WIDTH - 1 : 0] dcache_tag_way_3 [255 : 0];
reg  [`DCACHE_DATA_WIDTH - 1 : 0] dcache_data_way_3_r [255 : 0];

//
wire [`DCACHE_IDX_WIDTH - 1 : 0] dcache_idx = (i_dcache_rden ? i_dcache_ridx : i_dcache_widx);
wire [`DCACHE_TAG_WIDTH - 1 : 0] dcache_tag = (i_dcache_rden ? i_dcache_rtag : i_dcache_wtag);

wire [3 : 0] dcache_vld_vec = {
                                    dcache_vld_way_3[dcache_idx]
                                ,   dcache_vld_way_2[dcache_idx]
                                ,   dcache_vld_way_1[dcache_idx]
                                ,   dcache_vld_way_0[dcache_idx]
                            };
wire [1 : 0] dcache_wr_way = (i_plru_req ? o_plru_replace_idx : func_vec4(dcache_vld_vec));

wire [3 : 0] dcache_hit_vec = {
                                    (dcache_vld_vec[3] & (dcache_tag_way_3[dcache_idx] == dcache_tag))
                                ,   (dcache_vld_vec[2] & (dcache_tag_way_2[dcache_idx] == dcache_tag))
                                ,   (dcache_vld_vec[1] & (dcache_tag_way_1[dcache_idx] == dcache_tag))
                                ,   (dcache_vld_vec[0] & (dcache_tag_way_0[dcache_idx] == dcache_tag))
                            };

wire [3 : 0] dcache_dirty_vec = {
                                    (dcache_dirty_way_3[dcache_idx] & (dcache_wr_way == 2'd3))
                                ,   (dcache_dirty_way_2[dcache_idx] & (dcache_wr_way == 2'd2))
                                ,   (dcache_dirty_way_1[dcache_idx] & (dcache_wr_way == 2'd1))
                                ,   (dcache_dirty_way_0[dcache_idx] & (dcache_wr_way == 2'd0))
                                };

//  Read
assign o_dcache_hit = (|dcache_hit_vec);
assign o_dcache_rdat = ({`DCACHE_DATA_WIDTH{dcache_hit_vec[3]}} & dcache_data_way_3_r[dcache_idx])
                     | ({`DCACHE_DATA_WIDTH{dcache_hit_vec[2]}} & dcache_data_way_2_r[dcache_idx])
                     | ({`DCACHE_DATA_WIDTH{dcache_hit_vec[1]}} & dcache_data_way_1_r[dcache_idx])
                     | ({`DCACHE_DATA_WIDTH{dcache_hit_vec[0]}} & dcache_data_way_0_r[dcache_idx]);

assign o_dcache_wb = ((i_dcache_rden | i_dcache_wren) & (~o_dcache_hit) & (|dcache_dirty_vec));
assign o_dcache_wb_dat = ({`DCACHE_DATA_WIDTH{(o_plru_replace_idx == 2'd3)}} & dcache_data_way_3_r[dcache_idx])
                       | ({`DCACHE_DATA_WIDTH{(o_plru_replace_idx == 2'd2)}} & dcache_data_way_2_r[dcache_idx])
                       | ({`DCACHE_DATA_WIDTH{(o_plru_replace_idx == 2'd1)}} & dcache_data_way_1_r[dcache_idx])
                       | ({`DCACHE_DATA_WIDTH{(o_plru_replace_idx == 2'd0)}} & dcache_data_way_0_r[dcache_idx]);
//  Write
wire [255 : 0] dcache_vld_set_vec; 
wire [255 : 0] dcache_dirty_set_vec;
wire [255 : 0] dcache_dirty_clr_vec = dcache_vld_set_vec;

genvar i;
generate
    for(i = 0; i < 256; i = i + 1) begin
        assign dcache_vld_set_vec[i] = (i == dcache_idx);
        assign dcache_dirty_set_vec[i] = (o_dcache_hit & (i == dcache_idx));
    end
endgenerate

//  Way 0
wire dcache_vld_way_0_ena = (i_dcache_rep & (dcache_wr_way == 2'd0));
wire [255 : 0] dcache_vld_way_0_nxt = (dcache_vld_way_0 | dcache_vld_set_vec);

gnrl_dfflr #( 
    .DATA_WIDTH   (256),
    .INITIAL_VALUE(0)
) dcache_vld_way_0_dfflr (dcache_vld_way_0_ena, dcache_vld_way_0_nxt, dcache_vld_way_0, clk, rst_n);

wire dcache_dirty_way_0_ena = (dcache_vld_way_0_ena | (i_dcache_wren & dcache_hit_vec[0]));
wire [255 : 0] dcache_dirty_way_0_nxt = ((dcache_dirty_way_0 | dcache_dirty_set_vec) & (~dcache_dirty_clr_vec));

gnrl_dfflr #( 
    .DATA_WIDTH   (256),
    .INITIAL_VALUE(0)
) dcache_dirty_way_0_dfflr (dcache_dirty_way_0_ena, dcache_dirty_way_0_nxt, dcache_dirty_way_0, clk, rst_n);

//
wire [255 : 0] dcache_way_0_wren;

genvar wtag_idx_0;
generate
    for(wtag_idx_0 = 0; wtag_idx_0 < 256; wtag_idx_0 = wtag_idx_0 + 1) begin
        assign dcache_way_0_wren[wtag_idx_0] = (dcache_vld_way_0_ena & (wtag_idx_0 == dcache_idx));
        gnrl_dffl #( 
            .DATA_WIDTH(`DCACHE_TAG_WIDTH)
        ) dcache_tag_way_0_dffl (dcache_way_0_wren[wtag_idx_0], dcache_tag, dcache_tag_way_0[wtag_idx_0], clk);
    end
endgenerate

//
wire [`DCACHE_MASK_WIDTH - 1 : 0] dcache_wren_vec_0 = ({`DCACHE_MASK_WIDTH{(i_dcache_wren & dcache_hit_vec[0])}} & i_dcache_wmask            )
                                                    | ({`DCACHE_MASK_WIDTH{dcache_vld_way_0_ena               }} & {`DCACHE_MASK_WIDTH{1'b1}});
genvar wdat_idx_0;
generate
    for(wdat_idx_0 = 0; wdat_idx_0 < `DCACHE_MASK_WIDTH; wdat_idx_0 = wdat_idx_0 + 1) begin
        if((8 * wdat_idx_0 + 8) > `DCACHE_DATA_WIDTH) begin
            always @(posedge clk) begin
                if(dcache_wren_vec_0[wdat_idx_0]) begin
                    dcache_data_way_0_r[dcache_idx][`DCACHE_DATA_WIDTH - 1 : 8 * wdat_idx_0] <= #1 (i_dcache_rep ? i_dcache_rep_dat[`DCACHE_DATA_WIDTH - 1 : 8 * wdat_idx_0] : i_dcache_wdat[`DCACHE_DATA_WIDTH - 1 : 8 * wdat_idx_0]);
                end
            end
        end
        else begin
            always @(posedge clk) begin
                if(dcache_wren_vec_0[wdat_idx_0]) begin
                    dcache_data_way_0_r[dcache_idx][8 * wdat_idx_0 + 7 : 8 * wdat_idx_0] <= #1 (i_dcache_rep ? i_dcache_rep_dat[8 * wdat_idx_0 + 7 : 8 * wdat_idx_0] : i_dcache_wdat[8 * wdat_idx_0 + 7 : 8 * wdat_idx_0]);
                end
            end
        end
    end
endgenerate


//  Way 1
wire dcache_vld_way_1_ena = (i_dcache_rep & (dcache_wr_way == 2'd1));
wire [255 : 0] dcache_vld_way_1_nxt = (dcache_vld_way_1 | dcache_vld_set_vec);

gnrl_dfflr #( 
    .DATA_WIDTH   (256),
    .INITIAL_VALUE(0)
) dcache_vld_way_1_dfflr (dcache_vld_way_1_ena, dcache_vld_way_1_nxt, dcache_vld_way_1, clk, rst_n);

wire dcache_dirty_way_1_ena = (dcache_vld_way_1_ena | (i_dcache_wren & dcache_hit_vec[1]));
wire [255 : 0] dcache_dirty_way_1_nxt = ((dcache_dirty_way_1 | dcache_dirty_set_vec) & (~dcache_dirty_clr_vec));

gnrl_dfflr #( 
    .DATA_WIDTH   (256),
    .INITIAL_VALUE(0)
) dcache_dirty_way_1_dfflr (dcache_dirty_way_1_ena, dcache_dirty_way_1_nxt, dcache_dirty_way_1, clk, rst_n);

//
wire [255 : 0] dcache_way_1_wren;

genvar wtag_idx_1;
generate
    for(wtag_idx_1 = 0; wtag_idx_1 < 256; wtag_idx_1 = wtag_idx_1 + 1) begin
        assign dcache_way_1_wren[wtag_idx_1] = (dcache_vld_way_1_ena & (wtag_idx_1 == dcache_idx));
        gnrl_dffl #( 
            .DATA_WIDTH(`DCACHE_TAG_WIDTH)
        ) dcache_tag_way_1_dffl (dcache_way_1_wren[wtag_idx_1], dcache_tag, dcache_tag_way_1[wtag_idx_1], clk);
    end
endgenerate

//
wire [`DCACHE_MASK_WIDTH - 1 : 0] dcache_wren_vec_1 = ({`DCACHE_MASK_WIDTH{(i_dcache_wren & dcache_hit_vec[1])}} & i_dcache_wmask            )
                                                    | ({`DCACHE_MASK_WIDTH{dcache_vld_way_1_ena               }} & {`DCACHE_MASK_WIDTH{1'b1}});

genvar wdat_idx_1;
generate
    for(wdat_idx_1 = 0; wdat_idx_1 < `DCACHE_MASK_WIDTH; wdat_idx_1 = wdat_idx_1 + 1) begin
       if((8 * wdat_idx_1 + 8) > `DCACHE_DATA_WIDTH) begin
           always @(posedge clk) begin
               if(dcache_wren_vec_1[wdat_idx_1]) begin
                   dcache_data_way_1_r[wdat_idx_1][`DCACHE_DATA_WIDTH - 1 : 8 * wdat_idx_1] <= #1 (i_dcache_rep ? i_dcache_rep_dat[`DCACHE_DATA_WIDTH - 1 : 8 * wdat_idx_1] : i_dcache_wdat[`DCACHE_DATA_WIDTH - 1 : 8 * wdat_idx_1]);
               end
           end
       end 
       else begin
           always @(posedge clk) begin
               if(dcache_wren_vec_1[wdat_idx_1]) begin
                   dcache_data_way_1_r[wdat_idx_1][8 * wdat_idx_1 + 7 : 8 * wdat_idx_1] <= #1 (i_dcache_rep ? i_dcache_rep_dat[8 * wdat_idx_1 + 7 : 8 * wdat_idx_1] : i_dcache_wdat[8 * wdat_idx_1 + 7 : 8 * wdat_idx_1]);
               end
           end
       end
    end
endgenerate

//  Way 2
wire dcache_vld_way_2_ena = (i_dcache_rep & (dcache_wr_way == 2'd2));
wire [255 : 0] dcache_vld_way_2_nxt = (dcache_vld_way_2 | dcache_vld_set_vec);

gnrl_dfflr #( 
    .DATA_WIDTH   (256),
    .INITIAL_VALUE(0)
) dcache_vld_way_2_dfflr (dcache_vld_way_2_ena, dcache_vld_way_2_nxt, dcache_vld_way_2, clk, rst_n);

wire dcache_dirty_way_2_ena = (dcache_vld_way_2_ena | (i_dcache_wren & dcache_hit_vec[2]));
wire [255 : 0] dcache_dirty_way_2_nxt = ((dcache_dirty_way_2 | dcache_dirty_set_vec) & (~dcache_dirty_clr_vec));

gnrl_dfflr #( 
    .DATA_WIDTH   (256),
    .INITIAL_VALUE(0)
) dcache_dirty_way_2_dfflr (dcache_dirty_way_2_ena, dcache_dirty_way_2_nxt, dcache_dirty_way_2, clk, rst_n);

//
wire [255 : 0] dcache_way_2_wren;

genvar wtag_idx_2;
generate
    for(wtag_idx_2 = 0; wtag_idx_2 < 256; wtag_idx_2 = wtag_idx_2 + 1) begin
        assign dcache_way_2_wren[wtag_idx_2] = (dcache_vld_way_2_ena & (wtag_idx_2 == dcache_idx));
        gnrl_dffl #( 
            .DATA_WIDTH(`DCACHE_TAG_WIDTH)
        ) dcache_tag_way_2_dffl (dcache_way_2_wren[wtag_idx_2], dcache_tag, dcache_tag_way_2[wtag_idx_2], clk);
    end
endgenerate

//
wire [`DCACHE_MASK_WIDTH - 1 : 0] dcache_wren_vec_2 = ({`DCACHE_MASK_WIDTH{(i_dcache_wren & dcache_hit_vec[2])}} & i_dcache_wmask            )
                                                    | ({`DCACHE_MASK_WIDTH{dcache_vld_way_2_ena               }} & {`DCACHE_MASK_WIDTH{1'b1}});

genvar wdat_idx_2;
generate
    for(wdat_idx_2 = 0; wdat_idx_2 < `DCACHE_MASK_WIDTH; wdat_idx_2 = wdat_idx_2 + 1) begin
       if((8 * wdat_idx_2 + 8) > `DCACHE_DATA_WIDTH) begin
           always @(posedge clk) begin
               if(dcache_wren_vec_2[wdat_idx_2]) begin
                   dcache_data_way_2_r[wdat_idx_2][`DCACHE_DATA_WIDTH - 1 : 8 * wdat_idx_2] <= #1 (i_dcache_rep ? i_dcache_rep_dat[`DCACHE_DATA_WIDTH - 1 : 8 * wdat_idx_2] : i_dcache_wdat[`DCACHE_DATA_WIDTH - 1 : 8 * wdat_idx_2]);
               end
           end
       end 
       else begin
           always @(posedge clk) begin
               if(dcache_wren_vec_2[wdat_idx_2]) begin
                   dcache_data_way_2_r[wdat_idx_2][8 * wdat_idx_2 + 7 : 8 * wdat_idx_2] <= #1 (i_dcache_rep ? i_dcache_rep_dat[8 * wdat_idx_2 + 7 : 8 * wdat_idx_2] : i_dcache_wdat[8 * wdat_idx_2 + 7 : 8 * wdat_idx_2]);
               end
           end
       end
    end
endgenerate

//  Way 3
wire dcache_vld_way_3_ena = (i_dcache_rep & (dcache_wr_way == 2'd3));
wire [255 : 0] dcache_vld_way_3_nxt = (dcache_vld_way_3 | dcache_vld_set_vec);

gnrl_dfflr #( 
    .DATA_WIDTH   (256),
    .INITIAL_VALUE(0)
) dcache_vld_way_3_dfflr (dcache_vld_way_3_ena, dcache_vld_way_3_nxt, dcache_vld_way_3, clk, rst_n);

wire dcache_dirty_way_3_ena = (dcache_vld_way_3_ena | (i_dcache_wren & dcache_hit_vec[3]));
wire [255 : 0] dcache_dirty_way_3_nxt = ((dcache_dirty_way_3 | dcache_dirty_set_vec) & (~dcache_dirty_clr_vec));

gnrl_dfflr #( 
    .DATA_WIDTH   (256),
    .INITIAL_VALUE(0)
) dcache_dirty_way_3_dfflr (dcache_dirty_way_3_ena, dcache_dirty_way_3_nxt, dcache_dirty_way_3, clk, rst_n);

//
wire [255 : 0] dcache_way_3_wren;

genvar wtag_idx_3;
generate
    for(wtag_idx_3 = 0; wtag_idx_3 < 256; wtag_idx_3 = wtag_idx_3 + 1) begin
        assign dcache_way_3_wren[wtag_idx_3] = (dcache_vld_way_3_ena & (wtag_idx_3 == dcache_idx));
        gnrl_dffl #( 
            .DATA_WIDTH(`DCACHE_TAG_WIDTH)
        ) dcache_tag_way_3_dffl (dcache_way_3_wren[wtag_idx_3], dcache_tag, dcache_tag_way_3[wtag_idx_3], clk);
    end
endgenerate

//
wire [`DCACHE_MASK_WIDTH - 1 : 0] dcache_wren_vec_3 = ({`DCACHE_MASK_WIDTH{(i_dcache_wren & dcache_hit_vec[3])}} & i_dcache_wmask            )
                                                    | ({`DCACHE_MASK_WIDTH{dcache_vld_way_3_ena               }} & {`DCACHE_MASK_WIDTH{1'b1}});

genvar wdat_idx_3;
generate
    for(wdat_idx_3 = 0; wdat_idx_3 < `DCACHE_MASK_WIDTH; wdat_idx_3 = wdat_idx_3 + 1) begin
       if((8 * wdat_idx_3 + 8) > `DCACHE_DATA_WIDTH) begin
           always @(posedge clk) begin
               if(dcache_wren_vec_3[wdat_idx_3]) begin
                   dcache_data_way_3_r[wdat_idx_3][`DCACHE_DATA_WIDTH - 1 : 8 * wdat_idx_3] <= #1 (i_dcache_rep ? i_dcache_rep_dat[`DCACHE_DATA_WIDTH - 1 : 8 * wdat_idx_3] : i_dcache_wdat[`DCACHE_DATA_WIDTH - 1 : 8 * wdat_idx_3]);
               end
           end
       end 
       else begin
           always @(posedge clk) begin
               if(dcache_wren_vec_3[wdat_idx_3]) begin
                   dcache_data_way_3_r[wdat_idx_3][8 * wdat_idx_3 + 7 : 8 * wdat_idx_3] <= #1 (i_dcache_rep ? i_dcache_rep_dat[8 * wdat_idx_3 + 7 : 8 * wdat_idx_3] : i_dcache_wdat[8 * wdat_idx_3 + 7 : 8 * wdat_idx_3]);
               end
           end
       end
    end
endgenerate

//
wire [`DCACHE_TAG_WIDTH - 1 : 0] dcache_wb_addr_33_14 = ({`DCACHE_TAG_WIDTH{(o_plru_replace_idx == 2'd3)}} & dcache_tag_way_3[dcache_idx])
                                                      | ({`DCACHE_TAG_WIDTH{(o_plru_replace_idx == 2'd2)}} & dcache_tag_way_2[dcache_idx])
                                                      | ({`DCACHE_TAG_WIDTH{(o_plru_replace_idx == 2'd1)}} & dcache_tag_way_1[dcache_idx])
                                                      | ({`DCACHE_TAG_WIDTH{(o_plru_replace_idx == 2'd0)}} & dcache_tag_way_0[dcache_idx]);
assign o_dcache_wb_addr = {dcache_wb_addr_33_14, dcache_idx, 6'h0};

//  Replace
wire i_plru_hit = ((i_dcache_rden | i_dcache_wren) & o_dcache_hit);
wire [1 : 0] i_plru_hit_idx = func_vec4(dcache_hit_vec);
wire i_plru_req = ((i_dcache_rden | i_dcache_wren) & (&dcache_vld_vec));
wire [1 : 0] o_plru_replace_idx;

plru4_module plru4 (
    .i_plru_hit        (i_plru_hit),
    .i_plru_hit_idx    (i_plru_hit_idx),
    .i_plru_req        (i_plru_req),
    .o_plru_replace_idx(o_plru_replace_idx),

    .clk               (clk),
    .rst_n             (rst_n)
);
//  Functions
function [1 : 0] func_vec4;
    input [3 : 0] bit_map;

    case (bit_map)
        4'b0001: func_vec4 = 2'd0;
        4'b0010: func_vec4 = 2'd1;
        4'b0100: func_vec4 = 2'd2;
        4'b1000: func_vec4 = 2'd3;
        default: func_vec4 = 2'd0;
    endcase
endfunction

function [1 : 0] func_find_free;
    input [3 : 0] bit_map;

    casex (bit_map)
        4'bxxx0: func_find_free = 2'd0;
        4'bxx01: func_find_free = 2'd1;
        4'bx011: func_find_free = 2'd2;
        4'b0111: func_find_free = 2'd3;
        default: func_find_free = 2'd0;
    endcase
endfunction

endmodule   //  dcache_module

`endif  /*  !__EXU_DCACHE_V__!  */