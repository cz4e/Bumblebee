
`ifdef __DECODE_DEC_DECODER_V__

module dec_decoder_module (
    input                   [`INSTR_WIDTH - 1           : 0]            i_dec_instr,
    
    output                                                              o_dec_ilgl,
    output                  [`UOP_INFO_BUS_WIDTH - 1    : 0]            o_dec_info_bus,
    output                                                              o_dec_rs1_vld,
    output                  [`RS_CODE_WIDTH - 1         : 0]            o_dec_rs1_code,
    output                                                              o_dec_rs2_vld,
    output                  [`RS_CODE_WIDTH - 1         : 0]            o_dec_rs2_code,
    output                                                              o_dec_rs3_vld,
    output                  [`RS_CODE_WIDTH - 1         : 0]            o_dec_rs3_code,
    output                                                              o_dec_rd_vld,
    output                  [`RS_CODE_WIDTH - 1         : 0]            o_dec_rd_code,
    output                                                              o_dec_imm_vld,
    output                  [`IMM_WIDTH - 1             : 0]            o_dec_imm,
    output                                                              o_dec_len
);

wire [15 : 0] rv16_instr = i_dec_instr[15 : 0];
wire [31 : 0] rv32_instr = i_dec_instr;


//  RV32
wire [6 : 0] opcode = rv32_instr[6 : 0];

wire [4 : 0] rv32_rd_code    =   rv32_instr[11 : 7];
wire [4 : 0] rv32_rs1_code   =   rv32_instr[19 : 15];
wire [4 : 0] rv32_rs2_code   =   rv32_instr[24 : 20];
wire [4 : 0] rv32_rs3_code   =   rv32_instr[31 : 27];

wire [2 : 0] rv32_func3 =   rv32_instr[14 : 12];
wire [6 : 0] rv32_func7 =   rv32_instr[31 : 25];

wire [`RS_CODE_WIDTH - 1 : 0] rv32_rd   = rv32_instr[11 : 7];
wire [`RS_CODE_WIDTH - 1 : 0] rv32_rs1  = rv32_instr[19 : 15];
wire [`RS_CODE_WIDTH - 1 : 0] rv32_rs2  = rv32_instr[24 : 20];
wire [`RS_CODE_WIDTH - 1 : 0] rv32_rs3  = rv32_instr[31 : 27];

