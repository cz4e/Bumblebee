`ifdef __IQ_PHT_V__

module pht_module (
    input   [10                     : 0]            i_pht_ridx_0,
    output  [1                      : 0]            o_pht_rd_entry_0,
    input   [10                     : 0]            i_pht_ridx_1,
    output  [1                      : 0]            o_pht_rd_entry_1,
    input   [10                     : 0]            i_pht_ridx_2,
    output  [1                      : 0]            o_pht_rd_entry_2,
    input   [10                     : 0]            i_pht_ridx_3,
    output  [1                      : 0]            o_pht_rd_entry_3,
    
    input                                           i_pht_wren,
    input   [10                     : 0]            i_pht_widx,
    input   [1                      : 0]            i_pht_wr_entry,

    input                                           clk,
    input                                           rst_n
);

wire [1 : 0] pht_r [2047 : 0];

assign o_pht_rd_entry_0 = pht_r[i_pht_ridx_0];
assign o_pht_rd_entry_1 = pht_r[i_pht_ridx_1];
assign o_pht_rd_entry_2 = pht_r[i_pht_ridx_2];
assign o_pht_rd_entry_3 = pht_r[i_pht_ridx_3];


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


endmodule   //  pht_module

`endif  /*  !__IQ_PHT_V__!      */