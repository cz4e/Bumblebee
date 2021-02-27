`ifdef __BPU_BTB_V__

module btb_module ( 
    input                                   i_btb_rden,
    input   [`CORE_PC_WIDTH - 1     : 0]    i_btb_pc_addr,
    output                                  o_btb_match,
    output  [`BTB_IDX_WIDTH - 1     : 0]    o_btb_idx,
    output  [`CORE_PC_WIDTH - 1     : 0]    o_btb_taddr,
    output  [3                      : 0]    o_btb_offset,
    output                                  o_btb_type,

    input                                   i_btb_clr,
    input   [`BTB_IDX_WIDTH - 1     : 0]    i_btb_clr_idx,
    input                                   i_btb_mispred,
    input   [`BTB_IDX_WIDTH - 1     : 0]    i_btb_mis_idx,
    input   [`CORE_PC_WIDTH - 1     : 0]    i_btb_mis_taddr,
    input                                   i_btb_new_br,
    input   [`CORE_PC_WIDTH - 1     : 0]    i_btb_new_pc_addr,
    input   [`CORE_PC_WIDTH - 1     : 0]    i_btb_new_taddr,
    input                                   i_btb_new_type,

    input                                   clk,
    input                                   rst_n
);

wire [`BTB_DEPTH - 1        : 0] btb_vld_r;
wire [`BTB_TAG_WIDTH - 1    : 0] btb_tag_r [`BTB_DEPTH - 1 : 0];
wire [`BTB_DATA_WIDTH - 1   : 0] btb_data_r [`BTB_DEPTH - 1 : 0];

