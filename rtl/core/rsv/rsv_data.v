`ifdef __RSV_RSV_DATA_V__

module rsv_data_module (
    input                                           i_csr_trap_flush,
    input                                           i_exu_mis_flush,
    input                                           i_exu_ls_flush,
    
    input   [3                          : 0]        i_dsp_rsv_vld,
    input   [`RSV_IDX_WIDTH - 1         : 0]        i_dsp_rsv_free_entry_0,
    input   [`RSV_IDX_WIDTH - 1         : 0]        i_dsp_rsv_free_entry_1,
    input   [`RSV_IDX_WIDTH - 1         : 0]        i_dsp_rsv_free_entry_2,
    input   [`RSV_IDX_WIDTH - 1         : 0]        i_dsp_rsv_free_entry_3,
    input   [`ROB_ID_WIDTH  - 1         : 0]        i_dsp_rsv_rob_id_0,
    input                                           i_dsp_rsv_ld_vld_0,
    input   [`LOAD_BUFFER_ID_WIDTH - 1  : 0]        i_dsp_rsv_ld_id_0,
    input                                           i_dsp_rsv_st_vld_0,
    input   [`STORE_BUFFER_ID_WIDTH - 1 : 0]        i_dsp_rsv_st_id_0,
    input   [`DECINFO_WIDTH - 1         : 0]        i_dsp_rsv_decinfo_bus_0,
    input   [`PREDINFO_WIDTH - 1        : 0]        i_dsp_rsv_predinfo_bus_0,
    input   [`IMM_WIDTH - 1             : 0]        i_dsp_rsv_imm_0,
    input   [`ROB_ID_WIDTH  - 1         : 0]        i_dsp_rsv_rob_id_1,
    input                                           i_dsp_rsv_ld_vld_1,
    input   [`LOAD_BUFFER_ID_WIDTH - 1  : 0]        i_dsp_rsv_ld_id_1,
    input                                           i_dsp_rsv_st_vld_1,
    input   [`STORE_BUFFER_ID_WIDTH - 1 : 0]        i_dsp_rsv_st_id_1,
    input   [`DECINFO_WIDTH - 1         : 0]        i_dsp_rsv_decinfo_bus_1,
    input   [`PREDINFO_WIDTH - 1        : 0]        i_dsp_rsv_predinfo_bus_1,
    input   [`IMM_WIDTH - 1             : 0]        i_dsp_rsv_imm_1,
    input   [`ROB_ID_WIDTH  - 1         : 0]        i_dsp_rsv_rob_id_2,
    input                                           i_dsp_rsv_ld_vld_2,
    input   [`LOAD_BUFFER_ID_WIDTH - 1  : 0]        i_dsp_rsv_ld_id_2,
    input                                           i_dsp_rsv_st_vld_2,
    input   [`STORE_BUFFER_ID_WIDTH - 1 : 0]        i_dsp_rsv_st_id_2,
    input   [`DECINFO_WIDTH - 1         : 0]        i_dsp_rsv_decinfo_bus_2,
    input   [`PREDINFO_WIDTH - 1        : 0]        i_dsp_rsv_predinfo_bus_2,
    input   [`IMM_WIDTH - 1             : 0]        i_dsp_rsv_imm_2,
    input   [`ROB_ID_WIDTH  - 1         : 0]        i_dsp_rsv_rob_id_3,
    input                                           i_dsp_rsv_ld_vld_3,
    input   [`LOAD_BUFFER_ID_WIDTH - 1  : 0]        i_dsp_rsv_ld_id_3,
    input                                           i_dsp_rsv_st_vld_3,
    input   [`STORE_BUFFER_ID_WIDTH - 1 : 0]        i_dsp_rsv_st_id_3,
    input   [`DECINFO_WIDTH - 1         : 0]        i_dsp_rsv_decinfo_bus_3,
    input   [`PREDINFO_WIDTH - 1        : 0]        i_dsp_rsv_predinfo_bus_3,
    input   [`IMM_WIDTH - 1             : 0]        i_dsp_rsv_imm_3,
    input                                           i_dsp_rsv_dst_vld_0,
    input                                           i_dsp_rsv_dst_vld_1,
    input                                           i_dsp_rsv_dst_vld_2,
    input                                           i_dsp_rsv_dst_vld_3,
    input   [`PRF_CODE_WIDTH - 1        : 0]        i_dsp_rsv_dst_prf_code_0,
    input   [`PRF_CODE_WIDTH - 1        : 0]        i_dsp_rsv_dst_prf_code_1,
    input   [`PRF_CODE_WIDTH - 1        : 0]        i_dsp_rsv_dst_prf_code_2,
    input   [`PRF_CODE_WIDTH - 1        : 0]        i_dsp_rsv_dst_prf_code_3,
    input   [`EXCEPTION_CODE_WIDTH - 1  : 0]        i_dsp_rsv_excp_code_0,
    input   [`EXCEPTION_CODE_WIDTH - 1  : 0]        i_dsp_rsv_excp_code_1,
    input   [`EXCEPTION_CODE_WIDTH - 1  : 0]        i_dsp_rsv_excp_code_2,
    input   [`EXCEPTION_CODE_WIDTH - 1  : 0]        i_dsp_rsv_excp_code_3,
    input   [3                          : 0]        i_dsp_rsv_len,
    
    input   [63                         : 0]        i_oldest_rsv_vec_0,
    input   [63                         : 0]        i_oldest_rsv_vec_1,
    input   [63                         : 0]        i_oldest_rsv_vec_2,
    input   [63                         : 0]        i_oldest_rsv_vec_3,

    output  [`ROB_ID_WIDTH - 1          : 0]        o_rsv_rob_id_0,
    output  [`EXCEPTION_CODE_WIDTH - 1  : 0]        o_rsv_excp_code_0,
    output  [`DECINFO_WIDTH - 1         : 0]        o_rsv_decinfo_bus_0,
    output  [`IMM_WIDTH - 1             : 0]        o_rsv_imm_0,
	output                                          o_rsv_dst_vld_0,
	output  [`PRF_CODE_WIDTH - 1        : 0]        o_rsv_prf_code_0,
    output  [`ROB_ID_WIDTH - 1          : 0]        o_rsv_rob_id_1,
    output  [`EXCEPTION_CODE_WIDTH - 1  : 0]        o_rsv_excp_code_1,
    output  [`DECINFO_WIDTH - 1         : 0]        o_rsv_decinfo_bus_1,
	output  [`PREDINFO_WIDTH - 1        : 0]        o_rsv_predinfo_bus_1,
    output  [`IMM_WIDTH - 1             : 0]        o_rsv_imm_1,
	output                                          o_rsv_dst_vld_1,
	output  [`PRF_CODE_WIDTH - 1        : 0]        o_rsv_prf_code_1,
    output  [`ROB_ID_WIDTH - 1          : 0]        o_rsv_rob_id_2,
    output  [`EXCEPTION_CODE_WIDTH - 1  : 0]        o_rsv_excp_code_2,
    output  [`DECINFO_WIDTH - 1         : 0]        o_rsv_decinfo_bus_2,
    output  [`IMM_WIDTH - 1             : 0]        o_rsv_imm_2,
	output                                          o_rsv_dst_vld_2,
	output  [`PRF_CODE_WIDTH - 1        : 0]        o_rsv_prf_code_2,
    output  [`ROB_ID_WIDTH - 1          : 0]        o_rsv_rob_id_3,
    output                                          o_rsv_ld_vld_3,
    output  [`LOAD_BUFFER_ID_WIDTH - 1  : 0]        o_rsv_ld_id_3,
    output                                          o_rsv_st_vld_3,
    output  [`STORE_BUFFER_ID_WIDTH - 1 : 0]        o_rsv_st_id_3,
    output  [`EXCEPTION_CODE_WIDTH - 1  : 0]        o_rsv_excp_code_3,
    output  [`DECINFO_WIDTH - 1         : 0]        o_rsv_decinfo_bus_3,
    output  [`IMM_WIDTH - 1             : 0]        o_rsv_imm_3,
    output                                          o_rsv_dst_vld_3,
    output  [`PRF_CODE_WIDTH - 1        : 0]        o_rsv_prf_code_3,
    output  [3                          : 0]        o_rsv_len,
    
    input                                           clk,
    input                                           rst_n
);

