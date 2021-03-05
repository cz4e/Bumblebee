`ifdef __RSV_RSV_SRC_V__

module rsv_src_module (
    input                                   i_csr_trap_flush,
    input                                   i_exu_mis_flush,
    input                                   i_exu_ls_flush,

    input   [3                      : 0]    i_dsp_rsv_vld,
    input   [`RSV_IDX_WIDTH - 1     : 0]    i_dsp_rsv_free_entry_0,
    input   [`RSV_IDX_WIDTH - 1     : 0]    i_dsp_rsv_free_entry_1,
    input   [`RSV_IDX_WIDTH - 1     : 0]    i_dsp_rsv_free_entry_2,
    input   [`RSV_IDX_WIDTH - 1     : 0]    i_dsp_rsv_free_entry_3,
    
    input                                   i_dsp_rsv_src_vld_0,
    input   [`PRF_CODE_WIDTH - 1    : 0]    i_dsp_rsv_prf_code_0,
    input                                   i_dsp_rsv_src_vld_1,
    input   [`PRF_CODE_WIDTH - 1    : 0]    i_dsp_rsv_prf_code_1,
    input                                   i_dsp_rsv_src_vld_2,
    input   [`PRF_CODE_WIDTH - 1    : 0]    i_dsp_rsv_prf_code_2,
    input                                   i_dsp_rsv_src_vld_3,
    input   [`PRF_CODE_WIDTH - 1    : 0]    i_dsp_rsv_prf_code_3,

    input   [`RSV_ENTRY_NUMS - 1    : 0]    i_oldest_rsv_vec_0,
    input   [`RSV_ENTRY_NUMS - 1    : 0]    i_oldest_rsv_vec_1,
    input   [`RSV_ENTRY_NUMS - 1    : 0]    i_oldest_rsv_vec_2,
    input   [`RSV_ENTRY_NUMS - 1    : 0]    i_oldest_rsv_vec_3,

    input                                   i_rsv_arb_stall_0,
    input                                   i_rsv_arb_stall_1,
    input                                   i_rsv_arb_stall_2,
    input                                   i_rsv_arb_stall_3,
    
    input                                   i_exu_rsv_wb_vld_0,
    input   [`PRF_CODE_WIDTH - 1       : 0] i_exu_rsv_wb_prf_code_0,                    
    input                                   i_exu_rsv_wb_vld_1,
    input   [`PRF_CODE_WIDTH - 1       : 0] i_exu_rsv_wb_prf_code_1,                   
    input                                   i_exu_rsv_wb_vld_2,
    input   [`PRF_CODE_WIDTH - 1       : 0] i_exu_rsv_wb_prf_code_2,                    
    input                                   i_exu_rsv_wb_vld_3,
    input   [`PRF_CODE_WIDTH - 1       : 0] i_exu_rsv_wb_prf_code_3,                 
    
    output                                  o_rsv_src_vld_0,
    output  [`PRF_CODE_WIDTH - 1       : 0] o_rsv_src_prf_code_0,
    output                                  o_rsv_src_vld_1,
    output  [`PRF_CODE_WIDTH - 1       : 0] o_rsv_src_prf_code_1,
    output                                  o_rsv_src_vld_2,
    output  [`PRF_CODE_WIDTH - 1       : 0] o_rsv_src_prf_code_2,
    output                                  o_rsv_src_vld_3,
    output  [`PRF_CODE_WIDTH - 1       : 0] o_rsv_src_prf_code_3,

    output  [`RSV_ENTRY_NUMS - 1       : 0] o_rsv_src_rdy,
    
    input                                   clk,
    input                                   rst_n
);

//
wire [`RSV_ENTRY_NUMS - 1 : 0] rsv_src_rdy_r;
wire [`RSV_ENTRY_NUMS - 1 : 0] rsv_src_vld_r;
wire [`PRF_CODE_WIDTH - 1 : 0] rsv_src_prf_code_r [`RSV_ENTRY_NUMS - 1 : 0];

//
wire rsv_src_vld = (|i_dsp_rsv_vld);
wire rsv_need_flush = (i_csr_trap_flush | i_exu_ls_flush | i_exu_mis_flush);
wire rsv_arb_stall = (i_rsv_arb_stall_3
                   |  i_rsv_arb_stall_2
                   |  i_rsv_arb_stall_1
                   |  i_rsv_arb_stall_0);
