`ifdef __DECODE_DEC_REN_V__

module dec_ren_module (
    input                                       i_csr_trap_flush,
    input                                       i_exu_mis_flush,
    input                                       i_exu_ls_flush,
    
    input                                       i_dsp_ren_stall,
    input   [3                          : 0]    i_dec_ren_vld, 
    input                                       i_dec_ren_src1_vld_0,
    input   [`ARF_CODE_WIDTH - 1        : 0]    i_dec_ren_src1_code_0,
    input                                       i_dec_ren_src2_vld_0,
    input   [`ARF_CODE_WIDTH - 1        : 0]    i_dec_ren_src2_code_0,
    input                                       i_dec_ren_src3_vld_0,
    input   [`ARF_CODE_WIDTH - 1        : 0]    i_dec_ren_src3_code_0,
    input                                       i_dec_ren_dst_vld_0,
    input   [`ARF_CODE_WIDTH - 1        : 0]    i_dec_ren_dst_code_0,
    input                                       i_dec_ren_src1_vld_1,
    input   [`ARF_CODE_WIDTH - 1        : 0]    i_dec_ren_src1_code_1,
    input                                       i_dec_ren_src2_vld_1,
    input   [`ARF_CODE_WIDTH - 1        : 0]    i_dec_ren_src2_code_1,
    input                                       i_dec_ren_src3_vld_1,
    input   [`ARF_CODE_WIDTH - 1        : 0]    i_dec_ren_src3_code_1,
    input                                       i_dec_ren_dst_vld_1,
    input   [`ARF_CODE_WIDTH - 1        : 0]    i_dec_ren_dst_code_1,
    input                                       i_dec_ren_src1_vld_2,
    input   [`ARF_CODE_WIDTH - 1        : 0]    i_dec_ren_src1_code_2,
    input                                       i_dec_ren_src2_vld_2,
    input   [`ARF_CODE_WIDTH - 1        : 0]    i_dec_ren_src2_code_2,
    input                                       i_dec_ren_src3_vld_2,
    input   [`ARF_CODE_WIDTH - 1        : 0]    i_dec_ren_src3_code_2,
    input                                       i_dec_ren_dst_vld_2,
    input   [`ARF_CODE_WIDTH - 1        : 0]    i_dec_ren_dst_code_2,
    input                                       i_dec_ren_src1_vld_3,
    input   [`ARF_CODE_WIDTH - 1        : 0]    i_dec_ren_src1_code_3,
    input                                       i_dec_ren_src2_vld_3,
    input   [`ARF_CODE_WIDTH - 1        : 0]    i_dec_ren_src2_code_3,
    input                                       i_dec_ren_src3_vld_3,
    input   [`ARF_CODE_WIDTH - 1        : 0]    i_dec_ren_src3_code_3,
    input                                       i_dec_ren_dst_vld_3,
    input   [`ARF_CODE_WIDTH - 1        : 0]    i_dec_ren_dst_code_3, 

    input   [3                          : 0]    i_rob_ren_ret_vld,
    input   [`ARF_CODE_WIDTH - 1        : 0]    i_rob_ren_ret_arf_code_0,
    input   [`PRF_CODE_WIDTH - 1        : 0]    i_rob_ren_ret_prf_code_0,
    input   [`ARF_CODE_WIDTH - 1        : 0]    i_rob_ren_ret_arf_code_1,
    input   [`PRF_CODE_WIDTH - 1        : 0]    i_rob_ren_ret_prf_code_1,
    input   [`ARF_CODE_WIDTH - 1        : 0]    i_rob_ren_ret_arf_code_2,
    input   [`PRF_CODE_WIDTH - 1        : 0]    i_rob_ren_ret_prf_code_2,
    input   [`ARF_CODE_WIDTH - 1        : 0]    i_rob_ren_ret_arf_code_3,
    input   [`PRF_CODE_WIDTH - 1        : 0]    i_rob_ren_ret_prf_code_3,
    
    input   [3                          : 0]    i_rob_ren_rec_vld,
    input   [`ARF_CODE_WIDTH - 1        : 0]    i_rob_ren_rec_arf_code_0,
    input   [`PRF_CODE_WIDTH - 1        : 0]    i_rob_ren_rec_prf_code_0,
    input   [`ARF_CODE_WIDTH - 1        : 0]    i_rob_ren_rec_arf_code_1,
    input   [`PRF_CODE_WIDTH - 1        : 0]    i_rob_ren_rec_prf_code_1,
    input   [`ARF_CODE_WIDTH - 1        : 0]    i_rob_ren_rec_arf_code_2,
    input   [`PRF_CODE_WIDTH - 1        : 0]    i_rob_ren_rec_prf_code_2,
    input   [`ARF_CODE_WIDTH - 1        : 0]    i_rob_ren_rec_arf_code_3,
    input   [`PRF_CODE_WIDTH - 1        : 0]    i_rob_ren_rec_prf_code_3,

    input   [3                          : 0]    i_rob_ren_mis_vld,
    input   [`ARF_CODE_WIDTH - 1        : 0]    i_rob_ren_mis_arf_code_0,
    input   [`PRF_CODE_WIDTH - 1        : 0]    i_rob_ren_mis_prf_code_0,
    input   [`ARF_CODE_WIDTH - 1        : 0]    i_rob_ren_mis_arf_code_1,
    input   [`PRF_CODE_WIDTH - 1        : 0]    i_rob_ren_mis_prf_code_1,
    input   [`ARF_CODE_WIDTH - 1        : 0]    i_rob_ren_mis_arf_code_2,
    input   [`PRF_CODE_WIDTH - 1        : 0]    i_rob_ren_mis_prf_code_2,
    input   [`ARF_CODE_WIDTH - 1        : 0]    i_rob_ren_mis_arf_code_3,
    input   [`PRF_CODE_WIDTH - 1        : 0]    i_rob_ren_mis_prf_code_3,
    
    output  [`PRF_CODE_WIDTH - 1        : 0]    o_ren_dsp_src1_prf_code_0,
    output  [`PRF_CODE_WIDTH - 1        : 0]    o_ren_dsp_src2_prf_code_0,
    output  [`PRF_CODE_WIDTH - 1        : 0]    o_ren_dsp_src3_prf_code_0,
    output  [`PRF_CODE_WIDTH - 1        : 0]    o_ren_dsp_dst_prf_code_0,
    output  [`PRF_CODE_WIDTH - 1        : 0]    o_ren_dsp_src1_prf_code_1,
    output  [`PRF_CODE_WIDTH - 1        : 0]    o_ren_dsp_src2_prf_code_1,
    output  [`PRF_CODE_WIDTH - 1        : 0]    o_ren_dsp_src3_prf_code_1,
    output  [`PRF_CODE_WIDTH - 1        : 0]    o_ren_dsp_dst_prf_code_1,
    output  [`PRF_CODE_WIDTH - 1        : 0]    o_ren_dsp_src1_prf_code_2,
    output  [`PRF_CODE_WIDTH - 1        : 0]    o_ren_dsp_src2_prf_code_2,
    output  [`PRF_CODE_WIDTH - 1        : 0]    o_ren_dsp_src3_prf_code_2,
    output  [`PRF_CODE_WIDTH - 1        : 0]    o_ren_dsp_dst_prf_code_2,
    output  [`PRF_CODE_WIDTH - 1        : 0]    o_ren_dsp_src1_prf_code_3,
    output  [`PRF_CODE_WIDTH - 1        : 0]    o_ren_dsp_src2_prf_code_3,
    output  [`PRF_CODE_WIDTH - 1        : 0]    o_ren_dsp_src3_prf_code_3,
    output  [`PRF_CODE_WIDTH - 1        : 0]    o_ren_dsp_dst_prf_code_3,
    output  [`PRF_CODE_WIDTH - 1        : 0]    o_ren_dsp_pprf_code_0,
    output  [`PRF_CODE_WIDTH - 1        : 0]    o_ren_dsp_pprf_code_1,
    output  [`PRF_CODE_WIDTH - 1        : 0]    o_ren_dsp_pprf_code_2,
    output  [`PRF_CODE_WIDTH - 1        : 0]    o_ren_dsp_pprf_code_3,
    output                                      o_ren_dec_stall,
    
    output                                      o_ren_prf_free_req_0,
    output                                      o_ren_prf_free_req_1,
    output                                      o_ren_prf_free_req_2,
    output                                      o_ren_prf_free_req_3,
    output  [`PRF_CODE_WIDTH - 1        : 0]    o_ren_prf_code_0,
    output  [`PRF_CODE_WIDTH - 1        : 0]    o_ren_prf_code_1,
    output  [`PRF_CODE_WIDTH - 1        : 0]    o_ren_prf_code_2,
    output  [`PRF_CODE_WIDTH - 1        : 0]    o_ren_prf_code_3,
    
    input                                       clk,
    input                                       rst_n
);

wire i_ren_need_flush = (i_csr_trap_flush | i_exu_ls_flush | i_exu_mis_flush);

//
assign o_ren_prf_free_req_0 = (i_dec_ren_vld[0] & i_dec_ren_dst_vld_0 & (~i_dsp_ren_stall));
assign o_ren_prf_free_req_1 = (i_dec_ren_vld[1] & i_dec_ren_dst_vld_1 & (~i_dsp_ren_stall));
assign o_ren_prf_free_req_2 = (i_dec_ren_vld[2] & i_dec_ren_dst_vld_2 & (~i_dsp_ren_stall));
assign o_ren_prf_free_req_3 = (i_dec_ren_vld[3] & i_dec_ren_dst_vld_3 & (~i_dsp_ren_stall));

//
wire [`PRF_CODE_WIDTH - 1 : 0] o_flush_prf_code [31 : 0];