//
wire rsv_need_flush = (i_csr_trap_flush | i_exu_mis_flush | i_exu_ls_flush);

//
wire [`RSV_DATA_WIDTH - 1 : 0] rsv_data_r [63 : 0];

//  
wire [`RSV_DATA_WIDTH - 1 : 0] rsv_wdat_0 = {
                                                i_dsp_rsv_rob_id_0
                                            ,   i_dsp_rsv_ld_vld_0
                                            ,   i_dsp_rsv_ld_id_0
                                            ,   i_dsp_rsv_st_vld_0
                                            ,   i_dsp_rsv_st_id_0
                                            ,   i_dsp_rsv_decinfo_bus_0
                                            ,   i_dsp_rsv_predinfo_bus_0
                                            ,   i_dsp_rsv_dst_vld_0
                                            ,   i_dsp_rsv_dst_prf_code_0
                                            ,   i_dsp_rsv_len[0]
                                            ,   i_dsp_rsv_imm_0
                                            ,   i_dsp_rsv_excp_code_0
                                            };

wire [`RSV_DATA_WIDTH - 1 : 0] rsv_wdat_1 = {
                                                i_dsp_rsv_rob_id_1
                                            ,   i_dsp_rsv_ld_vld_1
                                            ,   i_dsp_rsv_ld_id_1
                                            ,   i_dsp_rsv_st_vld_1
                                            ,   i_dsp_rsv_st_id_1
                                            ,   i_dsp_rsv_decinfo_bus_1
                                            ,   i_dsp_rsv_predinfo_bus_1
                                            ,   i_dsp_rsv_dst_vld_1
                                            ,   i_dsp_rsv_dst_prf_code_1
                                            ,   i_dsp_rsv_len[1]
                                            ,   i_dsp_rsv_imm_1
                                            ,   i_dsp_rsv_excp_code_1
                                            };

wire [`RSV_DATA_WIDTH - 1 : 0] rsv_wdat_2 = {
                                                i_dsp_rsv_rob_id_2
                                            ,   i_dsp_rsv_ld_vld_2
                                            ,   i_dsp_rsv_ld_id_2
                                            ,   i_dsp_rsv_st_vld_2
                                            ,   i_dsp_rsv_st_id_2
                                            ,   i_dsp_rsv_decinfo_bus_2
                                            ,   i_dsp_rsv_predinfo_bus_2
                                            ,   i_dsp_rsv_dst_vld_2
                                            ,   i_dsp_rsv_dst_prf_code_2
                                            ,   i_dsp_rsv_len[2]
                                            ,   i_dsp_rsv_imm_2
                                            ,   i_dsp_rsv_excp_code_2
                                            };

