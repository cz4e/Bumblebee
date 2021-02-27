`ifdef __MMU_PTE_CACHE_V__

module pte_cache_module ( 
	input	[1                          : 0]		i_csr_rv_mode,
	input	[31                         : 0]		i_pte_cache_satp,
	input									        i_pte_cache_mmu_flush,
    input                                           i_pte_cache_rden,
	input	[`CORE_PC_WIDTH - 1         : 0]		i_pte_cache_vaddr,
	input									        i_pte_cache_wren,
	input	[1				            : 0]		i_pte_cache_level,
	input	[`PTE_WIDTH   - 1           : 0]		i_pte_cache_pte,
	input	[31				            : 0]		i_pte_cache_mmu_src1,
	input	[31				            : 0]		i_pte_cache_mmu_src2,

	output									        o_pte_cache_hit,
	output	[`PTE_CACHE_DATA_WIDTH - 1  : 0]	    o_pte_cache_rdata,

	input									        clk,
	input									        rst_n
);

wire [`PTE_CACHE_IDX_WIDTH - 1 : 0] pte_cache_ridx = i_pte_cache_vaddr[20 : 12];
wire [`PTE_CACHE_TAG_WIDTH - 1 : 0] pte_cache_rtag = {i_pte_cache_satp[30 : 22], i_csr_rv_mode[1 : 0], i_pte_cache_vaddr[31 : 20]};

//  Way 0
wire [511 : 0] pte_cache_vld_way_0;
wire [`PTE_CACHE_TAG_WIDTH - 1 : 0] pte_cache_tag_way_0;
wire [`PTE_CACHE_DATA_WIDTH - 1 : 0] pte_cache_data_way_0;

//  Way 1
wire [511 : 0] pte_cache_vld_way_1;
wire [`PTE_CACHE_TAG_WIDTH - 1 : 0] pte_cache_tag_way_1;
wire [`PTE_CACHE_DATA_WIDTH - 1 : 0] pte_cache_data_way_1;

//  Way 2
wire [511 : 0] pte_cache_vld_way_2;
wire [`PTE_CACHE_TAG_WIDTH - 1 : 0] pte_cache_tag_way_2;
wire [`PTE_CACHE_DATA_WIDTH - 1 : 0] pte_cache_data_way_2;

//  Way 3
wire [511 : 0] pte_cache_vld_way_3;
wire [`PTE_CACHE_TAG_WIDTH - 1 : 0] pte_cache_tag_way_3;
wire [`PTE_CACHE_DATA_WIDTH - 1 : 0] pte_cache_data_way_3;

//  Read Logic
wire [3 : 0] pte_cache_hit_vec = {
                                    (pte_cache_vld_way_3[pte_cache_ridx] & (pte_cache_tag_way_3[pte_cache_ridx] == pte_cache_rtag))
                                ,   (pte_cache_vld_way_2[pte_cache_ridx] & (pte_cache_tag_way_2[pte_cache_ridx] == pte_cache_rtag))
                                ,   (pte_cache_vld_way_1[pte_cache_ridx] & (pte_cache_tag_way_1[pte_cache_ridx] == pte_cache_rtag))
                                ,   (pte_cache_vld_way_0[pte_cache_ridx] & (pte_cache_tag_way_0[pte_cache_ridx] == pte_cache_rtag))
                                };

assign o_pte_cache_hit = (|pte_cache_hit_vec);

assign o_pte_cache_rdata = ({`PTE_CACHE_DATA_WIDTH{pte_cache_hit_vec[0]}} & pte_cache_data_way_0[pte_cache_ridx])
                         | ({`PTE_CACHE_DATA_WIDTH{pte_cache_hit_vec[1]}} & pte_cache_data_way_1[pte_cache_ridx])
                         | ({`PTE_CACHE_DATA_WIDTH{pte_cache_hit_vec[2]}} & pte_cache_data_way_2[pte_cache_ridx])
                         | ({`PTE_CACHE_DATA_WIDTH{pte_cache_hit_vec[3]}} & pte_cache_data_way_3[pte_cache_ridx]);
