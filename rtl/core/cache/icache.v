`ifdef __CACHE_ICACHE_V__

module icache_module (
    input                                           i_icache_inv_vld,
    input   [`PHY_ADDR_WIDTH - 1    : 0]            i_icache_inv_paddr,

    input                                           i_icache_req,
    input   [`ICACHE_TAG_WIDTH - 1  : 0]            i_icache_rtag,
    input   [`ICACHE_IDX_WIDTH - 1  : 0]            i_icache_ridx,
    input                                           i_icache_wren,
    input   [`ICACHE_IDX_WIDTH - 1  : 0]            i_icache_widx,
    input   [`ICACHE_TAG_WIDTH - 1  : 0]            i_icache_wtag,
    input   [`ICACHE_DATA_WIDTH - 1 : 0]            i_icache_wdat,

    output                                          o_icache_hit,
    output  [`ICACHE_DATA_WIDTH - 1 : 0]            o_icache_rdat,

    input                                           clk,
    input                                           rst_n
);

//
wire [3 : 0] icache_wr_vld = {
                                icache_vld_way_3[i_icache_widx]
                            ,   icache_vld_way_2[i_icache_widx]
                            ,   icache_vld_way_1[i_icache_widx]
                            ,   icache_vld_way_0[i_icache_widx]
                            };

wire icache_need_replace = (~(&icache_wr_vld));

wire [1 : 0] icache_wr_way = ({2{icache_need_replace   }} & o_plru_replace_idx         )
                           | ({2{(~icache_need_replace)}} & func_find_free(dtlb_wr_vld));

wire [255 : 0] icache_vld_way_set;
genvar idx;
generate
    for(idx = 0; idx < 256; idx = idx + 1) begin
        assign icache_vld_way_set[idx] = (idx == i_icache_widx);
    end
endgenerate