//  ARAT
wire [3 : 0] i_arat_wren_vec;
wire [`PRF_CODE_WIDTH - 1 : 0] o_arat_ret_prf_code_0, o_arat_ret_prf_code_1, o_arat_ret_prf_code_2, o_arat_ret_prf_code_3;

assign i_arat_wren_vec[0] = (i_rob_ren_ret_vld[0]
                          & (~((i_rob_ren_ret_arf_code_0 == i_rob_ren_ret_arf_code_1) & i_rob_ren_ret_vld[1]))
                          & (~((i_rob_ren_ret_arf_code_0 == i_rob_ren_ret_arf_code_2) & i_rob_ren_ret_vld[2]))
                          & (~((i_rob_ren_ret_arf_code_0 == i_rob_ren_ret_arf_code_3) & i_rob_ren_ret_vld[3])));
assign i_arat_wren_vec[1] = (i_rob_ren_ret_vld[1]
                          & (~((i_rob_ren_ret_arf_code_1 == i_rob_ren_ret_arf_code_2) & i_rob_ren_ret_vld[2]))
                          & (~((i_rob_ren_ret_arf_code_1 == i_rob_ren_ret_arf_code_3) & i_rob_ren_ret_vld[3])));
assign i_arat_wren_vec[2] = (i_rob_ren_ret_vld[2]
                          & (~((i_rob_ren_ret_arf_code_2 == i_rob_ren_ret_arf_code_3) & i_rob_ren_ret_vld[3])));
assign i_arat_wren_vec[3] = i_rob_ren_ret_vld[3];

dec_arat_module arch_rat (
    .i_arat_wren_0           (i_arat_wren_vec[0]),
    .i_arat_wr_dst_code_0    (i_rob_ren_ret_arf_code_0),
    .i_arat_wr_prf_code_0    (i_rob_ren_ret_prf_code_0),
    .i_arat_wren_1           (i_arat_wren_vec[1]),
    .i_arat_wr_dst_code_1    (i_rob_ren_ret_arf_code_1),
    .i_arat_wr_prf_code_1    (i_rob_ren_ret_prf_code_1),
    .i_arat_wren_2           (i_arat_wren_vec[2]),
    .i_arat_wr_dst_code_2    (i_rob_ren_ret_arf_code_2),
    .i_arat_wr_prf_code_2    (i_rob_ren_ret_prf_code_2),
    .i_arat_wren_3           (i_arat_wren_vec[3]),
    .i_arat_wr_dst_code_3    (i_rob_ren_ret_arf_code_3),
    .i_arat_wr_prf_code_3    (i_rob_ren_ret_prf_code_3),
    
    .o_arat_ret_prf_code_0   (o_arat_ret_prf_code_0),
    .o_arat_ret_prf_code_1   (o_arat_ret_prf_code_1),
    .o_arat_ret_prf_code_2   (o_arat_ret_prf_code_2),
    .o_arat_ret_prf_code_3   (o_arat_ret_prf_code_3),
    
    .o_arat_flush_prf_code_0 (o_flush_prf_code[0]),
    .o_arat_flush_prf_code_1 (o_flush_prf_code[1]),
    .o_arat_flush_prf_code_2 (o_flush_prf_code[2]),
    .o_arat_flush_prf_code_3 (o_flush_prf_code[3]),
    .o_arat_flush_prf_code_4 (o_flush_prf_code[4]),
    .o_arat_flush_prf_code_5 (o_flush_prf_code[5]),
    .o_arat_flush_prf_code_6 (o_flush_prf_code[6]),
    .o_arat_flush_prf_code_7 (o_flush_prf_code[7]),
    .o_arat_flush_prf_code_8 (o_flush_prf_code[8]),
    .o_arat_flush_prf_code_9 (o_flush_prf_code[9]),
    .o_arat_flush_prf_code_10(o_flush_prf_code[10]),
    .o_arat_flush_prf_code_11(o_flush_prf_code[11]),
    .o_arat_flush_prf_code_12(o_flush_prf_code[12]),
    .o_arat_flush_prf_code_13(o_flush_prf_code[13]),
    .o_arat_flush_prf_code_14(o_flush_prf_code[14]),
    .o_arat_flush_prf_code_15(o_flush_prf_code[15]),
    .o_arat_flush_prf_code_16(o_flush_prf_code[16]),
    .o_arat_flush_prf_code_17(o_flush_prf_code[17]),
    .o_arat_flush_prf_code_18(o_flush_prf_code[18]),
    .o_arat_flush_prf_code_19(o_flush_prf_code[19]),
    .o_arat_flush_prf_code_20(o_flush_prf_code[20]),
    .o_arat_flush_prf_code_21(o_flush_prf_code[21]),
    .o_arat_flush_prf_code_22(o_flush_prf_code[22]),
    .o_arat_flush_prf_code_23(o_flush_prf_code[23]),
    .o_arat_flush_prf_code_24(o_flush_prf_code[24]),
    .o_arat_flush_prf_code_25(o_flush_prf_code[25]),
    .o_arat_flush_prf_code_26(o_flush_prf_code[26]),
    .o_arat_flush_prf_code_27(o_flush_prf_code[27]),
    .o_arat_flush_prf_code_28(o_flush_prf_code[28]),
    .o_arat_flush_prf_code_29(o_flush_prf_code[29]),
    .o_arat_flush_prf_code_30(o_flush_prf_code[30]),
    .o_arat_flush_prf_code_31(o_flush_prf_code[31]),
    
    .clk                    (clk),
    .rst_n                  (rst_n)
);

//  SRAT
wire [3 : 0] i_srat_wren_vec;
wire [`ARF_CODE_WIDTH - 1 : 0] i_srat_wr_dst_code_0;
wire [`ARF_CODE_WIDTH - 1 : 0] i_srat_wr_dst_code_1;
wire [`ARF_CODE_WIDTH - 1 : 0] i_srat_wr_dst_code_2;
wire [`ARF_CODE_WIDTH - 1 : 0] i_srat_wr_dst_code_3;

wire [`PRF_CODE_WIDTH - 1 : 0] i_srat_wr_prf_code_0;
wire [`PRF_CODE_WIDTH - 1 : 0] i_srat_wr_prf_code_1;
wire [`PRF_CODE_WIDTH - 1 : 0] i_srat_wr_prf_code_2;
wire [`PRF_CODE_WIDTH - 1 : 0] i_srat_wr_prf_code_3;

wire [`PRF_CODE_WIDTH - 1 : 0] o_src1_prf_code_0, o_src1_prf_code_1, o_src1_prf_code_2, o_src1_prf_code_3;
wire [`PRF_CODE_WIDTH - 1 : 0] o_src2_prf_code_0, o_src2_prf_code_1, o_src2_prf_code_2, o_src2_prf_code_3;
wire [`PRF_CODE_WIDTH - 1 : 0] o_src3_prf_code_0, o_src3_prf_code_1, o_src3_prf_code_2, o_src3_prf_code_3;