//  Flush Logic
wire fencevm_flush_0 = (i_pte_cache_mmu_flush & (i_pte_cache_mmu_src1 == 32'd0) & (i_pte_cache_mmu_src2[8 : 0] == 9'd0));
wire fencevm_flush_1 = (i_pte_cache_mmu_flush & (i_pte_cache_mmu_src1 != 32'd0) & (i_pte_cache_mmu_src2[8 : 0] == 9'd0));
wire fencevm_flush_2 = (i_pte_cache_mmu_flush & (i_pte_cache_mmu_src1 == 32'd0) & (i_pte_cache_mmu_src2[8 : 0] != 9'd0));
wire fencevm_flush_3 = (i_pte_cache_mmu_flush & (i_pte_cache_mmu_src1 != 32'd0) & (i_pte_cache_mmu_src2[8 : 0] != 9'd0));

//  Way 0
wire [511 : 0] pte_cache_vld_way_0_flush_0;
wire [511 : 0] pte_cache_vld_way_0_flush_1;
wire [511 : 0] pte_cache_vld_way_0_flush_2;
wire [511 : 0] pte_cache_vld_way_0_flush_3;

genvar idx_0;
generate
    assign pte_cache_vld_way_0_flush_0[idx_0] = (pte_cache_vld_way_0[idx_0] & (pte_cache_tag_way_0[idx_0][12 : 11] == i_csr_rv_mode[1 : 0]));
    assign pte_cache_vld_way_0_flush_1[idx_0] = (pte_cache_vld_way_0[idx_0] & (pte_cache_tag_way_0[idx_0][12 :  0] == {i_csr_rv_mode[1 : 0], i_pte_cache_mmu_src1[31 : 20]}));
    assign pte_cache_vld_way_0_flush_2[idx_0] = (pte_cache_vld_way_0[idx_0] & (pte_cache_tag_way_0[idx_0][22 : 11] == {i_pte_cache_mmu_src2[8 : 0], i_csr_rv_mode[1 : 0]}));
    assign pte_cache_vld_way_0_flush_3[idx_0] = (pte_cache_vld_way_0[idx_0] & (pte_cache_tag_way_0[idx_0] == {i_pte_cache_mmu_src2[8 : 0], i_csr_rv_mode[1 : 0], i_pte_cache_mmu_src1[31 : 20]}));
endgenerate

wire [511 : 0] pte_cache_vld_way_0_flush_vec = ({512{fencevm_flush_0}} & pte_cache_vld_way_0_flush_0)
                                             | ({512{fencevm_flush_1}} & pte_cache_vld_way_0_flush_1)
                                             | ({512{fencevm_flush_2}} & pte_cache_vld_way_0_flush_2)
                                             | ({512{fencevm_flush_3}} & pte_cache_vld_way_0_flush_3);

//  Way 1
wire [511 : 0] pte_cache_vld_way_1_flush_0;
wire [511 : 0] pte_cache_vld_way_1_flush_1;
wire [511 : 0] pte_cache_vld_way_1_flush_2;
wire [511 : 0] pte_cache_vld_way_1_flush_3;

genvar idx_1;
generate
    assign pte_cache_vld_way_1_flush_0[idx_1] = (pte_cache_vld_way_1[idx_1] & (pte_cache_tag_way_1[idx_1][12 : 11] == i_csr_rv_mode[1 : 0]));
    assign pte_cache_vld_way_1_flush_1[idx_1] = (pte_cache_vld_way_1[idx_1] & (pte_cache_tag_way_1[idx_1][12 :  0] == {i_csr_rv_mode[1 : 0], i_pte_cache_mmu_src1[31 : 20]}));
    assign pte_cache_vld_way_1_flush_2[idx_1] = (pte_cache_vld_way_1[idx_1] & (pte_cache_tag_way_1[idx_1][22 : 11] == {i_pte_cache_mmu_src2[8 : 0], i_csr_rv_mode[1 : 0]}));
    assign pte_cache_vld_way_1_flush_3[idx_1] = (pte_cache_vld_way_1[idx_1] & (pte_cache_tag_way_1[idx_1] == {i_pte_cache_mmu_src2[8 : 0], i_csr_rv_mode[1 : 0], i_pte_cache_mmu_src1[31 : 20]}));
endgenerate

wire [511 : 0] pte_cache_vld_way_1_flush_vec = ({512{fencevm_flush_0}} & pte_cache_vld_way_1_flush_0)
                                             | ({512{fencevm_flush_1}} & pte_cache_vld_way_1_flush_1)
                                             | ({512{fencevm_flush_2}} & pte_cache_vld_way_1_flush_2)
                                             | ({512{fencevm_flush_3}} & pte_cache_vld_way_1_flush_3);