wire rsv_src_wb = (i_exu_rsv_wb_vld_0
                |  i_exu_rsv_wb_vld_1
                |  i_exu_rsv_wb_vld_2
                |  i_exu_rsv_wb_vld_3);

//  Modify rsv_src_vld_r
wire [`RSV_ENTRY_NUMS - 1 : 0] rsv_src_vld_nxt;

genvar i;
generate
    for(i = 0; i < `RSV_ENTRY_NUMS; i = i + 1) begin
        assign rsv_src_vld_nxt[i] = ({1{(i == i_dsp_rsv_free_entry_0) & (~rsv_need_flush)}} & i_dsp_rsv_src_vld_0)
                                  | ({1{(i == i_dsp_rsv_free_entry_1) & (~rsv_need_flush)}} & i_dsp_rsv_src_vld_1)
                                  | ({1{(i == i_dsp_rsv_free_entry_2) & (~rsv_need_flush)}} & i_dsp_rsv_src_vld_2)
                                  | ({1{(i == i_dsp_rsv_free_entry_3) & (~rsv_need_flush)}} & i_dsp_rsv_src_vld_3);
    end    
endgenerate

wire rsv_src_vld_ena = ((rsv_src_vld & (~rsv_arb_stall)) | rsv_need_flush);
gnrl_dfflr #(
    .DATA_WIDTH   (`RSV_ENTRY_NUMS),
    .INITIAL_VALUE(0)
) rsv_src_vld_dfflr (rsv_src_vld_ena, rsv_src_vld_nxt, rsv_src_vld_r, clk, rst_n);

//  Modify rsv_src_rdy_r
wire rsv_src_rdy_0 = (i_dsp_rsv_vld[0]
                  &  ((i_dsp_rsv_src_vld_0 & (~(|i_dsp_rsv_prf_code_0)))))
                  |  (~i_dsp_rsv_src_vld_0);
wire rsv_src_rdy_1 = (i_dsp_rsv_vld[1]
                  &  ((i_dsp_rsv_src_vld_1 & (~(|i_dsp_rsv_prf_code_1)))))
                  |  (~i_dsp_rsv_src_vld_1);
wire rsv_src_rdy_2 = (i_dsp_rsv_vld[2]
                  &  ((i_dsp_rsv_src_vld_2 & (~(|i_dsp_rsv_prf_code_2)))))
                  |  (~i_dsp_rsv_src_vld_2);
wire rsv_src_rdy_3 = (i_dsp_rsv_vld[3]
                  &  ((i_dsp_rsv_src_vld_3 & (~(|i_dsp_rsv_prf_code_3)))))
                  |  (~i_dsp_rsv_src_vld_3);


wire rsv_src_rdy_ena = (rsv_src_vld_ena
                     |  rsv_src_wb);

wire [`RSV_ENTRY_NUMS - 1 : 0] rsv_src_wb_rdy_set;

genvar j;
generate
    for(j = 0; j < `RSV_ENTRY_NUMS; j = j + 1) begin
        assign rsv_src_wb_rdy_set[j] = ((i_exu_rsv_wb_prf_code_0 == rsv_src_prf_code_r[j]) & i_exu_rsv_wb_vld_0)
                                     | ((i_exu_rsv_wb_prf_code_1 == rsv_src_prf_code_r[j]) & i_exu_rsv_wb_vld_1)
                                     | ((i_exu_rsv_wb_prf_code_2 == rsv_src_prf_code_r[j]) & i_exu_rsv_wb_vld_2)
                                     | ((i_exu_rsv_wb_prf_code_3 == rsv_src_prf_code_r[j]) & i_exu_rsv_wb_vld_3);
    end
endgenerate

wire [`RSV_ENTRY_NUMS - 1 : 0] rsv_src_rdy_nxt = ({`RSV_ENTRY_NUMS{rsv_src_rdy_0 & (~rsv_need_flush)}} & func_vec64(i_dsp_rsv_free_entry_0))
                                               | ({`RSV_ENTRY_NUMS{rsv_src_rdy_1 & (~rsv_need_flush)}} & func_vec64(i_dsp_rsv_free_entry_1))
                                               | ({`RSV_ENTRY_NUMS{rsv_src_rdy_2 & (~rsv_need_flush)}} & func_vec64(i_dsp_rsv_free_entry_2))
                                               | ({`RSV_ENTRY_NUMS{rsv_src_rdy_3 & (~rsv_need_flush)}} & func_vec64(i_dsp_rsv_free_entry_3))
                                               | ({`RSV_ENTRY_NUMS{rsv_src_wb    & (~rsv_need_flush)}} & rsv_src_wb_rdy_set                )
                                               | ({`RSV_ENTRY_NUMS{(~rsv_need_flush)                }} & rsv_src_rdy_r                     ); 
                                              // | ({`RSV_ENTRY_NUMS{rsv_need_flush                   }} & rsv_src_flush_rdy                 );
