`ifdef __MMU_MEM_CTRL_V__

module mem_ctrl_module ( 
    input                                           i_mem_ext_rden,
    input                                           i_mem_ext_wren,
    input   [`BYTE_MASK_WIDTH - 1   : 0]            i_mem_ext_mask,
    input   [2                      : 0]            i_mem_ext_burst,
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
localparam  MEM_CTR_WIDTH = 3;
localparam  MEM_CTR_1 = 3'd1,
            MEM_CTR_2 = 3'd2,
            MEM_CTR_3 = 3'd3,
            MEM_CTR_4 = 3'd4;

wire [MEM_CTR_WIDTH - 1 : 0] mem_ctr_r, mem_ctr_nxt;
wire mem_ctr_set = rdy_flag_clr;
wire mem_ctr_inc = (~rdy_flag_set);
wire mem_ctr_ena = (mem_ctr_set | mem_ctr_inc);

assign mem_ctr_nxt = (mem_ctr_set ? MEM_CTR_1 : (mem_ctr_r + 3'd1));

gnrl_dfflr #( 
    .DATA_WIDTH   (MEM_CTR_WIDTH),
    .INITIAL_VALUE(0)
) mem_ctr_dfflr (mem_ctr_ena, mem_ctr_nxt, mem_ctr_r, clk, rst_n);

wire mem_ctr_last_cycle = (mem_ctr_r == MEM_CTR_4);

//
wire [127 : 0] mem_sft_0_r;
wire [127 : 0] mem_sft_1_r;
wire [127 : 0] mem_sft_2_r;
wire [127 : 0] mem_sft_3_r;

wire [511 : 0] mem_dat_vec = {
                                mem_sft_3_r
                            ,   mem_sft_2_r
                            ,   mem_sft_1_r
                            ,   mem_sft_0_r
                            };

wire mem_sft_ena = (~rdy_flag_set);

gnrl_dffl #( 
    .DATA_WIDTH(128)
) mem_sft_3_dffl (mem_sft_ena, i_mem_ext_wdat, mem_sft_3_r, clk);

gnrl_dffl #( 
    .DATA_WIDTH(128)
) mem_sft_2_dffl (mem_sft_ena, mem_sft_3_r, mem_sft_2_r, clk);

gnrl_dffl #( 
    .DATA_WIDTH(128)
) mem_sft_1_dffl (mem_sft_ena, mem_sft_2_r, mem_sft_1_r, clk);

gnrl_dffl #( 
    .DATA_WIDTH(128)
) mem_sft_0_dffl (mem_sft_ena, mem_sft_1_r, mem_sft_0_r, clk);



//
wire i_cs = (~rdy_flag_r);

mem_module #( 
    .DATA_WIDTH(512),
    .ADDR_WIDTH()
) mem ( 
    .i_cs       (i_cs),
    .i_wren     (mem_op_r),
    .i_din      (mem_dat_vec),
    .i_addr     (i_mem_ext_paddr),
    .i_byte_mask(),
    .o_dout     (),

    .clk        (clk),
    .rst_n      (rst_n)
);


assign o_ext_mmu_rd_ack = (mem_ctr_last_cycle & (~mem_op_r));
assign o_ext_mmu_wr_ack = (mem_ctr_last_cycle & mem_op_r);
assign o_ext_mmu_rdat   = ()

endmodule   //  mem_ctrl_module


`endif  /*  !__MMU_MEM_CTRL_V__!    */