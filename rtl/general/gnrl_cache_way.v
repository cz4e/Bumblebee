`ifdef __GNRL_CACHE_WAY_V__

module cache_way_module #(
    parameter   CACHE_DEPTH = 128,
    parameter   DATA_WIDTH  = 128,
    parameter   INDEX_WIDTH = $clog2(CACHE_DEPTH)
) (
    input   [INDEX_WIDTH - 1        : 0]    i_cw_ridx,
    output  [DATA_WIDTH - 1         : 0]    o_cw_rdata,
    
    input                                   i_cw_wren,
    input   [INDEX_WIDTH - 1         : 0]   i_cw_widx,
    input   [DATA_WIDTH - 2          : 0]   i_cw_wdata,
    output                                  o_cw_wvalid,
    
    input                                   clk,
    input                                   rst_n
);

wire cw_valid [CACHE_DEPTH - 1 : 0];
wire [DATA_WIDTH - 1 : 0] cw_data [CACHE_DEPTH - 1 : 0];

//  Read Logic
assign o_cw_rdata = {cw_valid[i_cw_ridx], cw_data[i_cw_ridx]};

//  Valid
wire cw_valid_set = i_cw_wren;
wire cw_valid_clr = 1'b0;
wire cw_valid_ena = cw_valid_set | cw_valid_clr;
wire cw_valid_nxt = cw_valid_set | (~cw_valid_clr);

wire [CACHE_DEPTH - 1 : 0] cw_valid_sel;

genvar i;
generate
    for(i = 0; i < CACHE_DEPTH; i = i + 1) begin
        assign cw_valid_sel[i] = cw_valid_ena & (i == i_cw_widx);
        gnrl_dfflr #(
            .DATA_WIDTH(1),
            .INITIAL_VALUE(0)
        ) cw_valid_dfflr (cw_valid_sel[i], cw_valid_nxt, cw_valid[i], clk, rst_n);
    end
endgenerate

//  Write
assign o_cw_wvalid = cw_valid[i_cw_widx];

wire [CACHE_DEPTH - 1 : 0] cw_wsel;

genvar j;
generate
    for(j = 0; j < CACHE_DEPTH; j = j + 1) begin
        assign cw_wsel[j] = i_cw_wren & (j == i_cw_widx);
        gnrl_dffl #(
            .DATA_WIDTH(DATA_WIDTH - 1)
        ) cw_data_dffl (cw_wsel[j], i_cw_wdata, cw_data[j], clk);
    end
endgenerate

endmodule   //  cache_way_module

`endif  /*  !__GNRL_CACHE_WAY_V__!        */
