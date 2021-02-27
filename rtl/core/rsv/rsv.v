`ifdef __RSV_RSV_V__ 

module rsv_module (
	input											i_csr_trap_flush,
	input											i_exu_mis_flush,
	input	[`ROB_ID_WIDTH - 1			: 0]		i_exu_mis_rob_id,
	input											i_exu_ls_flush,
	input	[`ROB_ID_WIDTH - 1			: 0]		i_exu_ls_rob_id,

	input	[3							: 0]		i_dsp_rsv_vld,
	input 	[`DECINFO_WIDTH - 1			: 0]		i_dsp_rsv_decinfo_bus_0,
	input 	[`DECINFO_WIDTH - 1			: 0]		i_dsp_rsv_decinfo_bus_1,
	input 	[`DECINFO_WIDTH - 1			: 0]		i_dsp_rsv_decinfo_bus_2,
	input 	[`DECINFO_WIDTH - 1			: 0]		i_dsp_rsv_decinfo_bus_3,
	input	[`PREDINFO_WIDTH - 1		: 0]		i_dsp_rsv_predinfo_bus_0,
	input	[`PREDINFO_WIDTH - 1		: 0]		i_dsp_rsv_predinfo_bus_1,
	input	[`PREDINFO_WIDTH - 1		: 0]		i_dsp_rsv_predinfo_bus_2,
	input	[`PREDINFO_WIDTH - 1		: 0]		i_dsp_rsv_predinfo_bus_3,
	input	[3							: 0]		i_dsp_rsv_len,
	input 											i_dsp_rsv_src1_vld_0,
	input	[`PRF_CODE_WIDTH - 1		: 0]		i_dsp_rsv_src1_prf_code_0,
	input 											i_dsp_rsv_src2_vld_0,
	input	[`PRF_CODE_WIDTH - 1		: 0]		i_dsp_rsv_src2_prf_code_0,
	input 											i_dsp_rsv_src3_vld_0,
	input	[`PRF_CODE_WIDTH - 1		: 0]		i_dsp_rsv_src3_prf_code_0,
	input 											i_dsp_rsv_dst_vld_0,
	input	[`PRF_CODE_WIDTH - 1		: 0]		i_dsp_rsv_dst_prf_code_0,
	input 											i_dsp_rsv_src1_vld_1,
	input	[`PRF_CODE_WIDTH - 1		: 0]		i_dsp_rsv_src1_prf_code_1,
	input 											i_dsp_rsv_src2_vld_1,
	input	[`PRF_CODE_WIDTH - 1		: 0]		i_dsp_rsv_src2_prf_code_1,
	input 											i_dsp_rsv_src3_vld_1,
	input	[`PRF_CODE_WIDTH - 1		: 0]		i_dsp_rsv_src3_prf_code_1,
	input 											i_dsp_rsv_dst_vld_1,
	input	[`PRF_CODE_WIDTH - 1		: 0]		i_dsp_rsv_dst_prf_code_1,
	input 											i_dsp_rsv_src1_vld_2,
	input	[`PRF_CODE_WIDTH - 1		: 0]		i_dsp_rsv_src1_prf_code_2,
	input 											i_dsp_rsv_src2_vld_2,
	input	[`PRF_CODE_WIDTH - 1		: 0]		i_dsp_rsv_src2_prf_code_2,
	input 											i_dsp_rsv_src3_vld_2,
	input	[`PRF_CODE_WIDTH - 1		: 0]		i_dsp_rsv_src3_prf_code_2,
	input 											i_dsp_rsv_dst_vld_2,
	input	[`PRF_CODE_WIDTH - 1		: 0]		i_dsp_rsv_dst_prf_code_2,
	input 											i_dsp_rsv_src1_vld_3,
	input	[`PRF_CODE_WIDTH - 1		: 0]		i_dsp_rsv_src1_prf_code_3,
	input 											i_dsp_rsv_src2_vld_3,
	input	[`PRF_CODE_WIDTH - 1		: 0]		i_dsp_rsv_src2_prf_code_3,
	input 											i_dsp_rsv_src3_vld_3,
	input	[`PRF_CODE_WIDTH - 1		: 0]		i_dsp_rsv_src3_prf_code_3,
	input 											i_dsp_rsv_dst_vld_3,
	input	[`PRF_CODE_WIDTH - 1		: 0]		i_dsp_rsv_dst_prf_code_3,
	input	[`RSV_IDX_WIDTH - 1			: 0]		i_dsp_rsv_free_entry_0,
	input	[`RSV_IDX_WIDTH - 1			: 0]		i_dsp_rsv_free_entry_1,
	input	[`RSV_IDX_WIDTH - 1			: 0]		i_dsp_rsv_free_entry_2,
	input	[`RSV_IDX_WIDTH - 1			: 0]		i_dsp_rsv_free_entry_3,	
	input	[`ROB_ID_WIDTH - 1			: 0]		i_dsp_rsv_rob_id_0,
	input											i_dsp_rsv_ld_vld_0,
	input	[`LBUFF_ID_WIDTH - 1		: 0]		i_dsp_rsv_ld_id_0,
	input											i_dsp_rsv_st_vld_0,
	input	[`SBUFF_ID_WIDTH - 1		: 0]		i_dsp_rsv_st_id_0,
	input	[`ROB_ID_WIDTH - 1			: 0]		i_dsp_rsv_rob_id_1,
	input											i_dsp_rsv_ld_vld_1,
	input	[`LBUFF_ID_WIDTH - 1		: 0]		i_dsp_rsv_ld_id_1,
	input											i_dsp_rsv_st_vld_1,
	input	[`SBUFF_ID_WIDTH - 1		: 0]		i_dsp_rsv_st_id_1,
	input	[`ROB_ID_WIDTH - 1			: 0]		i_dsp_rsv_rob_id_2,
	input											i_dsp_rsv_ld_vld_2,
	input	[`LBUFF_ID_WIDTH - 1		: 0]		i_dsp_rsv_ld_id_2,
	input											i_dsp_rsv_st_vld_2,
	input	[`SBUFF_ID_WIDTH - 1		: 0]		i_dsp_rsv_st_id_2,
	input	[`ROB_ID_WIDTH - 1			: 0]		i_dsp_rsv_rob_id_3,
	input											i_dsp_rsv_ld_vld_3,
	input	[`LBUFF_ID_WIDTH - 1		: 0]		i_dsp_rsv_ld_id_3,
	input											i_dsp_rsv_st_vld_3,
	input	[`SBUFF_ID_WIDTH - 1		: 0]		i_dsp_rsv_st_id_3,

	input											i_ren_prf_free_req_0,
	input											i_ren_prf_free_req_1,
	input											i_ren_prf_free_req_2,
	input											i_ren_prf_free_req_3,
	input	[`PRF_CODE_WIDTH - 1		: 0]		i_ren_prf_free_prf_code_0,
	input	[`PRF_CODE_WIDTH - 1 		: 0]		i_ren_prf_free_prf_code_1,
	input	[`PRF_CODE_WIDTH - 1		: 0]		i_ren_prf_free_prf_code_2,
	input	[`PRF_CODE_WIDTH - 1 		: 0]		i_ren_prf_free_prf_code_3,

	input 											i_exu_rsv_wb_vld_0,
	input 	[`PRF_CODE_WIDTH - 1		: 0]		i_exu_rsv_wb_prf_code_0,
	input 	[`PRF_DATA_WIDTH - 1		: 0]		i_exu_rsv_wb_dat_0,
	input 											i_exu_rsv_wb_vld_1,
	input 	[`PRF_CODE_WIDTH - 1		: 0]		i_exu_rsv_wb_prf_code_1,
	input 	[`PRF_DATA_WIDTH - 1		: 0]		i_exu_rsv_wb_dat_1,
	input 											i_exu_rsv_wb_vld_2,
	input 	[`PRF_CODE_WIDTH - 1		: 0]		i_exu_rsv_wb_prf_code_2,
	input 	[`PRF_DATA_WIDTH - 1		: 0]		i_exu_rsv_wb_dat_2,
	input 											i_exu_rsv_wb_vld_3,
	input 	[`PRF_CODE_WIDTH - 1		: 0]		i_exu_rsv_wb_prf_code_3,
	input 	[`PRF_DATA_WIDTH - 1		: 0]		i_exu_rsv_wb_dat_3,

	output											o_rsv_exu_issue_vld_0,
	output											o_rsv_exu_issue_vld_1,
	output											o_rsv_exu_issue_vld_2,
	output											o_rsv_exu_issue_vld_3,
	output											o_rsv_exu_src1_vld_0,
	output	[`PRF_DATA_WIDTH - 1		: 0]		o_rsv_exu_src1_dat_0,
	output											o_rsv_exu_src2_vld_0,
	output	[`PRF_DATA_WIDTH - 1		: 0]		o_rsv_exu_src2_dat_0,
	output											o_rsv_exu_src3_vld_0,
	output	[`PRF_DATA_WIDTH - 1		: 0]		o_rsv_exu_src3_dat_0,
	output											o_rsv_exu_dst_vld_0,
	output	[`PRF_CODE_WIDTH - 1		: 0]		o_rsv_exu_dst_prf_code_0,
	output	[`EXCEPTION_CODE_WIDTH - 1	: 0]		o_rsv_exu_excp_code_0,
	output	[`DECINFO_WIDTH - 1			: 0]		o_rsv_exu_decinfo_bus_0,
	output	[`IMM_WIDTH - 1				: 0]		o_rsv_exu_imm_0,
	output											o_rsv_exu_len_0,
	output	[`ROB_ID_WIDTH - 1			: 0]		o_rsv_exu_rob_id_0,
	output											o_rsv_exu_src1_vld_1,
	output	[`PRF_DATA_WIDTH - 1		: 0]		o_rsv_exu_src1_dat_1,
	output											o_rsv_exu_src2_vld_1,
	output	[`PRF_DATA_WIDTH - 1		: 0]		o_rsv_exu_src2_dat_1,
	output											o_rsv_exu_src3_vld_1,
	output	[`PRF_DATA_WIDTH - 1		: 0]		o_rsv_exu_src3_dat_1,
	output											o_rsv_exu_dst_vld_1,
	output	[`PRF_CODE_WIDTH - 1		: 0]		o_rsv_exu_dst_prf_code_1,
	output	[`EXCEPTION_CODE_WIDTH - 1	: 0]		o_rsv_exu_excp_code_1,
	output	[`PREDINFO_WIDTH - 1		: 0]		o_rsv_exu_predinfo_bus_1,
	output	[`DECINFO_WIDTH - 1			: 0]		o_rsv_exu_decinfo_bus_1,
	output	[`IMM_WIDTH - 1				: 0]		o_rsv_exu_imm_1,
	output											o_rsv_exu_len_1,
	output	[`ROB_ID_WIDTH - 1			: 0]		o_rsv_exu_rob_id_1,
	output											o_rsv_exu_src1_vld_2,
	output	[`PRF_DATA_WIDTH - 1		: 0]		o_rsv_exu_src1_dat_2,
	output											o_rsv_exu_src2_vld_2,
	output	[`PRF_DATA_WIDTH - 1		: 0]		o_rsv_exu_src2_dat_2,
	output											o_rsv_exu_src3_vld_2,
	output	[`PRF_DATA_WIDTH - 1		: 0]		o_rsv_exu_src3_dat_2,
	output											o_rsv_exu_dst_vld_2,
	output	[`PRF_CODE_WIDTH - 1		: 0]		o_rsv_exu_dst_prf_code_2,
	output	[`EXCEPTION_CODE_WIDTH - 1	: 0]		o_rsv_exu_excp_code_2,
	output	[`DECINFO_WIDTH - 1			: 0]		o_rsv_exu_decinfo_bus_2,
	output	[`IMM_WIDTH - 1				: 0]		o_rsv_exu_imm_2,
	output											o_rsv_exu_len_2,
	output	[`ROB_ID_WIDTH - 1			: 0]		o_rsv_exu_rob_id_2,
	output											o_rsv_exu_src1_vld_3,
	output	[`PRF_DATA_WIDTH - 1		: 0]		o_rsv_exu_src1_dat_3,
	output											o_rsv_exu_src2_vld_3,
	output	[`PRF_DATA_WIDTH - 1		: 0]		o_rsv_exu_src2_dat_3,
	output											o_rsv_exu_src3_vld_3,
	output	[`PRF_DATA_WIDTH - 1		: 0]		o_rsv_exu_src3_dat_3,
	output											o_rsv_exu_dst_vld_3,
	output	[`PRF_CODE_WIDTH - 1		: 0]		o_rsv_exu_dst_prf_code_3,
	output	[`EXCEPTION_CODE_WIDTH - 1	: 0]		o_rsv_exu_excp_code_3,
	output	[`DECINFO_WIDTH - 1			: 0]		o_rsv_exu_decinfo_bus_3,
	output	[`MEM_SIZE_WIDTH - 1		: 0]		o_rsv_exu_mem_size_3,
	output	[`IMM_WIDTH - 1				: 0]		o_rsv_exu_imm_3,
	output											o_rsv_exu_len_3,
	output	[`ROB_ID_WIDTH - 1			: 0]		o_rsv_exu_rob_id_3,
	output											o_rsv_exu_ld_vld_3,
	output	[`LBUFF_ID_WIDTH - 1		: 0]		o_rsv_exu_ld_id_3,
	output											o_rsv_exu_st_vld_3,
	output	[`SBUFF_ID_WIDTH - 1		: 0]		o_rsv_exu_st_id_3,

	input											clk,
	input											rst_n
);

assign {
	
}

//
wire rsv_inst_3_is_alu	  = ((i_dsp_rsv_decinfo_bus_3[`DECINFO_EXEC_UNIT] == `UOPINFO_ALU)
						  |  (i_dsp_rsv_decinfo_bus_3[`DECINFO_EXEC_UNIT] == `UOPINFO_CSR));
wire rsv_inst_3_is_bjp	  = (i_dsp_rsv_decinfo_bus_3[`DECINFO_EXEC_UNIT] == `UOPINFO_BJP);
wire rsv_inst_3_is_muldiv = (i_dsp_rsv_decinfo_bus_3[`DECINFO_EXEC_UNIT] == `UOPINFO_MULDIV);
wire rsv_inst_3_is_agu	  = ((i_dsp_rsv_decinfo_bus_3[`DECINFO_EXEC_UNIT] == `UOPINFO_AGU)
						  |  (i_dsp_rsv_decinfo_bus_3[`DECINFO_EXEC_UNIT] == `UOPINFO_AMO));

wire rsv_inst_2_is_alu	  = ((i_dsp_rsv_decinfo_bus_2[`DECINFO_EXEC_UNIT] == `UOPINFO_ALU)
						  |  (i_dsp_rsv_decinfo_bus_2[`DECINFO_EXEC_UNIT] == `UOPINFO_CSR));
wire rsv_inst_2_is_bjp	  = (i_dsp_rsv_decinfo_bus_2[`DECINFO_EXEC_UNIT] == `UOPINFO_BJP);
wire rsv_inst_2_is_muldiv = (i_dsp_rsv_decinfo_bus_2[`DECINFO_EXEC_UNIT] == `UOPINFO_MULDIV);
wire rsv_inst_2_is_agu	  = ((i_dsp_rsv_decinfo_bus_2[`DECINFO_EXEC_UNIT] == `UOPINFO_AGU)
						  |  (i_dsp_rsv_decinfo_bus_2[`DECINFO_EXEC_UNIT] == `UOPINFO_AMO));

wire rsv_inst_1_is_alu	  = ((i_dsp_rsv_decinfo_bus_1[`DECINFO_EXEC_UNIT] == `UOPINFO_ALU)
						  |  (i_dsp_rsv_decinfo_bus_1[`DECINFO_EXEC_UNIT] == `UOPINFO_CSR));
wire rsv_inst_1_is_bjp	  = (i_dsp_rsv_decinfo_bus_1[`DECINFO_EXEC_UNIT] == `UOPINFO_BJP);
wire rsv_inst_1_is_muldiv = (i_dsp_rsv_decinfo_bus_1[`DECINFO_EXEC_UNIT] == `UOPINFO_MULDIV);
wire rsv_inst_1_is_agu	  = ((i_dsp_rsv_decinfo_bus_1[`DECINFO_EXEC_UNIT] == `UOPINFO_AGU)
						  |  (i_dsp_rsv_decinfo_bus_1[`DECINFO_EXEC_UNIT] == `UOPINFO_AMO));

wire rsv_inst_0_is_alu	  = ((i_dsp_rsv_decinfo_bus_0[`DECINFO_EXEC_UNIT] == `UOPINFO_ALU)
						  |  (i_dsp_rsv_decinfo_bus_0[`DECINFO_EXEC_UNIT] == `UOPINFO_CSR));
wire rsv_inst_0_is_bjp	  = (i_dsp_rsv_decinfo_bus_0[`DECINFO_EXEC_UNIT] == `UOPINFO_BJP);
wire rsv_inst_0_is_muldiv = (i_dsp_rsv_decinfo_bus_0[`DECINFO_EXEC_UNIT] == `UOPINFO_MULDIV);
wire rsv_inst_0_is_agu	  = ((i_dsp_rsv_decinfo_bus_0[`DECINFO_EXEC_UNIT] == `UOPINFO_AGU)
						  |  (i_dsp_rsv_decinfo_bus_0[`DECINFO_EXEC_UNIT] == `UOPINFO_AMO));

//  ALU age mtrx
wire [3 : 0] i_dsp_rsv_alu_vld = {	
									(i_dsp_rsv_vld[3] & rsv_inst_3_is_alu)
								,	(i_dsp_rsv_vld[2] & rsv_inst_2_is_alu)
								,	(i_dsp_rsv_vld[1] & rsv_inst_1_is_alu)
								,	(i_dsp_rsv_vld[0] & rsv_inst_0_is_alu)
					    		};

wire [`RSV_ENTRY_NUMS - 1 : 0] o_oldest_rsv_vec_0;

