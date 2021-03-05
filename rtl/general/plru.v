`ifdef __GNRL_PLRU_V__

module plru_module (
    input                               plru_hit,
    input   [5 : 0]                     plru_hit_idx,
    input                               plru_req,
    output  [5 : 0]                     plru_replace_idx,
    input                               clk,
    input                               rst_n
);

wire [62 : 0] plru_status, plru_status_nxt;
wire [63 : 0] plru_way_sel;

//  Tree
assign plru_way_sel[0]  = (~plru_status[0]) & (~plru_status[1]) & (~plru_status[3]) & (~plru_status[7]) & (~plru_status[15]) & (~plru_status[31]);
assign plru_way_sel[1]  = (~plru_status[0]) & (~plru_status[1]) & (~plru_status[3]) & (~plru_status[7]) & (~plru_status[15]) & plru_status[31];
assign plru_way_sel[2]  = (~plru_status[0]) & (~plru_status[1]) & (~plru_status[3]) & (~plru_status[7]) & plru_status[15] & (~plru_status[32]);
assign plru_way_sel[3]  = (~plru_status[0]) & (~plru_status[1]) & (~plru_status[3]) & (~plru_status[7]) & plru_status[15] & plru_status[32];
assign plru_way_sel[4]  = (~plru_status[0]) & (~plru_status[1]) & (~plru_status[3]) & plru_status[7] & (~plru_status[16]) & (~plru_status[33]);
assign plru_way_sel[5]  = (~plru_status[0]) & (~plru_status[1]) & (~plru_status[3]) & plru_status[7] & (~plru_status[16]) & plru_status[33];
assign plru_way_sel[6]  = (~plru_status[0]) & (~plru_status[1]) & (~plru_status[3]) & plru_status[7] & plru_status[16] & (~plru_status[34]);
assign plru_way_sel[7]  = (~plru_status[0]) & (~plru_status[1]) & (~plru_status[3]) & plru_status[7] & plru_status[16] & plru_status[34];
assign plru_way_sel[8]  = (~plru_status[0]) & (~plru_status[1]) & plru_status[3] & (~plru_status[8]) & (~plru_status[17]) & (~plru_status[35]);
assign plru_way_sel[9]  = (~plru_status[0]) & (~plru_status[1]) & plru_status[3] & (~plru_status[8]) & (~plru_status[17]) & plru_status[35];
assign plru_way_sel[10] = (~plru_status[0]) & (~plru_status[1]) & plru_status[3] & (~plru_status[8]) & plru_status[17] & (~plru_status[36]);
assign plru_way_sel[11] = (~plru_status[0]) & (~plru_status[1]) & plru_status[3] & (~plru_status[8]) & plru_status[17] & plru_status[36];
assign plru_way_sel[12] = (~plru_status[0]) & (~plru_status[1]) & plru_status[3] & plru_status[8] & (~plru_status[18]) & (~plru_status[37]);
assign plru_way_sel[13] = (~plru_status[0]) & (~plru_status[1]) & plru_status[3] & plru_status[8] & (~plru_status[18]) & plru_status[37];
assign plru_way_sel[14] = (~plru_status[0]) & (~plru_status[1]) & plru_status[3] & plru_status[8] & plru_status[18] & (~plru_status[38]);
assign plru_way_sel[15] = (~plru_status[0]) & (~plru_status[1]) & plru_status[3] & plru_status[8] & plru_status[18] & plru_status[38];
assign plru_way_sel[16] = (~plru_status[0]) & plru_status[1] & (~plru_status[4]) & (~plru_status[9]) & (~plru_status[19]) & (~plru_status[39]);
assign plru_way_sel[17] = (~plru_status[0]) & plru_status[1] & (~plru_status[4]) & (~plru_status[9]) & (~plru_status[19]) & plru_status[39];
assign plru_way_sel[18] = (~plru_status[0]) & plru_status[1] & (~plru_status[4]) & (~plru_status[9]) & plru_status[19] & (~plru_status[40]);
assign plru_way_sel[19] = (~plru_status[0]) & plru_status[1] & (~plru_status[4]) & (~plru_status[9]) & plru_status[19] & plru_status[40];
assign plru_way_sel[20] = (~plru_status[0]) & plru_status[1] & (~plru_status[4]) & plru_status[9] & (~plru_status[20]) & (~plru_status[41]);
assign plru_way_sel[21] = (~plru_status[0]) & plru_status[1] & (~plru_status[4]) & plru_status[9] & (~plru_status[20]) & plru_status[41];
assign plru_way_sel[22] = (~plru_status[0]) & plru_status[1] & (~plru_status[4]) & plru_status[9] & plru_status[20] & (~plru_status[42]);
assign plru_way_sel[23] = (~plru_status[0]) & plru_status[1] & (~plru_status[4]) & plru_status[9] & plru_status[20] & plru_status[42];
assign plru_way_sel[24] = (~plru_status[0]) & plru_status[1] & plru_status[4] & (~plru_status[10]) & (~plru_status[21]) & (~plru_status[43]);
assign plru_way_sel[25] = (~plru_status[0]) & plru_status[1] & plru_status[4] & (~plru_status[10]) & (~plru_status[21]) & plru_status[43];
assign plru_way_sel[26] = (~plru_status[0]) & plru_status[1] & plru_status[4] & (~plru_status[10]) & plru_status[21] & (~plru_status[44]);
assign plru_way_sel[27] = (~plru_status[0]) & plru_status[1] & plru_status[4] & (~plru_status[10]) & plru_status[21] & plru_status[44];
assign plru_way_sel[28] = (~plru_status[0]) & plru_status[1] & plru_status[4] & plru_status[10] & (~plru_status[22]) & (~plru_status[45]);
assign plru_way_sel[29] = (~plru_status[0]) & plru_status[1] & plru_status[4] & plru_status[10] & (~plru_status[22]) & plru_status[45];
assign plru_way_sel[30] = (~plru_status[0]) & plru_status[1] & plru_status[4] & plru_status[10] & plru_status[22] & (~plru_status[46]);
assign plru_way_sel[31] = (~plru_status[0]) & plru_status[1] & plru_status[4] & plru_status[10] & plru_status[22] & plru_status[46];
assign plru_way_sel[32] = plru_status[0] & (~plru_status[2]) & (~plru_status[5]) & (~plru_status[11]) & (~plru_status[23]) & (~plru_status[47]);
assign plru_way_sel[33] = plru_status[0] & (~plru_status[2]) & (~plru_status[5]) & (~plru_status[11]) & (~plru_status[23]) & plru_status[47];
assign plru_way_sel[34] = plru_status[0] & (~plru_status[2]) & (~plru_status[5]) & (~plru_status[11]) & plru_status[23] & (~plru_status[48]);
assign plru_way_sel[35] = plru_status[0] & (~plru_status[2]) & (~plru_status[5]) & (~plru_status[11]) & plru_status[23] & plru_status[48];
assign plru_way_sel[36] = plru_status[0] & (~plru_status[2]) & (~plru_status[5]) & plru_status[11] & (~plru_status[24]) & (~plru_status[49]);
assign plru_way_sel[37] = plru_status[0] & (~plru_status[2]) & (~plru_status[5]) & plru_status[11] & (~plru_status[24]) & plru_status[49];
assign plru_way_sel[38] = plru_status[0] & (~plru_status[2]) & (~plru_status[5]) & plru_status[11] & plru_status[24] & (~plru_status[50]);
assign plru_way_sel[39] = plru_status[0] & (~plru_status[2]) & (~plru_status[5]) & plru_status[11] & plru_status[24] & plru_status[50];
assign plru_way_sel[40] = plru_status[0] & (~plru_status[2]) & plru_status[5] & (~plru_status[12]) & (~plru_status[25]) & (~plru_status[51]);
assign plru_way_sel[41] = plru_status[0] & (~plru_status[2]) & plru_status[5] & (~plru_status[12]) & (~plru_status[25]) & plru_status[51];
assign plru_way_sel[42] = plru_status[0] & (~plru_status[2]) & plru_status[5] & (~plru_status[12]) & plru_status[25] & (~plru_status[52]);
assign plru_way_sel[43] = plru_status[0] & (~plru_status[2]) & plru_status[5] & (~plru_status[12]) & plru_status[25] & plru_status[52];
assign plru_way_sel[44] = plru_status[0] & (~plru_status[2]) & plru_status[5] & plru_status[12] & (~plru_status[26]) & (~plru_status[53]);
assign plru_way_sel[45] = plru_status[0] & (~plru_status[2]) & plru_status[5] & plru_status[12] & (~plru_status[26]) & plru_status[53];
assign plru_way_sel[46] = plru_status[0] & (~plru_status[2]) & plru_status[5] & plru_status[12] & plru_status[26] & (~plru_status[54]);
assign plru_way_sel[47] = plru_status[0] & (~plru_status[2]) & plru_status[5] & plru_status[12] & plru_status[26] & plru_status[54];
assign plru_way_sel[48] = plru_status[0] & plru_status[2] & (~plru_status[6]) & (~plru_status[13]) & (~plru_status[27]) & (~plru_status[55]);
assign plru_way_sel[49] = plru_status[0] & plru_status[2] & (~plru_status[6]) & (~plru_status[13]) & (~plru_status[27]) & plru_status[55];
assign plru_way_sel[50] = plru_status[0] & plru_status[2] & (~plru_status[6]) & (~plru_status[13]) & plru_status[27] & (~plru_status[56]);
assign plru_way_sel[51] = plru_status[0] & plru_status[2] & (~plru_status[6]) & (~plru_status[13]) & plru_status[27] & plru_status[56];
assign plru_way_sel[52] = plru_status[0] & plru_status[2] & (~plru_status[6]) & plru_status[13] & (~plru_status[28]) & (~plru_status[57]);
assign plru_way_sel[53] = plru_status[0] & plru_status[2] & (~plru_status[6]) & plru_status[13] & (~plru_status[28]) & plru_status[57];
assign plru_way_sel[54] = plru_status[0] & plru_status[2] & (~plru_status[6]) & plru_status[13] & plru_status[28] & (~plru_status[58]);
assign plru_way_sel[55] = plru_status[0] & plru_status[2] & (~plru_status[6]) & plru_status[13] & plru_status[28] & plru_status[58];
assign plru_way_sel[56] = plru_status[0] & plru_status[2] & plru_status[6] & (~plru_status[14]) & (~plru_status[29]) & (~plru_status[59]);
assign plru_way_sel[57] = plru_status[0] & plru_status[2] & plru_status[6] & (~plru_status[14]) & (~plru_status[29]) & plru_status[59];
assign plru_way_sel[58] = plru_status[0] & plru_status[2] & plru_status[6] & (~plru_status[14]) & plru_status[29] & (~plru_status[60]);
assign plru_way_sel[59] = plru_status[0] & plru_status[2] & plru_status[6] & (~plru_status[14]) & plru_status[29] & plru_status[60];
assign plru_way_sel[60] = plru_status[0] & plru_status[2] & plru_status[6] & plru_status[14] & (~plru_status[30]) & (~plru_status[61]);
assign plru_way_sel[61] = plru_status[0] & plru_status[2] & plru_status[6] & plru_status[14] & (~plru_status[30]) & plru_status[61];
assign plru_way_sel[62] = plru_status[0] & plru_status[2] & plru_status[6] & plru_status[14] & plru_status[30] & (~plru_status[62]);
assign plru_way_sel[63] = plru_status[0] & plru_status[2] & plru_status[6] & plru_status[14] & plru_status[30] & plru_status[62];

assign plru_replace_idx = func_vec64r(plru_way_sel);

//  Update status
wire [5 : 0] plru_update_idx = plru_hit ? plru_hit_idx : plru_replace_idx;
wire [63 : 0] plru_update_idx_sel = func_vec64(plru_update_idx);

//
wire [62 : 0] plru_update_status_sel;
assign plru_update_status_sel[31] = plru_update_idx_sel[0]  | plru_update_idx_sel[1];
assign plru_update_status_sel[32] = plru_update_idx_sel[2]  | plru_update_idx_sel[3];
assign plru_update_status_sel[33] = plru_update_idx_sel[4]  | plru_update_idx_sel[5];
assign plru_update_status_sel[34] = plru_update_idx_sel[6]  | plru_update_idx_sel[7];
assign plru_update_status_sel[35] = plru_update_idx_sel[8]  | plru_update_idx_sel[9];
assign plru_update_status_sel[36] = plru_update_idx_sel[10] | plru_update_idx_sel[11];
assign plru_update_status_sel[37] = plru_update_idx_sel[12] | plru_update_idx_sel[13];
assign plru_update_status_sel[38] = plru_update_idx_sel[14] | plru_update_idx_sel[15];
assign plru_update_status_sel[39] = plru_update_idx_sel[16] | plru_update_idx_sel[17];
assign plru_update_status_sel[40] = plru_update_idx_sel[18] | plru_update_idx_sel[19];
assign plru_update_status_sel[41] = plru_update_idx_sel[20] | plru_update_idx_sel[21];
assign plru_update_status_sel[42] = plru_update_idx_sel[22] | plru_update_idx_sel[23];
assign plru_update_status_sel[43] = plru_update_idx_sel[24] | plru_update_idx_sel[25];
assign plru_update_status_sel[44] = plru_update_idx_sel[26] | plru_update_idx_sel[27];
assign plru_update_status_sel[45] = plru_update_idx_sel[28] | plru_update_idx_sel[29];
assign plru_update_status_sel[46] = plru_update_idx_sel[30] | plru_update_idx_sel[31];
assign plru_update_status_sel[47] = plru_update_idx_sel[32] | plru_update_idx_sel[33];
assign plru_update_status_sel[48] = plru_update_idx_sel[34] | plru_update_idx_sel[35];
assign plru_update_status_sel[49] = plru_update_idx_sel[36] | plru_update_idx_sel[37];
assign plru_update_status_sel[50] = plru_update_idx_sel[38] | plru_update_idx_sel[39];
assign plru_update_status_sel[51] = plru_update_idx_sel[40] | plru_update_idx_sel[41];
assign plru_update_status_sel[52] = plru_update_idx_sel[42] | plru_update_idx_sel[43];
assign plru_update_status_sel[53] = plru_update_idx_sel[44] | plru_update_idx_sel[45];
assign plru_update_status_sel[54] = plru_update_idx_sel[46] | plru_update_idx_sel[47];
assign plru_update_status_sel[55] = plru_update_idx_sel[48] | plru_update_idx_sel[49];
assign plru_update_status_sel[56] = plru_update_idx_sel[50] | plru_update_idx_sel[51];
assign plru_update_status_sel[57] = plru_update_idx_sel[52] | plru_update_idx_sel[53];
assign plru_update_status_sel[58] = plru_update_idx_sel[54] | plru_update_idx_sel[55];
assign plru_update_status_sel[59] = plru_update_idx_sel[56] | plru_update_idx_sel[57];
assign plru_update_status_sel[60] = plru_update_idx_sel[58] | plru_update_idx_sel[59];
assign plru_update_status_sel[61] = plru_update_idx_sel[60] | plru_update_idx_sel[61];
assign plru_update_status_sel[62] = plru_update_idx_sel[62] | plru_update_idx_sel[63];

assign plru_update_status_sel[15] = plru_update_status_sel[31] | plru_update_status_sel[32];
assign plru_update_status_sel[16] = plru_update_status_sel[33] | plru_update_status_sel[34];
assign plru_update_status_sel[17] = plru_update_status_sel[35] | plru_update_status_sel[36];
assign plru_update_status_sel[18] = plru_update_status_sel[37] | plru_update_status_sel[38];
assign plru_update_status_sel[19] = plru_update_status_sel[39] | plru_update_status_sel[40];
assign plru_update_status_sel[20] = plru_update_status_sel[41] | plru_update_status_sel[42];
assign plru_update_status_sel[21] = plru_update_status_sel[43] | plru_update_status_sel[44];
assign plru_update_status_sel[22] = plru_update_status_sel[45] | plru_update_status_sel[46];
assign plru_update_status_sel[23] = plru_update_status_sel[47] | plru_update_status_sel[48];
assign plru_update_status_sel[24] = plru_update_status_sel[49] | plru_update_status_sel[50];
assign plru_update_status_sel[25] = plru_update_status_sel[51] | plru_update_status_sel[52];
assign plru_update_status_sel[26] = plru_update_status_sel[53] | plru_update_status_sel[54];
assign plru_update_status_sel[27] = plru_update_status_sel[55] | plru_update_status_sel[56];
assign plru_update_status_sel[28] = plru_update_status_sel[57] | plru_update_status_sel[58];
assign plru_update_status_sel[29] = plru_update_status_sel[59] | plru_update_status_sel[60];
assign plru_update_status_sel[30] = plru_update_status_sel[61] | plru_update_status_sel[62];

assign plru_update_status_sel[7]  = plru_update_status_sel[15] | plru_update_status_sel[16];
assign plru_update_status_sel[8]  = plru_update_status_sel[17] | plru_update_status_sel[18];
assign plru_update_status_sel[9]  = plru_update_status_sel[19] | plru_update_status_sel[20];
assign plru_update_status_sel[10] = plru_update_status_sel[21] | plru_update_status_sel[22];
assign plru_update_status_sel[11] = plru_update_status_sel[23] | plru_update_status_sel[24];
assign plru_update_status_sel[12] = plru_update_status_sel[25] | plru_update_status_sel[26];
assign plru_update_status_sel[13] = plru_update_status_sel[27] | plru_update_status_sel[28];
assign plru_update_status_sel[14] = plru_update_status_sel[29] | plru_update_status_sel[30];

assign plru_update_status_sel[3] = plru_update_status_sel[7] | plru_update_status_sel[8];
assign plru_update_status_sel[4] = plru_update_status_sel[9] | plru_update_status_sel[10];
assign plru_update_status_sel[5] = plru_update_status_sel[11] | plru_update_status_sel[12];
assign plru_update_status_sel[6] = plru_update_status_sel[13] | plru_update_status_sel[14];

assign plru_update_status_sel[1] = plru_update_status_sel[3] | plru_update_status_sel[4];
assign plru_update_status_sel[2] = plru_update_status_sel[5] | plru_update_status_sel[6];

assign plru_update_status_sel[0] = plru_update_status_sel[1] | plru_update_status_sel[2];

wire plru_update_ena = (plru_req | (plru_hit & (plru_last_idx != plru_hit_idx)));
assign plru_status_nxt = (plru_update_ena ? plru_update_status_sel ^ plru_status : plru_status);


gnrl_dfflr #(
    .DATA_WIDTH(63),
    .INITIAL_VALUE(0)
) plru_status_dfflr (plru_update_ena, plru_status_nxt, plru_status, clk, rst_n);

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
    input [63 : 0] bit_map;
    
    case(bit_map)
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

endmodule

`endif  /*  !__GNRL_PLRU_V__!    */
