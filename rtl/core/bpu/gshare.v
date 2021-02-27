`ifdef __BPU_GSHARE_V__

module bpu_gshare_module ( 
    input   [`CORE_PC_WIDTH - 1         : 0]    i_gs_pc_addr,
    output                                      o_gs_pred_taken,
    output  [1                          : 0]    o_gs_pht_entry,
    output  [`GHR_PHT_IDX_WIDTH - 1     : 0]    o_gs_pht_idx,

    input                                       i_gs_wren,
    input                                       i_gs_tsucc,
    input   [`GHR_PHT_IDX_WIDTH - 1     : 0]    i_gs_update_pht_idx,
    input   [1                          : 0]    i_gs_update_pht_entry,

    input                                       clk,
    input                                       rst_n
);

wire [`GHR_WIDTH - 1 : 0] gs_ghr_r;

wire gs_ghr_ena = i_gs_wren;
wire [`GHR_WIDTH - 1 : 0] gs_ghr_nxt = {gs_ghr_r[`GHR_WIDTH - 1 : 1], i_gs_tsucc};

gnrl_dfflr #( 
    .DATA_WIDTH   (`GHR_WIDTH),
    .INITIAL_VALUE(0)
) gs_ghr_dfflr (gs_ghr_ena, gs_ghr_nxt, gs_ghr_r, clk, rst_n);


wire [23 : 0] gs_ridx_24 = (i_gs_pc_addr[23 : 0] ^ gs_ghr_r);
wire [`GHR_PHT_IDX_WIDTH : 0] gs_ridx = (i_gs_pc_addr[31 : 20] ^ gs_ridx_24[11 : 0] ^ gs_rd_idx_24[23 : 12]);
wire [`GHR_PHT_IDX_WIDTH - 1 : 0] i_gs_ridx = gs_ridx[10 : 0];

/********************* PHT Module **************************/
ghr_pht_module ghr_pht ( 
    .i_pht_ridx    (i_gs_ridx),
    .o_pht_rd_entry(o_gs_pht_entry),
    .i_pht_wren    (i_gs_wren),
    .i_pht_widx    (i_gs_update_pht_idx),
    .i_pht_wr_entry(i_gs_update_pht_entry),

    .clk           (clk),
    .rst_n         (rst_n)
);

endmodule   //  bpu_gshare_module

`endif  /*  !__BPU_GSHARE_V__!  */