rsv_age_mtrx_module rsv_alu_age_mtrx (
	.i_csr_trap_flush      (i_csr_trap_flush),
	.i_exu_mis_flush       (i_exu_mis_flush),
	.i_exu_ls_flush        (i_exu_ls_flush),
	.i_dsp_rsv_vld         (i_dsp_rsv_alu_vld),
	.i_dsp_rsv_free_entry_0(i_dsp_rsv_free_entry_0),
	.i_dsp_rsv_free_entry_1(i_dsp_rsv_free_entry_1),
	.i_dsp_rsv_free_entry_2(i_dsp_rsv_free_entry_2),
	.i_dsp_rsv_free_entry_3(i_dsp_rsv_free_entry_3),
	.i_rsv_entry_vld_vec   (o_rsv_entry_vld_vec_0),
	.o_oldest_rsv_vec      (o_oldest_rsv_vec_0),

	.clk                   (clk),
	.rst_n                 (rst_n)
);

//	BJP age mtrx
wire [3 : 0] i_dsp_rsv_bjp_vld = {
									(i_dsp_rsv_vld[3] & rsv_inst_3_is_bjp)
								,	(i_dsp_rsv_vld[2] & rsv_inst_2_is_bjp)
								,	(i_dsp_rsv_vld[1] & rsv_inst_1_is_bjp)
								,	(i_dsp_rsv_vld[0] & rsv_inst_0_is_bjp)
								};

