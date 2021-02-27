`ifdef __DECODE_DEC_DECODE_V__

module dec_decode_module (
    input                                       i_csr_trap_flush,
    input                                       i_exu_mis_flush,
    input   [`ROB_ENTRY_WIDTH - 1       : 0]    i_exu_mis_rob_id,
    input                                       i_exu_ls_flush,
    input   [`ROB_ENTRY_WIDTH - 1       : 0]    i_exu_ls_rob_id,

    input   [3                          : 0]    i_iq_dec_vld,
    input   [`EXCEPTION_CODE_WIDTH - 1  : 0]    i_iq_dec_excp_code_0,
    input   [`EXCEPTION_CODE_WIDTH - 1  : 0]    i_iq_dec_excp_code_1,
    input   [`EXCEPTION_CODE_WIDTH - 1  : 0]    i_iq_dec_excp_code_2,
    input   [`EXCEPTION_CODE_WIDTH - 1  : 0]    i_iq_dec_excp_code_3,

    input   [`INSTR_WIDTH - 1           : 0]    i_iq_dec_instr_0,
    input   [`INSTR_WIDTH - 1           : 0]    i_iq_dec_instr_1,
    input   [`INSTR_WIDTH - 1           : 0]    i_iq_dec_instr_2,
    input   [`INSTR_WIDTH - 1           : 0]    i_iq_dec_instr_3,

    input   [`CORE_PC_WIDTH - 1         : 0]    i_iq_dec_addr_0,
    input   [`CORE_PC_WIDTH - 1         : 0]    i_iq_dec_addr_1,
    input   [`CORE_PC_WIDTH - 1         : 0]    i_iq_dec_addr_2,
    input   [`CORE_PC_WIDTH - 1         : 0]    i_iq_dec_addr_3,
    input   [`CORE_PC_WIDTH - 1         : 0]    i_iq_dec_taddr_0,
    input   [`CORE_PC_WIDTH - 1         : 0]    i_iq_dec_taddr_1,
    input   [`CORE_PC_WIDTH - 1         : 0]    i_iq_dec_taddr_2,
    input   [`CORE_PC_WIDTH - 1         : 0]    i_iq_dec_taddr_3,

    input   [`PREDINFO_WIDTH - 1        : 0]    i_iq_dec_predinfo_bus_0,
    input   [`PREDINFO_WIDTH - 1        : 0]    i_iq_dec_predinfo_bus_1,
    input   [`PREDINFO_WIDTH - 1        : 0]    i_iq_dec_predinfo_bus_2,
    input   [`PREDINFO_WIDTH - 1        : 0]    i_iq_dec_predinfo_bus_3,

    input                                       i_dsp_dec_stall,

    input   [3                          : 0]    i_rob_dec_ret_vld,
    input   [`ARF_CODE_WIDTH - 1        : 0]    i_rob_dec_ret_arf_code_0,
    input   [`PRF_CODE_WIDTH - 1        : 0]    i_rob_dec_ret_prf_code_0,
    input   [`ARF_CODE_WIDTH - 1        : 0]    i_rob_dec_ret_arf_code_1,
    input   [`PRF_CODE_WIDTH - 1        : 0]    i_rob_dec_ret_prf_code_1,
    input   [`ARF_CODE_WIDTH - 1        : 0]    i_rob_dec_ret_arf_code_2,
    input   [`PRF_CODE_WIDTH - 1        : 0]    i_rob_dec_ret_prf_code_2,
    input   [`ARF_CODE_WIDTH - 1        : 0]    i_rob_dec_ret_arf_code_3,
    input   [`PRF_CODE_WIDTH - 1        : 0]    i_rob_dec_ret_prf_code_3,
    
    input   [3                          : 0]    i_rob_dec_rec_vld,
    input   [`ARF_CODE_WIDTH - 1        : 0]    i_rob_dec_rec_arf_code_0,
    input   [`PRF_CODE_WIDTH - 1        : 0]    i_rob_dec_rec_prf_code_0,
    input   [`ARF_CODE_WIDTH - 1        : 0]    i_rob_dec_rec_arf_code_1,
    input   [`PRF_CODE_WIDTH - 1        : 0]    i_rob_dec_rec_prf_code_1,
    input   [`ARF_CODE_WIDTH - 1        : 0]    i_rob_dec_rec_arf_code_2,
    input   [`PRF_CODE_WIDTH - 1        : 0]    i_rob_dec_rec_prf_code_2,
    input   [`ARF_CODE_WIDTH - 1        : 0]    i_rob_dec_rec_arf_code_3,
    input   [`PRF_CODE_WIDTH - 1        : 0]    i_rob_dec_rec_prf_code_3,

    input   [3                          : 0]    i_rob_dec_mis_vld,
    input   [`ARF_CODE_WIDTH - 1        : 0]    i_rob_dec_mis_arf_code_0,
    input   [`PRF_CODE_WIDTH - 1        : 0]    i_rob_dec_mis_prf_code_0,
    input   [`ARF_CODE_WIDTH - 1        : 0]    i_rob_dec_mis_arf_code_1,
    input   [`PRF_CODE_WIDTH - 1        : 0]    i_rob_dec_mis_prf_code_1,
    input   [`ARF_CODE_WIDTH - 1        : 0]    i_rob_dec_mis_arf_code_2,
    input   [`PRF_CODE_WIDTH - 1        : 0]    i_rob_dec_mis_prf_code_2,
    input   [`ARF_CODE_WIDTH - 1        : 0]    i_rob_dec_mis_arf_code_3,
    input   [`PRF_CODE_WIDTH - 1        : 0]    i_rob_dec_mis_prf_code_3,

    output  [3                          : 0]    o_dec_dsp_vld,
    output  [`EXCEPTION_CODE_WIDTH - 1  : 0]    o_dec_dsp_excp_code_0,
    output                                      o_dec_dsp_ilgl_0,
    output                                      o_dec_dsp_len_0,
    output                                      o_dec_dsp_src1_vld_0,
    output  [`PRF_CODE_WIDTH - 1        : 0]    o_dec_dsp_src1_code_0,
    output                                      o_dec_dsp_src2_vld_0,
    output  [`PRF_CODE_WIDTH - 1        : 0]    o_dec_dsp_src2_code_0,
    output                                      o_dec_dsp_src3_vld_0,
    output  [`PRF_CODE_WIDTH - 1        : 0]    o_dec_dsp_src3_code_0,
    output                                      o_dec_dsp_dst_vld_0,
    output  [`PRF_CODE_WIDTH - 1        : 0]    o_dec_dsp_dst_code_0,
    output  [`IMM_WIDTH - 1             : 0]    o_dec_dsp_imm_0,
    output  [`DECINFO_WIDTH - 1         : 0]    o_dec_dsp_decinfo_bus_0,
    output  [`PREDINFO_WIDTH - 1        : 0]    o_dec_dsp_predinfo_bus_0,

    output  [`EXCEPTION_CODE_WIDTH - 1  : 0]    o_dec_dsp_excp_code_1,
    output                                      o_dec_dsp_ilgl_1,
    output                                      o_dec_dsp_len_1,
    output                                      o_dec_dsp_src1_vld_1,
    output  [`PRF_CODE_WIDTH - 1        : 0]    o_dec_dsp_src1_code_1,
    output                                      o_dec_dsp_src2_vld_1,
    output  [`PRF_CODE_WIDTH - 1        : 0]    o_dec_dsp_src2_code_1,
    output                                      o_dec_dsp_src3_vld_1,
    output  [`PRF_CODE_WIDTH - 1        : 0]    o_dec_dsp_src3_code_1,
    output                                      o_dec_dsp_dst_vld_1,
    output  [`PRF_CODE_WIDTH - 1        : 0]    o_dec_dsp_dst_code_1,
    output  [`IMM_WIDTH - 1             : 0]    o_dec_dsp_imm_1,
    output  [`DECINFO_WIDTH - 1         : 0]    o_dec_dsp_decinfo_bus_1,
    output  [`PREDINFO_WIDTH - 1        : 0]    o_dec_dsp_predinfo_bus_1,
    
    output  [`EXCEPTION_CODE_WIDTH - 1  : 0]    o_dec_dsp_excp_code_2,
    output                                      o_dec_dsp_ilgl_2,
    output                                      o_dec_dsp_len_2,
    output                                      o_dec_dsp_src1_vld_2,
    output  [`PRF_CODE_WIDTH - 1        : 0]    o_dec_dsp_src1_code_2,
    output                                      o_dec_dsp_src2_vld_2,
    output  [`PRF_CODE_WIDTH - 1        : 0]    o_dec_dsp_src2_code_2,
    output                                      o_dec_dsp_src3_vld_2,
    output  [`PRF_CODE_WIDTH - 1        : 0]    o_dec_dsp_src3_code_2,
    output                                      o_dec_dsp_dst_vld_2,
    output  [`PRF_CODE_WIDTH - 1        : 0]    o_dec_dsp_dst_code_2,
    output  [`IMM_WIDTH - 1             : 0]    o_dec_dsp_imm_2,
    output  [`DECINFO_WIDTH - 1         : 0]    o_dec_dsp_decinfo_bus_2,
    output  [`PREDINFO_WIDTH - 1        : 0]    o_dec_dsp_predinfo_bus_2,

    output  [`EXCEPTION_CODE_WIDTH - 1  : 0]    o_dec_dsp_excp_code_3,
    output                                      o_dec_dsp_ilgl_3,
    output                                      o_dec_dsp_len_3,
    output                                      o_dec_dsp_src1_vld_3,
    output  [`PRF_CODE_WIDTH - 1        : 0]    o_dec_dsp_src1_code_3,
    output                                      o_dec_dsp_src2_vld_3,
    output  [`PRF_CODE_WIDTH - 1        : 0]    o_dec_dsp_src2_code_3,
    output                                      o_dec_dsp_src3_vld_3,
    output  [`PRF_CODE_WIDTH - 1        : 0]    o_dec_dsp_src3_code_3,
    output                                      o_dec_dsp_dst_vld_3,
    output  [`PRF_CODE_WIDTH - 1        : 0]    o_dec_dsp_dst_code_3,
    output  [`IMM_WIDTH - 1             : 0]    o_dec_dsp_imm_3,
    output  [`DECINFO_WIDTH - 1         : 0]    o_dec_dsp_decinfo_bus_3,
    output  [`PREDINFO_WIDTH - 1        : 0]    o_dec_dsp_predinfo_bus_3,

    output  [`PRF_CODE_WIDTH - 1        : 0]    o_dec_dsp_pprf_code_0,
    output  [`PRF_CODE_WIDTH - 1        : 0]    o_dec_dsp_pprf_code_1,
    output  [`PRF_CODE_WIDTH - 1        : 0]    o_dec_dsp_pprf_code_2,
    output  [`PRF_CODE_WIDTH - 1        : 0]    o_dec_dsp_pprf_code_3,

    output                                      o_dec_iq_stall,

    output                                      o_dec_prf_free_req_0,
    output                                      o_dec_prf_free_req_1,
    output                                      o_dec_prf_free_req_2,
    output                                      o_dec_prf_free_req_3,
    output  [`PRF_CODE_WIDTH - 1        : 0]    o_dec_prf_code_0,
    output  [`PRF_CODE_WIDTH - 1        : 0]    o_dec_prf_code_1,
    output  [`PRF_CODE_WIDTH - 1        : 0]    o_dec_prf_code_2,
    output  [`PRF_CODE_WIDTH - 1        : 0]    o_dec_prf_code_3,

    output  [`INSTR_WIDTH - 1           : 0]    o_dec_dsp_instr_0,
    output  [`INSTR_WIDTH - 1           : 0]    o_dec_dsp_instr_1,
    output  [`INSTR_WIDTH - 1           : 0]    o_dec_dsp_instr_2,
    output  [`INSTR_WIDTH - 1           : 0]    o_dec_dsp_instr_3,

    output  [`CORE_PC_WIDTH - 1         : 0]    o_dec_dsp_addr_0,
    output  [`CORE_PC_WIDTH - 1         : 0]    o_dec_dsp_addr_1,
    output  [`CORE_PC_WIDTH - 1         : 0]    o_dec_dsp_addr_2,
    output  [`CORE_PC_WIDTH - 1         : 0]    o_dec_dsp_addr_3,
    output  [`CORE_PC_WIDTH - 1         : 0]    o_dec_dsp_taddr_0,
    output  [`CORE_PC_WIDTH - 1         : 0]    o_dec_dsp_taddr_1, 
    output  [`CORE_PC_WIDTH - 1         : 0]    o_dec_dsp_taddr_2,
    output  [`CORE_PC_WIDTH - 1         : 0]    o_dec_dsp_taddr_3,

    input                                       clk,
    input                                       rst_n
);

//  Decode  Stage
//  Decoder 0
wire [`ARF_CODE_WIDTH - 1 : 0] o_dec_ren_src1_code_0;
wire [`ARF_CODE_WIDTH - 1 : 0] o_dec_ren_src2_code_0;
wire [`ARF_CODE_WIDTH - 1 : 0] o_dec_ren_src3_code_0;
wire [`ARF_CODE_WIDTH - 1 : 0] o_dec_ren_dst_code_0;

decoder_module decoder0 (
    .i_dec_instr     (i_iq_dec_instr_0),
    .o_dec_ilgl      (o_dec_dsp_ilgl_0),
    .o_dec_info_bus  (o_dec_dsp_decinfo_bus_0),
    .o_dec_rs1_vld   (o_dec_dsp_src1_vld_0),
    .o_dec_rs1_code  (o_dec_ren_src1_code_0),
    .o_dec_rs2_vld   (o_dec_dsp_src2_vld_0),
    .o_dec_rs2_code  (o_dec_ren_src2_code_0),
    .o_dec_rs3_vld   (o_dec_dsp_src3_vld_0),
    .o_dec_rs3_code  (o_dec_ren_src3_code_0),
    .o_dec_rd_vld    (o_dec_dsp_dst_vld_0),
    .o_dec_rd_code   (o_dec_ren_dst_code_0),
    .o_dec_imm_vld   (),
    .o_dec_imm       (o_dec_dsp_imm_0),
    .o_dec_len       (o_dec_dsp_len_0)
);

assign o_dec_dsp_excp_code_0     = i_iq_dec_excp_code_0;
assign o_dec_dsp_predinfo_bus_0  = i_iq_dec_predinfo_bus_0;

//  Decoder 1

wire [`ARF_CODE_WIDTH - 1 : 0] o_dec_ren_src1_code_1;
wire [`ARF_CODE_WIDTH - 1 : 0] o_dec_ren_src2_code_1;
wire [`ARF_CODE_WIDTH - 1 : 0] o_dec_ren_src3_code_1;
wire [`ARF_CODE_WIDTH - 1 : 0] o_dec_ren_dst_code_1;


decoder_module decoder1 (
    .i_dec_instr     (i_iq_dec_instr_1),
    .o_dec_ilgl      (o_dec_dsp_ilgl_1),
    .o_dec_info_bus  (o_dec_dsp_decinfo_bus_1),
    .o_dec_rs1_vld   (o_dec_dsp_src1_vld_1),
    .o_dec_rs1_code  (o_dec_ren_src1_code_1),
    .o_dec_rs2_vld   (o_dec_dsp_src2_vld_1),
    .o_dec_rs2_code  (o_dec_ren_src2_code_1),
    .o_dec_rs3_vld   (o_dec_dsp_src3_vld_1),
    .o_dec_rs3_code  (o_dec_ren_src3_code_1),
    .o_dec_rd_vld    (o_dec_dsp_dst_vld_1),
    .o_dec_rd_code   (o_dec_ren_dst_code_1),
    .o_dec_imm_vld   (),
    .o_dec_imm       (o_dec_dsp_imm_1),
    .o_dec_len       (o_dec_dsp_len_1)
);

assign o_dec_dsp_excp_code_1     = i_iq_dec_excp_code_1;
assign o_dec_dsp_predinfo_bus_1  = i_iq_dec_predinfo_bus_1;

//  Decoder 2

wire [`ARF_CODE_WIDTH - 1 : 0] o_dec_ren_src1_code_2;
wire [`ARF_CODE_WIDTH - 1 : 0] o_dec_ren_src2_code_2;
wire [`ARF_CODE_WIDTH - 1 : 0] o_dec_ren_src3_code_2;
wire [`ARF_CODE_WIDTH - 1 : 0] o_dec_ren_dst_code_2;


decoder_module decoder2 (
    .i_dec_instr     (i_iq_dec_instr_2),
    .o_dec_ilgl      (o_dec_dsp_ilgl_2),
    .o_dec_info_bus  (o_dec_dsp_decinfo_bus_2),
    .o_dec_rs1_vld   (o_dec_dsp_src1_vld_2),
    .o_dec_rs1_code  (o_dec_ren_src1_code_2),
    .o_dec_rs2_vld   (o_dec_dsp_src2_vld_2),
    .o_dec_rs2_code  (o_dec_ren_src2_code_2),
    .o_dec_rs3_vld   (o_dec_dsp_src3_vld_2),
    .o_dec_rs3_code  (o_dec_ren_src3_code_2),
    .o_dec_rd_vld    (o_dec_dsp_dst_vld_2),
    .o_dec_rd_code   (o_dec_ren_dst_code_2),
    .o_dec_imm_vld   (),
    .o_dec_imm       (o_dec_dsp_imm_2),
    .o_dec_len       (o_dec_dsp_len_2)
);

assign o_dec_dsp_excp_code_2     = i_iq_dec_excp_code_2;
assign o_dec_dsp_predinfo_bus_2  = i_iq_dec_predinfo_bus_2;

//  Decoder 3
wire [`ARF_CODE_WIDTH - 1 : 0] o_dec_ren_src1_code_3;
wire [`ARF_CODE_WIDTH - 1 : 0] o_dec_ren_src2_code_3;
wire [`ARF_CODE_WIDTH - 1 : 0] o_dec_ren_src3_code_3;
wire [`ARF_CODE_WIDTH - 1 : 0] o_dec_ren_dst_code_3;


decoder_module decoder3 (
    .i_dec_instr     (i_iq_dec_instr_3),
    .o_dec_ilgl      (o_dec_dsp_ilgl_3),
    .o_dec_info_bus  (o_dec_dsp_decinfo_bus_3),
    .o_dec_rs1_vld   (o_dec_dsp_src1_vld_3),
    .o_dec_rs1_code  (o_dec_ren_src1_code_3),
    .o_dec_rs2_vld   (o_dec_dsp_src2_vld_3),
    .o_dec_rs2_code  (o_dec_ren_src2_code_3),
    .o_dec_rs3_vld   (o_dec_dsp_src3_vld_3),
    .o_dec_rs3_code  (o_dec_ren_src3_code_3),
    .o_dec_rd_vld    (o_dec_dsp_dst_vld_3),
    .o_dec_rd_code   (o_dec_ren_dst_code_3),
    .o_dec_imm_vld   (),
    .o_dec_imm       (o_dec_dsp_imm_3),
    .o_dec_len       (o_dec_dsp_len_3)
);

assign o_dec_dsp_excp_code_3     = i_iq_dec_excp_code_3;
assign o_dec_dsp_predinfo_bus_3  = i_iq_dec_predinfo_bus_3;

//  Rename Stage
wire [3 : 0] i_dec_ren_vld = i_iq_dec_vld;


dec_ren_module rename (
    .i_csr_trap_flush         (i_csr_trap_flush),
    .i_exu_mis_flush          (i_exu_mis_flush),
    .i_exu_ls_flush           (i_exu_ls_flush),

    .i_dsp_ren_stall          (i_dsp_dec_stall),

    .i_dec_ren_vld            (i_dec_ren_vld),
    .i_dec_ren_src1_vld_0     (o_dec_dsp_src1_vld_0),
    .i_dec_ren_src1_code_0    (o_dec_ren_src1_code_0),
    .i_dec_ren_src2_vld_0     (o_dec_dsp_src2_vld_0),
    .i_dec_ren_src2_code_0    (o_dec_ren_src2_code_0),
    .i_dec_ren_src3_vld_0     (o_dec_dsp_src3_vld_0),
    .i_dec_ren_src3_code_0    (o_dec_ren_src3_code_0),
    .i_dec_ren_dst_vld_0      (o_dec_dsp_dst_vld_0),
    .i_dec_ren_dst_code_0     (o_dec_ren_dst_code_0),
    .i_dec_ren_src1_vld_1     (o_dec_dsp_src1_vld_1),
    .i_dec_ren_src1_code_1    (o_dec_ren_src1_code_1),
    .i_dec_ren_src2_vld_1     (o_dec_dsp_src2_vld_1),
    .i_dec_ren_src2_code_1    (o_dec_ren_src2_code_1),
    .i_dec_ren_src3_vld_1     (o_dec_dsp_src3_vld_1),
    .i_dec_ren_src3_code_1    (o_dec_ren_src3_code_1),
    .i_dec_ren_dst_vld_1      (o_dec_dsp_dst_vld_1),
    .i_dec_ren_dst_code_1     (o_dec_ren_dst_code_1),
    .i_dec_ren_src1_vld_2     (o_dec_dsp_src1_vld_2),
    .i_dec_ren_src1_code_2    (o_dec_ren_src1_code_2),
    .i_dec_ren_src2_vld_2     (o_dec_dsp_src2_vld_2),
    .i_dec_ren_src2_code_2    (o_dec_ren_src2_code_2),
    .i_dec_ren_src3_vld_2     (o_dec_dsp_src3_vld_2),
    .i_dec_ren_src3_code_2    (o_dec_ren_src3_code_2),
    .i_dec_ren_dst_vld_2      (o_dec_dsp_dst_vld_2),
    .i_dec_ren_dst_code_2     (o_dec_ren_dst_code_2),
    .i_dec_ren_src1_vld_3     (o_dec_dsp_src1_vld_3),
    .i_dec_ren_src1_code_3    (o_dec_ren_src1_code_3),
    .i_dec_ren_src2_vld_3     (o_dec_dsp_src2_vld_3),
    .i_dec_ren_src2_code_3    (o_dec_ren_src2_code_3),
    .i_dec_ren_src3_vld_3     (o_dec_dsp_src3_vld_3),
    .i_dec_ren_src3_code_3    (o_dec_ren_src3_code_3),
    .i_dec_ren_dst_vld_3      (o_dec_dsp_dst_vld_3),
    .i_dec_ren_dst_code_3     (o_dec_ren_dst_code_3),

    .i_rob_ren_ret_vld        (i_rob_dec_ret_vld),
    .i_rob_ren_ret_arf_code_0 (i_rob_dec_ret_arf_code_0),
    .i_rob_ren_ret_prf_code_0 (i_rob_dec_ret_prf_code_0),
    .i_rob_ren_ret_arf_code_1 (i_rob_dec_ret_arf_code_1),
    .i_rob_ren_ret_prf_code_1 (i_rob_dec_ret_prf_code_1),
    .i_rob_ren_ret_arf_code_2 (i_rob_dec_ret_arf_code_2),
    .i_rob_ren_ret_prf_code_2 (i_rob_dec_ret_prf_code_2),
    .i_rob_ren_ret_arf_code_3 (i_rob_dec_ret_arf_code_3),
    .i_rob_ren_ret_prf_code_3 (i_rob_dec_ret_prf_code_3),

    .i_rob_ren_rec_vld        (i_rob_dec_rec_vld),
    .i_rob_ren_rec_arf_code_0 (i_rob_dec_rec_arf_code_0),
    .i_rob_ren_rec_prf_code_0 (i_rob_dec_rec_prf_code_0),
    .i_rob_ren_rec_arf_code_1 (i_rob_dec_rec_arf_code_1),
    .i_rob_ren_rec_prf_code_1 (i_rob_dec_rec_prf_code_1),
    .i_rob_ren_rec_arf_code_2 (i_rob_dec_rec_arf_code_2),
    .i_rob_ren_rec_prf_code_2 (i_rob_dec_rec_prf_code_2),
    .i_rob_ren_rec_arf_code_3 (i_rob_dec_rec_arf_code_3),
    .i_rob_ren_rec_prf_code_3 (i_rob_dec_rec_prf_code_3),

    .i_rob_ren_mis_vld        (i_rob_dec_mis_vld),
    .i_rob_ren_mis_arf_code_0 (i_rob_dec_mis_arf_code_0),
    .i_rob_ren_mis_prf_code_0 (i_rob_dec_mis_prf_code_0),
    .i_rob_ren_mis_arf_code_1 (i_rob_dec_mis_arf_code_1),
    .i_rob_ren_mis_prf_code_1 (i_rob_dec_mis_prf_code_1),
    .i_rob_ren_mis_arf_code_2 (i_rob_dec_mis_arf_code_2),
    .i_rob_ren_mis_prf_code_2 (i_rob_dec_mis_prf_code_2),
    .i_rob_ren_mis_arf_code_3 (i_rob_dec_mis_arf_code_3),
    .i_rob_ren_mis_prf_code_3 (i_rob_dec_mis_prf_code_3),

    .o_ren_dsp_src1_prf_code_0(o_dec_dsp_src1_code_0),
    .o_ren_dsp_src2_prf_code_0(o_dec_dsp_src2_code_0),
    .o_ren_dsp_src3_prf_code_0(o_dec_dsp_src3_code_0),
    .o_ren_dsp_dst_prf_code_0 (o_dec_dsp_dst_code_0),
    .o_ren_dsp_src1_prf_code_1(o_dec_dsp_src1_code_1),
    .o_ren_dsp_src2_prf_code_1(o_dec_dsp_src2_code_1),
    .o_ren_dsp_src3_prf_code_1(o_dec_dsp_src3_code_1),
    .o_ren_dsp_dst_prf_code_1 (o_dec_dsp_dst_code_1),
    .o_ren_dsp_src1_prf_code_2(o_dec_dsp_src1_code_2),
    .o_ren_dsp_src2_prf_code_2(o_dec_dsp_src2_code_2),
    .o_ren_dsp_src3_prf_code_2(o_dec_dsp_src3_code_2),
    .o_ren_dsp_dst_prf_code_2 (o_dec_dsp_dst_code_2),
    .o_ren_dsp_src1_prf_code_3(o_dec_dsp_src1_code_3),
    .o_ren_dsp_src2_prf_code_3(o_dec_dsp_src2_code_3),
    .o_ren_dsp_src3_prf_code_3(o_dec_dsp_src3_code_3),
    .o_ren_dsp_dst_prf_code_3 (o_dec_dsp_dst_code_3),
    .o_ren_dsp_pprf_code_0    (o_dec_dsp_pprf_code_0),
    .o_ren_dsp_pprf_code_1    (o_dec_dsp_pprf_code_1),
    .o_ren_dsp_pprf_code_2    (o_dec_dsp_pprf_code_2),
    .o_ren_dsp_pprf_code_3    (o_dec_dsp_pprf_code_3),
    .o_ren_dec_stall          (o_dec_iq_stall),

    .o_ren_prf_free_req_0     (o_dec_prf_free_req_0),
    .o_ren_prf_free_req_1     (o_dec_prf_free_req_1),
    .o_ren_prf_free_req_2     (o_dec_prf_free_req_2),
    .o_ren_prf_free_req_3     (o_dec_prf_free_req_3),
    .o_ren_prf_code_0         (o_dec_prf_code_0),
    .o_ren_prf_code_1         (o_dec_prf_code_1),
    .o_ren_prf_code_2         (o_dec_prf_code_2),
    .o_ren_prf_code_3         (o_dec_prf_code_3),

    .clk                      (clk),
    .rst_n                    (rst_n)
);

//
assign { 
        o_dec_dsp_instr_3
    ,   o_dec_dsp_instr_2
    ,   o_dec_dsp_instr_1
    ,   o_dec_dsp_instr_0
} = {
        i_iq_dec_instr_3
    ,   i_iq_dec_instr_2
    ,   i_iq_dec_instr_1
    ,   i_iq_dec_instr_0 
};

assign {
        o_dec_dsp_addr_3
    ,   o_dec_dsp_addr_2
    ,   o_dec_dsp_addr_1 
    ,   o_dec_dsp_addr_0
    ,   o_dec_dsp_taddr_3
    ,   o_dec_dsp_taddr_2
    ,   o_dec_dsp_taddr_1
    ,   o_dec_dsp_taddr_0
} = {
        i_iq_dec_addr_3
    ,   i_iq_dec_addr_2
    ,   i_iq_dec_addr_1
    ,   i_iq_dec_addr_0
    ,   i_iq_dec_taddr_3
    ,   i_iq_dec_taddr_2
    ,   i_iq_dec_taddr_1
    ,   i_iq_dec_taddr_0
};

endmodule   //  dec_decode_module

`endif  /*  !__DECODE_DEC_DECODE_V__! */
