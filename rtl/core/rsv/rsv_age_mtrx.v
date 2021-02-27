`ifdef __RSV_AGE_MTRX_V__

module rsv_age_mtrx_module (
    input                                       i_csr_trap_flush,
    input                                       i_exu_mis_flush,
    input                                       i_exu_ls_flush,
    input   [3                      : 0]        i_dsp_rsv_vld,
    input   [`RSV_IDX_WIDTH - 1     : 0]        i_dsp_rsv_free_entry_0,
    input   [`RSV_IDX_WIDTH - 1     : 0]        i_dsp_rsv_free_entry_1,
    input   [`RSV_IDX_WIDTH - 1     : 0]        i_dsp_rsv_free_entry_2,
    input   [`RSV_IDX_WIDTH - 1     : 0]        i_dsp_rsv_free_entry_3,
    input   [`RSV_ENTRY_NUMS - 1    : 0]        i_rsv_entry_vld_vec,
    output  [`RSV_ENTRY_NUMS - 1    : 0]        o_oldest_rsv_vec,

    input                                       clk,
    input                                       rst_n
);

wire rsv_age_mtrx_need_flush = (i_csr_trap_flush | i_exu_mis_flush | i_exu_ls_flush);

//
wire [`RSV_ENTRY_NUMS - 1 : 0] rsv_age_mtrx_r [`RSV_ENTRY_NUMS - 1 : 0];


wire [`RSV_ENTRY_NUMS - 1 : 0] rsv_age_mtrx_entry_onehot_0 = func_vec64(i_dsp_rsv_free_entry_0);
wire [`RSV_ENTRY_NUMS - 1 : 0] rsv_age_mtrx_entry_onehot_1 = func_vec64(i_dsp_rsv_free_entry_1);
wire [`RSV_ENTRY_NUMS - 1 : 0] rsv_age_mtrx_entry_onehot_2 = func_vec64(i_dsp_rsv_free_entry_2);


wire [`RSV_ENTRY_NUMS - 1 : 0] rsv_age_mtrx_entry_dat_0 = (i_rsv_entry_vld_vec);
wire [`RSV_ENTRY_NUMS - 1 : 0] rsv_age_mtrx_entry_dat_1 = (i_rsv_entry_vld_vec | rsv_age_mtrx_entry_onehot_0);
wire [`RSV_ENTRY_NUMS - 1 : 0] rsv_age_mtrx_entry_dat_2 = (i_rsv_entry_vld_vec 
                                                        | rsv_age_mtrx_entry_onehot_0 
                                                        | rsv_age_mtrx_entry_onehot_1);
wire [`RSV_ENTRY_NUMS - 1 : 0] rsv_age_mtrx_entry_dat_3 = (i_rsv_entry_vld_vec
                                                        | rsv_age_mtrx_entry_onehot_0
                                                        | rsv_age_mtrx_entry_onehot_1
                                                        | rsv_age_mtrx_entry_onehot_2);

//  Age Matrix
wire [`RSV_ENTRY_NUMS - 1 : 0] rsv_age_mtrx_ena;
wire [`RSV_ENTRY_NUMS - 1 : 0] rsv_age_mtrx_dat [`RSV_ENTRY_NUMS - 1 : 0];

genvar i;
generate
    for(i = 0; i < `RSV_ENTRY_NUMS; i = i + 1) begin
        assign rsv_age_mtrx_ena[i] = ((i_dsp_rsv_vld[3] & (i == i_dsp_rsv_free_entry_3))
                                   |  (i_dsp_rsv_vld[2] & (i == i_dsp_rsv_free_entry_2))
                                   |  (i_dsp_rsv_vld[1] & (i == i_dsp_rsv_free_entry_1))
                                   |  (i_dsp_rsv_vld[0] & (i == i_dsp_rsv_free_entry_0))
                                   ) | rsv_age_mtrx_need_flush;
        assign rsv_age_mtrx_dat[i] = ({`RSV_ENTRY_NUMS{((i_dsp_rsv_vld[3]) & (i == i_dsp_rsv_free_entry_3)) & (~rsv_age_mtrx_need_flush)}} & rsv_age_mtrx_entry_dat_3)
                                   | ({`RSV_ENTRY_NUMS{((i_dsp_rsv_vld[2]) & (i == i_dsp_rsv_free_entry_2)) & (~rsv_age_mtrx_need_flush)}} & rsv_age_mtrx_entry_dat_2)
                                   | ({`RSV_ENTRY_NUMS{((i_dsp_rsv_vld[1]) & (i == i_dsp_rsv_free_entry_1)) & (~rsv_age_mtrx_need_flush)}} & rsv_age_mtrx_entry_dat_1)
                                   | ({`RSV_ENTRY_NUMS{((i_dsp_rsv_vld[0]) & (i == i_dsp_rsv_free_entry_0)) & (~rsv_age_mtrx_need_flush)}} & rsv_age_mtrx_entry_dat_0); 
        gnrl_dfflr #(
            .DATA_WIDTH   (`RSV_ENTRY_NUMS),
            .INITIAL_VALUE(0)
        ) rsv_age_mtrx_dfflr (rsv_age_mtrx_ena[i], rsv_age_mtrx_dat[i], rsv_age_mtrx_r[i], clk, rst_n);
    end
endgenerate


//  Oldest Vector
wire [`RSV_ENTRY_NUMS - 1 : 0] rsv_oldest_vec [`RSV_ENTRY_NUMS - 1 : 0];

genvar j, k;
generate
    for(j = 0; j < `RSV_ENTRY_NUMS; j = j + 1) begin
        for(k = 0; k < `RSV_ENTRY_NUMS; k = k + 1) begin
            assign rsv_oldest_vec[j][k] = (k == j) ? 1'b0
                                        : (rsv_age_mtrx_r[j][k] & i_rsv_entry_vld_vec[k]);
        end
        assign o_oldest_rsv_vec[j] = (~(|rsv_oldest_vec[j])) & i_rsv_entry_vld_vec[j];
    end
endgenerate

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

endmodule   //  rsv_age_mtrx_module


`endif  /*  !__RSV_AGE_MTRX_V__!    */