//
wire btb_all_vld = (&btb_vld_r);
wire [`BTB_IDX_WIDTH - 1 : 0] btb_vld_idx = (btb_all_vld ? o_btb_plru_idx : func_find_vec32(btb_vld_r));

wire [`BTB_DEPTH - 1 : 0] btb_vld_nxt = (btb_vld_r 
                                      | (({`BTB_DEPTH{i_btb_new_br}}  & func_vec32(btb_vld_idx))))
                                      & (~({`BTB_DEPTH{i_btb_clr}} & func_vec32(i_btb_clr_idx)));

wire btb_vld_ena = (i_btb_new_br | i_btb_clr);
gnrl_dfflr #( 
    .DATA_WIDTH   (`BTB_DEPTH),
    .INITIAL_VALUE(0)
) btb_vld_dfflr (btb_vld_ena, btb_vld_nxt, btb_vld_r, clk, rst_n);

//  Read Logic
wire [`BTB_TAG_WIDTH - 1 : 0] btb_rtag = i_btb_pc_addr[`CORE_PC_WIDTH - 1 : 4];
wire [`BTB_DEPTH - 1 : 0] btb_match_vec;

genvar i;
generate
    for(i = 0; i < `BTB_DEPTH; i = i + 1) begin
        assign btb_match_vec[i] = (btb_vld_r[i] & (btb_tag_r[i] == btb_rtag));
    end
endgenerate

assign o_btb_match = (|btb_match_vec);
assign o_btb_idx = func_vec32_r(btb_match_vec);
assign {
        o_btb_taddr
    ,   o_btb_offset
    ,   o_btb_type
} = ({`BTB_DATA_WIDTH{btb_match_vec[0] }} & btb_data_r[ 0])
  | ({`BTB_DATA_WIDTH{btb_match_vec[1] }} & btb_data_r[ 1])
  | ({`BTB_DATA_WIDTH{btb_match_vec[2] }} & btb_data_r[ 2])
  | ({`BTB_DATA_WIDTH{btb_match_vec[3] }} & btb_data_r[ 3])
  | ({`BTB_DATA_WIDTH{btb_match_vec[4] }} & btb_data_r[ 4])
  | ({`BTB_DATA_WIDTH{btb_match_vec[5] }} & btb_data_r[ 5])
  | ({`BTB_DATA_WIDTH{btb_match_vec[6] }} & btb_data_r[ 6])
  | ({`BTB_DATA_WIDTH{btb_match_vec[7] }} & btb_data_r[ 7])
  | ({`BTB_DATA_WIDTH{btb_match_vec[8] }} & btb_data_r[ 8])
  | ({`BTB_DATA_WIDTH{btb_match_vec[9] }} & btb_data_r[ 9])
  | ({`BTB_DATA_WIDTH{btb_match_vec[10]}} & btb_data_r[10])
  | ({`BTB_DATA_WIDTH{btb_match_vec[11]}} & btb_data_r[11])
  | ({`BTB_DATA_WIDTH{btb_match_vec[12]}} & btb_data_r[12])
  | ({`BTB_DATA_WIDTH{btb_match_vec[13]}} & btb_data_r[13])
  | ({`BTB_DATA_WIDTH{btb_match_vec[14]}} & btb_data_r[14])
  | ({`BTB_DATA_WIDTH{btb_match_vec[15]}} & btb_data_r[15])
  | ({`BTB_DATA_WIDTH{btb_match_vec[16]}} & btb_data_r[16])
  | ({`BTB_DATA_WIDTH{btb_match_vec[17]}} & btb_data_r[17])
  | ({`BTB_DATA_WIDTH{btb_match_vec[18]}} & btb_data_r[18])
  | ({`BTB_DATA_WIDTH{btb_match_vec[19]}} & btb_data_r[19])
  | ({`BTB_DATA_WIDTH{btb_match_vec[20]}} & btb_data_r[20])
  | ({`BTB_DATA_WIDTH{btb_match_vec[21]}} & btb_data_r[21])
  | ({`BTB_DATA_WIDTH{btb_match_vec[22]}} & btb_data_r[22])
  | ({`BTB_DATA_WIDTH{btb_match_vec[23]}} & btb_data_r[23])
  | ({`BTB_DATA_WIDTH{btb_match_vec[24]}} & btb_data_r[24])
  | ({`BTB_DATA_WIDTH{btb_match_vec[25]}} & btb_data_r[25])
  | ({`BTB_DATA_WIDTH{btb_match_vec[26]}} & btb_data_r[26])
  | ({`BTB_DATA_WIDTH{btb_match_vec[27]}} & btb_data_r[27])
  | ({`BTB_DATA_WIDTH{btb_match_vec[28]}} & btb_data_r[28])
  | ({`BTB_DATA_WIDTH{btb_match_vec[29]}} & btb_data_r[29])
  | ({`BTB_DATA_WIDTH{btb_match_vec[30]}} & btb_data_r[30])
  | ({`BTB_DATA_WIDTH{btb_match_vec[31]}} & btb_data_r[31]);

//  Write Logic
wire btb_wr_tag_ena = i_btb_new_br;
wire btb_wr_data_ena = (i_btb_mispred | i_btb_new_br);

wire [`BTB_TAG_WIDTH - 1 : 0] btb_tag_nxt = i_btb_new_pc_addr[`CORE_PC_WIDTH - 1 : 4];
wire [`BTB_IDX_WIDTH - 1 : 0] btb_widx = (i_btb_mispred ? i_btb_mis_idx : btb_vld_idx);
wire [`BTB_DATA_WIDTH - 1 : 0] btb_mis_data_nxt = {
                                                    i_btb_mis_taddr
                                                ,   btb_data_r[btb_wr_idx][4 : 0]
                                                };
wire [`BTB_DATA_WIDTH - 1 : 0] btb_new_br_data_nxt = {
                                                        i_btb_new_taddr
                                                    ,   i_btb_new_pc_addr[3 : 0]
                                                    ,   i_btb_new_type
                                                    };
wire [`BTB_DATA_WIDTH - 1 : 0] btb_data_nxt = i_btb_mispred ? btb_mis_data_nxt
                                            : btb_new_br_data_nxt;

wire btb_wren = (btb_wr_tag_ena | btb_wr_data_ena);

//
wire [`BTB_DEPTH - 1 : 0] btb_wr_tag_ena;
wire [`BTB_DEPTH - 1 : 0] btb_wr_data_ena;

genvar j;
generate
    for(j = 0; j < `BTB_DEPTH; j = j + 1) begin
        assign btb_wr_tag_ena[j] = (btb_wr_tag_ena & (j == btb_widx));
        gnrl_dffl #( 
            .DATA_WIDTH(`BTB_TAG_WIDTH)
        ) btb_tag_dffl (btb_wr_tag_ena[j], btb_tag_nxt, btb_tag_r[j], clk);
        
        assign btb_wr_data_ena[j] = (btb_wr_data_ena & (j == btb_widx));
        gnrl_dffl #( 
            .DATA_WIDTH(`BTB_DATA_WIDTH)
        ) btb_data_dffl (btb_wr_data_ena[j], btb_data_nxt, btb_data_r[j], clk);
    end
endgenerate

//  PLRU
wire i_plru_hit = (o_btb_match & i_btb_rden);
wire i_plru_req = (btb_all_vld & i_btb_new_br);

