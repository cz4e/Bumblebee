`ifdef __IQ_BTAC_V__

module btac_module (
    input                                               i_btac_rden_0,
    input   [7                      : 0]                i_btac_ridx_0,
    input   [25                     : 0]                i_btac_rtag_0,
    output                                              o_btac_rd_hit_0,
    output  [1                      : 0]                o_btac_rd_way_0,
    output  [32                     : 0]                o_btac_rdat_0,
    input                                               i_btac_rden_1,
    input   [7                      : 0]                i_btac_ridx_1,
    input   [25                     : 0]                i_btac_rtag_1,
    output                                              o_btac_rd_hit_1,
    output  [1                      : 0]                o_btac_rd_way_1,
    output  [32                     : 0]                o_btac_rdat_1,
    input                                               i_btac_rden_2,
    input   [7                      : 0]                i_btac_ridx_2,
    input   [25                     : 0]                i_btac_rtag_2,
    output                                              o_btac_rd_hit_2,
    output  [1                      : 0]                o_btac_rd_way_2,
    output  [32                     : 0]                o_btac_rdat_2,
    input                                               i_btac_rden_3,
    input   [7                      : 0]                i_btac_ridx_3,
    input   [25                     : 0]                i_btac_rtag_3,
    output                                              o_btac_rd_hit_3,
    output  [1                      : 0]                o_btac_rd_way_3,
    output  [32                     : 0]                o_btac_rdat_3,
    input                                               i_btac_wren,
    input   [7                      : 0]                i_btac_widx,
    input   [25                     : 0]                i_btac_wtag,
    input   [32                     : 0]                i_btac_wdat,
    input                                               i_btac_updt,
    input   [7                      : 0]                i_btac_updt_idx,
    input   [1                      : 0]                i_btac_updt_way_idx,

    input                                               clk,
    input                                               rst_n
);

//  Way 0
wire [255 : 0] btac_vld_way_0_r;
wire [25 : 0] btac_tag_way_0_r [255 : 0];
wire [32 : 0] btac_dat_way_0_r [255 : 0];

//  Way 1
wire [255 : 0] btac_vld_way_1_r;
wire [25 : 0] btac_tag_way_1_r [255 : 0];
wire [32 : 0] btac_dat_way_1_r [255 : 0];

//  Way 2
wire [255 : 0] btac_vld_way_2_r;
wire [25 : 0] btac_tag_way_2_r [255 : 0];
wire [32 : 0] btac_dat_way_2_r [255 : 0];

//  Way 3
wire [255 : 0] btac_vld_way_3_r;
wire [25 : 0] btac_tag_way_3_r [255 : 0];
wire [32 : 0] btac_dat_way_3_r [255 : 0];

//  Way 0 Read
wire btac_idx_0_way_0_vld = btac_vld_way_0_r[i_btac_ridx_0];
wire [25 : 0] btac_idx_0_way_0_tag = btac_tag_way_0_r[i_btac_ridx_0];
wire [32 : 0] btac_idx_0_way_0_dat = btac_dat_way_0_r[i_btac_ridx_0];

wire btac_idx_1_way_0_vld = btac_vld_way_0_r[i_btac_ridx_1];
wire [25 : 0] btac_idx_1_way_0_tag = btac_tag_way_0_r[i_btac_ridx_1];
wire [32 : 0] btac_idx_1_way_0_dat = btac_dat_way_0_r[i_btac_ridx_1];

wire btac_idx_2_way_0_vld = btac_vld_way_0_r[i_btac_ridx_2];
wire [25 : 0] btac_idx_2_way_0_tag = btac_tag_way_0_r[i_btac_ridx_2];
wire [32 : 0] btac_idx_2_way_0_dat = btac_dat_way_0_r[i_btac_ridx_2];

wire btac_idx_3_way_0_vld = btac_vld_way_0_r[i_btac_ridx_3];
wire [25 : 0] btac_idx_3_way_0_tag = btac_tag_way_0_r[i_btac_ridx_3];
wire [32 : 0] btac_idx_3_way_0_dat = btac_dat_way_0_r[i_btac_ridx_3];

//  Way 1 Read
wire btac_idx_0_way_1_vld = btac_vld_way_1_r[i_btac_ridx_0];
wire [25 : 0] btac_idx_0_way_1_tag = btac_tag_way_1_r[i_btac_ridx_0];
wire [32 : 0] btac_idx_0_way_1_dat = btac_dat_way_1_r[i_btac_ridx_0];

wire btac_idx_1_way_1_vld = btac_vld_way_1_r[i_btac_ridx_1];
wire [25 : 0] btac_idx_1_way_1_tag = btac_tag_way_1_r[i_btac_ridx_1];
wire [32 : 0] btac_idx_1_way_1_dat = btac_dat_way_1_r[i_btac_ridx_1];

wire btac_idx_2_way_1_vld = btac_vld_way_1_r[i_btac_ridx_2];
wire [25 : 0] btac_idx_2_way_1_tag = btac_tag_way_1_r[i_btac_ridx_2];
wire [32 : 0] btac_idx_2_way_1_dat = btac_dat_way_1_r[i_btac_ridx_2];

wire btac_idx_3_way_1_vld = btac_vld_way_1_r[i_btac_ridx_3];
wire [25 : 0] btac_idx_3_way_1_tag = btac_tag_way_1_r[i_btac_ridx_3];
wire [32 : 0] btac_idx_3_way_1_dat = btac_dat_way_1_r[i_btac_ridx_3];

//  Way 2 Read
wire btac_idx_0_way_2_vld = btac_vld_way_2_r[i_btac_ridx_0];
wire [25 : 0] btac_idx_0_way_2_tag = btac_tag_way_2_r[i_btac_ridx_0];
wire [32 : 0] btac_idx_0_way_2_dat = btac_dat_way_2_r[i_btac_ridx_0];

wire btac_idx_1_way_2_vld = btac_vld_way_2_r[i_btac_ridx_1];
wire [25 : 0] btac_idx_1_way_2_tag = btac_tag_way_2_r[i_btac_ridx_1];
wire [32 : 0] btac_idx_1_way_2_dat = btac_dat_way_2_r[i_btac_ridx_1];

wire btac_idx_2_way_2_vld = btac_vld_way_2_r[i_btac_ridx_2];
wire [25 : 0] btac_idx_2_way_2_tag = btac_tag_way_2_r[i_btac_ridx_2];
wire [32 : 0] btac_idx_2_way_2_dat = btac_dat_way_2_r[i_btac_ridx_2];

wire btac_idx_3_way_2_vld = btac_vld_way_2_r[i_btac_ridx_3];
wire [25 : 0] btac_idx_3_way_2_tag = btac_tag_way_2_r[i_btac_ridx_3];
wire [32 : 0] btac_idx_3_way_2_dat = btac_dat_way_2_r[i_btac_ridx_3];

//  Way 3 Read
wire btac_idx_0_way_3_vld = btac_vld_way_3_r[i_btac_ridx_0];
wire [25 : 0] btac_idx_0_way_3_tag = btac_tag_way_3_r[i_btac_ridx_0];
wire [32 : 0] btac_idx_0_way_3_dat = btac_dat_way_3_r[i_btac_ridx_0];

wire btac_idx_1_way_3_vld = btac_vld_way_3_r[i_btac_ridx_1];
wire [25 : 0] btac_idx_1_way_3_tag = btac_tag_way_3_r[i_btac_ridx_1];
wire [32 : 0] btac_idx_1_way_3_dat = btac_dat_way_3_r[i_btac_ridx_1];

wire btac_idx_2_way_3_vld = btac_vld_way_3_r[i_btac_ridx_2];
wire [25 : 0] btac_idx_2_way_3_tag = btac_tag_way_3_r[i_btac_ridx_2];
wire [32 : 0] btac_idx_2_way_3_dat = btac_dat_way_3_r[i_btac_ridx_2];

wire btac_idx_3_way_3_vld = btac_vld_way_3_r[i_btac_ridx_3];
wire [25 : 0] btac_idx_3_way_3_tag = btac_tag_way_3_r[i_btac_ridx_3];
wire [32 : 0] btac_idx_3_way_3_dat = btac_dat_way_3_r[i_btac_ridx_3];

//
wire btac_idx_0_way_0_hit = (btac_idx_0_way_0_vld & (btac_idx_0_way_0_tag == i_btac_rtag_0));
wire btac_idx_0_way_1_hit = (btac_idx_0_way_1_vld & (btac_idx_0_way_1_tag == i_btac_rtag_0));
wire btac_idx_0_way_2_hit = (btac_idx_0_way_2_vld & (btac_idx_0_way_2_tag == i_btac_rtag_0));
wire btac_idx_0_way_3_hit = (btac_idx_0_way_3_vld & (btac_idx_0_way_3_tag == i_btac_rtag_0));

wire btac_idx_1_way_0_hit = (btac_idx_1_way_0_vld & (btac_idx_1_way_0_tag == i_btac_rtag_1));
wire btac_idx_1_way_1_hit = (btac_idx_1_way_1_vld & (btac_idx_1_way_1_tag == i_btac_rtag_1));
wire btac_idx_1_way_2_hit = (btac_idx_1_way_2_vld & (btac_idx_1_way_2_tag == i_btac_rtag_1));
wire btac_idx_1_way_3_hit = (btac_idx_1_way_3_vld & (btac_idx_1_way_3_tag == i_btac_rtag_1));

wire btac_idx_2_way_0_hit = (btac_idx_2_way_0_vld & (btac_idx_2_way_0_tag == i_btac_rtag_2));
wire btac_idx_2_way_1_hit = (btac_idx_2_way_1_vld & (btac_idx_2_way_1_tag == i_btac_rtag_2));
wire btac_idx_2_way_2_hit = (btac_idx_2_way_2_vld & (btac_idx_2_way_2_tag == i_btac_rtag_2));
wire btac_idx_2_way_3_hit = (btac_idx_2_way_3_vld & (btac_idx_2_way_3_tag == i_btac_rtag_2));

wire btac_idx_3_way_0_hit = (btac_idx_3_way_0_vld & (btac_idx_3_way_0_tag == i_btac_rtag_3));
wire btac_idx_3_way_1_hit = (btac_idx_3_way_1_vld & (btac_idx_3_way_1_tag == i_btac_rtag_3));
wire btac_idx_3_way_2_hit = (btac_idx_3_way_2_vld & (btac_idx_3_way_2_tag == i_btac_rtag_3));
wire btac_idx_3_way_3_hit = (btac_idx_3_way_3_vld & (btac_idx_3_way_3_tag == i_btac_rtag_3));

//
// rd_0 hit
assign o_btac_rd_hit_0 = ((btac_idx_0_way_0_hit | btac_idx_0_way_1_hit | btac_idx_0_way_2_hit | btac_idx_0_way_3_hit) & i_btac_rden_0);

assign o_btac_rd_way_0 = ({2{btac_idx_0_way_0_hit}} & 2'd0)
                       | ({2{btac_idx_0_way_1_hit}} & 2'd1)
                       | ({2{btac_idx_0_way_2_hit}} & 2'd2)
                       | ({2{btac_idx_0_way_3_hit}} & 2'd3);

assign o_btac_rdat_0 = ({33{btac_idx_0_way_0_hit}} & btac_idx_0_way_0_dat)
                     | ({33{btac_idx_0_way_1_hit}} & btac_idx_0_way_1_dat)
                     | ({33{btac_idx_0_way_2_hit}} & btac_idx_0_way_2_dat)
                     | ({33{btac_idx_0_way_3_hit}} & btac_idx_0_way_3_dat);

//  rd_1 hit
assign o_btac_rd_hit_1 = ((btac_idx_1_way_0_hit | btac_idx_1_way_1_hit | btac_idx_1_way_2_hit | btac_idx_1_way_3_hit) & i_btac_rden_1);

assign o_btac_rd_way_1 = ({2{btac_idx_1_way_0_hit}} & 2'd0)
                       | ({2{btac_idx_1_way_1_hit}} & 2'd1)
                       | ({2{btac_idx_1_way_2_hit}} & 2'd2)
                       | ({2{btac_idx_1_way_3_hit}} & 2'd3);

assign o_btac_rdat_1 = ({33{btac_idx_1_way_0_hit}} & btac_idx_1_way_0_dat)
                     | ({33{btac_idx_1_way_1_hit}} & btac_idx_1_way_1_dat)
                     | ({33{btac_idx_1_way_2_hit}} & btac_idx_1_way_2_dat)
                     | ({33{btac_idx_1_way_3_hit}} & btac_idx_1_way_3_dat);

//  rd_2 hit
assign o_btac_rd_hit_2 = ((btac_idx_2_way_0_hit | btac_idx_2_way_1_hit | btac_idx_2_way_2_hit | btac_idx_2_way_3_hit) & i_btac_rden_2);

assign o_btac_rd_way_2 = ({2{btac_idx_2_way_0_hit}} & 2'd0)
                       | ({2{btac_idx_2_way_1_hit}} & 2'd1)
                       | ({2{btac_idx_2_way_2_hit}} & 2'd2)
                       | ({2{btac_idx_2_way_3_hit}} & 2'd3);

assign o_btac_rdat_2 = ({33{btac_idx_2_way_0_hit}} & btac_idx_2_way_0_dat)
                     | ({33{btac_idx_2_way_1_hit}} & btac_idx_2_way_1_dat)
                     | ({33{btac_idx_2_way_2_hit}} & btac_idx_2_way_2_dat)
                     | ({33{btac_idx_2_way_3_hit}} & btac_idx_2_way_3_dat);

//  rd_3 hit
assign o_btac_rd_hit_3 = ((btac_idx_3_way_0_hit | btac_idx_3_way_1_hit | btac_idx_3_way_2_hit | btac_idx_3_way_3_hit) & i_btac_rden_3);

assign o_btac_rd_way_3 = ({2{btac_idx_3_way_0_hit}} & 2'd0)
                       | ({2{btac_idx_3_way_1_hit}} & 2'd1)
                       | ({2{btac_idx_3_way_2_hit}} & 2'd2)
                       | ({2{btac_idx_3_way_3_hit}} & 2'd3);

assign o_btac_rdat_3 = ({33{btac_idx_3_way_0_hit}} & btac_idx_3_way_0_dat)
                     | ({33{btac_idx_3_way_1_hit}} & btac_idx_3_way_1_dat)
                     | ({33{btac_idx_3_way_2_hit}} & btac_idx_3_way_2_dat)
                     | ({33{btac_idx_3_way_3_hit}} & btac_idx_3_way_3_dat);
//
wire btac_wr_way_0_vld = (btac_vld_way_0_r[i_btac_widx]);
wire btac_wr_way_1_vld = (btac_vld_way_1_r[i_btac_widx]);
wire btac_wr_way_2_vld = (btac_vld_way_2_r[i_btac_widx]);
wire btac_wr_way_3_vld = (btac_vld_way_3_r[i_btac_widx]);

wire btac_free_line = (~(btac_wr_way_0_vld | btac_wr_way_1_vld | btac_wr_way_2_vld | btac_wr_way_3_vld));


//  Write Logic
wire [1 : 0] btac_wr_idx = btac_free_line ? (   ({2{btac_wr_way_0_vld                                                                     }} & 2'd0)
                                            |   ({2{btac_wr_way_1_vld & (~btac_wr_way_0_vld)                                              }} & 2'd1)
                                            |   ({2{btac_wr_way_2_vld & (~btac_wr_way_0_vld) & (~btac_wr_way_1_vld)                       }} & 2'd2)
                                            |   ({2{btac_wr_way_3_vld & (~btac_wr_way_0_vld) & (~btac_wr_way_1_vld) & (~btac_wr_way_3_vld)}} & 2'd3))  
                         : o_plru_replace_idx;
wire [255 : 0] vld_wr_ena [3 : 0];
wire [255 : 0] vld_wr_nxt [3 : 0];

genvar vld_wr_idx;
generate
    for(vld_wr_idx = 0; vld_wr_idx < 256; vld_wr_idx = vld_wr_idx + 1) begin
        //  Way 0
        assign vld_wr_ena[0][vld_wr_idx] = ((vld_wr_idx == i_btac_widx) & (btac_wr_idx == 2'd0) & i_btac_wren)
                                         | ((vld_wr_idx == i_btac_updt_idx) & (i_btac_updt_way_idx == 2'd0) & i_btac_updt);
        assign vld_wr_nxt[0][vld_wr_idx] = ({1{i_btac_updt & (i_btac_updt_way_idx == 2'd0) & (vld_wr_idx == i_btac_updt_idx)}} & 1'b0)
                                         | ({1{i_btac_wren                                                                  }} & 1'b1);
        gnrl_dfflr #(
            .DATA_WIDTH   (1),
            .INITIAL_VALUE(0)
        ) btac_way_0_vld_dfflr (vld_wr_ena[0][vld_wr_idx],  vld_wr_nxt[0][vld_wr_idx], btac_vld_way_0_r[vld_wr_idx], clk, rst_n);

        gnrl_dffl #(
            .DATA_WIDTH   (26)
        ) btac_way_0_tag_dffl (vld_wr_ena[0][vld_wr_idx], i_btac_wtag, btac_tag_way_0_r[vld_wr_idx], clk);
        
        gnrl_dffl #(
            .DATA_WIDTH   (33)
        ) btac_way_0_dat_dffl (vld_wr_ena[0][vld_wr_idx], i_btac_wdat, btac_dat_way_0_r[vld_wr_idx], clk);

        //  Way 1
        assign vld_wr_ena[1][vld_wr_idx] = ((vld_wr_idx == i_btac_widx) & (btac_wr_idx == 2'd1) & i_btac_wren) 
                                         | ((vld_wr_idx == i_btac_updt_idx) & (i_btac_updt_way_idx == 2'd1) & i_btac_updt);
        assign vld_wr_nxt[1][vld_wr_idx] = ({1{i_btac_updt & (i_btac_updt_way_idx == 2'd1) & (vld_wr_idx == i_btac_updt_idx)}} & 1'b0)
                                         | ({1{i_btac_wren                                                                  }} & 1'b1);
        gnrl_dfflr #(
            .DATA_WIDTH   (1),
            .INITIAL_VALUE(0)
        ) btac_way_1_vld_dfflr (vld_wr_ena[1][vld_wr_idx], vld_wr_nxt[1][vld_wr_idx], btac_vld_way_1_r[vld_wr_idx], clk, rst_n);

        gnrl_dffl #(
            .DATA_WIDTH   (26)
        ) btac_way_1_tag_dffl (vld_wr_ena[1][vld_wr_idx], i_btac_wtag, btac_tag_way_1_r[vld_wr_idx], clk);
        
        gnrl_dffl #(
            .DATA_WIDTH   (33)
        ) btac_way_1_dat_dffl (vld_wr_ena[1][vld_wr_idx], i_btac_wdat, btac_dat_way_1_r[vld_wr_idx], clk);

        //  Way 2
        assign vld_wr_ena[2][vld_wr_idx] = ((vld_wr_idx == i_btac_widx) & (btac_wr_idx == 2'd2) & i_btac_wren)
                                         | ((vld_wr_idx == i_btac_updt_idx) & (i_btac_updt_way_idx == 2'd2) & i_btac_updt);
        assign vld_wr_nxt[2][vld_wr_idx] = ({1{i_btac_updt & (i_btac_updt_way_idx == 2'd2) & (vld_wr_idx == i_btac_updt_idx)}} & 1'b0)
                                         | ({1{i_btac_wren                                                                  }} & 1'b1);
        gnrl_dfflr #(
            .DATA_WIDTH   (1),
            .INITIAL_VALUE(0)
        ) btac_way_2_vld_dfflr (vld_wr_ena[2][vld_wr_idx], vld_wr_nxt[2][vld_wr_idx], btac_vld_way_2_r[vld_wr_idx], clk, rst_n);
        
        gnrl_dffl #(
            .DATA_WIDTH   (26)
        ) btac_way_2_tag_dffl (vld_wr_ena[2][vld_wr_idx], i_btac_wtag, btac_tag_way_2_r[vld_wr_idx], clk);
        
        gnrl_dffl #(
            .DATA_WIDTH   (33)
        ) btac_way_2_dat_dffl (vld_wr_ena[2][vld_wr_idx], i_btac_wdat, btac_dat_way_2_r[vld_wr_idx], clk);

        //  Way 3
        assign vld_wr_ena[3][vld_wr_idx] = ((vld_wr_idx == i_btac_widx) & (btac_wr_idx == 2'd3) & i_btac_wren)
                                         | ((vld_wr_idx == i_btac_updt_idx) & (i_btac_updt_way_idx == 2'd3) & i_btac_updt);
        assign vld_wr_nxt[3][vld_wr_idx] = ({1{i_btac_updt & (i_btac_updt_way_idx == 2'd3) & (vld_wr_idx == i_btac_updt_idx)}} & 1'b0)
                                         | ({1{i_btac_wren                                                                  }} & 1'b1);
        gnrl_dfflr #(
            .DATA_WIDTH   (1),
            .INITIAL_VALUE(0)
        ) btac_way_3_vld_dfflr (vld_wr_ena[3][vld_wr_idx], vld_wr_nxt[3][vld_wr_idx], btac_vld_way_3_r[vld_wr_idx], clk, rst_n);

        gnrl_dffl #(
            .DATA_WIDTH   (26)
        ) btac_way_3_tag_dffl (vld_wr_ena[3][vld_wr_idx], i_btac_wtag, btac_tag_way_3_r[vld_wr_idx], clk);
        
        gnrl_dffl #(
            .DATA_WIDTH   (33)
        ) btac_way_3_dat_dffl (vld_wr_ena[3][vld_wr_idx], i_btac_wdat, btac_dat_way_3_r[vld_wr_idx], clk);

    end
endgenerate

//

//  
wire i_plru_hit = (o_btac_rd_hit_0 | o_btac_rd_hit_1 | o_btac_rd_hit_2 | o_btac_rd_hit_3);
wire [1 : 0] i_plru_hit_idx = ({2{o_btac_rd_hit_3                                                               }} & i_btac_ridx_3)
                            | ({2{o_btac_rd_hit_2 & (~o_btac_rd_hit_3)                                          }} & i_btac_ridx_2)
                            | ({2{o_btac_rd_hit_1 & (~o_btac_rd_hit_3) & (~o_btac_rd_hit_2)                     }} & i_btac_ridx_1)
                            | ({2{o_btac_rd_hit_0 & (~o_btac_rd_hit_3) & (~o_btac_rd_hit_2) & (~o_btac_rd_hit_1)}} & i_btac_ridx_0);
wire i_plru_req = (i_btac_wren & (~btac_free_line));
wire [1 : 0] o_plru_replace_idx;

plru4_module btac_plru (
    .i_plru_hit        (i_plru_hit),
    .i_plru_hit_idx    (i_plru_hit_idx),
    .i_plru_req        (i_plru_req),
    .o_plru_replace_idx(o_plru_replace_idx),
    .clk               (clk),
    .rst_n             (rst_n)
);

endmodule   //  btac_module

`endif  /*  !__IQ_BTAC_V__! */