wire [`RSV_ENTRY_NUMS - 1 : 0] o_oldest_rsv_vec_1;

rsv_age_mtrx_module rsv_bjp_age_mtrx (
	.i_csr_trap_flush      (i_csr_trap_flush),
	.i_exu_mis_flush       (i_exu_mis_flush),
	.i_exu_ls_flush        (i_exu_ls_flush),
	.i_dsp_rsv_vld         (i_dsp_rsv_bjp_vld),
	.i_dsp_rsv_free_entry_0(i_dsp_rsv_free_entry_0),
	.i_dsp_rsv_free_entry_1(i_dsp_rsv_free_entry_1),
	.i_dsp_rsv_free_entry_2(i_dsp_rsv_free_entry_2),
	.i_dsp_rsv_free_entry_3(i_dsp_rsv_free_entry_3),
	.i_rsv_entry_vld_vec   (o_rsv_entry_vld_vec_1),
	.o_oldest_rsv_vec      (o_oldest_rsv_vec_1),

	.clk                   (clk),
	.rst_n                 (rst_n)
);

//	MULDIV age mtrx
wire [3 : 0] i_dsp_rsv_muldiv_vld = {
										(i_dsp_rsv_vld[3] & rsv_inst_3_is_muldiv)
									,	(i_dsp_rsv_vld[2] & rsv_inst_2_is_muldiv)
									,	(i_dsp_rsv_vld[1] & rsv_inst_1_is_muldiv)
									,	(i_dsp_rsv_vld[0] & rsv_inst_0_is_muldiv)
									};

wire [`RSV_ENTRY_NUMS - 1 : 0] o_oldest_rsv_vec_2;

rsv_age_mtrx_module rsv_muldiv_age_mtrx (
	.i_csr_trap_flush      (i_csr_trap_flush),
	.i_exu_mis_flush       (i_exu_mis_flush),
	.i_exu_ls_flush        (i_exu_ls_flush),
	.i_dsp_rsv_vld         (i_dsp_rsv_muldiv_vld),
	.i_dsp_rsv_free_entry_0(i_dsp_rsv_free_entry_0),
	.i_dsp_rsv_free_entry_1(i_dsp_rsv_free_entry_1),
	.i_dsp_rsv_free_entry_2(i_dsp_rsv_free_entry_2),
	.i_dsp_rsv_free_entry_3(i_dsp_rsv_free_entry_3),
	.i_rsv_entry_vld_vec   (o_rsv_entry_vld_vec_2),
	.o_oldest_rsv_vec      (o_oldest_rsv_vec_2),

	.clk                   (clk),
	.rst_n                 (rst_n)
);

//	AGU age mtrx
wire [3 : 0] i_dsp_rsv_agu_vld = {
									(i_dsp_rsv_vld[3] & rsv_inst_3_is_agu)
								,	(i_dsp_rsv_vld[2] & rsv_inst_2_is_agu)
								,	(i_dsp_rsv_vld[1] & rsv_inst_1_is_agu)
								,	(i_dsp_rsv_vld[0] & rsv_inst_0_is_agu)
								};

wire [`RSV_ENTRY_NUMS - 1 : 0] o_oldest_rsv_vec_3;

rsv_age_mtrx_module rsv_agu_age_mtrx (
	.i_csr_trap_flush      (i_csr_trap_flush),
	.i_exu_mis_flush       (i_exu_mis_flush),
	.i_exu_ls_flush        (i_exu_ls_flush),
	.i_dsp_rsv_vld         (i_dsp_rsv_agu_vld),
	.i_dsp_rsv_free_entry_0(i_dsp_rsv_free_entry_0),
	.i_dsp_rsv_free_entry_1(i_dsp_rsv_free_entry_1),
	.i_dsp_rsv_free_entry_2(i_dsp_rsv_free_entry_2),
	.i_dsp_rsv_free_entry_3(i_dsp_rsv_free_entry_3),
	.i_rsv_entry_vld_vec   (o_rsv_entry_vld_vec_3),
	.o_oldest_rsv_vec      (o_oldest_rsv_vec_3),

	.clk                   (clk),
	.rst_n                 (rst_n)
);

//	rsv_src1
wire o_rsv_src1_vld_0;
wire [`PRF_CODE_WIDTH - 1 : 0] o_rsv_src1_prf_code_0;
wire o_rsv_src1_vld_1;
wire [`PRF_CODE_WIDTH - 1 : 0] o_rsv_src1_prf_code_1;
wire o_rsv_src1_vld_2;
wire [`PRF_CODE_WIDTH - 1 : 0] o_rsv_src1_prf_code_2;
wire o_rsv_src1_vld_3;
wire [`PRF_CODE_WIDTH - 1 : 0] o_rsv_src1_prf_code_3;
wire [`RSV_ENTRY_NUMS - 1 : 0] o_rsv_src1_rdy;

