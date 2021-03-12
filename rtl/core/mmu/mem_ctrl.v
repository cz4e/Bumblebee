`ifdef __MMU_MEM_CTRL_V__

module mem_ctrl_module ( 
    input                                           i_mem_ext_rden,
    input                                           i_mem_ext_wren,
    input   [`BYTE_MASK_WIDTH - 1   : 0]            i_mem_ext_mask,
    input   [2                      : 0]            i_mem_ext_burst_size,
    input   [`PHY_ADDR_WIDTH - 1    : 0]            i_mem_ext_paddr,
    input   [127                    : 0]            i_mem_ext_wdat,
    input                                           i_mem_ext_burst_start,
    input                                           i_mem_ext_burst_end,
    input                                           i_mem_ext_burst_vld,

    output                                          o_ext_mmu_rd_ack,
    output                                          o_ext_mmu_wr_ack,
    output  [127                    : 0]            o_ext_mmu_rdat,
    output                                          o_ext_mmu_rdy,

    input                                           clk,
    input                                           rst_n
);

wire rdy_flag_r;
wire rdy_flag_set = (i_mem_ext_burst_end & i_mem_ext_burst_vld);
wire rdy_flag_clr = (i_mem_ext_burst_start & i_mem_ext_burst_vld);
wire rdy_flag_ena = (rdy_flag_set | rdy_flag_clr);
wire rdy_flag_nxt = (rdy_flag_set | (~rdy_flag_clr));

gnrl_dfflr #( 
    .DATA_WIDTH   (1),
    .INITIAL_VALUE(1)
) rdy_flag_dfflr (rdy_flag_ena, rdy_flag_nxt, rdy_flag_r, clk, rst_n);

assign o_ext_mmu_rdy = rdy_flag_r;

wire mem_op_r;
wire mem_op_ena = (i_mem_ext_rden | i_mem_ext_wren);
wire mem_op_nxt = (i_mem_ext_wren | (~i_mem_ext_rden));

gnrl_dfflr #( 
    .DATA_WIDTH   (1),
    .INITIAL_VALUE(0)
) mem_op_dfflr (mem_op_ena, mem_op_nxt, mem_op_r, clk, rst_n);

//  Counter
localparam  MEM_CTR_WIDTH = 2;
localparam  MEM_CTR_0 = 2'd0,
            MEM_CTR_1 = 2'd1,
            MEM_CTR_2 = 2'd2,
            MEM_CTR_3 = 2'd3;

wire [MEM_CTR_WIDTH - 1 : 0] mem_wr_ctr_r, mem_ctr_nxt;
wire mem_ctr_set = (i_mem_ext_wren & rdy_flag_clr & i_mem_ext_burst_vld);
wire mem_wr_ctr_inc = ((~rdy_flag_r) & i_mem_ext_burst_vld);
wire mem_wr_ctr_ena = (mem_ctr_set | mem_wr_ctr_inc);

assign mem_wr_ctr_nxt = (mem_wr_ctr_set ? MEM_CTR_1 : (mem_wr_ctr_r + 3'd1));

gnrl_dfflr #( 
    .DATA_WIDTH   (MEM_CTR_WIDTH),
    .INITIAL_VALUE(0)
) mem_wr_ctr_dfflr (mem_wr_ctr_ena, mem_wr_ctr_nxt, mem_wr_ctr_r, clk, rst_n);

wire mem_wr_ctr_1th = (mem_wr_ctr_r == MEM_CTR_1);
wire mem_wr_ctr_2th = (mem_wr_ctr_r == MEM_CTR_2);
wire mem_wr_ctr_3th = (mem_wr_ctr_r == MEM_CTR_3);
wire mem_wr_ctr_last_cycle = (mem_wr_ctr_r == MEM_CTR_3);

//
wire [127 : 0] mem_dat_sft_0_r;
wire [127 : 0] mem_dat_sft_1_r;
wire [127 : 0] mem_dat_sft_2_r;

wire [511 : 0] mem_dat_vec = {
                                i_mem_ext_wdat
                            ,   mem_dat_sft_2_r
                            ,   mem_dat_sft_1_r
                            ,   mem_dat_sft_0_r
                            };

wire mem_sft_ena = mem_wr_ctr_inc;

wire mem_sft_2_ena = (mem_sft_ena & mem_wr_ctr_2th);
gnrl_dffl #( 
    .DATA_WIDTH(128)
) mem_dat_sft_2_dffl (mem_sft_2_ena, i_mem_ext_wdat, mem_dat_sft_2_r, clk);

wire mem_sft_1_ena = (mem_sft_ena & mem_wr_ctr_1th);
gnrl_dffl #( 
    .DATA_WIDTH(128)
) mem_dat_sft_1_dffl (mem_sft_1_ena, i_mem_ext_wdat, mem_dat_sft_1_r, clk);


wire mem_sft_0_ena = (mem_sft_ena & mem_wr_ctr_0th);
gnrl_dffl #( 
    .DATA_WIDTH(128)
) mem_dat_sft_0_dffl (mem_sft_0_ena, i_mem_ext_wdat, mem_dat_sft_0_r, clk);

//
wire [15 : 0] mem_mask_sft_0_r;
wire [15 : 0] mem_mask_sft_1_r;
wire [15 : 0] mem_mask_sft_2_r;

wire [63 : 0] mem_mask_vec = {
                                i_mem_ext_mask
                            ,   mem_dat_sft_2_r
                            ,   mem_dat_sft_1_r
                            ,   mem_dat_sft_0_r
                            };

gnrl_dffl #( 
    .DATA_WIDTH(16)
) mem_mask_sft_2_dffl (mem_sft_2_ena, i_mem_ext_mask, mem_mask_sft_2_r, clk);

gnrl_dffl #( 
    .DATA_WIDTH(16)
) mem_mask_sft_1_dffl (mem_sft_1_ena, i_mem_ext_mask, mem_mask_sft_1_r, clk);

gnrl_dffl #( 
    .DATA_WIDTH(16)
) mem_mask_sft_0_dffl (mem_sft_0_ena, i_mem_ext_mask, mem_mask_sft_0_r, clk);

//
wire mem_cr_vld = (i_mem_ext_paddr[5 : 0] != 6'h0);

wire [`PHY_ADDR_WIDTH - 1 : 0] mem_paddr = ({`PHY_ADDR_WIDTH{(~mem_cr_flag_r)}} & i_mem_ext_paddr                                          )
                                         | ({`PHY_ADDR_WIDTH{mem_cr_flag_r   }} & {(i_mem_ext_paddr[`PHY_ADDR_WIDTH - 1 : 9] + 1'd1), 9'h0});

wire [5 : 0] mem_offset = i_mem_ext_paddr[5 : 0];
//
wire i_cs = (~rdy_flag_r);

mem_module #( 
    .DATA_WIDTH(512),
    .ADDR_WIDTH()
) mem ( 
    .i_cs       (i_cs),
    .i_wren     (mem_op_r),
    .i_din      (mem_dat_vec),
    .i_addr     (mem_paddr),
    .i_byte_mask(mem_mask_vec),
    .o_dout     (mem_rdat),

    .clk        (clk),
    .rst_n      (rst_n)
);


assign o_ext_mmu_rd_ack = (mem_wr_ctr_last_cycle & (~mem_op_r));
assign o_ext_mmu_wr_ack = (mem_wr_ctr_last_cycle & mem_op_r);

//
wire [511 : 0] mem_rdat;

wire [511 : 0] mem_rdat_0;
wire [511 : 0] mem_rdat_1 = mem_rdat;
wire [1023 : 0] mem_rdat_vec = ({1024{mem_cr_vld   }} & {mem_rdat_1, mem_rdat_0})
                             | ({1024{(~mem_cr_vld)}} & {512'h0,     mem_rdat_1});
wire mem_rdat_ena = (mem_cr_vld & (~rdy_flag_r));

gnrl_dffl #( 
    .DATA_WIDTH(512)
) mem_rdat_dffl (mem_rdat_ena, mem_rdat_1, mem_rdat_0, clk);


wire mem_rdat_delay = (i_mem_ext_rden & mem_cr_vld & rdy_flag_r);



wire [511 : 0] mem_rdat_sel = ({512{(mem_offset == 6'h0 )}} & mem_rdat_vec[511  :   0])
                            | ({512{(mem_offset == 6'h1 )}} & mem_rdat_vec[519  :   8])
                            | ({512{(mem_offset == 6'h2 )}} & mem_rdat_vec[527  :  16])
                            | ({512{(mem_offset == 6'h3 )}} & mem_rdat_vec[535  :  24])
                            | ({512{(mem_offset == 6'h4 )}} & mem_rdat_vec[543  :  32])
                            | ({512{(mem_offset == 6'h5 )}} & mem_rdat_vec[551  :  40])
                            | ({512{(mem_offset == 6'h6 )}} & mem_rdat_vec[559  :  48])
                            | ({512{(mem_offset == 6'h7 )}} & mem_rdat_vec[567  :  56])
                            | ({512{(mem_offset == 6'h8 )}} & mem_rdat_vec[575  :  64])
                            | ({512{(mem_offset == 6'h9 )}} & mem_rdat_vec[583  :  72])
                            | ({512{(mem_offset == 6'h10)}} & mem_rdat_vec[591  :  80])
                            | ({512{(mem_offset == 6'h11)}} & mem_rdat_vec[599  :  88])
                            | ({512{(mem_offset == 6'h12)}} & mem_rdat_vec[607  :  96])
                            | ({512{(mem_offset == 6'h13)}} & mem_rdat_vec[615  : 104])
                            | ({512{(mem_offset == 6'h14)}} & mem_rdat_vec[623  : 112])
                            | ({512{(mem_offset == 6'h15)}} & mem_rdat_vec[631  : 120])
                            | ({512{(mem_offset == 6'h16)}} & mem_rdat_vec[639  : 128])
                            | ({512{(mem_offset == 6'h17)}} & mem_rdat_vec[647  : 136])
                            | ({512{(mem_offset == 6'h18)}} & mem_rdat_vec[655  : 144])
                            | ({512{(mem_offset == 6'h19)}} & mem_rdat_vec[663  : 152])
                            | ({512{(mem_offset == 6'h20)}} & mem_rdat_vec[671  : 160])
                            | ({512{(mem_offset == 6'h21)}} & mem_rdat_vec[679  : 168])
                            | ({512{(mem_offset == 6'h22)}} & mem_rdat_vec[687  : 176])
                            | ({512{(mem_offset == 6'h23)}} & mem_rdat_vec[695  : 184])
                            | ({512{(mem_offset == 6'h24)}} & mem_rdat_vec[703  : 192])
                            | ({512{(mem_offset == 6'h25)}} & mem_rdat_vec[711  : 200])
                            | ({512{(mem_offset == 6'h26)}} & mem_rdat_vec[719  : 208])
                            | ({512{(mem_offset == 6'h27)}} & mem_rdat_vec[727  : 216])
                            | ({512{(mem_offset == 6'h28)}} & mem_rdat_vec[735  : 224])
                            | ({512{(mem_offset == 6'h29)}} & mem_rdat_vec[743  : 232])
                            | ({512{(mem_offset == 6'h30)}} & mem_rdat_vec[751  : 240])
                            | ({512{(mem_offset == 6'h31)}} & mem_rdat_vec[759  : 248])
                            | ({512{(mem_offset == 6'h32)}} & mem_rdat_vec[767  : 256])
                            | ({512{(mem_offset == 6'h33)}} & mem_rdat_vec[775  : 264])
                            | ({512{(mem_offset == 6'h34)}} & mem_rdat_vec[783  : 272])
                            | ({512{(mem_offset == 6'h35)}} & mem_rdat_vec[791  : 280])
                            | ({512{(mem_offset == 6'h36)}} & mem_rdat_vec[799  : 288])
                            | ({512{(mem_offset == 6'h37)}} & mem_rdat_vec[807  : 296])
                            | ({512{(mem_offset == 6'h38)}} & mem_rdat_vec[815  : 304])
                            | ({512{(mem_offset == 6'h39)}} & mem_rdat_vec[823  : 312])
                            | ({512{(mem_offset == 6'h40)}} & mem_rdat_vec[831  : 320])
                            | ({512{(mem_offset == 6'h41)}} & mem_rdat_vec[839  : 328])
                            | ({512{(mem_offset == 6'h42)}} & mem_rdat_vec[847  : 336])
                            | ({512{(mem_offset == 6'h43)}} & mem_rdat_vec[855  : 344])
                            | ({512{(mem_offset == 6'h44)}} & mem_rdat_vec[863  : 352])
                            | ({512{(mem_offset == 6'h45)}} & mem_rdat_vec[871  : 360])
                            | ({512{(mem_offset == 6'h46)}} & mem_rdat_vec[879  : 368])
                            | ({512{(mem_offset == 6'h47)}} & mem_rdat_vec[887  : 376])
                            | ({512{(mem_offset == 6'h48)}} & mem_rdat_vec[895  : 384])
                            | ({512{(mem_offset == 6'h49)}} & mem_rdat_vec[903  : 392])
                            | ({512{(mem_offset == 6'h50)}} & mem_rdat_vec[911  : 400])
                            | ({512{(mem_offset == 6'h51)}} & mem_rdat_vec[919  : 408])
                            | ({512{(mem_offset == 6'h52)}} & mem_rdat_vec[927  : 416])
                            | ({512{(mem_offset == 6'h53)}} & mem_rdat_vec[935  : 424])
                            | ({512{(mem_offset == 6'h54)}} & mem_rdat_vec[943  : 432])
                            | ({512{(mem_offset == 6'h55)}} & mem_rdat_vec[951  : 440])
                            | ({512{(mem_offset == 6'h56)}} & mem_rdat_vec[959  : 448])
                            | ({512{(mem_offset == 6'h57)}} & mem_rdat_vec[967  : 456])
                            | ({512{(mem_offset == 6'h58)}} & mem_rdat_vec[975  : 464])
                            | ({512{(mem_offset == 6'h59)}} & mem_rdat_vec[983  : 472])
                            | ({512{(mem_offset == 6'h60)}} & mem_rdat_vec[991  : 480])
                            | ({512{(mem_offset == 6'h61)}} & mem_rdat_vec[999  : 488])
                            | ({512{(mem_offset == 6'h62)}} & mem_rdat_vec[1007 : 496])
                            | ({512{(mem_offset == 6'h63)}} & mem_rdat_vec[1015 : 504]);



//  
localparam  MEM_RD_CTR_WIDTH = 3;
localparam  MEM_RD_CTR_1 = 3'd1,
            MEM_RD_CTR_2 = 3'd2,
            MEM_RD_CTR_3 = 3'd3,
            MEM_RD_CTR_4 = 3'd4;

wire [MEM_RD_CTR_WIDTH - 1 : 0] mem_rd_ctr_r, mem_rd_ctr_nxt;
wire mem_rd_ctr_set = (i_mem_ext_rden & rdy_flag_r & i_mem_ext_burst_vld);
wire mem_rd_ctr_inc = ((~mem_rdat_delay) & (~mem_rd_last_cycle) & i_mem_ext_burst_vld);
wire mem_rd_ctr_ena = (mem_rd_ctr_set | mem_rd_ctr_inc);
assign mem_rd_ctr_nxt = (mem_rd_ctr_set ? MEM_RD_CTR_1 : (mem_rd_ctr_r + 3'd1));

gnrl_dfflr #( 
    .DATA_WIDTH   (MEM_RD_CTR_WIDTH),
    .INITIAL_VALUE(0)
) mem_rd_ctr_dfflr (mem_rd_ctr_ena, mem_rd_ctr_nxt, mem_rd_ctr_r, clk, rst_n);

wire mem_rd_ctr_1th = (mem_rd_ctr_r == MEM_RD_CTR_1);
wire mem_rd_ctr_2th = (mem_rd_ctr_r == MEM_RD_CTR_2);
wire mem_rd_ctr_3th = (mem_rd_ctr_r == MEM_RD_CTR_3);
wire mem_rd_ctr_4th = (mem_rd_ctr_r == MEM_RD_CTR_4);

wire mem_rd_last_cycle = ({1(i_mem_ext_burst_size == 3'd1)} & mem_rd_ctr_1th)
                       | ({1(i_mem_ext_burst_size == 3'd2)} & mem_rd_ctr_2th)
                       | ({1(i_mem_ext_burst_size == 3'd3)} & mem_rd_ctr_3th)
                       | ({1(i_mem_ext_burst_size == 3'd4)} & mem_rd_ctr_4th);

assign o_ext_mmu_rdat = ({128{mem_rd_ctr_1th}} & mem_rdat_sel[127 :   0])
                      | ({128{mem_rd_ctr_2th}} & mem_rdat_sel[255 : 128])
                      | ({128{mem_rd_ctr_3th}} & mem_rdat_sel[383 : 256])
                      | ({128{mem_rd_ctr_4th}} & mem_rdat_sel[511 : 384]);

endmodule   //  mem_ctrl_module


`endif  /*  !__MMU_MEM_CTRL_V__!    */