wire [`RSV_DATA_WIDTH - 1 : 0] rsv_wdat_3 = {
                                                i_dsp_rsv_rob_id_3
                                            ,   i_dsp_rsv_ld_vld_3
                                            ,   i_dsp_rsv_ld_id_3
                                            ,   i_dsp_rsv_st_vld_3
                                            ,   i_dsp_rsv_st_id_3
                                            ,   i_dsp_rsv_decinfo_bus_3
                                            ,   i_dsp_rsv_predinfo_bus_3
                                            ,   i_dsp_rsv_dst_vld_3
                                            ,   i_dsp_rsv_dst_prf_code_3
                                            ,   i_dsp_rsv_len[3]
                                            ,   i_dsp_rsv_imm_3
                                            ,   i_dsp_rsv_excp_code_3
                                            };

wire [63 : 0] rsv_data_ena;
wire [`RSV_DATA_WIDTH - 1 : 0] rsv_data_nxt [63 : 0];

genvar i;
generate
    for(i = 0; i < 64; i = i + 1) begin
        assign rsv_data_ena[i] = (((i == i_dsp_rsv_free_entry_0) & i_dsp_rsv_vld[0])
                               |  ((i == i_dsp_rsv_free_entry_1) & i_dsp_rsv_vld[1])
                               |  ((i == i_dsp_rsv_free_entry_2) & i_dsp_rsv_vld[2])
                               |  ((i == i_dsp_rsv_free_entry_3) & i_dsp_rsv_vld[3])) & (~rsv_need_flush);
        assign rsv_data_nxt[i] = ({`RSV_DATA_WIDTH{(i == i_dsp_rsv_free_entry_0)}} & rsv_wdat_0)
                               | ({`RSV_DATA_WIDTH{(i == i_dsp_rsv_free_entry_1)}} & rsv_wdat_1)
                               | ({`RSV_DATA_WIDTH{(i == i_dsp_rsv_free_entry_2)}} & rsv_wdat_2)
                               | ({`RSV_DATA_WIDTH{(i == i_dsp_rsv_free_entry_3)}} & rsv_wdat_3);
        gnrl_dffl #(
            .DATA_WIDTH(`RSV_DATA_WIDTH)
        ) rsv_data_dffl (rsv_data_ena[i], rsv_data_nxt[i], rsv_data_r[i], clk);
    end
endgenerate

//
wire o_rsv_ld_vld_0;
wire [`LOAD_BUFFER_ID_WIDTH - 1 : 0] o_rsv_ld_id_0;
wire o_rsv_st_vld_0;
wire [`STORE_BUFFER_ID_WIDTH - 1 : 0] o_rsv_st_id_0;
wire [`PREDINFO_WIDTH - 1 : 0] o_rsv_predinfo_bus_0;