rsv_src_module rsv_src1 (
	.i_csr_trap_flush       (i_csr_trap_flush),
	.i_exu_mis_flush        (i_exu_mis_flush),
	.i_exu_ls_flush         (i_exu_ls_flush),

	.i_dsp_rsv_vld          (i_dsp_rsv_vld),
	.i_dsp_rsv_free_entry_0 (i_dsp_rsv_free_entry_0),
	.i_dsp_rsv_free_entry_1 (i_dsp_rsv_free_entry_1),
	.i_dsp_rsv_free_entry_2 (i_dsp_rsv_free_entry_2),
	.i_dsp_rsv_free_entry_3 (i_dsp_rsv_free_entry_3),
	.i_dsp_rsv_src_vld_0    (i_dsp_rsv_src1_vld_0),
	.i_dsp_rsv_prf_code_0   (i_dsp_rsv_src1_prf_code_0),
	.i_dsp_rsv_src_vld_1    (i_dsp_rsv_src1_vld_1),
	.i_dsp_rsv_prf_code_1   (i_dsp_rsv_src1_prf_code_1),
	.i_dsp_rsv_src_vld_2    (i_dsp_rsv_src1_vld_2),
	.i_dsp_rsv_prf_code_2   (i_dsp_rsv_src1_prf_code_2),
	.i_dsp_rsv_src_vld_3    (i_dsp_rsv_src1_vld_3),
	.i_dsp_rsv_prf_code_3   (i_dsp_rsv_src1_prf_code_3),
	.i_oldest_rsv_vec_0     (o_oldest_rsv_vec_0),
	.i_oldest_rsv_vec_1     (o_oldest_rsv_vec_1),
	.i_oldest_rsv_vec_2     (o_oldest_rsv_vec_2),
	.i_oldest_rsv_vec_3     (o_oldest_rsv_vec_3),
	.i_rsv_arb_stall_0	    (o_rsv_arb_stall_0),
	.i_rsv_arb_stall_1 	    (o_rsv_arb_stall_1),
	.i_rsv_arb_stall_2 	    (o_rsv_arb_stall_2),
	.i_rsv_arb_stall_3      (o_rsv_arb_stall_3),
	.i_exu_rsv_wb_vld_0     (i_exu_rsv_wb_vld_0),
	.i_exu_rsv_wb_prf_code_0(i_exu_rsv_wb_prf_code_0),
	.i_exu_rsv_wb_vld_1     (i_exu_rsv_wb_vld_1),
	.i_exu_rsv_wb_prf_code_1(i_exu_rsv_wb_prf_code_1),
	.i_exu_rsv_wb_vld_2     (i_exu_rsv_wb_vld_2),
	.i_exu_rsv_wb_prf_code_2(i_exu_rsv_wb_prf_code_2),
	.i_exu_rsv_wb_vld_3     (i_exu_rsv_wb_vld_3),
	.i_exu_rsv_wb_prf_code_3(i_exu_rsv_wb_prf_code_3),

	.o_rsv_src_vld_0        (o_rsv_src1_vld_0),
	.o_rsv_src_prf_code_0   (o_rsv_src1_prf_code_0),
	.o_rsv_src_vld_1        (o_rsv_src1_vld_1),
	.o_rsv_src_prf_code_1   (o_rsv_src1_prf_code_1),
	.o_rsv_src_vld_2        (o_rsv_src1_vld_2),
	.o_rsv_src_prf_code_2   (o_rsv_src1_prf_code_2),
	.o_rsv_src_vld_3        (o_rsv_src1_vld_3),
	.o_rsv_src_prf_code_3   (o_rsv_src1_prf_code_3),
	.o_rsv_src_rdy          (o_rsv_src1_rdy),

	.clk                    (clk),
	.rst_n                  (rst_n)
);

//	rsv_src2
wire o_rsv_src2_vld_0;
wire [`PRF_CODE_WIDTH - 1 : 0] o_rsv_src2_prf_code_0;
wire o_rsv_src2_vld_1;
wire [`PRF_CODE_WIDTH - 1 : 0] o_rsv_src2_prf_code_1;
wire o_rsv_src2_vld_2;
wire [`PRF_CODE_WIDTH - 1 : 0] o_rsv_src2_prf_code_2;
wire o_rsv_src2_vld_3;
wire [`PRF_CODE_WIDTH - 1 : 0] o_rsv_src2_prf_code_3;
wire [`RSV_ENTRY_NUMS - 1 : 0] o_rsv_src2_rdy;

rsv_src_module rsv_src2 (
	.i_csr_trap_flush       (i_csr_trap_flush),
	.i_exu_mis_flush        (i_exu_mis_flush),
	.i_exu_ls_flush         (i_exu_ls_flush),

	.i_dsp_rsv_vld          (i_dsp_rsv_vld),
	.i_dsp_rsv_free_entry_0 (i_dsp_rsv_free_entry_0),
	.i_dsp_rsv_free_entry_1 (i_dsp_rsv_free_entry_1),
	.i_dsp_rsv_free_entry_2 (i_dsp_rsv_free_entry_2),
	.i_dsp_rsv_free_entry_3 (i_dsp_rsv_free_entry_3),
	.i_dsp_rsv_src_vld_0    (i_dsp_rsv_src2_vld_0),
	.i_dsp_rsv_prf_code_0   (i_dsp_rsv_src2_prf_code_0),
	.i_dsp_rsv_src_vld_1    (i_dsp_rsv_src2_vld_1),
	.i_dsp_rsv_prf_code_1   (i_dsp_rsv_src2_prf_code_1),
	.i_dsp_rsv_src_vld_2    (i_dsp_rsv_src2_vld_2),
	.i_dsp_rsv_prf_code_2   (i_dsp_rsv_src2_prf_code_2),
	.i_dsp_rsv_src_vld_3    (i_dsp_rsv_src2_vld_3),
	.i_dsp_rsv_prf_code_3   (i_dsp_rsv_src2_prf_code_3),
	.i_oldest_rsv_vec_0     (o_oldest_rsv_vec_0),
	.i_oldest_rsv_vec_1     (o_oldest_rsv_vec_1),
	.i_oldest_rsv_vec_2     (o_oldest_rsv_vec_2),
	.i_oldest_rsv_vec_3     (o_oldest_rsv_vec_3),
	.i_rsv_arb_stall_0	    (o_rsv_arb_stall_0),
	.i_rsv_arb_stall_1 	    (o_rsv_arb_stall_1),
	.i_rsv_arb_stall_2 	    (o_rsv_arb_stall_2),
	.i_rsv_arb_stall_3      (o_rsv_arb_stall_3),
	.i_exu_rsv_wb_vld_0     (i_exu_rsv_wb_vld_0),
	.i_exu_rsv_wb_prf_code_0(i_exu_rsv_wb_prf_code_0),
	.i_exu_rsv_wb_vld_1     (i_exu_rsv_wb_vld_1),
	.i_exu_rsv_wb_prf_code_1(i_exu_rsv_wb_prf_code_1),
	.i_exu_rsv_wb_vld_2     (i_exu_rsv_wb_vld_2),
	.i_exu_rsv_wb_prf_code_2(i_exu_rsv_wb_prf_code_2),
	.i_exu_rsv_wb_vld_3     (i_exu_rsv_wb_vld_3),
	.i_exu_rsv_wb_prf_code_3(i_exu_rsv_wb_prf_code_3),

	.o_rsv_src_vld_0        (o_rsv_src2_vld_0),
	.o_rsv_src_prf_code_0   (o_rsv_src2_prf_code_0),
	.o_rsv_src_vld_1        (o_rsv_src2_vld_1),
	.o_rsv_src_prf_code_1   (o_rsv_src2_prf_code_1),
	.o_rsv_src_vld_2        (o_rsv_src2_vld_2),
	.o_rsv_src_prf_code_2   (o_rsv_src2_prf_code_2),
	.o_rsv_src_vld_3        (o_rsv_src2_vld_3),
	.o_rsv_src_prf_code_3   (o_rsv_src2_prf_code_3),
	.o_rsv_src_rdy          (o_rsv_src2_rdy),

	.clk                    (clk),
	.rst_n                  (rst_n)
);

//	rsv_src3
wire o_rsv_src3_vld_0;
wire [`PRF_CODE_WIDTH - 1 : 0] o_rsv_src3_prf_code_0;
wire o_rsv_src3_vld_1;
wire [`PRF_CODE_WIDTH - 1 : 0] o_rsv_src3_prf_code_1;
wire o_rsv_src3_vld_2;
wire [`PRF_CODE_WIDTH - 1 : 0] o_rsv_src3_prf_code_2;
wire o_rsv_src3_vld_3;
wire [`PRF_CODE_WIDTH - 1 : 0] o_rsv_src3_prf_code_3;
wire [`RSV_ENTRY_NUMS - 1 : 0] o_rsv_src3_rdy;

