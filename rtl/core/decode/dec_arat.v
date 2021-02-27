`ifdef __DECODE_DEC_ARAT_V__

module dec_arat_module (
    input                                           i_arat_wren_0,
    input       [`ARF_CODE_WIDTH - 1    : 0]        i_arat_wr_dst_code_0,
    input       [`PRF_CODE_WIDTH - 1    : 0]        i_arat_wr_prf_code_0,
    input                                           i_arat_wren_1,
    input       [`ARF_CODE_WIDTH - 1    : 0]        i_arat_wr_dst_code_1,
    input       [`PRF_CODE_WIDTH - 1    : 0]        i_arat_wr_prf_code_1,
    input                                           i_arat_wren_2,
    input       [`ARF_CODE_WIDTH - 1    : 0]        i_arat_wr_dst_code_2,
    input       [`PRF_CODE_WIDTH - 1    : 0]        i_arat_wr_prf_code_2,
    input                                           i_arat_wren_3,
    input       [`ARF_CODE_WIDTH - 1    : 0]        i_arat_wr_dst_code_3,
    input       [`PRF_CODE_WIDTH - 1    : 0]        i_arat_wr_prf_code_3,
    
    output      [`PRF_CODE_WIDTH - 1    : 0]        o_arat_ret_prf_code_0,
    output      [`PRF_CODE_WIDTH - 1    : 0]        o_arat_ret_prf_code_1,
    output      [`PRF_CODE_WIDTH - 1    : 0]        o_arat_ret_prf_code_2,
    output      [`PRF_CODE_WIDTH - 1    : 0]        o_arat_ret_prf_code_3,

    output      [`PRF_CODE_WIDTH - 1    : 0]        o_arat_flush_prf_code_0,
    output      [`PRF_CODE_WIDTH - 1    : 0]        o_arat_flush_prf_code_1,
    output      [`PRF_CODE_WIDTH - 1    : 0]        o_arat_flush_prf_code_2,
    output      [`PRF_CODE_WIDTH - 1    : 0]        o_arat_flush_prf_code_3,
    output      [`PRF_CODE_WIDTH - 1    : 0]        o_arat_flush_prf_code_4,
    output      [`PRF_CODE_WIDTH - 1    : 0]        o_arat_flush_prf_code_5,
    output      [`PRF_CODE_WIDTH - 1    : 0]        o_arat_flush_prf_code_6,
    output      [`PRF_CODE_WIDTH - 1    : 0]        o_arat_flush_prf_code_7,
    output      [`PRF_CODE_WIDTH - 1    : 0]        o_arat_flush_prf_code_8,
    output      [`PRF_CODE_WIDTH - 1    : 0]        o_arat_flush_prf_code_9,
    output      [`PRF_CODE_WIDTH - 1    : 0]        o_arat_flush_prf_code_10,
    output      [`PRF_CODE_WIDTH - 1    : 0]        o_arat_flush_prf_code_11,
    output      [`PRF_CODE_WIDTH - 1    : 0]        o_arat_flush_prf_code_12,
    output      [`PRF_CODE_WIDTH - 1    : 0]        o_arat_flush_prf_code_13,
    output      [`PRF_CODE_WIDTH - 1    : 0]        o_arat_flush_prf_code_14,
    output      [`PRF_CODE_WIDTH - 1    : 0]        o_arat_flush_prf_code_15,
    output      [`PRF_CODE_WIDTH - 1    : 0]        o_arat_flush_prf_code_16,
    output      [`PRF_CODE_WIDTH - 1    : 0]        o_arat_flush_prf_code_17,
    output      [`PRF_CODE_WIDTH - 1    : 0]        o_arat_flush_prf_code_18,
    output      [`PRF_CODE_WIDTH - 1    : 0]        o_arat_flush_prf_code_19,
    output      [`PRF_CODE_WIDTH - 1    : 0]        o_arat_flush_prf_code_20,
    output      [`PRF_CODE_WIDTH - 1    : 0]        o_arat_flush_prf_code_21,
    output      [`PRF_CODE_WIDTH - 1    : 0]        o_arat_flush_prf_code_22,
    output      [`PRF_CODE_WIDTH - 1    : 0]        o_arat_flush_prf_code_23,
    output      [`PRF_CODE_WIDTH - 1    : 0]        o_arat_flush_prf_code_24,
    output      [`PRF_CODE_WIDTH - 1    : 0]        o_arat_flush_prf_code_25,
    output      [`PRF_CODE_WIDTH - 1    : 0]        o_arat_flush_prf_code_26,
    output      [`PRF_CODE_WIDTH - 1    : 0]        o_arat_flush_prf_code_27,
    output      [`PRF_CODE_WIDTH - 1    : 0]        o_arat_flush_prf_code_28,
    output      [`PRF_CODE_WIDTH - 1    : 0]        o_arat_flush_prf_code_29,
    output      [`PRF_CODE_WIDTH - 1    : 0]        o_arat_flush_prf_code_30,
    output      [`PRF_CODE_WIDTH - 1    : 0]        o_arat_flush_prf_code_31,

    input                                           clk,
    input                                           rst_n
);

wire [`PRF_CODE_WIDTH - 1 : 0] arch_ren_table_r [31 : 0];

