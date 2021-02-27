`ifdef __RSV_RSV_PRF_V__

module rsv_prf_module (
    input                                   i_ren_prf_free_req_0,
    input                                   i_ren_prf_free_req_1,
    input                                   i_ren_prf_free_req_2,
    input                                   i_ren_prf_free_req_3,
    input   [`PRF_CODE_WIDTH - 1    : 0]    i_ren_prf_free_prf_code_0,
    input   [`PRF_CODE_WIDTH - 1    : 0]    i_ren_prf_free_prf_code_1,
    input   [`PRF_CODE_WIDTH - 1    : 0]    i_ren_prf_free_prf_code_2,
    input   [`PRF_CODE_WIDTH - 1    : 0]    i_ren_prf_free_prf_code_3,
    
    input   [`PRF_CODE_WIDTH - 1    : 0]    i_rsv_prf_rd_code_0,
    input   [`PRF_CODE_WIDTH - 1    : 0]    i_rsv_prf_rd_code_1,
    input   [`PRF_CODE_WIDTH - 1    : 0]    i_rsv_prf_rd_code_2,
    input   [`PRF_CODE_WIDTH - 1    : 0]    i_rsv_prf_rd_code_3,
    input   [`PRF_CODE_WIDTH - 1    : 0]    i_rsv_prf_rd_code_4,
    input   [`PRF_CODE_WIDTH - 1    : 0]    i_rsv_prf_rd_code_5,
    input   [`PRF_CODE_WIDTH - 1    : 0]    i_rsv_prf_rd_code_6,
    input   [`PRF_CODE_WIDTH - 1    : 0]    i_rsv_prf_rd_code_7,
    
    input                                   i_rsv_prf_wren_0,
    input                                   i_rsv_prf_wren_1,
    input                                   i_rsv_prf_wren_2,
    input                                   i_rsv_prf_wren_3,
    input   [`PRF_CODE_WIDTH - 1    : 0]    i_rsv_prf_wr_code_0,
    input   [`PRF_CODE_WIDTH - 1    : 0]    i_rsv_prf_wr_code_1,
    input   [`PRF_CODE_WIDTH - 1    : 0]    i_rsv_prf_wr_code_2,
    input   [`PRF_CODE_WIDTH - 1    : 0]    i_rsv_prf_wr_code_3,
    input   [`PRF_DATA_WIDTH - 1    : 0]    i_rsv_prf_wdat_0,
    input   [`PRF_DATA_WIDTH - 1    : 0]    i_rsv_prf_wdat_1,
    input   [`PRF_DATA_WIDTH - 1    : 0]    i_rsv_prf_wdat_2,
    input   [`PRF_DATA_WIDTH - 1    : 0]    i_rsv_prf_wdat_3,
    output  [`PRF_DATA_WIDTH - 1    : 0]    o_prf_rsv_rdat_0,
    output  [`PRF_DATA_WIDTH - 1    : 0]    o_prf_rsv_rdat_1,
    output  [`PRF_DATA_WIDTH - 1    : 0]    o_prf_rsv_rdat_2,
    output  [`PRF_DATA_WIDTH - 1    : 0]    o_prf_rsv_rdat_3,
    output  [`PRF_DATA_WIDTH - 1    : 0]    o_prf_rsv_rdat_4,
    output  [`PRF_DATA_WIDTH - 1    : 0]    o_prf_rsv_rdat_5,
    output  [`PRF_DATA_WIDTH - 1    : 0]    o_prf_rsv_rdat_6,
    output  [`PRF_DATA_WIDTH - 1    : 0]    o_prf_rsv_rdat_7,
    
    output  [`PRF_NUMS - 1          : 0]    o_prf_rsv_available,

    input                                   clk,
    input                                   rst_n
);


wire [`PRF_DATA_WIDTH - 1 : 0] rsv_prf_r [`PRF_NUMS - 1 : 0];