rsv_src_module rsv_src3 (
	.i_csr_trap_flush       (i_csr_trap_flush),
	.i_exu_mis_flush        (i_exu_mis_flush),
	.i_exu_ls_flush         (i_exu_ls_flush),

	.i_dsp_rsv_vld          (i_dsp_rsv_vld),
	.i_dsp_rsv_free_entry_0 (i_dsp_rsv_free_entry_0),
	.i_dsp_rsv_free_entry_1 (i_dsp_rsv_free_entry_1),
	.i_dsp_rsv_free_entry_2 (i_dsp_rsv_free_entry_2),
	.i_dsp_rsv_free_entry_3 (i_dsp_rsv_free_entry_3),
	.i_dsp_rsv_src_vld_0    (i_dsp_rsv_src3_vld_0),
	.i_dsp_rsv_prf_code_0   (i_dsp_rsv_src3_prf_code_0),
	.i_dsp_rsv_src_vld_1    (i_dsp_rsv_src3_vld_1),
	.i_dsp_rsv_prf_code_1   (i_dsp_rsv_src3_prf_code_1),
	.i_dsp_rsv_src_vld_2    (i_dsp_rsv_src3_vld_2),
	.i_dsp_rsv_prf_code_2   (i_dsp_rsv_src3_prf_code_2),
	.i_dsp_rsv_src_vld_3    (i_dsp_rsv_src3_vld_3),
	.i_dsp_rsv_prf_code_3   (i_dsp_rsv_src3_prf_code_3),
	.i_oldest_rsv_vec_0     (o_oldest_rsv_vec_0),
	.i_oldest_rsv_vec_1     (o_oldest_rsv_vec_1),
	.i_oldest_rsv_vec_2     (o_oldest_rsv_vec_2),
	.i_oldest_rsv_vec_3     (o_oldest_rsv_vec_3),
	.i_rsv_arb_stall_0	    (o_rsv_arb_stall_0),
	.i_rsv_arb_stall_1 	    (o_rsv_arb_stall_1),
	.i_rsv_arb_stall_2 	    (o_rsv_arb_stall_2),
	.i_rsv_arb_stall_3      (o_rsv_arb_stall_3),
	.i_exu_rsv_wb_vld_0     (i_exu_rsv_wb_vld_0),
	.i_exu_rsv_wb_prf_code_0(i_exu_rsv_wb_prf_code_0),
	.i_exu_rsv_wb_vld_1     (i_exu_rsv_wb_vld_1),
	.i_exu_rsv_wb_prf_code_1(i_exu_rsv_wb_prf_code_1),
	.i_exu_rsv_wb_vld_2     (i_exu_rsv_wb_vld_2),
	.i_exu_rsv_wb_prf_code_2(i_exu_rsv_wb_prf_code_2),
	.i_exu_rsv_wb_vld_3     (i_exu_rsv_wb_vld_3),
	.i_exu_rsv_wb_prf_code_3(i_exu_rsv_wb_prf_code_3),

	.o_rsv_src_vld_0        (o_rsv_src3_vld_0),
	.o_rsv_src_prf_code_0   (o_rsv_src3_prf_code_0),
	.o_rsv_src_vld_1        (o_rsv_src3_vld_1),
	.o_rsv_src_prf_code_1   (o_rsv_src3_prf_code_1),
	.o_rsv_src_vld_2        (o_rsv_src3_vld_2),
	.o_rsv_src_prf_code_2   (o_rsv_src3_prf_code_2),
	.o_rsv_src_vld_3        (o_rsv_src3_vld_3),
	.o_rsv_src_prf_code_3   (o_rsv_src3_prf_code_3),
	.o_rsv_src_rdy          (o_rsv_src3_rdy),

	.clk                    (clk),
	.rst_n                  (rst_n)
);