dec_srat_module spec_rat ( 
    .i_srat_src1_arf_code_0  (i_dec_ren_src1_code_0),
    .i_srat_src2_arf_code_0  (i_dec_ren_src2_code_0),
    .i_srat_src3_arf_code_0  (i_dec_ren_src3_code_0),
    .i_srat_src1_arf_code_1  (i_dec_ren_src1_code_1),
    .i_srat_src2_arf_code_1  (i_dec_ren_src2_code_1),
    .i_srat_src3_arf_code_1  (i_dec_ren_src3_code_1),
    .i_srat_src1_arf_code_2  (i_dec_ren_src1_code_2),
    .i_srat_src2_arf_code_2  (i_dec_ren_src2_code_2),
    .i_srat_src3_arf_code_2  (i_dec_ren_src3_code_2),
    .i_srat_src1_arf_code_3  (i_dec_ren_src1_code_3),
    .i_srat_src2_arf_code_3  (i_dec_ren_src2_code_3),
    .i_srat_src3_arf_code_3  (i_dec_ren_src3_code_3),
    
    .o_srat_src1_prf_code_0  (o_src1_prf_code_0),
    .o_srat_src2_prf_code_0  (o_src2_prf_code_0),
    .o_srat_src3_prf_code_0  (o_src3_prf_code_0),
    .o_srat_src1_prf_code_1  (o_src1_prf_code_1),
    .o_srat_src2_prf_code_1  (o_src2_prf_code_1),
    .o_srat_src3_prf_code_1  (o_src3_prf_code_1),
    .o_srat_src1_prf_code_2  (o_src1_prf_code_2),
    .o_srat_src2_prf_code_2  (o_src2_prf_code_2),
    .o_srat_src3_prf_code_2  (o_src3_prf_code_2),
    .o_srat_src1_prf_code_3  (o_src1_prf_code_3),
    .o_srat_src2_prf_code_3  (o_src2_prf_code_3),
    .o_srat_src3_prf_code_3  (o_src3_prf_code_3),
    
    .i_srat_wren_0           (i_srat_wren_vec[0]),
    .i_srat_wr_dst_code_0    (i_srat_wr_dst_code_0),
    .i_srat_wr_prf_code_0    (i_srat_wr_prf_code_0),
    .i_srat_wren_1           (i_srat_wren_vec[1]),
    .i_srat_wr_dst_code_1    (i_srat_wr_dst_code_1),
    .i_srat_wr_prf_code_1    (i_srat_wr_prf_code_1),
    .i_srat_wren_2           (i_srat_wren_vec[2]),
    .i_srat_wr_dst_code_2    (i_srat_wr_dst_code_2),
    .i_srat_wr_prf_code_2    (i_srat_wr_prf_code_2),
    .i_srat_wren_3           (i_srat_wren_vec[3]),
    .i_srat_wr_dst_code_3    (i_srat_wr_dst_code_3),
    .i_srat_wr_prf_code_3    (i_srat_wr_prf_code_3),
    
    .o_srat_wr_pprf_code_0   (o_ren_dsp_pprf_code_0),
    .o_srat_wr_pprf_code_1   (o_ren_dsp_pprf_code_1),
    .o_srat_wr_pprf_code_2   (o_ren_dsp_pprf_code_2),
    .o_srat_wr_pprf_code_3   (o_ren_dsp_pprf_code_3),
    
    .i_srat_except_flush     (i_ren_need_flush),
    .i_srat_flush_prf_code_0 (o_flush_prf_code[0]),
    .i_srat_flush_prf_code_1 (o_flush_prf_code[1]),
    .i_srat_flush_prf_code_2 (o_flush_prf_code[2]),
    .i_srat_flush_prf_code_3 (o_flush_prf_code[3]),
    .i_srat_flush_prf_code_4 (o_flush_prf_code[4]),
    .i_srat_flush_prf_code_5 (o_flush_prf_code[5]),
    .i_srat_flush_prf_code_6 (o_flush_prf_code[6]),
    .i_srat_flush_prf_code_7 (o_flush_prf_code[7]),
    .i_srat_flush_prf_code_8 (o_flush_prf_code[8]),
    .i_srat_flush_prf_code_9 (o_flush_prf_code[9]),
    .i_srat_flush_prf_code_10(o_flush_prf_code[10]),
    .i_srat_flush_prf_code_11(o_flush_prf_code[11]),
    .i_srat_flush_prf_code_12(o_flush_prf_code[12]),
    .i_srat_flush_prf_code_13(o_flush_prf_code[13]),
    .i_srat_flush_prf_code_14(o_flush_prf_code[14]),
    .i_srat_flush_prf_code_15(o_flush_prf_code[15]),
    .i_srat_flush_prf_code_16(o_flush_prf_code[16]),
    .i_srat_flush_prf_code_17(o_flush_prf_code[17]),
    .i_srat_flush_prf_code_18(o_flush_prf_code[18]),
    .i_srat_flush_prf_code_19(o_flush_prf_code[19]),
    .i_srat_flush_prf_code_20(o_flush_prf_code[20]),
    .i_srat_flush_prf_code_21(o_flush_prf_code[21]),
    .i_srat_flush_prf_code_22(o_flush_prf_code[22]),
    .i_srat_flush_prf_code_23(o_flush_prf_code[23]),
    .i_srat_flush_prf_code_24(o_flush_prf_code[24]),
    .i_srat_flush_prf_code_25(o_flush_prf_code[25]),
    .i_srat_flush_prf_code_26(o_flush_prf_code[26]),
    .i_srat_flush_prf_code_27(o_flush_prf_code[27]),
    .i_srat_flush_prf_code_28(o_flush_prf_code[28]),
    .i_srat_flush_prf_code_29(o_flush_prf_code[29]),
    .i_srat_flush_prf_code_30(o_flush_prf_code[30]),
    .i_srat_flush_prf_code_31(o_flush_prf_code[31]),
    
    .clk                     (clk),
    .rst_n                   (rst_n)
);