//  Way 2
wire [511 : 0] pte_cache_vld_way_2_flush_0;
wire [511 : 0] pte_cache_vld_way_2_flush_1;
wire [511 : 0] pte_cache_vld_way_2_flush_2;
wire [511 : 0] pte_cache_vld_way_2_flush_3;

genvar idx_2;
generate
    assign pte_cache_vld_way_2_flush_0[idx_2] = (pte_cache_vld_way_2[idx_2] & (pte_cache_tag_way_2[idx_2][12 : 11] == i_csr_rv_mode[1 : 0]));
    assign pte_cache_vld_way_2_flush_1[idx_2] = (pte_cache_vld_way_2[idx_2] & (pte_cache_tag_way_2[idx_2][12 :  0] == {i_csr_rv_mode[1 : 0], i_pte_cache_mmu_src1[31 : 20]}));
    assign pte_cache_vld_way_2_flush_2[idx_2] = (pte_cache_vld_way_2[idx_2] & (pte_cache_tag_way_2[idx_2][22 : 11] == {i_pte_cache_mmu_src2[8 : 0], i_csr_rv_mode[1 : 0]}));
    assign pte_cache_vld_way_2_flush_3[idx_2] = (pte_cache_vld_way_2[idx_2] & (pte_cache_tag_way_2[idx_2] == {i_pte_cache_mmu_src2[8 : 0], i_csr_rv_mode[1 : 0], i_pte_cache_mmu_src1[31 : 20]}));
endgenerate

wire [511 : 0] pte_cache_vld_way_2_flush_vec = ({512{fencevm_flush_0}} & pte_cache_vld_way_2_flush_0)
                                             | ({512{fencevm_flush_1}} & pte_cache_vld_way_2_flush_1)
                                             | ({512{fencevm_flush_2}} & pte_cache_vld_way_2_flush_2)
                                             | ({512{fencevm_flush_3}} & pte_cache_vld_way_2_flush_3);

//  Way 3
wire [511 : 0] pte_cache_vld_way_3_flush_0;
wire [511 : 0] pte_cache_vld_way_3_flush_1;
wire [511 : 0] pte_cache_vld_way_3_flush_2;
wire [511 : 0] pte_cache_vld_way_3_flush_3;

genvar idx_3;
generate
    assign pte_cache_vld_way_3_flush_0[idx_3] = (pte_cache_vld_way_3[idx_3] & (pte_cache_tag_way_3[idx_3][12 : 11] == i_csr_rv_mode[1 : 0]));
    assign pte_cache_vld_way_3_flush_1[idx_3] = (pte_cache_vld_way_3[idx_3] & (pte_cache_tag_way_3[idx_3][12 :  0] == {i_csr_rv_mode[1 : 0], i_pte_cache_mmu_src1[31 : 20]}));
    assign pte_cache_vld_way_3_flush_2[idx_3] = (pte_cache_vld_way_3[idx_3] & (pte_cache_tag_way_3[idx_3][22 : 11] == {i_pte_cache_mmu_src2[8 : 0], i_csr_rv_mode[1 : 0]}));
    assign pte_cache_vld_way_3_flush_3[idx_3] = (pte_cache_vld_way_3[idx_3] & (pte_cache_tag_way_3[idx_3] == {i_pte_cache_mmu_src2[8 : 0], i_csr_rv_mode[1 : 0], i_pte_cache_mmu_src1[31 : 20]}));
endgenerate

wire [511 : 0] pte_cache_vld_way_3_flush_vec = ({512{fencevm_flush_0}} & pte_cache_vld_way_3_flush_0)
                                             | ({512{fencevm_flush_1}} & pte_cache_vld_way_3_flush_1)
                                             | ({512{fencevm_flush_2}} & pte_cache_vld_way_3_flush_2)
                                             | ({512{fencevm_flush_3}} & pte_cache_vld_way_3_flush_3);