//	rsv_data
wire [3 : 0] o_rsv_exu_len;
rsv_data_module rsv_data (
	.i_csr_trap_flush         (i_csr_trap_flush),
	.i_exu_mis_flush          (i_exu_mis_flush),
	.i_exu_ls_flush           (i_exu_ls_flush),

	.i_dsp_rsv_vld            (i_dsp_rsv_vld),
	.i_dsp_rsv_free_entry_0   (i_dsp_rsv_free_entry_0),
	.i_dsp_rsv_free_entry_1   (i_dsp_rsv_free_entry_1),
	.i_dsp_rsv_free_entry_2   (i_dsp_rsv_free_entry_2),
	.i_dsp_rsv_free_entry_3   (i_dsp_rsv_free_entry_3),
	.i_dsp_rsv_rob_id_0       (i_dsp_rsv_rob_id_0),
	.i_dsp_rsv_ld_vld_0       (i_dsp_rsv_ld_vld_0),
	.i_dsp_rsv_ld_id_0        (i_dsp_rsv_ld_id_0),
	.i_dsp_rsv_st_vld_0       (i_dsp_rsv_st_vld_0),
	.i_dsp_rsv_st_id_0        (i_dsp_rsv_st_id_0),
	.i_dsp_rsv_dst_vld_0 	  (i_dsp_rsv_dst_vld_0),
	.i_dsp_rsv_dst_arf_code_0 (i_dsp_rsv_dst_arf_code_0),
	.i_dsp_rsv_dst_prf_code_0 (i_dsp_rsv_dst_prf_code_0),
	.i_dsp_rsv_dst_pprf_code_0(i_dsp_rsv_dst_pprf_code_0),
	.i_dsp_rsv_decinfo_bus_0  (i_dsp_rsv_decinfo_bus_0),
	.i_dsp_rsv_predinfo_bus_0 (i_dsp_rsv_predinfo_bus_0),
	.i_dsp_rsv_imm_0          (i_dsp_rsv_imm_0),
	.i_dsp_rsv_rob_id_1       (i_dsp_rsv_rob_id_1),
	.i_dsp_rsv_ld_vld_1       (i_dsp_rsv_ld_vld_1),
	.i_dsp_rsv_ld_id_1        (i_dsp_rsv_ld_id_1),
	.i_dsp_rsv_st_vld_1       (i_dsp_rsv_st_vld_1),
	.i_dsp_rsv_st_id_1        (i_dsp_rsv_st_id_1),
	.i_dsp_rsv_dst_vld_1 	  (i_dsp_rsv_dst_vld_1),
	.i_dsp_rsv_dst_arf_code_1 (i_dsp_rsv_dst_arf_code_1),
	.i_dsp_rsv_dst_prf_code_1 (i_dsp_rsv_dst_prf_code_1),
	.i_dsp_rsv_dst_pprf_code_1(i_dsp_rsv_dst_pprf_code_1),
	.i_dsp_rsv_decinfo_bus_1  (i_dsp_rsv_decinfo_bus_1),
	.i_dsp_rsv_predinfo_bus_1 (i_dsp_rsv_predinfo_bus_1),
	.i_dsp_rsv_imm_1          (i_dsp_rsv_imm_1),
	.i_dsp_rsv_rob_id_2       (i_dsp_rsv_rob_id_2),
	.i_dsp_rsv_ld_vld_2       (i_dsp_rsv_ld_vld_2),
	.i_dsp_rsv_ld_id_2        (i_dsp_rsv_ld_id_2),
	.i_dsp_rsv_st_vld_2       (i_dsp_rsv_st_vld_2),
	.i_dsp_rsv_st_id_2        (i_dsp_rsv_st_id_2),
	.i_dsp_rsv_dst_vld_2 	  (i_dsp_rsv_dst_vld_2),
	.i_dsp_rsv_dst_arf_code_2 (i_dsp_rsv_dst_arf_code_2),
	.i_dsp_rsv_dst_prf_code_2 (i_dsp_rsv_dst_prf_code_2),
	.i_dsp_rsv_dst_pprf_code_2(i_dsp_rsv_dst_pprf_code_2),
	.i_dsp_rsv_decinfo_bus_2  (i_dsp_rsv_decinfo_bus_2),
	.i_dsp_rsv_predinfo_bus_2 (i_dsp_rsv_predinfo_bus_2),
	.i_dsp_rsv_imm_2          (i_dsp_rsv_imm_2),
	.i_dsp_rsv_rob_id_3       (i_dsp_rsv_rob_id_3),
	.i_dsp_rsv_ld_vld_3       (i_dsp_rsv_ld_vld_3),
	.i_dsp_rsv_ld_id_3        (i_dsp_rsv_ld_id_3),
	.i_dsp_rsv_st_vld_3       (i_dsp_rsv_st_vld_3),
	.i_dsp_rsv_st_id_3        (i_dsp_rsv_st_id_3),
	.i_dsp_rsv_dst_vld_3 	  (i_dsp_rsv_dst_vld_3),
	.i_dsp_rsv_dst_arf_code_3 (i_dsp_rsv_dst_arf_code_3),
	.i_dsp_rsv_dst_prf_code_3 (i_dsp_rsv_dst_prf_code_3),
	.i_dsp_rsv_dst_pprf_code_3(i_dsp_rsv_dst_pprf_code_3),
	.i_dsp_rsv_decinfo_bus_3  (i_dsp_rsv_decinfo_bus_3),
	.i_dsp_rsv_predinfo_bus_3 (i_dsp_rsv_predinfo_bus_3),
	.i_dsp_rsv_imm_3          (i_dsp_rsv_imm_3),
	.i_dsp_rsv_len            (i_dsp_rsv_len),
	.i_oldest_rsv_vec_0       (o_oldest_rsv_vec_0),
	.i_oldest_rsv_vec_1       (o_oldest_rsv_vec_1),
	.i_oldest_rsv_vec_2       (o_oldest_rsv_vec_2),
	.i_oldest_rsv_vec_3       (o_oldest_rsv_vec_3),
	.i_dsp_rsv_excp_code_0    (i_dsp_rsv_excp_code_0),
	.i_dsp_rsv_excp_code_1    (i_dsp_rsv_excp_code_1),
	.i_dsp_rsv_excp_code_2    (i_dsp_rsv_excp_code_2),
	.i_dsp_rsv_excp_code_3    (i_dsp_rsv_excp_code_3),
	.o_rsv_rob_id_0           (o_rsv_exu_rob_id_0),
	.o_rsv_excp_code_0        (o_rsv_exu_excp_code_0),
	.o_rsv_decinfo_bus_0      (o_rsv_exu_decinfo_bus_0),
	.o_rsv_imm_0              (o_rsv_exu_imm_0),
	.o_rsv_dst_vld_0          (o_rsv_exu_dst_vld_0),
	.o_rsv_prf_code_0         (o_rsv_exu_dst_prf_code_0),
	.o_rsv_rob_id_1           (o_rsv_exu_rob_id_1),
	.o_rsv_excp_code_1        (o_rsv_exu_excp_code_1),
	.o_rsv_decinfo_bus_1      (o_rsv_exu_decinfo_bus_1),
	.o_rsv_predinfo_bus_1     (o_rsv_exu_predinfo_bus_1),
	.o_rsv_imm_1              (o_rsv_exu_imm_1),
	.o_rsv_dst_vld_1          (o_rsv_exu_dst_vld_1),
	.o_rsv_prf_code_1         (o_rsv_exu_dst_prf_code_1),
	.o_rsv_rob_id_2           (o_rsv_exu_rob_id_2),
	.o_rsv_excp_code_2        (o_rsv_exu_excp_code_2),
	.o_rsv_decinfo_bus_2      (o_rsv_exu_decinfo_bus_2),
	.o_rsv_imm_2              (o_rsv_exu_imm_2),
	.o_rsv_dst_vld_2          (o_rsv_exu_dst_vld_2),
	.o_rsv_prf_code_2         (o_rsv_exu_dst_prf_code_2),
	.o_rsv_rob_id_3           (o_rsv_exu_rob_id_3),
	.o_rsv_ld_vld_3           (o_rsv_exu_ld_vld_3),
	.o_rsv_ld_id_3            (o_rsv_exu_ld_id_3),
	.o_rsv_st_vld_3           (o_rsv_exu_st_vld_3),
	.o_rsv_st_id_3            (o_rsv_exu_st_id_3),
	.o_rsv_excp_code_3        (o_rsv_exu_excp_code_3),
	.o_rsv_decinfo_bus_3      (o_rsv_exu_decinfo_bus_3),
	.o_rsv_imm_3              (o_rsv_exu_imm_3),
	.o_rsv_dst_vld_3          (o_rsv_exu_dst_vld_3),
	.o_rsv_prf_code_3         (o_rsv_exu_dst_prf_code_3),
	.o_rsv_len                (o_rsv_exu_len),

	.clk                      (clk),
	.rst_n                    (rst_n)
);

assign {
		o_rsv_exu_len_3
	,	o_rsv_exu_len_2
	,	o_rsv_exu_len_1
	,	o_rsv_exu_len_0
} = o_rsv_exu_len;

//	rsv_ctrl
wire o_rsv_issue_vld_0;
wire [`RSV_ENTRY_NUMS - 1 : 0] o_rsv_entry_vld_vec_0;
wire o_rsv_issue_vld_1;
wire [`RSV_ENTRY_NUMS - 1 : 0] o_rsv_entry_vld_vec_1;
wire o_rsv_issue_vld_2;
wire [`RSV_ENTRY_NUMS - 1 : 0] o_rsv_entry_vld_vec_2;
wire o_rsv_issue_vld_3;
wire [`RSV_ENTRY_NUMS - 1 : 0] o_rsv_entry_vld_vec_3;