// Instr 0
assign o_ren_dsp_src1_prf_code_0 = o_src1_prf_code_0;
assign o_ren_dsp_src2_prf_code_0 = o_src2_prf_code_0;
assign o_ren_dsp_src3_prf_code_0 = o_src3_prf_code_0;

// Instr 1
wire src1_sel_0 = ((i_dec_ren_src1_vld_1 & (i_dec_ren_src1_code_1 == i_dec_ren_dst_code_0)) & o_ren_prf_free_req_0);
wire src2_sel_0 = ((i_dec_ren_src2_vld_1 & (i_dec_ren_src2_code_1 == i_dec_ren_dst_code_0)) & o_ren_prf_free_req_0);
wire src3_sel_0 = ((i_dec_ren_src3_vld_1 & (i_dec_ren_src3_code_1 == i_dec_ren_dst_code_0)) & o_ren_prf_free_req_0);

assign o_ren_dsp_src1_prf_code_1 = (src1_sel_0 ? o_ren_prf_code_0 : o_src1_prf_code_1);
assign o_ren_dsp_src2_prf_code_1 = (src2_sel_0 ? o_ren_prf_code_0 : o_src2_prf_code_1);
assign o_ren_dsp_src3_prf_code_1 = (src3_sel_0 ? o_ren_prf_code_0 : o_src3_prf_code_1);