//  Write 
wire [`PRF_DATA_WIDTH - 1 : 0] rsv_prf_nxt [`PRF_NUMS - 1 : 0];
wire [`PRF_NUMS - 1 : 0] rsv_prf_wren;

genvar i;
generate
    for(i = 0; i < `PRF_NUMS; i = i + 1) begin
        if(i == 0) begin
            assign rsv_prf_wren[i] = 1'b0;
            assign rsv_prf_r[i] = `PRF_DATA_WIDTH'd0;
        end
        else begin
            assign rsv_prf_wren[i] = (i_rsv_prf_wren_0 & (i == i_rsv_prf_wr_code_0))
                                   | (i_rsv_prf_wren_1 & (i == i_rsv_prf_wr_code_1))
                                   | (i_rsv_prf_wren_2 & (i == i_rsv_prf_wr_code_2))
                                   | (i_rsv_prf_wren_3 & (i == i_rsv_prf_wr_code_3));
            assign rsv_prf_nxt[i]  = ({`PRF_DATA_WIDTH{(i == i_rsv_prf_wr_code_0)}}  & i_rsv_prf_wdat_0)
                                   | ({`PRF_DATA_WIDTH{(i == i_rsv_prf_wr_code_1)}}  & i_rsv_prf_wdat_1)
                                   | ({`PRF_DATA_WIDTH{(i == i_rsv_prf_wr_code_2)}}  & i_rsv_prf_wdat_2)
                                   | ({`PRF_DATA_WIDTH{(i == i_rsv_prf_wr_code_3)}}  & i_rsv_prf_wdat_3);
            gnrl_dffl #(
                .DATA_WIDTH(`PRF_DATA_WIDTH)
            ) rsv_prf_dffl (rsv_prf_wren[i], rsv_prf_nxt[i], rsv_prf_r[i], clk);
        end
    end
endgenerate



//  Read
assign o_prf_rsv_rdat_0 = rsv_prf_r[i_rsv_prf_rd_code_0];
assign o_prf_rsv_rdat_1 = rsv_prf_r[i_rsv_prf_rd_code_1];
assign o_prf_rsv_rdat_2 = rsv_prf_r[i_rsv_prf_rd_code_2];
assign o_prf_rsv_rdat_3 = rsv_prf_r[i_rsv_prf_rd_code_3];
assign o_prf_rsv_rdat_4 = rsv_prf_r[i_rsv_prf_rd_code_4];
assign o_prf_rsv_rdat_5 = rsv_prf_r[i_rsv_prf_rd_code_5];
assign o_prf_rsv_rdat_6 = rsv_prf_r[i_rsv_prf_rd_code_6];
assign o_prf_rsv_rdat_7 = rsv_prf_r[i_rsv_prf_rd_code_7];

//  
wire prf_rsv_available_ena = (i_ren_prf_free_req_0
                           |  i_ren_prf_free_req_1
                           |  i_ren_prf_free_req_2
                           |  i_ren_prf_free_req_3);
wire [`PRF_NUMS - 1 : 0] o_prf_rsv_available_nxt = (({`PRF_NUMS{i_rsv_prf_wren_0}}    & func_vec128(i_rsv_prf_wr_code_0))
                                                 |  ({`PRF_NUMS{i_rsv_prf_wren_1}}    & func_vec128(i_rsv_prf_wr_code_1))
                                                 |  ({`PRF_NUMS{i_rsv_prf_wren_2}}    & func_vec128(i_rsv_prf_wr_code_2))
                                                 |  ({`PRF_NUMS{i_rsv_prf_wren_3}}    & func_vec128(i_rsv_prf_wr_code_3)))
                                                 & (~(({`PRF_NUMS{i_ren_prf_free_req_0}} & func_vec128(i_ren_prf_free_prf_code_0))
                                                 |   ({`PRF_NUMS{i_ren_prf_free_req_1}} & func_vec128(i_ren_prf_free_prf_code_1))
                                                 |   ({`PRF_NUMS{i_ren_prf_free_req_2}} & func_vec128(i_ren_prf_free_prf_code_2))
                                                 |   ({`PRF_NUMS{i_ren_prf_free_req_3}} & func_vec128(i_ren_prf_free_prf_code_3))));

gnrl_dfflr #(
    .DATA_WIDTH(`PRF_NUMS),
    .INITIAL_VALUE(1)
) prf_rsv_available_dfflr (prf_rsv_available_ena, o_prf_rsv_available_nxt, o_prf_rsv_available, clk, rst_n);