rsv_ctrl_module rsv_ctrl (
	.i_csr_trap_flush      (i_csr_trap_flush),
	.i_exu_mis_flush       (i_exu_mis_flush),
	.i_exu_mis_rob_id      (i_exu_mis_rob_id),
	.i_exu_ls_flush        (i_exu_ls_flush),
	.i_exu_ls_rob_id       (i_exu_ls_rob_id),

	.i_dsp_rsv_vld         (i_dsp_rsv_vld), 
	.i_dsp_rsv_free_entry_0(i_dsp_rsv_free_entry_0),
	.i_dsp_rsv_free_entry_1(i_dsp_rsv_free_entry_1),
	.i_dsp_rsv_free_entry_2(i_dsp_rsv_free_entry_2),
	.i_dsp_rsv_free_entry_3(i_dsp_rsv_free_entry_3),
	.i_dsp_rsv_rob_id_0    (i_dsp_rsv_rob_id_0),
	.i_dsp_rsv_rob_id_1    (i_dsp_rsv_rob_id_1),
	.i_dsp_rsv_rob_id_2    (i_dsp_rsv_rob_id_2),
	.i_dsp_rsv_rob_id_3    (i_dsp_rsv_rob_id_3),
	.i_dsp_rsv_exec_unit_0 (i_dsp_rsv_decinfo_bus_0[`DECINFO_EXEC_UNIT]),
	.i_dsp_rsv_exec_unit_1 (i_dsp_rsv_decinfo_bus_1[`DECINFO_EXEC_UNIT]),
	.i_dsp_rsv_exec_unit_2 (i_dsp_rsv_decinfo_bus_2[`DECINFO_EXEC_UNIT]), 
	.i_dsp_rsv_exec_unit_3 (i_dsp_rsv_decinfo_bus_3[`DECINFO_EXEC_UNIT]),
	.i_oldest_rsv_vec_0    (o_oldest_rsv_vec_0),
	.i_oldest_rsv_vec_1    (o_oldest_rsv_vec_1),
	.i_oldest_rsv_vec_2    (o_oldest_rsv_vec_2),
	.i_oldest_rsv_vec_3    (o_oldest_rsv_vec_3),
	.i_rsv_arb_stall_0	   (o_rsv_arb_stall_0),
	.i_rsv_arb_stall_1 	   (o_rsv_arb_stall_1),
	.i_rsv_arb_stall_2 	   (o_rsv_arb_stall_2),
	.i_rsv_arb_stall_3     (o_rsv_arb_stall_3),
	.i_rsv_src1_rdy_vec    (o_rsv_src1_rdy), 
	.i_rsv_src2_rdy_vec    (o_rsv_src2_rdy),
	.i_rsv_src3_rdy_vec    (o_rsv_src3_rdy),
	.o_rsv_issue_vld_0     (o_rsv_issue_vld_0),
	.o_rsv_entry_vld_vec_0 (o_rsv_entry_vld_vec_0), 
	.o_rsv_issue_vld_1     (o_rsv_issue_vld_1),
	.o_rsv_entry_vld_vec_1 (o_rsv_entry_vld_vec_1),
	.o_rsv_issue_vld_2     (o_rsv_issue_vld_2),
	.o_rsv_entry_vld_vec_2 (o_rsv_entry_vld_vec_2),
	.o_rsv_issue_vld_3     (o_rsv_issue_vld_3),
	.o_rsv_entry_vld_vec_3 (o_rsv_entry_vld_vec_3),
	.o_rsv_dsp_free_vld_0  (o_rsv_dsp_free_vld_0),
	.o_rsv_dsp_free_entry_0(o_rsv_dsp_free_entry_0),
	.o_rsv_dsp_free_vld_1  (o_rsv_dsp_free_vld_1),
	.o_rsv_dsp_free_entry_1(o_rsv_dsp_free_entry_1),
	.o_rsv_dsp_free_vld_2  (o_rsv_dsp_free_vld_2),
	.o_rsv_dsp_free_entry_2(o_rsv_dsp_free_entry_2),
	.o_rsv_dsp_free_vld_3  (o_rsv_dsp_free_vld_3),
	.o_rsv_dsp_free_entry_3(o_rsv_dsp_free_entry_3),

	.clk                   (clk),
	.rst_n                 (rst_n)
);

//
wire [`PRF_CODE_WIDTH - 1 : 0] o_prf_rsv_rd_code_0;
wire [`PRF_CODE_WIDTH - 1 : 0] o_prf_rsv_rd_code_1;
wire [`PRF_CODE_WIDTH - 1 : 0] o_prf_rsv_rd_code_2;
wire [`PRF_CODE_WIDTH - 1 : 0] o_prf_rsv_rd_code_3;
wire [`PRF_CODE_WIDTH - 1 : 0] o_prf_rsv_rd_code_4;
wire [`PRF_CODE_WIDTH - 1 : 0] o_prf_rsv_rd_code_5;
wire [`PRF_CODE_WIDTH - 1 : 0] o_prf_rsv_rd_code_6;
wire [`PRF_CODE_WIDTH - 1 : 0] o_prf_rsv_rd_code_7;


wire [`PRF_DATA_WIDTH - 1 : 0] o_prf_rsv_rdat_0;
wire [`PRF_DATA_WIDTH - 1 : 0] o_prf_rsv_rdat_1;
wire [`PRF_DATA_WIDTH - 1 : 0] o_prf_rsv_rdat_2;
wire [`PRF_DATA_WIDTH - 1 : 0] o_prf_rsv_rdat_3;
wire [`PRF_DATA_WIDTH - 1 : 0] o_prf_rsv_rdat_4;
wire [`PRF_DATA_WIDTH - 1 : 0] o_prf_rsv_rdat_5;
wire [`PRF_DATA_WIDTH - 1 : 0] o_prf_rsv_rdat_6;
wire [`PRF_DATA_WIDTH - 1 : 0] o_prf_rsv_rdat_7;

wire o_rsv_arb_stall_0;
wire o_rsv_arb_stall_1;
wire o_rsv_arb_stall_2;
wire o_rsv_arb_stall_3;

wire [3 : 0] o_rsv_exu_issue_vld;