//  Write
wire [31 : 0] i_arat_wren;
wire [`PRF_CODE_WIDTH - 1 : 0] i_arat_wr_dat [31 : 0];

genvar i;
generate
    assign arch_ren_table_r[0] = `PRF_CODE_WIDTH'd0; // Always 

    for(i = 1; i < 32; i = i + 1) begin
        assign i_arat_wren[i] = (i_arat_wren_0 & (i == i_arat_wr_dst_code_0))
                              | (i_arat_wren_1 & (i == i_arat_wr_dst_code_1))
                              | (i_arat_wren_2 & (i == i_arat_wr_dst_code_2))
                              | (i_arat_wren_3 & (i == i_arat_wr_dst_code_3));
        assign i_arat_wr_dat[i] = ({`PRF_CODE_WIDTH{(i_arat_wren_0 & (i == i_arat_wr_dst_code_0))}} & i_arat_wr_prf_code_0)
                                | ({`PRF_CODE_WIDTH{(i_arat_wren_1 & (i == i_arat_wr_dst_code_1))}} & i_arat_wr_prf_code_1)
                                | ({`PRF_CODE_WIDTH{(i_arat_wren_2 & (i == i_arat_wr_dst_code_2))}} & i_arat_wr_prf_code_2)
                                | ({`PRF_CODE_WIDTH{(i_arat_wren_3 & (i == i_arat_wr_dst_code_3))}} & i_arat_wr_prf_code_3);
        gnrl_dffl #( 
            .DATA_WIDTH(`PRF_CODE_WIDTH)
        ) arch_ren_table_dffl (i_arat_wren[i], i_arat_wr_dat[i], arch_ren_table_r[i], clk);
    end
endgenerate


assign o_arat_ret_prf_code_0 = arch_ren_table_r[i_arat_wr_dst_code_0];
assign o_arat_ret_prf_code_1 = arch_ren_table_r[i_arat_wr_dst_code_1];
assign o_arat_ret_prf_code_2 = arch_ren_table_r[i_arat_wr_dst_code_2];
assign o_arat_ret_prf_code_3 = arch_ren_table_r[i_arat_wr_dst_code_3];

//  Read
assign o_arat_flush_prf_code_0  = arch_ren_table_r[0];
assign o_arat_flush_prf_code_1  = arch_ren_table_r[1];
assign o_arat_flush_prf_code_2  = arch_ren_table_r[2];
assign o_arat_flush_prf_code_3  = arch_ren_table_r[3];
assign o_arat_flush_prf_code_4  = arch_ren_table_r[4];
assign o_arat_flush_prf_code_5  = arch_ren_table_r[5];
assign o_arat_flush_prf_code_6  = arch_ren_table_r[6];
assign o_arat_flush_prf_code_7  = arch_ren_table_r[7];
assign o_arat_flush_prf_code_8  = arch_ren_table_r[8];
assign o_arat_flush_prf_code_9  = arch_ren_table_r[9];
assign o_arat_flush_prf_code_10 = arch_ren_table_r[10];
assign o_arat_flush_prf_code_11 = arch_ren_table_r[11];
assign o_arat_flush_prf_code_12 = arch_ren_table_r[12];
assign o_arat_flush_prf_code_13 = arch_ren_table_r[13];
assign o_arat_flush_prf_code_14 = arch_ren_table_r[14];
assign o_arat_flush_prf_code_15 = arch_ren_table_r[15];
assign o_arat_flush_prf_code_16 = arch_ren_table_r[16];
assign o_arat_flush_prf_code_17 = arch_ren_table_r[17];
assign o_arat_flush_prf_code_18 = arch_ren_table_r[18];
assign o_arat_flush_prf_code_19 = arch_ren_table_r[19];
assign o_arat_flush_prf_code_20 = arch_ren_table_r[20];
assign o_arat_flush_prf_code_21 = arch_ren_table_r[21];
assign o_arat_flush_prf_code_22 = arch_ren_table_r[22];
assign o_arat_flush_prf_code_23 = arch_ren_table_r[23];
assign o_arat_flush_prf_code_24 = arch_ren_table_r[24];
assign o_arat_flush_prf_code_25 = arch_ren_table_r[25];
assign o_arat_flush_prf_code_26 = arch_ren_table_r[26];
assign o_arat_flush_prf_code_27 = arch_ren_table_r[27];
assign o_arat_flush_prf_code_28 = arch_ren_table_r[28];
assign o_arat_flush_prf_code_29 = arch_ren_table_r[29];
assign o_arat_flush_prf_code_30 = arch_ren_table_r[30];
assign o_arat_flush_prf_code_31 = arch_ren_table_r[31];

endmodule   //  dec_arat_module 


`endif  /*  !__DECODE_DEC_ARAT_V__! */