wire [`BTB_IDX_WIDTH - 1 : 0] i_plru_hit_idx = o_btb_idx;
wire [4 : 0] o_btb_plru_idx;

plru_module plru32 ( 
    .i_plru_hit     (i_plru_hit),
    .i_plru_hit_idx (i_plru_hit_idx),
    .i_plru_req     (i_plru_req),
    .o_plru_repl_idx(o_btb_plru_idx),
    .clk            (clk),
    .rst_n          (rst_n) 
);

//  Functions
function [4 : 0] func_find_vec32;
    input [31 : 0] bit_map;

    casex (bit_map)
        32'bxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxx1: func_find_vec32 = 5'd0;
        32'bxxxxxxxxxxxxxxxxxxxxxxxxxxxxxx10: func_find_vec32 = 5'd1;
        32'bxxxxxxxxxxxxxxxxxxxxxxxxxxxxx100: func_find_vec32 = 5'd2;
        32'bxxxxxxxxxxxxxxxxxxxxxxxxxxxx1000: func_find_vec32 = 5'd3;
        32'bxxxxxxxxxxxxxxxxxxxxxxxxxxx10000: func_find_vec32 = 5'd4;
        32'bxxxxxxxxxxxxxxxxxxxxxxxxxx100000: func_find_vec32 = 5'd5;
        32'bxxxxxxxxxxxxxxxxxxxxxxxxx1000000: func_find_vec32 = 5'd6;
        32'bxxxxxxxxxxxxxxxxxxxxxxxx10000000: func_find_vec32 = 5'd7;
        32'bxxxxxxxxxxxxxxxxxxxxxxx100000000: func_find_vec32 = 5'd8;
        32'bxxxxxxxxxxxxxxxxxxxxxx1000000000: func_find_vec32 = 5'd9;
        32'bxxxxxxxxxxxxxxxxxxxxx10000000000: func_find_vec32 = 5'd10;
        32'bxxxxxxxxxxxxxxxxxxxx100000000000: func_find_vec32 = 5'd11;
        32'bxxxxxxxxxxxxxxxxxxx1000000000000: func_find_vec32 = 5'd12;
        32'bxxxxxxxxxxxxxxxxxx10000000000000: func_find_vec32 = 5'd13;
        32'bxxxxxxxxxxxxxxxxx100000000000000: func_find_vec32 = 5'd14;
        32'bxxxxxxxxxxxxxxxx1000000000000000: func_find_vec32 = 5'd15;
        32'bxxxxxxxxxxxxxxx10000000000000000: func_find_vec32 = 5'd16;
        32'bxxxxxxxxxxxxxx100000000000000000: func_find_vec32 = 5'd17;
        32'bxxxxxxxxxxxxx1000000000000000000: func_find_vec32 = 5'd18;
        32'bxxxxxxxxxxxx10000000000000000000: func_find_vec32 = 5'd19;
        32'bxxxxxxxxxxx100000000000000000000: func_find_vec32 = 5'd20;
        32'bxxxxxxxxxx1000000000000000000000: func_find_vec32 = 5'd21;
        32'bxxxxxxxxx10000000000000000000000: func_find_vec32 = 5'd22;
        32'bxxxxxxxx100000000000000000000000: func_find_vec32 = 5'd23;
        32'bxxxxxxx1000000000000000000000000: func_find_vec32 = 5'd24;
        32'bxxxxxx10000000000000000000000000: func_find_vec32 = 5'd25;
        32'bxxxxx100000000000000000000000000: func_find_vec32 = 5'd26;
        32'bxxxx1000000000000000000000000000: func_find_vec32 = 5'd27;
        32'bxxx10000000000000000000000000000: func_find_vec32 = 5'd28;
        32'bxx100000000000000000000000000000: func_find_vec32 = 5'd29;
        32'bx1000000000000000000000000000000: func_find_vec32 = 5'd30;
        32'b10000000000000000000000000000000: func_find_vec32 = 5'd31;
        default:    
            func_find_vec32 = 5'd0;
    endcase

endfunction

function [31 : 0] func_vec32;
    input [4 : 0] index;

    case (index)
        5'd0 : func_vec32 = 32'b00000000000000000000000000000001;
        5'd1 : func_vec32 = 32'b00000000000000000000000000000010;
        5'd2 : func_vec32 = 32'b00000000000000000000000000000100;
        5'd3 : func_vec32 = 32'b00000000000000000000000000001000;
        5'd4 : func_vec32 = 32'b00000000000000000000000000010000;
        5'd5 : func_vec32 = 32'b00000000000000000000000000100000;
        5'd6 : func_vec32 = 32'b00000000000000000000000001000000;
        5'd7 : func_vec32 = 32'b00000000000000000000000010000000;
        5'd8 : func_vec32 = 32'b00000000000000000000000100000000;
        5'd9 : func_vec32 = 32'b00000000000000000000001000000000;
        5'd10: func_vec32 = 32'b00000000000000000000010000000000;
        5'd11: func_vec32 = 32'b00000000000000000000100000000000;
        5'd12: func_vec32 = 32'b00000000000000000001000000000000;
        5'd13: func_vec32 = 32'b00000000000000000010000000000000;
        5'd14: func_vec32 = 32'b00000000000000000100000000000000;
        5'd15: func_vec32 = 32'b00000000000000001000000000000000;
        5'd16: func_vec32 = 32'b00000000000000010000000000000000;
        5'd17: func_vec32 = 32'b00000000000000100000000000000000;
        5'd18: func_vec32 = 32'b00000000000001000000000000000000;
        5'd19: func_vec32 = 32'b00000000000010000000000000000000;
        5'd20: func_vec32 = 32'b00000000000100000000000000000000;
        5'd21: func_vec32 = 32'b00000000001000000000000000000000;
        5'd22: func_vec32 = 32'b00000000010000000000000000000000;
        5'd23: func_vec32 = 32'b00000000100000000000000000000000;
        5'd24: func_vec32 = 32'b00000001000000000000000000000000;
        5'd25: func_vec32 = 32'b00000010000000000000000000000000;
        5'd26: func_vec32 = 32'b00000100000000000000000000000000;
        5'd27: func_vec32 = 32'b00001000000000000000000000000000;
        5'd28: func_vec32 = 32'b00010000000000000000000000000000;
        5'd29: func_vec32 = 32'b00100000000000000000000000000000;
        5'd30: func_vec32 = 32'b01000000000000000000000000000000;
        5'd31: func_vec32 = 32'b10000000000000000000000000000000;
        default: 
            func_vec32 = 32'd0;
    endcase    
endfunction

function [4 : 0] func_vec32_r;
    input [31 : 0] index;

    case (index)
        32'b00000000000000000000000000000001: func_vec32_r = 5'd0;
        32'b00000000000000000000000000000010: func_vec32_r = 5'd1;
        32'b00000000000000000000000000000100: func_vec32_r = 5'd2;
        32'b00000000000000000000000000001000: func_vec32_r = 5'd3;
        32'b00000000000000000000000000010000: func_vec32_r = 5'd4;
        32'b00000000000000000000000000100000: func_vec32_r = 5'd5;
        32'b00000000000000000000000001000000: func_vec32_r = 5'd6;
        32'b00000000000000000000000010000000: func_vec32_r = 5'd7;
        32'b00000000000000000000000100000000: func_vec32_r = 5'd8;
        32'b00000000000000000000001000000000: func_vec32_r = 5'd9;
        32'b00000000000000000000010000000000: func_vec32_r = 5'd10;
        32'b00000000000000000000100000000000: func_vec32_r = 5'd11;
        32'b00000000000000000001000000000000: func_vec32_r = 5'd12;
        32'b00000000000000000010000000000000: func_vec32_r = 5'd13;
        32'b00000000000000000100000000000000: func_vec32_r = 5'd14;
        32'b00000000000000001000000000000000: func_vec32_r = 5'd15;
        32'b00000000000000010000000000000000: func_vec32_r = 5'd16;
        32'b00000000000000100000000000000000: func_vec32_r = 5'd17;
        32'b00000000000001000000000000000000: func_vec32_r = 5'd18;
        32'b00000000000010000000000000000000: func_vec32_r = 5'd19;
        32'b00000000000100000000000000000000: func_vec32_r = 5'd20;
        32'b00000000001000000000000000000000: func_vec32_r = 5'd21;
        32'b00000000010000000000000000000000: func_vec32_r = 5'd22;
        32'b00000000100000000000000000000000: func_vec32_r = 5'd23;
        32'b00000001000000000000000000000000: func_vec32_r = 5'd24;
        32'b00000010000000000000000000000000: func_vec32_r = 5'd25;
        32'b00000100000000000000000000000000: func_vec32_r = 5'd26;
        32'b00001000000000000000000000000000: func_vec32_r = 5'd27;
        32'b00010000000000000000000000000000: func_vec32_r = 5'd28;
        32'b00100000000000000000000000000000: func_vec32_r = 5'd29;
        32'b01000000000000000000000000000000: func_vec32_r = 5'd30;
        32'b10000000000000000000000000000000: func_vec32_r = 5'd31;
        default: 
            func_vec32_r = 5'd0;
    endcase    
endfunction

endmodule   //  btb_module

`endif  /*  !__BPU_BTB_V__! */