//  Write Logic
wire [`PTE_CACHE_IDX_WIDTH - 1 : 0] pte_cache_widx = i_pte_cache_vaddr[20 : 12];
wire [`PTE_CACHE_TAG_WIDTH - 1 : 0] pte_cache_wtag = {i_pte_cache_satp[30 : 22], i_csr_rv_mode[1 : 0], i_pte_cache_vaddr[31 : 20]};
wire [`PTE_CACHE_DATA_WIDTH - 1 : 0] pte_cache_wdat = {
                                                        i_pte_cache_level 
                                                    ,   i_pte_cache_pte
                                                    };

wire [3 : 0] pte_cache_vld_vec = { 
                                    pte_cache_vld_way_3[pte_cache_widx]
                                ,   pte_cache_vld_way_2[pte_cache_widx]
                                ,   pte_cache_vld_way_1[pte_cache_widx]
                                ,   pte_cache_vld_way_0[pte_cache_widx]
                                };

wire pte_cache_sel_way_0 = (i_pte_cache_wren & (((&pte_cache_vld_vec) & (o_plru_replace_idx == 2'd0)) | (~pte_cache_vld_vec[0])));
wire pte_cache_sel_way_1 = (i_pte_cache_wren & (((&pte_cache_vld_vec) & (o_plru_replace_idx == 2'd1)) | (pte_cache_vld_vec[0] & (~pte_cache_vld_vec[1]))));
wire pte_cache_sel_way_2 = (i_pte_cache_wren & (((&pte_cache_vld_vec) & (o_plru_replace_idx == 2'd2)) | (pte_cache_vld_vec[0] & pte_cache_vld_vec[1] & (~pte_cache_vld_vec[2]))));
wire pte_cache_sel_way_3 = (i_pte_cache_wren & (((&pte_cache_vld_vec) & (o_plru_replace_idx == 2'd3)) | (pte_cache_vld_vec[0] & pte_cache_vld_vec[1] & pte_cache_vld_vec[2] & (~pte_cache_vld_vec[3]))));

//
wire [511 : 0] pte_cache_vld_way_set;

genvar idx;
generate
    for(idx = 0; idx < 512; idx = idx + 1) begin
        assign dcache_vld_way_set[idx] = (idx == pte_cache_widx);
    end
endgenerate


//  Way 0
wire pte_cache_vld_way_0_ena = (pte_cache_sel_way_0 | i_pte_cache_mmu_flush);
wire [511 : 0] pte_cache_vld_way_0_nxt = (pte_cache_vld_way_0 
                                       |  ({512{pte_cache_sel_way_0}} & pte_cache_vld_way_set))
                                       & (~(pte_cache_vld_way_0_flush_vec));

gnrl_dfflr #( 
    .DATA_WIDTH   (512),
    .INITIAL_VALUE(0)
) pte_cache_vld_way_0_dfflr (pte_cache_vld_way_0_ena, pte_cache_vld_way_0_nxt, pte_cache_vld_way_0, clk, rst_n);

wire [511 : 0] pte_cache_way_0_wren;

genvar way_0_idx;
generate
    for(way_0_idx = 0; way_0_idx < 512; way_0_idx = way_0_idx + 1) begin
        assign pte_cache_way_0_wren[way_0_idx] = (pte_cache_sel_way_0 & (way_0_idx == pte_cache_widx));
        gnrl_dffl #( 
            .DATA_WIDTH(`PTE_CACHE_TAG_WIDTH)
        ) pte_cache_tag_way_0_dffl (pte_cache_way_0_wren[way_0_idx], pte_cache_wtag, pte_cache_tag_way_0[way_0_idx], clk);

        gnrl_dffl #( 
            .DATA_WIDTH(`PTE_CACHE_DATA_WIDTH)
        ) pte_cache_data_way_0_dffl (pte_cache_way_0_wren[way_0_idx], pte_cache_wdat, pte_cache_data_way_0[way_0_idx], clk);
    end
endgenerate

//  Way 1
wire pte_cache_vld_way_1_ena = (pte_cache_sel_way_1 | i_pte_cache_mmu_flush);
wire [511 : 0] pte_cache_vld_way_1_nxt = (pte_cache_vld_way_1 
                                       |  ({512{pte_cache_sel_way_1}} & pte_cache_vld_way_set))
                                       & (~(pte_cache_vld_way_1_flush_vec));

gnrl_dfflr #( 
    .DATA_WIDTH   (512),
    .INITIAL_VALUE(0)
) pte_cache_vld_way_1_dfflr (pte_cache_vld_way_1_ena, pte_cache_vld_way_1_nxt, pte_cache_vld_way_1, clk, rst_n);

wire [511 : 0] pte_cache_way_1_wren;

genvar way_1_idx;
generate
    for(way_1_idx = 0; way_1_idx < 512; way_1_idx = way_1_idx + 1) begin
        assign pte_cache_way_1_wren[way_1_idx] = (pte_cache_sel_way_1 & (way_1_idx == pte_cache_widx));
        gnrl_dffl #( 
            .DATA_WIDTH(`PTE_CACHE_TAG_WIDTH)
        ) pte_cache_tag_way_1_dffl (pte_cache_way_1_wren[way_1_idx], pte_cache_wtag, pte_cache_tag_way_1[way_1_idx], clk);

        gnrl_dffl #( 
            .DATA_WIDTH(`PTE_CACHE_DATA_WIDTH)
        ) pte_cache_data_way_1_dffl (pte_cache_way_1_wren[way_1_idx], pte_cache_wdat, pte_cache_data_way_1[way_1_idx], clk);
    end
endgenerate

//  Way 2
wire pte_cache_vld_way_2_ena = (pte_cache_sel_way_2 | i_pte_cache_mmu_flush);
wire [511 : 0] pte_cache_vld_way_2_nxt = (pte_cache_vld_way_2 
                                       |  ({512{pte_cache_sel_way_2}} & pte_cache_vld_way_set))
                                       & (~(pte_cache_vld_way_2_flush_vec));

gnrl_dfflr #( 
    .DATA_WIDTH   (512),
    .INITIAL_VALUE(0)
) pte_cache_vld_way_2_dfflr (pte_cache_vld_way_2_ena, pte_cache_vld_way_2_nxt, pte_cache_vld_way_2, clk, rst_n);

wire [511 : 0] pte_cache_way_2_wren;

genvar way_2_idx;
generate
    for(way_2_idx = 0; way_2_idx < 512; way_2_idx = way_2_idx + 1) begin
        assign pte_cache_way_2_wren[way_2_idx] = (pte_cache_sel_way_2 & (way_2_idx == pte_cache_widx));
        gnrl_dffl #( 
            .DATA_WIDTH(`PTE_CACHE_TAG_WIDTH)
        ) pte_cache_tag_way_2_dffl (pte_cache_way_2_wren[way_2_idx], pte_cache_wtag, pte_cache_tag_way_2[way_2_idx], clk);

        gnrl_dffl #( 
            .DATA_WIDTH(`PTE_CACHE_DATA_WIDTH)
        ) pte_cache_data_way_2_dffl (pte_cache_way_2_wren[way_2_idx], pte_cache_wdat, pte_cache_data_way_2[way_2_idx], clk);
    end
endgenerate

//  Way 3
wire pte_cache_vld_way_3_ena = (pte_cache_sel_way_3 | i_pte_cache_mmu_flush);
wire [511 : 0] pte_cache_vld_way_3_nxt = (pte_cache_vld_way_3 
                                       |  ({512{pte_cache_sel_way_3}} & pte_cache_vld_way_set))
                                       & (~(pte_cache_vld_way_3_flush_vec));

gnrl_dfflr #( 
    .DATA_WIDTH   (512),
    .INITIAL_VALUE(0)
) pte_cache_vld_way_3_dfflr (pte_cache_vld_way_3_ena, pte_cache_vld_way_3_nxt, pte_cache_vld_way_3, clk, rst_n);

wire [511 : 0] pte_cache_way_3_wren;

genvar way_3_idx;
generate
    for(way_3_idx = 0; way_3_idx < 512; way_3_idx = way_3_idx + 1) begin
        assign pte_cache_way_3_wren[way_3_idx] = (pte_cache_sel_way_3 & (way_3_idx == pte_cache_widx));
        gnrl_dffl #( 
            .DATA_WIDTH(`PTE_CACHE_TAG_WIDTH)
        ) pte_cache_tag_way_3_dffl (pte_cache_way_3_wren[way_3_idx], pte_cache_wtag, pte_cache_tag_way_3[way_3_idx], clk);

        gnrl_dffl #( 
            .DATA_WIDTH(`PTE_CACHE_DATA_WIDTH)
        ) pte_cache_data_way_3_dffl (pte_cache_way_3_wren[way_3_idx], pte_cache_wdat, pte_cache_data_way_3[way_3_idx], clk);
    end
endgenerate

//
wire i_plru_hit = (i_pte_cache_rden & o_pte_cache_hit);
wire [1 : 0] i_plru_hit_idx = func_vec4(pte_cache_hit_vec);

wire i_plru_req = (i_pte_cache_wren & (&pte_cache_vld_vec));
wire [1 : 0] o_plru_replace_idx;

plru4_module plru ( 
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

endmodule   //  pte_cache_module

`endif  /*  !__MMU_PTR_CACHE_V__!   */