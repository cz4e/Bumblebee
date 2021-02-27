`ifdef __EXU_DCACHE_V__

module dcache_module (
    input                                           i_dcache_req,
    input   [`DCACHE_TAG_WIDTH - 1  : 0]            i_dcache_rtag,
    input   [`DCACHE_IDX_WIDTH - 1  : 0]            i_dcache_ridx,
    input                                           i_dcache_wren,
    input   [`DCACHE_IDX_WIDTH - 1  : 0]            i_dcache_widx,
    input   [`DCACHE_TAG_WIDTH - 1  : 0]            i_dcache_wtag,
    input   [`DCACHE_DATA_WIDTH - 1 : 0]            i_dcache_wdat,

    output                                          o_dcache_hit,
    output  [`DCACHE_DATA_WIDTH - 1 : 0]            o_dcache_rdat,

    input                                           clk,
    input                                           rst_n
);

//
wire [3 : 0] dcache_wr_vld = {
                                dcache_vld_way_3[i_dcache_widx]
                            ,   dcache_vld_way_2[i_dcache_widx]
                            ,   dcache_vld_way_1[i_dcache_widx]
                            ,   dcache_vld_way_0[i_dcache_widx]
                            };

wire dcache_need_replace = (~(&dcache_wr_vld));

wire [1 : 0] dcache_wr_way = ({2{dcache_need_replace   }} & o_plru_replace_idx         )
                           | ({2{(~dcache_need_replace)}} & func_find_free(dtlb_wr_vld));

wire [255 : 0] dcache_vld_way_set;
genvar idx;
generate
    for(idx = 0; idx < 256; idx = idx + 1) begin
        assign dcache_vld_way_set[idx] = (idx == i_dcache_widx);
    end
endgenerate

//  Way 0
wire [255 : 0] dcache_vld_way_0;
wire [`DCACHE_TAG_WIDTH - 1 : 0] dcache_tag_way_0 [255 : 0];
wire [`DCACHE_DATA_WIDTH - 1 : 0] dcache_data_way_0 [255 : 0];


wire [255 : 0] dcache_vld_way_0_nxt = (dcache_vld_way_0 | ({256{dcache_vld_way_0_ena}} & dcache_vld_way_set));

wire dcache_vld_way_0_ena = (i_dcache_wren & (dcache_wr_way == 2'd0));

gnrl_dfflr #( 
    .DATA_WIDTH   (256),
    .INITIAL_VALUE(0)
) dcache_vld_way_0_dfflr (dcache_vld_way_0_ena, dcache_vld_way_0_nxt, dcache_vld_way_0, clk, rst_n);

wire [255 : 0] dcache_way_0_wren;

genvar way_0_idx;
generate
    for(way_0_idx = 0; way_0_idx < 256; way_0_idx = way_0_idx + 1) begin
        assign dcache_way_0_wren[way_0_idx] = (dcache_vld_way_0_ena & (way_0_idx == i_dcache_widx));
        gnrl_dffl #( 
            .DATA_WIDTH(`DCACHE_TAG_WIDTH)
        ) dcache_tag_way_0_dffl (dcache_way_0_wren[way_0_idx], i_dcache_wtag, dcache_tag_way_0[way_0_idx], clk);
    
        gnrl_dffl #( 
            .DATA_WIDTH(`DCACHE_DATA_WIDTH)
        ) dcache_data_way_0_dffl (dcache_way_0_wren[way_0_idx], i_dcache_wdat, dcache_data_way_0[way_0_idx], clk);
    end
endgenerate

//  Way 1
wire [255 : 0] dcache_vld_way_1;
wire [`DCACHE_TAG_WIDTH - 1 : 0] dcache_tag_way_1 [255 : 0];
wire [`DCACHE_DATA_WIDTH - 1 : 0] dcache_data_way_1 [255 : 0];

wire [255 : 0] dcache_vld_way_1_nxt = (dcache_vld_way_1 | ({256{dcache_vld_way_1_ena}} & dcache_vld_way_set));

wire dcache_vld_way_1_ena = (i_dcache_wren & (dcache_wr_way == 2'd1));

gnrl_dfflr #( 
    .DATA_WIDTH   (256),
    .INITIAL_VALUE(0)
) dcache_vld_way_1_dfflr (dcache_vld_way_1_ena, dcache_vld_way_1_nxt, dcache_vld_way_1, clk, rst_n);

wire [255 : 0] dcache_way_1_wren;

genvar way_1_idx;
generate
    for(way_1_idx = 0; way_1_idx < 256; way_1_idx = way_1_idx + 1) begin
        assign dcache_way_1_wren[way_1_idx] = (dcache_vld_way_1_ena & (way_1_idx == i_dcache_widx));
        gnrl_dffl #( 
            .DATA_WIDTH(`DCACHE_TAG_WIDTH)
        ) dcache_tag_way_1_dffl (dcache_way_1_wren[way_1_idx], i_dcache_wtag, dcache_tag_way_1[way_1_idx], clk);
    
        gnrl_dffl #( 
            .DATA_WIDTH(`DCACHE_DATA_WIDTH)
        ) dcache_data_way_1_dffl (dcache_way_1_wren[way_1_idx], i_dcache_wdat, dcache_data_way_1[way_1_idx], clk);
    end
endgenerate

//  Way 2
wire [255 : 0] dcache_vld_way_2;
wire [`DCACHE_TAG_WIDTH - 1 : 0] dcache_tag_way_2 [255 : 0];
wire [`DCACHE_DATA_WIDTH - 1 : 0] dcache_data_way_2 [255 : 0];

wire [255 : 0] dcache_vld_way_2_nxt = (dcache_vld_way_2 | ({256{dcache_vld_way_2_ena}} & dcache_vld_way_set));

wire dcache_vld_way_2_ena = (i_dcache_wren & (dcache_wr_way == 2'd2));

gnrl_dfflr #( 
    .DATA_WIDTH   (256),
    .INITIAL_VALUE(0)
) dcache_vld_way_2_dfflr (dcache_vld_way_2_ena, dcache_vld_way_2_nxt, dcache_vld_way_2, clk, rst_n);

wire [255 : 0] dcache_way_2_wren;

genvar way_2_idx;
generate
    for(way_2_idx = 0; way_2_idx < 256; way_2_idx = way_2_idx + 1) begin
        assign dcache_way_2_wren[way_2_idx] = (dcache_vld_way_2_ena & (way_2_idx == i_dcache_widx));
        gnrl_dffl #( 
            .DATA_WIDTH(`DCACHE_TAG_WIDTH)
        ) dcache_tag_way_2_dffl (dcache_way_2_wren[way_2_idx], i_dcache_wtag, dcache_tag_way_2[way_2_idx], clk);
    
        gnrl_dffl #( 
            .DATA_WIDTH(`DCACHE_DATA_WIDTH)
        ) dcache_data_way_2_dffl (dcache_way_2_wren[way_2_idx], i_dcache_wdat, dcache_data_way_2[way_2_idx], clk);
    end
endgenerate

//  Way 3
wire [255 : 0] dcache_vld_way_3;
wire [`DCACHE_TAG_WIDTH - 1 : 0] dcache_tag_way_3 [255 : 0];
wire [`DCACHE_DATA_WIDTH - 1 : 0] dcache_data_way_3 [255 : 0];

wire [255 : 0] dcache_vld_way_3_nxt = (dcache_vld_way_3 | ({256{dcache_vld_way_3_ena}} & dcache_vld_way_set));

wire dcache_vld_way_3_ena = (i_dcache_wren & (dcache_wr_way == 2'd3));

gnrl_dfflr #( 
    .DATA_WIDTH   (256),
    .INITIAL_VALUE(0)
) dcache_vld_way_3_dfflr (dcache_vld_way_3_ena, dcache_vld_way_3_nxt, dcache_vld_way_3, clk, rst_n);

wire [255 : 0] dcache_way_3_wren;

genvar way_3_idx;
generate
    for(way_3_idx = 0; way_3_idx < 256; way_3_idx = way_3_idx + 1) begin
        assign dcache_way_3_wren[way_3_idx] = (dcache_vld_way_3_ena & (way_3_idx == i_dcache_widx));
        gnrl_dffl #( 
            .DATA_WIDTH(`DCACHE_TAG_WIDTH)
        ) dcache_tag_way_3_dffl (dcache_way_3_wren[way_3_idx], i_dcache_wtag, dcache_tag_way_3[way_3_idx], clk);
    
        gnrl_dffl #( 
            .DATA_WIDTH(`DCACHE_DATA_WIDTH)
        ) dcache_data_way_3_dffl (dcache_way_3_wren[way_3_idx], i_dcache_wdat, dcache_data_way_3[way_3_idx], clk);
    end
endgenerate

//
wire [3 : 0] dcache_hit = {
                            (dcache_vld_way_3[i_dcache_ridx] & (dcache_tag_way_3[i_dcache_ridx] == i_dcache_rtag))
                        ,   (dcache_vld_way_2[i_dcache_ridx] & (dcache_tag_way_2[i_dcache_ridx] == i_dcache_rtag))
                        ,   (dcache_vld_way_1[i_dcache_ridx] & (dcache_tag_way_1[i_dcache_ridx] == i_dcache_rtag))
                        ,   (dcache_vld_way_0[i_dcache_ridx] & (dcache_tag_way_0[i_dcache_ridx] == i_dcache_rtag))
                        };

assign o_dcache_hit = (|dcache_hit);
assign o_dcache_rdat= ({`DCACHE_DATA_WIDTH{dcache_hit[0]}} & dcache_data_way_0[i_dcache_ridx])
                    | ({`DCACHE_DATA_WIDTH{dcache_hit[1]}} & dcache_data_way_1[i_dcache_ridx])
                    | ({`DCACHE_DATA_WIDTH{dcache_hit[2]}} & dcache_data_way_2[i_dcache_ridx])
                    | ({`DCACHE_DATA_WIDTH{dcache_hit[3]}} & dcache_data_way_3[i_dcache_ridx]);

//  Replace
wire i_plru_hit = (i_dcache_req & o_dcache_hit);
wire [1 : 0] i_plru_hit_idx = func_vec4(dcache_hit);
wire i_plru_req = (i_dcache_wren & dcache_need_replace);
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

function [255 : 0] func_vec256;
    input [7 : 0] index;

    case (index)

    endcase
endfunction
endmodule   //  dcache_module

`endif  /*  !__EXU_DCACHE_V__!  */