// Instr 2
wire [1 : 0] src1_sel_1 = {
                                (i_dec_ren_src1_vld_2 & (i_dec_ren_src1_code_2 == i_dec_ren_dst_code_1) & o_ren_prf_free_req_1)
                            ,   (i_dec_ren_src1_vld_2 & (i_dec_ren_src1_code_2 == i_dec_ren_dst_code_0) & o_ren_prf_free_req_0)
                        };
wire [1 : 0] src2_sel_1 = {
                                (i_dec_ren_src2_vld_2 & (i_dec_ren_src2_code_2 == i_dec_ren_dst_code_1) & o_ren_prf_free_req_1)
                            ,   (i_dec_ren_src2_vld_2 & (i_dec_ren_src2_code_2 == i_dec_ren_dst_code_0) & o_ren_prf_free_req_0)
                        };
wire [1 : 0] src3_sel_1 = {
                                (i_dec_ren_src3_vld_2 & (i_dec_ren_src3_code_2 == i_dec_ren_dst_code_1) & o_ren_prf_free_req_1)
                            ,   (i_dec_ren_src3_vld_2 & (i_dec_ren_src3_code_2 == i_dec_ren_dst_code_0) & o_ren_prf_free_req_0)
                        };

wire [2 : 0] src1_case_1 = {
                                (src1_sel_1[1 : 0] == 2'b00)
                            ,   ((~src1_sel_1[1]) & src1_sel_1[0])
                            ,   src1_sel_1[1]
                        };
wire [2 : 0] src2_case_1 = {
                                (src2_sel_1[1 : 0] == 2'b00)
                            ,   ((~src2_sel_1[1]) & src2_sel_1[0])
                            ,   src2_sel_1[1]
                        };

wire [2 : 0] src3_case_1 = {
                                (src3_sel_1[1 : 0] == 2'b00)
                            ,   ((~src3_sel_1[1]) & src3_sel_1[0])
                            ,   src3_sel_1[1]
                        };

assign o_ren_dsp_src1_prf_code_2 = ({`PRF_CODE_WIDTH{src1_case_1[0]}} & o_ren_prf_code_1 )
                                 | ({`PRF_CODE_WIDTH{src1_case_1[1]}} & o_ren_prf_code_0 )
                                 | ({`PRF_CODE_WIDTH{src1_case_1[2]}} & o_src1_prf_code_2);
assign o_ren_dsp_src2_prf_code_2 = ({`PRF_CODE_WIDTH{src2_case_1[0]}} & o_ren_prf_code_1 )
                                 | ({`PRF_CODE_WIDTH{src2_case_1[1]}} & o_ren_prf_code_0 )
                                 | ({`PRF_CODE_WIDTH{src2_case_1[2]}} & o_src2_prf_code_2);
assign o_ren_dsp_src3_prf_code_2 = ({`PRF_CODE_WIDTH{src3_case_1[0]}} & o_ren_prf_code_1 )
                                 | ({`PRF_CODE_WIDTH{src3_case_1[1]}} & o_ren_prf_code_0 )
                                 | ({`PRF_CODE_WIDTH{src3_case_1[2]}} & o_src3_prf_code_2);

//  Instr 3
wire [2 : 0] src1_sel_2 = {
                            (i_dec_ren_src1_vld_3 & (i_dec_ren_src1_code_3 == i_dec_ren_dst_code_2) & o_ren_prf_free_req_2)
                        ,   (i_dec_ren_src1_vld_3 & (i_dec_ren_src1_code_3 == i_dec_ren_dst_code_1) & o_ren_prf_free_req_1)
                        ,   (i_dec_ren_src1_vld_3 & (i_dec_ren_src1_code_3 == i_dec_ren_dst_code_0) & o_ren_prf_free_req_0)
                        };

wire [2 : 0] src2_sel_2 = {
                            (i_dec_ren_src2_vld_3 & (i_dec_ren_src2_code_3 == i_dec_ren_dst_code_2) & o_ren_prf_free_req_2)
                        ,   (i_dec_ren_src2_vld_3 & (i_dec_ren_src2_code_3 == i_dec_ren_dst_code_1) & o_ren_prf_free_req_1)
                        ,   (i_dec_ren_src2_vld_3 & (i_dec_ren_src2_code_3 == i_dec_ren_dst_code_0) & o_ren_prf_free_req_0)
                        };

wire [2 : 0] src3_sel_2 = {
                            (i_dec_ren_src3_vld_3 & (i_dec_ren_src3_code_3 == i_dec_ren_dst_code_2) & o_ren_prf_free_req_2)
                        ,   (i_dec_ren_src3_vld_3 & (i_dec_ren_src3_code_3 == i_dec_ren_dst_code_1) & o_ren_prf_free_req_1)
                        ,   (i_dec_ren_src3_vld_3 & (i_dec_ren_src3_code_3 == i_dec_ren_dst_code_0) & o_ren_prf_free_req_0)
                        };

wire [3 : 0] src1_case_2 = {
                                (src1_sel_2[2 : 0] == 3'b000)
                            ,   (src1_sel_2[2 : 0] == 3'b001)
                            ,   ((~src1_sel_2[2]) & src1_sel_2[1])
                            ,   src1_sel_2[2]
                        };

wire [3 : 0] src2_case_2 = {
                                (src2_sel_2[2 : 0] == 3'b000)
                            ,   (src2_sel_2[2 : 0] == 3'b001)
                            ,   ((~src2_sel_2[2]) & src2_sel_2[1])
                            ,   src2_sel_2[2]
                        };
wire [3 : 0] src3_case_2 = {
                                (src3_sel_2[2 : 0] == 3'b000)
                            ,   (src3_sel_2[2 : 0] == 3'b001)
                            ,   ((~src3_sel_2[2]) & src3_sel_2[1])
                            ,   src3_sel_2[2]
                        };

assign o_ren_dsp_src1_prf_code_3 = ({`PRF_CODE_WIDTH{src1_case_2[0]}} & o_ren_prf_code_2 )
                                 | ({`PRF_CODE_WIDTH{src1_case_2[1]}} & o_ren_prf_code_1 )
                                 | ({`PRF_CODE_WIDTH{src1_case_2[2]}} & o_ren_prf_code_0 )
                                 | ({`PRF_CODE_WIDTH{src1_case_2[3]}} & o_src1_prf_code_3);
assign o_ren_dsp_src2_prf_code_3 = ({`PRF_CODE_WIDTH{src2_case_2[0]}} & o_ren_prf_code_2 )
                                 | ({`PRF_CODE_WIDTH{src2_case_2[1]}} & o_ren_prf_code_1 )
                                 | ({`PRF_CODE_WIDTH{src2_case_2[2]}} & o_ren_prf_code_0 )
                                 | ({`PRF_CODE_WIDTH{src2_case_2[3]}} & o_src2_prf_code_3);
assign o_ren_dsp_src3_prf_code_3 = ({`PRF_CODE_WIDTH{src3_case_2[0]}} & o_ren_prf_code_2 )
                                 | ({`PRF_CODE_WIDTH{src3_case_2[1]}} & o_ren_prf_code_1 )
                                 | ({`PRF_CODE_WIDTH{src3_case_2[2]}} & o_ren_prf_code_0 )
                                 | ({`PRF_CODE_WIDTH{src3_case_2[3]}} & o_src3_prf_code_3);


//
assign i_srat_wren_vec[0] = (((o_ren_prf_free_req_0 & (~o_fl_stall))
                          &  (~((i_dec_ren_dst_code_0 == i_dec_ren_dst_code_1) & o_ren_prf_free_req_1))
                          &  (~((i_dec_ren_dst_code_0 == i_dec_ren_dst_code_2) & o_ren_prf_free_req_2))
                          &  (~((i_dec_ren_dst_code_0 == i_dec_ren_dst_code_3) & o_ren_prf_free_req_3)))
                          | i_rob_ren_rec_vld[0]);

assign i_srat_wren_vec[1] = (((o_ren_prf_free_req_1 & (~o_fl_stall))
                          &  (~((i_dec_ren_dst_code_1 == i_dec_ren_dst_code_2) & o_ren_prf_free_req_2))
                          &  (~((i_dec_ren_dst_code_1 == i_dec_ren_dst_code_3) & o_ren_prf_free_req_3)))
                          |  (((~i_rob_ren_rec_vld[0]) | (i_rob_ren_rec_arf_code_0 != i_rob_ren_rec_arf_code_1)) 
                          & i_rob_ren_rec_vld[1]));

assign i_srat_wren_vec[2] = (((o_ren_prf_free_req_2 & (~o_fl_stall))
                          &  (~((i_dec_ren_dst_code_2 == i_dec_ren_dst_code_3) & o_ren_prf_free_req_3)))
                          |  (((~i_rob_ren_rec_vld[0]) | (i_rob_ren_rec_arf_code_0 != i_rob_ren_rec_arf_code_2))
                          &  ((~i_rob_ren_rec_vld[1]) | (i_rob_ren_rec_arf_code_1 != i_rob_ren_rec_arf_code_2))
                          & i_rob_ren_rec_vld[2]));

assign i_srat_wren_vec[3] = ((o_ren_prf_free_req_3 & (~o_fl_stall))
                          |  (((~i_rob_ren_rec_vld[0]) | (i_rob_ren_rec_arf_code_0 != i_rob_ren_rec_arf_code_3))
                          &   ((~i_rob_ren_rec_vld[1]) | (i_rob_ren_rec_arf_code_1 != i_rob_ren_rec_arf_code_3))
                          &   ((~i_rob_ren_rec_vld[2]) | (i_rob_ren_rec_arf_code_2 != i_rob_ren_rec_arf_code_3))
                          &  i_rob_ren_rec_vld[3]));

assign i_srat_wr_dst_code_0 = (i_rob_ren_rec_vld[0] ? i_rob_ren_rec_arf_code_0 : i_dec_ren_dst_code_0);
assign i_srat_wr_dst_code_1 = (i_rob_ren_rec_vld[1] ? i_rob_ren_rec_arf_code_1 : i_dec_ren_dst_code_1);
assign i_srat_wr_dst_code_2 = (i_rob_ren_rec_vld[2] ? i_rob_ren_rec_arf_code_2 : i_dec_ren_dst_code_2);
assign i_srat_wr_dst_code_3 = (i_rob_ren_rec_vld[3] ? i_rob_ren_rec_arf_code_3 : i_dec_ren_dst_code_3);

assign i_srat_wr_prf_code_0 = (i_rob_ren_rec_vld[0] ? i_rob_ren_rec_prf_code_0 : o_ren_prf_code_0);
assign i_srat_wr_prf_code_1 = (i_rob_ren_rec_vld[1] ? i_rob_ren_rec_prf_code_1 : o_ren_prf_code_1);
assign i_srat_wr_prf_code_2 = (i_rob_ren_rec_vld[2] ? i_rob_ren_rec_prf_code_2 : o_ren_prf_code_2);
assign i_srat_wr_prf_code_3 = (i_rob_ren_rec_vld[3] ? i_rob_ren_rec_prf_code_3 : o_ren_prf_code_3);

//  Freelist
wire o_fl_stall;
wire [3 : 0] i_fl_wren_vec;
wire [`PRF_CODE_WIDTH - 1 : 0] i_fl_wr_prf_code_0, i_fl_wr_prf_code_1, i_fl_wr_prf_code_2, i_fl_wr_prf_code_3;

dec_freelist_module freelist ( 
    .i_fl_req_0        (o_ren_prf_free_req_0),
    .i_fl_req_1        (o_ren_prf_free_req_1),
    .i_fl_req_2        (o_ren_prf_free_req_2),
    .i_fl_req_3        (o_ren_prf_free_req_3),

    .o_fl_prf_code_0   (o_ren_prf_code_0),
    .o_fl_prf_code_1   (o_ren_prf_code_1),
    .o_fl_prf_code_2   (o_ren_prf_code_2),
    .o_fl_prf_code_3   (o_ren_prf_code_3),

    .o_fl_stall        (o_fl_stall),

    .i_fl_wren_0       (i_fl_wren_vec[0]),
    .i_fl_wren_1       (i_fl_wren_vec[1]),
    .i_fl_wren_2       (i_fl_wren_vec[2]),
    .i_fl_wren_3       (i_fl_wren_vec[3]),

    .i_fl_wr_prf_code_0(i_fl_wr_prf_code_0),
    .i_fl_wr_prf_code_1(i_fl_wr_prf_code_1),
    .i_fl_wr_prf_code_2(i_fl_wr_prf_code_2),
    .i_fl_wr_prf_code_3(i_fl_wr_prf_code_3),

    .clk               (clk),
    .rst_n             (rst_n)
);


assign i_fl_wren_vec = (i_rob_ren_ret_vld | i_rob_ren_mis_vld);

wire [1 : 0] fl_wr_sel_0;
assign fl_wr_sel_0[0] = (i_rob_ren_ret_vld[0]
                      & (((i_rob_ren_ret_arf_code_0 == i_rob_ren_ret_arf_code_1) & i_rob_ren_ret_vld[1])
                      |  ((i_rob_ren_ret_arf_code_0 == i_rob_ren_ret_arf_code_2) & i_rob_ren_ret_vld[2])
                      |  ((i_rob_ren_ret_arf_code_0 == i_rob_ren_ret_arf_code_3) & i_rob_ren_ret_vld[3])));
assign fl_wr_sel_0[1] = (i_rob_ren_ret_vld[0]
                      & (~((i_rob_ren_ret_arf_code_0 == i_rob_ren_ret_arf_code_1) & i_rob_ren_ret_vld[1]))
                      & (~((i_rob_ren_ret_arf_code_0 == i_rob_ren_ret_arf_code_2) & i_rob_ren_ret_vld[2]))
                      & (~((i_rob_ren_ret_arf_code_0 == i_rob_ren_ret_arf_code_3) & i_rob_ren_ret_vld[3])));

wire [1 : 0] fl_wr_sel_1;
assign fl_wr_sel_1[0] = (i_rob_ren_ret_vld[1]
                      & (((i_rob_ren_ret_arf_code_1 == i_rob_ren_ret_arf_code_2) & i_rob_ren_ret_vld[2])
                      |  ((i_rob_ren_ret_arf_code_1 == i_rob_ren_ret_arf_code_3) & i_rob_ren_ret_vld[3])));
assign fl_wr_sel_1[1] = (i_rob_ren_ret_vld[1]
                      & (~((i_rob_ren_ret_arf_code_1 == i_rob_ren_ret_arf_code_2) & i_rob_ren_ret_vld[2]))
                      & (~((i_rob_ren_ret_arf_code_1 == i_rob_ren_ret_arf_code_3) & i_rob_ren_ret_vld[3])));


wire [1 : 0] fl_wr_sel_2;
assign fl_wr_sel_2[0] = (i_rob_ren_ret_vld[2]
                      & (((i_rob_ren_ret_arf_code_2 == i_rob_ren_ret_arf_code_3) & i_rob_ren_ret_vld[3])));
assign fl_wr_sel_2[1] = (i_rob_ren_ret_vld[2]
                      & (~((i_rob_ren_ret_arf_code_2 == i_rob_ren_ret_arf_code_3) & i_rob_ren_ret_vld[3])));

wire [2 : 0] fl_wr_case_0 = { 
                                (fl_wr_sel_0[1 : 0] == 2'b10)
                            ,   (fl_wr_sel_0[1 : 0] == 2'b01)
                            ,   (fl_wr_sel_0[1 : 0] == 2'b00)
                            };
assign i_fl_wr_prf_code_0 = ({`PRF_CODE_WIDTH{fl_wr_case_0[0]}} & o_arat_ret_prf_code_0   )
                          | ({`PRF_CODE_WIDTH{fl_wr_case_0[1]}} & i_rob_ren_ret_arf_code_0)
                          | ({`PRF_CODE_WIDTH{fl_wr_case_0[2]}} & i_rob_ren_mis_arf_code_0);

assign [2 : 0] fl_wr_case_1 = {
                                (fl_wr_sel_1[1 : 0] == 2'b10)
                            ,   (fl_wr_sel_1[1 : 0] == 2'b01)
                            ,   (fl_wr_sel_1[1 : 0] == 2'b00)
                            };
assign i_fl_wr_prf_code_1 = ({`PRF_CODE_WIDTH{fl_wr_case_1[0]}} & o_arat_ret_prf_code_1   )
                          | ({`PRF_CODE_WIDTH{fl_wr_case_1[1]}} & i_rob_ren_ret_arf_code_1)
                          | ({`PRF_CODE_WIDTH{fl_wr_case_1[2]}} & i_rob_ren_mis_arf_code_1);

assign [2 : 0] fl_wr_case_2 = {
                                (fl_wr_sel_2[1 : 0] == 2'b10)
                            ,   (fl_wr_sel_2[1 : 0] == 2'b01)
                            ,   (fl_wr_sel_2[1 : 0] == 2'b00)
                            };
assign i_fl_wr_prf_code_2 = ({`PRF_CODE_WIDTH{fl_wr_case_2[0]}} & o_arat_ret_prf_code_2   )
                          | ({`PRF_CODE_WIDTH{fl_wr_case_2[1]}} & i_rob_ren_ret_arf_code_2)
                          | ({`PRF_CODE_WIDTH{fl_wr_case_2[2]}} & i_rob_ren_mis_arf_code_2);


assign i_fl_wr_prf_code_3 = (i_rob_ren_ret_vld[3] ? o_arat_ret_prf_code_3 : i_rob_ren_mis_arf_code_3);

assign {
        o_ren_dsp_dst_prf_code_3
    ,   o_ren_dsp_dst_prf_code_2 
    ,   o_ren_dsp_dst_prf_code_1
    ,   o_ren_dsp_dst_prf_code_0 
} = { 
        o_ren_prf_code_3
    ,   o_ren_prf_code_2
    ,   o_ren_prf_code_1
    ,   o_ren_prf_code_0
};

assign o_ren_dec_stall = (o_fl_stall | i_dsp_ren_stall);

endmodule   //  dec_ren_module

`endif  /*  !__DECODE_DEC_REN_V__!   */