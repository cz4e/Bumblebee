`ifdef __DECODE_DEC_SRAT_V__

module dec_srat_module ( 
    input   [`ARF_CODE_WIDTH - 1                : 0]            i_srat_src1_arf_code_0,
    input   [`ARF_CODE_WIDTH - 1                : 0]            i_srat_src2_arf_code_0,
    input   [`ARF_CODE_WIDTH - 1                : 0]            i_srat_src3_arf_code_0,
    input   [`ARF_CODE_WIDTH - 1                : 0]            i_srat_src1_arf_code_1,
    input   [`ARF_CODE_WIDTH - 1                : 0]            i_srat_src2_arf_code_1,
    input   [`ARF_CODE_WIDTH - 1                : 0]            i_srat_src3_arf_code_1,
    input   [`ARF_CODE_WIDTH - 1                : 0]            i_srat_src1_arf_code_2,
    input   [`ARF_CODE_WIDTH - 1                : 0]            i_srat_src2_arf_code_2,
    input   [`ARF_CODE_WIDTH - 1                : 0]            i_srat_src3_arf_code_2,
    input   [`ARF_CODE_WIDTH - 1                : 0]            i_srat_src1_arf_code_3,
    input   [`ARF_CODE_WIDTH - 1                : 0]            i_srat_src2_arf_code_3,
    input   [`ARF_CODE_WIDTH - 1                : 0]            i_srat_src3_arf_code_3,

    output  [`PRF_CODE_WIDTH - 1                : 0]            o_srat_src1_prf_code_0,
    output  [`PRF_CODE_WIDTH - 1                : 0]            o_srat_src2_prf_code_0,
    output  [`PRF_CODE_WIDTH - 1                : 0]            o_srat_src3_prf_code_0,
    output  [`PRF_CODE_WIDTH - 1                : 0]            o_srat_src1_prf_code_1,
    output  [`PRF_CODE_WIDTH - 1                : 0]            o_srat_src2_prf_code_1,
    output  [`PRF_CODE_WIDTH - 1                : 0]            o_srat_src3_prf_code_1,
    output  [`PRF_CODE_WIDTH - 1                : 0]            o_srat_src1_prf_code_2,
    output  [`PRF_CODE_WIDTH - 1                : 0]            o_srat_src2_prf_code_2,
    output  [`PRF_CODE_WIDTH - 1                : 0]            o_srat_src3_prf_code_2,
    output  [`PRF_CODE_WIDTH - 1                : 0]            o_srat_src1_prf_code_3,
    output  [`PRF_CODE_WIDTH - 1                : 0]            o_srat_src2_prf_code_3,
    output  [`PRF_CODE_WIDTH - 1                : 0]            o_srat_src3_prf_code_3,

    input                                                       i_srat_wren_0,
    input   [`ARF_CODE_WIDTH - 1                : 0]            i_srat_wr_dst_code_0,
    input   [`PRF_CODE_WIDTH - 1                : 0]            i_srat_wr_prf_code_0,
    input                                                       i_srat_wren_1,
    input   [`ARF_CODE_WIDTH - 1                : 0]            i_srat_wr_dst_code_1,
    input   [`PRF_CODE_WIDTH - 1                : 0]            i_srat_wr_prf_code_1,
    input                                                       i_srat_wren_2,
    input   [`ARF_CODE_WIDTH - 1                : 0]            i_srat_wr_dst_code_2,
    input   [`PRF_CODE_WIDTH - 1                : 0]            i_srat_wr_prf_code_2,
    input                                                       i_srat_wren_3,
    input   [`ARF_CODE_WIDTH - 1                : 0]            i_srat_wr_dst_code_3,
    input   [`PRF_CODE_WIDTH - 1                : 0]            i_srat_wr_prf_code_3,

    output  [`PRF_CODE_WIDTH - 1                : 0]            o_srat_wr_pprf_code_0,
    output  [`PRF_CODE_WIDTH - 1                : 0]            o_srat_wr_pprf_code_1,
    output  [`PRF_CODE_WIDTH - 1                : 0]            o_srat_wr_pprf_code_2,
    output  [`PRF_CODE_WIDTH - 1                : 0]            o_srat_wr_pprf_code_3,

    input                                                       i_srat_except_flush,
    input   [`PRF_CODE_WIDTH - 1                : 0]            i_srat_flush_prf_code_0,
    input   [`PRF_CODE_WIDTH - 1                : 0]            i_srat_flush_prf_code_1,
    input   [`PRF_CODE_WIDTH - 1                : 0]            i_srat_flush_prf_code_2,
    input   [`PRF_CODE_WIDTH - 1                : 0]            i_srat_flush_prf_code_3,
    input   [`PRF_CODE_WIDTH - 1                : 0]            i_srat_flush_prf_code_4,
    input   [`PRF_CODE_WIDTH - 1                : 0]            i_srat_flush_prf_code_5,
    input   [`PRF_CODE_WIDTH - 1                : 0]            i_srat_flush_prf_code_6,
    input   [`PRF_CODE_WIDTH - 1                : 0]            i_srat_flush_prf_code_7,
    input   [`PRF_CODE_WIDTH - 1                : 0]            i_srat_flush_prf_code_8,
    input   [`PRF_CODE_WIDTH - 1                : 0]            i_srat_flush_prf_code_9,
    input   [`PRF_CODE_WIDTH - 1                : 0]            i_srat_flush_prf_code_10,
    input   [`PRF_CODE_WIDTH - 1                : 0]            i_srat_flush_prf_code_11,
    input   [`PRF_CODE_WIDTH - 1                : 0]            i_srat_flush_prf_code_12,
    input   [`PRF_CODE_WIDTH - 1                : 0]            i_srat_flush_prf_code_13,
    input   [`PRF_CODE_WIDTH - 1                : 0]            i_srat_flush_prf_code_14,
    input   [`PRF_CODE_WIDTH - 1                : 0]            i_srat_flush_prf_code_15,
    input   [`PRF_CODE_WIDTH - 1                : 0]            i_srat_flush_prf_code_16,
    input   [`PRF_CODE_WIDTH - 1                : 0]            i_srat_flush_prf_code_17,
    input   [`PRF_CODE_WIDTH - 1                : 0]            i_srat_flush_prf_code_18,
    input   [`PRF_CODE_WIDTH - 1                : 0]            i_srat_flush_prf_code_19,
    input   [`PRF_CODE_WIDTH - 1                : 0]            i_srat_flush_prf_code_20,
    input   [`PRF_CODE_WIDTH - 1                : 0]            i_srat_flush_prf_code_21,
    input   [`PRF_CODE_WIDTH - 1                : 0]            i_srat_flush_prf_code_22,
    input   [`PRF_CODE_WIDTH - 1                : 0]            i_srat_flush_prf_code_23,
    input   [`PRF_CODE_WIDTH - 1                : 0]            i_srat_flush_prf_code_24,
    input   [`PRF_CODE_WIDTH - 1                : 0]            i_srat_flush_prf_code_25,
    input   [`PRF_CODE_WIDTH - 1                : 0]            i_srat_flush_prf_code_26,
    input   [`PRF_CODE_WIDTH - 1                : 0]            i_srat_flush_prf_code_27,
    input   [`PRF_CODE_WIDTH - 1                : 0]            i_srat_flush_prf_code_28,
    input   [`PRF_CODE_WIDTH - 1                : 0]            i_srat_flush_prf_code_29,
    input   [`PRF_CODE_WIDTH - 1                : 0]            i_srat_flush_prf_code_30,
    input   [`PRF_CODE_WIDTH - 1                : 0]            i_srat_flush_prf_code_31,

    input                                                       clk,
    input                                                       rst_n
);

wire [`PRF_CODE_WIDTH - 1 : 0] spec_ren_table_r [31 : 0];