wire rv32_rs1_x0    = (rv32_rs1_code == `RS_CODE_WIDTH'b00000);
wire rv32_rs1_x31   = (rv32_rs1_code == `RS_CODE_WIDTH'b11111);
wire rv32_rs2_x0    = (rv32_rs2_code == `RS_CODE_WIDTH'b00000);
wire rv32_rs2_x1    = (rv32_rs2_code == `RS_CODE_WIDTH'b00001);
wire rv32_rs2_x31   = (rv32_rs2_code == `RS_CODE_WIDTH'b11111);
wire rv32_rd_x0     = (rv32_rd_code  == `RS_CODE_WIDTH'b00000);
wire rv32_rd_x2     = (rv32_rd_code  == `RS_CODE_WIDTH'b00010);
wire rv32_rd_x31    = (rv32_rd_code  == `RS_CODE_WIDTH'b11111);

wire opcode_1_0_00  =   (opcode[1 : 0] == 2'b00);
wire opcode_1_0_01  =   (opcode[1 : 0] == 2'b01);
wire opcode_1_0_10  =   (opcode[1 : 0] == 2'b10);
wire opcode_1_0_11  =   (opcode[1 : 0] == 2'b11);

wire opcode_4_2_000 =   (opcode[4:2] == 3'b000);
wire opcode_4_2_001 =   (opcode[4:2] == 3'b001);
wire opcode_4_2_010 =   (opcode[4:2] == 3'b010);
wire opcode_4_2_011 =   (opcode[4:2] == 3'b011);
wire opcode_4_2_100 =   (opcode[4:2] == 3'b100);
wire opcode_4_2_101 =   (opcode[4:2] == 3'b101);
wire opcode_4_2_110 =   (opcode[4:2] == 3'b110);
wire opcode_4_2_111 =   (opcode[4:2] == 3'b111);

wire opcode_6_5_00  =   (opcode[6:5] == 2'b00);
wire opcode_6_5_01  =   (opcode[6:5] == 2'b01);
wire opcode_6_5_10  =   (opcode[6:5] == 2'b10);
wire opcode_6_5_11  =   (opcode[6:5] == 2'b11);

wire rv32_func3_000 = (rv32_func3 == 3'b000);
wire rv32_func3_001 = (rv32_func3 == 3'b001);
wire rv32_func3_010 = (rv32_func3 == 3'b010);
wire rv32_func3_011 = (rv32_func3 == 3'b011);
wire rv32_func3_100 = (rv32_func3 == 3'b100);
wire rv32_func3_101 = (rv32_func3 == 3'b101);
wire rv32_func3_110 = (rv32_func3 == 3'b110);
wire rv32_func3_111 = (rv32_func3 == 3'b111);


wire rv32_func7_0000000 = (rv32_func7 == 7'b0000000);
wire rv32_func7_0100000 = (rv32_func7 == 7'b0100000);
wire rv32_func7_0000001 = (rv32_func7 == 7'b0000001);
wire rv32_func7_0000101 = (rv32_func7 == 7'b0000101);
wire rv32_func7_0001001 = (rv32_func7 == 7'b0001001);
wire rv32_func7_0001101 = (rv32_func7 == 7'b0001101);
wire rv32_func7_0010101 = (rv32_func7 == 7'b0010101);
wire rv32_func7_0100001 = (rv32_func7 == 7'b0100001);
wire rv32_func7_0010001 = (rv32_func7 == 7'b0010001);
wire rv32_func7_0101101 = (rv32_func7 == 7'b0101101);
wire rv32_func7_1111111 = (rv32_func7 == 7'b1111111);
wire rv32_func7_0000100 = (rv32_func7 == 7'b0000100);
wire rv32_func7_0001000 = (rv32_func7 == 7'b0001000);
wire rv32_func7_0001100 = (rv32_func7 == 7'b0001100);
wire rv32_func7_0101100 = (rv32_func7 == 7'b0101100);
wire rv32_func7_0010000 = (rv32_func7 == 7'b0010000);
wire rv32_func7_0010100 = (rv32_func7 == 7'b0010100);
wire rv32_func7_1100000 = (rv32_func7 == 7'b1100000);
wire rv32_func7_1110000 = (rv32_func7 == 7'b1110000);
wire rv32_func7_1010000 = (rv32_func7 == 7'b1010000);
wire rv32_func7_1101000 = (rv32_func7 == 7'b1101000);
wire rv32_func7_1111000 = (rv32_func7 == 7'b1111000);
wire rv32_func7_1010001 = (rv32_func7 == 7'b1010001);
wire rv32_func7_1110001 = (rv32_func7 == 7'b1110001);
wire rv32_func7_1100001 = (rv32_func7 == 7'b1100001);
wire rv32_func7_1101001 = (rv32_func7 == 7'b1101001);


wire rv32_lui       = opcode_6_5_01 & opcode_4_2_101 & opcode_1_0_11;
wire rv32_auipc     = opcode_6_5_00 & opcode_4_2_101 & opcode_1_0_11;
wire rv32_jal       = opcode_6_5_11 & opcode_4_2_011 & opcode_1_0_11;
wire rv32_jalr      = opcode_6_5_11 & opcode_4_2_001 & opcode_1_0_11;
wire rv32_branch    = opcode_6_5_11 & opcode_4_2_001 & opcode_1_0_11;
wire rv32_load      = opcode_6_5_00 & opcode_4_2_000 & opcode_1_0_11;
wire rv32_store     = opcode_6_5_01 & opcode_4_2_000 & opcode_1_0_11;
wire rv32_op_imm    = opcode_6_5_00 & opcode_4_2_100 & opcode_1_0_11;
wire rv32_op        = opcode_6_5_01 & opcode_4_2_100 & opcode_1_0_11;
wire rv32_fence_op  = opcode_6_5_00 & opcode_4_2_011 & opcode_1_0_11;
wire rv32_system    = opcode_6_5_11 & opcode_4_2_100 & opcode_1_0_11;
wire rv32_muldiv    = opcode_6_5_01 & opcode_4_2_100 & opcode_1_0_11;
wire rv32_amo_op    = opcode_6_5_01 & opcode_4_2_011 & opcode_1_0_11;
wire rv32_fpu_load  = opcode_6_5_00 & opcode_4_2_001 & opcode_1_0_11;
wire rv32_fpu_store = opcode_6_5_01 & opcode_4_2_001 & opcode_1_0_11;
wire rv32_fpu_madds = opcode_6_5_10 & opcode_4_2_000 & opcode_1_0_11;
wire rv32_fpu_msubs = opcode_6_5_10 & opcode_4_2_001 & opcode_1_0_11;
wire rv32_fpu_nmsubs= opcode_6_5_10 & opcode_4_2_010 & opcode_1_0_11;
wire rv32_fpu_nmadds= opcode_6_5_10 & opcode_4_2_011 & opcode_1_0_11;
wire rv32_fpu_op    = opcode_6_5_10 & opcode_4_2_100 & opcode_1_0_11;


wire rv32_beq       = rv32_branch   & rv32_func3_000;
wire rv32_bne       = rv32_branch   & rv32_func3_001;
wire rv32_blt       = rv32_branch   & rv32_func3_100;
wire rv32_bge       = rv32_branch   & rv32_func3_101;
wire rv32_bltu      = rv32_branch   & rv32_func3_110;
wire rv32_bgeu      = rv32_branch   & rv32_func3_111;

wire rv32_lb        = rv32_load     & rv32_func3_000;
wire rv32_lh        = rv32_load     & rv32_func3_001;
wire rv32_lw        = rv32_load     & rv32_func3_010;
wire rv32_lbu       = rv32_load     & rv32_func3_100;
wire rv32_lhu       = rv32_load     & rv32_func3_101;
wire rv32_sb        = rv32_store    & rv32_func3_000;
wire rv32_sh        = rv32_store    & rv32_func3_001;
wire rv32_sw        = rv32_store    & rv32_func3_010;

wire rv32_addi      = rv32_op_imm   & rv32_func3_000;
wire rv32_slti      = rv32_op_imm   & rv32_func3_010;
wire rv32_sltiu     = rv32_op_imm   & rv32_func3_011;
wire rv32_xori      = rv32_op_imm   & rv32_func3_100;
wire rv32_ori       = rv32_op_imm   & rv32_func3_110;
wire rv32_andi      = rv32_op_imm   & rv32_func3_111;
wire rv32_slli      = rv32_op_imm   & rv32_func3_001 & rv32_func7_0000000;
wire rv32_srli      = rv32_op_imm   & rv32_func3_101 & rv32_func7_0000000;
wire rv32_srai      = rv32_op_imm   & rv32_func3_101 & rv32_func7_0100000;
wire rv32_nop       = rv32_addi     & rv32_rs1_x0   & rv32_rd_x0 & (~(|rv32_instr[31 : 20]));

wire rv32_add       = rv32_op       & rv32_func3_000 & rv32_func7_0000000;
wire rv32_sub       = rv32_op       & rv32_func3_000 & rv32_func7_0100000;
wire rv32_sll       = rv32_op       & rv32_func3_001 & rv32_func7_0000000;
wire rv32_slt       = rv32_op       & rv32_func3_010 & rv32_func7_0000000;
wire rv32_sltu      = rv32_op       & rv32_func3_011 & rv32_func7_0000000;
wire rv32_xor       = rv32_op       & rv32_func3_100 & rv32_func7_0000000;
wire rv32_srl       = rv32_op       & rv32_func3_101 & rv32_func7_0000000;
wire rv32_sra       = rv32_op       & rv32_func3_101 & rv32_func7_0100000;
wire rv32_or        = rv32_op       & rv32_func3_110 & rv32_func7_0000000;
wire rv32_and       = rv32_op       & rv32_func3_111 & rv32_func7_0000000;

wire rv32_fence     = rv32_fence_op & rv32_func3_000;
wire rv32_fencei    = rv32_fence_op & rv32_func3_001;

wire rv32_ecall_ebreak_ret_wfi  = rv32_system & rv32_func3_000;
wire rv32_ecall     = rv32_ecall_ebreak_ret_wfi & (rv32_instr[31 : 20] == 12'b0000_0000_0000);
wire rv32_ebreak    = rv32_ecall_ebreak_ret_wfi & (rv32_instr[31 : 20] == 12'b0000_0000_0001);
wire rv32_mret      = rv32_ecall_ebreak_ret_wfi & (rv32_instr[31 : 20] == 12'b0011_0000_0010);
wire rv32_sret      = rv32_ecall_ebreak_ret_wfi & (rv32_instr[31 : 20] == 12'b0001_0000_0010);
wire rv32_uret      = rv32_ecall_ebreak_ret_wfi & (rv32_instr[31 : 20] == 12'b0000_0000_0010);
wire rv32_wfi       = rv32_ecall_ebreak_ret_wfi & (rv32_instr[31 : 20] == 12'b0001_0000_0101);
wire rv32_sfence_vma= rv32_ecall_ebreak_ret_wfi & rv32_func7_0001001;

wire rv32_csr_op    = rv32_system   & (~(rv32_func3_000));
wire rv32_csrrw     = rv32_csr_op   & rv32_func3_001;
wire rv32_csrrs     = rv32_csr_op   & rv32_func3_010;
wire rv32_csrrc     = rv32_csr_op   & rv32_func3_011;
wire rv32_csrrwi    = rv32_csr_op   & rv32_func3_101;
wire rv32_csrrsi    = rv32_csr_op   & rv32_func3_110;
wire rv32_csrrci    = rv32_csr_op   & rv32_func3_111;

wire rv32_mul       = rv32_muldiv   & rv32_func3_000;
wire rv32_mulh      = rv32_muldiv   & rv32_func3_001;
wire rv32_mulhsu    = rv32_muldiv   & rv32_func3_010;
wire rv32_mulhu     = rv32_muldiv   & rv32_func3_011;
wire rv32_div       = rv32_muldiv   & rv32_func3_100;
wire rv32_divu      = rv32_muldiv   & rv32_func3_101;
wire rv32_rem       = rv32_muldiv   & rv32_func3_110;
wire rv32_remu      = rv32_muldiv   & rv32_func3_111;

wire rv32_lrw       = rv32_amo_op   & (rv32_func7[6 : 2] == 5'b00010);
wire rv32_scw       = rv32_amo_op   & (rv32_func7[6 : 2] == 5'b00011);
wire rv32_amoswapw  = rv32_amo_op   & (rv32_func7[6 : 2] == 5'b00001);
wire rv32_amoaddw   = rv32_amo_op   & (rv32_func7[6 : 2] == 5'b00000);
wire rv32_amoxorw   = rv32_amo_op   & (rv32_func7[6 : 2] == 5'b00100);
wire rv32_amoandw   = rv32_amo_op   & (rv32_func7[6 : 2] == 5'b01100);
wire rv32_amoorw    = rv32_amo_op   & (rv32_func7[6 : 2] == 5'b01000);
wire rv32_amominw   = rv32_amo_op   & (rv32_func7[6 : 2] == 5'b10000);
wire rv32_amomaxw   = rv32_amo_op   & (rv32_func7[6 : 2] == 5'b10100);
wire rv32_amominuw  = rv32_amo_op   & (rv32_func7[6 : 2] == 5'b11000);
wire rv32_amomaxuw  = rv32_amo_op   & (rv32_func7[6 : 2] == 5'b11100);

wire rv32_flw       = rv32_fpu_load & rv32_func3_010;
wire rv32_fsw       = rv32_fpu_store & rv32_func3_010;
wire rv32_fadds     = rv32_fpu_op   & rv32_func7_0000000;
wire rv32_fsubs     = rv32_fpu_op   & rv32_func7_0000100;
wire rv32_fmuls     = rv32_fpu_op   & rv32_func7_0001000;
wire rv32_fdivs     = rv32_fpu_op   & rv32_func7_0001100;
wire rv32_fsqrts    = rv32_fpu_op   & rv32_func7_0101100;
wire rv32_fsgnjs    = rv32_fpu_op   & rv32_func7_0010000 & rv32_func3_000;
wire rv32_fsgnjns   = rv32_fpu_op   & rv32_func7_0010000 & rv32_func3_001;
wire rv32_fsgnjxs   = rv32_fpu_op   & rv32_func7_0010000 & rv32_func3_010;
wire rv32_fmins     = rv32_fpu_op   & rv32_func7_0010100 & rv32_func3_000;
wire rv32_fmaxs     = rv32_fpu_op   & rv32_func7_0010100 & rv32_func3_001;
wire rv32_fcvtws    = rv32_fpu_op   & rv32_func7_1100000 & rv32_rs2_x0;
wire rv32_fcvtwus   = rv32_fpu_op   & rv32_func7_1100000 & rv32_rs2_x1;
wire rv32_fmvxw     = rv32_fpu_op   & rv32_func7_1110000 & rv32_func3_000 & rv32_rs2_x0;
wire rv32_feqs      = rv32_fpu_op   & rv32_func7_1010000 & rv32_func3_010;
wire rv32_flts      = rv32_fpu_op   & rv32_func7_1010000 & rv32_func3_001;
wire rv32_fles      = rv32_fpu_op   & rv32_func7_1010000 & rv32_func3_000;
wire rv32_fclasss   = rv32_fpu_op   & rv32_func7_1110000 & rv32_func3_001 & rv32_rs2_x0;
wire rv32_fcvtsw    = rv32_fpu_op   & rv32_func7_1101000 & rv32_rs2_x0;
wire rv32_fcvtswu   = rv32_fpu_op   & rv32_func7_1101000 & rv32_rs2_x1;
wire rv32_fmvwx     = rv32_fpu_op   & rv32_func7_1111000 & rv32_func3_000 & rv32_rs2_x0;

//
wire rv32_imm_sel_i = rv32_op_imm | rv32_jalr | rv32_load;
wire [`IMM_WIDTH - 1 : 0]  rv32_i_imm = {
                                           {20{rv32_instr[31]}}
                                          , rv32_instr[31:20]
                                         };

wire rv32_imm_sel_s = rv32_store;
wire [`IMM_WIDTH - 1 : 0]  rv32_s_imm = {
                                           {20{rv32_instr[31]}}
                                          , rv32_instr[31:25]
                                          , rv32_instr[11:7]
                                         };

wire rv32_imm_sel_b = rv32_branch;
wire [`IMM_WIDTH - 1 : 0]  rv32_b_imm = {
                                           {19{rv32_instr[31]}}
                                          , rv32_instr[31]
                                          , rv32_instr[7]
                                          , rv32_instr[30:25]
                                          , rv32_instr[11:8]
                                          , 1'b0
                                          };

wire rv32_imm_sel_u = rv32_lui | rv32_auipc;
wire [`IMM_WIDTH - 1 : 0]  rv32_u_imm = {rv32_instr[31:12]
                                        , 12'b0
                                        };

wire rv32_imm_sel_j = rv32_jal;
wire [`IMM_WIDTH - 1 : 0]  rv32_j_imm = {
                                           {11{rv32_instr[31]}}
                                          , rv32_instr[31]
                                          , rv32_instr[19:12]
                                          , rv32_instr[20]
                                          , rv32_instr[30:21]
                                          , 1'b0
                                          };
                    
wire [`IMM_WIDTH - 1 : 0] rv32_imm  = ({`IMM_WIDTH{rv32_imm_sel_i}}     & rv32_i_imm)
                                    | ({`IMM_WIDTH{rv32_imm_sel_s}}     & rv32_s_imm)
                                    | ({`IMM_WIDTH{rv32_imm_sel_b}}     & rv32_b_imm)
                                    | ({`IMM_WIDTH{rv32_imm_sel_u}}     & rv32_u_imm)
                                    | ({`IMM_WIDTH{rv32_imm_sel_j}}     & rv32_j_imm);


wire rv32_rs1_valid  = (
                        ~(rv32_lui | rv32_auipc | rv32_jal | rv32_fence_op | rv32_ecall_ebreak_ret_wfi | rv32_csrrwi | rv32_csrrsi | rv32_csrrci)
                    );
wire rv32_rs2_valid  = (
                        rv32_branch | rv32_store | rv32_op | (rv32_amo_op & (~rv32_lrw))
                    );
wire rv32_rs3_valid  = (rv32_fpu_madds | rv32_fpu_msubs | rv32_fpu_nmsubs | rv32_fpu_nmadds);
wire rv32_rd_valid   = (~(rv32_branch | rv32_store | rv32_fence_op | rv32_ecall_ebreak_ret_wfi));


wire rv32_imm_valid  = rv32_imm_sel_i
                    | rv32_imm_sel_s
                    | rv32_imm_sel_b
                    | rv32_imm_sel_u
                    | rv32_imm_sel_j;
                    
wire rv32_shamt_ilgl    = (rv32_slli | rv32_srli | rv32_srai) & (~(rv32_instr[25] == 1'b0));
wire rv32_all0s_ilgl    = rv32_func7_0000000
                        & rv32_rs2_x0
                        & rv32_rs1_x0
                        & rv32_func3_000
                        & rv32_rd_x0
                        & opcode_6_5_00
                        & opcode_4_2_000
                        & opcode_1_0_00;
                        
wire rv32_all1s_ilgl    = rv32_func7_1111111
                        & rv32_rs2_x31
                        & rv32_rs1_x31
                        & rv32_func3_111
                        & rv32_rd_x31
                        & opcode_6_5_11
                        & opcode_4_2_111
                        & opcode_1_0_11;
wire rv32_all0s1s_ilgl = rv32_all0s_ilgl | rv32_all1s_ilgl;
wire rv32_ilgl  = rv32_shamt_ilgl;

//  RV16
wire [`RS_CODE_WIDTH - 1 : 0] rv16_rd   = rv32_rd;
wire [`RS_CODE_WIDTH - 1 : 0] rv16_rs1  = rv16_rd;
wire [`RS_CODE_WIDTH - 1 : 0] rv16_rs2  = rv32_instr[6 : 2];

wire [`RS_CODE_WIDTH - 1 : 0] rv16_rdd  = {2'b01, rv32_instr[4 : 2]};
wire [`RS_CODE_WIDTH - 1 : 0] rv16_rss1 = {2'b01, rv32_instr[9 : 7]};
wire [`RS_CODE_WIDTH - 1 : 0] rv16_rss2 = rv16_rdd;

wire [2 : 0] rv16_func3 = rv32_instr[15 : 13];

wire rv16_rs1_x0    = (rv16_rs1 == 5'b00000);
wire rv16_rs2_x0    = (rv16_rs2 == 5'b00000);
wire rv16_rd_x0     = (rv16_rd  == 5'b00000);
wire rv16_rd_x2     = (rv16_rd  == 5'b00010);

wire rv16_func3_000 = (rv16_func3 == 3'b000);
wire rv16_func3_001 = (rv16_func3 == 3'b001);
wire rv16_func3_010 = (rv16_func3 == 3'b010);
wire rv16_func3_011 = (rv16_func3 == 3'b011);
wire rv16_func3_100 = (rv16_func3 == 3'b100);
wire rv16_func3_101 = (rv16_func3 == 3'b101);
wire rv16_func3_110 = (rv16_func3 == 3'b110);
wire rv16_func3_111 = (rv16_func3 == 3'b111);

wire rv16_addi4spn      = opcode_1_0_00 & rv16_func3_000;
wire rv16_lw            = opcode_1_0_00 & rv16_func3_010;
wire rv16_ld            = 1'b0;
wire rv16_sw            = opcode_1_0_00 & rv16_func3_110;
wire rv16_sd            = 1'b0;

wire rv16_addi          = opcode_1_0_01 & rv16_func3_000;
wire rv16_jal           = opcode_1_0_01 & rv16_func3_001;
wire rv16_li            = opcode_1_0_01 & rv16_func3_010;
wire rv16_lui_addi16sp  = opcode_1_0_01 & rv16_func3_011;
wire rv16_op            = opcode_1_0_01 & rv16_func3_100;
wire rv16_j             = opcode_1_0_01 & rv16_func3_101;
wire rv16_beqz          = opcode_1_0_01 & rv16_func3_110;
wire rv16_bnez          = opcode_1_0_01 & rv16_func3_111;

wire rv16_lui           = rv16_lui_addi16sp & (~rv32_rd_x0) & (~rv32_rd_x2);
wire rv16_addi16sp      = rv16_lui_addi16sp & (rv32_rd_x2);

wire rv16_subxororand   = rv16_op   & (rv16_instr[12 : 10] == 3'b011);
wire rv16_sub           = rv16_subxororand & (rv16_instr[6 : 5] == 2'b00);
wire rv16_xor           = rv16_subxororand & (rv16_instr[6 : 5] == 2'b01);
wire rv16_or            = rv16_subxororand & (rv16_instr[6 : 5] == 2'b10);
wire rv16_and           = rv16_subxororand & (rv16_instr[6 : 5] == 2'b11);

wire rv16_miscalu       = opcode_1_0_01 & rv16_func3_100;
wire rv16_srli          = rv16_miscalu  & (rv16_instr[11 : 10] == 2'b00);
wire rv16_srai          = rv16_miscalu  & (rv16_instr[11 : 10] == 2'b01);
wire rv16_andi          = rv16_miscalu  & (rv16_instr[11 : 10] == 2'b10);

wire rv16_slli          = opcode_1_0_10 & rv16_func3_000;
wire rv16_lwsp          = opcode_1_0_10 & rv16_func3_010;
wire rv16_ldsp          = 1'b0;
wire rv16_jalr_mv_add   = opcode_1_0_10 & rv16_func3_100;
wire rv16_swsp          = opcode_1_0_10 & rv16_func3_110;
wire rv16_sdsp          = 1'b0;
wire rv16_jalr          = rv16_jalr_mv_add & (rv16_instr[12])  & (~rv16_rs1_x0) & (rv16_rs2_x0);
wire rv16_jr            = rv16_jalr_mv_add & (~rv16_instr[12]) & (~rv16_rs1_x0) & (rv16_rs2_x0);
wire rv16_mv            = rv16_jalr_mv_add & (~rv16_instr[12]) & (~rv16_rd_x0)  & (~rv16_rs2_x0);
wire rv16_ebreak        = rv16_jalr_mv_add & (rv16_instr[12])  & (rv16_rd_x0)   & (rv16_rs2_x0);
wire rv16_add           = rv16_jalr_mv_add & (rv16_instr[12])  & (~rv16_rd_x0)  & (~rv16_rs2_x0);


wire rv16_flw           = opcode_1_0_00 & rv16_func3_011;
wire rv16_fld           = opcode_1_0_00 & rv16_func3_001;
wire rv16_fsw           = opcode_1_0_00 & rv16_func3_111;
wire rv16_fsd           = opcode_1_0_00 & rv16_func3_101;
wire rv16_fldsp         = opcode_1_0_10 & rv16_func3_001;
wire rv16_flwsp         = opcode_1_0_10 & rv16_func3_011;
wire rv16_fsdsp         = opcode_1_0_10 & rv16_func3_101;
wire rv16_fswsp         = opcode_1_0_10 & rv16_func3_111;

wire rv16_nop           = rv16_addi & (~rv16_instr[12]) & (rv16_rd_x0) & (rv16_rs2_x0);

wire rv16_imm_sel_cis   = rv16_lwsp | rv16_flwsp;
wire [`IMM_WIDTH - 1 : 0] rv16_cis_imm = {
                                          24'b0
                                        , rv16_instr[3:2]
                                        , rv16_instr[12]
                                        , rv16_instr[6:4]
                                        , 2'b0
                                         };

wire rv16_imm_sel_cis_d = rv16_ldsp | rv16_fldsp;
wire [`IMM_WIDTH - 1 : 0] rv16_cis_d_imm= {
                                          23'b0
                                        , rv16_instr[4:2]
                                        , rv16_instr[12]
                                        , rv16_instr[6:5]
                                        , 3'b0
                                         };

wire rv16_imm_sel_cili  = rv16_li | rv16_addi | rv16_slli | rv16_srai | rv16_srli | rv16_andi;
wire [`IMM_WIDTH - 1 : 0] rv16_cili_imm = {
                                          {26{rv16_instr[12]}}
                                        , rv16_instr[12]
                                        , rv16_instr[6:2]
                                         };

wire rv16_imm_sel_cilui = rv16_lui;
wire [`IMM_WIDTH - 1 : 0] rv16_cilui_imm = {
                                          {14{rv16_instr[12]}}
                                        , rv16_instr[12]
                                        , rv16_instr[6:2]
                                        , 12'b0
                                         };

wire rv16_imm_sel_ci16sp    = rv16_addi16sp;
wire [`IMM_WIDTH - 1 : 0] rv16_ci16sp_imm = {
                                          {22{rv16_instr[12]}}
                                        , rv16_instr[12]
                                        , rv16_instr[4]
                                        , rv16_instr[3]
                                        , rv16_instr[5]
                                        , rv16_instr[2]
                                        , rv16_instr[6]
                                        , 4'b0
                                         };

wire rv16_imm_sel_css   = rv16_swsp | rv16_fswsp;
wire [`IMM_WIDTH - 1 : 0] rv16_css_imm  = {
                                          24'b0
                                        , rv16_instr[8:7]
                                        , rv16_instr[12:9]
                                        , 2'b0
                                         };

wire rv16_imm_sel_css_d = rv16_sdsp | rv16_fsdsp;
wire [`IMM_WIDTH - 1 : 0] rv16_css_d_imm= {
                                          23'b0
                                        , rv16_instr[9:7]
                                        , rv16_instr[12:10]
                                        , 3'b0
                                         };

wire rv16_imm_sel_ciw   = rv16_addi4spn;
wire [`IMM_WIDTH - 1 : 0] rv16_ciw_imm  = {
                                          22'b0
                                        , rv16_instr[10:7]
                                        , rv16_instr[12]
                                        , rv16_instr[11]
                                        , rv16_instr[5]
                                        , rv16_instr[6]
                                        , 2'b0
                                         };

wire rv16_imm_sel_cl    = rv16_lw | rv16_flw;
wire [`IMM_WIDTH - 1 : 0] rv16_cl_imm   = {
                                          25'b0
                                        , rv16_instr[5]
                                        , rv16_instr[12]
                                        , rv16_instr[11]
                                        , rv16_instr[10]
                                        , rv16_instr[6]
                                        , 2'b0
                                         };

wire rv16_imm_sel_cl_d  = rv16_ld | rv16_fld;
wire [`IMM_WIDTH - 1 : 0] rv16_cl_d_imm = {
                                          24'b0
                                        , rv16_instr[6]
                                        , rv16_instr[5]
                                        , rv16_instr[12]
                                        , rv16_instr[11]
                                        , rv16_instr[10]
                                        , 3'b0
                                         };

wire rv16_imm_sel_cs    = rv16_sw | rv16_fsw;
wire [`IMM_WIDTH - 1 : 0] rv16_cs_imm   = {
                                          25'b0
                                        , rv16_instr[5]
                                        , rv16_instr[12]
                                        , rv16_instr[11]
                                        , rv16_instr[10]
                                        , rv16_instr[6]
                                        , 2'b0
                                         };

wire rv16_imm_sel_cs_d  = rv16_sd | rv16_fsd;
wire [`IMM_WIDTH - 1 : 0] rv16_cs_d_imm = {
                                          24'b0
                                        , rv16_instr[6]
                                        , rv16_instr[5]
                                        , rv16_instr[12]
                                        , rv16_instr[11]
                                        , rv16_instr[10]
                                        , 3'b0
                                         };

wire rv16_imm_sel_cb    = rv16_beqz | rv16_bnez;
wire [`IMM_WIDTH - 1 : 0] rv16_cb_imm   = {
                                          {23{rv16_instr[12]}}
                                        , rv16_instr[12]
                                        , rv16_instr[6:5]
                                        , rv16_instr[2]
                                        , rv16_instr[11:10]
                                        , rv16_instr[4:3]
                                        , 1'b0
                                         };

wire rv16_imm_sel_cj    = rv16_j | rv16_jal;
wire [`IMM_WIDTH - 1 : 0] rv16_cj_imm   = {
                                          {20{rv16_instr[12]}}
                                        , rv16_instr[12]
                                        , rv16_instr[8]
                                        , rv16_instr[10:9]
                                        , rv16_instr[6]
                                        , rv16_instr[7]
                                        , rv16_instr[2]
                                        , rv16_instr[11]
                                        , rv16_instr[5:3]
                                        , 1'b0
                                         };

wire rv16_imm_valid  = rv16_imm_sel_cis
                    | rv16_imm_sel_cis_d
                    | rv16_imm_sel_cili
                    | rv16_imm_sel_cilui
                    | rv16_imm_sel_ci16sp
                    | rv16_imm_sel_css
                    | rv16_imm_sel_css_d
                    | rv16_imm_sel_ciw
                    | rv16_imm_sel_cl
                    | rv16_imm_sel_cl_d
                    | rv16_imm_sel_cs
                    | rv16_imm_sel_cs_d
                    | rv16_imm_sel_cb
                    | rv16_imm_sel_cj;
wire [`IMM_WIDTH - 1 : 0] rv16_imm  = ({`IMM_WIDTH{rv16_imm_sel_cis     }}      & rv16_cis_imm      )
                                    | ({`IMM_WIDTH{rv16_imm_sel_cis_d   }}      & rv16_cis_d_imm    )
                                    | ({`IMM_WIDTH{rv16_imm_sel_cili    }}      & rv16_cili_imm     )
                                    | ({`IMM_WIDTH{rv16_imm_sel_cilui   }}      & rv16_cilui_imm    )
                                    | ({`IMM_WIDTH{rv16_imm_sel_ci16sp  }}      & rv16_ci16sp_imm   )
                                    | ({`IMM_WIDTH{rv16_imm_sel_css     }}      & rv16_css_imm      )
                                    | ({`IMM_WIDTH{rv16_imm_sel_css_d   }}      & rv16_css_d_imm    )
                                    | ({`IMM_WIDTH{rv16_imm_sel_ciw     }}      & rv16_ciw_imm      )
                                    | ({`IMM_WIDTH{rv16_imm_sel_cl      }}      & rv16_cl_imm       )
                                    | ({`IMM_WIDTH{rv16_imm_sel_cl_d    }}      & rv16_cl_d_imm     )
                                    | ({`IMM_WIDTH{rv16_imm_sel_cs      }}      & rv16_cs_imm       )
                                    | ({`IMM_WIDTH{rv16_imm_sel_cs_d    }}      & rv16_cs_d_imm     )
                                    | ({`IMM_WIDTH{rv16_imm_sel_cb      }}      & rv16_cb_imm       )
                                    | ({`IMM_WIDTH{rv16_imm_sel_cj      }}      & rv16_cj_imm       );


wire rv16_format_cr     = rv16_jalr_mv_add;
wire rv16_format_ci     = rv16_lwsp | rv16_flwsp | rv16_fldsp | rv16_li | rv16_lui_addi16sp | rv16_addi | rv16_slli;
wire rv16_format_css    = rv16_swsp | rv16_fswsp | rv16_fsdsp;
wire rv16_format_ciw    = rv16_addi4spn;
wire rv16_format_cl     = rv16_lw | rv16_flw | rv16_fld;
wire rv16_format_cs     = rv16_sw | rv16_fsw | rv16_fsd;
wire rv16_format_cb     = rv16_beqz | rv16_bnez | rv16_srli | rv16_srai | rv16_andi;
wire rv16_format_cj     = rv16_j | rv16_jal;

//  CR Format
wire rv16_need_cr_rs1   = rv16_format_cr & 1'b1;
wire rv16_need_cr_rs2   = rv16_format_cr & 1'b1;
wire rv16_need_cr_rd    = rv16_format_cr & 1'b1;
wire [`RS_CODE_WIDTH - 1 : 0] rv16_cr_rs1   = rv16_mv   ?   `RS_CODE_WIDTH'd0 : rv16_rs1;
wire [`RS_CODE_WIDTH - 1 : 0] rv16_cr_rs2   = rv16_rs2;
wire [`RS_CODE_WIDTH - 1 : 0] rv16_cr_rd    = (rv16_jalr | rv16_jr) ? {{`RS_CODE_WIDTH{1'b0}}, rv16_instr[12]}
                                            : rv16_rd;

//  CI Format
wire rv16_need_ci_rs1   = rv16_format_ci & 1'b1;
wire rv16_need_ci_rs2   = rv16_format_ci & 1'b0;
wire rv16_need_ci_rd    = rv16_format_ci & 1'b1;
wire [`RS_CODE_WIDTH - 1 : 0] rv16_ci_rs1   = (rv16_lwsp | rv16_flwsp | rv16_fldsp) ? `RS_CODE_WIDTH'd2
                                            : (rv16_lui | rv16_li) ? `RS_CODE_WIDTH'd0
                                            : rv16_rs1;
wire [`RS_CODE_WIDTH - 1 : 0] rv16_ci_rs2   = `RS_CODE_WIDTH'd0;
wire [`RS_CODE_WIDTH - 1 : 0] rv16_ci_rd    = rv16_rd;

//  CSS Format
wire rv16_need_css_rs1  = rv16_format_css & 1'b1;
wire rv16_need_css_rs2  = rv16_format_css & 1'b1;
wire rv16_need_css_rd   = rv16_format_css & 1'b0;
wire [`RS_CODE_WIDTH - 1 : 0] rv16_css_rs1  = `RS_CODE_WIDTH'd2;
wire [`RS_CODE_WIDTH - 1 : 0] rv16_css_rs2  = rv16_rs2;
wire [`RS_CODE_WIDTH - 1 : 0] rv16_css_rd   = `RS_CODE_WIDTH'd0;

//  CIW Format
wire rv16_need_ciw_rss1 = rv16_format_ciw & 1'b1;
wire rv16_need_ciw_rss2 = rv16_format_ciw & 1'b0;
wire rv16_need_ciw_rdd  = rv16_format_ciw & 1'b1;
wire [`RS_CODE_WIDTH - 1 : 0] rv16_ciw_rss1 = `RS_CODE_WIDTH'd2;
wire [`RS_CODE_WIDTH - 1 : 0] rv16_ciw_rss2 = `RS_CODE_WIDTH'd0;
wire [`RS_CODE_WIDTH - 1 : 0] rv16_ciw_rdd  = rv16_rdd;

//  CL Format
wire rv16_need_cl_rss1  = rv16_format_cl & 1'b1;
wire rv16_need_cl_rss2  = rv16_format_cl & 1'b0;
wire rv16_need_cl_rdd   = rv16_format_cl & 1'b1;
wire [`RS_CODE_WIDTH - 1 : 0] rv16_cl_rss1  = rv16_rss1;
wire [`RS_CODE_WIDTH - 1 : 0] rv16_cl_rss2  = `RS_CODE_WIDTH'd0;
wire [`RS_CODE_WIDTH - 1 : 0] rv16_cl_rdd   = rv16_rdd;

//  CS Format
wire rv16_need_cs_rss1  = rv16_format_cs & 1'b1;
wire rv16_need_cs_rss2  = rv16_format_cs & 1'b1;
wire rv16_need_cs_rdd   = rv16_format_cs & rv16_subxororand;
wire [`RS_CODE_WIDTH - 1 : 0] rv16_cs_rss1 = rv16_rss1;
wire [`RS_CODE_WIDTH - 1 : 0] rv16_cs_rss2 = rv16_rss2;
wire [`RS_CODE_WIDTH - 1 : 0] rv16_cs_rdd  = rv16_rss1;

//  CB Format
wire rv16_need_cb_rss1  = rv16_format_cb & 1'b1;
wire rv16_need_cb_rss2  = rv16_format_cb & (rv16_beqz | rv16_bnez);
wire rv16_need_cb_rdd   = rv16_format_cb & (~(rv16_beqz | rv16_bnez));
wire [`RS_CODE_WIDTH - 1 : 0] rv16_cb_rss1  = rv16_rss1;
wire [`RS_CODE_WIDTH - 1 : 0] rv16_cb_rss2  = `RS_CODE_WIDTH'd0;
wire [`RS_CODE_WIDTH - 1 : 0] rv16_cb_rdd   = rv16_rss1;

//  CJ Format
wire rv16_need_cj_rss1  = rv16_format_cj & 1'b0;
wire rv16_need_cj_rss2  = rv16_format_cj & 1'b0;
wire rv16_need_cj_rdd   = rv16_format_cj & 1'b1;
wire [`RS_CODE_WIDTH - 1 : 0] rv16_cj_rss1 = `RS_CODE_WIDTH'd0;
wire [`RS_CODE_WIDTH - 1 : 0] rv16_cj_rss2 = `RS_CODE_WIDTH'd0;
wire [`RS_CODE_WIDTH - 1 : 0] rv16_cj_rdd  = rv16_j ? `RS_CODE_WIDTH'd0 : `RS_CODE_WIDTH'd1;

//
wire rv16_need_rs1  = rv16_need_cr_rs1 | rv16_need_ci_rs1 | rv16_need_css_rs1;
wire rv16_need_rs2  = rv16_need_cr_rs2 | rv16_need_ci_rs2 | rv16_need_css_rs2;
wire rv16_need_rd   = rv16_need_cr_rd  | rv16_need_ci_rd  | rv16_need_css_rd;

wire rv16_need_rss1 = rv16_need_ciw_rss1 | rv16_need_cl_rss1 | rv16_need_cs_rss1 | rv16_need_cb_rss1 | rv16_need_cj_rss1;
wire rv16_need_rss2 = rv16_need_ciw_rss2 | rv16_need_cl_rss2 | rv16_need_cs_rss2 | rv16_need_cb_rss2 | rv16_need_cj_rss2;
wire rv16_need_rdd  = rv16_need_ciw_rdd  | rv16_need_cl_rdd  | rv16_need_cs_rdd  | rv16_need_cb_rdd  | rv16_need_cj_rdd;

wire rv16_rs1_valid = rv16_need_rs1 | rv16_need_rss1;
wire rv16_rs2_valid = rv16_need_rs2 | rv16_need_rss2;
wire rv16_rs3_valid = 1'b0;
wire rv16_rd_valid  = rv16_need_rd  | rv16_need_rdd;

wire [`RS_CODE_WIDTH - 1 : 0] rv16_rs1_code = ({`RS_CODE_WIDTH{rv16_need_cr_rs1  }}      & rv16_cr_rs1   )
                                            | ({`RS_CODE_WIDTH{rv16_need_ci_rs1  }}      & rv16_ci_rs1   )
                                            | ({`RS_CODE_WIDTH{rv16_need_css_rs1 }}      & rv16_css_rs1  )
                                            | ({`RS_CODE_WIDTH{rv16_need_ciw_rss1}}      & rv16_ciw_rss1 )
                                            | ({`RS_CODE_WIDTH{rv16_need_cl_rss1 }}      & rv16_cl_rss1  )
                                            | ({`RS_CODE_WIDTH{rv16_need_cs_rss1 }}      & rv16_cl_rss1  )
                                            | ({`RS_CODE_WIDTH{rv16_need_cb_rss1 }}      & rv16_cb_rss1  )
                                            | ({`RS_CODE_WIDTH{rv16_need_cj_rss1 }}      & rv16_cj_rss1  );

wire [`RS_CODE_WIDTH - 1 : 0] rv16_rs2_code = ({`RS_CODE_WIDTH{rv16_need_cr_rs2  }}      & rv16_cr_rs2   )
                                            | ({`RS_CODE_WIDTH{rv16_need_ci_rs2  }}      & rv16_ci_rs2   )
                                            | ({`RS_CODE_WIDTH{rv16_need_css_rs2 }}      & rv16_css_rs2  )
                                            | ({`RS_CODE_WIDTH{rv16_need_ciw_rss2}}      & rv16_ciw_rss2 )
                                            | ({`RS_CODE_WIDTH{rv16_need_cl_rss2 }}      & rv16_cl_rss2  )
                                            | ({`RS_CODE_WIDTH{rv16_need_cs_rss2 }}      & rv16_cl_rss2  )
                                            | ({`RS_CODE_WIDTH{rv16_need_cb_rss2 }}      & rv16_cb_rss2  )
                                            | ({`RS_CODE_WIDTH{rv16_need_cj_rss2 }}      & rv16_cj_rss2  );
wire [`RS_CODE_WIDTH - 1 : 0] rv16_rs3_code = `RS_CODE_WIDTH'd0;
wire [`RS_CODE_WIDTH - 1 : 0] rv16_rd_code  = ({`RS_CODE_WIDTH{rv16_need_cr_rd  }}      & rv16_cr_rd   )
                                            | ({`RS_CODE_WIDTH{rv16_need_ci_rd  }}      & rv16_ci_rd   )
                                            | ({`RS_CODE_WIDTH{rv16_need_css_rd }}      & rv16_css_rd  )
                                            | ({`RS_CODE_WIDTH{rv16_need_ciw_rdd}}      & rv16_ciw_rdd )
                                            | ({`RS_CODE_WIDTH{rv16_need_cl_rdd }}      & rv16_cl_rdd  )
                                            | ({`RS_CODE_WIDTH{rv16_need_cs_rdd }}      & rv16_cl_rdd  )
                                            | ({`RS_CODE_WIDTH{rv16_need_cb_rdd }}      & rv16_cb_rdd  )
                                            | ({`RS_CODE_WIDTH{rv16_need_cj_rdd }}      & rv16_cj_rdd  );

//
wire rv16_all0s_ilgl    = rv16_func3_000
                        & rv32_func3_000
                        & rv32_rd_x0
                        & opcode_6_5_00
                        & opcode_4_2_000
                        & opcode_1_0_00;
wire rv16_all1s_ilgl    = rv16_func3_111
                        & rv32_func3_111
                        & rv32_rd_x31
                        & opcode_6_5_11
                        & opcode_4_2_111
                        & opcode_1_0_11;
wire rv16_all0s1s_ilgl  = rv16_all0s_ilgl | rv16_all1s_ilgl;

wire rv16_shamt_ilgl    = (rv16_slli | rv16_srli | rv16_srai) & ((rv16_instr[12]) | (opcode_6_5_00 & opcode_4_2_000));
wire rv16_li_ilgl       = rv16_li & rv16_rd_x0;
wire rv16_lui_ilgl      = rv16_lui & (rv16_rd_x0 | rv16_rd_x2 | ((opcode_6_5_00 & opcode_4_2_000) & (~rv16_instr[12])));
wire rv16_li_lui_ilgl   = rv16_li_ilgl | rv16_lui_ilgl;
wire rv16_addi4spn_ilgl = rv16_addi4spn & ((~rv16_instr[12]) & rv16_rd_x0 & opcode_6_5_00);
wire rv16_addi16sp_ilgl = rv16_addi16sp & ((~rv16_instr[12]) & (opcode_6_5_00 & opcode_4_2_000));
wire rv16_lwsp_ilgl     = rv16_lwsp & rv16_rd_x0;
wire rv16_flwsp_ilgl    = 1'b0;
wire rv16_ldsp_ilgl     = rv16_ldsp & rv16_rd_x0;
wire rv16_fldsp_ilgl    = 1'b0;

wire rv16_ilgl          = (rv16_shamt_ilgl
                        |  rv16_li_lui_ilgl
                        |  rv16_addi4spn_ilgl
                        |  rv16_addi16sp_ilgl
                        |  rv16_lwsp_ilgl
                        |  rv16_flwsp_ilgl
                        |  rv16_ldsp_ilgl
                        |  rv16_fldsp_ilgl);

//
wire rv32           = (~(i_dec_instr[4 : 2] == 3'b111)) & opcode_1_0_11;


//  Decoder info bus
//  BJP INFO BUS
wire [`UOP_INFO_BUS_WIDTH - 1 : 0] bjp_info_bus;
assign bjp_info_bus[`UOPINFO_EXEC_UNIT      ]   = `UOPINFO_BJP;
assign bjp_info_bus[`UOPINFO_BJP_JUMP       ]   = rv32_jal | rv32_jalr | rv16_jalr | rv16_jr | rv16_jal | rv16_j;
assign bjp_info_bus[`UOPINFO_BJP_BEQ        ]   = rv32_beq | rv16_beqz;
assign bjp_info_bus[`UOPINFO_BJP_BNE        ]   = rv32_bne | rv16_bnez;
assign bjp_info_bus[`UOPINFO_BJP_BLT        ]   = rv32_blt;
assign bjp_info_bus[`UOPINFO_BJP_BLTU       ]   = rv32_bltu;
assign bjp_info_bus[`UOPINFO_BJP_BGE        ]   = rv32_bge;
assign bjp_info_bus[`UOPINFO_BJP_BGEU       ]   = rv32_bgeu;
assign bjp_info_bus[`UOPINFO_BJP_MRET       ]   = rv32_mret;
assign bjp_info_bus[`UOPINFO_BJP_SRET       ]   = rv32_sret;
assign bjp_info_bus[`UOPINFO_BJP_URET       ]   = rv32_uret;

//  ALU INFO BUS
wire [`UOP_INFO_BUS_WIDTH - 1 : 0] alu_info_bus;
assign alu_info_bus[`UOPINFO_EXEC_UNIT      ]   = `UOPINFO_ALU;
assign alu_info_bus[`UOPINFO_ALU_ADD        ]   = rv32_add | rv32_addi | rv32_auipc |
                                                  rv16_addi4spn | rv16_addi | rv16_addi16sp | rv16_add |
                                                  rv16_li  | rv16_mv;
assign alu_info_bus[`UOPINFO_ALU_SUB        ]   = rv32_sub | rv16_sub;
assign alu_info_bus[`UOPINFO_ALU_SLT        ]   = rv32_slt | rv32_slti;
assign alu_info_bus[`UOPINFO_ALU_SLTU       ]   = rv32_sltu| rv32_sltiu;
assign alu_info_bus[`UOPINFO_ALU_XOR        ]   = rv32_xor | rv32_xori | rv16_xor;
assign alu_info_bus[`UOPINFO_ALU_SLL        ]   = rv32_sll | rv32_slli | rv16_slli;
assign alu_info_bus[`UOPINFO_ALU_SRL        ]   = rv32_srl | rv32_srli | rv16_srli;
assign alu_info_bus[`UOPINFO_ALU_SRA        ]   = rv32_sra | rv32_srai | rv16_srai;
assign alu_info_bus[`UOPINFO_ALU_OR         ]   = rv32_or  | rv32_ori  | rv16_or;
assign alu_info_bus[`UOPINFO_ALU_AND        ]   = rv32_and | rv32_andi | rv16_and | rv16_andi;
assign alu_info_bus[`UOPINFO_ALU_LUI        ]   = rv32_lui | rv16_lui;
assign alu_info_bus[`UOPINFO_ALU_OPIMM      ]   = o_dec_imm_vld;
assign alu_info_bus[`UOPINFO_ALU_NOP        ]   = rv32_nop | rv16_nop;
assign alu_info_bus[`UOPINFO_ALU_FENCE      ]   = rv32_fence;
assign alu_info_bus[`UOPINFO_ALU_FENCE_I    ]   = rv32_fencei;
assign alu_info_bus[`UOPINFO_ALU_SFENCEVMA  ]   = rv32_sfence_vma;
assign alu_info_bus[`UOPINFO_ALU_ECALL      ]   = rv32_ecall;
assign alu_info_bus[`UOPINFO_ALU_EBRK       ]   = rv32_ebreak | rv16_ebreak;
assign alu_info_bus[`UOPINFO_ALU_WFI        ]   = rv32_wfi;

//  MULDIV INFO BUS
wire [`UOP_INFO_BUS_WIDTH - 1 : 0] muldiv_info_bus;
assign muldiv_info_bus[`UOPINFO_EXEC_UNIT      ]   = `UOPINFO_MULDIV;
assign muldiv_info_bus[`UOPINFO_MULDIV_MUL     ]   = rv32_mul;
assign muldiv_info_bus[`UOPINFO_MULDIV_MULH    ]   = rv32_mulh;
assign muldiv_info_bus[`UOPINFO_MULDIV_MULHU   ]   = rv32_mulhu;
assign muldiv_info_bus[`UOPINFO_MULDIV_MULHSU  ]   = rv32_mulhsu;
assign muldiv_info_bus[`UOPINFO_MULDIV_DIV     ]   = rv32_div;
assign muldiv_info_bus[`UOPINFO_MULDIV_DIVU    ]   = rv32_divu;
assign muldiv_info_bus[`UOPINFO_MULDIV_REM     ]   = rv32_rem;
assign muldiv_info_bus[`UOPINFO_MULDIV_REMU    ]   = rv32_remu;

//  CSR INFO BUS
wire [`UOP_INFO_BUS_WIDTH - 1 : 0] csr_info_bus;
assign csr_info_bus[`UOPINFO_EXEC_UNIT      ]   = `UOPINFO_CSR;
assign csr_info_bus[`UOPINFO_CSR_CSRRW      ]   = rv32_csrrw;
assign csr_info_bus[`UOPINFO_CSR_CSRRS      ]   = rv32_csrrs;
assign csr_info_bus[`UOPINFO_CSR_CSRRC      ]   = rv32_csrrc;
assign csr_info_bus[`UOPINFO_CSR_CSRRWI     ]   = rv32_csrrwi;
assign csr_info_bus[`UOPINFO_CSR_CSRRSI     ]   = rv32_csrrsi;
assign csr_info_bus[`UOPINFO_CSR_CSRRCI     ]   = rv32_csrrci;
assign csr_info_bus[`UOPINFO_CSR_ZIMM       ]   = rv32_rs1;
assign csr_info_bus[`UOPINFO_CSR_RS1IS0     ]   = rv32_rs1_x0;
assign csr_info_bus[`UOPINFO_CSR_RD1IS0     ]   = rv32_rd_x0;
assign csr_info_bus[`UOPINFO_CSR_ADDR       ]   = rv32_instr[31 : 20];

//  AGU INFO BUS
wire [1 : 0] agu_size   = rv32 ? rv32_func3[1 : 0] : 2'b10;
wire agu_usign          = rv32 ? rv32_func3[2] : 1'b0;

wire [`UOP_INFO_BUS_WIDTH - 1 : 0] agu_info_bus;
assign agu_info_bus[`UOPINFO_EXEC_UNIT      ]   = `UOPINFO_AGU;
assign agu_info_bus[`UOPINFO_AGU_LOAD       ]   = rv32_load     | rv32_lrw |
                                                  rv32_fpu_load | rv16_lw  |
                                                  rv16_lwsp     | rv16_flw |
                                                  rv16_fld      | rv16_fldsp |
                                                  rv16_flwsp;
assign agu_info_bus[`UOPINFO_AGU_STORE      ]   = rv32_store     | rv32_scw |
                                                  rv32_fpu_store | rv16_sw  |
                                                  rv16_swsp      | rv16_fsw |
                                                  rv16_fsd       | rv16_fsdsp |
                                                  rv16_fswsp;
assign agu_info_bus[`UOPINFO_AGU_SIZE       ]   = agu_size;
assign agu_info_bus[`UOPINFO_AGU_USIGN      ]   = agu_usign;
assign agu_info_bus[`UOPINFO_AGU_EXCL       ]   = rv32_lrw | rv32_scw;
assign agu_info_bus[`UOPINFO_AGU_AMOSWAPW   ]   = rv32_amoswapw;
assign agu_info_bus[`UOPINFO_AGU_AMOADDW    ]   = rv32_amoaddw;
assign agu_info_bus[`UOPINFO_AGU_AMOXORW    ]   = rv32_amoxorw;
assign agu_info_bus[`UOPINFO_AGU_AMOANDW    ]   = rv32_amoandw;
assign agu_info_bus[`UOPINFO_AGU_AMOORW     ]   = rv32_amoorw;
assign agu_info_bus[`UOPINFO_AGU_AMOMINW    ]   = rv32_amominw;
assign agu_info_bus[`UOPINFO_AGU_AMOMAXW    ]   = rv32_amomaxw;
assign agu_info_bus[`UOPINFO_AGU_AMOMINUW   ]   = rv32_amominuw;
assign agu_info_bus[`UOPINFO_AGU_AMOMAXUW   ]   = rv32_amomaxuw;

//  FPU INFO BUS
wire [1 : 0] rv32_fpu_precsion = 2'b00; // singal
wire [`UOP_INFO_BUS_WIDTH - 1 : 0] fpu_info_bus;
assign fpu_info_bus[`UOPINFO_EXEC_UNIT      ]   = `UOPINFO_FPU;
assign fpu_info_bus[`UOPINFO_FPU_PRECSION   ]   = rv32_fpu_precsion;
assign fpu_info_bus[`UOPINFO_FPU_FMADDS     ]   = rv32_fpu_madds;
assign fpu_info_bus[`UOPINFO_FPU_FMSUBS     ]   = rv32_fpu_msubs;
assign fpu_info_bus[`UOPINFO_FPU_FNMSUBS    ]   = rv32_fpu_nmsubs;
assign fpu_info_bus[`UOPINFO_FPU_FNMADDS    ]   = rv32_fpu_nmadds;
assign fpu_info_bus[`UOPINFO_FPU_ADDS       ]   = rv32_fadds;
assign fpu_info_bus[`UOPINFO_FPU_SUBS       ]   = rv32_fsubs;
assign fpu_info_bus[`UOPINFO_FPU_MULS       ]   = rv32_fmuls;
assign fpu_info_bus[`UOPINFO_FPU_DIVS       ]   = rv32_fdivs;
assign fpu_info_bus[`UOPINFO_FPU_SQRTS      ]   = rv32_fsqrts;
assign fpu_info_bus[`UOPINFO_FPU_SGNJS      ]   = rv32_fsgnjs;
assign fpu_info_bus[`UOPINFO_FPU_SGNJNS     ]   = rv32_fsgnjxs;
assign fpu_info_bus[`UOPINFO_FPU_MINS       ]   = rv32_fmins;
assign fpu_info_bus[`UOPINFO_FPU_MAXS       ]   = rv32_fmaxs;
assign fpu_info_bus[`UOPINFO_FPU_CVTWS      ]   = rv32_fcvtws;
assign fpu_info_bus[`UOPINFO_FPU_CVTWUS     ]   = rv32_fcvtwus;
assign fpu_info_bus[`UOPINFO_FPU_MVXW       ]   = rv32_fmvxw;
assign fpu_info_bus[`UOPINFO_FPU_FEQS       ]   = rv32_feqs;
assign fpu_info_bus[`UOPINFO_FPU_FLTS       ]   = rv32_flts;
assign fpu_info_bus[`UOPINFO_FPU_FLES       ]   = rv32_fles;
assign fpu_info_bus[`UOPINFO_FPU_CLASSS     ]   = rv32_fclasss;
assign fpu_info_bus[`UOPINFO_FPU_CVTSW      ]   = rv32_fcvtsw;
assign fpu_info_bus[`UOPINFO_FPU_CVTSWU     ]   = rv32_fcvtswu;
assign fpu_info_bus[`UOPINFO_FPU_MVWX       ]   = rv32_fmvwx;




//
wire bjp_jal    = rv32_jal | rv16_jal | rv16_j;
wire bjp_jalr   = rv32_jalr| rv16_jalr| rv16_jr;
wire bjp_bxx    = rv32_branch | rv16_beqz | rv16_bnez;
wire bjp_op     = bjp_jal | bjp_jalr | bjp_bxx;

wire alu_op = (~rv32_shamt_ilgl) & (~rv16_shamt_ilgl)
            & (~rv16_li_lui_ilgl) & (~rv16_addi4spn_ilgl) & (~rv16_addi16sp_ilgl)
            &
            (
                rv32_op_imm
            |   rv32_op & (~rv32_func7_0000001)
            |   rv32_fence_op
            |   rv32_sfence_vma
            |   rv32_auipc
            |   rv32_lui
            |   rv32_wfi
            |   rv32_ecall
            |   rv32_ebreak
            |   rv32_nop
            |   rv16_addi4spn
            |   rv16_addi
            |   rv16_lui_addi16sp
            |   rv16_li
            |   rv16_mv
            |   rv16_slli
            |   rv16_op
            |   rv16_add
            |   rv16_nop
            |   rv16_ebreak
            );

wire csr_op     = rv32_csr_op;
wire muldiv_op  = rv32_op & rv32_func7_0000001;
wire fpu_op     = rv32_fpu_madds
                | rv32_fpu_msubs
                | rv32_fpu_nmsubs
                | rv32_fpu_nmadds
                | rv32_fpu_op;
                
wire agu_op     = rv32_amo_op
                | rv32_load
                | rv32_store
                | rv32_fpu_load | rv32_fpu_store
                | rv16_lw | rv16_ld | rv16_flw | rv16_fld
                | rv16_sw | rv16_sd | rv16_fsw | rv16_fsd
                | (rv16_lwsp & (~rv16_lwsp_ilgl))
                | (rv16_ldsp & (~rv16_ldsp_ilgl))
                | rv16_swsp | rv16_sdsp;

wire [`UOP_INFO_BUS_WIDTH - 1 : 0] rv_info_bus = ({`UOP_INFO_BUS_WIDTH{bjp_op   }}      & bjp_info_bus   )
                                               | ({`UOP_INFO_BUS_WIDTH{alu_op   }}      & alu_info_bus   )
                                               | ({`UOP_INFO_BUS_WIDTH{csr_op   }}      & csr_info_bus   )
                                               | ({`UOP_INFO_BUS_WIDTH{muldiv_op}}      & muldiv_info_bus)
                                               | ({`UOP_INFO_BUS_WIDTH{fpu_op   }}      & fpu_info_bus   )
                                               | ({`UOP_INFO_BUS_WIDTH{agu_op   }}      & agu_info_bus   );
wire legl_ops   = bjp_op | alu_op | csr_op | muldiv_op | fpu_op | agu_op;



wire rv_all0s1s_ilgl = rv32 ? rv32_all0s1s_ilgl : rv16_all0s1s_ilgl;

assign o_dec_ilgl         = (rv_all0s1s_ilgl) | (rv32_ilgl & rv32) | (rv16_ilgl & (~rv32)) | (~legl_ops);
assign o_dec_info_bus     = rv_info_bus;
assign o_dec_rs1_vld      = rv32 ? rv32_rs1_valid : rv16_rs1_valid;
assign o_dec_rs1_code     = rv32 ? rv32_rs1_code  : rv16_rs1_code;
assign o_dec_rs2_vld      = rv32 ? rv32_rs2_valid : rv16_rs2_valid;
assign o_dec_rs2_code     = rv32 ? rv32_rs2_code  : rv16_rs2_code;
assign o_dec_rs3_vld      = rv32 ? rv32_rs3_valid : rv16_rs3_valid;
assign o_dec_rs3_code     = rv32 ? rv32_rs3_code  : rv16_rs3_code;
assign o_dec_rd_vld       = rv32 ? rv32_rd_valid  : rv16_rd_valid;
assign o_dec_rd_code      = rv32 ? rv32_rd_code   : rv16_rd_code;
assign o_dec_imm_vld      = rv32 ? rv32_imm_valid : rv16_imm_valid;
assign o_dec_imm          = rv32 ? rv32_imm       : rv16_imm;
assign o_dec_len          = rv32;

endmodule   //  dec_decoder_module

`endif  /*  !__DECODE_DEC_DECODER_V__!  */