gnrl_dfflr #(
    .DATA_WIDTH   (`RSV_ENTRY_NUMS),
    .INITIAL_VALUE(0)
) rsv_src_rdy_dfflr (rsv_src_rdy_ena, rsv_src_rdy_nxt, rsv_src_rdy_r, clk, rst_n);

//  Modify rsv_src_prf_code;
wire [`RSV_ENTRY_NUMS - 1 : 0] rsv_src_prf_code_ena;
wire [`PRF_CODE_WIDTH - 1 : 0] rsv_src_prf_code_nxt [`RSV_ENTRY_NUMS - 1 : 0];

genvar k;
generate
    for(k = 0; k < `RSV_ENTRY_NUMS; k = k + 1) begin
        assign rsv_src_prf_code_ena[k] = (((k == i_dsp_rsv_free_entry_0) & i_dsp_rsv_vld[0])
                                       |  ((k == i_dsp_rsv_free_entry_1) & i_dsp_rsv_vld[1])
                                       |  ((k == i_dsp_rsv_free_entry_2) & i_dsp_rsv_vld[2])
                                       |  ((k == i_dsp_rsv_free_entry_3) & i_dsp_rsv_vld[3])) & (~rsv_need_flush);
        assign rsv_src_prf_code_nxt[k] = ({`PRF_CODE_WIDTH{(k == i_dsp_rsv_free_entry_0)}} & i_dsp_rsv_prf_code_0)
                                       | ({`PRF_CODE_WIDTH{(k == i_dsp_rsv_free_entry_1)}} & i_dsp_rsv_prf_code_1)
                                       | ({`PRF_CODE_WIDTH{(k == i_dsp_rsv_free_entry_2)}} & i_dsp_rsv_prf_code_2)
                                       | ({`PRF_CODE_WIDTH{(k == i_dsp_rsv_free_entry_3)}} & i_dsp_rsv_prf_code_3);
        gnrl_dfflr #(
            .DATA_WIDTH   (`PRF_CODE_WIDTH),
            .INITIAL_VALUE(0)
        ) rsv_src_prf_code_dfflr (rsv_src_prf_code_ena[k], rsv_src_prf_code_nxt[k], rsv_src_prf_code_r[k], clk, rst_n);
    end
endgenerate

//  Issue info
wire [`RSV_IDX_WIDTH - 1 : 0] rsv_sel_idx_0 = func_vec64r(i_oldest_rsv_vec_0);
assign {
            o_rsv_src_vld_0
        ,   o_rsv_src_prf_code_0
} = {
            rsv_src_vld_r[rsv_sel_idx_0]
        ,   rsv_src_prf_code_r[rsv_sel_idx_0]
};

//
wire [`RSV_IDX_WIDTH - 1 : 0] rsv_sel_idx_1 = func_vec64r(i_oldest_rsv_vec_1);
assign {
            o_rsv_src_vld_1
        ,   o_rsv_src_prf_code_1
} = {
            rsv_src_vld_r[rsv_sel_idx_1]
        ,   rsv_src_prf_code_r[rsv_sel_idx_1]
};