assign {
            o_rsv_rob_id_0
        ,   o_rsv_ld_vld_0
        ,   o_rsv_ld_id_0
        ,   o_rsv_st_vld_0
        ,   o_rsv_st_id_0
        ,   o_rsv_decinfo_bus_0
        ,   o_rsv_predinfo_bus_0
        ,   o_rsv_dst_vld_0
        ,   o_rsv_prf_code_0
        ,   o_rsv_len[0]
        ,   o_rsv_imm_0
        ,   o_rsv_excp_code_0
} = rsv_data_r[func_vec64r(i_oldest_rsv_vec_0)];

//
wire o_rsv_ld_vld_1;
wire [`LOAD_BUFFER_ID_WIDTH - 1 : 0] o_rsv_ld_id_1;
wire o_rsv_st_vld_1;
wire [`STORE_BUFFER_ID_WIDTH - 1 : 0] o_rsv_st_id_1;

assign {
            o_rsv_rob_id_1
        ,   o_rsv_ld_vld_1
        ,   o_rsv_ld_id_1
        ,   o_rsv_st_vld_1
        ,   o_rsv_st_id_1
        ,   o_rsv_decinfo_bus_1
        ,   o_rsv_predinfo_bus_1
        ,   o_rsv_dst_vld_1
        ,   o_rsv_prf_code_1
        ,   o_rsv_len[1]
        ,   o_rsv_imm_1
        ,   o_rsv_excp_code_1
} = rsv_data_r[func_vec64r(i_oldest_rsv_vec_1)];

//
wire o_rsv_ld_vld_2;
wire [`LOAD_BUFFER_ID_WIDTH - 1 : 0] o_rsv_ld_id_2;
wire o_rsv_st_vld_2;
wire [`STORE_BUFFER_ID_WIDTH - 1 : 0] o_rsv_st_id_2;
wire [`PREDINFO_WIDTH - 1 : 0] o_rsv_predinfo_bus_2;

assign {
            o_rsv_rob_id_2
        ,   o_rsv_ld_vld_2
        ,   o_rsv_ld_id_2
        ,   o_rsv_st_vld_2
        ,   o_rsv_st_id_2
        ,   o_rsv_decinfo_bus_2
        ,   o_rsv_predinfo_bus_2
        ,   o_rsv_dst_vld_2
        ,   o_rsv_prf_code_2
        ,   o_rsv_len[2]
        ,   o_rsv_imm_2
        ,   o_rsv_excp_code_2
} = rsv_data_r[func_vec64r(i_oldest_rsv_vec_2)];
//
wire [`PREDINFO_WIDTH - 1 : 0] o_rsv_predinfo_bus_3;

assign {
            o_rsv_rob_id_3
        ,   o_rsv_ld_vld_3
        ,   o_rsv_ld_id_3
        ,   o_rsv_st_vld_3
        ,   o_rsv_st_id_3
        ,   o_rsv_decinfo_bus_3
        ,   o_rsv_predinfo_bus_3
        ,   o_rsv_dst_vld_3
        ,   o_rsv_prf_code_3
        ,   o_rsv_len[3]
        ,   o_rsv_imm_3
        ,   o_rsv_excp_code_3
} = rsv_data_r[func_vec64r(i_oldest_rsv_vec_3)];