wire [`PRF_CODE_WIDTH - 1 : 0] srat_flush_arr [31 : 0];
assign srat_flush_arr = { 
                            i_srat_flush_prf_code_31
                        ,   i_srat_flush_prf_code_30
                        ,   i_srat_flush_prf_code_29
                        ,   i_srat_flush_prf_code_28
                        ,   i_srat_flush_prf_code_27
                        ,   i_srat_flush_prf_code_26
                        ,   i_srat_flush_prf_code_25
                        ,   i_srat_flush_prf_code_24
                        ,   i_srat_flush_prf_code_23
                        ,   i_srat_flush_prf_code_22
                        ,   i_srat_flush_prf_code_21
                        ,   i_srat_flush_prf_code_20
                        ,   i_srat_flush_prf_code_19
                        ,   i_srat_flush_prf_code_18
                        ,   i_srat_flush_prf_code_17
                        ,   i_srat_flush_prf_code_16
                        ,   i_srat_flush_prf_code_15
                        ,   i_srat_flush_prf_code_14
                        ,   i_srat_flush_prf_code_13
                        ,   i_srat_flush_prf_code_12
                        ,   i_srat_flush_prf_code_11
                        ,   i_srat_flush_prf_code_10
                        ,   i_srat_flush_prf_code_9
                        ,   i_srat_flush_prf_code_8
                        ,   i_srat_flush_prf_code_7
                        ,   i_srat_flush_prf_code_6
                        ,   i_srat_flush_prf_code_5
                        ,   i_srat_flush_prf_code_4
                        ,   i_srat_flush_prf_code_3
                        ,   i_srat_flush_prf_code_2
                        ,   i_srat_flush_prf_code_1
                        ,   i_srat_flush_prf_code_0
                        };

//  Write
wire [31 : 0] i_srat_wren;
wire [`PRF_CODE_WIDTH - 1 : 0] i_srat_wr_dat [31 : 0];