//
wire [`RSV_IDX_WIDTH - 1 : 0] rsv_sel_idx_2 = func_vec64r(i_oldest_rsv_vec_2);
assign {
            o_rsv_src_vld_2
        ,   o_rsv_src_prf_code_2
} = {
            rsv_src_vld_r[rsv_sel_idx_2]
        ,   rsv_src_prf_code_r[rsv_sel_idx_2]
};

//
wire [`RSV_IDX_WIDTH - 1 : 0] rsv_sel_idx_3 = func_vec64r(i_oldest_rsv_vec_3);
assign {
            o_rsv_src_vld_3
        ,   o_rsv_src_prf_code_3
} = {
            rsv_src_vld_r[rsv_sel_idx_3]
        ,   rsv_src_prf_code_r[rsv_sel_idx_3]
};

//
assign o_rsv_src_rdy = rsv_src_rdy_r;

//  Functions
function [63 : 0] func_vec64;
    input [5 : 0] i_index;

    case (i_index)
        6'b000000: func_vec64 = 64'd1;                         // 0
        6'b000001: func_vec64 = 64'd2;                         // 1
        6'b000010: func_vec64 = 64'd4;                         // 2
        6'b000011: func_vec64 = 64'd8;                         // 3
        6'b000100: func_vec64 = 64'd16;                        // 4
        6'b000101: func_vec64 = 64'd32;                        // 5
        6'b000110: func_vec64 = 64'd64;                        // 6
        6'b000111: func_vec64 = 64'd128;                       // 7
        6'b001000: func_vec64 = 64'd256;                       // 8
        6'b001001: func_vec64 = 64'd512;                       // 9
        6'b001010: func_vec64 = 64'd1024;                      // 10
        6'b001011: func_vec64 = 64'd2048;                      // 11
        6'b001100: func_vec64 = 64'd4096;                      // 12
        6'b001101: func_vec64 = 64'd8192;                      // 13
        6'b001110: func_vec64 = 64'd16384;                     // 14
        6'b001111: func_vec64 = 64'd32768;                     // 15
        6'b010000: func_vec64 = 64'd65536;                     // 16
        6'b010001: func_vec64 = 64'd131072;                    // 17
        6'b010010: func_vec64 = 64'd262144;                    // 18
        6'b010011: func_vec64 = 64'd524288;                    // 19
        6'b010100: func_vec64 = 64'd1048576;                   // 20
        6'b010101: func_vec64 = 64'd2097152;                   // 21
        6'b010110: func_vec64 = 64'd4194304;                   // 22
        6'b010111: func_vec64 = 64'd8388608;                   // 23
        6'b011000: func_vec64 = 64'd16777216;                  // 24
        6'b011001: func_vec64 = 64'd33554432;                  // 25
        6'b011010: func_vec64 = 64'd67108864;                  // 26
        6'b011011: func_vec64 = 64'd134217728;                 // 27
        6'b011100: func_vec64 = 64'd268435456;                 // 28
        6'b011101: func_vec64 = 64'd536870912;                 // 29
        6'b011110: func_vec64 = 64'd1073741824;                // 30
        6'b011111: func_vec64 = 64'd2147483648;                // 31
        6'b100000: func_vec64 = 64'd4294967296;                // 32
        6'b100001: func_vec64 = 64'd8589934592;                // 33
        6'b100010: func_vec64 = 64'd17179869184;               // 34
        6'b100011: func_vec64 = 64'd34359738368;               // 35
        6'b100100: func_vec64 = 64'd68719476736;               // 36
        6'b100101: func_vec64 = 64'd137438953472;              // 37
        6'b100110: func_vec64 = 64'd274877906944;              // 38
        6'b100111: func_vec64 = 64'd549755813888;              // 39
        6'b101000: func_vec64 = 64'd1099511627776;             // 40
        6'b101001: func_vec64 = 64'd2199023255552;             // 41
        6'b101010: func_vec64 = 64'd4398046511104;             // 42
        6'b101011: func_vec64 = 64'd8796093022208;             // 43
        6'b101100: func_vec64 = 64'd17592186044416;            // 44
        6'b101101: func_vec64 = 64'd35184372088832;            // 45
        6'b101110: func_vec64 = 64'd70368744177664;            // 46
        6'b101111: func_vec64 = 64'd140737488355328;           // 47
        6'b110000: func_vec64 = 64'd281474976710656;           // 48
        6'b110001: func_vec64 = 64'd562949953421312;           // 49
        6'b110010: func_vec64 = 64'd1125899906842624;          // 50
        6'b110011: func_vec64 = 64'd2251799813685248;          // 51
        6'b110100: func_vec64 = 64'd4503599627370496;          // 52
        6'b110101: func_vec64 = 64'd9007199254740992;          // 53
        6'b110110: func_vec64 = 64'd18014398509481984;         // 54
        6'b110111: func_vec64 = 64'd36028797018963968;         // 55
        6'b111000: func_vec64 = 64'd72057594037927936;         // 56
        6'b111001: func_vec64 = 64'd144115188075855872;        // 57
        6'b111010: func_vec64 = 64'd288230376151711744;        // 58
        6'b111011: func_vec64 = 64'd576460752303423488;        // 59
        6'b111100: func_vec64 = 64'd1152921504606846976;       // 60
        6'b111101: func_vec64 = 64'd2305843009213693952;       // 61
        6'b111110: func_vec64 = 64'd4611686018427387904;       // 62
        6'b111111: func_vec64 = 64'd9223372036854775808;       // 63
        default: begin
            func_vec64 = 64'd0;                                // 64
        end
    endcase
