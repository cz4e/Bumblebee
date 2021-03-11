`ifdef __MMU_L2TLB_V__

module l2tlb_module ( 
	input	[1							: 0]	i_csr_rv_mode,
	input	[31							: 0]	i_l2tlb_satp,
	input 										i_l2tlb_rden,
	input	[`VADDR_WIDTH - 1 			: 0]	i_l2tlb_vaddr,
	input										i_l2tlb_wren,
	input	[`PTE_WIDTH - 1 			: 0]	i_l2tlb_pte,
	input	[21				 			: 0]	i_l2tlb_paddr,

	output										o_l2tlb_hit,
	output	[`L2TLB_TLB_WIDTH - 1 		: 0]	o_l2tlb_tlb,
	output 	[`PHY_ADDR_WIDTH - 1		: 0]	o_l2tlb_paddr,
	
	input										clk,
	input										rst_n
);

wire [`L2TLB_IDX_WIDTH - 1 : 0] l2tlb_ridx = i_l2tlb_vaddr[19 : 12];
wire [`L2TLB_TAG_WIDTH - 1 : 0] l2tlb_rtag = {i_l2tlb_satp[30 : 22], i_csr_rv_mode[1 : 0], i_l2tlb_vaddr[31 : 20]};


//  Way 0
wire [255 : 0] l2tlb_vld_way_0;
wire [`L2TLB_TAG_WIDTH - 1 : 0] l2tlb_tag_way_0 [255 : 0];
wire [`L2TLB_DATA_WIDTH - 1 : 0] l2tlb_data_way_0 [255 : 0];

//	Way 1
wire [255 : 0] l2tlb_vld_way_1;
wire [`L2TLB_TAG_WIDTH - 1 : 0] l2tlb_tag_way_1 [255 : 0];
wire [`L2TLB_DATA_WIDTH - 1 : 0] l2tlb_data_way_1 [255 : 0];

//	Way 2
wire [255 : 0] l2tlb_vld_way_2;
wire [`L2TLB_TAG_WIDTH - 1 : 0] l2tlb_tag_way_2 [255 : 0];
wire [`L2TLB_DATA_WIDTH - 1 : 0] l2tlb_data_way_2 [255 : 0];

//	Way 3
wire [255 : 0] l2tlb_vld_way_3;
wire [`L2TLB_TAG_WIDTH - 1 : 0] l2tlb_tag_way_3 [255 : 0];
wire [`L2TLB_DATA_WIDTH - 1 : 0] l2tlb_data_way_3 [255 : 0];

//	Read Logic
wire [`L2TLB_TAG_WIDTH - 1 : 0] l2tlb_way_0_tag = {l2tlb_data_way_0[l2tlb_ridx][`PTE_G], l2tlb_tag_way_0[l2tlb_ridx]};
wire [`L2TLB_TAG_WIDTH - 1 : 0] l2tlb_way_1_tag = {l2tlb_data_way_1[l2tlb_ridx][`PTE_G], l2tlb_tag_way_1[l2tlb_ridx]};
wire [`L2TLB_TAG_WIDTH - 1 : 0] l2tlb_way_2_tag = {l2tlb_data_way_2[l2tlb_ridx][`PTE_G], l2tlb_tag_way_2[l2tlb_ridx]};
wire [`L2TLB_TAG_WIDTH - 1 : 0] l2tlb_way_3_tag = {l2tlb_data_way_3[l2tlb_ridx][`PTE_G], l2tlb_tag_way_3[l2tlb_ridx]};

wire [3 : 0] l2tlb_hit_vec = {
								(((l2tlb_rtag == l2tlb_way_3_tag[22 : 0]) | ((l2tlb_tag[13 : 0] == l2tlb_way_3_tag[13 : 0]) & l2tlb_way_3_tag[23])) & l2tlb_vld_way_3[l2tlb_ridx])
							,	(((l2tlb_rtag == l2tlb_way_2_tag[22 : 0]) | ((l2tlb_tag[13 : 0] == l2tlb_way_2_tag[13 : 0]) & l2tlb_way_2_tag[23])) & l2tlb_vld_way_2[l2tlb_ridx])
							,	(((l2tlb_rtag == l2tlb_way_1_tag[22 : 0]) | ((l2tlb_tag[13 : 0] == l2tlb_way_1_tag[13 : 0]) & l2tlb_way_1_tag[23])) & l2tlb_vld_way_1[l2tlb_ridx])
							, 	(((l2tlb_rtag == l2tlb_way_0_tag[22 : 0]) | ((l2tlb_tag[13 : 0] == l2tlb_way_0_tag[13 : 0]) & l2tlb_way_0_tag[23])) & l2tlb_vld_way_0[l2tlb_ridx])
							};

assign o_l2tlb_hit = (|l2tlb_hit_vec);
assign o_l2tlb_tlb = ({`L2TLB_TLB_WIDTH{l2tlb_hit_vec[0]}} & {l2tlb_tag_way_0[l2tlb_ridx], l2tlb_data_way_0[l2tlb_ridx]})
				   | ({`L2TLB_TLB_WIDTH{l2tlb_hit_vec[1]}} & {l2tlb_tag_way_1[l2tlb_ridx], l2tlb_data_way_1[l2tlb_ridx]})
				   | ({`L2TLB_TLB_WIDTH{l2tlb_hit_vec[2]}} & {l2tlb_tag_way_2[l2tlb_ridx], l2tlb_data_way_2[l2tlb_ridx]})
				   | ({`L2TLB_TLB_WIDTH{l2tlb_hit_vec[3]}} & {l2tlb_tag_way_3[l2tlb_ridx], l2tlb_data_way_3[l2tlb_ridx]});

//	Write Logic
wire [`L2TLB_IDX_WIDTH - 1 : 0] l2tlb_widx = i_l2tlb_vaddr[19 : 12];
wire [`L2TLB_TAG_WIDTH - 1 : 0] l2tlb_wtag = {i_l2tlb_satp[30 : 22], i_csr_rv_mode[1 : 0], i_l2tlb_vaddr[31 : 20]};
wire [`L2TLB_DATA_WIDTH - 1 : 0] l2tlb_wdat = {
													i_l2tlb_pte[7 : 1]
												,	i_l2tlb_paddr[33 : 12]
											};

wire [3 : 0] l2tlb_vld_vec = {
								l2tlb_vld_way_3[l2tlb_widx]
							,	l2tlb_vld_way_2[l2tlb_widx]
							,	l2tlb_vld_way_1[l2tlb_widx]
							,	l2tlb_vld_way_0[l2tlb_widx]
							};

wire l2tlb_sel_way_0 = (i_l2tlb_wren & (((&l2tlb_vld_vec) & (o_plru_replace_idx == 2'd0)) | (~l2tlb_vld_vec[0])));
wire l2tlb_sel_way_1 = (i_l2tlb_wren & (((&l2tlb_vld_vec) & (o_plru_replace_idx == 2'd1)) | (l2tlb_vld_vec[0] & (~l2tlb_vld_vec[1]))));
wire l2tlb_sel_way_2 = (i_l2tlb_wren & (((&l2tlb_vld_vec) & (o_plru_replace_idx == 2'd2)) | (l2tlb_vld_vec[0] & l2tlb_vld_vec[1] & (~l2tlb_vld_vec[2]))));
wire l2tlb_sel_way_3 = (i_l2tlb_wren & (((&l2tlb_vld_vec) & (o_plru_replace_idx == 2'd3)) | (l2tlb_vld_vec[0] & l2tlb_vld_vec[1] & l2tlb_vld_vec[2] & (~l2tlb_vld_vec[3]))));

//
wire [255 : 0] l2tlb_vld_way_set;

genvar idx;
generate
	for(idx = 0; idx < 256; idx = idx + 1) begin
		assign l2tlb_vld_way_set[idx] = (idx == l2tlb_widx);
	end
endgenerate

//	Way 0
wire l2tlb_vld_way_0_ena = l2tlb_sel_way_0;

wire [255 : 0] l2tlb_vld_way_0_nxt = (l2tlb_vld_way_0 | ({256{l2tlb_vld_way_0_ena}} & l2tlb_vld_way_set));

gnrl_dfflr #( 
	.DATA_WIDTH   (256),
	.INITIAL_VALUE(0)
) l2tlb_vld_way_0_dfflr (l2tlb_vld_way_0_ena, l2tlb_vld_way_0_nxt, l2tlb_vld_way_0, clk, rst_n);

wire [255 : 0] l2tlb_way_0_wren;

genvar way_0_idx;
generate
	for(way_0_idx = 0; way_0_idx < 256; way_0_idx = way_0_idx + 1) begin
		assign l2tlb_way_0_wren[way_0_idx] = (l2tlb_sel_way_0 & (way_0_idx == l2tlb_widx));
		gnrl_dffl #( 
			.DATA_WIDTH(`L2TLB_TAG_WIDTH)
		) l2tlb_tag_way_0_dffl (l2tlb_way_0_wren[way_0_idx], l2tlb_wtag, l2tlb_tag_way_0[way_0_idx], clk);

		gnrl_dffl #( 
			.DATA_WIDTH(`L2TLB_DATA_WIDTH)
		) l2tlb_data_way_0_dffl (l2tlb_way_0_wren[way_0_idx], l2tlb_wdat, l2tlb_data_way_0[way_0_idx], clk);
	end
endgenerate

//	Way 1
wire l2tlb_vld_way_1_ena = l2tlb_sel_way_1;

wire [255 : 0] l2tlb_vld_way_1_nxt = (l2tlb_vld_way_1 | ({256{l2tlb_vld_way_1_ena}} & l2tlb_vld_way_set));

gnrl_dfflr #( 
	.DATA_WIDTH   (256),
	.INITIAL_VALUE(0)
) l2tlb_vld_way_1_dfflr (l2tlb_vld_way_1_ena, l2tlb_vld_way_1_nxt, l2tlb_vld_way_1, clk, rst_n);

wire [255 : 0] l2tlb_way_1_wren;

genvar way_1_idx;
generate
	for(way_1_idx = 0; way_1_idx < 256; way_1_idx = way_1_idx + 1) begin
		assign l2tlb_way_1_wren[way_1_idx] = (l2tlb_sel_way_1 & (way_1_idx == l2tlb_widx));
		gnrl_dffl #( 
			.DATA_WIDTH(`L2TLB_TAG_WIDTH)
		) l2tlb_tag_way_1_dffl (l2tlb_way_1_wren[way_1_idx], l2tlb_wtag, l2tlb_tag_way_1[way_1_idx], clk);

		gnrl_dffl #( 
			.DATA_WIDTH(`L2TLB_DATA_WIDTH)
		) l2tlb_data_way_1_dffl (l2tlb_way_1_wren[way_1_idx], l2tlb_wdat, l2tlb_data_way_1[way_1_idx], clk);
	end
endgenerate

//	Way 2
wire l2tlb_vld_way_2_ena = l2tlb_sel_way_2;

wire [255 : 0] l2tlb_vld_way_2_nxt = (l2tlb_vld_way_2 | ({256{l2tlb_vld_way_2_ena}} & l2tlb_vld_way_set));

gnrl_dfflr #( 
	.DATA_WIDTH   (256),
	.INITIAL_VALUE(0)
) l2tlb_vld_way_2_dfflr (l2tlb_vld_way_2_ena, l2tlb_vld_way_2_nxt, l2tlb_vld_way_2, clk, rst_n);

wire [255 : 0] l2tlb_way_2_wren;

genvar way_2_idx;
generate
	for(way_2_idx = 0; way_2_idx < 256; way_2_idx = way_2_idx + 1) begin
		assign l2tlb_way_2_wren[way_2_idx] = (l2tlb_sel_way_2 & (way_2_idx == l2tlb_widx));
		gnrl_dffl #( 
			.DATA_WIDTH(`L2TLB_TAG_WIDTH)
		) l2tlb_tag_way_2_dffl (l2tlb_way_2_wren[way_2_idx], l2tlb_wtag, l2tlb_tag_way_2[way_2_idx], clk);

		gnrl_dffl #( 
			.DATA_WIDTH(`L2TLB_DATA_WIDTH)
		) l2tlb_data_way_2_dffl (l2tlb_way_2_wren[way_2_idx], l2tlb_wdat, l2tlb_data_way_2[way_2_idx], clk);
	end
endgenerate

//	Way 3
wire l2tlb_vld_way_3_ena = l2tlb_sel_way_3;

wire [255 : 0] l2tlb_vld_way_3_nxt = (l2tlb_vld_way_3 | ({256{l2tlb_vld_way_3_ena}} & l2tlb_vld_way_set));

gnrl_dfflr #( 
	.DATA_WIDTH   (256),
	.INITIAL_VALUE(0)
) l2tlb_vld_way_3_dfflr (l2tlb_vld_way_3_ena, l2tlb_vld_way_3_nxt, l2tlb_vld_way_3, clk, rst_n);

wire [255 : 0] l2tlb_way_3_wren;

genvar way_3_idx;
generate
	for(way_3_idx = 0; way_3_idx < 256; way_3_idx = way_3_idx + 1) begin
		assign l2tlb_way_3_wren[way_3_idx] = (l2tlb_sel_way_3 & (way_3_idx == l2tlb_widx));
		gnrl_dffl #( 
			.DATA_WIDTH(`L2TLB_TAG_WIDTH)
		) l2tlb_tag_way_3_dffl (l2tlb_way_3_wren[way_3_idx], l2tlb_wtag, l2tlb_tag_way_3[way_3_idx], clk);

		gnrl_dffl #( 
			.DATA_WIDTH(`L2TLB_DATA_WIDTH)
		) l2tlb_data_way_3_dffl (l2tlb_way_3_wren[way_3_idx], l2tlb_wdat, l2tlb_data_way_3[way_3_idx], clk);
	end
endgenerate

//
assign o_l2tlb_paddr = {i_l2tlb_pte[31 : 10], i_l2tlb_vaddr[11 : 0]};


//
wire i_plru_hit = (i_l2tlb_rden & o_l2tlb_hit);
wire [1 : 0] i_plru_hit_idx = func_vec4(l2tlb_hit_vec);

wire i_plru_req = (i_l2tlb_wren & (&l2tlb_vld_vec));
wire [1 : 0] o_plru_replace_idx;

plru4_module plru ( 
    .i_plru_hit        (i_plru_hit),
    .i_plru_hit_idx    (i_plru_hit_idx),
    .i_plru_req        (i_plru_req),
    .o_plru_replace_idx(o_plru_replace_idx),
    .clk               (clk),
    .rst_n             (rst_n)
);
endmodule   //  l2tlb_module

`endif  /*  !__MMU_L2TLB_V__!   */