//  ICACHE flush
wire [`ICACHE_TAG_WIDTH - 1 : 0] icache_flush_tag = i_icache_inv_paddr[33 : 14];

wire [255 : 0] icache_flush_vec_0;
wire [255 : 0] icache_flush_vec_1;
wire [255 : 0] icache_flush_vec_2;
wire [255 : 0] icache_flush_vec_3;

genvar i;
generate
    for(i = 0; i < 256; i = i + 1) begin
        assign icache_flush_vec_0[i] = (icache_vld_way_0[i] & (icache_flush_tag == icache_tag_way_0[i]));
        assign icache_flush_vec_1[i] = (icache_vld_way_1[i] & (icache_flush_tag == icache_tag_way_1[i]));
        assign icache_flush_vec_2[i] = (icache_vld_way_2[i] & (icache_flush_tag == icache_tag_way_2[i]));
        assign icache_flush_vec_3[i] = (icache_vld_way_3[i] & (icache_flush_tag == icache_tag_way_3[i]));
    end
endgenerate

//  Way 0
wire [255 : 0] icache_vld_way_0;
wire [`ICACHE_TAG_WIDTH - 1 : 0] icache_tag_way_0 [255 : 0];
wire [`ICACHE_DATA_WIDTH - 1 : 0] icache_data_way_0 [255 : 0];


wire [255 : 0] icache_vld_way_0_nxt = (icache_vld_way_0 | ({256{(i_icache_wren & (icache_wr_way == 2'd0))}} & icache_vld_way_set))
                                    & (~icache_flush_vec_0);

wire icache_vld_way_0_ena = ((i_icache_wren & (icache_wr_way == 2'd0)) | i_icache_inv_vld);

gnrl_dfflr #( 
    .DATA_WIDTH   (256),
    .INITIAL_VALUE(0)
) icache_vld_way_0_dfflr (icache_vld_way_0_ena, icache_vld_way_0_nxt, icache_vld_way_0, clk, rst_n);

genvar way_0_idx;
generate
    for(way_0_idx = 0; way_0_idx < 256; way_0_idx = way_0_idx + 1) begin
        gnrl_dffl #( 
            .DATA_WIDTH(`ICACHE_TAG_WIDTH)
        ) icache_tag_way_0_dffl (icache_vld_way_0_ena, i_icache_wtag, icache_tag_way_0[way_0_idx], clk);
    
        gnrl_dffl #( 
            .DATA_WIDTH(`ICACHE_DATA_WIDTH)
        ) icache_data_way_0_dffl (icache_vld_way_0_ena, i_icache_wdat, icache_data_way_0[way_0_idx], clk);
    end
endgenerate

//  Way 1
wire [255 : 0] icache_vld_way_1;
wire [`ICACHE_TAG_WIDTH - 1 : 0] icache_tag_way_1 [255 : 0];
wire [`ICACHE_DATA_WIDTH - 1 : 0] icache_data_way_1 [255 : 0];

wire [255 : 0] icache_vld_way_1_nxt = (icache_vld_way_1 | ({256{(i_icache_wren & (icache_wr_way == 2'd1))}} & icache_vld_way_set))
                                    & (~icache_flush_vec_1);

wire icache_vld_way_1_ena = ((i_icache_wren & (icache_wr_way == 2'd1)) | i_icache_inv_vld);

gnrl_dfflr #( 
    .DATA_WIDTH   (256),
    .INITIAL_VALUE(0)
) icache_vld_way_1_dfflr (icache_vld_way_1_ena, icache_vld_way_1_nxt, icache_vld_way_1, clk, rst_n);

genvar way_1_idx;
generate
    for(way_1_idx = 0; way_1_idx < 256; way_1_idx = way_1_idx + 1) begin
        gnrl_dffl #( 
            .DATA_WIDTH(`ICACHE_TAG_WIDTH)
        ) icache_tag_way_1_dffl (icache_vld_way_1_ena, i_icache_wtag, icache_tag_way_1[way_1_idx], clk);
    
        gnrl_dffl #( 
            .DATA_WIDTH(`ICACHE_DATA_WIDTH)
        ) icache_data_way_1_dffl (icache_vld_way_1_ena, i_icache_wdat, icache_data_way_1[way_1_idx], clk);
    end
endgenerate

//  Way 2
wire [255 : 0] icache_vld_way_2;
wire [`ICACHE_TAG_WIDTH - 1 : 0] icache_tag_way_2 [255 : 0];
wire [`ICACHE_DATA_WIDTH - 1 : 0] icache_data_way_2 [255 : 0];

wire [255 : 0] icache_vld_way_2_nxt = (icache_vld_way_2 | ({256{(i_icache_wren & (icache_wr_way == 2'd2))}} & icache_vld_way_set))
                                    & (~icache_flush_vec_2);

wire icache_vld_way_2_ena = ((i_icache_wren & (icache_wr_way == 2'd2)) | i_icache_inv_vld);

gnrl_dfflr #( 
    .DATA_WIDTH   (256),
    .INITIAL_VALUE(0)
) icache_vld_way_2_dfflr (icache_vld_way_2_ena, icache_vld_way_2_nxt, icache_vld_way_2, clk, rst_n);

genvar way_2_idx;
generate
    for(way_2_idx = 0; way_2_idx < 256; way_2_idx = way_2_idx + 1) begin
        gnrl_dffl #( 
            .DATA_WIDTH(`ICACHE_TAG_WIDTH)
        ) icache_tag_way_2_dffl (icache_vld_way_2_ena, i_icache_wtag, icache_tag_way_2[way_2_idx], clk);
    
        gnrl_dffl #( 
            .DATA_WIDTH(`ICACHE_DATA_WIDTH)
        ) icache_data_way_2_dffl (icache_vld_way_2_ena, i_icache_wdat, icache_data_way_2[way_2_idx], clk);
    end
endgenerate

//  Way 3
wire [255 : 0] icache_vld_way_3;
wire [`ICACHE_TAG_WIDTH - 1 : 0] icache_tag_way_3 [255 : 0];
wire [`ICACHE_DATA_WIDTH - 1 : 0] icache_data_way_3 [255 : 0];

wire [255 : 0] icache_vld_way_3_nxt = (icache_vld_way_3 | ({256{(i_icache_wren & (icache_wr_way == 2'd3))}} & icache_vld_way_set))
                                    & (~icache_flush_vec_3);

wire icache_vld_way_3_ena = ((i_icache_wren & (icache_wr_way == 2'd3)) | i_icache_inv_vld);

gnrl_dfflr #( 
    .DATA_WIDTH   (256),
    .INITIAL_VALUE(0)
) icache_vld_way_3_dfflr (icache_vld_way_3_ena, icache_vld_way_3_nxt, icache_vld_way_3, clk, rst_n);

genvar way_3_idx;
generate
    for(way_3_idx = 0; way_3_idx < 256; way_3_idx = way_3_idx + 1) begin
        gnrl_dffl #( 
            .DATA_WIDTH(`ICACHE_TAG_WIDTH)
        ) icache_tag_way_3_dffl (icache_vld_way_3_ena, i_icache_wtag, icache_tag_way_3[way_3_idx], clk);
    
        gnrl_dffl #( 
            .DATA_WIDTH(`ICACHE_DATA_WIDTH)
        ) icache_data_way_3_dffl (icache_vld_way_3_ena, i_icache_wdat, icache_data_way_3[way_3_idx], clk);
    end
endgenerate

//
wire [3 : 0] icache_hit = {
                            (i_icache_req & icache_vld_way_3[i_icache_ridx] & (icache_tag_way_3[i_icache_ridx] == i_icache_rtag))
                        ,   (i_icache_req & icache_vld_way_2[i_icache_ridx] & (icache_tag_way_2[i_icache_ridx] == i_icache_rtag))
                        ,   (i_icache_req & icache_vld_way_1[i_icache_ridx] & (icache_tag_way_1[i_icache_ridx] == i_icache_rtag))
                        ,   (i_icache_req & icache_vld_way_0[i_icache_ridx] & (icache_tag_way_0[i_icache_ridx] == i_icache_rtag))
                        };

assign o_icache_hit = (|icache_hit);
assign o_icache_rdat= ({`ICACHE_DATA_WIDTH{icache_hit[0]}} & icache_data_way_0[i_icache_ridx])
                    | ({`ICACHE_DATA_WIDTH{icache_hit[1]}} & icache_data_way_1[i_icache_ridx])
                    | ({`ICACHE_DATA_WIDTH{icache_hit[2]}} & icache_data_way_2[i_icache_ridx])
                    | ({`ICACHE_DATA_WIDTH{icache_hit[3]}} & icache_data_way_3[i_icache_ridx]);

//  Replace
wire [1 : 0] i_plru_hit_idx = func_vec4r(icache_hit);
wire i_plru_req = (i_icache_wren & icache_need_replace);
wire [1 : 0] o_plru_replace_idx;

plru4_module plru4 (
    .i_plru_hit        (o_icache_hit),
    .i_plru_hit_idx    (i_plru_hit_idx),
    .i_plru_req        (i_plru_req),
    .o_plru_replace_idx(o_plru_replace_idx),

    .clk               (clk),
    .rst_n             (rst_n)
);

//  Functions
function [1 : 0] func_vec4r;
    input [3 : 0] bit_map;

    case (bit_map)
        4'b0001: func_vec4r = 2'd0;
        4'b0010: func_vec4r = 2'd1;
        4'b0100: func_vec4r = 2'd2;
        4'b1000: func_vec4r = 2'd3;
        default: func_vec4r = 2'd0;
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

endmodule   //  icache_module

`endif  /*  !__CACHE_ICACHE_V__!  */