endfunction

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
        default: func_vec64r = 6'd0;
    endcase

endfunction

function [5 : 0] func_sel_1;
    input [63 : 0] bit_map;
    
    case (bit_map)
        64'bxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxx1 : func_sel_1 = 6'b000000;
        64'bxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxx10 : func_sel_1 = 6'b000001;
        64'bxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxx100 : func_sel_1 = 6'b000010;
        64'bxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxx1000 : func_sel_1 = 6'b000011;
        64'bxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxx10000 : func_sel_1 = 6'b000100;
        64'bxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxx100000 : func_sel_1 = 6'b000101;
        64'bxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxx1000000 : func_sel_1 = 6'b000110;
        64'bxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxx10000000 : func_sel_1 = 6'b000111;
        64'bxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxx100000000 : func_sel_1 = 6'b001000;
        64'bxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxx1000000000 : func_sel_1 = 6'b001001;
        64'bxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxx10000000000 : func_sel_1 = 6'b001010;
        64'bxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxx100000000000 : func_sel_1 = 6'b001011;
        64'bxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxx1000000000000 : func_sel_1 = 6'b001100;
        64'bxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxx10000000000000 : func_sel_1 = 6'b001101;
        64'bxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxx100000000000000 : func_sel_1 = 6'b001110;
        64'bxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxx1000000000000000 : func_sel_1 = 6'b001111;
        64'bxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxx10000000000000000 : func_sel_1 = 6'b010000;
        64'bxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxx100000000000000000 : func_sel_1 = 6'b010001;
        64'bxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxx1000000000000000000 : func_sel_1 = 6'b010010;
        64'bxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxx10000000000000000000 : func_sel_1 = 6'b010011;
        64'bxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxx100000000000000000000 : func_sel_1 = 6'b010100;
        64'bxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxx1000000000000000000000 : func_sel_1 = 6'b010101;
        64'bxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxx10000000000000000000000 : func_sel_1 = 6'b010110;
        64'bxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxx100000000000000000000000 : func_sel_1 = 6'b010111;
        64'bxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxx1000000000000000000000000 : func_sel_1 = 6'b011000;
        64'bxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxx10000000000000000000000000 : func_sel_1 = 6'b011001;
        64'bxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxx100000000000000000000000000 : func_sel_1 = 6'b011010;
        64'bxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxx1000000000000000000000000000 : func_sel_1 = 6'b011011;
        64'bxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxx10000000000000000000000000000 : func_sel_1 = 6'b011100;
        64'bxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxx100000000000000000000000000000 : func_sel_1 = 6'b011101;
        64'bxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxx1000000000000000000000000000000 : func_sel_1 = 6'b011110;
        64'bxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxx10000000000000000000000000000000 : func_sel_1 = 6'b011111;
        64'bxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxx100000000000000000000000000000000 : func_sel_1 = 6'b100000;
        64'bxxxxxxxxxxxxxxxxxxxxxxxxxxxxxx1000000000000000000000000000000000 : func_sel_1 = 6'b100001;
        64'bxxxxxxxxxxxxxxxxxxxxxxxxxxxxx10000000000000000000000000000000000 : func_sel_1 = 6'b100010;
        64'bxxxxxxxxxxxxxxxxxxxxxxxxxxxx100000000000000000000000000000000000 : func_sel_1 = 6'b100011;
        64'bxxxxxxxxxxxxxxxxxxxxxxxxxxx1000000000000000000000000000000000000 : func_sel_1 = 6'b100100;
        64'bxxxxxxxxxxxxxxxxxxxxxxxxxx10000000000000000000000000000000000000 : func_sel_1 = 6'b100101;
        64'bxxxxxxxxxxxxxxxxxxxxxxxxx100000000000000000000000000000000000000 : func_sel_1 = 6'b100110;
        64'bxxxxxxxxxxxxxxxxxxxxxxxx1000000000000000000000000000000000000000 : func_sel_1 = 6'b100111;
        64'bxxxxxxxxxxxxxxxxxxxxxxx10000000000000000000000000000000000000000 : func_sel_1 = 6'b101000;
        64'bxxxxxxxxxxxxxxxxxxxxxx100000000000000000000000000000000000000000 : func_sel_1 = 6'b101001;
        64'bxxxxxxxxxxxxxxxxxxxxx1000000000000000000000000000000000000000000 : func_sel_1 = 6'b101010;
        64'bxxxxxxxxxxxxxxxxxxxx10000000000000000000000000000000000000000000 : func_sel_1 = 6'b101011;
        64'bxxxxxxxxxxxxxxxxxxx100000000000000000000000000000000000000000000 : func_sel_1 = 6'b101100;
        64'bxxxxxxxxxxxxxxxxxx1000000000000000000000000000000000000000000000 : func_sel_1 = 6'b101101;
        64'bxxxxxxxxxxxxxxxxx10000000000000000000000000000000000000000000000 : func_sel_1 = 6'b101110;
        64'bxxxxxxxxxxxxxxxx100000000000000000000000000000000000000000000000 : func_sel_1 = 6'b101111;
        64'bxxxxxxxxxxxxxxx1000000000000000000000000000000000000000000000000 : func_sel_1 = 6'b110000;
        64'bxxxxxxxxxxxxxx10000000000000000000000000000000000000000000000000 : func_sel_1 = 6'b110001;
        64'bxxxxxxxxxxxxx100000000000000000000000000000000000000000000000000 : func_sel_1 = 6'b110010;
        64'bxxxxxxxxxxxx1000000000000000000000000000000000000000000000000000 : func_sel_1 = 6'b110011;
        64'bxxxxxxxxxxx10000000000000000000000000000000000000000000000000000 : func_sel_1 = 6'b110100;
        64'bxxxxxxxxxx100000000000000000000000000000000000000000000000000000 : func_sel_1 = 6'b110101;
        64'bxxxxxxxxx1000000000000000000000000000000000000000000000000000000 : func_sel_1 = 6'b110110;
        64'bxxxxxxxx10000000000000000000000000000000000000000000000000000000 : func_sel_1 = 6'b110111;
        64'bxxxxxxx100000000000000000000000000000000000000000000000000000000 : func_sel_1 = 6'b111000;
        64'bxxxxxx1000000000000000000000000000000000000000000000000000000000 : func_sel_1 = 6'b111001;
        64'bxxxxx10000000000000000000000000000000000000000000000000000000000 : func_sel_1 = 6'b111010;
        64'bxxxx100000000000000000000000000000000000000000000000000000000000 : func_sel_1 = 6'b111011;
        64'bxxx1000000000000000000000000000000000000000000000000000000000000 : func_sel_1 = 6'b111100;
        64'bxx10000000000000000000000000000000000000000000000000000000000000 : func_sel_1 = 6'b111101;
        64'bx100000000000000000000000000000000000000000000000000000000000000 : func_sel_1 = 6'b111110;
        64'b1000000000000000000000000000000000000000000000000000000000000000 : func_sel_1 = 6'b111111;
    endcase

endfunction

endmodule   //  rsv_src_module

`endif  /*  !__RSV_RSV_SRC_V__! */