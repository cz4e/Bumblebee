`ifdef __GNRL_SRAM_V__

module sram_module #(
    parameter DATA_WIDTH = 32,
    parameter SRAM_DEPTH = 128,
    parameter ADDR_WIDTH = $clog2(SRAM_DEPTH),
    parameter CLEAR_ENABLE = 1,
    parameter INITIAL_VALUE = 0
) (
    input                           i_sram_cs,
    input                           i_sram_wren,
    input   [ADDR_WIDTH - 1 : 0]    i_sram_addr,
    input   [DATA_WIDTH - 1 : 0]    i_sram_din,
    output  [DATA_WIDTH - 1 : 0]    o_sram_dout,
    input                           clk,
    input                           rst_n
);



/*  Vivado IP Core
 *  DEPTH: 4096
 *  DW   : 2
 */
dist_mem_gen_0 sram (
    .i_ce(i_sram_ce),
    .we(i_sram_wren),
    .a(i_sram_addr),
    .d(i_sram_din),
    .spo(o_sram_dout),
    .clk(clk);
);

endmodule   //  sram_module

`endif  /*  !__GNRL_SRAM_V__!       */