genvar i;
generate
    assign spec_ren_table_r[0] = `PRF_CODE_WIDTH'd0; // Always

    for(i = 1; i < 32; i = i + 1) begin
        assign i_srat_wren[i] = i_srat_except_flush
                              | (i_srat_wren_0 & (i == i_srat_wr_dst_code_0))
                              | (i_srat_wren_1 & (i == i_srat_wr_dst_code_1))
                              | (i_srat_wren_2 & (i == i_srat_wr_dst_code_2))
                              | (i_srat_wren_3 & (i == i_srat_wr_dst_code_3));
        assign i_srat_wr_dat[i] = i_srat_except_flush ? srat_flush_arr[i]
                                : ({`PRF_CODE_WIDTH{(i_srat_wren_0 & (i == i_srat_wr_dst_code_0))}} & i_srat_wr_prf_code_0)
                                | ({`PRF_CODE_WIDTH{(i_srat_wren_1 & (i == i_srat_wr_dst_code_1))}} & i_srat_wr_prf_code_1)
                                | ({`PRF_CODE_WIDTH{(i_srat_wren_2 & (i == i_srat_wr_dst_code_2))}} & i_srat_wr_prf_code_2)
                                | ({`PRF_CODE_WIDTH{(i_srat_wren_3 & (i == i_srat_wr_dst_code_3))}} & i_srat_wr_prf_code_3);
        gnrl_dffl #( 
            .DATA_WIDTH(`PRF_CODE_WIDTH)
        ) spec_ren_table_dffl (i_srat_wren[i], i_srat_wr_dat[i], spec_ren_table_r[i], clk);
    end
endgenerate

assign o_srat_wr_pprf_code_0 = spec_ren_table_r[i_srat_wr_dst_code_0];
assign o_srat_wr_pprf_code_1 = spec_ren_table_r[i_srat_wr_dst_code_1];
assign o_srat_wr_pprf_code_2 = spec_ren_table_r[i_srat_wr_dst_code_2];
assign o_srat_wr_pprf_code_3 = spec_ren_table_r[i_srat_wr_dst_code_3];

//  Read
assign o_srat_src1_prf_code_0 = spec_ren_table_r[i_srat_src1_arf_code_0];
assign o_srat_src2_prf_code_0 = spec_ren_table_r[i_srat_src2_arf_code_0];
assign o_srat_src3_prf_code_0 = spec_ren_table_r[i_srat_src3_arf_code_0];
assign o_srat_src1_prf_code_1 = spec_ren_table_r[i_srat_src1_arf_code_1];
assign o_srat_src2_prf_code_1 = spec_ren_table_r[i_srat_src2_arf_code_1];
assign o_srat_src3_prf_code_1 = spec_ren_table_r[i_srat_src3_arf_code_1];
assign o_srat_src1_prf_code_2 = spec_ren_table_r[i_srat_src1_arf_code_2];
assign o_srat_src2_prf_code_2 = spec_ren_table_r[i_srat_src2_arf_code_2];
assign o_srat_src3_prf_code_2 = spec_ren_table_r[i_srat_src3_arf_code_2];
assign o_srat_src1_prf_code_3 = spec_ren_table_r[i_srat_src1_arf_code_3];
assign o_srat_src2_prf_code_3 = spec_ren_table_r[i_srat_src2_arf_code_3];
assign o_srat_src3_prf_code_3 = spec_ren_table_r[i_srat_src3_arf_code_3];

endmodule   //  dec_srat_module

`endif  /*  !__DECODE_DEC_SRAT_V__! */