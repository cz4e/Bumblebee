`ifdef __RSV_RSV_ISSUE_V__

module rsv_issue_module (
    input                                               i_rsv_issue_vld_0,
    input                                               i_rsv_issue_vld_1,
    input                                               i_rsv_issue_vld_2,
    input                                               i_rsv_issue_vld_3,
    input                                               i_rsv_src1_vld_0,
    input   [`PRF_CODE_WIDTH - 1        : 0]            i_rsv_src1_prf_code_0,
    input                                               i_rsv_src2_vld_0,
    input   [`PRF_CODE_WIDTH - 1        : 0]            i_rsv_src2_prf_code_0,
    input                                               i_rsv_src3_vld_0,
    input   [`PRF_CODE_WIDTH - 1        : 0]            i_rsv_src3_prf_code_0,
    input                                               i_rsv_dst_vld_0,
    input   [`PRF_CODE_WIDTH - 1        : 0]            i_rsv_dst_prf_code_0,
    input                                               i_rsv_src1_vld_1,
    input   [`PRF_CODE_WIDTH - 1        : 0]            i_rsv_src1_prf_code_1,
    input                                               i_rsv_src2_vld_1,
    input   [`PRF_CODE_WIDTH - 1        : 0]            i_rsv_src2_prf_code_1,
    input                                               i_rsv_src3_vld_1,
    input   [`PRF_CODE_WIDTH - 1        : 0]            i_rsv_src3_prf_code_1,
    input                                               i_rsv_dst_vld_1,
    input   [`PRF_CODE_WIDTH - 1        : 0]            i_rsv_dst_prf_code_1,
    input                                               i_rsv_src1_vld_2,
    input   [`PRF_CODE_WIDTH - 1        : 0]            i_rsv_src1_prf_code_2,
    input                                               i_rsv_src2_vld_2,
    input   [`PRF_CODE_WIDTH - 1        : 0]            i_rsv_src2_prf_code_2,
    input                                               i_rsv_src3_vld_2,
    input   [`PRF_CODE_WIDTH - 1        : 0]            i_rsv_src3_prf_code_2,
    input                                               i_rsv_dst_vld_2,
    input   [`PRF_CODE_WIDTH - 1        : 0]            i_rsv_dst_prf_code_2,
    input                                               i_rsv_src1_vld_3,
    input   [`PRF_CODE_WIDTH - 1        : 0]            i_rsv_src1_prf_code_3,
    input                                               i_rsv_src2_vld_3,
    input   [`PRF_CODE_WIDTH - 1        : 0]            i_rsv_src2_prf_code_3,
    input                                               i_rsv_src3_vld_3,
    input   [`PRF_CODE_WIDTH - 1        : 0]            i_rsv_src3_prf_code_3,
    input                                               i_rsv_dst_vld_3, 
    input   [`PRF_CODE_WIDTH - 1        : 0]            i_rsv_dst_prf_code_3,

    input   [`PRF_DATA_WIDTH - 1        : 0]            i_prf_rsv_rdat_0,
    input   [`PRF_DATA_WIDTH - 1        : 0]            i_prf_rsv_rdat_1,
    input   [`PRF_DATA_WIDTH - 1        : 0]            i_prf_rsv_rdat_2,
    input   [`PRF_DATA_WIDTH - 1        : 0]            i_prf_rsv_rdat_3,
    input   [`PRF_DATA_WIDTH - 1        : 0]            i_prf_rsv_rdat_4,
    input   [`PRF_DATA_WIDTH - 1        : 0]            i_prf_rsv_rdat_5,
    input   [`PRF_DATA_WIDTH - 1        : 0]            i_prf_rsv_rdat_6,
    input   [`PRF_DATA_WIDTH - 1        : 0]            i_prf_rsv_rdat_7, 

    input   [`PRF_NUMS - 1              : 0]            i_prf_rsv_available,

    output  [3                          : 0]            o_rsv_exu_issue_vld,
    output                                              o_rsv_exu_src1_vld_0,
    output  [`PRF_DATA_WIDTH - 1        : 0]            o_rsv_exu_src1_prf_data_0,
    output                                              o_rsv_exu_src2_vld_0,
    output  [`PRF_DATA_WIDTH - 1        : 0]            o_rsv_exu_src2_prf_data_0,
    output                                              o_rsv_exu_src3_vld_0,
    output  [`PRF_DATA_WIDTH - 1        : 0]            o_rsv_exu_src3_prf_data_0,
    output                                              o_rsv_exu_src1_vld_1,
    output  [`PRF_DATA_WIDTH - 1        : 0]            o_rsv_exu_src1_prf_data_1,
    output                                              o_rsv_exu_src2_vld_1,
    output  [`PRF_DATA_WIDTH - 1        : 0]            o_rsv_exu_src2_prf_data_1,
    output                                              o_rsv_exu_src3_vld_1,
    output  [`PRF_DATA_WIDTH - 1        : 0]            o_rsv_exu_src3_prf_data_1,
    output                                              o_rsv_exu_src1_vld_2,
    output  [`PRF_DATA_WIDTH - 1        : 0]            o_rsv_exu_src1_prf_data_2,
    output                                              o_rsv_exu_src2_vld_2,
    output  [`PRF_DATA_WIDTH - 1        : 0]            o_rsv_exu_src2_prf_data_2,
    output                                              o_rsv_exu_src3_vld_2,
    output  [`PRF_DATA_WIDTH - 1        : 0]            o_rsv_exu_src3_prf_data_2,
    output                                              o_rsv_exu_src1_vld_3,
    output  [`PRF_DATA_WIDTH - 1        : 0]            o_rsv_exu_src1_prf_data_3,
    output                                              o_rsv_exu_src2_vld_3,
    output  [`PRF_DATA_WIDTH - 1        : 0]            o_rsv_exu_src2_prf_data_3,
    output                                              o_rsv_exu_src3_vld_3,
    output  [`PRF_DATA_WIDTH - 1        : 0]            o_rsv_exu_src3_prf_data_3,

    output                                              o_rsv_arb_stall_0,
    output                                              o_rsv_arb_stall_1,
    output                                              o_rsv_arb_stall_2,
    output                                              o_rsv_arb_stall_3,

    output  [`PRF_CODE_WIDTH - 1        : 0]            o_rsv_prf_rd_code_0,
    output  [`PRF_CODE_WIDTH - 1        : 0]            o_rsv_prf_rd_code_1,
    output  [`PRF_CODE_WIDTH - 1        : 0]            o_rsv_prf_rd_code_2,
    output  [`PRF_CODE_WIDTH - 1        : 0]            o_rsv_prf_rd_code_3,
    output  [`PRF_CODE_WIDTH - 1        : 0]            o_rsv_prf_rd_code_4,
    output  [`PRF_CODE_WIDTH - 1        : 0]            o_rsv_prf_rd_code_5,
    output  [`PRF_CODE_WIDTH - 1        : 0]            o_rsv_prf_rd_code_6,
    output  [`PRF_CODE_WIDTH - 1        : 0]            o_rsv_prf_rd_code_7,

    input                                               clk,
    input                                               rst_n
);