//  Functions
function [127 : 0] func_vec128;
    input [6 : 0] index;
    
    case (index)
        7'b0000000 : func_vec128 = 128'd1;
        7'b0000001 : func_vec128 = 128'd2;
        7'b0000010 : func_vec128 = 128'd4;
        7'b0000011 : func_vec128 = 128'd8;
        7'b0000100 : func_vec128 = 128'd16;
        7'b0000101 : func_vec128 = 128'd32;
        7'b0000110 : func_vec128 = 128'd64;
        7'b0000111 : func_vec128 = 128'd128;
        7'b0001000 : func_vec128 = 128'd256;
        7'b0001001 : func_vec128 = 128'd512;
        7'b0001010 : func_vec128 = 128'd1024;
        7'b0001011 : func_vec128 = 128'd2048;
        7'b0001100 : func_vec128 = 128'd4096;
        7'b0001101 : func_vec128 = 128'd8192;
        7'b0001110 : func_vec128 = 128'd16384;
        7'b0001111 : func_vec128 = 128'd32768;
        7'b0010000 : func_vec128 = 128'd65536;
        7'b0010001 : func_vec128 = 128'd131072;
        7'b0010010 : func_vec128 = 128'd262144;
        7'b0010011 : func_vec128 = 128'd524288;
        7'b0010100 : func_vec128 = 128'd1048576;
        7'b0010101 : func_vec128 = 128'd2097152;
        7'b0010110 : func_vec128 = 128'd4194304;
        7'b0010111 : func_vec128 = 128'd8388608;
        7'b0011000 : func_vec128 = 128'd16777216;
        7'b0011001 : func_vec128 = 128'd33554432;
        7'b0011010 : func_vec128 = 128'd67108864;
        7'b0011011 : func_vec128 = 128'd134217728;
        7'b0011100 : func_vec128 = 128'd268435456;
        7'b0011101 : func_vec128 = 128'd536870912;
        7'b0011110 : func_vec128 = 128'd1073741824;
        7'b0011111 : func_vec128 = 128'd2147483648;
        7'b0100000 : func_vec128 = 128'd4294967296;
        7'b0100001 : func_vec128 = 128'd8589934592;
        7'b0100010 : func_vec128 = 128'd17179869184;
        7'b0100011 : func_vec128 = 128'd34359738368;
        7'b0100100 : func_vec128 = 128'd68719476736;
        7'b0100101 : func_vec128 = 128'd137438953472;
        7'b0100110 : func_vec128 = 128'd274877906944;
        7'b0100111 : func_vec128 = 128'd549755813888;
        7'b0101000 : func_vec128 = 128'd1099511627776;
        7'b0101001 : func_vec128 = 128'd2199023255552;
        7'b0101010 : func_vec128 = 128'd4398046511104;
        7'b0101011 : func_vec128 = 128'd8796093022208;
        7'b0101100 : func_vec128 = 128'd17592186044416;
        7'b0101101 : func_vec128 = 128'd35184372088832;
        7'b0101110 : func_vec128 = 128'd70368744177664;
        7'b0101111 : func_vec128 = 128'd140737488355328;
        7'b0110000 : func_vec128 = 128'd281474976710656;
        7'b0110001 : func_vec128 = 128'd562949953421312;
        7'b0110010 : func_vec128 = 128'd1125899906842624;
        7'b0110011 : func_vec128 = 128'd2251799813685248;
        7'b0110100 : func_vec128 = 128'd4503599627370496;
        7'b0110101 : func_vec128 = 128'd9007199254740992;
        7'b0110110 : func_vec128 = 128'd18014398509481984;
        7'b0110111 : func_vec128 = 128'd36028797018963968;
        7'b0111000 : func_vec128 = 128'd72057594037927936;
        7'b0111001 : func_vec128 = 128'd144115188075855872;
        7'b0111010 : func_vec128 = 128'd288230376151711744;
        7'b0111011 : func_vec128 = 128'd576460752303423488;
        7'b0111100 : func_vec128 = 128'd1152921504606846976;
        7'b0111101 : func_vec128 = 128'd2305843009213693952;
        7'b0111110 : func_vec128 = 128'd4611686018427387904;
        7'b0111111 : func_vec128 = 128'd9223372036854775808;
        7'b1000000 : func_vec128 = 128'd18446744073709551616;
        7'b1000001 : func_vec128 = 128'd36893488147419103232;
        7'b1000010 : func_vec128 = 128'd73786976294838206464;
        7'b1000011 : func_vec128 = 128'd147573952589676412928;
        7'b1000100 : func_vec128 = 128'd295147905179352825856;
        7'b1000101 : func_vec128 = 128'd590295810358705651712;
        7'b1000110 : func_vec128 = 128'd1180591620717411303424;
        7'b1000111 : func_vec128 = 128'd2361183241434822606848;
        7'b1001000 : func_vec128 = 128'd4722366482869645213696;
        7'b1001001 : func_vec128 = 128'd9444732965739290427392;
        7'b1001010 : func_vec128 = 128'd18889465931478580854784;
        7'b1001011 : func_vec128 = 128'd37778931862957161709568;
        7'b1001100 : func_vec128 = 128'd75557863725914323419136;
        7'b1001101 : func_vec128 = 128'd151115727451828646838272;
        7'b1001110 : func_vec128 = 128'd302231454903657293676544;
        7'b1001111 : func_vec128 = 128'd604462909807314587353088;
        7'b1010000 : func_vec128 = 128'd1208925819614629174706176;
        7'b1010001 : func_vec128 = 128'd2417851639229258349412352;
        7'b1010010 : func_vec128 = 128'd4835703278458516698824704;
        7'b1010011 : func_vec128 = 128'd9671406556917033397649408;
        7'b1010100 : func_vec128 = 128'd19342813113834066795298816;
        7'b1010101 : func_vec128 = 128'd38685626227668133590597632;
        7'b1010110 : func_vec128 = 128'd77371252455336267181195264;
        7'b1010111 : func_vec128 = 128'd154742504910672534362390528;
        7'b1011000 : func_vec128 = 128'd309485009821345068724781056;
        7'b1011001 : func_vec128 = 128'd618970019642690137449562112;
        7'b1011010 : func_vec128 = 128'd1237940039285380274899124224;
        7'b1011011 : func_vec128 = 128'd2475880078570760549798248448;
        7'b1011100 : func_vec128 = 128'd4951760157141521099596496896;
        7'b1011101 : func_vec128 = 128'd9903520314283042199192993792;
        7'b1011110 : func_vec128 = 128'd19807040628566084398385987584;
        7'b1011111 : func_vec128 = 128'd39614081257132168796771975168;
        7'b1100000 : func_vec128 = 128'd79228162514264337593543950336;
        7'b1100001 : func_vec128 = 128'd158456325028528675187087900672;
        7'b1100010 : func_vec128 = 128'd316912650057057350374175801344;
        7'b1100011 : func_vec128 = 128'd633825300114114700748351602688;
        7'b1100100 : func_vec128 = 128'd1267650600228229401496703205376;
        7'b1100101 : func_vec128 = 128'd2535301200456458802993406410752;
        7'b1100110 : func_vec128 = 128'd5070602400912917605986812821504;
        7'b1100111 : func_vec128 = 128'd10141204801825835211973625643008;
        7'b1101000 : func_vec128 = 128'd20282409603651670423947251286016;
        7'b1101001 : func_vec128 = 128'd40564819207303340847894502572032;
        7'b1101010 : func_vec128 = 128'd81129638414606681695789005144064;
        7'b1101011 : func_vec128 = 128'd162259276829213363391578010288128;
        7'b1101100 : func_vec128 = 128'd324518553658426726783156020576256;
        7'b1101101 : func_vec128 = 128'd649037107316853453566312041152512;
        7'b1101110 : func_vec128 = 128'd1298074214633706907132624082305024;
        7'b1101111 : func_vec128 = 128'd2596148429267413814265248164610048;
        7'b1110000 : func_vec128 = 128'd5192296858534827628530496329220096;
        7'b1110001 : func_vec128 = 128'd10384593717069655257060992658440192;
        7'b1110010 : func_vec128 = 128'd20769187434139310514121985316880384;
        7'b1110011 : func_vec128 = 128'd41538374868278621028243970633760768;
        7'b1110100 : func_vec128 = 128'd83076749736557242056487941267521536;
        7'b1110101 : func_vec128 = 128'd166153499473114484112975882535043072;
        7'b1110110 : func_vec128 = 128'd332306998946228968225951765070086144;
        7'b1110111 : func_vec128 = 128'd664613997892457936451903530140172288;
        7'b1111000 : func_vec128 = 128'd1329227995784915872903807060280344576;
        7'b1111001 : func_vec128 = 128'd2658455991569831745807614120560689152;
        7'b1111010 : func_vec128 = 128'd5316911983139663491615228241121378304;
        7'b1111011 : func_vec128 = 128'd10633823966279326983230456482242756608;
        7'b1111100 : func_vec128 = 128'd21267647932558653966460912964485513216;
        7'b1111101 : func_vec128 = 128'd42535295865117307932921825928971026432;
        7'b1111110 : func_vec128 = 128'd85070591730234615865843651857942052864;
        7'b1111111 : func_vec128 = 128'd170141183460469231731687303715884105728;
    endcase

endfunction
endmodule   //  rsv_prf_module

`endif  /*  !__RSV_RSV_PRF_V__!    */