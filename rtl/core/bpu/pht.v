`ifdef __BPU_BPU_PHT_V__

module bpu_pht_module ( 
    input   [`GHR_PHT_IDX_WIDTH - 1         : 0]            i_pht_ridx,
    output  [1                              : 0]            o_pht_rd_entry,

    input                                                   i_pht_wren,
    input   [`GHR_PHT_IDX_WIDTH - 1         : 0]            i_pht_widx,
    input   [1                              : 0]            i_pht_wr_entry,

    input                                                   clk,
    input                                                   rst_n
);

wire [1 : 0] pht_r [2047 : 0];

assign o_pht_rd_entry = pht_r[i_pht_ridx];

wire [2047 : 0] pht_ena;

genvar i;
generate
    for(i = 0; i < 2048; i = i + 1) begin
        assign pht_ena[i] = (i_pht_wren & (i == i_pht_widx));
        gnrl_dfflr #( 
            .DATA_WIDTH   (2),
            .INITIAL_VALUE(0)
        ) pht_r_dfflr (pht_ena[i], i_pht_wr_entry, pht_r[i], clk, rst_n);
    end
endgenerate

endmodule   //  bpu_pht_module

`endif  /*  !__BPU_BPU_PHT_V__! */