assign o_rsv_exu_issue_vld = {
                                i_rsv_issue_vld_3
                            ,   i_rsv_issue_vld_2
                            ,   i_rsv_issue_vld_1
                            ,   i_rsv_issue_vld_0
                            };

assign {
        o_rsv_exu_src3_vld_3
    ,   o_rsv_exu_src2_vld_3
    ,   o_rsv_exu_src1_vld_3
    ,   o_rsv_exu_src3_vld_2
    ,   o_rsv_exu_src2_vld_2
    ,   o_rsv_exu_src1_vld_2
    ,   o_rsv_exu_src3_vld_1
    ,   o_rsv_exu_src2_vld_1
    ,   o_rsv_exu_src1_vld_1
    ,   o_rsv_exu_src3_vld_0
    ,   o_rsv_exu_src2_vld_0
    ,   o_rsv_exu_src1_vld_0
} = {
        i_rsv_src3_vld_3
    ,   i_rsv_src2_vld_3
    ,   i_rsv_src1_vld_3
    ,   i_rsv_src3_vld_2
    ,   i_rsv_src2_vld_2
    ,   i_rsv_src1_vld_2
    ,   i_rsv_src3_vld_1
    ,   i_rsv_src2_vld_1
    ,   i_rsv_src1_vld_1
    ,   i_rsv_src3_vld_0
    ,   i_rsv_src2_vld_0
    ,   i_rsv_src1_vld_0
};

//  
wire rsv_src1_vld_0 = (i_rsv_issue_vld_0 & i_rsv_src1_vld_0);
wire rsv_src2_vld_0 = (i_rsv_issue_vld_0 & i_rsv_src2_vld_0);
wire rsv_src3_vld_0 = (i_rsv_issue_vld_0 & i_rsv_src3_vld_0);

wire rsv_src1_vld_1 = (i_rsv_issue_vld_1 & i_rsv_src1_vld_1);
wire rsv_src2_vld_1 = (i_rsv_issue_vld_1 & i_rsv_src2_vld_1);
wire rsv_src3_vld_1 = (i_rsv_issue_vld_1 & i_rsv_src3_vld_1);

wire rsv_src1_vld_2 = (i_rsv_issue_vld_2 & i_rsv_src1_vld_2);
wire rsv_src2_vld_2 = (i_rsv_issue_vld_2 & i_rsv_src2_vld_2);
wire rsv_src3_vld_2 = (i_rsv_issue_vld_2 & i_rsv_src3_vld_2);

wire rsv_src1_vld_3 = (i_rsv_issue_vld_3 & i_rsv_src1_vld_3);
wire rsv_src2_vld_3 = (i_rsv_issue_vld_3 & i_rsv_src2_vld_3);
wire rsv_src3_vld_3 = (i_rsv_issue_vld_3 & i_rsv_src3_vld_3);

wire [11 : 0] rsv_src_vec = {
                                rsv_src3_vld_2 // 11 
                            ,   rsv_src2_vld_2 // 10
                            ,   rsv_src1_vld_2 // 9
                            ,   rsv_src3_vld_0 // 8
                            ,   rsv_src2_vld_0 // 7
                            ,   rsv_src1_vld_0 // 6
                            ,   rsv_src3_vld_1 // 5
                            ,   rsv_src2_vld_1 // 4
                            ,   rsv_src1_vld_1 // 3
                            ,   rsv_src3_vld_3 // 2
                            ,   rsv_src2_vld_3 // 1
                            ,   rsv_src1_vld_3 // 0
                            };


wire [7 : 0] rsv_prf_port_vec;
wire [3 : 0] rsv_arb_rd_succ;

wire [1 : 0] rsv_src_ctr_0 = func_ctr3(rsv_src_vec[ 8 : 6]);
wire [1 : 0] rsv_src_ctr_1 = func_ctr3(rsv_src_vec[ 5 : 3]);
wire [1 : 0] rsv_src_ctr_2 = func_ctr3(rsv_src_vec[11 : 9]);
wire [1 : 0] rsv_src_ctr_3 = func_ctr3(rsv_src_vec[ 2 : 0]);