rsv_issue_module rsv_issue (
	.i_rsv_issue_vld_0        (o_rsv_issue_vld_0),
	.i_rsv_issue_vld_1        (o_rsv_issue_vld_1),
	.i_rsv_issue_vld_2        (o_rsv_issue_vld_2),
	.i_rsv_issue_vld_3        (o_rsv_issue_vld_3),
	.i_rsv_src1_vld_0         (o_rsv_src1_vld_0),
	.i_rsv_src1_prf_code_0    (o_rsv_src1_prf_code_0),
	.i_rsv_src2_vld_0         (o_rsv_src2_vld_0),
	.i_rsv_src2_prf_code_0    (o_rsv_src2_prf_code_0),
	.i_rsv_src3_vld_0         (o_rsv_src3_vld_0),
	.i_rsv_src3_prf_code_0    (o_rsv_src3_prf_code_0),
	.i_rsv_src1_vld_1         (o_rsv_src1_vld_1),
	.i_rsv_src1_prf_code_1    (o_rsv_src1_prf_code_1),
	.i_rsv_src2_vld_1         (o_rsv_src2_vld_1),
	.i_rsv_src2_prf_code_1    (o_rsv_src2_prf_code_1),
	.i_rsv_src3_vld_1         (o_rsv_src3_vld_1),
	.i_rsv_src3_prf_code_1    (o_rsv_src3_prf_code_1),
	.i_rsv_src1_vld_2         (o_rsv_src1_vld_2),
	.i_rsv_src1_prf_code_2    (o_rsv_src1_prf_code_2),
	.i_rsv_src2_vld_2         (o_rsv_src2_vld_2),
	.i_rsv_src2_prf_code_2    (o_rsv_src2_prf_code_2),
	.i_rsv_src3_vld_2         (o_rsv_src3_vld_2),
	.i_rsv_src3_prf_code_2    (o_rsv_src3_prf_code_2),
	.i_rsv_src1_vld_3         (o_rsv_src1_vld_3),
	.i_rsv_src1_prf_code_3    (o_rsv_src1_prf_code_3),
	.i_rsv_src2_vld_3         (o_rsv_src2_vld_3),
	.i_rsv_src2_prf_code_3    (o_rsv_src2_prf_code_3),
	.i_rsv_src3_vld_3         (o_rsv_src3_vld_3),
	.i_rsv_src3_prf_code_3    (o_rsv_src3_prf_code_3),
	.i_prf_rsv_rdat_0         (o_prf_rsv_rdat_0),
	.i_prf_rsv_rdat_1         (o_prf_rsv_rdat_1),
	.i_prf_rsv_rdat_2         (o_prf_rsv_rdat_2),
	.i_prf_rsv_rdat_3         (o_prf_rsv_rdat_3),
	.i_prf_rsv_rdat_4         (o_prf_rsv_rdat_4),
	.i_prf_rsv_rdat_5         (o_prf_rsv_rdat_5),
	.i_prf_rsv_rdat_6         (o_prf_rsv_rdat_6),
	.i_prf_rsv_rdat_7         (o_prf_rsv_rdat_7),
	.i_prf_rsv_available      (o_prf_rsv_available),
	.o_rsv_exu_issue_vld      (o_rsv_exu_issue_vld),
	.o_rsv_exu_src1_vld_0     (o_rsv_exu_src1_vld_0),
	.o_rsv_exu_src1_prf_data_0(o_rsv_exu_src1_dat_0),
	.o_rsv_exu_src2_vld_0     (o_rsv_exu_src2_vld_0),
	.o_rsv_exu_src2_prf_data_0(o_rsv_exu_src2_dat_0),
	.o_rsv_exu_src3_vld_0     (o_rsv_exu_src3_vld_0),
	.o_rsv_exu_src3_prf_data_0(o_rsv_exu_src3_dat_0),
	.o_rsv_exu_src1_vld_1     (o_rsv_exu_src1_vld_1),
	.o_rsv_exu_src1_prf_data_1(o_rsv_exu_src1_dat_1),
	.o_rsv_exu_src2_vld_1     (o_rsv_exu_src2_vld_1),
	.o_rsv_exu_src2_prf_data_1(o_rsv_exu_src2_dat_1),
	.o_rsv_exu_src3_vld_1     (o_rsv_exu_src3_vld_1),
	.o_rsv_exu_src3_prf_data_1(o_rsv_exu_src3_dat_1),
	.o_rsv_exu_src1_vld_2     (o_rsv_exu_src1_vld_2),
	.o_rsv_exu_src1_prf_data_2(o_rsv_exu_src1_dat_2),
	.o_rsv_exu_src2_vld_2     (o_rsv_exu_src2_vld_2),
	.o_rsv_exu_src2_prf_data_2(o_rsv_exu_src2_dat_2),
	.o_rsv_exu_src3_vld_2     (o_rsv_exu_src3_vld_2),
	.o_rsv_exu_src3_prf_data_2(o_rsv_exu_src3_dat_2), 
	.o_rsv_exu_src1_vld_3     (o_rsv_exu_src1_vld_3),
	.o_rsv_exu_src1_prf_data_3(o_rsv_exu_src1_dat_3),
	.o_rsv_exu_src2_vld_3     (o_rsv_exu_src2_vld_3),
	.o_rsv_exu_src2_prf_data_3(o_rsv_exu_src2_dat_3),
	.o_rsv_exu_src3_vld_3     (o_rsv_exu_src3_vld_3),
	.o_rsv_exu_src3_prf_data_3(o_rsv_exu_src3_dat_3),
	.o_rsv_arb_stall_0        (o_rsv_arb_stall_0),
	.o_rsv_arb_stall_1        (o_rsv_arb_stall_1),
	.o_rsv_arb_stall_2        (o_rsv_arb_stall_2),
	.o_rsv_arb_stall_3        (o_rsv_arb_stall_3),
	.o_rsv_prf_rd_code_0      (o_prf_rsv_rd_code_0),
	.o_rsv_prf_rd_code_1      (o_prf_rsv_rd_code_1),
	.o_rsv_prf_rd_code_2      (o_prf_rsv_rd_code_2),
	.o_rsv_prf_rd_code_3      (o_prf_rsv_rd_code_3),
	.o_rsv_prf_rd_code_4      (o_prf_rsv_rd_code_4),
	.o_rsv_prf_rd_code_5      (o_prf_rsv_rd_code_5),
	.o_rsv_prf_rd_code_6      (o_prf_rsv_rd_code_6),
	.o_rsv_prf_rd_code_7      (o_prf_rsv_rd_code_7),

	.clk                      (clk),
	.rst_n                    (rst_n)
);

assign {
		o_rsv_exu_issue_vld_3
	,	o_rsv_exu_issue_vld_2
	,	o_rsv_exu_issue_vld_1
	,	o_rsv_exu_issue_vld_0
} = o_rsv_exu_issue_vld;

//
wire [`PRF_NUMS - 1 : 0] o_prf_rsv_available;

rsv_prf_module rsv_prf (
	.i_ren_prf_free_req_0     (i_ren_prf_free_req_0),
	.i_ren_prf_free_req_1     (i_ren_prf_free_req_1),
	.i_ren_prf_free_req_2     (i_ren_prf_free_req_2),
	.i_ren_prf_free_req_3     (i_ren_prf_free_req_3),
	.i_ren_prf_free_prf_code_0(i_ren_prf_free_prf_code_0),
	.i_ren_prf_free_prf_code_1(i_ren_prf_free_prf_code_1),
	.i_ren_prf_free_prf_code_2(i_ren_prf_free_prf_code_2),
	.i_ren_prf_free_prf_code_3(i_ren_prf_free_prf_code_3),
	.i_rsv_prf_rd_code_0      (o_prf_rsv_rd_code_0),
	.i_rsv_prf_rd_code_1      (o_prf_rsv_rd_code_1),
	.i_rsv_prf_rd_code_2      (o_prf_rsv_rd_code_2),
	.i_rsv_prf_rd_code_3      (o_prf_rsv_rd_code_3),
	.i_rsv_prf_rd_code_4      (o_prf_rsv_rd_code_4),
	.i_rsv_prf_rd_code_5      (o_prf_rsv_rd_code_5),
	.i_rsv_prf_rd_code_6      (o_prf_rsv_rd_code_6),
	.i_rsv_prf_rd_code_7      (o_prf_rsv_rd_code_7),
	.i_rsv_prf_wren_0         (i_exu_rsv_wb_vld_0), 
	.i_rsv_prf_wren_1         (i_exu_rsv_wb_vld_1),
	.i_rsv_prf_wren_2         (i_exu_rsv_wb_vld_2), 
	.i_rsv_prf_wren_3         (i_exu_rsv_wb_vld_3),
	.i_rsv_prf_wr_code_0      (i_exu_rsv_wb_prf_code_0),
	.i_rsv_prf_wr_code_1      (i_exu_rsv_wb_prf_code_1),
	.i_rsv_prf_wr_code_2      (i_exu_rsv_wb_prf_code_2),
	.i_rsv_prf_wr_code_3      (i_exu_rsv_wb_prf_code_3),
	.i_rsv_prf_wdat_0         (i_exu_rsv_wb_dat_0),
	.i_rsv_prf_wdat_1         (i_exu_rsv_wb_dat_1),
	.i_rsv_prf_wdat_2         (i_exu_rsv_wb_dat_2),
	.i_rsv_prf_wdat_3         (i_exu_rsv_wb_dat_3), 
	.o_prf_rsv_rdat_0         (o_prf_rsv_rdat_0), 
	.o_prf_rsv_rdat_1         (o_prf_rsv_rdat_1),
	.o_prf_rsv_rdat_2         (o_prf_rsv_rdat_2),
	.o_prf_rsv_rdat_3         (o_prf_rsv_rdat_3), 
	.o_prf_rsv_rdat_4         (o_prf_rsv_rdat_4), 
	.o_prf_rsv_rdat_5         (o_prf_rsv_rdat_5), 
	.o_prf_rsv_rdat_6         (o_prf_rsv_rdat_6),
	.o_prf_rsv_rdat_7         (o_prf_rsv_rdat_7),
	.o_prf_rsv_available      (o_prf_rsv_available),

	.clk                      (clk), 
	.rst_n                    (rst_n)
);

endmodule   //  rsv_module

`endif  /*  !__RSV_RSV_V__! */