//  Functions
function [5 : 0] func_vec64r;
    input [63 : 0] i_index;
    
    case(i_index)
        64'd1                   : func_vec64r = 6'b000000;
        64'd2                   : func_vec64r = 6'b000001;
        64'd4                   : func_vec64r = 6'b000010;
        64'd8                   : func_vec64r = 6'b000011;
        64'd16                  : func_vec64r = 6'b000100;
        64'd32                  : func_vec64r = 6'b000101;
        64'd64                  : func_vec64r = 6'b000110;
        64'd128                 : func_vec64r = 6'b000111;
        64'd256                 : func_vec64r = 6'b001000;
        64'd512                 : func_vec64r = 6'b001001;
        64'd1024                : func_vec64r = 6'b001010;
        64'd2048                : func_vec64r = 6'b001011;
        64'd4096                : func_vec64r = 6'b001100;
        64'd8192                : func_vec64r = 6'b001101;
        64'd16384               : func_vec64r = 6'b001110;
        64'd32768               : func_vec64r = 6'b001111;
        64'd65536               : func_vec64r = 6'b010000;
        64'd131072              : func_vec64r = 6'b010001;
        64'd262144              : func_vec64r = 6'b010010;
        64'd524288              : func_vec64r = 6'b010011;
        64'd1048576             : func_vec64r = 6'b010100;
        64'd2097152             : func_vec64r = 6'b010101;
        64'd4194304             : func_vec64r = 6'b010110;
        64'd8388608             : func_vec64r = 6'b010111;
        64'd16777216            : func_vec64r = 6'b011000;
        64'd33554432            : func_vec64r = 6'b011001;
        64'd67108864            : func_vec64r = 6'b011010;
        64'd134217728           : func_vec64r = 6'b011011;
        64'd268435456           : func_vec64r = 6'b011100;
        64'd536870912           : func_vec64r = 6'b011101;
        64'd1073741824          : func_vec64r = 6'b011110;
        64'd2147483648          : func_vec64r = 6'b011111;
        64'd4294967296          : func_vec64r = 6'b100000;
        64'd8589934592          : func_vec64r = 6'b100001;
        64'd17179869184         : func_vec64r = 6'b100010;
        64'd34359738368         : func_vec64r = 6'b100011;
        64'd68719476736         : func_vec64r = 6'b100100;
        64'd137438953472        : func_vec64r = 6'b100101;
        64'd274877906944        : func_vec64r = 6'b100110;
        64'd549755813888        : func_vec64r = 6'b100111;
        64'd1099511627776       : func_vec64r = 6'b101000;
        64'd2199023255552       : func_vec64r = 6'b101001;
        64'd4398046511104       : func_vec64r = 6'b101010;
        64'd8796093022208       : func_vec64r = 6'b101011;
        64'd17592186044416      : func_vec64r = 6'b101100;
        64'd35184372088832      : func_vec64r = 6'b101101;
        64'd70368744177664      : func_vec64r = 6'b101110;
        64'd140737488355328     : func_vec64r = 6'b101111;
        64'd281474976710656     : func_vec64r = 6'b110000;
        64'd562949953421312     : func_vec64r = 6'b110001;
        64'd1125899906842624    : func_vec64r = 6'b110010;
        64'd2251799813685248    : func_vec64r = 6'b110011;
        64'd4503599627370496    : func_vec64r = 6'b110100;
        64'd9007199254740992    : func_vec64r = 6'b110101;
        64'd18014398509481984   : func_vec64r = 6'b110110;
        64'd36028797018963968   : func_vec64r = 6'b110111;
        64'd72057594037927936   : func_vec64r = 6'b111000;
        64'd144115188075855872  : func_vec64r = 6'b111001;
        64'd288230376151711744  : func_vec64r = 6'b111010;
        64'd576460752303423488  : func_vec64r = 6'b111011;
        64'd1152921504606846976 : func_vec64r = 6'b111100;
        64'd2305843009213693952 : func_vec64r = 6'b111101;
        64'd4611686018427387904 : func_vec64r = 6'b111110;
        64'd9223372036854775808 : func_vec64r = 6'b111111;
    endcase

endfunction

endmodule   //  rsv_data_module

`endif  /*  !__RSV_RSV_DATA_V__!    */