wire [3 : 0] rsv_src_ctr = ({2'b0, rsv_src_ctr_0}
                         +  {2'b0, rsv_src_ctr_1}
                         +  {2'b0, rsv_src_ctr_2}
                         +  {2'b0, rsv_src_ctr_3});

assign rsv_prf_port_vec = ({8{(rsv_src_ctr == 4'd1)}} & 8'b0000_0001)
                        | ({8{(rsv_src_ctr == 4'd2)}} & 8'b0000_0011)
                        | ({8{(rsv_src_ctr == 4'd3)}} & 8'b0000_0111)
                        | ({8{(rsv_src_ctr == 4'd4)}} & 8'b0000_1111)
                        | ({8{(rsv_src_ctr == 4'd5)}} & 8'b0001_1111)
                        | ({8{(rsv_src_ctr == 4'd6)}} & 8'b0011_1111)
                        | ({8{(rsv_src_ctr == 4'd7)}} & 8'b0111_1111)
                        | ({8{(rsv_src_ctr >= 4'd8)}} & 8'b1111_1111);

assign rsv_arb_rd_succ = {
                            1'b1 
                        ,   (rsv_src_ctr <= 4'd8) & (rsv_src_ctr_2 <= (4'd8 - ({2'b0, rsv_src_ctr_3} + {2'b0, rsv_src_ctr_1} + {2'b0, rsv_src_ctr_0})))
                        ,   1'b1
                        ,   (rsv_src_ctr_0 <= (4'd8 - ({2'b0, rsv_src_ctr_3} + {2'b0, rsv_src_ctr_1}))) 
                        };
//  PRF read port
//  Port 0
wire [3 : 0] rsv_rd_port_0_idx = func_sel_0(rsv_src_vec);
assign o_rsv_prf_rd_code_0 = ({`PRF_CODE_WIDTH{(rsv_rd_port_0_idx == 4'd0 )}} & i_rsv_src1_prf_code_3)
                           | ({`PRF_CODE_WIDTH{(rsv_rd_port_0_idx == 4'd1 )}} & i_rsv_src2_prf_code_3)
                           | ({`PRF_CODE_WIDTH{(rsv_rd_port_0_idx == 4'd2 )}} & i_rsv_src3_prf_code_3)
                           | ({`PRF_CODE_WIDTH{(rsv_rd_port_0_idx == 4'd3 )}} & i_rsv_src1_prf_code_1)
                           | ({`PRF_CODE_WIDTH{(rsv_rd_port_0_idx == 4'd4 )}} & i_rsv_src2_prf_code_1)
                           | ({`PRF_CODE_WIDTH{(rsv_rd_port_0_idx == 4'd5 )}} & i_rsv_src3_prf_code_1)
                           | ({`PRF_CODE_WIDTH{(rsv_rd_port_0_idx == 4'd6 )}} & i_rsv_src1_prf_code_0)
                           | ({`PRF_CODE_WIDTH{(rsv_rd_port_0_idx == 4'd7 )}} & i_rsv_src2_prf_code_0)
                           | ({`PRF_CODE_WIDTH{(rsv_rd_port_0_idx == 4'd8 )}} & i_rsv_src3_prf_code_0)
                           | ({`PRF_CODE_WIDTH{(rsv_rd_port_0_idx == 4'd9 )}} & i_rsv_src1_prf_code_2)
                           | ({`PRF_CODE_WIDTH{(rsv_rd_port_0_idx == 4'd10)}} & i_rsv_src2_prf_code_2)
                           | ({`PRF_CODE_WIDTH{(rsv_rd_port_0_idx == 4'd11)}} & i_rsv_src3_prf_code_2);

//  Port 1
wire [3 : 0] rsv_rd_port_1_idx = func_sel_1(rsv_src_vec);
assign o_rsv_prf_rd_code_1 = ({`PRF_CODE_WIDTH{(rsv_rd_port_1_idx == 4'd1 )}} & i_rsv_src2_prf_code_3)
                           | ({`PRF_CODE_WIDTH{(rsv_rd_port_1_idx == 4'd2 )}} & i_rsv_src3_prf_code_3)
                           | ({`PRF_CODE_WIDTH{(rsv_rd_port_1_idx == 4'd3 )}} & i_rsv_src1_prf_code_1)
                           | ({`PRF_CODE_WIDTH{(rsv_rd_port_1_idx == 4'd4 )}} & i_rsv_src2_prf_code_1)
                           | ({`PRF_CODE_WIDTH{(rsv_rd_port_1_idx == 4'd5 )}} & i_rsv_src3_prf_code_1)
                           | ({`PRF_CODE_WIDTH{(rsv_rd_port_1_idx == 4'd6 )}} & i_rsv_src1_prf_code_0)
                           | ({`PRF_CODE_WIDTH{(rsv_rd_port_1_idx == 4'd7 )}} & i_rsv_src2_prf_code_0)
                           | ({`PRF_CODE_WIDTH{(rsv_rd_port_1_idx == 4'd8 )}} & i_rsv_src3_prf_code_0)
                           | ({`PRF_CODE_WIDTH{(rsv_rd_port_1_idx == 4'd9 )}} & i_rsv_src1_prf_code_2)
                           | ({`PRF_CODE_WIDTH{(rsv_rd_port_1_idx == 4'd10)}} & i_rsv_src2_prf_code_2)
                           | ({`PRF_CODE_WIDTH{(rsv_rd_port_1_idx == 4'd11)}} & i_rsv_src3_prf_code_2);
//  Port 2
wire [3 : 0] rsv_rd_port_2_idx = func_sel_2(rsv_src_vec);
assign o_rsv_prf_rd_code_2 = ({`PRF_CODE_WIDTH{(rsv_rd_port_2_idx == 4'd2 )}} & i_rsv_src3_prf_code_3)
                           | ({`PRF_CODE_WIDTH{(rsv_rd_port_2_idx == 4'd3 )}} & i_rsv_src1_prf_code_1)
                           | ({`PRF_CODE_WIDTH{(rsv_rd_port_2_idx == 4'd4 )}} & i_rsv_src2_prf_code_1)
                           | ({`PRF_CODE_WIDTH{(rsv_rd_port_2_idx == 4'd5 )}} & i_rsv_src3_prf_code_1)
                           | ({`PRF_CODE_WIDTH{(rsv_rd_port_2_idx == 4'd6 )}} & i_rsv_src1_prf_code_0)
                           | ({`PRF_CODE_WIDTH{(rsv_rd_port_2_idx == 4'd7 )}} & i_rsv_src2_prf_code_0)
                           | ({`PRF_CODE_WIDTH{(rsv_rd_port_2_idx == 4'd8 )}} & i_rsv_src3_prf_code_0)
                           | ({`PRF_CODE_WIDTH{(rsv_rd_port_2_idx == 4'd9 )}} & i_rsv_src1_prf_code_2)
                           | ({`PRF_CODE_WIDTH{(rsv_rd_port_2_idx == 4'd10)}} & i_rsv_src2_prf_code_2)
                           | ({`PRF_CODE_WIDTH{(rsv_rd_port_2_idx == 4'd11)}} & i_rsv_src3_prf_code_2);
//  Port 3
wire [3 : 0] rsv_rd_port_3_idx = func_sel_3(rsv_src_vec);
assign o_rsv_prf_rd_code_3 = ({`PRF_CODE_WIDTH{(rsv_rd_port_3_idx == 4'd3 )}} & i_rsv_src1_prf_code_1)
                           | ({`PRF_CODE_WIDTH{(rsv_rd_port_3_idx == 4'd4 )}} & i_rsv_src2_prf_code_1)
                           | ({`PRF_CODE_WIDTH{(rsv_rd_port_3_idx == 4'd5 )}} & i_rsv_src3_prf_code_1)
                           | ({`PRF_CODE_WIDTH{(rsv_rd_port_3_idx == 4'd6 )}} & i_rsv_src1_prf_code_0)
                           | ({`PRF_CODE_WIDTH{(rsv_rd_port_3_idx == 4'd7 )}} & i_rsv_src2_prf_code_0)
                           | ({`PRF_CODE_WIDTH{(rsv_rd_port_3_idx == 4'd8 )}} & i_rsv_src3_prf_code_0)
                           | ({`PRF_CODE_WIDTH{(rsv_rd_port_3_idx == 4'd9 )}} & i_rsv_src1_prf_code_2)
                           | ({`PRF_CODE_WIDTH{(rsv_rd_port_3_idx == 4'd10)}} & i_rsv_src2_prf_code_2)
                           | ({`PRF_CODE_WIDTH{(rsv_rd_port_3_idx == 4'd11)}} & i_rsv_src3_prf_code_2);
//  Port 4
wire [3 : 0] rsv_rd_port_4_idx = func_sel_4(rsv_src_vec);
assign o_rsv_prf_rd_code_4 = ({`PRF_CODE_WIDTH{(rsv_rd_port_4_idx == 4'd4 )}} & i_rsv_src2_prf_code_1)
                           | ({`PRF_CODE_WIDTH{(rsv_rd_port_4_idx == 4'd5 )}} & i_rsv_src3_prf_code_1)
                           | ({`PRF_CODE_WIDTH{(rsv_rd_port_4_idx == 4'd6 )}} & i_rsv_src1_prf_code_0)
                           | ({`PRF_CODE_WIDTH{(rsv_rd_port_4_idx == 4'd7 )}} & i_rsv_src2_prf_code_0)
                           | ({`PRF_CODE_WIDTH{(rsv_rd_port_4_idx == 4'd8 )}} & i_rsv_src3_prf_code_0)
                           | ({`PRF_CODE_WIDTH{(rsv_rd_port_4_idx == 4'd9 )}} & i_rsv_src1_prf_code_2)
                           | ({`PRF_CODE_WIDTH{(rsv_rd_port_4_idx == 4'd10)}} & i_rsv_src2_prf_code_2)
                           | ({`PRF_CODE_WIDTH{(rsv_rd_port_4_idx == 4'd11)}} & i_rsv_src3_prf_code_2);
//  Port 5
wire [3 : 0] rsv_rd_port_5_idx = func_sel_5(rsv_src_vec);
assign o_rsv_prf_rd_code_5 = ({`PRF_CODE_WIDTH{(rsv_rd_port_5_idx == 4'd5 )}} & i_rsv_src3_prf_code_1)
                           | ({`PRF_CODE_WIDTH{(rsv_rd_port_5_idx == 4'd6 )}} & i_rsv_src1_prf_code_0)
                           | ({`PRF_CODE_WIDTH{(rsv_rd_port_5_idx == 4'd7 )}} & i_rsv_src2_prf_code_0)
                           | ({`PRF_CODE_WIDTH{(rsv_rd_port_5_idx == 4'd8 )}} & i_rsv_src3_prf_code_0)
                           | ({`PRF_CODE_WIDTH{(rsv_rd_port_5_idx == 4'd9 )}} & i_rsv_src1_prf_code_2)
                           | ({`PRF_CODE_WIDTH{(rsv_rd_port_5_idx == 4'd10)}} & i_rsv_src2_prf_code_2)
                           | ({`PRF_CODE_WIDTH{(rsv_rd_port_5_idx == 4'd11)}} & i_rsv_src3_prf_code_2);
//  Port 6
wire [3 : 0] rsv_rd_port_6_idx = func_sel_6(rsv_src_vec);
assign o_rsv_prf_rd_code_6 = ({`PRF_CODE_WIDTH{(rsv_rd_port_6_idx == 4'd6 )}} & i_rsv_src1_prf_code_0)
                           | ({`PRF_CODE_WIDTH{(rsv_rd_port_6_idx == 4'd7 )}} & i_rsv_src2_prf_code_0)
                           | ({`PRF_CODE_WIDTH{(rsv_rd_port_6_idx == 4'd8 )}} & i_rsv_src3_prf_code_0)
                           | ({`PRF_CODE_WIDTH{(rsv_rd_port_6_idx == 4'd9 )}} & i_rsv_src1_prf_code_2)
                           | ({`PRF_CODE_WIDTH{(rsv_rd_port_6_idx == 4'd10)}} & i_rsv_src2_prf_code_2)
                           | ({`PRF_CODE_WIDTH{(rsv_rd_port_6_idx == 4'd11)}} & i_rsv_src3_prf_code_2);
//  Port 7
wire [3 : 0] rsv_rd_port_7_idx = func_sel_7(rsv_src_vec);
assign o_rsv_prf_rd_code_7 = ({`PRF_CODE_WIDTH{(rsv_rd_port_7_idx == 4'd7 )}} & i_rsv_src2_prf_code_0)
                           | ({`PRF_CODE_WIDTH{(rsv_rd_port_7_idx == 4'd8 )}} & i_rsv_src3_prf_code_0)
                           | ({`PRF_CODE_WIDTH{(rsv_rd_port_7_idx == 4'd9 )}} & i_rsv_src1_prf_code_2)
                           | ({`PRF_CODE_WIDTH{(rsv_rd_port_7_idx == 4'd10)}} & i_rsv_src2_prf_code_2)
                           | ({`PRF_CODE_WIDTH{(rsv_rd_port_7_idx == 4'd11)}} & i_rsv_src3_prf_code_2);

//
assign {
        o_rsv_arb_stall_3
    ,   o_rsv_arb_stall_2
    ,   o_rsv_arb_stall_1
    ,   o_rsv_arb_stall_0
} = {
        (i_rsv_issue_vld_3 & (~rsv_arb_rd_succ[3]))
    ,   (i_rsv_issue_vld_2 & (~rsv_arb_rd_succ[2]))
    ,   (i_rsv_issue_vld_1 & (~rsv_arb_rd_succ[1]))
    ,   (i_rsv_issue_vld_0 & (~rsv_arb_rd_succ[0]))
    };
//
wire [3 : 0] sr_src_sel_0 = func_sel_0(rsv_src_vec);
wire [3 : 0] sr_src_sel_1 = func_sel_1(rsv_src_vec);
wire [3 : 0] sr_src_sel_2 = func_sel_2(rsv_src_vec);
wire [3 : 0] sr_src_sel_3 = func_sel_3(rsv_src_vec);
wire [3 : 0] sr_src_sel_4 = func_sel_4(rsv_src_vec);
wire [3 : 0] sr_src_sel_5 = func_sel_5(rsv_src_vec);
wire [3 : 0] sr_src_sel_6 = func_sel_6(rsv_src_vec);
wire [3 : 0] sr_src_sel_7 = func_sel_7(rsv_src_vec);

//  Issue port 3
wire [`PRF_DATA_WIDTH - 1 : 0] o_rsv_exu_src1_prf_data_3 = ({`PRF_DATA_WIDTH{(sr_src_sel_0 == 4'd0) & (i_prf_rsv_available[i_rsv_src1_prf_code_3])}} & i_prf_rsv_rdat_0);
wire [`PRF_DATA_WIDTH - 1 : 0] o_rsv_exu_src2_prf_data_3 = ({`PRF_CODE_WIDTH{(sr_src_sel_0 == 4'd1) & (i_prf_rsv_available[i_rsv_src2_prf_code_3])}} & i_prf_rsv_rdat_0)
                                                         | ({`PRF_CODE_WIDTH{(sr_src_sel_1 == 4'd1) & (i_prf_rsv_available[i_rsv_src2_prf_code_3])}} & i_prf_rsv_rdat_1);
wire [`PRF_DATA_WIDTH - 1 : 0] o_rsv_exu_src3_prf_data_3 = ({`PRF_DATA_WIDTH{(sr_src_sel_0 == 4'd2) & (i_prf_rsv_available[i_rsv_src3_prf_code_3])}} & i_prf_rsv_rdat_0)
                                                         | ({`PRF_DATA_WIDTH{(sr_src_sel_1 == 4'd2) & (i_prf_rsv_available[i_rsv_src3_prf_code_3])}} & i_prf_rsv_rdat_1)
                                                         | ({`PRF_DATA_WIDTH{(sr_src_sel_2 == 4'd2) & (i_prf_rsv_available[i_rsv_src3_prf_code_3])}} & i_prf_rsv_rdat_2);

//  Issue port 1
wire [`PRF_DATA_WIDTH - 1 : 0] o_rsv_exu_src1_prf_data_1 = ({`PRF_DATA_WIDTH{(sr_src_sel_0 == 4'd3) & (i_prf_rsv_available[i_rsv_src1_prf_code_1])}} & i_prf_rsv_rdat_0)
                                                         | ({`PRF_DATA_WIDTH{(sr_src_sel_1 == 4'd3) & (i_prf_rsv_available[i_rsv_src1_prf_code_1])}} & i_prf_rsv_rdat_1)
                                                         | ({`PRF_DATA_WIDTH{(sr_src_sel_2 == 4'd3) & (i_prf_rsv_available[i_rsv_src1_prf_code_1])}} & i_prf_rsv_rdat_2)
                                                         | ({`PRF_DATA_WIDTH{(sr_src_sel_3 == 4'd3) & (i_prf_rsv_available[i_rsv_src1_prf_code_1])}} & i_prf_rsv_rdat_3);
wire [`PRF_DATA_WIDTH - 1 : 0] o_rsv_exu_src2_prf_data_1 = ({`PRF_DATA_WIDTH{(sr_src_sel_0 == 4'd4) & (i_prf_rsv_available[i_rsv_src2_prf_code_1])}} & i_prf_rsv_rdat_0)
                                                         | ({`PRF_DATA_WIDTH{(sr_src_sel_1 == 4'd4) & (i_prf_rsv_available[i_rsv_src2_prf_code_1])}} & i_prf_rsv_rdat_1)
                                                         | ({`PRF_DATA_WIDTH{(sr_src_sel_2 == 4'd4) & (i_prf_rsv_available[i_rsv_src2_prf_code_1])}} & i_prf_rsv_rdat_2)
                                                         | ({`PRF_DATA_WIDTH{(sr_src_sel_3 == 4'd4) & (i_prf_rsv_available[i_rsv_src2_prf_code_1])}} & i_prf_rsv_rdat_3)
                                                         | ({`PRF_DATA_WIDTH{(sr_src_sel_4 == 4'd4) & (i_prf_rsv_available[i_rsv_src2_prf_code_1])}} & i_prf_rsv_rdat_4);
wire [`PRF_DATA_WIDTH - 1 : 0] o_rsv_exu_src3_prf_data_1 = ({`PRF_DATA_WIDTH{(sr_src_sel_0 == 4'd5) & (i_prf_rsv_available[i_rsv_src3_prf_code_1])}} & i_prf_rsv_rdat_0)
                                                         | ({`PRF_DATA_WIDTH{(sr_src_sel_1 == 4'd5) & (i_prf_rsv_available[i_rsv_src3_prf_code_1])}} & i_prf_rsv_rdat_1)
                                                         | ({`PRF_DATA_WIDTH{(sr_src_sel_2 == 4'd5) & (i_prf_rsv_available[i_rsv_src3_prf_code_1])}} & i_prf_rsv_rdat_2)
                                                         | ({`PRF_DATA_WIDTH{(sr_src_sel_3 == 4'd5) & (i_prf_rsv_available[i_rsv_src3_prf_code_1])}} & i_prf_rsv_rdat_3)
                                                         | ({`PRF_DATA_WIDTH{(sr_src_sel_4 == 4'd5) & (i_prf_rsv_available[i_rsv_src3_prf_code_1])}} & i_prf_rsv_rdat_4)
                                                         | ({`PRF_DATA_WIDTH{(sr_src_sel_5 == 4'd5) & (i_prf_rsv_available[i_rsv_src3_prf_code_1])}} & i_prf_rsv_rdat_5);

//  Issue port 0
wire [`PRF_DATA_WIDTH - 1 : 0] o_rsv_exu_src1_prf_data_0 = ({`PRF_DATA_WIDTH{(sr_src_sel_0 == 4'd6) & (i_prf_rsv_available[i_rsv_src1_prf_code_0])}} & i_prf_rsv_rdat_0)
                                                         | ({`PRF_DATA_WIDTH{(sr_src_sel_1 == 4'd6) & (i_prf_rsv_available[i_rsv_src1_prf_code_0])}} & i_prf_rsv_rdat_1)
                                                         | ({`PRF_DATA_WIDTH{(sr_src_sel_2 == 4'd6) & (i_prf_rsv_available[i_rsv_src1_prf_code_0])}} & i_prf_rsv_rdat_2)
                                                         | ({`PRF_DATA_WIDTH{(sr_src_sel_3 == 4'd6) & (i_prf_rsv_available[i_rsv_src1_prf_code_0])}} & i_prf_rsv_rdat_3)
                                                         | ({`PRF_DATA_WIDTH{(sr_src_sel_4 == 4'd6) & (i_prf_rsv_available[i_rsv_src1_prf_code_0])}} & i_prf_rsv_rdat_4)
                                                         | ({`PRF_DATA_WIDTH{(sr_src_sel_5 == 4'd6) & (i_prf_rsv_available[i_rsv_src1_prf_code_0])}} & i_prf_rsv_rdat_5)
                                                         | ({`PRF_DATA_WIDTH{(sr_src_sel_6 == 4'd6) & (i_prf_rsv_available[i_rsv_src1_prf_code_0])}} & i_prf_rsv_rdat_6);
wire [`PRF_DATA_WIDTH - 1 : 0] o_rsv_exu_src2_prf_data_0 = ({`PRF_DATA_WIDTH{(sr_src_sel_0 == 4'd7) & (i_prf_rsv_available[i_rsv_src2_prf_code_0])}} & i_prf_rsv_rdat_0)
                                                         | ({`PRF_DATA_WIDTH{(sr_src_sel_1 == 4'd7) & (i_prf_rsv_available[i_rsv_src2_prf_code_0])}} & i_prf_rsv_rdat_1)
                                                         | ({`PRF_DATA_WIDTH{(sr_src_sel_2 == 4'd7) & (i_prf_rsv_available[i_rsv_src2_prf_code_0])}} & i_prf_rsv_rdat_2)
                                                         | ({`PRF_DATA_WIDTH{(sr_src_sel_3 == 4'd7) & (i_prf_rsv_available[i_rsv_src2_prf_code_0])}} & i_prf_rsv_rdat_3)
                                                         | ({`PRF_DATA_WIDTH{(sr_src_sel_4 == 4'd7) & (i_prf_rsv_available[i_rsv_src2_prf_code_0])}} & i_prf_rsv_rdat_4)
                                                         | ({`PRF_DATA_WIDTH{(sr_src_sel_5 == 4'd7) & (i_prf_rsv_available[i_rsv_src2_prf_code_0])}} & i_prf_rsv_rdat_5)
                                                         | ({`PRF_DATA_WIDTH{(sr_src_sel_6 == 4'd7) & (i_prf_rsv_available[i_rsv_src2_prf_code_0])}} & i_prf_rsv_rdat_6)
                                                         | ({`PRF_DATA_WIDTH{(sr_src_sel_7 == 4'd7) & (i_prf_rsv_available[i_rsv_src2_prf_code_0])}} & i_prf_rsv_rdat_7);
wire [`PRF_DATA_WIDTH - 1 : 0] o_rsv_exu_src3_prf_data_0 = ({`PRF_DATA_WIDTH{(sr_src_sel_0 == 4'd8) & (i_prf_rsv_available[i_rsv_src3_prf_code_0])}} & i_prf_rsv_rdat_0)
                                                         | ({`PRF_DATA_WIDTH{(sr_src_sel_1 == 4'd8) & (i_prf_rsv_available[i_rsv_src3_prf_code_0])}} & i_prf_rsv_rdat_1)
                                                         | ({`PRF_DATA_WIDTH{(sr_src_sel_2 == 4'd8) & (i_prf_rsv_available[i_rsv_src3_prf_code_0])}} & i_prf_rsv_rdat_2)
                                                         | ({`PRF_DATA_WIDTH{(sr_src_sel_3 == 4'd8) & (i_prf_rsv_available[i_rsv_src3_prf_code_0])}} & i_prf_rsv_rdat_3)
                                                         | ({`PRF_DATA_WIDTH{(sr_src_sel_4 == 4'd8) & (i_prf_rsv_available[i_rsv_src3_prf_code_0])}} & i_prf_rsv_rdat_4)
                                                         | ({`PRF_DATA_WIDTH{(sr_src_sel_5 == 4'd8) & (i_prf_rsv_available[i_rsv_src3_prf_code_0])}} & i_prf_rsv_rdat_5)
                                                         | ({`PRF_DATA_WIDTH{(sr_src_sel_6 == 4'd8) & (i_prf_rsv_available[i_rsv_src3_prf_code_0])}} & i_prf_rsv_rdat_6)
                                                         | ({`PRF_DATA_WIDTH{(sr_src_sel_7 == 4'd8) & (i_prf_rsv_available[i_rsv_src3_prf_code_0])}} & i_prf_rsv_rdat_7);
 
//  Issue port 2
wire [`PRF_DATA_WIDTH - 1 : 0] o_rsv_exu_src1_prf_data_2 = ({`PRF_DATA_WIDTH{(sr_src_sel_0 == 4'd9 ) & (i_prf_rsv_available[i_rsv_src1_prf_code_2])}} & i_prf_rsv_rdat_0)
                                                         | ({`PRF_DATA_WIDTH{(sr_src_sel_1 == 4'd9 ) & (i_prf_rsv_available[i_rsv_src1_prf_code_2])}} & i_prf_rsv_rdat_1)
                                                         | ({`PRF_DATA_WIDTH{(sr_src_sel_2 == 4'd9 ) & (i_prf_rsv_available[i_rsv_src1_prf_code_2])}} & i_prf_rsv_rdat_2)
                                                         | ({`PRF_DATA_WIDTH{(sr_src_sel_3 == 4'd9 ) & (i_prf_rsv_available[i_rsv_src1_prf_code_2])}} & i_prf_rsv_rdat_3)
                                                         | ({`PRF_DATA_WIDTH{(sr_src_sel_4 == 4'd9 ) & (i_prf_rsv_available[i_rsv_src1_prf_code_2])}} & i_prf_rsv_rdat_4)
                                                         | ({`PRF_DATA_WIDTH{(sr_src_sel_5 == 4'd9 ) & (i_prf_rsv_available[i_rsv_src1_prf_code_2])}} & i_prf_rsv_rdat_5)
                                                         | ({`PRF_DATA_WIDTH{(sr_src_sel_6 == 4'd9 ) & (i_prf_rsv_available[i_rsv_src1_prf_code_2])}} & i_prf_rsv_rdat_6)
                                                         | ({`PRF_DATA_WIDTH{(sr_src_sel_7 == 4'd9 ) & (i_prf_rsv_available[i_rsv_src1_prf_code_2])}} & i_prf_rsv_rdat_7);
wire [`PRF_DATA_WIDTH - 1 : 0] o_rsv_exu_src2_prf_data_2 = ({`PRF_DATA_WIDTH{(sr_src_sel_0 == 4'd10) & (i_prf_rsv_available[i_rsv_src2_prf_code_2])}} & i_prf_rsv_rdat_0)
                                                         | ({`PRF_DATA_WIDTH{(sr_src_sel_1 == 4'd10) & (i_prf_rsv_available[i_rsv_src2_prf_code_2])}} & i_prf_rsv_rdat_1)
                                                         | ({`PRF_DATA_WIDTH{(sr_src_sel_2 == 4'd10) & (i_prf_rsv_available[i_rsv_src2_prf_code_2])}} & i_prf_rsv_rdat_2)
                                                         | ({`PRF_DATA_WIDTH{(sr_src_sel_3 == 4'd10) & (i_prf_rsv_available[i_rsv_src2_prf_code_2])}} & i_prf_rsv_rdat_3)
                                                         | ({`PRF_DATA_WIDTH{(sr_src_sel_4 == 4'd10) & (i_prf_rsv_available[i_rsv_src2_prf_code_2])}} & i_prf_rsv_rdat_4)
                                                         | ({`PRF_DATA_WIDTH{(sr_src_sel_5 == 4'd10) & (i_prf_rsv_available[i_rsv_src2_prf_code_2])}} & i_prf_rsv_rdat_5)
                                                         | ({`PRF_DATA_WIDTH{(sr_src_sel_6 == 4'd10) & (i_prf_rsv_available[i_rsv_src2_prf_code_2])}} & i_prf_rsv_rdat_6)
                                                         | ({`PRF_DATA_WIDTH{(sr_src_sel_7 == 4'd10) & (i_prf_rsv_available[i_rsv_src2_prf_code_2])}} & i_prf_rsv_rdat_7);
wire [`PRF_DATA_WIDTH - 1 : 0] o_rsv_exu_src3_prf_data_2 = ({`PRF_DATA_WIDTH{(sr_src_sel_0 == 4'd11) & (i_prf_rsv_available[i_rsv_src3_prf_code_2])}} & i_prf_rsv_rdat_0)
                                                         | ({`PRF_DATA_WIDTH{(sr_src_sel_1 == 4'd11) & (i_prf_rsv_available[i_rsv_src3_prf_code_2])}} & i_prf_rsv_rdat_1)
                                                         | ({`PRF_DATA_WIDTH{(sr_src_sel_2 == 4'd11) & (i_prf_rsv_available[i_rsv_src3_prf_code_2])}} & i_prf_rsv_rdat_2)
                                                         | ({`PRF_DATA_WIDTH{(sr_src_sel_3 == 4'd11) & (i_prf_rsv_available[i_rsv_src3_prf_code_2])}} & i_prf_rsv_rdat_3)
                                                         | ({`PRF_DATA_WIDTH{(sr_src_sel_4 == 4'd11) & (i_prf_rsv_available[i_rsv_src3_prf_code_2])}} & i_prf_rsv_rdat_4)
                                                         | ({`PRF_DATA_WIDTH{(sr_src_sel_5 == 4'd11) & (i_prf_rsv_available[i_rsv_src3_prf_code_2])}} & i_prf_rsv_rdat_5)
                                                         | ({`PRF_DATA_WIDTH{(sr_src_sel_6 == 4'd11) & (i_prf_rsv_available[i_rsv_src3_prf_code_2])}} & i_prf_rsv_rdat_6)
                                                         | ({`PRF_DATA_WIDTH{(sr_src_sel_7 == 4'd11) & (i_prf_rsv_available[i_rsv_src3_prf_code_2])}} & i_prf_rsv_rdat_7);

//

//  Functions
function  [1 : 0] func_ctr3;
    input [2 : 0] bit_map;

    func_ctr3 = {
                    ((bit_map[2] & bit_map[1]) | (bit_map[0] & (bit_map[2] | bit_map[1])))
                ,    (bit_map[2] ^ bit_map[1] ^ bit_map[0])         
    };

endfunction

function [3 : 0] func_sel_0;
    input   [11 : 0] bit_map;

    casex (bit_map)
        12'bxxx_xxx_xxx_xx1: func_sel_0 = 4'd0;
        12'bxxx_xxx_xxx_x1x: func_sel_0 = 4'd1;
        12'bxxx_xxx_xxx_1xx: func_sel_0 = 4'd2;
        12'bxxx_xxx_xx1_xxx: func_sel_0 = 4'd3;
        12'bxxx_xxx_x1x_xxx: func_sel_0 = 4'd4;
        12'bxxx_xxx_1xx_xxx: func_sel_0 = 4'd5;
        12'bxxx_xx1_xxx_xxx: func_sel_0 = 4'd6;
        12'bxxx_x1x_xxx_xxx: func_sel_0 = 4'd7;
        12'bxxx_1xx_xxx_xxx: func_sel_0 = 4'd8;
        12'bxx1_xxx_xxx_xxx: func_sel_0 = 4'd9;
        12'bx1x_xxx_xxx_xxx: func_sel_0 = 4'd10;
        12'b1xx_xxx_xxx_xxx: func_sel_0 = 4'd11;
        default: func_sel_0 = 4'd12;
    endcase

endfunction

function [3 : 0] func_sel_1;
    input   [11 : 0] bit_map;

    casex ({1'b0, bit_map[11 : 1]})
        12'bxxx_xxx_xxx_xx1: func_sel_1 = 4'd1;
        12'bxxx_xxx_xxx_x1x: func_sel_1 = 4'd2;
        12'bxxx_xxx_xxx_1xx: func_sel_1 = 4'd3;
        12'bxxx_xxx_xx1_xxx: func_sel_1 = 4'd4;
        12'bxxx_xxx_x1x_xxx: func_sel_1 = 4'd5;
        12'bxxx_xxx_1xx_xxx: func_sel_1 = 4'd6;
        12'bxxx_xx1_xxx_xxx: func_sel_1 = 4'd7;
        12'bxxx_x1x_xxx_xxx: func_sel_1 = 4'd8;
        12'bxxx_1xx_xxx_xxx: func_sel_1 = 4'd9;
        12'bxx1_xxx_xxx_xxx: func_sel_1 = 4'd10;
        12'bx1x_xxx_xxx_xxx: func_sel_1 = 4'd11;
        default: func_sel_1 = 4'd12;
    endcase
endfunction

function [3 : 0] func_sel_2;
    input   [11 : 0] bit_map;

    casex ({2'b0, bit_map[11 : 2]})
        12'bxxx_xxx_xxx_xx1: func_sel_2 = 4'd2;
        12'bxxx_xxx_xxx_x1x: func_sel_2 = 4'd3;
        12'bxxx_xxx_xxx_1xx: func_sel_2 = 4'd4;
        12'bxxx_xxx_xx1_xxx: func_sel_2 = 4'd5;
        12'bxxx_xxx_x1x_xxx: func_sel_2 = 4'd6;
        12'bxxx_xxx_1xx_xxx: func_sel_2 = 4'd7;
        12'bxxx_xx1_xxx_xxx: func_sel_2 = 4'd8;
        12'bxxx_x1x_xxx_xxx: func_sel_2 = 4'd9;
        12'bxxx_1xx_xxx_xxx: func_sel_2 = 4'd10;
        12'bxx1_xxx_xxx_xxx: func_sel_2 = 4'd11;
        default: func_sel_2 = 4'd12;
    endcase
endfunction

function [3 : 0] func_sel_3;
    input   [11 : 0] bit_map;

    casex ({3'b0, bit_map[11 : 3]})
        12'bxxx_xxx_xxx_xx1: func_sel_3 = 4'd3;
        12'bxxx_xxx_xxx_x1x: func_sel_3 = 4'd4;
        12'bxxx_xxx_xxx_1xx: func_sel_3 = 4'd5;
        12'bxxx_xxx_xx1_xxx: func_sel_3 = 4'd6;
        12'bxxx_xxx_x1x_xxx: func_sel_3 = 4'd7;
        12'bxxx_xxx_1xx_xxx: func_sel_3 = 4'd8;
        12'bxxx_xx1_xxx_xxx: func_sel_3 = 4'd9;
        12'bxxx_x1x_xxx_xxx: func_sel_3 = 4'd10;
        12'bxxx_1xx_xxx_xxx: func_sel_3 = 4'd11;
        default: func_sel_3 = 4'd12;
    endcase
endfunction

function [3 : 0] func_sel_4;
    input   [11 : 0] bit_map;

    casex ({4'b0, bit_map[11 : 4]})
        12'bxxx_xxx_xxx_xx1: func_sel_4 = 4'd4;
        12'bxxx_xxx_xxx_x1x: func_sel_4 = 4'd5;
        12'bxxx_xxx_xxx_1xx: func_sel_4 = 4'd6;
        12'bxxx_xxx_xx1_xxx: func_sel_4 = 4'd7;
        12'bxxx_xxx_x1x_xxx: func_sel_4 = 4'd8;
        12'bxxx_xxx_1xx_xxx: func_sel_4 = 4'd9;
        12'bxxx_xx1_xxx_xxx: func_sel_4 = 4'd10;
        12'bxxx_x1x_xxx_xxx: func_sel_4 = 4'd11;
        default: func_sel_4 = 4'd12;
    endcase
endfunction

function [3 : 0] func_sel_5;
    input   [11 : 0] bit_map;

    casex ({5'b0, bit_map[11 : 5]})
        12'bxxx_xxx_xxx_xx1: func_sel_5 = 4'd5;
        12'bxxx_xxx_xxx_x1x: func_sel_5 = 4'd6;
        12'bxxx_xxx_xxx_1xx: func_sel_5 = 4'd7;
        12'bxxx_xxx_xx1_xxx: func_sel_5 = 4'd8;
        12'bxxx_xxx_x1x_xxx: func_sel_5 = 4'd9;
        12'bxxx_xxx_1xx_xxx: func_sel_5 = 4'd10;
        12'bxxx_xx1_xxx_xxx: func_sel_5 = 4'd11;
        default: func_sel_5 = 4'd12;
    endcase
endfunction

function [3 : 0] func_sel_6;
    input   [11 : 0] bit_map;

    casex ({6'b0, bit_map[11 : 6]})
        12'bxxx_xxx_xxx_xx1: func_sel_6 = 4'd6;
        12'bxxx_xxx_xxx_x1x: func_sel_6 = 4'd7;
        12'bxxx_xxx_xxx_1xx: func_sel_6 = 4'd8;
        12'bxxx_xxx_xx1_xxx: func_sel_6 = 4'd9;
        12'bxxx_xxx_x1x_xxx: func_sel_6 = 4'd10;
        12'bxxx_xxx_1xx_xxx: func_sel_6 = 4'd11;
        default: func_sel_6 = 4'd12;
    endcase
endfunction

function [3 : 0] func_sel_7;
    input   [11 : 0] bit_map;

    casex ({7'b0, bit_map[11 : 7]})
        12'bxxx_xxx_xxx_xx1: func_sel_7 = 4'd7;
        12'bxxx_xxx_xxx_x1x: func_sel_7 = 4'd8;
        12'bxxx_xxx_xxx_1xx: func_sel_7 = 4'd9;
        12'bxxx_xxx_xx1_xxx: func_sel_7 = 4'd10;
        12'bxxx_xxx_x1x_xxx: func_sel_7 = 4'd11;
        default: func_sel_7 = 4'd12;
    endcase
endfunction

function [5 : 0] func_find_wr_vec;
    input [4 : 0] index;
    
    casex (index)
        5'bxxxx1: func_find_wr_vec = 6'b100_001;
        5'bxxx10: func_find_wr_vec = 6'b100_010;
        5'bxx100: func_find_wr_vec = 6'b100_100;
        5'bx1000: func_find_wr_vec = 6'b101_000;
        5'b10000: func_find_wr_vec = 6'b110_000;
        default: 
                func_find_wr_vec = 6'b000_000;
    endcase
endfunction

endmodule 	//	rsv_issue_module

`endif 	/*	!__RSV_RSV_ISSUE_V__!	*/